Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFBC61A8FAD
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 02:23:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2634577AbgDOAWp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Apr 2020 20:22:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:44555 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2634576AbgDOAWh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Apr 2020 20:22:37 -0400
IronPort-SDR: Oo/+z7nBqZxws5cJXfvDoM+ivnc+jbLi5QBVw4N+xOPqvBS8/GvmsU54f1Ri5DqGcCU+Tzl1nq
 UvKdhyvmVF8Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2020 17:22:34 -0700
IronPort-SDR: 2rw1uq/Y/YtkKgsceRzFm3pCa+ql1LNcQFdjmnclgK3o94OmrMg01ud+hCLW7oyQRoSIDf/IQn
 7z9Hex8NoouA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,384,1580803200"; 
   d="scan'208";a="298849665"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by FMSMGA003.fm.intel.com with ESMTP; 14 Apr 2020 17:22:34 -0700
Date:   Tue, 14 Apr 2020 17:22:34 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm list <kvm@vger.kernel.org>, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Subject: Re: [PATCH 2/2] kvm: nVMX: Single-step traps trump expired
 VMX-preemption timer
Message-ID: <20200415002234.GC12547@linux.intel.com>
References: <20200414000946.47396-1-jmattson@google.com>
 <20200414000946.47396-2-jmattson@google.com>
 <20200414031705.GP21204@linux.intel.com>
 <CALMp9eT23AUTU3m_oADKw3O_NMpuX3crx7eqSB8Rbgh3k0s_Jw@mail.gmail.com>
 <20200415001212.GA12547@linux.intel.com>
 <20200415002044.GB12547@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200415002044.GB12547@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 14, 2020 at 05:20:44PM -0700, Sean Christopherson wrote:
> On Tue, Apr 14, 2020 at 05:12:12PM -0700, Sean Christopherson wrote:
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
> > 
> > In general, interception of an event doesn't change the priority of events,
> > e.g. INTR shouldn't get priority over NMI just because if L1 wants to
> > intercept INTR but not NMI.
> > 
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

*sigh*  And a missing '{' here.

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
> 
> Obviously untested, because this doesn't compile due to a missing ')'.
> 
> > +               if (!nested_exit_on_intr(vcpu))
> > +                       return 0;
> > +
> >                 if (block_nested_events)
> >                         return -EBUSY;
> >                 nested_vmx_vmexit(vcpu, EXIT_REASON_EXTERNAL_INTERRUPT, 0, 0);
> > 
