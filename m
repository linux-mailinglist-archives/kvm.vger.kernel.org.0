Return-Path: <kvm+bounces-3798-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A15CC8080E8
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 07:39:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2FCD1281AB6
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 06:39:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FA4C12B68;
	Thu,  7 Dec 2023 06:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dNZW04b7"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2FD3D7E
	for <kvm@vger.kernel.org>; Wed,  6 Dec 2023 22:39:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701931156;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y8D+mFANWyB/haCVfpYtD6jJQ+9h/Z7nGuaValDJ6r4=;
	b=dNZW04b7CL2dkzcO0SksPTyfVIqTRXl9BTIylp7yHaptk2WSMvUZZt+SOugvEPOTVzhJjX
	AP0DBhl8inlpZzsPc0MMySPijbtblCLLT//Cg5YG0sbf39+pWPaLV0Hdwr2UxAUaQ5Onqr
	D7/Sr5khNr/5vOh7eCjwhNMrmh+DQMQ=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-455-qPNIXhUYNeenrT0QHVtp-Q-1; Thu, 07 Dec 2023 01:39:14 -0500
X-MC-Unique: qPNIXhUYNeenrT0QHVtp-Q-1
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-2864977ba2dso186318a91.0
        for <kvm@vger.kernel.org>; Wed, 06 Dec 2023 22:39:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701930849; x=1702535649;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y8D+mFANWyB/haCVfpYtD6jJQ+9h/Z7nGuaValDJ6r4=;
        b=bbg0lPGU9R8hF70mh+Ooc3Q4bJI8lFa/McgPvtpTSXfnzrnOLYbcfT8iXCC9M49J5y
         w0vd4U20ox0/1wbtlrKZXG4e7jS+MCGQb/99wYuzioTZKX1hwv9j9xWNbWn7QKfVbBAd
         nnkwTDPn1iHhXptCuKkSewq6Fi+5QdMmrUq6EkkbPKy6epYAKkfhKgPHoSYYt5nsm7Fy
         nIBKu6Jtj9jx9h8KAZchw+4xFRZ0f5leFG9lzb1MYDCaFJfW9dnOLVKnFPQrr2Iy/PGX
         fJf9f0FVGvZaoShQXpgUBqx3fK0Lp68GTwsRrE6BdOYP/DfhgrXd82Zz43SF0o702OMa
         wGeQ==
X-Gm-Message-State: AOJu0YxId4EQxWXZ6NRldLUXdxAq89gv2FcBUjwBUNMrpT8c5R1tIPM/
	Eg2IdSMWJH4j8eCHi8b432RKbFUGL5UyAJWjBjkPBBldGoPRE5pbc4MdIHzxEDPaDB+GLtEMngK
	xx6FFwr6gunoJ
X-Received: by 2002:a05:6a21:6d9d:b0:18f:cc5f:ffe with SMTP id wl29-20020a056a216d9d00b0018fcc5f0ffemr3844399pzb.4.1701930848724;
        Wed, 06 Dec 2023 22:34:08 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGW8oXSj33tDxC+iF+W/2uB16UvzJufMLnit1Si6yUYE+keN07PeMbWZ+5sRopmpMxWeVQPBQ==
X-Received: by 2002:a05:6a21:6d9d:b0:18f:cc5f:ffe with SMTP id wl29-20020a056a216d9d00b0018fcc5f0ffemr3844384pzb.4.1701930848323;
        Wed, 06 Dec 2023 22:34:08 -0800 (PST)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id m9-20020a170902db0900b001cfce833b6fsm523677plx.204.2023.12.06.22.34.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Dec 2023 22:34:07 -0800 (PST)
Message-ID: <1d374fd6-72cd-cf0d-02bc-71d8e82b7c5f@redhat.com>
Date: Thu, 7 Dec 2023 14:34:04 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v3] arm/kvm: Enable support for KVM_ARM_VCPU_PMU_V3_FILTER
Content-Language: en-US
To: Gavin Shan <gshan@redhat.com>, qemu-arm@nongnu.org
Cc: eauger@redhat.com, Paolo Bonzini <pbonzini@redhat.com>,
 Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
 qemu-devel@nongnu.org
