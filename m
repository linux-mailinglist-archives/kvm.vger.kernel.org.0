Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5B7417589
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 15:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345864AbhIXNZ3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 09:25:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346033AbhIXNY7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Sep 2021 09:24:59 -0400
Received: from mail-wr1-x44a.google.com (mail-wr1-x44a.google.com [IPv6:2a00:1450:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40D87C08EB32
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 05:54:39 -0700 (PDT)
Received: by mail-wr1-x44a.google.com with SMTP id a17-20020adfed11000000b00160525e875aso465737wro.23
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 05:54:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=KdvACj7ScAwIuEMJbmPRwZN04q8vDtBfcaRexWOega0=;
        b=Bp+HmPnpsNaDYKd2wJTQKcdK6QUvaLr2dbDESicGuN/CntrraxanjCKThSU6jpa/DF
         lXU3sJrAsE5wkdJMapqG3vAXGWPGAafdQVDNrEKQB3XoWP4fGSMAajMw9af32GlCD5Ee
         vbozyCMmUyE2UhxIfhrW79JRFDu5TSDftUpsulHmLrKwy1p7Qvbt20olLYrO1onf0VWp
         38ePfEaGMaV4BEhJBoSFZ/mM5AS7AB+OvTbfUeEW6B8XptMp+R+rqnPXo/C8J1esj6Ge
         YbrGALrWfcIu26o3vHuE9bgXN6VlYcpRb/+eV434kuDpJ8OQL6NyDW9wE8kWoUITIy2A
         YFnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=KdvACj7ScAwIuEMJbmPRwZN04q8vDtBfcaRexWOega0=;
        b=m+8Yb+928eSMSwdpl5pggH/CV01ME8aHnRmzsbdJ2ItCchNDyPeVal0U0mu8tlEdpd
         mGFr6rvPj+0tK3B7byIZd5b4M14u3c6SmpxoFUSKe50+iX7f98i2K42RnxPq9Tt35aQo
         yU9ntfrEFmqMgEUQBh35omHTOk9FZPFY7mLb0xIrAKuFh1tSAPFguv70m4GvvlP0l92P
         NKfDGiGiodCEGbjZ5KYmIaDJHzPgl3PnfGFneSGwFy/T96ReeZT2r66Yfz8Y35ni5wsZ
         QbUJdBCLgqkUrsPkDjPU7tEg6tyX+ECW9Qs3FuiEC4GiR+fddFMNSsvdXj4yclK6Fp24
         9Pkg==
X-Gm-Message-State: AOAM533pgqDvr+hXaioljufagPsISbMWhKzghrpmfkaiXw+Q2ufKss18
        n7KBSW/fQdzs8hMWyuOYxMfDYgg1bQ==
X-Google-Smtp-Source: ABdhPJyMxkK6kPHtGxtAN5P/8jRsrvR7E205Ok7blDFoTasMAguIS9tU/tg+pmTXLbz5/Qp+Xl4+87FOgA==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a1c:1b48:: with SMTP id b69mr1927489wmb.14.1632488077852;
 Fri, 24 Sep 2021 05:54:37 -0700 (PDT)
Date:   Fri, 24 Sep 2021 13:53:46 +0100
In-Reply-To: <20210924125359.2587041-1-tabba@google.com>
Message-Id: <20210924125359.2587041-18-tabba@google.com>
Mime-Version: 1.0
References: <20210924125359.2587041-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [RFC PATCH v1 17/30] KVM: arm64: access __hyp_running_vcpu via
 accessors only
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

__hyp_running_vcpu exposes struct vcpu, but all that accesses it
only need the cpu_ctxt and the hyp state. Start this refactoring
by first ensuring that all accesses to __hyp_running_vcpu go via
accessors and not directly.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_asm.h           | 24 ++++++++++++++++++++++
 arch/arm64/include/asm/kvm_host.h          |  7 +++++++
 arch/arm64/kernel/asm-offsets.c            |  1 +
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h |  4 ++--
 arch/arm64/kvm/hyp/nvhe/switch.c           | 10 ++++-----
 arch/arm64/kvm/hyp/vhe/switch.c            |  8 +++-----
 6 files changed, 41 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 5e9b33cbac51..766b6a852407 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -251,6 +251,18 @@ extern u32 __kvm_get_mdcr_el2(void);
 	ldr	\vcpu, [\ctxt, #HOST_CONTEXT_VCPU]
 .endm
 
+.macro get_vcpu_ctxt_ptr vcpu, ctxt
+	get_host_ctxt \ctxt, \vcpu
+	ldr	\vcpu, [\ctxt, #HOST_CONTEXT_VCPU]
+	add	\vcpu, \vcpu, #VCPU_CONTEXT
+.endm
+
+.macro get_vcpu_hyps_ptr vcpu, ctxt
+	get_host_ctxt \ctxt, \vcpu
+	ldr	\vcpu, [\ctxt, #HOST_CONTEXT_VCPU]
+	add	\vcpu, \vcpu, #VCPU_HYPS
+.endm
+
 .macro get_loaded_vcpu vcpu, ctxt
 	adr_this_cpu \ctxt, kvm_hyp_ctxt, \vcpu
 	ldr	\vcpu, [\ctxt, #HOST_CONTEXT_VCPU]
@@ -261,6 +273,18 @@ extern u32 __kvm_get_mdcr_el2(void);
 	str	\vcpu, [\ctxt, #HOST_CONTEXT_VCPU]
 .endm
 
+.macro get_loaded_vcpu_ctxt vcpu, ctxt
+	adr_this_cpu \ctxt, kvm_hyp_ctxt, \vcpu
+	ldr	\vcpu, [\ctxt, #HOST_CONTEXT_VCPU]
+	add	\vcpu, \vcpu, #VCPU_CONTEXT
+.endm
+
+.macro get_loaded_vcpu_hyps vcpu, ctxt
+	adr_this_cpu \ctxt, kvm_hyp_ctxt, \vcpu
+	ldr	\vcpu, [\ctxt, #HOST_CONTEXT_VCPU]
+	add	\vcpu, \vcpu, #VCPU_HYPS
+.endm
+
 /*
  * KVM extable for unexpected exceptions.
  * In the same format _asm_extable, but output to a different section so that
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index dc4b5e133d86..4b01c74705ad 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -230,6 +230,13 @@ struct kvm_cpu_context {
 	struct kvm_vcpu *__hyp_running_vcpu;
 };
 
+#define get_hyp_running_vcpu(ctxt) (ctxt)->__hyp_running_vcpu
+#define set_hyp_running_vcpu(ctxt, vcpu) (ctxt)->__hyp_running_vcpu = (vcpu)
+#define is_hyp_running_vcpu(ctxt) (ctxt)->__hyp_running_vcpu
+
+#define get_hyp_running_ctxt(host_ctxt) (host_ctxt)->__hyp_running_vcpu ? &(host_ctxt)->__hyp_running_vcpu->arch.ctxt : NULL
+#define get_hyp_running_hyps(host_ctxt) (host_ctxt)->__hyp_running_vcpu ? &(host_ctxt)->__hyp_running_vcpu->arch.hyp_state : NULL
+
 struct kvm_pmu_events {
 	u32 events_host;
 	u32 events_guest;
diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
index 1776efc3cc9d..1ecc55570acc 100644
--- a/arch/arm64/kernel/asm-offsets.c
+++ b/arch/arm64/kernel/asm-offsets.c
@@ -107,6 +107,7 @@ int main(void)
   BLANK();
 #ifdef CONFIG_KVM
   DEFINE(VCPU_CONTEXT,		offsetof(struct kvm_vcpu, arch.ctxt));
+  DEFINE(VCPU_HYPS,		offsetof(struct kvm_vcpu, arch.hyp_state));
   DEFINE(VCPU_FAULT_DISR,	offsetof(struct kvm_vcpu, arch.hyp_state.fault.disr_el1));
   DEFINE(VCPU_WORKAROUND_FLAGS,	offsetof(struct kvm_vcpu, arch.workaround_flags));
   DEFINE(CPU_USER_PT_REGS,	offsetof(struct kvm_cpu_context, regs));
diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
index 7bc8b34b65b2..df9cd2177e71 100644
--- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
+++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
@@ -80,7 +80,7 @@ static inline void __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
 	    !cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {
 		write_sysreg_el1(ctxt_sys_reg(ctxt, SCTLR_EL1),	SYS_SCTLR);
 		write_sysreg_el1(ctxt_sys_reg(ctxt, TCR_EL1),	SYS_TCR);
-	} else	if (!ctxt->__hyp_running_vcpu) {
+	} else	if (!is_hyp_running_vcpu(ctxt)) {
 		/*
 		 * Must only be done for guest registers, hence the context
 		 * test. We're coming from the host, so SCTLR.M is already
@@ -109,7 +109,7 @@ static inline void __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
 
 	if (!has_vhe() &&
 	    cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT) &&
-	    ctxt->__hyp_running_vcpu) {
+	    is_hyp_running_vcpu(ctxt)) {
 		/*
 		 * Must only be done for host registers, hence the context
 		 * test. Pairs with nVHE's __deactivate_traps().
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 164b0f899f7b..12c673301210 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -191,7 +191,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	}
 
 	host_ctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
-	host_ctxt->__hyp_running_vcpu = vcpu;
+	set_hyp_running_vcpu(host_ctxt, vcpu);
 	guest_ctxt = &vcpu->arch.ctxt;
 
 	pmu_switch_needed = __pmu_switch_to_guest(host_ctxt);
@@ -261,7 +261,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	if (system_uses_irq_prio_masking())
 		gic_write_pmr(GIC_PRIO_IRQOFF);
 
-	host_ctxt->__hyp_running_vcpu = NULL;
+	set_hyp_running_vcpu(host_ctxt, NULL);
 
 	return exit_code;
 }
@@ -274,12 +274,10 @@ void __noreturn hyp_panic(void)
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_vcpu *vcpu;
 	struct vcpu_hyp_state *vcpu_hyps;
-	struct kvm_cpu_context *vcpu_ctxt;
 
 	host_ctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
-	vcpu = host_ctxt->__hyp_running_vcpu;
-	vcpu_hyps = &hyp_state(vcpu);
-	vcpu_ctxt = &vcpu_ctxt(vcpu);
+	vcpu = get_hyp_running_vcpu(host_ctxt);
+	vcpu_hyps = get_hyp_running_hyps(host_ctxt);
 
 	if (vcpu) {
 		__timer_disable_traps();
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index f315058a50ca..14c434e00914 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -117,7 +117,7 @@ static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 	u64 exit_code;
 
 	host_ctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
-	host_ctxt->__hyp_running_vcpu = vcpu;
+	set_hyp_running_vcpu(host_ctxt, vcpu);
 	guest_ctxt = &vcpu->arch.ctxt;
 
 	sysreg_save_host_state_vhe(host_ctxt);
@@ -205,12 +205,10 @@ static void __hyp_call_panic(u64 spsr, u64 elr, u64 par)
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_vcpu *vcpu;
 	struct vcpu_hyp_state *vcpu_hyps;
-	struct kvm_cpu_context *vcpu_ctxt;
 
 	host_ctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
-	vcpu = host_ctxt->__hyp_running_vcpu;
-	vcpu_hyps = &hyp_state(vcpu);
-	vcpu_ctxt = &vcpu_ctxt(vcpu);
+	vcpu = get_hyp_running_vcpu(host_ctxt);
+	vcpu_hyps = get_hyp_running_hyps(host_ctxt);
 
 	__deactivate_traps(vcpu_hyps);
 	sysreg_restore_host_state_vhe(host_ctxt);
-- 
2.33.0.685.g46640cef36-goog

