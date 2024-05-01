Return-Path: <kvm+bounces-16354-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BC0EA8B8D76
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 17:48:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DEEDC1C20F33
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 15:48:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1159712FB13;
	Wed,  1 May 2024 15:48:31 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA79712F5A7;
	Wed,  1 May 2024 15:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714578510; cv=none; b=J5S6OvSqtyihfIPSWyaVXWVubL9iey+xJ+eBfnsQ855SY0RWJtBnz4eWl89sln9ptZ80ez6jbARBONo8DxPUEGZJdMQmIrLuk4d8pWKznKzFFqG65OyixwdgyEFO0QiSGFNxsiLvvFYYn5aZa5Qb1iUYSwQdyzkz+CeL+FiJ7Ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714578510; c=relaxed/simple;
	bh=ZZatJdKUDmf2CVXPMFjBWSOb+XJ/XSlCnJ9vhdW5Ets=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Xod3jlTpUPxOJfFfurnUj6wQ3sOqroa2qPqNfKlOC6lPmF/qzjeFSvQ6T6WVJUj1qxsCS+ualmXlWIIb0jfVfh3Nalr+nsmoOfKvi5R3w916xrAF7+bH1kq/9v+lqXeJEZH63od1PBUi1ZkSbDXVkGliz9zHHdU0qzYJ/6qpLCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 375502F4;
	Wed,  1 May 2024 08:48:52 -0700 (PDT)
Received: from [10.57.34.70] (unknown [10.57.34.70])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EA4EE3F793;
	Wed,  1 May 2024 08:48:19 -0700 (PDT)
Message-ID: <98ef5e64-2d1e-4fa2-a3da-210ea180f20f@arm.com>
Date: Wed, 1 May 2024 16:47:50 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 17/43] arm64: RME: Allow VMM to set RIPAS
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
 <20240412084309.1733783-18-steven.price@arm.com>
 <d2957090-fcf0-4dff-901e-d8ea975f2452@arm.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <d2957090-fcf0-4dff-901e-d8ea975f2452@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 19/04/2024 10:34, Suzuki K Poulose wrote:
> On 12/04/2024 09:42, Steven Price wrote:
>> Each page within the protected region of the realm guest can be marked
>> as either RAM or EMPTY. Allow the VMM to control this before the guest
>> has started and provide the equivalent functions to change this (with
>> the guest's approval) at runtime.
>>
>> When transitioning from RIPAS RAM (1) to RIPAS EMPTY (0) the memory is
>> unmapped from the guest and undelegated allowing the memory to be reused
>> by the host. When transitioning to RIPAS RAM the actual population of
>> the leaf RTTs is done later on stage 2 fault, however it may be
>> necessary to allocate additional RTTs to represent the range requested.
> 
> minor nit: To give a bit more context:
> 
> "however it may be necessary to allocate additional RTTs in order for
> the RMM to track the RIPAS for the requested range".

That is what I meant - but your wording is probably clearer ;)
Technically there's also the case where a RIPAS change will cause a
block mapping to be split which isn't just about tracking RIPAS but also
about breaking up the block mapping for the pages that remain.

