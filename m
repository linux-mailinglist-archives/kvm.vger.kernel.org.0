Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDD0C517AE7
	for <lists+kvm@lfdr.de>; Tue,  3 May 2022 01:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230112AbiEBXoa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 May 2022 19:44:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbiEBXme (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 May 2022 19:42:34 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB0232FFF7
        for <kvm@vger.kernel.org>; Mon,  2 May 2022 16:39:03 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id l6-20020a170903120600b0014f43ba55f3so7200749plh.11
        for <kvm@vger.kernel.org>; Mon, 02 May 2022 16:39:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=2pS0hWgdcRkNq6G/AG55Sf0c4w4fc3fRzcRztfm+yWk=;
        b=GtU4SgSxO0cJLd7SyfV+bBd/e/2VdhxQkOfz8942QZ6RHqtRSA2C2b170+KQG0Ce01
         ++WxiMfFdvz6EkBCG3NDgk2DCqwI/4W7NLZHvkdZE2WIujWVHYM9hhCDrOGhkU/SPa+L
         pfyoMyNCrMGHCND8hxqNCWACP4I9KguVW4dvn7eqLTEDHAdLaz4kBFh5oNv0Yy20Ybgm
         7k7S6Wt/5C/6iF5iFGmWwx9HcwegPVEJ3kVf7UEx29aYPTciZQKrtSs1m/oLch5Ssz0m
         Kw9QE2Utj4pgNfEy1ZQxjkWqKnA3Em+UPFoSAYxOOTZJ074loWot3CSxX+AVn0uf9Arj
         8vvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=2pS0hWgdcRkNq6G/AG55Sf0c4w4fc3fRzcRztfm+yWk=;
        b=JbRas6icxggUzYB0TPyx3r53ZsPMGr6F0T/TtiFg0nj5ZLEMumgTlj2TnKpwqhw1cL
         41Xn6JGYGTfNXTko52xJN1qa0seFLLym9h8+fZBxK9JSsinOLgYbADBcPcf77ajledfg
         Ydvd25LrnZPwou5E+qmWcnOXfCRdPnwRQ2DPxDWEw81pd8qG4goMY8fychyjlAIP38Hj
         8OAD2Sb1GwSKXbD6G/NAuhP85RCNaEJJPzryNfzPQYAqIciwHyzHVF3JIb6QYhAtSAIt
         m5CI8w/B1D+TDB8k3jagTLUFNjCn6leeT4PAI6Le7TPZ23dK+nMqHaD0O3O6cR+q3ExR
         Ngjg==
X-Gm-Message-State: AOAM533TMUliKmjRAUPDpSUXbrNMF6uFWnI1ICb1UxCx5zCWDjwjIXIL
        LgIYbqIuBHFPu4R2JPfa3ygBSwp/ihdF
X-Google-Smtp-Source: ABdhPJwFb/AtX13N7sj14zodiD0VRVFe7aLDUk+R4QqXEYoR67zFerFbvOaWwX6sfpxIZlYCwfi+92NDbCt/
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a05:6a00:1a4d:b0:50d:5921:1a8f with SMTP
 id h13-20020a056a001a4d00b0050d59211a8fmr13347502pfv.64.1651534743200; Mon,
 02 May 2022 16:39:03 -0700 (PDT)
Date:   Mon,  2 May 2022 23:38:47 +0000
In-Reply-To: <20220502233853.1233742-1-rananta@google.com>
Message-Id: <20220502233853.1233742-4-rananta@google.com>
Mime-Version: 1.0
References: <20220502233853.1233742-1-rananta@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH v7 3/9] KVM: arm64: Add standard hypervisor firmware register
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
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Gavin Shan <gshan@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
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
Reviewed-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/include/asm/kvm_host.h |  2 ++
 arch/arm64/include/uapi/asm/kvm.h |  3 +++
 arch/arm64/kvm/hypercalls.c       | 21 ++++++++++++++++++---
 include/kvm/arm_hypercalls.h      |  2 ++
 4 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index fef597af0beb..281dfcfd0a4e 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -105,9 +105,11 @@ struct kvm_arch_memory_slot {
  * struct kvm_smccc_features: Descriptor of the hypercall services exposed to the guests
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
index 5c53fd1f5690..38440e0bd4b4 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -72,8 +72,6 @@ static bool kvm_hvc_call_default_allowed(u32 func_id)
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
 		return kvm_hvc_call_default_allowed(func_id);
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
@@ -442,6 +456,7 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 
 		return 0;
 	case KVM_REG_ARM_STD_BMAP:
+	case KVM_REG_ARM_STD_HYP_BMAP:
 		return kvm_arm_set_fw_reg_bmap(vcpu, reg->id, val);
 	default:
 		return -ENOENT;
diff --git a/include/kvm/arm_hypercalls.h b/include/kvm/arm_hypercalls.h
index c832e8411609..00f9f1b1dc16 100644
--- a/include/kvm/arm_hypercalls.h
+++ b/include/kvm/arm_hypercalls.h
@@ -8,8 +8,10 @@
 
 /* Last valid bit of the bitmapped firmware registers */
 #define KVM_REG_ARM_STD_BMAP_BIT_MAX		0
+#define KVM_REG_ARM_STD_HYP_BMAP_BIT_MAX	0
 
 #define KVM_ARM_SMCCC_STD_FEATURES		GENMASK(KVM_REG_ARM_STD_BMAP_BIT_MAX, 0)
+#define KVM_ARM_SMCCC_STD_HYP_FEATURES		GENMASK(KVM_REG_ARM_STD_HYP_BMAP_BIT_MAX, 0)
 
 int kvm_hvc_call_handler(struct kvm_vcpu *vcpu);
 
-- 
2.36.0.464.gb9c8b46e94-goog

