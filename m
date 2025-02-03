Return-Path: <kvm+bounces-37115-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 25E16A254C0
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 09:47:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9B00116650E
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 08:47:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F117C1FC0FF;
	Mon,  3 Feb 2025 08:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="pxCXuo0r"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 861791D9A54
	for <kvm@vger.kernel.org>; Mon,  3 Feb 2025 08:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738572462; cv=none; b=t1DaTKV/1cViqQI1FL+uG4Y+e4CvzI2mOZgxjzgVoiPegAc8ulqduH0Ss9axQUsCv8fYelps3iRQfUqmoM30Porpnrtbvr0KazxviMV+SPzQBZCdLuh/mjhnYTDXlktmurei06CuvnKu3GCC6Zj/D2aGDg5giMDuIdC8PYSWB5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738572462; c=relaxed/simple;
	bh=MdAQkYNWzZMWJnGjtcSMkoNSEHYf0WOQNgvTYM8p9Wo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=koGdrRWpAVzBN89CyDhuAxQhtOzkCz7sPx3IE4X2xIA6pbQD+nzxnSbOjvWAonspMoepBpGhixvdo3LYbPTZcL+mxh4gHtgGxBTJINzuYpxCuKIsarS2nLJ1L0KFTAQtfMb0Y6OcEsBaUNMI3gX1/zGouqC8T2pfalNCLnXafEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=pxCXuo0r; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4361dc6322fso27409395e9.3
        for <kvm@vger.kernel.org>; Mon, 03 Feb 2025 00:47:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1738572458; x=1739177258; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xUeEANZV+vHyvkdbqegJHcNcPne4sU+ZdjerSN7tQJA=;
        b=pxCXuo0rxgNvOoXCElDsAa3wfyx351qxfzrRbwu1CRYh5xxRQupJetVzM1ybYxiiTB
         IMiKB3uCxAj6z/SMWUtqppEtVTjM92pE4uWPiOHHT3d+0iaYzABHI4EtWI1ApgArbXiC
         gVLfPwrxMoe3iR+Mi0Mq6ni8Vr4n8LDdSy1sPFNPtSViVkxOakQAYKU+IXlVD7P0s4dR
         la/cCZzMrYkbOSxg7Ys10RQNqumP/gyNY3IJoazIW+qdZQUklcG0hX6u5+zbgy2prOtP
         xaNSjE6gMtzEbF+jwZJqj0YzwAMmhG6RcXKs92TpC17N5Kme7If+apbercr2rHluCkMM
         //xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738572458; x=1739177258;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xUeEANZV+vHyvkdbqegJHcNcPne4sU+ZdjerSN7tQJA=;
        b=fpyTF7jrXicHvX5WU5xgBN6fBRZyE+ey728JPh8UHh3vS73YDdoVfXCCYR1BOxDNoA
         w+xY3nJwMQB7yaT+0vDE2avFUm1/fJrgonghT6g3gw+dJFCK7EgxmitqW+dU5z9Xd+Kf
         yWeW5tcjgBLtp49h8rSzbtd/5zlEPEMDD+4fvB06jdPViNNZTqkpVmvDf9V8DxRBE3O5
         sVM7dx9XuohZ1sK0Gaz75c62UpDFJtXws2xxVbtJF1qnA+VYfPsU9vaB/xsRKGth4DyV
         v/UGDuz9W+XGsbNyyb4kGKtKpuSe6QzX2JNv0B5vfEXM8yBKc98wHYxFeG+TlpL2bEyG
         BJkg==
X-Gm-Message-State: AOJu0YxLkTebn7B8g+75WTeRWqWQE+T+KJ7L8AWprB+SipcQuYwo0u1+
	akO4fAOwx2aCiNuuTMBwa2FikiXkktNESQv9m3IaTw5qOCk6sq/ZKNI19MmnrHw=
X-Gm-Gg: ASbGncvAQePo2X2nMxh771xDy1Yn99jIl1UWfirmntIsas0mY32swJRyL+JLP5s/toM
	MkyscRmccvljxwBu89XYIIjzJfd/rCubX69jIwBXgPamleZxJnDJErogPlchwfZF/4sqM3YnBEH
	2j1fDF4924BCsUnMCnymoYrn2WlgBckqquV49/ko67/kYHJn1cejm7ftbG4z3oKSIrg0mNX8QFB
	2VJSC+WYVi9SISmVpLAmN+LKMT+EAKmBESWrpL6lyRi3driheOCpWcHl/T/kr5liu5QMW7xB/b2
	tK90Ll0U5ZEpCqU1hAXbZhKD1wldGi21Y2iUy/jsQdx7Y3SL1Kyn0cKbpstd
X-Google-Smtp-Source: AGHT+IEjOmLBiehNQE7sTeLu67T8FXTO99wYA27TfHFyOBaCi3KmPjk1pQEdHGZwRWTQncH01M0KZA==
X-Received: by 2002:a7b:c3cd:0:b0:438:e231:d342 with SMTP id 5b1f17b1804b1-438e231d503mr115055825e9.1.1738572457754;
        Mon, 03 Feb 2025 00:47:37 -0800 (PST)
Received: from ?IPV6:2a01:e0a:e17:9700:16d2:7456:6634:9626? ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438e23e6984sm146205785e9.22.2025.02.03.00.47.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Feb 2025 00:47:37 -0800 (PST)
Message-ID: <242979a7-8264-4768-894a-e566901cbbef@rivosinc.com>
Date: Mon, 3 Feb 2025 09:47:36 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v3 2/2] riscv: Add tests for SBI FWFT
 extension
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 Andrew Jones <ajones@ventanamicro.com>, Anup Patel
 <apatel@ventanamicro.com>, Atish Patra <atishp@rivosinc.com>
