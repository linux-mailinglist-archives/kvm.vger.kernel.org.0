Return-Path: <kvm+bounces-54738-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 412C0B273E1
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 02:30:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D5F8C602884
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 00:29:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E016D21423C;
	Fri, 15 Aug 2025 00:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2SMBNvUh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C3C22135B8
	for <kvm@vger.kernel.org>; Fri, 15 Aug 2025 00:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755217571; cv=none; b=HRBKkmwvFgdfEy1b9zIsNJDICHpnfi6nXjRCPxH5NSEkTZUW2Qmi3MJSmajb0ROPMTaNCUIM0V5k/04vBXSY1U6TqLipoverl1OeqakhvdcCZcV8hqIyj19b7gsm1oJNjq1wC9Pf7+5HhuZNFrvQho27xYY17wH1qM7ka1J20KA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755217571; c=relaxed/simple;
	bh=qmL9NrmtiXC3HK88dDM+5zUIzt7pM8rk2E5vbAlLZ6g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OsdxXynetuA9Hufdk2YUEX4XzKdFRzDHxfAqsLpx2WSO/Vj9yMife79s0u335qxknE/7yfZEk0lwUqk0e8iwlhAS5AlbNWXdb+d6TAoGlQ5PBSW3wJl/2norHS5HJZupWb/c4nxd1ApWz70D7gvpvrKtz7u5TNCho2pqBcsmDZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2SMBNvUh; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-321cf7549afso2081607a91.0
        for <kvm@vger.kernel.org>; Thu, 14 Aug 2025 17:26:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755217569; x=1755822369; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=0eUCS0Bqt57t3+SFOXzW9pVxMUOmtV+wP/2egB/EzGA=;
        b=2SMBNvUhMFQYEiIiQrjkjaIHSNfTf1pr3c+I+sDP+V95HtWQFEzdTPjyFO7KtJ3jrK
         yok3QRDzk0FRq+3CqAsd0iriwa36PtuWllkcShL6IsxUM6kl2sWwBBqATfovLhAdaoqD
         Q1G6WZqgXp7nt7nIrh8stoJWxmee/40v8z0KIiazc8hNN1aR4fBgvNjMKRYV9gcBzTpk
         aS1vKQl3qfAsMT/zOyWORRo4Ejno4DQ4N0R5tpmgL9vD55laDS09v8gYeeBGGwWopoua
         0zH8CgH32/Au3GkoMwCsJ39pw6DzSc5B/6oRiTbBa8e3hNYxFVfmZTM6E4obNYb/G6co
         jDtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755217569; x=1755822369;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0eUCS0Bqt57t3+SFOXzW9pVxMUOmtV+wP/2egB/EzGA=;
        b=pmVyA1FEKaur0iFbi+oBeW4cNejR/qttMznNWVS82vMTbxwqHS59KkovXrvUk4INwk
         +hbzqRYMlKOcwq9XsUOz4mlD0UKFpemsRePNVsNaZ4n28o7dL4vThSJsQ4n70Zjw6Rmw
         81wCOZ58jig8ny6sHSgB8g7+5HDWT4ZgGSzyqMebLeIdnqmrfM8eLrrDRmVSDEbOxAcD
         om0nKZNh4FAaF+z46ZKtBP3AXzgdttTRJU/2X98eP3ynjsWt1dMOkcDHx+NXaTjvRT4t
         apA/WQlyIajJ3KgZI8wGqoNisYlzLXRQZ1lrPp5o52ifPFT1CpQZMiuLU640nMvXG87B
         MABA==
X-Gm-Message-State: AOJu0YzbBQ6rHMaOK2HPGu0D4ifYn4KSCUWMJrgYJ6Ze7JhkZBxtiHDE
	D7L/jKKi9Gf5/yEcBR5A6ZYkuGTLRiQPVwevkmq3ksLUolQIA8cx9ZrwrYwvmqYPCyY+ommh9IM
	oumHcaw==
X-Google-Smtp-Source: AGHT+IHNEO/6ctMp9BDujnLiKXXKG05Q/ECbAKzWkRd0I0EnYabFWDHpgpKuHdxcom2gzRTTIyDfWqa1DfI=
X-Received: from pjbos14.prod.google.com ([2002:a17:90b:1cce:b0:31f:3227:1724])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3f85:b0:31f:35f:96a1
 with SMTP id 98e67ed59e1d1-323407b888fmr487019a91.15.1755217568723; Thu, 14
 Aug 2025 17:26:08 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 14 Aug 2025 17:25:33 -0700
In-Reply-To: <20250815002540.2375664-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250815002540.2375664-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.rc1.163.g2494970778-goog
Message-ID: <20250815002540.2375664-14-seanjc@google.com>
Subject: [PATCH 6.6.y 13/20] KVM: x86: Fully defer to vendor code to decide
 how to force immediate exit
From: Sean Christopherson <seanjc@google.com>
To: stable@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Sasha Levin <sashal@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"

