Return-Path: <kvm+bounces-12153-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BE9DC88007D
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 16:24:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2A4911F22F63
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 15:24:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2089657BD;
	Tue, 19 Mar 2024 15:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NuH/IB5V"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D48D2657BA
	for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 15:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710861843; cv=none; b=iAvWDEy/BxRnpuSXR/cBD3ko3KhsBe9rAYmczLo2w23wH1Dd89zocXHCGfvw/FibHlX51nEveXjYq3q/pSywgv2tpVMIfNZsYMctvAb9rDSCe9UhUxp0x3++B/udynHcDlo420DUBA+ISf+TS383/fCsJGwHy/ZPmEY9yKV7Xro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710861843; c=relaxed/simple;
	bh=1dDLydAv3t8ycgvT1GQp7OzVbspxWFGPdP1zEWoeDwI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KsJpA0w9CZuG+9QdE517pHJM3Af60M4ZGijQ/9JnfWOGdonwaT8mR7LCHGxZTnKSTZcZOTc1VvykUPWaUVKLUOO0DCvX1DmDi9ZcP9Oy5OJ5mP0ebodDlwHz8lBEpzroGTDc6WdJdlEcT+25m6+GrQ5CB63oGJkdjQEGUvLl+oI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NuH/IB5V; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710861839;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bKKfxprg0OibH8731+5gTBZ7AmKnVcb+BK5nzCHPeb4=;
	b=NuH/IB5V6VmKzl9Xp6oi1D7IdBnXyRZuVlu8Q1cQiWltkopdHjrHKQdgFxAkpkRtSP6jqX
	bPCBE3ik+oA4H57zSMWoxGUEGhrbidfvwPKMHircf435Blg6G8/QnyK4ua8aEIU0hW6VKb
	b8awq/OXwoDicGJqGBxVoF0jIf56Mt0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-152-RsDtubP9OyajercUfPlr9A-1; Tue, 19 Mar 2024 11:23:58 -0400
X-MC-Unique: RsDtubP9OyajercUfPlr9A-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4140a509ee9so14460915e9.3
        for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 08:23:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710861837; x=1711466637;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bKKfxprg0OibH8731+5gTBZ7AmKnVcb+BK5nzCHPeb4=;
        b=dBuErdf6z/LGeUmhvb8WZioMlP/uBQ3nosbnDOjlDuqSdy5v8vvpFwGBmWLcN0ZfbH
         mFOO3ilcG1Y+hoXh8ENwuQwY6d/nCESHDtaDAwvNHuwkR3Yn1xB3xyJ88imfFk6c7dlt
         CCQL1qlLcKkuvyC4Aa5h0tb+mI+fr6p1/haJKyjsZ3qMUDZAPlx3WQ9QO9N9yp6QjZC1
         id7MFlDSLdLss78Ntw/ZT9gQkUPPP8BJb/p1dE5eDsDPYUfywso9fgwZ4bqOYPYkLeNo
         18UDxJFpGP1InwfSOQm+MK0lHWYvfGpHZLuV0L6WcW9dtmevlqu10WmO3/HnHQ1WA1Im
         96OQ==
X-Forwarded-Encrypted: i=1; AJvYcCX7gumzj90C5tAYl7vKT3EvcwusOGXsjxn6fXBwG4AcPJ4NTleNWavgF9sQle7UtIt4FTuSE5m8aN84EWF+OxCWMSpX
X-Gm-Message-State: AOJu0YxUJiG99/UX5LEP4AugnJ0bkpOn1KwTkbAEz8tmRJKbjKkn4Xyh
	gG7Gwu1ebxZ9IE6UzmecSPS3go+dL+uFyJtaTBBJN1U/b4FGTP3AqpGquJm9bwW3sYb7ZJEuD8W
	Zy2lhks52JjWTy9mkvsD2zIdOb+PwdNbWRDyaO9IaJwQf0OHb1Q==
X-Received: by 2002:a05:600c:46c9:b0:414:64c8:5523 with SMTP id q9-20020a05600c46c900b0041464c85523mr1800767wmo.3.1710861836643;
        Tue, 19 Mar 2024 08:23:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGZPzg2jZAHYLGSLgSGmPeSZqT44Ys75VdFIsKW7y3Zso7UeL5AyjYFSdgOKuZ5CVdpu9yalw==
