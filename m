Return-Path: <kvm+bounces-32863-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FF5E9E0F8F
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 01:15:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CD3C7B2369A
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 00:15:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9CC2B660;
	Tue,  3 Dec 2024 00:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="ovKzJy+Y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 018E510E3
	for <kvm@vger.kernel.org>; Tue,  3 Dec 2024 00:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733184938; cv=none; b=LmMTZ54w7ZdGhvlJYFma1t4v+oEkDK0NKbJAlJfJ3ps4rhpMa53w6+Jbip9StXsu4oxDPCx2Y5vMJ2QhhxeMPyBTWjassG1qy4HxXG9I0Ylvu9F2uQoTXtzZnoj0gZq/cI67NlPcCw9XXfLGOwb1VYvJzMHd9/FSpg4RdOfpLII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733184938; c=relaxed/simple;
	bh=r0YDfQRpMEbID59vFjWbfe/cgrEj5t8qE0gvWCUMUrs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=i3RRdXPaFKPeIuwzx2Bo0JKqWq/nOUsjXv0qnSWhNkBS0fyT8/DZVM9wPYVP9qTUxxHXvfAiS/zR6SUtyvvma9nIbL3UQgPTUYj/l7Ddt9nLbt0nNFFZmHlpK+iOsK9X10uXItX25fxCSIXBc2+GxChXYs9z2dMFG2xeZv/LAbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=ovKzJy+Y; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-2e56750bb0dso3553001a91.0
        for <kvm@vger.kernel.org>; Mon, 02 Dec 2024 16:15:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1733184934; x=1733789734; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k+YlV66sEeV5Gi1JEnWTwo3a+A+kAB7BmLzMmDK0RYY=;
        b=ovKzJy+YOLwww/ObTOZTaGhWoyxvWJgWCkkFRPayduzbl3n3BThwwa8r+0wqRwMzWj
         T3vm2iZo1/26rDvBivf6sYnYPm0AyLJkHAFCjAXv3UiP3KsU5J3eZPxhJPJuXfPwOM6c
         rWfBe0hHCxl7uoyqzLdZjBF5DFdtGHKiTaxsCZlZrM3l67bfk4ch8BhjocILbpaNGNOs
         BHSINwFUapr25U0xWlFozAwk+GjQ0EbJfbcw2cPeiFJhQWo/FvYFniUArQUyVuxgOFeg
         UyO2QBPpGO67ZoGqCs4bS/jlOISEFkvq+32fADf8zOFZ8S+y0qu8pB4+k17MA6FAciXQ
         w8Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733184934; x=1733789734;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k+YlV66sEeV5Gi1JEnWTwo3a+A+kAB7BmLzMmDK0RYY=;
        b=YEnTc+oW6b7O0FY2vO8p+ol/I3bPrNXiAr+dmKcvh2wKWLCPnfivk4C4Uho1izhkUW
         nmnNFUmV+18VHNYqEMBkJ0WbPRCiAFim6tBnHDY38Zx4s2NMpoqH5LA0pjqbfhwBOwrK
         /RhxgCkA61mjk7PTgmAZIO1Tf7oKHdY8Rf9/h9EaGzPVAWNT2QhgMZODjS7DaZjtY8X5
         w90xex+YMgond4G9GLGqD1m9HagDtzzscqNcnPCMTT26JVR8ba0j6RFz3J+H4ak3UtdZ
         QGIKdvwg/HYaff/Yt700fLxRPdgGCP7GE9JD7uIKFihwYcDaRoGFvgbFbmBx1dHbgNqz
         IsRg==
X-Forwarded-Encrypted: i=1; AJvYcCWZNAg2Ls7h8LZF4FkjIXcVLcULD/03WDNo6dj5dbayQpmb7HFvz8hGvw45GvMky4h3S7g=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz6lfD+hwlUcOErZfip/D4srZwj+1DlD0Xzo6I8O8n+2C2fmSII
	ptbsjo/ElLaeah3s3UpJvo3xZgXeavRVrK8Y9fGNMn5GUjvYV2J14HlBEmRw6Ya7ToZmiz5yWAw
	39LZ4IYoRn2PLodGeY1tI3WdtWPBMzOui4voESKt/18Rppv2X
X-Gm-Gg: ASbGncu3u8PSaW5sCzxgZDUid0fc4e157oAcavGQ7TmZdU6ENbdnDz7Mw/vUdWC7KY0
	fshEnMuIpEzI3bljo3hkW9UyuL8WIdA==
X-Google-Smtp-Source: AGHT+IHkfSZg8nwRSMyT59R8Thc83SJq1L85mjo/aMDSMjUafqwNxe8ioi4sjLMkGcNLINNqRnY9VhmQH6Pl1GzeePc=
X-Received: by 2002:a17:90b:4f4e:b0:2ee:693e:ed7a with SMTP id
 98e67ed59e1d1-2ef012796c8mr807474a91.35.1733184934283; Mon, 02 Dec 2024
 16:15:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241119-pmu_event_info-v1-0-a4f9691421f8@rivosinc.com>
 <20241119-pmu_event_info-v1-3-a4f9691421f8@rivosinc.com> <e124c532-7a08-4788-843d-345827e35f5f@sifive.com>
In-Reply-To: <e124c532-7a08-4788-843d-345827e35f5f@sifive.com>
From: Atish Kumar Patra <atishp@rivosinc.com>
Date: Mon, 2 Dec 2024 16:15:23 -0800
Message-ID: <CAHBxVyEwkPUcut0L7K9eewcmhOOidU16WnGRiPiP3D7-OS7HvQ@mail.gmail.com>
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

