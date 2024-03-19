Return-Path: <kvm+bounces-12172-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AF91880415
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 18:58:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BF1951C22A14
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 17:58:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2777B2C19B;
	Tue, 19 Mar 2024 17:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PKzcgcwY"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF4F2BAE3
	for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 17:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710871121; cv=none; b=nWzAqfgQY3/MQCVRfO0eCMQLtJZ4IduZlavwA2FfNTLx/Bux/PQAKqq0zqWwhqBMdT5pWFA+Oh9uApNI8ozazO7mk090c+qIHsllVwU8JedF1EMCT5XAGXISPbWu1IkKVJF/9bKKd1V5YoxX5/FO/LJ1rv9bf211b+5o4NEqeW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710871121; c=relaxed/simple;
	bh=c1TH/o2/DtZoo/bfXRGvptSy9R959uzhA62bCDbSAGM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=u9xL+bbvEkZFOW2jr94Jzmdmqm5cGK3WBN+tlYG8nfqBiEFc3nf/wbexz/1CEcM60wQNY42jdwnGiXib+q/8TA4U4I7XUIkXSKSsQKg2/H2bzhw6P6S2Z37nGj6MbRUjM8BvsR04R7O0jjtphP4HKwtFlPL9xwgYj7p6dOPQ1+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PKzcgcwY; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710871118;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jYmU+L2QgZldk4KcApW+ioelmr5/F2Py6BDqP9YORtA=;
	b=PKzcgcwYbI2ZZkSQ6t7yTtZcXx0P5m1/Dz4AWWKkCbLvqB+6Xaa3K4AUrj7/jV+DvLj96H
	sM/Bq45blsocfXFtgGROzBUG7cjlpshlnvVBnKYJ/d6RDfOIP6BtZFNQzkAppdHWqEYhli
	FMxipWzGLrQnRZmpf4yxaX7K8xgYNAg=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-690-Mw6mV3NEPCWS9HEj8WAB6A-1; Tue, 19 Mar 2024 13:58:37 -0400
X-MC-Unique: Mw6mV3NEPCWS9HEj8WAB6A-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-33ec0700091so3718349f8f.0
        for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 10:58:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710871115; x=1711475915;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jYmU+L2QgZldk4KcApW+ioelmr5/F2Py6BDqP9YORtA=;
        b=LD3B7ycj8FRcbIhnB9TsRb1oMYWigrZ8OGkl2DjIUzUwFx3I9knb6DHcRBG6TNLDcY
         FoltRtYJ0vxU6e5wJrr1kbzx9jnzzQppk9FBEc+wfzY0xh8ucg7Gd3doohdiL4pdl2Y3
         kTe/c3OL44y2v3l0+kIvAHwEdcVC0MYlUDI4mC6VIsYb0c04DQTa0GQrXE4KMHGA8ecz
         y+eBDhjjF4xGre9DMXTyQKsN1qdAqEbyXtdj/nDfFf3TyWVrTPEZTtdn5FtfADdKOmc2
         417h/IY//T8D+m7bCOoVuWiR4yI6gnCwM1X8jWAY4dalEkThk6vOZrtUMrjrwl75FNH6
         uXkA==
X-Forwarded-Encrypted: i=1; AJvYcCU/L6f6p1BZXdsq53zyVTt7pB/2y4RPV3LW4+qnkfo9/NbI5CpEmQ1u300zjVpZS2YVL/Ikh9SvNzG4dbJ14kEfVW+2
X-Gm-Message-State: AOJu0Yzmntg5gJIpqVMUNtA8YnNzJAA32BYvwBMsYsUkQbVbsZGz1sFX
	OuMUDEzzlI/hfFJzW1V5wRXEAgxBHuh/nb8hQjzG26qrjMG7SU1tyZvb5eqGeoejXs+QFd1FSNb
	S1luQa8gVRcb88omOP8yW+75zxJ47f1qGrm55NvbfZ2TUJ8BsSiuF+0hj2A==
X-Received: by 2002:adf:f583:0:b0:341:8efd:e20d with SMTP id f3-20020adff583000000b003418efde20dmr1471616wro.23.1710871115203;
        Tue, 19 Mar 2024 10:58:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEJaj9GK+Gn5lZ9KkbZqTGQDZfNRc+e2z6IHIpdRPOxzqcjSQsXBXG/qADG5Bw+HKzuiR6uMA==
