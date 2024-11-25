Return-Path: <kvm+bounces-32408-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 99BA69D7E51
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 09:56:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5376B2823E8
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 08:56:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFC6D18E05F;
	Mon, 25 Nov 2024 08:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="vHsJ4KLm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61E8E18F2D4
	for <kvm@vger.kernel.org>; Mon, 25 Nov 2024 08:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732524954; cv=none; b=kWItqIMFussFe999xvmLuTRxIVS7hPpNdt/KuWHST1FAFhrQrLMSdj6aG3I/vNggqO/kgHYaed6XxUVnBGLOF/JkoP2LroSuugpGfT5ODCyDhd6aD9myd7a/3iaBR/rFEibppZ923WFoka8GCKtf/eXvWJOh9T9McDF8ZfUTNyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732524954; c=relaxed/simple;
	bh=h1dV/pCzGfg+OjA/6gjKwI7YXvlNTszLIo3e9VsHd/0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gAGsifciW9JrTBIywLJ/Lh1zSZifo/ALC+tJSM0vtSNT9ikGHzgma70K1P3po/jFEPAr9new6oV8ogi5nKK/MFwFrxcf1tFFq7GPYFllpQt2nZ/WchnU+iaFyaube8C2D4cHbCkquf1Uu09KAEo3R+1tZgAUyMpJU5ywjN9bYS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=vHsJ4KLm; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4349cc45219so10339695e9.3
        for <kvm@vger.kernel.org>; Mon, 25 Nov 2024 00:55:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1732524949; x=1733129749; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=umufqv5swZ8ifobT3eeceE/eJ2HxnI5eiPvkCmheR14=;
        b=vHsJ4KLmCNd0/7bS8LqG6eF9tc59mM0HlYjTgVCV6djSrLXbx/2eRmJHoDPK+gwY+F
         tNdJInh8+diI9Stkb3okBFHArevmoKr7kgEFP/7A1orxrhJFbzzP2BVUcw0Cv+C2LtWJ
         V4+K+6o6NiUBgsciQKw7mEyLDl9Nztd+TEzBZ0r27yl3L20vgVGC/UrvtTBb29X3PU8m
         vVgWwREb/t2Sb5hsjWxNWVFBL2W1+eAMC2auEmLsESBhUSEjOqD3n3TEIl34F0wiE2EZ
         dBV/W5myTQaSP0FiownOQalXtOucw59eIpaeyPYrG2O0HoLy6DJfc7c+6KgCPZuh1Zlz
         +AQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732524949; x=1733129749;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=umufqv5swZ8ifobT3eeceE/eJ2HxnI5eiPvkCmheR14=;
        b=luakHrHlU2XwAEldf/d/9wqFB8QmMJuNqondvQDcJ23IuV+pUKYg8Cuxl7FzJllgZ+
         vy7EGmPwpBMb7X8LBCfg4tAmzbexgbXEJrxz4aYmREEymqvJgf3/yXKdxErsA5BoCgS5
         F4hB9K2Xc88/BPoZdIVQfZt0tzHkMpy/nJk4t5+cHA/qk+ZKjFZ/rZq98U50l3DzvjLm
         bXMVr0AXf1/tbpIPJm8bMdiZjK8pygRcH7KUX9zk7YQuwVu84eDcpAoCgoUP/5YKI7p+
         ZtOO0gmlxsttCix7GKA/f5Sb2SMkn0ibMCmrqoC2IZqW4IwqVkw1rneDdO51JV3Z4sDY
         ClUQ==
X-Gm-Message-State: AOJu0YwvtoZv1ojs12PJ7yh8JWq/J+a+3P/4N5qj83u4oEoXvkfSv4TR
	wh83hoodaKQLmkMFGuOysfOv9xQEh2fm6PK1LHZKHM+dbPtAki1bbmZ2RylmTxhwB2HHb/oIpSg
	+
X-Gm-Gg: ASbGncuIKX4jPjuvfffi++7WKVZwqlThlRCChLynvSgx+BVgywT/TrLg5tL8iQr8Vl8
	qZ5+p7skAPFa3flo3k0QHQdr0TBfpzQYDsJjoydOqY/sK0vvlV2kIktHYNBG6Swd2H/8YbnEEh0
	q0oc/miByX+gajHTQ7MS+mod8UsKIuoXR1Gic9SHPkJGrXA5OwISUAcwoqHdsBiZlYx4heJlq4t
	jECS/kyDGKTnI1hk5halpHjdsr398AyNaqqVvlyrxUx2947yq/XvcGPl9seCIszT1smt2jzpBCG
	JOKEPdRz+0mzUjluzFs=
X-Google-Smtp-Source: AGHT+IFHsOQNmhOzT2v+UlxXGiKZFDx3zfYcLvTh0I87r5dZYsJe9CtZmzHKmsZSydXV78RrkfuWvw==
X-Received: by 2002:a05:600c:4447:b0:42c:e0da:f15c with SMTP id 5b1f17b1804b1-433ce495857mr92466135e9.20.1732524948560;
        Mon, 25 Nov 2024 00:55:48 -0800 (PST)
Received: from ?IPV6:2a01:e0a:e17:9700:16d2:7456:6634:9626? ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-433b45adde1sm189886325e9.10.2024.11.25.00.55.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Nov 2024 00:55:48 -0800 (PST)
Message-ID: <362ddf23-283c-43e8-bfff-00ff971e8501@rivosinc.com>
Date: Mon, 25 Nov 2024 09:55:47 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v2 3/3] riscv: sbi: Add SSE extension tests
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 Andrew Jones <ajones@ventanamicro.com>, Anup Patel
 <apatel@ventanamicro.com>, Atish Patra <atishp@rivosinc.com>
References: <20241122140459.566306-1-cleger@rivosinc.com>
 <20241122140459.566306-4-cleger@rivosinc.com>
 <20241122-5e3fefbf68ba10f193470d6a@orel>
