Return-Path: <kvm+bounces-5134-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A24281C7AF
	for <lists+kvm@lfdr.de>; Fri, 22 Dec 2023 10:59:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C00C3B20FAA
	for <lists+kvm@lfdr.de>; Fri, 22 Dec 2023 09:59:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25953101CF;
	Fri, 22 Dec 2023 09:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hoPu9th2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D991EFBE2
	for <kvm@vger.kernel.org>; Fri, 22 Dec 2023 09:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-5cda24a77e0so900797a12.2
        for <kvm@vger.kernel.org>; Fri, 22 Dec 2023 01:58:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703239131; x=1703843931; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KTcCxUJL27ddH6D5M9oVZhfnGUHce9L/DOCN/1SMV+s=;
        b=hoPu9th2ugfU2iRh3P9zwxESPljHsA8QBxAgjBe05dvJb9x7EQ0zEut6ZdX8tE7g13
         EJcvcHDpVJS1Vmg3TOcZ7+mUkFg+plbZGOPFXik9e0zpM+ZTZTRWG7qpUdqwqFM2pbrc
         VuFXl/3GjcmgRyNOkC6SCGaX29JJlJ80WyJUsvzavHj6WiJBrEuTHnq3BdxJbIF5a+Bb
         5F58KOCcQouFZHUlicG7hYguJfYnD1KHCxnzely7D9+uFYImBBQVku0+l0v8Srank/Zm
         oWBEyL2WV9U3CyXPw93wrb2qcVACB++A9ySh9ga2beehrMVZWNDBqH1mxU1561+6u6eD
         Tv9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703239131; x=1703843931;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=KTcCxUJL27ddH6D5M9oVZhfnGUHce9L/DOCN/1SMV+s=;
        b=sRCunYdlRgD4Ysvays82Jy6TQM7/rdvicUHaR0jvNl4i8xk9IerdE3+V+nngYf35jJ
         PuJRMDNzmiDlYR8A9QlVB6fS8ueg/8g/vfEZW/bCXvUe2blSfn/7VQtGKA6Ue9H94OMR
         8DAz+H4asC2ruILmoQkReJzue5TjgGML5Ul5SvxUPddTqlP/k7rLDnWn6oitifEymOqq
         WHn6JSLt+Dl+0nqfAPJcuqmsnK89EN0NdsAu+gZWQgFYXctGrjKQfy46T26YSf7nkfWV
         qWGlVPLxmLzLq80nbov09prYy1c2BQ/STuEpPibACiaijtLC5hqeA6TiomhRH+giGpvJ
         u/TQ==
X-Gm-Message-State: AOJu0YwFRJogG50Mo+4OntnLDKaKfJUUteprA1xD0l0ynSvn+MtqFMvg
	pAGNZukvs5duB5OxouWJsdCQkWkYSzI=
X-Google-Smtp-Source: AGHT+IGOXE3Ldg+t9qQs+zrxUZCTaS3wif1/k2EocGhfOSk6zUmeSDem9TPtdES9niPNcG25Gjq6FA==
X-Received: by 2002:a05:6a20:9304:b0:186:aac2:26b9 with SMTP id r4-20020a056a20930400b00186aac226b9mr683682pzh.30.1703239131096;
        Fri, 22 Dec 2023 01:58:51 -0800 (PST)
Received: from localhost ([203.220.145.68])
        by smtp.gmail.com with ESMTPSA id qi10-20020a17090b274a00b0028b005bf19esm7061986pjb.34.2023.12.22.01.58.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Dec 2023 01:58:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 22 Dec 2023 19:58:45 +1000
