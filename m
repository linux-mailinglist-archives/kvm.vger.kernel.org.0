Return-Path: <kvm+bounces-57552-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B0CEFB578CE
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 13:46:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 103D81A273C8
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 11:45:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F40CB3002DE;
	Mon, 15 Sep 2025 11:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sYoxatmm"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D12432FF159;
	Mon, 15 Sep 2025 11:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757936697; cv=none; b=SJDITza8O7Ha/hvsQ87d/qz+3SdYi5cPXdsoEX6zMWOxwMiPomnWlkaIu5uTDv1xed3zND4VCIdBG4/kYF+jQywrWEqB5VQBSwvk4QtS/ujpdv6cZqheQgHCQhhPLWh13XGWWuZSLX4qlCFmWJvGSgFEdIwWyVgPDmAxrR2Btwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757936697; c=relaxed/simple;
	bh=2RbKdH4yDCd/pu6P2Shrhn2Mw55zuipHMBtAnz87VwY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=llzo3ZQQf5/GZHVu+pHVxrpof8qhl6oRTNMht87N04/qL+r8ubG9yjgRIeANBXzpkmKNbapTei4+I6gjFPV7aozWxDhCO57e3MHjzmbRnn1t2hrtpFEyew1E3MLFcbJ3z5h+3cN/h2iWPaHPMxUlScp7WTAYqljvICAt0wUr2ZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sYoxatmm; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B425EC4CEF5;
	Mon, 15 Sep 2025 11:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757936697;
	bh=2RbKdH4yDCd/pu6P2Shrhn2Mw55zuipHMBtAnz87VwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sYoxatmmSO6O4r3dXAL73a9cIW4maL1xTWDtEw4l9DnAUM3eIqlNgzyUHB1g2HQsM
	 e2V3Fuj+LZytfpqEihFw6Hr6mf1HAYbRK45Oca17mAFPNmvExRdivmdzykQkhiKUPj
	 wbnqWLvQSQm7hGYAr+VgtIH6H8dmbKXNTTYZGr9/j41+ypCPRUpfZguLssG5PtKb7K
	 A/afukqmU6Tg0Y+qZXEDUYqO0UYASZzsFJ2XnEGqTl72UpXcYyrsLwX50P7VID+coN
	 kGAoK/8W+iYJ8PbB/sr18UNsXXnuf51jGD496jgNVviAUSzX2PBxWyD2JFj2NOVyL+
	 YHeBvnDMHLUJg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1uy7df-00000006MDw-3nzy;
	Mon, 15 Sep 2025 11:44:55 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 05/16] KVM: arm64: Pass the walk_info structure to compute_par_s1()
Date: Mon, 15 Sep 2025 12:44:40 +0100
Message-Id: <20250915114451.660351-6-maz@kernel.org>
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

Instead of just passing the translation regime, pass the full
walk_info structure to compute_par_s1(). This will help further
chamges that will require it.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/at.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index bdb2c3e22f248..acf6a5d497773 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -807,8 +807,8 @@ static u64 compute_par_s12(struct kvm_vcpu *vcpu, u64 s1_par,
 	return par;
 }
 
-static u64 compute_par_s1(struct kvm_vcpu *vcpu, struct s1_walk_result *wr,
-			  enum trans_regime regime)
+static u64 compute_par_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
+			  struct s1_walk_result *wr)
 {
 	u64 par;
 
@@ -823,7 +823,7 @@ static u64 compute_par_s1(struct kvm_vcpu *vcpu, struct s1_walk_result *wr,
 		par  = SYS_PAR_EL1_NSE;
 		par |= wr->pa & GENMASK_ULL(47, 12);
 
-		if (regime == TR_EL10 &&
+		if (wi->regime == TR_EL10 &&
 		    (__vcpu_sys_reg(vcpu, HCR_EL2) & HCR_DC)) {
 			par |= FIELD_PREP(SYS_PAR_EL1_ATTR,
 					  MEMATTR(WbRaWa, WbRaWa));
@@ -838,14 +838,14 @@ static u64 compute_par_s1(struct kvm_vcpu *vcpu, struct s1_walk_result *wr,
 
 		par  = SYS_PAR_EL1_NSE;
 
-		mair = (regime == TR_EL10 ?
+		mair = (wi->regime == TR_EL10 ?
 			vcpu_read_sys_reg(vcpu, MAIR_EL1) :
 			vcpu_read_sys_reg(vcpu, MAIR_EL2));
 
 		mair >>= FIELD_GET(PTE_ATTRINDX_MASK, wr->desc) * 8;
 		mair &= 0xff;
 
-		sctlr = (regime == TR_EL10 ?
+		sctlr = (wi->regime == TR_EL10 ?
 			 vcpu_read_sys_reg(vcpu, SCTLR_EL1) :
 			 vcpu_read_sys_reg(vcpu, SCTLR_EL2));
 
@@ -1243,7 +1243,7 @@ static u64 handle_at_slow(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 		fail_s1_walk(&wr, ESR_ELx_FSC_PERM_L(wr.level), false);
 
 compute_par:
-	return compute_par_s1(vcpu, &wr, wi.regime);
+	return compute_par_s1(vcpu, &wi, &wr);
 }
 
 /*
-- 
2.39.2


