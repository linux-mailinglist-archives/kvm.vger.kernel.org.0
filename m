Return-Path: <kvm+bounces-24803-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A24DE95AC41
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 05:50:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 53586281293
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 03:50:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC9C036AFE;
	Thu, 22 Aug 2024 03:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U/LTJudt"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFEAE208A7;
	Thu, 22 Aug 2024 03:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724298628; cv=none; b=FrItc2w4nzfH0N8OrMESMIBEiwu3wkI9/HlkwPNiKMnrxGuDnO2rdypOutwr7Q+suk0Q2w9nhMy0tipttwqrGRitW3tMYPSZAj3t7F/Q7Ofz8NKVwlg1jdIEdneyaJ4D4+AjCrox3H5ukibkq4xb3Fyi6ohjhTrCjxDaoq+XuhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724298628; c=relaxed/simple;
	bh=AHkBAc1XVWS6nQvf2M9AgJE5Vd7B5Egch8qJ6oUGDQo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=L0dPCqaj2Q0sdkjHSti0eyFI0g9vdX4K0IlqsucTGRA6w1BHzIQ8ZNaacKEi44tYwd0EpaytV+OG2gWm6FG2Qr6vyZ6EDxPSIfcl7AyRNtTytaV+9hLKYzXitgqxIbugFO+4T+7xjqYGBJ8V7o6ma9C2q2NIqaDhXohxcVKfjVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U/LTJudt; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C79A9C4AF09;
	Thu, 22 Aug 2024 03:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724298626;
	bh=AHkBAc1XVWS6nQvf2M9AgJE5Vd7B5Egch8qJ6oUGDQo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=U/LTJudtiIghaFFDAmKyoOPFUcJi2oC4GeHy3YRqAQdVbLj74ScyC/EuteQgo1eBP
	 2fMBLsCPceFm4b8F3pe7WDra2aG4OsDZkYGXq90V6zS60QLEw28TNpvkBZF4DoTiAK
	 0pShhPtgQqjJY3Me8gKmsxeFEYGYPxz2cZyacmUQ3E2kQ+B7N3OtAH/V2rbGkiot2j
	 dFMDw1hCrP/xOJVEbq3pAOWShXz2ndn/GD9XSaI6Boq1FW2KUD1bjNRWO3o+85cspb
	 DFIoJq1+U83r9eOBwszTe4KQwAHF8e4Dtdqhb47Bf1jiSbcY8MiAvG1b41bXakgTrp
	 kH6WgvyfSVljw==
X-Mailer: emacs 31.0.50 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Steven Price <steven.price@arm.com>,
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
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>
Subject: Re: [PATCH v4 21/43] arm64: RME: Runtime faulting of memory
In-Reply-To: <20240821153844.60084-22-steven.price@arm.com>
References: <20240821153844.60084-1-steven.price@arm.com>
 <20240821153844.60084-22-steven.price@arm.com>
