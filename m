Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27B7C4FAA65
	for <lists+kvm@lfdr.de>; Sat,  9 Apr 2022 20:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243103AbiDISsN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 9 Apr 2022 14:48:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242726AbiDISsL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 9 Apr 2022 14:48:11 -0400
Received: from mail-il1-x149.google.com (mail-il1-x149.google.com [IPv6:2607:f8b0:4864:20::149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19DE33EF38
        for <kvm@vger.kernel.org>; Sat,  9 Apr 2022 11:46:03 -0700 (PDT)
Received: by mail-il1-x149.google.com with SMTP id a2-20020a056e020e0200b002ca4850353fso7649486ilk.5
        for <kvm@vger.kernel.org>; Sat, 09 Apr 2022 11:46:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=zNZX4qKhY9ssVWnn49fTFS/OBlYZmfJZZRBk/VLMFEQ=;
        b=d4yQAyhWpQ3rahskj100LtBM75OrsDckAju1kue9JsJGy7/G0CpsImwGHmksdFWHRu
         4gFkstxDFy6ZH5XWHo8ibiqFyIPRRyh9Xb8HLNNJNEMXKw7ozYZuDLkbdpDksNYbsQ9t
         wkIEjsSHRa4uGnzQYF64pCgkI9UEL1jRTT+QMtb983q3yILNRs8P0anYXv0f6EEvl9uW
         TjhpUIlWhtlOMzv1daxZQIEfqWuFTYCU/lKNI6HtHf2JzHyLTrJi7ra2OgmhElYiuIUV
         9TD8eHl9WRXeQ3iI3aLN+7wSqG3Z3z+fjAY0iYGexUjFB5P9Vm/8l5LeZpGR8IEX1LuV
         Umyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=zNZX4qKhY9ssVWnn49fTFS/OBlYZmfJZZRBk/VLMFEQ=;
        b=FY5qyWF1HBdWoR+W/ATrvroxopjjfSNluLOPICKNxAuMLRlrAgK3THaQkCzaQktZtC
         GldLzHNFlOEfZN3aMGRtjV42qelZwAQT1Xl7pCsTLi3o0zOm1csk8Ei6g12JDbHknmR3
         +F2o6H4M6yD8ZhRz2UgeiQpFlMFcB2/jonjGedaWAGop0FrFOxstdRyateMkqOUFx1p3
         S6yCauioPd72POkf+mzeM//Uy+iLDV85zw1ND3N+K7BU+OfQav6KPYjaZW7pVCfkOSSc
         PHI74mt+rbhUY+IFgn6efaIHIZAou5M+o5c+lx38F+5wnvAX/+MFsKsGTQTjNMEIhuA/
         8lQA==
X-Gm-Message-State: AOAM533gMgE8qkhqBBSYPqcs1SRKN1aOJX/usU3zSKxl/KigJ4FYFzJZ
        iXP34DK65SdJFK5yNFRfAoq/GKM0wKY=
X-Google-Smtp-Source: ABdhPJzKHJ8fsjsMM64D8LgRSxlfa1Txco7sfNhsaUgODY9Ihexzb336aYPs+oJL7rc2qXrOam0hJmudO1s=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a92:d90c:0:b0:2ca:40d7:1ab5 with SMTP id
 s12-20020a92d90c000000b002ca40d71ab5mr10879038iln.48.1649529962554; Sat, 09
 Apr 2022 11:46:02 -0700 (PDT)
Date:   Sat,  9 Apr 2022 18:45:39 +0000
In-Reply-To: <20220409184549.1681189-1-oupton@google.com>
Message-Id: <20220409184549.1681189-4-oupton@google.com>
Mime-Version: 1.0
References: <20220409184549.1681189-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v5 03/13] KVM: arm64: Track vCPU power state using MP state values
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     alexandru.elisei@arm.com, anup@brainfault.org,
        atishp@atishpatra.org, james.morse@arm.com, jingzhangos@google.com,
        jmattson@google.com, joro@8bytes.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, maz@kernel.org,
        pbonzini@redhat.com, pshier@google.com, rananta@google.com,
        reijiw@google.com, ricarkol@google.com, seanjc@google.com,
        suzuki.poulose@arm.com, vkuznets@redhat.com, wanpengli@tencent.com,
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

A subsequent change to KVM will add support for additional power states.
Store the MP state by value rather than keeping track of it as a
boolean.

No functional change intended.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  5 +++--
 arch/arm64/kvm/arm.c              | 22 ++++++++++++----------
 arch/arm64/kvm/psci.c             | 12 ++++++------
 3 files changed, 21 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 490cd7f3a905..f3f93d48e21a 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -365,8 +365,8 @@ struct kvm_vcpu_arch {
 		u32	mdscr_el1;
 	} guest_debug_preserved;
 
-	/* vcpu power-off state */
-	bool power_off;
+	/* vcpu power state */
+	struct kvm_mp_state mp_state;
 
 	/* Don't run the guest (internal implementation need) */
 	bool pause;
@@ -842,5 +842,6 @@ static inline void kvm_hyp_reserve(void) { }
 #endif
 
 void kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu);
