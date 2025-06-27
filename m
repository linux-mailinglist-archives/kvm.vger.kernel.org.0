Return-Path: <kvm+bounces-51027-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C77ECAEBF65
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 21:06:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F2BE54A042A
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 19:06:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B3D51FC109;
	Fri, 27 Jun 2025 19:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="aE/hJz4G"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A46CE1F4C99
	for <kvm@vger.kernel.org>; Fri, 27 Jun 2025 19:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751051177; cv=none; b=iBuBhIcrxsxsFJkNFJTP5Q/hrrkJbe8T63s5MJ3HG4zh6GpAYoDsGDyWJwf1rLUH1OzsQGiOg1xYtWuqvuCGLjg4CCIOTpoL/5oia7Y41gxonpbsMKlzbMrN+8qGmqcZaPRbuRruC/rrb7ib3TZt89ntLODGy+UgzBIqO6BaZV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751051177; c=relaxed/simple;
	bh=sHlM52WoiOuM7tWq8CoWmn2gjdLlqN0iR6CXRbUTDLk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UoUCAFpV2YHq6mm5WRL1aHetg457grocVT8bOJbfFjmF7USO2mcqhCzEtT0iGiKdjjKzzqku9CgALfZkEN2+16PgqdsI37UHLwZb2pPX2x69NzT5Dcqa1eRqGv1VvT2IFuJmNpMeX9nMUqlxFkXWJbsdCYH3M3dPN+bC2zkkRto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=aE/hJz4G; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-7d402c901cbso227270585a.3
        for <kvm@vger.kernel.org>; Fri, 27 Jun 2025 12:06:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1751051173; x=1751655973; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zSkB72+T4isnYxkdoUwFbLQg1JfirF1haClLK5jr+4A=;
        b=aE/hJz4GMunmGcuv4U9n4J1NC440keJmOFd2znioX3Ej38AhwUc2o5hLa0L8gEdchG
         gaDOkCoudGD9uFP64OFdeRpOUaql+IFMqmBnb53wipDYqo1eIz4RV/BvyP8bVnBqFBE8
         En6BdBwO/xOOnRDBrpNrHkEHSDHO5trxH1iereVQ5b284MNso23gzMjlDKH0awSCqoqP
         6E6hq0gLaA9WhBQXu/DP8fvoiebcrBbg4DF97exxZ2JlGOpY6GsAymFFfsavDU+d6hYP
         Rwec6HOjVSp3jd99i7z2+NcwW6GKh+aY5IlUJwsazr7obKm8TrkmRUfHP4oDnIv1W/WZ
         LitQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751051173; x=1751655973;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zSkB72+T4isnYxkdoUwFbLQg1JfirF1haClLK5jr+4A=;
        b=JdVvoHPk6i8+2I1iDYyxwr4IO1K0C2VztM7qYOVgC+5yEbpXuVcjJjc5ZdHd7ELa8D
         AQOY4D8DHUwBsbZANFSLR9JqqASRMI3iKG8bABpPmN8DVisfyfOD9qSK+dgC8YTl4l9R
         /0H5tNUzTCQjPSZ9KcjH/MuWPrazcfKHAnyn5MVcZhQcoDGQXF1Yp+jc+t81J1PiuP3v
         7lQRWIIQFr+qDGzpleLGsEc8/N9YyMk+ZcVi3qZ4WE8uCwiOuO18KmcQ2tOoBPWCTkn1
         e9ZADoPKajx/DXSVKD5uj+jpmFHr7Qkm83VIxLiUC4TIhF3q0K8TVNehXDd+PIcgehSD
         pnhg==
X-Gm-Message-State: AOJu0YwzZYS/bRoTBi/sJYKwYmoHQlyb9MGhu8ISQXPI8eAYGfJe/66+
	YhnVWbQYytiCG8oy8c/u2KCvTSKQDNDixQQsMm/CvJ/4Z1E5cy1ph3KUZo1PSKCVP8+Amhkp1U7
	dpKGBvnXNp7b7S0dd1wVNAxWXhUaUaew2TRYPFM8H3A==
X-Gm-Gg: ASbGncsEzFFvLl/ynuIcMs3kII1C5Ps+p0UGZeF9N6uHbZza3Iv+Nbj6IPGUq0eHx9w
	w/u72w+k/Fwr7HcxpoIU+1d1VZTTXF7BJtbU+01FbIZ30iYCUXiKpyP85NRSXaLsYMRibutg/HB
	xkRzf0yCk1OH3tsyMtVlX/GH60k7bD5IcHp6ckhEvWCg==
X-Google-Smtp-Source: AGHT+IG5UvYD/xYa1ZxR9Qj+vG2WiVWthmiQDDTfWeTyMogmvZHJrSSSwJfb1D7q55PRbuMkJ2BpcY5wRZdLDBGfJ7s=
X-Received: by 2002:ae9:e106:0:b0:7d4:46d0:75cd with SMTP id
 af79cd13be357-7d446d07677mr349639885a.8.1751051173092; Fri, 27 Jun 2025
 12:06:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250618154452.2136345-1-jesse@rivosinc.com> <20250627-c6a984395c94f8281954ab21@orel>
In-Reply-To: <20250627-c6a984395c94f8281954ab21@orel>
From: Jesse Taube <jesse@rivosinc.com>
Date: Fri, 27 Jun 2025 12:06:02 -0700
X-Gm-Features: Ac12FXyHA0ZvpCFuSW3W3qXL-WDm1XG2SMoS1KmQ0_Eg7G8aXZxzhD-9zdXpXNY
Message-ID: <CALSpo=bFJyf+Y1w-a7U++Zx_yCH8h6nP7dToAPBGPnYciHbVkQ@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v6] riscv: sbi: Add SBI Debug Triggers
 Extension tests
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-kselftest@vger.kernel.org, Atish Patra <atish.patra@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	=?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>, 
	Himanshu Chauhan <hchauhan@ventanamicro.com>, Charlie Jenkins <charlie@rivosinc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 27, 2025 at 6:02=E2=80=AFAM Andrew Jones <andrew.jones@linux.de=
