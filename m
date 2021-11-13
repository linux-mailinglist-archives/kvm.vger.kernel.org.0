Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAA8944F07C
	for <lists+kvm@lfdr.de>; Sat, 13 Nov 2021 02:23:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235646AbhKMBZv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 20:25:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235639AbhKMBZs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Nov 2021 20:25:48 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B253C061766
        for <kvm@vger.kernel.org>; Fri, 12 Nov 2021 17:22:57 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id f32-20020a635560000000b002df057654faso4864891pgm.4
        for <kvm@vger.kernel.org>; Fri, 12 Nov 2021 17:22:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=VI4xUZX2SgaAUorlezds0frm9PtlAxFmUgo0ykk1Vjg=;
        b=scMwAu8uHMha4/BUOYBN/DHwd5kD3H4etP4vODOnebCHMA5+ZMA6XA+9WcxolUgdlA
         IkEEIKMtuSTcrV3AYHRHnSDc2WcM9fgefTudv5cKtUUbV8uM+vXW4BebOqMzPNm2bk5n
         1+Vzc5z+PGUzjyUPowlblOoOucYN25e/FMjNFU1M2x2NJ+Fzmg2z1O18lKq7B0fl44BU
         TTE3twuBRh3rrmNb4KjlyuzgT+l8jbGHkSsMgeFNAM3UvIkAaukhITdb7IXe5VZwRt0X
         By2MwSmIrgjScbvutz1/X08WcUy+yFlER9yr/Evb6Md//Nc8ZM021XHHRfypv+vq8SYF
         GXaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=VI4xUZX2SgaAUorlezds0frm9PtlAxFmUgo0ykk1Vjg=;
        b=MohJ5bWKHh7fQ5QPF7BX/1uOUcqWZrp/XVrPnGPvCEkaVulAspPHPv7/r+OS+n0nom
         HO65Wouwyo8jeV7mbkf6ubdtTTgtJsqL3KJDucEcBEcZr4q56OtGacz/4bhvIQw5/4mP
         4OEiaFUUrWe+9me9ynaGLrT/B0gPvJygkVRw69tok8L9X6P17Dm//sYypjUcQtzYS4IQ
         qw1Xz9HlUBiVlpW0+OpIKznAhXNQyAYVIz1vxsvQRHbipp3gdcELEuyAG89xAtzUP414
         ptZ+4E++dvelNDqs0x/fNA0ty5I2mABm0WG3sWqFoUToZaPPQn1sV+h2Hwk4ULw6ChmO
         peYQ==
X-Gm-Message-State: AOAM531DhX2Xk/pYqFDidlGmaQfzHJcYeNhPppvV+6AT/yJSdULKxFXo
        4mLpsZy5PuALpptUubIPtw47VhTXoBBh
X-Google-Smtp-Source: ABdhPJwqzrBvcTPCYoT1Tldzfbztz8BwdLZEi5012/xMNTVOkaH29q73tnA2xy0RwfBuUM0JzfMABilP0mzT
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:90b:1b06:: with SMTP id
 nu6mr23110635pjb.155.1636766576513; Fri, 12 Nov 2021 17:22:56 -0800 (PST)
