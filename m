Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 847404C33A9
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 18:28:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232011AbiBXR1h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 12:27:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231744AbiBXR1K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 12:27:10 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25C1A278C95
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 09:26:21 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id g2-20020a170902740200b0014fc971527eso1417408pll.14
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 09:26:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=f7YVBmCb6IbcPz2I9pSRMYsNCE3tvWzh5vUe6Npy1Ak=;
        b=GIp3dFeze4hYb6KlcHmjeEgFI+VrVtEnbRgjGd32qlKA2YNcGaWP5tT+SNeDb5id8S
         OdR8AlBGI5a6PQqilkbfUfvxWLDDf+IXhx8WG/NOwhGsskYyy/CHYj+Zno+qpTUQEIZ2
         KaW+a/lIWjQmpI6XnKUUswrx/dBC3jyJp2SbUuhnRxsWZYjCUrDzAr/OCUvz7RrfQQSp
         V847UnL1nDMpusfG3u00l5lwbJkA8sSm6L1nHUC1cnsF35YkXe/TyPAjoHlSTAEQPe8k
         6QTrumKamOpp/qNO1f2Gc08fFiPg0Rz7NRXpzm4NEsT6QCisj6F+6SFEBlavPRBdSjqT
         A+iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=f7YVBmCb6IbcPz2I9pSRMYsNCE3tvWzh5vUe6Npy1Ak=;
        b=QNG0Q4psnt09CnaPQU60nerbkVUXxvpnVEbpDQzGhVBn9dNW9/7Gb+b07LTX4YZG0s
         1ZON9sF4NzGr2j4soVcwXAusOu2andwGWOKYnwzeC5UU7+h+ATwP7m9zbKYFTFcoTQ/r
         9dScIDFQyl3m0sOxoKTUJPxPLKCUr0GYja14yhMW+DDGV3CC5aZhbNO3paCRBbiaISGM
         gWK5NV4ABmXzT9qvv07bZQVS8P8H7YDwTbOPlKBpcNvZM8ZqyP8i32GzzVXdjVzCovsb
         4KhZmXWoWDFqne9z/3x1tIhEcbJ8PKoQ/YLJy1WWLp+UeZeenscQNHjKpEJd0Vzoik+l
         5xQA==
X-Gm-Message-State: AOAM5338xddTjL2QLvSjO0xq94wBWS+M03782FXEAvibbhoLhCIsZPZY
        1b5KQRldC7iPnVTUQ3+h6A0PPDOnN/ky
X-Google-Smtp-Source: ABdhPJxSCGu3k55BbAvghObP6sR447q+n09jYrxk+9b6zOi1NDp47823WoeG/9N4MDL4UVSEZtw++WwQmJLQ
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a05:6a00:1aca:b0:4e1:a2b6:5b9 with SMTP id
 f10-20020a056a001aca00b004e1a2b605b9mr3807079pfv.4.1645723580479; Thu, 24 Feb
 2022 09:26:20 -0800 (PST)
Date:   Thu, 24 Feb 2022 17:25:52 +0000
In-Reply-To: <20220224172559.4170192-1-rananta@google.com>
Message-Id: <20220224172559.4170192-7-rananta@google.com>
Mime-Version: 1.0
References: <20220224172559.4170192-1-rananta@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH v4 06/13] KVM: arm64: Add standard hypervisor firmware register
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
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce the firmware register to hold the standard hypervisor
service calls (owner value 5) as a bitmap. The bitmap represents
the features that'll be enabled for the guest, as configured by
the user-space. Currently, this includes support only for
Paravirtualized time, represented by bit-0.

