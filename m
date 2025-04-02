Return-Path: <kvm+bounces-42472-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C8D30A7900D
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 15:41:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E2BC1189252A
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 13:37:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7542B23771C;
	Wed,  2 Apr 2025 13:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="UuAIHe0y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE09620E328
	for <kvm@vger.kernel.org>; Wed,  2 Apr 2025 13:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743601004; cv=none; b=h5ZC1ytnCxzRPuKUSTRU4eC3Ayc+cj5+OoV1/F0V9RDdyQO1qh5+N7TlPfIRGfsxcY9xXdz0jmSvoO+ur3l/fMIFr1SEDu9FbmXSAjWST8kNlNB4xgm6ytDDd/i/uZ0O6onGyvf57JBEFlXBonseNHQW4YjBq7DxRj3//GqhlcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743601004; c=relaxed/simple;
	bh=4jNJ/I1jTSx3GyL4Ifg55JsEj1Dz52ZQASnFkVJ9VJk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ffdq8Brz8qqFyHz9GIgWORolGYBbhskZALpYIsjQ1aHinLvVL1e3WmnDs/rtx1Tban+Ty8d1+SvutHyooq2b5ymvHI0lD06m5FKDjuChGqXoxLfKeX7hXV2XV0m3cztYnc4ZyNxjdrw4p8Kr6GZwPtrGzeZWEzM3nwcDGhFDfaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=UuAIHe0y; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-43948f77f1aso48209015e9.0
        for <kvm@vger.kernel.org>; Wed, 02 Apr 2025 06:36:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1743601001; x=1744205801; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lJfVCNOyKlIn5SjHIiikLpbH+IBtLpw1jWMX+o/dVSU=;
        b=UuAIHe0yCxFUlq1NS6JzDcvpel1Zyn3K7KHD+SccVELBPYPRuPK7U8BMxJJYmMQK3u
         Kxn9OdoNRmccvWBtABrEqrVNscXLYcFYXSaDOX7rNWd7bdWQeNYGyDdCHJBrAV/JNFku
         EZynunq9Jqi9w0HGTf5deNK6d+DEPv3STur9K2c5sUs4yYQ4nXLxuM9MKcEnS2rXWNpu
         rgl2VSG9YQX+TEijx3O73J5taA6LurjXhs0Or4udE1ortOddRFXdKKwk+u7Jjorle6Gx
         atbqW2DfPgtaDB0EP0Mop8Lp3bUqZZ1IndOOD8wBp4+9qUNHj7DuM8Aqj/aWrJSDbbyr
         a2ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743601001; x=1744205801;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lJfVCNOyKlIn5SjHIiikLpbH+IBtLpw1jWMX+o/dVSU=;
        b=BzraVfLj/661oMMUU8sFJBhoDo87qDJFUs4vrZ+VBgi4TqwTO2naoNS6RH6Q0LRhIA
         znFbubYgAOWEyq9AHbtbBRnrpEiL9SUeoxTJur1rl57uL+zuPGUYFO4eIwtmHw/2S5NR
         tQQiTvX7mvBfHyOtvXS/seMNOErV5kgn9amUg4WwW1WXpLBDj8MZmvvofNltJPxEACxB
         D8z5MQyE2VEBZTGvR/ZiCXi7RyFumGaubm8Ol+NwSdG9eTZfu2HRuSi0DTvUydmmZDJK
         ZF6NyYLo6LKs4GCNYKKXuQFz3gSRp5y8agGZTwyEu7E+2TwBIEx8Uh6DAdWtlOjAbZ+o
         8LiQ==
X-Gm-Message-State: AOJu0YxjEZ2mErAE7hF+o/F/pQOkrl7I0Hn0KPs5I0zZHncegFyYr2VV
	oJzlQubD8xXjG881IPQswykegEt8MvIVCSLtTzQ6yC0NyCIJsE4mLqZ0VfO468k=
