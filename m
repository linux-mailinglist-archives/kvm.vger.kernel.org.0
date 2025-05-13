Return-Path: <kvm+bounces-46339-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C220EAB5325
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 12:47:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 63B2A188BD5C
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 10:44:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03C7024167F;
	Tue, 13 May 2025 10:44:04 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 671401CCEC8;
	Tue, 13 May 2025 10:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747133043; cv=none; b=Mufhh2bfjclmi1Aml4MENIxUMnZlQOl/sWaIDmXMsd7zUXysbK8sNNc1ePTDyAv4XfIfQ2NmSSRfphP+XzCPRhXdSlpT4D/GN/rS7L38xPO0+mV5lTRI649pttpN2hmR+FqvPvOFr3T7Cvh403vMEb+tubM0L20qoXIsiXYAAfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747133043; c=relaxed/simple;
	bh=R3qN94XqLBMC350Jm9Vx7bjxVR4PE08xu34naEEs5GU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nPzJ5EgDsiiClVCrDzupmeilVyHS+KlosrY2LkUKBqkQmfjApXJ//+d9ru4+JXs9MhE9pspXNYenWEFq4+Y9seJ06raLtgRawQ7kCVNeOo5EBPx6xvXHgKK9o5xv73/oK+4H+WgtnXoP3F6oSRY42CKxAlcN9dolUEosHtt2llk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B4BEE168F;
	Tue, 13 May 2025 03:43:49 -0700 (PDT)