>>
>> When freeing a block mapping it is necessary to temporarily unfold the
>> RTT which requires delegating an extra page to the RMM, this page can
>> then be recovered once the contents of the block mapping have been
>> freed. A spare, delegated page (spare_page) is used for this purpose.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>>   arch/arm64/include/asm/kvm_rme.h |  16 ++
>>   arch/arm64/kvm/mmu.c             |   8 +-
>>   arch/arm64/kvm/rme.c             | 390 +++++++++++++++++++++++++++++++
>>   3 files changed, 411 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/kvm_rme.h
>> b/arch/arm64/include/asm/kvm_rme.h
>> index 915e76068b00..cc8f81cfc3c0 100644
>> --- a/arch/arm64/include/asm/kvm_rme.h
>> +++ b/arch/arm64/include/asm/kvm_rme.h
>> @@ -96,6 +96,14 @@ void kvm_realm_destroy_rtts(struct kvm *kvm, u32
>> ia_bits);
>>   int kvm_create_rec(struct kvm_vcpu *vcpu);
>>   void kvm_destroy_rec(struct kvm_vcpu *vcpu);
>>   +void kvm_realm_unmap_range(struct kvm *kvm,
>> +               unsigned long ipa,
>> +               u64 size,
>> +               bool unmap_private);
>> +int realm_set_ipa_state(struct kvm_vcpu *vcpu,
>> +            unsigned long addr, unsigned long end,
>> +            unsigned long ripas);
>> +
>>   #define RME_RTT_BLOCK_LEVEL    2
>>   #define RME_RTT_MAX_LEVEL    3
>>   @@ -114,4 +122,12 @@ static inline unsigned long
>> rme_rtt_level_mapsize(int level)
>>       return (1UL << RME_RTT_LEVEL_SHIFT(level));
>>   }
>>   +static inline bool realm_is_addr_protected(struct realm *realm,
>> +                       unsigned long addr)
>> +{
>> +    unsigned int ia_bits = realm->ia_bits;
>> +
>> +    return !(addr & ~(BIT(ia_bits - 1) - 1));
>> +}
>> +
>>   #endif
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index 46f0c4e80ace..8a7b5449697f 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -310,6 +310,7 @@ static void invalidate_icache_guest_page(void *va,
>> size_t size)
>>    * @start: The intermediate physical base address of the range to unmap
>>    * @size:  The size of the area to unmap
>>    * @may_block: Whether or not we are permitted to block
>> + * @only_shared: If true then protected mappings should not be unmapped
>>    *
>>    * Clear a range of stage-2 mappings, lowering the various
>> ref-counts.  Must
>>    * be called while holding mmu_lock (unless for freeing the stage2
>> pgd before
>> @@ -317,7 +318,7 @@ static void invalidate_icache_guest_page(void *va,
>> size_t size)
>>    * with things behind our backs.
>>    */
>>   static void __unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t
>> start, u64 size,
>> -                 bool may_block)
>> +                 bool may_block, bool only_shared)
>>   {
>>       struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
>>       phys_addr_t end = start + size;
>> @@ -330,7 +331,7 @@ static void __unmap_stage2_range(struct kvm_s2_mmu
>> *mmu, phys_addr_t start, u64
>>     static void unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t
>> start, u64 size)
>>   {
>> -    __unmap_stage2_range(mmu, start, size, true);
>> +    __unmap_stage2_range(mmu, start, size, true, false);
>>   }
>>     static void stage2_flush_memslot(struct kvm *kvm,
>> @@ -1771,7 +1772,8 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct
>> kvm_gfn_range *range)
>>         __unmap_stage2_range(&kvm->arch.mmu, range->start << PAGE_SHIFT,
>>                    (range->end - range->start) << PAGE_SHIFT,
>> -                 range->may_block);
>> +                 range->may_block,
>> +                 range->only_shared);
>>         return false;
>>   }
>> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
>> index 629a095bea61..9e5983c51393 100644
>> --- a/arch/arm64/kvm/rme.c
>> +++ b/arch/arm64/kvm/rme.c
>> @@ -79,6 +79,12 @@ static phys_addr_t __alloc_delegated_page(struct
>> realm *realm,
>>       return phys;
>>   }
>>   +static phys_addr_t alloc_delegated_page(struct realm *realm,
>> +                    struct kvm_mmu_memory_cache *mc)
>> +{
>> +    return __alloc_delegated_page(realm, mc, GFP_KERNEL);
>> +}
>> +
>>   static void free_delegated_page(struct realm *realm, phys_addr_t phys)
>>   {
>>       if (realm->spare_page == PHYS_ADDR_MAX) {
>> @@ -94,6 +100,151 @@ static void free_delegated_page(struct realm
>> *realm, phys_addr_t phys)
>>       free_page((unsigned long)phys_to_virt(phys));
>>   }
>>   +static int realm_rtt_create(struct realm *realm,
>> +                unsigned long addr,
>> +                int level,
>> +                phys_addr_t phys)
>> +{
>> +    addr = ALIGN_DOWN(addr, rme_rtt_level_mapsize(level - 1));
>> +    return rmi_rtt_create(virt_to_phys(realm->rd), phys, addr, level);
>> +}
>> +
>> +static int realm_rtt_fold(struct realm *realm,
>> +              unsigned long addr,
>> +              int level,
>> +              phys_addr_t *rtt_granule)
>> +{
>> +    unsigned long out_rtt;
>> +    int ret;
>> +
>> +    ret = rmi_rtt_fold(virt_to_phys(realm->rd), addr, level, &out_rtt);
>> +
>> +    if (RMI_RETURN_STATUS(ret) == RMI_SUCCESS && rtt_granule)
>> +        *rtt_granule = out_rtt;
>> +
>> +    return ret;
>> +}
>> +
>> +static int realm_destroy_protected(struct realm *realm,
>> +                   unsigned long ipa,
>> +                   unsigned long *next_addr)
>> +{
>> +    unsigned long rd = virt_to_phys(realm->rd);
>> +    unsigned long addr;
>> +    phys_addr_t rtt;
>> +    int ret;
>> +
>> +loop:
>> +    ret = rmi_data_destroy(rd, ipa, &addr, next_addr);
>> +    if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
>> +        if (*next_addr > ipa)
>> +            return 0; /* UNASSIGNED */
>> +        rtt = alloc_delegated_page(realm, NULL);
>> +        if (WARN_ON(rtt == PHYS_ADDR_MAX))
>> +            return -1;
>> +        /* ASSIGNED - ipa is mapped as a block, so split */
>> +        ret = realm_rtt_create(realm, ipa,
>> +                       RMI_RETURN_INDEX(ret) + 1, rtt);
> 
> Could we not go all the way to L3 (rather than 1 level deeper) and try
> again ? That way, we are covered for block mappings at L1 (1G).

I don't think this situation can happen. The spec states that for
RMI_ERROR_RTT either top>ipa (UNASSIGNED, in which case we've bailed out
above) or top==ipa (ASSIGNED) in which case RMI_RETURN_INDEX(ret) must
equal 2.

So in this case realm_rtt_create() will always be called with level=3.

I can simplify this by explicitly passing 3 and adding a WARN_ON() for
RMI_RETURN_INDEX(ret) != 2.

>> +        if (WARN_ON(ret)) {
>> +            free_delegated_page(realm, rtt);
>> +            return -1;
>> +        }
>> +        /* retry */
>> +        goto loop;
>> +    } else if (WARN_ON(ret)) {
>> +        return -1;
>> +    }
>> +    ret = rmi_granule_undelegate(addr);
>> +
>> +    /*
>> +     * If the undelegate fails then something has gone seriously
>> +     * wrong: take an extra reference to just leak the page
>> +     */
>> +    if (WARN_ON(ret))
>> +        get_page(phys_to_page(addr));
>> +
>> +    return 0;
>> +}
>> +
>> +static void realm_unmap_range_shared(struct kvm *kvm,
>> +                     int level,
>> +                     unsigned long start,
>> +                     unsigned long end)
>> +{
>> +    struct realm *realm = &kvm->arch.realm;
>> +    unsigned long rd = virt_to_phys(realm->rd);
>> +    ssize_t map_size = rme_rtt_level_mapsize(level);
>> +    unsigned long next_addr, addr;
>> +    unsigned long shared_bit = BIT(realm->ia_bits - 1);
>> +
>> +    if (WARN_ON(level > RME_RTT_MAX_LEVEL))
>> +        return;
>> +
>> +    start |= shared_bit;
>> +    end |= shared_bit;
>> +
>> +    for (addr = start; addr < end; addr = next_addr) {
>> +        unsigned long align_addr = ALIGN(addr, map_size);
>> +        int ret;
>> +
>> +        next_addr = ALIGN(addr + 1, map_size);
>> +
>> +        if (align_addr != addr || next_addr > end) {
>> +            /* Need to recurse deeper */
>> +            if (addr < align_addr)
>> +                next_addr = align_addr;
>> +            realm_unmap_range_shared(kvm, level + 1, addr,
>> +                         min(next_addr, end));
>> +            continue;
>> +        }
>> +
>> +        ret = rmi_rtt_unmap_unprotected(rd, addr, level, &next_addr);
> 
> minor nit: We could potentially use rmi_rtt_destroy() to tear down
> shared mappings without unmapping them individually, if the range
> is big enough. All such optimisations could come later though.

Apparently so, I do feel the "liveness" concept in the RMM spec is very
confusing. But it looks like an RTT in the unprotected IPA range isn't
considered 'live' if it only contains ASSIGNED_NS entries. The wording
here isn't great though:

  An RTT is live if, for any of its entries, either of the following is
  true:
    • The RTTE state is ASSIGNED
    • The RTTE state is TABLE.

   Note that an RTT can be non-live, even if one of its entries is live.
   This would be the case for example if the RTT corresponds to an
   Unprotected IPA range and the state of one of its entries is
   ASSIGNED_NS.

Like you say this is an optimisation, so I think we should leave it
until later for now.

>> +        switch (RMI_RETURN_STATUS(ret)) {
>> +        case RMI_SUCCESS:
>> +            break;
>> +        case RMI_ERROR_RTT:
>> +            if (next_addr == addr) {
> 
> At this point we have a block aligned address, but the mapping is
> further deep. Given, start from top to down, we implicitly handle
> the case of block mappings. Not sure if that needs to be in a comment
> here.
> 
>> +                next_addr = ALIGN(addr + 1, map_size);
> 
> Reset to the "actual next" as it was overwritten by the RMI call.

I'll add a comment explaining what's happening here.

>> +                realm_unmap_range_shared(kvm, level + 1, addr,
>> +                             next_addr);
>> +            }
>> +            break;
>> +        default:
>> +            WARN_ON(1);
>> +        }
>> +    }
>> +}
>> +
>> +static void realm_unmap_range_private(struct kvm *kvm,
>> +                      unsigned long start,
>> +                      unsigned long end)
>> +{
>> +    struct realm *realm = &kvm->arch.realm;
>> +    ssize_t map_size = RME_PAGE_SIZE;
>> +    unsigned long next_addr, addr;
>> +
>> +    for (addr = start; addr < end; addr = next_addr) {
>> +        int ret;
>> +
>> +        next_addr = ALIGN(addr + 1, map_size);
>> +
>> +        ret = realm_destroy_protected(realm, addr, &next_addr);
>> +
>> +        if (WARN_ON(ret))
>> +            break;
>> +    }
>> +}
>> +
>> +static void realm_unmap_range(struct kvm *kvm,
>> +                  unsigned long start,
>> +                  unsigned long end,
>> +                  bool unmap_private)
>> +{
>> +    realm_unmap_range_shared(kvm, RME_RTT_MAX_LEVEL - 1, start, end);
> 
> minor nit: We already have a helper to find a suitable start level
> (defined below), may be we could use that ? And even do the rtt_destroy
> optimisation for unprotected range.

Good point, that should work.

>> +    if (unmap_private)
>> +        realm_unmap_range_private(kvm, start, end);
>> +}
>> +
>>   u32 kvm_realm_ipa_limit(void)
>>   {
>>       return u64_get_bits(rmm_feat_reg0, RMI_FEATURE_REGISTER_0_S2SZ);
>> @@ -190,6 +341,30 @@ static int realm_rtt_destroy(struct realm *realm,
>> unsigned long addr,
>>       return ret;
>>   }
>>   +static int realm_create_rtt_levels(struct realm *realm,
>> +                   unsigned long ipa,
>> +                   int level,
>> +                   int max_level,
>> +                   struct kvm_mmu_memory_cache *mc)
>> +{
>> +    if (WARN_ON(level == max_level))
>> +        return 0;
>> +
>> +    while (level++ < max_level) {
>> +        phys_addr_t rtt = alloc_delegated_page(realm, mc);
>> +
>> +        if (rtt == PHYS_ADDR_MAX)
>> +            return -ENOMEM;
>> +
>> +        if (realm_rtt_create(realm, ipa, level, rtt)) {
>> +            free_delegated_page(realm, rtt);
>> +            return -ENXIO;
>> +        }
>> +    }
>> +
>> +    return 0;
>> +}
>> +
>>   static int realm_tear_down_rtt_level(struct realm *realm, int level,
>>                        unsigned long start, unsigned long end)
>>   {
>> @@ -265,6 +440,68 @@ static int realm_tear_down_rtt_range(struct realm
>> *realm,
>>                        start, end);
>>   }
>>   +/*
>> + * Returns 0 on successful fold, a negative value on error, a
>> positive value if
>> + * we were not able to fold all tables at this level.
>> + */
>> +static int realm_fold_rtt_level(struct realm *realm, int level,
>> +                unsigned long start, unsigned long end)
>> +{
>> +    int not_folded = 0;
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
>> +        ret = realm_rtt_fold(realm, align_addr, level, &rtt_granule);
>> +
>> +        switch (RMI_RETURN_STATUS(ret)) {
>> +        case RMI_SUCCESS:
>> +            if (!WARN_ON(rmi_granule_undelegate(rtt_granule)))
>> +                free_page((unsigned long)phys_to_virt(rtt_granule));
> 
> minor nit: Do we need a wrapper function for things like this, abd
> leaking the page if undelegate fails, something like
> rme_reclaim_delegated_page()  ?

I'll take a look at that - mostly sites don't have the same argument
repeated (unlike this one), so I'll have to have a think about the best
form.

>> +            break;
>> +        case RMI_ERROR_RTT:
>> +            if (level == RME_RTT_MAX_LEVEL ||
>> +                RMI_RETURN_INDEX(ret) < level) {
>> +                not_folded++;
>> +                break;
>> +            }
>> +            /* Recurse a level deeper */
>> +            ret = realm_fold_rtt_level(realm,
>> +                           level + 1,
>> +                           addr,
>> +                           next_addr);
>> +            if (ret < 0)
>> +                return ret;
>> +            else if (ret == 0)
>> +                /* Try again at this level */
>> +                next_addr = addr;
>> +            break;
>> +        default:
>> +            return -ENXIO;
>> +        }
>> +    }
>> +
>> +    return not_folded;
>> +}
>> +
>> +static int realm_fold_rtt_range(struct realm *realm,
>> +                unsigned long start, unsigned long end)
>> +{
>> +    return realm_fold_rtt_level(realm, get_start_level(realm) + 1,
>> +                    start, end);
>> +}
>> +
>>   static void ensure_spare_page(struct realm *realm)
>>   {
>>       phys_addr_t tmp_rtt;
>> @@ -295,6 +532,147 @@ void kvm_realm_destroy_rtts(struct kvm *kvm, u32
>> ia_bits)
>>       WARN_ON(realm_tear_down_rtt_range(realm, 0, (1UL << ia_bits)));
>>   }
>>   +void kvm_realm_unmap_range(struct kvm *kvm, unsigned long ipa, u64
>> size,
>> +               bool unmap_private)
>> +{
>> +    unsigned long end = ipa + size;
>> +    struct realm *realm = &kvm->arch.realm;
>> +
>> +    end = min(BIT(realm->ia_bits - 1), end);
>> +
>> +    ensure_spare_page(realm);
>> +
>> +    realm_unmap_range(kvm, ipa, end, unmap_private);
>> +
>> +    realm_fold_rtt_range(realm, ipa, end);
> 
> Shouldn't this be :
> 
>     if (unmap_private)
>         realm_fold_rtt_range(realm, ipa, end);

Indeed it's a little pointless folding if we haven't touched the private
mappings.

> Also it is fine to reclaim RTTs from the protected space, not the
> unprotected half, as long as we use RTT_DESTROY in unmap_shared routine.
> 
>> +}
>> +
>> +static int find_map_level(struct realm *realm,
>> +              unsigned long start,
>> +              unsigned long end)
>> +{
>> +    int level = RME_RTT_MAX_LEVEL;
>> +
>> +    while (level > get_start_level(realm)) {
>> +        unsigned long map_size = rme_rtt_level_mapsize(level - 1);
>> +
>> +        if (!IS_ALIGNED(start, map_size) ||
>> +            (start + map_size) > end)
>> +            break;
>> +
>> +        level--;
>> +    }
>> +
>> +    return level;
>> +}
>> +
>> +int realm_set_ipa_state(struct kvm_vcpu *vcpu,
>> +            unsigned long start,
>> +            unsigned long end,
>> +            unsigned long ripas)
>> +{
>> +    struct kvm *kvm = vcpu->kvm;
>> +    struct realm *realm = &kvm->arch.realm;
>> +    struct realm_rec *rec = &vcpu->arch.rec;
>> +    phys_addr_t rd_phys = virt_to_phys(realm->rd);
>> +    phys_addr_t rec_phys = virt_to_phys(rec->rec_page);
>> +    struct kvm_mmu_memory_cache *memcache = &vcpu->arch.mmu_page_cache;
>> +    unsigned long ipa = start;
>> +    int ret = 0;
>> +
>> +    while (ipa < end) {
>> +        unsigned long next;
>> +
>> +        ret = rmi_rtt_set_ripas(rd_phys, rec_phys, ipa, end, &next);
>> +
>> +        if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
>> +            int walk_level = RMI_RETURN_INDEX(ret);
>> +            int level = find_map_level(realm, ipa, end);
> 
> Might be worth adding a comment here. Check if the RMM needs tables to
> create deeper level tables.

Ok

>> +
>> +            if (walk_level < level) {
>> +                ret = realm_create_rtt_levels(realm, ipa,
>> +                                  walk_level,
>> +                                  level,
>> +                                  memcache);
>                 /* Retry with RTTs created */

Ok

>> +                if (!ret)
>> +                    continue;
>> +            } else {
>> +                ret = -EINVAL;
>> +            }
>> +
>> +            break;
>> +        } else if (RMI_RETURN_STATUS(ret) != RMI_SUCCESS) {
>> +            WARN(1, "Unexpected error in %s: %#x\n", __func__,
>> +                 ret);
>> +            ret = -EINVAL;
>> +            break;
>> +        }
>> +        ipa = next;
>> +    }
>> +
>> +    if (ripas == RMI_EMPTY && ipa != start)
>> +        kvm_realm_unmap_range(kvm, start, ipa - start, true);
> 
> This triggers unmapping the "shared" aliases too, which is not necessary.

