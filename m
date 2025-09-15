Return-Path: <kvm+bounces-57557-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B06CB578D4
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 13:46:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AECA51884DD1
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 11:46:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FAE43019D9;
	Mon, 15 Sep 2025 11:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mD4vLh9c"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C74953002BF;
	Mon, 15 Sep 2025 11:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757936698; cv=none; b=nsYNdGR5oRMpu/NhIjpw9qPyhlLHIiomELRR4LDfR/i1qIf5OXAgaZSod8yon83fWAvfftkeqCbStJZyQW8Py19DV6UMRX7QFsM2tLvUg6LytGIpUOFMbOY/5OZl+iDVgyZAPV3dtgWpFOI1KJMGu6JdqVRJGtyG3sNZjbvzcac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757936698; c=relaxed/simple;
	bh=DmksNS3oXy1k1tzC02cPhS5A9PN6S9jc0qj047HiH4I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Da5vvrgqDVz/umysawS5jo2BWBvfeJPaccolE158Oum9tK3mHggN18SUUwKOldHBEaCFHw0m6pnBg7lKcSH9uy/Cw9StXnWIN1N258kX7NSrya3RSQhgMF+2/OPUIHXEMT6cdg2kmOcO78xZ2YzwZVg/o2uOYzDFWcpa4QxdajU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mD4vLh9c; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5A3EC4CEFF;
	Mon, 15 Sep 2025 11:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757936698;
	bh=DmksNS3oXy1k1tzC02cPhS5A9PN6S9jc0qj047HiH4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mD4vLh9cgv0AFMrlRuWP+GykJrQpwlAFEpgnLDU5NDLCxZUN3JvdYjdGrHI65GTad
	 4Jq2tGNxS2ZPAsn9sYSzpEBvZQXl5mEsXO+0BkJtGAGrQCzFkf2MX1LGEDzTXvYcfc
	 8wonRfkm7RiC518qAzDD57FGUO5gzEYAVDeFYnrfBw++a70zRtyqUqzIhCb4QYhGP9
	 E2jtqGsTMUaThqzmFU6d6+XbUsemsIz1UOosDzPVg/dYIT1btw6oJbmt+EF8xVX3Pr
	 truEYK2sksRWL8bkFuQcxMAV1wueqKndcd4PyPoTaAuxIDNTautPfY0CNCEAu81u1y
	 vBgqD1zMi5Qvg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1uy7dg-00000006MDw-3jJs;
	Mon, 15 Sep 2025 11:44:56 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 10/16] KVM: arm64: Allow use of S1 PTW for non-NV vcpus
Date: Mon, 15 Sep 2025 12:44:45 +0100
Message-Id: <20250915114451.660351-11-maz@kernel.org>
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

As we are about to use the S1 PTW in non-NV contexts, we must make
sure that we don't evaluate the EL2 state when dealing with the EL1&0
translation regime.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/at.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index 1230907d0aa0a..4f6686f59d1c4 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -108,8 +108,9 @@ static bool s1pie_enabled(struct kvm_vcpu *vcpu, enum trans_regime regime)
 	case TR_EL20:
 		return vcpu_read_sys_reg(vcpu, TCR2_EL2) & TCR2_EL2_PIE;
 	case TR_EL10:
-		return  (__vcpu_sys_reg(vcpu, HCRX_EL2) & HCRX_EL2_TCR2En) &&
-			(__vcpu_sys_reg(vcpu, TCR2_EL1) & TCR2_EL1_PIE);
+		return ((!vcpu_has_nv(vcpu) ||
+			 (__vcpu_sys_reg(vcpu, HCRX_EL2) & HCRX_EL2_TCR2En)) &&
+			(__vcpu_sys_reg(vcpu, TCR2_EL1) & TCR2_EL1_PIE));
 	default:
 		BUG();
 	}
@@ -132,7 +133,8 @@ static void compute_s1poe(struct kvm_vcpu *vcpu, struct s1_walk_info *wi)
 		wi->e0poe = (wi->regime == TR_EL20) && (val & TCR2_EL2_E0POE);
 		break;
 	case TR_EL10:
-		if (__vcpu_sys_reg(vcpu, HCRX_EL2) & HCRX_EL2_TCR2En) {
+		if (vcpu_has_nv(vcpu) &&
+		    !(__vcpu_sys_reg(vcpu, HCRX_EL2) & HCRX_EL2_TCR2En)) {
 			wi->poe = wi->e0poe = false;
 			return;
 		}
@@ -150,11 +152,16 @@ static int setup_s1_walk(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 	unsigned int stride, x;
 	bool va55, tbi, lva;
 
-	hcr = __vcpu_sys_reg(vcpu, HCR_EL2);
-
 	va55 = va & BIT(55);
 
-	wi->s2 = wi->regime == TR_EL10 && (hcr & (HCR_VM | HCR_DC));
+	if (vcpu_has_nv(vcpu)) {
+		hcr = __vcpu_sys_reg(vcpu, HCR_EL2);
+		wi->s2 = wi->regime == TR_EL10 && (hcr & (HCR_VM | HCR_DC));
+	} else {
+		WARN_ON_ONCE(wi->regime != TR_EL10);
+		wi->s2 = false;
+		hcr = 0;
+	}
 
 	switch (wi->regime) {
 	case TR_EL10:
@@ -851,7 +858,7 @@ static u64 compute_par_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 		par  = SYS_PAR_EL1_NSE;
 		par |= wr->pa & GENMASK_ULL(52, 12);
 
-		if (wi->regime == TR_EL10 &&
+		if (wi->regime == TR_EL10 && vcpu_has_nv(vcpu) &&
 		    (__vcpu_sys_reg(vcpu, HCR_EL2) & HCR_DC)) {
 			par |= FIELD_PREP(SYS_PAR_EL1_ATTR,
 					  MEMATTR(WbRaWa, WbRaWa));
-- 
2.39.2


