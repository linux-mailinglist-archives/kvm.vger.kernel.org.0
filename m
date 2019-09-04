Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6A5FA8DB0
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2019 21:32:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731818AbfIDR1A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Sep 2019 13:27:00 -0400
Received: from mga11.intel.com ([192.55.52.93]:31066 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731676AbfIDR1A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Sep 2019 13:27:00 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Sep 2019 10:26:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,467,1559545200"; 
   d="scan'208";a="183970561"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga007.fm.intel.com with ESMTP; 04 Sep 2019 10:26:59 -0700
Date:   Wed, 4 Sep 2019 10:26:58 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: Re: [PATCH v2 1/3] KVM: X86: Trace vcpu_id for vmexit
Message-ID: <20190904172658.GH24079@linux.intel.com>
References: <20190815103458.23207-1-peterx@redhat.com>
 <20190815103458.23207-2-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190815103458.23207-2-peterx@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 15, 2019 at 06:34:56PM +0800, Peter Xu wrote:
> Tracing the ID helps to pair vmenters and vmexits for guests with
> multiple vCPUs.
> 
> Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  arch/x86/kvm/trace.h | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> index b5c831e79094..c682f3f7f998 100644
> --- a/arch/x86/kvm/trace.h
> +++ b/arch/x86/kvm/trace.h
> @@ -232,17 +232,20 @@ TRACE_EVENT(kvm_exit,
>  		__field(	u32,	        isa             )
>  		__field(	u64,	        info1           )
>  		__field(	u64,	        info2           )
> +		__field(	int,	        vcpu_id         )

It doesn't actually affect anything, but vcpu_id is stored and printed as
an 'unsigned int' everywhere else in the trace code.  Stylistically I like
that approach even though struct kvm_vcpu holds it as a signed int.

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
