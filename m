Return-Path: <kvm+bounces-45290-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F6B9AA833D
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 00:35:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C623017BF69
	for <lists+kvm@lfdr.de>; Sat,  3 May 2025 22:35:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E15A1DACB8;
	Sat,  3 May 2025 22:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="t9zDPJ6A"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6865EBE
	for <kvm@vger.kernel.org>; Sat,  3 May 2025 22:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746311741; cv=none; b=SDF3ssBBsMaxY9Ce4OUn2eT8qHtpPBvZYHHvsE1ffmyXE4nGTXsYYAZ9QODkVAkgsCidjW4yWQS2yVn6/8PhzNx/X7Vx1oosIapwY4N5+ywTSYol7DwTkVoHQnnKHT090CJTqrcXzB1iEw8xW7nBtE9LPMLy2X3EtV1uhwuJ7c4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746311741; c=relaxed/simple;
	bh=PTl/PrwN2DUZGCbukeV3fhbviBY/xfkT5eSVv3ZWkE8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i9Wif57XDbNkGTIAN9+MYpoz4yBGRbxoq1SykYInsaN1knT1UaQI2BtTa6jiaGGY7t1vwiq8PbmnSNNjK0TWXdgkPDf8n971zl1D/Z2LVRk49O2kTywECLspuLyUiifU8s/Oi/4qjt/cC5QQ8v3F1GnM8o2/eIqxVr3AMMFX74k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=t9zDPJ6A; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-30549dacd53so2849170a91.1
        for <kvm@vger.kernel.org>; Sat, 03 May 2025 15:35:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746311739; x=1746916539; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zBDLv71STM75w0x2/WasV/3cQ/v/8orxvJvsjTDMfqY=;
        b=t9zDPJ6A8X3a9gMs4hClce5wqbR7NBXNPj74l3WhGf09FNv61RUrsR29waZAf2S0aC
         oaVhoY+wtPi8Me0HgMwDWcsE57zhyGlKz0SjcxlPAVwFSbCmcwBYzCZQVqXg1tExt6el
         fbHf2PQgkZ3gOvCdKUMIrJQeITmB37gpgHnfNtX/CVNpXoKtpwbCeBEN4wq9YrhIpDh/
         B1W/sEq2YA+rpinxDds3XYiSTk7ZYsWAcqrbwvtAw9v/VIhi90NAIf35i8DBdoGumfv9
         Uv4i4+hFSzqGEVyZo/qL0J3tWJccWG9tmmwAIcflcmciptqHdnfNOchJqkNJDq2Ehp+3
         JrQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746311739; x=1746916539;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zBDLv71STM75w0x2/WasV/3cQ/v/8orxvJvsjTDMfqY=;
        b=eAvrEAuJ4WWJGZgWOw70bfRHzozOSSkgZwudkeHAo020ciiPNCOl6AdUyT+f7NGZ3V
         lc9rnk/gF8h62dJ82o5xZf1FbwTG0Ok/oxWwoXKxIyc/WHpjnA3myQbtsZlSmybiUtya
         9Rfc1kGvdc0kNQtG19oYH4ZU27WqkAvMl5sJ9wVK8sv+xWOm82Lb/RJLDqEwVc94yuVh
         oKIw/t+niLuDznSDZU6Z/3QB/Gzh9uT4vfduZCpiC2YJyiSeZJf4MQV/sQjjjAdWKvT5
         oXsjqK9FQtM60FhTLcRXUyHgkXm6kbdhYqPP9dDWaY0Xu4WmqZfvgt2s9d0rArm2wNex
         5O0g==
X-Forwarded-Encrypted: i=1; AJvYcCV9MW/QTj0oqAKZLcn7/wmCzAGLuH8WxWdNRCDuDxSimFUtJ3gBhmgBGm4eLciXL7Rbv+k=@vger.kernel.org
X-Gm-Message-State: AOJu0YwX7a/6nzaPXqM0SlSlXa5u9pCbu2Wm5/k3CA1pvcLW15TqCZRk
	zgKE1/xZr5Kya6qUh/3szFVZz93cVYnGg9aGR0yDMnLfvHIbZRVVy5k0DU5PWoU=
