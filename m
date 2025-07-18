Return-Path: <kvm+bounces-52846-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 516B4B09A83
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 06:33:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DB885A46369
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 04:32:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A19F1DE4FF;
	Fri, 18 Jul 2025 04:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="L+xp+dSo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CC9517CA17
	for <kvm@vger.kernel.org>; Fri, 18 Jul 2025 04:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752813188; cv=none; b=oRDS5Fl0aYBFA/ER/JlKS5IMEJscYkpSJD71wbLFljXMZT8jAmn6cnkoqEqdjH3HLrRiJQTXfwf11uRGVClMn8NoPxZNvUwxc2w4pa62cNmJt3G8XahaONF5eTuVR7jc1Dax39FKwCK0PL03fOAIVk76ybJvfGRfSjYAm2SL/eA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752813188; c=relaxed/simple;
	bh=HmCuJ5yuguYahLvUWMJi9g3SQ94gXfbq68cY8XiIDrA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LR9hSyOxXGm9fn1LUB/KC15TntuFZlQdNubB7CejRxYWe7RUMi8yKWyUCzPn3SjukLIRvvni6GBEagI1EQ6KtjG/QhWVh1JULMUaP8ZQztDCxVF2jB3eSn1gy4uZ0xx+yoYCM0G+6VwehkOy5JEw5WWWKHGEA0ms36WTWA4Bc3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=L+xp+dSo; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-87999c368e9so163045739f.0
        for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 21:33:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1752813185; x=1753417985; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9BchHT2JqinVts/UeZMPzWB77o6GrLS5pyW1xcQuRic=;
        b=L+xp+dSow5D+E5pz5m0wD+nHE4zjC4opUfDZOnec1o1tV5o/RfxvntS8BcbpM6s1eq
         zUBMv5F8oHO8jE4lC95KDesJV1fe3Z3dNmQGjoHpESyQq2L/n/R0LkaZtCssg52D2R5M
         KQZQGs/xenE2pdTbYCLPECy4PL3xO5lID337n0XqgplOqcyBpz3Sa6/W0g1SfeRUSV4t
         OPQNxBVPRT6hfvvKuUTigR72mxx+hhy3WxJPPZEOc1AuO+hU17DS9dkvYaTeD7Gec1tz
         G8aql5gP67F/VE4rQedRcnU0HWm+4PbhKxx53ymbI5YCr2TWERE+KBXCOwq58BpJOwZ9
         trCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752813185; x=1753417985;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9BchHT2JqinVts/UeZMPzWB77o6GrLS5pyW1xcQuRic=;
        b=sGOZQhsr+XHowFPDVtvItGvlfAqSvj3eU/+Tl0WSEsuO/21S501k2tv32EAXyAaWRM
         LE6LHkRz5oIlZHK5170zrlE5QxUg6vk1PMqV3Ru3NK60YiT4i7nVqltU9F6yc8ZCRS+x
         OakR0orsy8rH0v6kztpL5d5ikAy8GaMPtbT9m7ob53OYv3qfQVhdjbhtdlEoaY+NPrLA
         10YHWgJq0Tc2MUsA45GgMCkDNwhiaMs4L1ikJvJYY/7NNpHCo7O3J4LqPntHOxN07EC+
         fBBSFMjvdPxddiyukOR9Zzjk/gqrSuhxUrVR2+JJRX/Fb1JjBecD0/sxlSuDfHcYn6mf
         16YA==
X-Forwarded-Encrypted: i=1; AJvYcCU9CW/2pN7d3o2ne5mzoErLkx0aNTkR1u8eiiXjhk2vC/DHjO8Y07n5c65A1V4Ruom6sZU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzk5IOMxt7B1MlhLwOe/VEI3PynkJ8BNaRvaQ+fg4Y6eiFWcOl7
	gwkdhiXtCOM+WKnYwP05FMJuQr3PUcdDPHkHlojJ8jQ0vIxtULAgn70KZ5vxxPJILbshWl2FPpH
	3ieSRtWv5Wp7S5d8qJaqH3EvALMyP5OYS1D/Nz8Y9DQ==
