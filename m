Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B39F4C0AEA
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 05:19:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237764AbiBWETo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 23:19:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237820AbiBWETm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 23:19:42 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12F1342499
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 20:19:15 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id r14-20020a5b018e000000b00624f6f97bf4so177446ybl.12
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 20:19:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=LV0bMpBwuTu9m8XQ2DkwpsVEfavJ0eUBuff0BNzXqZE=;
        b=KsxOxx2PLrLY9Nj5DCTzo8MAJ7qOd2q954TOQGc5r8Mf3k0gZVdLnz/SBy4XpJpss/
         cgNTHTJjQJuZOPWDInSOPJkGq5QJTqQld37u4DniYIlFQNletzIEM7eGpYe94Dqn1gXM
         FB0ds3mmfjR2659iBvcRjSzFo234VH2ISmfjEARPe400tQy57q2NN0TX5GAAcJDz1478
         Jf4U0DGSfFXEw7ON8lyDXHYO0sFiaW2AqvJWoRWusTJTdZBObp6ACA+IxkMlMXdK8wle
         M6D5Xcf0SOjwECkNvCo52ZEViFobbiAom5uazrx5S6/rqf8PYaAML34Uvn0t/n1rcC9Q
         fkcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=LV0bMpBwuTu9m8XQ2DkwpsVEfavJ0eUBuff0BNzXqZE=;
        b=xrxFE10TOjoBhqmzhPP10ZDxQUpSkRq3ghPWl03Os4rZ/SZwEwvMd2bShNMY9csQ83
         lSfgsYVWiP4Kd6q7p96g9Y0cPxFFxvXLoXxW6q2g4aqBTro4pNkWTquucZiUVk7l/Uwx
         2luvCtgcvrAJvG+FX54zfWAKbZ3zT1cgRupTh4sECUJjDJgBzhZ7hReMhCFN2oeIVFT7
         Wi6C3L9HwsFcwdUPzLfVy2K3G7AvIjycsGufe24gxYotqXZbd9q2vRX7DDhP0RAyzHA6
         pJ9+DCy7pg0fV4LSwEXrtcAXSR3ZRDJC/DQNcoB3Q8bdE5a1wFSDSG6ZVxiy49D8zJ7O
         6I1g==
X-Gm-Message-State: AOAM5300s8MIumxN7MYLfzjPu+wf5/L/NWfA86uSEv7afz4Lw/+q9rvv
        1I9NVUrgEVRmbvEKkXXfwSoKA/EE3Uk=
X-Google-Smtp-Source: ABdhPJx93W6mKOL8nHGtqQV3KIowPsQoWqRbNe5EILnWxaGTffzr5S6+TUULUibg8xQVs3aSOE3kMaP76XM=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a81:a748:0:b0:2d6:1f8b:23a9 with SMTP id
 e69-20020a81a748000000b002d61f8b23a9mr27565181ywh.329.1645589954212; Tue, 22
 Feb 2022 20:19:14 -0800 (PST)
Date:   Wed, 23 Feb 2022 04:18:31 +0000
In-Reply-To: <20220223041844.3984439-1-oupton@google.com>
Message-Id: <20220223041844.3984439-7-oupton@google.com>
Mime-Version: 1.0
References: <20220223041844.3984439-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [PATCH v3 06/19] KVM: arm64: Track vCPU power state using MP state values
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

A subsequent change to KVM will add support for additional power states.
Store the MP state by value rather than keeping track of it as a
boolean.

No functional change intended.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  5 +++--
 arch/arm64/kvm/arm.c              | 22 ++++++++++++----------
 arch/arm64/kvm/psci.c             | 10 +++++-----
 3 files changed, 20 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index cacc9efd2e70..3e8bfecaa95b 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -350,8 +350,8 @@ struct kvm_vcpu_arch {
 		u32	mdscr_el1;
 	} guest_debug_preserved;
 
-	/* vcpu power-off state */
-	bool power_off;
+	/* vcpu power state */
+	u32 mp_state;
 
 	/* Don't run the guest (internal implementation need) */
 	bool pause;
@@ -800,5 +800,6 @@ static inline void kvm_hyp_reserve(void) { }
 #endif
 
 void kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu);
+bool kvm_arm_vcpu_powered_off(struct kvm_vcpu *vcpu);
 
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 07c6a176cdcc..b4987b891f38 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -428,18 +428,20 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 
 void kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu)
 {
-	vcpu->arch.power_off = true;
+	vcpu->arch.mp_state = KVM_MP_STATE_STOPPED;
 	kvm_make_request(KVM_REQ_SLEEP, vcpu);
 	kvm_vcpu_kick(vcpu);
 }
 
