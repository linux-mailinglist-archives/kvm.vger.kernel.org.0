Return-Path: <kvm+bounces-12175-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F20F880499
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 19:19:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B09EA1F2440A
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 18:19:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF61B376F1;
	Tue, 19 Mar 2024 18:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DLTgm/Wu"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E2F236AE1
	for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 18:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710872335; cv=none; b=Di+Eg+85ZkkVxxKxMxeyLc6iwm4jIrSgS4kNSbn8S7VfwRXjM+EuRHT0tOOEfPIzqkkSKCvNsPzCPBQuUcyQ5S2HUhp4pNxRtrsioO9hy+QnKXbYztdE4hzmoVdNEI6boWjjP4kZDFuWp0ur0jnPHU5i8wzHKkKNtf8lrSpCUto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710872335; c=relaxed/simple;
	bh=hzdAk1XXdvKjOZ4AQHy8ggyj0EbaWXWPvMx/bAolRNU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RuchRzIMJbMRaNBHtzajVzva5S/9gp7O8uL4qIoFCGej9mpOu4D5aYT9sgwi8khK3p+PHuQjNFGEzrqMwQv+CU9UVStIblSqto4GT69h13vDgPjj4CPSPj4BV64tZfHA+qNI+hEzLWPbZk+vcbLIEtW+df1YruyilVbC18lx3s4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DLTgm/Wu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710872332;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0i1FXUp3Se0Q8v6HAao+2JETY0/VPzWwNUhVoeedqFg=;
	b=DLTgm/WujYiJXZtmrAonB1F31NUxfFEmSAA7MuvaQjU1LpOGFLnOwUByNsQRCiIoepnzdj
	1GgehGceReOf2NB3p9rWVF6GecNqCwktk8VqzdYIVDwVrzqs2cNNz+YA3s6SnxgZW9a7ew
	qTnxKm3hwzoz6g1mHJ7oLQKAq/F/las=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-608-E9oEtvOONzOYmiB8hXMwVg-1; Tue, 19 Mar 2024 14:18:50 -0400
X-MC-Unique: E9oEtvOONzOYmiB8hXMwVg-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-33e4397540bso3588195f8f.3
        for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 11:18:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710872329; x=1711477129;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0i1FXUp3Se0Q8v6HAao+2JETY0/VPzWwNUhVoeedqFg=;
        b=j46ZWysK+y0h88EG33h37j4A5dBaEfBvmpHL2U6hH1NWOOo1vgpmgw55Fxb1YcNfKB
         kzdUUBTpDDm3hnQY3EChaqXd3KGCqgCTRttB9CsxkZD36i7tl2cv1fSxBsGLnLIrlKIG
         IOiOp5HLwqtJPUGosRPcXcL/Dl6PyT2/0eiemIvSf/JnGHheiCXZhqhriI/wwJ9L8Hss
         pmO25l0VbHhFKJNSGe5Hcm4K74DVh7zsqHqeFPqFimNvoIVnNjR4i+0QyaAYlRpWf9rP
         3w6vHFYMHkWBKbobZFxpr9jh1H8nH8l30xUuw7u8gSJTQDLzejhAOF3X+zoDgzXq/OQw
         hdUg==
X-Forwarded-Encrypted: i=1; AJvYcCVUaRXv5hC6aSZaB+TO7m9YdAlzeJJoEfatqund0DD+PvwIC0zbHVxgcVyop79VeDQ2/OheWl6C/bFpiO6LfEU00ETA
X-Gm-Message-State: AOJu0Yxdm+Ybb22pDZjS7UBB9bbRfRcImLUaxEctlK100AZXZbrLdRad
	ZU4SUdLxf7LutPleKRaaad6CUTCcoQvYkKojkjO3FfrX+4iYhHZKXAGDEZaykXeB+v/+G/a4oYo
	azCxaqiGwyyVZ4IsIe7XdH1YtHcL7GRr7Tg9gczNfCyFVwnjcnw==
