Return-Path: <kvm+bounces-40244-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3456EA54DD5
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 15:32:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 49DED3AA58B
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 14:32:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D0CA1624DA;
	Thu,  6 Mar 2025 14:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="yNhCDuRQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 814C2149DF0
	for <kvm@vger.kernel.org>; Thu,  6 Mar 2025 14:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741271566; cv=none; b=Bh1jWce6sUySTqMpkLlr4HaXwXPB2Ust9K2RtWfK558z+r3lgAZwfD454/7KjClOu3h8D6Q60mdajeig2kIc1JHJKd5nESpzODNRKPHbehs5twjE3ug5tTb3UQ3S2NRfe9e8CUzQ+XItIkmWVd6QkLf38AdrdIAfoFqaWx98v14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741271566; c=relaxed/simple;
	bh=sKtzz5jYkUPxPCkC8UCGYE84t5HCXjsZTyCJG9fvbmo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X9sM4V/awKHxOtdQjAnFkWcdgGsGUp5ahLSjnuwXY/v4UEAwNTSM44D//uM01rfx9FxjQvwC6Rd7owCM9pMXoL4RkzgtkM/kzyQ1M0IHpsh1007eQL5Wlrx1fTftRtIo0nFHcDX0LmLnCyLud466txkzDodmdbKF4+dJCtSMXL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=yNhCDuRQ; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-43bd87f7c2eso4404345e9.3
        for <kvm@vger.kernel.org>; Thu, 06 Mar 2025 06:32:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1741271561; x=1741876361; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=q8/0wioZiEwVfUtPILJTA+wlnEDL8jDhZ1I8vdn+KCg=;
        b=yNhCDuRQCw/Ybj/7USBaBycrHXuVU7tQfYb8hitb0rAMLe1INM5nCfyLca/yiTf449
         uYFz/kkk5p6Spt6/qRqnJP5SuigmQ65frnNb5u8BWxpspF/U1KCLtdCxN1bss+jAM6Ye
         h44Ij6MVC54g+cCOuUqWpS0vdFWNT8mp23D65W7Z+uj+ZN8rh6jr7nLGAvKSZWMrexGX
         23Cg30fjdY/tijKAl1GXkhulqTtdCcj/IEjVUVZVj3vwgH+wxHFFCcyPRLmfa0RGCkAB
         qxWRbxrXYRJv8k0sV2E/rR8J6YAKNTfG0jx0ArCwxcPkqFxlm6rC4Z+agd/pb6vZP2zn
         W7Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741271561; x=1741876361;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q8/0wioZiEwVfUtPILJTA+wlnEDL8jDhZ1I8vdn+KCg=;
        b=FZWHPxST7YkLtywk58Y5/3+951nQnX2A3t7TPOI5fC3d9lBChFwszRpSl8GoGvvuFO
         Dx9b68bV3XgG3uczYz6rmfE/YWXv8kr12iAzyVGENw7jnyytzR9CdSCyfTKwM+X1qqpm
         ZTDWVEhUT92ksYwKvgQahoGHCYqhIUQgnf7jA3K3z3a0vg/CxKIWMXwgjgvAhAFKtpSE
         f2LVwELsdEe65kwJi63kcKd96+rkKuArGm5MFvkSodoDCu5An0uJ4gkgOOvilvD4u0JB
         rfetwiy2UJ3qgnyqspSIdQajBsmKpxvpFfAWfHz06aD84kMM5IF2luvfNiJLWivw+PKT
         mK+g==
X-Gm-Message-State: AOJu0YxsUCgBKklcHYfDlpAc/qnEcXKOu/9IKiUdjN5qtXrfnatjX3um
	DwpNbQNjdOJff8lArb1WgNunrs8NKcXSqcYtbQFrb6deI1Ph0oQljtCiRlr5VIs=
X-Gm-Gg: ASbGncsgwyScfnNCgqYbqkne18apy7Di6/WTL8dPKzIycdW0MSR0kpLpX91VtXTHNKr
	9acPa/nSEWikjIJ93cIlU5jt9UZHVzck0Eo6OfoeQmM3PKRzHqU9vr4kEsDQlzm7dBawHLVYrhf
	vEly6XvLVRmGdeTgcvrIU2WrhmmxWysEFDDAPZkSS/I/iF3HR3TsbzHAbUdGoJ7mPFHYarnDY7Q
	F4IMKKdWmKiTJ9/9SRXXRFGPIf+Z4Vp9YBhaIhueA/bbH6mP2uV68ecRZbO9GBthbJwZA9vINKK
	P5Gc2/1iA0tIRY7z7av+3GmMa/MZwbxR82Wr86dkxLBQxaWNk/UIpjJ/hFDOV4CtU9VVsBne9nr
	LY09nEsDqH+qqjw==
X-Google-Smtp-Source: AGHT+IGMeCm8z14k8n0EVV9EiflyBoD2cQ5tHXwsCtPmOREI8T3gTGyQZB/DH3cpdgHuEtPh+8X0vQ==
X-Received: by 2002:a05:600c:46ca:b0:43b:c7ad:55c2 with SMTP id 5b1f17b1804b1-43bd2929dd6mr63281235e9.6.1741271560356;
        Thu, 06 Mar 2025 06:32:40 -0800 (PST)
