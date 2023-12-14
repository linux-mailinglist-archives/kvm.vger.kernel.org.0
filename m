Return-Path: <kvm+bounces-4474-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D37E3812FDE
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 13:16:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7012BB21262
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 12:16:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EBC441771;
	Thu, 14 Dec 2023 12:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="bvWcy6PM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-xc2a.google.com (mail-oo1-xc2a.google.com [IPv6:2607:f8b0:4864:20::c2a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E75BA10A
	for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 04:16:00 -0800 (PST)
Received: by mail-oo1-xc2a.google.com with SMTP id 006d021491bc7-58e256505f7so4710103eaf.3
        for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 04:16:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1702556160; x=1703160960; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fBseVdrDFlP3wbP7vJYL9hvjzRVN+OTQXpZ+CsBu3pI=;
        b=bvWcy6PMY8YZaM7uhVJFLoE+xWHyZuH6BMb8w0KH2KFANUclkQc9Jfb/OqyfUMYO8T
         +134XcxFO4Z21nthq+eBU9Tx68rsCP+HmTSUj07Lbo3dHIWsDKCU0lZYDETFhuucqjMc
         dfzMob+PUTiLXZZVBKiNqDkOS6ai7FPfBKk9vCYw06xx1tTt32UtI0XvwdRy5CYTSI/W
         oTGNHcdMaBXCQb5onvv++5xkdyE2jQWMVSJFTgLp/nBHtRuR8G5OvUNd7sHFzXDngWwn
         4dT4sFpuo9kIz0TGa3Agauthu1uXA5XEwGktd1Kbgo7n1cfNyhwcy3r1zjPog/5Emwzq
         kDhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702556160; x=1703160960;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fBseVdrDFlP3wbP7vJYL9hvjzRVN+OTQXpZ+CsBu3pI=;
        b=sHohUiBx0EfbJlLH8Ufk4pUZwQE3llWhpXF7Z4U7Bnte0tqk85299tTOLyazBuaxEo
         wAjm626x9BGK5I79U7bk5qcl+YULGvuTGCReQxuwARnNAkfCjp/j5zPiQmoEIa+8CfNo
         P/3SdCONGeJa8xewyXjlwSCjbJK8K5d3VcViHcmRQbl3b1yS4I1r5XBg/6HrPzeyOdW3
         nI5/XOS1tgSAj3wPmlcqM0FSHwFENAeUNUq+yj8eDdHlKHVFn5dB5vK4GwwDoNCmVU15
         7E7saxEcK48XYJc8KAL0K9F7D4sVVO+RuLjzsXY3YMJjDPrPiHjmKV2GYN99mU0ihAxf
         IJbA==
X-Gm-Message-State: AOJu0Ywk0SKmXs/Mtu1+45tbl45wptAHT51yb/nAEkJQcfcIblFl2XMr
	N2xpp9L6ltuLjLgD0fyGMoBBbCJ1LtUjUmJmqc5x2g==
X-Google-Smtp-Source: AGHT+IEj9LpcHY6hPKfn4REgUhGo85Mz6E/WR3+z/9PsY0zYZ3nuIGu4wDt6mM+Ma9Kl8FbXjzNz7S4MPf/SQnJvxkk=
X-Received: by 2002:a05:6358:6f07:b0:170:17eb:14b6 with SMTP id
 r7-20020a0563586f0700b0017017eb14b6mr8323474rwn.38.1702556159958; Thu, 14 Dec
 2023 04:15:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231205024310.1593100-1-atishp@rivosinc.com> <20231205024310.1593100-3-atishp@rivosinc.com>
 <20231207-professed-component-84128c06befa@wendy>
In-Reply-To: <20231207-professed-component-84128c06befa@wendy>
From: Anup Patel <anup@brainfault.org>
Date: Thu, 14 Dec 2023 17:45:48 +0530
Message-ID: <CAAhSdy1vqGHeEMStu8Ft2Cz-_c=9e8ciwo9nBh=CDnEejEvp9w@mail.gmail.com>
Subject: Re: [RFC 2/9] drivers/perf: riscv: Add a flag to indicate SBI v2.0 support
To: Conor Dooley <conor.dooley@microchip.com>
Cc: Atish Patra <atishp@rivosinc.com>, linux-kernel@vger.kernel.org, 
	Alexandre Ghiti <alexghiti@rivosinc.com>, Andrew Jones <ajones@ventanamicro.com>, 
	Atish Patra <atishp@atishpatra.org>, Guo Ren <guoren@kernel.org>, 
	Icenowy Zheng <uwu@icenowy.me>, kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-riscv@lists.infradead.org, Mark Rutland <mark.rutland@arm.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 7, 2023 at 5:39=E2=80=AFPM Conor Dooley <conor.dooley@microchip=
.com> wrote:
>
> On Mon, Dec 04, 2023 at 06:43:03PM -0800, Atish Patra wrote:
> > SBI v2.0 added few functions to improve SBI PMU extension. In order
> > to be backward compatible, the driver must use these functions only
> > if SBI v2.0 is available.
> >
> > Signed-off-by: Atish Patra <atishp@rivosinc.com>
>
> IMO this does not make sense in a patch of its own and should probably
> be squashed with the first user for it.

I agree. This patch should be squashed into patch4 where the
flag is first used.

Regards,
Anup

>
> > ---
> >  drivers/perf/riscv_pmu_sbi.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> >
> > diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sbi.=
c
> > index 16acd4dcdb96..40a335350d08 100644
> > --- a/drivers/perf/riscv_pmu_sbi.c
> > +++ b/drivers/perf/riscv_pmu_sbi.c
> > @@ -35,6 +35,8 @@
> >  PMU_FORMAT_ATTR(event, "config:0-47");
> >  PMU_FORMAT_ATTR(firmware, "config:63");
> >
> > +static bool sbi_v2_available;
> > +
> >  static struct attribute *riscv_arch_formats_attr[] =3D {
> >       &format_attr_event.attr,
> >       &format_attr_firmware.attr,
> > @@ -1108,6 +1110,9 @@ static int __init pmu_sbi_devinit(void)
> >               return 0;
> >       }
> >
> > +     if (sbi_spec_version >=3D sbi_mk_version(2, 0))
> > +             sbi_v2_available =3D true;
> > +
> >       ret =3D cpuhp_setup_state_multi(CPUHP_AP_PERF_RISCV_STARTING,
> >                                     "perf/riscv/pmu:starting",
> >                                     pmu_sbi_starting_cpu, pmu_sbi_dying=
_cpu);
> > --
> > 2.34.1
> >

