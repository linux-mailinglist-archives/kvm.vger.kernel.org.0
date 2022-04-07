Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B44334F703B
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 03:18:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237339AbiDGBUo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 21:20:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240432AbiDGBUA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 21:20:00 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F483186894
        for <kvm@vger.kernel.org>; Wed,  6 Apr 2022 18:16:18 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id q13-20020a638c4d000000b003821725ad66so2270565pgn.23
        for <kvm@vger.kernel.org>; Wed, 06 Apr 2022 18:16:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=nVjr47POGBC3EXh5NnqgjDaWypqAXR5XHk3JbhNyB5Q=;
        b=UEHOviag/BPM19H+OoV8/7haDhyLRHPmFT6c36z/LhTHTL9XgN7R6UoUHz00VXYzWK
         q0WFP3B4ycjNKRSSpdSG6gAkiiN61agfFYlh5CUuCAhWINLpY2ILHm3mI+ybDfQH49yd
         Pfitp3CWvCIFGSBal/d9c6GKiXGrJGSxKU0fiMSzMlAGZ0POtU5cIZR8mUOacnFGy5dq
         hIWa/NfNhNYdGSAN77qgHlWn6IKNolWI8LKU/fB+3KvuU9rK5TN2oqjR3R0icroTkrnh
         sp6xwTtw0jmeGayySb0faJwkub8h1KOvf6mkLlxbp7aUiDHREJO46cEumeJT9wrOO+Z5
         x6Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=nVjr47POGBC3EXh5NnqgjDaWypqAXR5XHk3JbhNyB5Q=;
        b=BcARGWkjH+cPvaOPcc0ao5ngfs8xlFr2h7my8XlmKq0E6e5bBJoboPKmu3nYtXU3E3
         SGjCus8I+6vMQSOPJpC1LjvW48GaWq0LzZSrxZkS9xEC62kDcfIAaCUAt0HWe5X8/JyE
         mD8bqgootdXbKJy6xwx2GkWyiw7BbSwmUzNlRCR5uziYynUCOzk90BDTdsJ8IkFaRc+O
         W5uRqgPS6vE9OPWEiOClaXM7iQQ0ZAHmuQgIkBFzmeY7jUPK3KQX64sjOHaXPJ+Eqsfz
         QMwPCNIxaSmD9ZawQQZhyx8fCOWBaJOSUKZGiNvRTBtU4E8tyjDh5TZ8wFqIVzofmvzn
         pokA==
X-Gm-Message-State: AOAM531oBZZhDZKqJEc7w/xGcoLjsEOsVTr7CEht1SYFYD++Uu2Sj7so
        EZIZYrFpOfeFbtnF93em1i3IgjOZeFSu
X-Google-Smtp-Source: ABdhPJwc+GoBjiuo/AxxjHJhbzj+oGH5DanT5ZUY9CMxN11S7Op0CsHjzsHMm0TNj0CkPK8p+4CTjr7SCvXQ
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:902:cecb:b0:154:6f46:a5d6 with SMTP id
 d11-20020a170902cecb00b001546f46a5d6mr11461482plg.92.1649294177690; Wed, 06
 Apr 2022 18:16:17 -0700 (PDT)