Message-Id: <CXURVO6COZBK.2YISETA5D0C2@wheely>
Cc: <linuxppc-dev@lists.ozlabs.org>, "Laurent Vivier" <lvivier@redhat.com>,
 "Shaoqin Huang" <shahuang@redhat.com>, "Andrew Jones"
 <andrew.jones@linux.dev>, "Nico Boehr" <nrb@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v5 24/29] powerpc: interrupt tests
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Thomas Huth" <thuth@redhat.com>, <kvm@vger.kernel.org>
X-Mailer: aerc 0.15.2
References: <20231216134257.1743345-1-npiggin@gmail.com>
 <20231216134257.1743345-25-npiggin@gmail.com>
 <feab6612-31f6-41bd-8ee9-89a19aa0e76c@redhat.com>
In-Reply-To: <feab6612-31f6-41bd-8ee9-89a19aa0e76c@redhat.com>

On Tue Dec 19, 2023 at 11:57 PM AEST, Thomas Huth wrote:
> On 16/12/2023 14.42, Nicholas Piggin wrote:
> > Add basic testing of various kinds of interrupts, machine check,
> > page fault, illegal, decrementer, trace, syscall, etc.
> >=20
> > This has a known failure on QEMU TCG pseries machines where MSR[ME]
> > can be incorrectly set to 0.
> >=20
> > Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> > ---
> >   lib/powerpc/asm/ppc_asm.h |  21 +-
> >   powerpc/Makefile.common   |   3 +-
> >   powerpc/interrupts.c      | 422 +++++++++++++++++++++++++++++++++++++=
+
> >   powerpc/unittests.cfg     |   3 +
> >   4 files changed, 445 insertions(+), 4 deletions(-)
> >   create mode 100644 powerpc/interrupts.c
> >=20
> > diff --git a/lib/powerpc/asm/ppc_asm.h b/lib/powerpc/asm/ppc_asm.h
> > index ef2d91dd..778e78ee 100644
> > --- a/lib/powerpc/asm/ppc_asm.h
> > +++ b/lib/powerpc/asm/ppc_asm.h
> > @@ -35,17 +35,32 @@
> >  =20
> >   #endif /* __BYTE_ORDER__ */
> >  =20
> > +#define SPR_DSISR	0x012
> > +#define SPR_DAR		0x013
> > +#define SPR_DEC		0x016
> > +#define SPR_SRR0	0x01A
> > +#define SPR_SRR1	0x01B
> > +#define SPR_FSCR	0x099
> > +#define   FSCR_PREFIX	0x2000
> > +#define SPR_HDEC	0x136
> >   #define SPR_HSRR0	0x13A
> >   #define SPR_HSRR1	0x13B
> > +#define SPR_LPCR	0x13E
> > +#define   LPCR_HDICE	0x1UL
> > +#define SPR_HEIR	0x153
> > +#define SPR_SIAR	0x31C
> >  =20
> >   /* Machine State Register definitions: */
> >   #define MSR_LE_BIT	0
> >   #define MSR_EE_BIT	15			/* External Interrupts Enable */
> >   #define MSR_HV_BIT	60			/* Hypervisor mode */
> >   #define MSR_SF_BIT	63			/* 64-bit mode */
> > -#define MSR_ME		0x1000ULL
> >  =20
> > -#define SPR_HSRR0	0x13A
> > -#define SPR_HSRR1	0x13B
> > +#define MSR_DR		0x0010ULL
> > +#define MSR_IR		0x0020ULL
> > +#define MSR_BE		0x0200ULL		/* Branch Trace Enable */
> > +#define MSR_SE		0x0400ULL		/* Single Step Enable */
> > +#define MSR_EE		0x8000ULL
> > +#define MSR_ME		0x1000ULL
> >  =20
> >   #endif /* _ASMPOWERPC_PPC_ASM_H */
> > diff --git a/powerpc/Makefile.common b/powerpc/Makefile.common
> > index a7af225b..b340a53b 100644
> > --- a/powerpc/Makefile.common
> > +++ b/powerpc/Makefile.common
> > @@ -11,7 +11,8 @@ tests-common =3D \
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
> > index 00000000..3217b15e
> > --- /dev/null
> > +++ b/powerpc/interrupts.c
> > @@ -0,0 +1,422 @@
> > +/*
> > + * Test interrupts
> > + *
> > + * This work is licensed under the terms of the GNU LGPL, version 2.
> > + */
> > +#include <libcflat.h>
> > +#include <util.h>
> > +#include <migrate.h>
> > +#include <alloc.h>
> > +#include <asm/handlers.h>
> > +#include <asm/hcall.h>
> > +#include <asm/processor.h>
> > +#include <asm/barrier.h>
> > +
> > +#define SPR_LPCR	0x13E
> > +#define LPCR_HDICE	0x1UL
> > +#define SPR_DEC		0x016
> > +#define SPR_HDEC	0x136
> > +
> > +#define MSR_DR		0x0010ULL
> > +#define MSR_IR		0x0020ULL
> > +#define MSR_EE		0x8000ULL
> > +#define MSR_ME		0x1000ULL
>
> Why don't you use the definitions from ppc_asm.h above?

