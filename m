Return-Path: <kvm+bounces-39430-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 64FD0A470B0
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 02:05:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 245117A8A7B
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 01:04:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA93873477;
	Thu, 27 Feb 2025 01:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="lnHLPhFi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F54D54670
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 01:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740618319; cv=none; b=RsRI3PJQQ4+ufO8M6FkyEUkDqW6SDUMf/S1gz+ACGUjVsZicnuefkuOO1Azr4bP/f/5qS70zaGdq/YZ7AnNpVN/5HhwpedA76/6ieySuJEEctSryv4e37Kx2slKMX2Ary+bjvMIlXhnVVdoWHUjRrY9hwnQyBPTUnCMdtbaUALE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740618319; c=relaxed/simple;
	bh=GRHohmURlG1J0vCfqtMiE4OfWdA8l+xtBbsvFxNKx/s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nq/TBzPmGR4XzFgO8G/S/GWiVjsxbjJziw/kMFEM8TAzz3vkmBf1H1jwjVic2iYxamncgWP8+hs0B7AxxGkoSera2mANOz5r4ysmGzIfvl6iM1wRID/rnaLiqEolqC8xS32YMMVsSFu/aw/iavRTaJVwE+U7Z9MalrDD2RQNnXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=lnHLPhFi; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-223480ea43aso8575575ad.1
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 17:05:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1740618316; x=1741223116; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OPhlc9bmrf/baBUYMBCbtsRt7KZ0PJ5cb4Ib6su88Rg=;
        b=lnHLPhFijyHRvkkOPm3MymgpuIllImcuvfCfhJpXO1Ak62eQz8A6fpJH7TDbWW5Y2h
         5Cij8YrgzM9d/gNHPHgeL2764ukOrs9CmM+iqF7Fh6YUCCIm2uBnJrQ8hOa9BFG0ZViF
         dqtlACZguZ2TA1xXiP4XqYLko5NNURfGYDXj9Srj37jnZEM4PsBqNOgCxp75SlzLha6Y
         gBF5RHWp+r0W8KW/kvfcPysWDdRX0yRSmQ5w/WXLOI3n8VWP5+3rSYXP1KT1+r19kmry
         RSgQqMjgheLe8oFoqEsRoJp3NbMAy5tnKJw8GkC3Vmhvgqer1/VRRS2viIcxzXvdImFH
         dTgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740618316; x=1741223116;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OPhlc9bmrf/baBUYMBCbtsRt7KZ0PJ5cb4Ib6su88Rg=;
        b=N96lqZQxddi/XVpqrIZjVvqUpx1jxhjpcVqw406cj+Ba/z/VnYlHpFk5Skt1Ny9zHc
         +J2jLwamMWUP9oz4nCxCJdLjh2uoSICEIUS/SbWM75aynX3yEdDURkz7tO3UzC9zavTA
         Umn3tm0H2jP4OJRZomkHakALLtm6Fz18J6bJECXmlNPbDzurFW+/K5d5se4t5EPjjKsv
         uchUZ7eaa6+UVzl2xksSHnXnuBglyiCZ6Geu9sjSVJl6HW24OqvWIFKRifJYrdRwbzer
         rD7HSAt2jqT96uH67GAYFu1rGkHiv+U7vY1VmsPTFigmqJ2rZMZ12zzIu7tTGEOIvAx1
         agOQ==
X-Forwarded-Encrypted: i=1; AJvYcCXUVS2/Bq5p+EzUDTbVcJ728P+rmlIn/vEiX953IEhlKUxOUQnKfzIl1OeUkhcdRhdcKIM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzKF3ATqLZcdhwOS43Spv3TyuOamU5ezwzYM6ikfcJSnKCZ+JWH
	+8aFV8XgIWSWo/jO2exR8FOnFCGcKKCJx+ZvftK92cUX9syIw1kwhww9IDrdyE2mtupiWQ9thjW
	VM0W7K5Zc1+ak4Mw/0JQO3aS1sxXEQbUetqehXA==
X-Gm-Gg: ASbGnctsvua5BGRtVIFq/SFtEuGg0icvHMNep/dRvXo6Gn4jOP9g++IZS7wxQJFH6C2
	lNt8quIR7wGbnXmLQYMxUTefG581wXyogeGtcKsyoibAjf0wTmucuEW5AC03Wr4wKCFpF7qQkFA
	y9e9Cmjg==
