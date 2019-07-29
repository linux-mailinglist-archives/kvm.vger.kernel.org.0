Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7AB1790D0
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2019 18:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387557AbfG2Q2S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Jul 2019 12:28:18 -0400
Received: from mga12.intel.com ([192.55.52.136]:4210 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387549AbfG2Q2R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Jul 2019 12:28:17 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jul 2019 09:28:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,323,1559545200"; 
   d="scan'208";a="346698348"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga005.jf.intel.com with ESMTP; 29 Jul 2019 09:28:15 -0700
Date:   Mon, 29 Jul 2019 09:28:15 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Peter Xu <zhexu@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        peterx@redhat.com
Subject: Re: [PATCH 1/3] KVM: X86: Trace vcpu_id for vmexit
Message-ID: <20190729162815.GF21120@linux.intel.com>
References: <20190729053243.9224-1-peterx@redhat.com>
 <20190729053243.9224-2-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190729053243.9224-2-peterx@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 29, 2019 at 01:32:41PM +0800, Peter Xu wrote:
> It helps to pair vmenters and vmexis with multi-core systems.

Typo "vmexis".  The wording is also a bit funky.  How about:

Tracing the ID helps to pair vmenters and vmexits for guests with
multiple vCPUs.

> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  arch/x86/kvm/trace.h | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> index 4d47a2631d1f..26423d2e45df 100644
> --- a/arch/x86/kvm/trace.h
> +++ b/arch/x86/kvm/trace.h
> @@ -232,17 +232,20 @@ TRACE_EVENT(kvm_exit,
>  		__field(	u32,	        isa             )
>  		__field(	u64,	        info1           )
>  		__field(	u64,	        info2           )
> +		__field(	int,	        vcpu_id         )
>  	),
>  
>  	TP_fast_assign(
>  		__entry->exit_reason	= exit_reason;
>  		__entry->guest_rip	= kvm_rip_read(vcpu);
>  		__entry->isa            = isa;
> +		__entry->vcpu_id        = vcpu->vcpu_id;
>  		kvm_x86_ops->get_exit_info(vcpu, &__entry->info1,
>  					   &__entry->info2);
>  	),
>  
> -	TP_printk("reason %s rip 0x%lx info %llx %llx",
> +	TP_printk("vcpu %d reason %s rip 0x%lx info %llx %llx",
> +		  __entry->vcpu_id,
>  		 (__entry->isa == KVM_ISA_VMX) ?
>  		 __print_symbolic(__entry->exit_reason, VMX_EXIT_REASONS) :
>  		 __print_symbolic(__entry->exit_reason, SVM_EXIT_REASONS),
> -- 
> 2.21.0
> 
