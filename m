Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF8F3C0A43
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 19:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727682AbfI0RYN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Sep 2019 13:24:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58738 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726027AbfI0RYM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Sep 2019 13:24:12 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 432CE898112;
        Fri, 27 Sep 2019 17:24:12 +0000 (UTC)
Received: from amt.cnet (ovpn-112-2.gru2.redhat.com [10.97.112.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4693D1001938;
        Fri, 27 Sep 2019 17:24:09 +0000 (UTC)
Received: from amt.cnet (localhost [127.0.0.1])
        by amt.cnet (Postfix) with ESMTP id 1AA6710515E;
        Fri, 27 Sep 2019 12:50:06 -0300 (BRT)
Received: (from marcelo@localhost)
        by amt.cnet (8.14.7/8.14.7/Submit) id x8RFo2cC012646;
        Fri, 27 Sep 2019 12:50:02 -0300
Date:   Fri, 27 Sep 2019 12:50:02 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH] KVM: Don't shrink/grow vCPU halt_poll_ns if host side
 polling is disabled
Message-ID: <20190927154958.GB11810@amt.cnet>
References: <1569572822-28942-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1569572822-28942-1-git-send-email-wanpengli@tencent.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.67]); Fri, 27 Sep 2019 17:24:12 +0000 (UTC)
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
> +	}
>  
>  	trace_kvm_vcpu_wakeup(block_ns, waited, vcpu_valid_wakeup(vcpu));
>  	kvm_arch_vcpu_block_finish(vcpu);
> -- 
> 2.7.4

Looks good.

