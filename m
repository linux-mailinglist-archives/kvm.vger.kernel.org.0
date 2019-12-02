Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B18F10F215
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2019 22:21:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725919AbfLBVVt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Dec 2019 16:21:49 -0500
Received: from mga04.intel.com ([192.55.52.120]:61239 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725834AbfLBVVt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Dec 2019 16:21:49 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Dec 2019 13:21:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,270,1571727600"; 
   d="scan'208";a="410578849"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga005.fm.intel.com with ESMTP; 02 Dec 2019 13:21:48 -0800
Date:   Mon, 2 Dec 2019 13:21:48 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [PATCH] KVM: nVMX: Use SET_MSR_OR_WARN() to simplify failure
 logging
Message-ID: <20191202212148.GA8120@linux.intel.com>
References: <20191128094609.22161-1-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191128094609.22161-1-oupton@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 28, 2019 at 01:46:09AM -0800, Oliver Upton wrote:
> commit 458151f65b4d ("KVM: nVMX: Use kvm_set_msr to load
> IA32_PERF_GLOBAL_CTRL on VM-Exit") introduced the SET_MSR_OR_WARN()
> macro to WARN when kvm_set_msr() fails. Replace other occurences of this
> pattern with the macro to remove the need of printing on failure.
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 12 ++----------
>  1 file changed, 2 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 4aea7d304beb..f7dbaac7cb90 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -928,12 +928,8 @@ static u32 nested_vmx_load_msr(struct kvm_vcpu *vcpu, u64 gpa, u32 count)
>  				__func__, i, e.index, e.reserved);
>  			goto fail;
>  		}
> -		if (kvm_set_msr(vcpu, e.index, e.value)) {
> -			pr_debug_ratelimited(
> -				"%s cannot write MSR (%u, 0x%x, 0x%llx)\n",
> -				__func__, i, e.index, e.value);
> +		if (SET_MSR_OR_WARN(vcpu, e.index, e.value))
>  			goto fail;
> -		}
>  	}
>  	return 0;
>  fail:
> @@ -4175,12 +4171,8 @@ static void nested_vmx_restore_host_state(struct kvm_vcpu *vcpu)
>  				goto vmabort;
>  			}
>  
> -			if (kvm_set_msr(vcpu, h.index, h.value)) {
> -				pr_debug_ratelimited(
> -					"%s WRMSR failed (%u, 0x%x, 0x%llx)\n",
> -					__func__, j, h.index, h.value);
> +			if (SET_MSR_OR_WARN(vcpu, h.index, h.value))

A few comments on commit 458151f65b4d, which I obviously waited to long too
review :-)

I find the WARN part of SET_MSR_OR_WARN() to be misleading.  For me, WARN
means exactly that, an actual on WARN or WARN_ON, which has different
implications, especially when running with KERN_PANIC_ON_WARN.

I also don't like incorporating SET_MSR in the macro as it's not obvious
what action will be taken without looking at the macro itself.  IMO the
code is more readable if only the print is macrofied, e.g.:

			if (kvm_set_msr(vcpu, h.index, h.value)
				NVMX_LOG_WRMSR_ERROR(h.index, h.value);

As for the original code, arguably it *should* do a full WARN and not
simply log the error, as kvm_set_msr() should never fail if
VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL was exposed to L1, unlike the above two
cases where KVM is processing an L1-controlled MSR list, e.g.:

	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL)
		WARN_ON_ONCE(kvm_set_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL,
					 vmcs12->host_ia32_perf_global_ctrl));

Back to this patch, this isn't simply consolidating code, it's promoting
L1-controlled messages from pr_debug() to pr_warn().

What if you add a patch to remove SET_MSR_OR_WARN() and instead manually
do the WARN_ON_ONCE() as above, and then introduce a new macro to
consolidate the pr_debug_ratelimited() stuff in this patch?

>  				goto vmabort;
> -			}
>  		}
>  	}
>  
> -- 
> 2.24.0.432.g9d3f5f5b63-goog
> 
