Return-Path: <kvm+bounces-37504-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 460D0A2AD05
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 16:51:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0F3BD16AC5C
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 15:50:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 381B81F4176;
	Thu,  6 Feb 2025 15:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WE+8V5BK"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C11A2500C3;
	Thu,  6 Feb 2025 15:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738856984; cv=none; b=evVlBBZbY7S5C7FIWT2MRCb8p7Atbd+cPiq9jp9VJ0rt5+bud7SZthC3MKKFavUsPRxIAmcOjU8HMFLAtW/4tLmlycEmP/z9ToFHcaDsm8LJpkLDD1u9qfQFklgv1IvyV7JrqcaewpLAlx58VZRnPc9eRFtE22bgwj8j9OmkrA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738856984; c=relaxed/simple;
	bh=jlPtKAjwtS7PiVLm8FENiw38a0puKK/u36zQqUtKj28=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Uq2Q7w8CLeaRX+3G1F+lz3TRz5rc7jVvUrFUluKFbtno0ujIUiodJ/HFmHnW4RfVZZYH+XjE5w3PyA3+z/pu6BQLG23JW6NggJWUuveaZz2wueowaTxoiPeL/41FQk+3StBrXQNN2CSc2+hY01B3O82vQbvSHdV6UmY/gm+radI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WE+8V5BK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86140C4CEE9;
	Thu,  6 Feb 2025 15:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738856983;
	bh=jlPtKAjwtS7PiVLm8FENiw38a0puKK/u36zQqUtKj28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WE+8V5BKN34U+JyOwByddmkXc7WDl+x99WlG48InzDwcjC4lLHv8vG6sGZ555cJnF
	 SXG4FKl3t/RWJ5V6UoPVo/A8WdpdZ9XA6xsGA4sVm5rMrp6fCUL4A4HWMsE7nXTDKL
	 l2OYuuw5hiJIl21zX7Le3J+5y80yakQH+FrLcGvtvse413V4JbAVHmbidVbXKH3I/j
	 UF/ophwBnbuftjiO8F4wTPE3lnILaWPXhBRVlTndQ3luYnR+urCVa7+7GJUxmWq/rg
	 +cojEDibOyar6/ykPbIDLa9klU5uvenOAcy7z52/HlUL0mq3N19JmAoyUZVlEmCmlF
	 nXAMB5Up8hT/w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tg48L-001BOX-F8;
	Thu, 06 Feb 2025 15:49:41 +0000
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
Subject: [PATCH v3 10/16] KVM: arm64: nv: Add Maintenance Interrupt emulation
Date: Thu,  6 Feb 2025 15:49:19 +0000
Message-Id: <20250206154925.1109065-11-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250206154925.1109065-1-maz@kernel.org>
References: <20250206154925.1109065-1-maz@kernel.org>
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

Emulating the vGIC means emulating the dreaded Maintenance Interrupt.

This is a two-pronged problem:

- while running L2, getting an MI translates into an MI injected
  in the L1 based on the state of the HW.

- while running L1, we must accurately reflect the state of the
  MI line, based on the in-memory state.

The MI INTID is added to the distributor, as expected on any
virtualisation-capable implementation, and further patches
will allow its configuration.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arm.c                 |  6 ++++
 arch/arm64/kvm/vgic/vgic-init.c      | 29 ++++++++++++++++++
 arch/arm64/kvm/vgic/vgic-v3-nested.c | 45 ++++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic.c           |  9 ++++++
 arch/arm64/kvm/vgic/vgic.h           |  2 ++
 include/kvm/arm_vgic.h               |  4 +++
 6 files changed, 95 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index a1f6737fbf60a..6063131f84426 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -815,6 +815,12 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
 	if (ret)
 		return ret;
 
