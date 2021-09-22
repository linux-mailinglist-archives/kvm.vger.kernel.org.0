Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB535413EDC
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 03:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231267AbhIVBK0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 21:10:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230469AbhIVBK0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Sep 2021 21:10:26 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBA0EC061574
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 18:08:56 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id x28-20020ac8701c000000b0029f4b940566so5053070qtm.19
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 18:08:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=sB6+nektsQKbRT8URX4ZERcQGSMsEp1UgeUOYm/SIBg=;
        b=ar2Q5W2awd91FclF3OwF0DOCCDogFFVcJWd2TfjXanoMzpQHx3bXvhYj/HyMq2XmxC
         vzRb5qOfwVYIHLyvOsCBUgBXJ1ip6DPOk7b83qI7BmgMK9abwy7v5vpV1/BZKdXeNEU4
         PWQz9pRuxjU4Te/v73RIxYTX8I0/cFXhizx+Uy4sfivcDuI96aa6hFGWh4Q6/c75JQgt
         9wS52e0FOpXXkaIxL1lkBqNl0jre2tJC4xuZ17sIy42CEur1Mn8M1T0HgaVVBFa8vB8m
         8xVwBvAmefDog4v3LAoggKAl+4VaPrAhieU18Hln9IA27bZhmcLPHzmi2/Scsq1OUZ/b
         njLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=sB6+nektsQKbRT8URX4ZERcQGSMsEp1UgeUOYm/SIBg=;
        b=4WBA9uVsMpNyuZIEKbayRgQDOLgqTKdIL+xh/enNDuhiPMH3o8ODbH+kW3k+J7BaNk
         HPQp2z9D5zfE2EGFQaf8C5LSVex668FXWZfiStzgZ6W3yZpxcVAfBf1abeRuf8PL6Mwt
         1ZbsI2RungU+p/fNL4vB/3pF52hW81/yS8RDMjNN5bypxhLQrGOyV6bCxEAXgUAaFqom
         t0nSUR6goosy4dNTWUAn4Z9pHmEPUPPwh5lNFnCGS5Y9NEXuk+07rnwApJ3HuUFYhnGe
         aHtUqsDEwkX7M0ih90itbf0lMiq7odp5igX5RglpsvakdaEjvbYV5//geNjxPkfH/rTu
         Jefw==
X-Gm-Message-State: AOAM530t7knFwpotUH9/Y7VRuRpJbxe7bXpd8C3GvTnderU3ZTuOL0b5
        9aJpCDCzwICcb4DUaDi6/QTo6ED6s3K9P1Oe3YKNiZHQqqF7QHgPom3nY7aMpgbnmz88WGXrKsP
        gxe+PMCjsiA0k57MGbGR1XgTvKnkovRwA0TtxNsqC+PaoXK1u2YyLhVePewNxjv7uvjbi6K8=
X-Google-Smtp-Source: ABdhPJzOqeO2OuxpUMXXv+KHI6Xw27I1GqFhY5UPfC7OxcCkjvisPmzt0AP6yLCDqx5YjtHu+XqAy/nLZZiyOMgfQA==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a0c:aac2:: with SMTP id
 g2mr30995549qvb.41.1632272936004; Tue, 21 Sep 2021 18:08:56 -0700 (PDT)
Date:   Wed, 22 Sep 2021 01:08:49 +0000
Message-Id: <20210922010851.2312845-1-jingzhangos@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v1 1/3] KVM: arm64: Add arch specific exit reasons
From:   Jing Zhang <jingzhangos@google.com>
To:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        David Matlack <dmatlack@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Arch specific exit reasons have been available for other architectures.
Add arch specific exit reason support for ARM64, which would be used in
KVM stats for monitoring VCPU status.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/include/asm/kvm_emulate.h |  5 +++
 arch/arm64/include/asm/kvm_host.h    | 33 +++++++++++++++
 arch/arm64/kvm/handle_exit.c         | 62 +++++++++++++++++++++++++---
 arch/arm64/kvm/mmu.c                 |  4 ++
 arch/arm64/kvm/sys_regs.c            |  6 +++
 5 files changed, 105 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index fd418955e31e..eb5ec3a479d3 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -319,6 +319,11 @@ static inline bool kvm_vcpu_trap_is_iabt(const struct kvm_vcpu *vcpu)
 	return kvm_vcpu_trap_get_class(vcpu) == ESR_ELx_EC_IABT_LOW;
 }
 
