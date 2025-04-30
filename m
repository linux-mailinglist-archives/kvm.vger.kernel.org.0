Return-Path: <kvm+bounces-44854-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E6360AA42E8
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 08:08:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 43235467819
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 06:08:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAB951E47CC;
	Wed, 30 Apr 2025 06:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jaD+8E5N"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 399141DE2A7
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 06:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745993295; cv=none; b=htZHRLj0GbPIikYsQAuzcms6RV6YdXSgKWpnjQlFr967q1K6NYliaSW6U2I9V0h/Utwla4qfuLDHsJAX8cDmyVE7h/K0PsU3XmT9Eitfe+X2exATdTeeag0mD82ozysBlvkxGsqu5pr/ksuYQPeOwWKXie8P551lODQzber8zQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745993295; c=relaxed/simple;
	bh=Jid16RqCrghEM4X4cWUH0x2XWdLB5WBv0hJj+hVzOP4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=u/HCC1KGPZZqwUhYtLH217imxyixvgHv/Gv03wOFGgPFv4UZylZpNVcnOU1oJ+px/L+rgZbNVY52cHcSHVe7wd0qLVewSFm3LuFdjY5mM6u8KLq2mjtDQ+hWZnQWE+b6HT+uKLVCqhvYBSWAPdLHTJVIUYczXC0qUHTJE6pzODU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=jaD+8E5N; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-43d0618746bso48737675e9.2
        for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 23:08:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745993291; x=1746598091; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rSasN2qvfne7cnvgn4lGh5pVBMg2PxpSK1Y0mTKtEu8=;
        b=jaD+8E5NpzIk8kjXli4zeKOUBfLif2OUMvhUNAkYYi0rTA1sG7NiJ3S8BagSjL9HS/
         vBEXcm5z8Xgg6aoaa1+h52VTnjGQOCPp4U9/0avdZsU/bOTZReLswnJTlSPTuyfG27NQ
         IqXE3TKOpLG4cFAyEQdPPgsS6a2t0Wd1fXU0oY8Qr1q65Xzsq0OoyFDyUkadsikpMBOa
         zuS9rjWqON4MVFxIfAIsHa7Q+63aNgnh6JgN3RAC+qR5itsre1fyvVWcmKfQnSITEzeZ
         A0dw0gByXhBMcXXMsQg1fUqqRkiZswMLll3qm9aAC5Qdi0T+aElzPvp7ncSLuYBDkSS+
         5f2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745993291; x=1746598091;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rSasN2qvfne7cnvgn4lGh5pVBMg2PxpSK1Y0mTKtEu8=;
        b=Qgf0iLTj4489AE24YQz3v/c/rB3AHjgTt1O8iwiYe82vlPGs6Wl3hDbd+LwuzLY13t
         f3OV3D2I6z/Ir+lFkfceQg9RyxK7ZG2u5l6nTB/JUzp8e35AkjAeiu0P01ejwPY0p0Em
         GPFLwXOV9zbl764puLljrmfbO3h5zdAAJYlnEriw7FEV78GMikueTQCCkACSqr4v7SaA
         gRruSMWoJcCoOcWvjyDybUNxjU+vQV4pM7HDCL/leZSqelRl2IG4ahYas1EDbeqZ+B0+
         e3YqNdi4Cowlnl0+95/l2bdbv6Ilkw71Hh1PKwKiwQ8dlScz+Tk/As3+Pvoozbgid+4O
         5MvQ==
X-Forwarded-Encrypted: i=1; AJvYcCVdj+dQNJYyhvWrvbmUls5IpzFiWatpeAz8xIiEOb7SsWEvREwmsGcjYKrj4/aJjPJcM70=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5x6rktFrOJu9NHvzBSzeowiFtdVMAc7ekzqA17nsKBvsLgX8i
	485PqeFIggwoJ3bi+2eICHKCGFkQc6QheZPZ453TCe+OFfSjTIWNFo65B5HFDLs=
X-Gm-Gg: ASbGnctEpH5g0zL4lPy/Oi4eVdm4/6j7z2Q+VASK3LhmcqZbvd8IICCMdO2eGB0M9t/
	KxLpY7Pq7pNHr/O370aMgsgTobgrbDhhXLf1XAz5hJ/wRyUB6sR9P1NqZzBSmffQOfbuue/3yXN
	dYCgUcLXAmRPhtfY76al+9csPorqvLoRO4lLoUoe+0v1MGs2HN2kKWDSM2DUCcodwqaEB4mjIBY
	2+f7jurOBPMIUjd5T2IJ5N4YUtKPWlRF37DaX//FD5hj8u80NPiNLZKigWoUVb4Gg5gsXjLqEtQ
	UwFMC4KrwvfJ7TNMtDmihICtOLDC4ymUMGZS9LkSfGs8072p4D6yYLdotqNbv5PNKDlQIOrDXpO
	Y7f3Gp5tV
