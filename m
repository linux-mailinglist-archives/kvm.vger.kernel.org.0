Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 636C5492779
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 14:51:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243015AbiARNvN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 08:51:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37492 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239731AbiARNvM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Jan 2022 08:51:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642513870;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wpyCOtx9cZBw2W9lEvvyvmRvXVUbY2PgYr7UeyQNzpU=;
        b=PH7LruYnbpr04NZXy+sP9isAV3IomL50Nio6wniI9b6HgSj9PP6Ed/eoQ9bCQQ192V596F
        YZqyQJUVI9z0j5lTlmaPe4nVHwyffYc9S/kHubo84XREGwatsKMwCBvr6BxpMNEgRIPrPD
        3ARoxsKu2N5MZ5+RDEZgClhNacomNCg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-262-B3v-xr1sM0a7q2Z3OrIRRw-1; Tue, 18 Jan 2022 08:51:09 -0500
X-MC-Unique: B3v-xr1sM0a7q2Z3OrIRRw-1
Received: by mail-wm1-f71.google.com with SMTP id ay11-20020a05600c1e0b00b0034afc66f1fbso1871430wmb.9
        for <kvm@vger.kernel.org>; Tue, 18 Jan 2022 05:51:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=wpyCOtx9cZBw2W9lEvvyvmRvXVUbY2PgYr7UeyQNzpU=;
        b=6gxjId1pbAqhbtnM/Et2LIAOOUFN+kljx3vupHAjQLkPgEEc1amafEMO1l5H90X0LS
         9rMyiRC8FfSJjifvuBE8bNedyE7D/aYst1gtrXvoJhmhXcDuVnRLKd+MbDQZAXqKhu16
         tPo1EikG1YvMBmpIUEoxEPIXKR6VR3ckH6kpv4j+tW3QAhctLh8zT6bMqw4S9//eGCRC
         2PoUvnS64gw5uClPsbPwZT7cuuXXfjqY0rXTdgoBC1q+q7uVArBjrrH01T9t4L5fylGp
         rJthIA+b0yRFFhcDftln8INYZagH4b6N20IenEQtKL4hMO9q9ZMWChKGS4wVj0R8USp6
         IldA==
X-Gm-Message-State: AOAM531G0bKGfvpWfY3n7iBTCPu87aR4+sE22Mhu0HciQCBmTBzFgXd9
        Xa3f1fZaGjVdaQWacu93X25nltJdjZtGXqQ3eceOZx7DEG8uF2Ud2eq5ob+LiFQi2OKuRH/wnB+
        SzynkY3JlfURH
X-Received: by 2002:a5d:6811:: with SMTP id w17mr24307053wru.443.1642513867857;
        Tue, 18 Jan 2022 05:51:07 -0800 (PST)
X-Google-Smtp-Source: ABdhPJww7Eh/gQpLsNa7olEtt9CE0FFbWLusG97SdWpRNeWF6JuwvRVy2BXBTMONwARUG2yJVu5AdQ==
X-Received: by 2002:a5d:6811:: with SMTP id w17mr24307033wru.443.1642513867609;
        Tue, 18 Jan 2022 05:51:07 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id p4sm2596431wmq.40.2022.01.18.05.51.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jan 2022 05:51:07 -0800 (PST)
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v5 5/6] hw/arm/virt: Disable highmem devices that don't
 fit in the PA range
To:     Marc Zyngier <maz@kernel.org>, qemu-devel@nongnu.org
Cc:     Andrew Jones <drjones@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        kernel-team@android.com
References: <20220114140741.1358263-1-maz@kernel.org>
 <20220114140741.1358263-6-maz@kernel.org>
From:   Eric Auger <eric.auger@redhat.com>
Message-ID: <10f21d1f-7f95-d9ba-0803-9d11d461829a@redhat.com>
Date:   Tue, 18 Jan 2022 14:51:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220114140741.1358263-6-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 1/14/22 3:07 PM, Marc Zyngier wrote:
> In order to only keep the highmem devices that actually fit in
> the PA range, check their location against the range and update
> highest_gpa if they fit. If they don't, mark them as disabled.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  hw/arm/virt.c | 34 ++++++++++++++++++++++++++++------
>  1 file changed, 28 insertions(+), 6 deletions(-)
>
> diff --git a/hw/arm/virt.c b/hw/arm/virt.c
> index a427676b50..053791cc44 100644
> --- a/hw/arm/virt.c
> +++ b/hw/arm/virt.c
> @@ -1712,21 +1712,43 @@ static void virt_set_memmap(VirtMachineState *vms, int pa_bits)
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
> +            vms->highest_gpa = base + size - 1;
> +        }
> +
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

