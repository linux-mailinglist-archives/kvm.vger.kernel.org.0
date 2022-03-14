Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4F5E4D7ABE
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 07:23:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236363AbiCNGYN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 02:24:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230000AbiCNGYL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 02:24:11 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E44C2A1A4
        for <kvm@vger.kernel.org>; Sun, 13 Mar 2022 23:23:01 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id o41-20020a17090a0a2c00b001bf06e5badfso9280724pjo.3
        for <kvm@vger.kernel.org>; Sun, 13 Mar 2022 23:23:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=f/fYF1VoRAQEz03REOBoSds3NdjEfaVw2lVGAOw0KIw=;
        b=kJqt/wiVmXuDOJh+d3kVDVYz7SKpdAXDuLlcbv/63ivWr0R3h9XzjiKhzRrfzKeyb0
         tDVGuq2WfMOrqpNU5Fc3SZ9HNPp0pGPxZxB20DwU9VwKrKM6z5QrQtJl/zVLdrrhBH4l
         1bjkFkf4yrYCN0QUsi/ZEgC3DBpGrjkUDeVSaDL0JDnLNh1MJqJcsM41UoXhr/HmYHiu
         PnZrlv96hGcEVcSV+0BuGOr1V1fbEo1fGM1v3fHnj5VawY6VYT03hN0+uef5b0gmuQhp
         USWR/DRmdI09pPuaLF+AYaIXX+NpOtCW/477OkLY28kvc6diIvoz6xVOiEDisFF4c5ZP
         hA7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=f/fYF1VoRAQEz03REOBoSds3NdjEfaVw2lVGAOw0KIw=;
        b=aH8VDxYs8veAM+u/1SwfalUfbVnYCcsQEU0anQ5LmXW4LGJzPE6N/+K9myyRJR9UWI
         xKECA4rzu4BB6V/c7qH7mTN0fPVSVvafcpJzrnagNUpGv9jFw7gF3MlRThmUcKXnMJxY
         NNf4wp6ScFjSmfn+t7B5DJ71HTYr225s4JmS8OulIKXMDTalGBi+txvsEz44xAgh7LEx
         CSRQ3Zbvubff4kVYVwGQGmx6n63HEW7QImZ4Pa4GfLYq2SCLAlQijY+cCrCNsELRQEuv
         fcBbdI9DY2BkNkTp0iFdrmHBXkfaJZMTZ3ezw/ZQP5k36UCQfEVJmg7eMaQkX4zAD5qL
         Tutg==
X-Gm-Message-State: AOAM531dXeb0BkC1aPzmNUSV+d9vhLnehpGKZIpdPJPAY2qBoBGr+14+
        wI38CySN8zrHvgDfcXGHf+eBA6k7qMY=
X-Google-Smtp-Source: ABdhPJywoNjAUvPNiLxEdffEhXhP3oLl7v1t343ooaQtBU6jprhphTmOak8Xd6rBYY99BI/aTW9VvdzLFoc=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90b:1e10:b0:1bf:6c78:54a9 with SMTP id
 pg16-20020a17090b1e1000b001bf6c7854a9mr1697660pjb.1.1647238981030; Sun, 13
 Mar 2022 23:23:01 -0700 (PDT)
Date:   Sun, 13 Mar 2022 23:19:58 -0700
In-Reply-To: <20220314061959.3349716-1-reijiw@google.com>
Message-Id: <20220314061959.3349716-3-reijiw@google.com>
Mime-Version: 1.0
References: <20220314061959.3349716-1-reijiw@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v4 2/3] KVM: arm64: mixed-width check should be skipped for
 uninitialized vCPUs
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Peng Liang <liangpeng10@huawei.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Reiji Watanabe <reijiw@google.com>
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

KVM allows userspace to configure either all EL1 32bit or 64bit vCPUs
for a guest.  At vCPU reset, vcpu_allowed_register_width() checks
if the vcpu's register width is consistent with all other vCPUs'.
Since the checking is done even against vCPUs that are not initialized
(KVM_ARM_VCPU_INIT has not been done) yet, the uninitialized vCPUs
are erroneously treated as 64bit vCPU, which causes the function to
incorrectly detect a mixed-width VM.

