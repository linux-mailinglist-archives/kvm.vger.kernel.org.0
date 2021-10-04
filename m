Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAC0E420898
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 11:44:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232117AbhJDJqC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 05:46:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35821 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231962AbhJDJqB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Oct 2021 05:46:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633340652;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Xj2EuEVOkKsDx8NDBU7nmAb1dXmNr3DxIeN0lCugnx4=;
        b=FVZv1JOXn+VW3Vqk08MTxPUKD5qsI7WBDvUyOGz3xaVTmuqGa0ydPLT9+JAeHRFBNAnsqS
        X7+qByrqgXDwbUYM10fKLQew1z+mVEqDiJeG3v92iBHlKPz+m/zcxMv+LBORxzGkuNSQQP
        ANYKr5rZXy25CJNtnYuRuHs9glCJy+I=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-312-sdSPpTgnMA-QLal7ReEiSw-1; Mon, 04 Oct 2021 05:44:11 -0400
X-MC-Unique: sdSPpTgnMA-QLal7ReEiSw-1
Received: by mail-wm1-f71.google.com with SMTP id f12-20020a1c6a0c000000b0030d696e3798so746703wmc.3
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 02:44:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Xj2EuEVOkKsDx8NDBU7nmAb1dXmNr3DxIeN0lCugnx4=;
        b=otXIohWZJyw8AYj6ADWh61WhDY4Ryaud1Uo1IZYQnXlkf5hi7BEtDaVkGqbf8yXen/
         yehiJzNsybbxEHUrn9VqbSKi21oEP2/mUFcd5WKvzGAxxnoGlJmK8tRB/fhaIpls/7F3
         Z+lxX2gAYVQK4TTxLA/xTxmua4IuYa66NrXEdtj6mJQ4GFF7PFRcPF7r7kMPPUZuZwc0
         yj37bRxyAM1hMavOBTkDn4pxuiJj7Hp43nrciVCP2o6G/Sd+X7fyJ4/fHLPsFaKKOSwx
         5nB8SrxHnBXCB6bs/4mOQANeez32COKEZuhCmrDurh3NE5YSs1iTmhDVHHEiGWt6SNzP
         9/Vw==
X-Gm-Message-State: AOAM533RhaDS8UswTKCHRBL+SY9MOquqSHvt2AIOz1TN488KABRPXBva
        IVjiWB73VXRpVnbRRJKnZ/lnp/BGhwWXA1htDEI8YZvZt+trHpV26++LV/vXIfUkUUge3vNkUsM
        spf2X0jxS4T4T
X-Received: by 2002:a1c:7d0c:: with SMTP id y12mr17252396wmc.6.1633340650116;
        Mon, 04 Oct 2021 02:44:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyJwJXaCcMvmdsIG+SbzkOzsOXG04w26FIdFhGoCqVjymAJqr3ER5/M9rlRA8olgI7/usRnrw==
X-Received: by 2002:a1c:7d0c:: with SMTP id y12mr17252376wmc.6.1633340649909;
        Mon, 04 Oct 2021 02:44:09 -0700 (PDT)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id n68sm16106200wmn.13.2021.10.04.02.44.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 02:44:09 -0700 (PDT)
Date:   Mon, 4 Oct 2021 11:44:08 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     qemu-devel@nongnu.org, Eric Auger <eric.auger@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        kernel-team@android.com
Subject: Re: [PATCH v2 2/5] hw/arm/virt: Add a control for the the highmem
 redistributors
Message-ID: <20211004094408.xfftmls7h6bbypuk@gator>
References: <20211003164605.3116450-1-maz@kernel.org>
 <20211003164605.3116450-3-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211003164605.3116450-3-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Oct 03, 2021 at 05:46:02PM +0100, Marc Zyngier wrote:
> Just like we can control the enablement of the highmem PCIe region
> using highmem_ecam, let's add a control for the highmem GICv3
> redistributor region.
> 
> Similarily to highmem_ecam, these redistributors are disabled when
> highmem is off.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  hw/arm/virt-acpi-build.c | 2 ++
>  hw/arm/virt.c            | 3 +++
>  include/hw/arm/virt.h    | 4 +++-
>  3 files changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/hw/arm/virt-acpi-build.c b/hw/arm/virt-acpi-build.c
> index d7bef0e627..f0d0b662b7 100644
> --- a/hw/arm/virt-acpi-build.c
> +++ b/hw/arm/virt-acpi-build.c
> @@ -792,6 +792,8 @@ void virt_acpi_build(VirtMachineState *vms, AcpiBuildTables *tables)
>      acpi_add_table(table_offsets, tables_blob);
>      build_fadt_rev5(tables_blob, tables->linker, vms, dsdt);
>  
> +    vms->highmem_redists &= vms->highmem;
> +
>      acpi_add_table(table_offsets, tables_blob);
>      build_madt(tables_blob, tables->linker, vms);
>  
> diff --git a/hw/arm/virt.c b/hw/arm/virt.c
> index 8021d545c3..bcf58f677d 100644
> --- a/hw/arm/virt.c
> +++ b/hw/arm/virt.c
> @@ -2053,6 +2053,8 @@ static void machvirt_init(MachineState *machine)
>  
>      virt_flash_fdt(vms, sysmem, secure_sysmem ?: sysmem);
>  
> +    vms->highmem_redists &= vms->highmem;
> +
>      create_gic(vms, sysmem);
>  
>      virt_cpu_post_init(vms, sysmem);
> @@ -2750,6 +2752,7 @@ static void virt_instance_init(Object *obj)
>      vms->gic_version = VIRT_GIC_VERSION_NOSEL;
>  
>      vms->highmem_ecam = !vmc->no_highmem_ecam;
> +    vms->highmem_redists = true;
>  
>      if (vmc->no_its) {
>          vms->its = false;
> diff --git a/include/hw/arm/virt.h b/include/hw/arm/virt.h
> index b461b8d261..787cc8a27d 100644
> --- a/include/hw/arm/virt.h
> +++ b/include/hw/arm/virt.h
> @@ -141,6 +141,7 @@ struct VirtMachineState {
>      bool secure;
>      bool highmem;
>      bool highmem_ecam;
> +    bool highmem_redists;
>      bool its;
>      bool tcg_its;
>      bool virt;
> @@ -187,7 +188,8 @@ static inline int virt_gicv3_redist_region_count(VirtMachineState *vms)
>  
>      assert(vms->gic_version == VIRT_GIC_VERSION_3);
>  
> -    return MACHINE(vms)->smp.cpus > redist0_capacity ? 2 : 1;
> +    return (MACHINE(vms)->smp.cpus > redist0_capacity &&
> +            vms->highmem_redists) ? 2 : 1;

Wouldn't it be equivalent to just use vms->highmem here?

>  }
>  
>  #endif /* QEMU_ARM_VIRT_H */
> -- 
> 2.30.2
> 

Thanks,
drew

