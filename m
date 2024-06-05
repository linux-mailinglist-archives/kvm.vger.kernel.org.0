Return-Path: <kvm+bounces-18838-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B38848FC115
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 03:07:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1ED831F23FCB
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 01:07:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF5C74A29;
	Wed,  5 Jun 2024 01:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UbVOec4+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A83C210E5
	for <kvm@vger.kernel.org>; Wed,  5 Jun 2024 01:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717549626; cv=none; b=jWxwpiwaAsljj0cn4fWO90YH0PT6AaRP3CMli4qgl/UcpjCh0bUkoVc7RQli8udbFWjzs03VXEBAGT6g+QracaeO5lvUnGjrIo02Ybv+ki3qzY7Lve7r1aqv+W478V1mQUd0oeP+t/Ijwy79dymll/JvlC9iDODm+kz36neUUhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717549626; c=relaxed/simple;
	bh=2Z2C5SsrZwdqnt9rwnOcPuX3gpHDka3UWgGpDwcxWV8=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=al7GlYY0cu5IR7BXjJPA4CIC1Kl18s5/ejcWwnxmc6YA86GOuEs2TULFufL81cT19M/E4VVJpGhhg5JOgom6eSMr3szRZOYYFTJbgjHR6xzG/8gYOQXFI1GLVywaKwApK537XpPZitrmxN/ayZyB9m1saAi/uaEWfBEz2UGX+cU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UbVOec4+; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-70260814b2dso352416b3a.1
        for <kvm@vger.kernel.org>; Tue, 04 Jun 2024 18:07:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717549624; x=1718154424; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B8MODctVo107maa3kheuMwZfqqB2xVY67/KYlMCAoSw=;
        b=UbVOec4+svaH53KKfqVqZwWNbC9ziKAbI7wWi1PbZIZgcYf3g5VzMm0/Ovqw7L5FHK
         aB/ic32PR/qAFG+or6RM958fs8oHkcngvQTgk+YuM0LMxC8FF4VMYaxLOZcdHCeUYDoC
         D83jGdV4KzqBrDETvzwh0Mdk1D/RqhaCOwuT46TbiNafKwru7ZLcM/mkdGpywaqaJvca
         Exb2dl974jDit1JIq5B3T6sb7dNmHteOp3UVD+4fvbIoWL5SUVn3eIL23dSiekZrFZsx
         NEW6CPp59qIhI7L4HL6fqVuIjWvIkUpJJZpdLe2HqP7mucGP0jOcz4+CQcMcY3+54vzW
         RUyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717549624; x=1718154424;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=B8MODctVo107maa3kheuMwZfqqB2xVY67/KYlMCAoSw=;
        b=njG3kCSJ1gGehttMtgKOb1KT0VoDDm2Ll6R0SS5a7UVv9lZ4DxGSQeqdsm2cnUZ2K0
         s29xCItjXiSV1N+sva+GpeNoYnjXxNRFSYZZ6KRvdGf0Iqb/hCexcZDuW6HThLTQAgYm
         QcPrl1SIrcYYAihjY3npFnpajnQHgK9HlKBMSKRGkdPgEvSe++4IZ+vffmvnWl6Z14q9
         vAlUklYMcqOemQVqgZqFjh3zAFkb1w7CDuJevrOpQSXCNxVHcqPQ4T4fvy8BaoVXPCUo
         G0HxXTAwH7X3CFZciFPJfT7KG1U0mQfqA/Js3Q3oBn3tpSnitldcvmhkjENAYVfxzqj9
         lQpQ==
X-Forwarded-Encrypted: i=1; AJvYcCVlv07m+EgDlW/N6soFtHebb+w66eGkXk/dP0UgrbBM3ljZ7rawH4ftuMT27Cu0f9mFstPzCRtLYmFrLGcPNqfiANDj
X-Gm-Message-State: AOJu0YxBR5E03ttlorTqnn7MQIuxYoJO4E6OJFdZXtClycxMtq+2Xn7x
	FpsOjWcBwdj6INQk8cfa2DMyrRCNyvWejhesCisesB8mbDFLKj7l
X-Google-Smtp-Source: AGHT+IGcG8O833Adzt4vsnj+C3YmsA8Iu1/Gu6CWDfChhSH0dDkTcL5xCJL4A1hk35HmWo4c67BAfg==
X-Received: by 2002:a05:6a00:3cd6:b0:6f3:eb71:af90 with SMTP id d2e1a72fcca58-703e4b9bdbdmr1726526b3a.4.1717549623706;
        Tue, 04 Jun 2024 18:07:03 -0700 (PDT)
Received: from localhost (110-175-65-7.tpgi.com.au. [110.175.65.7])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7024967ae05sm7161080b3a.157.2024.06.04.18.07.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jun 2024 18:07:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 05 Jun 2024 11:06:57 +1000
Message-Id: <D1ROIXQIHXJV.38DLKI4T392V5@gmail.com>
Cc: "Laurent Vivier" <lvivier@redhat.com>, "Andrew Jones"
 <andrew.jones@linux.dev>, <linuxppc-dev@lists.ozlabs.org>,
 <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH v9 22/31] powerpc: Add MMU support
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Thomas Huth" <thuth@redhat.com>
X-Mailer: aerc 0.17.0
References: <20240504122841.1177683-1-npiggin@gmail.com>
 <20240504122841.1177683-23-npiggin@gmail.com>
 <75adb602-7ccc-4dcd-916e-5f79fcd1cdd3@redhat.com>
