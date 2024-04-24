Return-Path: <kvm+bounces-15784-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B8FC88B07DB
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 12:59:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 303AF1F21ABC
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 10:59:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 037FD159919;
	Wed, 24 Apr 2024 10:59:38 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CF7E15959D;
	Wed, 24 Apr 2024 10:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713956377; cv=none; b=FkXIZOsPeqrTVD6fkL1vDvGb/zQikUZVqPxZoAhRvA5w5yed1rUv8kiagNtyCSZybgq9KDVBdAvzbNKpuTrfP89WMirQp4NYfNu3v1EqQ4SISNDTpdNJs/EjMrGCmuppr5gBsCsb9dFhSdB48wD1ZXu38b9Pb2VlsLGmI5rHjRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713956377; c=relaxed/simple;
	bh=bTl3loIXLN2H+/fOqmBgK3pFEanAnlrk0H6llGWSkJw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AokOZEgGnXA1H0hNClXs8DkrByR09k+rnCo21o8ZHEPHwi9bVVrgq8WYhF6vcrsT5IbO3doC2XRunRoN541jJRDJUKtXJ00kn8A7aK5FThQIpoZlE2RtPFxzzIuLf5PDzJQnzoUGhoXFykQrzMPLO2i1Oxb3SJ8elbate8S7+Q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 534CD2F;
	Wed, 24 Apr 2024 04:00:02 -0700 (PDT)
Received: from [10.57.57.30] (unknown [10.57.57.30])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8A89A3F73F;
	Wed, 24 Apr 2024 03:59:31 -0700 (PDT)
Message-ID: <40413863-3158-460b-ad7e-e5afdb45b701@arm.com>
Date: Wed, 24 Apr 2024 11:59:34 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 13/43] arm64: RME: RTT handling
To: Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org,
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
 <eadfc969-cd41-4dbc-85ff-8d6f8e318837@arm.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <eadfc969-cd41-4dbc-85ff-8d6f8e318837@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 17/04/2024 14:37, Suzuki K Poulose wrote:
> Hi Steven
> 
> minort nit, Subject: arm64: RME: RTT tear down
> 
> This patch is all about tearing the RTTs, so may be the subject could
> be adjusted accordingly.

Good point, this patch has evolved and is now all about tearing down.

> On 12/04/2024 09:42, Steven Price wrote:
>> The RMM owns the stage 2 page tables for a realm, and KVM must request
>> that the RMM creates/destroys entries as necessary. The physical pages
>> to store the page tables are delegated to the realm as required, and can
>> be undelegated when no longer used.
>>
>> Creating new RTTs is the easy part, tearing down is a little more
>> tricky. The result of realm_rtt_destroy() can be used to effectively
>> walk the tree and destroy the entries (undelegating pages that were
>> given to the realm).
> 
> The patch looks functionally correct to me. Some minor style related
> comments below.
> 
>> Signed-off-by: Steven Price <steven.price@arm.com>
> 
>> ---
>>   arch/arm64/include/asm/kvm_rme.h |  19 ++++
>>   arch/arm64/kvm/mmu.c             |   6 +-
>>   arch/arm64/kvm/rme.c             | 171 +++++++++++++++++++++++++++++++
>>   3 files changed, 193 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/kvm_rme.h
>> b/arch/arm64/include/asm/kvm_rme.h
>> index fba85e9ce3ae..4ab5cb5e91b3 100644
>> --- a/arch/arm64/include/asm/kvm_rme.h
>> +++ b/arch/arm64/include/asm/kvm_rme.h
>> @@ -76,5 +76,24 @@ u32 kvm_realm_ipa_limit(void);
>>   int kvm_realm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap);
>>   int kvm_init_realm_vm(struct kvm *kvm);
>>   void kvm_destroy_realm(struct kvm *kvm);
>> +void kvm_realm_destroy_rtts(struct kvm *kvm, u32 ia_bits);
>> +
>> +#define RME_RTT_BLOCK_LEVEL    2
>> +#define RME_RTT_MAX_LEVEL    3
>> +
>> +#define RME_PAGE_SHIFT        12
>> +#define RME_PAGE_SIZE        BIT(RME_PAGE_SHIFT)
>> +/* See ARM64_HW_PGTABLE_LEVEL_SHIFT() */
>> +#define RME_RTT_LEVEL_SHIFT(l)    \
>> +    ((RME_PAGE_SHIFT - 3) * (4 - (l)) + 3)
>> +#define RME_L2_BLOCK_SIZE    BIT(RME_RTT_LEVEL_SHIFT(2))
>> +
>> +static inline unsigned long rme_rtt_level_mapsize(int level)
>> +{
>> +    if (WARN_ON(level > RME_RTT_MAX_LEVEL))
>> +        return RME_PAGE_SIZE;
>> +
>> +    return (1UL << RME_RTT_LEVEL_SHIFT(level));
>> +}
>>
> 
> super minor nit: We only support 4K for now, so may be could reuse
> the ARM64 generic macro helpers. I am fine either way.

