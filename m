Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1762D60F7
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 17:04:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403931AbgLJQEU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 11:04:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:32872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391139AbgLJQEG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 11:04:06 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC79A23D56;
        Thu, 10 Dec 2020 16:03:24 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1knONb-0008Di-43; Thu, 10 Dec 2020 16:01:19 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com
Subject: [PATCH v3 46/66] KVM: arm64: nv: Nested GICv3 Support
Date:   Thu, 10 Dec 2020 15:59:42 +0000
Message-Id: <20201210160002.1407373-47-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210160002.1407373-1-maz@kernel.org>
References: <20201210160002.1407373-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, jintack@cs.columbia.edu, alexandru.elisei@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jintack Lim <jintack@cs.columbia.edu>

When entering a nested VM, we set up the hypervisor control interface
based on what the guest hypervisor has set. Especially, we investigate
each list register written by the guest hypervisor whether HW bit is
set.  If so, we translate hw irq number from the guest's point of view
to the real hardware irq number if there is a mapping.

Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
[Rewritten to support GICv3 instead of GICv2]
Signed-off-by: Marc Zyngier <maz@kernel.org>
[Redesigned execution flow around vcpu load/put]
Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
---
 arch/arm64/include/asm/kvm_emulate.h |   8 +-
 arch/arm64/include/asm/kvm_host.h    |   9 +-
 arch/arm64/include/asm/kvm_nested.h  |   1 +
 arch/arm64/kvm/Makefile              |   2 +-
 arch/arm64/kvm/arm.c                 |  13 +-
 arch/arm64/kvm/nested.c              |  16 +++
 arch/arm64/kvm/sys_regs.c            | 179 ++++++++++++++++++++++++++-
 arch/arm64/kvm/vgic/vgic-v3-nested.c | 178 ++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic-v3.c        |  26 ++++
 arch/arm64/kvm/vgic/vgic.c           |  27 ++++
 include/kvm/arm_vgic.h               |  18 +++
 11 files changed, 468 insertions(+), 9 deletions(-)
 create mode 100644 arch/arm64/kvm/vgic/vgic-v3-nested.c

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index b447817d9dee..44b395854430 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -497,7 +497,13 @@ static inline bool kvm_is_write_fault(struct kvm_vcpu *vcpu)
 
 static inline unsigned long kvm_vcpu_get_mpidr_aff(struct kvm_vcpu *vcpu)
 {
-	return vcpu_read_sys_reg(vcpu, MPIDR_EL1) & MPIDR_HWID_BITMASK;
+	/*
+	 * Use the in-memory view for MPIDR_EL1. It can't be changed by the
+	 * guest, and is also accessed from the context of *another* vcpu,
+	 * so anything using some other state (such as the NV state that is
+	 * used by vcpu_read_sys_reg) will eventually go wrong.
+	 */
+	return __vcpu_sys_reg(vcpu, MPIDR_EL1) & MPIDR_HWID_BITMASK;
 }
 
 static inline void kvm_vcpu_set_be(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index f3743e45ded1..bd91b4219d5e 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -42,10 +42,11 @@
 
 #define KVM_REQ_SLEEP \
 	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
-#define KVM_REQ_IRQ_PENDING	KVM_ARCH_REQ(1)
-#define KVM_REQ_VCPU_RESET	KVM_ARCH_REQ(2)
-#define KVM_REQ_RECORD_STEAL	KVM_ARCH_REQ(3)
-#define KVM_REQ_RELOAD_GICv4	KVM_ARCH_REQ(4)
+#define KVM_REQ_IRQ_PENDING		KVM_ARCH_REQ(1)
+#define KVM_REQ_VCPU_RESET		KVM_ARCH_REQ(2)
+#define KVM_REQ_RECORD_STEAL		KVM_ARCH_REQ(3)
+#define KVM_REQ_RELOAD_GICv4		KVM_ARCH_REQ(4)
+#define KVM_REQ_GUEST_HYP_IRQ_PENDING	KVM_ARCH_REQ(5)
 
 #define KVM_DIRTY_LOG_MANUAL_CAPS   (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE | \
 				     KVM_DIRTY_LOG_INITIALLY_SET)
diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 2987806850f0..5fa3c634c8e1 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -67,6 +67,7 @@ extern void kvm_init_nested_s2_mmu(struct kvm_s2_mmu *mmu);
 extern struct kvm_s2_mmu *lookup_s2_mmu(struct kvm *kvm, u64 vttbr, u64 hcr);
 extern void kvm_vcpu_load_hw_mmu(struct kvm_vcpu *vcpu);
 extern void kvm_vcpu_put_hw_mmu(struct kvm_vcpu *vcpu);
+extern void check_nested_vcpu_requests(struct kvm_vcpu *vcpu);
 
 struct kvm_s2_trans {
 	phys_addr_t output;
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 8a23991f82b2..0c15321c0827 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -23,5 +23,5 @@ kvm-y := $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o \
 	 vgic/vgic-v3.o vgic/vgic-v4.o \
 	 vgic/vgic-mmio.o vgic/vgic-mmio-v2.o \
 	 vgic/vgic-mmio-v3.o vgic/vgic-kvm-device.o \
-	 vgic/vgic-its.o vgic/vgic-debug.o
+	 vgic/vgic-its.o vgic/vgic-debug.o vgic/vgic-v3-nested.o
 kvm-$(CONFIG_KVM_ARM_PMU)  += pmu-emul.o
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 2e042185e625..818ec91801e2 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -692,6 +692,8 @@ static void check_vcpu_requests(struct kvm_vcpu *vcpu)
 			vgic_v4_load(vcpu);
 			preempt_enable();
 		}
+
+		check_nested_vcpu_requests(vcpu);
 	}
 }
 
@@ -738,9 +740,16 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		 */
 		cond_resched();
 
-		update_vmid(&vcpu->arch.hw_mmu->vmid);
-
+		/*
+		 * A nested exeption triggered by a vcpu request (such
+		 * as an interrupt injected in a guest hypervisor) can
+		 * change the currently used VMID (by switching to a
+		 * different translation regime. It is thus necesary
+		 * to update the VMID *after* all requests have been
+		 * processed.
+		 */
 		check_vcpu_requests(vcpu);
+		update_vmid(&vcpu->arch.hw_mmu->vmid);
 
 		/*
 		 * Preparing the interrupts to be injected also
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index e78c6c093afc..9574fde823e6 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -580,6 +580,22 @@ void kvm_arch_flush_shadow_all(struct kvm *kvm)
 	kvm_free_stage2_pgd(&kvm->arch.mmu);
 }
 
+bool vgic_state_is_nested(struct kvm_vcpu *vcpu)
+{
+	bool imo = __vcpu_sys_reg(vcpu, HCR_EL2) & HCR_IMO;
+	bool fmo = __vcpu_sys_reg(vcpu, HCR_EL2) & HCR_FMO;
+
+	WARN_ONCE(imo != fmo, "Separate virtual IRQ/FIQ settings not supported\n");
+
+	return nested_virt_in_use(vcpu) && imo && fmo && !is_hyp_ctxt(vcpu);
+}
+
+void check_nested_vcpu_requests(struct kvm_vcpu *vcpu)
+{
+	if (kvm_check_request(KVM_REQ_GUEST_HYP_IRQ_PENDING, vcpu))
+		kvm_inject_nested_irq(vcpu);
+}
+
 #define FEATURE(x)	(GENMASK_ULL(x##_SHIFT + 3, x##_SHIFT))
 
 /*
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 560b44325e98..60d2fb6edc93 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -15,6 +15,8 @@
 #include <linux/printk.h>
 #include <linux/uaccess.h>
 
+#include <linux/irqchip/arm-gic-v3.h>
+
 #include <asm/cacheflush.h>
 #include <asm/cputype.h>
 #include <asm/debug-monitors.h>
@@ -455,6 +457,19 @@ static bool access_actlr(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+/*
+ * The architecture says that non-secure write accesses to this register from
+ * EL1 are trapped to EL2, if either:
+ *  - HCR_EL2.FMO==1, or
+ *  - HCR_EL2.IMO==1
+ */
+static bool sgi_traps_to_vel2(struct kvm_vcpu *vcpu)
+{
+	return (nested_virt_in_use(vcpu) &&
+		!vcpu_mode_el2(vcpu) &&
+		!!(vcpu_read_sys_reg(vcpu, HCR_EL2) & (HCR_IMO | HCR_FMO)));
+}
+
 /*
  * Trap handler for the GICv3 SGI generation system register.
  * Forward the request to the VGIC emulation.
@@ -470,6 +485,11 @@ static bool access_gic_sgi(struct kvm_vcpu *vcpu,
 	if (!p->is_write)
 		return read_from_write_only(vcpu, p, r);
 
+	if (sgi_traps_to_vel2(vcpu)) {
+		kvm_inject_nested_sync(vcpu, kvm_vcpu_get_esr(vcpu));
+		return false;
+	}
+
 	/*
 	 * In a system where GICD_CTLR.DS=1, a ICC_SGI0R_EL1 access generates
 	 * Group0 SGIs only, while ICC_SGI1R_EL1 can generate either group,
@@ -513,7 +533,13 @@ static bool access_gic_sre(struct kvm_vcpu *vcpu,
 	if (p->is_write)
 		return ignore_write(vcpu, p);
 
-	p->regval = vcpu->arch.vgic_cpu.vgic_v3.vgic_sre;
+	if (p->Op1 == 4) {	/* ICC_SRE_EL2 */
+		p->regval = (ICC_SRE_EL2_ENABLE | ICC_SRE_EL2_SRE |
+			     ICC_SRE_EL1_DIB | ICC_SRE_EL1_DFB);
+	} else {		/* ICC_SRE_EL1 */
+		p->regval = vcpu->arch.vgic_cpu.vgic_v3.vgic_sre;
+	}
+
 	return true;
 }
 
