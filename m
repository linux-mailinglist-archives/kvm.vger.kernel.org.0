Return-Path: <kvm+bounces-30144-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BAB7D9B731A
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 04:40:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 48B021F25835
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 03:40:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E60D13A256;
	Thu, 31 Oct 2024 03:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ls9ubQuJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E1E13A863
	for <kvm@vger.kernel.org>; Thu, 31 Oct 2024 03:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730346003; cv=none; b=SQtD1cmZHTk7KvKmwkGpviiJDo1y/pIhclkV8+NXDZPicwA+KsFx8UlgR3bgchN0mpHDOJmDdCboeKPmi1obotOfho7I+yozeTDNvkdBNsjikFqQnjSBQahVlGD1xwH7jzIXzuYwcYN8sCbeFYFOHIbcIHM0zbpUowl/JiOnAmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730346003; c=relaxed/simple;
	bh=lqhlHqV3COwkx1tRe9N/vUG8LYb9ZaQRohHuJ0GFHgc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UOW7hn/sMRio9u3Y6JC9luTyQKi5PrxPMQQaQh3mxvaoUXVPlmw34vWOANB4Ju1ArUMZoKPlG9x25tgAoIS2fqDDBrIlGmOfK4oMtS4XzENwGRaTtrSQaxnePGzsMPo3rxdZ+9rdM/GMOq+yi8Z7v5sKRS/epiMsU0aPwIpVrI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ls9ubQuJ; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-2e2eb9dde40so402359a91.0
        for <kvm@vger.kernel.org>; Wed, 30 Oct 2024 20:40:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730346000; x=1730950800; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qDmZiV+NWIwT+X+k+LAFHUSHr7OingjAwQqLRVIU6I4=;
        b=Ls9ubQuJtTMkpLd65nz0CjBqh5LjWOYWMz1JBwvIQqHe2OtUWtOF/JZd4Pot5e926h
         YQVZVx6WPcWHLjklYe2q6mrYvZbbY8VL63D9RQaMT9OwHtXpBc8i+iTi45gyaZLRt8iP
         Vsg6iTFkesNifeU8+axzR7qguPx1rde9LdRrJRlsfcZDRg8BpRa8/X1f+byp+XUDUONz
         FDM0yQdN6WjYkKpcI3JIhpznggxG7UweImNYLaDT16pvCdx73BWnKxwGwONFJApaNraj
         ExehGLvplf4LKENTovv9jK7CCb7j4Wjh32VJmHQznmA5pM7z3Bkj2I2clibrchql5kt3
         VESw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730346000; x=1730950800;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qDmZiV+NWIwT+X+k+LAFHUSHr7OingjAwQqLRVIU6I4=;
        b=DDT9KXmMoQF+8qFcx1QAeS2kjcmsfp/Z2GdVJmT6hiuwf/fWy3ws4+sm681QSQCOr3
         QtmflOuqnH7i8DJDOeWGksMAHd7Sf8VcPAfFc4ra4TtOpKTXIN3aY7oFABTNH3RSkYAx
         svkRNHfMry+LU6tyhbQJecD8YwX65VuCIIWPfWXoTSd553QTNYGm0d7GZ8Y922/XTP3z
         XMvp9aqmPaJVNFeWIdv7LfQsNEiiQK7xxWfxE0cfiVX4wt37GA0RnW16yryC6UF7X4rQ
         xWBw9MwghZudhPUviSYZA0rBBNo+0xQXZUhduEPw206jaseWxt0xv7voVitNdmT1xI8e
         EGMQ==
X-Forwarded-Encrypted: i=1; AJvYcCXwis54HoUz/2A2opLkBC2gdgB/CYg5tw95fviSV8UljF3x8PnVX0Jc9vpiW9ntJWL71iE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwRAv8CMux6J+bBZRLZwfFhhnDZHWod5wM+e9LLFhsTfde9hF1T
	ilq+kQrNcu43sKU4t0BdubfYJHnbermeeEvP3klNObg6szLff8Z7x5UdFp9+eDP3EGj9KhFV/gT
	Szq2HG0ayv3bv9t7QIbGPhtuiL5Q=
X-Google-Smtp-Source: AGHT+IHwNA/ciOAbP/RMMGgFOrSxmsSyi+XiO7uj18muYi44OJAU7w2GFJOYYZwwJWmjSUV5M9cnGGr8nNquoydXAl0=
X-Received: by 2002:a17:90b:2d92:b0:2e2:c40c:6e8a with SMTP id
 98e67ed59e1d1-2e93c1d3e42mr2258137a91.26.1730346000333; Wed, 30 Oct 2024
 20:40:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241023124527.1092810-1-alexyonghe@tencent.com> <ZyJ7ZsP4RaRfcFQF@google.com>
