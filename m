Return-Path: <kvm+bounces-63930-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 6058FC75AD4
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 18:30:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by tor.lore.kernel.org (Postfix) with ESMTPS id D7E722C515
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 17:30:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0F7A374154;
	Thu, 20 Nov 2025 17:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FckTF/7V"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AE2B371A3B;
	Thu, 20 Nov 2025 17:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763659559; cv=none; b=DvDIFFXPwGwUJvsqHdcInFuofOtrDbfl0glTSYOHHPJRbjZrf9h3Cph+JKLMT0fJB3fsOjUojmlDJ+vz/p+itk3aK8t9u6dSxWalaccBLkx7SVVFIzHIcaKNwUCH7IlrhX7JXx2Pe2raWmFVXFvJ/k2OSIQatBXJonSAX1lEZqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763659559; c=relaxed/simple;
	bh=fEboDabzfdT1z+/aMTmm6yEOOvmNnX4iNfBHI1NhwLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vjl1hODX3+Nu6HsjVdr+pExOJkrMdF48apDevaHV+vA5dCuarqALS+rWecLr0/8xNR5sbdTbvzJlu3/446kbObD6LhULXNpwlXAp/7FfjTlatLdbwrvVjCGNF50gFggsUeZKZdIcfuznXSVomYDjUL0uSgEJNEGpcqjdKKH0Sk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FckTF/7V; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E3A8C116D0;
	Thu, 20 Nov 2025 17:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763659559;
	bh=fEboDabzfdT1z+/aMTmm6yEOOvmNnX4iNfBHI1NhwLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FckTF/7VWZ32XbP6p5wjpbKBSNwR/zOVRsK+IEGtbZ1gg+emwHMOr3MqK9p9Pz6c0
	 p/35HB6+UgmYtaJy7v6sP9XVRZcGeIH4WBB+Jdd+tAO8RD7HdT7hebDAH3mNyFsKnA
	 kq7H5L1wDCx2vFnIEI+q07WhjGTMLRhHZyy6hUqMxm18JEINhWS50NP4Yt+eB9h436
	 1k30DMduabELcCDBrmFHXf3iYoBQsLn6CgD67tHxgNUJTQw3Whs45qLnzwlrMGSBst
	 xJMOSERBHrsAFafPAJR88JIUE45VnvQ44HRuQaz66YIrYIlAPUlqshmPIlIrFpC6+r
	 uYPGaH86orTcQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vM8Pt-00000006y6g-33bK;
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
Subject: [PATCH v4 16/49] KVM: arm64: GICv2: Decouple GICH_HCR programming from LRs being loaded
Date: Thu, 20 Nov 2025 17:25:06 +0000
Message-ID: <20251120172540.2267180-17-maz@kernel.org>
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

Not programming GICH_HCR while no LRs are populated is a bit
of an issue, as we otherwise don't see any maintenance interrupt
when the guest interacts with the LRs.

Decouple the two and always program the control register, even when
we don't have to touch the LRs.

This is very similar to what we are already doing for GICv3.

Tested-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-v2.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v2.c b/arch/arm64/kvm/vgic/vgic-v2.c
index 5cfbe58983428..a0d803c5b08ae 100644
--- a/arch/arm64/kvm/vgic/vgic-v2.c
+++ b/arch/arm64/kvm/vgic/vgic-v2.c
@@ -430,22 +430,25 @@ static void save_lrs(struct kvm_vcpu *vcpu, void __iomem *base)
 
 void vgic_v2_save_state(struct kvm_vcpu *vcpu)
 {
+	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
 	void __iomem *base = kvm_vgic_global_state.vctrl_base;
 	u64 used_lrs = vcpu->arch.vgic_cpu.vgic_v2.used_lrs;
 
 	if (!base)
 		return;
 
-	if (used_lrs) {
-		if (vcpu->arch.vgic_cpu.vgic_v2.vgic_hcr & GICH_HCR_LRENPIE) {
-			u32 val = readl_relaxed(base + GICH_HCR);
 
-			vcpu->arch.vgic_cpu.vgic_v2.vgic_hcr &= ~GICH_HCR_EOICOUNT;
-			vcpu->arch.vgic_cpu.vgic_v2.vgic_hcr |= val & GICH_HCR_EOICOUNT;
-		}
+	if (used_lrs)
 		save_lrs(vcpu, base);
-		writel_relaxed(0, base + GICH_HCR);
+
+	if (cpu_if->vgic_hcr & GICH_HCR_LRENPIE) {
+		u32 val = readl_relaxed(base + GICH_HCR);
+
+		cpu_if->vgic_hcr &= ~GICH_HCR_EOICOUNT;
+		cpu_if->vgic_hcr |= val & GICH_HCR_EOICOUNT;
 	}
+
+	writel_relaxed(0, base + GICH_HCR);
 }
 
 void vgic_v2_restore_state(struct kvm_vcpu *vcpu)
@@ -458,13 +461,10 @@ void vgic_v2_restore_state(struct kvm_vcpu *vcpu)
 	if (!base)
 		return;
 
-	if (used_lrs) {
-		writel_relaxed(cpu_if->vgic_hcr, base + GICH_HCR);
-		for (i = 0; i < used_lrs; i++) {
-			writel_relaxed(cpu_if->vgic_lr[i],
-				       base + GICH_LR0 + (i * 4));
-		}
-	}
+	writel_relaxed(cpu_if->vgic_hcr, base + GICH_HCR);
+
+	for (i = 0; i < used_lrs; i++)
+		writel_relaxed(cpu_if->vgic_lr[i], base + GICH_LR0 + (i * 4));
 }
 
 void vgic_v2_load(struct kvm_vcpu *vcpu)
-- 
2.47.3


