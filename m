Return-Path: <kvm+bounces-48510-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B281FACED1D
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 11:52:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6E330178CF2
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 09:52:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E77D2211484;
	Thu,  5 Jun 2025 09:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="F8zMfZ5w"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31C472C3242
	for <kvm@vger.kernel.org>; Thu,  5 Jun 2025 09:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749117144; cv=none; b=dINhxN4L0JQF+cNbiYQmfD6phswDoIVbS6qSGf00zX/c12g0uN/qSsVlERqF9AEPsnu6FnvSLnjXblbt9J3YHXFsWvlRnwy8YeiGr9f0gd1Ger5+UvXs4RMo5MmbXlQv+LNqBfGi5DK6nDXtR8rVbHCo8s4qq0wzIp8l1+qy4vI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749117144; c=relaxed/simple;
	bh=GHldxeImimvr/Yq/GggM5ZVX1lMmrMH7vOSTmyT0U4Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EiKJZ/UWLOxnaLnA6jXaPe9r7wfMApeZA4akHmxqjjWRdV25COWuA2oM7atpoDpE+197jQNOWFlKkqDMGvjHe1EpPmm66D1a93fULlYxuRzYGH4thKTNav3TkFcXmHpDpcnQnrx/wOSuPgzmTCIkI2piatli3cdB5q1HEV8OQCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=F8zMfZ5w; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-22e16234307so7464185ad.0
        for <kvm@vger.kernel.org>; Thu, 05 Jun 2025 02:52:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1749117141; x=1749721941; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=W3ypB/CDJeqC+inE+Z5rOQ5X1ye26gFGCDJVpyRDjlM=;
        b=F8zMfZ5wJSzNUt2Ogm0wZwQ3jnOL50f0e1ki/UK43Txb4Vgp/5iDE+1MG0cZ8p9tvi
         287arQ+7Jb3T4VuKwXodlufDR9ShsgyGVFY9wUyLul8l1RoBHoJm6OB6+b6djRxhzIZN
         Nm8xAouoMN48Gwgp5RtylD1ThhhLSkFhJdqLbNHdWeIRWMsYaKYvy2QQlBHwpCGv3Ugu
         XheZN9kyWs9PghOQKmUc1QHW5OY9mZXmArcogUDP5kq+Ig8V9+Jra8opYrzcx985ZO9M
         Rg1E3uLkx7shKvEj9wHgGpN0F2O02NNwls0ilNhxrSwIq00mXzwB8ghyFwhjD5v3dPJ7
         H8+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749117141; x=1749721941;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W3ypB/CDJeqC+inE+Z5rOQ5X1ye26gFGCDJVpyRDjlM=;
        b=RS06Brh0QDqOfy3D1n/aIBMXqa6bVgIxvE8rcm0C2e2jkippuJKps+11SIwnC3aS+z
         XsCB/FeqGbGUeV3NqDoBwU6P0UQ/7JDOcPeHEJPBlRdzUHbRw1AtS51BJT9tIdQJL0S2
         cOnDGn9EO2z2cnqQHT5AXqYQztUuKcku61aSyDYJUjbdNgnn8d6mHoo5ClMyqFCzCC9k
         mW27rjt7qjh5II4d/qFDsfLRv8BB94S1sXnGDYUbm3/p/f3dBPEPfk0pDUtbIJmDEmNg
         41zBos/eiipYZrkQc/394zLTUaMD0VqAxAoxu+WwyTD8Yj1AEHIUp3CWXaJTU2AofnwU
         etpg==
X-Gm-Message-State: AOJu0YwIEFTuWmJxdL4uXNmch9bm4YuMobok7dNOwjR4R0DhTW6/3kW9
	YFgiJgLE0Q8foxIBHBPYW1JxKDDF9bBUed3QQRtHGFmCEj6y5Kr1xcLLh1P8XnYAMPA=
