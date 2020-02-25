Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E471016C22C
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 14:23:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729590AbgBYNXx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 08:23:53 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:53863 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729386AbgBYNXx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Feb 2020 08:23:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582637032;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eDwDbaBrloN0/9UIxTHB+r5PAkSFUSrWWrBgDy0DRks=;
        b=NUVSMwXQlyOLWo2u3w6yTrjT3C7UpQni0C95wjBsQsDbYhWEHy7q29RUFTyYdQPqmODYc7
        CjSKSCDNPvXMljpaN+p7aZwS+3SHNdTm9dpZlV5lWruQjFuqMb6vvbCBikUoY4kTO9YJuw
        BVqmk3cTc0UmgM9W4tDHk3TbWp3zqPE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-210-CYrY3AgSPbeUcNsH9vOCFw-1; Tue, 25 Feb 2020 08:23:48 -0500
X-MC-Unique: CYrY3AgSPbeUcNsH9vOCFw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B86E2101FC6E;
        Tue, 25 Feb 2020 13:23:45 +0000 (UTC)
Received: from localhost (unknown [10.43.2.114])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3227B5C1D6;
        Tue, 25 Feb 2020 13:23:38 +0000 (UTC)
Date:   Tue, 25 Feb 2020 14:23:36 +0100
From:   Igor Mammedov <imammedo@redhat.com>
To:     Dongjiu Geng <gengdongjiu@huawei.com>
Cc:     <mst@redhat.com>, <xiaoguangrong.eric@gmail.com>,
        <shannon.zhaosl@gmail.com>, <peter.maydell@linaro.org>,
        <fam@euphon.net>, <rth@twiddle.net>, <ehabkost@redhat.com>,
        <mtosatti@redhat.com>, <qemu-devel@nongnu.org>,
        <kvm@vger.kernel.org>, <qemu-arm@nongnu.org>,
        <pbonzini@redhat.com>, <james.morse@arm.com>, <lersek@redhat.com>,
        <jonathan.cameron@huawei.com>,
        <shameerali.kolothum.thodi@huawei.com>, zhengxiang9@huawei.com
Subject: Re: [PATCH v24 05/10] ACPI: Build Hardware Error Source Table
Message-ID: <20200225142336.16b7fc40@redhat.com>
In-Reply-To: <20200217131248.28273-6-gengdongjiu@huawei.com>
References: <20200217131248.28273-1-gengdongjiu@huawei.com>
        <20200217131248.28273-6-gengdongjiu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 17 Feb 2020 21:12:43 +0800
Dongjiu Geng <gengdongjiu@huawei.com> wrote:

