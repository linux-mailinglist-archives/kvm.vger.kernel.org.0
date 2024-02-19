Return-Path: <kvm+bounces-9085-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E20A385A4A9
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 14:30:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6EAB61F246C5
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 13:30:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 877F23613D;
	Mon, 19 Feb 2024 13:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (4096-bit key) header.d=ilande.co.uk header.i=@ilande.co.uk header.b="fqsWckxX"
X-Original-To: kvm@vger.kernel.org
Received: from mail.ilande.co.uk (mail.ilande.co.uk [46.43.2.167])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABBDC36132
	for <kvm@vger.kernel.org>; Mon, 19 Feb 2024 13:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.43.2.167
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708349422; cv=none; b=BPvG9qAguSshr9P6xShYtqPZnDZQGVPNlzgEk5dJMPJsqghN6ptXm75NSLhNf7mxUgAN5zhF+y3tFC+OX6Q+B2Rjc/PTGS/WFWiIrycJXXumZH9FKa7YxZIqUSl+6dDqRLpUCCpDzxb2xSr26H4FAqixAwHYKvvab41C8BCIgnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708349422; c=relaxed/simple;
	bh=wDC1UCUBFwkABIpo/gcZO2G3dhDq2Nn7bsH4/ZOsJTQ=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:From:In-Reply-To:
	 Content-Type:Subject; b=QffBG55NfeBtlgGkfCLt5Hh9zaII9aqTn+3KfSWdc5hbZ51cN9ykRQLUmpSyj8EBJHbYf2d1/RSyv3nx1gRCpY++dEfdqM6zCsSc6BAleOf2aiucyPX+XGv9SboGpZLboLdOA5Xw6if8klxzoIKn5s0tNGJIGdx6SHvBJO3jHFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ilande.co.uk; spf=pass smtp.mailfrom=ilande.co.uk; dkim=pass (4096-bit key) header.d=ilande.co.uk header.i=@ilande.co.uk header.b=fqsWckxX; arc=none smtp.client-ip=46.43.2.167
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ilande.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ilande.co.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=ilande.co.uk; s=20220518; h=Subject:Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:MIME-Version:Date:Message-ID:Sender:
	Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender
	:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=oJGPiRT63+hXY9RNoSTiKodQ4PAZPM7uwa2SnQiaCP0=; b=fqsWckxXc/rbC1kgLWQQkiTbzP
	5sDtVVh0r3Dqkzm+K8VfKkr3s2fA0LZqARTLvG3Ly2TU9mDTCWZROFkY2/0CLBKHIlc1/RlNjtxgr
	liss5BU3Y041/fu64MRiZQE6tMElUnOPgBGO/KXfsfPq3TWPlh9wWTqZrGG55B4RKIAA2Bi3XXrYu
	gKlOUdvdD2TVThvtt4BvzGcEayqtWW6AvqTfDS0yR1loqcDTmtoaQ0plYY0HZEBg95cPqp5wtKprh
	jSZVaxNFlk9edr2OtfgjtneacxLuqJUG+gBwdt0IBf/hY0DaOzotOaZtK3SejKf49BwXz3ZTtKSJi
	7o7p+WGTNLPZ0WN5efQzVlh3z5x19iFMfeF0v2P5eIm5rHXk8Ek+zN5lwmAVuQ2+rnNWbMvNqlFH/
	YcJsSvOR9lcbrg103ymUJ6+0AZmGkLRD+2+jLso15g3R518sw3JJSs8LbJH5Zs8MTVVp2xPwzBnS7
	EJusgBDb+TbvZJWUY+2OuwITfHPd94cKcUeKvkBE2k4+lgA4AudTnELKA9dGs1GJITAvvtMfI0Kh6
	ALYo9VbpSW0fKsIYuXojoVeAZ7jRJNPzJZxZgWPOMgG8s/9fhImGkMz1IEXWYIALfJkuIGQDaIDwS
	JjZKPf+RNn0DIDhLs5gi7G6OsXXKADnlKU8P54ziM=;
Received: from [2a02:8012:c93d:0:260e:bf57:a4e9:8142]
	by mail.ilande.co.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
	(Exim 4.92)
	(envelope-from <mark.cave-ayland@ilande.co.uk>)
	id 1rc345-0001rZ-KD; Mon, 19 Feb 2024 12:48:13 +0000
