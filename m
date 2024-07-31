Return-Path: <kvm+bounces-22821-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AFEEC94369D
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 21:42:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6D87C284AE3
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 19:42:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1977C16D4E0;
	Wed, 31 Jul 2024 19:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hvvfd4YV"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38FE816CD25;
	Wed, 31 Jul 2024 19:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722454858; cv=none; b=jwCznpKre2QrH2BxrUQLabg0wGFvaCynlWs9Jw5+mI2kDBi0Q6XFX5pI3EQMM2rxyHGA2ufI2URt4gVNEhVEGnPbVNmbQy1DiqDgiM9rq6lnUQqRW0UyDzJIqzY+u17Jjs7YFJxlMAtRAFHDD3p0l+9Pk4vjQEsOHLdjWweftig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722454858; c=relaxed/simple;
	bh=TuS/6cRtmtNveKfMTQt2TRlXalUYKcoPDKFjEDaud+I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lNiaNWltI8G+yOaUOMcH3Q+qRn6DXuFThg44scXcEawZZ8bGuq9n/Jinr8iJg0/h77okpUpGTvn+fFdjMShpf0Nw85HGlGKPXHzWwF5JitcoOajc5gFwMABzzxtyExKA1G/6wkwd+wYXxa2QC4QZCjbk4FtTgccinmYie8hdlw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hvvfd4YV; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18587C4AF14;
	Wed, 31 Jul 2024 19:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722454858;
	bh=TuS/6cRtmtNveKfMTQt2TRlXalUYKcoPDKFjEDaud+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hvvfd4YV6du0eH03O769DPR6FeCCM2j6X6kIWBwGDklQ8HoyM5LUMWCEFYtnebhQ1
	 uKhsp4pDF+ldrCCgFC7r4aQXUenmA52NQ0UXabJN6EMIDIvCSv/fJ81sfVvg4U+9dJ
	 SGaeOtxRsgY76lLv/NojIc+Rez55sPpMnA+YYe9SOwzQiG6OPLoRctsHaVPAFokTiI
	 IDUGEaOB3h9AVgizBKW+l2dsedh4Y71DdvvV8YOi00HQVcXyaZ/mWQ4d9pC51h2R0I
	 lfP2vozglPm08kjy8KxVnqljoArHz9qE+W3Y11sSTYW9q4alqXW8FAa/kzSbwWipP5
	 4JcWXorBELjYg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sZFBw-00H6Gh-CR;
	Wed, 31 Jul 2024 20:40:56 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Przemyslaw Gaj <pgaj@cadence.com>
Subject: [PATCH v2 16/17] KVM: arm64: nv: Plumb handling of AT S1* traps from EL2
Date: Wed, 31 Jul 2024 20:40:29 +0100
Message-Id: <20240731194030.1991237-17-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240731194030.1991237-1-maz@kernel.org>
References: <20240731194030.1991237-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, alexandru.elisei@arm.com, anshuman.khandual@arm.com, pgaj@cadence.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Hooray, we're done. Plug the AT traps into the system instruction
table, and let it rip.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 45 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index e7e5e0df119e..9f3cf82e5231 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2803,6 +2803,36 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	EL2_REG(SP_EL2, NULL, reset_unknown, 0),
 };
 
+static bool handle_at_s1e01(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+			    const struct sys_reg_desc *r)
+{
+	u32 op = sys_insn(p->Op0, p->Op1, p->CRn, p->CRm, p->Op2);
+
+	__kvm_at_s1e01(vcpu, op, p->regval);
+
+	return true;
+}
+
+static bool handle_at_s1e2(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+			   const struct sys_reg_desc *r)
+{
+	u32 op = sys_insn(p->Op0, p->Op1, p->CRn, p->CRm, p->Op2);
+
+	__kvm_at_s1e2(vcpu, op, p->regval);
+
+	return true;
+}
+
+static bool handle_at_s12(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+			  const struct sys_reg_desc *r)
+{
+	u32 op = sys_insn(p->Op0, p->Op1, p->CRn, p->CRm, p->Op2);
+
+	__kvm_at_s12(vcpu, op, p->regval);
+
+	return true;
+}
+
 static bool kvm_supported_tlbi_s12_op(struct kvm_vcpu *vpcu, u32 instr)
 {
 	struct kvm *kvm = vpcu->kvm;
@@ -3065,6 +3095,14 @@ static struct sys_reg_desc sys_insn_descs[] = {
 	{ SYS_DESC(SYS_DC_ISW), access_dcsw },
 	{ SYS_DESC(SYS_DC_IGSW), access_dcgsw },
 	{ SYS_DESC(SYS_DC_IGDSW), access_dcgsw },
+
+	SYS_INSN(AT_S1E1R, handle_at_s1e01),
+	SYS_INSN(AT_S1E1W, handle_at_s1e01),
+	SYS_INSN(AT_S1E0R, handle_at_s1e01),
+	SYS_INSN(AT_S1E0W, handle_at_s1e01),
+	SYS_INSN(AT_S1E1RP, handle_at_s1e01),
+	SYS_INSN(AT_S1E1WP, handle_at_s1e01),
+
 	{ SYS_DESC(SYS_DC_CSW), access_dcsw },
 	{ SYS_DESC(SYS_DC_CGSW), access_dcgsw },
 	{ SYS_DESC(SYS_DC_CGDSW), access_dcgsw },
@@ -3144,6 +3182,13 @@ static struct sys_reg_desc sys_insn_descs[] = {
 	SYS_INSN(TLBI_VALE1NXS, handle_tlbi_el1),
 	SYS_INSN(TLBI_VAALE1NXS, handle_tlbi_el1),
 
+	SYS_INSN(AT_S1E2R, handle_at_s1e2),
+	SYS_INSN(AT_S1E2W, handle_at_s1e2),
+	SYS_INSN(AT_S12E1R, handle_at_s12),
+	SYS_INSN(AT_S12E1W, handle_at_s12),
+	SYS_INSN(AT_S12E0R, handle_at_s12),
+	SYS_INSN(AT_S12E0W, handle_at_s12),
+
 	SYS_INSN(TLBI_IPAS2E1IS, handle_ipas2e1is),
 	SYS_INSN(TLBI_RIPAS2E1IS, handle_ripas2e1is),
 	SYS_INSN(TLBI_IPAS2LE1IS, handle_ipas2e1is),
-- 
2.39.2


