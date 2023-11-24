Return-Path: <kvm+bounces-2429-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A9957F71BE
	for <lists+kvm@lfdr.de>; Fri, 24 Nov 2023 11:41:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 74A56B21352
	for <lists+kvm@lfdr.de>; Fri, 24 Nov 2023 10:41:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 306F31A70C;
	Fri, 24 Nov 2023 10:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eRW8yeLA"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6167FD44
	for <kvm@vger.kernel.org>; Fri, 24 Nov 2023 02:40:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700822452;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GcEAhnyF7ok1y2TsHe8A1SWj/3v1bsdVrKQ/aa5dGnU=;
	b=eRW8yeLAxSPnPCq5DOCMCh+U28owbUY5qZKxIcVKVmcXzxigD+wKxgcFh79RFc0axyof9v
	Y1QFyuI01igYTO7hja4wF+mMscd+9OxhH/Fh2YZaQFrtj+AeZCNyzVsOg7FQgExABWVokl
	sujNxVTPKGDTB9b7a9DPN3a98721iDY=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-167-Ox9yr2HIOcGnmlXGravuCg-1; Fri, 24 Nov 2023 05:40:50 -0500
X-MC-Unique: Ox9yr2HIOcGnmlXGravuCg-1
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-5c5daf2baccso21001497b3.3
        for <kvm@vger.kernel.org>; Fri, 24 Nov 2023 02:40:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700822449; x=1701427249;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GcEAhnyF7ok1y2TsHe8A1SWj/3v1bsdVrKQ/aa5dGnU=;
        b=fdoGVn/mEqsWcV26+EF9IpRPlzXCm7tBAumhXnGBmrIhaeTkwAD8bbLnSIZ/Vjorrf
         gnmgmUszLeb+ohwY/+mZ2qjsCkk48HvtRrp7r+0U0ynnOeMpti3MGGHsqxq0twJU6KA0
         rxGloOMclusHtW+U6PQc5zK4YlNctVnZKMkgXowOhrJCzhaQsb+CaoUBe716ayaTsgXB
         6XJlXu11oXPYxRLaCTAs7tFH2CBOmvA50Hb+7o9R61HlXwX/NjTJw15rErmkVwtC2V3s
         5dIxuiMb9xt2dXL3RLMbg0QiwiC2+RUgxvDXqIldP2mLntfmjmbXKebvMrAVL/zo75YF
         aB1g==
X-Gm-Message-State: AOJu0Yxb1nbRb76JgZqT7fG34a17ZvAqvh5Ay/ERv+n+bdE7eTBbgpfG
	e2oE188upk/4dRLWp49E2jMDyqaynEBV5frGTfY6I9qY0pImZAAmJ2NLeGRJSeaHLCh603s+TNO
	mIItUD+yu/hjCttrTLQyL
X-Received: by 2002:a25:acce:0:b0:db3:fa45:6985 with SMTP id x14-20020a25acce000000b00db3fa456985mr1869045ybd.46.1700822449090;
        Fri, 24 Nov 2023 02:40:49 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEkJnx+RQKHHJCMUGBVX1c033wnVfuj/W6gdmnR3pf/ejGvjPXrJZegC5/wjXNId6lEJ4AQvQ==
X-Received: by 2002:a25:acce:0:b0:db3:fa45:6985 with SMTP id x14-20020a25acce000000b00db3fa456985mr1869035ybd.46.1700822448798;
        Fri, 24 Nov 2023 02:40:48 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id k12-20020a0cf58c000000b006624e9d51d9sm1320159qvm.76.2023.11.24.02.40.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Nov 2023 02:40:48 -0800 (PST)
Message-ID: <b00544d2-1a0e-4aa6-b56a-fbe3e18f817d@redhat.com>
Date: Fri, 24 Nov 2023 11:40:45 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] arm/kvm: Enable support for KVM_ARM_VCPU_PMU_V3_FILTER
Content-Language: en-US
To: Shaoqin Huang <shahuang@redhat.com>, qemu-arm@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
 Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
 qemu-devel@nongnu.org
References: <20231117060838.39723-1-shahuang@redhat.com>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <20231117060838.39723-1-shahuang@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Shaoqin,

On 11/17/23 07:08, Shaoqin Huang wrote:
> The KVM_ARM_VCPU_PMU_V3_FILTER provide the ability to let the VMM decide
> which PMU events are provided to the guest. Add a new option
> `pmu-filter` as -accel sub-option to set the PMU Event Filtering.
you remind the reader the default policy without filter (ie. expose all
events from the hots)
> 
> The `pmu-filter` has such format:
> 
>   pmu-filter="{A,D}:start-end[;{A,D}:start-end...]"
> 
> The A means "allow" and D means "deny", start is the first event of the
> range and the end is the last one. The first filter action defines if the whole
> event list is an allow or deny list, if the first filter action is "allow", all
> other events are denied except start-end; if the first filter action is "deny",
> all other events are allowed except start-end. For example:

