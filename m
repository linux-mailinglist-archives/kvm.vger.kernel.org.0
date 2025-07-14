Return-Path: <kvm+bounces-52318-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D7D2AB03E95
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 14:27:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8F1743AA847
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 12:26:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1704F248F50;
	Mon, 14 Jul 2025 12:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jLUPtta3"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32797247294;
	Mon, 14 Jul 2025 12:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752496004; cv=none; b=i3RL2eOHAa5bGpgfIP/E01gJbPXNEqCah4pvIzXGTJXrHVaHDO4qXjMVIUciejIeAvX92dJBx29Xspm+OJsrrSDoTvkBw899YcUfDU3yODPA2MAMRxxzxK/8kpkDEwMvHmtWOrFqwldKRjSK6jcx0YncSZ1yZq4tKW2KAWqPv2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752496004; c=relaxed/simple;
	bh=yiBRnZF8C0L+8x0bFktDQLA16K927PmzOB5cfTo+bDc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GLnmX5q+jn0OglIHKgefB7+oz7JTt4hV3z15vXnz6t0q/kJXdOx8VK+b09577oHUba/tI6LJ+N2RTcMFnBVi5mAGsNN7HapAQVADqkYWMTjiwN+cVGmYGJXcH/MjRpYdclCceD+zzgRhg5zcU6VxtER4Zu+y+mNrb8ydu1p6zmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jLUPtta3; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEC0EC4CEF6;
	Mon, 14 Jul 2025 12:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752496003;
	bh=yiBRnZF8C0L+8x0bFktDQLA16K927PmzOB5cfTo+bDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jLUPtta3XYsfcmUjFlYXz/3u7AmtUGY/pQX9L0B50qG1hobRkf/kS4vn0kjK5YSp+
	 gtOVhhRbswJ1/jghJ5ATvFweu2MCtw7y1K6IqsPnvFx2tyQK3lVW33ylqoVjlJxXze
	 H5zHQUK9/H+nq04YQ/m3esgO6MkjNt/pWxvr6shOVSOAOKlwsTrfsKqP3yJA0YynDu
	 bzZk0KUyq0Uil0FHQBTekrhx15OcLTyqtZrUl2/HWm+lfuvGUZVtka1ZJPq2M2ymAY
	 6aVhTSX96TWYSjOKHrQL5Fkld4DgtdY818DzQQq7UzsEDSJ+GbQR0SZDuoMEStmy+v
	 AdP+xaVaugCaQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1ubIGY-00FW7V-0f;
	Mon, 14 Jul 2025 13:26:42 +0100
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
Subject: [PATCH 02/11] KVM: arm64: Don't advertise ICH_*_EL2 registers through GET_ONE_REG
Date: Mon, 14 Jul 2025 13:26:25 +0100
Message-Id: <20250714122634.3334816-3-maz@kernel.org>
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

It appears that exposing the GICv3 EL2 registers through the usual
sysreg interface is not consistent with the way we expose the EL1
registers. The latter are exposed via the GICv3 device interface
instead, and there is no reason why the EL2 registers should get
a different treatement.

Hide the registers from userspace until the GICv3 code grows the
required infrastructure.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 64 ++++++++++++++++++++++-----------------
 1 file changed, 37 insertions(+), 27 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 3f226cd5b502e..dceb4f8f242a7 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -772,6 +772,12 @@ static u64 reset_mpidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 	return mpidr;
 }
 
