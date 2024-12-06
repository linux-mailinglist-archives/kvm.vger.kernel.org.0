Return-Path: <kvm+bounces-33185-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D4DD9E62E4
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 02:02:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D505C2812CA
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 01:02:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40C1E76048;
	Fri,  6 Dec 2024 01:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0dp/80df"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8FF21DDD1
	for <kvm@vger.kernel.org>; Fri,  6 Dec 2024 01:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733446942; cv=none; b=IVGQm9MK5ErrskBRUtbDniVw+0fZIpKSbyzIBat73JdY8wp2cRSIFqzBfXPVjANQ8Thp2ftFpaLiTzmVgig2/7gH1ROMvVirDDX9VTQAXSNDpuFXSTzrkCPMDn/z2t8rosbsszbwkT+czgrc/KNi0Vm2RQpbMZ0nDl0PKpfa0LU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733446942; c=relaxed/simple;
	bh=AEbDNYDTXF4aiNY44nLSGz9KiD7JfrcFpeVov6AtjDc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=r+2Rz2V7d9IsVTMgMUaHpEEh8Z7ZaUO2HwYDLv8Ju/MsAivh9by3u9nCWEGxFoVy9/oYM/xtUJcheyPQmRybfj0QtN/xN4qvyLfwN6ySSmfelGwYBHiVqpIq903FHjoWqa8grnzRVQ+7UpmKQKOfvmZlhf1UXio0yLuu3myzakc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0dp/80df; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4349338add3so13145e9.0
        for <kvm@vger.kernel.org>; Thu, 05 Dec 2024 17:02:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733446939; x=1734051739; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HcmaJfowWcM2EfWC/f7eVIZnrBnrT7YMLdrj9P9FhKU=;
        b=0dp/80dfGsV7X/VCsxlfy0AKL08clM99V/IXIrCgybcYXt7M+HgbF4jQh+1wjsiHs3
         oqGycVEfQ+GdoMYEq/ZhS2KLU6wjeqWZ4hva5PniKl/9LLqGVhRz2o7/n/hjTlCS3ifW
         JN5iOE9KxRCpBf+Y+g+h+tejH76Kn9kThmZOKAsv+/gCOO2QC9FihorUAuOqUEqHb0RZ
         fpktbG+1WP+Ms9wGHS11jlPtkD6YagHMGZdw2s70udzOHssbTm3UPZyHUbrCCe6KH93I
         jRzG1c9Uv80h0SiVN035zPmeG6siiLDOixOfsOnrH4DbniFBCp/woyMTE+XWvcQscxL0
         CbLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733446939; x=1734051739;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HcmaJfowWcM2EfWC/f7eVIZnrBnrT7YMLdrj9P9FhKU=;
        b=HvtXeHPPjWeR39Q3ickz5/xfxA/kAmCRyrvj0VcHAqL9hocz2qegmDNV1o/f9FP6pI
         3O9EpXz0HP+hxK4UJWkQtpJXbtdrJb367IIhFWYODfbS7c2B6Nt/Vm9vfQhJKD4+N+pb
         cMPzZrncCM0cCcLMiXFziuivT7IUjQnziZvKqyQH07HCAQ1nxeUBeSMbEyoPM2K0bvWC
         Q5o2uIfJ3JJvAkXJ82zEp8wqcGokte99yry1iUgzBA/UErB3mbO4f7isNb+eacWcmrc2
         gr4RzxTT2p87hwLbujDJ4Tj6N8txPP+95m44QyQjaxYsYy0mLebBeeTlZHJDObud0Ru9
         9+DA==
X-Forwarded-Encrypted: i=1; AJvYcCUD13eRQNlsVJ1DhL481IMHEqOdRtAI9mxUVNb6e1KgaiS5pQZ5bGIRdA7uq3FpJ27fIK4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzMTHt+i5Ce6tYeQCmCfA+wPSxKfQD54fj0QFlw63O4Zczrcyjv
	1LeAZSIRDqNXCsQHcDxA7JEDVp/lbyNQIhH8T0u+zMqf3jntG8BHIDVGuhhvYPMSMPNkz1YkOqQ
	vppbVHsTAzkIuTwwxhzobnaoZ/NhP48NCORMt
X-Gm-Gg: ASbGnctt4iFN1YIFWTgYT7issQQI6nrzYkzAvCL/grOz8GGABoBrlbQhz111v2aDIqi
	Lx3LLbCsTXMXIqMprJ84enTKgT1TnRScTM0gSIyGPBlMYuXfsKbAql/XIvAmzGA==
