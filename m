Return-Path: <kvm+bounces-8907-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AFCA085866C
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 20:54:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6BC8D284353
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 19:54:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC762137C29;
	Fri, 16 Feb 2024 19:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="w9xQijV8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21E5F12A158
	for <kvm@vger.kernel.org>; Fri, 16 Feb 2024 19:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708113265; cv=none; b=WzfRSrGNa1sqK1n3VEGloa257N75RQPrBpEqhruDDvv4K0lgqNWLUZbEI34ASR03uHqTConQ1uNpPMfU4AUrBtfACL5QUKn78IaYNqohH+P9Up9cbawED2jdzz9C+ieuvfk+wKeMyM0FqTDT4zVIJI5rH/cnk4TT52Gs23Lm3eM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708113265; c=relaxed/simple;
	bh=DWbIemeaauxg4DKlDBXcAuMujE6346YfXHGb9GOQhxY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pUy/bkm5NG2MlzQmULPUZZMPRLfdMgZn75Jt7yj4toBB7BzMtMeVjfFAfnD/Z2ROBjHFMfXJQCBh0fGZY68g+wJTzA8aT3OQuExagbt/LCQzY6PAU6+aJJPOOxT2dTWqjpOxUhnHUzzQTcD0JHcA37ehki1DGE7ABqfLO+3jCdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=w9xQijV8; arc=none smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-2d21cdbc85bso10029111fa.2
        for <kvm@vger.kernel.org>; Fri, 16 Feb 2024 11:54:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1708113261; x=1708718061; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fTvzKYXRxk2Xk+NKT9N6TKpQ1vRzkheOt6rJHqBctwc=;
        b=w9xQijV8N9CTcEb5OZnCf4kOEziWE8KoDly1jNO0mKON5vejk/EqilqteCruWSXMJA
         8I7Eiogq1yuDSoxE0HRyqqQyWwRfU/rWX42x2mZzhwZD4raIoiDKsUJd/vFCiNx5CxrR
         OauuR4YT3lug12oRKH/rwXSRMbLrc0A3lPq+7vKXDzB47A1/CQlCT9sW3O2/9e4nZswJ
         aA8rraWkTYwOkSx1UqTw0PNkl+UCKFT0mc2QNdcBRxOZWh/Xb36v3R82I69xccNU89+k
         L14wTrkQH88ik6JV/kMqACLyjpYXE6wnugYzCxnRasEX+gA/B3zdHEl1OkBwUlL7y4YL
         vEpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708113261; x=1708718061;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fTvzKYXRxk2Xk+NKT9N6TKpQ1vRzkheOt6rJHqBctwc=;
        b=JT2Cc2l4I/FoIRqAwPUioo/zQNpmStPcP9hyNs4ZsXrwCcNDilslIbF6e+ZpS3UfCz
         tZd1FvLox6vG4KG6pzTwB6WW+PjtoAeW9wd4BQo19vjcKPaAhjeW9wKlRLyIqCyM+PkY
         V3WjKeEI0n6Cd9pg3K80cdljRTv84sbG6ChJ0FCB4b7iyQLoo/oPD9If9Nk6IO9OjXYD
         9QOfs//Wwyq9wrjT2bS0z6sUyZMoZtedKFQytnqA+x0ksNixiYjGG8jcGgFWF5M++VPY
         K4NlMj4/4IGdHnqpWA4ykwumHBgx32/S6dDzQpkP6/gfOh+LrMfp6MgJIZv2m8KpYKsD
         wazg==
X-Forwarded-Encrypted: i=1; AJvYcCVsTNMbJv6IcH2pl/zXsE6ly2VzBmm3X37Edl/99nM2IMMgBUJTjPZ1vMWRpmBkEq9RlDrCaFmxGke1mBth17bRUw2K
X-Gm-Message-State: AOJu0YwinBVHvq913Qeujnb5Q1NAhh2goghMjJ4zYVwH84w7EwrKZAzq
	/7+/33yh9C/T2UyLT8xy/oOiTpm/5tYo3UjwazyEczVqrKjyAGK8XaKwRHcmkeQ=
X-Google-Smtp-Source: AGHT+IFzjk+5T9BmuEZRICqcvnwesA2RMuuDU+Whj7S6bON3OfQ97tljdqKynRbPhDdS0PqMyMTtMg==
X-Received: by 2002:ac2:4209:0:b0:511:9250:1ba5 with SMTP id y9-20020ac24209000000b0051192501ba5mr3733969lfh.36.1708113261126;
        Fri, 16 Feb 2024 11:54:21 -0800 (PST)
Received: from [192.168.69.100] ([176.187.210.246])
        by smtp.gmail.com with ESMTPSA id b26-20020ac2563a000000b0051178d2f592sm55689lff.236.2024.02.16.11.54.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Feb 2024 11:54:20 -0800 (PST)
Message-ID: <2f8ec2e2-c4c7-48c3-9c3d-3e20bc3d6b9b@linaro.org>
Date: Fri, 16 Feb 2024 20:54:01 +0100
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
 Richard Henderson <richard.henderson@linaro.org>
References: <20240216153517.49422-1-philmd@linaro.org>
 <20240216153517.49422-2-philmd@linaro.org>
 <bcfd3f9d-04e3-79c9-c15f-c3c8d7669bdb@eik.bme.hu>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <bcfd3f9d-04e3-79c9-c15f-c3c8d7669bdb@eik.bme.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 16/2/24 18:14, BALATON Zoltan wrote:
> On Fri, 16 Feb 2024, Philippe Mathieu-Daudé wrote:
>> We want to set another qdev property (a link) for the pl110
>> and pl111 devices, we can not use sysbus_create_simple() which
>> only passes sysbus base address and IRQs as arguments. Inline
>> it so we can set the link property in the next commit.
>>
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
>> ---
>> hw/arm/realview.c    |  5 ++++-
>> hw/arm/versatilepb.c |  6 +++++-
>> hw/arm/vexpress.c    | 10 ++++++++--
>> 3 files changed, 17 insertions(+), 4 deletions(-)
>>
>> diff --git a/hw/arm/realview.c b/hw/arm/realview.c
>> index 9058f5b414..77300e92e5 100644
>> --- a/hw/arm/realview.c
>> +++ b/hw/arm/realview.c
>> @@ -238,7 +238,10 @@ static void realview_init(MachineState *machine,
>>     sysbus_create_simple("pl061", 0x10014000, pic[7]);
>>     gpio2 = sysbus_create_simple("pl061", 0x10015000, pic[8]);
>>
>> -    sysbus_create_simple("pl111", 0x10020000, pic[23]);
>> +    dev = qdev_new("pl111");
>> +    sysbus_realize_and_unref(SYS_BUS_DEVICE(dev), &error_fatal);
>> +    sysbus_mmio_map(SYS_BUS_DEVICE(dev), 0, 0x10020000);
>> +    sysbus_connect_irq(SYS_BUS_DEVICE(dev), 0, pic[23]);
> 
> Not directly related to this patch but this blows up 1 line into 4 just 
> to allow setting a property. Maybe just to keep some simplicity we'd 
> rather need either a sysbus_realize_simple function that takes a sysbus 
> device instead of the name and does not create the device itself or some 
> way to pass properties to sysbus create simple (but the latter may not 
> be easy to do in a generic way so not sure about that). What do you think?

Unfortunately sysbus doesn't scale in heterogeneous setup.

