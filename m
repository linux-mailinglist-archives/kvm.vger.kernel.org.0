Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58D1D1596A9
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 18:51:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730248AbgBKRvO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 12:51:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:53438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728935AbgBKRvO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 12:51:14 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BACA1206CC;
        Tue, 11 Feb 2020 17:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581443473;
        bh=nlXhKKJ34Rz7b0lfO28NB1NGDZ8MDge9YqsgbwjttLM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lMQDqkXyylqWVJB3WXIc9QU8MjkfA07meh0h1+JUfmTjizDwwpScrQC5EUy6N/mLr
         aF0jlkq5r5qrwOXmAKtR9Zo/rc6sOZGpAB1qnbUGUH20d9xAcIsnugV/br3lvQG3vk
         msALfpZzsDck2/20OAiLBtvekhLNJZC3HE9klI1g=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1j1Zfs-004O7k-9H; Tue, 11 Feb 2020 17:50:16 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v2 39/94] KVM: arm64: nv: Handle shadow stage 2 page faults
Date:   Tue, 11 Feb 2020 17:48:43 +0000
Message-Id: <20200211174938.27809-40-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200211174938.27809-1-maz@kernel.org>
References: <20200211174938.27809-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, Dave.Martin@arm.com, jintack@cs.columbia.edu, alexandru.elisei@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Christoffer Dall <christoffer.dall@linaro.org>

If we are faulting on a shadow stage 2 translation, we first walk the
guest hypervisor's stage 2 page table to see if it has a mapping. If
not, we inject a stage 2 page fault to the virtual EL2. Otherwise, we
create a mapping in the shadow stage 2 page table.

Note that we have to deal with two IPAs when we got a shadow stage 2
page fault. One is the address we faulted on, and is in the L2 guest
phys space. The other is from the guest stage-2 page table walk, and is
in the L1 guest phys space.  To differentiate them, we rename variables
so that fault_ipa is used for the former and ipa is used for the latter.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm/include/asm/kvm_mmu.h       | 52 +++++++++++++++
 arch/arm64/include/asm/kvm_emulate.h |  6 ++
 arch/arm64/include/asm/kvm_nested.h  | 18 ++++++
 arch/arm64/kvm/nested.c              | 39 ++++++++++++
 virt/kvm/arm/mmio.c                  | 14 ++---
 virt/kvm/arm/mmu.c                   | 94 ++++++++++++++++++++++------
 6 files changed, 197 insertions(+), 26 deletions(-)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index 8727fde21b8f..7f1fb496f435 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -423,6 +423,58 @@ static inline int kvm_set_ipa_limit(void) { return 0; }
 static inline void kvm_init_s2_mmu(struct kvm_s2_mmu *mmu) {}
 static inline void kvm_init_nested(struct kvm *kvm) {}
 
+struct kvm_s2_trans {};
+static inline phys_addr_t kvm_s2_trans_output(struct kvm_s2_trans *trans)
+{
+	BUG();
+}
+
+static inline unsigned long kvm_s2_trans_size(struct kvm_s2_trans *trans)
+{
+	BUG();
+}
+
+static inline u32 kvm_s2_trans_esr(struct kvm_s2_trans *trans)
+{
+	BUG();
+}
+
+static inline int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t ipa,
+				     struct kvm_s2_trans *trans)
+{
+	BUG();
+}
+
+static inline int kvm_s2_handle_perm_fault(struct kvm_vcpu *vcpu,
+					   struct kvm_s2_trans *trans)
+{
+	BUG();
+}
+
+static inline void kvm_inject_s2_fault(struct kvm_vcpu *vcpu, u32 esr)
+{
+	BUG();
+}
+
+static inline bool kvm_s2_trans_readable(struct kvm_s2_trans *trans)
+{
+	BUG();
+}
+
+static inline bool kvm_s2_trans_writable(struct kvm_s2_trans *trans)
+{
+	BUG();
+}
+
+static inline void kvm_nested_s2_flush(struct kvm *kvm) {}
+static inline void kvm_nested_s2_wp(struct kvm *kvm) {}
+static inline void kvm_nested_s2_clear(struct kvm *kvm) {}
+
+static inline bool kvm_is_shadow_s2_fault(struct kvm_vcpu *vcpu)
+{
+	return false;
+}
+
 static __always_inline u64 kvm_get_vttbr(struct kvm_s2_mmu *mmu)
 {
 	struct kvm_vmid *vmid = &mmu->vmid;
diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 0e5f88060ecc..1ccd98b5fead 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -684,4 +684,10 @@ static inline void __hyp_text __kvm_skip_instr(struct kvm_vcpu *vcpu)
 	write_sysreg_el2(*vcpu_pc(vcpu), SYS_ELR);
 }
 
