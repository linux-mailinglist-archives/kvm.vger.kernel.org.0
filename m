Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 167095254E9
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 20:33:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357696AbiELSdc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 14:33:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357687AbiELSda (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 14:33:30 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEB3A66AF9
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 11:33:28 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id n18so5732764plg.5
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 11:33:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4IDTIz43dDChb9K4Li6kT2GF0x6Fp6QV1MAB6j+A1wo=;
        b=I3GZpqw5OZk+I6am3PED1qh/iHyuOT6D2WhDtRJXfRmqSTEYE1g68efLO71YsMXrcP
         9GUpdlwxp0WsUWlPby0qmr5C2vLcxd0rdf99IicglGE67J4ZszQeOVjWwDzSL1cvZYRj
         C4FTvCTvDNvERXiN2Pe2dFijA9myTEFTZujEuAxWLPvxs5UuXSHR/dr6IidxWCwfr1pz
         CSNVP60xl56w2Xo/cQkpUXWBuLG7K6os4m3VzO1EpKEzM1PKj12gkhjNwMl+tIQhGewG
         tF4KfEh7DUyXoS6FwtdnJdBdYIk8Hp/YyhYaY8vSetWYZM+KdRwoEvjDyImuO33x4Fsj
         cegA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4IDTIz43dDChb9K4Li6kT2GF0x6Fp6QV1MAB6j+A1wo=;
        b=GdObdQGQokI60LQwC1KvvopGG5JDUU8CcjYhojMtoZaaVo5VrARnrW4Db2NKVIalLK
         uQw3avP4fuvTd39wJo4KRb0LQuG5VbYjS52sFRg9kEQr/PhMaFT/0HCDubBwQ6/LFlbm
         j4ihgk0jq6JhREesjwXKzy+o4K8XrUSEIS7d7V2R34KlUxi2H4eoInT+yaI98e+sVBWh
         f+0X065aTUpMeTHz22tx+TI5PD9Z/SCikRnCO3gtXmf7cCZUH7c6vb5sL2fM726VqOBl
         Wn1HxGz7FReIEXwA+QwfTGMu0+VyPKcjyPe13E73SLEw7R2YQAvnU59NgUybrgfdjAZE
         8qRg==
X-Gm-Message-State: AOAM532uoYh3AmaH7rKwbg1Kc4qf5eoQBuyIvc8M84xDBMcgMJvwy5f2
        ybPD6w88amSqC2tpTbqdgaKapoXvyhTLYA==
X-Google-Smtp-Source: ABdhPJwXp/WyVzOeB4hoteLztMid/o5OIKWxkHZtRm2t6qFHwXxXq1n23JZIsJN3ZN7kEjjUkHAScw==
X-Received: by 2002:a17:903:283:b0:152:157:eb7 with SMTP id j3-20020a170903028300b0015201570eb7mr1106906plr.109.1652380408045;
        Thu, 12 May 2022 11:33:28 -0700 (PDT)
Received: from localhost ([192.55.54.48])
        by smtp.gmail.com with ESMTPSA id k4-20020a628404000000b0050dc76281dcsm133438pfd.182.2022.05.12.11.33.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 May 2022 11:33:27 -0700 (PDT)
Date:   Thu, 12 May 2022 11:33:26 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        isaku.yamahata@intel.com, Gerd Hoffmann <kraxel@redhat.com>,
        Daniel P =?utf-8?B?LiBCZXJyYW5nw6k=?= <berrange@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Connor Kuehl <ckuehl@redhat.com>, erdemaktas@google.com,
        kvm@vger.kernel.org, qemu-devel@nongnu.org, seanjc@google.com
Subject: Re: [RFC PATCH v4 23/36] i386/tdx: Setup the TD HOB list
Message-ID: <20220512183326.GH2789321@ls.amr.corp.intel.com>
References: <20220512031803.3315890-1-xiaoyao.li@intel.com>
 <20220512031803.3315890-24-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220512031803.3315890-24-xiaoyao.li@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 12, 2022 at 11:17:50AM +0800,
Xiaoyao Li <xiaoyao.li@intel.com> wrote:

> The TD HOB list is used to pass the information from VMM to TDVF. The TD
> HOB must include PHIT HOB and Resource Descriptor HOB. More details can
> be found in TDVF specification and PI specification.
> 
> Build the TD HOB in TDX's machine_init_done callback.

Because HOB is introduced first time, please expand HOB.


> Co-developed-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>  hw/i386/meson.build   |   2 +-
>  hw/i386/tdvf-hob.c    | 212 ++++++++++++++++++++++++++++++++++++++++++
>  hw/i386/tdvf-hob.h    |  25 +++++
>  hw/i386/uefi.h        | 198 +++++++++++++++++++++++++++++++++++++++
>  target/i386/kvm/tdx.c |  16 ++++
>  5 files changed, 452 insertions(+), 1 deletion(-)
>  create mode 100644 hw/i386/tdvf-hob.c
>  create mode 100644 hw/i386/tdvf-hob.h
>  create mode 100644 hw/i386/uefi.h
> 
> diff --git a/hw/i386/meson.build b/hw/i386/meson.build
> index 97f3b50503b0..b59e0d35bba3 100644
> --- a/hw/i386/meson.build
> +++ b/hw/i386/meson.build
> @@ -28,7 +28,7 @@ i386_ss.add(when: 'CONFIG_PC', if_true: files(
>    'port92.c'))
>  i386_ss.add(when: 'CONFIG_X86_FW_OVMF', if_true: files('pc_sysfw_ovmf.c'),
>                                          if_false: files('pc_sysfw_ovmf-stubs.c'))
> -i386_ss.add(when: 'CONFIG_TDX', if_true: files('tdvf.c'))
> +i386_ss.add(when: 'CONFIG_TDX', if_true: files('tdvf.c', 'tdvf-hob.c'))
>  
>  subdir('kvm')
>  subdir('xen')
> diff --git a/hw/i386/tdvf-hob.c b/hw/i386/tdvf-hob.c
> new file mode 100644
> index 000000000000..31160e9f95c5
> --- /dev/null
> +++ b/hw/i386/tdvf-hob.c
> @@ -0,0 +1,212 @@
> +/*
> + * SPDX-License-Identifier: GPL-2.0-or-later
> +
> + * Copyright (c) 2020 Intel Corporation
> + * Author: Isaku Yamahata <isaku.yamahata at gmail.com>
> + *                        <isaku.yamahata at intel.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> +
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> +
> + * You should have received a copy of the GNU General Public License along
> + * with this program; if not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#include "qemu/osdep.h"
> +#include "qemu/log.h"
> +#include "e820_memory_layout.h"
> +#include "hw/i386/pc.h"
> +#include "hw/i386/x86.h"
> +#include "hw/pci/pcie_host.h"
> +#include "sysemu/kvm.h"
> +#include "tdvf-hob.h"
> +#include "uefi.h"
> +
> +typedef struct TdvfHob {
> +    hwaddr hob_addr;
> +    void *ptr;
> +    int size;
> +
> +    /* working area */
> +    void *current;
> +    void *end;
> +} TdvfHob;
> +
> +static uint64_t tdvf_current_guest_addr(const TdvfHob *hob)
> +{
> +    return hob->hob_addr + (hob->current - hob->ptr);
> +}
> +
> +static void tdvf_align(TdvfHob *hob, size_t align)
> +{
> +    hob->current = QEMU_ALIGN_PTR_UP(hob->current, align);
> +}
> +
> +static void *tdvf_get_area(TdvfHob *hob, uint64_t size)
> +{
> +    void *ret;
> +
> +    if (hob->current + size > hob->end) {
> +        error_report("TD_HOB overrun, size = 0x%" PRIx64, size);
> +        exit(1);
> +    }
> +
> +    ret = hob->current;
> +    hob->current += size;
> +    tdvf_align(hob, 8);
> +    return ret;
> +}
> +
> +static void tdvf_hob_add_mmio_resource(TdvfHob *hob, uint64_t start,
> +                                       uint64_t end)
> +{
> +    EFI_HOB_RESOURCE_DESCRIPTOR *region;
> +
> +    if (!start) {
> +        return;
> +    }
> +
> +    region = tdvf_get_area(hob, sizeof(*region));
> +    *region = (EFI_HOB_RESOURCE_DESCRIPTOR) {
> +        .Header = {
> +            .HobType = EFI_HOB_TYPE_RESOURCE_DESCRIPTOR,
> +            .HobLength = cpu_to_le16(sizeof(*region)),
> +            .Reserved = cpu_to_le32(0),
> +        },
> +        .Owner = EFI_HOB_OWNER_ZERO,
> +        .ResourceType = cpu_to_le32(EFI_RESOURCE_MEMORY_MAPPED_IO),
> +        .ResourceAttribute = cpu_to_le32(EFI_RESOURCE_ATTRIBUTE_TDVF_MMIO),
> +        .PhysicalStart = cpu_to_le64(start),
> +        .ResourceLength = cpu_to_le64(end - start),
> +    };
> +}
> +
> +static void tdvf_hob_add_mmio_resources(TdvfHob *hob)
> +{
> +    MachineState *ms = MACHINE(qdev_get_machine());
> +    X86MachineState *x86ms = X86_MACHINE(ms);
> +    PCIHostState *pci_host;
> +    uint64_t start, end;
> +    uint64_t mcfg_base, mcfg_size;
> +    Object *host;
> +
> +    /* Effectively PCI hole + other MMIO devices. */
> +    tdvf_hob_add_mmio_resource(hob, x86ms->below_4g_mem_size,
> +                               APIC_DEFAULT_ADDRESS);
> +
> +    /* Stolen from acpi_get_i386_pci_host(), there's gotta be an easier way. */
> +    pci_host = OBJECT_CHECK(PCIHostState,
> +                            object_resolve_path("/machine/i440fx", NULL),
> +                            TYPE_PCI_HOST_BRIDGE);
> +    if (!pci_host) {
> +        pci_host = OBJECT_CHECK(PCIHostState,
> +                                object_resolve_path("/machine/q35", NULL),
> +                                TYPE_PCI_HOST_BRIDGE);
> +    }
> +    g_assert(pci_host);
> +
> +    host = OBJECT(pci_host);
> +
> +    /* PCI hole above 4gb. */
> +    start = object_property_get_uint(host, PCI_HOST_PROP_PCI_HOLE64_START,
> +                                     NULL);
> +    end = object_property_get_uint(host, PCI_HOST_PROP_PCI_HOLE64_END, NULL);
> +    tdvf_hob_add_mmio_resource(hob, start, end);
> +
> +    /* MMCFG region */
> +    mcfg_base = object_property_get_uint(host, PCIE_HOST_MCFG_BASE, NULL);
> +    mcfg_size = object_property_get_uint(host, PCIE_HOST_MCFG_SIZE, NULL);
> +    if (mcfg_base && mcfg_base != PCIE_BASE_ADDR_UNMAPPED && mcfg_size) {
> +        tdvf_hob_add_mmio_resource(hob, mcfg_base, mcfg_base + mcfg_size);
> +    }
> +}
> +
> +static void tdvf_hob_add_memory_resources(TdxGuest *tdx, TdvfHob *hob)
> +{
> +    EFI_HOB_RESOURCE_DESCRIPTOR *region;
> +    EFI_RESOURCE_ATTRIBUTE_TYPE attr;
> +    EFI_RESOURCE_TYPE resource_type;
> +
> +    TdxRamEntry *e;
> +    int i;
> +
> +    for (i = 0; i < tdx->nr_ram_entries; i++) {
> +        e = &tdx->ram_entries[i];
> +
> +        if (e->type == TDX_RAM_UNACCEPTED) {
> +            resource_type = EFI_RESOURCE_MEMORY_UNACCEPTED;
> +            attr = EFI_RESOURCE_ATTRIBUTE_TDVF_UNACCEPTED;
> +        } else if (e->type == TDX_RAM_ADDED){
> +            resource_type = EFI_RESOURCE_SYSTEM_MEMORY;
> +            attr = EFI_RESOURCE_ATTRIBUTE_TDVF_PRIVATE;
> +        } else {
> +            error_report("unknown TDXRAMENTRY type %d", e->type);
> +            exit(1);
> +        }
> +
> +        region = tdvf_get_area(hob, sizeof(*region));
> +        *region = (EFI_HOB_RESOURCE_DESCRIPTOR) {
> +            .Header = {
> +                .HobType = EFI_HOB_TYPE_RESOURCE_DESCRIPTOR,
> +                .HobLength = cpu_to_le16(sizeof(*region)),
> +                .Reserved = cpu_to_le32(0),
> +            },
> +            .Owner = EFI_HOB_OWNER_ZERO,
> +            .ResourceType = cpu_to_le32(resource_type),
> +            .ResourceAttribute = cpu_to_le32(attr),
> +            .PhysicalStart = e->address,

nitpick: cpu_to_le64() for consistency. My bad.

> +            .ResourceLength = e->length,

ditto.

Thanks,

> +        };
> +    }
> +}
> +
> +void tdvf_hob_create(TdxGuest *tdx, TdxFirmwareEntry *td_hob)
> +{
> +    TdvfHob hob = {
> +        .hob_addr = td_hob->address,
> +        .size = td_hob->size,
> +        .ptr = td_hob->mem_ptr,
> +
> +        .current = td_hob->mem_ptr,
> +        .end = td_hob->mem_ptr + td_hob->size,
> +    };
> +
> +    EFI_HOB_GENERIC_HEADER *last_hob;
> +    EFI_HOB_HANDOFF_INFO_TABLE *hit;
> +
> +    /* Note, Efi{Free}Memory{Bottom,Top} are ignored, leave 'em zeroed. */
> +    hit = tdvf_get_area(&hob, sizeof(*hit));
> +    *hit = (EFI_HOB_HANDOFF_INFO_TABLE) {
> +        .Header = {
> +            .HobType = EFI_HOB_TYPE_HANDOFF,
> +            .HobLength = cpu_to_le16(sizeof(*hit)),
> +            .Reserved = cpu_to_le32(0),
> +        },
> +        .Version = cpu_to_le32(EFI_HOB_HANDOFF_TABLE_VERSION),
> +        .BootMode = cpu_to_le32(0),
> +        .EfiMemoryTop = cpu_to_le64(0),
> +        .EfiMemoryBottom = cpu_to_le64(0),
> +        .EfiFreeMemoryTop = cpu_to_le64(0),
> +        .EfiFreeMemoryBottom = cpu_to_le64(0),
> +        .EfiEndOfHobList = cpu_to_le64(0), /* initialized later */
> +    };
> +
> +    tdvf_hob_add_memory_resources(tdx, &hob);
> +
> +    tdvf_hob_add_mmio_resources(&hob);
> +
> +    last_hob = tdvf_get_area(&hob, sizeof(*last_hob));
> +    *last_hob =  (EFI_HOB_GENERIC_HEADER) {
> +        .HobType = EFI_HOB_TYPE_END_OF_HOB_LIST,
> +        .HobLength = cpu_to_le16(sizeof(*last_hob)),
> +        .Reserved = cpu_to_le32(0),
> +    };
> +    hit->EfiEndOfHobList = tdvf_current_guest_addr(&hob);
> +}
> diff --git a/hw/i386/tdvf-hob.h b/hw/i386/tdvf-hob.h
> new file mode 100644
> index 000000000000..f0494e8c4af8
> --- /dev/null
> +++ b/hw/i386/tdvf-hob.h
> @@ -0,0 +1,25 @@
> +#ifndef HW_I386_TD_HOB_H
> +#define HW_I386_TD_HOB_H
> +
> +#include "hw/i386/tdvf.h"
> +#include "hw/i386/uefi.h"
> +#include "target/i386/kvm/tdx.h"
> +
> +void tdvf_hob_create(TdxGuest *tdx, TdxFirmwareEntry *td_hob);
> +
> +#define EFI_RESOURCE_ATTRIBUTE_TDVF_PRIVATE     \
> +    (EFI_RESOURCE_ATTRIBUTE_PRESENT |           \
> +     EFI_RESOURCE_ATTRIBUTE_INITIALIZED |       \
> +     EFI_RESOURCE_ATTRIBUTE_TESTED)
> +
> +#define EFI_RESOURCE_ATTRIBUTE_TDVF_UNACCEPTED  \
> +    (EFI_RESOURCE_ATTRIBUTE_PRESENT |           \
> +     EFI_RESOURCE_ATTRIBUTE_INITIALIZED |       \
> +     EFI_RESOURCE_ATTRIBUTE_TESTED)
> +
> +#define EFI_RESOURCE_ATTRIBUTE_TDVF_MMIO        \
> +    (EFI_RESOURCE_ATTRIBUTE_PRESENT     |       \
> +     EFI_RESOURCE_ATTRIBUTE_INITIALIZED |       \
> +     EFI_RESOURCE_ATTRIBUTE_UNCACHEABLE)
> +
> +#endif
> diff --git a/hw/i386/uefi.h b/hw/i386/uefi.h
> new file mode 100644
> index 000000000000..b15aba796156
> --- /dev/null
> +++ b/hw/i386/uefi.h
> @@ -0,0 +1,198 @@
> +/*
> + * Copyright (C) 2020 Intel Corporation
> + *
> + * Author: Isaku Yamahata <isaku.yamahata at gmail.com>
> + *                        <isaku.yamahata at intel.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> +
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> +
> + * You should have received a copy of the GNU General Public License along
> + * with this program; if not, see <http://www.gnu.org/licenses/>.
> + *
> + */
> +
> +#ifndef HW_I386_UEFI_H
> +#define HW_I386_UEFI_H
> +
> +/***************************************************************************/
> +/*
> + * basic EFI definitions
> + * supplemented with UEFI Specification Version 2.8 (Errata A)
> + * released February 2020
> + */
> +/* UEFI integer is little endian */
> +
> +typedef struct {
> +    uint32_t Data1;
> +    uint16_t Data2;
> +    uint16_t Data3;
> +    uint8_t Data4[8];
> +} EFI_GUID;
> +
> +typedef enum {
> +    EfiReservedMemoryType,
> +    EfiLoaderCode,
> +    EfiLoaderData,
> +    EfiBootServicesCode,
> +    EfiBootServicesData,
> +    EfiRuntimeServicesCode,
> +    EfiRuntimeServicesData,
> +    EfiConventionalMemory,
> +    EfiUnusableMemory,
> +    EfiACPIReclaimMemory,
> +    EfiACPIMemoryNVS,
> +    EfiMemoryMappedIO,
> +    EfiMemoryMappedIOPortSpace,
> +    EfiPalCode,
> +    EfiPersistentMemory,
> +    EfiUnacceptedMemoryType,
> +    EfiMaxMemoryType
> +} EFI_MEMORY_TYPE;
> +
> +#define EFI_HOB_HANDOFF_TABLE_VERSION 0x0009
> +
> +#define EFI_HOB_TYPE_HANDOFF              0x0001
> +#define EFI_HOB_TYPE_MEMORY_ALLOCATION    0x0002
> +#define EFI_HOB_TYPE_RESOURCE_DESCRIPTOR  0x0003
> +#define EFI_HOB_TYPE_GUID_EXTENSION       0x0004
> +#define EFI_HOB_TYPE_FV                   0x0005
> +#define EFI_HOB_TYPE_CPU                  0x0006
> +#define EFI_HOB_TYPE_MEMORY_POOL          0x0007
> +#define EFI_HOB_TYPE_FV2                  0x0009
> +#define EFI_HOB_TYPE_LOAD_PEIM_UNUSED     0x000A
> +#define EFI_HOB_TYPE_UEFI_CAPSULE         0x000B
> +#define EFI_HOB_TYPE_FV3                  0x000C
> +#define EFI_HOB_TYPE_UNUSED               0xFFFE
> +#define EFI_HOB_TYPE_END_OF_HOB_LIST      0xFFFF
> +
> +typedef struct {
> +    uint16_t HobType;
> +    uint16_t HobLength;
> +    uint32_t Reserved;
> +} EFI_HOB_GENERIC_HEADER;
> +
> +typedef uint64_t EFI_PHYSICAL_ADDRESS;
> +typedef uint32_t EFI_BOOT_MODE;
> +
> +typedef struct {
> +    EFI_HOB_GENERIC_HEADER Header;
> +    uint32_t Version;
> +    EFI_BOOT_MODE BootMode;
> +    EFI_PHYSICAL_ADDRESS EfiMemoryTop;
> +    EFI_PHYSICAL_ADDRESS EfiMemoryBottom;
> +    EFI_PHYSICAL_ADDRESS EfiFreeMemoryTop;
> +    EFI_PHYSICAL_ADDRESS EfiFreeMemoryBottom;
> +    EFI_PHYSICAL_ADDRESS EfiEndOfHobList;
> +} EFI_HOB_HANDOFF_INFO_TABLE;
> +
> +#define EFI_RESOURCE_SYSTEM_MEMORY          0x00000000
> +#define EFI_RESOURCE_MEMORY_MAPPED_IO       0x00000001
> +#define EFI_RESOURCE_IO                     0x00000002
> +#define EFI_RESOURCE_FIRMWARE_DEVICE        0x00000003
> +#define EFI_RESOURCE_MEMORY_MAPPED_IO_PORT  0x00000004
> +#define EFI_RESOURCE_MEMORY_RESERVED        0x00000005
> +#define EFI_RESOURCE_IO_RESERVED            0x00000006
> +#define EFI_RESOURCE_MEMORY_UNACCEPTED      0x00000007
> +#define EFI_RESOURCE_MAX_MEMORY_TYPE        0x00000008
> +
> +#define EFI_RESOURCE_ATTRIBUTE_PRESENT                  0x00000001
> +#define EFI_RESOURCE_ATTRIBUTE_INITIALIZED              0x00000002
> +#define EFI_RESOURCE_ATTRIBUTE_TESTED                   0x00000004
> +#define EFI_RESOURCE_ATTRIBUTE_SINGLE_BIT_ECC           0x00000008
> +#define EFI_RESOURCE_ATTRIBUTE_MULTIPLE_BIT_ECC         0x00000010
> +#define EFI_RESOURCE_ATTRIBUTE_ECC_RESERVED_1           0x00000020
> +#define EFI_RESOURCE_ATTRIBUTE_ECC_RESERVED_2           0x00000040
> +#define EFI_RESOURCE_ATTRIBUTE_READ_PROTECTED           0x00000080
> +#define EFI_RESOURCE_ATTRIBUTE_WRITE_PROTECTED          0x00000100
> +#define EFI_RESOURCE_ATTRIBUTE_EXECUTION_PROTECTED      0x00000200
> +#define EFI_RESOURCE_ATTRIBUTE_UNCACHEABLE              0x00000400
> +#define EFI_RESOURCE_ATTRIBUTE_WRITE_COMBINEABLE        0x00000800
> +#define EFI_RESOURCE_ATTRIBUTE_WRITE_THROUGH_CACHEABLE  0x00001000
> +#define EFI_RESOURCE_ATTRIBUTE_WRITE_BACK_CACHEABLE     0x00002000
> +#define EFI_RESOURCE_ATTRIBUTE_16_BIT_IO                0x00004000
> +#define EFI_RESOURCE_ATTRIBUTE_32_BIT_IO                0x00008000
> +#define EFI_RESOURCE_ATTRIBUTE_64_BIT_IO                0x00010000
> +#define EFI_RESOURCE_ATTRIBUTE_UNCACHED_EXPORTED        0x00020000
> +#define EFI_RESOURCE_ATTRIBUTE_READ_ONLY_PROTECTED      0x00040000
> +#define EFI_RESOURCE_ATTRIBUTE_READ_ONLY_PROTECTABLE    0x00080000
> +#define EFI_RESOURCE_ATTRIBUTE_READ_PROTECTABLE         0x00100000
> +#define EFI_RESOURCE_ATTRIBUTE_WRITE_PROTECTABLE        0x00200000
> +#define EFI_RESOURCE_ATTRIBUTE_EXECUTION_PROTECTABLE    0x00400000
> +#define EFI_RESOURCE_ATTRIBUTE_PERSISTENT               0x00800000
> +#define EFI_RESOURCE_ATTRIBUTE_PERSISTABLE              0x01000000
> +#define EFI_RESOURCE_ATTRIBUTE_MORE_RELIABLE            0x02000000
> +
> +typedef uint32_t EFI_RESOURCE_TYPE;
> +typedef uint32_t EFI_RESOURCE_ATTRIBUTE_TYPE;
> +
> +typedef struct {
> +    EFI_HOB_GENERIC_HEADER Header;
> +    EFI_GUID Owner;
> +    EFI_RESOURCE_TYPE ResourceType;
> +    EFI_RESOURCE_ATTRIBUTE_TYPE ResourceAttribute;
> +    EFI_PHYSICAL_ADDRESS PhysicalStart;
> +    uint64_t ResourceLength;
> +} EFI_HOB_RESOURCE_DESCRIPTOR;
> +
> +typedef struct {
> +    EFI_HOB_GENERIC_HEADER Header;
> +    EFI_GUID Name;
> +
> +    /* guid specific data follows */
> +} EFI_HOB_GUID_TYPE;
> +
> +typedef struct {
> +    EFI_HOB_GENERIC_HEADER Header;
> +    EFI_PHYSICAL_ADDRESS BaseAddress;
> +    uint64_t Length;
> +} EFI_HOB_FIRMWARE_VOLUME;
> +
> +typedef struct {
> +    EFI_HOB_GENERIC_HEADER Header;
> +    EFI_PHYSICAL_ADDRESS BaseAddress;
> +    uint64_t Length;
> +    EFI_GUID FvName;
> +    EFI_GUID FileName;
> +} EFI_HOB_FIRMWARE_VOLUME2;
> +
> +typedef struct {
> +    EFI_HOB_GENERIC_HEADER Header;
> +    EFI_PHYSICAL_ADDRESS BaseAddress;
> +    uint64_t Length;
> +    uint32_t AuthenticationStatus;
> +    bool ExtractedFv;
> +    EFI_GUID FvName;
> +    EFI_GUID FileName;
> +} EFI_HOB_FIRMWARE_VOLUME3;
> +
> +typedef struct {
> +    EFI_HOB_GENERIC_HEADER Header;
> +    uint8_t SizeOfMemorySpace;
> +    uint8_t SizeOfIoSpace;
> +    uint8_t Reserved[6];
> +} EFI_HOB_CPU;
> +
> +typedef struct {
> +    EFI_HOB_GENERIC_HEADER Header;
> +} EFI_HOB_MEMORY_POOL;
> +
> +typedef struct {
> +    EFI_HOB_GENERIC_HEADER Header;
> +
> +    EFI_PHYSICAL_ADDRESS BaseAddress;
> +    uint64_t Length;
> +} EFI_HOB_UEFI_CAPSULE;
> +
> +#define EFI_HOB_OWNER_ZERO                                      \
> +    ((EFI_GUID){ 0x00000000, 0x0000, 0x0000,                    \
> +        { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 } })
> +
> +#endif
> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
> index e7071bfe4c9c..3e18ace90bf7 100644
> --- a/target/i386/kvm/tdx.c
> +++ b/target/i386/kvm/tdx.c
> @@ -22,6 +22,7 @@
>  #include "hw/i386/e820_memory_layout.h"
>  #include "hw/i386/x86.h"
>  #include "hw/i386/tdvf.h"
> +#include "hw/i386/tdvf-hob.h"
>  #include "kvm_i386.h"
>  #include "tdx.h"
>  
> @@ -130,6 +131,19 @@ static void get_tdx_capabilities(void)
>      tdx_caps = caps;
>  }
>  
> +static TdxFirmwareEntry *tdx_get_hob_entry(TdxGuest *tdx)
> +{
> +    TdxFirmwareEntry *entry;
> +
> +    for_each_tdx_fw_entry(&tdx->tdvf, entry) {
> +        if (entry->type == TDVF_SECTION_TYPE_TD_HOB) {
> +            return entry;
> +        }
> +    }
> +    error_report("TDVF metadata doesn't specify TD_HOB location.");
> +    exit(1);
> +}
> +
>  static void tdx_add_ram_entry(uint64_t address, uint64_t length, uint32_t type)
>  {
>      uint32_t nr_entries = tdx_guest->nr_ram_entries;
> @@ -249,6 +263,8 @@ static void tdx_finalize_vm(Notifier *notifier, void *unused)
>  
>      qsort(tdx_guest->ram_entries, tdx_guest->nr_ram_entries,
>            sizeof(TdxRamEntry), &tdx_ram_entry_compare);
> +
> +    tdvf_hob_create(tdx_guest, tdx_get_hob_entry(tdx_guest));
>  }
>  
>  static Notifier tdx_machine_done_notify = {
> -- 
> 2.27.0
> 
> 

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
