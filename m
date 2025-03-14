Return-Path: <kvm+bounces-41033-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A66FA60D4C
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 10:29:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4ED7C1640A2
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 09:29:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17C621EDA26;
	Fri, 14 Mar 2025 09:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="Hw6x0VfM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB83B763F8
	for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 09:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741944552; cv=none; b=mYZ1/IY93GrQVs9Rxumz+/8XXJ0TB6y7imkwELLhjm5jzzouK46s0E29TvvJYvM+DNjeth0zzh91rilQTT48EmIvAmnZzQMJi/NbZl+w9cWaG+ccDiEvM6gCBwTIH4twIhyy99YPa5SA32+YXtGlZcWxItCycAfAoy7nIZqGsNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741944552; c=relaxed/simple;
	bh=On6hACAAo2LuD2fDr9JPmfCe+Jm4GXGUyec5IAhuuz0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Wb/BxK0q8psd2faM7tXV64+4GurczS6Nr6H1CYIhpxvD2ihXLl1wjxX/BX6i/TbvMHhZoqEuTqft+hhCMFz2yh0AkWedWNsMC9TpayOjCcXLRihG40HIhZP6NjWw71yRmNfkY6equoKTSiODmqF0RA+g3XvLeb0AQVRsEgCiK4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=Hw6x0VfM; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-43cfa7e7f54so12362605e9.1
        for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 02:29:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1741944546; x=1742549346; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UNnwEjKQxFcWg1QY1DdbtwT36jd3wvBEGqbMmSPmuOg=;
        b=Hw6x0VfMECcSO3ZAMzz5T0Fo5lBefGXi4PVCm+fkq9w22yfYxurwa1QyGfMXckiNp5
         EJQAym+BH+/RfefYjt+Q8hhXOV38IBKr/r5gcARFwI3fsZPVsXIjMhbgdah3K1M/7vQ3
         G4OdSIxp1Qq96ydF4SO+bqZsrRQuLn3ahrJjE+0acyq9AW1m+2eyl8tPAYv1xxJTLEYI
         4Cj9Gdvv3tmor8rN8xroyeelnqnyFVkWFzoZYF+6RVIWCuBAIrQTQrPyXJbWFo0PCsW9
         +IdTaa3du06ehJlEJEEz/dx0+/J2j/Mpt347vyDNfhVUXPWvYUBufbyh6ybSqVJZlNok
         78uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741944546; x=1742549346;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UNnwEjKQxFcWg1QY1DdbtwT36jd3wvBEGqbMmSPmuOg=;
        b=N9xnrwWDM5BWkIWVGNrgW9jtNTQdF3l8KBqqgiInMlAjHAu4Dv3tIEmSHZmmW1iLo8
         6xESFaBZHXiF+v4S1cIqOzanR8F9co+49iF4jGkPDIj5pFP6QpVF9/nuE7cqrLIATKrR
         hoxsCaIrnjDX8fx9wcshJy5jqsU/kAu80Rhq47CrnxiI6XI7IaR9xgQrAOecwg8ywnYz
         i8qyb03M5QF/+DCVbuzxZym9DD4Tx802oZg1ShgEz0qiyhcdmfKNF84XBxqQmwrjo07g
         s2UfmJtwp0ovcINnorkreMYbWBmnZmXfdcNPZaMy3l8+QjmZwayGpBUcU6UgN2vX1vKh
         u8bw==
X-Gm-Message-State: AOJu0YzcyH7xgChfkWTUkfC3AShyuftAUq4DgfAeslp1u8Vvr4MkCtMt
	y+AX/CJph10wZvh6YBH8N+cLEchGjCLNZ3VDTJXMu0zSFVtvxwq2GXI+P7NhMV8=
X-Gm-Gg: ASbGncv5x9Cr3nrgitAqqBIeqzKWQNyxFhaE3y6xWJ8XTJRj+Hcxv5TehnWYeNJ0DlR
	63AQSkgJplRvXylQ7p/kKjL2qGJBvd8NYGnuWBXyqZf86eduPOmMSFfN6H2jUXYU8sX9qHa9e2a
	QWl7pWy9MCBUEamZF1lxAkaatfBq48zFvXI5bCt8Tl6tlJgcI41icOSugjdl/+izV0ZVTj7fNKX
	e1bmhkv6hRUoFbTq2xvzLhmOTzqdVpdIW43ET2eDcV/vL2Po0DHHfB2vW1NGxlVmjj6uF8NrGTZ
	IwqzNUYGSQ3Rb3BNd+C4om5973mLIq3rM6MQVTQvpZhCFgztR4hOID7zUAwno3+53YOezCqkpzs
	9naEBAU1qG63qTg==
X-Google-Smtp-Source: AGHT+IH0o9dx5XWqtNtgH9GEr/m+F9h/71/w1Wq3mdNsW8qX7EbNDkLqkar/xOyekb+sI3+fes1n0w==
X-Received: by 2002:a05:600c:354b:b0:439:4c1e:d810 with SMTP id 5b1f17b1804b1-43d1f1fd617mr21251235e9.9.1741944545671;
        Fri, 14 Mar 2025 02:29:05 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:e17:9700:16d2:7456:6634:9626? ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d1ffbcf95sm11154455e9.14.2025.03.14.02.29.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Mar 2025 02:29:04 -0700 (PDT)
Message-ID: <ba21e0e0-d262-41f1-a71b-b7de31cbbbce@rivosinc.com>
Date: Fri, 14 Mar 2025 10:29:04 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v8 6/6] riscv: sbi: Add SSE extension tests
To: Andrew Jones <ajones@ventanamicro.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 Anup Patel <apatel@ventanamicro.com>, Atish Patra <atishp@rivosinc.com>
References: <20250307161549.1873770-1-cleger@rivosinc.com>
 <20250307161549.1873770-7-cleger@rivosinc.com>
 <20250312-fa9b1889ef5f422be2e20cf4@orel>
