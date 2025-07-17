Return-Path: <kvm+bounces-52747-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0ACA9B09062
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 17:17:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 669EF3BFDEE
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 15:17:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F1242F85CD;
	Thu, 17 Jul 2025 15:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="VUtassdx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0FCE1DE2A7
	for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 15:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752765442; cv=none; b=p6LWu935NO3eFa76G46ZHSl91JSgAAsOT629EMHhivBxV9yr8oNr+8hbl2OqUphCpdaZWPKkGOrhE5CVHkLX3QmD/K2m55j69GjZusggLm4vwSHoMSvaPBjTgY0u9KLM+SyMTboT08NHsm+ynbgsNFiuKQaetLPpUb2MwmiPa9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752765442; c=relaxed/simple;
	bh=Dmx0deA06SazWXaBN/smo57DbddeC1VfCpawbGBHF8s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=h5zDNjoUWId4kY/IqPhcPGj1iZ7dQbL6EpZBXiy+4FGt637WqsyUSOn8SksZ+zL2r7TI3U/lYjz7TLblg4gljxABs6od/7rpb5jL2AKz+lwicAPT9PGTGoJVZR+YOjQn632q3M9nZGvLMhPeZ8hOMSxh9l4b1gvL9clxmsVDFuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=VUtassdx; arc=none smtp.client-ip=209.85.222.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-7dfc604107eso99230285a.2
        for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 08:17:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1752765439; x=1753370239; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T3tUz+FrzCtl0Vbggujp06ap3pA8xukaziREmjLBWYA=;
        b=VUtassdxmZuxujJyHhBBCWVJJbQW6YGCfJXjFNFG33B6stU1Vs3C0qwGt6TR9YXmAL
         FY3KfiwDTAnNly1ZeounXNX63lB4zxlxdVKTvSk5ujVQ7FfS50T0TMIq6DWycrREh4dW
         c6weV9nAmgyFZHTfifxsnHlF4FXZa5zf7UNXQXqdmPH29jSC36Ga+v+QWYZuubadNkYm
         bf5wRFpOUnl8Y0Jvng+WN0PimNdQjkFHxjf3TRU1v98dvNalTJkuVWcH0Wvk5tux+c3n
         Us5ezcJ2lompT/cOStjg0vwsjUvkXQAp1d/zqw4XQNbYVr/KyvTeKW2g3iwlpZ+osNDX
         gXZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752765439; x=1753370239;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T3tUz+FrzCtl0Vbggujp06ap3pA8xukaziREmjLBWYA=;
        b=Yk9dmwUOdUWuqIwrrJrbaxqujoKcLWaO2uMSa/IsAfohPbbROvsBFGU1RqgDaFp92y
         fjkif1MausGVQQGHv+oBnuYLhS9zzssXnY91BCgmjlHn3uOlAVrArUCLdSggyL3dV8et
         yN7SOV5uUZpo2WjpwHtjAO9yt6dAz8ZUyJB5JZvifRqHbSBxDAU3h5Ng14uHhKxSqh7k
         zHg1FZZhajEDKb9HPEFkHsi1spUNUMa9nHFV8xzj82VwsdOm+4fIpOL3c7q9Q+aKWC+y
         GBQ5spWBb9LkbTl7duiknL569cyM3nmg/WHFcdkU8twMzNnsbaSxKWOoNCyIF+V/0ik2
         m16g==
X-Forwarded-Encrypted: i=1; AJvYcCX1EL55Ts4ccmmhvPMbjvkImTOy/4iAb3QRWQnb8OB39W2jNmykx9mA1jMMt/MW+JhOMxY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxmXBi7NGmwTVkZxkYMo/4uhybtnOxnrvITvWmsV30TP1Ue201u
	h9bdT6tyzI6MRwn84tnx8/+Yw+7nYWphb71B0AM9fhJYVSPS6KRAxWAAQeOIe27ji4P7XadZW6O
	Z/1+pYkRFSiNuWIjHK9zNOp7V9c/1dgt34tRSy8LPPg==
X-Gm-Gg: ASbGnctQehO34NshnsXeSQQlyCdW9amCTxReH2U2ZkMAmozPusSSJQTISLOj5zywaK4
	zliGQ8+YmZyH3IVDKSAhNMgNy0cLjP8Hl4gsoxy3DYPPnd5MDHr70ewpbAeWvvCCSRMSCWFNlqy
	wXjuc/Pl37DokWXiYfYy8u9M9W/dEaSCMbb/35wwuQPjlE/+UjP4tmup0wvlCxnEb/a+i6v6oXC
	4Vu4tD0
X-Google-Smtp-Source: AGHT+IHz2ooSEYMwChi5WNQfJsDufDgq6WJG7AmXKC3wtaW/L8MYe8nihHSBFgq+2TYbHnsMVgzMJk9i+88DE/6bDYA=
X-Received: by 2002:a05:620a:7017:b0:7c5:5fa0:4617 with SMTP id
 af79cd13be357-7e343615e30mr946456785a.40.1752765438473; Thu, 17 Jul 2025
 08:17:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250522-pmu_event_info-v3-0-f7bba7fd9cfe@rivosinc.com> <20250522-pmu_event_info-v3-2-f7bba7fd9cfe@rivosinc.com>
