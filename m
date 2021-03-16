Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1092433DB56
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 18:47:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239334AbhCPRrR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 13:47:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:40044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239236AbhCPRqo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Mar 2021 13:46:44 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8205B6512D;
        Tue, 16 Mar 2021 17:46:43 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1lMDmD-0021ao-MY; Tue, 16 Mar 2021 17:46:41 +0000
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
Subject: [PATCH 05/11] KVM: arm64: vgic: move irq->get_input_level into an ops structure
Date:   Tue, 16 Mar 2021 17:46:10 +0000
Message-Id: <20210316174617.173033-6-maz@kernel.org>
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

We already have the option to attach a callback to an interrupt
to retrieve its pending state. As we are planning to expand this
facility, move this callback into its own data structure.

This will limit the size of individual interrupts as the ops
structures can be shared across multiple interrupts.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arch_timer.c |  8 ++++++--
 arch/arm64/kvm/vgic/vgic.c  | 14 +++++++-------
 include/kvm/arm_vgic.h      | 28 +++++++++++++++++-----------
 3 files changed, 30 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 74e0699661e9..e2288b6bf435 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -1116,6 +1116,10 @@ bool kvm_arch_timer_get_input_level(int vintid)
 	return kvm_timer_should_fire(timer);
 }
 
+static struct irq_ops arch_timer_irq_ops = {
+	.get_input_level = kvm_arch_timer_get_input_level,
+};
+
 int kvm_timer_enable(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_cpu *timer = vcpu_timer(vcpu);
@@ -1143,7 +1147,7 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
 	ret = kvm_vgic_map_phys_irq(vcpu,
 				    map.direct_vtimer->host_timer_irq,
 				    map.direct_vtimer->irq.irq,
-				    kvm_arch_timer_get_input_level);
+				    &arch_timer_irq_ops);
 	if (ret)
 		return ret;
 
@@ -1151,7 +1155,7 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
 		ret = kvm_vgic_map_phys_irq(vcpu,
 					    map.direct_ptimer->host_timer_irq,
 					    map.direct_ptimer->irq.irq,
-					    kvm_arch_timer_get_input_level);
+					    &arch_timer_irq_ops);
 	}
 
 	if (ret)
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 1c597c9885fa..1d22365c68e2 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -182,8 +182,8 @@ bool vgic_get_phys_line_level(struct vgic_irq *irq)
 
 	BUG_ON(!irq->hw);
 
-	if (irq->get_input_level)
-		return irq->get_input_level(irq->intid);
+	if (irq->ops && irq->ops->get_input_level)
+		return irq->ops->get_input_level(irq->intid);
 
 	WARN_ON(irq_get_irqchip_state(irq->host_irq,
 				      IRQCHIP_STATE_PENDING,
@@ -479,7 +479,7 @@ int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
 /* @irq->irq_lock must be held */
 static int kvm_vgic_map_irq(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
 			    unsigned int host_irq,
-			    bool (*get_input_level)(int vindid))
+			    struct irq_ops *ops)
 {
 	struct irq_desc *desc;
 	struct irq_data *data;
@@ -499,7 +499,7 @@ static int kvm_vgic_map_irq(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
 	irq->hw = true;
 	irq->host_irq = host_irq;
 	irq->hwintid = data->hwirq;
-	irq->get_input_level = get_input_level;
+	irq->ops = ops;
 	return 0;
 }
 
@@ -508,11 +508,11 @@ static inline void kvm_vgic_unmap_irq(struct vgic_irq *irq)
 {
 	irq->hw = false;
 	irq->hwintid = 0;
-	irq->get_input_level = NULL;
+	irq->ops = NULL;
 }
 
 int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, unsigned int host_irq,
-			  u32 vintid, bool (*get_input_level)(int vindid))
+			  u32 vintid, struct irq_ops *ops)
 {
 	struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, vintid);
 	unsigned long flags;
@@ -521,7 +521,7 @@ int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, unsigned int host_irq,
 	BUG_ON(!irq);
 
 	raw_spin_lock_irqsave(&irq->irq_lock, flags);
-	ret = kvm_vgic_map_irq(vcpu, irq, host_irq, get_input_level);
+	ret = kvm_vgic_map_irq(vcpu, irq, host_irq, ops);
 	raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
 	vgic_put_irq(vcpu->kvm, irq);
 
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 7afe789194d8..a7130f1b5ab9 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -92,6 +92,21 @@ enum vgic_irq_config {
 	VGIC_CONFIG_LEVEL
 };
 
+/*
+ * Per-irq ops overriding some common behavious.
+ *
+ * Always called in non-preemptible section and the functions can use
+ * kvm_arm_get_running_vcpu() to get the vcpu pointer for private IRQs.
+ */
+struct irq_ops {
+	/*
+	 * Callback function pointer to in-kernel devices that can tell us the
+	 * state of the input level of mapped level-triggered IRQ faster than
+	 * peaking into the physical GIC.
+	 */
+	bool (*get_input_level)(int vintid);
+};
+
 struct vgic_irq {
 	raw_spinlock_t irq_lock;	/* Protects the content of the struct */
 	struct list_head lpi_list;	/* Used to link all LPIs together */
@@ -129,16 +144,7 @@ struct vgic_irq {
 	u8 group;			/* 0 == group 0, 1 == group 1 */
 	enum vgic_irq_config config;	/* Level or edge */
 
-	/*
-	 * Callback function pointer to in-kernel devices that can tell us the
-	 * state of the input level of mapped level-triggered IRQ faster than
-	 * peaking into the physical GIC.
-	 *
-	 * Always called in non-preemptible section and the functions can use
-	 * kvm_arm_get_running_vcpu() to get the vcpu pointer for private
-	 * IRQs.
-	 */
-	bool (*get_input_level)(int vintid);
+	struct irq_ops *ops;
 
 	void *owner;			/* Opaque pointer to reserve an interrupt
 					   for in-kernel devices. */
@@ -354,7 +360,7 @@ void kvm_vgic_init_cpu_hardware(void);
 int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
 			bool level, void *owner);
 int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, unsigned int host_irq,
-			  u32 vintid, bool (*get_input_level)(int vindid));
+			  u32 vintid, struct irq_ops *ops);
 int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, unsigned int vintid);
 bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int vintid);
 
-- 
2.29.2

