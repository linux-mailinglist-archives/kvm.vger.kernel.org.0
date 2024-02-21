Return-Path: <kvm+bounces-9271-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A070385D051
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 07:16:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 68330B247B8
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 06:16:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E07F39FFE;
	Wed, 21 Feb 2024 06:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Xv+wqGuS"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FA17A35
	for <kvm@vger.kernel.org>; Wed, 21 Feb 2024 06:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708496188; cv=none; b=KForb5adgzC086SZ5ov1rZeXTk0IUz83fjKDr8Pbyhx15CbDUrhx4Zwt0hDB9Mpor+xBw44v9ev1/MVZjhmiu5Q0q0TTVM5F+m7O+htwU86695rbdKw4zbWhgqeriOP7a5awlHaYVDwVlVS7i0e3kEFvxwsbC6xS0pgAI1/kjIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708496188; c=relaxed/simple;
	bh=X4O4sqDCfGxt+hCdRbygROzsn47qnX1Rd4YMDICXBx8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pG6n3+50KTULj46AZPWmUC5TIrVB+tE+vH85gMtaIfidHLA7143nRiZIZNE/Ut1CJyhTiKHkJ1f4aaEeeex3j0987grywkEWRNg5RX4z0/17YLNiHXWf1i5hdHV2/GE5fgDo93FJjnb/W5zrZoMJid7ehe43r2PNRcDaFRZrw/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Xv+wqGuS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708496184;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QJhdyCIlMYXTG0s5GS8qyrlVcADTFEyzjfF0G46bbLk=;
	b=Xv+wqGuSysMCbVnpaSgor52hcq2hLzBV52B+8oXGuh2qpOnNN2yUdYiD3OoCNj44KZhkPR
	8lYy67XDfDjtCSgLePtSfmz15/SRX+ZBsscaUiEiz2XSgTlyyA7i0gNjGI49xBk5ISo3A0
	BYvkrBYMgyItcVYjipCfBOZdWVrVj9A=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-163-Uoa270jpM6mXw_HAHr7aQQ-1; Wed, 21 Feb 2024 01:16:23 -0500
X-MC-Unique: Uoa270jpM6mXw_HAHr7aQQ-1
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-563de65ac5dso1609915a12.1
        for <kvm@vger.kernel.org>; Tue, 20 Feb 2024 22:16:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708496182; x=1709100982;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QJhdyCIlMYXTG0s5GS8qyrlVcADTFEyzjfF0G46bbLk=;
        b=mlINM9bXA3TI2dQRidGC1dtaaHmFs09jhd85zXDL8znr1y7uAJtLLB1ZtTm8B8nY41
         3IPJ/Ad61mEBpVjNU0ZH1js7jNpqT8qYmG4nBLoN++dA4WhymkSmkupLHLYVZOyfCYzB
         btI6K9V5aBiM0qosAmmkCwTpRtXOrPNaVPqZ63MPA+12y4E3WRFgaAu2Rfs7UO0EGHlS
         kcSctQZa+3Ja7cy3n7gQJtuTTO60mBsB3cy797BZSgPtm8d/OLF9u2Zb2peDB/1vvy2L
         b385QGUP3vjGTycxtRacArYlg4CkODe/FkCTSqLFrAHS30nSWQHeYmCixhShwlgHo/13
         AkGw==
X-Forwarded-Encrypted: i=1; AJvYcCXjJKFSWlybk3N4/A2RyLOz59yAyaJAFKwF2le6asJUKsYDHrHixE6RHJoi+e62kVpieNjifnlTZKcCk8pykMsd4QUu
X-Gm-Message-State: AOJu0YzwavhHv7u+NGcphBERlzIGI0FH4HvQKnYomDtbfAh37ipD0YvD
	CFqvwodbrzJCbCLs6y5TaHNpvfylzrXPG42AmIn4jZOKZdSI7mWV2C6M6xfu70+9O7rjFMHIWXH
	15gn7fqO66MFNQuM/XFjLYXIAFrHtVAQOSS6wX5+GvrpNdmP0xQ==
X-Received: by 2002:a17:902:d683:b0:1db:c3b8:4620 with SMTP id v3-20020a170902d68300b001dbc3b84620mr12555976ply.5.1708496182057;
        Tue, 20 Feb 2024 22:16:22 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGk2qGkpMwfh5nezrB1Es2PO0igwF7Q8PBMDNee1Kj2stBTiW9ph7oL1q1443YiFA3mvduoBA==
X-Received: by 2002:a17:902:d683:b0:1db:c3b8:4620 with SMTP id v3-20020a170902d68300b001dbc3b84620mr12555957ply.5.1708496181567;
        Tue, 20 Feb 2024 22:16:21 -0800 (PST)
Received: from [10.72.116.47] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id e2-20020a170902d38200b001da0a698095sm7263361pld.282.2024.02.20.22.16.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Feb 2024 22:16:20 -0800 (PST)
Message-ID: <ea9aff1a-7a0e-4880-84bc-4132200a200b@redhat.com>
Date: Wed, 21 Feb 2024 14:16:16 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6] arm/kvm: Enable support for KVM_ARM_VCPU_PMU_V3_FILTER
To: Eric Auger <eauger@redhat.com>, qemu-arm@nongnu.org
Cc: Gavin Shan <gshan@redhat.com>, Sebastian Ott <sebott@redhat.com>,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20240201085124.152799-1-shahuang@redhat.com>
 <e2e20888-39ef-4f8d-ad5f-1130424fde4d@redhat.com>
