Return-Path: <kvm+bounces-46478-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 174CFAB68E5
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 12:35:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4772E3AFD84
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 10:35:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DD642749F8;
	Wed, 14 May 2025 10:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vMQFKDwC"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1CC32741A0;
	Wed, 14 May 2025 10:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747218908; cv=none; b=aH4hXRPL2VOogxfI/G7nt3AD4gccGdEYznrx7DfA4lWrYjO3IKLLvv1wYE94Mne9sRb0xBudXvdtJP4fCoo5NxKKj86ZaRvEngqeAkZtdKKXV47ejCmwkjnIxXFtRXp26TVTcm5UsnvkQSKb9Kxhxdl1uUU6NkA1IKf2uwVjY8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747218908; c=relaxed/simple;
	bh=bpPQ+zBhwRDzt3LBMXgmgyLTiv/fCrkank4nbp6VcVo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Lp3qzf85nrOmFHdg1f2IdPfuQYIg7GMrqSrkzyIb22+ZIqizF89UMeWGDvA7muy7aiH17WJ4NEcJFan6ESRNwJ8L369E9KI6fvAnNR+4OTtlCQ9851ox2bplywSmpajdVrjwa6A2H/872CnQdiF2D+00jVk7s74n9or7oGBHujM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vMQFKDwC; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2233C4CEE9;
	Wed, 14 May 2025 10:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747218907;
	bh=bpPQ+zBhwRDzt3LBMXgmgyLTiv/fCrkank4nbp6VcVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vMQFKDwCXKzAXa6EBD34osbvddNb3xOAj5XbQfwZw2ZC4aKJTaztRNz+tqer8HcIK
	 v+3xmizmh1F9/+wQ6htLRsI5Qf7DarX7nfnKfMp32vzMKZJHXJIGI7ImeS6qUvx3VZ
	 /bUn8k+B/fwCWWgccyIntqZQsa6D5FGJzPKhNv5wZjmxWsEMIVWRsRMfNNp6hZ+5Jw
	 1AGNmy1LUAITOo8kM7bhc/UW3dzfarnxXVA1HKx8PRz/+WqJ7DYGo7U5BCU+J4Y34X
	 n3HsSpelwvsNOvjYwtqtxbNoNwodmDdqXRMtlMgdHXc7rpFKAGEefihogpxniHlj3R
	 ai7x47EOoHH2A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uF9S5-00Eos3-Rq;
	Wed, 14 May 2025 11:35:05 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: [PATCH v4 08/17] KVM: arm64: nv: Add userspace and guest handling of VNCR_EL2
Date: Wed, 14 May 2025 11:34:51 +0100
Message-Id: <20250514103501.2225951-9-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250514103501.2225951-1-maz@kernel.org>
References: <20250514103501.2225951-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, eric.auger@redhat.com, gankulkarni@os.amperecomputing.com
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
index c762919a2072d..f5ac454dcf66a 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -562,6 +562,8 @@ enum vcpu_sysreg {
 	VNCR(HDFGWTR_EL2),
 	VNCR(HAFGRTR_EL2),
 
+	VNCR(VNCR_EL2),
+
 	VNCR(CNTVOFF_EL2),
 	VNCR(CNTV_CVAL_EL0),
 	VNCR(CNTV_CTL_EL0),
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 806e9cf6049a6..32ea6e362bab1 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1400,6 +1400,9 @@ int kvm_init_nv_sysregs(struct kvm_vcpu *vcpu)
 	res0 |= ICH_HCR_EL2_DVIM | ICH_HCR_EL2_vSGIEOICount;
 	set_sysreg_masks(kvm, ICH_HCR_EL2, res0, res1);
 
+	/* VNCR_EL2 */
+	set_sysreg_masks(kvm, VNCR_EL2, VNCR_EL2_RES0, VNCR_EL2_RES1);
+
 out:
 	for (enum vcpu_sysreg sr = __SANITISED_REG_START__; sr < NR_SYS_REGS; sr++)
 		(void)__vcpu_sys_reg(vcpu, sr);
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 26e02e1723911..204470283ccc3 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2281,15 +2281,6 @@ static bool bad_redir_trap(struct kvm_vcpu *vcpu,
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
@@ -2299,6 +2290,9 @@ static bool bad_redir_trap(struct kvm_vcpu *vcpu,
 	.val = v,				\
 }
 
+#define EL2_REG(name, acc, rst, v)			\
+	EL2_REG_FILTERED(name, acc, rst, v, el2_visibility)
+
 #define EL2_REG_VNCR(name, rst, v)	EL2_REG(name, bad_vncr_trap, rst, v)
 #define EL2_REG_REDIR(name, rst, v)	EL2_REG(name, bad_redir_trap, rst, v)
 
@@ -2446,6 +2440,16 @@ static unsigned int sve_el2_visibility(const struct kvm_vcpu *vcpu,
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
@@ -3263,6 +3267,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 			 tcr2_el2_visibility),
 	EL2_REG_VNCR(VTTBR_EL2, reset_val, 0),
 	EL2_REG_VNCR(VTCR_EL2, reset_val, 0),
+	EL2_REG_FILTERED(VNCR_EL2, bad_vncr_trap, reset_val, 0,
+			 vncr_el2_visibility),
 
 	{ SYS_DESC(SYS_DACR32_EL2), undef_access, reset_unknown, DACR32_EL2 },
 	EL2_REG_VNCR(HDFGRTR_EL2, reset_val, 0),
-- 
2.39.2


