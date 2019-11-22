Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E69BF107823
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2019 20:45:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbfKVTpr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Nov 2019 14:45:47 -0500
Received: from mga14.intel.com ([192.55.52.115]:16767 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726698AbfKVTpr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Nov 2019 14:45:47 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Nov 2019 11:45:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,231,1571727600"; 
   d="scan'208";a="210518682"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga006.jf.intel.com with ESMTP; 22 Nov 2019 11:45:45 -0800
Date:   Fri, 22 Nov 2019 11:45:45 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Marios Pomonis <pomonis@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, rkrcmar@redhat.com,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nick Finco <nifi@google.com>, Andrew Honig <ahonig@google.com>
Subject: Re: [PATCH] KVM: x86: Extend Spectre-v1 mitigation
Message-ID: <20191122194545.GC31235@linux.intel.com>
References: <20191122184039.7189-1-pomonis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191122184039.7189-1-pomonis@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 22, 2019 at 10:40:39AM -0800, Marios Pomonis wrote:
> From: Nick Finco <nifi@google.com>
> 
> This extends the Spectre-v1 mitigation introduced in
> commit 75f139aaf896 ("KVM: x86: Add memory barrier on vmcs field lookup")
> and commit 085331dfc6bb ("x86/kvm: Update spectre-v1 mitigation") in light
> of the Spectre-v1/L1TF combination described here:
> https://xenbits.xen.org/xsa/advisory-289.html
> 
> As reported in the link, an attacker can use the cache-load part of a
> Spectre-v1 gadget to bring memory into the L1 cache, then use L1TF to
> leak the loaded memory. Note that this attack is not fully mitigated by
> core scheduling; an attacker could employ L1TF on the same thread that
> loaded the memory in L1 instead of relying on neighboring hyperthreads.
> 
> This patch uses array_index_nospec() to prevent index computations from
> causing speculative loads into the L1 cache. These cases involve a
> bounds check followed by a memory read using the index; this is more
> common than the full Spectre-v1 pattern. In some cases, the index
> computation can be eliminated entirely by small amounts of refactoring.
> 
> Signed-off-by: Nick Finco <nifi@google.com>
> Signed-off-by: Marios Pomonis <pomonis@google.com>

+cc stable?

> Acked-by: Andrew Honig <ahonig@google.com>
> ---
>  arch/x86/kvm/emulate.c       | 11 ++++++++---
>  arch/x86/kvm/hyperv.c        | 10 ++++++----
>  arch/x86/kvm/i8259.c         |  6 +++++-
>  arch/x86/kvm/ioapic.c        | 15 +++++++++------
>  arch/x86/kvm/lapic.c         | 13 +++++++++----
>  arch/x86/kvm/mtrr.c          |  8 ++++++--
>  arch/x86/kvm/pmu.h           | 18 ++++++++++++++----
>  arch/x86/kvm/vmx/pmu_intel.c | 24 ++++++++++++++++--------
>  arch/x86/kvm/vmx/vmx.c       | 22 ++++++++++++++++------
>  arch/x86/kvm/x86.c           | 18 ++++++++++++++----
>  10 files changed, 103 insertions(+), 42 deletions(-)

Can you split this up into multiple patches?  I assume this needs to be
backported to stable, and throwing everything into a single patch will
make the process unnecessarily painful.  Reviewing things would also be
a lot easier.

...

> @@ -5828,6 +5836,8 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  	u32 exit_reason = vmx->exit_reason;
> +	u32 bounded_exit_reason = array_index_nospec(exit_reason,
> +						kvm_vmx_max_exit_handlers);
>  	u32 vectoring_info = vmx->idt_vectoring_info;
>  
>  	trace_kvm_exit(exit_reason, vcpu, KVM_ISA_VMX);
> @@ -5911,7 +5921,7 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu)
>  	}
>  
>  	if (exit_reason < kvm_vmx_max_exit_handlers
> -	    && kvm_vmx_exit_handlers[exit_reason]) {
> +	    && kvm_vmx_exit_handlers[bounded_exit_reason]) {
>  #ifdef CONFIG_RETPOLINE
>  		if (exit_reason == EXIT_REASON_MSR_WRITE)
>  			return kvm_emulate_wrmsr(vcpu);
> @@ -5926,7 +5936,7 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu)
>  		else if (exit_reason == EXIT_REASON_EPT_MISCONFIG)
>  			return handle_ept_misconfig(vcpu);
>  #endif
> -		return kvm_vmx_exit_handlers[exit_reason](vcpu);
> +		return kvm_vmx_exit_handlers[bounded_exit_reason](vcpu);
>  	} else {
>  		vcpu_unimpl(vcpu, "vmx: unexpected exit reason 0x%x\n",
>  				exit_reason);

Oof, using exit_reason for the comparison is subtle.  Rather than
precompute the bounded exit reason, what about refactoring the code so
that the array_index_nospec() tomfoolery can be done after the actual
bounds check?  This would also avoid the nospec stuff when using the
direct retpoline handling.

---
 arch/x86/kvm/vmx/vmx.c | 56 ++++++++++++++++++++++--------------------
 1 file changed, 30 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d39475e2d44e..14c2efd66300 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5910,34 +5910,38 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu)
 		}
 	}
 
