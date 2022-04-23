Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E76A150C551
	for <lists+kvm@lfdr.de>; Sat, 23 Apr 2022 02:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231331AbiDWAGx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 20:06:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231320AbiDWAGq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 20:06:46 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17EED20E49C
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 17:03:43 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id d6-20020aa78686000000b0050adc2b200cso4437271pfo.21
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 17:03:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=X/58AOVcJZBuIqfxzeZygHghzuDoH3dJ9eSYKiEOz2g=;
        b=ZraGiuXstCpSXkSyDbOK+UePTp4ddaFJZ6Xhue9ToYLy/B6su0aVTgtHIA5F+hzVKE
         qao9LxdR9vGNeefHgxKTuKSio09BV65qE6Tco5F9jn1Xiry222GiyCwzQcGdeao6RrZH
         FVe9goajXTtW3lSLTT8dkKxNPIu5t3eC8tOl2us0kwp7owu/pe48I1vkkl7krVGlZRZp
         AdU9lpgvcS1knso5pdkH4DDAfSamP4FDqSEXB+Lssy/eL83qoIn0xk62xXiJstL5yIMZ
         h9kI1tSN/MgLH53cbSpU95yavi8/XTYAiZ5LcMY9WxXaNvPEk7qDNUOY9A7wsToU8+wm
         20KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=X/58AOVcJZBuIqfxzeZygHghzuDoH3dJ9eSYKiEOz2g=;
        b=Kb86wZDJ2PhlvgTxFxxV6/7qaJIow66Kr9o3C82M9/RFjfto7Zt/GTKjsQxKlZdyHO
         hDIS03ZA8N3/Na3q8l4GGCqS9ylPAKeP6vVTfy2ig0ecNZ7YonyM1C1q9r5S+n3DumYx
         n3rBXse4YxIf3VSI8y9BRLCYzkGLVeT9Hm+526M9j1rs/1/nmaNzDJGDkCn+T9HRqjVB
         q8SVkgPqemyu9IFBxgDufzw18YqdtJO8wt06xzVYqGYh5GbuFd2CF/bWVZ2MY7uwgo6b
         4HqIsGKY0rWg2wA4YQvnWkrAj0BlOYfHQpHGE6uYbv+Em7FwZrW3YlVH5jR8wIOeFSaQ
         3TDw==
X-Gm-Message-State: AOAM533NyAqLlrj/NRhyfqNcxTdZzHUNMeJrAPXgJrriYnKUnBtsvTM/
        kfu8AwiL7+YzY8GqWbgBGa4pfoFxnBcH
X-Google-Smtp-Source: ABdhPJyy0rth+uSw5gtxwRXSqiV2zWvAnO4X9Yarza3qoKh5MHjxrHIwbAgL+mJcB0i7TM4kD8uy/xYIPRs4
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:90a:9105:b0:1d2:9e98:7e1e with SMTP id
 k5-20020a17090a910500b001d29e987e1emr662712pjo.0.1650672221976; Fri, 22 Apr
 2022 17:03:41 -0700 (PDT)
Date:   Sat, 23 Apr 2022 00:03:23 +0000
In-Reply-To: <20220423000328.2103733-1-rananta@google.com>
Message-Id: <20220423000328.2103733-5-rananta@google.com>
Mime-Version: 1.0
References: <20220423000328.2103733-1-rananta@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH v6 4/9] KVM: arm64: Add vendor hypervisor firmware register
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

