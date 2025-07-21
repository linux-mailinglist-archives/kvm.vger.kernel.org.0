Return-Path: <kvm+bounces-52963-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B9CFCB0C128
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 12:20:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7B33616CA89
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 10:20:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 350B328EBFE;
	Mon, 21 Jul 2025 10:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QZCrWDO1"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5765428DF31;
	Mon, 21 Jul 2025 10:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753093208; cv=none; b=iiuvvkQhT9p7xhaeo919g6ID6IOf17tD1u5MPfuudr32QXjShgK6YjElonR9LjDY0mnxX0OvkzQ2DkLvKdreyCZQtOdgi3hvV/vBOTdeOiQG7/s8vMzmyecygDB62osZdlL/9j/ODW00OUHD9kvW63r97HCTC8xnInUhhe/KtkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753093208; c=relaxed/simple;
	bh=BquqU5n/Nne4PARiM5JWa12LO6qSYywpm9CHk+avLmc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DMtZtJIr0WDJaQ5a4Els8q+/m9hcq7VhjsNZ7MSGCf1ZN4o7V419SB12atOTMquIfIH931n2gbU2WVz70o+2LMxepAbXEczu5YqTPlW4s90zrkilfAuPGWj8YHaz7CP+6SL1rcZK5K6bcQgmTGT75vs1eO14HpkGogJ/lV68g28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QZCrWDO1; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23070C4CEED;
	Mon, 21 Jul 2025 10:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753093208;
	bh=BquqU5n/Nne4PARiM5JWa12LO6qSYywpm9CHk+avLmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QZCrWDO1mVtsgH3lTu7bcej0ZzWTfLjnD3GIyZo7vbsDoHb3m7VSFAzZSOjT8oEWf
	 cd7oXZKAnZEfxT37mSdC3KrMmqK5k+MJSD7ZQiutyCAS6hO/2s9JT+KDWOKhm0eGL1
	 t2wx8LQJXRlcFeE3XWD+4rdit3AqDM/qkBDxmQsZPuHWv+YQp1xoE6FQPqpcJaF3HJ
	 pa9wsO3rwHoncZwWD4h4JwANq7MbdoiwVobTowIPTmj0LUv01pazpFRCEsY0M3fQfv
	 fEOTnJKckFHMk2iLbN2zKjrYnSXVPKBhZi2IGCh0foka5IXE3PC5p0RhFwHZET5yrO
	 utfwY8+eTWJlQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1udncs-00HZDF-7U;
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
Subject: [PATCH 4/7] KVM: arm64: Handle RASv1p1 registers
Date: Mon, 21 Jul 2025 11:19:52 +0100
Message-Id: <20250721101955.535159-5-maz@kernel.org>
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

FEAT_RASv1p1 system registeres are not handled at all so far.
KVM will give an embarassed warning on the console and inject
an UNDEF, despite RASv1p1 being exposed to the guest on suitable HW.

Handle these registers similarly to FEAT_RAS, with the added fun
that there are *two* way to indicate the presence of FEAT_RASv1p1.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index aea50870d9f11..9fb2812106cb0 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2695,6 +2695,16 @@ static bool access_ras(struct kvm_vcpu *vcpu,
 	struct kvm *kvm = vcpu->kvm;
 
 	switch(reg_to_encoding(r)) {
+	case SYS_ERXPFGCDN_EL1:
+	case SYS_ERXPFGCTL_EL1:
+	case SYS_ERXPFGF_EL1:
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
@@ -3058,6 +3068,9 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_ERXCTLR_EL1), access_ras },
 	{ SYS_DESC(SYS_ERXSTATUS_EL1), access_ras },
 	{ SYS_DESC(SYS_ERXADDR_EL1), access_ras },
+	{ SYS_DESC(SYS_ERXPFGF_EL1), access_ras },
+	{ SYS_DESC(SYS_ERXPFGCTL_EL1), access_ras },
+	{ SYS_DESC(SYS_ERXPFGCDN_EL1), access_ras },
 	{ SYS_DESC(SYS_ERXMISC0_EL1), access_ras },
 	{ SYS_DESC(SYS_ERXMISC1_EL1), access_ras },
 
-- 
2.39.2