+	if (vcpu_has_nv(vcpu)) {
+		ret = kvm_vgic_vcpu_nv_init(vcpu);
+		if (ret)
+			return ret;
+	}
+
 	/*
 	 * This needs to happen after any restriction has been applied
 	 * to the feature set.
diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index bc7e22ab5d812..c7a82bd0c276d 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -180,6 +180,27 @@ static int kvm_vgic_dist_init(struct kvm *kvm, unsigned int nr_spis)
 	return 0;
 }
 
+/* Default GICv3 Maintenance Interrupt INTID, as per SBSA */
+#define DEFAULT_MI_INTID	25
+
+int kvm_vgic_vcpu_nv_init(struct kvm_vcpu *vcpu)
+{
+	int ret;
+
+	guard(mutex)(&vcpu->kvm->arch.config_lock);
+
+	/*
+	 * Matching the tradition established with the timers, provide
+	 * a default PPI for the maintenance interrupt. It makes
+	 * things easier to reason about.
+	 */
+	if (vcpu->kvm->arch.vgic.mi_intid == 0)
+		vcpu->kvm->arch.vgic.mi_intid = DEFAULT_MI_INTID;
+	ret = kvm_vgic_set_owner(vcpu, vcpu->kvm->arch.vgic.mi_intid, vcpu);
+
+	return ret;
+}
+
 static int vgic_allocate_private_irqs_locked(struct kvm_vcpu *vcpu)
 {
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
@@ -588,12 +609,20 @@ void kvm_vgic_cpu_down(void)
 
 static irqreturn_t vgic_maintenance_handler(int irq, void *data)
 {
+	struct kvm_vcpu *vcpu = *(struct kvm_vcpu **)data;
+
 	/*
 	 * We cannot rely on the vgic maintenance interrupt to be
 	 * delivered synchronously. This means we can only use it to
 	 * exit the VM, and we perform the handling of EOIed
 	 * interrupts on the exit path (see vgic_fold_lr_state).
+	 *
+	 * Of course, NV throws a wrench in this plan, and needs
+	 * something special.
 	 */
+	if (vcpu && vgic_state_is_nested(vcpu))
+		vgic_v3_handle_nested_maint_irq(vcpu);
+
 	return IRQ_HANDLED;
 }
 
diff --git a/arch/arm64/kvm/vgic/vgic-v3-nested.c b/arch/arm64/kvm/vgic/vgic-v3-nested.c
index 3d80bfb37de00..e72be14d99d55 100644
--- a/arch/arm64/kvm/vgic/vgic-v3-nested.c
+++ b/arch/arm64/kvm/vgic/vgic-v3-nested.c
@@ -73,6 +73,24 @@ static DEFINE_PER_CPU(struct shadow_if, shadow_if);
  *   interrupt. The L0 active state will be cleared by the HW if the L1
  *   interrupt was itself backed by a HW interrupt.
  *
+ * Maintenance Interrupt (MI) management:
+ *
+ * Since the L2 guest runs the vgic in its full glory, MIs get delivered and
+ * used as a handover point between L2 and L1.
+ *
+ * - on delivery of a MI to L0 while L2 is running: make the L1 MI pending,
+ *   and let it rip. This will initiate a vcpu_put() on L2, and allow L1 to
+ *   run and process the MI.
+ *
+ * - L1 MI is a fully virtual interrupt, not linked to the host's MI. Its
+ *   state must be computed at each entry/exit of the guest, much like we do
+ *   it for the PMU interrupt.
+ *
+ * - because most of the ICH_*_EL2 registers live in the VNCR page, the
+ *   quality of emulation is poor: L1 can setup the vgic so that an MI would
+ *   immediately fire, and not observe anything until the next exit. Trying
+ *   to read ICH_MISR_EL2 would do the trick, for example.
+ *
  * System register emulation:
  *
  * We get two classes of registers:
@@ -341,3 +359,30 @@ void vgic_v3_put_nested(struct kvm_vcpu *vcpu)
 
 	shadow_if->lr_map = 0;
 }