+static inline bool kvm_is_shadow_s2_fault(struct kvm_vcpu *vcpu)
+{
+	return (vcpu->arch.hw_mmu != &vcpu->kvm->arch.mmu &&
+		vcpu->arch.hw_mmu->nested_stage2_enabled);
+}
+
 #endif /* __ARM64_KVM_EMULATE_H__ */
diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 3881e51d5a2d..b2bf82461fa6 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -27,9 +27,27 @@ struct kvm_s2_trans {
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
 extern int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
 			      struct kvm_s2_trans *result);
 
+extern int kvm_s2_handle_perm_fault(struct kvm_vcpu *vcpu,
+				    struct kvm_s2_trans *trans);
+extern int kvm_inject_s2_fault(struct kvm_vcpu *vcpu, u64 esr_el2);
 int handle_wfx_nested(struct kvm_vcpu *vcpu, bool is_wfe);
 extern bool __forward_traps(struct kvm_vcpu *vcpu, unsigned int reg,
 			    u64 control_bit);
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 573bcfcfe53f..361c3eb2032c 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -471,6 +471,45 @@ void kvm_vcpu_put_hw_mmu(struct kvm_vcpu *vcpu)
 	}
 }
 
+/*
+ * Returns non-zero if permission fault is handled by injecting it to the next
+ * level hypervisor.
+ */
+int kvm_s2_handle_perm_fault(struct kvm_vcpu *vcpu, struct kvm_s2_trans *trans)
+{
+	unsigned long fault_status = kvm_vcpu_trap_get_fault_type(vcpu);
+	bool forward_fault = false;
+
+	trans->esr = 0;
+
+	if (fault_status != FSC_PERM)
+		return 0;
+
+	if (kvm_vcpu_trap_is_iabt(vcpu)) {
+		forward_fault = (trans->upper_attr & PTE_S2_XN);
+	} else {
+		bool write_fault = kvm_is_write_fault(vcpu);
+
+		forward_fault = ((write_fault && !trans->writable) ||
+				 (!write_fault && !trans->readable));
+	}
+
+	if (forward_fault) {
+		trans->esr = esr_s2_fault(vcpu, trans->level, ESR_ELx_FSC_PERM);
+		return 1;
+	}
+
+	return 0;
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
 /*
  * Inject wfx to the virtual EL2 if this is not from the virtual EL2 and
  * the virtual HCR_EL2.TWX is set. Otherwise, let the host hypervisor
diff --git a/virt/kvm/arm/mmio.c b/virt/kvm/arm/mmio.c
index aedfcff99ac5..7ac7b1eac1ac 100644
--- a/virt/kvm/arm/mmio.c
+++ b/virt/kvm/arm/mmio.c
@@ -120,7 +120,7 @@ int kvm_handle_mmio_return(struct kvm_vcpu *vcpu, struct kvm_run *run)
 }
 
 int io_mem_abort(struct kvm_vcpu *vcpu, struct kvm_run *run,
-		 phys_addr_t fault_ipa)
+		 phys_addr_t ipa)
 {
 	unsigned long data;
 	unsigned long rt;
@@ -137,7 +137,7 @@ int io_mem_abort(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		if (vcpu->kvm->arch.return_nisv_io_abort_to_user) {
 			run->exit_reason = KVM_EXIT_ARM_NISV;
 			run->arm_nisv.esr_iss = kvm_vcpu_dabt_iss_nisv_sanitized(vcpu);
-			run->arm_nisv.fault_ipa = fault_ipa;
+			run->arm_nisv.fault_ipa = ipa;
 			return 0;
 		}
 
@@ -164,22 +164,22 @@ int io_mem_abort(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		data = vcpu_data_guest_to_host(vcpu, vcpu_get_reg(vcpu, rt),
 					       len);
 
-		trace_kvm_mmio(KVM_TRACE_MMIO_WRITE, len, fault_ipa, &data);
+		trace_kvm_mmio(KVM_TRACE_MMIO_WRITE, len, ipa, &data);
 		kvm_mmio_write_buf(data_buf, len, data);
 
-		ret = kvm_io_bus_write(vcpu, KVM_MMIO_BUS, fault_ipa, len,
+		ret = kvm_io_bus_write(vcpu, KVM_MMIO_BUS, ipa, len,
 				       data_buf);
 	} else {
 		trace_kvm_mmio(KVM_TRACE_MMIO_READ_UNSATISFIED, len,
-			       fault_ipa, NULL);
+			       ipa, NULL);
 
-		ret = kvm_io_bus_read(vcpu, KVM_MMIO_BUS, fault_ipa, len,
+		ret = kvm_io_bus_read(vcpu, KVM_MMIO_BUS, ipa, len,
 				      data_buf);
 	}
 
 	/* Now prepare kvm_run for the potential return to userland. */
 	run->mmio.is_write	= is_write;
-	run->mmio.phys_addr	= fault_ipa;
+	run->mmio.phys_addr	= ipa;
 	run->mmio.len		= len;
 	vcpu->mmio_needed	= 1;
 
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index bead2ad59f7d..c6db597b925c 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1388,7 +1388,8 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 	return ret;
 }
 
