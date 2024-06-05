Return-Path: <kvm+bounces-18837-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CA1F58FC112
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 03:04:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6A731282916
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 01:04:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B9C45C82;
	Wed,  5 Jun 2024 01:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SjyBf4PK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A5E84A29
	for <kvm@vger.kernel.org>; Wed,  5 Jun 2024 01:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717549456; cv=none; b=tGyvIfUQHGITEHPFj1dN0sU4WvxOMsOgOKYh+v7QXKCRFfezf5lQ64hDXlCp6AWEChmzWkbSCYTj81LDVAvjReeGf/HGisiKyc/sB2xMOXxkdA/C/yrzis3a9XRXZ0flVincoDeZZW5ECBcXX+dgpt95ow5TWQ6yhmY0JAFrEL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717549456; c=relaxed/simple;
	bh=fgkeAwy/jfiMT2mWEXo7kXnY7MJo7UB93kb9RWMaVKU=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:Cc:
	 References:In-Reply-To; b=SOP/IPliN/CuMxeuz5RuXCgw+bvtvh/971lv2zCbLSRjnFpMteII2Hmj2ea5aBr+EBDV+9flNluXSs10LjWWVsiQLl5z7nBMEj+iSti1fCGxiee2RsjVzHIzI0ke0HUVqhAN3V18bZttP7rxuKypkIWuVRZnyhJghufzHvROZas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SjyBf4PK; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-6c9e8c0a15bso2402909a12.3
        for <kvm@vger.kernel.org>; Tue, 04 Jun 2024 18:04:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717549454; x=1718154254; darn=vger.kernel.org;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Oyj+P5t43pKHTJuKnYG7NhQQXfP08lprT6P4Es8XJ2Q=;
        b=SjyBf4PKw4tenADxGv0gK9bX2SIRrH4n0qhutjm3+WbLnIwVcjrdOlTA62gmSg9Vqp
         ItGCzjcEPcCKVmVSeEeuZ1onOtUAKuOXmiRxAV0CRVOeEMu2ucOB+mTcvDOuqRqAX+5+
         3vehZSH+Kz0pRQwT4+iM0msIBr0AqiPXZvJhaGFR3aKVS/xh6iefUyDl5ubcCLS9mvo/
         SIZ/C0u0v2dau7w9XbKGyWcLwSYAefwtJWiJRf9NifqfD0uKjNIQNBIAU03ZkXXO5NOt
         xK8nsaIeUEMcoMiZVJ0o2t3h1TxPLRNdMH9bpeAIS3PPosGIKbmGYoIlVe9DJygHrgYL
         f7RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717549454; x=1718154254;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Oyj+P5t43pKHTJuKnYG7NhQQXfP08lprT6P4Es8XJ2Q=;
        b=SggQJv2nlTw6aglvcxec2zcY18Q2UcgyRd8WoJrlUKFFPhLV9zKi1mkUQSOrfZuEFz
         wmq7fjz4efnaTw+7wknuzhtoC4mq0Zc0pdvrzVe1TuKnf7+6cTB6kV1/DnNdYOy1x3wx
         mZJRw6a4U7FP/+wByOiL52zGr0PE4g2fDrYaBA2zyFLaZdSsxPBvEEfJw0Zjr7mmQp8k
         BhUurFRBJf5byrtxXP6myMd1BoyUhHStuFuIPI5Citkv+5LxvtaQvgvY2nBHFgLyOD8B
         cukl6852Yk+Zm2/IKbWHSxfJtvv6IDZv4haNQI++d7GViwC1las9ftJeRROcI+A86BD2
         lJsg==
X-Forwarded-Encrypted: i=1; AJvYcCVb1mlxId8upJfjxVu8KNCzQTrgU4qWs7jXmamPkCQ+IJGkEQrW0PCRzHzSI+G+uqDuChPgfgMZctt8UUBwO9p/NwUP
X-Gm-Message-State: AOJu0YzbdQKKoT3YUV7URRNkqc2dU0OHwpA0ty4fX/Q76UDyt8WazNx5
	Cbkt2XeZdri7n2X7NPchTlDS13HpQ0DEst+2OUMxHUwbjNqMN3Al
