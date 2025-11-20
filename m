Return-Path: <kvm+bounces-63933-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 17A43C75B6C
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 18:36:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 235DB35CB9F
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 17:30:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68E75393DD1;
	Thu, 20 Nov 2025 17:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ap9/KVSI"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63EF5374139;
	Thu, 20 Nov 2025 17:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763659560; cv=none; b=S9yaXpiANl5rmrF+d56MuSK1Yn1OrFSpurPkkS8a98myzTj3Fgw/4+10oDvMPPM2msd0Ox4poGpigH65Rsl2vKM84XQ9wg2Xe6SjJS9DXGP9fWFPeUrz+pjER1eJtQe1dfGlxqXqehV1cFTf/DvjXnqjZ5inaxRBqimORAswof4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763659560; c=relaxed/simple;
	bh=+Tg0lzsrYBfmnrwDBIpAImqT1N4cfKAmCDeyZzlZfU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V/sFWJYo56NwPn0gX15rVfV9kPtjfJUuIodZhQ2vAjATa2sSz9IKT++FJhRZ0qWFPd0gP/GqmIUKihHALWQdSlGEgdzTe5QGY5DWDpIvrt5TRuBPEg+fMANx4oUtm3h7VOeB60KmqAhYge/3J2C6EPcHZ14rPaWXY4YFY6LKb08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ap9/KVSI; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8187C4CEF1;
	Thu, 20 Nov 2025 17:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763659559;
	bh=+Tg0lzsrYBfmnrwDBIpAImqT1N4cfKAmCDeyZzlZfU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ap9/KVSIUsVZ3eUzH+cOWhuqpnKq/H+MhQ+2PBTWJ1WcGgn0WRyROsmk8UNWA0vsV
	 cOYLPBTf+laj4GpbMSr5jEatLEGU9ntBwNiNnWjsmM0cakh5EpJ+RGPrBQIxSYuEUS
	 WlAvjOYtiiLHqL014ylh/jzzORU7lTuYFXoqPgJA/nurHZnEdyTwG7mrg62NaPUDAP
	 tuvRdyjbwqF5QcZxLEF5YMZPFSjKdUefkZa6EB1MGg0OLMtcwyOvB4KuQAXJyv5Wx9
	 xssAPsLgQYco4buWLVmIVAXlnNHR4tA/5Wg/x0YsZpJ2MhhTmo8/HB/xTLVuaovn0m
	 OpE0KpsDBCuug==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vM8Pu-00000006y6g-0qLo;
	Thu, 20 Nov 2025 17:25:58 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v4 18/49] KVM: arm64: GICv2: Extract LR computing primitive
Date: Thu, 20 Nov 2025 17:25:08 +0000
Message-ID: <20251120172540.2267180-19-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251120172540.2267180-1-maz@kernel.org>
References: <20251120172540.2267180-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, christoffer.dall@arm.com, tabba@google.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Split vgic_v2_populate_lr() into two helpers, so that we have another
primitive that computes the LR from a vgic_irq, but doesn't update
anything in the shadow structure.

Tested-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-v2.c | 61 ++++++++++++++++++++++-------------
 1 file changed, 39 insertions(+), 22 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v2.c b/arch/arm64/kvm/vgic/vgic-v2.c
index fb8efdd4196b1..5a2165a8d22c0 100644
--- a/arch/arm64/kvm/vgic/vgic-v2.c
+++ b/arch/arm64/kvm/vgic/vgic-v2.c
@@ -107,18 +107,7 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
 	cpuif->used_lrs = 0;
 }
 
-/*
- * Populates the particular LR with the state of a given IRQ:
- * - for an edge sensitive IRQ the pending state is cleared in struct vgic_irq
- * - for a level sensitive IRQ the pending state value is unchanged;
- *   it is dictated directly by the input level
- *
- * If @irq describes an SGI with multiple sources, we choose the
- * lowest-numbered source VCPU and clear that bit in the source bitmap.
- *
- * The irq_lock must be held by the caller.
- */
-void vgic_v2_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)
+static u32 vgic_v2_compute_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq)
 {
 	u32 val = irq->intid;
 	bool allow_pending = true;
@@ -164,22 +153,52 @@ void vgic_v2_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)
 	if (allow_pending && irq_is_pending(irq)) {
 		val |= GICH_LR_PENDING_BIT;
 
-		if (irq->config == VGIC_CONFIG_EDGE)
-			irq->pending_latch = false;
-
 		if (vgic_irq_is_sgi(irq->intid)) {
 			u32 src = ffs(irq->source);
 
 			if (WARN_RATELIMIT(!src, "No SGI source for INTID %d\n",
 					   irq->intid))
-				return;
+				return 0;
 
 			val |= (src - 1) << GICH_LR_PHYSID_CPUID_SHIFT;
-			irq->source &= ~(1 << (src - 1));
-			if (irq->source) {
-				irq->pending_latch = true;
+			if (irq->source & ~BIT(src - 1))
 				val |= GICH_LR_EOI;
-			}
+		}
+	}
+
+	/* The GICv2 LR only holds five bits of priority. */
+	val |= (irq->priority >> 3) << GICH_LR_PRIORITY_SHIFT;
+
+	return val;
+}
+
+/*
+ * Populates the particular LR with the state of a given IRQ:
+ * - for an edge sensitive IRQ the pending state is cleared in struct vgic_irq
+ * - for a level sensitive IRQ the pending state value is unchanged;
+ *   it is dictated directly by the input level
+ *
+ * If @irq describes an SGI with multiple sources, we choose the
+ * lowest-numbered source VCPU and clear that bit in the source bitmap.
+ *
+ * The irq_lock must be held by the caller.
+ */
+void vgic_v2_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)
+{
+	u32 val = vgic_v2_compute_lr(vcpu, irq);
+
+	vcpu->arch.vgic_cpu.vgic_v2.vgic_lr[lr] = val;
+
+	if (val & GICH_LR_PENDING_BIT) {
+		if (irq->config == VGIC_CONFIG_EDGE)
+			irq->pending_latch = false;
+
+		if (vgic_irq_is_sgi(irq->intid)) {
+			u32 src = ffs(irq->source);
+
+			irq->source &= ~BIT(src - 1);
+			if (irq->source)
+				irq->pending_latch = true;
 		}
 	}
 
@@ -196,8 +215,6 @@ void vgic_v2_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)
 	val |= (irq->priority >> 3) << GICH_LR_PRIORITY_SHIFT;
 
 	irq->on_lr = true;
-
-	vcpu->arch.vgic_cpu.vgic_v2.vgic_lr[lr] = val;
 }
 
 void vgic_v2_clear_lr(struct kvm_vcpu *vcpu, int lr)
-- 
2.47.3


