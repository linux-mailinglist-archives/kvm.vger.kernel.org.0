Return-Path: <kvm+bounces-40534-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 31DACA5899F
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 01:15:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6CFF1162ACE
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 00:15:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9796ED2FB;
	Mon, 10 Mar 2025 00:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uv5zKATV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E39A8139E
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 00:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741565701; cv=none; b=mFaq3IFT3Hv6v8jZVG9uzagpCWVic5xFupuAJRZ4+I0jzTPdJ+eo2zSXOPuKeT9hOSbAKZkqqqx64nlmJtBcfMNmOdeg7E69vIU1FivwZbn7B5gSfpuBoTYLcM0XOG5I75Bso4VpWVqa6TSKAejxzLZm00+NzocQtvOWVcARIws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741565701; c=relaxed/simple;
	bh=zQUytR9IVeImFy6HMa06HgHBiiDz0m/YEBJQUrvX3e4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ABS/R1QMf4aEajgcVHLiKe1Ck7GJTQrclCQBEamy00IdgZPEPKliFLlKk6QrQ39ouxIGxAFFg9f9IqvLR1TE/asGtZOFGD4f5BY6XKMILe3kJTRlGLh2O4E9Dsvic89rnxB39JIf6SB7cL1wXpCdrJ443lg/CEp3CqTAKuAzhWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=uv5zKATV; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-390f5f48eafso1790495f8f.0
        for <kvm@vger.kernel.org>; Sun, 09 Mar 2025 17:14:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741565698; x=1742170498; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3XDnzfquwfvMltHwbNocic4mvgShzRB7PHB47fqbJOQ=;
        b=uv5zKATVKPNq/ZIzCUUMPN/WpOQdWXsqWovN7pmWRgo3axjJlujviRsAyF0wr2n+yC
         evdU+b7vGPxQfpBhe2jtgSGWIGxeqtZcYaozWwghbZ0DDFJkxs/qbH05Bx7dSU1Iu4mh
         gq/GPPq6e25rMalx6FiMVcqV8HUUzn2a9kOdp66aZ7wi6PnwuhxWcmfaj43p155vDQaJ
         5al69nk/K0seG3PUy9EEvtapP2KjMwji21i1m1I7BS9j7mrEViCfRnEArAJ4SogPh8IX
         dOwEyu1QxRQUWi/1T9wn02uGtku9xZG1NAWTFxweBYkWKsn0VjLZq4XWHLfVGBtzTPyt
         LR3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741565698; x=1742170498;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3XDnzfquwfvMltHwbNocic4mvgShzRB7PHB47fqbJOQ=;
        b=lMBo/h+KgN3nS+VIUcMTb7LcqyEDrz0AqgElz3OOC7k9wKa2fTpmYyP8JCyqDnfeBp
         DDWoBj5BSxn6W+40JppjtrDBf6dCGfg0pJzNPi0uiatuoURFeAWxKtGXbLYAqUn1la2+
         7YcTg1OESuyNd48Mj16k0TfnTQm6YrwwdUXlIndla7wUMthTESVtzyMGFq0HKhY/V0cb
         uPUxFdrcIRXeJ1hoI4pW6ZOCzUZPEQOyNAlCdKuHBBHp9/qy72EYK0uyefQTAQ67ma0t
         kdNv9Ih2dZTB8ofIOKnEE1EDSRkzASky+mF9IHCLJ5/DlnH4uXG+VvzIAgPzjFhDpqg3
         jsrQ==
X-Forwarded-Encrypted: i=1; AJvYcCVgH3DfONnd++rl3R6PeEd2rgrS9MSEaZ14oL83GGYd/M/pl8m/ekt4GZ74inO1LR1uCuU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxxg8dlvVZgn0CmCjI6fgI21aMFvBBlDR39bbdTUdFHqBqZGJbc
	3Uky15SoWfnht+vwFuyLug1WrZMM8rzn4pwuf9JJE70Blpfnv1YCRLtBWSsT2YA=
