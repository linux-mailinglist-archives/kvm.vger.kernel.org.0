Return-Path: <kvm+bounces-39416-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 26F92A46FC8
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 01:03:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 293563AFEF5
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 00:03:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24ED827005A;
	Thu, 27 Feb 2025 00:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="D+CFDCnp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD756A48
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 00:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740614598; cv=none; b=GQCAnyG35E82NNpawGHgBdd3V+ACQ6B0P8GbZzRcXv7cD3+4cwAbkdhNSUH0GiKT1l0c8s00BPM9NeM8WHUcPsp3K5qkDScJ5sdz+34lJtynSD0jieZXLIKLZ25i2/CSSUvu00DHISh8yGlMW3g1Zvmqh27/ewoZqkVg7VcpWnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740614598; c=relaxed/simple;
	bh=KkFjDxRYcbZseqFwc6DwvjKa1AnMTvM0gKC17ZUsX7g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HGXsb5VB7QWoO1sBe1q0OZ+G8JlE7M5mDCzxsWYk0myrvDZ0Ma5fPdcbjCNiA7glr6tTY9yZK8rtxOqvSpIvd6iR3QuEaWnh2qLPBPU+jXcsKXUAApK9FCHUfh7yRl0gxV+EWj+Sc5T6b/+3bopImCO8Pa+nOjGnIKn/lkas/LI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=D+CFDCnp; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2235189adaeso1552105ad.0
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 16:03:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1740614595; x=1741219395; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7eluzqqf3VmMNWgnnw6mwWFDCXsND3S4l7FpeN+tcY8=;
        b=D+CFDCnpP1TskNuA9WMYh3QlhpwxOCcH5L32w6Qp8FWOmXvSgqWeBYhiwMQRvfZzJw
         G4SlXLjJz8jeWKbj8LIloP2xbC0EQGhE7HTRfzV+JTbfzmh5uDizimrTqu9srlXO+icR
         ff6z9+7MNMxVe1sgiv5K9HLUAG6E6Nomz02igb+mIZlZbWtk6ovjvNzAT1ZmyAc/jwzn
         zS1NtElP+2AXIvQl67FCEQK1frz5IQIXYTxrZ5qgo+w7RSfuB1spFG8jdDBeQi3a7zes
         WE0sO/4AwHpaVfsyTKlsIywlW3lLggP1F0yu030m53qtlGeZ++0evSA40D16sKit69lE
         vPrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740614595; x=1741219395;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7eluzqqf3VmMNWgnnw6mwWFDCXsND3S4l7FpeN+tcY8=;
        b=iGnXOHBMY4QqCySJAustwphoBRR3z4SUnDDKPa+YQFrbim1CpKb564TZyIgQih8gTR
         DFJBXmFnGpB+5CTHUDMRdLVHO2CSwQg1JQnSnZklSydOqPA4GFPNGLI0ENtgkEx+Oi1a
         JuLiVUttCy5YJ3LoONSTShK8UjU/pzsf3gf3tyzFerGA8tRC9ImxSK15FbjZQrS0ygwK
         Mt3l+bfryDu4wxtLX16+5VOKvfeQ92JlMfYs/E2lW5RwDAVNDVK/FvbWVlVs37k6Uu2n
         MefcFpLpGq1p5+ClZfvT5CleeRxWAg4jzHGjJxSDYghvml9IKCxUaZqT4YNZXF4A7YSr
         TxGg==
X-Forwarded-Encrypted: i=1; AJvYcCVnWfBRFnxiKcFEIs662JWpTK3uhg8iSH+Z4YH8vjtty6hiXP0xyKIJUq9gBCMLP99hWUg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyHfZa1NJMmn29ydCzKna3r1CSPiMPwv86AFjWcVodlDnxDjtXi
	5zs/U8xiXh2C3TUbOsziR2MvKFN45CGx1bFudTlducfol+5z5KxWCSSO3hFr0DoFFs4YUiS2xxO
	CLiFTjWpw5roAyT1XPxqX0cey6pmvpd8jZSfSfA==
X-Gm-Gg: ASbGncverr9B7unCIFxfvyrNmWOJAgWeu9lsATUAPEmio6PtQRGlV80OquMc/x7hNNG
	m36DYt2dc+pfJJ/xS234LB2zC9qXk6cUvbJd3zr97fbadSNWe5Svu8MSmZFNontogbt7zarhJpr
	9sLn03tA==
X-Google-Smtp-Source: AGHT+IFrt1HFaZ54tMfJQXNhrvI9R+jOmDy/nuxxOKVXc1hJS2IXrvPo+lbSmj1tQY9y14Kf7mMsIhJxPaxk/aVTs/c=
X-Received: by 2002:a17:903:289:b0:21f:3823:482b with SMTP id
 d9443c01a7336-2234b08fc3amr20812385ad.25.1740614594829; Wed, 26 Feb 2025
 16:03:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250205-counter_delegation-v4-0-835cfa88e3b1@rivosinc.com>
 <20250205-counter_delegation-v4-8-835cfa88e3b1@rivosinc.com> <bcb10a3a-162b-4a8c-a479-38f4168cea9a@rivosinc.com>
