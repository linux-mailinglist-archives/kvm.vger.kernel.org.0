Return-Path: <kvm+bounces-35242-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 11907A0AB25
	for <lists+kvm@lfdr.de>; Sun, 12 Jan 2025 18:10:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 47A2518860D0
	for <lists+kvm@lfdr.de>; Sun, 12 Jan 2025 17:10:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1851A1C461F;
	Sun, 12 Jan 2025 17:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="caC+fuFe"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A38F1C2432;
	Sun, 12 Jan 2025 17:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736701733; cv=none; b=gKnpkl9eqMCVJ3GlCv/pScRyZ9URiZgw/nS+wY8eaKm07Rlr2Jafa3vFzU5/QyFMbUKSIoctVdcv+2NunAIdUB/qvW5QqOCocRbuzhbH3ATXhqYVU78VSt0iUxMRFC8IT9Mq5jeKyAbfVV2T7qUz0SiMgAEU5ghj0Vu8deFyLj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736701733; c=relaxed/simple;
	bh=PUNUuaq6uhvCuVfyV4hDWBnlQ70Z7CWDzh0OvyWCN/A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WXUweTZfbeHQM78sD+Kmmixu1j7zMF/a3bU78X7FFtZAaq6zrm2z/biTywQPMsYAl4H6074JbQkby30o4DALVua8BkQETb/+iKH+5jRROVdo1EF3J6pIe8IIHKd4vfvuORvfJCBtsXAg3oBfn276VW6xLIjdWaR52ADH5M6XH6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=caC+fuFe; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1826C4CEDF;
	Sun, 12 Jan 2025 17:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736701733;
	bh=PUNUuaq6uhvCuVfyV4hDWBnlQ70Z7CWDzh0OvyWCN/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=caC+fuFe/sVh8VWe/MTLYlf1lD/QjN/toxgpsS9E6al1U6MSKMgX38sifBZZtifP/
	 7sJstpJatRyuXaEaG40R/m3DgD1foxh2TtuAoptgLpNshkn81Y9dRobFF+CBhjPOaE
	 lJuDzrgPzOnU+r+B1pQ3/Zz2b52EwKQyr8hJqt9O//Q2BMN41POgFTJkQ6XVXgVMTQ
	 L4ahLIr0OGASB02frUT+b4iYu5CXM26WAhzatSDnS3xfLIbPIzSyAF9d/LaEiw7smQ
	 MF7ZBC2/oKxri9XwnACvspQR7IHhbxLT4qQdp5gy23JnAMxxXx6ddFCY7lqWp2FuzX
	 qd2LJ+6TiF2cQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tX1SF-00BNxR-7F;
	Sun, 12 Jan 2025 17:08:51 +0000
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
Subject: [PATCH v2 11/17] KVM: arm64: nv: Add Maintenance Interrupt emulation
Date: Sun, 12 Jan 2025 17:08:39 +0000
Message-Id: <20250112170845.1181891-12-maz@kernel.org>
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
index 5e353b2c225b4..756cc4e74e10f 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -824,6 +824,12 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
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


