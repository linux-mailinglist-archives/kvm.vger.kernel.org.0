Return-Path: <kvm+bounces-6885-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DBEEB83B500
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 23:51:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0DB551C2253F
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 22:51:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C84B5136641;
	Wed, 24 Jan 2024 22:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DhIKCunL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99D3D2C9A
	for <kvm@vger.kernel.org>; Wed, 24 Jan 2024 22:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706136706; cv=none; b=DxW7YbzBzVzwe/jzTYzmUh6COHsYgtgsPfr1nPZYLfKs8Tq3QB+EAPL3Ue9jkbQ3mk24tzgxXIDj+ltEZjnaHuOFpm2rbN2jzO+JDtNcmbHSMXMiOIGKNS7KKt2LawaDXqPdJFXWd7A/apZJaaNUR3vqvDeISKdmNQ3ZTSU0cEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706136706; c=relaxed/simple;
	bh=y7HxV+Np84h3b7pFhizDvvwdV72exh3vv8aNoSMmLIA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=n0nXtwH1VewaGDoeQqaJfcVZLVIy1YH+QwMKFpE8VI+rlPuL8kk82Ag2opj3G8ZL2FqesBlPjT812u7BVRxo3bu8drfp/TbRU4aU+Rh6/v73XKDhkcgkjJ7D8GGsTHCxjOotzaIv4wH8kJjaxDuyLUgbOGuEO6dk/F88rqVrSDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DhIKCunL; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6da10578363so3984719b3a.3
        for <kvm@vger.kernel.org>; Wed, 24 Jan 2024 14:51:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706136704; x=1706741504; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rSbhtgohGq6DFg+wGmtT8BdfOQwttX56L77yjeBITeU=;
        b=DhIKCunLpMhFW0QSfP15NrcP/m9j7U3Hn7O760/l3ZQNiNnIJfWnSjo/UOPo63o8hi
         rUJeaY8CA9mITtvYPXfbmHUxH/8nuotzo0yf0mannP3iHQ5or/n4eSdxTPolWQ5RY4u/
         zVoeLjI24MKP+KO+CtEPYvc1UXkRwlLwpXDmBhh64qAAnIXvV6edXX6mm81swHbA/5gB
         fP1JvmXwJfXBjcEFEh9aLHu5DrBvNyPJ6HllYexAh0tlGjMudBvZeP9Om0FPDJJAIqts
         I3Nu9hnRxjc+5TWlw5RxHWI1qSjBn+rRQTlNhLmOrweZzw7Dq84wdTDxzHdwKkJYx+Qu
         4rYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706136704; x=1706741504;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=rSbhtgohGq6DFg+wGmtT8BdfOQwttX56L77yjeBITeU=;
        b=gGEZ73+NuIDnXkH0CCU30dW0cQGXMiiuZSLqd0wb89HFtSVHB+gtyEGJv7mrmWVTLr
         +n4lfNTd5hA2W6oDhzE8r+EADbn4S8aJJkaS+j3Ku49Kg7enfSo1JTHN/4Z4zU/iGWrD
         WJJ+ZfA9lNZeVWb5MfM0FqFJ99JBfrKdlJyFXuB8PWmnOzEp766Z1eaF2J0/NjABIia4
         RLSsgJ9PKH2PHYCEzi219qVWnd3XZxcoIdR+LHV3fn1JEATrdKE+Gw/uAzz/UeWZ2k1U
         P3Tf6EX2rupZRI59bpf12CyVyd1kGvaT/TdsdgfC8Wd3zyFNbCSXnz1Ve8DARy88DByg
         F+zw==
X-Gm-Message-State: AOJu0YzX5IpwB2SoPXjBIbtIXrtMMITjCDSuEqqIvnndXJqHJm+yVAqx
	W9AmoIov85a9Gl5mzUAj+fqNgsCIf3s//WXdckfIJsXa68viXn+8b0xyNVKXR1lrXNv4X2VIeqC
	sxQ==
X-Google-Smtp-Source: AGHT+IFm8oubNdRBgNaQ9Mu4OrYjWXUylJvpMx3BJ4yGVDTXCO+qVZubo+OT0sSxQplEMU4UIy+VDvaC1Q4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1889:b0:6da:53fc:b263 with SMTP id
 x9-20020a056a00188900b006da53fcb263mr24862pfh.5.1706136703888; Wed, 24 Jan
 2024 14:51:43 -0800 (PST)
Date: Wed, 24 Jan 2024 14:51:42 -0800
In-Reply-To: <ZbGOK9m6UKkQ38bK@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240124003858.3954822-1-mizhang@google.com> <20240124003858.3954822-2-mizhang@google.com>
 <ZbExcMMl-IAzJrfx@google.com> <CAAAPnDFAvJBuETUsBScX6WqSbf_j=5h_CpWwrPHwXdBxDg_LFQ@mail.gmail.com>
 <ZbGAXpFUso9JzIjo@google.com> <ZbGOK9m6UKkQ38bK@google.com>
