Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FEDE1596A5
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 18:51:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730165AbgBKRvK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 12:51:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:53352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730085AbgBKRvJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 12:51:09 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A132F20661;
        Tue, 11 Feb 2020 17:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581443468;
        bh=Z3onEQv/IXIZ013PZdwmQdOHfXMbJRbewu8CHqkz7os=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GpBHejrSDUjNoXNcLBM8yMYdUM3B3eFduNz/xHkzG3De0iQxbdcDGA7R8R9GUr0mJ
         AOwZeHnpohFEN3Vc/aBrdQITAtjS9R2LC/TV1Pd6zGjT5D9E3JvII63Om0/Xxbt7LB
         IEHgEH6Uc0oHXjoBri7KqEPZ9y3hPZIaJm1ou5pU=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1j1Zfr-004O7k-1O; Tue, 11 Feb 2020 17:50:15 +0000
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
Subject: [PATCH v2 37/94] KVM: arm64: nv: Support multiple nested Stage-2 mmu structures
Date:   Tue, 11 Feb 2020 17:48:41 +0000
Message-Id: <20200211174938.27809-38-maz@kernel.org>
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
 arch/arm/include/asm/kvm_host.h     |   4 +
 arch/arm/include/asm/kvm_mmu.h      |   3 +
 arch/arm64/include/asm/kvm_host.h   |  29 +++++
 arch/arm64/include/asm/kvm_mmu.h    |   8 ++
 arch/arm64/include/asm/kvm_nested.h |   7 ++
 arch/arm64/kvm/nested.c             | 188 ++++++++++++++++++++++++++++
 virt/kvm/arm/arm.c                  |  16 ++-
 virt/kvm/arm/mmu.c                  |  24 ++--
 8 files changed, 268 insertions(+), 11 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index f43a68d8ea50..0a81c454a540 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -463,4 +463,8 @@ static inline bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu)
 	return true;
 }
 
+static inline void kvm_vcpu_load_hw_mmu(struct kvm_vcpu *vcpu) {}
+static inline void kvm_vcpu_put_hw_mmu(struct kvm_vcpu *vcpu) {}
+static inline int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu) { return 0; }
+
 #endif /* __ARM_KVM_HOST_H__ */
diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index 2d49950f8634..8727fde21b8f 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -420,6 +420,9 @@ static inline int hyp_map_aux_data(void)
 
 static inline int kvm_set_ipa_limit(void) { return 0; }
 
+static inline void kvm_init_s2_mmu(struct kvm_s2_mmu *mmu) {}
+static inline void kvm_init_nested(struct kvm *kvm) {}
+
 static __always_inline u64 kvm_get_vttbr(struct kvm_s2_mmu *mmu)
 {
 	struct kvm_vmid *vmid = &mmu->vmid;
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 42ca60c8b4c8..18e12d00c16d 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -77,11 +77,40 @@ struct kvm_s2_mmu {
 	phys_addr_t	pgd_phys;
 
 	struct kvm *kvm;
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
index ea1a597650f6..868e3386452f 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -89,6 +89,7 @@ alternative_cb_end
 #include <asm/mmu_context.h>
 #include <asm/pgtable.h>
 #include <asm/kvm_emulate.h>
+#include <asm/kvm_nested.h>
 
 void kvm_update_va_mask(struct alt_instr *alt,
 			__le32 *origptr, __le32 *updptr, int nr_inst);
@@ -154,6 +155,7 @@ int create_hyp_exec_mappings(phys_addr_t phys_addr, size_t size,
 			     void **haddr);
 void free_hyp_pgds(void);
 
+void kvm_unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size);
 void stage2_unmap_vm(struct kvm *kvm);
 int kvm_alloc_stage2_pgd(struct kvm_s2_mmu *mmu);
 void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu);
@@ -625,5 +627,11 @@ static __always_inline void __load_guest_stage2(struct kvm_s2_mmu *mmu)
 	asm(ALTERNATIVE("nop", "isb", ARM64_WORKAROUND_SPECULATIVE_AT_VHE));
 }
 
+static inline u64 get_vmid(u64 vttbr)
+{
+	return (vttbr & VTTBR_VMID_MASK(kvm_get_vmid_bits())) >>
+		VTTBR_VMID_SHIFT;
+}
+
 #endif /* __ASSEMBLY__ */
 #endif /* __ARM64_KVM_MMU_H__ */
diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index c258572b5ed4..88595447b598 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -10,6 +10,13 @@ static inline bool nested_virt_in_use(const struct kvm_vcpu *vcpu)
 		test_bit(KVM_ARM_VCPU_HAS_EL2, vcpu->arch.features);
 }
 
+extern void kvm_init_nested(struct kvm *kvm);
+extern int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu);
+extern void kvm_init_s2_mmu(struct kvm_s2_mmu *mmu);
+extern struct kvm_s2_mmu *lookup_s2_mmu(struct kvm *kvm, u64 vttbr, u64 hcr);
+extern void kvm_vcpu_load_hw_mmu(struct kvm_vcpu *vcpu);
+extern void kvm_vcpu_put_hw_mmu(struct kvm_vcpu *vcpu);
+
 int handle_wfx_nested(struct kvm_vcpu *vcpu, bool is_wfe);
 extern bool __forward_traps(struct kvm_vcpu *vcpu, unsigned int reg,
 			    u64 control_bit);
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index c40bf753ead9..65dbc1a796a1 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -19,12 +19,182 @@
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
+	if (!cpus_have_const_cap(ARM64_HAS_NESTED_VIRT))
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
+		       GFP_KERNEL | __GFP_ZERO);
+	if (tmp) {
+		tmp[num_mmus - 1].kvm = kvm;
+		atomic_set(&tmp[num_mmus - 1].refcnt, 0);
+		tmp[num_mmus - 2].kvm = kvm;
+		atomic_set(&tmp[num_mmus - 2].refcnt, 0);
+
+		if (kvm_alloc_stage2_pgd(&tmp[num_mmus - 1]) ||
+		    kvm_alloc_stage2_pgd(&tmp[num_mmus - 2])) {
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
+void kvm_init_s2_mmu(struct kvm_s2_mmu *mmu)
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
@@ -43,6 +213,24 @@ int handle_wfx_nested(struct kvm_vcpu *vcpu, bool is_wfe)
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
 #define FEATURE(x)	(GENMASK_ULL(x##_SHIFT + 3, x##_SHIFT))
 
 /*
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 0df8d281a7c6..dcd8d54d38ce 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -34,6 +34,7 @@
 #include <asm/kvm_arm.h>
 #include <asm/kvm_asm.h>
 #include <asm/kvm_mmu.h>
+#include <asm/kvm_nested.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_coproc.h>
 #include <asm/sections.h>
@@ -122,6 +123,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	if (ret)
 		goto out_fail_alloc;
 
+	kvm_init_nested(kvm);
+
 	ret = create_hyp_mappings(kvm, kvm + 1, PAGE_HYP);
 	if (ret)
 		goto out_free_stage2_pgd;
@@ -340,6 +343,9 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	int *last_ran;
 	kvm_host_data_t *cpu_data;
 
+	if (nested_virt_in_use(vcpu))
+		kvm_vcpu_load_hw_mmu(vcpu);
+
 	last_ran = this_cpu_ptr(vcpu->kvm->arch.last_vcpu_ran);
 	cpu_data = this_cpu_ptr(&kvm_host_data);
 
@@ -379,6 +385,9 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 	kvm_vgic_put(vcpu);
 	kvm_vcpu_pmu_restore_host(vcpu);
 
+	if (nested_virt_in_use(vcpu))
+		kvm_vcpu_put_hw_mmu(vcpu);
+
 	vcpu->cpu = -1;
 }
 
@@ -958,8 +967,13 @@ static int kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
 
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
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index ef46686da335..bead2ad59f7d 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -329,7 +329,7 @@ static void unmap_stage2_puds(struct kvm_s2_mmu *mmu, pgd_t *pgd,
 }
 
 /**
- * unmap_stage2_range -- Clear stage2 page table entries to unmap a range
+ * kvm_unmap_stage2_range -- Clear stage2 page table entries to unmap a range
  * @kvm:   The VM pointer
  * @start: The intermediate physical base address of the range to unmap
  * @size:  The size of the area to unmap
@@ -339,7 +339,7 @@ static void unmap_stage2_puds(struct kvm_s2_mmu *mmu, pgd_t *pgd,
  * destroying the VM), otherwise another faulting VCPU may come in and mess
  * with things behind our backs.
  */
-static void unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size)
+void kvm_unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size)
 {
 	struct kvm *kvm = mmu->kvm;
 	pgd_t *pgd;
@@ -928,6 +928,10 @@ int kvm_alloc_stage2_pgd(struct kvm_s2_mmu *mmu)
 
 	mmu->pgd = pgd;
 	mmu->pgd_phys = pgd_phys;
+	mmu->vmid.vmid_gen = 0;
+
+	kvm_init_s2_mmu(mmu);
+
 	return 0;
 }
 
