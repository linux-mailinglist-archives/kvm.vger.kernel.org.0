Return-Path: <kvm+bounces-45131-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E0D1AA6119
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 18:00:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A41A64C0756
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 16:00:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5ED6520C476;
	Thu,  1 May 2025 16:00:23 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C818118DB22;
	Thu,  1 May 2025 16:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746115222; cv=none; b=baAFeRBivI3j+jd5zn1YFw+JZwJgTk5UNAvllEE3uBHTA6F0E7JIDwF6oavZqI/wjMMbnDE6LRQ1hrJugUOGedyrHTWm8qRLAJs37jb78Gj9KAGxMrC62agiIfd1XsXxX9xkCxeM19ebku+gi5wiPxL7SZCJJYv+mcALNJq4Pvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746115222; c=relaxed/simple;
	bh=qycommOHeU0zrP8rXUreb45o44kJWtMHKA+K93ioBEQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I3gpTblGH0bw2zPIXhtYvIBzJ77Cb/9pCxbBuiLSemMHCJrsGOLwlSAdN1gPJBVz8Vmr9dvWgLa0eEZcNr+wj+4lD+ZR+OILFmj3AVUYKI9sHETUiqlXo3Wv8yqjqAVbo+Q+rbUQ2NZcrFlRZ4UdgKwB1bN24AcHFqJdgUD3Sf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7AA10168F;
	Thu,  1 May 2025 09:00:11 -0700 (PDT)
Received: from [10.1.33.27] (e122027.cambridge.arm.com [10.1.33.27])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1C2053F673;
	Thu,  1 May 2025 09:00:14 -0700 (PDT)
Message-ID: <d2caa472-01da-4dc2-8c38-bf0cd4524bcd@arm.com>
Date: Thu, 1 May 2025 17:00:13 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 15/43] arm64: RME: Allow VMM to set RIPAS
To: Gavin Shan <gshan@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20250416134208.383984-1-steven.price@arm.com>
 <20250416134208.383984-16-steven.price@arm.com>
 <cc2c5834-c942-4454-903d-11b53f8f5451@redhat.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <cc2c5834-c942-4454-903d-11b53f8f5451@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 30/04/2025 12:38, Gavin Shan wrote:
