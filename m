Return-Path: <kvm+bounces-14453-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E32998A29DD
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 10:54:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 123B51C22E30
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 08:54:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AEBA84A28;
	Fri, 12 Apr 2024 08:44:10 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AE6983CC6;
	Fri, 12 Apr 2024 08:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712911449; cv=none; b=vF6KR+1/f7tfu0W7atO4bQgMyuaQNpOXUsCBchqrLytj6he9xMAAd5KMHNVJLn6xkpNamRlh3LvQPi2+eOXEUEWF8ypzKn7IkvLXJ0PRjwgdfQfZqgoXer7Am09dk0iVCw7eQ+MOqXw6RTKyy2VpuGX6Sp4aQ6KMH9jrBHs5BBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712911449; c=relaxed/simple;
	bh=AsI0ill67JZP1KBTERhSAmNtP8/vOSa5xCek6LhVIIQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DOn9Yk0hXpLYczg3PaHFn8YbCBw+0KODlgw8aY5eNCe/GycvW4r4a9beyh1gfTC6JcfT6j0t02a6XYT7Cxl2QDwJ5fhbPDoQ2MetCHojNcFw4Ihkkn2bJmY5qvTt8E0SU29xj4eIvGJCw5Ilpn+QKafDHBd9OGTZDB8mlstJyqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F1D7015DB;
	Fri, 12 Apr 2024 01:44:36 -0700 (PDT)
Received: from e112269-lin.cambridge.arm.com (e112269-lin.cambridge.arm.com [10.1.194.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9610D3F6C4;
	Fri, 12 Apr 2024 01:44:05 -0700 (PDT)
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: [PATCH v2 21/43] arm64: RME: Runtime faulting of memory
Date: Fri, 12 Apr 2024 09:42:47 +0100
Message-Id: <20240412084309.1733783-22-steven.price@arm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240412084309.1733783-1-steven.price@arm.com>
References: <20240412084056.1733704-1-steven.price@arm.com>
 <20240412084309.1733783-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

At runtime if the realm guest accesses memory which hasn't yet been
mapped then KVM needs to either populate the region or fault the guest.

For memory in the lower (protected) region of IPA a fresh page is
provided to the RMM which will zero the contents. For memory in the
upper (shared) region of IPA, the memory from the memslot is mapped
into the realm VM non secure.

Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/include/asm/kvm_emulate.h |  10 ++
 arch/arm64/include/asm/kvm_rme.h     |  10 ++
 arch/arm64/kvm/mmu.c                 | 119 +++++++++++++++-
 arch/arm64/kvm/rme.c                 | 199 ++++++++++++++++++++++++---
 4 files changed, 316 insertions(+), 22 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 2209a7c6267f..d40d998d9be2 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -629,6 +629,16 @@ static inline bool kvm_realm_is_created(struct kvm *kvm)
 	return kvm_is_realm(kvm) && kvm_realm_state(kvm) != REALM_STATE_NONE;
 }
 
+static inline gpa_t kvm_gpa_stolen_bits(struct kvm *kvm)
+{
+	if (kvm_is_realm(kvm)) {
+		struct realm *realm = &kvm->arch.realm;
+
+		return BIT(realm->ia_bits - 1);
+	}
+	return 0;
+}
+
 static inline bool vcpu_is_rec(struct kvm_vcpu *vcpu)
 {
 	if (static_branch_unlikely(&kvm_rme_is_available))
diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
index 749f2eb97bd4..48c7766fadeb 100644
--- a/arch/arm64/include/asm/kvm_rme.h
+++ b/arch/arm64/include/asm/kvm_rme.h
@@ -103,6 +103,16 @@ void kvm_realm_unmap_range(struct kvm *kvm,
 			   unsigned long ipa,
 			   u64 size,
 			   bool unmap_private);
+int realm_map_protected(struct realm *realm,
+			unsigned long base_ipa,
+			struct page *dst_page,
+			unsigned long map_size,
+			struct kvm_mmu_memory_cache *memcache);
+int realm_map_non_secure(struct realm *realm,
+			 unsigned long ipa,
+			 struct page *page,
+			 unsigned long map_size,
+			 struct kvm_mmu_memory_cache *memcache);
 int realm_set_ipa_state(struct kvm_vcpu *vcpu,
 			unsigned long addr, unsigned long end,
 			unsigned long ripas);
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 8a7b5449697f..50a49e4e2020 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -325,8 +325,13 @@ static void __unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
 	WARN_ON(size & ~PAGE_MASK);
-	WARN_ON(stage2_apply_range(mmu, start, end, kvm_pgtable_stage2_unmap,
-				   may_block));
+
+	if (kvm_is_realm(kvm))
+		kvm_realm_unmap_range(kvm, start, size, !only_shared);
+	else
+		WARN_ON(stage2_apply_range(mmu, start, end,
+					   kvm_pgtable_stage2_unmap,
+					   may_block));
 }
 
 static void unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size)