+static inline bool kvm_vcpu_trap_is_dabt(const struct kvm_vcpu *vcpu)
+{
+	return kvm_vcpu_trap_get_class(vcpu) == ESR_ELx_EC_DABT_LOW;
+}
+
 static inline bool kvm_vcpu_trap_is_exec_fault(const struct kvm_vcpu *vcpu)
 {
 	return kvm_vcpu_trap_is_iabt(vcpu) && !kvm_vcpu_abt_iss1tw(vcpu);
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index f8be56d5342b..0f0cea26ce32 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -278,6 +278,36 @@ struct vcpu_reset_state {
 	bool		reset;
 };
 
+enum arm_exit_reason {
+	ARM_EXIT_UNKNOWN,
+	ARM_EXIT_IRQ,
+	ARM_EXIT_EL1_SERROR,
+	ARM_EXIT_HYP_GONE,
+	ARM_EXIT_IL,
+	ARM_EXIT_WFI,
+	ARM_EXIT_WFE,
+	ARM_EXIT_CP15_32,
+	ARM_EXIT_CP15_64,
+	ARM_EXIT_CP14_32,
+	ARM_EXIT_CP14_LS,
+	ARM_EXIT_CP14_64,
+	ARM_EXIT_HVC32,
+	ARM_EXIT_SMC32,
+	ARM_EXIT_HVC64,
+	ARM_EXIT_SMC64,
+	ARM_EXIT_SYS64,
+	ARM_EXIT_SVE,
+	ARM_EXIT_IABT_LOW,
+	ARM_EXIT_DABT_LOW,
+	ARM_EXIT_SOFTSTP_LOW,
+	ARM_EXIT_WATCHPT_LOW,
+	ARM_EXIT_BREAKPT_LOW,
+	ARM_EXIT_BKPT32,
+	ARM_EXIT_BRK64,
+	ARM_EXIT_FP_ASIMD,
+	ARM_EXIT_PAC,
+};
+
 struct kvm_vcpu_arch {
 	struct kvm_cpu_context ctxt;
 	void *sve_state;
@@ -384,6 +414,9 @@ struct kvm_vcpu_arch {
 		u64 last_steal;
 		gpa_t base;
 	} steal;
+
+	/* Arch specific exit reason */
+	enum arm_exit_reason exit_reason;
 };
 
 /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 275a27368a04..90a47758b23d 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -49,6 +49,18 @@ static int handle_hvc(struct kvm_vcpu *vcpu)
 	return ret;
 }
 
