Return-Path: <kvm+bounces-62450-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D45DCC44416
	for <lists+kvm@lfdr.de>; Sun, 09 Nov 2025 18:20:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C0FE63B6BEA
	for <lists+kvm@lfdr.de>; Sun,  9 Nov 2025 17:18:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C465930E85F;
	Sun,  9 Nov 2025 17:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cyWc157S"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBF5630CD86;
	Sun,  9 Nov 2025 17:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762708596; cv=none; b=oW7jV7CM3ijkyqCdy+Yp7fSz12lTDvooJ2PanhapkqiYwVYjWvBeg3eHWGuL1Oaf6EVARNAX537d/+ts93yb/MZm6/ARIiR89cgDmGHxsQo7CtwPBeV4JX9IBdGHXA6KgFriN1MHxhSeb5/zenSKX+Hc8gOqTmNwgXSXzPOVgck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762708596; c=relaxed/simple;
	bh=1WooFGAOvLd28Zek3XflMLApQolUs3QRCzmrIRk8vwk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IbUGpNvlTYQ0ST+lh3E3clWVI6Luaoq95auPF3iRWG12OgbLwV2dASzAJVmxVOYk14p29mcVIy0h2GjehhfaxByy8b+0uD8+tlr25se3MDLyn0gQ4qELtSztyqhCTZAjTCxtuZslR06JmXNwW6/r0qUaPUZtgvWJng4ohGrKKfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cyWc157S; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E9ECC19421;
	Sun,  9 Nov 2025 17:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762708596;
	bh=1WooFGAOvLd28Zek3XflMLApQolUs3QRCzmrIRk8vwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cyWc157SQpraYOmziB/7hK0ZEnBaM0tvaUUygu5MxtcTLbv3tkfb9X7nqP4Wdwe6K
	 kRj7hnQtglmT9a+W0wUXv45VOAEMwgjmFgMUFIw0dDnme3beoT/RiwzTxZdfclbKtV
	 uYhyPXpCsxMJtBKUJodfvwI3Kd4XSVr+p/xbuuU/AKPQA+C3OKuJ6AhKnlJ82FWqXf
	 qgKo+viU5Aa2AK5kZDHTUAWRls1/P0/eQruYL0WQh5S9/1M4EcPAHkz3M5iPVChDqW
	 m8bFHglbAkWPbKSeeKKi2UUGFwCG7p23IurtILaYuJqls29B11KkPB4Jj2iDrFSyL4
	 SCeHYfpT/9mVQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vI91m-00000003exw-2fZO;
	Sun, 09 Nov 2025 17:16:34 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>
Subject: [PATCH v2 27/45] KVM: arm64: GICv3: Handle deactivation via ICV_DIR_EL1 traps
Date: Sun,  9 Nov 2025 17:16:01 +0000
Message-ID: <20251109171619.1507205-28-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251109171619.1507205-1-maz@kernel.org>
References: <20251109171619.1507205-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, christoffer.dall@arm.com, Volodymyr_Babchuk@epam.com, yaoyuan@linux.alibaba.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Deactivation via ICV_DIR_EL1 is both relatively straightforward
(we have the interrupt that needs deactivation) and really awkward.

The main issue is that the interrupt may either be in an LR on
another CPU, or ourside of any LR.

In the former case, we process the deactivation is if ot was
a write to GICD_CACTIVERn, which is already implemented as a big
hammer IPI'ing all vcpus. In the latter case, we just perform
a normal deactivation, similar to what we do for EOImode==0.

Another annoying aspect is that we need to tell the CPU owning
the interrupt that its ap_list needs laudering. We use a brand new
vcpu request to that effect.

Note that this doesn't address deactivation via the GICV MMIO view,
which will be taken care of in a later change.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/arm.c              |  4 ++
 arch/arm64/kvm/hyp/vgic-v3-sr.c   |  3 ++
 arch/arm64/kvm/sys_regs.c         | 19 ++++++-
 arch/arm64/kvm/vgic/vgic-v3.c     | 85 +++++++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic.c        | 11 ++++
 arch/arm64/kvm/vgic/vgic.h        |  1 +
 include/kvm/arm_vgic.h            |  1 +
 8 files changed, 123 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 64302c438355c..7501a2ee4dd44 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -54,6 +54,7 @@
 #define KVM_REQ_NESTED_S2_UNMAP		KVM_ARCH_REQ(8)
 #define KVM_REQ_GUEST_HYP_IRQ_PENDING	KVM_ARCH_REQ(9)
 #define KVM_REQ_MAP_L1_VNCR_EL2		KVM_ARCH_REQ(10)
