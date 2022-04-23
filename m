Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23FE750C589
	for <lists+kvm@lfdr.de>; Sat, 23 Apr 2022 02:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231196AbiDWAGt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 20:06:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230344AbiDWAGf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 20:06:35 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C122020E3BC
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 17:03:40 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id q6-20020a170902eb8600b001588e49dcaaso5586691plg.9
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 17:03:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=mP1Uwgsnv1SK5QgD7IRfeGHJnynLFCdzyimuOyavtOc=;
        b=NmrAOPTLN/WSRCFZJc2Lu1QZJ3ptvSI+EFEBpPyARwpNChEY9lIHd5Mq/y0dFH6PKJ
         HY42n1PCA9mkz6/L+REDVE96dbZL2scUJ82B5nWmlsru77yoXsoIos7F/BteD7jg2bar
         p6NIFA2mROu4dgwYfIlLWaW5UnO1oDpl7bk51zltcw1pACOxekZNweFQzE+grp9BFUV2
         rclThtottNhdXuevYgUaQcC/3eSfgGVE1QlWXbkClatecStDErRKGliG6FGJR4GxYl+4
         san71cUeJtoJAWLmtr/FAIH9hatrOGDyUUTN9AAQxZV9O7kTX/3DZvM95pwZUSTtfyfA
         8trQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=mP1Uwgsnv1SK5QgD7IRfeGHJnynLFCdzyimuOyavtOc=;
        b=D+tLQ9HSVhWETact42PkhFx627f/1TA/6qwxJKf8R2g+IrmZTAqClWm4jyCS8H6mRp
         IvTGjQgHZZPSHyBhU0BXCOfdtlJUteseG3j7Vjz+kS1DvkgbJf64cVgMPeLoWrPP5+rW
         crEIv8yGEfaMLpZnBGbY1lGln7m07yHtb3P6e/d/VIXCcn9wpV6FwWf0SpGtBjdRwkSo
         0dPFhmbvObUaOC8Oj+5oHy/mVSK9Mzh9xAQvjwihL20eeG6eXuddXFb37ZgMxZ7og8Iy
         n9qgyQ/snl8QTBIuP7dRXjB1iOloubhQgiNzFXmkMUXVlgA1DAHk/7XS944lACmH9QxW
         B+tA==
X-Gm-Message-State: AOAM531336FdH0joRNjjsT9uhp44IGbAFXQw1eeiS3E9l2zw3UWZGzLA
        ySea9t5wvJo3j8ZflChdAMHtlzig4xKE
X-Google-Smtp-Source: ABdhPJwdYF9Hq6FjYJFE8CfsEDWbuxmRO1Mj6KqiAIfDU8iDs8ERGoc+XTD1L3G8uDC6tG+iALh6uu7Am/Po
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:aa7:90d5:0:b0:4e1:307c:d94a with SMTP id
 k21-20020aa790d5000000b004e1307cd94amr7551311pfk.38.1650672220245; Fri, 22
 Apr 2022 17:03:40 -0700 (PDT)
