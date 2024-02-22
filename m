Return-Path: <kvm+bounces-9362-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B50A85F4E2
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 10:46:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B70E2B27046
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 09:46:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A812C383AF;
	Thu, 22 Feb 2024 09:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YfDQlBFl"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 164493B290
	for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 09:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708595127; cv=none; b=mpsHAfyvI0x8MpKWp4346hbLpyB3/jQBtIXpTQejd7A/2wZuutWkCOBBr/wkQpj7+IjFHmANDea1AKiT+l/0vuZjg4jEU8vtnZp2Fi1C4nHlEF0Sxo8mE99qPNva/jIlipWwzqgFDYqbEpWL+BGVeNJ3cgsjQ086WQXwogyefOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708595127; c=relaxed/simple;
	bh=Ypiuk9HgqBpJ5r004H8hzqkyvqCw/wyQ2Sbd0VFET1M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m3GmHMwvQFaUcrNrmy8zVZGSP8drd/DgBk+2lsDq3o8e99ihvZhSHZ+r1H9kNuvEq6WHgai4coGzusvCYUNqUSMhwjcrf0wq19c4gABrNFzKXiNPUGzKU2TmhP7l3hYFcSnZGbxThjbOePNwe6Hs820sadDib4vSSECrHqLZSTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YfDQlBFl; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708595125;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OqvCsNgdDtfDySwuhgDSj+1POt1fOzibmhvUcXpywZo=;
	b=YfDQlBFlpKR190MsOWi0T+Y5x0OyWocUFztJx0MiigBRtelpdfKayYBYGJ5XPmzcB6kmb+
	Sl8P434HnFOZWIiuDpya/oekfQL6FVYPQQLEUC/QaopWxraB3UdYlUECkQ8rmTpw+chYa1
	sXfeavrqEFtgo0v7Ty28EtHZT4M61pw=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-402-hvKiyiNNP4OWWTuOAaz_Kw-1; Thu, 22 Feb 2024 04:45:23 -0500
X-MC-Unique: hvKiyiNNP4OWWTuOAaz_Kw-1
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-512aacf66d1so1218603e87.3
        for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 01:45:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708595122; x=1709199922;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OqvCsNgdDtfDySwuhgDSj+1POt1fOzibmhvUcXpywZo=;
        b=tNtpUlB16vCtmiVc4cTNWx8PLcHPkUtvH4PLyMaz+/Kq7hdpdijLRTCXaBS4VNjQt8
         IjDkdsDOtWfHK9lmz8La2xQSS6eryacBbfu7GECkzQpLGCK1IcfAhBrxlbO7qM0IFmj2
         uFHzqS3UB4ubnmUiUfyC48c2BtPNauj72F+LubnaSKsgFGfOSiNp3BVy0KKQp34lYTyL
         0H3XT4As48UuJYdP1vjqdxK1bUuPWAZx79s60qXhPB5ZGDOE8ZB0tFXPLKiTDE2hwGnu
         uJB+ZyCicEA72oJzlpsg3sWyDBLJkw+XWTYnSTzdtnwtaQXK42vw/LAmzjmHFLDeq564
         7gEQ==
X-Forwarded-Encrypted: i=1; AJvYcCUaVx71xTBE5WyGMv0k+uC9ObPQgQ1mkt13NHUWkfxY1+kACuAWN9AcL9XIqySDrapsFRFWdl9sQPsxXyimrFy1Biwa
X-Gm-Message-State: AOJu0Yy9Dtl1NktBtZNr8vXTuY+g9Us/AdXz0MqeYsFZAVcnlFw7PVy3
	t23wyvtlLKzOIJt8ADwlvXtnwTbH9hiRDDf0CqxzUk2ICguH3s2dDQsyH0WTkQxglumieCCBQrq
	x1haEfva7qrsAilmU8rjbVeDOwa2VbjWYP2syE8Vf/rscF0RypQ==
X-Received: by 2002:ac2:5926:0:b0:511:694b:245a with SMTP id v6-20020ac25926000000b00511694b245amr12352956lfi.58.1708595121933;
        Thu, 22 Feb 2024 01:45:21 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEJmrEwatCxIdmciAUaPEqaV5LxZy1ec3dxGWteZw5yNpghGwNToUh38oj1Lks515U2ZDD7WA==
