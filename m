Return-Path: <kvm+bounces-6882-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BD3283B3DE
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 22:26:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0ACE61F23348
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 21:26:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A7AD1350FB;
	Wed, 24 Jan 2024 21:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="31GB1bJg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B38E91339AA
	for <kvm@vger.kernel.org>; Wed, 24 Jan 2024 21:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706131554; cv=none; b=jx2YbbVoqavAKUTQ48SHp+HiRLbZtlhVWyFA0RWttnWjpjRmW7ovvRaaP8UL3JFR0TsQRy6z4P/AENp8c1KQjBlKgYzf8jlsLfeY0NI/Mpfs2Aj/P5xYdUyhmdAF5odzttPoGuLQFL9wAB34H7/OV760Su0FXdrU3pp+TpMnjr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706131554; c=relaxed/simple;
	bh=277XN7rVdH2eY6PXPKLwabMU7upP6pfA70NJVhCEo/o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Z8hTZ4q0xiEfDYVeeRUfsHaEVl8oMc2Kv2hjCimoL74AXxhqeYVYZFAIyirOU1trtL1aqVNNzO51ODC6iUfXfUgQ2ZBVlpua/vQVJ4Rgd+pvLi6gHv+b2TsFo6pHqG3/T8h+ftJ19w4geHWsU3zzHI/oFQGigqdvelxb1Q+yz88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=31GB1bJg; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc24eb17be6so9789661276.1
        for <kvm@vger.kernel.org>; Wed, 24 Jan 2024 13:25:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706131551; x=1706736351; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wOrPayXVbMvuGV7K47I5tyuTX654w1HjkPILeSMWTng=;
        b=31GB1bJgboGhBrw4RISXeyE7TiQjv+OlfZ+JHyUASJBX0W9PR1S3Y65uS4St5qoQpJ
         OyPEcRz5nfkhavW0cOHUin/sg5mM5hnplsF3ZHY2tdAGSn1F23AphhbgNhwssJD/vpp2
         V7R3MI0YgBScjtLUQSl7nuQHgNLoR1s7mJ+XASA2fO+hD6dw6A4KRFtqLvoev9q2NNaI
         u+mYAp+ch9pqvFUwXtKordRxxCfmx5Vy7O4nnEr8U+esZ4cY2L6Vtndjg7+eLULTME5A
         AWlXVDR3UPZVQ3wSb142rdNaQg5nJJDkLPpfsVLFBsNVcCqmqzEJRKk4ZLPAw52w6rsl
         rOLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706131551; x=1706736351;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=wOrPayXVbMvuGV7K47I5tyuTX654w1HjkPILeSMWTng=;
        b=Oo4tVsa9dV+3JqKrJgdo75DBWSOowPK5iQ8F1kiG8ubQmBMX/JJ615/SzOFftvXWml
         vkzzsN/12NVVaYT1ge19R+3H11woqkoU+C8AgicdQ2n+VjCw8+kZDwsP4vH5QQHObNAs
         pNcvt3XvgZ+/7Hc9O+X+S2XmeKB1FF/6ubnyVA5VtRWRCT0A4BGQ7iyYtMx9gT6yrjul
         4ie15y25lFtM1QEr4H+o6XUfhNMpcT/M7E+j1Uwei+RnyvNJ7tLDu4rwutQL+5Ixoxg4
         n5XW8BUv5q8pIR+j3sP4pc9NPrSFUpyru0SUufgwxoLGE2/iFKftmTrXzqzBvl6Jd6CQ
         snKg==
X-Gm-Message-State: AOJu0YweZOj84JjAerSbJEQBMl7g7E/typY+ekQZnNqcWSZN6MPm4S6l
	9HOwy4uWjuq4M69YgbS9BJ7NEzlb5wTh4WetwpC/wsdfZqiyRtAKlKQ9m/KeuQOaeitGG/Tbk5y
	L/g==
X-Google-Smtp-Source: AGHT+IHfDk7InmkuLCfkz2VJGNFO5lFSeKmp4Z/QLVjduOmTEHs8FkCeViiZktqDYRvGFMdxF0GAMcFxnZs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1793:b0:dc2:1c5d:eed5 with SMTP id
 ca19-20020a056902179300b00dc21c5deed5mr76ybb.12.1706131551648; Wed, 24 Jan
 2024 13:25:51 -0800 (PST)
Date: Wed, 24 Jan 2024 13:25:50 -0800
In-Reply-To: <CAAAPnDFAvJBuETUsBScX6WqSbf_j=5h_CpWwrPHwXdBxDg_LFQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240124003858.3954822-1-mizhang@google.com> <20240124003858.3954822-2-mizhang@google.com>
 <ZbExcMMl-IAzJrfx@google.com> <CAAAPnDFAvJBuETUsBScX6WqSbf_j=5h_CpWwrPHwXdBxDg_LFQ@mail.gmail.com>
Message-ID: <ZbGAXpFUso9JzIjo@google.com>
Subject: Re: [PATCH 1/2] KVM: x86/pmu: Reset perf_capabilities in vcpu to 0 if
 PDCM is disabled
