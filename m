Return-Path: <kvm+bounces-33950-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D91889F4D92
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 15:24:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9AEC5188CCB8
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 14:24:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 410331F7076;
	Tue, 17 Dec 2024 14:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c2FKzFy/"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB181F63D4;
	Tue, 17 Dec 2024 14:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734445408; cv=none; b=KsWzHsohPC0T5+oPNWsD5LmlRHVXyCNPfFM7aIpg8E+HsJ8CrQ955b2wZsxK7dhF0Cml9ECOXYc3IlV1Q7PpxIGytyrSM7zbK+vXt++5rSfFfaJcOG/Xz/wFiU5VlXjpu/zIj3814S0rcPIhPN6fcplyvnObgVla2UlgWQ0pUYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734445408; c=relaxed/simple;
	bh=qUpHIbiQuhU1+4N8+i0jJ8LE2+QbS+HIXdOvz3fZ3rY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=E5JzmKGK99Q2Srvk9nZ+ji4EkSTmaWjQre/urFOIGREgx9gW2aAESJY4gxO9fMHxW8aJmdjdhfFAgXoY78Mnpt2peXMsRwE8n9r4QnRId4FyVTNu2T69HYWNXhygyETgMeme4ULDzvEoeBD9H6KnaKJqdRfvBtPI5HUdPDMUixc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c2FKzFy/; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBA43C4CEDE;
	Tue, 17 Dec 2024 14:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734445408;
	bh=qUpHIbiQuhU1+4N8+i0jJ8LE2+QbS+HIXdOvz3fZ3rY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c2FKzFy/GHc4j1zsDmUE8iu21kR7SsTBcTqLJPMgNBqdnSx8klfhtVFMxWHmfpat9
	 d+RVllfg17xCuHpMwvlvyjGmiMV34XaazK9bzcP0ByBnyBgwxyESija1d5bmuzcE/B
	 lFJW0R700+buV372Qod2p35IOQ035ivAVhC5glGShmCQ0QVXc6m607+YUQwEfFl77k
	 E17Q8F0zcQX0I0OT4swEj1X5lmdQcn85vHaA4+tKVk/kzrb6jWQR7YL71boL2SeLxg
	 U6xSEAuHLSeQxvPYIkNUL00YkNKaYjSrg2PrRCq9ObdogR/YVXM81AEFzh6K8nMCqG
	 QdWEqNrO3Ojeg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tNYTu-004aJx-5g;
	Tue, 17 Dec 2024 14:23:26 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Chase Conklin <chase.conklin@arm.com>,
	Eric Auger <eauger@redhat.com>
Subject: [PATCH v2 08/12] KVM: arm64: nv: Add trap routing for CNTHCTL_EL2.EL1{NVPCT,NVVCT,TVT,TVCT}
Date: Tue, 17 Dec 2024 14:23:16 +0000
Message-Id: <20241217142321.763801-9-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241217142321.763801-1-maz@kernel.org>
References: <20241217142321.763801-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, andersson@kernel.org, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, chase.conklin@arm.com, eauger@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

