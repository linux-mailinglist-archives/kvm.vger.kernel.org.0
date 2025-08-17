Return-Path: <kvm+bounces-54858-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A6ADFB294F6
	for <lists+kvm@lfdr.de>; Sun, 17 Aug 2025 22:23:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EF3383A9AC5
	for <lists+kvm@lfdr.de>; Sun, 17 Aug 2025 20:22:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03C832D5C86;
	Sun, 17 Aug 2025 20:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XJVu3iKP"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2654224166F;
	Sun, 17 Aug 2025 20:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755462126; cv=none; b=aAXwUs5uDF1rTklkj/9Y6D7mb7ZLEXg2r3hW9COhsT5RNTbDAuVmDgkUKrMscyGRF84JP8pqm0XuXL4sn7EQFBVxYJuDn8SMOR1BeI8Nvj2WTysbgmRoRT2LmTGPefwTp2FmW809w7SZA5cKW0MR8MdYEh+hb/DZWuanS22r7Bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755462126; c=relaxed/simple;
	bh=3vd1wrwANdEhEBYmVfIfvZ49NXbAKqOZUOEAet9mLhk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TV7ZCyAfs2a64Rfudwv1kqAx5Bj9hrpgj5XSayYXFPyC0zEeuKY+mmvVs8pyDdmHdPUK8sHfCFgyK51dP+DjR9ZeaCVGaqiEKHjKgKD1du+S3+O83XQFvEqCtvxvgf7b7NRWnAm3LZfoMYZet9t0Z9UqjHjp/exb/9M1LSWEt/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XJVu3iKP; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3329C4CEED;
	Sun, 17 Aug 2025 20:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755462125;
	bh=3vd1wrwANdEhEBYmVfIfvZ49NXbAKqOZUOEAet9mLhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XJVu3iKPwIxUD+xgbvhcd7woxuQqc+pJbIZyZls8I/XbejiYnBW8dkzn04ehj1bFp
	 8hbz0muCmCYgXynb/Ma0Yp40WWD8PFgebMC7dIOLpCw9JhtSfgxPr+Rf0hgEBe5ucv
	 zumc7gGmp+f9XX+XKSBAdw0RBsZ+1XXGyw1I8SRy0rQxurqoByJqYRwOV1yRgaix2l
	 P20WvILNeCrSwMncgWdKr4gvKLPKqu2C+Iwsp1/N3z5goG5Q1cZ8eKnLT4Y5ZNFaeI
	 /61d8WwM/dibNOt1I41sKJDfJ/KmHBD/lMyWMFnI+4DdcnuxS3ONqJizKRXPZxO7wg
	 9HRTyegaOJBfA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1unjtD-008PX0-9H;
	Sun, 17 Aug 2025 21:22:03 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH v3 2/6] KVM: arm64: Handle RASv1p1 registers
Date: Sun, 17 Aug 2025 21:21:54 +0100
Message-Id: <20250817202158.395078-3-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250817202158.395078-1-maz@kernel.org>
References: <20250817202158.395078-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, will@kernel.org, catalin.marinas@arm.com, cohuck@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

FEAT_RASv1p1 system registeres are not handled at all so far.
KVM will give an embarassed warning on the console and inject
an UNDEF, despite RASv1p1 being exposed to the guest on suitable HW.

Handle these registers similarly to FEAT_RAS, with the added fun
that there are *two* way to indicate the presence of FEAT_RASv1p1.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 82ffb3b3b3cf7..feb1a7a708e25 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2697,6 +2697,18 @@ static bool access_ras(struct kvm_vcpu *vcpu,
 	struct kvm *kvm = vcpu->kvm;
 
 	switch(reg_to_encoding(r)) {
+	case SYS_ERXPFGCDN_EL1:
+	case SYS_ERXPFGCTL_EL1:
+	case SYS_ERXPFGF_EL1:
+	case SYS_ERXMISC2_EL1:
+	case SYS_ERXMISC3_EL1:
+		if (!(kvm_has_feat(kvm, ID_AA64PFR0_EL1, RAS, V1P1) ||
+		      (kvm_has_feat_enum(kvm, ID_AA64PFR0_EL1, RAS, IMP) &&
+		       kvm_has_feat(kvm, ID_AA64PFR1_EL1, RAS_frac, RASv1p1)))) {
+			kvm_inject_undefined(vcpu);
+			return false;
+		}
+		break;
 	default:
 		if (!kvm_has_feat(kvm, ID_AA64PFR0_EL1, RAS, IMP)) {
 			kvm_inject_undefined(vcpu);
@@ -3063,8 +3075,13 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_ERXCTLR_EL1), access_ras },
 	{ SYS_DESC(SYS_ERXSTATUS_EL1), access_ras },
 	{ SYS_DESC(SYS_ERXADDR_EL1), access_ras },
+	{ SYS_DESC(SYS_ERXPFGF_EL1), access_ras },
+	{ SYS_DESC(SYS_ERXPFGCTL_EL1), access_ras },
+	{ SYS_DESC(SYS_ERXPFGCDN_EL1), access_ras },
 	{ SYS_DESC(SYS_ERXMISC0_EL1), access_ras },
 	{ SYS_DESC(SYS_ERXMISC1_EL1), access_ras },
+	{ SYS_DESC(SYS_ERXMISC2_EL1), access_ras },
+	{ SYS_DESC(SYS_ERXMISC3_EL1), access_ras },
 
 	MTE_REG(TFSR_EL1),
 	MTE_REG(TFSRE0_EL1),
-- 
2.39.2


