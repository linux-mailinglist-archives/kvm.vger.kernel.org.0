Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16987B4003
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2019 20:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389897AbfIPSGP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Sep 2019 14:06:15 -0400
Received: from mga17.intel.com ([192.55.52.151]:39702 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389805AbfIPSGP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Sep 2019 14:06:15 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Sep 2019 11:06:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,513,1559545200"; 
   d="scan'208";a="201643031"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga001.fm.intel.com with ESMTP; 16 Sep 2019 11:06:14 -0700
Date:   Mon, 16 Sep 2019 11:06:14 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: Re: [PATCH v4 2/9] KVM: nVMX: Load GUEST_IA32_PERF_GLOBAL_CTRL MSR
 on vm-entry
Message-ID: <20190916180614.GF18871@linux.intel.com>
References: <20190906210313.128316-1-oupton@google.com>
 <20190906210313.128316-3-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190906210313.128316-3-oupton@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 06, 2019 at 02:03:06PM -0700, Oliver Upton wrote:
> Add condition to prepare_vmcs02 which loads IA32_PERF_GLOBAL_CTRL on
> VM-entry if the "load IA32_PERF_GLOBAL_CTRL" bit on the VM-entry control
> is set. Use kvm_set_msr() rather than directly writing to the field to
> avoid overwrite by atomic_switch_perf_msrs().
> 
> Suggested-by: Jim Mattson <jmattson@google.com>
> Co-developed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Signed-off-by: Oliver Upton <oupton@google.com>
> Reviewed-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Peter Shier <pshier@google.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index b0ca34bf4d21..9ba90b38d74b 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -2281,6 +2281,7 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  	struct hv_enlightened_vmcs *hv_evmcs = vmx->nested.hv_evmcs;
> +	struct msr_data msr_info;
>  	bool load_guest_pdptrs_vmcs12 = false;
>  
>  	if (vmx->nested.dirty_vmcs12 || hv_evmcs) {
> @@ -2404,6 +2405,16 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
>  	if (!enable_ept)
>  		vcpu->arch.walk_mmu->inject_page_fault = vmx_inject_page_fault_nested;
>  
> +	if (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL) {
> +		msr_info.host_initiated = false;
> +		msr_info.index = MSR_CORE_PERF_GLOBAL_CTRL;
> +		msr_info.data = vmcs12->guest_ia32_perf_global_ctrl;
> +		if (kvm_set_msr(vcpu, &msr_info))
> +			pr_debug_ratelimited(
> +				"%s cannot write MSR (0x%x, 0x%llx)\n",
> +				__func__, msr_info.index, msr_info.data);

Same comment on printing the name.  Might be work adding a helper function
or macro?  That'd also avoid blasting past the 80-column guideline.

> +	}
> +
>  	kvm_rsp_write(vcpu, vmcs12->guest_rsp);
>  	kvm_rip_write(vcpu, vmcs12->guest_rip);
>  	return 0;
> -- 
> 2.23.0.187.g17f5b7556c-goog
> 
