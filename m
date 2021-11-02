Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E60E04424A6
	for <lists+kvm@lfdr.de>; Tue,  2 Nov 2021 01:22:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232091AbhKBAZR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Nov 2021 20:25:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232097AbhKBAZJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Nov 2021 20:25:09 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20BE8C061203
        for <kvm@vger.kernel.org>; Mon,  1 Nov 2021 17:22:32 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id w30-20020aa79a1e000000b0048012d2e882so4836891pfj.2
        for <kvm@vger.kernel.org>; Mon, 01 Nov 2021 17:22:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Chm/T8yL3ygYrjvri7zfXhNFj/zx6GP1hVE4sMZ+a+w=;
        b=nN5gKUrFIqzx6CmBSS42DcfwFEpyDsegSFkgJjEQRTH4nwB4hAJbyU1slAbrRmMybH
         GP7ZzaU7vH0nbVkk0NGjh0fvvwDwguas2GMfEJfWS980D3reVJLje5eQERco2XDriuAD
         cC5X6GqVWKgR++ugI/Vnoi6YUkr1vqima0lpWMNkq/rcy6mzMjfmeYoq7Mp39T6iQ1gm
         n+RjTftFmodXfL0ZdpU1lgbAZQRM1F0WxusdGwSMFLbfS3V2aHdcRdA6wcFS9EAE5h8b
         RE99uIg7ik08KPFXWgW/xyfkOOqknGc1f9/n1/DnojcaJ+dzhxWeytk/l9mLkxF3J+/s
         +bNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Chm/T8yL3ygYrjvri7zfXhNFj/zx6GP1hVE4sMZ+a+w=;
        b=0UK/fEQt/h7Z2GuCrAPJ5EA33vnjf6gLXGYqJrf/IwHesJ3FClWcVGUAtLEoc10eR+
         XQ4Z1lZUmVNlHb8gtb1vSbRhvDkD+tXBVqA+S65jCFOAprcSGrisUb/R9rCvW0BLIQ5k
         M8/eOo3dHjT1fy8qbbOrqCUvGXLRQYisyUGzY5cy1PhM7EcAbd4YDvPyOasQ9ppCTYXA
         a2HImG15tHeTZ3u4kBHJgG8VuxZgh6tsZ1ejUDd6eNc66vFSe+QgMEXUussqdz2XLHJi
         RMhJwfYlaSZHz1oIcOTs3JFlV93Mx/eYbaQemHUKpiavOb1oOFNZcnJrACIyN19EwMjj
         o7Ow==
X-Gm-Message-State: AOAM531QAZRKITfoN/IiGgp6LFdOb2zJoW987Qhi2DjqiXGHZ2bX4XZ9
        noopWELXQc6wR2GbM5Yrc13PnU+tFC0D
X-Google-Smtp-Source: ABdhPJzwWL9vAsGyyzKtoA+qSmHdO5GSQso3+7zYZ8kWXJoBSLwa7gOBkk12voU8VEShgrYWhIwnPdrYS+HE
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:90b:1c05:: with SMTP id
 oc5mr2560695pjb.179.1635812551611; Mon, 01 Nov 2021 17:22:31 -0700 (PDT)
Date:   Tue,  2 Nov 2021 00:21:59 +0000
In-Reply-To: <20211102002203.1046069-1-rananta@google.com>
Message-Id: <20211102002203.1046069-5-rananta@google.com>
Mime-Version: 1.0
References: <20211102002203.1046069-1-rananta@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [RFC PATCH 4/8] KVM: arm64: Add standard hypervisor service calls
 firmware register
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
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
 Documentation/virt/kvm/arm/hypercalls.rst | 23 ++++++++++++++++-------
 arch/arm64/include/asm/kvm_host.h         |  1 +
 arch/arm64/include/uapi/asm/kvm.h         |  6 ++++++
 arch/arm64/kvm/arm.c                      |  1 +
 arch/arm64/kvm/hypercalls.c               | 22 ++++++++++++++++++++++
 arch/arm64/kvm/pvtime.c                   |  3 +++
 include/kvm/arm_hypercalls.h              |  3 +++
 7 files changed, 52 insertions(+), 7 deletions(-)

diff --git a/Documentation/virt/kvm/arm/hypercalls.rst b/Documentation/virt/kvm/arm/hypercalls.rst
index 1601919f256d..2cb82c694868 100644
--- a/Documentation/virt/kvm/arm/hypercalls.rst
+++ b/Documentation/virt/kvm/arm/hypercalls.rst
@@ -20,13 +20,13 @@ pseudo-registers" that can be manipulated using the GET/SET_ONE_REG
 interface. These registers can be saved/restored by userspace, and set
 to a convenient value if required.
 
-The firmware register KVM_REG_ARM_STD exposes the hypercall services
-in the form of a feature bitmap. Upon VM creation, by default, KVM exposes
-all the features to the guest, which can be learnt using GET_ONE_REG
-interface. Conversely, the features can be enabled or disabled via the
-SET_ONE_REG interface. These registers allow the user-space modification
-only until the VM has started running, after which they turn to read-only
-registers. SET_ONE_REG in this scenario will return -EBUSY.
+The firmware registers, KVM_REG_ARM_STD and KVM_REG_ARM_STD_HYP exposes
+the hypercall services in the form of a feature bitmap. Upon VM creation,
+by default, KVM exposes all the features to the guest, which can be learnt
+using GET_ONE_REG interface. Conversely, the features can be enabled or
+disabled via the SET_ONE_REG interface. These registers allow the user-space
+modification only until the VM has started running, after which they turn to
+read-only registers. SET_ONE_REG in this scenario will return -EBUSY.
 
 The following register is defined:
 
