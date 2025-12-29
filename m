Return-Path: <kvm+bounces-66805-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E658CE85BF
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 00:46:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 384023021746
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 23:46:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FB2B2FBDF5;
	Mon, 29 Dec 2025 23:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ok7oz4Xh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 200CA2853F2
	for <kvm@vger.kernel.org>; Mon, 29 Dec 2025 23:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767051995; cv=none; b=aIQbXxYSbRzexhG3Le/bQHvKMyQI0N93EXo89QCH6n12NNktuG3ZVQbBhjb2D3UdTyL9kWvn6oPbEoM5RLpb8goKaXDj3gJxl7b0T+HXKvOlVB+oSqn0CNHoDdNE/llf4olVlybKxgsc6V2QatZRnTo7ddG/Q3UioY5wHHU8CXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767051995; c=relaxed/simple;
	bh=Hjv/TIV1UsxvAnQ5o/hxVXWRY8sl9BefdtdnfhdDtCU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Mh57jJbwnLNqPN2M4v3LIRnfanQyTL/+hOisoNf7cKT7uv5gfhIcR7hE8V74AUqTbQ3/Y8ytevUGVY30nqKtNDMhzhgodOOylYY7/UI1VFMXN3fc7muTGXl/ujFQ3sbWbKFj7phdKjTavOLG5tlImQaeCUXP78G4mbp/hOIEKAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ok7oz4Xh; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34e70e2e363so21106433a91.1
        for <kvm@vger.kernel.org>; Mon, 29 Dec 2025 15:46:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767051993; x=1767656793; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l4xDJPMvIXKXvP5865Cb1+QQa5XZ/DHhQPRje5/U8PA=;
        b=ok7oz4XhZHvDJlf8nYmbn+eutgWWUTq7Y14M/qQ6IqH4vsZlbMG/hfRvSVWRTX4JNK
         jBT5ZHUL2tNUWFPIvW5Zm50WnpHJzo+AzAzGU4RW563zb5dIkG/GTwd3YizoTnpKnp8m
         dQWbkWY6JqEfKa7qjBx+ByYV6ElIegzZc0uD8/o02O4v8LXLDsjuOeVjkbzqYrlZMaGA
         GbtA48Rlo3iCCyHQsQZiAl/AlJYAWTObRo1xwOzgg3kfW5N6Pij0emlpQMbZtC9mq2Is
         b0eLJTydbFrXuE2r31C+hPxbXyxTq3pk5sOJRCvK4sJpxgdce99RL5v4l0Dp6uv0C1cj
         bLWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767051993; x=1767656793;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=l4xDJPMvIXKXvP5865Cb1+QQa5XZ/DHhQPRje5/U8PA=;
        b=rPDEyqtUxnwZ8Xl+yYHGRNGuh2SH+ZfYtvTNV+aaXJGyIYWWteAQU8Xxnr0y2mRnH/
         QlEcHCoAMHPl5ebrQVxtzoM2if17c+MhciwSvoTLjH8v3zYWJeD21vmLkBZDITiJeX4U
         /jHLEMwgaJ3DVTzEArWnHOBCaNFoYAPQ1Tmo56NO15F0Okke+qV8QpYujAPO2aNaualQ
         3SDKb96P5uMTYARJ/UJsP/Z+6S5zK8SQ5IIo4xpNBdjmm/yGL6BnUKb6mFPj3Hd0qH/A
         IthfQ5Ce/Ew90qwFEsAv4lD8UynubljHgvinBmh5IKXC/sRKLlmEk4bjTICEnLWyb7Xd
         gdqw==
X-Forwarded-Encrypted: i=1; AJvYcCWvIsPCKJ1rPzc6Hhk6qPZu4XoG4/q+YF5NXlC5yxmx3DD5flaNQmfpKvFxwWWSNu+tn7g=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzq7DR1wI+tJtCz8lTGtt55steMZaJ5iX4tjAXPJOAsP1+WB4MN
	+K8k8vKzdpZd9ndzn6mg4+8saalfQpOXAcEUeHZB1/nFofzUW9yONaGvGCxrJAMWl5HQ6BFy0Zs
	Nuxlk0g==
X-Google-Smtp-Source: AGHT+IGp6fI0koV588PCow0DDG4AaijuZIFTuoh8Uj8mqtB242NSfI8x+gcm6e8CNXigvxl5p4tFT0QHKwU=
X-Received: from pjot17.prod.google.com ([2002:a17:90a:9511:b0:349:a1a3:75fc])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:524b:b0:340:e529:5572
 with SMTP id 98e67ed59e1d1-34e9212a495mr26328433a91.8.1767051993309; Mon, 29
 Dec 2025 15:46:33 -0800 (PST)