@@ -340,7 +345,11 @@ static void stage2_flush_memslot(struct kvm *kvm,
 	phys_addr_t addr = memslot->base_gfn << PAGE_SHIFT;
 	phys_addr_t end = addr + PAGE_SIZE * memslot->npages;
 
-	stage2_apply_range_resched(&kvm->arch.mmu, addr, end, kvm_pgtable_stage2_flush);
+	if (kvm_is_realm(kvm))
+		kvm_realm_unmap_range(kvm, addr, end - addr, false);
+	else
+		stage2_apply_range_resched(&kvm->arch.mmu, addr, end,
+					   kvm_pgtable_stage2_flush);
 }
 
 /**
@@ -997,6 +1006,10 @@ void stage2_unmap_vm(struct kvm *kvm)
 	struct kvm_memory_slot *memslot;
 	int idx, bkt;
 
+	/* For realms this is handled by the RMM so nothing to do here */
+	if (kvm_is_realm(kvm))
+		return;
+
 	idx = srcu_read_lock(&kvm->srcu);
 	mmap_read_lock(current->mm);
 	write_lock(&kvm->mmu_lock);
@@ -1020,6 +1033,7 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
 	if (kvm_is_realm(kvm) &&
 	    (kvm_realm_state(kvm) != REALM_STATE_DEAD &&
 	     kvm_realm_state(kvm) != REALM_STATE_NONE)) {
+		unmap_stage2_range(mmu, 0, (~0ULL) & PAGE_MASK);
 		write_unlock(&kvm->mmu_lock);
 		kvm_realm_destroy_rtts(kvm, pgt->ia_bits);
 		return;
@@ -1383,6 +1397,69 @@ static bool kvm_vma_mte_allowed(struct vm_area_struct *vma)
 	return vma->vm_flags & VM_MTE_ALLOWED;
 }
 
+static int realm_map_ipa(struct kvm *kvm, phys_addr_t ipa,
+			 kvm_pfn_t pfn, unsigned long map_size,
+			 enum kvm_pgtable_prot prot,
+			 struct kvm_mmu_memory_cache *memcache)
+{
+	struct realm *realm = &kvm->arch.realm;
+	struct page *page = pfn_to_page(pfn);
+
+	if (WARN_ON(!(prot & KVM_PGTABLE_PROT_W)))
+		return -EFAULT;
+
+	if (!realm_is_addr_protected(realm, ipa))
+		return realm_map_non_secure(realm, ipa, page, map_size,
+					    memcache);
+
+	return realm_map_protected(realm, ipa, page, map_size, memcache);
+}
+
+static int private_memslot_fault(struct kvm_vcpu *vcpu,
+				 phys_addr_t fault_ipa,
+				 struct kvm_memory_slot *memslot)
+{
+	struct kvm *kvm = vcpu->kvm;
+	gpa_t gpa_stolen_mask = kvm_gpa_stolen_bits(kvm);
+	gfn_t gfn = (fault_ipa & ~gpa_stolen_mask) >> PAGE_SHIFT;
+	bool is_priv_gfn = !((fault_ipa & gpa_stolen_mask) == gpa_stolen_mask);
+	bool priv_exists = kvm_mem_is_private(kvm, gfn);
+	struct kvm_mmu_memory_cache *memcache = &vcpu->arch.mmu_page_cache;
+	int order;
+	kvm_pfn_t pfn;
+	int ret;
+
+	if (priv_exists != is_priv_gfn) {
+		kvm_prepare_memory_fault_exit(vcpu,
+					      fault_ipa & ~gpa_stolen_mask,
+					      PAGE_SIZE,
+					      kvm_is_write_fault(vcpu),
+					      false, is_priv_gfn);
+
+		return 0;
+	}
+
+	if (!is_priv_gfn) {
+		/* Not a private mapping, handling normally */
+		return -EAGAIN;
+	}
+
+	if (kvm_gmem_get_pfn(kvm, memslot, gfn, &pfn, &order))
+		return 1; /* Retry */
+
+	ret = kvm_mmu_topup_memory_cache(memcache,
+					 kvm_mmu_cache_min_pages(vcpu->arch.hw_mmu));
+	if (ret)
+		return ret;
+
+	/* FIXME: Should be able to use bigger than PAGE_SIZE mappings */
+	ret = realm_map_ipa(kvm, fault_ipa, pfn, PAGE_SIZE, KVM_PGTABLE_PROT_W,
+			     memcache);
+	if (!ret)
+		return 1; /* Handled */
+	return ret;
+}
+
 static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			  struct kvm_memory_slot *memslot, unsigned long hva,
 			  bool fault_is_perm)