In-Reply-To: <75adb602-7ccc-4dcd-916e-5f79fcd1cdd3@redhat.com>

On Tue Jun 4, 2024 at 5:30 PM AEST, Thomas Huth wrote:
> On 04/05/2024 14.28, Nicholas Piggin wrote:
> > Add support for radix MMU, 4kB and 64kB pages.
> >=20
> > This also adds MMU interrupt test cases, and runs the interrupts
> > test entirely with MMU enabled if it is available (aside from
> > machine check tests).
> >=20
> > Acked-by: Andrew Jones <andrew.jones@linux.dev> (configure changes)
> > Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> > ---
> ...
> > diff --git a/lib/ppc64/mmu.c b/lib/ppc64/mmu.c
> > new file mode 100644
> > index 000000000..5307cd862
> > --- /dev/null
> > +++ b/lib/ppc64/mmu.c
> > @@ -0,0 +1,281 @@
> > +/* SPDX-License-Identifier: GPL-2.0-only */
> > +/*
> > + * Radix MMU support
> > + *
> > + * Copyright (C) 2024, IBM Inc, Nicholas Piggin <npiggin@gmail.com>
> > + *
> > + * Derived from Linux kernel MMU code.
> > + */
> > +#include <asm/mmu.h>
> > +#include <asm/setup.h>
> > +#include <asm/smp.h>
> > +#include <asm/page.h>
> > +#include <asm/io.h>
> > +#include <asm/processor.h>
> > +#include <asm/hcall.h>
> > +
> > +#include "alloc_page.h"
> > +#include "vmalloc.h"
> > +#include <asm/pgtable-hwdef.h>
> > +#include <asm/pgtable.h>
> > +
> > +#include <linux/compiler.h>
> > +
> > +static pgd_t *identity_pgd;
> > +
> > +bool vm_available(void)
> > +{
> > +	return cpu_has_radix;
> > +}
> > +
> > +bool mmu_enabled(void)
> > +{
> > +	return current_cpu()->pgtable !=3D NULL;
> > +}
> > +
> > +void mmu_enable(pgd_t *pgtable)
> > +{
> > +	struct cpu *cpu =3D current_cpu();
> > +
> > +	if (!pgtable)
> > +		pgtable =3D identity_pgd;
> > +
> > +	cpu->pgtable =3D pgtable;
> > +
> > +	mtmsr(mfmsr() | (MSR_IR|MSR_DR));
> > +}
> > +
> > +void mmu_disable(void)
> > +{
> > +	struct cpu *cpu =3D current_cpu();
> > +
> > +	cpu->pgtable =3D NULL;
> > +
> > +	mtmsr(mfmsr() & ~(MSR_IR|MSR_DR));
> > +}
> > +
> > +static inline void tlbie(unsigned long rb, unsigned long rs, int ric, =
int prs, int r)
> > +{
> > +	asm volatile(".machine push ; .machine power9; ptesync ; tlbie %0,%1,=
%2,%3,%4 ; eieio ; tlbsync ; ptesync ; .machine pop" :: "r"(rb), "r"(rs), "=
i"(ric), "i"(prs), "i"(r) : "memory");
>
> That's a very long line, please split it up after every assembly instruct=
ion=20
> (using \n for new lines).
>
> > +}
> ...
> > diff --git a/powerpc/mmu.c b/powerpc/mmu.c
> > new file mode 100644
> > index 000000000..fef790506
> > --- /dev/null
> > +++ b/powerpc/mmu.c
> > @@ -0,0 +1,283 @@
> > +/* SPDX-License-Identifier: LGPL-2.0-only */
> > +/*
> > + * MMU Tests
> > + *
> > + * Copyright 2024 Nicholas Piggin, IBM Corp.
> > + */
> > +#include <libcflat.h>
> > +#include <asm/atomic.h>
> > +#include <asm/barrier.h>
> > +#include <asm/processor.h>
> > +#include <asm/mmu.h>
> > +#include <asm/smp.h>
> > +#include <asm/setup.h>
> > +#include <asm/ppc_asm.h>
> > +#include <vmalloc.h>
> > +#include <devicetree.h>
> > +
> > +static inline void tlbie(unsigned long rb, unsigned long rs, int ric, =
int prs, int r)
> > +{
> > +	asm volatile(".machine push ; .machine power9; ptesync ; tlbie %0,%1,=
%2,%3,%4 ; eieio ; tlbsync ; ptesync ; .machine pop" :: "r"(rb), "r"(rs), "=
i"(ric), "i"(prs), "i"(r) : "memory");
> > +}
>
> Same function again? Maybe it could go into mmu.h instead?
>
> > +static inline void tlbiel(unsigned long rb, unsigned long rs, int ric,=
 int prs, int r)
> > +{
> > +	asm volatile(".machine push ; .machine power9; ptesync ; tlbiel %0,%1=
,%2,%3,%4 ; ptesync ; .machine pop" :: "r"(rb), "r"(rs), "i"(ric), "i"(prs)=
, "i"(r) : "memory");
> > +}
>
> Please also split up the above long line.

I'll try to improve the lines.

> It would also be cool if you could get one of the other ppc guys at IBM t=
o=20
> review this patch, since I don't have a clue about this MMU stuff at all.

It would be.

Thanks,
Nick

