Return-Path: <kvm+bounces-52325-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E6577B03E9C
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 14:27:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AB69017DEB5
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 12:27:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8508324DCF6;
	Mon, 14 Jul 2025 12:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b60C/Shs"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A33248888;
	Mon, 14 Jul 2025 12:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752496004; cv=none; b=G/X8OFZeFeFpAvOpAHX72BY7ZPmI+QBCeli4ouwwNGj6O+MU7T2x/cwjI3WjGzH2YWz3HlFg430eu+JkO1AjLtIuz4lnCt/kdUpduUQtbMDOTi0l7gMfOeimj8RCf4g97Hn9fdB6JNg4pZPE/1r6rYzuKMnHNEZCow7x9SXYFh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752496004; c=relaxed/simple;
	bh=6cRlVYQO5KDpFDlBQDyUNZ44UIGHzPzKFtGAKSIg/Xc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AZmAavmNgCu4d9didAdBF8aPlUg1lfBcgMebvUHdmtknM6ndtEDA4o/ypcNFA2MlBVO5qbVY7lpN0UVUAS3QkPd1QIrzf1K+Q2x4QD5KaV6X7+wmW+S/SiQGn/HQsrepwMcnAwKECUAfJhJ+JrZQMbOK5V74ga0qTD3moXAKwoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b60C/Shs; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B76A0C4CEED;
	Mon, 14 Jul 2025 12:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752496004;
	bh=6cRlVYQO5KDpFDlBQDyUNZ44UIGHzPzKFtGAKSIg/Xc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b60C/Shss+qli+dHD9XaaGygPPKv5b+Rq2wuCuSlFlljNlEHz/vE2rqJRY+p62ofY
	 4jCOSP/+w66+4XX8r5C8zOEVhGD53wcho/e3iIywX7XYnTPOopDNHwyHx0EWOXYChF
	 SA0r/4k+MEWIlApVXB+V/JKHqDV5DjNrmCc7DmltfdxejR4GnGrVt1YqbgsyRVj8ib
	 s4NkdIF8JEJfQ5RAvojxa0j98djC4WL9twk17kEyjJQLTJnXprx5BJoqxnZTWnOj5U
	 a0DNXEG4VNty9NuDlcdaa/OxLVR8pDNX5RhIxnpH8UREWyiKGpdIShHVB/9d7KCO/5
	 YoZXXnjftj8ZA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1ubIGY-00FW7V-VQ;
	Mon, 14 Jul 2025 13:26:43 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH 07/11] KVM: arm64: Condition FGT registers on feature availability
Date: Mon, 14 Jul 2025 13:26:30 +0100
Message-Id: <20250714122634.3334816-8-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250714122634.3334816-1-maz@kernel.org>
References: <20250714122634.3334816-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, eric.auger@redhat.com, peter.maydell@linaro.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

We shouldn't expose the FEAT_FGT registers unconditionally. Make
them dependent on FEAT_FGT being actually advertised to the guest.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 6763910fdf1f3..b441049368c7e 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2592,6 +2592,16 @@ static unsigned int tcr2_el2_visibility(const struct kvm_vcpu *vcpu,
 	return __el2_visibility(vcpu, rd, tcr2_visibility);
 }
 
+static unsigned int fgt_visibility(const struct kvm_vcpu *vcpu,
+				   const struct sys_reg_desc *rd)
+{
+	if (el2_visibility(vcpu, rd) == 0 &&
+	    kvm_has_feat(vcpu->kvm, ID_AA64MMFR0_EL1, FGT, IMP))
+		return 0;
+
+	return REG_HIDDEN;
+}
+
 static unsigned int s1pie_visibility(const struct kvm_vcpu *vcpu,
 				     const struct sys_reg_desc *rd)
 {
@@ -3310,8 +3320,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	EL2_REG(MDCR_EL2, access_mdcr, reset_mdcr, 0),
 	EL2_REG(CPTR_EL2, access_rw, reset_val, CPTR_NVHE_EL2_RES1),
 	EL2_REG_VNCR(HSTR_EL2, reset_val, 0),
-	EL2_REG_VNCR(HFGRTR_EL2, reset_val, 0),
-	EL2_REG_VNCR(HFGWTR_EL2, reset_val, 0),
+	EL2_REG_VNCR_FILT(HFGRTR_EL2, fgt_visibility),
+	EL2_REG_VNCR_FILT(HFGWTR_EL2, fgt_visibility),
 	EL2_REG_VNCR(HFGITR_EL2, reset_val, 0),
 	EL2_REG_VNCR(HACR_EL2, reset_val, 0),
 
@@ -3331,9 +3341,9 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 			 vncr_el2_visibility),
 
 	{ SYS_DESC(SYS_DACR32_EL2), undef_access, reset_unknown, DACR32_EL2 },
-	EL2_REG_VNCR(HDFGRTR_EL2, reset_val, 0),
-	EL2_REG_VNCR(HDFGWTR_EL2, reset_val, 0),
-	EL2_REG_VNCR(HAFGRTR_EL2, reset_val, 0),
+	EL2_REG_VNCR_FILT(HDFGRTR_EL2, fgt_visibility),
+	EL2_REG_VNCR_FILT(HDFGWTR_EL2, fgt_visibility),
+	EL2_REG_VNCR_FILT(HAFGRTR_EL2, fgt_visibility),
 	EL2_REG_REDIR(SPSR_EL2, reset_val, 0),
 	EL2_REG_REDIR(ELR_EL2, reset_val, 0),
 	{ SYS_DESC(SYS_SP_EL1), access_sp_el1},
-- 
2.39.2


