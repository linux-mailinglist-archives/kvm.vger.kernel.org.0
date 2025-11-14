Return-Path: <kvm+bounces-63218-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7561BC5DEFB
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 16:41:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6904F4276BA
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 15:30:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 761BD330D51;
	Fri, 14 Nov 2025 15:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="cnFRgMGt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35EBC330B32
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 15:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763133577; cv=none; b=fbgyS0r/kh+AjLug+OvB7wU3tFN91TKsCqJbvmOf5pi8sUFrMeT3umqf/II+3bRRyltHp6pRvLd5OrXM0sNvrOXqYIteLCa2WQT3dZlFr2dvGQJpfGrf4o8ho/ZxpntpMH1eC8/ZMgtv9doyWotO+/Tkf2+QHmVm5NP6rTuPdKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763133577; c=relaxed/simple;
	bh=odgCtfRtt9HWEV1BYBNvvnuxVP9iAn6FECZ6XeyFjV0=;
	h=Content-Type:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To; b=rn8SIM54C2GVvARcRea7ggXLJ5LBCURShGElQ7SoWcq5R0SEhCIL2knDiTsfRq57T4SHpxEP8XhzTNzDu3MdAVeBtVxNwgbgmCtoPYLQvpgXRxEdMWCRwAZTqueIY5keiINQeqg0MkPf9M09nQHrhQ3tGuoZNrjQ72gOn/hQztA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=cnFRgMGt; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-8804650ca32so19122876d6.0
        for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 07:19:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1763133574; x=1763738374; darn=vger.kernel.org;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ff/n0hufRbHThDPcNkYeBQ8DZhVtnLaU9fv6Z3f5s8c=;
        b=cnFRgMGtt+Gwn1t9WUBDaZODznY8zHYXJOkzjtcFAtWZFBq/+JUzSW07e36Em9pftd
         jx4/DgvbNyC/4pQHTuyC1UaEqoc4ymHZZNPGaBcnw/QwIpCPxeqHebmGysGTYUdNmf4O
         Eicu1KmaMejBUheaZxe38UvgLnBvELKQwxSLbTNnIOiymlaEnwHDC20AERMf0Gnxl7fC
         YtoHLZiuH1ANKtcl67A7eoxunLXJTLG3HQ4kr/LBKMh+qOAupWhVCA/goRMZWw83jRT+
         2cX27bOFvrhx0IX43zc5AgXLYgmxq2VElX03hBnzBBCAjMMWeu9AIGBMpVDDrByn13ul
         ojIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763133574; x=1763738374;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ff/n0hufRbHThDPcNkYeBQ8DZhVtnLaU9fv6Z3f5s8c=;
        b=Ml252tQUY8p+0pPU8iuNaVUwcO+CSz4PDTpT9rm+3s9A1xT7zSrtr/tQEciHUJR72e
         /93GVxSdm2VsKBgNiXHCWGT33fgRix6kzh4hXMKEdOIl9JVT2DRvyKaCgF7O7VLqWl8x
         NDvGu4aksBJhYP8jUMH+B4iMSfQbdvK0eNsfmQ8H+WHZFiNgNLMUyTdWGLNVzf0dzQ5j
         3jrqlz8f9QMF3S/K+2FchQDjrZhDgLriId4t1vGavoUYZhNOcfA4pxC9MwSUWBhwi5vj
         kJADQ6+00O8Df3ASpCtaWfy7wA8f/eJeXEVV4L7dlZohTrZl19vAs/xd6zaaYH3j31lA
         YkzA==
X-Gm-Message-State: AOJu0YzHB4j/u7pmE+DzO4LIAtJDJHTWlaW7K/gI2R2P9hV6SQROIe0o
	YVWlK5CPTO+42aEAXj6NEbInKASk7Ge7hZu04uHC6E14Yupz7eb1lzBGJylIUc7Drl8=