Received: from ?IPV6:2a01:e0a:e17:9700:16d2:7456:6634:9626? ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43bdd9471b7sm21273965e9.34.2025.03.06.06.32.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Mar 2025 06:32:39 -0800 (PST)
Message-ID: <d37dc38b-ba6d-48cd-8d23-9e2ce9c6581e@rivosinc.com>
Date: Thu, 6 Mar 2025 15:32:39 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v7 6/6] riscv: sbi: Add SSE extension tests
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 Andrew Jones <ajones@ventanamicro.com>, Anup Patel
 <apatel@ventanamicro.com>, Atish Patra <atishp@rivosinc.com>
References: <20250214114423.1071621-1-cleger@rivosinc.com>
 <20250214114423.1071621-7-cleger@rivosinc.com>
 <20250227-93a15f012d9bda941ef44e38@orel>
Content-Language: en-US
From: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
In-Reply-To: <20250227-93a15f012d9bda941ef44e38@orel>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 28/02/2025 18:51, Andrew Jones wrote:
> 
> Global style note: For casts we prefer no space between the (type) and
> the variable, i.e. (type)var
> 
> On Fri, Feb 14, 2025 at 12:44:19PM +0100, Clément Léger wrote:
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
>>  riscv/Makefile  |    1 +
>>  riscv/sbi-sse.c | 1054 +++++++++++++++++++++++++++++++++++++++++++++++
>>  riscv/sbi.c     |    2 +
>>  3 files changed, 1057 insertions(+)
>>  create mode 100644 riscv/sbi-sse.c
>>
>> diff --git a/riscv/Makefile b/riscv/Makefile
>> index ed590ede..ea62e05f 100644
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
>> diff --git a/riscv/sbi-sse.c b/riscv/sbi-sse.c
>> new file mode 100644
>> index 00000000..27f47f73
>> --- /dev/null
>> +++ b/riscv/sbi-sse.c
>> @@ -0,0 +1,1054 @@
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
>> +#include <asm/io.h>
>> +#include <asm/page.h>
>> +#include <asm/processor.h>
>> +#include <asm/sbi.h>
>> +#include <asm/sbi-sse.h>
>> +#include <asm/setup.h>
>> +
>> +#include "sbi-tests.h"
>> +
>> +#define SSE_STACK_SIZE	PAGE_SIZE
>> +
>> +void check_sse(void);
> 
> Since we now have an #ifndef __ASSEMBLY__ section in riscv/sbi-tests.h we
> can just put this prototype there.
> 
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
>> +static struct sbiret sse_event_get_state(uint32_t event_id, enum sbi_sse_state *state)
>> +{
>> +	struct sbiret ret;
>> +	unsigned long status;
>> +
>> +	ret = sbi_sse_read_attrs(event_id, SBI_SSE_ATTR_STATUS, 1, &status);
>> +	if (ret.error) {
>> +		sbiret_report_error(&ret, 0, "Get SSE event status no error");
>> +		return ret;
>> +	}
>> +
>> +	*state = status & SBI_SSE_ATTR_STATUS_STATE_MASK;
>> +
>> +	return ret;
>> +}
>> +
>> +static void sse_global_event_set_current_hart(uint32_t event_id)
>> +{
>> +	struct sbiret ret;
>> +	unsigned long current_hart = current_thread_info()->hartid;
>> +
>> +	if (!sbi_sse_event_is_global(event_id))
>> +		return;
>> +
>> +	ret = sbi_sse_write_attrs(event_id, SBI_SSE_ATTR_PREFERRED_HART, 1, &current_hart);
>> +	if (ret.error)
>> +		report_abort("set preferred hart failure, error %ld", ret.error);
> 
> Are we sure we want to abort? Or should we try to propagate an error from
> here and just bail out of SSE tests?
> 
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
>> +	report(state == expected_state, "SSE event status == %ld", expected_state);
>> +
>> +	return state == expected_state;
> 
> Can just write
> 
>   return report(state == expected_state, "SSE event status == %ld", expected_state);
> 
>> +}
>> +
>> +static bool sse_event_pending(uint32_t event_id)
>> +{
>> +	struct sbiret ret;
>> +	unsigned long status;
>> +
>> +	ret = sbi_sse_read_attrs(event_id, SBI_SSE_ATTR_STATUS, 1, &status);
>> +	if (ret.error) {
>> +		report_fail("Failed to get SSE event status, error %ld", ret.error);
> 
> sbiret_report_error()
> 
>> +		return false;
>> +	}
>> +
>> +	return !!(status & BIT(SBI_SSE_ATTR_STATUS_PENDING_OFFSET));
>> +}
>> +
>> +static void *sse_alloc_stack(void)
>> +{
>> +	/*
>> +	 * We assume that SSE_STACK_SIZE always fit in one page. This page will
>> +	 * always be decrement before storing anything on it in sse-entry.S.
> 
> decremented
> 
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
>> +	const char *max_hart_str;
>> +	const char *attr_name;
>> +
>> +	report_prefix_push("attrs");
>> +
>> +	for (i = 0; i < ARRAY_SIZE(ro_attrs); i++) {
>> +		ret = sbi_sse_write_attrs(event_id, ro_attrs[i], 1, &value);
>> +		sbiret_report_error(&ret, SBI_ERR_BAD_RANGE, "RO attribute %s not writable",
>> +				    attr_names[ro_attrs[i]]);
>> +	}
>> +
>> +	ret = sbi_sse_read_attrs(event_id, SBI_SSE_ATTR_STATUS, ALL_ATTRS_COUNT, values);
>> +	sbiret_report_error(&ret, SBI_SUCCESS, "Read multiple attributes no error");
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
>> +		 * Preferred hart reset value is defined by SBI vendor and
>> +		 * status injectable bit also depends on the SBI implementation
> 
> The spec says the STATUS attribute reset value is zero. In any case, if
> certain bits can be tested then we should test them, so we can mask off
> the injectable bit and still check for zero.

Ack.

> 
>> +		 */
>> +		if (i != SBI_SSE_ATTR_STATUS && i != SBI_SSE_ATTR_PREFERRED_HART)
>> +			report(value == 0, "Attribute %s reset value is 0", attr_name);
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
>> +		max_hart_str = getenv("MAX_HART_ID");
> 
> This should be named "INVALID_HARTID"
> 
>> +		if (!max_hart_str)
>> +			value = 0xFFFFFFFFUL;
>> +		else
>> +			value = strtoul(max_hart_str, NULL, 0);
>> +
>> +		ret = sbi_sse_write_attrs(event_id, SBI_SSE_ATTR_PREFERRED_HART, 1, &value);
>> +		sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM, "Set invalid hart id error");
> 
> The spec doesn't say you can get invalid-param for a bad hartid.