In-Reply-To: <ZyJ7ZsP4RaRfcFQF@google.com>
From: zhuangel570 <zhuangel570@gmail.com>
Date: Thu, 31 Oct 2024 11:39:49 +0800
Message-ID: <CANZk6aQEH=9EFdsBfuRcUWhTu88Oc=x=Wp3bcqzQd1AVjcTTEg@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Try to enable irr_pending state with disabled APICv
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, wanpengli@tencent.com, 
	alexyonghe@tencent.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 31, 2024 at 2:31=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Wed, Oct 23, 2024, Yong He wrote:
> > From: Yong He <alexyonghe@tencent.com>
> >
> > Try to enable irr_pending when set APIC state, if there is
> > pending interrupt in IRR with disabled APICv.
> >
> > In save/restore VM scenery with disabled APICv. Qemu/CloudHypervisor
> > always send signals to stop running vcpu threads, then save
> > entire VM state, including APIC state. There may be a pending
> > timer interrupt in the saved APIC IRR that is injected before
> > vcpu_run return. But when restoring the VM, since APICv is
> > disabled, irr_pending is disabled by default, so this may cause
> > the timer interrupt in the IRR to be suspended for a long time,
> > until the next interrupt comes.
> >
> > Signed-off-by: Yong He <alexyonghe@tencent.com>
> > ---
> >  arch/x86/kvm/lapic.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > index 2098dc689088..7373f649958b 100644
> > --- a/arch/x86/kvm/lapic.c
> > +++ b/arch/x86/kvm/lapic.c
> > @@ -3099,6 +3099,10 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, st=
ruct kvm_lapic_state *s)
> >                                               apic_find_highest_irr(api=
c));
> >               kvm_x86_call(hwapic_isr_update)(apic_find_highest_isr(api=
c));
> >       }
> > +
> > +     /* Search the IRR and enable irr_pending state with disabled APIC=
v*/
> > +     if (!enable_apicv && apic_search_irr(apic) !=3D -1)
>
> This can/should be an "else" from the above "if (apic->apicv_active)".  I=
 also
> think KVM can safely clear irr_pending in this case, which is also why ir=
r_pending
> isn't handling in kvm_apic_update_apicv().  When APICv is disabled (inhib=
ited) at
> runtime, an IRQ may be in-flight, i.e. apic_search_irr() can get a false =
negative.

Thank you for your review and suggestions.

>
> But when stuffing APIC state, I don't see how that can happen.  So this?

Here is our case.

APICv is disabled by set enable_apicv to 0. Create VM snapshot, then
start/restore
new VM base the snapshot. We occasionally encountered issues with VMs hangi=
ng
for long periods of time after restore. Investigation show that there
is a timer IRQ
pending in IRR, but the newly restored VM could not detect it, because
irr_pending
is not set when restoring the APIC state by kvm_apic_set_state().

Further investigation show when creating VM snapshot, VMM pause VCPUs by si=
gnal,
an in-flight timer pending in IRR, and the tscdeadline is 0 in saved
APIC state. All these
contexts in saved APIC state prove that kvm_inject_pending_timer_irqs
had just injected
a timer (will also set the tscdeadline to 0) before the VCPU handle the sig=
nal.

Maybe this patch is a fix for 755c2bf87860 (KVM: x86: lapic: don't
touch irr_pending in
kvm_apic_update_apicv when inhibiting it), the irr_pending enable
check is missed in
kvm_apic_set_state() after that.

>
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 65412640cfc7..deb73aea2c06 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -3086,6 +3086,15 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, stru=
ct kvm_lapic_state *s)
>                 kvm_x86_call(hwapic_irr_update)(vcpu,
>                                                 apic_find_highest_irr(api=
c));
>                 kvm_x86_call(hwapic_isr_update)(apic_find_highest_isr(api=
c));
> +       } else {
> +               /*
> +                * Note, kvm_apic_update_apicv() is responsible for updat=
ing
> +                * isr_count and highest_isr_cache.  irr_pending is somew=
hat
> +                * special because it mustn't be cleared when APICv is di=
sabled
> +                * at runtime, and only state restore can cause an IRR bi=
t to
> +                * be set without also refreshing irr_pending.
> +                */
> +               apic->irr_pending =3D apic_search_irr(apic) !=3D -1;
>         }
>         kvm_make_request(KVM_REQ_EVENT, vcpu);
>         if (ioapic_in_kernel(vcpu->kvm))
>
> > +             apic->irr_pending =3D true;
> >       kvm_make_request(KVM_REQ_EVENT, vcpu);
> >       if (ioapic_in_kernel(vcpu->kvm))
> >               kvm_rtc_eoi_tracking_restore_one(vcpu);
> > --
> > 2.43.5
> >

