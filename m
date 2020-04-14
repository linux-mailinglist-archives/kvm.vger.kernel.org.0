Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FBF31A718F
	for <lists+kvm@lfdr.de>; Tue, 14 Apr 2020 05:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404478AbgDNDRG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Apr 2020 23:17:06 -0400
Received: from mga07.intel.com ([134.134.136.100]:34432 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404224AbgDNDRG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Apr 2020 23:17:06 -0400
IronPort-SDR: aj35rMfAx9Do4msL0WheGA4nZ/9PUEG/vKhIU7ubZ1ueLGPjxWq8hWf4cO4tHveYuuFr53FUCD
 L23rGsBxIVdg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2020 20:17:05 -0700
IronPort-SDR: jbQ5Enq0qSTQzPnYBmWwoqoqrc8JdZRkWuGPvSipYdPFwpSeJ2f8PZCRjGEcZGNvGv5eTtLokg
 rMq1+Xb9kQ9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,381,1580803200"; 
   d="scan'208";a="399817495"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga004.jf.intel.com with ESMTP; 13 Apr 2020 20:17:05 -0700
Date:   Mon, 13 Apr 2020 20:17:05 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Subject: Re: [PATCH 2/2] kvm: nVMX: Single-step traps trump expired
 VMX-preemption timer
Message-ID: <20200414031705.GP21204@linux.intel.com>
References: <20200414000946.47396-1-jmattson@google.com>
 <20200414000946.47396-2-jmattson@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200414000946.47396-2-jmattson@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 13, 2020 at 05:09:46PM -0700, Jim Mattson wrote:
> Previously, if the hrtimer for the nested VMX-preemption timer fired
> while L0 was emulating an L2 instruction with RFLAGS.TF set, the
> synthesized single-step trap would be unceremoniously dropped when
> synthesizing the "VMX-preemption timer expired" VM-exit from L2 to L1.
> 
> To fix this, don't synthesize a "VMX-preemption timer expired" VM-exit
> from L2 to L1 when there is a pending debug trap, such as a
> single-step trap.
> 
> Fixes: f4124500c2c13 ("KVM: nVMX: Fully emulate preemption timer")
> Signed-off-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Oliver Upton <oupton@google.com>
> Reviewed-by: Peter Shier <pshier@google.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index cbc9ea2de28f..6ab974debd44 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -3690,7 +3690,9 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
>  	    vmx->nested.preemption_timer_expired) {
>  		if (block_nested_events)
>  			return -EBUSY;
> -		nested_vmx_vmexit(vcpu, EXIT_REASON_PREEMPTION_TIMER, 0, 0);
> +		if (!vmx_pending_dbg_trap(vcpu))

IMO this one warrants a comment.  It's not immediately obvious that this
only applies to #DBs that are being injected into L2, and that returning
-EBUSY will do the wrong thing.

> +			nested_vmx_vmexit(vcpu, EXIT_REASON_PREEMPTION_TIMER,
> +					  0, 0);

I'd just let the "0, 0);" poke out past 80 chars.

>  		return 0;
>  	}
>  
> -- 
> 2.26.0.110.g2183baf09c-goog
> 
