Return-Path: <kvm+bounces-9950-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CF50867EBE
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 18:38:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 13F1E286B69
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 17:38:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6468B12F383;
	Mon, 26 Feb 2024 17:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Y4JyJZBX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 947D81292FF
	for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 17:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708969048; cv=none; b=ncM6MazLn/e81rebn8lYo1ZsUX2du61kJBrsum/Jk5qHZ+V93sI0a4a2bf5kVW7iQs3bk1py7aPTg90sGNmRHmCc9gxju64mwNmReF8kw1SORt0Mj6Ze/mA9sNl6VvPpcQD5EhSzUJvZu6KyBy6TXxtE/R/n5q3a8QcoTSpmD90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708969048; c=relaxed/simple;
	bh=qruZYQ8U3OtRKaG5ahQ+XCEbOjNKS/W5Vtc1DQ+jG24=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QuuS0eSFnDnAW+toPrBTLozpXI6SMWiAI/PZgOfbTfb0rek7qaUb70APDHpsX82/tZ2ym+79mgA8gk7GRk5aW1jm+lUszb6joySezXQNFOl4n+G5+gSqGaJ5XCWGraaEb34ceAU8UFVwJtaIGKFhkyIgAkM5TmjqmPPWRHi2Wkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Y4JyJZBX; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-563bb51c36eso3530755a12.2
        for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 09:37:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1708969045; x=1709573845; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=m77qrk6Qff2gXkBKjtrp1WyNIuR8YB6oHKyVJarj7i0=;
        b=Y4JyJZBX3NTxUZo1Imeoyv50uBcMl0H5LVjUmiqAjBK2e69yE1Ys7uLZvGnhOvAOft
         Q7sP1AloTvNZdBg1ARlsRrB6+zaRuPs63LaTiottNjCckTKogOIAcwj7phTFAmRsti8E
         MzUieQ48jGyqASNY8JNVhgLJwjFUIXUo+ZsN4aM4t0ckdLZI0Tw2oH8MvGfOkVZ9QymD
         b/i1IpGBtfuuVa18eoJOVYYyOTsLks8V99cbPSxGsBEQuhcejHPsnEbecL4IQRxFvv9I
         SxYF/YOo0mnPL7gO0PyAU4ggQjuDNXux33bIN7GqAnTUUJ+tmGRvoLejL2dNTQ+E6iA7
         PE/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708969045; x=1709573845;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=m77qrk6Qff2gXkBKjtrp1WyNIuR8YB6oHKyVJarj7i0=;
        b=PJ61IpF7vJTM7ciO6Jj7FEOrU1eYnOt66v7gUaN0wNirteuXyncw6cYwJT0//3CUho
         wpYpCRT7coO3B6CPVBa/07Q4VfjS392wMzd3nAdpu7PHrD7GFTJDvOU4EgGXAvlvfZiD
         cUewON5uDDnywTI1bJjA7yQHCpUsRXrUJyzSqL/k6KOHR1WEb7SY6100OFjOjgQv6jvF
         PWFsgnF7Bjlf3QNU5emlkg95RJFTjB07QpCm4TACg3TY2M0v/C1J1aHghZW631Zqzw0I
         7saGX0xazqkRTagtwljiHe6SJyf1GAjhyENB0DhefqFeyzeKgv+dAOr2fA+tbUEq5092
         hoqQ==
X-Forwarded-Encrypted: i=1; AJvYcCWMPo2Spf7DkPOeyxfWXKj1T0DbEGG69t2VusuzTl8xG4EIPglEAv8ODRgXsCBaP2OKMJ5UMV0eeGPUYL6bp57KOwld
X-Gm-Message-State: AOJu0YxRDb+y/s/dpB6doNYt6cgf2xWntHSbDEpMywdF4mVNyUuY+WyN
	o+mreKGMWZ3SP6TOZW+GZ566k9TMuMUB2FzEyhu37Z3zDHmzg8DofoyetclfX04=
X-Google-Smtp-Source: AGHT+IFGXBzF4RsP0r6hOzWjx6NVz650C+MO/PSYTkFPWzBZc890v54JFq4zQgLJPt1QZPAaUVEEHQ==
X-Received: by 2002:a17:906:1b4a:b0:a43:4675:631b with SMTP id p10-20020a1709061b4a00b00a434675631bmr2299525ejg.49.1708969044848;
        Mon, 26 Feb 2024 09:37:24 -0800 (PST)
Received: from [192.168.69.100] ([176.187.223.153])
        by smtp.gmail.com with ESMTPSA id d25-20020a170906305900b00a3eb1b1896bsm2579408ejd.58.2024.02.26.09.37.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Feb 2024 09:37:24 -0800 (PST)
Message-ID: <c5d5f835-5b7f-46bb-8393-6d638cbad012@linaro.org>
Date: Mon, 26 Feb 2024 18:37:21 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/6] hw/arm: Inline sysbus_create_simple(PL110 / PL111)
Content-Language: en-US
To: BALATON Zoltan <balaton@eik.bme.hu>,
 Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>
