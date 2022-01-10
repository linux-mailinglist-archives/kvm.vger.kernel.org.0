Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 087FB489C45
	for <lists+kvm@lfdr.de>; Mon, 10 Jan 2022 16:35:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236233AbiAJPfu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jan 2022 10:35:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:55387 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236216AbiAJPft (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 Jan 2022 10:35:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641828949;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V4pmMoHNw9NGYka6eDXChlx6TH2icG0i9HWG7XVxjIE=;
        b=W7gz/4+XdzBBnnFLfxvoygazEajh5A9SgSK6aENZ8a1OmOGlP9/9mniO/3FwbR1PCtd6wK
        /FR4IGEinme4AlQpinHOTTkLroNCxjVN7Ary3QfRZEGwqtv2eX9vCS5PaggJO6mYR4Azyf
        r70sCGEN4BisFgCgg4dR3KQ3PQbQBq0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-503-hz5aGEndPO2TmqIXxzkAnQ-1; Mon, 10 Jan 2022 10:35:48 -0500
X-MC-Unique: hz5aGEndPO2TmqIXxzkAnQ-1
Received: by mail-wm1-f71.google.com with SMTP id m15-20020a7bce0f000000b003473d477618so6564807wmc.8
        for <kvm@vger.kernel.org>; Mon, 10 Jan 2022 07:35:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=V4pmMoHNw9NGYka6eDXChlx6TH2icG0i9HWG7XVxjIE=;
        b=2f5ll2crPArVmiHlx0djvfuHPGELTEotVFdOaQdqxA07HQQZ0+CCDyIpkIr+Bj2Apz
         Oox+XFIlOqjs95VV9qVwFCkIKIjoN1TTLpmMM+WcR4z15tYyBxP19nbXBKdp+zaemUdf
         sB9rG5+qezy6jzGmayXsTUVk4hmiJ/YN8dbRf7yZtXZcBniQecNL3VveyIxfj8hmXnYS
         u4sH820Pa94GHBGloZnVWok0W23zqHmbN+pDrt7f274af8UXYDZOHQfPL1WyCRlIcWjR
         UcgNIqP6FrczVDLcBlJpzexT6bkJ8w2G4YNZ2Sz6iuIqZDyY6oqoiq+BX/kbHVJpeex/
         xFNg==
X-Gm-Message-State: AOAM5319XSKHCzTubOAqOvuCowMW2JDxI3h/LeaM35i0yaQNRkz6zGPl
        YBSH3PWV1f8n1sJViPodU2Er1x2CL0EZ3WTaNDXBZEe2UndZJlA7JoARxnk+KhkEcnIbDiV6sns
        qe39S4JNQyKaY
X-Received: by 2002:a1c:f01a:: with SMTP id a26mr3956wmb.175.1641828946331;
        Mon, 10 Jan 2022 07:35:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzlBR2VhoyVSOdpuV7VUclmcxkriBbSYJVAxqIDuFB2ondyMLGAPdicSSr3ZHYaQzMMUiZ/NA==
X-Received: by 2002:a1c:f01a:: with SMTP id a26mr3943wmb.175.1641828946188;
        Mon, 10 Jan 2022 07:35:46 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id t7sm3889718wmq.42.2022.01.10.07.35.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Jan 2022 07:35:45 -0800 (PST)
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v4 2/6] hw/arm/virt: Add a control for the the highmem
 redistributors
To:     Marc Zyngier <maz@kernel.org>, qemu-devel@nongnu.org
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        kernel-team@android.com, Andrew Jones <drjones@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>
References: <20220107163324.2491209-1-maz@kernel.org>
 <20220107163324.2491209-3-maz@kernel.org>
From:   Eric Auger <eric.auger@redhat.com>
Message-ID: <448274ac-2650-7c09-742d-584109fb5c56@redhat.com>
Date:   Mon, 10 Jan 2022 16:35:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220107163324.2491209-3-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 1/7/22 5:33 PM, Marc Zyngier wrote:
> Just like we can control the enablement of the highmem PCIe region
> using highmem_ecam, let's add a control for the highmem GICv3
> redistributor region.
>
> Similarily to highmem_ecam, these redistributors are disabled when
> highmem is off.
>
> Reviewed-by: Andrew Jones <drjones@redhat.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  hw/arm/virt-acpi-build.c | 2 ++
>  hw/arm/virt.c            | 2 ++
>  include/hw/arm/virt.h    | 4 +++-
>  3 files changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/hw/arm/virt-acpi-build.c b/hw/arm/virt-acpi-build.c
> index cdac009419..505c61e88e 100644
> --- a/hw/arm/virt-acpi-build.c
> +++ b/hw/arm/virt-acpi-build.c
> @@ -946,6 +946,8 @@ void virt_acpi_build(VirtMachineState *vms, AcpiBuildTables *tables)
>      acpi_add_table(table_offsets, tables_blob);
>      build_fadt_rev5(tables_blob, tables->linker, vms, dsdt);
>  
> +    vms->highmem_redists &= vms->highmem;
> +
>      acpi_add_table(table_offsets, tables_blob);
>      build_madt(tables_blob, tables->linker, vms);
>  
> diff --git a/hw/arm/virt.c b/hw/arm/virt.c
> index b9ce81f4a1..4d1d629432 100644
> --- a/hw/arm/virt.c
> +++ b/hw/arm/virt.c
> @@ -2106,6 +2106,7 @@ static void machvirt_init(MachineState *machine)
>      virt_flash_fdt(vms, sysmem, secure_sysmem ?: sysmem);
>  
>      vms->highmem_mmio &= vms->highmem;
> +    vms->highmem_redists &= vms->highmem;
>  
>      create_gic(vms, sysmem);
>  
> @@ -2805,6 +2806,7 @@ static void virt_instance_init(Object *obj)
>  
>      vms->highmem_ecam = !vmc->no_highmem_ecam;
>      vms->highmem_mmio = true;
> +    vms->highmem_redists = true;
>  
>      if (vmc->no_its) {
>          vms->its = false;
> diff --git a/include/hw/arm/virt.h b/include/hw/arm/virt.h
> index 9c54acd10d..dc9fa26faa 100644
> --- a/include/hw/arm/virt.h
> +++ b/include/hw/arm/virt.h
> @@ -144,6 +144,7 @@ struct VirtMachineState {
>      bool highmem;
>      bool highmem_ecam;
>      bool highmem_mmio;
> +    bool highmem_redists;
>      bool its;
>      bool tcg_its;
>      bool virt;
> @@ -190,7 +191,8 @@ static inline int virt_gicv3_redist_region_count(VirtMachineState *vms)
>  
>      assert(vms->gic_version == VIRT_GIC_VERSION_3);
>  
> -    return MACHINE(vms)->smp.cpus > redist0_capacity ? 2 : 1;
> +    return (MACHINE(vms)->smp.cpus > redist0_capacity &&
> +            vms->highmem_redists) ? 2 : 1;
If we fail to use the high redist region, is there any check that the
number of vcpus does not exceed the first redist region capacity.
Did you check that config, does it nicely fail?

Eric
>  }
>  
>  #endif /* QEMU_ARM_VIRT_H */

