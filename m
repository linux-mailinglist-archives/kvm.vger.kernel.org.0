Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF848417595
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 15:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345722AbhIXNZt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 09:25:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345422AbhIXNZT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Sep 2021 09:25:19 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3236BC034024
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 05:54:59 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id q18-20020a252a12000000b005b263fcc92eso3222660ybq.8
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 05:54:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=6pASbSsT/Yef+KNtWRsM7REwBs8GiQAxHWrM4DAwh1s=;
        b=oYStHblXmyttk5JHb7mn/QeeOuyrSd9jwYFYzrB6dav9dTynlqaP3PEkx4wfPblOZ8
         xp41B097EPMoLP9xWck4D48TFdIQCmqPXQLfPXAMJv8vr0BPDf/h6yIlGb/6jibiVK96
         U1S32OOmVXqWVIa5Ays6LyLJ9/5Su8IRzQJak9EaCdedq4ixS1rUxKrxoxBsMGgaEK38
         r4xLPHw/Dijs2WEajb/iV+BetQ3xx/Fl+sTIBpcnuchQrWIk9VilcecF9ysdUfiiwQh9
         uKgtpvVv4hBbZp9kgr+K1J/uKpBrB+7OEQFPv5EPVyEmdR8t9M/6KEfoN54/27SEYeAi
         7KZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=6pASbSsT/Yef+KNtWRsM7REwBs8GiQAxHWrM4DAwh1s=;
        b=KCtva5TDqGe+BXnbMCf6WIrlMIXPvS0/esMmUbsD1897o8sBsBSGC58yRX1k4rW4R4
         Hulj2UBTGSoKDzF0NCXUhcQgXNLySFPDnXLrMdtR409a4voBPOCEjQrpv4MMkZpH+9pc
         e8MmVjJdaRuTnH3ZH6jSOMufJe0QfYc6B4Zy7RwSOz1oOrbqycsKVYgbJFzU0WY13lAp
         Fr0cntLynow4wscIBmGBrw6jDuCUyPO/N2pJG2/3GPqsyynudZwaIl0YoOwJO2Uojy0X
         /3gfP/kP5BA3RY2TPeP3qJlpf2PS4wYtm+ZkkqyztNqWoL/sZjkqux+7D/3BXZt8Lt6G
         MrBw==
X-Gm-Message-State: AOAM532eDj35scaXB/HtFaERXCT++IByb7rgMTczoIl63Cfn0Y5OFuDz
        cZuaceTUHKZAE3kZ6F6g0xQ4YwPgzw==
X-Google-Smtp-Source: ABdhPJz5QSOUNSvYae9zYQoRjlhXT3uab0VnL6rjHZdQg2Hs0A2XNNOhm8ErqHE0DojL6wYHc3wByV8RRw==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a25:bdc5:: with SMTP id g5mr12073562ybk.403.1632488098448;
 Fri, 24 Sep 2021 05:54:58 -0700 (PDT)
Date:   Fri, 24 Sep 2021 13:53:56 +0100
In-Reply-To: <20210924125359.2587041-1-tabba@google.com>
Message-Id: <20210924125359.2587041-28-tabba@google.com>
Mime-Version: 1.0
References: <20210924125359.2587041-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [RFC PATCH v1 27/30] KVM: arm64: remove unsupported pVM features
From:   Fuad Tabba <tabba@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, will@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com, drjones@redhat.com,
        qperret@google.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
        tabba@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove code for unsupported features for protected VMs from
__kvm_vcpu_run_pvm(). Do not run unsupported code (SVE) in
__hyp_handle_fpsimd().

Enforcement of this is in the fixed features patch series [1].
The code removed or disabled is related to the following:
- PMU
- Debug
- Arm32
- SPE
- SVE

