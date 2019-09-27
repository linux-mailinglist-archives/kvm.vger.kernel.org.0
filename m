Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCA05C07CA
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 16:43:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727159AbfI0Omf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Sep 2019 10:42:35 -0400
Received: from mga06.intel.com ([134.134.136.31]:27990 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726251AbfI0Omf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Sep 2019 10:42:35 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Sep 2019 07:42:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,555,1559545200"; 
   d="scan'208";a="214850422"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga004.fm.intel.com with ESMTP; 27 Sep 2019 07:42:34 -0700
Date:   Fri, 27 Sep 2019 07:42:34 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH] KVM: Don't shrink/grow vCPU halt_poll_ns if host side
 polling is disabled
Message-ID: <20190927144234.GD24889@linux.intel.com>
References: <1569572822-28942-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1569572822-28942-1-git-send-email-wanpengli@tencent.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 27, 2019 at 04:27:02PM +0800, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> Don't waste cycles to shrink/grow vCPU halt_poll_ns if host 
> side polling is disabled.
> 
> Cc: Marcelo Tosatti <mtosatti@redhat.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  virt/kvm/kvm_main.c | 28 +++++++++++++++-------------
>  1 file changed, 15 insertions(+), 13 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index e6de315..b368be4 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2359,20 +2359,22 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
>  	kvm_arch_vcpu_unblocking(vcpu);
>  	block_ns = ktime_to_ns(cur) - ktime_to_ns(start);
>  
> -	if (!vcpu_valid_wakeup(vcpu))
> -		shrink_halt_poll_ns(vcpu);
> -	else if (halt_poll_ns) {
> -		if (block_ns <= vcpu->halt_poll_ns)
> -			;
> -		/* we had a long block, shrink polling */
> -		else if (vcpu->halt_poll_ns && block_ns > halt_poll_ns)
> +	if (!kvm_arch_no_poll(vcpu)) {

Can vcpu->halt_poll_ns be cached and used both here and in the similar
check above?  E.g.:

	unsigned int vcpu_halt_poll_ns;

	vcpu_halt_poll_ns = kvm_arch_no_poll(vcpu) ? 0 : vcpu->halt_poll_ns;

	if (vcpu_halt_poll_ns) {
		...
	}

> +		if (!vcpu_valid_wakeup(vcpu))
>  			shrink_halt_poll_ns(vcpu);
> -		/* we had a short halt and our poll time is too small */
> -		else if (vcpu->halt_poll_ns < halt_poll_ns &&
> -			block_ns < halt_poll_ns)
> -			grow_halt_poll_ns(vcpu);
> -	} else
> -		vcpu->halt_poll_ns = 0;
> +		else if (halt_poll_ns) {
> +			if (block_ns <= vcpu->halt_poll_ns)
> +				;
> +			/* we had a long block, shrink polling */
> +			else if (vcpu->halt_poll_ns && block_ns > halt_poll_ns)
> +				shrink_halt_poll_ns(vcpu);
> +			/* we had a short halt and our poll time is too small */
> +			else if (vcpu->halt_poll_ns < halt_poll_ns &&
> +				block_ns < halt_poll_ns)
> +				grow_halt_poll_ns(vcpu);
> +		} else
> +			vcpu->halt_poll_ns = 0;


Not your code, but it'd be a good time to add braces to the 'if' and
'else'.  Per Documentation/process/coding-style.rst:

  Do not unnecessarily use braces where a single statement will do.

  ...

  This does not apply if only one branch of a conditional statement is a single
  statement; in the latter case use braces in both branches:

        if (condition) {
                do_this();
                do_that();
        } else {
                otherwise();
        }


> +	}
>  
>  	trace_kvm_vcpu_wakeup(block_ns, waited, vcpu_valid_wakeup(vcpu));
>  	kvm_arch_vcpu_block_finish(vcpu);
> -- 
> 2.7.4
> 
