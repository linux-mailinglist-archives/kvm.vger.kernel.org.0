Return-Path: <kvm+bounces-29978-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CCA99B5319
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 21:11:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9C0DE1C229AC
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 20:11:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A3392076B2;
	Tue, 29 Oct 2024 20:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ouKrp1Wl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6EC21940B3
	for <kvm@vger.kernel.org>; Tue, 29 Oct 2024 20:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730232672; cv=none; b=R7TMjjWDD0fBnWar/zbfeHPM0nc6+IUWZw1uKd4RWQU0qo6JyRXNuFbTWur/5+x+FgHz6UJ5FS0W+nxHhL7ynN2E5ZCyci9XhAkgHxD/C6cTVWCq7Ybz6Dnv0FZX1DuBLBgac5lcqTPM1FnVQffw13r6pYBLhYhFdUgBbmC/OI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730232672; c=relaxed/simple;
	bh=bfoprkZGjmkHJRVDyqbHwnrqzCLu7TqY0+8j0H9z3NU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bwAVUA4ytt/WYC4+ViCdZJDFaNrX+TCxWutNj27FMWJsDPfsPkw7NC+CYRsbe0SNlF6hR0onv5qhfWVnmGqht87h+x+A5ZY4ReqGoe/y2xHRWAX1RbEQyIzHLWCGzSldoTX6HNN4aFKjSiYPvn8ixb8Uf32cGedWKZt29DuZsi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ouKrp1Wl; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-539ebb5a20aso6069842e87.2
        for <kvm@vger.kernel.org>; Tue, 29 Oct 2024 13:11:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1730232668; x=1730837468; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mVffrm7ORWtwr/oTU7Spuj4YBIi+VLsXfNiPlPYNk9Q=;
        b=ouKrp1Wl5Ye05ub16BoAMNU05Qq00hEor9ScWasIvbczlxvhRumOYNkuUzTZiwWYUk
         NJkAj3uWh1699hfJosx3eA0dVfR15z23W7I6KzD/SN/KMNGFIxgxz1TXrZ5sX7pdDIFN
         BpEuErwrFrnCbKY99MDQHZTo6wjQL+ehgxt3RGiOJ51D8htreeERE8D/JEw3/AcrimOG
         ds2ldp6NVczHT2RYVh6Yo+yEtaTD4lwf4tFxmJ2MSfBDB1iGc3dC7+e+T6VJpLMphKvU
         WSDXQEIyjDvxPVTaEhsH31nDNxDdTm3FyDFohIiGFTkD9cs/TNojwikxMWLufGxzWJQl
         qo6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730232668; x=1730837468;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mVffrm7ORWtwr/oTU7Spuj4YBIi+VLsXfNiPlPYNk9Q=;
        b=Qk5rDvKHPdvSNoDb9SPXBcZy8111vEfy+3TJO2gPkFUQPxfsU79WKQkCD7Y9oCxxE3
         wX9burY1Y+x1+60VQztQcoP05G+7c812PtKOS6trEHBaRZO2KErD56HbaCIqhQNxv6vj
         ahlmoph0Mx9PjYhy7k/MyTd3a+3MVEZ3jJ7U2gLjyXFwA7EX1flGWBWBEzNSq6VLC2Kz
         wQB3aJV8UPkZqiaG7hllCgWJIBJKPR3oT1KHAWjUJKYJRe8bZYzXQyrs42v1zcN7G9UJ
         VpvNmkwN0z+A1iYzWONu2JlOgkPx22FlJVOrTaBfapXo5V1RdwyG7vB5Y8WXV2f2lUNS
         o0yA==
X-Forwarded-Encrypted: i=1; AJvYcCWKKF+ldNBlMUtFjWXGmymhekZSAMTZ1MkZ0gfUeG3N3sqigvdQlb6kVjMbMhdqnnNFcZE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzYcBMt3KH2EptF3ajrEpbMt7ugWlRypl7wvcYfYECiDK92+NU3
	z8ebZBX7HWaeRPh7uXamNu9OXnHpOhy6WT1pk++/q7qowY9lpJSOGtNoSp4zAMQ=
