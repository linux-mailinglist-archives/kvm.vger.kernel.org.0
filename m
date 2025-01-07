Return-Path: <kvm+bounces-34697-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 47D3BA04859
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 18:34:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 27EBC16679E
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 17:34:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A16518C937;
	Tue,  7 Jan 2025 17:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="CrTIJKr1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F14017B50A
	for <kvm@vger.kernel.org>; Tue,  7 Jan 2025 17:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736271245; cv=none; b=YvQKWukNeoIAy6hN6QdOsksiw0McprM03r9DSiajLAnCo1jCjKhVF505kmjvU7L+pl+ANM4mGKdo2p+xOQmvFu3d/e8LM2IX57DQPmpOHMoKX4GSfinCzCWsSvLhS2y0tvspNJwrCPk08FKNX4QDRKMRx1hKCkHV8IWRUu6y33o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736271245; c=relaxed/simple;
	bh=jYD/h+7/PVZpFneHxt5z3FjHMvmjPEaWESJq2DdJ6jk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RF85p8jHFyl3LWV8jR5P9pS3laApNv+QBBbUTokIKqFR8bElemAni4aTfxxbKU8jdeuU0Hra8GgKsua19lOY7H3W8BA9u5ez6NDCWCSHYHa1eOetmH9Y4lM0QVYHVx8gh+7+djktuWZX3SYqubLm64cQ/eXOfuPBOeO/8bxklTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=CrTIJKr1; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-2ee397a82f6so23548983a91.2
        for <kvm@vger.kernel.org>; Tue, 07 Jan 2025 09:34:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1736271241; x=1736876041; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8chiWn8PHgcoyJVQOgate9PsARC7jUqDb+rR2Mrr+VA=;
        b=CrTIJKr1y6sXduaPThaMHtVhGG/oqVRy+ZWsLFBjdTHB5ymHWwvkI7bbwTHarL3ak+
         vrdBxwCkCazGDXGe4gIlevCEuJmPi1OTAV+usFS5/bsZmNvgeVHYPDkuhRBrLWcx+igO
         KeACPLergJ9yb4IyY+RGyBlaJJNx4YYM8nQIALT8ug51bJyMKmrEdqGg9MF5bCUuVpjM
         lbYjBhgfjT32Bfu0J5E96pS9Ckpoyr+QQEKxs7M+O0ve6pX7jTmNc1A/ftw7/oX8kQiV
         4VWhzESW3L5hHQHUrxUo4eQALsmy/x5LzsfiWbQQWy8580H0A3q/gy4r99qRIIC57Gfa
         Ejow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736271241; x=1736876041;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8chiWn8PHgcoyJVQOgate9PsARC7jUqDb+rR2Mrr+VA=;
        b=K4S++KNZspZZXWcRrWy2OLxElpg/8uNY+Qy080Vm1kCf8Vf9SO2OGVernw0JO/bnvg
         3D4y77cqWOrM+7vpfPod5F43/MRDZPZLbexjIWlYmvk6Oo3Bq+rpCarFc/knjFa7NiAo
         pZv39IEvq1j/GyokMXf/FGJl9+YgQnE/V3DeCb8G5hwwpScTvt71xgnRH+Y2xgMoFGbo
         nv0xIgx4uxv5HKvSrGFLWhYfv07GjRGI7gstcd2/jjBN1TARYqnI46zqQVa5RUnpaezj
         myGXeoDI2BD1cWgf0FzwTl0+UeuKoZrWCzeWJ0MtlWkVW6UvFra7iHdKDlRBHV9O29VX
         vCjQ==
X-Gm-Message-State: AOJu0Yyfij77tc1GVUzN45EPab8r07NrLWHZvlBAkEyth/Ne8QJnu/17
	e8zqCOB4KIMaoQ9UNeAh2dp3MinZcGjZAsMz45qAkjaTJGHaqkJk6N/OGGbVgyc=
X-Gm-Gg: ASbGnctlq/v7MQiI91dv8yD9Ksfa8zIY1joKBO949Ovxk6/rRpn69vUHCY4KSI2z/8U
	Ru4eKtRY/Mehp9tkWDGyLqXMhR2sjBYC4q65hillSdeg2ikbCfjBzRAdEbestHP4a4jndZOzZ/i
	gHVPqUVF+ahbqz6rA/2ukJ7L9Q7LqCtP+3wMR0eteNw2FzP92ExsBtapvpdFNJQsNuBJytJVvyE
	qbCfcSZgIkb6qhuFUMYqUy1ou+1YnXlJfACqo36suZeGwqMuMf4RSqWvzNTsdPQYw6hBNSeRlzM
	bZbqKz+uUKVQhMbcVDuMjl3hxw==
X-Google-Smtp-Source: AGHT+IGpFaqKxwP+asxFbBD1Yj7PsO+fRwK1mkugnP7ZKu1AjJHchKThe8xppLAgUTKIrZ/vqEzIiA==
X-Received: by 2002:a17:90b:2c84:b0:2ea:a25d:3baa with SMTP id 98e67ed59e1d1-2f452dfa40bmr97211846a91.5.1736271240898;
        Tue, 07 Jan 2025 09:34:00 -0800 (PST)