@@ -1402,10 +1479,19 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	long vma_pagesize, fault_granule;
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
 	struct kvm_pgtable *pgt;
+	gpa_t gpa_stolen_mask = kvm_gpa_stolen_bits(vcpu->kvm);
 
 	if (fault_is_perm)
 		fault_granule = kvm_vcpu_trap_get_perm_fault_granule(vcpu);
 	write_fault = kvm_is_write_fault(vcpu);
+
+	/*
+	 * Realms cannot map protected pages read-only
+	 * FIXME: It should be possible to map unprotected pages read-only
+	 */
+	if (vcpu_is_rec(vcpu))
+		write_fault = true;
+
 	exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
 	VM_BUG_ON(write_fault && exec_fault);
 
@@ -1478,7 +1564,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (vma_pagesize == PMD_SIZE || vma_pagesize == PUD_SIZE)
 		fault_ipa &= ~(vma_pagesize - 1);
 
-	gfn = fault_ipa >> PAGE_SHIFT;
+	gfn = (fault_ipa & ~gpa_stolen_mask) >> PAGE_SHIFT;
 	mte_allowed = kvm_vma_mte_allowed(vma);
 
 	vfio_allow_any_uc = vma->vm_flags & VM_ALLOW_ANY_UNCACHED;
@@ -1538,7 +1624,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 * If we are not forced to use page mapping, check if we are
 	 * backed by a THP and thus use block mapping if possible.
 	 */
