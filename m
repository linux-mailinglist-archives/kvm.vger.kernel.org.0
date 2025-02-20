Return-Path: <kvm+bounces-38703-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F860A3DBB3
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 14:50:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CCC97177C68
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 13:50:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4AD31FE472;
	Thu, 20 Feb 2025 13:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s6wwEOnu"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD1B71E5B9D;
	Thu, 20 Feb 2025 13:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740059355; cv=none; b=U6+DC5b8mTQ0/3rQRHgywYy7ZqqlxrerIpnFFaT/Ayy7yxq0Xnzvo/wcvMsWqMU+XQBevivRbnLUQGOXLaoRd7NcLbKXsaTp1TWac+OKsV/ti2KN7t90qWkRqyjACLy0l6jsS9smN+yLGCnImJ+gl5rfeV2lOtQ+V5pLKMgqrqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740059355; c=relaxed/simple;
	bh=Cptvvdg58Mif3ou0/tPyf1Nbz5VIb9W2RdSQkk+mm0A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CoHr6eCw3Nr4f9FtWQEs/DDzEAj6f3E8D1oPh+Dq+1c7Kmqqupt5CDHbSJ7Ecxmefeq81t31J81A4bKAdRsm9OzQ1s5pDOJQL0/g/HfBd0Vu3+cUwYxvNSnWahq4p49p+Ajj5V6NAnJ0fIZTgI0HTKFThCZNvv+uT9+RUv0MyqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s6wwEOnu; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57FC2C4CEE2;
	Thu, 20 Feb 2025 13:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740059355;
	bh=Cptvvdg58Mif3ou0/tPyf1Nbz5VIb9W2RdSQkk+mm0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s6wwEOnu+1WfeswTlWT8YKjD4yPv2MymZH39RYcqZteurXcUW7IxTtWBG1tLGEvqJ
	 u4AHbTmsvLEZoVaLLG5lotgVx1zST5i1iwcRFnuNTsfAJiNQT4TkpptaZIdsslKFfz
	 xEsWzm0Fiu11BY6e+zpYwecN7ymIHu7RTWt/BpuedO+8sSx6vsdBPn2ndjhmFyGDFn
	 PkDiCVuu0u0L1HKXUCAiNpDdIiFJ2Dzssgkwt0N6xDscCId5sHtwAhjirhFu3opzxj
	 +dG/fCeeKK0yUED3bCiMHtQ78pSPua7eBGBZn7tWccjI3Q3s4umij9bT8h2BBLXEeD
	 i0Zl9R/VtahRw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tl6vR-006DXp-Ij;
	Thu, 20 Feb 2025 13:49:13 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	gankulkarni@os.amperecomputing.com
Subject: [PATCH v2 10/14] KVM: arm64: Allow userspace to limit NV support to nVHE
Date: Thu, 20 Feb 2025 13:49:03 +0000
Message-Id: <20250220134907.554085-11-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250220134907.554085-1-maz@kernel.org>
References: <20250220134907.554085-1-maz@kernel.org>
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

NV is hard. No kidding.

In order to make things simpler, we have established that NV would
support two mutually exclusive configurations:

- VHE-only, and supporting recursive virtualisation

- mVHE-only, and not supporting recursive virtualisation

For that purpose, introduce a new vcpu feature flag that denotes
the second configuration. We use this flag to limit the idregs
further.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/uapi/asm/kvm.h |  1 +
 arch/arm64/kvm/nested.c           | 28 ++++++++++++++++++++++++++--
 2 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 568bf858f3198..3bcab2a106c98 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -105,6 +105,7 @@ struct kvm_regs {
 #define KVM_ARM_VCPU_PTRAUTH_ADDRESS	5 /* VCPU uses address authentication */
 #define KVM_ARM_VCPU_PTRAUTH_GENERIC	6 /* VCPU uses generic authentication */
 #define KVM_ARM_VCPU_HAS_EL2		7 /* Support nested virtualization */
+#define KVM_ARM_VCPU_HAS_EL2_E2H0	8 /* Limit NV support to E2H RES0 */
 
 struct kvm_vcpu_init {
 	__u32 target;
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 96d1d300e79f9..5ec5acb6310e9 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -51,6 +51,10 @@ int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu)
 	struct kvm_s2_mmu *tmp;
 	int num_mmus, ret = 0;
 
+	if (test_bit(KVM_ARM_VCPU_HAS_EL2_E2H0, kvm->arch.vcpu_features) &&
+	    !cpus_have_final_cap(ARM64_HAS_HCR_NV1))
+		return -EINVAL;
+
 	/*
 	 * Let's treat memory allocation failures as benign: If we fail to
 	 * allocate anything, return an error and keep the allocated array
@@ -894,6 +898,9 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 val)
 			ID_AA64MMFR1_EL1_HPDS	|
 			ID_AA64MMFR1_EL1_VH	|
 			ID_AA64MMFR1_EL1_VMIDBits);
+		/* FEAT_E2H0 implies no VHE */
+		if (test_bit(KVM_ARM_VCPU_HAS_EL2_E2H0, kvm->arch.vcpu_features))
+			val &= ~ID_AA64MMFR1_EL1_VH;
 		break;
 
 	case SYS_ID_AA64MMFR2_EL1:
@@ -909,8 +916,25 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 val)
 		break;
 
 	case SYS_ID_AA64MMFR4_EL1:
-		val = SYS_FIELD_PREP_ENUM(ID_AA64MMFR4_EL1, NV_frac, NV2_ONLY);
-		val |= SYS_FIELD_PREP_ENUM(ID_AA64MMFR4_EL1, E2H0, NI_NV1);
+		/*
+		 * You get EITHER
+		 *
+		 * - FEAT_VHE without FEAT_E2H0
+		 * - FEAT_NV limited to FEAT_NV2
+		 * - HCR_EL2.NV1 being RES0
+		 *
+		 * OR
+		 *
+		 * - FEAT_E2H0 without FEAT_VHE nor FEAT_NV
+		 *
+		 * Life is too short for anything else.
+		 */
+		if (test_bit(KVM_ARM_VCPU_HAS_EL2_E2H0, kvm->arch.vcpu_features)) {
+			val = 0;
+		} else {
+			val = SYS_FIELD_PREP_ENUM(ID_AA64MMFR4_EL1, NV_frac, NV2_ONLY);
+			val |= SYS_FIELD_PREP_ENUM(ID_AA64MMFR4_EL1, E2H0, NI_NV1);
+		}
 		break;
 
 	case SYS_ID_AA64DFR0_EL1:
-- 
2.39.2