Yeah, the kvm_realm_unmap_range() function is a bit problematic - the
various "unmap_private" and "only_shared" flags need a bit of a rethink.

>> +
>> +    return ret;
>> +}
>> +
>> +static int realm_init_ipa_state(struct realm *realm,
>> +                unsigned long ipa,
>> +                unsigned long end)
>> +{
>> +    phys_addr_t rd_phys = virt_to_phys(realm->rd);
>> +    int ret;
>> +
>> +    while (ipa < end) {
>> +        unsigned long next;
>> +
>> +        ret = rmi_rtt_init_ripas(rd_phys, ipa, end, &next);
>> +
>> +        if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
>> +            int err_level = RMI_RETURN_INDEX(ret);
>> +            int level = find_map_level(realm, ipa, end);
>> +
>> +            if (WARN_ON(err_level >= level))
>> +                return -ENXIO;
>> +
>> +            ret = realm_create_rtt_levels(realm, ipa,
>> +                              err_level,
>> +                              level, NULL);
>> +            if (ret)
>> +                return ret;
>> +            /* Retry with the RTT levels in place */
>> +            continue;
>> +        } else if (WARN_ON(ret)) {
>> +            return -ENXIO;
>> +        }
>> +
>> +        ipa = next;
>> +    }
>> +
>> +    return 0;
>> +}
>> +
>> +static int kvm_init_ipa_range_realm(struct kvm *kvm,
>> +                    struct kvm_cap_arm_rme_init_ipa_args *args)
>> +{
>> +    int ret = 0;
>> +    gpa_t addr, end;
>> +    struct realm *realm = &kvm->arch.realm;
>> +
>> +    addr = args->init_ipa_base;
>> +    end = addr + args->init_ipa_size;
>> +
>> +    if (end < addr)
>> +        return -EINVAL;
>> +
>> +    if (kvm_realm_state(kvm) != REALM_STATE_NEW)
>> +        return -EINVAL;
>> +
>> +    ret = realm_init_ipa_state(realm, addr, end);
>> +
>> +    return ret;
> 
> super minor nit:
> 
>     return realm_init_ipa_state(realm, addr, end);

That was probably left over from some printk() debugging ;)

Thanks,

Steve

>> +}
>> +
>>   /* Protects access to rme_vmid_bitmap */
>>   static DEFINE_SPINLOCK(rme_vmid_lock);
>>   static unsigned long *rme_vmid_bitmap;
>> @@ -418,6 +796,18 @@ int kvm_realm_enable_cap(struct kvm *kvm, struct
>> kvm_enable_cap *cap)
>>       case KVM_CAP_ARM_RME_CREATE_RD:
>>           r = kvm_create_realm(kvm);
>>           break;
>> +    case KVM_CAP_ARM_RME_INIT_IPA_REALM: {
>> +        struct kvm_cap_arm_rme_init_ipa_args args;
>> +        void __user *argp = u64_to_user_ptr(cap->args[1]);
>> +
>> +        if (copy_from_user(&args, argp, sizeof(args))) {
>> +            r = -EFAULT;
>> +            break;
>> +        }
>> +
>> +        r = kvm_init_ipa_range_realm(kvm, &args);
>> +        break;
>> +    }
> 
> 
> Suzuki


