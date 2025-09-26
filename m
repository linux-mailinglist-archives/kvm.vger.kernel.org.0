Return-Path: <kvm+bounces-58863-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E2F94BA36E6
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 13:03:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 192791C21EC3
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 11:04:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80B892F60CF;
	Fri, 26 Sep 2025 11:03:19 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 426312F5A37;
	Fri, 26 Sep 2025 11:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758884599; cv=none; b=pUQvzPAxry4rk07QS7yFEau4WXbHb2AzR0GytV+BBgZjNEJbwUJawCHrDR0s9wwarZ7LgSptXt8CvjN8aOZhrjtIwb6wyon+J+UlHnsu82/3xey+1Y+FHYJ5siCeolGkNm2D0YOD6JMon41S8Yo8oat/Nm7/i6Evc5fpeb0mPoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758884599; c=relaxed/simple;
	bh=1yYA03/HqN70fbxtl1BIi+79f20zSTIKwy8XNZGzj34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZRR4e9TnjJwoBdQa8hffcSVjZkjgZjfzt3oOs4YM9X+DV5NI36Yblip67ol+8V4ccG7mf+3cVqxFkJ6zEpIwc4bQbbEBx4IU1y0JryxgoBSx7MVmpR4q4GY5cwB9yQAeK5dE0nE7ox6MtgrT80LDTByzYE3CO2tHTY/R9ApqlrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7674F1691;
	Fri, 26 Sep 2025 04:03:08 -0700 (PDT)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.38.22])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 15C0E3F66E;
	Fri, 26 Sep 2025 04:03:12 -0700 (PDT)
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Emi Kisanuki <fj0570is@fujitsu.com>,
	Vishal Annapurve <vannapurve@google.com>,
	Steven Price <steven.price@arm.com>
Subject: [RFC PATCH 2/5] arm64: RME: Handle auxiliary RTT trees
Date: Fri, 26 Sep 2025 12:02:51 +0100
Message-ID: <20250926110254.55449-3-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250926110254.55449-1-steven.price@arm.com>
References: <20250926110254.55449-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When a guest is executing with multiple planes, then faults from a plane
other than a primary plane can indicate that there are missing entries
in the auxiliary RTT trees that need to be populated. Handle this by
allocating the necessary tables.

The auxiliary trees also need to be handled when tearing down realm
resources, so in these cases iterate over the auxiliary trees to
perform the same operations as in the primary tree.

Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/include/asm/kvm_rme.h |   6 +
 arch/arm64/kvm/mmu.c             |  15 ++-
 arch/arm64/kvm/rme-exit.c        |   6 +-
 arch/arm64/kvm/rme.c             | 206 +++++++++++++++++++++++++++++--
 4 files changed, 213 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
