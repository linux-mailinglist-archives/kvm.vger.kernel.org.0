Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEC021B5F9F
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 17:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729383AbgDWPkh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 11:40:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:51446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729380AbgDWPkh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 11:40:37 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00CC22168B;
        Thu, 23 Apr 2020 15:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587656436;
        bh=QS6rYDCDejPEk4jwFIWY7uyStVzw2sD2YDs5SA4saV8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ff5nAxcNtDkj2hPyr9StqjY60oILwlOWpX88EupxINen6GiwI36ZXEwGgTYqBJoys
         wSn1xqotPXjrj8RYqVdhBGc1zcwha1qvak+x9yb2obF8N0oZZ/i3C8lo5gxQHvWB82
         lwk/bJ+2sCISLLzyrzsWh0R47jk6Bf4YJaYqpXfI=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jRdxq-005oPM-D2; Thu, 23 Apr 2020 16:40:34 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        =?UTF-8?q?Andr=C3=A9=20Przywara?= <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Julien Grall <julien@xen.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu
Subject: [PATCH 6/8] KVM: arm: vgic-v2: Only use the virtual state when userspace accesses pending bits
Date:   Thu, 23 Apr 2020 16:40:07 +0100
Message-Id: <20200423154009.4113562-7-maz@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200423154009.4113562-1-maz@kernel.org>
References: <20200423154009.4113562-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com, andre.przywara@arm.com, christoffer.dall@arm.com, julien@xen.org, yuzenghui@huawei.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There is no point in accessing the HW when writing to any of the
ISPENDR/ICPENDR registers from userspace, as only the guest should
be allowed to change the HW state.

Introduce new userspace-specific accessors that deal solely with
the virtual state. Note that the API differs from that of GICv3,
where userspace exclusively uses ISPENDR to set the state. Too
bad we can't reuse it.

Fixes: 82e40f558de56 ("KVM: arm/arm64: vgic-v2: Handle SGI bits in GICD_I{S,C}PENDR0 as WI")
Reviewed-by: James Morse <james.morse@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 virt/kvm/arm/vgic/vgic-mmio-v2.c |  6 ++-
 virt/kvm/arm/vgic/vgic-mmio.c    | 86 ++++++++++++++++++++++++--------
 virt/kvm/arm/vgic/vgic-mmio.h    |  8 +++
 3 files changed, 76 insertions(+), 24 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
