Return-Path: <kvm+bounces-43988-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B37BCA99646
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 19:17:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A1D359206ED
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 17:16:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4FB328BAB7;
	Wed, 23 Apr 2025 17:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JyBLkBSc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60F4E28BA95
	for <kvm@vger.kernel.org>; Wed, 23 Apr 2025 17:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745428570; cv=none; b=gDYcrDF25ySm9dlvndzIsUcjakBUOjocyhaduMhuHGyz4o6YZjNSvHpUll5LMMEEaD3vjXc5KB5kWTMI48j0k/QEHpaoDgVhnMKWcAySh9Iab5N9qPSheciR/4zDudHOnAnhKJnzqZ9n8Sv5mvP2TMI5IzFd0+eokUl/P+6sU/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745428570; c=relaxed/simple;
	bh=s8DhHlPJWvIsgbsoToLAZ45tVx7yVHr17rRzAAX9TR0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ly1RTpihOqRUuCC9iDTg9KrQMhAdsec6H+wmcbKecQj8AyXoUpU1z4310s1HxLVpVZj2RF/f9zAhql/doyiQpF4FmCjXR/HaWUab/5k8gTCPCmunkWri6SBpX9RM/rX2Klz5k6klbw/1pkm0CWqNPEA6Ousbm8tt2iAn3S4aags=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JyBLkBSc; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ff6af1e264so124896a91.3
        for <kvm@vger.kernel.org>; Wed, 23 Apr 2025 10:16:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745428568; x=1746033368; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hrqmrLz7e0CPs0ksITZKUWYoX57wzVXLqGxivpIF80E=;
        b=JyBLkBSchR4xLHbeRgBEugPxLKnCtmkw5CjaOsRdl96jefVgOcVoOTuAyyeNvPhztp
         EXtR9UiRbago5Ze9La5oW5y+e/QWC8msbtUXA/dRxlAPN6pOqrt3hcHpCq9ucYdxyN0W
         dIQLBlsemqJ+wPUdAC4ECvJt43HVn8FXpuEh78BJ6aNeIdh/8nc/9FIKIN83h3ucu+wA
         3NDDuHRBrf6dr+JOQ8XmRYihW5l5N59aCoPCKKN6IcSvHDUIVMYDdmu2Pgd8CBITkj9A
         xINB6457sT6YVfifLUvkKcst2EE0V0x+bKQTd5hWnAhMIZ3OSQf49WEZyOeGJnDkcxxV
         Z01g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745428568; x=1746033368;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hrqmrLz7e0CPs0ksITZKUWYoX57wzVXLqGxivpIF80E=;
        b=qjcpOWwmjljzEcUvhAWZZlaFKw7kGvBAQKyNINAfL+eFYSAEjZzOmG1O+bVmIMVzxK
         xiYjkn9eERHreP51DuopSLNRmd/IumaS6/aSfwdjywktnrzpaHpZgdMWYBg3Et7ecb+s
         gcdFW5eeZ53pW5hlti5GC6X5vNTiLuEqTF7oq8i73x3K3AF6NIHX6WBIBI96LDysoPLQ
         IGS2GuImztwe7byHq2I6x4aI08bovLaWHM0Nyj/pnyeuJWDRDLhrinfjL0mv9LAffnt4
         dlXntwc2uySYPXB0oqI+VADbb5BhUnnW1Y1+0Ns0Luge02nz9sq/itN4MAxEsLsJ6bbw
         c7Vw==
X-Forwarded-Encrypted: i=1; AJvYcCU7jNVy7eRluPA7CIRzJtONl85KdgKiDQixU5oybsqxQHxecZiVZb1wRTL7+yS7mMxIbaM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyxhJ0NI7PpLa3kSe+0KaHzbeoiu2tflVp3ql8dCA9/1NW6Yh1E
	OyLVTeM5k/86zOzKUIk5o/1DlibctyclMoPz90yg2o/wFUGkVaXOSP7+Gw069t5tjVVGUNj+ScU
	H9w==
X-Google-Smtp-Source: AGHT+IHLl6jkGiLQ4wjyLG3esw4ZiRer7DcAc6NZDcDEWXrrD9hY5sUS0R/HiYWJa9E59RXMPwv8rRlRphU=
X-Received: from pji5.prod.google.com ([2002:a17:90b:3fc5:b0:2ff:4ba2:f3a5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5690:b0:2ff:52b8:2767
 with SMTP id 98e67ed59e1d1-3087bb69163mr27347605a91.19.1745428568576; Wed, 23
 Apr 2025 10:16:08 -0700 (PDT)
Date: Wed, 23 Apr 2025 10:16:07 -0700
In-Reply-To: <CABQX2QPUsKfkKYKnXG01A-jEu_7dbY7qBnEHyhYJnsSXD-jqng@mail.gmail.com>
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
Message-ID: <aAkgV3ja9NbDsrju@google.com>
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
> On Wed, Apr 23, 2025 at 11:54=E2=80=AFAM Sean Christopherson <seanjc@goog=
le.com> wrote:
> > > I'd say that if we desperately want to use a single cap for all of
> > > these then I'd probably prefer a different approach because this woul=
d
> > > make vmware_backdoor_enabled behavior really wacky.
> >
> > How so?  If kvm.enable_vmware_backdoor is true, then the backdoor is en=
abled
> > for all VMs, else it's disabled by default but can be enabled on a per-=
VM basis
> > by the new capability.
>=20
> Like you said if  kvm.enable_vmware_backdoor is true, then it's
> enabled for all VMs, so it'd make sense to allow disabling it on a
> per-vm basis on those systems.
> Just like when the kvm.enable_vmware_backdoor is false, the cap can be
> used to enable it on a per-vm basis.

Why?  What use case does that serve?

> > > It's the one that currently can only be set via kernel boot flags, so=
 having
> > > systems where the boot flag is on and disabling it on a per-vm basis =
makes
> > > sense and breaks with this.
> >
> > We could go this route, e.g. KVM does something similar for PMU virtual=
ization.
> > But the key difference is that enable_pmu is enabled by default, wherea=
s
> > enable_vmware_backdoor is disabled by default.  I.e. it makes far more =
sense for
> > the capability to let userspace opt-in, as opposed to opt-out.
> >
> > > I'd probably still write the code to be able to disable/enable all of=
 them
> > > because it makes sense for vmware_backdoor_enabled.
> >
> > Again, that's not KVM's default, and it will never be KVM's default.
>=20
> All I'm saying is that you can enable it on a whole system via the
> boot flags and on the systems on which it has been turned on it'd make
> sense to allow disabling it on a per-vm basis.

Again, why would anyone do that?  If you *know* you're going to run some VM=
s
with VMware emulation and some without, the sane approach is to not touch t=
he
module param and rely entirely on the capability.  Otherwise the VMM must b=
e
able to opt-out, which means that running an older userspace that doesn't k=
now
about the new capability *can't* opt-out.

The only reason to even keep the module param is to not break existing user=
s,
e.g. to be able to run VMs that want VMware functionality using an existing=
 VMM.

> Anyway, I'm sure I can make it work correctly under any constraints, so l=
et
> me try to understand the issue because I'm not sure what we're solving he=
re.
> Is the problem the fact that we have three caps and instead want to squee=
ze
> all of the functionality under one cap?

The "problem" is that I don't want to add complexity and create ABI for a u=
se
case that doesn't exist.

