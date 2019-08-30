Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C622A3D54
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2019 19:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728195AbfH3R7C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Aug 2019 13:59:02 -0400
Received: from mga12.intel.com ([192.55.52.136]:46098 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727883AbfH3R7C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Aug 2019 13:59:02 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Aug 2019 10:59:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,447,1559545200"; 
   d="scan'208";a="356860685"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga005.jf.intel.com with ESMTP; 30 Aug 2019 10:58:59 -0700
Date:   Fri, 30 Aug 2019 10:58:59 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>
Subject: Re: [PATCH 2/7] KVM: nVMX: Load GUEST_IA32_PERF_GLOBAL_CTRL MSR on
 vmentry
Message-ID: <20190830175859.GE15405@linux.intel.com>
References: <20190828234134.132704-1-oupton@google.com>
 <20190828234134.132704-3-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190828234134.132704-3-oupton@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 28, 2019 at 04:41:29PM -0700, Oliver Upton wrote:
> If the "load IA32_PERF_GLOBAL_CTRL" bit on the VM-entry control is
> set, the IA32_PERF_GLOBAL_CTRL MSR is loaded from GUEST_IA32_PERF_GLOBAL_CTRL
> on VM-entry. Adding condition to prepare_vmcs02 to set
> MSR_CORE_PERF_GLOBAL_CTRL if the "load IA32_PERF_GLOBAL_CTRL" bit is set.
> 
> Suggested-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Oliver Upton <oupton@google.com>
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

Blech, I was going to say you should add a helper to consolidate this code
for patches 1/7 and 2/7, but there are something like 10 different places
in KVM that have similar blobs.  I'll put together a patch or three to
add helpers, no need to address a wider problem with this series.

> +	}
> +
>  	kvm_rsp_write(vcpu, vmcs12->guest_rsp);
>  	kvm_rip_write(vcpu, vmcs12->guest_rip);
>  	return 0;
> -- 
> 2.23.0.187.g17f5b7556c-goog
> 
