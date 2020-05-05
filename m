Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04AF31C5356
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 12:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728641AbgEEKcN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 06:32:13 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:32526 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725766AbgEEKcN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 May 2020 06:32:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588674731;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B/ATC1Apm8jZkYS/3yZsCVadYViIHtu/niZs3YWzOz4=;
        b=DqOhxVcbA4ubL5U6/TjD9h23oqZQroam7J4H5Y+NhTB8hXdZ0exG7ztBLcMKpt7xhPi50F
        muqg265kMz8fjgIFXKdcllCL1m4fgoRasDtfCFe2KPTtI2TbDxGzKI6iDcC9+TkdBxpGIc
        OB/bP917eMpEjN8vWldmW+jsesIhEh4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-101-rO5dl4xwMwmLCu6sLFolQA-1; Tue, 05 May 2020 06:32:08 -0400
X-MC-Unique: rO5dl4xwMwmLCu6sLFolQA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E7504107ACF5;
        Tue,  5 May 2020 10:32:06 +0000 (UTC)
Received: from localhost (unknown [10.40.208.7])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 60C0F7053F;
        Tue,  5 May 2020 10:31:56 +0000 (UTC)
Date:   Tue, 5 May 2020 12:31:55 +0200
From:   Igor Mammedov <imammedo@redhat.com>
To:     Dongjiu Geng <gengdongjiu@huawei.com>
Cc:     <mst@redhat.com>, <xiaoguangrong.eric@gmail.com>,
        <peter.maydell@linaro.org>, <shannon.zhaosl@gmail.com>,
        <fam@euphon.net>, <rth@twiddle.net>, <ehabkost@redhat.com>,
        <mtosatti@redhat.com>, <qemu-devel@nongnu.org>,
        <kvm@vger.kernel.org>, <qemu-arm@nongnu.org>,
        <pbonzini@redhat.com>, <zhengxiang9@huawei.com>,
        <Jonathan.Cameron@huawei.com>, <linuxarm@huawei.com>
Subject: Re: [PATCH v25 06/10] ACPI: Record the Generic Error Status Block
 address
Message-ID: <20200505123155.3b11394f@redhat.com>
In-Reply-To: <20200410114639.32844-7-gengdongjiu@huawei.com>
References: <20200410114639.32844-1-gengdongjiu@huawei.com>
        <20200410114639.32844-7-gengdongjiu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 10 Apr 2020 19:46:35 +0800
Dongjiu Geng <gengdongjiu@huawei.com> wrote:

> Record the GHEB address via fw_cfg file, when recording
> a error to CPER, it will use this address to find out
> Generic Error Data Entries and write the error.
> 
> In order to avoid migration failure, make hardware
> error table address to a part of GED device instead
> of global variable, then this address will be migrated
> to target QEMU.
> 
> Acked-by: Xiang Zheng <zhengxiang9@huawei.com>
> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>

Reviewed-by: Igor Mammedov <imammedo@redhat.com>