Introduce KVM_ARCH_FLAG_EL1_32BIT and KVM_ARCH_FLAG_REG_WIDTH_CONFIGURED
bits for kvm->arch.flags.  A value of the EL1_32BIT bit indicates that
the guest needs to be configured with all 32bit or 64bit vCPUs, and
a value of the REG_WIDTH_CONFIGURED bit indicates if a value of the
EL1_32BIT bit is valid (already set up). Values in those bits are set at
the first KVM_ARM_VCPU_INIT for the guest based on KVM_ARM_VCPU_EL1_32BIT
configuration for the vCPU.

Check vcpu's register width against those new bits at the vcpu's
KVM_ARM_VCPU_INIT (instead of against other vCPUs' register width).

Fixes: 66e94d5cafd4 ("KVM: arm64: Prevent mixed-width VM creation")
Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/kvm_emulate.h | 27 ++++++++----
 arch/arm64/include/asm/kvm_host.h    |  9 ++++
 arch/arm64/kvm/reset.c               | 64 ++++++++++++++++++----------
 3 files changed, 70 insertions(+), 30 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index d62405ce3e6d..7496deab025a 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -43,10 +43,22 @@ void kvm_inject_pabt(struct kvm_vcpu *vcpu, unsigned long addr);
 
 void kvm_vcpu_wfi(struct kvm_vcpu *vcpu);
 
+#if defined(__KVM_VHE_HYPERVISOR__) || defined(__KVM_NVHE_HYPERVISOR__)
 static __always_inline bool vcpu_el1_is_32bit(struct kvm_vcpu *vcpu)
 {
 	return !(vcpu->arch.hcr_el2 & HCR_RW);
 }
+#else
+static __always_inline bool vcpu_el1_is_32bit(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+
+	WARN_ON_ONCE(!test_bit(KVM_ARCH_FLAG_REG_WIDTH_CONFIGURED,
+			       &kvm->arch.flags));
+
+	return test_bit(KVM_ARCH_FLAG_EL1_32BIT, &kvm->arch.flags);
+}
+#endif
 
 static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
 {
@@ -72,15 +84,14 @@ static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
 		vcpu->arch.hcr_el2 |= HCR_TVM;
 	}
 
-	if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features))
+	if (vcpu_el1_is_32bit(vcpu))
 		vcpu->arch.hcr_el2 &= ~HCR_RW;
