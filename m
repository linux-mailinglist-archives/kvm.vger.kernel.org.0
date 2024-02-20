Return-Path: <kvm+bounces-9112-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D1B2E85B093
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 02:38:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3783FB22260
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 01:38:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7416945942;
	Tue, 20 Feb 2024 01:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B5+Rcxno"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FC6E405EC
	for <kvm@vger.kernel.org>; Tue, 20 Feb 2024 01:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708393073; cv=none; b=BMYN39DW/9GKzw6NygKQIr3HkfPlRMhZ1JcWzlw4Ka5R0UdQqR7lCD3UC7g8TL97mhPJ0GzreF0Ucd3Jk9dT6bOY6rQzCpavIN6fqcMgxEyxiio6M5iylpAkvlr/4h2BZgKUpqcNfjY8sju4yNdRDKTZ60f4MBKTikV2DFgDzGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708393073; c=relaxed/simple;
	bh=tZhbd5SMUDQHUNl5Fq6WaKWET16FL5fhIAh4Vm93LO4=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=kZ1hcvPeBGurCSc8Lfd2RzDUBrjatYi50wF9cJL1wbUnA9zuombJ3UQNLv4RUnjyoqklH5cMbefNLuah9YT0D7ni/y4lyj82Xp6ZeIVIgg5jrjNJ++xKJoEowLJbmhpAu5bxRhT3Gz6jeukeWri898QdINdH5v3oU3V4OhuDwHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B5+Rcxno; arc=none smtp.client-ip=209.85.167.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-3c132695f1bso3817618b6e.2
        for <kvm@vger.kernel.org>; Mon, 19 Feb 2024 17:37:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708393070; x=1708997870; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nFajET3gehPBC380UF5pOUPKWV3LT2rAo3DivAM+jaw=;
        b=B5+RcxnoAb+vOpUmP4Blq56FepEVpX2BI1ibkaPupkPGiYb3IZcaHOGhZyqRfJEB13
         FIMDJNWkk2wmYZpzCY5zbxkd9TtYOLkH0KMRW/sdx605WqKLRPAshUDkyLTFG9lGEcsr
         LBj7DXD4s3txCfLQzbGUIiHbXUrvaEUENfvaEMFhKiltECB34dySI9VQMmv5Rm8+78W8
         AYsWP8aVKdKs2vcV3gMsANsEhc2RHBzfMwCcW6Ye3bPs5f9Yu/xWes9QwYdkgcpV65NG
         fpFzyhDli69OcxIpMrmcgUy+rtc/spkc6iygl8GsSODyopHVSuxwfjaTeKqk6OzW/CGZ
         zI9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708393070; x=1708997870;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=nFajET3gehPBC380UF5pOUPKWV3LT2rAo3DivAM+jaw=;
        b=q/tFMj+/7wsxLkH1BfyyBVsZVO2SaytkJSOXO699sgOYsZ/rkyd/pTh9opxe3IzpBp
         pQ5ojusspgzdInoodoSP6SPO2PqZSgaVspS0vfHnvziZm68m3dI6cYJoWYn8JF1cavEW
         RsDO+psdiXQqC2yU9zO9ogzd3OVxDkilMr43fqjJODy+lyUZYT53XuGp7/OGGn8FFMj0
         vGxHzdJZ4EuP/3q/us2Ywnyey2GYn6qITJyXA5HF7ThwzZiLGm/LLmN4ktkKNSTzo3qB
         Ot4ZvxhiIMYXHSQ0IlbpfUIof25O05nvnL3XfpDJ8NijXCp9B9jWfh7reo+RNuZ6D7RX
         ms1A==
X-Forwarded-Encrypted: i=1; AJvYcCVp0JAVxjoufc4+TAThEXY8dHgXU0DQYiF3P5OwsPlVUfTR7tqZPlRbs7bbKbaj428mNA7hxa8PIJ4hJKyuRuvCnPA4
X-Gm-Message-State: AOJu0Yy55wV6QUKkBovUS7uIysVqq9ttYVQoIeEPCQUf9yghxPrYEOX7
	DZ+KsQBvyhC14EjoqVDxDqkwVLHDBXXP++AecEePNR2zIKUxfDgT
X-Google-Smtp-Source: AGHT+IEgavf6g8kYYQ/AYPYws0X7emy2nUHVxar1CkHBpLrZcENDqEXdzI0imvbnFzSVw0u4o8uh/w==
X-Received: by 2002:a05:6358:e486:b0:176:d0a8:8df with SMTP id by6-20020a056358e48600b00176d0a808dfmr16032730rwb.8.1708393070162;
        Mon, 19 Feb 2024 17:37:50 -0800 (PST)
Received: from localhost (123-243-155-241.static.tpgi.com.au. [123.243.155.241])
        by smtp.gmail.com with ESMTPSA id l9-20020a170902eb0900b001db63cfe07dsm5035906plb.283.2024.02.19.17.37.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Feb 2024 17:37:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 20 Feb 2024 11:37:44 +1000
Message-Id: <CZ9ISRDH0OPM.CL3D0AK4NN8M@wheely>
Cc: "Andrew Jones" <andrew.jones@linux.dev>, "Eric Auger"
 <eric.auger@redhat.com>, <kvm@vger.kernel.org>, <kvmarm@lists.linux.dev>
Subject: Re: [kvm-unit-tests PATCH] lib/arm/io: Fix calling getchar()
 multiple times
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Alexandru Elisei" <alexandru.elisei@arm.com>, "Thomas Huth"
 <thuth@redhat.com>
