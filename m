Return-Path: <kvm+bounces-50701-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 49B4AAE8688
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 16:31:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EF1DA3A4E2B
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 14:31:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D221262FF1;
	Wed, 25 Jun 2025 14:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="gRb5MY1h"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vk1-f176.google.com (mail-vk1-f176.google.com [209.85.221.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E40E24A06F
	for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 14:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750861901; cv=none; b=X49fm6+VwqUpHslm5UQD/S5JYgKcvomRpSeDzG4j+l9+5JCz15uZAj2S4cbXiXsye72fDUy61PioMxOqkt4+/Cj9UQ4DaIN3DUxc2itbYTzPNu1prjqVW5uxxvTO5UVDzkEEYZP1z7Jh3xEFV/sZH66JBHNdKp3vf/0AinEDCWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750861901; c=relaxed/simple;
	bh=3I+gVkx1zcSeZSI2kzpQRJ2nZN33b8k+5p4GFpApePc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ws3WWsReWlbx6Z07O61vSYP7fQ5UK8ow6p0G/3QTLNQKkSDTy5xiathi/I8bOJMqiN/FV+s0fEqxdISEzbGcrHjWQBt+dZyCH1TZn2Xaf/4AfeBeRrUyrM4Mv9R6MAEXw7o4WKWKiemUkeCurlp23OrXa/jWi/00NAiS0681x/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=gRb5MY1h; arc=none smtp.client-ip=209.85.221.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-vk1-f176.google.com with SMTP id 71dfb90a1353d-52b2290e290so3652199e0c.1
        for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 07:31:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1750861898; x=1751466698; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rNEFN1NKG+swatDYQI6HrjoJU0jdsCu1bPMlAu48h0g=;
        b=gRb5MY1hNyX9AbKuC0qHV+NKna/hNqkA4jrhDwFkSbvhk5ynG61QJ3CLDA3+txtppi
         h7NzWAgRvCzeDFogDB3qURrBkyoZAS5sXNDeUrMWYr145rw9pgvAEJ0ZvFCyEM3k+mhl
         w3ntA65gSTsLSl1Bbh/JkIsMENjAIxYTqaXq6pOFzK0s7hFxgkcSVVqMTos96yutNgB/
         cbRIspBcAl0l0IE+bvCUycOBIX7awXqCO52WNy50+a5gjt//tU4yA2eULrp3nTVHW2AW
         CcOT7UByeSimGZivC1cmlOnr/ZFn7n6w9xUKIQx1eERO2jYxtx8y1So/hAkmg86oM6b1
         ZlIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750861898; x=1751466698;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rNEFN1NKG+swatDYQI6HrjoJU0jdsCu1bPMlAu48h0g=;
        b=gyRvfi5P9uWSe8kpvIMNyVyOLz3Haaqst0G4HmV0woH2CzgJnHfHBYCfibKzHBOr3J
         70JLg2zz7h8XCBjEDjkP8rl65E0fRcYxCa8n9XtA4dWNlc6+wEjHO/QI3ydmN/DTpU7N
         5WNWemlS6hiFCQUb3ewDZCR7B95EKjqmWgwT8UnVkUL1EfMpUfihnxeuyxuM++ixUS32
         4m9Uhm9jpVpZp+58hE2G/+sJgH4Ulco0O+/jVEemUiGZbSOXW9Kj6QM0z+l05+EwkIO8
         laXWiEiMJ7rT8X03N2KGePi7FPNfhkUy8q6v3bcT5SyQzdGYZUylpJreMEjVlEDNTXAI
         80mw==
X-Gm-Message-State: AOJu0YwlBe8IKUv235MzN1oWJZ8Dsa8pc88YRSOXtyg4/hYT3vcHlT9N
	PqDVDS/qGQZYpZQ0r9cvhaawsBqPMGfOQ80LhN5ARcVhq1r1rB+Xh3KTVPLmaGr7GcaVrY05Xde
	sCGFRtn6sxy7euRagLo9T76ciB17f0njwYgfxNrBhJA==
X-Gm-Gg: ASbGncuUfDBVNId3auww0tcwNfyAWT26utJeriZStNG3qxWv2tkYfnleYJ/6epTOUSa
	kDlyJ5MmiI3a6Q/uJTTV2uM7EOYl2g5uVomk283Y7UbBTI3IyxsLa/NRpZrh09LB5tfoOpvjS31
	v4P7Bv9J3gXN297Us7qAnN24g5fJG52XRfUDvCGcEBetz2
X-Google-Smtp-Source: AGHT+IFKZk8yDb57dXdu1goU1780yjICESJYQ6+NBRPRFD400b1dsKCn0S2Grq/YbRlUVTvVl3LuPip1M1XE7G/Op0c=
X-Received: by 2002:a05:6122:438b:b0:52a:79fd:34bd with SMTP id
 71dfb90a1353d-532ef3d28c7mr2189962e0c.4.1750861898326; Wed, 25 Jun 2025
 07:31:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250624192317.278437-1-jesse@rivosinc.com> <20250625-fc81fec2cf6d7ee195c0eb6c@orel>
In-Reply-To: <20250625-fc81fec2cf6d7ee195c0eb6c@orel>
From: Jesse Taube <jesse@rivosinc.com>
Date: Wed, 25 Jun 2025 07:31:27 -0700
X-Gm-Features: Ac12FXyDu2tWflqx0iVeOG6H8MMrg5H_8TMwkiqA4xvmkjqXYVxH_T-zC7snMds
Message-ID: <CALSpo=ZsEEQeoYz2dby9B4zgbFcxCzmjN9SH8Jch4Avvm14Cog@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v2] riscv: lib: sbi_shutdown add pass/fail
 exit code.
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-kselftest@vger.kernel.org, =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>, 
	Charlie Jenkins <charlie@rivosinc.com>, James Raphael Tiovalen <jamestiotio@gmail.com>, 
	Sean Christopherson <seanjc@google.com>, Cade Richard <cade.richard@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 25, 2025 at 1:33=E2=80=AFAM Andrew Jones <andrew.jones@linux.de=
v> wrote:
>
> On Tue, Jun 24, 2025 at 12:23:17PM -0700, Jesse Taube wrote:
> > When exiting it may be useful for the sbi implementation to know if
> > kvm-unit-tests passed or failed.
> > Add exit code to sbi_shutdown, and use it in exit() to pass
> > success/failure (0/1) to sbi.
> >
> > Signed-off-by: Jesse Taube <jesse@rivosinc.com>
> > ---
> >  lib/riscv/asm/sbi.h | 2 +-
> >  lib/riscv/io.c      | 2 +-
> >  lib/riscv/sbi.c     | 4 ++--
> >  3 files changed, 4 insertions(+), 4 deletions(-)
> >
> > diff --git a/lib/riscv/asm/sbi.h b/lib/riscv/asm/sbi.h
> > index a5738a5c..de11c109 100644
> > --- a/lib/riscv/asm/sbi.h
> > +++ b/lib/riscv/asm/sbi.h
> > @@ -250,7 +250,7 @@ struct sbiret sbi_ecall(int ext, int fid, unsigned =
long arg0,
> >                       unsigned long arg3, unsigned long arg4,
> >                       unsigned long arg5);
> >
> > -void sbi_shutdown(void);
> > +void sbi_shutdown(unsigned int code);
> >  struct sbiret sbi_hart_start(unsigned long hartid, unsigned long entry=
, unsigned long sp);
> >  struct sbiret sbi_hart_stop(void);
> >  struct sbiret sbi_hart_get_status(unsigned long hartid);
> > diff --git a/lib/riscv/io.c b/lib/riscv/io.c
> > index fb40adb7..0bde25d4 100644
> > --- a/lib/riscv/io.c
> > +++ b/lib/riscv/io.c
> > @@ -150,7 +150,7 @@ void halt(int code);
> >  void exit(int code)
> >  {
> >       printf("\nEXIT: STATUS=3D%d\n", ((code) << 1) | 1);
> > -     sbi_shutdown();
> > +     sbi_shutdown(!!code);
> >       halt(code);
> >       __builtin_unreachable();
> >  }
> > diff --git a/lib/riscv/sbi.c b/lib/riscv/sbi.c
> > index 2959378f..9dd11e9d 100644
> > --- a/lib/riscv/sbi.c
> > +++ b/lib/riscv/sbi.c
> > @@ -107,9 +107,9 @@ struct sbiret sbi_sse_inject(unsigned long event_id=
, unsigned long hart_id)
> >       return sbi_ecall(SBI_EXT_SSE, SBI_EXT_SSE_INJECT, event_id, hart_=
id, 0, 0, 0, 0);
> >  }
> >
> > -void sbi_shutdown(void)
> > +void sbi_shutdown(unsigned int code)
> >  {
> > -     sbi_ecall(SBI_EXT_SRST, 0, 0, 0, 0, 0, 0, 0);
> > +     sbi_ecall(SBI_EXT_SRST, 0, 0, code, 0, 0, 0, 0);
> >       puts("SBI shutdown failed!\n");
> >  }
> >
> > --
> > 2.43.0
> >
>
> I enhanced the commit message, changed the parameter to a boolean, and
> applied to riscv/sbi
>
> https://gitlab.com/jones-drew/kvm-unit-tests/-/commits/riscv/sbi
>
> but I'm having some second thoughts on it. It looks like opensbi and the
> two KVM VMMs I looked at (QEMU and kvmtool) all currently ignore this
> parameter and we don't know what they might choose to do if they stop
> ignoring it.