Received: from ?IPV6:2a01:e0a:e17:9700:16d2:7456:6634:9626? ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f4478ac7dbsm36191474a91.50.2025.01.07.09.33.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jan 2025 09:34:00 -0800 (PST)
Message-ID: <25e8e0c6-c9d4-4c98-ae02-284db0175d82@rivosinc.com>
Date: Tue, 7 Jan 2025 18:33:45 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v4 2/5] riscv: use asm-offsets to generate
 SBI_EXT_HSM values
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 Andrew Jones <ajones@ventanamicro.com>, Anup Patel
 <apatel@ventanamicro.com>, Atish Patra <atishp@rivosinc.com>
References: <20241125162200.1630845-1-cleger@rivosinc.com>
 <20241125162200.1630845-3-cleger@rivosinc.com>
 <20250107-feb21efc4c0815bd3ed7b173@orel>
Content-Language: en-US
From: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
In-Reply-To: <20250107-feb21efc4c0815bd3ed7b173@orel>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 07/01/2025 18:27, Andrew Jones wrote:
> On Mon, Nov 25, 2024 at 05:21:51PM +0100, Clément Léger wrote:
>> Replace hardcoded values with generated ones using asm-offset. This
>> allows to directly use ASM_SBI_EXT_HSM and ASM_SBI_EXT_HSM_START in
> 
> ASM_SBI_EXT_HSM_HART_STOP
> 
>> assembly.
>>
>> Signed-off-by: Clément Léger <cleger@rivosinc.com>
>> ---
>>  riscv/Makefile           |  2 +-
>>  riscv/sbi-asm.S          |  6 ++++--
>>  riscv/asm-offsets-test.c | 12 ++++++++++++
>>  riscv/.gitignore         |  1 +
>>  4 files changed, 18 insertions(+), 3 deletions(-)
>>  create mode 100644 riscv/asm-offsets-test.c
>>  create mode 100644 riscv/.gitignore
>>
>> diff --git a/riscv/Makefile b/riscv/Makefile
>> index 28b04156..a01ff8a3 100644
>> --- a/riscv/Makefile
>> +++ b/riscv/Makefile
>> @@ -86,7 +86,7 @@ CFLAGS += -ffreestanding
>>  CFLAGS += -O2
>>  CFLAGS += -I $(SRCDIR)/lib -I $(SRCDIR)/lib/libfdt -I lib -I $(SRCDIR)/riscv
>>  
>> -asm-offsets = lib/riscv/asm-offsets.h
>> +asm-offsets = lib/riscv/asm-offsets.h riscv/asm-offsets-test.h
>>  include $(SRCDIR)/scripts/asm-offsets.mak
>>  
>>  %.aux.o: $(SRCDIR)/lib/auxinfo.c
>> diff --git a/riscv/sbi-asm.S b/riscv/sbi-asm.S
>> index 923c2cec..193d9606 100644
>> --- a/riscv/sbi-asm.S
>> +++ b/riscv/sbi-asm.S
>> @@ -7,6 +7,8 @@
>>  #define __ASSEMBLY__
>>  #include <asm/asm.h>
>>  #include <asm/csr.h>
>> +#include <asm/asm-offsets.h>
>> +#include <generated/asm-offsets-test.h>
>>  
>>  #include "sbi-tests.h"
>>  
>> @@ -58,8 +60,8 @@ sbi_hsm_check:
>>  7:	lb	t0, 0(t1)
>>  	pause
>>  	beqz	t0, 7b
>> -	li	a7, 0x48534d	/* SBI_EXT_HSM */
>> -	li	a6, 1		/* SBI_EXT_HSM_HART_STOP */
>> +	li	a7, ASM_SBI_EXT_HSM
>> +	li	a6, ASM_SBI_EXT_HSM_HART_STOP
>>  	ecall
>>  8:	pause
>>  	j	8b
>> diff --git a/riscv/asm-offsets-test.c b/riscv/asm-offsets-test.c
>> new file mode 100644
>> index 00000000..116fe497
>> --- /dev/null
>> +++ b/riscv/asm-offsets-test.c
>> @@ -0,0 +1,12 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +#include <kbuild.h>
>> +#include <asm/sbi.h>
>> +#include "sbi-tests.h"
>> +
>> +int main(void)
>> +{
>> +	DEFINE(ASM_SBI_EXT_HSM, SBI_EXT_HSM);
>> +	DEFINE(ASM_SBI_EXT_HSM_HART_STOP, SBI_EXT_HSM_HART_STOP);
>> +
>> +	return 0;
>> +}
>> diff --git a/riscv/.gitignore b/riscv/.gitignore
>> new file mode 100644
>> index 00000000..91713581
>> --- /dev/null
>> +++ b/riscv/.gitignore
>> @@ -0,0 +1 @@
>> +/asm-offsets-test.[hs]
>> -- 
>> 2.45.2
>>
> 
> I like this and I should probably rework stuff to replace all the _IDX
> macros in riscv/sbi-tests.h. I think we should call it sbi-asm-offsets.c,
> though, and then change the Makefile and .gitignore changes to refer to
> riscv/*-asm-offsets.h. That would allow us to keep test-specific asm-
> offsets separate and avoid the name "asm-offsets-test" or similar which,
> to me, conveys it's for testing asm-offsets.

Yes indeed, that will be clearer. I'll take care of updating the file
name as well as the gitignore in this series.

Thanks,

Clément

> 
> Thanks,
> drew


