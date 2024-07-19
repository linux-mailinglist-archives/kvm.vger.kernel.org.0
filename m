Return-Path: <kvm+bounces-21967-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 926B2937CF0
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 21:25:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C1DFFB21C96
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 19:25:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 078D31487CE;
	Fri, 19 Jul 2024 19:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Eke+BEVK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 701F414830F;
	Fri, 19 Jul 2024 19:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721417099; cv=none; b=NHPTgedLKatUjqHCc71LFL2g3dVlfxpBlNI4InHd1VS1rbV4o5e7m1aY+KbBfy/m+sS1mekMoIh/tQu0RFVmFrowhoqK6PIZEXaSGaoHLCzoxsaZ6QQdzOkYVXKdOPTq5dC0PmOpKfEUJAUxe2HGi3etUIX5M+NT4of4X5puiL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721417099; c=relaxed/simple;
	bh=vGeqZIpryEFPDJuT1yJ6W86Uyha0+u0k65cey46kSDI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NTcUl9e34n75GS5YZUGLv9+cafIk9co+5oZZo7xHR24mGW5ou8KWky0v5WkyKW95TM8eHe4WVuNDtB6SdMbpFVAFXa7wy+DKL1FApA+2F8QbZQuEX0SMmT5iqxD15mv1SoXFVyglwvDhod3mOFzrhHICFN3Rk64O3Fg5O3JLyI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Eke+BEVK; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3684e8220f9so656166f8f.1;
        Fri, 19 Jul 2024 12:24:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721417096; x=1722021896; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XMDExgdXOQloXCqTuckcDxogNNvK+nkowrucWqTTb0w=;
        b=Eke+BEVKAuzv06eR5SU75Xr6uqEPo5yLBy6uVodJPwnQomeI9pKicZ2D9HKDw2wbP/
         mRLSpARI2kS9FNw4ZCFD57kUjZ6vP1JUsBKkLMkjbZIV1nuASTZGG6JbxzzdZvKk+cS+
         ykC4L3UznENOcfHXFWBlGczzV/H2TF4eWCPbZC2oH4QEJLjT3rgvPyb5iV++WoP49WY4
         W0yYsNraYGwqLEjrgrBxve6TweraNc3qUwEEIOwTjqJ5SgtIE9P14IZgsVWPxh+NjmEZ
         jnSXcnu4IjXp3gWONLE8xSYnvElmorS4EVtbGh1J5Zjallst1pQpAf/vbjEISttRXWBf
         C37A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721417096; x=1722021896;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XMDExgdXOQloXCqTuckcDxogNNvK+nkowrucWqTTb0w=;
        b=ECxAyT+dGVwJYVg7vt/FORfkYyFOoqnJMLdI5lk3Q8ve0uEnyg8Cg9sWUkevWP880k
         E4ahe9ICkKByP4ukfBGe/+2nQhlZvkVkM2UYe1zAD4GpUDNhD4CI2xuImdqhvRE5zu3m
         ecT0v0vdQpjCUy2n00gzdp3cKfKzY4mno93UH06fty6PuehAz0iV5dWRuLCUKLqAU6el
         y3VZW4rb+TNT93CTKAEWtF68AWQ4sQPkp7phxSpLR8Su5ATI6AVpblH9cP0XW0UZnyM3
         ZdCpF4iqpCDQxaxFCrBHfNnurLU030AJxHEdt30IVmP3OxoAWQaXmgI9x4hWePsjhgoS
         eoiQ==
X-Forwarded-Encrypted: i=1; AJvYcCV+SmiBuy4jaBKF9geFe+CCr6vNL2WUOJ3SpF+mtNV/dh9+UzNaWnqWEn5Pd5AM4GOmHnNcM/JILWFqMGvpW6ik5nluuzY05CPXGN0K
X-Gm-Message-State: AOJu0YyYPgyeJuZJf+3fsVgYPZL9YcckeZMsDLURFrvf0u0qvV0UOqnb
	HMjgKgBVanYeAZVkqYxisL1YJmq71+AvnH49xSgZeu5KXGUiy5DG
X-Google-Smtp-Source: AGHT+IFuhT4nQ/o+RCJyWvzYUED3XY27xOo8ZN8b6KlCp16iABWvCfQKkb/0g4nLF6tAupMUffp33Q==
X-Received: by 2002:adf:e8ce:0:b0:366:df35:b64f with SMTP id ffacd0b85a97d-36873dc1f38mr2297890f8f.4.1721417095524;
        Fri, 19 Jul 2024 12:24:55 -0700 (PDT)
