Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E98FEB400D
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2019 20:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729846AbfIPSKU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Sep 2019 14:10:20 -0400
Received: from mga01.intel.com ([192.55.52.88]:28300 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729800AbfIPSKU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Sep 2019 14:10:20 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Sep 2019 11:10:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,513,1559545200"; 
   d="scan'208";a="211240659"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga004.fm.intel.com with ESMTP; 16 Sep 2019 11:10:19 -0700
Date:   Mon, 16 Sep 2019 11:10:19 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: Re: [PATCH v4 5/9] KVM: nVMX: Check HOST_IA32_PERF_GLOBAL_CTRL on
 VM-entry
Message-ID: <20190916181019.GH18871@linux.intel.com>
References: <20190906210313.128316-1-oupton@google.com>
 <20190906210313.128316-6-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190906210313.128316-6-oupton@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 06, 2019 at 02:03:09PM -0700, Oliver Upton wrote:
> Add a consistency check on nested vm-entry for host's
> IA32_PERF_GLOBAL_CTRL from vmcs12. Per Intel's SDM Vol 3 26.2.2:
> 
>   If the "load IA32_PERF_GLOBAL_CTRL"
>   VM-exit control is 1, bits reserved in the IA32_PERF_GLOBAL_CTRL
>   MSR must be 0 in the field for that register"
> 
> Suggested-by: Jim Mattson <jmattson@google.com>
> Co-developed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Signed-off-by: Oliver Upton <oupton@google.com>
> Reviewed-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Peter Shier <pshier@google.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 6c3aa3bcede3..e2baa9ca562f 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -2636,6 +2636,7 @@ static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
>  				       struct vmcs12 *vmcs12)
>  {
>  	bool ia32e;
> +	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);

Same nit on the local variable.

>  
>  	if (!nested_host_cr0_valid(vcpu, vmcs12->host_cr0) ||
>  	    !nested_host_cr4_valid(vcpu, vmcs12->host_cr4) ||
> @@ -2650,6 +2651,11 @@ static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
>  	    !kvm_pat_valid(vmcs12->host_ia32_pat))
>  		return -EINVAL;
>  
> +	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL &&
> +	    !kvm_is_valid_perf_global_ctrl(pmu,
> +					   vmcs12->host_ia32_perf_global_ctrl))
> +		return -EINVAL;
> +
>  	ia32e = (vmcs12->vm_exit_controls &
>  		 VM_EXIT_HOST_ADDR_SPACE_SIZE) != 0;
>  
> -- 
> 2.23.0.187.g17f5b7556c-goog
> 