In-Reply-To: <20250522-pmu_event_info-v3-2-f7bba7fd9cfe@rivosinc.com>
From: Anup Patel <anup@brainfault.org>
Date: Thu, 17 Jul 2025 20:47:06 +0530
X-Gm-Features: Ac12FXzD0efP_qu0iiVx1ulFC3dW-BDJaKPty1r8E1h77LH8P4Y_H1glg7EyAyo
Message-ID: <CAAhSdy02kKJ0PHjyeGaV1-pC3DVL8-VcQ=EB+ha69=_CAQb2xg@mail.gmail.com>
Subject: Re: [PATCH v3 2/9] drivers/perf: riscv: Add raw event v2 support
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
> SBI v3.0 introduced a new raw event type that allows wider
> mhpmeventX width to be programmed via CFG_MATCH.
>
> Use the raw event v2 if SBI v3.0 is available.
>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  arch/riscv/include/asm/sbi.h |  4 ++++
>  drivers/perf/riscv_pmu_sbi.c | 16 ++++++++++++----
>  2 files changed, 16 insertions(+), 4 deletions(-)
>
> diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.h
> index 3d250824178b..6ce385a3a7bb 100644
> --- a/arch/riscv/include/asm/sbi.h
> +++ b/arch/riscv/include/asm/sbi.h
> @@ -160,7 +160,10 @@ struct riscv_pmu_snapshot_data {
>
>  #define RISCV_PMU_RAW_EVENT_MASK GENMASK_ULL(47, 0)
>  #define RISCV_PMU_PLAT_FW_EVENT_MASK GENMASK_ULL(61, 0)
> +/* SBI v3.0 allows extended hpmeventX width value */
> +#define RISCV_PMU_RAW_EVENT_V2_MASK GENMASK_ULL(55, 0)
>  #define RISCV_PMU_RAW_EVENT_IDX 0x20000
> +#define RISCV_PMU_RAW_EVENT_V2_IDX 0x30000
>  #define RISCV_PLAT_FW_EVENT    0xFFFF
>
>  /** General pmu event codes specified in SBI PMU extension */
> @@ -218,6 +221,7 @@ enum sbi_pmu_event_type {
>         SBI_PMU_EVENT_TYPE_HW =3D 0x0,
>         SBI_PMU_EVENT_TYPE_CACHE =3D 0x1,
>         SBI_PMU_EVENT_TYPE_RAW =3D 0x2,
> +       SBI_PMU_EVENT_TYPE_RAW_V2 =3D 0x3,
>         SBI_PMU_EVENT_TYPE_FW =3D 0xf,
>  };
>
> diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sbi.c
> index cfd6946fca42..273ed70098a3 100644
> --- a/drivers/perf/riscv_pmu_sbi.c
> +++ b/drivers/perf/riscv_pmu_sbi.c
> @@ -59,7 +59,7 @@ asm volatile(ALTERNATIVE(                              =
               \
>  #define PERF_EVENT_FLAG_USER_ACCESS    BIT(SYSCTL_USER_ACCESS)
>  #define PERF_EVENT_FLAG_LEGACY         BIT(SYSCTL_LEGACY)
>
> -PMU_FORMAT_ATTR(event, "config:0-47");
> +PMU_FORMAT_ATTR(event, "config:0-55");
>  PMU_FORMAT_ATTR(firmware, "config:62-63");
>
>  static bool sbi_v2_available;
> @@ -527,8 +527,10 @@ static int pmu_sbi_event_map(struct perf_event *even=
t, u64 *econfig)
>                 break;
>         case PERF_TYPE_RAW:
>                 /*
> -                * As per SBI specification, the upper 16 bits must be un=
used
> -                * for a hardware raw event.
> +                * As per SBI v0.3 specification,
> +                *  -- the upper 16 bits must be unused for a hardware ra=
w event.
> +                * As per SBI v3.0 specification,

The text here should be "As-per SBI v2.0 ..."

> +                *  -- the upper 8 bits must be unused for a hardware raw=
 event.
>                  * Bits 63:62 are used to distinguish between raw events
>                  * 00 - Hardware raw event
>                  * 10 - SBI firmware events
> @@ -537,8 +539,14 @@ static int pmu_sbi_event_map(struct perf_event *even=
t, u64 *econfig)
>
>                 switch (config >> 62) {
>                 case 0:
> +                       if (sbi_v3_available) {
> +                       /* Return error any bits [56-63] is set  as it is=
 not allowed by the spec */
> +                               if (!(config & ~RISCV_PMU_RAW_EVENT_V2_MA=
SK)) {
> +                                       *econfig =3D config & RISCV_PMU_R=
AW_EVENT_V2_MASK;
> +                                       ret =3D RISCV_PMU_RAW_EVENT_V2_ID=
X;
> +                               }
>                         /* Return error any bits [48-63] is set  as it is=
 not allowed by the spec */
> -                       if (!(config & ~RISCV_PMU_RAW_EVENT_MASK)) {
> +                       } else if (!(config & ~RISCV_PMU_RAW_EVENT_MASK))=
 {
>                                 *econfig =3D config & RISCV_PMU_RAW_EVENT=
_MASK;
>                                 ret =3D RISCV_PMU_RAW_EVENT_IDX;
>                         }
>
> --
> 2.43.0
>

Otherwise, this looks good to me.

Reviewed-by: Anup Patel <anup@brainfault.org>

Regards,
Anup