I prefer the kernel doc wording
The first registered range defines the global policy (global ALLOW if
the first @action is DENY, global DENY if the first @action is ALLOW).
> 
>   pmu-filter="A:0x11-0x11;A:0x23-0x3a,D:0x30-0x30"
shoudn't the "," be replaced by a ";"?


I would add: since the first action is allow, we have a global deny policy.
> 
> This will allow event 0x11 (The cycle counter), events 0x23 to 0x3a is
> also allowed except the event 0x30 is denied, and all the other events
> are disallowed.
> 
> Here is an real example shows how to use the PMU Event Filtering, when
> we launch a guest by use kvm, add such command line:
> 
>   # qemu-system-aarch64 \
> 	-accel kvm,pmu-filter="D:0x11-0x11"
Since the first filter action is deny, we have a global allow policy.
this disables the filtering of the cycle counter (event 0x11 being
CPU_CYCLES)

kernel doc says that the ranges should match the PMU arch (10 bits on
ARMv8.0, 16 bits from ARMv8.1 onwards). How do you handle that?
> 
> And then in guest, use the perf to count the cycle:
> 
>   # perf stat sleep 1
> 
>    Performance counter stats for 'sleep 1':
> 
>               1.22 msec task-clock                       #    0.001 CPUs utilized
>                  1      context-switches                 #  820.695 /sec
>                  0      cpu-migrations                   #    0.000 /sec
>                 55      page-faults                      #   45.138 K/sec
>    <not supported>      cycles
>            1128954      instructions
>             227031      branches                         #  186.323 M/sec
>               8686      branch-misses                    #    3.83% of all branches
> 
>        1.002492480 seconds time elapsed
> 
>        0.001752000 seconds user
>        0.000000000 seconds sys
> 
> As we can see, the cycle counter has been disabled in the guest, but
> other pmu events are still work.