[ Upstream commit 0ec3d6d1f169baa7fc512ae4b78d17e7c94b7763 ]

Now that vmx->req_immediate_exit is used only in the scope of
vmx_vcpu_run(), use force_immediate_exit to detect that KVM should usurp
the VMX preemption to force a VM-Exit and let vendor code fully handle
forcing a VM-Exit.

Opportunsitically drop __kvm_request_immediate_exit() and just have
vendor code call smp_send_reschedule() directly.  SVM already does this
when injecting an event while also trying to single-step an IRET, i.e.
it's not exactly secret knowledge that KVM uses a reschedule IPI to force
an exit.

Link: https://lore.kernel.org/r/20240110012705.506918-7-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
[sean: resolve absurd conflict due to funky kvm_x86_ops.sched_in prototype]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 -
 arch/x86/include/asm/kvm_host.h    |  3 ---
 arch/x86/kvm/svm/svm.c             |  7 ++++---
 arch/x86/kvm/vmx/vmx.c             | 32 +++++++++++++-----------------
 arch/x86/kvm/vmx/vmx.h             |  2 --
 arch/x86/kvm/x86.c                 | 10 +---------
 6 files changed, 19 insertions(+), 36 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index e59ded976166..8fe6667d945f 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -102,7 +102,6 @@ KVM_X86_OP(write_tsc_multiplier)
 KVM_X86_OP(get_exit_info)
 KVM_X86_OP(check_intercept)
 KVM_X86_OP(handle_exit_irqoff)
-KVM_X86_OP(request_immediate_exit)
 KVM_X86_OP(sched_in)
 KVM_X86_OP_OPTIONAL(update_cpu_dirty_logging)
 KVM_X86_OP_OPTIONAL(vcpu_blocking)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5703600a454e..8898ad8cb3de 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1695,8 +1695,6 @@ struct kvm_x86_ops {
 			       struct x86_exception *exception);
 	void (*handle_exit_irqoff)(struct kvm_vcpu *vcpu);
 
-	void (*request_immediate_exit)(struct kvm_vcpu *vcpu);
-
 	void (*sched_in)(struct kvm_vcpu *kvm, int cpu);
 
 	/*
@@ -2182,7 +2180,6 @@ extern bool kvm_find_async_pf_gfn(struct kvm_vcpu *vcpu, gfn_t gfn);
 
 int kvm_skip_emulated_instruction(struct kvm_vcpu *vcpu);
 int kvm_complete_insn_gp(struct kvm_vcpu *vcpu, int err);
-void __kvm_request_immediate_exit(struct kvm_vcpu *vcpu);
 
 void __user *__x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa,
 				     u32 size);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f42c6ef7dc20..4a53b38ea386 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4222,8 +4222,11 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu,
 		 * is enough to force an immediate vmexit.
 		 */
 		disable_nmi_singlestep(svm);
+		force_immediate_exit = true;
+	}
+
+	if (force_immediate_exit)
 		smp_send_reschedule(vcpu->cpu);
-	}
 
 	pre_svm_run(vcpu);
 
@@ -5075,8 +5078,6 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.check_intercept = svm_check_intercept,
 	.handle_exit_irqoff = svm_handle_exit_irqoff,
 
-	.request_immediate_exit = __kvm_request_immediate_exit,
-
 	.sched_in = svm_sched_in,
 
 	.nested_ops = &svm_nested_ops,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0ecc0e996386..704e5a552b4f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -49,6 +49,8 @@
 #include <asm/spec-ctrl.h>
 #include <asm/vmx.h>
 
+#include <trace/events/ipi.h>
+
 #include "capabilities.h"
 #include "cpuid.h"
 #include "hyperv.h"
@@ -1304,8 +1306,6 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 	u16 fs_sel, gs_sel;
 	int i;
 
-	vmx->req_immediate_exit = false;
-
 	/*
 	 * Note that guest MSRs to be saved/restored can also be changed
 	 * when guest state is loaded. This happens when guest transitions
@@ -6015,7 +6015,8 @@ static int handle_pml_full(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
-static fastpath_t handle_fastpath_preemption_timer(struct kvm_vcpu *vcpu)
+static fastpath_t handle_fastpath_preemption_timer(struct kvm_vcpu *vcpu,
+						   bool force_immediate_exit)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
@@ -6031,7 +6032,7 @@ static fastpath_t handle_fastpath_preemption_timer(struct kvm_vcpu *vcpu)
 	 * If the timer expired because KVM used it to force an immediate exit,
 	 * then mission accomplished.
 	 */
