Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16AC91BB300
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 02:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbgD1AoZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Apr 2020 20:44:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726263AbgD1AoZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 27 Apr 2020 20:44:25 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B7EAC03C1A8;
        Mon, 27 Apr 2020 17:44:25 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id g19so29706778otk.5;
        Mon, 27 Apr 2020 17:44:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VhGS8dYUF43wLQV+THWnzQsHj2BDh87oypEgi/eQ6Kg=;
        b=OiQeazIF2D+is/AHjp1Cf0TjfxsAC2pwsqBg7M2opP/nWx3JsneE7+JQ4c4RUaWaVt
         gOakvIsDK/12Dlyoe3srTPPINtf+EyHumf1GBwHuQBzt69dwvU0ZXqOevZOt3sanyM3s
         TvNEF4EqKj2oGaRvYahMKienDyiOPM0ApMbRg2Inpef3idPjPm9q06vvWI6ebOmeHIeU
         zL0FRTw2Q67kN21sdqperJ2OkN9iJMXLGGYznamBomMNU4vMt1bU/yb2BrL7XD3Hw/XH
         hGouTHbjMyYa36hzazNTcVq7dnP3r3tH7eFYJns/BuRizMuASe1XH3Y0l9OdxQPAt45h
         oGCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VhGS8dYUF43wLQV+THWnzQsHj2BDh87oypEgi/eQ6Kg=;
        b=pVKL3FZS0bbjAN1SeAdBsgX4GOyhWQl0Z1guVbwvQ0aOM2dBrGg2AmnoCwRmcHV1+v
         KbSBX76B9LOqTs7XGeJ7LUtGcQvfaMQJlLGbW+enbAgmYHyrhJegbAL3F6e7K3ibSzeK
         HHn1trfnreeCwrhu526bE11nU9tSbOSXOZWshNHWuv9BdMqovOJmvj22lnRdQJyVF1nX
         l+0YiGek7v4tQYntdvLO2e3ZIvbvHSfH/QF6SNzv7vG81bxQPgNV5uLdp+VcAhrYHiT+
         cwBNbeD93QLSobjQWgRoUC9El38LwcYVg/gksJ0wpX/1+oDCbIyfGP3jry0ELHfOFanR
         km5g==
X-Gm-Message-State: AGi0PuYjpox54N9pWICv76sRGQe/YTQ60fbXa/6IC7yPy2dsIP9J5oCz
        vysD6GwpeV8KQJfx6c4MdsnPBsGKbz1SrYGUdeU=
X-Google-Smtp-Source: APiQypJk69gEtiyGl45hjwalSRxAbT3qGjO5oQIz5CHWe3/f9MddOpA4ypPsyrtJkhLO+OKkSSMDwhWUPp5Ff0doLBw=
X-Received: by 2002:a05:6830:20d9:: with SMTP id z25mr12751170otq.254.1588034664624;
 Mon, 27 Apr 2020 17:44:24 -0700 (PDT)
MIME-Version: 1.0
References: <1587709364-19090-1-git-send-email-wanpengli@tencent.com>
 <1587709364-19090-3-git-send-email-wanpengli@tencent.com> <CANRm+CwvTrwmJnFWR8UgEkqyE_fyoc6KmrNuHQj=DuJDkR-UGA@mail.gmail.com>
 <20200427183656.GO14870@linux.intel.com>