+static int handle_hvc32(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.exit_reason = ARM_EXIT_HVC32;
+	return handle_hvc(vcpu);
+}
+
+static int handle_hvc64(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.exit_reason = ARM_EXIT_HVC64;
+	return handle_hvc(vcpu);
+}
+
 static int handle_smc(struct kvm_vcpu *vcpu)
 {
 	/*
@@ -64,12 +76,25 @@ static int handle_smc(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+static int handle_smc32(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.exit_reason = ARM_EXIT_SMC32;
+	return handle_smc(vcpu);
+}
+
+static int handle_smc64(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.exit_reason = ARM_EXIT_SMC64;
+	return handle_smc(vcpu);
+}
+
 /*
  * Guest access to FP/ASIMD registers are routed to this handler only
  * when the system doesn't support FP/ASIMD.
  */
 static int handle_no_fpsimd(struct kvm_vcpu *vcpu)
 {
+	vcpu->arch.exit_reason = ARM_EXIT_FP_ASIMD;
 	kvm_inject_undefined(vcpu);
 	return 1;
 }
@@ -91,10 +116,12 @@ static int kvm_handle_wfx(struct kvm_vcpu *vcpu)
 	if (kvm_vcpu_get_esr(vcpu) & ESR_ELx_WFx_ISS_WFE) {
 		trace_kvm_wfx_arm64(*vcpu_pc(vcpu), true);
 		vcpu->stat.wfe_exit_stat++;
+		vcpu->arch.exit_reason = ARM_EXIT_WFE;
 		kvm_vcpu_on_spin(vcpu, vcpu_mode_priv(vcpu));
 	} else {
 		trace_kvm_wfx_arm64(*vcpu_pc(vcpu), false);
 		vcpu->stat.wfi_exit_stat++;
+		vcpu->arch.exit_reason = ARM_EXIT_WFI;
 		kvm_vcpu_block(vcpu);
 		kvm_clear_request(KVM_REQ_UNHALT, vcpu);
 	}
@@ -119,12 +146,29 @@ static int kvm_handle_guest_debug(struct kvm_vcpu *vcpu)
 {
 	struct kvm_run *run = vcpu->run;
 	u32 esr = kvm_vcpu_get_esr(vcpu);
+	u8 esr_ec = ESR_ELx_EC(esr);
 
 	run->exit_reason = KVM_EXIT_DEBUG;
 	run->debug.arch.hsr = esr;
 
-	if (ESR_ELx_EC(esr) == ESR_ELx_EC_WATCHPT_LOW)
+	switch (esr_ec) {
+	case ESR_ELx_EC_SOFTSTP_LOW:
+		vcpu->arch.exit_reason = ARM_EXIT_SOFTSTP_LOW;
+		break;
+	case ESR_ELx_EC_WATCHPT_LOW:
 		run->debug.arch.far = vcpu->arch.fault.far_el2;
+		vcpu->arch.exit_reason = ARM_EXIT_WATCHPT_LOW;
+		break;
+	case ESR_ELx_EC_BREAKPT_LOW:
+		vcpu->arch.exit_reason = ARM_EXIT_BREAKPT_LOW;
+		break;
+	case ESR_ELx_EC_BKPT32:
+		vcpu->arch.exit_reason = ARM_EXIT_BKPT32;
+		break;
+	case ESR_ELx_EC_BRK64:
+		vcpu->arch.exit_reason = ARM_EXIT_BRK64;
+		break;
+	}
 
 	return 0;
 }
@@ -136,12 +180,14 @@ static int kvm_handle_unknown_ec(struct kvm_vcpu *vcpu)
 	kvm_pr_unimpl("Unknown exception class: esr: %#08x -- %s\n",
 		      esr, esr_get_class_string(esr));
 
+	vcpu->arch.exit_reason = ARM_EXIT_UNKNOWN;
 	kvm_inject_undefined(vcpu);
 	return 1;
 }
 
 static int handle_sve(struct kvm_vcpu *vcpu)
 {
+	vcpu->arch.exit_reason = ARM_EXIT_SVE;
 	/* Until SVE is supported for guests: */
 	kvm_inject_undefined(vcpu);
 	return 1;
@@ -154,6 +200,7 @@ static int handle_sve(struct kvm_vcpu *vcpu)
  */
 static int kvm_handle_ptrauth(struct kvm_vcpu *vcpu)
 {
+	vcpu->arch.exit_reason = ARM_EXIT_PAC;
 	kvm_inject_undefined(vcpu);
 	return 1;
 }
@@ -166,10 +213,10 @@ static exit_handle_fn arm_exit_handlers[] = {
 	[ESR_ELx_EC_CP14_MR]	= kvm_handle_cp14_32,
 	[ESR_ELx_EC_CP14_LS]	= kvm_handle_cp14_load_store,
 	[ESR_ELx_EC_CP14_64]	= kvm_handle_cp14_64,
-	[ESR_ELx_EC_HVC32]	= handle_hvc,
-	[ESR_ELx_EC_SMC32]	= handle_smc,
-	[ESR_ELx_EC_HVC64]	= handle_hvc,
-	[ESR_ELx_EC_SMC64]	= handle_smc,
+	[ESR_ELx_EC_HVC32]	= handle_hvc32,
+	[ESR_ELx_EC_SMC32]	= handle_smc32,
+	[ESR_ELx_EC_HVC64]	= handle_hvc64,
+	[ESR_ELx_EC_SMC64]	= handle_smc64,
 	[ESR_ELx_EC_SYS64]	= kvm_handle_sys_reg,
 	[ESR_ELx_EC_SVE]	= handle_sve,
 	[ESR_ELx_EC_IABT_LOW]	= kvm_handle_guest_abort,
@@ -230,8 +277,10 @@ int handle_exit(struct kvm_vcpu *vcpu, int exception_index)
 
 	switch (exception_index) {
 	case ARM_EXCEPTION_IRQ:
+		vcpu->arch.exit_reason = ARM_EXIT_IRQ;
 		return 1;
 	case ARM_EXCEPTION_EL1_SERROR:
+		vcpu->arch.exit_reason = ARM_EXIT_EL1_SERROR;
 		return 1;
 	case ARM_EXCEPTION_TRAP:
 		return handle_trap_exceptions(vcpu);
@@ -240,6 +289,7 @@ int handle_exit(struct kvm_vcpu *vcpu, int exception_index)
 		 * EL2 has been reset to the hyp-stub. This happens when a guest
 		 * is pre-empted by kvm_reboot()'s shutdown call.
 		 */
+		vcpu->arch.exit_reason = ARM_EXIT_HYP_GONE;
 		run->exit_reason = KVM_EXIT_FAIL_ENTRY;
 		return 0;
 	case ARM_EXCEPTION_IL:
@@ -247,11 +297,13 @@ int handle_exit(struct kvm_vcpu *vcpu, int exception_index)
 		 * We attempted an illegal exception return.  Guest state must
 		 * have been corrupted somehow.  Give up.
 		 */
+		vcpu->arch.exit_reason = ARM_EXIT_IL;
 		run->exit_reason = KVM_EXIT_FAIL_ENTRY;
 		return -EINVAL;
 	default:
 		kvm_pr_unimpl("Unsupported exception type: %d",
 			      exception_index);
+		vcpu->arch.exit_reason = ARM_EXIT_UNKNOWN;
 		run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
 		return 0;
 	}
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 1a94a7ca48f2..a6a18d113c98 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1197,6 +1197,10 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 
 	fault_ipa = kvm_vcpu_get_fault_ipa(vcpu);
 	is_iabt = kvm_vcpu_trap_is_iabt(vcpu);
+	if (is_iabt)
+		vcpu->arch.exit_reason = ARM_EXIT_IABT_LOW;
+	else if (kvm_vcpu_trap_is_dabt(vcpu))
+		vcpu->arch.exit_reason = ARM_EXIT_DABT_LOW;
 
 	/* Synchronous External Abort? */
 	if (kvm_vcpu_abt_issea(vcpu)) {
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 1d46e185f31e..0915dfa589c7 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2158,6 +2158,7 @@ static int check_sysreg_table(const struct sys_reg_desc *table, unsigned int n,
 
 int kvm_handle_cp14_load_store(struct kvm_vcpu *vcpu)
 {
+	vcpu->arch.exit_reason = ARM_EXIT_CP14_LS;
 	kvm_inject_undefined(vcpu);
 	return 1;
 }
@@ -2325,21 +2326,25 @@ static int kvm_handle_cp_32(struct kvm_vcpu *vcpu,
 
 int kvm_handle_cp15_64(struct kvm_vcpu *vcpu)
 {
+	vcpu->arch.exit_reason = ARM_EXIT_CP15_64;
 	return kvm_handle_cp_64(vcpu, cp15_64_regs, ARRAY_SIZE(cp15_64_regs));
 }
 
 int kvm_handle_cp15_32(struct kvm_vcpu *vcpu)
 {
+	vcpu->arch.exit_reason = ARM_EXIT_CP15_32;
 	return kvm_handle_cp_32(vcpu, cp15_regs, ARRAY_SIZE(cp15_regs));
 }
 
 int kvm_handle_cp14_64(struct kvm_vcpu *vcpu)
 {
+	vcpu->arch.exit_reason = ARM_EXIT_CP14_64;
 	return kvm_handle_cp_64(vcpu, cp14_64_regs, ARRAY_SIZE(cp14_64_regs));
 }
 
 int kvm_handle_cp14_32(struct kvm_vcpu *vcpu)
 {
+	vcpu->arch.exit_reason = ARM_EXIT_CP14_32;
 	return kvm_handle_cp_32(vcpu, cp14_regs, ARRAY_SIZE(cp14_regs));
 }
 
@@ -2397,6 +2402,7 @@ int kvm_handle_sys_reg(struct kvm_vcpu *vcpu)
 	int ret;
 
 	trace_kvm_handle_sys_reg(esr);
+	vcpu->arch.exit_reason = ARM_EXIT_SYS64;
 
 	params = esr_sys64_to_params(esr);
 	params.regval = vcpu_get_reg(vcpu, Rt);
-- 
2.33.0.464.g1972c5931b-goog

