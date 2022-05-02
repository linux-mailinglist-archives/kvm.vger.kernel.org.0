Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB6F517AEC
	for <lists+kvm@lfdr.de>; Tue,  3 May 2022 01:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbiEBXms (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 May 2022 19:42:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbiEBXme (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 May 2022 19:42:34 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49123329A6
        for <kvm@vger.kernel.org>; Mon,  2 May 2022 16:39:02 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id p18-20020aa78612000000b0050d1c170018so8698335pfn.15
        for <kvm@vger.kernel.org>; Mon, 02 May 2022 16:39:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Erd91eBMxYL5RN3AW1Ampyw8AjL+yywAzXFIHsV7has=;
        b=j4bUvq3jLCvyiAae8u/L0aDPo5ei5h9yt1egJt3KHUWJrvEwoGdX9CYfar2lrhWPxK
         KE8xiTwOyo13xjU0NZUg9BOLw3BGcDTn1aU3a1Eo7pE1D8KcHj2cTigYz+oDBSb6mh7q
         /r5kj+wE5OO9eGQ6tPQRr9KbZZDZSeizmeE3SaR3ZKnY1RqcenR38upR8JDSGZ2MmVd3
         1jKOWpp+v/wSekf1SayMSnqiKrB5Q6/WCYAjyFDeopdJ6tfX2poY1gUMqndJRUsWnqts
         Ka/QN7ZKSzaVxk6rcVritMz1+S5uJsL4ApYwJBFajUoDgDEdo66YHKeY1+mKveLosxKj
         13Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Erd91eBMxYL5RN3AW1Ampyw8AjL+yywAzXFIHsV7has=;
        b=I/puOo11YwHhIel/Ax1/ymTkWNaoA5ZPR3LGI1vJHj06urk5Epc/rAlm8iaXx7GA3a
         7+4avlcRU62iOHfgtK6vjoM4egw2zS2w+Sl4Gy2bdL02l/FQEf4o2mGgI77t9exqR+DF
         REVNGswTdKA2yInMeMPP535kx4/0vlRwjXOgtpSDlCMoEnGUQ/aj18LNnKjw28SiCGJq
         4ddngQMOhjxmaseZrJVXLPhSVyxJV7aD/9EOivn86ICqE6GVkG/lBMq9OPtwOsd1ofNS
         trrzuuH2PFLL895hT3qemOfCrS73YfnO3yObceK7dhktwSmwTBwoVqBhgVCAkBDEYm/g
         wQVw==
X-Gm-Message-State: AOAM532yCQaH8CxcCduZxaMMl0kDTifSupi/aP+R0ngN+4AWvxySA/2t
        aH1R7if0cGu1QrUot0ykBvzsPdBbuOnm
X-Google-Smtp-Source: ABdhPJzm0X+M89bexQ4/ThmDMbSorl28OooKgfEyVVRLAdp2t0A6SNYuY0igI1AglvM3CZaXh9FzV9vLelIg
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a62:ed0e:0:b0:4fa:11ed:2ad1 with SMTP id
 u14-20020a62ed0e000000b004fa11ed2ad1mr13310605pfh.34.1651534741653; Mon, 02
 May 2022 16:39:01 -0700 (PDT)
Date:   Mon,  2 May 2022 23:38:46 +0000
In-Reply-To: <20220502233853.1233742-1-rananta@google.com>
Message-Id: <20220502233853.1233742-3-rananta@google.com>
Mime-Version: 1.0
References: <20220502233853.1233742-1-rananta@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH v7 2/9] KVM: arm64: Setup a framework for hypercall bitmap
 firmware registers
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

KVM regularly introduces new hypercall services to the guests without
any consent from the userspace. This means, the guests can observe
hypercall services in and out as they migrate across various host
kernel versions. This could be a major problem if the guest
discovered a hypercall, started using it, and after getting migrated
to an older kernel realizes that it's no longer available. Depending
on how the guest handles the change, there's a potential chance that
the guest would just panic.

As a result, there's a need for the userspace to elect the services
that it wishes the guest to discover. It can elect these services
based on the kernels spread across its (migration) fleet. To remedy
this, extend the existing firmware pseudo-registers, such as
KVM_REG_ARM_PSCI_VERSION, but by creating a new COPROC register space
for all the hypercall services available.

These firmware registers are categorized based on the service call
owners, but unlike the existing firmware pseudo-registers, they hold
the features supported in the form of a bitmap.

During the VM initialization, the registers are set to upper-limit of
the features supported by the corresponding registers. It's expected
that the VMMs discover the features provided by each register via
GET_ONE_REG, and write back the desired values using SET_ONE_REG.
KVM allows this modification only until the VM has started.

Some of the standard features are not mapped to any bits of the
registers. But since they can recreate the original problem of
making it available without userspace's consent, they need to
be explicitly added to the case-list in
kvm_hvc_call_default_allowed(). Any function-id that's not enabled
via the bitmap, or not listed in kvm_hvc_call_default_allowed, will
be returned as SMCCC_RET_NOT_SUPPORTED to the guest.

Older userspace code can simply ignore the feature and the
hypercall services will be exposed unconditionally to the guests,
thus ensuring backward compatibility.

In this patch, the framework adds the register only for ARM's standard
secure services (owner value 4). Currently, this includes support only
for ARM True Random Number Generator (TRNG) service, with bit-0 of the
register representing mandatory features of v1.0. Other services are
momentarily added in the upcoming patches.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/include/asm/kvm_host.h |  12 ++++
 arch/arm64/include/uapi/asm/kvm.h |   9 +++
 arch/arm64/kvm/arm.c              |   1 +
 arch/arm64/kvm/guest.c            |   8 ++-
 arch/arm64/kvm/hypercalls.c       | 106 ++++++++++++++++++++++++++++++
 arch/arm64/kvm/psci.c             |  13 ++++
 include/kvm/arm_hypercalls.h      |   6 ++
 include/kvm/arm_psci.h            |   2 +-
 8 files changed, 154 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 94a27a7520f4..fef597af0beb 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -101,6 +101,15 @@ struct kvm_s2_mmu {
 struct kvm_arch_memory_slot {
 };
 
+/**
+ * struct kvm_smccc_features: Descriptor of the hypercall services exposed to the guests
+ *
+ * @std_bmap: Bitmap of standard secure service calls
+ */
+struct kvm_smccc_features {
+	unsigned long std_bmap;
+};
+
 struct kvm_arch {
 	struct kvm_s2_mmu mmu;
 
@@ -150,6 +159,9 @@ struct kvm_arch {
 
 	u8 pfr0_csv2;
 	u8 pfr0_csv3;
+
+	/* Hypercall features firmware registers' descriptor */
+	struct kvm_smccc_features smccc_feat;
 };
 
 struct kvm_vcpu_fault_info {
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index c1b6ddc02d2f..0b79d2dc6ffd 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -332,6 +332,15 @@ struct kvm_arm_copy_mte_tags {
 #define KVM_ARM64_SVE_VLS_WORDS	\
 	((KVM_ARM64_SVE_VQ_MAX - KVM_ARM64_SVE_VQ_MIN) / 64 + 1)
 
+/* Bitmap feature firmware registers */
+#define KVM_REG_ARM_FW_FEAT_BMAP		(0x0016 << KVM_REG_ARM_COPROC_SHIFT)
+#define KVM_REG_ARM_FW_FEAT_BMAP_REG(r)		(KVM_REG_ARM64 | KVM_REG_SIZE_U64 | \
+						KVM_REG_ARM_FW_FEAT_BMAP |	\
+						((r) & 0xffff))
+
+#define KVM_REG_ARM_STD_BMAP			KVM_REG_ARM_FW_FEAT_BMAP_REG(0)
+#define KVM_REG_ARM_STD_BIT_TRNG_V1_0		0
+
 /* Device Control API: ARM VGIC */
 #define KVM_DEV_ARM_VGIC_GRP_ADDR	0
 #define KVM_DEV_ARM_VGIC_GRP_DIST_REGS	1
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 523bc934fe2f..a37fadbd617e 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -156,6 +156,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	kvm->arch.max_vcpus = kvm_arm_default_max_vcpus();
 
 	set_default_spectre(kvm);
+	kvm_arm_init_hypercalls(kvm);
 
 	return ret;
 out_free_stage2_pgd:
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 0d5cca56cbda..8c607199cad1 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -756,7 +756,9 @@ int kvm_arm_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 
 	switch (reg->id & KVM_REG_ARM_COPROC_MASK) {
 	case KVM_REG_ARM_CORE:	return get_core_reg(vcpu, reg);
-	case KVM_REG_ARM_FW:	return kvm_arm_get_fw_reg(vcpu, reg);
+	case KVM_REG_ARM_FW:
+	case KVM_REG_ARM_FW_FEAT_BMAP:
+		return kvm_arm_get_fw_reg(vcpu, reg);
 	case KVM_REG_ARM64_SVE:	return get_sve_reg(vcpu, reg);
 	}
 
@@ -774,7 +776,9 @@ int kvm_arm_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 
 	switch (reg->id & KVM_REG_ARM_COPROC_MASK) {
 	case KVM_REG_ARM_CORE:	return set_core_reg(vcpu, reg);
-	case KVM_REG_ARM_FW:	return kvm_arm_set_fw_reg(vcpu, reg);
+	case KVM_REG_ARM_FW:
+	case KVM_REG_ARM_FW_FEAT_BMAP:
+		return kvm_arm_set_fw_reg(vcpu, reg);
 	case KVM_REG_ARM64_SVE:	return set_sve_reg(vcpu, reg);
 	}
 
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index fa6d9378d8e7..5c53fd1f5690 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -58,6 +58,48 @@ static void kvm_ptp_get_time(struct kvm_vcpu *vcpu, u64 *val)
 	val[3] = lower_32_bits(cycles);
 }
 
+static bool kvm_arm_fw_reg_feat_enabled(unsigned long *reg_bmap, unsigned long feat_bit)
+{
+	return test_bit(feat_bit, reg_bmap);
+}
+
+static bool kvm_hvc_call_default_allowed(u32 func_id)
+{
+	switch (func_id) {
+	/*
+	 * List of function-ids that are not gated with the bitmapped feature
+	 * firmware registers, and are to be allowed for servicing the call by default.
+	 */
+	case ARM_SMCCC_VERSION_FUNC_ID:
+	case ARM_SMCCC_ARCH_FEATURES_FUNC_ID:
+	case ARM_SMCCC_HV_PV_TIME_FEATURES:
+	case ARM_SMCCC_HV_PV_TIME_ST:
+	case ARM_SMCCC_VENDOR_HYP_CALL_UID_FUNC_ID:
+	case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
+	case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
+		return true;
+	default:
+		return kvm_psci_func_id_is_valid(func_id);
+	}
+}
+
+static bool kvm_hvc_call_allowed(struct kvm_vcpu *vcpu, u32 func_id)
+{
+	struct kvm_smccc_features *smccc_feat = &vcpu->kvm->arch.smccc_feat;
+
+	switch (func_id) {
+	case ARM_SMCCC_TRNG_VERSION:
+	case ARM_SMCCC_TRNG_FEATURES:
+	case ARM_SMCCC_TRNG_GET_UUID:
+	case ARM_SMCCC_TRNG_RND32:
+	case ARM_SMCCC_TRNG_RND64:
+		return kvm_arm_fw_reg_feat_enabled(&smccc_feat->std_bmap,
+						KVM_REG_ARM_STD_BIT_TRNG_V1_0);
+	default:
+		return kvm_hvc_call_default_allowed(func_id);
+	}
+}
+
 int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 {
 	u32 func_id = smccc_get_function(vcpu);
@@ -65,6 +107,9 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 	u32 feature;
 	gpa_t gpa;
 
+	if (!kvm_hvc_call_allowed(vcpu, func_id))
+		goto out;
+
 	switch (func_id) {
 	case ARM_SMCCC_VERSION_FUNC_ID:
 		val[0] = ARM_SMCCC_VERSION_1_1;
@@ -155,6 +200,7 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 		return kvm_psci_call(vcpu);
 	}
 
+out:
 	smccc_set_retval(vcpu, val[0], val[1], val[2], val[3]);
 	return 1;
 }
@@ -164,8 +210,16 @@ static const u64 kvm_arm_fw_reg_ids[] = {
 	KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1,
 	KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2,
 	KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3,
+	KVM_REG_ARM_STD_BMAP,
 };
 
+void kvm_arm_init_hypercalls(struct kvm *kvm)
+{
+	struct kvm_smccc_features *smccc_feat = &kvm->arch.smccc_feat;
+
+	smccc_feat->std_bmap = KVM_ARM_SMCCC_STD_FEATURES;
+}
+
 int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu)
 {
 	return ARRAY_SIZE(kvm_arm_fw_reg_ids);
@@ -237,6 +291,7 @@ static int get_kernel_wa_level(u64 regid)
 
 int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 {
+	struct kvm_smccc_features *smccc_feat = &vcpu->kvm->arch.smccc_feat;
 	void __user *uaddr = (void __user *)(long)reg->addr;
 	u64 val;
 
@@ -249,6 +304,9 @@ int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3:
 		val = get_kernel_wa_level(reg->id) & KVM_REG_FEATURE_LEVEL_MASK;
 		break;
+	case KVM_REG_ARM_STD_BMAP:
+		val = READ_ONCE(smccc_feat->std_bmap);
+		break;
 	default:
 		return -ENOENT;
 	}
@@ -259,6 +317,52 @@ int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	return 0;
 }
 
+static int kvm_arm_set_fw_reg_bmap(struct kvm_vcpu *vcpu, u64 reg_id, u64 val)
+{
+	int ret = 0;
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_smccc_features *smccc_feat = &kvm->arch.smccc_feat;
+	unsigned long *fw_reg_bmap, fw_reg_features;
+
+	switch (reg_id) {
+	case KVM_REG_ARM_STD_BMAP:
+		fw_reg_bmap = &smccc_feat->std_bmap;
+		fw_reg_features = KVM_ARM_SMCCC_STD_FEATURES;
+		break;
+	default:
+		return -ENOENT;
+	}
+
+	/* Check for unsupported bit */
+	if (val & ~fw_reg_features)
+		return -EINVAL;
+
+	/*
+	 * Return -EBUSY if the VM (any vCPU) has already started running.
+	 *
+	 * To avoid unnecessary serialization of kvm->lock, check for
+	 * KVM_ARCH_FLAG_HAS_RAN_ONCE, or if there's an update to the
+	 * current bitmap's value, before grabbing the lock.
+	 */
+	if (test_bit(KVM_ARCH_FLAG_HAS_RAN_ONCE, &kvm->arch.flags))
+		return -EBUSY;
+
+	if (val == *fw_reg_bmap)
+		return 0;
+
+	mutex_lock(&kvm->lock);
+
+	if (test_bit(KVM_ARCH_FLAG_HAS_RAN_ONCE, &kvm->arch.flags)) {
+		ret = -EBUSY;
+		goto out;
+	}
+
+	WRITE_ONCE(*fw_reg_bmap, val);
+out:
+	mutex_unlock(&kvm->lock);
+	return ret;
+}
+
 int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 {
 	void __user *uaddr = (void __user *)(long)reg->addr;
@@ -337,6 +441,8 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 			return -EINVAL;
 
 		return 0;
+	case KVM_REG_ARM_STD_BMAP:
+		return kvm_arm_set_fw_reg_bmap(vcpu, reg->id, val);
 	default:
 		return -ENOENT;
 	}
diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index 4bb76eb09248..94111f02674f 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -437,3 +437,16 @@ int kvm_psci_call(struct kvm_vcpu *vcpu)
 		return -EINVAL;
 	}
 }