For completeness, fun, and cerebral meltdown, add the virtualisation
related traps to the counter and timers.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/emulate-nested.c | 58 +++++++++++++++++++++++++++++++--
 1 file changed, 56 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 1ffbfd1c3cf2e..03d21044c41f5 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -89,6 +89,9 @@ enum cgt_group_id {
 	CGT_HCRX_EnFPM,
 	CGT_HCRX_TCR2En,
 
+	CGT_CNTHCTL_EL1TVT,
+	CGT_CNTHCTL_EL1TVCT,
+
 	CGT_ICH_HCR_TC,
 	CGT_ICH_HCR_TALL0,
 	CGT_ICH_HCR_TALL1,
@@ -124,6 +127,8 @@ enum cgt_group_id {
 	__COMPLEX_CONDITIONS__,
 	CGT_CNTHCTL_EL1PCTEN = __COMPLEX_CONDITIONS__,
 	CGT_CNTHCTL_EL1PTEN,
+	CGT_CNTHCTL_EL1NVPCT,
+	CGT_CNTHCTL_EL1NVVCT,
 
 	CGT_CPTR_TTA,
 	CGT_MDCR_HPMN,
@@ -393,6 +398,18 @@ static const struct trap_bits coarse_trap_bits[] = {
 		.mask		= HCRX_EL2_TCR2En,
 		.behaviour	= BEHAVE_FORWARD_RW,
 	},
+	[CGT_CNTHCTL_EL1TVT] = {
+		.index		= CNTHCTL_EL2,
+		.value		= CNTHCTL_EL1TVT,
+		.mask		= CNTHCTL_EL1TVT,
+		.behaviour	= BEHAVE_FORWARD_RW,
+	},
+	[CGT_CNTHCTL_EL1TVCT] = {
+		.index		= CNTHCTL_EL2,
+		.value		= CNTHCTL_EL1TVCT,
+		.mask		= CNTHCTL_EL1TVCT,
+		.behaviour	= BEHAVE_FORWARD_READ,
+	},
 	[CGT_ICH_HCR_TC] = {
 		.index		= ICH_HCR_EL2,
 		.value		= ICH_HCR_TC,
@@ -487,6 +504,32 @@ static enum trap_behaviour check_cnthctl_el1pten(struct kvm_vcpu *vcpu)
 	return BEHAVE_FORWARD_RW;
 }
 
+static bool is_nested_nv2_guest(struct kvm_vcpu *vcpu)
+{
+	u64 val;
+
+	val = __vcpu_sys_reg(vcpu, HCR_EL2);
+	return ((val & (HCR_E2H | HCR_TGE | HCR_NV2 | HCR_NV1 | HCR_NV)) == (HCR_E2H | HCR_NV2 | HCR_NV));
+}
+
+static enum trap_behaviour check_cnthctl_el1nvpct(struct kvm_vcpu *vcpu)
+{
+	if (!is_nested_nv2_guest(vcpu) ||
+	    !(__vcpu_sys_reg(vcpu, CNTHCTL_EL2) & CNTHCTL_EL1NVPCT))
+		return BEHAVE_HANDLE_LOCALLY;
+
+	return BEHAVE_FORWARD_RW;
+}
+
+static enum trap_behaviour check_cnthctl_el1nvvct(struct kvm_vcpu *vcpu)
+{
+	if (!is_nested_nv2_guest(vcpu) ||
+	    !(__vcpu_sys_reg(vcpu, CNTHCTL_EL2) & CNTHCTL_EL1NVVCT))
+		return BEHAVE_HANDLE_LOCALLY;
+
+	return BEHAVE_FORWARD_RW;
+}
+
 static enum trap_behaviour check_cptr_tta(struct kvm_vcpu *vcpu)
 {
 	u64 val = __vcpu_sys_reg(vcpu, CPTR_EL2);
@@ -534,6 +577,8 @@ static enum trap_behaviour check_mdcr_hpmn(struct kvm_vcpu *vcpu)
 static const complex_condition_check ccc[] = {
 	CCC(CGT_CNTHCTL_EL1PCTEN, check_cnthctl_el1pcten),
 	CCC(CGT_CNTHCTL_EL1PTEN, check_cnthctl_el1pten),
+	CCC(CGT_CNTHCTL_EL1NVPCT, check_cnthctl_el1nvpct),
+	CCC(CGT_CNTHCTL_EL1NVVCT, check_cnthctl_el1nvvct),
 	CCC(CGT_CPTR_TTA, check_cptr_tta),
 	CCC(CGT_MDCR_HPMN, check_mdcr_hpmn),
 };
@@ -850,11 +895,15 @@ static const struct encoding_to_trap_config encoding_to_cgt[] __initconst = {
 		      SYS_CNTHP_CVAL_EL2, CGT_HCR_NV),
 	SR_RANGE_TRAP(SYS_CNTHV_TVAL_EL2,
 		      SYS_CNTHV_CVAL_EL2, CGT_HCR_NV),
-	/* All _EL02, _EL12 registers */
+	/* All _EL02, _EL12 registers up to CNTKCTL_EL12*/
 	SR_RANGE_TRAP(sys_reg(3, 5, 0, 0, 0),
 		      sys_reg(3, 5, 10, 15, 7), CGT_HCR_NV),
 	SR_RANGE_TRAP(sys_reg(3, 5, 12, 0, 0),
-		      sys_reg(3, 5, 14, 15, 7), CGT_HCR_NV),
+		      sys_reg(3, 5, 14, 1, 0), CGT_HCR_NV),
+	SR_TRAP(SYS_CNTP_CTL_EL02,	CGT_CNTHCTL_EL1NVPCT),
+	SR_TRAP(SYS_CNTP_CVAL_EL02,	CGT_CNTHCTL_EL1NVPCT),
+	SR_TRAP(SYS_CNTV_CTL_EL02,	CGT_CNTHCTL_EL1NVVCT),
+	SR_TRAP(SYS_CNTV_CVAL_EL02,	CGT_CNTHCTL_EL1NVVCT),
 	SR_TRAP(OP_AT_S1E2R,		CGT_HCR_NV),
 	SR_TRAP(OP_AT_S1E2W,		CGT_HCR_NV),
 	SR_TRAP(OP_AT_S12E1R,		CGT_HCR_NV),
@@ -1184,6 +1233,11 @@ static const struct encoding_to_trap_config encoding_to_cgt[] __initconst = {
 	SR_TRAP(SYS_CNTP_CTL_EL0,	CGT_CNTHCTL_EL1PTEN),
 	SR_TRAP(SYS_CNTPCT_EL0,		CGT_CNTHCTL_EL1PCTEN),
 	SR_TRAP(SYS_CNTPCTSS_EL0,	CGT_CNTHCTL_EL1PCTEN),
+	SR_TRAP(SYS_CNTV_TVAL_EL0,	CGT_CNTHCTL_EL1TVT),
+	SR_TRAP(SYS_CNTV_CVAL_EL0,	CGT_CNTHCTL_EL1TVT),
+	SR_TRAP(SYS_CNTV_CTL_EL0,	CGT_CNTHCTL_EL1TVT),
+	SR_TRAP(SYS_CNTVCT_EL0,		CGT_CNTHCTL_EL1TVCT),
+	SR_TRAP(SYS_CNTVCTSS_EL0,	CGT_CNTHCTL_EL1TVCT),
 	SR_TRAP(SYS_FPMR,		CGT_HCRX_EnFPM),
 	/*
 	 * IMPDEF choice:
-- 
2.39.2


