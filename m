Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15A0040351C
	for <lists+kvm@lfdr.de>; Wed,  8 Sep 2021 09:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349201AbhIHHRl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Sep 2021 03:17:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41817 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348519AbhIHHRj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Sep 2021 03:17:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631085392;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nbJO5IEe+xQ4o2hyduhVSdtU4KYDyRNeaf2n3UHUb4k=;
        b=WJE6S6dv5sCQoh/0Sd0kbD9Vd3wODjbSMpUBup5PE5aE4RUxkluK9ecSkxf1m6T1h+yJwm
        FP1h4vhSSqxHSbkWBWuIfdVyVvwPLhJ7/F9wlZdzgz/7boRSeOh2NuwG3+mnDqZkJqkpsG
        bN4BU89/Mg3jHQAQi8bRXnOy6/zuJz4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-260-ajJcQ7bnMX-EtolbJj4OnQ-1; Wed, 08 Sep 2021 03:16:31 -0400
X-MC-Unique: ajJcQ7bnMX-EtolbJj4OnQ-1
Received: by mail-wr1-f69.google.com with SMTP id h1-20020adffd41000000b0015931e17ccfso214226wrs.18
        for <kvm@vger.kernel.org>; Wed, 08 Sep 2021 00:16:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=nbJO5IEe+xQ4o2hyduhVSdtU4KYDyRNeaf2n3UHUb4k=;
        b=Y4xvAMF3En+d8b57Fq2n1LHTHXv0CewbvWWj8PLL212kCEaVmsB2KE+dPczQ/sGofk
         2yZVg1dmRJSQl38T+aNcwZkZ495f1GFCEXMaKAedmqiEWHMckkzSzPtw83p76JKY0f7R
         MJOgEVX/2mgealxGaoPYw8QB/ZR+MBzLArsBLdZ5iG2kPdNVoZQapo241vZTGwDRVOaR
         CEPi4wZls7wZVsOG7QSM902xOE87zdeMMdRALc0uhsKvh5oyWFoezYW0xjKRbXKl7v0T
         6EbiUEn7C5LjU9/CRQ+qaenhjulaEl+fID701qN1vPekK9PjdxmKpyAjUrsGMmU0HcHK
         aAeg==
X-Gm-Message-State: AOAM531UnmpCRA0qM3XVNUeFXY5bILmSCLesa2DBQULeoPVuogX0BQWZ
        5r8i+LtUwjuws/WhJSKqT/LOBXLmSKk2t3eTosBuEZmX/yDiSf8owBCRepsqCsK5pbXYYbg+sIl
        X0e2HNu3y7z+3
X-Received: by 2002:adf:fb91:: with SMTP id a17mr2181596wrr.376.1631085390000;
        Wed, 08 Sep 2021 00:16:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzPKtJXLjpkkYJc6hfE/GBP0ZcfENgsVgOUyZszAz9xpVvta2M+XQswK/zCwzROecZ4lKdbxg==
X-Received: by 2002:adf:fb91:: with SMTP id a17mr2181580wrr.376.1631085389806;
        Wed, 08 Sep 2021 00:16:29 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id c3sm1259790wrd.34.2021.09.08.00.16.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Sep 2021 00:16:29 -0700 (PDT)
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH 2/3] hw/arm/virt: Honor highmem setting when computing
 highest_gpa
To:     Peter Maydell <peter.maydell@linaro.org>,
        Marc Zyngier <maz@kernel.org>
Cc:     QEMU Developers <qemu-devel@nongnu.org>,
        Andrew Jones <drjones@redhat.com>,
        kvmarm <kvmarm@lists.cs.columbia.edu>,
        kvm-devel <kvm@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>
References: <20210822144441.1290891-1-maz@kernel.org>
 <20210822144441.1290891-3-maz@kernel.org>
 <CAFEAcA9=SJd52ZEQb0gyW+2q9md4KMnLy8YsME-Mkd-AbvV41Q@mail.gmail.com>