> This patch builds Hardware Error Source Table(HEST) via fw_cfg blobs.
> Now it only supports ARMv8 SEA, a type of Generic Hardware Error
> Source version 2(GHESv2) error source. Afterwards, we can extend
> the supported types if needed. For the CPER section, currently it
> is memory section because kernel mainly wants userspace to handle
> the memory errors.
> 
> This patch follows the spec ACPI 6.2 to build the Hardware Error
> Source table. For more detailed information, please refer to
> document: docs/specs/acpi_hest_ghes.rst
> 
> build_ghes_hw_error_notification() helper will help to add Hardware
> Error Notification to ACPI tables without using packed C structures
> and avoid endianness issues as API doesn't need explicit conversion.
> 
> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
> Signed-off-by: Xiang Zheng <zhengxiang9@huawei.com>
> Acked-by: Xiang Zheng <zhengxiang9@huawei.com>
> ---
>  hw/acpi/ghes.c           | 126 +++++++++++++++++++++++++++++++++++++++++++++++
>  hw/arm/virt-acpi-build.c |   1 +
>  include/hw/acpi/ghes.h   |  39 +++++++++++++++
>  3 files changed, 166 insertions(+)
> 
> diff --git a/hw/acpi/ghes.c b/hw/acpi/ghes.c
> index e1b3f8f..7a7381d 100644
> --- a/hw/acpi/ghes.c
> +++ b/hw/acpi/ghes.c
> @@ -23,6 +23,7 @@
>  #include "qemu/units.h"
>  #include "hw/acpi/ghes.h"
>  #include "hw/acpi/aml-build.h"
> +#include "qemu/error-report.h"
>  
>  #define ACPI_GHES_ERRORS_FW_CFG_FILE        "etc/hardware_errors"
>  #define ACPI_GHES_DATA_ADDR_FW_CFG_FILE     "etc/hardware_errors_addr"
> @@ -33,6 +34,42 @@
>  /* Now only support ARMv8 SEA notification type error source */
>  #define ACPI_GHES_ERROR_SOURCE_COUNT        1
>  
> +/* Generic Hardware Error Source version 2 */
> +#define ACPI_GHES_SOURCE_GENERIC_ERROR_V2   10
> +
> +/* Address offset in Generic Address Structure(GAS) */
> +#define GAS_ADDR_OFFSET 4
> +
> +/*
> + * Hardware Error Notification
> + * ACPI 4.0: 17.3.2.7 Hardware Error Notification
> + * Composes dummy Hardware Error Notification descriptor of specified type
> + */
> +static void build_ghes_hw_error_notification(GArray *table, const uint8_t type)
> +{
> +    /* Type */
> +    build_append_int_noprefix(table, type, 1);
> +    /*
> +     * Length:
> +     * Total length of the structure in bytes
> +     */
> +    build_append_int_noprefix(table, 28, 1);
> +    /* Configuration Write Enable */
> +    build_append_int_noprefix(table, 0, 2);
> +    /* Poll Interval */
> +    build_append_int_noprefix(table, 0, 4);
> +    /* Vector */
> +    build_append_int_noprefix(table, 0, 4);
> +    /* Switch To Polling Threshold Value */
> +    build_append_int_noprefix(table, 0, 4);
> +    /* Switch To Polling Threshold Window */
> +    build_append_int_noprefix(table, 0, 4);
> +    /* Error Threshold Value */
> +    build_append_int_noprefix(table, 0, 4);
> +    /* Error Threshold Window */
> +    build_append_int_noprefix(table, 0, 4);
> +}
> +
>  /*
>   * Build table for the hardware error fw_cfg blob.
>   * Initialize "etc/hardware_errors" and "etc/hardware_errors_addr" fw_cfg blobs.
> @@ -87,3 +124,92 @@ void build_ghes_error_table(GArray *hardware_errors, BIOSLinker *linker)
>      bios_linker_loader_write_pointer(linker, ACPI_GHES_DATA_ADDR_FW_CFG_FILE,
>          0, sizeof(uint64_t), ACPI_GHES_ERRORS_FW_CFG_FILE, 0);
>  }
> +
> +/* Build Generic Hardware Error Source version 2 (GHESv2) */
> +static void build_ghes_v2(GArray *table_data, int source_id, BIOSLinker *linker)
> +{
> +    uint64_t address_offset;
> +    /*
> +     * Type:
> +     * Generic Hardware Error Source version 2(GHESv2 - Type 10)
> +     */
> +    build_append_int_noprefix(table_data, ACPI_GHES_SOURCE_GENERIC_ERROR_V2, 2);
> +    /* Source Id */
> +    build_append_int_noprefix(table_data, source_id, 2);
> +    /* Related Source Id */
> +    build_append_int_noprefix(table_data, 0xffff, 2);
> +    /* Flags */
> +    build_append_int_noprefix(table_data, 0, 1);
> +    /* Enabled */
> +    build_append_int_noprefix(table_data, 1, 1);
> +
> +    /* Number of Records To Pre-allocate */
> +    build_append_int_noprefix(table_data, 1, 4);
> +    /* Max Sections Per Record */
> +    build_append_int_noprefix(table_data, 1, 4);
> +    /* Max Raw Data Length */
> +    build_append_int_noprefix(table_data, ACPI_GHES_MAX_RAW_DATA_LENGTH, 4);
> +
> +    address_offset = table_data->len;
> +    /* Error Status Address */
> +    build_append_gas(table_data, AML_AS_SYSTEM_MEMORY, 0x40, 0,
> +                     4 /* QWord access */, 0);
> +    bios_linker_loader_add_pointer(linker, ACPI_BUILD_TABLE_FILE,
> +        address_offset + GAS_ADDR_OFFSET, sizeof(uint64_t),
> +        ACPI_GHES_ERRORS_FW_CFG_FILE, source_id * sizeof(uint64_t));
> +
> +    switch (source_id) {
> +    case ACPI_HEST_SRC_ID_SEA:
> +        /*
> +         * Notification Structure
> +         * Now only enable ARMv8 SEA notification type
> +         */
> +        build_ghes_hw_error_notification(table_data, ACPI_GHES_NOTIFY_SEA);
> +        break;
> +    default:
> +        error_report("Not support this error source");
> +        abort();
> +    }
> +
> +    /* Error Status Block Length */
> +    build_append_int_noprefix(table_data, ACPI_GHES_MAX_RAW_DATA_LENGTH, 4);
> +
> +    /*
> +     * Read Ack Register
> +     * ACPI 6.1: 18.3.2.8 Generic Hardware Error Source
> +     * version 2 (GHESv2 - Type 10)
> +     */
> +    address_offset = table_data->len;
> +    build_append_gas(table_data, AML_AS_SYSTEM_MEMORY, 0x40, 0,
> +                     4 /* QWord access */, 0);
> +    bios_linker_loader_add_pointer(linker, ACPI_BUILD_TABLE_FILE,
> +        address_offset + GAS_ADDR_OFFSET,
> +        sizeof(uint64_t), ACPI_GHES_ERRORS_FW_CFG_FILE,
> +        (ACPI_GHES_ERROR_SOURCE_COUNT + source_id) * sizeof(uint64_t));
> +
> +    /*
> +     * Read Ack Preserve field
> +     * We only provide the first bit in Read Ack Register to OSPM to write
> +     * while the other bits are preserved.
> +     */
> +    build_append_int_noprefix(table_data, ~0x1ULL, 8);
> +    /* Read Ack Write */
> +    build_append_int_noprefix(table_data, 0x1, 8);
> +}
> +
> +/* Build Hardware Error Source Table */
> +void acpi_build_hest(GArray *table_data, BIOSLinker *linker)
> +{
> +    uint64_t hest_start = table_data->len;
> +
> +    /* Hardware Error Source Table header*/
> +    acpi_data_push(table_data, sizeof(AcpiTableHeader));
> +
> +    /* Error Source Count */
> +    build_append_int_noprefix(table_data, ACPI_GHES_ERROR_SOURCE_COUNT, 4);
> +
> +    build_ghes_v2(table_data, ACPI_HEST_SRC_ID_SEA, linker);
> +
> +    build_header(linker, table_data, (void *)(table_data->data + hest_start),
> +        "HEST", table_data->len - hest_start, 1, NULL, "");
                                                          ^^^
is there any particular reason to make it empty instead of putting NULL there
so that QEMU would use default value?

> +}
> diff --git a/hw/arm/virt-acpi-build.c b/hw/arm/virt-acpi-build.c
> index 6819fcf..12a9a78 100644
> --- a/hw/arm/virt-acpi-build.c
> +++ b/hw/arm/virt-acpi-build.c
> @@ -834,6 +834,7 @@ void virt_acpi_build(VirtMachineState *vms, AcpiBuildTables *tables)
>      if (vms->ras) {
>          acpi_add_table(table_offsets, tables_blob);
>          build_ghes_error_table(tables->hardware_errors, tables->linker);
> +        acpi_build_hest(tables_blob, tables->linker);
>      }
>  
>      if (ms->numa_state->num_nodes > 0) {
> diff --git a/include/hw/acpi/ghes.h b/include/hw/acpi/ghes.h
> index 50379b0..18debd8 100644
> --- a/include/hw/acpi/ghes.h
> +++ b/include/hw/acpi/ghes.h
> @@ -24,5 +24,44 @@
>  
>  #include "hw/acpi/bios-linker-loader.h"
>  
> +/*
> + * Values for Hardware Error Notification Type field
> + */
> +enum AcpiGhesNotifyType {
> +    /* Polled */
> +    ACPI_GHES_NOTIFY_POLLED = 0,
> +    /* External Interrupt */
> +    ACPI_GHES_NOTIFY_EXTERNAL = 1,
> +    /* Local Interrupt */
> +    ACPI_GHES_NOTIFY_LOCAL = 2,
> +    /* SCI */
> +    ACPI_GHES_NOTIFY_SCI = 3,
> +    /* NMI */
> +    ACPI_GHES_NOTIFY_NMI = 4,
> +    /* CMCI, ACPI 5.0: 18.3.2.7, Table 18-290 */
> +    ACPI_GHES_NOTIFY_CMCI = 5,
> +    /* MCE, ACPI 5.0: 18.3.2.7, Table 18-290 */
> +    ACPI_GHES_NOTIFY_MCE = 6,
> +    /* GPIO-Signal, ACPI 6.0: 18.3.2.7, Table 18-332 */
> +    ACPI_GHES_NOTIFY_GPIO = 7,
> +    /* ARMv8 SEA, ACPI 6.1: 18.3.2.9, Table 18-345 */
> +    ACPI_GHES_NOTIFY_SEA = 8,
> +    /* ARMv8 SEI, ACPI 6.1: 18.3.2.9, Table 18-345 */
> +    ACPI_GHES_NOTIFY_SEI = 9,
> +    /* External Interrupt - GSIV, ACPI 6.1: 18.3.2.9, Table 18-345 */
> +    ACPI_GHES_NOTIFY_GSIV = 10,
> +    /* Software Delegated Exception, ACPI 6.2: 18.3.2.9, Table 18-383 */
> +    ACPI_GHES_NOTIFY_SDEI = 11,
> +    /* 12 and greater are reserved */
> +    ACPI_GHES_NOTIFY_RESERVED = 12
> +};
> +
> +enum {
> +    ACPI_HEST_SRC_ID_SEA = 0,
> +    /* future ids go here */
> +    ACPI_HEST_SRC_ID_RESERVED,
> +};
> +
>  void build_ghes_error_table(GArray *hardware_errors, BIOSLinker *linker);
> +void acpi_build_hest(GArray *table_data, BIOSLinker *linker);
>  #endif

