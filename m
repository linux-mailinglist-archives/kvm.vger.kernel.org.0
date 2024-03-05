Return-Path: <kvm+bounces-10851-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 825F6871382
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 03:19:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B8993B2079A
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 02:19:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB7321803A;
	Tue,  5 Mar 2024 02:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TB7EZFMz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7740A610B
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 02:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709605181; cv=none; b=OmzYfIAK8S5BSO1sQ39PLMeMK55fj8bbMTPfC4CcNPG6ZzNWcyJToWiiGwgXCS7iUw5iwyapulN389bcdTspBM/+x5orJrJWK3nKGTo+ub69yYv/6YQc137kiEaNnMz43zLqecpfV2EevX9fQ4NgA1aatjB8H1LKt5g382kZwnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709605181; c=relaxed/simple;
	bh=JV4qjR9ZBuxTdn5lxk7wLvyNHDLLYnX4J84gCKMybCA=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=d4+0iU4XIBB0VWAezmU1VNcp5TormZy7blQD0xWV43DKs16VxMSr1rfg8GSXYXce1Ke2ljfm7BtRU7Q4IddP3VWVZrMijFhh2T/FChw1bKw7AhNfR31FvikKQTFxhx+RbQHyxQdBbd9OvGMkF3/G5GzAoms2DZ4deFkTqR0TpBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TB7EZFMz; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-5d81b08d6f2so4751610a12.0
        for <kvm@vger.kernel.org>; Mon, 04 Mar 2024 18:19:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709605179; x=1710209979; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eoJ8PMFG+qLmT7z1XiSRXTkrr7OydTzzYFpmF/A+8/k=;
        b=TB7EZFMzJtC3qNqVoHC18SXJuA1kSMIg6/2c+2EpbAeVa82FIuEQEJf0xxzANHbZRf
         zclOlTigrMKJ3HXgBC3rxmZXVTDoSHcB1rFOE33cZzswDdc+H/iAxBWYcZ5Y5ze3CrNB
         2VLghK1TPCT49PqsDcItVmdoERzj1arelEpqnxxJ4GSmN7mo7NRNLH/lr7jdfX4IKJZk
         j3tzUAI0HGro5hgvTtkgfHO91Az/63c+CsKlf5xPBgHSI/tw4+4yjIf7b/QRpBTibWka
         BDJJTbdpNSmlcMq79EViTXJPWLCEtSSRiKjVyM0IfWBk1Q3i3zPv5fqCK0Do2g9HqRe7
         l8dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709605179; x=1710209979;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=eoJ8PMFG+qLmT7z1XiSRXTkrr7OydTzzYFpmF/A+8/k=;
        b=KwQafud/y/Ll5ubDErxplnuyhisfYU/RGyKa1MwJWz7aHm5m9Z72zCp2eEgM3SvcRv
         TOxEiT11drOis2hhUHyV/mkqDcrO+OgYRqpmEuWRcvs7mHdioErLuupIK7ulN4KBYjXN
         e+8BEocz2z2Y+8OxXnJ6+zmwYTOi2zbo45iP601E4Nw4lK5IgkmalAyIt5teyAYSJ0Qj
         0YOJpLoTfo/Yl1tUtkoFZBHw8yeYy1tsEua5ISm2AVWGFbLleXPrdZ5sf/tkQ2jH19Fy
         TSLA51Y3acGo2kC0xr/POxzWc3EnHk33ZjzC0lkYI8iyDiS/6BiiWbsm6X4ee4ROSjOz
         vjcw==
X-Forwarded-Encrypted: i=1; AJvYcCWpJghAwkfWDJrx8GeU1Fyx2rSDGRR7B3JAWeznk1oQgI+dHXvNcy68JNpEIzU4Mw1kvg2J4ZR1/8/tF+zGh7zfhFSm
X-Gm-Message-State: AOJu0YyWB6fUUWdBD8xhfoTTA6YMFdb+feCfFnYVczKgGbXtNn9alMHY
	gNMh20ly2b3paQrVmen13v5a7KzWLEU1dF00QhIRmToyEUnArOgg7bb2lI/H
