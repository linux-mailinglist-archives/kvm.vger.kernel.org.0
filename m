Return-Path: <kvm+bounces-23972-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 84358950211
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 12:08:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3ABBE1F236FB
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 10:08:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4939919D088;
	Tue, 13 Aug 2024 10:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mF1gzqUW"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BFFB19D07A;
	Tue, 13 Aug 2024 10:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723543588; cv=none; b=nM4m4j+qSt/C4cCItfwfoDLZ1dUm6uY/MaeOUYbGOCZHF36fN84kjX/U2vQLNtJu0hB19jLyKjAytTb+0yV10ctXnC9n7LmSwyjhD04/OXfQoVJGQFekWWoihET5UDbGAPGz6gAnph3lEdEG383jQBafuK1i6nQt0OG9ngpOGRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723543588; c=relaxed/simple;
	bh=TuS/6cRtmtNveKfMTQt2TRlXalUYKcoPDKFjEDaud+I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WZwklKQZctq7j4Sqa6xDlAbfneNn0BWLzmdEogPUw4CpzwQVNTMmLQ9gOUXWgFRnQSSx+JNGo6p25/REwieJyTTHfKr53z9Vv54UcKwbKGXJwTy9wU/5r+gP14ywMBJdhYMMog2HqOVtZQOuuNiJSAgAr3kW3SAOvTvKklgP4tA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mF1gzqUW; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE839C4AF09;
	Tue, 13 Aug 2024 10:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723543588;
	bh=TuS/6cRtmtNveKfMTQt2TRlXalUYKcoPDKFjEDaud+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mF1gzqUWJthPinHN/3ChnQ6VUoqcTMpb41g+La3DOw9cDR6ZlDQniTmGauDnaVECx
	 FxOqODv/WvR6MJnBo6lz4CNmzFLTCZ7d8EQ2KvM3n58lcSvVLVcKXDlqoL4qbXj1W0
	 tXH1sAgrUhFbuqygYbDECgN8hLF3Bgoc4ahR3xfY7WPpXUR6aWWG/ez8q8XMQJC3qI
	 pzJ4RjokVD5j00d8r2GUx4wUh1rUFhJt2WYFVm1pVO9HMnI97GI+6SYpqdVmgb3AAe
	 yhPtxwmnhg9gVEk5JAjZ81Q0TeR3QXo+ED9wF+XHHF0liRY+T3Re0I2Oc+z1SpvHNx
	 6KBzXyLFVEzhQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sdoQ5-003INM-Oo;
	Tue, 13 Aug 2024 11:06:25 +0100
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
Subject: [PATCH v3 17/18] KVM: arm64: nv: Plumb handling of AT S1* traps from EL2
Date: Tue, 13 Aug 2024 11:05:39 +0100
Message-Id: <20240813100540.1955263-18-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240813100540.1955263-1-maz@kernel.org>
References: <20240813100540.1955263-1-maz@kernel.org>
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


