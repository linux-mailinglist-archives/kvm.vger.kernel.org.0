Return-Path: <kvm+bounces-41543-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 12B4DA6A0ED
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 09:09:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 273997A7321
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 08:07:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB89C20A5D8;
	Thu, 20 Mar 2025 08:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="AHaFe53R"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B22115A8
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 08:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742458132; cv=none; b=jGBTNJ7RCWYg0ZdlATgR00h1PcAq3JNqY50DZZ1t5cQotsBJy0eSxyocv0rmKhicc8Kh3kGrp7x9znlwilR77rXSW4YHkvQISMqDqVCfCeL2RNNnV+yeIFy35IwsZ6v+7PH8IhhaOSFbP6gOQRtaLyIvTd+ImDMr8/XePe8SWI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742458132; c=relaxed/simple;
	bh=HE6g36GZYbyib00d8iAd8ex8GWayGBMH+NEPDpc1aLM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fOLbxkDJnapA9RcN+A8Q7AbFNAJkIofPILwBZMrVsQayaqFgZtOB3NXts8QfeDIqORx7R29PsIb6DVDpKULYGUBvxNn/Vbhm8jE1W2vT1aTNq3jMI20apZox5RUJXa9cSkyWOeR1Z8rsw4ckm+wJkj0VrmtT26l28pf7SCbUMaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=AHaFe53R; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-38a25d4b9d4so198532f8f.0
        for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 01:08:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1742458127; x=1743062927; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SGAKgWIQzN7mhK8heXs4xRroEsHz6MkpwwVFPikYiAg=;
        b=AHaFe53RxL+QbJTLlKIV2dcZVBgt8T5mGz5KfX71daoJrqDtjrWB7RST3GY+f6InTs
         sVd6B0C+jKIT/YTOV/kthY3I80NgUgjZw0IR/eIaj+HLHzAqobCquZPr6zhqdmjTDE3m
         Z1jJHkp45hvSi82iIPAKsE+K3OY4WtTSLHZw3ilFkUgDbV4hl94VEWhVVP6h3ioRf25V
         AEHo4dt4aadHP2/4/7yywBjxyVYD+rPDr5/dqWu5xw/30GVyUFL0s9ElhH22kKZ5tiA9
         l0oTKBFWkjlBnExwqeFTLdMGm6GO0ifDtTyML/MtQJtZC8RwxnfScxE2rgoeYrcsPEg2
         Fh1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742458127; x=1743062927;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SGAKgWIQzN7mhK8heXs4xRroEsHz6MkpwwVFPikYiAg=;
        b=jlGE7O4kg/RxUzx2WbzB/4JfOJy66MEJ/ae398lgLqVj89CH2hahw38Z0tp4flDgtg
         gC8y7IE3f/9HlNQD8xuMWhZqA7KEw+HgH+WlRAIgvWEA1eEYJVSq1eA/5bne1vL5ZE0k
         9n+o0aOA8BKn76H6ksqZEdcQFwLw4XdtRmJL6c82fpCYGLtQOeoX3QV1g1sl5Zci5nTU
         TOGVuVZTrsM1qY5aQIvWlao+9/tr4RfDL2zRVUeaqFGc5o2FJRsrw8Cw2B6jXv+3m6P4
         6tHXD0KBTLmQ5Jm3IBnDkO9JS5n0+MHJRcRp2vHPLeb2sOxm/3qRuyJXBotyjJlUSw8F
         tbRQ==
X-Gm-Message-State: AOJu0YwmN1uBz8gWHXdDV7nNkSJK+JevqHVhBMryc5QXU3SlnIMmfIPX
	PJaakbsNUEa13YB3NINLJ/sINQdjeC3K07msTwC/9SkvztDCAdts0v+vijLhMw6hRf7P9Z1eIzt
	fTDs=
X-Gm-Gg: ASbGncvLWzmbSdsnIPHBLKHIJKiAI+B7Vl5TZBIfJmHnHpe2sHXw9xpdETjiunUzOIH
	MWi7+oWYafkP+fPigDD0Ska235JoLzw9tP9/elAyXJZYnPHV5vZy23dsuGkqD0yPkPDx2sIhrDm
	t62yryQURukKVkPMeeBTvdYYk/z39XpAEGrWSGsbtIL9+X5z3gUKCuVzIdhHLUXQXHkFaMJtctp
	J4Gp3CNxSiMT933TSfTgLrb36NbKNa2YuWSI9nubFsa60FPOlubl0mjugUgxrWxodyforgRVGTU
	gXfO9Gmnm9bvTeD1jvOdZyx/bb8keuq6LYs/Bfoc/bMjIxb39FOJd3HDZcbJm9Is68zXYb/aYsP
	cfGM/jzccnzhs5JrWhOYPIeoP
X-Google-Smtp-Source: AGHT+IFO2kWZwodNF9+UTjUaxD+kEKmEFL7dIK7jDW2tYf6wT2aK+g6kAPYQAXxXqaVOblJ04xdL4Q==
X-Received: by 2002:a5d:59af:0:b0:391:4873:7943 with SMTP id ffacd0b85a97d-399739de3ecmr5477298f8f.32.1742458127332;
        Thu, 20 Mar 2025 01:08:47 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:e17:9700:16d2:7456:6634:9626? ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-395cbbc88f2sm23094574f8f.101.2025.03.20.01.08.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Mar 2025 01:08:46 -0700 (PDT)
