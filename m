Return-Path: <kvm+bounces-44008-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 678CEA99838
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 20:58:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8774F4A0C16
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 18:58:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC22028FFF5;
	Wed, 23 Apr 2025 18:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GxxSMh9u"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8394528F531
	for <kvm@vger.kernel.org>; Wed, 23 Apr 2025 18:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745434684; cv=none; b=PEJk87nrzXl097dNShZu9RYLVccssiQ82fqJ4zDMpmg9VboiBtQP4SjkIWE8ARqpixbIWUQ9IC/BleO4/s8X6rYrvFd3vOgNGmPQWWKdJf2ZfMUu5h5Q3f/o159Hz6MgtIErCDBIX+9q9vLtUkq1l76Ojcr81lCzRG7yLUIV5Hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745434684; c=relaxed/simple;
	bh=JVtcUVc7US+oTQaeQw+HQD5mxyfXQT0C1LC9Tz0ut/A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fAwbCVxEVhLniAAjGoECNPihDfaVXLSVwNpQU11pJX9KJ42eSnsbkcYgp2CyIkshap3c5ZzJIXof2oI59n60mnLp6XtyssAOA6I4vdC8iIEDBxG5JGWXlaAMSnQsH3xlHyJ7mJ5YUw9AMJSsjNa7+w23ESJKMW/W9CmB/65WXNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GxxSMh9u; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-af8f28f85a7so57561a12.2
        for <kvm@vger.kernel.org>; Wed, 23 Apr 2025 11:58:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745434682; x=1746039482; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aaXDtQDICrVid48fIAOG4chL/EvByd0GF5YvCsnDoyE=;
        b=GxxSMh9uxctMuvChBP526pBe5NNrHRDKPqHRpvGDAKNow2gqTRgzRHdvGmzRaU4Byo
         nbXYqb4vZIqluXfFOR9oLD7QKZ+A7AXbGjp8OKE/uOwWOJvowtwqjv1TSfAtt1gy4Hzk
         YU+lphDop5xr2KmNa+GREjhxUbyQjOw0pDaZr/jOwy0tN8vpyoqJ0sKROGvTpz1+nmJx
         MhNamEZjWDFzOH0/ltMygdO1Bya78ilsKf2B3D4ho8vb0xRtj9ncIVD/s3h0O/RaTUro
         +/CTdTLwIbMGx1l1D/9O0U8ZHExSFnyrTc0n5k3NF77ms2BX4xIst9Z0WxBprtV89CdP
         EqHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745434682; x=1746039482;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=aaXDtQDICrVid48fIAOG4chL/EvByd0GF5YvCsnDoyE=;
        b=SMeAHPEMkryswxJX2C51e3qavc/rBn6OmdmFNf44RTdEOEjubapu8eaoWDeVr0DuWG
         UC07NGUIZfl632np/4vu4FQtt63atj1d9rRGd7DAzJNQWuthdCItH8loFFAXU2upeJIW
         48gAGvDWr+PdcoixkGsXRN4UKwW4J31teE37nXH/N6mks22Jll4YUQWmxAaZIqWXoHoO
         5TWPxiYZiwJ3I5YR/RunCaUTnlIi0lumCDjH10RL2Z6q94flj/G7niQiXHbMLqqfu5uR
         zq8rctDDEJoCXbdPQRtKFVhs4/QJJuKF94CAa0k/qoRYzbcvjl5iz9N1QJiHB5Asts+C
         k+7w==
X-Forwarded-Encrypted: i=1; AJvYcCX5f/PASHSmEO6tPM8gn9aAmshq52N80PNEuSwh7sAK/t+/KwJIdJT47PY/pyG6h3+LtEk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyKVd0a7/AYO8PUcbMOuaNwEMBcSL0Vo7TO3Awf2zlOV9+sRvQJ
	DWaE4OpqfPS2xhCrUinbjnHFJ8D4mBcJgid2+IkJLimfETcehb9rYmtopusMIWm98B6nJ+yvgaj
	92g==
X-Google-Smtp-Source: AGHT+IGQ5NDwT7+wPfgEELFalTLORgQJexq0+s1pN2aLrlZiaK31u+Z+QuTxBath5TnsRBC9zdybUZTONlI=
X-Received: from pfia14.prod.google.com ([2002:a62:e20e:0:b0:736:5012:3564])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:158d:b0:1f5:9016:3594
 with SMTP id adf61e73a8af0-203cbc533f7mr31179674637.18.1745434681778; Wed, 23
 Apr 2025 11:58:01 -0700 (PDT)
