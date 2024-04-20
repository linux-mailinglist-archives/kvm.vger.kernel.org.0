Return-Path: <kvm+bounces-15409-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 194BB8AB838
	for <lists+kvm@lfdr.de>; Sat, 20 Apr 2024 03:08:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 81A1A1F21778
	for <lists+kvm@lfdr.de>; Sat, 20 Apr 2024 01:08:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 477371851;
	Sat, 20 Apr 2024 01:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="TP8g5oyW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A580D63E
	for <kvm@vger.kernel.org>; Sat, 20 Apr 2024 01:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713575307; cv=none; b=IDCVmEENYHZBLyXDfEhIAw9mUKg16Z78F9x8mW0I7VV0M/9PIhAnJHKxSE2SM5S9wYPWAZLOB3V7pVgQfUv8+iV/TGDV2zcvaPc0/eYFOxLv4WtVOnUAQRMWH1VwO1jKCjO6Isy9oIezR+zwWLt8Q+X3sZATlr+kolNJpFZjVIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713575307; c=relaxed/simple;
	bh=/v5DF/yr70RSo2cPlpFendzuWaxo1OWbch7DeiC/1po=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=o+rAUylQHDmbfEN7sMU/6Ellq3MBq1S83gUM/KOHOrnFugAWUVC8HTX4yeoG+8S4gybC0QdNWgvfmn3izh/nyctnOraxyMAg1STXSUXY6gFB+IHXr38uU2kHWARPMTr1c+DVG+NmLsNLcQZnXYLuUC36vDUP2yTcpRwdBi6SFEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=TP8g5oyW; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-518931f8d23so2669284e87.3
        for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 18:08:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1713575304; x=1714180104; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FopOoJVqlKLyitM+vV+llThPHlvMlGI12SmtWJmmk/0=;
        b=TP8g5oyWZGaFY+FIx/xBLkzBYg5ipxmpMLGeLn7b3e392q0X+8vNxbgjwMYY0nKo5W
         RGzxXUXagCcv9Tm0VObNwoWVH34aKqX93CNzj9TiVsOcxzxGFZff0cLVYH2KXy8xWvli
         qYXhw7wnmnD2hX4DZg/Oi9o1tDNWH2Mbj4n3eE5T9RgXZUlgWdsEyjn4uhhpfPPhSqfQ
         HOJ/LxTGHpWUn8EqI+lC3/XxNuM3VBjUBVKVnSt8Sx6DdL3R5DESIMq4Uh/SmHuLNY0o
         +OPwBx1Gc4N6jPc0aABYWybC8EG01gW/O8sOAw/ZnHleMfMJHUzAYdML1J/c5SBygoNX
         v8Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713575304; x=1714180104;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FopOoJVqlKLyitM+vV+llThPHlvMlGI12SmtWJmmk/0=;
        b=KmEv9r3aXNaF+tC1pPO2zqb70msvWRpHHVppIsy/b4vXcdCCKj0jkoib2qeQPkSa1e
         uuYxuv7oEoRB634+6f1UgfQWfEJdY85Tv5kBn50knWGpqlWiwwGiAQ5BMhmQa4iEt2k5
         kIbO7g5PZPKfMeEBQd2x2OWywk4KASIDhlN6jVIVnVjt109wNr1BqoW4cMPlo3AD77MP
         EVbxWGz72aiSRlChNzAN/Kc1JZKdbLXEZFtCL42VDjkKEjTZKkvukWwBCgiOVPCLxIin
         I3K/H+SyvTUAqIyLITSbfxbsw/i9XvVzyuHSg67Tm1BMMqBpCMkEh8/lTpF0dfaaXPqe
         0X8g==
X-Forwarded-Encrypted: i=1; AJvYcCWTh14LYZeubMpUFoTKBQHt51JhikXwA6gv5dx2QGByLSQMxiGZjoNZg9+Y1v7a4qeUxQkKw1UZ+50puJtZ4rt+VKmJ
X-Gm-Message-State: AOJu0YyBjwt0Z+4Jkq888QDKLuoon9q4vA9wQ7+V5vNtYlTZk6kddw0b
	c3cWZegw6/v1IE23GyWFT849aO5E3lSF2qpkldFHl0tPrSj64y1Hjx0OPY4JoXkwhs8RMck4Uo9
	zPEZlIkIIUY0PEW5Xf81QBVLR1962FnEudbOlJw==
X-Google-Smtp-Source: AGHT+IEogPfnlgAs9tR0qh0PAukDsFCglg4IjcLIKZzaVYr+8YdRMjPXcvRvV/A0KI3X5O1GyN/90pSnjyS/BTYsdl8=
X-Received: by 2002:ac2:5a1e:0:b0:519:296e:2c80 with SMTP id
 q30-20020ac25a1e000000b00519296e2c80mr1893557lfn.15.1713575303793; Fri, 19
 Apr 2024 18:08:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240420151741.962500-1-atishp@rivosinc.com> <20240420151741.962500-9-atishp@rivosinc.com>
 <6fa06233-d572-48a7-a8ef-73a7c5879c06@sifive.com>