Received: from [192.168.178.20] (dh207-42-168.xnet.hr. [88.207.42.168])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-368786848basm2373461f8f.15.2024.07.19.12.24.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Jul 2024 12:24:55 -0700 (PDT)
Message-ID: <99010d62-7211-4761-9e18-4ae1632b0d40@gmail.com>
Date: Fri, 19 Jul 2024 21:24:51 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: =?UTF-8?Q?Re=3A_=5BBUG=5D_arch/x86/kvm/x86=2Ec=3A_In_function_?=
 =?UTF-8?B?4oCYcHJlcGFyZV9lbXVsYXRpb25fZmFpbHVyZV9leGl04oCZOiBlcnJvcjogdXNl?=
 =?UTF-8?Q?_of_NULL_=E2=80=98data=E2=80=99_where_non-null_expected?=
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
 linux-kernel@vger.kernel.org, David Edmondson <david.edmondson@oracle.com>
References: <1eb96f85-edee-45fc-930f-a192cecbf54c@gmail.com>
 <Zpq4B2I1xcMLmuox@google.com>
Content-Language: en-US
From: Mirsad Todorovac <mtodorovac69@gmail.com>
In-Reply-To: <Zpq4B2I1xcMLmuox@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 7/19/24 21:01, Sean Christopherson wrote:
> On Fri, Jul 19, 2024, Mirsad Todorovac wrote:
>> Hi, all!
>>
>> On linux-stable 6.10 vanilla tree, another NULL pointer is passed, which was detected
>> by the fortify-string.h mechanism.
>>
>> arch/x86/kvm/x86.c
>> ==================
>>
>> 13667 kvm_prepare_emulation_failure_exit(vcpu);
>>
>> calls
>>
>> 8796 __kvm_prepare_emulation_failure_exit(vcpu, NULL, 0);
>>
>> which calls
>>
>> 8790 prepare_emulation_failure_exit(vcpu, data, ndata, NULL, 0);
>>
>> Note here that data == NULL and ndata = 0.
>>
>> again data == NULL and ndata == 0, which passes unchanged all until
>>
>> 8773 memcpy(&run->internal.data[info_start + ARRAY_SIZE(info)], data, ndata * sizeof(data[0]));
> 
> My reading of the C99 is that KVM's behavior is fine.
> 
>   Where an argument declared as size_t n specifies the length of the array for a
>   function, n can have the value zero on a call to that function. Unless explicitly stated
>   otherwise in the description of a particular function in this subclause, pointer arguments
>   on such a call shall still have valid values, as described in 7.1.4. On such a call, a
>   function that locates a character finds no occurrence, a function that compares two
>   character sequences returns zero, and a function that copies characters copies zero
>   characters.
> 
> If the function copies zero characters, then there can't be a store to the NULL
> pointer, and if there's no store, there's no NULL pointer explosion.
> 
> I suppose arguably one could argue the builtin memcpy() could deliberately fail
> on an invalid pointer, but that'd be rather ridiculous.

Thank you again, Sean, for committing so much attention to this warning.

Please don't blame it on me.

It would be for the best if I give the full compiler's warning message:

In file included from ./include/linux/string.h:374,
                 from ./include/linux/bitmap.h:13,
                 from ./include/linux/cpumask.h:13,
                 from ./include/linux/alloc_tag.h:13,
                 from ./include/linux/percpu.h:5,
                 from ./include/linux/context_tracking_state.h:5,
                 from ./include/linux/hardirq.h:5,
                 from ./include/linux/kvm_host.h:7,
                 from arch/x86/kvm/x86.c:20:
arch/x86/kvm/x86.c: In function ‘prepare_emulation_failure_exit’:
./include/linux/fortify-string.h:114:33: error: use of NULL ‘data’ where non-null expected [CWE-476] [-Werror=analyzer-null-argument]
  114 | #define __underlying_memcpy     __builtin_memcpy
      |                                 ^
./include/linux/fortify-string.h:633:9: note: in expansion of macro ‘__underlying_memcpy’
  633 |         __underlying_##op(p, q, __fortify_size);                        \
      |         ^~~~~~~~~~~~~
./include/linux/fortify-string.h:678:26: note: in expansion of macro ‘__fortify_memcpy_chk’
  678 | #define memcpy(p, q, s)  __fortify_memcpy_chk(p, q, s,                  \
      |                          ^~~~~~~~~~~~~~~~~~~~
