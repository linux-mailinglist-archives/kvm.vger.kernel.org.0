Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4ABB179A2D
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2020 21:37:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388582AbgCDUgv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Mar 2020 15:36:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:37134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388574AbgCDUgv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Mar 2020 15:36:51 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF96521741;
        Wed,  4 Mar 2020 20:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583354209;
        bh=KCCtgtp/AJrZjHD62EAaVE4OfaQJQc6xhaQuwsGRmO0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gc2AyfihKl7BPE51eCyzeA6LXaLgLDztIV4v65GDvEKGbLMqy0BgsMXLxdjx1VTgs
         4fFKWk3p2DSzs1RmICOY4vMvSmcgelxrrsktKp5XluU5uB1jGV26gSWiNnxl9ZFd6r
         W2NJy4Om1tonPDrKynNhQN/o+jNUBvcpwGzRbRNI=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1j9ajA-00A59R-Dr; Wed, 04 Mar 2020 20:34:48 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Robert Richter <rrichter@marvell.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Eric Auger <eric.auger@redhat.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v5 13/23] irqchip/gic-v4.1: Move doorbell management to the GICv4 abstraction layer
Date:   Wed,  4 Mar 2020 20:33:20 +0000
Message-Id: <20200304203330.4967-14-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200304203330.4967-1-maz@kernel.org>
References: <20200304203330.4967-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, lorenzo.pieralisi@arm.com, jason@lakedaemon.net, rrichter@marvell.com, tglx@linutronix.de, yuzenghui@huawei.com, eric.auger@redhat.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In order to hide some of the differences between v4.0 and v4.1, move
the doorbell management out of the KVM code, and into the GICv4-specific
layer. This allows the calling code to ask for the doorbell when blocking,
and otherwise to leave the doorbell permanently disabled.

This matches the v4.1 code perfectly, and only results in a minor
refactoring of the v4.0 code.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 drivers/irqchip/irq-gic-v4.c       | 45 +++++++++++++++++++++++++++---
 include/kvm/arm_vgic.h             |  1 +
 include/linux/irqchip/arm-gic-v4.h |  3 +-
 virt/kvm/arm/vgic/vgic-v3.c        |  4 ++-
 virt/kvm/arm/vgic/vgic-v4.c        | 34 ++++++++++------------
 5 files changed, 61 insertions(+), 26 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v4.c b/drivers/irqchip/irq-gic-v4.c
index c01910d53f9e..117ba6db023d 100644
--- a/drivers/irqchip/irq-gic-v4.c
+++ b/drivers/irqchip/irq-gic-v4.c
@@ -87,6 +87,11 @@ static struct irq_domain *gic_domain;
 static const struct irq_domain_ops *vpe_domain_ops;
 static const struct irq_domain_ops *sgi_domain_ops;
 
+static bool has_v4_1(void)
+{
+	return !!sgi_domain_ops;
+}
+
 int its_alloc_vcpu_irqs(struct its_vm *vm)
 {
 	int vpe_base_irq, i;
@@ -139,18 +144,50 @@ static int its_send_vpe_cmd(struct its_vpe *vpe, struct its_cmd_info *info)
 	return irq_set_vcpu_affinity(vpe->irq, info);
 }
 
