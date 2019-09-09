Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C3A3ADA43
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2019 15:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731238AbfIINs4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Sep 2019 09:48:56 -0400
Received: from foss.arm.com ([217.140.110.172]:50522 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731232AbfIINs4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Sep 2019 09:48:56 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CE4141576;
        Mon,  9 Sep 2019 06:48:55 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 74A993F59C;
        Mon,  9 Sep 2019 06:48:53 -0700 (PDT)
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        James Morse <james.morse@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 02/17] KVM: arm/arm64: vgic: Add __vgic_put_lpi_locked primitive
Date:   Mon,  9 Sep 2019 14:47:52 +0100
Message-Id: <20190909134807.27978-3-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190909134807.27978-1-maz@kernel.org>
References: <20190909134807.27978-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Our LPI translation cache needs to be able to drop the refcount
on an LPI whilst already holding the lpi_list_lock.

Let's add a new primitive for this.

Tested-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 virt/kvm/arm/vgic/vgic.c | 26 +++++++++++++++++---------
 virt/kvm/arm/vgic/vgic.h |  1 +
 2 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index 13d4b38a94ec..846bb680fd45 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -119,6 +119,22 @@ static void vgic_irq_release(struct kref *ref)
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
@@ -128,16 +144,8 @@ void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq)
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
index a25b790ffa4e..8e9413e317b8 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -161,6 +161,7 @@ vgic_get_mmio_region(struct kvm_vcpu *vcpu, struct vgic_io_device *iodev,
 		     gpa_t addr, int len);
 struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
 			      u32 intid);
+void __vgic_put_lpi_locked(struct kvm *kvm, struct vgic_irq *irq);
 void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq);
 bool vgic_get_phys_line_level(struct vgic_irq *irq);
 void vgic_irq_set_phys_pending(struct vgic_irq *irq, bool pending);
-- 
2.20.1

