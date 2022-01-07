Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34C69487B28
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 18:15:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348477AbiAGRPZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jan 2022 12:15:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44105 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240527AbiAGRPY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Jan 2022 12:15:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641575724;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4vsOOMP2jOzKaAjizeC5l39pTNWtPs1ir1jcXzS/usA=;
        b=AfD/9ROZ4cXMgz6Gxddl/7E47PW4UQSTpWccTvW2AjrgIXZFEYPxgqvcFejuesSfbztQIt
        kZVh+doC3x9T8/dlqu57hV1gd8J4iDuhZmiSvEPN9K0y/sQSGEH8xZBGXsB5b3VTFd7Qd3
        zBUAXK/rFxrEAaPcNzyBLAeW5ufuN78=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-52-Hqi-4svQNzm6CznyRk09Bg-1; Fri, 07 Jan 2022 12:15:22 -0500
X-MC-Unique: Hqi-4svQNzm6CznyRk09Bg-1
Received: by mail-wm1-f72.google.com with SMTP id m15-20020a05600c3b0f00b003465ede5e04so1877548wms.2
        for <kvm@vger.kernel.org>; Fri, 07 Jan 2022 09:15:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=4vsOOMP2jOzKaAjizeC5l39pTNWtPs1ir1jcXzS/usA=;
        b=YszuQc5ZqcOSYIWfa2L/7DxQvoLKOsPLBJ/N+qdfcIN+0ap2LSdL4JrhsCX/sYcFUu
         UHicq0eLKUQUujkatknXuMnJlSyfax8F1cHBMFwPy55UK76S6DymozPgs5zra4d9MeI1
         ZnbU8OJFTPqjwrF/K7WlV0vYglvx3kIMpiaPAVO4fIf3xUjSPg+jlZdIOM+bcGp09hsI
         qGw9IOJ8TwazGmpDTFhqpNrQEzLElsn9v0co2YODmVNSHN/7zn5wSpw7pb2Q505RET0J
         MHiZAhMCc2H+bOmrykxr3rbBOOvRlW06KKPDAE8ZxdjT0ZCCerSc5NBGZIuVdc2JD4Bz
         uCig==
X-Gm-Message-State: AOAM530o4yfemQzVO7U6+p2zTerXPc1lZrp0YfCua2YrTJqcRcCiaAqB
        scSlvB8PxZvvsf6GYwIEsS7taVO8/lQh6z4tXkG6lnkZAcNzyGn0KC2sn/HaxIBWnA6nqsows1n
        icEKiPTWbjmq0
X-Received: by 2002:a5d:6483:: with SMTP id o3mr58268895wri.101.1641575721113;
        Fri, 07 Jan 2022 09:15:21 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx8r1YuVw97cm+4Ci+idvC+xsdVFCO7vo+Z/vxPfFrHtrqAw3arjPJQbNKCupw6ctQsN426gQ==
X-Received: by 2002:a5d:6483:: with SMTP id o3mr58268875wri.101.1641575720919;
        Fri, 07 Jan 2022 09:15:20 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id y15sm1351601wmi.40.2022.01.07.09.15.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Jan 2022 09:15:20 -0800 (PST)
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v3 3/5] hw/arm/virt: Honor highmem setting when computing
 the memory map
To:     Marc Zyngier <maz@kernel.org>
Cc:     qemu-devel@nongnu.org, Andrew Jones <drjones@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        kernel-team@android.com
References: <20211227211642.994461-1-maz@kernel.org>
 <20211227211642.994461-4-maz@kernel.org>
 <ef8b3500-04ab-5434-6a04-0e8b1dcc65d1@redhat.com>
 <871r1kzhbp.wl-maz@kernel.org>
