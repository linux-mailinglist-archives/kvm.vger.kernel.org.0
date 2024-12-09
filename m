Return-Path: <kvm+bounces-33333-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E60649E9E55
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 19:52:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 639AC28263D
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 18:52:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62AEC179972;
	Mon,  9 Dec 2024 18:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="muOq98w1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF160155A34
	for <kvm@vger.kernel.org>; Mon,  9 Dec 2024 18:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733770339; cv=none; b=gi1nFc3IGDtkArt0rylBtMv72mq6E1BAjEM1++nkABmom8GT++wBx/+4C5FHIsNnmwUzNVbRSYMZyDwtvZhCHs17fdcJkZyBZptZfgL0/5UmoAF6nb5FXmwObZXlU4s2wAWUHYUDaLPkw2dqFO7dyzZJVsUqTUyoOGa9AjEGqwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733770339; c=relaxed/simple;
	bh=g2BRvOBD2WkAFs9Htd5iRD3WbS3hDE6awetT/6Oo6z0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=b8BW27OhM8L3v2zPDd7M2oqNaCkGK5rKwfrkoDs+Ogq2J3cR/UZl6IV64sBytK8Kd5ixFO61CviRoUAGPNv0vSdln3yh4jmX60x1GSTvg+4fpzmCYdwTiDCe3i+g3kexURqGVjSdG+sNZpdAWccoaHsfaKEmqOZPl4Kwt+9yKnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=muOq98w1; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-7fbc65f6c72so4613211a12.1
        for <kvm@vger.kernel.org>; Mon, 09 Dec 2024 10:52:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1733770337; x=1734375137; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vE5tXM4ceddZHK4DLvqd5OPVdW2n99/09qTSZ4lNDtc=;
        b=muOq98w1VcRH+yv6YXTMN6PkP8okiTRa+9hSupJJLI7RABJxM4rCWy4EqGaHUxHuIq
         m2BloPiQ7c+l45XLmRGLac4UWF9By0cTYvUKDjb/RHU4j+NWYv6vZPMduVWZL9jUpXvI
         dRNQ/33BmqLSBAk5D8P3Uj8lfVE7egGzDP/oZxfRziCg8ad9O2lfFCHUjpbGKwHIRYfK
         sT1IwUZH9TzvFT0rCHz4CCGuIR3j0iw+Oa0WgunTnTaFoRXOEwDiL/m1HaWM1wplFJ0z
         WHbbemkF0BlJlfz+VEC1A4MnefvnirQifwnTuJE5vY0Sjv46ULb6kpKG/Qmkc0OqXqf1
         kCNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733770337; x=1734375137;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vE5tXM4ceddZHK4DLvqd5OPVdW2n99/09qTSZ4lNDtc=;
        b=FG832fXd33qH1TV+PQGpAnjGasQ7RFu9/WABCrTME5uUvc13Oz3L5LlHdD8y0xb6EH
         VUYiJ18TMQuVmtkreF6rfxsL1DAeV6TnhVK65jkVJ5h2+jN6uYDChuEa5qM2o1p+ypJU
         gRWGQxeWx5znO4e4fjPi7MwZWd4dVCG080UODDTa+cQMxsRU5rBAXCeQIxfH59COZoIN
         R02HtictHLXOLu7R25zNJ6z0133/Ylu+VoClr3QhEgYwDMAY8IKGX36A8BGbXI/7XMzp
         oTW4sLNsTPbETX9/lmQ7b6z6ilcaPWYgesvQfMX+mbfKj1PxwKYRYzmYaxNAmcmqm59Z
         UzPA==
X-Forwarded-Encrypted: i=1; AJvYcCX9d5xdtY5ALLvkmFREdTp0DL7YH/t1jYtF6nkRG61nQ2UMLRVc0W8LJgded8DU/hDmvL0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0WPPXmQkh9rysKcNkvrP7U9J9/CExNSLTEt2JnQ99Z3io8U9S
	OY6Dexk+45X2d+BmJXoFtMtTZbVTXupaadXuvyR7ABUkJrN6TCBZVcDxg7WJ7ZWPUesKJyW2IJx
	Iqf4VC1BscHXok9ldWOSnKz9HrcCQRZXpp+x71w==
