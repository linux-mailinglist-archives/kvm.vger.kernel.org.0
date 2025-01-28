Return-Path: <kvm+bounces-36802-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D87A9A21340
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 21:53:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1273A3A5B5B
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 20:53:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEA0F1DFDA2;
	Tue, 28 Jan 2025 20:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zAp++q2y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 825111A841A
	for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 20:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738097619; cv=none; b=qdTIGEusCMNa8MGEIKu9DR/FLtWGV/AIeRyDLtQ3WJCbXRT1qQHIz7G+feiMXCEZIJ2GdNCFb5YmNw8FelDlWZkWtvQlkUQAv1boBDe0rxBXHQAOVmR1/Yw6wFQlQhx41HjoY8F12n5dCqpptYaKXcTkLzGE8uecsTNaWKGYJ1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738097619; c=relaxed/simple;
	bh=+GRN+IaEJ5M2mnWDN3XFvoVI/lKGp0qz3D4te05CGas=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=u1jKYi6Ne+R7TLXky7B4XqNuYDrKsv0KoGEm7epGgxQ8XZ1bOdgzTZpRUNuoh9+FnRfzPflYizTaLiVwWtSCcErWindOjcnTI3E5wfY11R8OBthrjILvuF9wT2uBBbZX3AX1akK7Xyd6kt/w7NplmF6+jN32adBMPUeLGcyimLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=zAp++q2y; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-2f13acbe29bso89880a91.1
        for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 12:53:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1738097617; x=1738702417; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SVGsgP2JxnTbIVukHbum7BO51ahJ2agUN7ZMpTkHHzw=;
        b=zAp++q2yI4kMu8OQNH45IkrTE5zVR5wY5+AI47b80zcPXy5REmwG30OINcZ9KpBM5o
         o3z69nqCt1clGmTadhPK+09diUg/dw+oFhtw1jXBZxrjjRoYxw6aU1LdaI6aCNVqazQg
         m6rP5bLl0a7fCWzLlrOUYHlgr8Ybs+KlO6z0oRGuRfzkVA8GRzxDB24FN+X2pCb9L0Ta
         KRYXqfWSD9p/DaV5z71n+2cVW9Ntmt04I/5w5rMffseMfCfcauiKa2PE4shbuS98+X25
         5fWSYkq5QJ400eyB5lgswj8y5/wDyKOPWT6SghQBEdavLQGs7IbhaGYZvEPiHAeIWitZ
         iK0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738097617; x=1738702417;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SVGsgP2JxnTbIVukHbum7BO51ahJ2agUN7ZMpTkHHzw=;
        b=PR589SszZMtcmr9Oirqkx4IfjZCHRAZYHWrWYTezEeSHh8RlIWjF0FYnrth1MVeuo/
         8ifm87+qz95UlEQvv4Mp/lDPQ+qdPQEbZuyi4/GXILiMwE3bo7SYORXoku5yA4P/Czbo
         qu9NfjhKTinYIrNKJJmmkEEh7e0Vrfs7SWmy8lee8pabcnRiaL3nd6Km5jpyLgOMOP7h
         +zzoPEggBcosZycx/qVCWj69IXuYOanoebEkpOByR9K1biwHkjMkZ1rIlkVGnlUEjH2B
         B1IRrBC/h8Ff9QEq9ITZ/qU7M+mrzJYkUUgyLWOKYq4qQshY7b2RBS/xx5soLLF5oJep
         ESzg==
X-Forwarded-Encrypted: i=1; AJvYcCW4Tu5yPzPmMVficDe7pVuXI4YWnbo5KCpsXTAPlLT9D4wFQByp50gi+lK0oko53t9iXcg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxyiRl34D6bIsGeWQddMDH1ZaKyjMAZTgaVrI6boD0HTKyAx2p9
	2fUwdMeeM0B21Gip/cyUtqX8iDkRXk/c4epz3S6sFF8MHpQ9Ipmjj0vLvUWAAjI=
X-Gm-Gg: ASbGncugC6yaEmMJHp1ykcXW71S1V0vJhLO9PBfcvOYuknRAqo04GDLq8bqCcnYR4O5
	P6vzH7PbHGGHGkRrWfkIWFcBCvtSimPEc/2nvo7UqeVArRyXNcwVpWBlfEDXEZbAO6tJeC79quq
	hP9di3BV9zosAynditij1sxntidznmdfYlNK3gcZ/0PBZSBMaHUq3cAEIAIGs3Fw8G6UxnOZbjV
	o3YfU6u/QYs/JBSbGgpP3ahk3WDVPv/PYzCPgo29uUB1UwOiclrbRzKN1fZ83aAu5RK39HQ1xQ/
	sZKXhfi8UUBxVlGdKRJrRKmQFuOqXviG18YnRVIVQuk5ZT7XtBhjV6RMWVCh5pm0sq13
X-Google-Smtp-Source: AGHT+IGynnfw6l0HWGM419rZ6NjdwyyMXK8dmbERaW3Nncp5VQsCdqzgSfuOiObtiy+GivS9eKjeqw==
X-Received: by 2002:a05:6a21:b8a:b0:1e1:a449:ff71 with SMTP id adf61e73a8af0-1ed7a48c8c6mr1126983637.1.1738097616739;
        Tue, 28 Jan 2025 12:53:36 -0800 (PST)
Received: from [192.168.0.4] (174-21-71-127.tukw.qwest.net. [174.21.71.127])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72f8a69fe05sm9732184b3a.27.2025.01.28.12.53.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jan 2025 12:53:36 -0800 (PST)
Message-ID: <6b7d03ac-68d3-4fbd-adc8-554e815ad785@linaro.org>
Date: Tue, 28 Jan 2025 12:53:34 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/9] cpus: Call hotplug handlers in DeviceWire()
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
 Yanan Wang <wangyanan55@huawei.com>, Eduardo Habkost <eduardo@habkost.net>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>, kvm@vger.kernel.org,
 Zhao Liu <zhao1.liu@intel.com>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 Igor Mammedov <imammedo@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, Peter Xu <peterx@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>
References: <20250128142152.9889-1-philmd@linaro.org>
 <20250128142152.9889-7-philmd@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250128142152.9889-7-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/28/25 06:21, Philippe Mathieu-Daudé wrote:
> To call the hotplug handlers with REALIZED vCPU, we can
> use the DeviceWire handler.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   hw/core/cpu-common.c | 11 ++++++-----
>   1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/hw/core/cpu-common.c b/hw/core/cpu-common.c
> index 9ee44a00277..8a02ac146f6 100644
> --- a/hw/core/cpu-common.c
> +++ b/hw/core/cpu-common.c
> @@ -211,16 +211,17 @@ static void cpu_common_realizefn(DeviceState *dev, Error **errp)
>           }
>       }
>   
> -    if (dev->hotplugged) {
> -        cpu_synchronize_post_init(cpu);
> -        cpu_resume(cpu);
> -    }
> -
>       /* NOTE: latest generic point where the cpu is fully realized */
>   }
>   
>   static void cpu_common_wire(DeviceState *dev)
>   {
> +    CPUState *cpu = CPU(dev);
> +
> +    if (dev->hotplugged) {
> +        cpu_synchronize_post_init(cpu);
> +        cpu_resume(cpu);
> +    }
>   }
>   
>   static void cpu_common_unwire(DeviceState *dev)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

