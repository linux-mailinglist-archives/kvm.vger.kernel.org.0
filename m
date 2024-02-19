Return-Path: <kvm+bounces-9077-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B92F585A37E
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 13:34:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 465FF1F21793
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 12:34:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A77236120;
	Mon, 19 Feb 2024 12:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Lcg2IGo5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BD4E3610A
	for <kvm@vger.kernel.org>; Mon, 19 Feb 2024 12:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708346025; cv=none; b=a9Ca+/JLYQEH7ggKhh/d0yslomHtLLQ0y1LkbND6HwdUycZj7dpugoswpl7BFNQv8km/ZfhLBhjRVXPktllJwQDXz7ctmt3Msu/aPs2reRtgsrzKIsU+tnlBxb9Rt8SenEVlrMkwbUfqT9qFHX8Ejnab+gA7dN/ECIKPIyFHiAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708346025; c=relaxed/simple;
	bh=AlFqNm7b4kuuOpo4ofobQ7csV1OLlbMaCgtohJG4R48=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mw6hb/PSrBeogy0XVZAV44WM+zhYOsl7UAm+v3rPnF4lOTkKXgxGIfBH41y31bUYm6TqgcUUOKk+f/YRNd37qeWDcxMRDmjH23wrsPoOKVIKvlL7AfKrJVERRrfJQNHh569kL5FWtU+/PkPx2t0m3Mbz7ddTY3hKueDnjVYCSXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Lcg2IGo5; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a3e4765c86eso180889066b.0
        for <kvm@vger.kernel.org>; Mon, 19 Feb 2024 04:33:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1708346022; x=1708950822; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=S4E0yzAO2ngkn+tDnZ9rriKrakxyWrEzizN7ZdrHINY=;
        b=Lcg2IGo5wpWic/8YOYhlr6SEDlTOwXNTV7oiMDgW4GzGlXGLQnP7Jbd/hcy7diL6Eh
         pnE1K89EXKZn9reZUP5Qr7BrNsIV+IBON7czS/blU97C/wagh2UpknLk8KiTi7iBPQGv
         I0AQWlRHZjFIal+nlw2PSyBonP/Ro9bzzPwpg4FM7/DbjoC2ZugtRA5MLSb0Rnzef3RD
         A6T3O+RVLvLrf4UMQRoRU86kJZQ8WNC7nYsGbs7mshO5xbucgBbsVNgLJLbkvpMwlIIF
         cqBrCdfQVYoC0ZFdVOSvv3voFAf19kBtZdq2CW371YVn50MX/Mzn9VEMrwodZk+H8WOM
         NvYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708346022; x=1708950822;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S4E0yzAO2ngkn+tDnZ9rriKrakxyWrEzizN7ZdrHINY=;
        b=Y61EHmxEw4CEqNLxEsVwc8ABPzCtIZS3A60M2q0uow1b9bU8aZ2UitNtAXmpJf6ggd
         Pfi4EyE9vj8Cwnf0mfDPpuIVOzO0cV0uSkVJ1FAUNOqntmdWpJNcViWz3T36cYZhhyxy
         VWfhLnF3b8/Q+jBxRcGW+z+dEnm+vhxqSG1oinxt/JZCC7aJiRtllxUxX8BLQvEl61dd
         tNqoSW5ZMyQMF/HD9o3zwseJPzOGR4rTS2X2WF1w7QSC0V9x9FPSRPCou8905ytzspzL
         PI+KHtfTYNx050/ygznnCdsKbAdbiLccG38fLuHgY76uLQOJgHAR/vBGbAqdvhGtZG3X
         xzrA==
X-Forwarded-Encrypted: i=1; AJvYcCWw8f38vSzGCxm+CncWZFK0TJSr5afNSrwUtT3QFd9oDGIkwAdEO77Mi994w3X8ZNDc/YCA9yIBGNWhsV9rAo6yqW9B
X-Gm-Message-State: AOJu0YyTPR0ypDqTmuoTAHn1E+awR1iYI/MCkQBYrW7LnywqAT8LAovu
	UY8XOseK78bupGk5CDkjUQy/POwiPCGxgTQKMXFAquXMB/l0nraS+FjBPakaxOA=
