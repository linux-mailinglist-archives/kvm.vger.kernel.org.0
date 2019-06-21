Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 338B14E417
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2019 11:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbfFUJkM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jun 2019 05:40:12 -0400
Received: from foss.arm.com ([217.140.110.172]:54184 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726773AbfFUJkL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jun 2019 05:40:11 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 98E5B147A;
        Fri, 21 Jun 2019 02:40:10 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (filthy-habits.cambridge.arm.com [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 445033F246;
        Fri, 21 Jun 2019 02:40:09 -0700 (PDT)
From:   Marc Zyngier <marc.zyngier@arm.com>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Julien Thierry <julien.thierry@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 37/59] KVM: arm64: nv: Handle shadow stage 2 page faults
Date:   Fri, 21 Jun 2019 10:38:21 +0100
Message-Id: <20190621093843.220980-38-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190621093843.220980-1-marc.zyngier@arm.com>
References: <20190621093843.220980-1-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Christoffer Dall <christoffer.dall@linaro.org>

If we are faulting on a shadow stage 2 translation, we first walk the
guest hypervisor's stage 2 page table to see if it has a mapping. If
not, we inject a stage 2 page fault to the virtual EL2. Otherwise, we
create a mapping in the shadow stage 2 page table.

Note that we have to deal with two IPAs when we got a showdow stage 2
page fault. One is the address we faulted on, and is in the L2 guest
phys space. The other is from the guest stage-2 page table walk, and is
in the L1 guest phys space.  To differentiate them, we rename variable
names so that fault_ipa is used for the former and ipa is used for the
latter.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_mmu.h       | 52 +++++++++++++++
 arch/arm64/include/asm/kvm_emulate.h |  6 ++
 arch/arm64/include/asm/kvm_nested.h  | 20 +++++-
 arch/arm64/kvm/nested.c              | 41 ++++++++++++
 virt/kvm/arm/mmio.c                  | 12 ++--
 virt/kvm/arm/mmu.c                   | 99 ++++++++++++++++++++++------
 6 files changed, 203 insertions(+), 27 deletions(-)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index e6984b6da2ce..afabf1fd1d17 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -423,6 +423,58 @@ static inline void kvm_set_ipa_limit(void) {}
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
index 73d8c54a52c6..b49a47f3daa8 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -606,4 +606,10 @@ static inline void __hyp_text __kvm_skip_instr(struct kvm_vcpu *vcpu)
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
index 686ba53379ab..052d46d96201 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -19,7 +19,7 @@ extern void kvm_vcpu_put_hw_mmu(struct kvm_vcpu *vcpu);
 
 struct kvm_s2_trans {
 	phys_addr_t output;
-	phys_addr_t block_size;
+	unsigned long block_size;
 	bool writable;
 	bool readable;
 	int level;
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
 extern bool forward_traps(struct kvm_vcpu *vcpu, u64 control_bit);
 extern bool forward_nv_traps(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 6a9bd68b769b..023027fa2db5 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -300,6 +300,8 @@ int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
 	u64 vtcr = vcpu_read_sys_reg(vcpu, VTCR_EL2);
 	struct s2_walk_info wi;
 
+	result->esr = 0;
+
 	if (!nested_virt_in_use(vcpu))
 		return 0;
 
@@ -415,6 +417,45 @@ void kvm_vcpu_put_hw_mmu(struct kvm_vcpu *vcpu)
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
index a8a6a0c883f1..2b5de8388bf4 100644
--- a/virt/kvm/arm/mmio.c
+++ b/virt/kvm/arm/mmio.c
@@ -142,7 +142,7 @@ static int decode_hsr(struct kvm_vcpu *vcpu, bool *is_write, int *len)
 }
 
 int io_mem_abort(struct kvm_vcpu *vcpu, struct kvm_run *run,
-		 phys_addr_t fault_ipa)
+		 phys_addr_t ipa)
 {
 	unsigned long data;
 	unsigned long rt;
@@ -171,22 +171,22 @@ int io_mem_abort(struct kvm_vcpu *vcpu, struct kvm_run *run,
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
 
 	if (!ret) {
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index faa61a81c8cc..3c7845832db8 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1384,7 +1384,8 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 	return ret;
 }
 
-static bool transparent_hugepage_adjust(kvm_pfn_t *pfnp, phys_addr_t *ipap)
+static bool transparent_hugepage_adjust(kvm_pfn_t *pfnp, phys_addr_t *ipap,
+					phys_addr_t *fault_ipap)
 {
 	kvm_pfn_t pfn = *pfnp;
 	gfn_t gfn = *ipap >> PAGE_SHIFT;
@@ -1418,6 +1419,7 @@ static bool transparent_hugepage_adjust(kvm_pfn_t *pfnp, phys_addr_t *ipap)
 		mask = PTRS_PER_PMD - 1;
 		VM_BUG_ON((gfn & mask) != (pfn & mask));
 		if (pfn & mask) {
+			*fault_ipap &= PMD_MASK;
 			*ipap &= PMD_MASK;
 			kvm_release_pfn_clean(pfn);
 			pfn &= ~mask;
@@ -1681,14 +1683,16 @@ static bool fault_supports_stage2_huge_mapping(struct kvm_memory_slot *memslot,
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
@@ -1697,6 +1701,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	bool logging_active = memslot_is_logging(memslot);
 	unsigned long vma_pagesize, flags = 0;
 	struct kvm_s2_mmu *mmu = vcpu->arch.hw_mmu;
+	unsigned long max_map_size = PUD_SIZE;
 
 	write_fault = kvm_is_write_fault(vcpu);
 	exec_fault = kvm_vcpu_trap_is_iabt(vcpu);
@@ -1717,11 +1722,26 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	}
 
 	vma_pagesize = vma_kernel_pagesize(vma);
-	if (logging_active ||
-	    !fault_supports_stage2_huge_mapping(memslot, hva, vma_pagesize)) {
-		force_pte = true;
-		vma_pagesize = PAGE_SIZE;
+
+	if (!fault_supports_stage2_huge_mapping(memslot, hva, vma_pagesize))
+		max_map_size = PAGE_SIZE;
+
+	if (logging_active)
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
@@ -1731,8 +1751,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
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
@@ -1784,7 +1805,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (mmu_notifier_retry(kvm, mmu_seq))
 		goto out_unlock;
 
-	if (vma_pagesize == PAGE_SIZE && !force_pte) {
+	if (vma_pagesize == PAGE_SIZE && max_map_size >= PMD_SIZE) {
 		/*
 		 * Only PMD_SIZE transparent hugepages(THP) are
 		 * currently supported. This code will need to be
@@ -1794,7 +1815,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		 * aligned and that the block is contained within the memslot.
 		 */
 		if (fault_supports_stage2_huge_mapping(memslot, hva, PMD_SIZE) &&
-		    transparent_hugepage_adjust(&pfn, &fault_ipa))
+		    transparent_hugepage_adjust(&pfn, &ipa, &fault_ipa))
 			vma_pagesize = PMD_SIZE;
 	}
 
@@ -1919,8 +1940,10 @@ static void handle_access_fault(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
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
@@ -1928,7 +1951,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu, struct kvm_run *run)
 
 	fault_status = kvm_vcpu_trap_get_fault_type(vcpu);
 
-	fault_ipa = kvm_vcpu_get_fault_ipa(vcpu);
+	ipa = fault_ipa = kvm_vcpu_get_fault_ipa(vcpu);
 	is_iabt = kvm_vcpu_trap_is_iabt(vcpu);
 
 	/* Synchronous External Abort? */
@@ -1952,6 +1975,12 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu, struct kvm_run *run)
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
@@ -1961,7 +1990,36 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu, struct kvm_run *run)
 
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
@@ -1995,13 +2053,13 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu, struct kvm_run *run)
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
@@ -2009,7 +2067,8 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		goto out_unlock;
 	}
 
-	ret = user_mem_abort(vcpu, fault_ipa, memslot, hva, fault_status);
+	ret = user_mem_abort(vcpu, fault_ipa, &nested_trans,
+			     memslot, hva, fault_status);
 	if (ret == 0)
 		ret = 1;
 out_unlock:
-- 
2.20.1

