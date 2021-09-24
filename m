Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 766A2417594
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 15:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346026AbhIXNZs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 09:25:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346154AbhIXNZG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Sep 2021 09:25:06 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF213C03401D
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 05:54:54 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id d20-20020ac81194000000b002a53ffbd04dso28858693qtj.12
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 05:54:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=h7avwCelVLDXrW65ivowhx5L97uC6oG1q5eldj7v03E=;
        b=HSj7gZGfE1Et2vmg3ht8IP44LkLd1mywKH9lU+M+SaqxPAhQomtoiMQDSdpuE1jlH0
         VjMgAJVQhNWJ6IR0dBYuKqen9a8e6ZwcErT6sKmrbHkSet6C+kMNx2fpZCShgK7tJ8i5
         Tfkk+GKBNixa2P/T7o4dn5RBzfOEocv2ZLWrqxfAOv+pXLMVKoRwTppWAkyyYZsYu5JF
         HdwISigqSEVHD9UFMlP8vbCfGs7HYpwttcpvRskdAZxLkbT4Mu8udkC7KtNx1ZUP139m
         RIxeaVjv2wRJ0JACk4h1lm/7OGP26Nfp3hla/AqHq6Sdwt8v4aXZ36GDhNxuFubJoe7E
         mwCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=h7avwCelVLDXrW65ivowhx5L97uC6oG1q5eldj7v03E=;
        b=FLmpUcVmuad067xSt/ds4aCPxyfPolO+nfAhsAVdJyHVNZKLYa2r2i5GzbnrPpU2XN
         X1jITg+RVY5Mr+y7mt5T/6UMJd4xFAvKZJRABDGvsfx+FdHMUm1flKZh7fVMEORVw74O
         UbF8sOxCDs/Tet/8qkouhFDWy8leqFhH9f0ShvS+kPxPPcquhCTfusEMrOs/Ern5Hsfk
         AIe+VcU214Pqo5E+/29/jVAre+ahP5Kj98aHprAY2uexn5Ou09VxUs2OI73WrYvupxWP
         nNr+xgk9r6IX08oCCrZeWrl1eOp4p52tc8AV1/7vS00e4C1ZXsZNIIOjsZEmwkzZICoJ
         /IPg==
X-Gm-Message-State: AOAM532HlEIlpTDDD5Brycunw4gtdDteTvY791EczT4Igc3KtQf+f0CL
        7sicH5HHMbahW/Gi9dq3HkxAJ1/1wA==
X-Google-Smtp-Source: ABdhPJyL0t+coFpdVZMGEPsDbytWRe779HP4gPBcO06ejSv04CQaDTyhghz78sdKCUcnBSSiAMc7iJUGkA==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a0c:d989:: with SMTP id y9mr9535459qvj.67.1632488093954;
 Fri, 24 Sep 2021 05:54:53 -0700 (PDT)
Date:   Fri, 24 Sep 2021 13:53:54 +0100
In-Reply-To: <20210924125359.2587041-1-tabba@google.com>
Message-Id: <20210924125359.2587041-26-tabba@google.com>
Mime-Version: 1.0
References: <20210924125359.2587041-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [RFC PATCH v1 25/30] KVM: arm64: separate kvm_run() for protected VMs
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

Split kvm_run() for protected and non-protected VMs. Protected
VMs support fewer features, separating it out will ease the
refactoring and simplify the code.

This patch starts only by replicated the code from the
non-protected case, to make it easier to diff against future
patches.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/switch.c | 119 ++++++++++++++++++++++++++++++-
 1 file changed, 116 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index b90ec8db5864..9e79f97ba49e 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -119,7 +119,7 @@ static void __hyp_vgic_save_state(struct kvm_vcpu *vcpu)
 	}
 }
 
-/* Restore VGICv3 state on non_VEH systems */
+/* Restore VGICv3 state on nVHE systems */
 static void __hyp_vgic_restore_state(struct kvm_vcpu *vcpu)
 {
 	if (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif)) {
@@ -166,8 +166,110 @@ static void __pmu_switch_to_host(struct kvm_cpu_context *host_ctxt)
 		write_sysreg(pmu->events_host, pmcntenset_el0);
 }
 
