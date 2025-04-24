Return-Path: <kvm+bounces-44139-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B9E2A9AF06
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 15:32:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3CA8B19418BF
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 13:32:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0C7D1494D9;
	Thu, 24 Apr 2025 13:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="BmCemtt+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E99D2745E
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 13:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745501554; cv=none; b=d7Lonf7SsLMmz+qOrUQJoKVyLNQuuzSztnzSphQlzh+z+qB6Uc8pCGgtkrXfoqr+RWyxUd4YMrZ92z0Lo1pGvbQpbbqKd2epCr8+sdPTHobGs7wDOhP0EFcyxn2TZ6j06ONio9E7SHXjiopJktLuJ4P5AbUtusvXPpGZ/TBp6pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745501554; c=relaxed/simple;
	bh=5IPXTT9VmT2loS2S4rr1Aj1vKmILujXvR/ey8pnT8jQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nkwqNLnAHhCERmsYnXkymgE5AUPYxqKclwGNO3tjISJzX9DpEAMcgYM1nYYFv6kt1cNIGSgkK2hFEXOPwGBsw7rlkhPWRcmp6PCH8H8TTrY74b50rADd4VFWahNeZuapfIj1y4ZVocrqpBEZF5vxRqxUu3S9Db2UovTmkE1xAUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=BmCemtt+; arc=none smtp.client-ip=209.85.208.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-310447fe59aso13067031fa.0
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 06:32:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1745501550; x=1746106350; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VeGcKHqB4Z2wfMv1jlgWPhEkEZUjDKBb+pZQP8ZrwYI=;
        b=BmCemtt+Yk16NVP98++4blWYcT9WTKjepuoc8IgI+/FRqLaSpoIcgg8MeqnH/AhGRz
         2GKjBtNb7skn73t55QSkzc2NpH+cZpyzoWsMASwLY5jQBrBxS3u46IR7z8EQT1FZrrKn
         4K3jCF1IhRz4CxoKddXkUBeKKaNi2rkdrmhM1CM/L2GcamocKT0xCLCoyTwXcb/VTzyE
         48jIEHINuXKfORVee55/rpEnfgJYwOhn8nCtg0GJ1tumHH8tZE2mOR4nUg9H4XJBa5Ti
         tM9zlMhZAm6ZWnHMPijLRuP38lMbQsDa1Hm/z1RsWG4YvW+LRWr3k1CJK6Wvz2VyTpGm
         o/NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745501550; x=1746106350;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VeGcKHqB4Z2wfMv1jlgWPhEkEZUjDKBb+pZQP8ZrwYI=;
        b=Ccz8KoeGZquM2EIIvTwq4ZfXo9rXzbgPXVHzumSTgzaAAlhWQ1f1RgjFzPDfkabAkw
         Un9H2bmIXyFjc6Y95UOQeiXvRfhJJqdph1XwlQIw8pSv5krwlckhWLuBW/aOaC9Xf+un
         Niteb2rHmCibccEv/QRkYH3V1SyXTW470dtW58SDBQrukF8mMApGBTnaoqoQnEsDcLuX
         2Ua84S1kJGulcYurvLIEH9UVhJ3YRFvvXCCO0YP1tNUKXFNsm+pLaTNDuuF/vNVt4PqN
         1kLvsGVRBJB8veuIVwAzktFFTtEzucsBG3ZxIRJQ3I/8OXBQYC3Ys+EC4M3LvgY5M+Em
         Zg9Q==
X-Forwarded-Encrypted: i=1; AJvYcCUjd6h6+kVyn3Cy4vgV2qzFRdXjwxbep7bzlTgbj1pnn4egjQobNZhNlpMQ/JUZdDpzyRg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz21Xewh6bsVQpEzly12OW1oU+vgF223FES0lNOEWvW/YSXHfpZ
	Mdz1mPd1s0gxW1gNqAP0Ji+JKsyYrOfzYu8wa8tLTZ58dx2Gc2Y3t492YKo2HYmZnEqFy2//cCO
	EEdUShlqmM5fpugayt/3K6VpD/OJKao38UFjQZA==
X-Gm-Gg: ASbGnctWLAWetLrdR4ywo1AiPe8kmr6NDZ5+4HEY3RRtsrIw+q6q3OMVEtsKf/fR5tv
	JtQxR7nk8I0WHlWfgRLizi0x8JgvbAZrbt5TDmTHt5eRc1l8N2NDYpbFardBJEYm/Rz9e4Qg8n8
	ui26adSYhJkwrFv3FccOO5URA=
X-Google-Smtp-Source: AGHT+IGdkCBJNeEpaCji6/KEonktM17wtjAw8Q/rmHqSi7hrgYLhJ2gPdSQVVvF8FRxWYb7NCMN16LkgY93J/3dhPmc=
X-Received: by 2002:a2e:bc18:0:b0:30b:fe62:2329 with SMTP id
 38308e7fff4ca-3179e5e5184mr10744571fa.11.1745501550226; Thu, 24 Apr 2025
 06:32:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250326065644.73765-1-apatel@ventanamicro.com>
 <20250326065644.73765-11-apatel@ventanamicro.com> <20250412-bc81866c2227ed98429f86b5@orel>
