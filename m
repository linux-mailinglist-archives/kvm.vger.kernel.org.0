Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BCDF489E1E
	for <lists+kvm@lfdr.de>; Mon, 10 Jan 2022 18:12:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238051AbiAJRM6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jan 2022 12:12:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:44935 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238007AbiAJRM5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 Jan 2022 12:12:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641834776;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=03p6qi4vSMUKe6Ewm0O52FmVWNcm73cafj58jFWwUb4=;
        b=axJ0XiY1I0gxAzjR5v21BlVBUQlbclASx1/Y7CYvrgUuqlCsFOwQq/ITDuFq4FhMc3gTcv
        ghPQ4OF16hvY1iV8nK2E5v5uDwjrQcCd5PnjDq6Gr7kykJDt+QUfLessO+Kgc/SDL8Uz7Q
        axyjlh8YgVg7pVk0/jSrVdLnlQOtkBw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-531-TUUGhWx3ORu-aJHYev7QxQ-1; Mon, 10 Jan 2022 12:12:55 -0500
X-MC-Unique: TUUGhWx3ORu-aJHYev7QxQ-1
Received: by mail-wm1-f72.google.com with SMTP id s17-20020a7bc0d1000000b00348737ba2a2so258879wmh.2
        for <kvm@vger.kernel.org>; Mon, 10 Jan 2022 09:12:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=03p6qi4vSMUKe6Ewm0O52FmVWNcm73cafj58jFWwUb4=;
        b=n+kFGvdfsryI3l+G9HjYLAmc8w2IIU3rTFSre4gMCztOKudmWOexc4gNYKJ0f5yGzq
         LOy99c2lTA6X9ow66RIvxDhpBwyS8SbWulUvGGy+cAakYrnAacNMmDd7Q0nVfaD0UKuT
         n5MSm/WNUlZVXYAimw0Kv3L2Hdc/KpttUvPaBO3psf7FYahfEfOi44Z5eifSEhZK1BAM
         V6lz5K8Sli28Gi9iAkOQigK9OWG5+3s5l4jYJeiix+YmXO78YzhulxaMY/WeR/z7jBrh
         dOhoNWI1GMTINBLt5l7o3McxaECyObNgHM1NcAUVKwN4mslAg4CmlogZW6N6IiqZ08lM
         6h6A==
X-Gm-Message-State: AOAM532BMvkL22rkCQKWAjzxmI6VR76EISKMMpoBoNXpkxBJ4FNLNO5b
        bTkSTEpsq6m4jV2UEjObAb0sHZ4gjJu6cMg6EGTgHlRRKfx4rpwQCGMo0v8kySnyp6ttT5/qU0W
        M1ZQifAoBrsmN
X-Received: by 2002:adf:fac3:: with SMTP id a3mr479972wrs.369.1641834772669;
        Mon, 10 Jan 2022 09:12:52 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxCFLFbIA8AorqfaYxU8UpegcJfTTKDPwhDdvVaVfqi2b0Bh1NWQH0spzhztlk2tCbDCNxvvg==
X-Received: by 2002:adf:fac3:: with SMTP id a3mr479949wrs.369.1641834772216;
        Mon, 10 Jan 2022 09:12:52 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id l6sm1383751wmq.22.2022.01.10.09.12.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Jan 2022 09:12:51 -0800 (PST)
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v4 5/6] hw/arm/virt: Disable highmem devices that don't
 fit in the PA range
To:     Marc Zyngier <maz@kernel.org>, qemu-devel@nongnu.org
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        kernel-team@android.com, Andrew Jones <drjones@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>
References: <20220107163324.2491209-1-maz@kernel.org>
 <20220107163324.2491209-6-maz@kernel.org>
From:   Eric Auger <eric.auger@redhat.com>
Message-ID: <dad34b51-51e2-37cd-44cd-7ca7c4fe6129@redhat.com>
Date:   Mon, 10 Jan 2022 18:12:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220107163324.2491209-6-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 1/7/22 5:33 PM, Marc Zyngier wrote:
> In order to only keep the highmem devices that actually fit in
> the PA range, check their location against the range and update
> highest_gpa if they fit. If they don't, mark them them as disabled.
s/them them/them
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  hw/arm/virt.c | 34 ++++++++++++++++++++++++++++------
>  1 file changed, 28 insertions(+), 6 deletions(-)
>
> diff --git a/hw/arm/virt.c b/hw/arm/virt.c
> index db4b0636e1..70b4773b3e 100644
> --- a/hw/arm/virt.c
> +++ b/hw/arm/virt.c
> @@ -1711,21 +1711,43 @@ static void virt_set_memmap(VirtMachineState *vms, int pa_bits)
>          base = vms->memmap[VIRT_MEM].base + LEGACY_RAMLIMIT_BYTES;
>      }
>  
> +    /* We know for sure that at least the memory fits in the PA space */
> +    vms->highest_gpa = memtop - 1;
> +
>      for (i = VIRT_LOWMEMMAP_LAST; i < ARRAY_SIZE(extended_memmap); i++) {
>          hwaddr size = extended_memmap[i].size;
> +        bool fits;
>  
>          base = ROUND_UP(base, size);
>          vms->memmap[i].base = base;
>          vms->memmap[i].size = size;
> +
> +        /*
> +         * Check each device to see if they fit in the PA space,
> +         * moving highest_gpa as we go.
> +         *
> +         * For each device that doesn't fit, disable it.
> +         */
> +        fits = (base + size) <= BIT_ULL(pa_bits);
> +        if (fits) {
> +            vms->highest_gpa = MAX(vms->highest_gpa, base + size - 1);
why do you need the MAX()?
> +        }
> +        switch (i) {
> +        case VIRT_HIGH_GIC_REDIST2:
> +            vms->highmem_redists &= fits;
> +            break;
> +        case VIRT_HIGH_PCIE_ECAM:
> +            vms->highmem_ecam &= fits;
> +            break;
> +        case VIRT_HIGH_PCIE_MMIO:
> +            vms->highmem_mmio &= fits;
> +            break;
> +        }
> +
>          base += size;
>      }
>  
> -    /*
> -     * If base fits within pa_bits, all good. If it doesn't, limit it
> -     * to the end of RAM, which is guaranteed to fit within pa_bits.
> -     */
> -    vms->highest_gpa = (base <= BIT_ULL(pa_bits) ? base : memtop) - 1;
> -
>      if (device_memory_size > 0) {
>          ms->device_memory = g_malloc0(sizeof(*ms->device_memory));
>          ms->device_memory->base = device_memory_base;
Eric

