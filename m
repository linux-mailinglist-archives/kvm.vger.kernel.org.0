Return-Path: <kvm+bounces-7084-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E48F283D57F
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 10:07:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 150BF1C25CDD
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 09:07:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3629F64CD9;
	Fri, 26 Jan 2024 07:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gGp6awA8"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41043125B2
	for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 07:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706255892; cv=none; b=d8th13oB9on2gKxx+2+6LlaSu/Aabajk7CQfRqOsnFArLdcmFreQZ0fhr8zcKP1teKmcd9KX6Q1AsVeIQ1k6YFfxFH1FAGUqaIL4EMf/Qin1hXr9WWpKgKlf8xso5ofD7GX00Vvpu2jQWk1Yatd/kDH3Ne7PK48Q6X/A9K2UbN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706255892; c=relaxed/simple;
	bh=9KOFiR+FOlFWCaG0BfZPDZm6LpkATM1dsoSh+gTfx84=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PT1qb2lBG9lPxEwYyVCRbGxVmGfDOt8vywnKsn6hSS4GKAj3eoKP+I7/utRlJPRSqnLCXmY6pbgEsyjNpWfDPFqE7OKSiyl3Ahn+f3GFmUaKoZCz2Leg4KFO6x7Kk0ffWfaIth4woSp3AFQupxwzDNGaZxzJyCcfWUrLUAjI+SM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gGp6awA8; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706255888;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D3Buiu182838u1oatISapL/bAKzONckxOrRoF1t1zgM=;
	b=gGp6awA8dMPSK2wbnODXn3rIBlzl7U6kf+4eLiNeA4S1JSFvbAvIb03XHpegqkKo+yvLKw
	/tQ+oNdD3CiPuyN9KiXcPFge6NyOMwYvDYf6p5GOYdlt1/BzChEQ4VCEYd9EjGcK6qfg58
	TuOpnLjCC/Pqh8R5uM8P3nMJlzgmH8Q=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-561-OcDfSXF_NhyrcC6OPyWAbg-1; Fri, 26 Jan 2024 02:58:06 -0500
X-MC-Unique: OcDfSXF_NhyrcC6OPyWAbg-1
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-5cf53f904f9so1995a12.1
        for <kvm@vger.kernel.org>; Thu, 25 Jan 2024 23:58:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706255886; x=1706860686;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=D3Buiu182838u1oatISapL/bAKzONckxOrRoF1t1zgM=;
        b=nOxwU7VujOpRRRPJdpOXBevnzZ54M1UNfdmm9bdvm8VnKWe1sHr8SoDXJWmzpE6YFo
         hSHgHFnZUVkKVck0JNV+alxIWfczAKLOXL++YE4cbzU/GmcNb4K/DPJk5vxZu2DKpunE
         7N83gi5ctdz0VW1iAnCOq4+S4HdCP2DDN1zf6Brjd6hTYH/We0FSi48skL2FXAtpc6w5
         GjB/AN3x2wVHPSP2Z5MO4cL7fqVMcrdZEfQYQqWCDBDfSY9YQYAeboEFuF6Ff/hTH2SB
         47Mg/+cw6/3vZYR+xB/BStE7DV7aDKOdx72fnokKrz/K9J7qRbKHDmZ0brzJQySIrgod
         xniA==
X-Forwarded-Encrypted: i=0; AJvYcCVHdqpAFk63sBNsAcv3uwEQWDDkdxzsyq8md8hErZDWmT9qnLPWWiyZL6WuO1Qe+VtcBpTFIzrRSEvpX0D4g4O47eJ4
X-Gm-Message-State: AOJu0YxAKDHAfar92B/WTywk+ZyuBhsOKB4LdaFlx8giP9Mg+sT1jQsn
	iMwwUKvwv1t6yId7jZmsHVMUJFUjfOO+qRYDcTWNOLqpk9NLlLq2VUv9NU30jgM0U72UGgYYVAv
	bHfFxhZDZNGofVrdMo97fkeFVBZNhfsNXO0OvNAcsdkkLIpvXZQ==
X-Received: by 2002:a05:6a20:438b:b0:19a:40f3:e460 with SMTP id i11-20020a056a20438b00b0019a40f3e460mr1900200pzl.2.1706255885823;
        Thu, 25 Jan 2024 23:58:05 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHMjzHrrTDlQTWUlAVe3VC27ZolQDRB8EJaUUcRXrUas+YYiVfkyB7k5Pl4uVIFuaUmINrUxA==
X-Received: by 2002:a05:6a20:438b:b0:19a:40f3:e460 with SMTP id i11-20020a056a20438b00b0019a40f3e460mr1900188pzl.2.1706255885305;
        Thu, 25 Jan 2024 23:58:05 -0800 (PST)
