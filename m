Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 943D11B4B47
	for <lists+kvm@lfdr.de>; Wed, 22 Apr 2020 19:05:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbgDVRF6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Apr 2020 13:05:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726183AbgDVRF5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Apr 2020 13:05:57 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7427AC03C1A9
        for <kvm@vger.kernel.org>; Wed, 22 Apr 2020 10:05:57 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id w20so3199194iob.2
        for <kvm@vger.kernel.org>; Wed, 22 Apr 2020 10:05:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SrDzkIsSHKXjyh6SSlxrAfdYpHKYVEOu2EcO/W/zyGE=;
        b=G/GZdCAwsvu0ExiKFVOSV5OClFNQTR1pDun2l7b4PtNf3T/7UeK9FVsVNwGBLruTko
         hroStOehwWLfXxrCVY8pqnivCvzrwkcT3bCcK0BiKYjO3WCmBCkb4ei9NJpqxYtSAE94
         cmqoo6brgqhVKpNNPK7e80J9yCFXagjyBWQ6KwSfJat0CnPAiOXffh9KFkAs+wnEdHJB
         zShMtExQx0MLy3riv/I/c18P/frxre5oXcFwFB64i37gcf5P+2IUOc073CROW+/QLxAU
         GS5mIopuMNjtqkFVEsgSgQZPhwFX+ph1pP1K2NDJtWKuqccNHxZAyFXk22HAnprlgCAm
         Ttbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SrDzkIsSHKXjyh6SSlxrAfdYpHKYVEOu2EcO/W/zyGE=;
        b=VCX9DiqaX3nwvLBXNl29gbkQgLYJ6NNsV72YwBR+/CbmZ1gNrij9FvNda7HjUZCMnO
         puXWFdfPxT4W67EF6eJJURxHXr37qGu2fmIJDfV/YMhUVK4wuf9kU8bH1w0QrQ1IGhlR
         tVHZhL4BguFyD8RuiD073dQxf+dB9fWlbBDdIblLGwoI6hMQ/iEgKUalv170LL0OR3U8
         x2c2IObZVeJTGZbGEnH6Gjyu2W2C+28+HLC4FmORgJeLIpnEtfziCN0DSITJXKxklCCf
         O+tnjO1fmqpT6jll75skrR/h/I86pNc1TjXdUt8Zr4LJh43laqbkspXmi6npYi/4/VVp
         1y2A==
X-Gm-Message-State: AGi0PubkdVo6yA0kIq0cz3EMy2iY2aROMYM0MfW7OQdcEWP713/dtQJK
        KDiO2XpoxwogDgoQV60k+Zj+y+SKgLW7614RF4lmeQ==
X-Google-Smtp-Source: APiQypKPsiXZgSm+JrfTdYHBzYMkOsJ9dMGz2JvqEnqBrTT4FbkeEPy5mu7pco6h/J6DG46GL7tW4mqGSOGYlY0NqUY=
X-Received: by 2002:a02:7f12:: with SMTP id r18mr14947067jac.75.1587575156423;
 Wed, 22 Apr 2020 10:05:56 -0700 (PDT)
MIME-Version: 1.0
References: <20200417183452.115762-1-makarandsonare@google.com>
 <20200417183452.115762-3-makarandsonare@google.com> <20200422015759.GE17836@linux.intel.com>
 <20200422020216.GF17836@linux.intel.com>
In-Reply-To: <20200422020216.GF17836@linux.intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 22 Apr 2020 10:05:45 -0700
Message-ID: <CALMp9eRUE7hRNUohhAuz8UoX0Zu1LtoXum7inuqW5ROy=m1hyQ@mail.gmail.com>
Subject: Re: [kvm PATCH 2/2] KVM: nVMX: Don't clobber preemption timer in the
 VMCS12 before L2 ran
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Makarand Sonare <makarandsonare@google.com>,
        kvm list <kvm@vger.kernel.org>, Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 21, 2020 at 7:02 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Tue, Apr 21, 2020 at 06:57:59PM -0700, Sean Christopherson wrote:
> > On Fri, Apr 17, 2020 at 11:34:52AM -0700, Makarand Sonare wrote:
> > > Don't clobber the VMX-preemption timer value in the VMCS12 during
> > > migration on the source while handling an L1 VMLAUNCH/VMRESUME but
> > > before L2 ran. In that case the VMCS12 preemption timer value
> > > should not be touched as it will be restarted on the target
> > > from its original value. This emulates migration occurring while L1
> > > awaits completion of its VMLAUNCH/VMRESUME instruction.
> > >
> > > Signed-off-by: Makarand Sonare <makarandsonare@google.com>
> > > Signed-off-by: Peter Shier <pshier@google.com>
> >
> > The SOB tags are reversed, i.e. Peter's should be first to show that he
> > wrote the patch and then transfered it to you for upstreaming.
> >
> > > Change-Id: I376d151585d4f1449319f7512151f11bbf08c5bf
> > > ---
> > >  arch/x86/kvm/vmx/nested.c | 12 +++++++-----
> > >  1 file changed, 7 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > > index 5365d7e5921ea..66155e9114114 100644
> > > --- a/arch/x86/kvm/vmx/nested.c
> > > +++ b/arch/x86/kvm/vmx/nested.c
> > > @@ -3897,11 +3897,13 @@ static void sync_vmcs02_to_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
> > >             vmcs12->guest_activity_state = GUEST_ACTIVITY_ACTIVE;
> > >
> > >     if (nested_cpu_has_preemption_timer(vmcs12)) {
> > > -           vmx->nested.preemption_timer_remaining =
> > > -                   vmx_get_preemption_timer_value(vcpu);
> > > -           if (vmcs12->vm_exit_controls & VM_EXIT_SAVE_VMX_PREEMPTION_TIMER)
> > > -                   vmcs12->vmx_preemption_timer_value =
> > > -                           vmx->nested.preemption_timer_remaining;
> > > +           if (!vmx->nested.nested_run_pending) {
> > > +                   vmx->nested.preemption_timer_remaining =
> > > +                           vmx_get_preemption_timer_value(vcpu);
> > > +                   if (vmcs12->vm_exit_controls & VM_EXIT_SAVE_VMX_PREEMPTION_TIMER)
> > > +                           vmcs12->vmx_preemption_timer_value =
> > > +                                   vmx->nested.preemption_timer_remaining;
> > > +                   }
> >
> > This indentation is messed up, the closing brace is for !nested_run_pending,
> > but it's aligned with (vm_exit_controls & ..._PREEMPTION_TIMER).
> >
> > Even better than fixing the indentation would be to include !nested_run_pending
> > in the top-level if statement, which reduces the nesting level and produces
> > a much cleaner diff, e.g.
> >
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index 409a39af121f..7dd6440425ab 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -3951,7 +3951,8 @@ static void sync_vmcs02_to_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
> >         else
> >                 vmcs12->guest_activity_state = GUEST_ACTIVITY_ACTIVE;
> >
> > -       if (nested_cpu_has_preemption_timer(vmcs12)) {
> > +       if (nested_cpu_has_preemption_timer(vmcs12) &&
> > +           !vmx->nested.nested_run_pending) {
> >                 vmx->nested.preemption_timer_remaining =
> >                         vmx_get_preemption_timer_value(vcpu);
> >                 if (vmcs12->vm_exit_controls & VM_EXIT_SAVE_VMX_PREEMPTION_TIMER)
>
> Actually, why is this a separate patch?  The code it's fixing was introduced
> in patch one of this series.

That's my fault. I questioned the legitimacy of this patch. When
nested_run_pending is set in sync_vmcs02_to_vmcs12, we are in the
middle of executing a VMLAUNCH or VMRESUME and userspace has requested
a dump of the nested state. At this point, we have already called
nested_vmx_enter_non_root_mode, and we have already started the timer.
Even though we are going to repeat the vmcs02 setup when restoring the
nested state, we do not actually rollback and restart the instruction.
Setting up the vmcs02 on the target is just something we have to do to
continue where we left off. Since we're continuing a partially
executed instruction after the restore rather than rolling back, I
think it's perfectly reasonable to go ahead and count the time elapsed
prior to KVM_GET_NESTED_STATE against L2's VMX-preemption timer.

I don't have a strong objection to this patch. It just seems to add
gratuitous complexity. If the consensus is to take it, the two parts
should be squashed together.