X-Google-Smtp-Source: AGHT+IHYmZXRBUbT+lccOGhElxssVlDpwS2bQieP60mt+K+2l6KN+WEnfMLGvN1bTfIOOsLGhLTXEA==
X-Received: by 2002:a05:600c:4ec6:b0:43c:f61e:6ea8 with SMTP id 5b1f17b1804b1-441b2635046mr8742475e9.2.1745993291433;
        Tue, 29 Apr 2025 23:08:11 -0700 (PDT)
Received: from [192.168.69.226] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-441ad870ae0sm26811145e9.2.2025.04.29.23.08.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Apr 2025 23:08:10 -0700 (PDT)
Message-ID: <e88f9bfe-1d8e-4571-81d0-55d750a2da9e@linaro.org>
Date: Wed, 30 Apr 2025 08:08:09 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/13] target/arm/kvm_arm: copy definitions from kvm
 headers
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
Cc: qemu-devel@nongnu.org, Peter Maydell <peter.maydell@linaro.org>,
 kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 qemu-arm@nongnu.org, anjo@rev.ng, richard.henderson@linaro.org
References: <20250429050010.971128-1-pierrick.bouvier@linaro.org>
 <20250429050010.971128-6-pierrick.bouvier@linaro.org>
 <87msbz45y6.fsf@draig.linaro.org>
 <d455055c-a13b-4e00-b921-5ede2be08e89@linaro.org>
 <b044596b-46a0-47ca-a1f0-61160c59efc9@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <b044596b-46a0-47ca-a1f0-61160c59efc9@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 30/4/25 00:02, Pierrick Bouvier wrote:
> On 4/29/25 2:14 PM, Pierrick Bouvier wrote:
>> On 4/29/25 3:28 AM, Alex Bennée wrote:
>>> Pierrick Bouvier <pierrick.bouvier@linaro.org> writes:
>>>
>>>> "linux/kvm.h" is not included for code compiled without
>>>> COMPILING_PER_TARGET, and headers are different depending architecture
>>>> (arm, arm64).
>>>> Thus we need to manually expose some definitions that will
>>>> be used by target/arm, ensuring they are the same for arm amd aarch64.
>>>>
>>>> As well, we must but prudent to not redefine things if code is already
>>>> including linux/kvm.h, thus the #ifndef COMPILING_PER_TARGET guard.
>>>>
>>>> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
>>>> ---
>>>>    target/arm/kvm_arm.h | 15 +++++++++++++++
>>>>    1 file changed, 15 insertions(+)
>>>>
>>>> diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
>>>> index c8ddf8beb2e..eedd081064c 100644
>>>> --- a/target/arm/kvm_arm.h
>>>> +++ b/target/arm/kvm_arm.h
>>>> @@ -16,6 +16,21 @@
>>>>    #define KVM_ARM_VGIC_V2   (1 << 0)
>>>>    #define KVM_ARM_VGIC_V3   (1 << 1)
>>>> +#ifndef COMPILING_PER_TARGET
>>>> +
>>>> +/* we copy those definitions from asm-arm and asm-aarch64, as they 
>>>> are the same
>>>> + * for both architectures */
>>>> +#define KVM_ARM_IRQ_CPU_IRQ 0
>>>> +#define KVM_ARM_IRQ_CPU_FIQ 1
>>>> +#define KVM_ARM_IRQ_TYPE_CPU 0
>>>> +typedef unsigned int __u32;
>>>> +struct kvm_vcpu_init {
>>>> +    __u32 target;
>>>> +    __u32 features[7];
>>>> +};
>>>> +
>>>> +#endif /* COMPILING_PER_TARGET */
>>>> +
>>>
>>> I'm not keen on the duplication. It seems to be the only reason we have
>>> struct kvm_vcpu_init is for kvm_arm_create_scratch_host_vcpu() where the
>>> only *external* user passes in a NULL.
>>>
>>
>> I'm not keen about it either, so thanks for pointing it.
>>
>>> If kvm_arm_create_scratch_host_vcpu() is made internal static to
>>> target/arm/kvm.c which will should always include the real linux headers
>>> you just need a QMP helper.
>>>
>>
>> Yes, sounds like the good approach! Thanks.
>>
> 
> Alas this function is used in target/arm/arm-qmp-cmds.c, and if we move 
> the code using it, it pulls QAPI, which is target dependent at this time.
> 
> Since struct kvm_vcpu_init is only used by pointer, I could workaround 
> this by doing a simple forward declaration in kvm_arm.h.

Correct, great!