index f51c6e939c761..a016f07adc281 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
@@ -417,10 +417,12 @@ static const struct vgic_register_region vgic_v2_dist_registers[] = {
 		NULL, vgic_uaccess_write_cenable, 1,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_PENDING_SET,
-		vgic_mmio_read_pending, vgic_mmio_write_spending, NULL, NULL, 1,
+		vgic_mmio_read_pending, vgic_mmio_write_spending,
+		NULL, vgic_uaccess_write_spending, 1,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_PENDING_CLEAR,
-		vgic_mmio_read_pending, vgic_mmio_write_cpending, NULL, NULL, 1,
+		vgic_mmio_read_pending, vgic_mmio_write_cpending,
+		NULL, vgic_uaccess_write_cpending, 1,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ACTIVE_SET,
 		vgic_mmio_read_active, vgic_mmio_write_sactive,
diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
index 6e30034d14645..b2d73fc0d1ef4 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -261,17 +261,6 @@ unsigned long vgic_mmio_read_pending(struct kvm_vcpu *vcpu,
 	return value;
 }
 
-/* Must be called with irq->irq_lock held */
-static void vgic_hw_irq_spending(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
-				 bool is_uaccess)
-{
-	if (is_uaccess)
-		return;
-
-	irq->pending_latch = true;
-	vgic_irq_set_phys_active(irq, true);
-}
-
 static bool is_vgic_v2_sgi(struct kvm_vcpu *vcpu, struct vgic_irq *irq)
 {
 	return (vgic_irq_is_sgi(irq->intid) &&
@@ -282,7 +271,6 @@ void vgic_mmio_write_spending(struct kvm_vcpu *vcpu,
 			      gpa_t addr, unsigned int len,
 			      unsigned long val)
 {
-	bool is_uaccess = !kvm_get_running_vcpu();
 	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
 	int i;
 	unsigned long flags;
@@ -312,22 +300,48 @@ void vgic_mmio_write_spending(struct kvm_vcpu *vcpu,
 			continue;
 		}
 
+		irq->pending_latch = true;
 		if (irq->hw)
-			vgic_hw_irq_spending(vcpu, irq, is_uaccess);
-		else
-			irq->pending_latch = true;
+			vgic_irq_set_phys_active(irq, true);
+
 		vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
 		vgic_put_irq(vcpu->kvm, irq);
 	}
 }
 
-/* Must be called with irq->irq_lock held */
-static void vgic_hw_irq_cpending(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
-				 bool is_uaccess)
+int vgic_uaccess_write_spending(struct kvm_vcpu *vcpu,
+				gpa_t addr, unsigned int len,
+				unsigned long val)
 {
-	if (is_uaccess)
-		return;
+	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
+	int i;
+	unsigned long flags;
+
+	for_each_set_bit(i, &val, len * 8) {
+		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
 
+		raw_spin_lock_irqsave(&irq->irq_lock, flags);
+		irq->pending_latch = true;
+
+		/*
+		 * GICv2 SGIs are terribly broken. We can't restore
+		 * the source of the interrupt, so just pick the vcpu
+		 * itself as the source...
+		 */
+		if (is_vgic_v2_sgi(vcpu, irq))
+			irq->source |= BIT(vcpu->vcpu_id);
+
+		vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
+
+		vgic_put_irq(vcpu->kvm, irq);
+	}
+
+	return 0;
+}
+
+/* Must be called with irq->irq_lock held */
+static void vgic_hw_irq_cpending(struct kvm_vcpu *vcpu, struct vgic_irq *irq)
+{
 	irq->pending_latch = false;
 
 	/*
@@ -350,7 +364,6 @@ void vgic_mmio_write_cpending(struct kvm_vcpu *vcpu,
 			      gpa_t addr, unsigned int len,
 			      unsigned long val)
 {
-	bool is_uaccess = !kvm_get_running_vcpu();
 	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
 	int i;
 	unsigned long flags;
@@ -381,7 +394,7 @@ void vgic_mmio_write_cpending(struct kvm_vcpu *vcpu,
 		}
 
 		if (irq->hw)
-			vgic_hw_irq_cpending(vcpu, irq, is_uaccess);
+			vgic_hw_irq_cpending(vcpu, irq);
 		else
 			irq->pending_latch = false;
 
@@ -390,6 +403,35 @@ void vgic_mmio_write_cpending(struct kvm_vcpu *vcpu,
 	}
 }
 
+int vgic_uaccess_write_cpending(struct kvm_vcpu *vcpu,
+				gpa_t addr, unsigned int len,
+				unsigned long val)
+{
+	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
+	int i;
+	unsigned long flags;
+
+	for_each_set_bit(i, &val, len * 8) {
+		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
+
+		raw_spin_lock_irqsave(&irq->irq_lock, flags);
+		/*
+		 * More fun with GICv2 SGIs! If we're clearing one of them
+		 * from userspace, which source vcpu to clear? Let's not
+		 * even think of it, and blow the whole set.
+		 */
+		if (is_vgic_v2_sgi(vcpu, irq))
+			irq->source = 0;
+
+		irq->pending_latch = false;
+
+		raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
+
+		vgic_put_irq(vcpu->kvm, irq);
+	}
+
+	return 0;
+}
 
 /*
  * If we are fiddling with an IRQ's active state, we have to make sure the IRQ
diff --git a/virt/kvm/arm/vgic/vgic-mmio.h b/virt/kvm/arm/vgic/vgic-mmio.h
index 327d0a6938e4d..fefcca2b14dc7 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.h
+++ b/virt/kvm/arm/vgic/vgic-mmio.h
@@ -157,6 +157,14 @@ void vgic_mmio_write_cpending(struct kvm_vcpu *vcpu,
 			      gpa_t addr, unsigned int len,
 			      unsigned long val);
 
+int vgic_uaccess_write_spending(struct kvm_vcpu *vcpu,
+				gpa_t addr, unsigned int len,
+				unsigned long val);
+
+int vgic_uaccess_write_cpending(struct kvm_vcpu *vcpu,
+				gpa_t addr, unsigned int len,
+				unsigned long val);
+
 unsigned long vgic_mmio_read_active(struct kvm_vcpu *vcpu,
 				    gpa_t addr, unsigned int len);
 
-- 
2.26.2

