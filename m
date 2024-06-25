Return-Path: <kvm+bounces-20471-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 597EE916887
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 15:01:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BDF0CB25165
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 13:01:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77E3015EFDF;
	Tue, 25 Jun 2024 13:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cXOQh/+I"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 980651DFC5;
	Tue, 25 Jun 2024 13:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719320449; cv=none; b=PbTt9ScTuOPicVATuhGjDX2WMdeFIHtb/3YIHd8oyxOLSSMTy0r6RpaZvOtFEAkmjbhixCHuUMtTZQuTfNKpdq3webbWVMWwSjEG8mZzkAeXhMeWsLNJfC3kJjhdYvZO66YFtalivR2fLaiqehxmf0IIk1gKojrVvmgBjl6jMdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719320449; c=relaxed/simple;
	bh=LULpueO0jZsesKVwJsPjTXcMFrz6B1Z4uMKe90FdyLY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Zcjj2HQK/eTkeIrrWRUPyJG8mhv2MZArNmjiThx/6yYWYfuQO9T/T1UXgYYnUrGwOe+EgstkrJKPWSGE5wf5GCSbZBc+CRRyT2KUeWV3TnM31jmVRFyQPATBM9yoVGZWDFEHRCPR3Oc2xvhKaVTQYiSFlimJs0oLAPM2IIGKMcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cXOQh/+I; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B591C4AF09;
	Tue, 25 Jun 2024 13:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719320449;
	bh=LULpueO0jZsesKVwJsPjTXcMFrz6B1Z4uMKe90FdyLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cXOQh/+IUA9MXLB270T1KWLZGkZp1tFr8+N90RNOcYoqfu8WZ8vZzAEOrjhX+YUq7
	 2Xb3JuWSd+/KIsW3bONJK1XFcmFDe8Z4csStJGz7KVDFaYqGIANrhsaNXX8eDhEOES
	 HJglvSFLyvprzQOh0bXg9HOIEQJttgLTCudDc3xe/3WAxtQtHmyEvhos5cOGKN70Bq
	 LGTLe4biTbIFOT9SN3BUr6Z61tvqGN7g6xXk4iJQwhXHE3br+dfqSwAyXR5dE45g7R
	 sGl8SrujFeRtl35LtSkYPGxSvl2bCTjx7actRE7KMuH1u1VzDdGstFkJ3lnVLr7/X4
	 p7snbLuc+Nbtw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sM5mx-0079X4-E3;
	Tue, 25 Jun 2024 14:00:47 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>
Subject: [PATCH 2/5] KVM: arm64: Get rid of HCRX_GUEST_FLAGS
Date: Tue, 25 Jun 2024 14:00:38 +0100
Message-Id: <20240625130042.259175-3-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240625130042.259175-1-maz@kernel.org>
References: <20240625130042.259175-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

HCRX_GUEST_FLAGS gives random KVM hackers the impression that
they can stuff bits in this macro and unconditionally enable
features in the guest.

In general, this is wrong (we have been there with FEAT_MOPS,
and again with FEAT_TCRX).

Document that HCRX_EL2.SMPME is an exception rather than the rule,
and get rid of HCRX_GUEST_FLAGS.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_arm.h | 1 -
 arch/arm64/kvm/sys_regs.c        | 8 +++++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index e6682a3ace5af..d81cc746e0ebd 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -102,7 +102,6 @@
 #define HCR_HOST_NVHE_PROTECTED_FLAGS (HCR_HOST_NVHE_FLAGS | HCR_TSC)
 #define HCR_HOST_VHE_FLAGS (HCR_RW | HCR_TGE | HCR_E2H)
 
-#define HCRX_GUEST_FLAGS (HCRX_EL2_SMPME)
 #define HCRX_HOST_FLAGS (HCRX_EL2_MSCEn | HCRX_EL2_TCR2En | HCRX_EL2_EnFPM)
 
 /* TCR_EL2 Registers bits */
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 71996d36f3751..8e22232c4b0f4 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -4062,7 +4062,13 @@ void kvm_init_sysreg(struct kvm_vcpu *vcpu)
 		vcpu->arch.hcr_el2 |= HCR_TTLBOS;
 
 	if (cpus_have_final_cap(ARM64_HAS_HCX)) {
-		vcpu->arch.hcrx_el2 = HCRX_GUEST_FLAGS;
+		/*
+		 * In general, all HCRX_EL2 bits are gated by a feature.
+		 * The only reason we can set SMPME without checking any
+		 * feature is that its effects are not directly observable
+		 * from the guest.
+		 */
+		vcpu->arch.hcrx_el2 = HCRX_EL2_SMPME;
 
 		if (kvm_has_feat(kvm, ID_AA64ISAR2_EL1, MOPS, IMP))
 			vcpu->arch.hcrx_el2 |= (HCRX_EL2_MSCEn | HCRX_EL2_MCE2);
-- 
2.39.2


