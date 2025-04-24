Return-Path: <kvm+bounces-44140-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AEC6A9AF99
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 15:47:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 02CF0189D73E
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 13:47:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E95E2171092;
	Thu, 24 Apr 2025 13:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="RFFhUXRK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34780146A72
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 13:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745502434; cv=none; b=iDO6PCwjp2rfgW5CDMZky6FIbkqZQuUMioN5XbE8PWHa8SBGNap/Foy8kLwJivZQnpcRl7n9UsdIjCuEVIvDWqcTTL7elCpbB8/9RnzGFhJy/mOIJvrf3VKsR3MPDm1l+f146aGSzQikY5yrds3Mx9ZNDZMeqVSLp0QReienGvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745502434; c=relaxed/simple;
	bh=SfxUfozdG/wFPKLIElbvK+GVokVF+cihhhaksRJ2Qz0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bt5kf/8qR8J91TJ0JhoWdFurIG9w9DiGzJq+w16JboCUioveVjuK390db6tn/b63gRm+e1uUBv4DBjAB9zgShR/UfAJQicREUJ7zdqcxSXTKzofrIwVArYs5N5gx39RuHFNZsMo+liFgPPXRIKJSllcl//PTR4FNmgl3VHFCkbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=RFFhUXRK; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-54acc0cd458so1227025e87.0
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 06:47:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1745502430; x=1746107230; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p3YD6QCvd7lsKiSV7ufRGyj+FOXkAdczCjapnA2nC9A=;
        b=RFFhUXRK8SXB7ii5tTQo065v9pJhdzAOkcMBpMGDxATP6SMNDJNj+TpaUXOee2FOJV
         StpYR0EN9kMh2DS6BJubOORy+DNt8I10GZ4SKrE2dbRXu+qMWM/DX3C2vzKQEdCsJBf6
         5jz/ZwmJsZaTiBkTfC6g1rQHlEo5o+qbkKsMzQ0rYcCNC2qCVf36EXHFZ6XP+jFEtO8e
         k5PPqj35QTY5+QoOTvVDnlkZNVFz78U9t/lWs6bWHR4sDvwulM4Agb2A2XWuTmQeMf9S
         JMdd0OznzJ6YTAifo0LAr8WoWQJQv9/ewhY/QNRAKKmrfxIOhkcWshkS+F2UeWamTpFE
         2F9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745502430; x=1746107230;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p3YD6QCvd7lsKiSV7ufRGyj+FOXkAdczCjapnA2nC9A=;
        b=EmAg2JqkKPd6XAyj1Ypx9JkMNrGh19Vki0uuG+5dddkQWSnOm8Q7CcLrztro0EivIi
         D9RzkZpYzeKSBJt6i0iy0zNGPz8bKx1lPJB8y+FctFlVC2Lt31NtNs8qR5xiRrSw+VrS
         N5crej9EpypbOqh0ecR52w0zzBz6QqwZS0WbTGVooyHA7wllFgSUa4+UVwKR5KhHWHSv
         YdXY/pcjWa67nTb/h0fQeGU93Dqd4pvaiZzT5MzHyad4aO/Kg1PAY+ipXwe6ca2+dkGA
         MbZtQzIiUgqMJFP81wQaIHu9jKEKwH5LnlwaaAq7bfFPB53abG7WfNztLOPzPOJuhK0w
         Ws+A==
X-Forwarded-Encrypted: i=1; AJvYcCX2vQsRLBzBMsVTBhnes3dI7NPsV1rMv4ROOim8X2jYwMh2IRb6BjQY+FMa8T6yFgHxDEQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx68wpTCLqzBKihXi6/8vVEhW19O3/oiotKmhEASyiYT03ZhddH
	80R+U59DRcgqODsckeM7kXXj15sLXY5zAQ5kp/qi9fOkg63KMUNQtxTzxWWL6ndU1ogBwDpddta
	NvPyUZuh8KyotMyOYkqrQDd2/K8uiuMfZNG3D9Q==
X-Gm-Gg: ASbGncuX/j2CQZuuNx8edM1uSSO4hZ5HuBGQ6CFrC2fbKVEaH5TX7i9fJ7EYM3TJOpT
	3PuoO9sPUYqOmePzAWpVvu+uDcY8TZjknP2tTGa36ZUgoIuszOyy0KUzIlB/b+N2dbcmjxcDuFs
	5wwQKSlRb8OcGXE5FtOfET/sA=
X-Google-Smtp-Source: AGHT+IGL5CKF7ZLlLOWTXNNHFd3UwB7l1rF5cmuzc7sms6njciyjq1qG2ai0cN8XyaEtFTQLti7jBl0lyb+h3lPX9I0=
X-Received: by 2002:a05:6512:1598:b0:549:8f47:e67d with SMTP id
 2adb3069b0e04-54e7c3fdbd2mr886419e87.34.1745502430166; Thu, 24 Apr 2025
 06:47:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250326065644.73765-1-apatel@ventanamicro.com>
 <20250326065644.73765-10-apatel@ventanamicro.com> <20250412-6eb18b693df1bd8959bcdfc6@orel>
 <CAK9=C2XD2Zk98KJrPYqseVQO-m_tFA97r=eXb2XXJ10vpxuk=A@mail.gmail.com> <20250424-6f042bf5e7c2433d9df6cd11@orel>