Content-Language: en-US
From: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
In-Reply-To: <20250312-fa9b1889ef5f422be2e20cf4@orel>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 12/03/2025 18:51, Andrew Jones wrote:
> On Fri, Mar 07, 2025 at 05:15:48PM +0100, Clément Léger wrote:
>> Add SBI SSE extension tests for the following features:
>> - Test attributes errors (invalid values, RO, etc)
>> - Registration errors
>> - Simple events (register, enable, inject)
>> - Events with different priorities
>> - Global events dispatch on different harts
>> - Local events on all harts
>> - Hart mask/unmask events
>>
>> Signed-off-by: Clément Léger <cleger@rivosinc.com>
>> ---
>>  riscv/Makefile    |    1 +
>>  riscv/sbi-tests.h |    1 +
>>  riscv/sbi-sse.c   | 1215 +++++++++++++++++++++++++++++++++++++++++++++
>>  riscv/sbi.c       |    2 +
>>  4 files changed, 1219 insertions(+)
>>  create mode 100644 riscv/sbi-sse.c
>>
>> diff --git a/riscv/Makefile b/riscv/Makefile
>> index 16fc125b..4fe2f1bb 100644
>> --- a/riscv/Makefile
>> +++ b/riscv/Makefile
>> @@ -18,6 +18,7 @@ tests += $(TEST_DIR)/sieve.$(exe)
>>  all: $(tests)
>>  
>>  $(TEST_DIR)/sbi-deps = $(TEST_DIR)/sbi-asm.o $(TEST_DIR)/sbi-fwft.o
>> +$(TEST_DIR)/sbi-deps += $(TEST_DIR)/sbi-sse.o
>>  
>>  # When built for EFI sieve needs extra memory, run with e.g. '-m 256' on QEMU
>>  $(TEST_DIR)/sieve.$(exe): AUXFLAGS = 0x1
>> diff --git a/riscv/sbi-tests.h b/riscv/sbi-tests.h
>> index b081464d..a71da809 100644
>> --- a/riscv/sbi-tests.h
>> +++ b/riscv/sbi-tests.h
>> @@ -71,6 +71,7 @@
>>  	sbiret_report(ret, expected_error, expected_value, "check sbi.error and sbi.value")
>>  
>>  void sbi_bad_fid(int ext);
>> +void check_sse(void);
>>  
>>  #endif /* __ASSEMBLER__ */
>>  #endif /* _RISCV_SBI_TESTS_H_ */
>> diff --git a/riscv/sbi-sse.c b/riscv/sbi-sse.c
>> new file mode 100644
>> index 00000000..7bd58b8b
>> --- /dev/null
>> +++ b/riscv/sbi-sse.c
>> @@ -0,0 +1,1215 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * SBI SSE testsuite
>> + *
>> + * Copyright (C) 2025, Rivos Inc., Clément Léger <cleger@rivosinc.com>
>> + */
>> +#include <alloc.h>
>> +#include <alloc_page.h>
>> +#include <bitops.h>
>> +#include <cpumask.h>
>> +#include <libcflat.h>
>> +#include <on-cpus.h>
>> +#include <stdlib.h>
>> +
>> +#include <asm/barrier.h>
>> +#include <asm/delay.h>
>> +#include <asm/io.h>
>> +#include <asm/page.h>
>> +#include <asm/processor.h>
>> +#include <asm/sbi.h>
>> +#include <asm/setup.h>
>> +#include <asm/timer.h>
>> +
>> +#include "sbi-tests.h"
>> +
>> +#define SSE_STACK_SIZE	PAGE_SIZE
>> +
>> +struct sse_event_info {
>> +	uint32_t event_id;
>> +	const char *name;
>> +	bool can_inject;
>> +};
>> +
>> +static struct sse_event_info sse_event_infos[] = {
>> +	{
>> +		.event_id = SBI_SSE_EVENT_LOCAL_HIGH_PRIO_RAS,
>> +		.name = "local_high_prio_ras",
>> +	},
>> +	{
>> +		.event_id = SBI_SSE_EVENT_LOCAL_DOUBLE_TRAP,
>> +		.name = "double_trap",
>> +	},
>> +	{
>> +		.event_id = SBI_SSE_EVENT_GLOBAL_HIGH_PRIO_RAS,
>> +		.name = "global_high_prio_ras",
>> +	},
>> +	{
>> +		.event_id = SBI_SSE_EVENT_LOCAL_PMU_OVERFLOW,
>> +		.name = "local_pmu_overflow",
>> +	},
>> +	{
>> +		.event_id = SBI_SSE_EVENT_LOCAL_LOW_PRIO_RAS,
>> +		.name = "local_low_prio_ras",
>> +	},
>> +	{
>> +		.event_id = SBI_SSE_EVENT_GLOBAL_LOW_PRIO_RAS,
>> +		.name = "global_low_prio_ras",
>> +	},
>> +	{
>> +		.event_id = SBI_SSE_EVENT_LOCAL_SOFTWARE,
>> +		.name = "local_software",
>> +	},
>> +	{
>> +		.event_id = SBI_SSE_EVENT_GLOBAL_SOFTWARE,
>> +		.name = "global_software",
>> +	},
>> +};
>> +
>> +static const char *const attr_names[] = {
>> +	[SBI_SSE_ATTR_STATUS] = "status",
>> +	[SBI_SSE_ATTR_PRIORITY] = "priority",
>> +	[SBI_SSE_ATTR_CONFIG] = "config",
>> +	[SBI_SSE_ATTR_PREFERRED_HART] = "preferred_hart",
>> +	[SBI_SSE_ATTR_ENTRY_PC] = "entry_pc",
>> +	[SBI_SSE_ATTR_ENTRY_ARG] = "entry_arg",
>> +	[SBI_SSE_ATTR_INTERRUPTED_SEPC] = "interrupted_sepc",
>> +	[SBI_SSE_ATTR_INTERRUPTED_FLAGS] = "interrupted_flags",
>> +	[SBI_SSE_ATTR_INTERRUPTED_A6] = "interrupted_a6",
>> +	[SBI_SSE_ATTR_INTERRUPTED_A7] = "interrupted_a7",
> 
> nit: tabulate
> 
>> +};
>> +
>> +static const unsigned long ro_attrs[] = {
>> +	SBI_SSE_ATTR_STATUS,
>> +	SBI_SSE_ATTR_ENTRY_PC,
>> +	SBI_SSE_ATTR_ENTRY_ARG,
>> +};
>> +
>> +static const unsigned long interrupted_attrs[] = {
>> +	SBI_SSE_ATTR_INTERRUPTED_SEPC,
>> +	SBI_SSE_ATTR_INTERRUPTED_FLAGS,
>> +	SBI_SSE_ATTR_INTERRUPTED_A6,
>> +	SBI_SSE_ATTR_INTERRUPTED_A7,
>> +};
>> +
>> +static const unsigned long interrupted_flags[] = {
>> +	SBI_SSE_ATTR_INTERRUPTED_FLAGS_SSTATUS_SPP,
>> +	SBI_SSE_ATTR_INTERRUPTED_FLAGS_SSTATUS_SPIE,
>> +	SBI_SSE_ATTR_INTERRUPTED_FLAGS_SSTATUS_SPELP,
>> +	SBI_SSE_ATTR_INTERRUPTED_FLAGS_SSTATUS_SDT,
>> +	SBI_SSE_ATTR_INTERRUPTED_FLAGS_HSTATUS_SPV,
>> +	SBI_SSE_ATTR_INTERRUPTED_FLAGS_HSTATUS_SPVP,
>> +};
>> +
>> +static struct sse_event_info *sse_event_get_info(uint32_t event_id)
>> +{
>> +	int i;
>> +
>> +	for (i = 0; i < ARRAY_SIZE(sse_event_infos); i++) {
>> +		if (sse_event_infos[i].event_id == event_id)
>> +			return &sse_event_infos[i];
>> +	}
>> +
>> +	assert_msg(false, "Invalid event id: %d", event_id);
>> +}
>> +
>> +static const char *sse_event_name(uint32_t event_id)
>> +{
>> +	return sse_event_get_info(event_id)->name;
>> +}
>> +
>> +static bool sse_event_can_inject(uint32_t event_id)
>> +{
>> +	return sse_event_get_info(event_id)->can_inject;
>> +}
>> +
>> +static struct sbiret sse_get_event_status_field(uint32_t event_id, unsigned long mask,
>> +						unsigned long shift, unsigned long *value)
>> +{
>> +	struct sbiret ret;
>> +	unsigned long status;
>> +
>> +	ret = sbi_sse_read_attrs(event_id, SBI_SSE_ATTR_STATUS, 1, &status);
>> +	if (ret.error) {
>> +		sbiret_report_error(&ret, SBI_SUCCESS, "Get event status");
>> +		return ret;
>> +	}
>> +
>> +	*value = (status & mask) >> shift;
>> +
>> +	return ret;
>> +}
>> +
>> +static struct sbiret sse_event_get_state(uint32_t event_id, enum sbi_sse_state *state)
>> +{
>> +	unsigned long status = 0;
>> +	struct sbiret ret;
>> +
>> +	ret = sse_get_event_status_field(event_id, SBI_SSE_ATTR_STATUS_STATE_MASK,
>> +					  SBI_SSE_ATTR_STATUS_STATE_OFFSET, &status);
>> +	*state = status;
>> +
>> +	return ret;
>> +}
>> +
>> +static unsigned long sse_global_event_set_current_hart(uint32_t event_id)
>> +{
>> +	struct sbiret ret;
>> +	unsigned long current_hart = current_thread_info()->hartid;
>> +
>> +	if (!sbi_sse_event_is_global(event_id))
>> +		return SBI_ERR_INVALID_PARAM;
> 
> The only two callers of sse_global_event_set_current_hart() check
> sbi_sse_event_is_global() themselves, so this check can be an assert().
> I think it should be anyway, since returning an SBI error, which didn't
> originate in SBI, could lead to confusion.

Indeed, that check is clearly meant to be an assert.

> 
>> +
>> +	ret = sbi_sse_write_attrs(event_id, SBI_SSE_ATTR_PREFERRED_HART, 1, &current_hart);
>> +	if (sbiret_report_error(&ret, SBI_SUCCESS, "Set preferred hart"))
>> +		return ret.error;
>> +
>> +	return 0;
>> +}
>> +
>> +static bool sse_check_state(uint32_t event_id, unsigned long expected_state)
>> +{
>> +	struct sbiret ret;
>> +	enum sbi_sse_state state;
>> +
>> +	ret = sse_event_get_state(event_id, &state);
>> +	if (ret.error)
>> +		return false;
>> +
>> +	return report(state == expected_state, "event status == %ld", expected_state);
>> +}
>> +
>> +static bool sse_event_pending(uint32_t event_id)
>> +{
>> +	bool pending = 0;
>> +
>> +	sse_get_event_status_field(event_id, BIT(SBI_SSE_ATTR_STATUS_PENDING_OFFSET),
>> +		SBI_SSE_ATTR_STATUS_PENDING_OFFSET, (unsigned long*)&pending);
>> +
>> +	return pending;
>> +}
>> +
>> +static void *sse_alloc_stack(void)
>> +{
>> +	/*
>> +	 * We assume that SSE_STACK_SIZE always fit in one page. This page will
>> +	 * always be decremented before storing anything on it in sse-entry.S.
>> +	 */
>> +	assert(SSE_STACK_SIZE <= PAGE_SIZE);
>> +
>> +	return (alloc_page() + SSE_STACK_SIZE);
>> +}
>> +
>> +static void sse_free_stack(void *stack)
>> +{
>> +	free_page(stack - SSE_STACK_SIZE);
>> +}
>> +
>> +static void sse_read_write_test(uint32_t event_id, unsigned long attr, unsigned long attr_count,
>> +				unsigned long *value, long expected_error, const char *str)
>> +{
>> +	struct sbiret ret;
>> +
>> +	ret = sbi_sse_read_attrs(event_id, attr, attr_count, value);
>> +	sbiret_report_error(&ret, expected_error, "Read %s error", str);
>> +
>> +	ret = sbi_sse_write_attrs(event_id, attr, attr_count, value);
>> +	sbiret_report_error(&ret, expected_error, "Write %s error", str);
>> +}
>> +
>> +#define ALL_ATTRS_COUNT	(SBI_SSE_ATTR_INTERRUPTED_A7 + 1)
>> +
>> +static void sse_test_attrs(uint32_t event_id)
>> +{
>> +	unsigned long value = 0;
>> +	struct sbiret ret;
>> +	void *ptr;
>> +	unsigned long values[ALL_ATTRS_COUNT];
>> +	unsigned int i;
>> +	const char *invalid_hart_str;
>> +	const char *attr_name;
>> +
>> +	report_prefix_push("attrs");
>> +
>> +	for (i = 0; i < ARRAY_SIZE(ro_attrs); i++) {
>> +		ret = sbi_sse_write_attrs(event_id, ro_attrs[i], 1, &value);
>> +		sbiret_report_error(&ret, SBI_ERR_DENIED, "RO attribute %s not writable",
>> +				    attr_names[ro_attrs[i]]);
>> +	}
>> +
>> +	ret = sbi_sse_read_attrs(event_id, SBI_SSE_ATTR_STATUS, ALL_ATTRS_COUNT, values);
>> +	sbiret_report_error(&ret, SBI_SUCCESS, "Read multiple attributes");
>> +
>> +	for (i = SBI_SSE_ATTR_STATUS; i <= SBI_SSE_ATTR_INTERRUPTED_A7; i++) {
>> +		ret = sbi_sse_read_attrs(event_id, i, 1, &value);
>> +		attr_name = attr_names[i];
>> +
>> +		sbiret_report_error(&ret, SBI_SUCCESS, "Read single attribute %s", attr_name);
>> +		if (values[i] != value)
>> +			report_fail("Attribute 0x%x single value read (0x%lx) differs from the one read with multiple attributes (0x%lx)",
>> +				    i, value, values[i]);
>> +		/*
>> +		 * Preferred hart reset value is defined by SBI vendor
>> +		 */
>> +		if(i != SBI_SSE_ATTR_PREFERRED_HART) {
>                   ^ missing space
> 
>> +			/*
>> +			 * Specification states that injectable bit is implementation dependent
>> +			 * but other bits are zero-initialized.
>> +			 */
>> +			if (i == SBI_SSE_ATTR_STATUS)
>> +				value &= ~BIT(SBI_SSE_ATTR_STATUS_INJECT_OFFSET);
>> +			report(value == 0, "Attribute %s reset value is 0, found %lx", attr_name,
>> +			       value);
> 
> nit: no need to wrap the line
> 
>> +		}
>> +	}
>> +
>> +#if __riscv_xlen > 32
>> +	value = BIT(32);
>> +	ret = sbi_sse_write_attrs(event_id, SBI_SSE_ATTR_PRIORITY, 1, &value);
>> +	sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM, "Write invalid prio > 0xFFFFFFFF error");
>> +#endif
>> +
>> +	value = ~SBI_SSE_ATTR_CONFIG_ONESHOT;
>> +	ret = sbi_sse_write_attrs(event_id, SBI_SSE_ATTR_CONFIG, 1, &value);
>> +	sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM, "Write invalid config value error");
>> +
>> +	if (sbi_sse_event_is_global(event_id)) {
>> +		invalid_hart_str = getenv("INVALID_HART_ID");
>> +		if (!invalid_hart_str)
>> +			value = 0xFFFFFFFFUL;
>> +		else
>> +			value = strtoul(invalid_hart_str, NULL, 0);
>> +
>> +		ret = sbi_sse_write_attrs(event_id, SBI_SSE_ATTR_PREFERRED_HART, 1, &value);
>> +		sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM, "Set invalid hart id error");
>> +	} else {
>> +		/* Set Hart on local event -> RO */
>> +		value = current_thread_info()->hartid;
>> +		ret = sbi_sse_write_attrs(event_id, SBI_SSE_ATTR_PREFERRED_HART, 1, &value);
>> +		sbiret_report_error(&ret, SBI_ERR_DENIED,
>> +				    "Set hart id on local event error");
>> +	}
>> +
>> +	/* Set/get flags, sepc, a6, a7 */
>> +	for (i = 0; i < ARRAY_SIZE(interrupted_attrs); i++) {
>> +		attr_name = attr_names[interrupted_attrs[i]];
>> +		ret = sbi_sse_read_attrs(event_id, interrupted_attrs[i], 1, &value);
>> +		sbiret_report_error(&ret, SBI_SUCCESS, "Get interrupted %s", attr_name);
>> +
>> +		value = ARRAY_SIZE(interrupted_attrs) - i;
>> +		ret = sbi_sse_write_attrs(event_id, interrupted_attrs[i], 1, &value);
>> +		sbiret_report_error(&ret, SBI_ERR_INVALID_STATE,
>> +				    "Set attribute %s invalid state error", attr_name);
>> +	}
>> +
>> +	sse_read_write_test(event_id, SBI_SSE_ATTR_STATUS, 0, &value, SBI_ERR_INVALID_PARAM,
>> +			    "attribute attr_count == 0");
>> +	sse_read_write_test(event_id, SBI_SSE_ATTR_INTERRUPTED_A7 + 1, 1, &value, SBI_ERR_BAD_RANGE,
>> +			    "invalid attribute");
>> +
>> +	/* Misaligned pointer address */
>> +	ptr = (void *)&value;
>> +	ptr += 1;
>> +	sse_read_write_test(event_id, SBI_SSE_ATTR_STATUS, 1, ptr, SBI_ERR_INVALID_ADDRESS,
>> +		"attribute with invalid address");
>> +
>> +	report_prefix_pop();
>> +}
>> +
>> +static void sse_test_register_error(uint32_t event_id)
>> +{
>> +	struct sbiret ret;
>> +
>> +	report_prefix_push("register");
>> +
>> +	ret = sbi_sse_unregister(event_id);
>> +	sbiret_report_error(&ret, SBI_ERR_INVALID_STATE, "unregister non-registered event");
>> +
>> +	ret = sbi_sse_register_raw(event_id, 0x1, 0);
>> +	sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM, "register misaligned entry");
>> +
>> +	ret = sbi_sse_register_raw(event_id, (unsigned long)sbi_sse_entry, 0);
> 
> sbi_sse_register(event_id, sbi_sse_entry, NULL) to avoid a cast.
> 
>> +	sbiret_report_error(&ret, SBI_SUCCESS, "register");
>> +	if (ret.error)
>> +		goto done;
>> +
>> +	ret = sbi_sse_register_raw(event_id, (unsigned long)sbi_sse_entry, 0);
> 
> same
> 
>> +	sbiret_report_error(&ret, SBI_ERR_INVALID_STATE, "register used event failure");
>> +
>> +	ret = sbi_sse_unregister(event_id);
>> +	sbiret_report_error(&ret, SBI_SUCCESS, "unregister");
>> +
>> +done:
>> +	report_prefix_pop();
>> +}
>> +
>> +struct sse_simple_test_arg {
>> +	bool done;
>> +	unsigned long expected_a6;
>> +	uint32_t event_id;
>> +};
>> +
>> +#if __riscv_xlen > 32
>> +
>> +struct alias_test_params {
>> +	unsigned long event_id;
>> +	unsigned long attr_id;
>> +	unsigned long attr_count;
>> +	const char *str;
>> +};
>> +
>> +static void test_alias(uint32_t event_id)
>> +{
>> +	struct alias_test_params *write, *read;
>> +	unsigned long write_value, read_value;
>> +	struct sbiret ret;
>> +	bool err = false;
>> +	int r, w;
>> +	struct alias_test_params params[] = {
>> +		{event_id, SBI_SSE_ATTR_INTERRUPTED_A6, 1, "non aliased"},
>> +		{BIT(32) + event_id, SBI_SSE_ATTR_INTERRUPTED_A6, 1, "aliased event_id"},
>> +		{event_id, BIT(32) + SBI_SSE_ATTR_INTERRUPTED_A6, 1, "aliased attr_id"},
>> +		{event_id, SBI_SSE_ATTR_INTERRUPTED_A6, BIT(32) + 1, "aliased attr_count"},
>> +	};
>> +
>> +	report_prefix_push("alias");
>> +	for (w = 0; w < ARRAY_SIZE(params); w++) {
>> +		write = &params[w];
>> +
>> +		write_value = 0xDEADBEEF + w;
>> +		ret = sbi_sse_write_attrs(write->event_id, write->attr_id, write->attr_count, &write_value);
>> +		if (ret.error)
>> +			sbiret_report_error(&ret, SBI_SUCCESS, "Write %s, event 0x%lx attr 0x%lx, attr count 0x%lx", write->str, write->event_id, write->attr_id, write->attr_count);
> 
> I like long lines, but this one is too long even for me. I'd break it
> after the format string.
> 
>> +
>> +		for (r = 0; r < ARRAY_SIZE(params); r++) {
>> +			read = &params[r];
>> +			read_value = 0;
>> +			ret = sbi_sse_read_attrs(read->event_id, read->attr_id, read->attr_count, &read_value);
>> +			if (ret.error)
>> +				sbiret_report_error(&ret, SBI_SUCCESS,
>> +						    "Read %s, event 0x%lx attr 0x%lx, attr count 0x%lx", read->str, read->event_id, read->attr_id, read->attr_count);
> 
> same
> 
>> +
>> +			/* Do not spam output with a lot of reports */
>> +			if (write_value != read_value) {
>> +				err = true;
>> +				report_fail("Write %s, event 0x%lx attr 0x%lx, attr count 0x%lx value %lx =="
>> +					    "Read %s, event 0x%lx attr 0x%lx, attr count 0x%lx value %lx",
>> +				write->str, write->event_id, write->attr_id, write->attr_count,
>> +				write_value,
>> +				read->str, read->event_id, read->attr_id, read->attr_count,
>> +				read_value);
> 
> indentation is off
> 
>> +			}
>> +		}
>> +	}
>> +
>> +	report(!err, "BIT(32) aliasing tests");
>> +	report_prefix_pop();
>> +}
>> +#endif
>> +
>> +static void sse_simple_handler(void *data, struct pt_regs *regs, unsigned int hartid)
>> +{
>> +	struct sse_simple_test_arg *arg = data;
>> +	int i;
>> +	struct sbiret ret;
>> +	const char *attr_name;
>> +	uint32_t event_id = READ_ONCE(arg->event_id), attr;
>> +	unsigned long value, prev_value, flags;
>> +	unsigned long interrupted_state[ARRAY_SIZE(interrupted_attrs)];
>> +	unsigned long modified_state[ARRAY_SIZE(interrupted_attrs)] = {4, 3, 2, 1};
>> +	unsigned long tmp_state[ARRAY_SIZE(interrupted_attrs)];
>> +
>> +	report((regs->status & SR_SPP) == SR_SPP, "Interrupted S-mode");
>> +	report(hartid == current_thread_info()->hartid, "Hartid correctly passed");
>> +	sse_check_state(event_id, SBI_SSE_STATE_RUNNING);
>> +	report(!sse_event_pending(event_id), "Event not pending");
>> +
>> +	/* Read full interrupted state */
>> +	ret = sbi_sse_read_attrs(event_id, SBI_SSE_ATTR_INTERRUPTED_SEPC,
>> +				 ARRAY_SIZE(interrupted_attrs), interrupted_state);
>> +	sbiret_report_error(&ret, SBI_SUCCESS, "Save full interrupted state from handler");
>> +
>> +	/* Write full modified state and read it */
>> +	ret = sbi_sse_write_attrs(event_id, SBI_SSE_ATTR_INTERRUPTED_SEPC,
>> +				  ARRAY_SIZE(modified_state), modified_state);
>> +	sbiret_report_error(&ret, SBI_SUCCESS,
>> +			    "Write full interrupted state from handler");
>> +
>> +	ret = sbi_sse_read_attrs(event_id, SBI_SSE_ATTR_INTERRUPTED_SEPC,
>> +				ARRAY_SIZE(tmp_state), tmp_state);
>> +	sbiret_report_error(&ret, SBI_SUCCESS, "Read full modified state from handler");
>> +
>> +	report(memcmp(tmp_state, modified_state, sizeof(modified_state)) == 0,
>> +	       "Full interrupted state successfully written");
>> +
>> +#if __riscv_xlen > 32
>> +	test_alias(event_id);
>> +#endif
>> +
>> +	/* Restore full saved state */
>> +	ret = sbi_sse_write_attrs(event_id, SBI_SSE_ATTR_INTERRUPTED_SEPC,
>> +		ARRAY_SIZE(interrupted_attrs), interrupted_state);
> 
> indentation is off
> 
>> +	sbiret_report_error(&ret, SBI_SUCCESS,
>> +			    "Full interrupted state restore from handler");
> 
> no need to wrap
> 
>> +
>> +	/* We test SBI_SSE_ATTR_INTERRUPTED_FLAGS below with specific flag values */
>> +	for (i = 0; i < ARRAY_SIZE(interrupted_attrs); i++) {
>> +		attr = interrupted_attrs[i];
>> +		if (attr == SBI_SSE_ATTR_INTERRUPTED_FLAGS)
>> +			continue;
>> +
>> +		attr_name = attr_names[attr];
>> +
>> +		ret = sbi_sse_read_attrs(event_id, attr, 1, &prev_value);
>> +		sbiret_report_error(&ret, SBI_SUCCESS, "Get attr %s", attr_name);
>> +
>> +		value = 0xDEADBEEF + i;
>> +		ret = sbi_sse_write_attrs(event_id, attr, 1, &value);
>> +		sbiret_report_error(&ret, SBI_SUCCESS, "Set attr %s", attr_name);
>> +
>> +		ret = sbi_sse_read_attrs(event_id, attr, 1, &value);
>> +		sbiret_report_error(&ret, SBI_SUCCESS, "Get attr %s", attr_name);
>> +		report(value == 0xDEADBEEF + i, "Get attr %s, value: 0x%lx", attr_name,
>> +		       value);
> 
> no need to wrap
> 
>> +
>> +		ret = sbi_sse_write_attrs(event_id, attr, 1, &prev_value);
>> +		sbiret_report_error(&ret, SBI_SUCCESS, "Restore attr %s value", attr_name);
>> +	}
>> +
>> +	/* Test all flags allowed for SBI_SSE_ATTR_INTERRUPTED_FLAGS */
>> +	attr = SBI_SSE_ATTR_INTERRUPTED_FLAGS;
>> +	ret = sbi_sse_read_attrs(event_id, attr, 1, &prev_value);
>> +	sbiret_report_error(&ret, SBI_SUCCESS, "Save interrupted flags");
>> +
>> +	for (i = 0; i < ARRAY_SIZE(interrupted_flags); i++) {
>> +		flags = interrupted_flags[i];
>> +		ret = sbi_sse_write_attrs(event_id, attr, 1, &flags);
>> +		sbiret_report_error(&ret, SBI_SUCCESS,
>> +				    "Set interrupted flags bit 0x%lx value", flags);
>> +		ret = sbi_sse_read_attrs(event_id, attr, 1, &value);
>> +		sbiret_report_error(&ret, SBI_SUCCESS, "Get interrupted flags after set");
>> +		report(value == flags, "interrupted flags modified value: 0x%lx", value);
>> +	}
>> +
>> +	/* Write invalid bit in flag register */
>> +	flags = SBI_SSE_ATTR_INTERRUPTED_FLAGS_SSTATUS_SDT << 1;
>> +	ret = sbi_sse_write_attrs(event_id, attr, 1, &flags);
>> +	sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM, "Set invalid flags bit 0x%lx value error",
>> +			    flags);
>> +
> 
> no need to wrap