perf list should work as well
> 
> Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
> ---
> v1->v2:
>   - Add more description for allow and deny meaning in 
>     commit message.                                     [Sebastian]
>   - Small improvement.                                  [Sebastian]
> 
> v1: https://lore.kernel.org/all/20231113081713.153615-1-shahuang@redhat.com/
> ---
>  include/sysemu/kvm_int.h |  1 +
>  qemu-options.hx          | 16 +++++++++++++
>  target/arm/kvm.c         | 22 +++++++++++++++++
>  target/arm/kvm64.c       | 51 ++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 90 insertions(+)
> 
> diff --git a/include/sysemu/kvm_int.h b/include/sysemu/kvm_int.h
> index fd846394be..8f4601474f 100644
> --- a/include/sysemu/kvm_int.h
> +++ b/include/sysemu/kvm_int.h
> @@ -120,6 +120,7 @@ struct KVMState
>      uint32_t xen_caps;
>      uint16_t xen_gnttab_max_frames;
>      uint16_t xen_evtchn_max_pirq;
> +    char *kvm_pmu_filter;
>  };
>  
>  void kvm_memory_listener_register(KVMState *s, KVMMemoryListener *kml,
> diff --git a/qemu-options.hx b/qemu-options.hx
> index 42fd09e4de..dd3518092c 100644
> --- a/qemu-options.hx
> +++ b/qemu-options.hx
> @@ -187,6 +187,7 @@ DEF("accel", HAS_ARG, QEMU_OPTION_accel,
>      "                tb-size=n (TCG translation block cache size)\n"
>      "                dirty-ring-size=n (KVM dirty ring GFN count, default 0)\n"
>      "                eager-split-size=n (KVM Eager Page Split chunk size, default 0, disabled. ARM only)\n"
> +    "                pmu-filter={A,D}:start-end[;...] (KVM PMU Event Filter, default no filter. ARM only)\n"
>      "                notify-vmexit=run|internal-error|disable,notify-window=n (enable notify VM exit and set notify window, x86 only)\n"
>      "                thread=single|multi (enable multi-threaded TCG)\n", QEMU_ARCH_ALL)
>  SRST
> @@ -259,6 +260,21 @@ SRST
>          impact on the memory. By default, this feature is disabled
>          (eager-split-size=0).
>  
> +    ``pmu-filter={A,D}:start-end[;...]``
> +        KVM implements pmu event filtering to prevent a guest from being able to
> +	sample certain events. It has the following format:
> +
> +	pmu-filter="{A,D}:start-end[;{A,D}:start-end...]"
you may add []* to express that you have any number of ranges
> +
> +	The A means "allow" and D means "deny", start if the first event of the
> +	range and the end is the last one. For example:
> +
> +	pmu-filter="A:0x11-0x11;A:0x23-0x3a,D:0x30-0x30"
is is hex format only?
> +
> +	This will allow event 0x11 (The cycle counter), events 0x23 to 0x3a is
> +	also allowed except the event 0x30 is denied, and all the other events
> +	are disallowed.
s/disallowed/hidden?
> +
>      ``notify-vmexit=run|internal-error|disable,notify-window=n``
>          Enables or disables notify VM exit support on x86 host and specify
>          the corresponding notify window to trigger the VM exit if enabled.
> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index 7903e2ddde..74796de055 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -1108,6 +1108,21 @@ static void kvm_arch_set_eager_split_size(Object *obj, Visitor *v,
>      s->kvm_eager_split_size = value;
>  }
>  
> +static char *kvm_arch_get_pmu_filter(Object *obj, Error **errp)
> +{
> +    KVMState *s = KVM_STATE(obj);
> +
> +    return g_strdup(s->kvm_pmu_filter);
> +}
> +
> +static void kvm_arch_set_pmu_filter(Object *obj, const char *pmu_filter,
> +                                    Error **errp)
> +{
> +    KVMState *s = KVM_STATE(obj);
> +
> +    s->kvm_pmu_filter = g_strdup(pmu_filter);
can the user specify the option several times in which case we would
leak here?
> +}
> +
>  void kvm_arch_accel_class_init(ObjectClass *oc)
>  {
>      object_class_property_add(oc, "eager-split-size", "size",
> @@ -1116,4 +1131,11 @@ void kvm_arch_accel_class_init(ObjectClass *oc)
>  
>      object_class_property_set_description(oc, "eager-split-size",
>          "Eager Page Split chunk size for hugepages. (default: 0, disabled)");
> +
> +    object_class_property_add_str(oc, "pmu-filter",
> +                                  kvm_arch_get_pmu_filter,
> +                                  kvm_arch_set_pmu_filter);
> +
> +    object_class_property_set_description(oc, "pmu-filter",
> +        "PMU Event Filtering description for guest pmu. (default: NULL, disabled)");
>  }
> diff --git a/target/arm/kvm64.c b/target/arm/kvm64.c
> index 3c175c93a7..6eac328b48 100644
> --- a/target/arm/kvm64.c
> +++ b/target/arm/kvm64.c
> @@ -10,6 +10,7 @@
>   */
>  
>  #include "qemu/osdep.h"
> +#include <asm-arm64/kvm.h>
>  #include <sys/ioctl.h>
>  #include <sys/ptrace.h>
>  
> @@ -131,6 +132,53 @@ static bool kvm_arm_set_device_attr(CPUState *cs, struct kvm_device_attr *attr,
>      return true;
>  }
>  
> +static void kvm_arm_pmu_filter_init(CPUState *cs)
> +{
> +    static bool pmu_filter_init = false;
> +    struct kvm_pmu_event_filter filter;
> +    struct kvm_device_attr attr = {
> +        .group      = KVM_ARM_VCPU_PMU_V3_CTRL,
> +        .attr       = KVM_ARM_VCPU_PMU_V3_FILTER,
> +        .addr       = (uint64_t)&filter,
> +    };
> +    KVMState *kvm_state = cs->kvm_state;
> +    char *tmp;
> +    char *str, act;
> +
> +    if (!kvm_state->kvm_pmu_filter)
> +        return;
> +
> +    /* This only needs to be called for 1 vcpu. */
> +    if (!pmu_filter_init)
> +        pmu_filter_init = true;
where is it used?
> +
> +    tmp = g_strdup(kvm_state->kvm_pmu_filter);
> +
> +    for (str = strtok(tmp, ";"); str != NULL; str = strtok(NULL, ";")) {
> +        unsigned short start = 0, end = 0;
> +
> +        sscanf(str, "%c:%hx-%hx", &act, &start, &end);
> +        if ((act != 'A' && act != 'D') || (!start && !end)) {
> +            error_report("skipping invalid filter %s\n", str);
> +            continue;
> +        }
> +
> +        filter = (struct kvm_pmu_event_filter) {
> +            .base_event     = start,
> +            .nevents        = end - start + 1,
> +            .action         = act == 'A' ? KVM_PMU_EVENT_ALLOW :
> +                                           KVM_PMU_EVENT_DENY,
> +        };
> +
> +        if (!kvm_arm_set_device_attr(cs, &attr, "PMU Event Filter")) {
> +            error_report("Failed to init PMU Event Filter\n");
you may add some hints about why this failed.
> +            abort();
> +        }
> +    }
> +
> +    g_free(tmp);
> +}
> +
>  void kvm_arm_pmu_init(CPUState *cs)
>  {
>      struct kvm_device_attr attr = {
> @@ -141,6 +189,9 @@ void kvm_arm_pmu_init(CPUState *cs)
>      if (!ARM_CPU(cs)->has_pmu) {
>          return;
>      }
> +
> +    kvm_arm_pmu_filter_init(cs);
> +
>      if (!kvm_arm_set_device_attr(cs, &attr, "PMU")) {
>          error_report("failed to init PMU");
>          abort();

I see x86 seems to have a similar capability (see
KVM_CAP_PMU_EVENT_FILTER). But I am not sure this is integrated in qemu?

Thanks

Eric


