Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE8354F704F
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 03:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238392AbiDGBVD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 21:21:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240435AbiDGBUA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 21:20:00 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04BA01868A0
        for <kvm@vger.kernel.org>; Wed,  6 Apr 2022 18:16:20 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id y23-20020a62b517000000b004fd8affa86aso1609948pfe.12
        for <kvm@vger.kernel.org>; Wed, 06 Apr 2022 18:16:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=uKF3LzEpbt0jcGyoq/1Xe6ZugarWRpxWPPyqjttx12c=;
        b=HM05i9xYqmF9YTZlktYDfk2oGC8DrHDBcY4XhwET5dVfw8LN4y0IMKOS1ytyeBj8Cw
         B/wBVDV66kxEe7mCNTi5PXpHQruPW8ePrvO8hkkzFwhNNhTkWTw3dBSL13pBojaT/ggB
         dhMU2E2GXe5p9geAbeSEqsG6Bf026kh91SwOsyaNZHE0DTtCorey8FKXNypvuZsJtoxr
         W2ec6Q0+9bZ6Eoqrj+shgeLEBouwJmsPfDHNu5f6oNjZa3dH2N4ATifv8AIPOrXmYvjX
         e4BXmNBCrIgJPm9lQ4QoBR/i/KWJu+PkQUWdvus429ZSK8xW60jcdBza69jIYxO2Elp7
         Jm2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=uKF3LzEpbt0jcGyoq/1Xe6ZugarWRpxWPPyqjttx12c=;
        b=W7AY790msQd0gY6kLOhBntMBYVMUixs1PWEz1cXffREZlFkequcQ9UZstjm0c/OOyI
         VfdolP0zxPEssrwqJ6e/FDQlLxdB3BBg84aRkdExYF4A9k/It6cwJLg7JsaZziSePvpD
         ipU1m+rVEg4nmRa+XKmLGgYBVoYdbg5DfNFsypGIM1RyZf1tkBF+/Y4ckQLXHR9+T3A/
         NhXhYyzONUS6kCCo4ac5xlR1vpYMZY1dwVuzjCnGvkDlA9zqzvo4/GAaXnY+m3tDN2gw
         ByJs5WClWW2PMe3EI21+3aZ2e3/TowhMyH0xQU8dDp2BYlQ2UXpL593YST5TmbwpMTlf
         KerQ==
X-Gm-Message-State: AOAM5316b8KHxKh6zrS/oI6E4o8awuoqFWpEYfF1KSaoI/byRDXCEUhP
        o0gdDYp1KSl8vika7Bj5HR9a51HXTPMV
X-Google-Smtp-Source: ABdhPJw2IUgAWNtqzd51LY4wfv37u3QV9B0xYw5NFlCSPW6EpcxGVctPDL5vzpbqWcSbeoJoMsCmwREaVyUd
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a05:6a00:23c1:b0:4fa:efcb:9c81 with SMTP
 id g1-20020a056a0023c100b004faefcb9c81mr11488095pfc.75.1649294179498; Wed, 06
 Apr 2022 18:16:19 -0700 (PDT)
Date:   Thu,  7 Apr 2022 01:15:59 +0000
In-Reply-To: <20220407011605.1966778-1-rananta@google.com>
Message-Id: <20220407011605.1966778-5-rananta@google.com>
Mime-Version: 1.0
References: <20220407011605.1966778-1-rananta@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v5 04/10] KVM: arm64: Add vendor hypervisor firmware register
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

