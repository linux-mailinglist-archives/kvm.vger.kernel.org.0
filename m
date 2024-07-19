Return-Path: <kvm+bounces-21970-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 54397937D07
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 21:41:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 01256281D39
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 19:41:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09E721487E1;
	Fri, 19 Jul 2024 19:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HWUT7dob"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D0C8C2D6;
	Fri, 19 Jul 2024 19:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721418100; cv=none; b=pYdU6/s+OeDXirgn6ngSYdwVh6PLOon3jiRiHYr+61TjX6ZOx2xYbnMm4eAPS7YsNte1hKb4Mml11N/gUaca8zWSIbZF7Ocfi3kP80Asg14Fd2G2Oe6xGgMy87wndqZz/2hLMtOC13vOTYPGYV8MgftrBcGF8dyirimQD24e48o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721418100; c=relaxed/simple;
	bh=8H23THpE1acNvMGj7JC5vQqrevRbSHpynqjvNxDqnY8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Smth03iHYA0to3OfMMGp4d2gdaHTReZij40dJeiKe4MXYqRFmYuiZjEIsmA7Ef4lPJ7GsfaG7mO/zCMYLYOieVVrzi6pnTYyAcqNGBUtXYMwTe8/UCtsQV+RH2wFmpXDcI7GskjX8nV8P9ePdzNB6/Kz1b4dNEYGl82wZKHHACY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HWUT7dob; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-42797289c8bso15587075e9.0;
        Fri, 19 Jul 2024 12:41:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721418097; x=1722022897; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9nF0E5YozCKB1j65ODy12kYcawDfF2oGJyBNWvCvWFw=;
        b=HWUT7dobr5JO6d6POoLxEc717xLu3A2JVbLDjeoUFnC6VoNyKsyE17YXETKChxjBSe
         smQrdMugS4enzfrXcgNviamaaI8bIs0CXpkDBxL21P/C5EASG/kURU7cScD9F5xXRxj/
         sXuXZPoCDnrg8kEu3g77+gpgOk7IUHfbITtgBhyhmBJmJQEr8ryM+CRm1aOOT7FpTrvp
         ED5LMXa2yldNTzaX4QiGYKhdADX90+mz11dqA2FbTTZohfX3P9mej2LFwQe4XNGt/I6F
         fQjacbf1Bmt7E8C+9kWaaqqb0Lfbgzlgtg+sC5lkdAMMomTkQ2RHHFARD0OwajQMZEXu
         6Zxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721418097; x=1722022897;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9nF0E5YozCKB1j65ODy12kYcawDfF2oGJyBNWvCvWFw=;
        b=duTKQiERUyyD0GeFAa9Mg06HFV5kWwnA+udvM9OgFSU2kimaGDFdW9jrgaGuiAHmn5
         v//BALVavosa/MjoU8pUqpJpDH7ScUxN/EdHd6lpnPpjFJP5C/lYIojBIpygXcT2sp7u
         WbKMgstuAsdxU0vL4Y5IXs7FFM6IHGgyk8RV4dTI9IyzxTrtc/Lg0x5aEI1GrsSxoVg4
         YE51LvegARuw+/DWkTrSTsmvMqcwYEqPe8FSPyXw1yy9sB5ho46z03nEP2kmbPRFY3Tp
         gNSfDxpjrc/l3nSYPcwsu9s4krKxhVEIUnyvHNyGWv2OojEDzH82PkdsIQmyDcqAQOHO
         QylQ==
X-Forwarded-Encrypted: i=1; AJvYcCVDQUodW2lmrUnCdNBfZ7/hDhfrnQdg204Z1p37O/AxHJIGqmoe7ah6bH8o0rJzsWjSuHcPCJi5X088/Pfu4Lx8Z3QoJH04IVO4oofr
X-Gm-Message-State: AOJu0YxHiozu7zyuO/1t0nn8scNcZBVvTWtmhclaXVVongjT3nQbwguR
	I9Xc1Uk0oB9YQTbU31kX/M82+5U2xnj5e9VbaZOk7b6DfPrcc/cY
X-Google-Smtp-Source: AGHT+IFpVUhVOzrkrSmhcCOw1aHeZZ7TFtDbev6x/0/UYK9oHIzJi1FTIuSmcB2M8lQ1s+UGk+Wzgw==
X-Received: by 2002:a05:600c:190a:b0:426:59fe:ac2e with SMTP id 5b1f17b1804b1-427c2cfd7a2mr65975045e9.29.1721418096738;
        Fri, 19 Jul 2024 12:41:36 -0700 (PDT)
