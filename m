Return-Path: <kvm+bounces-63850-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id E8A3AC744AB
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 14:39:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 4F1C735B62D
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 13:33:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2AD333F385;
	Thu, 20 Nov 2025 13:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cjvnuliu"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB8FA33CEA4;
	Thu, 20 Nov 2025 13:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763645540; cv=none; b=bNkgwOgZGrjGAI5Qve06EigQPlnbJXCLvBWL1I1QIwfdBz8voBudkzaigGOIFugslV32J8b7RUWzQTP6ZxweTzKWVvOaWQ81mlc6YFhaTIzl0OQHh2y0muK76IjytGucVYmF5UHkFZFH+KVw0/2GWhU/XJWT6RrnR9g8/3GUUTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763645540; c=relaxed/simple;
	bh=sNShVh/3Wfcp1fU9b2leeizEh1WeKw0B0W6xrZVsUhM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ENOyqmzIvzKueIOlLGAh/ogibyCTB5FyDgcuWOywWuunaAU3iVd8CtwOFanIhdG3wN5ZCK8uIt9nFNF49yFYmmYEvfgZOWvxFSibruPETezsBOPJwtOJGf6octvqiHVZaZySg23wv8DYzIEDIc+ym0oLtc4Mr/biHqnXLdGKzrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cjvnuliu; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78B1AC116D0;
	Thu, 20 Nov 2025 13:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763645540;
	bh=sNShVh/3Wfcp1fU9b2leeizEh1WeKw0B0W6xrZVsUhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CjvnuliuV+bv9g/yeXSYer26fqmvlOW/YSVHjI7KPUPDP2IJSSrvGNiC7U2jYro/Q
	 X3sMClG9/aDHnnWUisu3w9uTEc39dqIBn7/FvqQpYsauEtbaK4+rKBLHjBpyRzCrEj
	 L2oioSW4MK4vmIULP4VBwPckH3HcrZUWE7f7vYWTZegocJsnsn/+XP55djCLF4oZde
	 eLP56FstsaNsL1TPB0A7xNTKmWGm2MZ4QR0aUGNSD7PZteowb5IGngOOK4z0Tpyt/M
	 3zZyNOXTeJ2D/SuQggjb+4cRi98eg8D8jKbYnqMmthkULI69/yBKPF3iD/Ai5cbXrm
	 sw16y2OHQ9VpA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vM4lm-00000006tUG-2Sxt;
	Thu, 20 Nov 2025 13:32:18 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 4/5] KVM: arm64: Report optional ID register traps with a 0x18 syndrome
Date: Thu, 20 Nov 2025 13:32:01 +0000
Message-ID: <20251120133202.2037803-5-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251120133202.2037803-1-maz@kernel.org>
References: <20251120133202.2037803-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

With FEAT_IDST, unimplemented system registers must be reported using
EC=0x18 at the closest handling EL, rather than with an UNDEF.

Most system registers are always implemented thanks to their dependency
on FEAT_AA64, except for a set of (currently) three registers:
GMID_EL1 (depending on MTE2), CCSIDR2_EL1 (depending on FEAT_CCIDX),
and SMIDR_EL1 (depending on SME).

For these three registers, report their trap as EC=0x18 if they
end-up trapping into KVM and that FEAT_IDST is not implemented in the
guest. Otherwise, just make them UNDEF.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 40f32b017f107..992137822dcf9 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -82,6 +82,16 @@ static bool write_to_read_only(struct kvm_vcpu *vcpu,
 			"sys_reg write to read-only register");
 }
 
+static bool idst_access(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+			const struct sys_reg_desc *r)
+{
+	if (kvm_has_feat_enum(vcpu->kvm, ID_AA64MMFR2_EL1, IDS, 0x0))
+		return undef_access(vcpu, p, r);
+
+	kvm_inject_sync(vcpu, kvm_vcpu_get_esr(vcpu));
+	return false;
+}
+
 enum sr_loc_attr {
 	SR_LOC_MEMORY	= 0,	  /* Register definitely in memory */
 	SR_LOC_LOADED	= BIT(0), /* Register on CPU, unless it cannot */
@@ -3396,9 +3406,9 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_CCSIDR_EL1), access_ccsidr },
 	{ SYS_DESC(SYS_CLIDR_EL1), access_clidr, reset_clidr, CLIDR_EL1,
 	  .set_user = set_clidr, .val = ~CLIDR_EL1_RES0 },
-	{ SYS_DESC(SYS_CCSIDR2_EL1), undef_access },
-	{ SYS_DESC(SYS_GMID_EL1), undef_access },
-	{ SYS_DESC(SYS_SMIDR_EL1), undef_access },
+	{ SYS_DESC(SYS_CCSIDR2_EL1), idst_access },
+	{ SYS_DESC(SYS_GMID_EL1), idst_access },
+	{ SYS_DESC(SYS_SMIDR_EL1), idst_access },
 	IMPLEMENTATION_ID(AIDR_EL1, GENMASK_ULL(63, 0)),
 	{ SYS_DESC(SYS_CSSELR_EL1), access_csselr, reset_unknown, CSSELR_EL1 },
 	ID_FILTERED(CTR_EL0, ctr_el0,
-- 
2.47.3


