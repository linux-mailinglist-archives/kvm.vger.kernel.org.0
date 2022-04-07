Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C59AE4F703F
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 03:19:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237556AbiDGBUr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 21:20:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240421AbiDGBT7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 21:19:59 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CE7519481D
        for <kvm@vger.kernel.org>; Wed,  6 Apr 2022 18:16:14 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id c9-20020a17090a1d0900b001caaf769af6so2602639pjd.2
        for <kvm@vger.kernel.org>; Wed, 06 Apr 2022 18:16:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=5u03x/HLlc0Hh1druSco9/87yvuZ6sE0IlI0HvYdiu0=;
        b=Alx8hkns9cY4mkrWASLK8H9Kz4uhW7TPyd6Rx3GCipVugvHQs7OYifTbc0s4oJbAOs
         mohz8IE2bZJispvbmmOetYEi54FH+28oSxl9PRia+CcvKEzhh37WF+YJmt67j/KYw2oT
         7ncpzhK7VQxY9Wm3VnkrJehCglwjVHu6LQoRAw6IWBRfqBM0DbuIbWEEeAsSwf0Z0CGa
         BsVz+nYQ5f72vgCc77pw3c/H+rLPG0nXux0vQc6EeTTAiNkzh1KEnNPvmEL8aNw3Kj9z
         XbGyYkIR5dxiCVC9r9XjwI0byqi3XgM855DtnE09pvi404melE3nsov7M4uS1z4MnbC3
         A0vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=5u03x/HLlc0Hh1druSco9/87yvuZ6sE0IlI0HvYdiu0=;
        b=FTyBUzI+9Snqq2FZzUVtotCBrwIaP9eR6QYMQptjA0mXRtTDGRBSEalLfSiBsxVfB2
         EveU/O54F0nFrArYJ4GvuaVDwrWkc3LtgvO/azeen+JrBEiFLzrtEj2z+jozCve/kiQY
         xNBfYORVqN0MFKXClpqsExuUEGItVFbSWtP1Zf9jrtPI8IKxMvWemivc++F8TacHu+WZ
         s5qhD6DyPzxREBJQhD53L0PQVu87fWzPsY7pkZKc7Ar+u6cT+pCjxo2zawGtyociD7b5
         /TVf8OP+qgSrhM8Dp0ORY70SDdEALCKasNk/eMYOjYUCmVBeb3oChAYukQRZcI6FpRqp
         XqVg==
X-Gm-Message-State: AOAM532JVCJpOp0NicVkwFQgVhp6PVXUvhTPbvM+aUbWsbxaatex9IJ2
        escoElA0SASpQBJSx1SY3aa7gLNqfmAm
X-Google-Smtp-Source: ABdhPJxU79isHzLX38OUe4Fk8yt6G8cVN12RodinD1QS0nGJk/LJKfNc1C++G94WOMqMh71LmXQAMrmjxaNc
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:90b:4d8d:b0:1c9:961c:19d2 with SMTP id
 oj13-20020a17090b4d8d00b001c9961c19d2mr12948118pjb.176.1649294174034; Wed, 06
 Apr 2022 18:16:14 -0700 (PDT)
Date:   Thu,  7 Apr 2022 01:15:56 +0000
In-Reply-To: <20220407011605.1966778-1-rananta@google.com>
Message-Id: <20220407011605.1966778-2-rananta@google.com>
Mime-Version: 1.0
References: <20220407011605.1966778-1-rananta@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v5 01/10] KVM: arm64: Factor out firmware register handling
 from psci.c
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

Common hypercall firmware register handing is currently employed
by psci.c. Since the upcoming patches add more of these registers,
it's better to move the generic handling to hypercall.c for a
cleaner presentation.

While we are at it, collect all the firmware registers under
fw_reg_ids[] to help implement kvm_arm_get_fw_num_regs() and
kvm_arm_copy_fw_reg_indices() in a generic way. Also, define
KVM_REG_FEATURE_LEVEL_MASK using a GENMASK instead.

No functional change intended.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Reviewed-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/guest.c       |   2 +-
 arch/arm64/kvm/hypercalls.c  | 185 +++++++++++++++++++++++++++++++++++
 arch/arm64/kvm/psci.c        | 183 ----------------------------------
 include/kvm/arm_hypercalls.h |   7 ++
 include/kvm/arm_psci.h       |   7 --
 5 files changed, 193 insertions(+), 191 deletions(-)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 7e15b03fbdf8..0d5cca56cbda 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -18,7 +18,7 @@
 #include <linux/string.h>
 #include <linux/vmalloc.h>
 #include <linux/fs.h>
