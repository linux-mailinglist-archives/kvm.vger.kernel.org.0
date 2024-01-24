Return-Path: <kvm+bounces-6881-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 773D783B389
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 22:04:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D66F6B21F47
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 21:04:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E43361350F5;
	Wed, 24 Jan 2024 21:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rlaBaD8y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9DBC1350DE
	for <kvm@vger.kernel.org>; Wed, 24 Jan 2024 21:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706130273; cv=none; b=q/ACvXbFRA4V+yWZLIHmKBu0biFmnPz7repoRtOLHvU3b8qHUFU3BInOV0CdD/TMhdhj/YwVSrgyCCgs2T8uVBHSKOY/RIcAM8/FGPfp6KPVlMeqt9sIoc0WrMjdZAHOlmfA6/g11KFqhwiaajctpFTkcvTEgyczgYJfx39TU0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706130273; c=relaxed/simple;
	bh=rnqQksO6jKPLFgx/+tiUJsLCt73PVeCSgVfenkMhb+w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ph4Ak8Yqy6NNi998S3GzzKsRWOyw6rOVO7UMIz5xZF8Gtkcq42O+aYytM3aN6tiUpnkRluFzAd7U3Ii45TBqR8mpYVnK+1+ds6rj1HzuPVQnyslwbYNefG8PhkgU6BwXWscsw3JCXFs6KcN6ILR2BMRfEEGYzuVxA1uhXzXNl48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rlaBaD8y; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1d76f1e3e85so37315ad.0
        for <kvm@vger.kernel.org>; Wed, 24 Jan 2024 13:04:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706130271; x=1706735071; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XizRQUBlHaAbu9XxeiCMQdYmbPWgy6XwF09TqKGHj34=;
        b=rlaBaD8yYapAsfo/sc1/AUAR9EjfFlgiPFFR4hHFagiDFpWv9DTAQVkh76Vd87toxI
         YBAX6OqVwtxtshh9r9mAaJgXKeD29qTRq9s6AUZYyHVvQWNlEdyhlVPB3zVPiOHgq4om
         IJ3QP5MSoVsWhzELd8d5GH76+HLgFZyLXlrqbvHiaDB9+8rIdpzo1ArR9gldYas56Y3N
         +hzvHAYvLEk0egR9oDbgxhrLfKvK7sKatWohT0AwtwASwcO86xEo5rOsHXcmjbegS+U/
         kydQOCKFUI9c4zzslHnjYTbFdBIvU1AfHOusHf9td6tBE9eg7WZuf2gZ41mfXD7TZzBK
         NWUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706130271; x=1706735071;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XizRQUBlHaAbu9XxeiCMQdYmbPWgy6XwF09TqKGHj34=;
        b=wjkneypLfdMbJtkJkfoKMQy/KNMWTCBkuilz/E9Zs1iuo4BjWQE7AL7NU5vGTQKIvx
         HBXwklt0kSTeIN/fof3t7yYt11fo6CyK8uPevbwN+i0jgvfTLu0e8H8XbV6F9cnww2qW
         0N7VzFFvKZRnLxB5ugn7AbvfkU2E4tDqHC/Ut1DzmAxo2Vf8DQJ+YYjrYpDoAhuvQlP9
         g7+vD52HD7sKRask6ZArFScuT0Mse89VbLwLCrS7nPwg7BtbnXYGYKU2CJ6pcPbw7GvY
         HeE0oDx7yOB20cT+1enG2UvUDMz1CZ3jDIwwH5r9dTXZEhEG9B4aMXvYE4WcRjhQGFCi
         HTjw==
X-Gm-Message-State: AOJu0Yyofg+8X41CNUsuZyxN4Tw77kQQ9HJsPl9grkZ47aD07mmHxPxh
	+KPkWjZ9T/krAaN15XdHXnHiYGKbIUU4jUwrtarOSTjPcZDnNQMQ+ZKBJ0CGXnAHV68qxDngjnq
	CR99wD/72AjF3q6oEJZljueVnMPZ88X4e3Jd2
