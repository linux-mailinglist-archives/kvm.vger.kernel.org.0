Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEF644FE256
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 15:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352043AbiDLNYM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 09:24:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356321AbiDLNXH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 09:23:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDAE125D7
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 06:13:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 57A42619FC
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 13:13:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FDD2C385B2;
        Tue, 12 Apr 2022 13:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649769234;
        bh=Ut9f0t7P1uj9iDlWM5d1L6gPtrcHpfme+F7WU+3GL4U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LLymQ1mUulJsFhiJ4sMb86UekUZtrqwJj5vstOzuKmX23ymHphBBDOrJIGX+p83m5
         S4H5vQ6bGyhkBIi0t0Pmt6YT7bexazwXbXCaTwrxFdb0G9buniVx7b+jjvoW6Fiw8K
         MmopbAAOrEbsCX07bMYEGtGuOnNkClYLjGqtzEev21u5ygVhA4mGsk9ZaD0ioM8myo
         xvkn8V42Lleq8DWHZtYxu+qf+Wk9J6TiG+zAMyqwxmcioa80yxRJxnLCZstiBoKcaX
         4v85z/GIrs1rMPpNikXOdlwAJ7kXmZalIvBrDjhEtr+erhgWp4nMs10dCbxODwkR9B
         p9xhxtIBDJtng==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1neGLA-003mvX-79; Tue, 12 Apr 2022 14:13:52 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: [PATCH 05/10] KVM: arm64: Handle blocking WFIT instruction
Date:   Tue, 12 Apr 2022 14:12:58 +0100
Message-Id: <20220412131303.504690-6-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220412131303.504690-1-maz@kernel.org>
References: <20220412131303.504690-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When trapping a blocking WFIT instruction, take it into account when
computing the deadline of the background timer.

The state is tracked with a new vcpu flag, and is gated by a new
CPU capability, which isn't currently enabled.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/arch_timer.c       | 22 ++++++++++++++++++++--
 arch/arm64/kvm/arm.c              |  1 +
 arch/arm64/kvm/handle_exit.c      |  7 ++++++-
 arch/arm64/tools/cpucaps          |  1 +
 5 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index e3b25dc6c367..9e6e8701933e 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -441,6 +441,7 @@ struct kvm_vcpu_arch {
 #define KVM_ARM64_DEBUG_STATE_SAVE_TRBE	(1 << 13) /* Save TRBE context if active  */
 #define KVM_ARM64_FP_FOREIGN_FPSTATE	(1 << 14)
 #define KVM_ARM64_ON_UNSUPPORTED_CPU	(1 << 15) /* Physical CPU not in supported_cpus */
+#define KVM_ARM64_WFIT			(1 << 16) /* WFIT instruction trapped */
 
 #define KVM_GUESTDBG_VALID_MASK (KVM_GUESTDBG_ENABLE | \
 				 KVM_GUESTDBG_USE_SW_BP | \
diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index c92a68190f6a..4e39ace073af 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -239,6 +239,20 @@ static bool kvm_timer_irq_can_fire(struct arch_timer_context *timer_ctx)
 		  (ARCH_TIMER_CTRL_IT_MASK | ARCH_TIMER_CTRL_ENABLE)) == ARCH_TIMER_CTRL_ENABLE);
 }
 
+static bool vcpu_has_wfit_active(struct kvm_vcpu *vcpu)
+{
+	return (cpus_have_final_cap(ARM64_HAS_WFXT) &&
+		(vcpu->arch.flags & KVM_ARM64_WFIT));
+}
+
+static u64 wfit_delay_ns(struct kvm_vcpu *vcpu)
+{
+	struct arch_timer_context *ctx = vcpu_vtimer(vcpu);
+	u64 val = vcpu_get_reg(vcpu, kvm_vcpu_sys_get_rt(vcpu));
+
+	return kvm_counter_compute_delta(ctx, val);
+}
+
 /*
  * Returns the earliest expiration time in ns among guest timers.
  * Note that it will return 0 if none of timers can fire.
@@ -256,6 +270,9 @@ static u64 kvm_timer_earliest_exp(struct kvm_vcpu *vcpu)
 			min_delta = min(min_delta, kvm_timer_compute_delta(ctx));
 	}
 
+	if (vcpu_has_wfit_active(vcpu))
+		min_delta = min(min_delta, wfit_delay_ns(vcpu));
+
 	/* If none of timers can fire, then return 0 */
 	if (min_delta == ULLONG_MAX)
 		return 0;
@@ -355,7 +372,7 @@ static bool kvm_timer_should_fire(struct arch_timer_context *timer_ctx)
 
 int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
 {
-	return 0;
+	return vcpu_has_wfit_active(vcpu) && wfit_delay_ns(vcpu) == 0;
 }
 
 /*
@@ -481,7 +498,8 @@ static void kvm_timer_blocking(struct kvm_vcpu *vcpu)
 	 */
 	if (!kvm_timer_irq_can_fire(map.direct_vtimer) &&
 	    !kvm_timer_irq_can_fire(map.direct_ptimer) &&
-	    !kvm_timer_irq_can_fire(map.emul_ptimer))
+	    !kvm_timer_irq_can_fire(map.emul_ptimer) &&
+	    !vcpu_has_wfit_active(vcpu))
 		return;
 
 	/*
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 2122c699af06..e7cb8a4d2e81 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -634,6 +634,7 @@ void kvm_vcpu_wfi(struct kvm_vcpu *vcpu)
 	preempt_enable();
 
 	kvm_vcpu_halt(vcpu);
+	vcpu->arch.flags &= ~KVM_ARM64_WFIT;
 	kvm_clear_request(KVM_REQ_UNHALT, vcpu);
 
 	preempt_disable();
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 97fe14aab1a3..4260f2cd1971 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -85,16 +85,21 @@ static int handle_no_fpsimd(struct kvm_vcpu *vcpu)
  * WFI: Simply call kvm_vcpu_halt(), which will halt execution of
  * world-switches and schedule other host processes until there is an
  * incoming IRQ or FIQ to the VM.
+ * WFIT: Same as WFI, with a timed wakeup implemented as a background timer
  */
 static int kvm_handle_wfx(struct kvm_vcpu *vcpu)
 {
-	if (kvm_vcpu_get_esr(vcpu) & ESR_ELx_WFx_ISS_WFE) {
+	u64 esr = kvm_vcpu_get_esr(vcpu);
+
+	if (esr & ESR_ELx_WFx_ISS_WFE) {
 		trace_kvm_wfx_arm64(*vcpu_pc(vcpu), true);
 		vcpu->stat.wfe_exit_stat++;
 		kvm_vcpu_on_spin(vcpu, vcpu_mode_priv(vcpu));
 	} else {
 		trace_kvm_wfx_arm64(*vcpu_pc(vcpu), false);
 		vcpu->stat.wfi_exit_stat++;
+		if ((esr & (ESR_ELx_WFx_ISS_RV | ESR_ELx_WFx_ISS_WFxT)) == (ESR_ELx_WFx_ISS_RV | ESR_ELx_WFx_ISS_WFxT))
+			vcpu->arch.flags |= KVM_ARM64_WFIT;
 		kvm_vcpu_wfi(vcpu);
 	}
 
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index 3ed418f70e3b..01f7d253dec4 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -38,6 +38,7 @@ HAS_STAGE2_FWB
 HAS_SYSREG_GIC_CPUIF
 HAS_TLB_RANGE
 HAS_VIRT_HOST_EXTN
+HAS_WFXT
 HW_DBM
 KVM_PROTECTED_MODE
 MISMATCHED_CACHE_TYPE
-- 
2.34.1