-#include <kvm/arm_psci.h>
+#include <kvm/arm_hypercalls.h>
 #include <asm/cputype.h>
 #include <linux/uaccess.h>
 #include <asm/fpsimd.h>
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 202b8c455724..fa6d9378d8e7 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -158,3 +158,188 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 	smccc_set_retval(vcpu, val[0], val[1], val[2], val[3]);
 	return 1;
 }
+
+static const u64 kvm_arm_fw_reg_ids[] = {
+	KVM_REG_ARM_PSCI_VERSION,
+	KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1,
+	KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2,
+	KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3,
+};
+
+int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu)
+{
+	return ARRAY_SIZE(kvm_arm_fw_reg_ids);
+}
+
+int kvm_arm_copy_fw_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(kvm_arm_fw_reg_ids); i++) {
+		if (put_user(kvm_arm_fw_reg_ids[i], uindices++))
+			return -EFAULT;
+	}
+
+	return 0;
+}
+
+#define KVM_REG_FEATURE_LEVEL_WIDTH	4
+#define KVM_REG_FEATURE_LEVEL_MASK	GENMASK(KVM_REG_FEATURE_LEVEL_WIDTH, 0)
+
+/*
+ * Convert the workaround level into an easy-to-compare number, where higher
+ * values mean better protection.
+ */
+static int get_kernel_wa_level(u64 regid)
+{
+	switch (regid) {
+	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1:
+		switch (arm64_get_spectre_v2_state()) {
+		case SPECTRE_VULNERABLE:
+			return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_NOT_AVAIL;
+		case SPECTRE_MITIGATED:
+			return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_AVAIL;
+		case SPECTRE_UNAFFECTED:
+			return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_NOT_REQUIRED;
+		}
+		return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_NOT_AVAIL;
+	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2:
+		switch (arm64_get_spectre_v4_state()) {
+		case SPECTRE_MITIGATED:
+			/*
+			 * As for the hypercall discovery, we pretend we
+			 * don't have any FW mitigation if SSBS is there at
+			 * all times.
+			 */
+			if (cpus_have_final_cap(ARM64_SSBS))
+				return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_AVAIL;
+			fallthrough;
+		case SPECTRE_UNAFFECTED:
+			return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_REQUIRED;
+		case SPECTRE_VULNERABLE:
+			return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_AVAIL;
+		}
+		break;
+	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3:
+		switch (arm64_get_spectre_bhb_state()) {
+		case SPECTRE_VULNERABLE:
+			return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3_NOT_AVAIL;
+		case SPECTRE_MITIGATED:
+			return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3_AVAIL;
+		case SPECTRE_UNAFFECTED:
+			return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3_NOT_REQUIRED;
+		}
+		return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3_NOT_AVAIL;
+	}
+
+	return -EINVAL;
+}
+
+int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
+{
+	void __user *uaddr = (void __user *)(long)reg->addr;
+	u64 val;
+
+	switch (reg->id) {
+	case KVM_REG_ARM_PSCI_VERSION:
+		val = kvm_psci_version(vcpu);
+		break;
+	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1:
+	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2:
+	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3:
+		val = get_kernel_wa_level(reg->id) & KVM_REG_FEATURE_LEVEL_MASK;
+		break;
+	default:
+		return -ENOENT;
+	}
+
+	if (copy_to_user(uaddr, &val, KVM_REG_SIZE(reg->id)))
+		return -EFAULT;
+
+	return 0;
+}
+
+int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
+{
+	void __user *uaddr = (void __user *)(long)reg->addr;
+	u64 val;
+	int wa_level;
+
+	if (copy_from_user(&val, uaddr, KVM_REG_SIZE(reg->id)))
+		return -EFAULT;
+
+	switch (reg->id) {
+	case KVM_REG_ARM_PSCI_VERSION:
+	{
+		bool wants_02;
+
+		wants_02 = test_bit(KVM_ARM_VCPU_PSCI_0_2, vcpu->arch.features);
+
+		switch (val) {
+		case KVM_ARM_PSCI_0_1:
+			if (wants_02)
+				return -EINVAL;
+			vcpu->kvm->arch.psci_version = val;
+			return 0;
+		case KVM_ARM_PSCI_0_2:
+		case KVM_ARM_PSCI_1_0:
+		case KVM_ARM_PSCI_1_1:
+			if (!wants_02)
+				return -EINVAL;
+			vcpu->kvm->arch.psci_version = val;
+			return 0;
+		}
+		break;
+	}
+
+	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1:
+	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3:
+		if (val & ~KVM_REG_FEATURE_LEVEL_MASK)
+			return -EINVAL;
+
+		if (get_kernel_wa_level(reg->id) < val)
+			return -EINVAL;
+
+		return 0;
+
+	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2:
+		if (val & ~(KVM_REG_FEATURE_LEVEL_MASK |
+			    KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_ENABLED))
+			return -EINVAL;
+
+		/* The enabled bit must not be set unless the level is AVAIL. */
+		if ((val & KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_ENABLED) &&
+		    (val & KVM_REG_FEATURE_LEVEL_MASK) != KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_AVAIL)
+			return -EINVAL;
+
+		/*
+		 * Map all the possible incoming states to the only two we
+		 * really want to deal with.
+		 */
+		switch (val & KVM_REG_FEATURE_LEVEL_MASK) {
+		case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_AVAIL:
+		case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_UNKNOWN:
+			wa_level = KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_AVAIL;
+			break;
+		case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_AVAIL:
+		case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_REQUIRED:
+			wa_level = KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_REQUIRED;
+			break;
+		default:
+			return -EINVAL;
+		}
+
+		/*
+		 * We can deal with NOT_AVAIL on NOT_REQUIRED, but not the
+		 * other way around.
+		 */
+		if (get_kernel_wa_level(reg->id) < wa_level)
+			return -EINVAL;
+
+		return 0;
+	default:
+		return -ENOENT;
+	}
+
+	return -EINVAL;
+}
diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index 372da09a2fab..bdfa93ca57d1 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -439,186 +439,3 @@ int kvm_psci_call(struct kvm_vcpu *vcpu)
 		return -EINVAL;
 	}
 }
