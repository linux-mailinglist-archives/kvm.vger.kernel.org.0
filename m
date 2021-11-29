Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E073F4621AE
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 21:08:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232731AbhK2ULU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 15:11:20 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:41984 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379878AbhK2UJS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Nov 2021 15:09:18 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C590CB81632
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 20:05:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35BDEC53FCF;
        Mon, 29 Nov 2021 20:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638216358;
        bh=kF1ZILcXVrn3bd3UFJOtJ+0jVXpzh/pOYlqmtkgNu9k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b6vFfZjlY4x8ixasujWNjpSGRqR52lKqGqzNlMXIkToQZx2QXWdBR83/NtgvTqLfT
         12iAAEDuOLuH+rL8vGBfJlTSVuaLOtHUG1hm4Y9LPiCZRzvfVGJD2YD/G0jtz63lDn
         hBCx7QmeBq7xRPBbBIWjW/iP+NeFT96WfL+uN8omDSaIYIcF7UPgJY5fMtfWYhm/CM
         0JkIJ97iQgaxiqraW23+Yu+OtmseC/G3bbAoicSsHq2tUd018tKm65B5+KEGJl4Lz5
         fdVeprxHzEkldCpr73CTt2zpKGbSRMH1bFh3GCEWV/L3Hu0j4p6jJcVVs81K8hrnUY
         Vf+7/AV5JEKsA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mrmqz-008gvR-HR; Mon, 29 Nov 2021 20:02:21 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Haibo Xu <haibo.xu@linaro.org>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: [PATCH v5 38/69] KVM: arm64: nv: Support multiple nested Stage-2 mmu structures
Date:   Mon, 29 Nov 2021 20:01:19 +0000
Message-Id: <20211129200150.351436-39-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211129200150.351436-1-maz@kernel.org>
References: <20211129200150.351436-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, jintack@cs.columbia.edu, haibo.xu@linaro.org, gankulkarni@os.amperecomputing.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add Stage-2 mmu data structures for virtual EL2 and for nested guests.
We don't yet populate shadow Stage-2 page tables, but we now have a
framework for getting to a shadow Stage-2 pgd.

We allocate twice the number of vcpus as Stage-2 mmu structures because
that's sufficient for each vcpu running two translation regimes without
having to flush the Stage-2 page tables.

Co-developed-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h   |  29 +++++
 arch/arm64/include/asm/kvm_mmu.h    |   9 ++
 arch/arm64/include/asm/kvm_nested.h |   7 +
 arch/arm64/kvm/arm.c                |  16 ++-
 arch/arm64/kvm/mmu.c                |  29 +++--
 arch/arm64/kvm/nested.c             | 195 ++++++++++++++++++++++++++++
 6 files changed, 275 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 6a7b13edc5cb..00c3366129b8 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -102,14 +102,43 @@ struct kvm_s2_mmu {
 	int __percpu *last_vcpu_ran;
 
 	struct kvm_arch *arch;
+
+	/*
+	 * For a shadow stage-2 MMU, the virtual vttbr programmed by the guest
+	 * hypervisor.  Unused for kvm_arch->mmu. Set to 1 when the structure
+	 * contains no valid information.
+	 */
+	u64	vttbr;
+
+	/* true when this represents a nested context where virtual HCR_EL2.VM == 1 */
+	bool	nested_stage2_enabled;
+
+	/*
+	 *  0: Nobody is currently using this, check vttbr for validity
+	 * >0: Somebody is actively using this.
+	 */
+	atomic_t refcnt;
 };
 
