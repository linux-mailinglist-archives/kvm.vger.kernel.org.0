Return-Path: <kvm+bounces-36102-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 56D76A17C8B
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 12:00:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EDD613A1E35
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 10:59:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C0911F0E4B;
	Tue, 21 Jan 2025 10:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="w4PMR5y0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E13FA1EE02F
	for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 10:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737457171; cv=none; b=eYpwaW0rafeLPcQmbLdHjDq4e+TRpFzYIrqSgKPwHXhhhGRjHu9g38EjAtuNePv9ytR4AEhb7KueU3bhQJ9srxZl6DaPrhnj4p474VVpT5BnEt5x2LmqLY+cKWEpQdRRntshNPNhhgblD1L8Mn0q0+jr46XbzzajS+jLsjHH9aI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737457171; c=relaxed/simple;
	bh=tb+w5qhSzadpqndQPCimayTbJ2V7Svm26qZtgVRpIEg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CMN7+jfWBnbtxhJfGqXdrEUHd3txiqBWYZW5xgnujEbr9XmdvjDsB1TIicRxYavuPOEwGovxiJRCa6V6WBFgye45KUbP7l8XWFnu1gNa/M5Zaj0Jorfz4POzuDmiSdCsdF6udAkrEC7ubDCAbnSrSNm5rfhimM9w0raz1QWjWHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=w4PMR5y0; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-21634338cfdso127023075ad.2
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 02:59:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1737457167; x=1738061967; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3Ll3niAYQyqhl1Gu/FURdFm4KuXNJN6QySjFaTiM0So=;
        b=w4PMR5y0CdmH8ib8MNF4Y9QOAlYqmvifOLzI6ngFYsvVrA1PscS7FJu7JA8G78sAB7
         JxCB6AVYbAumgadcybdTGS7jHD8MTs65Jz/TbVXMu0TVelB5bQYmGRaCpExPmPMEOzw6
         umTIhKw7c0nhIZbDy+FefPRniosjX3FP4elpoKqXW9a6R+gd5fuwunzTbKpzaQPLD87r
         cQf8Zm/Jt49PPGsYn+kNjkJI73PHxL0o9jrxDwjXzR+XNy/TeILUBV3x0hPoodIq2CxB
         DjslE59YlYgZisSYDckE+U8x9TQevrIvlH+r9Ry50f0yc5zTbzGrK3HdvG6OaP0Le4P5
         GZNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737457167; x=1738061967;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3Ll3niAYQyqhl1Gu/FURdFm4KuXNJN6QySjFaTiM0So=;
        b=Sg8jMU+cQjNB2+GE+xHDiIMJgZ35jjvZ8G3//39xW6C3g2MHbMIdTiUqTb0SdlX3nm
         lpvsJE3QoRTcIWgpAfTFA62rshc5Av0x9ZCtiUpC/5tIlutDdgIXX8/pqZg9Kvg1FoFu
         eJy6USMiWGjE8cOl2dXCUQ+Xgl9GrKd0l74M54HP2fohiUd8+T/W6xpfHl84+oujveWj
         ZoOvU+kYSeEk1ijDVtEcbKU3d5dT8tG8FtfbZ9RJ3emKRy5awlXEkgYXtxJ3Y/oDvqrQ
         NBRs3K/IALRgGCjIp4464pZIamNouIAvOsPezABymcvtz/NiPDXK5bawx61CvF5zYbXy
         ws3w==
X-Gm-Message-State: AOJu0Yx2Oq0+bWJqiVF7Mki2LQejmecMLbGF9QtIclqCil9TnKlxZeQr
	/0VbaNl7oz5APy7tiTqFX3XNApDNhnVwJGvT2p1yR9wlcLiLWD/sMoP7vfdorhQ=
X-Gm-Gg: ASbGncv8knHaPUvdIag7QUDqvgaST4ww+p46L5XW31Ogzgw9fl6mlzQCu6PJHEFz73H
	8Y2H9nUihljmveTbQfbizOMbOnRP2G97Degmzo1QnSZYbUyvpLdVP2Hh9olnvrlCKGBhado1MQI
	5bz1c1Ua9ikrOPmLYjtNwGQUhaW1JIjAr/D4s5UYP4rLfZ9HLwwN396w6fXsSCbq6ZvY3CXSR/V
	Q7PT8VgSIu+NreiLPd+qmM5u9sTY+ilv/GUKFM0ZQSuDMI9oKN5aT9zvWePMt8xYQd6aBR8UYDO
	4wLJBlYPrtWPENPobkQX1Q+Yg+1L9Z2K1QGTXpE=
