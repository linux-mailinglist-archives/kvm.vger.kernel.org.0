Return-Path: <kvm+bounces-63342-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id E1C40C6323B
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 10:22:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 590644ED29B
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 09:16:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86540327204;
	Mon, 17 Nov 2025 09:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oT0W65Pq"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70C73324B35;
	Mon, 17 Nov 2025 09:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763370941; cv=none; b=nBNw+37w69mngUiPwgwWdTd+uQCY9f/FVWxyCvC6Qw6c9gmhHJSDSs/ib+x9GsZH7zga3HL9hs70rrlHBu0r0vGBG3qhV3kXCwukuZ+TAFy1NCxLDF25Jpp2hn9ldMTlPzHO894An/27p72gIQPc/V+XPTDN/1yxabzItmK1e34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763370941; c=relaxed/simple;
	bh=SjAPAT7Ii/PBx38u8BcV3f0g82AGlAuOBhVYh0MSvsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YMep22gyN7bttU/snfF2txUh5BLY7m6PiIotcrZPdqILElDCenOBjGT5lMpSvlvA1Sj9i5XOFajkNua8aozs+caMX/b3h6cL/ENvb1EglsAkLOsHc6kmm4jfDrXDc+hgu7wDH2clNZGhiVlYMmasxJKMMpone966higI6ZR5t/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oT0W65Pq; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F387C4AF55;
	Mon, 17 Nov 2025 09:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763370941;
	bh=SjAPAT7Ii/PBx38u8BcV3f0g82AGlAuOBhVYh0MSvsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oT0W65PqtN5Enq/OFCS/E1MpKLh83fguhX8tuqUIEi6KSxLg9y06/xgaFUdi7SFnL
	 dk7LOdq0OM4wpPd0SqGmZewTjTJG6kmkklW82FefRIJT36OoVULA0/bUXWyik83kH0
	 r/PJ3P31PUsB1iZ3df31fAV5z5Vx+/Qz6HUOGGrX2UT5uqegNn26iqwbakR8LWbvkN
	 ojy2bsjnx60m19En+fNhvzfkA20P+bTBvuWQyEtIAMl+xXP9TZpsh1+muc7Racj+Wu
	 WzdsOZFCmN1yUEKspjt1em7WWYkBkXnFKs+4SnEtq9cPT1MHmSIX1Srg0X/IRkaIEj
	 TSFMqArSyw+Sg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vKvKl-00000005lB2-0kxF;
	Mon, 17 Nov 2025 09:15:39 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v3 3/5] KVM: arm64: GICv3: nv: Resync LRs/VMCR/HCR early for better MI emulation
Date: Mon, 17 Nov 2025 09:15:25 +0000
Message-ID: <20251117091527.1119213-4-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251117091527.1119213-1-maz@kernel.org>
References: <20251117091527.1119213-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, christoffer.dall@arm.com, tabba@google.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

The current approach to nested GICv3 support is to not do anything
while L2 is running, wait a transition from L2 to L1 to resync
LRs, VMCR and HCR, and only then evaluate the state to decide
whether to generate a maintenance interrupt.

This doesn't provide a good quality of emulation, and it would be
far preferable to find out early that we need to perform a switch.

Move the LRs/VMCR and HCR resync into vgic_v3_sync_nested(), so
that we have most of the state available. As we turning the vgic
off at this stage to avoid a screaming host MI, add a new helper
vgic_v3_flush_nested() that switches the vgic on again. The MI can
then be directly injected as required.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_hyp.h     |  1 +
 arch/arm64/kvm/hyp/vgic-v3-sr.c      |  2 +-
 arch/arm64/kvm/vgic/vgic-v3-nested.c | 69 ++++++++++++++++------------
 arch/arm64/kvm/vgic/vgic.c           |  6 ++-
 arch/arm64/kvm/vgic/vgic.h           |  1 +
 5 files changed, 46 insertions(+), 33 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index dbf16a9f67728..76ce2b94bd97e 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -77,6 +77,7 @@ DECLARE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
 int __vgic_v2_perform_cpuif_access(struct kvm_vcpu *vcpu);
 
 u64 __gic_v3_get_lr(unsigned int lr);
+void __gic_v3_set_lr(u64 val, int lr);
 
 void __vgic_v3_save_state(struct vgic_v3_cpu_if *cpu_if);
 void __vgic_v3_restore_state(struct vgic_v3_cpu_if *cpu_if);
diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
index 71199e1a92940..99342c13e1794 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -60,7 +60,7 @@ u64 __gic_v3_get_lr(unsigned int lr)
 	unreachable();
 }
 
