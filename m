Return-Path: <kvm+bounces-32841-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 691859E0AF3
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 19:26:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 27347163F91
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 18:26:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3B841DE2CF;
	Mon,  2 Dec 2024 18:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="qDfrXbBu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBFBA1DDC1C
	for <kvm@vger.kernel.org>; Mon,  2 Dec 2024 18:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733163988; cv=none; b=GgJVFLD6n6KO1J+yMTK/iuwy3fcJ23D4KddXyEh/q33q+YDXD0lRIlawFN3olAYpfg9pWZplrl7jB/cmWMYlJuvs8D2AoISR08tmJmxGg0shxgRSu2EhhlcyuorSSyUikwBRqbBIaFAv4pnrO4Nots+RSWGZL35yV0cNoD0Mhgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733163988; c=relaxed/simple;
	bh=vGodzCJVBpdbhBU4jIgckviiIENNu2tjMRs7JzTqFBo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gZ5jDOU1Ixhy2fsUgpd8bSDyagyHKmoYTPJ/8t5pBA3qkuwopWBQqFV6f3PxAUKU0ixQqcEatMnqfh2f1GZT+8gOqEL0wAaZjkxwFSCM9RkBHNGkanZUWd6x6qZRk5NrLkoaNZXvVj2LvEpQo4qFV5R21aktcnu+T7AW/7iNt8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=qDfrXbBu; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2155312884fso28887225ad.0
        for <kvm@vger.kernel.org>; Mon, 02 Dec 2024 10:26:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1733163984; x=1733768784; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y1fSjzDB3EYral3FJfD5w5SvZiqHwVm4ThrouSzXoG0=;
        b=qDfrXbButJqmhV8jhzv1kZ+BR61N+60b7GaCLBJkW0cx4digV75LEO8nqFKT6GwvPF
         oK0uC4YwDFaMWcFnUQcvmkp4sogyA+vp9QKxUCO2MG8ufudsIXHcPqNb6xfNdsnz/JC0
         9RaEzi1dUAumbCuviDU7L5kXxOue1iHXk6EtpAQVkJt4mcjlpeu0P94G+eSTmgAuuJJ3
         UFctMOvAkEvJpevYErnac6CG3cOgm0Grg6Nl+yVIDSqKqRPaQCL3ubgIcVvz0MExW2Gt
         0XuzSPQWzDKzxeKUb5O9zwMBOY124fIJOwXP8DKhN6BGcPd/ZWivGtvv0E2KFPuJPTto
         dwlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733163984; x=1733768784;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y1fSjzDB3EYral3FJfD5w5SvZiqHwVm4ThrouSzXoG0=;
        b=OadWwcEKe9l6pGOq900KoqFOuheEtug4l50NayvfqTbGoiIFniq3nzwj6iNAOWH59I
         tFqpBEpqPCDoumAvdH63/UVWz0GVkKsh4dmjlUiCo1VGpcXclNuLGnQDKLcgJG/b2SDq
         mINT3v6zJHUPyvyS5N0FYCzYXnCNWhdolJJGZU20Y/wR4CUD7/CQ1gwdXUq2JiSH3JLh
         XzMJtBj5e7ASLKTroKXDVKsJA3eHH5/F9XA8uRI1wvDEBjuVaso9alGQOA95me4Lbzx6
         DJGXhRFQJVf66iZtP4PiHjQrNJrRbDaGOjE0uCHiZnfMaXYAwZy9j5QKVjfR4smqLbmg
         cHlA==
X-Forwarded-Encrypted: i=1; AJvYcCXnvpiyn4RUPHc0Kda+FLzvlQ8FVIQrootFc+wQ2VowqCMkBrkATS7U9I3D0DvDXwZMk2w=@vger.kernel.org
X-Gm-Message-State: AOJu0YzNbZ3SSGWwqRJlmEkvGfo2aqxt3v1zHJL9qXejfNknBniVfFym
	UfxYr8rn7VOgrPHnm+iN9XNrNq2CmgC6hALEDou/Dgux/PYPzZ5/myQV1v87QJYf7ZE5h71jI4D
	lGxwsRhLhmo7z8SWxUq/mjCpdwIfqIOVCcUfhRg==
X-Gm-Gg: ASbGncvMSX6xcxwbzuNojjp+HYCXlCTZlAT0CTLthebN6k+5a1DCfyBu+la5nAv4zQC
	rlEdXwRP9dsFkjUBfRvWs+2miJbfIzg==
X-Google-Smtp-Source: AGHT+IHisvs3rWpMuRQOWixPnTvVtgjxW+u1yNS90T+VjRikLrDQHeBjU8J20X11uqJqFe47EIY9Qqlj+A9dyAN+3sc=
X-Received: by 2002:a17:902:f54c:b0:215:8695:ef91 with SMTP id
 d9443c01a7336-2158695f663mr92656975ad.6.1733163984202; Mon, 02 Dec 2024
 10:26:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241119-pmu_event_info-v1-0-a4f9691421f8@rivosinc.com>
 <20241119-pmu_event_info-v1-2-a4f9691421f8@rivosinc.com> <77b7b44f-e05a-4845-8d45-0e0d831bb8e7@ghiti.fr>
