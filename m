Return-Path: <kvm+bounces-61874-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D07EC2D5A5
	for <lists+kvm@lfdr.de>; Mon, 03 Nov 2025 18:07:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C954C3A04E8
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 16:57:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC530321F51;
	Mon,  3 Nov 2025 16:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PozW+kgK"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3794631E0EC;
	Mon,  3 Nov 2025 16:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762188930; cv=none; b=jSNfBIN48oQNQPoN5QWI9XrupE+r9fOhxrxt6WpdEFYDMjDO2Lz273yO4TDmdVNe5bRWpeOWyCVu2M6mWdRUEMANEulAvbv918YFxP/uc9CC/+faoxjSOcmOQudVUjBetd8klYzWK2ioajbBwKicWexwj2B07jAYMENVWR6NJWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762188930; c=relaxed/simple;
	bh=zuhKLI7VX81K7N1waWG6RKB+bJ6LNUR7JqGCymcfMXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fcwpz0DqCZdXvIRcAYdhkcZ6rYkpOjkBnq4uQ4K6RUY84+JS6GYEDK7XqAZdM8q9xMr552C02B2SBDYwI+kUnmlWdYcCayaHALnA1c6lnCamiB7/uTsg2BEOw+sRNj4UF3ZJleBDZnbc/KYKela5t8gwdSqaMZh5Q8rGpKOoD9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PozW+kgK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C05F3C4CEFD;
	Mon,  3 Nov 2025 16:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762188929;
	bh=zuhKLI7VX81K7N1waWG6RKB+bJ6LNUR7JqGCymcfMXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PozW+kgKZllTeNrjJv/g/u3+TzveJkdKg4AH1MNeKIqUai2wjCGyE9HC75KpQzCUo
	 ShNQVoIhJu4GBr4PfCnVuuYlKh73WxKEGJBksgu8Bbbotj7Wm8BWoojivw77ybZK9C
	 OvX3hmoDZjjEULrlBKm2xR67u+ct3bXXwWEd4tWog77UBJ4upYPRGWz4j/vcV8ypnK
	 DdA1DucsIF/nUobJ94ANjG6lXQArbeWMlvLrkiG/owFbj84CV0PBZ9tWKhVqsDJfyj
	 iZbghcPenDQWPguqNok/RpQMZVsyKakx1Cut8wuZYNT+KvF9EMEdO+Z88JzA+JUKYS
	 /CyEF7XVLuC1Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vFxq3-000000021VN-3LBp;
	Mon, 03 Nov 2025 16:55:27 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>
Subject: [PATCH 13/33] KVM: arm64: GICv3: Extract LR computing primitive
Date: Mon,  3 Nov 2025 16:54:57 +0000
Message-ID: <20251103165517.2960148-14-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251103165517.2960148-1-maz@kernel.org>
References: <20251103165517.2960148-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, christoffer.dall@arm.com, Volodymyr_Babchuk@epam.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Split vgic_v3_populate_lr() into two, so that we have another
primitive that computes the LR from a vgic_irq, but doesn't
update anything in the shadow structure.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-v3.c | 49 +++++++++++++++++++++++------------
 1 file changed, 32 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 8f28227ae7193..ad5c0dbae2dfe 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -107,7 +107,7 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
 }
 
 /* Requires the irq to be locked already */
-void vgic_v3_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)
+static u64 vgic_v3_compute_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq)
 {
 	u32 model = vcpu->kvm->arch.vgic.vgic_model;
 	u64 val = irq->intid;
@@ -154,6 +154,35 @@ void vgic_v3_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)
 	if (allow_pending && irq_is_pending(irq)) {
 		val |= ICH_LR_PENDING_BIT;
 
+		if (is_v2_sgi) {
+			u32 src = ffs(irq->source);
+
+			if (WARN_RATELIMIT(!src, "No SGI source for INTID %d\n",
+					   irq->intid))
+				return 0;
+
+			val |= (src - 1) << GICH_LR_PHYSID_CPUID_SHIFT;
+			if (irq->source & ~BIT(src - 1))
+				val |= ICH_LR_EOI;
+		}
+	}
+
+	if (irq->group)
+		val |= ICH_LR_GROUP;
+
+	val |= (u64)irq->priority << ICH_LR_PRIORITY_SHIFT;
+
+	return val;
+}
+
+void vgic_v3_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)
+{
+	u32 model = vcpu->kvm->arch.vgic.vgic_model;
+	u64 val = vgic_v3_compute_lr(vcpu, irq);
+
+	vcpu->arch.vgic_cpu.vgic_v3.vgic_lr[lr] = val;
+
+	if (val & ICH_LR_PENDING_BIT) {
 		if (irq->config == VGIC_CONFIG_EDGE)
 			irq->pending_latch = false;
 
@@ -161,16 +190,9 @@ void vgic_v3_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)
 		    model == KVM_DEV_TYPE_ARM_VGIC_V2) {
 			u32 src = ffs(irq->source);
 
-			if (WARN_RATELIMIT(!src, "No SGI source for INTID %d\n",
-					   irq->intid))
-				return;
-
-			val |= (src - 1) << GICH_LR_PHYSID_CPUID_SHIFT;
-			irq->source &= ~(1 << (src - 1));
-			if (irq->source) {
+			irq->source &= ~BIT(src - 1);
+			if (irq->source)
 				irq->pending_latch = true;
-				val |= ICH_LR_EOI;
-			}
 		}
 	}
 
@@ -183,13 +205,6 @@ void vgic_v3_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)
 	if (vgic_irq_is_mapped_level(irq) && (val & ICH_LR_PENDING_BIT))
 		irq->line_level = false;
 
-	if (irq->group)
-		val |= ICH_LR_GROUP;
-
-	val |= (u64)irq->priority << ICH_LR_PRIORITY_SHIFT;
-
-	vcpu->arch.vgic_cpu.vgic_v3.vgic_lr[lr] = val;
-
 	irq->on_lr = true;
 }
 
-- 
2.47.3


