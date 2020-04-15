Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3CED1AB43F
	for <lists+kvm@lfdr.de>; Thu, 16 Apr 2020 01:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389686AbgDOXeb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 19:34:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbgDOXdn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Apr 2020 19:33:43 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E7D0C061A0C
        for <kvm@vger.kernel.org>; Wed, 15 Apr 2020 16:33:43 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id e127so3802065iof.6
        for <kvm@vger.kernel.org>; Wed, 15 Apr 2020 16:33:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HJkyUvh7KGQiqXwoFnwOCjKQ5vX+2Zj9u0dy+MypXMU=;
        b=FiTHSXFSO2Hjahnm4LkCvmLGKPmsP5af4RynkNgG/BDhu/PljznjYarsrMCaDlCvV7
         ic9uEIL3wH4HPgKUE/RC4eEE4l7o3Om8lTs0PCILBV3/DnSJslM873COqaiPNkIWyT18
         dDrGyohRmGLEo4Q54nN8sB9cvz+a4JWFWkSNC43qzv733+LY9vPpAoNfC9pchHx9jXj8
         glJPQTo/P9zEM3n5mbAxAGp8vyLL53RRLWRhVDT4qc6vrCCmIt7mNJAsT11fIKosFwbl
         LzYndJVbn5Zt9wJV9gtFqgMIy9fZIgh8Ji1wps9YLgKC8vYdvU6lm7Czw4zoikfLFmMe
         1sLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HJkyUvh7KGQiqXwoFnwOCjKQ5vX+2Zj9u0dy+MypXMU=;
        b=QtYjGBcGBl0jhd06dsmM/qiLNY4YN33vsrmvFjCtFqPzS7Ja4ACnPfCxoGa1yagZ1q
         vJEa8ZdsVhM1Bc1cw+RyEu81/ODXIMbjNZxTOhc6/HTiSRnMUcOtLJMp5g6kiJWXG0W8
         m1QyXoMJUi3poyVphqnu4sRUIZDoCeAy8Fk2HIWDpYg2qIjeNzqk5HY6kUTp1D0DSCrM
         ywlsM80/o7HAQRISA4F+aGirGI6qgwHfHpSyhc4j3T0Cxo33pKYRGtxTql86ef3i6lYG
         RtP3X00gEu9HKBU/XDQN+depH7fMbnBGgX2j1eWRqHqjvzKqiG4VCPYIEOz1oPFIb/8C
         WDdg==
X-Gm-Message-State: AGi0PubEUvKqqtt/s955nE+a+lpMq0xbg2MRLH69STqMi0QmQomnAeFU
        s5UemANpJqNtfCbBRJt8157ffMT3d+duQBvko6Di1w==
X-Google-Smtp-Source: APiQypLfxl13FisQo0c+qftNwapdMwHbY9RCJVJK1qgbHntd3ObnhXBOhtDT9MbcJGtMdJfBmDoIU8KDp0p7/93Sg9s=
X-Received: by 2002:a6b:c408:: with SMTP id y8mr28235156ioa.12.1586993622157;
 Wed, 15 Apr 2020 16:33:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200414000946.47396-1-jmattson@google.com> <20200414000946.47396-2-jmattson@google.com>
 <20200414031705.GP21204@linux.intel.com> <CALMp9eT23AUTU3m_oADKw3O_NMpuX3crx7eqSB8Rbgh3k0s_Jw@mail.gmail.com>
 <20200415001212.GA12547@linux.intel.com>
In-Reply-To: <20200415001212.GA12547@linux.intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 15 Apr 2020 16:33:31 -0700
Message-ID: <CALMp9eS-s5doptTzVkE2o9jDYuGU3T=5azMhm3fCqLJPcABAOg@mail.gmail.com>
Subject: Re: [PATCH 2/2] kvm: nVMX: Single-step traps trump expired
 VMX-preemption timer
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm list <kvm@vger.kernel.org>, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 14, 2020 at 5:12 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
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

Yes, it's wrong in the abstract, but with respect to faults and the
VMX-preemption timer expiration, is there any way for either L1 or L2
to *know* that the virtual CPU has done something wrong?

Isn't it generally true that if you have an exception queued when you
transition from L2 to L1, then you've done something wrong? I wonder
if the call to kvm_clear_exception_queue() in prepare_vmcs12() just
serves to sweep a whole collection of problems under the rug.

> In general, interception of an event doesn't change the priority of events,
> e.g. INTR shouldn't get priority over NMI just because if L1 wants to
> intercept INTR but not NMI.

Yes, but that's a different problem altogether.

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
> +               if (!nested_exit_on_intr(vcpu))
> +                       return 0;
> +
>                 if (block_nested_events)
>                         return -EBUSY;
>                 nested_vmx_vmexit(vcpu, EXIT_REASON_EXTERNAL_INTERRUPT, 0, 0);
>