> ---
> change since v24:
> 1. Use s->ghes_state.ghes_addr_le to check in ghes_needed()
> 2. Using hardware_error->len instead of request_block_size to calculate in acpi_ghes_add_fw_cfg()
> 3. Remove assert(vms->acpi_dev) be build APEI table
> 4. Directly use ACPI_GED(vms->acpi_dev) instead of ACPI_GED(vms->acpi_dev)
> ---
>  hw/acpi/generic_event_device.c         | 19 +++++++++++++++++++
>  hw/acpi/ghes.c                         | 14 ++++++++++++++
>  hw/arm/virt-acpi-build.c               |  8 ++++++++
>  include/hw/acpi/generic_event_device.h |  2 ++
>  include/hw/acpi/ghes.h                 |  6 ++++++
>  5 files changed, 49 insertions(+)
> 
> diff --git a/hw/acpi/generic_event_device.c b/hw/acpi/generic_event_device.c
> index 021ed2b..1491291 100644
> --- a/hw/acpi/generic_event_device.c
> +++ b/hw/acpi/generic_event_device.c
> @@ -234,6 +234,24 @@ static const VMStateDescription vmstate_ged_state = {
>      }
>  };
>  
> +static bool ghes_needed(void *opaque)
> +{
> +    AcpiGedState *s = opaque;
> +    return s->ghes_state.ghes_addr_le;
> +}
> +
> +static const VMStateDescription vmstate_ghes_state = {
> +    .name = "acpi-ged/ghes",
> +    .version_id = 1,
> +    .minimum_version_id = 1,
> +    .needed = ghes_needed,
> +    .fields      = (VMStateField[]) {
> +        VMSTATE_STRUCT(ghes_state, AcpiGedState, 1,
> +                       vmstate_ghes_state, AcpiGhesState),
> +        VMSTATE_END_OF_LIST()
> +    }
> +};
> +
>  static const VMStateDescription vmstate_acpi_ged = {
>      .name = "acpi-ged",
>      .version_id = 1,
> @@ -244,6 +262,7 @@ static const VMStateDescription vmstate_acpi_ged = {
>      },
>      .subsections = (const VMStateDescription * []) {
>          &vmstate_memhp_state,
> +        &vmstate_ghes_state,
>          NULL
>      }
>  };
> diff --git a/hw/acpi/ghes.c b/hw/acpi/ghes.c
> index 091fd87..e74af23 100644
> --- a/hw/acpi/ghes.c
> +++ b/hw/acpi/ghes.c
> @@ -24,6 +24,8 @@
>  #include "hw/acpi/ghes.h"
>  #include "hw/acpi/aml-build.h"
>  #include "qemu/error-report.h"
> +#include "hw/acpi/generic_event_device.h"
> +#include "hw/nvram/fw_cfg.h"
>  
>  #define ACPI_GHES_ERRORS_FW_CFG_FILE        "etc/hardware_errors"
>  #define ACPI_GHES_DATA_ADDR_FW_CFG_FILE     "etc/hardware_errors_addr"
> @@ -213,3 +215,15 @@ void acpi_build_hest(GArray *table_data, BIOSLinker *linker)
>      build_header(linker, table_data, (void *)(table_data->data + hest_start),
>          "HEST", table_data->len - hest_start, 1, NULL, NULL);
>  }
> +
> +void acpi_ghes_add_fw_cfg(AcpiGhesState *ags, FWCfgState *s,
> +                          GArray *hardware_error)
> +{
> +    /* Create a read-only fw_cfg file for GHES */
> +    fw_cfg_add_file(s, ACPI_GHES_ERRORS_FW_CFG_FILE, hardware_error->data,
> +                    hardware_error->len);
> +
> +    /* Create a read-write fw_cfg file for Address */
> +    fw_cfg_add_file_callback(s, ACPI_GHES_DATA_ADDR_FW_CFG_FILE, NULL, NULL,
> +        NULL, &(ags->ghes_addr_le), sizeof(ags->ghes_addr_le), false);
> +}
> diff --git a/hw/arm/virt-acpi-build.c b/hw/arm/virt-acpi-build.c
> index f611bce..2726aac 100644
> --- a/hw/arm/virt-acpi-build.c
> +++ b/hw/arm/virt-acpi-build.c
> @@ -911,6 +911,7 @@ void virt_acpi_setup(VirtMachineState *vms)
>  {
>      AcpiBuildTables tables;
>      AcpiBuildState *build_state;
> +    AcpiGedState *acpi_ged_state;
>  
>      if (!vms->fw_cfg) {
>          trace_virt_acpi_setup();
> @@ -941,6 +942,13 @@ void virt_acpi_setup(VirtMachineState *vms)
>      fw_cfg_add_file(vms->fw_cfg, ACPI_BUILD_TPMLOG_FILE, tables.tcpalog->data,
>                      acpi_data_len(tables.tcpalog));
>  
> +    if (vms->ras) {
> +        assert(vms->acpi_dev);
> +        acpi_ged_state = ACPI_GED(vms->acpi_dev);
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
> index 18debd8..a3420fc 100644
> --- a/include/hw/acpi/ghes.h
> +++ b/include/hw/acpi/ghes.h
> @@ -62,6 +62,12 @@ enum {
>      ACPI_HEST_SRC_ID_RESERVED,
>  };
>  
> +typedef struct AcpiGhesState {
> +    uint64_t ghes_addr_le;
> +} AcpiGhesState;
> +
>  void build_ghes_error_table(GArray *hardware_errors, BIOSLinker *linker);
>  void acpi_build_hest(GArray *table_data, BIOSLinker *linker);
> +void acpi_ghes_add_fw_cfg(AcpiGhesState *vms, FWCfgState *s,
> +                          GArray *hardware_errors);
>  #endif

