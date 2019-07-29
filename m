Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99912790BA
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2019 18:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728809AbfG2QXm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Jul 2019 12:23:42 -0400
Received: from mga03.intel.com ([134.134.136.65]:64001 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727576AbfG2QXm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Jul 2019 12:23:42 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jul 2019 09:23:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,323,1559545200"; 
   d="scan'208";a="179428010"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by FMSMGA003.fm.intel.com with ESMTP; 29 Jul 2019 09:23:39 -0700
Date:   Mon, 29 Jul 2019 09:23:38 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Peter Xu <zhexu@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        peterx@redhat.com
Subject: Re: [PATCH 3/3] KVM: X86: Tune PLE Window tracepoint
Message-ID: <20190729162338.GE21120@linux.intel.com>
References: <20190729053243.9224-1-peterx@redhat.com>
 <20190729053243.9224-4-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190729053243.9224-4-peterx@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 29, 2019 at 01:32:43PM +0800, Peter Xu wrote:
> The PLE window tracepoint triggers easily and it can be a bit
> confusing too.  One example line:
> 
>   kvm_ple_window: vcpu 0: ple_window 4096 (shrink 4096)
> 
> It easily let people think of "the window now is 4096 which is
> shrinked", but the truth is the value actually didn't change (4096).
> 
> Let's only dump this message if the value really changed, and we make
> the message even simpler like:
> 
>   kvm_ple_window: vcpu 4 (4096 -> 8192)

This seems a bit too terse, e.g. requires a decent amount of effort to
do relatively simple things like show only cases where the windows was
shrunk, or grew/shrunk by a large amount.  In this case, more is likely
better, e.g.: 

  kvm_ple_window_changed: vcpu 4 ple_window 8192 old 4096 grow 4096

and

  kvm_ple_window_changed: vcpu 4 ple_window 4096 old 8192 shrink 4096


Tangentially related, it'd be nice to settle on a standard format for
printing field+val.  Right now there are four different styles, e.g.
"field=val", "field = val", "field: val" and "field val".

> 
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  arch/x86/kvm/svm.c     |  8 ++++----
>  arch/x86/kvm/trace.h   | 22 +++++++++-------------
>  arch/x86/kvm/vmx/vmx.c |  4 ++--
>  3 files changed, 15 insertions(+), 19 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 48c865a4e5dd..0d365b621b5a 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -1268,8 +1268,8 @@ static void grow_ple_window(struct kvm_vcpu *vcpu)
>  	if (control->pause_filter_count != old)
>  		mark_dirty(svm->vmcb, VMCB_INTERCEPTS);
>  
> -	trace_kvm_ple_window_grow(vcpu->vcpu_id,
> -				  control->pause_filter_count, old);
> +	trace_kvm_ple_window_changed(vcpu->vcpu_id,
> +				     control->pause_filter_count, old);
>  }
>  
>  static void shrink_ple_window(struct kvm_vcpu *vcpu)
> @@ -1286,8 +1286,8 @@ static void shrink_ple_window(struct kvm_vcpu *vcpu)
>  	if (control->pause_filter_count != old)
>  		mark_dirty(svm->vmcb, VMCB_INTERCEPTS);
>  
> -	trace_kvm_ple_window_shrink(vcpu->vcpu_id,
> -				    control->pause_filter_count, old);
> +	trace_kvm_ple_window_changed(vcpu->vcpu_id,
> +				     control->pause_filter_count, old);
>  }
>  
>  static __init int svm_hardware_setup(void)
> diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> index 76a39bc25b95..91c91f358b23 100644
> --- a/arch/x86/kvm/trace.h
> +++ b/arch/x86/kvm/trace.h
> @@ -891,34 +891,30 @@ TRACE_EVENT(kvm_pml_full,
>  );
>  
>  TRACE_EVENT(kvm_ple_window,
> -	TP_PROTO(bool grow, unsigned int vcpu_id, int new, int old),
> -	TP_ARGS(grow, vcpu_id, new, old),
> +	TP_PROTO(unsigned int vcpu_id, int new, int old),
> +	TP_ARGS(vcpu_id, new, old),
>  
>  	TP_STRUCT__entry(
> -		__field(                bool,      grow         )

Side note, if the tracepoint is invoked only on changes the "grow" field
can be removed even if the tracepoint prints grow vs. shrink, i.e. there's
no ambiguity since new==old will never happen.

>  		__field(        unsigned int,   vcpu_id         )
>  		__field(                 int,       new         )
>  		__field(                 int,       old         )
>  	),
>  
>  	TP_fast_assign(
> -		__entry->grow           = grow;
>  		__entry->vcpu_id        = vcpu_id;
>  		__entry->new            = new;
>  		__entry->old            = old;
>  	),
>  
> -	TP_printk("vcpu %u: ple_window %d (%s %d)",
> -	          __entry->vcpu_id,
> -	          __entry->new,
> -	          __entry->grow ? "grow" : "shrink",
> -	          __entry->old)
> +	TP_printk("vcpu %u (%d -> %d)",
> +	          __entry->vcpu_id, __entry->old, __entry->new)
>  );
>  
> -#define trace_kvm_ple_window_grow(vcpu_id, new, old) \
> -	trace_kvm_ple_window(true, vcpu_id, new, old)
> -#define trace_kvm_ple_window_shrink(vcpu_id, new, old) \
> -	trace_kvm_ple_window(false, vcpu_id, new, old)
> +#define trace_kvm_ple_window_changed(vcpu, new, old)		\
> +	do {							\
> +		if (old != new)					\
> +			trace_kvm_ple_window(vcpu, new, old);	\
> +	} while (0)
>  
>  TRACE_EVENT(kvm_pvclock_update,
>  	TP_PROTO(unsigned int vcpu_id, struct pvclock_vcpu_time_info *pvclock),
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index d98eac371c0a..cc1f98130e6a 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -5214,7 +5214,7 @@ static void grow_ple_window(struct kvm_vcpu *vcpu)
>  	if (vmx->ple_window != old)
>  		vmx->ple_window_dirty = true;
>  
> -	trace_kvm_ple_window_grow(vcpu->vcpu_id, vmx->ple_window, old);
> +	trace_kvm_ple_window_changed(vcpu->vcpu_id, vmx->ple_window, old);

No need for the macro, the snippet right about already checks 'new != old'.
Though I do like the rename, i.e. rename the trace function to
trace_kvm_ple_window_changed().

>  }
>  
>  static void shrink_ple_window(struct kvm_vcpu *vcpu)
> @@ -5229,7 +5229,7 @@ static void shrink_ple_window(struct kvm_vcpu *vcpu)
>  	if (vmx->ple_window != old)
>  		vmx->ple_window_dirty = true;
>  
> -	trace_kvm_ple_window_shrink(vcpu->vcpu_id, vmx->ple_window, old);
> +	trace_kvm_ple_window_changed(vcpu->vcpu_id, vmx->ple_window, old);
>  }
>  
>  /*
> -- 
> 2.21.0
> 
