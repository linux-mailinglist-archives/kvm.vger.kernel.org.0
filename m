Return-Path: <kvm+bounces-10848-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C1EC5871361
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 03:12:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E1A3DB25236
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 02:12:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 456A418032;
	Tue,  5 Mar 2024 02:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TOZMhhNJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00BE517C95
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 02:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709604767; cv=none; b=rQzvLCpJznei+fD3anjsaM8403aOib9eTMArqTLQdqZFnzm5I2Q6DROb9Sqe5chjyPLUwFEmRYx4C8EUElLOHZUsFhkTVNF9mSPXkmT5Z81RQeLkyRogNhWxay+rshSQajl6obZMng8Rr40IYVeSCFoW6jMoZdmNPWO+g0QyFlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709604767; c=relaxed/simple;
	bh=xdP+I2ry0S3k2K36+Fj2FnOYPCTVwpua6MeJxTolwa0=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=sJDzpmp6LivGe+kN67MztLq1smUryzZ7BFmaeW2DYnfjEf7p9ete6VT4GpRcRyz1ekx9dzOoqgolvYgkZk8O8krPn3IH1UaKRrmmBVSwiieD2f5YoN9ekbQX9cosJWLSy0ZIvxHnoEVsZndGEM2IQsJTNgSrxiHhSu2YOvyJrGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TOZMhhNJ; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-6e617b39877so1562015b3a.3
        for <kvm@vger.kernel.org>; Mon, 04 Mar 2024 18:12:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709604765; x=1710209565; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6+XQ3M+Esqxw+BYm1LMLo360LMfLh1KPGarB/Ars53U=;
        b=TOZMhhNJF0CjOlIJY4mdUPdJLXYt35SP0nBF0a2LLg511psSMatECnvws/eWrqGTe/
         KBs+YoWNEH61ECtj7CVTYu4D3YO04kSJikl1pusWZevMTP54BiOEsXVKshvpSgQ7+BYg
         J36ju7rXA+Rxevm8IiX0OAzQ6+5WJ/f8PyqdfsarDei0rSyTvqRF7X673wJ5gNSEnfZt
         M8+doSUVQz+82cj5JWQZNQH7gfByVXhraxnm/5vsgKP+L6wu/gBtqsWwW/zwIZxZ+1VJ
         mlU/2LWkYyhlmeNi33PcgELBxXw8R++rtiroK6uhyz0+sGEcVwe+51a1ekrAz4wf9ORI
         nIFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709604765; x=1710209565;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=6+XQ3M+Esqxw+BYm1LMLo360LMfLh1KPGarB/Ars53U=;
        b=Z8WdBfo0i72Sa6EeLdmF8ssFazaXshw3LxiS2/qFZEU/IEjEVxV6G+E8KEokG5HbgO
         yhNzCYV43VFUWFLtB96yCxshg7G/swJiw8d8bXZDbmwv5k6KAI2MYDKF3dckJcYpjQLc
         5qaF3Xa5klNTPYzeA5izPB4v03nnScjFuweQzvUjob+famriCYw04jygAZQhjuK80P4P
         zBm0fbR5WyLRhdrMzI7yUygRhSmtUozIZ4ITzYNPDG8YyG18Rh+TFmIRBMxaXLlQKhGt
         ehOmz4EvbHUskgh2cqMfmzV1kIJdeTbb8v+op9p1/eyzYm/qJdiI93qz8C4CTli0hbY0
         e3xQ==
X-Forwarded-Encrypted: i=1; AJvYcCWq9DjT7ghtp2Rm6XSf+lK8affJQi9uFLGQ2ltT2XNib+1Lalx3nPXN9O6YWw8EHU7FV7ir6DcNktLbSDbOI+IMjQBG
X-Gm-Message-State: AOJu0YylAkhBVZlGeBe6DvLCjLKiM2Q5jzeTt3DBnboqIM/aiJ7uh6SB
	tcIqNMuUglARE7Nw7DG7XXsMbew+JxhdbtnpA4k5hiN2RIfrFoEj
X-Google-Smtp-Source: AGHT+IEu8DynXzu9BByQp4QIf16lsnSVc/1E7fhz1eJ1/IbWK85IpX7ljsbYufF7UOAOwWKIv4wY9g==
X-Received: by 2002:a05:6a20:428e:b0:1a1:4d86:7d2 with SMTP id o14-20020a056a20428e00b001a14d8607d2mr554530pzj.11.1709604765212;
        Mon, 04 Mar 2024 18:12:45 -0800 (PST)
