Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4C7BB993
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2019 18:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729121AbfIWQ2j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 12:28:39 -0400
Received: from mga02.intel.com ([134.134.136.20]:26282 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726328AbfIWQ2j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 12:28:39 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Sep 2019 09:28:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,541,1559545200"; 
   d="scan'208";a="189108811"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga007.fm.intel.com with ESMTP; 23 Sep 2019 09:28:37 -0700
Date:   Mon, 23 Sep 2019 09:28:37 -0700
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
Message-ID: <20190923162837.GD18195@linux.intel.com>
References: <20190920212509.2578-1-aarcange@redhat.com>
 <20190920212509.2578-16-aarcange@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190920212509.2578-16-aarcange@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Subject should be something like:

  KVM: VMX: Make direct calls to fast path VM-Exit handlers

On Fri, Sep 20, 2019 at 05:25:07PM -0400, Andrea Arcangeli wrote:
> It's enough to check the exit value and issue a direct call to avoid
> the retpoline for all the common vmexit reasons.
> 
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 24 ++++++++++++++++++++++--
>  1 file changed, 22 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index a6e597025011..9aa73e216df2 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -5866,9 +5866,29 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu)
>  	}
>  
>  	if (exit_reason < kvm_vmx_max_exit_handlers
> -	    && kvm_vmx_exit_handlers[exit_reason])
> +	    && kvm_vmx_exit_handlers[exit_reason]) {
> +#ifdef CONFIG_RETPOLINE

I'd strongly prefer to make any optimization of this type unconditional,
i.e. not dependent on CONFIG_RETPOLINE.  Today, I'm comfortable testing
KVM only with CONFIG_RETPOLINE=y since the only KVM-specific difference
is additive code in vmx_vmexit.  That would no longer be the case if KVM
has non-trivial code differences for retpoline.

> +		if (exit_reason == EXIT_REASON_MSR_WRITE)
> +			return handle_wrmsr(vcpu);
> +		else if (exit_reason == EXIT_REASON_PREEMPTION_TIMER)
> +			return handle_preemption_timer(vcpu);
> +		else if (exit_reason == EXIT_REASON_PENDING_INTERRUPT)
> +			return handle_interrupt_window(vcpu);
> +		else if (exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT)
> +			return handle_external_interrupt(vcpu);
> +		else if (exit_reason == EXIT_REASON_HLT)
> +			return handle_halt(vcpu);
> +		else if (exit_reason == EXIT_REASON_PAUSE_INSTRUCTION)
> +			return handle_pause(vcpu);
> +		else if (exit_reason == EXIT_REASON_MSR_READ)
> +			return handle_rdmsr(vcpu);
> +		else if (exit_reason == EXIT_REASON_CPUID)
> +			return handle_cpuid(vcpu);
> +		else if (exit_reason == EXIT_REASON_EPT_MISCONFIG)
> +			return handle_ept_misconfig(vcpu);
> +#endif

This can be hoisted above the if statement.

>  		return kvm_vmx_exit_handlers[exit_reason](vcpu);
> -	else {
> +	} else {
>  		vcpu_unimpl(vcpu, "vmx: unexpected exit reason 0x%x\n",
>  				exit_reason);
>  		dump_vmcs();
