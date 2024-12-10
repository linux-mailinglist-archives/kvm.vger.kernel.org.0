Return-Path: <kvm+bounces-33369-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BF499EA428
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 02:17:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6C1E0164023
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 01:17:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46C3C7083F;
	Tue, 10 Dec 2024 01:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="qO+huy68"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A3602AD16
	for <kvm@vger.kernel.org>; Tue, 10 Dec 2024 01:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733793417; cv=none; b=AwFhLE/srDD6I+UnhRlpjG9UwAWs59Ak4JBbZgTklIwHP6HTxtXvCD8yJsRor+421+dxmxYGIzDCb64Kox8+imWEOpKwmrooJl4wHTZtkh7i89pjTvrJVqOifNAphoOycdN1/ny5eEdkypa6ZRHmzsQH0AP9s7umlQ4hTdPWtRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733793417; c=relaxed/simple;
	bh=xe55CIvx9ga5Wlbj8l+zBcpHsp0iebXqFs2lCVyrqGA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=teTcZX2Ei662v+Mj4h1kmcmVZMvhAYxg+gx/01SZ5g1tVI3+k277QOwgfQBoJBij1smQGd10V2Jg4+Acv5zFqPLjjmlYn0iOOqlbF8SD2IlfgzTVtyJtHseS1VnE75BHHxO/crlnIDGfIzPjyMxgnSygR8XqkNrDHc2In+5I6dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=qO+huy68; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-725aa5c597cso3708193b3a.1
        for <kvm@vger.kernel.org>; Mon, 09 Dec 2024 17:16:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1733793414; x=1734398214; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l5lnOzUj92tNwAYe96qZDcz3FYlyRcurTdW3wXkywCY=;
        b=qO+huy68wkoAh1hNuTPHmqglcowQjr0C2Ejf+m9AaOT7sbMlSkrwu+lTUEAKPSQkud
         CnxCcKPWWp9uzwFh80XM20SuIWB2G/LOK3l76AED2BCqGQOXDhvxOoGKt4cYRUZUw0lh
         xasEIhqIOoaIjA3+U6wrMdP7HY56eoRbL9LD5UidL93SOxaGPTHUgs7b1q6ZFC6H7dFN
         mMfBR440EWNKEYfzD2Aav+sADQmm9c8hwTepM/kyUKuhUBqk3UU5LUsnQGbB5zD0R4bl
         fSbuCNIuAmu2j/+sYg27fFcI4w1Q8Ikhp4MYPtyeMiFibTEeB3vtz7wG00K22oS2E72S
         Dx1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733793414; x=1734398214;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l5lnOzUj92tNwAYe96qZDcz3FYlyRcurTdW3wXkywCY=;
        b=xK8S9wnKu6bHDRUcX9VVTQFZhnxYvkliQwXvOgpNL1icwbHfn5KH+VyBl8VmG8s3fZ
         rlLNjmdPQO6TSspvDgnVcnuaCvPnPFQgii4UyrejO3mKHwMix7yNq8RwNgEQrGqkwsVe
         yMQZisqeZPiQG045VrgtDWOSYJhhuDUty0olfupkZZj7wNvdrLcrwY0X0nIuDbTvp3ZJ
         W2Q0Y/JbjfikkeZTcPxV6S4PeBJP5VSX6t4VBwqhF15gCMyvv9pxF8I6sx/ltVtviDUL
         LGvm8iz2n0ntozcRgRxqpI4V6OPv1oixFrmjKtrCU9jOpFbL41cTTzKumGnThy55LPYm
         Sm8A==
X-Forwarded-Encrypted: i=1; AJvYcCWGOW/BOlQgpTFm/q6tslfDkUck9YZzCpGhRTiL95HjjJWQrEBiWoGctfkoSS37OWXovaE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzbf4CSG+sZ0nvnWUYDZNjC8E7Qhu5TS8KXM6DRd/H44GXjDiWw
	qb6Yl7/Vuu9WdyZzXdnD4i6FaeHV5F2ZPOvDhf5fnlORFBhgtvUqZCHf+Er+HW5vCst5dnadjnW
	pqO4Ew0xUKGzA7K97PD0OAgqvGmpUkj/0AsV61w==
X-Gm-Gg: ASbGncvE7dwHR8igzxUH3sMVk0l3XBVrdIRVIH3ks1lD2YavO2E3fldNDITjbhU+Awp
	nKwfxr7AWMkecILsdWCfB5ssiw7XLFduunA==
