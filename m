Return-Path: <kvm+bounces-20948-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3498E927315
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 11:31:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 64FFF1C2114E
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 09:31:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03CCF194C81;
	Thu,  4 Jul 2024 09:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VoQLTDuG"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1D5C171A7
	for <kvm@vger.kernel.org>; Thu,  4 Jul 2024 09:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720085494; cv=none; b=eVM+begpkx8qSR2Qu+LO/OsrFBsZ/H6jZDN0EDH5rPHsYcPfHi8460ddNbYKSVOeEzhwXoR5Gy1YFfE6dixMs3Qdq7+pZuOSFY8ReH1wlodoJ0ljd+P+XLn02djAeCYb0XumD07QWYTRHTs1dzi4nepo+a50PmGv19Inl5GhW+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720085494; c=relaxed/simple;
	bh=M3Q/C/0aBv+/QAM0vww824JYxIHbIM9Lr0w5wE5qIrs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WhdRGD0+FYq4788fQt9z7bQNjv4+0OI0bqTMGrwo9d/06jZSJ+dD2YoeeuPDlvM/7Rf5tNSfKhgLjHraF0NxuebZeqZphKE6J7JcV2G1afFyhWNLhaZ9SGMUmkHwjzOSfIfcR8WMK5tVjLe7iH2JsoJO3TQ7nI/51wzUOKUZ9uM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VoQLTDuG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720085491;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kxNojJQhevmJiR5jUJTMNLDBmomzLCrmfrhYNJxWwrk=;
	b=VoQLTDuGpdVpckTCqfoBcQ5XzfF3DmkQNA5AksaZQcw5ZTS149tNsjrlM8dnS5vYJetQfm
	HrrVx1tEtLCJEa/LHxr6IbtbkCf9gTA6daQM9RPh34OspbKfMQvIBJNrGGRUjaj67jyP7X
	hS7QzAWtCIvq1JeGp2CLW7NtoD63xrs=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-526-sgEKSlCuNE2vdyjq77JhoA-1; Thu, 04 Jul 2024 05:31:29 -0400
X-MC-Unique: sgEKSlCuNE2vdyjq77JhoA-1
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-2ee87e69b53so5314201fa.0
        for <kvm@vger.kernel.org>; Thu, 04 Jul 2024 02:31:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720085488; x=1720690288;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kxNojJQhevmJiR5jUJTMNLDBmomzLCrmfrhYNJxWwrk=;
        b=O/2/OXleOHkGmkwC3/DXQ+D+w9H3YGoxdsTItClmXBDU57FZJkrJEU9w09yqAe9m8b
         dJCSV8EmPzHf6J2/0QRer506hCyhhlcdzmArwKaSkEoC8tqwRVoteSB3pg6/RHzsIA0u
         GC0eJ5H+L7iUFjwrJ5Y75gHv8pjBM0XxFuH0roYM2iJYDoHhep2T6eXumHhc3kXM/qtO
         B2QW1pDXADQ1QFRxHGOth1hvOyLeRiOwbejOII0q0FnsG5jsJcIJv0IpAi77Vg7ams56
         l+Aj36DYB75YTNPJ8h53SOyUOt1itUt4eLkobTBFraiMurV0PQs5Zh1RZlGyvwlm4Q/r
         avzA==
X-Forwarded-Encrypted: i=1; AJvYcCUVzK5B+HX4wF8HakiDncrK0o9eAmwCjqVykNGQd8JnPhW0xeKZmdXGvgDglHPQZfA8+UFmC4ay+GNh8481bAgy2kxZ
X-Gm-Message-State: AOJu0Yyu+Tiretkqrqos6tH9neUC97Nhm8pRqYhH8OLErRl2KpRSqcsm
	s5rX4lDOpPx/d7xL0p9TlMVSPZW3EIb7PuneNJwRXpsTSA65gSKYeqnhD6UYi/O/bMHBWu8ocJ1
	3VT7fLXXetqnh3x3oUO5X+h8Y99pIJhuodLM+QtiOdnCVEYvfG0ziXGTcPMCdSSNGsTeEAcQ7Ma
	HwVD9v5yXHK23uhCAQT3qMOgOe
