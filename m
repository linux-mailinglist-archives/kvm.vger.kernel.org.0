Return-Path: <kvm+bounces-18749-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DC4C8FAFF3
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 12:38:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 39F7D1C22414
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 10:38:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBD0F145333;
	Tue,  4 Jun 2024 10:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U5Yd1d50"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 628A514532F
	for <kvm@vger.kernel.org>; Tue,  4 Jun 2024 10:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717497496; cv=none; b=ABtr7KG6GYrV73IgRE2VyvhJkUCNSHFGZ9jaTNpJKqYB+p90dGBdySxTSoaoPCP8eXYwlfrKcyX5CAZFFa4I07WhFdbiOgRMhL9j1jitljRXGPsHsPMP9RpzS8nMP+WReJYaKVVm0mPmLBaLMUV25N0F35uqQMFgUtbSzjG/Eb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717497496; c=relaxed/simple;
	bh=vVcHV5sCdb7U1ADlc2oYxhAXF7u/tgG9IHdZt3B+XGQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XOBRx/gLl0ED/GNlLqNX68NUqePjKnxdc60o+2fNWQr6yrpbIlfe3BzX7t2Og4d2ifqaMNczCAwO7uZirFY8ynTOYUJoU49TwP7sXEeAp3//b+6/EzrQG1eVkGR/nlo4srzc7JMieq2ZXXAw39vKp1z7WgA7V/TDTVpyPEWOGxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=U5Yd1d50; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717497492;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=7Nvp5AaQYpAVjvz+txzIU0wdf5FQKPdQuCtMNBtXpUw=;
	b=U5Yd1d50dd2l7yGTmtRWqMchgLIgrm19qy89AU+DDZGtCRb6I53MtiFyFgWIkamTDy2Oio
	DW1p8TGz4aTsNH94o0poeGksrL9ljqPdbKszfVE2uGJY07Fj42rQBzRTDgQxg/i/YnXaN2
	PiuDY7l+UM26IHYJP/wINJfXvkDQA2E=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-359-Ohg0HhNOM3GCWOYSfrQ7Lg-1; Tue, 04 Jun 2024 06:38:11 -0400
X-MC-Unique: Ohg0HhNOM3GCWOYSfrQ7Lg-1
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-2e714e6f8b2so43499561fa.1
        for <kvm@vger.kernel.org>; Tue, 04 Jun 2024 03:38:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717497489; x=1718102289;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7Nvp5AaQYpAVjvz+txzIU0wdf5FQKPdQuCtMNBtXpUw=;
        b=sd+h6OENW6ZmKF3Y5PRETlHFR2NpPO/UoGujuIF0bFT9bC+rTvfA3ByowPySPOZvPH
         gnKe1+j7Z95wiRueXFAxqsD3hf0AtO3YPc8y2+lKXOeR+Z7mZNZBCFrWt0FBGxwaH+74
         5u6VHzLM3H0sQzgZ7fuz4ayIUDglc5l2T+L8ValTdepgj8g6e8Hvw3/TQ4gQ9Dbi/1Et
         Ylm5be7fYgf/pODz0XfAYXJzizAcHJ1qSLAuPFVRNPLmGTqOWca75UaVWdsvhh0H9z6x
         0GtttcycdwatgalQCzliiSpJcaNqpbi72Ek7GeqI8Y+fljZYph9tNdTtijrUNCg//vRb
         WTbg==
X-Forwarded-Encrypted: i=1; AJvYcCWausohstxI0l1vLw9AhBWDutv84VmCVAhww9w7sCGJxTTHow/msJcrIBZWVdez9KmuMnwnVgQ4wvsjD8MgsWFocz98
X-Gm-Message-State: AOJu0Ywg5THFOtmPdMxGcXQWDrGdOwgWadA1mar2mkCSN73LTi10nJAI
	RLsyX+Yq4ff5xHlduvH1/HFBMOcUnkDBlytgcqJ0shaNaXk+4rFXMzAx+TRm5uYD3DZnmc7IcjF
	aDSnVwTIGyfDeywWdhv0ssgD7An2SWzcwUH2hm7NPGJ9BlrUWIA==
