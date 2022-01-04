Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE2F64848DA
	for <lists+kvm@lfdr.de>; Tue,  4 Jan 2022 20:49:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231495AbiADTtm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jan 2022 14:49:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231708AbiADTti (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jan 2022 14:49:38 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2686EC061784
        for <kvm@vger.kernel.org>; Tue,  4 Jan 2022 11:49:38 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id d3-20020a17090a2a4300b001b22191073dso368367pjg.4
        for <kvm@vger.kernel.org>; Tue, 04 Jan 2022 11:49:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=yfWDJrgheE6EJzsXpJMIRXHEkqTr0RVehHDg0xmihp8=;
        b=W0AXiLpl2S7gXtCBksq+thzqaUHb/7bLFRjviizxzYnABqvhnuGn4bzUwgFxoksDs/
         bbhcaFZXCIqhJiEKR3OvwN5sCm8XNxcjGYxdvM7MpZzTUBEDpSRg6DdiVe7kpkv1WPRu
         UWdPkuCepwzBv+aDaGPBwQmoqrWixSXMfkInP/PXY4A8R61FN6Ml1pmnDrZRltieP2WI
         kg/1XqsTRCAFDli+/o0o0AFZOPxlsUbk8JZfVSiS572Z9UtAgp3lH5YYbBdW7FhIpPRj
         WmoMFyH7/1LRnaumoUA/0OqKBqP12ak2nt05qNETVU0iexosHP9hHL8WlLvP1w0VWxL2
         ckUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=yfWDJrgheE6EJzsXpJMIRXHEkqTr0RVehHDg0xmihp8=;
        b=PR1pQxIMAsZT2CpYv2uA12fJ1KIIuL7cIxOO4h4SoTqkYI4Z8BLg1RZZlHJcImN6CU
         1EJR8mPJ0/a9kgWX/79rATs1PtDf93roog3gdpxVNuNkZ/2+12COBpatPc9PNqxW6LX1
         bQ90m5GxI9zkdNGplprOUWGT/7b/2HhODMQWPhvfykxbFKy/WQMummE0CMokVJw5rtuc
         yZ6EYPdh/bR3o2IVSsed2mG/NeZ5BWTJ6L8p0Yl+lMCqbLbvBJoZBU0vGOELP26pOW8u
         QoPuOEi1gpDaoSafEkmTOBprk7QAv+N1gSo5LgUbtB6X4HTmdaA0hmfyvafb3RMS+wpd
         +3sw==
X-Gm-Message-State: AOAM531VLlVb1SK1uJB7lH8rxMDSvAHFPqWBoJtSxL8foitvNMg7N1Jj
        ZRsh81xTzUf926PKRquEiCcAqUdq9s8c
X-Google-Smtp-Source: ABdhPJzt7q6w1jFERyOAw2+AtYhDsaPLLpmCxdrGIzTeujAMo2uRVcJyfPB4fALmXk6r1dYw2Cm98vwiSARV
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:902:b201:b0:149:4b25:332d with SMTP id
 t1-20020a170902b20100b001494b25332dmr52005386plr.17.1641325777691; Tue, 04
 Jan 2022 11:49:37 -0800 (PST)
Date:   Tue,  4 Jan 2022 19:49:11 +0000
In-Reply-To: <20220104194918.373612-1-rananta@google.com>
Message-Id: <20220104194918.373612-5-rananta@google.com>
Mime-Version: 1.0
References: <20220104194918.373612-1-rananta@google.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
Subject: [RFC PATCH v3 04/11] KVM: arm64: Setup a framework for hypercall
 bitmap firmware registers
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

KVM regularly introduces new hypercall services to the guests without
any consent from the Virtual Machine Manager (VMM). This means, the
guests can observe hypercall services in and out as they migrate
across various host kernel versions. This could be a major problem
if the guest discovered a hypercall, started using it, and after
getting migrated to an older kernel realizes that it's no longer
available. Depending on how the guest handles the change, there's
a potential chance that the guest would just panic.

As a result, there's a need for the VMM to elect the services that
it wishes the guest to discover. VMM can elect these services based
on the kernels spread across its (migration) fleet. To remedy this,
extend the existing firmware psuedo-registers, such as
KVM_REG_ARM_PSCI_VERSION, for all the hypercall services available.

These firmware registers are categorized based on the service call
owners, and unlike the existing firmware psuedo-registers, they hold
the features supported in the form of a bitmap.

The capability, KVM_CAP_ARM_HVC_FW_REG_BMAP, is used to announce
this extension, which returns the number of psuedo-firmware
registers supported. During the VM initialization, the registers
holds an upper-limit of the features supported by the corresponding
registers. It's expected that the VMMs discover the features
provided by each register via GET_ONE_REG, and writeback the
desired values using SET_ONE_REG. KVM allows this modification
only until the VM has started.

Older VMMs can simply ignore the capability and the hypercall services
will be exposed unconditionally to the guests, thus ensuring backward
compatibility.

In this patch, the framework adds the register only for ARM's standard
secure services (owner value 4). Currently, this includes support only
for ARM True Random Number Generator (TRNG) service, with bit-0 of the
register representing mandatory features of v1.0. Other services are
momentarily added in the upcoming patches.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  12 ++++
 arch/arm64/include/uapi/asm/kvm.h |   4 ++
 arch/arm64/kvm/arm.c              |   4 ++
 arch/arm64/kvm/hypercalls.c       | 103 +++++++++++++++++++++++++++++-
 arch/arm64/kvm/trng.c             |   8 +--
 include/kvm/arm_hypercalls.h      |   6 ++
 6 files changed, 129 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 2a5f7f38006f..a32cded0371b 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -102,6 +102,15 @@ struct kvm_s2_mmu {
 struct kvm_arch_memory_slot {
 };
 
+/**
+ * struct kvm_hvc_desc: KVM ARM64 hypercall descriptor
+ *
+ * @hvc_std_bmap: Bitmap of standard secure service calls
+ */
+struct kvm_hvc_desc {
+	u64 hvc_std_bmap;
+};
+
 struct kvm_arch {
 	struct kvm_s2_mmu mmu;
 
@@ -137,6 +146,9 @@ struct kvm_arch {
 
 	/* Memory Tagging Extension enabled for the guest */
 	bool mte_enabled;
+
+	/* Hypercall firmware register' descriptor */
+	struct kvm_hvc_desc hvc_desc;
 };
 
 struct kvm_vcpu_fault_info {
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index b3edde68bc3e..0d6f29c58456 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -281,6 +281,10 @@ struct kvm_arm_copy_mte_tags {
 #define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_REQUIRED	3
 #define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_ENABLED     	(1U << 4)
 
+#define KVM_REG_ARM_STD_BMAP			KVM_REG_ARM_FW_REG(3)
+#define KVM_REG_ARM_STD_BIT_TRNG_V1_0		BIT(0)
+#define KVM_REG_ARM_STD_BMAP_BIT_MAX		0       /* Last valid bit */
+
 /* SVE registers */
 #define KVM_REG_ARM64_SVE		(0x15 << KVM_REG_ARM_COPROC_SHIFT)
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index e4727dc771bf..56fe81565235 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -156,6 +156,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	kvm->arch.max_vcpus = kvm_arm_default_max_vcpus();
 
 	set_default_spectre(kvm);
+	kvm_arm_init_hypercalls(kvm);
 
 	return ret;
 out_free_stage2_pgd:
@@ -283,6 +284,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ARM_PTRAUTH_GENERIC:
 		r = system_has_full_ptr_auth();
 		break;
+	case KVM_CAP_ARM_HVC_FW_REG_BMAP:
+		r = kvm_arm_num_fw_bmap_regs();
+		break;
 	default:
 		r = 0;
 	}
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 3c2fcf31ad3d..06243e4670eb 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -58,6 +58,29 @@ static void kvm_ptp_get_time(struct kvm_vcpu *vcpu, u64 *val)
 	val[3] = lower_32_bits(cycles);
 }
 
+static bool kvm_arm_fw_reg_feat_enabled(u64 reg_bmap, u64 feat_bit)
+{
+	return reg_bmap & feat_bit;
+}
+
+bool kvm_hvc_call_supported(struct kvm_vcpu *vcpu, u32 func_id)
+{
+	struct kvm_hvc_desc *hvc_desc = &vcpu->kvm->arch.hvc_desc;
+
+	switch (func_id) {
+	case ARM_SMCCC_TRNG_VERSION:
+	case ARM_SMCCC_TRNG_FEATURES:
+	case ARM_SMCCC_TRNG_GET_UUID:
+	case ARM_SMCCC_TRNG_RND32:
+	case ARM_SMCCC_TRNG_RND64:
+		return kvm_arm_fw_reg_feat_enabled(hvc_desc->hvc_std_bmap,
+						KVM_REG_ARM_STD_BIT_TRNG_V1_0);
+	default:
+		/* By default, allow the services that aren't listed here */
+		return true;
+	}
+}
+
 int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 {
 	u32 func_id = smccc_get_function(vcpu);
@@ -65,6 +88,9 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 	u32 feature;
 	gpa_t gpa;
 
+	if (!kvm_hvc_call_supported(vcpu, func_id))
+		goto out;
+
 	switch (func_id) {
 	case ARM_SMCCC_VERSION_FUNC_ID:
 		val[0] = ARM_SMCCC_VERSION_1_1;
@@ -143,6 +169,7 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 		return kvm_psci_call(vcpu);
 	}
 
+out:
 	smccc_set_retval(vcpu, val[0], val[1], val[2], val[3]);
 	return 1;
 }
@@ -153,9 +180,25 @@ static const u64 kvm_arm_fw_reg_ids[] = {
 	KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2,
 };
 
+static const u64 kvm_arm_fw_reg_bmap_ids[] = {
+	KVM_REG_ARM_STD_BMAP,
+};
+
+void kvm_arm_init_hypercalls(struct kvm *kvm)
+{
+	struct kvm_hvc_desc *hvc_desc = &kvm->arch.hvc_desc;
+
+	hvc_desc->hvc_std_bmap = ARM_SMCCC_STD_FEATURES;
+}
+
+int kvm_arm_num_fw_bmap_regs(void)
+{
+	return ARRAY_SIZE(kvm_arm_fw_reg_bmap_ids);
+}
+
 int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu)
 {
-	return ARRAY_SIZE(kvm_arm_fw_reg_ids);
+	return ARRAY_SIZE(kvm_arm_fw_reg_ids) + kvm_arm_num_fw_bmap_regs();
 }
 
 int kvm_arm_copy_fw_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
@@ -167,6 +210,11 @@ int kvm_arm_copy_fw_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
 			return -EFAULT;
 	}
 
+	for (i = 0; i < ARRAY_SIZE(kvm_arm_fw_reg_bmap_ids); i++) {
+		if (put_user(kvm_arm_fw_reg_bmap_ids[i], uindices++))
+			return -EFAULT;
+	}
+
 	return 0;
 }
 