-	if (vma_pagesize == PAGE_SIZE && !(force_pte || device)) {
+	/* FIXME: We shouldn't need to disable this for realms */
+	if (vma_pagesize == PAGE_SIZE && !(force_pte || device || kvm_is_realm(kvm))) {
 		if (fault_is_perm && fault_granule > PAGE_SIZE)
 			vma_pagesize = fault_granule;
 		else
@@ -1584,6 +1671,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 */
 	if (fault_is_perm && vma_pagesize == fault_granule)
 		ret = kvm_pgtable_stage2_relax_perms(pgt, fault_ipa, prot);
+	else if (kvm_is_realm(kvm))
+		ret = realm_map_ipa(kvm, fault_ipa, pfn, vma_pagesize,
+				    prot, memcache);
 	else
 		ret = kvm_pgtable_stage2_map(pgt, fault_ipa, vma_pagesize,
 					     __pfn_to_phys(pfn), prot,
@@ -1638,6 +1728,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 	struct kvm_memory_slot *memslot;
 	unsigned long hva;
 	bool is_iabt, write_fault, writable;
+	gpa_t gpa_stolen_mask = kvm_gpa_stolen_bits(vcpu->kvm);
 	gfn_t gfn;
 	int ret, idx;
 
@@ -1693,8 +1784,15 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 
 	idx = srcu_read_lock(&vcpu->kvm->srcu);
 
-	gfn = fault_ipa >> PAGE_SHIFT;
+	gfn = (fault_ipa & ~gpa_stolen_mask) >> PAGE_SHIFT;
 	memslot = gfn_to_memslot(vcpu->kvm, gfn);
+
+	if (kvm_slot_can_be_private(memslot)) {
+		ret = private_memslot_fault(vcpu, fault_ipa, memslot);
+		if (ret != -EAGAIN)
+			goto out;
+	}
+
 	hva = gfn_to_hva_memslot_prot(memslot, gfn, &writable);
 	write_fault = kvm_is_write_fault(vcpu);
 	if (kvm_is_error_hva(hva) || (write_fault && !writable)) {
@@ -1738,6 +1836,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 		 * of the page size.
 		 */
 		fault_ipa |= kvm_vcpu_get_hfar(vcpu) & ((1 << 12) - 1);
+		fault_ipa &= ~gpa_stolen_mask;
 		ret = io_mem_abort(vcpu, fault_ipa);
 		goto out_unlock;
 	}
@@ -1819,6 +1918,10 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	if (!kvm->arch.mmu.pgt)
 		return false;
 
+	/* We don't support aging for Realms */
+	if (kvm_is_realm(kvm))
+		return true;
+
 	return kvm_pgtable_stage2_test_clear_young(kvm->arch.mmu.pgt,
 						   range->start << PAGE_SHIFT,
 						   size, true);
@@ -1831,6 +1934,10 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	if (!kvm->arch.mmu.pgt)
 		return false;
 
+	/* We don't support aging for Realms */
+	if (kvm_is_realm(kvm))
+		return true;
+
 	return kvm_pgtable_stage2_test_clear_young(kvm->arch.mmu.pgt,
 						   range->start << PAGE_SHIFT,
 						   size, false);
diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
index 4aab507f896e..72f6f5f542c4 100644
--- a/arch/arm64/kvm/rme.c
+++ b/arch/arm64/kvm/rme.c
@@ -606,6 +606,170 @@ static int fold_rtt(struct realm *realm, unsigned long addr, int level)
 	return 0;
 }
 
+int realm_map_protected(struct realm *realm,
+			unsigned long base_ipa,
+			struct page *dst_page,
+			unsigned long map_size,
+			struct kvm_mmu_memory_cache *memcache)
+{
+	phys_addr_t dst_phys = page_to_phys(dst_page);
+	phys_addr_t rd = virt_to_phys(realm->rd);
+	unsigned long phys = dst_phys;
+	unsigned long ipa = base_ipa;
+	unsigned long size;
+	int map_level;
+	int ret = 0;
+
+	if (WARN_ON(!IS_ALIGNED(ipa, map_size)))
+		return -EINVAL;
+
+	switch (map_size) {
+	case PAGE_SIZE:
+		map_level = 3;
+		break;
+	case RME_L2_BLOCK_SIZE:
+		map_level = 2;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (map_level < RME_RTT_MAX_LEVEL) {
+		/*
+		 * A temporary RTT is needed during the map, precreate it,
+		 * however if there is an error (e.g. missing parent tables)
+		 * this will be handled below.
+		 */
+		realm_create_rtt_levels(realm, ipa, map_level,
+					RME_RTT_MAX_LEVEL, memcache);
+	}
+
+	for (size = 0; size < map_size; size += PAGE_SIZE) {
+		if (rmi_granule_delegate(phys)) {
+			struct rtt_entry rtt;
+
+			/*
+			 * It's possible we raced with another VCPU on the same
+			 * fault. If the entry exists and matches then exit
+			 * early and assume the other VCPU will handle the
+			 * mapping.
+			 */
+			if (rmi_rtt_read_entry(rd, ipa, RME_RTT_MAX_LEVEL, &rtt))
+				goto err;
+
+			// FIXME: For a block mapping this could race at level
+			// 2 or 3...
+			if (WARN_ON((rtt.walk_level != RME_RTT_MAX_LEVEL ||
+				     rtt.state != RMI_ASSIGNED ||
+				     rtt.desc != phys))) {
+				goto err;
+			}
+
+			return 0;
+		}
+
+		ret = rmi_data_create_unknown(rd, phys, ipa);
+
+		if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
+			/* Create missing RTTs and retry */
+			int level = RMI_RETURN_INDEX(ret);
+
+			ret = realm_create_rtt_levels(realm, ipa, level,
+						      RME_RTT_MAX_LEVEL,
+						      memcache);
+			WARN_ON(ret);
+			if (ret)
+				goto err_undelegate;
+
+			ret = rmi_data_create_unknown(rd, phys, ipa);
+		}
+		WARN_ON(ret);
+
+		if (ret)
+			goto err_undelegate;
+
+		phys += PAGE_SIZE;
+		ipa += PAGE_SIZE;
+	}
+
+	if (map_size == RME_L2_BLOCK_SIZE)
+		ret = fold_rtt(realm, base_ipa, map_level);
+	if (WARN_ON(ret))
+		goto err;
+
+	return 0;
+
+err_undelegate:
+	if (WARN_ON(rmi_granule_undelegate(phys))) {
+		/* Page can't be returned to NS world so is lost */
+		get_page(phys_to_page(phys));
+	}
+err:
+	while (size > 0) {
+		unsigned long data, top;
+
+		phys -= PAGE_SIZE;
+		size -= PAGE_SIZE;
+		ipa -= PAGE_SIZE;
+
+		WARN_ON(rmi_data_destroy(rd, ipa, &data, &top));
+
+		if (WARN_ON(rmi_granule_undelegate(phys))) {
+			/* Page can't be returned to NS world so is lost */
+			get_page(phys_to_page(phys));
+		}
+	}
+	return -ENXIO;
+}
+
+int realm_map_non_secure(struct realm *realm,
+			 unsigned long ipa,
+			 struct page *page,
+			 unsigned long map_size,
+			 struct kvm_mmu_memory_cache *memcache)
+{
+	phys_addr_t rd = virt_to_phys(realm->rd);
+	int map_level;
+	int ret = 0;
+	unsigned long desc = page_to_phys(page) |
+			     PTE_S2_MEMATTR(MT_S2_FWB_NORMAL) |
+			     /* FIXME: Read+Write permissions for now */
+			     (3 << 6) |
+			     PTE_SHARED;
+
+	if (WARN_ON(!IS_ALIGNED(ipa, map_size)))
+		return -EINVAL;
+
+	switch (map_size) {
+	case PAGE_SIZE:
+		map_level = 3;
+		break;
+	case RME_L2_BLOCK_SIZE:
+		map_level = 2;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	ret = rmi_rtt_map_unprotected(rd, ipa, map_level, desc);
+
+	if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
+		/* Create missing RTTs and retry */
+		int level = RMI_RETURN_INDEX(ret);
+
+		ret = realm_create_rtt_levels(realm, ipa, level, map_level,
+					      memcache);
+		if (WARN_ON(ret))
+			return -ENXIO;
+
+		ret = rmi_rtt_map_unprotected(rd, ipa, map_level, desc);
+	}
+	if (WARN_ON(ret))
+		return -ENXIO;
+
+	return 0;
+}
+
 static int populate_par_region(struct kvm *kvm,
 			       phys_addr_t ipa_base,
 			       phys_addr_t ipa_end,
@@ -617,7 +781,6 @@ static int populate_par_region(struct kvm *kvm,
 	int idx;
 	phys_addr_t ipa;
 	int ret = 0;
-	struct page *tmp_page;
 	unsigned long data_flags = 0;
 
 	base_gfn = gpa_to_gfn(ipa_base);
@@ -639,9 +802,8 @@ static int populate_par_region(struct kvm *kvm,
 		goto out;
 	}
 
-	tmp_page = alloc_page(GFP_KERNEL);
-	if (!tmp_page) {
-		ret = -ENOMEM;
+	if (!kvm_slot_can_be_private(memslot)) {
+		ret = -EINVAL;
 		goto out;
 	}
 
@@ -714,31 +876,36 @@ static int populate_par_region(struct kvm *kvm,
 		for (offset = 0; offset < map_size && !ret;
 		     offset += PAGE_SIZE, page++) {
 			phys_addr_t page_ipa = ipa + offset;
+			kvm_pfn_t priv_pfn;
+			int order;
 
-			ret = realm_create_protected_data_page(realm, page_ipa,
-							       page, tmp_page,
-							       data_flags);
+			ret = kvm_gmem_get_pfn(kvm, memslot,
+					       page_ipa >> PAGE_SHIFT,
+					       &priv_pfn, &order);
+			if (ret)
+				break;
+
+			ret = realm_create_protected_data_page(
+					realm, page_ipa,
+					pfn_to_page(priv_pfn),
+					page, data_flags);
 		}
+
+		kvm_release_pfn_clean(pfn);
+
 		if (ret)
-			goto err_release_pfn;
+			break;
 
 		if (level == 2) {
 			ret = fold_rtt(realm, ipa, level);
 			if (ret)
-				goto err_release_pfn;
+				break;
 		}
 
 		ipa += map_size;
-		kvm_release_pfn_dirty(pfn);
-err_release_pfn:
-		if (ret) {
-			kvm_release_pfn_clean(pfn);
-			break;
-		}
 	}
 
 	mmap_read_unlock(current->mm);
-	__free_page(tmp_page);
 
 out:
 	srcu_read_unlock(&kvm->srcu, idx);
-- 
2.34.1


