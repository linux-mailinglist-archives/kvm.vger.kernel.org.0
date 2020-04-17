Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF131AD89F
	for <lists+kvm@lfdr.de>; Fri, 17 Apr 2020 10:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729787AbgDQIdl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Apr 2020 04:33:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:59372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729770AbgDQIdk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Apr 2020 04:33:40 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A3F86221EA;
        Fri, 17 Apr 2020 08:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587112418;
        bh=leXis4W8ZvtMZe0/e58isk+dxdlpSgjQXJPhnDTY22c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UsJKXtPz+VXS+36enLV5cjqdbfmqABEJYKCaB9Fylsx07vvT+W5TYrnmYKznDkpdZ
         CMAsr36ICEESUN4LVBjelbY00pnF/PXa13xcByGFAHzPzgVhzlCwtrY2OKLBY+edqs
         2g2kv+0PTrompMhPAdnwAZO5B97ltG+a9Tcwy404=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jPMRN-00473f-0H; Fri, 17 Apr 2020 09:33:37 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Zenghui Yu <yuzenghui@huawei.com>,
        Eric Auger <eric.auger@redhat.com>,
        Andre Przywara <Andre.Przywara@arm.com>,
        Julien Grall <julien@xen.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v2 2/6] KVM: arm: vgic: Synchronize the whole guest on GIC{D,R}_I{S,C}ACTIVER read
Date:   Fri, 17 Apr 2020 09:33:15 +0100
Message-Id: <20200417083319.3066217-3-maz@kernel.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200417083319.3066217-1-maz@kernel.org>
References: <20200417083319.3066217-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, yuzenghui@huawei.com, eric.auger@redhat.com, Andre.Przywara@arm.com, julien@xen.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When a guest tries to read the active state of its interrupts,
we currently just return whatever state we have in memory. This
means that if such an interrupt lives in a List Register on another
CPU, we fail to obsertve the latest active state for this interrupt.

In order to remedy this, stop all the other vcpus so that they exit
and we can observe the most recent value for the state. This is
similar to what we are doing for the write side of the same
registers, and results in new MMIO handlers for userspace (which
do not need to stop the guest, as it is supposed to be stopped
already).

Reported-by: Julien Grall <julien@xen.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 virt/kvm/arm/vgic/vgic-mmio-v2.c |   4 +-
 virt/kvm/arm/vgic/vgic-mmio-v3.c |  12 ++--
 virt/kvm/arm/vgic/vgic-mmio.c    | 100 ++++++++++++++++++++-----------
 virt/kvm/arm/vgic/vgic-mmio.h    |   3 +
 4 files changed, 75 insertions(+), 44 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