Yeah, should be more consistent with those. I'll take a look.

>
> > +static bool cpu_has_heir(void)
> > +{
> > +	uint32_t pvr =3D mfspr(287);	/* Processor Version Register */
> > +
> > +	if (!machine_is_powernv())
> > +		return false;
> > +
> > +	/* POWER6 has HEIR, but QEMU powernv support does not go that far */
> > +	switch (pvr >> 16) {
> > +	case 0x4b:			/* POWER8E */
> > +	case 0x4c:			/* POWER8NVL */
> > +	case 0x4d:			/* POWER8 */
> > +	case 0x4e:			/* POWER9 */
> > +	case 0x80:			/* POWER10 */
>
> I'd suggest to introduce some #defines for those PVR values instead of us=
ing=20
> magic numbers all over the place?

Yeah you're right.

>
> > +		return true;
> > +	default:
> > +		return false;
> > +	}
> > +}
> > +
> > +static bool cpu_has_prefix(void)
> > +{
> > +	uint32_t pvr =3D mfspr(287);	/* Processor Version Register */
> > +	switch (pvr >> 16) {
> > +	case 0x80:			/* POWER10 */
> > +		return true;
> > +	default:
> > +		return false;
> > +	}
> > +}
> > +
> > +static bool cpu_has_lev_in_srr1(void)
> > +{
> > +	uint32_t pvr =3D mfspr(287);	/* Processor Version Register */
> > +	switch (pvr >> 16) {
> > +	case 0x80:			/* POWER10 */
> > +		return true;
> > +	default:
> > +		return false;
> > +	}
> > +}
> > +
> > +static bool regs_is_prefix(volatile struct pt_regs *regs)
> > +{
> > +	return (regs->msr >> (63-34)) & 1;
>
> You introduced a bunch of new #define MSR_xx statements ... why not for t=
his=20
> one, too?

It's an interrupt-specific bit so SRR1_xx, but yes it should be a
define.

>
> > +}
> > +
> > +static void regs_advance_insn(struct pt_regs *regs)
> > +{
> > +	if (regs_is_prefix(regs))
> > +		regs->nip +=3D 8;
> > +	else
> > +		regs->nip +=3D 4;
> > +}
> > +
> > +static volatile bool got_interrupt;
> > +static volatile struct pt_regs recorded_regs;
> > +
> > +static void mce_handler(struct pt_regs *regs, void *opaque)
> > +{
> > +	got_interrupt =3D true;
> > +	memcpy((void *)&recorded_regs, regs, sizeof(struct pt_regs));
> > +	regs_advance_insn(regs);
> > +}
> > +
> > +static void test_mce(void)
> > +{
> > +	unsigned long addr =3D -4ULL;
> > +	uint8_t tmp;
> > +
> > +	handle_exception(0x200, mce_handler, NULL);
> > +
> > +	if (machine_is_powernv()) {
> > +		enable_mcheck();
> > +	} else {
> > +		report(mfmsr() & MSR_ME, "pseries machine has MSR[ME]=3D1");
> > +		if (!(mfmsr() & MSR_ME)) { /* try to fix it */
> > +			enable_mcheck();
> > +		}
> > +		if (mfmsr() & MSR_ME) {
> > +			disable_mcheck();
> > +			report(mfmsr() & MSR_ME, "pseries is unable to change MSR[ME]");
> > +			if (!(mfmsr() & MSR_ME)) { /* try to fix it */
> > +				enable_mcheck();
> > +			}
> > +		}
> > +	}
> > +
> > +	asm volatile("lbz %0,0(%1)" : "=3Dr"(tmp) : "r"(addr));
> > +
> > +	report(got_interrupt, "MCE on access to invalid real address");
> > +	report(mfspr(SPR_DAR) =3D=3D addr, "MCE sets DAR correctly");
> > +	got_interrupt =3D false;
> > +}
> > +
> > +static void dseg_handler(struct pt_regs *regs, void *data)
> > +{
> > +	got_interrupt =3D true;
> > +	memcpy((void *)&recorded_regs, regs, sizeof(struct pt_regs));
> > +	regs_advance_insn(regs);
> > +	regs->msr &=3D ~MSR_DR;
> > +}
> > +
> > +static void test_dseg(void)
> > +{
> > +	uint64_t msr, tmp;
> > +
> > +	report_prefix_push("data segment");
> > +
> > +	/* Some HV start in radix mode and need 0x300 */
> > +	handle_exception(0x300, &dseg_handler, NULL);
> > +	handle_exception(0x380, &dseg_handler, NULL);
> > +
> > +	asm volatile(
> > +"		mfmsr	%0		\n \
> > +		ori	%0,%0,%2	\n \
> > +		mtmsrd	%0		\n \
> > +		lbz	%1,0(0)		"
> > +		: "=3Dr"(msr), "=3Dr"(tmp) : "i"(MSR_DR): "memory");
> > +
> > +	report(got_interrupt, "interrupt on NULL dereference");
> > +	got_interrupt =3D false;
> > +
> > +	handle_exception(0x300, NULL, NULL);
> > +	handle_exception(0x380, NULL, NULL);
> > +
> > +	report_prefix_pop();
> > +}
> > +
> > +static void dec_handler(struct pt_regs *regs, void *data)
> > +{
> > +	got_interrupt =3D true;
> > +	memcpy((void *)&recorded_regs, regs, sizeof(struct pt_regs));
> > +	regs->msr &=3D ~MSR_EE;
> > +}
> > +
> > +static void test_dec(void)
> > +{
> > +	uint64_t msr;
> > +
> > +	report_prefix_push("decrementer");
> > +
> > +	handle_exception(0x900, &dec_handler, NULL);
> > +
> > +	asm volatile(
> > +"		mtdec	%1		\n \
> > +		mfmsr	%0		\n \
> > +		ori	%0,%0,%2	\n \
> > +		mtmsrd	%0,1		"
> > +		: "=3Dr"(msr) : "r"(10000), "i"(MSR_EE): "memory");
> > +
> > +	while (!got_interrupt)
> > +		;
>
> Maybe add a timeout (in case the interrupt never fires)?

Yeah that would improve things.

> > +	report(got_interrupt, "interrupt on decrementer underflow");
> > +	got_interrupt =3D false;
> > +
> > +	handle_exception(0x900, NULL, NULL);
> > +
> > +	if (!machine_is_powernv())
> > +		goto done;
> > +
> > +	handle_exception(0x980, &dec_handler, NULL);
> > +
> > +	mtspr(SPR_LPCR, mfspr(SPR_LPCR) | LPCR_HDICE);
> > +	asm volatile(
> > +"		mtspr	0x136,%1	\n \
> > +		mtdec	%3		\n \
> > +		mfmsr	%0		\n \
> > +		ori	%0,%0,%2	\n \
> > +		mtmsrd	%0,1		"
> > +		: "=3Dr"(msr) : "r"(10000), "i"(MSR_EE), "r"(0x7fffffff): "memory");
> > +
> > +	while (!got_interrupt)
> > +		;
>
> dito?

Will do.

Thanks,
Nick