In-Reply-To: <20250412-bc81866c2227ed98429f86b5@orel>
From: Anup Patel <apatel@ventanamicro.com>
Date: Thu, 24 Apr 2025 19:02:18 +0530
X-Gm-Features: ATxdqUGKpSyTYWk5wjcQ2o5qr5UQRJKGGv-UNCsqsaOCMCRFJdyBoxZECeLxDoU
Message-ID: <CAK9=C2UxikXyX_VEn7txnfXVjCdLE7Awn=yjs_Ye2dc8VP=DRg@mail.gmail.com>
Subject: Re: [kvmtool PATCH 10/10] riscv: Allow including extensions in the
 min CPU type using command-line
To: Andrew Jones <ajones@ventanamicro.com>
Cc: Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com, maz@kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Atish Patra <atishp@atishpatra.org>, 
	Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 12, 2025 at 7:15=E2=80=AFPM Andrew Jones <ajones@ventanamicro.c=
om> wrote:
>
> On Wed, Mar 26, 2025 at 12:26:44PM +0530, Anup Patel wrote:
> > It is useful to allow including extensions in the min CPU type on need
> > basis via command-line. To achieve this, parse extension names as comma
> > separated values appended to the "min" CPU type using command-line.
> >
> > For example, to include Sstc and Ssaia in the min CPU type use
> > "--cpu-type min,sstc,ssaia" command-line option.
> >
> > Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> > ---
> >  riscv/fdt.c | 41 +++++++++++++++++++++++++++++++++++++++--
> >  1 file changed, 39 insertions(+), 2 deletions(-)
> >
> > diff --git a/riscv/fdt.c b/riscv/fdt.c
> > index 4c018c8..9cefd2f 100644
> > --- a/riscv/fdt.c
> > +++ b/riscv/fdt.c
> > @@ -108,6 +108,20 @@ static bool __isa_ext_warn_disable_failure(struct =
kvm *kvm, struct isa_ext_info
> >       return true;
> >  }
> >
> > +static void __min_cpu_include(const char *ext, size_t ext_len)
>
> s/include/enable/

Okay, I will update.

>
> > +{
> > +     struct isa_ext_info *info;
> > +     unsigned long i;
> > +
> > +     for (i =3D 0; i < ARRAY_SIZE(isa_info_arr); i++) {
> > +             info =3D &isa_info_arr[i];
> > +             if (strlen(info->name) !=3D ext_len)
> > +                     continue;
> > +             if (!strncmp(ext, info->name, ext_len))
>
> strcmp should be fine here since we already checked length.

Well, strcmp() does not work here because the "ext" pointer
points to a non-null terminated substring of a larger comma
separated string.

>
> > +                     info->min_cpu_included =3D true;
> > +     }
> > +}
> > +
> >  bool riscv__isa_extension_disabled(struct kvm *kvm, unsigned long isa_=
ext_id)
> >  {
> >       struct isa_ext_info *info =3D NULL;
> > @@ -128,16 +142,39 @@ bool riscv__isa_extension_disabled(struct kvm *kv=
m, unsigned long isa_ext_id)
> >  int riscv__cpu_type_parser(const struct option *opt, const char *arg, =
int unset)
> >  {
> >       struct kvm *kvm =3D opt->ptr;
> > +     const char *str, *nstr;
> > +     int len;
> >
> > -     if ((strncmp(arg, "min", 3) && strncmp(arg, "max", 3)) || strlen(=
arg) !=3D 3)
> > +     if ((strncmp(arg, "min", 3) || strlen(arg) < 3) &&
>
> If arg =3D=3D 'min', then it can't be less than 3 so the '|| strlen(arg) =
< 3'
> is dead code.
>
> > +         (strncmp(arg, "max", 3) || strlen(arg) !=3D 3))
>
> I think we want
>
>  if (strlen(arg) < 3 ||
>      (strlen(arg) =3D=3D 3 && strcmp(arg, "min") && strcmp(arg, "max")) |=
|
>      strncmp(arg, "min", 3))

Nope, for cpu-type =3D "min" the strlen(arg) can be greater than 3
because of comma separated extensions provided as part of
cpu-type value.

>
> >               die("Invalid CPU type %s\n", arg);
> >
> >       if (!strncmp(arg, "max", 3))
> >               kvm->cfg.arch.cpu_type =3D "max";
> >
> > -     if (!strncmp(arg, "min", 3))
> > +     if (!strncmp(arg, "min", 3)) {
> >               kvm->cfg.arch.cpu_type =3D "min";
> >
> > +             str =3D arg;
> > +             str +=3D 3;
> > +             while (*str) {
> > +                     if (*str =3D=3D ',') {
> > +                             str++;
> > +                             continue;
> > +                     }
> > +
> > +                     nstr =3D strchr(str, ',');
> > +                     if (!nstr)
> > +                             nstr =3D str + strlen(str);
> > +
> > +                     len =3D nstr - str;
> > +                     if (len) {
>
> I think len will always be nonzero since *str isn't \0 and we ate all
> consecutive ,'s above. __min_cpu_include() is also safe to call with
> len=3D0, so we could drop this check.

No point in unnecessarily calling __min_cpu_include() for
len =3D=3D 0. I am sure this extra check won't hurt so I think
we should keep it.

>
> > +                             __min_cpu_include(str, len);
> > +                             str +=3D len;
> > +                     }
> > +             }
> > +     }
> > +
> >       return 0;
> >  }
> >
> > --
> > 2.43.0
> >
>
> Thanks,
> drew

Regards,
Anup

