Return-Path: <kvm+bounces-48281-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 18C49ACC34B
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 11:39:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CE9E416C2B5
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 09:39:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9C0E2820A7;
	Tue,  3 Jun 2025 09:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="p+mse9Y5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CE147262D
	for <kvm@vger.kernel.org>; Tue,  3 Jun 2025 09:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748943582; cv=none; b=PP+EhLaF2Ji0eLjxcd0i+j/oEC5Bk2r9rxCIZgqiks6BBmQwLQL06LwLMTE0YZfcStAMe3S191BfDyIJd7aWRGVYRQlO9UuRW5+p4jLHqJmuPVCK6FLnGOAIBma6OsUfYzJS4v5z4xWSbGr3agD0B0VdIuKDl5UMlHUQ+7m/Vlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748943582; c=relaxed/simple;
	bh=G1pjibmREa2t/341lEP+G0FLennuhhvknePe/rNydS4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=W//zKyN8Cpf3UUIYCePZIpknhd2zEItkaafy0Xdtcm/LZCpY/MjSUu4zkPZKVkVClcbUKJY/OKj1TciZeG6D9uSMkNTdrHz+0gqw+x6tLpICHsrkln5I8Mt7JNMPC9JQBwmDquODSWQZDKhaYl4IXCRnPlSJVxSm5XIXZ5b+2xE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=p+mse9Y5; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-3a50956e5d3so1667596f8f.1
        for <kvm@vger.kernel.org>; Tue, 03 Jun 2025 02:39:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1748943578; x=1749548378; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ayLqPCugi//yFqn+B/ihiY+QIzVCkAIVDSi6CRkF8vA=;
        b=p+mse9Y5Ao+IMdOW7vm6X1vm37udHFtLX5xPosd2Yn4VDp9/zNDUqYUumjju3q6rkM
         ApokxEX9Q+vWXVYEDdqtETB+3YznlWeq3dFN0UmjJxWJlP/7m1BgBR9m0RamxbfF3ZXO
         OzpMFPSOAT+Kvu1avsYzLSyKZILFc+5KE6Qc6j+X08AG0jd1uY0YrebQTwCFLTJCVKmL
         0LfybcN2VLfQ7Lc14QGRgk5wD7PYTCUB+n3qAyl178hawp6+nqBwUwhvE3M7WjQK1o8B
         9rySeVndQN78yxVIwtqw9EjqvN86ebrA3vYK/WUgEXNX7C0sKOMYUeZXdYkYKwCin6QI
         GErA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748943578; x=1749548378;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ayLqPCugi//yFqn+B/ihiY+QIzVCkAIVDSi6CRkF8vA=;
        b=QHHUFZHTR2ZkiwA4OKfeS4rOd8siLKuRIFsnFQcvZHyR2GiHfcovLIp+BjzeDbpKqO
         OK66zY9D9POC/psbLm3a7sAJBml0txHIBd2dbZZUUFV7rHccfRFXfp2LPC7ljC1UEmje
         NV0tOCoyzZw2zBeVnLI4YUhJwwu/k9kJleKqOXTW5NRYlPQWI8xJVqlevelm7MFSKkJW
         EAaOXk+wxmh8DLkSacnOKO5h6eOSuYJbX6FYHvANrs/aUqTuXNBIt5H5o1sj6LKaYmgH
         b37gRWSUGTkW4pDJ7upOcYx/RLTIt30fTdwWw3NWFC1LnBzhlnUfEKDuEjpiLCfB5Fwl
         f+oQ==
X-Gm-Message-State: AOJu0YzNUDf4+Th0hbWU7txTc8oO8kIbSuqHvOIsp+xNlocwMahUouA7
	pLNm8TPyCnL5bMb+q1N6btXd3l6RL4qU8sf9HJqCAM1i293hvJ8RXluekPhSJCbrGSE8TG80kj4
	EUTJu50E=
