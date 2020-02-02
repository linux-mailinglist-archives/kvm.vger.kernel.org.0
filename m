Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5FD14FD14
	for <lists+kvm@lfdr.de>; Sun,  2 Feb 2020 13:45:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726342AbgBBMor (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 2 Feb 2020 07:44:47 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:43224 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726044AbgBBMor (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 2 Feb 2020 07:44:47 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 4A0BD4F90B04E2EBA13E;
        Sun,  2 Feb 2020 20:44:43 +0800 (CST)
Received: from [127.0.0.1] (10.142.68.147) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.439.0; Sun, 2 Feb 2020
 20:44:37 +0800
Subject: Re: [PATCH v22 5/9] ACPI: Record the Generic Error Status Block
 address
To:     Igor Mammedov <imammedo@redhat.com>
CC:     <pbonzini@redhat.com>, <mst@redhat.com>,
        <shannon.zhaosl@gmail.com>, <peter.maydell@linaro.org>,
        <fam@euphon.net>, <rth@twiddle.net>, <ehabkost@redhat.com>,
        <mtosatti@redhat.com>, <xuwei5@huawei.com>,
        <jonathan.cameron@huawei.com>, <james.morse@arm.com>,
        <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>,
        <qemu-arm@nongnu.org>, <zhengxiang9@huawei.com>,
        <linuxarm@huawei.com>
References: <1578483143-14905-1-git-send-email-gengdongjiu@huawei.com>
 <1578483143-14905-6-git-send-email-gengdongjiu@huawei.com>
 <20200128154110.04baa5bc@redhat.com>
From:   gengdongjiu <gengdongjiu@huawei.com>
Message-ID: <02a78eff-865c-b9e0-6d5f-d4caa4daa98d@huawei.com>
Date:   Sun, 2 Feb 2020 20:44:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20200128154110.04baa5bc@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.142.68.147]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

sorry for the late response due to Chinese new year

On 2020/1/28 22:41, Igor Mammedov wrote:
> On Wed, 8 Jan 2020 19:32:19 +0800
> Dongjiu Geng <gengdongjiu@huawei.com> wrote:
> 
> in addition to comments of others:
> 
>> Record the GHEB address via fw_cfg file, when recording
>> a error to CPER, it will use this address to find out
>> Generic Error Data Entries and write the error.
>>
>> Make the HEST GHES to a GED device.
> 
> It's hard to parse this even kno
> Pls rephrase/make commit message more verbose,
> so it would describe why and what patch is supposed to do
Ok, thanks for the comments.

> 
> 
>> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
>> Signed-off-by: Xiang Zheng <zhengxiang9@huawei.com>
>> ---
>>  hw/acpi/generic_event_device.c         | 15 ++++++++++++++-
>>  hw/acpi/ghes.c                         | 16 ++++++++++++++++
>>  hw/arm/virt-acpi-build.c               | 13 ++++++++++++-
>>  include/hw/acpi/generic_event_device.h |  2 ++
>>  include/hw/acpi/ghes.h                 |  6 ++++++
>>  5 files changed, 50 insertions(+), 2 deletions(-)
>>
>> diff --git a/hw/acpi/generic_event_device.c b/hw/acpi/generic_event_device.c
>> index 9cee90c..9bf37e4 100644
>> --- a/hw/acpi/generic_event_device.c
>> +++ b/hw/acpi/generic_event_device.c
>> @@ -234,12 +234,25 @@ static const VMStateDescription vmstate_ged_state = {
>>      }
>>  };
>>  
>> +static const VMStateDescription vmstate_ghes_state = {
>> +    .name = "acpi-ghes-state",
>> +    .version_id = 1,
>> +    .minimum_version_id = 1,
>> +    .fields      = (VMStateField[]) {
>> +        VMSTATE_UINT64(ghes_addr_le, AcpiGhesState),
>> +        VMSTATE_END_OF_LIST()
>> +    }
>> +};
>> +
>>  static const VMStateDescription vmstate_acpi_ged = {
>>      .name = "acpi-ged",
>>      .version_id = 1,
>>      .minimum_version_id = 1,
>>      .fields = (VMStateField[]) {
>> -        VMSTATE_STRUCT(ged_state, AcpiGedState, 1, vmstate_ged_state, GEDState),
>> +        VMSTATE_STRUCT(ged_state, AcpiGedState, 1,
>> +                       vmstate_ged_state, GEDState),
>> +        VMSTATE_STRUCT(ghes_state, AcpiGedState, 1,
>> +                       vmstate_ghes_state, AcpiGhesState),
>>          VMSTATE_END_OF_LIST(),
>>      },
>>      .subsections = (const VMStateDescription * []) {
>> diff --git a/hw/acpi/ghes.c b/hw/acpi/ghes.c
>> index 9d37798..68f4abf 100644
>> --- a/hw/acpi/ghes.c
>> +++ b/hw/acpi/ghes.c
>> @@ -23,6 +23,7 @@
>>  #include "hw/acpi/acpi.h"
>>  #include "hw/acpi/ghes.h"
>>  #include "hw/acpi/aml-build.h"
>> +#include "hw/acpi/generic_event_device.h"
>>  #include "hw/nvram/fw_cfg.h"
>>  #include "sysemu/sysemu.h"
>>  #include "qemu/error-report.h"
>> @@ -208,3 +209,18 @@ void acpi_build_hest(GArray *table_data, GArray *hardware_errors,
>>      build_header(linker, table_data, (void *)(table_data->data + hest_start),
>>          "HEST", table_data->len - hest_start, 1, NULL, "");
>>  }
>> +
>> +void acpi_ghes_add_fw_cfg(AcpiGhesState *ags, FWCfgState *s,
>> +                            GArray *hardware_error)
> 
> not aligned properly

will modify it.

> 
>> +{
>> +    size_t size = 2 * sizeof(uint64_t) + ACPI_GHES_MAX_RAW_DATA_LENGTH;
>> +    size_t request_block_size = ACPI_GHES_ERROR_SOURCE_COUNT * size;
>> +
>> +    /* Create a read-only fw_cfg file for GHES */
>> +    fw_cfg_add_file(s, ACPI_GHES_ERRORS_FW_CFG_FILE, hardware_error->data,
>> +                    request_block_size);
>> +
>> +    /* Create a read-write fw_cfg file for Address */
>> +    fw_cfg_add_file_callback(s, ACPI_GHES_DATA_ADDR_FW_CFG_FILE, NULL, NULL,
>> +        NULL, &(ags->ghes_addr_le), sizeof(ags->ghes_addr_le), false);
>> +}
>> diff --git a/hw/arm/virt-acpi-build.c b/hw/arm/virt-acpi-build.c
>> index 837bbf9..c8aa94d 100644
>> --- a/hw/arm/virt-acpi-build.c
>> +++ b/hw/arm/virt-acpi-build.c
>> @@ -797,6 +797,7 @@ void virt_acpi_build(VirtMachineState *vms, AcpiBuildTables *tables)
>>      unsigned dsdt, xsdt;
>>      GArray *tables_blob = tables->table_data;
>>      MachineState *ms = MACHINE(vms);
>> +    AcpiGedState *acpi_ged_state;
>>  
>>      table_offsets = g_array_new(false, true /* clear */,
>>                                          sizeof(uint32_t));
>> @@ -831,7 +832,9 @@ void virt_acpi_build(VirtMachineState *vms, AcpiBuildTables *tables)
>>      acpi_add_table(table_offsets, tables_blob);
>>      build_spcr(tables_blob, tables->linker, vms);
>>  
>> -    if (vms->ras) {
>> +    acpi_ged_state = ACPI_GED(object_resolve_path_type("", TYPE_ACPI_GED,
>> +                                                       NULL));
>> +    if (acpi_ged_state &&  vms->ras) {
> 
> there is vms->acpi_dev which is GED, so you don't need to look it up
> 
> suggest:
   Thanks for the suggestion.

>  if (ras) {
>     assert(ged)
      assert(vms->acpi_dev), right?

>     do other fun stuff ...
>  }

> 
>>          acpi_add_table(table_offsets, tables_blob);
>>          build_ghes_error_table(tables->hardware_errors, tables->linker);
>>          acpi_build_hest(tables_blob, tables->hardware_errors,
>> @@ -925,6 +928,7 @@ void virt_acpi_setup(VirtMachineState *vms)
>>  {
>>      AcpiBuildTables tables;
>>      AcpiBuildState *build_state;
>> +    AcpiGedState *acpi_ged_state;
>>  
>>      if (!vms->fw_cfg) {
>>          trace_virt_acpi_setup();
>> @@ -955,6 +959,13 @@ void virt_acpi_setup(VirtMachineState *vms)
>>      fw_cfg_add_file(vms->fw_cfg, ACPI_BUILD_TPMLOG_FILE, tables.tcpalog->data,
>>                      acpi_data_len(tables.tcpalog));
>>  
>> +    acpi_ged_state = ACPI_GED(object_resolve_path_type("", TYPE_ACPI_GED,
>> +                                                       NULL));
>> +    if (acpi_ged_state && vms->ras) {
> 
> ditto

Ok.

> 
>> +        acpi_ghes_add_fw_cfg(&acpi_ged_state->ghes_state,
>> +                             vms->fw_cfg, tables.hardware_errors);
>> +    }
>> +
>>      build_state->rsdp_mr = acpi_add_rom_blob(virt_acpi_build_update,
>>                                               build_state, tables.rsdp,
>>                                               ACPI_BUILD_RSDP_FILE, 0);
>> diff --git a/include/hw/acpi/generic_event_device.h b/include/hw/acpi/generic_event_device.h
>> index d157eac..037d2b5 100644
>> --- a/include/hw/acpi/generic_event_device.h
>> +++ b/include/hw/acpi/generic_event_device.h
>> @@ -61,6 +61,7 @@
>>  
>>  #include "hw/sysbus.h"
>>  #include "hw/acpi/memory_hotplug.h"
>> +#include "hw/acpi/ghes.h"
>>  
>>  #define ACPI_POWER_BUTTON_DEVICE "PWRB"
>>  
>> @@ -95,6 +96,7 @@ typedef struct AcpiGedState {
>>      GEDState ged_state;
>>      uint32_t ged_event_bitmap;
>>      qemu_irq irq;
>> +    AcpiGhesState ghes_state;
>>  } AcpiGedState;
>>  
>>  void build_ged_aml(Aml *table, const char* name, HotplugHandler *hotplug_dev,
>> diff --git a/include/hw/acpi/ghes.h b/include/hw/acpi/ghes.h
>> index 09a7f86..a6761e6 100644
>> --- a/include/hw/acpi/ghes.h
>> +++ b/include/hw/acpi/ghes.h
>> @@ -60,7 +60,13 @@ enum {
>>      ACPI_HEST_SRC_ID_RESERVED,
>>  };
>>  
>> +typedef struct AcpiGhesState {
>> +    uint64_t ghes_addr_le;
>> +} AcpiGhesState;
>> +
>>  void build_ghes_error_table(GArray *hardware_errors, BIOSLinker *linker);
>>  void acpi_build_hest(GArray *table_data, GArray *hardware_error,
>>                            BIOSLinker *linker);
>> +void acpi_ghes_add_fw_cfg(AcpiGhesState *vms, FWCfgState *s,
>> +                          GArray *hardware_errors);
>>  #endif
> 
> .
> 