Received: from localhost (220-235-220-130.tpgi.com.au. [220.235.220.130])
        by smtp.gmail.com with ESMTPSA id gx15-20020a17090b124f00b00298ca46547fsm8430529pjb.36.2024.03.04.18.12.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Mar 2024 18:12:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 05 Mar 2024 12:12:39 +1000
Message-Id: <CZLGB4BCREUU.SZ1AQ0LTGNKB@wheely>
Cc: "Laurent Vivier" <lvivier@redhat.com>, "Andrew Jones"
 <andrew.jones@linux.dev>, "Paolo Bonzini" <pbonzini@redhat.com>, "Joel
 Stanley" <joel@jms.id.au>, <linuxppc-dev@lists.ozlabs.org>,
 <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH 04/32] powerpc: interrupt stack
 backtracing
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Thomas Huth" <thuth@redhat.com>
X-Mailer: aerc 0.15.2
References: <20240226101218.1472843-1-npiggin@gmail.com>
 <20240226101218.1472843-5-npiggin@gmail.com>
 <9d1166ed-e24f-4257-a441-080f577d3dde@redhat.com>
In-Reply-To: <9d1166ed-e24f-4257-a441-080f577d3dde@redhat.com>

On Fri Mar 1, 2024 at 7:53 PM AEST, Thomas Huth wrote:
> On 26/02/2024 11.11, Nicholas Piggin wrote:
> > Add support for backtracing across interrupt stacks, and
> > add interrupt frame backtrace for unhandled interrupts.
> >=20
> > Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> > ---
> >   lib/powerpc/processor.c |  4 ++-
> >   lib/ppc64/asm/stack.h   |  3 +++
> >   lib/ppc64/stack.c       | 55 ++++++++++++++++++++++++++++++++++++++++=
+
> >   powerpc/Makefile.ppc64  |  1 +
> >   powerpc/cstart64.S      |  7 ++++--
> >   5 files changed, 67 insertions(+), 3 deletions(-)
> >   create mode 100644 lib/ppc64/stack.c
> >=20
> > diff --git a/lib/powerpc/processor.c b/lib/powerpc/processor.c
> > index ad0d95666..114584024 100644
> > --- a/lib/powerpc/processor.c
> > +++ b/lib/powerpc/processor.c
> > @@ -51,7 +51,9 @@ void do_handle_exception(struct pt_regs *regs)
> >   		return;
> >   	}
> >  =20
> > -	printf("unhandled cpu exception %#lx at NIA:0x%016lx MSR:0x%016lx\n",=
 regs->trap, regs->nip, regs->msr);