X-Google-Smtp-Source: AGHT+IGaWUNfLQttDPyCJbytal14ydEn804b4fTgQOfi3CA2cpZq7LiiHXK4re9VMDLeJz//iatDWA==
X-Received: by 2002:a05:6a21:999e:b0:1db:e0d7:675c with SMTP id adf61e73a8af0-1eb2148cc78mr27945908637.13.1737457167087;
        Tue, 21 Jan 2025 02:59:27 -0800 (PST)
Received: from ?IPV6:2a01:e0a:e17:9700:16d2:7456:6634:9626? ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-a9bcc3234c4sm8445464a12.19.2025.01.21.02.59.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2025 02:59:26 -0800 (PST)
Message-ID: <788fe888-c07e-4d2f-9e7b-916ec9e509e9@rivosinc.com>
Date: Tue, 21 Jan 2025 11:59:16 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH 2/2] riscv: Add tests for SBI FWFT
 extension
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 Andrew Jones <ajones@ventanamicro.com>, Anup Patel
 <apatel@ventanamicro.com>, Atish Patra <atishp@rivosinc.com>
References: <20250106155321.1109586-1-cleger@rivosinc.com>
 <20250106155321.1109586-3-cleger@rivosinc.com>
 <20250115-0e896f7efb3e6bc2af91afb4@orel>
Content-Language: en-US
From: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
In-Reply-To: <20250115-0e896f7efb3e6bc2af91afb4@orel>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 15/01/2025 13:58, Andrew Jones wrote:
> On Mon, Jan 06, 2025 at 04:53:20PM +0100, Clément Léger wrote:
>> This commit add tests for a the FWFT SBI extension. Currently, only
> 
> s/This commit//
> 
>> the reserved range as well as the misaligned exception delegation.
>>
>> Signed-off-by: Clément Léger <cleger@rivosinc.com>
>> ---
>>  riscv/Makefile      |   2 +-
>>  lib/riscv/asm/sbi.h |  31 +++++++++
>>  riscv/sbi-fwft.c    | 153 ++++++++++++++++++++++++++++++++++++++++++++
>>  riscv/sbi.c         |   3 +
>>  4 files changed, 188 insertions(+), 1 deletion(-)
>>  create mode 100644 riscv/sbi-fwft.c
>>
>> diff --git a/riscv/Makefile b/riscv/Makefile
>> index 5b5e157c..52718f3f 100644
>> --- a/riscv/Makefile
>> +++ b/riscv/Makefile
>> @@ -17,7 +17,7 @@ tests += $(TEST_DIR)/sieve.$(exe)
>>  
>>  all: $(tests)
>>  
>> -$(TEST_DIR)/sbi-deps = $(TEST_DIR)/sbi-asm.o
>> +$(TEST_DIR)/sbi-deps = $(TEST_DIR)/sbi-asm.o $(TEST_DIR)/sbi-fwft.o
>>  
>>  # When built for EFI sieve needs extra memory, run with e.g. '-m 256' on QEMU
>>  $(TEST_DIR)/sieve.$(exe): AUXFLAGS = 0x1
>> diff --git a/lib/riscv/asm/sbi.h b/lib/riscv/asm/sbi.h
>> index 98a9b097..27e6fcdb 100644
>> --- a/lib/riscv/asm/sbi.h
>> +++ b/lib/riscv/asm/sbi.h
>> @@ -11,6 +11,9 @@
>>  #define SBI_ERR_ALREADY_AVAILABLE	-6
>>  #define SBI_ERR_ALREADY_STARTED		-7
>>  #define SBI_ERR_ALREADY_STOPPED		-8
>> +#define SBI_ERR_NO_SHMEM		-9
>> +#define SBI_ERR_INVALID_STATE		-10
>> +#define SBI_ERR_BAD_RANGE		-11
> 
> Need SBI_ERR_DENIED_LOCKED (and TIMEOUT and IO) too

Indeed, i'll add that.