+static inline bool kvm_s2_mmu_valid(struct kvm_s2_mmu *mmu)
+{
+	return !(mmu->vttbr & 1);
+}
+
 struct kvm_arch_memory_slot {
 };
 
 struct kvm_arch {
 	struct kvm_s2_mmu mmu;
 
+	/*
+	 * Stage 2 paging stage for VMs with nested virtual using a virtual
+	 * VMID.
+	 */
+	struct kvm_s2_mmu *nested_mmus;
+	size_t nested_mmus_size;
+	int nested_mmus_next;
+
 	/* VTCR_EL2 value for this VM */
 	u64    vtcr;
 
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index c018c7b40761..7250594e3d68 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -116,6 +116,7 @@ alternative_cb_end
 #include <asm/cacheflush.h>
 #include <asm/mmu_context.h>
 #include <asm/kvm_emulate.h>
+#include <asm/kvm_nested.h>
 
 void kvm_update_va_mask(struct alt_instr *alt,
 			__le32 *origptr, __le32 *updptr, int nr_inst);
@@ -159,6 +160,7 @@ int create_hyp_exec_mappings(phys_addr_t phys_addr, size_t size,
 			     void **haddr);
 void free_hyp_pgds(void);
 
+void kvm_unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size);
 void stage2_unmap_vm(struct kvm *kvm);
 int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu);
 void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu);
@@ -294,5 +296,12 @@ static inline struct kvm *kvm_s2_mmu_to_kvm(struct kvm_s2_mmu *mmu)
 {
 	return container_of(mmu->arch, struct kvm, arch);
 }
+
+static inline u64 get_vmid(u64 vttbr)
+{
+	return (vttbr & VTTBR_VMID_MASK(kvm_get_vmid_bits())) >>
+		VTTBR_VMID_SHIFT;
+}
+
 #endif /* __ASSEMBLY__ */
 #endif /* __ARM64_KVM_MMU_H__ */
diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 026ddaad972c..473ecd1d60d0 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -61,6 +61,13 @@ static inline u64 translate_cnthctl_el2_to_cntkctl_el1(u64 cnthctl)
 		(cnthctl & (CNTHCTL_EVNTI | CNTHCTL_EVNTDIR | CNTHCTL_EVNTEN)));
 }
 
+extern void kvm_init_nested(struct kvm *kvm);
+extern int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu);
+extern void kvm_init_nested_s2_mmu(struct kvm_s2_mmu *mmu);
+extern struct kvm_s2_mmu *lookup_s2_mmu(struct kvm *kvm, u64 vttbr, u64 hcr);
+extern void kvm_vcpu_load_hw_mmu(struct kvm_vcpu *vcpu);
+extern void kvm_vcpu_put_hw_mmu(struct kvm_vcpu *vcpu);
+
 int handle_wfx_nested(struct kvm_vcpu *vcpu, bool is_wfe);
 extern bool __forward_traps(struct kvm_vcpu *vcpu, unsigned int reg,
 			    u64 control_bit);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 68da54d58cd0..1dbf63319b99 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -37,6 +37,7 @@
 #include <asm/kvm_arm.h>
 #include <asm/kvm_asm.h>
 #include <asm/kvm_mmu.h>
+#include <asm/kvm_nested.h>
 #include <asm/kvm_emulate.h>
 #include <asm/sections.h>
 
@@ -146,6 +147,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	if (ret)
 		return ret;
 
+	kvm_init_nested(kvm);
+
 	ret = create_hyp_mappings(kvm, kvm + 1, PAGE_HYP);
 	if (ret)
 		goto out_free_stage2_pgd;
@@ -389,6 +392,9 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	struct kvm_s2_mmu *mmu;
 	int *last_ran;
 
+	if (nested_virt_in_use(vcpu))
+		kvm_vcpu_load_hw_mmu(vcpu);
+
 	mmu = vcpu->arch.hw_mmu;
 	last_ran = this_cpu_ptr(mmu->last_vcpu_ran);
 
@@ -437,6 +443,9 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 	kvm_vgic_put(vcpu);
 	kvm_vcpu_pmu_restore_host(vcpu);
 
+	if (nested_virt_in_use(vcpu))
+		kvm_vcpu_put_hw_mmu(vcpu);
+
 	vcpu->cpu = -1;
 }
 