X-Google-Smtp-Source: AGHT+IEIaylrIhF+CRfrKdhZa5ZKgIDOjz22A/+79B7ak6gyCIon7CfN6oUMPmG/6W/Z2hop7Lqm9g==
X-Received: by 2002:a17:906:f1c5:b0:a3e:5d06:be57 with SMTP id gx5-20020a170906f1c500b00a3e5d06be57mr2978095ejb.41.1708346021695;
        Mon, 19 Feb 2024 04:33:41 -0800 (PST)
Received: from [192.168.69.100] ([176.176.181.220])
        by smtp.gmail.com with ESMTPSA id s8-20020a170906500800b00a3de4c7bf00sm2903610ejj.79.2024.02.19.04.33.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Feb 2024 04:33:41 -0800 (PST)
Message-ID: <e3c5dc3f-8e66-4e69-86c0-89e35a8a6b8e@linaro.org>
Date: Mon, 19 Feb 2024 13:33:38 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/6] hw/arm: Inline sysbus_create_simple(PL110 / PL111)
Content-Language: en-US
To: BALATON Zoltan <balaton@eik.bme.hu>
Cc: qemu-devel@nongnu.org, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, Eduardo Habkost <eduardo@habkost.net>,
 qemu-arm@nongnu.org, kvm@vger.kernel.org,
 Peter Maydell <peter.maydell@linaro.org>,
 Igor Mitsyanko <i.mitsyanko@gmail.com>, "Michael S. Tsirkin"
 <mst@redhat.com>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
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
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <6b5758d6-f464-2461-f9dd-71d2e15b610a@eik.bme.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 19/2/24 13:00, BALATON Zoltan wrote:
> On Mon, 19 Feb 2024, Philippe Mathieu-Daudé wrote:
>> On 19/2/24 12:27, BALATON Zoltan wrote:
>>> On Mon, 19 Feb 2024, Philippe Mathieu-Daudé wrote:
>>>> On 16/2/24 20:54, Philippe Mathieu-Daudé wrote:
>>>>> On 16/2/24 18:14, BALATON Zoltan wrote:
>>>>>> On Fri, 16 Feb 2024, Philippe Mathieu-Daudé wrote:
>>>>>>> We want to set another qdev property (a link) for the pl110
>>>>>>> and pl111 devices, we can not use sysbus_create_simple() which
>>>>>>> only passes sysbus base address and IRQs as arguments. Inline
>>>>>>> it so we can set the link property in the next commit.
>>>>>>>
>>>>>>> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
>>>>>>> ---
>>>>>>> hw/arm/realview.c    |  5 ++++-
>>>>>>> hw/arm/versatilepb.c |  6 +++++-
>>>>>>> hw/arm/vexpress.c    | 10 ++++++++--
>>>>>>> 3 files changed, 17 insertions(+), 4 deletions(-)
>>>>>>>
>>>>>>> diff --git a/hw/arm/realview.c b/hw/arm/realview.c
>>>>>>> index 9058f5b414..77300e92e5 100644
>>>>>>> --- a/hw/arm/realview.c
>>>>>>> +++ b/hw/arm/realview.c
>>>>>>> @@ -238,7 +238,10 @@ static void realview_init(MachineState 
>>>>>>> *machine,
>>>>>>>     sysbus_create_simple("pl061", 0x10014000, pic[7]);
>>>>>>>     gpio2 = sysbus_create_simple("pl061", 0x10015000, pic[8]);
>>>>>>>
>>>>>>> -    sysbus_create_simple("pl111", 0x10020000, pic[23]);
>>>>>>> +    dev = qdev_new("pl111");
>>>>>>> +    sysbus_realize_and_unref(SYS_BUS_DEVICE(dev), &error_fatal);
>>>>>>> +    sysbus_mmio_map(SYS_BUS_DEVICE(dev), 0, 0x10020000);
>>>>>>> +    sysbus_connect_irq(SYS_BUS_DEVICE(dev), 0, pic[23]);
>>>>>>
>>>>>> Not directly related to this patch but this blows up 1 line into 4 
>>>>>> just to allow setting a property. Maybe just to keep some 
>>>>>> simplicity we'd rather need either a sysbus_realize_simple 
>>>>>> function that takes a sysbus device instead of the name and does 
>>>>>> not create the device itself or some way to pass properties to 
>>>>>> sysbus create simple (but the latter may not be easy to do in a 
>>>>>> generic way so not sure about that). What do you think?
>>>>>
>>>>> Unfortunately sysbus doesn't scale in heterogeneous setup.
>>>>
>>>> Regarding the HW modelling API complexity you are pointing at, we'd
>>>> like to move from the current imperative programming paradigm to a
>>>> declarative one, likely DSL driven. Meanwhile it is being investigated
>>>> (as part of "Dynamic Machine"), I'm trying to get the HW APIs right
>>>
>>> I'm aware of that activity but we're currently still using board code 
>>> to construct machines and probably will continue to do so for a 
>>> while. Also because likely not all current machines will be converted 
>>> to new declarative way so having a convenient API for that is still 
>>> useful.
>>>
>>> (As for the language to describe the devices of a machine and their 
>>> connections declaratively the device tree does just that but dts is 
>>> not a very user friendly descrtiption language so I haven't brought 
>>> that up as a possibility. But you may still could get some clues by 
>>> looking at the problems it had to solve to at least get a 
>>> requirements for the machine description language.)
>>>
>>>> for heterogeneous emulation. Current price to pay is a verbose
>>>> imperative QDev API, hoping we'll get later a trivial declarative one
>>>> (like this single sysbus_create_simple call), where we shouldn't worry
>>>> about the order of low level calls, whether to use link or not, etc.
>>>
>>> Having a detailed low level API does not prevent a more convenient 
>>> for current use higher level API on top so keeping that around for 
>>> current machines would allow you to chnage the low level API without 
>>> having to change all the board codes because you's only need to 
>>> update the simple high level API.
>>
>> So what is your suggestion here, add a new complex helper to keep
>> a one-line style?
>>
>> DeviceState *sysbus_create_simple_dma_link(const char *typename,
>>                                           hwaddr baseaddr,
>>                                           const char *linkname,
>>                                           Object *linkobj,
>>                                           qemu_irq irq);
> 
> I think just having sysbus_realize_simple that does the same as 
> sysbus_create_simple minus creating the device would be enough because 
> then the cases where you need to set properties could still use it after 
> qdev_new or init and property_set but hide the realize and connecting 
> the device behind this single call.

So you suggest splitting sysbus_create_simple() as
sysbus_create_simple() + sysbus_realize_simple(), so we can set
properties between the 2 calls? IOW extract qdev_new() from
sysbus_create_varargs() and rename it as sysbus_realize_simple()?

So we need a massive refactoring of:

- dev = sysbus_create_simple(typename, addr, irq);
+ dev = qdev_new(typename);
+ // optionally set properties
+ sysbus_realize_simple(dev, addr, irq);

- dev = sysbus_create_varargs(typename, addr, irqA, irqB, ...);
+ dev = qdev_new(typename);
+ // optionally set properties
+ sysbus_realize_varargs(dev, addr, irqA, irqB, ...);

I'm not sure it is worth it because we want to move away from
sysbus, merging the non-sysbus specific API to qdev (like indexed
memory regions and IRQs to named ones).

>> I wonder why this is that important since you never modified
>> any of the files changed by this series:
> 
> For new people trying to contribute to QEMU QDev is overwhelming so 
> having some way to need less of it to do simple things would help them 
> to get started.
> 
> Regards,
> BALATON Zoltan


