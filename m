Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45A735195E9
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 05:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344241AbiEDD2f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 May 2022 23:28:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344223AbiEDD2d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 May 2022 23:28:33 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F5E5275CC
        for <kvm@vger.kernel.org>; Tue,  3 May 2022 20:24:59 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id j187-20020a638bc4000000b003c1922b0f1bso106034pge.3
        for <kvm@vger.kernel.org>; Tue, 03 May 2022 20:24:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=EIziyV713c9Gy7N8pI1PaC9upsDWwJjlqgfEvo9nqeE=;
        b=ZPKEu8L2nh3LgddlnvnOclfE8A4DcgXiW2eTUjHjxVu1MnOPBfQTkjUFcz3kUDLmbE
         IDEhi43K3RPvBdOnJ+brA+wlxUHtrapRfayJzLb/iMRul23LGEBxJ5F7M+AbRCP3Zs+4
         cJax+mXxqETi5oIUa0d6sAyEM/AO5QqR+tiYUWf8uH6mZj/VLJ3Lzp6YIxNs3ci5dhT0
         YMs3Gx2ruYx5nFjrJ18fdKUG8mDvRehcIzXibBAc1iA+hWFhVe45WNdijVsogBmyL1Qk
         D3VE3Gg0BTVa0ZVLU+kidwm2WsZfciyke7b+Dl9JyFXY7INMIIesAXKAXJGxCoiuXC0P
         lwig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=EIziyV713c9Gy7N8pI1PaC9upsDWwJjlqgfEvo9nqeE=;
        b=Nol6N+K2+bJDbbvc7tcb01t+ZyaLHO7IU+IKcnFMBLCusobHnkrn9eJgF/GcewWDfu
         YVwQUChKz/9dFImilsSJpnK1e8j008IxrbDIdQk5d/DckboZy0AQHm82tWVb/mPFCoGe
         DnfcDAC6RwNHtBfG0a5nz2b9wij/4lyiPK83c+ztlozjpPUk1VWJ1bv7qHt5RepB1M1t
         Zg/N/LHY58kLdlg4v1JcZ8KzYwXkahxK/qWD+f3bhfooEY4svBYBY3lac7nFkgaNhRGS
         pxLkWXthAYc5kNi/wzBC9QRE0siLutU6xki8pvEPkurT99pykHOuCi/Gj509L5cA34od
         jLoQ==
X-Gm-Message-State: AOAM532vzEAWc6JDlLcEXbc+piq+43XYlFqPPTNUrCpPbIBqMa/6mP7S
        dWwCY2KUPHiZ+f6h2sMHnyx6XWlKdak=
X-Google-Smtp-Source: ABdhPJxI0BTdhjgimjAkiuzVocoWP2C0Axd2vDhxllpUDEld/gAcfN5MTikLaK6SDPL3cM2XOBrF84TBSXk=
X-Received: from oupton3.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:21eb])
 (user=oupton job=sendgmr) by 2002:a17:902:b698:b0:158:faee:442f with SMTP id
 c24-20020a170902b69800b00158faee442fmr20205719pls.75.1651634698846; Tue, 03
 May 2022 20:24:58 -0700 (PDT)
Date:   Wed,  4 May 2022 03:24:37 +0000
In-Reply-To: <20220504032446.4133305-1-oupton@google.com>
Message-Id: <20220504032446.4133305-4-oupton@google.com>
Mime-Version: 1.0
References: <20220504032446.4133305-1-oupton@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH v6 03/12] KVM: arm64: Track vCPU power state using MP state values
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, maz@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        reijiw@google.com, ricarkol@google.com,
        Oliver Upton <oupton@google.com>
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

A subsequent change to KVM will add support for additional power states.
Store the MP state by value rather than keeping track of it as a
boolean.

No functional change intended.

Signed-off-by: Oliver Upton <oupton@google.com>
Reviewed-by: Reiji Watanabe <reijiw@google.com>
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
index 9b1f3acae155..2e6f060214a7 100644
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
2.36.0.464.gb9c8b46e94-goog

