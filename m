Return-Path: <kvm+bounces-52848-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C835EB09A97
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 06:39:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A307C1896564
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 04:40:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B472C1DE2AD;
	Fri, 18 Jul 2025 04:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="guBiItDF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5892617CA17
	for <kvm@vger.kernel.org>; Fri, 18 Jul 2025 04:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752813588; cv=none; b=lFkWrW02lcdzkPULF4vBPp6pK5w++yCVnqMdlka5UbH06d7/jW9e6EUkbu8AjPs69/e/82x4nz/LwlCLKwtE5Ps2YmK+YD7UDpgVDVVAobnntLG/gl69RXeWQ/oz76QNoc4oZTUv/XzGU7glEzoYYV+n+4Ft2yOEJ9bCzwo39VY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752813588; c=relaxed/simple;
	bh=YsKmpzxRJB1Wb3zOWYhYhKFe6FWC24kFEP48EfJYMt0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Zs7wyLLuK8416ZYbqMGo8rUdT6bSkDfCLO0bulvkbZwdDRI3MlLOfHMX7vt2SbAozTW1aQ4AUyilPJt5SQRDCg+9FYosjrpLu9z3OiBO6nLFE7dGnyY7JxKicPO3kb71E1dIk55Djgir7YVv06+VTo3kIYvNJWH5RSCvDpW4m0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=guBiItDF; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-87c124eb056so11503239f.2
        for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 21:39:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1752813586; x=1753418386; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lmjhOSDCIU1wo/Cj0YflFKr4yJ8Ipsknqxo6fdZydpc=;
        b=guBiItDF99B00Pk80OZoFXRRGEEogqxTI7/nfVu4uqbI9277emRWKRF8AnBaBm1UGv
         qjmc3XwVqFuEgLoLcDV2csDOdmA3rb95o3DePMqH34AXvQZLGOR6kWrb8wNRw6zEQUkD
         SV/7MRWOeRX/HFBgCAJYo1LF0rGYwTvWBKNElkCSG7UGSIctWWuNtwM7l7w8P/5oPNst
         4MC2ByyhkkwoX7S8q8ajfyXq8v+NMqmOZ+lqdPLTw9Jx/vOznAkT12nUuHtjtIKpFCOj
         3kxxMtErpvP7Q9GEPZDBd5K3PF+RvbMJphGpIqSazBe2JkZ8U7ko6nIADH4V3frrPJbo
         8w2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752813586; x=1753418386;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lmjhOSDCIU1wo/Cj0YflFKr4yJ8Ipsknqxo6fdZydpc=;
        b=PbC6EfSS70sXxozHNO3woA8iRrsFU8Z5B91mQfbnClHrtBuZc8EOWgyWlfMtp2YZGh
         qUWdm80RgRnp63NDlHN2w3QCA4lUJoUFNqhtyqRwJTosMGkU/a+7GcoZfjUdhwC0pxGc
         unOTBQzPHg/rD4WZlEfzojb+N0e3tXKDXgslQHs/AhUQfjlbpYUr17La4cYZ1cjayuBH
         l20zR7Oxq9hd9KkKfXREhVW4uPQVqLo7I7WTQ5HcyTkPQnUH+1rUr+Wc2hUG+uqx8aov
         A7a9zKdyqy/YBIs3ygAOq+rlR6I1I1ww9NkJt8CHbhQAQJVsPNATgI1UZMczhDRpqYh9
         Uj4g==
X-Forwarded-Encrypted: i=1; AJvYcCXIyM1HE10vs+Xr6ajyJtPzLJYazzpQZNkyRWss40SDLAIegEiXT4R1Oi72dBJJyx6BRa0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwVXGnTxYH0iOOB6aluy8/EhKJnNP/WnfzwWnZKcEWg1+4E1Vdz
	V+HFcYz3iXSmwrYENufPgydsAwDxQ2MKxUrnBB5euaebnYB93qak2BB4dOz49Xx9vCHnf3e2BWg
	uGsQkybzeyN7z2FEF1fnGF9X5QARmfJr8clbB8ce0pQ==
X-Gm-Gg: ASbGnct9HfzK8hS005CD+6SLgqWxHevjXhsb3NY8wakkZcXoeA4p83zMh68ihZBOBUy
	6VshkPTsJWZCPdnV2Lc7LvEHE1zyRzVaOpJG3FpR5vwyW3cUQJwEwJBMAMvlyrmOw6gGQ3CpJ5Y
	lL4oxm704+r1qcSFnJWdhcKvfwQvudK0b6ZHcFFouR0WFT13tAwHaGjqvGf1sDLUeGewO3YiWgZ
	ZnQRzog