+#define KVM_REQ_VGIC_PROCESS_UPDATE	KVM_ARCH_REQ(11)
 
 #define KVM_DIRTY_LOG_MANUAL_CAPS   (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE | \
 				     KVM_DIRTY_LOG_INITIALLY_SET)
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 733195ef183e1..fe13f9777f9ca 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1041,6 +1041,10 @@ static int check_vcpu_requests(struct kvm_vcpu *vcpu)
 		 */
 		kvm_check_request(KVM_REQ_IRQ_PENDING, vcpu);
 
+		/* Process interrupts deactivated through a trap */
+		if (kvm_check_request(KVM_REQ_VGIC_PROCESS_UPDATE, vcpu))
+			kvm_vgic_process_async_update(vcpu);
+
 		if (kvm_check_request(KVM_REQ_RECORD_STEAL, vcpu))
 			kvm_update_stolen_time(vcpu);
 
diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
index 1e5c1cf4b9144..8d3f4c069ea63 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -1247,6 +1247,9 @@ int __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
 	case SYS_ICC_DIR_EL1:
 		if (unlikely(is_read))
 			return 0;
+		/* Full exit if required to handle overflow deactivation... */
+		if (vcpu->arch.vgic_cpu.vgic_v3.vgic_hcr & ICH_HCR_EL2_TDIR)
+			return 0;
 		fn = __vgic_v3_write_dir;
 		break;
 	case SYS_ICC_RPR_EL1:
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index e67eb39ddc118..1b69d6e2d720d 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -666,6 +666,21 @@ static bool access_gic_sre(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+static bool access_gic_dir(struct kvm_vcpu *vcpu,
+			   struct sys_reg_params *p,
+			   const struct sys_reg_desc *r)
+{
+	if (!kvm_has_gicv3(vcpu->kvm))
+		return undef_access(vcpu, p, r);
+
+	if (!p->is_write)
+		return undef_access(vcpu, p, r);
+
+	vgic_v3_deactivate(vcpu, p->regval);
+
+	return true;
+}
+
 static bool trap_raz_wi(struct kvm_vcpu *vcpu,
 			struct sys_reg_params *p,
 			const struct sys_reg_desc *r)
@@ -3370,7 +3385,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_ICC_AP1R1_EL1), undef_access },
 	{ SYS_DESC(SYS_ICC_AP1R2_EL1), undef_access },
 	{ SYS_DESC(SYS_ICC_AP1R3_EL1), undef_access },
-	{ SYS_DESC(SYS_ICC_DIR_EL1), undef_access },
+	{ SYS_DESC(SYS_ICC_DIR_EL1), access_gic_dir },
 	{ SYS_DESC(SYS_ICC_RPR_EL1), undef_access },
 	{ SYS_DESC(SYS_ICC_SGI1R_EL1), access_gic_sgi },
 	{ SYS_DESC(SYS_ICC_ASGI1R_EL1), access_gic_sgi },
@@ -4495,7 +4510,7 @@ static const struct sys_reg_desc cp15_regs[] = {
 	{ CP15_SYS_DESC(SYS_ICC_AP1R1_EL1), undef_access },
 	{ CP15_SYS_DESC(SYS_ICC_AP1R2_EL1), undef_access },
 	{ CP15_SYS_DESC(SYS_ICC_AP1R3_EL1), undef_access },
-	{ CP15_SYS_DESC(SYS_ICC_DIR_EL1), undef_access },
+	{ CP15_SYS_DESC(SYS_ICC_DIR_EL1), access_gic_dir },
 	{ CP15_SYS_DESC(SYS_ICC_RPR_EL1), undef_access },
 	{ CP15_SYS_DESC(SYS_ICC_IAR1_EL1), undef_access },
 	{ CP15_SYS_DESC(SYS_ICC_EOIR1_EL1), undef_access },
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index e17eefc6a2bb6..f2e9b96c6b65c 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -12,6 +12,7 @@
 #include <asm/kvm_mmu.h>
 #include <asm/kvm_asm.h>
 
+#include "vgic-mmio.h"
 #include "vgic.h"
 
 static bool group0_trap;
@@ -168,6 +169,90 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
 	cpuif->used_lrs = 0;
 }
 
