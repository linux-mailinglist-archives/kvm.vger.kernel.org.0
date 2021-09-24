Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F20BB417590
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 15:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345152AbhIXNZo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 09:25:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345154AbhIXNZB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Sep 2021 09:25:01 -0400
Received: from mail-wr1-x44a.google.com (mail-wr1-x44a.google.com [IPv6:2a00:1450:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6297CC034017
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 05:54:47 -0700 (PDT)
Received: by mail-wr1-x44a.google.com with SMTP id z2-20020a5d4c82000000b0015b140e0562so8012406wrs.7
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 05:54:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Q+8n29A2U0S8NhAXycyXeyNJmHo/u/5CJ1rE8AvB4D8=;
        b=cxpNbynNFzYUxpl57MPUhLzZUKq20M6Q1Tq3Uvg3l5O/+YFgKxm+t3GqpLYgANuefD
         FPUjOhEFGEJy43xXVn6ZFNY0LFs4Uy6mjCyxHhS8Zo/wb78rOmhuQQJ9vwDTZv8/11dw
         DXLgiQ4WjLw2W/KPOPTTtiK/9s1sIFiRPMuNAefBb6r1alfL0vFOz1pUq+Crz1+Tc1Wf
         FYB+yadmLGksdNEeGyE+zllj0q2xhraWVXxhQ1ab7nRJfm8KrZox2fEDFaKyRLw+x4w4
         r49qzs8672CUxLgy2rljpqGDb7uuyXtfH+mlUs38aHU7pwRKXgh3dZ02yKB2BTwkyoQ8
         Ln1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Q+8n29A2U0S8NhAXycyXeyNJmHo/u/5CJ1rE8AvB4D8=;
        b=7Sj+glteifGrutKSl4rNmsxvGF8Fh+4IOeW3DTs2J5BqyLKpQ8xspEsNON6yxXTLB2
         EfvWOb1in6xTH3IXrlAD6wXuUgw9Hnnp7Pjj3OFzxatZ7arbiR/K4LRywLEiGlytmOFO
         QjQXYN9sUjkr5oOLxNHt40RY1Cz24VQGulaLP5sJjwZHg+gFYMLMcTxcOEb3U3H9vSJX
         b7IQuHNJz91xSVFl3hoOGKUowomd1DM4YjhuwuJdzd9NS4cnjrE4js/zmM3o2n42RvYb
         8CyQcopXAgYNy+fHXrrGjKqpLUQGy+0WqNV8QxelAbv3ZeZJGfVLCUIH4Z979AjK9WKP
         c0gw==
X-Gm-Message-State: AOAM531k8L86LBIQwhX+NcLbKoBACk6ZoTYMOmxyHCCvK1OkBHkz+RR4
        Hv1z/VxtZj18mMqLQQAcFkJU92FhOw==
X-Google-Smtp-Source: ABdhPJwSaHPVCm7TSNiTJZE78dylDVwwxbZ3U77YPIEY25dKbKZj9TIDo4HPPu5CDTfj+SDFth6yZB/QeA==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:adf:ecd2:: with SMTP id s18mr11112114wro.99.1632488085955;
 Fri, 24 Sep 2021 05:54:45 -0700 (PDT)
Date:   Fri, 24 Sep 2021 13:53:50 +0100
In-Reply-To: <20210924125359.2587041-1-tabba@google.com>
Message-Id: <20210924125359.2587041-22-tabba@google.com>
Mime-Version: 1.0
References: <20210924125359.2587041-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [RFC PATCH v1 21/30] KVM: arm64: transition code to
 __hyp_running_ctxt and __hyp_running_hyps
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

Transition code for to use the new hyp_running pointers.
Everything is consistent, because all fields are in-sync.

Remove __hyp_running_vcpu now that no one is using it.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_asm.h  | 24 ++++--------------------
 arch/arm64/include/asm/kvm_host.h |  5 +----
 arch/arm64/kernel/asm-offsets.c   |  1 -
 arch/arm64/kvm/handle_exit.c      |  6 +++---
 arch/arm64/kvm/hyp/nvhe/host.S    |  2 +-
 arch/arm64/kvm/hyp/nvhe/switch.c  |  4 +---
 arch/arm64/kvm/hyp/vhe/switch.c   |  8 ++++----
 7 files changed, 14 insertions(+), 36 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 52079e937fcd..e24ebcf9e0d3 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -246,31 +246,18 @@ extern u32 __kvm_get_mdcr_el2(void);
 	add	\reg, \reg, #HOST_DATA_CONTEXT
 .endm
 
-.macro get_vcpu_ptr vcpu, ctxt
-	get_host_ctxt \ctxt, \vcpu
-	ldr	\vcpu, [\ctxt, #HOST_CONTEXT_VCPU]
-.endm
-
 .macro get_vcpu_ctxt_ptr vcpu, ctxt
 	get_host_ctxt \ctxt, \vcpu
-	ldr	\vcpu, [\ctxt, #HOST_CONTEXT_VCPU]
-	add	\vcpu, \vcpu, #VCPU_CONTEXT
+	ldr	\vcpu, [\ctxt, #HOST_CONTEXT_CTXT]
 .endm
 
 .macro get_vcpu_hyps_ptr vcpu, ctxt
 	get_host_ctxt \ctxt, \vcpu
-	ldr	\vcpu, [\ctxt, #HOST_CONTEXT_VCPU]
-	add	\vcpu, \vcpu, #VCPU_HYPS
-.endm
-
-.macro get_loaded_vcpu vcpu, ctxt
-	adr_this_cpu \ctxt, kvm_hyp_ctxt, \vcpu
-	ldr	\vcpu, [\ctxt, #HOST_CONTEXT_VCPU]
+	ldr	\vcpu, [\ctxt, #HOST_CONTEXT_HYPS]
 .endm
 
 .macro set_loaded_vcpu vcpu, ctxt, tmp
 	adr_this_cpu \ctxt, kvm_hyp_ctxt, \tmp
-	str	\vcpu, [\ctxt, #HOST_CONTEXT_VCPU]
 
 	add	\tmp, \vcpu, #VCPU_CONTEXT
 	str	\tmp, [\ctxt, #HOST_CONTEXT_CTXT]
@@ -281,21 +268,18 @@ extern u32 __kvm_get_mdcr_el2(void);
 
 .macro clear_loaded_vcpu ctxt, tmp
 	adr_this_cpu \ctxt, kvm_hyp_ctxt, \tmp
-	str	xzr, [\ctxt, #HOST_CONTEXT_VCPU]
 	str	xzr, [\ctxt, #HOST_CONTEXT_CTXT]
 	str	xzr, [\ctxt, #HOST_CONTEXT_HYPS]
 .endm
 
 .macro get_loaded_vcpu_ctxt vcpu, ctxt
 	adr_this_cpu \ctxt, kvm_hyp_ctxt, \vcpu
-	ldr	\vcpu, [\ctxt, #HOST_CONTEXT_VCPU]
-	add	\vcpu, \vcpu, #VCPU_CONTEXT
+	ldr	\vcpu, [\ctxt, #HOST_CONTEXT_CTXT]
 .endm
 
 .macro get_loaded_vcpu_hyps vcpu, ctxt
 	adr_this_cpu \ctxt, kvm_hyp_ctxt, \vcpu
-	ldr	\vcpu, [\ctxt, #HOST_CONTEXT_VCPU]
-	add	\vcpu, \vcpu, #VCPU_HYPS
+	ldr	\vcpu, [\ctxt, #HOST_CONTEXT_HYPS]
 .endm
 
 /*
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index b42d0c6c8004..035ca5a49166 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -227,15 +227,12 @@ struct kvm_cpu_context {
 
 	u64 sys_regs[NR_SYS_REGS];
 
-	struct kvm_vcpu *__hyp_running_vcpu;
 	struct kvm_cpu_context *__hyp_running_ctxt;
 	struct vcpu_hyp_state *__hyp_running_hyps;
 };
 
-#define get_hyp_running_vcpu(ctxt) (ctxt)->__hyp_running_vcpu
 #define set_hyp_running_vcpu(host_ctxt, vcpu) do { \
 	struct kvm_vcpu *v = (vcpu); \
-	(host_ctxt)->__hyp_running_vcpu = v; \
 	if (vcpu) { \
 		(host_ctxt)->__hyp_running_ctxt = &v->arch.ctxt; \
 		(host_ctxt)->__hyp_running_hyps = &v->arch.hyp_state; \
@@ -245,7 +242,7 @@ struct kvm_cpu_context {
 	}\
 } while(0)
 
-#define is_hyp_running_vcpu(ctxt) (ctxt)->__hyp_running_vcpu
+#define is_hyp_running_vcpu(ctxt) (ctxt)->__hyp_running_ctxt
 
 #define get_hyp_running_ctxt(host_ctxt) (host_ctxt)->__hyp_running_ctxt
 #define get_hyp_running_hyps(host_ctxt) (host_ctxt)->__hyp_running_hyps
diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
index 9c25078da294..f42aea730cf4 100644
--- a/arch/arm64/kernel/asm-offsets.c
+++ b/arch/arm64/kernel/asm-offsets.c
@@ -116,7 +116,6 @@ int main(void)
   DEFINE(CPU_APDAKEYLO_EL1,	offsetof(struct kvm_cpu_context, sys_regs[APDAKEYLO_EL1]));
   DEFINE(CPU_APDBKEYLO_EL1,	offsetof(struct kvm_cpu_context, sys_regs[APDBKEYLO_EL1]));
   DEFINE(CPU_APGAKEYLO_EL1,	offsetof(struct kvm_cpu_context, sys_regs[APGAKEYLO_EL1]));
-  DEFINE(HOST_CONTEXT_VCPU,	offsetof(struct kvm_cpu_context, __hyp_running_vcpu));
   DEFINE(HOST_CONTEXT_CTXT,	offsetof(struct kvm_cpu_context, __hyp_running_ctxt));
   DEFINE(HOST_CONTEXT_HYPS,	offsetof(struct kvm_cpu_context, __hyp_running_hyps));
   DEFINE(HOST_DATA_CONTEXT,	offsetof(struct kvm_host_data, host_ctxt));
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 22e9f03fe901..cb6a25b79e38 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -293,7 +293,7 @@ void handle_exit_early(struct kvm_vcpu *vcpu, int exception_index)
 }
 
 void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, u64 spsr, u64 elr,
-					      u64 par, uintptr_t vcpu,
+					      u64 par, uintptr_t vcpu_ctxt,
 					      u64 far, u64 hpfar) {
 	u64 elr_in_kimg = __phys_to_kimg(__hyp_pa(elr));
 	u64 hyp_offset = elr_in_kimg - kaslr_offset() - elr;
@@ -333,6 +333,6 @@ void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, u64 spsr, u64 elr,
 	 */
 	kvm_err("Hyp Offset: 0x%llx\n", hyp_offset);
 
-	panic("HYP panic:\nPS:%08llx PC:%016llx ESR:%08llx\nFAR:%016llx HPFAR:%016llx PAR:%016llx\nVCPU:%016lx\n",
-	      spsr, elr, esr, far, hpfar, par, vcpu);
+	panic("HYP panic:\nPS:%08llx PC:%016llx ESR:%08llx\nFAR:%016llx HPFAR:%016llx PAR:%016llx\nVCPU_CTXT:%016lx\n",
+	      spsr, elr, esr, far, hpfar, par, vcpu_ctxt);
 }
diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
index 7de2e8716f69..975cf125d54c 100644
--- a/arch/arm64/kvm/hyp/nvhe/host.S
+++ b/arch/arm64/kvm/hyp/nvhe/host.S
@@ -87,7 +87,7 @@ SYM_FUNC_START(__hyp_do_panic)
 
 	/* Load the panic arguments into x0-7 */
 	mrs	x0, esr_el2
-	get_vcpu_ptr x4, x5
+	get_vcpu_ctxt_ptr x4, x5
 	mrs	x5, far_el2
 	mrs	x6, hpfar_el2
 	mov	x7, xzr			// Unused argument
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 12c673301210..483df8fe052e 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -272,14 +272,12 @@ void __noreturn hyp_panic(void)
 	u64 elr = read_sysreg_el2(SYS_ELR);
 	u64 par = read_sysreg_par();
 	struct kvm_cpu_context *host_ctxt;
-	struct kvm_vcpu *vcpu;
 	struct vcpu_hyp_state *vcpu_hyps;
 
 	host_ctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
-	vcpu = get_hyp_running_vcpu(host_ctxt);
 	vcpu_hyps = get_hyp_running_hyps(host_ctxt);
 
-	if (vcpu) {
+	if (vcpu_hyps) {
 		__timer_disable_traps();
 		__deactivate_traps(vcpu_hyps);
 		__load_host_stage2();
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 14c434e00914..64de9f0d7636 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -203,20 +203,20 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 static void __hyp_call_panic(u64 spsr, u64 elr, u64 par)
 {
 	struct kvm_cpu_context *host_ctxt;
-	struct kvm_vcpu *vcpu;
+	struct kvm_cpu_context *vcpu_ctxt;
 	struct vcpu_hyp_state *vcpu_hyps;
 
 	host_ctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
-	vcpu = get_hyp_running_vcpu(host_ctxt);
+	vcpu_ctxt = get_hyp_running_ctxt(host_ctxt);
 	vcpu_hyps = get_hyp_running_hyps(host_ctxt);
 
 	__deactivate_traps(vcpu_hyps);
 	sysreg_restore_host_state_vhe(host_ctxt);
 
-	panic("HYP panic:\nPS:%08llx PC:%016llx ESR:%08llx\nFAR:%016llx HPFAR:%016llx PAR:%016llx\nVCPU:%p\n",
+	panic("HYP panic:\nPS:%08llx PC:%016llx ESR:%08llx\nFAR:%016llx HPFAR:%016llx PAR:%016llx\nVCPU_CTXT:%p\n",
 	      spsr, elr,
 	      read_sysreg_el2(SYS_ESR), read_sysreg_el2(SYS_FAR),
-	      read_sysreg(hpfar_el2), par, vcpu);
+	      read_sysreg(hpfar_el2), par, vcpu_ctxt);
 }
 NOKPROBE_SYMBOL(__hyp_call_panic);
 
-- 
2.33.0.685.g46640cef36-goog

