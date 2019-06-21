Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D42B34E43F
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2019 11:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726975AbfFUJlN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jun 2019 05:41:13 -0400
Received: from foss.arm.com ([217.140.110.172]:54314 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726983AbfFUJkb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jun 2019 05:40:31 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E86CC1500;
        Fri, 21 Jun 2019 02:40:30 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (filthy-habits.cambridge.arm.com [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 938A13F246;
        Fri, 21 Jun 2019 02:40:29 -0700 (PDT)
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
Subject: [PATCH 50/59] KVM: arm64: nv: Nested GICv3 Support
Date:   Fri, 21 Jun 2019 10:38:34 +0100
Message-Id: <20190621093843.220980-51-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190621093843.220980-1-marc.zyngier@arm.com>
References: <20190621093843.220980-1-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
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
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
[Redesigned execution flow around vcpu load/put]
Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
---
 arch/arm/include/asm/kvm_emulate.h |   1 +
 arch/arm/include/asm/kvm_host.h    |   6 +-
 arch/arm64/include/asm/kvm_host.h  |   5 +-
 arch/arm64/kvm/Makefile            |   1 +
 arch/arm64/kvm/nested.c            |  10 ++
 arch/arm64/kvm/sys_regs.c          | 178 ++++++++++++++++++++++++++++-
 include/kvm/arm_vgic.h             |  18 +++
 virt/kvm/arm/arm.c                 |   7 +-
 virt/kvm/arm/vgic/vgic-v3-nested.c | 177 ++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic-v3.c        |  28 +++++
 virt/kvm/arm/vgic/vgic.c           |  32 ++++++
 11 files changed, 456 insertions(+), 7 deletions(-)
 create mode 100644 virt/kvm/arm/vgic/vgic-v3-nested.c

diff --git a/arch/arm/include/asm/kvm_emulate.h b/arch/arm/include/asm/kvm_emulate.h
index 865ce545b465..a53f19041e16 100644
--- a/arch/arm/include/asm/kvm_emulate.h
+++ b/arch/arm/include/asm/kvm_emulate.h
@@ -334,5 +334,6 @@ static inline unsigned long vcpu_data_host_to_guest(struct kvm_vcpu *vcpu,
 static inline void vcpu_ptrauth_setup_lazy(struct kvm_vcpu *vcpu) {}
 
 static inline bool is_hyp_ctxt(struct kvm_vcpu *vcpu) { return false; }
+static inline int kvm_inject_nested_irq(struct kvm_vcpu *vcpu) { BUG(); }
 
 #endif /* __ARM_KVM_EMULATE_H__ */
diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index cc761610e41e..d6923ed55796 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -35,10 +35,12 @@
 #define KVM_MAX_VCPUS VGIC_V2_MAX_CPUS
 #endif
 
+/* KVM_REQ_GUEST_HYP_IRQ_PENDING is actually unused */
 #define KVM_REQ_SLEEP \
 	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
-#define KVM_REQ_IRQ_PENDING	KVM_ARCH_REQ(1)
-#define KVM_REQ_VCPU_RESET	KVM_ARCH_REQ(2)
+#define KVM_REQ_IRQ_PENDING		KVM_ARCH_REQ(1)
+#define KVM_REQ_VCPU_RESET		KVM_ARCH_REQ(2)
+#define KVM_REQ_GUEST_HYP_IRQ_PENDING	KVM_ARCH_REQ(3)
 
 DECLARE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
 
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index e0fe9acb46bf..e2e44cc650bf 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -53,8 +53,9 @@
 
 #define KVM_REQ_SLEEP \
 	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
-#define KVM_REQ_IRQ_PENDING	KVM_ARCH_REQ(1)
-#define KVM_REQ_VCPU_RESET	KVM_ARCH_REQ(2)
+#define KVM_REQ_IRQ_PENDING		KVM_ARCH_REQ(1)
+#define KVM_REQ_VCPU_RESET		KVM_ARCH_REQ(2)
+#define KVM_REQ_GUEST_HYP_IRQ_PENDING	KVM_ARCH_REQ(3)
 
 DECLARE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
 
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index f11bd8b0d837..045a8f18f465 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -38,3 +38,4 @@ kvm-$(CONFIG_KVM_ARM_PMU) += $(KVM)/arm/pmu.o
 
 kvm-$(CONFIG_KVM_ARM_HOST) += nested.o
 kvm-$(CONFIG_KVM_ARM_HOST) += emulate-nested.o
+kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-v3-nested.o
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 214d59019935..df2db9ab7cfb 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -539,3 +539,13 @@ void kvm_arch_flush_shadow_all(struct kvm *kvm)
 	kvm->arch.nested_mmus_size = 0;
 	kvm_free_stage2_pgd(&kvm->arch.mmu);
 }
+
+bool vgic_state_is_nested(struct kvm_vcpu *vcpu)
+{
+	bool imo = __vcpu_sys_reg(vcpu, HCR_EL2) & HCR_IMO;
+	bool fmo = __vcpu_sys_reg(vcpu, HCR_EL2) & HCR_FMO;
+
+	WARN(imo != fmo, "Separate virtual IRQ/FIQ settings not supported\n");
+
+	return nested_virt_in_use(vcpu) && imo && fmo && !is_hyp_ctxt(vcpu);
+}
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 2031a59fcf49..ba3bcd29c02d 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -26,6 +26,8 @@
 #include <linux/printk.h>
 #include <linux/uaccess.h>
 
+#include <linux/irqchip/arm-gic-v3.h>
+
 #include <asm/cacheflush.h>
 #include <asm/cputype.h>
 #include <asm/debug-monitors.h>
@@ -505,6 +507,18 @@ static bool access_vm_reg(struct kvm_vcpu *vcpu,
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
+	return !vcpu_mode_el2(vcpu) &&
+		!!(__vcpu_sys_reg(vcpu, HCR_EL2) & (HCR_IMO | HCR_FMO));
+}
+
 /*
  * Trap handler for the GICv3 SGI generation system register.
  * Forward the request to the VGIC emulation.
@@ -520,6 +534,11 @@ static bool access_gic_sgi(struct kvm_vcpu *vcpu,
 	if (!p->is_write)
 		return read_from_write_only(vcpu, p, r);
 
+	if (sgi_traps_to_vel2(vcpu)) {
+		kvm_inject_nested_sync(vcpu, kvm_vcpu_get_hsr(vcpu));
+		return false;
+	}
+
 	/*
 	 * In a system where GICD_CTLR.DS=1, a ICC_SGI0R_EL1 access generates
 	 * Group0 SGIs only, while ICC_SGI1R_EL1 can generate either group,
@@ -563,7 +582,13 @@ static bool access_gic_sre(struct kvm_vcpu *vcpu,
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
 
@@ -1793,6 +1818,122 @@ static bool access_id_aa64pfr0_el1(struct kvm_vcpu *v,
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
@@ -2123,6 +2264,41 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_RMR_EL2), access_rw, reset_val, RMR_EL2, 0 },
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
 
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 163b132e100e..707fbe627155 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -310,6 +310,15 @@ struct vgic_cpu {
 
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
@@ -366,6 +375,13 @@ int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu);
 void kvm_vgic_load(struct kvm_vcpu *vcpu);
 void kvm_vgic_put(struct kvm_vcpu *vcpu);
 
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
@@ -411,4 +427,6 @@ int kvm_vgic_v4_unset_forwarding(struct kvm *kvm, int irq,
 void kvm_vgic_v4_enable_doorbell(struct kvm_vcpu *vcpu);
 void kvm_vgic_v4_disable_doorbell(struct kvm_vcpu *vcpu);
 
+bool vgic_state_is_nested(struct kvm_vcpu *vcpu);
+
 #endif /* __KVM_ARM_VGIC_H */
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index ca10a11e044e..ddcab58ae440 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -634,6 +634,9 @@ static void check_vcpu_requests(struct kvm_vcpu *vcpu)
 		 * that a VCPU sees new virtual interrupts.
 		 */
 		kvm_check_request(KVM_REQ_IRQ_PENDING, vcpu);
+
+		if (kvm_check_request(KVM_REQ_GUEST_HYP_IRQ_PENDING, vcpu))
+			kvm_inject_nested_irq(vcpu);
 	}
 }
 
@@ -680,10 +683,10 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		 */
 		cond_resched();
 
-		update_vmid(&vcpu->arch.hw_mmu->vmid);
-
 		check_vcpu_requests(vcpu);
 
+		update_vmid(&vcpu->arch.hw_mmu->vmid);
+
 		/*
 		 * Preparing the interrupts to be injected also
 		 * involves poking the GIC, which must be done in a
diff --git a/virt/kvm/arm/vgic/vgic-v3-nested.c b/virt/kvm/arm/vgic/vgic-v3-nested.c
new file mode 100644
index 000000000000..6fb81dfbb679
--- /dev/null
+++ b/virt/kvm/arm/vgic/vgic-v3-nested.c
@@ -0,0 +1,177 @@
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
+	int i;
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
+	}
+
+	s_cpu_if->used_lrs = kvm_vgic_global_state.nr_lr;
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
diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index 77d23e817756..25edf32c28fb 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -18,6 +18,7 @@
 #include <kvm/arm_vgic.h>
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
+#include <asm/kvm_nested.h>
 #include <asm/kvm_asm.h>
 
 #include "vgic.h"
@@ -298,6 +299,12 @@ void vgic_v3_enable(struct kvm_vcpu *vcpu)
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
@@ -660,6 +667,13 @@ void vgic_v3_load(struct kvm_vcpu *vcpu)
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
@@ -672,12 +686,18 @@ void vgic_v3_load(struct kvm_vcpu *vcpu)
 
 	if (has_vhe())
 		__vgic_v3_activate_traps(cpu_if);
+
+	if (vgic_state_is_nested(vcpu))
+		vgic_v3_load_nested(vcpu);
 }
 
 void vgic_v3_put(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
 
+	if (vgic_state_is_nested(vcpu))
+		cpu_if = &vcpu->arch.vgic_cpu.shadow_vgic_v3;
+
 	if (likely(cpu_if->vgic_sre))
 		cpu_if->vgic_vmcr = kvm_call_hyp_ret(__vgic_v3_read_vmcr);
 
@@ -685,4 +705,12 @@ void vgic_v3_put(struct kvm_vcpu *vcpu)
 
 	if (has_vhe())
 		__vgic_v3_deactivate_traps(cpu_if);
+
+	if (vgic_state_is_nested(vcpu))
+		vgic_v3_put_nested(vcpu);
 }
+
+__weak void vgic_v3_sync_nested(struct kvm_vcpu *vcpu) {}
+__weak void vgic_v3_handle_nested_maint_irq(struct kvm_vcpu *vcpu) {}
+__weak void vgic_v3_load_nested(struct kvm_vcpu *vcpu) {}
+__weak void vgic_v3_put_nested(struct kvm_vcpu *vcpu) {}
diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index 6953aefecbb6..f32f49b0c803 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -872,6 +872,10 @@ void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
 {
 	int used_lrs;
 
+	/* If nesting, this is a load/put affair, not flush/sync. */
+	if (vgic_state_is_nested(vcpu))
+		return;
+
 	WARN_ON(vgic_v4_sync_hwstate(vcpu));
 
 	/* An empty ap_list_head implies used_lrs == 0 */
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
@@ -1022,3 +1049,8 @@ bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int vintid)
 
 	return map_is_active;
 }
+
+__weak bool vgic_state_is_nested(struct kvm_vcpu *vcpu)
+{
+	return false;
+}
-- 
2.20.1