index 3ed04b309cda..e5c0c8274bf8 100644
--- a/arch/arm64/include/asm/kvm_rme.h
+++ b/arch/arm64/include/asm/kvm_rme.h
@@ -54,6 +54,8 @@ enum realm_state {
  * @num_aux: The number of auxiliary pages required by the RMM
  * @vmid: VMID to be used by the RMM for the realm
  * @ia_bits: Number of valid Input Address bits in the IPA
+ * @num_aux_planes: Number of auxiliary planes
+ * @rtt_tree_pp: True if each plane has its own RTT tree
  */
 struct realm {
 	enum realm_state state;
@@ -64,6 +66,8 @@ struct realm {
 	unsigned long num_aux;
 	unsigned int vmid;
 	unsigned int ia_bits;
+	unsigned int num_aux_planes;
+	bool rtt_tree_pp;
 };
 
 /**
@@ -107,6 +111,8 @@ int kvm_rec_enter(struct kvm_vcpu *vcpu);
 int kvm_rec_pre_enter(struct kvm_vcpu *vcpu);
 int handle_rec_exit(struct kvm_vcpu *vcpu, int rec_run_status);
 
+int realm_aux_map(struct kvm_vcpu *vcpu, phys_addr_t ipa);
+
 void kvm_realm_unmap_range(struct kvm *kvm,
 			   unsigned long ipa,
 			   unsigned long size,
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index a36ece6c3bf2..a433926e214b 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1502,11 +1502,12 @@ static bool kvm_vma_mte_allowed(struct vm_area_struct *vma)
 	return vma->vm_flags & VM_MTE_ALLOWED;
 }
 
-static int realm_map_ipa(struct kvm *kvm, phys_addr_t ipa,
+static int realm_map_ipa(struct kvm_vcpu *vcpu, phys_addr_t ipa,
 			 kvm_pfn_t pfn, unsigned long map_size,
 			 enum kvm_pgtable_prot prot,
 			 struct kvm_mmu_memory_cache *memcache)
 {
+	struct kvm *kvm = vcpu->kvm;
 	struct realm *realm = &kvm->arch.realm;
 
 	/*
@@ -1517,6 +1518,14 @@ static int realm_map_ipa(struct kvm *kvm, phys_addr_t ipa,
 	if (WARN_ON(!(prot & KVM_PGTABLE_PROT_W)))
 		return -EFAULT;
 
+	if (vcpu->arch.rec.run->exit.rtt_tree > 0) {
+		int ret;
+
+		ret = realm_aux_map(vcpu, ipa);
+		if (ret <= 0)
+			return ret;
+	}
+
 	ipa = ALIGN_DOWN(ipa, PAGE_SIZE);
 	if (!kvm_realm_is_private_address(realm, ipa))
 		return realm_map_non_secure(realm, ipa, pfn, map_size,
@@ -1571,7 +1580,7 @@ static int private_memslot_fault(struct kvm_vcpu *vcpu,
 		return ret;
 
 	/* FIXME: Should be able to use bigger than PAGE_SIZE mappings */
-	ret = realm_map_ipa(kvm, fault_ipa, pfn, PAGE_SIZE, KVM_PGTABLE_PROT_W,
+	ret = realm_map_ipa(vcpu, fault_ipa, pfn, PAGE_SIZE, KVM_PGTABLE_PROT_W,
 			    memcache);
 	if (!ret)
 		return 1; /* Handled */
@@ -1917,7 +1926,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		prot &= ~KVM_NV_GUEST_MAP_SZ;
 		ret = KVM_PGT_FN(kvm_pgtable_stage2_relax_perms)(pgt, fault_ipa, prot, flags);
 	} else if (kvm_is_realm(kvm)) {
-		ret = realm_map_ipa(kvm, fault_ipa, pfn, vma_pagesize,
+		ret = realm_map_ipa(vcpu, fault_ipa, pfn, vma_pagesize,
 				    prot, memcache);
 	} else {
 		ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, fault_ipa, vma_pagesize,
diff --git a/arch/arm64/kvm/rme-exit.c b/arch/arm64/kvm/rme-exit.c
index 1a8ca7526863..04c8af8642af 100644
--- a/arch/arm64/kvm/rme-exit.c
+++ b/arch/arm64/kvm/rme-exit.c
@@ -44,11 +44,7 @@ static int rec_exit_sync_dabt(struct kvm_vcpu *vcpu)
 
 static int rec_exit_sync_iabt(struct kvm_vcpu *vcpu)
 {
-	struct realm_rec *rec = &vcpu->arch.rec;
-
-	vcpu_err(vcpu, "Unhandled instruction abort (ESR: %#llx).\n",
-		 rec->run->exit.esr);
-	return -ENXIO;
+	return kvm_handle_guest_abort(vcpu);
 }
 
 static int rec_exit_sys_reg(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
index 299473298720..c420546d26f3 100644
--- a/arch/arm64/kvm/rme.c
+++ b/arch/arm64/kvm/rme.c
@@ -225,6 +225,17 @@ static int realm_rtt_create(struct realm *realm,
 	return rmi_rtt_create(virt_to_phys(realm->rd), phys, addr, level);
 }
 
+static int realm_rtt_aux_create(struct realm *realm,
+				unsigned long addr,
+				int level,
+				phys_addr_t phys,
+				int rtt_tree_idx)
+{
+	addr = ALIGN_DOWN(addr, rme_rtt_level_mapsize(level - 1));
+	return rmi_rtt_aux_create(virt_to_phys(realm->rd), phys, addr, level,
+				  rtt_tree_idx);
+}
+
 static int realm_rtt_fold(struct realm *realm,
 			  unsigned long addr,
 			  int level,
@@ -244,13 +255,17 @@ static int realm_rtt_fold(struct realm *realm,
 
 static int realm_rtt_destroy(struct realm *realm, unsigned long addr,
 			     int level, phys_addr_t *rtt_granule,
-			     unsigned long *next_addr)
+			     unsigned long *next_addr, int rtt_tree_idx)
 {
 	unsigned long out_rtt;
 	int ret;
 
-	ret = rmi_rtt_destroy(virt_to_phys(realm->rd), addr, level,
-			      &out_rtt, next_addr);
+	if (rtt_tree_idx == 0)
+		ret = rmi_rtt_destroy(virt_to_phys(realm->rd), addr, level,
+				      &out_rtt, next_addr);
+	else
+		ret = rmi_rtt_aux_destroy(virt_to_phys(realm->rd), addr, level,
+					  rtt_tree_idx, &out_rtt, next_addr);
 
 	*rtt_granule = out_rtt;
 
@@ -289,8 +304,44 @@ static int realm_create_rtt_levels(struct realm *realm,
 	return 0;
 }
 
+static int realm_create_rtt_aux_levels(struct realm *realm,
+				       unsigned long ipa,
+				       int level,
+				       int max_level,
+				       int tree_idx,
+				       struct kvm_mmu_memory_cache *mc)
+{
+	if (level == max_level)
+		return 0;
+	if (tree_idx == 0)
+		return realm_create_rtt_levels(realm, ipa,
+					       level, max_level, mc);
+
+	while (level++ < max_level) {
+		phys_addr_t rtt = alloc_delegated_granule(mc);
+		int ret;
+
+		if (rtt == PHYS_ADDR_MAX)
+			return -ENOMEM;
+
+		ret = realm_rtt_aux_create(realm, ipa, level, rtt, tree_idx);
+
+		if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT_AUX &&
+		    RMI_RETURN_INDEX(ret) == level - 1) {
+			/* The RTT already exists, continue */
+			continue;
+		} else if (RMI_RETURN_STATUS(ret) != RMI_SUCCESS) {
+			free_delegated_granule(rtt);
+			return -ENXIO;
+		}
+	}
+
+	return 0;
+}
+
 static int realm_tear_down_rtt_level(struct realm *realm, int level,
-				     unsigned long start, unsigned long end)
+				     unsigned long start, unsigned long end,
+				     int rtt_tree_idx)
 {
 	ssize_t map_size;
 	unsigned long addr, next_addr;
@@ -315,20 +366,22 @@ static int realm_tear_down_rtt_level(struct realm *realm, int level,
 			ret = realm_tear_down_rtt_level(realm,
 							level + 1,
 							addr,
-							min(next_addr, end));
+							min(next_addr, end),
+							rtt_tree_idx);
 			if (ret)
 				return ret;
 			continue;
 		}
 
 		ret = realm_rtt_destroy(realm, addr, level,
-					&rtt_granule, &next_addr);
+					&rtt_granule, &next_addr, rtt_tree_idx);
 
 		switch (RMI_RETURN_STATUS(ret)) {
 		case RMI_SUCCESS:
 			free_rtt(rtt_granule);
 			break;
 		case RMI_ERROR_RTT:
+		case RMI_ERROR_RTT_AUX:
 			if (next_addr > addr) {
 				/* Missing RTT, skip */
 				break;
@@ -354,7 +407,8 @@ static int realm_tear_down_rtt_level(struct realm *realm, int level,
 			ret = realm_tear_down_rtt_level(realm,
 							level + 1,
 							addr,
-							next_addr);
+							next_addr,
+							rtt_tree_idx);
 			if (ret)
 				return ret;
 			/*
@@ -372,15 +426,52 @@ static int realm_tear_down_rtt_level(struct realm *realm, int level,
 	return 0;
 }
 
-static int realm_tear_down_rtt_range(struct realm *realm,
-				     unsigned long start, unsigned long end)
+static void realm_unmap_aux_unprotected(struct realm *realm,
+					unsigned long start,
+					unsigned long end,
+					int rtt_tree_idx)
 {
+	unsigned long rd = virt_to_phys(realm->rd);
+	unsigned long next;
+	int ret;
+
+	while (start < end) {
+		ret = rmi_rtt_aux_unmap_unprotected(rd, start, rtt_tree_idx,
+						    &next);
+
+		if (WARN_ON(ret))
+			return;
+
+		start = next;
+	}
+}
+
+static void realm_tear_down_rtt_range(struct realm *realm, u32 ia_bits,
+				      int rtt_tree_idx)
+{
+	int ret;
+	int sl = get_start_level(realm);
+	unsigned long end = 1UL << ia_bits;
+
+	if (rtt_tree_idx) {
+		unsigned long start = end >> 1;
+
+		/*
+		 * AUX trees cannot destroy the RTTs in the unprotected region,
+		 * instead we must unmap the region.
+		 */
+		realm_unmap_aux_unprotected(realm, start, end, rtt_tree_idx);
+		end = start;
+	}
+
 	/*
 	 * Root level RTTs can only be destroyed after the RD is destroyed. So
 	 * tear down everything below the root level
 	 */
-	return realm_tear_down_rtt_level(realm, get_start_level(realm) + 1,
-					 start, end);
+	ret = realm_tear_down_rtt_level(realm, sl + 1,
+					0, end, rtt_tree_idx);
+
+	WARN_ON(ret);
 }
 
 /*
@@ -443,7 +534,14 @@ void kvm_realm_destroy_rtts(struct kvm *kvm, u32 ia_bits)
 {
 	struct realm *realm = &kvm->arch.realm;
 
-	WARN_ON(realm_tear_down_rtt_range(realm, 0, (1UL << ia_bits)));
+	if (realm->rtt_tree_pp) {
+		int idx;
+
+		for (idx = 1; idx <= realm->num_aux_planes; idx++)
+			realm_tear_down_rtt_range(realm, ia_bits, idx);
+	}
+
+	realm_tear_down_rtt_range(realm, ia_bits, 0);
 }
 
 static int realm_destroy_private_granule(struct realm *realm,
@@ -476,6 +574,17 @@ static int realm_destroy_private_granule(struct realm *realm,
 			return -ENXIO;
 		}
 		goto retry;
+	} else if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT_AUX) {
+		int idx;
+
+		WARN_ON(!realm->rtt_tree_pp);
+
+		for (idx = 1; idx <= realm->num_aux_planes; idx++) {
+			ret = rmi_rtt_aux_unmap_protected(rd, ipa, idx, NULL);
+			if (WARN_ON(ret))
+				return -1;
+		}
+		goto retry;
 	} else if (WARN_ON(ret)) {
 		return -ENXIO;
 	}
@@ -1100,6 +1209,79 @@ static int populate_region(struct kvm *kvm,
 	return ret;
 }
 
+/*
+ * Return values:
+ *  0: Success
+ *  1: Primary RTT is invalid at IPA
+ * <0: Error
+ */
+int realm_aux_map(struct kvm_vcpu *vcpu, phys_addr_t ipa)
+{
+	int ret;
+	int level, max_level;
+	struct kvm_mmu_memory_cache *mc = &vcpu->arch.mmu_page_cache;
+	struct realm *realm = &vcpu->kvm->arch.realm;
+	phys_addr_t rd = virt_to_phys(realm->rd);
+	unsigned long rtt_tree_idx = vcpu->arch.rec.run->exit.rtt_tree;
+
+	kvm_mmu_topup_memory_cache(mc, kvm_mmu_cache_min_pages(vcpu->arch.hw_mmu));
+
+loop:
+	if (kvm_realm_is_private_address(realm, ipa)) {
+		ret = rmi_rtt_aux_map_protected(rd, ipa, rtt_tree_idx,
+						NULL, NULL);
+	} else {
+		int sl = get_start_level(realm);
+		unsigned long esr = vcpu->arch.rec.run->exit.esr;
+
+		if (WARN_ON(!esr_is_data_abort(esr) ||
+			    !esr_fsc_is_translation_fault(esr)))
+			return -EINVAL;
+
+		if ((esr & ESR_ELx_FSC) != ESR_ELx_FSC_FAULT_L(sl)) {
+			/*
+			 * Unprotected AUX RTT trees are shared. So if the
+			 * level is not at the start level the fault must be
+			 * due to a missing primary RTT (not an AUX RTT).
+			 */
+			return 1;
+		}
+		/* For the AUX RTT the IPA needs aligning to the start level. */
+		ipa = ALIGN_DOWN(ipa, rme_rtt_level_mapsize(sl));
+		ret = rmi_rtt_aux_map_unprotected(rd, ipa, rtt_tree_idx);
+	}
+
+	switch (RMI_RETURN_STATUS(ret)) {
+	case RMI_SUCCESS:
+		return 0;
+	case RMI_ERROR_RTT:
+		return 1;
+	case RMI_ERROR_RTT_AUX:
+		/*
+		 * Attempt to create RTTs and try again.
+		 * Try to block level first.
+		 */
+		level = RMI_RETURN_INDEX(ret);
+		if (level < RMM_RTT_BLOCK_LEVEL)
+			max_level = RMM_RTT_BLOCK_LEVEL;
+		else
+			max_level = RMM_RTT_MAX_LEVEL;
+
+		ret = realm_create_rtt_aux_levels(realm, ipa,
+						  level, max_level,
+						  rtt_tree_idx, mc);
+		if (WARN_ON(ret))
+			return -EIO;
+		goto loop;
+	default:
+		WARN_ON(1);
+		ret = -EIO;
+	}
+
+	WARN_ON(1);
+	return -EIO;
+}
+
 static int kvm_populate_realm(struct kvm *kvm,
 			      struct arm_rme_populate_realm *args)
 {
-- 
2.43.0


