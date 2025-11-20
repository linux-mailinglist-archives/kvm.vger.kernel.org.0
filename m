Return-Path: <kvm+bounces-63939-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 61BF8C75B9C
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 18:37:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 3D96B4E1794
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 17:30:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8FB83A79A1;
	Thu, 20 Nov 2025 17:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FEPDQrVa"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 184AE3A1CF0;
	Thu, 20 Nov 2025 17:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763659562; cv=none; b=RtVmkHPWuXps8ILgc6JEvijSOXEbnkreYCAYqhZx+Nphnlm2Qfsiy0UKVDzMqOQjivCbgnTcX4zgUR+qnQg95uByMpDQyH52DqnarZX4LP2lutHC2DecCYQB5k0I1mDymSMCT2JFCS+MvLBJj7TNomn8zkSZpLthFMYw1FhIoIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763659562; c=relaxed/simple;
	bh=mCUOPrHWsZgohB19bFMPYL0p1tQzBnSsAdKuz7R2y/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u9QvdQpizAlb0d4mIyF73H38cprjgj/HzYkRoSEW4M5H6nDNRTSliyvGDUrW+PfwmBY23sV5Jx8b2CRaZcS16b1HDph+6JTCgVT7HXU+TIPf4sRUuiF2OUv6XZ6TV1y5kYLptyKnj+n6r+F4+Gn6QyPO8RG8IdhtQS/16N+4EjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FEPDQrVa; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84967C116C6;
	Thu, 20 Nov 2025 17:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763659561;
	bh=mCUOPrHWsZgohB19bFMPYL0p1tQzBnSsAdKuz7R2y/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FEPDQrVauUkMMHNLlUK8x44kXa+Y9QaLHWuA/TrJAce66E+KPuouXd/FT/GGlBoeu
	 8JMPGZ5DDoePMp16iK+Nf9flaNRFEdt/F8iwR+vVhg8fy8QM3gfG7YuENgr9Rdpr0D
	 A9Vm7XxmE8V2tdHgyqvBXC6IraJLU+FqIHfHV1tpq/fcdVx6YOcEhJO9NmGmG45ckk
	 0RfHNFTNuLVNp4myJEO2r4IKdl+jwAaC+NfbYRgNnvl9vTxIlGmC6dM+HJxEq2IJtD
	 PsuKQK43OCAxbvRueHOIVVnECw1MteJ6mjqCzOOX2tyvaaLoQVs8zcZTNej+aDm4Cm
	 xvds7A7tTz0OQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vM8Pv-00000006y6g-2vNt;
	Thu, 20 Nov 2025 17:25:59 +0000
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
Subject: [PATCH v4 24/49] KVM: arm64: Invert ap_list sorting to push active interrupts out
Date: Thu, 20 Nov 2025 17:25:14 +0000
Message-ID: <20251120172540.2267180-25-maz@kernel.org>
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

Having established that pending interrupts should have priority
to be moved into the LRs over the active interrupts, implement this
in the ap_list sorting.

Tested-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic.c | 27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 004010104659a..c7a5454ac4c9f 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -270,10 +270,7 @@ struct kvm_vcpu *vgic_target_oracle(struct vgic_irq *irq)
  * well, the first items in the list being the first things populated in the
  * LRs.
  *
- * A hard rule is that active interrupts can never be pushed out of the LRs
- * (and therefore take priority) since we cannot reliably trap on deactivation
- * of IRQs and therefore they have to be present in the LRs.
- *
+ * Pending, non-active interrupts must be placed at the head of the list.
  * Otherwise things should be sorted by the priority field and the GIC
  * hardware support will take care of preemption of priority groups etc.
  *
@@ -298,21 +295,21 @@ static int vgic_irq_cmp(void *priv, const struct list_head *a,
 	raw_spin_lock(&irqa->irq_lock);
 	raw_spin_lock_nested(&irqb->irq_lock, SINGLE_DEPTH_NESTING);
 
-	if (irqa->active || irqb->active) {
-		ret = (int)irqb->active - (int)irqa->active;
-		goto out;
-	}
+	penda = irqa->enabled && irq_is_pending(irqa) && !irqa->active;
+	pendb = irqb->enabled && irq_is_pending(irqb) && !irqb->active;
 
-	penda = irqa->enabled && irq_is_pending(irqa);
-	pendb = irqb->enabled && irq_is_pending(irqb);
+	ret = (int)pendb - (int)penda;
+	if (ret)
+		goto out;
 
-	if (!penda || !pendb) {
-		ret = (int)pendb - (int)penda;
+	/* Both pending and enabled, sort by priority (lower number first) */
+	ret = (int)irqa->priority - (int)irqb->priority;
+	if (ret)
 		goto out;
-	}
 
-	/* Both pending and enabled, sort by priority */
-	ret = irqa->priority - irqb->priority;
+	/* Finally, HW bit active interrupts have priority over non-HW ones */
+	ret = (int)irqb->hw - (int)irqa->hw;
+
 out:
 	raw_spin_unlock(&irqb->irq_lock);
 	raw_spin_unlock(&irqa->irq_lock);
-- 
2.47.3


