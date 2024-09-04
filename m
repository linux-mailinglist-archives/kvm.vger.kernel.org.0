Return-Path: <kvm+bounces-25895-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2652696C349
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 18:02:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EAED7B29F01
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 16:01:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4AE51DFE3F;
	Wed,  4 Sep 2024 15:59:54 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1C581DB94D;
	Wed,  4 Sep 2024 15:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725465594; cv=none; b=I7TygJ2SPtGzTOWWqsGvaP8UnIo/P+zmZMp7YdEJA7IqTPEYkGJnQ4t1sGGq+As8infcd9gLKffFZ38dujC4VbMgAYVjSu9hi3x6bD1Iiz/o4SN7dKnvdVEZJvhuE4+0O4cdxyFEdTu9aboD6aGDvqMfVFU3XWP6CPXt89dd/Dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725465594; c=relaxed/simple;
	bh=MMEPNHTHKxiotFQk//EZ58z8HAfAg7MEpXl9vneAPsU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LCp555uOTN6xi8Wtmnqd/gXDfEQsroiBW3Chc1Ws9rbtubePOv2emppLoV5rIwX83eaGBaiyWmn+EAOptVUgkowinJldOaYaEjSQc37P29AxsbLYdrZSJNGxLVyQHbprkT9lzxk0m0BR233oGelagnM5w8kCR1ANm3MwwXqIh/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0D8F9FEC;
	Wed,  4 Sep 2024 09:00:18 -0700 (PDT)
Received: from [10.57.75.163] (unknown [10.57.75.163])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 671763F73B;
	Wed,  4 Sep 2024 08:59:47 -0700 (PDT)
Message-ID: <95d8bdc8-95f2-4694-aa9c-b73811ecd1ad@arm.com>
Date: Wed, 4 Sep 2024 16:59:45 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 21/43] arm64: RME: Runtime faulting of memory
To: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>
References: <20240821153844.60084-1-steven.price@arm.com>
 <20240821153844.60084-22-steven.price@arm.com>
 <20240904144821.GA223966@myrica>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <20240904144821.GA223966@myrica>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 04/09/2024 15:48, Jean-Philippe Brucker wrote:
> On Wed, Aug 21, 2024 at 04:38:22PM +0100, Steven Price wrote:
>> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
>> index 2c4e28b457be..337b3dd1e00c 100644
>> --- a/arch/arm64/kvm/rme.c
>> +++ b/arch/arm64/kvm/rme.c
>> @@ -627,6 +627,181 @@ static int fold_rtt(struct realm *realm, unsigned long addr, int level)
>>  	return 0;
>>  }
>>  
>> +static phys_addr_t rtt_get_phys(struct realm *realm, struct rtt_entry *rtt)
>> +{
>> +	bool lpa2 = realm->params->flags & RMI_REALM_PARAM_FLAG_LPA2;
> 
> At this point realm->params is NULL, cleared by kvm_create_realm()

Ah, indeed so. Also LPA2 isn't yet supported (we have no way of setting
that flag).

Since this code is only called for block mappings (also not yet
supported) that explains why I've never seen the issue.

Thanks,
Steve

> Thanks,
> Jean
> 
>> +
>> +	if (lpa2)
>> +		return rtt->desc & GENMASK(49, 12);
>> +	return rtt->desc & GENMASK(47, 12);
>> +}
>> +
>> +int realm_map_protected(struct realm *realm,
>> +			unsigned long base_ipa,
>> +			struct page *dst_page,
>> +			unsigned long map_size,
>> +			struct kvm_mmu_memory_cache *memcache)
>> +{
>> +	phys_addr_t dst_phys = page_to_phys(dst_page);
>> +	phys_addr_t rd = virt_to_phys(realm->rd);
>> +	unsigned long phys = dst_phys;
>> +	unsigned long ipa = base_ipa;
>> +	unsigned long size;
>> +	int map_level;
>> +	int ret = 0;
>> +
>> +	if (WARN_ON(!IS_ALIGNED(ipa, map_size)))
>> +		return -EINVAL;
>> +
>> +	switch (map_size) {
>> +	case PAGE_SIZE:
>> +		map_level = 3;
>> +		break;
>> +	case RME_L2_BLOCK_SIZE:
>> +		map_level = 2;
>> +		break;
>> +	default:
>> +		return -EINVAL;
>> +	}
>> +
>> +	if (map_level < RME_RTT_MAX_LEVEL) {
>> +		/*
>> +		 * A temporary RTT is needed during the map, precreate it,
>> +		 * however if there is an error (e.g. missing parent tables)
>> +		 * this will be handled below.
>> +		 */
>> +		realm_create_rtt_levels(realm, ipa, map_level,
>> +					RME_RTT_MAX_LEVEL, memcache);
>> +	}
>> +
>> +	for (size = 0; size < map_size; size += PAGE_SIZE) {
>> +		if (rmi_granule_delegate(phys)) {
>> +			struct rtt_entry rtt;
>> +
>> +			/*
>> +			 * It's possible we raced with another VCPU on the same
>> +			 * fault. If the entry exists and matches then exit
>> +			 * early and assume the other VCPU will handle the
>> +			 * mapping.
>> +			 */
>> +			if (rmi_rtt_read_entry(rd, ipa, RME_RTT_MAX_LEVEL, &rtt))
>> +				goto err;
>> +
>> +			/*
>> +			 * FIXME: For a block mapping this could race at level
>> +			 * 2 or 3... currently we don't support block mappings
>> +			 */
>> +			if (WARN_ON((rtt.walk_level != RME_RTT_MAX_LEVEL ||
>> +				     rtt.state != RMI_ASSIGNED ||
>> +				     rtt_get_phys(realm, &rtt) != phys))) {
> 


