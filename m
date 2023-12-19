Return-Path: <kvm+bounces-4770-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D42518181ED
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 08:03:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1204DB24C24
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 07:03:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 751F51B267;
	Tue, 19 Dec 2023 06:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NBn7sTDY"
X-Original-To: kvm@vger.kernel.org
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE15C1A293
	for <kvm@vger.kernel.org>; Tue, 19 Dec 2023 06:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1702969163;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4MA+Z15O910anrZucMdivOiD9UVYXogIaJsA7bpY1Ec=;
	b=NBn7sTDYb0QTLrQ38MZPicLFpdoKFF6JEASGln38BsPOqgWpPvrzMNHjEayoBRTcQdu9U5
	Y/hg9pGgiHoS6IaTFoMsNG1CziX2DwTFQN+mJ6OQggthfPUrj8GVISh64OxQJl9YroWSle
	SsyGaAr4EF84Z5keF/x+FkIwt3+/s2I=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Kunkun Jiang <jiangkunkun@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 1/3] KVM: arm64: vgic: Use common accessor for writes to ISPENDR
Date: Tue, 19 Dec 2023 06:58:53 +0000
Message-ID: <20231219065855.1019608-2-oliver.upton@linux.dev>
In-Reply-To: <20231219065855.1019608-1-oliver.upton@linux.dev>
References: <20231219065855.1019608-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Perhaps unsurprisingly, there is a considerable amount of duplicate
code between the MMIO and user accessors for ISPENDR. At the same
time there are some important differences between user and guest
MMIO, like how SGIs can only be made pending from userspace.

Fold user and MMIO accessors into a common helper, maintaining the
distinction between the two. User accesses can now mark SGIs as
pending in hardware for GICv4.1 vSGIs.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-mmio.c | 50 ++++++++++++++-------------------
 1 file changed, 21 insertions(+), 29 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-mmio.c b/arch/arm64/kvm/vgic/vgic-mmio.c
index ff558c05e990..273912083056 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio.c
@@ -301,9 +301,8 @@ static bool is_vgic_v2_sgi(struct kvm_vcpu *vcpu, struct vgic_irq *irq)
 		vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V2);
 }
 
-void vgic_mmio_write_spending(struct kvm_vcpu *vcpu,
-			      gpa_t addr, unsigned int len,
-			      unsigned long val)
+static void __set_pending(struct kvm_vcpu *vcpu, gpa_t addr, unsigned int len,
+			  unsigned long val, bool is_user)
 {
 	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
 	int i;
@@ -312,14 +311,22 @@ void vgic_mmio_write_spending(struct kvm_vcpu *vcpu,
 	for_each_set_bit(i, &val, len * 8) {
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
 
-		/* GICD_ISPENDR0 SGI bits are WI */
-		if (is_vgic_v2_sgi(vcpu, irq)) {
+		/* GICD_ISPENDR0 SGI bits are WI when written from the guest. */
+		if (is_vgic_v2_sgi(vcpu, irq) && !is_user) {
 			vgic_put_irq(vcpu->kvm, irq);
 			continue;
 		}
 
 		raw_spin_lock_irqsave(&irq->irq_lock, flags);
 
+		/*
+		 * GICv2 SGIs are terribly broken. We can't restore
+		 * the source of the interrupt, so just pick the vcpu
+		 * itself as the source...
+		 */
+		if (is_vgic_v2_sgi(vcpu, irq))
+			irq->source |= BIT(vcpu->vcpu_id);
+
 		if (irq->hw && vgic_irq_is_sgi(irq->intid)) {
 			/* HW SGI? Ask the GIC to inject it */
 			int err;
@@ -335,7 +342,7 @@ void vgic_mmio_write_spending(struct kvm_vcpu *vcpu,
 		}
 
 		irq->pending_latch = true;
-		if (irq->hw)
+		if (irq->hw && !is_user)
 			vgic_irq_set_phys_active(irq, true);
 
 		vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
@@ -343,33 +350,18 @@ void vgic_mmio_write_spending(struct kvm_vcpu *vcpu,
 	}
 }
 
+void vgic_mmio_write_spending(struct kvm_vcpu *vcpu,
+			      gpa_t addr, unsigned int len,
+			      unsigned long val)
+{
+	__set_pending(vcpu, addr, len, val, false);
+}
+
 int vgic_uaccess_write_spending(struct kvm_vcpu *vcpu,
 				gpa_t addr, unsigned int len,
 				unsigned long val)
 {
-	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
-	int i;
-	unsigned long flags;
-
-	for_each_set_bit(i, &val, len * 8) {
-		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
-
-		raw_spin_lock_irqsave(&irq->irq_lock, flags);
-		irq->pending_latch = true;
-
-		/*
-		 * GICv2 SGIs are terribly broken. We can't restore
-		 * the source of the interrupt, so just pick the vcpu
-		 * itself as the source...
-		 */
-		if (is_vgic_v2_sgi(vcpu, irq))
-			irq->source |= BIT(vcpu->vcpu_id);
-
-		vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
-
-		vgic_put_irq(vcpu->kvm, irq);
-	}
-
+	__set_pending(vcpu, addr, len, val, true);
 	return 0;
 }
 
-- 
2.43.0.472.g3155946c3a-goog