X-Google-Smtp-Source: AGHT+IHNDxzVFx4Fjry46BXz1MibF2flAze+KQwgSpC0yKWv1F2kvwsfIv8wF0CgYV8avF+Sj0p+siSkN66OmJVbtO0=
X-Received: by 2002:a05:6a00:174b:b0:725:e37d:cd36 with SMTP id
 d2e1a72fcca58-7273c8f4a8bmr3915070b3a.2.1733793413778; Mon, 09 Dec 2024
 17:16:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241119-pmu_event_info-v1-0-a4f9691421f8@rivosinc.com>
 <20241119-pmu_event_info-v1-5-a4f9691421f8@rivosinc.com> <0a4a569e-dfab-4aed-90df-2fe9719a3803@sifive.com>
In-Reply-To: <0a4a569e-dfab-4aed-90df-2fe9719a3803@sifive.com>
From: Atish Kumar Patra <atishp@rivosinc.com>
Date: Mon, 9 Dec 2024 17:16:43 -0800
Message-ID: <CAHBxVyGSxMVm5QO9TmSy6MBVtc6zX0ju6n2+PK-RXuX5=KLLjA@mail.gmail.com>
Subject: Re: [PATCH 5/8] drivers/perf: riscv: Implement PMU event info function
To: Samuel Holland <samuel.holland@sifive.com>
Cc: linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Palmer Dabbelt <palmer@rivosinc.com>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, Anup Patel <anup@brainfault.org>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Mayuresh Chitale <mchitale@ventanamicro.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 2, 2024 at 2:49=E2=80=AFPM Samuel Holland <samuel.holland@sifiv=
e.com> wrote:
>
> Hi Atish,
>
> On 2024-11-19 2:29 PM, Atish Patra wrote:
> > With the new SBI PMU event info function, we can query the availability
> > of the all standard SBI PMU events at boot time with a single ecall.
> > This improves the bootime by avoiding making an SBI call for each
> > standard PMU event. Since this function is defined only in SBI v3.0,
> > invoke this only if the underlying SBI implementation is v3.0 or higher=
.
> >
> > Signed-off-by: Atish Patra <atishp@rivosinc.com>
> > ---
> >  arch/riscv/include/asm/sbi.h |  7 +++++
> >  drivers/perf/riscv_pmu_sbi.c | 71 ++++++++++++++++++++++++++++++++++++=
++++++++
> >  2 files changed, 78 insertions(+)
> >
> > diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.=
h
> > index 3ee9bfa5e77c..c04f64fbc01d 100644
> > --- a/arch/riscv/include/asm/sbi.h
> > +++ b/arch/riscv/include/asm/sbi.h
> > @@ -134,6 +134,7 @@ enum sbi_ext_pmu_fid {
> >       SBI_EXT_PMU_COUNTER_FW_READ,
> >       SBI_EXT_PMU_COUNTER_FW_READ_HI,
> >       SBI_EXT_PMU_SNAPSHOT_SET_SHMEM,
> > +     SBI_EXT_PMU_EVENT_GET_INFO,
> >  };
> >
> >  union sbi_pmu_ctr_info {
> > @@ -157,6 +158,12 @@ struct riscv_pmu_snapshot_data {
> >       u64 reserved[447];
> >  };
> >
> > +struct riscv_pmu_event_info {
> > +     u32 event_idx;
> > +     u32 output;
> > +     u64 event_data;
> > +};
> > +
> >  #define RISCV_PMU_RAW_EVENT_MASK GENMASK_ULL(47, 0)
> >  #define RISCV_PMU_PLAT_FW_EVENT_MASK GENMASK_ULL(61, 0)
> >  /* SBI v3.0 allows extended hpmeventX width value */
> > diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sbi.=
c
> > index f0e845ff6b79..2a6527cc9d97 100644
> > --- a/drivers/perf/riscv_pmu_sbi.c
> > +++ b/drivers/perf/riscv_pmu_sbi.c
> > @@ -100,6 +100,7 @@ static unsigned int riscv_pmu_irq;
> >  /* Cache the available counters in a bitmask */
> >  static unsigned long cmask;
> >
> > +static int pmu_event_find_cache(u64 config);
>
> This new declaration does not appear to be used.
>

This is a forward declaration as  pmu_event_find_cache but it should
be in the next patch instead of this patch.
I have moved it to that patch.

> >  struct sbi_pmu_event_data {
> >       union {
> >               union {
> > @@ -299,6 +300,68 @@ static struct sbi_pmu_event_data pmu_cache_event_m=
ap[PERF_COUNT_HW_CACHE_MAX]
> >       },
> >  };
> >
> > +static int pmu_sbi_check_event_info(void)
> > +{
> > +     int num_events =3D ARRAY_SIZE(pmu_hw_event_map) + PERF_COUNT_HW_C=
ACHE_MAX *
> > +                      PERF_COUNT_HW_CACHE_OP_MAX * PERF_COUNT_HW_CACHE=
_RESULT_MAX;
> > +     struct riscv_pmu_event_info *event_info_shmem;
> > +     phys_addr_t base_addr;
> > +     int i, j, k, result =3D 0, count =3D 0;
> > +     struct sbiret ret;
> > +
> > +     event_info_shmem =3D (struct riscv_pmu_event_info *)
> > +                        kcalloc(num_events, sizeof(*event_info_shmem),=
 GFP_KERNEL);
>
> Please drop the unnecessary cast.
>

Done.

> > +     if (!event_info_shmem) {
> > +             pr_err("Can not allocate memory for event info query\n");
>
> Usually there's no need to print an error for allocation failure, since t=
he
> allocator already warns. And this isn't really an error, since we can (an=
d do)
> fall back to the existing way of checking for events.
>

Fixed.

> > +             return -ENOMEM;
> > +     }
> > +
> > +     for (i =3D 0; i < ARRAY_SIZE(pmu_hw_event_map); i++)
> > +             event_info_shmem[count++].event_idx =3D pmu_hw_event_map[=
i].event_idx;
> > +
> > +     for (i =3D 0; i < ARRAY_SIZE(pmu_cache_event_map); i++) {
> > +             for (int j =3D 0; j < ARRAY_SIZE(pmu_cache_event_map[i]);=
 j++) {
> > +                     for (int k =3D 0; k < ARRAY_SIZE(pmu_cache_event_=
map[i][j]); k++)
> > +                             event_info_shmem[count++].event_idx =3D
> > +                                                     pmu_cache_event_m=
ap[i][j][k].event_idx;
> > +             }
> > +     }
> > +
> > +     base_addr =3D __pa(event_info_shmem);
> > +     if (IS_ENABLED(CONFIG_32BIT))
> > +             ret =3D sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_EVENT_GET_INFO=
, lower_32_bits(base_addr),
> > +                             upper_32_bits(base_addr), count, 0, 0, 0)=
;
> > +     else
> > +             ret =3D sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_EVENT_GET_INFO=
, base_addr, 0,
> > +                             count, 0, 0, 0);
> > +     if (ret.error) {
> > +             result =3D -EOPNOTSUPP;
> > +             goto free_mem;
> > +     }
> > +     /* Do we need some barriers here or priv mode transition will ens=
ure that */
>
> No barrier is needed -- the SBI implementation is running on the same har=
t, so
> coherency isn't even a consideration.
>
> > +     for (i =3D 0; i < ARRAY_SIZE(pmu_hw_event_map); i++) {
> > +             if (!(event_info_shmem[i].output & 0x01))
>
> This bit mask should probably use a macro.
>
> > +                     pmu_hw_event_map[i].event_idx =3D -ENOENT;
> > +     }
> > +
> > +     count =3D ARRAY_SIZE(pmu_hw_event_map);
> > +
> > +     for (i =3D 0; i < ARRAY_SIZE(pmu_cache_event_map); i++) {
> > +             for (j =3D 0; j < ARRAY_SIZE(pmu_cache_event_map[i]); j++=
) {
> > +                     for (k =3D 0; k < ARRAY_SIZE(pmu_cache_event_map[=
i][j]); k++) {
> > +                             if (!(event_info_shmem[count].output & 0x=
01))
>
> Same comment applies here.
>

Done.


> Regards,
> Samuel
>
> > +                                     pmu_cache_event_map[i][j][k].even=
t_idx =3D -ENOENT;
> > +                             count++;
> > +                     }
> > +             }
> > +     }
> > +
> > +free_mem:
> > +     kfree(event_info_shmem);
> > +
> > +     return result;
> > +}
> > +
> >  static void pmu_sbi_check_event(struct sbi_pmu_event_data *edata)
> >  {
> >       struct sbiret ret;
> > @@ -316,6 +379,14 @@ static void pmu_sbi_check_event(struct sbi_pmu_eve=
nt_data *edata)
> >
> >  static void pmu_sbi_check_std_events(struct work_struct *work)
> >  {
> > +     int ret;
> > +
> > +     if (sbi_v3_available) {
> > +             ret =3D pmu_sbi_check_event_info();
> > +             if (!ret)
> > +                     return;
> > +     }
> > +
> >       for (int i =3D 0; i < ARRAY_SIZE(pmu_hw_event_map); i++)
> >               pmu_sbi_check_event(&pmu_hw_event_map[i]);
> >
> >
>

