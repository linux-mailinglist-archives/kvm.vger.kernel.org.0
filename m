Return-Path: <kvm+bounces-41743-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A5726A6C918
	for <lists+kvm@lfdr.de>; Sat, 22 Mar 2025 11:18:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7958E4663DB
	for <lists+kvm@lfdr.de>; Sat, 22 Mar 2025 10:17:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 060371FCFFB;
	Sat, 22 Mar 2025 10:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="P38r2TSV"
X-Original-To: kvm@vger.kernel.org
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A7501F8690
	for <kvm@vger.kernel.org>; Sat, 22 Mar 2025 10:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742638575; cv=none; b=PYU6b71lmU6ZRW1LNcwb9OnhMg431VBlsUh+Yr+iWoHj1P/Qu6GxAo6AKkbg5mgExbkwgURpK/w9SJK1vRFixRGT1aSBfBr3cMJxhm31NVFdXFBNU3wzgD8/dOlo15JYpAbM1mxu2T38d6KU5O64EPoI5Li2pdTbpTeC0YmqWt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742638575; c=relaxed/simple;
	bh=858ICyMfHYQtLUufct6O6UJ1cUKmMog+bUI+2IB+EJQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jJo4NzFt9tA3LCIycvKibCEQvYenw1rB6cFLI6HHXZdwzHf6PEjblnCT3mOLWCDVBjPd5LjoSTT5YMyLudqPt8zJl3hyFXOpl3GsfDGL8SEIMcfDfms8aW7sG0ThEu9TIX1egrWYrOvF5XZrpr1UgZSjrZUw14BAGe4jHCWtc6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=P38r2TSV; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Sat, 22 Mar 2025 11:16:02 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742638568;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eQIQAGa0YGJajSk3ankuiMImJkjvvFDd6nADq6+ZRwY=;
	b=P38r2TSVQ70LzcxVT551RrCLJWG4UYt3trPKrIEF+LkqJoRoxhtM4J166qD5hsCh9DpotQ
	FRWIXRMW1nMif32A/8z2/uPxBxdUU/qsaMqPdhMvBrbMo6aDIv6IJ1EYlwa1ppyfkK/MOv
	L1G3T+dLoE2al7KdzOj4uDqBbunK3U0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Samuel Holland <samuel.holland@sifive.com>
Cc: kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH 3/3] riscv: Support UARTs with different
 I/O widths
Message-ID: <20250322-14825fb84bded49184f4c363@orel>
References: <20241210044442.91736-1-samuel.holland@sifive.com>
 <20241210044442.91736-4-samuel.holland@sifive.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241210044442.91736-4-samuel.holland@sifive.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Dec 09, 2024 at 10:44:42PM -0600, Samuel Holland wrote:
> Integration of ns16550-compatible UARTs is often done with 16 or 32-bit wide
> registers. Add support for these using the standard DT properties.
> 
> Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
> ---
>  lib/riscv/io.c | 41 +++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 39 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/riscv/io.c b/lib/riscv/io.c
> index 8d684ccd..011b5b1d 100644
> --- a/lib/riscv/io.c
> +++ b/lib/riscv/io.c
> @@ -25,8 +25,34 @@
>   */
>  #define UART_EARLY_BASE ((u8 *)(unsigned long)CONFIG_UART_EARLY_BASE)
>  static volatile u8 *uart0_base = UART_EARLY_BASE;
> +static u32 uart0_reg_shift = 1;

I changed this to 0 (8-bit default).

Thanks,
drew

