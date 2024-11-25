Return-Path: <kvm+bounces-32413-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E6EEB9D835A
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 11:29:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 86BF4162D4E
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 10:29:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C6B4192580;
	Mon, 25 Nov 2024 10:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="gu6UOIhR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA8A61922D8
	for <kvm@vger.kernel.org>; Mon, 25 Nov 2024 10:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732530583; cv=none; b=qNKBiiv4qncS//u9a/KufE6GGdg4EvU9UiA22Koz0+v3pOGALBHIrms1vsnksj40IxHCPUo0hVcnjFjg3142FaiowHKkK4m8GONjDEcWV4N4tPUBdumuvq+uZqdWgS44osAsm3xrjic2GzrPfVLOSHUJSSuMuI66j5tdNJehgNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732530583; c=relaxed/simple;
	bh=4QebM7wDpO/ZzGIZmaMvzH5LwLGao59GjeHtLMWBgyc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lEOw3zRBKEiKCNvB8jGoGs6jZ1ZcPKp3cv3r+fVNtf99xxpUr5IZ/ZRUavGC4v0L6UD0Zk95Tl4HCQaEsE/he+JLN9LiNH8+V7zRUtLQOpPLNZpssu7Oc/INunGztmY8O+HWuL9ntiwmI5ltPeXv+UBjCwruG40WIQMCEb7R7sY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=gu6UOIhR; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-38232cebb0cso3308705f8f.1
        for <kvm@vger.kernel.org>; Mon, 25 Nov 2024 02:29:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1732530579; x=1733135379; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Et8bfP7f+d7et6IdLZNPrHhGEwHHDGt66EmqTI7LK6I=;
        b=gu6UOIhRZ74fMpciRvD8v8muRIOLRGT+GZC6lsABfDTOC/OuO5Z2qI2Q9mtw/mJPSj
         ZA4g2V1ZsmeBwZFk5F+K9Znks/bD26ACY0wxhFjtdL0grofghVMzNCged/oxv3JNs1wZ
         YwDkLvtAKIoi/+r8GF6/0e96qA49KWp3tqlN0l+Ghf2CetfP/PAzzCY1UJ2LyIbfCZbv
         2XKVFmHIdVrE9hf29+DbIVhv/40hadUbC824RSjTffED/EtBKeJA1xchnkeeU2FNGNXK
         Lbml2UiSc1dAdPUW359CYlDjwxNf0YApUGSoD+GjQpIOtwMoRLEYmNujxhq8aktB8neS
         UhBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732530579; x=1733135379;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Et8bfP7f+d7et6IdLZNPrHhGEwHHDGt66EmqTI7LK6I=;
        b=aD9D3LBwU43xBN+tAfI9+pKuBk+aQpaQitYGgm/VGYGoDFIqBJaoetNnkmdOsGNsGj
         mM/N3ulE3n5rb6ON+2p1Se3mVGz6qQ5zytdHgbzWtayv3LENKaQXuNqqej1bO55eTQZn
         kaYPM3a9/MeMPg6CZ8xqas+1hgmcaraAefQt7jlxu3GW8Jq0CuvXXV/gLVNDw1ikhNjL
         z2YjwzhTrJcuvqF3wOXcTO2GpfZwYLKCok/rC7N6V1s1d1EQbsjEo7RR4RcD4b43mNGk
         9PkR4gBvKnvWApEMoPaDDaof8UQy1fg2kjnf+3zpw2k9nTgim9Q3HKuxfIPdQy/fD1GB
         S5qw==
X-Gm-Message-State: AOJu0YyhnVkstm/IW3+l0+1RX/ONEaaDzMP4Ey6bO2L2xDcsgTU3Tqin
	hxewO5cSc0EO0ORQGmG5i/YBBnJnvB6w1hdzYyZLqzE2GaBiF1q/l1/63eVcYtG3KaAttyjXyn9
	B
X-Gm-Gg: ASbGncvg3lspgeI4LFBpFfiy43+typaTfYm8uKsj69Ca1P/Oa3kupYS12T03t9V80a3
	oBOiI/56U1vyeHsvw0OBZ/XPk2tlktdSGv5wUFoG8KBYoJvh9CNgMJmgvwUx/x7kOWLJWyQxNK7
	i9RsSfNj8DI+uGvTXMzCWTgtSYv7JautcgbZSQdYKBCc4jBYVw2vJiLOfLyE8hdrjCGhSTU+gLy
	I9o9lt4+1re+Q/gYKTLuBfCX4GHYtocmFToOzKGWOj1DItll0UhjaqLAY3IVmRTfmda15j/Qdfk
	RVfewiuLxBiHS5vSuYk=