v> wrote:
>
> On Wed, Jun 18, 2025 at 08:44:52AM -0700, Jesse Taube wrote:
> > Add tests for the DBTR SBI extension.
> >
> > Signed-off-by: Jesse Taube <jesse@rivosinc.com>
> > Reviewed-by: Charlie Jenkins <charlie@rivosinc.com>
> > Tested-by: Charlie Jenkins <charlie@rivosinc.com>
> > ---
> > V1 -> V2:
> >  - Call report_prefix_pop before returning
> >  - Disable compressed instructions in exec_call, update related comment
> >  - Remove extra "| 1" in dbtr_test_load
> >  - Remove extra newlines
> >  - Remove extra tabs in check_exec
> >  - Remove typedefs from enums
> >  - Return when dbtr_install_trigger fails
> >  - s/avalible/available/g
> >  - s/unistall/uninstall/g
> > V2 -> V3:
> >  - Change SBI_DBTR_SHMEM_INVALID_ADDR to -1UL
> >  - Move all dbtr functions to sbi-dbtr.c
> >  - Move INSN_LEN to processor.h
> >  - Update include list
> >  - Use C-style comments
> > V3 -> V4:
> >  - Include libcflat.h
> >  - Remove #define SBI_DBTR_SHMEM_INVALID_ADDR
> > V4 -> V5:
> >  - Sort includes
> >  - Add kfail for update triggers
> > V5 -> V6:
> >  - Add assert in gen_tdata1
> >  - Add prefix to dbtr_test_type
> >  - Add TRIG_STATE_DMODE
> >  - Add TRIG_STATE_RESERVED
> >  - Align function paramaters with opening parenthesis
> >  - Change OpenSBI < v1.7 to < v1.5
> >  - Constantly use spaces in prefix rather than _
> >  - Export split_phys_addr
> >  - Fix MCONTROL_U and MCONTROL_M mix up
> >  - Fix swapped VU and VS
> >  - Move /* to own line
> >  - Print type in dbtr_test_type
> >  - Remove _BIT suffix from macros
> >  - Remove duplicate MODE_S
> >  - Remove spaces before include
> >  - Rename tdata1,2 to trigger and control in dbtr_install_trigger
> >  - Report skip in dbtr_test_multiple
> >  - Report variables in info not pass or fail
> >  - s/save/store/g
> >  - sbi_debug_set_shmem use split_phys_addr
> >  - Use if (!report(... in dbtr_test_disable_enable
> > ---
> >  lib/riscv/asm/sbi.h |   1 +
> >  riscv/Makefile      |   1 +
> >  riscv/sbi-dbtr.c    | 839 ++++++++++++++++++++++++++++++++++++++++++++
> >  riscv/sbi-tests.h   |   2 +
> >  riscv/sbi.c         |   3 +-
> >  5 files changed, 845 insertions(+), 1 deletion(-)
> >  create mode 100644 riscv/sbi-dbtr.c
> >
> > diff --git a/lib/riscv/asm/sbi.h b/lib/riscv/asm/sbi.h
> > index a5738a5c..78fd6e2a 100644
> > --- a/lib/riscv/asm/sbi.h
> > +++ b/lib/riscv/asm/sbi.h
> > @@ -51,6 +51,7 @@ enum sbi_ext_id {
> >       SBI_EXT_SUSP =3D 0x53555350,
> >       SBI_EXT_FWFT =3D 0x46574654,
> >       SBI_EXT_SSE =3D 0x535345,
> > +     SBI_EXT_DBTR =3D 0x44425452,
> >  };
> >
> >  enum sbi_ext_base_fid {
> > diff --git a/riscv/Makefile b/riscv/Makefile
> > index 11e68eae..55c7ac93 100644
> > --- a/riscv/Makefile
> > +++ b/riscv/Makefile
> > @@ -20,6 +20,7 @@ all: $(tests)
> >  $(TEST_DIR)/sbi-deps +=3D $(TEST_DIR)/sbi-asm.o
> >  $(TEST_DIR)/sbi-deps +=3D $(TEST_DIR)/sbi-fwft.o
> >  $(TEST_DIR)/sbi-deps +=3D $(TEST_DIR)/sbi-sse.o
> > +$(TEST_DIR)/sbi-deps +=3D $(TEST_DIR)/sbi-dbtr.o
>
> My OCD says this should come after the sbi-asm to be alphabetical.
>
> >
> >  all_deps +=3D $($(TEST_DIR)/sbi-deps)
> >
> > diff --git a/riscv/sbi-dbtr.c b/riscv/sbi-dbtr.c
> > new file mode 100644
> > index 00000000..7837553f
> > --- /dev/null
> > +++ b/riscv/sbi-dbtr.c
> > @@ -0,0 +1,839 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/*
> > + * SBI DBTR testsuite
> > + *
> > + * Copyright (C) 2025, Rivos Inc., Jesse Taube <jesse@rivosinc.com>
> > + */
> > +
> > +#include <libcflat.h>
> > +#include <bitops.h>
> > +
> > +#include <asm/io.h>
> > +#include <asm/processor.h>
> > +
> > +#include "sbi-tests.h"
> > +
> > +#define RV_MAX_TRIGGERS                      32
> > +
> > +#define SBI_DBTR_TRIG_STATE_MAPPED           BIT(0)
> > +#define SBI_DBTR_TRIG_STATE_U                        BIT(1)
> > +#define SBI_DBTR_TRIG_STATE_S                        BIT(2)
> > +#define SBI_DBTR_TRIG_STATE_VU                       BIT(3)
> > +#define SBI_DBTR_TRIG_STATE_VS                       BIT(4)
> > +#define SBI_DBTR_TRIG_STATE_HAVE_HW_TRIG     BIT(5)
> > +#define SBI_DBTR_TRIG_STATE_RESERVED         GENMASK(7, 6)
> > +
> > +#define SBI_DBTR_TRIG_STATE_HW_TRIG_IDX_SHIFT                8
> > +#define SBI_DBTR_TRIG_STATE_HW_TRIG_IDX(trig_state)  (trig_state >> SB=
I_DBTR_TRIG_STATE_HW_TRIG_IDX_SHIFT)
> > +
> > +#define SBI_DBTR_TDATA1_TYPE_SHIFT           (__riscv_xlen - 4)
> > +#define SBI_DBTR_TDATA1_DMODE                        BIT_UL(__riscv_xl=
en - 5)
> > +
> > +#define SBI_DBTR_TDATA1_MCONTROL6_LOAD               BIT(0)
> > +#define SBI_DBTR_TDATA1_MCONTROL6_STORE              BIT(1)
> > +#define SBI_DBTR_TDATA1_MCONTROL6_EXECUTE    BIT(2)
> > +#define SBI_DBTR_TDATA1_MCONTROL6_U          BIT(3)
> > +#define SBI_DBTR_TDATA1_MCONTROL6_S          BIT(4)
> > +#define SBI_DBTR_TDATA1_MCONTROL6_M          BIT(6)
> > +#define SBI_DBTR_TDATA1_MCONTROL6_SELECT     BIT(21)
> > +#define SBI_DBTR_TDATA1_MCONTROL6_VU         BIT(23)
> > +#define SBI_DBTR_TDATA1_MCONTROL6_VS         BIT(24)
> > +
> > +#define SBI_DBTR_TDATA1_MCONTROL_LOAD                BIT(0)
> > +#define SBI_DBTR_TDATA1_MCONTROL_STORE               BIT(1)
> > +#define SBI_DBTR_TDATA1_MCONTROL_EXECUTE     BIT(2)
> > +#define SBI_DBTR_TDATA1_MCONTROL_U           BIT(3)
> > +#define SBI_DBTR_TDATA1_MCONTROL_S           BIT(4)
> > +#define SBI_DBTR_TDATA1_MCONTROL_M           BIT(6)
> > +#define SBI_DBTR_TDATA1_MCONTROL_SELECT              BIT(19)
> > +
> > +enum McontrolType {
> > +     SBI_DBTR_TDATA1_TYPE_NONE =3D             (0UL << SBI_DBTR_TDATA1=
_TYPE_SHIFT),
> > +     SBI_DBTR_TDATA1_TYPE_LEGACY =3D           (1UL << SBI_DBTR_TDATA1=
_TYPE_SHIFT),
> > +     SBI_DBTR_TDATA1_TYPE_MCONTROL =3D         (2UL << SBI_DBTR_TDATA1=
_TYPE_SHIFT),
> > +     SBI_DBTR_TDATA1_TYPE_ICOUNT =3D           (3UL << SBI_DBTR_TDATA1=
_TYPE_SHIFT),
> > +     SBI_DBTR_TDATA1_TYPE_ITRIGGER =3D         (4UL << SBI_DBTR_TDATA1=
_TYPE_SHIFT),
> > +     SBI_DBTR_TDATA1_TYPE_ETRIGGER =3D         (5UL << SBI_DBTR_TDATA1=
_TYPE_SHIFT),
> > +     SBI_DBTR_TDATA1_TYPE_MCONTROL6 =3D        (6UL << SBI_DBTR_TDATA1=
_TYPE_SHIFT),
> > +     SBI_DBTR_TDATA1_TYPE_TMEXTTRIGGER =3D     (7UL << SBI_DBTR_TDATA1=
_TYPE_SHIFT),
> > +     SBI_DBTR_TDATA1_TYPE_RESERVED0 =3D        (8UL << SBI_DBTR_TDATA1=
_TYPE_SHIFT),
> > +     SBI_DBTR_TDATA1_TYPE_RESERVED1 =3D        (9UL << SBI_DBTR_TDATA1=
_TYPE_SHIFT),
> > +     SBI_DBTR_TDATA1_TYPE_RESERVED2 =3D        (10UL << SBI_DBTR_TDATA=
1_TYPE_SHIFT),
> > +     SBI_DBTR_TDATA1_TYPE_RESERVED3 =3D        (11UL << SBI_DBTR_TDATA=
1_TYPE_SHIFT),
> > +     SBI_DBTR_TDATA1_TYPE_CUSTOM0 =3D          (12UL << SBI_DBTR_TDATA=
1_TYPE_SHIFT),
> > +     SBI_DBTR_TDATA1_TYPE_CUSTOM1 =3D          (13UL << SBI_DBTR_TDATA=
1_TYPE_SHIFT),
> > +     SBI_DBTR_TDATA1_TYPE_CUSTOM2 =3D          (14UL << SBI_DBTR_TDATA=
1_TYPE_SHIFT),
> > +     SBI_DBTR_TDATA1_TYPE_DISABLED =3D         (15UL << SBI_DBTR_TDATA=
1_TYPE_SHIFT),
> > +};
> > +
> > +enum Tdata1Value {
> > +     VALUE_NONE =3D    0,
> > +     VALUE_LOAD =3D    BIT(0),
> > +     VALUE_STORE =3D   BIT(1),
> > +     VALUE_EXECUTE =3D BIT(2),
> > +};
> > +
> > +enum Tdata1Mode {
> > +     MODE_NONE =3D     0,
> > +     MODE_M =3D        BIT(0),
> > +     MODE_U =3D        BIT(1),
> > +     MODE_S =3D        BIT(2),
> > +     MODE_VU =3D       BIT(3),
> > +     MODE_VS =3D       BIT(4),
> > +};
> > +
> > +enum sbi_ext_dbtr_fid {
> > +     SBI_EXT_DBTR_NUM_TRIGGERS =3D 0,
> > +     SBI_EXT_DBTR_SETUP_SHMEM,
> > +     SBI_EXT_DBTR_TRIGGER_READ,
> > +     SBI_EXT_DBTR_TRIGGER_INSTALL,
> > +     SBI_EXT_DBTR_TRIGGER_UPDATE,
> > +     SBI_EXT_DBTR_TRIGGER_UNINSTALL,
> > +     SBI_EXT_DBTR_TRIGGER_ENABLE,
> > +     SBI_EXT_DBTR_TRIGGER_DISABLE,
> > +};
> > +
> > +struct sbi_dbtr_data_msg {
> > +     unsigned long tstate;
> > +     unsigned long tdata1;
> > +     unsigned long tdata2;
> > +     unsigned long tdata3;
> > +};
> > +
> > +struct sbi_dbtr_id_msg {
> > +     unsigned long idx;
> > +};
> > +
> > +/* SBI shared mem messages layout */
> > +struct sbi_dbtr_shmem_entry {
> > +     union {
> > +             struct sbi_dbtr_data_msg data;
> > +             struct sbi_dbtr_id_msg id;
> > +     };
> > +};
> > +
> > +static bool dbtr_handled;
> > +
> > +/* Expected to be leaf function as not to disrupt frame-pointer */
> > +static __attribute__((naked)) void exec_call(void)
> > +{
> > +     /* skip over nop when triggered instead of ret. */
> > +     asm volatile (".option push\n"
> > +                   ".option arch, -c\n"
> > +                   "nop\n"
> > +                   "ret\n"
> > +                   ".option pop\n");
> > +}
> > +
> > +static void dbtr_exception_handler(struct pt_regs *regs)
> > +{
> > +     dbtr_handled =3D true;
> > +
> > +     /* Reading *epc may cause a fault, skip over nop */
> > +     if ((void *)regs->epc =3D=3D exec_call) {
> > +             regs->epc +=3D 4;
> > +             return;
> > +     }
> > +
> > +     /* WARNING: Skips over the trapped intruction */
> > +     regs->epc +=3D RV_INSN_LEN(readw((void *)regs->epc));
> > +}
> > +
> > +static bool do_store(void *tdata2)
> > +{
> > +     bool ret;
> > +
> > +     writel(0, tdata2);
> > +
> > +     ret =3D dbtr_handled;
> > +     dbtr_handled =3D false;
> > +
> > +     return ret;
> > +}
> > +
> > +static bool do_load(void *tdata2)
> > +{
> > +     bool ret;
> > +
> > +     readl(tdata2);
> > +
> > +     ret =3D dbtr_handled;
> > +     dbtr_handled =3D false;
> > +
> > +     return ret;
> > +}
> > +
> > +static bool do_exec(void)
> > +{
> > +     bool ret;
> > +
> > +     exec_call();
> > +
> > +     ret =3D dbtr_handled;
> > +     dbtr_handled =3D false;
> > +
> > +     return ret;
> > +}
> > +
> > +static unsigned long gen_tdata1_mcontrol(enum Tdata1Mode mode, enum Td=
ata1Value value)
> > +{
> > +     unsigned long tdata1 =3D SBI_DBTR_TDATA1_TYPE_MCONTROL;
> > +
> > +     if (value & VALUE_LOAD)
> > +             tdata1 |=3D SBI_DBTR_TDATA1_MCONTROL_LOAD;
> > +
> > +     if (value & VALUE_STORE)
> > +             tdata1 |=3D SBI_DBTR_TDATA1_MCONTROL_STORE;
> > +
> > +     if (value & VALUE_EXECUTE)
> > +             tdata1 |=3D SBI_DBTR_TDATA1_MCONTROL_EXECUTE;
> > +
> > +     if (mode & MODE_M)
> > +             tdata1 |=3D SBI_DBTR_TDATA1_MCONTROL_M;
> > +
> > +     if (mode & MODE_U)
> > +             tdata1 |=3D SBI_DBTR_TDATA1_MCONTROL_U;
> > +
> > +     if (mode & MODE_S)
> > +             tdata1 |=3D SBI_DBTR_TDATA1_MCONTROL_S;
> > +
> > +     return tdata1;
> > +}
> > +
> > +static unsigned long gen_tdata1_mcontrol6(enum Tdata1Mode mode, enum T=
data1Value value)
> > +{
> > +     unsigned long tdata1 =3D SBI_DBTR_TDATA1_TYPE_MCONTROL6;
> > +
> > +     if (value & VALUE_LOAD)
> > +             tdata1 |=3D SBI_DBTR_TDATA1_MCONTROL6_LOAD;
> > +
> > +     if (value & VALUE_STORE)
> > +             tdata1 |=3D SBI_DBTR_TDATA1_MCONTROL6_STORE;
> > +
> > +     if (value & VALUE_EXECUTE)
> > +             tdata1 |=3D SBI_DBTR_TDATA1_MCONTROL6_EXECUTE;
> > +
> > +     if (mode & MODE_M)
> > +             tdata1 |=3D SBI_DBTR_TDATA1_MCONTROL6_M;
> > +
> > +     if (mode & MODE_U)
> > +             tdata1 |=3D SBI_DBTR_TDATA1_MCONTROL6_U;
> > +
> > +     if (mode & MODE_S)
> > +             tdata1 |=3D SBI_DBTR_TDATA1_MCONTROL6_S;
> > +
> > +     if (mode & MODE_VU)
> > +             tdata1 |=3D SBI_DBTR_TDATA1_MCONTROL6_VU;
> > +
> > +     if (mode & MODE_VS)
> > +             tdata1 |=3D SBI_DBTR_TDATA1_MCONTROL6_VS;
> > +
> > +     return tdata1;
> > +}
> > +
> > +static unsigned long gen_tdata1(enum McontrolType type, enum Tdata1Val=
ue value, enum Tdata1Mode mode)
> > +{
> > +     switch (type) {
> > +     case SBI_DBTR_TDATA1_TYPE_MCONTROL:
> > +             return gen_tdata1_mcontrol(mode, value);
> > +     case SBI_DBTR_TDATA1_TYPE_MCONTROL6:
> > +             return gen_tdata1_mcontrol6(mode, value);
> > +     default:
> > +             assert_msg(false, "Invalid mcontrol type: %lu", type);
> > +             return 0;
>
> Can drop the 'return 0' line now that there's an unconditional assert.
>
> > +     }
> > +}
> > +
> > +static struct sbiret sbi_debug_num_triggers(unsigned long trig_tdata1)
> > +{
> > +     return sbi_ecall(SBI_EXT_DBTR, SBI_EXT_DBTR_NUM_TRIGGERS, trig_td=
ata1, 0, 0, 0, 0, 0);
> > +}
> > +
> > +static struct sbiret sbi_debug_set_shmem_raw(unsigned long shmem_phys_=
lo,
> > +                                          unsigned long shmem_phys_hi,
> > +                                          unsigned long flags)
> > +{
> > +     return sbi_ecall(SBI_EXT_DBTR, SBI_EXT_DBTR_SETUP_SHMEM, shmem_ph=
ys_lo,
> > +                      shmem_phys_hi, flags, 0, 0, 0);
> > +}
> > +
> > +static struct sbiret sbi_debug_set_shmem(void *shmem)
> > +{
> > +     unsigned long base_addr_lo, base_addr_hi;
> > +
> > +     split_phys_addr(virt_to_phys(shmem), &base_addr_hi, &base_addr_lo=
);
> > +     return sbi_debug_set_shmem_raw(base_addr_lo, base_addr_hi, 0);
> > +}
> > +
> > +static struct sbiret sbi_debug_read_triggers(unsigned long trig_idx_ba=
se,
> > +                                          unsigned long trig_count)
> > +{
> > +     return sbi_ecall(SBI_EXT_DBTR, SBI_EXT_DBTR_TRIGGER_READ, trig_id=
x_base,
> > +                      trig_count, 0, 0, 0, 0);
> > +}
> > +
> > +static struct sbiret sbi_debug_install_triggers(unsigned long trig_cou=
nt)
> > +{
> > +     return sbi_ecall(SBI_EXT_DBTR, SBI_EXT_DBTR_TRIGGER_INSTALL, trig=
_count, 0, 0, 0, 0, 0);
> > +}
> > +
> > +static struct sbiret sbi_debug_update_triggers(unsigned long trig_coun=
t)
> > +{
> > +     return sbi_ecall(SBI_EXT_DBTR, SBI_EXT_DBTR_TRIGGER_UPDATE, trig_=
count, 0, 0, 0, 0, 0);
> > +}
> > +
> > +static struct sbiret sbi_debug_uninstall_triggers(unsigned long trig_i=
dx_base,
> > +                                               unsigned long trig_idx_=
mask)
> > +{
> > +     return sbi_ecall(SBI_EXT_DBTR, SBI_EXT_DBTR_TRIGGER_UNINSTALL, tr=
ig_idx_base,
> > +                      trig_idx_mask, 0, 0, 0, 0);
> > +}
> > +
> > +static struct sbiret sbi_debug_enable_triggers(unsigned long trig_idx_=
base,
> > +                                            unsigned long trig_idx_mas=
k)
> > +{
> > +     return sbi_ecall(SBI_EXT_DBTR, SBI_EXT_DBTR_TRIGGER_ENABLE, trig_=
idx_base,
> > +                      trig_idx_mask, 0, 0, 0, 0);
> > +}
> > +
> > +static struct sbiret sbi_debug_disable_triggers(unsigned long trig_idx=
_base,
> > +                                             unsigned long trig_idx_ma=
sk)
> > +{
> > +     return sbi_ecall(SBI_EXT_DBTR, SBI_EXT_DBTR_TRIGGER_DISABLE, trig=
_idx_base,
> > +                      trig_idx_mask, 0, 0, 0, 0);
> > +}
> > +
> > +static bool dbtr_install_trigger(struct sbi_dbtr_shmem_entry *shmem, v=
oid *trigger,
> > +                              unsigned long control)
> > +{
> > +     struct sbiret sbi_ret;
> > +     bool ret;
> > +
> > +     shmem->data.tdata1 =3D control;
> > +     shmem->data.tdata2 =3D (unsigned long)trigger;
> > +
> > +     sbi_ret =3D sbi_debug_install_triggers(1);
> > +     ret =3D sbiret_report_error(&sbi_ret, SBI_SUCCESS, "sbi_debug_ins=
tall_triggers");
> > +     if (ret)
> > +             install_exception_handler(EXC_BREAKPOINT, dbtr_exception_=
handler);
> > +
> > +     return ret;
> > +}
> > +
> > +static bool dbtr_uninstall_trigger(void)
> > +{
> > +     struct sbiret ret;
> > +
> > +     install_exception_handler(EXC_BREAKPOINT, NULL);
> > +
> > +     ret =3D sbi_debug_uninstall_triggers(0, 1);
> > +     return sbiret_report_error(&ret, SBI_SUCCESS, "sbi_debug_uninstal=
l_triggers");
> > +}
> > +
> > +static unsigned long dbtr_test_num_triggers(void)
> > +{
> > +     struct sbiret ret;
> > +     unsigned long tdata1 =3D 0;
> > +     /* sbi_debug_num_triggers will return trig_max in sbiret.value wh=
en trig_tdata1 =3D=3D 0 */
> > +
> > +     /* should be at least one trigger. */
> > +     ret =3D sbi_debug_num_triggers(tdata1);
> > +     sbiret_report_error(&ret, SBI_SUCCESS, "sbi_debug_num_triggers");
> > +
> > +     if (ret.value =3D=3D 0) {
> > +             report_fail("sbi_debug_num_triggers: Returned 0 triggers =
available");
> > +     } else {
> > +             report_pass("sbi_debug_num_triggers: Returned triggers av=
ailable");
> > +             report_info("sbi_debug_num_triggers: Returned %lu trigger=
s available", ret.value);
>
> Rather than put the sbi_debug_num_triggers prefix in each report call, we
> can just push it.
>
> > +     }
> > +
> > +     return ret.value;
> > +}
> > +
> > +static enum McontrolType dbtr_test_type(unsigned long *num_trig)
> > +{
> > +     struct sbiret ret;
> > +     unsigned long tdata1 =3D SBI_DBTR_TDATA1_TYPE_MCONTROL6;
> > +
> > +     report_prefix_push("test type");
> > +
> > +     ret =3D sbi_debug_num_triggers(tdata1);
> > +     sbiret_report_error(&ret, SBI_SUCCESS, "sbi_debug_num_triggers: m=
control6");
> > +     *num_trig =3D ret.value;
> > +     if (ret.value > 0) {
> > +             report_pass("sbi_debug_num_triggers: Returned mcontrol6 t=
riggers available");
> > +             report_info("sbi_debug_num_triggers: Returned %lu mcontro=
l6 triggers available",
>
> Same comment about pushing "sbi_debug_num_triggers".
>
> > +                         ret.value);
> > +             report_prefix_pop();
>
> If we push sbi_debug_num_triggers, then this can be a report_prefix_popn(=
2).
>
> > +             return tdata1;
> > +     }
> > +
> > +     tdata1 =3D SBI_DBTR_TDATA1_TYPE_MCONTROL;
> > +
> > +     ret =3D sbi_debug_num_triggers(tdata1);
> > +     sbiret_report_error(&ret, SBI_SUCCESS, "sbi_debug_num_triggers: m=
control");
> > +     *num_trig =3D ret.value;
> > +     if (ret.value > 0) {
> > +             report_pass("sbi_debug_num_triggers: Returned mcontrol tr=
iggers available");
> > +             report_info("sbi_debug_num_triggers: Returned %lu mcontro=
l triggers available",
> > +                         ret.value);
> > +             report_prefix_pop();
> > +             return tdata1;
> > +     }
> > +
> > +     report_fail("sbi_debug_num_triggers: Returned 0 mcontrol(6) trigg=
ers available");
> > +     report_prefix_pop();
> > +
> > +     return SBI_DBTR_TDATA1_TYPE_NONE;
> > +}
> > +
> > +static struct sbiret dbtr_test_store_install_uninstall(struct sbi_dbtr=
_shmem_entry *shmem,
> > +                                                   enum McontrolType t=
ype)
> > +{
> > +     static unsigned long test;
> > +     struct sbiret ret;
> > +
> > +     report_prefix_push("store trigger");
> > +
> > +     shmem->data.tdata1 =3D gen_tdata1(type, VALUE_STORE, MODE_S);
> > +     shmem->data.tdata2 =3D (unsigned long)&test;
> > +
> > +     ret =3D sbi_debug_install_triggers(1);
> > +     if (!sbiret_report_error(&ret, SBI_SUCCESS, "sbi_debug_install_tr=
iggers")) {
> > +             report_prefix_pop();
> > +             return ret;
> > +     }
> > +
> > +     install_exception_handler(EXC_BREAKPOINT, dbtr_exception_handler)=
;
> > +
> > +     report(do_store(&test), "triggered");
> > +
> > +     if (do_load(&test))
> > +             report_fail("triggered by load");
> > +
> > +     ret =3D sbi_debug_uninstall_triggers(0, 1);
> > +     sbiret_report_error(&ret, SBI_SUCCESS, "sbi_debug_uninstall_trigg=
ers");
> > +
> > +     if (do_store(&test))
> > +             report_fail("triggered after uninstall");
> > +
> > +     install_exception_handler(EXC_BREAKPOINT, NULL);
> > +     report_prefix_pop();
> > +
> > +     return ret;
> > +}
> > +
> > +static void dbtr_test_update(struct sbi_dbtr_shmem_entry *shmem, enum =
McontrolType type)
> > +{
> > +     static unsigned long test;
> > +     struct sbiret ret;
> > +     bool kfail;
> > +
> > +     report_prefix_push("update trigger");
> > +
> > +     if (!dbtr_install_trigger(shmem, NULL, gen_tdata1(type, VALUE_NON=
E, MODE_NONE))) {
> > +             report_prefix_pop();
> > +             return;
> > +     }
> > +
> > +     shmem->id.idx =3D 0;
> > +     shmem->data.tdata1 =3D gen_tdata1(type, VALUE_STORE, MODE_S);
> > +     shmem->data.tdata2 =3D (unsigned long)&test;
> > +
> > +     ret =3D sbi_debug_update_triggers(1);
> > +     sbiret_report_error(&ret, SBI_SUCCESS, "sbi_debug_update_triggers=
");
> > +
> > +     /*
> > +      * Known broken update_triggers.
> > +      * https://lore.kernel.org/opensbi/aDdp1UeUh7GugeHp@ghost/T/#t
> > +      */
> > +     kfail =3D __sbi_get_imp_id() =3D=3D SBI_IMPL_OPENSBI &&
> > +             __sbi_get_imp_version() < sbi_impl_opensbi_mk_version(1, =
7);
> > +     report_kfail(kfail, do_store(&test), "triggered");
> > +
> > +     dbtr_uninstall_trigger();
> > +     report_prefix_pop();
> > +}
> > +
> > +static void dbtr_test_load(struct sbi_dbtr_shmem_entry *shmem, enum Mc=
ontrolType type)
> > +{
> > +     static unsigned long test;
> > +
> > +     report_prefix_push("load trigger");
> > +     if (!dbtr_install_trigger(shmem, &test, gen_tdata1(type, VALUE_LO=
AD, MODE_S))) {
> > +             report_prefix_pop();
> > +             return;
> > +     }
> > +
> > +     report(do_load(&test), "triggered");
> > +
> > +     if (do_store(&test))
> > +             report_fail("triggered by store");
> > +
> > +     dbtr_uninstall_trigger();
> > +     report_prefix_pop();
> > +}
> > +
> > +static void dbtr_test_disable_enable(struct sbi_dbtr_shmem_entry *shme=
m, enum McontrolType type)
> > +{
> > +     static unsigned long test;
> > +     struct sbiret ret;
> > +
> > +     report_prefix_push("disable trigger");
> > +     if (!dbtr_install_trigger(shmem, &test, gen_tdata1(type, VALUE_ST=
ORE, MODE_S))) {
> > +             report_prefix_pop();
> > +             return;
> > +     }
> > +
> > +     ret =3D sbi_debug_disable_triggers(0, 1);
> > +     sbiret_report_error(&ret, SBI_SUCCESS, "sbi_debug_disable_trigger=
s");
> > +
> > +     if (!report(!do_store(&test), "should not trigger")) {
> > +             dbtr_uninstall_trigger();
> > +             report_prefix_pop();
> > +             report_skip("enable trigger: no disable");
> > +
> > +             return;
> > +     }
> > +
> > +     report_prefix_pop();
> > +     report_prefix_push("enable trigger");
> > +
> > +     ret =3D sbi_debug_enable_triggers(0, 1);
> > +     sbiret_report_error(&ret, SBI_SUCCESS, "sbi_debug_enable_triggers=
");
> > +
> > +     report(do_store(&test), "triggered");
> > +
> > +     dbtr_uninstall_trigger();
> > +     report_prefix_pop();
> > +}
> > +
> > +static void dbtr_test_exec(struct sbi_dbtr_shmem_entry *shmem, enum Mc=
ontrolType type)
> > +{
> > +     static unsigned long test;
> > +
> > +     report_prefix_push("exec trigger");
> > +     /* check if loads and stores trigger exec */
> > +     if (!dbtr_install_trigger(shmem, &test, gen_tdata1(type, VALUE_EX=
ECUTE, MODE_S))) {
> > +             report_prefix_pop();
> > +             return;
> > +     }
> > +
> > +     if (do_load(&test))
> > +             report_fail("triggered by load");
> > +
> > +     if (do_store(&test))
> > +             report_fail("triggered by store");
> > +
> > +     dbtr_uninstall_trigger();
> > +
> > +     /* Check if exec works */
> > +     if (!dbtr_install_trigger(shmem, exec_call, gen_tdata1(type, VALU=
E_EXECUTE, MODE_S))) {
> > +             report_prefix_pop();
> > +             return;
> > +     }
> > +     report(do_exec(), "triggered");
> > +
> > +     dbtr_uninstall_trigger();
> > +     report_prefix_pop();
> > +}
> > +
> > +static void dbtr_test_read(struct sbi_dbtr_shmem_entry *shmem, enum Mc=
ontrolType type)
> > +{
> > +     const unsigned long tstatus_expected =3D SBI_DBTR_TRIG_STATE_S | =
SBI_DBTR_TRIG_STATE_MAPPED;
> > +     const unsigned long tdata1 =3D gen_tdata1(type, VALUE_STORE, MODE=
_S);
> > +     static unsigned long test;
> > +     struct sbiret ret;
> > +
> > +     report_prefix_push("read trigger");
> > +     if (!dbtr_install_trigger(shmem, &test, tdata1)) {
> > +             report_prefix_pop();
> > +             return;
> > +     }
> > +
> > +     ret =3D sbi_debug_read_triggers(0, 1);
> > +     sbiret_report_error(&ret, SBI_SUCCESS, "sbi_debug_read_triggers")=
;
> > +
> > +     report(shmem->data.tdata1 =3D=3D tdata1, "tdata1 expected: 0x%016=
lx", tdata1);
> > +     report_info("tdata1 found: 0x%016lx", shmem->data.tdata1);
> > +     report(shmem->data.tdata2 =3D=3D ((unsigned long)&test), "tdata2 =
expected: 0x%016lx",
> > +            (unsigned long)&test);
> > +     report_info("tdata2 found: 0x%016lx", shmem->data.tdata2);
> > +     report(shmem->data.tstate =3D=3D tstatus_expected, "tstate expect=
ed: 0x%016lx", tstatus_expected);
> > +     report_info("tstate found: 0x%016lx", shmem->data.tstate);
>
> These don't need to be split into report/report_info pairs because the
> report is checking for a specific value. We only split when report is
> checking for some nonzero value and we also want to output what that
> specific value was for informational purposes.

I'm a bit confused. Should it only report_info when the test fails?

>
> > +
> > +     dbtr_uninstall_trigger();
> > +     report_prefix_pop();
> > +}
> > +
> > +static void check_exec(unsigned long base)
> > +{
> > +     struct sbiret ret;
> > +
> > +     report(do_exec(), "exec triggered");
> > +
> > +     ret =3D sbi_debug_uninstall_triggers(base, 1);
> > +     sbiret_report_error(&ret, SBI_SUCCESS, "sbi_debug_uninstall_trigg=
ers");
> > +}
> > +
> > +static void dbtr_test_multiple(struct sbi_dbtr_shmem_entry *shmem, enu=
m McontrolType type,
> > +                            unsigned long num_trigs)
> > +{
> > +     static unsigned long test[2];
> > +     struct sbiret ret;
> > +     bool have_three =3D num_trigs > 2;
> > +
> > +     if (num_trigs < 2) {
> > +             report_skip("test multiple");
> > +             return;
> > +     }
> > +
> > +     report_prefix_push("test multiple");
> > +
> > +     if (!dbtr_install_trigger(shmem, &test[0], gen_tdata1(type, VALUE=
_STORE, MODE_S))) {
> > +             report_prefix_pop();
> > +             return;
> > +     }
> > +     if (!dbtr_install_trigger(shmem, &test[1], gen_tdata1(type, VALUE=
_LOAD, MODE_S)))
> > +             goto error;
> > +     if (have_three &&
> > +         !dbtr_install_trigger(shmem, exec_call, gen_tdata1(type, VALU=
E_EXECUTE, MODE_S))) {
> > +             ret =3D sbi_debug_uninstall_triggers(1, 1);
> > +             sbiret_report_error(&ret, SBI_SUCCESS, "sbi_debug_uninsta=
ll_triggers");
> > +             goto error;
> > +     }
> > +
> > +     report(do_store(&test[0]), "store triggered");
> > +
> > +     if (do_load(&test[0]))
> > +             report_fail("store triggered by load");
> > +
> > +     report(do_load(&test[1]), "load triggered");
> > +
> > +     if (do_store(&test[1]))
> > +             report_fail("load triggered by store");
> > +
> > +     if (have_three)
> > +             check_exec(2);
> > +
> > +     ret =3D sbi_debug_uninstall_triggers(1, 1);
> > +     sbiret_report_error(&ret, SBI_SUCCESS, "sbi_debug_uninstall_trigg=
ers");
> > +
> > +     if (do_load(&test[1]))
> > +             report_fail("load triggered after uninstall");
> > +
> > +     report(do_store(&test[0]), "store triggered");
> > +
> > +     if (!have_three &&
> > +         dbtr_install_trigger(shmem, exec_call, gen_tdata1(type, VALUE=
_EXECUTE, MODE_S)))
> > +             check_exec(1);
> > +
> > +error:
> > +     ret =3D sbi_debug_uninstall_triggers(0, 1);
> > +     sbiret_report_error(&ret, SBI_SUCCESS, "sbi_debug_uninstall_trigg=
ers");
> > +
> > +     install_exception_handler(EXC_BREAKPOINT, NULL);
> > +     report_prefix_pop();
> > +}
> > +
> > +static void dbtr_test_multiple_types(struct sbi_dbtr_shmem_entry *shme=
m, unsigned long type)
> > +{
> > +     static unsigned long test;
> > +
> > +     report_prefix_push("test multiple types");
> > +
> > +     /* check if loads and stores trigger exec */
> > +     if (!dbtr_install_trigger(shmem, &test,
> > +                          gen_tdata1(type, VALUE_EXECUTE | VALUE_LOAD =
| VALUE_STORE, MODE_S))) {
> > +             report_prefix_pop();
> > +             return;
> > +     }
> > +
> > +     report(do_load(&test), "load triggered");
> > +
> > +     report(do_store(&test), "store triggered");
> > +
> > +     dbtr_uninstall_trigger();
> > +
> > +     /* Check if exec works */
> > +     if (!dbtr_install_trigger(shmem, exec_call,
> > +                          gen_tdata1(type, VALUE_EXECUTE | VALUE_LOAD =
| VALUE_STORE, MODE_S))) {
> > +             report_prefix_pop();
> > +             return;
> > +     }
> > +
> > +     report(do_exec(), "exec triggered");
> > +
> > +     dbtr_uninstall_trigger();
> > +     report_prefix_pop();
> > +}
> > +
> > +static void dbtr_test_disable_uninstall(struct sbi_dbtr_shmem_entry *s=
hmem, enum McontrolType type)
> > +{
> > +     static unsigned long test;
> > +     struct sbiret ret;
> > +
> > +     report_prefix_push("disable uninstall");
> > +     if (!dbtr_install_trigger(shmem, &test, gen_tdata1(type, VALUE_ST=
ORE, MODE_S))) {
> > +             report_prefix_pop();
> > +             return;
> > +     }
> > +
> > +     ret =3D sbi_debug_disable_triggers(0, 1);
> > +     sbiret_report_error(&ret, SBI_SUCCESS, "sbi_debug_disable_trigger=
s");
> > +
> > +     dbtr_uninstall_trigger();
> > +
> > +     if (!dbtr_install_trigger(shmem, &test, gen_tdata1(type, VALUE_ST=
ORE, MODE_S))) {
> > +             report_prefix_pop();
> > +             return;
> > +     }
> > +
> > +     report(do_store(&test), "triggered");
> > +
> > +     dbtr_uninstall_trigger();
> > +     report_prefix_pop();
> > +}
> > +
> > +static void dbtr_test_uninstall_enable(struct sbi_dbtr_shmem_entry *sh=
mem, enum McontrolType type)
> > +{
> > +     static unsigned long test;
> > +     struct sbiret ret;
> > +
> > +     report_prefix_push("uninstall enable");
> > +     if (!dbtr_install_trigger(shmem, &test, gen_tdata1(type, VALUE_ST=
ORE, MODE_S))) {
> > +             report_prefix_pop();
> > +             return;
> > +     }
> > +     dbtr_uninstall_trigger();
> > +
> > +     ret =3D sbi_debug_enable_triggers(0, 1);
> > +     sbiret_report_error(&ret, SBI_SUCCESS, "sbi_debug_enable_triggers=
");
> > +
> > +     install_exception_handler(EXC_BREAKPOINT, dbtr_exception_handler)=
;
> > +
> > +     report(!do_store(&test), "should not trigger");
> > +
> > +     install_exception_handler(EXC_BREAKPOINT, NULL);
> > +     report_prefix_pop();
> > +}
> > +
> > +static void dbtr_test_uninstall_update(struct sbi_dbtr_shmem_entry *sh=
mem, enum McontrolType type)
> > +{
> > +     static unsigned long test;
> > +     struct sbiret ret;
> > +     bool kfail;
> > +
> > +     report_prefix_push("uninstall update");
> > +     if (!dbtr_install_trigger(shmem, NULL, gen_tdata1(type, VALUE_NON=
E, MODE_NONE))) {
> > +             report_prefix_pop();
> > +             return;
> > +     }
> > +
> > +     dbtr_uninstall_trigger();
> > +
> > +     shmem->id.idx =3D 0;
> > +     shmem->data.tdata1 =3D gen_tdata1(type, VALUE_STORE, MODE_S);
> > +     shmem->data.tdata2 =3D (unsigned long)&test;
> > +
> > +     /*
> > +      * Known broken update_triggers.
> > +      * https://lore.kernel.org/opensbi/aDdp1UeUh7GugeHp@ghost/T/#t
> > +      */
> > +     kfail =3D __sbi_get_imp_id() =3D=3D SBI_IMPL_OPENSBI &&
> > +             __sbi_get_imp_version() < sbi_impl_opensbi_mk_version(1, =
7);
> > +     ret =3D sbi_debug_update_triggers(1);
> > +     sbiret_kfail_error(kfail, &ret, SBI_ERR_FAILURE, "sbi_debug_updat=
e_triggers");
> > +
> > +     install_exception_handler(EXC_BREAKPOINT, dbtr_exception_handler)=
;
> > +
> > +     report(!do_store(&test), "should not trigger");
> > +
> > +     install_exception_handler(EXC_BREAKPOINT, NULL);
> > +     report_prefix_pop();
> > +}
> > +
> > +static void dbtr_test_disable_read(struct sbi_dbtr_shmem_entry *shmem,=
 enum McontrolType type)
> > +{
> > +     const unsigned long tstatus_expected =3D SBI_DBTR_TRIG_STATE_S | =
SBI_DBTR_TRIG_STATE_MAPPED;
> > +     const unsigned long tdata1 =3D gen_tdata1(type, VALUE_STORE, MODE=
_NONE);
> > +     static unsigned long test;
> > +     struct sbiret ret;
> > +
> > +     report_prefix_push("disable read");
> > +     if (!dbtr_install_trigger(shmem, &test, gen_tdata1(type, VALUE_ST=
ORE, MODE_S))) {
> > +             report_prefix_pop();
> > +             return;
> > +     }
> > +
> > +     ret =3D sbi_debug_disable_triggers(0, 1);
> > +     sbiret_report_error(&ret, SBI_SUCCESS, "sbi_debug_disable_trigger=
s");
> > +
> > +     ret =3D sbi_debug_read_triggers(0, 1);
> > +     sbiret_report_error(&ret, SBI_SUCCESS, "sbi_debug_read_triggers")=
;
> > +
> > +     report(shmem->data.tdata1 =3D=3D tdata1, "tdata1 expected: 0x%016=
lx", tdata1);
> > +     report_info("tdata1 found: 0x%016lx", shmem->data.tdata1);
> > +     report(shmem->data.tdata2 =3D=3D ((unsigned long)&test), "tdata2 =
expected: 0x%016lx",
> > +            (unsigned long)&test);
> > +     report_info("tdata2 found: 0x%016lx", shmem->data.tdata2);
> > +     report(shmem->data.tstate =3D=3D tstatus_expected, "tstate expect=
ed: 0x%016lx", tstatus_expected);
> > +     report_info("tstate found: 0x%016lx", shmem->data.tstate);
>
> Same comment about not needing to split this.
>
> > +
> > +     dbtr_uninstall_trigger();
> > +     report_prefix_pop();
> > +}
> > +
> > +void check_dbtr(void)
> > +{
> > +     static struct sbi_dbtr_shmem_entry shmem[RV_MAX_TRIGGERS] =3D {};
> > +     unsigned long num_trigs;
> > +     enum McontrolType trig_type;
> > +     struct sbiret ret;
> > +
> > +     report_prefix_push("dbtr");
> > +
> > +     if (!sbi_probe(SBI_EXT_DBTR)) {
> > +             report_skip("extension not available");
> > +             report_prefix_pop();
> > +             return;
>
> Could rename the 'error' label to something else and goto it from here
> too.

Is `dtbr_exit_test` ok?

>
> > +     }
> > +
> > +     if (__sbi_get_imp_id() =3D=3D SBI_IMPL_OPENSBI &&
> > +         __sbi_get_imp_version() < sbi_impl_opensbi_mk_version(1, 5)) =
{
> > +             report_skip("OpenSBI < v1.5 detected, skipping tests");
> > +             report_prefix_pop();
> > +             return;
>
> Why do we need to do this? Isn't the DBTR probe above enough?

I copied it from the sbi-sse.c file none of the other tests do this so
I'll remove it.

Thanks,
Jesse Taube

>
> > +     }
> > +
> > +     num_trigs =3D dbtr_test_num_triggers();
> > +     if (!num_trigs)
> > +             goto error;
> > +
> > +     trig_type =3D dbtr_test_type(&num_trigs);
> > +     if (trig_type =3D=3D SBI_DBTR_TDATA1_TYPE_NONE)
> > +             goto error;
> > +
> > +     ret =3D sbi_debug_set_shmem(shmem);
> > +     sbiret_report_error(&ret, SBI_SUCCESS, "sbi_debug_set_shmem");
> > +
> > +     ret =3D dbtr_test_store_install_uninstall(&shmem[0], trig_type);
> > +     /* install or uninstall failed */
> > +     if (ret.error !=3D SBI_SUCCESS)
> > +             goto error;
> > +
> > +     dbtr_test_load(&shmem[0], trig_type);
> > +     dbtr_test_exec(&shmem[0], trig_type);
> > +     dbtr_test_read(&shmem[0], trig_type);
> > +     dbtr_test_disable_enable(&shmem[0], trig_type);
> > +     dbtr_test_update(&shmem[0], trig_type);
> > +     dbtr_test_multiple_types(&shmem[0], trig_type);
> > +     dbtr_test_multiple(shmem, trig_type, num_trigs);
> > +     dbtr_test_disable_uninstall(&shmem[0], trig_type);
> > +     dbtr_test_uninstall_enable(&shmem[0], trig_type);
> > +     dbtr_test_uninstall_update(&shmem[0], trig_type);
> > +     dbtr_test_disable_read(&shmem[0], trig_type);
> > +
> > +error:
> > +     report_prefix_pop();
> > +}
> > diff --git a/riscv/sbi-tests.h b/riscv/sbi-tests.h
> > index d5c4ae70..c1ebf016 100644
> > --- a/riscv/sbi-tests.h
> > +++ b/riscv/sbi-tests.h
> > @@ -97,8 +97,10 @@ static inline bool env_enabled(const char *env)
> >       return s && (*s =3D=3D '1' || *s =3D=3D 'y' || *s =3D=3D 'Y');
> >  }
> >
> > +void split_phys_addr(phys_addr_t paddr, unsigned long *hi, unsigned lo=
ng *lo);
> >  void sbi_bad_fid(int ext);
> >  void check_sse(void);
> > +void check_dbtr(void);
> >
> >  #endif /* __ASSEMBLER__ */
> >  #endif /* _RISCV_SBI_TESTS_H_ */
> > diff --git a/riscv/sbi.c b/riscv/sbi.c
> > index edb1a6be..3b8aadce 100644
> > --- a/riscv/sbi.c
> > +++ b/riscv/sbi.c
> > @@ -105,7 +105,7 @@ static int rand_online_cpu(prng_state *ps)
> >       return cpu;
> >  }
> >
> > -static void split_phys_addr(phys_addr_t paddr, unsigned long *hi, unsi=
gned long *lo)
> > +void split_phys_addr(phys_addr_t paddr, unsigned long *hi, unsigned lo=
ng *lo)
> >  {
> >       *lo =3D (unsigned long)paddr;
> >       *hi =3D 0;
> > @@ -1561,6 +1561,7 @@ int main(int argc, char **argv)
> >       check_susp();
> >       check_sse();
> >       check_fwft();
> > +     check_dbtr();
> >
> >       return report_summary();
> >  }
> > --
> > 2.43.0
> >
>
> Thanks,
> drew

