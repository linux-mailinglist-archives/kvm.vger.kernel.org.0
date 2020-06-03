Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E31501EC743
	for <lists+kvm@lfdr.de>; Wed,  3 Jun 2020 04:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725810AbgFCCYQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jun 2020 22:24:16 -0400
Received: from mga02.intel.com ([134.134.136.20]:14630 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725780AbgFCCYQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Jun 2020 22:24:16 -0400
IronPort-SDR: Fg+aPrISzAGDr4jHS/AMXPVLmwb8wvsas1LMiSnZkloEz9OapG+NxZCIzrdoCnSbW+hxq76/Vy
 mGu8itVzYjHg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2020 19:24:15 -0700
IronPort-SDR: tNy2nn62cX3ruc8KIngYK08o7rjpTA3Knoty3ydGbRuVfgxdznpVxe1I53Mt+ZlWcdjOoZiZQI
 zNVD3hHpfkBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,466,1583222400"; 
   d="scan'208";a="312455531"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by FMSMGA003.fm.intel.com with ESMTP; 02 Jun 2020 19:24:15 -0700
Date:   Tue, 2 Jun 2020 19:24:14 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Liran Alon <liran.alon@oracle.com>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Subject: Re: [PATCH v3 3/4] kvm: vmx: Add last_cpu to struct vcpu_vmx
Message-ID: <20200603022414.GA24364@linux.intel.com>
References: <20200601222416.71303-1-jmattson@google.com>
 <20200601222416.71303-4-jmattson@google.com>
 <20200602012139.GF21661@linux.intel.com>
 <CALMp9eS3XEVdZ-_pRsevOiKRBSbCr96saicxC+stPfUqsM1u1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eS3XEVdZ-_pRsevOiKRBSbCr96saicxC+stPfUqsM1u1A@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 02, 2020 at 10:33:51AM -0700, Jim Mattson wrote:
> On Mon, Jun 1, 2020 at 6:21 PM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > On Mon, Jun 01, 2020 at 03:24:15PM -0700, Jim Mattson wrote:
> > > As we already do in svm, record the last logical processor on which a
> > > vCPU has run, so that it can be communicated to userspace for
> > > potential hardware errors.
> > >
> > > Signed-off-by: Jim Mattson <jmattson@google.com>
> > > Reviewed-by: Oliver Upton <oupton@google.com>
> > > Reviewed-by: Peter Shier <pshier@google.com>
> > > ---
> > >  arch/x86/kvm/vmx/vmx.c | 1 +
> > >  arch/x86/kvm/vmx/vmx.h | 3 +++
> > >  2 files changed, 4 insertions(+)
> > >
> > > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > > index 170cc76a581f..42856970d3b8 100644
> > > --- a/arch/x86/kvm/vmx/vmx.c
> > > +++ b/arch/x86/kvm/vmx/vmx.c
> > > @@ -6730,6 +6730,7 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
> > >       if (vcpu->arch.cr2 != read_cr2())
> > >               write_cr2(vcpu->arch.cr2);
> > >
> > > +     vmx->last_cpu = vcpu->cpu;
> >
> > This is redundant in the EXIT_FASTPATH_REENTER_GUEST case.  Setting it
> > before reenter_guest is technically wrong if emulation_required is true, but
> > that doesn't seem like it'd be an issue in practice.
> 
> I really would like to capture the last logical processor to execute
> VMLAUNCH/VMRESUME (or VMRUN on the AMD side) on behalf of this vCPU.

Does it matter though?  The flows that consume the variable are all directly
in the VM-Exit path.

> > >       vmx->fail = __vmx_vcpu_run(vmx, (unsigned long *)&vcpu->arch.regs,
> > >                                  vmx->loaded_vmcs->launched);
> > >
> > > diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> > > index 672c28f17e49..8a1e833cf4fb 100644
> > > --- a/arch/x86/kvm/vmx/vmx.h
> > > +++ b/arch/x86/kvm/vmx/vmx.h
> > > @@ -302,6 +302,9 @@ struct vcpu_vmx {
> > >       u64 ept_pointer;
> > >
> > >       struct pt_desc pt_desc;
> > > +
> > > +     /* which host CPU was used for running this vcpu */
> > > +     unsigned int last_cpu;
> >
> > Why not put this in struct kvm_vcpu_arch?  I'd also vote to name it
> > last_run_cpu, as last_cpu is super misleading.
> 
> I think last_run_cpu may also be misleading, since in the cases of
> interest, nothing actually 'ran.' Maybe last_attempted_vmentry_cpu?

Ya, that thought crossed my mind as well.

> > And if it's in arch, what about setting it vcpu_enter_guest?
> 
> As you point out above, this isn't entirely accurate. (But that's the
> way we roll in kvm, isn't it? :-)

As an alternative to storing the last run/attempted CPU, what about moving
the "bad VM-Exit" detection into handle_exit_irqoff, or maybe a new hook
that is called after IRQs are enabled but before preemption is enabled, e.g.
detect_bad_exit or something?  All of the paths in patch 4/4 can easily be
moved out of handle_exit.  VMX would require a little bit of refacotring for
it's "no handler" check, but that should be minor.
