Return-Path: <kvm+bounces-23424-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B22FE949764
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 20:15:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DE2451C215C3
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 18:15:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3371770FD;
	Tue,  6 Aug 2024 18:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FPNjut5F"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C4575BAF0
	for <kvm@vger.kernel.org>; Tue,  6 Aug 2024 18:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722968094; cv=none; b=kPETOgZGhqB0SjFRdTegAF1J+lM7eUNAqwfa/O+T1NpWhi7+J6GDJGvNYwu/K6P1KsJmv8B5pTyfgIvucmigadJAmDMHqEaP0gYEjj+Z4uHgnZYED4OkjCYDZx9zjyymOwe3H4VNByiixP+joWMy4rYQfsAJijVj5FPiZ+ifL5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722968094; c=relaxed/simple;
	bh=nbOH63i1r/yo44GYJ2h3kR6UlpygqBW02KmvGZREjcE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=T8SX+zPyK2stt2zn4U40a4yw2v9qfF/mY7iXevjjCg+UxVwQL2LYzUYxBioW9aRUh2ElXuO9uWe42NMQBaSavuv5ZXXIJ6Oy+2BYkz7cY70ovs+In055qY2H2JMPWN4HFpzfPbXB3hmfjrABq/y0xDxYohk+9Cm+E0y5jYCtyAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FPNjut5F; arc=none smtp.client-ip=209.85.160.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-260f94067bcso448024fac.3
        for <kvm@vger.kernel.org>; Tue, 06 Aug 2024 11:14:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722968091; x=1723572891; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mFdjbs2mjIASOsCu96qW8fLgpB9sbXImHOr5xadmr5E=;
        b=FPNjut5FewEZr6GxRbL41IbJuX9XFhyWGe8z8mwYGLOtlT4Bl8Wwv8LMUTGcJa9v1k
         mtAlKuXpJT+QczSIx8BEBM9gD+mecQXkyAfouEA23whCRWa7zKKjmTflPCFRfJQXAP72
         qK2HwtELbOjX2Ruh3ISVaHUS4/1A9OcbvXBe8XtITG3SllQ+4xGs0VKtZYoSmKlLvwiD
         K6fmUiWQ+cyuq6zhL5DDTzm+Sz9mfUoEOcoE4Cbdm7+HUXKRcPgp7nnXIbmdx+9B/UYF
         2NsQTe77gyLOfvpsd57qlAXzayVY/p4SY20m2AYRN8qw3bHWK5jZ0WJdGBh1LW9n0mY7
         fwEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722968091; x=1723572891;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mFdjbs2mjIASOsCu96qW8fLgpB9sbXImHOr5xadmr5E=;
        b=gyzvdQPsnPPacy8CNhMlWLP7mEYDol4ujROQB0AU04dY7Prm6GWHqKB8gmmTPgMUne
         yErxXis8HNQ8aWRYOp2bhwAZ1rMbTl6xOdsO3zT0AmHSIjgGqqF0KxYx0WHmIfYkSWRB
         MrxYyIcPUMhuN0iZ2aGe74UDy1Qf3FrXkWcT3/XVRUtTgj9fL8JVY1k0WjXS7vUup32h
         wX2yQTuPDDILkFP+LNf5bRxfGHaCxr2aXvDRpR5dSig76jGbvByIaOf0K9DJ9xFUIsSi
         RELLR6dsI6u+r3oaTBvtcvoFfBuwqzRYAlJmaGEMe+zG9c8iubaMtIIGGi3qxAE/642T
         wtJw==
X-Forwarded-Encrypted: i=1; AJvYcCVA98Y5fAOWyXC9933m878GKNIa81uiGgXwxpqzVqcHJsQ0kGPwq8zzLoZWy0y/4UtvC3N/Mbs3sBmIvE3qXNEbUJ7b
X-Gm-Message-State: AOJu0Ywcn7ANsaInt3DjvraL0eyx14HCDc9tYk4H3w+nKlfiI5xkYBya
	UuhhB4KVnRj6GLdzs3ScTELiBmkNrPlNfI6X3J9GMZdJs2saAhdyhJuSMGk3JuTbBDNeYKlv0+l
	SpcdBofhshaLSCPHkEzhuHs+il6ju92YVyGMafoitLrybNHi+lbBC
