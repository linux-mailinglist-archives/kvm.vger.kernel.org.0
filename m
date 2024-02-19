Return-Path: <kvm+bounces-9073-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7375685A27C
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 12:51:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 981DE1C217EB
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 11:51:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECB5D2E630;
	Mon, 19 Feb 2024 11:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pcstVTMX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B999D3714C
	for <kvm@vger.kernel.org>; Mon, 19 Feb 2024 11:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708343376; cv=none; b=ahTl9L8t4tfovECNdp9t0V9PlrU7d+75j3ZoWaAq8yq2CYGOTz8x5OyyFPlrW+8AqMCirYdfA9IDUqy5+X763AZLYIhHZPcGhuowrjBTgx0PziM3hfdB53/MC0XT5J0iaZynbXBUoBR7XyBfLSLsiVUKaS+b7hvy74GdeCFL5So=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708343376; c=relaxed/simple;
	bh=dz7g1UUQCdIPx2pnoyxdxdS7OeSiA4whxyYSsWVQ4KI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eL0u2D1t110zPLYChL2MQy7tR40GfR+ex1FrbvbpiDRJT27J1lXudJ0GMcV8h9H6RAaz2kyUXvjX36HFqqPJpDqSNod28Iop1b8i6jww1vBBBPb9VVjQ0C0I+wIesr5e7/GFAFemJx/J3frfiIyZp368iG7DeLsSqWYXv9abDMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=pcstVTMX; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-33d5ec64351so212415f8f.2
        for <kvm@vger.kernel.org>; Mon, 19 Feb 2024 03:49:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1708343372; x=1708948172; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YngC5yhQXscsRLlNrXXGSMc1GCmCcfETUmdOlmq3fbI=;
        b=pcstVTMXe/2cQ+HTuVrJ/lMrRRNwmBgV6uEfqTG+dEvu6UHNne5HBDVjIzmf1SuGyH
         qYNrxSq745B3QZV0mHwG8xqq0r/P/NSC9JUNJmntZ8KaOUp+mMk5yUb1pdAPqHD7JrKj
         M/LzQIuTVCbMQoJujRgqOj7z+Hhdr0a0X8kc8gQQwcjSVSz51T00vkkquGuAcjszQ5BO
         EdsqiMcs7gb3JOp4faK0i3coQsOTa9P7kAbO2sIuK0rA7482Rje8+TpqGx2lvLsLwrRY
         Zx2JcKwLV/zQzC+perA0N6836fdUnEkQrAqHJ+jdvz/anfONl1223TP5jbQGgt/HfcyQ
         VSaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708343372; x=1708948172;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YngC5yhQXscsRLlNrXXGSMc1GCmCcfETUmdOlmq3fbI=;
        b=aYDdIKGAx6tMD2dzwVpH4TuCqbxx3E1cIZatlal4IRafFu66/Q806wk+LpBZXQ6SRl
         y2adGiw/X0vnJcW1uPOmwr3swl4vWMxcvxW98pibK0132bEC9DlNbaxPUbFLK5ag8QGi
         Zxed5a0mbw5OMTSFdj8FWTY3HrN6T91RxuqLWt3c/1jHHU/vFNPLAtj9NgJvlLh1dmeD
         b/kr6C+8yfisYde5dlNc1GbZfQGocslTj2I6PpHWHj+4F9JZbvUYfAg5eIlRH/Q0Yd69
         ThKRCX4bBi5/4SHwvwnmmKI7eKIwXF8LCMYFdkdMleqTG+4Dp8Fj8Iv4xyyKrS8X9FEw
         nSbQ==
X-Forwarded-Encrypted: i=1; AJvYcCVowB3Pe2KOEnPq4xCNbXL9X38PORCxNPOEIHauPk2hb/now1DRzDOgAdCWFf2j7C7rumYYbQeP4nuhGGzwoTb60gxu
X-Gm-Message-State: AOJu0YxVpWoNuuC9pGogMW3+j74LKFptA1/6q4Ki44BZJ53duYYHaulo
	xHZZz1pZRjcfBmeNI7ZU5KhiuqtwkXYSzxh/L7jR6XnvJyU/0+cCgaauqv18UDI=
X-Google-Smtp-Source: AGHT+IE8KNo6h9P+hO82/XMMmYdvNPlUxhLjsn8Bh7xGr43q6/gL/9uAehuo7PCZY4KC/Ns/Cr8pTg==
X-Received: by 2002:a05:6000:a07:b0:33d:4e4:686e with SMTP id co7-20020a0560000a0700b0033d04e4686emr10084893wrb.68.1708343371946;
        Mon, 19 Feb 2024 03:49:31 -0800 (PST)
