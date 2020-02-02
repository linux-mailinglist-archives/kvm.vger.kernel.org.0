Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED01914FD62
	for <lists+kvm@lfdr.de>; Sun,  2 Feb 2020 14:42:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726916AbgBBNmg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 2 Feb 2020 08:42:36 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:55326 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726387AbgBBNmg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 2 Feb 2020 08:42:36 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 78765E8A0C0750743925;
        Sun,  2 Feb 2020 21:42:33 +0800 (CST)
Received: from [127.0.0.1] (10.142.68.147) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.439.0; Sun, 2 Feb 2020
 21:42:24 +0800
Subject: Re: [PATCH v22 7/9] ACPI: Record Generic Error Status Block(GESB)
 table
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
 <1578483143-14905-8-git-send-email-gengdongjiu@huawei.com>
 <20200128162938.18bd0e95@redhat.com>
From:   gengdongjiu <gengdongjiu@huawei.com>
Message-ID: <a9f46632-0766-7e82-7dc4-752d00b4a0a1@huawei.com>
Date:   Sun, 2 Feb 2020 21:42:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20200128162938.18bd0e95@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.142.68.147]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020/1/28 23:29, Igor Mammedov wrote:
> On Wed, 8 Jan 2020 19:32:21 +0800
> Dongjiu Geng <gengdongjiu@huawei.com> wrote:
> 
>> kvm_arch_on_sigbus_vcpu() error injection uses source_id as
>> index in etc/hardware_errors to find out Error Status Data
>> Block entry corresponding to error source. So supported source_id
>> values should be assigned here and not be changed afterwards to
>> make sure that guest will write error into expected Error Status
>> Data Block even if guest was migrated to a newer QEMU.
>>
>> Before QEMU writes a new error to ACPI table, it will check whether
>> previous error has been acknowledged. Otherwise it will ignore the new
>> error. For the errors section type, QEMU simulate it to memory section
>> error.
>>
>> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
>> Signed-off-by: Xiang Zheng <zhengxiang9@huawei.com>
>> Reviewed-by: Michael S. Tsirkin <mst@redhat.com>
>> ---
>>  hw/acpi/ghes.c         | 224 ++++++++++++++++++++++++++++++++++++++++++++++++-
>>  include/hw/acpi/ghes.h |   3 +
>>  include/qemu/uuid.h    |   5 ++
>>  3 files changed, 230 insertions(+), 2 deletions(-)
>>
>> diff --git a/hw/acpi/ghes.c b/hw/acpi/ghes.c
>> index 68f4abf..f2ecffe 100644
>> --- a/hw/acpi/ghes.c
>> +++ b/hw/acpi/ghes.c
>> @@ -28,21 +28,56 @@
>>  #include "sysemu/sysemu.h"
>>  #include "qemu/error-report.h"
>>  
>> -#include "hw/acpi/bios-linker-loader.h"
> why it's moved to header?

Because the function declaration "void acpi_build_hest(GArray *table_data, GArray *hardware_error,
                          BIOSLinker *linker);" needs it in the header file, Otherwise The compilation will be failed.


Anyway I will move this change to patch "[v22,4/9] ACPI: Build Hardware Error Source Table", because that patch needs it .

