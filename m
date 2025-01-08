Return-Path: <kvm+bounces-34829-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id ACBF9A0648E
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 19:35:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 40AB41886157
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 18:35:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D7A6202C4D;
	Wed,  8 Jan 2025 18:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="jrpseMxo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C84D1202C47
	for <kvm@vger.kernel.org>; Wed,  8 Jan 2025 18:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736361263; cv=none; b=X+kpMuJdZpVap8Cw6I4VeYSctLhNT7xhMDqVUmz0JOT5TG0dNIlKWcNR7KHrGAzu+8QP8Mem9P/877KnQp64Bg44cQ5D1Kk3UgiWWrDwuSza22aHO3fUIZMIhHCx0XWCJY5boMB2aZ7HEYzTB3/xGfsLHHqJ9zCWITBvIxhHCDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736361263; c=relaxed/simple;
	bh=qnX46omGjPjC/q+gyDkJa+35YULFw89vPSSIZ7CduEc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RrZNVvyt8nq0ohY2Z0O6sI4wD/1K6c0xPaKSoxBpYsmOgzSiRIJPJ0hozrh+h7f1H4OPAVOLBaFW4/inS9FpmU69NYpAuo8JaTw+0WsHekbdaHP91wLaIo+41z6tvduW8eJZEb/OrwF8fEuoedh7KEuw3c2Pdz4LMwoQtujharM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=jrpseMxo; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2164b662090so600885ad.1
        for <kvm@vger.kernel.org>; Wed, 08 Jan 2025 10:34:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1736361260; x=1736966060; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DqnnjKkSHwAf9hrNplxrEhAq6xbb+daTfv8Q2VG5nP8=;
        b=jrpseMxoaVpRH8UJzjKdSlJwC/Bgqs9Dd7r8ux6xPvPMTWKR74QzAD9fUm8pU9qgFk
         +/IcQ9L+kr8xC8zO+uSDuquLbJzWokxaPoT+4LhN8E8nyka1alAejXBXjRGF5+I2SWHT
         GKtvdWWq9YaNnuRpo+hOGUoHWuN+Jt01uj/bC9sCSAMwpStFKzHk4R8CEUAra8JMEQOe
         /+58DqgvQLO0zaBYzA/5EHb8R0S7Q96F8JN29ZQCBeWsSN1qY0jxNyo3RTKUU9TLOsz+
         sH0gsGeZZk8ZYggIR6ReVkv6Swq6gwynZVbFYKO3XxHOxGen+BWSLOxc49PsiRMw5qdr
         n2Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736361260; x=1736966060;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DqnnjKkSHwAf9hrNplxrEhAq6xbb+daTfv8Q2VG5nP8=;
        b=r03HOiNVT0VmcKy5TiA124WS2+QIHCzgDDlb6aVl+W/hpvogaxHj1HESOAw2V1TdPh
         ldV2xaGxRSLUm+1X2Vitu1uQ9I8/XomaOtUx6CaNcz6RgQULJWE2esOrLTqpfONDddGD
         HYSiuNaZJdtQmZdYPEOa1Uw5Oj8mW0E/6TAKsM76ZW5WxmGDBAxBaEGxfr3Tly0K7p+J
         K7B2/kasCLzLaHaAZKZ4HyLdvgZAER6GQqnvaPSx2SXsydSgxuoP7Lj07Kgc8HZ05GZ2
         m7Y3yCYF/avhFL1NMsEkZvx+ge47zCuvoR38WqNscfeqT/1WA3FuA+B8qMCMUo4Ulp18
         WB1w==
X-Forwarded-Encrypted: i=1; AJvYcCUzw9DR0UdmaPoZydBGdTXLRcyM14fnJ8h5EQA9MqSC+779PEUjREohY9eoP7z90oZ6a8k=@vger.kernel.org
X-Gm-Message-State: AOJu0YziS0prrFiESI+wgfkX31L+bYF71n7PiWdhW8S2OQ35hXlVFQgi
	C/IZJkwFd495t5S46lybjPo7OBEyvaR2wfeMzWd0EHFXsAux3VoZXtmnR2I4Q/i/20x5BGarFTr
	0aEoH4jRjorUTp4f1LiiV/scVEdrSNoldQR3xFw==
X-Gm-Gg: ASbGnctgXXMSeJ9sDoU7PTCTa99RW72wGY4tjyMShLk1vQR8umiF+qxl4KPWzGaguBP
	kqaLkV7VTl0eSUjfy37E6vrPYvg7G0HsMGnK0