@@ -211,9 +259,20 @@ static int get_kernel_wa_level(u64 regid)
 	return -EINVAL;
 }
 
+static void
+kvm_arm_get_fw_reg_bmap(struct kvm_vcpu *vcpu, u64 fw_reg_bmap, u64 *val)
+{
+	struct kvm *kvm = vcpu->kvm;
+
+	mutex_lock(&kvm->lock);
+	*val = fw_reg_bmap;
+	mutex_unlock(&kvm->lock);
+}
+
 int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 {
 	void __user *uaddr = (void __user *)(long)reg->addr;
+	struct kvm_hvc_desc *hvc_desc = &vcpu->kvm->arch.hvc_desc;
 	u64 val;
 
 	switch (reg->id) {
@@ -224,6 +283,9 @@ int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2:
 		val = get_kernel_wa_level(reg->id) & KVM_REG_FEATURE_LEVEL_MASK;
 		break;
+	case KVM_REG_ARM_STD_BMAP:
+		kvm_arm_get_fw_reg_bmap(vcpu, hvc_desc->hvc_std_bmap, &val);
+		break;
 	default:
 		return -ENOENT;
 	}
@@ -234,6 +296,43 @@ int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	return 0;
 }
 
+static int kvm_arm_set_fw_reg_bmap(struct kvm_vcpu *vcpu, u64 reg_id, u64 val)
+{
+	int ret = 0;
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_hvc_desc *hvc_desc = &kvm->arch.hvc_desc;
+	u64 *fw_reg_bmap, fw_reg_features;
+
+	switch (reg_id) {
+	case KVM_REG_ARM_STD_BMAP:
+		fw_reg_bmap = &hvc_desc->hvc_std_bmap;
+		fw_reg_features = ARM_SMCCC_STD_FEATURES;
+		break;
+	default:
+		return -ENOENT;
+	}
+
+	/* Check for unsupported bit */
+	if (val & ~fw_reg_features)
+		return -EINVAL;
+
+	mutex_lock(&kvm->lock);
+
+	/*
+	 * If the VM (any vCPU) has already started running, return success
+	 * if there's no change in the value. Else, return -EBUSY.
+	 */
+	if (kvm_vm_has_started(kvm)) {
+		ret = *fw_reg_bmap != val ? -EBUSY : 0;
+		goto out;
+	}
+
+	*fw_reg_bmap = val;
+out:
+	mutex_unlock(&kvm->lock);
+	return ret;
+}
+
 int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 {
 	void __user *uaddr = (void __user *)(long)reg->addr;
@@ -310,6 +409,8 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 			return -EINVAL;
 
 		return 0;
+	case KVM_REG_ARM_STD_BMAP:
+		return kvm_arm_set_fw_reg_bmap(vcpu, reg->id, val);
 	default:
 		return -ENOENT;
 	}
