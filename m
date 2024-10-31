Return-Path: <kvm+bounces-30196-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CF139B7E2B
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 16:20:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F09672811A4
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 15:20:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 328931A256A;
	Thu, 31 Oct 2024 15:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BXJaIIcR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ABB919D098
	for <kvm@vger.kernel.org>; Thu, 31 Oct 2024 15:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730387792; cv=none; b=qjROxR5FZReGBuuGFkFjmkS0aWRC06WhYPI70/Iy4oe8io15KxnAwPMVfWkZVQJFoLvIzZABGequ85NlAmxJDm3JEutOBn4dfwAqjwvLqvpLJzra56PMGJqfxzns1WaQ9lPrhiFGeuMTa0JeIc0WED3LO9rsGyrGTnXAJjeVDtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730387792; c=relaxed/simple;
	bh=6iGWinUXtqbRxNAx0fpqrbY55VGEjPPTwMPQEwI4W/A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TijKrQgHMqwa2oa2Kvi4oSY/rkbm5DB7dwFCuRAvCn4A2RnnfRq4zioWDaS72V5nLuGU/lMB9YQzsvVe/EnQsR3qwXNWpp9vdBYy4AfpCdcRVa+djsExq2EHD/mvbo1y1KzQvWle9FrgCjaZjJ8L0nUfdFCVBl87lJZpPEjWxKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BXJaIIcR; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7eda7c4f014so1004427a12.3
        for <kvm@vger.kernel.org>; Thu, 31 Oct 2024 08:16:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730387790; x=1730992590; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7PC7N5+e08dtpORCdL76yKhFOdMWJc/mxzHSvNgjS1A=;
        b=BXJaIIcRFY0iD+dmHn65HY+nblNp339BHbcgWIfI8yoRiS86w9GYt7QTKBOAtouyUm
         AUd7jt59VL0YlLPCntNeDrRfuhu32mBvZ9bYD523oTN18k9INRD7XELa09SoFK24ieEj
         XPsNiG+ffdeXZJ0U/PYR6UcpkLxvfy/4WomynsK62zugATvxqTWRv6ZEB/z+grTrmJTv
         OO8MG+P5InTBAAKuglNAKIh2jHWx+9iAtWIkU5AWmLkhloS+wDr4qQcVYmtFSOFCKkvU
         IRQdhqDTwsyRtHb0BQJnpcSx2CFg42A/JZ6ZsPnYhvXvv+Vibq/lCy+1cRDd6dJfBd20
         H46g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730387790; x=1730992590;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=7PC7N5+e08dtpORCdL76yKhFOdMWJc/mxzHSvNgjS1A=;
        b=umRpvV7zmZiQsHrPvtKy6C1+f07P3vDpBAUtv5/yngRDtnADKBvpAc3qEA1LKCy0lo
         SInRfRZSDQDgz5NKUAdhdJ68DF/Ed9ZwPVWsD2Ld7J1s1Rzy/KHPAmyKNhe3EkJpRGyP
         C1PfU6fz2i5XxdO4c7faIjUj4OuQq+y4irlunzY9mfIHLQyFXCYU+Lu5JVNmqFZ/dQRn
         qs7pYuRrIUhY4Zw2iR/7Hb2tI7CrTWOIWPQQ2l9DmOIumlqktZGFYckN6ZeBisHbMjdS
         HgvpmP1EBEagmOc4r+bIoKXmyTbFikRu1/jJpO/IXw9NVNBqfcLgrD/pL/eXa2a/RyYZ
         B+CA==
X-Forwarded-Encrypted: i=1; AJvYcCUlkz/Y1gpH31ILEBni/bQPIDtaIVLTdplSLI61Sw06SvKaJFV7PERJtuTLULH1D04IAhQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxJ+SPsJE+pNlk8RY3fl+v7aj08+eFAG6fdI/fhqlyAoOuHZMVa
	B5cX3ep4lyIvfhQxZ+giD8++kZyQAq3djCVJ+xQWdpqVx6nwStnF2HLNQgJc0vLxexH+MRcpWYx
	4oQ==
