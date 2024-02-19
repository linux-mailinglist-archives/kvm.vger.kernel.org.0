Return-Path: <kvm+bounces-9093-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3561A85A5C6
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 15:22:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E68FC2812C8
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 14:22:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAB1A374EA;
	Mon, 19 Feb 2024 14:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VUaSSK87"
X-Original-To: kvm@vger.kernel.org
Received: from out-176.mta0.migadu.com (out-176.mta0.migadu.com [91.218.175.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68FC93714E
	for <kvm@vger.kernel.org>; Mon, 19 Feb 2024 14:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708352537; cv=none; b=ghWUHaybkYTnmsg3zlI8KlnnEOsZS3p4YqO5A7p3RhG+KeoOvAOAHMj4V0rT+Ei4EJFRi30uKqlKy8cqwOUz7HiczyrjmSm2thWDjdvjKMwoqYluXr0M3V7K5U8q+dSHMhemvD9KWXWsrkk40G57ePxJiSuRKpDZxUAXnXNdBm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708352537; c=relaxed/simple;
	bh=chnIN4vL9jLnK4VypYkgOETR21m7QxjboNyAcNCEsbc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GZK2ZLCBF9FHMH5R6V1KMV2T6XzvP2wIfgp8MG8323knDY2W3zngZQQblviLDRKX5Yq2QGG2vsmsOAPXSLRjIYJlm9YBBSVOIIl2uPccj4Oh0dqJxdAguTqyCJACqMjKzI7Bc6EtuxnZ3SQjZjQX5e3JSQI+ge7jziWC5HXrLrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VUaSSK87; arc=none smtp.client-ip=91.218.175.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 19 Feb 2024 15:22:07 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708352531;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dEwETXJPSfp+ZHtoUMgCFOjnER5vHjcEDtT5CNqJGtk=;
	b=VUaSSK87B9kpmQzeWGW2AM2Q9bOuUWaKtCiEwgrNDmt/xTZmzR8vVxSRGVTVGLJn8+sD9h
	rVZ8o1PCTh35YRlz9lPgYO741JqS0V4finQWlm7uQ16NP3ymMKHH7T5XmXHHVw8qwy+fwU
	RcSL6ig2k8EFgagHS81uZxk4b7I28xY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Thomas Huth <thuth@redhat.com>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, 
	Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>, 
	kvmarm@lists.linux.dev
Subject: Re: [kvm-unit-tests PATCH] lib/arm/io: Fix calling getchar()
 multiple times
Message-ID: <20240219-a8fd2613c2a3dc474c966ffb@orel>
References: <20240216140210.70280-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240216140210.70280-1-thuth@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Feb 16, 2024 at 03:02:10PM +0100, Thomas Huth wrote:
> getchar() can currently only be called once on arm since the implementation
> is a little bit too  naïve: After the first character has arrived, the
> data register never gets set to zero again. To properly check whether a
> byte is available, we need to check the "RX fifo empty" on the pl011 UART
> or the "RX data ready" bit on the ns16550a UART instead.
> 
> With this proper check in place, we can finally also get rid of the
> ugly assert(count < 16) statement here.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  lib/arm/io.c | 34 ++++++++++++++--------------------
>  1 file changed, 14 insertions(+), 20 deletions(-)
> 
> diff --git a/lib/arm/io.c b/lib/arm/io.c
> index c15e57c4..836fa854 100644
> --- a/lib/arm/io.c
> +++ b/lib/arm/io.c
> @@ -28,6 +28,7 @@ static struct spinlock uart_lock;
>   */
>  #define UART_EARLY_BASE (u8 *)(unsigned long)CONFIG_UART_EARLY_BASE
>  static volatile u8 *uart0_base = UART_EARLY_BASE;
> +bool is_pl011_uart;
>  
>  static void uart0_init_fdt(void)
>  {
> @@ -59,7 +60,10 @@ static void uart0_init_fdt(void)
>  			abort();
>  		}
>  
> +		is_pl011_uart = (i == 0);
>  	} else {
> +		is_pl011_uart = !fdt_node_check_compatible(dt_fdt(), ret,
> +		                                           "arm,pl011");
>  		ret = dt_pbus_translate_node(ret, 0, &base);
>  		assert(ret == 0);
>  	}
> @@ -111,31 +115,21 @@ void puts(const char *s)
>  	spin_unlock(&uart_lock);
>  }
>  
> -static int do_getchar(void)
> +int __getchar(void)
>  {
> -	int c;
> +	int c = -1;
>  
>  	spin_lock(&uart_lock);
> -	c = readb(uart0_base);
> -	spin_unlock(&uart_lock);
> -
> -	return c ?: -1;
> -}
> -
> -/*
> - * Minimalist implementation for migration completion detection.
> - * Without FIFOs enabled on the QEMU UART device we just read
> - * the data register: we cannot read more than 16 characters.
> - */
> -int __getchar(void)
> -{
> -	int c = do_getchar();
> -	static int count;
>  
> -	if (c != -1)
> -		++count;
> +	if (is_pl011_uart) {
> +		if (!(readb(uart0_base + 6 * 4) & 0x10))  /* RX not empty? */
> +			c = readb(uart0_base);
> +	} else {
> +		if (readb(uart0_base + 5) & 0x01)         /* RX data ready? */
> +			c = readb(uart0_base);
> +	}

I think I'd eventually prefer encapsulating these separate implementations
into a console device, but that might be a bit heavy handed for a fix that
we want to pull into the multi-migration series.

Thanks,
drew

