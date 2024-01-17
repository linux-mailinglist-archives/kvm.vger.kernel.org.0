Return-Path: <kvm+bounces-6389-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 18EFF830677
	for <lists+kvm@lfdr.de>; Wed, 17 Jan 2024 14:00:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 821101F2623B
	for <lists+kvm@lfdr.de>; Wed, 17 Jan 2024 13:00:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBEC71F951;
	Wed, 17 Jan 2024 12:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S08fnEkn"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECB111F939
	for <kvm@vger.kernel.org>; Wed, 17 Jan 2024 12:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705496388; cv=none; b=i28PrZX9GQt7ooHYedLYrgFM/Qytov42SjpveL67z0X8yZw+W81mVLcd+6RmZ/yZMCY+UXDClYrlPaGCJGjmnHv6JS+zGGYIzSkOHk5BDGkW/XueIGbIIKOVJelKnvlKD0inptaRW+gBNdsWHtMJhayMBI4kFvtdUpMyiiVi7+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705496388; c=relaxed/simple;
	bh=c1r9ejwjZjJST85IOOUMUorWTTlb2V9nPslwRdArZ6M=;
	h=DKIM-Signature:Received:X-MC-Unique:Received:
	 X-Google-DKIM-Signature:X-Gm-Message-State:X-Received:
	 X-Google-Smtp-Source:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:Content-Language:To:Cc:References:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding; b=I1BToPykAV5vmxxh+/jThi8OqRhzyFYXWPTJ6nOP4GGsm8/TLiEDUharChmguvX9Q5HO8JW2fAvPEt0kSJWxoNPn99NsilooZk0b/6dMwUYXwSHPcfD/WLDVkEzXQv/T4+3sjdkrkk4QfYfxdAh3mVNRQe02ztg8YWAXS2CtKDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S08fnEkn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705496384;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XgoSKBqcUYHyp2f4oduCQ1hiRilDPAqB7+tCYfnp1qk=;
	b=S08fnEknmUmzqOD1Gy1Y7Si4pOHF+Ban2luFUm+lo6n6WR8M68il+x6TI/4L6e26xhB9UX
	McN4l73F3A2tvKWowbzxqfrCd5c82JNNN1Ey2mDVPz51Tru5tN/D+/kFwD7VNpHEEOJnBf
	OVg274EpWuGex5c59aZEq8HG9a2cR44=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-616-xA11YZjmNZq4Uj3ypqrY1A-1; Wed, 17 Jan 2024 07:59:43 -0500
X-MC-Unique: xA11YZjmNZq4Uj3ypqrY1A-1
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-5ee22efe5eeso154903917b3.3
        for <kvm@vger.kernel.org>; Wed, 17 Jan 2024 04:59:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705496383; x=1706101183;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XgoSKBqcUYHyp2f4oduCQ1hiRilDPAqB7+tCYfnp1qk=;
        b=M+IwGx16hCKvYzsDZi3I0bDtzomzy2m7NP10FaN829Gsvn5S7T7G8pxKwHIWnKt73m
         IpvNlhX9PKEAnfXvKJwxzgfEIUTKV/o3hXO9oebHprRMvOXt2L3BSxitklAOdhLLWTO7
         D7vaXg5cYnXn2TCmaYG07LlNBWMOPcZLf5J0SCkPaq+T5qa3Hlq8NeIUQcMC2uU8bk4N
         wVbkeZa4NT5TQwAHXHtS6JBNe9UFpcUdcjlgvkiibSF2GV4Viju7kWKHjQcyJ21ffynb
         lcqKQ613x0RyXji3t7q4lSXzGHyR1GBIkN1ZijcPr0vukJsle2U+XnJBr1c4tn/rTjtS
         6iuA==
X-Gm-Message-State: AOJu0YwSOCb3TSf3UkW5FM8a+NC/Qb3bMzFFmUWaEE3JW0YD2WqiT429
	r5fQMOhRAxl0RTiWkjs4QI4YQnUSgAijEPJpAUVfZxgh0M+bu1ASdYg1CDMk49FQnpzW3tFKzIO
	Vgm+2riwidW42BaM8Pf4m
