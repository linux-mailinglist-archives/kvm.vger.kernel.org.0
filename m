Return-Path: <kvm+bounces-32407-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A36DD9D7D67
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 09:48:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 24FBC16114C
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 08:48:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F075718FC84;
	Mon, 25 Nov 2024 08:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="2GZI1hyB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8279B18CBEC
	for <kvm@vger.kernel.org>; Mon, 25 Nov 2024 08:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732524414; cv=none; b=YmSW8y/6z0az/vJws6oVEHPsnGng6dbS7wcu+fkyM8iVxmtn+79iGe5Z9ulW2nELD0YXKadO3tbeHc0YgHKn8xSfoDOxXQuGC2RgUy5sownwWqmJqkF/Qz45xh/HQTp0htvLv90dKvRcjdz0U+K2Rw9CJyXYoJoumbZKJWgsFVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732524414; c=relaxed/simple;
	bh=Ph205mEdiCycxPAEgK2IM/a8yeCyBRh4YGYGFvM/Zsw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uWH7wJoM2nuieHc6GMvw4WlqNmd7O4oZkHUVMk/DJPvSRep9uReOcEem+1hZKVxKo5LRIYVn8hkAtXQhhyHflWRcTmv54qxMv4EXwV7jSJ8Ap/KFLV3PuEiUIjWU5BH8QvN7TMpqGwnX+coFo/HBPnLxcPnQ4Njau9uLzeFZ+4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=2GZI1hyB; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-434a1833367so1063025e9.1
        for <kvm@vger.kernel.org>; Mon, 25 Nov 2024 00:46:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1732524410; x=1733129210; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Vio/n7OiiDid0j1bEWNQFL6ZAeovWhRgATN2vY16mU8=;
        b=2GZI1hyBlKvXyQvBfwV84Te6hSpzs+zQu6QTEc5dUJqYGP3YW3/afByUqj8o0D1ek0
         JMlOR8bYBZpU9MP5DsRGgP1IrSHN59FgKciXZEO8vd7e4jlRTTLc3W56jG76kn3HNLPS
         /AryGLcjK7OcGaA9n4iQiDw7DVIljA+RNa/mD8TGCBbbmior1ClDynRV3Gkb8xQXHk9B
         Epd9MbPwR/KMgMOXzY+ly7c8xb2Mw0f8TbvKdzjckr8rD5ZTxurNTMrd+KHVZPdnBAYq
         I7GxmYFaJoRCpenlSUTAfzYso+cosncDnLqgm8Tj/f9ZSCisirhqjajwT1WGcqYMsK94
         /qjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732524410; x=1733129210;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Vio/n7OiiDid0j1bEWNQFL6ZAeovWhRgATN2vY16mU8=;
        b=A22iBivtoPBOPR9i1KEsiE6vZDSEgRCAZC/CxdFjFaOIeNxO8lZq5TL3avnEwpupYJ
         f70L/zl8oLIka/hd+atW4fKCdNkx7hjUeO+Ijonp7Nmf1nB4kbssT7cRWl2a3Jh1+MnT
         Mqu2PTb+wt8YROc5pLv+WK9hrd8Rko9P5Ktxm7eswPybG/1W7xepX1my77N5mAtRFb1B
         enAO5FpGWU1dcdTYdGfcxH5ubFW63DnkKDC67PKo1ndwKMoq+UQoYOCIve58ajIZDwHV
         bmpM+rcOBVehvtBXEJrH4CcErhfyNtVu/mFBaGteCwdR1rlp5sYWFYKgUA7e6Es/3MH5
         6fTA==
X-Gm-Message-State: AOJu0Yz8P8jZ1vz7fL0ycB4xJQcP/GhEBnagTTB3ESeHBFZzdGRZ9kt4
	g37QQErMvWUZjJP0ZblNEFKNW4/AYHlfALZOFS0tdGEvYzSFoT1a+8RU5y9TqrfzKhM93Aec56M
	7
