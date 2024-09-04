Return-Path: <kvm+bounces-25837-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E068096B470
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 10:24:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9DE002886BC
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 08:24:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B31741865F5;
	Wed,  4 Sep 2024 08:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gs7dD/FY"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D762417C987;
	Wed,  4 Sep 2024 08:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725438280; cv=none; b=XqCPiJxMhcX8d+dLuyztisffP051cPLMQnag3WAd2j6rt8M+g5+I/y1vsefzkL3b0OpaHV8HisfULZuqmyd8UlZ+cZu3JbodWOfhwkA9hrEveXx9A5TfgM9Ytu82m8dehcrjqBROdy09GJdF5ceaVZEgqLyUctHjQBD+KZUkcJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725438280; c=relaxed/simple;
	bh=fZHddvF+qYhgRuvqft59eESqhUj0wguwxqDnkpoLylI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LbHkZOCbaeNTLFqyaKpSpk/hB47hQAHB8uNWJh7T98vagf+aOkzDs8BIficGSJEkf+tCBCugHr1ZEsw/yh6tLkOBROwUD6AzJ95IUhJcaxlwqvkYzBwu7XKkyGQt2yLq4V1cMYReeBs5WEvdeaMdyRZBrvCizcowYFdMXSzypQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gs7dD/FY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92877C4CECA;
	Wed,  4 Sep 2024 08:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725438280;
	bh=fZHddvF+qYhgRuvqft59eESqhUj0wguwxqDnkpoLylI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gs7dD/FYwUpk6GUD26LeNN+TuWtGlRVm52wdMzUTi74VXpAI5kyudsp8PBlSjOFY6
	 TvfY7qMfOkm9Gy1bpC9s5k+FTEwIRZBabu83Y/nRgM5eB47ddL92klDlRefp9jtUHn
	 tiDSgzvFC2D8zb3HgROaT66+U/MWxS/nI/7Su2cgvb738enJetviCNBrCHEKpXhgb3
	 64PZq/I/906Lb03ZPjZWC2IaBMROqDPqCvdDMXfb+qSj5hA9HuJcIuRJpxGx1d+Dqj
	 p8ONNnh0PBpExNS2XrOnXRhFOV3miVhMh8vzmyKchScy5tWOarJkaqIJWYqweqotv8
	 Ap4x6Y+hmHKvw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sllJe-009VF3-FH;
	Wed, 04 Sep 2024 09:24:38 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 1/3] KVM: arm64: Simplify handling of CNTKCTL_EL12
Date: Wed,  4 Sep 2024 09:24:17 +0100
Message-Id: <20240904082419.1982402-2-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240904082419.1982402-1-maz@kernel.org>
References: <20240904082419.1982402-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

We go trough a great deal of effort to map CNTKCTL_EL12 to CNTKCTL_EL1
while hidding this mapping from userspace via a special visibility helper.

However, it would be far simpler to just provide an accessor doing the
mapping job, removing the need for a visibility helper.

With that done, we can also remove the EL12_REG() macro which serves
no purpose.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 45c9e3b2acd4..5328fac8d547 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2105,15 +2105,6 @@ static unsigned int hidden_user_visibility(const struct kvm_vcpu *vcpu,
 	return REG_HIDDEN_USER;
 }
 
-#define EL12_REG(name, acc, rst, v) {		\
-	SYS_DESC(SYS_##name##_EL12),		\
-	.access = acc,				\
-	.reset = rst,				\
-	.reg = name##_EL1,			\
-	.val = v,				\
-	.visibility = hidden_user_visibility,	\
-}
-
 /*
  * Since reset() callback and field val are not used for idregs, they will be
  * used for specific purposes for idregs.
@@ -2221,6 +2212,18 @@ static bool access_spsr(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+static bool access_cntkctl_el12(struct kvm_vcpu *vcpu,
+				struct sys_reg_params *p,
+				const struct sys_reg_desc *r)
+{
+	if (p->is_write)
+		__vcpu_sys_reg(vcpu, CNTKCTL_EL1) = p->regval;
+	else
+		p->regval = __vcpu_sys_reg(vcpu, CNTKCTL_EL1);
+
+	return true;
+}
+
 static u64 reset_hcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
 	u64 val = r->val;
@@ -2825,7 +2828,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	EL2_REG_VNCR(CNTVOFF_EL2, reset_val, 0),
 	EL2_REG(CNTHCTL_EL2, access_rw, reset_val, 0),
 
-	EL12_REG(CNTKCTL, access_rw, reset_val, 0),
+	{ SYS_DESC(SYS_CNTKCTL_EL12), access_cntkctl_el12 },
 
 	EL2_REG(SP_EL2, NULL, reset_unknown, 0),
 };
-- 
2.39.2