-
-	/*
-	 * TID3: trap feature register accesses that we virtualise.
-	 * For now this is conditional, since no AArch32 feature regs
-	 * are currently virtualised.
-	 */
-	if (!vcpu_el1_is_32bit(vcpu))
+	else
+		/*
+		 * TID3: trap feature register accesses that we virtualise.
+		 * For now this is conditional, since no AArch32 feature regs
+		 * are currently virtualised.
+		 */
 		vcpu->arch.hcr_el2 |= HCR_TID3;
 
 	if (cpus_have_const_cap(ARM64_MISMATCHED_CACHE_TYPE) ||
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 11a7ae747ded..22ad977069f5 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -125,6 +125,15 @@ struct kvm_arch {
 #define KVM_ARCH_FLAG_RETURN_NISV_IO_ABORT_TO_USER	0
 	/* Memory Tagging Extension enabled for the guest */
 #define KVM_ARCH_FLAG_MTE_ENABLED			1
+	/*
+	 * The following two bits are used to indicate the guest's EL1
+	 * register width configuration. A value of KVM_ARCH_FLAG_EL1_32BIT
+	 * bit is valid only when KVM_ARCH_FLAG_REG_WIDTH_CONFIGURED is set.
+	 * Otherwise, the guest's EL1 register width has not yet been
+	 * determined yet.
+	 */
+#define KVM_ARCH_FLAG_REG_WIDTH_CONFIGURED		2
+#define KVM_ARCH_FLAG_EL1_32BIT				3
 	unsigned long flags;
 
 	/*
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index ecc40c8cd6f6..cbeb6216ee25 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -181,27 +181,45 @@ static int kvm_vcpu_enable_ptrauth(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
-static bool vcpu_allowed_register_width(struct kvm_vcpu *vcpu)
+/*
+ * A guest can have either all EL1 32bit or 64bit vcpus only. It is
+ * indicated by a value of KVM_ARCH_FLAG_EL1_32BIT bit in kvm->arch.flags,
+ * which is valid only when KVM_ARCH_FLAG_REG_WIDTH_CONFIGURED in
+ * kvm->arch.flags is set.
+ * This function sets the EL1_32BIT bit based on the given @is32bit (and
+ * sets REG_WIDTH_CONFIGURED bit). When those flags are already set,
+ * @is32bit must be consistent with the flags.
+ * Returns 0 on success, or non-zero otherwise.
+ */
+static int kvm_set_vm_width(struct kvm *kvm, bool is32bit)
 {
-	struct kvm_vcpu *tmp;
-	bool is32bit;
-	unsigned long i;
+	bool allowed;
+
+	lockdep_assert_held(&kvm->lock);
+
+	if (test_bit(KVM_ARCH_FLAG_REG_WIDTH_CONFIGURED, &kvm->arch.flags)) {
+		/*
+		 * The guest's register width is already configured.
+		 * Make sure that @is32bit is consistent with it.
+		 */
+		allowed = (is32bit ==
+			   test_bit(KVM_ARCH_FLAG_EL1_32BIT, &kvm->arch.flags));
+		return allowed ? 0 : -EINVAL;
+	}
 
-	is32bit = vcpu_has_feature(vcpu, KVM_ARM_VCPU_EL1_32BIT);
 	if (!cpus_have_const_cap(ARM64_HAS_32BIT_EL1) && is32bit)
-		return false;
+		return -EINVAL;
 
 	/* MTE is incompatible with AArch32 */
-	if (kvm_has_mte(vcpu->kvm) && is32bit)
-		return false;
+	if (kvm_has_mte(kvm) && is32bit)
+		return -EINVAL;
 
-	/* Check that the vcpus are either all 32bit or all 64bit */
-	kvm_for_each_vcpu(i, tmp, vcpu->kvm) {
-		if (vcpu_has_feature(tmp, KVM_ARM_VCPU_EL1_32BIT) != is32bit)
-			return false;
-	}
+	if (is32bit)
+		set_bit(KVM_ARCH_FLAG_EL1_32BIT, &kvm->arch.flags);
 
-	return true;
+	set_bit(KVM_ARCH_FLAG_REG_WIDTH_CONFIGURED, &kvm->arch.flags);
+
+	return 0;
 }
 
 /**
@@ -230,10 +248,17 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 	u32 pstate;
 
 	mutex_lock(&vcpu->kvm->lock);
-	reset_state = vcpu->arch.reset_state;
-	WRITE_ONCE(vcpu->arch.reset_state.reset, false);
+	ret = kvm_set_vm_width(vcpu->kvm,
+			       vcpu_has_feature(vcpu, KVM_ARM_VCPU_EL1_32BIT));
+	if (!ret) {
+		reset_state = vcpu->arch.reset_state;
+		WRITE_ONCE(vcpu->arch.reset_state.reset, false);
+	}
 	mutex_unlock(&vcpu->kvm->lock);
 
+	if (ret)
+		return ret;
+
 	/* Reset PMU outside of the non-preemptible section */
 	kvm_pmu_vcpu_reset(vcpu);
 
@@ -260,14 +285,9 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 		}
 	}
 
-	if (!vcpu_allowed_register_width(vcpu)) {
-		ret = -EINVAL;
-		goto out;
-	}
-
 	switch (vcpu->arch.target) {
 	default:
-		if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features)) {
+		if (vcpu_el1_is_32bit(vcpu)) {
 			pstate = VCPU_RESET_PSTATE_SVC;
 		} else {
 			pstate = VCPU_RESET_PSTATE_EL1;
-- 
2.35.1.723.g4982287a31-goog

