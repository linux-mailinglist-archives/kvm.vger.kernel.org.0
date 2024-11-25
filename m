Return-Path: <kvm+bounces-32454-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B54149D886E
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 15:49:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 04A89B34BFF
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 14:42:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8279E1B3920;
	Mon, 25 Nov 2024 14:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="q0teQbxu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDF0216419
	for <kvm@vger.kernel.org>; Mon, 25 Nov 2024 14:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732545699; cv=none; b=O4HWrWYC4YoLRIdCMJid+s2WRIHjGcvjKsuWlaqQ+egkhKWuwMJBbtNjOetcTS68LZHEeeZg3cif7mISGJdY+Era2utJZBZyj5Qv7/DEStEmYM+VY0/G6KMuz73yRMtBO3cSzJ6Bf/TyjE5EUCcCOxCYQwPS3GJJz4UnoCNj+ZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732545699; c=relaxed/simple;
	bh=wcFk27tEaOCxQdKShFqW9srwLXJShyAcDEmMv0CA6DA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t1zeBe57ZT5fWEuEo24BKLbjZQhva1qVY2Gg+OlT9vEwpea41i8tSPQv5kxyUbavBIA58WbrIcrLVdWoNO5qjkzJk1FXS+/+MIfsoZ9vQbOQ8oaVd3yev9bR7vfBYVZ5XCbl//K1eWdxAyj5eJxFBcYUaUH3J57wlHlfDoVwlIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=q0teQbxu; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-212348d391cso44071355ad.2
        for <kvm@vger.kernel.org>; Mon, 25 Nov 2024 06:41:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1732545696; x=1733150496; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=S3T+CVAc6+kkbHp7ZsbMeBANr7K+fS6n4h5Oxm62hD4=;
        b=q0teQbxu9Oa4woofbM6oV6ZKVpQ5TvIh3vT3AfBa4L7QiV3s5XzcxskbFeN/yyeSER
         EGZsfrycscnuyJnVMrAiZgjgkLQtBFBZNh+4eqyA7ycMPHhpVNnVRxIhBB4DMWAcuPcb
         HlBQTVZ/CYGZ2T2D9sa3DgMNWcQcLwYVRc81pDQpTzaj+ddors+G4MVZM79ZYfqYIzkc
         u/g11MiJ2bVAM0w6W4kRUHNz9fgYIfNOXtDLFt8udIUWlJ3y1O13R4E0uTE5150ezSIX
         y2BlxK6BVjxrS2qzCTq3RhTRN/TP9QURPMzPod1xij9lKZupfmUBVaAuZpf6HE3hOHcq
         OlgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732545696; x=1733150496;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S3T+CVAc6+kkbHp7ZsbMeBANr7K+fS6n4h5Oxm62hD4=;
        b=t28JUqFtyL5Zos006ybZF93zxNBeo/K1gZONrakiw5/In+8ZljV5I0//1e7AjG9eHV
         ce9E42rlehAOWM7PZgwzcv0F2d3rIk5GPfuSUbO9VhuHfUIe4mNFVG86C5HHyAaE1M72
         zgnGLVfbEDTEvVNifU3xMCp9T0dIoXiO15aw6jldUTGE0Y8V6r0qEuPOTthTIShBvB0P
         VhVRK52SdbAdMK2gxWG0eisN4YDEUHWgUGl8VPUZlh9d+kn/3KQ8N+Kb3BbdOHySyYMU
         wJuSQ4ejnUPaircgueJloJn6KMVGSkblAVyDhr3utGhpuay5gsaOEKHS9hyxRh2uWNy3
         x4Jw==
X-Gm-Message-State: AOJu0Yx6cP5tJyuQNQP/DxNXpSO32m0R8NtnMYjkS64b6zFhVJmrdddQ
	STzYkM/z1ECCtwPJqIgrgSF5Wv9CGsbutrVad3sqnBLa+gGNBOgTnbXS+0pYjJc=
X-Gm-Gg: ASbGncuS3vlMesQAq/VXlkWe429AhEORV6kDEtWZf5d2QFehd2EtPiaM+9CKEvxdCAc
	eSE6fCJqQMULILUZ5RSaR94ZlNqOdjXQIv90GXulnx9QfN8NgLvhcnJwg1rIiqMLY+eap6MnUd7
	aftiwuemhGmJeRfjfl34B5VSWXJ1y8wT8f3dgCaAp1KkiE9Tiw/h2JcK3CHbf0X29GSPalVNM6V
	gl+8xKHjoCW+obf9VZ5YwnORO05LVBgZs5OonIGF2rgxccWfOFIkAzyCB5w0QTLNBSHXO8T0hvl
	xNwnXYpox2sfTkRJ2e4=