In-Reply-To: <bcb10a3a-162b-4a8c-a479-38f4168cea9a@rivosinc.com>
From: Atish Kumar Patra <atishp@rivosinc.com>
Date: Wed, 26 Feb 2025 16:03:04 -0800
X-Gm-Features: AQ5f1Jpty0qq-pYufASOZ8Op-YJ_VW5jRuImaN1P7f7dzUah8vHjK9-7awdIFLs
Message-ID: <CAHBxVyHZ+iw9dC=4xzbW-UdEELdpr-E=FtExGOMnPzUKSRwFvg@mail.gmail.com>
Subject: Re: [PATCH v4 08/21] RISC-V: Add Sscfg extension CSR definition
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

On Fri, Feb 7, 2025 at 1:30=E2=80=AFAM Cl=C3=A9ment L=C3=A9ger <cleger@rivo=
sinc.com> wrote:
>
>
>
> On 06/02/2025 08:23, Atish Patra wrote:
> > From: Kaiwen Xue <kaiwenx@rivosinc.com>
> >
> > This adds the scountinhibit CSR definition and S-mode accessible hpmeve=
nt
> > bits defined by smcdeleg/ssccfg. scountinhibit allows S-mode to start/s=
top
> > counters directly from S-mode without invoking SBI calls to M-mode. It =
is
> > also used to figure out the counters delegated to S-mode by the M-mode =
as
> > well.
> >
> > Signed-off-by: Kaiwen Xue <kaiwenx@rivosinc.com>
> > ---
> >  arch/riscv/include/asm/csr.h | 26 ++++++++++++++++++++++++++
> >  1 file changed, 26 insertions(+)
> >
> > diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.=
h
> > index 2ad2d492e6b4..42b7f4f7ec0f 100644
> > --- a/arch/riscv/include/asm/csr.h
> > +++ b/arch/riscv/include/asm/csr.h
> > @@ -224,6 +224,31 @@
> >  #define SMSTATEEN0_HSENVCFG          (_ULL(1) << SMSTATEEN0_HSENVCFG_S=
HIFT)
> >  #define SMSTATEEN0_SSTATEEN0_SHIFT   63
> >  #define SMSTATEEN0_SSTATEEN0         (_ULL(1) << SMSTATEEN0_SSTATEEN0_=
SHIFT)
> > +/* HPMEVENT bits. These are accessible in S-mode via Smcdeleg/Ssccfg *=
/
> > +#ifdef CONFIG_64BIT
> > +#define HPMEVENT_OF                  (_UL(1) << 63)
> > +#define HPMEVENT_MINH                        (_UL(1) << 62)
> > +#define HPMEVENT_SINH                        (_UL(1) << 61)
> > +#define HPMEVENT_UINH                        (_UL(1) << 60)
> > +#define HPMEVENT_VSINH                       (_UL(1) << 59)
> > +#define HPMEVENT_VUINH                       (_UL(1) << 58)
> > +#else
> > +#define HPMEVENTH_OF                 (_ULL(1) << 31)
> > +#define HPMEVENTH_MINH                       (_ULL(1) << 30)
> > +#define HPMEVENTH_SINH                       (_ULL(1) << 29)
> > +#define HPMEVENTH_UINH                       (_ULL(1) << 28)
> > +#define HPMEVENTH_VSINH                      (_ULL(1) << 27)
> > +#define HPMEVENTH_VUINH                      (_ULL(1) << 26)
>
> Hi Atish,
>
> Could you use BIT_UL/BIT_ULL() ? With that fixed,
>

Done.

> Reviewed-by: Cl=C3=A9ment L=C3=A9ger <cleger@rivosinc.com>
>

Thanks!

> Thanks,
>
> Cl=C3=A9ment
>
> > +
> > +#define HPMEVENT_OF                  (HPMEVENTH_OF << 32)
> > +#define HPMEVENT_MINH                        (HPMEVENTH_MINH << 32)
> > +#define HPMEVENT_SINH                        (HPMEVENTH_SINH << 32)
> > +#define HPMEVENT_UINH                        (HPMEVENTH_UINH << 32)
> > +#define HPMEVENT_VSINH                       (HPMEVENTH_VSINH << 32)
> > +#define HPMEVENT_VUINH                       (HPMEVENTH_VUINH << 32)
> > +#endif
> > +
> > +#define SISELECT_SSCCFG_BASE         0x40
> >
> >  /* mseccfg bits */
> >  #define MSECCFG_PMM                  ENVCFG_PMM
> > @@ -305,6 +330,7 @@
> >  #define CSR_SCOUNTEREN               0x106
> >  #define CSR_SENVCFG          0x10a
> >  #define CSR_SSTATEEN0                0x10c
> > +#define CSR_SCOUNTINHIBIT    0x120
> >  #define CSR_SSCRATCH         0x140
> >  #define CSR_SEPC             0x141
> >  #define CSR_SCAUSE           0x142
> >
>

