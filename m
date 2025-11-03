Return-Path: <kvm+bounces-61872-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C414C2D4E1
	for <lists+kvm@lfdr.de>; Mon, 03 Nov 2025 17:59:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1D9A2189C5A2
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 16:58:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A951E321F3E;
	Mon,  3 Nov 2025 16:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aOCuFx2E"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 313AB31E0E5;
	Mon,  3 Nov 2025 16:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762188930; cv=none; b=duGn/g6VQe+TosygLm66MY8nuAXWKrEvN2f4+Sen6PHvKkFWRcAB9944jLic0ctI3/iqzZKhuYTGVRNRhYrT21VG/gHJOboERxzTosO8JKF3fAA8/BUxn+mfEgbvRsR6WZlOuhEwdpXZN/ER5yKj/MyIYDNuMYft3uPAZzTL2W0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762188930; c=relaxed/simple;
	bh=FMwu06lK7Q6CryDZ52WbXhfFTuUdJV55nVDRrDJIZtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r8U0OAPCBmcTnGPinvKBRre6dkfklL2XP1u7ZgpW4ACmZCuGK6vFyLVlOvZdWw3XdefeCeoIb2opOMc/8Kuk9HraQcr7AWGxHlv/OGY6gjYzrvoasmLS2va3QdWZoa33UhGW02Ck/Zw2YUhRwvEtbZqL8gL4lDNMmVqV7cm/zos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aOCuFx2E; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E7C4C19421;
	Mon,  3 Nov 2025 16:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762188930;
	bh=FMwu06lK7Q6CryDZ52WbXhfFTuUdJV55nVDRrDJIZtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aOCuFx2EDzly2p88N1IsrJeEr6bhP8mfVtXrKV3suAEZgKv2GwgGLCQJzxr2OfAqr
	 pC55uhIKOHmCE16uI24k3AWfykkKVaiQJkMHrZUM+SxFxjV3qIuCPSfCnAjIAK6B5i
	 D74dcum93yaTo/pa8sRNtHQ6vxXp9uSMEIs5h+0tv89ZvCFniuh/tUBHGRZh2cFC2/
	 4bgDrQ/nAUN3beZiQOVYLlzVHU0dXtzRrM/NCHPf4iYZ9HPoPAqWyLaZhepEZc4MFc
	 inn9hvnWCHhK4vViFrRJsMWm4qKZw2/eF3SEBKiyQKG86YMYVwX0vTa+dx8xcmTeAe
	 8ab8KR1L5iwug==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vFxq4-000000021VN-1BmN;
	Mon, 03 Nov 2025 16:55:28 +0000
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
Subject: [PATCH 15/33] KVM: arm64: GICv2: Decouple GICH_HCR programming from LRs being loaded
Date: Mon,  3 Nov 2025 16:54:59 +0000
Message-ID: <20251103165517.2960148-16-maz@kernel.org>
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

Not programming GICH_HCR while no LRs are populated is a bit
of an issue, as we otherwise don't see any maintenance interrupt
when the guest interacts with the LRs.

Decouple the two and always program the control register, even when
we don't have to touch the LRs.

This is very similar to what we are already doing for GICv3.

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


