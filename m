Return-Path: <kvm+bounces-19986-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 35D9F90EF23
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 15:36:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AF078282123
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 13:36:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9123147C6E;
	Wed, 19 Jun 2024 13:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E733mlRd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5073313E409
	for <kvm@vger.kernel.org>; Wed, 19 Jun 2024 13:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718804187; cv=none; b=ADTxI7mb133Z9pF7wSzH/cPQw6HI5Ao0i+rkZwHuJ6MYvXu05MLJKUGetHj+X1J/3gJ/Ij3sJSMGFCz3qhnjrr1Z0wpL0Yx6tem9GCKv0IthSh6U2Wn0XiT8FmSr6r/K5yuBRkxM+0vxL9EtGikAmeS8l6gBWUAkcTOJEPvFw2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718804187; c=relaxed/simple;
	bh=RClfDAaqlaWzIb2pRv5XURd48wHUXfxk1/AW9bwZ+nM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uR0SitsK3BkiQ7CEkHETZUM+A3JuqCQRNjXwQ6ADb+M1dN5rlUXkGYcqf+MrnoEJdHpH4slklubonznwak+5jnlk/Tm1WRwqDz/9Sd8LlR0eFnmGkehJvclDgcleWi8p7TLEtipya0QCdbzptzxROjnMXodTQheNReQZRecwYg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E733mlRd; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-57cfe600cbeso2353932a12.2
        for <kvm@vger.kernel.org>; Wed, 19 Jun 2024 06:36:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718804183; x=1719408983; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I2OnyNb00PPiJfAupCSEqWZwKF3Uec55akA8mnPmH/s=;
        b=E733mlRd0WB3Zon+54onBwuwD8Zj4NpCZa5JndwLmIjKxO0ud6gbykXrqREBvD0Q3U
         hb9bDgKJeATbtQHeCalBdjiqpt/nzUBBMJhAuO3NlMKtqKUPd1F3MSY4/sj9+buFCaiu
         ARxcaFGd7m1OETFfsmSkJU4UVixwDzNWSZNz5HJp0R+6qIPm8oiU6OTOnaLxnycy8mxP
         o6iiGznM7411JicCJ4ARTI+8k1C0JumyjPEJfTCuNGqPmMtipjwAVXIz9LDvxU1XVyCz
         ESAhd4k0I8awui58nWcWycVG6Ul6+jgFHYCR9SoUBMfWWpt6/jU1HQyVz0D8BSmDHu8s
         SmZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718804183; x=1719408983;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I2OnyNb00PPiJfAupCSEqWZwKF3Uec55akA8mnPmH/s=;
        b=ef19XNGMegldETB9sWO/eaf2LDGcgeqsQu2WeHAtFwvg8Jb9sPwaCNrpjcKeBJn6an
         DwXyVmtRlSqOLg0SU3DgZKH9Dg2WVbk4vB/Sai2+69+uApRnWLewAfcSDq/iYK1SDsly
         HYejRWuFRhx8VDxts6wwtUWRqvjmggUOteiBzeqTMT9ZMCJkfJpBDxDuBxu87NFAjfzu
         qJGjdHHZJ9gKLAvmtakoWxPVPlYGhc4/hKL8pTe1gCLuqsCdCanLyV+j2LWuwTH2FGKg
         svSRBHyz7Bb7k6soJHBdw/CtCrtnt6Mb1KKVQ7jml1xeDN0Cil4s2vfA0blR9lNErQMG
         Jqww==
X-Gm-Message-State: AOJu0YywJqBYrqXz3XPnEuA5Qna6OjE5caAjIJhQfoIYPU4d/T3txXb3
	39lpsIjIo4/ITBim0hgAMG9eoGT9UE24ZEXb2ehqNQAVRjryXYjowtr61aQG8LoS5pxCyr5MtFT
	EPUFkAh8yUX+vfswm72t9auIdEAiXP0KmXvY=
X-Google-Smtp-Source: AGHT+IHhXUB+Ta6Niwe8JtqaaThuytuBChGgs32YZyobNgyY84HF5jAq9luuT8Qj+BUvdJBT94gepezFtq7ZosyWbL8=
X-Received: by 2002:a50:baa5:0:b0:57c:ff70:5429 with SMTP id
 4fb4d7f45d1cf-57d07e670a2mr1262757a12.8.1718804182023; Wed, 19 Jun 2024
 06:36:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240618173053.364776-1-jamestiotio@gmail.com>
 <20240618173053.364776-3-jamestiotio@gmail.com> <20240619-5747f9b7cf121c71889128a7@orel>