Introduce the firmware register to hold the vendor specific
hypervisor service calls (owner value 6) as a bitmap. The
bitmap represents the features that'll be enabled for the
guest, as configured by the user-space. Currently, this
includes support for KVM-vendor features, and Precision Time
Protocol (PTP), represented by bit-0 and bit-1 respectively.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  2 ++
 arch/arm64/include/uapi/asm/kvm.h |  4 ++++
 arch/arm64/kvm/hypercalls.c       | 21 +++++++++++++++++----
 include/kvm/arm_hypercalls.h      |  4 ++++
 4 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 20165242ebd9..b79161bad69a 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -106,10 +106,12 @@ struct kvm_arch_memory_slot {
  *
  * @std_bmap: Bitmap of standard secure service calls
  * @std_hyp_bmap: Bitmap of standard hypervisor service calls
+ * @vendor_hyp_bmap: Bitmap of vendor specific hypervisor service calls
  */
 struct kvm_smccc_features {
 	u64 std_bmap;
 	u64 std_hyp_bmap;
+	u64 vendor_hyp_bmap;
 };
 
 struct kvm_arch {
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 67353bf4e69d..9a5ac0ed4113 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -344,6 +344,10 @@ struct kvm_arm_copy_mte_tags {
 #define KVM_REG_ARM_STD_HYP_BMAP		KVM_REG_ARM_FW_FEAT_BMAP_REG(1)
 #define KVM_REG_ARM_STD_HYP_BIT_PV_TIME		BIT(0)
 
+#define KVM_REG_ARM_VENDOR_HYP_BMAP		KVM_REG_ARM_FW_FEAT_BMAP_REG(2)
+#define KVM_REG_ARM_VENDOR_HYP_BIT_FUNC_FEAT	BIT(0)
+#define KVM_REG_ARM_VENDOR_HYP_BIT_PTP		BIT(1)
+
 /* Device Control API: ARM VGIC */
 #define KVM_DEV_ARM_VGIC_GRP_ADDR	0
 #define KVM_DEV_ARM_VGIC_GRP_DIST_REGS	1
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 64ae6c7e7145..80836c341fd3 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -66,8 +66,6 @@ static const u32 hvc_func_default_allowed_list[] = {
 	ARM_SMCCC_VERSION_FUNC_ID,
 	ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
 	ARM_SMCCC_VENDOR_HYP_CALL_UID_FUNC_ID,
-	ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID,
-	ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID,
 };
 
 static bool kvm_hvc_call_default_allowed(struct kvm_vcpu *vcpu, u32 func_id)
@@ -102,6 +100,12 @@ static bool kvm_hvc_call_allowed(struct kvm_vcpu *vcpu, u32 func_id)
 	case ARM_SMCCC_HV_PV_TIME_ST:
 		return kvm_arm_fw_reg_feat_enabled(smccc_feat->std_hyp_bmap,
 					KVM_REG_ARM_STD_HYP_BIT_PV_TIME);
+	case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
+		return kvm_arm_fw_reg_feat_enabled(smccc_feat->vendor_hyp_bmap,
+					KVM_REG_ARM_VENDOR_HYP_BIT_FUNC_FEAT);
+	case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
+		return kvm_arm_fw_reg_feat_enabled(smccc_feat->vendor_hyp_bmap,
+					KVM_REG_ARM_VENDOR_HYP_BIT_PTP);
 	default:
 		return kvm_hvc_call_default_allowed(vcpu, func_id);
 	}
@@ -194,8 +198,7 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 		val[3] = ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_3;
 		break;
 	case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
-		val[0] = BIT(ARM_SMCCC_KVM_FUNC_FEATURES);
-		val[0] |= BIT(ARM_SMCCC_KVM_FUNC_PTP);
+		val[0] = smccc_feat->vendor_hyp_bmap;
 		break;
 	case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
 		kvm_ptp_get_time(vcpu, val);
@@ -222,6 +225,7 @@ static const u64 kvm_arm_fw_reg_ids[] = {
 	KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3,
 	KVM_REG_ARM_STD_BMAP,
 	KVM_REG_ARM_STD_HYP_BMAP,
+	KVM_REG_ARM_VENDOR_HYP_BMAP,
 };
 
 void kvm_arm_init_hypercalls(struct kvm *kvm)
@@ -230,6 +234,7 @@ void kvm_arm_init_hypercalls(struct kvm *kvm)
 
 	smccc_feat->std_bmap = KVM_ARM_SMCCC_STD_FEATURES;
 	smccc_feat->std_hyp_bmap = KVM_ARM_SMCCC_STD_HYP_FEATURES;
+	smccc_feat->vendor_hyp_bmap = KVM_ARM_SMCCC_VENDOR_HYP_FEATURES;
 }
 
 int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu)
@@ -322,6 +327,9 @@ int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	case KVM_REG_ARM_STD_HYP_BMAP:
 		val = READ_ONCE(smccc_feat->std_hyp_bmap);
 		break;
+	case KVM_REG_ARM_VENDOR_HYP_BMAP:
+		val = READ_ONCE(smccc_feat->vendor_hyp_bmap);
+		break;
 	default:
 		return -ENOENT;
 	}
@@ -348,6 +356,10 @@ static int kvm_arm_set_fw_reg_bmap(struct kvm_vcpu *vcpu, u64 reg_id, u64 val)
 		fw_reg_bmap = &smccc_feat->std_hyp_bmap;
 		fw_reg_features = KVM_ARM_SMCCC_STD_HYP_FEATURES;
 		break;
+	case KVM_REG_ARM_VENDOR_HYP_BMAP:
+		fw_reg_bmap = &smccc_feat->vendor_hyp_bmap;
+		fw_reg_features = KVM_ARM_SMCCC_VENDOR_HYP_FEATURES;
+		break;
 	default:
 		return -ENOENT;
 	}
@@ -453,6 +465,7 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 		return 0;
 	case KVM_REG_ARM_STD_BMAP:
 	case KVM_REG_ARM_STD_HYP_BMAP:
+	case KVM_REG_ARM_VENDOR_HYP_BMAP:
 		return kvm_arm_set_fw_reg_bmap(vcpu, reg->id, val);
 	default:
 		return -ENOENT;
diff --git a/include/kvm/arm_hypercalls.h b/include/kvm/arm_hypercalls.h
index b0915d8c5b81..eaf4f6b318a8 100644
--- a/include/kvm/arm_hypercalls.h
+++ b/include/kvm/arm_hypercalls.h
@@ -9,6 +9,7 @@
 /* Last valid bits of the bitmapped firmware registers */
 #define KVM_REG_ARM_STD_BMAP_BIT_MAX		0
 #define KVM_REG_ARM_STD_HYP_BMAP_BIT_MAX	0
+#define KVM_REG_ARM_VENDOR_HYP_BMAP_BIT_MAX	1
 
 #define KVM_ARM_SMCCC_STD_FEATURES \
 	GENMASK_ULL(KVM_REG_ARM_STD_BMAP_BIT_MAX, 0)
@@ -16,6 +17,9 @@
 #define KVM_ARM_SMCCC_STD_HYP_FEATURES \
 	GENMASK_ULL(KVM_REG_ARM_STD_HYP_BMAP_BIT_MAX, 0)
 
+#define KVM_ARM_SMCCC_VENDOR_HYP_FEATURES \
+	GENMASK_ULL(KVM_REG_ARM_VENDOR_HYP_BMAP_BIT_MAX, 0)
+
 int kvm_hvc_call_handler(struct kvm_vcpu *vcpu);
 
 static inline u32 smccc_get_function(struct kvm_vcpu *vcpu)
-- 
2.35.1.1094.g7c7d902a7c-goog