X-Gm-Gg: ASbGnct2LQI/2ITRXndngmPieEXoXbhS4td+FDt+YodktAVjrXF6fbnRbkQiDyBm7oq
	OvRnn/QwSiwLckRa52edcQJuM22Amppi2Yw==
X-Google-Smtp-Source: AGHT+IE3NlpgFvVBKio4rCWUgc2OgxnpAocEZrxQPQ/mMBSJUxJJVDkYqliqfqvlAJcB016TmpcY1ruHhQTOFNKl1H8=
X-Received: by 2002:a05:6a21:78a6:b0:1e1:adcd:eaf8 with SMTP id
 adf61e73a8af0-1e1adcdf090mr4266443637.28.1733770337025; Mon, 09 Dec 2024
 10:52:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241119-pmu_event_info-v1-0-a4f9691421f8@rivosinc.com>
 <20241119-pmu_event_info-v1-3-a4f9691421f8@rivosinc.com> <e124c532-7a08-4788-843d-345827e35f5f@sifive.com>
 <CAHBxVyEwkPUcut0L7K9eewcmhOOidU16WnGRiPiP3D7-OS7HvQ@mail.gmail.com> <b48c4319-1fbc-4703-88d2-6f495af9c24e@sifive.com>
In-Reply-To: <b48c4319-1fbc-4703-88d2-6f495af9c24e@sifive.com>
From: Atish Kumar Patra <atishp@rivosinc.com>
Date: Mon, 9 Dec 2024 10:52:06 -0800
Message-ID: <CAHBxVyFrsF0jwwFwKsg_6=c5ewFZG12iz3owzHEv6GxpA+hB1w@mail.gmail.com>
Subject: Re: [PATCH 3/8] drivers/perf: riscv: Add raw event v2 support
To: Samuel Holland <samuel.holland@sifive.com>
Cc: Anup Patel <anup@brainfault.org>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Mayuresh Chitale <mchitale@ventanamicro.com>, 
	linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Palmer Dabbelt <palmer@rivosinc.com>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 2, 2024 at 6:39=E2=80=AFPM Samuel Holland <samuel.holland@sifiv=