Date: Wed, 23 Apr 2025 11:57:59 -0700
In-Reply-To: <CABQX2QMtQes5yiG4VBvQgWkuAoSWgcP8R+X7MeuV_xHeLfpznw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250422161304.579394-1-zack.rusin@broadcom.com>
 <20250422161304.579394-5-zack.rusin@broadcom.com> <a803c925-b682-490f-8cd9-ca8d4cc599aa@zytor.com>
 <CABQX2QMznYZiVm40Ligq+pFKmEkVpScW+zcKYbPpGgm0=S2Xkg@mail.gmail.com>
 <aAjrOgsooR4RYIJr@google.com> <CABQX2QNDmXizUDP_sckvfaM9OBTxHSr0ESgJ_=Z_5RiODfOGsg@mail.gmail.com>
 <aAkNN029DIxYay-j@google.com> <CABQX2QPUsKfkKYKnXG01A-jEu_7dbY7qBnEHyhYJnsSXD-jqng@mail.gmail.com>
 <aAkgV3ja9NbDsrju@google.com> <CABQX2QMtQes5yiG4VBvQgWkuAoSWgcP8R+X7MeuV_xHeLfpznw@mail.gmail.com>
Message-ID: <aAk4N0wYQeeYPLVM@google.com>
Subject: Re: [PATCH v2 4/5] KVM: x86: Add support for legacy VMware backdoors
 in nested setups
From: Sean Christopherson <seanjc@google.com>
To: Zack Rusin <zack.rusin@broadcom.com>
Cc: Xin Li <xin@zytor.com>, linux-kernel@vger.kernel.org, 
	Doug Covelli <doug.covelli@broadcom.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 23, 2025, Zack Rusin wrote:
> On Wed, Apr 23, 2025 at 1:16=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > On Wed, Apr 23, 2025, Zack Rusin wrote:
> > > On Wed, Apr 23, 2025 at 11:54=E2=80=AFAM Sean Christopherson <seanjc@=
google.com> wrote:
> > > > > I'd say that if we desperately want to use a single cap for all o=
f
> > > > > these then I'd probably prefer a different approach because this =
would
> > > > > make vmware_backdoor_enabled behavior really wacky.
> > > >
> > > > How so?  If kvm.enable_vmware_backdoor is true, then the backdoor i=
s enabled
> > > > for all VMs, else it's disabled by default but can be enabled on a =
per-VM basis
> > > > by the new capability.
> > >
> > > Like you said if  kvm.enable_vmware_backdoor is true, then it's
> > > enabled for all VMs, so it'd make sense to allow disabling it on a
> > > per-vm basis on those systems.
> > > Just like when the kvm.enable_vmware_backdoor is false, the cap can b=
e
> > > used to enable it on a per-vm basis.
> >
> > Why?  What use case does that serve?
>=20
> Testing purposes?

Heh, testing what?  To have heterogenous VMware emulation settings on a sin=
gle
host, at least one of the VMMs needs to have been updated to utilize the ne=
w
capability.  Updating the VMM that doesn't want VMware emulation makes zero=
 sense,
because that would limit testing to only the non-nested backdoor.

> > > > > It's the one that currently can only be set via kernel boot flags=
, so having
> > > > > systems where the boot flag is on and disabling it on a per-vm ba=
sis makes
> > > > > sense and breaks with this.
> > > >
> > > > We could go this route, e.g. KVM does something similar for PMU vir=
tualization.
> > > > But the key difference is that enable_pmu is enabled by default, wh=
ereas
> > > > enable_vmware_backdoor is disabled by default.  I.e. it makes far m=
ore sense for
> > > > the capability to let userspace opt-in, as opposed to opt-out.
> > > >
> > > > > I'd probably still write the code to be able to disable/enable al=
l of them
> > > > > because it makes sense for vmware_backdoor_enabled.
> > > >
> > > > Again, that's not KVM's default, and it will never be KVM's default=
.
> > >
> > > All I'm saying is that you can enable it on a whole system via the
> > > boot flags and on the systems on which it has been turned on it'd mak=
e
> > > sense to allow disabling it on a per-vm basis.
> >
> > Again, why would anyone do that?  If you *know* you're going to run som=
e VMs
> > with VMware emulation and some without, the sane approach is to not tou=
ch the
> > module param and rely entirely on the capability.  Otherwise the VMM mu=
st be
> > able to opt-out, which means that running an older userspace that doesn=
't know
> > about the new capability *can't* opt-out.
> >
> > The only reason to even keep the module param is to not break existing =
users,
> > e.g. to be able to run VMs that want VMware functionality using an exis=
ting VMM.
> >
> > > Anyway, I'm sure I can make it work correctly under any constraints, =
so let
> > > me try to understand the issue because I'm not sure what we're solvin=
g here.
> > > Is the problem the fact that we have three caps and instead want to s=
queeze
> > > all of the functionality under one cap?
> >
> > The "problem" is that I don't want to add complexity and create ABI for=
 a use
> > case that doesn't exist.
>=20
> Would you like to see a v3 where I specifically do not allow disabling
> those caps?

Yes.  Though I recommend waiting to send a v3 until I (and others) have had=
 a
change to review the rest of the patches, e.g. to avoid wasting your time.