[1]
Link: https://lore.kernel.org/kvmarm/20210922124704.600087-1-tabba@google.com/T/#u

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h |  5 ++--
 arch/arm64/kvm/hyp/nvhe/switch.c        | 36 -------------------------
 2 files changed, 3 insertions(+), 38 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 433601f79b94..3ef429cfd9af 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -232,6 +232,7 @@ static inline bool __hyp_handle_fpsimd(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
+	const bool is_protected = is_nvhe_hyp_code() && kvm_vm_is_protected(kern_hyp_va(vcpu->kvm));
 	bool sve_guest, sve_host;
 	u8 esr_ec;
 	u64 reg;
@@ -239,7 +240,7 @@ static inline bool __hyp_handle_fpsimd(struct kvm_vcpu *vcpu)
 	if (!system_supports_fpsimd())
 		return false;
 
-	if (system_supports_sve()) {
+	if (system_supports_sve() && !is_protected) {
 		sve_guest = hyp_state_has_sve(vcpu_hyps);
 		sve_host = hyp_state_flags(vcpu_hyps) & KVM_ARM64_HOST_SVE_IN_USE;
 	} else {
@@ -247,7 +248,7 @@ static inline bool __hyp_handle_fpsimd(struct kvm_vcpu *vcpu)
 		sve_host = false;
 	}
 
-	esr_ec = kvm_vcpu_trap_get_class(vcpu);
+	esr_ec = kvm_hyp_state_trap_get_class(vcpu_hyps);
 	if (esr_ec != ESR_ELx_EC_FP_ASIMD &&
 	    esr_ec != ESR_ELx_EC_SVE)
 		return false;
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 0d654b324612..aa0dc4f0433b 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -288,7 +288,6 @@ static int __kvm_vcpu_run_pvm(struct kvm_vcpu *vcpu)
 	struct vgic_dist *vgic = &kvm->arch.vgic;
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_cpu_context *guest_ctxt;
-	bool pmu_switch_needed;
 	u64 exit_code;
 
 	/*
@@ -306,29 +305,10 @@ static int __kvm_vcpu_run_pvm(struct kvm_vcpu *vcpu)
 	set_hyp_running_vcpu(host_ctxt, vcpu);
 	guest_ctxt = &vcpu->arch.ctxt;
 
-	pmu_switch_needed = __pmu_switch_to_guest(host_ctxt);
-
 	__sysreg_save_state_nvhe(host_ctxt);
-	/*
-	 * We must flush and disable the SPE buffer for nVHE, as
-	 * the translation regime(EL1&0) is going to be loaded with
-	 * that of the guest. And we must do this before we change the
-	 * translation regime to EL2 (via MDCR_EL2_E2PB == 0) and
-	 * before we load guest Stage1.
-	 */
-	__debug_save_host_buffers_nvhe(vcpu);
 
 	kvm_adjust_pc(vcpu_ctxt, vcpu_hyps);
 
-	/*
-	 * We must restore the 32-bit state before the sysregs, thanks
-	 * to erratum #852523 (Cortex-A57) or #853709 (Cortex-A72).
-	 *
-	 * Also, and in order to be able to deal with erratum #1319537 (A57)
-	 * and #1319367 (A72), we must ensure that all VM-related sysreg are
-	 * restored before we enable S2 translation.
-	 */
-	__sysreg32_restore_state(vcpu);
 	__sysreg_restore_state_nvhe(guest_ctxt);
 
 	__load_guest_stage2(kern_hyp_va(vcpu->arch.hw_mmu));
@@ -337,8 +317,6 @@ static int __kvm_vcpu_run_pvm(struct kvm_vcpu *vcpu)
 	__hyp_vgic_restore_state(vcpu);
 	__timer_enable_traps();
 
-	__debug_switch_to_guest(vcpu);
-
 	do {
 		struct kvm_cpu_context *hyp_ctxt = this_cpu_ptr(&kvm_hyp_ctxt);
 		set_hyp_running_vcpu(hyp_ctxt, vcpu);
@@ -350,7 +328,6 @@ static int __kvm_vcpu_run_pvm(struct kvm_vcpu *vcpu)
 	} while (fixup_guest_exit(vcpu, vgic, &exit_code));
 
 	__sysreg_save_state_nvhe(guest_ctxt);
-	__sysreg32_save_state(vcpu);
 	__timer_disable_traps();
 	__hyp_vgic_save_state(vcpu);
 
@@ -359,19 +336,6 @@ static int __kvm_vcpu_run_pvm(struct kvm_vcpu *vcpu)
 
 	__sysreg_restore_state_nvhe(host_ctxt);
 
-	if (hyp_state_flags(vcpu_hyps) & KVM_ARM64_FP_ENABLED)
-		__fpsimd_save_fpexc32(vcpu);
-
-	__debug_switch_to_host(vcpu);
-	/*
-	 * This must come after restoring the host sysregs, since a non-VHE
-	 * system may enable SPE here and make use of the TTBRs.
-	 */
-	__debug_restore_host_buffers_nvhe(vcpu);
-
-	if (pmu_switch_needed)
-		__pmu_switch_to_host(host_ctxt);
-
 	/* Returning to host will clear PSR.I, remask PMR if needed */
 	if (system_uses_irq_prio_masking())
 		gic_write_pmr(GIC_PRIO_IRQOFF);
-- 
2.33.0.685.g46640cef36-goog

