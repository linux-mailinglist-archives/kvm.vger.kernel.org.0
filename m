Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0A704D22B7
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 21:35:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350258AbiCHUfx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 15:35:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344401AbiCHUfw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 15:35:52 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4815848385
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 12:34:54 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id mg21-20020a17090b371500b001bef9e4657cso3287309pjb.0
        for <kvm@vger.kernel.org>; Tue, 08 Mar 2022 12:34:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=osjEu/BzQjlMgIynCXPifURSKARPlb6CcHwdOG0TASU=;
        b=rSi8eUgt5HjmDltnAVBs+TcNHyne2FZzqLvIx+y7nmvqStEp6BdD+zeusVa0Z7NIOL
         grArvEwdeD3d5y07nZKqV8p+kwSvkmX1c/1ngs3Y5pLieAEDr5tbqK9vhuKWVtpcCldc
         4JZYvasPEB4oHZ2UBZLSGWtDaOgnitLa4/zu64kYgwAtd0g0FIaPGrjBzLphTceHFMoD
         bl50LXYgQbppvOlqWBYZbK6mVR83yWrZ0VahR+EJuRgCSc+mT8Y6ihhqI1uaxjyp9FKf
         svJLoZa6Rk2UkX1jUXKH919T2bLdLFsH3BGG/Q99+omj4WcCV4G7PUoslCCUWrgCSmS2
         4Llw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=osjEu/BzQjlMgIynCXPifURSKARPlb6CcHwdOG0TASU=;
        b=kO+Lv50ofq+Ay65DprxY1haIa35PiP2ZifjQDAKr4Qqe6mZeYf2CEEB3oX+tyQrtu8
         KQD2vOgOdoOv/QDUV8vlheTgHhCz/1BJhOU5ekCLHxkO+P7j+O3AZ9zN6UWf2rYLmAuk
         kcC+3QC3ssbcFcZc7YZx2M3I2+ofeETB7xHR9EV+4RJH4dWjyrUQJhq/GJs/IazMSDRW
         y2szY4aOdevbTHuClJVNeMQnCN3JKLep/qwsWu97rWUthHCqic+k0LWD+Q9D14L5pY8e
         13uW4hmTrp19ti9ZQAWZIOVN+eA0ZiXigU4MM528LboUAPipePoujP3ml0xgYctRmRN6
         tgtQ==
X-Gm-Message-State: AOAM533UY5rwwnFSWxTGDKlEPHPrFOBEzVbYvsNzg3SZb4QG7sKSY50E
        mU8okdJG7k2DatF7kmixp0tkkA==
X-Google-Smtp-Source: ABdhPJyE5IcAOAHabCX2EwwigAkNWylbCiTy41Q2s8ug0zdsv3HojecbYVakGoAVIq9yFWxBxue4Hw==
X-Received: by 2002:a17:90a:cce:b0:1bf:6387:30d9 with SMTP id 14-20020a17090a0cce00b001bf638730d9mr6765495pjt.196.1646771693437;
        Tue, 08 Mar 2022 12:34:53 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id c18-20020a056a000ad200b004cdccd3da08sm21393384pfl.44.2022.03.08.12.34.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 12:34:52 -0800 (PST)
Date:   Tue, 8 Mar 2022 20:34:49 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        dmatlack@google.com
Subject: Re: [PATCH v2 06/25] KVM: nVMX/nSVM: do not monkey-patch
 inject_page_fault callback
Message-ID: <Yie96ZqK8NYBOMYm@google.com>
References: <20220221162243.683208-1-pbonzini@redhat.com>
 <20220221162243.683208-7-pbonzini@redhat.com>
 <YieOvca6qbCDgrMl@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YieOvca6qbCDgrMl@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 08, 2022, Sean Christopherson wrote:
> On Mon, Feb 21, 2022, Paolo Bonzini wrote:
> > Currently, vendor code is patching the inject_page_fault and later, on
> > vmexit, expecting kvm_init_mmu to restore the inject_page_fault callback.
> > 
> > This is brittle, as exposed by the fact that SVM KVM_SET_NESTED_STATE
> > forgets to do it.  Instead, do the check at the time a page fault actually
> > has to be injected.  This does incur the cost of an extra retpoline
> > for nested vmexits when TDP is disabled, but is overall much cleaner.
> > While at it, add a comment that explains why the different behavior
> > is needed in this case.
> > 
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > ---
> 
> If I have NAK powers, NAK NAK NAK NAK NAK :-)
> 
> Forcing a VM-Exit is a hack, e.g. it's the entire reason inject_emulated_exception()
> returns a bool.  Even worse, it's confusing and misleading due to being incomplete.
> 
> The need hack for the hack is not unique to !tdp_enabled, the #DF can be triggered
> any time L0 is intercepting #PF.  Hello, allow_smaller_maxphyaddr.
> 
> And while I think allow_smaller_maxphyaddr should be burned with fire, architecturally
> it's still incomplete.  Any exception that is injected by KVM needs to be subjected
> to nested interception checks, not just #PF.  E.g. a #GP while vectoring a different
> fault should also be routed to L1.  KVM (mostly) gets away with special casing #PF
> because that's the only common scenario where L1 wants to intercept _and fix_ a fault
> that can occur while vectoring an exception.  E.g. in the #GP => #DF case, odds are
> very good that L1 will inject a #DF too, but that doesn't make KVM's behavior correct.
> 
> I have a series to handle this by performing the interception checks when an exception
> is queued, instead of when KVM injects the excepiton, and using a second kvm_queued_exception
> field to track exceptions that are queued for VM-Exit (so as not to lose the injected
> exception, which needs to be saved into vmc*12.  It's functional, though I haven't
> tested migration (requires minor shenanigans to perform interception checks for pending
> exceptions coming in from userspace).

Here's my preferred band-aid for this so we can make inject_page_fault() constant
without having to wait for a proper fix.  It's still putting lipstick on a pig,
but is a bit more complete and IMO better documents the mess.  This slots into
your series in place of your patch without much fuss.


From: Sean Christopherson <seanjc@google.com>
Date: Thu, 3 Mar 2022 20:20:17 -0800
Subject: [PATCH] KVM: x86: Clean up and document nested #PF workaround

Replace the per-vendor hack-a-fix for KVM's #PF => #PF => #DF workaround
with an explicit, common workaround in kvm_inject_emulated_page_fault().
Aside from being a hack, the current approach is brittle and incomplete,
e.g. nSVM's KVM_SET_NESTED_STATE fails to set ->inject_page_fault(),
and nVMX fails to apply the workaround when VMX is intercepting #PF due
to allow_smaller_maxphyaddr=1.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/svm/nested.c       | 15 ++++++++-------
 arch/x86/kvm/vmx/nested.c       | 15 ++++++---------
 arch/x86/kvm/x86.c              | 21 ++++++++++++++++++++-
 4 files changed, 36 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index da2f3a21e37b..c372a74acd9c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1496,6 +1496,8 @@ struct kvm_x86_ops {
 struct kvm_x86_nested_ops {
 	void (*leave_nested)(struct kvm_vcpu *vcpu);
 	int (*check_events)(struct kvm_vcpu *vcpu);
+	int (*handle_page_fault_workaround)(struct kvm_vcpu *vcpu,
+					    struct x86_exception *fault);
 	bool (*hv_timer_pending)(struct kvm_vcpu *vcpu);
 	void (*triple_fault)(struct kvm_vcpu *vcpu);
 	int (*get_state)(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 96bab464967f..dd942c719cf6 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -54,22 +54,25 @@ static void nested_svm_inject_npf_exit(struct kvm_vcpu *vcpu,
 	nested_svm_vmexit(svm);
 }

-static void svm_inject_page_fault_nested(struct kvm_vcpu *vcpu, struct x86_exception *fault)
+static int nested_svm_handle_page_fault_workaround(struct kvm_vcpu *vcpu,
+						   struct x86_exception *fault)
 {
        struct vcpu_svm *svm = to_svm(vcpu);
+
        WARN_ON(!is_guest_mode(vcpu));

 	if (vmcb12_is_intercept(&svm->nested.ctl,
 				INTERCEPT_EXCEPTION_OFFSET + PF_VECTOR) &&
-	    !svm->nested.nested_run_pending) {
+	    !WARN_ON_ONCE(svm->nested.nested_run_pending)) {
                svm->vmcb->control.exit_code = SVM_EXIT_EXCP_BASE + PF_VECTOR;
                svm->vmcb->control.exit_code_hi = 0;
                svm->vmcb->control.exit_info_1 = fault->error_code;
                svm->vmcb->control.exit_info_2 = fault->address;
                nested_svm_vmexit(svm);
-       } else {
-               kvm_inject_page_fault(vcpu, fault);
+	       return 0;
        }
+
+	return -EINVAL;
 }

 static u64 nested_svm_get_tdp_pdptr(struct kvm_vcpu *vcpu, int index)
@@ -680,9 +683,6 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
 	if (ret)
 		return ret;

-	if (!npt_enabled)
-		vcpu->arch.mmu->inject_page_fault = svm_inject_page_fault_nested;
-
 	if (!from_vmrun)
 		kvm_make_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);

@@ -1567,6 +1567,7 @@ static bool svm_get_nested_state_pages(struct kvm_vcpu *vcpu)
 struct kvm_x86_nested_ops svm_nested_ops = {
 	.leave_nested = svm_leave_nested,
 	.check_events = svm_check_nested_events,
+	.handle_page_fault_workaround = nested_svm_handle_page_fault_workaround,
 	.triple_fault = nested_svm_triple_fault,
 	.get_nested_state_pages = svm_get_nested_state_pages,
 	.get_state = svm_get_nested_state,
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index f18744f7ff82..cc4c74339d35 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -476,24 +476,23 @@ static int nested_vmx_check_exception(struct kvm_vcpu *vcpu, unsigned long *exit
 	return 0;
 }

-
-static void vmx_inject_page_fault_nested(struct kvm_vcpu *vcpu,
-		struct x86_exception *fault)
+static int nested_vmx_handle_page_fault_workaround(struct kvm_vcpu *vcpu,
+						   struct x86_exception *fault)
 {
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);

 	WARN_ON(!is_guest_mode(vcpu));

 	if (nested_vmx_is_page_fault_vmexit(vmcs12, fault->error_code) &&
-		!to_vmx(vcpu)->nested.nested_run_pending) {
+	    !WARN_ON_ONCE(to_vmx(vcpu)->nested.nested_run_pending)) {
 		vmcs12->vm_exit_intr_error_code = fault->error_code;
 		nested_vmx_vmexit(vcpu, EXIT_REASON_EXCEPTION_NMI,
 				  PF_VECTOR | INTR_TYPE_HARD_EXCEPTION |
 				  INTR_INFO_DELIVER_CODE_MASK | INTR_INFO_VALID_MASK,
 				  fault->address);
-	} else {
-		kvm_inject_page_fault(vcpu, fault);
+		return 0;
 	}
+	return -EINVAL;
 }

 static int nested_vmx_check_io_bitmap_controls(struct kvm_vcpu *vcpu,
@@ -2614,9 +2613,6 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 		vmcs_write64(GUEST_PDPTR3, vmcs12->guest_pdptr3);
 	}

-	if (!enable_ept)
-		vcpu->arch.walk_mmu->inject_page_fault = vmx_inject_page_fault_nested;
-
 	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL) &&
 	    WARN_ON_ONCE(kvm_set_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL,
 				     vmcs12->guest_ia32_perf_global_ctrl))) {
@@ -6804,6 +6800,7 @@ __init int nested_vmx_hardware_setup(int (*exit_handlers[])(struct kvm_vcpu *))
 struct kvm_x86_nested_ops vmx_nested_ops = {
 	.leave_nested = vmx_leave_nested,
 	.check_events = vmx_check_nested_events,
+	.handle_page_fault_workaround = nested_vmx_handle_page_fault_workaround,
 	.hv_timer_pending = nested_vmx_preemption_timer_pending,
 	.triple_fault = nested_vmx_triple_fault,
 	.get_state = vmx_get_nested_state,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7fa1bdd9909e..010fb54a9a82 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -748,6 +748,7 @@ void kvm_inject_page_fault(struct kvm_vcpu *vcpu, struct x86_exception *fault)
 }
 EXPORT_SYMBOL_GPL(kvm_inject_page_fault);

+/* Returns true if the page fault was immediately morphed into a VM-Exit. */
 bool kvm_inject_emulated_page_fault(struct kvm_vcpu *vcpu,
 				    struct x86_exception *fault)
 {
@@ -766,8 +767,26 @@ bool kvm_inject_emulated_page_fault(struct kvm_vcpu *vcpu,
 		kvm_mmu_invalidate_gva(vcpu, fault_mmu, fault->address,
 				       fault_mmu->root.hpa);

+	/*
+	 * A workaround for KVM's bad exception handling.  If KVM injected an
+	 * exception into L2, and L2 encountered a #PF while vectoring the
+	 * injected exception, manually check to see if L1 wants to intercept
+	 * #PF, otherwise queuing the #PF will lead to #DF or a lost exception.
+	 * In all other cases, defer the check to nested_ops->check_events(),
+	 * which will correctly handle priority (this does not).  Note, other
+	 * exceptions, e.g. #GP, are theoretically affected, #PF is simply the
+	 * most problematic, e.g. when L0 and L1 are both intercepting #PF for
+	 * shadow paging.
+	 *
+	 * TODO: Rewrite exception handling to track injected and pending
+	 *       (VM-Exit) exceptions separately.
+	 */
+	if (unlikely(vcpu->arch.exception.injected && is_guest_mode(vcpu)) &&
+	    !kvm_x86_ops.nested_ops->handle_page_fault_workaround(vcpu, fault))
+		return true;
+
 	fault_mmu->inject_page_fault(vcpu, fault);
-	return fault->nested_page_fault;
+	return false;
 }
 EXPORT_SYMBOL_GPL(kvm_inject_emulated_page_fault);


base-commit: bb92fb66dcf8735c5190f415fed587bff7dd6717
--