X-Google-Smtp-Source: AGHT+IFu4ku3WutNT7glrafGrvIvbfxBCcvM0b4ZV/axE4JgynlazXi+vp9yAoARE88Q8l5LZbFYEorYd+u/vifTLrw=
X-Received: by 2002:a05:6870:b61b:b0:254:a753:d1c0 with SMTP id
 586e51a60fabf-26891ece96fmr20000977fac.48.1722968091357; Tue, 06 Aug 2024
 11:14:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240802224031.154064-1-amoorthy@google.com> <20240802224031.154064-3-amoorthy@google.com>
 <ZrFXcHnhXUcjof1U@linux.dev>
In-Reply-To: <ZrFXcHnhXUcjof1U@linux.dev>
From: Anish Moorthy <amoorthy@google.com>
Date: Tue, 6 Aug 2024 11:14:15 -0700
Message-ID: <CAF7b7mouOmmDsU23r74s-z6JmLWvr2debGRjFgPdXotew_nAfA@mail.gmail.com>
Subject: Re: [PATCH 2/3] KVM: arm64: Declare support for KVM_CAP_MEMORY_FAULT_INFO
To: Oliver Upton <oliver.upton@linux.dev>
Cc: seanjc@google.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	jthoughton@google.com, rananta@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 5, 2024 at 3:51=E2=80=AFPM Oliver Upton <oliver.upton@linux.dev=
> wrote:
>
> The wording of the cap documentation isn't as relaxed as I'd
> anticipated. Perhaps:
>
>   The presence of this capability indicates that KVM_RUN *may* fill
>   kvm_run.memory_fault if ...
>
> IOW, userspace is not guaranteed that the structure is filled for every
> 'memory fault'.

Agreed, I can add a patch to update the docs

While we're at it, what do we think of removing this disclaimer?

>Note: Userspaces which attempt to resolve memory faults so that they can r=
etry
> KVM_RUN are encouraged to guard against repeatedly receiving the same
> error/annotated fault.

I originally added this bit due to my concerns with the idea of
filling kvm_run.memory_fault even for EFAULTs that weren't guaranteed
to be returned by KVM_RUN [1]. However if I'm interpreting Sean's
response to [2] correctly, I think we're now committed to only
KVM_EXIT_MEMORY_FAULTing for EFAULTs/EHWPOISONs which return from
KVM_RUN. At the very least, that seems to be true of current usages.

[1] https://lore.kernel.org/kvm/CAF7b7mrDt6sPQiTenSiqTOHORo1TSPhjSC-tt8fJtu=
q55B86kg@mail.gmail.com/
[2] https://lore.kernel.org/kvm/CAF7b7mqYr0J-J2oaU=3Dc-dzLys-m6Ttp7ZOb3Em7n=
1wUj3rhh+A@mail.gmail.com/#t

> > -:Architectures: x86
> > +:Architectures: x86, arm64
>
> nitpick: alphabetize
>
> >  :Returns: Informational only, -EINVAL on direct KVM_ENABLE_CAP.
> >
> >  The presence of this capability indicates that KVM_RUN will fill
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index a7ca776b51ec..4121b5a43b9c 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -335,6 +335,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, l=
ong ext)
> >       case KVM_CAP_ARM_SYSTEM_SUSPEND:
> >       case KVM_CAP_IRQFD_RESAMPLE:
> >       case KVM_CAP_COUNTER_OFFSET:
> > +     case KVM_CAP_MEMORY_FAULT_INFO:
> >               r =3D 1;
> >               break;
>
> Please just squash this into the following patch. Introducing the
> capability without the implied functionality doesn't make a lot of
> sense.
>
> --
> Thanks,
> Oliver