Indeed.

> 
>> +	} else {
>> +		/* Set Hart on local event -> RO */
>> +		value = current_thread_info()->hartid;
>> +		ret = sbi_sse_write_attrs(event_id, SBI_SSE_ATTR_PREFERRED_HART, 1, &value);
>> +		sbiret_report_error(&ret, SBI_ERR_BAD_RANGE, "Set hart id on local event error");
> 
> The spec doesn't say you can get bad-range for a valid hartid when set
> locally.

Ditto.

> 
>> +	}
>> +
>> +	/* Set/get flags, sepc, a6, a7 */
>> +	for (i = 0; i < ARRAY_SIZE(interrupted_attrs); i++) {
>> +		attr_name = attr_names[interrupted_attrs[i]];
>> +		ret = sbi_sse_read_attrs(event_id, interrupted_attrs[i], 1, &value);
>> +		sbiret_report_error(&ret, SBI_SUCCESS, "Get interrupted %s no error", attr_name);
>> +
>> +		value = ARRAY_SIZE(interrupted_attrs) - i;
> 
> I don't understand how this creates an invalid value for all interrupted attrs?
> 
>> +		ret = sbi_sse_write_attrs(event_id, interrupted_attrs[i], 1, &value);
>> +		sbiret_report_error(&ret, SBI_ERR_INVALID_STATE,
> 
> The spec doesn't state SBI_ERR_INVALID_STATE will ever be returned for
> sbi_sse_write_attrs()

Yeah, indeed, the attributes are specified as being writable only when
in RUNNING state. I inferred that as well, i'll probably send a
clarification to the spec for that.

> 
>> +				    "Set attribute %s invalid state error", attr_name);
>> +	}
>> +
>> +	sse_read_write_test(event_id, SBI_SSE_ATTR_STATUS, 0, &value, SBI_ERR_INVALID_PARAM,
>> +			    "attribute attr_count == 0");
>> +	sse_read_write_test(event_id, SBI_SSE_ATTR_INTERRUPTED_A7 + 1, 1, &value, SBI_ERR_BAD_RANGE,
>> +			    "invalid attribute");
>> +
>> +#if __riscv_xlen > 32
>> +	sse_read_write_test(event_id, BIT(32), 1, &value, SBI_ERR_INVALID_PARAM,
>> +			    "attribute id > 32 bits");
>> +	sse_read_write_test(event_id, SBI_SSE_ATTR_STATUS, BIT(32), &value, SBI_ERR_INVALID_PARAM,
>> +			    "attribute count > 32 bits");
> 
> I think you plan to change these to expect them to behave like
> base_attr_id=1 and attr_count=1.
> 
>> +#endif
>> +
>> +	/* Misaligned pointer address */
>> +	ptr = (void *) &value;
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
>> +	sbiret_report_error(&ret, SBI_ERR_INVALID_STATE, "SSE unregister non registered event");
> 
> non-registered
> 
>> +
>> +	ret = sbi_sse_register_raw(event_id, 0x1, 0);
>> +	sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM, "SSE register misaligned entry");
>> +
>> +	ret = sbi_sse_register_raw(event_id, virt_to_phys(sbi_sse_entry), 0);
>> +	sbiret_report_error(&ret, SBI_SUCCESS, "SSE register ok");
>> +	if (ret.error)
>> +		goto done;
>> +
>> +	ret = sbi_sse_register_raw(event_id, virt_to_phys(sbi_sse_entry), 0);
>> +	sbiret_report_error(&ret, SBI_ERR_INVALID_STATE, "SSE register twice failure");
> 
> "SSE register used event"
> 
>> +
>> +	ret = sbi_sse_unregister(event_id);
>> +	sbiret_report_error(&ret, SBI_SUCCESS, "SSE unregister ok");
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
>> +	sbiret_report_error(&ret, SBI_SUCCESS, "Save full interrupted state from SSE handler ok");
>> +
>> +	/* Write full modified state and read it */
>> +	ret = sbi_sse_write_attrs(event_id, SBI_SSE_ATTR_INTERRUPTED_SEPC,
>> +				  ARRAY_SIZE(modified_state), modified_state);
>> +	sbiret_report_error(&ret, SBI_SUCCESS,
>> +			    "Write full interrupted state from SSE handler ok");
>> +
>> +	ret = sbi_sse_read_attrs(event_id, SBI_SSE_ATTR_INTERRUPTED_SEPC,
>> +				ARRAY_SIZE(tmp_state), tmp_state);
>> +	sbiret_report_error(&ret, SBI_SUCCESS, "Read full modified state from SSE handler ok");
>> +
>> +	report(memcmp(tmp_state, modified_state, sizeof(modified_state)) == 0,
>> +		      "Full interrupted state successfully written");
> 
> "Full... should line up under the report(, not memcmp(
> 
>> +
>> +	/* Restore full saved state */
>> +	ret = sbi_sse_write_attrs(event_id, SBI_SSE_ATTR_INTERRUPTED_SEPC,
>> +		ARRAY_SIZE(interrupted_attrs), interrupted_state);
>> +	sbiret_report_error(&ret, SBI_SUCCESS,
>> +			    "Full interrupted state restore from SSE handler ok");
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
>> +		sbiret_report_error(&ret, SBI_SUCCESS, "Get attr %s no error", attr_name);
>> +
>> +		value = 0xDEADBEEF + i;
>> +		ret = sbi_sse_write_attrs(event_id, attr, 1, &value);
>> +		sbiret_report_error(&ret, SBI_SUCCESS, "Set attr %s no error", attr_name);
>> +
>> +		ret = sbi_sse_read_attrs(event_id, attr, 1, &value);
>> +		sbiret_report_error(&ret, SBI_SUCCESS, "Get attr %s no error", attr_name);
>> +		report(value == 0xDEADBEEF + i, "Get attr %s no error, value: 0x%lx", attr_name,
>> +		       value);
>> +
>> +		ret = sbi_sse_write_attrs(event_id, attr, 1, &prev_value);
>> +		sbiret_report_error(&ret, SBI_SUCCESS, "Restore attr %s value no error", attr_name);
>> +	}
>> +
>> +	/* Test all flags allowed for SBI_SSE_ATTR_INTERRUPTED_FLAGS*/
>                                                                     ^
> 								    missing
> 								    space
> 
>> +	attr = SBI_SSE_ATTR_INTERRUPTED_FLAGS;
>> +	ret = sbi_sse_read_attrs(event_id, attr, 1, &prev_value);
>> +	sbiret_report_error(&ret, SBI_SUCCESS, "Save interrupted flags no error");
>> +
>> +	for (i = 0; i < ARRAY_SIZE(interrupted_flags); i++) {
>> +		flags = interrupted_flags[i];
>> +		ret = sbi_sse_write_attrs(event_id, attr, 1, &flags);
>> +		sbiret_report_error(&ret, SBI_SUCCESS,
>> +				    "Set interrupted flags bit 0x%lx value no error", flags);
>> +		ret = sbi_sse_read_attrs(event_id, attr, 1, &value);
>> +		sbiret_report_error(&ret, SBI_SUCCESS, "Get interrupted flags after set no error");
>> +		report(value == flags, "interrupted flags modified value ok: 0x%lx", value);
> 
> Do we also need to test with more than one flag set at a time?

That is already done a few lines above (see /* Restore full saved state */).

> 
>> +	}
>> +
>> +	/* Write invalid bit in flag register */
>> +	flags = SBI_SSE_ATTR_INTERRUPTED_FLAGS_SSTATUS_SDT << 1;
>> +	ret = sbi_sse_write_attrs(event_id, attr, 1, &flags);
>> +	sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM, "Set invalid flags bit 0x%lx value error",
>> +			    flags);
>> +#if __riscv_xlen > 32
>> +	flags = BIT(32);
>> +	ret = sbi_sse_write_attrs(event_id, attr, 1, &flags);
>> +	sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM, "Set invalid flags bit 0x%lx value error",
> 
> This should have a different report string than the test above.