For the default syscon QEMU doesn't ignore it and exits with the exit
code given.
https://gitlab.com/qemu-project/qemu/-/blob/master/hw/misc/sifive_test.c?re=
f_type=3Dheads#L44

Both RustSBI and BBL implement the sifive_test device correctly and
provide an exit code,
OpenSBI ignores it, though it is trivial to add it.
https://github.com/rustsbi/rustsbi/blob/main/prototyper/prototyper/src/plat=
form/reset.rs#L21
https://github.com/riscv-software-src/riscv-pk/blob/master/machine/finisher=
.c#L15

> For example, they could choose to hang, rather than complete
> the shutdown when they see a "system failure" reason. It may make sense
> to indicate system failure if the test aborts, since, in those cases,
> something unexpected with the testing occurred. However, successfully
> running tests which find and report failures isn't unexpected, so it
> shouldn't raise an alarm to the SBI implementation in those cases.
>
> Do you already have a usecase for this in mind?

Yes making CI easier, as the exit code is passed to QEMU rather than
having to parse the text.

> If so, we could make
> the behavior optional to enable that use case and use cases like it
> but we'd keep that behavior off by default to avoid problems with SBI
> implementations that do things with the "system failure" information we'd
> rather they not do.

Sure, do you want it to be a configure flag like  --console?

Thanks,
Jesse Taube

>
> Thanks,
> drew

