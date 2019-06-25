Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39D9754EBA
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2019 14:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727261AbfFYMYu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jun 2019 08:24:50 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:19109 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726506AbfFYMYu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jun 2019 08:24:50 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id B59C77A453E4B3F2400D;
        Tue, 25 Jun 2019 20:24:44 +0800 (CST)
Received: from [127.0.0.1] (10.142.68.147) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.439.0; Tue, 25 Jun 2019
 20:24:34 +0800
Subject: Re: [PATCH v17 10/10] target-arm: kvm64: handle SIGBUS signal from
 kernel or KVM
To:     Igor Mammedov <imammedo@redhat.com>
CC:     <pbonzini@redhat.com>, <mst@redhat.com>,
        <shannon.zhaosl@gmail.com>, <peter.maydell@linaro.org>,
        <lersek@redhat.com>, <james.morse@arm.com>, <mtosatti@redhat.com>,
        <rth@twiddle.net>, <ehabkost@redhat.com>, <zhengxiang9@huawei.com>,
        <jonathan.cameron@huawei.com>, <xuwei5@huawei.com>,
        <kvm@vger.kernel.org>, <qemu-devel@nongnu.org>,
        <qemu-arm@nongnu.org>, <linuxarm@huawei.com>
References: <1557832703-42620-1-git-send-email-gengdongjiu@huawei.com>
 <1557832703-42620-11-git-send-email-gengdongjiu@huawei.com>
 <20190624150810.1287160e@redhat.com>
From:   gengdongjiu <gengdongjiu@huawei.com>
Message-ID: <3059ee08-c041-2006-36b5-fd0e53c08e79@huawei.com>
Date:   Tue, 25 Jun 2019 20:24:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190624150810.1287160e@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.142.68.147]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2019/6/24 21:08, Igor Mammedov wrote:
> On Tue, 14 May 2019 04:18:23 -0700
> Dongjiu Geng <gengdongjiu@huawei.com> wrote:
> 
>> Add SIGBUS signal handler. In this handler, it checks the SIGBUS type,
>> translates the host VA delivered by host to guest PA, then fill this PA
>> to guest APEI GHES memory, then notify guest according to the SIGBUS type.
>>
>> If guest accesses the poisoned memory, it generates Synchronous External
>> Abort(SEA). Then host kernel gets an APEI notification and call memory_failure()
>> to unmapped the affected page for the guest's stage 2, finally return
>> to guest.
>>
>> Guest continues to access PG_hwpoison page, it will trap to KVM as stage2 fault,
>> then a SIGBUS_MCEERR_AR synchronous signal is delivered to Qemu, Qemu record this
>> error address into guest APEI GHES memory and notify guest using
>> Synchronous-External-Abort(SEA).
>>
>> Suggested-by: James Morse <james.morse@arm.com>
>> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
>> ---
>>  hw/acpi/acpi_ghes.c         | 177 ++++++++++++++++++++++++++++++++++++++++++++
>>  include/hw/acpi/acpi_ghes.h |   6 +-
>>  include/sysemu/kvm.h        |   2 +-
>>  target/arm/kvm64.c          |  39 ++++++++++
>>  4 files changed, 222 insertions(+), 2 deletions(-)
>>
>> diff --git a/hw/acpi/acpi_ghes.c b/hw/acpi/acpi_ghes.c
>> index d03e797..06b7374 100644
>> --- a/hw/acpi/acpi_ghes.c
>> +++ b/hw/acpi/acpi_ghes.c
>> @@ -26,6 +26,101 @@
>>  #include "sysemu/sysemu.h"
>>  #include "qemu/error-report.h"
>>  
>> +/* UEFI 2.6: N.2.5 Memory Error Section */
>> +static void build_append_mem_cper(GArray *table, uint64_t error_physical_addr)
>> +{
>> +    /*
>> +     * Memory Error Record
>> +     */
>> +    build_append_int_noprefix(table,
>> +                 (1UL << 14) | /* Type Valid */
>> +                 (1UL << 1) /* Physical Address Valid */,
>> +                 8);
> bad indent
I will update it

> 
>> +    /* Memory error status information */
>> +    build_append_int_noprefix(table, 0, 8);
>> +    /* The physical address at which the memory error occurred */
>> +    build_append_int_noprefix(table, error_physical_addr, 8);
>> +    build_append_int_noprefix(table, 0, 48);
>> +    build_append_int_noprefix(table, 0 /* Unknown error */, 1);
>> +    build_append_int_noprefix(table, 0, 7);
>> +}
>> +
>> +static int ghes_record_mem_error(uint64_t error_block_address,
>> +                                    uint64_t error_physical_addr)
> bad indent
I will update it