> On 4/16/25 11:41 PM, Steven Price wrote:
>> Each page within the protected region of the realm guest can be marked
>> as either RAM or EMPTY. Allow the VMM to control this before the guest
>> has started and provide the equivalent functions to change this (with
>> the guest's approval) at runtime.
>>
>> When transitioning from RIPAS RAM (1) to RIPAS EMPTY (0) the memory is
>> unmapped from the guest and undelegated allowing the memory to be reused
>> by the host. When transitioning to RIPAS RAM the actual population of
>> the leaf RTTs is done later on stage 2 fault, however it may be
>> necessary to allocate additional RTTs to allow the RMM track the RIPAS
>> for the requested range.
>>
>> When freeing a block mapping it is necessary to temporarily unfold the
>> RTT which requires delegating an extra page to the RMM, this page can
>> then be recovered once the contents of the block mapping have been
>> freed.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> Changes from v7:
>>   * Replace use of "only_shared" with the upstream "attr_filter" field
>>     of struct kvm_gfn_range.
>>   * Clean up the logic in alloc_delegated_granule() for when to call
>>     kvm_account_pgtable_pages().
>>   * Rename realm_destroy_protected_granule() to
>>     realm_destroy_private_granule() to match the naming elsewhere. Also
>>     fix the return codes in the function to be descriptive.
>>   * Several other minor changes to names/return codes.
>> Changes from v6:
>>   * Split the code dealing with the guest triggering a RIPAS change into
>>     a separate patch, so this patch is purely for the VMM setting up the
>>     RIPAS before the guest first runs.
>>   * Drop the useless flags argument from alloc_delegated_granule().
>>   * Account RTTs allocated for a guest using kvm_account_pgtable_pages().
>>   * Deal with the RMM granule size potentially being smaller than the
>>     host's PAGE_SIZE. Although note alloc_delegated_granule() currently
>>     still allocates an entire host page for every RMM granule (so wasting
>>     memory when PAGE_SIZE>4k).
>> Changes from v5:
>>   * Adapt to rebasing.
>>   * Introduce find_map_level()
>>   * Rename some functions to be clearer.
>>   * Drop the "spare page" functionality.
>> Changes from v2:
>>   * {alloc,free}_delegated_page() moved from previous patch to this one.
>>   * alloc_delegated_page() now takes a gfp_t flags parameter.
>>   * Fix the reference counting of guestmem pages to avoid leaking memory.
>>   * Several misc code improvements and extra comments.
>> ---
>>   arch/arm64/include/asm/kvm_rme.h |   5 +
>>   arch/arm64/kvm/mmu.c             |   8 +-
>>   arch/arm64/kvm/rme.c             | 384 +++++++++++++++++++++++++++++++
>>   3 files changed, 394 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/
>> asm/kvm_rme.h
>> index 9bcad6ec5dbb..b916db8565a2 100644
>> --- a/arch/arm64/include/asm/kvm_rme.h
>> +++ b/arch/arm64/include/asm/kvm_rme.h
>> @@ -101,6 +101,11 @@ void kvm_realm_destroy_rtts(struct kvm *kvm, u32
>> ia_bits);
>>   int kvm_create_rec(struct kvm_vcpu *vcpu);
>>   void kvm_destroy_rec(struct kvm_vcpu *vcpu);
>>   +void kvm_realm_unmap_range(struct kvm *kvm,
>> +               unsigned long ipa,
>> +               unsigned long size,
>> +               bool unmap_private);
>> +
>>   static inline bool kvm_realm_is_private_address(struct realm *realm,
>>                           unsigned long addr)
>>   {
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index d80a9d408f71..71c04259e39f 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -323,6 +323,7 @@ static void invalidate_icache_guest_page(void *va,
>> size_t size)
>>    * @start: The intermediate physical base address of the range to unmap
>>    * @size:  The size of the area to unmap
>>    * @may_block: Whether or not we are permitted to block
>> + * @only_shared: If true then protected mappings should not be unmapped
>>    *
>>    * Clear a range of stage-2 mappings, lowering the various ref-
>> counts.  Must
>>    * be called while holding mmu_lock (unless for freeing the stage2
>> pgd before
>> @@ -330,7 +331,7 @@ static void invalidate_icache_guest_page(void *va,
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
>> @@ -344,7 +345,7 @@ static void __unmap_stage2_range(struct kvm_s2_mmu
>> *mmu, phys_addr_t start, u64
>>   void kvm_stage2_unmap_range(struct kvm_s2_mmu *mmu, phys_addr_t start,
>>                   u64 size, bool may_block)
>>   {
>> -    __unmap_stage2_range(mmu, start, size, may_block);
>> +    __unmap_stage2_range(mmu, start, size, may_block, false);
>>   }
>>     void kvm_stage2_flush_range(struct kvm_s2_mmu *mmu, phys_addr_t
>> addr, phys_addr_t end)
>> @@ -1975,7 +1976,8 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct
>> kvm_gfn_range *range)
>>         __unmap_stage2_range(&kvm->arch.mmu, range->start << PAGE_SHIFT,
>>                    (range->end - range->start) << PAGE_SHIFT,
>> -                 range->may_block);
>> +                 range->may_block,
>> +                 !(range->attr_filter & KVM_FILTER_PRIVATE));
>>         kvm_nested_s2_unmap(kvm, range->may_block);
>>       return false;
>> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
>> index 1239eb07aca6..33eb793d8bdb 100644
>> --- a/arch/arm64/kvm/rme.c
>> +++ b/arch/arm64/kvm/rme.c
>> @@ -87,6 +87,51 @@ static int get_start_level(struct realm *realm)
>>       return 4 - ((realm->ia_bits - 8) / (RMM_PAGE_SHIFT - 3));
>>   }
>>   +static int find_map_level(struct realm *realm,
>> +              unsigned long start,
>> +              unsigned long end)
>> +{
>> +    int level = RMM_RTT_MAX_LEVEL;
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
>> +static phys_addr_t alloc_delegated_granule(struct
>> kvm_mmu_memory_cache *mc)
>> +{
>> +    phys_addr_t phys;
>> +    void *virt;
>> +
>> +    if (mc)
>> +        virt = kvm_mmu_memory_cache_alloc(mc);
>> +    else
>> +        virt = (void *)__get_free_page(GFP_KERNEL_ACCOUNT);
> 
> 
> It would be more safe to use (GFP_ATOMIC | __GFP_ZERO | __GFP_ACCOUNT),
> consistent
> to the flags used by kvm_mmu_memory_cache_alloc().

Ack

>> +
>> +    if (!virt)
>> +        return PHYS_ADDR_MAX;
>> +
>> +    phys = virt_to_phys(virt);
>> +
>> +    if (rmi_granule_delegate(phys)) {
>> +        free_page((unsigned long)virt);
>> +
>> +        return PHYS_ADDR_MAX;
>> +    }
>> +
>> +    kvm_account_pgtable_pages(virt, 1);
>> +
>> +    return phys;
>> +}
>> +
>>   static void free_delegated_granule(phys_addr_t phys)
>>   {
>>       if (WARN_ON(rmi_granule_undelegate(phys))) {
>> @@ -99,6 +144,154 @@ static void free_delegated_granule(phys_addr_t phys)
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
>> +static int realm_destroy_private_granule(struct realm *realm,
>> +                     unsigned long ipa,
>> +                     unsigned long *next_addr,
>> +                     phys_addr_t *out_rtt)
>> +{
>> +    unsigned long rd = virt_to_phys(realm->rd);
>> +    unsigned long rtt_addr;
>> +    phys_addr_t rtt;
>> +    int ret;
>> +
>> +retry:
>> +    ret = rmi_data_destroy(rd, ipa, &rtt_addr, next_addr);
>> +    if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
>> +        if (*next_addr > ipa)
>> +            return 0; /* UNASSIGNED */
>> +        rtt = alloc_delegated_granule(NULL);
>> +        if (WARN_ON(rtt == PHYS_ADDR_MAX))
>> +            return -ENOMEM;
>> +        /*
>> +         * ASSIGNED - ipa is mapped as a block, so split. The index
>> +         * from the return code should be 2 otherwise it appears
>> +         * there's a huge page bigger than KVM currently supports
>> +         */
>> +        WARN_ON(RMI_RETURN_INDEX(ret) != 2);
>> +        ret = realm_rtt_create(realm, ipa, 3, rtt);
>> +        if (WARN_ON(ret)) {
>> +            free_delegated_granule(rtt);
>> +            return -ENXIO;
>> +        }
>> +        goto retry;
>> +    } else if (WARN_ON(ret)) {
>> +        return -ENXIO;
>> +    }
>> +
>> +    ret = rmi_granule_undelegate(rtt_addr);
>> +    if (WARN_ON(ret))
>> +        return -ENXIO;
>> +
>> +    *out_rtt = rtt_addr;
>> +
>> +    return 0;
>> +}
>> +
>> +static int realm_unmap_private_page(struct realm *realm,
>> +                    unsigned long ipa,
>> +                    unsigned long *next_addr)
>> +{
>> +    unsigned long end = ALIGN(ipa + 1, PAGE_SIZE);
>> +    unsigned long addr;
>> +    phys_addr_t out_rtt = PHYS_ADDR_MAX;
>> +    int ret;
>> +
>> +    for (addr = ipa; addr < end; addr = *next_addr) {
>> +        ret = realm_destroy_private_granule(realm, addr, next_addr,
>> +                            &out_rtt);
>> +        if (ret)
>> +            return ret;
>> +    }
>> +
>> +    if (out_rtt != PHYS_ADDR_MAX)
>> +        free_page((unsigned long)phys_to_virt(out_rtt));
>> +
>> +    return 0;
>> +}
>> +
>> +static void realm_unmap_shared_range(struct kvm *kvm,
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
>> +    if (WARN_ON(level > RMM_RTT_MAX_LEVEL))
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
>> +            realm_unmap_shared_range(kvm, level + 1, addr,
>> +                         min(next_addr, end));
>> +            continue;
>> +        }
>> +
>> +        ret = rmi_rtt_unmap_unprotected(rd, addr, level, &next_addr);
>> +        switch (RMI_RETURN_STATUS(ret)) {
>> +        case RMI_SUCCESS:
>> +            break;
>> +        case RMI_ERROR_RTT:
>> +            if (next_addr == addr) {
>> +                /*
>> +                 * There's a mapping here, but it's not a block
>> +                 * mapping, so reset next_addr to the next block
>> +                 * boundary and recurse to clear out the pages
>> +                 * one level deeper.
>> +                 */
>> +                next_addr = ALIGN(addr + 1, map_size);
>> +                realm_unmap_shared_range(kvm, level + 1, addr,
>> +                             next_addr);
>> +            }
>> +            break;
>> +        default:
>> +            WARN_ON(1);
>> +            return;
>> +        }
>> +
>> +        cond_resched_rwlock_write(&kvm->mmu_lock);
>> +    }
>> +}
>> +
>>   /* Calculate the number of s2 root rtts needed */
>>   static int realm_num_root_rtts(struct realm *realm)
>>   {
>> @@ -209,6 +402,40 @@ static int realm_rtt_destroy(struct realm *realm,
>> unsigned long addr,
>>       return ret;
>>   }
>>   +static int realm_create_rtt_levels(struct realm *realm,
>> +                   unsigned long ipa,
>> +                   int level,
>> +                   int max_level,
>> +                   struct kvm_mmu_memory_cache *mc)
>> +{
>> +    if (level == max_level)
>> +        return 0;
>> +
>> +    while (level++ < max_level) {
>> +        phys_addr_t rtt = alloc_delegated_granule(mc);
>> +        int ret;
>> +
>> +        if (rtt == PHYS_ADDR_MAX)
>> +            return -ENOMEM;
>> +
>> +        ret = realm_rtt_create(realm, ipa, level, rtt);
>> +
>> +        if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT &&
>> +            RMI_RETURN_INDEX(ret) == level) {
>> +            /* The RTT already exists, continue */
>> +            continue;
>> +        }
>> +        if (ret) {
>> +            WARN(1, "Failed to create RTT at level %d: %d\n",
>> +                 level, ret);
>> +            free_delegated_granule(rtt);
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
>> @@ -299,6 +526,61 @@ static int realm_tear_down_rtt_range(struct realm
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
>> +    if (WARN_ON(level > RMM_RTT_MAX_LEVEL))
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
>> +            free_delegated_granule(rtt_granule);
>> +            break;
>> +        case RMI_ERROR_RTT:
>> +            if (level == RMM_RTT_MAX_LEVEL ||
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
>> +            WARN_ON(1);
>> +            return -ENXIO;
>> +        }
>> +    }
>> +
>> +    return not_folded;
>> +}
>> +
>>   void kvm_realm_destroy_rtts(struct kvm *kvm, u32 ia_bits)
>>   {
>>       struct realm *realm = &kvm->arch.realm;
>> @@ -306,6 +588,96 @@ void kvm_realm_destroy_rtts(struct kvm *kvm, u32
>> ia_bits)
>>       WARN_ON(realm_tear_down_rtt_range(realm, 0, (1UL << ia_bits)));
>>   }
>>   +static void realm_unmap_private_range(struct kvm *kvm,
>> +                      unsigned long start,
>> +                      unsigned long end)
>> +{
>> +    struct realm *realm = &kvm->arch.realm;
>> +    unsigned long next_addr, addr;
>> +    int ret;
>> +
>> +    for (addr = start; addr < end; addr = next_addr) {
>> +        ret = realm_unmap_private_page(realm, addr, &next_addr);
>> +
>> +        if (ret)
>> +            break;
>> +    }
>> +
>> +    realm_fold_rtt_level(realm, get_start_level(realm) + 1,
>> +                 start, end);
>> +}
>> +
>> +void kvm_realm_unmap_range(struct kvm *kvm, unsigned long start,
>> +               unsigned long size, bool unmap_private)
>> +{
> 
> This function can be called by the MMU notifier to invalidate the
> mapping for
> the specified IPA range. However, we're missing one parameter to
> indicate if
> the request from the MMU notifier is blockable or not. We're having the
> imprecise
> assumption that all requests are blockable, which isn't always true.
> With this
> assumption, cond_resched_rwlock_write(&kvm->mmu_lock) is always called in
> realm_unmap_shared_range().
> 
> Another issue is that cond_resched_rwlock_write(&kvm->mmu_lock) is
> missed if
> the request is blockable in realm_unmap_private_page().

Thanks, that makes a lot of sense. I'd got myself rather confused about
whether this function could block or not. Somehow I'd completely missed
the may_block flag in __unmap_stage2_range().

>> +    unsigned long end = start + size;
>> +    struct realm *realm = &kvm->arch.realm;
>> +
>> +    end = min(BIT(realm->ia_bits - 1), end);
>> +
>> +    if (realm->state == REALM_STATE_NONE)
>> +        return;
> 
>     if (!kvm_realm_is_created(kvm)))
>         return;

Ack

>> +
>> +    realm_unmap_shared_range(kvm, find_map_level(realm, start, end),
>> +                 start, end);
>> +    if (unmap_private)
>> +        realm_unmap_private_range(kvm, start, end);
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
> 
> The readability would be better if the explicit 'continue' can be avoid,
> something
> like below:
> 
>     switch (RMI_RETURN_STATUS(ret)) {
>     case RMI_SUCCESS:
>         ipa = next;
>         break;
>     case RMI_ERROR_RTT:
>         :
>         ret = realm_create_rtt_levels(realm, ipa, error_level, level,
> NULL);
>         if (ret)
>             return ret;
>         break;
>     default:
>         WARN_ON(1);
>         return -ENXIO;
>     }

I have to admit to quite liking 'continue' for retry loops, but in this
case your switch statement seems just as readable so I'll switch this.

>> +static int kvm_init_ipa_range_realm(struct kvm *kvm,
>> +                    struct arm_rme_init_ripas *args)
>> +{
>> +    gpa_t addr, end;
>> +    struct realm *realm = &kvm->arch.realm;
>> +
>> +    addr = args->base;
>> +    end = addr + args->size;
>> +
>> +    if (end < addr)
>> +        return -EINVAL;
> 
> The check needs to cover 'end <= addr'. RMI_ERROR_INPUT is returned from
> RMM::smc_rtt_init_ripas()
> if 'end' is equal to 'addr', but we're returning 0, inconsistent to that.

I agree we're different to smc_rtt_init_ripas(), but I don't really see
why we should prevent args->size==0. Calling the low level SMC in that
case would clearly be wrong (the kernel should be validating and that
would show a lack of validation), but we handle that with the while loop
in realm_init_ipa_state().

Do you think it's important to define this uAPI to disallow size==0?

>     if (end <= addr)
>         return -EINVAL;
> 
>> +
>> +    if (kvm_realm_state(kvm) != REALM_STATE_NEW)
>> +        return -EPERM;
> 
> To keep the consistency, kvm_realm_is_created() can be used here.
> 
>     if (kvm_realm_is_created(kvm))
>         return -EPERM;

This isn't the same - kvm_realm_is_create() is checking for
REALM_STATE_NONE, but we want to check for REALM_STATE_NEW.

Thanks,
Steve

>> +
>> +    return realm_init_ipa_state(realm, addr, end);
>> +}
>> +
>>   /* Protects access to rme_vmid_bitmap */
>>   static DEFINE_SPINLOCK(rme_vmid_lock);
>>   static unsigned long *rme_vmid_bitmap;
>> @@ -431,6 +803,18 @@ int kvm_realm_enable_cap(struct kvm *kvm, struct
>> kvm_enable_cap *cap)
>>       case KVM_CAP_ARM_RME_CREATE_REALM:
>>           r = kvm_create_realm(kvm);
>>           break;
>> +    case KVM_CAP_ARM_RME_INIT_RIPAS_REALM: {
>> +        struct arm_rme_init_ripas args;
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
>>       default:
>>           r = -EINVAL;
>>           break;
> 
> Thanks,
> Gavin
> 


