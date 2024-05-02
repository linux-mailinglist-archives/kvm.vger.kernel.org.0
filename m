Return-Path: <kvm+bounces-16409-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A64E78B98A4
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 12:17:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CA764B212AA
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 10:17:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD2B45812B;
	Thu,  2 May 2024 10:17:03 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D04C156440;
	Thu,  2 May 2024 10:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714645023; cv=none; b=FRXEcPb9Q6s+FEBS8MLAatSXQnkCA+cBF+DhKSnS6M4o2NNjxz7UjQxu8+TJlqzTMUNgh0qSmsvvZ7qjybShdcNTIJsp69J1ivCQvK7E5Rxjy4/qJhbxxDAZCIrbRLFp56mOeE+yzXDMeW/lzpskol1pO2Cs0HsDeyCRJA2F0gI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714645023; c=relaxed/simple;
	bh=s66TcP7sDfUVV9MW/afp3T9duv+GA/uOVOZWsntuYLg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rBfMU2WDaDi/iOdruxa79B8xmyNWaiknDQSCbCg3FgzaOdKsjfBiMRHohiIZ4FYCU19uHfM5W629H24jr+hZoo23JHnw+3MgOMYIB/pZR+ljSB5EkCGAeeIUjMcmDs8WtwKxvCrserXTX98pwMgYL4+vmDgVgombaSlfBq4nBdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CC7B62F4;
	Thu,  2 May 2024 03:17:25 -0700 (PDT)
Received: from [10.1.197.1] (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D8E5F3F793;
	Thu,  2 May 2024 03:16:57 -0700 (PDT)
Message-ID: <85a4bbda-4516-4c2a-ae51-5e8f8c451e3a@arm.com>
Date: Thu, 2 May 2024 11:16:56 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 17/43] arm64: RME: Allow VMM to set RIPAS
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
 <20240412084309.1733783-18-steven.price@arm.com>
 <d2957090-fcf0-4dff-901e-d8ea975f2452@arm.com>
 <98ef5e64-2d1e-4fa2-a3da-210ea180f20f@arm.com>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <98ef5e64-2d1e-4fa2-a3da-210ea180f20f@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 01/05/2024 16:47, Steven Price wrote:
> On 19/04/2024 10:34, Suzuki K Poulose wrote:
>> On 12/04/2024 09:42, Steven Price wrote:
>>> Each page within the protected region of the realm guest can be marked
>>> as either RAM or EMPTY. Allow the VMM to control this before the guest
>>> has started and provide the equivalent functions to change this (with
>>> the guest's approval) at runtime.
>>>
>>> When transitioning from RIPAS RAM (1) to RIPAS EMPTY (0) the memory is
>>> unmapped from the guest and undelegated allowing the memory to be reused
>>> by the host. When transitioning to RIPAS RAM the actual population of
>>> the leaf RTTs is done later on stage 2 fault, however it may be
>>> necessary to allocate additional RTTs to represent the range requested.
>>
>> minor nit: To give a bit more context:
>>
>> "however it may be necessary to allocate additional RTTs in order for
>> the RMM to track the RIPAS for the requested range".
> 
> That is what I meant - but your wording is probably clearer ;)
> Technically there's also the case where a RIPAS change will cause a
> block mapping to be split which isn't just about tracking RIPAS but also
> about breaking up the block mapping for the pages that remain.
> 
>>>
>>> When freeing a block mapping it is necessary to temporarily unfold the
>>> RTT which requires delegating an extra page to the RMM, this page can
>>> then be recovered once the contents of the block mapping have been
>>> freed. A spare, delegated page (spare_page) is used for this purpose.
>>>
>>> Signed-off-by: Steven Price <steven.price@arm.com>
>>> ---
>>>    arch/arm64/include/asm/kvm_rme.h |  16 ++
>>>    arch/arm64/kvm/mmu.c             |   8 +-
>>>    arch/arm64/kvm/rme.c             | 390 +++++++++++++++++++++++++++++++
>>>    3 files changed, 411 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/arch/arm64/include/asm/kvm_rme.h
>>> b/arch/arm64/include/asm/kvm_rme.h
>>> index 915e76068b00..cc8f81cfc3c0 100644
>>> --- a/arch/arm64/include/asm/kvm_rme.h
>>> +++ b/arch/arm64/include/asm/kvm_rme.h
>>> @@ -96,6 +96,14 @@ void kvm_realm_destroy_rtts(struct kvm *kvm, u32
>>> ia_bits);
>>>    int kvm_create_rec(struct kvm_vcpu *vcpu);
>>>    void kvm_destroy_rec(struct kvm_vcpu *vcpu);
>>>    +void kvm_realm_unmap_range(struct kvm *kvm,
>>> +               unsigned long ipa,
>>> +               u64 size,
>>> +               bool unmap_private);
>>> +int realm_set_ipa_state(struct kvm_vcpu *vcpu,
>>> +            unsigned long addr, unsigned long end,
>>> +            unsigned long ripas);
>>> +
>>>    #define RME_RTT_BLOCK_LEVEL    2
>>>    #define RME_RTT_MAX_LEVEL    3
>>>    @@ -114,4 +122,12 @@ static inline unsigned long
>>> rme_rtt_level_mapsize(int level)
>>>        return (1UL << RME_RTT_LEVEL_SHIFT(level));
>>>    }
>>>    +static inline bool realm_is_addr_protected(struct realm *realm,
>>> +                       unsigned long addr)
>>> +{
>>> +    unsigned int ia_bits = realm->ia_bits;
>>> +
>>> +    return !(addr & ~(BIT(ia_bits - 1) - 1));
>>> +}
>>> +
>>>    #endif
>>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>>> index 46f0c4e80ace..8a7b5449697f 100644
>>> --- a/arch/arm64/kvm/mmu.c
>>> +++ b/arch/arm64/kvm/mmu.c
>>> @@ -310,6 +310,7 @@ static void invalidate_icache_guest_page(void *va,
>>> size_t size)
>>>     * @start: The intermediate physical base address of the range to unmap
>>>     * @size:  The size of the area to unmap
>>>     * @may_block: Whether or not we are permitted to block
>>> + * @only_shared: If true then protected mappings should not be unmapped
>>>     *
>>>     * Clear a range of stage-2 mappings, lowering the various
>>> ref-counts.  Must
>>>     * be called while holding mmu_lock (unless for freeing the stage2
>>> pgd before
>>> @@ -317,7 +318,7 @@ static void invalidate_icache_guest_page(void *va,
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
>>> @@ -330,7 +331,7 @@ static void __unmap_stage2_range(struct kvm_s2_mmu
>>> *mmu, phys_addr_t start, u64
>>>      static void unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t
>>> start, u64 size)
>>>    {
>>> -    __unmap_stage2_range(mmu, start, size, true);
>>> +    __unmap_stage2_range(mmu, start, size, true, false);
>>>    }
>>>      static void stage2_flush_memslot(struct kvm *kvm,
>>> @@ -1771,7 +1772,8 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct
>>> kvm_gfn_range *range)
>>>          __unmap_stage2_range(&kvm->arch.mmu, range->start << PAGE_SHIFT,
>>>                     (range->end - range->start) << PAGE_SHIFT,
>>> -                 range->may_block);
>>> +                 range->may_block,
>>> +                 range->only_shared);
>>>          return false;
>>>    }
>>> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
>>> index 629a095bea61..9e5983c51393 100644
>>> --- a/arch/arm64/kvm/rme.c
>>> +++ b/arch/arm64/kvm/rme.c
>>> @@ -79,6 +79,12 @@ static phys_addr_t __alloc_delegated_page(struct
>>> realm *realm,
>>>        return phys;
>>>    }
>>>    +static phys_addr_t alloc_delegated_page(struct realm *realm,
>>> +                    struct kvm_mmu_memory_cache *mc)
>>> +{
>>> +    return __alloc_delegated_page(realm, mc, GFP_KERNEL);
>>> +}
>>> +
>>>    static void free_delegated_page(struct realm *realm, phys_addr_t phys)
>>>    {
>>>        if (realm->spare_page == PHYS_ADDR_MAX) {
>>> @@ -94,6 +100,151 @@ static void free_delegated_page(struct realm
>>> *realm, phys_addr_t phys)
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
>>> +
>>> +    if (RMI_RETURN_STATUS(ret) == RMI_SUCCESS && rtt_granule)
>>> +        *rtt_granule = out_rtt;
>>> +
>>> +    return ret;
>>> +}
>>> +
>>> +static int realm_destroy_protected(struct realm *realm,
>>> +                   unsigned long ipa,
>>> +                   unsigned long *next_addr)
>>> +{
>>> +    unsigned long rd = virt_to_phys(realm->rd);
>>> +    unsigned long addr;
>>> +    phys_addr_t rtt;
>>> +    int ret;
>>> +
>>> +loop:
>>> +    ret = rmi_data_destroy(rd, ipa, &addr, next_addr);
>>> +    if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
>>> +        if (*next_addr > ipa)
>>> +            return 0; /* UNASSIGNED */
>>> +        rtt = alloc_delegated_page(realm, NULL);
>>> +        if (WARN_ON(rtt == PHYS_ADDR_MAX))
>>> +            return -1;
>>> +        /* ASSIGNED - ipa is mapped as a block, so split */
>>> +        ret = realm_rtt_create(realm, ipa,
>>> +                       RMI_RETURN_INDEX(ret) + 1, rtt);
>>
>> Could we not go all the way to L3 (rather than 1 level deeper) and try
>> again ? That way, we are covered for block mappings at L1 (1G).
> 
> I don't think this situation can happen. The spec states that for
> RMI_ERROR_RTT either top>ipa (UNASSIGNED, in which case we've bailed out
> above) or top==ipa (ASSIGNED) in which case RMI_RETURN_INDEX(ret) must
> equal 2.

It could be 1 as RMM spec allows Block mapping at L1. But if we don't
fold to that level in KVM, the current code may be fine.

> 
> So in this case realm_rtt_create() will always be called with level=3.
> 
> I can simplify this by explicitly passing 3 and adding a WARN_ON() for
> RMI_RETURN_INDEX(ret) != 2.

Yes please, if we don't fold all the way up to L1.

Thanks
Suzuki



