Return-Path: <kvm+bounces-19683-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E58C2908DBD
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 16:46:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C8F611C219CF
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 14:46:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A27D2E401;
	Fri, 14 Jun 2024 14:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lRLVpSpv"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E10D17C79;
	Fri, 14 Jun 2024 14:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718376376; cv=none; b=FFeiQ2d1VfmQ8ZMzLO6hqJkfvGlyD6akIdf+RRxZ//Nz2usCQgIlLGqqsvtqLZ5YDym828sU9NufI9Fz9Q6e0RS95KfCwlEZkv+QoegsP3ieWkGGd1TKC1TcDrNl9+ILwmJhBxcFEj7tvwn+6QhnKmNZtXmmqVLU93GD9W475pU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718376376; c=relaxed/simple;
	bh=5LZqhDm9ONfXbn/UCdu4qz3vVb8uH5h0ErtLsyzASvI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nhRIZ8tipbGwlsDdsc80zt8+k883aQ2Hj7Yw/sy+viVjNfYrlbxhyimhtxYhT25E173TDKVhro5HxwOYd4M3IWG0/JnjAyLo/mzTkZedooHiZoCm1+Rr+3vChyeAqPZAjJmFZB2qBwvs7CGD+qdpYInXvxLyiasss12mhEp95V8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lRLVpSpv; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EA95C2BD10;
	Fri, 14 Jun 2024 14:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718376376;
	bh=5LZqhDm9ONfXbn/UCdu4qz3vVb8uH5h0ErtLsyzASvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lRLVpSpvoyCVdHh06oHKapBuTG8iiOgtEIc/YhjEw3MjBc7Tap6OK7IubH6ObTVA2
	 3keaX+shaVpKqFoCgv1ySBp9AQYUheT1SEzPNSRxeBi31pnzTgNVQtaTwrb5ReKVZg
	 M9o5jXbCDxhtxZ1tVVe1jkq4oSvXRdm4YGFVEPMfTWZnrti7lAqbiM46MIdiZT6ma0
	 kANda6aKwT9zhVYq9dVPNPZ7boHXdBcjrMMlNfJs81H/DHeFi6aJyVXz7irtNhBmVn
	 QQc5iYFJHOzDF9XzTf2+cemG5JkdfMGDXqvQv/qvmxN3ZrOLww77yg/MkxeEGtVhR4
	 JMhj6wUrp55BQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sI8By-003wb4-AZ;
	Fri, 14 Jun 2024 15:46:14 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: [PATCH v3 03/16] KVM: arm64: nv: Handle shadow stage 2 page faults
Date: Fri, 14 Jun 2024 15:45:39 +0100
Message-Id: <20240614144552.2773592-4-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240614144552.2773592-1-maz@kernel.org>
References: <20240614144552.2773592-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, alexandru.elisei@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

If we are faulting on a shadow stage 2 translation, we first walk the
guest hypervisor's stage 2 page table to see if it has a mapping. If
not, we inject a stage 2 page fault to the virtual EL2. Otherwise, we
create a mapping in the shadow stage 2 page table.

Note that we have to deal with two IPAs when we got a shadow stage 2
page fault. One is the address we faulted on, and is in the L2 guest
phys space. The other is from the guest stage-2 page table walk, and is
in the L1 guest phys space.  To differentiate them, we rename variables
so that fault_ipa is used for the former and ipa is used for the latter.

When mapping a page in a shadow stage-2, special care must be taken not
to be more permissive than the guest is.

Co-developed-by: Christoffer Dall <christoffer.dall@linaro.org>
Co-developed-by: Jintack Lim <jintack.lim@linaro.org>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_nested.h | 33 ++++++++++
 arch/arm64/kvm/mmu.c                | 97 ++++++++++++++++++++++++++---
 arch/arm64/kvm/nested.c             | 45 +++++++++++++
 3 files changed, 166 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 5404b7b843cf..82e0484ca26b 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -78,8 +78,41 @@ struct kvm_s2_trans {
 	u64 upper_attr;
 };
 
+static inline phys_addr_t kvm_s2_trans_output(struct kvm_s2_trans *trans)
+{
+	return trans->output;
+}
+
+static inline unsigned long kvm_s2_trans_size(struct kvm_s2_trans *trans)
+{
+	return trans->block_size;
+}
+
+static inline u32 kvm_s2_trans_esr(struct kvm_s2_trans *trans)
+{
+	return trans->esr;
+}
+
+static inline bool kvm_s2_trans_readable(struct kvm_s2_trans *trans)
+{
+	return trans->readable;
+}
+
+static inline bool kvm_s2_trans_writable(struct kvm_s2_trans *trans)
+{
+	return trans->writable;
+}
+
+static inline bool kvm_s2_trans_executable(struct kvm_s2_trans *trans)
+{
+	return !(trans->upper_attr & BIT(54));
+}
+
 extern int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
 			      struct kvm_s2_trans *result);
