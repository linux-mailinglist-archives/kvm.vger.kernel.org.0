Return-Path: <kvm+bounces-19630-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EEB53907D60
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 22:20:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5E1CBB2403C
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 20:20:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2044A14A0AD;
	Thu, 13 Jun 2024 20:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pV2PYW6v"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F68913D53E
	for <kvm@vger.kernel.org>; Thu, 13 Jun 2024 20:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718309937; cv=none; b=g9f1iGSW4Cm2FKaV01Cfv18GiN2sNLDtGsx9TGFE7BcMXBsigehoMcla/9XWAtsUjGnb9PTY7KZPkVq+rrdspyS4RsF0WG3G4pmAcF2X0fhBEmKY5FjoXQ9TLPNvcKt+pM0qQDKfgcn1lwNVpG2tXEsCVSSidq3xksZ9BhJc2Xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718309937; c=relaxed/simple;
	bh=a/GKKXhvXev2mZGEZOfAVooelSVwD8ifXDIBALnLt6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ptymyIBM4mOXI5sTRAGhfDBWdaBfp9cZW+opUk/tg+XVgdfjOodx0LxszoRny5f85tHwOsPIt29CZI5CkoKCx+FBceHtc1CxVGw2SHaFjPvp/NzDcIIWCOL+hBpbw6K5LqbCt7uaYIx4VnD4TDZpzTavm4vRPBNhEGew5xGkjDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pV2PYW6v; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718309934;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xIavj6lFuI+JP6ACtD2mEVvAYjPXbU38kB0BHh1F2RM=;
	b=pV2PYW6vjyPMav+vT/Re3ub1SneySpv8r8oSgSl/1cuN3fDOuoDCDeGmMWCryT4OcrSrIg
	vvZd3qNRoE5k5jqBeF9FBmkZsyOT5ke/mQT52RGIHQBkxFV26ixUaTJn8zE9QEw8ltuYKm
	j4pB6Le5DvmD0Ew1Ruyd0/rT/jVJ89I=
X-Envelope-To: maz@kernel.org
X-Envelope-To: james.morse@arm.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: tabba@google.com
X-Envelope-To: oliver.upton@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvm@vger.kernel.org,
	Fuad Tabba <tabba@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 13/15] KVM: arm64: nv: Add trap description for CPTR_EL2
Date: Thu, 13 Jun 2024 20:17:54 +0000
Message-ID: <20240613201756.3258227-14-oliver.upton@linux.dev>
In-Reply-To: <20240613201756.3258227-1-oliver.upton@linux.dev>
References: <20240613201756.3258227-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Marc Zyngier <maz@kernel.org>

Add trap description for CPTR_EL2.{TCPAC,TAM,E0POE,TTA}.

TTA is a bit annoying as it changes location depending on E2H.
This forces us to add yet another "complex" trap condition.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/emulate-nested.c | 91 +++++++++++++++++++++++++++++++++
 1 file changed, 91 insertions(+)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 72d733c74a38..61e6b97c3e25 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -79,6 +79,10 @@ enum cgt_group_id {
 	CGT_MDCR_E2TB,
 	CGT_MDCR_TDCC,
 
+	CGT_CPACR_E0POE,
+	CGT_CPTR_TAM,
+	CGT_CPTR_TCPAC,
+
 	/*
 	 * Anything after this point is a combination of coarse trap
 	 * controls, which must all be evaluated to decide what to do.
@@ -106,6 +110,8 @@ enum cgt_group_id {
 	CGT_CNTHCTL_EL1PCTEN = __COMPLEX_CONDITIONS__,
 	CGT_CNTHCTL_EL1PTEN,
 
+	CGT_CPTR_TTA,
+
 	/* Must be last */
 	__NR_CGT_GROUP_IDS__
 };
@@ -345,6 +351,24 @@ static const struct trap_bits coarse_trap_bits[] = {
 		.mask		= MDCR_EL2_TDCC,
 		.behaviour	= BEHAVE_FORWARD_ANY,
 	},
+	[CGT_CPACR_E0POE] = {
+		.index		= CPTR_EL2,
+		.value		= CPACR_ELx_E0POE,
+		.mask		= CPACR_ELx_E0POE,
+		.behaviour	= BEHAVE_FORWARD_ANY,
+	},
+	[CGT_CPTR_TAM] = {
+		.index		= CPTR_EL2,
+		.value		= CPTR_EL2_TAM,
+		.mask		= CPTR_EL2_TAM,
+		.behaviour	= BEHAVE_FORWARD_ANY,
+	},
+	[CGT_CPTR_TCPAC] = {
+		.index		= CPTR_EL2,
+		.value		= CPTR_EL2_TCPAC,
+		.mask		= CPTR_EL2_TCPAC,
+		.behaviour	= BEHAVE_FORWARD_ANY,
+	},
 };
 
 #define MCB(id, ...)						\