X-Google-Smtp-Source: AGHT+IHrzWD8hTKku+GnLUtLP/hFjQfbmE46eCWViow6nW8eTsYbms9nLnRbfU/2hi06gNkDgVP3C23j9Wgkgv5GB2I=
X-Received: by 2002:a05:6a00:6f0b:b0:725:e4b9:a600 with SMTP id
 d2e1a72fcca58-72d22048bf7mr4941908b3a.16.1736361260107; Wed, 08 Jan 2025
 10:34:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241125162200.1630845-1-cleger@rivosinc.com> <20241125162200.1630845-5-cleger@rivosinc.com>
 <20250108-522f238cc21ce59e16134c79@orel>
In-Reply-To: <20250108-522f238cc21ce59e16134c79@orel>
From: Atish Kumar Patra <atishp@rivosinc.com>
Date: Wed, 8 Jan 2025 10:34:09 -0800
X-Gm-Features: AbW1kvbKSIv8-fUX5pU5qDFEV3fgG-ZWJzHG9jd_bOk35dA9MC94SWhC5KY9vxA
Message-ID: <CAHBxVyFuuNpHjEgozfJxKS3RPoEqkHK=xFhouEsQ-eo_9kiptw@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v4 4/5] riscv: lib: Add SBI SSE extension definitions
To: Andrew Jones <andrew.jones@linux.dev>
Cc: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	Andrew Jones <ajones@ventanamicro.com>, Anup Patel <apatel@ventanamicro.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 8, 2025 at 5:03=E2=80=AFAM Andrew Jones <andrew.jones@linux.dev=
> wrote:
>
> On Mon, Nov 25, 2024 at 05:21:53PM +0100, Cl=C3=A9ment L=C3=A9ger wrote:
> > Add SBI SSE extension definitions in sbi.h
> >
> > Signed-off-by: Cl=C3=A9ment L=C3=A9ger <cleger@rivosinc.com>
> > ---
> >  lib/riscv/asm/sbi.h | 83 +++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 83 insertions(+)
> >
> > diff --git a/lib/riscv/asm/sbi.h b/lib/riscv/asm/sbi.h
> > index 98a9b097..a751d0c3 100644
> > --- a/lib/riscv/asm/sbi.h
> > +++ b/lib/riscv/asm/sbi.h
> > @@ -11,6 +11,11 @@
> >  #define SBI_ERR_ALREADY_AVAILABLE    -6
> >  #define SBI_ERR_ALREADY_STARTED              -7
> >  #define SBI_ERR_ALREADY_STOPPED              -8
> > +#define SBI_ERR_NO_SHMEM             -9
> > +#define SBI_ERR_INVALID_STATE                -10
> > +#define SBI_ERR_BAD_RANGE            -11
> > +#define SBI_ERR_TIMEOUT                      -12
> > +#define SBI_ERR_IO                   -13
> >
> >  #ifndef __ASSEMBLY__
> >  #include <cpumask.h>
> > @@ -23,6 +28,7 @@ enum sbi_ext_id {
> >       SBI_EXT_SRST =3D 0x53525354,
> >       SBI_EXT_DBCN =3D 0x4442434E,
> >       SBI_EXT_SUSP =3D 0x53555350,
> > +     SBI_EXT_SSE =3D 0x535345,
> >  };
> >
> >  enum sbi_ext_base_fid {
> > @@ -71,6 +77,83 @@ enum sbi_ext_dbcn_fid {
> >       SBI_EXT_DBCN_CONSOLE_WRITE_BYTE,
> >  };
> >
> > +enum sbi_ext_sse_fid {
> > +     SBI_EXT_SSE_READ_ATTRS =3D 0,
> > +     SBI_EXT_SSE_WRITE_ATTRS,
> > +     SBI_EXT_SSE_REGISTER,
> > +     SBI_EXT_SSE_UNREGISTER,
> > +     SBI_EXT_SSE_ENABLE,
> > +     SBI_EXT_SSE_DISABLE,
> > +     SBI_EXT_SSE_COMPLETE,
> > +     SBI_EXT_SSE_INJECT,
> > +     SBI_EXT_SSE_HART_UNMASK,
> > +     SBI_EXT_SSE_HART_MASK,
> > +};
> > +
> > +/* SBI SSE Event Attributes. */
> > +enum sbi_sse_attr_id {
> > +     SBI_SSE_ATTR_STATUS             =3D 0x00000000,
> > +     SBI_SSE_ATTR_PRIORITY           =3D 0x00000001,
> > +     SBI_SSE_ATTR_CONFIG             =3D 0x00000002,
> > +     SBI_SSE_ATTR_PREFERRED_HART     =3D 0x00000003,
> > +     SBI_SSE_ATTR_ENTRY_PC           =3D 0x00000004,
> > +     SBI_SSE_ATTR_ENTRY_ARG          =3D 0x00000005,
> > +     SBI_SSE_ATTR_INTERRUPTED_SEPC   =3D 0x00000006,
> > +     SBI_SSE_ATTR_INTERRUPTED_FLAGS  =3D 0x00000007,
> > +     SBI_SSE_ATTR_INTERRUPTED_A6     =3D 0x00000008,
> > +     SBI_SSE_ATTR_INTERRUPTED_A7     =3D 0x00000009,
> > +};
> > +
> > +#define SBI_SSE_ATTR_STATUS_STATE_OFFSET     0
> > +#define SBI_SSE_ATTR_STATUS_STATE_MASK               0x3
> > +#define SBI_SSE_ATTR_STATUS_PENDING_OFFSET   2
> > +#define SBI_SSE_ATTR_STATUS_INJECT_OFFSET    3
> > +
> > +#define SBI_SSE_ATTR_CONFIG_ONESHOT  (1 << 0)
>
> BIT(0)
>
> > +
> > +#define SBI_SSE_ATTR_INTERRUPTED_FLAGS_SSTATUS_SPP   BIT(0)
> > +#define SBI_SSE_ATTR_INTERRUPTED_FLAGS_SSTATUS_SPIE  BIT(1)
> > +#define SBI_SSE_ATTR_INTERRUPTED_FLAGS_HSTATUS_SPV   BIT(2)
> > +#define SBI_SSE_ATTR_INTERRUPTED_FLAGS_HSTATUS_SPVP  BIT(3)
> > +
> > +enum sbi_sse_state {
> > +     SBI_SSE_STATE_UNUSED            =3D 0,
> > +     SBI_SSE_STATE_REGISTERED        =3D 1,
> > +     SBI_SSE_STATE_ENABLED           =3D 2,
> > +     SBI_SSE_STATE_RUNNING           =3D 3,
> > +};
> > +
> > +/* SBI SSE Event IDs. */
> > +#define SBI_SSE_EVENT_LOCAL_RAS                      0x00000000
> > +#define SBI_SSE_EVENT_LOCAL_DOUBLE_TRAP              0x00000001
> > +#define SBI_SSE_EVENT_LOCAL_PLAT_0_START     0x00004000
> > +#define SBI_SSE_EVENT_LOCAL_PLAT_0_END               0x00007fff
> > +
> > +#define SBI_SSE_EVENT_GLOBAL_RAS             0x00008000
> > +#define SBI_SSE_EVENT_GLOBAL_PLAT_0_START    0x0000c000
> > +#define SBI_SSE_EVENT_GLOBAL_PLAT_0_END              0x0000ffff
> > +
> > +#define SBI_SSE_EVENT_LOCAL_PMU                      0x00010000
> > +#define SBI_SSE_EVENT_LOCAL_PLAT_1_START     0x00014000
> > +#define SBI_SSE_EVENT_LOCAL_PLAT_1_END               0x00017fff
> > +#define SBI_SSE_EVENT_GLOBAL_PLAT_1_START    0x0001c000
> > +#define SBI_SSE_EVENT_GLOBAL_PLAT_1_END              0x0001ffff
> > +
> > +#define SBI_SSE_EVENT_LOCAL_PLAT_2_START     0x00024000
> > +#define SBI_SSE_EVENT_LOCAL_PLAT_2_END               0x00027fff
> > +#define SBI_SSE_EVENT_GLOBAL_PLAT_2_START    0x0002c000
> > +#define SBI_SSE_EVENT_GLOBAL_PLAT_2_END              0x0002ffff
>
> The above four don't appear to be in the spec anymore.
>
> > +
> > +#define SBI_SSE_EVENT_LOCAL_SOFTWARE         0xffff0000
> > +#define SBI_SSE_EVENT_LOCAL_PLAT_3_START     0xffff4000
> > +#define SBI_SSE_EVENT_LOCAL_PLAT_3_END               0xffff7fff
> > +#define SBI_SSE_EVENT_GLOBAL_SOFTWARE                0xffff8000
> > +#define SBI_SSE_EVENT_GLOBAL_PLAT_3_START    0xffffc000
> > +#define SBI_SSE_EVENT_GLOBAL_PLAT_3_END              0xffffffff
> > +
> > +#define SBI_SSE_EVENT_PLATFORM_BIT           (1 << 14)
> > +#define SBI_SSE_EVENT_GLOBAL_BIT             (1 << 15)
>
> BIT(14)
> BIT(15)
>
> I think other changes are coming to these event IDs from a series Atish
> recently posted too.
>

Yeah. As per Anup's suggestion and ARC feedback, we have modified the
segments a little bit.

PTAL: https://github.com/riscv-non-isa/riscv-sbi-doc/blob/master/src/ext-ss=
e.adoc

> > +
> >  struct sbiret {
> >       long error;
> >       long value;
> > --
> > 2.45.2
> >
>
> Thanks,
> drew

