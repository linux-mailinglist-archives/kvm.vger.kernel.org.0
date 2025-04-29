Return-Path: <kvm+bounces-44824-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C62CAA1CA8
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 23:07:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EF3601BC2422
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 21:07:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0ECA0268688;
	Tue, 29 Apr 2025 21:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="QqBIujIw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83D9326A1D9
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 21:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745960827; cv=none; b=TK6CoDsgoEQU8Vw8ERCKtgIYqJMPriuQHF33PrygT55YTZCdypnSdIvO3SdEuc+uLqguClwtp2X4HksVKNqDQwM08f74+DgPHcRRUaqsj1CTXXXRzSWE7P2OaOx5X3x5kmXOyMs4kJGF6Lu+kv52W5hFOS54OOsW8oNkEyHz5Mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745960827; c=relaxed/simple;
	bh=LWgkH39AdAHGMott5a3i+zxxXldGQog2oioV2KbhQzg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fhxWxfQh8vPsTLCL1iLngD7RArUv/4mn5oU6riNIROaboX2XS4tynfXXnCP09tW5mxU2xJQNsCKNY0+sSViNxbC0uPiEtI3owBpeFBR5QS79fSk2hDWUh1Ml6y0iIIEPgK4ERlYgsuTdDuE9vg9k2LGD1YSTU53CchdmwyxUelY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=QqBIujIw; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-74019695377so2307438b3a.3
        for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 14:07:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745960825; x=1746565625; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=J0R7aQy+3GY23ZMFehDXTfzL4PuUym9QxuFfe3VQUYA=;
        b=QqBIujIwqRHsuGVkgNBZJC5fZBtt34vakZ02mjHkMHsPbWaQMD/rmpvNM1aYYTxE/O
         VGnJ7AzTKziwrBMnny2IQCzH4tpMOukMuwagCbRGRWC4oViRjCGcqLe/ZSNpNIkmuy42
         +g0AxRGH75aA0l7XYzUAg8it3wjuSpJrriR40fk1ayXPKjr1aavAAxvjUxCX9TJHTIPC
         GiwINv3paNPMU9mJ14KtbVv2nxhxqEO11lZdC2hkCIc0otb37I51ew+1GUruLXORIFiS
         pOyMoiwzqWyMhVAtAaRli/+1GXe0b21EU6qUF/clgiQK06yp4vGOuFV3ElHqq6CaLvlC
         Ectw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745960825; x=1746565625;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J0R7aQy+3GY23ZMFehDXTfzL4PuUym9QxuFfe3VQUYA=;
        b=aFZnqz7/EQr/d/hsV6dgRrGsU/qaEfCAlO8VqqgqptonbSBdqs0jzOHD7rd+oLSxM/
         LsFZDVbgWKuJsO7HUUTE1QAVPpSGtuFJ3CC88my0QWH/AXv9BdlUOZBiAvDZGz77IeQb
         4SHqyhyA4CDwxmeUtCgOW0lWJfKMpehVVMF0742OJpD572HR7Drru8rG+GsehNsmZoQ6
         MIhumxG6KzxZnWBBI++6zNxxhTWg4+mhnFVWWjzgxCkoqNTzDBy32v+4h+GJrPPQ9MDP
         7ZsDD0NSQUqVCu+Q8dfbXZpcOenpQxJCMVkQEEwWTKft0wXuHrdQcS15EQCjV0K2czpz
         o1PA==
X-Forwarded-Encrypted: i=1; AJvYcCWiOaJuzv36pK7nQvgVpQ1V0KbC0/tL/khP2vFUjjl96KigFXoDl6QC+59n1kOjVQRN+3E=@vger.kernel.org
X-Gm-Message-State: AOJu0YwwZ40tpZ2cqX1reiky2A0knKaPhLtz6EXRRS05aedEkctmFudb
	Hc9zfgx79dG96I81YsZ+BDI7/vYPj1f58EZAx7l1CyjFWo6J1oIHlWQsBUm2R2TpCl428towRC8
	L
X-Gm-Gg: ASbGncvh0YOpFAoddXoo75+qXKMh1J9oP/RDi0hEy81KmVWjdHh5bERZSAF/3F3Pmoh
	WCCNRMi2kLHOb7dkNb7ibZLM40O02+cO93j+ngnGpTwKYSi0o9At1tngfXEs7u/RIgjtOXV2mMW
	yWq+qeiaKoW5LpsM0hFWIaEZnE4D4NZlnhOsymb+4f34gEMbk7EJkkWBSu+Uw7NSEfTrymHO158
	/BB+PMPv+GWCDubYmBiMohGAaZNJfJClKi/RPU8bPzUt9bDaszFSvgXCG2kcedRz8uc3v2lagKY
	RFKbtO82/t1CtNQ9hBxyWWMj/f3B8mVsmylEAe1L6sifN3bJLfyd2g==
