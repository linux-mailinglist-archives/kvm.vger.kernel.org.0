Return-Path: <kvm+bounces-36797-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4687FA21256
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 20:44:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A948D167528
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 19:44:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AD201DFE34;
	Tue, 28 Jan 2025 19:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="oXSPxpZR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D489F2E414
	for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 19:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738093449; cv=none; b=XDf8BiaFcNVpUs4uwICjVPmRZGcJz2wTDBYFEtr5O6fIextY5U0Jxf3LHASiFQX9JKVP0KVARvskfIx6qb0RQlCLoaXAS2nbrLKulkwnDPPvKrI06iYB8Ztu0MXGZv1N8ucvAWE09YaGsKu0RKDAgrwztN3vO2IxbBRsc+il20w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738093449; c=relaxed/simple;
	bh=Lc0Mem3Pv2VeILUVgyHLj56Enu/UelA5Mq2KsrE0AcQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qTq2c+93nw/Q5Vka5PgO3Cmd3qqlOT4jC5QE3YiaYZLMt3RtRJRsB1t1N4RvLhnIMVyevXJivNHJcN0mTITxQgBuCMmhHbynbnYeQLAlt6O3iFhGDeMo5U9Yl+NQQxG04SkoJlns/6KT6S7DEA0ck5TCZsOsMivhtrxCIBWpxLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=oXSPxpZR; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-219f8263ae0so112027445ad.0
        for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 11:44:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1738093447; x=1738698247; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=04aeoJjB5IJnzmcHt17DQP+KPYap4dU3QzpuAnykwIc=;
        b=oXSPxpZROmkD90R8fvLXd3+RIdvsXjcQwXd7w3Gry4PFLQkqbfZ9xBI8cmca2A1ZRN
         yLEmzkJci0fedYKgJorSc/uB7lKa2z1J0D2MoOFR8CxLgfTjLbRmCgyMswWYIQ45oWTv
         BGToHx0cKxHKhgtiDRFH8FPI2paI+1sti3nkDbOWjZ7FEHI5tbR8Fb7JdLuL/j9wvGjr
         ixZtmf/ElDAYhziDLXF7BoG0KYTQ3KT6OK6NoGfOobQZvnIucfqo+F3Lz2CQFf5prffq
         YV21mVYESOajULIspnUDakOF2Wn96s68zeXy18IUuSW2wPDgtkzuBTnBLKmLzYs6b+DI
         Cung==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738093447; x=1738698247;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=04aeoJjB5IJnzmcHt17DQP+KPYap4dU3QzpuAnykwIc=;
        b=swHqGfPo87GI9YpNFKy4vuO7xv90P/aq5WLaW/rfv78TDwndfxK8a2rJUy89XLVJJz
         ZympUDkLcyJdeI9BYbGhzbL8DAoBY+IBZTktPyXND+oWNd/mNe5lL4Qr+qA2APNslgul
         ozfFehXiEFr8iaGipefrXow09/YTFeWx/sWDs88Dlik5HSJ2Tooacw+ZRQa+tOfEFYVv
         mKYtweLTqB6vWOgFbzl3jYhuz+KUsP+lGZu/pfRAK3VrB/SiUn3G+7ufJyMUucsw4kz1
         7ipTbem978WMnoSSKdOTojJM2UGYouKMB3AuETmdBzdIvaz+XK0P75He9f8heMM6lfLD
         CRgw==
X-Forwarded-Encrypted: i=1; AJvYcCWnPgZ7Ks4PEfMGVyUvq6FAzvH8li9tLGxMWB0o6/nfrcRm1xZQSALVb0eKVyQPapA4CTM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwxlCCOZOpVTETKLWpcltUmxyq5UDJUrtWQosfh1x0cqRedj5Xu
	RW13SrKkJtblVvyRj4QKUeJTQylA8ukiJm4wu9VbUPENt2qkG59TZ1raw6n2Q5uY9n5p8+6p2S2
	P