X-Google-Smtp-Source: AGHT+IHHhui4gq8S6rdjq13CbEnHI/wIoAB/nmAHNVRfT+AXWunsGPydsTLsJ8Yqmiu9r5Um+Dlhkw==
X-Received: by 2002:a17:902:e843:b0:20b:a6f5:2768 with SMTP id d9443c01a7336-2129f65c738mr196258275ad.10.1732545694594;
        Mon, 25 Nov 2024 06:41:34 -0800 (PST)
Received: from ?IPV6:2a01:e0a:e17:9700:16d2:7456:6634:9626? ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2129dc22679sm65332465ad.266.2024.11.25.06.41.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Nov 2024 06:41:34 -0800 (PST)
Message-ID: <bdec8a59-89c0-4047-8365-5b2fa23732bb@rivosinc.com>
Date: Mon, 25 Nov 2024 15:41:23 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v3 3/4] riscv: lib: Add SSE assembly entry
 handling
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 Andrew Jones <ajones@ventanamicro.com>, Anup Patel
 <apatel@ventanamicro.com>, Atish Patra <atishp@rivosinc.com>
References: <20241125115452.1255745-1-cleger@rivosinc.com>
 <20241125115452.1255745-4-cleger@rivosinc.com>
 <20241125-46efbc121d5164de961a804e@orel>
 <5853b922-da5a-409e-875b-084da78999bd@rivosinc.com>
 <20241125-23cfeccc06900429ecd2a31d@orel>