-
-int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu)
-{
-	return 4;		/* PSCI version and three workaround registers */
-}
-
-int kvm_arm_copy_fw_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
-{
-	if (put_user(KVM_REG_ARM_PSCI_VERSION, uindices++))
-		return -EFAULT;
-
-	if (put_user(KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1, uindices++))
-		return -EFAULT;
-
-	if (put_user(KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2, uindices++))
-		return -EFAULT;
-
-	if (put_user(KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3, uindices++))
-		return -EFAULT;
-
-	return 0;
-}
-
-#define KVM_REG_FEATURE_LEVEL_WIDTH	4
-#define KVM_REG_FEATURE_LEVEL_MASK	(BIT(KVM_REG_FEATURE_LEVEL_WIDTH) - 1)
-
-/*
- * Convert the workaround level into an easy-to-compare number, where higher
- * values mean better protection.
- */
-static int get_kernel_wa_level(u64 regid)
-{
-	switch (regid) {
-	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1:
-		switch (arm64_get_spectre_v2_state()) {
-		case SPECTRE_VULNERABLE:
-			return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_NOT_AVAIL;
-		case SPECTRE_MITIGATED:
-			return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_AVAIL;
-		case SPECTRE_UNAFFECTED:
-			return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_NOT_REQUIRED;
-		}
-		return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_NOT_AVAIL;
-	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2:
-		switch (arm64_get_spectre_v4_state()) {
-		case SPECTRE_MITIGATED:
-			/*
-			 * As for the hypercall discovery, we pretend we
-			 * don't have any FW mitigation if SSBS is there at
-			 * all times.
-			 */
-			if (cpus_have_final_cap(ARM64_SSBS))
-				return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_AVAIL;
-			fallthrough;
-		case SPECTRE_UNAFFECTED:
-			return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_REQUIRED;
-		case SPECTRE_VULNERABLE:
-			return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_AVAIL;
-		}
-		break;
-	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3:
-		switch (arm64_get_spectre_bhb_state()) {
-		case SPECTRE_VULNERABLE:
-			return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3_NOT_AVAIL;
-		case SPECTRE_MITIGATED:
-			return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3_AVAIL;
-		case SPECTRE_UNAFFECTED:
-			return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3_NOT_REQUIRED;
-		}
-		return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3_NOT_AVAIL;
-	}
-
-	return -EINVAL;
-}
-
-int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
-{
-	void __user *uaddr = (void __user *)(long)reg->addr;
-	u64 val;
-
-	switch (reg->id) {
-	case KVM_REG_ARM_PSCI_VERSION:
-		val = kvm_psci_version(vcpu);
-		break;
-	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1:
-	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2:
-	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3:
-		val = get_kernel_wa_level(reg->id) & KVM_REG_FEATURE_LEVEL_MASK;
-		break;
-	default:
-		return -ENOENT;
-	}
-
-	if (copy_to_user(uaddr, &val, KVM_REG_SIZE(reg->id)))
-		return -EFAULT;
-
-	return 0;
-}
-
-int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
-{
-	void __user *uaddr = (void __user *)(long)reg->addr;
-	u64 val;
-	int wa_level;
-
-	if (copy_from_user(&val, uaddr, KVM_REG_SIZE(reg->id)))
-		return -EFAULT;
-
-	switch (reg->id) {
-	case KVM_REG_ARM_PSCI_VERSION:
-	{
-		bool wants_02;
-
-		wants_02 = test_bit(KVM_ARM_VCPU_PSCI_0_2, vcpu->arch.features);
-
-		switch (val) {
-		case KVM_ARM_PSCI_0_1:
-			if (wants_02)
-				return -EINVAL;
-			vcpu->kvm->arch.psci_version = val;
-			return 0;
-		case KVM_ARM_PSCI_0_2:
-		case KVM_ARM_PSCI_1_0:
-		case KVM_ARM_PSCI_1_1:
-			if (!wants_02)
-				return -EINVAL;
-			vcpu->kvm->arch.psci_version = val;
-			return 0;
-		}
-		break;
-	}
-
-	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1:
-	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3:
-		if (val & ~KVM_REG_FEATURE_LEVEL_MASK)
-			return -EINVAL;
-
-		if (get_kernel_wa_level(reg->id) < val)
-			return -EINVAL;
-
-		return 0;
-
-	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2:
-		if (val & ~(KVM_REG_FEATURE_LEVEL_MASK |
-			    KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_ENABLED))
-			return -EINVAL;
-
-		/* The enabled bit must not be set unless the level is AVAIL. */
-		if ((val & KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_ENABLED) &&
-		    (val & KVM_REG_FEATURE_LEVEL_MASK) != KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_AVAIL)
-			return -EINVAL;
-
-		/*
-		 * Map all the possible incoming states to the only two we
-		 * really want to deal with.
-		 */
-		switch (val & KVM_REG_FEATURE_LEVEL_MASK) {
-		case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_AVAIL:
-		case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_UNKNOWN:
-			wa_level = KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_AVAIL;
-			break;
-		case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_AVAIL:
-		case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_REQUIRED:
-			wa_level = KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_REQUIRED;
-			break;
-		default:
-			return -EINVAL;
-		}
-
-		/*
-		 * We can deal with NOT_AVAIL on NOT_REQUIRED, but not the
-		 * other way around.
-		 */
-		if (get_kernel_wa_level(reg->id) < wa_level)
-			return -EINVAL;
-
-		return 0;
-	default:
-		return -ENOENT;
-	}
-
-	return -EINVAL;
-}
diff --git a/include/kvm/arm_hypercalls.h b/include/kvm/arm_hypercalls.h
index 0e2509d27910..5d38628a8d04 100644
--- a/include/kvm/arm_hypercalls.h
+++ b/include/kvm/arm_hypercalls.h
@@ -40,4 +40,11 @@ static inline void smccc_set_retval(struct kvm_vcpu *vcpu,
 	vcpu_set_reg(vcpu, 3, a3);
 }
 
+struct kvm_one_reg;
+
+int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu);
+int kvm_arm_copy_fw_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices);
+int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
+int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
+
 #endif
diff --git a/include/kvm/arm_psci.h b/include/kvm/arm_psci.h
index 68b96c3826c3..6e55b9283789 100644
--- a/include/kvm/arm_psci.h
+++ b/include/kvm/arm_psci.h
@@ -39,11 +39,4 @@ static inline int kvm_psci_version(struct kvm_vcpu *vcpu)
 
 int kvm_psci_call(struct kvm_vcpu *vcpu);
 
-struct kvm_one_reg;
-
-int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu);
-int kvm_arm_copy_fw_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices);
-int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
-int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
-
 #endif /* __KVM_ARM_PSCI_H__ */
-- 
2.35.1.1094.g7c7d902a7c-goog

