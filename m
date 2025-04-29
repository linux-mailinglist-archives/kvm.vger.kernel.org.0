Return-Path: <kvm+bounces-44825-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D6C1FAA1CAC
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 23:09:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 41534170FCC
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 21:09:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E37F826B09D;
	Tue, 29 Apr 2025 21:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="eXqP1kpt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89CA113AC1
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 21:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745960951; cv=none; b=FXW73zpnYzRyUsDLU2GPeJ9UyV6JmLDNFGil91FJEEG1tFYIuHyNah0BpfImugT7vG83uossQ4uo/xC7mB3NuT5uPJjRQiSKkJWevKdV3LrEQUrzrZABgGKu9GBuJr3/dDxM3NEIa0aKqbIFCNNhvPODS/R0IX/f/7swG4ldv2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745960951; c=relaxed/simple;
	bh=hgbhQTgDo62lWQEOkRNiYcPYKlAEz+do7tSxAtE5VWA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mvCi1vfQrP49vcI6cI2mZj1P8u1YOwfgByb2TWWPUKMq6ZoOAcxtFnUOGbOKlvkJyGeguaMULGFNU0xcWCbm8frEi3b6OqrxVbRDOaoZjc6nsKWkl+e+mfqA2tCL/bH/4GNq+3sb1/hFzFUdGMJiOnzCdkxZkBj9OJBaS0/jZ2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=eXqP1kpt; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-22c33e4fdb8so70181965ad.2
        for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 14:09:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745960949; x=1746565749; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MLeuxHcfNivb7tyBBoY+e0IZqSm/iDGYB29+J+i/d7Q=;
        b=eXqP1kptLY8XRNjpOr5gKLdkY3tTdp/2OWzJS0RqfNgSn/rDK0Axd+U0bqcW4YgxO0
         q9rpl6uIi6ag5Tdv6a/kRUmJqWL1Q2jC/jPOf9t8AYbkrhlmnLgEY2ATKSq58/d+8mmZ
         jYreP7/0pUJepeVC5aoZcqeuAR07qRyS8XADKxSag27OCS5WFpOfhPLxiJMB3BIwunV2
         +7ul+v4N06OX/NXtehNlpXvuaQIqPGoocju9L0lT0/WPa1AKH/IZ5PyrwkhJfGeOtU7Q
         oET30yz1pauoTztLLwAC0xWzG5vlOsOkx/UnnjpdESubWc44ce2/BTxWbOaMig01dXzM
         AGtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745960949; x=1746565749;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MLeuxHcfNivb7tyBBoY+e0IZqSm/iDGYB29+J+i/d7Q=;
        b=Ptg6Kdqud5V6ghxRkkM/WkGZX8v4Wh+t2UStRRHlGjdMhvbf3OlE5dCn3copf8Dgtt
         JWAd6ieMbTtYTK3tXnJGrYf+tckvTHIfgwH5O3+2Wq1bgjEIZ8bcIRG03QJUAMUMOtJa
         SL4IEIuLw1yD1vOK3XN3ztnYn+6kSoUqRKXumszz5lt6kUKAUvprq7sgWV/N5xus7Rhq
         7iaYORUOWxNXau6k2/Wiij3KrPt2ftrfwYaEk2McwwelBZApln4Gc+l2UvrjlPbrs/TL
         nBZIy+1Oxl2n0uv9ct8g8D7ipfHFqhBybfqZnjRbE4RjDw9++8KjdZQaPBu0GYvqlQru
         ENFA==
X-Forwarded-Encrypted: i=1; AJvYcCX6G+y/d1t/YnISx81NIHra6yfWedeS0JwdPMwzTuBHGMUUDe3bhXVx9iCOYCeXPkya0G4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy73gknul15vUp8S1KI2KT/t41BA6+EbwLSPiyREgDExafwRUm9
	Bd5SLdcWlEDID4qYDT2v0aNJLSXZRqxhI+QniLhGz9h+ZYEvzjRF08romb/V9bw=