In-Reply-To: <20200427183656.GO14870@linux.intel.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 28 Apr 2020 08:44:13 +0800
Message-ID: <CANRm+CzdCcz4Vyw-6D5xTc+VmRTr6=O0U=7vfdNLF=LjW5HOEg@mail.gmail.com>
Subject: Re: [PATCH v3 2/5] KVM: X86: Introduce need_cancel_enter_guest helper
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Haiwei Li <lihaiwei@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 28 Apr 2020 at 02:36, Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Sun, Apr 26, 2020 at 10:05:00AM +0800, Wanpeng Li wrote:
> > On Fri, 24 Apr 2020 at 14:23, Wanpeng Li <kernellwp@gmail.com> wrote:
> > >
> > > From: Wanpeng Li <wanpengli@tencent.com>
> > >
> > > Introduce need_cancel_enter_guest() helper, we need to check some
> > > conditions before doing CONT_RUN, in addition, it can also catch
> > > the case vmexit occurred while another event was being delivered
> > > to guest software since vmx_complete_interrupts() adds the request
> > > bit.
> > >
> > > Tested-by: Haiwei Li <lihaiwei@tencent.com>
> > > Cc: Haiwei Li <lihaiwei@tencent.com>
> > > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > > ---
> > >  arch/x86/kvm/vmx/vmx.c | 12 +++++++-----
> > >  arch/x86/kvm/x86.c     | 10 ++++++++--
> > >  arch/x86/kvm/x86.h     |  1 +
> > >  3 files changed, 16 insertions(+), 7 deletions(-)
> > >
> > > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > > index f1f6638..5c21027 100644
> > > --- a/arch/x86/kvm/vmx/vmx.c
> > > +++ b/arch/x86/kvm/vmx/vmx.c
> > > @@ -6577,7 +6577,7 @@ bool __vmx_vcpu_run(struct vcpu_vmx *vmx, unsigned long *regs, bool launched);
> > >
> > >  static enum exit_fastpath_completion vmx_vcpu_run(struct kvm_vcpu *vcpu)
> > >  {
> > > -       enum exit_fastpath_completion exit_fastpath;
> > > +       enum exit_fastpath_completion exit_fastpath = EXIT_FASTPATH_NONE;
> > >         struct vcpu_vmx *vmx = to_vmx(vcpu);
> > >         unsigned long cr3, cr4;
> > >
> > > @@ -6754,10 +6754,12 @@ static enum exit_fastpath_completion vmx_vcpu_run(struct kvm_vcpu *vcpu)
> > >         vmx_recover_nmi_blocking(vmx);
> > >         vmx_complete_interrupts(vmx);
> > >
> > > -       exit_fastpath = vmx_exit_handlers_fastpath(vcpu);
> > > -       /* static call is better with retpolines */
> > > -       if (exit_fastpath == EXIT_FASTPATH_CONT_RUN)
> > > -               goto cont_run;
> > > +       if (!kvm_need_cancel_enter_guest(vcpu)) {
> > > +               exit_fastpath = vmx_exit_handlers_fastpath(vcpu);
> > > +               /* static call is better with retpolines */
> > > +               if (exit_fastpath == EXIT_FASTPATH_CONT_RUN)
> > > +                       goto cont_run;
> > > +       }
> >
> > The kvm_need_cancel_enter_guest() should not before
> > vmx_exit_handlers_fastpath() which will break IPI fastpath. How about
> > applying something like below, otherwise, maybe introduce another
> > EXIT_FASTPATH_CONT_FAIL to indicate fails due to
> > kvm_need_cancel_enter_guest() if checking it after
> > vmx_exit_handlers_fastpath(), then we return 1 in vmx_handle_exit()
> > directly instead of kvm_skip_emulated_instruction(). VMX-preemption
> > timer exit doesn't need to skip emulated instruction but wrmsr
> > TSCDEADLINE MSR exit does which results in a little complex here.
> >
> > Paolo, what do you think?
> >
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 853d3af..9317924 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -6564,6 +6564,9 @@ static enum exit_fastpath_completion
> > handle_fastpath_preemption_timer(struct kvm
> >  {
> >      struct vcpu_vmx *vmx = to_vmx(vcpu);
> >
> > +    if (kvm_need_cancel_enter_guest(vcpu))
> > +        return EXIT_FASTPATH_NONE;
> > +
> >      if (!vmx->req_immediate_exit &&
> >          !unlikely(vmx->loaded_vmcs->hv_timer_soft_disabled)) {
> >              kvm_lapic_expired_hv_timer(vcpu);
> > @@ -6771,12 +6774,10 @@ static enum exit_fastpath_completion
> > vmx_vcpu_run(struct kvm_vcpu *vcpu)
> >      vmx_recover_nmi_blocking(vmx);
> >      vmx_complete_interrupts(vmx);
> >
> > -    if (!(kvm_need_cancel_enter_guest(vcpu))) {
> > -        exit_fastpath = vmx_exit_handlers_fastpath(vcpu);
> > -        if (exit_fastpath == EXIT_FASTPATH_CONT_RUN) {
> > -            vmx_sync_pir_to_irr(vcpu);
> > -            goto cont_run;
> > -        }
> > +    exit_fastpath = vmx_exit_handlers_fastpath(vcpu);
> > +    if (exit_fastpath == EXIT_FASTPATH_CONT_RUN) {
>
> Relying on the handlers to check kvm_need_cancel_enter_guest() will be
> error prone and costly to maintain.  I also don't like that it buries the
> logic.
>
> What about adding another flavor, e.g.:
>
>         exit_fastpath = vmx_exit_handlers_fastpath(vcpu);
>         if (exit_fastpath == EXIT_FASTPATH_CONT_RUN &&
>             kvm_need_cancel_enter_guest(vcpu))
>                 exit_fastpath = EXIT_FASTPATH_NOP;
>
> That would also allow you to enable preemption timer without first having
> to add CONT_RUN, which would be a very good thing for bisection.

I miss understand the second part, do you mean don't need to add
CONT_RUN in patch 1/5?

    Wanpeng
