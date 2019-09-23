Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4674BBCC3
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2019 22:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502551AbfIWUXv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 16:23:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:45688 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728856AbfIWUXv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 16:23:51 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Sep 2019 13:23:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,541,1559545200"; 
   d="scan'208,223";a="389607898"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga006.fm.intel.com with ESMTP; 23 Sep 2019 13:23:49 -0700
Date:   Mon, 23 Sep 2019 13:23:49 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Andrea Arcangeli <aarcange@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/17] KVM: retpolines: x86: eliminate retpoline from
 vmx.c exit handlers
Message-ID: <20190923202349.GL18195@linux.intel.com>
References: <20190920212509.2578-1-aarcange@redhat.com>
 <20190920212509.2578-16-aarcange@redhat.com>
 <87o8zb8ik1.fsf@vitty.brq.redhat.com>
 <7329012d-0b3b-ce86-f58d-3d2d5dc5a790@redhat.com>
 <20190923190514.GB19996@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="r5Pyd7+fXNt84Ff3"
Content-Disposition: inline
In-Reply-To: <20190923190514.GB19996@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--r5Pyd7+fXNt84Ff3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 23, 2019 at 03:05:14PM -0400, Andrea Arcangeli wrote:
> On Mon, Sep 23, 2019 at 11:57:57AM +0200, Paolo Bonzini wrote:
> > On 23/09/19 11:31, Vitaly Kuznetsov wrote:
> > > +#ifdef CONFIG_RETPOLINE
> > > +		if (exit_reason == EXIT_REASON_MSR_WRITE)
> > > +			return handle_wrmsr(vcpu);
> > > +		else if (exit_reason == EXIT_REASON_PREEMPTION_TIMER)
> > > +			return handle_preemption_timer(vcpu);
> > > +		else if (exit_reason == EXIT_REASON_PENDING_INTERRUPT)
> > > +			return handle_interrupt_window(vcpu);
> > > +		else if (exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT)
> > > +			return handle_external_interrupt(vcpu);
> > > +		else if (exit_reason == EXIT_REASON_HLT)
> > > +			return handle_halt(vcpu);
> > > +		else if (exit_reason == EXIT_REASON_PAUSE_INSTRUCTION)
> > > +			return handle_pause(vcpu);
> > > +		else if (exit_reason == EXIT_REASON_MSR_READ)
> > > +			return handle_rdmsr(vcpu);
> > > +		else if (exit_reason == EXIT_REASON_CPUID)
> > > +			return handle_cpuid(vcpu);
> > > +		else if (exit_reason == EXIT_REASON_EPT_MISCONFIG)
> > > +			return handle_ept_misconfig(vcpu);
> > > +#endif
> > >  		return kvm_vmx_exit_handlers[exit_reason](vcpu);
> > 
> > Most of these, while frequent, are already part of slow paths.
> > 
> > I would keep only EXIT_REASON_MSR_WRITE, EXIT_REASON_PREEMPTION_TIMER,
> > EXIT_REASON_EPT_MISCONFIG and add EXIT_REASON_IO_INSTRUCTION.
> 
> Intuition doesn't work great when it comes to CPU speculative
> execution runtime. I can however run additional benchmarks to verify
> your theory that keeping around frequent retpolines will still perform
> ok.
> 
> > If you make kvm_vmx_exit_handlers const, can the compiler substitute for
> > instance kvm_vmx_exit_handlers[EXIT_REASON_MSR_WRITE] with handle_wrmsr?
> >  Just thinking out loud, not sure if it's an improvement code-wise.
> 
> gcc gets right if you make it const, it calls kvm_emulate_wrmsr in
> fact. However I don't think const will fly
> with_vmx_hardware_setup()... in fact at runtime testing nested I just
> got:
> 
> BUG: unable to handle page fault for address: ffffffffa00751e0
> #PF: supervisor write access in kernel mode
> #PF: error_code(0x0003) - permissions violation
> PGD 2424067 P4D 2424067 PUD 2425063 PMD 7cc09067 PTE 80000000741cb161
> Oops: 0003 [#1] SMP NOPTI
> CPU: 1 PID: 4458 Comm: insmod Not tainted 5.3.0+ #1
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS ?-20190711_202441-buildvm-armv7-10.arm.fedoraproject.or4
> RIP: 0010:nested_vmx_hardware_setup+0x29a/0x37a [kvm_intel]
> Code: 41 ff c5 66 89 2c 85 20 92 0b a0 66 44 89 34 85 22 92 0b a0 49 ff c7 e9 e6 fe ff ff 44 89 2d 28 24 fc ff 48
> RSP: 0018:ffffc90000257c18 EFLAGS: 00010246
> RAX: ffffffffa001e0b0 RBX: ffffffffa0075140 RCX: 0000000000000000
> RDX: ffff888078f60000 RSI: 0000000000002401 RDI: 0000000000000018
> RBP: 0000000000006c08 R08: 0000000000001000 R09: 000000000007ffdc
> R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000006c08
> R13: 0000000000000017 R14: 0000000000000268 R15: 0000000000000018
> FS:  00007f7fb7ef0b80(0000) GS:ffff88807da40000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffffffffa00751e0 CR3: 0000000079620001 CR4: 0000000000160ee0
> Call Trace:
>  hardware_setup+0x4df/0x5b2 [kvm_intel]
>  kvm_arch_hardware_setup+0x2f/0x27b [kvm_intel]
>  kvm_init+0x5d/0x26d [kvm_intel]

The attached patch should do the trick.

--r5Pyd7+fXNt84Ff3
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-KVM-nVMX-Do-not-dynamically-set-VMX-instruction-exit.patch"

From 4e0c2d73d796eae03aa289f77bef5f4a7acef655 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <sean.j.christopherson@intel.com>
Date: Mon, 23 Sep 2019 13:19:43 -0700
Subject: [PATCH] KVM: nVMX: Do not dynamically set VMX instruction exit
 handlers

Handle VMX instructions via a dedicated function and a switch statement
provided by the nVMX code instead of overwriting kvm_vmx_exit_handlers
when nested support is enabled.  This will allow a future patch to make
kvm_vmx_exit_handlers a const, which in turn allows for better compiler
optimizations, e.g. direct calls instead of retpolined indirect calls.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 52 ++++++++++++++++++++++++++++-----------
 arch/x86/kvm/vmx/nested.h |  3 ++-
 arch/x86/kvm/vmx/vmx.c    |  5 +++-
 3 files changed, 44 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 6ce83c602e7f..41c7fcf28ab6 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5072,6 +5072,43 @@ static int handle_vmfunc(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+int nested_vmx_handle_vmx_instruction(struct kvm_vcpu *vcpu)
+{
+	switch (to_vmx(vcpu)->exit_reason) {
+	case EXIT_REASON_VMCLEAR:
+		return handle_vmclear(vcpu);
+	case EXIT_REASON_VMLAUNCH:
+		return handle_vmlaunch(vcpu);
+	case EXIT_REASON_VMPTRLD:
+		return handle_vmptrld(vcpu);
+	case EXIT_REASON_VMPTRST:
+		return handle_vmptrst(vcpu);
+	case EXIT_REASON_VMREAD:
+		return handle_vmread(vcpu);
+	case EXIT_REASON_VMRESUME:
+		return handle_vmresume(vcpu);
+	case EXIT_REASON_VMWRITE:
+		return handle_vmwrite(vcpu);
+	case EXIT_REASON_VMOFF:
+		return handle_vmoff(vcpu);
+	case EXIT_REASON_VMON:
+		return handle_vmon(vcpu);
+	case EXIT_REASON_INVEPT:
+		return handle_invept(vcpu);
+	case EXIT_REASON_INVVPID:
+		return handle_invvpid(vcpu);
+	case EXIT_REASON_VMFUNC:
+		return handle_vmfunc(vcpu);
+	}
+
+	WARN_ON_ONCE(1);
+	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+	vcpu->run->internal.suberror =
+	KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
+	vcpu->run->internal.ndata = 1;
+	vcpu->run->internal.data[0] = to_vmx(vcpu)->exit_reason;
+	return 0;
+}
 
 static bool nested_vmx_exit_handled_io(struct kvm_vcpu *vcpu,
 				       struct vmcs12 *vmcs12)
@@ -5972,7 +6009,7 @@ void nested_vmx_hardware_unsetup(void)
 	}
 }
 