Date:   Sat, 23 Apr 2022 00:03:22 +0000
In-Reply-To: <20220423000328.2103733-1-rananta@google.com>
Message-Id: <20220423000328.2103733-4-rananta@google.com>
Mime-Version: 1.0
References: <20220423000328.2103733-1-rananta@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH v6 3/9] KVM: arm64: Add standard hypervisor firmware register
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
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

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  2 ++
 arch/arm64/include/uapi/asm/kvm.h |  3 +++
 arch/arm64/kvm/hypercalls.c       | 21 ++++++++++++++++++---
 include/kvm/arm_hypercalls.h      |  2 ++
 4 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index df07f4c10197..27d4b2a7970e 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -105,9 +105,11 @@ struct kvm_arch_memory_slot {
  * struct kvm_smccc_features: Descriptor the hypercall services exposed to the guests
  *
  * @std_bmap: Bitmap of standard secure service calls
+ * @std_hyp_bmap: Bitmap of standard hypervisor service calls
  */
 struct kvm_smccc_features {
 	unsigned long std_bmap;
+	unsigned long std_hyp_bmap;
 };
 
 struct kvm_arch {
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 0b79d2dc6ffd..9eecc7ee8c14 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -341,6 +341,9 @@ struct kvm_arm_copy_mte_tags {
 #define KVM_REG_ARM_STD_BMAP			KVM_REG_ARM_FW_FEAT_BMAP_REG(0)
 #define KVM_REG_ARM_STD_BIT_TRNG_V1_0		0
 
+#define KVM_REG_ARM_STD_HYP_BMAP		KVM_REG_ARM_FW_FEAT_BMAP_REG(1)
+#define KVM_REG_ARM_STD_HYP_BIT_PV_TIME		0
+
 /* Device Control API: ARM VGIC */
 #define KVM_DEV_ARM_VGIC_GRP_ADDR	0
 #define KVM_DEV_ARM_VGIC_GRP_DIST_REGS	1
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index df55a04d2fe8..f097bebdad39 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -72,8 +72,6 @@ static bool kvm_hvc_call_default_allowed(struct kvm_vcpu *vcpu, u32 func_id)
 	 */
 	case ARM_SMCCC_VERSION_FUNC_ID:
 	case ARM_SMCCC_ARCH_FEATURES_FUNC_ID:
-	case ARM_SMCCC_HV_PV_TIME_FEATURES:
-	case ARM_SMCCC_HV_PV_TIME_ST:
 	case ARM_SMCCC_VENDOR_HYP_CALL_UID_FUNC_ID:
 	case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
 	case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
@@ -95,6 +93,10 @@ static bool kvm_hvc_call_allowed(struct kvm_vcpu *vcpu, u32 func_id)
 	case ARM_SMCCC_TRNG_RND64:
 		return kvm_arm_fw_reg_feat_enabled(&smccc_feat->std_bmap,
 						KVM_REG_ARM_STD_BIT_TRNG_V1_0);
+	case ARM_SMCCC_HV_PV_TIME_FEATURES:
+	case ARM_SMCCC_HV_PV_TIME_ST:
+		return kvm_arm_fw_reg_feat_enabled(&smccc_feat->std_hyp_bmap,
+					KVM_REG_ARM_STD_HYP_BIT_PV_TIME);
 	default:
 		return kvm_hvc_call_default_allowed(vcpu, func_id);
 	}
@@ -102,6 +104,7 @@ static bool kvm_hvc_call_allowed(struct kvm_vcpu *vcpu, u32 func_id)
 
 int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 {
+	struct kvm_smccc_features *smccc_feat = &vcpu->kvm->arch.smccc_feat;
 	u32 func_id = smccc_get_function(vcpu);
 	u64 val[4] = {SMCCC_RET_NOT_SUPPORTED};
 	u32 feature;
@@ -165,7 +168,9 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 			}
 			break;
 		case ARM_SMCCC_HV_PV_TIME_FEATURES:
-			val[0] = SMCCC_RET_SUCCESS;
+			if (kvm_arm_fw_reg_feat_enabled(&smccc_feat->std_hyp_bmap,
+					KVM_REG_ARM_STD_HYP_BIT_PV_TIME))
+				val[0] = SMCCC_RET_SUCCESS;
 			break;
 		}
 		break;
@@ -211,6 +216,7 @@ static const u64 kvm_arm_fw_reg_ids[] = {
 	KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2,
 	KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3,
 	KVM_REG_ARM_STD_BMAP,
+	KVM_REG_ARM_STD_HYP_BMAP,
 };
 
 void kvm_arm_init_hypercalls(struct kvm *kvm)
@@ -218,6 +224,7 @@ void kvm_arm_init_hypercalls(struct kvm *kvm)
 	struct kvm_smccc_features *smccc_feat = &kvm->arch.smccc_feat;
 
 	smccc_feat->std_bmap = KVM_ARM_SMCCC_STD_FEATURES;
+	smccc_feat->std_hyp_bmap = KVM_ARM_SMCCC_STD_HYP_FEATURES;
 }
 
 int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu)
@@ -307,6 +314,9 @@ int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	case KVM_REG_ARM_STD_BMAP:
 		val = READ_ONCE(smccc_feat->std_bmap);
 		break;
+	case KVM_REG_ARM_STD_HYP_BMAP:
+		val = READ_ONCE(smccc_feat->std_hyp_bmap);
+		break;
 	default:
 		return -ENOENT;
 	}
@@ -329,6 +339,10 @@ static int kvm_arm_set_fw_reg_bmap(struct kvm_vcpu *vcpu, u64 reg_id, u64 val)
 		fw_reg_bmap = &smccc_feat->std_bmap;
 		fw_reg_features = KVM_ARM_SMCCC_STD_FEATURES;
 		break;
+	case KVM_REG_ARM_STD_HYP_BMAP:
+		fw_reg_bmap = &smccc_feat->std_hyp_bmap;
+		fw_reg_features = KVM_ARM_SMCCC_STD_HYP_FEATURES;
+		break;
 	default:
 		return -ENOENT;
 	}
@@ -430,6 +444,7 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 
 		return 0;
 	case KVM_REG_ARM_STD_BMAP:
+	case KVM_REG_ARM_STD_HYP_BMAP:
 		return kvm_arm_set_fw_reg_bmap(vcpu, reg->id, val);
 	default:
 		return -ENOENT;
diff --git a/include/kvm/arm_hypercalls.h b/include/kvm/arm_hypercalls.h
index 499b45b607b6..aadd6ae3ab72 100644
--- a/include/kvm/arm_hypercalls.h
+++ b/include/kvm/arm_hypercalls.h
@@ -8,8 +8,10 @@
 
 /* Last valid bits of the bitmapped firmware registers */
 #define KVM_REG_ARM_STD_BMAP_BIT_MAX		0
+#define KVM_REG_ARM_STD_HYP_BMAP_BIT_MAX	0
 
 #define KVM_ARM_SMCCC_STD_FEATURES		GENMASK(KVM_REG_ARM_STD_BMAP_BIT_MAX, 0)
+#define KVM_ARM_SMCCC_STD_HYP_FEATURES		GENMASK(KVM_REG_ARM_STD_HYP_BMAP_BIT_MAX, 0)
 
 int kvm_hvc_call_handler(struct kvm_vcpu *vcpu);
 
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