References: <20231129030827.2657755-1-shahuang@redhat.com>
 <3a0e0c48-3043-4330-b318-ec15c7ef0725@redhat.com>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <3a0e0c48-3043-4330-b318-ec15c7ef0725@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Gavin,

On 12/1/23 13:37, Gavin Shan wrote:
> Hi Shaoqin,
> 
> On 11/29/23 14:08, Shaoqin Huang wrote:
>> The KVM_ARM_VCPU_PMU_V3_FILTER provide the ability to let the VMM decide
>> which PMU events are provided to the guest. Add a new option
>> `pmu-filter` as -accel sub-option to set the PMU Event Filtering.
>> Without the filter, the KVM will expose all events from the host to
>> guest by default.
>>
>> The `pmu-filter` has such format:
>>
>>    pmu-filter="{A,D}:start-end[;{A,D}:start-end...]"
>>
>> The A means "allow" and D means "deny", start is the first event of the
>> range and the end is the last one. The first registered range defines
>> the global policy(global ALLOW if the first @action is DENY, global DENY
>> if the first @action is ALLOW). The start and end only support hex
>> format now. For example:
>>
>>    pmu-filter="A:0x11-0x11;A:0x23-0x3a;D:0x30-0x30"
>>
>> Since the first action is allow, we have a global deny policy. It
>> will allow event 0x11 (The cycle counter), events 0x23 to 0x3a is
>> also allowed except the event 0x30 is denied, and all the other events
>> are disallowed.
>>
>> Here is an real example shows how to use the PMU Event Filtering, when
>> we launch a guest by use kvm, add such command line:
>>
>>    # qemu-system-aarch64 \
>>     -accel kvm,pmu-filter="D:0x11-0x11"
>>
>> Since the first action is deny, we have a global allow policy. This
>> disables the filtering of the cycle counter (event 0x11 being 
>> CPU_CYCLES).
>>
>> And then in guest, use the perf to count the cycle:
>>
>>    # perf stat sleep 1
>>
>>     Performance counter stats for 'sleep 1':
>>
>>                1.22 msec task-clock                       #    0.001 
>> CPUs utilized
>>                   1      context-switches                 #  820.695 /sec
>>                   0      cpu-migrations                   #    0.000 /sec
>>                  55      page-faults                      #   45.138 
>> K/sec
>>     <not supported>      cycles
>>             1128954      instructions
>>              227031      branches                         #  186.323 
>> M/sec
>>                8686      branch-misses                    #    3.83% 
>> of all branches
>>
>>         1.002492480 seconds time elapsed
>>
>>         0.001752000 seconds user
>>         0.000000000 seconds sys
>>
>> As we can see, the cycle counter has been disabled in the guest, but
>> other pmu events are still work.
>>
>> Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
>> ---
>> v2->v3:
>>    - Improve commits message, use kernel doc wording, add more 
>> explaination on
>>      filter example, fix some typo error.                [Eric]
>>    - Add g_free() in kvm_arch_set_pmu_filter() to prevent memory leak. 
>> [Eric]
>>    - Add more precise error message report.              [Eric]
>>    - In options doc, add pmu-filter rely on KVM_ARM_VCPU_PMU_V3_FILTER 
>> support in
>>      KVM.                                                [Eric]
>>
>> v1->v2:
>>    - Add more description for allow and deny meaning in
>>      commit message.                                     [Sebastian]
>>    - Small improvement.                                  [Sebastian]
>>
>> v2: 
>> https://lore.kernel.org/all/20231117060838.39723-1-shahuang@redhat.com/
>> v1: 
>> https://lore.kernel.org/all/20231113081713.153615-1-shahuang@redhat.com/
>> ---
>>   include/sysemu/kvm_int.h |  1 +
>>   qemu-options.hx          | 21 +++++++++++++
>>   target/arm/kvm.c         | 23 ++++++++++++++
>>   target/arm/kvm64.c       | 68 ++++++++++++++++++++++++++++++++++++++++
>>   4 files changed, 113 insertions(+)
>>
>> diff --git a/include/sysemu/kvm_int.h b/include/sysemu/kvm_int.h
>> index fd846394be..8f4601474f 100644
>> --- a/include/sysemu/kvm_int.h
>> +++ b/include/sysemu/kvm_int.h
>> @@ -120,6 +120,7 @@ struct KVMState
>>       uint32_t xen_caps;
>>       uint16_t xen_gnttab_max_frames;
>>       uint16_t xen_evtchn_max_pirq;
>> +    char *kvm_pmu_filter;
>>   };
>>   void kvm_memory_listener_register(KVMState *s, KVMMemoryListener *kml,
>> diff --git a/qemu-options.hx b/qemu-options.hx
>> index 42fd09e4de..8b721d6668 100644
>> --- a/qemu-options.hx
>> +++ b/qemu-options.hx
>> @@ -187,6 +187,7 @@ DEF("accel", HAS_ARG, QEMU_OPTION_accel,
>>       "                tb-size=n (TCG translation block cache size)\n"
>>       "                dirty-ring-size=n (KVM dirty ring GFN count, 
>> default 0)\n"
>>       "                eager-split-size=n (KVM Eager Page Split chunk 
>> size, default 0, disabled. ARM only)\n"
>> +    "                pmu-filter={A,D}:start-end[;...] (KVM PMU Event 
>> Filter, default no filter. ARM only)\n"
>    ^^^^^^^
> 
> Potential alignment issue, or the email isn't shown for me correctly.
> Besides, why not follow the pattern in the commit log, which is nicer
> than what's of being:
> 
> pmu-filter={A,D}:start-end[;...]
> 
> to
> 
> pmu-filter="{A,D}:start-end[;{A,D}:start-end...]
> 