@@ -1088,8 +1097,13 @@ static int kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
 
 	vcpu->arch.target = phys_target;
 
+	/* Prepare for nested if required */
+	ret = kvm_vcpu_init_nested(vcpu);
+
 	/* Now we know what it is, we can reset it. */
-	ret = kvm_reset_vcpu(vcpu);
+	if (!ret)
+		ret = kvm_reset_vcpu(vcpu);
+
 	if (ret) {
 		vcpu->arch.target = -1;
 		bitmap_zero(vcpu->arch.features, KVM_VCPU_MAX_FEATURES);
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 9eec548fccd1..ab1653b8e601 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -162,7 +162,7 @@ static void invalidate_icache_guest_page(void *va, size_t size)
  * does.
  */
 /**
- * unmap_stage2_range -- Clear stage2 page table entries to unmap a range
+ * __unmap_stage2_range -- Clear stage2 page table entries to unmap a range
  * @mmu:   The KVM stage-2 MMU pointer
  * @start: The intermediate physical base address of the range to unmap
  * @size:  The size of the area to unmap
@@ -185,7 +185,7 @@ static void __unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64
 				   may_block));
 }
 
-static void unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size)
+void kvm_unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size)
 {
 	__unmap_stage2_range(mmu, start, size, true);
 }
@@ -507,7 +507,20 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu)
 	int cpu, err;
 	struct kvm_pgtable *pgt;
 
+	/*
+	 * If we already have our page tables in place, and that the
+	 * MMU context is the canonical one, we have a bug somewhere,
+	 * as this is only supposed to ever happen once per VM.
+	 *
+	 * Otherwise, we're building nested page tables, and that's
+	 * probably because userspace called KVM_ARM_VCPU_INIT more
+	 * than once on the same vcpu. Since that's actually legal,
+	 * don't kick a fuss and leave gracefully.
+	 */
 	if (mmu->pgt != NULL) {
+		if (&kvm->arch.mmu != mmu)
+			return 0;
+
 		kvm_err("kvm_arch already initialized?\n");
 		return -EINVAL;
 	}
@@ -533,6 +546,9 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu)
 	mmu->pgt = pgt;
 	mmu->pgd_phys = __pa(pgt->pgd);
 	WRITE_ONCE(mmu->vmid.vmid_gen, 0);
+
+	kvm_init_nested_s2_mmu(mmu);
+
 	return 0;
 
 out_destroy_pgtable:
@@ -578,7 +594,7 @@ static void stage2_unmap_memslot(struct kvm *kvm,
 
 		if (!(vma->vm_flags & VM_PFNMAP)) {
 			gpa_t gpa = addr + (vm_start - memslot->userspace_addr);
-			unmap_stage2_range(&kvm->arch.mmu, gpa, vm_end - vm_start);
+			kvm_unmap_stage2_range(&kvm->arch.mmu, gpa, vm_end - vm_start);
 		}
 		hva = vm_end;
 	} while (hva < reg_end);
@@ -1556,11 +1572,6 @@ void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen)
 {
 }
 
-void kvm_arch_flush_shadow_all(struct kvm *kvm)
-{
-	kvm_free_stage2_pgd(&kvm->arch.mmu);
-}
-
 void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 				   struct kvm_memory_slot *slot)
 {
@@ -1568,7 +1579,7 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 	phys_addr_t size = slot->npages << PAGE_SHIFT;
 
 	spin_lock(&kvm->mmu_lock);
-	unmap_stage2_range(&kvm->arch.mmu, gpa, size);
+	kvm_unmap_stage2_range(&kvm->arch.mmu, gpa, size);
 	spin_unlock(&kvm->mmu_lock);
 }
 
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 19b674983e13..b034a2343374 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -19,12 +19,189 @@
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
 
+#include <asm/kvm_arm.h>
 #include <asm/kvm_emulate.h>
+#include <asm/kvm_mmu.h>
 #include <asm/kvm_nested.h>
 #include <asm/sysreg.h>
 
 #include "sys_regs.h"
 