Received: from [192.168.69.100] ([176.176.181.220])
        by smtp.gmail.com with ESMTPSA id w2-20020adfec42000000b0033d13530134sm10088512wrn.106.2024.02.19.03.49.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Feb 2024 03:49:31 -0800 (PST)
Message-ID: <2b9ea923-c4f9-4ee4-8ed2-ba9f62c15579@linaro.org>
Date: Mon, 19 Feb 2024 12:49:28 +0100
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
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <00e2b898-3c5f-d19c-fddc-e657306e071f@eik.bme.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 19/2/24 12:27, BALATON Zoltan wrote:
> On Mon, 19 Feb 2024, Philippe Mathieu-Daudé wrote:
>> On 16/2/24 20:54, Philippe Mathieu-Daudé wrote:
>>> On 16/2/24 18:14, BALATON Zoltan wrote:
>>>> On Fri, 16 Feb 2024, Philippe Mathieu-Daudé wrote:
>>>>> We want to set another qdev property (a link) for the pl110
>>>>> and pl111 devices, we can not use sysbus_create_simple() which
>>>>> only passes sysbus base address and IRQs as arguments. Inline
>>>>> it so we can set the link property in the next commit.
>>>>>
>>>>> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
>>>>> ---
>>>>> hw/arm/realview.c    |  5 ++++-
>>>>> hw/arm/versatilepb.c |  6 +++++-
>>>>> hw/arm/vexpress.c    | 10 ++++++++--
>>>>> 3 files changed, 17 insertions(+), 4 deletions(-)
>>>>>
>>>>> diff --git a/hw/arm/realview.c b/hw/arm/realview.c
>>>>> index 9058f5b414..77300e92e5 100644
>>>>> --- a/hw/arm/realview.c
>>>>> +++ b/hw/arm/realview.c
>>>>> @@ -238,7 +238,10 @@ static void realview_init(MachineState *machine,
>>>>>     sysbus_create_simple("pl061", 0x10014000, pic[7]);
>>>>>     gpio2 = sysbus_create_simple("pl061", 0x10015000, pic[8]);
>>>>>
>>>>> -    sysbus_create_simple("pl111", 0x10020000, pic[23]);
>>>>> +    dev = qdev_new("pl111");
>>>>> +    sysbus_realize_and_unref(SYS_BUS_DEVICE(dev), &error_fatal);
>>>>> +    sysbus_mmio_map(SYS_BUS_DEVICE(dev), 0, 0x10020000);
>>>>> +    sysbus_connect_irq(SYS_BUS_DEVICE(dev), 0, pic[23]);
>>>>
>>>> Not directly related to this patch but this blows up 1 line into 4 
>>>> just to allow setting a property. Maybe just to keep some simplicity 
>>>> we'd rather need either a sysbus_realize_simple function that takes 
>>>> a sysbus device instead of the name and does not create the device 
>>>> itself or some way to pass properties to sysbus create simple (but 
>>>> the latter may not be easy to do in a generic way so not sure about 
>>>> that). What do you think?
>>>
>>> Unfortunately sysbus doesn't scale in heterogeneous setup.
>>
>> Regarding the HW modelling API complexity you are pointing at, we'd
>> like to move from the current imperative programming paradigm to a
>> declarative one, likely DSL driven. Meanwhile it is being investigated
>> (as part of "Dynamic Machine"), I'm trying to get the HW APIs right
> 
> I'm aware of that activity but we're currently still using board code to 
> construct machines and probably will continue to do so for a while. Also 
> because likely not all current machines will be converted to new 
> declarative way so having a convenient API for that is still useful.
> 
> (As for the language to describe the devices of a machine and their 
> connections declaratively the device tree does just that but dts is not 
> a very user friendly descrtiption language so I haven't brought that up 
> as a possibility. But you may still could get some clues by looking at 
> the problems it had to solve to at least get a requirements for the 
> machine description language.)
> 
>> for heterogeneous emulation. Current price to pay is a verbose
>> imperative QDev API, hoping we'll get later a trivial declarative one
>> (like this single sysbus_create_simple call), where we shouldn't worry
>> about the order of low level calls, whether to use link or not, etc.
> 
> Having a detailed low level API does not prevent a more convenient for 
> current use higher level API on top so keeping that around for current 
> machines would allow you to chnage the low level API without having to 
> change all the board codes because you's only need to update the simple 
> high level API.

So what is your suggestion here, add a new complex helper to keep
a one-line style?

DeviceState *sysbus_create_simple_dma_link(const char *typename,
                                            hwaddr baseaddr,
                                            const char *linkname,
                                            Object *linkobj,
                                            qemu_irq irq);

I wonder why this is that important since you never modified
any of the files changed by this series:

$ git shortlog -es hw/arm/realview.c hw/arm/versatilepb.c 
hw/arm/vexpress.c hw/display/pl110.c hw/arm/exynos4210.c 
hw/display/exynos4210_fimd.c hw/i386/kvmvapic.c
     66  Peter Maydell <peter.maydell@linaro.org>
     34  Markus Armbruster <armbru@redhat.com>
     29  Philippe Mathieu-Daudé <philmd@linaro.org>
     28  Paolo Bonzini <pbonzini@redhat.com>
     17  Andreas Färber <afaerber@suse.de>
     13  Eduardo Habkost <ehabkost@redhat.com>
      8  Greg Bellows <greg.bellows@linaro.org>
      7  Krzysztof Kozlowski <krzk@kernel.org>
      6  Gerd Hoffmann <kraxel@redhat.com>
      5  Richard Henderson <richard.henderson@linaro.org>
      5  Jan Kiszka <jan.kiszka@siemens.com>
      5  Igor Mammedov <imammedo@redhat.com>
      4  Xiaoqiang Zhao <zxq_yx_007@163.com>
      4  Thomas Huth <thuth@redhat.com>
      4  Anthony Liguori <anthony@codemonkey.ws>
      3  Stefan Weil <sw@weilnetz.de>
      3  Pavel Dovgaluk <Pavel.Dovgaluk@ispras.ru>
      3  Guenter Roeck <linux@roeck-us.net>
      3  Daniel P. Berrangé <berrange@redhat.com>
      3  Alistair Francis <alistair.francis@xilinx.com>
      2  Roy Franz <roy.franz@linaro.org>
      2  Pavel Dovgaluk <pavel.dovgaluk@ispras.ru>
      2  Marcel Apfelbaum <marcel.a@redhat.com>
      2  Linus Walleij <linus.walleij@linaro.org>
      2  Like Xu <like.xu@linux.intel.com>
      2  Juan Quintela <quintela@trasno.org>
      2  Igor Mitsyanko <i.mitsyanko@samsung.com>
      2  Hu Tao <hutao@cn.fujitsu.com>
      2  David Woodhouse <dwmw@amazon.co.uk>
      1  Zongyuan Li <zongyuan.li@smartx.com>
      1  Wen, Jianxian <Jianxian.Wen@verisilicon.com>
      1  Vincent Palatin <vpalatin@chromium.org>
      1  Tao Xu <tao3.xu@intel.com>
      1  Sergey Fedorov <serge.fdrv@gmail.com>
      1  Prasad J Pandit <ppandit@redhat.com>
      1  Prasad J Pandit <pjp@fedoraproject.org>
      1  Pranith Kumar <bobby.prani@gmail.com>
      1  Peter Crosthwaite <peter.crosthwaite@xilinx.com>
      1  Nikita Belov <zodiac@ispras.ru>
      1  Martin Kletzander <mkletzan@redhat.com>
      1  Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>
      1  Marcelo Tosatti <mtosatti@redhat.com>
      1  Marcel Apfelbaum <marcel@redhat.com>
      1  Marc-André Lureau <marcandre.lureau@redhat.com>
      1  Laurent Vivier <lvivier@redhat.com>
      1  Laszlo Ersek <lersek@redhat.com>
      1  Kevin Wolf <kwolf@redhat.com>
      1  Jean-Christophe Dubois <jcd@tribudubois.net>
      1  Igor Mitsyanko <i.mitsyanko@gmail.com>
      1  Grant Likely <grant.likely@linaro.org>
      1  Gonglei (Arei) <arei.gonglei@huawei.com>
      1  Frederic Konrad <konrad.frederic@yahoo.fr>
      1  Fabian Aggeler <aggelerf@ethz.ch>
      1  Eric Auger <eric.auger@linaro.org>
      1  Emilio G. Cota <cota@braap.org>
      1  Dirk Müller <dirk@dmllr.de>
      1  David Gibson <david@gibson.dropbear.id.au>
      1  Chen Qun <kuhn.chenqun@huawei.com>
      1  Chen Fan <chen.fan.fnst@cn.fujitsu.com>
      1  Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
      1  Anthony Liguori <aliguori@amazon.com>
      1  Alexander Graf <agraf@csgraf.de>
      1  Alex Chen <alex.chen@huawei.com>
      1  Alex Bennée <alex.bennee@linaro.org>