Content-Language: en-US
From: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
In-Reply-To: <20241125-23cfeccc06900429ecd2a31d@orel>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 25/11/2024 15:26, Andrew Jones wrote:
> On Mon, Nov 25, 2024 at 03:13:01PM +0100, Clément Léger wrote:
>>
>>
>> On 25/11/2024 14:50, Andrew Jones wrote:
>>> On Mon, Nov 25, 2024 at 12:54:47PM +0100, Clément Léger wrote:
>>>> Add a SSE entry assembly code to handle SSE events. Events should be
>>>> registered with a struct sse_handler_arg containing a correct stack and
>>>> handler function.
>>>>
>>>> Signed-off-by: Clément Léger <cleger@rivosinc.com>
>>>> ---
>>>>  riscv/Makefile          |   1 +
>>>>  lib/riscv/asm/sse.h     |  16 +++++++
>>>>  lib/riscv/sse-entry.S   | 100 ++++++++++++++++++++++++++++++++++++++++
>>>>  lib/riscv/asm-offsets.c |   9 ++++
>>>>  4 files changed, 126 insertions(+)
>>>>  create mode 100644 lib/riscv/asm/sse.h
>>>>  create mode 100644 lib/riscv/sse-entry.S
>>>>
>>>> diff --git a/riscv/Makefile b/riscv/Makefile
>>>> index 5b5e157c..c278ec5c 100644
>>>> --- a/riscv/Makefile
>>>> +++ b/riscv/Makefile
>>>> @@ -41,6 +41,7 @@ cflatobjs += lib/riscv/sbi.o
>>>>  cflatobjs += lib/riscv/setjmp.o
>>>>  cflatobjs += lib/riscv/setup.o
>>>>  cflatobjs += lib/riscv/smp.o
>>>> +cflatobjs += lib/riscv/sse-entry.o
>>>>  cflatobjs += lib/riscv/stack.o
>>>>  cflatobjs += lib/riscv/timer.o
>>>>  ifeq ($(ARCH),riscv32)
>>>> diff --git a/lib/riscv/asm/sse.h b/lib/riscv/asm/sse.h
>>>> new file mode 100644
>>>> index 00000000..557f6680
>>>> --- /dev/null
>>>> +++ b/lib/riscv/asm/sse.h
>>>> @@ -0,0 +1,16 @@
>>>> +/* SPDX-License-Identifier: GPL-2.0-only */
>>>> +#ifndef _ASMRISCV_SSE_H_
>>>> +#define _ASMRISCV_SSE_H_
>>>> +
>>>> +typedef void (*sse_handler_fn)(void *data, struct pt_regs *regs, unsigned int hartid);
>>>> +
>>>> +struct sse_handler_arg {
>>>> +	unsigned long reg_tmp;
>>>> +	sse_handler_fn handler;
>>>> +	void *handler_data;
>>>> +	void *stack;
>>>> +};
>>>
>>> It still feels wrong to put a test-specific struct definition in lib. It's
>>> test-specific, because the SSE register function doesn't define it
>>> (otherwise we'd put the definition in lib/riscv/asm/sbi.h with the rest of
>>> the defines that come straight from the spec). Now, if we foresee using
>>> sse_event_register() outside of SBI SSE testing, then it would make sense
>>> to come up with a common struct, but it doesn't look like we have plans
>>> for that now, and sse_event_register() isn't in lib/riscv/sbi.c yet.
>>>
>>>> +
>>>> +extern void sse_entry(void);
>>>> +
>>>> +#endif /* _ASMRISCV_SSE_H_ */
>>>> diff --git a/lib/riscv/sse-entry.S b/lib/riscv/sse-entry.S
>>>> new file mode 100644
>>>> index 00000000..f1244e17
>>>> --- /dev/null
>>>> +++ b/lib/riscv/sse-entry.S
>>>> @@ -0,0 +1,100 @@
>>>> +/* SPDX-License-Identifier: GPL-2.0-only */
>>>> +/*
>>>> + * SBI SSE entry code
>>>> + *
>>>> + * Copyright (C) 2024, Rivos Inc., Clément Léger <cleger@rivosinc.com>
>>>> + */
>>>> +#include <asm/asm.h>
>>>> +#include <asm/asm-offsets.h>
>>>> +#include <asm/csr.h>
>>>> +
>>>> +.global sse_entry
>>>> +sse_entry:
>>>
>>> sse_entry is also test-specific unless we export sse_event_register().
>>>
>>>> +	/* Save stack temporarily */
>>>> +	REG_S sp, SSE_REG_TMP(a7)
>>>> +	/* Set entry stack */
>>>> +	REG_L sp, SSE_HANDLER_STACK(a7)
>>>> +
>>>> +	addi sp, sp, -(PT_SIZE)
>>>> +	REG_S ra, PT_RA(sp)
>>>> +	REG_S s0, PT_S0(sp)
>>>> +	REG_S s1, PT_S1(sp)
>>>> +	REG_S s2, PT_S2(sp)
>>>> +	REG_S s3, PT_S3(sp)
>>>> +	REG_S s4, PT_S4(sp)
>>>> +	REG_S s5, PT_S5(sp)
>>>> +	REG_S s6, PT_S6(sp)
>>>> +	REG_S s7, PT_S7(sp)
>>>> +	REG_S s8, PT_S8(sp)
>>>> +	REG_S s9, PT_S9(sp)
>>>> +	REG_S s10, PT_S10(sp)
>>>> +	REG_S s11, PT_S11(sp)
>>>> +	REG_S tp, PT_TP(sp)
>>>> +	REG_S t0, PT_T0(sp)
>>>> +	REG_S t1, PT_T1(sp)
>>>> +	REG_S t2, PT_T2(sp)
>>>> +	REG_S t3, PT_T3(sp)
>>>> +	REG_S t4, PT_T4(sp)
>>>> +	REG_S t5, PT_T5(sp)
>>>> +	REG_S t6, PT_T6(sp)
>>>> +	REG_S gp, PT_GP(sp)
>>>> +	REG_S a0, PT_A0(sp)
>>>> +	REG_S a1, PT_A1(sp)
>>>> +	REG_S a2, PT_A2(sp)
>>>> +	REG_S a3, PT_A3(sp)
>>>> +	REG_S a4, PT_A4(sp)
>>>> +	REG_S a5, PT_A5(sp)
>>>> +	csrr a1, CSR_SEPC
>>>> +	REG_S a1, PT_EPC(sp)
>>>> +	csrr a2, CSR_SSTATUS
>>>> +	REG_S a2, PT_STATUS(sp)
>>>> +
>>>> +	REG_L a0, SSE_REG_TMP(a7)
>>>> +	REG_S a0, PT_SP(sp)
>>>> +
>>>> +	REG_L t0, SSE_HANDLER(a7)
>>>> +	REG_L a0, SSE_HANDLER_DATA(a7)
>>>> +	mv a1, sp
>>>> +	mv a2, a6
>>>> +	jalr t0
>>>> +
>>>> +
>>>> +	REG_L a1, PT_EPC(sp)
>>>> +	REG_L a2, PT_STATUS(sp)
>>>> +	csrw CSR_SEPC, a1
>>>> +	csrw CSR_SSTATUS, a2
>>>> +
>>>> +	REG_L ra, PT_RA(sp)
>>>> +	REG_L s0, PT_S0(sp)
>>>> +	REG_L s1, PT_S1(sp)
>>>> +	REG_L s2, PT_S2(sp)
>>>> +	REG_L s3, PT_S3(sp)
>>>> +	REG_L s4, PT_S4(sp)
>>>> +	REG_L s5, PT_S5(sp)
>>>> +	REG_L s6, PT_S6(sp)
>>>> +	REG_L s7, PT_S7(sp)
>>>> +	REG_L s8, PT_S8(sp)
>>>> +	REG_L s9, PT_S9(sp)
>>>> +	REG_L s10, PT_S10(sp)
>>>> +	REG_L s11, PT_S11(sp)
>>>> +	REG_L tp, PT_TP(sp)
>>>> +	REG_L t0, PT_T0(sp)
>>>> +	REG_L t1, PT_T1(sp)
>>>> +	REG_L t2, PT_T2(sp)
>>>> +	REG_L t3, PT_T3(sp)
>>>> +	REG_L t4, PT_T4(sp)
>>>> +	REG_L t5, PT_T5(sp)
>>>> +	REG_L t6, PT_T6(sp)
>>>> +	REG_L gp, PT_GP(sp)
>>>> +	REG_L a0, PT_A0(sp)
>>>> +	REG_L a1, PT_A1(sp)
>>>> +	REG_L a2, PT_A2(sp)
>>>> +	REG_L a3, PT_A3(sp)
>>>> +	REG_L a4, PT_A4(sp)
>>>> +	REG_L a5, PT_A5(sp)
>>>> +
>>>> +	REG_L sp, PT_SP(sp)
>>>> +
>>>> +	li a7, ASM_SBI_EXT_SSE
>>>> +	li a6, ASM_SBI_EXT_SSE_COMPLETE
>>>> +	ecall
>>>> diff --git a/lib/riscv/asm-offsets.c b/lib/riscv/asm-offsets.c
>>>> index 6c511c14..b3465eeb 100644
>>>> --- a/lib/riscv/asm-offsets.c
>>>> +++ b/lib/riscv/asm-offsets.c
>>>> @@ -3,7 +3,9 @@
>>>>  #include <elf.h>
>>>>  #include <asm/processor.h>
>>>>  #include <asm/ptrace.h>
>>>> +#include <asm/sbi.h>
>>>>  #include <asm/smp.h>
>>>> +#include <asm/sse.h>
>>>>  
>>>>  int main(void)
>>>>  {
>>>> @@ -63,5 +65,12 @@ int main(void)
>>>>  	OFFSET(THREAD_INFO_HARTID, thread_info, hartid);
>>>>  	DEFINE(THREAD_INFO_SIZE, sizeof(struct thread_info));
>>>>  
>>>> +	OFFSET(SSE_REG_TMP, sse_handler_arg, reg_tmp);
>>>> +	OFFSET(SSE_HANDLER, sse_handler_arg, handler);
>>>> +	OFFSET(SSE_HANDLER_DATA, sse_handler_arg, handler_data);
>>>> +	OFFSET(SSE_HANDLER_STACK, sse_handler_arg, stack);
>>>
>>> I think I prefer just hard coding the offsets in defines and then using
>>> static asserts to ensure they stay as expected. Below is a diff I applied
>>> which moves some stuff around. Let me know what you think.
>>>
>>> Thanks,
>>> drew
>>>
>>>> +	DEFINE(ASM_SBI_EXT_SSE, SBI_EXT_SSE);
>>>> +	DEFINE(ASM_SBI_EXT_SSE_COMPLETE, SBI_EXT_SSE_COMPLETE);
>>>> +
>>>>  	return 0;
>>>>  }
>>>> -- 
>>>> 2.45.2
>>>>
>>>
>>> diff --git a/lib/riscv/asm-offsets.c b/lib/riscv/asm-offsets.c
>>> index b3465eebbaa2..402eb4d90a8e 100644
>>> --- a/lib/riscv/asm-offsets.c
>>> +++ b/lib/riscv/asm-offsets.c
>>> @@ -5,7 +5,6 @@
>>>  #include <asm/ptrace.h>
>>>  #include <asm/sbi.h>
>>>  #include <asm/smp.h>
>>> -#include <asm/sse.h>
>>>  
>>>  int main(void)
>>>  {
>>> @@ -65,10 +64,8 @@ int main(void)
>>>  	OFFSET(THREAD_INFO_HARTID, thread_info, hartid);
>>>  	DEFINE(THREAD_INFO_SIZE, sizeof(struct thread_info));
>>>  
>>> -	OFFSET(SSE_REG_TMP, sse_handler_arg, reg_tmp);
>>> -	OFFSET(SSE_HANDLER, sse_handler_arg, handler);
>>> -	OFFSET(SSE_HANDLER_DATA, sse_handler_arg, handler_data);
>>> -	OFFSET(SSE_HANDLER_STACK, sse_handler_arg, stack);
>>> +	DEFINE(ASM_SBI_EXT_HSM, SBI_EXT_HSM);
>>> +	DEFINE(ASM_SBI_EXT_HSM_HART_STOP, SBI_EXT_HSM_HART_STOP);
>>>  	DEFINE(ASM_SBI_EXT_SSE, SBI_EXT_SSE);
>>>  	DEFINE(ASM_SBI_EXT_SSE_COMPLETE, SBI_EXT_SSE_COMPLETE);
>>>  
>>> diff --git a/lib/riscv/asm/sse.h b/lib/riscv/asm/sse.h
>>> deleted file mode 100644
>>> index 557f6680e90c..000000000000
>>> --- a/lib/riscv/asm/sse.h
>>> +++ /dev/null
>>> @@ -1,16 +0,0 @@
>>> -/* SPDX-License-Identifier: GPL-2.0-only */
>>> -#ifndef _ASMRISCV_SSE_H_
>>> -#define _ASMRISCV_SSE_H_
>>> -
>>> -typedef void (*sse_handler_fn)(void *data, struct pt_regs *regs, unsigned int hartid);
>>> -
>>> -struct sse_handler_arg {
>>> -	unsigned long reg_tmp;
>>> -	sse_handler_fn handler;
>>> -	void *handler_data;
>>> -	void *stack;
>>> -};
>>> -
>>> -extern void sse_entry(void);
>>> -
>>> -#endif /* _ASMRISCV_SSE_H_ */
>>> diff --git a/lib/riscv/sse-entry.S b/lib/riscv/sse-entry.S
>>> deleted file mode 100644
>>> index f1244e17fe08..000000000000
>>> --- a/lib/riscv/sse-entry.S
>>> +++ /dev/null
>>> @@ -1,100 +0,0 @@
>>> -/* SPDX-License-Identifier: GPL-2.0-only */
>>> -/*
>>> - * SBI SSE entry code
>>> - *
>>> - * Copyright (C) 2024, Rivos Inc., Clément Léger <cleger@rivosinc.com>
>>> - */
>>> -#include <asm/asm.h>
>>> -#include <asm/asm-offsets.h>
>>> -#include <asm/csr.h>
>>> -
>>> -.global sse_entry
>>> -sse_entry:
>>> -	/* Save stack temporarily */
>>> -	REG_S sp, SSE_REG_TMP(a7)
>>> -	/* Set entry stack */
>>> -	REG_L sp, SSE_HANDLER_STACK(a7)
>>> -
>>> -	addi sp, sp, -(PT_SIZE)
>>> -	REG_S ra, PT_RA(sp)
>>> -	REG_S s0, PT_S0(sp)
>>> -	REG_S s1, PT_S1(sp)
>>> -	REG_S s2, PT_S2(sp)
>>> -	REG_S s3, PT_S3(sp)
>>> -	REG_S s4, PT_S4(sp)
>>> -	REG_S s5, PT_S5(sp)
>>> -	REG_S s6, PT_S6(sp)
>>> -	REG_S s7, PT_S7(sp)
>>> -	REG_S s8, PT_S8(sp)
>>> -	REG_S s9, PT_S9(sp)
>>> -	REG_S s10, PT_S10(sp)
>>> -	REG_S s11, PT_S11(sp)
>>> -	REG_S tp, PT_TP(sp)
>>> -	REG_S t0, PT_T0(sp)
>>> -	REG_S t1, PT_T1(sp)
>>> -	REG_S t2, PT_T2(sp)
>>> -	REG_S t3, PT_T3(sp)
>>> -	REG_S t4, PT_T4(sp)
>>> -	REG_S t5, PT_T5(sp)
>>> -	REG_S t6, PT_T6(sp)
>>> -	REG_S gp, PT_GP(sp)
>>> -	REG_S a0, PT_A0(sp)
>>> -	REG_S a1, PT_A1(sp)
>>> -	REG_S a2, PT_A2(sp)
>>> -	REG_S a3, PT_A3(sp)
>>> -	REG_S a4, PT_A4(sp)
>>> -	REG_S a5, PT_A5(sp)
>>> -	csrr a1, CSR_SEPC
>>> -	REG_S a1, PT_EPC(sp)
>>> -	csrr a2, CSR_SSTATUS
>>> -	REG_S a2, PT_STATUS(sp)
>>> -
>>> -	REG_L a0, SSE_REG_TMP(a7)
>>> -	REG_S a0, PT_SP(sp)
>>> -
>>> -	REG_L t0, SSE_HANDLER(a7)
>>> -	REG_L a0, SSE_HANDLER_DATA(a7)
>>> -	mv a1, sp
>>> -	mv a2, a6
>>> -	jalr t0
>>> -
>>> -
>>> -	REG_L a1, PT_EPC(sp)
>>> -	REG_L a2, PT_STATUS(sp)
>>> -	csrw CSR_SEPC, a1
>>> -	csrw CSR_SSTATUS, a2
>>> -
>>> -	REG_L ra, PT_RA(sp)
>>> -	REG_L s0, PT_S0(sp)
>>> -	REG_L s1, PT_S1(sp)
>>> -	REG_L s2, PT_S2(sp)
>>> -	REG_L s3, PT_S3(sp)
>>> -	REG_L s4, PT_S4(sp)
>>> -	REG_L s5, PT_S5(sp)
>>> -	REG_L s6, PT_S6(sp)
>>> -	REG_L s7, PT_S7(sp)
>>> -	REG_L s8, PT_S8(sp)
>>> -	REG_L s9, PT_S9(sp)
>>> -	REG_L s10, PT_S10(sp)
>>> -	REG_L s11, PT_S11(sp)
>>> -	REG_L tp, PT_TP(sp)
>>> -	REG_L t0, PT_T0(sp)
>>> -	REG_L t1, PT_T1(sp)
>>> -	REG_L t2, PT_T2(sp)
>>> -	REG_L t3, PT_T3(sp)
>>> -	REG_L t4, PT_T4(sp)
>>> -	REG_L t5, PT_T5(sp)
>>> -	REG_L t6, PT_T6(sp)
>>> -	REG_L gp, PT_GP(sp)
>>> -	REG_L a0, PT_A0(sp)
>>> -	REG_L a1, PT_A1(sp)
>>> -	REG_L a2, PT_A2(sp)
>>> -	REG_L a3, PT_A3(sp)
>>> -	REG_L a4, PT_A4(sp)
>>> -	REG_L a5, PT_A5(sp)
>>> -
>>> -	REG_L sp, PT_SP(sp)
>>> -
>>> -	li a7, ASM_SBI_EXT_SSE
>>> -	li a6, ASM_SBI_EXT_SSE_COMPLETE
>>> -	ecall
>>> diff --git a/riscv/Makefile b/riscv/Makefile
>>> index 81b75ad52411..62a2efc18492 100644
>>> --- a/riscv/Makefile
>>> +++ b/riscv/Makefile
>>> @@ -41,7 +41,6 @@ cflatobjs += lib/riscv/sbi.o
>>>  cflatobjs += lib/riscv/setjmp.o
>>>  cflatobjs += lib/riscv/setup.o
>>>  cflatobjs += lib/riscv/smp.o
>>> -cflatobjs += lib/riscv/sse-entry.o
>>>  cflatobjs += lib/riscv/stack.o
>>>  cflatobjs += lib/riscv/timer.o
>>>  ifeq ($(ARCH),riscv32)
>>> diff --git a/riscv/sbi-asm.S b/riscv/sbi-asm.S
>>> index 923c2ceca5db..5c50606e9940 100644
>>> --- a/riscv/sbi-asm.S
>>> +++ b/riscv/sbi-asm.S
>>> @@ -6,6 +6,7 @@
>>>   */
>>>  #define __ASSEMBLY__
>>>  #include <asm/asm.h>
>>> +#include <asm/asm-offsets.h>
>>>  #include <asm/csr.h>
>>>  
>>>  #include "sbi-tests.h"
>>> @@ -58,8 +59,8 @@ sbi_hsm_check:
>>>  7:	lb	t0, 0(t1)
>>>  	pause
>>>  	beqz	t0, 7b
>>> -	li	a7, 0x48534d	/* SBI_EXT_HSM */
>>> -	li	a6, 1		/* SBI_EXT_HSM_HART_STOP */
>>> +	li	a7, ASM_SBI_EXT_HSM
>>> +	li	a6, ASM_SBI_EXT_HSM_HART_STOP
>>>  	ecall
>>>  8:	pause
>>>  	j	8b
>>> @@ -129,3 +130,94 @@ sbi_susp_resume:
>>>  	call	longjmp
>>>  6:	pause	/* unreachable */
>>>  	j	6b
>>> +
>>> +.global sse_entry
>>> +sse_entry:
>>> +	/* Save stack temporarily */
>>> +	REG_S sp, SBI_SSE_REG_TMP(a7)
>>> +	/* Set entry stack */
>>> +	REG_L sp, SBI_SSE_HANDLER_STACK(a7)
>>> +
>>> +	addi sp, sp, -(PT_SIZE)
>>> +	REG_S ra, PT_RA(sp)
>>> +	REG_S s0, PT_S0(sp)
>>> +	REG_S s1, PT_S1(sp)
>>> +	REG_S s2, PT_S2(sp)
>>> +	REG_S s3, PT_S3(sp)
>>> +	REG_S s4, PT_S4(sp)
>>> +	REG_S s5, PT_S5(sp)
>>> +	REG_S s6, PT_S6(sp)
>>> +	REG_S s7, PT_S7(sp)
>>> +	REG_S s8, PT_S8(sp)
>>> +	REG_S s9, PT_S9(sp)
>>> +	REG_S s10, PT_S10(sp)
>>> +	REG_S s11, PT_S11(sp)
>>> +	REG_S tp, PT_TP(sp)
>>> +	REG_S t0, PT_T0(sp)
>>> +	REG_S t1, PT_T1(sp)
>>> +	REG_S t2, PT_T2(sp)
>>> +	REG_S t3, PT_T3(sp)
>>> +	REG_S t4, PT_T4(sp)
>>> +	REG_S t5, PT_T5(sp)
>>> +	REG_S t6, PT_T6(sp)
>>> +	REG_S gp, PT_GP(sp)
>>> +	REG_S a0, PT_A0(sp)
>>> +	REG_S a1, PT_A1(sp)
>>> +	REG_S a2, PT_A2(sp)
>>> +	REG_S a3, PT_A3(sp)
>>> +	REG_S a4, PT_A4(sp)
>>> +	REG_S a5, PT_A5(sp)
>>> +	csrr a1, CSR_SEPC
>>> +	REG_S a1, PT_EPC(sp)
>>> +	csrr a2, CSR_SSTATUS
>>> +	REG_S a2, PT_STATUS(sp)
>>> +
>>> +	REG_L a0, SBI_SSE_REG_TMP(a7)
>>> +	REG_S a0, PT_SP(sp)
>>> +
>>> +	REG_L t0, SBI_SSE_HANDLER(a7)
>>> +	REG_L a0, SBI_SSE_HANDLER_DATA(a7)
>>> +	mv a1, sp
>>> +	mv a2, a6
>>> +	jalr t0
>>> +
>>> +
>>> +	REG_L a1, PT_EPC(sp)
>>> +	REG_L a2, PT_STATUS(sp)
>>> +	csrw CSR_SEPC, a1
>>> +	csrw CSR_SSTATUS, a2
>>> +
>>> +	REG_L ra, PT_RA(sp)
>>> +	REG_L s0, PT_S0(sp)
>>> +	REG_L s1, PT_S1(sp)
>>> +	REG_L s2, PT_S2(sp)
>>> +	REG_L s3, PT_S3(sp)
>>> +	REG_L s4, PT_S4(sp)
>>> +	REG_L s5, PT_S5(sp)
>>> +	REG_L s6, PT_S6(sp)
>>> +	REG_L s7, PT_S7(sp)
>>> +	REG_L s8, PT_S8(sp)
>>> +	REG_L s9, PT_S9(sp)
>>> +	REG_L s10, PT_S10(sp)
>>> +	REG_L s11, PT_S11(sp)
>>> +	REG_L tp, PT_TP(sp)
>>> +	REG_L t0, PT_T0(sp)
>>> +	REG_L t1, PT_T1(sp)
>>> +	REG_L t2, PT_T2(sp)
>>> +	REG_L t3, PT_T3(sp)
>>> +	REG_L t4, PT_T4(sp)
>>> +	REG_L t5, PT_T5(sp)
>>> +	REG_L t6, PT_T6(sp)
>>> +	REG_L gp, PT_GP(sp)
>>> +	REG_L a0, PT_A0(sp)
>>> +	REG_L a1, PT_A1(sp)
>>> +	REG_L a2, PT_A2(sp)
>>> +	REG_L a3, PT_A3(sp)
>>> +	REG_L a4, PT_A4(sp)
>>> +	REG_L a5, PT_A5(sp)
>>> +
>>> +	REG_L sp, PT_SP(sp)
>>> +
>>> +	li a7, ASM_SBI_EXT_SSE
>>> +	li a6, ASM_SBI_EXT_SSE_COMPLETE
>>> +	ecall
>>> diff --git a/riscv/sbi-sse.c b/riscv/sbi-sse.c
>>> index a230c600a5a2..85521546838c 100644
>>> --- a/riscv/sbi-sse.c
>>> +++ b/riscv/sbi-sse.c
>>> @@ -16,12 +16,12 @@
>>>  #include <asm/processor.h>
>>>  #include <asm/sbi.h>
>>>  #include <asm/setup.h>
>>> -#include <asm/sse.h>
>>>  
>>>  #include "sbi-tests.h"
>>>  
>>>  #define SSE_STACK_SIZE	PAGE_SIZE
>>>  
>>> +void sse_entry(void);
>>>  void check_sse(void);
>>>  
>>>  struct sse_event_info {
>>> diff --git a/riscv/sbi-tests.h b/riscv/sbi-tests.h
>>> index ce129968fe99..163751ba9ca6 100644
>>> --- a/riscv/sbi-tests.h
>>> +++ b/riscv/sbi-tests.h
>>> @@ -33,4 +33,25 @@
>>>  #define SBI_SUSP_TEST_HARTID	(1 << 2)
>>>  #define SBI_SUSP_TEST_MASK	7
>>>  
>>> +#define SBI_SSE_REG_TMP		0
>>> +#define SBI_SSE_HANDLER		8
>>> +#define SBI_SSE_HANDLER_DATA	16
>>> +#define SBI_SSE_HANDLER_STACK	24
>>> +
>>> +#ifndef __ASSEMBLY__
>>> +
>>> +typedef void (*sse_handler_fn)(void *data, struct pt_regs *regs, unsigned int hartid);
>>> +
>>> +struct sse_handler_arg {
>>> +	unsigned long reg_tmp;
>>> +	sse_handler_fn handler;
>>> +	void *handler_data;
>>> +	void *stack;
>>> +};
>>> +_Static_assert(offsetof(struct sse_handler_arg, reg_tmp) == SBI_SSE_REG_TMP);
>>> +_Static_assert(offsetof(struct sse_handler_arg, handler) == SBI_SSE_HANDLER);
>>> +_Static_assert(offsetof(struct sse_handler_arg, handler_data) == SBI_SSE_HANDLER_DATA);
>>> +_Static_assert(offsetof(struct sse_handler_arg, stack) == SBI_SSE_HANDLER_STACK);
>>> +
>>
>> I'm not a huge fan but in the end, the result is the same and it suits
>> you ;)
> 
> Ideally we'd have asm-offsets for test code so we don't have to choose
> between hard coding offsets and putting code in the library that doesn't
> belong there. I'm OK with deferring that work, though, by choosing hard
> coded offsets which we can check at compile time.

yeah, I took a look a asm-offset generation but it seems pretty
hardcoded for a signle asm-offsets.c file yet. Probably require much
more work to have multiples files but i'll take a look. In the meantime,
it makes sense to move that in riscv/ as you say. That per test
asm-offsets can be added later.

> 
>> Let's go for it, I'll integrate that in the series (minus the HSM
>> stuff).
> 
> I wouldn't complain if the HSM defines got slipped in with a "while at it
> change the HSM defines to ones provided by asm-offsets" type of comment
> in the commit message, but I can also add a patch on top which does that
> change myself.

No worries then, I'll add that !

> 
> Thanks,
> drew