X-Google-Smtp-Source: AGHT+IG2VFG7/21UDLie69cmQsjkP4oLuob/J4Q5NswUjJ5IYcEKrQBEaHPNe6mf4H6kwoposy0bS20kkOA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:6a02:2c08:b0:7ea:6bf4:3643 with SMTP id
 41be03b00d2f7-7ee27e02db2mr7131a12.0.1730387789754; Thu, 31 Oct 2024 08:16:29
 -0700 (PDT)
Date: Thu, 31 Oct 2024 08:16:28 -0700
In-Reply-To: <CANZk6aQEH=9EFdsBfuRcUWhTu88Oc=x=Wp3bcqzQd1AVjcTTEg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241023124527.1092810-1-alexyonghe@tencent.com>
 <ZyJ7ZsP4RaRfcFQF@google.com> <CANZk6aQEH=9EFdsBfuRcUWhTu88Oc=x=Wp3bcqzQd1AVjcTTEg@mail.gmail.com>
Message-ID: <ZyOfTCy5dJ32tzTr@google.com>
Subject: Re: [PATCH] KVM: x86: Try to enable irr_pending state with disabled APICv
From: Sean Christopherson <seanjc@google.com>
To: zhuangel570 <zhuangel570@gmail.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, wanpengli@tencent.com, 
	alexyonghe@tencent.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 31, 2024, zhuangel570 wrote:
> On Thu, Oct 31, 2024 at 2:31=E2=80=AFAM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > On Wed, Oct 23, 2024, Yong He wrote:
> > > From: Yong He <alexyonghe@tencent.com>
> > >
> > > Try to enable irr_pending when set APIC state, if there is
> > > pending interrupt in IRR with disabled APICv.
> > >
> > > In save/restore VM scenery with disabled APICv. Qemu/CloudHypervisor
> > > always send signals to stop running vcpu threads, then save
> > > entire VM state, including APIC state. There may be a pending
> > > timer interrupt in the saved APIC IRR that is injected before
> > > vcpu_run return. But when restoring the VM, since APICv is
> > > disabled, irr_pending is disabled by default, so this may cause
> > > the timer interrupt in the IRR to be suspended for a long time,
> > > until the next interrupt comes.
> > >
> > > Signed-off-by: Yong He <alexyonghe@tencent.com>
> > > ---
> > >  arch/x86/kvm/lapic.c | 4 ++++
> > >  1 file changed, 4 insertions(+)
> > >
> > > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > > index 2098dc689088..7373f649958b 100644
> > > --- a/arch/x86/kvm/lapic.c
> > > +++ b/arch/x86/kvm/lapic.c
> > > @@ -3099,6 +3099,10 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, =
struct kvm_lapic_state *s)
> > >                                               apic_find_highest_irr(a=
pic));
> > >               kvm_x86_call(hwapic_isr_update)(apic_find_highest_isr(a=
pic));
> > >       }
> > > +
> > > +     /* Search the IRR and enable irr_pending state with disabled AP=
ICv*/
> > > +     if (!enable_apicv && apic_search_irr(apic) !=3D -1)
> >
> > This can/should be an "else" from the above "if (apic->apicv_active)". =
 I also
> > think KVM can safely clear irr_pending in this case, which is also why =
irr_pending
> > isn't handling in kvm_apic_update_apicv().  When APICv is disabled (inh=
ibited) at
> > runtime, an IRQ may be in-flight, i.e. apic_search_irr() can get a fals=
e negative.
>=20
> Thank you for your review and suggestions.
>=20
> >
> > But when stuffing APIC state, I don't see how that can happen.  So this=
?
>=20
> Here is our case.

Sorry for not being clear.  I wasn't saying that the bug you encountered ca=
n't
happen.  I 100% agree it's a real bug.  What I was saying can't happen is a=
n
in-flight virtual IRQ from another vCPU or device racing with setting APIC =
state,
and the VM (or VMM) having any expectation that everything would work corre=
ctly.

And so, I think it's save for KVM to explicitly set irr_pending, i.e. to po=
tentially
_clear_ irr_pending.

If you are able to verify the psuedo-patch I posted fixes the bug you encou=
ntered,
that is how I would like to fix the bug.

