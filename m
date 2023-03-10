Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68DF86B4BC3
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 16:56:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230427AbjCJP4w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 10:56:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230294AbjCJPyR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 10:54:17 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6BD92132AAA;
        Fri, 10 Mar 2023 07:47:23 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 733641684;
        Fri, 10 Mar 2023 07:48:06 -0800 (PST)
Received: from [10.1.25.11] (e122027.cambridge.arm.com [10.1.25.11])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 67A8C3F5A1;
        Fri, 10 Mar 2023 07:47:20 -0800 (PST)
Message-ID: <554bbe2d-ead5-187d-7460-a8c03f2528fa@arm.com>
Date:   Fri, 10 Mar 2023 15:47:19 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [RFC PATCH 17/28] arm64: RME: Runtime faulting of memory
Content-Language: en-GB
To:     Zhi Wang <zhi.wang.linux@gmail.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Joey Gouly <joey.gouly@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
 <20230127112932.38045-1-steven.price@arm.com>
 <20230127112932.38045-18-steven.price@arm.com>
 <20230306202055.00000d0b@gmail.com>
From:   Steven Price <steven.price@arm.com>
In-Reply-To: <20230306202055.00000d0b@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/03/2023 18:20, Zhi Wang wrote:
> On Fri, 27 Jan 2023 11:29:21 +0000
> Steven Price <steven.price@arm.com> wrote:
> 
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
>>  arch/arm64/include/asm/kvm_emulate.h | 10 +++++
>>  arch/arm64/include/asm/kvm_rme.h     | 12 ++++++
>>  arch/arm64/kvm/mmu.c                 | 64 +++++++++++++++++++++++++---
>>  arch/arm64/kvm/rme.c                 | 48 +++++++++++++++++++++
>>  4 files changed, 128 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
>> index 285e62914ca4..3a71b3d2e10a 100644
>> --- a/arch/arm64/include/asm/kvm_emulate.h
>> +++ b/arch/arm64/include/asm/kvm_emulate.h
>> @@ -502,6 +502,16 @@ static inline enum realm_state kvm_realm_state(struct kvm *kvm)
>>  	return READ_ONCE(kvm->arch.realm.state);
>>  }
>>  
>> +static inline gpa_t kvm_gpa_stolen_bits(struct kvm *kvm)
>> +{
>> +	if (kvm_is_realm(kvm)) {
>> +		struct realm *realm = &kvm->arch.realm;
>> +
>> +		return BIT(realm->ia_bits - 1);
>> +	}
>> +	return 0;
>> +}
>> +
> 
> "stolen" seems a little bit vague. Maybe "shared" bit would be better as
> SEV-SNP has C bit and TDX has shared bit. It would be nice to align with
> the common knowledge.

The Arm CCA term is the "protected" bit[1] - although the bit is
backwards as it's cleared to indicate protected... so not ideal naming! ;)

But it's termed 'stolen' here as it's effectively removed from the set
of value address bits. And this function is returning a mask of the bits
that are not available as address bits. The naming was meant to be
generic that this could encompass other features that need to reserve
IPA bits.

But it's possible this is too generic and perhaps we should just deal
with a single bit rather than potential masks. Alternatively we could
invert this and return a set of valid bits:

static inline gpa_t kvm_gpa_valid_bits(struct kvm *kvm)
{
	if (kvm_is_realm(kvm)) {
		struct realm *realm = &kvm->arch.realm;

		return ~BIT(realm->ia_bits - 1);
	}
	return ~(gpa_t)0;
}

That would at least match the current usage where the inverse is what we
need.

So SEV-SNP or TDX have a concept of a mask to apply to addresses from
the guest? Can we steal any existing terms?


[1] Technically the spec only states: "Software in a Realm should treat
the most significant bit of an IPA as a protection attribute." I don't
think the bit is directly referred to in the spec as anything other than
"the most significant bit". Although that in itself is confusing as it
is the most significant *active* bit (i.e the configured IPA size
changes which bit is used).

