Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 294F34C0AEE
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 05:19:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237555AbiBWETr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 23:19:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237820AbiBWETq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 23:19:46 -0500
Received: from mail-il1-x149.google.com (mail-il1-x149.google.com [IPv6:2607:f8b0:4864:20::149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43A803D499
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 20:19:19 -0800 (PST)
Received: by mail-il1-x149.google.com with SMTP id 8-20020a921808000000b002c242893628so5754152ily.13
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 20:19:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=q4R57xxRvoqj0jvH1kp4v0WNULcwYMhHe97HrH/NaKs=;
        b=DIrZsjZSKFumvER62QxuVVmXN1YyjtPRSZ3IMZ/epU6OehIQXsMHpDUDJuGM0sOdM9
         Xa3GkIW9L1+RIdnmjFNA5a673Mcz3uKfIixj7KMotznbMEEH9dFB8SmOHRQD74Nh2iU5
         /7EiFdHWmatqdVt7VnOxpVe7w+vjpclEKpBEm02/LK+3qb4UPkYmg4HytmTCzm/wjrnA
         jtes3QqhSyJ8fFm8E02Gd9jcHp35eVR4Rdd9lJpdLD80QoXM56UOdi0o4w/M1qJT+wzi
         MKtM80CRGELEJKjtfsa2TyXi0fnONndSfUgHn+K9t6rJMB14yHAn5o3oXEAtsEZEhBiH
         KKWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=q4R57xxRvoqj0jvH1kp4v0WNULcwYMhHe97HrH/NaKs=;
        b=iGGzL6zAsVVNWxIONv4BdrU/ygD6/S0juqoncMjJ9g0d9nsQ1lzVBIHYeqd6wOGCdB
         l6NtIKGw1s/rcnQV1S444m73ydQDYQzY/+ZB/jwCAZkQI9SIH9J+ip+LBQZN5hN6LdYI
         TvaURqJg8ux1w+uqTjToKijKuFU+wF1pJSh7M+7g7WHrWNFcS51uQrA378zotW5uDClP
         s9jyx714cOxQM7BJZzdYO6sLayjM0RrhQ6mH9NPaZEJ4zXzQuBjqcSevelqaTDnFVSHt
         VgDTkiVDOuQ5diBu0BhCdAOnS+rqE2Ltvx0faDh1bEkhHUkBeQhtUOs297WZbiMVgPkF
         Z8Vg==
X-Gm-Message-State: AOAM530q3JYVcqKVK5M4Aqd6IFfOx7iHCYrajh4H7cwlbM8CENlHi5RP
        IUab4MlKd7MNUS2OK7sWEHIhBiQEsMI=
X-Google-Smtp-Source: ABdhPJyUvSf/lmncTWDQIYy3XL/42+UT+v7lgPaWwTGgn82xM27AgseWmCm72Pgc1Dgi/YpsD2EkZrVPldE=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6e02:1b8e:b0:2c2:2750:1178 with SMTP id
 h14-20020a056e021b8e00b002c227501178mr12158397ili.126.1645589958479; Tue, 22
 Feb 2022 20:19:18 -0800 (PST)
Date:   Wed, 23 Feb 2022 04:18:33 +0000
In-Reply-To: <20220223041844.3984439-1-oupton@google.com>
Message-Id: <20220223041844.3984439-9-oupton@google.com>
Mime-Version: 1.0
References: <20220223041844.3984439-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [PATCH v3 08/19] KVM: arm64: Add reset helper that accepts
 caller-provided reset state
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Peter Shier <pshier@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Oliver Upton <oupton@google.com>
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

To date, struct vcpu_reset_state has been used to implement PSCI CPU_ON,
as callers of this function provide context for the targeted vCPU. A
subsequent change to KVM will require that a vCPU can populate its own
reset context.

Extract the vCPU reset implementation into a new function to separate
the locked read of shared data (vcpu->arch.reset_state) from the use of
the reset context.

No functional change intended.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 16 ++++++-----
 arch/arm64/kvm/reset.c            | 44 +++++++++++++++++++------------
 2 files changed, 36 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 3e8bfecaa95b..33ecec755310 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -67,6 +67,15 @@ extern unsigned int kvm_sve_max_vl;
 int kvm_arm_init_sve(void);
 
 u32 __attribute_const__ kvm_target_cpu(void);
+
+struct vcpu_reset_state {
+	unsigned long	pc;
+	unsigned long	r0;
+	bool		be;
+	bool		reset;
+};
+
+int __kvm_reset_vcpu(struct kvm_vcpu *vcpu, struct vcpu_reset_state *reset_state);
 int kvm_reset_vcpu(struct kvm_vcpu *vcpu);
 void kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu);
 
@@ -271,13 +280,6 @@ extern s64 kvm_nvhe_sym(hyp_physvirt_offset);
 extern u64 kvm_nvhe_sym(hyp_cpu_logical_map)[NR_CPUS];
 #define hyp_cpu_logical_map CHOOSE_NVHE_SYM(hyp_cpu_logical_map)
 
-struct vcpu_reset_state {
-	unsigned long	pc;
-	unsigned long	r0;
-	bool		be;
-	bool		reset;
-};
-
 struct kvm_vcpu_arch {
 	struct kvm_cpu_context ctxt;
 	void *sve_state;
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index ecc40c8cd6f6..f879a8f6a99c 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -205,35 +205,32 @@ static bool vcpu_allowed_register_width(struct kvm_vcpu *vcpu)
 }
 
 /**
- * kvm_reset_vcpu - sets core registers and sys_regs to reset value
+ * __kvm_reset_vcpu - sets core registers and sys_regs to reset value
  * @vcpu: The VCPU pointer
+ * @reset_state: Context to use to reset the vCPU
  *
  * This function sets the registers on the virtual CPU struct to their
  * architecturally defined reset values, except for registers whose reset is
  * deferred until kvm_arm_vcpu_finalize().
  *
- * Note: This function can be called from two paths: The KVM_ARM_VCPU_INIT
- * ioctl or as part of handling a request issued by another VCPU in the PSCI
- * handling code.  In the first case, the VCPU will not be loaded, and in the
- * second case the VCPU will be loaded.  Because this function operates purely
- * on the memory-backed values of system registers, we want to do a full put if
+ * Note: This function can be called from two paths:
+ *  - The KVM_ARM_VCPU_INIT ioctl
+ *  - handling a request issued by another VCPU in the PSCI handling code
+ *
+ * In the first case, the VCPU will not be loaded, and in the second case the
+ * VCPU will be loaded.  Because this function operates purely on the
+ * memory-backed values of system registers, we want to do a full put if
  * we were loaded (handling a request) and load the values back at the end of
  * the function.  Otherwise we leave the state alone.  In both cases, we
  * disable preemption around the vcpu reset as we would otherwise race with
  * preempt notifiers which also call put/load.
  */
-int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
+int __kvm_reset_vcpu(struct kvm_vcpu *vcpu, struct vcpu_reset_state *reset_state)
 {
-	struct vcpu_reset_state reset_state;
 	int ret;
 	bool loaded;
 	u32 pstate;
 
-	mutex_lock(&vcpu->kvm->lock);
-	reset_state = vcpu->arch.reset_state;
-	WRITE_ONCE(vcpu->arch.reset_state.reset, false);
-	mutex_unlock(&vcpu->kvm->lock);
-
 	/* Reset PMU outside of the non-preemptible section */
 	kvm_pmu_vcpu_reset(vcpu);
 
@@ -296,8 +293,8 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 	 * Additional reset state handling that PSCI may have imposed on us.
 	 * Must be done after all the sys_reg reset.
 	 */
-	if (reset_state.reset) {
-		unsigned long target_pc = reset_state.pc;
+	if (reset_state->reset) {
+		unsigned long target_pc = reset_state->pc;
 
 		/* Gracefully handle Thumb2 entry point */
 		if (vcpu_mode_is_32bit(vcpu) && (target_pc & 1)) {
@@ -306,11 +303,11 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 		}
 
 		/* Propagate caller endianness */
-		if (reset_state.be)
+		if (reset_state->be)
 			kvm_vcpu_set_be(vcpu);
 
 		*vcpu_pc(vcpu) = target_pc;
-		vcpu_set_reg(vcpu, 0, reset_state.r0);
+		vcpu_set_reg(vcpu, 0, reset_state->r0);
 	}
 
 	/* Reset timer */
@@ -320,6 +317,19 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 		kvm_arch_vcpu_load(vcpu, smp_processor_id());
 	preempt_enable();
 	return ret;
+
+}
+
+int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_reset_state reset_state;
+
+	mutex_lock(&vcpu->kvm->lock);
+	reset_state = vcpu->arch.reset_state;
+	WRITE_ONCE(vcpu->arch.reset_state.reset, false);
+	mutex_unlock(&vcpu->kvm->lock);
+
+	return __kvm_reset_vcpu(vcpu, &reset_state);
 }
 
 u32 get_kvm_ipa_limit(void)
-- 
2.35.1.473.g83b2b277ed-goog