@@ -410,12 +434,26 @@ static enum trap_behaviour check_cnthctl_el1pten(struct kvm_vcpu *vcpu)
 	return BEHAVE_FORWARD_ANY;
 }
 
+static enum trap_behaviour check_cptr_tta(struct kvm_vcpu *vcpu)
+{
+	u64 val = __vcpu_sys_reg(vcpu, CPTR_EL2);
+
+	if (!vcpu_el2_e2h_is_set(vcpu))
+		val = translate_cptr_el2_to_cpacr_el1(val);
+
+	if (val & CPACR_ELx_TTA)
+		return BEHAVE_FORWARD_ANY;
+
+	return BEHAVE_HANDLE_LOCALLY;
+}
+
 #define CCC(id, fn)				\
 	[id - __COMPLEX_CONDITIONS__] = fn
 
 static const complex_condition_check ccc[] = {
 	CCC(CGT_CNTHCTL_EL1PCTEN, check_cnthctl_el1pcten),
 	CCC(CGT_CNTHCTL_EL1PTEN, check_cnthctl_el1pten),
+	CCC(CGT_CPTR_TTA, check_cptr_tta),
 };
 
 /*
@@ -1000,6 +1038,59 @@ static const struct encoding_to_trap_config encoding_to_cgt[] __initconst = {
 	SR_TRAP(SYS_TRBPTR_EL1, 	CGT_MDCR_E2TB),
 	SR_TRAP(SYS_TRBSR_EL1, 		CGT_MDCR_E2TB),
 	SR_TRAP(SYS_TRBTRG_EL1,		CGT_MDCR_E2TB),
+	SR_TRAP(SYS_CPACR_EL1,		CGT_CPTR_TCPAC),
+	SR_TRAP(SYS_AMUSERENR_EL0,	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMCFGR_EL0,		CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMCGCR_EL0,		CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMCNTENCLR0_EL0,	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMCNTENCLR1_EL0,	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMCNTENSET0_EL0,	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMCNTENSET1_EL0,	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMCR_EL0,		CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVCNTR0_EL0(0),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVCNTR0_EL0(1),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVCNTR0_EL0(2),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVCNTR0_EL0(3),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVCNTR1_EL0(0),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVCNTR1_EL0(1),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVCNTR1_EL0(2),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVCNTR1_EL0(3),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVCNTR1_EL0(4),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVCNTR1_EL0(5),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVCNTR1_EL0(6),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVCNTR1_EL0(7),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVCNTR1_EL0(8),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVCNTR1_EL0(9),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVCNTR1_EL0(10),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVCNTR1_EL0(11),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVCNTR1_EL0(12),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVCNTR1_EL0(13),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVCNTR1_EL0(14),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVCNTR1_EL0(15),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVTYPER0_EL0(0),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVTYPER0_EL0(1),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVTYPER0_EL0(2),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVTYPER0_EL0(3),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVTYPER1_EL0(0),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVTYPER1_EL0(1),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVTYPER1_EL0(2),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVTYPER1_EL0(3),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVTYPER1_EL0(4),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVTYPER1_EL0(5),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVTYPER1_EL0(6),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVTYPER1_EL0(7),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVTYPER1_EL0(8),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVTYPER1_EL0(9),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVTYPER1_EL0(10),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVTYPER1_EL0(11),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVTYPER1_EL0(12),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVTYPER1_EL0(13),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVTYPER1_EL0(14),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_AMEVTYPER1_EL0(15),	CGT_CPTR_TAM),
+	SR_TRAP(SYS_POR_EL0,		CGT_CPACR_E0POE),
+	/* op0=2, op1=1, and CRn<0b1000 */
+	SR_RANGE_TRAP(sys_reg(2, 1, 0, 0, 0),
+		      sys_reg(2, 1, 7, 15, 7), CGT_CPTR_TTA),
 	SR_TRAP(SYS_CNTP_TVAL_EL0,	CGT_CNTHCTL_EL1PTEN),
 	SR_TRAP(SYS_CNTP_CVAL_EL0,	CGT_CNTHCTL_EL1PTEN),
 	SR_TRAP(SYS_CNTP_CTL_EL0,	CGT_CNTHCTL_EL1PTEN),
-- 
2.45.2.627.g7a2c4fd464-goog


