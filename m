Return-Path: <kvm+bounces-19695-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 73ACF908DC8
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 16:47:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EB81B289C9E
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 14:47:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 448735577E;
	Fri, 14 Jun 2024 14:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LBI1njjv"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 635B549626;
	Fri, 14 Jun 2024 14:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718376378; cv=none; b=UkjzntVS/PxRdK8256YTNbkm/MbxvgkikePaSXzqtrpwUq8z5aK6R5lJrbhvIbSTKbpZCtelqxPl1XVG/HvJeuOuI1KsX+ULR+gt1UWV6/ySDZQdTzNjRoD3omhCgCk9uzbY0x4iF06IJfwiJkAqZZ0lo9lxlMcGRCZJAoZ4XiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718376378; c=relaxed/simple;
	bh=eAzMQSKP9msotMm8XGrFKPMCeZQjYzjiAbuNYEVNnhw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=D4/P/YfWgCHnII28itQYDL1g1p9RuNjc8I7Kp1C8JSD+ladhb0OHlHOBCuBDD5xy4qKTBmwXkpvSoFZDCvqo8YjGegj9qqN3olDaFlniPvufBaYRFPRbd2oAWIzPrgng2mlWt4i335vL06pftK14JJtpVDpXCkf4rXlrlZcni0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LBI1njjv; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44560C2BD10;
	Fri, 14 Jun 2024 14:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718376378;
	bh=eAzMQSKP9msotMm8XGrFKPMCeZQjYzjiAbuNYEVNnhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LBI1njjvEwVUpyMIv5Tav9iBPDm2ykColifG4zDHevJgt9keuZIOB+B+nZt1xz8nb
	 eBfNbfl4k947B13lMQ+KOLjHHI3U2LJnwM3kwmCPjdh4bKGS51U67ht0wmZGFuiCTg
	 DnsZRSLbZvtaI9VBGJUQ1kGjfqbYODQu9acLsqPHm9wI1Vv7JFxMk+1gC61gT2jPA1
	 mnJws9Txkbjli7djjvJwo7igtSZzIO6rhmDqDIplMc4/JBSi9pPIv0he6XTLk4Utjg
	 DjVgCP1pLHArQG24cVGKizRJ1wb8VC6ghAC1Jm7Qxvu2E23LORzHenq9aKYCi6kajF
	 BmPeqj3kJao+A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sI8C0-003wb4-JE;
	Fri, 14 Jun 2024 15:46:16 +0100
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
Subject: [PATCH v3 14/16] KVM: arm64: nv: Add handling of outer-shareable TLBI operations
Date: Fri, 14 Jun 2024 15:45:50 +0100
Message-Id: <20240614144552.2773592-15-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240614144552.2773592-1-maz@kernel.org>
References: <20240614144552.2773592-1-maz@kernel.org>
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
index af4713cce613..4d1c98449176 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -805,9 +805,12 @@ static u64 limit_nv_id_reg(u32 id, u64 val)
 
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


