Return-Path: <kvm+bounces-1957-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EFC4A7EF38B
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 14:11:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2C5D51C20905
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 13:11:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5774331741;
	Fri, 17 Nov 2023 13:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="0Jh9IEnc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20312D57
	for <kvm@vger.kernel.org>; Fri, 17 Nov 2023 05:11:35 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id 98e67ed59e1d1-28039ee1587so1533750a91.2
        for <kvm@vger.kernel.org>; Fri, 17 Nov 2023 05:11:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1700226694; x=1700831494; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6E9rdo8qzUdOfFpLyb8P/NwaQhOJy8xXp5m1DZcVMbs=;
        b=0Jh9IEncApe3dbjC0pYFA6uGR96saTAaIoi1TMkeMwBv+5Oswt9hbuRJ9gjctTfZVv
         iMeoPeCv+tjez7DDFpZGYLpF/ix0UIse7qdmeKx/YKD6UZaOaF7s2Bl3/WoIOM9npcJd
         k4/VCKT43U6Ra9sPQiQL9xyaRHnRTWiEf4CJTybfC2jSvKB1gUsMrvLdklhzT079E9Qx
         5BnVRW2uSlZ6PyUutWCMgFdYUrAQzM88i0AJaWuN/lB0lsAmhPJ8HMEuP5gsxlx+c+XF
         GIFUUTcqdZL38LIARq68Z1xfFsG4inBCIhfeqGKvd1EODnp9bSBmRUGQlvHWoiGIvVqs
         sjiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700226694; x=1700831494;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6E9rdo8qzUdOfFpLyb8P/NwaQhOJy8xXp5m1DZcVMbs=;
        b=YzmUnuzFwVwmCNmRbELpo/yDFYoBNLZr7/KjyTviKtDx6M6CahNfDI6zo5RWDD5PjE
         mMlAl82KtmidBCDqOpQvzOL1I++TMA8IDMDPky8R3fxRtRGFBu+L0cl9ydRuAJ08x99F
         hk9APxcO+YkeZv3USc5ouq4xN9NIzq4WnmkDg6pg8xbi/96FusS6xv3WydgJpCIIIcF5
         5fZFvkkRN6uhgbMioYXI0zAg90NJ1ub5Rz2lpr9pWtc7ZHX+n0qM4+EVD8P5pFptzs1O
         VWU7Ot3UxeBE/MjpKw8UqySIPaeUIp6NIHPxPd+sYIa4Eu1CAQO77lHd1N/kKMxB9dKz
         s6Qw==
X-Gm-Message-State: AOJu0YwAeOxGQASq28kvi++RJvTFSA1c2XfdLyZAzPD1q6BA1LFhmrl0
	TJ3n2thEbK5YzLptNOrp/lLzKfGWvQLwJWA6soNFQg==
X-Google-Smtp-Source: AGHT+IFgkLOaY0/DJgU/R9AI39sZ+6DPT8zwZKvyF4UaFzfmMFJIGvIF2iBAT0bJLBWK5QSv+GXZ5swJVYptGL1IhU4=
X-Received: by 2002:a17:90a:974a:b0:281:3a4a:2e61 with SMTP id
 i10-20020a17090a974a00b002813a4a2e61mr14672875pjw.14.1700226694377; Fri, 17
 Nov 2023 05:11:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231020072140.900967-1-apatel@ventanamicro.com>
 <20231020072140.900967-9-apatel@ventanamicro.com> <2023102153-retread-narrow-54ee@gregkh>
In-Reply-To: <2023102153-retread-narrow-54ee@gregkh>
From: Anup Patel <anup@brainfault.org>
Date: Fri, 17 Nov 2023 18:41:23 +0530
Message-ID: <CAAhSdy1T-Ca7V21SSW=UCByujv39te7wRYGm40ZqDQ-JxH6pbA@mail.gmail.com>
Subject: Re: [PATCH v3 8/9] tty: Add SBI debug console support to HVC SBI driver
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Anup Patel <apatel@ventanamicro.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Atish Patra <atishp@atishpatra.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Jiri Slaby <jirislaby@kernel.org>, 
	Conor Dooley <conor@kernel.org>, Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-serial@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-kernel@vger.kernel.org, Atish Patra <atishp@rivosinc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 21, 2023 at 10:16=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Fri, Oct 20, 2023 at 12:51:39PM +0530, Anup Patel wrote:
> > From: Atish Patra <atishp@rivosinc.com>
> >
> > RISC-V SBI specification supports advanced debug console
> > support via SBI DBCN extension.
> >
> > Extend the HVC SBI driver to support it.
> >
> > Signed-off-by: Atish Patra <atishp@rivosinc.com>
> > Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> > ---
> >  drivers/tty/hvc/Kconfig         |  2 +-
> >  drivers/tty/hvc/hvc_riscv_sbi.c | 82 ++++++++++++++++++++++++++++++---
> >  2 files changed, 76 insertions(+), 8 deletions(-)
> >
> > diff --git a/drivers/tty/hvc/Kconfig b/drivers/tty/hvc/Kconfig
> > index 4f9264d005c0..6e05c5c7bca1 100644
> > --- a/drivers/tty/hvc/Kconfig
> > +++ b/drivers/tty/hvc/Kconfig
> > @@ -108,7 +108,7 @@ config HVC_DCC_SERIALIZE_SMP
> >
> >  config HVC_RISCV_SBI
> >       bool "RISC-V SBI console support"
> > -     depends on RISCV_SBI_V01
> > +     depends on RISCV_SBI
> >       select HVC_DRIVER
> >       help
> >         This enables support for console output via RISC-V SBI calls, w=
hich
> > diff --git a/drivers/tty/hvc/hvc_riscv_sbi.c b/drivers/tty/hvc/hvc_risc=
v_sbi.c
> > index 31f53fa77e4a..56da1a4b5aca 100644
> > --- a/drivers/tty/hvc/hvc_riscv_sbi.c
> > +++ b/drivers/tty/hvc/hvc_riscv_sbi.c
> > @@ -39,21 +39,89 @@ static int hvc_sbi_tty_get(uint32_t vtermno, char *=
buf, int count)
> >       return i;
> >  }
> >
> > -static const struct hv_ops hvc_sbi_ops =3D {
> > +static const struct hv_ops hvc_sbi_v01_ops =3D {
> >       .get_chars =3D hvc_sbi_tty_get,
> >       .put_chars =3D hvc_sbi_tty_put,
> >  };
> >
> > -static int __init hvc_sbi_init(void)
> > +static int hvc_sbi_dbcn_tty_put(uint32_t vtermno, const char *buf, int=
 count)
> >  {
> > -     return PTR_ERR_OR_ZERO(hvc_alloc(0, 0, &hvc_sbi_ops, 16));
> > +     phys_addr_t pa;
> > +     struct sbiret ret;
> > +
> > +     if (is_vmalloc_addr(buf)) {
> > +             pa =3D page_to_phys(vmalloc_to_page(buf)) + offset_in_pag=
e(buf);
> > +             if (PAGE_SIZE < (offset_in_page(buf) + count))
> > +                     count =3D PAGE_SIZE - offset_in_page(buf);
> > +     } else {
> > +             pa =3D __pa(buf);
> > +     }
> > +
> > +     if (IS_ENABLED(CONFIG_32BIT))
> > +             ret =3D sbi_ecall(SBI_EXT_DBCN, SBI_EXT_DBCN_CONSOLE_WRIT=
E,
> > +                             count, lower_32_bits(pa), upper_32_bits(p=
a),
> > +                             0, 0, 0);
> > +     else
> > +             ret =3D sbi_ecall(SBI_EXT_DBCN, SBI_EXT_DBCN_CONSOLE_WRIT=
E,
> > +                             count, pa, 0, 0, 0, 0);
>
> Again, you need a helper function here to keep you from having to keep
> this all in sync.

Sure, I will update.

>
> > +     if (ret.error)
> > +             return 0;
> > +
> > +     return count;
> >  }
> > -device_initcall(hvc_sbi_init);
> >
> > -static int __init hvc_sbi_console_init(void)
> > +static int hvc_sbi_dbcn_tty_get(uint32_t vtermno, char *buf, int count=
)
> >  {
> > -     hvc_instantiate(0, 0, &hvc_sbi_ops);
> > +     phys_addr_t pa;
> > +     struct sbiret ret;
> > +
> > +     if (is_vmalloc_addr(buf)) {
> > +             pa =3D page_to_phys(vmalloc_to_page(buf)) + offset_in_pag=
e(buf);
> > +             if (PAGE_SIZE < (offset_in_page(buf) + count))
> > +                     count =3D PAGE_SIZE - offset_in_page(buf);
> > +     } else {
> > +             pa =3D __pa(buf);
> > +     }
> > +
> > +     if (IS_ENABLED(CONFIG_32BIT))
> > +             ret =3D sbi_ecall(SBI_EXT_DBCN, SBI_EXT_DBCN_CONSOLE_READ=
,
> > +                             count, lower_32_bits(pa), upper_32_bits(p=
a),
> > +                             0, 0, 0);
> > +     else
> > +             ret =3D sbi_ecall(SBI_EXT_DBCN, SBI_EXT_DBCN_CONSOLE_READ=
,
> > +                             count, pa, 0, 0, 0, 0);
>
> And here too.

Okay.

>
> thanks,
>
> greg k-h

Regards,
Anup