X-Gm-Gg: ASbGnct5HrdIF2Jt6ua6UfgUzbOfFjBg7aoyr/mxE5mMUk4Jq5e1SInMSh5kIvSy/+s
	89VvCZo9cm5HpIbmsmUjkDgDZuoKfkU/HwWqe3VmYNXil9cb5ra961Vv7g1VvJnS7xzfhHDfD71
	W8r2wvhaQI7a/I5QyLligkBibyOpYPiVF8MP9LHoGzFBNYHtYo8GH0THxs2DyOKYG3gUwmpyar3
	hk/6tNM9uk/fYMkieoLQRQildZP88S7e25yCkRyTnKobmTlhVr+7ZuzwF0KWBjwNKnXfdp5itvw
	eLKufl9AdDB7i/8pJoY6b1aZiiK/NZdxZT9ULizUnV73H/ugaMXRWAqZjvtvNCAbub8bhzdEnX3
	IA5dVnOXCkJ06
X-Google-Smtp-Source: AGHT+IHqoB80XkpSQPer1Ybe2qKMEe9hTqpnQTlMttk3wKgoqoID3B7xzsZrRedXZs1Je32TrSlzmA==
X-Received: by 2002:a5d:588f:0:b0:391:1806:e23d with SMTP id ffacd0b85a97d-39132d7a3b6mr5996316f8f.6.1741565698246;
        Sun, 09 Mar 2025 17:14:58 -0700 (PDT)
Received: from [192.168.69.199] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3912c102b62sm12960568f8f.84.2025.03.09.17.14.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 Mar 2025 17:14:56 -0700 (PDT)
Message-ID: <440fe370-a0d3-4a32-97e2-e5f219f79933@linaro.org>
Date: Mon, 10 Mar 2025 01:14:55 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/7] hw/hyperv: remove duplication compilation units
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>,
 "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 alex.bennee@linaro.org, qemu-devel@nongnu.org,
 Marcelo Tosatti <mtosatti@redhat.com>, richard.henderson@linaro.org,
 manos.pitsidianakis@linaro.org
References: <20250307215623.524987-1-pierrick.bouvier@linaro.org>
 <8c511d16-05d6-4852-86fc-a3be993557c7@linaro.org>
 <8d2a19a8-e0a4-4050-8ba5-9baa9b47782f@maciej.szmigiero.name>
 <91ddf98c-3a5d-404b-9e80-ed4580c1c373@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <91ddf98c-3a5d-404b-9e80-ed4580c1c373@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/3/25 00:33, Pierrick Bouvier wrote:
> Hi Maciej,
> 
> On 3/7/25 14:31, Maciej S. Szmigiero wrote:
>> Hi Philippe,
>>
>> On 7.03.2025 23:25, Philippe Mathieu-Daudé wrote:
>>> Hi Maciej,
>>>
>>> On 7/3/25 22:56, Pierrick Bouvier wrote:
>>>> Work towards having a single binary, by removing duplicated object 
>>>> files.
>>>
>>>> Pierrick Bouvier (7):
>>>>     hw/hyperv/hv-balloon-stub: common compilation unit
>>>>     hw/hyperv/hyperv.h: header cleanup
>>>>     hw/hyperv/vmbus: common compilation unit
>>>>     hw/hyperv/hyperv-proto: move SYNDBG definition from target/i386
>>>>     hw/hyperv/syndbg: common compilation unit
>>>>     hw/hyperv/balloon: common balloon compilation units
>>>>     hw/hyperv/hyperv_testdev: common compilation unit
>>>
>>> If you are happy with this series and provide your Ack-by tag,
>>> I can take it in my next hw-misc pull request if that helps.
>>
>> There's nothing obviously wrong in the patch set,
>> but if we can defer this to Monday then I could do
>> a runtime check with a Windows VM too.
>>
> 
> this series needs some fixup after the merge of 58d0053: include/exec: 
> Move TARGET_PAGE_{SIZE,MASK,BITS} to target_page.h.
> 
> I'll re-spin it later, so don't waste your time trying it.

1, 2 & 4 are not affected. Until someone object, I plan to include them
in my next hw-misc pull request on Tuesday.

