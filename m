Return-Path: <kvm+bounces-32410-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D7419D82AA
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 10:40:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0EBAA163D17
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 09:40:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5EB819066D;
	Mon, 25 Nov 2024 09:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CCvYEqj6"
X-Original-To: kvm@vger.kernel.org
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC9B7190662
	for <kvm@vger.kernel.org>; Mon, 25 Nov 2024 09:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732527533; cv=none; b=i1JnQ48ymaaOgDkBXo5GYQy7IU2fR49pMUUolJWAvsBx0v/tC1jwHx7eweYTHAWACqnpWyhPqKcF4WIZahWid1hlYm8EDYHPaozXb9H5lPLtYqD30GAdiAgu/i2C8Eh5ruu5nRAAx8yQk+2kyyMwEIYE0z/RcUqCYk/yL2swbLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732527533; c=relaxed/simple;
	bh=WfRsctaaQalyj7442BSlx17Q4rE3RCMKY7t5toNFFQE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fN+vsxK//D9uCiU57Yz+TjdLTByW6YN6DcgdG22ZULc3hJJ4XDlpbgF6u77JZZk2LngF5n1o/yGuc6i0GMc4fNmd5OTkN8YQhijH5X4bqXe309mMos8PqNs4mosMUQ0ZM2uieeZ0oDVi9Htg6mlo8bOl0QZVT1FdOis+CVeMsgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CCvYEqj6; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 25 Nov 2024 10:38:44 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1732527527;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GY4uIFRpPt94aAuY8Pt80T57OfFW3WMI5D+NOYj9t5U=;
	b=CCvYEqj6k0VQvdeuMieerbEb79PLy+dua/gkW2JVI6lCgrh9PCa2eESQCyt1nybcEvnVk2
	WQlsyMrY3zS5+AwxoY38oqVNdgVRFBwJKN1Ccs9QYQZv3OFvivmyvIJJ4mmtZOSRyoIcjR
	2a+U0mVM/RUq+FPUrXui1scU+CdP1RY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	Andrew Jones <ajones@ventanamicro.com>, Anup Patel <apatel@ventanamicro.com>, 
	Atish Patra <atishp@rivosinc.com>
Subject: Re: [kvm-unit-tests PATCH v2 2/3] riscv: lib: Add SSE assembly entry
 handling
Message-ID: <20241125-a56b5a8b8a80cdd2e9598fee@orel>
References: <20241122140459.566306-1-cleger@rivosinc.com>
 <20241122140459.566306-3-cleger@rivosinc.com>
 <20241122-a7e54373559727e1e296b8c4@orel>
 <90b8e2d2-1fc6-4166-a3bf-3cd8af3b5b8d@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <90b8e2d2-1fc6-4166-a3bf-3cd8af3b5b8d@rivosinc.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Nov 25, 2024 at 09:46:48AM +0100, Clément Léger wrote:
> 
> 
> On 22/11/2024 17:20, Andrew Jones wrote:
> > On Fri, Nov 22, 2024 at 03:04:56PM +0100, Clément Léger wrote:
> >> Add a SSE entry assembly code to handle SSE events. Events should be
> >> registered with a struct sse_handler_arg containing a correct stack and
> >> handler function.
> >>
> >> Signed-off-by: Clément Léger <cleger@rivosinc.com>
> >> ---
> >>  riscv/Makefile          |   1 +
> >>  lib/riscv/asm/sse.h     |  16 +++++++
> >>  lib/riscv/sse-entry.S   | 100 ++++++++++++++++++++++++++++++++++++++++
> > 
> > Let's just add the entry function to riscv/sbi-asm.S and the
> > sse_handler_arg struct definition to riscv/sbi-tests.h
> 
> Hi drew,
> 
> I need to have some offset generated using asm-offsets.c which is in
> lib/riscv. If I move the sse_handler_arg in riscv/sbi-tests.h, that will
> be really off to include that file in the lib/riscv/asm-offsets.c.

That's true, but it's also not great to put a test-specific definition of
an arg structure in lib code. It seems like we'll eventually want a neater
solution to this, though, since using asm-offsets for test-specific
structures makes sense. However, we could put it off for now, since each
member of the structure that SSE tests need is the same size,
sizeof(long), so we can do the same thing that HSM and SUSP do, which is
to define some indices and access with ASMARR().

> Except if you have some other solution.

ASMARR(), even though I'm not a huge fan of that approach either...

> 
> > 
> >>  lib/riscv/asm-offsets.c |   9 ++++
> >>  4 files changed, 126 insertions(+)
> >>  create mode 100644 lib/riscv/asm/sse.h
> >>  create mode 100644 lib/riscv/sse-entry.S
> >>
> >> diff --git a/riscv/Makefile b/riscv/Makefile
> >> index 28b04156..e50621ad 100644
> >> --- a/riscv/Makefile
> >> +++ b/riscv/Makefile
> >> @@ -39,6 +39,7 @@ cflatobjs += lib/riscv/sbi.o
> >>  cflatobjs += lib/riscv/setjmp.o
> >>  cflatobjs += lib/riscv/setup.o
> >>  cflatobjs += lib/riscv/smp.o
> >> +cflatobjs += lib/riscv/sse-entry.o
> >>  cflatobjs += lib/riscv/stack.o
> >>  cflatobjs += lib/riscv/timer.o
> >>  ifeq ($(ARCH),riscv32)
> >> diff --git a/lib/riscv/asm/sse.h b/lib/riscv/asm/sse.h
> >> new file mode 100644
> >> index 00000000..557f6680
> >> --- /dev/null
> >> +++ b/lib/riscv/asm/sse.h
> >> @@ -0,0 +1,16 @@
> >> +/* SPDX-License-Identifier: GPL-2.0-only */
> >> +#ifndef _ASMRISCV_SSE_H_
> >> +#define _ASMRISCV_SSE_H_
> >> +
> >> +typedef void (*sse_handler_fn)(void *data, struct pt_regs *regs, unsigned int hartid);
> >> +
> >> +struct sse_handler_arg {
> >> +	unsigned long reg_tmp;
> >> +	sse_handler_fn handler;
> >> +	void *handler_data;
> >> +	void *stack;
> >> +};
> >> +
> >> +extern void sse_entry(void);
> >> +
> >> +#endif /* _ASMRISCV_SSE_H_ */
> >> diff --git a/lib/riscv/sse-entry.S b/lib/riscv/sse-entry.S
> >> new file mode 100644
> >> index 00000000..bedc47e9
> >> --- /dev/null
> >> +++ b/lib/riscv/sse-entry.S
> >> @@ -0,0 +1,100 @@
> >> +/* SPDX-License-Identifier: GPL-2.0-only */
> >> +/*
> >> + * SBI SSE entry code
> >> + *
> >> + * Copyright (C) 2024, Rivos Inc., Clément Léger <cleger@rivosinc.com>
> >> + */
> >> +#include <asm/asm.h>
> >> +#include <asm/asm-offsets.h>
> >> +#include <asm/csr.h>
> >> +
> >> +.global sse_entry
> >> +sse_entry:
> >> +	/* Save stack temporarily */
> >> +	REG_S sp, SSE_REG_TMP(a6)

While thinking about the asm-offsets issue, I took a closer look at this
and noticed that this should be a7, since ENTRY_ARG is specified to be
set to A7. It looks like we have A6 (hartid) and A7 (arg) swapped. The
opensbi implementation also has them swapped, allowing this test to pass.
Both need to be fixed.

Thanks,
drew