> Also, it would be nice to change the name of gpa_stolen_mask accordingly.
> 
>>  static inline bool vcpu_is_rec(struct kvm_vcpu *vcpu)
>>  {
>>  	if (static_branch_unlikely(&kvm_rme_is_available))
>> diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
>> index 9d1583c44a99..303e4a5e5704 100644
>> --- a/arch/arm64/include/asm/kvm_rme.h
>> +++ b/arch/arm64/include/asm/kvm_rme.h
>> @@ -50,6 +50,18 @@ void kvm_destroy_rec(struct kvm_vcpu *vcpu);
>>  int kvm_rec_enter(struct kvm_vcpu *vcpu);
>>  int handle_rme_exit(struct kvm_vcpu *vcpu, int rec_run_status);
>>  
>> +void kvm_realm_unmap_range(struct kvm *kvm, unsigned long ipa, u64 size);
>> +int realm_map_protected(struct realm *realm,
>> +			unsigned long hva,
>> +			unsigned long base_ipa,
>> +			struct page *dst_page,
>> +			unsigned long map_size,
>> +			struct kvm_mmu_memory_cache *memcache);
>> +int realm_map_non_secure(struct realm *realm,
>> +			 unsigned long ipa,
>> +			 struct page *page,
>> +			 unsigned long map_size,
>> +			 struct kvm_mmu_memory_cache *memcache);
>>  int realm_set_ipa_state(struct kvm_vcpu *vcpu,
>>  			unsigned long addr, unsigned long end,
>>  			unsigned long ripas);
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index f29558c5dcbc..5417c273861b 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -235,8 +235,13 @@ static void __unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64
>>  
>>  	lockdep_assert_held_write(&kvm->mmu_lock);
>>  	WARN_ON(size & ~PAGE_MASK);
>> -	WARN_ON(stage2_apply_range(kvm, start, end, kvm_pgtable_stage2_unmap,
>> -				   may_block));
>> +
>> +	if (kvm_is_realm(kvm))
>> +		kvm_realm_unmap_range(kvm, start, size);
>> +	else
>> +		WARN_ON(stage2_apply_range(kvm, start, end,
>> +					   kvm_pgtable_stage2_unmap,
>> +					   may_block));
>>  }
>>  
>>  static void unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size)
>> @@ -250,7 +255,11 @@ static void stage2_flush_memslot(struct kvm *kvm,
>>  	phys_addr_t addr = memslot->base_gfn << PAGE_SHIFT;
>>  	phys_addr_t end = addr + PAGE_SIZE * memslot->npages;
>>  
>> -	stage2_apply_range_resched(kvm, addr, end, kvm_pgtable_stage2_flush);
>> +	if (kvm_is_realm(kvm))
>> +		kvm_realm_unmap_range(kvm, addr, end - addr);
>> +	else
>> +		stage2_apply_range_resched(kvm, addr, end,
>> +					   kvm_pgtable_stage2_flush);
>>  }
>>  
>>  /**
>> @@ -818,6 +827,10 @@ void stage2_unmap_vm(struct kvm *kvm)
>>  	struct kvm_memory_slot *memslot;
>>  	int idx, bkt;
>>  
>> +	/* For realms this is handled by the RMM so nothing to do here */
>> +	if (kvm_is_realm(kvm))
>> +		return;
>> +
>>  	idx = srcu_read_lock(&kvm->srcu);
>>  	mmap_read_lock(current->mm);
>>  	write_lock(&kvm->mmu_lock);
>> @@ -840,6 +853,7 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
>>  	pgt = mmu->pgt;
>>  	if (kvm_is_realm(kvm) &&
>>  	    kvm_realm_state(kvm) != REALM_STATE_DYING) {
>> +		unmap_stage2_range(mmu, 0, (~0ULL) & PAGE_MASK);
>>  		write_unlock(&kvm->mmu_lock);
>>  		kvm_realm_destroy_rtts(&kvm->arch.realm, pgt->ia_bits,
>>  				       pgt->start_level);
>> @@ -1190,6 +1204,24 @@ static bool kvm_vma_mte_allowed(struct vm_area_struct *vma)
>>  	return vma->vm_flags & VM_MTE_ALLOWED;
>>  }
>>  
>> +static int realm_map_ipa(struct kvm *kvm, phys_addr_t ipa, unsigned long hva,
>> +			 kvm_pfn_t pfn, unsigned long map_size,
>> +			 enum kvm_pgtable_prot prot,
>> +			 struct kvm_mmu_memory_cache *memcache)
>> +{
>> +	struct realm *realm = &kvm->arch.realm;
>> +	struct page *page = pfn_to_page(pfn);
>> +
>> +	if (WARN_ON(!(prot & KVM_PGTABLE_PROT_W)))
>> +		return -EFAULT;
>> +
>> +	if (!realm_is_addr_protected(realm, ipa))
>> +		return realm_map_non_secure(realm, ipa, page, map_size,
>> +					    memcache);
>> +
>> +	return realm_map_protected(realm, hva, ipa, page, map_size, memcache);
>> +}
>> +
>>  static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>  			  struct kvm_memory_slot *memslot, unsigned long hva,
>>  			  unsigned long fault_status)
>> @@ -1210,9 +1242,15 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>  	unsigned long vma_pagesize, fault_granule;
>>  	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
>>  	struct kvm_pgtable *pgt;
>> +	gpa_t gpa_stolen_mask = kvm_gpa_stolen_bits(vcpu->kvm);
>>  
>>  	fault_granule = 1UL << ARM64_HW_PGTABLE_LEVEL_SHIFT(fault_level);
>>  	write_fault = kvm_is_write_fault(vcpu);
>> +
>> +	/* Realms cannot map read-only */
> 
> Out of curiosity, why? It would be nice to have more explanation in the
> comment.

