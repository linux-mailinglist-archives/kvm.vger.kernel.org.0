Return-Path: <kvm+bounces-38286-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4633FA36EF4
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 16:03:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3F54616F5CB
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 15:03:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62B211F37BA;
	Sat, 15 Feb 2025 15:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nrUd42Oy"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9687C1DF27F;
	Sat, 15 Feb 2025 15:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739631723; cv=none; b=JPto519AS3K9vYKUVzwk+OZFJ3K2WCtuBi+ESgKZjxyAAYoCgIWDjs1aUw1mU2Obtz99uSQ0tROZt+Gk69zD+8pvwlf2BQ9i2kWIdB3qK/4m0T/g7z3mlsLgOoKbkq3glbmRZ4f0S+4JQB4TBNN8egUDfFoR4j4ZhMaap1tNWc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739631723; c=relaxed/simple;
	bh=zkHr3vkzDC1kIdGLI1aElkjYHYfjk/IsB6KkkSw5XXM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=I5sJ6b+nzP0wJd6xJHDdkudh/4XbyP+hLSExwB4yw8+N8/guj/F8reKdc1WdikY3Facm0ZXDLgROGHKFD22yFJnqDtJnHiJzViH30gnGMmcY7u7fDbNK2YzkGEs0UTw6iqqa07u+nYU5Qs29PJZXLYCOw0UySD14hzl9jdUl55Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nrUd42Oy; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77A8AC4CEE9;
	Sat, 15 Feb 2025 15:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739631723;
	bh=zkHr3vkzDC1kIdGLI1aElkjYHYfjk/IsB6KkkSw5XXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nrUd42OyfvCH1SC3wCEszYBngm0+i3DA9zYt4hGbMtC7fjSETBHv0m+6lVKJoHGVG
	 cPxsQSv1Z9LGKCob2niUx6AhNCFj4Pbrpell6ZUENOPCpdhnCQgK55Ix5LOM4lJ2/O
	 ZVtxj1WZzR4DEujiGCixM3MWBG2d7dSlSFlrJmp4uJVzZ4MF9KKzNuXoYSiz/l/WSQ
	 1fxhWnPWv3CIwf+drsXxnb42G/sv5MYEDo+LIPDqWdklRgbjwd1vH63COLRKhTvpSg
	 XeTEMgmW0qQZpcwoICNscctf/Wg4m8GC/D771W2Lpm6P/wfQYaMuL6Ly6CESBrbCqc
	 rV7+uMKi/wMvA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tjJg9-004Nz6-Om;
	Sat, 15 Feb 2025 15:02:01 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: [PATCH 08/14] KVM: arm64: nv: Add userspace and guest handling of VNCR_EL2
Date: Sat, 15 Feb 2025 15:01:28 +0000
Message-Id: <20250215150134.3765791-9-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250215150134.3765791-1-maz@kernel.org>
References: <20250215150134.3765791-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, eric.auger@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Plug VNCR_EL2 in the vcpu_sysreg enum, define its RES0/RES1 bits,
and make it accessible to userspace when the VM is configured to
support FEAT_NV2.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |  2 ++
 arch/arm64/kvm/nested.c           |  3 +++
 arch/arm64/kvm/sys_regs.c         | 24 +++++++++++++++---------
 3 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index dd287ccaffdb7..9b91a9e97cdce 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -551,6 +551,8 @@ enum vcpu_sysreg {
 	VNCR(HDFGWTR_EL2),
 	VNCR(HAFGRTR_EL2),
 
+	VNCR(VNCR_EL2),
+
 	VNCR(CNTVOFF_EL2),
 	VNCR(CNTV_CVAL_EL0),
 	VNCR(CNTV_CTL_EL0),
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 6ae5ec43ddeaa..aed25a003750d 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1371,6 +1371,9 @@ int kvm_init_nv_sysregs(struct kvm_vcpu *vcpu)
 		res0 |= GENMASK(11, 8);
 	set_sysreg_masks(kvm, CNTHCTL_EL2, res0, res1);
 
+	/* VNCR_EL2 */
+	set_sysreg_masks(kvm, VNCR_EL2, VNCR_EL2_RES0, VNCR_EL2_RES1);
+
 out:
 	for (enum vcpu_sysreg sr = __SANITISED_REG_START__; sr < NR_SYS_REGS; sr++)
 		(void)__vcpu_sys_reg(vcpu, sr);
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 24eaff9379e75..cf1243dd04548 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2234,15 +2234,6 @@ static bool bad_redir_trap(struct kvm_vcpu *vcpu,
 			"trap of EL2 register redirected to EL1");
 }
 
-#define EL2_REG(name, acc, rst, v) {		\
-	SYS_DESC(SYS_##name),			\
-	.access = acc,				\
-	.reset = rst,				\
-	.reg = name,				\
-	.visibility = el2_visibility,		\
-	.val = v,				\
-}
-
 #define EL2_REG_FILTERED(name, acc, rst, v, filter) {	\
 	SYS_DESC(SYS_##name),			\
 	.access = acc,				\
@@ -2252,6 +2243,9 @@ static bool bad_redir_trap(struct kvm_vcpu *vcpu,
 	.val = v,				\
 }
 
+#define EL2_REG(name, acc, rst, v)			\
+	EL2_REG_FILTERED(name, acc, rst, v, el2_visibility)
+
 #define EL2_REG_VNCR(name, rst, v)	EL2_REG(name, bad_vncr_trap, rst, v)
 #define EL2_REG_REDIR(name, rst, v)	EL2_REG(name, bad_redir_trap, rst, v)
 
@@ -2407,6 +2401,16 @@ static unsigned int sve_el2_visibility(const struct kvm_vcpu *vcpu,
 	return __el2_visibility(vcpu, rd, sve_visibility);
 }
 
+static unsigned int vncr_el2_visibility(const struct kvm_vcpu *vcpu,
+					const struct sys_reg_desc *rd)
+{
+	if (el2_visibility(vcpu, rd) == 0 &&
+	    kvm_has_feat(vcpu->kvm, ID_AA64MMFR4_EL1, NV_frac, NV2_ONLY))
+		return 0;
+
+	return REG_HIDDEN;
+}
+
 static bool access_zcr_el2(struct kvm_vcpu *vcpu,
 			   struct sys_reg_params *p,
 			   const struct sys_reg_desc *r)
@@ -3054,6 +3058,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 			 tcr2_el2_visibility),
 	EL2_REG_VNCR(VTTBR_EL2, reset_val, 0),
 	EL2_REG_VNCR(VTCR_EL2, reset_val, 0),
+	EL2_REG_FILTERED(VNCR_EL2, bad_vncr_trap, reset_val, 0,
+			 vncr_el2_visibility),
 
 	{ SYS_DESC(SYS_DACR32_EL2), undef_access, reset_unknown, DACR32_EL2 },
 	EL2_REG_VNCR(HDFGRTR_EL2, reset_val, 0),
-- 
2.39.2