Message-ID: <bc5929e4-1782-4719-8231-fe04a9719c40@ilande.co.uk>
Date: Mon, 19 Feb 2024 12:48:48 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: BALATON Zoltan <balaton@eik.bme.hu>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
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
Content-Language: en-US
From: Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>
Autocrypt: addr=mark.cave-ayland@ilande.co.uk; keydata=
 xsBNBFQJuzwBCADAYvxrwUh1p/PvUlNFwKosVtVHHplgWi5p29t58QlOUkceZG0DBYSNqk93
 3JzBTbtd4JfFcSupo6MNNOrCzdCbCjZ64ik8ycaUOSzK2tKbeQLEXzXoaDL1Y7vuVO7nL9bG
 E5Ru3wkhCFc7SkoypIoAUqz8EtiB6T89/D9TDEyjdXUacc53R5gu8wEWiMg5MQQuGwzbQy9n
 PFI+mXC7AaEUqBVc2lBQVpAYXkN0EyqNNT12UfDLdxaxaFpUAE2pCa2LTyo5vn5hEW+i3VdN
 PkmjyPvL6DdY03fvC01PyY8zaw+UI94QqjlrDisHpUH40IUPpC/NB0LwzL2aQOMkzT2NABEB
 AAHNME1hcmsgQ2F2ZS1BeWxhbmQgPG1hcmsuY2F2ZS1heWxhbmRAaWxhbmRlLmNvLnVrPsLA
 eAQTAQIAIgUCVAm7PAIbAwYLCQgHAwIGFQgCCQoLBBYCAwECHgECF4AACgkQW8LFb64PMh9f
 NAgAuc3ObOEY8NbZko72AGrg2tWKdybcMVITxmcor4hb9155o/OWcA4IDbeATR6cfiDL/oxU
 mcmtXVgPqOwtW3NYAKr5g/FrZZ3uluQ2mtNYAyTFeALy8YF7N3yhs7LOcpbFP7tEbkSzoXNG
 z8iYMiYtKwttt40WaheWuRs0ZOLbs6yoczZBDhna3Nj0LA3GpeJKlaV03O4umjKJgACP1c/q
 T2Pkg+FCBHHFP454+waqojHp4OCBo6HyK+8I4wJRa9Z0EFqXIu8lTDYoggeX0Xd6bWeCFHK3
 DhD0/Xi/kegSW33unsp8oVcM4kcFxTkpBgj39dB4KwAUznhTJR0zUHf63M7ATQRUCbs8AQgA
 y7kyevA4bpetM/EjtuqQX4U05MBhEz/2SFkX6IaGtTG2NNw5wbcAfhOIuNNBYbw6ExuaJ3um
 2uLseHnudmvN4VSJ5Hfbd8rhqoMmmO71szgT/ZD9MEe2KHzBdmhmhxJdp+zQNivy215j6H27
 14mbC2dia7ktwP1rxPIX1OOfQwPuqlkmYPuVwZP19S4EYnCELOrnJ0m56tZLn5Zj+1jZX9Co
 YbNLMa28qsktYJ4oU4jtn6V79H+/zpERZAHmH40IRXdR3hA+Ye7iC/ZpWzT2VSDlPbGY9Yja
 Sp7w2347L5G+LLbAfaVoejHlfy/msPeehUcuKjAdBLoEhSPYzzdvEQARAQABwsBfBBgBAgAJ
 BQJUCbs8AhsMAAoJEFvCxW+uDzIfabYIAJXmBepHJpvCPiMNEQJNJ2ZSzSjhic84LTMWMbJ+
 opQgr5cb8SPQyyb508fc8b4uD8ejlF/cdbbBNktp3BXsHlO5BrmcABgxSP8HYYNsX0n9kERv
 NMToU0oiBuAaX7O/0K9+BW+3+PGMwiu5ml0cwDqljxfVN0dUBZnQ8kZpLsY+WDrIHmQWjtH+
 Ir6VauZs5Gp25XLrL6bh/SL8aK0BX6y79m5nhfKI1/6qtzHAjtMAjqy8ChPvOqVVVqmGUzFg
 KPsrrIoklWcYHXPyMLj9afispPVR8e0tMKvxzFBWzrWX1mzljbBlnV2n8BIwVXWNbgwpHSsj
 imgcU9TTGC5qd9g=
