Return-Path: <kvm+bounces-35239-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BB79FA0AB22
	for <lists+kvm@lfdr.de>; Sun, 12 Jan 2025 18:09:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9EC0A3A70AC
	for <lists+kvm@lfdr.de>; Sun, 12 Jan 2025 17:09:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A915D1C3BF6;
	Sun, 12 Jan 2025 17:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZnRNphQG"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AED621C1F04;
	Sun, 12 Jan 2025 17:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736701732; cv=none; b=bkoQhrWhRLaYSk1PHLO52DBlZ8EA7rY8m+pXGmDbNUyY0SADAOh8y278Ip837PIePyrEIIEk9uegaoZcx1Y/+sL/wR9VwxqUmzWFj4H7vfbQlMEccz6PJa6R7h/Fk980kKiReSZ2z6FMnDD6+WrwOw8h8stMnrpH2JGX2kz0Coc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736701732; c=relaxed/simple;
	bh=nbb1CtXBV1u3wQmVFKa/eFMc0yKUhMlmDTtGqqUT5sQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HBRqPe3Nl02QNWhLwa7jmZoA9CLBQJI96ZGGNrVzyRCmvdONKPp7Tpkth5SWuc2+nvf8+THEWye4UMM9K5cNd8Yu3zv45BBRmquGr0vTAQ1m7oqnpUzIbOHV+r9FyvrH/xg5zxvU5N8ixs96tRcpFVXV4NRNtsmWRm1l1xv7vMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZnRNphQG; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 662DCC4CEE7;
	Sun, 12 Jan 2025 17:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736701732;
	bh=nbb1CtXBV1u3wQmVFKa/eFMc0yKUhMlmDTtGqqUT5sQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZnRNphQGAYxU0npHZnkK+OxfZfrJ3/9YX40TsAnZAAoDwTVaY01CRGMQM/bH82CzA
	 iwR/d6XsPcGP/r+Gl6Xxy4Ya0FN2hBYvPSYQ4DuXqsWIReqjIoUyvZdgjhwx4Zouug
	 lhnNswu1eNrDk9RKQSmhmjf4Ts7AGVdlpnV2m76fd0K4DhDfX9zi8YOKmKgPT827Jq
	 PSzpPUAPFXQgXa/vzb7Tfm6BKFbN8GZkPHCyxoTlJDpfwaiFksLNranY6u+z0GWaCK
	 xNBvN7ByNGobGgleaN7qgYWoJSYzvEyFg3dIQhKD6udIQ+7kz8JLF8qoYuNM1peQtW
	 wT1IzCLe/caIg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tX1SE-00BNxR-Mb;
	Sun, 12 Jan 2025 17:08:50 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v2 09/17] KVM: arm64: nv: Nested GICv3 emulation
Date: Sun, 12 Jan 2025 17:08:37 +0000
Message-Id: <20250112170845.1181891-10-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250112170845.1181891-1-maz@kernel.org>
References: <20250112170845.1181891-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, andre.przywara@arm.com, eric.auger@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

When entering a nested VM, we set up the hypervisor control interface
based on what the guest hypervisor has set. Especially, we investigate
each list register written by the guest hypervisor whether HW bit is
set.  If so, we translate hw irq number from the guest's point of view
to the real hardware irq number if there is a mapping.

Co-developed-by: Jintack Lim <jintack@cs.columbia.edu>
Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
[Christoffer: Redesigned execution flow around vcpu load/put]
Co-developed-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
[maz: Rewritten to support GICv3 instead of GICv2, NV2 support]
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_hyp.h     |   2 +
 arch/arm64/kvm/hyp/vgic-v3-sr.c      |   2 +-
 arch/arm64/kvm/vgic/vgic-v3-nested.c | 218 +++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic-v3.c        |  11 ++
 arch/arm64/kvm/vgic/vgic.c           |   6 +
 arch/arm64/kvm/vgic/vgic.h           |   4 +
 include/kvm/arm_vgic.h               |   2 +
 7 files changed, 244 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index c838309e4ec47..e6be1f5d0967f 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -76,6 +76,8 @@ DECLARE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
 
 int __vgic_v2_perform_cpuif_access(struct kvm_vcpu *vcpu);
 
+u64 __gic_v3_get_lr(unsigned int lr);
+
 void __vgic_v3_save_state(struct vgic_v3_cpu_if *cpu_if);
 void __vgic_v3_restore_state(struct vgic_v3_cpu_if *cpu_if);
 void __vgic_v3_activate_traps(struct vgic_v3_cpu_if *cpu_if);
diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
index b47dede973b3c..ed363aa3027e5 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -18,7 +18,7 @@
 #define vtr_to_nr_pre_bits(v)		((((u32)(v) >> 26) & 7) + 1)
 #define vtr_to_nr_apr_regs(v)		(1 << (vtr_to_nr_pre_bits(v) - 5))
 
-static u64 __gic_v3_get_lr(unsigned int lr)
+u64 __gic_v3_get_lr(unsigned int lr)
 {
 	switch (lr & 0xf) {
 	case 0:
diff --git a/arch/arm64/kvm/vgic/vgic-v3-nested.c b/arch/arm64/kvm/vgic/vgic-v3-nested.c
index 48bfd2f556a36..3d80bfb37de00 100644
--- a/arch/arm64/kvm/vgic/vgic-v3-nested.c
+++ b/arch/arm64/kvm/vgic/vgic-v3-nested.c
@@ -16,6 +16,8 @@
 #include "vgic.h"
 
 #define ICH_LRN(n)	(ICH_LR0_EL2 + (n))
+#define ICH_AP0RN(n)	(ICH_AP0R0_EL2 + (n))
+#define ICH_AP1RN(n)	(ICH_AP1R0_EL2 + (n))
 
 struct mi_state {
 	u16	eisr;
@@ -23,9 +25,54 @@ struct mi_state {
 	bool	pend;
 };
 
+/*
+ * The shadow registers loaded to the hardware when running a L2 guest
+ * with the virtual IMO/FMO bits set.
+ */
+struct shadow_if {
+	struct vgic_v3_cpu_if	cpuif;
+	unsigned long		lr_map;
+};
+
+static DEFINE_PER_CPU(struct shadow_if, shadow_if);
+
 /*
  * Nesting GICv3 support
  *
+ * On a non-nesting VM (only running at EL0/EL1), the host hypervisor
+ * completely controls the interrupts injected via the list registers.
+ * Consequently, most of the state that is modified by the guest (by ACK-ing
+ * and EOI-ing interrupts) is synced by KVM on each entry/exit, so that we
+ * keep a semi-consistent view of the interrupts.
+ *
+ * This still applies for a NV guest, but only while "InHost" (either
+ * running at EL2, or at EL0 with HCR_EL2.{E2H.TGE}=={1,1}.
+ *
+ * When running a L2 guest ("not InHost"), things are radically different,
+ * as the L1 guest is in charge of provisioning the interrupts via its own
+ * view of the ICH_LR*_EL2 registers, which conveniently live in the VNCR
+ * page.  This means that the flow described above does work (there is no
+ * state to rebuild in the L0 hypervisor), and that most things happed on L2
+ * load/put:
+ *
+ * - on L2 load: move the in-memory L1 vGIC configuration into a shadow,
+ *   per-CPU data structure that is used to populate the actual LRs. This is
+ *   an extra copy that we could avoid, but life is short. In the process,
+ *   we remap any interrupt that has the HW bit set to the mapped interrupt
+ *   on the host, should the host consider it a HW one. This allows the HW
+ *   deactivation to take its course, such as for the timer.
+ *
+ * - on L2 put: perform the inverse transformation, so that the result of L2
+ *   running becomes visible to L1 in the VNCR-accessible registers.
+ *
+ * - there is nothing to do on L2 entry, as everything will have happenned
+ *   on load. However, this is the point where we detect that an interrupt
+ *   targeting L1 and prepare the grand switcheroo.
+ *
+ * - on L2 exit: emulate the HW bit, and deactivate corresponding the L1
+ *   interrupt. The L0 active state will be cleared by the HW if the L1
+ *   interrupt was itself backed by a HW interrupt.
+ *
  * System register emulation:
  *
  * We get two classes of registers:
@@ -42,6 +89,26 @@ struct mi_state {
  * trap) thanks to NV being set by L1.
  */
 
+bool vgic_state_is_nested(struct kvm_vcpu *vcpu)
+{
+	u64 xmo;
+
+	if (vcpu_has_nv(vcpu) && !is_hyp_ctxt(vcpu)) {
+		xmo = __vcpu_sys_reg(vcpu, HCR_EL2) & (HCR_IMO | HCR_FMO);
+		WARN_ONCE(xmo && xmo != (HCR_IMO | HCR_FMO),
+			  "Separate virtual IRQ/FIQ settings not supported\n");
+
+		return !!xmo;
+	}
+
+	return false;
+}
+
+static struct shadow_if *get_shadow_if(void)
+{
+	return this_cpu_ptr(&shadow_if);
+}
+
 static bool lr_triggers_eoi(u64 lr)
 {
 	return !(lr & (ICH_LR_STATE | ICH_LR_HW)) && (lr & ICH_LR_EOI);
@@ -123,3 +190,154 @@ u64 vgic_v3_get_misr(struct kvm_vcpu *vcpu)
 
 	return reg;
 }
+
+/*
+ * For LRs which have HW bit set such as timer interrupts, we modify them to
+ * have the host hardware interrupt number instead of the virtual one programmed
+ * by the guest hypervisor.
+ */
+static void vgic_v3_create_shadow_lr(struct kvm_vcpu *vcpu,
+				     struct vgic_v3_cpu_if *s_cpu_if)
+{
+	unsigned long lr_map = 0;
+	int index = 0;
+
+	for (int i = 0; i < kvm_vgic_global_state.nr_lr; i++) {
+		u64 lr = __vcpu_sys_reg(vcpu, ICH_LRN(i));
+		struct vgic_irq *irq;
+
+		if (!(lr & ICH_LR_STATE))
+			lr = 0;
+
+		if (!(lr & ICH_LR_HW))
+			goto next;
+
+		/* We have the HW bit set, check for validity of pINTID */
+		irq = vgic_get_vcpu_irq(vcpu, FIELD_GET(ICH_LR_PHYS_ID_MASK, lr));
+		if (!irq || !irq->hw || irq->intid > VGIC_MAX_SPI ) {
+			/* There was no real mapping, so nuke the HW bit */
+			lr &= ~ICH_LR_HW;
+			if (irq)
+				vgic_put_irq(vcpu->kvm, irq);
+			goto next;
+		}
+
+		/* It is illegal to have the EOI bit set with HW */
+		lr &= ~ICH_LR_EOI;
+
+		/* Translate the virtual mapping to the real one */
+		lr &= ~ICH_LR_PHYS_ID_MASK;
+		lr |= FIELD_PREP(ICH_LR_PHYS_ID_MASK, (u64)irq->hwintid);
+
+		vgic_put_irq(vcpu->kvm, irq);
+
+next:
+		s_cpu_if->vgic_lr[index] = lr;
+		if (lr) {
+			lr_map |= BIT(i);
+			index++;
+		}
+	}
+
+	container_of(s_cpu_if, struct shadow_if, cpuif)->lr_map = lr_map;
+	s_cpu_if->used_lrs = index;
+}
+
+void vgic_v3_sync_nested(struct kvm_vcpu *vcpu)
+{
+	struct shadow_if *shadow_if = get_shadow_if();
+	int i, index = 0;
+
+	for_each_set_bit(i, &shadow_if->lr_map, kvm_vgic_global_state.nr_lr) {
+		u64 lr = __vcpu_sys_reg(vcpu, ICH_LRN(i));
+		struct vgic_irq *irq;
+
+		if (!(lr & ICH_LR_HW) || !(lr & ICH_LR_STATE))
+			goto next;
+
+		/*
+		 * If we had a HW lr programmed by the guest hypervisor, we
+		 * need to emulate the HW effect between the guest hypervisor
+		 * and the nested guest.
+		 */
+		irq = vgic_get_vcpu_irq(vcpu, FIELD_GET(ICH_LR_PHYS_ID_MASK, lr));
+		if (WARN_ON(!irq)) /* Shouldn't happen as we check on load */
+			goto next;
+
+		lr = __gic_v3_get_lr(index);
+		if (!(lr & ICH_LR_STATE))
+			irq->active = false;
+
+		vgic_put_irq(vcpu->kvm, irq);
+	next:
+		index++;
+	}
+}
+
+static void vgic_v3_create_shadow_state(struct kvm_vcpu *vcpu,
+					struct vgic_v3_cpu_if *s_cpu_if)
+{
+	struct vgic_v3_cpu_if *host_if = &vcpu->arch.vgic_cpu.vgic_v3;
+	int i;
+
+	s_cpu_if->vgic_hcr = __vcpu_sys_reg(vcpu, ICH_HCR_EL2);
+	s_cpu_if->vgic_vmcr = __vcpu_sys_reg(vcpu, ICH_VMCR_EL2);
+	s_cpu_if->vgic_sre = host_if->vgic_sre;
+
+	for (i = 0; i < 4; i++) {
+		s_cpu_if->vgic_ap0r[i] = __vcpu_sys_reg(vcpu, ICH_AP0RN(i));
+		s_cpu_if->vgic_ap1r[i] = __vcpu_sys_reg(vcpu, ICH_AP1RN(i));
+	}
+
+	vgic_v3_create_shadow_lr(vcpu, s_cpu_if);
+}
+
+void vgic_v3_load_nested(struct kvm_vcpu *vcpu)
+{
+	struct shadow_if *shadow_if = get_shadow_if();
+	struct vgic_v3_cpu_if *cpu_if = &shadow_if->cpuif;
+
+	BUG_ON(!vgic_state_is_nested(vcpu));
+
+	vgic_v3_create_shadow_state(vcpu, cpu_if);
+
+	__vgic_v3_restore_vmcr_aprs(cpu_if);
+	__vgic_v3_activate_traps(cpu_if);
+
+	__vgic_v3_restore_state(cpu_if);
+}
+
+void vgic_v3_put_nested(struct kvm_vcpu *vcpu)
+{
+	struct shadow_if *shadow_if = get_shadow_if();
+	struct vgic_v3_cpu_if *s_cpu_if = &shadow_if->cpuif;
+	int i;
+
+	__vgic_v3_save_vmcr_aprs(s_cpu_if);
+	__vgic_v3_deactivate_traps(s_cpu_if);
+	__vgic_v3_save_state(s_cpu_if);
+
+	/*
+	 * Translate the shadow state HW fields back to the virtual ones
+	 * before copying the shadow struct back to the nested one.
+	 */
+	__vcpu_sys_reg(vcpu, ICH_HCR_EL2) = s_cpu_if->vgic_hcr;
+	__vcpu_sys_reg(vcpu, ICH_VMCR_EL2) = s_cpu_if->vgic_vmcr;
+
+	for (i = 0; i < 4; i++) {
+		__vcpu_sys_reg(vcpu, ICH_AP0RN(i)) = s_cpu_if->vgic_ap0r[i];
+		__vcpu_sys_reg(vcpu, ICH_AP1RN(i)) = s_cpu_if->vgic_ap1r[i];
+	}
+
+	for_each_set_bit(i, &shadow_if->lr_map, kvm_vgic_global_state.nr_lr) {
+		u64 val = __vcpu_sys_reg(vcpu, ICH_LRN(i));
+
+		val &= ~ICH_LR_STATE;
+		val |= s_cpu_if->vgic_lr[i] & ICH_LR_STATE;
+
+		__vcpu_sys_reg(vcpu, ICH_LRN(i)) = val;
+		s_cpu_if->vgic_lr[i] = 0;
+	}
+
+	shadow_if->lr_map = 0;
+}
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 0bdecbbe74898..67e89bf708e6d 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -733,6 +733,12 @@ void vgic_v3_load(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
 
+	/* If the vgic is nested, perform the full state loading */
+	if (vgic_state_is_nested(vcpu)) {
+		vgic_v3_load_nested(vcpu);
+		return;
+	}
+
 	kvm_call_hyp(__vgic_v3_restore_vmcr_aprs, cpu_if);
 
 	if (has_vhe())
@@ -745,6 +751,11 @@ void vgic_v3_put(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
 
+	if (vgic_state_is_nested(vcpu)) {
+		vgic_v3_put_nested(vcpu);
+		return;
+	}
+
 	kvm_call_hyp(__vgic_v3_save_vmcr_aprs, cpu_if);
 	WARN_ON(vgic_v4_put(vcpu));
 
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index cc8c6b9b5dd8b..324c547e1b4d8 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -872,6 +872,12 @@ void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
 {
 	int used_lrs;
 
+	/* If nesting, emulate the HW effect from L0 to L1 */
+	if (vgic_state_is_nested(vcpu)) {
+		vgic_v3_sync_nested(vcpu);
+		return;
+	}
+
 	/* An empty ap_list_head implies used_lrs == 0 */
 	if (list_empty(&vcpu->arch.vgic_cpu.ap_list_head))
 		return;
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 122d95b4e2845..cf0c084e5d347 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -353,4 +353,8 @@ static inline bool kvm_has_gicv3(struct kvm *kvm)
 	return kvm_has_feat(kvm, ID_AA64PFR0_EL1, GIC, IMP);
 }
 
+void vgic_v3_sync_nested(struct kvm_vcpu *vcpu);
+void vgic_v3_load_nested(struct kvm_vcpu *vcpu);
+void vgic_v3_put_nested(struct kvm_vcpu *vcpu);
+
 #endif
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 5017fcc71e604..1b373cb870fe4 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -437,6 +437,8 @@ int vgic_v4_load(struct kvm_vcpu *vcpu);
 void vgic_v4_commit(struct kvm_vcpu *vcpu);
 int vgic_v4_put(struct kvm_vcpu *vcpu);
 
+bool vgic_state_is_nested(struct kvm_vcpu *vcpu);
+
 /* CPU HP callbacks */
 void kvm_vgic_cpu_up(void);
 void kvm_vgic_cpu_down(void);
-- 
2.39.2


