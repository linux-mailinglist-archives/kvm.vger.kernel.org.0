Return-Path: <kvm+bounces-40625-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DF3E7A5943B
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 13:25:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 85DAE1881FEF
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 12:26:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA837229B1A;
	Mon, 10 Mar 2025 12:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FJMLbB4a"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20BD2226CFD;
	Mon, 10 Mar 2025 12:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741609513; cv=none; b=Xj0la3h6pkvhnYLs0LB85DHwxnIZ3fmSu1iEcyksswZlwdrs3qXELj3DDpDUwzdJLySH2sRnocmFXAmaZ3/zxUI1eAEYsosMlOJwKvri68/TCtaejbp7BPFXvol11NY1QJCl+9vhc7x2JovdHgLlC0djs2OFt3UfDFB0c/+ErvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741609513; c=relaxed/simple;
	bh=ZE+hPenVOTQeFf5J4FOVNMdUmE/JU4Ov7Z3QusKsApo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=roBXqzZ2yyhDsegob0yR2d1iIX/pvw4227UtPnEbXWZlm4GpLazM767LEfrnQeauehK9ZC7EwS4q3+IyjPzx6IBM4OeyymamJc7inCV5l5O6ljZLROE5YSVEwDrLsz8wm3dYDVSCyNnMlk+fbI0C+Mjh7zoQreDlptbEhPGj6MQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FJMLbB4a; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF181C4CEE5;
	Mon, 10 Mar 2025 12:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741609513;
	bh=ZE+hPenVOTQeFf5J4FOVNMdUmE/JU4Ov7Z3QusKsApo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FJMLbB4aRKh9jqihjUFkpSDFLKFZuKQP3mB4upMU0FgfICdxwxE+7sVf5FfYhVSQq
	 /w5cbBlaiF7hBqWNT3b0fc9linVJyeMVReGP3AqhEPmPr+TNAiSbJOojyTV9zDnQgx
	 lxocuL3zPm1XZ4qmx8o4LNMvJlz4Df6JSm6AquxNgYmRWwWH8pQPEG8zAtltGheVYV
	 cFPJzajIItaQ+cmHu6KJQJqHgTp3OaAY30k3imhGxcIdir+RwuWjP1UxcQLXPEEkMP
	 b7ayWiCj7zByKKH6aoFP7ZTYVvvaaJPTT0mRdkumxv0LyaSDwEDZCbv9BDI/pYLUTr
	 EbafbL85S0FUw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1trcBz-00CAea-3H;
	Mon, 10 Mar 2025 12:25:11 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH v2 05/23] KVM: arm64: Handle trapping of FEAT_LS64* instructions
Date: Mon, 10 Mar 2025 12:24:47 +0000
Message-Id: <20250310122505.2857610-6-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250310122505.2857610-1-maz@kernel.org>
References: <20250310122505.2857610-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, mark.rutland@arm.com, tabba@google.com
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
index 512d152233ff2..b2d11cd0447c1 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -294,6 +294,61 @@ static int handle_svc(struct kvm_vcpu *vcpu)
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
@@ -303,6 +358,7 @@ static exit_handle_fn arm_exit_handlers[] = {
 	[ESR_ELx_EC_CP14_LS]	= kvm_handle_cp14_load_store,
 	[ESR_ELx_EC_CP10_ID]	= kvm_handle_cp10_id,
 	[ESR_ELx_EC_CP14_64]	= kvm_handle_cp14_64,
+	[ESR_ELx_EC_OTHER]	= handle_other,
 	[ESR_ELx_EC_HVC32]	= handle_hvc,
 	[ESR_ELx_EC_SMC32]	= handle_smc,
 	[ESR_ELx_EC_HVC64]	= handle_hvc,
-- 
2.39.2