X-Google-Smtp-Source: AGHT+IENdgMgO0gxX+6kYoLAr72gS29wcRWhFhIn33d6/0uIwcwOpu7I3hqWA9vC9CrOfETEA/VC2g==
X-Received: by 2002:a5d:588c:0:b0:382:495c:deca with SMTP id ffacd0b85a97d-38260bc93famr11161040f8f.39.1732530578976;
        Mon, 25 Nov 2024 02:29:38 -0800 (PST)
Received: from ?IPV6:2a01:e0a:e17:9700:16d2:7456:6634:9626? ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3825fbc3531sm10180147f8f.80.2024.11.25.02.29.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Nov 2024 02:29:38 -0800 (PST)
Message-ID: <c174b3bb-5839-4396-9c5e-68b56fbd1bce@rivosinc.com>
Date: Mon, 25 Nov 2024 11:29:38 +0100
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
 <90b8e2d2-1fc6-4166-a3bf-3cd8af3b5b8d@rivosinc.com>
 <20241125-a56b5a8b8a80cdd2e9598fee@orel>
Content-Language: en-US
From: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
In-Reply-To: <20241125-a56b5a8b8a80cdd2e9598fee@orel>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 25/11/2024 10:38, Andrew Jones wrote:
> On Mon, Nov 25, 2024 at 09:46:48AM +0100, Clément Léger wrote:
>>
>>
>> On 22/11/2024 17:20, Andrew Jones wrote:
>>> On Fri, Nov 22, 2024 at 03:04:56PM +0100, Clément Léger wrote:
>>>> Add a SSE entry assembly code to handle SSE events. Events should be
>>>> registered with a struct sse_handler_arg containing a correct stack and
>>>> handler function.
>>>>
>>>> Signed-off-by: Clément Léger <cleger@rivosinc.com>
>>>> ---
>>>>  riscv/Makefile          |   1 +
>>>>  lib/riscv/asm/sse.h     |  16 +++++++
>>>>  lib/riscv/sse-entry.S   | 100 ++++++++++++++++++++++++++++++++++++++++
>>>
>>> Let's just add the entry function to riscv/sbi-asm.S and the
>>> sse_handler_arg struct definition to riscv/sbi-tests.h
>>
>> Hi drew,
>>
>> I need to have some offset generated using asm-offsets.c which is in
>> lib/riscv. If I move the sse_handler_arg in riscv/sbi-tests.h, that will
>> be really off to include that file in the lib/riscv/asm-offsets.c.
> 
> That's true, but it's also not great to put a test-specific definition of
> an arg structure in lib code. It seems like we'll eventually want a neater
> solution to this, though, since using asm-offsets for test-specific
> structures makes sense. However, we could put it off for now, since each
> member of the structure that SSE tests need is the same size,
> sizeof(long), so we can do the same thing that HSM and SUSP do, which is
> to define some indices and access with ASMARR().

The struct sse_handler_arg isn't actually test-specific as well as the
assembly code. Test data are actually specified in the handler and
handler_data field of the sse_handler_arg. But maybe the part that uses
the sse_handler data should actually be hidden from the test layer. I
can add some function to wrap that.

> 
>> Except if you have some other solution.
> 
> ASMARR(), even though I'm not a huge fan of that approach either...
> 
>>
>>>
>>>>  lib/riscv/asm-offsets.c |   9 ++++
>>>>  4 files changed, 126 insertions(+)
>>>>  create mode 100644 lib/riscv/asm/sse.h
>>>>  create mode 100644 lib/riscv/sse-entry.S
>>>>
>>>> diff --git a/riscv/Makefile b/riscv/Makefile
>>>> index 28b04156..e50621ad 100644
>>>> --- a/riscv/Makefile
>>>> +++ b/riscv/Makefile
>>>> @@ -39,6 +39,7 @@ cflatobjs += lib/riscv/sbi.o
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
>>>> +
>>>> +extern void sse_entry(void);
>>>> +
>>>> +#endif /* _ASMRISCV_SSE_H_ */
>>>> diff --git a/lib/riscv/sse-entry.S b/lib/riscv/sse-entry.S
>>>> new file mode 100644
>>>> index 00000000..bedc47e9
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
>>>> +	/* Save stack temporarily */
>>>> +	REG_S sp, SSE_REG_TMP(a6)
> 
> While thinking about the asm-offsets issue, I took a closer look at this
> and noticed that this should be a7, since ENTRY_ARG is specified to be
> set to A7. It looks like we have A6 (hartid) and A7 (arg) swapped. The
> opensbi implementation also has them swapped, allowing this test to pass.
> Both need to be fixed.

Ouch, nice catch, I'll fix that up.

> 
> Thanks,
> drew


