--[[
	zhandouluoji putong gongji
]]

local army_list = {{100,20,200,80,10},{100,20,400,80,10},{200,20,200,80,10},{80,20,100,80,10},{250,20,100,80,10},{300,20,600,80,10}} 			--attack defend blood hit dodoge
local enemy_list = {{80,20,200,80,10},{80,20,400,80,10},{150,20,200,80,10},{80,20,100,80,10},{150,20,100,80,10},{200,20,600,80,10}} 
local index = 1
local isEnd = false, str

local function isHit(hit, dodge)
	local temp = hit - dodge
	local rand = math.random(100)
	if temp > rand then
		return true
	end
	return false
end

local function isDead(list)
	for i = 1, #list do
		if list[i][3] > 0 then
			return false
		end
	end
	return true
end

local function gameOver(isMy)
	if isMy then
		if isDead(enemy_list) then
			str = "my winner"
			return true
		end
	else
		if isDead(army_list) then
			str = "my lose"
			return true
		end
	end
	return false
end

local function findTarget(self, list, pos)
	if pos > 3 then pos = pos - 3 end

	local function getTargetFromData(num, beginIndex, endIndex)
		if list[num][3] > 0 then
			return list[num]
		else
			for i = beginIndex, endIndex do
				if i ~= num and list[num][3] > 0 then
					return list[num]
				end
			end
		end
		return null
	end

	local target = getTargetFromData(pos, 1, 3)
	if target ==null then
		target = getTargetFromData(pos + 3, 4, 6)
	end

	return target
end

local function startAttack(self, target, isMy)
	if isHit(self[4], target[5]) then
		local tempDamage = self[1] - target[2]
		if tempDamage <= 0 then
			tempDamage = 1
		end

		target[3] = target[3] - tempDamage
		print(" attack damage ===== " .. tempDamage)

		if target[3] <= 0 then
			if gameOver(isMy) then
				isEnd = true
			end
		end

	else
		print("attack be dodoge ")
	end
end

-- army start attack
local function roleAttack(selfList, enemyList, isMy)
	if selfList[index][3] <= 0 then
		return
	end

	local target = findTarget(selfList[index], enemyList, index)
	if target == null then
		return
	end

	startAttack(selfList[index], target, isMy)
end

local function start()

	if isEnd then
		print(str)
		return
	end

	while index <= 6 do
		roleAttack(army_list, enemy_list, true)
		roleAttack(enemy_list, army_list, false)
		index = index + 1
	end

	index = 1
	start()
end

local function main()
	start()
end

main()
