Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD324E440
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2019 11:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbfFUJlQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jun 2019 05:41:16 -0400
Received: from foss.arm.com ([217.140.110.172]:54298 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726956AbfFUJka (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jun 2019 05:40:30 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5DF84147A;
        Fri, 21 Jun 2019 02:40:29 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (filthy-habits.cambridge.arm.com [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0A05A3F246;
        Fri, 21 Jun 2019 02:40:27 -0700 (PDT)
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
Subject: [PATCH 49/59] KVM: arm64: nv: vgic-v3: Take cpu_if pointer directly instead of vcpu
Date:   Fri, 21 Jun 2019 10:38:33 +0100
Message-Id: <20190621093843.220980-50-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190621093843.220980-1-marc.zyngier@arm.com>
References: <20190621093843.220980-1-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Christoffer Dall <christoffer.dall@arm.com>

If we move the used_lrs field to the version-specific cpu interface
structure, the following functions only operate on the struct
vgic_v3_cpu_if and not the full vcpu:

  __vgic_v3_save_state
  __vgic_v3_restore_state
  __vgic_v3_activate_traps
  __vgic_v3_deactivate_traps
  __vgic_v3_save_aprs
  __vgic_v3_restore_aprs

This is going to be very useful for nested virt, so move the used_lrs
field and change the prototypes and implementations of these functions to
take the cpu_if parameter directly.

No functional change.

Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_hyp.h   | 12 ++++++------
 arch/arm/kvm/hyp/switch.c        |  8 ++++----
 arch/arm64/include/asm/kvm_hyp.h | 12 ++++++------
 arch/arm64/kvm/hyp/switch.c      |  8 ++++----
 include/kvm/arm_vgic.h           |  5 ++++-
 virt/kvm/arm/hyp/vgic-v3-sr.c    | 33 ++++++++++----------------------
 virt/kvm/arm/vgic/vgic-v2.c      | 10 +++++-----
 virt/kvm/arm/vgic/vgic-v3.c      | 12 ++++++------
 virt/kvm/arm/vgic/vgic.c         | 25 ++++++++++++++++--------
 9 files changed, 62 insertions(+), 63 deletions(-)

diff --git a/arch/arm/include/asm/kvm_hyp.h b/arch/arm/include/asm/kvm_hyp.h
index 059224fb14db..da68073ab672 100644
--- a/arch/arm/include/asm/kvm_hyp.h
+++ b/arch/arm/include/asm/kvm_hyp.h
@@ -113,12 +113,12 @@ void __vgic_v2_restore_state(struct kvm_vcpu *vcpu);
 void __sysreg_save_state(struct kvm_cpu_context *ctxt);
 void __sysreg_restore_state(struct kvm_cpu_context *ctxt);
 
-void __vgic_v3_save_state(struct kvm_vcpu *vcpu);
-void __vgic_v3_restore_state(struct kvm_vcpu *vcpu);
-void __vgic_v3_activate_traps(struct kvm_vcpu *vcpu);
-void __vgic_v3_deactivate_traps(struct kvm_vcpu *vcpu);
-void __vgic_v3_save_aprs(struct kvm_vcpu *vcpu);
-void __vgic_v3_restore_aprs(struct kvm_vcpu *vcpu);
+void __vgic_v3_save_state(struct vgic_v3_cpu_if *cpu_if);
+void __vgic_v3_restore_state(struct vgic_v3_cpu_if *cpu_if);
+void __vgic_v3_activate_traps(struct vgic_v3_cpu_if *cpu_if);
+void __vgic_v3_deactivate_traps(struct vgic_v3_cpu_if *cpu_if);
+void __vgic_v3_save_aprs(struct vgic_v3_cpu_if *cpu_if);
+void __vgic_v3_restore_aprs(struct vgic_v3_cpu_if *cpu_if);
 
 asmlinkage void __vfp_save_state(struct vfp_hard_struct *vfp);
 asmlinkage void __vfp_restore_state(struct vfp_hard_struct *vfp);
diff --git a/arch/arm/kvm/hyp/switch.c b/arch/arm/kvm/hyp/switch.c
index 6e9c3f11bfa4..92513fb5bfa2 100644
--- a/arch/arm/kvm/hyp/switch.c
+++ b/arch/arm/kvm/hyp/switch.c
@@ -90,16 +90,16 @@ static void __hyp_text __deactivate_vm(struct kvm_vcpu *vcpu)
 static void __hyp_text __vgic_save_state(struct kvm_vcpu *vcpu)
 {
 	if (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif)) {
-		__vgic_v3_save_state(vcpu);
-		__vgic_v3_deactivate_traps(vcpu);
+		__vgic_v3_save_state(&vcpu->arch.vgic_cpu.vgic_v3);
+		__vgic_v3_deactivate_traps(&vcpu->arch.vgic_cpu.vgic_v3);
 	}
 }
 
 static void __hyp_text __vgic_restore_state(struct kvm_vcpu *vcpu)
 {
 	if (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif)) {
-		__vgic_v3_activate_traps(vcpu);
-		__vgic_v3_restore_state(vcpu);
+		__vgic_v3_activate_traps(&vcpu->arch.vgic_cpu.vgic_v3);
+		__vgic_v3_restore_state(&vcpu->arch.vgic_cpu.vgic_v3);
 	}
 }
 
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index e8044f265824..3ebbf307d2e2 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -83,12 +83,12 @@ typeof(orig) * __hyp_text fname(void)					\
 
 int __vgic_v2_perform_cpuif_access(struct kvm_vcpu *vcpu);
 
-void __vgic_v3_save_state(struct kvm_vcpu *vcpu);
-void __vgic_v3_restore_state(struct kvm_vcpu *vcpu);
-void __vgic_v3_activate_traps(struct kvm_vcpu *vcpu);
-void __vgic_v3_deactivate_traps(struct kvm_vcpu *vcpu);
-void __vgic_v3_save_aprs(struct kvm_vcpu *vcpu);
-void __vgic_v3_restore_aprs(struct kvm_vcpu *vcpu);
+void __vgic_v3_save_state(struct vgic_v3_cpu_if *cpu_if);
+void __vgic_v3_restore_state(struct vgic_v3_cpu_if *cpu_if);
+void __vgic_v3_activate_traps(struct vgic_v3_cpu_if *cpu_if);
+void __vgic_v3_deactivate_traps(struct vgic_v3_cpu_if *cpu_if);
+void __vgic_v3_save_aprs(struct vgic_v3_cpu_if *cpu_if);
+void __vgic_v3_restore_aprs(struct vgic_v3_cpu_if *cpu_if);
 int __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu);
 
 void __timer_enable_traps(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index bd9fc0dae8e8..0fba9d47ff56 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -271,8 +271,8 @@ static void __hyp_text __deactivate_vm(struct kvm_vcpu *vcpu)
 static void __hyp_text __hyp_vgic_save_state(struct kvm_vcpu *vcpu)
 {
 	if (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif)) {
-		__vgic_v3_save_state(vcpu);
-		__vgic_v3_deactivate_traps(vcpu);
+		__vgic_v3_save_state(&vcpu->arch.vgic_cpu.vgic_v3);
+		__vgic_v3_deactivate_traps(&vcpu->arch.vgic_cpu.vgic_v3);
 	}
 }
 
@@ -280,8 +280,8 @@ static void __hyp_text __hyp_vgic_save_state(struct kvm_vcpu *vcpu)
 static void __hyp_text __hyp_vgic_restore_state(struct kvm_vcpu *vcpu)
 {
 	if (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif)) {
-		__vgic_v3_activate_traps(vcpu);
-		__vgic_v3_restore_state(vcpu);
+		__vgic_v3_activate_traps(&vcpu->arch.vgic_cpu.vgic_v3);
+		__vgic_v3_restore_state(&vcpu->arch.vgic_cpu.vgic_v3);
 	}
 }
 
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 7fc3b413b3de..163b132e100e 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -278,6 +278,8 @@ struct vgic_v2_cpu_if {
 	u32		vgic_vmcr;
 	u32		vgic_apr;
 	u32		vgic_lr[VGIC_V2_MAX_LRS];
+
+	unsigned int used_lrs;
 };
 
 struct vgic_v3_cpu_if {
@@ -295,6 +297,8 @@ struct vgic_v3_cpu_if {
 	 * linking the Linux IRQ subsystem and the ITS together.
 	 */
 	struct its_vpe	its_vpe;
+
+	unsigned int used_lrs;
 };
 
 struct vgic_cpu {
@@ -304,7 +308,6 @@ struct vgic_cpu {
 		struct vgic_v3_cpu_if	vgic_v3;
 	};
 
-	unsigned int used_lrs;
 	struct vgic_irq private_irqs[VGIC_NR_PRIVATE_IRQS];
 
 	raw_spinlock_t ap_list_lock;	/* Protects the ap_list */
diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
index 370bd6c5e6cb..b5d818d8b458 100644
--- a/virt/kvm/arm/hyp/vgic-v3-sr.c
+++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
@@ -205,10 +205,9 @@ static u32 __hyp_text __vgic_v3_read_ap1rn(int n)
 	return val;
 }
 
-void __hyp_text __vgic_v3_save_state(struct kvm_vcpu *vcpu)
+void __hyp_text __vgic_v3_save_state(struct vgic_v3_cpu_if *cpu_if)
 {
-	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
-	u64 used_lrs = vcpu->arch.vgic_cpu.used_lrs;
+	u64 used_lrs = cpu_if->used_lrs;
 
 	/*
 	 * Make sure stores to the GIC via the memory mapped interface
@@ -241,10 +240,9 @@ void __hyp_text __vgic_v3_save_state(struct kvm_vcpu *vcpu)
 	}
 }
 
-void __hyp_text __vgic_v3_restore_state(struct kvm_vcpu *vcpu)
+void __hyp_text __vgic_v3_restore_state(struct vgic_v3_cpu_if *cpu_if)
 {
-	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
-	u64 used_lrs = vcpu->arch.vgic_cpu.used_lrs;
+	u64 used_lrs = cpu_if->used_lrs;
 	int i;
 
 	if (used_lrs || cpu_if->its_vpe.its_vm) {
@@ -268,10 +266,8 @@ void __hyp_text __vgic_v3_restore_state(struct kvm_vcpu *vcpu)
 	}
 }
 
-void __hyp_text __vgic_v3_activate_traps(struct kvm_vcpu *vcpu)
+void __hyp_text __vgic_v3_activate_traps(struct vgic_v3_cpu_if *cpu_if)
 {
-	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
-
 	/*
 	 * VFIQEn is RES1 if ICC_SRE_EL1.SRE is 1. This causes a
 	 * Group0 interrupt (as generated in GICv2 mode) to be
@@ -317,9 +313,8 @@ void __hyp_text __vgic_v3_activate_traps(struct kvm_vcpu *vcpu)
 		write_gicreg(cpu_if->vgic_hcr, ICH_HCR_EL2);
 }
 
-void __hyp_text __vgic_v3_deactivate_traps(struct kvm_vcpu *vcpu)
+void __hyp_text __vgic_v3_deactivate_traps(struct vgic_v3_cpu_if *cpu_if)
 {
-	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
 	u64 val;
 
 	if (!cpu_if->vgic_sre) {
@@ -344,15 +339,11 @@ void __hyp_text __vgic_v3_deactivate_traps(struct kvm_vcpu *vcpu)
 		write_gicreg(0, ICH_HCR_EL2);
 }
 
-void __hyp_text __vgic_v3_save_aprs(struct kvm_vcpu *vcpu)
+void __hyp_text __vgic_v3_save_aprs(struct vgic_v3_cpu_if *cpu_if)
 {
-	struct vgic_v3_cpu_if *cpu_if;
 	u64 val;
 	u32 nr_pre_bits;
 
-	vcpu = kern_hyp_va(vcpu);
-	cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
-
 	val = read_gicreg(ICH_VTR_EL2);
 	nr_pre_bits = vtr_to_nr_pre_bits(val);
 
@@ -377,15 +368,11 @@ void __hyp_text __vgic_v3_save_aprs(struct kvm_vcpu *vcpu)
 	}
 }
 
-void __hyp_text __vgic_v3_restore_aprs(struct kvm_vcpu *vcpu)
+void __hyp_text __vgic_v3_restore_aprs(struct vgic_v3_cpu_if *cpu_if)
 {
-	struct vgic_v3_cpu_if *cpu_if;
 	u64 val;
 	u32 nr_pre_bits;
 
-	vcpu = kern_hyp_va(vcpu);
-	cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
-
 	val = read_gicreg(ICH_VTR_EL2);
 	nr_pre_bits = vtr_to_nr_pre_bits(val);
 
@@ -456,7 +443,7 @@ static int __hyp_text __vgic_v3_highest_priority_lr(struct kvm_vcpu *vcpu,
 						    u32 vmcr,
 						    u64 *lr_val)
 {
-	unsigned int used_lrs = vcpu->arch.vgic_cpu.used_lrs;
+	unsigned int used_lrs = vcpu->arch.vgic_cpu.vgic_v3.used_lrs;
 	u8 priority = GICv3_IDLE_PRIORITY;
 	int i, lr = -1;
 
@@ -495,7 +482,7 @@ static int __hyp_text __vgic_v3_highest_priority_lr(struct kvm_vcpu *vcpu,
 static int __hyp_text __vgic_v3_find_active_lr(struct kvm_vcpu *vcpu,
 					       int intid, u64 *lr_val)
 {
-	unsigned int used_lrs = vcpu->arch.vgic_cpu.used_lrs;
+	unsigned int used_lrs = vcpu->arch.vgic_cpu.vgic_v3.used_lrs;
 	int i;
 
 	for (i = 0; i < used_lrs; i++) {
diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
index d91a8938aa7c..66fdffe28ea9 100644
--- a/virt/kvm/arm/vgic/vgic-v2.c
+++ b/virt/kvm/arm/vgic/vgic-v2.c
@@ -67,7 +67,7 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
 
 	cpuif->vgic_hcr &= ~GICH_HCR_UIE;
 
-	for (lr = 0; lr < vgic_cpu->used_lrs; lr++) {
+	for (lr = 0; lr < vgic_cpu->vgic_v2.used_lrs; lr++) {
 		u32 val = cpuif->vgic_lr[lr];
 		u32 cpuid, intid = val & GICH_LR_VIRTUALID;
 		struct vgic_irq *irq;
@@ -131,7 +131,7 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
 		vgic_put_irq(vcpu->kvm, irq);
 	}
 
-	vgic_cpu->used_lrs = 0;
+	cpuif->used_lrs = 0;
 }
 
 /*
@@ -434,7 +434,7 @@ int vgic_v2_probe(const struct gic_kvm_info *info)
 static void save_lrs(struct kvm_vcpu *vcpu, void __iomem *base)
 {
 	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
-	u64 used_lrs = vcpu->arch.vgic_cpu.used_lrs;
+	u64 used_lrs = cpu_if->used_lrs;
 	u64 elrsr;
 	int i;
 
@@ -455,7 +455,7 @@ static void save_lrs(struct kvm_vcpu *vcpu, void __iomem *base)
 void vgic_v2_save_state(struct kvm_vcpu *vcpu)
 {
 	void __iomem *base = kvm_vgic_global_state.vctrl_base;
-	u64 used_lrs = vcpu->arch.vgic_cpu.used_lrs;
+	u64 used_lrs = vcpu->arch.vgic_cpu.vgic_v2.used_lrs;
 
 	if (!base)
 		return;
@@ -470,7 +470,7 @@ void vgic_v2_restore_state(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
 	void __iomem *base = kvm_vgic_global_state.vctrl_base;
-	u64 used_lrs = vcpu->arch.vgic_cpu.used_lrs;
+	u64 used_lrs = cpu_if->used_lrs;
 	int i;
 
 	if (!base)
diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index 9f87e58dbd4a..77d23e817756 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -51,7 +51,7 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
 
 	cpuif->vgic_hcr &= ~ICH_HCR_UIE;
 
-	for (lr = 0; lr < vgic_cpu->used_lrs; lr++) {
+	for (lr = 0; lr < cpuif->used_lrs; lr++) {
 		u64 val = cpuif->vgic_lr[lr];
 		u32 intid, cpuid;
 		struct vgic_irq *irq;
@@ -123,7 +123,7 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
 		vgic_put_irq(vcpu->kvm, irq);
 	}
 
-	vgic_cpu->used_lrs = 0;
+	cpuif->used_lrs = 0;
 }
 
 /* Requires the irq to be locked already */
@@ -668,10 +668,10 @@ void vgic_v3_load(struct kvm_vcpu *vcpu)
 	if (likely(cpu_if->vgic_sre))
 		kvm_call_hyp(__vgic_v3_write_vmcr, cpu_if->vgic_vmcr);
 
-	kvm_call_hyp(__vgic_v3_restore_aprs, vcpu);
+	kvm_call_hyp(__vgic_v3_restore_aprs, kern_hyp_va(cpu_if));
 
 	if (has_vhe())
-		__vgic_v3_activate_traps(vcpu);
+		__vgic_v3_activate_traps(cpu_if);
 }
 
 void vgic_v3_put(struct kvm_vcpu *vcpu)
@@ -681,8 +681,8 @@ void vgic_v3_put(struct kvm_vcpu *vcpu)
 	if (likely(cpu_if->vgic_sre))
 		cpu_if->vgic_vmcr = kvm_call_hyp_ret(__vgic_v3_read_vmcr);
 
-	kvm_call_hyp(__vgic_v3_save_aprs, vcpu);
+	kvm_call_hyp(__vgic_v3_save_aprs, kern_hyp_va(cpu_if));
 
 	if (has_vhe())
-		__vgic_v3_deactivate_traps(vcpu);
+		__vgic_v3_deactivate_traps(cpu_if);
 }
diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index 1c5b4dbd33e4..6953aefecbb6 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -797,6 +797,7 @@ static void vgic_flush_lr_state(struct kvm_vcpu *vcpu)
 	int count;
 	bool multi_sgi;
 	u8 prio = 0xff;
+	int i = 0;
 
 	lockdep_assert_held(&vgic_cpu->ap_list_lock);
 
@@ -838,11 +839,14 @@ static void vgic_flush_lr_state(struct kvm_vcpu *vcpu)
 		}
 	}
 
-	vcpu->arch.vgic_cpu.used_lrs = count;
-
 	/* Nuke remaining LRs */
-	for ( ; count < kvm_vgic_global_state.nr_lr; count++)
-		vgic_clear_lr(vcpu, count);
+	for (i = count ; i < kvm_vgic_global_state.nr_lr; i++)
+		vgic_clear_lr(vcpu, i);
+
+	if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
+		vcpu->arch.vgic_cpu.vgic_v2.used_lrs = count;
+	else
+		vcpu->arch.vgic_cpu.vgic_v3.used_lrs = count;
 }
 
 static inline bool can_access_vgic_from_kernel(void)
@@ -860,13 +864,13 @@ static inline void vgic_save_state(struct kvm_vcpu *vcpu)
 	if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
 		vgic_v2_save_state(vcpu);
 	else