The bit value format does differentiate the printf though.

> 
>> +			    flags);
>> +#endif
>> +
>> +	ret = sbi_sse_write_attrs(event_id, attr, 1, &prev_value);
>> +	sbiret_report_error(&ret, SBI_SUCCESS, "Restore interrupted flags no error");
>> +
>> +	/* Try to change HARTID/Priority while running */
>> +	if (sbi_sse_event_is_global(event_id)) {
>> +		value = current_thread_info()->hartid;
>> +		ret = sbi_sse_write_attrs(event_id, SBI_SSE_ATTR_PREFERRED_HART, 1, &value);
>> +		sbiret_report_error(&ret, SBI_ERR_INVALID_STATE, "Set hart id while running error");
>> +	}
> 
> SBI_ERR_INVALID_STATE is not listed as a possible error for write_attrs.

Will update the spec.

> 
>> +
>> +	value = 0;
>> +	ret = sbi_sse_write_attrs(event_id, SBI_SSE_ATTR_PRIORITY, 1, &value);
>> +	sbiret_report_error(&ret, SBI_ERR_INVALID_STATE, "Set priority while running error");
>> +
>> +	report(interrupted_state[2] == READ_ONCE(arg->expected_a6),
>> +	       "Interrupted state a6 ok, expected 0x%lx, got 0x%lx",
>> +	       READ_ONCE(arg->expected_a6), interrupted_state[2]);
> 
> Could just READ_ONCE expected_a6 once.