The register is also added to the kvm_arm_vm_scope_fw_regs[] list
as it maintains its state per-VM.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  2 ++
 arch/arm64/include/uapi/asm/kvm.h |  4 ++++
 arch/arm64/kvm/guest.c            |  1 +
 arch/arm64/kvm/hypercalls.c       | 20 +++++++++++++++++++-
 include/kvm/arm_hypercalls.h      |  3 +++
 5 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 1909ced3208f..318148b69279 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -105,9 +105,11 @@ struct kvm_arch_memory_slot {
  * struct kvm_hvc_desc: KVM ARM64 hypercall descriptor
  *
  * @hvc_std_bmap: Bitmap of standard secure service calls
+ * @hvc_std_hyp_bmap: Bitmap of standard hypervisor service calls
  */
 struct kvm_hvc_desc {
 	u64 hvc_std_bmap;
+	u64 hvc_std_hyp_bmap;
 };
 
 struct kvm_arch {
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 2decc30d6b84..9a2caead7359 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -295,6 +295,10 @@ struct kvm_arm_copy_mte_tags {
 #define KVM_REG_ARM_STD_BIT_TRNG_V1_0		BIT(0)
 #define KVM_REG_ARM_STD_BMAP_BIT_MAX		0       /* Last valid bit */
 
+#define KVM_REG_ARM_STD_HYP_BMAP		KVM_REG_ARM_FW_BMAP_REG(1)
+#define KVM_REG_ARM_STD_HYP_BIT_PV_TIME		BIT(0)
+#define KVM_REG_ARM_STD_HYP_BMAP_BIT_MAX	0       /* Last valid bit */
+
 /* SVE registers */
 #define KVM_REG_ARM64_SVE		(0x15 << KVM_REG_ARM_COPROC_SHIFT)
 
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index d66e6c742bbe..c42426d6137e 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -66,6 +66,7 @@ static const u64 kvm_arm_vm_scope_fw_regs[] = {
 	KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1,
 	KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2,
 	KVM_REG_ARM_STD_BMAP,
+	KVM_REG_ARM_STD_HYP_BMAP,
 };
 
 /**
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 48c126c3da72..ebc0cc26cf2e 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -75,6 +75,10 @@ static bool kvm_hvc_call_supported(struct kvm_vcpu *vcpu, u32 func_id)
 	case ARM_SMCCC_TRNG_RND64:
 		return kvm_arm_fw_reg_feat_enabled(hvc_desc->hvc_std_bmap,
 						KVM_REG_ARM_STD_BIT_TRNG_V1_0);
+	case ARM_SMCCC_HV_PV_TIME_FEATURES:
+	case ARM_SMCCC_HV_PV_TIME_ST:
+		return kvm_arm_fw_reg_feat_enabled(hvc_desc->hvc_std_hyp_bmap,
+					KVM_REG_ARM_STD_HYP_BIT_PV_TIME);
 	default:
 		/* By default, allow the services that aren't listed here */
 		return true;
@@ -83,6 +87,7 @@ static bool kvm_hvc_call_supported(struct kvm_vcpu *vcpu, u32 func_id)
 
 int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 {
+	struct kvm_hvc_desc *hvc_desc = &vcpu->kvm->arch.hvc_desc;
 	u32 func_id = smccc_get_function(vcpu);
 	u64 val[4] = {SMCCC_RET_NOT_SUPPORTED};
 	u32 feature;
@@ -134,7 +139,10 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 			}
 			break;
 		case ARM_SMCCC_HV_PV_TIME_FEATURES:
-			val[0] = SMCCC_RET_SUCCESS;
+			if (kvm_arm_fw_reg_feat_enabled(
+					hvc_desc->hvc_std_hyp_bmap,
+					KVM_REG_ARM_STD_HYP_BIT_PV_TIME))
+				val[0] = SMCCC_RET_SUCCESS;
 			break;
 		}
 		break;
@@ -179,6 +187,7 @@ static const u64 kvm_arm_fw_reg_ids[] = {
 	KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1,
 	KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2,
 	KVM_REG_ARM_STD_BMAP,
+	KVM_REG_ARM_STD_HYP_BMAP,
 };
 
 void kvm_arm_init_hypercalls(struct kvm *kvm)
@@ -186,6 +195,7 @@ void kvm_arm_init_hypercalls(struct kvm *kvm)
 	struct kvm_hvc_desc *hvc_desc = &kvm->arch.hvc_desc;
 
 	hvc_desc->hvc_std_bmap = ARM_SMCCC_STD_FEATURES;
+	hvc_desc->hvc_std_hyp_bmap = ARM_SMCCC_STD_HYP_FEATURES;
 }
 
 int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu)
@@ -272,6 +282,9 @@ int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	case KVM_REG_ARM_STD_BMAP:
 		val = READ_ONCE(hvc_desc->hvc_std_bmap);
 		break;
+	case KVM_REG_ARM_STD_HYP_BMAP:
+		val = READ_ONCE(hvc_desc->hvc_std_hyp_bmap);
+		break;
 	default:
 		return -ENOENT;
 	}
@@ -294,6 +307,10 @@ static int kvm_arm_set_fw_reg_bmap(struct kvm_vcpu *vcpu, u64 reg_id, u64 val)
 		fw_reg_bmap = &hvc_desc->hvc_std_bmap;
 		fw_reg_features = ARM_SMCCC_STD_FEATURES;
 		break;
+	case KVM_REG_ARM_STD_HYP_BMAP:
+		fw_reg_bmap = &hvc_desc->hvc_std_hyp_bmap;
+		fw_reg_features = ARM_SMCCC_STD_HYP_FEATURES;
+		break;
 	default:
 		return -ENOENT;
 	}
@@ -398,6 +415,7 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 
 		return 0;
 	case KVM_REG_ARM_STD_BMAP:
+	case KVM_REG_ARM_STD_HYP_BMAP:
 		return kvm_arm_set_fw_reg_bmap(vcpu, reg_id, val);
 	default:
 		return -ENOENT;
diff --git a/include/kvm/arm_hypercalls.h b/include/kvm/arm_hypercalls.h
index 64d30b452809..a1cb6e839c74 100644
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
2.35.1.473.g83b2b277ed-goog