@@ -1759,6 +1785,122 @@ static bool access_spsr_el2(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+static bool access_gic_apr(struct kvm_vcpu *vcpu,
+			   struct sys_reg_params *p,
+			   const struct sys_reg_desc *r)
+{
+	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.nested_vgic_v3;
+	u32 index, *base;
+
+	index = r->Op2;
+	if (r->CRm == 8)
+		base = cpu_if->vgic_ap0r;
+	else
+		base = cpu_if->vgic_ap1r;
+
+	if (p->is_write)
+		base[index] = p->regval;
+	else
+		p->regval = base[index];
+
+	return true;
+}
+
+static bool access_gic_hcr(struct kvm_vcpu *vcpu,
+			   struct sys_reg_params *p,
+			   const struct sys_reg_desc *r)
+{
+	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.nested_vgic_v3;
+
+	if (p->is_write)
+		cpu_if->vgic_hcr = p->regval;
+	else
+		p->regval = cpu_if->vgic_hcr;
+
+	return true;
+}
+
+static bool access_gic_vtr(struct kvm_vcpu *vcpu,
+			   struct sys_reg_params *p,
+			   const struct sys_reg_desc *r)
+{
+	if (p->is_write)
+		return write_to_read_only(vcpu, p, r);
+
+	p->regval = kvm_vgic_global_state.ich_vtr_el2;
+
+	return true;
+}
+
+static bool access_gic_misr(struct kvm_vcpu *vcpu,
+			    struct sys_reg_params *p,
+			    const struct sys_reg_desc *r)
+{
+	if (p->is_write)
+		return write_to_read_only(vcpu, p, r);
+
+	p->regval = vgic_v3_get_misr(vcpu);
+
+	return true;
+}
+
+static bool access_gic_eisr(struct kvm_vcpu *vcpu,
+			    struct sys_reg_params *p,
+			    const struct sys_reg_desc *r)
+{
+	if (p->is_write)
+		return write_to_read_only(vcpu, p, r);
+
+	p->regval = vgic_v3_get_eisr(vcpu);
+
+	return true;
+}
+
+static bool access_gic_elrsr(struct kvm_vcpu *vcpu,
+			     struct sys_reg_params *p,
+			     const struct sys_reg_desc *r)
+{
+	if (p->is_write)
+		return write_to_read_only(vcpu, p, r);
+
+	p->regval = vgic_v3_get_elrsr(vcpu);
+
+	return true;
+}
+
+static bool access_gic_vmcr(struct kvm_vcpu *vcpu,
+			    struct sys_reg_params *p,
+			    const struct sys_reg_desc *r)
+{
+	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.nested_vgic_v3;
+
+	if (p->is_write)
+		cpu_if->vgic_vmcr = p->regval;
+	else
+		p->regval = cpu_if->vgic_vmcr;
+
+	return true;
+}
+
+static bool access_gic_lr(struct kvm_vcpu *vcpu,
+			  struct sys_reg_params *p,
+			  const struct sys_reg_desc *r)
+{
+	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.nested_vgic_v3;
+	u32 index;
+
+	index = p->Op2;
+	if (p->CRm == 13)
+		index += 8;
+
+	if (p->is_write)
+		cpu_if->vgic_lr[index] = p->regval;
+	else
+		p->regval = cpu_if->vgic_lr[index];
+
+	return true;
+}
+
 /*
  * Architected system registers.
  * Important: Must be sorted ascending by Op0, Op1, CRn, CRm, Op2
@@ -2175,6 +2317,41 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_RMR_EL2), access_wi, reset_val, RMR_EL2, 1 },
 	{ SYS_DESC(SYS_VDISR_EL2), trap_undef },
 
+	{ SYS_DESC(SYS_ICH_AP0R0_EL2), access_gic_apr },
+	{ SYS_DESC(SYS_ICH_AP0R1_EL2), access_gic_apr },
+	{ SYS_DESC(SYS_ICH_AP0R2_EL2), access_gic_apr },
+	{ SYS_DESC(SYS_ICH_AP0R3_EL2), access_gic_apr },
+	{ SYS_DESC(SYS_ICH_AP1R0_EL2), access_gic_apr },
+	{ SYS_DESC(SYS_ICH_AP1R1_EL2), access_gic_apr },
+	{ SYS_DESC(SYS_ICH_AP1R2_EL2), access_gic_apr },
+	{ SYS_DESC(SYS_ICH_AP1R3_EL2), access_gic_apr },
+
+	{ SYS_DESC(SYS_ICC_SRE_EL2), access_gic_sre },
+
+	{ SYS_DESC(SYS_ICH_HCR_EL2), access_gic_hcr },
+	{ SYS_DESC(SYS_ICH_VTR_EL2), access_gic_vtr },
+	{ SYS_DESC(SYS_ICH_MISR_EL2), access_gic_misr },
+	{ SYS_DESC(SYS_ICH_EISR_EL2), access_gic_eisr },
+	{ SYS_DESC(SYS_ICH_ELRSR_EL2), access_gic_elrsr },
+	{ SYS_DESC(SYS_ICH_VMCR_EL2), access_gic_vmcr },
+
+	{ SYS_DESC(SYS_ICH_LR0_EL2), access_gic_lr },
+	{ SYS_DESC(SYS_ICH_LR1_EL2), access_gic_lr },
+	{ SYS_DESC(SYS_ICH_LR2_EL2), access_gic_lr },
+	{ SYS_DESC(SYS_ICH_LR3_EL2), access_gic_lr },
+	{ SYS_DESC(SYS_ICH_LR4_EL2), access_gic_lr },
+	{ SYS_DESC(SYS_ICH_LR5_EL2), access_gic_lr },
+	{ SYS_DESC(SYS_ICH_LR6_EL2), access_gic_lr },
+	{ SYS_DESC(SYS_ICH_LR7_EL2), access_gic_lr },
+	{ SYS_DESC(SYS_ICH_LR8_EL2), access_gic_lr },
+	{ SYS_DESC(SYS_ICH_LR9_EL2), access_gic_lr },
+	{ SYS_DESC(SYS_ICH_LR10_EL2), access_gic_lr },
+	{ SYS_DESC(SYS_ICH_LR11_EL2), access_gic_lr },
+	{ SYS_DESC(SYS_ICH_LR12_EL2), access_gic_lr },
+	{ SYS_DESC(SYS_ICH_LR13_EL2), access_gic_lr },
+	{ SYS_DESC(SYS_ICH_LR14_EL2), access_gic_lr },
+	{ SYS_DESC(SYS_ICH_LR15_EL2), access_gic_lr },
+
 	{ SYS_DESC(SYS_CONTEXTIDR_EL2), access_rw, reset_val, CONTEXTIDR_EL2, 0 },
 	{ SYS_DESC(SYS_TPIDR_EL2), access_rw, reset_val, TPIDR_EL2, 0 },
 
diff --git a/arch/arm64/kvm/vgic/vgic-v3-nested.c b/arch/arm64/kvm/vgic/vgic-v3-nested.c
new file mode 100644
index 000000000000..bfe0ccde514f
--- /dev/null
+++ b/arch/arm64/kvm/vgic/vgic-v3-nested.c
@@ -0,0 +1,178 @@
+#include <linux/cpu.h>
+#include <linux/kvm.h>
+#include <linux/kvm_host.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
+
+#include <linux/irqchip/arm-gic-v3.h>
+
+#include <asm/kvm_emulate.h>
+#include <asm/kvm_arm.h>
+#include <kvm/arm_vgic.h>
+
+#include "vgic.h"
+
+static inline struct vgic_v3_cpu_if *vcpu_nested_if(struct kvm_vcpu *vcpu)
+{
+	return &vcpu->arch.vgic_cpu.nested_vgic_v3;
+}
+
+static inline struct vgic_v3_cpu_if *vcpu_shadow_if(struct kvm_vcpu *vcpu)
+{
+	return &vcpu->arch.vgic_cpu.shadow_vgic_v3;
+}
+
+static inline bool lr_triggers_eoi(u64 lr)
+{
+	return !(lr & (ICH_LR_STATE | ICH_LR_HW)) && (lr & ICH_LR_EOI);
+}
+
+u16 vgic_v3_get_eisr(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v3_cpu_if *cpu_if = vcpu_nested_if(vcpu);
+	u16 reg = 0;
+	int i;
+
+	for (i = 0; i < kvm_vgic_global_state.nr_lr; i++) {
+		if (lr_triggers_eoi(cpu_if->vgic_lr[i]))
+			reg |= BIT(i);
+	}
+
+	return reg;
+}
+
+u16 vgic_v3_get_elrsr(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v3_cpu_if *cpu_if = vcpu_nested_if(vcpu);
+	u16 reg = 0;
+	int i;
+
+	for (i = 0; i < kvm_vgic_global_state.nr_lr; i++) {
+		if (!(cpu_if->vgic_lr[i] & ICH_LR_STATE))
+			reg |= BIT(i);
+	}
+
+	return reg;
+}
+
+u64 vgic_v3_get_misr(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v3_cpu_if *cpu_if = vcpu_nested_if(vcpu);
+	int nr_lr = kvm_vgic_global_state.nr_lr;
+	u64 reg = 0;
+
+	if (vgic_v3_get_eisr(vcpu))
+		reg |= ICH_MISR_EOI;
+
+	if (cpu_if->vgic_hcr & ICH_HCR_UIE) {
+		int used_lrs;
+
+		used_lrs = nr_lr - hweight16(vgic_v3_get_elrsr(vcpu));
+		if (used_lrs <= 1)
+			reg |= ICH_MISR_U;
+	}
+
+	/* TODO: Support remaining bits in this register */
+	return reg;
+}
+
+/*
+ * For LRs which have HW bit set such as timer interrupts, we modify them to
+ * have the host hardware interrupt number instead of the virtual one programmed
+ * by the guest hypervisor.
+ */
+static void vgic_v3_create_shadow_lr(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v3_cpu_if *cpu_if = vcpu_nested_if(vcpu);
+	struct vgic_v3_cpu_if *s_cpu_if = vcpu_shadow_if(vcpu);
+	struct vgic_irq *irq;
+	int i, used_lrs = 0;
+
+	for (i = 0; i < kvm_vgic_global_state.nr_lr; i++) {
+		u64 lr = cpu_if->vgic_lr[i];
+		int l1_irq;
+
+		if (!(lr & ICH_LR_HW))
+			goto next;
+
+		/* We have the HW bit set */
+		l1_irq = (lr & ICH_LR_PHYS_ID_MASK) >> ICH_LR_PHYS_ID_SHIFT;
+		irq = vgic_get_irq(vcpu->kvm, vcpu, l1_irq);
+
+		if (!irq || !irq->hw) {
+			/* There was no real mapping, so nuke the HW bit */
+			lr &= ~ICH_LR_HW;
+			if (irq)
+				vgic_put_irq(vcpu->kvm, irq);
+			goto next;
+		}
+
+		/* Translate the virtual mapping to the real one */
+		lr &= ~ICH_LR_EOI; /* Why? */
+		lr &= ~ICH_LR_PHYS_ID_MASK;
+		lr |= (u64)irq->hwintid << ICH_LR_PHYS_ID_SHIFT;
+		vgic_put_irq(vcpu->kvm, irq);
+
+next:
+		s_cpu_if->vgic_lr[i] = lr;
+		used_lrs = i + 1;
+	}
+
+	s_cpu_if->used_lrs = used_lrs;
+}
+
+/*
+ * Change the shadow HWIRQ field back to the virtual value before copying over
+ * the entire shadow struct to the nested state.
+ */
+static void vgic_v3_fixup_shadow_lr_state(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v3_cpu_if *cpu_if = vcpu_nested_if(vcpu);
+	struct vgic_v3_cpu_if *s_cpu_if = vcpu_shadow_if(vcpu);
+	int lr;
+
+	for (lr = 0; lr < kvm_vgic_global_state.nr_lr; lr++) {
+		s_cpu_if->vgic_lr[lr] &= ~ICH_LR_PHYS_ID_MASK;
+		s_cpu_if->vgic_lr[lr] |= cpu_if->vgic_lr[lr] & ICH_LR_PHYS_ID_MASK;
+	}
+}
+
+void vgic_v3_load_nested(struct kvm_vcpu *vcpu)
+{
+	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
+
+	vgic_cpu->shadow_vgic_v3 = vgic_cpu->nested_vgic_v3;
+	vgic_v3_create_shadow_lr(vcpu);
+	__vgic_v3_restore_state(vcpu_shadow_if(vcpu));
+}
+
+void vgic_v3_put_nested(struct kvm_vcpu *vcpu)
+{
+	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
+
+	__vgic_v3_save_state(vcpu_shadow_if(vcpu));
+
+	/*
+	 * Translate the shadow state HW fields back to the virtual ones
+	 * before copying the shadow struct back to the nested one.
+	 */
+	vgic_v3_fixup_shadow_lr_state(vcpu);
+	vgic_cpu->nested_vgic_v3 = vgic_cpu->shadow_vgic_v3;
+}
+
+void vgic_v3_handle_nested_maint_irq(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v3_cpu_if *cpu_if = vcpu_nested_if(vcpu);
+
+	/*
+	 * If we exit a nested VM with a pending maintenance interrupt from the
+	 * GIC, then we need to forward this to the guest hypervisor so that it
+	 * can re-sync the appropriate LRs and sample level triggered interrupts
+	 * again.
+	 */
+	if (vgic_state_is_nested(vcpu) &&
+	    (cpu_if->vgic_hcr & ICH_HCR_EN) &&
+	    vgic_v3_get_misr(vcpu))
+		kvm_inject_nested_irq(vcpu);
+}
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 9cdf39a94a63..e4c5c27552da 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -6,6 +6,7 @@
 #include <kvm/arm_vgic.h>
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
+#include <asm/kvm_nested.h>
 #include <asm/kvm_asm.h>
 
 #include "vgic.h"
