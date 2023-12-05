Return-Path: <kvm+bounces-3500-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D1FD8050AD
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 11:39:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B56A2281860
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 10:39:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACD9F58ADC;
	Tue,  5 Dec 2023 10:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z2/TDP/W"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03F531BE5
	for <kvm@vger.kernel.org>; Tue,  5 Dec 2023 02:37:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701772674;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WhrltLpYpRfruoeHLu41cyXbAA0zn8v5CL/MVSEdybo=;
	b=Z2/TDP/Wk0clI6FI7hS7cE6Qfto/S/Pfu7+elUIz44HLyLuvtMvqRjJp4egXb0F3lPl5Xs
	tSgfNu+rrptKUuX8t7XX7j5KjbrLGJeAwrLzpYMGr5M+3EJdHnjlPv+6jUp//oTilR9IHx
	UAMWLWhzgPEsFop53CzYs4OWPAWs6cg=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-394-_2FxBfz2Pg2Q_Bkz_mhF6A-1; Tue,
 05 Dec 2023 05:37:52 -0500
X-MC-Unique: _2FxBfz2Pg2Q_Bkz_mhF6A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 01DA938135E0;
	Tue,  5 Dec 2023 10:37:52 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.45.225.152])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 614D0C15A0C;
	Tue,  5 Dec 2023 10:37:49 +0000 (UTC)
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v4 1/4] KVM: x86: refactor req_immediate_exit logic
Date: Tue,  5 Dec 2023 12:37:42 +0200
Message-Id: <20231205103745.506724-2-mlevitsk@redhat.com>
In-Reply-To: <20231205103745.506724-1-mlevitsk@redhat.com>
References: <20231205103745.506724-1-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

- move req_immediate_exit variable from arch specific to common code.
- remove arch specific callback .request_immediate_exit and move the code
  down to the arch's vcpu_run's code.

No functional change is intended.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 -
 arch/x86/include/asm/kvm_host.h    |  5 ++---
 arch/x86/kvm/svm/svm.c             |  7 ++++---
 arch/x86/kvm/vmx/vmx.c             | 18 ++++++-----------
 arch/x86/kvm/vmx/vmx.h             |  2 --
 arch/x86/kvm/x86.c                 | 31 +++++++++++++-----------------
 6 files changed, 25 insertions(+), 39 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 26b628d84594b93..3aeb7c669a0b09b 100644
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
index d7036982332e33d..044b4f9265c5427 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1021,6 +1021,8 @@ struct kvm_vcpu_arch {
 	 */
 	bool pdptrs_from_userspace;
 
+	bool req_immediate_exit;
+
 #if IS_ENABLED(CONFIG_HYPERV)
 	hpa_t hv_root_tdp;
 #endif
@@ -1700,8 +1702,6 @@ struct kvm_x86_ops {
 			       struct x86_exception *exception);
 	void (*handle_exit_irqoff)(struct kvm_vcpu *vcpu);
 
-	void (*request_immediate_exit)(struct kvm_vcpu *vcpu);
-
 	void (*sched_in)(struct kvm_vcpu *vcpu, int cpu);
 
 	/*
@@ -2187,7 +2187,6 @@ extern bool kvm_find_async_pf_gfn(struct kvm_vcpu *vcpu, gfn_t gfn);
 
 int kvm_skip_emulated_instruction(struct kvm_vcpu *vcpu);
 int kvm_complete_insn_gp(struct kvm_vcpu *vcpu, int err);
-void __kvm_request_immediate_exit(struct kvm_vcpu *vcpu);
 
 void __user *__x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa,
 				     u32 size);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 1855a6d7c976ad2..d2c6ff9036009dd 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4137,9 +4137,12 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 		 * is enough to force an immediate vmexit.
 		 */
 		disable_nmi_singlestep(svm);
-		smp_send_reschedule(vcpu->cpu);
+		vcpu->arch.req_immediate_exit = true;
 	}
 
+	if (vcpu->arch.req_immediate_exit)
+		smp_send_reschedule(vcpu->cpu);
+
 	pre_svm_run(vcpu);
 
 	sync_lapic_to_cr8(vcpu);