+bool kvm_arm_vcpu_stopped(struct kvm_vcpu *vcpu);
 
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 28c83c6ddbae..29e107457c4d 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -434,18 +434,20 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 
 void kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu)
 {
-	vcpu->arch.power_off = true;
+	vcpu->arch.mp_state.mp_state = KVM_MP_STATE_STOPPED;
 	kvm_make_request(KVM_REQ_SLEEP, vcpu);
 	kvm_vcpu_kick(vcpu);
 }
 
+bool kvm_arm_vcpu_stopped(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.mp_state.mp_state == KVM_MP_STATE_STOPPED;
+}
+
 int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
 				    struct kvm_mp_state *mp_state)
 {
-	if (vcpu->arch.power_off)
-		mp_state->mp_state = KVM_MP_STATE_STOPPED;
-	else
-		mp_state->mp_state = KVM_MP_STATE_RUNNABLE;
+	*mp_state = vcpu->arch.mp_state;
 
 	return 0;
 }
@@ -457,7 +459,7 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
 
 	switch (mp_state->mp_state) {
 	case KVM_MP_STATE_RUNNABLE:
-		vcpu->arch.power_off = false;
+		vcpu->arch.mp_state = *mp_state;
 		break;
 	case KVM_MP_STATE_STOPPED:
 		kvm_arm_vcpu_power_off(vcpu);
@@ -480,7 +482,7 @@ int kvm_arch_vcpu_runnable(struct kvm_vcpu *v)
 {
 	bool irq_lines = *vcpu_hcr(v) & (HCR_VI | HCR_VF);
 	return ((irq_lines || kvm_vgic_vcpu_pending_irq(v))
-		&& !v->arch.power_off && !v->arch.pause);
+		&& !kvm_arm_vcpu_stopped(v) && !v->arch.pause);
 }
 
 bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu)
@@ -597,10 +599,10 @@ static void vcpu_req_sleep(struct kvm_vcpu *vcpu)
 	struct rcuwait *wait = kvm_arch_vcpu_get_wait(vcpu);
 
 	rcuwait_wait_event(wait,
-			   (!vcpu->arch.power_off) &&(!vcpu->arch.pause),
+			   (!kvm_arm_vcpu_stopped(vcpu)) && (!vcpu->arch.pause),
 			   TASK_INTERRUPTIBLE);
 
-	if (vcpu->arch.power_off || vcpu->arch.pause) {
+	if (kvm_arm_vcpu_stopped(vcpu) || vcpu->arch.pause) {
 		/* Awaken to handle a signal, request we sleep again later. */
 		kvm_make_request(KVM_REQ_SLEEP, vcpu);
 	}
@@ -1126,7 +1128,7 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
 	if (test_bit(KVM_ARM_VCPU_POWER_OFF, vcpu->arch.features))
 		kvm_arm_vcpu_power_off(vcpu);
 	else
-		vcpu->arch.power_off = false;
+		vcpu->arch.mp_state.mp_state = KVM_MP_STATE_RUNNABLE;
 
 	return 0;
 }
diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index cdc0609c1135..f2f45a3cbe86 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -76,7 +76,7 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
 	 */
 	if (!vcpu)
 		return PSCI_RET_INVALID_PARAMS;
-	if (!vcpu->arch.power_off) {
+	if (!kvm_arm_vcpu_stopped(vcpu)) {
 		if (kvm_psci_version(source_vcpu) != KVM_ARM_PSCI_0_1)
 			return PSCI_RET_ALREADY_ON;
 		else
@@ -100,12 +100,12 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
 	kvm_make_request(KVM_REQ_VCPU_RESET, vcpu);
 
 	/*
-	 * Make sure the reset request is observed if the change to
-	 * power_off is observed.
+	 * Make sure the reset request is observed if the RUNNABLE mp_state is
+	 * observed.
 	 */
 	smp_wmb();
 
-	vcpu->arch.power_off = false;
+	vcpu->arch.mp_state.mp_state = KVM_MP_STATE_RUNNABLE;
 	kvm_vcpu_wake_up(vcpu);
 
 	return PSCI_RET_SUCCESS;
@@ -143,7 +143,7 @@ static unsigned long kvm_psci_vcpu_affinity_info(struct kvm_vcpu *vcpu)
 		mpidr = kvm_vcpu_get_mpidr_aff(tmp);
 		if ((mpidr & target_affinity_mask) == target_affinity) {
 			matching_cpus++;
-			if (!tmp->arch.power_off)
+			if (!kvm_arm_vcpu_stopped(tmp))
 				return PSCI_0_2_AFFINITY_LEVEL_ON;
 		}
 	}
@@ -169,7 +169,7 @@ static void kvm_prepare_system_event(struct kvm_vcpu *vcpu, u32 type, u64 flags)
 	 * re-initialized.
 	 */
 	kvm_for_each_vcpu(i, tmp, vcpu->kvm)
-		tmp->arch.power_off = true;
+		tmp->arch.mp_state.mp_state = KVM_MP_STATE_STOPPED;
 	kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_SLEEP);
 
 	memset(&vcpu->run->system_event, 0, sizeof(vcpu->run->system_event));
-- 
2.35.1.1178.g4f1659d476-goog