@@ -966,7 +970,7 @@ static void stage2_unmap_memslot(struct kvm *kvm,
 
 		if (!(vma->vm_flags & VM_PFNMAP)) {
 			gpa_t gpa = addr + (vm_start - memslot->userspace_addr);
-			unmap_stage2_range(&kvm->arch.mmu, gpa, vm_end - vm_start);
+			kvm_unmap_stage2_range(&kvm->arch.mmu, gpa, vm_end - vm_start);
 		}
 		hva = vm_end;
 	} while (hva < reg_end);
@@ -1005,7 +1009,7 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
 
 	spin_lock(&kvm->mmu_lock);
 	if (mmu->pgd) {
-		unmap_stage2_range(mmu, 0, kvm_phys_size(kvm));
+		kvm_unmap_stage2_range(mmu, 0, kvm_phys_size(kvm));
 		pgd = READ_ONCE(mmu->pgd);
 		mmu->pgd = NULL;
 	}
@@ -1097,7 +1101,7 @@ static int stage2_set_pmd_huge(struct kvm_s2_mmu *mmu,
 		 * get handled accordingly.
 		 */
 		if (!pmd_thp_or_huge(old_pmd)) {
-			unmap_stage2_range(mmu, addr & S2_PMD_MASK, S2_PMD_SIZE);
+			kvm_unmap_stage2_range(mmu, addr & S2_PMD_MASK, S2_PMD_SIZE);
 			goto retry;
 		}
 		/*
@@ -1149,7 +1153,7 @@ static int stage2_set_pud_huge(struct kvm_s2_mmu *mmu,
 		 * the range for this block and retry.
 		 */
 		if (!stage2_pud_huge(kvm, old_pud)) {
-			unmap_stage2_range(mmu, addr & S2_PUD_MASK, S2_PUD_SIZE);
+			kvm_unmap_stage2_range(mmu, addr & S2_PUD_MASK, S2_PUD_SIZE);
 			goto retry;
 		}
 
@@ -2051,7 +2055,7 @@ static int handle_hva_to_gpa(struct kvm *kvm,
 
 static int kvm_unmap_hva_handler(struct kvm *kvm, gpa_t gpa, u64 size, void *data)
 {
-	unmap_stage2_range(&kvm->arch.mmu, gpa, size);
+	kvm_unmap_stage2_range(&kvm->arch.mmu, gpa, size);
 	return 0;
 }
 
@@ -2356,7 +2360,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 
 	spin_lock(&kvm->mmu_lock);
 	if (ret)
-		unmap_stage2_range(&kvm->arch.mmu, mem->guest_phys_addr, mem->memory_size);
+		kvm_unmap_stage2_range(&kvm->arch.mmu, mem->guest_phys_addr, mem->memory_size);
 	else
 		stage2_flush_memslot(&kvm->arch.mmu, memslot);
 	spin_unlock(&kvm->mmu_lock);
@@ -2380,7 +2384,7 @@ void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen)
 {
 }
 
-void kvm_arch_flush_shadow_all(struct kvm *kvm)
+__weak void kvm_arch_flush_shadow_all(struct kvm *kvm)
 {
 	kvm_free_stage2_pgd(&kvm->arch.mmu);
 }
@@ -2392,7 +2396,7 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 	phys_addr_t size = slot->npages << PAGE_SHIFT;
 
 	spin_lock(&kvm->mmu_lock);
-	unmap_stage2_range(&kvm->arch.mmu, gpa, size);
+	kvm_unmap_stage2_range(&kvm->arch.mmu, gpa, size);
 	spin_unlock(&kvm->mmu_lock);
 }
 
-- 
2.20.1

