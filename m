Return-Path: <kvm+bounces-30282-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 635B09B8C2C
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 08:43:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 869A91C215EC
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 07:43:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25A1F1547FD;
	Fri,  1 Nov 2024 07:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DaZ1fmtp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F18E153BF8
	for <kvm@vger.kernel.org>; Fri,  1 Nov 2024 07:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730446990; cv=none; b=s3kIAGqE3YIwrtWmSrDfxqDVTKUNx0bqBL7lpxNDc0DLKh0IZRT+TKqZQvJRYC/8W6lPFovJWS1jsp2pL8WLaJCysJdRNkhdd4Z2ZXqzuXvvW7rRquHs9EuuGj6O9uBDOq9533eexcShJskUC3IomcfAnG5JdZhgiAB2NSAqkTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730446990; c=relaxed/simple;
	bh=tvNnV5MECZVRu+hlHAjQvdjf98SRgQrhsiBPP45sJMc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BTZ+Fxs99slQKCUqPIsVq7sEufNVk4jbhmnMrsesETr4Q5wz1tsMgdZui+loA2KWL/5W4XuLHcxzz7J8XCXNT36DX6wh4voVA1zRAakrU/TV03kMMxmWb0BkmNyTh+XzP3aSAV9qqw3VWk24lM3FDaXTniZ0T/QfWl/ScOl2hgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DaZ1fmtp; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-20cbca51687so16342915ad.1
        for <kvm@vger.kernel.org>; Fri, 01 Nov 2024 00:43:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730446987; x=1731051787; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dODtoQitSBROE/XsLMUd7NwCqUhJC+ZZvderyAPghfs=;
        b=DaZ1fmtpt+xGATJ1V07QkJqfVv/7EY318Lc0Srl+bBipva8IBq6JhhvTnd7uwTRhA1
         XxWQlxwE6CVvS5DcEpfuDdzo9NXJ45a/PNgL8jP4I5iDl7j2qARu2J0T63+XJd9ay+ht
         RYWl434/ICkdtXhuPwq/xCp44i4bhQ+O5OWABSSnHWV60IGgbu6O/BTS4L3A4Omsza5C
         QM4q8fvZ5SRy4KSNvHySFwP2jga4SLmpkbShQNPHIondIGYKz24YHTRbjLaTHvGvNhlF
         jtX+QqEwQKpBTSl0biikjkguZynLe1wdNX59Xpcvvl1WmEAsWztrPRquVRqoKX6L+GEz
         bz0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730446987; x=1731051787;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dODtoQitSBROE/XsLMUd7NwCqUhJC+ZZvderyAPghfs=;
        b=rPZTzexeDq0d4bJJ5Rmgg4CrtixZN4Yu3YpMnC0LB/EYfDb0WbCOsHJUsiCWT/oH1S
         jCZxacNZpSWSJWIxLlIoM0/PwfyE8OT6Wa4hyj+GJcmou63xftUHGyMPMOMI8nzN1908
         25tSipXDYuB2nquwnqusUxLQQoGd8Dm2uJdDjY6HEsIoUYftf4gG84iZcKuWiXgtjg8P
         RxGThOWNgEsO3coUK7eZyLlHNW3W0amukN2UM4pX+K/mFP/ih2CdHP0ABE+KMY4FGNXF
         IIAsy7aov8IL5bVyctQeJ5PsPXSlNuhhs2BXPmqNfypeuQxQbkqf9u554aPLW3meoN1+
         KcdA==
X-Forwarded-Encrypted: i=1; AJvYcCXC5cBxpuLyXlndlFLTB63uIUkCUUejfM1cZYs6WQ8/OB3My8pyQ4RctmP661QTVuBTYPU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzs7W6nO/y/zt0vC0RxJm0f6PnySHg5mkk+FhN6FBHPg/AVJxc0
	6HmXgFVj419OfsIn3NMMwrTpmB64OkiiV9zQiLlrO6nulGutHprp1JdTKpDSHsyh/dIlRIIsM2y
	I60Zc97KU8aoSr+JMZp/8up7DBEU=