From:   Eric Auger <eric.auger@redhat.com>
Message-ID: <8a927165-e45d-07c9-a6d6-b32303195523@redhat.com>
Date:   Wed, 8 Sep 2021 09:16:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAFEAcA9=SJd52ZEQb0gyW+2q9md4KMnLy8YsME-Mkd-AbvV41Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi
On 9/7/21 2:58 PM, Peter Maydell wrote:
> On Sun, 22 Aug 2021 at 15:45, Marc Zyngier <maz@kernel.org> wrote:
>> Even when the VM is configured with highmem=off, the highest_gpa
>> field includes devices that are above the 4GiB limit, which is
>> what highmem=off is supposed to enforce. This leads to failures
>> in virt_kvm_type() on systems that have a crippled IPA range,
>> as the reported IPA space is larger than what it should be.
>>
>> Instead, honor the user-specified limit to only use the devices
>> at the lowest end of the spectrum.
>>
>> Note that this doesn't affect memory, which is still allowed to
>> go beyond 4GiB with highmem=on configurations.
>>
>> Cc: Andrew Jones <drjones@redhat.com>
>> Cc: Eric Auger <eric.auger@redhat.com>
>> Cc: Peter Maydell <peter.maydell@linaro.org>
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> ---
>>  hw/arm/virt.c | 10 +++++++---
>>  1 file changed, 7 insertions(+), 3 deletions(-)
>>
>> diff --git a/hw/arm/virt.c b/hw/arm/virt.c
>> index 81eda46b0b..bc189e30b8 100644
>> --- a/hw/arm/virt.c
>> +++ b/hw/arm/virt.c
>> @@ -1598,7 +1598,7 @@ static uint64_t virt_cpu_mp_affinity(VirtMachineState *vms, int idx)
>>  static void virt_set_memmap(VirtMachineState *vms)
>>  {
>>      MachineState *ms = MACHINE(vms);
>> -    hwaddr base, device_memory_base, device_memory_size;
>> +    hwaddr base, device_memory_base, device_memory_size, ceiling;
>>      int i;
>>
>>      vms->memmap = extended_memmap;
>> @@ -1625,7 +1625,7 @@ static void virt_set_memmap(VirtMachineState *vms)
>>      device_memory_size = ms->maxram_size - ms->ram_size + ms->ram_slots * GiB;
>>
>>      /* Base address of the high IO region */
>> -    base = device_memory_base + ROUND_UP(device_memory_size, GiB);
>> +    ceiling = base = device_memory_base + ROUND_UP(device_memory_size, GiB);
>>      if (base < device_memory_base) {
>>          error_report("maxmem/slots too huge");
>>          exit(EXIT_FAILURE);
>> @@ -1642,7 +1642,11 @@ static void virt_set_memmap(VirtMachineState *vms)
>>          vms->memmap[i].size = size;
>>          base += size;
>>      }
>> -    vms->highest_gpa = base - 1;
>> +    if (vms->highmem) {
>> +           /* If we have highmem, move the IPA limit to the top */
>> +           ceiling = base;
>> +    }
>> +    vms->highest_gpa = ceiling - 1;
> This doesn't look right to me. If highmem is false and the
> high IO region would be above the 4GB mark then we should not
> create the high IO region at all, surely? This code looks like
> it goes ahead and puts the high IO region above 4GB and then
> lies in the highest_gpa value about what the highest used GPA is.
>
> -- PMM
>
Doesn't the problem come from "if maxram_size is < 255GiB we keep the
legacy memory map" and set base = vms->memmap[VIRT_MEM].base +
LEGACY_RAMLIMIT_BYTES; leading to IO regions allocated above?
Instead shouldn't we condition this to highmem=on only then?

But by the way do we need to added extended_memmap IO regions at all if
highmem=off?
I am not wrong the VIRT_HIGH_PCIE_ECAM and VIRT_HIGH_PCIE_MMIO only are
used if highmem=on. In create_pcie(), base_mmio_high/size_mmio_high are
used if vms->highmem and we have ecam_id =
VIRT_ECAM_ID(vms->highmem_ecam); with vms->highmem_ecam &= vms->highmem
&& (!firmware_loaded || aarch64);

So if I do not miss anything maybe we could skip the allocation of the
extended_memmap IO regions if highmem=off?

And doesn't it look reasonable to limit the number of vcpus if highmem=off?

Thanks

Eric