Ok. I can replace it with the better format.

>>       "                
>> notify-vmexit=run|internal-error|disable,notify-window=n (enable 
>> notify VM exit and set notify window, x86 only)\n"
>>       "                thread=single|multi (enable multi-threaded 
>> TCG)\n", QEMU_ARCH_ALL)
>>   SRST
>> @@ -259,6 +260,26 @@ SRST
>>           impact on the memory. By default, this feature is disabled
>>           (eager-split-size=0).
>> +    ``pmu-filter={A,D}:start-end[;...]``
>> +        KVM implements pmu event filtering to prevent a guest from 
>> being able to
>         ^^^^               ^^^^^^^^^^^^^^^^^^^
>         Alignment          "PMU Event Filtering" to be consistent
> 

Thanks for pointing it out. It should be an alignment issue. I will fix it.

>> +    sample certain events. It depends on the 
>> KVM_ARM_VCPU_PMU_V3_FILTER attr
>                                                                              ^^^^
>                                                                              attribute
>> +    supported in KVM. It has the following format:
>> +
>> +    pmu-filter="{A,D}:start-end[;{A,D}:start-end...]"
>> +
>> +    The A means "allow" and D means "deny", start is the first event 
>> of the
>> +    range and the end is the last one. The first registered range 
>> defines
>> +    the global policy(global ALLOW if the first @action is DENY, 
>> global DENY
>> +    if the first @action is ALLOW). The start and end only support hex
>> +    format now. For example:
>> +
>> +    pmu-filter="A:0x11-0x11;A:0x23-0x3a;D:0x30-0x30"
>> +
>> +    Since the first action is allow, we have a global deny policy. It
>> +    will allow event 0x11 (The cycle counter), events 0x23 to 0x3a is
>> +    also allowed except the event 0x30 is denied, and all the other 
>> events
>> +    are disallowed.
>> +
>>       ``notify-vmexit=run|internal-error|disable,notify-window=n``
>>           Enables or disables notify VM exit support on x86 host and 
>> specify
>>           the corresponding notify window to trigger the VM exit if 
>> enabled.
>> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
>> index 7903e2ddde..116a0d3d2b 100644
>> --- a/target/arm/kvm.c
>> +++ b/target/arm/kvm.c
>> @@ -1108,6 +1108,22 @@ static void 
>> kvm_arch_set_eager_split_size(Object *obj, Visitor *v,
>>       s->kvm_eager_split_size = value;
>>   }
>> +static char *kvm_arch_get_pmu_filter(Object *obj, Error **errp)
>> +{
>> +    KVMState *s = KVM_STATE(obj);
>> +
>> +    return g_strdup(s->kvm_pmu_filter);
>> +}
>> +
>> +static void kvm_arch_set_pmu_filter(Object *obj, const char *pmu_filter,
>> +                                    Error **errp)
>> +{
>> +    KVMState *s = KVM_STATE(obj);
>> +
>> +    g_free(s->kvm_pmu_filter);
>> +    s->kvm_pmu_filter = g_strdup(pmu_filter);
>> +}
>> +
>>   void kvm_arch_accel_class_init(ObjectClass *oc)
>>   {
>>       object_class_property_add(oc, "eager-split-size", "size",
>> @@ -1116,4 +1132,11 @@ void kvm_arch_accel_class_init(ObjectClass *oc)
>>       object_class_property_set_description(oc, "eager-split-size",
>>           "Eager Page Split chunk size for hugepages. (default: 0, 
>> disabled)");
>> +
>> +    object_class_property_add_str(oc, "pmu-filter",
>> +                                  kvm_arch_get_pmu_filter,
>> +                                  kvm_arch_set_pmu_filter);
>> +
>> +    object_class_property_set_description(oc, "pmu-filter",
>> +        "PMU Event Filtering description for guest pmu. (default: 
>> NULL, disabled)");
>                                                        ^^^
>                                                        PMU

Got it.

>>   }
>> diff --git a/target/arm/kvm64.c b/target/arm/kvm64.c
>> index 3c175c93a7..7947b83b36 100644
>> --- a/target/arm/kvm64.c
>> +++ b/target/arm/kvm64.c
>> @@ -10,6 +10,7 @@
>>    */
>>   #include "qemu/osdep.h"
>> +#include <asm-arm64/kvm.h>
>>   #include <sys/ioctl.h>
>>   #include <sys/ptrace.h>
>> @@ -131,6 +132,70 @@ static bool kvm_arm_set_device_attr(CPUState *cs, 
>> struct kvm_device_attr *attr,
>>       return true;
>>   }
>> +static void kvm_arm_pmu_filter_init(CPUState *cs)
>> +{
>> +    static bool pmu_filter_init = false;
>> +    struct kvm_pmu_event_filter filter;
>> +    struct kvm_device_attr attr = {
>> +        .group      = KVM_ARM_VCPU_PMU_V3_CTRL,
>> +        .attr       = KVM_ARM_VCPU_PMU_V3_FILTER,
>> +        .addr       = (uint64_t)&filter,
>> +    };
>> +    KVMState *kvm_state = cs->kvm_state;
> 
> I would move @kvm_state to the beginning of the function since it's the 
> container
> to everything else.
> 

Ok. I can move it to the first.

>> +    char *tmp;
>> +    char *str, act;
>> +
>> +    if (!kvm_state->kvm_pmu_filter)
>> +        return;
>> +
>> +    if (kvm_vcpu_ioctl(cs, KVM_HAS_DEVICE_ATTR, attr)) {
>> +        error_report("The kernel doesn't support the pmu event 
>> filter!\n");
>> +        abort();
>> +    }
>> +
> 
> s/attr/&attr ?
> 

It should be &attr.

> The connection between vCPU and attribute query was set up in Linux 
> v4.10 by
> commit f577f6c2a6a ("arm64: KVM: Introduce per-vcpu kvm device 
> controls"), and
> the capability depends on KVM_CAP_VCPU_ATTRIBUTES. I think 
> KVM_CAP_VCPU_ATTRIBUTES
> needs to be checked prior to kvm_vcpu_ioctl(cs, KVM_HAS_DEVICE_ATTR, ...)
> 

I searched the KVM_CAP_VCPU_ATTRIBUTES, no where check the capability. 
And the current usage of KVM_HAS_DEVICE_ATTR never check the 
KVM_CAP_VCPU_ATTRIBUTES. I guess we don't need it.

> Besides, the PMU Event Filtering was introduced to Linux v4.10. It means 
> the user
> can crash qemu when "pmu-filter" is provided on Linux v4.9. So the 
> correct behavior
> would be warning and ignore "pmu-filter" since it's an add-on and 
> best-effort
> feature.

Thanks for pointing this out, I think it's reasonable. I can replace all 
error_report with wran_report and replace delete all abort().

> 
> 
>> +    /* The filter only needs to be initialized for 1 vcpu. */
>> +    if (!pmu_filter_init)
>> +        pmu_filter_init = true;
>> +
> 
> { } has been missed. QEMU needs it even for the block with single line 
> of code.
> 

Ok. I will add it.

>> +    tmp = g_strdup(kvm_state->kvm_pmu_filter);
>> +
>> +    for (str = strtok(tmp, ";"); str != NULL; str = strtok(NULL, ";")) {
>> +        unsigned short start = 0, end = 0;
>> +
>> +        sscanf(str, "%c:%hx-%hx", &act, &start, &end);
>> +        if ((act != 'A' && act != 'D') || (!start && !end)) {
>> +            error_report("skipping invalid filter %s\n", str);
>> +            continue;
>> +        }
>> +
>> +        filter = (struct kvm_pmu_event_filter) {
>> +            .base_event     = start,
>> +            .nevents        = end - start + 1,
>> +            .action         = act == 'A' ? KVM_PMU_EVENT_ALLOW :
>> +                                           KVM_PMU_EVENT_DENY,
>> +        };
>> +
>> +        if (!kvm_arm_set_device_attr(cs, &attr, "PMU Event Filter")) {
>> +            if (errno == EINVAL)
>> +                error_report("Invalid filter range [0x%x-0x%x]. "
>> +                             "ARMv8.0 support 10 bits event space, "
>> +                             "ARMv8.1 support 16 bits event space",
>> +                             start, end);
>> +            else if (errno == ENODEV)
>> +                error_report("GIC not initialized");
>> +            else if (errno == ENXIO)
>> +                error_report("PMUv3 not properly configured or 
>> in-kernel irqchip "
>> +                             "not configured.");
>> +            else if (errno == EBUSY)
>> +                error_report("PMUv3 already initialized or a VCPU has 
>> already run");
>> +
>> +            abort();
>> +        }
>> +    }
>> +
>> +    g_free(tmp);
>> +}
>> +
> 
> { } has been missed.
> 
> g_strsplit() may be good fit to parse "pmu-filter". 
> cpu-target.c::parse_cpu_option()
> is the example for its usage.
> 

Ok. I can follow the implementation. It actually much simpler.

> As I explained above, it wouldn't a "abort()" since "pmu-filter" is an 
> add-on and
> best-effort attempt. We probably just warn done by warn_report() instead 
> of raising
> error if the PMU Event Filter fails to be set.
> 

Will do that.

Thanks,
Shaoqin

>>   void kvm_arm_pmu_init(CPUState *cs)
>>   {
>>       struct kvm_device_attr attr = {
>> @@ -141,6 +206,9 @@ void kvm_arm_pmu_init(CPUState *cs)
>>       if (!ARM_CPU(cs)->has_pmu) {
>>           return;
>>       }
>> +
>> +    kvm_arm_pmu_filter_init(cs);
>> +
>>       if (!kvm_arm_set_device_attr(cs, &attr, "PMU")) {
>>           error_report("failed to init PMU");
>>           abort();
> 
> Thanks,
> Gavin
> 

-- 
Shaoqin


