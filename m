Return-Path: <kvm+bounces-14971-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A3EC98A84A9
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 15:30:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F007CB289CC
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 13:30:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DD881411F2;
	Wed, 17 Apr 2024 13:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qBeEsJnv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A4BE13E043
	for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 13:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713360572; cv=none; b=VNumuCyNKuP/tS9Dzq+PGQdBiaCW4pbAkodeCaXgARETo67s/pilk1Pxoo/yJSi1F02vpkPkTWi5yns4Qaxys7u6mScnOIwIgNdvPcUqp5VpxfZ4tKYdI8Ogqp3cXzsnjozv+/YDZbAvKuytU2ljmbNBOI36ry8xm4ZxUDcYhSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713360572; c=relaxed/simple;
	bh=TeiTLJN/5okNpELe3ZA4zy7aqgMGfMFAywMokEL2gE0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lR1P+cbU/DJoG0goLtAUVxVfnQ3rmjRWWVinmMgZR1kQrj8SkAeIwyWyGphsFaHMiumSja7oztvpN/kA5cAoDsF+TjKdB0E4VfVT0L/Dqn6oYL1xR7SEeiDi5wIuaoVT2b7o1MrsDV0R4x2QP6x5FQKo9On2K+MHi3eteV3wSWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=qBeEsJnv; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-6eff9dc1821so2954382b3a.3
        for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 06:29:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1713360569; x=1713965369; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=U9yUjGy+KC3uZnAtPNkhuEl1+cCKcH9uusVMRUEMaAc=;
        b=qBeEsJnvJxT3NtRa0AFvYJ25CjQnkTbG2cSrO7i/eZ6gKhqL5O75Xs+4nEcaNtc5jq
         rQ+cKR441g8vZo4QBK+o3sG6+jenqQNBfQioH6zB9Bpc+YBPPt778oSgEKbly7XfZ23B
         htrRLeUlUOi2iHrY2OitTROaopRrMGb/4sY5toMw3vkVYlNo+OP08ZdwiDbgyPBqUcD3
         j4q4mY8caAa9LWfhruY5HMP+NPWmQ//+p2lMGgUYEoVize2LkvhwpnHBEWSdvex/Bxif
         17zyi/WYrKQiWB4Tmh60oeBwxQsGK39VjZg5bSWDn4/w4cxA/YIHHMpccJb/ghcsPH1M
         /xSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713360569; x=1713965369;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U9yUjGy+KC3uZnAtPNkhuEl1+cCKcH9uusVMRUEMaAc=;
        b=HjmIM3Fsk2CJ9zaPkMFbu6kO706ckvjxWtFjznjrrhWQJkKHjxagGFROVjUU6JIMa/
         zqJqzKfSis24e85wlAK1Upj5wtGt7zWGY2xWr2XKaT4tvZE6l8Nij/1ul5DVKTAWK6ap
         qIvcpmMmbTxgQeERo0kERzRbjvLRNyyl5Elmf699t6t4U5OoO9XMN2dJWA760AslWunN
         mw0fRmeBjgZT3ck6ZPITUpFEC4HsXBlMktFcoB/VISSBgy8+fpkZXzGyCul6js0laTpT
         KApSkFYuSdQC5UnpUr5G26AqSHHg4Chj3ZsNTmvegiWY+EjL/lZDcMQ1LVKWN7HbQtM1
         TTeQ==
X-Forwarded-Encrypted: i=1; AJvYcCUQtiVDuRHK4wRMGiV3cKVnsDKGseW68pAQYeVGz52xq9541CjemCSbA4gKIJZUXbq5VExKKNAsg5TCH7IcK3POCcmZ
X-Gm-Message-State: AOJu0Yyjpfr2Y5LX76wiqlNScuvcltmr5zt9OQH6h/u/znKlv/pqZgaF
	fhA3dpVIQyp+AMfUwY9+2IltI/+FWho1cxXAtoomxTQBP0tfp34zolnSMhwCvw8=
