Return-Path: <kvm+bounces-47006-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EB70ABC5B6
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 19:36:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B96DB168780
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 17:36:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A6C9288C3F;
	Mon, 19 May 2025 17:36:07 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DB412874F5;
	Mon, 19 May 2025 17:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747676166; cv=none; b=TiSwBVAhloJaT3IkX432XFjep8bMdfxrp+g3qvRJtygYhnWPb6kSi85K05PjXS6I8m94+5Ub16QgatZP/UWgcuWxoJFquLAYNwL/3x1aHkhRbkvJivdD8Qb1hX7XIvz1e8g393xWdOoDoPYtYI9jW1MqaIYEAmyk64ievS8Cq3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747676166; c=relaxed/simple;
	bh=uRxGMqVvMhdnhZUCOSCjxyGRSKnkRsYIWlWK7s5f0LE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YzlcwrehXQm0bnrUv6qaUlONUmwJdi2bNn/fek4IXjSh+Vx6h5dyQTPExcNKtXICV5cCMce54oVR5OSCUaoKgjz8L6e3JY4c+o9D7CfEidaYyXEj2u9p/nExQxW/LX00AleRrJwHhwjuQ1L4JxGQKRg1yFi0eS9B2sysnQ/mcDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 323FD1655;
	Mon, 19 May 2025 10:35:50 -0700 (PDT)
Received: from [10.57.50.157] (unknown [10.57.50.157])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id C790F3F673;
	Mon, 19 May 2025 10:35:59 -0700 (PDT)
Message-ID: <3a04995a-524c-4d07-8c8b-82930f9bca72@arm.com>
Date: Mon, 19 May 2025 18:35:58 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 20/43] arm64: RME: Runtime faulting of memory
Content-Language: en-GB
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>
References: <20250416134208.383984-1-steven.price@arm.com>
 <20250416134208.383984-21-steven.price@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20250416134208.383984-21-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Steven

On 16/04/2025 14:41, Steven Price wrote:
> At runtime if the realm guest accesses memory which hasn't yet been
> mapped then KVM needs to either populate the region or fault the guest.
> 
> For memory in the lower (protected) region of IPA a fresh page is
> provided to the RMM which will zero the contents. For memory in the
> upper (shared) region of IPA, the memory from the memslot is mapped
> into the realm VM non secure.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>

Please find some comments below.

...

> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
> index f6af3ea6ea8a..b6959cd17a6c 100644
> --- a/arch/arm64/kvm/rme.c
> +++ b/arch/arm64/kvm/rme.c
> @@ -714,6 +714,186 @@ static int realm_create_protected_data_page(struct realm *realm,
>   	return -ENXIO;
>   }
>   
> +static int fold_rtt(struct realm *realm, unsigned long addr, int level)
> +{
> +	phys_addr_t rtt_addr;
> +	int ret;
> +
> +	ret = realm_rtt_fold(realm, addr, level, &rtt_addr);
> +	if (ret)
> +		return ret;
> +
> +	free_delegated_granule(rtt_addr);
> +
> +	return 0;
> +}
> +
> +int realm_map_protected(struct realm *realm,
> +			unsigned long ipa,
> +			kvm_pfn_t pfn,
> +			unsigned long map_size,
> +			struct kvm_mmu_memory_cache *memcache)
> +{
> +	phys_addr_t phys = __pfn_to_phys(pfn);
> +	phys_addr_t rd = virt_to_phys(realm->rd);
> +	unsigned long base_ipa = ipa;
> +	unsigned long size;
> +	int map_level;
> +	int ret = 0;
> +
> +	if (WARN_ON(!IS_ALIGNED(map_size, RMM_PAGE_SIZE)))
> +		return -EINVAL;
> +
> +	if (WARN_ON(!IS_ALIGNED(ipa, map_size)))
> +		return -EINVAL;
> +
> +	if (IS_ALIGNED(map_size, RMM_L2_BLOCK_SIZE))
> +		map_level = 2;

minor nit : RMM_RTT_BLOCK_LEVEL

> +	else
> +		map_level = 3;

minor nit:  RMM_RTT_MAX_LEVEL ?

> +
> +	if (map_level < RMM_RTT_MAX_LEVEL) {
> +		/*
> +		 * A temporary RTT is needed during the map, precreate it,
> +		 * however if there is an error (e.g. missing parent tables)
> +		 * this will be handled below.
> +		 */
> +		realm_create_rtt_levels(realm, ipa, map_level,
> +					RMM_RTT_MAX_LEVEL, memcache);
> +	}
> +
> +	for (size = 0; size < map_size; size += RMM_PAGE_SIZE) {
> +		if (rmi_granule_delegate(phys)) {
> +			/*
> +			 * It's likely we raced with another VCPU on the same
> +			 * fault. Assume the other VCPU has handled the fault
> +			 * and return to the guest.
> +			 */
> +			return 0;
> +		}
> +
> +		ret = rmi_data_create_unknown(rd, phys, ipa);
> +
> +		if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
> +			/* Create missing RTTs and retry */
> +			int level = RMI_RETURN_INDEX(ret);
> +
> +			WARN_ON(level == RMM_RTT_MAX_LEVEL);
> +
> +			ret = realm_create_rtt_levels(realm, ipa, level,
> +						      RMM_RTT_MAX_LEVEL,
> +						      memcache);
> +			if (ret)
> +				goto err_undelegate;
> +
> +			ret = rmi_data_create_unknown(rd, phys, ipa);
> +		}
> +
> +		if (WARN_ON(ret))
> +			goto err_undelegate;
> +
> +		phys += RMM_PAGE_SIZE;
> +		ipa += RMM_PAGE_SIZE;
> +	}
> +
> +	if (map_size == RMM_L2_BLOCK_SIZE) {
> +		ret = fold_rtt(realm, base_ipa, map_level + 1);
> +		if (WARN_ON(ret))
> +			goto err;
> +	}
> +
> +	return 0;
> +
> +err_undelegate:
> +	if (WARN_ON(rmi_granule_undelegate(phys))) {
> +		/* Page can't be returned to NS world so is lost */
> +		get_page(phys_to_page(phys));
> +	}
> +err:
> +	while (size > 0) {
> +		unsigned long data, top;
> +
> +		phys -= RMM_PAGE_SIZE;
> +		size -= RMM_PAGE_SIZE;
> +		ipa -= RMM_PAGE_SIZE;
> +
> +		WARN_ON(rmi_data_destroy(rd, ipa, &data, &top));
> +
> +		if (WARN_ON(rmi_granule_undelegate(phys))) {
> +			/* Page can't be returned to NS world so is lost */
> +			get_page(phys_to_page(phys));
> +		}
> +	}
> +	return -ENXIO;
> +}
> +
> +int realm_map_non_secure(struct realm *realm,
> +			 unsigned long ipa,
> +			 kvm_pfn_t pfn,
> +			 unsigned long size,
> +			 struct kvm_mmu_memory_cache *memcache)
> +{
> +	phys_addr_t rd = virt_to_phys(realm->rd);
> +	phys_addr_t phys = __pfn_to_phys(pfn);
> +	unsigned long offset;
> +	int map_size, map_level;
> +	int ret = 0;
> +
> +	if (WARN_ON(!IS_ALIGNED(size, RMM_PAGE_SIZE)))
> +		return -EINVAL;
> +
> +	if (WARN_ON(!IS_ALIGNED(ipa, size)))
> +		return -EINVAL;
> +
> +	if (IS_ALIGNED(size, RMM_L2_BLOCK_SIZE)) {
> +		map_level = 2;
> +		map_size = RMM_L2_BLOCK_SIZE;

Same here, stick to the symbols than digits.

> +	} else {
> +		map_level = 3;
> +		map_size = RMM_PAGE_SIZE;
> +	}
> +
> +	for (offset = 0; offset < size; offset += map_size) {
> +		/*
> +		 * realm_map_ipa() enforces that the memory is writable,

The function names seems to be obsolete, please fix.

> +		 * so for now we permit both read and write.
> +		 */
> +		unsigned long desc = phys |
> +				     PTE_S2_MEMATTR(MT_S2_FWB_NORMAL) |
> +				     KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R |
> +				     KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
> +		ret = rmi_rtt_map_unprotected(rd, ipa, map_level, desc);
> +
> +		if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {

Could we hit the following case and end up in failure ?

* Initially a single page is shared and the S2 is mapped
* Later the Realm shares the entire L2 block and encounters a fault
   at a new IPA within the L2 block.

In this case, we may try to L2 mapping when there is a L3 mapping and
we could encounter (RMI_ERROR_RTT, 2).


> +			/* Create missing RTTs and retry */
> +			int level = RMI_RETURN_INDEX(ret);

So we should probably go down the rtt create step, with the following
check.

			if (level < map_level) {

> +
> +			ret = realm_create_rtt_levels(realm, ipa, level,
> +						      map_level, memcache);
> +			if (ret)
> +				return -ENXIO;
> +
> +			ret = rmi_rtt_map_unprotected(rd, ipa, map_level, desc);


		} else {

Otherwise, may be we need to do some more hard work to fix it up.

1. If map_level == 3, something is terribly wrong or we raced with 
another thread ?

2. If map_level < 3 and we didn't race :

   a. Going one level down and creating the mappings there and then 
folding. But we could endup dealing with ERROR_RTT,3 as in (1).

   b. Easiest is to destroy the table at "map_level + 1" and retry the map.


Suzuki



> +		}
> +		/*
> +		 * RMI_ERROR_RTT can be reported for two reasons: either the
> +		 * RTT tables are not there, or there is an RTTE already
> +		 * present for the address.  The call to
> +		 * realm_create_rtt_levels() above handles the first case, and
> +		 * in the second case this indicates that another thread has
> +		 * already populated the RTTE for us, so we can ignore the
> +		 * error and continue.
> +		 */
> +		if (ret && RMI_RETURN_STATUS(ret) != RMI_ERROR_RTT)
> +			return -ENXIO;
> +
> +		ipa += map_size;
> +		phys += map_size;
> +	}
> +
> +	return 0;
> +}
> +
>   static int populate_region(struct kvm *kvm,
>   			   phys_addr_t ipa_base,
>   			   phys_addr_t ipa_end,