On Mon, Dec 2, 2024 at 2:37=E2=80=AFPM Samuel Holland <samuel.holland@sifiv=
e.com> wrote:
>
> Hi Atish,
>
> On 2024-11-19 2:29 PM, Atish Patra wrote:
> > SBI v3.0 introduced a new raw event type that allows wider
> > mhpmeventX width to be programmed via CFG_MATCH.
> >
> > Use the raw event v2 if SBI v3.0 is available.
> >
> > Signed-off-by: Atish Patra <atishp@rivosinc.com>
> > ---
> >  arch/riscv/include/asm/sbi.h |  4 ++++
> >  drivers/perf/riscv_pmu_sbi.c | 18 ++++++++++++------
> >  2 files changed, 16 insertions(+), 6 deletions(-)
> >
> > diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.=
h
> > index 9be38b05f4ad..3ee9bfa5e77c 100644
> > --- a/arch/riscv/include/asm/sbi.h
> > +++ b/arch/riscv/include/asm/sbi.h
> > @@ -159,7 +159,10 @@ struct riscv_pmu_snapshot_data {
> >
> >  #define RISCV_PMU_RAW_EVENT_MASK GENMASK_ULL(47, 0)
> >  #define RISCV_PMU_PLAT_FW_EVENT_MASK GENMASK_ULL(61, 0)
> > +/* SBI v3.0 allows extended hpmeventX width value */
> > +#define RISCV_PMU_RAW_EVENT_V2_MASK GENMASK_ULL(55, 0)
> >  #define RISCV_PMU_RAW_EVENT_IDX 0x20000
> > +#define RISCV_PMU_RAW_EVENT_V2_IDX 0x30000
> >  #define RISCV_PLAT_FW_EVENT  0xFFFF
> >
> >  /** General pmu event codes specified in SBI PMU extension */
> > @@ -217,6 +220,7 @@ enum sbi_pmu_event_type {
> >       SBI_PMU_EVENT_TYPE_HW =3D 0x0,
> >       SBI_PMU_EVENT_TYPE_CACHE =3D 0x1,
> >       SBI_PMU_EVENT_TYPE_RAW =3D 0x2,
> > +     SBI_PMU_EVENT_TYPE_RAW_V2 =3D 0x3,
> >       SBI_PMU_EVENT_TYPE_FW =3D 0xf,
> >  };
> >
> > diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sbi.=
c
> > index 50cbdbf66bb7..f0e845ff6b79 100644
> > --- a/drivers/perf/riscv_pmu_sbi.c
> > +++ b/drivers/perf/riscv_pmu_sbi.c
> > @@ -59,7 +59,7 @@ asm volatile(ALTERNATIVE(                            =
               \
> >  #define PERF_EVENT_FLAG_USER_ACCESS  BIT(SYSCTL_USER_ACCESS)
> >  #define PERF_EVENT_FLAG_LEGACY               BIT(SYSCTL_LEGACY)
> >
> > -PMU_FORMAT_ATTR(event, "config:0-47");
> > +PMU_FORMAT_ATTR(event, "config:0-55");
> >  PMU_FORMAT_ATTR(firmware, "config:62-63");
> >
> >  static bool sbi_v2_available;
> > @@ -527,18 +527,24 @@ static int pmu_sbi_event_map(struct perf_event *e=
vent, u64 *econfig)
> >               break;
> >       case PERF_TYPE_RAW:
> >               /*
> > -              * As per SBI specification, the upper 16 bits must be un=
used
> > -              * for a hardware raw event.
> > +              * As per SBI v0.3 specification,
> > +              *  -- the upper 16 bits must be unused for a hardware ra=
w event.
> > +              * As per SBI v3.0 specification,
> > +              *  -- the upper 8 bits must be unused for a hardware raw=
 event.
> >                * Bits 63:62 are used to distinguish between raw events
> >                * 00 - Hardware raw event
> >                * 10 - SBI firmware events
> >                * 11 - Risc-V platform specific firmware event
> >                */
> > -
> >               switch (config >> 62) {
> >               case 0:
> > -                     ret =3D RISCV_PMU_RAW_EVENT_IDX;
> > -                     *econfig =3D config & RISCV_PMU_RAW_EVENT_MASK;
> > +                     if (sbi_v3_available) {
> > +                             *econfig =3D config & RISCV_PMU_RAW_EVENT=
_V2_MASK;
> > +                             ret =3D RISCV_PMU_RAW_EVENT_V2_IDX;
> > +                     } else {
> > +                             *econfig =3D config & RISCV_PMU_RAW_EVENT=
_MASK;
> > +                             ret =3D RISCV_PMU_RAW_EVENT_IDX;
>
> Shouldn't we check to see if any of bits 48-55 are set and return an erro=
r,
> instead of silently requesting the wrong event?
>

We can. I did not add it originally as we can't do much validation for
the raw events for anyways.
If the encoding is not supported the user will get the error anyways
as it can't find a counter.
We will just save 1 SBI call if the kernel doesn't allow requesting an
event if bits 48-55 are set.

> Regards,
> Samuel
>
> > +                     }
> >                       break;
> >               case 2:
> >                       ret =3D (config & 0xFFFF) | (SBI_PMU_EVENT_TYPE_F=
W << 16);
> >
>