-static bool transparent_hugepage_adjust(kvm_pfn_t *pfnp, phys_addr_t *ipap)
+static bool transparent_hugepage_adjust(kvm_pfn_t *pfnp, phys_addr_t *ipap,
+					phys_addr_t *fault_ipap)
 {
 	kvm_pfn_t pfn = *pfnp;
 	gfn_t gfn = *ipap >> PAGE_SHIFT;
@@ -1416,6 +1417,7 @@ static bool transparent_hugepage_adjust(kvm_pfn_t *pfnp, phys_addr_t *ipap)
 		mask = PTRS_PER_PMD - 1;
 		VM_BUG_ON((gfn & mask) != (pfn & mask));
 		if (pfn & mask) {
+			*fault_ipap &= PMD_MASK;
 			*ipap &= PMD_MASK;
 			kvm_release_pfn_clean(pfn);
 			pfn &= ~mask;
@@ -1671,14 +1673,16 @@ static bool fault_supports_stage2_huge_mapping(struct kvm_memory_slot *memslot,
 }
 
 static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
-			  struct kvm_memory_slot *memslot, unsigned long hva,
-			  unsigned long fault_status)
+			  struct kvm_s2_trans *nested,
+			  struct kvm_memory_slot *memslot,
+			  unsigned long hva, unsigned long fault_status)
 {
 	int ret;
-	bool write_fault, writable, force_pte = false;
+	bool write_fault, writable;
 	bool exec_fault, needs_exec;
 	unsigned long mmu_seq;
-	gfn_t gfn = fault_ipa >> PAGE_SHIFT;
+	phys_addr_t ipa = fault_ipa;
+	gfn_t gfn;
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_mmu_memory_cache *memcache = &vcpu->arch.mmu_page_cache;
 	struct vm_area_struct *vma;
@@ -1688,6 +1692,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	bool logging_active = memslot_is_logging(memslot);
 	unsigned long vma_pagesize, flags = 0;
 	struct kvm_s2_mmu *mmu = vcpu->arch.hw_mmu;
+	unsigned long max_map_size = PUD_SIZE;
 
 	write_fault = kvm_is_write_fault(vcpu);
 	exec_fault = kvm_vcpu_trap_is_iabt(vcpu);
@@ -1715,10 +1720,22 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	vma_pagesize = 1ULL << vma_shift;
 	if (logging_active ||
 	    (vma->vm_flags & VM_PFNMAP) ||
-	    !fault_supports_stage2_huge_mapping(memslot, hva, vma_pagesize)) {
-		force_pte = true;
-		vma_pagesize = PAGE_SIZE;
+	    !fault_supports_stage2_huge_mapping(memslot, hva, vma_pagesize))
+		max_map_size = PAGE_SIZE;
+
+	if (kvm_is_shadow_s2_fault(vcpu)) {
+		ipa = kvm_s2_trans_output(nested);
+
+		/*
+		 * If we're about to create a shadow stage 2 entry, then we
+		 * can only create a block mapping if the guest stage 2 page
+		 * table uses at least as big a mapping.
+		 */
+		max_map_size = min(kvm_s2_trans_size(nested), max_map_size);
 	}
+	gfn = ipa >> PAGE_SHIFT;
+
+	vma_pagesize = min(vma_pagesize, max_map_size);
 
 	/*
 	 * The stage2 has a minimum of 2 level table (For arm64 see
@@ -1728,8 +1745,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 * 3 levels, i.e, PMD is not folded.
 	 */
 	if (vma_pagesize == PMD_SIZE ||
-	    (vma_pagesize == PUD_SIZE && kvm_stage2_has_pmd(kvm)))
-		gfn = (fault_ipa & huge_page_mask(hstate_vma(vma))) >> PAGE_SHIFT;
+	    (vma_pagesize == PUD_SIZE && kvm_stage2_has_pmd(kvm))) {
+		gfn = (ipa & huge_page_mask(hstate_vma(vma))) >> PAGE_SHIFT;
+	}
 	up_read(&current->mm->mmap_sem);
 
 	/* We need minimum second+third level pages */
@@ -1784,7 +1802,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (mmu_notifier_retry(kvm, mmu_seq))
 		goto out_unlock;
 