X-Gm-Gg: ASbGncvH8W749nMzX8dUJ3XLv4eHNaLZKwUkhILf5qn2ywRVPuO5K8v36N+22vvZIeo
	zxe/mEZcqpuD83kEXcQ0V9EmKiRqjbXcNijggQkUzOqLX9QagAp3GY/ghejostQm/f4Pf3KAOpZ
	r2eQIBp6IOXFZeVCP4lHJ8izx7VHbMbeRGrEoK+iJuyw6rYYF92MqsiHoYlXpWUufO59bhqRgaA
	jPjge+W0nV4QdHKIfu89drZ7jpFcPRlZPAfz93hVkYVNKoTWWb53954wqt32nYPytDVRK+4DKqJ
	1hEkWr5lIiIu3Q/bUZU3SQCIOmCb6HEbq7wHb7ITrzYBk8WL5U1G5ltlFA==
X-Google-Smtp-Source: AGHT+IGLzqDcatxwCQOibIRSu3TFdbVWQAuI1VMxBkp+tnwkmB/idPX29h0clhe4fa+EBrptVCtyvw==
X-Received: by 2002:a17:903:2f84:b0:215:bc30:c952 with SMTP id d9443c01a7336-21dd7c49ad7mr4386245ad.6.1738093446728;
        Tue, 28 Jan 2025 11:44:06 -0800 (PST)
Received: from [192.168.0.4] (174-21-71-127.tukw.qwest.net. [174.21.71.127])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21da414c483sm85530395ad.159.2025.01.28.11.44.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jan 2025 11:44:06 -0800 (PST)
Message-ID: <aea2b578-78a4-4252-9cfb-c066fa2e3a80@linaro.org>
Date: Tue, 28 Jan 2025 11:44:04 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/9] accel/tcg: Simplify use of &first_cpu in
 rr_cpu_thread_fn()
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
 Yanan Wang <wangyanan55@huawei.com>, Eduardo Habkost <eduardo@habkost.net>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>, kvm@vger.kernel.org,
 Zhao Liu <zhao1.liu@intel.com>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 Igor Mammedov <imammedo@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, Peter Xu <peterx@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>
References: <20250128142152.9889-1-philmd@linaro.org>
 <20250128142152.9889-2-philmd@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250128142152.9889-2-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/28/25 06:21, Philippe Mathieu-Daudé wrote:
> Let vCPUs wait for themselves being ready first, then other ones.
> This allows the first thread to starts without the global vcpu
> queue (thus &first_cpu) being populated.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   accel/tcg/tcg-accel-ops-rr.c | 15 ++++++++-------
>   1 file changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/accel/tcg/tcg-accel-ops-rr.c b/accel/tcg/tcg-accel-ops-rr.c
> index 028b385af9a..5ad3d617bce 100644
> --- a/accel/tcg/tcg-accel-ops-rr.c
> +++ b/accel/tcg/tcg-accel-ops-rr.c
> @@ -197,20 +197,21 @@ static void *rr_cpu_thread_fn(void *arg)
>       qemu_guest_random_seed_thread_part2(cpu->random_seed);
>   
>       /* wait for initial kick-off after machine start */
> -    while (first_cpu->stopped) {
> -        qemu_cond_wait_bql(first_cpu->halt_cond);
> +    while (cpu->stopped) {
> +        CPUState *iter_cpu;
> +
> +        qemu_cond_wait_bql(cpu->halt_cond);
>   
>           /* process any pending work */
> -        CPU_FOREACH(cpu) {
> -            current_cpu = cpu;
> -            qemu_wait_io_event_common(cpu);
> +        CPU_FOREACH(iter_cpu) {
> +            current_cpu = iter_cpu;
> +            qemu_wait_io_event_common(iter_cpu);
>           }
>       }
>   
> +    g_assert(first_cpu);
>       rr_start_kick_timer();
>   
> -    cpu = first_cpu;

This final line seems to be unrelated.

I'm not saying it's wrong, but it's certainly a change in behaviour.  We no longer execute 
from first_cpu first.


r~

