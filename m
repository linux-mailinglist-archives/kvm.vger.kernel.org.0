Return-Path: <kvm+bounces-9102-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 656DA85A96E
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 17:56:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1824E2865EE
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 16:56:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60562446A6;
	Mon, 19 Feb 2024 16:56:13 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41FBD44389
	for <kvm@vger.kernel.org>; Mon, 19 Feb 2024 16:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708361772; cv=none; b=kLSTP0wJh6JB1COAW/t0I4vEdl52EMLBZgn4mlMqbrzOEFQym1JkkJExGf4oA2QJy8hkb62uOAO1qWBJcUsib9f5fIi23xuLOUlwGP8oMopJ4eIEBc1CSuiFvA82+MrZ0Bi3kk6/TkG/9krJq1tyDLJuXYd1wthtZl8Z6d4/yUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708361772; c=relaxed/simple;
	bh=AkPcE8McHBhy/l2wJWb/CDxJG7R5AjV1tCPwRaX1pcM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i3Pjrm2STEi/BSfQrash/zhGbuLHzEN6orDczZ6GwfFPk/8CeyEBl484ohneW3Z+sieRPPA0vnysUpKR07CNKsqJoS3NwS43yK/+LzozUixdIA/+KT+hVhGFtlFiZbTTB2tdUiZrkFsbacgoN0hRtoS6mALYmHpTeZS+herMMro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6B307DA7;
	Mon, 19 Feb 2024 08:56:49 -0800 (PST)
Received: from raptor (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8C1CF3F762;
	Mon, 19 Feb 2024 08:56:08 -0800 (PST)
Date: Mon, 19 Feb 2024 16:56:05 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Andrew Jones <andrew.jones@linux.dev>,
	Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org,
	Nicholas Piggin <npiggin@gmail.com>, kvmarm@lists.linux.dev
Subject: Re: [kvm-unit-tests PATCH] lib/arm/io: Fix calling getchar()
 multiple times
Message-ID: <ZdOIJfvVm7C23ZdZ@raptor>
References: <20240216140210.70280-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240216140210.70280-1-thuth@redhat.com>

Hi,

Thanks for writing this. I've tested it with kvmtool, which emulates a 8250
UART:

Tested-by: Alexandru Elisei <alexandru.elisei@arm.com>

This fixes a longstanding bug with kvmtool, where migrate_once() would read
the last character that was sent, and then think that migration was
completed even though it was never performed.

While we are on the subject of migration:

SKIP: gicv3: its-migration: Test requires at least 4 vcpus
Now migrate the VM, then press a key to continue...
INFO: gicv3: its-migration: Migration complete
SUMMARY: 1 tests, 1 skipped

That's extremely confusing. Why is migrate_once() executed after the
test_its_pending() function call without checking if the test was skipped?

Nitpicks below.

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

I think it would be useful if the magic numbers were replaced by something
less opaque, something like:

		if (!(readb(uart0_base + PL011_UARTFR) & PL011_UARTFR_RXFE))

> +			c = readb(uart0_base);
> +	} else {
> +		if (readb(uart0_base + 5) & 0x01)         /* RX data ready? */

Same as above, perhaps:

		if (readb(uart0_base + UART16550_LSR) & UART16550_LSR_DR)

Naming of course being subject to taste.

Thanks,
Alex

> +			c = readb(uart0_base);
> +	}
>  
> -	assert(count < 16);
> +	spin_unlock(&uart_lock);
>  
>  	return c;
>  }
> -- 
> 2.43.0
> 

