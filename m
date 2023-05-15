Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 040D2703A41
	for <lists+kvm@lfdr.de>; Mon, 15 May 2023 19:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244845AbjEORuN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 May 2023 13:50:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244851AbjEORtt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 May 2023 13:49:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54BB01C3AA
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 10:47:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 542EE62F13
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 17:47:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B16AC4339C;
        Mon, 15 May 2023 17:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684172862;
        bh=ed11ywc5Sg41IevOdDgmy9Bdg7U9U9+IcpEmKWLmFLw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W+jYPy4o+TIP/Xd7j2fanjGtUPEZ15SQlSw3vzK4EYDcT+D22u+6agYzmoMYkhTaK
         X29UXMbTA+w12boH9P/3Xy1On4XVbVikk9n5DyFBf6lcswAdiGeod82v7V648mkvGD
         EwIHXhjFGbNjaDUllt/xxfoWgfDJQE+sNh02DQd7OfLQdTE89ixYnrIELN7eZoRcZ/
         7VxkKsU/EnhCfQ2J2e7CEn9PcT5Z5suyTR2MW/RqNuCcHGYbJoC5X3RUcmmoOIdaFU
         xAUMYrqxT/DG/ShBFQBl+K5++Oj9gJlAk8iqivSL3rLBZoe6VPpjfGg8GI7HGKys+3
         gZVwnX8r8PeAg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pyc39-00FJAF-6k;
        Mon, 15 May 2023 18:31:55 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Darren Hart <darren@os.amperecomputing.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Miguel Luis <miguel.luis@oracle.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v10 49/59] KVM: arm64: nv: Move nested vgic state into the sysreg file
