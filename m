Return-Path: <kvm+bounces-61883-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AF2EAC2D509
	for <lists+kvm@lfdr.de>; Mon, 03 Nov 2025 18:00:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 29D6B189BFEB
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 16:59:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02CB9326D5F;
	Mon,  3 Nov 2025 16:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jj0mzUeN"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C189324B23;
	Mon,  3 Nov 2025 16:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762188932; cv=none; b=hLDcdVSsQSYf9Jj3Q/g4yEPnrrzQdproU87M3cb333Lw00Fi4xtepU/3YSvJsqUVeUzAn4jx3INZpyWPgssTx+KvX08zEwK3hV6v4CjR+l7DjLgo8LiGex0j/bwiGMbd+EY1fbVXgcOcPDfG1zq1fPkxaXW88pi0Gm1KM2y9LM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762188932; c=relaxed/simple;
	bh=Ksllf4QLmgdsUpwCGY9LSpYWYzEnFPQKXe3yy4PN5mU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oYxni98lvvE2VraCkkJXklgj45cQdusTNOP2UlpPL3w18fzTAWvp7FTC/iEr2B8bHcsmFc8W/Df/KYqEMlEXkVPNJFN4Xy53ToGMpA3zeBjvld48G6uxqCyHlY6iTH6X6boJnyDSaSvFkt5pZrMEK7IJttg1PA1Ce8+jCs38bkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jj0mzUeN; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FD02C4CEE7;
	Mon,  3 Nov 2025 16:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762188932;
	bh=Ksllf4QLmgdsUpwCGY9LSpYWYzEnFPQKXe3yy4PN5mU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jj0mzUeNpCVIvienrf7new8E1injENLKMeUShmwFWj73Dz3uQwlQ2Fil62y8qWxjs
	 eDfmahHLzJGsHUrWab1xIeiihtKlKrOtWQEW9fBuImQNwyUO6T4UeYbj0b/Gp9T6eU
	 5MvPGbvs/7A7ssM6CJ7xgx8MvYN4Nam5m3dxy63q1QRAY7dGfKZvVRfQCVaH1hv0ml
	 kstpCFSewKYVeUYDuihhtmV/UQrcNtPwTjH3jO4lsdgx2/Lq1UNdhc9FSlGNuiBKb2
	 YaWns2EapYiMHHsPGzGBKNlJaJGn2gX7rvYqJZVgXvc2foETsy771L5LM+vW+rq/hW
	 lnBR1cwide1iA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vFxq6-000000021VN-1cXg;
	Mon, 03 Nov 2025 16:55:30 +0000
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
Subject: [PATCH 24/33] KVM: arm64: Use MI to detect groups being enabled/disabled
Date: Mon,  3 Nov 2025 16:55:08 +0000
Message-ID: <20251103165517.2960148-25-maz@kernel.org>
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

Add the maintenance interrupt to force an exit when the guest
enables/disables individual groups, so that we can resort the
ap_list accordingly.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-v2.c | 5 +++++
 arch/arm64/kvm/vgic/vgic-v3.c | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-v2.c b/arch/arm64/kvm/vgic/vgic-v2.c
index f53bc55288978..9d4702aec454b 100644
--- a/arch/arm64/kvm/vgic/vgic-v2.c
+++ b/arch/arm64/kvm/vgic/vgic-v2.c
@@ -39,6 +39,11 @@ void vgic_v2_configure_hcr(struct kvm_vcpu *vcpu,
 		cpuif->vgic_hcr |= GICH_HCR_LRENPIE;
 	if (irqs_outside_lrs(als))
 		cpuif->vgic_hcr |= GICH_HCR_UIE;
+
+	cpuif->vgic_hcr |= (cpuif->vgic_vmcr & GICH_VMCR_ENABLE_GRP0_MASK) ?
+		GICH_HCR_VGrp0DIE : GICH_HCR_VGrp0EIE;
+	cpuif->vgic_hcr |= (cpuif->vgic_vmcr & GICH_VMCR_ENABLE_GRP1_MASK) ?
+		GICH_HCR_VGrp1DIE : GICH_HCR_VGrp1EIE;
 }
 
 static bool lr_signals_eoi_mi(u32 lr_val)
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 79fa16c5344fb..e18b13b240492 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -36,6 +36,11 @@ void vgic_v3_configure_hcr(struct kvm_vcpu *vcpu,
 
 	if (!als->nr_sgi)
 		cpuif->vgic_hcr |= ICH_HCR_EL2_vSGIEOICount;
+
+	cpuif->vgic_hcr |= (cpuif->vgic_vmcr & ICH_VMCR_ENG0_MASK) ?
+		ICH_HCR_EL2_VGrp0DIE : ICH_HCR_EL2_VGrp0EIE;
+	cpuif->vgic_hcr |= (cpuif->vgic_vmcr & ICH_VMCR_ENG1_MASK) ?
+		ICH_HCR_EL2_VGrp1DIE : ICH_HCR_EL2_VGrp1EIE;
 }
 
 static bool lr_signals_eoi_mi(u64 lr_val)
-- 
2.47.3


