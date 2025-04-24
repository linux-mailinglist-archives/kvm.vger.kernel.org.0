Return-Path: <kvm+bounces-44184-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FC32A9B1E2
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 17:17:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 431C91B6401C
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 15:17:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AA441993B2;
	Thu, 24 Apr 2025 15:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="M31jKxjB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAE1C15AF6
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 15:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745507838; cv=none; b=Uw7eNYrjeBO6Fth+hN3GR6ukPmIkB6vdQNc8C8ZdHO+qlw7RU9zKbH3dFJL8bpoOsnlvh92cJtmHZ7Sj+SkOMV6Wj5gQ/KOw0y4kXz+QOsA6UMmS9Lvx6vqnLTIkv5fRdjZqtUWe4vjZ5mtbiJGiHOx7L7t5EcyUfdGLZ2xFAdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745507838; c=relaxed/simple;
	bh=tS6s3jdqLfeu/HP/FdG9OAaK5zkeb8OtT1/wlTr2FRw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rIgVpQgvv45J7c+AKlIdHPCb+0psf5dkDhhoZi+4C2v+QcO0NlCdCozBCvHITCjifKQFpLKHGT6BAy3F9TBcBszwpR5BxMkIGjUktbg+tvrCH9v1Zohrxd5Q4gx4EXbtf9cK08uc+2BML8JGfMZUtKvfEHJ2v39UfMwVCR2k0Uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=M31jKxjB; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-54998f865b8so1148328e87.3
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 08:17:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1745507835; x=1746112635; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bkX8L9FmNiooLHGCaRLkArZ3Rbkys/Ef4Mr2QS/rQm4=;
        b=M31jKxjB8GaqDMprh8buwrmpi1oNXoA7Y9bZLosY9SWGlzruOPY2RAeo+lvu8KIJAB
         bGrZTqed4qd4s6MYoHn2iRaKs2PP+oUwKPDrOmeuF2R54RDQRH/4budo7cIclwLaThQJ
         9ZqXUWegwQZsPunqRX3ukk+s39p5a+Ow2cOUirAwJtrXVfs2BOBUDzy4CRSBRpNd7GD0
         4WVULLdEGGoBCYtb2FS9iHNKU/FnYnF0vjxGnfrviDBLokX/LWMeE15oMP2yq9GyW91g
         /dIvhi15ikwNBnLxHo/M7hFtYdtrYj1bZV68L6P5MiX23q4gp6pts7Nld1j+blxEztBK
         tU7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745507835; x=1746112635;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bkX8L9FmNiooLHGCaRLkArZ3Rbkys/Ef4Mr2QS/rQm4=;
        b=IQsyc6grV4Z9fXmAE7voyOc30RPC8bJOKD6uChEKVEEPwjsAR7fMhbUMLfzj7oeIDT
         Lo55EC6pxYJzI93j3achzaTgSkbP/2eh+c+QTwQEH3cdjKbFD5kKeOynBxzAO4BNbPLH
         Iqq/0yYSnhCU+vLda17kQ1ZY4XrxltrJdL4aHaMm99MyVj1e4qOiLnI02FSYEMm57FB3
         Ov/HA7w2WvGTluHynYbnlNfTYRs4P8UHs0ypz6yeFgyEMLXEBL74nNcG44+fOrKFQTpZ
         HMLWZm2JJdVQKqSAFb7FdBEe+TtPdJhvdRI5k32LO6ZQ7vFjosAV2sOM/Mecnhy4JlwG
         pr4A==
X-Forwarded-Encrypted: i=1; AJvYcCWUFzVLiT6y5TTdmJNBzJEH1S6uv3s1k7cM4dIxcc/CleFOZuhIFOVmc5xHZlyczVZw4Io=@vger.kernel.org
X-Gm-Message-State: AOJu0YyxN4qViUTij3G7R5JT1AD8erkgLQ9KFfiz1CG8ElWZB/Ckqplx
	MekOkEmdIskm8MX6IqrL+mGogne9s2XrlRASt6xyJzwEcwKaZYZJuhXQn+kOAi8rurWcYroKUN2
	RJytRSTrlXNyU4V8k/KvDK9o3CG/LLORmMaYPQw==
