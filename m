Return-Path: <kvm+bounces-9043-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A4E5859E90
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 09:39:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9F30A1C21D00
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 08:39:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10C6D21A1C;
	Mon, 19 Feb 2024 08:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RDEiNksv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71DA021362
	for <kvm@vger.kernel.org>; Mon, 19 Feb 2024 08:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708331956; cv=none; b=cuYIMwRbqxgsZIliwaP8MP+7UyhLuCGNBmAmBJI0a6JgJ9V6YuNVJqXnMBX75IrawN/Wv/LmgcahThh88SH42emIhqry7CsiLN+7FRs74WcHDmIPORB6A4MpdBcEX0jt5lwhxZjsGynKbTw1hMaHICm/30DYdCzsd3haXnZ2qO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708331956; c=relaxed/simple;
	bh=A3xd3HuCyyZaK0uqA6PRWXE2toVSmHjxUzOhRICX9bM=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=do1xUV2WChGYudhGFd2inMshprX9D4f/Gg2Y2WLmmYqXhQOnH1yvkkuZeu/MZbnlGaKQNX7b4NT468VYKhFOSSlVtLDyvt+W7XFfb5+XuQMnGCnhT41uwlS6H1qk9X5y+kgo5u4qIw90bjyFGw0a9+Ai9umb04dU4e5GCHU4hIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=RDEiNksv; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-412698cdd77so1020345e9.1
        for <kvm@vger.kernel.org>; Mon, 19 Feb 2024 00:39:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1708331953; x=1708936753; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CYXFroxxpCnwAYN1gM2WM91eHQq25PtJZrWxJ2nunuU=;
        b=RDEiNksv8bQFmkMq9lKEVRl1ydmZX6r5/9pJHS80PDCwUv5+BtHTwjkcFeswl3DbbV
         4UUBn4F0WF7xyp+n2IBpt7OS0vrrK+ni3XQa5uCDG/c3+9lBTXcaLXlO7buAWLuzTa7F
         /ABQfVti4RZNXX/E1XVDZvxsjDN6GWtNPb4tC2b/zUl5KXanEAIMZgm/OphWIGsQ4hX4
         zWCTOLB9df0Pa3OSFcn685v865WdQ8hgQz6OzRrhS9HIBwxC5EvmkzL074Ekuaxx9Voo
         hpMXEUCXySNaBiObCq6u/hPCqw5snTU+Fgs+jxJDFBK01Cc2iSawhm8h3EQAWwn6thcK
         1ovg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708331953; x=1708936753;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CYXFroxxpCnwAYN1gM2WM91eHQq25PtJZrWxJ2nunuU=;
        b=UFZFQ8Al2WBKt4EfBEMd8Gra6pxgGkrirsqYZ0iZCfvtaJniMa2rbj9GdBjvtxBc/N
         ybbHXsphbWVMtgfYKOws7bvDW8fV3ezDrOPY7vjUJZFOIvk+dn0+6UG0dKp3LocwIBbx
         IniD8xJC35xsBTQeLTxLg0kApMjZocxRVosRmE4B4z8Rkni46DUfGn53NzckTECETJ/m
         5+U2Dd8xQ2XWWS327Fgd0wXasf1VuwwQyiZW3nnXOU/Y/tMTcwEQMlElcy5jqOSuyHvU
         lUItqljUnGKIAFzLabpVupJdqxRqN4cxwDK1NRuudbbHibb3Qdg5+3RCgOewfwGiiGVF
         UPpQ==
X-Forwarded-Encrypted: i=1; AJvYcCWaKuoGWS5u0kmva5Ab0xDDtdvNHkfdQDtwHCUBqQ616/rZsEgOSaVLKjXxNC7yEsrhKUkU6ViiXR4wUUD9A78m/P7i
X-Gm-Message-State: AOJu0YyyRq5ZZli0MuIEYfUi27mi/V+9gc+eAD6Uu8uA9eypKN7dohC6
	fZGU7tTFarasUHXldAj9APOUaFqoW9y7EwafQGaAJzSY2rdZ0i019x119yx/I6w=
