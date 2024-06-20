Return-Path: <kvm+bounces-20133-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EAB89910D81
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 18:49:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 78EB7B27293
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 16:49:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 082A01B3734;
	Thu, 20 Jun 2024 16:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KxgRQBMW"
X-Original-To: kvm@vger.kernel.org
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8094B1B29C0
	for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 16:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718902050; cv=none; b=Vzm3QaV8s6iSN1dCeHJvorujPc7/+ptw0ZJw0oLAHxLRi1Iwi2Q5OmZCS+MwzNszo79lwtae08nsVEFuY25RoaegsRb8AnWqBHgR3XogByHMnAwaGUeeIUtS/6LZsaq306/oMxPumibW0U+8poew3TPw/b42YU75pjKE+WMpap4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718902050; c=relaxed/simple;
	bh=1yg5AYELubECKlo6Eo+bOKuSCabL7JbyyNuiHWaHuKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oynqt1Wt64f/KAmoRSz0HxdvOwslDKG4gCjoszy4/q7A2zGaoIt+F5l1zPf8LUxTjmY0iXk20DI+9rZOjFWRBEwj10NL/81VDwhIE6xXFkKuEm4BH9ly4kfvRy3mrId+DzYPian3QeNy3XBAhTFy0FfQ1LNM6HJCuFYynXVtDuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KxgRQBMW; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718902046;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pmtAAR+VAB2Y/FTza7jwIQlFzzrt1sW9kGZMKbx09nI=;
	b=KxgRQBMW5FNtkE0N7vAipJ+aFRuNn/hNERbLuTOyH3eyQ3m7nn0Lu/EN/LfhGCgu5CW7U5
	aDrXklfGs8abRzRUbqttsoyNSy1EIaBcVRXx3qeNacOJDtq5iRM/u/DOgc6UNMnwdaz21p
	SXFBKMLVH1m6TynaTSmgaHiDymEO9kM=
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
Subject: [PATCH v3 13/15] KVM: arm64: nv: Add trap description for CPTR_EL2
Date: Thu, 20 Jun 2024 16:46:50 +0000
Message-ID: <20240620164653.1130714-14-oliver.upton@linux.dev>
In-Reply-To: <20240620164653.1130714-1-oliver.upton@linux.dev>
References: <20240620164653.1130714-1-oliver.upton@linux.dev>
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
2.45.2.741.gdbec12cfda-goog