X-Received: by 2002:a05:6902:1371:b0:dc2:23cf:6ada with SMTP id bt17-20020a056902137100b00dc223cf6adamr1633151ybb.73.1705496382661;
        Wed, 17 Jan 2024 04:59:42 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH+zrMhOBFNzVTkOaVw9IJ1zHDLL9AzqDtn0v6/+KfBbBD99xmgWmxjLMT5gnkWrUs28xEoPQ==
X-Received: by 2002:a05:6902:1371:b0:dc2:23cf:6ada with SMTP id bt17-20020a056902137100b00dc223cf6adamr1633138ybb.73.1705496382282;
        Wed, 17 Jan 2024 04:59:42 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id w5-20020a0cf705000000b006818033cceasm292955qvn.38.2024.01.17.04.59.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jan 2024 04:59:41 -0800 (PST)
Message-ID: <852ee2a3-b69f-4480-a6f4-f2b274f5e01c@redhat.com>
Date: Wed, 17 Jan 2024 13:59:38 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] arm/kvm: Enable support for KVM_ARM_VCPU_PMU_V3_FILTER
Content-Language: en-US
To: Shaoqin Huang <shahuang@redhat.com>, qemu-arm@nongnu.org
Cc: Gavin Shan <gshan@redhat.com>, Peter Maydell <peter.maydell@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org
References: <20240115080144.44944-1-shahuang@redhat.com>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <20240115080144.44944-1-shahuang@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi  Shaoqin,

On 1/15/24 09:01, Shaoqin Huang wrote:
> The KVM_ARM_VCPU_PMU_V3_FILTER provides the ability to let the VMM decide
> which PMU events are provided to the guest. Add a new option
> `kvm-pmu-filter` as -cpu sub-option to set the PMU Event Filtering.
> Without the filter, all PMU events are exposed from host to guest by
> default. The usage of the new sub-option can be found from the updated
> document (docs/system/arm/cpu-features.rst).

do not hesitate to cc qemu-arm@nongnu.org for ARM specific topics.