Date:   Sat, 13 Nov 2021 01:22:28 +0000
In-Reply-To: <20211113012234.1443009-1-rananta@google.com>
Message-Id: <20211113012234.1443009-6-rananta@google.com>
Mime-Version: 1.0
References: <20211113012234.1443009-1-rananta@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [RFC PATCH v2 05/11] KVM: arm64: Add standard hypervisor firmware register
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce the firmware register to hold the standard hypervisor
service calls (owner value 5) as a bitmap. The bitmap represents
the features that'll be enabled for the guest, as configured by
the user-space. Currently, this includes support only for
Paravirtualized time, represented by bit-0.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/include/uapi/asm/kvm.h |  4 ++++
 arch/arm64/kvm/hypercalls.c       | 24 ++++++++++++++++++++++++
 arch/arm64/kvm/pvtime.c           |  3 +++
 include/kvm/arm_hypercalls.h      |  3 +++
 5 files changed, 35 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 1546a2f973ef..e8e540bd1fe5 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -113,6 +113,7 @@ struct hvc_reg_desc {
 	bool fw_reg_bmap_enabled;
 
 	struct hvc_fw_reg_bmap hvc_std_bmap;
+	struct hvc_fw_reg_bmap hvc_std_hyp_bmap;
 };
 
 struct kvm_arch {
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index d6e099ed14ef..5890cbcd6385 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -285,6 +285,10 @@ struct kvm_arm_copy_mte_tags {
 #define KVM_REG_ARM_STD_BIT_TRNG_V1_0		BIT(0)
 #define KVM_REG_ARM_STD_BMAP_BIT_MAX		0	/* Last valid bit */
 
+#define KVM_REG_ARM_STD_HYP_BMAP		KVM_REG_ARM_FW_REG(4)
+#define KVM_REG_ARM_STD_HYP_BIT_PV_TIME	BIT(0)
+#define KVM_REG_ARM_STD_HYP_BMAP_BIT_MAX	0	/* Last valid bit */
+
 /* SVE registers */
 #define KVM_REG_ARM64_SVE		(0x15 << KVM_REG_ARM_COPROC_SHIFT)
 
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index f5df7bc61146..b3320adc068c 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -84,6 +84,10 @@ bool kvm_hvc_call_supported(struct kvm_vcpu *vcpu, u32 func_id)
 	case ARM_SMCCC_TRNG_RND64:
 		return kvm_arm_fw_reg_feat_enabled(&hvc_desc->hvc_std_bmap,
 					KVM_REG_ARM_STD_BIT_TRNG_V1_0);
+	case ARM_SMCCC_HV_PV_TIME_FEATURES:
+	case ARM_SMCCC_HV_PV_TIME_ST:
+		return kvm_arm_fw_reg_feat_enabled(&hvc_desc->hvc_std_hyp_bmap,
+					KVM_REG_ARM_STD_HYP_BIT_PV_TIME);
 	default:
 		/* By default, allow the services that aren't listed here */
 		return true;
@@ -109,6 +113,9 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 		break;
 	case ARM_SMCCC_ARCH_FEATURES_FUNC_ID:
 		feature = smccc_get_arg1(vcpu);
+		if (!kvm_hvc_call_supported(vcpu, feature))
+			break;
+
 		switch (feature) {
 		case ARM_SMCCC_ARCH_WORKAROUND_1:
 			switch (arm64_get_spectre_v2_state()) {
@@ -194,6 +201,7 @@ static const u64 fw_reg_ids[] = {
 
 static const u64 fw_reg_bmap_ids[] = {
 	KVM_REG_ARM_STD_BMAP,
+	KVM_REG_ARM_STD_HYP_BMAP,
 };
 
 static void kvm_arm_fw_reg_init_hvc(struct hvc_reg_desc *hvc_desc,
@@ -212,6 +220,8 @@ void kvm_arm_init_hypercalls(struct kvm *kvm)
 
 	kvm_arm_fw_reg_init_hvc(hvc_desc, &hvc_desc->hvc_std_bmap,
 				KVM_REG_ARM_STD_BMAP, ARM_SMCCC_STD_FEATURES);
+	kvm_arm_fw_reg_init_hvc(hvc_desc, &hvc_desc->hvc_std_hyp_bmap,
+			KVM_REG_ARM_STD_HYP_BMAP, ARM_SMCCC_STD_HYP_FEATURES);
 }
 
 static void kvm_arm_fw_reg_sanitize(struct hvc_fw_reg_bmap *fw_reg_bmap)
@@ -259,6 +269,7 @@ void kvm_arm_sanitize_fw_regs(struct kvm *kvm)
 		goto out;
 
 	kvm_arm_fw_reg_sanitize(&hvc_desc->hvc_std_bmap);
+	kvm_arm_fw_reg_sanitize(&hvc_desc->hvc_std_hyp_bmap);
 
 out:
 	spin_unlock(&hvc_desc->lock);
@@ -310,6 +321,9 @@ static int kvm_arm_fw_reg_set_bmap(struct kvm *kvm,
 	case KVM_REG_ARM_STD_BMAP:
 		fw_reg_features = ARM_SMCCC_STD_FEATURES;
 		break;
+	case KVM_REG_ARM_STD_HYP_BMAP:
+		fw_reg_features = ARM_SMCCC_STD_HYP_FEATURES;
+		break;
 	default:
 		ret = -EINVAL;
 		goto out;
@@ -432,6 +446,13 @@ int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 		if (ret)
 			return ret;
 
+		break;
+	case KVM_REG_ARM_STD_HYP_BMAP:
+		ret = kvm_arm_fw_reg_get_bmap(kvm,
+					&hvc_desc->hvc_std_hyp_bmap, &val);
+		if (ret)
+			return ret;
+
 		break;
 	default:
 		return -ENOENT;
@@ -523,6 +544,9 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 		return 0;
 	case KVM_REG_ARM_STD_BMAP:
 		return kvm_arm_fw_reg_set_bmap(kvm, &hvc_desc->hvc_std_bmap, val);
+	case KVM_REG_ARM_STD_HYP_BMAP:
+		return kvm_arm_fw_reg_set_bmap(kvm,
+					&hvc_desc->hvc_std_hyp_bmap, val);
 	default:
 		return -ENOENT;
 	}
diff --git a/arch/arm64/kvm/pvtime.c b/arch/arm64/kvm/pvtime.c
index 78a09f7a6637..4fa436dbd0b7 100644
--- a/arch/arm64/kvm/pvtime.c
+++ b/arch/arm64/kvm/pvtime.c
@@ -37,6 +37,9 @@ long kvm_hypercall_pv_features(struct kvm_vcpu *vcpu)
 	u32 feature = smccc_get_arg1(vcpu);
 	long val = SMCCC_RET_NOT_SUPPORTED;
 
+	if (!kvm_hvc_call_supported(vcpu, feature))
+		return val;
+
 	switch (feature) {
 	case ARM_SMCCC_HV_PV_TIME_FEATURES:
 	case ARM_SMCCC_HV_PV_TIME_ST:
diff --git a/include/kvm/arm_hypercalls.h b/include/kvm/arm_hypercalls.h
index 8c6300d1cbaf..77c30e335f44 100644
--- a/include/kvm/arm_hypercalls.h
+++ b/include/kvm/arm_hypercalls.h
@@ -9,6 +9,9 @@
 #define ARM_SMCCC_STD_FEATURES \
 	GENMASK_ULL(KVM_REG_ARM_STD_BMAP_BIT_MAX, 0)
 
+#define ARM_SMCCC_STD_HYP_FEATURES \
+	GENMASK_ULL(KVM_REG_ARM_STD_HYP_BMAP_BIT_MAX, 0)
+
 int kvm_hvc_call_handler(struct kvm_vcpu *vcpu);
 
 static inline u32 smccc_get_function(struct kvm_vcpu *vcpu)
-- 
2.34.0.rc1.387.gb447b232ab-goog