X-Received: by 2002:a05:651c:1991:b0:2ea:7603:af63 with SMTP id 38308e7fff4ca-2ea95163bc3mr97230441fa.26.1717497489014;
        Tue, 04 Jun 2024 03:38:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGucLj+jsMZRzmFr7a7rwwFQ95iNenHorKzmqkWKAWnjfwZ3relZ2Y/3/C/VEsoRqpUk8ysUw==
X-Received: by 2002:a05:651c:1991:b0:2ea:7603:af63 with SMTP id 38308e7fff4ca-2ea95163bc3mr97230241fa.26.1717497488601;
        Tue, 04 Jun 2024 03:38:08 -0700 (PDT)
Received: from [192.168.0.4] (ip-109-43-178-97.web.vodafone.de. [109.43.178.97])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4212b85c628sm149890405e9.25.2024.06.04.03.38.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jun 2024 03:38:08 -0700 (PDT)
Message-ID: <c497801d-f043-46f5-bfa2-74eff672ae47@redhat.com>
Date: Tue, 4 Jun 2024 12:38:07 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v9 27/31] powerpc: add pmu tests
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Laurent Vivier <lvivier@redhat.com>, Andrew Jones
 <andrew.jones@linux.dev>, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org
References: <20240504122841.1177683-1-npiggin@gmail.com>
 <20240504122841.1177683-28-npiggin@gmail.com>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240504122841.1177683-28-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 04/05/2024 14.28, Nicholas Piggin wrote:
> Add some initial PMU testing.
> 
> - PMC5/6 tests
> - PMAE / PMI test
> - BHRB basic tests
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
...
> diff --git a/lib/powerpc/setup.c b/lib/powerpc/setup.c
> index a4ff678ce..8ff4939e2 100644
> --- a/lib/powerpc/setup.c
> +++ b/lib/powerpc/setup.c
> @@ -33,6 +33,7 @@ u32 initrd_size;
>   u32 cpu_to_hwid[NR_CPUS] = { [0 ... NR_CPUS-1] = (~0U) };
>   int nr_cpus_present;
>   uint64_t tb_hz;
> +uint64_t cpu_hz;
>   
>   struct mem_region mem_regions[NR_MEM_REGIONS];
>   phys_addr_t __physical_start, __physical_end;
> @@ -42,6 +43,7 @@ struct cpu_set_params {
>   	unsigned icache_bytes;
>   	unsigned dcache_bytes;
>   	uint64_t tb_hz;
> +	uint64_t cpu_hz;
>   };
>   
>   static void cpu_set(int fdtnode, u64 regval, void *info)
> @@ -95,6 +97,22 @@ static void cpu_set(int fdtnode, u64 regval, void *info)
>   		data = (u32 *)prop->data;
>   		params->tb_hz = fdt32_to_cpu(*data);
>   
> +		prop = fdt_get_property(dt_fdt(), fdtnode,
> +					"ibm,extended-clock-frequency", NULL);
> +		if (prop) {
> +			data = (u32 *)prop->data;
> +			params->cpu_hz = fdt32_to_cpu(*data);
> +			params->cpu_hz <<= 32;
> +			data = (u32 *)prop->data + 1;
> +			params->cpu_hz |= fdt32_to_cpu(*data);

Why don't you simply cast to (u64 *) and use fdt64_to_cpu() here instead?

...
> diff --git a/powerpc/pmu.c b/powerpc/pmu.c
> new file mode 100644
> index 000000000..8b13ee4cd
> --- /dev/null
> +++ b/powerpc/pmu.c
> @@ -0,0 +1,403 @@
...
> +static void test_pmc5_with_fault(void)
> +{
> +	unsigned long pmc5_1, pmc5_2;
> +
> +	handle_exception(0x700, &illegal_handler, NULL);
> +	handle_exception(0xe40, &illegal_handler, NULL);
> +
> +	reset_mmcr0();
> +	mtspr(SPR_PMC5, 0);
> +	mtspr(SPR_MMCR0, mfspr(SPR_MMCR0) & ~(MMCR0_FC | MMCR0_FC56));
> +	asm volatile(".long 0x0" ::: "memory");
> +	mtspr(SPR_MMCR0, mfspr(SPR_MMCR0) | (MMCR0_FC | MMCR0_FC56));
> +	assert(got_interrupt);
> +	got_interrupt = false;
> +	pmc5_1 = mfspr(SPR_PMC5);
> +
> +	reset_mmcr0();
> +	mtspr(SPR_PMC5, 0);
> +	mtspr(SPR_MMCR0, mfspr(SPR_MMCR0) & ~(MMCR0_FC | MMCR0_FC56));
> +	asm volatile(".rep 20 ; nop ; .endr ; .long 0x0" ::: "memory");
> +	mtspr(SPR_MMCR0, mfspr(SPR_MMCR0) | (MMCR0_FC | MMCR0_FC56));
> +	assert(got_interrupt);
> +	got_interrupt = false;
> +	pmc5_2 = mfspr(SPR_PMC5);
> +
> +	/* TCG and POWER9 do not count instructions around faults correctly */
> +	report_kfail(true, pmc5_1 + 20 == pmc5_2, "PMC5 counts instructions with fault");

It would be nice to have the TCG detection patch before this patch, so you 
could use the right condition here right from the start.

> +	handle_exception(0x700, NULL, NULL);
> +	handle_exception(0xe40, NULL, NULL);
> +}
> +
> +static void test_pmc5_with_sc(void)
> +{
> +	unsigned long pmc5_1, pmc5_2;
> +
> +	handle_exception(0xc00, &sc_handler, NULL);
> +
> +	reset_mmcr0();
> +	mtspr(SPR_PMC5, 0);
> +	mtspr(SPR_MMCR0, mfspr(SPR_MMCR0) & ~(MMCR0_FC | MMCR0_FC56));
> +	asm volatile("sc 0" ::: "memory");
> +	mtspr(SPR_MMCR0, mfspr(SPR_MMCR0) | (MMCR0_FC | MMCR0_FC56));
> +	assert(got_interrupt);
> +	got_interrupt = false;
> +	pmc5_1 = mfspr(SPR_PMC5);
> +
> +	reset_mmcr0();
> +	mtspr(SPR_PMC5, 0);
> +	mtspr(SPR_MMCR0, mfspr(SPR_MMCR0) & ~(MMCR0_FC | MMCR0_FC56));
> +	asm volatile(".rep 20 ; nop ; .endr ; sc 0" ::: "memory");
> +	mtspr(SPR_MMCR0, mfspr(SPR_MMCR0) | (MMCR0_FC | MMCR0_FC56));
> +	assert(got_interrupt);
> +	got_interrupt = false;
> +	pmc5_2 = mfspr(SPR_PMC5);
> +
> +	/* TCG does not count instructions around syscalls correctly */
> +	report_kfail(true, pmc5_1 + 20 == pmc5_2, "PMC5 counts instructions with syscall");

dito

> +	handle_exception(0xc00, NULL, NULL);
> +}
> +
> +static void test_pmc56(void)
> +{
> +	unsigned long tmp;
> +
> +	report_prefix_push("pmc56");
> +
> +	reset_mmcr0();
> +	mtspr(SPR_PMC5, 0);
> +	mtspr(SPR_PMC6, 0);
> +	report(mfspr(SPR_PMC5) == 0, "PMC5 zeroed");
> +	report(mfspr(SPR_PMC6) == 0, "PMC6 zeroed");
> +	mtspr(SPR_MMCR0, mfspr(SPR_MMCR0) & ~MMCR0_FC);
> +	msleep(100);
> +	report(mfspr(SPR_PMC5) == 0, "PMC5 frozen");
> +	report(mfspr(SPR_PMC6) == 0, "PMC6 frozen");
> +	mtspr(SPR_MMCR0, mfspr(SPR_MMCR0) & ~MMCR0_FC56);
> +	mdelay(100);
> +	mtspr(SPR_MMCR0, mfspr(SPR_MMCR0) | (MMCR0_FC | MMCR0_FC56));
> +	report(mfspr(SPR_PMC5) != 0, "PMC5 counting");
> +	report(mfspr(SPR_PMC6) != 0, "PMC6 counting");
> +
> +	/* Dynamic frequency scaling could cause to be out, so don't fail. */
> +	tmp = mfspr(SPR_PMC6);
> +	report(true, "PMC6 ratio to reported clock frequency is %ld%%", tmp * 1000 / cpu_hz);

report(true, ...) looks weird. Use report_info() instead?

  Thomas