The RMM specification doesn't support mapping protected memory read
only. I don't believe there is any reason why it couldn't, but equally I
don't think there any use cases for a guest needing read-only pages so
this just isn't supported by the RMM. Since the page is necessarily
taken away from the host it's fairly irrelevant (from the host's
perspective) whether it is actually read only or not.

However, this is technically wrong for the case of unprotected (shared)
pages - it should be possible to map those read only. But I need to have
a think about how to fix that up.

>> +	if (vcpu_is_rec(vcpu))
>> +		write_fault = true;
>> +
>>  	exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
>>  	VM_BUG_ON(write_fault && exec_fault);
>>  
>> @@ -1272,7 +1310,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>  	if (vma_pagesize == PMD_SIZE || vma_pagesize == PUD_SIZE)
>>  		fault_ipa &= ~(vma_pagesize - 1);
>>  
>> -	gfn = fault_ipa >> PAGE_SHIFT;
>> +	gfn = (fault_ipa & ~gpa_stolen_mask) >> PAGE_SHIFT;
>>  	mmap_read_unlock(current->mm);
>>  
>>  	/*
>> @@ -1345,7 +1383,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>  	 * If we are not forced to use page mapping, check if we are
>>  	 * backed by a THP and thus use block mapping if possible.
>>  	 */
>> -	if (vma_pagesize == PAGE_SIZE && !(force_pte || device)) {
>> +	/* FIXME: We shouldn't need to disable this for realms */
>> +	if (vma_pagesize == PAGE_SIZE && !(force_pte || device || kvm_is_realm(kvm))) {
> 
> Why do we have to disable this temporarily?

The current uABI (not using memfd) has some serious issues regarding
huge page support. KVM normally follows the user space mappings of the
memslot - so if user space has a huge page (transparent or hugetlbs)
then stage 2 for the guest also gets one.

However realms sometimes require that the stage 2 differs. The main
examples are:

 * RIPAS - if part of a huge page is RIPAS_RAM and part RIPAS_EMPTY then
the huge page would have to be split.

 * Initially populated memory: basically the same as above - if the
populated memory doesn't perfectly align with huge pages, then the
head/tail pages would need to be broken up.

Removing this hack allows the huge pages to be created in stage 2, but
then causes overmapping of the initial contents, then later on when the
VMM (or guest) attempts to change the properties of the misaligned tail
it gets an error because the pages are already present in stage 2.

The planned solution to all this is to stop following the user space
page tables and create huge pages opportunistically from the memfd that
backs the protected range. For now this hack exists to avoid things
"randomly" failing when e.g. the initial kernel image isn't huge page
aligned. In theory it should be possible to make this work with the
current uABI, but it's not worth it when we know we're replacing it.

>>  		if (fault_status == FSC_PERM && fault_granule > PAGE_SIZE)
>>  			vma_pagesize = fault_granule;
>>  		else
>> @@ -1382,6 +1421,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>  	 */
>>  	if (fault_status == FSC_PERM && vma_pagesize == fault_granule)
>>  		ret = kvm_pgtable_stage2_relax_perms(pgt, fault_ipa, prot);
>> +	else if (kvm_is_realm(kvm))
>> +		ret = realm_map_ipa(kvm, fault_ipa, hva, pfn, vma_pagesize,
>> +				    prot, memcache);
>>  	else
>>  		ret = kvm_pgtable_stage2_map(pgt, fault_ipa, vma_pagesize,
>>  					     __pfn_to_phys(pfn), prot,
>> @@ -1437,6 +1479,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>>  	struct kvm_memory_slot *memslot;
>>  	unsigned long hva;
>>  	bool is_iabt, write_fault, writable;
>> +	gpa_t gpa_stolen_mask = kvm_gpa_stolen_bits(vcpu->kvm);
>>  	gfn_t gfn;
>>  	int ret, idx;
>>  
>> @@ -1491,7 +1534,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>>  
>>  	idx = srcu_read_lock(&vcpu->kvm->srcu);
>>  
>> -	gfn = fault_ipa >> PAGE_SHIFT;
>> +	gfn = (fault_ipa & ~gpa_stolen_mask) >> PAGE_SHIFT;
>>  	memslot = gfn_to_memslot(vcpu->kvm, gfn);
>>  	hva = gfn_to_hva_memslot_prot(memslot, gfn, &writable);
>>  	write_fault = kvm_is_write_fault(vcpu);
>> @@ -1536,6 +1579,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>>  		 * of the page size.
>>  		 */
>>  		fault_ipa |= kvm_vcpu_get_hfar(vcpu) & ((1 << 12) - 1);
>> +		fault_ipa &= ~gpa_stolen_mask;
>>  		ret = io_mem_abort(vcpu, fault_ipa);
>>  		goto out_unlock;
>>  	}
>> @@ -1617,6 +1661,10 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>>  	if (!kvm->arch.mmu.pgt)
>>  		return false;
>>
> 
> Does the unprotected (shared) region of a realm support aging?

In theory this should be possible to support by unmapping the NS entry
and handling the fault. But the hardware access flag optimisation isn't
available with the RMM, and the overhead of RMI calls to unmap/map could
be significant.

For now this isn't something we've looked at, but I guess it might be
worth trying out when we have some real hardware to benchmark on.

>> +	/* We don't support aging for Realms */
>> +	if (kvm_is_realm(kvm))
>> +		return true;
>> +
>>  	WARN_ON(size != PAGE_SIZE && size != PMD_SIZE && size != PUD_SIZE);
>>  
>>  	kpte = kvm_pgtable_stage2_mkold(kvm->arch.mmu.pgt,
>> @@ -1630,6 +1678,10 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>>  	if (!kvm->arch.mmu.pgt)
>>  		return false;
>>  
>> +	/* We don't support aging for Realms */
>> +	if (kvm_is_realm(kvm))
>> +		return true;
>> +
>>  	return kvm_pgtable_stage2_is_young(kvm->arch.mmu.pgt,
>>  					   range->start << PAGE_SHIFT);
>>  }
>> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
>> index 3405b43e1421..3d46191798e5 100644
>> --- a/arch/arm64/kvm/rme.c
>> +++ b/arch/arm64/kvm/rme.c
>> @@ -608,6 +608,54 @@ int realm_map_protected(struct realm *realm,
>>  	return -ENXIO;
>>  }
>>  
>> +int realm_map_non_secure(struct realm *realm,
>> +			 unsigned long ipa,
>> +			 struct page *page,
>> +			 unsigned long map_size,
>> +			 struct kvm_mmu_memory_cache *memcache)
>> +{
>> +	phys_addr_t rd = virt_to_phys(realm->rd);
>> +	int map_level;
>> +	int ret = 0;
>> +	unsigned long desc = page_to_phys(page) |
>> +			     PTE_S2_MEMATTR(MT_S2_FWB_NORMAL) |
>> +			     /* FIXME: Read+Write permissions for now */
> Why can't we handle the prot from the realm_map_ipa()? Working in progress? :)

Yes, work in progress - this comes from the "Realms cannot map
read-only" in user_mem_abort() above. Since all faults are treated as
write faults we need to upgrade to read/write here too.

The prot in realm_map_ipa isn't actually useful currently because we
simply WARN_ON and return if it doesn't have PROT_W. Again this needs to
be fixed! It's on my todo list ;)

Steve

>> +			     (3 << 6) |
>> +			     PTE_SHARED;
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
>> +	ret = rmi_rtt_map_unprotected(rd, ipa, map_level, desc);
>> +
>> +	if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
>> +		/* Create missing RTTs and retry */
>> +		int level = RMI_RETURN_INDEX(ret);
>> +
>> +		ret = realm_create_rtt_levels(realm, ipa, level, map_level,
>> +					      memcache);
>> +		if (WARN_ON(ret))
>> +			return -ENXIO;
>> +
>> +		ret = rmi_rtt_map_unprotected(rd, ipa, map_level, desc);
>> +	}
>> +	if (WARN_ON(ret))
>> +		return -ENXIO;
>> +
>> +	return 0;
>> +}
>> +
>>  static int populate_par_region(struct kvm *kvm,
>>  			       phys_addr_t ipa_base,
>>  			       phys_addr_t ipa_end)
> 

