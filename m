Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4933CBB9BA
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2019 18:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389238AbfIWQhr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 12:37:47 -0400
Received: from mga01.intel.com ([192.55.52.88]:60880 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389180AbfIWQhr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 12:37:47 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Sep 2019 09:37:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,541,1559545200"; 
   d="scan'208";a="389536570"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga006.fm.intel.com with ESMTP; 23 Sep 2019 09:37:46 -0700
Date:   Mon, 23 Sep 2019 09:37:46 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Andrea Arcangeli <aarcange@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/17] KVM: retpolines: x86: eliminate retpoline from
 vmx.c exit handlers
Message-ID: <20190923163746.GE18195@linux.intel.com>
References: <20190920212509.2578-1-aarcange@redhat.com>
 <20190920212509.2578-16-aarcange@redhat.com>
 <87o8zb8ik1.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87o8zb8ik1.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 23, 2019 at 11:31:58AM +0200, Vitaly Kuznetsov wrote:
> Andrea Arcangeli <aarcange@redhat.com> writes:
> 
> > It's enough to check the exit value and issue a direct call to avoid
> > the retpoline for all the common vmexit reasons.
> >
> > Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> > ---
> >  arch/x86/kvm/vmx/vmx.c | 24 ++++++++++++++++++++++--
> >  1 file changed, 22 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index a6e597025011..9aa73e216df2 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -5866,9 +5866,29 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu)
> >  	}
> >  
> >  	if (exit_reason < kvm_vmx_max_exit_handlers
> > -	    && kvm_vmx_exit_handlers[exit_reason])
> > +	    && kvm_vmx_exit_handlers[exit_reason]) {
> > +#ifdef CONFIG_RETPOLINE
> > +		if (exit_reason == EXIT_REASON_MSR_WRITE)
> > +			return handle_wrmsr(vcpu);
> > +		else if (exit_reason == EXIT_REASON_PREEMPTION_TIMER)
> > +			return handle_preemption_timer(vcpu);
> > +		else if (exit_reason == EXIT_REASON_PENDING_INTERRUPT)
> > +			return handle_interrupt_window(vcpu);
> > +		else if (exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT)
> > +			return handle_external_interrupt(vcpu);
> > +		else if (exit_reason == EXIT_REASON_HLT)
> > +			return handle_halt(vcpu);
> > +		else if (exit_reason == EXIT_REASON_PAUSE_INSTRUCTION)
> > +			return handle_pause(vcpu);
> > +		else if (exit_reason == EXIT_REASON_MSR_READ)
> > +			return handle_rdmsr(vcpu);
> > +		else if (exit_reason == EXIT_REASON_CPUID)
> > +			return handle_cpuid(vcpu);
> > +		else if (exit_reason == EXIT_REASON_EPT_MISCONFIG)
> > +			return handle_ept_misconfig(vcpu);
> > +#endif
> >  		return kvm_vmx_exit_handlers[exit_reason](vcpu);
> 
> I agree with the identified set of most common vmexits, however, this
> still looks a bit random. Would it be too much if we get rid of
> kvm_vmx_exit_handlers completely replacing this code with one switch()?

Hmm, that'd require redirects for nVMX functions since they are set at
runtime.  That isn't necessarily a bad thing.  The approach could also be
used if Paolo's idea of making kvm_vmx_max_exit_handlers const allows the
compiler to avoid retpoline.

E.g.:

static int handle_vmx_instruction(struct kvm_vcpu *vcpu)
{
	if (nested)
		return nested_vmx_handle_exit(vcpu);

	kvm_queue_exception(vcpu, UD_VECTOR);
	return 1;
}
