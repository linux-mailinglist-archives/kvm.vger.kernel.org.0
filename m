Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD3EB37A3B
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 18:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728723AbfFFQzK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 12:55:10 -0400
Received: from foss.arm.com ([217.140.101.70]:50724 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728708AbfFFQzJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 12:55:09 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 53C4215AB;
        Thu,  6 Jun 2019 09:55:09 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (filthy-habits.cambridge.arm.com [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8762A3F690;
        Thu,  6 Jun 2019 09:55:07 -0700 (PDT)
From:   Marc Zyngier <marc.zyngier@arm.com>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Julien Thierry <julien.thierry@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        "Raslan, KarimAllah" <karahmed@amazon.de>
Subject: [PATCH 2/8] KVM: arm/arm64: vgic: Add __vgic_put_lpi_locked primitive
Date:   Thu,  6 Jun 2019 17:54:49 +0100
Message-Id: <20190606165455.162478-3-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190606165455.162478-1-marc.zyngier@arm.com>
References: <20190606165455.162478-1-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Our LPI translation cache needs to be able to drop the refcount
on an LPI whilst already holding the lpi_list_lock.

Let's add a new primitive for this.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic.c | 26 +++++++++++++++++---------
 virt/kvm/arm/vgic/vgic.h |  1 +
 2 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index 191deccf60bf..376a297e2169 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -130,6 +130,22 @@ static void vgic_irq_release(struct kref *ref)
 {
 }
 
+/*
+ * Drop the refcount on the LPI. Must be called with lpi_list_lock held.
+ */
+void __vgic_put_lpi_locked(struct kvm *kvm, struct vgic_irq *irq)
+{
+	struct vgic_dist *dist = &kvm->arch.vgic;
+
+	if (!kref_put(&irq->refcount, vgic_irq_release))
+		return;
+
+	list_del(&irq->lpi_list);
+	dist->lpi_list_count--;
+
+	kfree(irq);
+}
+
 void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
@@ -139,16 +155,8 @@ void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq)
 		return;
 
 	raw_spin_lock_irqsave(&dist->lpi_list_lock, flags);
-	if (!kref_put(&irq->refcount, vgic_irq_release)) {
-		raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
-		return;
-	};
-
-	list_del(&irq->lpi_list);
-	dist->lpi_list_count--;
+	__vgic_put_lpi_locked(kvm, irq);
 	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
-
-	kfree(irq);
 }
 
 void vgic_flush_pending_lpis(struct kvm_vcpu *vcpu)
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index a58e1b263dca..80cd40575bc9 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -172,6 +172,7 @@ vgic_get_mmio_region(struct kvm_vcpu *vcpu, struct vgic_io_device *iodev,
 		     gpa_t addr, int len);
 struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
 			      u32 intid);
+void __vgic_put_lpi_locked(struct kvm *kvm, struct vgic_irq *irq);
 void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq);
 bool vgic_get_phys_line_level(struct vgic_irq *irq);
 void vgic_irq_set_phys_pending(struct vgic_irq *irq, bool pending);
-- 
2.20.1