X-Gm-Gg: ASbGncvSTEwfYrjJ97kIpGqR9h+fa6qeruDlEQFpKTYLsGBsvU8h7lINRmN3nV77bzj
	Vu897cg2jDJI1155wW6T6HWlFRhuvT22Q5MQFaJS8HLcqw3GL6PtVkVO1uL9kDKqFxMFck21suR
	uQ8mzMAzlTMLw3SZj6kM4a/hH4EOEA0NCoiBy9W6PnGoWhR2ehVk8ygi4ly1uLZb/UBoinA/uII
	jasV0S9MxznegAyc0YSlJMGgt+zXlVxvR7IWgXB1j66Ox0XEhSn5wGPDoMHm/WnPDYcf7l0KSWp
	yIA4geyPvhZw9vhW36xEzQR9SwFonuSDPLTFv7p08ywpvTq77ykECg1ZQ09dnmHdn8InDdCqJX2
	UBmXt/3FkeYZYvkXA+FjO
X-Google-Smtp-Source: AGHT+IHvMtp1naq4IZqEIpfuBySCuSrG2k5Qj3MISy4s3AAu70yotqoZzvkcAMZ0F5V2di/fXwlKuA==
X-Received: by 2002:a17:903:22c4:b0:221:1497:7b08 with SMTP id d9443c01a7336-235f168d581mr45188775ad.23.1749117141287;
        Thu, 05 Jun 2025 02:52:21 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:e17:9700:16d2:7456:6634:9626? ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3132c0987eesm1153249a91.24.2025.06.05.02.52.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Jun 2025 02:52:20 -0700 (PDT)
Message-ID: <f8acf479-4a80-4128-bdd3-4ae69e0c215c@rivosinc.com>
Date: Thu, 5 Jun 2025 11:52:14 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests v2 2/2] riscv: Add ISA double trap extension
 testing
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 Andrew Jones <ajones@ventanamicro.com>, Ved Shanbhogue <ved@rivosinc.com>
References: <20250603154652.1712459-1-cleger@rivosinc.com>
 <20250603154652.1712459-3-cleger@rivosinc.com>
 <20250603-1e175dd9e60c1bf2a52dbfc9@orel>
