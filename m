Return-Path: <kvm+bounces-29644-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E03409AE702
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 15:52:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 67C471F25045
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 13:52:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4EF51E130F;
	Thu, 24 Oct 2024 13:52:01 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBFF850285;
	Thu, 24 Oct 2024 13:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729777921; cv=none; b=KoxJcw3qXSSSP1q01WHUcMVsKUv7o2VrUjfE9/TQsSksZd6X4Y0F5jAbyw921J7JpzfZiOWBz+AnpZu25DCO/vTYly/eXtXdAoYj5ZS9HhPUBfm/ui6u6F3HfKgKWq0B8hiySBd6309OjLLJUmOdXfABNeaBD/Dabgxxyre9UrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729777921; c=relaxed/simple;
	bh=Cjch77xdbZxDDCQaHpimwUOeniXMA+BKSIB/mjPXNl4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fZJzUAgMCvddxEhfNYzWihGBbzKCcN+QTIevGusQ8iK4Xd06y1hgu+8p/t1OqH3t+K3GPepUBdQEqIFmsDxuA5h4m0nr0fYF3xelYcoNSYiwSq0plkpE2M6+vds1Y5Lw8fkNOFMOaXLhi7419nj+80yLaVN2wNI87yCRLR0mSKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C46DB339;
	Thu, 24 Oct 2024 06:52:25 -0700 (PDT)
Received: from [10.1.197.1] (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5C9A23F528;
	Thu, 24 Oct 2024 06:51:53 -0700 (PDT)
Message-ID: <d5c0fd3c-b735-4621-a563-a90149ed8cc5@arm.com>
Date: Thu, 24 Oct 2024 14:51:51 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 21/43] arm64: RME: Runtime faulting of memory
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
References: <20241004152804.72508-1-steven.price@arm.com>
 <20241004152804.72508-22-steven.price@arm.com>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20241004152804.72508-22-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 04/10/2024 16:27, Steven Price wrote:
