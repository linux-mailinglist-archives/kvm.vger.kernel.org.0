Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 075C41F8D8
	for <lists+kvm@lfdr.de>; Wed, 15 May 2019 18:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727248AbfEOQm7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 May 2019 12:42:59 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:40485 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726406AbfEOQm7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 May 2019 12:42:59 -0400
Received: by mail-lj1-f194.google.com with SMTP id d15so388163ljc.7
        for <kvm@vger.kernel.org>; Wed, 15 May 2019 09:42:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7lwWCU/enr49sAtX03bw0pmLYZWGqwWLRgDGE/HyyFM=;
        b=Rzf/qWmuDKqTD56DSAhGNHRaaF2xWZ+Bxs4hV3XQVpg4QyV54Xx1N2lPCZtq8NQWql
         pLazxDb0dZgOmiQlg/0e69/WWillDHdFNaqNXUVQEdZVsD90HPLGwLcQaesmcKpryAay
         CkfiNoFSWd/YmNdpykLVUcP0EgmbN5KPoXbVL8qJ7+IOexRMw/ePEgn74B4UP0CNsKBV
         QAfxwTMniDBUueMMrtbcLu0waSvd3/JoCJpNDcp1evNmZd4iJ6vAnDPHyg7RZ/ja1AUj
         BkwEyolPi1mebZ+ibUdPLdXr4aUy8u3wuHPuRdZmC+OgJVMS42qa2Y6Hc3+FRZ4EtNGN
         QF4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7lwWCU/enr49sAtX03bw0pmLYZWGqwWLRgDGE/HyyFM=;
        b=f+rriw+O6mW6r6Sf0e7VWpIi5VWUXo/8+9fT22SdKNpa3/FXRVPplTQRA8t6QDPUhT
         l3m/YiTCfjaPZJhhEDxiR3e4zGeQIgfHdKSeLGrJf1WrWtq9tJRpyxDzNInpOIo+6eLZ
         EEmmaK4z9sftgeSzjZvwB+/J8rjtKw9c5te9GlKXrU9I2WXtUVphGlB82b3KvCUPBnKD
         +vcmJ60+Z3YY6O5SRYBx4b+axn4dOLR2r0e9vLGR0hCagCJXwzJh3UP3In3e8d0UAdNK
         BcEj/94Q2Rk2bvd4/5sl9EylyDzolF5uua8QoXjgO80fRJAouU7sA1aHB0O6Bl9L7bxi
         pjLA==
X-Gm-Message-State: APjAAAWLOR8+q6mnEkCstlMpfucUkTz8ZR8/t9P9FNb+EfvTPnjqwPyb
        grjt1G4Jv8J2dj1s/utB9XMPda3rajfkhqUELHbR3A==
X-Google-Smtp-Source: APXvYqwUJRxPZ3wsv+y2nfcD10ABe2Mkgu2RxDX37gdelb1SY8vbkXSj+t4XjKZoWpJsi5gqNM7xfYwP8As7Mh+7rh4=
X-Received: by 2002:a2e:a294:: with SMTP id k20mr15504341lja.118.1557938575681;
 Wed, 15 May 2019 09:42:55 -0700 (PDT)
MIME-Version: 1.0
References: <20190502183133.258026-1-aaronlewis@google.com>
 <87zho37s2h.fsf@vitty.brq.redhat.com> <CAAAPnDHJ=ZC+CoKYkYkRsv+WJJjHJ66iN6jU72spL3+LckUpvA@mail.gmail.com>
 <878svgsovg.fsf@vitty.brq.redhat.com> <CAAAPnDFsixYb2R-0uN-_DCEb4U-MEo0Pd1hmFzpqqAojc9GxXA@mail.gmail.com>
In-Reply-To: <CAAAPnDFsixYb2R-0uN-_DCEb4U-MEo0Pd1hmFzpqqAojc9GxXA@mail.gmail.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Wed, 15 May 2019 09:42:44 -0700
Message-ID: <CAAAPnDHPCztgDCCKkaux=2=Fr-YrVhARR_8qrdYo-+AT3CQ+LQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] KVM: nVMX: KVM_SET_NESTED_STATE - Tear down old EVMCS
 state before setting new state
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Peter Shier <pshier@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, rkrcmar@redhat.com,
        Jim Mattson <jmattson@google.com>,
        Marc Orr <marcorr@google.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 8, 2019 at 2:18 PM Aaron Lewis <aaronlewis@google.com> wrote:
