Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED258151077
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2020 20:48:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbgBCTsI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Feb 2020 14:48:08 -0500
Received: from mga07.intel.com ([134.134.136.100]:44391 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726018AbgBCTsI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Feb 2020 14:48:08 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Feb 2020 11:48:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,398,1574150400"; 
   d="scan'208";a="231127073"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga003.jf.intel.com with ESMTP; 03 Feb 2020 11:48:07 -0800
Date:   Mon, 3 Feb 2020 11:48:06 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>
Subject: Re: [PATCH v2 3/5] KVM: x86: Deliver exception payload on
 KVM_GET_VCPU_EVENTS
Message-ID: <20200203194806.GC19638@linux.intel.com>
References: <20200128092715.69429-1-oupton@google.com>
 <20200128092715.69429-4-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200128092715.69429-4-oupton@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 28, 2020 at 01:27:13AM -0800, Oliver Upton wrote:
> KVM doesn't utilize exception payloads by default, as this behavior
> diverges from the expectations of the userspace API. However, this
> constraint only applies if KVM is servicing a KVM_GET_VCPU_EVENTS ioctl
> before delivering the exception.
> 
> Use exception payloads unconditionally if the vcpu is in guest mode.

This sentence is super confusing.  It doesn't align with the code, which
is clearly handling "not is in guest mode".  And KVM already uses payloads
unconditionally, it's only the deferring behavior that is changing.

> Deliver the exception payload before completing a KVM_GET_VCPU_EVENTS
> to ensure API compatibility.
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  arch/x86/kvm/x86.c | 29 ++++++++++++++++-------------
>  1 file changed, 16 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 7a341c0c978a..9f080101618c 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -497,19 +497,7 @@ static void kvm_multiple_exception(struct kvm_vcpu *vcpu,
>  		vcpu->arch.exception.error_code = error_code;
>  		vcpu->arch.exception.has_payload = has_payload;
>  		vcpu->arch.exception.payload = payload;
> -		/*
> -		 * In guest mode, payload delivery should be deferred,
> -		 * so that the L1 hypervisor can intercept #PF before
> -		 * CR2 is modified (or intercept #DB before DR6 is
> -		 * modified under nVMX).  However, for ABI
> -		 * compatibility with KVM_GET_VCPU_EVENTS and
> -		 * KVM_SET_VCPU_EVENTS, we can't delay payload
> -		 * delivery unless userspace has enabled this
> -		 * functionality via the per-VM capability,
> -		 * KVM_CAP_EXCEPTION_PAYLOAD.
> -		 */
> -		if (!vcpu->kvm->arch.exception_payload_enabled ||
> -		    !is_guest_mode(vcpu))
> +		if (!is_guest_mode(vcpu))
>  			kvm_deliver_exception_payload(vcpu);
>  		return;
>  	}
> @@ -3790,6 +3778,21 @@ static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
>  {
>  	process_nmi(vcpu);
>  
> +	/*
> +	 * In guest mode, payload delivery should be deferred,
> +	 * so that the L1 hypervisor can intercept #PF before
> +	 * CR2 is modified (or intercept #DB before DR6 is
> +	 * modified under nVMX).  However, for ABI
> +	 * compatibility with KVM_GET_VCPU_EVENTS and
> +	 * KVM_SET_VCPU_EVENTS, we can't delay payload
> +	 * delivery unless userspace has enabled this
> +	 * functionality via the per-VM capability,
> +	 * KVM_CAP_EXCEPTION_PAYLOAD.
> +	 */

This comment needs to be rewritten.  It makes sense in the context of
kvm_multiple_exception(), here it's just confusing.

> +	if (!vcpu->kvm->arch.exception_payload_enabled &&
> +	    vcpu->arch.exception.pending && vcpu->arch.exception.has_payload)
> +		kvm_deliver_exception_payload(vcpu);

Crushing CR2/DR6 just because userspace is retrieving info can't possibly
be correct.  If it somehow is correct then this needs big fat comment.

What is the ABI compatibility issue?  E.g. can KVM simply hide the payload
info on KVM_GET_VCPU_EVENT and then drop it on KVM_SET_VCPU_EVENTS?

> +
>  	/*
>  	 * The API doesn't provide the instruction length for software
>  	 * exceptions, so don't report them. As long as the guest RIP
> -- 
> 2.25.0.341.g760bfbb309-goog
> 