> 
> 
>> +{
>> +    GArray *block;
>> +    uint64_t current_block_length;
>> +    uint32_t data_length;
>> +    /* Memory section */
>> +    char mem_section_id_le[] = {0x14, 0x11, 0xBC, 0xA5, 0x64, 0x6F, 0xDE,
>> +                                0x4E, 0xB8, 0x63, 0x3E, 0x83, 0xED, 0x7C,
>> +                                0x83, 0xB1};
>> +    uint8_t fru_id[16] = {0};
>> +    uint8_t fru_text[20] = {0};
>> +
>> +    /* Generic Error Status Block
>> +     * | +---------------------+
>> +     * | |     block_status    |
>> +     * | +---------------------+
>> +     * | |    raw_data_offset  |
>> +     * | +---------------------+
>> +     * | |    raw_data_length  |
>> +     * | +---------------------+
>> +     * | |     data_length     |
>> +     * | +---------------------+
>> +     * | |   error_severity    |
>> +     * | +---------------------+
>> +     */
>> +    block = g_array_new(false, true /* clear */, 1);
>> +
>> +    /* Get the length of the Generic Error Data Entries */
>> +    cpu_physical_memory_read(error_block_address +
>> +        offsetof(AcpiGenericErrorStatus, data_length), &data_length, 4);
>> +    /* The current whole length of the generic error status block */
>> +    current_block_length = sizeof(AcpiGenericErrorStatus) + le32_to_cpu(data_length);
> I might be missing something but why do you read length from guest?
> Isn't it something provided by QEMU/host?
The length of the Generic Error Data Entries is not fixed, as the CPER number increases, the length will increase.
there is already a member to record the length for the CPER in the table, this table is in the guest.
so it is better directly read the length from the table instead of providing by QEMU/host.


> 
>> +
>> +    /* This is the length if adding a new generic error data entry*/
>> +    data_length += GHES_DATA_LENGTH;
>> +    data_length += GHES_MEM_CPER_LENGTH;
>> +
>> +    /* Check whether it will run out of the preallocated memory if adding a new
>> +     * generic error data entry
>> +     */
>> +    if ((data_length + sizeof(AcpiGenericErrorStatus)) > GHES_MAX_RAW_DATA_LENGTH) {
>> +        error_report("Record CPER out of boundary!!!");
>> +        return GHES_CPER_FAIL;
>> +    }
>> +
>> +    /* Build the new generic error status block header */
>> +    build_append_ghes_generic_status(block, cpu_to_le32(ACPI_GEBS_UNCORRECTABLE), 0, 0,
>> +        cpu_to_le32(data_length), cpu_to_le32(ACPI_CPER_SEV_RECOVERABLE));
>> +
>> +    /* Write back above generic error status block header to guest memory */
>> +    cpu_physical_memory_write(error_block_address, block->data,
>> +                              block->len);
>> +
>> +    /* Add a new generic error data entry */
>> +
>> +    data_length = block->len;
>> +    /* Build this new generic error data entry header */
>> +    build_append_ghes_generic_data(block, mem_section_id_le,
>> +                    cpu_to_le32(ACPI_CPER_SEV_RECOVERABLE), cpu_to_le32(0x300), 0, 0,
>> +                    cpu_to_le32(80)/* the total size of Memory Error Record */, fru_id,
>> +                    fru_text, 0);
>> +
>> +    /* Build the memory section CPER for above new generic error data entry */
>> +    build_append_mem_cper(block, error_physical_addr);
>> +
>> +    /* Write back above this new generic error data entry to guest memory */
>> +    cpu_physical_memory_write(error_block_address + current_block_length,
>> +                    block->data + data_length, block->len - data_length);
>> +
>> +    g_array_free(block, true);
>> +
>> +    return GHES_CPER_OK;
>> +}
>> +
>>  /* Build table for the hardware error fw_cfg blob */
>>  void build_hardware_error_table(GArray *hardware_errors, BIOSLinker *linker)
>>  {
>> @@ -169,3 +264,85 @@ void ghes_add_fw_cfg(FWCfgState *s, GArray *hardware_error)
>>      fw_cfg_add_file_callback(s, GHES_DATA_ADDR_FW_CFG_FILE, NULL, NULL, NULL,
>>          &ges.ghes_addr_le, sizeof(ges.ghes_addr_le), false);
>>  }
>> +
>> +bool ghes_record_errors(uint32_t notify, uint64_t physical_address)
>> +{
>> +    uint64_t error_block_addr, read_ack_register_addr;
>> +    int read_ack_register = 0, loop = 0;
>> +    uint64_t start_addr = le32_to_cpu(ges.ghes_addr_le);
>> +    bool ret = GHES_CPER_FAIL;
>> +    const uint8_t error_source_id[] = { 0xff, 0xff, 0xff, 0xff,
>> +                                        0xff, 0xff, 0xff, 0, 1};
>> +
>> +    /*
>> +     * | +---------------------+ ges.ghes_addr_le
>> +     * | |error_block_address0 |
>> +     * | +---------------------+ --+--
>> +     * | |    .............    | GHES_ADDRESS_SIZE
>> +     * | +---------------------+ --+--
>> +     * | |error_block_addressN |
>> +     * | +---------------------+
>> +     * | | read_ack_register0  |
>> +     * | +---------------------+ --+--
>> +     * | |   .............     | GHES_ADDRESS_SIZE
>> +     * | +---------------------+ --+--
>> +     * | | read_ack_registerN  |
>> +     * | +---------------------+ --+--
>> +     * | |      CPER           |   |
>> +     * | |      ....           | GHES_MAX_RAW_DATA_LENGT
>> +     * | |      CPER           |   |
>> +     * | +---------------------+ --+--
>> +     * | |    ..........       |
>> +     * | +---------------------+
>> +     * | |      CPER           |
>> +     * | |      ....           |
>> +     * | |      CPER           |
>> +     * | +---------------------+
>> +     */
>> +    if (physical_address && notify < ACPI_HEST_NOTIFY_RESERVED) {
>> +        /* Find and check the source id for this new CPER */
>> +        if (error_source_id[notify] != 0xff) {
>> +            start_addr += error_source_id[notify] * GHES_ADDRESS_SIZE;
>> +        } else {
>> +            goto out;
>> +        }
>> +
>> +        cpu_physical_memory_read(start_addr, &error_block_addr,
>> +                                    GHES_ADDRESS_SIZE);
>> +
>> +        read_ack_register_addr = start_addr +
>> +                        ACPI_HEST_ERROR_SOURCE_COUNT * GHES_ADDRESS_SIZE;
>> +retry:
>> +        cpu_physical_memory_read(read_ack_register_addr,
>> +                                 &read_ack_register, GHES_ADDRESS_SIZE);
>> +
>> +        /* zero means OSPM does not acknowledge the error */
>> +        if (!read_ack_register) {
>> +            if (loop < 3) {
>> +                usleep(100 * 1000);
>> +                loop++;
>> +                goto retry;
>> +            } else {
>> +                error_report("OSPM does not acknowledge previous error,"
>> +                    " so can not record CPER for current error, forcibly acknowledge"
>> +                    " previous error to avoid blocking next time CPER record! Exit");
>> +                read_ack_register = 1;
>> +                cpu_physical_memory_write(read_ack_register_addr,
>> +                    &read_ack_register, GHES_ADDRESS_SIZE);
>> +            }
>> +        } else {
>> +            if (error_block_addr) {
>> +                read_ack_register = 0;
>> +                /* Clear the Read Ack Register, OSPM will write it to 1 when
>> +                 * acknowledge this error.
>> +                 */
>> +                cpu_physical_memory_write(read_ack_register_addr,
>> +                    &read_ack_register, GHES_ADDRESS_SIZE);
>> +                ret = ghes_record_mem_error(error_block_addr, physical_address);
>> +            }
>> +        }
>> +    }
>> +
>> +out:
>> +    return ret;
>> +}
>> diff --git a/include/hw/acpi/acpi_ghes.h b/include/hw/acpi/acpi_ghes.h
>> index 38fd87c..6b38097 100644
>> --- a/include/hw/acpi/acpi_ghes.h
>> +++ b/include/hw/acpi/acpi_ghes.h
>> @@ -32,11 +32,14 @@
>>  #define GHES_ADDRESS_SIZE           8
>>  
>>  #define GHES_DATA_LENGTH            72
>> -#define GHES_CPER_LENGTH            80
>> +#define GHES_MEM_CPER_LENGTH        80
>>  
>>  #define ReadAckPreserve             0xfffffffe
>>  #define ReadAckWrite                0x1
>>  
>> +#define GHES_CPER_OK                1
>> +#define GHES_CPER_FAIL              0
>> +
>>  /* The max size in bytes for one error block */
>>  #define GHES_MAX_RAW_DATA_LENGTH        0x1000
>>  /* Now only have GPIO-Signal and ARMv8 SEA notification types error sources
>> @@ -76,4 +79,5 @@ void build_apei_hest(GArray *table_data, GArray *hardware_error,
>>  
>>  void build_hardware_error_table(GArray *hardware_errors, BIOSLinker *linker);
>>  void ghes_add_fw_cfg(FWCfgState *s, GArray *hardware_errors);
>> +bool ghes_record_errors(uint32_t notify, uint64_t error_physical_addr);
>>  #endif
>> diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
>> index a6d1cd1..1d1a7a8 100644
>> --- a/include/sysemu/kvm.h
>> +++ b/include/sysemu/kvm.h
>> @@ -377,7 +377,7 @@ bool kvm_vcpu_id_is_valid(int vcpu_id);
>>  /* Returns VCPU ID to be used on KVM_CREATE_VCPU ioctl() */
>>  unsigned long kvm_arch_vcpu_id(CPUState *cpu);
>>  
>> -#ifdef TARGET_I386
>> +#if defined(TARGET_I386) || defined(TARGET_AARCH64)
>>  #define KVM_HAVE_MCE_INJECTION 1
>>  void kvm_arch_on_sigbus_vcpu(CPUState *cpu, int code, void *addr);
>>  #endif
>> diff --git a/target/arm/kvm64.c b/target/arm/kvm64.c
>> index c7bdc6a..d2eac28 100644
>> --- a/target/arm/kvm64.c
>> +++ b/target/arm/kvm64.c
>> @@ -27,6 +27,10 @@
>>  #include "kvm_arm.h"
>>  #include "internals.h"
>>  #include "hw/arm/arm.h"
>> +#include "exec/ram_addr.h"
>> +#include "hw/acpi/acpi-defs.h"
>> +#include "hw/acpi/acpi_ghes.h"
>> +#include "hw/acpi/acpi.h"
>>  
>>  static bool have_guest_debug;
>>  
>> @@ -1029,6 +1033,41 @@ int kvm_arch_get_registers(CPUState *cs)
>>      return ret;
>>  }
>>  
>> +void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr)
>> +{
>> +    ram_addr_t ram_addr;
>> +    hwaddr paddr;
>> +
>> +    assert(code == BUS_MCEERR_AR || code == BUS_MCEERR_AO);
>> +
>> +    if (acpi_enabled && addr) {
>> +        ram_addr = qemu_ram_addr_from_host(addr);
>> +        if (ram_addr != RAM_ADDR_INVALID &&
>> +            kvm_physical_memory_addr_from_host(c->kvm_state, addr, &paddr)) {
>> +            kvm_hwpoison_page_add(ram_addr);
>> +            /* Asynchronous signal will be masked by main thread, so
>> +             * only handle synchronous signal.
>> +             */
>> +            if (code == BUS_MCEERR_AR) {
>> +                kvm_cpu_synchronize_state(c);
>> +                if (GHES_CPER_FAIL != ghes_record_errors(ACPI_HEST_NOTIFY_SEA, paddr)) {
>> +                    kvm_inject_arm_sea(c);
>> +                } else {
>> +                    fprintf(stderr, "failed to record the error\n");
>> +                }
>> +            }
>> +            return;
>> +        }
>> +        fprintf(stderr, "Hardware memory error for memory used by "
>> +                "QEMU itself instead of guest system!\n");
>> +    }
>> +
>> +    if (code == BUS_MCEERR_AR) {
>> +        fprintf(stderr, "Hardware memory error!\n");
>> +        exit(1);
>> +    }
>> +}
>> +
>>  /* C6.6.29 BRK instruction */
>>  static const uint32_t brk_insn = 0xd4200000;
>>  
> 
> .
> 