index 5945f062d749..d63881f60e1a 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
@@ -422,11 +422,11 @@ static const struct vgic_register_region vgic_v2_dist_registers[] = {
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ACTIVE_SET,
 		vgic_mmio_read_active, vgic_mmio_write_sactive,
-		NULL, vgic_mmio_uaccess_write_sactive, 1,
+		vgic_uaccess_read_active, vgic_mmio_uaccess_write_sactive, 1,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ACTIVE_CLEAR,
 		vgic_mmio_read_active, vgic_mmio_write_cactive,
-		NULL, vgic_mmio_uaccess_write_cactive, 1,
+		vgic_uaccess_read_active, vgic_mmio_uaccess_write_cactive, 1,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_PRI,
 		vgic_mmio_read_priority, vgic_mmio_write_priority, NULL, NULL,
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index e72dcc454247..f2b37a081f26 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -553,11 +553,11 @@ static const struct vgic_register_region vgic_v3_dist_registers[] = {
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ISACTIVER,
 		vgic_mmio_read_active, vgic_mmio_write_sactive,
-		NULL, vgic_mmio_uaccess_write_sactive, 1,
+		vgic_uaccess_read_active, vgic_mmio_uaccess_write_sactive, 1,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ICACTIVER,
 		vgic_mmio_read_active, vgic_mmio_write_cactive,
-		NULL, vgic_mmio_uaccess_write_cactive,
+		vgic_uaccess_read_active, vgic_mmio_uaccess_write_cactive,
 		1, VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_IPRIORITYR,
 		vgic_mmio_read_priority, vgic_mmio_write_priority, NULL, NULL,
@@ -625,12 +625,12 @@ static const struct vgic_register_region vgic_v3_rd_registers[] = {
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH_UACCESS(SZ_64K + GICR_ISACTIVER0,
 		vgic_mmio_read_active, vgic_mmio_write_sactive,
-		NULL, vgic_mmio_uaccess_write_sactive,
-		4, VGIC_ACCESS_32bit),
+		vgic_uaccess_read_active, vgic_mmio_uaccess_write_sactive, 4,
+		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH_UACCESS(SZ_64K + GICR_ICACTIVER0,
 		vgic_mmio_read_active, vgic_mmio_write_cactive,
-		NULL, vgic_mmio_uaccess_write_cactive,
-		4, VGIC_ACCESS_32bit),
+		vgic_uaccess_read_active, vgic_mmio_uaccess_write_cactive, 4,
+		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(SZ_64K + GICR_IPRIORITYR0,
 		vgic_mmio_read_priority, vgic_mmio_write_priority, 32,
 		VGIC_ACCESS_32bit | VGIC_ACCESS_8bit),
diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
index d085e047953f..b38e94e8f74a 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -348,8 +348,39 @@ void vgic_mmio_write_cpending(struct kvm_vcpu *vcpu,
 	}
 }
 
-unsigned long vgic_mmio_read_active(struct kvm_vcpu *vcpu,
-				    gpa_t addr, unsigned int len)
+
+/*
+ * If we are fiddling with an IRQ's active state, we have to make sure the IRQ
+ * is not queued on some running VCPU's LRs, because then the change to the
+ * active state can be overwritten when the VCPU's state is synced coming back
+ * from the guest.
+ *
+ * For shared interrupts as well as GICv3 private interrupts, we have to
+ * stop all the VCPUs because interrupts can be migrated while we don't hold
+ * the IRQ locks and we don't want to be chasing moving targets.
+ *
+ * For GICv2 private interrupts we don't have to do anything because
+ * userspace accesses to the VGIC state already require all VCPUs to be
+ * stopped, and only the VCPU itself can modify its private interrupts
+ * active state, which guarantees that the VCPU is not running.
+ */
+static void vgic_access_active_prepare(struct kvm_vcpu *vcpu, u32 intid)
+{
+	if (vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3 ||
+	    intid >= VGIC_NR_PRIVATE_IRQS)
+		kvm_arm_halt_guest(vcpu->kvm);
+}
+
+/* See vgic_access_active_prepare */
+static void vgic_access_active_finish(struct kvm_vcpu *vcpu, u32 intid)
+{
+	if (vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3 ||
+	    intid >= VGIC_NR_PRIVATE_IRQS)
+		kvm_arm_resume_guest(vcpu->kvm);
+}
+
+static unsigned long __vgic_mmio_read_active(struct kvm_vcpu *vcpu,
+					     gpa_t addr, unsigned int len)
 {
 	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
 	u32 value = 0;
@@ -359,6 +390,10 @@ unsigned long vgic_mmio_read_active(struct kvm_vcpu *vcpu,
 	for (i = 0; i < len * 8; i++) {
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
 
+		/*
+		 * Even for HW interrupts, don't evaluate the HW state as
+		 * all the guest is interested in is the virtual state.
+		 */
 		if (irq->active)
 			value |= (1U << i);
 
@@ -368,6 +403,29 @@ unsigned long vgic_mmio_read_active(struct kvm_vcpu *vcpu,
 	return value;
 }
 
+unsigned long vgic_mmio_read_active(struct kvm_vcpu *vcpu,
+				    gpa_t addr, unsigned int len)
+{
+	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
+	u32 val;
+
+	mutex_lock(&vcpu->kvm->lock);
+	vgic_access_active_prepare(vcpu, intid);
+
+	val = __vgic_mmio_read_active(vcpu, addr, len);
+
+	vgic_access_active_finish(vcpu, intid);
+	mutex_unlock(&vcpu->kvm->lock);
+
+	return val;
+}
+
+unsigned long vgic_uaccess_read_active(struct kvm_vcpu *vcpu,
+				    gpa_t addr, unsigned int len)
+{
+	return __vgic_mmio_read_active(vcpu, addr, len);
+}
+
 /* Must be called with irq->irq_lock held */
 static void vgic_hw_irq_change_active(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
 				      bool active, bool is_uaccess)
@@ -426,36 +484,6 @@ static void vgic_mmio_change_active(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
 		raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
 }
 
-/*
- * If we are fiddling with an IRQ's active state, we have to make sure the IRQ
- * is not queued on some running VCPU's LRs, because then the change to the
- * active state can be overwritten when the VCPU's state is synced coming back
- * from the guest.
- *
- * For shared interrupts, we have to stop all the VCPUs because interrupts can
- * be migrated while we don't hold the IRQ locks and we don't want to be
- * chasing moving targets.
- *
- * For private interrupts we don't have to do anything because userspace
- * accesses to the VGIC state already require all VCPUs to be stopped, and
- * only the VCPU itself can modify its private interrupts active state, which
- * guarantees that the VCPU is not running.
- */
-static void vgic_change_active_prepare(struct kvm_vcpu *vcpu, u32 intid)
-{
-	if (vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3 ||
-	    intid >= VGIC_NR_PRIVATE_IRQS)
-		kvm_arm_halt_guest(vcpu->kvm);
-}
-
-/* See vgic_change_active_prepare */
-static void vgic_change_active_finish(struct kvm_vcpu *vcpu, u32 intid)
-{
-	if (vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3 ||
-	    intid >= VGIC_NR_PRIVATE_IRQS)
-		kvm_arm_resume_guest(vcpu->kvm);
-}
-
 static void __vgic_mmio_write_cactive(struct kvm_vcpu *vcpu,
 				      gpa_t addr, unsigned int len,
 				      unsigned long val)
@@ -477,11 +505,11 @@ void vgic_mmio_write_cactive(struct kvm_vcpu *vcpu,
 	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
 
 	mutex_lock(&vcpu->kvm->lock);
-	vgic_change_active_prepare(vcpu, intid);
+	vgic_access_active_prepare(vcpu, intid);
 
 	__vgic_mmio_write_cactive(vcpu, addr, len, val);
 
-	vgic_change_active_finish(vcpu, intid);
+	vgic_access_active_finish(vcpu, intid);
 	mutex_unlock(&vcpu->kvm->lock);
 }
 
@@ -514,11 +542,11 @@ void vgic_mmio_write_sactive(struct kvm_vcpu *vcpu,
 	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
 
 	mutex_lock(&vcpu->kvm->lock);
-	vgic_change_active_prepare(vcpu, intid);
+	vgic_access_active_prepare(vcpu, intid);
 
 	__vgic_mmio_write_sactive(vcpu, addr, len, val);
 
-	vgic_change_active_finish(vcpu, intid);
+	vgic_access_active_finish(vcpu, intid);
 	mutex_unlock(&vcpu->kvm->lock);
 }
 
diff --git a/virt/kvm/arm/vgic/vgic-mmio.h b/virt/kvm/arm/vgic/vgic-mmio.h
index 5af2aefad435..30713a44e3fa 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.h
+++ b/virt/kvm/arm/vgic/vgic-mmio.h
@@ -152,6 +152,9 @@ void vgic_mmio_write_cpending(struct kvm_vcpu *vcpu,
 unsigned long vgic_mmio_read_active(struct kvm_vcpu *vcpu,
 				    gpa_t addr, unsigned int len);
 
+unsigned long vgic_uaccess_read_active(struct kvm_vcpu *vcpu,
+				    gpa_t addr, unsigned int len);
+
 void vgic_mmio_write_cactive(struct kvm_vcpu *vcpu,
 			     gpa_t addr, unsigned int len,
 			     unsigned long val);
-- 
2.26.1

