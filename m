Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85B6142088C
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 11:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232339AbhJDJnF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 05:43:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37565 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231849AbhJDJnF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Oct 2021 05:43:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633340476;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dxfVhJVrqy9SilnYUxM4IeGNxJd1tbk2Hh41DGObvxE=;
        b=Zn34M2LHw4dab01WvAtoXBcNCsYSB7dmo+r2zU5Nae6KzhD8kMU6ggIdPLE8x9Do/3kb1H
        AQItDN6NtxmjKxsy+WiKjq0DHd0pEPh8zl+QQA/qvIbYRVp/253OyMVLALavTxukWmNRwa
        lQ6qd2Ux/HmyceMsmZoVQXdqYj2aD0s=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-350-wipLN_3EM-a3i_kbdctyAA-1; Mon, 04 Oct 2021 05:41:14 -0400
X-MC-Unique: wipLN_3EM-a3i_kbdctyAA-1
Received: by mail-wr1-f71.google.com with SMTP id j15-20020a5d564f000000b00160698bf7e9so4433791wrw.13
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 02:41:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dxfVhJVrqy9SilnYUxM4IeGNxJd1tbk2Hh41DGObvxE=;
        b=ALixYd16UMiXeY3VKyHjj2M7A103BszmfEL5e8x0Otf+VblR7UXUC7QyjSzf10INo2
         IEMeI+/TgFrt+5JVN2oCJVk1cTUpBUh/PwN+Ni9JP66tbMVxkMFhCpzB9nXlZOT8CkNg
         w7LfrNfIAMAJkcOE/+UFHnz9GkbdSrb+Juwno91QWoG10W4GvRsl34uzuj2NXe/uBvwZ
         h4wIDksXIKLeimV22yxKxeLNtUuNhbi++mSh8c+pc9lUVrw9IpUxduDz7NraNvLhpey1
         RbF/mu9fcyVRJB6pQVIr3MILfdT0mintpnvU3XTHkpJVLydRj9KeE+lHHXUYmUmYpmMy
         Cwqg==
X-Gm-Message-State: AOAM531jwzOxYujqvKCF8XJ3gnn6TqikvpvWW/bi6gFPzisU5rgdM+wf
        Qmw+2na6NDcUrx9XvcV3BF3DkIGt84ou85TQ/50ra4KuXWD9HtHuZJfRcFBb0tVJhRyCZoc3LQS
        eEqhXpkc7Pd66
X-Received: by 2002:adf:8b17:: with SMTP id n23mr11450042wra.290.1633340473684;
        Mon, 04 Oct 2021 02:41:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxJKWagXir+Cur7XWqj46gpIlntXbexRxFlKwV6Z5cdcFb0pk6YR7WGxNsnbwzxcb78pAGg9g==
X-Received: by 2002:adf:8b17:: with SMTP id n23mr11450026wra.290.1633340473501;
        Mon, 04 Oct 2021 02:41:13 -0700 (PDT)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id o8sm7202183wme.38.2021.10.04.02.41.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 02:41:13 -0700 (PDT)
Date:   Mon, 4 Oct 2021 11:41:11 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     qemu-devel@nongnu.org, Eric Auger <eric.auger@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        kernel-team@android.com
Subject: Re: [PATCH v2 1/5] hw/arm/virt: Key enablement of highmem PCIe on
 highmem_ecam
Message-ID: <20211004094111.2762nq634e24j4rn@gator>
References: <20211003164605.3116450-1-maz@kernel.org>
 <20211003164605.3116450-2-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211003164605.3116450-2-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Oct 03, 2021 at 05:46:01PM +0100, Marc Zyngier wrote:
> Currently, the highmem PCIe region is oddly keyed on the highmem
> attribute instead of highmem_ecam. Move the enablement of this PCIe
> region over to highmem_ecam.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  hw/arm/virt-acpi-build.c | 10 ++++------
>  hw/arm/virt.c            |  4 ++--
>  2 files changed, 6 insertions(+), 8 deletions(-)
> 
> diff --git a/hw/arm/virt-acpi-build.c b/hw/arm/virt-acpi-build.c
> index 037cc1fd82..d7bef0e627 100644
> --- a/hw/arm/virt-acpi-build.c
> +++ b/hw/arm/virt-acpi-build.c
> @@ -157,10 +157,9 @@ static void acpi_dsdt_add_virtio(Aml *scope,
>  }
>  
>  static void acpi_dsdt_add_pci(Aml *scope, const MemMapEntry *memmap,
> -                              uint32_t irq, bool use_highmem, bool highmem_ecam,
> -                              VirtMachineState *vms)
> +                              uint32_t irq, VirtMachineState *vms)
>  {
> -    int ecam_id = VIRT_ECAM_ID(highmem_ecam);
> +    int ecam_id = VIRT_ECAM_ID(vms->highmem_ecam);
>      struct GPEXConfig cfg = {
>          .mmio32 = memmap[VIRT_PCIE_MMIO],
>          .pio    = memmap[VIRT_PCIE_PIO],
> @@ -169,7 +168,7 @@ static void acpi_dsdt_add_pci(Aml *scope, const MemMapEntry *memmap,
>          .bus    = vms->bus,
>      };
>  
> -    if (use_highmem) {
> +    if (vms->highmem_ecam) {
>          cfg.mmio64 = memmap[VIRT_HIGH_PCIE_MMIO];
>      }
>  
> @@ -712,8 +711,7 @@ build_dsdt(GArray *table_data, BIOSLinker *linker, VirtMachineState *vms)
>      acpi_dsdt_add_fw_cfg(scope, &memmap[VIRT_FW_CFG]);
>      acpi_dsdt_add_virtio(scope, &memmap[VIRT_MMIO],
>                      (irqmap[VIRT_MMIO] + ARM_SPI_BASE), NUM_VIRTIO_TRANSPORTS);
> -    acpi_dsdt_add_pci(scope, memmap, (irqmap[VIRT_PCIE] + ARM_SPI_BASE),
> -                      vms->highmem, vms->highmem_ecam, vms);
> +    acpi_dsdt_add_pci(scope, memmap, (irqmap[VIRT_PCIE] + ARM_SPI_BASE), vms);

While tidying this interface, could also remove the superfluous ().

>      if (vms->acpi_dev) {
>          build_ged_aml(scope, "\\_SB."GED_DEVICE,
>                        HOTPLUG_HANDLER(vms->acpi_dev),
> diff --git a/hw/arm/virt.c b/hw/arm/virt.c
> index 7170aaacd5..8021d545c3 100644
> --- a/hw/arm/virt.c
> +++ b/hw/arm/virt.c
> @@ -1362,7 +1362,7 @@ static void create_pcie(VirtMachineState *vms)
>                               mmio_reg, base_mmio, size_mmio);
>      memory_region_add_subregion(get_system_memory(), base_mmio, mmio_alias);
>  
> -    if (vms->highmem) {
> +    if (vms->highmem_ecam) {
>          /* Map high MMIO space */
>          MemoryRegion *high_mmio_alias = g_new0(MemoryRegion, 1);
>  
> @@ -1416,7 +1416,7 @@ static void create_pcie(VirtMachineState *vms)
>      qemu_fdt_setprop_sized_cells(ms->fdt, nodename, "reg",
>                                   2, base_ecam, 2, size_ecam);
>  
> -    if (vms->highmem) {
> +    if (vms->highmem_ecam) {
>          qemu_fdt_setprop_sized_cells(ms->fdt, nodename, "ranges",
>                                       1, FDT_PCI_RANGE_IOPORT, 2, 0,
>                                       2, base_pio, 2, size_pio,
> -- 
> 2.30.2
> 


Reviewed-by: Andrew Jones <drjones@redhat.com>

Thanks,
drew