X-Google-Smtp-Source: AGHT+IEmzNz0icfWLpez1BUsW/bodw4yxi3kEJGu2T9c7GZ0fGiTA+k8NPv9fX34ISAbJbxPgbyIN7vFEs0p7/UvZxk=
X-Received: by 2002:a05:6a00:2445:b0:731:e974:f9c2 with SMTP id
 d2e1a72fcca58-73426af3a2dmr33707676b3a.0.1740618315744; Wed, 26 Feb 2025
 17:05:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250205-counter_delegation-v4-0-835cfa88e3b1@rivosinc.com>
 <20250205-counter_delegation-v4-12-835cfa88e3b1@rivosinc.com> <586dc43d-74cd-413b-86e2-545384ad796f@rivosinc.com>
In-Reply-To: <586dc43d-74cd-413b-86e2-545384ad796f@rivosinc.com>
From: Atish Kumar Patra <atishp@rivosinc.com>
Date: Wed, 26 Feb 2025 17:05:02 -0800
X-Gm-Features: AQ5f1Jpcwi9qlqm9BYyz76VdGTMqDksYTZy-kqauaAcNToAAh7JyG1DiMAREibo
Message-ID: <CAHBxVyGAtZV8mJdcLtSHKHCrtrx3ygUG16onhpPRUUPk6_WJuA@mail.gmail.com>
Subject: Re: [PATCH v4 12/21] RISC-V: perf: Modify the counter discovery mechanism
To: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, weilin.wang@intel.com, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Conor Dooley <conor@kernel.org>, devicetree@vger.kernel.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
	linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 7, 2025 at 2:29=E2=80=AFAM Cl=C3=A9ment L=C3=A9ger <cleger@rivo=
