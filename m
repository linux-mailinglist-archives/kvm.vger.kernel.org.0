Return-Path: <kvm+bounces-63929-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id B7E5DC75B63
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 18:35:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id DE1773640F1
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 17:29:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B2FE37413E;
	Thu, 20 Nov 2025 17:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tyDE/IIp"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62D162F1FF3;
	Thu, 20 Nov 2025 17:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763659559; cv=none; b=DCBDtiybT7u5UmuZRYwQkh/5OffMCUZYUa+zt5qVSXW7ZO3caZ1ACvIW/wiCuh3yU3BYPABwsJ97i1Qn9whnyPz0bsqu45uR3ZinBmhbAXSyt0z6I1Zm0Ac5yqo+6KANU/8a8ErdGJ/9kkgkaNoQewYeE0N1er0MMhdq5TnOjh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763659559; c=relaxed/simple;
	bh=GJuikNEiM9aYP/YLsdMUrKCS8u0NoKs6DKQCFgpx0+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H5SqhiTlpZJW/QuWF/wyEJgIoJQLbVtj0HPRZ61AFVnkse8tsFLKLrcJRm1PqGFhm1Ko14UV3bDMn//H4crEJjVvAmf/wBoDFHBTYZkLyS7Ed7yhbpjSHkJgEkA6uSwn1duYAEHuT8ZALA9eo0JG6lvDCpImqaM0sW5NTGaphko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tyDE/IIp; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A776C16AAE;
	Thu, 20 Nov 2025 17:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763659559;
	bh=GJuikNEiM9aYP/YLsdMUrKCS8u0NoKs6DKQCFgpx0+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tyDE/IIpI1etUWtXxneew0sNRZ5d+61WZbmhdnp5cecxlZiOkGqip40IaDEIghM55
	 ccC/VtiWPqDsUJue0NWb3T8ME26Y5KY4pAXnU7xYVEDGpAWulBxZtpOng0OIenO/XV
	 zyOiNl6SQIEiHA23b6C7DjUO9pJTrh1h7AP1v6/O50t2DIeXhmqv9TYBlYlKyLBefm
	 0No+9cfjTrnUv4W9ecYF+rbC8I8tyiQzip/aW5Lsr6ArmQ33JqRafUfLh+qsxH3yiY
	 r3uY65IGGPf+icUXheVKsfC66FVDd2hcF5PPxyPlQFVQLS7zOLDW1JKmyOSbZbnw+Y
	 N3RNMJWFyOW4A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vM8Pt-00000006y6g-0zBq;
	Thu, 20 Nov 2025 17:25:57 +0000
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
Subject: [PATCH v4 14/49] KVM: arm64: GICv3: Extract LR computing primitive
Date: Thu, 20 Nov 2025 17:25:04 +0000
Message-ID: <20251120172540.2267180-15-maz@kernel.org>
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

Split vgic_v3_populate_lr() into two, so that we have another
primitive that computes the LR from a vgic_irq, but doesn't
update anything in the shadow structure.

Tested-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-v3.c | 49 +++++++++++++++++++++++------------
 1 file changed, 32 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 6b7d7b4048f03..bcce7f35a6d67 100644
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