X-Google-Smtp-Source: AGHT+IH32wV8hOys1/FlSKA99ZrcKLdxQ/jVjCKspBhTfIoQlbisbUoYD7FByxZw5MrxgeqxouXjtA==
X-Received: by 2002:a05:6a00:10ce:b0:739:56c2:b661 with SMTP id d2e1a72fcca58-740389b795bmr898455b3a.12.1745960824759;
        Tue, 29 Apr 2025 14:07:04 -0700 (PDT)
Received: from [192.168.1.87] ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74039a5c36bsm146946b3a.132.2025.04.29.14.07.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Apr 2025 14:07:04 -0700 (PDT)
Message-ID: <6e628189-f497-4d95-a6ac-c3cc726be2ad@linaro.org>
Date: Tue, 29 Apr 2025 14:07:03 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/13] target/arm/cpu: get endianness from cpu state
To: Anton Johansson <anjo@rev.ng>
Cc: qemu-devel@nongnu.org, Peter Maydell <peter.maydell@linaro.org>,
 kvm@vger.kernel.org, alex.bennee@linaro.org,
 Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-arm@nongnu.org, richard.henderson@linaro.org
References: <20250429050010.971128-1-pierrick.bouvier@linaro.org>
 <20250429050010.971128-10-pierrick.bouvier@linaro.org>
 <bwdflzaiqdpq33uzowvrgjbha3wye6k74puwur755pq27z67eu@mnc2ze4it5cl>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Content-Language: en-US
In-Reply-To: <bwdflzaiqdpq33uzowvrgjbha3wye6k74puwur755pq27z67eu@mnc2ze4it5cl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/29/25 5:26 AM, Anton Johansson wrote:
> On 29/04/25, Pierrick Bouvier wrote:
>> Remove TARGET_BIG_ENDIAN dependency.
>>
>> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
>> ---
>>   target/arm/cpu.c | 22 +++++++++++-----------
>>   1 file changed, 11 insertions(+), 11 deletions(-)
>>
>> diff --git a/target/arm/cpu.c b/target/arm/cpu.c
>> index e7a15ade8b4..85e886944f6 100644
>> --- a/target/arm/cpu.c
>> +++ b/target/arm/cpu.c
>> @@ -67,6 +67,15 @@ static void arm_cpu_set_pc(CPUState *cs, vaddr value)
>>       }
>>   }
>>   
>> +static bool arm_cpu_is_big_endian(CPUState *cs)
>> +{
>> +    ARMCPU *cpu = ARM_CPU(cs);
>> +    CPUARMState *env = &cpu->env;
>> +
>> +    cpu_synchronize_state(cs);
>> +    return arm_cpu_data_is_big_endian(env);
>> +}
>> +
>>   static vaddr arm_cpu_get_pc(CPUState *cs)
>>   {
>>       ARMCPU *cpu = ARM_CPU(cs);
>> @@ -1130,15 +1139,6 @@ static void arm_cpu_kvm_set_irq(void *opaque, int irq, int level)
>>   #endif
>>   }
>>   
>> -static bool arm_cpu_virtio_is_big_endian(CPUState *cs)
>> -{
>> -    ARMCPU *cpu = ARM_CPU(cs);
>> -    CPUARMState *env = &cpu->env;
>> -
>> -    cpu_synchronize_state(cs);
>> -    return arm_cpu_data_is_big_endian(env);
>> -}
>> -
>>   #ifdef CONFIG_TCG
>>   bool arm_cpu_exec_halt(CPUState *cs)
>>   {
>> @@ -1203,7 +1203,7 @@ static void arm_disas_set_info(CPUState *cpu, disassemble_info *info)
>>   
>>       info->endian = BFD_ENDIAN_LITTLE;
>>       if (bswap_code(sctlr_b)) {
>> -        info->endian = TARGET_BIG_ENDIAN ? BFD_ENDIAN_LITTLE : BFD_ENDIAN_BIG;
>> +        info->endian = arm_cpu_is_big_endian(cpu) ? BFD_ENDIAN_LITTLE : BFD_ENDIAN_BIG;
>>       }
> 
> I'm not the most familiar with arm but as far as I can tell these are
> not equivalent. My understanding is that arm_cpu_is_big_endian() models
> data endianness, and TARGET_BIG_ENDIAN instruction endianness.
> 
> Also, for user mode where this branch is relevant, bswap_code() still
> depends on TARGET_BIG_ENDIAN anyway and the above branch would reduce to
> (on arm32)
> 
>    if (TARGET_BIG_ENDIAN ^ sctlr_b) {
>        info->endian = sctlr_b ? BFD_ENDIAN_LITTLE : BFD_ENDIAN_BIG;
>    }
> 
> giving the opposite result to the original code.
> 

Ooops, that's a good point, I missed it was calling 
arm_cpu_data_is_big_endian under the hoods.

I'll stick to target_big_endian().

Thanks,
Pierrick