X-Google-Smtp-Source: AGHT+IECq50jUUORKiDYMBjG95N98XIMKvb/xSRYaPvjPOBa00vc8Dgc78oKWMk2nlEI301hfIKVbw==
X-Received: by 2002:a05:6a21:196:b0:1b1:ed9d:f92e with SMTP id adf61e73a8af0-1b2b70eeae8mr1537879637.38.1717549454405;
        Tue, 04 Jun 2024 18:04:14 -0700 (PDT)
Received: from localhost (110-175-65-7.tpgi.com.au. [110.175.65.7])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70242c2448fsm7622992b3a.192.2024.06.04.18.04.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jun 2024 18:04:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 05 Jun 2024 11:04:09 +1000
Message-Id: <D1ROGSFOPWVG.P6EV7DR1DIT2@gmail.com>
Subject: Re: [kvm-unit-tests PATCH v9 21/31] powerpc: Add timebase tests
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Thomas Huth" <thuth@redhat.com>
Cc: "Laurent Vivier" <lvivier@redhat.com>, "Andrew Jones"
 <andrew.jones@linux.dev>, <linuxppc-dev@lists.ozlabs.org>,
 <kvm@vger.kernel.org>
X-Mailer: aerc 0.17.0
References: <20240504122841.1177683-1-npiggin@gmail.com>
 <20240504122841.1177683-22-npiggin@gmail.com>
 <014763b7-93d9-4725-acc0-b5436a5ea91a@redhat.com>
In-Reply-To: <014763b7-93d9-4725-acc0-b5436a5ea91a@redhat.com>

On Tue Jun 4, 2024 at 4:12 PM AEST, Thomas Huth wrote:
> On 04/05/2024 14.28, Nicholas Piggin wrote:
> > This has a known failure on QEMU TCG machines where the decrementer
> > interrupt is not lowered when the DEC wraps from -ve to +ve.
>
> Would it then make sense to mark the test with accel =3D kvm to avoid the=
 test=20
> failure when running with TCG?

Still want to test it with TCG though, which had quite a few bugs I
used these tests to fix. It is marked as known fail for TCG (once the
later host accel patch is merged).

