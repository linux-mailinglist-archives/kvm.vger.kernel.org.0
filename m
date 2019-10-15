Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6818D6CB9
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 03:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727225AbfJOBHl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Oct 2019 21:07:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:20325 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727084AbfJOBHl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Oct 2019 21:07:41 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Oct 2019 18:07:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,297,1566889200"; 
   d="scan'208";a="395374550"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga005.fm.intel.com with ESMTP; 14 Oct 2019 18:07:40 -0700
Date:   Mon, 14 Oct 2019 18:07:40 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, Liran Alon <liran.alon@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dan Cross <dcross@google.com>, Peter Shier <pshier@google.com>
Subject: Re: [PATCH v4] KVM: nVMX: Don't leak L1 MMIO regions to L2
Message-ID: <20191015010740.GA24895@linux.intel.com>
References: <20191015001304.2304-1-jmattson@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191015001304.2304-1-jmattson@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 14, 2019 at 05:13:04PM -0700, Jim Mattson wrote:
> If the "virtualize APIC accesses" VM-execution control is set in the
> VMCS, the APIC virtualization hardware is triggered when a page walk
> in VMX non-root mode terminates at a PTE wherein the address of the 4k
> page frame matches the APIC-access address specified in the VMCS. On
> hardware, the APIC-access address may be any valid 4k-aligned physical
> address.
> 
> KVM's nVMX implementation enforces the additional constraint that the
> APIC-access address specified in the vmcs12 must be backed by
> a "struct page" in L1. If not, L0 will simply clear the "virtualize
> APIC accesses" VM-execution control in the vmcs02.
> 
> The problem with this approach is that the L1 guest has arranged the
> vmcs12 EPT tables--or shadow page tables, if the "enable EPT"
> VM-execution control is clear in the vmcs12--so that the L2 guest
> physical address(es)--or L2 guest linear address(es)--that reference
> the L2 APIC map to the APIC-access address specified in the
> vmcs12. Without the "virtualize APIC accesses" VM-execution control in
> the vmcs02, the APIC accesses in the L2 guest will directly access the
> APIC-access page in L1.
> 
> When there is no mapping whatsoever for the APIC-access address in L1,
> the L2 VM just loses the intended APIC virtualization. However, when
> the APIC-access address is mapped to an MMIO region in L1, the L2
> guest gets direct access to the L1 MMIO device. For example, if the
> APIC-access address specified in the vmcs12 is 0xfee00000, then L2
> gets direct access to L1's APIC.
> 
> Since this vmcs12 configuration is something that KVM cannot
> faithfully emulate, the appropriate response is to exit to userspace
> with KVM_INTERNAL_ERROR_EMULATION.
> 
> Fixes: fe3ef05c7572 ("KVM: nVMX: Prepare vmcs02 from vmcs01 and vmcs12")
> Reported-by: Dan Cross <dcross@google.com>
> Signed-off-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Peter Shier <pshier@google.com>
> ---

With two nits below:

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>

> @@ -3244,13 +3247,9 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
>  	 * the nested entry.
>  	 */
>  	vmx->nested.nested_run_pending = 1;
> -	ret = nested_vmx_enter_non_root_mode(vcpu, true);
> -	vmx->nested.nested_run_pending = !ret;
> -	if (ret > 0)
> -		return 1;
> -	else if (ret)
> -		return nested_vmx_failValid(vcpu,
> -			VMXERR_ENTRY_INVALID_CONTROL_FIELD);
> +	status = nested_vmx_enter_non_root_mode(vcpu, true);
> +	if (unlikely(status != NVMX_VMENTRY_SUCCESS))

KVM doesn't usually add (un)likely annotations for things that are under
L1's control.  The "unlikely(vmx->fail)" in nested_vmx_exit_reflected() is
there because it's true iff KVM missed a VM-Fail condition that was caught
by hardware.

> +		goto vmentry_failed;
>  
>  	/* Hide L1D cache contents from the nested guest.  */
>  	vmx->vcpu.arch.l1tf_flush_l1d = true;
> @@ -3281,6 +3280,16 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
>  		return kvm_vcpu_halt(vcpu);
>  	}
>  	return 1;
> +
> +vmentry_failed:
> +	vmx->nested.nested_run_pending = 0;
> +	if (status == NVMX_VMENTRY_KVM_INTERNAL_ERROR)
> +		return 0;
> +	if (status == NVMX_VMENTRY_VMEXIT)
> +		return 1;
> +	WARN_ON_ONCE(status != NVMX_VMENTRY_VMFAIL);
> +	return nested_vmx_failValid(vcpu,
> +				    VMXERR_ENTRY_INVALID_CONTROL_FIELD);

This can fit on a single line.

>  }
>  
>  /*
