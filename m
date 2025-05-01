Return-Path: <kvm+bounces-45177-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D0195AA6529
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 23:14:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 79F684A38E1
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 21:14:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 115482609F0;
	Thu,  1 May 2025 21:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="u6+usVWj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A64331946DA
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 21:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746134063; cv=none; b=S48rRwrhuNIu4vtEK9lXEEjSOhuYIk4Hu9pGCbvOIEvkGZaf6KlZhYqEXHjCdd9RbhkyYfPbt87H+Yb5J2HW3u7PZsUCqmU/ILnpZUER3XiCqLkDreA6rt7kkLnEGs2p0cbRgPq0t55Z/OI2NwO0EGriKbDWUNzmkqFujSOplqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746134063; c=relaxed/simple;
	bh=yBnyEILSAwfluMGRoKR7Yty9ngDPq4bXZh0Bz4gssHQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DuyMjEMBvdMi7Og5yBjgEamED+B5QlaXSIP9dPHJ5aWXhIpQVnxIt4z+7xDWw9ZSiYxbFQFNHaAsxDOcSLILh1c0WZdJd/Blpt/yt3pvfHCA6s9NY56gKPVp/Y/WUw5SYJM3jw8V8LjG0lYc9IT+hmJ+ZPclG86739BwSnRCaso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=u6+usVWj; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-224019ad9edso21987345ad.1
        for <kvm@vger.kernel.org>; Thu, 01 May 2025 14:14:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746134061; x=1746738861; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IjAzNRLbOrsoMtq/EPdzdknnHjpmqyE7LPvsWSwmdj8=;
        b=u6+usVWjvAL9WuWouMm7Jbt8bi77HP3j/jQpLaEk507qFW461FkVhzdRIEiJUkvKmY
         i6zWxPCrvZqyoJKUqqD5HgCeCrlk9OCZhuNym1dtEWNZYsjH3a1zobxaiRu+cuC9PuQm
         wZLJxWtnVQN1hCM5zNyHCPjXRThcFY6u8sY5wD0WkBj0vW9CYDWOO8pNItLH3do9EpVn
         5Sa/Iq/wvlZlQeuzcxgl9q1ihqBpJ6nUJne1PNMuHhPCTiK7t+hopBDmzdREn9B38HWq
         NLWGrIaOM2WZ4YgI9tu8x+Y4asaDok/25NH9wpaWnREGSyoYuermRNFhV6Mo1tZf5ngE
         AY+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746134061; x=1746738861;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IjAzNRLbOrsoMtq/EPdzdknnHjpmqyE7LPvsWSwmdj8=;
        b=uAB1BaMGQ9rnWW/bKW1TJkAa9JKuYvjE7CB55vJRA8LnEaCRKuZp4arvHYiUhKmhzK
         XdC8Xob9wcQZDBO/ui+FCUV9gXPA0XehJ5T8PvV8ZX1GTJxui6M8+N+m6xbyV3oLUYf5
         xntHpoqcdAmub2JK293eRTZSK5z6Mqrre608EzKALaANB11vITsaLTu2Pwx3FRMhe8qS
         kWo+wkAPOkqJpfvvlTAgSH0/WCA7gKqU8P0yiS9Wf2w6IyCcAzZAMuTvf2zcOQbhwb3k
         zjvAasSPbkmgWl/p3cwYqyfu1+X1Xv5V9Gnhk8S7Wh2BiBV645shZS0lHYgb6cwb69Ih
         X6BA==
X-Forwarded-Encrypted: i=1; AJvYcCW4hQb1HaYUyHujHn0HkRLPNeKNVZo7JrK49sOeSodTlrwg9bhIX9zDxfBa55Ppw8mLE6A=@vger.kernel.org
X-Gm-Message-State: AOJu0YyA7PZEDQmNcT18f73FV0Il36i/AV8vGZkgK8S5NxxjDdsW2vQS
	CK4jgpVgMhZbPIPLGlNid5ddVd0MQXLnq+nIRV2DIfHm1HJKO7rTHSap6C+7aBk=
X-Gm-Gg: ASbGncuC9wbIni2eaqXSnYtnNzfwhSzxV6jBd5CwAIP5iTivG4k/LkiP30r3I+mXKzU
	sA+GqFZgpQ/OjNoUA5lITYK2YdMuC39uh5K3VMgJXP7fLptX5EsYREudoghOA18BKhmJFQLU7Oo
	TcKfb9n6a70oSwz0bfoSTz4cRfKgF/PGmZCdEeiOauYnzpoIKYsUwMRTuIWtt6BKC0cvq7uEZT4
	pb/jxbqB5y4VeyftrJW0sNJqvDIDviYlCo761+Oet1r6Fjazm35irDKPAU7STronjAP0kSAI3lh
	YAQ9UjyHgiRMpXbYYmdwly142QlPLoM9BQI5EV1JKN3CNQGzsaXFgd5q5tsqcs41YfA2Tzum4yk
	2qQxtOq4=
X-Google-Smtp-Source: AGHT+IHrnRruNGSrJshHmWNz0Xu2ccGJ1f+1U8k2VE3mc5qFlXIZViS2LGp1pbaM8OTkQ1Dqx2jCgg==
X-Received: by 2002:a17:903:2f91:b0:223:90ec:80f0 with SMTP id d9443c01a7336-22e10344ebamr9025215ad.22.1746134060854;
        Thu, 01 May 2025 14:14:20 -0700 (PDT)
Received: from [192.168.0.4] (71-212-47-143.tukw.qwest.net. [71.212.47.143])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e1091702asm819235ad.206.2025.05.01.14.14.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 May 2025 14:14:20 -0700 (PDT)
Message-ID: <757f10a3-712b-44a0-9914-5b221e185a20@linaro.org>
Date: Thu, 1 May 2025 14:14:18 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 29/33] target/arm/ptw: replace target_ulong with
 uint64_t
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org,
 alex.bennee@linaro.org, Paolo Bonzini <pbonzini@redhat.com>, anjo@rev.ng,
 kvm@vger.kernel.org
References: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
 <20250501062344.2526061-30-pierrick.bouvier@linaro.org>
 <21d32a4f-8954-4a36-ba0d-6cb7a50f242d@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <21d32a4f-8954-4a36-ba0d-6cb7a50f242d@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 5/1/25 12:35, Philippe Mathieu-Daudé wrote:
> On 1/5/25 08:23, Pierrick Bouvier wrote:
>> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
>> ---
>>   target/arm/ptw.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/target/arm/ptw.c b/target/arm/ptw.c
>> index d0a53d0987f..424d1b54275 100644
>> --- a/target/arm/ptw.c
>> +++ b/target/arm/ptw.c
>> @@ -1660,7 +1660,7 @@ static bool get_phys_addr_lpae(CPUARMState *env, S1Translate *ptw,
>>       uint64_t ttbr;
>>       hwaddr descaddr, indexmask, indexmask_grainsize;
>>       uint32_t tableattrs;
>> -    target_ulong page_size;
>> +    uint64_t page_size;
> 
> Alternatively size_t.

No, this is not related to the size of any host-side object.

Bear in mind this particular page_size is used for the sizes of the intermediate page 
table levels.  So, at the very top level of the page table walk this will be quite large.



r~

