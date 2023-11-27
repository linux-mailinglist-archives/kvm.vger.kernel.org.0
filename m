Return-Path: <kvm+bounces-2505-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CF5A27F9CEF
	for <lists+kvm@lfdr.de>; Mon, 27 Nov 2023 10:54:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 166CDB20CF0
	for <lists+kvm@lfdr.de>; Mon, 27 Nov 2023 09:54:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15E731798E;
	Mon, 27 Nov 2023 09:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Pj5ZfADw"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E3CFF0
	for <kvm@vger.kernel.org>; Mon, 27 Nov 2023 01:54:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701078868;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cM/r8MzsZGaaTECTb4VwCyR2TWXt7Icsvks5c3ZwKVc=;
	b=Pj5ZfADwlFvdjHA7i2odMKauV2vyj+zx/AKPj5WkthwSKpXlB0QP43+Z/UZiJmM3YKeN6N
	4ZKzJaldQEfZPxnbRjGd0gugpeupyzgKMr7GN9MYjAAL3dq6qNEe6h8fFL4vXsr9tyvMX9
	nNU627zMKEh2upHgruHHiMSa6AqpDSM=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-501-B7BlvtTCO8eFIwzna1uv9w-1; Mon, 27 Nov 2023 04:54:24 -0500
X-MC-Unique: B7BlvtTCO8eFIwzna1uv9w-1
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-285bec90888so362318a91.0
        for <kvm@vger.kernel.org>; Mon, 27 Nov 2023 01:54:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701078863; x=1701683663;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cM/r8MzsZGaaTECTb4VwCyR2TWXt7Icsvks5c3ZwKVc=;
        b=Jb3bEgDKXildhholn5ldAIByv0Qp8Euy2B0QTgauGn+PRCTysM/ZCCFh+XttMTiaVE
         wf/jVVuj4eqN2i+PMEiL9u8sbFCD4Bz6w16es9rPEv+K786qrXBWqzzIR/rIHL5aVECc
         ET+TJxUCG4guZIJ3V1F89PmYd3uNdhMJZKUKd6fcguzaek7PUCg7H3xeA7V/K1fXh1v+
         MULKio5Rk3emTQru6o2RIwsZMPdmhEr8z2AGoAEk/qtlpFc3avxeM1VMLULRNFFKnVxc
         IV4B+I2/iu6PACrjV4MWa2+UnQNx6adMSxx6nbEPbYPoYVejkhJJjQXYpEt9UET+TUZm
         we4Q==
X-Gm-Message-State: AOJu0YxXgohi5W3h+PAS0p9uPs06T5xVwOHgiqIsrUFtdzhJ1A5y4H/h
	YIMA2QYkqKuae2lKKLxBFedPX0bcJrorCz3F/rFTtHq1QAukIHOzCb4+jbI2WWUaaoAQNJ8wvQ4
	gc8ceJtgwF66j
X-Received: by 2002:a17:903:2308:b0:1ce:2fc1:60ef with SMTP id d8-20020a170903230800b001ce2fc160efmr12497967plh.0.1701078863269;
        Mon, 27 Nov 2023 01:54:23 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFmyQ5vYknKazaiYRzfPMmlTZI4Y2vti37sd7I1XRJvOcAr1efGDRk0xXmMRFKdTQeTAp1jsA==
X-Received: by 2002:a17:903:2308:b0:1ce:2fc1:60ef with SMTP id d8-20020a170903230800b001ce2fc160efmr12497955plh.0.1701078862891;
        Mon, 27 Nov 2023 01:54:22 -0800 (PST)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id n17-20020a170902d2d100b001cfcfe3c1e5sm1387402plc.173.2023.11.27.01.54.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Nov 2023 01:54:22 -0800 (PST)
Message-ID: <cdb65963-48a4-590b-b366-a43b61e9d22d@redhat.com>
Date: Mon, 27 Nov 2023 17:54:19 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v2] arm/kvm: Enable support for KVM_ARM_VCPU_PMU_V3_FILTER
Content-Language: en-US
To: Eric Auger <eauger@redhat.com>, qemu-arm@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
 Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
 qemu-devel@nongnu.org
References: <20231117060838.39723-1-shahuang@redhat.com>
 <d9e83b7a-0fca-406f-b58e-9014a5e14870@redhat.com>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <d9e83b7a-0fca-406f-b58e-9014a5e14870@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Eric,

