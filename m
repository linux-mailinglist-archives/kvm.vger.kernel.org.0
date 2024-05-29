Return-Path: <kvm+bounces-18319-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C5F0B8D3A0E
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 16:57:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E4A5A1C20D8D
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 14:57:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7535B181D03;
	Wed, 29 May 2024 14:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QRgIXTxA"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E91718131C;
	Wed, 29 May 2024 14:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716994596; cv=none; b=UAgPtQXQsUwvWsLsMlLcNDEJ3U7nbgay50mVtp0Pc7Hglv6TS9D799yTdW9uls5VHJ/5NSrUZdSzdRGrpyg+SLGDohs/wrViZPgOpmwiSWs3fEI3EftQKscYmaztLyPl0MDhho3HbbCRihDQUP8D9dlGCmVSMc69xkSFlDDRTO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716994596; c=relaxed/simple;
	bh=eCcqiZtRCnWRnuZzittOfWcqWypPDOkyKBOlAf2ATvE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Cv92rVPxH2oFLROo1BZzU5iAaajRpMX+n+yW+6vM9AhWf7FY7spwmK8PzhXn0tJhQv5PUU/+XD2I61Ljc7AKV5NO4nLwxdK9oTYCqMPdkkBWqVuBXc8ga4Qk4IdPhKiOwJ1Jsh+Telmt8zkzZSqrY0s8tZ1C3X3p86GCOZqoVN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QRgIXTxA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 710CDC4AF07;
	Wed, 29 May 2024 14:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716994596;
	bh=eCcqiZtRCnWRnuZzittOfWcqWypPDOkyKBOlAf2ATvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QRgIXTxAGP5w/8ADtzmcWstKU3d1Osw9RAt62wp2acxnO1IMPnSonVzuiVv+TKabC
	 d+Re9tSIoPhtdWx4E9BtD9gzae1aqOF/xEDYs+5CuvFcDuskgfZ/k20ra6AJx7Zbcr
	 yEb66627oAzpZD0YdxMrWHSskcHY/8HGFK9cXNjRutQi/9U8EEvNCLty2X2YfXmtgO
	 DACX1IfB9B2ju2emBTySQlWnaO7Jai+Jr39HxuuWvpHInJIeX4sIvjAfGzF1+ilF5K
	 ktytxQck7yykCrdhSTxeVkEkgtJjesAub5qfg0oK4J4HgMiA24Mv+d2iJEfiE12+Vm
	 YNp3Jhq9O/flA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sCKjC-00GekF-Pt;
	Wed, 29 May 2024 15:56:34 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: [PATCH v2 14/16] KVM: arm64: nv: Add handling of outer-shareable TLBI operations
Date: Wed, 29 May 2024 15:56:26 +0100
Message-Id: <20240529145628.3272630-15-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240529145628.3272630-1-maz@kernel.org>
References: <20240529145628.3272630-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, alexandru.elisei@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Our handling of outer-shareable TLBIs is pretty basic: we just
map them to the existing inner-shareable ones, because we really
don't have anything else.

The only significant change is that we can now advertise FEAT_TLBIOS
support if the host supports it.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/vhe/tlb.c | 10 ++++++++++
 arch/arm64/kvm/nested.c      |  5 ++++-
 arch/arm64/kvm/sys_regs.c    | 15 +++++++++++++++
 3 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/vhe/tlb.c b/arch/arm64/kvm/hyp/vhe/tlb.c
index 75aa36465805..85db6ffd9d9d 100644
--- a/arch/arm64/kvm/hyp/vhe/tlb.c
+++ b/arch/arm64/kvm/hyp/vhe/tlb.c
@@ -226,6 +226,7 @@ void __kvm_flush_vm_context(void)
  *
  * - a TLBI targeting EL2 S1 is remapped to EL1 S1
  * - a non-shareable TLBI is upgraded to being inner-shareable
