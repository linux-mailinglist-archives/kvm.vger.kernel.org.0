Return-Path: <kvm+bounces-36556-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DCDAA1BAD3
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 17:46:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DB17218860D4
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 16:46:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88AFD15CD79;
	Fri, 24 Jan 2025 16:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="qx7zpzzN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51156E552
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 16:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737737162; cv=none; b=jnB57CqpP1uLPT/IX9WyY1PnuWV17IbNEaKGIaIR80H+S3L3IU0GBdHajmHtAEI/x13ojDlfVLBCww9B6SLumyCz8P2rWAkYwHalPMNAdZ+Gkwnae0ICOouwvup7L8TRImsVR0GHBqMnBql+O1npFbPWG9OQMnDTnmNmrvevvI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737737162; c=relaxed/simple;
	bh=L49e6rqBy6bsL/cwamgUOiyrr7shhTeMpfe8FK14/XM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i9+kGr3MeDrmFT5cRnBBV4HocS493QZQ4ZYL0lpyDRPfWCXR6yL2QstSbmHnS4fIyswTcF19cTr606W6bhmi1IL0oZ/LU8+yfkThto22jEnLdhl9Gp/PiSJSTJoCr0bbzuyN3yDo8yyc4ydjQcgE+s2vnHg+miviLvnVWXpl2tE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=qx7zpzzN; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3862d161947so1280674f8f.3
        for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 08:45:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1737737157; x=1738341957; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Y8XbLCxX1uSj7HqhlHeupCA+OPJANyZfPb/u1FQWnOY=;
        b=qx7zpzzNXWpiWT3aUDUh+su2uquFRDu98sxPjT+4n5fMZe4mNK4IR2gU94YsLtGxtu
         cVYtqhJrDSM5lp9h0b41QowVPbZn0PqPlvvesmnldbugNygHW7q7p6KJ7C+q5Sl4c9Vh
         NP4owE4w1a9APXePxwGB2fvNvll5LjE1YfQnLfhpavWepJA/nqcQ8okfO7b5mL5elp6I
         kaxtdF4td9Y9ZbGbhOFN2nPk0YsihAvPr2Tdwa923k6UQiXJU20czNK41TXcqf3rAH1I
         BjKHobklsgWgEoIJGH6L16aDU+Zbq+t68wEW3Z8I8Oa2kHcQxCX8WEdostziUVz3yXu/
         Z5/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737737157; x=1738341957;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y8XbLCxX1uSj7HqhlHeupCA+OPJANyZfPb/u1FQWnOY=;
        b=pbT1jeAOaiaycCGuVJi5kKSXEn5PZlmfZjPo7R8TIgJKTHOSytQIAAN6jd9gWlOU/4
         glnHoCuHPmFzo/WXmGT4Uq5xkJBFUexs2XRkoOPlosGGlVQkGkdN7JYmf90tkF1WtBn4
         2OpsWARmSLIQucWuu91tk+WwtWp36J4wZBWYiOtcZaMtO7+2LSyd4/7K1BUGQ1YKESdM
         IL3qp4TzQUzEj3QmfwekgSFLhZRVZMKZfsVhjIAEAIseUWDeJZjELtluViUFtKsgIYWi
         rZncYF/+j8IR5vBD5efrbXxr+rADzFEqNu0MPO8DCL951Jh2hOACKSZfhZZ4wYNSzMm5
         MVYg==
X-Gm-Message-State: AOJu0Yz7Pr9GHaveGZcQDA0ozs8mNa2S+uzyvY4cBn2L+/koBLjfEoYe
	GSfcly0P0X/gE/9CxF0IF3Wz2IRMpAsQIcI1+2W04Z7fIX78cor1puda/PBwqEw=
