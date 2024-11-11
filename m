Return-Path: <kvm+bounces-31488-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BC5F79C4178
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 16:06:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 721C11F23E21
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 15:06:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9900719DFB5;
	Mon, 11 Nov 2024 15:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JwtSkHiI"
X-Original-To: kvm@vger.kernel.org
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CECC1E481
	for <kvm@vger.kernel.org>; Mon, 11 Nov 2024 15:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731337593; cv=none; b=aOa0Gg9vgpb4nzD2AMMWSR24C+ZHSl9DsF1MAiFMhEwzGuNPWNwV93wbTJ7wC75+sGl4LRUfk8BEnzdlMLZRN7WPwk5Nh4/5ZPjKXZ7FU8cMwXoPY0+CkMOScGc5d9tSfx+v3IHxzVwUXdwMeyytdZIJA1bXEVGdaXhR0XgO0+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731337593; c=relaxed/simple;
	bh=XPigqyoDdW3fkfC+LxAoAX59AAKtqduo1fEN6jeR38I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DpWyGl6j9LckeGoUb1wOUB0vyZMYQa8u9j5xuUF3IMypFg0r1TCMVl1AT5y6RovGyaaODzB2fxrl+yZ4xV68rRWksBMxRnqIiz5A5MDtgZUTRyg0915gCsc/wmBrzcBnn+VkhR0XG4iTfdICNDxMFyMUKinu1/yFXNQWoutBKUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JwtSkHiI; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 11 Nov 2024 16:06:26 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1731337589;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2E81jDb2jTPreew3G/RdnyMvKKTPnIPaHxcevfNalME=;
	b=JwtSkHiIj87Bx/QLy1Tqo0RF5yi5JY5zaGKKDiRaJCiwgPNTFHtXygpTwnWqcbz8o1u5/V
	fca5sZXjH3uEQtoZ0ru7NdezSoXCo4ZqMofitnxzBz2TjgIZXrdqaG9RfOsZKiSjGgsD3X
	M7wsmPVAArqzqKoDEvROGiiMGNFInuI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Cc: atishp@rivosinc.com, jamestiotio@gmail.com
Subject: Re: [kvm-unit-tests PATCH] riscv: sbi: Prepare for assembly entry
 points
Message-ID: <20241111-fb7b1486cc4c49ceebd93964@orel>
References: <20241106094015.21204-2-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241106094015.21204-2-andrew.jones@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Wed, Nov 06, 2024 at 10:40:16AM +0100, Andrew Jones wrote:
> From: James Raphael Tiovalen <jamestiotio@gmail.com>
> 
> The HSM tests will need to test HSM start and resumption from HSM
> suspend. Prepare for these tests, as well other tests, such as the
> SUSP resume tests, by providing an assembly file for SBI tests.
> 
> Signed-off-by: James Raphael Tiovalen <jamestiotio@gmail.com>
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> ---
>  riscv/Makefile    |  3 ++-
>  riscv/sbi-asm.S   | 12 ++++++++++++
>  riscv/sbi-tests.h |  6 ++++++
>  3 files changed, 20 insertions(+), 1 deletion(-)
>  create mode 100644 riscv/sbi-asm.S
>  create mode 100644 riscv/sbi-tests.h
> 
> diff --git a/riscv/Makefile b/riscv/Makefile
> index 22fd273acac3..734441f94dad 100644
> --- a/riscv/Makefile
> +++ b/riscv/Makefile
> @@ -43,6 +43,7 @@ cflatobjs += lib/riscv/timer.o
>  ifeq ($(ARCH),riscv32)
>  cflatobjs += lib/ldiv32.o
>  endif
> +cflatobjs += riscv/sbi-asm.o
>  
>  ########################################
>  
> @@ -82,7 +83,7 @@ CFLAGS += -mcmodel=medany
>  CFLAGS += -std=gnu99
>  CFLAGS += -ffreestanding
>  CFLAGS += -O2
> -CFLAGS += -I $(SRCDIR)/lib -I $(SRCDIR)/lib/libfdt -I lib
> +CFLAGS += -I $(SRCDIR)/lib -I $(SRCDIR)/lib/libfdt -I lib -I $(SRCDIR)/riscv
>  
>  asm-offsets = lib/riscv/asm-offsets.h
>  include $(SRCDIR)/scripts/asm-offsets.mak
> diff --git a/riscv/sbi-asm.S b/riscv/sbi-asm.S
> new file mode 100644
> index 000000000000..fbf97cab39c8
> --- /dev/null
> +++ b/riscv/sbi-asm.S
> @@ -0,0 +1,12 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Helper assembly code routines for RISC-V SBI extension tests.
> + *
> + * Copyright (C) 2024, James Raphael Tiovalen <jamestiotio@gmail.com>
> + */
> +#define __ASSEMBLY__
> +
> +#include "sbi-tests.h"
> +
> +.section .text
> +
> diff --git a/riscv/sbi-tests.h b/riscv/sbi-tests.h
> new file mode 100644
> index 000000000000..c28046f7cfbd
> --- /dev/null
> +++ b/riscv/sbi-tests.h
> @@ -0,0 +1,6 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +#ifndef _RISCV_SBI_TESTS_H_
> +#define _RISCV_SBI_TESTS_H_
> +
> +
> +#endif /* _RISCV_SBI_TESTS_H_ */
> -- 
> 2.47.0
>

Merged through riscv/sbi.

Thanks,
drew

