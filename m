Return-Path: <kvm+bounces-14972-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D5DA8A84D9
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 15:38:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 540B52825B4
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 13:38:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF73013F440;
	Wed, 17 Apr 2024 13:37:58 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4AA313D89F;
	Wed, 17 Apr 2024 13:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713361078; cv=none; b=chEd9zJrR+iVPIpperifyMeJWpyhZo0tcLt+LKH8ClR2Ft365nN9cZgO3xlIWMmG/r8nCWwvd2NUT+4dAdEKKCMYmoJej4HIIlsQqEYDpBFYwE77pqAFi5mchw7z/Xi9vuJcXI1jbbyZEyFcRI6ykVf4OhENPuZNUVOk2CDACo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713361078; c=relaxed/simple;
	bh=39AHeotFYiV7LmIyRhGYC2ER5DUVYKUxHjeYw5rCVhs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TlEVtGXhw996GGBiwvlX9vI/tida1TLxhMM7FBxNA0T/3KD1EemI3vyb0BVaFFaPZJeWLoABqN0nLwwnQ2UmzhhrxxxwQnr1S8BTjIcR4g7UtqxG2LQ28wZr+Z1nAiHHUKAhZO+n4dDEsNIIZaIOaYmnl8ynTH57PP1Jn67l3Yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CF822339;
	Wed, 17 Apr 2024 06:38:22 -0700 (PDT)
Received: from [10.1.39.28] (FVFF763DQ05P.cambridge.arm.com [10.1.39.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9CCDD3F738;
	Wed, 17 Apr 2024 06:37:52 -0700 (PDT)
Message-ID: <eadfc969-cd41-4dbc-85ff-8d6f8e318837@arm.com>
Date: Wed, 17 Apr 2024 14:37:51 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 13/43] arm64: RME: RTT handling
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
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
References: <20240412084056.1733704-1-steven.price@arm.com>
 <20240412084309.1733783-1-steven.price@arm.com>
 <20240412084309.1733783-14-steven.price@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20240412084309.1733783-14-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Steven

minort nit, Subject: arm64: RME: RTT tear down

This patch is all about tearing the RTTs, so may be the subject could
be adjusted accordingly.

On 12/04/2024 09:42, Steven Price wrote:
> The RMM owns the stage 2 page tables for a realm, and KVM must request
> that the RMM creates/destroys entries as necessary. The physical pages
> to store the page tables are delegated to the realm as required, and can
> be undelegated when no longer used.
> 
> Creating new RTTs is the easy part, tearing down is a little more
> tricky. The result of realm_rtt_destroy() can be used to effectively
> walk the tree and destroy the entries (undelegating pages that were
> given to the realm).

The patch looks functionally correct to me. Some minor style related
comments below.

> Signed-off-by: Steven Price <steven.price@arm.com>

> ---
>   arch/arm64/include/asm/kvm_rme.h |  19 ++++
>   arch/arm64/kvm/mmu.c             |   6 +-
>   arch/arm64/kvm/rme.c             | 171 +++++++++++++++++++++++++++++++
>   3 files changed, 193 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
> index fba85e9ce3ae..4ab5cb5e91b3 100644
> --- a/arch/arm64/include/asm/kvm_rme.h
> +++ b/arch/arm64/include/asm/kvm_rme.h
> @@ -76,5 +76,24 @@ u32 kvm_realm_ipa_limit(void);
>   int kvm_realm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap);
>   int kvm_init_realm_vm(struct kvm *kvm);
>   void kvm_destroy_realm(struct kvm *kvm);
> +void kvm_realm_destroy_rtts(struct kvm *kvm, u32 ia_bits);
> +
> +#define RME_RTT_BLOCK_LEVEL	2
> +#define RME_RTT_MAX_LEVEL	3
> +
> +#define RME_PAGE_SHIFT		12
> +#define RME_PAGE_SIZE		BIT(RME_PAGE_SHIFT)
> +/* See ARM64_HW_PGTABLE_LEVEL_SHIFT() */
> +#define RME_RTT_LEVEL_SHIFT(l)	\
> +	((RME_PAGE_SHIFT - 3) * (4 - (l)) + 3)
> +#define RME_L2_BLOCK_SIZE	BIT(RME_RTT_LEVEL_SHIFT(2))
> +
> +static inline unsigned long rme_rtt_level_mapsize(int level)
> +{
> +	if (WARN_ON(level > RME_RTT_MAX_LEVEL))
> +		return RME_PAGE_SIZE;
> +
> +	return (1UL << RME_RTT_LEVEL_SHIFT(level));
> +}
> 

super minor nit: We only support 4K for now, so may be could reuse
the ARM64 generic macro helpers. I am fine either way.