sinc.com> wrote:
>
>
>
> On 06/02/2025 08:23, Atish Patra wrote:
> > If both counter delegation and SBI PMU is present, the counter
> > delegation will be used for hardware pmu counters while the SBI PMU
> > will be used for firmware counters. Thus, the driver has to probe
> > the counters info via SBI PMU to distinguish the firmware counters.
> >
> > The hybrid scheme also requires improvements of the informational
> > logging messages to indicate the user about underlying interface
> > used for each use case.
> >
> > Signed-off-by: Atish Patra <atishp@rivosinc.com>
> > ---
> >  drivers/perf/riscv_pmu_dev.c | 118 ++++++++++++++++++++++++++++++++---=
--------
> >  1 file changed, 88 insertions(+), 30 deletions(-)
> >
> > diff --git a/drivers/perf/riscv_pmu_dev.c b/drivers/perf/riscv_pmu_dev.=
c
> > index 6b43d844eaea..5ddf4924c5b3 100644
> > --- a/drivers/perf/riscv_pmu_dev.c
> > +++ b/drivers/perf/riscv_pmu_dev.c
> > @@ -66,6 +66,10 @@ static bool sbi_v2_available;
> >  static DEFINE_STATIC_KEY_FALSE(sbi_pmu_snapshot_available);
> >  #define sbi_pmu_snapshot_available() \
> >       static_branch_unlikely(&sbi_pmu_snapshot_available)
> > +static DEFINE_STATIC_KEY_FALSE(riscv_pmu_sbi_available);
> > +static DEFINE_STATIC_KEY_FALSE(riscv_pmu_cdeleg_available);
> > +static bool cdeleg_available;
> > +static bool sbi_available;
> >
> >  static struct attribute *riscv_arch_formats_attr[] =3D {
> >       &format_attr_event.attr,
> > @@ -88,7 +92,8 @@ static int sysctl_perf_user_access __read_mostly =3D =
SYSCTL_USER_ACCESS;
> >
> >  /*
> >   * This structure is SBI specific but counter delegation also require =
counter
> > - * width, csr mapping. Reuse it for now.
> > + * width, csr mapping. Reuse it for now we can have firmware counters =
for
> > + * platfroms with counter delegation support.
> >   * RISC-V doesn't have heterogeneous harts yet. This need to be part o=
f
> >   * per_cpu in case of harts with different pmu counters
> >   */
> > @@ -100,6 +105,8 @@ static unsigned int riscv_pmu_irq;
> >
> >  /* Cache the available counters in a bitmask */
> >  static unsigned long cmask;
> > +/* Cache the available firmware counters in another bitmask */
> > +static unsigned long firmware_cmask;
> >
> >  struct sbi_pmu_event_data {
> >       union {
> > @@ -778,35 +785,49 @@ static int rvpmu_sbi_find_num_ctrs(void)
> >               return sbi_err_map_linux_errno(ret.error);
> >  }
> >
> > -static int rvpmu_sbi_get_ctrinfo(int nctr, unsigned long *mask)
> > +static int rvpmu_deleg_find_ctrs(void)
> > +{
> > +     /* TODO */
> > +     return -1;
> > +}
> > +
> > +static int rvpmu_sbi_get_ctrinfo(int nsbi_ctr, int ndeleg_ctr)
>
> Hi Atish,
>
> These parameters could be unsigned I think.
>

sure. Changed it to u32.

> >  {
> >       struct sbiret ret;
> > -     int i, num_hw_ctr =3D 0, num_fw_ctr =3D 0;
> > +     int i, num_hw_ctr =3D 0, num_fw_ctr =3D 0, num_ctr =3D 0;
> >       union sbi_pmu_ctr_info cinfo;
> >
> > -     pmu_ctr_list =3D kcalloc(nctr, sizeof(*pmu_ctr_list), GFP_KERNEL)=
;
> > -     if (!pmu_ctr_list)
> > -             return -ENOMEM;
> > -
> > -     for (i =3D 0; i < nctr; i++) {
> > +     for (i =3D 0; i < nsbi_ctr; i++) {
> >               ret =3D sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_GET_IN=
FO, i, 0, 0, 0, 0, 0);
> >               if (ret.error)
> >                       /* The logical counter ids are not expected to be=
 contiguous */
> >                       continue;
> >
> > -             *mask |=3D BIT(i);
> > -
> >               cinfo.value =3D ret.value;
> >               if (cinfo.type =3D=3D SBI_PMU_CTR_TYPE_FW)
> >                       num_fw_ctr++;
> > -             else
> > +
> > +             if (!cdeleg_available) {
>
> What is the rationale for using additional boolean identical to the
> static keys ? Reducing the amount of code patch site in cold path ? If

yes.

> so, I guess you can use static_key_enabled(&riscv_pmu_cdeleg_available).
> But your solution is fine as well, it just duplicates two identical value=
s.
>

good point. I will change it. Thanks!

> >                       num_hw_ctr++;
> > -             pmu_ctr_list[i].value =3D cinfo.value;
> > +                     cmask |=3D BIT(i);
> > +                     pmu_ctr_list[i].value =3D cinfo.value;
> > +             } else if (cinfo.type =3D=3D SBI_PMU_CTR_TYPE_FW) {
> > +                     /* Track firmware counters in a different mask */
> > +                     firmware_cmask |=3D BIT(i);
> > +                     pmu_ctr_list[i].value =3D cinfo.value;
> > +             }
> > +
> >       }
> >
> > -     pr_info("%d firmware and %d hardware counters\n", num_fw_ctr, num=
_hw_ctr);
> > +     if (cdeleg_available) {
> > +             pr_info("%d firmware and %d hardware counters\n", num_fw_=
ctr, ndeleg_ctr);
> > +             num_ctr =3D num_fw_ctr + ndeleg_ctr;
> > +     } else {
> > +             pr_info("%d firmware and %d hardware counters\n", num_fw_=
ctr, num_hw_ctr);
> > +             num_ctr =3D nsbi_ctr;
> > +     }
> >
> > -     return 0;
> > +     return num_ctr;
> >  }
> >
> >  static inline void rvpmu_sbi_stop_all(struct riscv_pmu *pmu)
> > @@ -1067,16 +1088,33 @@ static void rvpmu_ctr_stop(struct perf_event *e=
vent, unsigned long flag)
> >       /* TODO: Counter delegation implementation */
> >  }
> >
> > -static int rvpmu_find_num_ctrs(void)
> > +static int rvpmu_find_ctrs(void)
> >  {
> > -     return rvpmu_sbi_find_num_ctrs();
> > -     /* TODO: Counter delegation implementation */
> > -}
> > +     int num_sbi_counters =3D 0, num_deleg_counters =3D 0, num_counter=
s =3D 0;
> >
> > -static int rvpmu_get_ctrinfo(int nctr, unsigned long *mask)
> > -{
> > -     return rvpmu_sbi_get_ctrinfo(nctr, mask);
> > -     /* TODO: Counter delegation implementation */
> > +     /*
> > +      * We don't know how many firmware counters available. Just alloc=
ate
> > +      * for maximum counters driver can support. The default is 64 any=
ways.
> > +      */
> > +     pmu_ctr_list =3D kcalloc(RISCV_MAX_COUNTERS, sizeof(*pmu_ctr_list=
),
> > +                            GFP_KERNEL);
> > +     if (!pmu_ctr_list)
> > +             return -ENOMEM;
> > +
> > +     if (cdeleg_available)
> > +             num_deleg_counters =3D rvpmu_deleg_find_ctrs();
> > +
> > +     /* This is required for firmware counters even if the above is tr=
ue */
> > +     if (sbi_available)
> > +             num_sbi_counters =3D rvpmu_sbi_find_num_ctrs();
> > +
> > +     if (num_sbi_counters >=3D RISCV_MAX_COUNTERS || num_deleg_counter=
s >=3D RISCV_MAX_COUNTERS)
> > +             return -ENOSPC;
>
> Why is this using '>=3D' ? You allocated space for RISCV_MAX_COUNTERS, so
> RISCV_MAX_COUNTERS should fit right ?
>
Yeah. That's a typo. Thanks for catching it.

> > +
> > +     /* cache all the information about counters now */
> > +     num_counters =3D rvpmu_sbi_get_ctrinfo(num_sbi_counters, num_dele=
g_counters);
> > +
> > +     return num_counters;
>
> return rvpmu_sbi_get_ctrinfo(num_sbi_counters, num_deleg_counters);
>
> >  }
> >
> >  static int rvpmu_event_map(struct perf_event *event, u64 *econfig)
> > @@ -1377,12 +1415,21 @@ static int rvpmu_device_probe(struct platform_d=
evice *pdev)
> >       int ret =3D -ENODEV;
> >       int num_counters;
> >
> > -     pr_info("SBI PMU extension is available\n");
> > +     if (cdeleg_available) {
> > +             pr_info("hpmcounters will use the counter delegation ISA =
extension\n");
> > +             if (sbi_available)
> > +                     pr_info("Firmware counters will be use SBI PMU ex=
tension\n");
>
> s/will be use/will use
>
> > +             else
> > +                     pr_info("Firmware counters will be not available =
as SBI PMU extension is not present\n");
>
> s/will be not/will not
>

Fixed.

> > +     } else if (sbi_available) {
> > +             pr_info("Both hpmcounters and firmware counters will use =
SBI PMU extension\n");
> > +     }
> > +
> >       pmu =3D riscv_pmu_alloc();
> >       if (!pmu)
> >               return -ENOMEM;
> >
> > -     num_counters =3D rvpmu_find_num_ctrs();
> > +     num_counters =3D rvpmu_find_ctrs();
> >       if (num_counters < 0) {
> >               pr_err("SBI PMU extension doesn't provide any counters\n"=
);
> >               goto out_free;
> > @@ -1394,9 +1441,6 @@ static int rvpmu_device_probe(struct platform_dev=
ice *pdev)
> >               pr_info("SBI returned more than maximum number of counter=
s. Limiting the number of counters to %d\n", num_counters);
> >       }
> >
> > -     /* cache all the information about counters now */
> > -     if (rvpmu_get_ctrinfo(num_counters, &cmask))
> > -             goto out_free;
> >
> >       ret =3D rvpmu_setup_irqs(pmu, pdev);
> >       if (ret < 0) {
> > @@ -1486,13 +1530,27 @@ static int __init rvpmu_devinit(void)
> >       int ret;
> >       struct platform_device *pdev;
> >
> > -     if (sbi_spec_version < sbi_mk_version(0, 3) ||
> > -         !sbi_probe_extension(SBI_EXT_PMU)) {
> > -             return 0;
> > +     if (sbi_spec_version >=3D sbi_mk_version(0, 3) &&
> > +         sbi_probe_extension(SBI_EXT_PMU)) {
> > +             static_branch_enable(&riscv_pmu_sbi_available);
> > +             sbi_available =3D true;
> >       }
> >
> >       if (sbi_spec_version >=3D sbi_mk_version(2, 0))
> >               sbi_v2_available =3D true;
> > +     /*
> > +      * We need all three extensions to be present to access the count=
ers
> > +      * in S-mode via Supervisor Counter delegation.
> > +      */
> > +     if (riscv_isa_extension_available(NULL, SSCCFG) &&
> > +         riscv_isa_extension_available(NULL, SMCDELEG) &&
> > +         riscv_isa_extension_available(NULL, SSCSRIND)) {
> > +             static_branch_enable(&riscv_pmu_cdeleg_available);
> > +             cdeleg_available =3D true;
> > +     }
> > +
> > +     if (!(sbi_available || cdeleg_available))
> > +             return 0;
> >
> >       ret =3D cpuhp_setup_state_multi(CPUHP_AP_PERF_RISCV_STARTING,
> >                                     "perf/riscv/pmu:starting",
> >
>

