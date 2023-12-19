Return-Path: <kvm+bounces-4772-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D64688181EF
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 08:03:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6F17E284FFC
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 07:03:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72F911BDC5;
	Tue, 19 Dec 2023 06:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gDhl8sPv"
X-Original-To: kvm@vger.kernel.org
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 298A51B27A
	for <kvm@vger.kernel.org>; Tue, 19 Dec 2023 06:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1702969166;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F9o3UskDr2jYwmQSpWQPI+b+KMDoEezlPhX1Sv2Kwek=;
	b=gDhl8sPvVQNiEOckj/VSMkEFTNmNX2Dui9ngJbC0KLhvs+9eqmxEZhVKzlsfM1PDZ0CrAM
	n/yYCLb0NbYTFRuKjiKf7tt5BiJUnZe7kTUdPaI+I7MgdrrdTVH9RwIHRr0OFS8uA0bqpk
	cK8B3RY5N2EtmyX7Oxm1aEMnieI0UK0=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Kunkun Jiang <jiangkunkun@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 3/3] KVM: arm64: vgic-v3: Reinterpret user ISPENDR writes as I{C,S}PENDR
Date: Tue, 19 Dec 2023 06:58:55 +0000
Message-ID: <20231219065855.1019608-4-oliver.upton@linux.dev>
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

User writes to ISPENDR for GICv3 are treated specially, as zeroes
actually clear the pending state for interrupts (unlike HW). Reimplement
it using the ISPENDR and ICPENDR user accessors. This eliminates some
code and ensures that userspace can modify the state of SGIs in hardware
for GICv4.1 vSGIs.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 28 +++++-----------------------
 1 file changed, 5 insertions(+), 23 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index 89117ba2528a..2962ccd8013a 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -357,31 +357,13 @@ static int vgic_v3_uaccess_write_pending(struct kvm_vcpu *vcpu,
 					 gpa_t addr, unsigned int len,
 					 unsigned long val)
 {
-	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
-	int i;
-	unsigned long flags;
-
-	for (i = 0; i < len * 8; i++) {
-		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
-
-		raw_spin_lock_irqsave(&irq->irq_lock, flags);
-		if (test_bit(i, &val)) {
-			/*
-			 * pending_latch is set irrespective of irq type
-			 * (level or edge) to avoid dependency that VM should
-			 * restore irq config before pending info.
-			 */
-			irq->pending_latch = true;
-			vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
-		} else {
-			irq->pending_latch = false;
-			raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
-		}
+	int ret;
 
-		vgic_put_irq(vcpu->kvm, irq);
-	}
+	ret = vgic_uaccess_write_spending(vcpu, addr, len, val);
+	if (ret)
+		return ret;
 
-	return 0;
+	return vgic_uaccess_write_cpending(vcpu, addr, len, ~val);
 }
 
 /* We want to avoid outer shareable. */
-- 
2.43.0.472.g3155946c3a-goog


