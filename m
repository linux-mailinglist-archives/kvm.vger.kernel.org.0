Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4971596A6
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 18:51:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730276AbgBKRvM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 12:51:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:53392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730238AbgBKRvL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 12:51:11 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B10C5206D6;
        Tue, 11 Feb 2020 17:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581443471;
        bh=iD+dO0Xdz4rLOP0a58aDH/YSqaLiXx6FsLfAjEm2ro0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qRjumTLmAcaRBObhPd6R0WQ25oxocU491DJLNnCogWs6VALAJi0ofN9vY+vL0WX8Y
         L94vIZBEslq1+CJvpuXZv0kgt11sQLzHzRURz/0BM3USpzZbm4ksgSst8q5J9blNgw
         Y/nQWG1V5rCYeHmHmXXkyEVuVC13JcPMPtzf1IeY=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1j1ZgG-004O7k-44; Tue, 11 Feb 2020 17:50:40 +0000
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
Subject: [PATCH v2 79/94] KVM: arm64: nv: Move nested vgic state into the sysreg file
Date:   Tue, 11 Feb 2020 17:49:23 +0000
Message-Id: <20200211174938.27809-80-maz@kernel.org>
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

The vgic nested state needs to be accessible from the VNCR page, and
thus needs to be part of the normal sysreg file. Let's move it there.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h  |  9 +++
 arch/arm64/kvm/sys_regs.c          | 53 ++++++++++++------
 include/kvm/arm_vgic.h             |  7 ---
 virt/kvm/arm/vgic/vgic-v3-nested.c | 88 +++++++++++++++---------------
 virt/kvm/arm/vgic/vgic-v3.c        | 18 ++++--
 virt/kvm/arm/vgic/vgic.h           | 10 ++++
 6 files changed, 111 insertions(+), 74 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index e160cf283601..7a66abd3df7e 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -272,6 +272,15 @@ enum vcpu_sysreg {
 	VNCR(VTCR_EL2),	/* Virtualization Translation Control Register */
 	VNCR(TPIDR_EL2),/* EL2 Software Thread ID Register */
 
+	VNCR(ICH_LR0_EL2),
+	ICH_LR15_EL2 = ICH_LR0_EL2 + 15,
+	VNCR(ICH_AP0R0_EL2),
+	ICH_AP0R3_EL2 = ICH_AP0R0_EL2 + 3,
+	VNCR(ICH_AP1R0_EL2),
+	ICH_AP1R3_EL2 = ICH_AP1R0_EL2 + 3,
+	VNCR(ICH_HCR_EL2),
+	VNCR(ICH_VMCR_EL2),
+
 	NR_SYS_REGS	/* Nothing after this line! */
 };
 
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 9d426304bfb3..5a41788054b7 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1880,17 +1880,17 @@ static bool access_gic_apr(struct kvm_vcpu *vcpu,
 			   struct sys_reg_params *p,
 			   const struct sys_reg_desc *r)
 {
-	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.nested_vgic_v3;
-	u32 index, *base;
+	u64 *base;
+	u8 index;
 
 	index = r->Op2;
 	if (r->CRm == 8)
-		base = cpu_if->vgic_ap0r;
+		base = __ctxt_sys_reg(&vcpu->arch.ctxt, ICH_AP0R0_EL2);
 	else
-		base = cpu_if->vgic_ap1r;
+		base = __ctxt_sys_reg(&vcpu->arch.ctxt, ICH_AP1R0_EL2);
 
 	if (p->is_write)
-		base[index] = p->regval;
+		base[index] = lower_32_bits(p->regval);
 	else
 		p->regval = base[index];
 
@@ -1901,12 +1901,10 @@ static bool access_gic_hcr(struct kvm_vcpu *vcpu,
 			   struct sys_reg_params *p,
 			   const struct sys_reg_desc *r)
 {
-	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.nested_vgic_v3;
-
 	if (p->is_write)
-		cpu_if->vgic_hcr = p->regval;
+		__vcpu_sys_reg(vcpu, ICH_HCR_EL2) = lower_32_bits(p->regval);
 	else
-		p->regval = cpu_if->vgic_hcr;
+		p->regval = __vcpu_sys_reg(vcpu, ICH_HCR_EL2);
 
 	return true;
 }
@@ -1963,12 +1961,19 @@ static bool access_gic_vmcr(struct kvm_vcpu *vcpu,
 			    struct sys_reg_params *p,
 			    const struct sys_reg_desc *r)
 {
-	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.nested_vgic_v3;
-
 	if (p->is_write)
-		cpu_if->vgic_vmcr = p->regval;
+		__vcpu_sys_reg(vcpu, ICH_VMCR_EL2) = (p->regval	&
+						      (ICH_VMCR_ENG0_MASK	|
+						       ICH_VMCR_ENG1_MASK	|
+						       ICH_VMCR_PMR_MASK	|
+						       ICH_VMCR_BPR0_MASK	|
+						       ICH_VMCR_BPR1_MASK	|
+						       ICH_VMCR_EOIM_MASK	|
+						       ICH_VMCR_CBPR_MASK	|
+						       ICH_VMCR_FIQ_EN_MASK	|
+						       ICH_VMCR_ACK_CTL_MASK));
 	else
-		p->regval = cpu_if->vgic_vmcr;
+		p->regval = __vcpu_sys_reg(vcpu, ICH_VMCR_EL2);
 
 	return true;
 }
@@ -1977,17 +1982,29 @@ static bool access_gic_lr(struct kvm_vcpu *vcpu,
 			  struct sys_reg_params *p,
 			  const struct sys_reg_desc *r)
 {
-	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.nested_vgic_v3;
 	u32 index;
+	u64 *base;
 
+	base = __ctxt_sys_reg(&vcpu->arch.ctxt, ICH_LR0_EL2);
 	index = p->Op2;
 	if (p->CRm == 13)
 		index += 8;
 
-	if (p->is_write)
-		cpu_if->vgic_lr[index] = p->regval;
-	else
-		p->regval = cpu_if->vgic_lr[index];
+	if (p->is_write) {
+		u64 mask = (ICH_LR_VIRTUAL_ID_MASK	|
+			    ICH_LR_GROUP		|
+			    ICH_LR_HW			|
+			    ICH_LR_STATE);
+
+		if (p->regval & ICH_LR_HW)
+			mask |= ICH_LR_PHYS_ID_MASK;
+		else
+			mask |= ICH_LR_EOI;
+
+		base[index] = p->regval & mask;
+	} else {
+		p->regval = base[index];
+	}
 
 	return true;
 }
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index b5c026a7e0ee..a03148ee1266 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -305,9 +305,6 @@ struct vgic_cpu {
 
 	struct vgic_irq private_irqs[VGIC_NR_PRIVATE_IRQS];
 
-	/* CPU vif control registers for the virtual GICH interface */
-	struct vgic_v3_cpu_if	nested_vgic_v3;
-
 	/*
 	 * The shadow vif control register loaded to the hardware when
 	 * running a nested L2 guest with the virtual IMO/FMO bit set.
@@ -370,10 +367,6 @@ void kvm_vgic_load(struct kvm_vcpu *vcpu);
 void kvm_vgic_put(struct kvm_vcpu *vcpu);
 void kvm_vgic_vmcr_sync(struct kvm_vcpu *vcpu);
 
-void vgic_v3_sync_nested(struct kvm_vcpu *vcpu);
-void vgic_v3_load_nested(struct kvm_vcpu *vcpu);
-void vgic_v3_put_nested(struct kvm_vcpu *vcpu);
-void vgic_v3_handle_nested_maint_irq(struct kvm_vcpu *vcpu);
 u16 vgic_v3_get_eisr(struct kvm_vcpu *vcpu);
 u16 vgic_v3_get_elrsr(struct kvm_vcpu *vcpu);
 u64 vgic_v3_get_misr(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/arm/vgic/vgic-v3-nested.c b/virt/kvm/arm/vgic/vgic-v3-nested.c
index 94b1edb67011..51f7a521e829 100644
--- a/virt/kvm/arm/vgic/vgic-v3-nested.c
+++ b/virt/kvm/arm/vgic/vgic-v3-nested.c
@@ -16,11 +16,6 @@
 #define CREATE_TRACE_POINTS
 #include "vgic-nested-trace.h"
 
-static inline struct vgic_v3_cpu_if *vcpu_nested_if(struct kvm_vcpu *vcpu)
-{
-	return &vcpu->arch.vgic_cpu.nested_vgic_v3;
-}
-
 static inline struct vgic_v3_cpu_if *vcpu_shadow_if(struct kvm_vcpu *vcpu)
 {
 	return &vcpu->arch.vgic_cpu.shadow_vgic_v3;
@@ -33,12 +28,11 @@ static inline bool lr_triggers_eoi(u64 lr)
 
 u16 vgic_v3_get_eisr(struct kvm_vcpu *vcpu)
 {
-	struct vgic_v3_cpu_if *cpu_if = vcpu_nested_if(vcpu);
 	u16 reg = 0;
 	int i;
 
 	for (i = 0; i < kvm_vgic_global_state.nr_lr; i++) {
-		if (lr_triggers_eoi(cpu_if->vgic_lr[i]))
+		if (lr_triggers_eoi(__vcpu_sys_reg(vcpu, ICH_LRN(i))))
 			reg |= BIT(i);
 	}
 
@@ -47,12 +41,11 @@ u16 vgic_v3_get_eisr(struct kvm_vcpu *vcpu)
 
 u16 vgic_v3_get_elrsr(struct kvm_vcpu *vcpu)
 {
-	struct vgic_v3_cpu_if *cpu_if = vcpu_nested_if(vcpu);
 	u16 reg = 0;
 	int i;
 
 	for (i = 0; i < kvm_vgic_global_state.nr_lr; i++) {
-		if (!(cpu_if->vgic_lr[i] & ICH_LR_STATE))
+		if (!(__vcpu_sys_reg(vcpu, ICH_LRN(i)) & ICH_LR_STATE))
 			reg |= BIT(i);
 	}
 
@@ -61,14 +54,13 @@ u16 vgic_v3_get_elrsr(struct kvm_vcpu *vcpu)
 
 u64 vgic_v3_get_misr(struct kvm_vcpu *vcpu)
 {
-	struct vgic_v3_cpu_if *cpu_if = vcpu_nested_if(vcpu);
 	int nr_lr = kvm_vgic_global_state.nr_lr;
 	u64 reg = 0;
 
 	if (vgic_v3_get_eisr(vcpu))
 		reg |= ICH_MISR_EOI;
 
-	if (cpu_if->vgic_hcr & ICH_HCR_UIE) {
+	if (__vcpu_sys_reg(vcpu, ICH_HCR_EL2) & ICH_HCR_UIE) {
 		int used_lrs;
 
 		used_lrs = nr_lr - hweight16(vgic_v3_get_elrsr(vcpu));
@@ -87,13 +79,12 @@ u64 vgic_v3_get_misr(struct kvm_vcpu *vcpu)
  */
 static void vgic_v3_create_shadow_lr(struct kvm_vcpu *vcpu)
 {
-	struct vgic_v3_cpu_if *cpu_if = vcpu_nested_if(vcpu);
 	struct vgic_v3_cpu_if *s_cpu_if = vcpu_shadow_if(vcpu);
 	struct vgic_irq *irq;
 	int i, used_lrs = 0;
 
 	for (i = 0; i < kvm_vgic_global_state.nr_lr; i++) {
-		u64 lr = cpu_if->vgic_lr[i];
+		u64 lr = __vcpu_sys_reg(vcpu, ICH_LRN(i));
 		int l1_irq;
 
 		if (!(lr & ICH_LR_HW))
@@ -123,36 +114,20 @@ static void vgic_v3_create_shadow_lr(struct kvm_vcpu *vcpu)
 	}
 
 	trace_vgic_create_shadow_lrs(vcpu, kvm_vgic_global_state.nr_lr,
-				     s_cpu_if->vgic_lr, cpu_if->vgic_lr);
+				     s_cpu_if->vgic_lr,
+				     __ctxt_sys_reg(&vcpu->arch.ctxt, ICH_LR0_EL2));
 
 	s_cpu_if->used_lrs = used_lrs;
 }
 
-/*
- * Change the shadow HWIRQ field back to the virtual value before copying over
- * the entire shadow struct to the nested state.
- */
-static void vgic_v3_fixup_shadow_lr_state(struct kvm_vcpu *vcpu)
-{
-	struct vgic_v3_cpu_if *cpu_if = vcpu_nested_if(vcpu);
-	struct vgic_v3_cpu_if *s_cpu_if = vcpu_shadow_if(vcpu);
-	int lr;
-
-	for (lr = 0; lr < kvm_vgic_global_state.nr_lr; lr++) {
-		s_cpu_if->vgic_lr[lr] &= ~ICH_LR_PHYS_ID_MASK;
-		s_cpu_if->vgic_lr[lr] |= cpu_if->vgic_lr[lr] & ICH_LR_PHYS_ID_MASK;
-	}
-}
-
 void vgic_v3_sync_nested(struct kvm_vcpu *vcpu)
 {
-	struct vgic_v3_cpu_if *cpu_if = vcpu_nested_if(vcpu);
 	struct vgic_v3_cpu_if *s_cpu_if = vcpu_shadow_if(vcpu);
 	struct vgic_irq *irq;
 	int i;
 
 	for (i = 0; i < s_cpu_if->used_lrs; i++) {
-		u64 lr = cpu_if->vgic_lr[i];
+		u64 lr = __vcpu_sys_reg(vcpu, ICH_LRN(i));
 		int l1_irq;
 
 		if (!(lr & ICH_LR_HW) || !(lr & ICH_LR_STATE))
@@ -178,14 +153,27 @@ void vgic_v3_sync_nested(struct kvm_vcpu *vcpu)
 	}
 }
 
+void vgic_v3_create_shadow_state(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.shadow_vgic_v3;
+	int i;
+
+	cpu_if->vgic_hcr = __vcpu_sys_reg(vcpu, ICH_HCR_EL2);
+	cpu_if->vgic_vmcr = __vcpu_sys_reg(vcpu, ICH_VMCR_EL2);
+
+	for (i = 0; i < 4; i++) {
+		cpu_if->vgic_ap0r[i] = __vcpu_sys_reg(vcpu, ICH_AP0RN(i));
+		cpu_if->vgic_ap1r[i] = __vcpu_sys_reg(vcpu, ICH_AP1RN(i));
+	}
+
+	vgic_v3_create_shadow_lr(vcpu);
+}
+
 void vgic_v3_load_nested(struct kvm_vcpu *vcpu)
 {
-	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
 	struct vgic_irq *irq;
 	unsigned long flags;
 
-	vgic_cpu->shadow_vgic_v3 = vgic_cpu->nested_vgic_v3;
-	vgic_v3_create_shadow_lr(vcpu);
 	__vgic_v3_restore_state(vcpu_shadow_if(vcpu));
 
 	irq = vgic_get_irq(vcpu->kvm, vcpu, vcpu->kvm->arch.vgic.maint_irq);
@@ -199,26 +187,40 @@ void vgic_v3_load_nested(struct kvm_vcpu *vcpu)
 
 void vgic_v3_put_nested(struct kvm_vcpu *vcpu)
 {
-	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
+	struct vgic_v3_cpu_if *s_cpu_if = vcpu_shadow_if(vcpu);
+	int i;
 
-	__vgic_v3_save_state(vcpu_shadow_if(vcpu));
+	__vgic_v3_save_state(s_cpu_if);
 
-	trace_vgic_put_nested(vcpu, kvm_vgic_global_state.nr_lr,
-			      vcpu_shadow_if(vcpu)->vgic_lr);
+	trace_vgic_put_nested(vcpu, kvm_vgic_global_state.nr_lr, s_cpu_if->vgic_lr);
 
 	/*
 	 * Translate the shadow state HW fields back to the virtual ones
 	 * before copying the shadow struct back to the nested one.
 	 */
-	vgic_v3_fixup_shadow_lr_state(vcpu);
-	vgic_cpu->nested_vgic_v3 = vgic_cpu->shadow_vgic_v3;
+	__vcpu_sys_reg(vcpu, ICH_HCR_EL2) = s_cpu_if->vgic_hcr;
+	__vcpu_sys_reg(vcpu, ICH_VMCR_EL2) = s_cpu_if->vgic_vmcr;
+
+	for (i = 0; i < 4; i++) {
+		__vcpu_sys_reg(vcpu, ICH_AP0RN(i)) = s_cpu_if->vgic_ap0r[i];
+		__vcpu_sys_reg(vcpu, ICH_AP1RN(i)) = s_cpu_if->vgic_ap1r[i];
+	}
+
+	for (i = 0; i < kvm_vgic_global_state.nr_lr; i++) {
+		u64 val = __vcpu_sys_reg(vcpu, ICH_LRN(i));
+
+		val &= ~ICH_LR_STATE;
+		val |= s_cpu_if->vgic_lr[i] & ICH_LR_STATE;
+
+		__vcpu_sys_reg(vcpu, ICH_LRN(i)) = val;
+	}
+
 	irq_set_irqchip_state(kvm_vgic_global_state.maint_irq,
 			      IRQCHIP_STATE_ACTIVE, false);
 }
 
 void vgic_v3_handle_nested_maint_irq(struct kvm_vcpu *vcpu)
 {
-	struct vgic_v3_cpu_if *cpu_if = vcpu_nested_if(vcpu);
 	bool state;
 
 	/*
@@ -230,7 +232,7 @@ void vgic_v3_handle_nested_maint_irq(struct kvm_vcpu *vcpu)
 	if (!vgic_state_is_nested(vcpu))
 		return;
 
-	state  = cpu_if->vgic_hcr & ICH_HCR_EN;
+	state  = __vcpu_sys_reg(vcpu, ICH_HCR_EL2) & ICH_HCR_EN;
 	state &= vgic_v3_get_misr(vcpu);
 
 	kvm_vgic_inject_irq(vcpu->kvm, vcpu->vcpu_id,
diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index bca20528d5d1..e8c63c8d017a 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -292,10 +292,11 @@ void vgic_v3_enable(struct kvm_vcpu *vcpu)
 				     ICC_SRE_EL1_SRE);
 		/*
 		 * If nesting is allowed, force GICv3 onto the nested
-		 * guests as well.
+		 * guests as well by setting the shadow state to the
+		 * same value.
 		 */
 		if (nested_virt_in_use(vcpu))
-			vcpu->arch.vgic_cpu.nested_vgic_v3.vgic_sre = vgic_v3->vgic_sre;
+			vcpu->arch.vgic_cpu.shadow_vgic_v3.vgic_sre = vgic_v3->vgic_sre;
 		vcpu->arch.vgic_cpu.pendbaser = INITIAL_PENDBASER_VALUE;
 	} else {
 		vgic_v3->vgic_sre = 0;
@@ -660,11 +661,15 @@ void vgic_v3_load(struct kvm_vcpu *vcpu)
 	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
 
 	/*
-	 * vgic_v3_load_nested only affects the LRs in the shadow
-	 * state, so it is fine to pass the nested state around.
+	 * If the vgic is in nested state, populate the shadow state
+	 * from the guest's nested state. As vgic_v3_load_nested()
+	 * will only load LRs, let's deal with the rest of the state
+	 * here as if it was a non-nested state. Cunning.
 	 */
-	if (vgic_state_is_nested(vcpu))
-		cpu_if = &vcpu->arch.vgic_cpu.nested_vgic_v3;
+	if (vgic_state_is_nested(vcpu)) {
+		vgic_v3_create_shadow_state(vcpu);
+		cpu_if = &vcpu->arch.vgic_cpu.shadow_vgic_v3;
+	}
 
 	/*
 	 * If dealing with a GICv2 emulation on GICv3, VMCR_EL2.VFIQen
@@ -718,5 +723,6 @@ void vgic_v3_put(struct kvm_vcpu *vcpu)
 
 __weak void vgic_v3_sync_nested(struct kvm_vcpu *vcpu) {}
 __weak void vgic_v3_handle_nested_maint_irq(struct kvm_vcpu *vcpu) {}
+__weak void vgic_v3_create_shadow_state(struct kvm_vcpu *vcpu) {}
 __weak void vgic_v3_load_nested(struct kvm_vcpu *vcpu) {}
 __weak void vgic_v3_put_nested(struct kvm_vcpu *vcpu) {}
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index c7fefd6b1c80..a8f97e95fe31 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -317,4 +317,14 @@ bool vgic_supports_direct_msis(struct kvm *kvm);
 int vgic_v4_init(struct kvm *kvm);
 void vgic_v4_teardown(struct kvm *kvm);
 
+void vgic_v3_sync_nested(struct kvm_vcpu *vcpu);
+void vgic_v3_create_shadow_state(struct kvm_vcpu *vcpu);
+void vgic_v3_load_nested(struct kvm_vcpu *vcpu);
+void vgic_v3_put_nested(struct kvm_vcpu *vcpu);
+void vgic_v3_handle_nested_maint_irq(struct kvm_vcpu *vcpu);
+
+#define ICH_LRN(n)	(ICH_LR0_EL2 + (n))
+#define ICH_AP0RN(n)	(ICH_AP0R0_EL2 + (n))
+#define ICH_AP1RN(n)	(ICH_AP1R0_EL2 + (n))
+
 #endif
-- 
2.20.1

