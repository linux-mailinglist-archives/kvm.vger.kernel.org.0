Return-Path: <kvm+bounces-46828-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DB7CCAB9FEE
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 17:34:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CD6EA7A5F94
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 15:32:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C22131BC099;
	Fri, 16 May 2025 15:34:04 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4566E55B;
	Fri, 16 May 2025 15:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747409644; cv=none; b=Go86Uj6SZaAkhp9uJGM1ZIIAmyhy35VRAXpCgY2qo4cgP8NHg3dZm05HkP2yKKVFg86CNTmwoYaJshGahhoJm/Abk6g4dz4a1NmqdBnU9OGRXjxx0MaXr12TrIJDFpIzhG2FH0QU3h82Z3yc9Q7E6mkd4VMcmVV/1gjDlRu/+F0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747409644; c=relaxed/simple;
	bh=P1o9YCn3aIKy/rdJkM6d2iZEhjhfCDYp+sUvlaTi2q4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T8ncb4FQnL6WLHZkqXUPhX02+bS01YqFRdr/tUDJGaVUrc58rlIch1bAsK58wSPI2CETNMzjhl8zbaGr9KyWT5KCUtDTNOIKaA/lKemjQB6XiHU/qiVrqmMfG5RhN0MqQsIFJ355qv/S7m79DPdbAmnlIfwLXC/zsGZR/nXbwnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 19047169C;
	Fri, 16 May 2025 08:33:49 -0700 (PDT)
Received: from [10.1.27.17] (e122027.cambridge.arm.com [10.1.27.17])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 821053F673;
	Fri, 16 May 2025 08:33:56 -0700 (PDT)
Message-ID: <4fca6bfa-3687-4fdf-8204-00fa90d36e2a@arm.com>
Date: Fri, 16 May 2025 16:33:54 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 20/43] arm64: RME: Runtime faulting of memory
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
 <20250416134208.383984-21-steven.price@arm.com>
 <c99b408c-3819-482a-a427-68045211e434@redhat.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <c99b408c-3819-482a-a427-68045211e434@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 01/05/2025 01:16, Gavin Shan wrote:
> On 4/16/25 11:41 PM, Steven Price wrote:
>> At runtime if the realm guest accesses memory which hasn't yet been
>> mapped then KVM needs to either populate the region or fault the guest.
>>
>> For memory in the lower (protected) region of IPA a fresh page is
>> provided to the RMM which will zero the contents. For memory in the
>> upper (shared) region of IPA, the memory from the memslot is mapped
>> into the realm VM non secure.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> Changes since v7:
>>   * Remove redundant WARN_ONs for realm_create_rtt_levels() - it will
>>     internally WARN when necessary.
>> Changes since v6:
>>   * Handle PAGE_SIZE being larger than RMM granule size.
>>   * Some minor renaming following review comments.
>> Changes since v5:
>>   * Reduce use of struct page in preparation for supporting the RMM
>>     having a different page size to the host.
>>   * Handle a race when delegating a page where another CPU has faulted on
>>     a the same page (and already delegated the physical page) but not yet
>>     mapped it. In this case simply return to the guest to either use the
>>     mapping from the other CPU (or refault if the race is lost).
>>   * The changes to populate_par_region() are moved into the previous
>>     patch where they belong.
>> Changes since v4:
>>   * Code cleanup following review feedback.
>>   * Drop the PTE_SHARED bit when creating unprotected page table entries.
>>     This is now set by the RMM and the host has no control of it and the
>>     spec requires the bit to be set to zero.
>> Changes since v2:
>>   * Avoid leaking memory if failing to map it in the realm.
>>   * Correctly mask RTT based on LPA2 flag (see rtt_get_phys()).
>>   * Adapt to changes in previous patches.
>> ---
>>   arch/arm64/include/asm/kvm_emulate.h |  10 ++
>>   arch/arm64/include/asm/kvm_rme.h     |  10 ++
>>   arch/arm64/kvm/mmu.c                 | 127 ++++++++++++++++++-
>>   arch/arm64/kvm/rme.c                 | 180 +++++++++++++++++++++++++++
>>   4 files changed, 321 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/
>> include/asm/kvm_emulate.h
>> index c803c8188d9c..def439d6d732 100644
>> --- a/arch/arm64/include/asm/kvm_emulate.h
>> +++ b/arch/arm64/include/asm/kvm_emulate.h
>> @@ -704,6 +704,16 @@ static inline bool kvm_realm_is_created(struct
>> kvm *kvm)
>>       return kvm_is_realm(kvm) && kvm_realm_state(kvm) !=
>> REALM_STATE_NONE;
>>   }
>>   +static inline gpa_t kvm_gpa_from_fault(struct kvm *kvm, phys_addr_t
>> ipa)
>> +{
>> +    if (kvm_is_realm(kvm)) {
>> +        struct realm *realm = &kvm->arch.realm;
>> +
>> +        return ipa & ~BIT(realm->ia_bits - 1);
>> +    }
>> +    return ipa;
>> +}
>> +
>>   static inline bool vcpu_is_rec(struct kvm_vcpu *vcpu)
>>   {
>>       if (static_branch_unlikely(&kvm_rme_is_available))
>> diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/
>> asm/kvm_rme.h
>> index d86051ef0c5c..47aa6362c6c9 100644
>> --- a/arch/arm64/include/asm/kvm_rme.h
>> +++ b/arch/arm64/include/asm/kvm_rme.h
>> @@ -108,6 +108,16 @@ void kvm_realm_unmap_range(struct kvm *kvm,
>>                  unsigned long ipa,
>>                  unsigned long size,
>>                  bool unmap_private);
>> +int realm_map_protected(struct realm *realm,
>> +            unsigned long base_ipa,
>> +            kvm_pfn_t pfn,
>> +            unsigned long size,
>> +            struct kvm_mmu_memory_cache *memcache);
>> +int realm_map_non_secure(struct realm *realm,
>> +             unsigned long ipa,
>> +             kvm_pfn_t pfn,
>> +             unsigned long size,
>> +             struct kvm_mmu_memory_cache *memcache);
>>     static inline bool kvm_realm_is_private_address(struct realm *realm,
>>                           unsigned long addr)
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index 71c04259e39f..02b66ee35426 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -338,8 +338,13 @@ static void __unmap_stage2_range(struct
>> kvm_s2_mmu *mmu, phys_addr_t start, u64
>>         lockdep_assert_held_write(&kvm->mmu_lock);
>>       WARN_ON(size & ~PAGE_MASK);
>> -    WARN_ON(stage2_apply_range(mmu, start, end,
>> KVM_PGT_FN(kvm_pgtable_stage2_unmap),
>> -                   may_block));
>> +
>> +    if (kvm_is_realm(kvm))
>> +        kvm_realm_unmap_range(kvm, start, size, !only_shared);
>> +    else
>> +        WARN_ON(stage2_apply_range(mmu, start, end,
>> +                       KVM_PGT_FN(kvm_pgtable_stage2_unmap),
>> +                       may_block));
>>   }
>>   
> 
> As spotted previsouly, the parameter @may_block isn't handled by
> kvm_realm_unmap_range().

Ack.

>>   void kvm_stage2_unmap_range(struct kvm_s2_mmu *mmu, phys_addr_t start,
>> @@ -359,7 +364,10 @@ static void stage2_flush_memslot(struct kvm *kvm,
>>       phys_addr_t addr = memslot->base_gfn << PAGE_SHIFT;
>>       phys_addr_t end = addr + PAGE_SIZE * memslot->npages;
>>   -    kvm_stage2_flush_range(&kvm->arch.mmu, addr, end);
>> +    if (kvm_is_realm(kvm))
>> +        kvm_realm_unmap_range(kvm, addr, end - addr, false);
>> +    else
>> +        kvm_stage2_flush_range(&kvm->arch.mmu, addr, end);
>>   }
>>     /**
>> @@ -1053,6 +1061,10 @@ void stage2_unmap_vm(struct kvm *kvm)
>>       struct kvm_memory_slot *memslot;
>>       int idx, bkt;
>>   +    /* For realms this is handled by the RMM so nothing to do here */
>> +    if (kvm_is_realm(kvm))
>> +        return;
>> +
>>       idx = srcu_read_lock(&kvm->srcu);
>>       mmap_read_lock(current->mm);
>>       write_lock(&kvm->mmu_lock);
>> @@ -1078,6 +1090,7 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
>>       if (kvm_is_realm(kvm) &&
>>           (kvm_realm_state(kvm) != REALM_STATE_DEAD &&
>>            kvm_realm_state(kvm) != REALM_STATE_NONE)) {
>> +        kvm_stage2_unmap_range(mmu, 0, (~0ULL) & PAGE_MASK, false);
>>           write_unlock(&kvm->mmu_lock);
>>           kvm_realm_destroy_rtts(kvm, pgt->ia_bits);
> 
> (~0ULL & PAGE_MASK) wouldn't be a problem since the range will be
> limited to
> [0, BIT(realm->ia_bits) - 1] in kvm_realm_unmap_range(). I think it's
> reasonable
> to pass the maximal size here, something like:
> 
>         kvm_stage2_unmap_range(mmu, 0, BIT(realm->ia_bits - 1), false);

Yes, that's probably neater. There's a WARN_ON() in
__unmap_stage2_range() otherwise I'd have just used a simple ~0ULL.

>>   @@ -1482,6 +1495,82 @@ static bool kvm_vma_mte_allowed(struct
>> vm_area_struct *vma)
>>       return vma->vm_flags & VM_MTE_ALLOWED;
>>   }
>>   +static int realm_map_ipa(struct kvm *kvm, phys_addr_t ipa,
>> +             kvm_pfn_t pfn, unsigned long map_size,
>> +             enum kvm_pgtable_prot prot,
>> +             struct kvm_mmu_memory_cache *memcache)
>> +{
>> +    struct realm *realm = &kvm->arch.realm;
>> +
>> +    if (WARN_ON(!(prot & KVM_PGTABLE_PROT_W)))
>> +        return -EFAULT;
> 
> A comment to explain why KVM_PGTABLE_PROT_W is required would be nice,
> something like:
> 
>     /*
>      * Write permission is required for now even though it's possible to
>      * map unprotected pages (granules) as read-only. It's impossible to
>      * map protected pages (granules) as read-only.
>      */

Ack.

>> +
>> +    ipa = ALIGN_DOWN(ipa, PAGE_SIZE);
>> +
>> +    if (!kvm_realm_is_private_address(realm, ipa))
>> +        return realm_map_non_secure(realm, ipa, pfn, map_size,
>> +                        memcache);
>> +
>> +    return realm_map_protected(realm, ipa, pfn, map_size, memcache);
>> +}
>> +
>> +static int private_memslot_fault(struct kvm_vcpu *vcpu,
>> +                 phys_addr_t fault_ipa,
>> +                 struct kvm_memory_slot *memslot)
>> +{
>> +    struct kvm *kvm = vcpu->kvm;
>> +    gpa_t gpa = kvm_gpa_from_fault(kvm, fault_ipa);
>> +    gfn_t gfn = gpa >> PAGE_SHIFT;
>> +    bool is_priv_gfn = kvm_mem_is_private(kvm, gfn);
>> +    struct kvm_mmu_memory_cache *memcache = &vcpu->arch.mmu_page_cache;
>> +    struct page *page;
>> +    kvm_pfn_t pfn;
>> +    int ret;
>> +    /*
>> +     * For Realms, the shared address is an alias of the private GPA
>> with
>> +     * the top bit set. Thus is the fault address matches the GPA
>> then it
>> +     * is the private alias.
>> +     */
>> +    bool is_priv_fault = (gpa == fault_ipa);
>> +
>> +    if (is_priv_gfn != is_priv_fault) {
>> +        kvm_prepare_memory_fault_exit(vcpu,
>> +                          gpa,
>> +                          PAGE_SIZE,
>> +                          kvm_is_write_fault(vcpu),
>> +                          false, is_priv_fault);
> 
> nit:
> 
>         kvm_prepare_memory_fault_exit(vcpu, gpa, PAGE_SIZE,
>                 kvm_is_write_fault(vcpu), false, is_priv_fault);

Fair enough.

>> +
>> +        /*
>> +         * KVM_EXIT_MEMORY_FAULT requires an return code of -EFAULT,
>> +         * see the API documentation
>> +         */
>> +        return -EFAULT;
>> +    }
>> +
>> +    if (!is_priv_fault) {
>> +        /* Not a private mapping, handling normally */
>> +        return -EINVAL;
>> +    }
>> +
>> +    ret = kvm_mmu_topup_memory_cache(memcache,
>> +                     kvm_mmu_cache_min_pages(vcpu->arch.hw_mmu));
>> +    if (ret)
>> +        return ret;
>> +
>> +    ret = kvm_gmem_get_pfn(kvm, memslot, gfn, &pfn, &page, NULL);
>> +    if (ret)
>> +        return ret;
>> +
>> +    /* FIXME: Should be able to use bigger than PAGE_SIZE mappings */
>> +    ret = realm_map_ipa(kvm, fault_ipa, pfn, PAGE_SIZE,
>> KVM_PGTABLE_PROT_W,
>> +                memcache);
>> +    if (!ret)
>> +        return 1; /* Handled */
>> +
>> +    put_page(page);
>> +    return ret;
>> +}
>> +
>>   static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>                 struct kvm_s2_trans *nested,
>>                 struct kvm_memory_slot *memslot, unsigned long hva,
>> @@ -1509,6 +1598,14 @@ static int user_mem_abort(struct kvm_vcpu
>> *vcpu, phys_addr_t fault_ipa,
>>       if (fault_is_perm)
>>           fault_granule = kvm_vcpu_trap_get_perm_fault_granule(vcpu);
>>       write_fault = kvm_is_write_fault(vcpu);
>> +
>> +    /*
>> +     * Realms cannot map protected pages read-only
>> +     * FIXME: It should be possible to map unprotected pages read-only
>> +     */
>> +    if (vcpu_is_rec(vcpu))
>> +        write_fault = true;
>> +
>>       exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
>>       VM_BUG_ON(write_fault && exec_fault);
>>   @@ -1623,7 +1720,7 @@ static int user_mem_abort(struct kvm_vcpu
>> *vcpu, phys_addr_t fault_ipa,
>>           ipa &= ~(vma_pagesize - 1);
>>       }
>>   -    gfn = ipa >> PAGE_SHIFT;
>> +    gfn = kvm_gpa_from_fault(kvm, ipa) >> PAGE_SHIFT;
>>       mte_allowed = kvm_vma_mte_allowed(vma);
>>         vfio_allow_any_uc = vma->vm_flags & VM_ALLOW_ANY_UNCACHED;
>> @@ -1756,6 +1853,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu,
>> phys_addr_t fault_ipa,
>>            */
>>           prot &= ~KVM_NV_GUEST_MAP_SZ;
>>           ret = KVM_PGT_FN(kvm_pgtable_stage2_relax_perms)(pgt,
>> fault_ipa, prot, flags);
>> +    } else if (kvm_is_realm(kvm)) {
>> +        ret = realm_map_ipa(kvm, fault_ipa, pfn, vma_pagesize,
>> +                    prot, memcache);
>>       } else {
>>           ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, fault_ipa,
>> vma_pagesize,
>>                            __pfn_to_phys(pfn), prot,
>> @@ -1897,8 +1997,15 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>>           nested = &nested_trans;
>>       }
>>   -    gfn = ipa >> PAGE_SHIFT;
>> +    gfn = kvm_gpa_from_fault(vcpu->kvm, ipa) >> PAGE_SHIFT;
>>       memslot = gfn_to_memslot(vcpu->kvm, gfn);
>> +
>> +    if (kvm_slot_can_be_private(memslot)) {
>> +        ret = private_memslot_fault(vcpu, ipa, memslot);
>> +        if (ret != -EINVAL)
>> +            goto out;
>> +    }
>> +
>>       hva = gfn_to_hva_memslot_prot(memslot, gfn, &writable);
>>       write_fault = kvm_is_write_fault(vcpu);
>>       if (kvm_is_error_hva(hva) || (write_fault && !writable)) {
>> @@ -1942,7 +2049,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>>            * of the page size.
>>            */
>>           ipa |= kvm_vcpu_get_hfar(vcpu) & GENMASK(11, 0);
>> -        ret = io_mem_abort(vcpu, ipa);
>> +        ret = io_mem_abort(vcpu, kvm_gpa_from_fault(vcpu->kvm, ipa));
>>           goto out_unlock;
>>       }
>>   @@ -1990,6 +2097,10 @@ bool kvm_age_gfn(struct kvm *kvm, struct
>> kvm_gfn_range *range)
>>       if (!kvm->arch.mmu.pgt)
>>           return false;
>>   +    /* We don't support aging for Realms */
>> +    if (kvm_is_realm(kvm))
>> +        return true;
>> +
>>       return KVM_PGT_FN(kvm_pgtable_stage2_test_clear_young)(kvm-
>> >arch.mmu.pgt,
>>                              range->start << PAGE_SHIFT,
>>                              size, true);
>> @@ -2006,6 +2117,10 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct
>> kvm_gfn_range *range)
>>       if (!kvm->arch.mmu.pgt)
>>           return false;
>>   +    /* We don't support aging for Realms */
>> +    if (kvm_is_realm(kvm))
>> +        return true;
>> +
>>       return KVM_PGT_FN(kvm_pgtable_stage2_test_clear_young)(kvm-
>> >arch.mmu.pgt,
>>                              range->start << PAGE_SHIFT,
>>                              size, false);
>> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
>> index f6af3ea6ea8a..b6959cd17a6c 100644
>> --- a/arch/arm64/kvm/rme.c
>> +++ b/arch/arm64/kvm/rme.c
>> @@ -714,6 +714,186 @@ static int
>> realm_create_protected_data_page(struct realm *realm,
>>       return -ENXIO;
>>   }
>>   +static int fold_rtt(struct realm *realm, unsigned long addr, int
>> level)
>> +{
>> +    phys_addr_t rtt_addr;
>> +    int ret;
>> +
>> +    ret = realm_rtt_fold(realm, addr, level, &rtt_addr);
>> +    if (ret)
>> +        return ret;
>> +
>> +    free_delegated_granule(rtt_addr);
>> +
>> +    return 0;
>> +}
>> +
>> +int realm_map_protected(struct realm *realm,
>> +            unsigned long ipa,
>> +            kvm_pfn_t pfn,
>> +            unsigned long map_size,
>> +            struct kvm_mmu_memory_cache *memcache)
>> +{
>> +    phys_addr_t phys = __pfn_to_phys(pfn);
>> +    phys_addr_t rd = virt_to_phys(realm->rd);
>> +    unsigned long base_ipa = ipa;
>> +    unsigned long size;
>> +    int map_level;
>> +    int ret = 0;
>> +
>> +    if (WARN_ON(!IS_ALIGNED(map_size, RMM_PAGE_SIZE)))
>> +        return -EINVAL;
>> +
>> +    if (WARN_ON(!IS_ALIGNED(ipa, map_size)))
>> +        return -EINVAL;
>> +
>> +    if (IS_ALIGNED(map_size, RMM_L2_BLOCK_SIZE))
>> +        map_level = 2;
>> +    else
>> +        map_level = 3;
>> +
> 
> This block of code can be compacted a bit:
> 
>     int map_level = IS_ALIGNED(map_size, RMM_L2_BLOCK_SIZE) ? 2 : 3;
> 
>     if (WARN_ON(!IS_ALIGNED(map_size, RMM_PAGE_SIZE) || !IS_ALIGNED(ipa,
> map_size))
>         return -EINVAL;

Ack

>> +    if (map_level < RMM_RTT_MAX_LEVEL) {
>> +        /*
>> +         * A temporary RTT is needed during the map, precreate it,
>> +         * however if there is an error (e.g. missing parent tables)
>> +         * this will be handled below.
>> +         */
>> +        realm_create_rtt_levels(realm, ipa, map_level,
>> +                    RMM_RTT_MAX_LEVEL, memcache);
>> +    }
>> +
>> +    for (size = 0; size < map_size; size += RMM_PAGE_SIZE) {
>> +        if (rmi_granule_delegate(phys)) {
>> +            /*
>> +             * It's likely we raced with another VCPU on the same
>> +             * fault. Assume the other VCPU has handled the fault
>> +             * and return to the guest.
>> +             */
>> +            return 0;
>> +        }
>> +
>> +        ret = rmi_data_create_unknown(rd, phys, ipa);
>> +
>> +        if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
>> +            /* Create missing RTTs and retry */
>> +            int level = RMI_RETURN_INDEX(ret);
>> +
>> +            WARN_ON(level == RMM_RTT_MAX_LEVEL);
>> +
>> +            ret = realm_create_rtt_levels(realm, ipa, level,
>> +                              RMM_RTT_MAX_LEVEL,
>> +                              memcache);
>> +            if (ret)
>> +                goto err_undelegate;
>> +
>> +            ret = rmi_data_create_unknown(rd, phys, ipa);
>> +        }
>> +
>> +        if (WARN_ON(ret))
>> +            goto err_undelegate;
>> +
>> +        phys += RMM_PAGE_SIZE;
>> +        ipa += RMM_PAGE_SIZE;
>> +    }
>> +
>> +    if (map_size == RMM_L2_BLOCK_SIZE) {
>> +        ret = fold_rtt(realm, base_ipa, map_level + 1);
>> +        if (WARN_ON(ret))
>> +            goto err;
>> +    }
>> +
>> +    return 0;
>> +
>> +err_undelegate:
>> +    if (WARN_ON(rmi_granule_undelegate(phys))) {
>> +        /* Page can't be returned to NS world so is lost */
>> +        get_page(phys_to_page(phys));
>> +    }
>> +err:
>> +    while (size > 0) {
>> +        unsigned long data, top;
>> +
>> +        phys -= RMM_PAGE_SIZE;
>> +        size -= RMM_PAGE_SIZE;
>> +        ipa -= RMM_PAGE_SIZE;
>> +
>> +        WARN_ON(rmi_data_destroy(rd, ipa, &data, &top));
>> +
>> +        if (WARN_ON(rmi_granule_undelegate(phys))) {
>> +            /* Page can't be returned to NS world so is lost */
>> +            get_page(phys_to_page(phys));
>> +        }
>> +    }
>> +    return -ENXIO;
>> +}
>> +
>> +int realm_map_non_secure(struct realm *realm,
>> +             unsigned long ipa,
>> +             kvm_pfn_t pfn,
>> +             unsigned long size,
>> +             struct kvm_mmu_memory_cache *memcache)
>> +{
>> +    phys_addr_t rd = virt_to_phys(realm->rd);
>> +    phys_addr_t phys = __pfn_to_phys(pfn);
>> +    unsigned long offset;
>> +    int map_size, map_level;
>> +    int ret = 0;
>> +
>> +    if (WARN_ON(!IS_ALIGNED(size, RMM_PAGE_SIZE)))
>> +        return -EINVAL;
>> +
>> +    if (WARN_ON(!IS_ALIGNED(ipa, size)))
>> +        return -EINVAL;
>> +
>> +    if (IS_ALIGNED(size, RMM_L2_BLOCK_SIZE)) {
>> +        map_level = 2;
>> +        map_size = RMM_L2_BLOCK_SIZE;
>> +    } else {
>> +        map_level = 3;
>> +        map_size = RMM_PAGE_SIZE;
>> +    }
>> +
> 
> Similiarly, it can be compacted a bit:
> 
>     int map_size = IS_ALIGNED(size, RMM_L2_BLOCK_SIZE) ?
> RMM_L2_BLOCK_SIZE : RMM_PAGE_SIZE;
>     int map_level = IS_ALIGNED(map_size, RMM_L2_BLOCK_SIZE) ? 2 : 3;
> 
>     if (WARN_ON(!IS_ALIGNED(size, RMM_PAGE_SIZE) || !IS_ALIGNED(ipa, size))
>         return -EINVAL;

I agree combining the WARN_ON()s makes sense. But the repeated ternary
operator just hides the map_level/map_size connection (and I'm not a big
fan of the ternary operator).

However, we do have rme_rtt_level_mapsize() which I can use to convert
the level to the size and avoid the second ternary.

>> +    for (offset = 0; offset < size; offset += map_size) {
>> +        /*
>> +         * realm_map_ipa() enforces that the memory is writable,
>> +         * so for now we permit both read and write.
>> +         */
>> +        unsigned long desc = phys |
>> +                     PTE_S2_MEMATTR(MT_S2_FWB_NORMAL) |
>> +                     KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R |
>> +                     KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
>> +        ret = rmi_rtt_map_unprotected(rd, ipa, map_level, desc);
>> +
>> +        if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
>> +            /* Create missing RTTs and retry */
>> +            int level = RMI_RETURN_INDEX(ret);
>> +
>> +            ret = realm_create_rtt_levels(realm, ipa, level,
>> +                              map_level, memcache);
>> +            if (ret)
>> +                return -ENXIO;
>> +
>> +            ret = rmi_rtt_map_unprotected(rd, ipa, map_level, desc);
>> +        }
>> +        /*
>> +         * RMI_ERROR_RTT can be reported for two reasons: either the
>> +         * RTT tables are not there, or there is an RTTE already
>> +         * present for the address.  The call to
>> +         * realm_create_rtt_levels() above handles the first case, and
>> +         * in the second case this indicates that another thread has
>> +         * already populated the RTTE for us, so we can ignore the
>> +         * error and continue.
>> +         */
>> +        if (ret && RMI_RETURN_STATUS(ret) != RMI_ERROR_RTT)
>> +            return -ENXIO;
> 
> The comments needs to be aligned in format :)
> 
> If RMM returns RMI_ERROR_RTT for third case in the future, the
> assumption here
> is broken. I think it's worthy to double confirm by checking the RTT entry
> through RTT_READ_ENTRY interface. If the mapping doesn't exist, we probably
> still need to retry.

The spec is clear on what the RMM is permitted to return error codes, so
we're safe for any conforming implementation. And (hopefully) if new
error conditions are added we can ensure that they can be distinguished
from the existing conditions. Clearly we'd have to update the code to
support new spec features.

There's a cost with doing these hypercalls. I expect there will be a
strong desire in the near future for optimisations to reduce the number
of calls and we'll see spec changes to enable it. So I've tried to avoid
"doubling checking".

And if the mapping really doesn't exist then we'd simply expect another
fault from the guest when it retries the operation that caused the fault
in the first place. So the retry logic is there (albeit in a very
expensive form).

Of course if you've spotted a condition here that I haven't thought of
then please do let me know - these paths are quite tricky to reason
about and very difficult to get meaningful testing on.

Thanks,
Steve

>> +
>> +        ipa += map_size;
>> +        phys += map_size;
>> +    }
>> +
>> +    return 0;
>> +}
>> +
>>   static int populate_region(struct kvm *kvm,
>>                  phys_addr_t ipa_base,
>>                  phys_addr_t ipa_end,
> 
> Thanks,
> Gavin
> 