+
+/*
+ * If we exit a L2 VM with a pending maintenance interrupt from the GIC,
+ * then we need to forward this to L1 so that it can re-sync the appropriate
+ * LRs and sample level triggered interrupts again.
+ */
+void vgic_v3_handle_nested_maint_irq(struct kvm_vcpu *vcpu)
+{
+	bool state = read_sysreg_s(SYS_ICH_MISR_EL2);
+
+	/* This will force a switch back to L1 if the level is high */
+	kvm_vgic_inject_irq(vcpu->kvm, vcpu,
+			    vcpu->kvm->arch.vgic.mi_intid, state, vcpu);
+
+	sysreg_clear_set_s(SYS_ICH_HCR_EL2, ICH_HCR_EL2_En, 0);
+}
+
+void vgic_v3_nested_update_mi(struct kvm_vcpu *vcpu)
+{
+	bool level;
+
+	level  = __vcpu_sys_reg(vcpu, ICH_HCR_EL2) & ICH_HCR_EL2_En;
+	if (level)
+		level &= vgic_v3_get_misr(vcpu);
+	kvm_vgic_inject_irq(vcpu->kvm, vcpu,
+			    vcpu->kvm->arch.vgic.mi_intid, level, vcpu);
+}
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 9734a71b85611..8f8096d489252 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -878,6 +878,9 @@ void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
 		return;
 	}
 
+	if (vcpu_has_nv(vcpu))
+		vgic_v3_nested_update_mi(vcpu);
+
 	/* An empty ap_list_head implies used_lrs == 0 */
 	if (list_empty(&vcpu->arch.vgic_cpu.ap_list_head))
 		return;
@@ -921,6 +924,9 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
 	 *
 	 * - Otherwise, do exactly *NOTHING*. The guest state is
 	 *   already loaded, and we can carry on with running it.
+	 *
+	 * If we have NV, but are not in a nested state, compute the
+	 * maintenance interrupt state, as it may fire.
 	 */
 	if (vgic_state_is_nested(vcpu)) {
 		if (kvm_vgic_vcpu_pending_irq(vcpu))
@@ -929,6 +935,9 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
 		return;
 	}
 
+	if (vcpu_has_nv(vcpu))
+		vgic_v3_nested_update_mi(vcpu);
+
 	/*
 	 * If there are no virtual interrupts active or pending for this
 	 * VCPU, then there is no work to do and we can bail out without
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index cf0c084e5d347..0c5a63712702b 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -356,5 +356,7 @@ static inline bool kvm_has_gicv3(struct kvm *kvm)
 void vgic_v3_sync_nested(struct kvm_vcpu *vcpu);
 void vgic_v3_load_nested(struct kvm_vcpu *vcpu);
 void vgic_v3_put_nested(struct kvm_vcpu *vcpu);
+void vgic_v3_handle_nested_maint_irq(struct kvm_vcpu *vcpu);
+void vgic_v3_nested_update_mi(struct kvm_vcpu *vcpu);
 
 #endif
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 1b373cb870fe4..714cef854c1c3 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -249,6 +249,9 @@ struct vgic_dist {
 
 	int			nr_spis;
 
+	/* The GIC maintenance IRQ for nested hypervisors. */
+	u32			mi_intid;
+
 	/* base addresses in guest physical address space: */
 	gpa_t			vgic_dist_base;		/* distributor */
 	union {
@@ -369,6 +372,7 @@ extern struct static_key_false vgic_v3_cpuif_trap;
 int kvm_set_legacy_vgic_v2_addr(struct kvm *kvm, struct kvm_arm_device_addr *dev_addr);
 void kvm_vgic_early_init(struct kvm *kvm);
 int kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu);
+int kvm_vgic_vcpu_nv_init(struct kvm_vcpu *vcpu);
 int kvm_vgic_create(struct kvm *kvm, u32 type);
 void kvm_vgic_destroy(struct kvm *kvm);
 void kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu);
-- 
2.39.2