In-Reply-To: <6fa06233-d572-48a7-a8ef-73a7c5879c06@sifive.com>
From: Atish Kumar Patra <atishp@rivosinc.com>
Date: Fri, 19 Apr 2024 18:08:12 -0700
Message-ID: <CAHBxVyHZ81G7yaMkV25RBwS=ric=MA92MePaPtQaOXuR+C70YA@mail.gmail.com>
Subject: Re: [PATCH v8 08/24] drivers/perf: riscv: Fix counter mask iteration
 for RV32
To: Samuel Holland <samuel.holland@sifive.com>
Cc: linux-kernel@vger.kernel.org, Andrew Jones <ajones@ventanamicro.com>, 
	Ajay Kaher <ajay.kaher@broadcom.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alexghiti@rivosinc.com>, Anup Patel <anup@brainfault.org>, 
	Conor Dooley <conor.dooley@microchip.com>, Juergen Gross <jgross@suse.com>, 
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-riscv@lists.infradead.org, 
	Mark Rutland <mark.rutland@arm.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Shuah Khan <shuah@kernel.org>, virtualization@lists.linux.dev, 
	Will Deacon <will@kernel.org>, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 19, 2024 at 5:37=E2=80=AFPM Samuel Holland
<samuel.holland@sifive.com> wrote:
>
> Hi Atish,
>
> On 2024-04-20 10:17 AM, Atish Patra wrote:
> > For RV32, used_hw_ctrs can have more than 1 word if the firmware choose=
s
> > to interleave firmware/hardware counters indicies. Even though it's a
> > unlikely scenario, handle that case by iterating over all the words
> > instead of just using the first word.
> >
> > Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> > Signed-off-by: Atish Patra <atishp@rivosinc.com>
> > ---
> >  drivers/perf/riscv_pmu_sbi.c | 21 ++++++++++++---------
> >  1 file changed, 12 insertions(+), 9 deletions(-)
> >
> > diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sbi.=
c
> > index f23501898657..4eacd89141a9 100644
> > --- a/drivers/perf/riscv_pmu_sbi.c
> > +++ b/drivers/perf/riscv_pmu_sbi.c
> > @@ -652,10 +652,12 @@ static inline void pmu_sbi_stop_all(struct riscv_=
pmu *pmu)
> >  static inline void pmu_sbi_stop_hw_ctrs(struct riscv_pmu *pmu)
> >  {
> >       struct cpu_hw_events *cpu_hw_evt =3D this_cpu_ptr(pmu->hw_events)=
;
> > +     int i;
> >
> > -     /* No need to check the error here as we can't do anything about =
the error */
> > -     sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_STOP, 0,
> > -               cpu_hw_evt->used_hw_ctrs[0], 0, 0, 0, 0);
> > +     for (i =3D 0; i < BITS_TO_LONGS(RISCV_MAX_COUNTERS); i++)
> > +             /* No need to check the error here as we can't do anythin=
g about the error */
> > +             sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_STOP, i * BITS=
_PER_LONG,
> > +                       cpu_hw_evt->used_hw_ctrs[i], 0, 0, 0, 0);
> >  }
> >
> >  /*
> > @@ -667,7 +669,7 @@ static inline void pmu_sbi_stop_hw_ctrs(struct risc=
v_pmu *pmu)
> >  static inline void pmu_sbi_start_overflow_mask(struct riscv_pmu *pmu,
> >                                              unsigned long ctr_ovf_mask=
)
> >  {
> > -     int idx =3D 0;
> > +     int idx =3D 0, i;
> >       struct cpu_hw_events *cpu_hw_evt =3D this_cpu_ptr(pmu->hw_events)=
;
> >       struct perf_event *event;
> >       unsigned long flag =3D SBI_PMU_START_FLAG_SET_INIT_VALUE;
> > @@ -676,11 +678,12 @@ static inline void pmu_sbi_start_overflow_mask(st=
ruct riscv_pmu *pmu,
> >       struct hw_perf_event *hwc;
> >       u64 init_val =3D 0;
> >
> > -     ctr_start_mask =3D cpu_hw_evt->used_hw_ctrs[0] & ~ctr_ovf_mask;
> > -
> > -     /* Start all the counters that did not overflow in a single shot =
*/
> > -     sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_START, 0, ctr_start_ma=
sk,
> > -               0, 0, 0, 0);
> > +     for (i =3D 0; i < BITS_TO_LONGS(RISCV_MAX_COUNTERS); i++) {
> > +             ctr_start_mask =3D cpu_hw_evt->used_hw_ctrs[i] & ~ctr_ovf=
_mask;
>
> This is applying the mask for the first 32 logical counters to the both s=
ets of
> 32 logical counters. ctr_ovf_mask needs to be 64 bits wide here, so each =
loop
> iteration can apply the correct half of the mask.
>

The 64bit wide support for ctr_ovf_mask is added in the next patch.

> Regards,
> Samuel
>
> > +             /* Start all the counters that did not overflow in a sing=
le shot */
> > +             sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_START, i * BIT=
S_PER_LONG, ctr_start_mask,
> > +                     0, 0, 0, 0);
> > +     }
> >
> >       /* Reinitialize and start all the counter that overflowed */
> >       while (ctr_ovf_mask) {
>