Message-ID: <56d35d26-05f7-4c5a-a987-a5cafb39a8ef@rivosinc.com>
Date: Thu, 20 Mar 2025 09:08:45 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v11 4/8] lib: riscv: Add functions for
 version checking
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 Andrew Jones <ajones@ventanamicro.com>, Anup Patel
 <apatel@ventanamicro.com>, Atish Patra <atishp@rivosinc.com>
References: <20250317164655.1120015-1-cleger@rivosinc.com>
 <20250317164655.1120015-5-cleger@rivosinc.com>
 <20250319-7ce04ed29661af987303b215@orel>
Content-Language: en-US
From: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
In-Reply-To: <20250319-7ce04ed29661af987303b215@orel>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 19/03/2025 18:31, Andrew Jones wrote:
> On Mon, Mar 17, 2025 at 05:46:49PM +0100, Clément Léger wrote:
>> Version checking was done using some custom hardcoded values, backport a
>> few SBI function and defines from Linux to do that cleanly.
>>
>> Signed-off-by: Clément Léger <cleger@rivosinc.com>
>> ---
>>  lib/riscv/asm/sbi.h | 15 +++++++++++++++
>>  lib/riscv/sbi.c     |  9 +++++++--
>>  2 files changed, 22 insertions(+), 2 deletions(-)
>>
>> diff --git a/lib/riscv/asm/sbi.h b/lib/riscv/asm/sbi.h
>> index 2f4d91ef..ee9d6e50 100644
>> --- a/lib/riscv/asm/sbi.h
>> +++ b/lib/riscv/asm/sbi.h
>> @@ -18,6 +18,13 @@
>>  #define SBI_ERR_IO			-13
>>  #define SBI_ERR_DENIED_LOCKED		-14
>>  
>> +/* SBI spec version fields */
>> +#define SBI_SPEC_VERSION_MAJOR_SHIFT	24
>> +#define SBI_SPEC_VERSION_MAJOR_MASK	0x7f
>> +#define SBI_SPEC_VERSION_MINOR_MASK	0xffffff
>> +#define SBI_SPEC_VERSION_MASK		((SBI_SPEC_VERSION_MAJOR_MASK << SBI_SPEC_VERSION_MAJOR_SHIFT) | \
>> +					SBI_SPEC_VERSION_MINOR_MASK)
>                                        ^ needs one more space
>> +
>>  #ifndef __ASSEMBLER__
>>  #include <cpumask.h>
>>  
>> @@ -110,6 +117,13 @@ struct sbiret {
>>  	long value;
>>  };
>>  
>> +/* Make SBI version */
> 
> Unnecessary comment, it's the same as the function name.

Yeah that's a copy/paste from Linux, didn't cleanup.

> 
>> +static inline unsigned long sbi_mk_version(unsigned long major, unsigned long minor)
>> +{
>> +	return ((major & SBI_SPEC_VERSION_MAJOR_MASK) << SBI_SPEC_VERSION_MAJOR_SHIFT)
>> +		| (minor & SBI_SPEC_VERSION_MINOR_MASK);
>> +}
>> +
>>  struct sbiret sbi_ecall(int ext, int fid, unsigned long arg0,
>>  			unsigned long arg1, unsigned long arg2,
>>  			unsigned long arg3, unsigned long arg4,
>> @@ -124,6 +138,7 @@ struct sbiret sbi_send_ipi_cpu(int cpu);
>>  struct sbiret sbi_send_ipi_cpumask(const cpumask_t *mask);
>>  struct sbiret sbi_send_ipi_broadcast(void);
>>  struct sbiret sbi_set_timer(unsigned long stime_value);
>> +struct sbiret sbi_get_spec_version(void);
>>  long sbi_probe(int ext);
>>  
>>  #endif /* !__ASSEMBLER__ */
>> diff --git a/lib/riscv/sbi.c b/lib/riscv/sbi.c
>> index 02dd338c..9d4eb541 100644
>> --- a/lib/riscv/sbi.c
>> +++ b/lib/riscv/sbi.c
>> @@ -107,12 +107,17 @@ struct sbiret sbi_set_timer(unsigned long stime_value)
>>  	return sbi_ecall(SBI_EXT_TIME, SBI_EXT_TIME_SET_TIMER, stime_value, 0, 0, 0, 0, 0);
>>  }
>>  
>> +struct sbiret sbi_get_spec_version(void)
>> +{
>> +	return sbi_ecall(SBI_EXT_BASE, SBI_EXT_BASE_GET_SPEC_VERSION, 0, 0, 0, 0, 0, 0);
>> +}
>> +
>>  long sbi_probe(int ext)
>>  {
>>  	struct sbiret ret;
>>  
>> -	ret = sbi_ecall(SBI_EXT_BASE, SBI_EXT_BASE_GET_SPEC_VERSION, 0, 0, 0, 0, 0, 0);
>> -	assert(!ret.error && (ret.value & 0x7ffffffful) >= 2);
>> +	ret = sbi_get_spec_version();
>> +	assert(!ret.error && (ret.value & SBI_SPEC_VERSION_MASK) >= sbi_mk_version(0, 2));
>>  
>>  	ret = sbi_ecall(SBI_EXT_BASE, SBI_EXT_BASE_PROBE_EXT, ext, 0, 0, 0, 0, 0);
>>  	assert(!ret.error);
>> -- 
>> 2.47.2
>>
> 
> I fixed those two things up while applying.

Thanks Andrew,

Clément

> 
> Thanks,
> drew


