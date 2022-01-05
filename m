Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC989484FF3
	for <lists+kvm@lfdr.de>; Wed,  5 Jan 2022 10:22:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238844AbiAEJWr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 04:22:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:58878 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232036AbiAEJWo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Jan 2022 04:22:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641374563;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nJYdodG85/ccnAQTfgZ3AUnRmcUufSnMa1xnUl79IAI=;
        b=WOH/tIpdipa/9a1zK0+WHv6lBQylIuDl/irsaz1IX72tuDXiAEbpxYIjpCKUkI04msz4Wp
        qCL3xTiPElTR3M9BP0Bewm1y7G9fSAlgrbJyC9598aFcJiumdWuNE6Z2kuJ3uxefWO4oBQ
        rFruu0hl13CLs44nvKCGzocn4FwAyO0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-625-rNgImt6sOL2MNXrICQ_Pgw-1; Wed, 05 Jan 2022 04:22:42 -0500
X-MC-Unique: rNgImt6sOL2MNXrICQ_Pgw-1
Received: by mail-wr1-f72.google.com with SMTP id g6-20020adfbc86000000b001a2d62be244so11039686wrh.23
        for <kvm@vger.kernel.org>; Wed, 05 Jan 2022 01:22:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=nJYdodG85/ccnAQTfgZ3AUnRmcUufSnMa1xnUl79IAI=;
        b=CNowPGi6XvfKTLdfPuaysLM3k6JfMYHZ7OxVwupOF1I4KPZ+TFr4be0BUbuxBGU7KH
         TQOI/Z4vC5gBUsDlO2pZYo3symAq9vwPxdapMM19EwWjBl5ySpT2hbKJR/V0kCZkL9HF
         Xuw4Bf4EkThZSMiNmG6Ib94UvvsTtMBcEz/SueL7TeDJg0SHSQImC762RqlbAT7pSuSe
         0NVAtFxvJU4GZB6jmiJf1V56oBLqSiGNiYUNskM+wxUaTUqCsSKfsfifKFWV/6KAwZKW
         Srm4y7ko4tvFp7asQ4ArCO1ZE8PvaZ4eSLIQ2FhTsr7SCARhMtr/dnFKP9Ci/BcK2Cpc
         vMqg==
X-Gm-Message-State: AOAM532VCsQygFIH4yj9ulqb4wLKBnCYtYFV8ySkN9kpdG3Df4pf10YM
        NIci39O82Ngxehgr0FzxTBmTLoyVL8VyW2gzPlIabXOy9QzBH5ORBsx/rUeBbNL9XuZVUJUYaap
        u1PvF/g6SO2CK
X-Received: by 2002:a05:600c:3d0f:: with SMTP id bh15mr2037727wmb.27.1641374561381;
        Wed, 05 Jan 2022 01:22:41 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz5u8kXW70952AOxAuw5ljL9wtKWvvP0ulgX5HpX3UhLV+slhtiBMxJ6UN+z0RstQQDzjW3tw==
X-Received: by 2002:a05:600c:3d0f:: with SMTP id bh15mr2037711wmb.27.1641374561183;
        Wed, 05 Jan 2022 01:22:41 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id c7sm45516656wri.21.2022.01.05.01.22.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jan 2022 01:22:40 -0800 (PST)
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v3 3/5] hw/arm/virt: Honor highmem setting when computing
 the memory map
To:     Marc Zyngier <maz@kernel.org>, qemu-devel@nongnu.org
Cc:     Andrew Jones <drjones@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        kernel-team@android.com
References: <20211227211642.994461-1-maz@kernel.org>
 <20211227211642.994461-4-maz@kernel.org>
From:   Eric Auger <eric.auger@redhat.com>
Message-ID: <ef8b3500-04ab-5434-6a04-0e8b1dcc65d1@redhat.com>
Date:   Wed, 5 Jan 2022 10:22:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20211227211642.994461-4-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 12/27/21 10:16 PM, Marc Zyngier wrote:
> Even when the VM is configured with highmem=off, the highest_gpa
> field includes devices that are above the 4GiB limit.
> Similarily, nothing seem to check that the memory is within
> the limit set by the highmem=off option.
>
> This leads to failures in virt_kvm_type() on systems that have
> a crippled IPA range, as the reported IPA space is larger than
> what it should be.
>
> Instead, honor the user-specified limit to only use the devices
> at the lowest end of the spectrum, and fail if we have memory
> crossing the 4GiB limit.
>
> Reviewed-by: Andrew Jones <drjones@redhat.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  hw/arm/virt.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/hw/arm/virt.c b/hw/arm/virt.c
> index 8b600d82c1..84dd3b36fb 100644
> --- a/hw/arm/virt.c
> +++ b/hw/arm/virt.c
> @@ -1678,6 +1678,11 @@ static void virt_set_memmap(VirtMachineState *vms)
>          exit(EXIT_FAILURE);
>      }
>  
> +    if (!vms->highmem &&
> +        vms->memmap[VIRT_MEM].base + ms->maxram_size > 4 * GiB) {
> +        error_report("highmem=off, but memory crosses the 4GiB limit\n");
> +        exit(EXIT_FAILURE);

The memory is composed of initial memory and device memory.
device memory is put after the initial memory but has a 1GB alignment
On top of that you have 1G page alignment per device memory slot

so potentially the highest mem address is larger than
vms->memmap[VIRT_MEM].base + ms->maxram_size.
I would rather do the check on device_memory_base + device_memory_size
> +    }
>      /*
>       * We compute the base of the high IO region depending on the
>       * amount of initial and device memory. The device memory start/size
> @@ -1707,7 +1712,9 @@ static void virt_set_memmap(VirtMachineState *vms)
>          vms->memmap[i].size = size;
>          base += size;
>      }
> -    vms->highest_gpa = base - 1;
> +    vms->highest_gpa = (vms->highmem ?
> +                        base :
> +                        vms->memmap[VIRT_MEM].base + ms->maxram_size) - 1;
As per the previous comment this looks wrong to me if !highmem.

If !highmem, if RAM requirements are low we still could get benefit from
REDIST2 and HIGH ECAM which could fit within the 4GB limit. But maybe we
simply don't care? If we don't, why don't we simply skip the
extended_memmap overlay as suggested in v2? I did not get your reply sorry.

Thanks

Eric
>      if (device_memory_size > 0) {
>          ms->device_memory = g_malloc0(sizeof(*ms->device_memory));
>          ms->device_memory->base = device_memory_base;