X-Received: by 2002:a5d:6505:0:b0:33e:1e0:2679 with SMTP id x5-20020a5d6505000000b0033e01e02679mr10466494wru.47.1710872329416;
        Tue, 19 Mar 2024 11:18:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFabTZcYR2CWBvnYuMUxPYalH15zeGyYk2U9hmhf16bKkWsKNfW+fEYPxikdl7MgJ+RVcgwMw==
X-Received: by 2002:a5d:6505:0:b0:33e:1e0:2679 with SMTP id x5-20020a5d6505000000b0033e01e02679mr10466468wru.47.1710872329046;
        Tue, 19 Mar 2024 11:18:49 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id u14-20020a056000038e00b0033e34c53354sm8525278wrf.56.2024.03.19.11.18.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Mar 2024 11:18:48 -0700 (PDT)
Message-ID: <f26c5a3d-8ca8-4fbc-860e-d170cd5973c8@redhat.com>
Date: Tue, 19 Mar 2024 19:18:47 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7] arm/kvm: Enable support for KVM_ARM_VCPU_PMU_V3_FILTER
Content-Language: en-US
To: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>
Cc: Shaoqin Huang <shahuang@redhat.com>, qemu-arm@nongnu.org,
 Sebastian Ott <sebott@redhat.com>, Peter Maydell <peter.maydell@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org
References: <20240221063431.76992-1-shahuang@redhat.com>
 <ZfmtxxlATpvhK61y@redhat.com>
 <84e01fa8-0de6-4d2b-8696-53cd3c3f42fa@redhat.com>
 <ZfnUZKf3p8jv2yEM@redhat.com>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <ZfnUZKf3p8jv2yEM@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,