X-Gm-Gg: ASbGncuPWsmpS/PWC8lPYDoo5KgP4v1a/6h4etIaBnMKOQG6CBoEaVKj8A9taoDSynU
	g28eWZ7E8tKg2DIhFwmwwd871GPabtUcxaMPPMxmXAh6/3bxSX3VVt6gJgLKHdQ1kCJLQaMdII5
	1gkSHzr9d6eC7XtEABFkM/ZZbcYMAUBsfrtfPzIrJij5dMuXED2um+JGRCFY8vEXtk751wW8lwZ
	9knKxsfI6GersQiKAZkTHfZdSYTpkVKkql/1jDoeC7xeix3vQyU+cawWuhl25pxJ2pTpFEK+VDz
	cm9HL7c/qQxAb+fUE0hfiAbdtffS+Vlcwg/hOqPxJ8LjvcXgtZXhMg==
X-Google-Smtp-Source: AGHT+IFJAVVz+DXuFU/KI+fGh5lxTsxPYTq2T+1ENcK3xXo/V3zdiRTE8LsOsqIZ267Yuwp1VlKb5w==
X-Received: by 2002:a17:90b:3bc6:b0:2fa:2268:1af4 with SMTP id 98e67ed59e1d1-30a42e72d1amr15068492a91.7.1746311738932;
        Sat, 03 May 2025 15:35:38 -0700 (PDT)
Received: from [192.168.1.87] ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e150eae35sm28820185ad.27.2025.05.03.15.35.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 03 May 2025 15:35:38 -0700 (PDT)
Message-ID: <a1894468-896f-41ba-8c20-851f92b465d5@linaro.org>
Date: Sat, 3 May 2025 15:35:37 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 29/33] target/arm/ptw: replace target_ulong with
 uint64_t
Content-Language: en-US
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org,
 richard.henderson@linaro.org, alex.bennee@linaro.org,
 Paolo Bonzini <pbonzini@redhat.com>, anjo@rev.ng, kvm@vger.kernel.org
References: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
 <20250501062344.2526061-30-pierrick.bouvier@linaro.org>
 <21d32a4f-8954-4a36-ba0d-6cb7a50f242d@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <21d32a4f-8954-4a36-ba0d-6cb7a50f242d@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 5/1/25 12:35 PM, Philippe Mathieu-Daudé wrote:
> On 1/5/25 08:23, Pierrick Bouvier wrote:
>> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
>> ---
>>    target/arm/ptw.c | 4 ++--
>>    1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/target/arm/ptw.c b/target/arm/ptw.c
>> index d0a53d0987f..424d1b54275 100644
>> --- a/target/arm/ptw.c
>> +++ b/target/arm/ptw.c
>> @@ -1660,7 +1660,7 @@ static bool get_phys_addr_lpae(CPUARMState *env, S1Translate *ptw,
>>        uint64_t ttbr;
>>        hwaddr descaddr, indexmask, indexmask_grainsize;
>>        uint32_t tableattrs;
>> -    target_ulong page_size;
>> +    uint64_t page_size;
> 
> Alternatively size_t.
> 
>>        uint64_t attrs;
>>        int32_t stride;
>>        int addrsize, inputsize, outputsize;
>> @@ -1733,7 +1733,7 @@ static bool get_phys_addr_lpae(CPUARMState *env, S1Translate *ptw,
>>         * validation to do here.
>>         */
>>        if (inputsize < addrsize) {
>> -        target_ulong top_bits = sextract64(address, inputsize,
>> +        uint64_t top_bits = sextract64(address, inputsize,
>>                                               addrsize - inputsize);
> 
> Maybe use int64_t for signed? Anyway, pre-existing, so:
>

Yes, I'll change to signed integer.

> Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> 
>>            if (-top_bits != param.select) {
>>                /* The gap between the two regions is a Translation fault */
> 