-	if (vmx->req_immediate_exit)
+	if (force_immediate_exit)
 		return EXIT_FASTPATH_EXIT_HANDLED;
 
 	/*
@@ -7210,13 +7211,13 @@ static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
 					msrs[i].host, false);
 }
 
-static void vmx_update_hv_timer(struct kvm_vcpu *vcpu)
+static void vmx_update_hv_timer(struct kvm_vcpu *vcpu, bool force_immediate_exit)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	u64 tscl;
 	u32 delta_tsc;
 
-	if (vmx->req_immediate_exit) {
+	if (force_immediate_exit) {
 		vmcs_write32(VMX_PREEMPTION_TIMER_VALUE, 0);
 		vmx->loaded_vmcs->hv_timer_soft_disabled = false;
 	} else if (vmx->hv_deadline_tsc != -1) {
@@ -7269,7 +7270,8 @@ void noinstr vmx_spec_ctrl_restore_host(struct vcpu_vmx *vmx,
 	barrier_nospec();
 }
 
-static fastpath_t vmx_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
+static fastpath_t vmx_exit_handlers_fastpath(struct kvm_vcpu *vcpu,
+					     bool force_immediate_exit)
 {
 	/*
 	 * If L2 is active, some VMX preemption timer exits can be handled in
@@ -7283,7 +7285,7 @@ static fastpath_t vmx_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
 	case EXIT_REASON_MSR_WRITE:
 		return handle_fastpath_set_msr_irqoff(vcpu);
 	case EXIT_REASON_PREEMPTION_TIMER:
-		return handle_fastpath_preemption_timer(vcpu);
+		return handle_fastpath_preemption_timer(vcpu, force_immediate_exit);
 	default:
 		return EXIT_FASTPATH_NONE;
 	}
@@ -7425,7 +7427,9 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
 		vmx_passthrough_lbr_msrs(vcpu);
 
 	if (enable_preemption_timer)
-		vmx_update_hv_timer(vcpu);
+		vmx_update_hv_timer(vcpu, force_immediate_exit);
+	else if (force_immediate_exit)
+		smp_send_reschedule(vcpu->cpu);
 
 	kvm_wait_lapic_expire(vcpu);
 
@@ -7489,7 +7493,7 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
 	vmx_recover_nmi_blocking(vmx);
 	vmx_complete_interrupts(vmx);
 
-	return vmx_exit_handlers_fastpath(vcpu);
+	return vmx_exit_handlers_fastpath(vcpu, force_immediate_exit);
 }
 
 static void vmx_vcpu_free(struct kvm_vcpu *vcpu)
@@ -7988,11 +7992,6 @@ static __init void vmx_set_cpu_caps(void)
 		kvm_cpu_cap_check_and_set(X86_FEATURE_WAITPKG);
 }
 
-static void vmx_request_immediate_exit(struct kvm_vcpu *vcpu)
-{
-	to_vmx(vcpu)->req_immediate_exit = true;
-}
-
 static int vmx_check_intercept_io(struct kvm_vcpu *vcpu,
 				  struct x86_instruction_info *info)
 {
@@ -8404,8 +8403,6 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.check_intercept = vmx_check_intercept,
 	.handle_exit_irqoff = vmx_handle_exit_irqoff,
 
-	.request_immediate_exit = vmx_request_immediate_exit,
-
 	.sched_in = vmx_sched_in,
 
 	.cpu_dirty_log_size = PML_ENTITY_NUM,
@@ -8663,7 +8660,6 @@ static __init int hardware_setup(void)
 	if (!enable_preemption_timer) {
 		vmx_x86_ops.set_hv_timer = NULL;
 		vmx_x86_ops.cancel_hv_timer = NULL;
-		vmx_x86_ops.request_immediate_exit = __kvm_request_immediate_exit;
 	}
 
 	kvm_caps.supported_mce_cap |= MCG_LMCE_P;
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index fb36bde2dd87..50d32d830890 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -331,8 +331,6 @@ struct vcpu_vmx {
 	unsigned int ple_window;
 	bool ple_window_dirty;
 
-	bool req_immediate_exit;
-
 	/* Support for PML */
 #define PML_ENTITY_NUM		512
 	struct page *pml_pg;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8a7a6cf4b4ec..44784ad244c6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10505,12 +10505,6 @@ static void kvm_vcpu_reload_apic_access_page(struct kvm_vcpu *vcpu)
 	static_call_cond(kvm_x86_set_apic_access_page_addr)(vcpu);
 }
 
-void __kvm_request_immediate_exit(struct kvm_vcpu *vcpu)
-{
-	smp_send_reschedule(vcpu->cpu);
-}
-EXPORT_SYMBOL_GPL(__kvm_request_immediate_exit);
-
 /*
  * Called within kvm->srcu read side.
  * Returns 1 to let vcpu_run() continue the guest execution loop without
@@ -10756,10 +10750,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		goto cancel_injection;
 	}
 
-	if (req_immediate_exit) {
+	if (req_immediate_exit)
 		kvm_make_request(KVM_REQ_EVENT, vcpu);
-		static_call(kvm_x86_request_immediate_exit)(vcpu);
-	}
 
 	fpregs_assert_state_consistent();
 	if (test_thread_flag(TIF_NEED_FPU_LOAD))
-- 
2.51.0.rc1.163.g2494970778-goog


