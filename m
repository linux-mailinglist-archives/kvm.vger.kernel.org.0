Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 715D5420A85
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 14:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233036AbhJDMCP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 08:02:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30310 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229778AbhJDMCO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Oct 2021 08:02:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633348825;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Szh1sZdd2NA++7VzE8dfvZgPCeKZLBpLUKEMevzbR2c=;
        b=OCh2rWS6JEVzBAEPP2cpylcumjxb6M93vOCxnLT5WKf7qVoijo7QPI07rU+3SxJ0+CykDd
        NYge2UQc5KCaQqKrLrZyip2metEE75hZGZhmwWJEMdEAXPJdHxF2pHoTV8Vo6Ks7qfWY6X
        LJaGiTbxHxzDAFYiHSNM1wgOW3+S2Bs=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-584-ddmst8FYOva4p7Mydj9pQw-1; Mon, 04 Oct 2021 08:00:24 -0400
X-MC-Unique: ddmst8FYOva4p7Mydj9pQw-1
Received: by mail-wm1-f69.google.com with SMTP id 129-20020a1c0187000000b0030d4081c36cso4061820wmb.0
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 05:00:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=Szh1sZdd2NA++7VzE8dfvZgPCeKZLBpLUKEMevzbR2c=;
        b=UsZPrvodDBajG1OH+KLCBLKO42jXJCNoTlEZ6Upzrf8ph1Bu6Qi/b/i7oSmZpATXNB
         nz6KF38GAXOD30TfM0T08dfz6oIpbi1c67ZUhboTtwL56PWLLngMiLits4+rDZFlifPB
         RwF82BwZaxFpcsRIvCcixTapbPnDEJ4jE65ZMQGKsSwWNfHG54yGbtWnmokNAM+K1ugu
         WQ2Y8Hy8BDoTzEtl40tppFQRFUELL+fIsp8KELsM/wBdMQizsTg+Tx0Qkq0Xr8w+PX/q
         CH+CswA5dtWXfKqX6r8BeTZbhK5GahQQf+gf7d78xJxtLTq34Jv43xRh8JNl7d1AwPKe
         1YqA==
X-Gm-Message-State: AOAM5332G6+IgIs5tCjm6/0MT0YfVkElc15Q0ISjpZ9+7GluXu92haaV
        9NPuxpRXvrm2ZdrDgbBEQsSIeWpj523XND/+qO1wZsc9KTockJaIzYSE++RWlbybsNZ4ybkzsBz
        z3sOtL2TEG7Py
X-Received: by 2002:adf:a45e:: with SMTP id e30mr12058140wra.269.1633348823446;
        Mon, 04 Oct 2021 05:00:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxHUUsSuliMbaWMUJfOxhomX+YqGVSB+h6Tbvc9XMFwkt9wv5ln2ZOsJjF3r/t46K2PWn19YQ==
X-Received: by 2002:adf:a45e:: with SMTP id e30mr12058101wra.269.1633348823180;
        Mon, 04 Oct 2021 05:00:23 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id j27sm16609782wms.6.2021.10.04.05.00.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Oct 2021 05:00:22 -0700 (PDT)
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v2 1/5] hw/arm/virt: Key enablement of highmem PCIe on
 highmem_ecam
To:     Marc Zyngier <maz@kernel.org>, qemu-devel@nongnu.org
Cc:     Andrew Jones <drjones@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        kernel-team@android.com
References: <20211003164605.3116450-1-maz@kernel.org>
 <20211003164605.3116450-2-maz@kernel.org>
From:   Eric Auger <eric.auger@redhat.com>
Message-ID: <dbe883ca-880e-7f2b-1de7-4b2d3361545d@redhat.com>
Date:   Mon, 4 Oct 2021 14:00:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20211003164605.3116450-2-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 10/3/21 6:46 PM, Marc Zyngier wrote:
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
highmem_ecam is more restrictive than use_highmem:
vms->highmem_ecam &= vms->highmem && (!firmware_loaded || aarch64);

If I remember correctly there was a problem using highmem ECAM with 32b
AAVMF FW.

However 5125f9cd2532 ("hw/arm/virt: Add high MMIO PCI region, 512G in
size") introduced high MMIO PCI region without this constraint.

So to me we should keep vms->highmem here

Eric

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

