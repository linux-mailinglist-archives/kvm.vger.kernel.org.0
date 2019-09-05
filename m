Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB72CAA7CB
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2019 17:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389160AbfIEP6Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Sep 2019 11:58:24 -0400
Received: from mga04.intel.com ([192.55.52.120]:15818 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731012AbfIEP6Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Sep 2019 11:58:24 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Sep 2019 08:58:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,470,1559545200"; 
   d="scan'208";a="173991652"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga007.jf.intel.com with ESMTP; 05 Sep 2019 08:58:23 -0700
Date:   Thu, 5 Sep 2019 08:58:23 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: Re: [PATCH v3 4/4] KVM: VMX: Change ple_window type to unsigned int
Message-ID: <20190905155823.GB29019@linux.intel.com>
References: <20190905023616.29082-1-peterx@redhat.com>
 <20190905023616.29082-5-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190905023616.29082-5-peterx@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 05, 2019 at 10:36:16AM +0800, Peter Xu wrote:
> The VMX ple_window is 32 bits wide, so logically it can overflow with
> an int.  The module parameter is declared as unsigned int which is
> good, however the dynamic variable is not.  Switching all the
> ple_window references to use unsigned int.
> 
> The tracepoint changes will also affect SVM, but SVM is using an even
> smaller width (16 bits) so it's always fine.
> 
> Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  arch/x86/kvm/trace.h   | 8 ++++----
>  arch/x86/kvm/vmx/vmx.c | 4 ++--
>  arch/x86/kvm/vmx/vmx.h | 2 +-
>  3 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> index f1177e03768f..ae924566c401 100644
> --- a/arch/x86/kvm/trace.h
> +++ b/arch/x86/kvm/trace.h
> @@ -891,13 +891,13 @@ TRACE_EVENT(kvm_pml_full,
>  );
>  
>  TRACE_EVENT(kvm_ple_window_update,
> -	TP_PROTO(unsigned int vcpu_id, int new, int old),
> +	TP_PROTO(unsigned int vcpu_id, unsigned int new, unsigned int old),
>  	TP_ARGS(vcpu_id, new, old),
>  
>  	TP_STRUCT__entry(
>  		__field(        unsigned int,   vcpu_id         )
> -		__field(                 int,       new         )
> -		__field(                 int,       old         )
> +		__field(        unsigned int,       new         )
> +		__field(        unsigned int,       old         )

Changing the trace event storage needs to be done in patch 3/4, otherwise
we're knowingly introducing a bug (for one commit).  Alternatively, swap
the order of the patches.

>  	),
>  
>  	TP_fast_assign(
> @@ -906,7 +906,7 @@ TRACE_EVENT(kvm_ple_window_update,
>  		__entry->old            = old;
>  	),
>  
> -	TP_printk("vcpu %u old %d new %d (%s)",
> +	TP_printk("vcpu %u old %u new %u (%s)",
>  	          __entry->vcpu_id, __entry->old, __entry->new,
>  		  __entry->old < __entry->new ? "growed" : "shrinked")
>  );
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 469c4134a4a7..1dbb63ffdd6d 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -5227,7 +5227,7 @@ static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
>  static void grow_ple_window(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> -	int old = vmx->ple_window;
> +	unsigned int old = vmx->ple_window;
>  
>  	vmx->ple_window = __grow_ple_window(old, ple_window,
>  					    ple_window_grow,
> @@ -5243,7 +5243,7 @@ static void grow_ple_window(struct kvm_vcpu *vcpu)
>  static void shrink_ple_window(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> -	int old = vmx->ple_window;
> +	unsigned int old = vmx->ple_window;
>  
>  	vmx->ple_window = __shrink_ple_window(old, ple_window,
>  					      ple_window_shrink,
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 82d0bc3a4d52..64d5a4890aa9 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -253,7 +253,7 @@ struct vcpu_vmx {
>  	struct nested_vmx nested;
>  
>  	/* Dynamic PLE window. */
> -	int ple_window;
> +	unsigned int ple_window;
>  	bool ple_window_dirty;
>  
>  	bool req_immediate_exit;
> -- 
> 2.21.0
> 