X-Received: by 2002:a05:600c:46c9:b0:414:64c8:5523 with SMTP id q9-20020a05600c46c900b0041464c85523mr1800745wmo.3.1710861836087;
        Tue, 19 Mar 2024 08:23:56 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id f11-20020a05600c4e8b00b0041461cce1cbsm3523325wmq.46.2024.03.19.08.23.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Mar 2024 08:23:55 -0700 (PDT)
Message-ID: <901a0623-c93b-4930-9ef5-89adf505929d@redhat.com>
Date: Tue, 19 Mar 2024 16:23:54 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8] arm/kvm: Enable support for KVM_ARM_VCPU_PMU_V3_FILTER
Content-Language: en-US
To: Shaoqin Huang <shahuang@redhat.com>, qemu-arm@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Huth <thuth@redhat.com>,
 Laurent Vivier <lvivier@redhat.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org
References: <20240312074849.71475-1-shahuang@redhat.com>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <20240312074849.71475-1-shahuang@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Shaoqin,

On 3/12/24 08:48, Shaoqin Huang wrote:
> The KVM_ARM_VCPU_PMU_V3_FILTER provides the ability to let the VMM decide
> which PMU events are provided to the guest. Add a new option
> `kvm-pmu-filter` as -cpu sub-option to set the PMU Event Filtering.
> Without the filter, all PMU events are exposed from host to guest by
> default. The usage of the new sub-option can be found from the updated
> document (docs/system/arm/cpu-features.rst).
> 
> Here is an example which shows how to use the PMU Event Filtering, when
> we launch a guest by use kvm, add such command line:
> 
>   # qemu-system-aarch64 \
>         -accel kvm \
>         -cpu host,kvm-pmu-filter="D:0x11-0x11"
> 
> Since the first action is deny, we have a global allow policy. This
> filters out the cycle counter (event 0x11 being CPU_CYCLES).
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
> other pmu events do still work.
> 
> Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
> ---
> v7->v8:
>   - Add qtest for kvm-pmu-filter.
>   - Do the kvm-pmu-filter syntax checking up-front in the kvm_pmu_filter_set()
>   function. And store the filter information at there. When kvm_pmu_filter_get()
>   reconstitute it.
> 
> v6->v7:
>   - Check return value of sscanf.
>   - Improve the check condition.
> 
> v5->v6:
>   - Commit message improvement.
>   - Remove some unused code.
>   - Collect Reviewed-by, thanks Sebastian.
>   - Use g_auto(Gstrv) to replace the gchar **.          [Eric]
> 
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
> ---
>  docs/system/arm/cpu-features.rst |  23 +++++++
>  target/arm/arm-qmp-cmds.c        |   2 +-
>  target/arm/cpu.h                 |   3 +
>  target/arm/kvm.c                 | 115 +++++++++++++++++++++++++++++++
>  tests/qtest/arm-cpu-features.c   |  51 ++++++++++++++
>  5 files changed, 193 insertions(+), 1 deletion(-)
> 
> diff --git a/docs/system/arm/cpu-features.rst b/docs/system/arm/cpu-features.rst
> index a5fb929243..f3930f34b3 100644
> --- a/docs/system/arm/cpu-features.rst
> +++ b/docs/system/arm/cpu-features.rst
> @@ -204,6 +204,29 @@ the list of KVM VCPU features and their descriptions.
>    the guest scheduler behavior and/or be exposed to the guest
>    userspace.
>  
> +``kvm-pmu-filter``
> +  By default kvm-pmu-filter is disabled. This means that by default all PMU
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
> +  the global policy (global ALLOW if the first action is DENY, global DENY
> +  if the first action is ALLOW). The start and end only support hexadecimal
> +  format. For example:
> +
> +  kvm-pmu-filter="A:0x11-0x11;A:0x23-0x3a;D:0x30-0x30"
> +
> +  Since the first action is allow, we have a global deny policy. It
> +  will allow event 0x11 (the cycle counter), events 0x23 to 0x3a are
> +  also allowed except the event 0x30 which is denied, and all the other
> +  events are denied.
> +
>  TCG VCPU Features
>  =================
>  
> diff --git a/target/arm/arm-qmp-cmds.c b/target/arm/arm-qmp-cmds.c
> index 2250cd7ddf..36df2e4820 100644
> --- a/target/arm/arm-qmp-cmds.c
> +++ b/target/arm/arm-qmp-cmds.c
> @@ -94,7 +94,7 @@ static const char *cpu_model_advertised_features[] = {
>      "sve128", "sve256", "sve384", "sve512",
>      "sve640", "sve768", "sve896", "sve1024", "sve1152", "sve1280",
>      "sve1408", "sve1536", "sve1664", "sve1792", "sve1920", "sve2048",
> -    "kvm-no-adjvtime", "kvm-steal-time",
> +    "kvm-no-adjvtime", "kvm-steal-time", "kvm-pmu-filter",
>      "pauth", "pauth-impdef", "pauth-qarma3",
>      NULL
>  };
> diff --git a/target/arm/cpu.h b/target/arm/cpu.h
> index 63f31e0d98..b810a80e67 100644
> --- a/target/arm/cpu.h
> +++ b/target/arm/cpu.h
> @@ -948,6 +948,9 @@ struct ArchCPU {
>  
>      /* KVM steal time */
>      OnOffAuto kvm_steal_time;
> +
> +    /* KVM PMU Filter */
> +    GArray *kvm_pmu_filter;
>  #endif /* CONFIG_KVM */
>  
>      /* Uniprocessor system with MP extensions */
> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index 81813030a5..7f62fad029 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -496,6 +496,72 @@ static void kvm_steal_time_set(Object *obj, bool value, Error **errp)
>      ARM_CPU(obj)->kvm_steal_time = value ? ON_OFF_AUTO_ON : ON_OFF_AUTO_OFF;
>  }
>  
> +static char *kvm_pmu_filter_get(Object *obj, Error **errp)
> +{
> +    ARMCPU *cpu = ARM_CPU(obj);
> +    g_autoptr(GString) pmu_filter = g_string_new(NULL);
> +    struct kvm_pmu_event_filter *filter;
> +    char action;
> +    int i;
> +
> +    if (!cpu->kvm_pmu_filter) {
> +        return NULL;
> +    }
> +
> +    for (i = 0; i < cpu->kvm_pmu_filter->len; i++) {
> +        filter = &g_array_index(cpu->kvm_pmu_filter,
> +                                struct kvm_pmu_event_filter, i);
> +        if (i) {
> +            g_string_append_c(pmu_filter, ';');
> +        }
> +        action = filter->action == KVM_PMU_EVENT_ALLOW ? 'A' : 'D';
> +        g_string_append_printf(pmu_filter, "%c:0x%hx-0x%hx", action,
> +                               filter->base_event,
> +                               filter->base_event + filter->nevents - 1);
> +    }
> +
> +    return g_strdup(pmu_filter->str);
> +}
> +
> +static void kvm_pmu_filter_set(Object *obj, const char *pmu_filter,
> +                               Error **errp)
> +{
> +    ARMCPU *cpu = ARM_CPU(obj);
> +    struct kvm_pmu_event_filter filter;
> +    g_auto(GStrv) event_filters;
> +    int i;
> +
> +    if (cpu->kvm_pmu_filter) {
> +        g_array_free(cpu->kvm_pmu_filter, true);
> +    }
> +
> +    cpu->kvm_pmu_filter = g_array_new(false, false,
> +                                      sizeof(struct kvm_pmu_event_filter));
> +
> +    event_filters = g_strsplit(pmu_filter, ";", -1);
> +    for (i = 0; event_filters[i]; i++) {
> +        unsigned short start = 0, end = 0;
> +        char act;
> +
> +        if (sscanf(event_filters[i], "%c:%hx-%hx", &act, &start, &end) != 3) {
> +            warn_report("Skipping invalid PMU filter %s", event_filters[i]);
> +            continue;
> +        }
> +
> +        if ((act != 'A' && act != 'D') || start > end) {
> +            warn_report("Skipping invalid PMU filter %s", event_filters[i]);
> +            continue;
if both conditions above lead to the same outcome, I think you can merge
"or" them.

on v7 Peter suggested we should rather fail if the user passes us an
option that can't be applied. This sounds even more sensible now we
handle things on "set". Then you can use error_setg on errp and return.
> +        }
> +
> +        filter.base_event = start;
> +        filter.nevents = end - start + 1;
> +        filter.action = (act == 'A') ? KVM_PMU_EVENT_ALLOW :
> +                                       KVM_PMU_EVENT_DENY;
> +
> +        g_array_append_vals(cpu->kvm_pmu_filter, &filter, 1);
> +    }
> +}
> +
>  /* KVM VCPU properties should be prefixed with "kvm-". */
>  void kvm_arm_add_vcpu_properties(ARMCPU *cpu)
>  {
> @@ -517,6 +583,12 @@ void kvm_arm_add_vcpu_properties(ARMCPU *cpu)
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
> @@ -1706,6 +1778,47 @@ static bool kvm_arm_set_device_attr(ARMCPU *cpu, struct kvm_device_attr *attr,
>      return true;
>  }
>  
> +static void kvm_arm_pmu_filter_init(ARMCPU *cpu)
> +{
> +    static bool pmu_filter_init;
> +    struct kvm_device_attr attr = {
> +        .group      = KVM_ARM_VCPU_PMU_V3_CTRL,
> +        .attr       = KVM_ARM_VCPU_PMU_V3_FILTER,
> +    };
> +    int i;
> +
> +    /*
> +     * The filter only needs to be initialized through one vcpu ioctl and it
> +     * will affect all other vcpu in the vm.
> +     * It can be referred from kernel commit d7eec2360e3 ("KVM: arm64: Add PMU
> +     * event filtering infrastructure"):
> +     * Note that although the ioctl is per-vcpu, the map of allowed events is
> +     * global to the VM (it can be setup from any vcpu until the vcpu PMU is
> +     * initialized).
Personnally I would just say:

although the ioctl is per-vcpu,  the map of allowed events is global to
the VM (and can be setup from any vcpu until the vcpu PMU is initialized
> +     */
> +    if (pmu_filter_init) {
> +        return;
> +    } else {
> +        pmu_filter_init = true;
> +    }
> +
> +    if (!cpu->kvm_pmu_filter) {
> +        return;
> +    }
> +    if (kvm_vcpu_ioctl(CPU(cpu), KVM_HAS_DEVICE_ATTR, &attr)) {
> +        error_report("KVM doesn't support the PMU Event Filter!");
> +        return;
> +    }
> +
> +    for (i = 0; i < cpu->kvm_pmu_filter->len; i++) {
> +        attr.addr = (uint64_t)&g_array_index(cpu->kvm_pmu_filter,
> +                                             struct kvm_pmu_event_filter, i);
> +        if (!kvm_arm_set_device_attr(cpu, &attr, "PMU_V3_FILTER")) {
> +            break;
I think Peter requested it to fail. Here it doesn't.
> +        }
> +    }
> +}
> +
>  void kvm_arm_pmu_init(ARMCPU *cpu)
>  {
>      struct kvm_device_attr attr = {
> @@ -1716,6 +1829,8 @@ void kvm_arm_pmu_init(ARMCPU *cpu)
>      if (!cpu->has_pmu) {
>          return;
>      }
> +
> +    kvm_arm_pmu_filter_init(cpu);
>      if (!kvm_arm_set_device_attr(cpu, &attr, "PMU")) {
>          error_report("failed to init PMU");
>          abort();
> diff --git a/tests/qtest/arm-cpu-features.c b/tests/qtest/arm-cpu-features.c
> index a8a4c668ad..60a5e32eb8 100644
> --- a/tests/qtest/arm-cpu-features.c
> +++ b/tests/qtest/arm-cpu-features.c
> @@ -127,6 +127,17 @@ static bool resp_get_feature(QDict *resp, const char *feature)
>      return qdict_get_bool(props, feature);
>  }
>  
> +static const char *resp_get_feature_str(QDict *resp, const char *feature)
> +{
> +    QDict *props;
> +
> +    g_assert(resp);
> +    g_assert(resp_has_props(resp));
> +    props = resp_get_props(resp);
> +    g_assert(qdict_get(props, feature));
> +    return qdict_get_str(props, feature);
> +}
> +
>  #define assert_has_feature(qts, cpu_type, feature)                     \
>  ({                                                                     \
>      QDict *_resp = do_query_no_props(qts, cpu_type);                   \
> @@ -156,6 +167,18 @@ static bool resp_get_feature(QDict *resp, const char *feature)
>      g_assert(qdict_get_bool(_props, feature) == (expected_value));     \
>  })
>  
> +#define resp_assert_feature_str(resp, feature, expected_value)         \
> +({                                                                     \
> +    QDict *_props;                                                     \
> +                                                                       \
> +    g_assert(_resp);                                                   \
> +    g_assert(resp_has_props(_resp));                                   \
> +    _props = resp_get_props(_resp);                                    \
> +    g_assert(qdict_get(_props, feature));                              \
> +    g_assert_cmpstr(qdict_get_str(_props, feature),                    \
> +                    ==, (expected_value));                             \
> +})
> +
>  #define assert_feature(qts, cpu_type, feature, expected_value)         \
>  ({                                                                     \
>      QDict *_resp;                                                      \
> @@ -177,6 +200,17 @@ static bool resp_get_feature(QDict *resp, const char *feature)
>      qobject_unref(_resp);                                              \
>  })
>  
> +#define assert_set_feature_str(qts, cpu_type, feature, value)          \
> +({                                                                     \
> +    const char *_fmt = "{ %s: %s }";                                   \
> +    QDict *_resp;                                                      \
> +                                                                       \
> +    _resp = do_query(qts, cpu_type, _fmt, feature, value);             \
> +    g_assert(_resp);                                                   \
> +    resp_assert_feature_str(_resp, feature, value);                    \
> +    qobject_unref(_resp);                                              \
> +})
> +
>  #define assert_has_feature_enabled(qts, cpu_type, feature)             \
>      assert_feature(qts, cpu_type, feature, true)
>  
> @@ -461,6 +495,7 @@ static void test_query_cpu_model_expansion(const void *data)
>  
>      assert_has_not_feature(qts, "max", "kvm-no-adjvtime");
>      assert_has_not_feature(qts, "max", "kvm-steal-time");
> +    assert_has_not_feature(qts, "max", "kvm-pmu-filter");
>  
>      if (g_str_equal(qtest_get_arch(), "aarch64")) {
>          assert_has_feature_enabled(qts, "max", "aarch64");
> @@ -508,6 +543,7 @@ static void test_query_cpu_model_expansion_kvm(const void *data)
>      assert_set_feature(qts, "host", "kvm-no-adjvtime", false);
>  
>      if (g_str_equal(qtest_get_arch(), "aarch64")) {
> +        const char *kvm_supports_pmu_filter;
>          bool kvm_supports_steal_time;
>          bool kvm_supports_sve;
>          char max_name[8], name[8];
> @@ -546,15 +582,29 @@ static void test_query_cpu_model_expansion_kvm(const void *data)
>           * because this instance of KVM doesn't support them. Test that the
>           * features are present, and, when enabled, issue further tests.
>           */
> +        assert_has_feature(qts, "host", "kvm-pmu-filter");
>          assert_has_feature(qts, "host", "kvm-steal-time");
>          assert_has_feature(qts, "host", "sve");
>  
>          resp = do_query_no_props(qts, "host");
> +        kvm_supports_pmu_filter = resp_get_feature_str(resp, "kvm-pmu-filter");
>          kvm_supports_steal_time = resp_get_feature(resp, "kvm-steal-time");
>          kvm_supports_sve = resp_get_feature(resp, "sve");
>          vls = resp_get_sve_vls(resp);
>          qobject_unref(resp);
>  
> +        if (kvm_supports_pmu_filter) {
> +            assert_set_feature_str(qts, "host", "kvm-pmu-filter", "");
> +            assert_set_feature_str(qts, "host", "kvm-pmu-filter",
> +                                   "A:0x11-0x11");
> +            assert_set_feature_str(qts, "host", "kvm-pmu-filter",
> +                                   "D:0x11-0x11");
> +            assert_set_feature_str(qts, "host", "kvm-pmu-filter",
> +                                   "A:0x11-0x11;A:0x12-0x20");
> +            assert_set_feature_str(qts, "host", "kvm-pmu-filter",
> +                                   "D:0x11-0x11;A:0x12-0x20;D:0x12-0x15");
Just to double check this set the filter and checks the filter is
applied, is that correct?
I see you set some ranges of events. Are you sure those events are
supported on host PMU and won't create a failure on setting the PMU filter?

Thanks

Eric
> +        }
> +
>          if (kvm_supports_steal_time) {
>              /* If we have steal-time then we should be able to toggle it. */
>              assert_set_feature(qts, "host", "kvm-steal-time", false);
> @@ -622,6 +672,7 @@ static void test_query_cpu_model_expansion_kvm(const void *data)
>          assert_has_not_feature(qts, "host", "pmu");
>          assert_has_not_feature(qts, "host", "sve");
>          assert_has_not_feature(qts, "host", "kvm-steal-time");
> +        assert_has_not_feature(qts, "host", "kvm-pmu-filter");
>      }
>  
>      qtest_quit(qts);