X-Google-Smtp-Source: AGHT+IEQm7S7HhrAefu6bB3WsI9sjvU1NibhMhK2h3mgqHzs6Ac3q/ixT/MrrVYq2nNiKqsosFqETQ==
X-Received: by 2002:a05:6512:1285:b0:539:e513:1f66 with SMTP id 2adb3069b0e04-53b3491e086mr6508337e87.37.1730232667785;
        Tue, 29 Oct 2024 13:11:07 -0700 (PDT)
Received: from [192.168.156.226] ([91.223.100.133])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53bc0d5f161sm40364e87.213.2024.10.29.13.10.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Oct 2024 13:11:07 -0700 (PDT)
Message-ID: <31e8dc51-f70f-44eb-a768-61cfa50eed5b@linaro.org>
Date: Tue, 29 Oct 2024 17:10:52 -0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/9] hw/core: Make CPU topology enumeration
 arch-agnostic
To: Zhao Liu <zhao1.liu@intel.com>, =?UTF-8?Q?Daniel_P_=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
 Eduardo Habkost <eduardo@habkost.net>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Yanan Wang <wangyanan55@huawei.com>, "Michael S . Tsirkin" <mst@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, =?UTF-8?Q?Alex_Benn=C3=A9e?=
 <alex.bennee@linaro.org>, Peter Maydell <peter.maydell@linaro.org>,
 Jonathan Cameron <Jonathan.Cameron@huawei.com>,
 Sia Jee Heng <jeeheng.sia@starfivetech.com>,
 Alireza Sanaee <alireza.sanaee@huawei.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-riscv@nongnu.org,
 qemu-arm@nongnu.org, Zhenyu Wang <zhenyu.z.wang@intel.com>,
 Dapeng Mi <dapeng1.mi@linux.intel.com>, Yongwei Ma <yongwei.ma@intel.com>
References: <20241022135151.2052198-1-zhao1.liu@intel.com>
 <20241022135151.2052198-3-zhao1.liu@intel.com>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20241022135151.2052198-3-zhao1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 22/10/24 10:51, Zhao Liu wrote:
