Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A5A84C0AE8
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 05:19:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237733AbiBWETn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 23:19:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237177AbiBWETk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 23:19:40 -0500
Received: from mail-ot1-x349.google.com (mail-ot1-x349.google.com [IPv6:2607:f8b0:4864:20::349])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94AAC3B550
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 20:19:13 -0800 (PST)
Received: by mail-ot1-x349.google.com with SMTP id k6-20020a056830168600b005ad4ee444easo9313483otr.20
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 20:19:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=V5qsHM9PPCNHYHtsk7xXfFwoohxSHTAZ/oFj3pAWz30=;
        b=d+BWzznlqCeXnt3CV4ZxwZKy0cQlouKMrCwBYrMN8WxZ4HE6kYGfy+alWWZcj0ITf+
         hRfD7wnAvFYjcAOlBGnsk8bNgy+jL8L57ZbKJFsax/Cy0PgtgxV6DbzZNpSxSQFiHPB2
         rtdm/gbYe3g+CrerxOpjuMmKqJhf/LEC7VdFwY+Vui9oNp3XutwkY7jnHrNAKjQvdSN7
         UHifXytuzFfXAMKnRG0hgx6sFl2llURt6HmHWO9PrPwIw4lw8rSqGU+JB+ucpnzwWXvq
         XVWurRbwxK6RJfONJnUTxjF2wjopFKJFizmshuK/VP6lhzV/tFUQtwTbQjFbz0Geo+8x
         z5dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=V5qsHM9PPCNHYHtsk7xXfFwoohxSHTAZ/oFj3pAWz30=;
        b=Ln/qGXqfPs7fxZPq0Lk1CCuTThWp6deRV20lQVMLjgGpO+Hwd2BrmjefNLim49nk/c
         4hxHuhoaWvxNbYImh6ZsV+Nz281ATgU5RK5fzLMzvak8014dpKjUZuh/bE2bruithUbJ
         IWfVEIJ16Vb0KFK/xWp8K5x9LgxmEQ4t9IKLY1DfDefpkA92j43WK23DaT32W+hQwXEo
         vlglOv8QMvCXoVZu77Jk0z+FCVJV+vT4TLeu8eY5FrvawlMRHyZHhL5/5aJab4dvGKOK
         2yL4ybZXkNLSlW8zG2GFuWZOLIlO6U37vxIyOZjwVeKeDnEKwlFTBVJRLMnQ2wrFgqfH
         bx/g==
X-Gm-Message-State: AOAM531LWToOeBlmCTkI18Bxj51v4LX1bPxXyN/EWgfq9OrC8uPuIq4S
        DgjZnVK4WvQh329ZySZBMnlJIrAU0Ng=
X-Google-Smtp-Source: ABdhPJz2r87HmEpYMAnjO/m9fLbMPEZ1tg4GBYqYnr72VGiUpcnn5x9nctQ9aGq3W7L2fok9q633fRYVs7Y=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6870:4692:b0:d3:f39:92e1 with SMTP id
 a18-20020a056870469200b000d30f3992e1mr3257927oap.69.1645589952479; Tue, 22
 Feb 2022 20:19:12 -0800 (PST)
Date:   Wed, 23 Feb 2022 04:18:30 +0000
In-Reply-To: <20220223041844.3984439-1-oupton@google.com>
Message-Id: <20220223041844.3984439-6-oupton@google.com>
Mime-Version: 1.0
References: <20220223041844.3984439-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [PATCH v3 05/19] KVM: arm64: Dedupe vCPU power off helpers
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

vcpu_power_off() and kvm_psci_vcpu_off() are equivalent; rename the
former and replace all callsites to the latter.

No functional change intended.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  2 ++
 arch/arm64/kvm/arm.c              |  6 +++---
 arch/arm64/kvm/psci.c             | 11 ++---------
 3 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 5bc01e62c08a..cacc9efd2e70 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -799,4 +799,6 @@ void __init kvm_hyp_reserve(void);
 static inline void kvm_hyp_reserve(void) { }
 #endif
 
+void kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu);
+
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index ecc5958e27fe..07c6a176cdcc 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -426,7 +426,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 	vcpu->cpu = -1;
 }
 
-static void vcpu_power_off(struct kvm_vcpu *vcpu)
+void kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.power_off = true;
 	kvm_make_request(KVM_REQ_SLEEP, vcpu);
@@ -454,7 +454,7 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
 		vcpu->arch.power_off = false;
 		break;
 	case KVM_MP_STATE_STOPPED:
-		vcpu_power_off(vcpu);
+		kvm_arm_vcpu_power_off(vcpu);
 		break;
 	default:
 		ret = -EINVAL;
@@ -1179,7 +1179,7 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
 	 * Handle the "start in power-off" case.
 	 */
 	if (test_bit(KVM_ARM_VCPU_POWER_OFF, vcpu->arch.features))
-		vcpu_power_off(vcpu);
+		kvm_arm_vcpu_power_off(vcpu);
 	else
 		vcpu->arch.power_off = false;
 
diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index 4335cd5193b8..e3f93b7f8d38 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -53,13 +53,6 @@ static unsigned long kvm_psci_vcpu_suspend(struct kvm_vcpu *vcpu)
 	return PSCI_RET_SUCCESS;
 }
 
-static void kvm_psci_vcpu_off(struct kvm_vcpu *vcpu)
-{
-	vcpu->arch.power_off = true;
-	kvm_make_request(KVM_REQ_SLEEP, vcpu);
-	kvm_vcpu_kick(vcpu);
-}
-
 static inline bool kvm_psci_valid_affinity(struct kvm_vcpu *vcpu,
 					   unsigned long affinity)
 {
@@ -262,7 +255,7 @@ static int kvm_psci_0_2_call(struct kvm_vcpu *vcpu)
 		val = kvm_psci_vcpu_suspend(vcpu);
 		break;
 	case PSCI_0_2_FN_CPU_OFF:
-		kvm_psci_vcpu_off(vcpu);
+		kvm_arm_vcpu_power_off(vcpu);
 		val = PSCI_RET_SUCCESS;
 		break;
 	case PSCI_0_2_FN_CPU_ON:
@@ -375,7 +368,7 @@ static int kvm_psci_0_1_call(struct kvm_vcpu *vcpu)
 
 	switch (psci_fn) {
 	case KVM_PSCI_FN_CPU_OFF:
-		kvm_psci_vcpu_off(vcpu);
+		kvm_arm_vcpu_power_off(vcpu);
 		val = PSCI_RET_SUCCESS;
 		break;
 	case KVM_PSCI_FN_CPU_ON:
-- 
2.35.1.473.g83b2b277ed-goog