Message-ID: <ZbGUfmn-ZAe4lkiN@google.com>
Subject: Re: [PATCH 1/2] KVM: x86/pmu: Reset perf_capabilities in vcpu to 0 if
 PDCM is disabled
From: Sean Christopherson <seanjc@google.com>
To: Mingwei Zhang <mizhang@google.com>
Cc: Aaron Lewis <aaronlewis@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 24, 2024, Mingwei Zhang wrote:
> On Wed, Jan 24, 2024, Sean Christopherson wrote:
> > On Wed, Jan 24, 2024, Aaron Lewis wrote:
> > > On Wed, Jan 24, 2024 at 7:49=E2=80=AFAM Sean Christopherson <seanjc@g=
oogle.com> wrote:
> > > >
> > > > On Wed, Jan 24, 2024, Mingwei Zhang wrote:
> > > > No, this is just papering over the underlying bug.  KVM shouldn't b=
e stuffing
> > > > vcpu->arch.perf_capabilities without explicit writes from host user=
space.  E.g
> > > > KVM_SET_CPUID{,2} is allowed multiple times, at which point KVM cou=
ld clobber a
> > > > host userspace write to MSR_IA32_PERF_CAPABILITIES.  It's unlikely =
any userspace
> > > > actually does something like that, but KVM overwriting guest state =
is almost
> > > > never a good thing.
> > > >
> > > > I've been meaning to send a patch for a long time (IIRC, Aaron also=
 ran into this?).
> > > > KVM needs to simply not stuff vcpu->arch.perf_capabilities.  I beli=
eve we are
> > > > already fudging around this in our internal kernels, so I don't thi=
nk there's a
> > > > need to carry a hack-a-fix for the destination kernel.
> > > >
> > > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > > index 27e23714e960..fdef9d706d61 100644
> > > > --- a/arch/x86/kvm/x86.c
> > > > +++ b/arch/x86/kvm/x86.c
> > > > @@ -12116,7 +12116,6 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *v=
cpu)
> > > >
> > > >         kvm_async_pf_hash_reset(vcpu);
> > > >
> > > > -       vcpu->arch.perf_capabilities =3D kvm_caps.supported_perf_ca=
p;
> > >=20
> > > Yeah, that will fix the issue we are seeing.  The only thing that's
> > > not clear to me is if userspace should expect KVM to set this or if
> > > KVM should expect userspace to set this.  How is that generally
> > > decided?
> >=20
> > By "this", you mean the effective RESET value for vcpu->arch.perf_capab=
ilities?
> > To be consistent with KVM's CPUID module at vCPU creation, which is com=
pletely
> > empty (vCPU has no PMU and no PDCM support) KVM *must* zero
> > vcpu->arch.perf_capabilities.
> >=20
> > If userspace wants a non-zero value, then userspace needs to set CPUID =
to enable
> > PDCM and set MSR_IA32_PERF_CAPABILITIES.
> >=20
> > MSR_IA32_ARCH_CAPABILITIES is in the same boat, e.g. a vCPU without
> > X86_FEATURE_ARCH_CAPABILITIES can end up seeing a non-zero MSR value.  =
That too
> > should be excised.
> >=20
> hmm, does that mean KVM just allows an invalid vcpu state exist from
> host point of view?

Yes.

https://lore.kernel.org/all/ZC4qF90l77m3X1Ir@google.com

> I think this makes a lot of confusions on migration where VMM on the sour=
ce
> believes that a non-zero value from KVM_GET_MSRS is valid and the VMM on =
the
> target will find it not true.

Yes, but seeing a non-zero value is a KVM bug that should be fixed.

> If we follow the suggestion by removing the initial value at vCPU
> creation time, then I think it breaks the existing VMM code, since that
> requires VMM to explicitly set the MSR, which I am not sure we do today.

Yeah, I'm hoping we can squeak by without breaking existing setups.

I'm 99% certain QEMU is ok, as QEMU has explicitly set MSR_IA32_PERF_CAPABI=
LITIES
since support for PDCM/PERF_CAPABILITIES was added by commit ea39f9b643
("target/i386: define a new MSR based feature word - FEAT_PERF_CAPABILITIES=
").

Frankly, if our VMM doesn't do the same, then it's wildly busted.  Relying =
on
KVM to define the vCPU is irresponsible, to put it nicely.

> The following code below is different. The key difference is that the
> following code preserves a valid value, but this case is to not preserve
> an invalid value.=20

But it's a completely different fix.  I referenced that commit to call out =
that
the need for the commit and changelog suggests that someone (*cough* us) is=
 relying
on KVM to initialize MSR_PLATFORM_INFO, and has been doing so for a very lo=
ng time.
That doesn't mean it's the correct KVM behavior, just that it's much riskie=
r to
change.