X-Gm-Gg: ASbGncu4HHW8jmgUvm9Afql6jaQ49sAn+qITZV4CcuG8Egq450cEddz29uiZvb39k4d
	7tI/PhhvUixhoG5ZwcXgXT2GTT0ZFUY38ybGpKx0nn88kxQIs0EwuGV9iA7zBFnfx9ohb7GFbMQ
	ig6sZBOYntUZPJnAgawwoSMUZjJPd1jrtuiud5Ne1TlbUG3pN4x9RldCfhW7iSkz8shrdss/nZH
	upKzIAkiKWCb7HSF9xKgxIVs/9E6WISXz7dhxo05C3992kFJssdT3xRJzccmi4XJMMiwYJf2oMk
	DdoE6H7W5qY8BWHJlhzVA5nekMLLKmg2c3R4H9yfcyipYAjAWC7bJXNEWH7/l28QjTFabe9XNXc
	QmTdlomE7mkMnXsbrzV/4YHpEWu2jtr5OYS7V7fZ2+XayEKE5FiEResw5hS00Fek0cKDsccLGiF
	q4T3SnShlXBEw0PbOe1MdhWjV2WLg+jO7ILfV0KbRdugWVBcdbuYuH3u/G8AKFVnZ5seomxKhTy
	L3JVLxL/0XJvO8ZJShaj+Nn1qr26hU+uih0O/7aYTVj3w==
X-Google-Smtp-Source: AGHT+IHDQuG8RXHen2dH3FTAvcOBFKsj0n7A8gaSjwXtV5IA7mYPkh5cF/CYfOQbKF+bsr0GNibZJA==
X-Received: by 2002:a05:6214:495:b0:880:4bb9:4c99 with SMTP id 6a1803df08f44-88292771558mr43148516d6.66.1763133573614;
        Fri, 14 Nov 2025 07:19:33 -0800 (PST)
Received: from ?IPV6:2003:fa:af29:b100:e8b2:7dbf:b11:65fc? (p200300faaf29b100e8b27dbf0b1165fc.dip0.t-ipconnect.de. [2003:fa:af29:b100:e8b2:7dbf:b11:65fc])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88286588be1sm32397566d6.47.2025.11.14.07.19.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Nov 2025 07:19:31 -0800 (PST)
Content-Type: multipart/mixed; boundary="------------jdOz0xm8frMTGQPfnrTpEfPS"
Message-ID: <fc886a22-49f3-4627-8ba6-933099e7640d@grsecurity.net>
Date: Fri, 14 Nov 2025 16:19:24 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v3 17/17] x86/cet: Add testcases to verify
 KVM rejects emulation of CET instructions
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, Chao Gao <chao.gao@intel.com>,
 Paolo Bonzini <pbonzini@redhat.com>
References: <20251114001258.1717007-1-seanjc@google.com>
 <20251114001258.1717007-18-seanjc@google.com>
Content-Language: en-US, de-DE
From: Mathias Krause <minipli@grsecurity.net>
Autocrypt: addr=minipli@grsecurity.net; keydata=
 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
 RzDVkdgPJkL/NFTKZHo5foFXNi89kA==
In-Reply-To: <20251114001258.1717007-18-seanjc@google.com>

This is a multi-part message in MIME format.
--------------jdOz0xm8frMTGQPfnrTpEfPS
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 14.11.25 01:12, Sean Christopherson wrote:
> Add SHSTK and IBT testcases to verify that KVM rejects (forced) emulation
> of instructions that interact with SHSTK and/or IBT state, as KVM doesn't
> support emulating SHSTK or IBT (rejecting emulation is preferable to
> compromising guest security).
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  x86/cet.c | 123 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 121 insertions(+), 2 deletions(-)
> 
> diff --git a/x86/cet.c b/x86/cet.c
> index 26cd1c9b..34c78210 100644
> --- a/x86/cet.c
> +++ b/x86/cet.c
> @@ -75,6 +75,113 @@ static uint64_t cet_ibt_func(void)
>  	return 0;
>  }
>  
> +#define __CET_TEST_UNSUPPORTED_INSTRUCTION(insn)			\
> +({									\
> +	struct far_pointer32 fp = {					\
> +		.offset = 0,						\
> +		.selector = USER_CS,					\
> +	};								\
> +									\
> +	asm volatile ("push %%rax\n"					\
> +		      ASM_TRY_FEP("1f") insn "\n\t"			\
> +		      "1:"						\
> +		      "pop %%rax\n"					\
> +		      : : "m" (fp), "a" (NONCANONICAL) : "memory");	\
> +									\
> +	exception_vector();					\
> +})
> +
> +#define SHSTK_TEST_UNSUPPORTED_INSTRUCTION(insn)			\
> +do {									\
> +	uint8_t vector = __CET_TEST_UNSUPPORTED_INSTRUCTION(insn);	\
> +									\
> +	report(vector == UD_VECTOR, "Wanted #UD on %s, got %s",		\
> +	       insn, exception_mnemonic(vector));			\
> +} while (0)
> +
> +/*
> + * Treat IRET as unsupported with IBT even though the minimal interactions with
> + * IBT _could_ be easily emulated by KVM, as KVM doesn't support emulating IRET
> + * outside of Real Mode.
> + */
> +#define CET_TEST_UNSUPPORTED_INSTRUCTIONS(CET)				\
> +do {									\
> +	CET##_TEST_UNSUPPORTED_INSTRUCTION("callq *%%rax");		\
> +	CET##_TEST_UNSUPPORTED_INSTRUCTION("lcall *%0");		\

Maybe spell out that this is a 32bit far call ("lcalll *%0"), as only
these are supported on AMD *and* Intel? (Intel can do 64bit ones too.)

> +	CET##_TEST_UNSUPPORTED_INSTRUCTION("syscall");			\
> +	CET##_TEST_UNSUPPORTED_INSTRUCTION("sysenter");			\
> +	CET##_TEST_UNSUPPORTED_INSTRUCTION("iretq");			\

These, if emulated, would be rather disastrous to the test. :D
- SYSCALL messes badly with the register state.
- SYSENTER should #UD in long mode on AMD anyway but Intel allows it.
  However, it'll likely #GP early, prior to messing with register state,
  as IA32_SYSENTER_CS doesn't get initialized as the CPU expects it to
  be.
- The stack frame for IRETQ isn't properly set up (lacks CS, RFLAGS, SS,
  RSP) but even if it'll #GP early for the non-canonical address, it'll
  have modified RSP, making the recovery "pop %rax" pop an unrelated
  stack word, likely making the code crash soon after.