X-Google-Smtp-Source: AGHT+IEzXZtRTpqZPP5g7x2Fm91kPpdZS5/X5V/55yjLcJ8BQVVYt3sRPxAm7hdiFuIt8kIDsDR0IpWsd9pUjol0rkY=
X-Received: by 2002:a05:6e02:3045:b0:3e0:4f66:310a with SMTP id
 e9e14a558f8ab-3e282e868cbmr102473895ab.16.1752813586416; Thu, 17 Jul 2025
 21:39:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250522-pmu_event_info-v3-0-f7bba7fd9cfe@rivosinc.com> <20250522-pmu_event_info-v3-5-f7bba7fd9cfe@rivosinc.com>
In-Reply-To: <20250522-pmu_event_info-v3-5-f7bba7fd9cfe@rivosinc.com>
From: Anup Patel <anup@brainfault.org>
Date: Fri, 18 Jul 2025 10:09:34 +0530
X-Gm-Features: Ac12FXz48gZhuRL6l_A_d2ML5HT5uyFhLTVui-Isq6ALvDwU7Ubg6PFae_bdCbw
Message-ID: <CAAhSdy1U02MDSGdMy+zCzdF4YENzvvKLnS+uszPpkH_nAPA9yw@mail.gmail.com>
Subject: Re: [PATCH v3 5/9] drivers/perf: riscv: Export PMU event info function
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
> The event mapping function can be used in event info function to find out
> the corresponding SBI PMU event encoding during the get_event_info functi=
on
> as well. Refactor and export it so that it can be invoked from kvm and
> internal driver.
>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  drivers/perf/riscv_pmu_sbi.c   | 124 ++++++++++++++++++++++-------------=
------
>  include/linux/perf/riscv_pmu.h |   2 +
>  2 files changed, 69 insertions(+), 57 deletions(-)
>
> diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sbi.c
> index 33d8348bf68a..f5d3db6dba18 100644
> --- a/drivers/perf/riscv_pmu_sbi.c
> +++ b/drivers/perf/riscv_pmu_sbi.c
> @@ -100,6 +100,7 @@ static unsigned int riscv_pmu_irq;
>  /* Cache the available counters in a bitmask */
>  static unsigned long cmask;
>
> +static int pmu_event_find_cache(u64 config);
>  struct sbi_pmu_event_data {
>         union {
>                 union {
> @@ -411,6 +412,71 @@ static bool pmu_sbi_ctr_is_fw(int cidx)
>         return (info->type =3D=3D SBI_PMU_CTR_TYPE_FW) ? true : false;
>  }
>
> +int riscv_pmu_get_event_info(u32 type, u64 config, u64 *econfig)
> +{
> +       int ret =3D -ENOENT;
> +
> +       switch (type) {
> +       case PERF_TYPE_HARDWARE:
> +               if (config >=3D PERF_COUNT_HW_MAX)
> +                       return -EINVAL;
> +               ret =3D pmu_hw_event_map[config].event_idx;
> +               break;
> +       case PERF_TYPE_HW_CACHE:
> +               ret =3D pmu_event_find_cache(config);
> +               break;
> +       case PERF_TYPE_RAW:
> +               /*
> +                * As per SBI v0.3 specification,
> +                *  -- the upper 16 bits must be unused for a hardware ra=
w event.
> +                * As per SBI v3.0 specification,
> +                *  -- the upper 8 bits must be unused for a hardware raw=
 event.
> +                * Bits 63:62 are used to distinguish between raw events
> +                * 00 - Hardware raw event
> +                * 10 - SBI firmware events
> +                * 11 - Risc-V platform specific firmware event
> +                */
> +               switch (config >> 62) {
> +               case 0:
> +                       if (sbi_v3_available) {
> +                       /* Return error any bits [56-63] is set  as it is=
 not allowed by the spec */
> +                               if (!(config & ~RISCV_PMU_RAW_EVENT_V2_MA=
SK)) {
> +                                       if (econfig)
> +                                               *econfig =3D config & RIS=
CV_PMU_RAW_EVENT_V2_MASK;
> +                                       ret =3D RISCV_PMU_RAW_EVENT_V2_ID=
X;
> +                               }
> +                       /* Return error any bits [48-63] is set  as it is=
 not allowed by the spec */
> +                       } else if (!(config & ~RISCV_PMU_RAW_EVENT_MASK))=
 {
> +                               if (econfig)
> +                                       *econfig =3D config & RISCV_PMU_R=
AW_EVENT_MASK;
> +                               ret =3D RISCV_PMU_RAW_EVENT_IDX;
> +                       }
> +                       break;
> +               case 2:
> +                       ret =3D (config & 0xFFFF) | (SBI_PMU_EVENT_TYPE_F=
W << 16);
> +                       break;
> +               case 3:
> +                       /*
> +                        * For Risc-V platform specific firmware events
> +                        * Event code - 0xFFFF
> +                        * Event data - raw event encoding
> +                        */
> +                       ret =3D SBI_PMU_EVENT_TYPE_FW << 16 | RISCV_PLAT_=
FW_EVENT;
> +                       if (econfig)
> +                               *econfig =3D config & RISCV_PMU_PLAT_FW_E=
VENT_MASK;
> +                       break;
> +               default:
> +                       break;
> +               }
> +               break;
> +       default:
> +               break;
> +       }
> +
> +       return ret;
> +}
> +EXPORT_SYMBOL_GPL(riscv_pmu_get_event_info);
> +
>  /*
>   * Returns the counter width of a programmable counter and number of har=
dware
>   * counters. As we don't support heterogeneous CPUs yet, it is okay to j=
ust
> @@ -576,7 +642,6 @@ static int pmu_sbi_event_map(struct perf_event *event=
, u64 *econfig)
>  {
>         u32 type =3D event->attr.type;
>         u64 config =3D event->attr.config;
> -       int ret =3D -ENOENT;
>
>         /*
>          * Ensure we are finished checking standard hardware events for
> @@ -584,62 +649,7 @@ static int pmu_sbi_event_map(struct perf_event *even=
t, u64 *econfig)
>          */
>         flush_work(&check_std_events_work);
>
> -       switch (type) {
> -       case PERF_TYPE_HARDWARE:
> -               if (config >=3D PERF_COUNT_HW_MAX)
> -                       return -EINVAL;
> -               ret =3D pmu_hw_event_map[event->attr.config].event_idx;
> -               break;
> -       case PERF_TYPE_HW_CACHE:
> -               ret =3D pmu_event_find_cache(config);
> -               break;
> -       case PERF_TYPE_RAW:
> -               /*
> -                * As per SBI v0.3 specification,
> -                *  -- the upper 16 bits must be unused for a hardware ra=
w event.
> -                * As per SBI v3.0 specification,
> -                *  -- the upper 8 bits must be unused for a hardware raw=
 event.
> -                * Bits 63:62 are used to distinguish between raw events
> -                * 00 - Hardware raw event
> -                * 10 - SBI firmware events
> -                * 11 - Risc-V platform specific firmware event
> -                */
> -
> -               switch (config >> 62) {
> -               case 0:
> -                       if (sbi_v3_available) {
> -                       /* Return error any bits [56-63] is set  as it is=
 not allowed by the spec */
> -                               if (!(config & ~RISCV_PMU_RAW_EVENT_V2_MA=
SK)) {
> -                                       *econfig =3D config & RISCV_PMU_R=
AW_EVENT_V2_MASK;
> -                                       ret =3D RISCV_PMU_RAW_EVENT_V2_ID=
X;
> -                               }
> -                       /* Return error any bits [48-63] is set  as it is=
 not allowed by the spec */
> -                       } else if (!(config & ~RISCV_PMU_RAW_EVENT_MASK))=
 {
> -                               *econfig =3D config & RISCV_PMU_RAW_EVENT=
_MASK;
> -                               ret =3D RISCV_PMU_RAW_EVENT_IDX;
> -                       }
> -                       break;
> -               case 2:
> -                       ret =3D (config & 0xFFFF) | (SBI_PMU_EVENT_TYPE_F=
W << 16);
> -                       break;
> -               case 3:
> -                       /*
> -                        * For Risc-V platform specific firmware events
> -                        * Event code - 0xFFFF
> -                        * Event data - raw event encoding
> -                        */
> -                       ret =3D SBI_PMU_EVENT_TYPE_FW << 16 | RISCV_PLAT_=
FW_EVENT;
> -                       *econfig =3D config & RISCV_PMU_PLAT_FW_EVENT_MAS=
K;
> -                       break;
> -               default:
> -                       break;
> -               }
> -               break;
> -       default:
> -               break;
> -       }
> -
> -       return ret;
> +       return riscv_pmu_get_event_info(type, config, econfig);
>  }
>
>  static void pmu_sbi_snapshot_free(struct riscv_pmu *pmu)
> diff --git a/include/linux/perf/riscv_pmu.h b/include/linux/perf/riscv_pm=
u.h
> index 701974639ff2..4a5e3209c473 100644
> --- a/include/linux/perf/riscv_pmu.h
> +++ b/include/linux/perf/riscv_pmu.h
> @@ -91,6 +91,8 @@ struct riscv_pmu *riscv_pmu_alloc(void);
>  int riscv_pmu_get_hpm_info(u32 *hw_ctr_width, u32 *num_hw_ctr);
>  #endif
>
> +int riscv_pmu_get_event_info(u32 type, u64 config, u64 *econfig);
> +
>  #endif /* CONFIG_RISCV_PMU */

We will see compile/link errors for users of riscv_pmu_get_event_info()
if CONFIG_RISCV_PMU_SBI is not defined. Am I missing anything

>
>  #endif /* _RISCV_PMU_H */
>
> --
> 2.43.0
>

Regards,
Anup

