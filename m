Return-Path: <kvm+bounces-32503-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B91039D94D1
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 10:46:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 13EC21643BA
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 09:46:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F33171BC9F6;
	Tue, 26 Nov 2024 09:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FObc1Kum"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E53031474DA
	for <kvm@vger.kernel.org>; Tue, 26 Nov 2024 09:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732614372; cv=none; b=Ij2DYpBNCTNtLcMmrWySoFqdKqYJtXzhy4Z8aJjas4GWBjShwA0W0oPKeUAKj70oVAC/FQajnJ5w4lhHg2jg1O7etB6HNLhjSkfbPKpszVyHuftBGk/FGnK4EiCaaXfdsdZR2uH0rHg3AXVyQUZW15wqyAPvDaFaau5e1qrn+SU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732614372; c=relaxed/simple;
	bh=pkn+NdHqiEGjJkMi7VxUtMn7x64lFKV38xzbHu4tfog=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mwKxhM3o6rL+PW7ZSafeENCdaE58rwZEqUvrWUgWylT0vd4NYntzuscc9HkA/g1Ui3OFILWRFXq7GavWTK2gtT1gugcOa9yV1DPBQuasi3rQKkK/Dqm2B0INQUTgfjEoLFQYmYTG5BGGGfn7iyC+ne3vu/Si0uXIgRxqEo5ALro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=FObc1Kum; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-53de8ecafeeso715287e87.1
        for <kvm@vger.kernel.org>; Tue, 26 Nov 2024 01:46:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1732614368; x=1733219168; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=utOlLiB1oR3lMYaNsbhIs9qYb6RkQxsFS+ZnaRw29QQ=;
        b=FObc1KumJ6SELQcdzy7TlcszHikHDYeQZaOYlDPe+3JEhgrSEDYclDtZSRTxgsywkx
         3vK6OqQ60ZX3NohBUGfnfuuhBgUicingao05SGnEXxWmBt+6Ryay/ZYkWNUJfZLeLHGP
         LhzIwESQ8vZitcM0pvnfcYTGdaL3JK4+n22yj17SbFm7zrw7niNlrGSZROg/eCa8HOuV
         5+qPDaxCys74/reAAquay7nqEdElQIpoRT7kZw7OdM6TmuMUMHQ2mxByAlRU2cqwSNb9
         7V/EPeilG3vkE9x2IYL6ib4+nhoVmVCD5sS/dNbP2f8VrWYjdwNom4KqEdIY67pr5Mcb
         LKyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732614368; x=1733219168;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=utOlLiB1oR3lMYaNsbhIs9qYb6RkQxsFS+ZnaRw29QQ=;
        b=Jabbc6rtpdTl2lDsdDcJA3TNIdYh8g0FyubX7cZTqzEoCsfs/s6rI1OhHj0BoaUYjS
         dpdfgCXk1L/Abls4BnkH9k+TxbYfpe1QEC5NVFQ9MZExgXTzmnzF9E461pUv+DdE8G2L
         jAW5Gtp7gtyuV7G0AYsJ/rgKAI/RXeAe7oeGrAvCShPoJ1z1lJ+ci7Tjrg12zDb9++0B
         qjCBnZfPkhk4+YNk5bdWJz/BF6cYmYQV6JfJFBOdPnmFdV4zEY0GGhxxcNvQX1iHuRk1
         csazkRvz0b1t6PiJp4ZmxHzHm+Rgpk1W+TxRmHgC5a6RNLTrQBGB4jl3hM5h9QKVsjhQ
         7/wA==
X-Forwarded-Encrypted: i=1; AJvYcCXY8Ru7B2yWc/rKVa7nXaeXZJ0BXPUh9HsVWuLn95itMCKeH5OKXczvgIFkWs5iwa25elw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwjVr2LKPqtrp2/l3yKnk0MlhcbfucvmgWLXNlVsQJ9PpQEOz6c
	MQavSZIy+3c+kYfff26V9QlP3iLLMwaOFN+P/VkTI40iQFvNP+xR01gAI6agWNo=
X-Gm-Gg: ASbGncssLtFlD3zCqs2sAFO/y3DK8zSya7XnisOwtUV3BIaETqNhA2i7Q81d7YVFuEh
	jNQz/72P4aHyOAF6QMOWIsG1z87yoqVRHpouJSyIdSlaGzoc2VrTLV4pp1h8Jvd10WR8QHnZuUy
	u04tvHDPh7ohZJTlU40eAFIT6U6jB+epHOdBimLPtqjhRQKVBnAee6Ekgjbkk8vt2xHOwVIMMas
	FQroMVN0FUdwr3OUDs/wLhq8mQ+KXjcu7JXi3ZMg9abWJMB7O95y1lriBq7nfsV1Q==
