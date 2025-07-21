Return-Path: <kvm+bounces-52961-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C404B0C126
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 12:20:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0365416B387
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 10:20:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD9C628E61C;
	Mon, 21 Jul 2025 10:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e/bOeeGh"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF5D128DF0F;
	Mon, 21 Jul 2025 10:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753093208; cv=none; b=mqqccKNAnXnKHgw28JKi5KU6Jm64Y1jwpzwq1ibffl8q5ZuL3uvxSgiMeEGPX7JfocpiOHK5QExAYdc0myXFIaX4JtS4gzTUiWvc7talkDXIXXCKyGgUSrkLT75m+WOShEKUwx627xkNDpprvFqr1HaX6fzHDLR5wE5+VRK22KU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753093208; c=relaxed/simple;
	bh=aU3ERR3QXKPxAdBKGuj6WvEx4vWELd23g27wVC/6O8U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sGkZ8FzzAiUNWZNm83MHQsIMi92IQydccPKaxlnl+bJP/+Tk7WFILWjkSd0lXeuEdG3fA4XBwPw6e8/xaZG+iYfO89j15xV8RATq0KC7lz4T2KnE9L9xugIwYbshEEXN5+GFk32NUi+fjLsO7s+NC+YEIaaVnYy1dT0/zv2AXOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e/bOeeGh; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE413C4CEF4;
	Mon, 21 Jul 2025 10:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753093207;
	bh=aU3ERR3QXKPxAdBKGuj6WvEx4vWELd23g27wVC/6O8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e/bOeeGhumpGirTKEEVLNgLFpqIqkwkLHcrgMdCAha3qEZYikGGIf+lKbrEbzhnYt
	 6YAFSrv/CcZ259ma57vVPP1TUD8AK9P6EWlmo5Mt2+hKdumFMltsg3E6PGa0V9zZmw
	 qi7LMlZswL661VfvPUPfF/1kw5RFFWHoTT1O67RQ0nIH9AcGoIGi9if3ncSNNdmpSi
	 pIXT+Pvvd6rA0tMdAMP5Q9MNec4bEpvWNStI44mwoUzRz8Jyn7Xs4W1pVn5xIWLsUS
	 He3xgxGOCsfTfM8K1UaaaxIlw1i9wGHJIhiwaAhwgDpq7IdjH14ppB1afHhXFFLYEQ
	 EF0bONN3rUUVA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1udncs-00HZDF-17;
	Mon, 21 Jul 2025 11:20:06 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 3/7] KVM: arm64: Make RAS registers UNDEF when RAS isn't advertised
Date: Mon, 21 Jul 2025 11:19:51 +0100
Message-Id: <20250721101955.535159-4-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250721101955.535159-1-maz@kernel.org>
References: <20250721101955.535159-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, will@kernel.org, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

We currently always expose FEAT_RAS when available on the host.

As we are about to make this feature selectable from userspace,
check for it being present before emulating register accesses
as RAZ/WI, and inject an UNDEF otherwise.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 33 +++++++++++++++++++++++++--------
 1 file changed, 25 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 9d8c47e706b96..aea50870d9f11 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2688,6 +2688,23 @@ static bool access_mdcr(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+static bool access_ras(struct kvm_vcpu *vcpu,
+		       struct sys_reg_params *p,
+		       const struct sys_reg_desc *r)
+{
+	struct kvm *kvm = vcpu->kvm;
+
+	switch(reg_to_encoding(r)) {
+	default:
+		if (!kvm_has_feat(kvm, ID_AA64PFR0_EL1, RAS, IMP)) {
+			kvm_inject_undefined(vcpu);
+			return false;
+		}
+	}
+
+	return trap_raz_wi(vcpu, p, r);
+}
+
 /*
  * For historical (ahem ABI) reasons, KVM treated MIDR_EL1, REVIDR_EL1, and
  * AIDR_EL1 as "invariant" registers, meaning userspace cannot change them.
@@ -3035,14 +3052,14 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_AFSR1_EL1), access_vm_reg, reset_unknown, AFSR1_EL1 },
 	{ SYS_DESC(SYS_ESR_EL1), access_vm_reg, reset_unknown, ESR_EL1 },
 
-	{ SYS_DESC(SYS_ERRIDR_EL1), trap_raz_wi },
-	{ SYS_DESC(SYS_ERRSELR_EL1), trap_raz_wi },
-	{ SYS_DESC(SYS_ERXFR_EL1), trap_raz_wi },
-	{ SYS_DESC(SYS_ERXCTLR_EL1), trap_raz_wi },
-	{ SYS_DESC(SYS_ERXSTATUS_EL1), trap_raz_wi },
-	{ SYS_DESC(SYS_ERXADDR_EL1), trap_raz_wi },
-	{ SYS_DESC(SYS_ERXMISC0_EL1), trap_raz_wi },
-	{ SYS_DESC(SYS_ERXMISC1_EL1), trap_raz_wi },
+	{ SYS_DESC(SYS_ERRIDR_EL1), access_ras },
+	{ SYS_DESC(SYS_ERRSELR_EL1), access_ras },
+	{ SYS_DESC(SYS_ERXFR_EL1), access_ras },
+	{ SYS_DESC(SYS_ERXCTLR_EL1), access_ras },
+	{ SYS_DESC(SYS_ERXSTATUS_EL1), access_ras },
+	{ SYS_DESC(SYS_ERXADDR_EL1), access_ras },
+	{ SYS_DESC(SYS_ERXMISC0_EL1), access_ras },
+	{ SYS_DESC(SYS_ERXMISC1_EL1), access_ras },
 
 	MTE_REG(TFSR_EL1),
 	MTE_REG(TFSRE0_EL1),
-- 
2.39.2