+ * - an outer-shareable TLBI is also mapped to inner-shareable
  */
 int __kvm_tlbi_s1e2(struct kvm_s2_mmu *mmu, u64 va, u64 sys_encoding)
 {
@@ -245,32 +246,41 @@ int __kvm_tlbi_s1e2(struct kvm_s2_mmu *mmu, u64 va, u64 sys_encoding)
 	switch (sys_encoding) {
 	case OP_TLBI_ALLE2:
 	case OP_TLBI_ALLE2IS:
+	case OP_TLBI_ALLE2OS:
 	case OP_TLBI_VMALLE1:
 	case OP_TLBI_VMALLE1IS:
+	case OP_TLBI_VMALLE1OS:
 		__tlbi(vmalle1is);
 		break;
 	case OP_TLBI_VAE2:
 	case OP_TLBI_VAE2IS:
+	case OP_TLBI_VAE2OS:
 	case OP_TLBI_VAE1:
 	case OP_TLBI_VAE1IS:
+	case OP_TLBI_VAE1OS:
 		__tlbi(vae1is, va);
 		break;
 	case OP_TLBI_VALE2:
 	case OP_TLBI_VALE2IS:
+	case OP_TLBI_VALE2OS:
 	case OP_TLBI_VALE1:
 	case OP_TLBI_VALE1IS:
+	case OP_TLBI_VALE1OS:
 		__tlbi(vale1is, va);
 		break;
 	case OP_TLBI_ASIDE1:
 	case OP_TLBI_ASIDE1IS:
+	case OP_TLBI_ASIDE1OS:
 		__tlbi(aside1is, va);
 		break;
 	case OP_TLBI_VAAE1:
 	case OP_TLBI_VAAE1IS:
+	case OP_TLBI_VAAE1OS:
 		__tlbi(vaae1is, va);
 		break;
 	case OP_TLBI_VAALE1:
 	case OP_TLBI_VAALE1IS:
+	case OP_TLBI_VAALE1OS:
 		__tlbi(vaale1is, va);
 		break;
 	default:
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 5ab5c43c571b..981c879ba79a 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -804,9 +804,12 @@ static u64 limit_nv_id_reg(u32 id, u64 val)
 
 	switch (id) {
 	case SYS_ID_AA64ISAR0_EL1:
-		/* Support everything but TME, O.S. and Range TLBIs */
+		/* Support everything but TME and Range TLBIs */
+		tmp = FIELD_GET(NV_FTR(ISAR0, TLB), val);
+		tmp = min(tmp, ID_AA64ISAR0_EL1_TLB_OS);
 		val &= ~(NV_FTR(ISAR0, TLB)		|
 			 NV_FTR(ISAR0, TME));
+		val |= FIELD_PREP(NV_FTR(ISAR0, TLB), tmp);
 		break;
 
 	case SYS_ID_AA64ISAR1_EL1:
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 5bed362f80d3..7dec7da167f6 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2959,6 +2959,13 @@ static struct sys_reg_desc sys_insn_descs[] = {
 	{ SYS_DESC(SYS_DC_CIGSW), access_dcgsw },
 	{ SYS_DESC(SYS_DC_CIGDSW), access_dcgsw },
 
+	SYS_INSN(TLBI_VMALLE1OS, handle_tlbi_el1),
+	SYS_INSN(TLBI_VAE1OS, handle_tlbi_el1),
+	SYS_INSN(TLBI_ASIDE1OS, handle_tlbi_el1),
+	SYS_INSN(TLBI_VAAE1OS, handle_tlbi_el1),
+	SYS_INSN(TLBI_VALE1OS, handle_tlbi_el1),
+	SYS_INSN(TLBI_VAALE1OS, handle_tlbi_el1),
+
 	SYS_INSN(TLBI_VMALLE1IS, handle_tlbi_el1),
 	SYS_INSN(TLBI_VAE1IS, handle_tlbi_el1),
 	SYS_INSN(TLBI_ASIDE1IS, handle_tlbi_el1),
@@ -2975,9 +2982,17 @@ static struct sys_reg_desc sys_insn_descs[] = {
 	SYS_INSN(TLBI_IPAS2E1IS, handle_ipas2e1is),
 	SYS_INSN(TLBI_IPAS2LE1IS, handle_ipas2e1is),
 
+	SYS_INSN(TLBI_ALLE2OS, trap_undef),
+	SYS_INSN(TLBI_VAE2OS, trap_undef),
+	SYS_INSN(TLBI_ALLE1OS, handle_alle1is),
+	SYS_INSN(TLBI_VALE2OS, trap_undef),
+	SYS_INSN(TLBI_VMALLS12E1OS, handle_vmalls12e1is),
+
 	SYS_INSN(TLBI_ALLE1IS, handle_alle1is),
 	SYS_INSN(TLBI_VMALLS12E1IS, handle_vmalls12e1is),
+	SYS_INSN(TLBI_IPAS2E1OS, handle_ipas2e1is),
 	SYS_INSN(TLBI_IPAS2E1, handle_ipas2e1is),
+	SYS_INSN(TLBI_IPAS2LE1OS, handle_ipas2e1is),
 	SYS_INSN(TLBI_IPAS2LE1, handle_ipas2e1is),
 	SYS_INSN(TLBI_ALLE1, handle_alle1is),
 	SYS_INSN(TLBI_VMALLS12E1, handle_vmalls12e1is),
-- 
2.39.2


