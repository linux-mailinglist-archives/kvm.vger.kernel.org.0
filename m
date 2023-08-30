Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E352A78D922
	for <lists+kvm@lfdr.de>; Wed, 30 Aug 2023 20:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231538AbjH3Sc1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Aug 2023 14:32:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244194AbjH3Mnp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Aug 2023 08:43:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92424193
        for <kvm@vger.kernel.org>; Wed, 30 Aug 2023 05:42:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693399375;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JSiaWd3XTuuzrZMx0m5UZPazKAadIjf8HRjOqCLLZZ8=;
        b=aVed3lDRnj77wzN4y+cqVubJKgCePg5ANVumUeKzQ8wEbExErNvjfx7zanpdAIPE/xS8ng
        mJeKoZk4lP7sB4pQrJHETCser/bOPZmY+3vHsSyT7XSz0/dA1PlJSuBlMYMo9Wd8WZPrh1
        2hD0wj77lrtKlymwk5982Cz3Hc5+mew=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-86-2BVjFtiyPIK734y9nBcB9w-1; Wed, 30 Aug 2023 08:42:51 -0400
X-MC-Unique: 2BVjFtiyPIK734y9nBcB9w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DEFAE1C0E4C1;
        Wed, 30 Aug 2023 12:42:50 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.45.224.27])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4B1282026D35;
        Wed, 30 Aug 2023 12:42:48 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 1/4] KVM: x86: refactor req_immediate_exit logic
Date:   Wed, 30 Aug 2023 15:42:40 +0300
Message-Id: <20230830124243.671152-2-mlevitsk@redhat.com>
In-Reply-To: <20230830124243.671152-1-mlevitsk@redhat.com>
References: <20230830124243.671152-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

- move req_immediate_exit variable from arch specific to common code.
- remove arch specific callback .request_immediate_exit and move the code
  down to the arch's vcpu_run's code.

No functional change is intended.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 -
 arch/x86/include/asm/kvm_host.h    |  5 ++---
 arch/x86/kvm/svm/svm.c             |  5 +++--
 arch/x86/kvm/vmx/vmx.c             | 18 ++++++-----------
 arch/x86/kvm/vmx/vmx.h             |  2 --
 arch/x86/kvm/x86.c                 | 31 +++++++++++-------------------
 6 files changed, 22 insertions(+), 40 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index e3054e3e46d52d..f654a7f4cc8c0c 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -101,7 +101,6 @@ KVM_X86_OP(write_tsc_multiplier)
 KVM_X86_OP(get_exit_info)
 KVM_X86_OP(check_intercept)
 KVM_X86_OP(handle_exit_irqoff)
