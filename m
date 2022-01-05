Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E6F548501B
	for <lists+kvm@lfdr.de>; Wed,  5 Jan 2022 10:36:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238916AbiAEJg6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 04:36:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:20047 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233853AbiAEJg5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Jan 2022 04:36:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641375417;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4WVzA9BJExJuk1ssdVBduOeQo2g6GGK9eFCCncTyilM=;
        b=bKwnraGCbUdNdkaYpwJ16MDzRfDl9udL9E9FR5rHITGQ88JbLBqtkhm9LEUxKLeJ6Ree/1
        +uJEkg4/Y+MghP9oektVFGdTsgILT/5fjFYLV63mvYg8lLfPvHLYMrB3plNoyIe7xev+Bu
        iEOU5hxEPXh81ZLKZUGK2KHnwNNW9+4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-201-pQY3JtOVMNqBtHGiNsjucA-1; Wed, 05 Jan 2022 04:36:56 -0500
X-MC-Unique: pQY3JtOVMNqBtHGiNsjucA-1
Received: by mail-wr1-f72.google.com with SMTP id s30-20020adfa29e000000b001a25caee635so12364925wra.19
        for <kvm@vger.kernel.org>; Wed, 05 Jan 2022 01:36:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:cc:reply-to:references
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=4WVzA9BJExJuk1ssdVBduOeQo2g6GGK9eFCCncTyilM=;
        b=KZ8fUB3TqBMp1I+5JSoCF+cL9R+4DOhVZdB5MC5G1dtwCo0jK0PHXXr3CJ/Ghv/+DE
         3eyGzOW7E/4BmhIyL7RQ3a7HbaOz7/Nrz9lXidkF5xWFJjfudgGM8SatdZTZtW2aYn0f
         9ugDogilZIdnY1mvHws3sJ5cZdXO2gJeQnkI91uzZ1s1il3fYImmjkvZSIuB4toh988H
         p9hmXmAR6ypKB6nV1wU9uGezSEKgdsNTCi49D7DtnMEuLW0GlB+K+YoxMnF/364XdbIE
         OtJ8VcfsFNj5fZGmYy8OmkrhcG/JJY13zv0Cu1Xzrv7+9IwimKFo/oUxVZ+1DEPliv23
         APuw==
X-Gm-Message-State: AOAM532VNH7IpW0DYBU35LckclHsue7jRguLSPscYjVzA5yzI4BndaFR
        B4uoMzoQprN1EbQcmF556sOU05308bS5aKw3mofJSIFWN38hMRxzVBiBd11UKcXPXWYewOWL/c7
        mdZt6O77Cv6Il
X-Received: by 2002:a05:600c:1d07:: with SMTP id l7mr2134917wms.12.1641375414209;
        Wed, 05 Jan 2022 01:36:54 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx+iYJbw7dL4mNA5vHV3pQPLdyhZKPXbHb1/JrvElCtt4s3NbE2JDK7q/xQopwj3NdJaMx++w==
X-Received: by 2002:a05:600c:1d07:: with SMTP id l7mr2134906wms.12.1641375413966;
        Wed, 05 Jan 2022 01:36:53 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id n1sm43208190wri.46.2022.01.05.01.36.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jan 2022 01:36:53 -0800 (PST)
Subject: Re: [PATCH v3 3/5] hw/arm/virt: Honor highmem setting when computing
 the memory map
From:   Eric Auger <eric.auger@redhat.com>
To:     Marc Zyngier <maz@kernel.org>, qemu-devel@nongnu.org
Cc:     Andrew Jones <drjones@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        kernel-team@android.com
Reply-To: eric.auger@redhat.com, eric.auger@redhat.com
References: <20211227211642.994461-1-maz@kernel.org>
 <20211227211642.994461-4-maz@kernel.org>
 <ef8b3500-04ab-5434-6a04-0e8b1dcc65d1@redhat.com>
Message-ID: <70643d20-b954-dcc4-0dee-6457244b64e0@redhat.com>
Date:   Wed, 5 Jan 2022 10:36:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <ef8b3500-04ab-5434-6a04-0e8b1dcc65d1@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 1/5/22 10:22 AM, Eric Auger wrote:
> Hi Marc,
> 
> On 12/27/21 10:16 PM, Marc Zyngier wrote:
>> Even when the VM is configured with highmem=off, the highest_gpa
>> field includes devices that are above the 4GiB limit.
>> Similarily, nothing seem to check that the memory is within
>> the limit set by the highmem=off option.
>>
>> This leads to failures in virt_kvm_type() on systems that have
>> a crippled IPA range, as the reported IPA space is larger than
>> what it should be.
>>
>> Instead, honor the user-specified limit to only use the devices
>> at the lowest end of the spectrum, and fail if we have memory
>> crossing the 4GiB limit.
>>
>> Reviewed-by: Andrew Jones <drjones@redhat.com>
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> ---
>>  hw/arm/virt.c | 9 ++++++++-
>>  1 file changed, 8 insertions(+), 1 deletion(-)
>>
>> diff --git a/hw/arm/virt.c b/hw/arm/virt.c
>> index 8b600d82c1..84dd3b36fb 100644
>> --- a/hw/arm/virt.c
>> +++ b/hw/arm/virt.c
>> @@ -1678,6 +1678,11 @@ static void virt_set_memmap(VirtMachineState *vms)
>>          exit(EXIT_FAILURE);
>>      }
>>  
>> +    if (!vms->highmem &&
>> +        vms->memmap[VIRT_MEM].base + ms->maxram_size > 4 * GiB) {
>> +        error_report("highmem=off, but memory crosses the 4GiB limit\n");
>> +        exit(EXIT_FAILURE);
> 
> The memory is composed of initial memory and device memory.
> device memory is put after the initial memory but has a 1GB alignment
> On top of that you have 1G page alignment per device memory slot
> 
> so potentially the highest mem address is larger than
> vms->memmap[VIRT_MEM].base + ms->maxram_size.
> I would rather do the check on device_memory_base + device_memory_size
>> +    }
>>      /*
>>       * We compute the base of the high IO region depending on the
>>       * amount of initial and device memory. The device memory start/size
>> @@ -1707,7 +1712,9 @@ static void virt_set_memmap(VirtMachineState *vms)
>>          vms->memmap[i].size = size;
>>          base += size;
>>      }
>> -    vms->highest_gpa = base - 1;
>> +    vms->highest_gpa = (vms->highmem ?
>> +                        base :
>> +                        vms->memmap[VIRT_MEM].base + ms->maxram_size) - 1;
> As per the previous comment this looks wrong to me if !highmem.
> 
> If !highmem, if RAM requirements are low we still could get benefit from
> REDIST2 and HIGH ECAM which could fit within the 4GB limit. But maybe we
the above assertion is wrong, sorry, as we kept the legacy mem map in
that situation (HIGH regions always put above 256 GB). So anyway we can
skip the extended memmap if !highmem.

Eric
> simply don't care? If we don't, why don't we simply skip the
> extended_memmap overlay as suggested in v2? I did not get your reply sorry.
> 
> Thanks
> 
> Eric
>>      if (device_memory_size > 0) {
>>          ms->device_memory = g_malloc0(sizeof(*ms->device_memory));
>>          ms->device_memory->base = device_memory_base;
> 