X-Received: by 2002:adf:f583:0:b0:341:8efd:e20d with SMTP id f3-20020adff583000000b003418efde20dmr1471599wro.23.1710871114880;
        Tue, 19 Mar 2024 10:58:34 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id y10-20020a5d4aca000000b0033e03d37685sm12909668wrs.55.2024.03.19.10.58.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Mar 2024 10:58:34 -0700 (PDT)
Message-ID: <84e01fa8-0de6-4d2b-8696-53cd3c3f42fa@redhat.com>
Date: Tue, 19 Mar 2024 18:58:33 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7] arm/kvm: Enable support for KVM_ARM_VCPU_PMU_V3_FILTER
Content-Language: en-US
To: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Shaoqin Huang <shahuang@redhat.com>
Cc: qemu-arm@nongnu.org, Sebastian Ott <sebott@redhat.com>,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20240221063431.76992-1-shahuang@redhat.com>
 <ZfmtxxlATpvhK61y@redhat.com>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <ZfmtxxlATpvhK61y@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Daniel,

On 3/19/24 16:22, Daniel P. Berrangé wrote:
> On Wed, Feb 21, 2024 at 01:34:31AM -0500, Shaoqin Huang wrote:
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
>>   # qemu-system-aarch64 \
>>         -accel kvm \
>>         -cpu host,kvm-pmu-filter="D:0x11-0x11"
> 
> snip
> 
>> @@ -517,6 +533,12 @@ void kvm_arm_add_vcpu_properties(ARMCPU *cpu)
>>                               kvm_steal_time_set);
>>      object_property_set_description(obj, "kvm-steal-time",
>>                                      "Set off to disable KVM steal time.");
>> +
>> +    object_property_add_str(obj, "kvm-pmu-filter", kvm_pmu_filter_get,
>> +                            kvm_pmu_filter_set);
>> +    object_property_set_description(obj, "kvm-pmu-filter",
>> +                                    "PMU Event Filtering description for "
>> +                                    "guest PMU. (default: NULL, disabled)");
>>  }
> 
> Passing a string property, but....[1]
> 
>>  
>>  bool kvm_arm_pmu_supported(void)
>> @@ -1706,6 +1728,62 @@ static bool kvm_arm_set_device_attr(ARMCPU *cpu, struct kvm_device_attr *attr,
>>      return true;
>>  }
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
> 
> If the user requested a filter and it can't be supported, QEMU
> must exit with an error, not ignore the user's request.
> 
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
>> +        if (sscanf(event_filters[i], "%c:%hx-%hx", &act, &start, &end) != 3) {
>> +            warn_report("Skipping invalid PMU filter %s", event_filters[i]);
>> +            continue;
> 
> Warning on user syntax errors is undesirable - it should be a fatal
> error of the user gets this wrong.
> 
>> +        }
>> +
>> +        if ((act != 'A' && act != 'D') || start > end) {
>> +            warn_report("Skipping invalid PMU filter %s", event_filters[i]);
>> +            continue;
> 
> Likewise should be fatal.
> 
>> +        }
>> +
>> +        filter.base_event = start;
>> +        filter.nevents = end - start + 1;
>> +        filter.action = (act == 'A') ? KVM_PMU_EVENT_ALLOW :
>> +                                       KVM_PMU_EVENT_DENY;
>> +
>> +        if (!kvm_arm_set_device_attr(cpu, &attr, "PMU_V3_FILTER")) {
>> +            break;
>> +        }
>> +    }
>> +}
> 
> ..[1] then implementing a custom parser is rather a QEMU design anti-pattern,
> especially when the proposed syntax is incapable of being mapped into the
> normal QAPI syntax for a list of structs should we want to fully convert
> -cpu to QAPI parsing later. I wonder if can we model this property with
> QAPI now ?
I guess you mean creating a new property like those in
hw/core/qdev-properties-system.c for instance  and populating an array
of those at CPU object level?

Note there is v8 but most of your comments still apply
https://lore.kernel.org/all/20240312074849.71475-1-shahuang@redhat.com/

Thanks

Eric
> 
> With regards,
> Daniel