X-Gm-Gg: ASbGnct/NUkFkXWuCYuRup3xST3pgo9YtBbmQCUxUDfrZKt1GY1vJcmr6vpFiRcL5/t
	A8sQLBYgDBBvCsg+bB1mPP7qhV9mJmBh5LfVfrk4OzVy8de5ODGhNwX7CQq7D/iOP9xAZz+r2ks
	z3pU2qA+3P4kTvxabEmPHsgWLCiiB8Sjd93Jjb0NxntEtNmgeM5eV03az9lO2Y7DaO8YzLwmDXY
	qE5jmchwXDg885XokHIVWQrDnBvRKYLbMw7uOTOOhIF+1Om9rSCmCnTJ9WOE06ndxCdG7DfAyBv
	sadmHgXLZq33YiTBjuThPKch/+OMO5j230sm4mL61lP0oNI59A==
X-Google-Smtp-Source: AGHT+IFZ06OqkC/xFYj3mlUFAD1jtP/egeeNxGmAtPlkgVm838MqiNeQ+jA5lmrsUJLnFKyL9LMO5g==
X-Received: by 2002:a5d:59a2:0:b0:38a:88f8:aad7 with SMTP id ffacd0b85a97d-38bf57bdb18mr27720843f8f.54.1737737157210;
        Fri, 24 Jan 2025 08:45:57 -0800 (PST)
Received: from ?IPV6:2a01:e0a:e17:9700:16d2:7456:6634:9626? ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38c2a17d865sm3254071f8f.38.2025.01.24.08.45.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jan 2025 08:45:56 -0800 (PST)
Message-ID: <dd156ff1-3425-491a-830f-ce28abc6ed7e@rivosinc.com>
Date: Fri, 24 Jan 2025 17:45:55 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v2 2/2] riscv: Add tests for SBI FWFT
 extension
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 Andrew Jones <ajones@ventanamicro.com>, Anup Patel
 <apatel@ventanamicro.com>, Atish Patra <atishp@rivosinc.com>
References: <20250123165405.3524478-1-cleger@rivosinc.com>
 <20250123165405.3524478-3-cleger@rivosinc.com>
 <20250123-c4b9bac80893db142bc99690@orel>