+void vgic_v3_deactivate(struct kvm_vcpu *vcpu, u64 val)
+{
+	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
+	struct vgic_v3_cpu_if *cpuif = &vgic_cpu->vgic_v3;
+	struct kvm_vcpu *target_vcpu = NULL;
+	struct vgic_irq *irq;
+	unsigned long flags;
+	bool mmio = false;
+	u64 lr = 0;
+
+	/*
+	 * We only deal with DIR when EOIMode==1, and only for SGI,
+	 * PPI or SPI.
+	 */
+	if (!(cpuif->vgic_vmcr & ICH_VMCR_EOIM_MASK) ||
+	    val >= vcpu->kvm->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS)
+		return;
+
+	/* Make sure we're in the same context as LR handling */
+	local_irq_save(flags);
+
+	irq = vgic_get_vcpu_irq(vcpu, val);
+	if (WARN_ON_ONCE(!irq))
+		goto out;
+
+	/*
+	 * EOIMode=1: we must rely on traps to handle deactivate of
+	 * overflowing interrupts, as there is no ordering guarantee and
+	 * EOIcount isn't being incremented. Priority drop will have taken
+	 * place, as ICV_EOIxR_EL1 only affects the APRs and not the LRs.
+	 *
+	 * Three possibities:
+	 *
+	 * - The irq is not queued on any CPU, and there is nothing to
+	 *   do,
+	 *
+	 * - Or the irq is in an LR, meaning that its state is not
+	 *   directly observable. Treat it bluntly by making it as if
+	 *   this was a write to GICD_ICACTIVER, which will force an
+	 *   exit on all vcpus. If it hurts, don't do that.
+	 *
+	 * - Or the irq is active, but not in an LR, and we can
+	 *   directly deactivate it by building a pseudo-LR, fold it,
+	 *   and queue a request to prune the resulting ap_list,
+	 */
+	scoped_guard(raw_spinlock, &irq->irq_lock) {
+		target_vcpu = irq->vcpu;
+
+		/* Not on any ap_list? */
+		if (!target_vcpu)
+			goto put;
+
+		/*
+		 * Urgh. We're deactivating something that we cannot
+		 * observe yet... Big hammer time.
+		 */
+		if (irq->on_lr) {
+			mmio = true;
+			goto put;
+		}
+
+		/* (with a Dalek voice) DEACTIVATE!!!! */
+		lr = vgic_v3_compute_lr(vcpu, irq) & ~ICH_LR_ACTIVE_BIT;
+	}
+
+	if (lr & ICH_LR_HW)
+		vgic_v3_deactivate_phys(FIELD_GET(ICH_LR_PHYS_ID_MASK, lr));
+
+	vgic_v3_fold_lr(vcpu, lr);
+
+put:
+	vgic_put_irq(vcpu->kvm, irq);
+
+out:
+	local_irq_restore(flags);
+
+	if (mmio)
+		vgic_mmio_write_cactive(vcpu, (val / 32) * 4, 4, BIT(val % 32));
+
+	/* Force the ap_list to be pruned */
+	if (target_vcpu)
+		kvm_make_request(KVM_REQ_VGIC_PROCESS_UPDATE, target_vcpu);
+}
+
 /* Requires the irq to be locked already */
 static u64 vgic_v3_compute_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq)
 {
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 5c9204d18b27d..8c502135199f8 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -990,6 +990,17 @@ void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
 	vgic_prune_ap_list(vcpu);
 }
 
+/* Sync interrupts that were deactivated through a DIR trap */
+void kvm_vgic_process_async_update(struct kvm_vcpu *vcpu)
+{
+	unsigned long flags;
+
+	/* Make sure we're in the same context as LR handling */
+	local_irq_save(flags);
+	vgic_prune_ap_list(vcpu);
+	local_irq_restore(flags);
+}
+
 static inline void vgic_restore_state(struct kvm_vcpu *vcpu)
 {
 	if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 037efb6200823..01ff6d4aa9dad 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -318,6 +318,7 @@ static inline void vgic_get_irq_ref(struct vgic_irq *irq)
 void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu);
 void vgic_v3_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr);
 void vgic_v3_clear_lr(struct kvm_vcpu *vcpu, int lr);
+void vgic_v3_deactivate(struct kvm_vcpu *vcpu, u64 val);
 void vgic_v3_configure_hcr(struct kvm_vcpu *vcpu, struct ap_list_summary *als);
 void vgic_v3_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 void vgic_v3_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index ec349c5a4a8b6..b798546755a34 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -421,6 +421,7 @@ bool kvm_vcpu_has_pending_irqs(struct kvm_vcpu *vcpu);
 void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu);
 void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu);
 void kvm_vgic_reset_mapped_irq(struct kvm_vcpu *vcpu, u32 vintid);
+void kvm_vgic_process_async_update(struct kvm_vcpu *vcpu);
 
 void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg, bool allow_group1);
 
-- 
2.47.3