+bool kvm_arm_vcpu_powered_off(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.mp_state == KVM_MP_STATE_STOPPED;
+}
+
 int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
 				    struct kvm_mp_state *mp_state)
 {
-	if (vcpu->arch.power_off)
-		mp_state->mp_state = KVM_MP_STATE_STOPPED;
-	else
-		mp_state->mp_state = KVM_MP_STATE_RUNNABLE;
+	mp_state->mp_state = vcpu->arch.mp_state;
 
 	return 0;
 }
@@ -451,7 +453,7 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
 
 	switch (mp_state->mp_state) {
 	case KVM_MP_STATE_RUNNABLE:
-		vcpu->arch.power_off = false;
+		vcpu->arch.mp_state = mp_state->mp_state;
 		break;
 	case KVM_MP_STATE_STOPPED:
 		kvm_arm_vcpu_power_off(vcpu);
@@ -474,7 +476,7 @@ int kvm_arch_vcpu_runnable(struct kvm_vcpu *v)
 {
 	bool irq_lines = *vcpu_hcr(v) & (HCR_VI | HCR_VF);
 	return ((irq_lines || kvm_vgic_vcpu_pending_irq(v))
-		&& !v->arch.power_off && !v->arch.pause);
+		&& !kvm_arm_vcpu_powered_off(v) && !v->arch.pause);
 }
 
 bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu)
@@ -668,10 +670,10 @@ static void vcpu_req_sleep(struct kvm_vcpu *vcpu)
 	struct rcuwait *wait = kvm_arch_vcpu_get_wait(vcpu);
 
 	rcuwait_wait_event(wait,
-			   (!vcpu->arch.power_off) &&(!vcpu->arch.pause),
+			   (!kvm_arm_vcpu_powered_off(vcpu)) && (!vcpu->arch.pause),
 			   TASK_INTERRUPTIBLE);
 
-	if (vcpu->arch.power_off || vcpu->arch.pause) {
+	if (kvm_arm_vcpu_powered_off(vcpu) || vcpu->arch.pause) {
 		/* Awaken to handle a signal, request we sleep again later. */
 		kvm_make_request(KVM_REQ_SLEEP, vcpu);
 	}
@@ -1181,7 +1183,7 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
 	if (test_bit(KVM_ARM_VCPU_POWER_OFF, vcpu->arch.features))
 		kvm_arm_vcpu_power_off(vcpu);
 	else
-		vcpu->arch.power_off = false;
+		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
 
 	return 0;
 }
diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index e3f93b7f8d38..77a00913cdfd 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -97,7 +97,7 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
 	 */
 	if (!vcpu)
 		return PSCI_RET_INVALID_PARAMS;
-	if (!vcpu->arch.power_off) {
+	if (!kvm_arm_vcpu_powered_off(vcpu)) {
 		if (kvm_psci_version(source_vcpu) != KVM_ARM_PSCI_0_1)
 			return PSCI_RET_ALREADY_ON;
 		else
@@ -122,11 +122,11 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
 
 	/*
 	 * Make sure the reset request is observed if the change to
-	 * power_off is observed.
+	 * mp_state is observed.
 	 */
 	smp_wmb();
 
-	vcpu->arch.power_off = false;
+	vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
 	kvm_vcpu_wake_up(vcpu);
 
 	return PSCI_RET_SUCCESS;
@@ -164,7 +164,7 @@ static unsigned long kvm_psci_vcpu_affinity_info(struct kvm_vcpu *vcpu)
 		mpidr = kvm_vcpu_get_mpidr_aff(tmp);
 		if ((mpidr & target_affinity_mask) == target_affinity) {
 			matching_cpus++;
-			if (!tmp->arch.power_off)
+			if (!kvm_arm_vcpu_powered_off(tmp))
 				return PSCI_0_2_AFFINITY_LEVEL_ON;
 		}
 	}
@@ -190,7 +190,7 @@ static void kvm_prepare_system_event(struct kvm_vcpu *vcpu, u32 type)
 	 * re-initialized.
 	 */
 	kvm_for_each_vcpu(i, tmp, vcpu->kvm)
-		tmp->arch.power_off = true;
+		tmp->arch.mp_state = KVM_MP_STATE_STOPPED;
 	kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_SLEEP);
 
 	memset(&vcpu->run->system_event, 0, sizeof(vcpu->run->system_event));
-- 
2.35.1.473.g83b2b277ed-goog