Received: from [192.168.178.20] (dh207-42-168.xnet.hr. [88.207.42.168])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-427d2a635cdsm62848615e9.13.2024.07.19.12.41.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Jul 2024 12:41:36 -0700 (PDT)
Message-ID: <824a0819-a09d-40ac-820c-f7975aee1dae@gmail.com>
Date: Fri, 19 Jul 2024 21:41:32 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: =?UTF-8?Q?Re=3A_=5BBUG=5D_arch/x86/kvm/vmx/pmu=5Fintel=2Ec=3A54=3A_?=
 =?UTF-8?Q?error=3A_dereference_of_NULL_=E2=80=98pmc=E2=80=99_=5BCWE-476=5D?=
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
 linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>
References: <c42bff52-1058-4bff-be90-5bab45ed57be@gmail.com>
 <ZpqgfETiBXfBfFqU@google.com>
 <70137930-fea1-4d45-b453-e6ae984c4b2b@gmail.com>
 <Zpq9Bp7T_AdbVhmP@google.com>
Content-Language: en-US
From: Mirsad Todorovac <mtodorovac69@gmail.com>
In-Reply-To: <Zpq9Bp7T_AdbVhmP@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 7/19/24 21:22, Sean Christopherson wrote:
> On Fri, Jul 19, 2024, Mirsad Todorovac wrote:
>> On 7/19/24 19:21, Sean Christopherson wrote:
>>> On Fri, Jul 19, 2024, Mirsad Todorovac wrote:
>>>> Hi,
>>>>
>>>> In the build of 6.10.0 from stable tree, the following error was detected.
>>>>
>>>> You see that the function get_fixed_pmc() can return NULL pointer as a result
>>>> if msr is outside of [base, base + pmu->nr_arch_fixed_counters) interval.
>>>>
>>>> kvm_pmu_request_counter_reprogram(pmc) is then called with that NULL pointer
>>>> as the argument, which expands to .../pmu.h
>>>>
>>>> #define pmc_to_pmu(pmc)   (&(pmc)->vcpu->arch.pmu)
>>>>
>>>> which is a NULL pointer dereference in that speculative case.
>>>
>>> I'm somewhat confused.  Did you actually hit a BUG() due to a NULL-pointer
>>> dereference, are you speculating that there's a bug, or did you find some speculation
>>> issue with the CPU?
>>>
>>> It should be impossible for get_fixed_pmc() to return NULL in this case.  The
>>> loop iteration is fully controlled by KVM, i.e. 'i' is guaranteed to be in the
>>> ranage [0..pmu->nr_arch_fixed_counters).
>>>
>>> And the input @msr is "MSR_CORE_PERF_FIXED_CTR0 +i", so the if-statement expands to:
>>>
>>> 	if (MSR_CORE_PERF_FIXED_CTR0 + [0..pmu->nr_arch_fixed_counters) >= MSR_CORE_PERF_FIXED_CTR0 &&
>>> 	    MSR_CORE_PERF_FIXED_CTR0 + [0..pmu->nr_arch_fixed_counters) < MSR_CORE_PERF_FIXED_CTR0 + pmu->nr_arch_fixed_counters)
>>>
>>> i.e. is guaranteed to evaluate true.
>>>
>>> Am I missing something?
>>
>> Hi Sean,
>>
>> Thank you for replying promptly.
>>
>> Perhaps I should have provided the GCC error report in the first place.
> 
> Yes, though the report itself is somewhat secondary, what matters the most is how
> you found the bug and how to reproduce the failure.  Critically, IIUC, this requires
> analyzer-null-dereference, which AFAIK isn't even enabled by W=1, let alone a base
> build.
> 
> Please see the 0-day bot's reports[*] for a fantastic example of how to report
> things that are found by non-standard (by kernel standards) means.
> 
> In general, I suspect that analyzer-null-dereference will generate a _lot_ of
> false positives, and is probably not worth reporting unless you are absolutely
> 100% certain there's a real bug.  I (and most maintainers) am happy to deal with
> false positives here and there _if_ the signal to noise ratio is high.  But if
> most reports are false positives, they'll likely all end up getting ignored.
> 
> [*] https://lore.kernel.org/all/202406111250.d8XtA9SC-lkp@intel.com

I think I understood the meaning between the lines.

However, to repeat the obvious, reducing the global dependencies simplifies the readability
and the logical proof of the code. :-/

Needless to say, dividing into pure functions and const functions reduces the number of
dependencies, as it is N × (N - 1), sqr (N).

For example, if a condition is always true, but the compiler cannot deduce it from code,
there is something odd.

CONCLUSION: If this generated 5 out of 5 false positives, then I might be giving up on this
as a waste of your time.

However, it was great fun analysing x86 KVM code. :-)

Sort of cool that you guys on Google consider bug report from nobody admins from the
universities ;-)

Best regards,
Mirsad Todorovac