So these instructions really *rely* on KVM to #UD on these early.
Dunno, but it feels like the tests should be made more robust wrt.
possible future emulation by KVM?

> +} while (0)
> +
> +static uint64_t cet_shstk_emulation(void)
> +{
> +	CET_TEST_UNSUPPORTED_INSTRUCTIONS(SHSTK);
> +
> +	SHSTK_TEST_UNSUPPORTED_INSTRUCTION("call 1f");
> +	SHSTK_TEST_UNSUPPORTED_INSTRUCTION("retq");
> +	SHSTK_TEST_UNSUPPORTED_INSTRUCTION("retq $10");
> +	SHSTK_TEST_UNSUPPORTED_INSTRUCTION("lretq");
> +	SHSTK_TEST_UNSUPPORTED_INSTRUCTION("lretq $10");
> +
> +	/* Do a handful of JMPs to verify they aren't impacted by SHSTK. */
> +	asm volatile(KVM_FEP "jmp 1f\n\t"
> +		     "1:\n\t"
> +		     KVM_FEP "lea 2f(%%rip), %%rax\n\t"
> +		     KVM_FEP "jmp *%%rax\n\t"
                              ^^^^^^^^^^
Fortunately, this indirect branch runs only with shadow stack enabled,
no IBT. If it would, than below misses an ENDBR64.
                     vvv
> +		     "2:\n\t"> +		     KVM_FEP "push $" xstr(USER_CS) "\n\t"
> +		     KVM_FEP "lea 3f(%%rip), %%rax\n\t"
> +		     KVM_FEP "push %%rax\n\t"
> +		     /* Manually encode ljmpq, which gas doesn't recognize :-( */

LJMPQ is actually only supported on Intel systems. AMD doesn't support
it and one has to emulate it via "push $cs; push $rip; lretq". Dunno if
it's a feature or bug of KVM to emulate LJMPQ fine on AMD -- if it does,
that is!

> +		     KVM_FEP ".byte 0x48\n\t"
> +		     "ljmpl *(%%rsp)\n\t"
> +		     "3:\n\t"
> +		     KVM_FEP "pop %%rax\n\t"
> +		     KVM_FEP "pop %%rax\n\t"
> +		     ::: "eax");
> +
> +	return 0;
> +}
> +

