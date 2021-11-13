Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB9744F085
	for <lists+kvm@lfdr.de>; Sat, 13 Nov 2021 02:23:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235681AbhKMBZz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 20:25:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235634AbhKMBZu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Nov 2021 20:25:50 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A7B7C061767
        for <kvm@vger.kernel.org>; Fri, 12 Nov 2021 17:22:59 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id p13-20020a63c14d000000b002da483902b1so5644310pgi.12
        for <kvm@vger.kernel.org>; Fri, 12 Nov 2021 17:22:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Qw/clVNLM0HNZHqaD4lCmZow7BlWKfkgGErSltFYrjA=;
        b=XK/XfQZyOCv34OdPg13Gv7n46oxO77mh2e+k5qYG7JBdYFUE3ZvOs67O2HdEVwt7ay
         TDSCi5NN6WlIsUglBQmwVa0xCSQlrTU6V3LC0YtIxzPRDuj9aWXUvgUVV1paxUHYJjML
         dW9nV9gC0MUKl4mpGfYmdvaDaqnGYQaq0plREFfPfPNxgDWzkl+k1fGvZZEXZGbjmI+J
         jj9+pXb4NF9LeCdRyZkgfzX1CW9YWXRXGBHMC7YSLjshKl3o+KRs9DqUeOJO9yrdTV4F
         Q1ZAOxg5FqizoSGbzsMn3fbcyKLdWhKvIidT8om4gB+hh0c/DW3FX69+c23czcDm0V5J
         UNow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Qw/clVNLM0HNZHqaD4lCmZow7BlWKfkgGErSltFYrjA=;
        b=B9zH1VcJGHhogavZJKLFp00/l3nYVovyVEmxGf5yPWWxDzu650vUg/l5302ph/ZUB2
         syE8W0U7sAoU8yx8mCBgqwF0BhlWxNAF/Fcr0eHO0n++drWyf2FpU3i/ynX1U6sISHYM
         EKsIIwcOAnz8HtQJHcAgLfOIwZqA8d3F/b6x9R0CV3yyepA2dQxkN4NeyQptgNrdXVXv
         ULYeafedpvAkFX+t08Twnha7WlBi3tDv7WpQfiwmx2GPOUbdu4QTs/YziXHwjCv4GYLL
         16EMTDIXsx61DkH8LogqlbOO2gLc/OPd+MidE0SCbCTTysDrdBi0E6PALMcjBFv6fRgJ
         0qiw==
X-Gm-Message-State: AOAM532mu2EaVTOClnHqixGgIAfE4iO7O7CS1+UMvNw8VNymf+SosRhX
        1jzi71rG5JdjokWdi524ID9B6WPSOa1/
X-Google-Smtp-Source: ABdhPJy57fAHa9LRUb/E2nHa4PDT9a3BCQlcAHcEgns3RhXXXKmRA4HhXAK0WxiN2T67Dr6WLbiAMYiHpry3
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:aa7:9dcd:0:b0:494:658c:3943 with SMTP id
 g13-20020aa79dcd000000b00494658c3943mr17575007pfq.19.1636766578705; Fri, 12
 Nov 2021 17:22:58 -0800 (PST)
Date:   Sat, 13 Nov 2021 01:22:29 +0000
In-Reply-To: <20211113012234.1443009-1-rananta@google.com>
Message-Id: <20211113012234.1443009-7-rananta@google.com>
Mime-Version: 1.0
References: <20211113012234.1443009-1-rananta@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [RFC PATCH v2 06/11] KVM: arm64: Add vendor hypervisor firmware register
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