-KVM_X86_OP(request_immediate_exit)
 KVM_X86_OP(sched_in)
 KVM_X86_OP_OPTIONAL(update_cpu_dirty_logging)
 KVM_X86_OP_OPTIONAL(vcpu_blocking)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3bc146dfd38da5..5f2a93f92a3df7 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -993,6 +993,8 @@ struct kvm_vcpu_arch {
 	 */
 	bool pdptrs_from_userspace;
 
+	bool req_immediate_exit;
+
 #if IS_ENABLED(CONFIG_HYPERV)
 	hpa_t hv_root_tdp;
 #endif
@@ -1672,8 +1674,6 @@ struct kvm_x86_ops {
 			       struct x86_exception *exception);
 	void (*handle_exit_irqoff)(struct kvm_vcpu *vcpu);
 
-	void (*request_immediate_exit)(struct kvm_vcpu *vcpu);
-
 	void (*sched_in)(struct kvm_vcpu *kvm, int cpu);
 
 	/*
@@ -2157,7 +2157,6 @@ extern bool kvm_find_async_pf_gfn(struct kvm_vcpu *vcpu, gfn_t gfn);
 
 int kvm_skip_emulated_instruction(struct kvm_vcpu *vcpu);
 int kvm_complete_insn_gp(struct kvm_vcpu *vcpu, int err);
-void __kvm_request_immediate_exit(struct kvm_vcpu *vcpu);
 
 void __user *__x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa,
 				     u32 size);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 956726d867aafc..18d0895975dfd8 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4063,6 +4063,9 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 	clgi();
 	kvm_load_guest_xsave_state(vcpu);
 
+	if (vcpu->arch.req_immediate_exit)
+		smp_send_reschedule(vcpu->cpu);
+
 	kvm_wait_lapic_expire(vcpu);
 
 	/*
@@ -4878,8 +4881,6 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.check_intercept = svm_check_intercept,
 	.handle_exit_irqoff = svm_handle_exit_irqoff,
 
-	.request_immediate_exit = __kvm_request_immediate_exit,
-
 	.sched_in = svm_sched_in,
 
 	.nested_ops = &svm_nested_ops,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index df461f387e20d4..77ef6f02b3f42f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -68,6 +68,8 @@
 #include "x86.h"
 #include "smm.h"
 
+#include <trace/events/ipi.h>
+
 MODULE_AUTHOR("Qumranet");
 MODULE_LICENSE("GPL");
 
@@ -1274,8 +1276,6 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 	u16 fs_sel, gs_sel;
 	int i;
 
-	vmx->req_immediate_exit = false;
-
 	/*
 	 * Note that guest MSRs to be saved/restored can also be changed
 	 * when guest state is loaded. This happens when guest transitions
@@ -5997,7 +5997,7 @@ static fastpath_t handle_fastpath_preemption_timer(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
-	if (!vmx->req_immediate_exit &&
+	if (!vcpu->arch.req_immediate_exit &&
 	    !unlikely(vmx->loaded_vmcs->hv_timer_soft_disabled)) {
 		kvm_lapic_expired_hv_timer(vcpu);
 		return EXIT_FASTPATH_REENTER_GUEST;
@@ -7153,7 +7153,7 @@ static void vmx_update_hv_timer(struct kvm_vcpu *vcpu)
 	u64 tscl;
 	u32 delta_tsc;
 
-	if (vmx->req_immediate_exit) {
+	if (vcpu->arch.req_immediate_exit) {
 		vmcs_write32(VMX_PREEMPTION_TIMER_VALUE, 0);
 		vmx->loaded_vmcs->hv_timer_soft_disabled = false;
 	} else if (vmx->hv_deadline_tsc != -1) {
@@ -7348,6 +7348,8 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 
 	if (enable_preemption_timer)
 		vmx_update_hv_timer(vcpu);
+	else if (vcpu->arch.req_immediate_exit)
+		smp_send_reschedule(vcpu->cpu);
 
 	kvm_wait_lapic_expire(vcpu);
 
@@ -7892,11 +7894,6 @@ static __init void vmx_set_cpu_caps(void)
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
@@ -8305,8 +8302,6 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.check_intercept = vmx_check_intercept,
 	.handle_exit_irqoff = vmx_handle_exit_irqoff,
 
-	.request_immediate_exit = vmx_request_immediate_exit,
-
 	.sched_in = vmx_sched_in,
 
 	.cpu_dirty_log_size = PML_ENTITY_NUM,
@@ -8564,7 +8559,6 @@ static __init int hardware_setup(void)
 	if (!enable_preemption_timer) {
 		vmx_x86_ops.set_hv_timer = NULL;
 		vmx_x86_ops.cancel_hv_timer = NULL;
-		vmx_x86_ops.request_immediate_exit = __kvm_request_immediate_exit;
 	}
 
 	kvm_caps.supported_mce_cap |= MCG_LMCE_P;
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 32384ba3849949..96c94f69ef8311 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -330,8 +330,6 @@ struct vcpu_vmx {
 	unsigned int ple_window;
 	bool ple_window_dirty;
 
-	bool req_immediate_exit;
-
 	/* Support for PML */
 #define PML_ENTITY_NUM		512
 	struct page *pml_pg;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 278dbd37dab244..53f0a5f493be37 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10052,8 +10052,7 @@ static void kvm_inject_exception(struct kvm_vcpu *vcpu)
  * ordering between that side effect, the instruction completing, _and_ the
  * delivery of the asynchronous event.
  */
-static int kvm_check_and_inject_events(struct kvm_vcpu *vcpu,
-				       bool *req_immediate_exit)
+static int kvm_check_and_inject_events(struct kvm_vcpu *vcpu)
 {
 	bool can_inject;
 	int r;
@@ -10230,8 +10229,9 @@ static int kvm_check_and_inject_events(struct kvm_vcpu *vcpu,
 
 	if (is_guest_mode(vcpu) &&
 	    kvm_x86_ops.nested_ops->has_events &&
-	    kvm_x86_ops.nested_ops->has_events(vcpu))
-		*req_immediate_exit = true;
+	    kvm_x86_ops.nested_ops->has_events(vcpu)) {
+		vcpu->arch.req_immediate_exit = true;
+	}
 
 	/*
 	 * KVM must never queue a new exception while injecting an event; KVM
@@ -10248,10 +10248,9 @@ static int kvm_check_and_inject_events(struct kvm_vcpu *vcpu,
 	WARN_ON_ONCE(vcpu->arch.exception.pending ||
 		     vcpu->arch.exception_vmexit.pending);
 	return 0;
-
 out:
 	if (r == -EBUSY) {
-		*req_immediate_exit = true;
+		vcpu->arch.req_immediate_exit = true;
 		r = 0;
 	}
 	return r;
@@ -10478,12 +10477,6 @@ static void kvm_vcpu_reload_apic_access_page(struct kvm_vcpu *vcpu)
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
@@ -10498,8 +10491,6 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		kvm_cpu_accept_dm_intr(vcpu);
 	fastpath_t exit_fastpath;
 
-	bool req_immediate_exit = false;
-
 	if (kvm_request_pending(vcpu)) {
 		if (kvm_check_request(KVM_REQ_VM_DEAD, vcpu)) {
 			r = -EIO;
@@ -10660,7 +10651,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 			goto out;
 		}
 
-		r = kvm_check_and_inject_events(vcpu, &req_immediate_exit);
+		r = kvm_check_and_inject_events(vcpu);
 		if (r < 0) {
 			r = 0;
 			goto out;
@@ -10729,10 +10720,9 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		goto cancel_injection;
 	}
 
-	if (req_immediate_exit) {
+
+	if (vcpu->arch.req_immediate_exit)
 		kvm_make_request(KVM_REQ_EVENT, vcpu);
-		static_call(kvm_x86_request_immediate_exit)(vcpu);
-	}
 
 	fpregs_assert_state_consistent();
 	if (test_thread_flag(TIF_NEED_FPU_LOAD))
@@ -10764,6 +10754,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 			     (kvm_get_apic_mode(vcpu) != LAPIC_MODE_DISABLED));
 
 		exit_fastpath = static_call(kvm_x86_vcpu_run)(vcpu);
+
 		if (likely(exit_fastpath != EXIT_FASTPATH_REENTER_GUEST))
 			break;
 
@@ -10779,6 +10770,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		++vcpu->stat.exits;
 	}
 
+	vcpu->arch.req_immediate_exit = false;
 	/*
 	 * Do this here before restoring debug registers on the host.  And
 	 * since we do this before handling the vmexit, a DR access vmexit
@@ -10866,8 +10858,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	return r;
 
 cancel_injection:
-	if (req_immediate_exit)
-		kvm_make_request(KVM_REQ_EVENT, vcpu);
+	vcpu->arch.req_immediate_exit = false;
 	static_call(kvm_x86_cancel_injection)(vcpu);
 	if (unlikely(vcpu->arch.apic_attention))
 		kvm_lapic_sync_from_vapic(vcpu);
-- 
2.26.3