References: <20250128141543.1338677-1-cleger@rivosinc.com>
 <20250128141543.1338677-3-cleger@rivosinc.com>
 <20250129-ab75148a5b1ce97ae8529532@orel>
Content-Language: en-US
From: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
In-Reply-To: <20250129-ab75148a5b1ce97ae8529532@orel>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 29/01/2025 15:17, Andrew Jones wrote:
> On Tue, Jan 28, 2025 at 03:15:42PM +0100, Clément Léger wrote:
>> Add tests for the FWFT SBI extension. Currently, only the reserved range
>> as well as the misaligned exception delegation are used.
>>
>> Signed-off-by: Clément Léger <cleger@rivosinc.com>
>> ---
>>  riscv/Makefile      |   2 +-
>>  lib/riscv/asm/sbi.h |  34 ++++++++
>>  riscv/sbi-fwft.c    | 190 ++++++++++++++++++++++++++++++++++++++++++++
>>  riscv/sbi.c         |   3 +
>>  4 files changed, 228 insertions(+), 1 deletion(-)
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
>> index 00000000..c9292cfb
>> --- /dev/null
>> +++ b/riscv/sbi-fwft.c
>> @@ -0,0 +1,190 @@
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
>> +#include "sbi-tests.h"
>> +
>> +void check_fwft(void);
>> +
>> +
>> +static struct sbiret fwft_set_raw(unsigned long feature, unsigned long value, unsigned long flags)
>> +{
>> +	return sbi_ecall(SBI_EXT_FWFT, SBI_EXT_FWFT_SET, feature, value, flags, 0, 0, 0);
>> +}
>> +
>> +static struct sbiret fwft_set(uint32_t feature, unsigned long value, unsigned long flags)
>> +{
>> +	return fwft_set_raw(feature, value, flags);
>> +}
>> +
>> +static struct sbiret fwft_get_raw(unsigned long feature)
>> +{
>> +	return sbi_ecall(SBI_EXT_FWFT, SBI_EXT_FWFT_GET, feature, 0, 0, 0, 0, 0);
>> +}
>> +
>> +static struct sbiret fwft_get(uint32_t feature)
>> +{
>> +	return fwft_get_raw(feature);
>> +}
>> +
>> +static void fwft_check_reserved(unsigned long id)
>> +{
>> +	struct sbiret ret;
>> +
>> +	ret = fwft_get(id);
>> +	sbiret_report_error(&ret, SBI_ERR_DENIED, "get reserved feature 0x%lx", id);
>> +
>> +	ret = fwft_set(id, 1, 0);
>> +	sbiret_report_error(&ret, SBI_ERR_DENIED, "set reserved feature 0x%lx", id);
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
>> +		sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM,
>> +				    "get feature 0x%lx error", BIT(32));
>> +
>> +		ret = fwft_set_raw(BIT(32), 0, 0);
>> +		sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM,
>> +				    "set feature 0x%lx error", BIT(32));
> 
> At least with the compiler I'm using, the code inside this
> "if (__riscv_xlen > 32)" block is still getting compiled for
> rv32 and breaking on the BIT(). It doesn't help to use BIT_ULL() here
> since fwft_get/set_raw() take longs. I guess we'll have to use #if.

Acked, forgot to compile for rv32 that time. I'll double check for SSE.

Thanks,

Clément

> 
> Fixed on merge.
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
>> +static struct sbiret fwft_misaligned_exc_set(unsigned long value, unsigned long flags)
>> +{
>> +	return fwft_set(SBI_FWFT_MISALIGNED_EXC_DELEG, value, flags);
>> +}
>> +
>> +static struct sbiret fwft_misaligned_exc_get(void)
>> +{
>> +	return fwft_get(SBI_FWFT_MISALIGNED_EXC_DELEG);
>> +}
>> +
>> +static void fwft_check_misaligned_exc_deleg(void)
>> +{
>> +	struct sbiret ret;
>> +
>> +	report_prefix_push("misaligned_exc_deleg");
>> +
>> +	ret = fwft_misaligned_exc_get();
>> +	if (ret.error == SBI_ERR_NOT_SUPPORTED) {
>> +		report_skip("SBI_FWFT_MISALIGNED_EXC_DELEG is not supported");
>> +		return;
>> +	}
>> +
>> +	if (!sbiret_report_error(&ret, 0, "Get misaligned deleg feature no error"))
>> +		return;
>> +
>> +	ret = fwft_misaligned_exc_set(2, 0);
>> +	sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM,
>> +			    "Set misaligned deleg feature invalid value 2");
>> +	ret = fwft_misaligned_exc_set(0xFFFFFFFF, 0);
>> +	sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM,
>> +			    "Set misaligned deleg feature invalid value 0xFFFFFFFF");
>> +
>> +	if (__riscv_xlen > 32) {
>> +		ret = fwft_misaligned_exc_set(BIT(32), 0);
>> +		sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM,
>> +				    "Set misaligned deleg with invalid value > 32bits");
>> +
>> +		ret = fwft_misaligned_exc_set(0, BIT(32));
>> +		sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM,
>> +				    "Set misaligned deleg with invalid flag > 32bits");
> 
> Same comment as above and also fixed on merge.
> 
> Thanks,
> drew


