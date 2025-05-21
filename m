Return-Path: <kvm+bounces-47243-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B4B17ABEEA8
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 10:56:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DB5741BA5D3D
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 08:56:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F67B23817A;
	Wed, 21 May 2025 08:55:54 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AB9221FF55;
	Wed, 21 May 2025 08:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747817754; cv=none; b=ubvPeTbGSmZjtt28EBZsPGBnR1grOYWwhidMrbQDzQjBT4bs+jpiF0zQD8/8wg9mtNM+MpngcBs5fa9Ae6ZhmJtI4rXfhStAIBNpA3LQTN5cJmRv5yGpu02yw9iECaJZQ24v3ItT8Ton/+NqekJI6GdzaH5Db4rxv0AigMJddUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747817754; c=relaxed/simple;
	bh=J3eT9enofDeXnYSzoWheHzHJjQzB95yLnnDDVWBQ5Jc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OcVX2e7ibNC4ZpfOMhH0NPqVZzKMV5taJ3rDoVyslsnKlyJGqONUWDCPvpxe1g/fq+MfTwtfvJeVTQdH9Wr24KvQ8e4XnBgvRpeKGFsfur+AhYSHdELrtbAFlg3ISQiluFxw58zj2ar48V+A1ffRiCxaGmXKUFh6QMDLmVnXU7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CE4E71515;
	Wed, 21 May 2025 01:55:36 -0700 (PDT)
Received: from [10.57.23.70] (unknown [10.57.23.70])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4864A3F6A8;
	Wed, 21 May 2025 01:55:46 -0700 (PDT)
Message-ID: <c544b3fe-3cf2-4dcd-8c0f-ab9f1795e305@arm.com>
Date: Wed, 21 May 2025 09:55:43 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 20/43] arm64: RME: Runtime faulting of memory
To: Suzuki K Poulose <suzuki.poulose@arm.com>, Gavin Shan <gshan@redhat.com>,
 kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20250416134208.383984-1-steven.price@arm.com>
 <20250416134208.383984-21-steven.price@arm.com>
 <c99b408c-3819-482a-a427-68045211e434@redhat.com>
 <4fca6bfa-3687-4fdf-8204-00fa90d36e2a@arm.com>
 <d1b3caaf-636f-48e6-90e6-0bb650753748@arm.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <d1b3caaf-636f-48e6-90e6-0bb650753748@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 20/05/2025 15:48, Suzuki K Poulose wrote:
> On 16/05/2025 16:33, Steven Price wrote:
>> On 01/05/2025 01:16, Gavin Shan wrote:
>>> On 4/16/25 11:41 PM, Steven Price wrote:
>>>> At runtime if the realm guest accesses memory which hasn't yet been
>>>> mapped then KVM needs to either populate the region or fault the guest.
>>>>
>>>> For memory in the lower (protected) region of IPA a fresh page is
>>>> provided to the RMM which will zero the contents. For memory in the
>>>> upper (shared) region of IPA, the memory from the memslot is mapped
>>>> into the realm VM non secure.
>>>>
>>>> Signed-off-by: Steven Price <steven.price@arm.com>
>>>> ---
>>>> Changes since v7:
>>>>    * Remove redundant WARN_ONs for realm_create_rtt_levels() - it will
>>>>      internally WARN when necessary.
>>>> Changes since v6:
>>>>    * Handle PAGE_SIZE being larger than RMM granule size.
>>>>    * Some minor renaming following review comments.
>>>> Changes since v5:
>>>>    * Reduce use of struct page in preparation for supporting the RMM
>>>>      having a different page size to the host.
>>>>    * Handle a race when delegating a page where another CPU has
>>>> faulted on
>>>>      a the same page (and already delegated the physical page) but
>>>> not yet
>>>>      mapped it. In this case simply return to the guest to either
>>>> use the
>>>>      mapping from the other CPU (or refault if the race is lost).
>>>>    * The changes to populate_par_region() are moved into the previous
>>>>      patch where they belong.
>>>> Changes since v4:
>>>>    * Code cleanup following review feedback.
>>>>    * Drop the PTE_SHARED bit when creating unprotected page table
>>>> entries.
>>>>      This is now set by the RMM and the host has no control of it
>>>> and the
>>>>      spec requires the bit to be set to zero.
>>>> Changes since v2:
>>>>    * Avoid leaking memory if failing to map it in the realm.
>>>>    * Correctly mask RTT based on LPA2 flag (see rtt_get_phys()).
>>>>    * Adapt to changes in previous patches.
>>>> ---
>>>>    arch/arm64/include/asm/kvm_emulate.h |  10 ++
>>>>    arch/arm64/include/asm/kvm_rme.h     |  10 ++
>>>>    arch/arm64/kvm/mmu.c                 | 127 ++++++++++++++++++-
>>>>    arch/arm64/kvm/rme.c                 | 180 ++++++++++++++++++++++
>>>> +++++
>>>>    4 files changed, 321 insertions(+), 6 deletions(-)
>>>>
>>>> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/
>>>> include/asm/kvm_emulate.h
>>>> index c803c8188d9c..def439d6d732 100644
>>>> --- a/arch/arm64/include/asm/kvm_emulate.h
>>>> +++ b/arch/arm64/include/asm/kvm_emulate.h
>>>> @@ -704,6 +704,16 @@ static inline bool kvm_realm_is_created(struct
>>>> kvm *kvm)
>>>>        return kvm_is_realm(kvm) && kvm_realm_state(kvm) !=
>>>> REALM_STATE_NONE;
>>>>    }
>>>>    +static inline gpa_t kvm_gpa_from_fault(struct kvm *kvm, phys_addr_t
>>>> ipa)
>>>> +{
>>>> +    if (kvm_is_realm(kvm)) {
>>>> +        struct realm *realm = &kvm->arch.realm;
>>>> +
>>>> +        return ipa & ~BIT(realm->ia_bits - 1);
>>>> +    }
>>>> +    return ipa;
>>>> +}
>>>> +
>>>>    static inline bool vcpu_is_rec(struct kvm_vcpu *vcpu)
>>>>    {
>>>>        if (static_branch_unlikely(&kvm_rme_is_available))
>>>> diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/
>>>> asm/kvm_rme.h
>>>> index d86051ef0c5c..47aa6362c6c9 100644
>>>> --- a/arch/arm64/include/asm/kvm_rme.h
>>>> +++ b/arch/arm64/include/asm/kvm_rme.h
>>>> @@ -108,6 +108,16 @@ void kvm_realm_unmap_range(struct kvm *kvm,
>>>>                   unsigned long ipa,
>>>>                   unsigned long size,
>>>>                   bool unmap_private);
>>>> +int realm_map_protected(struct realm *realm,
>>>> +            unsigned long base_ipa,
>>>> +            kvm_pfn_t pfn,
>>>> +            unsigned long size,
>>>> +            struct kvm_mmu_memory_cache *memcache);
>>>> +int realm_map_non_secure(struct realm *realm,
>>>> +             unsigned long ipa,
>>>> +             kvm_pfn_t pfn,
>>>> +             unsigned long size,
>>>> +             struct kvm_mmu_memory_cache *memcache);
>>>>      static inline bool kvm_realm_is_private_address(struct realm
>>>> *realm,
>>>>                            unsigned long addr)
>>>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>>>> index 71c04259e39f..02b66ee35426 100644
>>>> --- a/arch/arm64/kvm/mmu.c
>>>> +++ b/arch/arm64/kvm/mmu.c
>>>> @@ -338,8 +338,13 @@ static void __unmap_stage2_range(struct
>>>> kvm_s2_mmu *mmu, phys_addr_t start, u64
>>>>          lockdep_assert_held_write(&kvm->mmu_lock);
>>>>        WARN_ON(size & ~PAGE_MASK);
>>>> -    WARN_ON(stage2_apply_range(mmu, start, end,
>>>> KVM_PGT_FN(kvm_pgtable_stage2_unmap),
>>>> -                   may_block));
>>>> +
>>>> +    if (kvm_is_realm(kvm))
>>>> +        kvm_realm_unmap_range(kvm, start, size, !only_shared);
>>>> +    else
>>>> +        WARN_ON(stage2_apply_range(mmu, start, end,
>>>> +                       KVM_PGT_FN(kvm_pgtable_stage2_unmap),
>>>> +                       may_block));
>>>>    }
>>>>    
>>>
>>> As spotted previsouly, the parameter @may_block isn't handled by
>>> kvm_realm_unmap_range().
>>
>> Ack.
>>
>>>>    void kvm_stage2_unmap_range(struct kvm_s2_mmu *mmu, phys_addr_t
>>>> start,
>>>> @@ -359,7 +364,10 @@ static void stage2_flush_memslot(struct kvm *kvm,
>>>>        phys_addr_t addr = memslot->base_gfn << PAGE_SHIFT;
>>>>        phys_addr_t end = addr + PAGE_SIZE * memslot->npages;
>>>>    -    kvm_stage2_flush_range(&kvm->arch.mmu, addr, end);
>>>> +    if (kvm_is_realm(kvm))
>>>> +        kvm_realm_unmap_range(kvm, addr, end - addr, false);
>>>> +    else
>>>> +        kvm_stage2_flush_range(&kvm->arch.mmu, addr, end);
>>>>    }
>>>>      /**
>>>> @@ -1053,6 +1061,10 @@ void stage2_unmap_vm(struct kvm *kvm)
>>>>        struct kvm_memory_slot *memslot;
>>>>        int idx, bkt;
>>>>    +    /* For realms this is handled by the RMM so nothing to do
>>>> here */
>>>> +    if (kvm_is_realm(kvm))
>>>> +        return;
>>>> +
>>>>        idx = srcu_read_lock(&kvm->srcu);
>>>>        mmap_read_lock(current->mm);
>>>>        write_lock(&kvm->mmu_lock);
>>>> @@ -1078,6 +1090,7 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
>>>>        if (kvm_is_realm(kvm) &&
>>>>            (kvm_realm_state(kvm) != REALM_STATE_DEAD &&
>>>>             kvm_realm_state(kvm) != REALM_STATE_NONE)) {
>>>> +        kvm_stage2_unmap_range(mmu, 0, (~0ULL) & PAGE_MASK, false);
>>>>            write_unlock(&kvm->mmu_lock);
>>>>            kvm_realm_destroy_rtts(kvm, pgt->ia_bits);
>>>
>>> (~0ULL & PAGE_MASK) wouldn't be a problem since the range will be
>>> limited to
>>> [0, BIT(realm->ia_bits) - 1] in kvm_realm_unmap_range(). I think it's
>>> reasonable
>>> to pass the maximal size here, something like:
>>>
>>>          kvm_stage2_unmap_range(mmu, 0, BIT(realm->ia_bits - 1), false);
> 
> I think this must be, given the end is excluding:
>        kvm_stage2_unmap_range(mmu, 0, BIT(realm->ia_bits), false);
> 
> BIT(realm->ia_bits - 1) only covers the protected half. The unprotected
> half spans  [ BIT(realm->ia_bits - 1), BIT(realm->ia_bits))

The kernel treats the two halves as aliasing. kvm_realm_unmap_range()
caps the end to min(BIT(realm->ia_bits - 1), end). So this wouldn't make
any difference.

This an unfortunate outcome of the memory slots describing both the
protected region (via guestmem_fd) and the shared region (via VMM maps).
So a single memslot describes two regions which leads to the kernel
treating those regions as aliasing for some purposes.

Thanks,
Steve