+extern int kvm_s2_handle_perm_fault(struct kvm_vcpu *vcpu,
+				    struct kvm_s2_trans *trans);
+extern int kvm_inject_s2_fault(struct kvm_vcpu *vcpu, u64 esr_el2);
 
 int kvm_init_nv_sysregs(struct kvm *kvm);
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 8984b7c213e1..5aed2e9d380d 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1407,6 +1407,7 @@ static bool kvm_vma_mte_allowed(struct vm_area_struct *vma)
 }
 
 static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
+			  struct kvm_s2_trans *nested,
 			  struct kvm_memory_slot *memslot, unsigned long hva,
 			  bool fault_is_perm)
 {
@@ -1415,6 +1416,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	bool exec_fault, mte_allowed;
 	bool device = false, vfio_allow_any_uc = false;
 	unsigned long mmu_seq;
+	phys_addr_t ipa = fault_ipa;
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_mmu_memory_cache *memcache = &vcpu->arch.mmu_page_cache;
 	struct vm_area_struct *vma;
@@ -1498,10 +1500,38 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	}
 
 	vma_pagesize = 1UL << vma_shift;
+
+	if (nested) {
+		unsigned long max_map_size;
+
+		max_map_size = force_pte ? PAGE_SIZE : PUD_SIZE;
+
+		ipa = kvm_s2_trans_output(nested);
+
+		/*
+		 * If we're about to create a shadow stage 2 entry, then we
+		 * can only create a block mapping if the guest stage 2 page
+		 * table uses at least as big a mapping.
+		 */
+		max_map_size = min(kvm_s2_trans_size(nested), max_map_size);
+
+		/*
+		 * Be careful that if the mapping size falls between
+		 * two host sizes, take the smallest of the two.
+		 */
+		if (max_map_size >= PMD_SIZE && max_map_size < PUD_SIZE)
+			max_map_size = PMD_SIZE;
+		else if (max_map_size >= PAGE_SIZE && max_map_size < PMD_SIZE)
+			max_map_size = PAGE_SIZE;
+
+		force_pte = (max_map_size == PAGE_SIZE);
+		vma_pagesize = min(vma_pagesize, (long)max_map_size);
+	}
+
 	if (vma_pagesize == PMD_SIZE || vma_pagesize == PUD_SIZE)
 		fault_ipa &= ~(vma_pagesize - 1);
 
-	gfn = fault_ipa >> PAGE_SHIFT;
+	gfn = ipa >> PAGE_SHIFT;
 	mte_allowed = kvm_vma_mte_allowed(vma);
 
 	vfio_allow_any_uc = vma->vm_flags & VM_ALLOW_ANY_UNCACHED;
@@ -1552,6 +1582,17 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (exec_fault && device)
 		return -ENOEXEC;
 
+	/*
+	 * Potentially reduce shadow S2 permissions to match the guest's own
+	 * S2. For exec faults, we'd only reach this point if the guest
+	 * actually allowed it (see kvm_s2_handle_perm_fault).
+	 */
+	if (nested) {
+		writable &= kvm_s2_trans_writable(nested);
+		if (!kvm_s2_trans_readable(nested))
+			prot &= ~KVM_PGTABLE_PROT_R;
+	}
+
 	read_lock(&kvm->mmu_lock);
 	pgt = vcpu->arch.hw_mmu->pgt;
 	if (mmu_invalidate_retry(kvm, mmu_seq)) {
@@ -1598,7 +1639,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			prot |= KVM_PGTABLE_PROT_NORMAL_NC;
 		else
 			prot |= KVM_PGTABLE_PROT_DEVICE;
-	} else if (cpus_have_final_cap(ARM64_HAS_CACHE_DIC)) {
+	} else if (cpus_have_final_cap(ARM64_HAS_CACHE_DIC) &&
+		   (!nested || kvm_s2_trans_executable(nested))) {
 		prot |= KVM_PGTABLE_PROT_X;
 	}
 
