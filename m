Return-Path: <kvm+bounces-9251-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 600D185CED4
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 04:39:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E2B98285764
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 03:39:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 538A538DD2;
	Wed, 21 Feb 2024 03:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kShJV2WY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E48E23C9
	for <kvm@vger.kernel.org>; Wed, 21 Feb 2024 03:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708486753; cv=none; b=sl8g3Sy4aiu70ciFldDbzCz4Ze4/foLuy0llG5IcQ/EjnqbFrRP4RHjH+c4ihKdZRYxQWVTfs4GJ3dRSW6AD8YcjpDekvwZwPUzLBE0+YzTgJyseAw18l85udlnKpVh+INS+RhJbozVAuBH9JvicoMEb69EwobZKMnvmyPxwZWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708486753; c=relaxed/simple;
	bh=H4cTMnfp99W1KBlfzNlCqw0liwFSscXiSjeuPnAt9RU=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:To:Cc:Subject:
	 References:In-Reply-To; b=R4xQesHCIjnK4gXAkh6vLUvHl+GSnaU4Bigvg7MfU+rhyLHYV8WGGCFM/Qngjo9taeQh7FD2JKF7O4ZHQ8jk7kihBJSUdNfugl3PJ2TRi/o55UOaEC0LNCmKF7CdsCOoB5FkXeelUXlcureZ3Kzl5Fqxk+rRxJRTborULBiJKeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kShJV2WY; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-6e46dcd8feaso1544740b3a.2
        for <kvm@vger.kernel.org>; Tue, 20 Feb 2024 19:39:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708486751; x=1709091551; darn=vger.kernel.org;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y6fl3OofbJfiG8irvpRvJAkMN/E77e4wsBS32CiwqYA=;
        b=kShJV2WY4Wv2vB4FUTLqKrPIb8UeRZXBTIbupTvPBYvqUvR2VkKhDdnI8NvjUhTAU2
         PA/v40NUZOLEnIDO9ea7poYq2jhvjgiq8iqrl/37puCXnsLLRxVycMhmjHAi0vMSTwjs
         AymhKpUUSHeo6Aq4npkXQc+ddX/oa+zAaKGhsDtgcJE5wRbs8f6JUJveH5gUj1kbPxM+
         FKKLkenY+3o5KpUPSREBO5Qvih7I6ZduUxi3qNQhHfzXo8eBSTD6/s5zTd9n4oUnM7BF
         flKUKZ/jgjTVkpe2gdiUM6oYkgiB0xs0U0PuUum9pVrucDG2elE/B1OZ9huw0Vv5GhDy
         1n7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708486751; x=1709091551;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Y6fl3OofbJfiG8irvpRvJAkMN/E77e4wsBS32CiwqYA=;
        b=G7sWNJlGhpr69p/17ouqjYSpd1cto9yG1L2ehSw//PBvzk105bgESH60ciq9PNKnb/
         LEATSLSrj951yd4UMP1FH/InqFJVFCzoN//smSSoPWA5VkXVoWJh3zrnIvrYC5bQ3uEB
         D7/nSom5hwXTgdq1eI4NcnQPnPDSBenCQU4vmM2KU8CljxV9Ecs6uo/46assAlzFjvXG
         4pulAXh0sf0qWPpTVFH06vn8bpM0Xavn1+Le6d6X2JTYIqRaJPB90zDsE+fKirT8STbR
         DIz/fiE4Ui6HsTelMY1/CkDcRvHq0eHs8iYjARZy5tcGTDPYGefjX58jROK7c5ICOTWv
         W4Hg==
X-Forwarded-Encrypted: i=1; AJvYcCVN+Bz/cRXqa1mZ5eU8PYU1HDcupBNtvsMWgyw6sErJyr6tiWAmQDwNJmqOy67tCdxKnh/+joD3JfFbSwpKFqI9jVDh
X-Gm-Message-State: AOJu0YzAM1YUkDBEPCSXectZRp/c6aMmQNmtpk4sNKJ7z4O6CLmZQyJz
	uI9q2YMStipHtWLIB6o/d7H4qh02VCjhf8gCObGQ0MkiA8CUosME
