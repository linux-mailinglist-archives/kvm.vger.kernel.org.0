Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBDA41C7B20
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 22:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728888AbgEFUXC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 16:23:02 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:41150 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726885AbgEFUXC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 May 2020 16:23:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588796579;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+hoxZl5uTNpLSt0fv2HP1uBte8+65KVUGGnMGYBnbn8=;
        b=HiH08wUHhOjofkDF4MKV/L9NObqSGh03Ol9ZW7Hd2MP+9XICiALq+HOnJ4hZK4byzKATN4
        TN0xsvXHbWXqn4cAncHbOK33vaAAEmo2Utc6ov9YcEoK78+ADAg9j0wX8etlChvmWMSkGf
        z2CTkswsdoWn3B7+SMCJM+qVw1MwZ54=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-190-WLGtG9V2Mi-0uJBtqREs9w-1; Wed, 06 May 2020 16:22:57 -0400
X-MC-Unique: WLGtG9V2Mi-0uJBtqREs9w-1
Received: by mail-wr1-f72.google.com with SMTP id 30so1907362wrq.15
        for <kvm@vger.kernel.org>; Wed, 06 May 2020 13:22:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+hoxZl5uTNpLSt0fv2HP1uBte8+65KVUGGnMGYBnbn8=;
        b=W/bArzF0r8Sbxf4EeZhorAhLARJOffnE/x2bC+Mo3c9U5kbxb4vH12zE21E2Z/lfF/
         VMfTNbPegbMVy1YjeL+yVfcXGZU92lsnCf7uGwtRgrKeQ4h+TDaYVWXWXTPvQ0gPocor
         Hy1KQD2FaKSWW7jT0+RiRnNqY5Ny+mbVEDKi9+UiJN5sYAZjXnLgTAr/RXjYFyyJNQMR
         MGd/vxq+UABLWwdyM5cJV6gctIP47TP2S2SNv7mRSvFvxoPUgR6c0qgysJZDxdQNGY8H
         xP3qmGoibULPwRC3Fei3+s7ltVOhBH+grft3CcDeFc6wf4dBNbko1kLIV/hXx57D61uK
         lWhQ==
X-Gm-Message-State: AGi0Pua6N3aZQG+LsKHDrnFeWK1WsBazZ+Nd6984yqVfT50ImJCcHMRW
        LqnvqCZbR1zYrULfLphFBUrygBJHLsEDfqqCJpW0GnJ+scK6C1iEOHngaA4QKXL3aEz+uI7QISE
        J2iiyqI7VZPdB
X-Received: by 2002:a1c:1f83:: with SMTP id f125mr5986698wmf.150.1588796576579;
        Wed, 06 May 2020 13:22:56 -0700 (PDT)
X-Google-Smtp-Source: APiQypKAdZZr7TXBFoiPYDyzQjZ2JTIIKBmmZCQgHhZzn3DRvI1ks08+KZo+Z1cftAVxMFRL2pTr6A==
X-Received: by 2002:a1c:1f83:: with SMTP id f125mr5986657wmf.150.1588796576246;
        Wed, 06 May 2020 13:22:56 -0700 (PDT)
Received: from redhat.com (bzq-109-66-7-121.red.bezeqint.net. [109.66.7.121])
        by smtp.gmail.com with ESMTPSA id n6sm4550205wrs.81.2020.05.06.13.22.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 13:22:55 -0700 (PDT)
Date:   Wed, 6 May 2020 16:22:52 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Dongjiu Geng <gengdongjiu@huawei.com>
Cc:     imammedo@redhat.com, xiaoguangrong.eric@gmail.com,
        peter.maydell@linaro.org, shannon.zhaosl@gmail.com, fam@euphon.net,
        rth@twiddle.net, ehabkost@redhat.com, mtosatti@redhat.com,
        qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-arm@nongnu.org,
        pbonzini@redhat.com, zhengxiang9@huawei.com,
        Jonathan.Cameron@huawei.com, linuxarm@huawei.com
Subject: Re: [PATCH v25 05/10] ACPI: Build Hardware Error Source Table
Message-ID: <20200506162246-mutt-send-email-mst@kernel.org>
References: <20200410114639.32844-1-gengdongjiu@huawei.com>
 <20200410114639.32844-6-gengdongjiu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200410114639.32844-6-gengdongjiu@huawei.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 10, 2020 at 07:46:34PM +0800, Dongjiu Geng wrote:
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
> Signed-off-by: Xiang Zheng <zhengxiang9@huawei.com>
> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>

Reviewed-by: Michael S. Tsirkin <mst@redhat.com>

> ---
> change since v24:
> 1. Add acpi_add_table() before acpi_build_hest()
> 2. Pass NULL for oem_table_id in build_header() to build Hardware
>    Error Source Table header
> ---
>  hw/acpi/ghes.c           | 126 +++++++++++++++++++++++++++++++++++++++++++++++
>  hw/arm/virt-acpi-build.c |   2 +
>  include/hw/acpi/ghes.h   |  39 +++++++++++++++
>  3 files changed, 167 insertions(+)
> 
> diff --git a/hw/acpi/ghes.c b/hw/acpi/ghes.c
> index e1b3f8f..091fd87 100644
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
> +        "HEST", table_data->len - hest_start, 1, NULL, NULL);
> +}
> diff --git a/hw/arm/virt-acpi-build.c b/hw/arm/virt-acpi-build.c
> index cc6ffcd..f611bce 100644
> --- a/hw/arm/virt-acpi-build.c
> +++ b/hw/arm/virt-acpi-build.c
> @@ -820,6 +820,8 @@ void virt_acpi_build(VirtMachineState *vms, AcpiBuildTables *tables)
>  
>      if (vms->ras) {
>          build_ghes_error_table(tables->hardware_errors, tables->linker);
> +        acpi_add_table(table_offsets, tables_blob);
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
> -- 
> 1.8.3.1