Date: Mon, 29 Dec 2025 15:46:31 -0800
In-Reply-To: <CABgObfa5ViBjb_BnmKqf0+7M6rZ5-M+yOw_7tVK_Ek6tp21Z=w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251224001249.1041934-1-pbonzini@redhat.com> <20251224001249.1041934-3-pbonzini@redhat.com>
 <aVMEcaZD_SzKzRvr@google.com> <CABgObfa5ViBjb_BnmKqf0+7M6rZ5-M+yOw_7tVK_Ek6tp21Z=w@mail.gmail.com>
Message-ID: <aVMS1xa99GsiZpFQ@google.com>
Subject: Re: [PATCH 2/5] x86, fpu: separate fpstate->xfd and guest XFD
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 30, 2025, Paolo Bonzini wrote:
> On Mon, Dec 29, 2025 at 11:45=E2=80=AFPM Sean Christopherson <seanjc@goog=
le.com> wrote:
> > So, given that KVM's effective ABI is to record XSTATE_BV[i]=3D0 if XFD=
[i]=3D=3D1, I
> > vote to fix this by emulating that behavior when stuffing XFD in
> > fpu_update_guest_xfd(), and then manually closing the hole Paolo found =
in
> > fpu_copy_uabi_to_guest_fpstate().
>=20
> I disagree with changing the argument from const void* to void*.
> Let's instead treat it as a KVM backwards-compatibility quirk:
>=20
>     union fpregs_state *xstate =3D
>         (union fpregs_state *)guest_xsave->region;
>     xstate->xsave.header.xfeatures &=3D
>         ~vcpu->arch.guest_fpu.fpstate->xfd;
>=20
> It keeps the kernel/ API const as expected and if anything I'd
> consider adding a WARN to fpu_copy_uabi_to_guest_fpstate(), basically
> asserting that there would be no #NM on the subsequent restore.

Works for me. =20

> > @@ -319,10 +319,25 @@ EXPORT_SYMBOL_FOR_KVM(fpu_enable_guest_xfd_featur=
es);
> >  #ifdef CONFIG_X86_64
> >  void fpu_update_guest_xfd(struct fpu_guest *guest_fpu, u64 xfd)
> >  {
> > +       struct fpstate *fpstate =3D guest_fpu->fpstate;
> > +
> >         fpregs_lock();
> > -       guest_fpu->fpstate->xfd =3D xfd;
> > -       if (guest_fpu->fpstate->in_use)
> > -               xfd_update_state(guest_fpu->fpstate);
> > +       fpstate->xfd =3D xfd;
> > +       if (fpstate->in_use)
> > +               xfd_update_state(fpstate);
> > +
> > +       /*
> > +        * If the guest's FPU state is NOT resident in hardware, clear =
disabled
> > +        * components in XSTATE_BV as attempting to load disabled compo=
nents
> > +        * will generate #NM _in the host_, and KVM's ABI is that savin=
g guest
> > +        * XSAVE state should see XSTATE_BV[i]=3D0 if XFD[i]=3D1.
> > +        *
> > +        * If the guest's FPU state is in hardware, simply do nothing a=
s XSAVE
> > +        * itself saves XSTATE_BV[i] as 0 if XFD[i]=3D1.
>=20
> s/saves/(from fpu_swap_kvm_fpstate) will save/
>=20
> > +        */
> > +       if (xfd && test_thread_flag(TIF_NEED_FPU_LOAD))
> > +               fpstate->regs.xsave.header.xfeatures &=3D ~xfd;
>=20
> No objections to this part.  I'll play with this to adjust the
> selftests either tomorrow or, more likely, on January 2nd, and send a
> v2 that also includes the change from preemption_disabled to
> irqs_disabled.

To hopefully save you some time, I responded to the selftests with cleanups=
 and
adjustments to hit both bugs (see patch 3).

> I take it that you don't have any qualms with the new
> fpu_load_guest_fpstate function,

Hmm, I don't have a strong opinion?  Actually, after looking at patch 5, I =
agree
that adding fpu_load_guest_fpstate() is useful.  My only hesitation was tha=
t
kvm_fpu_{get,put}() would be _very_ similar, but critically different, at w=
hich
point NOT using fpu_update_guest_xfd() in kvm_fpu_get() could be confusing.

> but let me know if you prefer to have it in a separate submission destine=
d to
> 6.20 only.

I'd say don't send it to stable@, otherwise I don't have a preference on 6.=
19
versus 6.20.