> 
>>  
>>  #ifndef __ASSEMBLY__
>>  #include <cpumask.h>
>> @@ -23,6 +26,7 @@ enum sbi_ext_id {
>>  	SBI_EXT_SRST = 0x53525354,
>>  	SBI_EXT_DBCN = 0x4442434E,
>>  	SBI_EXT_SUSP = 0x53555350,
>> +	SBI_EXT_FWFT = 0x46574654,
>>  };
>>  
>>  enum sbi_ext_base_fid {
>> @@ -71,6 +75,33 @@ enum sbi_ext_dbcn_fid {
>>  	SBI_EXT_DBCN_CONSOLE_WRITE_BYTE,
>>  };
>>  
>> +/* SBI function IDs for FW feature extension */
>> +#define SBI_EXT_FWFT_SET		0x0
>> +#define SBI_EXT_FWFT_GET		0x1
> 
> Use a _fid enum like the other extensions.
> 
>> +
>> +enum sbi_fwft_feature_t {
> 
> Use defines for the following, like SSE does for its ranges.
> 
>> +	SBI_FWFT_MISALIGNED_EXC_DELEG		= 0x0,
>> +	SBI_FWFT_LANDING_PAD			= 0x1,
>> +	SBI_FWFT_SHADOW_STACK			= 0x2,
>> +	SBI_FWFT_DOUBLE_TRAP			= 0x3,
>> +	SBI_FWFT_PTE_AD_HARDWARE_UPDATE		= 0x4,
> 
> SBI_FWFT_PTE_AD_HW_UPDATING
> 
>> +	SBI_FWFT_POINTER_MASKING_PMLEN		= 0x5,
>> +	SBI_FWFT_LOCAL_RESERVED_START		= 0x6,
>> +	SBI_FWFT_LOCAL_RESERVED_END		= 0x3fffffff,
> 
> Do we need the reserved start/end? SSE doesn't define its reserved
> ranges.

As seen below, it is used for reserved range testing. You are right
about SSE, that would be nice to test that as well.

> 
>> +	SBI_FWFT_LOCAL_PLATFORM_START		= 0x40000000,
>> +	SBI_FWFT_LOCAL_PLATFORM_END		= 0x7fffffff,
>> +
>> +	SBI_FWFT_GLOBAL_RESERVED_START		= 0x80000000,
>> +	SBI_FWFT_GLOBAL_RESERVED_END		= 0xbfffffff,
> 
> Same reserved range question.
> 
>> +	SBI_FWFT_GLOBAL_PLATFORM_START		= 0xc0000000,
>> +	SBI_FWFT_GLOBAL_PLATFORM_END		= 0xffffffff,
>> +};
>> +
>> +#define SBI_FWFT_PLATFORM_FEATURE_BIT		(1 << 30)
>> +#define SBI_FWFT_GLOBAL_FEATURE_BIT		(1 << 31)
>> +
>> +#define SBI_FWFT_SET_FLAG_LOCK			(1 << 0)
> 
> BIT() for the above defines
> 
>> +
>>  struct sbiret {
>>  	long error;
>>  	long value;
>> diff --git a/riscv/sbi-fwft.c b/riscv/sbi-fwft.c
>> new file mode 100644
>> index 00000000..8a7f2070
>> --- /dev/null
>> +++ b/riscv/sbi-fwft.c
>> @@ -0,0 +1,153 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * SBI verification
>> + *
>> + * Copyright (C) 2024, Rivos Inc., Clément Léger <cleger@rivosinc.com>
>> + */
>> +#include <libcflat.h>
>> +#include <stdlib.h>
>> +
>> +#include <asm/csr.h>
>> +#include <asm/processor.h>
>> +#include <asm/ptrace.h>
>> +#include <asm/sbi.h>
>> +
>> +void check_fwft(void);
>> +
>> +static int fwft_set(unsigned long feature_id, unsigned long value,
> 
> returning an int is truncating sbiret.error
> 
> s/unsigned long feature_id/uint32_t feature/
> 
>> +		       unsigned long flags)
>> +{
>> +	struct sbiret ret = sbi_ecall(SBI_EXT_FWFT, SBI_EXT_FWFT_SET,
>> +				      feature_id, value, flags, 0, 0, 0);
>> +
>> +	return ret.error;
>> +}
> 
> Probably need a fwft_set_raw() as well which takes an unsigned long for
> feature in order to test feature IDs that set bits >= 32 and returns
> an sbiret allowing sbiret.value to be checked.
> 
>> +
>> +static int fwft_get(unsigned long feature_id, unsigned long *value)
> 
> returning an int is truncating sbiret.error
> 
> s/unsigned long feature_id/uint32_t feature/
> 
>> +{
>> +	struct sbiret ret = sbi_ecall(SBI_EXT_FWFT, SBI_EXT_FWFT_GET,
>> +				      feature_id, 0, 0, 0, 0, 0);
>> +
>> +	*value = ret.value;
>> +
>> +	return ret.error;
> 
> Why not just return sbiret to return both value and error?
> 
> As a separate patch we should update struct sbiret to match the latest
> spec which now has a union in it.
> 
> Same comment about needing a _raw version too.

Acked, I actually modified bith get/set to return an sbiret directly,
that's easier to handle a unique return type in tests.

> 
>> +}
>> +
>> +static void fwft_check_reserved(unsigned long id)
>> +{
>> +	int ret;
>> +	bool pass = true;
>> +	unsigned long value;
>> +
>> +	ret = fwft_get(id, &value);
>> +	if (ret != SBI_ERR_DENIED)
>> +		pass = false;
>> +
>> +	ret = fwft_set(id, 1, 0);
>> +	if (ret != SBI_ERR_DENIED)
>> +		pass = false;
>> +
>> +	report(pass, "get/set reserved feature 0x%lx error == SBI_ERR_DENIED", id);
> 
> The get and set should be split into two tests
> 
>  struct sbiret ret;
>  ret = fwft_get(id);
>  report(ret.error == SBI_ERR_DENIED, ...);
>  ret = fwft_set(id, 1, 0);
>  report(ret.error == SBI_ERR_DENIED, ...);
> 
>> +}
>> +
>> +static void fwft_check_denied(void)
>> +{
>> +	fwft_check_reserved(SBI_FWFT_LOCAL_RESERVED_START);
>> +	fwft_check_reserved(SBI_FWFT_LOCAL_RESERVED_END);
>> +	fwft_check_reserved(SBI_FWFT_GLOBAL_RESERVED_START);
>> +	fwft_check_reserved(SBI_FWFT_GLOBAL_RESERVED_END);
> 
> I see why we have the reserved ranges defined now. Shouldn't we also have
> tests like these for SSE, which means we should define the reserved ranges
> for it too?

Yes, that should be tested in SSE as well.

> 
>> +}
>> +
>> +static bool misaligned_handled;
>> +
>> +static void misaligned_handler(struct pt_regs *regs)
>> +{
>> +	misaligned_handled = true;
>> +	regs->epc += 4;
>> +}
>> +
>> +static void fwft_check_misaligned(void)
>> +{
>> +	int ret;
>> +	unsigned long value;
>> +
>> +	report_prefix_push("misaligned_deleg");
> 
> "misaligned_exc_deleg"
> 
>> +
>> +	ret = fwft_get(SBI_FWFT_MISALIGNED_EXC_DELEG, &value);
>> +	if (ret == SBI_ERR_NOT_SUPPORTED) {
>> +		report_skip("SBI_FWFT_MISALIGNED_EXC_DELEG is not supported");
>> +		return;
>> +	}
>> +	report(!ret, "Get misaligned deleg feature no error");
> 
> Should output the error too
> 
>> +	if (ret)
>> +		return;
>> +
>> +	ret = fwft_set(SBI_FWFT_MISALIGNED_EXC_DELEG, 2, 0);
>> +	report(ret == SBI_ERR_INVALID_PARAM, "Set misaligned deleg feature invalid value error");
>> +	ret = fwft_set(SBI_FWFT_MISALIGNED_EXC_DELEG, 0xFFFFFFFF, 0);
>> +	report(ret == SBI_ERR_INVALID_PARAM, "Set misaligned deleg feature invalid value error");
> 
> Something like
> 
>      if (__riscv_xlen > 32) {
>         ret = fwft_set(SBI_FWFT_MISALIGNED_EXC_DELEG, (1ul << 32), 0);
>         report(ret == SBI_ERR_INVALID_PARAM
>      }
> 
> would be a good test too (and also for the flags parameter)
> 

Acked I'll add that.

>> +
>> +	/* Set to 0 and check after with get */
>> +	ret = fwft_set(SBI_FWFT_MISALIGNED_EXC_DELEG, 0, 0);
>> +	report(!ret, "Set misaligned deleg feature value no error");
>> +	ret = fwft_get(SBI_FWFT_MISALIGNED_EXC_DELEG, &value);
>> +	if (ret)
>> +		report_fail("Get misaligned deleg feature after set");
>> +	else
>> +		report(value == 0, "Set misaligned deleg feature value 0");
>> +
>> +	/* Set to 1 and check after with get */
>> +	ret = fwft_set(SBI_FWFT_MISALIGNED_EXC_DELEG, 1, 0);
>> +	report(!ret, "Set misaligned deleg feature value no error");
>> +	ret = fwft_get(SBI_FWFT_MISALIGNED_EXC_DELEG, &value);
>> +	if (ret)
>> +		report_fail("Get misaligned deleg feature after set");
>> +	else
>> +		report(value == 1, "Set misaligned deleg feature value 1");
>> +
>> +	install_exception_handler(EXC_LOAD_MISALIGNED, misaligned_handler);
>> +
>> +	asm volatile (
>> +		".option norvc\n"
> 
> We also need push/pop otherwise from here on out we stop using compression
> instructions.

Yeah, nice catch, I'll add push/pop.

> 
>> +		"lw %[val], 1(%[val_addr])"
>> +		: [val] "+r" (value)
>> +		: [val_addr] "r" (&value)
>> +		: "memory");
>> +
>> +	if (!misaligned_handled)
>> +		report_skip("Verify misaligned load exception trap in supervisor");
> 
> Why is this report_skip()? Shouldn't we just do
> 
>   report(misaligned_handled, ...)

Some platforms might actually allow you to delegate the misaligned
access trap but handle scalar misaligned accesses in hardware but trap
on vector misaligned. To be "more" complete, I should add vector testing
but I haven't had time to check vector instructions.

> 
>> +	else
>> +		report_pass("Verify misaligned load exception trap in supervisor");
>> +
>> +	install_exception_handler(EXC_LOAD_MISALIGNED, NULL);
>> +
>> +	report_prefix_pop();
>> +}
>> +
>> +void check_fwft(void)
>> +{
>> +	struct sbiret ret;
>> +
>> +	report_prefix_push("fwft");
>> +
>> +	if (!sbi_probe(SBI_EXT_FWFT)) {
>> +		report_skip("FWFT extension not available");
>> +		report_prefix_pop();
>> +		return;
>> +	}
>> +
>> +	ret = sbi_ecall(SBI_EXT_BASE, SBI_EXT_BASE_PROBE_EXT, SBI_EXT_FWFT, 0, 0, 0, 0, 0);
>> +	report(!ret.error, "FWFT extension probing no error");
>> +	if (ret.error)
>> +		goto done;
>> +
>> +	if (ret.value == 0) {
>> +		report_skip("FWFT extension is not present");
>> +		goto done;
>> +	}
> 
> The above "raw" probing looks like it should have been removed when
> the sbi_probe() call was added.

Oups yes, that should have been removed.

> 
>> +
>> +	fwft_check_denied();
>> +	fwft_check_misaligned();
>> +done:
>> +	report_prefix_pop();
>> +}
>> diff --git a/riscv/sbi.c b/riscv/sbi.c
>> index 6f4ddaf1..8600e38e 100644
>> --- a/riscv/sbi.c
>> +++ b/riscv/sbi.c
>> @@ -32,6 +32,8 @@
>>  
>>  #define	HIGH_ADDR_BOUNDARY	((phys_addr_t)1 << 32)
>>  
>> +void check_fwft(void);
>> +
>>  static long __labs(long a)
>>  {
>>  	return __builtin_labs(a);
>> @@ -1451,6 +1453,7 @@ int main(int argc, char **argv)
>>  	check_hsm();
>>  	check_dbcn();
>>  	check_susp();
>> +	check_fwft();
>>  
>>  	return report_summary();
>>  }
>> -- 
>> 2.47.1
>>
> 
> Nice start to the FWFT tests. After this is merged I'll add tests for
> PTE_AD_HW_UPDATING. We also should get LOCK and local/global tests in
> sooner than later.

Acked, I'll add LOCK testing for misaligned as well.

Thanks for the review,

Clément

> 
> Thanks,
> drew


