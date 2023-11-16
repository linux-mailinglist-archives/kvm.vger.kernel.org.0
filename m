Return-Path: <kvm+bounces-1882-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 71E057EDDA8
	for <lists+kvm@lfdr.de>; Thu, 16 Nov 2023 10:34:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 296311F23B21
	for <lists+kvm@lfdr.de>; Thu, 16 Nov 2023 09:34:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4788928DDD;
	Thu, 16 Nov 2023 09:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W3tqRaA+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8451F1A3
	for <kvm@vger.kernel.org>; Thu, 16 Nov 2023 01:34:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700127273;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QuTQg4Oyw0769gWhs5zrEa0uRXRA0CYB8AH2mm3Alio=;
	b=W3tqRaA+VMnUBqYtcEY+LDBteStjYe8kOWjRXThLZ2YskGiKctbcXylTXV9mPyoLpLxw1V
	HY3LQgsy9s6wXUXHZUTlOOtI+PITSyy0G1s7WUi2tZOAfBsRDK63OW4dChaiZYQcbrZp+A
	l1r32TEoSRVe7714KRdcDYjMltsObbg=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-158-2G88DXnAPGilh6_9mftiZA-1; Thu, 16 Nov 2023 04:34:32 -0500
X-MC-Unique: 2G88DXnAPGilh6_9mftiZA-1
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-5be2bce0dc9so84128a12.1
        for <kvm@vger.kernel.org>; Thu, 16 Nov 2023 01:34:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700127271; x=1700732071;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QuTQg4Oyw0769gWhs5zrEa0uRXRA0CYB8AH2mm3Alio=;
        b=uw6P6Lfyd3AdZ5OZMrLT1HX8WmMTY01rgQNvE/TfxkXLEKNJKLG7h9fRhnxauTpEDl
         YApCvkKB/kK2rgMJirMKSN6F1AGHrnLFyeCP4UAQg8ZDbzgatW2UOhPClsLwq8Glns8o
         2qdaT1yGANYGgQvc5hMG4wZxSOFBZF2EAMO4onU4Zho9l8nr/Znmy5GuZNzYPxL55tl4
         /vGwdBgO7uSYpEGs18O2IXI2DRcuJ4UvxAnAJmHeChkvHvJHEv7LzoWf+qjL0XK+Vdg5
         VK0+gSbW92uxnzr4xx7RQJJJy0RMGVdkAssq20Vd/Qs1DZjSFHMZ9ThX303voXaA/ZvJ
         +8Uw==
X-Gm-Message-State: AOJu0YyxIbufy8jR49ocdNlFFi5sMOJVFx6WaxZQQrUymT6rHrCxcC5K
	WuMYkkpj7CMPOQKS8sNfkTeS9J/9x1/sS5YWq++Cn6h2rIpnK3c7tAYksDOyNLziaShX5QWy6k0
	l0YmGmwUeh54b
X-Received: by 2002:a17:902:e74f:b0:1cd:fbc7:270e with SMTP id p15-20020a170902e74f00b001cdfbc7270emr5851474plf.2.1700127271310;
        Thu, 16 Nov 2023 01:34:31 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGJ3UeuSMW7xPsMYOmA57fbxtROXVUGVQani83bu2ED+ywYPs4rrxWnRJXXPCovjl8EldRadQ==
X-Received: by 2002:a17:902:e74f:b0:1cd:fbc7:270e with SMTP id p15-20020a170902e74f00b001cdfbc7270emr5851458plf.2.1700127270996;
        Thu, 16 Nov 2023 01:34:30 -0800 (PST)
Received: from [10.72.112.142] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id l14-20020a170902f68e00b001ca4ad86357sm8743043plg.227.2023.11.16.01.34.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Nov 2023 01:34:30 -0800 (PST)
Message-ID: <eb794c0d-51c8-ecbd-2b24-d93ae00466a0@redhat.com>
Date: Thu, 16 Nov 2023 17:34:28 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v1] arm/kvm: Enable support for KVM_ARM_VCPU_PMU_V3_FILTER
Content-Language: en-US
To: Sebastian Ott <sebott@redhat.com>
Cc: qemu-arm@nongnu.org, eric.auger@redhat.com,
 Paolo Bonzini <pbonzini@redhat.com>, Peter Maydell
 <peter.maydell@linaro.org>, kvm@vger.kernel.org, qemu-devel@nongnu.org
References: <20231113081713.153615-1-shahuang@redhat.com>
 <3a570842-aaec-6447-b043-d908e83717ec@redhat.com>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <3a570842-aaec-6447-b043-d908e83717ec@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Sebastian,

On 11/15/23 20:17, Sebastian Ott wrote:
> Hi,
> 
> On Mon, 13 Nov 2023, Shaoqin Huang wrote:
>> +    ``pmu-filter={A,D}:start-end[;...]``
>> +        KVM implements pmu event filtering to prevent a guest from 
>> being able to
>> +    sample certain events. It has the following format:
>> +
>> +    pmu-filter="{A,D}:start-end[;{A,D}:start-end...]"
>> +
>> +    The A means "allow" and D means "deny", start if the first event 
>> of the
>                                                        ^
>                                                        is
> 

Thanks for point it out.

> Also it should be stated that the first filter action defines if the whole
> list is an allow or a deny list.
> 
>> +static void kvm_arm_pmu_filter_init(CPUState *cs)
>> +{
>> +    struct kvm_pmu_event_filter filter;
>> +    struct kvm_device_attr attr = {
>> +        .group      = KVM_ARM_VCPU_PMU_V3_CTRL,
>> +        .attr       = KVM_ARM_VCPU_PMU_V3_FILTER,
>> +    };
>> +    KVMState *kvm_state = cs->kvm_state;
>> +    char *tmp;
>> +    char *str, act;
>> +
>> +    if (!kvm_state->kvm_pmu_filter)
>> +        return;
>> +
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
>> +        attr.addr = (uint64_t)&filter;
> 
> That could move to the initialization of attr (the address of filter
> doesn't change).
> 

It looks better. Will change it.

>> +        if (!kvm_arm_set_device_attr(cs, &attr, "PMU Event Filter")) {
>> +            error_report("Failed to init PMU Event Filter\n");
>> +            abort();
>> +        }
>> +    }
>> +
>> +    g_free(tmp);
>> +}
>> +
>> void kvm_arm_pmu_init(CPUState *cs)
>> {
>>     struct kvm_device_attr attr = {
>>         .group = KVM_ARM_VCPU_PMU_V3_CTRL,
>>         .attr = KVM_ARM_VCPU_PMU_V3_INIT,
>>     };
>> +    static bool pmu_filter_init = false;
>>
>>     if (!ARM_CPU(cs)->has_pmu) {
>>         return;
>>     }
>> +    if (!pmu_filter_init) {
>> +        kvm_arm_pmu_filter_init(cs);
>> +        pmu_filter_init = true;
> 
> pmu_filter_init could move inside kvm_arm_pmu_filter_init() - maybe
> together with a comment that this only needs to be called for 1 vcpu.

Good idea. Will do that.

Thanks,
Shaoqin

> 
> Thanks,
> Sebastian
> 