X-Google-Smtp-Source: AGHT+IFCyc5usWs/7BxilId46aueDKh1a62dp0LNle3bBBnJHQlRodaSqn24Ui5wuhlH+o33ZgIijSPpk7HLFn4Nntw=
X-Received: by 2002:a17:90a:e7c2:b0:2e2:c406:ec84 with SMTP id
 98e67ed59e1d1-2e94c53a6a2mr3401475a91.38.1730446987434; Fri, 01 Nov 2024
 00:43:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241023124527.1092810-1-alexyonghe@tencent.com>
 <ZyJ7ZsP4RaRfcFQF@google.com> <CANZk6aQEH=9EFdsBfuRcUWhTu88Oc=x=Wp3bcqzQd1AVjcTTEg@mail.gmail.com>
 <ZyOfTCy5dJ32tzTr@google.com>
In-Reply-To: <ZyOfTCy5dJ32tzTr@google.com>
From: zhuangel570 <zhuangel570@gmail.com>
Date: Fri, 1 Nov 2024 15:42:56 +0800
Message-ID: <CANZk6aTQ5fn3AaKZq1uj1r45U6TMfkympu66yUEzEj_=ugQ51w@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Try to enable irr_pending state with disabled APICv
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, wanpengli@tencent.com, 
	alexyonghe@tencent.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 31, 2024 at 11:16=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
>
> On Thu, Oct 31, 2024, zhuangel570 wrote:
> > On Thu, Oct 31, 2024 at 2:31=E2=80=AFAM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> > >
> > > On Wed, Oct 23, 2024, Yong He wrote:
> > > > From: Yong He <alexyonghe@tencent.com>
> > > >
> > > > Try to enable irr_pending when set APIC state, if there is
> > > > pending interrupt in IRR with disabled APICv.
> > > >
> > > > In save/restore VM scenery with disabled APICv. Qemu/CloudHyperviso=
r
> > > > always send signals to stop running vcpu threads, then save
> > > > entire VM state, including APIC state. There may be a pending
> > > > timer interrupt in the saved APIC IRR that is injected before
> > > > vcpu_run return. But when restoring the VM, since APICv is
> > > > disabled, irr_pending is disabled by default, so this may cause
> > > > the timer interrupt in the IRR to be suspended for a long time,
> > > > until the next interrupt comes.
> > > >
> > > > Signed-off-by: Yong He <alexyonghe@tencent.com>
> > > > ---
> > > >  arch/x86/kvm/lapic.c | 4 ++++
> > > >  1 file changed, 4 insertions(+)
> > > >
> > > > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > > > index 2098dc689088..7373f649958b 100644
> > > > --- a/arch/x86/kvm/lapic.c
> > > > +++ b/arch/x86/kvm/lapic.c
> > > > @@ -3099,6 +3099,10 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu=
, struct kvm_lapic_state *s)
> > > >                                               apic_find_highest_irr=
(apic));
> > > >               kvm_x86_call(hwapic_isr_update)(apic_find_highest_isr=
(apic));
> > > >       }
> > > > +
> > > > +     /* Search the IRR and enable irr_pending state with disabled =
APICv*/
> > > > +     if (!enable_apicv && apic_search_irr(apic) !=3D -1)
> > >
> > > This can/should be an "else" from the above "if (apic->apicv_active)"=
.  I also
> > > think KVM can safely clear irr_pending in this case, which is also wh=
y irr_pending
> > > isn't handling in kvm_apic_update_apicv().  When APICv is disabled (i=
nhibited) at
> > > runtime, an IRQ may be in-flight, i.e. apic_search_irr() can get a fa=
lse negative.
> >
> > Thank you for your review and suggestions.
> >
> > >
> > > But when stuffing APIC state, I don't see how that can happen.  So th=
is?
> >
> > Here is our case.
>
> Sorry for not being clear.  I wasn't saying that the bug you encountered =
can't
> happen.  I 100% agree it's a real bug.  What I was saying can't happen is=
 an
> in-flight virtual IRQ from another vCPU or device racing with setting API=
C state,
> and the VM (or VMM) having any expectation that everything would work cor=
rectly.
>
> And so, I think it's save for KVM to explicitly set irr_pending, i.e. to =
potentially
> _clear_ irr_pending.

Got it, thanks.

>
> If you are able to verify the psuedo-patch I posted fixes the bug you enc=
ountered,
> that is how I would like to fix the bug.

Yes, your patch may fix the issue better, and I have checked on my test mac=
hine
and it is fixed.