+
+bool kvm_psci_func_id_is_valid(u32 func_id)
+{
+	if (ARM_SMCCC_OWNER_NUM(func_id) == ARM_SMCCC_OWNER_STANDARD &&
+		ARM_SMCCC_FUNC_NUM(func_id) >= 0 && ARM_SMCCC_FUNC_NUM(func_id) <= 0x1f)
+		return true;
+
+	/* KVM's PSCI 0.1 doesn't comply with SMCCC, and has its own function-id base and range */
+	if (func_id >= KVM_PSCI_FN(0) && func_id <= KVM_PSCI_FN(3))
+		return true;
+
+	return false;
+}
diff --git a/include/kvm/arm_hypercalls.h b/include/kvm/arm_hypercalls.h
index 5d38628a8d04..c832e8411609 100644
--- a/include/kvm/arm_hypercalls.h
+++ b/include/kvm/arm_hypercalls.h
@@ -6,6 +6,11 @@
 
 #include <asm/kvm_emulate.h>
 
+/* Last valid bit of the bitmapped firmware registers */
+#define KVM_REG_ARM_STD_BMAP_BIT_MAX		0
+
+#define KVM_ARM_SMCCC_STD_FEATURES		GENMASK(KVM_REG_ARM_STD_BMAP_BIT_MAX, 0)
+
 int kvm_hvc_call_handler(struct kvm_vcpu *vcpu);
 
 static inline u32 smccc_get_function(struct kvm_vcpu *vcpu)
@@ -42,6 +47,7 @@ static inline void smccc_set_retval(struct kvm_vcpu *vcpu,
 
 struct kvm_one_reg;
 
+void kvm_arm_init_hypercalls(struct kvm *kvm);
 int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu);
 int kvm_arm_copy_fw_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices);
 int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
diff --git a/include/kvm/arm_psci.h b/include/kvm/arm_psci.h
index 6e55b9283789..1f9ec5f2e513 100644
--- a/include/kvm/arm_psci.h
+++ b/include/kvm/arm_psci.h
@@ -36,7 +36,7 @@ static inline int kvm_psci_version(struct kvm_vcpu *vcpu)
 	return KVM_ARM_PSCI_0_1;
 }
 
-
 int kvm_psci_call(struct kvm_vcpu *vcpu);
+bool kvm_psci_func_id_is_valid(u32 func_id);
 
 #endif /* __KVM_ARM_PSCI_H__ */
-- 
2.36.0.464.gb9c8b46e94-goog

