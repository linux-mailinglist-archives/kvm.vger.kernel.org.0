Return-Path: <kvm+bounces-18728-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2221C8FAA8E
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 08:12:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 89B611F22105
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 06:12:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A27A13D511;
	Tue,  4 Jun 2024 06:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OpiUuYMv"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACD7814294
	for <kvm@vger.kernel.org>; Tue,  4 Jun 2024 06:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717481565; cv=none; b=Q6QdNYXVyLW226K6qtGbSmmEl/wwUxtc5oeFpP5CZZrHA2OHPGFEt4lyfJHNspdNxDOYzxuORx693JZOuBfQzllGgSXV8iqz5tXdvlL/1RKhq2mUN+GFSMZP460GbtEn0KsFDVMUlu1eaw0jv6E9wkBniOnNuiLmkXeMktO6tXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717481565; c=relaxed/simple;
	bh=fD3NngslPAJxTE7XdYyxMvAFqzzrEDAkWTj7pl+0X5I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Am/QUpbNdB8Thn+7rJcWBj06EZ8oVeA4G+sE68zrJhBTwmF5V4w/ZvyDFeJWaSrintfOx2swao4Q/rUcnMFGExT5G2IuJ0Zn70csFHqjFytk4/ubzSKnQExFzVaMyUhhokbge5Afn50QTzabWRk+xZP8zzLYR2bWZsRHXEJ+XJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OpiUuYMv; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717481562;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=kouAuKW5xy3pVULjE18K8TFXVjcNP5iYKQ3l8/U0TTE=;
	b=OpiUuYMvE2iIHEcTmh2JXQVclsXeEZ3yWIe8/bxtHCVUBP6dbwASbgoUFxAagVA3F8Zm6V
	0QpvE+hZa/1U0V3DdL2iIMmXA4mno5F6ZO5OEq/ouAGlWoH0KsHOj3UaI4mVjrqATONESe
	+oHcuke/F7WV6uYeYCZUp4J36n7ydLU=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-680-uObMmHOPN--uQcumO3CLVA-1; Tue, 04 Jun 2024 02:12:40 -0400
X-MC-Unique: uObMmHOPN--uQcumO3CLVA-1
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-2ea95b8aa6aso28523461fa.2
        for <kvm@vger.kernel.org>; Mon, 03 Jun 2024 23:12:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717481559; x=1718086359;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kouAuKW5xy3pVULjE18K8TFXVjcNP5iYKQ3l8/U0TTE=;
        b=ETQmRx3fU7buXyeJmhVj8kfu6JIVzrGVMWR4Tpt4v3WlV755Q6Ok/Hxz5CG8R76Rtf
         bFBIe0FU6stb4l0NVYhGt+X/rrZRkepzdOSl3rQd8eyuBFflV3aBh8qIUGUNFnGBzcHi
         JFACOYoylmPndCml+dHogfog86TMAqTRW4o/J9xH9WM7mm2y+FehIFo/kDGC6tvgY0s9
         W9D4XZGCaJ9U9A7FmFt9v8Pn2FK7AV3CgZtKjkJpMmk/kvLDQcLXSYeP4Er/h5hLigJ0
         4Wpu2mcGEIu5Lc+pdE3DT1OumZcCuMviHX4bbxXXG3z1pJ4qDZ1IEzNavBJvc0rveKaZ
         I8cA==
X-Forwarded-Encrypted: i=1; AJvYcCWDyaa8u1qOTW53lzigho96EjmmfYJxvLdN00asstEoOMG+3X3jc7JXPZ5TPKaJvsDxqhdqxx7nEVreQC6YLG5LzIZV
X-Gm-Message-State: AOJu0YxIGNjnmET+nJHwutbNTdqg4kcjxqhg5g7AgSbafpe3RDnbDt3A
	PfXF+eS8Tq7f+2ERc6V8DByQsCFoJQNgl7MAQgyvBUyYQbCQYBOlC4+IoiaQlwbIenbm9uwUqjU
	eTFzO49zWdD8flUhgdqbgtTgE0GG9lNtRXw1hL5fHtru+Zwi3lQ==