-		__vgic_v3_save_state(vcpu);
+		__vgic_v3_save_state(&vcpu->arch.vgic_cpu.vgic_v3);
 }
 
 /* Sync back the hardware VGIC state into our emulation after a guest's run. */
 void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
 {
-	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
+	int used_lrs;
 
 	WARN_ON(vgic_v4_sync_hwstate(vcpu));
 
@@ -877,7 +881,12 @@ void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
 	if (can_access_vgic_from_kernel())
 		vgic_save_state(vcpu);
 
-	if (vgic_cpu->used_lrs)
+	if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
+		used_lrs = vcpu->arch.vgic_cpu.vgic_v2.used_lrs;
+	else
+		used_lrs = vcpu->arch.vgic_cpu.vgic_v3.used_lrs;
+
+	if (used_lrs)
 		vgic_fold_lr_state(vcpu);
 	vgic_prune_ap_list(vcpu);
 }
@@ -887,7 +896,7 @@ static inline void vgic_restore_state(struct kvm_vcpu *vcpu)
 	if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
 		vgic_v2_restore_state(vcpu);
 	else
-		__vgic_v3_restore_state(vcpu);
+		__vgic_v3_restore_state(&vcpu->arch.vgic_cpu.vgic_v3);
 }
 
 /* Flush our emulation state into the GIC hardware before entering the guest. */
-- 
2.20.1