Cc: Peter Maydell <peter.maydell@linaro.org>, qemu-devel@nongnu.org,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Eduardo Habkost <eduardo@habkost.net>, qemu-arm@nongnu.org,
 kvm@vger.kernel.org, Igor Mitsyanko <i.mitsyanko@gmail.com>,
 "Michael S. Tsirkin" <mst@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Markus Armbruster <armbru@redhat.com>,
 Manos Pitsidianakis <manos.pitsidianakis@linaro.org>
References: <20240216153517.49422-1-philmd@linaro.org>
 <20240216153517.49422-2-philmd@linaro.org>
 <bcfd3f9d-04e3-79c9-c15f-c3c8d7669bdb@eik.bme.hu>
 <2f8ec2e2-c4c7-48c3-9c3d-3e20bc3d6b9b@linaro.org>
 <b40fd79f-4d41-4e04-90c1-6f4b2fde811d@linaro.org>
 <00e2b898-3c5f-d19c-fddc-e657306e071f@eik.bme.hu>
 <2b9ea923-c4f9-4ee4-8ed2-ba9f62c15579@linaro.org>
 <6b5758d6-f464-2461-f9dd-71d2e15b610a@eik.bme.hu>
 <bc5929e4-1782-4719-8231-fe04a9719c40@ilande.co.uk>
 <CAFEAcA-Mvd4NVY2yDgNEdjZ_YPrN93PDZRyfCi7JyCjmPs4gAQ@mail.gmail.com>
 <0a31f410-415d-474b-bcea-9cb18f41aeb2@ilande.co.uk>
 <9ef2075b-b26b-41d2-a7d0-456cec3b104a@eik.bme.hu>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <9ef2075b-b26b-41d2-a7d0-456cec3b104a@eik.bme.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 19/2/24 15:05, BALATON Zoltan wrote:
> On Mon, 19 Feb 2024, Mark Cave-Ayland wrote:
>> On 19/02/2024 13:05, Peter Maydell wrote:
>>> On Mon, 19 Feb 2024 at 12:49, Mark Cave-Ayland
>>> <mark.cave-ayland@ilande.co.uk> wrote:
>>>>
>>>> On 19/02/2024 12:00, BALATON Zoltan wrote:
>>>>> For new people trying to contribute to QEMU QDev is overwhelming so 
>>>>> having some way
>>>>> to need less of it to do simple things would help them to get started.
>>>>
>>>> It depends what how you define "simple": for QEMU developers most 
>>>> people search for
>>>> similar examples in the codebase and copy/paste them. I'd much 
>>>> rather have a slightly
>>>> longer, but consistent API for setting properties rather than coming 
>>>> up with many
>>>> special case wrappers that need to be maintained just to keep the 
>>>> line count down for
>>>> "simplicity".
>>>>
>>>> I think that Phil's approach here is the best one for now, 
>>>> particularly given that it
>>>> allows us to take another step towards heterogeneous machines. As 
>>>> the work in this
>>>> area matures it might be that we can consider other approaches, but 
>>>> that's not a
>>>> decision that can be made right now and so shouldn't be a reason to 
>>>> block this change.
>>>
>>> Mmm. It's unfortunate that we're working with C, so we're a bit limited
>>> in what tools we have to try to make a better and lower-boilerplate
>>> interface for the "create, configure, realize and wire up devices" task.
>>> (I think you could do much better in a higher level language...)
>>> sysbus_create_simple() was handy at the time, but it doesn't work so
>>> well for more complicated SoC-based boards. It's noticeable that
>>> if you look at the code that uses it, it's almost entirely the older
>>> and less maintained board models, especially those which don't actually
>>> model an SoC and just have the board code create all the devices.
>>
>> Yeah I was thinking that you'd use the DSL (e.g. YAML templates or 
>> similar) to provide some of the boilerplating around common actions, 
>> rather than the C API itself. Even better, once everything has been 
>> moved to use a DSL then the C API shouldn't really matter so much as 
>> it is no longer directly exposed to the user.
> 
> That may be a few more releases away (although Philippe is doing an 
> excellent job with doing this all alone and as efficient as he is it 
> might be reached sooner). So I think board code will stay for a while 
> therefore if something can be done to keep it simple with not much work 
> then maybe that's worth considering. That's why I did not propose to 
> keep sysbus_create_simple and add properties to it because that might 
> need something like a properties array with values that's hard to 
> describe in C so it would be a bit more involved to implement and 
> defining such arrays would only make it a litle less cluttered. So just 
> keeping the parts that work for simple devices in sysbus_realize_simple 
> and also keep sysbus_create_simple where it's already used is probably 
> enough now rather than converting those to low level calls everywhere now.
> 
> Then we'll see how well the declarative machines will turn out and then 
> if we no longer need to write board code these wrappers could go away 
> then but for now it may be too early when we still have a lot of board 
> code to maintain.

I'll keep forward with this patch inlining sysbus_create_simple();
if we notice in few releases the DSL experiment is a failure, I don't
mind going back reverting it.

Regards,

Phil.