> At runtime if the realm guest accesses memory which hasn't yet been
> mapped then KVM needs to either populate the region or fault the guest.
> 
> For memory in the lower (protected) region of IPA a fresh page is
> provided to the RMM which will zero the contents. For memory in the
> upper (shared) region of IPA, the memory from the memslot is mapped
> into the realm VM non secure.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v4:
>   * Code cleanup following review feedback.
>   * Drop the PTE_SHARED bit when creating unprotected page table entries.
>     This is now set by the RMM and the host has no control of it and the
>     spec requires the bit to be set to zero.
> Changes since v2:
>   * Avoid leaking memory if failing to map it in the realm.
>   * Correctly mask RTT based on LPA2 flag (see rtt_get_phys()).
>   * Adapt to changes in previous patches.
> ---
>   arch/arm64/include/asm/kvm_emulate.h |  10 ++
>   arch/arm64/include/asm/kvm_rme.h     |  10 ++
>   arch/arm64/kvm/mmu.c                 | 124 +++++++++++++++-
>   arch/arm64/kvm/rme.c                 | 205 +++++++++++++++++++++++++--
>   4 files changed, 328 insertions(+), 21 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index 7430c77574e3..fa03520d7933 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -710,6 +710,16 @@ static inline bool kvm_realm_is_created(struct kvm *kvm)
>   	return kvm_is_realm(kvm) && kvm_realm_state(kvm) != REALM_STATE_NONE;
>   }
>   
> +static inline gpa_t kvm_gpa_from_fault(struct kvm *kvm, phys_addr_t fault_ipa)
> +{
> +	if (kvm_is_realm(kvm)) {
> +		struct realm *realm = &kvm->arch.realm;
> +
> +		return fault_ipa & ~BIT(realm->ia_bits - 1);
> +	}
> +	return fault_ipa;
> +}
> +
>   static inline bool vcpu_is_rec(struct kvm_vcpu *vcpu)
>   {
>   	if (static_branch_unlikely(&kvm_rme_is_available))
> diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
> index 889fe120283a..b8e6f8e7a5e5 100644
> --- a/arch/arm64/include/asm/kvm_rme.h
> +++ b/arch/arm64/include/asm/kvm_rme.h
> @@ -103,6 +103,16 @@ void kvm_realm_unmap_range(struct kvm *kvm,
>   			   unsigned long ipa,
>   			   u64 size,
>   			   bool unmap_private);
> +int realm_map_protected(struct realm *realm,
> +			unsigned long base_ipa,
> +			struct page *dst_page,
> +			unsigned long map_size,
> +			struct kvm_mmu_memory_cache *memcache);
> +int realm_map_non_secure(struct realm *realm,
> +			 unsigned long ipa,
> +			 struct page *page,
> +			 unsigned long map_size,
> +			 struct kvm_mmu_memory_cache *memcache);
>   int realm_set_ipa_state(struct kvm_vcpu *vcpu,
>   			unsigned long addr, unsigned long end,
>   			unsigned long ripas,
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 23346b1d29cb..1c78738a2645 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -325,8 +325,13 @@ static void __unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64
>   
>   	lockdep_assert_held_write(&kvm->mmu_lock);
>   	WARN_ON(size & ~PAGE_MASK);
> -	WARN_ON(stage2_apply_range(mmu, start, end, kvm_pgtable_stage2_unmap,
> -				   may_block));
> +
> +	if (kvm_is_realm(kvm))
> +		kvm_realm_unmap_range(kvm, start, size, !only_shared);
> +	else
> +		WARN_ON(stage2_apply_range(mmu, start, end,
> +					   kvm_pgtable_stage2_unmap,
> +					   may_block));
>   }
>   
>   void kvm_stage2_unmap_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size)
> @@ -345,7 +350,10 @@ static void stage2_flush_memslot(struct kvm *kvm,
>   	phys_addr_t addr = memslot->base_gfn << PAGE_SHIFT;
>   	phys_addr_t end = addr + PAGE_SIZE * memslot->npages;
>   
> -	kvm_stage2_flush_range(&kvm->arch.mmu, addr, end);
> +	if (kvm_is_realm(kvm))
> +		kvm_realm_unmap_range(kvm, addr, end - addr, false);
> +	else
> +		kvm_stage2_flush_range(&kvm->arch.mmu, addr, end);
>   }
>   
>   /**
> @@ -1037,6 +1045,10 @@ void stage2_unmap_vm(struct kvm *kvm)
>   	struct kvm_memory_slot *memslot;
>   	int idx, bkt;
>   
> +	/* For realms this is handled by the RMM so nothing to do here */
> +	if (kvm_is_realm(kvm))
> +		return;
> +
>   	idx = srcu_read_lock(&kvm->srcu);
>   	mmap_read_lock(current->mm);
>   	write_lock(&kvm->mmu_lock);
> @@ -1062,6 +1074,7 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
>   	if (kvm_is_realm(kvm) &&
>   	    (kvm_realm_state(kvm) != REALM_STATE_DEAD &&
>   	     kvm_realm_state(kvm) != REALM_STATE_NONE)) {
> +		kvm_stage2_unmap_range(mmu, 0, (~0ULL) & PAGE_MASK);
>   		write_unlock(&kvm->mmu_lock);
>   		kvm_realm_destroy_rtts(kvm, pgt->ia_bits);
>   		return;
> @@ -1428,6 +1441,76 @@ static bool kvm_vma_mte_allowed(struct vm_area_struct *vma)
>   	return vma->vm_flags & VM_MTE_ALLOWED;
>   }
>   
> +static int realm_map_ipa(struct kvm *kvm, phys_addr_t ipa,
> +			 kvm_pfn_t pfn, unsigned long map_size,
> +			 enum kvm_pgtable_prot prot,
> +			 struct kvm_mmu_memory_cache *memcache)
> +{
> +	struct realm *realm = &kvm->arch.realm;
> +	struct page *page = pfn_to_page(pfn);
> +
> +	if (WARN_ON(!(prot & KVM_PGTABLE_PROT_W)))
> +		return -EFAULT;
> +
> +	if (!realm_is_addr_protected(realm, ipa))
> +		return realm_map_non_secure(realm, ipa, page, map_size,
> +					    memcache);
> +
> +	return realm_map_protected(realm, ipa, page, map_size, memcache);
> +}
> +
> +static int private_memslot_fault(struct kvm_vcpu *vcpu,
> +				 phys_addr_t fault_ipa,
> +				 struct kvm_memory_slot *memslot)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +	gpa_t gpa = kvm_gpa_from_fault(kvm, fault_ipa);
> +	gfn_t gfn = gpa >> PAGE_SHIFT;
> +	bool priv_exists = kvm_mem_is_private(kvm, gfn);
> +	struct kvm_mmu_memory_cache *memcache = &vcpu->arch.mmu_page_cache;
> +	kvm_pfn_t pfn;
> +	int ret;
> +	/*
> +	 * For Realms, the shared address is an alias of the private GPA with
> +	 * the top bit set. Thus is the fault address matches the GPA then it
> +	 * is the private alias.
> +	 */
> +	bool is_priv_gfn = (gpa == fault_ipa);
> +
> +	if (priv_exists != is_priv_gfn) {
> +		kvm_prepare_memory_fault_exit(vcpu,
> +					      gpa,
> +					      PAGE_SIZE,
> +					      kvm_is_write_fault(vcpu),
> +					      false, is_priv_gfn);
> +
> +		return -EFAULT;
> +	}
> +
> +	if (!is_priv_gfn) {
> +		/* Not a private mapping, handling normally */
> +		return -EINVAL;
> +	}
> +
> +	ret = kvm_mmu_topup_memory_cache(memcache,
> +					 kvm_mmu_cache_min_pages(vcpu->arch.hw_mmu));
> +	if (ret)
> +		return ret;
> +
> +	ret = kvm_gmem_get_pfn(kvm, memslot, gfn, &pfn, NULL);
> +	if (ret)
> +		return ret;
> +
> +	/* FIXME: Should be able to use bigger than PAGE_SIZE mappings */
> +	ret = realm_map_ipa(kvm, fault_ipa, pfn, PAGE_SIZE, KVM_PGTABLE_PROT_W,
> +			    memcache);
> +	if (!ret)
> +		return 1; /* Handled */
> +
> +	put_page(pfn_to_page(pfn));
> +	return ret;
> +}
> +
>   static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   			  struct kvm_s2_trans *nested,
>   			  struct kvm_memory_slot *memslot, unsigned long hva,
> @@ -1453,6 +1536,14 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   	if (fault_is_perm)
>   		fault_granule = kvm_vcpu_trap_get_perm_fault_granule(vcpu);
>   	write_fault = kvm_is_write_fault(vcpu);
> +
> +	/*
> +	 * Realms cannot map protected pages read-only
> +	 * FIXME: It should be possible to map unprotected pages read-only
> +	 */
> +	if (vcpu_is_rec(vcpu))
> +		write_fault = true;
> +
>   	exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
>   	VM_BUG_ON(write_fault && exec_fault);
>   
> @@ -1560,7 +1651,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   		ipa &= ~(vma_pagesize - 1);
>   	}
>   
> -	gfn = ipa >> PAGE_SHIFT;
> +	gfn = kvm_gpa_from_fault(kvm, ipa) >> PAGE_SHIFT;
>   	mte_allowed = kvm_vma_mte_allowed(vma);
>   
>   	vfio_allow_any_uc = vma->vm_flags & VM_ALLOW_ANY_UNCACHED;
> @@ -1641,7 +1732,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   	 * If we are not forced to use page mapping, check if we are
>   	 * backed by a THP and thus use block mapping if possible.
>   	 */
> -	if (vma_pagesize == PAGE_SIZE && !(force_pte || device)) {
> +	/* FIXME: We shouldn't need to disable this for realms */
> +	if (vma_pagesize == PAGE_SIZE && !(force_pte || device || kvm_is_realm(kvm))) {
>   		if (fault_is_perm && fault_granule > PAGE_SIZE)
>   			vma_pagesize = fault_granule;
>   		else
> @@ -1693,6 +1785,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   		 */
>   		prot &= ~KVM_NV_GUEST_MAP_SZ;
>   		ret = kvm_pgtable_stage2_relax_perms(pgt, fault_ipa, prot);
> +	} else if (kvm_is_realm(kvm)) {
> +		ret = realm_map_ipa(kvm, fault_ipa, pfn, vma_pagesize,
> +				    prot, memcache);
>   	} else {
>   		ret = kvm_pgtable_stage2_map(pgt, fault_ipa, vma_pagesize,
>   					     __pfn_to_phys(pfn), prot,
> @@ -1841,8 +1936,15 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>   		nested = &nested_trans;
>   	}
>   
> -	gfn = ipa >> PAGE_SHIFT;
> +	gfn = kvm_gpa_from_fault(vcpu->kvm, ipa) >> PAGE_SHIFT;
>   	memslot = gfn_to_memslot(vcpu->kvm, gfn);
> +
> +	if (kvm_slot_can_be_private(memslot)) {
> +		ret = private_memslot_fault(vcpu, ipa, memslot);
> +		if (ret != -EINVAL)
> +			goto out;
> +	}
> +
>   	hva = gfn_to_hva_memslot_prot(memslot, gfn, &writable);
>   	write_fault = kvm_is_write_fault(vcpu);
>   	if (kvm_is_error_hva(hva) || (write_fault && !writable)) {
> @@ -1886,7 +1988,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>   		 * of the page size.
>   		 */
>   		ipa |= kvm_vcpu_get_hfar(vcpu) & GENMASK(11, 0);
> -		ret = io_mem_abort(vcpu, ipa);
> +		ret = io_mem_abort(vcpu, kvm_gpa_from_fault(vcpu->kvm, ipa));
>   		goto out_unlock;
>   	}
>   
> @@ -1934,6 +2036,10 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>   	if (!kvm->arch.mmu.pgt)
>   		return false;
>   
> +	/* We don't support aging for Realms */
> +	if (kvm_is_realm(kvm))
> +		return true;
> +
>   	return kvm_pgtable_stage2_test_clear_young(kvm->arch.mmu.pgt,
>   						   range->start << PAGE_SHIFT,
>   						   size, true);
> @@ -1950,6 +2056,10 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>   	if (!kvm->arch.mmu.pgt)
>   		return false;
>   
> +	/* We don't support aging for Realms */
> +	if (kvm_is_realm(kvm))
> +		return true;
> +
>   	return kvm_pgtable_stage2_test_clear_young(kvm->arch.mmu.pgt,
>   						   range->start << PAGE_SHIFT,
>   						   size, false);
> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
> index b794673b6a5d..f3e809c2087d 100644
> --- a/arch/arm64/kvm/rme.c
> +++ b/arch/arm64/kvm/rme.c
> @@ -627,6 +627,181 @@ static int fold_rtt(struct realm *realm, unsigned long addr, int level)
>   	return 0;
>   }
>   
> +static phys_addr_t rtt_get_phys(struct realm *realm, struct rtt_entry *rtt)
> +{
> +	/* FIXME: For now LPA2 isn't supported in a realm guest */
> +	bool lpa2 = false;
> +
> +	if (lpa2)
> +		return rtt->desc & GENMASK(49, 12);
> +	return rtt->desc & GENMASK(47, 12);
> +}
> +
> +int realm_map_protected(struct realm *realm,
> +			unsigned long base_ipa,
> +			struct page *dst_page,
> +			unsigned long map_size,
> +			struct kvm_mmu_memory_cache *memcache)
> +{
> +	phys_addr_t dst_phys = page_to_phys(dst_page);
> +	phys_addr_t rd = virt_to_phys(realm->rd);
> +	unsigned long phys = dst_phys;
> +	unsigned long ipa = base_ipa;
> +	unsigned long size;
> +	int map_level;
> +	int ret = 0;
> +
> +	if (WARN_ON(!IS_ALIGNED(ipa, map_size)))
> +		return -EINVAL;
> +
> +	switch (map_size) {
> +	case PAGE_SIZE:
> +		map_level = 3;
> +		break;
> +	case RME_L2_BLOCK_SIZE:
> +		map_level = 2;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	if (map_level < RME_RTT_MAX_LEVEL) {
> +		/*
> +		 * A temporary RTT is needed during the map, precreate it,
> +		 * however if there is an error (e.g. missing parent tables)
> +		 * this will be handled below.
> +		 */
> +		realm_create_rtt_levels(realm, ipa, map_level,
> +					RME_RTT_MAX_LEVEL, memcache);
> +	}
> +
> +	for (size = 0; size < map_size; size += PAGE_SIZE) {
> +		if (rmi_granule_delegate(phys)) {
> +			struct rtt_entry rtt;
> +
> +			/*
> +			 * It's possible we raced with another VCPU on the same
> +			 * fault. If the entry exists and matches then exit
> +			 * early and assume the other VCPU will handle the
> +			 * mapping.
> +			 */
> +			if (rmi_rtt_read_entry(rd, ipa, RME_RTT_MAX_LEVEL, &rtt))
> +				goto err;
> +
> +			/*
> +			 * FIXME: For a block mapping this could race at level
> +			 * 2 or 3... currently we don't support block mappings
> +			 */
> +			if (WARN_ON((rtt.walk_level != RME_RTT_MAX_LEVEL ||
> +				     rtt.state != RMI_ASSIGNED ||
> +				     rtt_get_phys(realm, &rtt) != phys))) {
> +				goto err;
> +			}
> +
> +			return 0;
> +		}
> +
> +		ret = rmi_data_create_unknown(rd, phys, ipa);
> +
> +		if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
> +			/* Create missing RTTs and retry */
> +			int level = RMI_RETURN_INDEX(ret);
> +
> +			ret = realm_create_rtt_levels(realm, ipa, level,
> +						      RME_RTT_MAX_LEVEL,
> +						      memcache);
> +			WARN_ON(ret);
> +			if (ret)
> +				goto err_undelegate;
> +
> +			ret = rmi_data_create_unknown(rd, phys, ipa);
> +		}
> +		WARN_ON(ret);
> +
> +		if (ret)
> +			goto err_undelegate;
> +
> +		phys += PAGE_SIZE;
> +		ipa += PAGE_SIZE;
> +	}
> +
> +	if (map_size == RME_L2_BLOCK_SIZE)
> +		ret = fold_rtt(realm, base_ipa, map_level);
> +	if (WARN_ON(ret))
> +		goto err;
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
> +		phys -= PAGE_SIZE;
> +		size -= PAGE_SIZE;
> +		ipa -= PAGE_SIZE;
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
> +			 struct page *page,
> +			 unsigned long map_size,
> +			 struct kvm_mmu_memory_cache *memcache)
> +{
> +	phys_addr_t rd = virt_to_phys(realm->rd);
> +	int map_level;
> +	int ret = 0;
> +	unsigned long desc = page_to_phys(page) |
> +			     PTE_S2_MEMATTR(MT_S2_FWB_NORMAL) |
> +			     /* FIXME: Read+Write permissions for now */
> +			     (3 << 6);
> +
> +	if (WARN_ON(!IS_ALIGNED(ipa, map_size)))
> +		return -EINVAL;
> +
> +	switch (map_size) {
> +	case PAGE_SIZE:
> +		map_level = 3;
> +		break;
> +	case RME_L2_BLOCK_SIZE:
> +		map_level = 2;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	ret = rmi_rtt_map_unprotected(rd, ipa, map_level, desc);
> +
> +	if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
> +		/* Create missing RTTs and retry */
> +		int level = RMI_RETURN_INDEX(ret);
> +
> +		ret = realm_create_rtt_levels(realm, ipa, level, map_level,
> +					      memcache);
> +		if (WARN_ON(ret))
> +			return -ENXIO;
> +
> +		ret = rmi_rtt_map_unprotected(rd, ipa, map_level, desc);
> +	}
> +	if (WARN_ON(ret))

We could race against another thread for unprotected mapping too, thus 
we may need to handle the case and read the RTT to make sure everything
is alright ? The support for block mapping might add more scenarios
similar to the FIXME in protected case.

Suzuki


> +		return -ENXIO;
> +
> +	return 0;
> +}
> +
>   static int populate_par_region(struct kvm *kvm,
>   			       phys_addr_t ipa_base,
>   			       phys_addr_t ipa_end,
> @@ -638,7 +813,6 @@ static int populate_par_region(struct kvm *kvm,
>   	int idx;
>   	phys_addr_t ipa;
>   	int ret = 0;
> -	struct page *tmp_page;
>   	unsigned long data_flags = 0;
>   
>   	base_gfn = gpa_to_gfn(ipa_base);
> @@ -660,9 +834,8 @@ static int populate_par_region(struct kvm *kvm,
>   		goto out;
>   	}
>   
> -	tmp_page = alloc_page(GFP_KERNEL);
> -	if (!tmp_page) {
> -		ret = -ENOMEM;
> +	if (!kvm_slot_can_be_private(memslot)) {
> +		ret = -EINVAL;
>   		goto out;
>   	}
>   
> @@ -729,28 +902,32 @@ static int populate_par_region(struct kvm *kvm,
>   		for (offset = 0; offset < map_size && !ret;
>   		     offset += PAGE_SIZE, page++) {
>   			phys_addr_t page_ipa = ipa + offset;
> +			kvm_pfn_t priv_pfn;
> +			int order;
> +
> +			ret = kvm_gmem_get_pfn(kvm, memslot,
> +					       page_ipa >> PAGE_SHIFT,
> +					       &priv_pfn, &order);
> +			if (ret)
> +				break;
>   
>   			ret = realm_create_protected_data_page(realm, page_ipa,
> -							       page, tmp_page,
> -							       data_flags);
> +							       pfn_to_page(priv_pfn),
> +							       page, data_flags);
>   		}
> +
> +		kvm_release_pfn_clean(pfn);
> +
>   		if (ret)
> -			goto err_release_pfn;
> +			break;
>   
>   		if (level == 2)
>   			fold_rtt(realm, ipa, level);
>   
>   		ipa += map_size;
> -		kvm_release_pfn_dirty(pfn);
> -err_release_pfn:
> -		if (ret) {
> -			kvm_release_pfn_clean(pfn);
> -			break;
> -		}
>   	}
>   
>   	mmap_read_unlock(current->mm);
> -	__free_page(tmp_page);
>   
>   out:
>   	srcu_read_unlock(&kvm->srcu, idx);


