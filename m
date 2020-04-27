Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 609CE1BAB4F
	for <lists+kvm@lfdr.de>; Mon, 27 Apr 2020 19:31:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726403AbgD0RbK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Apr 2020 13:31:10 -0400
Received: from mga18.intel.com ([134.134.136.126]:58062 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725963AbgD0RbK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Apr 2020 13:31:10 -0400
IronPort-SDR: aNRtvq3zFQSTrkM2AZtgiLRxCr7ZuIxt1DGpEwVn/8F1/lPj6nNIsdo4HtWQH+cQEnD5EPZqLq
 HS3kl8uVSB9g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2020 10:31:09 -0700
IronPort-SDR: iJmI1/x6PHS2h8HHL4fe+rV4IJA9OEVmDNy7L7RGOQE5trEzykiUS9a81i3L8rtgOPwvffUQBC
 xzitp72/sAAw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,324,1583222400"; 
   d="scan'208";a="246214203"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga007.jf.intel.com with ESMTP; 27 Apr 2020 10:31:09 -0700
Date:   Mon, 27 Apr 2020 10:31:09 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: VMX: Use accessor to read vmcs.INTR_INFO when
 handling exception
Message-ID: <20200427173108.GI14870@linux.intel.com>
References: <20200427171837.22613-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200427171837.22613-1-sean.j.christopherson@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 27, 2020 at 10:18:37AM -0700, Sean Christopherson wrote:
> Use vmx_get_intr_info() when grabbing the cached vmcs.INTR_INFO in
> handle_exception_nmi() to ensure the cache isn't stale.  Bypassing the
> caching accessor doesn't cause any known issues as the cache is always
> refreshed by handle_exception_nmi_irqoff(), but the whole point of
> adding the proper caching mechanism was to avoid such dependencies.

Despite stating that this doesn't cause any known issues, the reason I
ended up looking at this code is because I hit an emulation error due to a
presumed page fault getting intercepted while EPT is enabled, i.e. I hit
this warning:

	if (is_page_fault(intr_info)) {
		cr2 = vmx_get_exit_qual(vcpu);
		/* EPT won't cause page fault directly */
		WARN_ON_ONCE(!vcpu->arch.apf.host_apf_reason && enable_ept);
		return kvm_handle_page_fault(vcpu, error_code, cr2, NULL, 0);
	}

The problem is that I hit the WARN while running KVM unit tests in L2, with
the "buggy" KVM in L1, and a slightly older version of kvm/queue running as
L0.  I.e. the bug could easily be incorrect #PF reflection/injection in L0.

To make matters worse, I stupidly didn't capture any state at the time
of failure because I assumed the failure would be reproducible, e.g. I
don't know if L2 (L1 from this patch's perspective) or L3 (relative L2) was
active.

And because things weren't complicated enough, I'm not even sure what KVM
configuration I was running as L2 (relative L1).  I know what commit I was
running, but I may or may not have been running with ept=0, and it may or
may not have been a 32-bit kernel.  *sigh*

I've been poring over the caching code and the nested code trying to figure
out what might have gone wrong, but haven't been able to find a smoking gun.

TL;DR: I don't think this causes bugs, but I hit a non-reproducible WARN
that is very much related to the code in question.


> Fixes: 8791585837f6 ("KVM: VMX: Cache vmcs.EXIT_INTR_INFO using arch avail_reg flags")
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 3ab6ca6062ce..7bddcb24f6f3 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4677,7 +4677,7 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
>  	u32 vect_info;
>  
>  	vect_info = vmx->idt_vectoring_info;
> -	intr_info = vmx->exit_intr_info;
> +	intr_info = vmx_get_intr_info(vcpu);
>  
>  	if (is_machine_check(intr_info) || is_nmi(intr_info))
>  		return 1; /* handled by handle_exception_nmi_irqoff() */
> -- 
> 2.26.0
> 