> 
>> -
>>  #define ACPI_GHES_ERRORS_FW_CFG_FILE        "etc/hardware_errors"
>>  #define ACPI_GHES_DATA_ADDR_FW_CFG_FILE     "etc/hardware_errors_addr"
>>  
>>  /* The max size in bytes for one error block */
>>  #define ACPI_GHES_MAX_RAW_DATA_LENGTH       0x400
>> +
>>  /* Now only support ARMv8 SEA notification type error source */
>>  #define ACPI_GHES_ERROR_SOURCE_COUNT        1
>> +
>>  /* Generic Hardware Error Source version 2 */
>>  #define ACPI_GHES_SOURCE_GENERIC_ERROR_V2   10
>> +
>>  /* Address offset in Generic Address Structure(GAS) */
>>  #define GAS_ADDR_OFFSET 4
>>  
>>  /*
>> + * The total size of Generic Error Data Entry
>> + * ACPI 6.1/6.2: 18.3.2.7.1 Generic Error Data,
>> + * Table 18-343 Generic Error Data Entry
>> + */
>> +#define ACPI_GHES_DATA_LENGTH               72
>> +
>> +/* The memory section CPER size, UEFI 2.6: N.2.5 Memory Error Section */
>> +#define ACPI_GHES_MEM_CPER_LENGTH           80
>> +
>> +/* Masks for block_status flags */
>> +#define ACPI_GEBS_UNCORRECTABLE         1
>> +
>> +#define UEFI_CPER_SEC_PLATFORM_MEM                              \
>> +    UUID_LE(0xA5BC1114, 0x6F64, 0x4EDE, 0xB8, 0x63, 0x3E, 0x83, \
>> +            0xED, 0x7C, 0x83, 0xB1)
>> +
>> +/*
>> + * Total size for Generic Error Status Block except Generic Error Data Entries
>> + * ACPI 6.2: 18.3.2.7.1 Generic Error Data,
>> + * Table 18-380 Generic Error Status Block
>> + */
>> +#define ACPI_GHES_GESB_SIZE                 20
>> +
>> +/*
>> + * Values for error_severity field
>> + */
>> +enum AcpiGenericErrorSeverity {
>> +    ACPI_CPER_SEV_RECOVERABLE = 0,
>> +    ACPI_CPER_SEV_FATAL = 1,
>> +    ACPI_CPER_SEV_CORRECTED = 2,
>> +    ACPI_CPER_SEV_NONE = 3,
>> +};
>> +
>> +/*
>>   * Hardware Error Notification
>>   * ACPI 4.0: 17.3.2.7 Hardware Error Notification
>>   * Composes dummy Hardware Error Notification descriptor of specified type
>> @@ -73,6 +108,127 @@ static void build_ghes_hw_error_notification(GArray *table, const uint8_t type)
>>  }
>>  
>>  /*
>> + * Generic Error Data Entry
>> + * ACPI 6.1: 18.3.2.7.1 Generic Error Data
>> + */
>> +static void acpi_ghes_generic_error_data(GArray *table, QemuUUID section_type,
>> +                uint32_t error_severity, uint8_t validation_bits, uint8_t flags,
>> +                uint32_t error_data_length, QemuUUID fru_id,
>> +                uint64_t time_stamp)
>> +{
>> +    /* Section Type */
>> +    g_array_append_vals(table, section_type.data,
>> +                        ARRAY_SIZE(section_type.data));
>> +
>> +    /* Error Severity */
>> +    build_append_int_noprefix(table, error_severity, 4);
>> +    /* Revision */
>> +    build_append_int_noprefix(table, 0x300, 2);
>> +    /* Validation Bits */
>> +    build_append_int_noprefix(table, validation_bits, 1);
>> +    /* Flags */
>> +    build_append_int_noprefix(table, flags, 1);
>> +    /* Error Data Length */
>> +    build_append_int_noprefix(table, error_data_length, 4);
>> +
>> +    /* FRU Id */
>> +    g_array_append_vals(table, fru_id.data, ARRAY_SIZE(fru_id.data));
>> +
>> +    /* FRU Text */
>> +    build_append_int_noprefix(table, 0, 20);
>> +    /* Timestamp */
>> +    build_append_int_noprefix(table, time_stamp, 8);
>> +}
>> +
>> +/*
>> + * Generic Error Status Block
>> + * ACPI 6.1: 18.3.2.7.1 Generic Error Data
>> + */
>> +static void acpi_ghes_generic_error_status(GArray *table, uint32_t block_status,
>> +                uint32_t raw_data_offset, uint32_t raw_data_length,
>> +                uint32_t data_length, uint32_t error_severity)
>> +{
>> +    /* Block Status */
>> +    build_append_int_noprefix(table, block_status, 4);
>> +    /* Raw Data Offset */
>> +    build_append_int_noprefix(table, raw_data_offset, 4);
>> +    /* Raw Data Length */
>> +    build_append_int_noprefix(table, raw_data_length, 4);
>> +    /* Data Length */
>> +    build_append_int_noprefix(table, data_length, 4);
>> +    /* Error Severity */
>> +    build_append_int_noprefix(table, error_severity, 4);
>> +}
>> +
>> +/* UEFI 2.6: N.2.5 Memory Error Section */
>> +static void acpi_ghes_build_append_mem_cper(GArray *table,
>> +                                            uint64_t error_physical_addr)
>> +{
>> +    /*
>> +     * Memory Error Record
>> +     */
>> +
>> +    /* Validation Bits */
>> +    build_append_int_noprefix(table,
>> +                              (1ULL << 14) | /* Type Valid */
>> +                              (1ULL << 1) /* Physical Address Valid */,
>> +                              8);
>> +    /* Error Status */
>> +    build_append_int_noprefix(table, 0, 8);
>> +    /* Physical Address */
>> +    build_append_int_noprefix(table, error_physical_addr, 8);
>> +    /* Skip all the detailed information normally found in such a record */
>> +    build_append_int_noprefix(table, 0, 48);
>> +    /* Memory Error Type */
>> +    build_append_int_noprefix(table, 0 /* Unknown error */, 1);
>> +    /* Skip all the detailed information normally found in such a record */
>> +    build_append_int_noprefix(table, 0, 7);
>> +}
>> +
>> +static int acpi_ghes_record_mem_error(uint64_t error_block_address,
>> +                                      uint64_t error_physical_addr)
>> +{
>> +    GArray *block;
>> +    /* Memory Error Section Type */
>> +    QemuUUID mem_section_id_le = UEFI_CPER_SEC_PLATFORM_MEM;
>> +    QemuUUID fru_id = {};
> add comment /* invalid fru id: UEFI 2.6: ..., table ...
ok.

> 
> 
>> +    uint32_t data_length;
>> +
>> +    block = g_array_new(false, true /* clear */, 1);
>> +
>> +    /* This is the length if adding a new generic error data entry*/
>> +    data_length = ACPI_GHES_DATA_LENGTH + ACPI_GHES_MEM_CPER_LENGTH;
>> +
>> +    /*
>> +     * Check whether it will run out of the preallocated memory if adding a new
>> +     * generic error data entry
>> +     */
>> +    if ((data_length + ACPI_GHES_GESB_SIZE) > ACPI_GHES_MAX_RAW_DATA_LENGTH) {
>> +        error_report("Not enough memory to record new CPER!!!");
>> +        return -1;
>> +    }
>> +
>> +    /* Build the new generic error status block header */
>> +    acpi_ghes_generic_error_status(block, ACPI_GEBS_UNCORRECTABLE,
>> +        0, 0, data_length, ACPI_CPER_SEV_RECOVERABLE);
>> +
>> +    /* Build this new generic error data entry header */
>> +    acpi_ghes_generic_error_data(block, mem_section_id_le,
>> +        ACPI_CPER_SEV_RECOVERABLE, 0, 0,
>> +        ACPI_GHES_MEM_CPER_LENGTH, fru_id, 0);
>> +
>> +    /* Build the memory section CPER for above new generic error data entry */
>> +    acpi_ghes_build_append_mem_cper(block, error_physical_addr);
>> +
>> +    /* Write back above this new generic error data entry to guest memory */
> 
> /* Write the generic error data entry into guest memory */
>> +    cpu_physical_memory_write(error_block_address, block->data, block->len);
>> +
>> +    g_array_free(block, true);
>> +
>> +    return 0;
>> +}
>> +
>> +/*
>>   * Build table for the hardware error fw_cfg blob.
>>   * Initialize "etc/hardware_errors" and "etc/hardware_errors_addr" fw_cfg blobs.
>>   * See docs/specs/acpi_hest_ghes.rst for blobs format.
>> @@ -224,3 +380,67 @@ void acpi_ghes_add_fw_cfg(AcpiGhesState *ags, FWCfgState *s,
>>      fw_cfg_add_file_callback(s, ACPI_GHES_DATA_ADDR_FW_CFG_FILE, NULL, NULL,
>>          NULL, &(ags->ghes_addr_le), sizeof(ags->ghes_addr_le), false);
>>  }
>> +
>> +int acpi_ghes_record_errors(uint8_t source_id, uint64_t physical_address)
>> +{
>> +    uint64_t error_block_addr, read_ack_register_addr, read_ack_register = 0;
>> +    int loop = 0;
>> +    uint64_t start_addr;
>> +    bool ret = -1;
>> +    AcpiGedState *acpi_ged_state;
>> +    AcpiGhesState *ags;
>> +
>> +    assert(source_id < ACPI_HEST_SRC_ID_RESERVED);
>> +
>> +    acpi_ged_state = ACPI_GED(object_resolve_path_type("", TYPE_ACPI_GED,
>> +                                                       NULL));
>> +    if (acpi_ged_state) {
>> +        ags = &acpi_ged_state->ghes_state;
>> +    } else {
>> +        error_report("ACPI GED device not found");
>> +        return -1;
>> +    }
>> +
>> +    start_addr = le64_to_cpu(ags->ghes_addr_le);
>> +
>> +    if (physical_address) {
>> +
>> +        if (source_id < ACPI_HEST_SRC_ID_RESERVED) {
>> +            start_addr += source_id * sizeof(uint64_t);
>> +        }
>> +
>> +        cpu_physical_memory_read(start_addr, &error_block_addr,
>> +                                 sizeof(error_block_addr));
>> +
>> +        read_ack_register_addr = start_addr +
>> +            ACPI_GHES_ERROR_SOURCE_COUNT * sizeof(uint64_t);
>> +retry:
>> +        cpu_physical_memory_read(read_ack_register_addr,
>> +                                 &read_ack_register, sizeof(read_ack_register));
>> +
>> +        /* zero means OSPM does not acknowledge the error */
>> +        if (!read_ack_register) {
>> +            if (loop < 3) {
>> +                usleep(100 * 1000);
>> +                loop++;
>> +                goto retry;
> it's not doing what commit message says
> 
> if message is supposed to be dropped, just drop it without any delay loops.
ok, I will drop it.

> 
>> +            } else {
>> +                error_report("OSPM does not acknowledge previous error,"
>> +                    " so can not record CPER for current error anymore");
>> +            }
>> +        } else if (error_block_addr) {
>> +                read_ack_register = cpu_to_le64(0);
>                                           ^^^^ pointless "= 0" will do just fine
> 
>> +                /*
>> +                 * Clear the Read Ack Register, OSPM will write it to 1 when
>> +                 * acknowledge this error.
> s/acknowledge/it acknowledges/
Thanks for this pointing out.

> 
>> +                 */
>> +                cpu_physical_memory_write(read_ack_register_addr,
>> +                    &read_ack_register, sizeof(uint64_t));
>> +
>> +                ret = acpi_ghes_record_mem_error(error_block_addr,
>> +                                                 physical_address);
>> +        }
>> +    }
>> +
>> +    return ret;
>> +}
>> diff --git a/include/hw/acpi/ghes.h b/include/hw/acpi/ghes.h
>> index a6761e6..ab0ae33 100644
>> --- a/include/hw/acpi/ghes.h
>> +++ b/include/hw/acpi/ghes.h
>> @@ -22,6 +22,8 @@
>>  #ifndef ACPI_GHES_H
>>  #define ACPI_GHES_H
>>  
>> +#include "hw/acpi/bios-linker-loader.h"
>> +
>>  /*
>>   * Values for Hardware Error Notification Type field
>>   */
>> @@ -69,4 +71,5 @@ void acpi_build_hest(GArray *table_data, GArray *hardware_error,
>>                            BIOSLinker *linker);
>>  void acpi_ghes_add_fw_cfg(AcpiGhesState *vms, FWCfgState *s,
>>                            GArray *hardware_errors);
>> +int acpi_ghes_record_errors(uint8_t notify, uint64_t error_physical_addr);
>>  #endif
>> diff --git a/include/qemu/uuid.h b/include/qemu/uuid.h
>> index 129c45f..b35e294 100644
>> --- a/include/qemu/uuid.h
>> +++ b/include/qemu/uuid.h
>> @@ -34,6 +34,11 @@ typedef struct {
>>      };
>>  } QemuUUID;
>>  
>> +#define UUID_LE(a, b, c, d0, d1, d2, d3, d4, d5, d6, d7)             \
>> +  {{{ (a) & 0xff, ((a) >> 8) & 0xff, ((a) >> 16) & 0xff, ((a) >> 24) & 0xff, \
>> +     (b) & 0xff, ((b) >> 8) & 0xff, (c) & 0xff, ((c) >> 8) & 0xff,          \
>> +     (d0), (d1), (d2), (d3), (d4), (d5), (d6), (d7) } } }
> 
> since you are adding generalizing macro, take of NVDIMM_UUID_LE which served as model

do you mean use this generalizing macro to replace NVDIMM_UUID_LE, right?

> 
> 
>>  #define UUID_FMT "%02hhx%02hhx%02hhx%02hhx-" \
>>                   "%02hhx%02hhx-%02hhx%02hhx-" \
>>                   "%02hhx%02hhx-" \
> 
> .
> 