X-Google-Smtp-Source: AGHT+IHHZHE2hxZImjTjtz52BTCa19x73B+ifItIOGXblR1mvSpW7ADOmJuk9lMf8fB3r9j7LKBDzQ==
X-Received: by 2002:a05:600c:3591:b0:412:41:bb3d with SMTP id p17-20020a05600c359100b004120041bb3dmr9611111wmq.3.1708331952833;
        Mon, 19 Feb 2024 00:39:12 -0800 (PST)
Received: from [192.168.69.100] ([176.176.181.220])
        by smtp.gmail.com with ESMTPSA id w3-20020a05600c014300b0040fccf7e8easm10567009wmm.36.2024.02.19.00.39.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Feb 2024 00:39:12 -0800 (PST)
Message-ID: <b40fd79f-4d41-4e04-90c1-6f4b2fde811d@linaro.org>
Date: Mon, 19 Feb 2024 09:39:10 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/6] hw/arm: Inline sysbus_create_simple(PL110 / PL111)
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
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
In-Reply-To: <2f8ec2e2-c4c7-48c3-9c3d-3e20bc3d6b9b@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 16/2/24 20:54, Philippe Mathieu-Daudé wrote:
> On 16/2/24 18:14, BALATON Zoltan wrote:
>> On Fri, 16 Feb 2024, Philippe Mathieu-Daudé wrote:
>>> We want to set another qdev property (a link) for the pl110
>>> and pl111 devices, we can not use sysbus_create_simple() which
>>> only passes sysbus base address and IRQs as arguments. Inline
>>> it so we can set the link property in the next commit.
>>>
>>> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
>>> ---
>>> hw/arm/realview.c    |  5 ++++-
>>> hw/arm/versatilepb.c |  6 +++++-
>>> hw/arm/vexpress.c    | 10 ++++++++--
>>> 3 files changed, 17 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/hw/arm/realview.c b/hw/arm/realview.c
>>> index 9058f5b414..77300e92e5 100644
>>> --- a/hw/arm/realview.c
>>> +++ b/hw/arm/realview.c
>>> @@ -238,7 +238,10 @@ static void realview_init(MachineState *machine,
>>>     sysbus_create_simple("pl061", 0x10014000, pic[7]);
>>>     gpio2 = sysbus_create_simple("pl061", 0x10015000, pic[8]);
>>>
>>> -    sysbus_create_simple("pl111", 0x10020000, pic[23]);
>>> +    dev = qdev_new("pl111");
>>> +    sysbus_realize_and_unref(SYS_BUS_DEVICE(dev), &error_fatal);
>>> +    sysbus_mmio_map(SYS_BUS_DEVICE(dev), 0, 0x10020000);
>>> +    sysbus_connect_irq(SYS_BUS_DEVICE(dev), 0, pic[23]);
>>
>> Not directly related to this patch but this blows up 1 line into 4 
>> just to allow setting a property. Maybe just to keep some simplicity 
>> we'd rather need either a sysbus_realize_simple function that takes a 
>> sysbus device instead of the name and does not create the device 
>> itself or some way to pass properties to sysbus create simple (but the 
>> latter may not be easy to do in a generic way so not sure about that). 
>> What do you think?
> 
> Unfortunately sysbus doesn't scale in heterogeneous setup.

Regarding the HW modelling API complexity you are pointing at, we'd
like to move from the current imperative programming paradigm to a
declarative one, likely DSL driven. Meanwhile it is being investigated
(as part of "Dynamic Machine"), I'm trying to get the HW APIs right
for heterogeneous emulation. Current price to pay is a verbose
imperative QDev API, hoping we'll get later a trivial declarative one
(like this single sysbus_create_simple call), where we shouldn't worry
about the order of low level calls, whether to use link or not, etc.

For the big list of issues we are trying to improve, see:
https://lore.kernel.org/qemu-devel/87o7d1i7ky.fsf@pond.sub.org/

