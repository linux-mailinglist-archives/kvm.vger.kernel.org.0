Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7F0F1AD8A0
	for <lists+kvm@lfdr.de>; Fri, 17 Apr 2020 10:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729790AbgDQIdl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Apr 2020 04:33:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:59480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729780AbgDQIdl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Apr 2020 04:33:41 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F15C221EB;
        Fri, 17 Apr 2020 08:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587112420;
        bh=KZ7zjhPPX6JY2RPqaAoxBA7gOEOc9dunZYLsFObgt2A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lEq+0Rt6EzYDejMgWL0Z2sOvzHbwYrSR5miBgbNYCxB1ObNeamghDVp+NtEX+9ZLM
         cQRTrDHIANLtqcssKXp6n2BgbjhX/b3AQeK2HY+7tSuTku4eN/bkMgqpVrW2HdTiw9
         wVO38VPHZnzsjfj80oq0D/aKd3E29CKZ/GAHJMAU=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jPMRO-00473f-CF; Fri, 17 Apr 2020 09:33:38 +0100
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
Subject: [PATCH v2 4/6] KVM: arm: vgic-v2: Only use the virtual state when userspace accesses pending bits
Date:   Fri, 17 Apr 2020 09:33:17 +0100
Message-Id: <20200417083319.3066217-5-maz@kernel.org>
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

There is no point in accessing the HW when writing to any of the
ISPENDR/ICPENDR registers from userspace, as only the guest should
be allowed to change the HW state.

Introduce new userspace-specific accessors that deal solely with
the virtual state. Note that the API differs from that of GICv3,
where userspace exclusively uses ISPENDR to set the state. Too
bad we can't reuse it.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 virt/kvm/arm/vgic/vgic-mmio-v2.c |  6 +++--
 virt/kvm/arm/vgic/vgic-mmio.c    | 41 ++++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic-mmio.h    |  8 +++++++
 3 files changed, 53 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
index f51c6e939c76..a016f07adc28 100644
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
index 6e30034d1464..f1927ae02d2e 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -321,6 +321,27 @@ void vgic_mmio_write_spending(struct kvm_vcpu *vcpu,
 	}
 }
 
+int vgic_uaccess_write_spending(struct kvm_vcpu *vcpu,
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
+		irq->pending_latch = true;
+		vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
+
+		vgic_put_irq(vcpu->kvm, irq);
+	}
+
+	return 0;
+}
+
 /* Must be called with irq->irq_lock held */
 static void vgic_hw_irq_cpending(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
 				 bool is_uaccess)
@@ -390,6 +411,26 @@ void vgic_mmio_write_cpending(struct kvm_vcpu *vcpu,
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
+		irq->pending_latch = false;
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
index 327d0a6938e4..fefcca2b14dc 100644
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
2.26.1

