Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87EC6420AD9
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 14:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232925AbhJDMZf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 08:25:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39589 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230337AbhJDMZf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Oct 2021 08:25:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633350226;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Wl7ICQODkHW0YfDfZWHTQGFAOQQBlguFC3IFpZqYzao=;
        b=FtUPZu3lbzrFI9E3Oe025T79RPLVjLgGbpLak0UG7zimfoKBxgzqnZcWtKFQ/uCVIyY99s
        JvFhhP0aaAxdXCJuHnC3y1sHnSzOilf49pnwNg2+VhXseqQUHJEZ+YrSxCMxwAfSqTajUG
        swUAhKGKY2CS7GfOwI8qkm0CjKX59I8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-502-GxpYwCHZMbS0jqio7jIMnw-1; Mon, 04 Oct 2021 08:23:45 -0400
X-MC-Unique: GxpYwCHZMbS0jqio7jIMnw-1
Received: by mail-wm1-f72.google.com with SMTP id m9-20020a05600c4f4900b003057c761567so9908905wmq.1
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 05:23:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=Wl7ICQODkHW0YfDfZWHTQGFAOQQBlguFC3IFpZqYzao=;
        b=rjtvaxJQUxmwD4ufPJlBkTcsyqGStgyDECCKOwoNGWtPC35aUnEoa3WRwqzOxSA+L+
         1vbij1K6Ax/yMhqP/iBubSzUYHNktWSEzx8uADbrY6rffaCLQ7ep1gbngox7VkbnaaXb
         vkFqpS8anGN5Raz8RqTaoFvNJVdd3xc6pxjnIfD/NsPozrclL7TMnSKq4YoVEp1QfUy6
         H3/uqs2DHxrowxH/MGQB4E9rSMkJ8+YglVg42kKCkQCShQcmeqMFdniOJgV2SSJ36quM
         kUfLtOE2ftSuRCZnMUMYoCQIMeC/fnjqLzaL7AmbHo5Gv3NY9iwIug2SfdNyBkpKoJOL
         wAvw==
X-Gm-Message-State: AOAM533QKWPsZ+jSWUru8fGHGh0MkHPccHf85/cf6j/AQnJR3yDdY4v1
        u7R9UhqtgrvlPHGkFQheuHUxS2QfA0j+7PZj2x2ouy5e7hjTJN4NtMYT6F8qWgtQQG5aXUoVrfJ
        fj9L707lu4r28
X-Received: by 2002:a05:600c:aca:: with SMTP id c10mr18225412wmr.174.1633350223513;
        Mon, 04 Oct 2021 05:23:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxitcIwPYb5MpA3gCLqjGct65p9PyV+TzRYqXfXifFRuJt7/5ttvdPSHfIcdPnoBpfMalndPA==
X-Received: by 2002:a05:600c:aca:: with SMTP id c10mr18225400wmr.174.1633350223347;
        Mon, 04 Oct 2021 05:23:43 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id f19sm14674493wmf.11.2021.10.04.05.23.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Oct 2021 05:23:42 -0700 (PDT)
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v2 3/5] hw/arm/virt: Honor highmem setting when computing
 the memory map
To:     Marc Zyngier <maz@kernel.org>, qemu-devel@nongnu.org
Cc:     Andrew Jones <drjones@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        kernel-team@android.com
References: <20211003164605.3116450-1-maz@kernel.org>
 <20211003164605.3116450-4-maz@kernel.org>
From:   Eric Auger <eric.auger@redhat.com>
Message-ID: <b36a602e-a8f4-c8ac-bd4b-95fd6d426736@redhat.com>
Date:   Mon, 4 Oct 2021 14:23:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20211003164605.3116450-4-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 10/3/21 6:46 PM, Marc Zyngier wrote:
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
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  hw/arm/virt.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/hw/arm/virt.c b/hw/arm/virt.c
> index bcf58f677d..9d2abdbd5f 100644
> --- a/hw/arm/virt.c
> +++ b/hw/arm/virt.c
> @@ -1628,6 +1628,11 @@ static void virt_set_memmap(VirtMachineState *vms)
>          exit(EXIT_FAILURE);
>      }
>  
> +    if (!vms->highmem &&
> +        vms->memmap[VIRT_MEM].base + ms->maxram_size > 4 * GiB) {
> +        error_report("highmem=off, but memory crosses the 4GiB limit\n");
> +        exit(EXIT_FAILURE);
> +    }
>      /*
>       * We compute the base of the high IO region depending on the
>       * amount of initial and device memory. The device memory start/size
> @@ -1657,7 +1662,9 @@ static void virt_set_memmap(VirtMachineState *vms)
>          vms->memmap[i].size = size;
>          base += size;
>      }
> -    vms->highest_gpa = base - 1;
> +    vms->highest_gpa = (vms->highmem ?
> +                        base :
> +                        vms->memmap[VIRT_MEM].base + ms->maxram_size) - 1;
I think I would have preferred to have

if (vms->highmem) {
   for (i = VIRT_LOWMEMMAP_LAST; i < ARRAY_SIZE(extended_memmap); i++) {
        hwaddr size = extended_memmap[i].size;

        base = ROUND_UP(base, size);
        vms->memmap[i].base = base;
        vms->memmap[i].size = size;
        base += size;
    }
}
as it is useless to execute that code and create new memmap entries in
case of !highmem.

But nevertheless, this looks correct

Eric
>      if (device_memory_size > 0) {
>          ms->device_memory = g_malloc0(sizeof(*ms->device_memory));
>          ms->device_memory->base = device_memory_base;