Date:   Mon, 15 May 2023 18:30:53 +0100
Message-Id: <20230515173103.1017669-50-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230515173103.1017669-1-maz@kernel.org>
References: <20230515173103.1017669-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, miguel.luis@oracle.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The vgic nested state needs to be accessible from the VNCR page, and
thus needs to be part of the normal sysreg file. Let's move it there.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h    |  9 +++
 arch/arm64/kvm/sys_regs.c            | 53 ++++++++++++------
 arch/arm64/kvm/vgic/vgic-v3-nested.c | 82 ++++++++++++++--------------
 arch/arm64/kvm/vgic/vgic-v3.c        | 12 ++--
 arch/arm64/kvm/vgic/vgic.h           | 10 ++++
 include/kvm/arm_vgic.h               |  7 ---
 6 files changed, 104 insertions(+), 69 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 14e5bdbe7153..eb8ad037f1c5 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -448,6 +448,15 @@ enum vcpu_sysreg {
 	VNCR(CNTP_CVAL_EL0),
 	VNCR(CNTP_CTL_EL0),
 
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
index 3c2fe3fd9ab3..228dba82e9e5 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2025,17 +2025,17 @@ static bool access_gic_apr(struct kvm_vcpu *vcpu,
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
 
@@ -2046,12 +2046,10 @@ static bool access_gic_hcr(struct kvm_vcpu *vcpu,
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
@@ -2108,12 +2106,19 @@ static bool access_gic_vmcr(struct kvm_vcpu *vcpu,
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
@@ -2122,17 +2127,29 @@ static bool access_gic_lr(struct kvm_vcpu *vcpu,
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
diff --git a/arch/arm64/kvm/vgic/vgic-v3-nested.c b/arch/arm64/kvm/vgic/vgic-v3-nested.c
index 919275b94625..12937bc86e1c 100644
--- a/arch/arm64/kvm/vgic/vgic-v3-nested.c
+++ b/arch/arm64/kvm/vgic/vgic-v3-nested.c
@@ -15,11 +15,6 @@
 
 #include "vgic.h"
 
-static inline struct vgic_v3_cpu_if *vcpu_nested_if(struct kvm_vcpu *vcpu)
-{
-	return &vcpu->arch.vgic_cpu.nested_vgic_v3;
-}
-
 static inline struct vgic_v3_cpu_if *vcpu_shadow_if(struct kvm_vcpu *vcpu)
 {
 	return &vcpu->arch.vgic_cpu.shadow_vgic_v3;
@@ -32,12 +27,11 @@ static inline bool lr_triggers_eoi(u64 lr)
 
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
 
@@ -46,12 +40,11 @@ u16 vgic_v3_get_eisr(struct kvm_vcpu *vcpu)
 
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
 
@@ -60,14 +53,13 @@ u16 vgic_v3_get_elrsr(struct kvm_vcpu *vcpu)
 
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
@@ -86,13 +78,12 @@ u64 vgic_v3_get_misr(struct kvm_vcpu *vcpu)
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
@@ -124,31 +115,14 @@ static void vgic_v3_create_shadow_lr(struct kvm_vcpu *vcpu)
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
@@ -172,14 +146,27 @@ void vgic_v3_sync_nested(struct kvm_vcpu *vcpu)
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
@@ -193,16 +180,32 @@ void vgic_v3_load_nested(struct kvm_vcpu *vcpu)
 
 void vgic_v3_put_nested(struct kvm_vcpu *vcpu)
 {
-	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
+	struct vgic_v3_cpu_if *s_cpu_if = vcpu_shadow_if(vcpu);
+	int i;
 
-	__vgic_v3_save_state(vcpu_shadow_if(vcpu));
+	__vgic_v3_save_state(s_cpu_if);
 
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
@@ -216,10 +219,9 @@ void vgic_v3_handle_nested_maint_irq(struct kvm_vcpu *vcpu)
 	 * again.
 	 */
 	if (vgic_state_is_nested(vcpu)) {
-		struct vgic_v3_cpu_if *cpu_if = vcpu_nested_if(vcpu);
 		bool state;
 
-		state  = cpu_if->vgic_hcr & ICH_HCR_EN;
+		state  = __vcpu_sys_reg(vcpu, ICH_HCR_EL2) & ICH_HCR_EN;
 		state &= vgic_v3_get_misr(vcpu);
 
 		kvm_vgic_inject_irq(vcpu->kvm, vcpu->vcpu_id,
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 4e907c2b1c20..c520c12744b2 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -281,10 +281,11 @@ void vgic_v3_enable(struct kvm_vcpu *vcpu)
 				     ICC_SRE_EL1_SRE);
 		/*
 		 * If nesting is allowed, force GICv3 onto the nested
-		 * guests as well.
+		 * guests as well by setting the shadow state to the
+		 * same value.
 		 */
 		if (vcpu_has_nv(vcpu))
-			vcpu->arch.vgic_cpu.nested_vgic_v3.vgic_sre = vgic_v3->vgic_sre;
+			vcpu->arch.vgic_cpu.shadow_vgic_v3.vgic_sre = vgic_v3->vgic_sre;
 		vcpu->arch.vgic_cpu.pendbaser = INITIAL_PENDBASER_VALUE;
 	} else {
 		vgic_v3->vgic_sre = 0;
@@ -738,10 +739,13 @@ void vgic_v3_load(struct kvm_vcpu *vcpu)
 	vcpu->arch.vgic_cpu.current_cpu_if = cpu_if;
 
 	/*
-	 * vgic_v3_load_nested only affects the LRs in the shadow
-	 * state, so it is fine to pass the nested state around.
+	 * If the vgic is in nested state, populate the shadow state
+	 * from the guest's nested state. As vgic_v3_load_nested()
+	 * will only load LRs, let's deal with the rest of the state
+	 * here as if it was a non-nested state. Cunning.
 	 */
 	if (vgic_state_is_nested(vcpu)) {
+		vgic_v3_create_shadow_state(vcpu);
 		cpu_if = &vcpu->arch.vgic_cpu.shadow_vgic_v3;
 		vcpu->arch.vgic_cpu.current_cpu_if = cpu_if;
 	}
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index f9923beedd27..bbf07bde4dc0 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -344,4 +344,14 @@ void vgic_v4_configure_vsgis(struct kvm *kvm);
 void vgic_v4_get_vlpi_state(struct vgic_irq *irq, bool *val);
 int vgic_v4_request_vpe_irq(struct kvm_vcpu *vcpu, int irq);
 
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
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 1a2e2e8abd92..9b91a8135dac 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -334,9 +334,6 @@ struct vgic_cpu {
 
 	struct vgic_irq private_irqs[VGIC_NR_PRIVATE_IRQS];
 
-	/* CPU vif control registers for the virtual GICH interface */
-	struct vgic_v3_cpu_if	nested_vgic_v3;
-
 	/*
 	 * The shadow vif control register loaded to the hardware when
 	 * running a nested L2 guest with the virtual IMO/FMO bit set.
@@ -403,10 +400,6 @@ void kvm_vgic_load(struct kvm_vcpu *vcpu);
 void kvm_vgic_put(struct kvm_vcpu *vcpu);
 void kvm_vgic_vmcr_sync(struct kvm_vcpu *vcpu);
 
-void vgic_v3_sync_nested(struct kvm_vcpu *vcpu);
-void vgic_v3_load_nested(struct kvm_vcpu *vcpu);
-void vgic_v3_put_nested(struct kvm_vcpu *vcpu);
-void vgic_v3_handle_nested_maint_irq(struct kvm_vcpu *vcpu);
 u16 vgic_v3_get_eisr(struct kvm_vcpu *vcpu);
 u16 vgic_v3_get_elrsr(struct kvm_vcpu *vcpu);
 u64 vgic_v3_get_misr(struct kvm_vcpu *vcpu);
-- 
2.34.1

