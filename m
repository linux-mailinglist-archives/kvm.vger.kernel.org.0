Return-Path: <kvm+bounces-22053-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C8F50939013
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2024 15:45:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EB3481C20FF6
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2024 13:45:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA73D16D4D1;
	Mon, 22 Jul 2024 13:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a+BLWLaN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D39716D4D7;
	Mon, 22 Jul 2024 13:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721655907; cv=none; b=PvO5HyDqKGroJGJUBF3sqYSVUFzaLJC/hFnaM1FIEadt7wP4mvJS8BTbJACI42cBy0709oD1jDfaFazEznxnXhmRtXimG2zftaREliwrzxnGcGNHkbyQ+X+NZTN/paGI04aFmc1OWZ9jFFixcVcuTdr3aYuYiiGKq9Ry++WsyXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721655907; c=relaxed/simple;
	bh=EtYS+d6x6zLgneJBI6SyZHqmcURZgGiQbSt+k/yrGsI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KAQEcswFEl5a8CyHJpik2q5eQVYn0f6CXW1/vpVM+S4ZybtgAynniY25Hiab1xPFrLELBZMpAkFya85EoBkioAuBoEnM5ZV7ovnurTWYeNpSBYPvfcg66jw7vw1nguo1+6OUbwl0rJqcRUfcpn2o89C823ouXlWMWBO1oZcyCKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a+BLWLaN; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-58f9874aeb4so3222317a12.0;
        Mon, 22 Jul 2024 06:45:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721655904; x=1722260704; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8XGZ/9NOo05JXkZW6LQJzWemV3G3cXpXy4U7z9X0yZE=;
        b=a+BLWLaNNphKvkqSwBNjk8ECnePtAAS1h1J3K/GC3dRUmOSA3Q5Xr2IKE1QxvNVrT+
         z0UWc7Lep4Y4Vfz4nRnNWCQ8IJ3nQnJbj8AD4UrJIAXf/PvnMjJRdXRjwSTdHYU9mt31
         ajV7QkS+XomRRwvWljFfDYruohgPkgj9k2HyB0cAwmGcmdHqa5A41MSPNmcMBdHqKy3R
         tMZu/g03cy0ckqUWHD1IFytb4WDGX0hpnsyGc4W+1ioAdCmcnCYNiYJBcMtFQ7L+nzn7
         WflqGAQUOLWijs3sVBS/hkkZmw/ITSdEsMEa/DRalwbvIc2RustT2yui5Bk+8I8hDLMM
         ddqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721655904; x=1722260704;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8XGZ/9NOo05JXkZW6LQJzWemV3G3cXpXy4U7z9X0yZE=;
        b=X5UbvseOoB/oxBqe+YNEjOvaijEPi2DSI6iUweix+hIIHW8qP3sGYe4hCiGUItHVDM
         aJ9ESH5nUK7e8vNcCTaGCBTr4/uSfoprT2IrimQxbGh5V9hJ8ZPqyUMiByxskyrE4dBJ
         GsSXsRx1LQEi8EDJ6dYKx7UifaAKVc9sdfUY4Yn2NAaHzf5/Civ9O/DHOHrPLMcxYWvk
         J7EUYX/MwaMJW2eFW4wgheHaqjsOooFDsu3u/oIJFhP8vI+LcI44QV2HgCoGHCnmJ1an
         zpv6kX/ckOJ41Fil27W91StlGdILKlxr3+t6j8g8WH/edG1QmJr7QOAIdC1ED8VPrlAr
         hhSQ==
X-Forwarded-Encrypted: i=1; AJvYcCWD4D/xYg75kOppEQF4gmPQz8YOc1P4Hp0iKdOQLWLhl1mirKu1YLZ7h2+iuCywJsPC7iZk0A49CPfThDB3fi2su5S+LUjHVvWd8st7B3ik4FY0Jqs0VQnbIpVW+n6CftcR
X-Gm-Message-State: AOJu0YwBc28ImzKV40e818yeeim1+LG375ZJX2MkVBK8/886W3Eo6clb
	dGNaEnxVje56sKfF8DXTwc+mjyWdMwdR4hWYBN2EeRuQPHA7I776
X-Google-Smtp-Source: AGHT+IGUpWLi5KINnrnH7j9LvFAUyxJ8tqxAzN0mqU6WDSVaJ2/vZq9nKb36lvhw4w/P1SfhYGpj2w==
X-Received: by 2002:a05:6402:3553:b0:5a3:55a5:39f1 with SMTP id 4fb4d7f45d1cf-5a3eee825afmr5637335a12.13.1721655903441;
        Mon, 22 Jul 2024 06:45:03 -0700 (PDT)
Received: from [192.168.178.20] (dh207-42-168.xnet.hr. [88.207.42.168])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5a436f0eac2sm4639266a12.52.2024.07.22.06.45.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Jul 2024 06:45:02 -0700 (PDT)
Message-ID: <d8ad6d4a-148b-4ca4-9e9c-8dcce0274b3f@gmail.com>
Date: Mon, 22 Jul 2024 15:44:56 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: =?UTF-8?Q?Re=3A_=5BBUG=5D_arch/x86/kvm/vmx/pmu=5Fintel=2Ec=3A54=3A_?=
 =?UTF-8?Q?error=3A_dereference_of_NULL_=E2=80=98pmc=E2=80=99_=5BCWE-476=5D?=