Ack.

> 
>> +
>> +	report(interrupted_state[3] == SBI_EXT_SSE,
>> +	       "Interrupted state a7 ok, expected 0x%x, got 0x%lx", SBI_EXT_SSE,
>> +	       interrupted_state[3]);
>> +
>> +	WRITE_ONCE(arg->done, true);
>> +}
>> +
>> +static void sse_test_inject_simple(uint32_t event_id)
>> +{
>> +	unsigned long value;
>> +	struct sbiret ret;
>> +	struct sse_simple_test_arg test_arg = {.event_id = event_id};
>> +	struct sbi_sse_handler_arg args = {
>> +		.handler = sse_simple_handler,
>> +		.handler_data = (void *) &test_arg,
>> +		.stack = sse_alloc_stack(),
>> +	};
>> +
>> +	report_prefix_push("simple");
>> +
>> +	if (!sse_check_state(event_id, SBI_SSE_STATE_UNUSED))
>> +		goto done;
>> +
>> +	ret = sbi_sse_register(event_id, &args);
>> +	if (!sbiret_report_error(&ret, SBI_SUCCESS, "SSE register no error"))
>> +		goto done;
>> +
>> +	if (!sse_check_state(event_id, SBI_SSE_STATE_REGISTERED))
>> +		goto done;
>> +
>> +	/* Be sure global events are targeting the current hart */
>> +	sse_global_event_set_current_hart(event_id);
>> +
>> +	ret = sbi_sse_enable(event_id);
>> +	if (!sbiret_report_error(&ret, SBI_SUCCESS, "SSE enable no error"))
>> +		goto done;
>> +
>> +	if (!sse_check_state(event_id, SBI_SSE_STATE_ENABLED))
>> +		goto done;
>> +
>> +	ret = sbi_sse_hart_mask();
>> +	if (!sbiret_report_error(&ret, SBI_SUCCESS, "SSE hart mask no error"))
>> +		goto done;
>> +
>> +	ret = sbi_sse_inject(event_id, current_thread_info()->hartid);
>> +	if (!sbiret_report_error(&ret, SBI_SUCCESS, "SSE injection masked no error"))
>> +		goto done;
>> +
>> +	barrier();
>> +	report(test_arg.done == 0, "SSE event masked not handled");
> 
> Could instead drop the barrier() calls and use READ/WRITE_ONCE with all
> test_arg member accesses.
> 
>> +
>> +	/*
>> +	 * When unmasking the SSE events, we expect it to be injected
>> +	 * immediately so a6 should be SBI_EXT_SBI_SSE_HART_UNMASK
>> +	 */
>> +	test_arg.expected_a6 = SBI_EXT_SSE_HART_UNMASK;
>> +	ret = sbi_sse_hart_unmask();
>> +	if (!sbiret_report_error(&ret, SBI_SUCCESS, "SSE hart unmask no error"))
>> +		goto done;
>> +
>> +	barrier();
>> +	report(test_arg.done == 1, "SSE event unmasked handled");
>> +	test_arg.done = 0;
>> +	test_arg.expected_a6 = SBI_EXT_SSE_INJECT;
>> +
>> +	/* Set as oneshot and verify it is disabled */
>> +	ret = sbi_sse_disable(event_id);
>> +	sbiret_report_error(&ret, SBI_SUCCESS, "Disable event ok");
>> +	value = SBI_SSE_ATTR_CONFIG_ONESHOT;
>> +	ret = sbi_sse_write_attrs(event_id, SBI_SSE_ATTR_CONFIG, 1, &value);
>> +	sbiret_report_error(&ret, SBI_SUCCESS, "Set event attribute as ONESHOT");
>> +	ret = sbi_sse_enable(event_id);
>> +	sbiret_report_error(&ret, SBI_SUCCESS, "Enable event ok");
>> +
>> +	ret = sbi_sse_inject(event_id, current_thread_info()->hartid);
>> +	if (!sbiret_report_error(&ret, SBI_SUCCESS, "SSE second injection no error"))
>> +		goto done;
>> +
>> +	barrier();
>> +	report(test_arg.done == 1, "SSE event handled ok");
>> +	test_arg.done = 0;
>> +
>> +	if (!sse_check_state(event_id, SBI_SSE_STATE_REGISTERED))
>> +		goto done;
>> +
>> +	/* Clear ONESHOT FLAG */
>> +	value = 0;
>> +	sbi_sse_write_attrs(event_id, SBI_SSE_ATTR_CONFIG, 1, &value);
> 
> Why clear the oneshot flag before unregistering (and not check if the attr
> write was successful)?

I previously add some loop over the test but the oneshot messed up the
next test. Anyway, I think it's better to restore the event to it's
previous state. I'll check for the return value though.

> 
>> +
>> +	ret = sbi_sse_unregister(event_id);
>> +	if (!sbiret_report_error(&ret, SBI_SUCCESS, "SSE unregister no error"))
>> +		goto done;
>> +
>> +	sse_check_state(event_id, SBI_SSE_STATE_UNUSED);
>> +
>> +done:
> 
> Is it ok to leave this function with an event registered/enabled? If not,
> then some of the goto's above should goto other labels which disable and
> unregister.

No it's not but it's massive pain to keep everything coherent when it
fails ;)