@@ -1658,8 +1700,10 @@ static void handle_access_fault(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
  */
 int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 {
+	struct kvm_s2_trans nested_trans, *nested = NULL;
 	unsigned long esr;
-	phys_addr_t fault_ipa;
+	phys_addr_t fault_ipa; /* The address we faulted on */
+	phys_addr_t ipa; /* Always the IPA in the L1 guest phys space */
 	struct kvm_memory_slot *memslot;
 	unsigned long hva;
 	bool is_iabt, write_fault, writable;
@@ -1668,7 +1712,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 
 	esr = kvm_vcpu_get_esr(vcpu);
 
-	fault_ipa = kvm_vcpu_get_fault_ipa(vcpu);
+	ipa = fault_ipa = kvm_vcpu_get_fault_ipa(vcpu);
 	is_iabt = kvm_vcpu_trap_is_iabt(vcpu);
 
 	if (esr_fsc_is_translation_fault(esr)) {
@@ -1718,7 +1762,42 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 
 	idx = srcu_read_lock(&vcpu->kvm->srcu);
 
-	gfn = fault_ipa >> PAGE_SHIFT;
+	/*
+	 * We may have faulted on a shadow stage 2 page table if we are
+	 * running a nested guest.  In this case, we have to resolve the L2
+	 * IPA to the L1 IPA first, before knowing what kind of memory should
+	 * back the L1 IPA.
+	 *
+	 * If the shadow stage 2 page table walk faults, then we simply inject
+	 * this to the guest and carry on.
+	 *
+	 * If there are no shadow S2 PTs because S2 is disabled, there is
+	 * nothing to walk and we treat it as a 1:1 before going through the
+	 * canonical translation.
+	 */
+	if (kvm_is_nested_s2_mmu(vcpu->kvm,vcpu->arch.hw_mmu) &&
+	    vcpu->arch.hw_mmu->nested_stage2_enabled) {
+		u32 esr;
+
+		ret = kvm_walk_nested_s2(vcpu, fault_ipa, &nested_trans);
+		if (ret) {
+			esr = kvm_s2_trans_esr(&nested_trans);
+			kvm_inject_s2_fault(vcpu, esr);
+			goto out_unlock;
+		}
+
+		ret = kvm_s2_handle_perm_fault(vcpu, &nested_trans);
+		if (ret) {
+			esr = kvm_s2_trans_esr(&nested_trans);
+			kvm_inject_s2_fault(vcpu, esr);
+			goto out_unlock;
+		}
+
+		ipa = kvm_s2_trans_output(&nested_trans);
+		nested = &nested_trans;
+	}
+
+	gfn = ipa >> PAGE_SHIFT;
 	memslot = gfn_to_memslot(vcpu->kvm, gfn);
 	hva = gfn_to_hva_memslot_prot(memslot, gfn, &writable);
 	write_fault = kvm_is_write_fault(vcpu);
@@ -1762,13 +1841,13 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 		 * faulting VA. This is always 12 bits, irrespective
 		 * of the page size.
 		 */
-		fault_ipa |= kvm_vcpu_get_hfar(vcpu) & ((1 << 12) - 1);
-		ret = io_mem_abort(vcpu, fault_ipa);
+		ipa |= kvm_vcpu_get_hfar(vcpu) & GENMASK(11, 0);
+		ret = io_mem_abort(vcpu, ipa);
 		goto out_unlock;
 	}
 
 	/* Userspace should not be able to register out-of-bounds IPAs */
-	VM_BUG_ON(fault_ipa >= kvm_phys_size(vcpu->arch.hw_mmu));
+	VM_BUG_ON(ipa >= kvm_phys_size(vcpu->arch.hw_mmu));
 
 	if (esr_fsc_is_access_flag_fault(esr)) {
 		handle_access_fault(vcpu, fault_ipa);
@@ -1776,7 +1855,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 		goto out_unlock;
 	}
 
-	ret = user_mem_abort(vcpu, fault_ipa, memslot, hva,
+	ret = user_mem_abort(vcpu, fault_ipa, nested, memslot, hva,
 			     esr_fsc_is_permission_fault(esr));
 	if (ret == 0)
 		ret = 1;
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 2fcfaeaeef98..1883276167d0 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -121,6 +121,15 @@ static u32 compute_fsc(int level, u32 fsc)
 	return fsc | (level & 0x3);
 }
 
+static int esr_s2_fault(struct kvm_vcpu *vcpu, int level, u32 fsc)
+{
+	u32 esr;
+
+	esr = kvm_vcpu_get_esr(vcpu) & ~ESR_ELx_FSC;
+	esr |= compute_fsc(level, fsc);
+	return esr;
+}
+
 static int get_ia_size(struct s2_walk_info *wi)
 {
 	return 64 - wi->t0sz;
@@ -482,6 +491,42 @@ void kvm_vcpu_put_hw_mmu(struct kvm_vcpu *vcpu)
 	}
 }
 
+/*
+ * Returns non-zero if permission fault is handled by injecting it to the next
+ * level hypervisor.
+ */
+int kvm_s2_handle_perm_fault(struct kvm_vcpu *vcpu, struct kvm_s2_trans *trans)
+{
+	bool forward_fault = false;
+
+	trans->esr = 0;
+
+	if (!kvm_vcpu_trap_is_permission_fault(vcpu))
+		return 0;
+
+	if (kvm_vcpu_trap_is_iabt(vcpu)) {
+		forward_fault = !kvm_s2_trans_executable(trans);
+	} else {
+		bool write_fault = kvm_is_write_fault(vcpu);
+
+		forward_fault = ((write_fault && !trans->writable) ||
+				 (!write_fault && !trans->readable));
+	}
+
+	if (forward_fault)
+		trans->esr = esr_s2_fault(vcpu, trans->level, ESR_ELx_FSC_PERM);
+
+	return forward_fault;
+}
+
+int kvm_inject_s2_fault(struct kvm_vcpu *vcpu, u64 esr_el2)
+{
+	vcpu_write_sys_reg(vcpu, vcpu->arch.fault.far_el2, FAR_EL2);
+	vcpu_write_sys_reg(vcpu, vcpu->arch.fault.hpfar_el2, HPFAR_EL2);
+
+	return kvm_inject_nested_sync(vcpu, esr_el2);
+}
+
 void kvm_arch_flush_shadow_all(struct kvm *kvm)
 {
 	int i;
-- 
2.39.2