Introduce the firmware register to hold the vendor specific
hypervisor service calls (owner value 6) as a bitmap. The
bitmap represents the features that'll be enabled for the
guest, as configured by the user-space. Currently, this
includes support for KVM-vendor features along with
reading the UID, represented by bit-0, and Precision Time
Protocol (PTP), represented by bit-1.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  2 ++
 arch/arm64/include/uapi/asm/kvm.h |  4 ++++
 arch/arm64/kvm/hypercalls.c       | 23 ++++++++++++++++++-----
 include/kvm/arm_hypercalls.h      |  2 ++
 4 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 27d4b2a7970e..a025c2ba012a 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -106,10 +106,12 @@ struct kvm_arch_memory_slot {
  *
  * @std_bmap: Bitmap of standard secure service calls
  * @std_hyp_bmap: Bitmap of standard hypervisor service calls
+ * @vendor_hyp_bmap: Bitmap of vendor specific hypervisor service calls
  */
 struct kvm_smccc_features {
 	unsigned long std_bmap;
 	unsigned long std_hyp_bmap;
+	unsigned long vendor_hyp_bmap;
 };
 
 struct kvm_arch {
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 9eecc7ee8c14..e7d5ae222684 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -344,6 +344,10 @@ struct kvm_arm_copy_mte_tags {
 #define KVM_REG_ARM_STD_HYP_BMAP		KVM_REG_ARM_FW_FEAT_BMAP_REG(1)
 #define KVM_REG_ARM_STD_HYP_BIT_PV_TIME		0
 
+#define KVM_REG_ARM_VENDOR_HYP_BMAP		KVM_REG_ARM_FW_FEAT_BMAP_REG(2)
+#define KVM_REG_ARM_VENDOR_HYP_BIT_FUNC_FEAT	0
+#define KVM_REG_ARM_VENDOR_HYP_BIT_PTP		1
+
 /* Device Control API: ARM VGIC */
 #define KVM_DEV_ARM_VGIC_GRP_ADDR	0
 #define KVM_DEV_ARM_VGIC_GRP_DIST_REGS	1
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index f097bebdad39..76e626d0e699 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -72,9 +72,6 @@ static bool kvm_hvc_call_default_allowed(struct kvm_vcpu *vcpu, u32 func_id)
 	 */
 	case ARM_SMCCC_VERSION_FUNC_ID:
 	case ARM_SMCCC_ARCH_FEATURES_FUNC_ID:
-	case ARM_SMCCC_VENDOR_HYP_CALL_UID_FUNC_ID:
-	case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
-	case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
 		return true;
 	default:
 		return kvm_psci_func_id_is_valid(vcpu, func_id);
@@ -97,6 +94,13 @@ static bool kvm_hvc_call_allowed(struct kvm_vcpu *vcpu, u32 func_id)
 	case ARM_SMCCC_HV_PV_TIME_ST:
 		return kvm_arm_fw_reg_feat_enabled(&smccc_feat->std_hyp_bmap,
 					KVM_REG_ARM_STD_HYP_BIT_PV_TIME);
+	case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
+	case ARM_SMCCC_VENDOR_HYP_CALL_UID_FUNC_ID:
+		return kvm_arm_fw_reg_feat_enabled(&smccc_feat->vendor_hyp_bmap,
+					KVM_REG_ARM_VENDOR_HYP_BIT_FUNC_FEAT);
+	case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
+		return kvm_arm_fw_reg_feat_enabled(&smccc_feat->vendor_hyp_bmap,
+					KVM_REG_ARM_VENDOR_HYP_BIT_PTP);
 	default:
 		return kvm_hvc_call_default_allowed(vcpu, func_id);
 	}
@@ -189,8 +193,7 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 		val[3] = ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_3;
 		break;
 	case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
-		val[0] = BIT(ARM_SMCCC_KVM_FUNC_FEATURES);
-		val[0] |= BIT(ARM_SMCCC_KVM_FUNC_PTP);
+		val[0] = smccc_feat->vendor_hyp_bmap;
 		break;
 	case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
 		kvm_ptp_get_time(vcpu, val);
@@ -217,6 +220,7 @@ static const u64 kvm_arm_fw_reg_ids[] = {
 	KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3,
 	KVM_REG_ARM_STD_BMAP,
 	KVM_REG_ARM_STD_HYP_BMAP,
+	KVM_REG_ARM_VENDOR_HYP_BMAP,
 };
 
 void kvm_arm_init_hypercalls(struct kvm *kvm)
@@ -225,6 +229,7 @@ void kvm_arm_init_hypercalls(struct kvm *kvm)
 
 	smccc_feat->std_bmap = KVM_ARM_SMCCC_STD_FEATURES;
 	smccc_feat->std_hyp_bmap = KVM_ARM_SMCCC_STD_HYP_FEATURES;
+	smccc_feat->vendor_hyp_bmap = KVM_ARM_SMCCC_VENDOR_HYP_FEATURES;
 }
 
 int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu)
@@ -317,6 +322,9 @@ int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	case KVM_REG_ARM_STD_HYP_BMAP:
 		val = READ_ONCE(smccc_feat->std_hyp_bmap);
 		break;
+	case KVM_REG_ARM_VENDOR_HYP_BMAP:
+		val = READ_ONCE(smccc_feat->vendor_hyp_bmap);
+		break;
 	default:
 		return -ENOENT;
 	}
@@ -343,6 +351,10 @@ static int kvm_arm_set_fw_reg_bmap(struct kvm_vcpu *vcpu, u64 reg_id, u64 val)
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
@@ -445,6 +457,7 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 		return 0;
 	case KVM_REG_ARM_STD_BMAP:
 	case KVM_REG_ARM_STD_HYP_BMAP:
+	case KVM_REG_ARM_VENDOR_HYP_BMAP:
 		return kvm_arm_set_fw_reg_bmap(vcpu, reg->id, val);
 	default:
 		return -ENOENT;
diff --git a/include/kvm/arm_hypercalls.h b/include/kvm/arm_hypercalls.h
index aadd6ae3ab72..4ebfdd26e486 100644
--- a/include/kvm/arm_hypercalls.h
+++ b/include/kvm/arm_hypercalls.h
@@ -9,9 +9,11 @@
 /* Last valid bits of the bitmapped firmware registers */
 #define KVM_REG_ARM_STD_BMAP_BIT_MAX		0
 #define KVM_REG_ARM_STD_HYP_BMAP_BIT_MAX	0
+#define KVM_REG_ARM_VENDOR_HYP_BMAP_BIT_MAX	1
 
 #define KVM_ARM_SMCCC_STD_FEATURES		GENMASK(KVM_REG_ARM_STD_BMAP_BIT_MAX, 0)
 #define KVM_ARM_SMCCC_STD_HYP_FEATURES		GENMASK(KVM_REG_ARM_STD_HYP_BMAP_BIT_MAX, 0)
+#define KVM_ARM_SMCCC_VENDOR_HYP_FEATURES	GENMASK(KVM_REG_ARM_VENDOR_HYP_BMAP_BIT_MAX, 0)
 
 int kvm_hvc_call_handler(struct kvm_vcpu *vcpu);
 
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

