Return-Path: <kvm+bounces-19987-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F8AB90EF35
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 15:41:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 349CF1F21FC2
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 13:41:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EA2F13DDC0;
	Wed, 19 Jun 2024 13:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NxiKizfJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1897914B96E
	for <kvm@vger.kernel.org>; Wed, 19 Jun 2024 13:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718804482; cv=none; b=OkjwMrXkw5FtmXJ2NMgMG3f83fn3Ck+4aGMSYLobysJQ1D0ngypxYPxpEUt0wB6bSMRx3kI5nM0ec3AiU0atQl+XGJ/XCjk2Ig+qCQv/Lenhv4jrNt3dcDcQr92lTgrewbYaTo7YHPEcqM48KJ76qJ5iMhNDaktghr23FcwwCnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718804482; c=relaxed/simple;
	bh=2UHDI2XxwOvWyEzmuJdHe248WK5SMSQoAl8C2lNYnF8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WxpzUGVnaEDrGsxqyE09AMxXD5zMo+W0LmlmlV/Vnha6Gp6zyZ9nUW384Xylc2QAPLXlH/FXzpkiaajB1OU0o6jLgYK4xaULmWF8HP+TLgy118reewHHVQVN0aY8n7ebohQ3xohY02QDc8WZCojWyUXJvFuQWepSyT1+n23yuXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NxiKizfJ; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-57a4d7ba501so8273631a12.2
        for <kvm@vger.kernel.org>; Wed, 19 Jun 2024 06:41:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718804479; x=1719409279; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xq+r7usRX/S+4Xtw72+s6ED4D41EE/ebQwhi1xrEsac=;
        b=NxiKizfJvinvOV5R0OcD7jWZACj9F6fEN50IZP8y760Zcz9R/vineiwnJlqXPYRZHO
         TF+ze/LVDSkn3Hkqgvg2HKwLbthEiPIEP10tS78c1kdjuF0t/9GQNzZCsa6tzoJEz1Ng
         s8xYXc1mTLGVm0qSA3EMNytbad+hwyxEMvBsipbIxhpjFJ7nF7wUPsid6AHXZsN41zwz
         5SWSVC9cJxl25hDfU0XvlH1IGMNjhDn88w9eovEE8BbWo+KCvdlPPtPWC/iBTvHd4nG/
         P+h/0S1BbXNCTNk0g4csoBFUrNP5SMImBuiZmz2986Q32xU8hGNDNGkoO6dl4FVymST/
         PJIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718804479; x=1719409279;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Xq+r7usRX/S+4Xtw72+s6ED4D41EE/ebQwhi1xrEsac=;
        b=PoU1RSC9KwYdxiFASmunkZgBaH0wHrCntnZB/lvQO8K2AcQBsJOXR1dZSDMwKJHof+
         t0F/JeeiOuQBYxLdhHBVBdcrbV85+nxVy40FqqGZt7dktsG0xT1L+4MoRrikzll0aizB
         keVPyaY5cP5uNth365u9AgGigUenpA5/LIU838W9jhVTS329fc72eQLeW9t1URdrpd4S
         OZtBPvxdv8HEgSrwqXNBGQYJWZNdhzyJzeFzCSo6S3qW2fkQTE+6fOXuWg3WXNFxuSR9
         e0JEN2qpMro/jSBtA1pbPT1y/Dgc9Fw5uEuYzt+xGuq/2+fQmq3ZXXGEURFc3hibKZLp
         3jzw==
X-Gm-Message-State: AOJu0Yw8A0UIJiiQXwhKnJIiXDj4m9t040p19qCIT2MAEVGNOh71E8D6
	HqzLA7L9lmdGOI23Z4Y7+lLrrHpB2TCA1rD3eabopuzF96F6UtKfVymQKcAQuju9VcVKeouC1oo
	WLu1Mr5ySZzENLD4TuZXjC9STwNI=
X-Google-Smtp-Source: AGHT+IHAxrkbW8tTRLluOV8D0Dh87IDRZSSauJptbq/0i/C0K3w9s8M1TK6Rtm4KpV501gXV7C9tjCUMu+zc2X7Idrg=
X-Received: by 2002:a17:906:9c92:b0:a6e:f533:ce28 with SMTP id
 a640c23a62f3a-a6fab6071cfmr201835866b.12.1718804479113; Wed, 19 Jun 2024
 06:41:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240618173053.364776-1-jamestiotio@gmail.com>
 <20240618173053.364776-4-jamestiotio@gmail.com> <20240619-3ba7acf7b1504529899f6cc9@orel>
In-Reply-To: <20240619-3ba7acf7b1504529899f6cc9@orel>
From: James R T <jamestiotio@gmail.com>
Date: Wed, 19 Jun 2024 21:40:42 +0800
Message-ID: <CAA_Li+uQqXxb7REhDX6pzX0-T+p-WdmBcvJk9ZLK9p7TF6MtjQ@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH 3/4] riscv: Add methods to toggle interrupt
 enable bits
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, atishp@rivosinc.com, 
	cade.richard@berkeley.edu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 19, 2024 at 4:39=E2=80=AFPM Andrew Jones <andrew.jones@linux.de=