Received: from [10.72.116.129] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id x5-20020a17090a388500b00290f8afd8acsm696483pjb.47.2024.01.25.23.58.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jan 2024 23:58:04 -0800 (PST)
Message-ID: <19930d3f-d7ef-44ed-aee1-e3537d973cf8@redhat.com>
Date: Fri, 26 Jan 2024 15:58:00 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] arm/kvm: Enable support for KVM_ARM_VCPU_PMU_V3_FILTER
To: Eric Auger <eauger@redhat.com>, qemu-arm@nongnu.org
Cc: Gavin Shan <gshan@redhat.com>, Peter Maydell <peter.maydell@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org
References: <20240115080144.44944-1-shahuang@redhat.com>
 <852ee2a3-b69f-4480-a6f4-f2b274f5e01c@redhat.com>
Content-Language: en-US
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <852ee2a3-b69f-4480-a6f4-f2b274f5e01c@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Eric,

On 1/17/24 20:59, Eric Auger wrote:
> Hi  Shaoqin,
> 
> On 1/15/24 09:01, Shaoqin Huang wrote:
>> The KVM_ARM_VCPU_PMU_V3_FILTER provides the ability to let the VMM decide
>> which PMU events are provided to the guest. Add a new option
>> `kvm-pmu-filter` as -cpu sub-option to set the PMU Event Filtering.
>> Without the filter, all PMU events are exposed from host to guest by
>> default. The usage of the new sub-option can be found from the updated
>> document (docs/system/arm/cpu-features.rst).
> 
> do not hesitate to cc qemu-arm@nongnu.org for ARM specific topics.
> 
>>
>> Here is an example shows how to use the PMU Event Filtering, when
> which shows
>> we launch a guest by use kvm, add such command line:
>>
>>    # qemu-system-aarch64 \
>>          -accel kvm \
>>          -cpu host,kvm-pmu-filter="D:0x11-0x11"
>>
>> Since the first action is deny, we have a global allow policy. This
>> disables the filtering of the cycle counter (event 0x11 being CPU_CYCLES).
> Actually it filters it ;-) It would rather say this filters out the
> cycle counter. But I am not a native speaker either ;-)
>>
>> And then in guest, use the perf to count the cycle:
>>
>>    # perf stat sleep 1
>>
>>     Performance counter stats for 'sleep 1':
>>
>>                1.22 msec task-clock                       #    0.001 CPUs utilized
>>                   1      context-switches                 #  820.695 /sec
>>                   0      cpu-migrations                   #    0.000 /sec
>>                  55      page-faults                      #   45.138 K/sec
>>     <not supported>      cycles
>>             1128954      instructions
>>              227031      branches                         #  186.323 M/sec
>>                8686      branch-misses                    #    3.83% of all branches
>>
>>         1.002492480 seconds time elapsed
>>
>>         0.001752000 seconds user
>>         0.000000000 seconds sys
>>
>> As we can see, the cycle counter has been disabled in the guest, but
>> other pmu events are still work.
> do still work
>>
>> Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
>> ---
>> v4->v5:
>>    - Change the kvm-pmu-filter as a -cpu sub-option.     [Eric]
>>    - Comment tweak.                                      [Gavin]
>>    - Rebase to the latest branch.
>>
>> v3->v4:
>>    - Fix the wrong check for pmu_filter_init.            [Sebastian]
>>    - Fix multiple alignment issue.                       [Gavin]
>>    - Report error by warn_report() instead of error_report(), and don't use
>>    abort() since the PMU Event Filter is an add-on and best-effort feature.
>>                                                          [Gavin]
>>    - Add several missing {  } for single line of code.   [Gavin]
>>    - Use the g_strsplit() to replace strtok().           [Gavin]
>>
>> v2->v3:
>>    - Improve commits message, use kernel doc wording, add more explaination on
>>      filter example, fix some typo error.                [Eric]
>>    - Add g_free() in kvm_arch_set_pmu_filter() to prevent memory leak. [Eric]
>>    - Add more precise error message report.              [Eric]
>>    - In options doc, add pmu-filter rely on KVM_ARM_VCPU_PMU_V3_FILTER support in
>>      KVM.                                                [Eric]
>>
>> v1->v2:
>>    - Add more description for allow and deny meaning in
>>      commit message.                                     [Sebastian]
>>    - Small improvement.                                  [Sebastian]
>>
>>   docs/system/arm/cpu-features.rst | 23 ++++++++++
>>   include/sysemu/kvm_int.h         |  1 +
>>   target/arm/cpu.h                 |  3 ++
>>   target/arm/kvm.c                 | 78 ++++++++++++++++++++++++++++++++
>>   4 files changed, 105 insertions(+)
>>
>> diff --git a/docs/system/arm/cpu-features.rst b/docs/system/arm/cpu-features.rst
>> index a5fb929243..44a797c50e 100644
>> --- a/docs/system/arm/cpu-features.rst
>> +++ b/docs/system/arm/cpu-features.rst
>> @@ -204,6 +204,29 @@ the list of KVM VCPU features and their descriptions.
>>     the guest scheduler behavior and/or be exposed to the guest
>>     userspace.
>>   
>> +``kvm-pmu-filter``
>> +  By default kvm-pmu-filter is disabled. This means that by default all pmu
>> +  events will be exposed to guest.
>> +
>> +  KVM implements PMU Event Filtering to prevent a guest from being able to
>> +  sample certain events. It depends on the KVM_ARM_VCPU_PMU_V3_FILTER
>> +  attribute supported in KVM. It has the following format:
>> +
>> +  kvm-pmu-filter="{A,D}:start-end[;{A,D}:start-end...]"
>> +
>> +  The A means "allow" and D means "deny", start is the first event of the
>> +  range and the end is the last one. The first registered range defines
>> +  the global policy(global ALLOW if the first @action is DENY, global DENY
>> +  if the first @action is ALLOW). The start and end only support hexadecimal
>> +  format now. For example:
>> +
>> +  kvm-pmu-filter="A:0x11-0x11;A:0x23-0x3a;D:0x30-0x30"
>> +
>> +  Since the first action is allow, we have a global deny policy. It
>> +  will allow event 0x11 (The cycle counter), events 0x23 to 0x3a is
> s/is/are
>> +  also allowed except the event 0x30 is denied, and all the other events
> 0x30 is/0x30 which is
>> +  are disallowed.
> s/disallowed/denied just to match the above terminology.
>> +
>>   TCG VCPU Features
>>   =================
>>   
>> diff --git a/include/sysemu/kvm_int.h b/include/sysemu/kvm_int.h
>> index fd846394be..8f4601474f 100644
>> --- a/include/sysemu/kvm_int.h
>> +++ b/include/sysemu/kvm_int.h
>> @@ -120,6 +120,7 @@ struct KVMState
>>       uint32_t xen_caps;
>>       uint16_t xen_gnttab_max_frames;
>>       uint16_t xen_evtchn_max_pirq;
>> +    char *kvm_pmu_filter;
> I think this is not needed anymore
>>   };
>>   
>>   void kvm_memory_listener_register(KVMState *s, KVMMemoryListener *kml,
>> diff --git a/target/arm/cpu.h b/target/arm/cpu.h
>> index 8c3ca2e231..1be7dca4aa 100644
>> --- a/target/arm/cpu.h
>> +++ b/target/arm/cpu.h
>> @@ -971,6 +971,9 @@ struct ArchCPU {
>>   
>>       /* KVM steal time */
>>       OnOffAuto kvm_steal_time;
>> +
>> +    /* KVM PMU Filter */
>> +    char *kvm_pmu_filter;
>>   #endif /* CONFIG_KVM */
>>   
>>       /* Uniprocessor system with MP extensions */
>> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
>> index c5a3183843..413ee2720e 100644
>> --- a/target/arm/kvm.c
>> +++ b/target/arm/kvm.c
>> @@ -495,6 +495,22 @@ static void kvm_steal_time_set(Object *obj, bool value, Error **errp)
>>       ARM_CPU(obj)->kvm_steal_time = value ? ON_OFF_AUTO_ON : ON_OFF_AUTO_OFF;
>>   }
>>   
>> +static char *kvm_pmu_filter_get(Object *obj, Error **errp)
>> +{
>> +    ARMCPU *cpu = ARM_CPU(obj);
>> +
>> +    return g_strdup(cpu->kvm_pmu_filter);
>> +}
>> +
>> +static void kvm_pmu_filter_set(Object *obj, const char *pmu_filter,
>> +                               Error **errp)
>> +{
>> +    ARMCPU *cpu = ARM_CPU(obj);
>> +
>> +    g_free(cpu->kvm_pmu_filter);
>> +    cpu->kvm_pmu_filter = g_strdup(pmu_filter);
>> +}
>> +
>>   /* KVM VCPU properties should be prefixed with "kvm-". */
>>   void kvm_arm_add_vcpu_properties(ARMCPU *cpu)
>>   {
>> @@ -516,6 +532,12 @@ void kvm_arm_add_vcpu_properties(ARMCPU *cpu)
>>                                kvm_steal_time_set);
>>       object_property_set_description(obj, "kvm-steal-time",
>>                                       "Set off to disable KVM steal time.");
>> +
>> +    object_property_add_str(obj, "kvm-pmu-filter", kvm_pmu_filter_get,
>> +                            kvm_pmu_filter_set);
>> +    object_property_set_description(obj, "kvm-pmu-filter",
>> +                                    "PMU Event Filtering description for "
>> +                                    "guest PMU. (default: NULL, disabled)");
>>   }
>>   
>>   bool kvm_arm_pmu_supported(void)
>> @@ -1705,6 +1727,60 @@ static bool kvm_arm_set_device_attr(ARMCPU *cpu, struct kvm_device_attr *attr,
>>       return true;
>>   }
>>   
>> +static void kvm_arm_pmu_filter_init(ARMCPU *cpu)
>> +{
>> +    static bool pmu_filter_init;
>> +    struct kvm_pmu_event_filter filter;
>> +    struct kvm_device_attr attr = {
>> +        .group      = KVM_ARM_VCPU_PMU_V3_CTRL,
>> +        .attr       = KVM_ARM_VCPU_PMU_V3_FILTER,
>> +        .addr       = (uint64_t)&filter,
>> +    };
>> +    int i;
>> +    gchar **event_filters;
> wonder if you couldn't use g_auto(GStrv) event_filters with auto
> cleenup? examples in qom/object.c for instance
>> +
>> +    if (!cpu->kvm_pmu_filter) {
>> +        return;
>> +    }
>> +    if (kvm_vcpu_ioctl(CPU(cpu), KVM_HAS_DEVICE_ATTR, &attr)) {
>> +        warn_report("The KVM doesn't support the PMU Event Filter!");
>> +        return;
>> +    }
>> +
>> +    /*
>> +     * The filter only needs to be initialized through one vcpu ioctl and it
>> +     * will affect all other vcpu in the vm.
>> +     */
>> +    if (pmu_filter_init) {
> I think I commented on that on the v4. Maybe I missed your reply. You
> sure you don't need to call it for each vcpu?
> 
>> +        return;
>> +    } else {
>> +        pmu_filter_init = true;
>> +    }
>> +
>> +    event_filters = g_strsplit(cpu->kvm_pmu_filter, ";", -1);
>> +    for (i = 0; event_filters[i]; i++) {
>> +        unsigned short start = 0, end = 0;
>> +        char act;
>> +
>> +        sscanf(event_filters[i], "%c:%hx-%hx", &act, &start, &end);
>> +        if ((act != 'A' && act != 'D') || (!start && !end)) {
>> +            warn_report("Skipping invalid PMU filter %s", event_filters[i]);
>> +            continue;
>> +        }
>> +
>> +        filter.base_event = start;
>> +        filter.nevents = end - start + 1;
>> +        filter.action = (act == 'A') ? KVM_PMU_EVENT_ALLOW :
>> +                                       KVM_PMU_EVENT_DENY;
>> +
>> +        if (!kvm_arm_set_device_attr(cpu, &attr, "PMU Event Filter")) {
> Nit: maybe s/PMU Event Filter/PMU_V3_FILTER
>> +            break;
>> +        }
>> +    }
>> +
>> +    g_strfreev(event_filters);
>> +}
>> +
>>   void kvm_arm_pmu_init(ARMCPU *cpu)
>>   {
>>       struct kvm_device_attr attr = {
>> @@ -1715,6 +1791,8 @@ void kvm_arm_pmu_init(ARMCPU *cpu)
>>       if (!cpu->has_pmu) {
>>           return;
>>       }
>> +
>> +    kvm_arm_pmu_filter_init(cpu);
>>       if (!kvm_arm_set_device_attr(cpu, &attr, "PMU")) {
>>           error_report("failed to init PMU");
>>           abort();
> Along with this new vcpu feature you may want to add a test like what
> was done in 68970d1e0d07 ("hw/arm/virt: Implement kvm-steal-time"), in
> tests/qtest/arm-cpu-features.c
> 

I have some doubts about adding the qtest into the qtest/arm-cpu-features.c.

When I use the 'query-cpu-model-expansion' to query the cpu-features, 
the kvm-pmu-filter will not shown in the returned results, just like below.

{'execute': 'query-cpu-model-expansion', 'arguments': {'type': 'full', 
'model': { 'name': 'host'}}}{"return": {}}

{"return": {"model": {"name": "host", "props": {"sve768": false, 
"sve128": false, "sve1024": false, "sve1280": false, "sve896": false, 
"sve256": false, "sve1536": false, "sve1792": false, "sve384": false, 
"sve": false, "sve2048": false, "pauth": false, "kvm-no-adjvtime": 
false, "sve512": false, "aarch64": true, "pmu": true, "sve1920": false, 
"sve1152": false, "kvm-steal-time": true, "sve640": false, "sve1408": 
false, "sve1664": false}}}}

I'm not sure if it's because the `query-cpu-model-expansion` only return 
the feature which is bool. Since the kvm-pmu-filter is a str, it won't 
be recognized as a feature. As a result, we don't have the way add new 
test like other cpu feature.

Do you have any suggestions?

Thanks,
Shaoqin


> Thanks
> 
> Eric
> 

-- 
Shaoqin