Content-Language: en-US
From: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
In-Reply-To: <20250123-c4b9bac80893db142bc99690@orel>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 24/01/2025 17:35, Andrew Jones wrote:
> On Thu, Jan 23, 2025 at 05:54:04PM +0100, Clément Léger wrote:
>> Add tests for the FWFT SBI extension. Currently, only the reserved range
>> as well as the misaligned exception delegation are used.
>>
>> Signed-off-by: Clément Léger <cleger@rivosinc.com>
>> ---
>>  riscv/Makefile      |   2 +-
>>  lib/riscv/asm/sbi.h |  34 ++++++++
>>  riscv/sbi-fwft.c    | 189 ++++++++++++++++++++++++++++++++++++++++++++
>>  riscv/sbi.c         |   3 +
>>  4 files changed, 227 insertions(+), 1 deletion(-)
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
>> index 98a9b097..397400f2 100644
>> --- a/lib/riscv/asm/sbi.h
>> +++ b/lib/riscv/asm/sbi.h
>> @@ -11,6 +11,12 @@
>>  #define SBI_ERR_ALREADY_AVAILABLE	-6
>>  #define SBI_ERR_ALREADY_STARTED		-7
>>  #define SBI_ERR_ALREADY_STOPPED		-8
>> +#define SBI_ERR_NO_SHMEM		-9
>> +#define SBI_ERR_INVALID_STATE		-10
>> +#define SBI_ERR_BAD_RANGE		-11
>> +#define SBI_ERR_TIMEOUT			-12
>> +#define SBI_ERR_IO			-13
>> +#define SBI_ERR_LOCKED			-14
>>  
>>  #ifndef __ASSEMBLY__
>>  #include <cpumask.h>
>> @@ -23,6 +29,7 @@ enum sbi_ext_id {
>>  	SBI_EXT_SRST = 0x53525354,
>>  	SBI_EXT_DBCN = 0x4442434E,
>>  	SBI_EXT_SUSP = 0x53555350,
>> +	SBI_EXT_FWFT = 0x46574654,
>>  };
>>  
>>  enum sbi_ext_base_fid {
>> @@ -71,6 +78,33 @@ enum sbi_ext_dbcn_fid {
>>  	SBI_EXT_DBCN_CONSOLE_WRITE_BYTE,
>>  };
>>  
>> +
>> +enum sbi_ext_fwft_fid {
>> +	SBI_EXT_FWFT_SET = 0,
>> +	SBI_EXT_FWFT_GET,
>> +};
>> +
>> +#define SBI_FWFT_MISALIGNED_EXC_DELEG		0x0
>> +#define SBI_FWFT_LANDING_PAD			0x1
>> +#define SBI_FWFT_SHADOW_STACK			0x2
>> +#define SBI_FWFT_DOUBLE_TRAP			0x3
>> +#define SBI_FWFT_PTE_AD_HW_UPDATING		0x4
>> +#define SBI_FWFT_POINTER_MASKING_PMLEN		0x5
>> +#define SBI_FWFT_LOCAL_RESERVED_START		0x6
>> +#define SBI_FWFT_LOCAL_RESERVED_END		0x3fffffff
>> +#define SBI_FWFT_LOCAL_PLATFORM_START		0x40000000
>> +#define SBI_FWFT_LOCAL_PLATFORM_END		0x7fffffff
>> +
>> +#define SBI_FWFT_GLOBAL_RESERVED_START		0x80000000
>> +#define SBI_FWFT_GLOBAL_RESERVED_END		0xbfffffff
>> +#define SBI_FWFT_GLOBAL_PLATFORM_START		0xc0000000
>> +#define SBI_FWFT_GLOBAL_PLATFORM_END		0xffffffff
>> +
>> +#define SBI_FWFT_PLATFORM_FEATURE_BIT		BIT(30)
>> +#define SBI_FWFT_GLOBAL_FEATURE_BIT		BIT(31)
>> +
>> +#define SBI_FWFT_SET_FLAG_LOCK			BIT(0)
>> +
>>  struct sbiret {
>>  	long error;
>>  	long value;
>> diff --git a/riscv/sbi-fwft.c b/riscv/sbi-fwft.c
>> new file mode 100644
>> index 00000000..7866a917
>> --- /dev/null
>> +++ b/riscv/sbi-fwft.c
>> @@ -0,0 +1,189 @@
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
>> +
>> +static struct sbiret fwft_set_raw(unsigned long feature_id, unsigned long value,
>> +				  unsigned long flags)
>> +{
>> +	return sbi_ecall(SBI_EXT_FWFT, SBI_EXT_FWFT_SET, feature_id, value,
>> +			 flags, 0, 0, 0);
>> +}
>> +
>> +static struct sbiret fwft_set(uint32_t feature_id, unsigned long value,
>> +			      unsigned long flags)
>> +{
>> +	return fwft_set_raw(feature_id, value, flags);
>> +}
>> +
>> +static struct sbiret fwft_get_raw(unsigned long feature_id)
>> +{
>> +	return sbi_ecall(SBI_EXT_FWFT, SBI_EXT_FWFT_GET, feature_id, 0, 0, 0, 0,
>> +			 0);
>> +}
>> +
>> +static struct sbiret fwft_get(uint32_t feature_id)
>> +{
>> +	return fwft_get_raw(feature_id);
>> +}
> 
> nit: s/feature_id/feature/ for all the above, as that would exactly match
> the spec, but no biggy.
> 
>> +
>> +static void fwft_check_reserved(unsigned long id)
>> +{
>> +	struct sbiret ret;
>> +
>> +	ret = fwft_get(id);
>> +	report(ret.error == SBI_ERR_DENIED,
>> +	       "get reserved feature 0x%lx error == SBI_ERR_DENIED", id);
>> +
>> +	ret = fwft_set(id, 1, 0);
>> +	report(ret.error == SBI_ERR_DENIED,
>> +	       "set reserved feature 0x%lx error == SBI_ERR_DENIED", id);
> 
> I think we need something like gen_report(), which is in riscv/sbi.c, in
> order to output the unexpected errors if we don't get what we expect. I've
> pushed a few patches to my riscv/sbi branch[1] in order to provide
> sbiret_report_error().
> 
> [1] https://gitlab.com/jones-drew/kvm-unit-tests/-/commits/riscv/sbi

Ok sounds good, I'll use that function. And I'll do that on SSE testing
as well.

> 
>> +}
>> +
>> +static void fwft_check_base(void)
>> +{
>> +	struct sbiret ret;
>> +
>> +	report_prefix_push("base");
>> +
>> +	fwft_check_reserved(SBI_FWFT_LOCAL_RESERVED_START);
>> +	fwft_check_reserved(SBI_FWFT_LOCAL_RESERVED_END);
>> +	fwft_check_reserved(SBI_FWFT_GLOBAL_RESERVED_START);
>> +	fwft_check_reserved(SBI_FWFT_GLOBAL_RESERVED_END);
>> +
>> +	/* Check id > 32 bits */
>> +	if (__riscv_xlen > 32) {
>> +		ret = fwft_get_raw(BIT(32));
>> +		report(ret.error == SBI_ERR_INVALID_PARAM,
>> +		"get feature 0x%lx error == SBI_ERR_INVALID_PARAM", BIT(32));
> 
> Need to indent the string under ret.error.
> 
>> +
>> +		ret = fwft_set_raw(BIT(32), 0, 0);
>> +		report(ret.error == SBI_ERR_INVALID_PARAM,
>> +		"set feature 0x%lx error == SBI_ERR_INVALID_PARAM", BIT(32));
> 
> Need to indent the string under ret.error.
> 
>> +	}
>> +
>> +	report_prefix_pop();
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
>> +static void fwft_check_misaligned_exc_deleg(void)
>> +{
>> +	struct sbiret ret;
>> +
>> +	report_prefix_push("misaligned_exc_deleg");
>> +
>> +	ret = fwft_get(SBI_FWFT_MISALIGNED_EXC_DELEG);
>> +	if (ret.error == SBI_ERR_NOT_SUPPORTED) {
>> +		report_skip("SBI_FWFT_MISALIGNED_EXC_DELEG is not supported");
>> +		return;
>> +	}
>> +	report(!ret.error, "Get misaligned deleg feature no error: %lx",
>> +	       ret.error);
>> +	if (ret.error)
>> +		return;
> 
> With the new sbiret_report_error() this can become
> 
>   if (!sbiret_report_error(ret, 0, "Get misaligned deleg feature no error"))
>       return;
> 
>> +
>> +	ret = fwft_set(SBI_FWFT_MISALIGNED_EXC_DELEG, 2, 0);
>> +	report(ret.error == SBI_ERR_INVALID_PARAM,
>> +	       "Set misaligned deleg feature invalid value error");
>> +	ret = fwft_set(SBI_FWFT_MISALIGNED_EXC_DELEG, 0xFFFFFFFF, 0);
>> +	report(ret.error == SBI_ERR_INVALID_PARAM,
>> +	       "Set misaligned deleg feature invalid value error");
> 
> Need sbiret_report_error() to ensure we can see what the returned error
> was if it isn't what we expected.
> 
> We should have a different error message for each test so testers can
> look up the one that failed by the message. Maybe just output the
> invalid test value too.

Yes sure, I'll include the set value as well.

> 
>> +
>> +	if (__riscv_xlen > 32) {
>> +		ret = fwft_set(SBI_FWFT_MISALIGNED_EXC_DELEG, BIT(32), 0);
>> +		report(ret.error == SBI_ERR_INVALID_PARAM,
>> +		       "Set misaligned deleg with value > 32bits invalid param error");
>> +
>> +		ret = fwft_set(SBI_FWFT_MISALIGNED_EXC_DELEG, 0, BIT(32));
>> +		report(ret.error == SBI_ERR_INVALID_PARAM,
>> +		       "Set misaligned deleg with flag > 32bits invalid param error");
> 
> Same two comments as above.
> 
>> +	}
>> +
>> +	/* Set to 0 and check after with get */
>> +	ret = fwft_set(SBI_FWFT_MISALIGNED_EXC_DELEG, 0, 0);
>> +	report(!ret.error, "Set misaligned deleg feature value no error");
> 
>  sbiret_report_error()
> 
>> +	ret = fwft_get(SBI_FWFT_MISALIGNED_EXC_DELEG);
>> +	if (ret.error)
>> +		report_fail("Get misaligned deleg feature after set: %lx",
>> +			    ret.error);
>> +	else
>> +		report(ret.value == 0, "Set misaligned deleg feature value 0");
> 
>  sbiret_report(ret, 0, 0, "get/set misaligned deleg feature value 0")
> 
>> +
>> +	/* Set to 1 and check after with get */
>> +	ret = fwft_set(SBI_FWFT_MISALIGNED_EXC_DELEG, 1, 0);
>> +	report(!ret.error, "Set misaligned deleg feature value no error");
>> +	ret = fwft_get(SBI_FWFT_MISALIGNED_EXC_DELEG);
>> +	if (ret.error)
>> +		report_fail("Get misaligned deleg feature after set: %lx",
>> +			    ret.error);
>> +	else
>> +		report(ret.value == 1, "Set misaligned deleg feature value 1");
> 
> Same sbiret_report_error / sbiret_report comments as above.
> 
> We should get SBI_ERR_NOT_SUPPORTED if the platform doesn't support
> delegating misaligned exceptions, right? If so, then we should tolerate
> that and skip the trap test below.

I can't find/remember in which discussion it was discussed but the
consensus was that it is not an UNSUPPORTED error since the trap exist
on all implementations an can always be delegated. So this is actually
not and error, the trap is delegated but the platform does not generate
any misalign access traps. The S-mode can then check if the platform
misaligned accesses traps or not by itself.

> 
>> +
>> +	install_exception_handler(EXC_LOAD_MISALIGNED, misaligned_handler);
>> +
>> +	asm volatile (
>> +		".option push\n"
>> +		/*
>> +		 * Disable compression so the lw takes exactly 4 bytes and thus
>> +		 * can be skipped reliably from the exception handler.
>> +		 */
>> +		".option arch,-c\n"
> 
> What's the difference between this and .option norvc ?

I felt like this is mode generic than norvc/rvc. .arch works with all
extension AFAIK, norvc/rvc is purely relevant to C. Both of them works
the same way (at least to my trials with it).

> 
>> +		"lw %[val], 1(%[val_addr])\n"
>> +		".option pop\n"
>> +		: [val] "+r" (ret.value)
>> +		: [val_addr] "r" (&ret.value)
>> +		: "memory");
>> +
>> +	if (!misaligned_handled)
>> +		report_skip("Verify misaligned load exception trap in supervisor");
> 
> If we skip this test when we can't set SBI_FWFT_MISALIGNED_EXC_DELEG to 1,
> then we should always fail this test when we don't get the exception.

See my comment above. This is likely to be just an additional
information then. ie platform traps upon misaligned accesses. Probably
not what you expected though.

> 
>> +	else
>> +		report_pass("Verify misaligned load exception trap in supervisor");
>> +
>> +	install_exception_handler(EXC_LOAD_MISALIGNED, NULL);
>> +
>> +	/* Lock the feature */
>> +	ret = fwft_set(SBI_FWFT_MISALIGNED_EXC_DELEG, 0, SBI_FWFT_SET_FLAG_LOCK);
>> +	report(!ret.error, "Set misaligned deleg feature value 0 and lock no error");
>> +	ret = fwft_set(SBI_FWFT_MISALIGNED_EXC_DELEG, 1, 0);
>> +	report(ret.error == SBI_ERR_LOCKED,
>> +	       "Set misaligned deleg feature value 0 and lock no error");
>> +	ret = fwft_get(SBI_FWFT_MISALIGNED_EXC_DELEG);
>> +	report(!ret.error, "Get misaligned deleg locked value no error");
> 
> Need sbiret_report_error() for all these tests.
> 
>> +
>> +	report_prefix_pop();
>> +}
>> +
>> +void check_fwft(void)
>> +{
>> +	report_prefix_push("fwft");
>> +
>> +	if (!sbi_probe(SBI_EXT_FWFT)) {
>> +		report_skip("FWFT extension not available");
>> +		report_prefix_pop();
>> +		return;
>> +	}
>> +
>> +	fwft_check_base();
>> +	fwft_check_misaligned_exc_deleg();
>> +
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
> Thanks,
> drew