Content-Language: en-US
From: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
In-Reply-To: <20241122-5e3fefbf68ba10f193470d6a@orel>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 22/11/2024 17:34, Andrew Jones wrote:
> On Fri, Nov 22, 2024 at 03:04:57PM +0100, Clément Léger wrote:
>> Add SBI SSE extension tests for the following features:
>> - Test attributes errors (invalid values, RO, etc)
>> - Registration errors
>> - Simple events (register, enable, inject)
>> - Events with different priorities
>> - Global events dispatch on different harts
>> - Local events on all harts
>>
>> Signed-off-by: Clément Léger <cleger@rivosinc.com>
>> ---
>>  riscv/Makefile      |   1 +
>>  lib/riscv/asm/csr.h |   2 +
>>  riscv/sbi-tests.h   |   4 +
>>  riscv/sbi-sse.c     | 981 ++++++++++++++++++++++++++++++++++++++++++++
>>  riscv/sbi.c         |   1 +
>>  riscv/unittests.cfg |   4 +
>>  6 files changed, 993 insertions(+)
>>  create mode 100644 riscv/sbi-sse.c
>>
>> diff --git a/riscv/Makefile b/riscv/Makefile
>> index e50621ad..768e1c25 100644
>> --- a/riscv/Makefile
>> +++ b/riscv/Makefile
>> @@ -46,6 +46,7 @@ ifeq ($(ARCH),riscv32)
>>  cflatobjs += lib/ldiv32.o
>>  endif
>>  cflatobjs += riscv/sbi-asm.o
>> +cflatobjs += riscv/sbi-sse.o
> 
> We should figure out how to only link these files into
> riscv/sbi.{flat,efi}

Hey drew, thansk for the review.

I'll check if this is possible to do that yeah.

> 
>>  
>>  ########################################
>>  
>> diff --git a/lib/riscv/asm/csr.h b/lib/riscv/asm/csr.h
>> index 16f5ddd7..06831380 100644
>> --- a/lib/riscv/asm/csr.h
>> +++ b/lib/riscv/asm/csr.h
>> @@ -21,6 +21,8 @@
>>  /* Exception cause high bit - is an interrupt if set */
>>  #define CAUSE_IRQ_FLAG		(_AC(1, UL) << (__riscv_xlen - 1))
>>  
>> +#define SSTATUS_SPP		_AC(0x00000100, UL) /* Previously Supervisor */
>> +
>>  /* Exception causes */
>>  #define EXC_INST_MISALIGNED	0
>>  #define EXC_INST_ACCESS		1
>> diff --git a/riscv/sbi-tests.h b/riscv/sbi-tests.h
>> index ce129968..2115acc6 100644
>> --- a/riscv/sbi-tests.h
>> +++ b/riscv/sbi-tests.h
>> @@ -33,4 +33,8 @@
>>  #define SBI_SUSP_TEST_HARTID	(1 << 2)
>>  #define SBI_SUSP_TEST_MASK	7
>>  
>> +#ifndef __ASSEMBLY__
>> +void check_sse(void);
> 
> We can just put this in riscv/sbi.c

sbi.c is already almost 1500 lines long, adding SSE would make it a 2500
lines files. IMHO, it would be nice to keep it separated to keep it
clean. But if you really have a strong opinion to incorporate that in
sbi.c, I'll do that.

Thanks,

Clément