X-Google-Smtp-Source: AGHT+IHgpjCWKep0JPfgj37yDf77qRqL+JTEAVLUknvmT32wbjHdHn49KfPQi5Vfs9R9lc6DQCU2ig==
X-Received: by 2002:a05:6a20:9587:b0:1a1:48df:e19a with SMTP id iu7-20020a056a20958700b001a148dfe19amr600895pzb.35.1709605178648;
        Mon, 04 Mar 2024 18:19:38 -0800 (PST)
Received: from localhost (220-235-220-130.tpgi.com.au. [220.235.220.130])
        by smtp.gmail.com with ESMTPSA id j4-20020a635944000000b005e43cce33f8sm7984554pgm.88.2024.03.04.18.19.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Mar 2024 18:19:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 05 Mar 2024 12:19:32 +1000
Message-Id: <CZLGGDYWE8P0.VKR8WWH6B6LM@wheely>
Cc: "Laurent Vivier" <lvivier@redhat.com>, "Andrew Jones"
 <andrew.jones@linux.dev>, "Paolo Bonzini" <pbonzini@redhat.com>, "Joel
 Stanley" <joel@jms.id.au>, <linuxppc-dev@lists.ozlabs.org>,
 <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH 14/32] powerpc: general interrupt tests
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Thomas Huth" <thuth@redhat.com>
X-Mailer: aerc 0.15.2
References: <20240226101218.1472843-1-npiggin@gmail.com>
 <20240226101218.1472843-15-npiggin@gmail.com>
 <1b89e399-1160-4fca-a9d7-89d60fc9a710@redhat.com>
In-Reply-To: <1b89e399-1160-4fca-a9d7-89d60fc9a710@redhat.com>

On Fri Mar 1, 2024 at 10:41 PM AEST, Thomas Huth wrote:
> On 26/02/2024 11.12, Nicholas Piggin wrote:
> > Add basic testing of various kinds of interrupts, machine check,
> > page fault, illegal, decrementer, trace, syscall, etc.
> >=20
> > This has a known failure on QEMU TCG pseries machines where MSR[ME]
> > can be incorrectly set to 0.
>
> Two questions out of curiosity:
>
> Any chance that this could be fixed easily in QEMU?

Yes I have a fix on the mailing list. It should get into 9.0 and
probably stable.

> Or is there a way to detect TCG from within the test? (for example, we ha=
ve=20
> a host_is_tcg() function for s390x so we can e.g. use report_xfail() for=
=20
> tests that are known to fail on TCG there)

I do have a half-done patch which adds exactly this.

One (minor) annoyance is that it doesn't seem possible to detect QEMU
version to add workarounds. E.g., we would like to test the fixed
functionality, but older qemu should not. Maybe that's going too much
into a rabbit hole. We *could* put a QEMU version into device tree
to deal with this though...

