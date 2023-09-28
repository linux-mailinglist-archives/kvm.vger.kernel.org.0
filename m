Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56AFA7B1853
	for <lists+kvm@lfdr.de>; Thu, 28 Sep 2023 12:37:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231304AbjI1Khi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 06:37:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230517AbjI1Khg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 06:37:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E768191
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 03:36:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695897411;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WV2huBY/GxD4ImPycOVjD/A33F2mmWshbEVS6hcV8NQ=;
        b=N8TpBOecw3viDr65jjCQRPdjBJmIziyd3N8pHEwa+GwePs09aWnPw8jK8nEPJWLwkcX/Op
        mwq6u9fnu3xmansw81ftiwDng1Yo+t6z10AqYNUQiQv03smZuhI0LNnRtJ4iGdMC7edyTx
        grMA10d2E2FVa2wJr5FDat5C5Z+ipKc=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-120-L_SUntkrO7OcY1FZ8H-9DA-1; Thu, 28 Sep 2023 06:36:47 -0400
X-MC-Unique: L_SUntkrO7OcY1FZ8H-9DA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D8D61381459B;
        Thu, 28 Sep 2023 10:36:46 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.45.226.141])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6441B492B16;
        Thu, 28 Sep 2023 10:36:44 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Dave Hansen <dave.hansen@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v3 1/4] KVM: x86: refactor req_immediate_exit logic