X-Received: by 2002:ac2:5926:0:b0:511:694b:245a with SMTP id v6-20020ac25926000000b00511694b245amr12352939lfi.58.1708595121465;
        Thu, 22 Feb 2024 01:45:21 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id n22-20020a05600c4f9600b00411a6ce0f99sm21585408wmq.24.2024.02.22.01.45.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Feb 2024 01:45:21 -0800 (PST)
Message-ID: <4eba4e50-92aa-4eb8-bbaf-38076195e844@redhat.com>
Date: Thu, 22 Feb 2024 10:45:19 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7] arm/kvm: Enable support for KVM_ARM_VCPU_PMU_V3_FILTER
Content-Language: en-US
To: Shaoqin Huang <shahuang@redhat.com>, qemu-arm@nongnu.org
Cc: Sebastian Ott <sebott@redhat.com>,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20240221063431.76992-1-shahuang@redhat.com>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <20240221063431.76992-1-shahuang@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Shaoqin,
On 2/21/24 07:34, Shaoqin Huang wrote:
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
> Reviewed-by: Sebastian Ott <sebott@redhat.com>
> Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
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
> 
>  docs/system/arm/cpu-features.rst | 23 +++++++++
>  target/arm/cpu.h                 |  3 ++
>  target/arm/kvm.c                 | 80 ++++++++++++++++++++++++++++++++
>  3 files changed, 106 insertions(+)
> 
> diff --git a/docs/system/arm/cpu-features.rst b/docs/system/arm/cpu-features.rst
> index a5fb929243..7c8f6a60ef 100644
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
> +  format. For example:
> +
> +  kvm-pmu-filter="A:0x11-0x11;A:0x23-0x3a;D:0x30-0x30"
> +
> +  Since the first action is allow, we have a global deny policy. It
> +  will allow event 0x11 (The cycle counter), events 0x23 to 0x3a are
> +  also allowed except the event 0x30 which is denied, and all the other
> +  events are denied.
> +
>  TCG VCPU Features
>  =================
>  
> diff --git a/target/arm/cpu.h b/target/arm/cpu.h
> index 63f31e0d98..f7f2431755 100644
> --- a/target/arm/cpu.h
> +++ b/target/arm/cpu.h
> @@ -948,6 +948,9 @@ struct ArchCPU {
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
> index 81813030a5..5c62580d34 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -496,6 +496,22 @@ static void kvm_steal_time_set(Object *obj, bool value, Error **errp)
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
> @@ -517,6 +533,12 @@ void kvm_arm_add_vcpu_properties(ARMCPU *cpu)
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
> @@ -1706,6 +1728,62 @@ static bool kvm_arm_set_device_attr(ARMCPU *cpu, struct kvm_device_attr *attr,
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
> +    g_auto(GStrv) event_filters;
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
> +        if (sscanf(event_filters[i], "%c:%hx-%hx", &act, &start, &end) != 3) {
> +            warn_report("Skipping invalid PMU filter %s", event_filters[i]);
> +            continue;
> +        }
> +
> +        if ((act != 'A' && act != 'D') || start > end) {
> +            warn_report("Skipping invalid PMU filter %s", event_filters[i]);
> +            continue;
> +        }
> +
> +        filter.base_event = start;
> +        filter.nevents = end - start + 1;
> +        filter.action = (act == 'A') ? KVM_PMU_EVENT_ALLOW :
> +                                       KVM_PMU_EVENT_DENY;
> +
> +        if (!kvm_arm_set_device_attr(cpu, &attr, "PMU_V3_FILTER")) {
> +            break;
> +        }
> +    }
> +}
> +
>  void kvm_arm_pmu_init(ARMCPU *cpu)
>  {
>      struct kvm_device_attr attr = {
> @@ -1716,6 +1794,8 @@ void kvm_arm_pmu_init(ARMCPU *cpu)
>      if (!cpu->has_pmu) {
>          return;
>      }
> +
> +    kvm_arm_pmu_filter_init(cpu);
>      if (!kvm_arm_set_device_attr(cpu, &attr, "PMU")) {
>          error_report("failed to init PMU");
>          abort();
> 
> base-commit: 760b4dcdddba4a40b9fa0eb78fdfc7eda7cb83d0


