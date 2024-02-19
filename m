Return-Path: <kvm+bounces-9090-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A230A85A535
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 14:58:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 18533B213B0
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 13:57:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C45E936AF5;
	Mon, 19 Feb 2024 13:57:51 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from zero.eik.bme.hu (zero.eik.bme.hu [152.66.115.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D58336AE5
	for <kvm@vger.kernel.org>; Mon, 19 Feb 2024 13:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=152.66.115.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708351071; cv=none; b=Ec9jHJ7v8shsHsoEY1hpkEMZ+LpDWR0REITiwqEcL6jSU9zAvFzpVHm1iJkwDFuvXhKQNKDr64Yg9tiri33TpkyxKHWCMXqu2bZgeF2b8NAD13mP6yOgJH36Wxio/jC9T77CHIT/kKEGF0xHSDL2WcvDKXnmA3D0laF94Xhl2vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708351071; c=relaxed/simple;
	bh=BeUu/qQFvclzINoiIygX1xMRl3wAMHAndB9HhbHAVV8=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=T5RuDWLV7EZql7jlWN56vGfZzLGptRcf/KUGW49rzb2OtUD7YfGfOaaXmK7f389hJ2K2Meb5PdJTDoUfpQPQxJVKIi6cASSN0XsMB9+gnj9o332ligueAB/4XdWf8eVlEl+t2O63jgwVaZIOETUDLYymi0MeyDSRnWZpVOahhAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=eik.bme.hu; spf=pass smtp.mailfrom=eik.bme.hu; arc=none smtp.client-ip=152.66.115.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=eik.bme.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=eik.bme.hu
Received: from zero.eik.bme.hu (localhost [127.0.0.1])
	by zero.eik.bme.hu (Postfix) with ESMTP id 6FEF84E6003;
	Mon, 19 Feb 2024 14:57:45 +0100 (CET)
X-Virus-Scanned: amavisd-new at eik.bme.hu
Received: from zero.eik.bme.hu ([127.0.0.1])
	by zero.eik.bme.hu (zero.eik.bme.hu [127.0.0.1]) (amavisd-new, port 10028)
	with ESMTP id TUwGnDj7pJuX; Mon, 19 Feb 2024 14:57:43 +0100 (CET)
Received: by zero.eik.bme.hu (Postfix, from userid 432)
	id 69CEB4E6013; Mon, 19 Feb 2024 14:57:43 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by zero.eik.bme.hu (Postfix) with ESMTP id 642A57456B4;
	Mon, 19 Feb 2024 14:57:43 +0100 (CET)
Date: Mon, 19 Feb 2024 14:57:43 +0100 (CET)
From: BALATON Zoltan <balaton@eik.bme.hu>
To: Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>
cc: =?ISO-8859-15?Q?Philippe_Mathieu-Daud=E9?= <philmd@linaro.org>, 
    qemu-devel@nongnu.org, 
    =?ISO-8859-15?Q?Daniel_P=2E_Berrang=E9?= <berrange@redhat.com>, 
    Eduardo Habkost <eduardo@habkost.net>, qemu-arm@nongnu.org, 
    kvm@vger.kernel.org, Peter Maydell <peter.maydell@linaro.org>, 
    Igor Mitsyanko <i.mitsyanko@gmail.com>, 
    "Michael S. Tsirkin" <mst@redhat.com>, 
    Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, 
    Paolo Bonzini <pbonzini@redhat.com>, 
    Richard Henderson <richard.henderson@linaro.org>, 
    Markus Armbruster <armbru@redhat.com>, 
    Manos Pitsidianakis <manos.pitsidianakis@linaro.org>
Subject: Re: [PATCH 1/6] hw/arm: Inline sysbus_create_simple(PL110 / PL111)
In-Reply-To: <bc5929e4-1782-4719-8231-fe04a9719c40@ilande.co.uk>
Message-ID: <8115d26c-458a-74d0-6c85-bc03b2f99011@eik.bme.hu>
References: <20240216153517.49422-1-philmd@linaro.org> <20240216153517.49422-2-philmd@linaro.org> <bcfd3f9d-04e3-79c9-c15f-c3c8d7669bdb@eik.bme.hu> <2f8ec2e2-c4c7-48c3-9c3d-3e20bc3d6b9b@linaro.org> <b40fd79f-4d41-4e04-90c1-6f4b2fde811d@linaro.org>
 <00e2b898-3c5f-d19c-fddc-e657306e071f@eik.bme.hu> <2b9ea923-c4f9-4ee4-8ed2-ba9f62c15579@linaro.org> <6b5758d6-f464-2461-f9dd-71d2e15b610a@eik.bme.hu> <bc5929e4-1782-4719-8231-fe04a9719c40@ilande.co.uk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="3866299591-1125001828-1708351063=:77986"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--3866299591-1125001828-1708351063=:77986
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT

On Mon, 19 Feb 2024, Mark Cave-Ayland wrote:
> On 19/02/2024 12:00, BALATON Zoltan wrote:
>> On Mon, 19 Feb 2024, Philippe Mathieu-Daudé wrote:
>>> On 19/2/24 12:27, BALATON Zoltan wrote:
>>>> On Mon, 19 Feb 2024, Philippe Mathieu-Daudé wrote:
>>>>> On 16/2/24 20:54, Philippe Mathieu-Daudé wrote:
>>>>>> On 16/2/24 18:14, BALATON Zoltan wrote:
>>>>>>> On Fri, 16 Feb 2024, Philippe Mathieu-Daudé wrote:
>>>>>>>> We want to set another qdev property (a link) for the pl110
>>>>>>>> and pl111 devices, we can not use sysbus_create_simple() which
>>>>>>>> only passes sysbus base address and IRQs as arguments. Inline
>>>>>>>> it so we can set the link property in the next commit.
>>>>>>>> 
>>>>>>>> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
>>>>>>>> ---
>>>>>>>> hw/arm/realview.c    |  5 ++++-
>>>>>>>> hw/arm/versatilepb.c |  6 +++++-
>>>>>>>> hw/arm/vexpress.c    | 10 ++++++++--
>>>>>>>> 3 files changed, 17 insertions(+), 4 deletions(-)
>>>>>>>> 
>>>>>>>> diff --git a/hw/arm/realview.c b/hw/arm/realview.c
>>>>>>>> index 9058f5b414..77300e92e5 100644
>>>>>>>> --- a/hw/arm/realview.c
>>>>>>>> +++ b/hw/arm/realview.c
>>>>>>>> @@ -238,7 +238,10 @@ static void realview_init(MachineState *machine,
>>>>>>>>     sysbus_create_simple("pl061", 0x10014000, pic[7]);
>>>>>>>>     gpio2 = sysbus_create_simple("pl061", 0x10015000, pic[8]);
>>>>>>>> 
>>>>>>>> -    sysbus_create_simple("pl111", 0x10020000, pic[23]);
>>>>>>>> +    dev = qdev_new("pl111");
>>>>>>>> +    sysbus_realize_and_unref(SYS_BUS_DEVICE(dev), &error_fatal);
>>>>>>>> +    sysbus_mmio_map(SYS_BUS_DEVICE(dev), 0, 0x10020000);
>>>>>>>> +    sysbus_connect_irq(SYS_BUS_DEVICE(dev), 0, pic[23]);
>>>>>>> 
>>>>>>> Not directly related to this patch but this blows up 1 line into 4 
>>>>>>> just to allow setting a property. Maybe just to keep some simplicity 
>>>>>>> we'd rather need either a sysbus_realize_simple function that takes a 
>>>>>>> sysbus device instead of the name and does not create the device 
>>>>>>> itself or some way to pass properties to sysbus create simple (but the 
>>>>>>> latter may not be easy to do in a generic way so not sure about that). 
>>>>>>> What do you think?
>>>>>> 
>>>>>> Unfortunately sysbus doesn't scale in heterogeneous setup.
>>>>> 
>>>>> Regarding the HW modelling API complexity you are pointing at, we'd
>>>>> like to move from the current imperative programming paradigm to a
>>>>> declarative one, likely DSL driven. Meanwhile it is being investigated
>>>>> (as part of "Dynamic Machine"), I'm trying to get the HW APIs right
>>>> 
>>>> I'm aware of that activity but we're currently still using board code to 
>>>> construct machines and probably will continue to do so for a while. Also 
>>>> because likely not all current machines will be converted to new 
>>>> declarative way so having a convenient API for that is still useful.
>>>> 
>>>> (As for the language to describe the devices of a machine and their 
>>>> connections declaratively the device tree does just that but dts is not a 
>>>> very user friendly descrtiption language so I haven't brought that up as 
>>>> a possibility. But you may still could get some clues by looking at the 
>>>> problems it had to solve to at least get a requirements for the machine 
>>>> description language.)
>>>> 
>>>>> for heterogeneous emulation. Current price to pay is a verbose
>>>>> imperative QDev API, hoping we'll get later a trivial declarative one
>>>>> (like this single sysbus_create_simple call), where we shouldn't worry
>>>>> about the order of low level calls, whether to use link or not, etc.
>>>> 
>>>> Having a detailed low level API does not prevent a more convenient for 
>>>> current use higher level API on top so keeping that around for current 
>>>> machines would allow you to chnage the low level API without having to 
>>>> change all the board codes because you's only need to update the simple 
>>>> high level API.
>>> 
>>> So what is your suggestion here, add a new complex helper to keep
>>> a one-line style?
>>> 
>>> DeviceState *sysbus_create_simple_dma_link(const char *typename,
>>>                                           hwaddr baseaddr,
>>>                                           const char *linkname,
>>>                                           Object *linkobj,
>>>                                           qemu_irq irq);
>> 
>> I think just having sysbus_realize_simple that does the same as 
>> sysbus_create_simple minus creating the device would be enough because then 
>> the cases where you need to set properties could still use it after 
>> qdev_new or init and property_set but hide the realize and connecting the 
>> device behind this single call.
>
> I can't say I'm a fan of sysbus_create_simple() because its use of varargs to 
> populate qdev properties is based upon the assumptions that the properties 
> defined with device_class_set_props() are stored in a list. I can see there 
> could be potential in future to store properties in other structures such as 
> a hash, and keeping this API would prevent this change. FWIW my personal 
> preference would be to remove this API completely.
>
>>> I wonder why this is that important since you never modified
>>> any of the files changed by this series:
>> 
>> For new people trying to contribute to QEMU QDev is overwhelming so having 
>> some way to need less of it to do simple things would help them to get 
>> started.
>
> It depends what how you define "simple": for QEMU developers most people 
> search for similar examples in the codebase and copy/paste them. I'd much 
> rather have a slightly longer, but consistent API for setting properties 
> rather than coming up with many special case wrappers that need to be 
> maintained just to keep the line count down for "simplicity".

It's not just about keeping the line count down, although that helps with 
readablility, it's simpler to see what the code does if one has to go 
through less QDev and QOM details, and new people are unfamiliar with 
those so when they see the five lines creating the single device they 
won't get what it does while a sysbus_create_simple call is very self 
explaining. Maybe sysbus_create_simple is not the best API and not one we 
can keep but by point is that as long as we have board code and it's the 
main way to create machines that developers have to work with then we 
should have some simple API to do that and don't leave them with only low 
level QOM and QDev calls that are not high level enough to creare a 
machine conveniently. If the direction is to eventually don't need any 
code to create a machine then don't spend much time on designing that API 
but at least keep what we have as long as it's possible. Removing the 
device creation from sysbus_create_simple is not a big change but allows 
board code to keep using it for now instead of ending up an unreadable low 
level calls that makes it harder to see at a glance what a board consists 
of.

> I think that Phil's approach here is the best one for now, particularly given 
> that it allows us to take another step towards heterogeneous machines. As the 
> work in this area matures it might be that we can consider other approaches, 
> but that's not a decision that can be made right now and so shouldn't be a 
> reason to block this change.

I did not say this patch should not be accepred or anything like that. 
Just if there's a way with not too much work to make this simpler (as in 
more readable and understandable for people not familiar with low levels 
of QEMU) then I think that's worth trying and keeping at least most of the 
functions of sysbus_create_simple as sysbus_realize_simple is not much 
work to do but avoids blowing up the board code with a lot of low level 
QOM stuff that I'd rather keep out of there unless it could be made less 
overwhelming and verbose. Also keeping a higher level API for board code 
would help this refactoring because if the low level calls are not all 
over the board code then they would need to change less as the changes 
could be done within the higher level API implementation.

But at the end this is just my opinion and Philippe is free to do what he 
wants. I ust shared this view point in case he can take it into account 
but if not then it's not the end of the world.

Regards,
BALATON Zoltan
--3866299591-1125001828-1708351063=:77986--