X-Google-Smtp-Source: AGHT+IHr7rZI6yrn8JV11lazv05GZRIqvfrcbTPzKk8VEbu5RR7SF7uBMzJ9HVO9yJW2t5jlaavaPVHxFJi+zcGvyVY=
X-Received: by 2002:a05:600c:35ca:b0:42c:acd7:b59b with SMTP id
 5b1f17b1804b1-434de39c6bbmr476085e9.6.1733446938910; Thu, 05 Dec 2024
 17:02:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241031212104.1429609-1-jiaqiyan@google.com> <86r07v1g2z.wl-maz@kernel.org>
 <CACw3F51FbzkkX_DcCVCieZ=408oP_Fy3sXYk5AjWRX3RJO2Fzg@mail.gmail.com>
 <878qtou96b.wl-maz@kernel.org> <CACw3F50gB40dqQ4CZ7f4X4aRkxHQhjiYunAhqbmVtcGnd5g3bA@mail.gmail.com>
 <Zz2TyC9-zNQ3D-KB@linux.dev>
In-Reply-To: <Zz2TyC9-zNQ3D-KB@linux.dev>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Thu, 5 Dec 2024 17:02:06 -0800
Message-ID: <CACw3F50ACSOsP9+qJr2g=dL9p3-6AcZ2VWP2bbWvBMasu796pw@mail.gmail.com>
Subject: Re: [RFC PATCH v1] KVM: arm64: Introduce KVM_CAP_ARM_SIGBUS_ON_SEA
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
Cc: joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, pbonzini@redhat.com, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, duenwen@google.com, rananta@google.com, 
	James Houghton <jthoughton@google.com>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 19, 2024 at 11:46=E2=80=AFPM Oliver Upton <oliver.upton@linux.d=
ev> wrote:
>
> On Tue, Nov 19, 2024 at 03:57:46PM -0800, Jiaqi Yan wrote:
> >
> > While continuing the discussion here, I think it may make sense I sent
> > out a V2 with 2 major updates:
> >   - add documentation for new SIGBUS feature
> >   - remove KVM_CAP_ARM_SIGBUS_ON_SEA
>
> Just wanted to add that QEMU already has a functioning "MCE" injection
> implemenation based on signals that deals with the sloppy mess of
> coordinating w/ vCPU threads [*].
>
> I completely agree with Marc that the UAPI around using signals for this
> sort of thing is a giant pile of crap, but it seems to be a semi-understo=
od
> pile of crap. And from that perspective, wiring unclaimed SEAs into the
> existing infrastructure at least makes the UAPI consistent.
>
> [*]: https://elixir.bootlin.com/qemu/v9.1.1/C/ident/kvm_on_sigbus_vcpu
>
> > On Tue, Nov 12, 2024 at 12:51=E2=80=AFAM Marc Zyngier <maz@kernel.org> =
wrote:
> > > > Do you mean a CAP that VMM can tell KVM the VM guest has RAS abilit=
y?
> > > > I don't know if there is one for arm64. On x86 there is
> > > > KVM_X86_SETUP_MCE. KVM_CAP_ARM_INJECT_EXT_DABT maybe a revelant one
> > > > but I don't think it is exactly the one for "RAS ability".
> > >
> > > Having though about this a bit more, I now think this is independent
> > > of the guest supporting RAS. This really is about the VMM asking to b=
e
> > > made aware of RAS errors affecting the guest, and it is the signallin=
g
> > > back to the guest that needs to be gated by ID_AA64PFR0_EL1.RAS.
> >
> > Just to make sure I fully catch you. I think ID_AA64PFR0_EL1.RAS
> > translates to ARM64_HAS_RAS_EXTN in the kernel. If VMM signals RAS
> > error back to the guest with SEA, are you suggesting
> > __kvm_arm_vcpu_set_events should check
> > cpus_have_final_cap(ARM64_HAS_RAS_EXTN) before it
> > kvm_inject_dabt(vcpu)?
> >
> > If so, how could __kvm_arm_vcpu_set_events know if the error is about
> > RAS (e.g. memory error) vs about accessing memory not in a memslot
> > (i.e. KVM_EXIT_ARM_NISV)? I guess KVM needs to look at ESR_EL2 again
> > (e.g. kvm_vcpu_abt_issea vs kvm_vcpu_dabt_isvalid)?
>
> Good point. I don't think we can lock down this UAPI after the fact
> given the existing use cases. It is ultimately up to the VMM what to do.
>
> I don't see anything that would stop an implementation without FEAT_RAS
> from generating an SEA in this situation. The lack of FEAT_RAS (to me at
> least) implies:
>
>  - No ESR injection for vSErrors (already enforced in UAPI)
>  - No deferral of SErrors / ESBs
>  - No error record registers in the PE

Thanks Oliver, if I read you correctly, __kvm_arm_vcpu_set_events
doesn't need to assert ARM64_HAS_RAS_EXTN, and it also doesn't need to
differentiate RAS and KVM_EXIT_ARM_NISV.

>
> Of course, it is very likely you've thought about this more than I have,
> Marc.

I will send out RFC V2 in a second. Please take another look and
comment there, Marc and Oliver, thanks!

>
> --
> Thanks,
> Oliver

