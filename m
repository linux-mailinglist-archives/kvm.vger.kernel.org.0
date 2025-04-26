Return-Path: <kvm+bounces-44429-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BAFA8A9DA9E
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 14:30:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EAC121BA7553
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 12:30:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1453F2528FC;
	Sat, 26 Apr 2025 12:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iWPsQMWC"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31A192517B9;
	Sat, 26 Apr 2025 12:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745670535; cv=none; b=fU9o7OPLZrcdpgOOOES+Ak23itVew1lJhnjiXl0OK/oyBKcMEtnx6IAuTht8qolPbEyj5pyVb4fe3zzurQtxapm5wOvk0S8qlc5ayR2EsrecS6xWw/mU3CNQnqMdBpyTp7MEpSqc6BCWQ13pn13nnnygFlR/MbugqKd9YEWNQuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745670535; c=relaxed/simple;
	bh=JPZnkgKeH2BfI/uIT3Qi4WDVKYqDjgxeu8Gn2tox7AY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EyDLOMoZftFTOAobgP/x+YcoZfl3wsQKm4eWjSRweGB9m4CxEgdjE0vkDBGvmZD6NJyQZePQK9XLbC3u1dZ1uPjRg/GM7Hb8f+Cfiv46X4gEwzUUz024De4v3toNTsB5cNwnKaq/7nlMpvb5ONXlRuSF39oMODxKl033XsQWRyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iWPsQMWC; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1184CC4CEEA;
	Sat, 26 Apr 2025 12:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745670535;
	bh=JPZnkgKeH2BfI/uIT3Qi4WDVKYqDjgxeu8Gn2tox7AY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iWPsQMWC+l9u+v5NBt2l1hAIIi4lZXMWRyvGWnsGamBVH8dYH8s60UFgh3IeSghgT
	 4t1vBmHdm7Vi169L9Em+n/pMSwi/3Q/xzrktTWIH4KuLHqemzfvnFNJMK2JdnU2N38
	 JfUp3FCyXY/1tNifyHbONiHOMgVPbEBnA/thI4tq8Hled8SKLAjY4EhBtlrg7xekm6
	 QZw7lVSoGrfGjlD1+6DXMSyuoTaS+GdIa3hUEpypqQQuWWZKRCxeIto409RAstpjsd
	 rYozu3FNt4z2PaA8SQurtLe7IB9aJTwbcSCGOoo7rh+hl/xr+m9sdZvCATFWfLB1Dp
	 Sn2nce8p7v0dg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1u8eeL-0092VH-7n;
	Sat, 26 Apr 2025 13:28:53 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH v3 17/42] KVM: arm64: Handle trapping of FEAT_LS64* instructions
Date: Sat, 26 Apr 2025 13:28:11 +0100
Message-Id: <20250426122836.3341523-18-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250426122836.3341523-1-maz@kernel.org>
References: <20250426122836.3341523-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, mark.rutland@arm.com, tabba@google.com, will@kernel.org, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

We generally don't expect FEAT_LS64* instructions to trap, unless
they are trapped by a guest hypervisor.

Otherwise, this is just the guest playing tricks on us by using
an instruction that isn't advertised, which we handle with a well
deserved UNDEF.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/handle_exit.c | 56 ++++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index b73dc26bc44b4..636c14ed2bb82 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -298,6 +298,61 @@ static int handle_svc(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+static int handle_other(struct kvm_vcpu *vcpu)
+{
+	bool is_l2 = vcpu_has_nv(vcpu) && !is_hyp_ctxt(vcpu);
+	u64 hcrx = __vcpu_sys_reg(vcpu, HCRX_EL2);
+	u64 esr = kvm_vcpu_get_esr(vcpu);
+	u64 iss = ESR_ELx_ISS(esr);
+	struct kvm *kvm = vcpu->kvm;
+	bool allowed, fwd = false;
+
+	/*
+	 * We only trap for two reasons:
+	 *
+	 * - the feature is disabled, and the only outcome is to
+	 *   generate an UNDEF.
+	 *
+	 * - the feature is enabled, but a NV guest wants to trap the
+	 *   feature used my its L2 guest. We forward the exception in
+	 *   this case.
+	 *
+	 * What we don't expect is to end-up here if the guest is
+	 * expected be be able to directly use the feature, hence the
+	 * WARN_ON below.
+	 */
+	switch (iss) {
+	case ESR_ELx_ISS_OTHER_ST64BV:
+		allowed = kvm_has_feat(kvm, ID_AA64ISAR1_EL1, LS64, LS64_V);
+		if (is_l2)
+			fwd = !(hcrx & HCRX_EL2_EnASR);
+		break;
+	case ESR_ELx_ISS_OTHER_ST64BV0:
+		allowed = kvm_has_feat(kvm, ID_AA64ISAR1_EL1, LS64, LS64_ACCDATA);
+		if (is_l2)
+			fwd = !(hcrx & HCRX_EL2_EnAS0);
+		break;
+	case ESR_ELx_ISS_OTHER_LDST64B:
+		allowed = kvm_has_feat(kvm, ID_AA64ISAR1_EL1, LS64, LS64);
+		if (is_l2)
+			fwd = !(hcrx & HCRX_EL2_EnALS);
+		break;
+	default:
+		/* Clearly, we're missing something. */
+		WARN_ON_ONCE(1);
+		allowed = false;
+	}
+
+	WARN_ON_ONCE(allowed && !fwd);
+
+	if (allowed && fwd)
+		kvm_inject_nested_sync(vcpu, esr);
+	else
+		kvm_inject_undefined(vcpu);
+
+	return 1;
+}
+
 static exit_handle_fn arm_exit_handlers[] = {
 	[0 ... ESR_ELx_EC_MAX]	= kvm_handle_unknown_ec,
 	[ESR_ELx_EC_WFx]	= kvm_handle_wfx,
@@ -307,6 +362,7 @@ static exit_handle_fn arm_exit_handlers[] = {
 	[ESR_ELx_EC_CP14_LS]	= kvm_handle_cp14_load_store,
 	[ESR_ELx_EC_CP10_ID]	= kvm_handle_cp10_id,
 	[ESR_ELx_EC_CP14_64]	= kvm_handle_cp14_64,
+	[ESR_ELx_EC_OTHER]	= handle_other,
 	[ESR_ELx_EC_HVC32]	= handle_hvc,
 	[ESR_ELx_EC_SMC32]	= handle_smc,
 	[ESR_ELx_EC_HVC64]	= handle_hvc,
-- 
2.39.2