That's actually > 100 columns if unwrap.
> 
>> +	flags = BIT(SBI_SSE_ATTR_INTERRUPTED_FLAGS_SSTATUS_SDT + 1);
>> +	ret = sbi_sse_write_attrs(event_id, attr, 1, &flags);
>> +	sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM, "Set invalid flags bit 0x%lx value error",
>> +			    flags);
>> +
> 
> no need to wrap

Ditto

> 
>> +	ret = sbi_sse_write_attrs(event_id, attr, 1, &prev_value);
>> +	sbiret_report_error(&ret, SBI_SUCCESS, "Restore interrupted flags");
>> +
>> +	/* Try to change HARTID/Priority while running */
>> +	if (sbi_sse_event_is_global(event_id)) {
>> +		value = current_thread_info()->hartid;
>> +		ret = sbi_sse_write_attrs(event_id, SBI_SSE_ATTR_PREFERRED_HART, 1, &value);
>> +		sbiret_report_error(&ret, SBI_ERR_INVALID_STATE, "Set hart id while running error");
>> +	}
>> +
>> +	value = 0;
>> +	ret = sbi_sse_write_attrs(event_id, SBI_SSE_ATTR_PRIORITY, 1, &value);
>> +	sbiret_report_error(&ret, SBI_ERR_INVALID_STATE, "Set priority while running error");
>> +
>> +	value = READ_ONCE(arg->expected_a6);
>> +	report(interrupted_state[2] == value, "Interrupted state a6, expected 0x%lx, got 0x%lx",
>> +	       value, interrupted_state[2]);
>> +
>> +	report(interrupted_state[3] == SBI_EXT_SSE,
>> +	       "Interrupted state a7, expected 0x%x, got 0x%lx", SBI_EXT_SSE,
>> +	       interrupted_state[3]);
>> +
>> +	WRITE_ONCE(arg->done, true);
>> +}
>> +
>> +static int sse_test_inject_simple(uint32_t event_id)
>> +{
>> +	unsigned long value, error;
>> +	struct sbiret ret;
>> +	int err_ret = 1;
>> +	struct sse_simple_test_arg test_arg = {.event_id = event_id};
>> +	struct sbi_sse_handler_arg args = {
>> +		.handler = sse_simple_handler,
>> +		.handler_data = (void *)&test_arg,
>> +		.stack = sse_alloc_stack(),
>> +	};
>> +
>> +	report_prefix_push("simple");
>> +
>> +	if (!sse_check_state(event_id, SBI_SSE_STATE_UNUSED))
>> +		goto err;
>> +
>> +	ret = sbi_sse_register(event_id, &args);
>> +	if (!sbiret_report_error(&ret, SBI_SUCCESS, "register"))
>> +		goto err;
>> +
>> +	if (!sse_check_state(event_id, SBI_SSE_STATE_REGISTERED))
>> +		goto err;
>> +
>> +	if (sbi_sse_event_is_global(event_id)) {
>> +		/* Be sure global events are targeting the current hart */
>> +		error = sse_global_event_set_current_hart(event_id);
>> +		if (error)
>> +			goto err;
>> +	}
>> +
>> +	ret = sbi_sse_enable(event_id);
>> +	if (!sbiret_report_error(&ret, SBI_SUCCESS, "enable"))
>> +		goto err;
>> +
>> +	if (!sse_check_state(event_id, SBI_SSE_STATE_ENABLED))
>> +		goto err;
>> +
>> +	ret = sbi_sse_hart_mask();
>> +	if (!sbiret_report_error(&ret, SBI_SUCCESS, "hart mask"))
>> +		goto err;
>> +
>> +	ret = sbi_sse_inject(event_id, current_thread_info()->hartid);
>> +	if (!sbiret_report_error(&ret, SBI_SUCCESS, "injection masked")) {
>> +		sbi_sse_hart_unmask();
>> +		goto err;
>> +	}
>> +
>> +	report(READ_ONCE(test_arg.done) == 0, "event masked not handled");
>> +
>> +	/*
>> +	 * When unmasking the SSE events, we expect it to be injected
>> +	 * immediately so a6 should be SBI_EXT_SBI_SSE_HART_UNMASK
>> +	 */
>> +	WRITE_ONCE(test_arg.expected_a6, SBI_EXT_SSE_HART_UNMASK);
>> +	ret = sbi_sse_hart_unmask();
>> +	if (!sbiret_report_error(&ret, SBI_SUCCESS, "hart unmask")) {
>> +		goto err;
>> +	}
>> +
>> +	report(READ_ONCE(test_arg.done) == 1, "event unmasked handled");
>> +	WRITE_ONCE(test_arg.done, 0);
>> +	WRITE_ONCE(test_arg.expected_a6, SBI_EXT_SSE_INJECT);
>> +
>> +	/* Set as oneshot and verify it is disabled */
>> +	ret = sbi_sse_disable(event_id);
>> +	if (!sbiret_report_error(&ret, SBI_SUCCESS, "Disable event")) {
>> +		/* Nothing we can really do here, event can not be disabled */
>> +		goto err;
>> +	}
>> +
>> +	value = SBI_SSE_ATTR_CONFIG_ONESHOT;
>> +	ret = sbi_sse_write_attrs(event_id, SBI_SSE_ATTR_CONFIG, 1, &value);
>> +	if (!sbiret_report_error(&ret, SBI_SUCCESS, "Set event attribute as ONESHOT"))
>> +		goto err;
>> +
>> +	ret = sbi_sse_enable(event_id);
>> +	if (!sbiret_report_error(&ret, SBI_SUCCESS, "Enable event"))
>> +		goto err;
>> +
>> +	ret = sbi_sse_inject(event_id, current_thread_info()->hartid);
>> +	if (!sbiret_report_error(&ret, SBI_SUCCESS, "second injection"))
>> +		goto err;
>> +
>> +	report(READ_ONCE(test_arg.done) == 1, "event handled");
>> +	WRITE_ONCE(test_arg.done, 0);
>> +
>> +	if (!sse_check_state(event_id, SBI_SSE_STATE_REGISTERED))
>> +		goto err;
>> +
>> +	/* Clear ONESHOT FLAG */
>> +	value = 0;
>> +	ret = sbi_sse_write_attrs(event_id, SBI_SSE_ATTR_CONFIG, 1, &value);
>> +	if (!sbiret_report_error(&ret, SBI_SUCCESS, "Clear CONFIG.ONESHOT flag"))
>> +		goto err;
>> +
>> +	ret = sbi_sse_unregister(event_id);
>> +	if (!sbiret_report_error(&ret, SBI_SUCCESS, "unregister"))
>> +		goto err;
>> +
>> +	sse_check_state(event_id, SBI_SSE_STATE_UNUSED);
>> +
>> +	err_ret = 0;
>> +err:
>> +	sse_free_stack(args.stack);
>> +	report_prefix_pop();
>> +
>> +	return err_ret;
>> +}
>> +
>> +struct sse_foreign_cpu_test_arg {
>> +	bool done;
>> +	unsigned int expected_cpu;
>> +	uint32_t event_id;
>> +};
>> +
>> +static void sse_foreign_cpu_handler(void *data, struct pt_regs *regs, unsigned int hartid)
>> +{
>> +	struct sse_foreign_cpu_test_arg *arg = data;
>> +	unsigned int expected_cpu;
>> +
>> +	/* For arg content to be visible */
>> +	smp_rmb();
>> +	expected_cpu = READ_ONCE(arg->expected_cpu);
>> +	report(expected_cpu == current_thread_info()->cpu,
>> +	       "Received event on CPU (%d), expected CPU (%d)", current_thread_info()->cpu,
>> +	       expected_cpu);
>> +
>> +	WRITE_ONCE(arg->done, true);
>> +	/* For arg update to be visible for other CPUs */
>> +	smp_wmb();
>> +}
>> +
>> +struct sse_local_per_cpu {
>> +	struct sbi_sse_handler_arg args;
>> +	struct sbiret ret;
>> +	struct sse_foreign_cpu_test_arg handler_arg;
>> +};
>> +
>> +static void sse_register_enable_local(void *data)
>> +{
>> +	struct sbiret ret;
>> +	struct sse_local_per_cpu *cpu_args = data;
>> +	struct sse_local_per_cpu *cpu_arg = &cpu_args[current_thread_info()->cpu];
>> +	uint32_t event_id = cpu_arg->handler_arg.event_id;
>> +
>> +	ret = sbi_sse_register(event_id, &cpu_arg->args);
>> +	WRITE_ONCE(cpu_arg->ret, ret);
>> +	if (ret.error)
>> +		return;
>> +
>> +	ret = sbi_sse_enable(event_id);
>> +	WRITE_ONCE(cpu_arg->ret, ret);
>> +}
>> +
>> +static void sbi_sse_disable_unregister_local(void *data)
>> +{
>> +	struct sbiret ret;
>> +	struct sse_local_per_cpu *cpu_args = data;
>> +	struct sse_local_per_cpu *cpu_arg = &cpu_args[current_thread_info()->cpu];
>> +	uint32_t event_id = cpu_arg->handler_arg.event_id;
>> +
>> +	ret = sbi_sse_disable(event_id);
>> +	WRITE_ONCE(cpu_arg->ret, ret);
>> +	if (ret.error)
>> +		return;
>> +
>> +	ret = sbi_sse_unregister(event_id);
>> +	WRITE_ONCE(cpu_arg->ret, ret);
>> +}
>> +
>> +static int sse_test_inject_local(uint32_t event_id)
>> +{
>> +	int cpu;
>> +	int err_ret = 1;
>> +	struct sbiret ret;
>> +	struct sse_local_per_cpu *cpu_args, *cpu_arg;
>> +	struct sse_foreign_cpu_test_arg *handler_arg;
>> +
>> +	cpu_args = calloc(NR_CPUS, sizeof(struct sbi_sse_handler_arg));
>> +
>> +	report_prefix_push("local_dispatch");
>> +	for_each_online_cpu(cpu) {
>> +		cpu_arg = &cpu_args[cpu];
>> +		cpu_arg->handler_arg.event_id = event_id;
>> +		cpu_arg->args.stack = sse_alloc_stack();
>> +		cpu_arg->args.handler = sse_foreign_cpu_handler;
>> +		cpu_arg->args.handler_data = (void *)&cpu_arg->handler_arg;
>> +	}
>> +
>> +	on_cpus(sse_register_enable_local, cpu_args);
>> +	for_each_online_cpu(cpu) {
>> +		cpu_arg = &cpu_args[cpu];
>> +		ret = cpu_arg->ret;
>> +		if (ret.error) {
>> +			report_fail("CPU failed to register/enable event: %ld", ret.error);
>> +			goto err;
>> +		}
>> +
>> +		handler_arg = &cpu_arg->handler_arg;
>> +		WRITE_ONCE(handler_arg->expected_cpu, cpu);
>> +		/* For handler_arg content to be visible for other CPUs */
>> +		smp_wmb();
>> +		ret = sbi_sse_inject(event_id, cpus[cpu].hartid);
>> +		if (ret.error) {
>> +			report_fail("CPU failed to inject event: %ld", ret.error);
>> +			goto err;
>> +		}
>> +	}
>> +
>> +	for_each_online_cpu(cpu) {
>> +		handler_arg = &cpu_args[cpu].handler_arg;
>> +		smp_rmb();
>> +		while (!READ_ONCE(handler_arg->done)) {
>> +			/* For handler_arg update to be visible */
>> +			smp_rmb();
>> +			cpu_relax();
>> +		}
>> +		WRITE_ONCE(handler_arg->done, false);
>> +	}
>> +
>> +	on_cpus(sbi_sse_disable_unregister_local, cpu_args);
>> +	for_each_online_cpu(cpu) {
>> +		cpu_arg = &cpu_args[cpu];
>> +		ret = READ_ONCE(cpu_arg->ret);
>> +		if (ret.error) {
>> +			report_fail("CPU failed to disable/unregister event: %ld", ret.error);
>> +			goto err;
>> +		}
>> +	}
>> +
>> +	err_ret = 0;
>> +err:
>> +	for_each_online_cpu(cpu) {
>> +		cpu_arg = &cpu_args[cpu];
>> +		sse_free_stack(cpu_arg->args.stack);
>> +	}
>> +
>> +	report_pass("local event dispatch on all CPUs");
>> +	report_prefix_pop();
>> +
>> +	return err_ret;
>> +}
>> +
>> +static int sse_test_inject_global(uint32_t event_id)
>> +{
>> +	unsigned long value;
>> +	struct sbiret ret;
>> +	unsigned int cpu;
>> +	uint64_t timeout;
>> +	int err_ret = 1;
>> +	struct sse_foreign_cpu_test_arg test_arg = {.event_id = event_id};
>> +	struct sbi_sse_handler_arg args = {
>> +		.handler = sse_foreign_cpu_handler,
>> +		.handler_data = (void *)&test_arg,
>> +		.stack = sse_alloc_stack(),
>> +	};
>> +	enum sbi_sse_state state;
>> +
>> +	report_prefix_push("global_dispatch");
>> +
>> +	ret = sbi_sse_register(event_id, &args);
>> +	if (!sbiret_report_error(&ret, SBI_SUCCESS, "Register event"))
>> +		goto err;
>> +
>> +	for_each_online_cpu(cpu) {
>> +		WRITE_ONCE(test_arg.expected_cpu, cpu);
>> +		/* For test_arg content to be visible for other CPUs */
>> +		smp_wmb();
>> +		value = cpu;
>> +		ret = sbi_sse_write_attrs(event_id, SBI_SSE_ATTR_PREFERRED_HART, 1, &value);
>> +		if (!sbiret_report_error(&ret, SBI_SUCCESS, "Set preferred hart"))
>> +			goto err;
>> +
>> +		ret = sbi_sse_enable(event_id);
>> +		if (!sbiret_report_error(&ret, SBI_SUCCESS, "Enable event"))
>> +			goto err;
>> +
>> +		ret = sbi_sse_inject(event_id, cpu);
>> +		if (!sbiret_report_error(&ret, SBI_SUCCESS, "Inject event"))
>> +			goto err;
>> +
>> +		smp_rmb();
>> +		while (!READ_ONCE(test_arg.done)) {
>> +			/* For shared test_arg structure */
>> +			smp_rmb();
>> +			cpu_relax();
>> +		}
>> +
>> +		WRITE_ONCE(test_arg.done, false);
>> +
>> +		timeout = timer_get_cycles() + usec_to_cycles((uint64_t)1000);
> 
> Should probably add an environment variable for this timeout and then use
> 1000 as the default when the variable isn't set.

Ack.

> 
>> +		/* Wait for event to be back in ENABLED state */
>> +		do {
>> +			ret = sse_event_get_state(event_id, &state);
>> +			if (ret.error)
>> +				goto err;
>> +			cpu_relax();
>> +		} while (state != SBI_SSE_STATE_ENABLED || timer_get_cycles() < timeout);
> 
>                                                         ^ &&
>> +
>> +		if (!report(state == SBI_SSE_STATE_ENABLED,
>> +		    "wait for event to be in enable state"))
> 
> nit: no need to wrap this line, but if we do, then "wait should be under
> state
> 
>> +			goto err;
>> +
>> +		ret = sbi_sse_disable(event_id);
>> +		if (!sbiret_report_error(&ret, SBI_SUCCESS, "Disable event"))
>> +			goto err;
>> +
>> +		report_pass("Global event on CPU %d", cpu);
>> +	}
>> +
>> +	ret = sbi_sse_unregister(event_id);
>> +	sbiret_report_error(&ret, SBI_SUCCESS, "Unregister event");
>> +
>> +	err_ret = 0;
>> +
>> +err:
>> +	sse_free_stack(args.stack);
>> +	report_prefix_pop();
>> +
>> +	return err_ret;
>> +}
>> +
>> +struct priority_test_arg {
>> +	uint32_t event_id;
>> +	bool called;
>> +	u32 prio;
>> +	struct priority_test_arg *next_event_arg;
>> +	void (*check_func)(struct priority_test_arg *arg);
>> +};
>> +
>> +static void sse_hi_priority_test_handler(void *arg, struct pt_regs *regs,
>> +					 unsigned int hartid)
>> +{
>> +	struct priority_test_arg *targ = arg;
>> +	struct priority_test_arg *next = targ->next_event_arg;
>> +
>> +	targ->called = true;
>> +	if (next) {
>> +		sbi_sse_inject(next->event_id, current_thread_info()->hartid);
>> +
>> +		report(!sse_event_pending(next->event_id), "Higher priority event is not pending");
>> +		report(next->called, "Higher priority event was handled");
>> +	}
>> +}
>> +
>> +static void sse_low_priority_test_handler(void *arg, struct pt_regs *regs,
>> +					  unsigned int hartid)
>> +{
>> +	struct priority_test_arg *targ = arg;
>> +	struct priority_test_arg *next = targ->next_event_arg;
>> +
>> +	targ->called = true;
>> +
>> +	if (next) {
>> +		sbi_sse_inject(next->event_id, current_thread_info()->hartid);
>> +
>> +		report(sse_event_pending(next->event_id), "Lower priority event is pending");
>> +		report(!next->called, "Lower priority event %s was not handle before %s",
> 
> handled
> 
>> +		       sse_event_name(next->event_id), sse_event_name(targ->event_id));
>> +	}
>> +}
>> +
>> +static void sse_test_injection_priority_arg(struct priority_test_arg *in_args,
>> +					    unsigned int in_args_size,
>> +					    sbi_sse_handler_fn handler,
>> +					    const char *test_name)
>> +{
>> +	unsigned int i;
>> +	unsigned long value, uret;
>> +	struct sbiret ret;
>> +	uint32_t event_id;
>> +	struct priority_test_arg *arg;
>> +	unsigned int args_size = 0;
>> +	struct sbi_sse_handler_arg event_args[in_args_size];
>> +	struct priority_test_arg *args[in_args_size];
>> +	void *stack;
>> +	struct sbi_sse_handler_arg *event_arg;
>> +
>> +	report_prefix_push(test_name);
>> +
>> +	for (i = 0; i < in_args_size; i++) {
>> +		arg = &in_args[i];
>> +		event_id = arg->event_id;
>> +		if (!sse_event_can_inject(event_id))
>> +			continue;
>> +
>> +		args[args_size] = arg;
>> +		args_size++;
>> +		event_args->stack = 0;
>> +	}
>> +
>> +	if (!args_size) {
>> +		report_skip("No injectable events");
>> +		goto skip;
>> +	}
>> +
>> +	for (i = 0; i < args_size; i++) {
>> +		arg = args[i];
>> +		event_id = arg->event_id;
>> +		stack = sse_alloc_stack();
>> +
>> +		event_arg = &event_args[i];
>> +		event_arg->handler = handler;
>> +		event_arg->handler_data = (void *)arg;
>> +		event_arg->stack = stack;
>> +
>> +		if (i < (args_size - 1))
>> +			arg->next_event_arg = args[i + 1];
>> +		else
>> +			arg->next_event_arg = NULL;
>> +
>> +		/* Be sure global events are targeting the current hart */
>> +		if (sbi_sse_event_is_global(event_id)) {
>> +			uret = sse_global_event_set_current_hart(event_id);
>> +			if (uret)
>> +				goto err;
> 
> If we goto err from here or the next goto, then we'll also get disable and
> unregister failures reported.
> 
>> +		}
>> +
>> +		ret = sbi_sse_register(event_id, event_arg);
>> +		if (ret.error) {
>> +			sbiret_report_error(&ret, SBI_SUCCESS, "register event 0x%x", event_id);
>> +			goto err;
>> +		}
>> +
>> +		value = arg->prio;
>> +		ret = sbi_sse_write_attrs(event_id, SBI_SSE_ATTR_PRIORITY, 1, &value);
>> +		if (ret.error) {
>> +			sbiret_report_error(&ret, SBI_SUCCESS, "set event 0x%x priority", event_id);
>> +			goto err;
> 
> from here we'll get disable failures reported.
> 
>> +		}
>> +		ret = sbi_sse_enable(event_id);
>> +		if (ret.error) {
>> +			sbiret_report_error(&ret, SBI_SUCCESS, "enable event 0x%x", event_id);
>> +			goto err;
>> +		}
>> +	}
> 
> It looks like we need a complete
> 
> if (!a)
>    goto a_out;
> if (!b)
>    goto b_out;
> 
> /* ret = success */
> 
> b_out:
>   /* undo b */
> a_out:
>   /* undo a */
> 
> return ret;
> 
> type of model. Or just manage it directly.
> 
>  if (!a)
>   ...
>  if (!b) {
>   /* undo a */
>   ...
>  }
> 
>> +
>> +	/* Inject first event */
>> +	ret = sbi_sse_inject(args[0]->event_id, current_thread_info()->hartid);
>> +	sbiret_report_error(&ret, SBI_SUCCESS, "injection");
>> +
>> +err:
>> +	for (i = 0; i < args_size; i++) {
>> +		arg = args[i];
>> +		event_id = arg->event_id;
>> +
>> +		report(arg->called, "Event %s handler called", sse_event_name(arg->event_id));
>> +
>> +		ret = sbi_sse_disable(event_id);
>> +		if (ret.error)
>> +			sbiret_report_error(&ret, SBI_SUCCESS, "disable event 0x%x", event_id);
>> +
>> +		sbi_sse_unregister(event_id);
>> +		if (ret.error)
>> +			sbiret_report_error(&ret, SBI_SUCCESS, "unregister event 0x%x", event_id);
>> +
>> +		event_arg = &event_args[i];
>> +		if (event_arg->stack)
>> +			sse_free_stack(event_arg->stack);
>> +	}
>> +
>> +skip:
>> +	report_prefix_pop();
>> +}
>> +
>> +static struct priority_test_arg hi_prio_args[] = {
>> +	{.event_id = SBI_SSE_EVENT_GLOBAL_SOFTWARE},
>> +	{.event_id = SBI_SSE_EVENT_LOCAL_SOFTWARE},
>> +	{.event_id = SBI_SSE_EVENT_GLOBAL_LOW_PRIO_RAS},
>> +	{.event_id = SBI_SSE_EVENT_LOCAL_LOW_PRIO_RAS},
>> +	{.event_id = SBI_SSE_EVENT_LOCAL_PMU_OVERFLOW},
>> +	{.event_id = SBI_SSE_EVENT_GLOBAL_HIGH_PRIO_RAS},
>> +	{.event_id = SBI_SSE_EVENT_LOCAL_DOUBLE_TRAP},
>> +	{.event_id = SBI_SSE_EVENT_LOCAL_HIGH_PRIO_RAS},
>> +};
>> +
>> +static struct priority_test_arg low_prio_args[] = {
>> +	{.event_id = SBI_SSE_EVENT_LOCAL_HIGH_PRIO_RAS},
>> +	{.event_id = SBI_SSE_EVENT_LOCAL_DOUBLE_TRAP},
>> +	{.event_id = SBI_SSE_EVENT_GLOBAL_HIGH_PRIO_RAS},
>> +	{.event_id = SBI_SSE_EVENT_LOCAL_PMU_OVERFLOW},
>> +	{.event_id = SBI_SSE_EVENT_LOCAL_LOW_PRIO_RAS},
>> +	{.event_id = SBI_SSE_EVENT_GLOBAL_LOW_PRIO_RAS},
>> +	{.event_id = SBI_SSE_EVENT_LOCAL_SOFTWARE},
>> +	{.event_id = SBI_SSE_EVENT_GLOBAL_SOFTWARE},
>> +};
>> +
>> +static struct priority_test_arg prio_args[] = {
>> +	{.event_id = SBI_SSE_EVENT_GLOBAL_SOFTWARE,		.prio = 5},
>> +	{.event_id = SBI_SSE_EVENT_LOCAL_SOFTWARE,		.prio = 10},
>> +	{.event_id = SBI_SSE_EVENT_LOCAL_LOW_PRIO_RAS,		.prio = 12},
>> +	{.event_id = SBI_SSE_EVENT_LOCAL_PMU_OVERFLOW,		.prio = 15},
>> +	{.event_id = SBI_SSE_EVENT_GLOBAL_HIGH_PRIO_RAS,	.prio = 20},
>> +	{.event_id = SBI_SSE_EVENT_GLOBAL_LOW_PRIO_RAS, 	.prio = 22},
>> +	{.event_id = SBI_SSE_EVENT_LOCAL_HIGH_PRIO_RAS, 	.prio = 25},
>> +};
>> +
>> +static struct priority_test_arg same_prio_args[] = {
>> +	{.event_id = SBI_SSE_EVENT_LOCAL_PMU_OVERFLOW,		.prio = 0},
>> +	{.event_id = SBI_SSE_EVENT_GLOBAL_LOW_PRIO_RAS,		.prio = 0},
>> +	{.event_id = SBI_SSE_EVENT_LOCAL_HIGH_PRIO_RAS,		.prio = 10},
>> +	{.event_id = SBI_SSE_EVENT_LOCAL_SOFTWARE,		.prio = 10},
>> +	{.event_id = SBI_SSE_EVENT_GLOBAL_SOFTWARE,		.prio = 10},
>> +	{.event_id = SBI_SSE_EVENT_GLOBAL_HIGH_PRIO_RAS,	.prio = 20},
>> +	{.event_id = SBI_SSE_EVENT_LOCAL_LOW_PRIO_RAS,		.prio = 20},
>> +};
>> +
>> +static void sse_test_injection_priority(void)
>> +{
>> +	report_prefix_push("prio");
>> +
>> +	sse_test_injection_priority_arg(hi_prio_args, ARRAY_SIZE(hi_prio_args),
>> +					sse_hi_priority_test_handler, "high");
>> +
>> +	sse_test_injection_priority_arg(low_prio_args, ARRAY_SIZE(low_prio_args),
>> +					sse_low_priority_test_handler, "low");
>> +
>> +	sse_test_injection_priority_arg(prio_args, ARRAY_SIZE(prio_args),
>> +					sse_low_priority_test_handler, "changed");
>> +
>> +	sse_test_injection_priority_arg(same_prio_args, ARRAY_SIZE(same_prio_args),
>> +					sse_low_priority_test_handler, "same_prio_args");
>> +
>> +	report_prefix_pop();
>> +}
>> +
>> +static void test_invalid_event_id(unsigned long event_id)
>> +{
>> +	struct sbiret ret;
>> +	unsigned long value = 0;
>> +
>> +	ret = sbi_sse_register_raw(event_id, (unsigned long) sbi_sse_entry, 0);
>> +	sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM,
>> +			    "register event_id 0x%lx", event_id);
>> +
>> +	ret = sbi_sse_unregister(event_id);
>> +	sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM,
>> +			"unregister event_id 0x%lx", event_id);
>> +
>> +	ret = sbi_sse_enable(event_id);
>> +	sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM,
>> +			    "enable event_id 0x%lx", event_id);
>> +
>> +	ret = sbi_sse_disable(event_id);
>> +	sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM,
>> +			    "disable event_id 0x%lx", event_id);
>> +
>> +	ret = sbi_sse_inject(event_id, 0);
>> +	sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM,
>> +			    "inject event_id 0x%lx", event_id);
>> +
>> +	ret = sbi_sse_write_attrs(event_id, SBI_SSE_ATTR_PRIORITY, 1, &value);
>> +	sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM,
>> +			    "write attr event_id 0x%lx", event_id);
>> +
>> +	ret = sbi_sse_read_attrs(event_id, SBI_SSE_ATTR_PRIORITY, 1, &value);
>> +	sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM,
>> +			    "read attr event_id 0x%lx", event_id);
>> +}
>> +
>> +static void sse_test_invalid_event_id(void)
>> +{
>> +
>> +	report_prefix_push("event_id");
>> +
>> +	test_invalid_event_id(SBI_SSE_EVENT_LOCAL_RESERVED_0_START);
>> +
>> +	report_prefix_pop();
>> +}
>> +
>> +static void sse_check_event_availability(uint32_t event_id, bool *can_inject, bool *supported)
>> +{
>> +	unsigned long status;
>> +	struct sbiret ret;
>> +
>> +	*can_inject = false;
>> +	*supported = false;
>> +
>> +	ret = sbi_sse_read_attrs(event_id, SBI_SSE_ATTR_STATUS, 1, &status);
>> +	if (ret.error != SBI_SUCCESS && ret.error != SBI_ERR_NOT_SUPPORTED) {
>> +		report_fail("Get event status != SBI_SUCCESS && != SBI_ERR_NOT_SUPPORTED: %ld", ret.error);
>> +		return;
>> +	}
>> +	if (ret.error == SBI_ERR_NOT_SUPPORTED)
>> +		return;
>> +
>> +	if (!ret.error)
>> +		*supported = true;
>> +
>> +	*can_inject = (status >> SBI_SSE_ATTR_STATUS_INJECT_OFFSET) & 1;
> 
> this should also be under the 'if (!ret.error)'

the 'if (!ret.error)' is actually useless since at that point it is == 0
(ie based on the two 'if's above.

> 
>> +}
>> +
>> +static void sse_secondary_boot_and_unmask(void *data)
>> +{
>> +	sbi_sse_hart_unmask();
>> +}
>> +
>> +static void sse_check_mask(void)
>> +{
>> +	struct sbiret ret;
>> +
>> +	/* Upon boot, event are masked, check that */
>> +	ret = sbi_sse_hart_mask();
>> +	sbiret_report_error(&ret, SBI_ERR_ALREADY_STOPPED, "hart mask at boot time");
>> +
>> +	ret = sbi_sse_hart_unmask();
>> +	sbiret_report_error(&ret, SBI_SUCCESS, "hart unmask");
>> +	ret = sbi_sse_hart_unmask();
>> +	sbiret_report_error(&ret, SBI_ERR_ALREADY_STARTED, "hart unmask twice error");
>> +
>> +	ret = sbi_sse_hart_mask();
>> +	sbiret_report_error(&ret, SBI_SUCCESS, "hart mask");
>> +	ret = sbi_sse_hart_mask();
>> +	sbiret_report_error(&ret, SBI_ERR_ALREADY_STOPPED, "hart mask twice");
>> +}
>> +
>> +static int run_inject_test(struct sse_event_info *info)
>> +{
>> +	unsigned long event_id = info->event_id;
>> +
>> +	if (!info->can_inject) {
>> +		report_skip("Event does not support injection, skipping injection tests");
>> +		return 0;
>> +	}
>> +
>> +	if (sse_test_inject_simple(event_id))
>> +		return 1;
>> +
>> +	if (sbi_sse_event_is_global(event_id))
>> +		return sse_test_inject_global(event_id);
>> +	else
>> +		return sse_test_inject_local(event_id);
>> +}
>> +
>> +void check_sse(void)
>> +{
>> +	struct sse_event_info *info;
>> +	unsigned long i, event_id;
>> +	bool supported;
>> +
>> +	report_prefix_push("sse");
>> +
>> +	if (!sbi_probe(SBI_EXT_SSE)) {
>> +		report_skip("extension not available");
>> +		report_prefix_pop();
>> +		return;
>> +	}
>> +
>> +	sse_check_mask();
>> +
>> +	/*
>> +	 * Dummy wakeup of all processors since some of them will be targeted
>> +	 * by global events without going through the wakeup call as well as
>> +	 * unmasking SSE events on all harts
>> +	 */
>> +	on_cpus(sse_secondary_boot_and_unmask, NULL);
>> +
>> +	sse_test_invalid_event_id();
>> +
>> +	for (i = 0; i < ARRAY_SIZE(sse_event_infos); i++) {
>> +		info = &sse_event_infos[i];
>> +		event_id = info->event_id;
>> +		report_prefix_push(info->name);
>> +		sse_check_event_availability(event_id, &info->can_inject, &supported);
>> +		if (!supported) {
>> +			report_skip("Event is not supported, skipping tests");
>> +			report_prefix_pop();
>> +			continue;
>> +		}
>> +
>> +		sse_test_attrs(event_id);
>> +		sse_test_register_error(event_id);
>> +
>> +		if (run_inject_test(info)) {
>> +			report_skip("Event test failed, event state unreliable");
>> +			info->can_inject = false;
>> +		}
>> +
>> +		report_prefix_pop();
>> +	}
>> +
>> +	sse_test_injection_priority();
>> +
>> +	report_prefix_pop();
>> +}
>> diff --git a/riscv/sbi.c b/riscv/sbi.c
>> index 0404bb81..478cb35d 100644
>> --- a/riscv/sbi.c
>> +++ b/riscv/sbi.c
>> @@ -32,6 +32,7 @@
>>  
>>  #define	HIGH_ADDR_BOUNDARY	((phys_addr_t)1 << 32)
>>  
>> +void check_sse(void);
>>  void check_fwft(void);
>>  
>>  static long __labs(long a)
>> @@ -1567,6 +1568,7 @@ int main(int argc, char **argv)
>>  	check_hsm();
>>  	check_dbcn();
>>  	check_susp();
>> +	check_sse();
>>  	check_fwft();
>>  
>>  	return report_summary();
>> -- 
>> 2.47.2
>>
> 
> Thanks,
> drew