arch/x86/kvm/x86.c:8773:9: note: in expansion of macro ‘memcpy’
 8773 |         memcpy(&run->internal.data[info_start + ARRAY_SIZE(info)], data,
      |         ^~~~~~
  ‘kvm_handle_memory_failure’: events 1-4
    |
    |13649 | int kvm_handle_memory_failure(struct kvm_vcpu *vcpu, int r,
    |      |     ^~~~~~~~~~~~~~~~~~~~~~~~~
    |      |     |
    |      |     (1) entry to ‘kvm_handle_memory_failure’
    |......
    |13652 |         if (r == X86EMUL_PROPAGATE_FAULT) {
    |      |            ~
    |      |            |
    |      |            (2) following ‘false’ branch (when ‘r != 2’)...
    |......
    |13667 |         kvm_prepare_emulation_failure_exit(vcpu);
    |      |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    |      |         |
    |      |         (3) ...to here
    |      |         (4) calling ‘kvm_prepare_emulation_failure_exit’ from ‘kvm_handle_memory_failure’
    |
    +--> ‘kvm_prepare_emulation_failure_exit’: events 5-6
           |
           | 8790 |         prepare_emulation_failure_exit(vcpu, data, ndata, NULL, 0);
           |      |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
           |      |         |
           |      |         (6) calling ‘prepare_emulation_failure_exit’ from ‘kvm_prepare_emulation_failure_exit’
           |......
           | 8794 | void kvm_prepare_emulation_failure_exit(struct kvm_vcpu *vcpu)
           |      |      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
           |      |      |
           |      |      (5) entry to ‘kvm_prepare_emulation_failure_exit’
           |
           +--> ‘prepare_emulation_failure_exit’: event 7
                  |
                  | 8728 | static void prepare_emulation_failure_exit(struct kvm_vcpu *vcpu, u64 *data,
                  |      |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                  |      |             |
                  |      |             (7) entry to ‘prepare_emulation_failure_exit’
                  |
                ‘prepare_emulation_failure_exit’: event 8
                  |
                  |./include/asm-generic/bug.h:112:12:
                  |  112 |         if (unlikely(__ret_warn_on))                            \
                  |      |            ^
                  |      |            |
                  |      |            (8) following ‘false’ branch...
arch/x86/kvm/x86.c:8753:13: note: in expansion of macro ‘WARN_ON_ONCE’
                  | 8753 |         if (WARN_ON_ONCE(ndata > 4))
                  |      |             ^~~~~~~~~~~~
                  |
                ‘prepare_emulation_failure_exit’: events 9-10
                  |
                  | 8757 |         info_start = 1;
                  |      |         ^~~~~~~~~~
                  |      |         |
                  |      |         (9) ...to here
                  |......
                  | 8760 |         if (insn_size) {
                  |      |            ~
                  |      |            |
                  |      |            (10) following ‘false’ branch (when ‘insn_size == 0’)...
                  |
                ‘prepare_emulation_failure_exit’: event 11
                  |
                  |./include/linux/fortify-string.h:620:62:
                  |  620 |                              p_size_field, q_size_field, op) ({         \
                  |      |                                                              ^
                  |      |                                                              |
                  |      |                                                              (11) ...to here
./include/linux/fortify-string.h:678:26: note: in expansion of macro ‘__fortify_memcpy_chk’
                  |  678 | #define memcpy(p, q, s)  __fortify_memcpy_chk(p, q, s,                  \
                  |      |                          ^~~~~~~~~~~~~~~~~~~~
arch/x86/kvm/x86.c:8772:9: note: in expansion of macro ‘memcpy’
                  | 8772 |         memcpy(&run->internal.data[info_start], info, sizeof(info));
                  |      |         ^~~~~~
                  |
                ‘prepare_emulation_failure_exit’: events 12-17
                  |
                  |./include/linux/fortify-string.h:596:12:
                  |  596 |         if (p_size != SIZE_MAX && p_size < size)
                  |      |            ^
                  |      |            |
                  |      |            (12) following ‘false’ branch (when ‘__p_size > 39’)...
                  |      |            (14) following ‘false’ branch (when ‘__fortify_size <= __p_size’)...
                  |  597 |                 fortify_panic(func, FORTIFY_WRITE, p_size, size, true);
                  |  598 |         else if (q_size != SIZE_MAX && q_size < size)
                  |      |              ~~ ~
                  |      |              |  |
                  |      |              |  (16) following ‘false’ branch (when ‘__fortify_size <= __q_size’)...
                  |      |              (13) ...to here
                  |      |              (15) ...to here
                  |......
                  |  612 |         if (p_size_field != SIZE_MAX &&
                  |      |         ~~  
                  |      |         |
                  |      |         (17) ...to here
                  |
                ‘prepare_emulation_failure_exit’: event 18
                  |
                  |  114 | #define __underlying_memcpy     __builtin_memcpy
                  |      |                                 ^
                  |      |                                 |
                  |      |                                 (18) argument 2 (‘data’) NULL where non-null expected
./include/linux/fortify-string.h:633:9: note: in expansion of macro ‘__underlying_memcpy’
                  |  633 |         __underlying_##op(p, q, __fortify_size);                        \
                  |      |         ^~~~~~~~~~~~~
./include/linux/fortify-string.h:678:26: note: in expansion of macro ‘__fortify_memcpy_chk’
                  |  678 | #define memcpy(p, q, s)  __fortify_memcpy_chk(p, q, s,                  \
                  |      |                          ^~~~~~~~~~~~~~~~~~~~
arch/x86/kvm/x86.c:8773:9: note: in expansion of macro ‘memcpy’
                  | 8773 |         memcpy(&run->internal.data[info_start + ARRAY_SIZE(info)], data,
                  |      |         ^~~~~~
                  |
<built-in>: note: argument 2 of ‘__builtin_memcpy’ must be non-null
  CC [M]  kernel/kheaders.o
cc1: all warnings being treated as errors

Hope this helps.

Best regards,
Mirsad Todorovac