Given we'll likely want to support host granules other than 4k in the
future I'd like to avoid using the generic ones. It's also a clear
signal that the code is referring to the RTTs rather than the host's
page tables.

> 
>>   #endif
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index af4564f3add5..46f0c4e80ace 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -1012,17 +1012,17 @@ void stage2_unmap_vm(struct kvm *kvm)
>>   void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
>>   {
>>       struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
>> -    struct kvm_pgtable *pgt = NULL;
>> +    struct kvm_pgtable *pgt;
>>         write_lock(&kvm->mmu_lock);
>> +    pgt = mmu->pgt;
>>       if (kvm_is_realm(kvm) &&
>>           (kvm_realm_state(kvm) != REALM_STATE_DEAD &&
>>            kvm_realm_state(kvm) != REALM_STATE_NONE)) {
>> -        /* TODO: teardown rtts */
>>           write_unlock(&kvm->mmu_lock);
>> +        kvm_realm_destroy_rtts(kvm, pgt->ia_bits);
>>           return;
>>       }
>> -    pgt = mmu->pgt;
>>       if (pgt) {
>>           mmu->pgd_phys = 0;
>>           mmu->pgt = NULL;
>> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
>> index 9652ec6ab2fd..09b59bcad8b6 100644
>> --- a/arch/arm64/kvm/rme.c
>> +++ b/arch/arm64/kvm/rme.c
>> @@ -47,6 +47,53 @@ static int rmi_check_version(void)
>>       return 0;
>>   }
>>   +static phys_addr_t __alloc_delegated_page(struct realm *realm,
>> +                      struct kvm_mmu_memory_cache *mc,
>> +                      gfp_t flags)
> 
> minor nit: Do we need "__" here ? The counter part is plain
> free_delegated_page without the "__". We could drop the prefix
> 
> Or we could split the function as:
> 
> alloc_delegated_page()
> {
>   if (spare_page_available)
>     return spare_page;
>   return __alloc_delegated_page(); /* Alloc and delegate a page */
> }

I'm not really sure I follow. The reason for the 'wrapper' function
alloc_delegated_page() is because most call sites don't care about the
GFP flags (defaults to GFP_KERNEL), but for ensure_spare_page() we need
to pass GFP_ATOMIC.

Admittedly there are only 3 call sites in total and the wrapper isn't
added yet. I'll tidy this up by simply adding the GFP_KERNEL flag onto
the two call sites.

> 
>> +{
>> +    phys_addr_t phys = PHYS_ADDR_MAX;
>> +    void *virt;
>> +
>> +    if (realm->spare_page != PHYS_ADDR_MAX) {
>> +        swap(realm->spare_page, phys);
>> +        goto out;
>> +    }
>> +
>> +    if (mc)
>> +        virt = kvm_mmu_memory_cache_alloc(mc);
>> +    else
>> +        virt = (void *)__get_free_page(flags);
>> +
>> +    if (!virt)
>> +        goto out;
>> +
>> +    phys = virt_to_phys(virt);
>> +
>> +    if (rmi_granule_delegate(phys)) {
>> +        free_page((unsigned long)virt);
>> +
>> +        phys = PHYS_ADDR_MAX;
>> +    }
>> +
>> +out:
>> +    return phys;
>> +}
>> +
>> +static void free_delegated_page(struct realm *realm, phys_addr_t phys)
>> +{
>> +    if (realm->spare_page == PHYS_ADDR_MAX) {
>> +        realm->spare_page = phys;
>> +        return;
>> +    }
>> +
>> +    if (WARN_ON(rmi_granule_undelegate(phys))) {
>> +        /* Undelegate failed: leak the page */
>> +        return;
>> +    }
>> +
>> +    free_page((unsigned long)phys_to_virt(phys));
>> +}
>> +
>>   u32 kvm_realm_ipa_limit(void)
>>   {
>>       return u64_get_bits(rmm_feat_reg0, RMI_FEATURE_REGISTER_0_S2SZ);
>> @@ -124,6 +171,130 @@ static int realm_create_rd(struct kvm *kvm)
>>       return r;
>>   }
>>   +static int realm_rtt_destroy(struct realm *realm, unsigned long addr,
>> +                 int level, phys_addr_t *rtt_granule,
>> +                 unsigned long *next_addr)
>> +{
>> +    unsigned long out_rtt;
>> +    unsigned long out_top;
>> +    int ret;
>> +
>> +    ret = rmi_rtt_destroy(virt_to_phys(realm->rd), addr, level,
>> +                  &out_rtt, &out_top);
>> +
>> +    if (rtt_granule)
>> +        *rtt_granule = out_rtt;
>> +    if (next_addr)
>> +        *next_addr = out_top;
> 
> minor nit: As mentioned in the previous patch, we could move this check
> to the rmi_rtt_destroy().

Done, I've also dropped the check for rtt_granule - it's a bug to be
passing that as NULL.

>> +
>> +    return ret;
>> +}
>> +
>> +static int realm_tear_down_rtt_level(struct realm *realm, int level,
>> +                     unsigned long start, unsigned long end)
>> +{
>> +    ssize_t map_size;
>> +    unsigned long addr, next_addr;
>> +
>> +    if (WARN_ON(level > RME_RTT_MAX_LEVEL))
>> +        return -EINVAL;
>> +
>> +    map_size = rme_rtt_level_mapsize(level - 1);
>> +
>> +    for (addr = start; addr < end; addr = next_addr) {
>> +        phys_addr_t rtt_granule;
>> +        int ret;
>> +        unsigned long align_addr = ALIGN(addr, map_size);
>> +
>> +        next_addr = ALIGN(addr + 1, map_size);
>> +
>> +        if (next_addr <= end && align_addr == addr) {
>> +            ret = realm_rtt_destroy(realm, addr, level,
>> +                        &rtt_granule, &next_addr);
>> +        } else {
>> +            /* Recurse a level deeper */
>> +            ret = realm_tear_down_rtt_level(realm,
>> +                            level + 1,
>> +                            addr,
>> +                            min(next_addr, end));
>> +            if (ret)
>> +                return ret;
>> +            continue;
>> +        }
> 
> I think it would be better readable if we did something like :
> 
>         /*
>          * The target range is smaller than what this level
>          * covers. Go deeper.
>          */
>         if (next_addr > end || align_addr != addr) {
>             ret = realm_tear_down_rtt_level(realm,
>                             level + 1, addr,
>                             min(next_addr, end));
>             if (ret)
>                 return ret;
>             continue;
>         }
> 
>         ret = realm_rtt_destroy(realm, addr, level,
>                     &rtt_granule, &next_addr);

Yes that seems clearly, thanks for the suggestion.

>> +
>> +        switch (RMI_RETURN_STATUS(ret)) {
>> +        case RMI_SUCCESS:
>> +            if (!WARN_ON(rmi_granule_undelegate(rtt_granule)))
>> +                free_page((unsigned long)phys_to_virt(rtt_granule));
>> +            break;
>> +        case RMI_ERROR_RTT:
>> +            if (next_addr > addr) {
>> +                /* unassigned or destroyed */
> 
> minor nit:
>                 /* RTT doesn't exist, skip */

Indeed, this comment is out of date - the spec now calls this condition
"Missing RTT" so I'll use that wording.

> 
>> +                break;
>> +            }
> 
>> +            if (WARN_ON(RMI_RETURN_INDEX(ret) != level))
>> +                return -EBUSY;
> 
> In practise, we only call this for the full IPA range and we wouldn't go
> deeper, if the top level entry was missing. So, there is no reason why
> the RMM didn't walk to the requested level. May be we could add a
> comment here :
>             /*
>              * We tear down the RTT range for the full IPA
>              * space, after everything is unmapped. Also we
>              * descend down only if we cannot tear down a
>              * top level RTT. Thus RMM must be able to walk
>              * to the requested level. e.g., a block mapping
>              * exists at L1 or L2.
>              */

Sure, will add.

>> +            if (WARN_ON(level == RME_RTT_MAX_LEVEL)) {
>> +                // Live entry
>> +                return -EBUSY;
> 
> 
> The first part of the comment above applies to this. So may be it is
> good to have it.
> 
> 
>> +            }
> 
>> +            /* Recurse a level deeper */
> 
> minor nit:
>             /*
>              * The table has active entries in it, recurse
>              * deeper and tear down the RTTs.
>              */

Sure

>> +            next_addr = ALIGN(addr + 1, map_size);
>> +            ret = realm_tear_down_rtt_level(realm,
>> +                            level + 1,
>> +                            addr,
>> +                            next_addr);
>> +            if (ret)
>> +                return ret;
>> +            /* Try again at this level */
> 
>             /*
>              * Now that the children RTTs are destroyed,
>              * retry at this level.
>              */

Sure

>> +            next_addr = addr;
>> +            break;
>> +        default:
>> +            WARN_ON(1);
>> +            return -ENXIO;
>> +        }
>> +    }
>> +
>> +    return 0;
>> +}
>> +
>> +static int realm_tear_down_rtt_range(struct realm *realm,
>> +                     unsigned long start, unsigned long end)
>> +{
>> +    return realm_tear_down_rtt_level(realm, get_start_level(realm) + 1,
>> +                     start, end);
>> +}
>> +
>> +static void ensure_spare_page(struct realm *realm)
>> +{
>> +    phys_addr_t tmp_rtt;
>> +
>> +    /*
>> +     * Make sure we have a spare delegated page for tearing down the
>> +     * block mappings. We do this by allocating then freeing a page.
>> +     * We must use Atomic allocations as we are called with
>> kvm->mmu_lock
>> +     * held.
>> +     */
>> +    tmp_rtt = __alloc_delegated_page(realm, NULL, GFP_ATOMIC);
>> +
>> +    /*
>> +     * If the allocation failed, continue as we may not have a block
>> level
>> +     * mapping so it may not be fatal, otherwise free it to assign it
>> +     * to the spare page.
>> +     */
>> +    if (tmp_rtt != PHYS_ADDR_MAX)
>> +        free_delegated_page(realm, tmp_rtt);
>> +}
>> +
>> +void kvm_realm_destroy_rtts(struct kvm *kvm, u32 ia_bits)
>> +{
>> +    struct realm *realm = &kvm->arch.realm;
>> +
>> +    ensure_spare_page(realm);
>> +
>> +    WARN_ON(realm_tear_down_rtt_range(realm, 0, (1UL << ia_bits)));
>> +}
> 
> minor nit: We don't seem to be using the "spare_page" yet in this patch.
> May be a good idea to move all the related changes
> (alloc_delegated_page() / free_delegated_page, ensure_spare_page() etc)
> to the patch where it may be better suited ?

Good point - I think the calls get added in "arm64: RME: Allow VMM to
set RIPAS". I'll try to move them there.

Thanks,

Steve

> Suzuki
> 
>> +
>>   /* Protects access to rme_vmid_bitmap */
>>   static DEFINE_SPINLOCK(rme_vmid_lock);
>>   static unsigned long *rme_vmid_bitmap;
> 