> 
>> +	sse_free_stack(args.stack);
>> +	report_prefix_pop();
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
>> +static void sse_test_inject_local(uint32_t event_id)
>> +{
>> +	int cpu;
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
>> +		if (ret.error)
>> +			report_abort("CPU failed to register/enable SSE event: %ld",
>> +				     ret.error);
> 
> Do we need this to be an abort?

Probably not but since events used some state machine, we probably
messed up the state. Same comment than before applies, it's a pain to
restore events to their previous state properly. I figured out that
since this is a test, it might not be *that* important to keep it
totally sane in case something goes wrong. i'll try some best effort to
handle that though.

> 
>> +
>> +		handler_arg = &cpu_arg->handler_arg;
>> +		WRITE_ONCE(handler_arg->expected_cpu, cpu);
>> +		/* For handler_arg content to be visible for other CPUs */
>> +		smp_wmb();
>> +		ret = sbi_sse_inject(event_id, cpus[cpu].hartid);
>> +		if (ret.error)
>> +			report_abort("CPU failed to register/enable SSE event: %ld",
>> +				     ret.error);
> 
> abort?
> 
>> +	}
>> +
>> +	for_each_online_cpu(cpu) {
>> +		handler_arg = &cpu_args[cpu].handler_arg;
> 
> Need smp_rmb() here in case we read done=1 on first try in order
> to be sure that all other data ordered wrt the done write can
> be observed.
> 
>> +		while (!READ_ONCE(handler_arg->done)) {
> 
> Maybe a cpu_relax() here.
> 
>> +			/* For handler_arg update to be visible */
>> +			smp_rmb();
>> +		}
>> +		WRITE_ONCE(handler_arg->done, false);
>> +	}
>> +
>> +	on_cpus(sbi_sse_disable_unregister_local, cpu_args);
>> +	for_each_online_cpu(cpu) {
>> +		cpu_arg = &cpu_args[cpu];
>> +		ret = READ_ONCE(cpu_arg->ret);
>> +		if (ret.error)
>> +			report_abort("CPU failed to disable/unregister SSE event: %ld",
>> +				     ret.error);
> 
> abort?
> 
>> +	}
>> +
>> +	for_each_online_cpu(cpu) {
>> +		cpu_arg = &cpu_args[cpu];
>> +
> 
> delete unnecessary blank line
> 
>> +		sse_free_stack(cpu_arg->args.stack);
>> +	}
>> +
>> +	report_pass("local event dispatch on all CPUs");
>> +	report_prefix_pop();
>> +
>> +}
>> +
>> +static void sse_test_inject_global(uint32_t event_id)
>> +{
>> +	unsigned long value;
>> +	struct sbiret ret;
>> +	unsigned int cpu;
>> +	struct sse_foreign_cpu_test_arg test_arg = {.event_id = event_id};
>> +	struct sbi_sse_handler_arg args = {
>> +		.handler = sse_foreign_cpu_handler,
>> +		.handler_data = (void *) &test_arg,
>> +		.stack = sse_alloc_stack(),
>> +	};
>> +	enum sbi_sse_state state;
>> +
>> +	report_prefix_push("global_dispatch");
>> +
>> +	ret = sbi_sse_register(event_id, &args);
>> +	if (!sbiret_report_error(&ret, SBI_SUCCESS, "Register event no error"))
>> +		goto err_free_stack;
>> +
>> +	for_each_online_cpu(cpu) {
>> +		WRITE_ONCE(test_arg.expected_cpu, cpu);
>> +		/* For test_arg content to be visible for other CPUs */
>> +		smp_wmb();
>> +		value = cpu;
>> +		ret = sbi_sse_write_attrs(event_id, SBI_SSE_ATTR_PREFERRED_HART, 1, &value);
>> +		if (!sbiret_report_error(&ret, SBI_SUCCESS, "Set preferred hart no error"))
>> +			goto err_unregister;
>> +
>> +		ret = sbi_sse_enable(event_id);
>> +		if (!sbiret_report_error(&ret, SBI_SUCCESS, "Enable SSE event no error"))
>> +			goto err_unregister;
>> +
>> +		ret = sbi_sse_inject(event_id, cpu);
>> +		if (!sbiret_report_error(&ret, SBI_SUCCESS, "Inject SSE event no error"))
>> +			goto err_disable;
>> +
> 
> smp_rmb()
> 
>> +		while (!READ_ONCE(test_arg.done)) {
> 
> cpu_relax()
> 
>> +			/* For shared test_arg structure */
>> +			smp_rmb();
>> +		}
>> +
>> +		WRITE_ONCE(test_arg.done, false);
>> +
>> +		/* Wait for event to be in ENABLED state */
>> +		do {
>> +			ret = sse_event_get_state(event_id, &state);
>> +			if (sbiret_report_error(&ret, SBI_SUCCESS, "Get SSE event state no error"))
>> +				goto err_disable;
> 
> cpu_relax() or even use udelay()?
> 
>> +		} while (state != SBI_SSE_STATE_ENABLED);
>> +
>> +err_disable:
>> +		ret = sbi_sse_disable(event_id);
>> +		if (!sbiret_report_error(&ret, SBI_SUCCESS, "Disable SSE event no error"))
>> +			goto err_unregister;
>> +
>> +		report_pass("Global event on CPU %d", cpu);
>> +	}
>> +
>> +err_unregister:
>> +	ret = sbi_sse_unregister(event_id);
>> +	sbiret_report_error(&ret, SBI_SUCCESS, "Unregister SSE event no error");
>> +
>> +err_free_stack:
>> +	sse_free_stack(args.stack);
>> +	report_prefix_pop();
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
>> +		report(!sse_event_pending(next->event_id), "Higher priority event is pending");
> 
> "is not pending"
> 
>> +		report(next->called, "Higher priority event was not handled");
> 
> "was handled"
> 
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
>> +		report(!next->called, "Lower priority event %s was handle before %s",
> 
> "was not handled"
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
>> +	unsigned long value;
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
>> +	}
>> +
>> +	if (!args_size) {
>> +		report_skip("No event injectable");
>> +		report_prefix_pop();
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
>> +		sse_global_event_set_current_hart(event_id);
>> +
>> +		sbi_sse_register(event_id, event_arg);
>> +		value = arg->prio;
>> +		sbi_sse_write_attrs(event_id, SBI_SSE_ATTR_PRIORITY, 1, &value);
>> +		sbi_sse_enable(event_id);
> 
> No return code checks for these SSE calls? If we're 99% sure they should
> succeed, then I'd still check them with asserts.

I was a bit lazy here. Since the goal is *not* to check the event state
themselve but rather the ordering, I didn't bother checking them. As
said before, habndling error and event state properly in case of error
seemed like a churn to me *just* for testing. I'll try something better
as well though.

> 
>> +	}
>> +
>> +	/* Inject first event */
>> +	ret = sbi_sse_inject(args[0]->event_id, current_thread_info()->hartid);
>> +	sbiret_report_error(&ret, SBI_SUCCESS, "SSE injection no error");
>> +
>> +	for (i = 0; i < args_size; i++) {
>> +		arg = args[i];
>> +		event_id = arg->event_id;
>> +
>> +		report(arg->called, "Event %s handler called", sse_event_name(arg->event_id));
>> +
>> +		sbi_sse_disable(event_id);
>> +		sbi_sse_unregister(event_id);
> 
> No return code checks?
> 
>> +
>> +		event_arg = &event_args[i];
>> +		sse_free_stack(event_arg->stack);
>> +	}
>> +
>> +skip:
>> +	report_prefix_pop();
> 
> Isn't this an extra pop()? We should be able to return directly from the
> report_skip() if-block.

Indeed.

> 
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
>> +	{.event_id = SBI_SSE_EVENT_GLOBAL_SOFTWARE, .prio = 5},
>> +	{.event_id = SBI_SSE_EVENT_LOCAL_SOFTWARE, .prio = 10},
>> +	{.event_id = SBI_SSE_EVENT_LOCAL_LOW_PRIO_RAS, .prio = 12},
>> +	{.event_id = SBI_SSE_EVENT_LOCAL_PMU_OVERFLOW, .prio = 15},
>> +	{.event_id = SBI_SSE_EVENT_GLOBAL_HIGH_PRIO_RAS, .prio = 20},
>> +	{.event_id = SBI_SSE_EVENT_GLOBAL_LOW_PRIO_RAS, .prio = 22},
>> +	{.event_id = SBI_SSE_EVENT_LOCAL_HIGH_PRIO_RAS, .prio = 25},
>> +};
>> +
>> +static struct priority_test_arg same_prio_args[] = {
>> +	{.event_id = SBI_SSE_EVENT_LOCAL_PMU_OVERFLOW, .prio = 0},
>> +	{.event_id = SBI_SSE_EVENT_GLOBAL_LOW_PRIO_RAS, .prio = 0},
>> +	{.event_id = SBI_SSE_EVENT_LOCAL_HIGH_PRIO_RAS, .prio = 10},
>> +	{.event_id = SBI_SSE_EVENT_LOCAL_SOFTWARE, .prio = 10},
>> +	{.event_id = SBI_SSE_EVENT_GLOBAL_SOFTWARE, .prio = 10},
>> +	{.event_id = SBI_SSE_EVENT_GLOBAL_HIGH_PRIO_RAS, .prio = 20},
>> +	{.event_id = SBI_SSE_EVENT_LOCAL_LOW_PRIO_RAS, .prio = 20},
>> +};
> 
> nit: could tab out the .prio's in order to better tabulate the above two
> structs.
> 
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
>> +			    "SSE register event_id 0x%lx invalid param", event_id);
>> +
>> +	ret = sbi_sse_unregister(event_id);
>> +	sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM,
>> +			"SSE unregister event_id 0x%lx invalid param", event_id);
>> +
>> +	ret = sbi_sse_enable(event_id);
>> +	sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM,
>> +			    "SSE enable event_id 0x%lx invalid param", event_id);
>> +
>> +	ret = sbi_sse_disable(event_id);
>> +	sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM,
>> +			    "SSE disable event_id 0x%lx invalid param", event_id);
>> +
>> +	ret = sbi_sse_inject(event_id, 0);
>> +	sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM,
>> +			    "SSE inject event_id 0x%lx invalid param", event_id);
>> +
>> +	ret = sbi_sse_write_attrs(event_id, SBI_SSE_ATTR_PRIORITY, 1, &value);
>> +	sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM,
>> +			    "SSE write attr event_id 0x%lx invalid param", event_id);
>> +
>> +	ret = sbi_sse_read_attrs(event_id, SBI_SSE_ATTR_PRIORITY, 1, &value);
>> +	sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM,
>> +			    "SSE read attr event_id 0x%lx invalid param", event_id);
> 
> We can s/invalid param/ from all the strings above since we output
> SBI_ERR_INVALID_PARAM with the latest sbiret_report_error()