X-Google-Smtp-Source: AGHT+IEgPYGjd00SGryCdnreRrXW62LjioerYcxGvnCvCc3B/u1pf7NqEr8VgV7nsB94Fkj4zvDt8g==
X-Received: by 2002:a17:903:2b0d:b0:1dc:7ca:36de with SMTP id mc13-20020a1709032b0d00b001dc07ca36demr6812499plb.9.1708486751438;
        Tue, 20 Feb 2024 19:39:11 -0800 (PST)
Received: from localhost (220-235-194-103.tpgi.com.au. [220.235.194.103])
        by smtp.gmail.com with ESMTPSA id iw20-20020a170903045400b001dbb86b88e5sm7011393plb.124.2024.02.20.19.39.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Feb 2024 19:39:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 21 Feb 2024 13:39:06 +1000
Message-Id: <CZAG089APSLA.2814EZST7N1DF@wheely>
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Thomas Huth" <thuth@redhat.com>, "Andrew Jones"
 <andrew.jones@linux.dev>, "Alexandru Elisei" <alexandru.elisei@arm.com>,
 "Eric Auger" <eric.auger@redhat.com>, <kvm@vger.kernel.org>
Cc: <kvmarm@lists.linux.dev>
Subject: Re: [kvm-unit-tests PATCH] lib/arm/io: Fix calling getchar()
 multiple times
X-Mailer: aerc 0.15.2
References: <20240216140210.70280-1-thuth@redhat.com>
In-Reply-To: <20240216140210.70280-1-thuth@redhat.com>

On Sat Feb 17, 2024 at 12:02 AM AEST, Thomas Huth wrote:
> getchar() can currently only be called once on arm since the implementati=
on
> is a little bit too  na=C3=AFve: After the first character has arrived, t=
he
> data register never gets set to zero again. To properly check whether a
> byte is available, we need to check the "RX fifo empty" on the pl011 UART
> or the "RX data ready" bit on the ns16550a UART instead.
>
> With this proper check in place, we can finally also get rid of the
> ugly assert(count < 16) statement here.
>
> Signed-off-by: Thomas Huth <thuth@redhat.com>

With the QEMU bug fix, the multi migration patches work well on
arm64 with this patch for me (on TCG).

Tested-by: Nicholas Piggin <npiggin@gmail.com>

Thanks,
Nick

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
>  static volatile u8 *uart0_base =3D UART_EARLY_BASE;
> +bool is_pl011_uart;
> =20
>  static void uart0_init_fdt(void)
>  {
> @@ -59,7 +60,10 @@ static void uart0_init_fdt(void)
>  			abort();
>  		}
> =20
> +		is_pl011_uart =3D (i =3D=3D 0);
>  	} else {
> +		is_pl011_uart =3D !fdt_node_check_compatible(dt_fdt(), ret,
> +		                                           "arm,pl011");
>  		ret =3D dt_pbus_translate_node(ret, 0, &base);
>  		assert(ret =3D=3D 0);
>  	}
> @@ -111,31 +115,21 @@ void puts(const char *s)
>  	spin_unlock(&uart_lock);
>  }
> =20
> -static int do_getchar(void)
> +int __getchar(void)
>  {
> -	int c;
> +	int c =3D -1;
> =20
>  	spin_lock(&uart_lock);
> -	c =3D readb(uart0_base);
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
> -	int c =3D do_getchar();
> -	static int count;
> =20
> -	if (c !=3D -1)
> -		++count;
> +	if (is_pl011_uart) {
> +		if (!(readb(uart0_base + 6 * 4) & 0x10))  /* RX not empty? */
> +			c =3D readb(uart0_base);
> +	} else {
> +		if (readb(uart0_base + 5) & 0x01)         /* RX data ready? */
> +			c =3D readb(uart0_base);
> +	}
> =20
> -	assert(count < 16);
> +	spin_unlock(&uart_lock);
> =20
>  	return c;
>  }