-	if (exit_reason < kvm_vmx_max_exit_handlers
-	    && kvm_vmx_exit_handlers[exit_reason]) {
+	if (exit_reason >= kvm_vmx_max_exit_handlers)
+		goto unexpected_vmexit;
+
 #ifdef CONFIG_RETPOLINE
-		if (exit_reason == EXIT_REASON_MSR_WRITE)
-			return kvm_emulate_wrmsr(vcpu);
-		else if (exit_reason == EXIT_REASON_PREEMPTION_TIMER)
-			return handle_preemption_timer(vcpu);
-		else if (exit_reason == EXIT_REASON_PENDING_INTERRUPT)
-			return handle_interrupt_window(vcpu);
-		else if (exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT)
-			return handle_external_interrupt(vcpu);
-		else if (exit_reason == EXIT_REASON_HLT)
-			return kvm_emulate_halt(vcpu);
-		else if (exit_reason == EXIT_REASON_EPT_MISCONFIG)
-			return handle_ept_misconfig(vcpu);
+	if (exit_reason == EXIT_REASON_MSR_WRITE)
+		return kvm_emulate_wrmsr(vcpu);
+	else if (exit_reason == EXIT_REASON_PREEMPTION_TIMER)
+		return handle_preemption_timer(vcpu);
+	else if (exit_reason == EXIT_REASON_PENDING_INTERRUPT)
+		return handle_interrupt_window(vcpu);
+	else if (exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT)
+		return handle_external_interrupt(vcpu);
+	else if (exit_reason == EXIT_REASON_HLT)
+		return kvm_emulate_halt(vcpu);
+	else if (exit_reason == EXIT_REASON_EPT_MISCONFIG)
+		return handle_ept_misconfig(vcpu);
 #endif
-		return kvm_vmx_exit_handlers[exit_reason](vcpu);
-	} else {
-		vcpu_unimpl(vcpu, "vmx: unexpected exit reason 0x%x\n",
-				exit_reason);
-		dump_vmcs();
-		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-		vcpu->run->internal.suberror =
-			KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
-		vcpu->run->internal.ndata = 1;
-		vcpu->run->internal.data[0] = exit_reason;
-		return 0;
-	}
+
+	exit_reason = array_index_nospec(exit_reason, kvm_vmx_max_exit_handlers);
+	if (!kvm_vmx_exit_handlers[exit_reason])
+		goto unexpected_vmexit;
+
+	return kvm_vmx_exit_handlers[exit_reason](vcpu);
+
+unexpected_vmexit:
+	vcpu_unimpl(vcpu, "vmx: unexpected exit reason 0x%x\n", exit_reason);
+	dump_vmcs();
+	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+	vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
+	vcpu->run->internal.ndata = 1;
+	vcpu->run->internal.data[0] = exit_reason;
+	return 0;
 }
 
 /*
-- 
2.24.0