@@ -91,4 +91,13 @@ The following register is defined:
         The bit represents the services offered under v1.0 of ARM True Random Number Generator
         (TRNG) specification (ARM DEN 0098).
 
+* KVM_REG_ARM_STD_HYP
+    Controls the bitmap of the ARM Standard Hypervisor Service Calls.
+
+    The following bits are accepted:
+
+      KVM_REG_ARM_STD_HYP_PV_TIME_ST:
+        The bit represents the Paravirtualized Time service (also known as stolen time) as
+        represented by ARM DEN0057A.
+
 .. [1] https://developer.arm.com/-/media/developer/pdf/ARM_DEN_0070A_Firmware_interfaces_for_mitigating_CVE-2017-5715.pdf
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 176d6be7b4da..cee4f4b8a756 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -107,6 +107,7 @@ struct hvc_reg_desc {
 	bool write_attempted;
 
 	u64 kvm_std_bmap;
+	u64 kvm_std_hyp_bmap;
 };
 
 struct kvm_arch {
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 6387dea5396d..46701da1a27d 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -287,6 +287,12 @@ enum kvm_reg_arm_std_bmap {
 	KVM_REG_ARM_STD_BMAP_MAX,
 };
 
+#define KVM_REG_ARM_STD_HYP		KVM_REG_ARM_FW_REG(4)
+enum kvm_reg_arm_std_hyp_bmap {
+	KVM_REG_ARM_STD_HYP_PV_TIME_ST,
+	KVM_REG_ARM_STD_HYP_BMAP_MAX,
+};
+
 /* SVE registers */
 #define KVM_REG_ARM64_SVE		(0x15 << KVM_REG_ARM_COPROC_SHIFT)
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 1cf58aa49222..1c69d2a71b86 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -135,6 +135,7 @@ static void set_default_hypercalls(struct kvm *kvm)
 	struct hvc_reg_desc *hvc_desc = &kvm->arch.hvc_desc;
 
 	hvc_desc->kvm_std_bmap = ARM_SMCCC_STD_FEATURES;
+	hvc_desc->kvm_std_hyp_bmap = ARM_SMCCC_STD_HYP_FEATURES;
 }
 
 /**
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 0b3006353bf6..46064c515058 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -65,6 +65,8 @@ static u64 *kvm_fw_reg_to_bmap(struct kvm *kvm, u64 fw_reg)
 	switch (fw_reg) {
 	case KVM_REG_ARM_STD:
 		return &hvc_desc->kvm_std_bmap;
+	case KVM_REG_ARM_STD_HYP:
+		return &hvc_desc->kvm_std_hyp_bmap;
 	default:
 		return NULL;
 	}
@@ -87,6 +89,10 @@ static const struct kvm_hvc_func_map hvc_std_map[] = {
 	HVC_FUNC_MAP_DESC(ARM_SMCCC_TRNG_RND64, KVM_REG_ARM_STD_TRNG_V1_0),
 };
 
+static const struct kvm_hvc_func_map hvc_std_hyp_map[] = {
+	HVC_FUNC_MAP_DESC(ARM_SMCCC_HV_PV_TIME_ST, KVM_REG_ARM_STD_HYP_PV_TIME_ST),
+};
+
 bool kvm_hvc_call_supported(struct kvm_vcpu *vcpu, u32 func_id)
 {
 	struct kvm *kvm = vcpu->kvm;
@@ -102,6 +108,11 @@ bool kvm_hvc_call_supported(struct kvm_vcpu *vcpu, u32 func_id)
 		hvc_func_map = hvc_std_map;
 		map_sz = ARRAY_SIZE(hvc_std_map);
 		break;
+	case ARM_SMCCC_OWNER_STANDARD_HYP:
+		fw_reg = KVM_REG_ARM_STD_HYP;
+		hvc_func_map = hvc_std_hyp_map;
+		map_sz = ARRAY_SIZE(hvc_std_hyp_map);
+		break;
 	default:
 		/* Allow all the owners that aren't mapped */
 		return true;
@@ -218,6 +229,7 @@ static const u64 fw_reg_ids[] = {
 	KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1,
 	KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2,
 	KVM_REG_ARM_STD,
+	KVM_REG_ARM_STD_HYP,
 };
 
 int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu)
@@ -295,6 +307,9 @@ int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	case KVM_REG_ARM_STD:
 		val = hvc_desc->kvm_std_bmap;
 		break;
+	case KVM_REG_ARM_STD_HYP:
+		val = hvc_desc->kvm_std_hyp_bmap;
+		break;
 	default:
 		return -ENOENT;
 	}
@@ -424,6 +439,13 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 
 		hvc_desc->kvm_std_bmap = val;
 		return 0;
+
+	case KVM_REG_ARM_STD_HYP:
+		if (val & ~ARM_SMCCC_STD_HYP_FEATURES)
+			return -EINVAL;
+
+		hvc_desc->kvm_std_hyp_bmap = val;
+		return 0;
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
index 5f01bb139312..bbb3b12b10e3 100644
--- a/include/kvm/arm_hypercalls.h
+++ b/include/kvm/arm_hypercalls.h
@@ -9,6 +9,9 @@
 #define ARM_SMCCC_STD_FEATURES \
 	GENMASK_ULL(KVM_REG_ARM_STD_BMAP_MAX - 1, 0)
 
+#define ARM_SMCCC_STD_HYP_FEATURES \
+	GENMASK_ULL(KVM_REG_ARM_STD_HYP_BMAP_MAX - 1, 0)
+
 int kvm_hvc_call_handler(struct kvm_vcpu *vcpu);
 
 static inline u32 smccc_get_function(struct kvm_vcpu *vcpu)
-- 
2.33.1.1089.g2158813163f-goog

