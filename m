Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AFF6B401E
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2019 20:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732137AbfIPSQA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Sep 2019 14:16:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:41845 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727039AbfIPSQA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Sep 2019 14:16:00 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Sep 2019 11:15:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,513,1559545200"; 
   d="scan'208";a="270271573"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga001.jf.intel.com with ESMTP; 16 Sep 2019 11:15:59 -0700
Date:   Mon, 16 Sep 2019 11:15:59 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: Re: [PATCH v4 1/9] KVM: nVMX: Use kvm_set_msr to load
 IA32_PERF_GLOBAL_CTRL on vmexit
Message-ID: <20190916181559.GI18871@linux.intel.com>
References: <20190906210313.128316-1-oupton@google.com>
 <20190906210313.128316-2-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190906210313.128316-2-oupton@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 06, 2019 at 02:03:05PM -0700, Oliver Upton wrote:
> The existing implementation for loading the IA32_PERF_GLOBAL_CTRL MSR
> on VM-exit was incorrect, as the next call to atomic_switch_perf_msrs()
> could cause this value to be overwritten. Instead, call kvm_set_msr()
> which will allow atomic_switch_perf_msrs() to correctly set the values.
> 
> Suggested-by: Jim Mattson <jmattson@google.com>
> Co-developed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Signed-off-by: Oliver Upton <oupton@google.com>
> Reviewed-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Peter Shier <pshier@google.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index ced9fba32598..b0ca34bf4d21 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -3724,6 +3724,7 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
>  				   struct vmcs12 *vmcs12)
>  {
>  	struct kvm_segment seg;
> +	struct msr_data msr_info;
>  	u32 entry_failure_code;
>  
>  	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_EFER)
> @@ -3800,9 +3801,15 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
>  		vmcs_write64(GUEST_IA32_PAT, vmcs12->host_ia32_pat);
>  		vcpu->arch.pat = vmcs12->host_ia32_pat;
>  	}
> -	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL)
> -		vmcs_write64(GUEST_IA32_PERF_GLOBAL_CTRL,
> -			vmcs12->host_ia32_perf_global_ctrl);
> +	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL) {
> +		msr_info.host_initiated = false;
> +		msr_info.index = MSR_CORE_PERF_GLOBAL_CTRL;
> +		msr_info.data = vmcs12->host_ia32_perf_global_ctrl;
> +		if (kvm_set_msr(vcpu, &msr_info))
> +			pr_debug_ratelimited(
> +				"%s cannot write MSR (0x%x, 0x%llx)\n",
> +				__func__, msr_info.index, msr_info.data);

I belatedly realized we don't actually do anything on failure.  If you
reorder the series to add the checks (currently patches 4/9 and 5/9) at
the very beginning, can we then WARN on failure here (and in the guest
flow too)?

> +	}
>  
>  	/* Set L1 segment info according to Intel SDM
>  	    27.5.2 Loading Host Segment and Descriptor-Table Registers */
> -- 
> 2.23.0.187.g17f5b7556c-goog
> 