>
> From: Vitaly Kuznetsov <vkuznets@redhat.com>
> Date: Wed, May 8, 2019 at 12:55 PM
> To: Aaron Lewis
> Cc: Peter Shier, Paolo Bonzini, <rkrcmar@redhat.com>, Jim Mattson,
> Marc Orr, <kvm@vger.kernel.org>
>
> > Aaron Lewis <aaronlewis@google.com> writes:
> >
> > > From: Vitaly Kuznetsov <vkuznets@redhat.com>
> > > Date: Fri, May 3, 2019 at 3:25 AM
> > > To: Aaron Lewis
> > > Cc: Peter Shier, <pbonzini@redhat.com>, <rkrcmar@redhat.com>,
> > > <jmattson@google.com>, <marcorr@google.com>, <kvm@vger.kernel.org>
> > >
> > >> Aaron Lewis <aaronlewis@google.com> writes:
> > >>
> > >> > Move call to nested_enable_evmcs until after free_nested() is complete.
> > >> >
> > >> > Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> > >> > Reviewed-by: Marc Orr <marcorr@google.com>
> > >> > Reviewed-by: Peter Shier <pshier@google.com>
> > >> > ---
> > >> >  arch/x86/kvm/vmx/nested.c | 6 +++---
> > >> >  1 file changed, 3 insertions(+), 3 deletions(-)
> > >> >
> > >> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > >> > index 081dea6e211a..3b39c60951ac 100644
> > >> > --- a/arch/x86/kvm/vmx/nested.c
> > >> > +++ b/arch/x86/kvm/vmx/nested.c
> > >> > @@ -5373,9 +5373,6 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
> > >> >       if (kvm_state->format != 0)
> > >> >               return -EINVAL;
> > >> >
> > >> > -     if (kvm_state->flags & KVM_STATE_NESTED_EVMCS)
> > >> > -             nested_enable_evmcs(vcpu, NULL);
> > >> > -
> > >> >       if (!nested_vmx_allowed(vcpu))
> > >> >               return kvm_state->vmx.vmxon_pa == -1ull ? 0 : -EINVAL;
> > >> >
> > >> > @@ -5417,6 +5414,9 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
> > >> >       if (kvm_state->vmx.vmxon_pa == -1ull)
> > >> >               return 0;
> > >> >
> > >> > +     if (kvm_state->flags & KVM_STATE_NESTED_EVMCS)
> > >> > +             nested_enable_evmcs(vcpu, NULL);
> > >> > +
> > >> >       vmx->nested.vmxon_ptr = kvm_state->vmx.vmxon_pa;
> > >> >       ret = enter_vmx_operation(vcpu);
> > >> >       if (ret)
> > >>
> > >> nested_enable_evmcs() doesn't do much, actually, in case it was
> > >> previously enabled it doesn't do anything and in case it wasn't ordering
> > >> with free_nested() (where you're aiming at nested_release_evmcs() I
> > >> would guess) shouldn't matter. So could you please elaborate (better in
> > >> the commit message) why do we need this re-ordered? My guess is that
> > >> you'd like to perform checks for e.g. 'vmx.vmxon_pa == -1ull' before
> > >> we actually start doing any changes but let's clarify that.
> > >>
> > >> Thanks!
> > >>
> > >> --
> > >> Vitaly
> > >
> > > There are two reasons for doing this:
> > > 1. We don't want to set new state if we are going to leave nesting and
> > > exit the function (ie: vmx.vmxon_pa = -1), like you pointed out.
> > > 2. To be more future proof, we don't want to set new state before
> > > tearing down state.  This could cause conflicts down the road.
> > >
> > > I can add this to the commit message if there are no objections to
> > > these points.
> >
> > Sounds good to me, please do. Thanks!
> >
> > --
> > Vitaly
>
> Here is the updated patch:
>
>
> Move call to nested_enable_evmcs until after free_nested() is
> complete.  There are two reasons for doing this:
> 1. We don't want to set new state if we are going to leave nesting and
> exit the function (ie: vmx.vmxon_pa = -1).
> 2. To be more future proof, we don't want to set new state before
> tearing down state.  This could cause conflicts down the road.
>
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> Reviewed-by: Marc Orr <marcorr@google.com>
> Reviewed-by: Peter Shier <pshier@google.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index fe5814df5149..6ecc301df874 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -5373,9 +5373,6 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
>   if (kvm_state->format != 0)
>   return -EINVAL;
>
> - if (kvm_state->flags & KVM_STATE_NESTED_EVMCS)
> - nested_enable_evmcs(vcpu, NULL);
> -
>   if (!nested_vmx_allowed(vcpu))
>   return kvm_state->vmx.vmxon_pa == -1ull ? 0 : -EINVAL;
>
> @@ -5417,6 +5414,9 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
>   if (kvm_state->vmx.vmxon_pa == -1ull)
>   return 0;
>
> + if (kvm_state->flags & KVM_STATE_NESTED_EVMCS)
> + nested_enable_evmcs(vcpu, NULL);
> +
>   vmx->nested.vmxon_ptr = kvm_state->vmx.vmxon_pa;
>   ret = enter_vmx_operation(vcpu);
>   if (ret)

Hi Vitaly,

Does this update look good or are any other changes needed?

Thanks,
Aaron