> > +/* Check amount of CPUs nodes that have the TM flag */
> > +static int find_dec_bits(void)
> > +{
> > +	int ret;
> > +
> > +	ret =3D dt_for_each_cpu_node(cpu_dec_bits, NULL);
>
> What sense does it make to run this for each CPU node if the cpu_dec_bits=
=20
> function always overwrites the global dec_bits variable?
> Wouldn't it be sufficient to run this for the first node only? Or should =
the=20
> cpu_dec_bits function maybe check that all nodes have the same value?

Yeah it could use first subnode.

> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	return dec_bits;
> > +}
> > +
> > +
> > +static bool do_migrate =3D false;
> > +static volatile bool got_interrupt;
> > +static volatile struct pt_regs recorded_regs;
> > +
> > +static uint64_t dec_max;
> > +static uint64_t dec_min;
> > +
> > +static void test_tb(int argc, char **argv)
> > +{
> > +	uint64_t tb;
> > +
> > +	tb =3D get_tb();
> > +	if (do_migrate)
> > +		migrate();
> > +	report(get_tb() >=3D tb, "timebase is incrementing");
>
> If you use >=3D for testing, it could also mean that the TB stays at the =
same=20
> value, so "timebase is incrementing" sounds misleading. Maybe rather=20
> "timebase is not decreasing" ? Or wait a little bit, then check with ">" =
only ?

Yeah, maybe first immediate test could ensure it doesn't go
backward, then wait a bit and check it increments.

> > +}
> > +
> > +static void dec_stop_handler(struct pt_regs *regs, void *data)
> > +{
> > +	mtspr(SPR_DEC, dec_max);
> > +}
> > +
> > +static void dec_handler(struct pt_regs *regs, void *data)
> > +{
> > +	got_interrupt =3D true;
> > +	memcpy((void *)&recorded_regs, regs, sizeof(struct pt_regs));
> > +	regs->msr &=3D ~MSR_EE;
> > +}
> > +
> > +static void test_dec(int argc, char **argv)
> > +{
> > +	uint64_t tb1, tb2, dec;
> > +	int i;
> > +
> > +	handle_exception(0x900, &dec_handler, NULL);
> > +
> > +	for (i =3D 0; i < 100; i++) {
> > +		tb1 =3D get_tb();
> > +		mtspr(SPR_DEC, dec_max);
> > +		dec =3D mfspr(SPR_DEC);
> > +		tb2 =3D get_tb();
> > +		if (tb2 - tb1 < dec_max - dec)
> > +			break;
> > +	}
> > +	/* POWER CPUs can have a slight (few ticks) variation here */
> > +	report_kfail(true, tb2 - tb1 >=3D dec_max - dec, "decrementer remains=
 within TB after mtDEC");
> > +
> > +	tb1 =3D get_tb();
> > +	mtspr(SPR_DEC, dec_max);
> > +	mdelay(1000);
> > +	dec =3D mfspr(SPR_DEC);
> > +	tb2 =3D get_tb();
> > +	report(tb2 - tb1 >=3D dec_max - dec, "decrementer remains within TB a=
fter 1s");
> > +
> > +	mtspr(SPR_DEC, dec_max);
> > +	local_irq_enable();
> > +	local_irq_disable();
> > +	if (mfspr(SPR_DEC) <=3D dec_max) {
> > +		report(!got_interrupt, "no interrupt on decrementer positive");
> > +	}
> > +	got_interrupt =3D false;
> > +
> > +	mtspr(SPR_DEC, 1);
> > +	mdelay(100); /* Give the timer a chance to run */
> > +	if (do_migrate)
> > +		migrate();
> > +	local_irq_enable();
> > +	local_irq_disable();
> > +	report(got_interrupt, "interrupt on decrementer underflow");
> > +	got_interrupt =3D false;
> > +
> > +	if (do_migrate)
> > +		migrate();
> > +	local_irq_enable();
> > +	local_irq_disable();
> > +	report(got_interrupt, "interrupt on decrementer still underflown");
> > +	got_interrupt =3D false;
> > +
> > +	mtspr(SPR_DEC, 0);
> > +	mdelay(100); /* Give the timer a chance to run */
> > +	if (do_migrate)
> > +		migrate();
> > +	local_irq_enable();
> > +	local_irq_disable();
> > +	report(got_interrupt, "DEC deal with set to 0");
> > +	got_interrupt =3D false;
> > +
> > +	/* Test for level-triggered decrementer */
> > +	mtspr(SPR_DEC, -1ULL);
> > +	if (do_migrate)
> > +		migrate();
> > +	local_irq_enable();
> > +	local_irq_disable();
> > +	report(got_interrupt, "interrupt on decrementer write MSB");
> > +	got_interrupt =3D false;
> > +
> > +	mtspr(SPR_DEC, dec_max);
> > +	local_irq_enable();
> > +	if (do_migrate)
> > +		migrate();
> > +	mtspr(SPR_DEC, -1);
> > +	local_irq_disable();
> > +	report(got_interrupt, "interrupt on decrementer write MSB with irqs o=
n");
> > +	got_interrupt =3D false;
> > +
> > +	mtspr(SPR_DEC, dec_min + 1);
> > +	mdelay(100);
> > +	local_irq_enable();
> > +	local_irq_disable();
> > +	/* TCG does not model this correctly */
> > +	report_kfail(true, !got_interrupt, "no interrupt after wrap to positi=
ve");
> > +	got_interrupt =3D false;
> > +
> > +	handle_exception(0x900, NULL, NULL);
> > +}
> > +
> > +static void test_hdec(int argc, char **argv)
> > +{
> > +	uint64_t tb1, tb2, hdec;
> > +
> > +	if (!machine_is_powernv()) {
> > +		report_skip("skipping on !powernv machine");
>
> I'd rather say "not running on powernv machine"

Okay.

Thanks,
Nick