-static void __gic_v3_set_lr(u64 val, int lr)
+void __gic_v3_set_lr(u64 val, int lr)
 {
 	switch (lr & 0xf) {
 	case 0:
diff --git a/arch/arm64/kvm/vgic/vgic-v3-nested.c b/arch/arm64/kvm/vgic/vgic-v3-nested.c
index 17bceef83269e..bf37fd3198ba7 100644
--- a/arch/arm64/kvm/vgic/vgic-v3-nested.c
+++ b/arch/arm64/kvm/vgic/vgic-v3-nested.c
@@ -70,13 +70,14 @@ static int lr_map_idx_to_shadow_idx(struct shadow_if *shadow_if, int idx)
  * - on L2 put: perform the inverse transformation, so that the result of L2
  *   running becomes visible to L1 in the VNCR-accessible registers.
  *
- * - there is nothing to do on L2 entry, as everything will have happened
- *   on load. However, this is the point where we detect that an interrupt
- *   targeting L1 and prepare the grand switcheroo.
+ * - there is nothing to do on L2 entry apart from enabling the vgic, as
+ *   everything will have happened on load. However, this is the point where
+ *   we detect that an interrupt targeting L1 and prepare the grand
+ *   switcheroo.
  *
- * - on L2 exit: emulate the HW bit, and deactivate corresponding the L1
- *   interrupt. The L0 active state will be cleared by the HW if the L1
- *   interrupt was itself backed by a HW interrupt.
+ * - on L2 exit: resync the LRs and VMCR, emulate the HW bit, and deactivate
+ *   corresponding the L1 interrupt. The L0 active state will be cleared by
+ *   the HW if the L1 interrupt was itself backed by a HW interrupt.
  *
  * Maintenance Interrupt (MI) management:
  *
@@ -265,15 +266,30 @@ static void vgic_v3_create_shadow_lr(struct kvm_vcpu *vcpu,
 	s_cpu_if->used_lrs = hweight16(shadow_if->lr_map);
 }
 
+void vgic_v3_flush_nested(struct kvm_vcpu *vcpu)
+{
+	u64 val = __vcpu_sys_reg(vcpu, ICH_HCR_EL2);
+
+	write_sysreg_s(val | vgic_ich_hcr_trap_bits(), SYS_ICH_HCR_EL2);
+}
+
 void vgic_v3_sync_nested(struct kvm_vcpu *vcpu)
 {
 	struct shadow_if *shadow_if = get_shadow_if();
 	int i;
 
 	for_each_set_bit(i, &shadow_if->lr_map, kvm_vgic_global_state.nr_lr) {
-		u64 lr = __vcpu_sys_reg(vcpu, ICH_LRN(i));
+		u64 val, host_lr, lr;
 		struct vgic_irq *irq;
 
+		host_lr = __gic_v3_get_lr(lr_map_idx_to_shadow_idx(shadow_if, i));
+
+		/* Propagate the new LR state */
+		lr = __vcpu_sys_reg(vcpu, ICH_LRN(i));
+		val = lr & ~ICH_LR_STATE;
+		val |= host_lr & ICH_LR_STATE;
+		__vcpu_assign_sys_reg(vcpu, ICH_LRN(i), val);
+
 		if (!(lr & ICH_LR_HW) || !(lr & ICH_LR_STATE))
 			continue;
 
@@ -286,12 +302,21 @@ void vgic_v3_sync_nested(struct kvm_vcpu *vcpu)
 		if (WARN_ON(!irq)) /* Shouldn't happen as we check on load */
 			continue;
 
-		lr = __gic_v3_get_lr(lr_map_idx_to_shadow_idx(shadow_if, i));
-		if (!(lr & ICH_LR_STATE))
+		if (!(host_lr & ICH_LR_STATE))
 			irq->active = false;
 
 		vgic_put_irq(vcpu->kvm, irq);
 	}
+
+	/* We need these to be synchronised to generate the MI */
+	__vcpu_assign_sys_reg(vcpu, ICH_VMCR_EL2, read_sysreg_s(SYS_ICH_VMCR_EL2));
+	__vcpu_rmw_sys_reg(vcpu, ICH_HCR_EL2, &=, ~ICH_HCR_EL2_EOIcount);
+	__vcpu_rmw_sys_reg(vcpu, ICH_HCR_EL2, |=, read_sysreg_s(SYS_ICH_HCR_EL2) & ICH_HCR_EL2_EOIcount);
+
+	write_sysreg_s(0, SYS_ICH_HCR_EL2);
+	isb();
+
+	vgic_v3_nested_update_mi(vcpu);
 }
 
 static void vgic_v3_create_shadow_state(struct kvm_vcpu *vcpu,
@@ -325,7 +350,8 @@ void vgic_v3_load_nested(struct kvm_vcpu *vcpu)
 	__vgic_v3_restore_vmcr_aprs(cpu_if);
 	__vgic_v3_activate_traps(cpu_if);
 
-	__vgic_v3_restore_state(cpu_if);
+	for (int i = 0; i < cpu_if->used_lrs; i++)
+		__gic_v3_set_lr(cpu_if->vgic_lr[i], i);
 
 	/*
 	 * Propagate the number of used LRs for the benefit of the HYP
@@ -338,36 +364,19 @@ void vgic_v3_put_nested(struct kvm_vcpu *vcpu)
 {
 	struct shadow_if *shadow_if = get_shadow_if();
 	struct vgic_v3_cpu_if *s_cpu_if = &shadow_if->cpuif;
-	u64 val;
 	int i;
 
 	__vgic_v3_save_aprs(s_cpu_if);
-	__vgic_v3_deactivate_traps(s_cpu_if);
-	__vgic_v3_save_state(s_cpu_if);
-
-	/*
-	 * Translate the shadow state HW fields back to the virtual ones
-	 * before copying the shadow struct back to the nested one.
-	 */
-	val = __vcpu_sys_reg(vcpu, ICH_HCR_EL2);
-	val &= ~ICH_HCR_EL2_EOIcount_MASK;
-	val |= (s_cpu_if->vgic_hcr & ICH_HCR_EL2_EOIcount_MASK);
-	__vcpu_assign_sys_reg(vcpu, ICH_HCR_EL2, val);
-	__vcpu_assign_sys_reg(vcpu, ICH_VMCR_EL2, s_cpu_if->vgic_vmcr);
 
 	for (i = 0; i < 4; i++) {
 		__vcpu_assign_sys_reg(vcpu, ICH_AP0RN(i), s_cpu_if->vgic_ap0r[i]);
 		__vcpu_assign_sys_reg(vcpu, ICH_AP1RN(i), s_cpu_if->vgic_ap1r[i]);
 	}
 
-	for_each_set_bit(i, &shadow_if->lr_map, kvm_vgic_global_state.nr_lr) {
-		val = __vcpu_sys_reg(vcpu, ICH_LRN(i));
-
-		val &= ~ICH_LR_STATE;
-		val |= s_cpu_if->vgic_lr[lr_map_idx_to_shadow_idx(shadow_if, i)] & ICH_LR_STATE;
+	for (i = 0; i < s_cpu_if->used_lrs; i++)
+		__gic_v3_set_lr(0, i);
 
-		__vcpu_assign_sys_reg(vcpu, ICH_LRN(i), val);
-	}
+	__vgic_v3_deactivate_traps(s_cpu_if);
 
 	vcpu->arch.vgic_cpu.vgic_v3.used_lrs = 0;
 }
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index a2f408754774e..4e4db52008c10 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -1056,8 +1056,9 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
 	 *   abort the entry procedure and inject the exception at the
 	 *   beginning of the run loop.
 	 *
-	 * - Otherwise, do exactly *NOTHING*. The guest state is
-	 *   already loaded, and we can carry on with running it.
+	 * - Otherwise, do exactly *NOTHING* apart from enabling the virtual
+	 *   CPU interface. The guest state is already loaded, and we can
+	 *   carry on with running it.
 	 *
 	 * If we have NV, but are not in a nested state, compute the
 	 * maintenance interrupt state, as it may fire.
@@ -1066,6 +1067,7 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
 		if (kvm_vgic_vcpu_pending_irq(vcpu))
 			kvm_make_request(KVM_REQ_GUEST_HYP_IRQ_PENDING, vcpu);
 
+		vgic_v3_flush_nested(vcpu);
 		return;
 	}
 
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index ec3a61e8e6b30..5f0fc96b4dc29 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -446,6 +446,7 @@ static inline bool kvm_has_gicv3(struct kvm *kvm)
 	return kvm_has_feat(kvm, ID_AA64PFR0_EL1, GIC, IMP);
 }
 
+void vgic_v3_flush_nested(struct kvm_vcpu *vcpu);
 void vgic_v3_sync_nested(struct kvm_vcpu *vcpu);
 void vgic_v3_load_nested(struct kvm_vcpu *vcpu);
 void vgic_v3_put_nested(struct kvm_vcpu *vcpu);
-- 
2.47.3