> +/*
> + * Don't invoke printf() or report() in the IBT testcase, as it will likely
> + * generate an indirect branch without an endbr64 annotation and thus #CP.

Uhm, x86/Makefile.x86_64 has this:

fcf_protection_full := $(call cc-option, -fcf-protection=full,)
COMMON_CFLAGS += -mno-red-zone -mno-sse -mno-sse2 $(fcf_protection_full)
[...]
ifneq ($(fcf_protection_full),)
tests += $(TEST_DIR)/cet.$(exe)
endif

So all code that needs it should have a leading ENDBR64 or the cet test
wouldn't be part of the test suite.

However, I also notice it isn't working...

[digging in, hours later...]

After tweaking the exception handling to be able to tweak the IBT
tracker state (which would be stuck at WAIT_FOR_ENDBRANCH for a missing
ENDBR64), it still wouldn't work for me. Bummer! Further instrumentation
showed, the code triggered within exception_mnemonic() which caused only
more question marks -- it's just a simple switch, right? Though, looking
at the disassembly made it crystal clear:

000000000040707c <exception_mnemonic>:
  40707c:       endbr64
  407080:       cmp    $0x1e,%edi
  407083:       ja     407117 <exception_mnemonic+0x9b>
  407089:       mov    %edi,%edi
  40708b:       notrack jmp *0x4107e0(,%rdi,8)
    ::
  4070b1:       mov    $0x411c7c,%eax	# <-- #CP(3) here

The switch block caused gcc to emit a jump table and an indirect jump
for it (to 40708b). The jump is prefixed with 'notrack' to keep the size
of the jump target stubs small, allowing for omitting the ENDBR64
instruction. However, the IBT test code doesn't enable that in the MSR,
leading the CPU to raising a #CP(3) for this indirect jump. D'oh!

So we can either disable the generation of jump tables in gcc
(-fno-jump-tables) or just allow the 'notrack' handling. I guess the
latter is easier.

Attached patch gets me this (on some early CET series patch set, not
v6.18-rcX):

Running user mode Shadow Stack tests
The return-address in shadow-stack = 0x4035ab, in normal stack = 0x4035ab
Try to temper the return-address, this causes #CP on returning...
PASS: NEAR RET shadow-stack protection test
Try to temper the return-address of far-called function...
PASS: FAR RET shadow-stack protection test
PASS: SHSTK: Wanted #UD on callq *%%rax, got #UD
PASS: SHSTK: Wanted #UD on lcall *%0, got #UD
PASS: SHSTK: Wanted #UD on syscall, got #UD
PASS: SHSTK: Wanted #UD on sysenter, got #UD
PASS: SHSTK: Wanted #UD on iretq, got #UD
PASS: SHSTK: Wanted #UD on call 1f, got #UD
FAIL: SHSTK: Wanted #UD on retq, got #GP
FAIL: SHSTK: Wanted #UD on retq $10, got #GP
PASS: SHSTK: Wanted #UD on lretq, got #UD
PASS: SHSTK: Wanted #UD on lretq $10, got #UD
PASS: MSR_IA32_PL3_SSP alignment test.
No endbr64 instruction at jmp target, this triggers #CP...
PASS: Indirect-branch tracking test
PASS: IBT: Wanted #UD on callq *%%rax, got #UD
PASS: IBT: Wanted #UD on lcall *%0, got #UD
PASS: IBT: Wanted #UD on syscall, got #UD
PASS: IBT: Wanted #UD on sysenter, got #UD
PASS: IBT: Wanted #UD on iretq, got #UD
PASS: IBT: Wanted #UD on jmp *%%rax, got #UD
Unhandled exception 13 #GP(0) at ip 0000000000000000
error_code=0000      rflags=00010006      cs=0000004b
rax=aaaaaaaaaaaaaaaa rcx=00000000000003fd rdx=00000000000003f8
rbx=aaaaaaaaaaaaaaaa
rbp=0000000000713e70 rsi=0000000000411cb7 rdi=000000000000000a
 r8=0000000000411cb7  r9=00000000000003f8 r10=000000000000000d
r11=0000000000000000
r12=0000000000000006 r13=0000000000000000 r14=0000000000000000
r15=0000000000000000
cr0=0000000080010011 cr2=0000000000000000 cr3=000000000107f000
cr4=0000000000800020
cr8=0000000000000000
	STACK: @0 4035ab 400deb 4001bd
b'0x0000000000000000: ?? ??:0'

Progress, but still something to fix, namely the "ljmp *%0" which is,
apparently, successfully branching to address 0 and then triggering a
#GP(0). But maybe that's just because I'm on an old version of the KVM
CET series, haven't build v6.18-rcX yet.

Anyhow, one less puzzle, so should be good?

> + * Return the line number of the macro invocation to signal failure.
> + */
> +#define IBT_TEST_UNSUPPORTED_INSTRUCTION(insn)				\
> +do {									\
> +	uint8_t vector = __CET_TEST_UNSUPPORTED_INSTRUCTION(insn);	\
> +									\
> +	if (vector != UD_VECTOR)					\
> +		return __LINE__;					\
> +} while (0)
> +
> +static uint64_t cet_ibt_emulation(void)
> +{
> +	CET_TEST_UNSUPPORTED_INSTRUCTIONS(IBT);
> +
> +	IBT_TEST_UNSUPPORTED_INSTRUCTION("jmp *%%rax");
> +	IBT_TEST_UNSUPPORTED_INSTRUCTION("ljmp *%0");
> +
> +	/* Verify direct CALLs and JMPs, and all RETs aren't impacted by IBT. */
> +	asm volatile(KVM_FEP "jmp 2f\n\t"
> +		     "1: " KVM_FEP " ret\n\t"
> +		     "2: " KVM_FEP " call 1b\n\t"
> +		     KVM_FEP "push $" xstr(USER_CS) "\n\t"
> +		     KVM_FEP "lea 3f(%%rip), %%rax\n\t"
> +		     KVM_FEP "push %%rax\n\t"
> +		     KVM_FEP "lretq\n\t"
> +		     "3:\n\t"
> +		     KVM_FEP "push $0x55555555\n\t"
> +		     KVM_FEP "push $" xstr(USER_CS) "\n\t"
> +		     KVM_FEP "lea 4f(%%rip), %%rax\n\t"
> +		     KVM_FEP "push %%rax\n\t"
> +		     KVM_FEP "lretq $8\n\t"
> +		     "4:\n\t"
> +		     ::: "eax");
> +	return 0;
> +}
> +
>  #define CP_ERR_NEAR_RET	0x0001
>  #define CP_ERR_FAR_RET	0x0002
>  #define CP_ERR_ENDBR	0x0003
> @@ -117,15 +224,20 @@ static void test_shstk(void)
>  	/* Store shadow-stack pointer. */
>  	wrmsr(MSR_IA32_PL3_SSP, (u64)(shstk_virt + 0x1000));
>  
> -	printf("Unit tests for CET user mode...\n");
> +	printf("Running user mode Shadow Stack tests\n");
>  	run_in_user(cet_shstk_func, CP_VECTOR, 0, 0, 0, 0, &rvc);
>  	report(rvc && exception_error_code() == CP_ERR_NEAR_RET,
>  	       "NEAR RET shadow-stack protection test");
> -
>  	run_in_user(cet_shstk_far_ret, CP_VECTOR, 0, 0, 0, 0, &rvc);
>  	report(rvc && exception_error_code() == CP_ERR_FAR_RET,
>  	       "FAR RET shadow-stack protection test");
>  
> +	if (is_fep_available &&
> +	    (run_in_user(cet_shstk_emulation, CP_VECTOR, 0, 0, 0, 0, &rvc) || rvc))
> +		report_fail("Forced emulation with SHSTK generated %s(%u)",
> +			    exception_mnemonic(exception_vector()),
> +			    exception_error_code());
> +
>  	/* SSP should be 4-Byte aligned */
>  	vector = wrmsr_safe(MSR_IA32_PL3_SSP, 0x1);
>  	report(vector == GP_VECTOR, "MSR_IA32_PL3_SSP alignment test.");
> @@ -133,6 +245,7 @@ static void test_shstk(void)
>  
>  static void test_ibt(void)
>  {
> +	uint64_t l;
>  	bool rvc;
>  
>  	if (!this_cpu_has(X86_FEATURE_IBT)) {
> @@ -146,6 +259,12 @@ static void test_ibt(void)
>  	run_in_user(cet_ibt_func, CP_VECTOR, 0, 0, 0, 0, &rvc);
>  	report(rvc && exception_error_code() == CP_ERR_ENDBR,
>  	       "Indirect-branch tracking test");
> +
> +	if (is_fep_available &&
> +	    ((l = run_in_user(cet_ibt_emulation, CP_VECTOR, 0, 0, 0, 0, &rvc)) || rvc))
> +		report_fail("Forced emulation with IBT generated %s(%u) at line %lu",
> +			    exception_mnemonic(exception_vector()),
> +			    exception_error_code(), l);
>  }
>  
>  int main(int ac, char **av)Reviewed-by: Mathias Krause <minipli@grsecurity.net>

Thanks,
Mathias
--------------jdOz0xm8frMTGQPfnrTpEfPS
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-x86-cet-Enable-NOTRACK-handling-for-IBT-tests.patch"
Content-Disposition: attachment;
 filename="0001-x86-cet-Enable-NOTRACK-handling-for-IBT-tests.patch"
Content-Transfer-Encoding: base64

RnJvbSA1Y2JhNGE5Y2NkZmY4ZTY4MmFlNTNlZTY5ODQ5ODc5ZWRjMzI2NzQ2IE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBNYXRoaWFzIEtyYXVzZSA8bWluaXBsaUBncnNlY3Vy
aXR5Lm5ldD4KRGF0ZTogRnJpLCAxNCBOb3YgMjAyNSAxNTo1MzoxMCArMDEwMApTdWJqZWN0
OiBba3ZtLXVuaXQtdGVzdHMgUEFUQ0hdIHg4NjogY2V0OiBFbmFibGUgTk9UUkFDSyBoYW5k
bGluZyBmb3IgSUJUCiB0ZXN0cwoKZ2NjJ3MganVtcCB0YWJsZSBoYW5kbGluZyBtYWtlcyB1
c2Ugb2YgJ25vdHJhY2snIGluZGlyZWN0IGp1bXBzLCBjYXVzaW5nCnNwdXJpb3VzICNDUCgz
KSBleGNlcHRpb25zLgoKRW5hYmxlICdub3RyYWNrJyBoYW5kbGluZyBmb3IgdGhlIElCVCB0
ZXN0cyBpbnN0ZWFkIG9mIGRpc2FibGluZyBqdW1wCnRhYmxlcyBhcyB3ZSBtYXkgd2FudCB0
byBtYWtlIHVzZSBvZiAnbm90cmFjaycgb3Vyc2VsdmVzIGluIGZ1dHVyZQp0ZXN0cy4KCldp
dGggdGhhdCBmaXhlZCwgd2UgY2FuIG1ha2UgdGhlIElCVCB0ZXN0cyByZXBvcnQoKSBzdWNj
ZXNzZnVsbHksIGp1c3QKYXMgdGhlIHNoYWRvdyBzdGFjayB0ZXN0cyBkby4KClNpZ25lZC1v
ZmYtYnk6IE1hdGhpYXMgS3JhdXNlIDxtaW5pcGxpQGdyc2VjdXJpdHkubmV0PgotLS0KIHg4
Ni9jZXQuYyB8IDE3ICsrKysrKysrKy0tLS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgOSBpbnNl
cnRpb25zKCspLCA4IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL3g4Ni9jZXQuYyBiL3g4
Ni9jZXQuYwppbmRleCAzNGM3ODIxMDNhMTAuLjgwMWQ4ZGE2ZTkyOSAxMDA2NDQKLS0tIGEv
eDg2L2NldC5jCisrKyBiL3g4Ni9jZXQuYwpAQCAtOTUsNyArOTUsNyBAQCBzdGF0aWMgdWlu
dDY0X3QgY2V0X2lidF9mdW5jKHZvaWQpCiBkbyB7CQkJCQkJCQkJXAogCXVpbnQ4X3QgdmVj
dG9yID0gX19DRVRfVEVTVF9VTlNVUFBPUlRFRF9JTlNUUlVDVElPTihpbnNuKTsJXAogCQkJ
CQkJCQkJXAotCXJlcG9ydCh2ZWN0b3IgPT0gVURfVkVDVE9SLCAiV2FudGVkICNVRCBvbiAl
cywgZ290ICVzIiwJCVwKKwlyZXBvcnQodmVjdG9yID09IFVEX1ZFQ1RPUiwgIlNIU1RLOiBX
YW50ZWQgI1VEIG9uICVzLCBnb3QgJXMiLAlcCiAJICAgICAgIGluc24sIGV4Y2VwdGlvbl9t
bmVtb25pYyh2ZWN0b3IpKTsJCQlcCiB9IHdoaWxlICgwKQogCkBAIC0xNTIsOCArMTUyLDgg
QEAgc3RhdGljIHVpbnQ2NF90IGNldF9zaHN0a19lbXVsYXRpb24odm9pZCkKIGRvIHsJCQkJ
CQkJCQlcCiAJdWludDhfdCB2ZWN0b3IgPSBfX0NFVF9URVNUX1VOU1VQUE9SVEVEX0lOU1RS
VUNUSU9OKGluc24pOwlcCiAJCQkJCQkJCQlcCi0JaWYgKHZlY3RvciAhPSBVRF9WRUNUT1Ip
CQkJCQlcCi0JCXJldHVybiBfX0xJTkVfXzsJCQkJCVwKKwlyZXBvcnQodmVjdG9yID09IFVE
X1ZFQ1RPUiwgIklCVDogV2FudGVkICNVRCBvbiAlcywgZ290ICVzIiwJXAorCSAgICAgICBp
bnNuLCBleGNlcHRpb25fbW5lbW9uaWModmVjdG9yKSk7CQkJXAogfSB3aGlsZSAoMCkKIAog
c3RhdGljIHVpbnQ2NF90IGNldF9pYnRfZW11bGF0aW9uKHZvaWQpCkBAIC0xODksOCArMTg5
LDkgQEAgc3RhdGljIHVpbnQ2NF90IGNldF9pYnRfZW11bGF0aW9uKHZvaWQpCiAjZGVmaW5l
IENQX0VSUl9TRVRTU0JTWQkweDAwMDUKICNkZWZpbmUgQ1BfRVJSX0VOQ0wJCUJJVCgxNSkK
IAotI2RlZmluZSBFTkFCTEVfU0hTVEtfQklUIDB4MQotI2RlZmluZSBFTkFCTEVfSUJUX0JJ
VCAgIDB4NAorI2RlZmluZSBDRVRfRU5BQkxFX1NIU1RLCUJJVCgwKQorI2RlZmluZSBDRVRf
RU5BQkxFX0lCVAkJQklUKDIpCisjZGVmaW5lIENFVF9FTkFCTEVfTk9UUkFDSwlCSVQoNCkK
IAogc3RhdGljIHZvaWQgdGVzdF9zaHN0ayh2b2lkKQogewpAQCAtMjE5LDcgKzIyMCw3IEBA
IHN0YXRpYyB2b2lkIHRlc3Rfc2hzdGsodm9pZCkKIAlpbnN0YWxsX3B0ZShjdXJyZW50X3Bh
Z2VfdGFibGUoKSwgMSwgc2hzdGtfdmlydCwgcHRlLCAwKTsKIAogCS8qIEVuYWJsZSBzaGFk
b3ctc3RhY2sgcHJvdGVjdGlvbiAqLwotCXdybXNyKE1TUl9JQTMyX1VfQ0VULCBFTkFCTEVf
U0hTVEtfQklUKTsKKwl3cm1zcihNU1JfSUEzMl9VX0NFVCwgQ0VUX0VOQUJMRV9TSFNUSyk7
CiAKIAkvKiBTdG9yZSBzaGFkb3ctc3RhY2sgcG9pbnRlci4gKi8KIAl3cm1zcihNU1JfSUEz
Ml9QTDNfU1NQLCAodTY0KShzaHN0a192aXJ0ICsgMHgxMDAwKSk7CkBAIC0yNTMsOCArMjU0
LDggQEAgc3RhdGljIHZvaWQgdGVzdF9pYnQodm9pZCkKIAkJcmV0dXJuOwogCX0KIAotCS8q
IEVuYWJsZSBpbmRpcmVjdC1icmFuY2ggdHJhY2tpbmcgKi8KLQl3cm1zcihNU1JfSUEzMl9V
X0NFVCwgRU5BQkxFX0lCVF9CSVQpOworCS8qIEVuYWJsZSBpbmRpcmVjdC1icmFuY2ggdHJh
Y2tpbmcgKG5vdHJhY2sgaGFuZGxpbmcgZm9yIGp1bXAgdGFibGVzKSAqLworCXdybXNyKE1T
Ul9JQTMyX1VfQ0VULCBDRVRfRU5BQkxFX0lCVCB8IENFVF9FTkFCTEVfTk9UUkFDSyk7CiAK
IAlydW5faW5fdXNlcihjZXRfaWJ0X2Z1bmMsIENQX1ZFQ1RPUiwgMCwgMCwgMCwgMCwgJnJ2
Yyk7CiAJcmVwb3J0KHJ2YyAmJiBleGNlcHRpb25fZXJyb3JfY29kZSgpID09IENQX0VSUl9F
TkRCUiwKLS0gCjIuNTEuMAoK

--------------jdOz0xm8frMTGQPfnrTpEfPS--

