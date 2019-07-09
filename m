Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D09FB63845
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2019 16:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726060AbfGIO4v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jul 2019 10:56:51 -0400
Received: from mga03.intel.com ([134.134.136.65]:54008 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726055AbfGIO4v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Jul 2019 10:56:51 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Jul 2019 07:56:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,470,1557212400"; 
   d="scan'208";a="168003295"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.165])
  by orsmga003.jf.intel.com with ESMTP; 09 Jul 2019 07:56:50 -0700
Date:   Tue, 9 Jul 2019 07:56:50 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Wei Yang <w90p710@gmail.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH] KVM: x86: Fix guest time accounting with
 VIRT_CPU_ACCOUNTING_GEN
Message-ID: <20190709145650.GC25369@linux.intel.com>
References: <20190708164751.88385-1-w90p710@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190708164751.88385-1-w90p710@gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 09, 2019 at 12:47:51AM +0800, Wei Yang wrote:
> move guest_exit() after local_irq_eanbled() so that the timer interrupt
> hits we account that tick as spent in the guest.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Wei Yang <w90p710@gmail.com>
> ---
>  arch/x86/kvm/x86.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 2e302e977dac..04a2913f9226 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8044,7 +8044,6 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  
>  	++vcpu->stat.exits;
>  
> -	guest_exit_irqoff();
>  	if (lapic_in_kernel(vcpu)) {
>  		s64 delta = vcpu->arch.apic->lapic_timer.advance_expire_delta;
>  		if (delta != S64_MIN) {
> @@ -8054,6 +8053,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  	}
>  
>  	local_irq_enable();
> +	guest_exit();

The tracing invoked by trace_kvm_wait_lapic_expire() needs to be done
after guest exit, otherwise it will violate the RCU quiescent state.  See
commits:

  8b89fe1f6c43 ("kvm: x86: move tracepoints outside extended quiescent state")
  ec0671d5684a ("KVM: LAPIC: Delay trace_kvm_wait_lapic_expire tracepoint to after vmexit")

Is this an actual issue in practice, or was this prompted by code
inspection?

On SVM, this patch is essentially a nop as irqs are temporarily enabled by
svm_handle_exit_irqoff().  On VMX, this only applies to ticks that occur
between VM-Exit and local_irq_enable(), which is a fairly small window all
things considered.  Toggling irqs off and back on in guest_exit() seems
like a waste of cycles, and could introduce other inaccuracies on VMX,
e.g. if non-tick interrupts are taken and cause the tick to expire.

>  	preempt_enable();
>  
>  	vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
> -- 
> 2.14.1.40.g8e62ba1
> 