X-Gm-Gg: ASbGncuXNSxP0keO3qsbTJet+ihfcO2FaBcs+U8IO7A4S6GeDU/sbshcpjtF0MynjJy
	Rhfg+ZbAMsvydohn631NT3j0q/jl+ciSNaz49z50leDCRiMevXI77B+2ZnNfysaAGvuoMSlA7xb
	cYdaq80vb9/OPoEuNU7lW4LlAcMcxDUHcEug==
X-Google-Smtp-Source: AGHT+IEq2nDdTYCCuLC8CvG8Nu1G2tLTs9KyL8Oc/Ly8gBV/Sos+3gNM1kuYagtuyh2a1lvS7wE4XaXBUz4iSISWl4U=
X-Received: by 2002:a05:6512:b99:b0:549:6759:3982 with SMTP id
 2adb3069b0e04-54e7c44cc36mr1090314e87.37.1745507834576; Thu, 24 Apr 2025
 08:17:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250326065644.73765-1-apatel@ventanamicro.com>
 <20250326065644.73765-11-apatel@ventanamicro.com> <20250412-bc81866c2227ed98429f86b5@orel>
 <CAK9=C2UxikXyX_VEn7txnfXVjCdLE7Awn=yjs_Ye2dc8VP=DRg@mail.gmail.com> <20250424-153e6b09d5f0ccdee057a0d9@orel>
In-Reply-To: <20250424-153e6b09d5f0ccdee057a0d9@orel>
From: Anup Patel <apatel@ventanamicro.com>
Date: Thu, 24 Apr 2025 20:47:02 +0530
X-Gm-Features: ATxdqUEEIROQU0mWFtLvZ77bUroGqt47muzTW4_uxC9olgu_IqcHhHi2hGHp7K0
Message-ID: <CAK9=C2VCvE34hdTa2h2_Yr78HO-m5fWw-EzM2L9AAgaE9dDs+Q@mail.gmail.com>
Subject: Re: [kvmtool PATCH 10/10] riscv: Allow including extensions in the
 min CPU type using command-line
To: Andrew Jones <ajones@ventanamicro.com>
Cc: Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com, maz@kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Atish Patra <atishp@atishpatra.org>, 
	Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 24, 2025 at 7:37=E2=80=AFPM Andrew Jones <ajones@ventanamicro.c=
om> wrote:
>
> On Thu, Apr 24, 2025 at 07:02:18PM +0530, Anup Patel wrote:
> > On Sat, Apr 12, 2025 at 7:15=E2=80=AFPM Andrew Jones <ajones@ventanamic=
ro.com> wrote:
> > > >  bool riscv__isa_extension_disabled(struct kvm *kvm, unsigned long =
isa_ext_id)
> > > >  {
> > > >       struct isa_ext_info *info =3D NULL;
> > > > @@ -128,16 +142,39 @@ bool riscv__isa_extension_disabled(struct kvm=
 *kvm, unsigned long isa_ext_id)
> > > >  int riscv__cpu_type_parser(const struct option *opt, const char *a=
rg, int unset)
> > > >  {
> > > >       struct kvm *kvm =3D opt->ptr;
> > > > +     const char *str, *nstr;
> > > > +     int len;
> > > >
> > > > -     if ((strncmp(arg, "min", 3) && strncmp(arg, "max", 3)) || str=
len(arg) !=3D 3)
> > > > +     if ((strncmp(arg, "min", 3) || strlen(arg) < 3) &&
> > >
> > > If arg =3D=3D 'min', then it can't be less than 3 so the '|| strlen(a=
rg) < 3'
> > > is dead code.
> > >
> > > > +         (strncmp(arg, "max", 3) || strlen(arg) !=3D 3))
> > >
> > > I think we want
> > >
> > >  if (strlen(arg) < 3 ||
> > >      (strlen(arg) =3D=3D 3 && strcmp(arg, "min") && strcmp(arg, "max"=
)) ||
> > >      strncmp(arg, "min", 3))
> >
> > Nope, for cpu-type =3D "min" the strlen(arg) can be greater than 3
> > because of comma separated extensions provided as part of
> > cpu-type value.
>
> That's what the last condition 'strncmp(arg, "min", 3)' of my proposed
> compound-condition is confirming. That condition is only checked for
> strlen(arg) > 3.
>

This last condition causes "--cpu-type max" to fail.

Regards,
Anup

