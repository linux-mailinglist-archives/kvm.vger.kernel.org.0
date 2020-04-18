Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6FBC1AE9C5
	for <lists+kvm@lfdr.de>; Sat, 18 Apr 2020 06:24:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725796AbgDREVJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 18 Apr 2020 00:21:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:28927 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725440AbgDREVJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 18 Apr 2020 00:21:09 -0400
IronPort-SDR: CyjN/EZd1nSOUolKGpZkQsBAbPUZyVsIAKSIWCr6lc5vbW2up3TSy2Y3m85bhIlkPMPLTyc453
 fhD81+TwI6Ug==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2020 21:21:08 -0700
IronPort-SDR: EeDMeTxG/9QI+Cx3T0w0VnOhBXrELvbzxnj47ajg2x3hW7cF6VCQpeOBpfrAqFH3smV9hpU/fp
 moUUP01Wus9Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,397,1580803200"; 
   d="scan'208";a="257786037"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga006.jf.intel.com with ESMTP; 17 Apr 2020 21:21:08 -0700
Date:   Fri, 17 Apr 2020 21:21:08 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm list <kvm@vger.kernel.org>, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Subject: Re: [PATCH 2/2] kvm: nVMX: Single-step traps trump expired
 VMX-preemption timer
Message-ID: <20200418042108.GF15609@linux.intel.com>
References: <20200414000946.47396-1-jmattson@google.com>
 <20200414000946.47396-2-jmattson@google.com>
 <20200414031705.GP21204@linux.intel.com>
 <CALMp9eT23AUTU3m_oADKw3O_NMpuX3crx7eqSB8Rbgh3k0s_Jw@mail.gmail.com>
 <20200415001212.GA12547@linux.intel.com>
 <CALMp9eS-s5doptTzVkE2o9jDYuGU3T=5azMhm3fCqLJPcABAOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eS-s5doptTzVkE2o9jDYuGU3T=5azMhm3fCqLJPcABAOg@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 15, 2020 at 04:33:31PM -0700, Jim Mattson wrote:
> On Tue, Apr 14, 2020 at 5:12 PM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > On Tue, Apr 14, 2020 at 09:47:53AM -0700, Jim Mattson wrote:
> > > Regarding -EBUSY, I'm in complete agreement. However, I'm not sure
> > > what the potential confusion is regarding the event. Are you
> > > suggesting that one might think that we have a #DB to deliver to L1
> > > while we're in guest mode? IIRC, that can happen under SVM, but I
> > > don't believe it can happen under VMX.
> >
> > The potential confusion is that vcpu->arch.exception.pending was already
> > checked, twice.  It makes one wonder why it needs to be checked a third
> > time.  And actually, I think that's probably a good indicator that singling
> > out single-step #DB isn't the correct fix, it just happens to be the only
> > case that's been encountered thus far, e.g. a #PF when fetching the instr
> > for emulation should also get priority over the preemption timer.  On real
> > hardware, expiration of the preemption timer while vectoring a #PF wouldn't
> > wouldn't get recognized until the next instruction boundary, i.e. at the
> > start of the first instruction of the #PF handler.  Dropping the #PF isn't
> > a problem in most cases, because unlike the single-step #DB, it will be
> > re-encountered when L1 resumes L2.  But, dropping the #PF is still wrong.
> 
> Yes, it's wrong in the abstract, but with respect to faults and the
> VMX-preemption timer expiration, is there any way for either L1 or L2
> to *know* that the virtual CPU has done something wrong?

I don't think so?  But how is that relevant, i.e. if we can fix KVM instead
of fudging the result, why wouldn't we fix KVM?

> Isn't it generally true that if you have an exception queued when you
> transition from L2 to L1, then you've done something wrong? I wonder
> if the call to kvm_clear_exception_queue() in prepare_vmcs12() just
> serves to sweep a whole collection of problems under the rug.

More than likely, yes.

> > In general, interception of an event doesn't change the priority of events,
> > e.g. INTR shouldn't get priority over NMI just because if L1 wants to
> > intercept INTR but not NMI.
> 
> Yes, but that's a different problem altogether.

But isn't the fix the same?  Stop processing events if a higher priority
event is pending, regardless of whether the event exits to L1.

> > TL;DR: I think the fix should instead be:
> >
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index c868c64770e0..042d7a9037be 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -3724,9 +3724,10 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
> >         /*
> >          * Process any exceptions that are not debug traps before MTF.
> >          */
> > -       if (vcpu->arch.exception.pending &&
> > -           !vmx_pending_dbg_trap(vcpu) &&
> > -           nested_vmx_check_exception(vcpu, &exit_qual)) {
> > +       if (vcpu->arch.exception.pending && !vmx_pending_dbg_trap(vcpu))
> > +               if (!nested_vmx_check_exception(vcpu, &exit_qual))
> > +                       return 0;
> > +
> >                 if (block_nested_events)
> >                         return -EBUSY;
> >                 nested_vmx_inject_exception_vmexit(vcpu, exit_qual);
> > @@ -3741,8 +3742,10 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
> >                 return 0;
> >         }
> >
> > -       if (vcpu->arch.exception.pending &&
> > -           nested_vmx_check_exception(vcpu, &exit_qual)) {
> > +       if (vcpu->arch.exception.pending) {
> > +               if (!nested_vmx_check_exception(vcpu, &exit_qual))
> > +                       return 0;
> > +
> >                 if (block_nested_events)
> >                         return -EBUSY;
> >                 nested_vmx_inject_exception_vmexit(vcpu, exit_qual);
> > @@ -3757,7 +3760,10 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
> >                 return 0;
> >         }
> >
> > -       if (vcpu->arch.nmi_pending && nested_exit_on_nmi(vcpu)) {
> > +       if (vcpu->arch.nmi_pending) {
> > +               if (!nested_exit_on_nmi(vcpu))
> > +                       return 0;
> > +
> >                 if (block_nested_events)
> >                         return -EBUSY;
> >                 nested_vmx_vmexit(vcpu, EXIT_REASON_EXCEPTION_NMI,
> > @@ -3772,7 +3778,10 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
> >                 return 0;
> >         }
> >
> > -       if (kvm_cpu_has_interrupt(vcpu) && nested_exit_on_intr(vcpu)) {
> > +       if (kvm_cpu_has_interrupt(vcpu) {
> > +               if (!nested_exit_on_intr(vcpu))
> > +                       return 0;
> > +
> >                 if (block_nested_events)
> >                         return -EBUSY;
> >                 nested_vmx_vmexit(vcpu, EXIT_REASON_EXTERNAL_INTERRUPT, 0, 0);
> >
