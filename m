Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C9111A8FAC
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 02:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2634572AbgDOAVp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Apr 2020 20:21:45 -0400
Received: from mga18.intel.com ([134.134.136.126]:13425 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392373AbgDOAVL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Apr 2020 20:21:11 -0400
IronPort-SDR: yYDcRM/I/AaooXuUkOAaw46/hPEma3393JsRyQFM2SiT7tnzglR7P6+dhPKDyW6suVXQ6fz35v
 v9TtIoh2iqdw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2020 17:21:04 -0700
IronPort-SDR: Z/UHUCYOuUDjpejDG6n0CA4MtTvNPLtBSkLr35v/iqt+N6YlTD+5EyHpnuM16KRfSWOfWajjiF
 4l23oHvktmDA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,384,1580803200"; 
   d="scan'208";a="363526095"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 14 Apr 2020 17:21:04 -0700
Date:   Tue, 14 Apr 2020 17:20:44 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm list <kvm@vger.kernel.org>, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Subject: Re: [PATCH 2/2] kvm: nVMX: Single-step traps trump expired
 VMX-preemption timer
Message-ID: <20200415002044.GB12547@linux.intel.com>
References: <20200414000946.47396-1-jmattson@google.com>
 <20200414000946.47396-2-jmattson@google.com>
 <20200414031705.GP21204@linux.intel.com>
 <CALMp9eT23AUTU3m_oADKw3O_NMpuX3crx7eqSB8Rbgh3k0s_Jw@mail.gmail.com>
 <20200415001212.GA12547@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200415001212.GA12547@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 14, 2020 at 05:12:12PM -0700, Sean Christopherson wrote:
> On Tue, Apr 14, 2020 at 09:47:53AM -0700, Jim Mattson wrote:
> > On Mon, Apr 13, 2020 at 8:17 PM Sean Christopherson
> > <sean.j.christopherson@intel.com> wrote:
> > >
> > > On Mon, Apr 13, 2020 at 05:09:46PM -0700, Jim Mattson wrote:
> > > > Previously, if the hrtimer for the nested VMX-preemption timer fired
> > > > while L0 was emulating an L2 instruction with RFLAGS.TF set, the
> > > > synthesized single-step trap would be unceremoniously dropped when
> > > > synthesizing the "VMX-preemption timer expired" VM-exit from L2 to L1.
> > > >
> > > > To fix this, don't synthesize a "VMX-preemption timer expired" VM-exit
> > > > from L2 to L1 when there is a pending debug trap, such as a
> > > > single-step trap.
> > > >
> > > > Fixes: f4124500c2c13 ("KVM: nVMX: Fully emulate preemption timer")
> > > > Signed-off-by: Jim Mattson <jmattson@google.com>
> > > > Reviewed-by: Oliver Upton <oupton@google.com>
> > > > Reviewed-by: Peter Shier <pshier@google.com>
> > > > ---
> > > >  arch/x86/kvm/vmx/nested.c | 4 +++-
> > > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > > > index cbc9ea2de28f..6ab974debd44 100644
> > > > --- a/arch/x86/kvm/vmx/nested.c
> > > > +++ b/arch/x86/kvm/vmx/nested.c
> > > > @@ -3690,7 +3690,9 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
> > > >           vmx->nested.preemption_timer_expired) {
> > > >               if (block_nested_events)
> > > >                       return -EBUSY;
> > > > -             nested_vmx_vmexit(vcpu, EXIT_REASON_PREEMPTION_TIMER, 0, 0);
> > > > +             if (!vmx_pending_dbg_trap(vcpu))
> > >
> > > IMO this one warrants a comment.  It's not immediately obvious that this
> > > only applies to #DBs that are being injected into L2, and that returning
> > > -EBUSY will do the wrong thing.
> > 
> > Regarding -EBUSY, I'm in complete agreement. However, I'm not sure
> > what the potential confusion is regarding the event. Are you
> > suggesting that one might think that we have a #DB to deliver to L1
> > while we're in guest mode? IIRC, that can happen under SVM, but I
> > don't believe it can happen under VMX.
> 
> The potential confusion is that vcpu->arch.exception.pending was already
> checked, twice.  It makes one wonder why it needs to be checked a third
> time.  And actually, I think that's probably a good indicator that singling
> out single-step #DB isn't the correct fix, it just happens to be the only
> case that's been encountered thus far, e.g. a #PF when fetching the instr
> for emulation should also get priority over the preemption timer.  On real
> hardware, expiration of the preemption timer while vectoring a #PF wouldn't
> wouldn't get recognized until the next instruction boundary, i.e. at the
> start of the first instruction of the #PF handler.  Dropping the #PF isn't
> a problem in most cases, because unlike the single-step #DB, it will be
> re-encountered when L1 resumes L2.  But, dropping the #PF is still wrong.
> 
> In general, interception of an event doesn't change the priority of events,
> e.g. INTR shouldn't get priority over NMI just because if L1 wants to
> intercept INTR but not NMI.
> 
> TL;DR: I think the fix should instead be:
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index c868c64770e0..042d7a9037be 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -3724,9 +3724,10 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
>         /*
>          * Process any exceptions that are not debug traps before MTF.
>          */
> -       if (vcpu->arch.exception.pending &&
> -           !vmx_pending_dbg_trap(vcpu) &&
> -           nested_vmx_check_exception(vcpu, &exit_qual)) {
> +       if (vcpu->arch.exception.pending && !vmx_pending_dbg_trap(vcpu))
> +               if (!nested_vmx_check_exception(vcpu, &exit_qual))
> +                       return 0;
> +
>                 if (block_nested_events)
>                         return -EBUSY;
>                 nested_vmx_inject_exception_vmexit(vcpu, exit_qual);
> @@ -3741,8 +3742,10 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
>                 return 0;
>         }
> 
> -       if (vcpu->arch.exception.pending &&
> -           nested_vmx_check_exception(vcpu, &exit_qual)) {
> +       if (vcpu->arch.exception.pending) {
> +               if (!nested_vmx_check_exception(vcpu, &exit_qual))
> +                       return 0;
> +
>                 if (block_nested_events)
>                         return -EBUSY;
>                 nested_vmx_inject_exception_vmexit(vcpu, exit_qual);
> @@ -3757,7 +3760,10 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
>                 return 0;
>         }
> 
> -       if (vcpu->arch.nmi_pending && nested_exit_on_nmi(vcpu)) {
> +       if (vcpu->arch.nmi_pending) {
> +               if (!nested_exit_on_nmi(vcpu))
> +                       return 0;
> +
>                 if (block_nested_events)
>                         return -EBUSY;
>                 nested_vmx_vmexit(vcpu, EXIT_REASON_EXCEPTION_NMI,
> @@ -3772,7 +3778,10 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
>                 return 0;
>         }
> 
> -       if (kvm_cpu_has_interrupt(vcpu) && nested_exit_on_intr(vcpu)) {
> +       if (kvm_cpu_has_interrupt(vcpu) {

Obviously untested, because this doesn't compile due to a missing ')'.

> +               if (!nested_exit_on_intr(vcpu))
> +                       return 0;
> +
>                 if (block_nested_events)
>                         return -EBUSY;
>                 nested_vmx_vmexit(vcpu, EXIT_REASON_EXTERNAL_INTERRUPT, 0, 0);
> 