-	if (vma_pagesize == PAGE_SIZE && !force_pte) {
+	if (vma_pagesize == PAGE_SIZE && max_map_size >= PMD_SIZE) {
 		/*
 		 * Only PMD_SIZE transparent hugepages(THP) are
 		 * currently supported. This code will need to be
@@ -1794,7 +1812,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		 * aligned and that the block is contained within the memslot.
 		 */
 		if (fault_supports_stage2_huge_mapping(memslot, hva, PMD_SIZE) &&
-		    transparent_hugepage_adjust(&pfn, &fault_ipa))
+		    transparent_hugepage_adjust(&pfn, &ipa, &fault_ipa))
 			vma_pagesize = PMD_SIZE;
 	}
 
@@ -1919,8 +1937,10 @@ static void handle_access_fault(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
 int kvm_handle_guest_abort(struct kvm_vcpu *vcpu, struct kvm_run *run)
 {
 	unsigned long fault_status;
-	phys_addr_t fault_ipa;
+	phys_addr_t fault_ipa; /* The address we faulted on */
+	phys_addr_t ipa; /* Always the IPA in the L1 guest phys space */
 	struct kvm_memory_slot *memslot;
+	struct kvm_s2_trans nested_trans;
 	unsigned long hva;
 	bool is_iabt, write_fault, writable;
 	gfn_t gfn;
@@ -1928,7 +1948,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu, struct kvm_run *run)
 
 	fault_status = kvm_vcpu_trap_get_fault_type(vcpu);
 
-	fault_ipa = kvm_vcpu_get_fault_ipa(vcpu);
+	ipa = fault_ipa = kvm_vcpu_get_fault_ipa(vcpu);
 	is_iabt = kvm_vcpu_trap_is_iabt(vcpu);
 
 	/* Synchronous External Abort? */
@@ -1952,6 +1972,12 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	/* Check the stage-2 fault is trans. fault or write fault */
 	if (fault_status != FSC_FAULT && fault_status != FSC_PERM &&
 	    fault_status != FSC_ACCESS) {
+		/*
+		 * We must never see an address size fault on shadow stage 2
+		 * page table walk, because we would have injected an addr
+		 * size fault when we walked the nested s2 page and not
+		 * create the shadow entry.
+		 */
 		kvm_err("Unsupported FSC: EC=%#x xFSC=%#lx ESR_EL2=%#lx\n",
 			kvm_vcpu_trap_get_class(vcpu),
 			(unsigned long)kvm_vcpu_trap_get_fault(vcpu),
@@ -1961,7 +1987,36 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu, struct kvm_run *run)
 
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
+	 */
+	if (kvm_is_shadow_s2_fault(vcpu)) {
+		u32 esr;
+
+		ret = kvm_walk_nested_s2(vcpu, fault_ipa, &nested_trans);
+		esr = kvm_s2_trans_esr(&nested_trans);
+		if (esr)
+			kvm_inject_s2_fault(vcpu, esr);
+		if (ret)
+			goto out_unlock;
+
+		ret = kvm_s2_handle_perm_fault(vcpu, &nested_trans);
+		esr = kvm_s2_trans_esr(&nested_trans);
+		if (esr)
+			kvm_inject_s2_fault(vcpu, esr);
+		if (ret)
+			goto out_unlock;
+
+		ipa = kvm_s2_trans_output(&nested_trans);
+	}
+
+	gfn = ipa >> PAGE_SHIFT;
 	memslot = gfn_to_memslot(vcpu->kvm, gfn);
 	hva = gfn_to_hva_memslot_prot(memslot, gfn, &writable);
 	write_fault = kvm_is_write_fault(vcpu);
@@ -1994,13 +2049,13 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		 * faulting VA. This is always 12 bits, irrespective
 		 * of the page size.
 		 */
-		fault_ipa |= kvm_vcpu_get_hfar(vcpu) & ((1 << 12) - 1);
-		ret = io_mem_abort(vcpu, run, fault_ipa);
+		ipa |= kvm_vcpu_get_hfar(vcpu) & ((1 << 12) - 1);
+		ret = io_mem_abort(vcpu, run, ipa);
 		goto out_unlock;
 	}
 
 	/* Userspace should not be able to register out-of-bounds IPAs */
-	VM_BUG_ON(fault_ipa >= kvm_phys_size(vcpu->kvm));
+	VM_BUG_ON(ipa >= kvm_phys_size(vcpu->kvm));
 
 	if (fault_status == FSC_ACCESS) {
 		handle_access_fault(vcpu, fault_ipa);
@@ -2008,7 +2063,8 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		goto out_unlock;
 	}
 
-	ret = user_mem_abort(vcpu, fault_ipa, memslot, hva, fault_status);
+	ret = user_mem_abort(vcpu, fault_ipa, &nested_trans,
+			     memslot, hva, fault_status);
 	if (ret == 0)
 		ret = 1;
 out:
-- 
2.20.1