In-Reply-To: <20250424-6f042bf5e7c2433d9df6cd11@orel>
From: Anup Patel <apatel@ventanamicro.com>
Date: Thu, 24 Apr 2025 19:16:57 +0530
X-Gm-Features: ATxdqUGyKgYvqFYuWeIiCm7KejgIGr1ToUBN0bphOPv_rE7-cEmyC-W0lHkvFuU
Message-ID: <CAK9=C2U35Z2Q3q9jOVK2tkvUf5FXpN0+__3E8Gi8s6CLYdVM2Q@mail.gmail.com>
Subject: Re: [kvmtool PATCH 09/10] riscv: Add cpu-type command-line option
To: Andrew Jones <ajones@ventanamicro.com>
Cc: Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com, maz@kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Atish Patra <atishp@atishpatra.org>, 
	Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 24, 2025 at 6:59=E2=80=AFPM Andrew Jones <ajones@ventanamicro.c=
om> wrote:
>
> On Thu, Apr 24, 2025 at 06:27:35PM +0530, Anup Patel wrote:
> > On Sat, Apr 12, 2025 at 6:45=E2=80=AFPM Andrew Jones <ajones@ventanamic=
ro.com> wrote:
> > >
> > > On Wed, Mar 26, 2025 at 12:26:43PM +0530, Anup Patel wrote:
> ...
> > > > +         !info->min_cpu_included)
> > > > +             return true;
> > >
> > > If 'min_cpu_included' (or 'min_enabled') is all we plan to check for
> > > whether or not an extension is enabled for the 'min' cpu type, then
> > > we should write this as
> > >
> > >  if (!strcmp(kvm->cfg.arch.cpu_type, "min"))
> > >     return !info->min_enabled;
> > >
> > > Otherwise when min_enabled is true we'd still check
> > > kvm->cfg.arch.ext_disabled[info->ext_id].
> >
> > The extensions part of "min" cpu_type can be disabled using
> > "--disable-xyz" command-line options hence the current approach.
> >
>
> Shouldn't we just have a single place to check? Otherwise something like
> this may not work the way the user expects
>
>   -cpu min,xyz --disable-xyz

Yes, adding "xyz" extension to "min" cpu-type as comma separated
value and then disabling using --disable-xyz looks silly but the intention
here is that --disable-xyz options should work min cpu-type as long as
xyz is included in min cpu-type.

This will help in future if we decide to add "min_v2" or "min++"
cpu-type.

>
> Something like that makes sense if you have a runkvm script like this
>
>   #!/bin/bash
>   BASE_CPU=3Dmin,xyz
>   lkvm ... -cpu $BASE_CPU $@
>
> and then you invoke it with
>
>   runkvm --disable-xyz

This is also a possible way of using this but this was not my intention.

>
> > > >       bool            sbi_ext_disabled[KVM_RISCV_SBI_EXT_MAX];
> > > >  };
> > > >
> > > > +int riscv__cpu_type_parser(const struct option *opt, const char *a=
rg, int unset);
> > > > +
> > > >  #define OPT_ARCH_RUN(pfx, cfg)                                    =
           \
> > > >       pfx,                                                         =
   \
> > > > +     OPT_CALLBACK('\0', "cpu-type", kvm, "min or max",            =
   \
> > > > +                  "Choose the cpu type (default is max).", riscv__=
cpu_type_parser, kvm),\
> > >
> > > I had to look ahead at the next patch to understand why we're setting=
 kvm
> > > as the opt pointer here. I think it should be added in the next patch
> > > where it's used. Also, we don't use opt->value so we cna set that to =
NULL.
> >
> > We are indeed using opt->ptr in this patch so we should be passing
> > kvm as opt-ptr.
>
> Oh yeah, I see that now.
>
> > > > diff --git a/riscv/kvm.c b/riscv/kvm.c
> > > > index 1d49479..6a1b154 100644
> > > > --- a/riscv/kvm.c
> > > > +++ b/riscv/kvm.c
> > > > @@ -20,6 +20,8 @@ u64 kvm__arch_default_ram_address(void)
> > > >
> > > >  void kvm__arch_validate_cfg(struct kvm *kvm)
> > > >  {
> > > > +     if (!kvm->cfg.arch.cpu_type)
> > > > +             kvm->cfg.arch.cpu_type =3D "max";
> > > >  }
> > >
> > > Hmm, seems like we're missing the right place for this. A validate
> > > function shouln't be setting defaults. I think we should rename
> > > kvm__arch_default_ram_address() to
> > >
> > >   void kvm__arch_set_defaults(struct kvm_config *cfg)
> > >
> > > and set cfg->ram_addr inside it. Then add the cpu_type default
> > > setting to riscv's impl.
> >
> > Renaming kvm__arch_default_ram_address() is certainly not
> > the right way because it has to be done after parsing options
> > so that we set the default value of cpu_type only if it is not
> > set by command-line options. Due to this reason, the
> > kvm__arch_validate_cfg() is the best place to set default
> > value of cpu_type.
>
> Can't we just unconditionally set kvm->cfg.arch.cpu_type to "max" in
> kvm__arch_set_defaults() and then if the command line parsing determines
> it should be overridden it gets reassigned?
>
> Actually, does cpu_type need to be a string? If we use an enum for it
> we could save ourselves some of the strcmp pain.
>

Good suggestion, let me try.

Regards,
Anup