Thanks,
Nick
>
> > Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> > ---
> >   lib/powerpc/asm/processor.h |   4 +
> >   lib/powerpc/asm/reg.h       |  17 ++
> >   lib/powerpc/setup.c         |  11 +
> >   lib/ppc64/asm/ptrace.h      |  16 ++
> >   powerpc/Makefile.common     |   3 +-
> >   powerpc/interrupts.c        | 415 +++++++++++++++++++++++++++++++++++=
+
> >   powerpc/unittests.cfg       |   3 +
> >   7 files changed, 468 insertions(+), 1 deletion(-)
> >   create mode 100644 powerpc/interrupts.c
> >=20
> > diff --git a/lib/powerpc/asm/processor.h b/lib/powerpc/asm/processor.h
> > index cf1b9d8ff..eed37d1f4 100644
> > --- a/lib/powerpc/asm/processor.h
> > +++ b/lib/powerpc/asm/processor.h
> > @@ -11,7 +11,11 @@ void do_handle_exception(struct pt_regs *regs);
> >   #endif /* __ASSEMBLY__ */
> >  =20
> >   extern bool cpu_has_hv;
> > +extern bool cpu_has_power_mce;
> > +extern bool cpu_has_siar;
> >   extern bool cpu_has_heai;
> > +extern bool cpu_has_prefix;
> > +extern bool cpu_has_sc_lev;
> >  =20
> >   static inline uint64_t mfspr(int nr)
> >   {
> > diff --git a/lib/powerpc/asm/reg.h b/lib/powerpc/asm/reg.h
> > index 782e75527..d6097f48f 100644
> > --- a/lib/powerpc/asm/reg.h
> > +++ b/lib/powerpc/asm/reg.h
> > @@ -5,8 +5,15 @@
> >  =20
> >   #define UL(x) _AC(x, UL)
> >  =20
> > +#define SPR_DSISR	0x012
> > +#define SPR_DAR		0x013
> > +#define SPR_DEC		0x016
> >   #define SPR_SRR0	0x01a
> >   #define SPR_SRR1	0x01b
> > +#define   SRR1_PREFIX		UL(0x20000000)
> > +#define SPR_FSCR	0x099
> > +#define   FSCR_PREFIX		UL(0x2000)
> > +#define SPR_HFSCR	0x0be
> >   #define SPR_TB		0x10c
> >   #define SPR_SPRG0	0x110
> >   #define SPR_SPRG1	0x111
> > @@ -22,12 +29,17 @@
> >   #define   PVR_VER_POWER8	UL(0x004d0000)
> >   #define   PVR_VER_POWER9	UL(0x004e0000)
> >   #define   PVR_VER_POWER10	UL(0x00800000)
> > +#define SPR_HDEC	0x136
> >   #define SPR_HSRR0	0x13a
> >   #define SPR_HSRR1	0x13b
> > +#define SPR_LPCR	0x13e
> > +#define   LPCR_HDICE		UL(0x1)
> > +#define SPR_HEIR	0x153
> >   #define SPR_MMCR0	0x31b
> >   #define   MMCR0_FC		UL(0x80000000)
> >   #define   MMCR0_PMAE		UL(0x04000000)
> >   #define   MMCR0_PMAO		UL(0x00000080)
> > +#define SPR_SIAR	0x31c
> >  =20
> >   /* Machine State Register definitions: */
> >   #define MSR_LE_BIT	0
> > @@ -35,6 +47,11 @@
> >   #define MSR_HV_BIT	60			/* Hypervisor mode */
> >   #define MSR_SF_BIT	63			/* 64-bit mode */
> >  =20
> > +#define MSR_DR		UL(0x0010)
> > +#define MSR_IR		UL(0x0020)
> > +#define MSR_BE		UL(0x0200)		/* Branch Trace Enable */
> > +#define MSR_SE		UL(0x0400)		/* Single Step Enable */
> > +#define MSR_EE		UL(0x8000)
> >   #define MSR_ME		UL(0x1000)
> >  =20
> >   #endif
> > diff --git a/lib/powerpc/setup.c b/lib/powerpc/setup.c
> > index 3c81aee9e..9b665f59c 100644
> > --- a/lib/powerpc/setup.c
> > +++ b/lib/powerpc/setup.c
> > @@ -87,7 +87,11 @@ static void cpu_set(int fdtnode, u64 regval, void *i=
nfo)
> >   }
> >  =20
> >   bool cpu_has_hv;
> > +bool cpu_has_power_mce; /* POWER CPU machine checks */
> > +bool cpu_has_siar;
> >   bool cpu_has_heai;
> > +bool cpu_has_prefix;
> > +bool cpu_has_sc_lev; /* sc interrupt has LEV field in SRR1 */
> >  =20
> >   static void cpu_init(void)
> >   {
> > @@ -112,15 +116,22 @@ static void cpu_init(void)
> >  =20
> >   	switch (mfspr(SPR_PVR) & PVR_VERSION_MASK) {
> >   	case PVR_VER_POWER10:
> > +		cpu_has_prefix =3D true;
> > +		cpu_has_sc_lev =3D true;
> >   	case PVR_VER_POWER9:
> >   	case PVR_VER_POWER8E:
> >   	case PVR_VER_POWER8NVL:
> >   	case PVR_VER_POWER8:
> > +		cpu_has_power_mce =3D true;
> >   		cpu_has_heai =3D true;
> > +		cpu_has_siar =3D true;
> >   		break;
> >   	default:
> >   		break;
> >   	}
> > +
> > +	if (!cpu_has_hv) /* HEIR is HV register */
> > +		cpu_has_heai =3D false;
> >   }
> >  =20
> >   static void mem_init(phys_addr_t freemem_start)
> > diff --git a/lib/ppc64/asm/ptrace.h b/lib/ppc64/asm/ptrace.h
> > index 12de7499b..db263a59e 100644
> > --- a/lib/ppc64/asm/ptrace.h
> > +++ b/lib/ppc64/asm/ptrace.h
> > @@ -5,6 +5,9 @@
> >   #define STACK_FRAME_OVERHEAD    112     /* size of minimum stack fram=
e */
> >  =20
> >   #ifndef __ASSEMBLY__
> > +
> > +#include <asm/reg.h>
> > +
> >   struct pt_regs {
> >   	unsigned long gpr[32];
> >   	unsigned long nip;
> > @@ -17,6 +20,19 @@ struct pt_regs {
> >   	unsigned long _pad; /* stack must be 16-byte aligned */
> >   };
> >  =20
> > +static inline bool regs_is_prefix(volatile struct pt_regs *regs)
> > +{
> > +	return regs->msr & SRR1_PREFIX;
> > +}
> > +
> > +static inline void regs_advance_insn(struct pt_regs *regs)
> > +{
> > +	if (regs_is_prefix(regs))
> > +		regs->nip +=3D 8;
> > +	else
> > +		regs->nip +=3D 4;
> > +}
> > +
> >   #define STACK_INT_FRAME_SIZE    (sizeof(struct pt_regs) + \
> >   				 STACK_FRAME_OVERHEAD + KERNEL_REDZONE_SIZE)
> >  =20
> > diff --git a/powerpc/Makefile.common b/powerpc/Makefile.common
> > index 1e181da69..68165fc25 100644
> > --- a/powerpc/Makefile.common
> > +++ b/powerpc/Makefile.common
> > @@ -12,7 +12,8 @@ tests-common =3D \
> >   	$(TEST_DIR)/rtas.elf \
> >   	$(TEST_DIR)/emulator.elf \
> >   	$(TEST_DIR)/tm.elf \
> > -	$(TEST_DIR)/sprs.elf
> > +	$(TEST_DIR)/sprs.elf \
> > +	$(TEST_DIR)/interrupts.elf
> >  =20
> >   tests-all =3D $(tests-common) $(tests)
> >   all: directories $(TEST_DIR)/boot_rom.bin $(tests-all)
> > diff --git a/powerpc/interrupts.c b/powerpc/interrupts.c
> > new file mode 100644
> > index 000000000..442f8c569
> > --- /dev/null
> > +++ b/powerpc/interrupts.c
> > @@ -0,0 +1,415 @@
> > +/*
> > + * Test interrupts
> > + *
> > + * Copyright 2024 Nicholas Piggin, IBM Corp.
> > + *
> > + * This work is licensed under the terms of the GNU LGPL, version 2.
>
> I know, we're using this line in a lot of source files ... but maybe we=
=20
> should do better for new files at least: "LGPL, version 2" is a little bi=
t=20
> ambiguous: Does it mean the "Library GPL version 2.0" or the "Lesser GPL=
=20
> version 2.1"? Maybe you could clarify by additionally providing a SPDX=20
> identifier here, or by explicitly writing 2.0 or 2.1.

Sure I'll try to improve this for all the new files.

Thanks,
Nick