> Cache topology needs to be defined based on CPU topology levels. Thus,
> define CPU topology enumeration in qapi/machine.json to make it generic
> for all architectures.
> 
> To match the general topology naming style, rename CPU_TOPO_LEVEL_* to
> CPU_TOPOLOGY_LEVEL_*, and rename SMT and package levels to thread and
> socket.
> 
> Also, enumerate additional topology levels for non-i386 arches, and add
> a CPU_TOPOLOGY_LEVEL_DEFAULT to help future smp-cache object to work
> with compatibility requirement of arch-specific cache topology models.
> 
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> Tested-by: Yongwei Ma <yongwei.ma@intel.com>
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> ---
> Changes since Patch v3:
>   * Dropped "invalid" level to avoid an unsettable option. (Daniel)
> ---
>   hw/i386/x86-common.c       |   4 +-
>   include/hw/i386/topology.h |  23 ++----
>   qapi/machine-common.json   |  44 +++++++++++-
>   target/i386/cpu.c          | 144 ++++++++++++++++++-------------------
>   target/i386/cpu.h          |   4 +-
>   5 files changed, 123 insertions(+), 96 deletions(-)
> 
> diff --git a/hw/i386/x86-common.c b/hw/i386/x86-common.c
> index b86c38212eab..bc360a9ea44b 100644
> --- a/hw/i386/x86-common.c
> +++ b/hw/i386/x86-common.c
> @@ -273,12 +273,12 @@ void x86_cpu_pre_plug(HotplugHandler *hotplug_dev,
>   
>       if (ms->smp.modules > 1) {
>           env->nr_modules = ms->smp.modules;
> -        set_bit(CPU_TOPO_LEVEL_MODULE, env->avail_cpu_topo);
> +        set_bit(CPU_TOPOLOGY_LEVEL_MODULE, env->avail_cpu_topo);
>       }
>   
>       if (ms->smp.dies > 1) {
>           env->nr_dies = ms->smp.dies;
> -        set_bit(CPU_TOPO_LEVEL_DIE, env->avail_cpu_topo);
> +        set_bit(CPU_TOPOLOGY_LEVEL_DIE, env->avail_cpu_topo);
>       }
>   
>       /*
> diff --git a/include/hw/i386/topology.h b/include/hw/i386/topology.h
> index 48b43edc5a90..b2c8bf2de158 100644
> --- a/include/hw/i386/topology.h
> +++ b/include/hw/i386/topology.h
> @@ -39,7 +39,7 @@
>    *  CPUID Fn8000_0008_ECX[ApicIdCoreIdSize[3:0]] is set to apicid_core_width().
>    */
>   
> -
> +#include "qapi/qapi-types-machine-common.h"
>   #include "qemu/bitops.h"
>   
>   /*
> @@ -62,22 +62,7 @@ typedef struct X86CPUTopoInfo {
>       unsigned threads_per_core;
>   } X86CPUTopoInfo;
>   
> -#define CPU_TOPO_LEVEL_INVALID CPU_TOPO_LEVEL_MAX
> -
> -/*
> - * CPUTopoLevel is the general i386 topology hierarchical representation,
> - * ordered by increasing hierarchical relationship.
> - * Its enumeration value is not bound to the type value of Intel (CPUID[0x1F])
> - * or AMD (CPUID[0x80000026]).
> - */
> -enum CPUTopoLevel {
> -    CPU_TOPO_LEVEL_SMT,
> -    CPU_TOPO_LEVEL_CORE,
> -    CPU_TOPO_LEVEL_MODULE,
> -    CPU_TOPO_LEVEL_DIE,
> -    CPU_TOPO_LEVEL_PACKAGE,
> -    CPU_TOPO_LEVEL_MAX,
> -};
> +#define CPU_TOPOLOGY_LEVEL_INVALID CPU_TOPOLOGY_LEVEL__MAX


> @@ -341,18 +341,18 @@ static uint32_t apicid_offset_by_topo_level(X86CPUTopoInfo *topo_info,
>       return 0;
>   }
>   
> -static uint32_t cpuid1f_topo_type(enum CPUTopoLevel topo_level)
> +static uint32_t cpuid1f_topo_type(enum CpuTopologyLevel topo_level)
>   {
>       switch (topo_level) {
> -    case CPU_TOPO_LEVEL_INVALID:
> +    case CPU_TOPOLOGY_LEVEL_INVALID:

Since we use an enum, I'd rather directly use CPU_TOPOLOGY_LEVEL__MAX.

Or maybe in this case ...

>           return CPUID_1F_ECX_TOPO_LEVEL_INVALID;
> -    case CPU_TOPO_LEVEL_SMT:
> +    case CPU_TOPOLOGY_LEVEL_THREAD:
>           return CPUID_1F_ECX_TOPO_LEVEL_SMT;
> -    case CPU_TOPO_LEVEL_CORE:
> +    case CPU_TOPOLOGY_LEVEL_CORE:
>           return CPUID_1F_ECX_TOPO_LEVEL_CORE;
> -    case CPU_TOPO_LEVEL_MODULE:
> +    case CPU_TOPOLOGY_LEVEL_MODULE:
>           return CPUID_1F_ECX_TOPO_LEVEL_MODULE;
> -    case CPU_TOPO_LEVEL_DIE:
> +    case CPU_TOPOLOGY_LEVEL_DIE:
>           return CPUID_1F_ECX_TOPO_LEVEL_DIE;
>       default:
            /* Other types are not supported in QEMU. */
            g_assert_not_reached();

... return CPUID_1F_ECX_TOPO_LEVEL_INVALID as default.

Can be cleaned on top, so:

Acked-by: Philippe Mathieu-Daudé <philmd@linaro.org>