+static unsigned int hidden_visibility(const struct kvm_vcpu *vcpu,
+				      const struct sys_reg_desc *r)
+{
+	return REG_HIDDEN;
+}
+
 static unsigned int pmu_visibility(const struct kvm_vcpu *vcpu,
 				   const struct sys_reg_desc *r)
 {
@@ -2324,6 +2330,10 @@ static bool bad_redir_trap(struct kvm_vcpu *vcpu,
 	EL2_REG_FILTERED(name, acc, rst, v, el2_visibility)
 
 #define EL2_REG_VNCR(name, rst, v)	EL2_REG(name, bad_vncr_trap, rst, v)
+#define EL2_REG_VNCR_FILT(name, vis)			\
+	EL2_REG_FILTERED(name, bad_vncr_trap, reset_val, 0, vis)
+#define EL2_REG_VNCR_GICv3(name)			\
+	EL2_REG_VNCR_FILT(name, hidden_visibility)
 #define EL2_REG_REDIR(name, rst, v)	EL2_REG(name, bad_redir_trap, rst, v)
 
 /*
@@ -3372,40 +3382,40 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_RVBAR_EL2), undef_access },
 	{ SYS_DESC(SYS_RMR_EL2), undef_access },
 
-	EL2_REG_VNCR(ICH_AP0R0_EL2, reset_val, 0),
-	EL2_REG_VNCR(ICH_AP0R1_EL2, reset_val, 0),
-	EL2_REG_VNCR(ICH_AP0R2_EL2, reset_val, 0),
-	EL2_REG_VNCR(ICH_AP0R3_EL2, reset_val, 0),
-	EL2_REG_VNCR(ICH_AP1R0_EL2, reset_val, 0),
-	EL2_REG_VNCR(ICH_AP1R1_EL2, reset_val, 0),
-	EL2_REG_VNCR(ICH_AP1R2_EL2, reset_val, 0),
-	EL2_REG_VNCR(ICH_AP1R3_EL2, reset_val, 0),
+	EL2_REG_VNCR_GICv3(ICH_AP0R0_EL2),
+	EL2_REG_VNCR_GICv3(ICH_AP0R1_EL2),
+	EL2_REG_VNCR_GICv3(ICH_AP0R2_EL2),
+	EL2_REG_VNCR_GICv3(ICH_AP0R3_EL2),
+	EL2_REG_VNCR_GICv3(ICH_AP1R0_EL2),
+	EL2_REG_VNCR_GICv3(ICH_AP1R1_EL2),
+	EL2_REG_VNCR_GICv3(ICH_AP1R2_EL2),
+	EL2_REG_VNCR_GICv3(ICH_AP1R3_EL2),
 
 	{ SYS_DESC(SYS_ICC_SRE_EL2), access_gic_sre },
 
-	EL2_REG_VNCR(ICH_HCR_EL2, reset_val, 0),
+	EL2_REG_VNCR_GICv3(ICH_HCR_EL2),
 	{ SYS_DESC(SYS_ICH_VTR_EL2), access_gic_vtr },
 	{ SYS_DESC(SYS_ICH_MISR_EL2), access_gic_misr },
 	{ SYS_DESC(SYS_ICH_EISR_EL2), access_gic_eisr },
 	{ SYS_DESC(SYS_ICH_ELRSR_EL2), access_gic_elrsr },
-	EL2_REG_VNCR(ICH_VMCR_EL2, reset_val, 0),
-
-	EL2_REG_VNCR(ICH_LR0_EL2, reset_val, 0),
-	EL2_REG_VNCR(ICH_LR1_EL2, reset_val, 0),
-	EL2_REG_VNCR(ICH_LR2_EL2, reset_val, 0),
-	EL2_REG_VNCR(ICH_LR3_EL2, reset_val, 0),
-	EL2_REG_VNCR(ICH_LR4_EL2, reset_val, 0),
-	EL2_REG_VNCR(ICH_LR5_EL2, reset_val, 0),
-	EL2_REG_VNCR(ICH_LR6_EL2, reset_val, 0),
-	EL2_REG_VNCR(ICH_LR7_EL2, reset_val, 0),
-	EL2_REG_VNCR(ICH_LR8_EL2, reset_val, 0),
-	EL2_REG_VNCR(ICH_LR9_EL2, reset_val, 0),
-	EL2_REG_VNCR(ICH_LR10_EL2, reset_val, 0),
-	EL2_REG_VNCR(ICH_LR11_EL2, reset_val, 0),
-	EL2_REG_VNCR(ICH_LR12_EL2, reset_val, 0),
-	EL2_REG_VNCR(ICH_LR13_EL2, reset_val, 0),
-	EL2_REG_VNCR(ICH_LR14_EL2, reset_val, 0),
-	EL2_REG_VNCR(ICH_LR15_EL2, reset_val, 0),
+	EL2_REG_VNCR_GICv3(ICH_VMCR_EL2),
+
+	EL2_REG_VNCR_GICv3(ICH_LR0_EL2),
+	EL2_REG_VNCR_GICv3(ICH_LR1_EL2),
+	EL2_REG_VNCR_GICv3(ICH_LR2_EL2),
+	EL2_REG_VNCR_GICv3(ICH_LR3_EL2),
+	EL2_REG_VNCR_GICv3(ICH_LR4_EL2),
+	EL2_REG_VNCR_GICv3(ICH_LR5_EL2),
+	EL2_REG_VNCR_GICv3(ICH_LR6_EL2),
+	EL2_REG_VNCR_GICv3(ICH_LR7_EL2),
+	EL2_REG_VNCR_GICv3(ICH_LR8_EL2),
+	EL2_REG_VNCR_GICv3(ICH_LR9_EL2),
+	EL2_REG_VNCR_GICv3(ICH_LR10_EL2),
+	EL2_REG_VNCR_GICv3(ICH_LR11_EL2),
+	EL2_REG_VNCR_GICv3(ICH_LR12_EL2),
+	EL2_REG_VNCR_GICv3(ICH_LR13_EL2),
+	EL2_REG_VNCR_GICv3(ICH_LR14_EL2),
+	EL2_REG_VNCR_GICv3(ICH_LR15_EL2),
 
 	EL2_REG(CONTEXTIDR_EL2, access_rw, reset_val, 0),
 	EL2_REG(TPIDR_EL2, access_rw, reset_val, 0),
-- 
2.39.2


