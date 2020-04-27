Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF55E1BACAF
	for <lists+kvm@lfdr.de>; Mon, 27 Apr 2020 20:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbgD0SaP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Apr 2020 14:30:15 -0400
Received: from mga03.intel.com ([134.134.136.65]:34512 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726189AbgD0SaP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Apr 2020 14:30:15 -0400
IronPort-SDR: FH5ieVHTDZl2NcHKKYf3Qs7DeErajLnY5EAM0OEBjnqhXdmMpwSrJk3Wab0NNYh1W3Q0BZorGQ
 6oo8xKHAu1mw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2020 11:30:14 -0700
IronPort-SDR: dzNpUWnLy+BqQgkoHYn8J7WnmojkK9OYjkNk7tmyxglsZJEl8zaAD+fCzVBM4QOOGsJNp/sxSe
 LJqMy4MasX9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,325,1583222400"; 
   d="scan'208";a="281861522"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga004.fm.intel.com with ESMTP; 27 Apr 2020 11:30:13 -0700
Date:   Mon, 27 Apr 2020 11:30:13 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Haiwei Li <lihaiwei@tencent.com>
Subject: Re: [PATCH v3 2/5] KVM: X86: Introduce need_cancel_enter_guest helper
Message-ID: <20200427183013.GN14870@linux.intel.com>
References: <1587709364-19090-1-git-send-email-wanpengli@tencent.com>
 <1587709364-19090-3-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1587709364-19090-3-git-send-email-wanpengli@tencent.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 24, 2020 at 02:22:41PM +0800, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> Introduce need_cancel_enter_guest() helper, we need to check some 
> conditions before doing CONT_RUN, in addition, it can also catch 
> the case vmexit occurred while another event was being delivered 
> to guest software since vmx_complete_interrupts() adds the request 
> bit.
> 
> Tested-by: Haiwei Li <lihaiwei@tencent.com>
> Cc: Haiwei Li <lihaiwei@tencent.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 12 +++++++-----
>  arch/x86/kvm/x86.c     | 10 ++++++++--
>  arch/x86/kvm/x86.h     |  1 +
>  3 files changed, 16 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index f1f6638..5c21027 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6577,7 +6577,7 @@ bool __vmx_vcpu_run(struct vcpu_vmx *vmx, unsigned long *regs, bool launched);
>  
>  static enum exit_fastpath_completion vmx_vcpu_run(struct kvm_vcpu *vcpu)
>  {
> -	enum exit_fastpath_completion exit_fastpath;
> +	enum exit_fastpath_completion exit_fastpath = EXIT_FASTPATH_NONE;
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  	unsigned long cr3, cr4;
>  
> @@ -6754,10 +6754,12 @@ static enum exit_fastpath_completion vmx_vcpu_run(struct kvm_vcpu *vcpu)
>  	vmx_recover_nmi_blocking(vmx);
>  	vmx_complete_interrupts(vmx);
>  
> -	exit_fastpath = vmx_exit_handlers_fastpath(vcpu);
> -	/* static call is better with retpolines */
> -	if (exit_fastpath == EXIT_FASTPATH_CONT_RUN)
> -		goto cont_run;
> +	if (!kvm_need_cancel_enter_guest(vcpu)) {
> +		exit_fastpath = vmx_exit_handlers_fastpath(vcpu);
> +		/* static call is better with retpolines */
> +		if (exit_fastpath == EXIT_FASTPATH_CONT_RUN)
> +			goto cont_run;
> +	}
>  
>  	return exit_fastpath;
>  }
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 59958ce..4561104 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1581,6 +1581,13 @@ int kvm_emulate_wrmsr(struct kvm_vcpu *vcpu)
>  }
>  EXPORT_SYMBOL_GPL(kvm_emulate_wrmsr);
>  
> +bool kvm_need_cancel_enter_guest(struct kvm_vcpu *vcpu)

What about kvm_vcpu_<???>_pending()?  Not sure what a good ??? would be.
The "cancel_enter_guest" wording is a bit confusing when this is called
from the VM-Exit path.

> +{
> +	return (vcpu->mode == EXITING_GUEST_MODE || kvm_request_pending(vcpu)
> +	    || need_resched() || signal_pending(current));

Parantheses around the whole statement are unnecessary.  Personal preference
is to put the || before the newline.

> +}
> +EXPORT_SYMBOL_GPL(kvm_need_cancel_enter_guest);
> +
>  /*
>   * The fast path for frequent and performance sensitive wrmsr emulation,
>   * i.e. the sending of IPI, sending IPI early in the VM-Exit flow reduces
> @@ -8373,8 +8380,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  	if (kvm_lapic_enabled(vcpu) && vcpu->arch.apicv_active)
>  		kvm_x86_ops.sync_pir_to_irr(vcpu);
>  
> -	if (vcpu->mode == EXITING_GUEST_MODE || kvm_request_pending(vcpu)
> -	    || need_resched() || signal_pending(current)) {
> +	if (kvm_need_cancel_enter_guest(vcpu)) {
>  		vcpu->mode = OUTSIDE_GUEST_MODE;
>  		smp_wmb();
>  		local_irq_enable();
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 7b5ed8e..1906e7e 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -364,5 +364,6 @@ static inline bool kvm_dr7_valid(u64 data)
>  void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu);
>  void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu);
>  u64 kvm_spec_ctrl_valid_bits(struct kvm_vcpu *vcpu);
> +bool kvm_need_cancel_enter_guest(struct kvm_vcpu *vcpu);
>  
>  #endif
> -- 
> 2.7.4
> 
