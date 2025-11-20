Return-Path: <kvm+bounces-63926-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 33617C75B60
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 18:35:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 9E9C2363A13
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 17:29:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82D64371A33;
	Thu, 20 Nov 2025 17:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r/yz4Tv/"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A41436CE09;
	Thu, 20 Nov 2025 17:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763659558; cv=none; b=RZgZoPDrWA/FsPTO90/qswfr2ulJMeLMun0n8uxMCvvW8eGdgD7w/3v866mFr6oFwHJaP/tzA8AKvCNE2IDpHsKdcjaVtJoKjiGN96ZmP8A/gCEtJwBAhNsMLfYQXPUTCPltzeLjQkY8m3I4Y8qp+RjLI08qa/q2Kcrsg9nTbE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763659558; c=relaxed/simple;
	bh=yYpe3ZiXdu0kQ382PoQuTzOmEcqd+Y4/E7xAIiyvr0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=psQ+W+5KmUedV+2nFAQeolM6NCfbFv1LuIaronPDNtwBiy4wf+7r+swwBsqkBYwuNRCgD9YkNSRoQ+deCCEtP/EXYjVedV7a3qqRZTn0vYdIAEUogaSoloZOlAkyJPZkThzs91HSxGNTXipSf8G1HgUHjz+KjUPVB8Ggs6XFlfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r/yz4Tv/; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CCE5C116C6;
	Thu, 20 Nov 2025 17:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763659558;
	bh=yYpe3ZiXdu0kQ382PoQuTzOmEcqd+Y4/E7xAIiyvr0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r/yz4Tv/3FTYweByKSMq3BQxadKiZ7enrNxDz8jMyBdoJf5NUNCpg8+Okrf1Cfnrj
	 l83DYxc836/AfAd0Ep12VbkhfTGHPhOrDa3EipNWSXvrhBN/o/ifoEc49SPUziXnGE
	 /Q9H1tAvgmmvuTjXO62BHo0Caj/KaVNK/eQa9EdiQuOCVNke/Jqyxc0KjzV1GEuiTi
	 jpwHSKaJeoj2L4Sn+KWYkMqhcssJ7pHKdXaBd8Fjz5f+vdpL6v4DuvNhv/EtUpVrfc
	 GZUSZGFma4xTyS0mk5AKE0MCaH9Hhc1KC7iKbaJdCRX5Gi1EwwY9wtfKQtNZ9TP1IW
	 dLh2Eh/YLWe6Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vM8Ps-00000006y6g-319A;
	Thu, 20 Nov 2025 17:25:56 +0000
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
Subject: [PATCH v4 12/49] KVM: arm64: GICv3: Decouple ICH_HCR_EL2 programming from LRs
Date: Thu, 20 Nov 2025 17:25:02 +0000
Message-ID: <20251120172540.2267180-13-maz@kernel.org>
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

Not programming ICH_HCR_EL2 while no LRs are populated is a bit
of an issue, as we otherwise don't see any maintenance interrupt
when the guest interacts with the LRs.

Decouple the two and always program the control register, even when
we don't have to touch the LRs.

Tested-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/vgic-v3-sr.c | 26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
index 9bfcbfd91118a..2509b52bbd629 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -219,20 +219,12 @@ void __vgic_v3_save_state(struct vgic_v3_cpu_if *cpu_if)
 		}
 	}
 
-	if (used_lrs || cpu_if->its_vpe.its_vm) {
+	if (used_lrs) {
 		int i;
 		u32 elrsr;
 
 		elrsr = read_gicreg(ICH_ELRSR_EL2);
 
-		if (cpu_if->vgic_hcr & ICH_HCR_EL2_LRENPIE) {
-			u64 val = read_gicreg(ICH_HCR_EL2);
-			cpu_if->vgic_hcr &= ~ICH_HCR_EL2_EOIcount;
-			cpu_if->vgic_hcr |= val & ICH_HCR_EL2_EOIcount;
-		}
-
-		write_gicreg(0, ICH_HCR_EL2);
-
 		for (i = 0; i < used_lrs; i++) {
 			if (elrsr & (1 << i))
 				cpu_if->vgic_lr[i] &= ~ICH_LR_STATE;
@@ -242,6 +234,14 @@ void __vgic_v3_save_state(struct vgic_v3_cpu_if *cpu_if)
 			__gic_v3_set_lr(0, i);
 		}
 	}
+
+	if (cpu_if->vgic_hcr & ICH_HCR_EL2_LRENPIE) {
+		u64 val = read_gicreg(ICH_HCR_EL2);
+		cpu_if->vgic_hcr &= ~ICH_HCR_EL2_EOIcount;
+		cpu_if->vgic_hcr |= val & ICH_HCR_EL2_EOIcount;
+	}
+
+	write_gicreg(0, ICH_HCR_EL2);
 }
 
 void __vgic_v3_restore_state(struct vgic_v3_cpu_if *cpu_if)
@@ -249,12 +249,10 @@ void __vgic_v3_restore_state(struct vgic_v3_cpu_if *cpu_if)
 	u64 used_lrs = cpu_if->used_lrs;
 	int i;
 
-	if (used_lrs || cpu_if->its_vpe.its_vm) {
-		write_gicreg(compute_ich_hcr(cpu_if), ICH_HCR_EL2);
+	write_gicreg(compute_ich_hcr(cpu_if), ICH_HCR_EL2);
 
-		for (i = 0; i < used_lrs; i++)
-			__gic_v3_set_lr(cpu_if->vgic_lr[i], i);
-	}
+	for (i = 0; i < used_lrs; i++)
+		__gic_v3_set_lr(cpu_if->vgic_lr[i], i);
 
 	/*
 	 * Ensure that writes to the LRs, and on non-VHE systems ensure that
-- 
2.47.3