> 
> Here is an example shows how to use the PMU Event Filtering, when
which shows
> we launch a guest by use kvm, add such command line:
> 
>   # qemu-system-aarch64 \
>         -accel kvm \
>         -cpu host,kvm-pmu-filter="D:0x11-0x11"
> 
> Since the first action is deny, we have a global allow policy. This
> disables the filtering of the cycle counter (event 0x11 being CPU_CYCLES).
Actually it filters it ;-) It would rather say this filters out the
cycle counter. But I am not a native speaker either ;-)
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
do still work
> 
> Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
> ---
> v4->v5:
>   - Change the kvm-pmu-filter as a -cpu sub-option.     [Eric]
>   - Comment tweak.                                      [Gavin]
>   - Rebase to the latest branch.
> 
> v3->v4:
>   - Fix the wrong check for pmu_filter_init.            [Sebastian]
>   - Fix multiple alignment issue.                       [Gavin]
>   - Report error by warn_report() instead of error_report(), and don't use
>   abort() since the PMU Event Filter is an add-on and best-effort feature.
>                                                         [Gavin]
>   - Add several missing {  } for single line of code.   [Gavin]
>   - Use the g_strsplit() to replace strtok().           [Gavin]
> 
> v2->v3:
>   - Improve commits message, use kernel doc wording, add more explaination on
>     filter example, fix some typo error.                [Eric]
>   - Add g_free() in kvm_arch_set_pmu_filter() to prevent memory leak. [Eric]
>   - Add more precise error message report.              [Eric]
>   - In options doc, add pmu-filter rely on KVM_ARM_VCPU_PMU_V3_FILTER support in
>     KVM.                                                [Eric]
> 
> v1->v2:
>   - Add more description for allow and deny meaning in 
>     commit message.                                     [Sebastian]
>   - Small improvement.                                  [Sebastian]
> 
>  docs/system/arm/cpu-features.rst | 23 ++++++++++
>  include/sysemu/kvm_int.h         |  1 +
>  target/arm/cpu.h                 |  3 ++
>  target/arm/kvm.c                 | 78 ++++++++++++++++++++++++++++++++
>  4 files changed, 105 insertions(+)
> 
> diff --git a/docs/system/arm/cpu-features.rst b/docs/system/arm/cpu-features.rst
> index a5fb929243..44a797c50e 100644
> --- a/docs/system/arm/cpu-features.rst
> +++ b/docs/system/arm/cpu-features.rst
> @@ -204,6 +204,29 @@ the list of KVM VCPU features and their descriptions.
>    the guest scheduler behavior and/or be exposed to the guest
>    userspace.
>  
> +``kvm-pmu-filter``
> +  By default kvm-pmu-filter is disabled. This means that by default all pmu
> +  events will be exposed to guest.
> +
> +  KVM implements PMU Event Filtering to prevent a guest from being able to
> +  sample certain events. It depends on the KVM_ARM_VCPU_PMU_V3_FILTER
> +  attribute supported in KVM. It has the following format:
> +
> +  kvm-pmu-filter="{A,D}:start-end[;{A,D}:start-end...]"
> +
> +  The A means "allow" and D means "deny", start is the first event of the
> +  range and the end is the last one. The first registered range defines
> +  the global policy(global ALLOW if the first @action is DENY, global DENY
> +  if the first @action is ALLOW). The start and end only support hexadecimal
> +  format now. For example:
> +
> +  kvm-pmu-filter="A:0x11-0x11;A:0x23-0x3a;D:0x30-0x30"
> +
> +  Since the first action is allow, we have a global deny policy. It
> +  will allow event 0x11 (The cycle counter), events 0x23 to 0x3a is
s/is/are
> +  also allowed except the event 0x30 is denied, and all the other events
0x30 is/0x30 which is
> +  are disallowed.
s/disallowed/denied just to match the above terminology.
> +
>  TCG VCPU Features
>  =================
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
I think this is not needed anymore
>  };
>  
>  void kvm_memory_listener_register(KVMState *s, KVMMemoryListener *kml,
> diff --git a/target/arm/cpu.h b/target/arm/cpu.h
> index 8c3ca2e231..1be7dca4aa 100644
> --- a/target/arm/cpu.h
> +++ b/target/arm/cpu.h
> @@ -971,6 +971,9 @@ struct ArchCPU {
>  
>      /* KVM steal time */
>      OnOffAuto kvm_steal_time;
> +
> +    /* KVM PMU Filter */
> +    char *kvm_pmu_filter;
>  #endif /* CONFIG_KVM */
>  
>      /* Uniprocessor system with MP extensions */
> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index c5a3183843..413ee2720e 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -495,6 +495,22 @@ static void kvm_steal_time_set(Object *obj, bool value, Error **errp)
>      ARM_CPU(obj)->kvm_steal_time = value ? ON_OFF_AUTO_ON : ON_OFF_AUTO_OFF;
>  }
>  
> +static char *kvm_pmu_filter_get(Object *obj, Error **errp)
> +{
> +    ARMCPU *cpu = ARM_CPU(obj);
> +
> +    return g_strdup(cpu->kvm_pmu_filter);
> +}
> +
> +static void kvm_pmu_filter_set(Object *obj, const char *pmu_filter,
> +                               Error **errp)
> +{
> +    ARMCPU *cpu = ARM_CPU(obj);
> +
> +    g_free(cpu->kvm_pmu_filter);
> +    cpu->kvm_pmu_filter = g_strdup(pmu_filter);
> +}
> +
>  /* KVM VCPU properties should be prefixed with "kvm-". */
>  void kvm_arm_add_vcpu_properties(ARMCPU *cpu)
>  {
> @@ -516,6 +532,12 @@ void kvm_arm_add_vcpu_properties(ARMCPU *cpu)
>                               kvm_steal_time_set);
>      object_property_set_description(obj, "kvm-steal-time",
>                                      "Set off to disable KVM steal time.");
> +
> +    object_property_add_str(obj, "kvm-pmu-filter", kvm_pmu_filter_get,
> +                            kvm_pmu_filter_set);
> +    object_property_set_description(obj, "kvm-pmu-filter",
> +                                    "PMU Event Filtering description for "
> +                                    "guest PMU. (default: NULL, disabled)");
>  }
>  
>  bool kvm_arm_pmu_supported(void)
> @@ -1705,6 +1727,60 @@ static bool kvm_arm_set_device_attr(ARMCPU *cpu, struct kvm_device_attr *attr,
>      return true;
>  }
>  
> +static void kvm_arm_pmu_filter_init(ARMCPU *cpu)
> +{
> +    static bool pmu_filter_init;
> +    struct kvm_pmu_event_filter filter;
> +    struct kvm_device_attr attr = {
> +        .group      = KVM_ARM_VCPU_PMU_V3_CTRL,
> +        .attr       = KVM_ARM_VCPU_PMU_V3_FILTER,
> +        .addr       = (uint64_t)&filter,
> +    };
> +    int i;
> +    gchar **event_filters;
wonder if you couldn't use g_auto(GStrv) event_filters with auto
cleenup? examples in qom/object.c for instance
> +
> +    if (!cpu->kvm_pmu_filter) {
> +        return;
> +    }
> +    if (kvm_vcpu_ioctl(CPU(cpu), KVM_HAS_DEVICE_ATTR, &attr)) {
> +        warn_report("The KVM doesn't support the PMU Event Filter!");
> +        return;
> +    }
> +
> +    /*
> +     * The filter only needs to be initialized through one vcpu ioctl and it
> +     * will affect all other vcpu in the vm.
> +     */
> +    if (pmu_filter_init) {
I think I commented on that on the v4. Maybe I missed your reply. You
sure you don't need to call it for each vcpu?

> +        return;
> +    } else {
> +        pmu_filter_init = true;
> +    }
> +
> +    event_filters = g_strsplit(cpu->kvm_pmu_filter, ";", -1);
> +    for (i = 0; event_filters[i]; i++) {
> +        unsigned short start = 0, end = 0;
> +        char act;
> +
> +        sscanf(event_filters[i], "%c:%hx-%hx", &act, &start, &end);
> +        if ((act != 'A' && act != 'D') || (!start && !end)) {
> +            warn_report("Skipping invalid PMU filter %s", event_filters[i]);
> +            continue;
> +        }
> +
> +        filter.base_event = start;
> +        filter.nevents = end - start + 1;
> +        filter.action = (act == 'A') ? KVM_PMU_EVENT_ALLOW :
> +                                       KVM_PMU_EVENT_DENY;
> +
> +        if (!kvm_arm_set_device_attr(cpu, &attr, "PMU Event Filter")) {
Nit: maybe s/PMU Event Filter/PMU_V3_FILTER
> +            break;
> +        }
> +    }
> +
> +    g_strfreev(event_filters);
> +}
> +
>  void kvm_arm_pmu_init(ARMCPU *cpu)
>  {
>      struct kvm_device_attr attr = {
> @@ -1715,6 +1791,8 @@ void kvm_arm_pmu_init(ARMCPU *cpu)
>      if (!cpu->has_pmu) {
>          return;
>      }
> +
> +    kvm_arm_pmu_filter_init(cpu);
>      if (!kvm_arm_set_device_attr(cpu, &attr, "PMU")) {
>          error_report("failed to init PMU");
>          abort();
Along with this new vcpu feature you may want to add a test like what
was done in 68970d1e0d07 ("hw/arm/virt: Implement kvm-steal-time"), in
tests/qtest/arm-cpu-features.c

Thanks

Eric


