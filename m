Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F9C7A8DBC
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2019 21:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730261AbfIDRc4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Sep 2019 13:32:56 -0400
Received: from mga12.intel.com ([192.55.52.136]:39841 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729594AbfIDRcz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Sep 2019 13:32:55 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Sep 2019 10:32:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,467,1559545200"; 
   d="scan'208";a="199078363"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga001.fm.intel.com with ESMTP; 04 Sep 2019 10:32:54 -0700
Date:   Wed, 4 Sep 2019 10:32:54 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: Re: [PATCH v2 3/3] KVM: X86: Tune PLE Window tracepoint
Message-ID: <20190904173254.GJ24079@linux.intel.com>
References: <20190815103458.23207-1-peterx@redhat.com>
 <20190815103458.23207-4-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190815103458.23207-4-peterx@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 15, 2019 at 06:34:58PM +0800, Peter Xu wrote:
> The PLE window tracepoint triggers even if the window is not changed,
> and the wording can be a bit confusing too.  One example line:
> 
>   kvm_ple_window: vcpu 0: ple_window 4096 (shrink 4096)
> 
> It easily let people think of "the window now is 4096 which is
> shrinked", but the truth is the value actually didn't change (4096).
> 
> Let's only dump this message if the value really changed, and we make
> the message even simpler like:
> 
>   kvm_ple_window: vcpu 4 old 4096 new 8192 (growed)
> 
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  arch/x86/kvm/svm.c     | 16 ++++++++--------
>  arch/x86/kvm/trace.h   | 21 ++++++---------------
>  arch/x86/kvm/vmx/vmx.c | 14 ++++++++------
>  arch/x86/kvm/x86.c     |  2 +-
>  4 files changed, 23 insertions(+), 30 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index d685491fce4d..d5cb6b5a9254 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -1269,11 +1269,11 @@ static void grow_ple_window(struct kvm_vcpu *vcpu)
>  							pause_filter_count_grow,
>  							pause_filter_count_max);
>  
> -	if (control->pause_filter_count != old)
> +	if (control->pause_filter_count != old) {
>  		mark_dirty(svm->vmcb, VMCB_INTERCEPTS);
> -
> -	trace_kvm_ple_window_grow(vcpu->vcpu_id,
> -				  control->pause_filter_count, old);
> +		trace_kvm_ple_window_update(vcpu->vcpu_id,
> +					    control->pause_filter_count, old);
> +	}
>  }
>  
>  static void shrink_ple_window(struct kvm_vcpu *vcpu)
> @@ -1287,11 +1287,11 @@ static void shrink_ple_window(struct kvm_vcpu *vcpu)
>  						    pause_filter_count,
>  						    pause_filter_count_shrink,
>  						    pause_filter_count);
> -	if (control->pause_filter_count != old)
> +	if (control->pause_filter_count != old) {
>  		mark_dirty(svm->vmcb, VMCB_INTERCEPTS);
> -
> -	trace_kvm_ple_window_shrink(vcpu->vcpu_id,
> -				    control->pause_filter_count, old);
> +		trace_kvm_ple_window_update(vcpu->vcpu_id,
> +					    control->pause_filter_count, old);
> +	}
>  }
>  
>  static __init int svm_hardware_setup(void)
> diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> index 76a39bc25b95..97df9d7cae71 100644
> --- a/arch/x86/kvm/trace.h
> +++ b/arch/x86/kvm/trace.h
> @@ -890,36 +890,27 @@ TRACE_EVENT(kvm_pml_full,
>  	TP_printk("vcpu %d: PML full", __entry->vcpu_id)
>  );
>  
> -TRACE_EVENT(kvm_ple_window,
> -	TP_PROTO(bool grow, unsigned int vcpu_id, int new, int old),
> -	TP_ARGS(grow, vcpu_id, new, old),
> +TRACE_EVENT(kvm_ple_window_update,
> +	TP_PROTO(unsigned int vcpu_id, int new, int old),
> +	TP_ARGS(vcpu_id, new, old),
>  
>  	TP_STRUCT__entry(
> -		__field(                bool,      grow         )
>  		__field(        unsigned int,   vcpu_id         )
>  		__field(                 int,       new         )
>  		__field(                 int,       old         )

Not your code, but these should really be 'unsigned int', especially now
that they are directly compared when printing "growed" versus "shrinked".
For SVM it doesn't matter since the underlying hardware fields are only
16 bits, but on VMX they're 32 bits, e.g. theoretically userspace could
set ple_window and ple_window_max to a negative value.

The ple_window variable in struct vcpu_vmx and local snapshots of the
field should also be updated, but that can be done separately.

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
> +	TP_printk("vcpu %u old %d new %d (%s)",
> +	          __entry->vcpu_id, __entry->old, __entry->new,
> +		  __entry->old < __entry->new ? "growed" : "shrinked")
>  );
>  
> -#define trace_kvm_ple_window_grow(vcpu_id, new, old) \
> -	trace_kvm_ple_window(true, vcpu_id, new, old)
> -#define trace_kvm_ple_window_shrink(vcpu_id, new, old) \
> -	trace_kvm_ple_window(false, vcpu_id, new, old)
> -
>  TRACE_EVENT(kvm_pvclock_update,
>  	TP_PROTO(unsigned int vcpu_id, struct pvclock_vcpu_time_info *pvclock),
>  	TP_ARGS(vcpu_id, pvclock),
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 42ed3faa6af8..469c4134a4a7 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -5233,10 +5233,11 @@ static void grow_ple_window(struct kvm_vcpu *vcpu)
>  					    ple_window_grow,
>  					    ple_window_max);
>  
> -	if (vmx->ple_window != old)
> +	if (vmx->ple_window != old) {
>  		vmx->ple_window_dirty = true;
> -
> -	trace_kvm_ple_window_grow(vcpu->vcpu_id, vmx->ple_window, old);
> +		trace_kvm_ple_window_update(vcpu->vcpu_id,
> +					    vmx->ple_window, old);
> +	}
>  }
>  
>  static void shrink_ple_window(struct kvm_vcpu *vcpu)
> @@ -5248,10 +5249,11 @@ static void shrink_ple_window(struct kvm_vcpu *vcpu)
>  					      ple_window_shrink,
>  					      ple_window);
>  
> -	if (vmx->ple_window != old)
> +	if (vmx->ple_window != old) {
>  		vmx->ple_window_dirty = true;
> -
> -	trace_kvm_ple_window_shrink(vcpu->vcpu_id, vmx->ple_window, old);
> +		trace_kvm_ple_window_update(vcpu->vcpu_id,
> +					    vmx->ple_window, old);
> +	}
>  }
>  
>  /*
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 93b0bd45ac73..69ad184edc90 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10082,7 +10082,7 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_invlpga);
>  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_skinit);
>  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_intercepts);
>  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_write_tsc_offset);
> -EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_ple_window);
> +EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_ple_window_update);
>  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_pml_full);
>  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_pi_irte_update);
>  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_unaccelerated_access);
> -- 
> 2.21.0
> 
