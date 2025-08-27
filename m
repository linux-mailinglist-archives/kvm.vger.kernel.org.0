Return-Path: <kvm+bounces-55901-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 570BAB38783
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 18:12:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8BEFF7B8977
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 16:10:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDF1435AABF;
	Wed, 27 Aug 2025 16:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ali6INvB"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 923A5352FED;
	Wed, 27 Aug 2025 16:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756311050; cv=none; b=D0Yysh8nS8YvNZhnQMX1KlH11HRGDRPF7/aUNgJMWJmylmOx0RSvBtquqABdsWZ8O/55h7lA3KAJ1dyH3ObZHtV6rJS/fITyyPCYC9wAc86+T6vh6RlHfDByGgj310k7qmiHMvxSoOzuGYJnE8YlyM6/5CIR8BV+LGwung+hMuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756311050; c=relaxed/simple;
	bh=n2n6snPz5XhRY4UtuG7IAalJ4oYuX0+XTMNpi/fWpoA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CMKMNrMGplMk9CvPiRG7N5e1Qb1UQ4ZvLVWoQmakPC5fuHbsM5EiAxuai77QRVK0m60TgwSZepWPH7EKqGBeWga+sSy7OSOTz/L/TjmUcPMAy1SERvtyG96G5gu+JIs6eufHzJBgebPoJvlyWQh6JCCxYkxZ4y9MJXF4f+ZrgG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ali6INvB; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41CB1C4CEFC;
	Wed, 27 Aug 2025 16:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756311050;
	bh=n2n6snPz5XhRY4UtuG7IAalJ4oYuX0+XTMNpi/fWpoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ali6INvBOiD2S41wf+GWDgsqkbauWXeOOUZuDsEKNxp/z6BW1JggxBxxOeofFFqrP
	 9Hdog8L4HPKMe11NWTCcD0CI1gPSuZ4dXyEQtfrMJQuJZ6b+21YOpW+w6IbrADhlso
	 K7DOpzOOAYZJQ11FA9a9VjA3HDU3N4/DQmclIiERGtlUiXRHx2FVIS+QZS3E7N3BQn
	 3WWvIYEouh2yD0kv0Y8grT7CgACfA4r7FuJHucMpRt2sg0k9bCi+mYrYLNETEtT/d4
	 fnyPejcGKp7dtKWri6d6YMvb7mN5fbmekrShlyM8TE1FQkzH2veCpvFMdK/YZT1WjM
	 IPqm+s/1gwmbA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1urIjY-00000000yGc-249o;
	Wed, 27 Aug 2025 16:10:48 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 10/16] KVM: arm64: Allow use of S1 PTW for non-NV vcpus
Date: Wed, 27 Aug 2025 17:10:32 +0100
Message-Id: <20250827161039.938958-11-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250827161039.938958-1-maz@kernel.org>
References: <20250827161039.938958-1-maz@kernel.org>
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
index 3bc6cc00ab9a6..48406328b74e3 100644
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