In-Reply-To: <20240619-5747f9b7cf121c71889128a7@orel>
From: James R T <jamestiotio@gmail.com>
Date: Wed, 19 Jun 2024 21:35:45 +0800
Message-ID: <CAA_Li+sJaPbouAGJ7+kmSJnTgT83UtATVjybYbeU3JkgsiE8jA@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH 2/4] riscv: Update exception cause list
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, atishp@rivosinc.com, 
	cade.richard@berkeley.edu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 19, 2024 at 4:31=E2=80=AFPM Andrew Jones <andrew.jones@linux.de=
v> wrote:
>
> On Wed, Jun 19, 2024 at 01:30:51AM GMT, James Raphael Tiovalen wrote:
> > Update the list of exception and interrupt causes to follow the latest
> > RISC-V privileged ISA specification (version 20240411).
> >
> > Signed-off-by: James Raphael Tiovalen <jamestiotio@gmail.com>
> > ---
> >  lib/riscv/asm/csr.h       | 15 +++++++++------
> >  lib/riscv/asm/processor.h |  2 +-
> >  2 files changed, 10 insertions(+), 7 deletions(-)
> >
> > diff --git a/lib/riscv/asm/csr.h b/lib/riscv/asm/csr.h
> > index d5879d2a..c1777744 100644
> > --- a/lib/riscv/asm/csr.h
> > +++ b/lib/riscv/asm/csr.h
> > @@ -26,15 +26,18 @@
> >  #define EXC_STORE_MISALIGNED 6
> >  #define EXC_STORE_ACCESS     7
> >  #define EXC_SYSCALL          8
> > -#define EXC_HYPERVISOR_SYSCALL       9
> > -#define EXC_SUPERVISOR_SYSCALL       10
> > +#define EXC_SUPERVISOR_SYSCALL       9
> >  #define EXC_INST_PAGE_FAULT  12
> >  #define EXC_LOAD_PAGE_FAULT  13
> >  #define EXC_STORE_PAGE_FAULT 15
> > -#define EXC_INST_GUEST_PAGE_FAULT    20
> > -#define EXC_LOAD_GUEST_PAGE_FAULT    21
> > -#define EXC_VIRTUAL_INST_FAULT               22
> > -#define EXC_STORE_GUEST_PAGE_FAULT   23
> > +#define EXC_SOFTWARE_CHECK   18
> > +#define EXC_HARDWARE_ERROR   19
>
> The above changes don't update the exception cause list to the latest
> spec, they drop the defines supporting the hypervisor extension's
> augmentations (see Section 18.6.1 of the 20240411 priv spec).
>

Right, I missed that section. I only checked Section 10.1.8. I will
update this list accordingly.

> > +
> > +/* Interrupt causes */
> > +#define IRQ_SUPERVISOR_SOFTWARE      1
> > +#define IRQ_SUPERVISOR_TIMER 5
> > +#define IRQ_SUPERVISOR_EXTERNAL      9
> > +#define IRQ_COUNTER_OVERFLOW 13
>
> These are fine, but we could also add the defines for the hypervisor
> extension's augmentations. I also usually just copy+paste the defines
> from Linux since I prefer name consistency.
>

Sure, I will do that.

> >
> >  #ifndef __ASSEMBLY__
> >
> > diff --git a/lib/riscv/asm/processor.h b/lib/riscv/asm/processor.h
> > index 767b1caa..5942ed2e 100644
> > --- a/lib/riscv/asm/processor.h
> > +++ b/lib/riscv/asm/processor.h
> > @@ -4,7 +4,7 @@
> >  #include <asm/csr.h>
> >  #include <asm/ptrace.h>
> >
> > -#define EXCEPTION_CAUSE_MAX  16
> > +#define EXCEPTION_CAUSE_MAX  64
>
> If we want to test the H extension, then we'll want 20-23, but everything
> else is custom or reserved, so we don't need to allocate handler pointer
> space all the way up to 64 as they'll never be used.
>

In that case, I will keep it to 24 then.

> Thanks,
> drew
>
> >  #define INTERRUPT_CAUSE_MAX  16
> >
> >  typedef void (*exception_fn)(struct pt_regs *);
> > --
> > 2.43.0
> >
> >
> > --
> > kvm-riscv mailing list
> > kvm-riscv@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/kvm-riscv

Best regards,
James Raphael Tiovalen