+void kvm_init_nested(struct kvm *kvm)
+{
+	kvm->arch.nested_mmus = NULL;
+	kvm->arch.nested_mmus_size = 0;
+}
+
+int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_s2_mmu *tmp;
+	int num_mmus;
+	int ret = -ENOMEM;
+
+	if (!test_bit(KVM_ARM_VCPU_HAS_EL2, vcpu->arch.features))
+		return 0;
+
+	if (!cpus_have_final_cap(ARM64_HAS_NESTED_VIRT))
+		return -EINVAL;
+
+	mutex_lock(&kvm->lock);
+
+	/*
+	 * Let's treat memory allocation failures as benign: If we fail to
+	 * allocate anything, return an error and keep the allocated array
+	 * alive. Userspace may try to recover by intializing the vcpu
+	 * again, and there is no reason to affect the whole VM for this.
+	 */
+	num_mmus = atomic_read(&kvm->online_vcpus) * 2;
+	tmp = krealloc(kvm->arch.nested_mmus,
+		       num_mmus * sizeof(*kvm->arch.nested_mmus),
+		       GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+	if (tmp) {
+		/*
+		 * If we went through a realocation, adjust the MMU
+		 * back-pointers in the previously initialised
+		 * pg_table structures.
+		 */
+		if (kvm->arch.nested_mmus != tmp) {
+			int i;
+
+			for (i = 0; i < num_mmus - 2; i++)
+				tmp[i].pgt->mmu = &tmp[i];
+		}
+
+		if (kvm_init_stage2_mmu(kvm, &tmp[num_mmus - 1]) ||
+		    kvm_init_stage2_mmu(kvm, &tmp[num_mmus - 2])) {
+			kvm_free_stage2_pgd(&tmp[num_mmus - 1]);
+			kvm_free_stage2_pgd(&tmp[num_mmus - 2]);
+		} else {
+			kvm->arch.nested_mmus_size = num_mmus;
+			ret = 0;
+		}
+
+		kvm->arch.nested_mmus = tmp;
+	}
+
+	mutex_unlock(&kvm->lock);
+	return ret;
+}
+
+/* Must be called with kvm->lock held */
+struct kvm_s2_mmu *lookup_s2_mmu(struct kvm *kvm, u64 vttbr, u64 hcr)
+{
+	bool nested_stage2_enabled = hcr & HCR_VM;
+	int i;
+
+	/* Don't consider the CnP bit for the vttbr match */
+	vttbr = vttbr & ~VTTBR_CNP_BIT;
+
+	/*
+	 * Two possibilities when looking up a S2 MMU context:
+	 *
+	 * - either S2 is enabled in the guest, and we need a context that
+         *   is S2-enabled and matches the full VTTBR (VMID+BADDR), which
+         *   makes it safe from a TLB conflict perspective (a broken guest
+         *   won't be able to generate them),
+	 *
+	 * - or S2 is disabled, and we need a context that is S2-disabled
+         *   and matches the VMID only, as all TLBs are tagged by VMID even
+         *   if S2 translation is enabled.
+	 */
+	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
+		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
+
+		if (!kvm_s2_mmu_valid(mmu))
+			continue;
+
+		if (nested_stage2_enabled &&
+		    mmu->nested_stage2_enabled &&
+		    vttbr == mmu->vttbr)
+			return mmu;
+
+		if (!nested_stage2_enabled &&
+		    !mmu->nested_stage2_enabled &&
+		    get_vmid(vttbr) == get_vmid(mmu->vttbr))
+			return mmu;
+	}
+	return NULL;
+}
+
+static struct kvm_s2_mmu *get_s2_mmu_nested(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+	u64 vttbr = vcpu_read_sys_reg(vcpu, VTTBR_EL2);
+	u64 hcr= vcpu_read_sys_reg(vcpu, HCR_EL2);
+	struct kvm_s2_mmu *s2_mmu;
+	int i;
+
+	s2_mmu = lookup_s2_mmu(kvm, vttbr, hcr);
+	if (s2_mmu)
+		goto out;
+
+	/*
+	 * Make sure we don't always search from the same point, or we
+	 * will always reuse a potentially active context, leaving
+	 * free contexts unused.
+	 */
+	for (i = kvm->arch.nested_mmus_next;
+	     i < (kvm->arch.nested_mmus_size + kvm->arch.nested_mmus_next);
+	     i++) {
+		s2_mmu = &kvm->arch.nested_mmus[i % kvm->arch.nested_mmus_size];
+
+		if (atomic_read(&s2_mmu->refcnt) == 0)
+			break;
+	}
+	BUG_ON(atomic_read(&s2_mmu->refcnt)); /* We have struct MMUs to spare */
+
+	/* Set the scene for the next search */
+	kvm->arch.nested_mmus_next = (i + 1) % kvm->arch.nested_mmus_size;
+
+	if (kvm_s2_mmu_valid(s2_mmu)) {
+		/* Clear the old state */
+		kvm_unmap_stage2_range(s2_mmu, 0, kvm_phys_size(kvm));
+		if (s2_mmu->vmid.vmid_gen)
+			kvm_call_hyp(__kvm_tlb_flush_vmid, s2_mmu);
+	}
+
+	/*
+	 * The virtual VMID (modulo CnP) will be used as a key when matching
+	 * an existing kvm_s2_mmu.
+	 */
+	s2_mmu->vttbr = vttbr & ~VTTBR_CNP_BIT;
+	s2_mmu->nested_stage2_enabled = hcr & HCR_VM;
+
+out:
+	atomic_inc(&s2_mmu->refcnt);
+	return s2_mmu;
+}
+
+void kvm_init_nested_s2_mmu(struct kvm_s2_mmu *mmu)
+{
+	mmu->vttbr = 1;
+	mmu->nested_stage2_enabled = false;
+	atomic_set(&mmu->refcnt, 0);
+}
+
+void kvm_vcpu_load_hw_mmu(struct kvm_vcpu *vcpu)
+{
+	if (is_hyp_ctxt(vcpu)) {
+		vcpu->arch.hw_mmu = &vcpu->kvm->arch.mmu;
+	} else {
+		spin_lock(&vcpu->kvm->mmu_lock);
+		vcpu->arch.hw_mmu = get_s2_mmu_nested(vcpu);
+		spin_unlock(&vcpu->kvm->mmu_lock);
+	}
+}
+
+void kvm_vcpu_put_hw_mmu(struct kvm_vcpu *vcpu)
+{
+	if (vcpu->arch.hw_mmu != &vcpu->kvm->arch.mmu) {
+		atomic_dec(&vcpu->arch.hw_mmu->refcnt);
+		vcpu->arch.hw_mmu = NULL;
+	}
+}
+
 /*
  * Inject wfx to the virtual EL2 if this is not from the virtual EL2 and
  * the virtual HCR_EL2.TWX is set. Otherwise, let the host hypervisor
@@ -43,6 +220,24 @@ int handle_wfx_nested(struct kvm_vcpu *vcpu, bool is_wfe)
 	return -EINVAL;
 }
 
+void kvm_arch_flush_shadow_all(struct kvm *kvm)
+{
+	int i;
+
+	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
+		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
+
+		WARN_ON(atomic_read(&mmu->refcnt));
+
+		if (!atomic_read(&mmu->refcnt))
+			kvm_free_stage2_pgd(mmu);
+	}
+	kfree(kvm->arch.nested_mmus);
+	kvm->arch.nested_mmus = NULL;
+	kvm->arch.nested_mmus_size = 0;
+	kvm_free_stage2_pgd(&kvm->arch.mmu);
+}
+
 /*
  * Our emulated CPU doesn't support all the possible features. For the
  * sake of simplicity (and probably mental sanity), wipe out a number
-- 
2.30.2

