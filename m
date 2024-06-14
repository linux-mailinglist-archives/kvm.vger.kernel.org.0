Return-Path: <kvm+bounces-19696-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 28229908DCA
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 16:47:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B785B2858D0
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 14:47:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C053261FC9;
	Fri, 14 Jun 2024 14:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QEEViNpL"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4A5049655;
	Fri, 14 Jun 2024 14:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718376379; cv=none; b=k2lnqQcOKKNJwqTKF6qOEOsUUoBVIjYBnsv47Mbt8QzyQh+SodtVHkRv3Vg9SlmbNnFB0u6/VoEOgwDCdYvgDsWtHLYLQT+iJ05txQS2GjauqN29ksUxO5RkTxkNQWxkeeNmG2mTveWVbNPDTNnOwJGqyS5PfYej4AlMsyCYWdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718376379; c=relaxed/simple;
	bh=SS7WGAr1LEYooScmKmkwyKFU1d7cHpinholv/HXzUmE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eQcsuparhq6lLyrcdN3F7O8tdazdreJX+Urt8BhL5tbKcXU7FSbR1++T7Aq5khCoieiHwIUYa300dqPiXJ/DO0c0QeoU5Q6ZmbM9YLGlcoYR/5GiXoX/Qxc9TSajtIC+jCBs8AU1cy2SslDsz82nZUzzNilRIOwPNDEsEQcp34Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QEEViNpL; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAEB4C4AF51;
	Fri, 14 Jun 2024 14:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718376378;
	bh=SS7WGAr1LEYooScmKmkwyKFU1d7cHpinholv/HXzUmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QEEViNpLioofi8wukio7zo3VHQniMbec1iJQ2XMsaKAEAbg3Q8O/9wNq2iLdTdYLL
	 jf3zL5iybpIMWHFS7IHdScu62mnLjqiJa3DxFHb88DlFT3wlFU56TOM+yHw5CoBsmZ
	 BNcluMczk5mFtIDA3ad2wjQBA5iCVf+oWnE1SrgGpY2e11Rqt0UhTnZ0q5+DG7XxvV
	 s6wHp333qobb3ZxF3SOvjNbC9KbiSPnPLzHbvRCbjinm/2FJLzrg2e03XqR9eb8XAS
	 O/kUr61ON3yfpli53G0q4KRLaCDefhfRcOevQysGtB2SiHrPg5qLMWEhPA7vhBPhyL
	 b02TUj//czi1A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sI8C1-003wb4-0N;
	Fri, 14 Jun 2024 15:46:17 +0100
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
Subject: [PATCH v3 16/16] KVM: arm64: nv: Add handling of NXS-flavoured TLBI operations
Date: Fri, 14 Jun 2024 15:45:52 +0100
Message-Id: <20240614144552.2773592-17-maz@kernel.org>
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

Latest kid on the block: NXS (Non-eXtra-Slow) TLBI operations.

Let's add those in bulk (NSH, ISH, OSH, both normal and range)
as they directly map to their XS (the standard ones) counterparts.

Not a lot to say about them, they are basically useless.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/vhe/tlb.c | 46 +++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c    | 73 ++++++++++++++++++++++++++++++++++++
 2 files changed, 119 insertions(+)

diff --git a/arch/arm64/kvm/hyp/vhe/tlb.c b/arch/arm64/kvm/hyp/vhe/tlb.c
index 18e30f03f3f5..3d50a1bd2bdb 100644
--- a/arch/arm64/kvm/hyp/vhe/tlb.c
+++ b/arch/arm64/kvm/hyp/vhe/tlb.c
@@ -227,6 +227,7 @@ void __kvm_flush_vm_context(void)
  * - a TLBI targeting EL2 S1 is remapped to EL1 S1
  * - a non-shareable TLBI is upgraded to being inner-shareable
  * - an outer-shareable TLBI is also mapped to inner-shareable