X-Gm-Gg: ASbGncvK/hX0OAUX8ZFWrs7TxYCshruyWWRUV8wFZlILFkZscnbOiALPAgy0/DcXdy5
	1WPkGxcivp8WwdEXYK28MhyGseRVD07yDBcsND1a/iY++5c49R2oGC9ZqKtGP6TNtJzv2kgllki
	EOjdaXEIVxXP2grd3C3YIRRbFKY9KR/dA8cMD0v45LUurePZLdaO0CHf6ORNCjcsq+4oy/QYWKX
	QxGgilWtQkL2uRwwoh1O7TpnZSS5ektInEZ7uvdTJcpJWr97u3oWRxhPl666LqDkF/V7bFKZ2Nt
	7txr/D8unf7hWG2WlYBgKDPFcoeTVqcuIGOqoDwCHQ3XF94MP28Yxa1+C7nBrKVb
X-Google-Smtp-Source: AGHT+IFRj+IPjAu+ZLe7pYPx3EsLGYybdG1EozzrwQ8TYu9qesZOiZaauU4yxthkSrf6JESEIKXUQw==
X-Received: by 2002:a17:903:3c48:b0:220:d257:cdbd with SMTP id d9443c01a7336-22df358762bmr13027345ad.48.1745960948821;
        Tue, 29 Apr 2025 14:09:08 -0700 (PDT)
Received: from [192.168.1.87] ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22db4d770d6sm107801645ad.17.2025.04.29.14.09.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Apr 2025 14:09:08 -0700 (PDT)
Message-ID: <75cc3e9c-05bc-46e0-9bd0-d0c889133434@linaro.org>
Date: Tue, 29 Apr 2025 14:09:07 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/13] include/system/hvf: missing vaddr include
Content-Language: en-US
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
 alex.bennee@linaro.org, Paolo Bonzini <pbonzini@redhat.com>,
 qemu-arm@nongnu.org, anjo@rev.ng, richard.henderson@linaro.org
References: <20250429050010.971128-1-pierrick.bouvier@linaro.org>
 <20250429050010.971128-3-pierrick.bouvier@linaro.org>
 <e178a430-7916-4294-b0c3-60343ce6f023@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <e178a430-7916-4294-b0c3-60343ce6f023@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 4/29/25 12:13 AM, Philippe Mathieu-Daudé wrote:
> Hi Pierrick,
> 
> On 29/4/25 06:59, Pierrick Bouvier wrote:
>> On MacOS x86_64:
>> In file included from ../target/i386/hvf/x86_task.c:13:
>> /Users/runner/work/qemu/qemu/include/system/hvf.h:42:5: error: unknown type name 'vaddr'
>>       vaddr pc;
>>       ^
>> /Users/runner/work/qemu/qemu/include/system/hvf.h:43:5: error: unknown type name 'vaddr'
>>       vaddr saved_insn;
>>       ^
>> /Users/runner/work/qemu/qemu/include/system/hvf.h:45:5: error: type name requires a specifier or qualifier
>>       QTAILQ_ENTRY(hvf_sw_breakpoint) entry;
>>       ^
>> /Users/runner/work/qemu/qemu/include/system/hvf.h:45:18: error: a parameter list without types is only allowed in a function definition
>>       QTAILQ_ENTRY(hvf_sw_breakpoint) entry;
>>                    ^
>> /Users/runner/work/qemu/qemu/include/system/hvf.h:45:36: error: expected ';' at end of declaration list
>>       QTAILQ_ENTRY(hvf_sw_breakpoint) entry;
>>
>> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
>> ---
>>    include/system/hvf.h | 1 +
>>    1 file changed, 1 insertion(+)
>>
>> diff --git a/include/system/hvf.h b/include/system/hvf.h
>> index 730f927f034..356fced63e3 100644
>> --- a/include/system/hvf.h
>> +++ b/include/system/hvf.h
>> @@ -15,6 +15,7 @@
>>    
>>    #include "qemu/accel.h"
>>    #include "qom/object.h"
>> +#include "exec/vaddr.h"
>>    
>>    #ifdef COMPILING_PER_TARGET
>>    #include "cpu.h"
> 
> What do you think of these changes instead?
> 
> https://lore.kernel.org/qemu-devel/20250403235821.9909-27-philmd@linaro.org/

Sounds good to me, it's the right include set.
I tried to remove cpu.h, and noticed the error, so readded it, without 
investigating too much.

Feel free to merge the current patch on your side (or the version you 
wrote, it's ok for me).

