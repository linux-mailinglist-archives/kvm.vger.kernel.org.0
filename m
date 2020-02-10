Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 480FE1584CD
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2020 22:30:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727414AbgBJVaO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Feb 2020 16:30:14 -0500
Received: from mga05.intel.com ([192.55.52.43]:52938 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727003AbgBJVaO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Feb 2020 16:30:14 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Feb 2020 13:30:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,426,1574150400"; 
   d="scan'208";a="221700921"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga007.jf.intel.com with ESMTP; 10 Feb 2020 13:30:11 -0800
Date:   Mon, 10 Feb 2020 13:30:11 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@amacapital.net>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Laight <David.Laight@aculab.com>
Subject: Re: [PATCH v2 4/6] kvm: vmx: Extend VMX's #AC handding for split
 lock in guest
Message-ID: <20200210213010.GA2510@linux.intel.com>
References: <20200203151608.28053-1-xiaoyao.li@intel.com>
 <20200203151608.28053-5-xiaoyao.li@intel.com>
 <20200203211458.GG19638@linux.intel.com>
 <2b95a6ef-828d-768c-f9c6-2e798485717e@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2b95a6ef-828d-768c-f9c6-2e798485717e@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 04, 2020 at 02:46:14PM +0800, Xiaoyao Li wrote:
> On 2/4/2020 5:14 AM, Sean Christopherson wrote:
> >>diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> >>index c475fa2aaae0..93e3370c5f84 100644
> >>--- a/arch/x86/kvm/vmx/vmx.c
> >>+++ b/arch/x86/kvm/vmx/vmx.c
> >>@@ -4233,6 +4233,8 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> >>  	vmx->msr_ia32_umwait_control = 0;
> >>+	vmx->disable_split_lock_detect = false;
> >>+
> >
> >I see no reason to give special treatment to RESET/INIT, i.e. leave the
> >flag set.  vCPUs are zeroed on allocation.
> 
> So when guest reboots, it doesn't need to reset it to false?

No.  KVM _could_ clear disable_split_lock_detect, but it's not required.
E.g. KVM could periodically clear disable_split_lock_detect irrespective
of RESET/INIT.

> I am not clear about difference between RESET and INIT, so I didn't
> differentiate them into different case with init_event

...

> >>+			kvm_queue_exception_e(vcpu, AC_VECTOR, error_code);
> >>+			return 1;
> >>+		}
> >>+		if (get_split_lock_detect_state() == sld_warn) {
> >>+			pr_warn("kvm: split lock #AC happened in %s [%d]\n",
> >>+				current->comm, current->pid);
> >
> >Set TIF_SLD and the MSR bit, then __switch_to_xtra() will automatically
> >handle writing the MSR when necessary.
> 
> Right, we can do this.
> 
> However, if using TIF_SLD and __switch_to_xtra() to switch MSR bit. Once
> there is a split lock in guest, it set TIF_SLD for the vcpu thread, so it
> loses the capability to find and warn the split locks in the user space
> thread, e.g., QEMU vcpu thread, and also loses the capability to find the
> split lock in KVM.

Finding split locks in KVM is a non-issue, in the (hopefully unlikely) event
KVM ends up with a split lock bug, the odds of the bug being hit *only* 
after a guest also hits a split-lock #AC are tiny.

Userspace is a different question.  My preference would to keep KVM simple
and rely in TIF_SLD.

> If it's not a problem, I agree to use TIF_SLD.
> 
> >Even better would be to export handle_user_split_lock() and call that
> >directly.  The EFLAGS.AC logic in handle_user_split_lock() can be moved out
> >to do_alignment_check() to avoid that complication; arguably that should be
> >done in the initial SLD patch.
> 
> the warning message of handle_user_split_lock() contains the RIP of
> userspace application. If use it here, what RIP should we use? the guest RIP
> of the faulting instruction?

Yes, guest RIP.

> >>+			vmx->disable_split_lock_detect = true;
> >>+			return 1;
> >>+		}
> >>+		/* fall through*/
> >>  	default:
> >>  		kvm_run->exit_reason = KVM_EXIT_EXCEPTION;
> >>  		kvm_run->ex.exception = ex_no;
> >>@@ -6530,6 +6562,11 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
> >>  	 */
> >>  	x86_spec_ctrl_set_guest(vmx->spec_ctrl, 0);
> >>+	if (static_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT) &&
> >>+	    unlikely(vmx->disable_split_lock_detect) &&
> >>+	    !test_tsk_thread_flag(current, TIF_SLD))
> >>+		split_lock_detect_set(false);
> >>+
> >>  	/* L1D Flush includes CPU buffer clear to mitigate MDS */
> >>  	if (static_branch_unlikely(&vmx_l1d_should_flush))
> >>  		vmx_l1d_flush(vcpu);
> >>@@ -6564,6 +6601,11 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
> >>  	x86_spec_ctrl_restore_host(vmx->spec_ctrl, 0);
> >>+	if (static_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT) &&
> >>+	    unlikely(vmx->disable_split_lock_detect) &&
> >>+	    !test_tsk_thread_flag(current, TIF_SLD))
> >>+		split_lock_detect_set(true);
> >
> >Manually calling split_lock_detect_set() in vmx_vcpu_run() is unnecessary.
> >The MSR only needs to be written on the initial #AC, after that KVM can
> >rely on the stickiness of TIF_SLD to ensure the MSR is set correctly when
> >control transfer to/from this vCPU.
> >
> >>+
> >>  	/* All fields are clean at this point */
> >>  	if (static_branch_unlikely(&enable_evmcs))
> >>  		current_evmcs->hv_clean_fields |=
> >>diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> >>index 7f42cf3dcd70..912eba66c5d5 100644
> >>--- a/arch/x86/kvm/vmx/vmx.h
> >>+++ b/arch/x86/kvm/vmx/vmx.h
> >>@@ -274,6 +274,9 @@ struct vcpu_vmx {
> >>  	bool req_immediate_exit;
> >>+	/* Disable split-lock detection when running the vCPU */
> >>+	bool disable_split_lock_detect;
> >>+
> >>  	/* Support for PML */
> >>  #define PML_ENTITY_NUM		512
> >>  	struct page *pml_pg;
> >>-- 
> >>2.23.0
> >>
> 
