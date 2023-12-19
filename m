Return-Path: <kvm+bounces-4771-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B9568181EE
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 08:03:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ACCE9284EDF
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 07:03:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9737B1B291;
	Tue, 19 Dec 2023 06:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="IcY0hKC0"
X-Original-To: kvm@vger.kernel.org
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 759151A5A7
	for <kvm@vger.kernel.org>; Tue, 19 Dec 2023 06:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1702969164;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FNbLxIRh0Wv8TFS1gqoM2aRKtArcp+QnRhjztAMo6bE=;
	b=IcY0hKC0ClZRGkmVkPCntLlNQdLeWpSHyU8veILGfRBG4CUG9ExmPfe3FiaybSqw7FbGyN
	rMaQtHEXz9uDZvG/q0kp4cfCG2zcz4R/xzvrX7Q/DQ5mg0QnreOs4k3CgW9vP0m2FAjRMC
	KDCNRrwDNWGvvBWl5nXHU9mGdw0JJHg=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Kunkun Jiang <jiangkunkun@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 2/3] KVM: arm64: vgic: Use common accessor for writes to ICPENDR
Date: Tue, 19 Dec 2023 06:58:54 +0000
Message-ID: <20231219065855.1019608-3-oliver.upton@linux.dev>
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

Fold MMIO and user accessors into a common helper while maintaining the
distinction between the two. It is now possible for userspace to clear
the pending state for SGIs from the ITS, as is the case with GICv4.1
vSGIs.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-mmio.c | 51 ++++++++++++++-------------------
 1 file changed, 22 insertions(+), 29 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-mmio.c b/arch/arm64/kvm/vgic/vgic-mmio.c
index 273912083056..cf76523a2194 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio.c
@@ -386,9 +386,9 @@ static void vgic_hw_irq_cpending(struct kvm_vcpu *vcpu, struct vgic_irq *irq)
 		vgic_irq_set_phys_active(irq, false);
 }
 
-void vgic_mmio_write_cpending(struct kvm_vcpu *vcpu,
-			      gpa_t addr, unsigned int len,
-			      unsigned long val)
+static void __clear_pending(struct kvm_vcpu *vcpu,
+			    gpa_t addr, unsigned int len,
+			    unsigned long val, bool is_user)
 {
 	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
 	int i;
@@ -397,14 +397,22 @@ void vgic_mmio_write_cpending(struct kvm_vcpu *vcpu,
 	for_each_set_bit(i, &val, len * 8) {
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
 
-		/* GICD_ICPENDR0 SGI bits are WI */
-		if (is_vgic_v2_sgi(vcpu, irq)) {
+		/* GICD_ICPENDR0 SGI bits are WI when written from the guest. */
+		if (is_vgic_v2_sgi(vcpu, irq) && !is_user) {
 			vgic_put_irq(vcpu->kvm, irq);
 			continue;
 		}
 
 		raw_spin_lock_irqsave(&irq->irq_lock, flags);
 
+		/*
+		 * More fun with GICv2 SGIs! If we're clearing one of them
+		 * from userspace, which source vcpu to clear? Let's not
+		 * even think of it, and blow the whole set.
+		 */
+		if (is_vgic_v2_sgi(vcpu, irq))
+			irq->source = 0;
+
 		if (irq->hw && vgic_irq_is_sgi(irq->intid)) {
 			/* HW SGI? Ask the GIC to clear its pending bit */
 			int err;
@@ -419,7 +427,7 @@ void vgic_mmio_write_cpending(struct kvm_vcpu *vcpu,
 			continue;
 		}
 
-		if (irq->hw)
+		if (irq->hw && !is_user)
 			vgic_hw_irq_cpending(vcpu, irq);
 		else
 			irq->pending_latch = false;
@@ -429,33 +437,18 @@ void vgic_mmio_write_cpending(struct kvm_vcpu *vcpu,
 	}
 }
 
+void vgic_mmio_write_cpending(struct kvm_vcpu *vcpu,
+			      gpa_t addr, unsigned int len,
+			      unsigned long val)
+{
+	__clear_pending(vcpu, addr, len, val, false);
+}
+
 int vgic_uaccess_write_cpending(struct kvm_vcpu *vcpu,
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
-		/*
-		 * More fun with GICv2 SGIs! If we're clearing one of them
-		 * from userspace, which source vcpu to clear? Let's not
-		 * even think of it, and blow the whole set.
-		 */
-		if (is_vgic_v2_sgi(vcpu, irq))
-			irq->source = 0;
-
-		irq->pending_latch = false;
-
-		raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
-
-		vgic_put_irq(vcpu->kvm, irq);
-	}
-
+	__clear_pending(vcpu, addr, len, val, true);
 	return 0;
 }
 
-- 
2.43.0.472.g3155946c3a-goog