In-Reply-To: <6b5758d6-f464-2461-f9dd-71d2e15b610a@eik.bme.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a02:8012:c93d:0:260e:bf57:a4e9:8142
X-SA-Exim-Mail-From: mark.cave-ayland@ilande.co.uk
X-Spam-Level: 
Subject: Re: [PATCH 1/6] hw/arm: Inline sysbus_create_simple(PL110 / PL111)
X-SA-Exim-Version: 4.2.1 (built Wed, 08 May 2019 21:11:16 +0000)
X-SA-Exim-Scanned: Yes (on mail.ilande.co.uk)

On 19/02/2024 12:00, BALATON Zoltan wrote:

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
>>>>>>> @@ -238,7 +238,10 @@ static void realview_init(MachineState *machine,
>>>>>>>     sysbus_create_simple("pl061", 0x10014000, pic[7]);
>>>>>>>     gpio2 = sysbus_create_simple("pl061", 0x10015000, pic[8]);
>>>>>>>
>>>>>>> -    sysbus_create_simple("pl111", 0x10020000, pic[23]);
>>>>>>> +    dev = qdev_new("pl111");
>>>>>>> +    sysbus_realize_and_unref(SYS_BUS_DEVICE(dev), &error_fatal);
>>>>>>> +    sysbus_mmio_map(SYS_BUS_DEVICE(dev), 0, 0x10020000);
>>>>>>> +    sysbus_connect_irq(SYS_BUS_DEVICE(dev), 0, pic[23]);
>>>>>>
>>>>>> Not directly related to this patch but this blows up 1 line into 4 just to 
>>>>>> allow setting a property. Maybe just to keep some simplicity we'd rather need 
>>>>>> either a sysbus_realize_simple function that takes a sysbus device instead of 
>>>>>> the name and does not create the device itself or some way to pass properties 
>>>>>> to sysbus create simple (but the latter may not be easy to do in a generic way 
>>>>>> so not sure about that). What do you think?
>>>>>
>>>>> Unfortunately sysbus doesn't scale in heterogeneous setup.
>>>>
>>>> Regarding the HW modelling API complexity you are pointing at, we'd
>>>> like to move from the current imperative programming paradigm to a
>>>> declarative one, likely DSL driven. Meanwhile it is being investigated
>>>> (as part of "Dynamic Machine"), I'm trying to get the HW APIs right
>>>
>>> I'm aware of that activity but we're currently still using board code to construct 
>>> machines and probably will continue to do so for a while. Also because likely not 
>>> all current machines will be converted to new declarative way so having a 
>>> convenient API for that is still useful.
>>>
>>> (As for the language to describe the devices of a machine and their connections 
>>> declaratively the device tree does just that but dts is not a very user friendly 
>>> descrtiption language so I haven't brought that up as a possibility. But you may 
>>> still could get some clues by looking at the problems it had to solve to at least 
>>> get a requirements for the machine description language.)
>>>
>>>> for heterogeneous emulation. Current price to pay is a verbose
>>>> imperative QDev API, hoping we'll get later a trivial declarative one
>>>> (like this single sysbus_create_simple call), where we shouldn't worry
>>>> about the order of low level calls, whether to use link or not, etc.
>>>
>>> Having a detailed low level API does not prevent a more convenient for current use 
>>> higher level API on top so keeping that around for current machines would allow 
>>> you to chnage the low level API without having to change all the board codes 
>>> because you's only need to update the simple high level API.
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
> I think just having sysbus_realize_simple that does the same as sysbus_create_simple 
> minus creating the device would be enough because then the cases where you need to 
> set properties could still use it after qdev_new or init and property_set but hide 
> the realize and connecting the device behind this single call.

I can't say I'm a fan of sysbus_create_simple() because its use of varargs to 
populate qdev properties is based upon the assumptions that the properties defined 
with device_class_set_props() are stored in a list. I can see there could be 
potential in future to store properties in other structures such as a hash, and 
keeping this API would prevent this change. FWIW my personal preference would be to 
remove this API completely.

>> I wonder why this is that important since you never modified
>> any of the files changed by this series:
> 
> For new people trying to contribute to QEMU QDev is overwhelming so having some way 
> to need less of it to do simple things would help them to get started.

It depends what how you define "simple": for QEMU developers most people search for 
similar examples in the codebase and copy/paste them. I'd much rather have a slightly 
longer, but consistent API for setting properties rather than coming up with many 
special case wrappers that need to be maintained just to keep the line count down for 
"simplicity".

I think that Phil's approach here is the best one for now, particularly given that it 
allows us to take another step towards heterogeneous machines. As the work in this 
area matures it might be that we can consider other approaches, but that's not a 
decision that can be made right now and so shouldn't be a reason to block this change.


ATB,

Mark.


