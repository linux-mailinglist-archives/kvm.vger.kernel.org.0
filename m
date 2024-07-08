Return-Path: <kvm+bounces-21113-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A2B792A7BA
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 18:58:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AAE2E282623
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 16:58:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 281DE14885B;
	Mon,  8 Jul 2024 16:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sgcjIrpE"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C2031482F5;
	Mon,  8 Jul 2024 16:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720457890; cv=none; b=YHyLqwQoPu3R6+05bKq5CIqkpzK1qwQmouj03kFlCYr/TNZ0irVIGHqE6U/sUsbzwDHyriktGlJcCEgrkK0QRbNA0M7iv7T2jR/gqtRj1NG/Pe12lpwmdsVRxazwihaCNFy9EFZRgXHywrHP1t4pm9aBZQAr9GenwXe7/mdxG+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720457890; c=relaxed/simple;
	bh=xgtxveXTJwvzkpFohpoJENXHtiwU/tbP8ceu6f2Dbas=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=a/URqhglStVIm1m6ot4sropCzDg6fiSZdU6pGyfSPv6VpCz8oXKiYfxpFCXkvOVnb5hbKCUMqK8bwagrhwHDvnQ8yft1oI7bSRG6DPKPHGDNvgH7QWIgKyqXmnMGii2Ybx66HNvOO4A+umqvpNd03Jav06oSc2nwpx5zd/NOTVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sgcjIrpE; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D777FC32786;
	Mon,  8 Jul 2024 16:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720457889;
	bh=xgtxveXTJwvzkpFohpoJENXHtiwU/tbP8ceu6f2Dbas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sgcjIrpE8/hXKbX4dsTSZ/xShU/txDYQhtGmh3imUp3kesCuHfPgYCbfgLuILi6Eg
	 tMIhitmyhzEsC2QvAXcbafCzduKTabWxyK8/OeT/3G20nYAIXdPznn0tvUihqfOwA1
	 Ans+5XMx38FGlmXbvpwL0P512LK+jE16JBzvARlwRcGIWuYaQOVpOkHTCmSTtFZxoe
	 Q5P1fKl0Vq97OOZcse/JUT89cMDoDUamDObnybm9A0sC0WMm5GC7L8QdftWlQpnOEk
	 ZoI75m4FV+SsubHZVEPk6kydIU2T75v8HIKZheU7ZicQ/2/s2SUhgElTKN2344bvR7
	 4jx0OTwXLRx9Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sQrgl-00AfMX-W1;
	Mon, 08 Jul 2024 17:58:08 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>
Subject: [PATCH 11/12] KVM: arm64: nv: Plumb handling of AT S1* traps from EL2
Date: Mon,  8 Jul 2024 17:57:59 +0100
Message-Id: <20240708165800.1220065-2-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240708165800.1220065-1-maz@kernel.org>
References: <20240625133508.259829-1-maz@kernel.org>
 <20240708165800.1220065-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Hooray, we're done. Plug the AT traps into the system instruction
table, and let it rip.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 45 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 06c39f191b5ec..d8dadcb9b5e3f 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2797,6 +2797,36 @@ static const struct sys_reg_desc sys_reg_descs[] = {
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
@@ -3059,6 +3089,14 @@ static struct sys_reg_desc sys_insn_descs[] = {
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
@@ -3138,6 +3176,13 @@ static struct sys_reg_desc sys_insn_descs[] = {
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