@@ -4995,8 +4998,6 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.check_intercept = svm_check_intercept,
 	.handle_exit_irqoff = svm_handle_exit_irqoff,
 
-	.request_immediate_exit = __kvm_request_immediate_exit,
-
 	.sched_in = svm_sched_in,
 
 	.nested_ops = &svm_nested_ops,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index be20a60047b1f29..b8fa16f9e621878 100644
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
 
@@ -7899,11 +7901,6 @@ static __init void vmx_set_cpu_caps(void)
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
@@ -8312,8 +8309,6 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.check_intercept = vmx_check_intercept,
 	.handle_exit_irqoff = vmx_handle_exit_irqoff,
 
-	.request_immediate_exit = vmx_request_immediate_exit,
-
 	.sched_in = vmx_sched_in,
 
 	.cpu_dirty_log_size = PML_ENTITY_NUM,
@@ -8571,7 +8566,6 @@ static __init int hardware_setup(void)
 	if (!enable_preemption_timer) {
 		vmx_x86_ops.set_hv_timer = NULL;
 		vmx_x86_ops.cancel_hv_timer = NULL;
-		vmx_x86_ops.request_immediate_exit = __kvm_request_immediate_exit;
 	}
 
 	kvm_caps.supported_mce_cap |= MCG_LMCE_P;
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index c2130d2c8e24bb5..4dabd16a3d7180e 100644
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
index 2c924075f6f112a..2089a0b08ce08c0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10179,8 +10179,7 @@ static void kvm_inject_exception(struct kvm_vcpu *vcpu)
  * ordering between that side effect, the instruction completing, _and_ the
  * delivery of the asynchronous event.
  */
-static int kvm_check_and_inject_events(struct kvm_vcpu *vcpu,
-				       bool *req_immediate_exit)
+static int kvm_check_and_inject_events(struct kvm_vcpu *vcpu)
 {
 	bool can_inject;
 	int r;
@@ -10357,8 +10356,9 @@ static int kvm_check_and_inject_events(struct kvm_vcpu *vcpu,
 
 	if (is_guest_mode(vcpu) &&
 	    kvm_x86_ops.nested_ops->has_events &&
-	    kvm_x86_ops.nested_ops->has_events(vcpu))
-		*req_immediate_exit = true;
+	    kvm_x86_ops.nested_ops->has_events(vcpu)) {
+		vcpu->arch.req_immediate_exit = true;
+	}
 
 	/*
 	 * KVM must never queue a new exception while injecting an event; KVM
@@ -10375,10 +10375,9 @@ static int kvm_check_and_inject_events(struct kvm_vcpu *vcpu,
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
@@ -10605,12 +10604,6 @@ static void kvm_vcpu_reload_apic_access_page(struct kvm_vcpu *vcpu)
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
@@ -10625,7 +10618,6 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		kvm_cpu_accept_dm_intr(vcpu);
 	fastpath_t exit_fastpath;
 
-	bool req_immediate_exit = false;
 
 	if (kvm_request_pending(vcpu)) {
 		if (kvm_check_request(KVM_REQ_VM_DEAD, vcpu)) {
@@ -10787,7 +10779,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 			goto out;
 		}
 
-		r = kvm_check_and_inject_events(vcpu, &req_immediate_exit);
+		r = kvm_check_and_inject_events(vcpu);
 		if (r < 0) {
 			r = 0;
 			goto out;
@@ -10856,10 +10848,9 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
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
@@ -10891,6 +10882,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 			     (kvm_get_apic_mode(vcpu) != LAPIC_MODE_DISABLED));
 
 		exit_fastpath = static_call(kvm_x86_vcpu_run)(vcpu);
+
 		if (likely(exit_fastpath != EXIT_FASTPATH_REENTER_GUEST))
 			break;
 
@@ -10906,6 +10898,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		++vcpu->stat.exits;
 	}
 
+	vcpu->arch.req_immediate_exit = false;
 	/*
 	 * Do this here before restoring debug registers on the host.  And
 	 * since we do this before handling the vmexit, a DR access vmexit
@@ -10993,8 +10986,10 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
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


