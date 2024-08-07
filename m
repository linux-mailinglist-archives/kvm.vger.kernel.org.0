Return-Path: <kvm+bounces-23550-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BB2694ACBD
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 17:23:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8CE341C20ECA
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 15:23:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D23384D25;
	Wed,  7 Aug 2024 15:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YLrwB68h"
X-Original-To: kvm@vger.kernel.org
Received: from out-184.mta1.migadu.com (out-184.mta1.migadu.com [95.215.58.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6A6484A3F
	for <kvm@vger.kernel.org>; Wed,  7 Aug 2024 15:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723044072; cv=none; b=Xa7RD3e/95y8MUJtYYg0eZ+C3YQb2Dh2ArqCqU1xHP7XIVIstF7KmeTn05YWh7kmzMyyegSOenTHOdvYRbdFQCWcEWfVHu/huoFoQW+bnvZnJMWtXT8A1g43gzUWSV/3zFQ3dGvN8qVij6aC3dfrtHW3W+myoyCpxbNK8uj9+ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723044072; c=relaxed/simple;
	bh=G719NbjBafy32G+f+7asj6B4wGI1xXETS7hD/nuMBfA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jnvNdeeWMr69auNaLmTpHwbppHl8Dx5KW6U/KE5f0GTnwJjFtw7ngBqNKzi1hzp7BzkZczukTcBYPhx88iY8jEXwx5BTtZh8LM8QIK/GO+K+kauq0d7PI0m9B2jy/cz3/WfdCOqc1ZR4rEd63MWp+PNZpYwE8/OdswHPG1gS4YM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YLrwB68h; arc=none smtp.client-ip=95.215.58.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 7 Aug 2024 17:21:03 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1723044068;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3Nbx3grGOM7fFMna9F8lSr/AyS5e5jQ4cR0sLfmoEi4=;
	b=YLrwB68h1EsMpkVGsxTwWiM8fHnpRerzrfb0f0Gw28wmfHCm3WVUWnyH6/TMPbGRaFmgLG
	yqycj32eSdXPyYflaSGfdTMm79/aouy4o3ZvYwyejLr1pkQOpRODgpjPV9SEGAsejSo8Gh
	/F3pz3WHzl/5NeHtU9xus6CLHYKAc9o=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	Andrew Jones <ajones@ventanamicro.com>, Anup Patel <apatel@ventanamicro.com>, 
	Atish Patra <atishp@rivosinc.com>
Subject: Re: [kvm-unit-tests PATCH v1 1/4] riscv: move REG_L/REG_W in a
 dedicated asm.h file
Message-ID: <20240807-d8d51c8e443841247efaf75d@orel>
References: <20240517134007.928539-1-cleger@rivosinc.com>
 <20240517134007.928539-2-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240517134007.928539-2-cleger@rivosinc.com>
X-Migadu-Flow: FLOW_OUT

On Fri, May 17, 2024 at 03:40:02PM GMT, Clément Léger wrote:
> These assembly macros will be used as part of the SSE entry assembly
> code, export them in asm.h header.
> 
> Signed-off-by: Clément Léger <cleger@rivosinc.com>
> ---
>  lib/riscv/asm/asm.h | 19 +++++++++++++++++++
>  riscv/cstart.S      | 14 +-------------
>  2 files changed, 20 insertions(+), 13 deletions(-)
>  create mode 100644 lib/riscv/asm/asm.h
> 
> diff --git a/lib/riscv/asm/asm.h b/lib/riscv/asm/asm.h
> new file mode 100644
> index 00000000..763b28e6
> --- /dev/null
> +++ b/lib/riscv/asm/asm.h
> @@ -0,0 +1,19 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +#ifndef _ASMRISCV_ASM_H_
> +#define _ASMRISCV_ASM_H_
> +
> +#if __riscv_xlen == 64
> +#define __REG_SEL(a, b) a
> +#elif __riscv_xlen == 32
> +#define __REG_SEL(a, b) b
> +#else
> +#error "Unexpected __riscv_xlen"
> +#endif
> +
> +#define REG_L	__REG_SEL(ld, lw)
> +#define REG_S	__REG_SEL(sd, sw)
> +#define SZREG	__REG_SEL(8, 4)
> +
> +#define FP_SIZE 16
> +
> +#endif /* _ASMRISCV_ASM_H_ */
> diff --git a/riscv/cstart.S b/riscv/cstart.S
> index 10b5da57..d5d8ad25 100644
> --- a/riscv/cstart.S
> +++ b/riscv/cstart.S
> @@ -4,22 +4,10 @@
>   *
>   * Copyright (C) 2023, Ventana Micro Systems Inc., Andrew Jones <ajones@ventanamicro.com>
>   */
> +#include <asm/asm.h>
>  #include <asm/asm-offsets.h>
>  #include <asm/csr.h>
>  
> -#if __riscv_xlen == 64
> -#define __REG_SEL(a, b) a
> -#elif __riscv_xlen == 32
> -#define __REG_SEL(a, b) b
> -#else
> -#error "Unexpected __riscv_xlen"
> -#endif
> -
> -#define REG_L	__REG_SEL(ld, lw)
> -#define REG_S	__REG_SEL(sd, sw)
> -#define SZREG	__REG_SEL(8, 4)
> -
> -#define FP_SIZE 16
>  
>  .macro push_fp, ra=ra
>  	addi	sp, sp, -FP_SIZE
> -- 
> 2.43.0
>

Queued, https://gitlab.com/jones-drew/kvm-unit-tests/-/commits/riscv/queue

Thanks,
drew