Date: Thu, 22 Aug 2024 09:20:15 +0530
Message-ID: <yq5acym12p3c.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Steven Price <steven.price@arm.com> writes:

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
> Changes since v2:
>  * Avoid leaking memory if failing to map it in the realm.
>  * Correctly mask RTT based on LPA2 flag (see rtt_get_phys()).
>  * Adapt to changes in previous patches.
> ---
>  arch/arm64/include/asm/kvm_emulate.h |  10 ++
>  arch/arm64/include/asm/kvm_rme.h     |  10 ++
>  arch/arm64/kvm/mmu.c                 | 120 +++++++++++++++-
>  arch/arm64/kvm/rme.c                 | 205 +++++++++++++++++++++++++--
>  4 files changed, 325 insertions(+), 20 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index 7430c77574e3..0b50572d3719 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -710,6 +710,16 @@ static inline bool kvm_realm_is_created(struct kvm *kvm)
>  	return kvm_is_realm(kvm) && kvm_realm_state(kvm) != REALM_STATE_NONE;
>  }
>  
> +static inline gpa_t kvm_gpa_stolen_bits(struct kvm *kvm)
> +{
> +	if (kvm_is_realm(kvm)) {
> +		struct realm *realm = &kvm->arch.realm;
> +
> +		return BIT(realm->ia_bits - 1);
> +	}
> +	return 0;
> +}
> +
>  static inline bool vcpu_is_rec(struct kvm_vcpu *vcpu)
>  {
>  	if (static_branch_unlikely(&kvm_rme_is_available))
> diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
> index 0e44b20cfa48..c50854f44674 100644
> --- a/arch/arm64/include/asm/kvm_rme.h
> +++ b/arch/arm64/include/asm/kvm_rme.h
> @@ -103,6 +103,16 @@ void kvm_realm_unmap_range(struct kvm *kvm,
>  			   unsigned long ipa,
>  			   u64 size,
>  			   bool unmap_private);
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
>  int realm_set_ipa_state(struct kvm_vcpu *vcpu,
>  			unsigned long addr, unsigned long end,
>  			unsigned long ripas,
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 620d26810019..eb8b8d013f3e 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -325,8 +325,13 @@ static void __unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64
>  
>  	lockdep_assert_held_write(&kvm->mmu_lock);
>  	WARN_ON(size & ~PAGE_MASK);
> -	WARN_ON(stage2_apply_range(mmu, start, end, kvm_pgtable_stage2_unmap,
> -				   may_block));
> +
> +	if (kvm_is_realm(kvm))
> +		kvm_realm_unmap_range(kvm, start, size, !only_shared);
> +	else
> +		WARN_ON(stage2_apply_range(mmu, start, end,
> +					   kvm_pgtable_stage2_unmap,
> +					   may_block));
>  }
>  
>  void kvm_stage2_unmap_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size)
> @@ -345,7 +350,10 @@ static void stage2_flush_memslot(struct kvm *kvm,
>  	phys_addr_t addr = memslot->base_gfn << PAGE_SHIFT;
>  	phys_addr_t end = addr + PAGE_SIZE * memslot->npages;
>  
> -	kvm_stage2_flush_range(&kvm->arch.mmu, addr, end);
> +	if (kvm_is_realm(kvm))
> +		kvm_realm_unmap_range(kvm, addr, end - addr, false);
> +	else
> +		kvm_stage2_flush_range(&kvm->arch.mmu, addr, end);
>  }
>  
>  /**
> @@ -1037,6 +1045,10 @@ void stage2_unmap_vm(struct kvm *kvm)
>  	struct kvm_memory_slot *memslot;
>  	int idx, bkt;
>  
> +	/* For realms this is handled by the RMM so nothing to do here */
> +	if (kvm_is_realm(kvm))
> +		return;
> +
>  	idx = srcu_read_lock(&kvm->srcu);
>  	mmap_read_lock(current->mm);
>  	write_lock(&kvm->mmu_lock);
> @@ -1062,6 +1074,7 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
>  	if (kvm_is_realm(kvm) &&
>  	    (kvm_realm_state(kvm) != REALM_STATE_DEAD &&
>  	     kvm_realm_state(kvm) != REALM_STATE_NONE)) {
> +		kvm_stage2_unmap_range(mmu, 0, (~0ULL) & PAGE_MASK);
>  		write_unlock(&kvm->mmu_lock);
>  		kvm_realm_destroy_rtts(kvm, pgt->ia_bits);
>  		return;
> @@ -1428,6 +1441,71 @@ static bool kvm_vma_mte_allowed(struct vm_area_struct *vma)
>  	return vma->vm_flags & VM_MTE_ALLOWED;
>  }
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
> +	gpa_t gpa_stolen_mask = kvm_gpa_stolen_bits(kvm);
> +	gfn_t gfn = (fault_ipa & ~gpa_stolen_mask) >> PAGE_SHIFT;
> +	bool is_priv_gfn = !((fault_ipa & gpa_stolen_mask) == gpa_stolen_mask);
> +	bool priv_exists = kvm_mem_is_private(kvm, gfn);
> +	struct kvm_mmu_memory_cache *memcache = &vcpu->arch.mmu_page_cache;
> +	kvm_pfn_t pfn;
> +	int ret;
> +
> +	if (priv_exists != is_priv_gfn) {
> +		kvm_prepare_memory_fault_exit(vcpu,
> +					      fault_ipa & ~gpa_stolen_mask,
> +					      PAGE_SIZE,
> +					      kvm_is_write_fault(vcpu),
> +					      false, is_priv_gfn);
> +
> +		return 0;
> +	}
> +
> +	if (!is_priv_gfn) {
> +		/* Not a private mapping, handling normally */
> +		return -EAGAIN;
> +	}
>