-__init int nested_vmx_hardware_setup(int (*exit_handlers[])(struct kvm_vcpu *))
+__init int nested_vmx_hardware_setup(void)
 {
 	int i;
 
@@ -5995,19 +6032,6 @@ __init int nested_vmx_hardware_setup(int (*exit_handlers[])(struct kvm_vcpu *))
 		init_vmcs_shadow_fields();
 	}
 
-	exit_handlers[EXIT_REASON_VMCLEAR]	= handle_vmclear,
-	exit_handlers[EXIT_REASON_VMLAUNCH]	= handle_vmlaunch,
-	exit_handlers[EXIT_REASON_VMPTRLD]	= handle_vmptrld,
-	exit_handlers[EXIT_REASON_VMPTRST]	= handle_vmptrst,
-	exit_handlers[EXIT_REASON_VMREAD]	= handle_vmread,
-	exit_handlers[EXIT_REASON_VMRESUME]	= handle_vmresume,
-	exit_handlers[EXIT_REASON_VMWRITE]	= handle_vmwrite,
-	exit_handlers[EXIT_REASON_VMOFF]	= handle_vmoff,
-	exit_handlers[EXIT_REASON_VMON]		= handle_vmon,
-	exit_handlers[EXIT_REASON_INVEPT]	= handle_invept,
-	exit_handlers[EXIT_REASON_INVVPID]	= handle_invvpid,
-	exit_handlers[EXIT_REASON_VMFUNC]	= handle_vmfunc,
-
 	kvm_x86_ops->check_nested_events = vmx_check_nested_events;
 	kvm_x86_ops->get_nested_state = vmx_get_nested_state;
 	kvm_x86_ops->set_nested_state = vmx_set_nested_state;
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index 187d39bf0bf1..0da48c83cccf 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -10,9 +10,10 @@ void vmx_leave_nested(struct kvm_vcpu *vcpu);
 void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps,
 				bool apicv);
 void nested_vmx_hardware_unsetup(void);