+ * - an nXS TLBI is upgraded to XS
  */
 int __kvm_tlbi_s1e2(struct kvm_s2_mmu *mmu, u64 va, u64 sys_encoding)
 {
@@ -250,6 +251,12 @@ int __kvm_tlbi_s1e2(struct kvm_s2_mmu *mmu, u64 va, u64 sys_encoding)
 	case OP_TLBI_VMALLE1:
 	case OP_TLBI_VMALLE1IS:
 	case OP_TLBI_VMALLE1OS:
+	case OP_TLBI_ALLE2NXS:
+	case OP_TLBI_ALLE2ISNXS:
+	case OP_TLBI_ALLE2OSNXS:
+	case OP_TLBI_VMALLE1NXS:
+	case OP_TLBI_VMALLE1ISNXS:
+	case OP_TLBI_VMALLE1OSNXS:
 		__tlbi(vmalle1is);
 		break;
 	case OP_TLBI_VAE2:
@@ -258,6 +265,12 @@ int __kvm_tlbi_s1e2(struct kvm_s2_mmu *mmu, u64 va, u64 sys_encoding)
 	case OP_TLBI_VAE1:
 	case OP_TLBI_VAE1IS:
 	case OP_TLBI_VAE1OS:
+	case OP_TLBI_VAE2NXS:
+	case OP_TLBI_VAE2ISNXS:
+	case OP_TLBI_VAE2OSNXS:
+	case OP_TLBI_VAE1NXS:
+	case OP_TLBI_VAE1ISNXS:
+	case OP_TLBI_VAE1OSNXS:
 		__tlbi(vae1is, va);
 		break;
 	case OP_TLBI_VALE2:
@@ -266,21 +279,36 @@ int __kvm_tlbi_s1e2(struct kvm_s2_mmu *mmu, u64 va, u64 sys_encoding)
 	case OP_TLBI_VALE1:
 	case OP_TLBI_VALE1IS:
 	case OP_TLBI_VALE1OS:
+	case OP_TLBI_VALE2NXS:
+	case OP_TLBI_VALE2ISNXS:
+	case OP_TLBI_VALE2OSNXS:
+	case OP_TLBI_VALE1NXS:
+	case OP_TLBI_VALE1ISNXS:
+	case OP_TLBI_VALE1OSNXS:
 		__tlbi(vale1is, va);
 		break;
 	case OP_TLBI_ASIDE1:
 	case OP_TLBI_ASIDE1IS:
 	case OP_TLBI_ASIDE1OS:
+	case OP_TLBI_ASIDE1NXS:
+	case OP_TLBI_ASIDE1ISNXS:
+	case OP_TLBI_ASIDE1OSNXS:
 		__tlbi(aside1is, va);
 		break;
 	case OP_TLBI_VAAE1:
 	case OP_TLBI_VAAE1IS:
 	case OP_TLBI_VAAE1OS:
+	case OP_TLBI_VAAE1NXS:
+	case OP_TLBI_VAAE1ISNXS:
+	case OP_TLBI_VAAE1OSNXS:
 		__tlbi(vaae1is, va);
 		break;
 	case OP_TLBI_VAALE1:
 	case OP_TLBI_VAALE1IS:
 	case OP_TLBI_VAALE1OS:
+	case OP_TLBI_VAALE1NXS:
+	case OP_TLBI_VAALE1ISNXS:
+	case OP_TLBI_VAALE1OSNXS:
 		__tlbi(vaale1is, va);
 		break;
 	case OP_TLBI_RVAE2:
@@ -289,6 +317,12 @@ int __kvm_tlbi_s1e2(struct kvm_s2_mmu *mmu, u64 va, u64 sys_encoding)
 	case OP_TLBI_RVAE1:
 	case OP_TLBI_RVAE1IS:
 	case OP_TLBI_RVAE1OS:
+	case OP_TLBI_RVAE2NXS:
+	case OP_TLBI_RVAE2ISNXS:
+	case OP_TLBI_RVAE2OSNXS:
+	case OP_TLBI_RVAE1NXS:
+	case OP_TLBI_RVAE1ISNXS:
+	case OP_TLBI_RVAE1OSNXS:
 		__tlbi(rvae1is, va);
 		break;
 	case OP_TLBI_RVALE2:
@@ -297,16 +331,28 @@ int __kvm_tlbi_s1e2(struct kvm_s2_mmu *mmu, u64 va, u64 sys_encoding)
 	case OP_TLBI_RVALE1:
 	case OP_TLBI_RVALE1IS:
 	case OP_TLBI_RVALE1OS:
+	case OP_TLBI_RVALE2NXS:
+	case OP_TLBI_RVALE2ISNXS:
+	case OP_TLBI_RVALE2OSNXS:
+	case OP_TLBI_RVALE1NXS:
+	case OP_TLBI_RVALE1ISNXS:
+	case OP_TLBI_RVALE1OSNXS:
 		__tlbi(rvale1is, va);
 		break;
 	case OP_TLBI_RVAAE1:
 	case OP_TLBI_RVAAE1IS:
 	case OP_TLBI_RVAAE1OS:
+	case OP_TLBI_RVAAE1NXS:
+	case OP_TLBI_RVAAE1ISNXS:
+	case OP_TLBI_RVAAE1OSNXS:
 		__tlbi(rvaae1is, va);
 		break;
 	case OP_TLBI_RVAALE1:
 	case OP_TLBI_RVAALE1IS:
 	case OP_TLBI_RVAALE1OS:
+	case OP_TLBI_RVAALE1NXS:
+	case OP_TLBI_RVAALE1ISNXS:
+	case OP_TLBI_RVAALE1OSNXS:
 		__tlbi(rvaale1is, va);
 		break;
 	default:
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index f6edcb863577..803cd5f16e43 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -3046,6 +3046,42 @@ static struct sys_reg_desc sys_insn_descs[] = {
 	SYS_INSN(TLBI_VALE1, handle_tlbi_el1),
 	SYS_INSN(TLBI_VAALE1, handle_tlbi_el1),
 
+	SYS_INSN(TLBI_VMALLE1OSNXS, handle_tlbi_el1),
+	SYS_INSN(TLBI_VAE1OSNXS, handle_tlbi_el1),
+	SYS_INSN(TLBI_ASIDE1OSNXS, handle_tlbi_el1),
+	SYS_INSN(TLBI_VAAE1OSNXS, handle_tlbi_el1),
+	SYS_INSN(TLBI_VALE1OSNXS, handle_tlbi_el1),
+	SYS_INSN(TLBI_VAALE1OSNXS, handle_tlbi_el1),
+
+	SYS_INSN(TLBI_RVAE1ISNXS, handle_tlbi_el1),
+	SYS_INSN(TLBI_RVAAE1ISNXS, handle_tlbi_el1),
+	SYS_INSN(TLBI_RVALE1ISNXS, handle_tlbi_el1),
+	SYS_INSN(TLBI_RVAALE1ISNXS, handle_tlbi_el1),
+
+	SYS_INSN(TLBI_VMALLE1ISNXS, handle_tlbi_el1),
+	SYS_INSN(TLBI_VAE1ISNXS, handle_tlbi_el1),
+	SYS_INSN(TLBI_ASIDE1ISNXS, handle_tlbi_el1),
+	SYS_INSN(TLBI_VAAE1ISNXS, handle_tlbi_el1),
+	SYS_INSN(TLBI_VALE1ISNXS, handle_tlbi_el1),
+	SYS_INSN(TLBI_VAALE1ISNXS, handle_tlbi_el1),
+
+	SYS_INSN(TLBI_RVAE1OSNXS, handle_tlbi_el1),
+	SYS_INSN(TLBI_RVAAE1OSNXS, handle_tlbi_el1),
+	SYS_INSN(TLBI_RVALE1OSNXS, handle_tlbi_el1),
+	SYS_INSN(TLBI_RVAALE1OSNXS, handle_tlbi_el1),
+
+	SYS_INSN(TLBI_RVAE1NXS, handle_tlbi_el1),
+	SYS_INSN(TLBI_RVAAE1NXS, handle_tlbi_el1),
+	SYS_INSN(TLBI_RVALE1NXS, handle_tlbi_el1),
+	SYS_INSN(TLBI_RVAALE1NXS, handle_tlbi_el1),
+
+	SYS_INSN(TLBI_VMALLE1NXS, handle_tlbi_el1),
+	SYS_INSN(TLBI_VAE1NXS, handle_tlbi_el1),
+	SYS_INSN(TLBI_ASIDE1NXS, handle_tlbi_el1),
+	SYS_INSN(TLBI_VAAE1NXS, handle_tlbi_el1),
+	SYS_INSN(TLBI_VALE1NXS, handle_tlbi_el1),
+	SYS_INSN(TLBI_VAALE1NXS, handle_tlbi_el1),
+
 	SYS_INSN(TLBI_IPAS2E1IS, handle_ipas2e1is),
 	SYS_INSN(TLBI_RIPAS2E1IS, handle_ripas2e1is),
 	SYS_INSN(TLBI_IPAS2LE1IS, handle_ipas2e1is),
@@ -3076,6 +3112,43 @@ static struct sys_reg_desc sys_insn_descs[] = {
 	SYS_INSN(TLBI_RVALE2, trap_undef),
 	SYS_INSN(TLBI_ALLE1, handle_alle1is),
 	SYS_INSN(TLBI_VMALLS12E1, handle_vmalls12e1is),
+
+	SYS_INSN(TLBI_IPAS2E1ISNXS, handle_ipas2e1is),
+	SYS_INSN(TLBI_RIPAS2E1ISNXS, handle_ripas2e1is),
+	SYS_INSN(TLBI_IPAS2LE1ISNXS, handle_ipas2e1is),
+	SYS_INSN(TLBI_RIPAS2LE1ISNXS, handle_ripas2e1is),
+
+	SYS_INSN(TLBI_ALLE2OSNXS, trap_undef),
+	SYS_INSN(TLBI_VAE2OSNXS, trap_undef),
+	SYS_INSN(TLBI_ALLE1OSNXS, handle_alle1is),
+	SYS_INSN(TLBI_VALE2OSNXS, trap_undef),
+	SYS_INSN(TLBI_VMALLS12E1OSNXS, handle_vmalls12e1is),
+
+	SYS_INSN(TLBI_RVAE2ISNXS, trap_undef),
+	SYS_INSN(TLBI_RVALE2ISNXS, trap_undef),
+	SYS_INSN(TLBI_ALLE2ISNXS, trap_undef),
+	SYS_INSN(TLBI_VAE2ISNXS, trap_undef),
+
+	SYS_INSN(TLBI_ALLE1ISNXS, handle_alle1is),
+	SYS_INSN(TLBI_VALE2ISNXS, trap_undef),
+	SYS_INSN(TLBI_VMALLS12E1ISNXS, handle_vmalls12e1is),
+	SYS_INSN(TLBI_IPAS2E1OSNXS, handle_ipas2e1is),
+	SYS_INSN(TLBI_IPAS2E1NXS, handle_ipas2e1is),
+	SYS_INSN(TLBI_RIPAS2E1NXS, handle_ripas2e1is),
+	SYS_INSN(TLBI_RIPAS2E1OSNXS, handle_ripas2e1is),
+	SYS_INSN(TLBI_IPAS2LE1OSNXS, handle_ipas2e1is),
+	SYS_INSN(TLBI_IPAS2LE1NXS, handle_ipas2e1is),
+	SYS_INSN(TLBI_RIPAS2LE1NXS, handle_ripas2e1is),
+	SYS_INSN(TLBI_RIPAS2LE1OSNXS, handle_ripas2e1is),
+	SYS_INSN(TLBI_RVAE2OSNXS, trap_undef),
+	SYS_INSN(TLBI_RVALE2OSNXS, trap_undef),
+	SYS_INSN(TLBI_RVAE2NXS, trap_undef),
+	SYS_INSN(TLBI_RVALE2NXS, trap_undef),
+	SYS_INSN(TLBI_ALLE2NXS, trap_undef),
+	SYS_INSN(TLBI_VAE2NXS, trap_undef),
+	SYS_INSN(TLBI_ALLE1NXS, handle_alle1is),
+	SYS_INSN(TLBI_VALE2NXS, trap_undef),
+	SYS_INSN(TLBI_VMALLS12E1NXS, handle_vmalls12e1is),
 };
 
 static const struct sys_reg_desc *first_idreg;
-- 
2.39.2