X-Gm-Gg: ASbGncsOTiMTd1QtTbF6XwfOx0bKPennqAv3x+tQQ+4QybDz8ExfjPBnFaV87tN58Yz
	ZZ9I0dv930hjLsn5DSyXNMS0I93nUyRuntyz1+SxVqwia/5GV2jg2s0wmO2dshsAcSn3tRshfLa
	jHyIKKqWQILhIJNnltuQTgNJa2mwxa9IVu3I4IFivpszrsoc/Jx9vksmRLiHvLvB2WRBkorwkUc
	jZ/qUmS
X-Google-Smtp-Source: AGHT+IGxLSLfJEWbT94QQ9wDEPcHHk7UU5oQFPXNoEg2dmlbQDZqZkULuKjbXMOnhCheEHP/8Vs0hjk7tTvXdvuroqU=
X-Received: by 2002:a05:6e02:1488:b0:3e2:8172:25e3 with SMTP id
 e9e14a558f8ab-3e282e3961cmr83450795ab.14.1752813185443; Thu, 17 Jul 2025
 21:33:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250522-pmu_event_info-v3-0-f7bba7fd9cfe@rivosinc.com> <20250522-pmu_event_info-v3-4-f7bba7fd9cfe@rivosinc.com>
In-Reply-To: <20250522-pmu_event_info-v3-4-f7bba7fd9cfe@rivosinc.com>
From: Anup Patel <anup@brainfault.org>
Date: Fri, 18 Jul 2025 10:02:53 +0530
X-Gm-Features: Ac12FXz8CojGLXC08fo8TuectN9PJto19GIlEKkPXZw46d0UC0i4fpJCDCQw5Dc
Message-ID: <CAAhSdy1RyJyjus_SUOw7GUZsQLr5SFV4TZ9d7K1OEKDR27TaWQ@mail.gmail.com>
Subject: Re: [PATCH v3 4/9] drivers/perf: riscv: Implement PMU event info function
To: Atish Patra <atishp@rivosinc.com>
Cc: Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Mayuresh Chitale <mchitale@ventanamicro.com>, linux-riscv@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Palmer Dabbelt <palmer@rivosinc.com>, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 23, 2025 at 12:33=E2=80=AFAM Atish Patra <atishp@rivosinc.com> =
wrote:
>
> With the new SBI PMU event info function, we can query the availability
> of the all standard SBI PMU events at boot time with a single ecall.
> This improves the bootime by avoiding making an SBI call for each
> standard PMU event. Since this function is defined only in SBI v3.0,
> invoke this only if the underlying SBI implementation is v3.0 or higher.
>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  arch/riscv/include/asm/sbi.h |  9 ++++++
>  drivers/perf/riscv_pmu_sbi.c | 68 ++++++++++++++++++++++++++++++++++++++=
++++++
>  2 files changed, 77 insertions(+)
>
> diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.h
> index 6ce385a3a7bb..77b6997eb6c5 100644
> --- a/arch/riscv/include/asm/sbi.h
> +++ b/arch/riscv/include/asm/sbi.h
> @@ -135,6 +135,7 @@ enum sbi_ext_pmu_fid {
>         SBI_EXT_PMU_COUNTER_FW_READ,
>         SBI_EXT_PMU_COUNTER_FW_READ_HI,
>         SBI_EXT_PMU_SNAPSHOT_SET_SHMEM,
> +       SBI_EXT_PMU_EVENT_GET_INFO,
>  };
>
>  union sbi_pmu_ctr_info {
> @@ -158,6 +159,14 @@ struct riscv_pmu_snapshot_data {
>         u64 reserved[447];
>  };
>
> +struct riscv_pmu_event_info {
> +       u32 event_idx;
> +       u32 output;
> +       u64 event_data;
> +};
> +
> +#define RISCV_PMU_EVENT_INFO_OUTPUT_MASK 0x01
> +
>  #define RISCV_PMU_RAW_EVENT_MASK GENMASK_ULL(47, 0)
>  #define RISCV_PMU_PLAT_FW_EVENT_MASK GENMASK_ULL(61, 0)
>  /* SBI v3.0 allows extended hpmeventX width value */
> diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sbi.c
> index 273ed70098a3..33d8348bf68a 100644
> --- a/drivers/perf/riscv_pmu_sbi.c
> +++ b/drivers/perf/riscv_pmu_sbi.c
> @@ -299,6 +299,66 @@ static struct sbi_pmu_event_data pmu_cache_event_map=
[PERF_COUNT_HW_CACHE_MAX]
>         },
>  };
>
> +static int pmu_sbi_check_event_info(void)
> +{
> +       int num_events =3D ARRAY_SIZE(pmu_hw_event_map) + PERF_COUNT_HW_C=
ACHE_MAX *
> +                        PERF_COUNT_HW_CACHE_OP_MAX * PERF_COUNT_HW_CACHE=
_RESULT_MAX;
> +       struct riscv_pmu_event_info *event_info_shmem;
> +       phys_addr_t base_addr;
> +       int i, j, k, result =3D 0, count =3D 0;
> +       struct sbiret ret;
> +
> +       event_info_shmem =3D kcalloc(num_events, sizeof(*event_info_shmem=
), GFP_KERNEL);
> +       if (!event_info_shmem)
> +               return -ENOMEM;
> +
> +       for (i =3D 0; i < ARRAY_SIZE(pmu_hw_event_map); i++)
> +               event_info_shmem[count++].event_idx =3D pmu_hw_event_map[=
i].event_idx;
> +
> +       for (i =3D 0; i < ARRAY_SIZE(pmu_cache_event_map); i++) {
> +               for (j =3D 0; j < ARRAY_SIZE(pmu_cache_event_map[i]); j++=
) {
> +                       for (k =3D 0; k < ARRAY_SIZE(pmu_cache_event_map[=
i][j]); k++)
> +                               event_info_shmem[count++].event_idx =3D
> +                                                       pmu_cache_event_m=
ap[i][j][k].event_idx;
> +               }
> +       }
> +
> +       base_addr =3D __pa(event_info_shmem);
> +       if (IS_ENABLED(CONFIG_32BIT))
> +               ret =3D sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_EVENT_GET_INFO=
, lower_32_bits(base_addr),
> +                               upper_32_bits(base_addr), count, 0, 0, 0)=
;
> +       else
> +               ret =3D sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_EVENT_GET_INFO=
, base_addr, 0,
> +                               count, 0, 0, 0);
> +       if (ret.error) {
> +               result =3D -EOPNOTSUPP;
> +               goto free_mem;
> +       }
> +
> +       for (i =3D 0; i < ARRAY_SIZE(pmu_hw_event_map); i++) {
> +               if (!(event_info_shmem[i].output & RISCV_PMU_EVENT_INFO_O=
UTPUT_MASK))
> +                       pmu_hw_event_map[i].event_idx =3D -ENOENT;
> +       }
> +
> +       count =3D ARRAY_SIZE(pmu_hw_event_map);
> +
> +       for (i =3D 0; i < ARRAY_SIZE(pmu_cache_event_map); i++) {
> +               for (j =3D 0; j < ARRAY_SIZE(pmu_cache_event_map[i]); j++=
) {
> +                       for (k =3D 0; k < ARRAY_SIZE(pmu_cache_event_map[=
i][j]); k++) {
> +                               if (!(event_info_shmem[count].output &
> +                                     RISCV_PMU_EVENT_INFO_OUTPUT_MASK))
> +                                       pmu_cache_event_map[i][j][k].even=
t_idx =3D -ENOENT;
> +                               count++;
> +                       }
> +               }
> +       }
> +
> +free_mem:
> +       kfree(event_info_shmem);
> +
> +       return result;
> +}
> +
>  static void pmu_sbi_check_event(struct sbi_pmu_event_data *edata)
>  {
>         struct sbiret ret;
> @@ -316,6 +376,14 @@ static void pmu_sbi_check_event(struct sbi_pmu_event=
_data *edata)
>
>  static void pmu_sbi_check_std_events(struct work_struct *work)
>  {
> +       int ret;
> +
> +       if (sbi_v3_available) {
> +               ret =3D pmu_sbi_check_event_info();
> +               if (!ret)
> +                       return;

We should not fall back to the old way if ret !=3D 0. Rather,
the pmu_sbi_check_std_events() should return failure if
pmu_sbi_check_event_info() fails.

> +       }
> +
>         for (int i =3D 0; i < ARRAY_SIZE(pmu_hw_event_map); i++)
>                 pmu_sbi_check_event(&pmu_hw_event_map[i]);
>
>
> --
> 2.43.0
>

Regards,
Anup

