Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ECAE1B4EC8
	for <lists+kvm@lfdr.de>; Wed, 22 Apr 2020 23:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbgDVVGu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Apr 2020 17:06:50 -0400
Received: from mga04.intel.com ([192.55.52.120]:52075 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725779AbgDVVGu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Apr 2020 17:06:50 -0400
IronPort-SDR: YuJpB8DaIrqSjs7JPcNR7MugHrwUWGnxDFg16+VVz2kaMGjx2HIjLXHkkwdEfCZaCbzKgCsvzp
 QjgVvy70rA1g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2020 14:06:49 -0700
IronPort-SDR: ashm6OgPKQzJXJ5C/L+irWtgD/CQXghBzpfatTWZjiEDUxSlRaCRyZEJx3B3mFKBQ2KfYmq+xj
 eTlu1d4t3ecw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,304,1583222400"; 
   d="scan'208";a="244643749"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga007.jf.intel.com with ESMTP; 22 Apr 2020 14:06:49 -0700
Date:   Wed, 22 Apr 2020 14:06:49 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Subject: Re: [PATCH 1/2] kvm: nVMX: Pending debug exceptions trump expired
 VMX-preemption timer
Message-ID: <20200422210649.GA5823@linux.intel.com>
References: <20200414000946.47396-1-jmattson@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200414000946.47396-1-jmattson@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 13, 2020 at 05:09:45PM -0700, Jim Mattson wrote:
> Fixes: f4124500c2c13 ("KVM: nVMX: Fully emulate preemption timer")
> Signed-off-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Oliver Upton <oupton@google.com>
> Reviewed-by: Peter Shier <pshier@google.com>

...

> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 83050977490c..aae01253bfba 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4682,7 +4682,7 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
>  			if (is_icebp(intr_info))
>  				WARN_ON(!skip_emulated_instruction(vcpu));
>  
> -			kvm_queue_exception(vcpu, DB_VECTOR);
> +			kvm_requeue_exception(vcpu, DB_VECTOR);

This isn't wrong per se, but it's effectively papering over an underlying
bug, e.g. the same missed preemption timer bug can manifest if the timer
expires while in KVM context (because the hr timer is left running) and KVM
queues an exception for _any_ reason.  Most of the scenarios where L0 will
queue an exception for L2 are fairly contrived, but they are possible.

I believe the correct fix is to open a "preemption timer window" like we do
for pending SMI, NMI and IRQ.  It's effectively the same handling a pending
SMI on VMX, set req_immediate_exit in the !inject_pending_event() path.

Patches incoming soon-ish, think I've finally got my head wrapped around all
the combinations, though I also thought that was true several hours ago...

>  			return 1;
>  		}
>  		kvm_run->debug.arch.dr6 = dr6 | DR6_FIXED_1;
> @@ -4703,7 +4703,7 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
>  		break;
>  	case AC_VECTOR:
>  		if (guest_inject_ac(vcpu)) {
> -			kvm_queue_exception_e(vcpu, AC_VECTOR, error_code);
> +			kvm_requeue_exception_e(vcpu, AC_VECTOR, error_code);
>  			return 1;
>  		}
>  
> -- 
> 2.26.0.110.g2183baf09c-goog
> 