@@ -289,6 +290,12 @@ void vgic_v3_enable(struct kvm_vcpu *vcpu)
 		vgic_v3->vgic_sre = (ICC_SRE_EL1_DIB |
 				     ICC_SRE_EL1_DFB |
 				     ICC_SRE_EL1_SRE);
+		/*
+		 * If nesting is allowed, force GICv3 onto the nested
+		 * guests as well.
+		 */
+		if (nested_virt_in_use(vcpu))
+			vcpu->arch.vgic_cpu.nested_vgic_v3.vgic_sre = vgic_v3->vgic_sre;
 		vcpu->arch.vgic_cpu.pendbaser = INITIAL_PENDBASER_VALUE;
 	} else {
 		vgic_v3->vgic_sre = 0;
@@ -654,6 +661,13 @@ void vgic_v3_load(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
 
+	/*
+	 * vgic_v3_load_nested only affects the LRs in the shadow
+	 * state, so it is fine to pass the nested state around.
+	 */
+	if (vgic_state_is_nested(vcpu))
+		cpu_if = &vcpu->arch.vgic_cpu.nested_vgic_v3;
+
 	/*
 	 * If dealing with a GICv2 emulation on GICv3, VMCR_EL2.VFIQen
 	 * is dependent on ICC_SRE_EL1.SRE, and we have to perform the
@@ -667,6 +681,9 @@ void vgic_v3_load(struct kvm_vcpu *vcpu)
 	if (has_vhe())
 		__vgic_v3_activate_traps(cpu_if);
 
+	if (vgic_state_is_nested(vcpu))
+		vgic_v3_load_nested(vcpu);
+
 	WARN_ON(vgic_v4_load(vcpu));
 }
 
@@ -674,6 +691,9 @@ void vgic_v3_vmcr_sync(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
 
+	if (vgic_state_is_nested(vcpu))
+		cpu_if = &vcpu->arch.vgic_cpu.shadow_vgic_v3;
+
 	if (likely(cpu_if->vgic_sre))
 		cpu_if->vgic_vmcr = kvm_call_hyp_ret(__vgic_v3_read_vmcr);
 }
@@ -686,8 +706,14 @@ void vgic_v3_put(struct kvm_vcpu *vcpu)
 
 	vgic_v3_vmcr_sync(vcpu);
 
+	if (vgic_state_is_nested(vcpu))
+		cpu_if = &vcpu->arch.vgic_cpu.shadow_vgic_v3;
+
 	kvm_call_hyp(__vgic_v3_save_aprs, cpu_if);
 
 	if (has_vhe())
 		__vgic_v3_deactivate_traps(cpu_if);
+
+	if (vgic_state_is_nested(vcpu))
+		vgic_v3_put_nested(vcpu);
 }
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 2af93dc80689..eae63e5c8322 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -876,6 +876,10 @@ void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
 {
 	int used_lrs;
 
+	/* If nesting, this is a load/put affair, not flush/sync. */
+	if (vgic_state_is_nested(vcpu))
+		return;
+
 	/* An empty ap_list_head implies used_lrs == 0 */
 	if (list_empty(&vcpu->arch.vgic_cpu.ap_list_head))
 		return;
@@ -920,6 +924,29 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
 	    !vgic_supports_direct_msis(vcpu->kvm))
 		return;
 
+	/*
+	 * If in a nested state, we must return early. Two possibilities:
+	 *
+	 * - If we have any pending IRQ for the guest and the guest
+	 *   expects IRQs to be handled in its virtual EL2 mode (the
+	 *   virtual IMO bit is set) and it is not already running in
+	 *   virtual EL2 mode, then we have to emulate an IRQ
+	 *   exception to virtual EL2.
+	 *
+	 *   We do that by placing a request to ourselves which will
+	 *   abort the entry procedure and inject the exception at the
+	 *   beginning of the run loop.
+	 *
+	 * - Otherwise, do exactly *NOTHING*. The guest state is
+	 *   already loaded, and we can carry on with running it.
+	 */
+	if (vgic_state_is_nested(vcpu)) {
+		if (kvm_vgic_vcpu_pending_irq(vcpu))
+			kvm_make_request(KVM_REQ_GUEST_HYP_IRQ_PENDING, vcpu);
+
+		return;
+	}
+
 	DEBUG_SPINLOCK_BUG_ON(!irqs_disabled());
 
 	if (!list_empty(&vcpu->arch.vgic_cpu.ap_list_head)) {
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 4749c4748e5a..4c6e61398f63 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -306,6 +306,15 @@ struct vgic_cpu {
 
 	struct vgic_irq private_irqs[VGIC_NR_PRIVATE_IRQS];
 
+	/* CPU vif control registers for the virtual GICH interface */
+	struct vgic_v3_cpu_if	nested_vgic_v3;
+
+	/*
+	 * The shadow vif control register loaded to the hardware when
+	 * running a nested L2 guest with the virtual IMO/FMO bit set.
+	 */
+	struct vgic_v3_cpu_if	shadow_vgic_v3;
+
 	raw_spinlock_t ap_list_lock;	/* Protects the ap_list */
 
 	/*
@@ -362,6 +371,13 @@ void kvm_vgic_load(struct kvm_vcpu *vcpu);
 void kvm_vgic_put(struct kvm_vcpu *vcpu);
 void kvm_vgic_vmcr_sync(struct kvm_vcpu *vcpu);
 
+void vgic_v3_load_nested(struct kvm_vcpu *vcpu);
+void vgic_v3_put_nested(struct kvm_vcpu *vcpu);
+void vgic_v3_handle_nested_maint_irq(struct kvm_vcpu *vcpu);
+u16 vgic_v3_get_eisr(struct kvm_vcpu *vcpu);
+u16 vgic_v3_get_elrsr(struct kvm_vcpu *vcpu);
+u64 vgic_v3_get_misr(struct kvm_vcpu *vcpu);
+
 #define irqchip_in_kernel(k)	(!!((k)->arch.vgic.in_kernel))
 #define vgic_initialized(k)	((k)->arch.vgic.initialized)
 #define vgic_ready(k)		((k)->arch.vgic.ready)
@@ -406,4 +422,6 @@ int vgic_v4_load(struct kvm_vcpu *vcpu);
 void vgic_v4_commit(struct kvm_vcpu *vcpu);
 int vgic_v4_put(struct kvm_vcpu *vcpu, bool need_db);
 
+bool vgic_state_is_nested(struct kvm_vcpu *vcpu);
+
 #endif /* __KVM_ARM_VGIC_H */
-- 
2.29.2