-/* Switch to the guest for legacy non-VHE systems */
-int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
+/* Switch to the non-protected guest */
+static int __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_hyp_state *vcpu_hyps = &vcpu->arch.hyp_state;
+	struct kvm_cpu_context *vcpu_ctxt = &vcpu->arch.ctxt;
+	struct kvm *kvm = kern_hyp_va(vcpu->kvm);
+	struct vgic_dist *vgic = &kvm->arch.vgic;
+	struct kvm_cpu_context *host_ctxt;
+	struct kvm_cpu_context *guest_ctxt;
+	bool pmu_switch_needed;
+	u64 exit_code;
+
+	/*
+	 * Having IRQs masked via PMR when entering the guest means the GIC
+	 * will not signal the CPU of interrupts of lower priority, and the
+	 * only way to get out will be via guest exceptions.
+	 * Naturally, we want to avoid this.
+	 */
+	if (system_uses_irq_prio_masking()) {
+		gic_write_pmr(GIC_PRIO_IRQON | GIC_PRIO_PSR_I_SET);
+		pmr_sync();
+	}
+
+	host_ctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
+	set_hyp_running_vcpu(host_ctxt, vcpu);
+	guest_ctxt = &vcpu->arch.ctxt;
+
+	pmu_switch_needed = __pmu_switch_to_guest(host_ctxt);
+
+	__sysreg_save_state_nvhe(host_ctxt);
+	/*
+	 * We must flush and disable the SPE buffer for nVHE, as
+	 * the translation regime(EL1&0) is going to be loaded with
+	 * that of the guest. And we must do this before we change the
+	 * translation regime to EL2 (via MDCR_EL2_E2PB == 0) and
+	 * before we load guest Stage1.
+	 */
+	__debug_save_host_buffers_nvhe(vcpu);
+
+	kvm_adjust_pc(vcpu_ctxt, vcpu_hyps);
+
+	/*
+	 * We must restore the 32-bit state before the sysregs, thanks
+	 * to erratum #852523 (Cortex-A57) or #853709 (Cortex-A72).
+	 *
+	 * Also, and in order to be able to deal with erratum #1319537 (A57)
+	 * and #1319367 (A72), we must ensure that all VM-related sysreg are
+	 * restored before we enable S2 translation.
+	 */
+	__sysreg32_restore_state(vcpu);
+	__sysreg_restore_state_nvhe(guest_ctxt);
+
+	__load_guest_stage2(kern_hyp_va(vcpu->arch.hw_mmu));
+	__activate_traps(vcpu);
+
+	__hyp_vgic_restore_state(vcpu);
+	__timer_enable_traps();
+
+	__debug_switch_to_guest(vcpu);
+
+	do {
+		struct kvm_cpu_context *hyp_ctxt = this_cpu_ptr(&kvm_hyp_ctxt);
+		set_hyp_running_vcpu(hyp_ctxt, vcpu);
+
+		/* Jump in the fire! */
+		exit_code = __guest_enter(guest_ctxt);
+
+		/* And we're baaack! */
+	} while (fixup_guest_exit(vcpu, vgic, &exit_code));
+
+	__sysreg_save_state_nvhe(guest_ctxt);
+	__sysreg32_save_state(vcpu);
+	__timer_disable_traps();
+	__hyp_vgic_save_state(vcpu);
+
+	__deactivate_traps(vcpu_hyps);
+	__load_host_stage2();
+
+	__sysreg_restore_state_nvhe(host_ctxt);
+
+	if (hyp_state_flags(vcpu_hyps) & KVM_ARM64_FP_ENABLED)
+		__fpsimd_save_fpexc32(vcpu);
+
+	__debug_switch_to_host(vcpu);
+	/*
+	 * This must come after restoring the host sysregs, since a non-VHE
+	 * system may enable SPE here and make use of the TTBRs.
+	 */
+	__debug_restore_host_buffers_nvhe(vcpu);
+
+	if (pmu_switch_needed)
+		__pmu_switch_to_host(host_ctxt);
+
+	/* Returning to host will clear PSR.I, remask PMR if needed */
+	if (system_uses_irq_prio_masking())
+		gic_write_pmr(GIC_PRIO_IRQOFF);
+
+	set_hyp_running_vcpu(host_ctxt, NULL);
+
+	return exit_code;
+}
+
+/* Switch to the protected guest */
+static int __kvm_vcpu_run_pvm(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
@@ -268,6 +370,17 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	return exit_code;
 }
 
+/* Switch to the guest for non-VHE and protected KVM systems */
+int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
+{
+	vcpu = kern_hyp_va(vcpu);
+
+	if (likely(!kvm_vm_is_protected(kern_hyp_va(vcpu->kvm))))
+		return __kvm_vcpu_run_nvhe(vcpu);
+	else
+		return __kvm_vcpu_run_pvm(vcpu);
+}
+
 void __noreturn hyp_panic(void)
 {
 	u64 spsr = read_sysreg_el2(SYS_SPSR);
-- 
2.33.0.685.g46640cef36-goog

