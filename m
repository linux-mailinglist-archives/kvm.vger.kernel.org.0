Return-Path: <kvm+bounces-40627-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E4273A5943C
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 13:25:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 91D9D3A88A3
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 12:25:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8276229B15;
	Mon, 10 Mar 2025 12:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KdXfaTcv"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCC52227EAE;
	Mon, 10 Mar 2025 12:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741609513; cv=none; b=XcOzbbG726Ja9D4coQFDn/77ITBH4bQ+Kvv7/ydvTK/ZCvSXXaq2NiOokiDLg5LCE8u7tBbMEBiptuITyHUYm9guyPCWOVLq69TZsKe/Vi/0an9dXvhSZUnR4T6eo89iAGRiFSagpDRqcNIMjociNNZNQe8hxSwetmz0G064Wlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741609513; c=relaxed/simple;
	bh=ZD1y0xgxzq9f9Jo/IS2k524ME5JZt65ppnEfB//OQRw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qJv9qCzrFe1MLJm1FjETR1q6MniioHtEQDbq79w3nAzyJ5Na/j1+I8pDUsGsOE81S9XFT6V7qL/e5k0+FZyfDQa+xn5hXTrcmndm8wiR4+D0mnWGwLdldXb7nuqu1XkJwhSMcmOlwr7fM1Q9ejWT38Nt/cImRXIwNsUnLLrsEOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KdXfaTcv; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBE1EC4CEF7;
	Mon, 10 Mar 2025 12:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741609513;
	bh=ZD1y0xgxzq9f9Jo/IS2k524ME5JZt65ppnEfB//OQRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KdXfaTcvnr3wgA4J0AlNItmJ/J8Dx0y/I5wcxDwVuSfE2TOtXEq3pi93vgr3cdxm7
	 zPM+cDb3SvpwlN//TAIgbH79aUx8zfSI4xWl4Bfva4hhzCxGk+WeA4xuK05aUV53B0
	 HG+I29XUOnDY2Us/dykGu4e2Qhhq48233dEFH5o8eLGRR28woJgi/RuBMWHoSPT/92
	 KEgoOolhmdKSwfWbEb8E0JPDaEVIMLe+SF0BQXbRd4RPJcQqVu5F0nEzc3f74FVt6S
	 LUaEoJSFxJCqYxK0nZ2BNNUr2XZyU/C7ZEJyByOpX+BTRZGyHX4/Ondm3P5YEJ6pv+
	 4iauqUiOfgOMw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1trcBz-00CAea-TO;
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
Subject: [PATCH v2 08/23] KVM: arm64: Plug FEAT_GCS handling
Date: Mon, 10 Mar 2025 12:24:50 +0000
Message-Id: <20250310122505.2857610-9-maz@kernel.org>
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

We don't seem to be handling the GCS-specific exception class.
Handle it by delivering an UNDEF to the guest, and populate the
relevant trap bits.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/handle_exit.c | 11 +++++++++++
 arch/arm64/kvm/sys_regs.c    |  8 ++++++++
 2 files changed, 19 insertions(+)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index b2d11cd0447c1..bf08c44491b4a 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -294,6 +294,16 @@ static int handle_svc(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+static int kvm_handle_gcs(struct kvm_vcpu *vcpu)
+{
+	/* We don't expect GCS, so treat it with contempt */
+	if (kvm_has_feat(vcpu->kvm, ID_AA64PFR1_EL1, GCS, IMP))
+		WARN_ON_ONCE(1);
+
+	kvm_inject_undefined(vcpu);
+	return 1;
+}
+
 static int handle_other(struct kvm_vcpu *vcpu)
 {
 	bool is_l2 = vcpu_has_nv(vcpu) && !is_hyp_ctxt(vcpu);
@@ -376,6 +386,7 @@ static exit_handle_fn arm_exit_handlers[] = {
 	[ESR_ELx_EC_BRK64]	= kvm_handle_guest_debug,
 	[ESR_ELx_EC_FP_ASIMD]	= kvm_handle_fpasimd,
 	[ESR_ELx_EC_PAC]	= kvm_handle_ptrauth,
+	[ESR_ELx_EC_GCS]	= kvm_handle_gcs,
 };
 
 static exit_handle_fn kvm_get_exit_handler(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 18721c773475d..2ecd0d51a2dae 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -5056,6 +5056,14 @@ void kvm_calculate_traps(struct kvm_vcpu *vcpu)
 						HFGITR_EL2_nBRBIALL);
 	}
 
+	if (!kvm_has_feat(kvm, ID_AA64PFR1_EL1, GCS, IMP)) {
+		kvm->arch.fgu[HFGxTR_GROUP] |= (HFGxTR_EL2_nGCS_EL0 |
+						HFGxTR_EL2_nGCS_EL1);
+		kvm->arch.fgu[HFGITR_GROUP] |= (HFGITR_EL2_nGCSPUSHM_EL1 |
+						HFGITR_EL2_nGCSSTR_EL1 |
+						HFGITR_EL2_nGCSEPP);
+	}
+
 	set_bit(KVM_ARCH_FLAG_FGU_INITIALIZED, &kvm->arch.flags);
 out:
 	mutex_unlock(&kvm->arch.config_lock);
-- 
2.39.2