diff --git a/arch/arm64/kvm/trng.c b/arch/arm64/kvm/trng.c
index 99bdd7103c9c..23f912514b06 100644
--- a/arch/arm64/kvm/trng.c
+++ b/arch/arm64/kvm/trng.c
@@ -60,14 +60,8 @@ int kvm_trng_call(struct kvm_vcpu *vcpu)
 		val = ARM_SMCCC_TRNG_VERSION_1_0;
 		break;
 	case ARM_SMCCC_TRNG_FEATURES:
-		switch (smccc_get_arg1(vcpu)) {
-		case ARM_SMCCC_TRNG_VERSION:
-		case ARM_SMCCC_TRNG_FEATURES:
-		case ARM_SMCCC_TRNG_GET_UUID:
-		case ARM_SMCCC_TRNG_RND32:
-		case ARM_SMCCC_TRNG_RND64:
+		if (kvm_hvc_call_supported(vcpu, smccc_get_arg1(vcpu)))
 			val = TRNG_SUCCESS;
-		}
 		break;
 	case ARM_SMCCC_TRNG_GET_UUID:
 		smccc_set_retval(vcpu, le32_to_cpu(u[0]), le32_to_cpu(u[1]),
diff --git a/include/kvm/arm_hypercalls.h b/include/kvm/arm_hypercalls.h
index 5d38628a8d04..8fe68d8d6d96 100644
--- a/include/kvm/arm_hypercalls.h
+++ b/include/kvm/arm_hypercalls.h
@@ -6,6 +6,9 @@
 
 #include <asm/kvm_emulate.h>
 
+#define ARM_SMCCC_STD_FEATURES \
+	GENMASK_ULL(KVM_REG_ARM_STD_BMAP_BIT_MAX, 0)
+
 int kvm_hvc_call_handler(struct kvm_vcpu *vcpu);
 
 static inline u32 smccc_get_function(struct kvm_vcpu *vcpu)
@@ -42,9 +45,12 @@ static inline void smccc_set_retval(struct kvm_vcpu *vcpu,
 
 struct kvm_one_reg;
 
+void kvm_arm_init_hypercalls(struct kvm *kvm);
+int kvm_arm_num_fw_bmap_regs(void);
 int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu);
 int kvm_arm_copy_fw_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices);
 int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
 int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
+bool kvm_hvc_call_supported(struct kvm_vcpu *vcpu, u32 func_id);
 
 #endif
-- 
2.34.1.448.ga2b2bfdf31-goog