Date:   Thu,  7 Apr 2022 01:15:58 +0000
In-Reply-To: <20220407011605.1966778-1-rananta@google.com>
Message-Id: <20220407011605.1966778-4-rananta@google.com>
Mime-Version: 1.0
References: <20220407011605.1966778-1-rananta@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v5 03/10] KVM: arm64: Add standard hypervisor firmware register
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

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  2 ++
 arch/arm64/include/uapi/asm/kvm.h |  3 +++
 arch/arm64/kvm/hypercalls.c       | 21 ++++++++++++++++++---
 include/kvm/arm_hypercalls.h      |  4 ++++
 4 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 6e663383d7b4..20165242ebd9 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -105,9 +105,11 @@ struct kvm_arch_memory_slot {
  * struct kvm_smccc_features: Descriptor the hypercall services exposed to the guests
  *
  * @std_bmap: Bitmap of standard secure service calls
+ * @std_hyp_bmap: Bitmap of standard hypervisor service calls
  */
 struct kvm_smccc_features {
 	u64 std_bmap;
+	u64 std_hyp_bmap;
 };
 
 struct kvm_arch {
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 56e4bc58a355..67353bf4e69d 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -341,6 +341,9 @@ struct kvm_arm_copy_mte_tags {
 #define KVM_REG_ARM_STD_BMAP			KVM_REG_ARM_FW_FEAT_BMAP_REG(0)
 #define KVM_REG_ARM_STD_BIT_TRNG_V1_0		BIT(0)
 
+#define KVM_REG_ARM_STD_HYP_BMAP		KVM_REG_ARM_FW_FEAT_BMAP_REG(1)
+#define KVM_REG_ARM_STD_HYP_BIT_PV_TIME		BIT(0)
+
 /* Device Control API: ARM VGIC */
 #define KVM_DEV_ARM_VGIC_GRP_ADDR	0
 #define KVM_DEV_ARM_VGIC_GRP_DIST_REGS	1
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index cf04b5ee5f56..64ae6c7e7145 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -65,8 +65,6 @@ static void kvm_ptp_get_time(struct kvm_vcpu *vcpu, u64 *val)
 static const u32 hvc_func_default_allowed_list[] = {
 	ARM_SMCCC_VERSION_FUNC_ID,
 	ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
-	ARM_SMCCC_HV_PV_TIME_FEATURES,
-	ARM_SMCCC_HV_PV_TIME_ST,
 	ARM_SMCCC_VENDOR_HYP_CALL_UID_FUNC_ID,
 	ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID,
 	ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID,
@@ -100,6 +98,10 @@ static bool kvm_hvc_call_allowed(struct kvm_vcpu *vcpu, u32 func_id)
 	case ARM_SMCCC_TRNG_RND64:
 		return kvm_arm_fw_reg_feat_enabled(smccc_feat->std_bmap,
 						KVM_REG_ARM_STD_BIT_TRNG_V1_0);
+	case ARM_SMCCC_HV_PV_TIME_FEATURES:
+	case ARM_SMCCC_HV_PV_TIME_ST:
+		return kvm_arm_fw_reg_feat_enabled(smccc_feat->std_hyp_bmap,
+					KVM_REG_ARM_STD_HYP_BIT_PV_TIME);
 	default:
 		return kvm_hvc_call_default_allowed(vcpu, func_id);
 	}
@@ -107,6 +109,7 @@ static bool kvm_hvc_call_allowed(struct kvm_vcpu *vcpu, u32 func_id)
 
 int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 {
+	struct kvm_smccc_features *smccc_feat = &vcpu->kvm->arch.smccc_feat;
 	u32 func_id = smccc_get_function(vcpu);
 	u64 val[4] = {SMCCC_RET_NOT_SUPPORTED};
 	u32 feature;
@@ -170,7 +173,9 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 			}
 			break;
 		case ARM_SMCCC_HV_PV_TIME_FEATURES:
-			val[0] = SMCCC_RET_SUCCESS;
+			if (kvm_arm_fw_reg_feat_enabled(smccc_feat->std_hyp_bmap,
+					KVM_REG_ARM_STD_HYP_BIT_PV_TIME))
+				val[0] = SMCCC_RET_SUCCESS;
 			break;
 		}
 		break;
@@ -216,6 +221,7 @@ static const u64 kvm_arm_fw_reg_ids[] = {
 	KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2,
 	KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3,
 	KVM_REG_ARM_STD_BMAP,
+	KVM_REG_ARM_STD_HYP_BMAP,
 };
 
 void kvm_arm_init_hypercalls(struct kvm *kvm)
@@ -223,6 +229,7 @@ void kvm_arm_init_hypercalls(struct kvm *kvm)
 	struct kvm_smccc_features *smccc_feat = &kvm->arch.smccc_feat;
 
 	smccc_feat->std_bmap = KVM_ARM_SMCCC_STD_FEATURES;
+	smccc_feat->std_hyp_bmap = KVM_ARM_SMCCC_STD_HYP_FEATURES;
 }
 
 int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu)
@@ -312,6 +319,9 @@ int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	case KVM_REG_ARM_STD_BMAP:
 		val = READ_ONCE(smccc_feat->std_bmap);
 		break;
+	case KVM_REG_ARM_STD_HYP_BMAP:
+		val = READ_ONCE(smccc_feat->std_hyp_bmap);
+		break;
 	default:
 		return -ENOENT;
 	}
@@ -334,6 +344,10 @@ static int kvm_arm_set_fw_reg_bmap(struct kvm_vcpu *vcpu, u64 reg_id, u64 val)
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
@@ -438,6 +452,7 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 
 		return 0;
 	case KVM_REG_ARM_STD_BMAP:
+	case KVM_REG_ARM_STD_HYP_BMAP:
 		return kvm_arm_set_fw_reg_bmap(vcpu, reg->id, val);
 	default:
 		return -ENOENT;
diff --git a/include/kvm/arm_hypercalls.h b/include/kvm/arm_hypercalls.h
index fd3ff350ee9d..b0915d8c5b81 100644
--- a/include/kvm/arm_hypercalls.h
+++ b/include/kvm/arm_hypercalls.h
@@ -8,10 +8,14 @@
 
 /* Last valid bits of the bitmapped firmware registers */
 #define KVM_REG_ARM_STD_BMAP_BIT_MAX		0
+#define KVM_REG_ARM_STD_HYP_BMAP_BIT_MAX	0
 
 #define KVM_ARM_SMCCC_STD_FEATURES \
 	GENMASK_ULL(KVM_REG_ARM_STD_BMAP_BIT_MAX, 0)
 
+#define KVM_ARM_SMCCC_STD_HYP_FEATURES \
+	GENMASK_ULL(KVM_REG_ARM_STD_HYP_BMAP_BIT_MAX, 0)
+
 int kvm_hvc_call_handler(struct kvm_vcpu *vcpu);
 
 static inline u32 smccc_get_function(struct kvm_vcpu *vcpu)
-- 
2.35.1.1094.g7c7d902a7c-goog

