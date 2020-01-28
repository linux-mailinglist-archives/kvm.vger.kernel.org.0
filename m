Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 504D314BAD6
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2020 15:42:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730504AbgA1Ol0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jan 2020 09:41:26 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:60384 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730395AbgA1OlX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Jan 2020 09:41:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580222481;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YCe3+L7di9I3yalYd5A8ayFZkGHdC0vR0KLagp0ado8=;
        b=V7Mu2MaM3B1f2xjl9GCerubEcysRjShA1doS74i3IIY40AphRhCyIzb3uny6i9Oe0sjCPf
        B6aF4AzvrH+JeGo8FkmAkGrg2TbPJS5+QJKLRI7Mhz8pjtWoo4/9tHaVAoA2QiuKwhsSDy
        KuJC1cK/e0b87lN9iJSsSsH2TuQY7k4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-239-CC3YDS7aOpCiWWUZbRp6UQ-1; Tue, 28 Jan 2020 09:41:20 -0500
X-MC-Unique: CC3YDS7aOpCiWWUZbRp6UQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3B68F100726D;
        Tue, 28 Jan 2020 14:41:18 +0000 (UTC)
Received: from localhost (unknown [10.43.2.114])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7398310098FB;
        Tue, 28 Jan 2020 14:41:12 +0000 (UTC)
Date:   Tue, 28 Jan 2020 15:41:10 +0100
From:   Igor Mammedov <imammedo@redhat.com>
To:     Dongjiu Geng <gengdongjiu@huawei.com>
Cc:     <pbonzini@redhat.com>, <mst@redhat.com>,
        <shannon.zhaosl@gmail.com>, <peter.maydell@linaro.org>,
        <fam@euphon.net>, <rth@twiddle.net>, <ehabkost@redhat.com>,
        <mtosatti@redhat.com>, <xuwei5@huawei.com>,
        <jonathan.cameron@huawei.com>, <james.morse@arm.com>,
        <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>,
        <qemu-arm@nongnu.org>, zhengxiang9@huawei.com, linuxarm@huawei.com
Subject: Re: [PATCH v22 5/9] ACPI: Record the Generic Error Status Block
 address
Message-ID: <20200128154110.04baa5bc@redhat.com>
In-Reply-To: <1578483143-14905-6-git-send-email-gengdongjiu@huawei.com>
References: <1578483143-14905-1-git-send-email-gengdongjiu@huawei.com>
 <1578483143-14905-6-git-send-email-gengdongjiu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 8 Jan 2020 19:32:19 +0800
Dongjiu Geng <gengdongjiu@huawei.com> wrote:

in addition to comments of others:

> Record the GHEB address via fw_cfg file, when recording
> a error to CPER, it will use this address to find out
> Generic Error Data Entries and write the error.
> 
> Make the HEST GHES to a GED device.

It's hard to parse this even kno
Pls rephrase/make commit message more verbose,
so it would describe why and what patch is supposed to do


> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
> Signed-off-by: Xiang Zheng <zhengxiang9@huawei.com>
> ---
>  hw/acpi/generic_event_device.c         | 15 ++++++++++++++-
>  hw/acpi/ghes.c                         | 16 ++++++++++++++++
>  hw/arm/virt-acpi-build.c               | 13 ++++++++++++-
>  include/hw/acpi/generic_event_device.h |  2 ++
>  include/hw/acpi/ghes.h                 |  6 ++++++
>  5 files changed, 50 insertions(+), 2 deletions(-)
> 
> diff --git a/hw/acpi/generic_event_device.c b/hw/acpi/generic_event_device.c
> index 9cee90c..9bf37e4 100644
> --- a/hw/acpi/generic_event_device.c
> +++ b/hw/acpi/generic_event_device.c
> @@ -234,12 +234,25 @@ static const VMStateDescription vmstate_ged_state = {
>      }
>  };
>  
> +static const VMStateDescription vmstate_ghes_state = {
> +    .name = "acpi-ghes-state",
> +    .version_id = 1,
> +    .minimum_version_id = 1,
> +    .fields      = (VMStateField[]) {
> +        VMSTATE_UINT64(ghes_addr_le, AcpiGhesState),
> +        VMSTATE_END_OF_LIST()
> +    }
> +};
> +
>  static const VMStateDescription vmstate_acpi_ged = {
>      .name = "acpi-ged",
>      .version_id = 1,
>      .minimum_version_id = 1,
>      .fields = (VMStateField[]) {
> -        VMSTATE_STRUCT(ged_state, AcpiGedState, 1, vmstate_ged_state, GEDState),
> +        VMSTATE_STRUCT(ged_state, AcpiGedState, 1,
> +                       vmstate_ged_state, GEDState),
> +        VMSTATE_STRUCT(ghes_state, AcpiGedState, 1,
> +                       vmstate_ghes_state, AcpiGhesState),
>          VMSTATE_END_OF_LIST(),
>      },
>      .subsections = (const VMStateDescription * []) {
> diff --git a/hw/acpi/ghes.c b/hw/acpi/ghes.c
> index 9d37798..68f4abf 100644
> --- a/hw/acpi/ghes.c
> +++ b/hw/acpi/ghes.c
> @@ -23,6 +23,7 @@
>  #include "hw/acpi/acpi.h"
>  #include "hw/acpi/ghes.h"
>  #include "hw/acpi/aml-build.h"
> +#include "hw/acpi/generic_event_device.h"
>  #include "hw/nvram/fw_cfg.h"
>  #include "sysemu/sysemu.h"
>  #include "qemu/error-report.h"
> @@ -208,3 +209,18 @@ void acpi_build_hest(GArray *table_data, GArray *hardware_errors,
>      build_header(linker, table_data, (void *)(table_data->data + hest_start),
>          "HEST", table_data->len - hest_start, 1, NULL, "");
>  }
> +
> +void acpi_ghes_add_fw_cfg(AcpiGhesState *ags, FWCfgState *s,
> +                            GArray *hardware_error)

not aligned properly

> +{
> +    size_t size = 2 * sizeof(uint64_t) + ACPI_GHES_MAX_RAW_DATA_LENGTH;
> +    size_t request_block_size = ACPI_GHES_ERROR_SOURCE_COUNT * size;
> +
> +    /* Create a read-only fw_cfg file for GHES */
> +    fw_cfg_add_file(s, ACPI_GHES_ERRORS_FW_CFG_FILE, hardware_error->data,
> +                    request_block_size);
> +
> +    /* Create a read-write fw_cfg file for Address */
> +    fw_cfg_add_file_callback(s, ACPI_GHES_DATA_ADDR_FW_CFG_FILE, NULL, NULL,
> +        NULL, &(ags->ghes_addr_le), sizeof(ags->ghes_addr_le), false);
> +}
> diff --git a/hw/arm/virt-acpi-build.c b/hw/arm/virt-acpi-build.c
> index 837bbf9..c8aa94d 100644
> --- a/hw/arm/virt-acpi-build.c
> +++ b/hw/arm/virt-acpi-build.c
> @@ -797,6 +797,7 @@ void virt_acpi_build(VirtMachineState *vms, AcpiBuildTables *tables)
>      unsigned dsdt, xsdt;
>      GArray *tables_blob = tables->table_data;
>      MachineState *ms = MACHINE(vms);
> +    AcpiGedState *acpi_ged_state;
>  
>      table_offsets = g_array_new(false, true /* clear */,
>                                          sizeof(uint32_t));
> @@ -831,7 +832,9 @@ void virt_acpi_build(VirtMachineState *vms, AcpiBuildTables *tables)
>      acpi_add_table(table_offsets, tables_blob);
>      build_spcr(tables_blob, tables->linker, vms);
>  
> -    if (vms->ras) {
> +    acpi_ged_state = ACPI_GED(object_resolve_path_type("", TYPE_ACPI_GED,
> +                                                       NULL));
> +    if (acpi_ged_state &&  vms->ras) {

there is vms->acpi_dev which is GED, so you don't need to look it up

suggest:
 if (ras) {
    assert(ged)
    do other fun stuff ...
 }

>          acpi_add_table(table_offsets, tables_blob);
>          build_ghes_error_table(tables->hardware_errors, tables->linker);
>          acpi_build_hest(tables_blob, tables->hardware_errors,
> @@ -925,6 +928,7 @@ void virt_acpi_setup(VirtMachineState *vms)
>  {
>      AcpiBuildTables tables;
>      AcpiBuildState *build_state;
> +    AcpiGedState *acpi_ged_state;
>  
>      if (!vms->fw_cfg) {
>          trace_virt_acpi_setup();
> @@ -955,6 +959,13 @@ void virt_acpi_setup(VirtMachineState *vms)
>      fw_cfg_add_file(vms->fw_cfg, ACPI_BUILD_TPMLOG_FILE, tables.tcpalog->data,
>                      acpi_data_len(tables.tcpalog));
>  
> +    acpi_ged_state = ACPI_GED(object_resolve_path_type("", TYPE_ACPI_GED,
> +                                                       NULL));
> +    if (acpi_ged_state && vms->ras) {

ditto

> +        acpi_ghes_add_fw_cfg(&acpi_ged_state->ghes_state,
> +                             vms->fw_cfg, tables.hardware_errors);
> +    }
> +
>      build_state->rsdp_mr = acpi_add_rom_blob(virt_acpi_build_update,
>                                               build_state, tables.rsdp,
>                                               ACPI_BUILD_RSDP_FILE, 0);
> diff --git a/include/hw/acpi/generic_event_device.h b/include/hw/acpi/generic_event_device.h
> index d157eac..037d2b5 100644
> --- a/include/hw/acpi/generic_event_device.h
> +++ b/include/hw/acpi/generic_event_device.h
> @@ -61,6 +61,7 @@
>  
>  #include "hw/sysbus.h"
>  #include "hw/acpi/memory_hotplug.h"
> +#include "hw/acpi/ghes.h"
>  
>  #define ACPI_POWER_BUTTON_DEVICE "PWRB"
>  
> @@ -95,6 +96,7 @@ typedef struct AcpiGedState {
>      GEDState ged_state;
>      uint32_t ged_event_bitmap;
>      qemu_irq irq;
> +    AcpiGhesState ghes_state;
>  } AcpiGedState;
>  
>  void build_ged_aml(Aml *table, const char* name, HotplugHandler *hotplug_dev,
> diff --git a/include/hw/acpi/ghes.h b/include/hw/acpi/ghes.h
> index 09a7f86..a6761e6 100644
> --- a/include/hw/acpi/ghes.h
> +++ b/include/hw/acpi/ghes.h
> @@ -60,7 +60,13 @@ enum {
>      ACPI_HEST_SRC_ID_RESERVED,
>  };
>  
> +typedef struct AcpiGhesState {
> +    uint64_t ghes_addr_le;
> +} AcpiGhesState;
> +
>  void build_ghes_error_table(GArray *hardware_errors, BIOSLinker *linker);
>  void acpi_build_hest(GArray *table_data, GArray *hardware_error,
>                            BIOSLinker *linker);
> +void acpi_ghes_add_fw_cfg(AcpiGhesState *vms, FWCfgState *s,
> +                          GArray *hardware_errors);
>  #endif

