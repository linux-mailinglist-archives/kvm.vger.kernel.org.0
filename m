Return-Path: <kvm+bounces-9072-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 594B385A1EB
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 12:28:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 136B5281041
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 11:28:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1924B2C1AE;
	Mon, 19 Feb 2024 11:28:07 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from zero.eik.bme.hu (zero.eik.bme.hu [152.66.115.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D663E847A
	for <kvm@vger.kernel.org>; Mon, 19 Feb 2024 11:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=152.66.115.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708342086; cv=none; b=THZKtrAvg2I86Y0qxTSRa8HmTJ3JIDyZ+08Kl5D/yF9IcRvbfbRIlqF93YClUGi+ZxpT1joXvSOX/TGD1cE1oAIVwK9iZSdPfhjIERyY+fNzyWfk/qENW8RMwTwOuC08Nws/A9DXpK5o5DqiiI18ZUJextH1wQtVxtdzKAHmjEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708342086; c=relaxed/simple;
	bh=4Cvud7QyiAKhb7TutEh2G1s4OpY3N/BteMZqGcYZ1Jo=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=tuWj8wRJPww3W6Pu7FIHX0yZEHvx9A6RL/OKcqLHnPXY6fyx3b5dPvg26U9NUfr5D5Q3SisD23tGjE8Bi4IaoS5DNEwu5Y9wSumuIrir395mEigMFDGVb1zz7dvKu0Ylso6La0+quZAVz1JV8ZeiXd1nLvM7D+2Tb77L55CtO3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=eik.bme.hu; spf=pass smtp.mailfrom=eik.bme.hu; arc=none smtp.client-ip=152.66.115.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=eik.bme.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=eik.bme.hu
Received: from zero.eik.bme.hu (localhost [127.0.0.1])
	by zero.eik.bme.hu (Postfix) with ESMTP id C27344E6012;
	Mon, 19 Feb 2024 12:27:53 +0100 (CET)
X-Virus-Scanned: amavisd-new at eik.bme.hu
Received: from zero.eik.bme.hu ([127.0.0.1])
	by zero.eik.bme.hu (zero.eik.bme.hu [127.0.0.1]) (amavisd-new, port 10028)
	with ESMTP id ZCiph4DT3mu7; Mon, 19 Feb 2024 12:27:51 +0100 (CET)
Received: by zero.eik.bme.hu (Postfix, from userid 432)
	id C80734E6003; Mon, 19 Feb 2024 12:27:51 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by zero.eik.bme.hu (Postfix) with ESMTP id C65637456B4;
	Mon, 19 Feb 2024 12:27:51 +0100 (CET)
Date: Mon, 19 Feb 2024 12:27:51 +0100 (CET)
From: BALATON Zoltan <balaton@eik.bme.hu>
To: =?ISO-8859-15?Q?Philippe_Mathieu-Daud=E9?= <philmd@linaro.org>
cc: qemu-devel@nongnu.org, 
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
In-Reply-To: <b40fd79f-4d41-4e04-90c1-6f4b2fde811d@linaro.org>
Message-ID: <00e2b898-3c5f-d19c-fddc-e657306e071f@eik.bme.hu>
References: <20240216153517.49422-1-philmd@linaro.org> <20240216153517.49422-2-philmd@linaro.org> <bcfd3f9d-04e3-79c9-c15f-c3c8d7669bdb@eik.bme.hu> <2f8ec2e2-c4c7-48c3-9c3d-3e20bc3d6b9b@linaro.org> <b40fd79f-4d41-4e04-90c1-6f4b2fde811d@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="3866299591-507710864-1708342071=:44613"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--3866299591-507710864-1708342071=:44613
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT

On Mon, 19 Feb 2024, Philippe Mathieu-Daudé wrote:
> On 16/2/24 20:54, Philippe Mathieu-Daudé wrote:
>> On 16/2/24 18:14, BALATON Zoltan wrote:
>>> On Fri, 16 Feb 2024, Philippe Mathieu-Daudé wrote:
>>>> We want to set another qdev property (a link) for the pl110
>>>> and pl111 devices, we can not use sysbus_create_simple() which
>>>> only passes sysbus base address and IRQs as arguments. Inline
>>>> it so we can set the link property in the next commit.
>>>> 
>>>> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
>>>> ---
>>>> hw/arm/realview.c    |  5 ++++-
>>>> hw/arm/versatilepb.c |  6 +++++-
>>>> hw/arm/vexpress.c    | 10 ++++++++--
>>>> 3 files changed, 17 insertions(+), 4 deletions(-)
>>>> 
>>>> diff --git a/hw/arm/realview.c b/hw/arm/realview.c
>>>> index 9058f5b414..77300e92e5 100644
>>>> --- a/hw/arm/realview.c
>>>> +++ b/hw/arm/realview.c
>>>> @@ -238,7 +238,10 @@ static void realview_init(MachineState *machine,
>>>>     sysbus_create_simple("pl061", 0x10014000, pic[7]);
>>>>     gpio2 = sysbus_create_simple("pl061", 0x10015000, pic[8]);
>>>> 
>>>> -    sysbus_create_simple("pl111", 0x10020000, pic[23]);
>>>> +    dev = qdev_new("pl111");
>>>> +    sysbus_realize_and_unref(SYS_BUS_DEVICE(dev), &error_fatal);
>>>> +    sysbus_mmio_map(SYS_BUS_DEVICE(dev), 0, 0x10020000);
>>>> +    sysbus_connect_irq(SYS_BUS_DEVICE(dev), 0, pic[23]);
>>> 
>>> Not directly related to this patch but this blows up 1 line into 4 just to 
>>> allow setting a property. Maybe just to keep some simplicity we'd rather 
>>> need either a sysbus_realize_simple function that takes a sysbus device 
>>> instead of the name and does not create the device itself or some way to 
>>> pass properties to sysbus create simple (but the latter may not be easy to 
>>> do in a generic way so not sure about that). What do you think?
>> 
>> Unfortunately sysbus doesn't scale in heterogeneous setup.
>
> Regarding the HW modelling API complexity you are pointing at, we'd
> like to move from the current imperative programming paradigm to a
> declarative one, likely DSL driven. Meanwhile it is being investigated
> (as part of "Dynamic Machine"), I'm trying to get the HW APIs right

I'm aware of that activity but we're currently still using board code to 
construct machines and probably will continue to do so for a while. Also 
because likely not all current machines will be converted to new 
declarative way so having a convenient API for that is still useful.

(As for the language to describe the devices of a machine and their 
connections declaratively the device tree does just that but dts is not a 
very user friendly descrtiption language so I haven't brought that up as a 
possibility. But you may still could get some clues by looking at the 
problems it had to solve to at least get a requirements for the machine 
description language.)

> for heterogeneous emulation. Current price to pay is a verbose
> imperative QDev API, hoping we'll get later a trivial declarative one
> (like this single sysbus_create_simple call), where we shouldn't worry
> about the order of low level calls, whether to use link or not, etc.

Having a detailed low level API does not prevent a more convenient for 
current use higher level API on top so keeping that around for current 
machines would allow you to chnage the low level API without having to 
change all the board codes because you's only need to update the simple 
high level API.

Regards,
BALATON Zoltan
--3866299591-507710864-1708342071=:44613--