X-Gm-Gg: ASbGncs02BgxGmjA9bEt2A5Q/PATuGm6RtZofde4znjJ3sq3sNP7uR3ouOMcTg8k4np
	kCWOVrJyQeAP4wdj6IM/oC5ec/LG3zRHSjTZn97g5IiiuJZMicA5xxVTHXU3I0lEABBN+kUzgST
	JXFqvenrn1CqYZY/0TSublGP++hXQ6BBISgthGWgwyllfOqQSiQUgMVI2ekNzdGfMdYo3SRG0dk
	XSh30nV5Xyvshkw516uvEVig5pJm9TP1yc0kCMDZ8ZM3yuTOorC0UZtj3guFMu9COdtBHLP7ZQJ
	j7aom2pISUsPFYOxV74uq6a7G9h6HxarY4X2XSFsXRJcIXjJoT5wv/79CiT4GyEfxpmRbcgmM/y
	Rljyrb6Gawvg0mmBfyC7L
X-Google-Smtp-Source: AGHT+IFcea6hN76MOIQI/+9F3NsPsMXQ4LSnJaMZ0puhT/uVpcczwGPv9UZv0RfeI7sq7BJnHJCv2A==
X-Received: by 2002:a5d:5846:0:b0:3a0:7d39:c23f with SMTP id ffacd0b85a97d-3a4f7a4d6b8mr12923490f8f.21.1748943578293;
        Tue, 03 Jun 2025 02:39:38 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:e17:9700:16d2:7456:6634:9626? ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a4efe6c4f2sm17444573f8f.22.2025.06.03.02.39.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Jun 2025 02:39:37 -0700 (PDT)
Message-ID: <032926ca-ee2c-4483-bd5f-196c83de9a7b@rivosinc.com>
Date: Tue, 3 Jun 2025 11:39:37 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] riscv: Add ISA double trap extension testing
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 Andrew Jones <ajones@ventanamicro.com>, Ved Shanbhogue <ved@rivosinc.com>
References: <20250523075341.1355755-1-cleger@rivosinc.com>
 <20250523075341.1355755-4-cleger@rivosinc.com>
 <20250603-46e84d5167307b38c90a06b5@orel>