To: Jim Mattson <jmattson@google.com>
Cc: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
 Like Xu <likexu@tencent.com>
References: <c42bff52-1058-4bff-be90-5bab45ed57be@gmail.com>
 <ZpqgfETiBXfBfFqU@google.com>
 <70137930-fea1-4d45-b453-e6ae984c4b2b@gmail.com>
 <Zpq9Bp7T_AdbVhmP@google.com>
 <824a0819-a09d-40ac-820c-f7975aee1dae@gmail.com>
 <CALMp9eStzLK7kQY41b37zvZuR7UVzOD+W7vDPhyKXYPDhUww0g@mail.gmail.com>
Content-Language: en-US
From: Mirsad Todorovac <mtodorovac69@gmail.com>
In-Reply-To: <CALMp9eStzLK7kQY41b37zvZuR7UVzOD+W7vDPhyKXYPDhUww0g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 7/19/24 22:14, Jim Mattson wrote:
> On Fri, Jul 19, 2024 at 12:41 PM Mirsad Todorovac
> <mtodorovac69@gmail.com> wrote:
>>
>>
>>
>> On 7/19/24 21:22, Sean Christopherson wrote:
>>> On Fri, Jul 19, 2024, Mirsad Todorovac wrote:
>>>> On 7/19/24 19:21, Sean Christopherson wrote:
>>>>> On Fri, Jul 19, 2024, Mirsad Todorovac wrote:
>>>>>> Hi,
>>>>>>
>>>>>> In the build of 6.10.0 from stable tree, the following error was detected.
>>>>>>
>>>>>> You see that the function get_fixed_pmc() can return NULL pointer as a result
>>>>>> if msr is outside of [base, base + pmu->nr_arch_fixed_counters) interval.
>>>>>>
>>>>>> kvm_pmu_request_counter_reprogram(pmc) is then called with that NULL pointer
>>>>>> as the argument, which expands to .../pmu.h
>>>>>>
>>>>>> #define pmc_to_pmu(pmc)   (&(pmc)->vcpu->arch.pmu)
>>>>>>
>>>>>> which is a NULL pointer dereference in that speculative case.
>>>>>
>>>>> I'm somewhat confused.  Did you actually hit a BUG() due to a NULL-pointer
>>>>> dereference, are you speculating that there's a bug, or did you find some speculation
>>>>> issue with the CPU?
>>>>>
>>>>> It should be impossible for get_fixed_pmc() to return NULL in this case.  The
>>>>> loop iteration is fully controlled by KVM, i.e. 'i' is guaranteed to be in the
>>>>> ranage [0..pmu->nr_arch_fixed_counters).
>>>>>
>>>>> And the input @msr is "MSR_CORE_PERF_FIXED_CTR0 +i", so the if-statement expands to:
>>>>>
>>>>>     if (MSR_CORE_PERF_FIXED_CTR0 + [0..pmu->nr_arch_fixed_counters) >= MSR_CORE_PERF_FIXED_CTR0 &&
>>>>>         MSR_CORE_PERF_FIXED_CTR0 + [0..pmu->nr_arch_fixed_counters) < MSR_CORE_PERF_FIXED_CTR0 + pmu->nr_arch_fixed_counters)
>>>>>
>>>>> i.e. is guaranteed to evaluate true.
>>>>>
>>>>> Am I missing something?
>>>>
>>>> Hi Sean,
>>>>
>>>> Thank you for replying promptly.
>>>>
>>>> Perhaps I should have provided the GCC error report in the first place.
>>>
>>> Yes, though the report itself is somewhat secondary, what matters the most is how
>>> you found the bug and how to reproduce the failure.  Critically, IIUC, this requires
>>> analyzer-null-dereference, which AFAIK isn't even enabled by W=1, let alone a base
>>> build.
>>>
>>> Please see the 0-day bot's reports[*] for a fantastic example of how to report
>>> things that are found by non-standard (by kernel standards) means.
>>>
>>> In general, I suspect that analyzer-null-dereference will generate a _lot_ of
>>> false positives, and is probably not worth reporting unless you are absolutely
>>> 100% certain there's a real bug.  I (and most maintainers) am happy to deal with
>>> false positives here and there _if_ the signal to noise ratio is high.  But if
>>> most reports are false positives, they'll likely all end up getting ignored.
>>>
>>> [*] https://lore.kernel.org/all/202406111250.d8XtA9SC-lkp@intel.com
>>
>> I think I understood the meaning between the lines.
>>
>> However, to repeat the obvious, reducing the global dependencies simplifies the readability
>> and the logical proof of the code. :-/
> 
> Comments would also help. :)
> 
>> Needless to say, dividing into pure functions and const functions reduces the number of
>> dependencies, as it is N × (N - 1), sqr (N).
>>
>> For example, if a condition is always true, but the compiler cannot deduce it from code,
>> there is something odd.
>>
>> CONCLUSION: If this generated 5 out of 5 false positives, then I might be giving up on this
>> as a waste of your time.
>>
>> However, it was great fun analysing x86 KVM code. :-)
> 
> I assure you that there are plenty of actual bugs in KVM. This tool
> just isn't finding them.

Well, this series of reports did not target KVM. It was accidental that GCC static analyser
reported those dubious false positives first.

Best regards,
Mirsad Todorovac
 
>> Sort of cool that you guys on Google consider bug report from nobody admins from the
>> universities ;-)
>>
>> Best regards,
>> Mirsad Todorovac
>>