On 11/25/23 02:24, Eric Auger wrote:
> Hi,
> 
> On 11/17/23 07:08, Shaoqin Huang wrote:
>> The KVM_ARM_VCPU_PMU_V3_FILTER provide the ability to let the VMM decide
>> which PMU events are provided to the guest. Add a new option
>> `pmu-filter` as -accel sub-option to set the PMU Event Filtering.
>>
>> The `pmu-filter` has such format:
>>
>>    pmu-filter="{A,D}:start-end[;{A,D}:start-end...]"
>>
>> The A means "allow" and D means "deny", start is the first event of the
>> range and the end is the last one. The first filter action defines if the whole
>> event list is an allow or deny list, if the first filter action is "allow", all
>> other events are denied except start-end; if the first filter action is "deny",
>> all other events are allowed except start-end. For example:
>>
>>    pmu-filter="A:0x11-0x11;A:0x23-0x3a,D:0x30-0x30"
>>
>> This will allow event 0x11 (The cycle counter), events 0x23 to 0x3a is
>> also allowed except the event 0x30 is denied, and all the other events
>> are disallowed.
>>
>> Here is an real example shows how to use the PMU Event Filtering, when
>> we launch a guest by use kvm, add such command line:
>>
>>    # qemu-system-aarch64 \
>> 	-accel kvm,pmu-filter="D:0x11-0x11"
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
>>
>> Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
>> ---
>> v1->v2:
>>    - Add more description for allow and deny meaning in
>>      commit message.                                     [Sebastian]
>>    - Small improvement.                                  [Sebastian]
>>
>> v1: https://lore.kernel.org/all/20231113081713.153615-1-shahuang@redhat.com/
>> ---
>>   include/sysemu/kvm_int.h |  1 +
>>   qemu-options.hx          | 16 +++++++++++++
>>   target/arm/kvm.c         | 22 +++++++++++++++++
>>   target/arm/kvm64.c       | 51 ++++++++++++++++++++++++++++++++++++++++
>>   4 files changed, 90 insertions(+)
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
>>   };
>>   
>>   void kvm_memory_listener_register(KVMState *s, KVMMemoryListener *kml,
>> diff --git a/qemu-options.hx b/qemu-options.hx
>> index 42fd09e4de..dd3518092c 100644
>> --- a/qemu-options.hx
>> +++ b/qemu-options.hx
>> @@ -187,6 +187,7 @@ DEF("accel", HAS_ARG, QEMU_OPTION_accel,
>>       "                tb-size=n (TCG translation block cache size)\n"
>>       "                dirty-ring-size=n (KVM dirty ring GFN count, default 0)\n"
>>       "                eager-split-size=n (KVM Eager Page Split chunk size, default 0, disabled. ARM only)\n"
>> +    "                pmu-filter={A,D}:start-end[;...] (KVM PMU Event Filter, default no filter. ARM only)\n"
>>       "                notify-vmexit=run|internal-error|disable,notify-window=n (enable notify VM exit and set notify window, x86 only)\n"
>>       "                thread=single|multi (enable multi-threaded TCG)\n", QEMU_ARCH_ALL)
>>   SRST
>> @@ -259,6 +260,21 @@ SRST
>>           impact on the memory. By default, this feature is disabled
>>           (eager-split-size=0).
>>   
>> +    ``pmu-filter={A,D}:start-end[;...]``
>> +        KVM implements pmu event filtering to prevent a guest from being able to
>> +	sample certain events. It has the following format:
>> +
>> +	pmu-filter="{A,D}:start-end[;{A,D}:start-end...]"
>> +
>> +	The A means "allow" and D means "deny", start if the first event of the
>> +	range and the end is the last one. For example:
>> +
>> +	pmu-filter="A:0x11-0x11;A:0x23-0x3a,D:0x30-0x30"
>> +
>> +	This will allow event 0x11 (The cycle counter), events 0x23 to 0x3a is
>> +	also allowed except the event 0x30 is denied, and all the other events
>> +	are disallowed.
>> +
>>       ``notify-vmexit=run|internal-error|disable,notify-window=n``
>>           Enables or disables notify VM exit support on x86 host and specify
>>           the corresponding notify window to trigger the VM exit if enabled.
>> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
>> index 7903e2ddde..74796de055 100644
>> --- a/target/arm/kvm.c
>> +++ b/target/arm/kvm.c
>> @@ -1108,6 +1108,21 @@ static void kvm_arch_set_eager_split_size(Object *obj, Visitor *v,
>>       s->kvm_eager_split_size = value;
>>   }
>>   
>> +static char *kvm_arch_get_pmu_filter(Object *obj, Error **errp)
>> +{
>> +    KVMState *s = KVM_STATE(obj);
>> +
>> +    return g_strdup(s->kvm_pmu_filter);
>> +}
>> +
>> +static void kvm_arch_set_pmu_filter(Object *obj, const char *pmu_filter,
>> +                                    Error **errp)
>> +{
>> +    KVMState *s = KVM_STATE(obj);
>> +
>> +    s->kvm_pmu_filter = g_strdup(pmu_filter);
>> +}
>> +
>>   void kvm_arch_accel_class_init(ObjectClass *oc)
>>   {
>>       object_class_property_add(oc, "eager-split-size", "size",
>> @@ -1116,4 +1131,11 @@ void kvm_arch_accel_class_init(ObjectClass *oc)
>>   
>>       object_class_property_set_description(oc, "eager-split-size",
>>           "Eager Page Split chunk size for hugepages. (default: 0, disabled)");
>> +
>> +    object_class_property_add_str(oc, "pmu-filter",
>> +                                  kvm_arch_get_pmu_filter,
>> +                                  kvm_arch_set_pmu_filter);
>> +
>> +    object_class_property_set_description(oc, "pmu-filter",
>> +        "PMU Event Filtering description for guest pmu. (default: NULL, disabled)");
>>   }
>> diff --git a/target/arm/kvm64.c b/target/arm/kvm64.c
>> index 3c175c93a7..6eac328b48 100644
>> --- a/target/arm/kvm64.c
>> +++ b/target/arm/kvm64.c
>> @@ -10,6 +10,7 @@
>>    */
>>   
>>   #include "qemu/osdep.h"
>> +#include <asm-arm64/kvm.h>
>>   #include <sys/ioctl.h>
>>   #include <sys/ptrace.h>
>>   
>> @@ -131,6 +132,53 @@ static bool kvm_arm_set_device_attr(CPUState *cs, struct kvm_device_attr *attr,
>>       return true;
>>   }
>>   
>> +static void kvm_arm_pmu_filter_init(CPUState *cs)
>> +{
>> +    static bool pmu_filter_init = false;
>> +    struct kvm_pmu_event_filter filter;
>> +    struct kvm_device_attr attr = {
>> +        .group      = KVM_ARM_VCPU_PMU_V3_CTRL,
>> +        .attr       = KVM_ARM_VCPU_PMU_V3_FILTER,
>> +        .addr       = (uint64_t)&filter,
>> +    };
>> +    KVMState *kvm_state = cs->kvm_state;
>> +    char *tmp;
>> +    char *str, act;
>> +
>> +    if (!kvm_state->kvm_pmu_filter)
>> +        return;
>> +
> usually we check the kernel capability (here KVM_CAP_ARM_PMU_V3) before
> doing further actions. It allows you to give an inidication to the user
> that the kernel does not allow it. Also you should precise in the doc
> that this accel option requires host kernel caps I think.

I get it.

>> +    /* This only needs to be called for 1 vcpu. */
>> +    if (!pmu_filter_init)
>> +        pmu_filter_init = true;
>> +
>> +    tmp = g_strdup(kvm_state->kvm_pmu_filter);
>> +
>> +    for (str = strtok(tmp, ";"); str != NULL; str = strtok(NULL, ";")) {
>> +        unsigned short start = 0, end = 0;
>> +
>> +        sscanf(str, "%c:%hx-%hx", &act, &start, &end);
>> +        if ((act != 'A' && act != 'D') || (!start && !end)) {
>> +            error_report("skipping invalid filter %s\n", str);
>> +            continue;
>> +        }
>> +
>> +        filter = (struct kvm_pmu_event_filter) {
>> +            .base_event     = start,
>> +            .nevents        = end - start + 1,
>> +            .action         = act == 'A' ? KVM_PMU_EVENT_ALLOW :
>> +                                           KVM_PMU_EVENT_DENY,
>> +        };
>> +
>> +        if (!kvm_arm_set_device_attr(cs, &attr, "PMU Event Filter")) {
>> +            error_report("Failed to init PMU Event Filter\n");
> if you do the above, here you know that the host allows to set filters
> but that the user input is incorrect.

I see. Thanks for your additional information.

Thanks,
Shaoqin

> 
> Thanks
> 
> Eric
>> +            abort();
>> +        }
>> +    }
>> +
>> +    g_free(tmp);
>> +}
>> +
>>   void kvm_arm_pmu_init(CPUState *cs)
>>   {
>>       struct kvm_device_attr attr = {
>> @@ -141,6 +189,9 @@ void kvm_arm_pmu_init(CPUState *cs)
>>       if (!ARM_CPU(cs)->has_pmu) {
>>           return;
>>       }
>> +
>> +    kvm_arm_pmu_filter_init(cs);
>> +
>>       if (!kvm_arm_set_device_attr(cs, &attr, "PMU")) {
>>           error_report("failed to init PMU");
>>           abort();
> 

-- 
Shaoqin