Content-Language: en-US
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <e2e20888-39ef-4f8d-ad5f-1130424fde4d@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Eric,

On 2/15/24 17:13, Eric Auger wrote:
> Hi Shaoqin,
> 
> On 2/1/24 09:51, Shaoqin Huang wrote:
>> The KVM_ARM_VCPU_PMU_V3_FILTER provides the ability to let the VMM decide
>> which PMU events are provided to the guest. Add a new option
>> `kvm-pmu-filter` as -cpu sub-option to set the PMU Event Filtering.
>> Without the filter, all PMU events are exposed from host to guest by
>> default. The usage of the new sub-option can be found from the updated
>> document (docs/system/arm/cpu-features.rst).
>>
>> Here is an example which shows how to use the PMU Event Filtering, when
>> we launch a guest by use kvm, add such command line:
>>
>>    # qemu-system-aarch64 \
>>          -accel kvm \
>>          -cpu host,kvm-pmu-filter="D:0x11-0x11"
>>
>> Since the first action is deny, we have a global allow policy. This
>> filters out the cycle counter (event 0x11 being CPU_CYCLES).
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
>> other pmu events do still work.
>>
>> Reviewed-by: Sebastian Ott <sebott@redhat.com>
>> Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
>> ---
>> v5->v6:
>>    - Commit message improvement.
>>    - Remove some unused code.
>>    - Collect Reviewed-by, thanks Sebastian.
>>    - Use g_auto(Gstrv) to replace the gchar **.          [Eric]
>>
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
>>   target/arm/cpu.h                 |  3 ++
>>   target/arm/kvm.c                 | 76 ++++++++++++++++++++++++++++++++
>>   3 files changed, 102 insertions(+)
>>
>> diff --git a/docs/system/arm/cpu-features.rst b/docs/system/arm/cpu-features.rst
>> index a5fb929243..26e306cc83 100644
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
> nit: I would remove " now"

Will remove it.

>> +
>> +  kvm-pmu-filter="A:0x11-0x11;A:0x23-0x3a;D:0x30-0x30"
>> +
>> +  Since the first action is allow, we have a global deny policy. It
>> +  will allow event 0x11 (The cycle counter), events 0x23 to 0x3a are
>> +  also allowed except the event 0x30 which is denied, and all the other
>> +  events are denied.
>> +
>>   TCG VCPU Features
>>   =================
>>   
>> diff --git a/target/arm/cpu.h b/target/arm/cpu.h
>> index d3477b1601..2d860c227d 100644
>> --- a/target/arm/cpu.h
>> +++ b/target/arm/cpu.h
>> @@ -948,6 +948,9 @@ struct ArchCPU {
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
>> index 81813030a5..3f16f96f7e 100644
>> --- a/target/arm/kvm.c
>> +++ b/target/arm/kvm.c
>> @@ -496,6 +496,22 @@ static void kvm_steal_time_set(Object *obj, bool value, Error **errp)
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
>> @@ -517,6 +533,12 @@ void kvm_arm_add_vcpu_properties(ARMCPU *cpu)
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
>> @@ -1706,6 +1728,58 @@ static bool kvm_arm_set_device_attr(ARMCPU *cpu, struct kvm_device_attr *attr,
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
>> +    g_auto(GStrv) event_filters;
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
> I would check the returned value of sscanf. In most of the existing
> calls in qemu it is done that way.

Yep. It's better to check the return value of sscanf.

> 
> "returns the number of fields that were successfully converted and
> assigned. The return value does not include fields that were read but
> not assigned."
>> +        if ((act != 'A' && act != 'D') || (!start && !end)) {
> the 2nd check then could be replaced by start > end to check we have a
> valid range.

Yes. If we check the return value of sscanf, we can replace the second 
check to start > end, and it will help to detect the overflow.

Thanks,
Shaoqin

>> +            warn_report("Skipping invalid PMU filter %s", event_filters[i]);
>> +            continue;
>> +        }
>> +
>> +        filter.base_event = start;
>> +        filter.nevents = end - start + 1;
> the above check would help here I think. Also handle the case where it
> could overflow?
>> +        filter.action = (act == 'A') ? KVM_PMU_EVENT_ALLOW :
>> +                                       KVM_PMU_EVENT_DENY;
>> +
>> +        if (!kvm_arm_set_device_attr(cpu, &attr, "PMU_V3_FILTER")) {
>> +            break;
>> +        }
>> +    }
>> +}
>> +
>>   void kvm_arm_pmu_init(ARMCPU *cpu)
>>   {
>>       struct kvm_device_attr attr = {
>> @@ -1716,6 +1790,8 @@ void kvm_arm_pmu_init(ARMCPU *cpu)
>>       if (!cpu->has_pmu) {
>>           return;
>>       }
>> +
>> +    kvm_arm_pmu_filter_init(cpu);
>>       if (!kvm_arm_set_device_attr(cpu, &attr, "PMU")) {
>>           error_report("failed to init PMU");
>>           abort();
>>
>> base-commit: bd2e12310b18b51aefbf834e6d54989fd175976f
> Thanks
> 
> Eric
> 

-- 
Shaoqin