-__init int nested_vmx_hardware_setup(int (*exit_handlers[])(struct kvm_vcpu *));
+__init int nested_vmx_hardware_setup(void);
 void nested_vmx_vcpu_setup(void);
 void nested_vmx_free_vcpu(struct kvm_vcpu *vcpu);
+int nested_vmx_handle_vmx_instruction(struct kvm_vcpu *vcpu);
 int nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu, bool from_vmentry);
 bool nested_vmx_exit_reflected(struct kvm_vcpu *vcpu, u32 exit_reason);
 void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 73bf9a2e6fb6..229b3a5e0695 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5459,6 +5459,9 @@ static int handle_preemption_timer(struct kvm_vcpu *vcpu)
  */
 static int handle_vmx_instruction(struct kvm_vcpu *vcpu)
 {
+	if (nested)
+		return nested_vmx_handle_vmx_instruction(vcpu);
+
 	kvm_queue_exception(vcpu, UD_VECTOR);
 	return 1;
 }
@@ -7631,7 +7634,7 @@ static __init int hardware_setup(void)
 		nested_vmx_setup_ctls_msrs(&vmcs_config.nested,
 					   vmx_capability.ept, enable_apicv);
 
-		r = nested_vmx_hardware_setup(kvm_vmx_exit_handlers);
+		r = nested_vmx_hardware_setup();
 		if (r)
 			return r;
 	}
-- 
2.22.0


--r5Pyd7+fXNt84Ff3--