In-Reply-To: <77b7b44f-e05a-4845-8d45-0e0d831bb8e7@ghiti.fr>
From: Atish Kumar Patra <atishp@rivosinc.com>
Date: Mon, 2 Dec 2024 10:26:13 -0800
Message-ID: <CAHBxVyHZvLrKNCAPJfHxYYn30Mm++J=mff+tVU9GZ_8rt3WnEg@mail.gmail.com>
Subject: Re: [PATCH 2/8] drivers/perf: riscv: Fix Platform firmware event data
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: Anup Patel <anup@brainfault.org>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Mayuresh Chitale <mchitale@ventanamicro.com>, 
	linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Palmer Dabbelt <palmer@rivosinc.com>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 28, 2024 at 5:10=E2=80=AFAM Alexandre Ghiti <alex@ghiti.fr> wro=
te:
>
> Hi Atish,
>
> On 19/11/2024 21:29, Atish Patra wrote:
> > Platform firmware event data field is allowed to be 62 bits for
> > Linux as uppper most two bits are reserved to indicate SBI fw or
> > platform specific firmware events.
> > However, the event data field is masked as per the hardware raw
> > event mask which is not correct.
> >
> > Fix the platform firmware event data field with proper mask.
> >
> > Fixes: f0c9363db2dd ("perf/riscv-sbi: Add platform specific firmware ev=
ent handling")
> >
> > Signed-off-by: Atish Patra <atishp@rivosinc.com>
> > ---
> >   arch/riscv/include/asm/sbi.h |  1 +
> >   drivers/perf/riscv_pmu_sbi.c | 12 +++++-------
> >   2 files changed, 6 insertions(+), 7 deletions(-)
> >
> > diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.=
h
> > index 98f631b051db..9be38b05f4ad 100644
> > --- a/arch/riscv/include/asm/sbi.h
> > +++ b/arch/riscv/include/asm/sbi.h
> > @@ -158,6 +158,7 @@ struct riscv_pmu_snapshot_data {
> >   };
> >
> >   #define RISCV_PMU_RAW_EVENT_MASK GENMASK_ULL(47, 0)
> > +#define RISCV_PMU_PLAT_FW_EVENT_MASK GENMASK_ULL(61, 0)
> >   #define RISCV_PMU_RAW_EVENT_IDX 0x20000
> >   #define RISCV_PLAT_FW_EVENT 0xFFFF
> >
> > diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sbi.=
c
> > index cb98efa9b106..50cbdbf66bb7 100644
> > --- a/drivers/perf/riscv_pmu_sbi.c
> > +++ b/drivers/perf/riscv_pmu_sbi.c
> > @@ -508,7 +508,6 @@ static int pmu_sbi_event_map(struct perf_event *eve=
nt, u64 *econfig)
> >   {
> >       u32 type =3D event->attr.type;
> >       u64 config =3D event->attr.config;
> > -     u64 raw_config_val;
> >       int ret;
> >
> >       /*
> > @@ -529,21 +528,20 @@ static int pmu_sbi_event_map(struct perf_event *e=
vent, u64 *econfig)
> >       case PERF_TYPE_RAW:
> >               /*
> >                * As per SBI specification, the upper 16 bits must be un=
used
> > -              * for a raw event.
> > +              * for a hardware raw event.
> >                * Bits 63:62 are used to distinguish between raw events
> >                * 00 - Hardware raw event
> >                * 10 - SBI firmware events
> >                * 11 - Risc-V platform specific firmware event
> >                */
> > -             raw_config_val =3D config & RISCV_PMU_RAW_EVENT_MASK;
> > +
> >               switch (config >> 62) {
> >               case 0:
> >                       ret =3D RISCV_PMU_RAW_EVENT_IDX;
> > -                     *econfig =3D raw_config_val;
> > +                     *econfig =3D config & RISCV_PMU_RAW_EVENT_MASK;
> >                       break;
> >               case 2:
> > -                     ret =3D (raw_config_val & 0xFFFF) |
> > -                             (SBI_PMU_EVENT_TYPE_FW << 16);
> > +                     ret =3D (config & 0xFFFF) | (SBI_PMU_EVENT_TYPE_F=
W << 16);
> >                       break;
> >               case 3:
> >                       /*
> > @@ -552,7 +550,7 @@ static int pmu_sbi_event_map(struct perf_event *eve=
nt, u64 *econfig)
> >                        * Event data - raw event encoding
> >                        */
> >                       ret =3D SBI_PMU_EVENT_TYPE_FW << 16 | RISCV_PLAT_=
FW_EVENT;
> > -                     *econfig =3D raw_config_val;
> > +                     *econfig =3D config & RISCV_PMU_PLAT_FW_EVENT_MAS=
K;
> >                       break;
> >               }
> >               break;
> >
>
> It seems independent from the other patches, so I guess we should take
> it for 6.13 rcX.
>

Yes. This patch doesn't have any SBI v3.0 dependencies. I will send
this patch separately
so that it can be applied for 6.13 rcX

> Let me know if that's not the case.
>
> Thanks,
>
> Alex
>

