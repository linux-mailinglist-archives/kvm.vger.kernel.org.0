Return-Path: <kvm+bounces-9391-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FA0185FB3D
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 15:28:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C3ED51C2269F
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 14:28:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7423E146916;
	Thu, 22 Feb 2024 14:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="QN9/WkQV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A32A83A8E4
	for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 14:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708612117; cv=none; b=O4+8DWNcgqXY9DWwX/FJgf5V9am3+NCm9oNij1WpkHq8U090AHhY9V6wDXYb9E/1ul7zfcPdOeB1h7PUyzbBH2fRzbsCkaeabBRia9G43LEruW2A1Zo6BtspqKyI8nM+rNim39ch92ME0faITeHVVplcBGtJZWgPYF8E53dJrtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708612117; c=relaxed/simple;
	bh=0p5Y4e1eS9MWMKKA6lWaBVkeb2cRljpZVHcyH4pcCow=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QmEahdQ4CGpuWl1CzZPhTd5bP176jg3kd35AjERhXd4Z1PkUdRd64PzvF/jI21cyKNjow86lDLEi3XxetdSto6EqRAQufylxVuXf6JVdWlfPM7knrB/ziSG469z0c15ZafGvhbFzHpGJMc+a3MSX6tKkJYQXbJQHIoY9LauXjRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=QN9/WkQV; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-55a035669d5so3550847a12.2
        for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 06:28:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1708612114; x=1709216914; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=eC+CYy2oEug9+rMCzsvGNr80fqPIx2W2fhrxncPzcUU=;
        b=QN9/WkQV3JwOys4xpNBOLIGSFdk2XDEQgGpqsgAF6NoS5iKqO78QWZdQcw00XCQKD2
         1NqWuaZAEhoxB2AHDPTBZBkPexu3ixW/3cPQCGmT93DSLHcqCUq/KCklepx3VnDRBn5g
         MLatTNBRk1ka5mu5PZzeaCsobLGVWStm23EXbceXaIOap1F1L3UtUBaGShzDEm+TBem/
         N3OODMpnfCAs6fx+UrI6VemRS3Q0nQGZTdPheMSv68iKPy8+FvX10mUcmn+KGRqP/jPi
         ZEKCcTLKI3aHaH/iJdN4xGrR98NdiHVgB3fTiqdnA0ohoolGGK+w6cjk9zPuGlYslYc9
         IL6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708612114; x=1709216914;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eC+CYy2oEug9+rMCzsvGNr80fqPIx2W2fhrxncPzcUU=;
        b=mwQ0Wn/LhGRH9QBTxo2F47sJ1PS1ntrvZcWm3UxnKhpMt6MgHh6BY3FBG6aSLwNBlP
         mnIUMveDtRfsXO9pHZmzyTak260usyeAXo8whOX8mB36OZ2ZuHAdKuJwbUdRgrv5L3fd
         UU32hEak8aBzSmwIRsaglh/XD797bfTkJQm0mBKf48lDJJBNJoomClsw/sNlc4rd1UL4
         M8m/GG9THVTFsgufjjwInJezzUSrJaI29AAa4Vbb+uhfKVqrOfo0tPViv1+G8IFckHXg
         pAN1oiO2lnEpFgJliRMBv8nr9FFPcb8KjTROvtlI9FyvIoJOPQHo3CICpVbSpMIBBDM+
         7I5w==
X-Forwarded-Encrypted: i=1; AJvYcCWW15FPuB6r5Dc+2JQgC+onW43Gb095zIIsV8iolLYAQutQ/C16aKUFQwp7nXOOWQSqUeF+On3Ee2OpNMNMrPrhD7/w
X-Gm-Message-State: AOJu0Yys3/tS6msBhz42jnNMnYJ4J44Uc+4A2i7rymmdDWx4T4KoXxxi
	fb/GWH3pp+kjg/qb00X/piFK9L6mZc02EuG+FYIRKr5E0nydROpKvuiTrGZd6WfHqvNDz/IgyM1
	yA+MV4Gox9KS5w3EC1Da2NY8MJyGiM/EMjOQB9Q==
X-Google-Smtp-Source: AGHT+IHGGZd198Umwm6cmbEPRtl4kxak3bT5a7pDH9biI6YaDN0S4+0apb2JWG0jrJmJoKkPaMS7NeVGTGmdlOSqYX4=
X-Received: by 2002:a50:bb2e:0:b0:565:11c5:c7db with SMTP id
 y43-20020a50bb2e000000b0056511c5c7dbmr2909011ede.5.1708612113988; Thu, 22 Feb
 2024 06:28:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240221063431.76992-1-shahuang@redhat.com>
In-Reply-To: <20240221063431.76992-1-shahuang@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Thu, 22 Feb 2024 14:28:22 +0000
Message-ID: <CAFEAcA-dAghULy_LibG8XLq4yUT3wZLUKvjrRzWZ+4ZSKfYEmQ@mail.gmail.com>
Subject: Re: [PATCH v7] arm/kvm: Enable support for KVM_ARM_VCPU_PMU_V3_FILTER
To: Shaoqin Huang <shahuang@redhat.com>
Cc: qemu-arm@nongnu.org, Eric Auger <eauger@redhat.com>, 
	Sebastian Ott <sebott@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, qemu-devel@nongnu.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 21 Feb 2024 at 06:34, Shaoqin Huang <shahuang@redhat.com> wrote:
>
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

The new syntax for the filter property seems quite complicated.
I think it would be worth testing it with a new test in
tests/qtest/arm-cpu-features.c.


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

"PMU"

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

Missing space before '('.

Why the '@' before 'action'?

> +  if the first @action is ALLOW). The start and end only support hexadecimal
> +  format. For example:
> +
> +  kvm-pmu-filter="A:0x11-0x11;A:0x23-0x3a;D:0x30-0x30"
> +
> +  Since the first action is allow, we have a global deny policy. It
> +  will allow event 0x11 (The cycle counter), events 0x23 to 0x3a are

lowercase "the".

> +  also allowed except the event 0x30 which is denied, and all the other
> +  events are denied.
> +

Did you check that the documentation builds and that this new
documentation renders into HTML the way you want it?

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

Drop "The ".

Should this really only be a warning, rather than an error?

> +        return;
> +    }
> +
> +    /*
> +     * The filter only needs to be initialized through one vcpu ioctl and it
> +     * will affect all other vcpu in the vm.

Weird. Why isn't it a VM ioctl if it affects the whole VM ?

> +     */
> +    if (pmu_filter_init) {
> +        return;
> +    } else {
> +        pmu_filter_init = true;
> +    }

Shouldn't we do this before we do the kvm_vcpu_ioctl check
for whether the kernel supports the filter? Otherwise presumably
we'll print the warning once per vCPU, rather than only once.

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

It would be better to do the syntax checking up-front when
the user tries to set the property. Then you can make the
property-setting return an error for invalid strings.

> +
> +        filter.base_event = start;
> +        filter.nevents = end - start + 1;
> +        filter.action = (act == 'A') ? KVM_PMU_EVENT_ALLOW :
> +                                       KVM_PMU_EVENT_DENY;
> +
> +        if (!kvm_arm_set_device_attr(cpu, &attr, "PMU_V3_FILTER")) {

Shouldn't we arrange for an error message if this fails?

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
> --
> 2.40.1

thanks
-- PMM

