Return-Path: <kvm+bounces-11447-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D2D7877189
	for <lists+kvm@lfdr.de>; Sat,  9 Mar 2024 14:56:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C2978B20FDA
	for <lists+kvm@lfdr.de>; Sat,  9 Mar 2024 13:56:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 438B340867;
	Sat,  9 Mar 2024 13:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="MMx37O0M"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB5251BDF4
	for <kvm@vger.kernel.org>; Sat,  9 Mar 2024 13:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709992566; cv=none; b=TFMSELI05oyjFYbhXERWdmCautqxRLBhdE6dlaqS5bU3CABobUUi1mXR9gZbPMR9XRPVaNDAJo9QQfdRT+WR3Gv5pQ6e1IUZJdRr8Gda8VMsVZt+raCOnG+ifqJ5MVHuV9diieFB+Il05y2BQlhvqa/db9DsmVfrH+lUiqkAPkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709992566; c=relaxed/simple;
	bh=I59VH6rnQPLa2uDF7Gok56IpPye9Hb2QhJxFV6gK3f0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lm32BARUK/3Kg5HTsY9von2wRNaa1bB/r/OuYT6yJZQYXFOYfdc5b4U31ufL0Hx/Y0yVikJFzxcgilwt7OWfPVDvKM+gi9YsyKVLikMrIPusKNojoCFLMourXdouGlCetMYaVjz2F0n1+5xXdyslJzztzY/sBsJsQS8xOTWjbbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=MMx37O0M; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-413216e601eso2185835e9.1
        for <kvm@vger.kernel.org>; Sat, 09 Mar 2024 05:56:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1709992562; x=1710597362; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=j/HsoclK8oFQ4qi18yZzZcW2qu6FHeVgS9jILiPGy6w=;
        b=MMx37O0ME5jGEiEPWmc/NgzXmMsVH8Y3MB9LWweFKP/68VTF5RL94OipkPXs2HCoU5
         Zx7tN18OU3jn+5kazb15hx+7blk8g2O/W9XJYU/XJWLJ3W/+XZ9dz1hhUyRdkws+5Xyw
         ghPZZhux/5cMFD7a7oWI/CAxiKlUzErF5o+HqCNgKOgRr2vKXmpwUTY2G7Sii7ikhMKK
         QdQpoqxbZ9LofpqcYgFQ+S8iP37k/ubpzeVSyr8GeBQsARU4e77EcYwtfL2xs87OKxCx
         2y3Ir1/vJ5nfso/xcBPlZXiaHDzSuKm2qbJQuSR9eTzqPAa6KxIetOSAtI/suoyZoUsV
         G2fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709992562; x=1710597362;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j/HsoclK8oFQ4qi18yZzZcW2qu6FHeVgS9jILiPGy6w=;
        b=Hq8aUtd3iQ0tD+eZo03oCPxfSzMBjTy9qtOwB5SOwVH7/3Z5FDLZgM8xPOu3lJtxql
         pFf2BA9F1Zgj1O1HqLAkukLVyIcoAWUQf89aGPaoFYB87DwmWlGFXLD+D/KmNHuccwL9
         EcuUfFW6qE5A1oke23EOzw4WayZeZfbbcEhdLeG1Reg+v+zO/NRNosHzFucalw2Dxlwq
         ji+rt5HszEY6Xque73KsaCfVmM09LI7yrkI9yDug4SuzeQyTL+coY5f9JI8xtAG8fdnk
         72UHRMWnDzw3XRve37tcS33JMnlDvqvOjHBJljUfpq2+x8KfJIF+QxDUcI2T4BGWKXcG
         3ovg==
X-Forwarded-Encrypted: i=1; AJvYcCUsFDLDuRgs/rXuc2U8YbJkKcL/Xg4KSyrdrHZ6Yx2OAyNz+idgiLb8bLMno8F24BqeQsf+/cLahMqoY6YL5It05Zkc
X-Gm-Message-State: AOJu0Ywk9K1X2si23w5u3SVJ2ND1qVidq4b2r+C7aBQCGHsYN/J4JKF8
	GKfjQ6C6sk4YOjs4GKx72qU1ubPL99ylkw5AKy0H6Zw6GZUsoiQ4o9dtBRGMxeE=
X-Google-Smtp-Source: AGHT+IHKLUNBAr4YLdH9TGDIUQwct/XsTIrbBBU17nMuxSw56x0i+whSOUvjDh/dd6RFzwAxA4ZfQQ==
X-Received: by 2002:a05:600c:548e:b0:412:ed9b:621c with SMTP id iv14-20020a05600c548e00b00412ed9b621cmr1460363wmb.24.1709992562128;
        Sat, 09 Mar 2024 05:56:02 -0800 (PST)
Received: from [192.168.69.100] ([176.176.181.237])
        by smtp.gmail.com with ESMTPSA id fc19-20020a05600c525300b0041312855081sm2643627wmb.5.2024.03.09.05.55.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 Mar 2024 05:56:01 -0800 (PST)
Message-ID: <d58b22bb-43b4-42aa-8ed2-1975beb1f31c@linaro.org>
Date: Sat, 9 Mar 2024 14:55:57 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 00/21] Introduce smp.modules for x86 in QEMU
Content-Language: en-US
To: Zhao Liu <zhao1.liu@linux.intel.com>
Cc: Eduardo Habkost <eduardo@habkost.net>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Yanan Wang <wangyanan55@huawei.com>, "Michael S . Tsirkin" <mst@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Eric Blake <eblake@redhat.com>,
 Markus Armbruster <armbru@redhat.com>, Marcelo Tosatti
 <mtosatti@redhat.com>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
 qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Zhenyu Wang <zhenyu.z.wang@intel.com>,
 Zhuocheng Ding <zhuocheng.ding@intel.com>, Babu Moger <babu.moger@amd.com>,
 Yongwei Ma <yongwei.ma@intel.com>, Zhao Liu <zhao1.liu@intel.com>
References: <20240227103231.1556302-1-zhao1.liu@linux.intel.com>
 <17444096-9602-43e1-9042-2a7ce02b5e79@linaro.org>
 <ZeuyN8Eacq1Twsvg@intel.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <ZeuyN8Eacq1Twsvg@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Zhao,

On 9/3/24 01:49, Zhao Liu wrote:
> On Fri, Mar 08, 2024 at 05:36:38PM +0100, Philippe Mathieu-Daudé wrote:
>> Date: Fri, 8 Mar 2024 17:36:38 +0100
>> From: Philippe Mathieu-Daudé <philmd@linaro.org>
>> Subject: Re: [PATCH v9 00/21] Introduce smp.modules for x86 in QEMU
>>
>> On 27/2/24 11:32, Zhao Liu wrote:
>>
>>> ---
>>> Zhao Liu (20):
>>>     hw/core/machine: Introduce the module as a CPU topology level
>>>     hw/core/machine: Support modules in -smp
>>>     hw/core: Introduce module-id as the topology subindex
>>>     hw/core: Support module-id in numa configuration
>>
>> Patches 1-4 queued, thanks!
> 
> Thanks Philippe!

I dropped this 4 patches in favor of "Cleanup on SMP and its test"
v2 
(https://lore.kernel.org/qemu-devel/20240308160148.3130837-1-zhao1.liu@linux.intel.com/)
which seems more important, to get the "parameter=0" deprecation
in the next release. (Patch 2 diverged).

Regards,

Phil.