X-Google-Smtp-Source: AGHT+IE6xQl1EcEphFdHM0huRf7JkAbzMW3ss8W6b4OgepYU2e+X7pEgHJyT8hN5oSrVdMtbpms3UA==
X-Received: by 2002:a05:6a20:3cab:b0:1a9:97fb:40cc with SMTP id b43-20020a056a203cab00b001a997fb40ccmr16554938pzj.2.1713360569312;
        Wed, 17 Apr 2024 06:29:29 -0700 (PDT)
Received: from [172.20.9.36] ([209.37.221.130])
        by smtp.gmail.com with ESMTPSA id i16-20020a17090332d000b001e2a43bafbasm11530447plr.216.2024.04.17.06.29.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Apr 2024 06:29:29 -0700 (PDT)
Message-ID: <4e762eb1-864e-4bb5-ab5d-debeac19c8fa@linaro.org>
Date: Wed, 17 Apr 2024 15:29:26 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/19] amba: store owner from modules with
 amba_driver_register()
To: Suzuki K Poulose <suzuki.poulose@arm.com>,
 Russell King <linux@armlinux.org.uk>, Mike Leach <mike.leach@linaro.org>,
 James Clark <james.clark@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Maxime Coquelin <mcoquelin.stm32@gmail.com>,
 Alexandre Torgue <alexandre.torgue@foss.st.com>,
 Linus Walleij <linus.walleij@linaro.org>, Andi Shyti
 <andi.shyti@kernel.org>, Olivia Mackall <olivia@selenic.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, Vinod Koul <vkoul@kernel.org>,
 Dmitry Torokhov <dmitry.torokhov@gmail.com>,
 Miquel Raynal <miquel.raynal@bootlin.com>,
 Michal Simek <michal.simek@amd.com>, Eric Auger <eric.auger@redhat.com>,
 Alex Williamson <alex.williamson@redhat.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, coresight@lists.linaro.org,
 linux-arm-kernel@lists.infradead.org,
 linux-stm32@st-md-mailman.stormreply.com, linux-i2c@vger.kernel.org,
 linux-crypto@vger.kernel.org, dmaengine@vger.kernel.org,
 linux-input@vger.kernel.org, kvm@vger.kernel.org
References: <20240326-module-owner-amba-v1-0-4517b091385b@linaro.org>
 <171182151736.34189.6433134738765363803.b4-ty@linaro.org>
 <cfa5aa01-44ef-4eb1-9ca6-541ed5908db4@linaro.org>
 <8a8a8e8b-8256-4d33-a39b-9e3cbc4ccff2@arm.com>
Content-Language: en-US
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Autocrypt: addr=krzysztof.kozlowski@linaro.org; keydata=
 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
 D2GYIS41Kv4Isx2dEFh+/Q==
In-Reply-To: <8a8a8e8b-8256-4d33-a39b-9e3cbc4ccff2@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 16/04/2024 12:41, Suzuki K Poulose wrote:
> + Greg
> 
> 
> Hi Krzysztof,
> 
> On 30/03/2024 18:00, Krzysztof Kozlowski wrote:
>> On 30/03/2024 18:58, Krzysztof Kozlowski wrote:
>>>
>>> On Tue, 26 Mar 2024 21:23:30 +0100, Krzysztof Kozlowski wrote:
>>>> Merging
>>>> =======
>>>> All further patches depend on the first amba patch, therefore please ack
>>>> and this should go via one tree.
>>>>
>>>> Description
>>>> ===========
>>>> Modules registering driver with amba_driver_register() often forget to
>>>> set .owner field.
>>>>
>>>> [...]
>>>
>>> Applied, thanks!
>>>
>>> [01/19] amba: store owner from modules with amba_driver_register()
>>>          (no commit info)
>>
>> Patchset applied here:
>> https://git.kernel.org/pub/scm/linux/kernel/git/krzk/linux-dt.git/log/?h=for-v6.10/module-owner-amba
> 
> How do you plan to push this ? Given this affects most of the drivers/, 
> do you plan to send this to Greg ? We have changes in the coresight
> tree that would conflict with this "tag" ( I haven't merged them yet, 
> but is in my local queue). I want to make sure we can avoid the
> conflicts. I am happy to merge this to my local tree and base the
> changes on this, if this is going in for v6.10 and all are in agreement.

I pushed it to arm-linux patches but it hasn't been picked up.

I propose you take entire set then.

Best regards,
Krzysztof