On 3/19/24 19:07, Daniel P. Berrangé wrote:
> On Tue, Mar 19, 2024 at 06:58:33PM +0100, Eric Auger wrote:
>> Hi Daniel,
>>
>> On 3/19/24 16:22, Daniel P. Berrangé wrote:
>>> On Wed, Feb 21, 2024 at 01:34:31AM -0500, Shaoqin Huang wrote:
>>>> The KVM_ARM_VCPU_PMU_V3_FILTER provides the ability to let the VMM decide
>>>> which PMU events are provided to the guest. Add a new option
>>>> `kvm-pmu-filter` as -cpu sub-option to set the PMU Event Filtering.
>>>> Without the filter, all PMU events are exposed from host to guest by
>>>> default. The usage of the new sub-option can be found from the updated
>>>> document (docs/system/arm/cpu-features.rst).
>>>>
>>>> Here is an example which shows how to use the PMU Event Filtering, when
>>>> we launch a guest by use kvm, add such command line:
>>>>
>>>>   # qemu-system-aarch64 \
>>>>         -accel kvm \
>>>>         -cpu host,kvm-pmu-filter="D:0x11-0x11"
>>>
>>> snip
>>>
>>>> @@ -517,6 +533,12 @@ void kvm_arm_add_vcpu_properties(ARMCPU *cpu)
>>>>                               kvm_steal_time_set);
>>>>      object_property_set_description(obj, "kvm-steal-time",
>>>>                                      "Set off to disable KVM steal time.");
>>>> +
>>>> +    object_property_add_str(obj, "kvm-pmu-filter", kvm_pmu_filter_get,
>>>> +                            kvm_pmu_filter_set);
>>>> +    object_property_set_description(obj, "kvm-pmu-filter",
>>>> +                                    "PMU Event Filtering description for "
>>>> +                                    "guest PMU. (default: NULL, disabled)");
>>>>  }
>>>
>>> Passing a string property, but....[1]
>>>
>>>>  
>>>>  bool kvm_arm_pmu_supported(void)
>>>> @@ -1706,6 +1728,62 @@ static bool kvm_arm_set_device_attr(ARMCPU *cpu, struct kvm_device_attr *attr,
>>>>      return true;
>>>>  }
>>>>  
>>>> +static void kvm_arm_pmu_filter_init(ARMCPU *cpu)
>>>> +{
>>>> +    static bool pmu_filter_init;
>>>> +    struct kvm_pmu_event_filter filter;
>>>> +    struct kvm_device_attr attr = {
>>>> +        .group      = KVM_ARM_VCPU_PMU_V3_CTRL,
>>>> +        .attr       = KVM_ARM_VCPU_PMU_V3_FILTER,
>>>> +        .addr       = (uint64_t)&filter,
>>>> +    };
>>>> +    int i;
>>>> +    g_auto(GStrv) event_filters;
>>>> +
>>>> +    if (!cpu->kvm_pmu_filter) {
>>>> +        return;
>>>> +    }
>>>> +    if (kvm_vcpu_ioctl(CPU(cpu), KVM_HAS_DEVICE_ATTR, &attr)) {
>>>> +        warn_report("The KVM doesn't support the PMU Event Filter!");
>>>
>>> If the user requested a filter and it can't be supported, QEMU
>>> must exit with an error, not ignore the user's request.
>>>
>>>> +        return;
>>>> +    }
>>>> +
>>>> +    /*
>>>> +     * The filter only needs to be initialized through one vcpu ioctl and it
>>>> +     * will affect all other vcpu in the vm.
>>>> +     */
>>>> +    if (pmu_filter_init) {
>>>> +        return;
>>>> +    } else {
>>>> +        pmu_filter_init = true;
>>>> +    }
>>>> +
>>>> +    event_filters = g_strsplit(cpu->kvm_pmu_filter, ";", -1);
>>>> +    for (i = 0; event_filters[i]; i++) {
>>>> +        unsigned short start = 0, end = 0;
>>>> +        char act;
>>>> +
>>>> +        if (sscanf(event_filters[i], "%c:%hx-%hx", &act, &start, &end) != 3) {
>>>> +            warn_report("Skipping invalid PMU filter %s", event_filters[i]);
>>>> +            continue;
>>>
>>> Warning on user syntax errors is undesirable - it should be a fatal
>>> error of the user gets this wrong.
>>>
>>>> +        }
>>>> +
>>>> +        if ((act != 'A' && act != 'D') || start > end) {
>>>> +            warn_report("Skipping invalid PMU filter %s", event_filters[i]);
>>>> +            continue;
>>>
>>> Likewise should be fatal.
>>>
>>>> +        }
>>>> +
>>>> +        filter.base_event = start;
>>>> +        filter.nevents = end - start + 1;
>>>> +        filter.action = (act == 'A') ? KVM_PMU_EVENT_ALLOW :
>>>> +                                       KVM_PMU_EVENT_DENY;
>>>> +
>>>> +        if (!kvm_arm_set_device_attr(cpu, &attr, "PMU_V3_FILTER")) {
>>>> +            break;
>>>> +        }
>>>> +    }
>>>> +}
>>>
>>> ..[1] then implementing a custom parser is rather a QEMU design anti-pattern,
>>> especially when the proposed syntax is incapable of being mapped into the
>>> normal QAPI syntax for a list of structs should we want to fully convert
>>> -cpu to QAPI parsing later. I wonder if can we model this property with
>>> QAPI now ?
>> I guess you mean creating a new property like those in
>> hw/core/qdev-properties-system.c for instance  and populating an array
>> of those at CPU object level?
> 
> Yeah, something like the IOThreadVirtQueueMapping data type would
> be the more QAPI like code pattern.
OK thank you for the confirmation. Then if we create such kind of
property it would be nice that this latter also matches the need of x86
PMU filtering. I think the uapi exists at KVM level but has never been
integrated in qemu.
> 
>> Note there is v8 but most of your comments still apply
>> https://lore.kernel.org/all/20240312074849.71475-1-shahuang@redhat.com/
> 
> Yes, sorry I just saw Peter's query about libvirt on this v7 and
> didn't think to look for a newer version

no problem. Thank you for your time

Eric
> 
> With regards,
> Daniel


