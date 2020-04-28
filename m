Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20F3C1BB323
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 03:03:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbgD1BDQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Apr 2020 21:03:16 -0400
Received: from mga12.intel.com ([192.55.52.136]:48366 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726263AbgD1BDP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Apr 2020 21:03:15 -0400
IronPort-SDR: ss8XX41GWzOej3rlMf/TJQEHlOqx1fUlKpXqhyP2Z7biAbjH3h7ougJkNoDAYyLBRaxW5TLuK1
 HtfgTELe/fWA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2020 18:03:15 -0700
IronPort-SDR: g76t0Djx48ZE6PbBVETOmC4oPnCumQAPrxsqLiw1myb2aC7mQFYgl0A0AL5/YzOBoC42ZrrF0e
 /16sF2dl88NQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,325,1583222400"; 
   d="scan'208";a="260923278"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga006.jf.intel.com with ESMTP; 27 Apr 2020 18:03:15 -0700
Date:   Mon, 27 Apr 2020 18:03:15 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Haiwei Li <lihaiwei@tencent.com>
Subject: Re: [PATCH v3 2/5] KVM: X86: Introduce need_cancel_enter_guest helper
Message-ID: <20200428010315.GE14870@linux.intel.com>
References: <1587709364-19090-1-git-send-email-wanpengli@tencent.com>
 <1587709364-19090-3-git-send-email-wanpengli@tencent.com>
 <CANRm+CwvTrwmJnFWR8UgEkqyE_fyoc6KmrNuHQj=DuJDkR-UGA@mail.gmail.com>
 <20200427183656.GO14870@linux.intel.com>
 <CANRm+CzdCcz4Vyw-6D5xTc+VmRTr6=O0U=7vfdNLF=LjW5HOEg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANRm+CzdCcz4Vyw-6D5xTc+VmRTr6=O0U=7vfdNLF=LjW5HOEg@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 28, 2020 at 08:44:13AM +0800, Wanpeng Li wrote:
> On Tue, 28 Apr 2020 at 02:36, Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > > @@ -6771,12 +6774,10 @@ static enum exit_fastpath_completion
> > > vmx_vcpu_run(struct kvm_vcpu *vcpu)
> > >      vmx_recover_nmi_blocking(vmx);
> > >      vmx_complete_interrupts(vmx);
> > >
> > > -    if (!(kvm_need_cancel_enter_guest(vcpu))) {
> > > -        exit_fastpath = vmx_exit_handlers_fastpath(vcpu);
> > > -        if (exit_fastpath == EXIT_FASTPATH_CONT_RUN) {
> > > -            vmx_sync_pir_to_irr(vcpu);
> > > -            goto cont_run;
> > > -        }
> > > +    exit_fastpath = vmx_exit_handlers_fastpath(vcpu);
> > > +    if (exit_fastpath == EXIT_FASTPATH_CONT_RUN) {
> >
> > Relying on the handlers to check kvm_need_cancel_enter_guest() will be
> > error prone and costly to maintain.  I also don't like that it buries the
> > logic.
> >
> > What about adding another flavor, e.g.:
> >
> >         exit_fastpath = vmx_exit_handlers_fastpath(vcpu);
> >         if (exit_fastpath == EXIT_FASTPATH_CONT_RUN &&
> >             kvm_need_cancel_enter_guest(vcpu))
> >                 exit_fastpath = EXIT_FASTPATH_NOP;
> >
> > That would also allow you to enable preemption timer without first having
> > to add CONT_RUN, which would be a very good thing for bisection.
> 
> I miss understand the second part, do you mean don't need to add
> CONT_RUN in patch 1/5?

Yes, with the disclaimer that I haven't worked through all the flows to
ensure it's actually doable and/or a good idea. 

The idea is to add EXIT_FASTPATH_NOP and use that for the preemption timer
fastpath.  KVM would still go through it's full run loop, but it would skip
invoking the exit handler.  In theory that would disassociate fast handling
of the preemption timer from resuming the guest without going back to the
run loop, i.e. provide a separate bisection point for enabling CONT_RUN.

Like I said, might not be a good idea, e.g. if preemption timer ends up
being the only user of EXIT_FASTPATH_CONT_RUN then EXIT_FASTPATH_NOP is a
waste of space.

Side topic, what about EXIT_FASTPATH_RESUME instead of CONT_RUN?  Or maybe
REENTER_GUEST?  Something that start with RE :-)