Instead of that EAGAIN, it better to handle as below?

 arch/arm64/kvm/mmu.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 1eddbc7d7156..33ef95b5c94a 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1480,11 +1480,6 @@ static int private_memslot_fault(struct kvm_vcpu *vcpu,
 		return 0;
 	}
 
-	if (!is_priv_gfn) {
-		/* Not a private mapping, handling normally */
-		return -EAGAIN;
-	}
-
 	ret = kvm_mmu_topup_memory_cache(memcache,
 					 kvm_mmu_cache_min_pages(vcpu->arch.hw_mmu));
 	if (ret)
@@ -1925,12 +1920,25 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 	gfn = kvm_gpa_from_fault(vcpu->kvm, ipa) >> PAGE_SHIFT;
 	memslot = gfn_to_memslot(vcpu->kvm, gfn);
 
-	if (kvm_slot_can_be_private(memslot)) {
-		ret = private_memslot_fault(vcpu, fault_ipa, memslot);
-		if (ret != -EAGAIN)
+	if (kvm_slot_can_be_private(memslot) &&
+	    kvm_is_private_gpa(vcpu->kvm, ipa)) {
+		ret = private_memslot_fault(vcpu, ipa, memslot);
 			goto out;
 	}
+	/* attribute msimatch. shared access fault on a mem with private attribute */
+	if (kvm_mem_is_private(vcpu->kvm, gfn)) {
+		/* let VMM fixup the memory attribute */
+		kvm_prepare_memory_fault_exit(vcpu,
+					      kvm_gpa_from_fault(vcpu->kvm, ipa),
+					      PAGE_SIZE,
+					      kvm_is_write_fault(vcpu),
+					      false, false);
+
+		ret =  0;
+		goto out;
+	}
 
+	/* Slot can be be private, but fault addr is not, handle that as normal fault */
 	hva = gfn_to_hva_memslot_prot(memslot, gfn, &writable);
 	write_fault = kvm_is_write_fault(vcpu);
 	if (kvm_is_error_hva(hva) || (write_fault && !writable)) {
-- 
2.34.1





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
>  static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  			  struct kvm_s2_trans *nested,
>  			  struct kvm_memory_slot *memslot, unsigned long hva,
> @@ -1449,10 +1527,19 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	long vma_pagesize, fault_granule;
>  	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
>  	struct kvm_pgtable *pgt;
> +	gpa_t gpa_stolen_mask = kvm_gpa_stolen_bits(vcpu->kvm);
>  
>  	if (fault_is_perm)
>  		fault_granule = kvm_vcpu_trap_get_perm_fault_granule(vcpu);
>  	write_fault = kvm_is_write_fault(vcpu);
> +
> +	/*
> +	 * Realms cannot map protected pages read-only
> +	 * FIXME: It should be possible to map unprotected pages read-only
> +	 */
> +	if (vcpu_is_rec(vcpu))
> +		write_fault = true;
> +
>  	exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
>  	VM_BUG_ON(write_fault && exec_fault);
>  
> @@ -1553,7 +1640,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	if (vma_pagesize == PMD_SIZE || vma_pagesize == PUD_SIZE)
>  		fault_ipa &= ~(vma_pagesize - 1);
>  
> -	gfn = ipa >> PAGE_SHIFT;
> +	gfn = (ipa & ~gpa_stolen_mask) >> PAGE_SHIFT;
>  	mte_allowed = kvm_vma_mte_allowed(vma);
>  
>  	vfio_allow_any_uc = vma->vm_flags & VM_ALLOW_ANY_UNCACHED;
> @@ -1634,7 +1721,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	 * If we are not forced to use page mapping, check if we are
>  	 * backed by a THP and thus use block mapping if possible.
>  	 */
> -	if (vma_pagesize == PAGE_SIZE && !(force_pte || device)) {
> +	/* FIXME: We shouldn't need to disable this for realms */
> +	if (vma_pagesize == PAGE_SIZE && !(force_pte || device || kvm_is_realm(kvm))) {
>  		if (fault_is_perm && fault_granule > PAGE_SIZE)
>  			vma_pagesize = fault_granule;
>  		else
> @@ -1686,6 +1774,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  		 */
>  		prot &= ~KVM_NV_GUEST_MAP_SZ;
>  		ret = kvm_pgtable_stage2_relax_perms(pgt, fault_ipa, prot);
> +	} else if (kvm_is_realm(kvm)) {
> +		ret = realm_map_ipa(kvm, fault_ipa, pfn, vma_pagesize,
> +				    prot, memcache);
>  	} else {
>  		ret = kvm_pgtable_stage2_map(pgt, fault_ipa, vma_pagesize,
>  					     __pfn_to_phys(pfn), prot,
> @@ -1744,6 +1835,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>  	struct kvm_memory_slot *memslot;
>  	unsigned long hva;
>  	bool is_iabt, write_fault, writable;
> +	gpa_t gpa_stolen_mask = kvm_gpa_stolen_bits(vcpu->kvm);
>  	gfn_t gfn;
>  	int ret, idx;
>  
> @@ -1834,8 +1926,15 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>  		nested = &nested_trans;
>  	}
>  
> -	gfn = ipa >> PAGE_SHIFT;
> +	gfn = (ipa & ~gpa_stolen_mask) >> PAGE_SHIFT;
>  	memslot = gfn_to_memslot(vcpu->kvm, gfn);
> +
> +	if (kvm_slot_can_be_private(memslot)) {
> +		ret = private_memslot_fault(vcpu, fault_ipa, memslot);
> +		if (ret != -EAGAIN)
> +			goto out;
> +	}
> +
>

Instead of referring this as stolen bits is it better to do

 arch/arm64/include/asm/kvm_emulate.h | 20 +++++++++++++++++---
 arch/arm64/kvm/mmu.c                 | 21 ++++++++-------------
 2 files changed, 25 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 0b50572d3719..790412fd53b8 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -710,14 +710,28 @@ static inline bool kvm_realm_is_created(struct kvm *kvm)
 	return kvm_is_realm(kvm) && kvm_realm_state(kvm) != REALM_STATE_NONE;
 }
 
-static inline gpa_t kvm_gpa_stolen_bits(struct kvm *kvm)
+static inline gpa_t kvm_gpa_from_fault(struct kvm *kvm, phys_addr_t fault_addr)
 {
+	gpa_t addr_mask;
+
 	if (kvm_is_realm(kvm)) {
 		struct realm *realm = &kvm->arch.realm;
 
-		return BIT(realm->ia_bits - 1);
+		addr_mask = BIT(realm->ia_bits - 1);
+		/* clear shared bit and return */
+		return fault_addr & ~addr_mask;
 	}
-	return 0;
+	return fault_addr;
+}
+
+static inline bool kvm_is_private_gpa(struct kvm *kvm, phys_addr_t fault_addr)
+{
+	/*
+	 * For Realms, the shared address is an alias of the private GPA
+	 * with top bit set and we have a single address space. Thus if the
+	 * fault address matches the GPA, it is the private GPA
+	 */
+	return fault_addr == kvm_gpa_from_fault(kvm, fault_addr);
 }
 
 static inline bool vcpu_is_rec(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index eb8b8d013f3e..1eddbc7d7156 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1464,20 +1464,18 @@ static int private_memslot_fault(struct kvm_vcpu *vcpu,
 				 struct kvm_memory_slot *memslot)
 {
 	struct kvm *kvm = vcpu->kvm;
-	gpa_t gpa_stolen_mask = kvm_gpa_stolen_bits(kvm);
-	gfn_t gfn = (fault_ipa & ~gpa_stolen_mask) >> PAGE_SHIFT;
-	bool is_priv_gfn = !((fault_ipa & gpa_stolen_mask) == gpa_stolen_mask);
-	bool priv_exists = kvm_mem_is_private(kvm, gfn);
+	gfn_t gfn = kvm_gpa_from_fault(kvm, fault_ipa) >> PAGE_SHIFT;
 	struct kvm_mmu_memory_cache *memcache = &vcpu->arch.mmu_page_cache;
 	kvm_pfn_t pfn;
 	int ret;
 
-	if (priv_exists != is_priv_gfn) {
+	if (!kvm_mem_is_private(kvm, gfn)) {
+		/* let VMM fixup the memory attribute */
 		kvm_prepare_memory_fault_exit(vcpu,
-					      fault_ipa & ~gpa_stolen_mask,
+					      kvm_gpa_from_fault(kvm, fault_ipa),
 					      PAGE_SIZE,
 					      kvm_is_write_fault(vcpu),
-					      false, is_priv_gfn);
+					      false, true);
 
 		return 0;
 	}
@@ -1527,7 +1525,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	long vma_pagesize, fault_granule;
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
 	struct kvm_pgtable *pgt;
-	gpa_t gpa_stolen_mask = kvm_gpa_stolen_bits(vcpu->kvm);
 
 	if (fault_is_perm)
 		fault_granule = kvm_vcpu_trap_get_perm_fault_granule(vcpu);
@@ -1640,7 +1637,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (vma_pagesize == PMD_SIZE || vma_pagesize == PUD_SIZE)
 		fault_ipa &= ~(vma_pagesize - 1);
 
-	gfn = (ipa & ~gpa_stolen_mask) >> PAGE_SHIFT;
+	gfn = kvm_gpa_from_fault(kvm, ipa) >> PAGE_SHIFT;
 	mte_allowed = kvm_vma_mte_allowed(vma);
 
 	vfio_allow_any_uc = vma->vm_flags & VM_ALLOW_ANY_UNCACHED;
@@ -1835,7 +1832,6 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 	struct kvm_memory_slot *memslot;
 	unsigned long hva;
 	bool is_iabt, write_fault, writable;
-	gpa_t gpa_stolen_mask = kvm_gpa_stolen_bits(vcpu->kvm);
 	gfn_t gfn;
 	int ret, idx;
 
@@ -1926,7 +1922,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 		nested = &nested_trans;
 	}
 
-	gfn = (ipa & ~gpa_stolen_mask) >> PAGE_SHIFT;
+	gfn = kvm_gpa_from_fault(vcpu->kvm, ipa) >> PAGE_SHIFT;
 	memslot = gfn_to_memslot(vcpu->kvm, gfn);
 
 	if (kvm_slot_can_be_private(memslot)) {
@@ -1978,8 +1974,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 		 * of the page size.
 		 */
 		ipa |= kvm_vcpu_get_hfar(vcpu) & GENMASK(11, 0);
-		ipa &= ~gpa_stolen_mask;
-		ret = io_mem_abort(vcpu, ipa);
+		ret = io_mem_abort(vcpu, kvm_gpa_from_fault(vcpu->kvm, ipa));
 		goto out_unlock;
 	}
 
-- 


>  	hva = gfn_to_hva_memslot_prot(memslot, gfn, &writable);
>  	write_fault = kvm_is_write_fault(vcpu);
>  	if (kvm_is_error_hva(hva) || (write_fault && !writable)) {
> @@ -1879,6 +1978,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>  		 * of the page size.
>  		 */
>  		ipa |= kvm_vcpu_get_hfar(vcpu) & GENMASK(11, 0);
> +		ipa &= ~gpa_stolen_mask;
>  		ret = io_mem_abort(vcpu, ipa);
>  		goto out_unlock;
>  	}
> @@ -1927,6 +2027,10 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>  	if (!kvm->arch.mmu.pgt)
>  		return false;
>  
> +	/* We don't support aging for Realms */
> +	if (kvm_is_realm(kvm))
> +		return true;
> +
>  	return kvm_pgtable_stage2_test_clear_young(kvm->arch.mmu.pgt,
>  						   range->start << PAGE_SHIFT,
>  						   size, true);
> @@ -1943,6 +2047,10 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>  	if (!kvm->arch.mmu.pgt)
>  		return false;
>  
> +	/* We don't support aging for Realms */
> +	if (kvm_is_realm(kvm))
> +		return true;
> +
>  	return kvm_pgtable_stage2_test_clear_young(kvm->arch.mmu.pgt,
>  						   range->start << PAGE_SHIFT,
>  						   size, false);


-aneesh