> 
>> +#endif /* !__ASSEMBLY__ */
>> +
>>  #endif /* _RISCV_SBI_TESTS_H_ */
>> diff --git a/riscv/sbi-sse.c b/riscv/sbi-sse.c
>> new file mode 100644
>> index 00000000..16eb0575
>> --- /dev/null
>> +++ b/riscv/sbi-sse.c
>> @@ -0,0 +1,981 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * SBI SSE testsuite
>> + *
>> + * Copyright (C) 2024, Rivos Inc., Clément Léger <cleger@rivosinc.com>
>> + */
>> +#include <libcflat.h>
>> +#include <alloc_page.h>
>> +#include <bitops.h>
>> +#include <cpumask.h>
>> +#include <libcflat.h>
> 
> libcflat.h is repeated and let's alphabetize all these
> 
>> +#include <on-cpus.h>
>> +#include <alloc.h>
>> +
>> +#include <asm/barrier.h>
>> +#include <asm/page.h>
>> +#include <asm/processor.h>
>> +#include <asm/sbi.h>
>> +#include <asm/setup.h>
>> +#include <asm/sse.h>
>> +
>> +#include "sbi-tests.h"
>> +
>> +#define SSE_STACK_SIZE	PAGE_SIZE
>> +
>> +struct sse_event_info {
>> +	unsigned long event_id;
>> +	const char *name;
>> +	bool can_inject;
>> +};
>> +
>> +static struct sse_event_info sse_event_infos[] = {
>> +	{
>> +		.event_id = SBI_SSE_EVENT_LOCAL_RAS,
>> +		.name = "local_ras",
>> +	},
>> +	{
>> +		.event_id = SBI_SSE_EVENT_GLOBAL_RAS,
>> +		.name = "global_ras",
>> +	},
>> +	{
>> +		.event_id = SBI_SSE_EVENT_LOCAL_PMU,
>> +		.name = "local_pmu",
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
>> +	[SBI_SSE_ATTR_PRIO] = "prio",
>> +	[SBI_SSE_ATTR_CONFIG] = "config",
>> +	[SBI_SSE_ATTR_PREFERRED_HART] = "preferred_hart",
>> +	[SBI_SSE_ATTR_ENTRY_PC] = "entry_pc",
>> +	[SBI_SSE_ATTR_ENTRY_ARG] = "entry_arg",
>> +	[SBI_SSE_ATTR_INTERRUPTED_SEPC] = "interrupted_pc",
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
>> +	SBI_SSE_ATTR_INTERRUPTED_FLAGS,
>> +	SBI_SSE_ATTR_INTERRUPTED_SEPC,
>> +	SBI_SSE_ATTR_INTERRUPTED_A6,
>> +	SBI_SSE_ATTR_INTERRUPTED_A7,
>> +};
>> +
>> +static const unsigned long interrupted_flags[] = {
>> +	SBI_SSE_ATTR_INTERRUPTED_FLAGS_STATUS_SPP,
>> +	SBI_SSE_ATTR_INTERRUPTED_FLAGS_STATUS_SPIE,
>> +	SBI_SSE_ATTR_INTERRUPTED_FLAGS_HSTATUS_SPV,
>> +	SBI_SSE_ATTR_INTERRUPTED_FLAGS_HSTATUS_SPVP,
>> +};
>> +
>> +static struct sse_event_info *sse_evt_get_infos(unsigned long event_id)
>> +{
>> +	int i;
>> +
>> +	for (i = 0; i < ARRAY_SIZE(sse_event_infos); i++) {
>> +		if (sse_event_infos[i].event_id == event_id)
>> +			return &sse_event_infos[i];
>> +	}
>> +
>> +	assert_msg(false, "Invalid event id: %ld", event_id);
>> +}
>> +
>> +static const char *sse_evt_name(unsigned long event_id)
>> +{
>> +	struct sse_event_info *infos = sse_evt_get_infos(event_id);
>> +
>> +	return infos->name;
>> +}
>> +
>> +static bool sse_evt_can_inject(unsigned long event_id)
>> +{
>> +	struct sse_event_info *infos = sse_evt_get_infos(event_id);
>> +
>> +	return infos->can_inject;
>> +}
>> +
>> +static bool sse_event_is_global(unsigned long event_id)
>> +{
>> +	return !!(event_id & SBI_SSE_EVENT_GLOBAL_BIT);
>> +}
>> +
>> +static struct sbiret sse_event_get_attr_raw(unsigned long event_id,
>> +					    unsigned long base_attr_id,
>> +					    unsigned long attr_count,
>> +					    unsigned long phys_lo,
>> +					    unsigned long phys_hi)
>> +{
>> +	return sbi_ecall(SBI_EXT_SSE, SBI_EXT_SSE_READ_ATTR, event_id,
>> +			base_attr_id, attr_count, phys_lo, phys_hi, 0);
>> +}
>> +
>> +static unsigned long sse_event_get_attrs(unsigned long event_id, unsigned long attr_id,
>> +					 unsigned long *values, unsigned int attr_count)
>> +{
>> +	struct sbiret ret;
>> +
>> +	ret = sse_event_get_attr_raw(event_id, attr_id, attr_count, (unsigned long)values, 0);
>> +
>> +	return ret.error;
>> +}
>> +
>> +static unsigned long sse_event_get_attr(unsigned long event_id, unsigned long attr_id,
>> +					unsigned long *value)
>> +{
>> +	return sse_event_get_attrs(event_id, attr_id, value, 1);
>> +}
>> +
>> +static struct sbiret sse_event_set_attr_raw(unsigned long event_id, unsigned long base_attr_id,
>> +					    unsigned long attr_count, unsigned long phys_lo,
>> +					    unsigned long phys_hi)
>> +{
>> +	return sbi_ecall(SBI_EXT_SSE, SBI_EXT_SSE_WRITE_ATTR, event_id, base_attr_id, attr_count,
>> +			 phys_lo, phys_hi, 0);
>> +}
>> +
>> +static unsigned long sse_event_set_attr(unsigned long event_id, unsigned long attr_id,
>> +					unsigned long value)
>> +{
>> +	struct sbiret ret;
>> +
>> +	ret = sse_event_set_attr_raw(event_id, attr_id, 1, (unsigned long)&value, 0);
>> +
>> +	return ret.error;
>> +}
>> +
>> +static unsigned long sse_event_register_raw(unsigned long event_id, void *entry_pc, void *entry_arg)
>> +{
>> +	struct sbiret ret;
>> +
>> +	ret = sbi_ecall(SBI_EXT_SSE, SBI_EXT_SSE_REGISTER, event_id, (unsigned long)entry_pc,
>> +			(unsigned long)entry_arg, 0, 0, 0);
>> +
>> +	return ret.error;
>> +}
>> +
>> +static unsigned long sse_event_register(unsigned long event_id, struct sse_handler_arg *arg)
>> +{
>> +	struct sbiret ret;
>> +
>> +	ret = sbi_ecall(SBI_EXT_SSE, SBI_EXT_SSE_REGISTER, event_id, (unsigned long)sse_entry,
>> +			(unsigned long)arg, 0, 0, 0);
>> +
>> +	return ret.error;
>> +}
>> +
>> +static unsigned long sse_event_unregister(unsigned long event_id)
>> +{
>> +	struct sbiret ret;
>> +
>> +	ret = sbi_ecall(SBI_EXT_SSE, SBI_EXT_SSE_UNREGISTER, event_id, 0, 0, 0, 0, 0);
>> +
>> +	return ret.error;
>> +}
>> +
>> +static unsigned long sse_event_enable(unsigned long event_id)
>> +{
>> +	struct sbiret ret;
>> +
>> +	ret = sbi_ecall(SBI_EXT_SSE, SBI_EXT_SSE_ENABLE, event_id, 0, 0, 0, 0, 0);
>> +
>> +	return ret.error;
>> +}
>> +
>> +static unsigned long sse_event_inject(unsigned long event_id, unsigned long hart_id)
>> +{
>> +	struct sbiret ret;
>> +
>> +	ret = sbi_ecall(SBI_EXT_SSE, SBI_EXT_SSE_INJECT, event_id, hart_id, 0, 0, 0, 0);
>> +
>> +	return ret.error;
>> +}
>> +
>> +static unsigned long sse_event_disable(unsigned long event_id)
>> +{
>> +	struct sbiret ret;
>> +
>> +	ret = sbi_ecall(SBI_EXT_SSE, SBI_EXT_SSE_DISABLE, event_id, 0, 0, 0, 0, 0);
>> +
>> +	return ret.error;
>> +}
>> +
>> +
>> +static int sse_get_state(unsigned long event_id, enum sbi_sse_state *state)
>> +{
>> +	int ret;
>> +	unsigned long status;
>> +
>> +	ret = sse_event_get_attr(event_id, SBI_SSE_ATTR_STATUS, &status);
>> +	if (ret) {
>> +		report_fail("Failed to get SSE event status");
>> +		return -1;
>> +	}
>> +
>> +	*state = status & SBI_SSE_ATTR_STATUS_STATE_MASK;
>> +
>> +	return 0;
>> +}
>> +
>> +static void sse_global_event_set_current_hart(unsigned long event_id)
>> +{
>> +	int ret;
>> +
>> +	if (!sse_event_is_global(event_id))
>> +		return;
>> +
>> +	ret = sse_event_set_attr(event_id, SBI_SSE_ATTR_PREFERRED_HART,
>> +				 current_thread_info()->hartid);
>> +	if (ret)
>> +		report_abort("set preferred hart failure");
>> +}
>> +
>> +static int sse_check_state(unsigned long event_id, unsigned long expected_state)
>> +{
>> +	int ret;
>> +	enum sbi_sse_state state;
>> +
>> +	ret = sse_get_state(event_id, &state);
>> +	if (ret)
>> +		return 1;
>> +	report(state == expected_state, "SSE event status == %ld", expected_state);
>> +
>> +	return state != expected_state;
>> +}
>> +
>> +static bool sse_event_pending(unsigned long event_id)
>> +{
>> +	int ret;
>> +	unsigned long status;
>> +
>> +	ret = sse_event_get_attr(event_id, SBI_SSE_ATTR_STATUS, &status);
>> +	if (ret) {
>> +		report_fail("Failed to get SSE event status");
>> +		return false;
>> +	}
>> +
>> +	return !!(status & BIT(SBI_SSE_ATTR_STATUS_PENDING_OFFSET));
>> +}
>> +
>> +static void *sse_alloc_stack(void)
>> +{
>> +	return (alloc_page() + PAGE_SIZE);
>> +}
>> +
>> +static void sse_free_stack(void *stack)
>> +{
>> +	free_page(stack - PAGE_SIZE);
>> +}
> 
> I guess this should be SSE_STACK_SIZE, otherwise that define can be
> removed
> 
>> +
>> +static void sse_test_attr(unsigned long event_id)
>> +{
>> +	unsigned long ret, value = 0;
>> +	unsigned long values[ARRAY_SIZE(ro_attrs)];
>> +	struct sbiret sret;
>> +	unsigned int i;
>> +
>> +	report_prefix_push("attrs");
>> +
>> +	for (i = 0; i < ARRAY_SIZE(ro_attrs); i++) {
>> +		ret = sse_event_set_attr(event_id, ro_attrs[i], value);
>> +		report(ret == SBI_ERR_BAD_RANGE, "RO attribute %s not writable",
>> +		       attr_names[ro_attrs[i]]);
>> +	}
>> +
>> +	for (i = SBI_SSE_ATTR_STATUS; i <= SBI_SSE_ATTR_INTERRUPTED_A7; i++) {
>> +		ret = sse_event_get_attr(event_id, i, &value);
>> +		report(ret == SBI_SUCCESS, "Read single attribute %s", attr_names[i]);
>> +		/* Preferred Hart reset value is defined by SBI vendor and status injectable bit
>> +		 * also depends on the SBI implementation
>> +		 */
>> +		if (i != SBI_SSE_ATTR_STATUS && i != SBI_SSE_ATTR_PREFERRED_HART)
>> +			report(value == 0, "Attribute %s reset value is 0", attr_names[i]);
>> +	}
>> +
>> +	ret = sse_event_get_attrs(event_id, SBI_SSE_ATTR_STATUS, values,
>> +				  SBI_SSE_ATTR_INTERRUPTED_A7 - SBI_SSE_ATTR_STATUS);
>> +	report(ret == SBI_SUCCESS, "Read multiple attributes");
>> +
>> +#if __riscv_xlen > 32
>> +	ret = sse_event_set_attr(event_id, SBI_SSE_ATTR_PRIO, 0xFFFFFFFFUL + 1UL);
>> +	report(ret == SBI_ERR_INVALID_PARAM, "Write prio > 0xFFFFFFFF error");
>> +#endif
>> +
>> +	ret = sse_event_set_attr(event_id, SBI_SSE_ATTR_CONFIG, ~SBI_SSE_ATTR_CONFIG_ONESHOT);
>> +	report(ret == SBI_ERR_INVALID_PARAM, "Write invalid config error");
>> +
>> +	if (sse_event_is_global(event_id)) {
>> +		ret = sse_event_set_attr(event_id, SBI_SSE_ATTR_PREFERRED_HART, 0xFFFFFFFFUL);
>> +		report(ret == SBI_ERR_INVALID_PARAM, "Set invalid hart id error");
>> +	} else {
>> +		/* Set Hart on local event -> RO */
>> +		ret = sse_event_set_attr(event_id, SBI_SSE_ATTR_PREFERRED_HART,
>> +					 current_thread_info()->hartid);
>> +		report(ret == SBI_ERR_BAD_RANGE, "Set hart id on local event error");
>> +	}
>> +
>> +	/* Set/get flags, sepc, a6, a7 */
>> +	for (i = 0; i < ARRAY_SIZE(interrupted_attrs); i++) {
>> +		ret = sse_event_get_attr(event_id, interrupted_attrs[i], &value);
>> +		report(ret == 0, "Get interrupted %s no error", attr_names[interrupted_attrs[i]]);
>> +
>> +		/* 0x1 is a valid value for all the interrupted attributes */
>> +		ret = sse_event_set_attr(event_id, SBI_SSE_ATTR_INTERRUPTED_FLAGS, 0x1);
>> +		report(ret == SBI_ERR_INVALID_STATE, "Set interrupted flags invalid state error");
>> +	}
>> +
>> +	/* Attr_count == 0 */
>> +	sret = sse_event_get_attr_raw(event_id, SBI_SSE_ATTR_STATUS, 0, (unsigned long) &value, 0);
>> +	report(sret.error == SBI_ERR_INVALID_PARAM, "Read attribute attr_count == 0 error");
>> +
>> +	sret = sse_event_set_attr_raw(event_id, SBI_SSE_ATTR_STATUS, 0, (unsigned long) &value, 0);
>> +	report(sret.error == SBI_ERR_INVALID_PARAM, "Write attribute attr_count == 0 error");
>> +
>> +	/* Invalid attribute id */
>> +	ret = sse_event_get_attr(event_id, SBI_SSE_ATTR_INTERRUPTED_A7 + 1, &value);
>> +	report(ret == SBI_ERR_BAD_RANGE, "Read invalid attribute error");
>> +	ret = sse_event_set_attr(event_id, SBI_SSE_ATTR_INTERRUPTED_A7 + 1, value);
>> +	report(ret == SBI_ERR_BAD_RANGE, "Write invalid attribute error");
>> +
>> +	/* Misaligned phys address */
>> +	sret = sse_event_get_attr_raw(event_id, SBI_SSE_ATTR_STATUS, 1,
>> +				      ((unsigned long) &value | 0x1), 0);
>> +	report(sret.error == SBI_ERR_INVALID_ADDRESS, "Read attribute with invalid address error");
>> +	sret = sse_event_set_attr_raw(event_id, SBI_SSE_ATTR_STATUS, 1,
>> +				      ((unsigned long) &value | 0x1), 0);
>> +	report(sret.error == SBI_ERR_INVALID_ADDRESS, "Write attribute with invalid address error");
>> +
>> +	report_prefix_pop();
>> +}
>> +
>> +static void sse_test_register_error(unsigned long event_id)
>> +{
>> +	unsigned long ret;
>> +
>> +	report_prefix_push("register");
>> +
>> +	ret = sse_event_unregister(event_id);
>> +	report(ret == SBI_ERR_INVALID_STATE, "SSE unregister non registered event");
>> +
>> +	ret = sse_event_register_raw(event_id, (void *) 0x1, NULL);
>> +	report(ret == SBI_ERR_INVALID_PARAM, "SSE register misaligned entry");
>> +
>> +	ret = sse_event_register_raw(event_id, (void *) sse_entry, NULL);
>> +	report(ret == SBI_SUCCESS, "SSE register ok");
>> +	if (ret)
>> +		goto done;
>> +
>> +	ret = sse_event_register_raw(event_id, (void *) sse_entry, NULL);
>> +	report(ret == SBI_ERR_INVALID_STATE, "SSE register twice failure");
>> +	if (!ret)
>> +		goto done;
>> +
>> +	ret = sse_event_unregister(event_id);
>> +	report(ret == SBI_SUCCESS, "SSE unregister ok");
>> +
>> +done:
>> +	report_prefix_pop();
>> +}
>> +
>> +struct sse_simple_test_arg {
>> +	bool done;
>> +	unsigned long event_id;
>> +};
>> +
>> +static void sse_simple_handler(void *data, struct pt_regs *regs, unsigned int hartid)
>> +{
>> +	volatile struct sse_simple_test_arg *arg = data;
>> +	int ret, i;
>> +	const char *attr_name;
>> +	unsigned long event_id = arg->event_id, value, prev_value, flags, attr;
>> +	const unsigned long regs_len = (SBI_SSE_ATTR_INTERRUPTED_A7 - SBI_SSE_ATTR_INTERRUPTED_A6) +
>> +				       1;
>> +	unsigned long interrupted_state[regs_len];
>> +
>> +	if ((regs->status & SSTATUS_SPP) == 0)
>> +		report_fail("Interrupted S-mode");
>> +
>> +	if (hartid != current_thread_info()->hartid)
>> +		report_fail("Hartid correctly passed");
>> +
>> +	sse_check_state(event_id, SBI_SSE_STATE_RUNNING);
>> +	if (sse_event_pending(event_id))
>> +		report_fail("Event is not pending");
>> +
>> +	/* Set a6, a7, sepc, flags while running */
>> +	for (i = 0; i < ARRAY_SIZE(interrupted_attrs); i++) {
>> +		attr = interrupted_attrs[i];
>> +		attr_name = attr_names[attr];
>> +
>> +		ret = sse_event_get_attr(event_id, attr, &prev_value);
>> +		report(ret == 0, "Get attr %s no error", attr_name);
>> +
>> +		/* We test SBI_SSE_ATTR_INTERRUPTED_FLAGS below with specific flag values */
>> +		if (attr == SBI_SSE_ATTR_INTERRUPTED_FLAGS)
>> +			continue;
>> +
>> +		ret = sse_event_set_attr(event_id, attr, 0xDEADBEEF + i);
>> +		report(ret == 0, "Set attr %s invalid state no error", attr_name);
>> +
>> +		ret = sse_event_get_attr(event_id, attr, &value);
>> +		report(ret == 0, "Get attr %s modified value no error", attr_name);
>> +		report(value == 0xDEADBEEF + i, "Get attr %s modified value ok", attr_name);
>> +
>> +		ret = sse_event_set_attr(event_id, attr, prev_value);
>> +		report(ret == 0, "Restore attr %s value no error", attr_name);
>> +	}
>> +
>> +	/* Test all flags allowed for SBI_SSE_ATTR_INTERRUPTED_FLAGS*/
>> +	attr = SBI_SSE_ATTR_INTERRUPTED_FLAGS;
>> +	attr_name = attr_names[attr];
>> +	ret = sse_event_get_attr(event_id, attr, &prev_value);
>> +	report(ret == 0, "Get attr %s no error", attr_name);
>> +
>> +	for (i = 0; i < ARRAY_SIZE(interrupted_flags); i++) {
>> +		flags = interrupted_flags[i];
>> +		ret = sse_event_set_attr(event_id, attr, flags);
>> +		report(ret == 0, "Set interrupted %s value no error", attr_name);
>> +		ret = sse_event_get_attr(event_id, attr, &value);
>> +		report(value == flags, "Get attr %s modified value ok", attr_name);
>> +	}
>> +
>> +	ret = sse_event_set_attr(event_id, attr, prev_value);
>> +		report(ret == 0, "Restore attr %s value no error", attr_name);
>> +
>> +	/* Try to change HARTID/Priority while running */
>> +	if (sse_event_is_global(event_id)) {
>> +		ret = sse_event_set_attr(event_id, SBI_SSE_ATTR_PREFERRED_HART,
>> +					 current_thread_info()->hartid);
>> +		report(ret == SBI_ERR_INVALID_STATE, "Set hart id while running error");
>> +	}
>> +
>> +	ret = sse_event_set_attr(event_id, SBI_SSE_ATTR_PRIO, 0);
>> +	report(ret == SBI_ERR_INVALID_STATE, "Set priority while running error");
>> +
>> +	ret = sse_event_get_attrs(event_id, SBI_SSE_ATTR_INTERRUPTED_A6, interrupted_state,
>> +				  regs_len);
>> +	report(ret == SBI_SUCCESS, "Read interrupted context from SSE handler ok");
>> +	if (interrupted_state[0] != SBI_EXT_SSE_INJECT)
>> +		report_fail("Interrupted state a6 check ok");
>> +	if (interrupted_state[1] != SBI_EXT_SSE)
>> +		report_fail("Interrupted state a7 check ok");
>> +
>> +	arg->done = true;
>> +}
>> +
>> +static void sse_test_inject_simple(unsigned long event_id)
>> +{
>> +	unsigned long ret;
>> +	struct sse_handler_arg args;
>> +	volatile struct sse_simple_test_arg test_arg = {.event_id = event_id};
>> +
>> +	args.handler = sse_simple_handler;
>> +	args.handler_data = (void *) &test_arg;
>> +	args.stack = sse_alloc_stack();
>> +
>> +	report_prefix_push("simple");
>> +
>> +	ret = sse_check_state(event_id, SBI_SSE_STATE_UNUSED);
>> +	if (ret)
>> +		goto done;
>> +
>> +	ret = sse_event_register(event_id, &args);
>> +	report(ret == SBI_SUCCESS, "SSE register no error");
>> +	if (ret)
>> +		goto done;
>> +
>> +	ret = sse_check_state(event_id, SBI_SSE_STATE_REGISTERED);
>> +	if (ret)
>> +		goto done;
>> +
>> +	/* Be sure global events are targeting the current hart */
>> +	sse_global_event_set_current_hart(event_id);
>> +
>> +	ret = sse_event_enable(event_id);
>> +	report(ret == SBI_SUCCESS, "SSE enable no error");
>> +	if (ret)
>> +		goto done;
>> +
>> +	ret = sse_check_state(event_id, SBI_SSE_STATE_ENABLED);
>> +	if (ret)
>> +		goto done;
>> +
>> +	ret = sse_event_inject(event_id, current_thread_info()->hartid);
>> +	report(ret == SBI_SUCCESS, "SSE injection no error");
>> +	if (ret)
>> +		goto done;
>> +
>> +	barrier();
>> +	report(test_arg.done == 1, "SSE event handled ok");
>> +	test_arg.done = 0;
>> +
>> +	/* Set as oneshot and verify it is disabled */
>> +	ret = sse_event_disable(event_id);
>> +	report(ret == 0, "Disable event ok");
>> +	ret = sse_event_set_attr(event_id, SBI_SSE_ATTR_CONFIG, SBI_SSE_ATTR_CONFIG_ONESHOT);
>> +	report(ret == 0, "Set event attribute as ONESHOT");
>> +	ret = sse_event_enable(event_id);
>> +	report(ret == 0, "Enable event ok");
>> +
>> +	ret = sse_event_inject(event_id, current_thread_info()->hartid);
>> +	report(ret == SBI_SUCCESS, "SSE injection 2 no error");
>> +	if (ret)
>> +		goto done;
>> +
>> +	barrier();
>> +	report(test_arg.done == 1, "SSE event handled ok");
>> +	test_arg.done = 0;
>> +
>> +	ret = sse_check_state(event_id, SBI_SSE_STATE_REGISTERED);
>> +	if (ret)
>> +		goto done;
>> +
>> +	/* Clear ONESHOT FLAG */
>> +	sse_event_set_attr(event_id, SBI_SSE_ATTR_CONFIG, 0);
>> +
>> +	ret = sse_event_unregister(event_id);
>> +	report(ret == SBI_SUCCESS, "SSE unregister no error");
>> +	if (ret)
>> +		goto done;
>> +
>> +	sse_check_state(event_id, SBI_SSE_STATE_UNUSED);
>> +
>> +done:
>> +	sse_free_stack(args.stack);
>> +	report_prefix_pop();
>> +}
>> +
>> +struct sse_foreign_cpu_test_arg {
>> +	bool done;
>> +	unsigned int expected_cpu;
>> +	unsigned long event_id;
>> +};
>> +
>> +static void sse_foreign_cpu_handler(void *data, struct pt_regs *regs, unsigned int hartid)
>> +{
>> +	volatile struct sse_foreign_cpu_test_arg *arg = data;
>> +
>> +	/* For arg content to be visible */
>> +	smp_rmb();
>> +	if (arg->expected_cpu != current_thread_info()->cpu)
>> +		report_fail("Received event on CPU (%d), expected CPU (%d)",
>> +			    current_thread_info()->cpu, arg->expected_cpu);
>> +
>> +	arg->done = true;
>> +	/* For arg update to be visible for other CPUs */
>> +	smp_wmb();
>> +}
>> +
>> +struct sse_local_per_cpu {
>> +	struct sse_handler_arg args;
>> +	unsigned long ret;
>> +};
>> +
>> +struct sse_local_data {
>> +	unsigned long event_id;
>> +	struct sse_local_per_cpu *cpu_args[NR_CPUS];
>> +};
>> +
>> +static void sse_register_enable_local(void *data)
>> +{
>> +	struct sse_local_data *local_data = data;
>> +	struct sse_local_per_cpu *cpu_arg = local_data->cpu_args[current_thread_info()->cpu];
>> +
>> +	cpu_arg->ret = sse_event_register(local_data->event_id, &cpu_arg->args);
>> +	if (cpu_arg->ret)
>> +		return;
>> +
>> +	cpu_arg->ret = sse_event_enable(local_data->event_id);
>> +}
>> +
>> +static void sse_disable_unregister_local(void *data)
>> +{
>> +	struct sse_local_data *local_data = data;
>> +	struct sse_local_per_cpu *cpu_arg = local_data->cpu_args[current_thread_info()->cpu];
>> +
>> +	cpu_arg->ret = sse_event_disable(local_data->event_id);
>> +	if (cpu_arg->ret)
>> +		return;
>> +
>> +	cpu_arg->ret = sse_event_unregister(local_data->event_id);
>> +}
>> +
>> +static void sse_test_inject_local(unsigned long event_id)
>> +{
>> +	int cpu;
>> +	unsigned long ret;
>> +	struct sse_local_data local_data;
>> +	struct sse_local_per_cpu *cpu_arg;
>> +	volatile struct sse_foreign_cpu_test_arg test_arg = {.event_id = event_id};
>> +
>> +	report_prefix_push("local_dispatch");
>> +	local_data.event_id = event_id;
>> +
>> +	for_each_online_cpu(cpu) {
>> +		cpu_arg = calloc(1, sizeof(struct sse_handler_arg));
>> +
>> +		cpu_arg->args.stack = sse_alloc_stack();
>> +		cpu_arg->args.handler = sse_foreign_cpu_handler;
>> +		cpu_arg->args.handler_data = (void *)&test_arg;
>> +		local_data.cpu_args[cpu] = cpu_arg;
>> +	}
>> +
>> +	on_cpus(sse_register_enable_local, &local_data);
>> +	for_each_online_cpu(cpu) {
>> +		if (local_data.cpu_args[cpu]->ret)
>> +			report_abort("CPU failed to register/enable SSE event");
>> +
>> +		test_arg.expected_cpu = cpu;
>> +		/* For test_arg content to be visible for other CPUs */
>> +		smp_wmb();
>> +		ret = sse_event_inject(event_id, cpus[cpu].hartid);
>> +		if (ret)
>> +			report_abort("CPU failed to register/enable SSE event");
>> +
>> +		while (!test_arg.done) {
>> +			/* For test_arg update to be visible */
>> +			smp_rmb();
>> +		}
>> +
>> +		test_arg.done = false;
>> +	}
>> +
>> +	on_cpus(sse_disable_unregister_local, &local_data);
>> +	for_each_online_cpu(cpu) {
>> +		if (local_data.cpu_args[cpu]->ret)
>> +			report_abort("CPU failed to disable/unregister SSE event");
>> +	}
>> +
>> +	for_each_online_cpu(cpu) {
>> +		cpu_arg = local_data.cpu_args[cpu];
>> +
>> +		sse_free_stack(cpu_arg->args.stack);
>> +	}
>> +
>> +	report_pass("local event dispatch on all CPUs");
>> +	report_prefix_pop();
>> +
>> +}
>> +
>> +static void sse_test_inject_global(unsigned long event_id)
>> +{
>> +	unsigned long ret;
>> +	unsigned int cpu;
>> +	struct sse_handler_arg args;
>> +	volatile struct sse_foreign_cpu_test_arg test_arg = {.event_id = event_id};
>> +	enum sbi_sse_state state;
>> +
>> +	args.handler = sse_foreign_cpu_handler;
>> +	args.handler_data = (void *)&test_arg;
>> +	args.stack = sse_alloc_stack();
>> +
>> +	report_prefix_push("global_dispatch");
>> +
>> +	ret = sse_event_register(event_id, &args);
>> +	if (ret)
>> +		goto done;
>> +
>> +	for_each_online_cpu(cpu) {
>> +		test_arg.expected_cpu = cpu;
>> +		/* For test_arg content to be visible for other CPUs */
>> +		smp_wmb();
>> +		ret = sse_event_set_attr(event_id, SBI_SSE_ATTR_PREFERRED_HART, cpu);
>> +		if (ret) {
>> +			report_fail("Failed to set preferred hart");
>> +			goto done;
>> +		}
>> +
>> +		ret = sse_event_enable(event_id);
>> +		if (ret) {
>> +			report_fail("Failed to enable SSE event");
>> +			goto done;
>> +		}
>> +
>> +		ret = sse_event_inject(event_id, cpu);
>> +		if (ret) {
>> +			report_fail("Failed to inject event");
>> +			goto done;
>> +		}
>> +
>> +		while (!test_arg.done) {
>> +			/* For shared test_arg structure */
>> +			smp_rmb();
>> +		}
>> +
>> +		test_arg.done = false;
>> +
>> +		/* Wait for event to be in ENABLED state */
>> +		do {
>> +			ret = sse_get_state(event_id, &state);
>> +			if (ret) {
>> +				report_fail("Failed to get event state");
>> +				goto done;
>> +			}
>> +		} while (state != SBI_SSE_STATE_ENABLED);
>> +
>> +		ret = sse_event_disable(event_id);
>> +		if (ret) {
>> +			report_fail("Failed to disable SSE event");
>> +			goto done;
>> +		}
>> +
>> +		report_pass("Global event on CPU %d", cpu);
>> +	}
>> +
>> +done:
>> +	ret = sse_event_unregister(event_id);
>> +	if (ret)
>> +		report_fail("Failed to unregister event");
>> +
>> +	sse_free_stack(args.stack);
>> +	report_prefix_pop();
>> +}
>> +
>> +struct priority_test_arg {
>> +	unsigned long evt;
>> +	bool called;
>> +	u32 prio;
>> +	struct priority_test_arg *next_evt_arg;
>> +	void (*check_func)(struct priority_test_arg *arg);
>> +};
>> +
>> +static void sse_hi_priority_test_handler(void *arg, struct pt_regs *regs,
>> +					 unsigned int hartid)
>> +{
>> +	struct priority_test_arg *targ = arg;
>> +	struct priority_test_arg *next = targ->next_evt_arg;
>> +
>> +	targ->called = 1;
>> +	if (next) {
>> +		sse_event_inject(next->evt, current_thread_info()->hartid);
>> +		if (sse_event_pending(next->evt))
>> +			report_fail("Higher priority event is pending");
>> +		if (!next->called)
>> +			report_fail("Higher priority event was not handled");
>> +	}
>> +}
>> +
>> +static void sse_low_priority_test_handler(void *arg, struct pt_regs *regs,
>> +					  unsigned int hartid)
>> +{
>> +	struct priority_test_arg *targ = arg;
>> +	struct priority_test_arg *next = targ->next_evt_arg;
>> +
>> +	targ->called = 1;
>> +
>> +	if (next) {
>> +		sse_event_inject(next->evt, current_thread_info()->hartid);
>> +
>> +		if (!sse_event_pending(next->evt))
>> +			report_fail("Lower priority event is pending");
>> +
>> +		if (next->called)
>> +			report_fail("Lower priority event %s was handle before %s",
>> +			      sse_evt_name(next->evt), sse_evt_name(targ->evt));
>> +	}
>> +}
>> +
>> +static void sse_test_injection_priority_arg(struct priority_test_arg *in_args,
>> +					    unsigned int in_args_size,
>> +					    sse_handler_fn handler,
>> +					    const char *test_name)
>> +{
>> +	unsigned int i;
>> +	int ret;
>> +	unsigned long event_id;
>> +	struct priority_test_arg *arg;
>> +	unsigned int args_size = 0;
>> +	struct sse_handler_arg event_args[in_args_size];
>> +	struct priority_test_arg *args[in_args_size];
>> +	void *stack;
>> +	struct sse_handler_arg *event_arg;
>> +
>> +	report_prefix_push(test_name);
>> +
>> +	for (i = 0; i < in_args_size; i++) {
>> +		arg = &in_args[i];
>> +		event_id = arg->evt;
>> +		if (!sse_evt_can_inject(event_id))
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
>> +		event_id = arg->evt;
>> +		stack = sse_alloc_stack();
>> +
>> +		event_arg = &event_args[i];
>> +		event_arg->handler = handler;
>> +		event_arg->handler_data = (void *)arg;
>> +		event_arg->stack = stack;
>> +
>> +		if (i < (args_size - 1))
>> +			arg->next_evt_arg = args[i + 1];
>> +		else
>> +			arg->next_evt_arg = NULL;
>> +
>> +		/* Be sure global events are targeting the current hart */
>> +		sse_global_event_set_current_hart(event_id);
>> +
>> +		sse_event_register(event_id, event_arg);
>> +		sse_event_set_attr(event_id, SBI_SSE_ATTR_PRIO, arg->prio);
>> +		sse_event_enable(event_id);
>> +	}
>> +
>> +	/* Inject first event */
>> +	ret = sse_event_inject(args[0]->evt, current_thread_info()->hartid);
>> +	report(ret == SBI_SUCCESS, "SSE injection no error");
>> +
>> +	for (i = 0; i < args_size; i++) {
>> +		arg = args[i];
>> +		event_id = arg->evt;
>> +
>> +		if (!arg->called)
>> +			report_fail("Event %s handler called", sse_evt_name(arg->evt));
>> +
>> +		sse_event_disable(event_id);
>> +		sse_event_unregister(event_id);
>> +
>> +		event_arg = &event_args[i];
>> +		sse_free_stack(event_arg->stack);
>> +	}
>> +
>> +skip:
>> +	report_prefix_pop();
>> +}
>> +
>> +static struct priority_test_arg hi_prio_args[] = {
>> +	{.evt = SBI_SSE_EVENT_GLOBAL_SOFTWARE},
>> +	{.evt = SBI_SSE_EVENT_LOCAL_SOFTWARE},
>> +	{.evt = SBI_SSE_EVENT_LOCAL_PMU},
>> +	{.evt = SBI_SSE_EVENT_GLOBAL_RAS},
>> +	{.evt = SBI_SSE_EVENT_LOCAL_RAS},
>> +};
>> +
>> +static struct priority_test_arg low_prio_args[] = {
>> +	{.evt = SBI_SSE_EVENT_LOCAL_RAS},
>> +	{.evt = SBI_SSE_EVENT_GLOBAL_RAS},
>> +	{.evt = SBI_SSE_EVENT_LOCAL_PMU},
>> +	{.evt = SBI_SSE_EVENT_LOCAL_SOFTWARE},
>> +	{.evt = SBI_SSE_EVENT_GLOBAL_SOFTWARE},
>> +};
>> +
>> +static struct priority_test_arg prio_args[] = {
>> +	{.evt = SBI_SSE_EVENT_GLOBAL_SOFTWARE, .prio = 5},
>> +	{.evt = SBI_SSE_EVENT_LOCAL_SOFTWARE, .prio = 10},
>> +	{.evt = SBI_SSE_EVENT_LOCAL_PMU, .prio = 15},
>> +	{.evt = SBI_SSE_EVENT_GLOBAL_RAS, .prio = 20},
>> +	{.evt = SBI_SSE_EVENT_LOCAL_RAS, .prio = 25},
>> +};
>> +
>> +static struct priority_test_arg same_prio_args[] = {
>> +	{.evt = SBI_SSE_EVENT_LOCAL_PMU, .prio = 0},
>> +	{.evt = SBI_SSE_EVENT_LOCAL_RAS, .prio = 10},
>> +	{.evt = SBI_SSE_EVENT_LOCAL_SOFTWARE, .prio = 10},
>> +	{.evt = SBI_SSE_EVENT_GLOBAL_SOFTWARE, .prio = 10},
>> +	{.evt = SBI_SSE_EVENT_GLOBAL_RAS, .prio = 20},
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
>> +static bool sse_can_inject(unsigned long event_id)
>> +{
>> +	int ret;
>> +	unsigned long status;
>> +
>> +	ret = sse_event_get_attr(event_id, SBI_SSE_ATTR_STATUS, &status);
>> +	report(ret == 0, "SSE get attr status no error");
>> +	if (ret)
>> +		return 0;
>> +
>> +	return !!(status & BIT(SBI_SSE_ATTR_STATUS_INJECT_OFFSET));
>> +}
>> +
>> +static void boot_secondary(void *data)
>> +{
>> +}
>> +
>> +void check_sse(void)
>> +{
>> +	unsigned long i, event;
>> +
>> +	/*
>> +	 * Dummy wakeup of all processors since some of them will be targeted
>> +	 * by global events without going through the wakeup call.
>> +	 */
>> +	on_cpus(boot_secondary, NULL);
>> +	report_prefix_push("sse");
>> +
>> +	if (!sbi_probe(SBI_EXT_SSE)) {
>> +		report_skip("SSE extension not available");
>> +		report_prefix_pop();
>> +		return;
>> +	}
>> +
>> +	for (i = 0; i < ARRAY_SIZE(sse_event_infos); i++) {
>> +		event = sse_event_infos[i].event_id;
>> +		report_prefix_push(sse_event_infos[i].name);
>> +		if (!sse_can_inject(event)) {
>> +			report_skip("Event does not support injection");
>> +			report_prefix_pop();
>> +			continue;
>> +		} else {
>> +			sse_event_infos[i].can_inject = true;
>> +		}
>> +		sse_test_attr(event);
>> +		sse_test_register_error(event);
>> +		sse_test_inject_simple(event);
>> +		if (sse_event_is_global(event))
>> +			sse_test_inject_global(event);
>> +		else
>> +			sse_test_inject_local(event);
>> +
>> +		report_prefix_pop();
>> +	}
>> +
>> +	sse_test_injection_priority();
>> +
>> +	report_prefix_pop();
>> +}
>> diff --git a/riscv/sbi.c b/riscv/sbi.c
>> index 6f4ddaf1..96dfb2ca 100644
>> --- a/riscv/sbi.c
>> +++ b/riscv/sbi.c
>> @@ -1451,6 +1451,7 @@ int main(int argc, char **argv)
>>  	check_hsm();
>>  	check_dbcn();
>>  	check_susp();
>> +	check_sse();
>>  
>>  	return report_summary();
>>  }
>> diff --git a/riscv/unittests.cfg b/riscv/unittests.cfg
>> index 2eb760ec..ddd05de7 100644
>> --- a/riscv/unittests.cfg
>> +++ b/riscv/unittests.cfg
>> @@ -18,3 +18,7 @@ groups = selftest
>>  file = sbi.flat
>>  smp = $MAX_SMP
>>  groups = sbi
>> +
>> +[sbi_sse]
>> +file = sbi_sse.flat
>> +groups = sbi
>> -- 
>> 2.45.2
>>
> 
> I only had time for quick skim, but it looks pretty good.
> 
> Thanks,
> drew