X-Received: by 2002:a2e:9ad4:0:b0:2ee:8566:32cb with SMTP id 38308e7fff4ca-2ee8ed91179mr8615441fa.16.1720085488334;
        Thu, 04 Jul 2024 02:31:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGVbVO4d+JOSmyjsLo6p8Y4Usmvfss8knt2bViouPT6u4HSsDLVbHbNmD8TcEEVPjVTziY4gUfUv0aH0IDagiM=
X-Received: by 2002:a2e:9ad4:0:b0:2ee:8566:32cb with SMTP id
 38308e7fff4ca-2ee8ed91179mr8615341fa.16.1720085487933; Thu, 04 Jul 2024
 02:31:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240704000019.3928862-1-michael.roth@amd.com>
 <CABgObfYX+nDnQSW5xyT3SjYbQ72--EW5buCkUuG_Z_JPFqfQNA@mail.gmail.com> <ZoZge_2UT_yRJE56@redhat.com>
In-Reply-To: <ZoZge_2UT_yRJE56@redhat.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 4 Jul 2024 11:31:16 +0200
Message-ID: <CABgObfbf1u_RvRTcoZFepFWdavFnkqNwUCwHm1nE4tNKmM8+pA@mail.gmail.com>
Subject: Re: [PATCH] i386/sev: Don't allow automatic fallback to legacy KVM_SEV*_INIT
To: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>
Cc: Michael Roth <michael.roth@amd.com>, qemu-devel@nongnu.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 4, 2024 at 10:42=E2=80=AFAM Daniel P. Berrang=C3=A9 <berrange@r=
edhat.com> wrote:
>
> On Thu, Jul 04, 2024 at 08:51:05AM +0200, Paolo Bonzini wrote:
> > On Thu, Jul 4, 2024 at 2:01=E2=80=AFAM Michael Roth <michael.roth@amd.c=
om> wrote:
> > > Currently if the 'legacy-vm-type' property of the sev-guest object is
> > > left unset, QEMU will attempt to use the newer KVM_SEV_INIT2 kernel
> > > interface in conjunction with the newer KVM_X86_SEV_VM and
> > > KVM_X86_SEV_ES_VM KVM VM types.
> > >
> > > This can lead to measurement changes if, for instance, an SEV guest w=
as
> > > created on a host that originally had an older kernel that didn't
> > > support KVM_SEV_INIT2, but is booted on the same host later on after =
the
> > > host kernel was upgraded.
> >
> > I think this is the right thing to do for SEV-ES. I agree that it's
> > bad to require a very new kernel (6.10 will be released only a month
> > before QEMU 9.1), on the other hand the KVM_SEV_ES_INIT API is broken
> > in several ways. As long as there is a way to go back to it, and it's
> > not changed by old machine types, not using it for SEV-ES is the
> > better choice for upstream.
>
> Broken how ?   I know there was the regression with the 'debug_swap'
> parameter, but was something that should just be fixed in the kernel,
> rather than breaking userspace. What else is a problem ?

The debug_swap parameter simply could not be enabled in the old API
without breaking measurements. The new API *is the fix* to allow using
it (though QEMU doesn't have the option plumbed in yet). There is no
extensibility.

Enabling debug_swap by default is also a thorny problem; it cannot be
enabled by default because not all CPUs support it, and also we'd have
the same problem that we cannot enable debug_swap on new machine types
without requiring a new kernel. Tying the default to the -cpu model
would work but it is confusing.

But I guess we can add support for debug_swap, disabled by default and
switch to the new API if debug_swap is enabled.

> I don't think its reasonable for QEMU to require a brand new kernel
> for new machine types, given SEV & SEV-ES have been deployed for
> many years already.

I think it's reasonable if the fix is displayed right into the error
message. It's only needed for SEV-ES though, SEV can use the old and
new APIs interchangeably.

Paolo


