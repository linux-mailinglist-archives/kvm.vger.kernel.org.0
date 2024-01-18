Return-Path: <kvm+bounces-6418-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D80A2831597
	for <lists+kvm@lfdr.de>; Thu, 18 Jan 2024 10:15:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 90CE52846D8
	for <lists+kvm@lfdr.de>; Thu, 18 Jan 2024 09:15:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7A5A1BC33;
	Thu, 18 Jan 2024 09:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WRhnItv1"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 545BE13FF8
	for <kvm@vger.kernel.org>; Thu, 18 Jan 2024 09:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705569338; cv=none; b=TViAlt0Y0cmhh6UtNyLp2kBe10JpAbfk7E0tHxp8xlYMFYPhdNcbLODSav47TnpPdivUouu35Qzkq5Gv8Urngf0U9Yl0WSeJjF0mKAytdfxktErJKkEJ7kWz7MOddYtnxPRgLPSRXAuDRARKuIb3MTofzrUwLgv3SI10wXN+/7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705569338; c=relaxed/simple;
	bh=j1EyYOqT4NW0UWWbUHaQWToqyvyIZzEuZLX5je+IXig=;
	h=DKIM-Signature:Received:X-MC-Unique:Received:
	 X-Google-DKIM-Signature:X-Gm-Message-State:X-Received:
	 X-Google-Smtp-Source:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:Content-Language:To:Cc:References:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding; b=YhlFLDwYPlFuPinzBS6NPRHUZBSOB7TarsyRe9GVTY7oBqeVyV0Rg7wkNuJs+6urC7Axv7cXGGbBxVb6dhsaQIRIpzMRP/2EkmIkvsDboOixuoXS1FDuIJPsBOW+GVmgj8XeSeGJ2u0/9+8CHcZItbZRGF+JoCPPr2/i6/xGFrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WRhnItv1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705569335;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KwCd7826almhpSf/b29InQHhw76eQACzSTc5c4HWA5c=;
	b=WRhnItv1BOdBoFXlC2yPA/hA69U/rGdAfXvZeG9uU6OTJ1J+8wB8YzoSBzAGMp76MvJIlx
	Oueopf33ILv/wjG0eFMF91GS6oemLyGmvBqWXJCJeByvwExNSRxNVufo1gCLyvmioKQM+d
	b1IBtem7swXY1dJrHwaGlpgZ6u4kd9s=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-619-8Nil20aNOP6YDZbLEiTgRg-1; Thu, 18 Jan 2024 04:15:33 -0500
X-MC-Unique: 8Nil20aNOP6YDZbLEiTgRg-1
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-5cf474e52c6so199344a12.0
        for <kvm@vger.kernel.org>; Thu, 18 Jan 2024 01:15:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705569332; x=1706174132;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KwCd7826almhpSf/b29InQHhw76eQACzSTc5c4HWA5c=;
        b=QvJxnuujBQp+3SK1MXhXmDtQQI+qglJ8ZEGe387HS0a2ifx6PsLDDysWeSZVdoBYmt
         23GPd1nUmaI3JA6E+QwOAtsfwTIdj13ci3Sw9Mewuj56e3lZJn6QGYWXlVzs+Er9Kh8/
         lvkbPCxm2ZhGOU6bDofMLgaerMasrXOF03e9kIgsOXO5VM4eAypep8Tl3nc8CTLtMnjA
         d4Om8JeE0iS800vgRMT3nydpEOU/pfs6xwzBQCqRk/A4QKS9htmPY1RGU/3HlMwEfj93
         MQGGI9eFOcfG2+pSTIIwczLyd1vnIJat+otTnmIUpH5VMZGVD5ZQQ5QQW3c//QuA3ouV
         7JFQ==
X-Gm-Message-State: AOJu0YwI+ThBGHAFLy9oYDTr968pW7aBhKsmb3k3kAR9AzSMpzF5EPtg
	8amJINUzLIuEpD3S4ksQNl22p+tkmOLk6wlz0prGE4auMMpGaMj7FqGATRu3ewg3z/oOsagUKY9
	ZD3sgMwrbabCMyNHmFIwVremt3QSuRoP7s5O1fD7YxvS+d7sNyA==
X-Received: by 2002:a17:903:41c7:b0:1d4:e308:cb0d with SMTP id u7-20020a17090341c700b001d4e308cb0dmr1042775ple.5.1705569331870;
        Thu, 18 Jan 2024 01:15:31 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEaRAFhwcG1uIdnAdwwoUauHw1P3VNDBUj8w5Rtv+6wU/DUr5NOUQ6bsKvljWSLHZUsk0PSqA==
X-Received: by 2002:a17:903:41c7:b0:1d4:e308:cb0d with SMTP id u7-20020a17090341c700b001d4e308cb0dmr1042763ple.5.1705569331419;
        Thu, 18 Jan 2024 01:15:31 -0800 (PST)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id n9-20020a170902d0c900b001d706c17af2sm751174pln.268.2024.01.18.01.15.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jan 2024 01:15:30 -0800 (PST)
Message-ID: <bebf1bfc-8f51-4e30-af33-9b3f276ad3ee@redhat.com>
Date: Thu, 18 Jan 2024 17:15:27 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] arm/kvm: Enable support for KVM_ARM_VCPU_PMU_V3_FILTER
Content-Language: en-US
To: Eric Auger <eauger@redhat.com>, qemu-arm@nongnu.org
Cc: Gavin Shan <gshan@redhat.com>, Peter Maydell <peter.maydell@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org
References: <20240115080144.44944-1-shahuang@redhat.com>
 <852ee2a3-b69f-4480-a6f4-f2b274f5e01c@redhat.com>
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

Thanks for pointing it. It should be deleted.

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

I can take a look of it.

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

 From the document we know that set the pmu_filter through one vcpu 
ioctl but it will take effect on the entire vm.

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

Ok. I can add a new test and repost it. And I will fix all errors 
pointed by you. Thanks for your reviewing.

> Thanks
> 
> Eric
> 

-- 
Shaoqin


