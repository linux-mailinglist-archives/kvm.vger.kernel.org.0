Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8E3E33DB55
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 18:47:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239205AbhCPRrQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 13:47:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:40068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239230AbhCPRqo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Mar 2021 13:46:44 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0253A6512F;
        Tue, 16 Mar 2021 17:46:44 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1lMDmE-0021ao-7m; Tue, 16 Mar 2021 17:46:42 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Hector Martin <marcan@marcan.st>,
        Mark Rutland <mark.rutland@arm.com>, kernel-team@android.com
Subject: [PATCH 06/11] KVM: arm64: vgic: Implement SW-driven deactivation
Date:   Tue, 16 Mar 2021 17:46:11 +0000
Message-Id: <20210316174617.173033-7-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210316174617.173033-1-maz@kernel.org>
References: <20210316174617.173033-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, eric.auger@redhat.com, marcan@marcan.st, mark.rutland@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In order to deal with these systems that do not offer HW-based
deactivation of interrupts, let implement a SW-based approach:

- When the irq is queued into a LR, treat it as a pure virtual
  interrupt and set the EOI flag in the LR.

- When the interrupt state is read back from the LR, force a
  deactivation when the state is invalid (neither active nor
  pending)

Interrupts requiring such treatment get the VGIC_SW_RESAMPLE flag.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-v2.c | 19 +++++++++++++++----
 arch/arm64/kvm/vgic/vgic-v3.c | 19 +++++++++++++++----
 include/kvm/arm_vgic.h        | 10 ++++++++++
 3 files changed, 40 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v2.c b/arch/arm64/kvm/vgic/vgic-v2.c
index 11934c2af2f4..2c580204f1dc 100644
--- a/arch/arm64/kvm/vgic/vgic-v2.c
+++ b/arch/arm64/kvm/vgic/vgic-v2.c
@@ -108,11 +108,22 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
 		 * If this causes us to lower the level, we have to also clear
 		 * the physical active state, since we will otherwise never be
 		 * told when the interrupt becomes asserted again.
+		 *
+		 * Another case is when the interrupt requires a helping hand
+		 * on deactivation (no HW deactivation, for example).
 		 */
-		if (vgic_irq_is_mapped_level(irq) && (val & GICH_LR_PENDING_BIT)) {
-			irq->line_level = vgic_get_phys_line_level(irq);
+		if (vgic_irq_is_mapped_level(irq)) {
+			bool resample = false;
+
+			if (val & GICH_LR_PENDING_BIT) {
+				irq->line_level = vgic_get_phys_line_level(irq);
+				resample = !irq->line_level;
+			} else if (vgic_irq_needs_resampling(irq) &&
+				   !(irq->active || irq->pending_latch)) {
+				resample = true;
+			}
 
-			if (!irq->line_level)
+			if (resample)
 				vgic_irq_set_phys_active(irq, false);
 		}
 
@@ -152,7 +163,7 @@ void vgic_v2_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)
 	if (irq->group)
 		val |= GICH_LR_GROUP1;
 
-	if (irq->hw) {
+	if (irq->hw && !vgic_irq_needs_resampling(irq)) {
 		val |= GICH_LR_HW;
 		val |= irq->hwintid << GICH_LR_PHYSID_CPUID_SHIFT;
 		/*
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 6f530925a231..d7ee88de3a5c 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -99,11 +99,22 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
 		 * If this causes us to lower the level, we have to also clear
 		 * the physical active state, since we will otherwise never be
 		 * told when the interrupt becomes asserted again.
+		 *
+		 * Another case is when the interrupt requires a helping hand
+		 * on deactivation (no HW deactivation, for example).
 		 */
-		if (vgic_irq_is_mapped_level(irq) && (val & ICH_LR_PENDING_BIT)) {
-			irq->line_level = vgic_get_phys_line_level(irq);
+		if (vgic_irq_is_mapped_level(irq)) {
+			bool resample = false;
+
+			if (val & ICH_LR_PENDING_BIT) {
+				irq->line_level = vgic_get_phys_line_level(irq);
+				resample = !irq->line_level;
+			} else if (vgic_irq_needs_resampling(irq) &&
+				   !(irq->active || irq->pending_latch)) {
+				resample = true;
+			}
 
-			if (!irq->line_level)
+			if (resample)
 				vgic_irq_set_phys_active(irq, false);
 		}
 
@@ -134,7 +145,7 @@ void vgic_v3_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)
 		}
 	}
 
-	if (irq->hw) {
+	if (irq->hw && !vgic_irq_needs_resampling(irq)) {
 		val |= ICH_LR_HW;
 		val |= ((u64)irq->hwintid) << ICH_LR_PHYS_ID_SHIFT;
 		/*
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index a7130f1b5ab9..379ee0c97ede 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -99,6 +99,11 @@ enum vgic_irq_config {
  * kvm_arm_get_running_vcpu() to get the vcpu pointer for private IRQs.
  */
 struct irq_ops {
+	/* Per interrupt flags for special-cased interrupts */
+	unsigned long flags;
+
+#define VGIC_IRQ_SW_RESAMPLE	BIT(0)	/* Clear the active state for resampling */
+
 	/*
 	 * Callback function pointer to in-kernel devices that can tell us the
 	 * state of the input level of mapped level-triggered IRQ faster than
@@ -150,6 +155,11 @@ struct vgic_irq {
 					   for in-kernel devices. */
 };
 
+static inline bool vgic_irq_needs_resampling(struct vgic_irq *irq)
+{
+	return irq->ops && (irq->ops->flags & VGIC_IRQ_SW_RESAMPLE);
+}
+
 struct vgic_register_region;
 struct vgic_its;
 
-- 
2.29.2

