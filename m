Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A930218D7D5
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 19:51:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727524AbgCTSvZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 14:51:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:45456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727516AbgCTSvW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 14:51:22 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9245F20777;
        Fri, 20 Mar 2020 18:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584730281;
        bh=LNXzotwMtrv5V875ftqEcn2GX8BhiErSgEEJgyCSPMw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SL4ekUhY55kYGiA9/aN585t3lrNfvUXOFD4fU3U9PY4chGEFn2aYI2ZA65ugMAisf
         bke+ETVCpyIbDOAAcIBhd31yFiozjEl9jqa2aPdzRxcNm+3WJO0KfBVdULJtksVZ7/
         Wih4lpOwWExVSipnnVRMjDy/8tddG6dpIEq5gsJA=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jFMK9-00EKAx-2H; Fri, 20 Mar 2020 18:24:49 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Eric Auger <eric.auger@redhat.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v6 19/23] KVM: arm64: GICv4.1: Allow SGIs to switch between HW and SW interrupts
Date:   Fri, 20 Mar 2020 18:24:02 +0000
Message-Id: <20200320182406.23465-20-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200320182406.23465-1-maz@kernel.org>
References: <20200320182406.23465-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, lorenzo.pieralisi@arm.com, jason@lakedaemon.net, tglx@linutronix.de, yuzenghui@huawei.com, eric.auger@redhat.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In order to let a guest buy in the new, active-less SGIs, we
need to be able to switch between the two modes.

Handle this by stopping all guest activity, transfer the state
from one mode to the other, and resume the guest. Nothing calls
this code so far, but a later patch will plug it into the MMIO
emulation.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
Link: https://lore.kernel.org/r/20200304203330.4967-20-maz@kernel.org
---
 include/kvm/arm_vgic.h      |  3 ++
 virt/kvm/arm/vgic/vgic-v4.c | 98 +++++++++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic.h    |  1 +
 3 files changed, 102 insertions(+)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 63457908c9c4..69f4164d6477 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -231,6 +231,9 @@ struct vgic_dist {
 	/* distributor enabled */
 	bool			enabled;
 
+	/* Wants SGIs without active state */
+	bool			nassgireq;
+
 	struct vgic_irq		*spis;
 
 	struct vgic_io_device	dist_iodev;
diff --git a/virt/kvm/arm/vgic/vgic-v4.c b/virt/kvm/arm/vgic/vgic-v4.c
index c2fcde104ea2..27ac833e5ec7 100644
--- a/virt/kvm/arm/vgic/vgic-v4.c
+++ b/virt/kvm/arm/vgic/vgic-v4.c
@@ -97,6 +97,104 @@ static irqreturn_t vgic_v4_doorbell_handler(int irq, void *info)
 	return IRQ_HANDLED;
 }
 
+static void vgic_v4_sync_sgi_config(struct its_vpe *vpe, struct vgic_irq *irq)
+{
+	vpe->sgi_config[irq->intid].enabled	= irq->enabled;
+	vpe->sgi_config[irq->intid].group 	= irq->group;
+	vpe->sgi_config[irq->intid].priority	= irq->priority;
+}
+
+static void vgic_v4_enable_vsgis(struct kvm_vcpu *vcpu)
+{
+	struct its_vpe *vpe = &vcpu->arch.vgic_cpu.vgic_v3.its_vpe;
+	int i;
+
+	/*
+	 * With GICv4.1, every virtual SGI can be directly injected. So
+	 * let's pretend that they are HW interrupts, tied to a host
+	 * IRQ. The SGI code will do its magic.
+	 */
+	for (i = 0; i < VGIC_NR_SGIS; i++) {
+		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, i);
+		struct irq_desc *desc;
+		unsigned long flags;
+		int ret;
+
+		raw_spin_lock_irqsave(&irq->irq_lock, flags);
+
+		if (irq->hw)
+			goto unlock;
+
+		irq->hw = true;
+		irq->host_irq = irq_find_mapping(vpe->sgi_domain, i);
+
+		/* Transfer the full irq state to the vPE */
+		vgic_v4_sync_sgi_config(vpe, irq);
+		desc = irq_to_desc(irq->host_irq);
+		ret = irq_domain_activate_irq(irq_desc_get_irq_data(desc),
+					      false);
+		if (!WARN_ON(ret)) {
+			/* Transfer pending state */
+			ret = irq_set_irqchip_state(irq->host_irq,
+						    IRQCHIP_STATE_PENDING,
+						    irq->pending_latch);
+			WARN_ON(ret);
+			irq->pending_latch = false;
+		}
+	unlock:
+		raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
+		vgic_put_irq(vcpu->kvm, irq);
+	}
+}
+
+static void vgic_v4_disable_vsgis(struct kvm_vcpu *vcpu)
+{
+	int i;
+
+	for (i = 0; i < VGIC_NR_SGIS; i++) {
+		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, i);
+		struct irq_desc *desc;
+		unsigned long flags;
+		int ret;
+
+		raw_spin_lock_irqsave(&irq->irq_lock, flags);
+
+		if (!irq->hw)
+			goto unlock;
+
+		irq->hw = false;
+		ret = irq_get_irqchip_state(irq->host_irq,
+					    IRQCHIP_STATE_PENDING,
+					    &irq->pending_latch);
+		WARN_ON(ret);
+
+		desc = irq_to_desc(irq->host_irq);
+		irq_domain_deactivate_irq(irq_desc_get_irq_data(desc));
+	unlock:
+		raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
+		vgic_put_irq(vcpu->kvm, irq);
+	}
+}
+
+/* Must be called with the kvm lock held */
+void vgic_v4_configure_vsgis(struct kvm *kvm)
+{
+	struct vgic_dist *dist = &kvm->arch.vgic;
+	struct kvm_vcpu *vcpu;
+	int i;
+
+	kvm_arm_halt_guest(kvm);
+
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		if (dist->nassgireq)
+			vgic_v4_enable_vsgis(vcpu);
+		else
+			vgic_v4_disable_vsgis(vcpu);
+	}
+
+	kvm_arm_resume_guest(kvm);
+}
+
 /**
  * vgic_v4_init - Initialize the GICv4 data structures
  * @kvm:	Pointer to the VM being initialized
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index c7fefd6b1c80..769e4802645e 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -316,5 +316,6 @@ void vgic_its_invalidate_cache(struct kvm *kvm);
 bool vgic_supports_direct_msis(struct kvm *kvm);
 int vgic_v4_init(struct kvm *kvm);
 void vgic_v4_teardown(struct kvm *kvm);
+void vgic_v4_configure_vsgis(struct kvm *kvm);
 
 #endif
-- 
2.20.1