X-Gm-Gg: ASbGncs4oH5r1ps5HwsR4LlcbgCu45hAz1UD77czpIQggIKhagoAPn5M88sWt8v+ucA
	ZD2LiG9NAkIWl0dasg2/iwWsVdiJPs5o21O1XHm/1LGDu38cdFH3JMKW8cwUppdsytm9a2/aGdU
	sMS5pY8zgB9UUzQjBnmtnt2lD+MzDRGTzd1PP5tYjqwfOhfw5Z7N4Up13DJGSMLo8SuZ5g9sLQq
	WmHZhIyD09hYo5EEu6J/urTqLKfyA3WK3lB960Edp8d6k59RbK27fuGZosbjrTYF8nbJax/xYcO
	jFPmvpF3us+CimHLTLA=
X-Google-Smtp-Source: AGHT+IF9HRBk1O6nq7uwU0RhwGegPgfbiidENXGqVJkjmuwp6fzOrPFf8gnM+DLjYCIdWrECuJfsTQ==
X-Received: by 2002:a05:600c:218a:b0:434:9f9a:100c with SMTP id 5b1f17b1804b1-4349f9a116dmr19047825e9.12.1732524409884;
        Mon, 25 Nov 2024 00:46:49 -0800 (PST)
Received: from ?IPV6:2a01:e0a:e17:9700:16d2:7456:6634:9626? ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3825fbc34bdsm9990657f8f.78.2024.11.25.00.46.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Nov 2024 00:46:49 -0800 (PST)
Message-ID: <90b8e2d2-1fc6-4166-a3bf-3cd8af3b5b8d@rivosinc.com>
Date: Mon, 25 Nov 2024 09:46:48 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v2 2/3] riscv: lib: Add SSE assembly entry
 handling
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 Andrew Jones <ajones@ventanamicro.com>, Anup Patel
 <apatel@ventanamicro.com>, Atish Patra <atishp@rivosinc.com>
References: <20241122140459.566306-1-cleger@rivosinc.com>
 <20241122140459.566306-3-cleger@rivosinc.com>
 <20241122-a7e54373559727e1e296b8c4@orel>
Content-Language: en-US
From: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
In-Reply-To: <20241122-a7e54373559727e1e296b8c4@orel>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 22/11/2024 17:20, Andrew Jones wrote:
> On Fri, Nov 22, 2024 at 03:04:56PM +0100, Clément Léger wrote:
>> Add a SSE entry assembly code to handle SSE events. Events should be
>> registered with a struct sse_handler_arg containing a correct stack and
>> handler function.
>>
>> Signed-off-by: Clément Léger <cleger@rivosinc.com>
>> ---
>>  riscv/Makefile          |   1 +
>>  lib/riscv/asm/sse.h     |  16 +++++++
>>  lib/riscv/sse-entry.S   | 100 ++++++++++++++++++++++++++++++++++++++++
> 
> Let's just add the entry function to riscv/sbi-asm.S and the
> sse_handler_arg struct definition to riscv/sbi-tests.h

Hi drew,

I need to have some offset generated using asm-offsets.c which is in
lib/riscv. If I move the sse_handler_arg in riscv/sbi-tests.h, that will
be really off to include that file in the lib/riscv/asm-offsets.c.
Except if you have some other solution.