X-Mailer: aerc 0.15.2
References: <20240216140210.70280-1-thuth@redhat.com>
 <ZdOIJfvVm7C23ZdZ@raptor>
In-Reply-To: <ZdOIJfvVm7C23ZdZ@raptor>

On Tue Feb 20, 2024 at 2:56 AM AEST, Alexandru Elisei wrote:
> Hi,
>
> Thanks for writing this. I've tested it with kvmtool, which emulates a 82=
50
> UART:
>
> Tested-by: Alexandru Elisei <alexandru.elisei@arm.com>
>
> This fixes a longstanding bug with kvmtool, where migrate_once() would re=
ad
> the last character that was sent, and then think that migration was
> completed even though it was never performed.
>
> While we are on the subject of migration:
>
> SKIP: gicv3: its-migration: Test requires at least 4 vcpus
> Now migrate the VM, then press a key to continue...
> INFO: gicv3: its-migration: Migration complete
> SUMMARY: 1 tests, 1 skipped
>
> That's extremely confusing. Why is migrate_once() executed after the
> test_its_pending() function call without checking if the test was skipped=
?

Looks like it was done so the test is skipped without killing the harness
due to expected migration point not being reached.

After the multi-migration series, you could just put a migrate_quiet()
there as a quick fix.

But I'm thinking we could just remove the requirement for the harness
to see at least 1 migration point. The test itself knows how many
migrations it should perform, by how many times it calls migrate*().
It is somewhat a sanity test against test being invoked the wrong way
and not doing the migration, but how much is that worth...? Actually
we could have a new sideband message like "VM migration is skipped"
that doesn't do anything except tell the test harness to not fail
due to missing migration point. That gets the best of both worlds,
just needs tests to be updated.

Thanks,
Nick

>
> Nitpicks below.
>
> On Fri, Feb 16, 2024 at 03:02:10PM +0100, Thomas Huth wrote:
> > getchar() can currently only be called once on arm since the implementa=
tion
> > is a little bit too  na=C3=AFve: After the first character has arrived,=
 the
> > data register never gets set to zero again. To properly check whether a
> > byte is available, we need to check the "RX fifo empty" on the pl011 UA=
RT
> > or the "RX data ready" bit on the ns16550a UART instead.
> >=20
> > With this proper check in place, we can finally also get rid of the
> > ugly assert(count < 16) statement here.
> >=20
> > Signed-off-by: Thomas Huth <thuth@redhat.com>
> > ---
> >  lib/arm/io.c | 34 ++++++++++++++--------------------
> >  1 file changed, 14 insertions(+), 20 deletions(-)
> >=20
> > diff --git a/lib/arm/io.c b/lib/arm/io.c
> > index c15e57c4..836fa854 100644
> > --- a/lib/arm/io.c
> > +++ b/lib/arm/io.c
> > @@ -28,6 +28,7 @@ static struct spinlock uart_lock;
> >   */
> >  #define UART_EARLY_BASE (u8 *)(unsigned long)CONFIG_UART_EARLY_BASE
> >  static volatile u8 *uart0_base =3D UART_EARLY_BASE;
> > +bool is_pl011_uart;
> > =20
> >  static void uart0_init_fdt(void)
> >  {
> > @@ -59,7 +60,10 @@ static void uart0_init_fdt(void)
> >  			abort();
> >  		}
> > =20
> > +		is_pl011_uart =3D (i =3D=3D 0);
> >  	} else {
> > +		is_pl011_uart =3D !fdt_node_check_compatible(dt_fdt(), ret,
> > +		                                           "arm,pl011");
> >  		ret =3D dt_pbus_translate_node(ret, 0, &base);
> >  		assert(ret =3D=3D 0);
> >  	}
> > @@ -111,31 +115,21 @@ void puts(const char *s)
> >  	spin_unlock(&uart_lock);
> >  }
> > =20
> > -static int do_getchar(void)
> > +int __getchar(void)
> >  {
> > -	int c;
> > +	int c =3D -1;
> > =20
> >  	spin_lock(&uart_lock);
> > -	c =3D readb(uart0_base);
> > -	spin_unlock(&uart_lock);
> > -
> > -	return c ?: -1;
> > -}
> > -
> > -/*
> > - * Minimalist implementation for migration completion detection.
> > - * Without FIFOs enabled on the QEMU UART device we just read
> > - * the data register: we cannot read more than 16 characters.
> > - */
> > -int __getchar(void)
> > -{
> > -	int c =3D do_getchar();
> > -	static int count;
> > =20
> > -	if (c !=3D -1)
> > -		++count;
> > +	if (is_pl011_uart) {
> > +		if (!(readb(uart0_base + 6 * 4) & 0x10))  /* RX not empty? */
>
> I think it would be useful if the magic numbers were replaced by somethin=
g
> less opaque, something like:
>
> 		if (!(readb(uart0_base + PL011_UARTFR) & PL011_UARTFR_RXFE))
>
> > +			c =3D readb(uart0_base);
> > +	} else {
> > +		if (readb(uart0_base + 5) & 0x01)         /* RX data ready? */
>
> Same as above, perhaps:
>
> 		if (readb(uart0_base + UART16550_LSR) & UART16550_LSR_DR)
>
> Naming of course being subject to taste.
>
> Thanks,
> Alex
>
> > +			c =3D readb(uart0_base);
> > +	}
> > =20
> > -	assert(count < 16);
> > +	spin_unlock(&uart_lock);
> > =20
> >  	return c;
> >  }
> > --=20
> > 2.43.0
> >=20


