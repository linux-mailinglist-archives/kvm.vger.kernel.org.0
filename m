Return-Path: <kvm+bounces-57553-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CB49DB578D1
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 13:46:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AC8CF1A201C2
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 11:46:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0838830148D;
	Mon, 15 Sep 2025 11:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iGLKFNmr"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E9D2FFDCB;
	Mon, 15 Sep 2025 11:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757936698; cv=none; b=fKAELzMhmUAFaNQwxseHiptgAouERlGk70vyi+SE0tj6azgtUdsY5bTTY4a3kCZDndSECLUlKFykwoW71AKBl9NJ4908DixMMA2hanc80a6CMtChIHZ2AqUs2d9mYTPVW6wwlGe+mLBmk7SUarE3bl6fvW/59yj3dcr6NhFDMIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757936698; c=relaxed/simple;
	bh=YGO8iofCD9Klx/7xoZBjB3a2UwUyHWW5VkjpdU6mkSo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Kzx9WzUeAl6/dFBRacCqvpMXVURFVs7q0/clsEhqTXaciV59YdJrY3c+8vMDx4JhLVJXPqsuFonyHJ6YaVAtxGF6cgCxdTgIZ7x24qIR6M1ll2Qjv6HyVHgBcEEef3RnDoYB/mVqa8DkX38HGub4G1na18Zh4Pkcu+qW0DWIYdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iGLKFNmr; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4EB7C4CEF1;
	Mon, 15 Sep 2025 11:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757936697;
	bh=YGO8iofCD9Klx/7xoZBjB3a2UwUyHWW5VkjpdU6mkSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iGLKFNmrU69yTiktOfzRLU3kbWpFoVwhEwehBIh7gmmzau6EdVdpz9YxurBHkFDXh
	 KwYCgSexf7eMPgGmHDZoomfXhFntmNnFbugCGZGJtQxwCOOeEiPzJ2xdBGgHBdCEY/
	 z6Z9dSvtF92sLWsUZZsCb4CCCgrheQT4ha09MzMYuVHf3Ptp9C9cl5Q1COXsuybc8L
	 0IvdKqIfVEqL4UshJb97iAhiCr2bDQ+r57eBOIF9hI/ZJvawp+NDsh7Ozfwf4gbfEQ
	 Ue9I1b+f+OXVOw9XGbO+OUGEH/k0q21QY1ILGbL6B8z2943U4Xsu5LGDrKrtnMeUI/
	 E4nfOAVXl2UUw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1uy7df-00000006MDw-2ygY;
	Mon, 15 Sep 2025 11:44:55 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 04/16] KVM: arm64: Decouple output address from the PT descriptor
Date: Mon, 15 Sep 2025 12:44:39 +0100
Message-Id: <20250915114451.660351-5-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250915114451.660351-1-maz@kernel.org>
References: <20250915114451.660351-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Add a helper converting the descriptor into a nicely formed OA,
irrespective of the in-descriptor representation (< 52bit, LPA
or LPA2).

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/at.c | 30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index e02e467fc2ccd..bdb2c3e22f248 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -56,6 +56,29 @@ static bool has_52bit_pa(struct kvm_vcpu *vcpu, struct s1_walk_info *wi, u64 tcr
 	return (tcr & (wi->regime == TR_EL2 ? TCR_EL2_DS : TCR_DS));
 }
 
+static u64 desc_to_oa(struct s1_walk_info *wi, u64 desc)
+{
+	u64 addr;
+
+	if (!wi->pa52bit)
+		return desc & GENMASK_ULL(47, wi->pgshift);
+
+	switch (BIT(wi->pgshift)) {
+	case SZ_4K:
+	case SZ_16K:
+		addr = desc & GENMASK_ULL(49, wi->pgshift);
+		addr |= FIELD_GET(KVM_PTE_ADDR_51_50_LPA2, desc) << 50;
+		break;
+	case SZ_64K:
+	default:	    /* IMPDEF: treat any other value as 64k */
+		addr = desc & GENMASK_ULL(47, wi->pgshift);
+		addr |= FIELD_GET(KVM_PTE_ADDR_51_48, desc) << 48;
+		break;
+	}
+
+	return addr;
+}
+
 /* Return the translation regime that applies to an AT instruction */
 static enum trans_regime compute_translation_regime(struct kvm_vcpu *vcpu, u32 op)
 {
@@ -402,7 +425,7 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 			wr->PXNTable |= FIELD_GET(PMD_TABLE_PXN, desc);
 		}
 
-		baddr = desc & GENMASK_ULL(47, wi->pgshift);
+		baddr = desc_to_oa(wi, desc);
 
 		/* Check for out-of-range OA */
 		if (check_output_size(baddr, wi))
@@ -431,7 +454,8 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 			goto transfault;
 	}
 
-	if (check_output_size(desc & GENMASK(47, va_bottom), wi))
+	baddr = desc_to_oa(wi, desc);
+	if (check_output_size(baddr & GENMASK(52, va_bottom), wi))
 		goto addrsz;
 
 	if (!(desc & PTE_AF)) {
@@ -444,7 +468,7 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 	wr->failed = false;
 	wr->level = level;
 	wr->desc = desc;
-	wr->pa = desc & GENMASK(47, va_bottom);
+	wr->pa = baddr & GENMASK(52, va_bottom);
 	wr->pa |= va & GENMASK_ULL(va_bottom - 1, 0);
 
 	wr->nG = (wi->regime != TR_EL2) && (desc & PTE_NG);
-- 
2.39.2