X-Received: by 2002:a2e:9796:0:b0:2ea:7a0b:7935 with SMTP id 38308e7fff4ca-2ea9515f4bcmr71370241fa.24.1717481559441;
        Mon, 03 Jun 2024 23:12:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHDUj5p9Nd1S78kdtNmrzEwvoPot4HNUSev3rqZ6AHZ6a9Im/hY9CiQpfb+U2aDjGq3aUi/4Q==
X-Received: by 2002:a2e:9796:0:b0:2ea:7a0b:7935 with SMTP id 38308e7fff4ca-2ea9515f4bcmr71370081fa.24.1717481558979;
        Mon, 03 Jun 2024 23:12:38 -0700 (PDT)
Received: from [192.168.0.4] (ip-109-43-178-97.web.vodafone.de. [109.43.178.97])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4214beb5c9asm8052605e9.7.2024.06.03.23.12.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Jun 2024 23:12:38 -0700 (PDT)
Message-ID: <014763b7-93d9-4725-acc0-b5436a5ea91a@redhat.com>
Date: Tue, 4 Jun 2024 08:12:37 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v9 21/31] powerpc: Add timebase tests
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Laurent Vivier <lvivier@redhat.com>, Andrew Jones
 <andrew.jones@linux.dev>, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org
References: <20240504122841.1177683-1-npiggin@gmail.com>
 <20240504122841.1177683-22-npiggin@gmail.com>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240504122841.1177683-22-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 04/05/2024 14.28, Nicholas Piggin wrote:
> This has a known failure on QEMU TCG machines where the decrementer
> interrupt is not lowered when the DEC wraps from -ve to +ve.

Would it then make sense to mark the test with accel = kvm to avoid the test 
failure when running with TCG?

