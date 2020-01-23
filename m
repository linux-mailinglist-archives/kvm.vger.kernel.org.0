Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E471E146D45
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2020 16:48:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbgAWPsZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jan 2020 10:48:25 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:45180 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726231AbgAWPsZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Jan 2020 10:48:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579794502;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H55UGcj9JNEhuKBOPdJUGxTRwPeyv/2LSIFTHjTEnp8=;
        b=J+6BF/oDEcYNJXt+ltg4u4MAgI/ZnbPAhl/MnWlyf2EdoWdk0AnEhnISNQt9E8XzgNw3/D
        9RjGygcl3WRMBxh1AsAFUDTIF5gdKK2IrCJ7f8xx7pYUd9qQ1zfXeVaNB2ifcTuMIDTjq2
        HAv7hi9fHpeRYuBbxg0mXupxeWOX44A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-315-EnG-gdkCM4KtqWBMWSvXdw-1; Thu, 23 Jan 2020 10:48:20 -0500
X-MC-Unique: EnG-gdkCM4KtqWBMWSvXdw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D923E1005512;
        Thu, 23 Jan 2020 15:48:17 +0000 (UTC)
Received: from localhost (unknown [10.43.2.114])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 974FA5D9E2;
        Thu, 23 Jan 2020 15:48:10 +0000 (UTC)
Date:   Thu, 23 Jan 2020 16:48:08 +0100
From:   Igor Mammedov <imammedo@redhat.com>
To:     Dongjiu Geng <gengdongjiu@huawei.com>
Cc:     <pbonzini@redhat.com>, <mst@redhat.com>,
        <shannon.zhaosl@gmail.com>, <peter.maydell@linaro.org>,
        <fam@euphon.net>, <rth@twiddle.net>, <ehabkost@redhat.com>,
        <mtosatti@redhat.com>, <xuwei5@huawei.com>,
        <jonathan.cameron@huawei.com>, <james.morse@arm.com>,
        <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>,
        <qemu-arm@nongnu.org>, <zhengxiang9@huawei.com>,
        <linuxarm@huawei.com>
Subject: Re: [PATCH v22 4/9] ACPI: Build Hardware Error Source Table
Message-ID: <20200123164808.38af0491@redhat.com>
In-Reply-To: <1578483143-14905-5-git-send-email-gengdongjiu@huawei.com>
References: <1578483143-14905-1-git-send-email-gengdongjiu@huawei.com>
        <1578483143-14905-5-git-send-email-gengdongjiu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 8 Jan 2020 19:32:18 +0800
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
> build_append_ghes_notify() will help to add Hardware Error Notification
> to ACPI tables without using packed C structures and avoid endianness
> issues as API doesn't need explicit conversion.
> 
> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
> Signed-off-by: Xiang Zheng <zhengxiang9@huawei.com>
> Reviewed-by: Michael S. Tsirkin <mst@redhat.com>
> Acked-by: Xiang Zheng <zhengxiang9@huawei.com>


Overall it looks fine to me, see couple nits below


> ---
>  hw/acpi/ghes.c           | 118 ++++++++++++++++++++++++++++++++++++++++++++++-
>  hw/arm/virt-acpi-build.c |   2 +
>  include/hw/acpi/ghes.h   |  40 ++++++++++++++++
>  3 files changed, 159 insertions(+), 1 deletion(-)
> 
> diff --git a/hw/acpi/ghes.c b/hw/acpi/ghes.c
> index b7fdbbb..9d37798 100644
> --- a/hw/acpi/ghes.c
> +++ b/hw/acpi/ghes.c
> @@ -34,9 +34,42 @@
>  
>  /* The max size in bytes for one error block */
>  #define ACPI_GHES_MAX_RAW_DATA_LENGTH       0x400
> -
>  /* Now only support ARMv8 SEA notification type error source */
>  #define ACPI_GHES_ERROR_SOURCE_COUNT        1
> +/* Generic Hardware Error Source version 2 */
> +#define ACPI_GHES_SOURCE_GENERIC_ERROR_V2   10
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
>  
>  /*
>   * Build table for the hardware error fw_cfg blob.
> @@ -92,3 +125,86 @@ void build_ghes_error_table(GArray *hardware_errors, BIOSLinker *linker)
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
> +        address_offset + GAS_ADDR_OFFSET,
> +        sizeof(uint64_t), ACPI_GHES_ERRORS_FW_CFG_FILE, 0);
> +
> +    /*
> +     * Notification Structure
> +     * Now only enable ARMv8 SEA notification type
> +     */
> +    build_ghes_hw_error_notification(table_data, ACPI_GHES_NOTIFY_SEA);
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
> +        ACPI_GHES_ERROR_SOURCE_COUNT * sizeof(uint64_t));
> +
> +    /*
> +     * Read Ack Preserve
> +     * We only provide the first bit in Read Ack Register to OSPM to write
> +     * while the other bits are preserved.
> +     */
> +    build_append_int_noprefix(table_data, ~0x1ULL, 8);
> +    /* Read Ack Write */
> +    build_append_int_noprefix(table_data, 0x1, 8);
> +}
> +
> +/* Build Hardware Error Source Table */
> +void acpi_build_hest(GArray *table_data, GArray *hardware_errors,
                                             ^^^^^^^^ it seems to be unused, so why it's here?

> +                          BIOSLinker *linker)
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
> +}
> diff --git a/hw/arm/virt-acpi-build.c b/hw/arm/virt-acpi-build.c
> index 6819fcf..837bbf9 100644
> --- a/hw/arm/virt-acpi-build.c
> +++ b/hw/arm/virt-acpi-build.c
> @@ -834,6 +834,8 @@ void virt_acpi_build(VirtMachineState *vms, AcpiBuildTables *tables)
>      if (vms->ras) {
>          acpi_add_table(table_offsets, tables_blob);
>          build_ghes_error_table(tables->hardware_errors, tables->linker);
> +        acpi_build_hest(tables_blob, tables->hardware_errors,
> +                             tables->linker);

not aligned properly

you can use ./scripts/checkpatch.pl to see if there is style errors


>      }
>  
>      if (ms->numa_state->num_nodes > 0) {
> diff --git a/include/hw/acpi/ghes.h b/include/hw/acpi/ghes.h
> index 3dbda3f..09a7f86 100644
> --- a/include/hw/acpi/ghes.h
> +++ b/include/hw/acpi/ghes.h
> @@ -22,5 +22,45 @@
>  #ifndef ACPI_GHES_H
>  #define ACPI_GHES_H
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
> +void acpi_build_hest(GArray *table_data, GArray *hardware_error,
> +                          BIOSLinker *linker);
>  #endif

