Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25F131BAD09
	for <lists+kvm@lfdr.de>; Mon, 27 Apr 2020 20:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726252AbgD0Smy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Apr 2020 14:42:54 -0400
Received: from mga12.intel.com ([192.55.52.136]:26249 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726223AbgD0Smy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Apr 2020 14:42:54 -0400
IronPort-SDR: ab4v1RvQvQZYo7MJONB2yglj2v1qt3VZR3gxKnv7Ql2STrRSSG+qF8r6F87lP+JkEqz4qkSJdI
 TILaIn7db2AA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2020 11:42:54 -0700
IronPort-SDR: XpoGt/OpVhcESU1Pjd1d9Ljez4WXwDlvyO41N/XKPWTN49Dt8KyUsT3hJso7snho9gkE5n3Soi
 epzqOcMcKKyA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,325,1583222400"; 
   d="scan'208";a="431876032"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga005.jf.intel.com with ESMTP; 27 Apr 2020 11:42:53 -0700
Date:   Mon, 27 Apr 2020 11:42:53 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Haiwei Li <lihaiwei@tencent.com>
Subject: Re: [PATCH v3 5/5] KVM: VMX: Handle preemption timer fastpath
Message-ID: <20200427184253.GR14870@linux.intel.com>
References: <1587709364-19090-1-git-send-email-wanpengli@tencent.com>
 <1587709364-19090-6-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1587709364-19090-6-git-send-email-wanpengli@tencent.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 24, 2020 at 02:22:44PM +0800, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> This patch implements handle preemption timer fastpath, after timer fire 
> due to VMX-preemption timer counts down to zero, handle it as soon as 
> possible and vmentry immediately without checking various kvm stuff when 
> possible.
> 
> Testing on SKX Server.
> 
> cyclictest in guest(w/o mwait exposed, adaptive advance lapic timer is default -1):
> 
> 5540.5ns -> 4602ns       17%
> 
> kvm-unit-test/vmexit.flat:
> 
> w/o avanced timer:
> tscdeadline_immed: 2885    -> 2431.25  15.7%
> tscdeadline:       5668.75 -> 5188.5    8.4%
> 
> w/ adaptive advance timer default -1:
> tscdeadline_immed: 2965.25 -> 2520     15.0%
> tscdeadline:       4663.75 -> 4537      2.7%
> 
> Tested-by: Haiwei Li <lihaiwei@tencent.com>
> Cc: Haiwei Li <lihaiwei@tencent.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index d21b66b..028967a 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6560,12 +6560,28 @@ void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp)
>  	}
>  }
>  
> +static enum exit_fastpath_completion handle_fastpath_preemption_timer(struct kvm_vcpu *vcpu)

Somewhat offtopic, would it make sense to add a fastpath_t typedef?  These
enum lines are a bit long...

> +{
> +	struct vcpu_vmx *vmx = to_vmx(vcpu);
> +
> +	if (!vmx->req_immediate_exit &&
> +		!unlikely(vmx->loaded_vmcs->hv_timer_soft_disabled)) {

Bad indentation.

Also, this is is identical to handle_preemption_timer(), why not something
like:

static bool __handle_preemption_timer(struct vcpu)
{
	struct vcpu_vmx *vmx = to_vmx(vcpu);

	if (!vmx->req_immediate_exit &&
	    !unlikely(vmx->loaded_vmcs->hv_timer_soft_disabled)) {
		kvm_lapic_expired_hv_timer(vcpu);
		return true;
	}

	return false;
}

static enum exit_fastpath_completion handle_fastpath_preemption_timer(struct kvm_vcpu *vcpu)
{
	if (__handle_preemption_timer(vcpu))
		return EXIT_FASTPATH_CONT_RUN;
	return EXIT_FASTPATH_NONE;
}

static int handle_preemption_timer(struct kvm_vcpu *vcpu)
{
	__handle_preemption_timer(vcpu);
	return 1;
}

> +		kvm_lapic_expired_hv_timer(vcpu);
> +		trace_kvm_exit(EXIT_REASON_PREEMPTION_TIMER, vcpu, KVM_ISA_VMX);
> +		return EXIT_FASTPATH_CONT_RUN;
> +	}
> +
> +	return EXIT_FASTPATH_NONE;
> +}
> +
>  static enum exit_fastpath_completion vmx_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
>  {
>  	if (!is_guest_mode(vcpu) && vcpu->arch.apicv_active) {
>  		switch (to_vmx(vcpu)->exit_reason) {
>  		case EXIT_REASON_MSR_WRITE:
>  			return handle_fastpath_set_msr_irqoff(vcpu);
> +		case EXIT_REASON_PREEMPTION_TIMER:
> +			return handle_fastpath_preemption_timer(vcpu);
>  		default:
>  			return EXIT_FASTPATH_NONE;
>  		}
> -- 
> 2.7.4
> 