> diff --git a/powerpc/timebase.c b/powerpc/timebase.c
> new file mode 100644
> index 000000000..02a4e33c0
> --- /dev/null
> +++ b/powerpc/timebase.c
> @@ -0,0 +1,331 @@
> +/* SPDX-License-Identifier: LGPL-2.0-only */
> +/*
> + * Test Timebase
> + *
> + * Copyright 2024 Nicholas Piggin, IBM Corp.
> + *
> + * This contains tests of timebase facility, TB, DEC, etc.
> + */
> +#include <libcflat.h>
> +#include <util.h>
> +#include <migrate.h>
> +#include <alloc.h>
> +#include <asm/handlers.h>
> +#include <devicetree.h>
> +#include <asm/hcall.h>
> +#include <asm/processor.h>
> +#include <asm/time.h>
> +#include <asm/barrier.h>
> +
> +static int dec_bits = 0;
> +
> +static void cpu_dec_bits(int fdtnode, u64 regval __unused, void *arg __unused)
> +{
> +	const struct fdt_property *prop;
> +	int plen;
> +
> +	prop = fdt_get_property(dt_fdt(), fdtnode, "ibm,dec-bits", &plen);
> +	if (!prop) {
> +		dec_bits = 32;
> +		return;
> +	}
> +
> +	/* Sanity check for the property layout (first two bytes are header) */
> +	assert(plen == 4);
> +
> +	dec_bits = fdt32_to_cpu(*(uint32_t *)prop->data);
> +}
> +
> +/* Check amount of CPUs nodes that have the TM flag */
> +static int find_dec_bits(void)
> +{
> +	int ret;
> +
> +	ret = dt_for_each_cpu_node(cpu_dec_bits, NULL);

What sense does it make to run this for each CPU node if the cpu_dec_bits 
function always overwrites the global dec_bits variable?
Wouldn't it be sufficient to run this for the first node only? Or should the 
cpu_dec_bits function maybe check that all nodes have the same value?

> +	if (ret < 0)
> +		return ret;
> +
> +	return dec_bits;
> +}
> +
> +
> +static bool do_migrate = false;
> +static volatile bool got_interrupt;
> +static volatile struct pt_regs recorded_regs;
> +
> +static uint64_t dec_max;
> +static uint64_t dec_min;
> +
> +static void test_tb(int argc, char **argv)
> +{
> +	uint64_t tb;
> +
> +	tb = get_tb();
> +	if (do_migrate)
> +		migrate();
> +	report(get_tb() >= tb, "timebase is incrementing");

If you use >= for testing, it could also mean that the TB stays at the same 
value, so "timebase is incrementing" sounds misleading. Maybe rather 
"timebase is not decreasing" ? Or wait a little bit, then check with ">" only ?

> +}
> +
> +static void dec_stop_handler(struct pt_regs *regs, void *data)
> +{
> +	mtspr(SPR_DEC, dec_max);
> +}
> +
> +static void dec_handler(struct pt_regs *regs, void *data)
> +{
> +	got_interrupt = true;
> +	memcpy((void *)&recorded_regs, regs, sizeof(struct pt_regs));
> +	regs->msr &= ~MSR_EE;
> +}
> +
> +static void test_dec(int argc, char **argv)
> +{
> +	uint64_t tb1, tb2, dec;
> +	int i;
> +
> +	handle_exception(0x900, &dec_handler, NULL);
> +
> +	for (i = 0; i < 100; i++) {
> +		tb1 = get_tb();
> +		mtspr(SPR_DEC, dec_max);
> +		dec = mfspr(SPR_DEC);
> +		tb2 = get_tb();
> +		if (tb2 - tb1 < dec_max - dec)
> +			break;
> +	}
> +	/* POWER CPUs can have a slight (few ticks) variation here */
> +	report_kfail(true, tb2 - tb1 >= dec_max - dec, "decrementer remains within TB after mtDEC");
> +
> +	tb1 = get_tb();
> +	mtspr(SPR_DEC, dec_max);
> +	mdelay(1000);
> +	dec = mfspr(SPR_DEC);
> +	tb2 = get_tb();
> +	report(tb2 - tb1 >= dec_max - dec, "decrementer remains within TB after 1s");
> +
> +	mtspr(SPR_DEC, dec_max);
> +	local_irq_enable();
> +	local_irq_disable();
> +	if (mfspr(SPR_DEC) <= dec_max) {
> +		report(!got_interrupt, "no interrupt on decrementer positive");
> +	}
> +	got_interrupt = false;
> +
> +	mtspr(SPR_DEC, 1);
> +	mdelay(100); /* Give the timer a chance to run */
> +	if (do_migrate)
> +		migrate();
> +	local_irq_enable();
> +	local_irq_disable();
> +	report(got_interrupt, "interrupt on decrementer underflow");
> +	got_interrupt = false;
> +
> +	if (do_migrate)
> +		migrate();
> +	local_irq_enable();
> +	local_irq_disable();
> +	report(got_interrupt, "interrupt on decrementer still underflown");
> +	got_interrupt = false;
> +
> +	mtspr(SPR_DEC, 0);
> +	mdelay(100); /* Give the timer a chance to run */
> +	if (do_migrate)
> +		migrate();
> +	local_irq_enable();
> +	local_irq_disable();
> +	report(got_interrupt, "DEC deal with set to 0");
> +	got_interrupt = false;
> +
> +	/* Test for level-triggered decrementer */
> +	mtspr(SPR_DEC, -1ULL);
> +	if (do_migrate)
> +		migrate();
> +	local_irq_enable();
> +	local_irq_disable();
> +	report(got_interrupt, "interrupt on decrementer write MSB");
> +	got_interrupt = false;
> +
> +	mtspr(SPR_DEC, dec_max);
> +	local_irq_enable();
> +	if (do_migrate)
> +		migrate();
> +	mtspr(SPR_DEC, -1);
> +	local_irq_disable();
> +	report(got_interrupt, "interrupt on decrementer write MSB with irqs on");
> +	got_interrupt = false;
> +
> +	mtspr(SPR_DEC, dec_min + 1);
> +	mdelay(100);
> +	local_irq_enable();
> +	local_irq_disable();
> +	/* TCG does not model this correctly */
> +	report_kfail(true, !got_interrupt, "no interrupt after wrap to positive");
> +	got_interrupt = false;
> +
> +	handle_exception(0x900, NULL, NULL);
> +}
> +
> +static void test_hdec(int argc, char **argv)
> +{
> +	uint64_t tb1, tb2, hdec;
> +
> +	if (!machine_is_powernv()) {
> +		report_skip("skipping on !powernv machine");

I'd rather say "not running on powernv machine"

> +		return;
> +	}

  Thomas