Introduce the firmware register to hold the vendor specific
hypervisor service calls (owner value 6) as a bitmap. The
bitmap represents the features that'll be enabled for the
guest, as configured by the user-space. Currently, this
includes support only for Precision Time Protocol (PTP),
represented by bit-0.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/include/uapi/asm/kvm.h |  4 ++++
 arch/arm64/kvm/hypercalls.c       | 30 +++++++++++++++++++++++++++++-
 include/kvm/arm_hypercalls.h      |  3 +++
 4 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index e8e540bd1fe5..ef1d10bdf562 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -114,6 +114,7 @@ struct hvc_reg_desc {
 
 	struct hvc_fw_reg_bmap hvc_std_bmap;
 	struct hvc_fw_reg_bmap hvc_std_hyp_bmap;
+	struct hvc_fw_reg_bmap hvc_vendor_hyp_bmap;
 };
 
 struct kvm_arch {
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 5890cbcd6385..8468e5d265df 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -289,6 +289,10 @@ struct kvm_arm_copy_mte_tags {
 #define KVM_REG_ARM_STD_HYP_BIT_PV_TIME	BIT(0)
 #define KVM_REG_ARM_STD_HYP_BMAP_BIT_MAX	0	/* Last valid bit */
 
+#define KVM_REG_ARM_VENDOR_HYP_BMAP		KVM_REG_ARM_FW_REG(5)
+#define KVM_REG_ARM_VENDOR_HYP_BIT_PTP		BIT(0)
+#define KVM_REG_ARM_VENDOR_HYP_BMAP_BIT_MAX	0	/* Last valid bit */
+
 /* SVE registers */
 #define KVM_REG_ARM64_SVE		(0x15 << KVM_REG_ARM_COPROC_SHIFT)
 
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index b3320adc068c..e1361029101e 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -88,6 +88,9 @@ bool kvm_hvc_call_supported(struct kvm_vcpu *vcpu, u32 func_id)
 	case ARM_SMCCC_HV_PV_TIME_ST:
 		return kvm_arm_fw_reg_feat_enabled(&hvc_desc->hvc_std_hyp_bmap,
 					KVM_REG_ARM_STD_HYP_BIT_PV_TIME);
+	case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
+		return kvm_arm_fw_reg_feat_enabled(&hvc_desc->hvc_vendor_hyp_bmap,
+					KVM_REG_ARM_VENDOR_HYP_BIT_PTP);
 	default:
 		/* By default, allow the services that aren't listed here */
 		return true;
@@ -99,6 +102,7 @@ bool kvm_hvc_call_supported(struct kvm_vcpu *vcpu, u32 func_id)
 
 int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 {
+	struct hvc_reg_desc *hvc_desc = &vcpu->kvm->arch.hvc_desc;
 	u32 func_id = smccc_get_function(vcpu);
 	u64 val[4] = {SMCCC_RET_NOT_SUPPORTED};
 	u32 feature;
@@ -173,7 +177,14 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 		break;
 	case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
 		val[0] = BIT(ARM_SMCCC_KVM_FUNC_FEATURES);
-		val[0] |= BIT(ARM_SMCCC_KVM_FUNC_PTP);
+
+		/*
+		 * The feature bits exposed to user-space doesn't include
+		 * ARM_SMCCC_KVM_FUNC_FEATURES. However, we expose this to
+		 * the guest as bit-0. Hence, left-shift the user-space
+		 * exposed bitmap by 1 to accommodate this.
+		 */
+		val[0] |= hvc_desc->hvc_vendor_hyp_bmap.bmap << 1;
 		break;
 	case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
 		kvm_ptp_get_time(vcpu, val);
@@ -202,6 +213,7 @@ static const u64 fw_reg_ids[] = {
 static const u64 fw_reg_bmap_ids[] = {
 	KVM_REG_ARM_STD_BMAP,
 	KVM_REG_ARM_STD_HYP_BMAP,
+	KVM_REG_ARM_VENDOR_HYP_BMAP,
 };
 
 static void kvm_arm_fw_reg_init_hvc(struct hvc_reg_desc *hvc_desc,
@@ -222,6 +234,8 @@ void kvm_arm_init_hypercalls(struct kvm *kvm)
 				KVM_REG_ARM_STD_BMAP, ARM_SMCCC_STD_FEATURES);
 	kvm_arm_fw_reg_init_hvc(hvc_desc, &hvc_desc->hvc_std_hyp_bmap,
 			KVM_REG_ARM_STD_HYP_BMAP, ARM_SMCCC_STD_HYP_FEATURES);
+	kvm_arm_fw_reg_init_hvc(hvc_desc, &hvc_desc->hvc_vendor_hyp_bmap,
+		KVM_REG_ARM_VENDOR_HYP_BMAP, ARM_SMCCC_VENDOR_HYP_FEATURES);
 }
 
 static void kvm_arm_fw_reg_sanitize(struct hvc_fw_reg_bmap *fw_reg_bmap)
@@ -270,6 +284,7 @@ void kvm_arm_sanitize_fw_regs(struct kvm *kvm)
 
 	kvm_arm_fw_reg_sanitize(&hvc_desc->hvc_std_bmap);
 	kvm_arm_fw_reg_sanitize(&hvc_desc->hvc_std_hyp_bmap);
+	kvm_arm_fw_reg_sanitize(&hvc_desc->hvc_vendor_hyp_bmap);
 
 out:
 	spin_unlock(&hvc_desc->lock);
@@ -324,6 +339,9 @@ static int kvm_arm_fw_reg_set_bmap(struct kvm *kvm,
 	case KVM_REG_ARM_STD_HYP_BMAP:
 		fw_reg_features = ARM_SMCCC_STD_HYP_FEATURES;
 		break;
+	case KVM_REG_ARM_VENDOR_HYP_BMAP:
+		fw_reg_features = ARM_SMCCC_VENDOR_HYP_FEATURES;
+		break;
 	default:
 		ret = -EINVAL;
 		goto out;
@@ -453,6 +471,13 @@ int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 		if (ret)
 			return ret;
 
+		break;
+	case KVM_REG_ARM_VENDOR_HYP_BMAP:
+		ret = kvm_arm_fw_reg_get_bmap(kvm,
+					&hvc_desc->hvc_vendor_hyp_bmap, &val);
+		if (ret)
+			return ret;
+
 		break;
 	default:
 		return -ENOENT;
@@ -547,6 +572,9 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	case KVM_REG_ARM_STD_HYP_BMAP:
 		return kvm_arm_fw_reg_set_bmap(kvm,
 					&hvc_desc->hvc_std_hyp_bmap, val);
+	case KVM_REG_ARM_VENDOR_HYP_BMAP:
+		return kvm_arm_fw_reg_set_bmap(kvm,
+					&hvc_desc->hvc_vendor_hyp_bmap, val);
 	default:
 		return -ENOENT;
 	}
diff --git a/include/kvm/arm_hypercalls.h b/include/kvm/arm_hypercalls.h
index 77c30e335f44..94f56562fea8 100644
--- a/include/kvm/arm_hypercalls.h
+++ b/include/kvm/arm_hypercalls.h
@@ -12,6 +12,9 @@
 #define ARM_SMCCC_STD_HYP_FEATURES \
 	GENMASK_ULL(KVM_REG_ARM_STD_HYP_BMAP_BIT_MAX, 0)
 
+#define ARM_SMCCC_VENDOR_HYP_FEATURES \
+	GENMASK_ULL(KVM_REG_ARM_VENDOR_HYP_BMAP_BIT_MAX, 0)
+
 int kvm_hvc_call_handler(struct kvm_vcpu *vcpu);
 
 static inline u32 smccc_get_function(struct kvm_vcpu *vcpu)
-- 
2.34.0.rc1.387.gb447b232ab-goog