> 
>>  lib/riscv/asm-offsets.c |   9 ++++
>>  4 files changed, 126 insertions(+)
>>  create mode 100644 lib/riscv/asm/sse.h
>>  create mode 100644 lib/riscv/sse-entry.S
>>
>> diff --git a/riscv/Makefile b/riscv/Makefile
>> index 28b04156..e50621ad 100644
>> --- a/riscv/Makefile
>> +++ b/riscv/Makefile
>> @@ -39,6 +39,7 @@ cflatobjs += lib/riscv/sbi.o
>>  cflatobjs += lib/riscv/setjmp.o
>>  cflatobjs += lib/riscv/setup.o
>>  cflatobjs += lib/riscv/smp.o
>> +cflatobjs += lib/riscv/sse-entry.o
>>  cflatobjs += lib/riscv/stack.o
>>  cflatobjs += lib/riscv/timer.o
>>  ifeq ($(ARCH),riscv32)
>> diff --git a/lib/riscv/asm/sse.h b/lib/riscv/asm/sse.h
>> new file mode 100644
>> index 00000000..557f6680
>> --- /dev/null
>> +++ b/lib/riscv/asm/sse.h
>> @@ -0,0 +1,16 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>> +#ifndef _ASMRISCV_SSE_H_
>> +#define _ASMRISCV_SSE_H_
>> +
>> +typedef void (*sse_handler_fn)(void *data, struct pt_regs *regs, unsigned int hartid);
>> +
>> +struct sse_handler_arg {
>> +	unsigned long reg_tmp;
>> +	sse_handler_fn handler;
>> +	void *handler_data;
>> +	void *stack;
>> +};
>> +
>> +extern void sse_entry(void);
>> +
>> +#endif /* _ASMRISCV_SSE_H_ */
>> diff --git a/lib/riscv/sse-entry.S b/lib/riscv/sse-entry.S
>> new file mode 100644
>> index 00000000..bedc47e9
>> --- /dev/null
>> +++ b/lib/riscv/sse-entry.S
>> @@ -0,0 +1,100 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>> +/*
>> + * SBI SSE entry code
>> + *
>> + * Copyright (C) 2024, Rivos Inc., Clément Léger <cleger@rivosinc.com>
>> + */
>> +#include <asm/asm.h>
>> +#include <asm/asm-offsets.h>
>> +#include <asm/csr.h>
>> +
>> +.global sse_entry
>> +sse_entry:
>> +	/* Save stack temporarily */
>> +	REG_S sp, SSE_REG_TMP(a6)
>> +	/* Set entry stack */
>> +	REG_L sp, SSE_HANDLER_STACK(a6)
>> +
>> +	addi sp, sp, -(PT_SIZE)
>> +	REG_S ra, PT_RA(sp)
>> +	REG_S s0, PT_S0(sp)
>> +	REG_S s1, PT_S1(sp)
>> +	REG_S s2, PT_S2(sp)
>> +	REG_S s3, PT_S3(sp)
>> +	REG_S s4, PT_S4(sp)
>> +	REG_S s5, PT_S5(sp)
>> +	REG_S s6, PT_S6(sp)
>> +	REG_S s7, PT_S7(sp)
>> +	REG_S s8, PT_S8(sp)
>> +	REG_S s9, PT_S9(sp)
>> +	REG_S s10, PT_S10(sp)
>> +	REG_S s11, PT_S11(sp)
>> +	REG_S tp, PT_TP(sp)
>> +	REG_S t0, PT_T0(sp)
>> +	REG_S t1, PT_T1(sp)
>> +	REG_S t2, PT_T2(sp)
>> +	REG_S t3, PT_T3(sp)
>> +	REG_S t4, PT_T4(sp)
>> +	REG_S t5, PT_T5(sp)
>> +	REG_S t6, PT_T6(sp)
>> +	REG_S gp, PT_GP(sp)
>> +	REG_S a0, PT_A0(sp)
>> +	REG_S a1, PT_A1(sp)
>> +	REG_S a2, PT_A2(sp)
>> +	REG_S a3, PT_A3(sp)
>> +	REG_S a4, PT_A4(sp)
>> +	REG_S a5, PT_A5(sp)
>> +	csrr a1, CSR_SEPC
>> +	REG_S a1, PT_EPC(sp)
>> +	csrr a2, CSR_SSTATUS
>> +	REG_S a2, PT_STATUS(sp)
>> +
>> +	REG_L a0, SSE_REG_TMP(a6)
>> +	REG_S a0, PT_SP(sp)
>> +
>> +	REG_L t0, SSE_HANDLER(a6)
>> +	REG_L a0, SSE_HANDLER_DATA(a6)
>> +	move a1, sp
>> +	move a2, a7
> 
> nit: prefer 'mv'
> 
>> +	jalr t0
>> +
>> +
>> +	REG_L a1, PT_EPC(sp)
>> +	REG_L a2, PT_STATUS(sp)
>> +	csrw CSR_SEPC, a1
>> +	csrw CSR_SSTATUS, a2
>> +
>> +	REG_L ra, PT_RA(sp)
>> +	REG_L s0, PT_S0(sp)
>> +	REG_L s1, PT_S1(sp)
>> +	REG_L s2, PT_S2(sp)
>> +	REG_L s3, PT_S3(sp)
>> +	REG_L s4, PT_S4(sp)
>> +	REG_L s5, PT_S5(sp)
>> +	REG_L s6, PT_S6(sp)
>> +	REG_L s7, PT_S7(sp)
>> +	REG_L s8, PT_S8(sp)
>> +	REG_L s9, PT_S9(sp)
>> +	REG_L s10, PT_S10(sp)
>> +	REG_L s11, PT_S11(sp)
>> +	REG_L tp, PT_TP(sp)
>> +	REG_L t0, PT_T0(sp)
>> +	REG_L t1, PT_T1(sp)
>> +	REG_L t2, PT_T2(sp)
>> +	REG_L t3, PT_T3(sp)
>> +	REG_L t4, PT_T4(sp)
>> +	REG_L t5, PT_T5(sp)
>> +	REG_L t6, PT_T6(sp)
>> +	REG_L gp, PT_GP(sp)
>> +	REG_L a0, PT_A0(sp)
>> +	REG_L a1, PT_A1(sp)
>> +	REG_L a2, PT_A2(sp)
>> +	REG_L a3, PT_A3(sp)
>> +	REG_L a4, PT_A4(sp)
>> +	REG_L a5, PT_A5(sp)
>> +
>> +	REG_L sp, PT_SP(sp)
>> +
>> +	li a7, ASM_SBI_EXT_SSE
>> +	li a6, ASM_SBI_EXT_SSE_COMPLETE
>> +	ecall
>> diff --git a/lib/riscv/asm-offsets.c b/lib/riscv/asm-offsets.c
>> index 6c511c14..b3465eeb 100644
>> --- a/lib/riscv/asm-offsets.c
>> +++ b/lib/riscv/asm-offsets.c
>> @@ -3,7 +3,9 @@
>>  #include <elf.h>
>>  #include <asm/processor.h>
>>  #include <asm/ptrace.h>
>> +#include <asm/sbi.h>
>>  #include <asm/smp.h>
>> +#include <asm/sse.h>
>>  
>>  int main(void)
>>  {
>> @@ -63,5 +65,12 @@ int main(void)
>>  	OFFSET(THREAD_INFO_HARTID, thread_info, hartid);
>>  	DEFINE(THREAD_INFO_SIZE, sizeof(struct thread_info));
>>  
>> +	OFFSET(SSE_REG_TMP, sse_handler_arg, reg_tmp);
>> +	OFFSET(SSE_HANDLER, sse_handler_arg, handler);
>> +	OFFSET(SSE_HANDLER_DATA, sse_handler_arg, handler_data);
>> +	OFFSET(SSE_HANDLER_STACK, sse_handler_arg, stack);
>> +	DEFINE(ASM_SBI_EXT_SSE, SBI_EXT_SSE);
>> +	DEFINE(ASM_SBI_EXT_SSE_COMPLETE, SBI_EXT_SSE_COMPLETE);
> 
> sbi_hsm_check just uses the numbers and adds comments. We could instead
> move the extension IDs from an enum to defines outside the
> #ifndef __ASSEMBLY__ and function IDs can also be defines accessible
> by assembly.

With respect to my previous comment, that applies for the IDs but I
still need the offsets to be generated. Any idea ?

Thanks, Clément

> 
>> +
>>  	return 0;
>>  }
>> -- 
>> 2.45.2
>>
> 
> Thanks,
> drew