>   #endif
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index af4564f3add5..46f0c4e80ace 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1012,17 +1012,17 @@ void stage2_unmap_vm(struct kvm *kvm)
>   void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
>   {
>   	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
> -	struct kvm_pgtable *pgt = NULL;
> +	struct kvm_pgtable *pgt;
>   
>   	write_lock(&kvm->mmu_lock);
> +	pgt = mmu->pgt;
>   	if (kvm_is_realm(kvm) &&
>   	    (kvm_realm_state(kvm) != REALM_STATE_DEAD &&
>   	     kvm_realm_state(kvm) != REALM_STATE_NONE)) {
> -		/* TODO: teardown rtts */
>   		write_unlock(&kvm->mmu_lock);
> +		kvm_realm_destroy_rtts(kvm, pgt->ia_bits);
>   		return;
>   	}
> -	pgt = mmu->pgt;
>   	if (pgt) {
>   		mmu->pgd_phys = 0;
>   		mmu->pgt = NULL;
> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
> index 9652ec6ab2fd..09b59bcad8b6 100644
> --- a/arch/arm64/kvm/rme.c
> +++ b/arch/arm64/kvm/rme.c
> @@ -47,6 +47,53 @@ static int rmi_check_version(void)
>   	return 0;
>   }
>   
> +static phys_addr_t __alloc_delegated_page(struct realm *realm,
> +					  struct kvm_mmu_memory_cache *mc,
> +					  gfp_t flags)

minor nit: Do we need "__" here ? The counter part is plain 
free_delegated_page without the "__". We could drop the prefix

Or we could split the function as:

alloc_delegated_page()
{
   if (spare_page_available)
	return spare_page;
   return __alloc_delegated_page(); /* Alloc and delegate a page */
}


> +{
> +	phys_addr_t phys = PHYS_ADDR_MAX;
> +	void *virt;
> +
> +	if (realm->spare_page != PHYS_ADDR_MAX) {
> +		swap(realm->spare_page, phys);
> +		goto out;
> +	}
> +
> +	if (mc)
> +		virt = kvm_mmu_memory_cache_alloc(mc);
> +	else
> +		virt = (void *)__get_free_page(flags);
> +
> +	if (!virt)
> +		goto out;
> +
> +	phys = virt_to_phys(virt);
> +
> +	if (rmi_granule_delegate(phys)) {
> +		free_page((unsigned long)virt);
> +
> +		phys = PHYS_ADDR_MAX;
> +	}
> +
> +out:
> +	return phys;
> +}
> +
> +static void free_delegated_page(struct realm *realm, phys_addr_t phys)
> +{
> +	if (realm->spare_page == PHYS_ADDR_MAX) {
> +		realm->spare_page = phys;
> +		return;
> +	}
> +
> +	if (WARN_ON(rmi_granule_undelegate(phys))) {
> +		/* Undelegate failed: leak the page */
> +		return;
> +	}
> +
> +	free_page((unsigned long)phys_to_virt(phys));
> +}
> +
>   u32 kvm_realm_ipa_limit(void)
>   {
>   	return u64_get_bits(rmm_feat_reg0, RMI_FEATURE_REGISTER_0_S2SZ);
> @@ -124,6 +171,130 @@ static int realm_create_rd(struct kvm *kvm)
>   	return r;
>   }
>   
> +static int realm_rtt_destroy(struct realm *realm, unsigned long addr,
> +			     int level, phys_addr_t *rtt_granule,
> +			     unsigned long *next_addr)
> +{
> +	unsigned long out_rtt;
> +	unsigned long out_top;
> +	int ret;
> +
> +	ret = rmi_rtt_destroy(virt_to_phys(realm->rd), addr, level,
> +			      &out_rtt, &out_top);
> +
> +	if (rtt_granule)
> +		*rtt_granule = out_rtt;
> +	if (next_addr)
> +		*next_addr = out_top;

minor nit: As mentioned in the previous patch, we could move this check 
to the rmi_rtt_destroy().

> +
> +	return ret;
> +}
> +
> +static int realm_tear_down_rtt_level(struct realm *realm, int level,
> +				     unsigned long start, unsigned long end)
> +{
> +	ssize_t map_size;
> +	unsigned long addr, next_addr;
> +
> +	if (WARN_ON(level > RME_RTT_MAX_LEVEL))
> +		return -EINVAL;
> +
> +	map_size = rme_rtt_level_mapsize(level - 1);
> +
> +	for (addr = start; addr < end; addr = next_addr) {
> +		phys_addr_t rtt_granule;
> +		int ret;
> +		unsigned long align_addr = ALIGN(addr, map_size);
> +
> +		next_addr = ALIGN(addr + 1, map_size);
> +
> +		if (next_addr <= end && align_addr == addr) {
> +			ret = realm_rtt_destroy(realm, addr, level,
> +						&rtt_granule, &next_addr);
> +		} else {
> +			/* Recurse a level deeper */
> +			ret = realm_tear_down_rtt_level(realm,
> +							level + 1,
> +							addr,
> +							min(next_addr, end));
> +			if (ret)
> +				return ret;
> +			continue;
> +		}

I think it would be better readable if we did something like :

		/*
		 * The target range is smaller than what this level
		 * covers. Go deeper.
		 */
		if (next_addr > end || align_addr != addr) {
			ret = realm_tear_down_rtt_level(realm,
							level + 1, addr,
							min(next_addr, end));
			if (ret)
				return ret;
			continue;
		}

		ret = realm_rtt_destroy(realm, addr, level,
					&rtt_granule, &next_addr);
		
> +
> +		switch (RMI_RETURN_STATUS(ret)) {
> +		case RMI_SUCCESS:
> +			if (!WARN_ON(rmi_granule_undelegate(rtt_granule)))
> +				free_page((unsigned long)phys_to_virt(rtt_granule));
> +			break;
> +		case RMI_ERROR_RTT:
> +			if (next_addr > addr) {
> +				/* unassigned or destroyed */

minor nit:
				/* RTT doesn't exist, skip */

> +				break;
> +			}

> +			if (WARN_ON(RMI_RETURN_INDEX(ret) != level))
> +				return -EBUSY;

In practise, we only call this for the full IPA range and we wouldn't go 
deeper, if the top level entry was missing. So, there is no reason why
the RMM didn't walk to the requested level. May be we could add a 
comment here :
			/*
			 * We tear down the RTT range for the full IPA
			 * space, after everything is unmapped. Also we
			 * descend down only if we cannot tear down a
			 * top level RTT. Thus RMM must be able to walk
			 * to the requested level. e.g., a block mapping
			 * exists at L1 or L2.
			 */

> +			if (WARN_ON(level == RME_RTT_MAX_LEVEL)) {
> +				// Live entry
> +				return -EBUSY;


The first part of the comment above applies to this. So may be it is
good to have it.


> +			}

> +			/* Recurse a level deeper */

minor nit:
			/*
			 * The table has active entries in it, recurse
			 * deeper and tear down the RTTs.
			 */

> +			next_addr = ALIGN(addr + 1, map_size);
> +			ret = realm_tear_down_rtt_level(realm,
> +							level + 1,
> +							addr,
> +							next_addr);
> +			if (ret)
> +				return ret;
> +			/* Try again at this level */

			/*
			 * Now that the children RTTs are destroyed,
			 * retry at this level.
			 */
> +			next_addr = addr;
> +			break;
> +		default:
> +			WARN_ON(1);
> +			return -ENXIO;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static int realm_tear_down_rtt_range(struct realm *realm,
> +				     unsigned long start, unsigned long end)
> +{
> +	return realm_tear_down_rtt_level(realm, get_start_level(realm) + 1,
> +					 start, end);
> +}
> +
> +static void ensure_spare_page(struct realm *realm)
> +{
> +	phys_addr_t tmp_rtt;
> +
> +	/*
> +	 * Make sure we have a spare delegated page for tearing down the
> +	 * block mappings. We do this by allocating then freeing a page.
> +	 * We must use Atomic allocations as we are called with kvm->mmu_lock
> +	 * held.
> +	 */
> +	tmp_rtt = __alloc_delegated_page(realm, NULL, GFP_ATOMIC);
> +
> +	/*
> +	 * If the allocation failed, continue as we may not have a block level
> +	 * mapping so it may not be fatal, otherwise free it to assign it
> +	 * to the spare page.
> +	 */
> +	if (tmp_rtt != PHYS_ADDR_MAX)
> +		free_delegated_page(realm, tmp_rtt);
> +}
> +
> +void kvm_realm_destroy_rtts(struct kvm *kvm, u32 ia_bits)
> +{
> +	struct realm *realm = &kvm->arch.realm;
> +
> +	ensure_spare_page(realm);
> +
> +	WARN_ON(realm_tear_down_rtt_range(realm, 0, (1UL << ia_bits)));
> +}

minor nit: We don't seem to be using the "spare_page" yet in this patch. 
May be a good idea to move all the related changes 
(alloc_delegated_page() / free_delegated_page, ensure_spare_page() etc)
to the patch where it may be better suited ?

Suzuki

> +
>   /* Protects access to rme_vmid_bitmap */
>   static DEFINE_SPINLOCK(rme_vmid_lock);
>   static unsigned long *rme_vmid_bitmap;