v> wrote:
>
> On Wed, Jun 19, 2024 at 01:30:52AM GMT, James Raphael Tiovalen wrote:
> > Add some helper methods to toggle the interrupt enable bits in the SIE
> > register.
> >
> > Signed-off-by: James Raphael Tiovalen <jamestiotio@gmail.com>
> > ---
> >  riscv/Makefile            |  1 +
> >  lib/riscv/asm/csr.h       |  7 +++++++
> >  lib/riscv/asm/interrupt.h | 12 ++++++++++++
> >  lib/riscv/interrupt.c     | 39 +++++++++++++++++++++++++++++++++++++++
> >  4 files changed, 59 insertions(+)
> >  create mode 100644 lib/riscv/asm/interrupt.h
> >  create mode 100644 lib/riscv/interrupt.c
> >
> > diff --git a/riscv/Makefile b/riscv/Makefile
> > index 919a3ebb..108d4481 100644
> > --- a/riscv/Makefile
> > +++ b/riscv/Makefile
> > @@ -30,6 +30,7 @@ cflatobjs +=3D lib/memregions.o
> >  cflatobjs +=3D lib/on-cpus.o
> >  cflatobjs +=3D lib/vmalloc.o
> >  cflatobjs +=3D lib/riscv/bitops.o
> > +cflatobjs +=3D lib/riscv/interrupt.o
> >  cflatobjs +=3D lib/riscv/io.o
> >  cflatobjs +=3D lib/riscv/isa.o
> >  cflatobjs +=3D lib/riscv/mmu.o
> > diff --git a/lib/riscv/asm/csr.h b/lib/riscv/asm/csr.h
> > index c1777744..da58b0ce 100644
> > --- a/lib/riscv/asm/csr.h
> > +++ b/lib/riscv/asm/csr.h
> > @@ -4,15 +4,22 @@
> >  #include <linux/const.h>
> >
> >  #define CSR_SSTATUS          0x100
> > +#define CSR_SIE                      0x104
> >  #define CSR_STVEC            0x105
> >  #define CSR_SSCRATCH         0x140
> >  #define CSR_SEPC             0x141
> >  #define CSR_SCAUSE           0x142
> >  #define CSR_STVAL            0x143
> > +#define CSR_SIP                      0x144
> >  #define CSR_SATP             0x180
> >
> >  #define SSTATUS_SIE          (_AC(1, UL) << 1)
> >
> > +#define SIE_SSIE             (_AC(1, UL) << 1)
> > +#define SIE_STIE             (_AC(1, UL) << 5)
> > +#define SIE_SEIE             (_AC(1, UL) << 9)
> > +#define SIE_LCOFIE           (_AC(1, UL) << 13)
> > +
> >  /* Exception cause high bit - is an interrupt if set */
> >  #define CAUSE_IRQ_FLAG               (_AC(1, UL) << (__riscv_xlen - 1)=
)
> >
> > diff --git a/lib/riscv/asm/interrupt.h b/lib/riscv/asm/interrupt.h
> > new file mode 100644
> > index 00000000..b760afbb
> > --- /dev/null
> > +++ b/lib/riscv/asm/interrupt.h
> > @@ -0,0 +1,12 @@
> > +/* SPDX-License-Identifier: GPL-2.0-only */
> > +#ifndef _ASMRISCV_INTERRUPT_H_
> > +#define _ASMRISCV_INTERRUPT_H_
> > +
> > +#include <stdbool.h>
> > +
> > +void toggle_software_interrupt(bool enable);
> > +void toggle_timer_interrupt(bool enable);
> > +void toggle_external_interrupt(bool enable);
> > +void toggle_local_cof_interrupt(bool enable);
> > +
> > +#endif /* _ASMRISCV_INTERRUPT_H_ */
> > diff --git a/lib/riscv/interrupt.c b/lib/riscv/interrupt.c
> > new file mode 100644
> > index 00000000..bc0e16f1
> > --- /dev/null
> > +++ b/lib/riscv/interrupt.c
> > @@ -0,0 +1,39 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/*
> > + * Copyright (C) 2024, James Raphael Tiovalen <jamestiotio@gmail.com>
> > + */
> > +#include <libcflat.h>
> > +#include <asm/csr.h>
> > +#include <asm/interrupt.h>
> > +
> > +void toggle_software_interrupt(bool enable)
> > +{
> > +     if (enable)
> > +             csr_set(CSR_SIE, SIE_SSIE);
> > +     else
> > +             csr_clear(CSR_SIE, SIE_SSIE);
> > +}
> > +
> > +void toggle_timer_interrupt(bool enable)
> > +{
> > +     if (enable)
> > +             csr_set(CSR_SIE, SIE_STIE);
> > +     else
> > +             csr_clear(CSR_SIE, SIE_STIE);
> > +}
> > +
> > +void toggle_external_interrupt(bool enable)
> > +{
> > +     if (enable)
> > +             csr_set(CSR_SIE, SIE_SEIE);
> > +     else
> > +             csr_clear(CSR_SIE, SIE_SEIE);
> > +}
> > +
> > +void toggle_local_cof_interrupt(bool enable)
> > +{
> > +     if (enable)
> > +             csr_set(CSR_SIE, SIE_LCOFIE);
> > +     else
> > +             csr_clear(CSR_SIE, SIE_LCOFIE);
> > +}
> > --
> > 2.43.0
> >
>
> Most of this patch seems premature since the series only needs
> toggle_timer_interrupt(). Also, I think lib/riscv/interrupt.c
> is premature because something like toggle_timer_interrupt()
> can be a static inline in a new lib/riscv/asm/timer.h file.
>

Got it. In that case, I will combine the changes with the actual test
since we will be adding only the timer interrupt code.

> And please provide two functions rather than a toggle with
> a parameter, i.e.
>
>   timer_interrupt_enable() / timer_interrupt_disable()
>

Sure, will do that.

> Thanks,
> drew

Best regards,
James Raphael Tiovalen