Content-Language: en-US
From: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
In-Reply-To: <20250603-46e84d5167307b38c90a06b5@orel>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 03/06/2025 11:09, Andrew Jones wrote:
> On Fri, May 23, 2025 at 09:53:10AM +0200, Clément Léger wrote:
>> This test allows to test the double trap implementation of hardware as
>> well as the SBI FWFT and SSE support for double trap. The tests will try
>> to trigger double trap using various sequences and will test to receive
>> the SSE double trap event if supported.
>>
>> It is provided as a separate test from the SBI one for two reasons:
>> - It isn't specifically testing SBI "per se".
>> - It ends up by trying to crash into in M-mode.
>>
>> Currently, the test uses a page fault to raise a trap programatically.
>> Some concern was raised by a github user on the original branch [1]
>> saying that the spec doesn't mandate any trap to be delegatable and that
>> we would need a way to detect which ones are delegatable. I think we can
>> safely assume that PAGE FAULT is delagatable and if a hardware that does
>> not have support comes up then it will probably be the vendor
>> responsibility to provide a way to do so.
>>
>> Link: https://github.com/clementleger/kvm-unit-tests/issues/1 [1]
>> Signed-off-by: Clément Léger <cleger@rivosinc.com>
>> ---
>>  riscv/Makefile      |   1 +
>>  lib/riscv/asm/csr.h |   1 +
>>  riscv/isa-dbltrp.c  | 189 ++++++++++++++++++++++++++++++++++++++++++++
>>  riscv/unittests.cfg |   5 ++
>>  4 files changed, 196 insertions(+)
>>  create mode 100644 riscv/isa-dbltrp.c
>>
>> diff --git a/riscv/Makefile b/riscv/Makefile
>> index 11e68eae..d71c9d2e 100644
>> --- a/riscv/Makefile
>> +++ b/riscv/Makefile
>> @@ -14,6 +14,7 @@ tests =
>>  tests += $(TEST_DIR)/sbi.$(exe)
>>  tests += $(TEST_DIR)/selftest.$(exe)
>>  tests += $(TEST_DIR)/sieve.$(exe)
>> +tests += $(TEST_DIR)/isa-dbltrp.$(exe)
>>  
>>  all: $(tests)
>>  
>> diff --git a/lib/riscv/asm/csr.h b/lib/riscv/asm/csr.h
>> index 3e4b5fca..6a8e0578 100644
>> --- a/lib/riscv/asm/csr.h
>> +++ b/lib/riscv/asm/csr.h
>> @@ -18,6 +18,7 @@
>>  
>>  #define SR_SIE			_AC(0x00000002, UL)
>>  #define SR_SPP			_AC(0x00000100, UL)
>> +#define SR_SDT			_AC(0x01000000, UL) /* Supervisor Double Trap */
>>  
>>  /* Exception cause high bit - is an interrupt if set */
>>  #define CAUSE_IRQ_FLAG		(_AC(1, UL) << (__riscv_xlen - 1))
>> diff --git a/riscv/isa-dbltrp.c b/riscv/isa-dbltrp.c
>> new file mode 100644
>> index 00000000..174aee2a
>> --- /dev/null
>> +++ b/riscv/isa-dbltrp.c
>> @@ -0,0 +1,189 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * SBI verification
>> + *
>> + * Copyright (C) 2025, Rivos Inc., Clément Léger <cleger@rivosinc.com>
>> + */
>> +#include <alloc.h>
>> +#include <alloc_page.h>
>> +#include <libcflat.h>
>> +#include <stdlib.h>
>> +
>> +#include <asm/csr.h>
>> +#include <asm/page.h>
>> +#include <asm/processor.h>
>> +#include <asm/ptrace.h>
>> +#include <asm/sbi.h>
>> +
>> +#include <sbi-tests.h>
>> +
>> +static bool double_trap;
>> +static bool set_sdt = true;
>> +
>> +#define GEN_TRAP()								\
>> +do {										\
>> +	void *ptr = NULL;							\
>> +	unsigned long value = 0;						\
>> +	asm volatile(								\
>> +	"	.option push\n"							\
>> +	"	.option arch,-c\n"						\
>> +	"	sw %0, 0(%1)\n"							\
>> +	"	.option pop\n"							\
>> +	: : "r"(value), "r"(ptr) : "memory");					\
> 
> nit: need some spaces
> 
>  "r" (value), "r" (ptr)
> 
>> +} while (0)
>> +
>> +static void syscall_trap_handler(struct pt_regs *regs)
> 
> This is a page fault handler, not a syscall.
> >> +{
>> +	if (set_sdt)
>> +		csr_set(CSR_SSTATUS, SR_SDT);
>> +
>> +	if (double_trap) {
>> +		double_trap = false;
>> +		GEN_TRAP();
>> +	}
>> +
>> +	/* Skip trapping instruction */
>> +	regs->epc += 4;
>> +}
>> +
>> +static bool sse_dbltrp_called;
>> +
>> +static void sse_dbltrp_handler(void *data, struct pt_regs *regs, unsigned int hartid)
>> +{
>> +	struct sbiret ret;
>> +	unsigned long flags;
>> +	unsigned long expected_flags = SBI_SSE_ATTR_INTERRUPTED_FLAGS_SSTATUS_SPP |
>> +				       SBI_SSE_ATTR_INTERRUPTED_FLAGS_SSTATUS_SDT;
>> +
>> +	ret = sbi_sse_read_attrs(SBI_SSE_EVENT_LOCAL_DOUBLE_TRAP, SBI_SSE_ATTR_INTERRUPTED_FLAGS, 1,
>> +				 &flags);
>> +	sbiret_report_error(&ret, SBI_SUCCESS, "Get double trap event flags");
>> +	report(flags == expected_flags, "SSE flags == 0x%lx", expected_flags);
>> +
>> +	sse_dbltrp_called = true;
>> +
>> +	/* Skip trapping instruction */
>> +	regs->epc += 4;
>> +}
>> +
>> +static void sse_double_trap(void)
>> +{
>> +	struct sbiret ret;
>> +
>> +	struct sbi_sse_handler_arg handler_arg = {
>> +		.handler = sse_dbltrp_handler,
>> +		.stack = alloc_page() + PAGE_SIZE,
>> +	};
>> +
>> +	report_prefix_push("sse");
>> +
>> +	ret = sbi_sse_hart_unmask();
>> +	if (!sbiret_report_error(&ret, SBI_SUCCESS, "SSE hart unmask ok"))
>> +		goto out;
> 
> The unmasking failed, but the out label takes us to a mask.

Hi Drew,

Yeah masking it even if unmask wasn't so important since it's the boot
state. I'll add a separate label though.

> 
>> +
>> +	ret = sbi_sse_register(SBI_SSE_EVENT_LOCAL_DOUBLE_TRAP, &handler_arg);
>> +	if (ret.error == SBI_ERR_NOT_SUPPORTED) {
>> +		report_skip("SSE double trap event is not supported");
>> +		goto out;
>> +	}
>> +	sbiret_report_error(&ret, SBI_SUCCESS, "SSE double trap register");
>> +
>> +	ret = sbi_sse_enable(SBI_SSE_EVENT_LOCAL_DOUBLE_TRAP);
>> +	if (!sbiret_report_error(&ret, SBI_SUCCESS, "SSE double trap enable"))
>> +		goto out_unregister;
>> +
>> +	/*
>> +	 * Generate a double crash so that an SSE event should be generated. The SPEC (ISA nor SBI)
>> +	 * does not explicitly tell that if supported it should generate an SSE event but that's
>> +	 * a reasonable assumption to do so if both FWFT and SSE are supported.
> 
> This is something to raise in a tech-prs call, because it sounds like we
> need another paragraph for FWFT which states when DOUBLE_TRAP is enabled
> and SSE is supported that SSE local double trap events will be raised. Or,
> we need another FWFT feature that allows S-mode to request that behavior
> be enabled/disabled when SSE is supported (and M-mode can decide yes/no
> to that request).

That's a good point, I'll submit a patch to modify the SBI doc in that way.


> 
>> +	 */
>> +	set_sdt = true;
>> +	double_trap = true;
> 
> WRITE_ONCE(set_sdt, true);
> WRITE_ONCE(double_trap, true);
> 
>> +	GEN_TRAP();
>> +
>> +	report(sse_dbltrp_called, "SSE double trap event generated");
> 
> READ_ONCE(sse_dbltrp_called)
> 
>> +
>> +	ret = sbi_sse_disable(SBI_SSE_EVENT_LOCAL_DOUBLE_TRAP);
>> +	sbiret_report_error(&ret, SBI_SUCCESS, "SSE double trap disable");
>> +out_unregister:
>> +	ret = sbi_sse_unregister(SBI_SSE_EVENT_LOCAL_DOUBLE_TRAP);
>> +	sbiret_report_error(&ret, SBI_SUCCESS, "SSE double trap unregister");
>> +
>> +out:
>> +	sbi_sse_hart_mask();
>> +	free_page(handler_arg.stack - PAGE_SIZE);
>> +
>> +	report_prefix_pop();
>> +}
>> +
>> +static void check_double_trap(void)
>> +{
>> +	struct sbiret ret;
>> +
>> +	/* Disable double trap */
>> +	ret = sbi_fwft_set(SBI_FWFT_DOUBLE_TRAP, 0, 0);
>> +	sbiret_report_error(&ret, SBI_SUCCESS, "Set double trap enable feature value == 0");
>> +	ret = sbi_fwft_get(SBI_FWFT_DOUBLE_TRAP);
>> +	sbiret_report(&ret, SBI_SUCCESS, 0, "Get double trap enable feature value == 0");
>> +
>> +	install_exception_handler(EXC_STORE_PAGE_FAULT, syscall_trap_handler);
>> +
>> +	double_trap = true;
> 
> WRITE_ONCE(double_trap, true);
> 
>> +	GEN_TRAP();
>> +	report_pass("Double trap disabled, trap first time ok");
>> +
>> +	/* Enable double trap */
>> +	ret = sbi_fwft_set(SBI_FWFT_DOUBLE_TRAP, 1, 1);
> 
> Why lock it?

That's a mistake.

> 
>> +	sbiret_report_error(&ret, SBI_SUCCESS, "Set double trap enable feature value == 1");
>> +	ret = sbi_fwft_get(SBI_FWFT_DOUBLE_TRAP);
>> +	if (!sbiret_report(&ret, SBI_SUCCESS, 1, "Get double trap enable feature value == 1"))
>> +		return;
>> +
>> +	/* First time, clear the double trap flag (SDT) so that it doesn't generate a double trap */
>> +	set_sdt = false;
>> +	double_trap = true;
> 
> WRITE_ONCE(set_sdt, true);
> WRITE_ONCE(double_trap, true);
> 
>> +	GEN_TRAP();
>> +	report_pass("Trapped twice allowed ok");
>> +
>> +	if (sbi_probe(SBI_EXT_SSE))
>> +		sse_double_trap();
>> +	else
>> +		report_skip("SSE double trap event will not be tested, extension is not available");
>> +
>> +	/*
>> +	 * Second time, keep the double trap flag (SDT) and generate another trap, this should
> 
> Third time if we did the SSE test.
> 
>> +	 * generate a double trap. Since there is no SSE handler registered, it should crash to
>> +	 * M-mode.
> 
> No SSE handler that we know of... sse_double_trap() should return
> some error if it fails to unregister and then we should skip this
> test in that case.

Indeed, good catch.

> 
>> +	 */
>> +	set_sdt = true;
>> +	double_trap = true;
> 
> WRITE_ONCE(set_sdt, true);
> WRITE_ONCE(double_trap, true);
> 
>> +	report_info("Should generate a double trap and crash !");
>> +	GEN_TRAP();
>> +	report_fail("Should have crashed !");
> 
> nit: Put the '!' next to the last word.
> 
> I think this M-mode crash test should be optional. We can make it optional
> on an environment variable since we already use environment variables for
> other optional tests. We even have env_or_skip() in riscv/sbi-tests.h for
> that purpose.

Acked, I'll use env_or_skip().

Thanks,

Clément

> 
>> +}
>> +
>> +int main(int argc, char **argv)
>> +{
>> +	struct sbiret ret;
>> +
>> +	report_prefix_push("dbltrp");
>> +
>> +	if (!sbi_probe(SBI_EXT_FWFT)) {
>> +		report_skip("FWFT extension is not available, can not enable double traps");
>> +		goto out;
>> +	}
>> +
>> +	ret = sbi_fwft_get(SBI_FWFT_DOUBLE_TRAP);
>> +	if (ret.value == SBI_ERR_NOT_SUPPORTED) {
>> +		report_skip("SBI_FWFT_DOUBLE_TRAP is not supported !");
> 
> nit: Put the '!' next to the last word.
> 
>> +		goto out;
>> +	}
>> +
>> +	if (sbiret_report_error(&ret, SBI_SUCCESS, "SBI_FWFT_DOUBLE_TRAP get value"))
>> +		check_double_trap();
>> +
>> +out:
>> +	report_prefix_pop();
>> +
>> +	return report_summary();
>> +}
>> diff --git a/riscv/unittests.cfg b/riscv/unittests.cfg
>> index 2eb760ec..757e6027 100644
>> --- a/riscv/unittests.cfg
>> +++ b/riscv/unittests.cfg
>> @@ -18,3 +18,8 @@ groups = selftest
>>  file = sbi.flat
>>  smp = $MAX_SMP
>>  groups = sbi
>> +
>> +[dbltrp]
>> +file = isa-dbltrp.flat
>> +smp = $MAX_SMP
> 
> The test doesn't appear to require multiple harts.
> 
>> +groups = isa
> 
> groups = isa sbi
> 
>> -- 
>> 2.49.0
>>
> 
> Thanks,
> drew