-int its_schedule_vpe(struct its_vpe *vpe, bool on)
+int its_make_vpe_non_resident(struct its_vpe *vpe, bool db)
 {
-	struct its_cmd_info info;
+	struct irq_desc *desc = irq_to_desc(vpe->irq);
+	struct its_cmd_info info = { };
 	int ret;
 
 	WARN_ON(preemptible());
 
-	info.cmd_type = on ? SCHEDULE_VPE : DESCHEDULE_VPE;
+	info.cmd_type = DESCHEDULE_VPE;
+	if (has_v4_1()) {
+		/* GICv4.1 can directly deal with doorbells */
+		info.req_db = db;
+	} else {
+		/* Undo the nested disable_irq() calls... */
+		while (db && irqd_irq_disabled(&desc->irq_data))
+			enable_irq(vpe->irq);
+	}
+
+	ret = its_send_vpe_cmd(vpe, &info);
+	if (!ret)
+		vpe->resident = false;
+
+	return ret;
+}
+
+int its_make_vpe_resident(struct its_vpe *vpe, bool g0en, bool g1en)
+{
+	struct its_cmd_info info = { };
+	int ret;
+
+	WARN_ON(preemptible());
+
+	info.cmd_type = SCHEDULE_VPE;
+	if (has_v4_1()) {
+		info.g0en = g0en;
+		info.g1en = g1en;
+	} else {
+		/* Disabled the doorbell, as we're about to enter the guest */
+		disable_irq_nosync(vpe->irq);
+	}
 
 	ret = its_send_vpe_cmd(vpe, &info);
 	if (!ret)
-		vpe->resident = on;
+		vpe->resident = true;
 
 	return ret;
 }
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 9d53f545a3d5..63457908c9c4 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -70,6 +70,7 @@ struct vgic_global {
 
 	/* Hardware has GICv4? */
 	bool			has_gicv4;
+	bool			has_gicv4_1;
 
 	/* GIC system register CPU interface */
 	struct static_key_false gicv3_cpuif;
diff --git a/include/linux/irqchip/arm-gic-v4.h b/include/linux/irqchip/arm-gic-v4.h
index b4dbf899460b..8b42d9d9b17e 100644
--- a/include/linux/irqchip/arm-gic-v4.h
+++ b/include/linux/irqchip/arm-gic-v4.h
@@ -125,7 +125,8 @@ struct its_cmd_info {
 
 int its_alloc_vcpu_irqs(struct its_vm *vm);
 void its_free_vcpu_irqs(struct its_vm *vm);
-int its_schedule_vpe(struct its_vpe *vpe, bool on);
+int its_make_vpe_resident(struct its_vpe *vpe, bool g0en, bool g1en);
+int its_make_vpe_non_resident(struct its_vpe *vpe, bool db);
 int its_invall_vpe(struct its_vpe *vpe);
 int its_map_vlpi(int irq, struct its_vlpi_map *map);
 int its_get_vlpi(int irq, struct its_vlpi_map *map);
diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index f45635a6f0ec..1bc09b523486 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -595,7 +595,9 @@ int vgic_v3_probe(const struct gic_kvm_info *info)
 	/* GICv4 support? */
 	if (info->has_v4) {
 		kvm_vgic_global_state.has_gicv4 = gicv4_enable;
-		kvm_info("GICv4 support %sabled\n",
+		kvm_vgic_global_state.has_gicv4_1 = info->has_v4_1 && gicv4_enable;
+		kvm_info("GICv4%s support %sabled\n",
+			 kvm_vgic_global_state.has_gicv4_1 ? ".1" : "",
 			 gicv4_enable ? "en" : "dis");
 	}
 
diff --git a/virt/kvm/arm/vgic/vgic-v4.c b/virt/kvm/arm/vgic/vgic-v4.c
index 46f875589c47..1eb0f8c76219 100644
--- a/virt/kvm/arm/vgic/vgic-v4.c
+++ b/virt/kvm/arm/vgic/vgic-v4.c
@@ -67,10 +67,10 @@
  * it. And if we've migrated our vcpu from one CPU to another, we must
  * tell the ITS (so that the messages reach the right redistributor).
  * This is done in two steps: first issue a irq_set_affinity() on the
- * irq corresponding to the vcpu, then call its_schedule_vpe(). You
- * must be in a non-preemptible context. On exit, another call to
- * its_schedule_vpe() tells the redistributor that we're done with the
- * vcpu.
+ * irq corresponding to the vcpu, then call its_make_vpe_resident().
+ * You must be in a non-preemptible context. On exit, a call to
+ * its_make_vpe_non_resident() tells the redistributor that we're done
+ * with the vcpu.
  *
  * Finally, the doorbell handling: Each vcpu is allocated an interrupt
  * which will fire each time a VLPI is made pending whilst the vcpu is
@@ -86,7 +86,8 @@ static irqreturn_t vgic_v4_doorbell_handler(int irq, void *info)
 	struct kvm_vcpu *vcpu = info;
 
 	/* We got the message, no need to fire again */
-	if (!irqd_irq_disabled(&irq_to_desc(irq)->irq_data))
+	if (!kvm_vgic_global_state.has_gicv4_1 &&
+	    !irqd_irq_disabled(&irq_to_desc(irq)->irq_data))
 		disable_irq_nosync(irq);
 
 	vcpu->arch.vgic_cpu.vgic_v3.its_vpe.pending_last = true;
@@ -199,19 +200,11 @@ void vgic_v4_teardown(struct kvm *kvm)
 int vgic_v4_put(struct kvm_vcpu *vcpu, bool need_db)
 {
 	struct its_vpe *vpe = &vcpu->arch.vgic_cpu.vgic_v3.its_vpe;
-	struct irq_desc *desc = irq_to_desc(vpe->irq);
 
 	if (!vgic_supports_direct_msis(vcpu->kvm) || !vpe->resident)
 		return 0;
 
-	/*
-	 * If blocking, a doorbell is required. Undo the nested
-	 * disable_irq() calls...
-	 */
-	while (need_db && irqd_irq_disabled(&desc->irq_data))
-		enable_irq(vpe->irq);
-
-	return its_schedule_vpe(vpe, false);
+	return its_make_vpe_non_resident(vpe, need_db);
 }
 
 int vgic_v4_load(struct kvm_vcpu *vcpu)
@@ -232,18 +225,19 @@ int vgic_v4_load(struct kvm_vcpu *vcpu)
 	if (err)
 		return err;
 
-	/* Disabled the doorbell, as we're about to enter the guest */
-	disable_irq_nosync(vpe->irq);
-
-	err = its_schedule_vpe(vpe, true);
+	err = its_make_vpe_resident(vpe, false, vcpu->kvm->arch.vgic.enabled);
 	if (err)
 		return err;
 
 	/*
 	 * Now that the VPE is resident, let's get rid of a potential
-	 * doorbell interrupt that would still be pending.
+	 * doorbell interrupt that would still be pending. This is a
+	 * GICv4.0 only "feature"...
 	 */
-	return irq_set_irqchip_state(vpe->irq, IRQCHIP_STATE_PENDING, false);
+	if (!kvm_vgic_global_state.has_gicv4_1)
+		err = irq_set_irqchip_state(vpe->irq, IRQCHIP_STATE_PENDING, false);
+
+	return err;
 }
 
 static struct vgic_its *vgic_get_its(struct kvm *kvm,
-- 
2.20.1