Yeah, I'll make some cleanup in other strings as well.

> 
>> +}
>> +
>> +static void sse_test_invalid_event_id(void)
>> +{
>> +
>> +	report_prefix_push("event_id");
>> +
>> +#if __riscv_xlen > 32
>> +	test_invalid_event_id(BIT_ULL(32));
>> +#endif
> 
> With your latest opensbi changes we'll truncate eventid, so we need
> another invalid eventid for the tests. That's good since we can then test
> for rv32 too.

Indeed.

> 
>> +
>> +	report_prefix_pop();
>> +}
>> +
>> +static bool sse_can_inject(uint32_t event_id)
>> +{
>> +	struct sbiret ret;
>> +	unsigned long status;
>> +
>> +	ret = sbi_sse_read_attrs(event_id, SBI_SSE_ATTR_STATUS, 1, &status);
>> +	if (ret.error)
> 
> Don't we want to assert or complain loudly about an unexpected status read
> failure?

I can add some warning yeah

> 
>> +		return false;
>> +
>> +	return !!(status & BIT(SBI_SSE_ATTR_STATUS_INJECT_OFFSET));
>> +}
>> +
>> +static void boot_secondary(void *data)
> 
> Maybe name this sse_secondary_boot_and_unmask?
> 
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
>> +	sbiret_report_error(&ret, SBI_ERR_ALREADY_STOPPED, "SSE hart mask at boot time ok");
>> +
>> +	ret = sbi_sse_hart_unmask();
>> +	sbiret_report_error(&ret, SBI_SUCCESS, "SSE hart no error ok");
>                                                         ^ unmask
> 
>> +	ret = sbi_sse_hart_unmask();
>> +	sbiret_report_error(&ret, SBI_ERR_ALREADY_STARTED, "SSE hart unmask twice error ok");
>> +
>> +	ret = sbi_sse_hart_mask();
>> +	sbiret_report_error(&ret, SBI_SUCCESS, "SSE hart mask no error");
>> +	ret = sbi_sse_hart_mask();
>> +	sbiret_report_error(&ret, SBI_ERR_ALREADY_STOPPED, "SSE hart mask twice ok");
>> +}
>> +
>> +void check_sse(void)
>> +{
>> +	unsigned long i, event_id;
>> +
>> +	report_prefix_push("sse");
>> +
>> +	if (!sbi_probe(SBI_EXT_SSE)) {
>> +		report_skip("SSE extension not available");
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
>> +	on_cpus(boot_secondary, NULL);
>> +
>> +	sse_test_invalid_event_id();
>> +
>> +	for (i = 0; i < ARRAY_SIZE(sse_event_infos); i++) {
>> +		event_id = sse_event_infos[i].event_id;
>> +		report_prefix_push(sse_event_infos[i].name);
>> +		if (!sse_can_inject(event_id)) {
>> +			report_skip("Event 0x%lx does not support injection", event_id);
>> +			report_prefix_pop();
>> +			continue;
>> +		} else {
>> +			sse_event_infos[i].can_inject = true;
> 
> What do we need to cache can_inject=true for if we filter out all events
> which have can_inject=false? 

The cache value is used in priority tests.

Should we run at least something with
> events which don't support injection?

Yeah, a few tests can be run, I'll modify that

> 
>> +		}
>> +		sse_test_attrs(event_id);
>> +		sse_test_register_error(event_id);
>> +		sse_test_inject_simple(event_id);
>> +		if (sbi_sse_event_is_global(event_id))
>> +			sse_test_inject_global(event_id);
>> +		else
>> +			sse_test_inject_local(event_id);
>> +
>> +		report_prefix_pop();
>> +	}
>> +
>> +	sse_test_injection_priority();
>> +
>> +	report_prefix_pop();
>> +}
>> diff --git a/riscv/sbi.c b/riscv/sbi.c
>> index 7c7a2d2d..49e81bda 100644
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
>> @@ -1439,6 +1440,7 @@ int main(int argc, char **argv)
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