From:   Eric Auger <eric.auger@redhat.com>
Message-ID: <d330de15-b452-1f9c-14fa-906b88a8b4c4@redhat.com>
Date:   Fri, 7 Jan 2022 18:15:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <871r1kzhbp.wl-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 1/6/22 10:26 PM, Marc Zyngier wrote:
> On Wed, 05 Jan 2022 09:22:39 +0000,
> Eric Auger <eric.auger@redhat.com> wrote:
>> Hi Marc,
>>
>> On 12/27/21 10:16 PM, Marc Zyngier wrote:
>>> Even when the VM is configured with highmem=off, the highest_gpa
>>> field includes devices that are above the 4GiB limit.
>>> Similarily, nothing seem to check that the memory is within
>>> the limit set by the highmem=off option.
>>>
>>> This leads to failures in virt_kvm_type() on systems that have
>>> a crippled IPA range, as the reported IPA space is larger than
>>> what it should be.
>>>
>>> Instead, honor the user-specified limit to only use the devices
>>> at the lowest end of the spectrum, and fail if we have memory
>>> crossing the 4GiB limit.
>>>
>>> Reviewed-by: Andrew Jones <drjones@redhat.com>
>>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>>> ---
>>>  hw/arm/virt.c | 9 ++++++++-
>>>  1 file changed, 8 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/hw/arm/virt.c b/hw/arm/virt.c
>>> index 8b600d82c1..84dd3b36fb 100644
>>> --- a/hw/arm/virt.c
>>> +++ b/hw/arm/virt.c
>>> @@ -1678,6 +1678,11 @@ static void virt_set_memmap(VirtMachineState *vms)
>>>          exit(EXIT_FAILURE);
>>>      }
>>>  
>>> +    if (!vms->highmem &&
>>> +        vms->memmap[VIRT_MEM].base + ms->maxram_size > 4 * GiB) {
>>> +        error_report("highmem=off, but memory crosses the 4GiB limit\n");
>>> +        exit(EXIT_FAILURE);
>> The memory is composed of initial memory and device memory.
>> device memory is put after the initial memory but has a 1GB alignment
>> On top of that you have 1G page alignment per device memory slot
>>
>> so potentially the highest mem address is larger than
>> vms->memmap[VIRT_MEM].base + ms->maxram_size.
>> I would rather do the check on device_memory_base + device_memory_size
> Yup, that's a good point.
>
> There is also a corner case in one of the later patches where I check
> this limit against the PA using the rounded-up device_memory_size.
> This could result in returning an error if the last memory slot would
> still fit in the PA space, but the rounded-up quantity wouldn't. I
> don't think it matters much, but I'll fix it anyway.
>
>>> +    }
>>>      /*
>>>       * We compute the base of the high IO region depending on the
>>>       * amount of initial and device memory. The device memory start/size
>>> @@ -1707,7 +1712,9 @@ static void virt_set_memmap(VirtMachineState *vms)
>>>          vms->memmap[i].size = size;
>>>          base += size;
>>>      }
>>> -    vms->highest_gpa = base - 1;
>>> +    vms->highest_gpa = (vms->highmem ?
>>> +                        base :
>>> +                        vms->memmap[VIRT_MEM].base + ms->maxram_size) - 1;
>> As per the previous comment this looks wrong to me if !highmem.
> Agreed.
>
>> If !highmem, if RAM requirements are low we still could get benefit from
>> REDIST2 and HIGH ECAM which could fit within the 4GB limit. But maybe we
>> simply don't care?
> I don't see how. These devices live at a minimum of 256GB, which
> contradicts the very meaning of !highmem being a 4GB limit.
Yes I corrected the above statement afterwards, sorry for the noise.
>
>> If we don't, why don't we simply skip the extended_memmap overlay as
>> suggested in v2? I did not get your reply sorry.
> Because although this makes sense if you only care about a 32bit
> limit, we eventually want to check against an arbitrary PA limit and
> enable the individual devices that do fit in that space.

In my understanding that is what virt_kvm_type() was supposed to do by
testing the result of kvm_arm_get_max_vm_ipa_size and requested_pa_size
(which accounted the high regions) and exiting if they were
incompatible. But I must miss something.
>
> In order to do that, we need to compute the base addresses for these
> extra devices. Also, computing 3 base addresses isn't going to be
> massively expensive.
>
> Thanks,
>
> 	M.
>
Eric