Content-Language: en-US
From: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
In-Reply-To: <20250603-1e175dd9e60c1bf2a52dbfc9@orel>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 03/06/2025 18:25, Andrew Jones wrote:
> On Tue, Jun 03, 2025 at 05:46:50PM +0200, Clément Léger wrote:
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
>> safely assume that PAGE FAULT is delegatable and if a hardware that does
>> not have support comes up then it will probably be the vendor
>> responsibility to provide a way to do so.
>>
>> Link: https://github.com/clementleger/kvm-unit-tests/issues/1 [1]
>> Signed-off-by: Clément Léger <cleger@rivosinc.com>
>> ---
>>  riscv/Makefile            |   1 +
>>  lib/riscv/asm/csr.h       |   1 +
>>  lib/riscv/asm/processor.h |  10 ++
>>  riscv/isa-dbltrp.c        | 211 ++++++++++++++++++++++++++++++++++++++
>>  riscv/unittests.cfg       |   4 +
>>  5 files changed, 227 insertions(+)
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
>> diff --git a/lib/riscv/asm/processor.h b/lib/riscv/asm/processor.h
>> index 40104272..87a41312 100644
>> --- a/lib/riscv/asm/processor.h
>> +++ b/lib/riscv/asm/processor.h
>> @@ -48,6 +48,16 @@ static inline void ipi_ack(void)
>>  	csr_clear(CSR_SIP, IE_SSIE);
>>  }
>>  
>> +static inline void local_dlbtrp_enable(void)
>> +{
>> +	csr_set(CSR_SSTATUS, SR_SDT);
>> +}
>> +
>> +static inline void local_dlbtrp_disable(void)
>> +{
>> +	csr_clear(CSR_SSTATUS, SR_SDT);
>> +}
>> +
>>  void install_exception_handler(unsigned long cause, void (*handler)(struct pt_regs *));
>>  void install_irq_handler(unsigned long cause, void (*handler)(struct pt_regs *));
>>  void do_handle_exception(struct pt_regs *regs);
>> diff --git a/riscv/isa-dbltrp.c b/riscv/isa-dbltrp.c
>> new file mode 100644
>> index 00000000..a4545096
>> --- /dev/null
>> +++ b/riscv/isa-dbltrp.c
>> @@ -0,0 +1,211 @@
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
>> +static bool clear_sdt;
>> +
>> +#define INSN_LEN(insn)			((((insn) & 0x3) < 0x3) ? 2 : 4)
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
>> +	: : "r" (value), "r" (ptr) : "memory");					\
>> +} while (0)
>> +
>> +static void pagefault_trap_handler(struct pt_regs *regs)
>> +{
>> +	if (READ_ONCE(clear_sdt))
>> +		local_dlbtrp_disable();
>> +
>> +	if (READ_ONCE(double_trap)) {
>> +		WRITE_ONCE(double_trap, false);
>> +		GEN_TRAP();
>> +	}
>> +
>> +	/* Skip trapping instruction */
>> +	regs->epc += 4;
>> +
>> +	local_dlbtrp_enable();
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
>> +	WRITE_ONCE(sse_dbltrp_called, true);
>> +
>> +	/* Skip trapping instruction */
>> +	regs->epc += 4;
>> +}
>> +
>> +static int sse_double_trap(void)
>> +{
>> +	struct sbiret ret;
>> +	int err = 0;
>> +
>> +	struct sbi_sse_handler_arg handler_arg = {
>> +		.handler = sse_dbltrp_handler,
>> +		.stack = alloc_page() + PAGE_SIZE,
>> +	};
>> +
>> +	report_prefix_push("sse");
>> +
>> +	ret = sbi_sse_hart_unmask();
>> +	if (!sbiret_report_error(&ret, SBI_SUCCESS, "SSE hart unmask ok")) {
>> +		report_skip("Failed to unmask SSE events, skipping test");
>> +		goto out_free_page;
>> +	}
>> +
>> +	ret = sbi_sse_register(SBI_SSE_EVENT_LOCAL_DOUBLE_TRAP, &handler_arg);
>> +	if (ret.error == SBI_ERR_NOT_SUPPORTED) {
>> +		report_skip("SSE double trap event is not supported");
>> +		goto out_mask_sse;
>> +	}
>> +	sbiret_report_error(&ret, SBI_SUCCESS, "SSE double trap register");
>> +
>> +	ret = sbi_sse_enable(SBI_SSE_EVENT_LOCAL_DOUBLE_TRAP);
>> +	if (!sbiret_report_error(&ret, SBI_SUCCESS, "SSE double trap enable")) {
>> +		err = ret.error;
> 
> I'm not sure we need to return an error for this case. We won't be leaving
> an SSE event handler registered.
> >> +		goto out_unregister;
>> +	}
>> +
>> +	/*
>> +	 * Generate a double crash so that an SSE event should be generated. The SPEC (ISA nor SBI)
>> +	 * does not explicitly tell that if supported it should generate an SSE event but that's
>> +	 * a reasonable assumption to do so if both FWFT and SSE are supported.
>> +	 */
>> +	WRITE_ONCE(clear_sdt, false);
>> +	WRITE_ONCE(double_trap, true);
>> +	GEN_TRAP();
>> +
>> +	report(READ_ONCE(sse_dbltrp_called), "SSE double trap event generated");
>> +
>> +	ret = sbi_sse_disable(SBI_SSE_EVENT_LOCAL_DOUBLE_TRAP);
>> +	sbiret_report_error(&ret, SBI_SUCCESS, "SSE double trap disable");
>> +
>> +out_unregister:
>> +	ret = sbi_sse_unregister(SBI_SSE_EVENT_LOCAL_DOUBLE_TRAP);
>> +	sbiret_report_error(&ret, SBI_SUCCESS, "SSE double trap unregister");
> 
> Needs to be
> 
>  if (!sbiret_report_error(&ret, SBI_SUCCESS, "SSE double trap unregister"))
>     err = ret.error;

Hi Drew,

Indeed, thanks for catching it.

> 
>> +
>> +out_mask_sse:
>> +	sbi_sse_hart_mask();
>> +
>> +out_free_page:
>> +	free_page(handler_arg.stack - PAGE_SIZE);
>> +	report_prefix_pop();
>> +
>> +	return err;
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
>> +	install_exception_handler(EXC_STORE_PAGE_FAULT, pagefault_trap_handler);
>> +
>> +	WRITE_ONCE(clear_sdt, true);
>> +	WRITE_ONCE(double_trap, true);
>> +	GEN_TRAP();
>> +	report_pass("Double trap disabled, trap first time ok");
>> +
>> +	/* Enable double trap */
>> +	ret = sbi_fwft_set(SBI_FWFT_DOUBLE_TRAP, 1, 0);
>> +	sbiret_report_error(&ret, SBI_SUCCESS, "Set double trap enable feature value == 1");
>> +	ret = sbi_fwft_get(SBI_FWFT_DOUBLE_TRAP);
>> +	if (!sbiret_report(&ret, SBI_SUCCESS, 1, "Get double trap enable feature value == 1"))
>> +		return;
>> +
>> +	/* First time, clear the double trap flag (SDT) so that it doesn't generate a double trap */
>> +	WRITE_ONCE(clear_sdt, true);
>> +	WRITE_ONCE(double_trap, true);
>> +
>> +	GEN_TRAP();
>> +	report_pass("Trapped twice allowed ok");
>> +
>> +	if (sbi_probe(SBI_EXT_SSE)) {
>> +		if (sse_double_trap()) {
>> +			report_skip("Could not correctly unregister SSE event, skipping last test");
>> +			return;
>> +		}
>> +	} else {
>> +		report_skip("SSE double trap event will not be tested, extension is not available");
> 
> Missing return

That's actually telling us it skipped the SSE + double trap test, not
the rest of this function. So that should be kept without any return or
we will skip the last test.

Thanks,

Clément

> 
>> +	}
> 
> How about rearranging as
> 
>  if (!sbi_probe(SBI_EXT_SSE)) {
>     report_skip("SSE double trap event will not be tested, extension is not available");
>     return;
>  }
>  if (sse_double_trap()) {
>     report_skip("Could not correctly unregister SSE event, skipping last test");
>     return;
>  }
> 
>> +
>> +	if (!env_or_skip("DOUBLE_TRAP_TEST_CRASH"))
>> +		return;
>> +
>> +	/*
>> +	 * Third time, keep the double trap flag (SDT) and generate another trap, this should
>> +	 * generate a double trap. Since there is no SSE handler registered, it should crash to
>> +	 * M-mode.
>> +	 */
>> +	WRITE_ONCE(clear_sdt, false);
>> +	WRITE_ONCE(double_trap, true);
>> +	report_info("Should generate a double trap and crash!");
>> +	GEN_TRAP();
>> +	report_fail("Should have crashed!");
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
>> +	if (ret.error == SBI_ERR_NOT_SUPPORTED) {
>> +		report_skip("SBI_FWFT_DOUBLE_TRAP is not supported!");
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
>> index 2eb760ec..286e1cc7 100644
>> --- a/riscv/unittests.cfg
>> +++ b/riscv/unittests.cfg
>> @@ -18,3 +18,7 @@ groups = selftest
>>  file = sbi.flat
>>  smp = $MAX_SMP
>>  groups = sbi
>> +
>> +[dbltrp]
>> +file = isa-dbltrp.flat
>> +groups = isa sbi
>> -- 
>> 2.49.0
>>
> 
> Thanks,
> drew