Received: from [10.1.35.46] (Suzukis-MBP.cambridge.arm.com [10.1.35.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 2EA723F5A1;
	Tue, 13 May 2025 03:43:57 -0700 (PDT)
Message-ID: <d0cbb637-6ba1-4858-b326-31271e9949ea@arm.com>
Date: Tue, 13 May 2025 11:43:56 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 15/43] arm64: RME: Allow VMM to set RIPAS
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
 <20250416134208.383984-16-steven.price@arm.com>
 <83071e55-cbe4-4786-b60e-d26ce16368b3@arm.com>
 <f4ee678d-112d-46d1-8b87-70e55d6617e1@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <f4ee678d-112d-46d1-8b87-70e55d6617e1@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/05/2025 15:45, Steven Price wrote:
> On 06/05/2025 14:23, Suzuki K Poulose wrote:
>> Hi Steven
>>
>> On 16/04/2025 14:41, Steven Price wrote:
>>> Each page within the protected region of the realm guest can be marked
>>> as either RAM or EMPTY. Allow the VMM to control this before the guest
>>> has started and provide the equivalent functions to change this (with
>>> the guest's approval) at runtime.
>>>
>>> When transitioning from RIPAS RAM (1) to RIPAS EMPTY (0) the memory is
>>> unmapped from the guest and undelegated allowing the memory to be reused
>>> by the host. When transitioning to RIPAS RAM the actual population of
>>> the leaf RTTs is done later on stage 2 fault, however it may be
>>> necessary to allocate additional RTTs to allow the RMM track the RIPAS
>>> for the requested range.
>>>
>>> When freeing a block mapping it is necessary to temporarily unfold the
>>> RTT which requires delegating an extra page to the RMM, this page can
>>> then be recovered once the contents of the block mapping have been
>>> freed.
>>>
>>> Signed-off-by: Steven Price <steven.price@arm.com>
>>> ---
>>> Changes from v7:
>>>    * Replace use of "only_shared" with the upstream "attr_filter" field
>>>      of struct kvm_gfn_range.
>>>    * Clean up the logic in alloc_delegated_granule() for when to call
>>>      kvm_account_pgtable_pages().
>>>    * Rename realm_destroy_protected_granule() to
>>>      realm_destroy_private_granule() to match the naming elsewhere. Also
>>>      fix the return codes in the function to be descriptive.
>>>    * Several other minor changes to names/return codes.
>>> Changes from v6:
>>>    * Split the code dealing with the guest triggering a RIPAS change into
>>>      a separate patch, so this patch is purely for the VMM setting up the
>>>      RIPAS before the guest first runs.
>>>    * Drop the useless flags argument from alloc_delegated_granule().
>>>    * Account RTTs allocated for a guest using kvm_account_pgtable_pages().
>>>    * Deal with the RMM granule size potentially being smaller than the
>>>      host's PAGE_SIZE. Although note alloc_delegated_granule() currently
>>>      still allocates an entire host page for every RMM granule (so wasting
>>>      memory when PAGE_SIZE>4k).
>>> Changes from v5:
>>>    * Adapt to rebasing.
>>>    * Introduce find_map_level()
>>>    * Rename some functions to be clearer.
>>>    * Drop the "spare page" functionality.
>>> Changes from v2:
>>>    * {alloc,free}_delegated_page() moved from previous patch to this one.
>>>    * alloc_delegated_page() now takes a gfp_t flags parameter.
>>>    * Fix the reference counting of guestmem pages to avoid leaking memory.
>>>    * Several misc code improvements and extra comments.
>>> ---
>>>    arch/arm64/include/asm/kvm_rme.h |   5 +
>>>    arch/arm64/kvm/mmu.c             |   8 +-
>>>    arch/arm64/kvm/rme.c             | 384 +++++++++++++++++++++++++++++++
>>>    3 files changed, 394 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/
>>> asm/kvm_rme.h
>>> index 9bcad6ec5dbb..b916db8565a2 100644
>>> --- a/arch/arm64/include/asm/kvm_rme.h
>>> +++ b/arch/arm64/include/asm/kvm_rme.h
>>> @@ -101,6 +101,11 @@ void kvm_realm_destroy_rtts(struct kvm *kvm, u32
>>> ia_bits);
>>>    int kvm_create_rec(struct kvm_vcpu *vcpu);
>>>    void kvm_destroy_rec(struct kvm_vcpu *vcpu);
>>>    +void kvm_realm_unmap_range(struct kvm *kvm,
>>> +               unsigned long ipa,
>>> +               unsigned long size,
>>> +               bool unmap_private);
>>> +
>>>    static inline bool kvm_realm_is_private_address(struct realm *realm,
>>>                            unsigned long addr)
>>>    {
>>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>>> index d80a9d408f71..71c04259e39f 100644
>>> --- a/arch/arm64/kvm/mmu.c
>>> +++ b/arch/arm64/kvm/mmu.c
>>> @@ -323,6 +323,7 @@ static void invalidate_icache_guest_page(void *va,
>>> size_t size)
>>>     * @start: The intermediate physical base address of the range to unmap
>>>     * @size:  The size of the area to unmap
>>>     * @may_block: Whether or not we are permitted to block
>>> + * @only_shared: If true then protected mappings should not be unmapped
>>>     *
>>>     * Clear a range of stage-2 mappings, lowering the various ref-
>>> counts.  Must
>>>     * be called while holding mmu_lock (unless for freeing the stage2
>>> pgd before
>>> @@ -330,7 +331,7 @@ static void invalidate_icache_guest_page(void *va,
>>> size_t size)
>>>     * with things behind our backs.
>>>     */
>>>    static void __unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t
>>> start, u64 size,
>>> -                 bool may_block)
>>> +                 bool may_block, bool only_shared)
>>>    {
>>>        struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
>>>        phys_addr_t end = start + size;
>>> @@ -344,7 +345,7 @@ static void __unmap_stage2_range(struct kvm_s2_mmu
>>> *mmu, phys_addr_t start, u64
>>>    void kvm_stage2_unmap_range(struct kvm_s2_mmu *mmu, phys_addr_t start,
>>>                    u64 size, bool may_block)
>>>    {
>>> -    __unmap_stage2_range(mmu, start, size, may_block);
>>> +    __unmap_stage2_range(mmu, start, size, may_block, false);
>>>    }
>>>      void kvm_stage2_flush_range(struct kvm_s2_mmu *mmu, phys_addr_t
>>> addr, phys_addr_t end)
>>> @@ -1975,7 +1976,8 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct
>>> kvm_gfn_range *range)
>>>          __unmap_stage2_range(&kvm->arch.mmu, range->start << PAGE_SHIFT,
>>>                     (range->end - range->start) << PAGE_SHIFT,
>>> -                 range->may_block);
>>> +                 range->may_block,
>>> +                 !(range->attr_filter & KVM_FILTER_PRIVATE));
>>>          kvm_nested_s2_unmap(kvm, range->may_block);
>>>        return false;
>>> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
>>> index 1239eb07aca6..33eb793d8bdb 100644
>>> --- a/arch/arm64/kvm/rme.c
>>> +++ b/arch/arm64/kvm/rme.c
>>> @@ -87,6 +87,51 @@ static int get_start_level(struct realm *realm)
>>>        return 4 - ((realm->ia_bits - 8) / (RMM_PAGE_SHIFT - 3));
>>>    }
>>>    
>>
>>> +
>>> +static phys_addr_t alloc_delegated_granule(struct
>>> kvm_mmu_memory_cache *mc)
>>> +{
>>> +    phys_addr_t phys;
>>> +    void *virt;
>>> +
>>> +    if (mc)
>>> +        virt = kvm_mmu_memory_cache_alloc(mc);
>>> +    else
>>> +        virt = (void *)__get_free_page(GFP_KERNEL_ACCOUNT);
>>> +
>>> +    if (!virt)
>>> +        return PHYS_ADDR_MAX;
>>> +
>>> +    phys = virt_to_phys(virt);
>>> +
>>> +    if (rmi_granule_delegate(phys)) {
>>> +        free_page((unsigned long)virt);
>>> +
>>> +        return PHYS_ADDR_MAX;
>>> +    }
>>> +
>>
>>
>>> +    kvm_account_pgtable_pages(virt, 1);
>>
>> Could we delay this to the place where we actually use it ? Otherwise
>> we may get the accounting wrong, if e.g, free it using
>> free_delegated_granule() ? Also, the name doesn't suggest that
>> we are allocating an rtt (though it accepts a memory_cache for rtts).
> 
> I think what I should do is provide wrappers for the RTT functions and
> move the kvm_account_pgtables_pages() to the wrappers. That would make
> it more obvious which allocations are for RTTs and hopefully avoid
> accounting errors.
> 
>>> +
>>> +    return phys;
>>> +}
>>> +
>>>    static void free_delegated_granule(phys_addr_t phys)
>>>    {
>>>        if (WARN_ON(rmi_granule_undelegate(phys))) {
>>> @@ -99,6 +144,154 @@ static void free_delegated_granule(phys_addr_t phys)
>>>        free_page((unsigned long)phys_to_virt(phys));
>>>    }
>>>    +static int realm_rtt_create(struct realm *realm,
>>> +                unsigned long addr,
>>> +                int level,
>>> +                phys_addr_t phys)
>>> +{
>>> +    addr = ALIGN_DOWN(addr, rme_rtt_level_mapsize(level - 1));
>>> +    return rmi_rtt_create(virt_to_phys(realm->rd), phys, addr, level);
>>> +}
>>> +
>>> +static int realm_rtt_fold(struct realm *realm,
>>> +              unsigned long addr,
>>> +              int level,
>>> +              phys_addr_t *rtt_granule)
>>> +{
>>> +    unsigned long out_rtt;
>>> +    int ret;
>>> +
>>> +    ret = rmi_rtt_fold(virt_to_phys(realm->rd), addr, level, &out_rtt);
>>
>> minor nit: Should we align "addr" to level - 1, similar to what we do
>> for rtt_create, just to be consistent and safer ?
> 
> Ack
> 
>>> +
>>> +    if (RMI_RETURN_STATUS(ret) == RMI_SUCCESS && rtt_granule)
>>> +        *rtt_granule = out_rtt;
>>> +
>>> +    return ret;
>>> +}
>>> +
>>> +static int realm_destroy_private_granule(struct realm *realm,
>>> +                     unsigned long ipa,
>>> +                     unsigned long *next_addr,
>>> +                     phys_addr_t *out_rtt)
>>> +{
>>> +    unsigned long rd = virt_to_phys(realm->rd);
>>> +    unsigned long rtt_addr;
>>> +    phys_addr_t rtt;
>>> +    int ret;
>>> +
>>> +retry:
>>> +    ret = rmi_data_destroy(rd, ipa, &rtt_addr, next_addr);
>>> +    if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
>>> +        if (*next_addr > ipa)
>>> +            return 0; /* UNASSIGNED */
>>> +        rtt = alloc_delegated_granule(NULL);
>>> +        if (WARN_ON(rtt == PHYS_ADDR_MAX))
>>> +            return -ENOMEM;
>>> +        /*
>>> +         * ASSIGNED - ipa is mapped as a block, so split. The index
>>> +         * from the return code should be 2 otherwise it appears
>>> +         * there's a huge page bigger than KVM currently supports
>>> +         */
>>> +        WARN_ON(RMI_RETURN_INDEX(ret) != 2);
>>> +        ret = realm_rtt_create(realm, ipa, 3, rtt);
>>> +        if (WARN_ON(ret)) {
>>
>> Can we race with another thread ? If so, we may need to do an rtt read
>> to confirm if we are safe to retry and ignore the failure.
> 
> We're holding the KVM mmu_lock (the only call path is
> realm_unmap_private_range() > realm_unmap_private_page() >
> realm_destroy_private_granule(). So we can't race with another thread
> doing the same thing.
> 
> This situation happens when there's a block mapping, so we know there
> can't be a racing thread faulting in other pages in the same RTT (as all
> the base pages are already there). So AFAICT this should never happen
> due to a race...

I see, we shouldn't see a fault as the mappings are valid. Thanks for
the clarification.

> 
> I may have missed something though ;)
> 
> I'm also a little wary of using rtt read because that in itself can be
> racy (unless we're holding a suitable lock the situation can change
> before/after the read).

Very much true. But it at least gives you some chance of a debug.

> 
>>> +            free_delegated_granule(rtt);
>>> +            return -ENXIO;
>>> +        }
>>> +        goto retry;
>>> +    } else if (WARN_ON(ret)) {
>>
>> minor nit: I am wondering, if we should add a new wrapper for warn_on,
>> which also dumps the RTT entry and the operation that caused the
>> WARNING ? Might be useful to debug and pin point issues. We have several
>> cases
>> where this might be used.
> 
> In this particular case the error is not RMI_ERROR_RTT, so the RTT
> probably isn't particularly enlightening. But I agree the default
> WARN_ON splat tends not to be informative, I'll take a look at if a
> wrapper could help.

...

>>>    void kvm_realm_destroy_rtts(struct kvm *kvm, u32 ia_bits)
>>>    {
>>>        struct realm *realm = &kvm->arch.realm;
>>> @@ -306,6 +588,96 @@ void kvm_realm_destroy_rtts(struct kvm *kvm, u32
>>> ia_bits)
>>>        WARN_ON(realm_tear_down_rtt_range(realm, 0, (1UL << ia_bits)));
>>>    }
>>>    +static void realm_unmap_private_range(struct kvm *kvm,
>>> +                      unsigned long start,
>>> +                      unsigned long end)
>>> +{
>>> +    struct realm *realm = &kvm->arch.realm;
>>> +    unsigned long next_addr, addr;
>>> +    int ret;
>>> +
>>> +    for (addr = start; addr < end; addr = next_addr) {
>>> +        ret = realm_unmap_private_page(realm, addr, &next_addr);
>>> +
>>> +        if (ret)
>>> +            break;
>>
>> Do we need yielding CPU here, similar to the shared case ? It may be
>> difficult (not impossible) to define a check point to do that.
> 
> Yes, I've already got a local change adding a "may_block" flag to the
> function so we can do a cond_resched_rwlock_write() call here when possible.

Cool, thanks.

> 
>>> +    }
>>> +
>>> +    realm_fold_rtt_level(realm, get_start_level(realm) + 1,
>>> +                 start, end);
>>
>> We don't seem to be reclaiing the RTTs from shared mapping case ?
> 
> I'm not sure I follow: realm_fold_rtt_level() will free any RTTs that
> are released.
> 
> Or are you referring to the fact that we don't (yet) fold the shared
> range? I have been purposefully leaving that for now as normally we'd

sorry it was a bit vague. We don't seem to be reclaiming the RTTs in
realm_unmap_shared_range(), like we do for the private range.


> follow the page size in the VMM to choose the page size on the guest,
> but that doesn't work when the RMM might have a different page size to
> the host. So my reasons for leaving it for later are:
> 
>   * First huge pages is very much a TODO in general.
> 
>   * When we support >4K host pages then a huge page on the host may not
>     be available in the RMM, so we can't just follow the VMM.
> 
>   * We don't have support in realm_unmap_shared_range() to split a block
>     mapping up - it could be added, but it's not clear to me if it's best
>     to split a block mapping, or remove the whole and refault as
>     required.
> 
>   * guest_memfd might well be able to provide some good hints here, but
>     we'll have to wait for that series to settle.

I am not sure I follow. None of this affects folding, once we have 
"unmapped". For that matter, we could easily DESTROY the RTTs in
shared side without unmapping, but we can do that later as an
optimisation.


> 
>>> +}
>>> +
>>> +void kvm_realm_unmap_range(struct kvm *kvm, unsigned long start,
>>> +               unsigned long size, bool unmap_private)
>>> +{
>>> +    unsigned long end = start + size;
>>> +    struct realm *realm = &kvm->arch.realm;
>>> +
>>> +    end = min(BIT(realm->ia_bits - 1), end);
>>> +
>>> +    if (realm->state == REALM_STATE_NONE)
>>> +        return;
>>> +
>>> +    realm_unmap_shared_range(kvm, find_map_level(realm, start, end),
>>> +                 start, end);
>>> +    if (unmap_private)
>>> +        realm_unmap_private_range(kvm, start, end);
>>> +}
>>> +
>>> +static int realm_init_ipa_state(struct realm *realm,
>>> +                unsigned long ipa,
>>> +                unsigned long end)
>>> +{
>>> +    phys_addr_t rd_phys = virt_to_phys(realm->rd);
>>> +    int ret;
>>> +
>>> +    while (ipa < end) {
>>> +        unsigned long next;
>>> +
>>> +        ret = rmi_rtt_init_ripas(rd_phys, ipa, end, &next);
>>> +
>>> +        if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
>>> +            int err_level = RMI_RETURN_INDEX(ret);
>>> +            int level = find_map_level(realm, ipa, end);
>>> +
>>> +            if (WARN_ON(err_level >= level))
>>
>> I am wondering if WARN_ON() is required here. A buggy VMM could trigger
>> the WARN_ON(). (e.g, INIT_IPA after POPULATE, where L3 table is
>> created.). The only case where it may be worth WARNING is if the level
>> == 3.
> 
> I have to admit I've struggled to get my head round this ;)
> 
> init_ripas will fail with ERROR_RTT in three cases:
> 
>   1. (base_align) The base address isn't aligned for the level reached.
> 
>   2. (rtt_state) The rtte state is !UNASSIGNED.
> 
>   3. (no_progress) base==walk_top - the while condition should prevent
>      this.
> 
> So I think case 1 is the case we're expecting, and creating RTTs should
> resolve it.
> 
> Case 2 is presumably the case you are concerned about, although it's not
> because tables have been created, but because INIT_RIPAS is invalid on
> areas that have been populated already.

Correct, this is the case I was referring to.

> 
> If my reading of the spec is correct, then level == 3 isn't a possible
> result, so beyond potentially finding RMM bugs I don't think a WARN for

It is almost certainly possible, with L3 page mapping created for
POPULATE and a follow up INIT_RIPAS with 2M or even 1G alignment, could
lead us to expect that only L1 or L2 is required (find_map_level) but
the RTT walk reached L3 and failed. This is not a case of RMM bug, but
a VMM not following the rules.

> that is very interesting. So for now I'll just drop the WARN_ON here
> altogether.

Thanks, that is much safer

Suzuki