From: Sean Christopherson <seanjc@google.com>
To: Aaron Lewis <aaronlewis@google.com>
Cc: Mingwei Zhang <mizhang@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 24, 2024, Aaron Lewis wrote:
> On Wed, Jan 24, 2024 at 7:49=E2=80=AFAM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > On Wed, Jan 24, 2024, Mingwei Zhang wrote:
> > > Reset vcpu->arch.perf_capabilities to 0 if PDCM is disabled in guest =
cpuid.
> > > Without this, there is an issue in live migration. In particular, to
> > > migrate a VM with no PDCM enabled, VMM on the source is able to retri=
eve a
> > > non-zero value by reading the MSR_IA32_PERF_CAPABILITIES. However, VM=
M on
> > > the target is unable to set the value. This creates confusions on the=
 user
> > > side.
> > >
> > > Fundamentally, it is because vcpu->arch.perf_capabilities as the cach=
ed
> > > value of MSR_IA32_PERF_CAPABILITIES is incorrect, and there is nothin=
g
> > > wrong on the kvm_get_msr_common() which just reads
> > > vcpu->arch.perf_capabilities.
> > >
> > > Fix the issue by adding the reset code in kvm_vcpu_after_set_cpuid(),=
 i.e.
> > > early in VM setup time.
> > >
> > > Cc: Aaron Lewis <aaronlewis@google.com>
> > > Signed-off-by: Mingwei Zhang <mizhang@google.com>
> > > ---
> > >  arch/x86/kvm/cpuid.c | 3 +++
> > >  1 file changed, 3 insertions(+)
> > >
> > > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > > index adba49afb5fe..416bee03c42a 100644
> > > --- a/arch/x86/kvm/cpuid.c
> > > +++ b/arch/x86/kvm/cpuid.c
> > > @@ -369,6 +369,9 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_v=
cpu *vcpu)
> > >       vcpu->arch.maxphyaddr =3D cpuid_query_maxphyaddr(vcpu);
> > >       vcpu->arch.reserved_gpa_bits =3D kvm_vcpu_reserved_gpa_bits_raw=
(vcpu);
> > >
> > > +     /* Reset MSR_IA32_PERF_CAPABILITIES guest value to 0 if PDCM is=
 off. */
> > > +     if (!guest_cpuid_has(vcpu, X86_FEATURE_PDCM))
> > > +             vcpu->arch.perf_capabilities =3D 0;
> >
> > No, this is just papering over the underlying bug.  KVM shouldn't be st=
uffing
> > vcpu->arch.perf_capabilities without explicit writes from host userspac=
e.  E.g
> > KVM_SET_CPUID{,2} is allowed multiple times, at which point KVM could c=
lobber a
> > host userspace write to MSR_IA32_PERF_CAPABILITIES.  It's unlikely any =
userspace
> > actually does something like that, but KVM overwriting guest state is a=
lmost
> > never a good thing.
> >
> > I've been meaning to send a patch for a long time (IIRC, Aaron also ran=
 into this?).
> > KVM needs to simply not stuff vcpu->arch.perf_capabilities.  I believe =
we are
> > already fudging around this in our internal kernels, so I don't think t=
here's a
> > need to carry a hack-a-fix for the destination kernel.
> >
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 27e23714e960..fdef9d706d61 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -12116,7 +12116,6 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
> >
> >         kvm_async_pf_hash_reset(vcpu);
> >
> > -       vcpu->arch.perf_capabilities =3D kvm_caps.supported_perf_cap;
>=20
> Yeah, that will fix the issue we are seeing.  The only thing that's
> not clear to me is if userspace should expect KVM to set this or if
> KVM should expect userspace to set this.  How is that generally
> decided?

By "this", you mean the effective RESET value for vcpu->arch.perf_capabilit=
ies?
To be consistent with KVM's CPUID module at vCPU creation, which is complet=
ely
empty (vCPU has no PMU and no PDCM support) KVM *must* zero
vcpu->arch.perf_capabilities.

If userspace wants a non-zero value, then userspace needs to set CPUID to e=
nable
PDCM and set MSR_IA32_PERF_CAPABILITIES.

MSR_IA32_ARCH_CAPABILITIES is in the same boat, e.g. a vCPU without
X86_FEATURE_ARCH_CAPABILITIES can end up seeing a non-zero MSR value.  That=
 too
should be excised.

In a perfect world, KVM would also zero-initialize vcpu->arch.msr_platform_=
info,
but that one is less obviously broken and also less obviously safe to remov=
e.

  commit e53d88af63ab4104e1226b8f9959f1e9903da10b
  Author:     Jim Mattson <jmattson@google.com>
  AuthorDate: Tue Oct 30 12:20:21 2018 -0700
  Commit:     Paolo Bonzini <pbonzini@redhat.com>
  CommitDate: Fri Dec 14 18:00:01 2018 +0100

      kvm: x86: Don't modify MSR_PLATFORM_INFO on vCPU reset
   =20
      If userspace has provided a different value for this MSR (e.g with th=
e
      turbo bits set), the userspace-provided value should survive a vCPU
      reset. For backwards compatibility, MSR_PLATFORM_INFO is initialized
      in kvm_arch_vcpu_setup.
   =20
      Signed-off-by: Jim Mattson <jmattson@google.com>
      Reviewed-by: Drew Schmitt <dasch@google.com>
      Cc: Abhiroop Dabral <adabral@paloaltonetworks.com>
      Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

In other words, KVM shouldn't define the vCPU model beyond the absolute bar=
e
minimum that is required by the x86 architecture (as of P6 CPUs, which is m=
ore
or less the oldest CPU KVM can reasonably virtualize without carrying usele=
ss code).