e.com> wrote:
>
> Hi Atish,
>
> On 2024-12-02 6:15 PM, Atish Kumar Patra wrote:
> > On Mon, Dec 2, 2024 at 2:37=E2=80=AFPM Samuel Holland <samuel.holland@s=
ifive.com> wrote:
> >> On 2024-11-19 2:29 PM, Atish Patra wrote:
> >>> SBI v3.0 introduced a new raw event type that allows wider
> >>> mhpmeventX width to be programmed via CFG_MATCH.
> >>>
> >>> Use the raw event v2 if SBI v3.0 is available.
> >>>
> >>> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> >>> ---
> >>>  arch/riscv/include/asm/sbi.h |  4 ++++
> >>>  drivers/perf/riscv_pmu_sbi.c | 18 ++++++++++++------
> >>>  2 files changed, 16 insertions(+), 6 deletions(-)
> >>>
> >>> diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sb=
i.h
> >>> index 9be38b05f4ad..3ee9bfa5e77c 100644
> >>> --- a/arch/riscv/include/asm/sbi.h
> >>> +++ b/arch/riscv/include/asm/sbi.h
> >>> @@ -159,7 +159,10 @@ struct riscv_pmu_snapshot_data {
> >>>
> >>>  #define RISCV_PMU_RAW_EVENT_MASK GENMASK_ULL(47, 0)
> >>>  #define RISCV_PMU_PLAT_FW_EVENT_MASK GENMASK_ULL(61, 0)
> >>> +/* SBI v3.0 allows extended hpmeventX width value */
> >>> +#define RISCV_PMU_RAW_EVENT_V2_MASK GENMASK_ULL(55, 0)
> >>>  #define RISCV_PMU_RAW_EVENT_IDX 0x20000
> >>> +#define RISCV_PMU_RAW_EVENT_V2_IDX 0x30000
> >>>  #define RISCV_PLAT_FW_EVENT  0xFFFF
> >>>
> >>>  /** General pmu event codes specified in SBI PMU extension */
> >>> @@ -217,6 +220,7 @@ enum sbi_pmu_event_type {
> >>>       SBI_PMU_EVENT_TYPE_HW =3D 0x0,
> >>>       SBI_PMU_EVENT_TYPE_CACHE =3D 0x1,
> >>>       SBI_PMU_EVENT_TYPE_RAW =3D 0x2,
> >>> +     SBI_PMU_EVENT_TYPE_RAW_V2 =3D 0x3,
> >>>       SBI_PMU_EVENT_TYPE_FW =3D 0xf,
> >>>  };
> >>>
> >>> diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sb=
i.c
> >>> index 50cbdbf66bb7..f0e845ff6b79 100644
> >>> --- a/drivers/perf/riscv_pmu_sbi.c
> >>> +++ b/drivers/perf/riscv_pmu_sbi.c
> >>> @@ -59,7 +59,7 @@ asm volatile(ALTERNATIVE(                          =
                 \
> >>>  #define PERF_EVENT_FLAG_USER_ACCESS  BIT(SYSCTL_USER_ACCESS)
> >>>  #define PERF_EVENT_FLAG_LEGACY               BIT(SYSCTL_LEGACY)
> >>>
> >>> -PMU_FORMAT_ATTR(event, "config:0-47");
> >>> +PMU_FORMAT_ATTR(event, "config:0-55");
> >>>  PMU_FORMAT_ATTR(firmware, "config:62-63");
> >>>
> >>>  static bool sbi_v2_available;
> >>> @@ -527,18 +527,24 @@ static int pmu_sbi_event_map(struct perf_event =
*event, u64 *econfig)
> >>>               break;
> >>>       case PERF_TYPE_RAW:
> >>>               /*
> >>> -              * As per SBI specification, the upper 16 bits must be =
unused
> >>> -              * for a hardware raw event.
> >>> +              * As per SBI v0.3 specification,
> >>> +              *  -- the upper 16 bits must be unused for a hardware =
raw event.
> >>> +              * As per SBI v3.0 specification,
> >>> +              *  -- the upper 8 bits must be unused for a hardware r=
aw event.
> >>>                * Bits 63:62 are used to distinguish between raw event=
s
> >>>                * 00 - Hardware raw event
> >>>                * 10 - SBI firmware events
> >>>                * 11 - Risc-V platform specific firmware event
> >>>                */
> >>> -
> >>>               switch (config >> 62) {
> >>>               case 0:
> >>> -                     ret =3D RISCV_PMU_RAW_EVENT_IDX;
> >>> -                     *econfig =3D config & RISCV_PMU_RAW_EVENT_MASK;
> >>> +                     if (sbi_v3_available) {
> >>> +                             *econfig =3D config & RISCV_PMU_RAW_EVE=
NT_V2_MASK;
> >>> +                             ret =3D RISCV_PMU_RAW_EVENT_V2_IDX;
> >>> +                     } else {
> >>> +                             *econfig =3D config & RISCV_PMU_RAW_EVE=
NT_MASK;
> >>> +                             ret =3D RISCV_PMU_RAW_EVENT_IDX;
> >>
> >> Shouldn't we check to see if any of bits 48-55 are set and return an e=
rror,
> >> instead of silently requesting the wrong event?
> >>
> >
> > We can. I did not add it originally as we can't do much validation for
> > the raw events for anyways.
> > If the encoding is not supported the user will get the error anyways
> > as it can't find a counter.
> > We will just save 1 SBI call if the kernel doesn't allow requesting an
> > event if bits 48-55 are set.
>
> The scenario I'm concerned about is where masking off bits 48-55 results =
in a
> valid, supported encoding for a different event. For example, in the HPM =
event
> encoding scheme used by Rocket and inherited by SiFive cores, bits 8-55 a=
re a
> bitmap. So masking off some of those bits will exclude some events, but w=
ill not
> create an invalid encoding. This could be very confusing for users.
>

Ahh yes. That is problematic if the vendor implements that type of
event encoding.
I will send the fix patch with an error if bits 48-55 are set.

> Regards,
> Samuel
>