X-Google-Smtp-Source: AGHT+IGQWM6uXzGcNGnkQNOhuHw97egQRdbE7AkCaRYHafH78NNtcslkaJUAwejq3eS7g3joDs3QMQ==
X-Received: by 2002:a05:6512:2356:b0:539:e2cc:d380 with SMTP id 2adb3069b0e04-53dd389c8cbmr6294994e87.27.1732614367757;
        Tue, 26 Nov 2024 01:46:07 -0800 (PST)
Received: from [192.168.69.197] ([176.176.143.205])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3825fbc4123sm13084777f8f.79.2024.11.26.01.46.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Nov 2024 01:46:07 -0800 (PST)
Message-ID: <04e11ba4-2e3d-4e98-a125-977da8c75d7c@linaro.org>
Date: Tue, 26 Nov 2024 10:46:04 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 07/60] kvm: Introduce kvm_arch_pre_create_vcpu()
To: Xiaoyao Li <xiaoyao.li@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Riku Voipio <riku.voipio@iki.fi>,
 Richard Henderson <richard.henderson@linaro.org>,
 Zhao Liu <zhao1.liu@intel.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Igor Mammedov <imammedo@redhat.com>, Ani Sinha <anisinha@redhat.com>
Cc: Yanan Wang <wangyanan55@huawei.com>, Cornelia Huck <cohuck@redhat.com>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, rick.p.edgecombe@intel.com,
 kvm@vger.kernel.org, qemu-devel@nongnu.org
References: <20241105062408.3533704-1-xiaoyao.li@intel.com>
 <20241105062408.3533704-8-xiaoyao.li@intel.com>
 <fbe5da1d-9a0e-4aa4-91f9-dfb729f39dc9@linaro.org>
 <68c65132-0f2e-44eb-b084-bf70edd51417@intel.com>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <68c65132-0f2e-44eb-b084-bf70edd51417@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 25/11/24 08:27, Xiaoyao Li wrote:
> On 11/13/2024 2:28 PM, Philippe Mathieu-Daudé wrote:
>> Hi,
>>
>> On 5/11/24 06:23, Xiaoyao Li wrote:
>>> Introduce kvm_arch_pre_create_vcpu(), to perform arch-dependent
>>> work prior to create any vcpu. This is for i386 TDX because it needs
>>> call TDX_INIT_VM before creating any vcpu.
>>>
>>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>>> Acked-by: Gerd Hoffmann <kraxel@redhat.com>
>>> ---
>>> Changes in v3:
>>> - pass @errp to kvm_arch_pre_create_vcpu(); (Per Daniel)
>>> ---
>>>   accel/kvm/kvm-all.c  | 10 ++++++++++
>>>   include/sysemu/kvm.h |  1 +
>>>   2 files changed, 11 insertions(+)
>>>
>>> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
>>> index 930a5bfed58f..1732fa1adecd 100644
>>> --- a/accel/kvm/kvm-all.c
>>> +++ b/accel/kvm/kvm-all.c
>>> @@ -523,6 +523,11 @@ void kvm_destroy_vcpu(CPUState *cpu)
>>>       }
>>>   }
>>> +int __attribute__ ((weak)) kvm_arch_pre_create_vcpu(CPUState *cpu, 
>>> Error **errp)
>>
>> We don't use the weak attribute. Maybe declare stubs for each arch?
> 
> Or define TARGET_KVM_HAVE_PRE_CREATE_VCPU to avoid touching other ARCHes?
> 
> 8<------------------------------------------------------------------
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -536,10 +531,12 @@ int kvm_init_vcpu(CPUState *cpu, Error **errp)
> 
>       trace_kvm_init_vcpu(cpu->cpu_index, kvm_arch_vcpu_id(cpu));
> 
> +#ifdef TARGET_KVM_HAVE_PRE_CREATE_VCPU
>       ret = kvm_arch_pre_create_vcpu(cpu, errp);
>       if (ret < 0) {
>           goto err;
>       }
> +#endif
> 
>       ret = kvm_create_vcpu(cpu);
>       if (ret < 0) {
> diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
> index 643ca4950543..bb76bf090fec 100644
> --- a/include/sysemu/kvm.h
> +++ b/include/sysemu/kvm.h
> @@ -374,7 +374,9 @@ int kvm_arch_get_default_type(MachineState *ms);
> 
>   int kvm_arch_init(MachineState *ms, KVMState *s);
> 
> +#ifdef TARGET_KVM_HAVE_PRE_CREATE_VCPU
>   int kvm_arch_pre_create_vcpu(CPUState *cpu, Error **errp);
> +#enfid
>   int kvm_arch_init_vcpu(CPUState *cpu);
>   int kvm_arch_destroy_vcpu(CPUState *cpu);
> 
> 
> 
> I'm OK with either. Please let me what is your preference!

Personally stubs because it is simpler to find where to
implement something, but it is Paolo's area, so his
preference takes over.