X-Google-Smtp-Source: AGHT+IGTJBa4VEZI289z7a8SPKOIESK1qdc/0dgaW79HDpgK0RplBVCGi/9lVBA37rZn3yjqGtJuzXKpqssmRPybJ5A=
X-Received: by 2002:a17:903:32c2:b0:1d5:ea14:cd89 with SMTP id
 i2-20020a17090332c200b001d5ea14cd89mr8229plr.1.1706130270686; Wed, 24 Jan
 2024 13:04:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240124003858.3954822-1-mizhang@google.com> <20240124003858.3954822-2-mizhang@google.com>
 <ZbExcMMl-IAzJrfx@google.com>
In-Reply-To: <ZbExcMMl-IAzJrfx@google.com>
From: Aaron Lewis <aaronlewis@google.com>
Date: Wed, 24 Jan 2024 13:04:18 -0800
Message-ID: <CAAAPnDFAvJBuETUsBScX6WqSbf_j=5h_CpWwrPHwXdBxDg_LFQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: x86/pmu: Reset perf_capabilities in vcpu to 0 if
 PDCM is disabled
To: Sean Christopherson <seanjc@google.com>
Cc: Mingwei Zhang <mizhang@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 24, 2024 at 7:49=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Wed, Jan 24, 2024, Mingwei Zhang wrote:
> > Reset vcpu->arch.perf_capabilities to 0 if PDCM is disabled in guest cp=
uid.
> > Without this, there is an issue in live migration. In particular, to
> > migrate a VM with no PDCM enabled, VMM on the source is able to retriev=
e a
> > non-zero value by reading the MSR_IA32_PERF_CAPABILITIES. However, VMM =
on
> > the target is unable to set the value. This creates confusions on the u=
ser
> > side.
> >
> > Fundamentally, it is because vcpu->arch.perf_capabilities as the cached
> > value of MSR_IA32_PERF_CAPABILITIES is incorrect, and there is nothing
> > wrong on the kvm_get_msr_common() which just reads
> > vcpu->arch.perf_capabilities.
> >
> > Fix the issue by adding the reset code in kvm_vcpu_after_set_cpuid(), i=
.e.
> > early in VM setup time.
> >
> > Cc: Aaron Lewis <aaronlewis@google.com>
> > Signed-off-by: Mingwei Zhang <mizhang@google.com>
> > ---
> >  arch/x86/kvm/cpuid.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > index adba49afb5fe..416bee03c42a 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -369,6 +369,9 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcp=
u *vcpu)
> >       vcpu->arch.maxphyaddr =3D cpuid_query_maxphyaddr(vcpu);
> >       vcpu->arch.reserved_gpa_bits =3D kvm_vcpu_reserved_gpa_bits_raw(v=
cpu);
> >
> > +     /* Reset MSR_IA32_PERF_CAPABILITIES guest value to 0 if PDCM is o=
ff. */
> > +     if (!guest_cpuid_has(vcpu, X86_FEATURE_PDCM))
> > +             vcpu->arch.perf_capabilities =3D 0;
>
> No, this is just papering over the underlying bug.  KVM shouldn't be stuf=
fing
> vcpu->arch.perf_capabilities without explicit writes from host userspace.=
  E.g
> KVM_SET_CPUID{,2} is allowed multiple times, at which point KVM could clo=
bber a
> host userspace write to MSR_IA32_PERF_CAPABILITIES.  It's unlikely any us=
erspace
> actually does something like that, but KVM overwriting guest state is alm=
ost
> never a good thing.
>
> I've been meaning to send a patch for a long time (IIRC, Aaron also ran i=
nto this?).
> KVM needs to simply not stuff vcpu->arch.perf_capabilities.  I believe we=
 are
> already fudging around this in our internal kernels, so I don't think the=
re's a
> need to carry a hack-a-fix for the destination kernel.
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 27e23714e960..fdef9d706d61 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12116,7 +12116,6 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>
>         kvm_async_pf_hash_reset(vcpu);
>
> -       vcpu->arch.perf_capabilities =3D kvm_caps.supported_perf_cap;

Yeah, that will fix the issue we are seeing.  The only thing that's
not clear to me is if userspace should expect KVM to set this or if
KVM should expect userspace to set this.  How is that generally
decided?

>         kvm_pmu_init(vcpu);
>
>         vcpu->arch.pending_external_vector =3D -1;
>
> >       kvm_pmu_refresh(vcpu);
> >       vcpu->arch.cr4_guest_rsvd_bits =3D
> >           __cr4_reserved_bits(guest_cpuid_has, vcpu);
> > --
> > 2.43.0.429.g432eaa2c6b-goog
> >