Date:   Thu, 28 Sep 2023 13:36:37 +0300
Message-Id: <20230928103640.78453-2-mlevitsk@redhat.com>
In-Reply-To: <20230928103640.78453-1-mlevitsk@redhat.com>
References: <20230928103640.78453-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: *
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
 arch/x86/kvm/x86.c                 | 31 +++++++++++++-----------------
 6 files changed, 24 insertions(+), 38 deletions(-)

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
index 17715cb8731d5d..383a1d0cc0743b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1011,6 +1011,8 @@ struct kvm_vcpu_arch {
 	 */
 	bool pdptrs_from_userspace;
 
+	bool req_immediate_exit;
+
 #if IS_ENABLED(CONFIG_HYPERV)
 	hpa_t hv_root_tdp;
 #endif
@@ -1690,8 +1692,6 @@ struct kvm_x86_ops {
 			       struct x86_exception *exception);
 	void (*handle_exit_irqoff)(struct kvm_vcpu *vcpu);
 
-	void (*request_immediate_exit)(struct kvm_vcpu *vcpu);
-
 	void (*sched_in)(struct kvm_vcpu *kvm, int cpu);
 
 	/*
@@ -2176,7 +2176,6 @@ extern bool kvm_find_async_pf_gfn(struct kvm_vcpu *vcpu, gfn_t gfn);
 
 int kvm_skip_emulated_instruction(struct kvm_vcpu *vcpu);
 int kvm_complete_insn_gp(struct kvm_vcpu *vcpu, int err);
-void __kvm_request_immediate_exit(struct kvm_vcpu *vcpu);
 
 void __user *__x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa,
 				     u32 size);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 9507df93f410a6..60b130b7f9d510 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4176,6 +4176,9 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 	clgi();
 	kvm_load_guest_xsave_state(vcpu);
 
+	if (vcpu->arch.req_immediate_exit)
+		smp_send_reschedule(vcpu->cpu);
+
 	kvm_wait_lapic_expire(vcpu);
 
 	/*
@@ -5004,8 +5007,6 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.check_intercept = svm_check_intercept,
 	.handle_exit_irqoff = svm_handle_exit_irqoff,
 
-	.request_immediate_exit = __kvm_request_immediate_exit,
-
 	.sched_in = svm_sched_in,
 
 	.nested_ops = &svm_nested_ops,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 72e3943f36935c..eb7e42235e8811 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -67,6 +67,8 @@
 #include "x86.h"
 #include "smm.h"
 
+#include <trace/events/ipi.h>
+
 MODULE_AUTHOR("Qumranet");
 MODULE_LICENSE("GPL");
 
@@ -1288,8 +1290,6 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 	u16 fs_sel, gs_sel;
 	int i;
 
-	vmx->req_immediate_exit = false;
-
 	/*
 	 * Note that guest MSRs to be saved/restored can also be changed
 	 * when guest state is loaded. This happens when guest transitions
@@ -5996,7 +5996,7 @@ static fastpath_t handle_fastpath_preemption_timer(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
-	if (!vmx->req_immediate_exit &&
+	if (!vcpu->arch.req_immediate_exit &&
 	    !unlikely(vmx->loaded_vmcs->hv_timer_soft_disabled)) {
 		kvm_lapic_expired_hv_timer(vcpu);
 		return EXIT_FASTPATH_REENTER_GUEST;
@@ -7154,7 +7154,7 @@ static void vmx_update_hv_timer(struct kvm_vcpu *vcpu)
 	u64 tscl;
 	u32 delta_tsc;
 
-	if (vmx->req_immediate_exit) {
+	if (vcpu->arch.req_immediate_exit) {
 		vmcs_write32(VMX_PREEMPTION_TIMER_VALUE, 0);
 		vmx->loaded_vmcs->hv_timer_soft_disabled = false;
 	} else if (vmx->hv_deadline_tsc != -1) {
@@ -7357,6 +7357,8 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 
 	if (enable_preemption_timer)
 		vmx_update_hv_timer(vcpu);
+	else if (vcpu->arch.req_immediate_exit)
+		smp_send_reschedule(vcpu->cpu);
 
 	kvm_wait_lapic_expire(vcpu);
 
@@ -7902,11 +7904,6 @@ static __init void vmx_set_cpu_caps(void)
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
@@ -8315,8 +8312,6 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.check_intercept = vmx_check_intercept,
 	.handle_exit_irqoff = vmx_handle_exit_irqoff,
 
-	.request_immediate_exit = vmx_request_immediate_exit,
-
 	.sched_in = vmx_sched_in,
 
 	.cpu_dirty_log_size = PML_ENTITY_NUM,
@@ -8574,7 +8569,6 @@ static __init int hardware_setup(void)
 	if (!enable_preemption_timer) {
 		vmx_x86_ops.set_hv_timer = NULL;
 		vmx_x86_ops.cancel_hv_timer = NULL;
-		vmx_x86_ops.request_immediate_exit = __kvm_request_immediate_exit;
 	}
 
 	kvm_caps.supported_mce_cap |= MCG_LMCE_P;
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index c2130d2c8e24bb..4dabd16a3d7180 100644
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
index 9f18b06bbda66b..dfb7d25ed94f26 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10049,8 +10049,7 @@ static void kvm_inject_exception(struct kvm_vcpu *vcpu)
  * ordering between that side effect, the instruction completing, _and_ the
  * delivery of the asynchronous event.
  */
-static int kvm_check_and_inject_events(struct kvm_vcpu *vcpu,
-				       bool *req_immediate_exit)
+static int kvm_check_and_inject_events(struct kvm_vcpu *vcpu)
 {
 	bool can_inject;
 	int r;
@@ -10227,8 +10226,9 @@ static int kvm_check_and_inject_events(struct kvm_vcpu *vcpu,
 
 	if (is_guest_mode(vcpu) &&
 	    kvm_x86_ops.nested_ops->has_events &&
-	    kvm_x86_ops.nested_ops->has_events(vcpu))
-		*req_immediate_exit = true;
+	    kvm_x86_ops.nested_ops->has_events(vcpu)) {
+		vcpu->arch.req_immediate_exit = true;
+	}
 
 	/*
 	 * KVM must never queue a new exception while injecting an event; KVM
@@ -10245,10 +10245,9 @@ static int kvm_check_and_inject_events(struct kvm_vcpu *vcpu,
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
@@ -10475,12 +10474,6 @@ static void kvm_vcpu_reload_apic_access_page(struct kvm_vcpu *vcpu)
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
@@ -10495,7 +10488,6 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		kvm_cpu_accept_dm_intr(vcpu);
 	fastpath_t exit_fastpath;
 
-	bool req_immediate_exit = false;
 
 	if (kvm_request_pending(vcpu)) {
 		if (kvm_check_request(KVM_REQ_VM_DEAD, vcpu)) {
@@ -10657,7 +10649,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 			goto out;
 		}
 
-		r = kvm_check_and_inject_events(vcpu, &req_immediate_exit);
+		r = kvm_check_and_inject_events(vcpu);
 		if (r < 0) {
 			r = 0;
 			goto out;
@@ -10726,10 +10718,9 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
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
@@ -10761,6 +10752,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 			     (kvm_get_apic_mode(vcpu) != LAPIC_MODE_DISABLED));
 
 		exit_fastpath = static_call(kvm_x86_vcpu_run)(vcpu);
+
 		if (likely(exit_fastpath != EXIT_FASTPATH_REENTER_GUEST))
 			break;
 
@@ -10776,6 +10768,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		++vcpu->stat.exits;
 	}
 
+	vcpu->arch.req_immediate_exit = false;
 	/*
 	 * Do this here before restoring debug registers on the host.  And
 	 * since we do this before handling the vmexit, a DR access vmexit
@@ -10863,8 +10856,10 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	return r;
 
 cancel_injection:
-	if (req_immediate_exit)
+	if (vcpu->arch.req_immediate_exit) {
+		vcpu->arch.req_immediate_exit = false;
 		kvm_make_request(KVM_REQ_EVENT, vcpu);
+	}
 	static_call(kvm_x86_cancel_injection)(vcpu);
 	if (unlikely(vcpu->arch.apic_attention))
 		kvm_lapic_sync_from_vapic(vcpu);
-- 
2.26.3