> > +	printf("Unhandled cpu exception %#lx at NIA:0x%016lx MSR:0x%016lx\n",
> > +			regs->trap, regs->nip, regs->msr);
> > +	dump_frame_stack((void *)regs->nip, (void *)regs->gpr[1]);
> >   	abort();
> >   }
> >  =20
> > diff --git a/lib/ppc64/asm/stack.h b/lib/ppc64/asm/stack.h
> > index 9734bbb8f..94fd1021c 100644
> > --- a/lib/ppc64/asm/stack.h
> > +++ b/lib/ppc64/asm/stack.h
> > @@ -5,4 +5,7 @@
> >   #error Do not directly include <asm/stack.h>. Just use <stack.h>.
> >   #endif
> >  =20
> > +#define HAVE_ARCH_BACKTRACE
> > +#define HAVE_ARCH_BACKTRACE_FRAME
> > +
> >   #endif
> > diff --git a/lib/ppc64/stack.c b/lib/ppc64/stack.c
> > new file mode 100644
> > index 000000000..fcb7fa860
> > --- /dev/null
> > +++ b/lib/ppc64/stack.c
> > @@ -0,0 +1,55 @@
> > +#include <libcflat.h>
> > +#include <asm/ptrace.h>
> > +#include <stack.h>
> > +
> > +extern char exception_stack_marker[];
> > +
> > +int backtrace_frame(const void *frame, const void **return_addrs, int =
max_depth)
> > +{
> > +	static int walking;
> > +	int depth =3D 0;
> > +	const unsigned long *bp =3D (unsigned long *)frame;
> > +	void *return_addr;
> > +
> > +	asm volatile("" ::: "lr"); /* Force it to save LR */
> > +
> > +	if (walking) {
> > +		printf("RECURSIVE STACK WALK!!!\n");
> > +		return 0;
> > +	}
> > +	walking =3D 1;
> > +
> > +	bp =3D (unsigned long *)bp[0];
> > +	return_addr =3D (void *)bp[2];
> > +
> > +	for (depth =3D 0; bp && depth < max_depth; depth++) {
> > +		return_addrs[depth] =3D return_addr;
> > +		if (return_addrs[depth] =3D=3D 0)
> > +			break;
> > +		if (return_addrs[depth] =3D=3D exception_stack_marker) {
> > +			struct pt_regs *regs;
> > +
> > +			regs =3D (void *)bp + STACK_FRAME_OVERHEAD;
> > +			bp =3D (unsigned long *)bp[0];
> > +			/* Represent interrupt frame with vector number */
> > +			return_addr =3D (void *)regs->trap;
> > +			if (depth + 1 < max_depth) {
> > +				depth++;
> > +				return_addrs[depth] =3D return_addr;
> > +				return_addr =3D (void *)regs->nip;
> > +			}
> > +		} else {
> > +			bp =3D (unsigned long *)bp[0];
> > +			return_addr =3D (void *)bp[2];
> > +		}
> > +	}
> > +
> > +	walking =3D 0;
> > +	return depth;
> > +}
> > +
> > +int backtrace(const void **return_addrs, int max_depth)
> > +{
> > +	return backtrace_frame(__builtin_frame_address(0), return_addrs,
> > +			       max_depth);
> > +}
> > diff --git a/powerpc/Makefile.ppc64 b/powerpc/Makefile.ppc64
> > index b0ed2b104..eb682c226 100644
> > --- a/powerpc/Makefile.ppc64
> > +++ b/powerpc/Makefile.ppc64
> > @@ -17,6 +17,7 @@ cstart.o =3D $(TEST_DIR)/cstart64.o
> >   reloc.o  =3D $(TEST_DIR)/reloc64.o
> >  =20
> >   OBJDIRS +=3D lib/ppc64
> > +cflatobjs +=3D lib/ppc64/stack.o
> >  =20
> >   # ppc64 specific tests
> >   tests =3D $(TEST_DIR)/spapr_vpa.elf
> > diff --git a/powerpc/cstart64.S b/powerpc/cstart64.S
> > index 14ab0c6c8..278af84a6 100644
> > --- a/powerpc/cstart64.S
> > +++ b/powerpc/cstart64.S
> > @@ -188,6 +188,7 @@ call_handler:
> >   	.endr
> >   	mfsprg1	r0
> >   	std	r0,GPR1(r1)
> > +	std	r0,0(r1)
> >  =20
> >   	/* lr, xer, ccr */
> >  =20
> > @@ -206,12 +207,12 @@ call_handler:
> >   	subi	r31, r31, 0b - start_text
> >   	ld	r2, (p_toc_text - start_text)(r31)
> >  =20
> > -	/* FIXME: build stack frame */
> > -
> >   	/* call generic handler */
> >  =20
> >   	addi	r3,r1,STACK_FRAME_OVERHEAD
> >   	bl	do_handle_exception
> > +	.global exception_stack_marker
> > +exception_stack_marker:
> >  =20
> >   	/* restore context */
> >  =20
> > @@ -321,6 +322,7 @@ handler_trampoline:
> >   	/* nip and msr */
> >   	mfsrr0	r0
> >   	std	r0, _NIP(r1)
> > +	std	r0, INT_FRAME_SIZE+16(r1)
>
> So if I got that right, INT_FRAME_SIZE+16 points to the stack frame of th=
e=20
> function that was running before the interrupt handler? Is it such a good=
=20
> idea to change that here?

No, we switch to exception stack and don't support recursing interrupts
on stack at the moment, so this goes into the initial frame.

> Please add a comment here explaining this line.=20
> Thanks!

Yes, good idea.

Thanks,
Nick

>
>
> >   	mfsrr1	r0
> >   	std	r0, _MSR(r1)
> > @@ -337,6 +339,7 @@ handler_htrampoline:
> >   	/* nip and msr */
> >   	mfspr	r0, SPR_HSRR0
> >   	std	r0, _NIP(r1)
> > +	std	r0, INT_FRAME_SIZE+16(r1)
>
> dito.
>
> >   	mfspr	r0, SPR_HSRR1
> >   	std	r0, _MSR(r1)
>
>   Thomas