X-Gm-Gg: ASbGncsSbbiwg7rz/bs/E7rPI2xBa0NrlfkLbj4WY/VuMuaYLKer4DiY9qzKkW0LnFj
	X+hIvPBBm8gWan4fO8cni4QSJ38eaMdeY1hTfYrPmpRnbfOFWcLRU7v8B0YgHglPIaAZbgqAbNQ
	wQB7uQj2I3JiZk6cXPqUt5CBIHzJWl78nP+QEgB6W8UknW3IOa1oAPwV0Fz36/xnIwGlv/WqLtW
	9gwxBGTV5svEVVthua2LLSbH5wfT87Hygr8gF07UEthc1qmnmvfNoyAZHmdedCb+0VM+81Vb7TO
	I5GrFhOIiMj7Ty02y1L4bD7aOD1SvJm/uObwmF9iJm+oX1UJJBxnEiw/WIc1mld8AleyH1tfZEk
	GJBmPxHsdQzfW
X-Google-Smtp-Source: AGHT+IHoyscVn8p5jxvX72Ru3UvDJ2OXxx0IAldkyjAZ5Adle9QLCIrr4AZ9ithEY6/SyYpc+bvqUQ==
X-Received: by 2002:a05:600c:1e22:b0:43b:d0fe:b8ac with SMTP id 5b1f17b1804b1-43db8526564mr178633115e9.30.1743601000940;
        Wed, 02 Apr 2025 06:36:40 -0700 (PDT)
Received: from [192.168.69.235] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39c0b6588e9sm17432591f8f.14.2025.04.02.06.36.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Apr 2025 06:36:40 -0700 (PDT)
Message-ID: <ca52ecb4-6c1d-4299-9764-5839db2d013e@linaro.org>
Date: Wed, 2 Apr 2025 15:36:39 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 20/30] target/arm/cpu: always define kvm related
 registers
To: Richard Henderson <richard.henderson@linaro.org>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org,
 Thomas Huth <thuth@redhat.com>
Cc: kvm@vger.kernel.org, qemu-arm@nongnu.org,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
References: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
 <20250320223002.2915728-21-pierrick.bouvier@linaro.org>
 <1109fe22-9008-47c6-b14d-7323f9888822@linaro.org>
 <11b5441f-c7c0-4b4c-8061-471a49e8465a@linaro.org>
 <428e6fdb-24b9-47a2-9d3f-4ef5c2e1a0ae@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <428e6fdb-24b9-47a2-9d3f-4ef5c2e1a0ae@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 25/3/25 02:24, Richard Henderson wrote:
> On 3/24/25 14:11, Pierrick Bouvier wrote:
>> On 3/23/25 12:37, Richard Henderson wrote:
>>> On 3/20/25 15:29, Pierrick Bouvier wrote:
>>>> This does not hurt, even if they are not used.
>>>>
>>>> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
>>>> ---
>>>>    target/arm/cpu.h | 2 --
>>>>    1 file changed, 2 deletions(-)
>>>>
>>>> diff --git a/target/arm/cpu.h b/target/arm/cpu.h
>>>> index a8a1a8faf6b..ab7412772bc 100644
>>>> --- a/target/arm/cpu.h
>>>> +++ b/target/arm/cpu.h
>>>> @@ -971,7 +971,6 @@ struct ArchCPU {
>>>>         */
>>>>        uint32_t kvm_target;
>>>> -#ifdef CONFIG_KVM
>>>>        /* KVM init features for this CPU */
>>>>        uint32_t kvm_init_features[7];
>>>> @@ -984,7 +983,6 @@ struct ArchCPU {
>>>>        /* KVM steal time */
>>>>        OnOffAuto kvm_steal_time;
>>>> -#endif /* CONFIG_KVM */
>>>>        /* Uniprocessor system with MP extensions */
>>>>        bool mp_is_up;
>>>
>>> I'm not sure what this achieves?   CONFIG_KVM is a configure-time 
>>> selection.
>>>
>>
>> CONFIG_KVM is a poisoned identifier.
>> It's included via config-target.h, and not config-host.h.
> 
> Whoops, yes.

If we go this way, can we consistently allow CONFIG_${HW_ACCEL}
(read "remove poisoned defs in config-poison.h)?

