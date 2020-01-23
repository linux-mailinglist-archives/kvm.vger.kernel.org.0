Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6506146C6A
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2020 16:15:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727278AbgAWPPH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jan 2020 10:15:07 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:43986 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726232AbgAWPPH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jan 2020 10:15:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579792505;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zHxKV5delk2SSk0YuUAQlRrTMWrEa6kG/0h6v9KRSsk=;
        b=NmKRgbm7HqkUXFU4Dj2ql5nDEhC87bpI08sRx/scC3SpkqETY/zayve4EsHr2cUPOA/U+j
        vkzO/RarGt3aRCFM61AzIBRSaLD6E/hn6x84htO7YPjVr6sOn/q9xcP5Fe4L1Q1ZZYdtnN
        7KNFbFs9uM1qbMZvBNeHmrKR5iqLYN4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-338-F4Nr1m3AOiS65u8fRdpwgw-1; Thu, 23 Jan 2020 10:15:01 -0500
X-MC-Unique: F4Nr1m3AOiS65u8fRdpwgw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 144429496D;
        Thu, 23 Jan 2020 15:14:59 +0000 (UTC)
Received: from localhost (unknown [10.43.2.114])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 45D485C1B2;
        Thu, 23 Jan 2020 15:14:52 +0000 (UTC)
Date:   Thu, 23 Jan 2020 16:14:51 +0100
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
Subject: Re: [PATCH v22 3/9] ACPI: Build related register address fields via
 hardware error fw_cfg blob
Message-ID: <20200123161451.07c4a291@redhat.com>
In-Reply-To: <1578483143-14905-4-git-send-email-gengdongjiu@huawei.com>
References: <1578483143-14905-1-git-send-email-gengdongjiu@huawei.com>
        <1578483143-14905-4-git-send-email-gengdongjiu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 8 Jan 2020 19:32:17 +0800
Dongjiu Geng <gengdongjiu@huawei.com> wrote:

> This patch builds error_block_address and read_ack_register fields
> in hardware errors table , the error_block_address points to Generic
> Error Status Block(GESB) via bios_linker. The max size for one GESB
> is 0x1000 in bytes, For more detailed information, please refer to

s/0x1000/4Kb/

> document: docs/specs/acpi_hest_ghes.rst
> 
> Now we only support one Error source, if necessary, we can extend to
> support more.
> 
> Suggested-by: Laszlo Ersek <lersek@redhat.com>
> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
> Signed-off-by: Xiang Zheng <zhengxiang9@huawei.com>
> Reviewed-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  default-configs/arm-softmmu.mak |  1 +
>  hw/acpi/Kconfig                 |  4 ++
>  hw/acpi/Makefile.objs           |  1 +
>  hw/acpi/aml-build.c             |  2 +
>  hw/acpi/ghes.c                  | 94 +++++++++++++++++++++++++++++++++++++++++
>  hw/arm/virt-acpi-build.c        |  6 +++
>  include/hw/acpi/aml-build.h     |  1 +
>  include/hw/acpi/ghes.h          | 26 ++++++++++++
>  8 files changed, 135 insertions(+)
>  create mode 100644 hw/acpi/ghes.c
>  create mode 100644 include/hw/acpi/ghes.h
> 
> diff --git a/default-configs/arm-softmmu.mak b/default-configs/arm-softmmu.mak
> index 1f2e0e7..5722f31 100644
> --- a/default-configs/arm-softmmu.mak
> +++ b/default-configs/arm-softmmu.mak
> @@ -40,3 +40,4 @@ CONFIG_FSL_IMX25=y
>  CONFIG_FSL_IMX7=y
>  CONFIG_FSL_IMX6UL=y
>  CONFIG_SEMIHOSTING=y
> +CONFIG_ACPI_APEI=y
> diff --git a/hw/acpi/Kconfig b/hw/acpi/Kconfig
> index 12e3f1e..ed8c34d 100644
> --- a/hw/acpi/Kconfig
> +++ b/hw/acpi/Kconfig
> @@ -23,6 +23,10 @@ config ACPI_NVDIMM
>      bool
>      depends on ACPI
>  
> +config ACPI_APEI
> +    bool
> +    depends on ACPI
> +
>  config ACPI_PCI
>      bool
>      depends on ACPI && PCI
> diff --git a/hw/acpi/Makefile.objs b/hw/acpi/Makefile.objs
> index 9925305..7b5db4b 100644
> --- a/hw/acpi/Makefile.objs
> +++ b/hw/acpi/Makefile.objs
> @@ -5,6 +5,7 @@ common-obj-$(CONFIG_ACPI_CPU_HOTPLUG) += cpu_hotplug.o
>  common-obj-$(CONFIG_ACPI_MEMORY_HOTPLUG) += memory_hotplug.o
>  common-obj-$(CONFIG_ACPI_CPU_HOTPLUG) += cpu.o
>  common-obj-$(CONFIG_ACPI_NVDIMM) += nvdimm.o
> +common-obj-$(CONFIG_ACPI_APEI) += ghes.o
>  common-obj-$(CONFIG_ACPI_VMGENID) += vmgenid.o
>  common-obj-$(CONFIG_ACPI_HW_REDUCED) += generic_event_device.o
>  common-obj-$(call lnot,$(CONFIG_ACPI_X86)) += acpi-stub.o
> diff --git a/hw/acpi/aml-build.c b/hw/acpi/aml-build.c
> index 2c3702b..3681ec6 100644
> --- a/hw/acpi/aml-build.c
> +++ b/hw/acpi/aml-build.c
> @@ -1578,6 +1578,7 @@ void acpi_build_tables_init(AcpiBuildTables *tables)
>      tables->table_data = g_array_new(false, true /* clear */, 1);
>      tables->tcpalog = g_array_new(false, true /* clear */, 1);
>      tables->vmgenid = g_array_new(false, true /* clear */, 1);
> +    tables->hardware_errors = g_array_new(false, true /* clear */, 1);
>      tables->linker = bios_linker_loader_init();
>  }
>  
> @@ -1588,6 +1589,7 @@ void acpi_build_tables_cleanup(AcpiBuildTables *tables, bool mfre)
>      g_array_free(tables->table_data, true);
>      g_array_free(tables->tcpalog, mfre);
>      g_array_free(tables->vmgenid, mfre);
> +    g_array_free(tables->hardware_errors, mfre);
>  }
>  
>  /*
> diff --git a/hw/acpi/ghes.c b/hw/acpi/ghes.c
> new file mode 100644
> index 0000000..b7fdbbb
> --- /dev/null
> +++ b/hw/acpi/ghes.c
> @@ -0,0 +1,94 @@
> +/*
> + * Support for generating APEI tables and recording CPER for Guests
> + *
> + * Copyright (c) 2019 HUAWEI TECHNOLOGIES CO., LTD.
s/2019/2020/

the same for other places that add this string within this series

> + *
> + * Author: Dongjiu Geng <gengdongjiu@huawei.com>
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
> +#include "hw/acpi/acpi.h"
> +#include "hw/acpi/ghes.h"
> +#include "hw/acpi/aml-build.h"
> +#include "hw/nvram/fw_cfg.h"
> +#include "sysemu/sysemu.h"
> +#include "qemu/error-report.h"
> +
> +#include "hw/acpi/bios-linker-loader.h"
> +
> +#define ACPI_GHES_ERRORS_FW_CFG_FILE        "etc/hardware_errors"
> +#define ACPI_GHES_DATA_ADDR_FW_CFG_FILE     "etc/hardware_errors_addr"
> +
> +/* The max size in bytes for one error block */
> +#define ACPI_GHES_MAX_RAW_DATA_LENGTH       0x400

using 1 * KiB would make it more readable


> +
> +/* Now only support ARMv8 SEA notification type error source */
> +#define ACPI_GHES_ERROR_SOURCE_COUNT        1
> +
> +/*
> + * Build table for the hardware error fw_cfg blob.
> + * Initialize "etc/hardware_errors" and "etc/hardware_errors_addr" fw_cfg blobs.
> + * See docs/specs/acpi_hest_ghes.rst for blobs format.
> + */
> +void build_ghes_error_table(GArray *hardware_errors, BIOSLinker *linker)
> +{
> +    int i, error_status_block_offset;
> +
> +    /* Build error_block_address */
> +    for (i = 0; i < ACPI_GHES_ERROR_SOURCE_COUNT; i++) {
> +        build_append_int_noprefix(hardware_errors, 0, sizeof(uint64_t));
> +    }
> +
> +    /* Build read_ack_register */
> +    for (i = 0; i < ACPI_GHES_ERROR_SOURCE_COUNT; i++) {
> +        /*
> +         * Initialize the value of read_ack_register to 1, so GHES can be
> +         * writeable after (re)boot.
> +         * ACPI 6.2: 18.3.2.8 Generic Hardware Error Source version 2
> +         * (GHESv2 - Type 10)
> +         */
> +        build_append_int_noprefix(hardware_errors, 1, sizeof(uint64_t));
> +    }
> +
> +    /* Generic Error Status Block offset in the hardware error fw_cfg blob */
> +    error_status_block_offset = hardware_errors->len;
> +
> +    /* Reserve space for Error Status Data Block */
> +    acpi_data_push(hardware_errors,
> +        ACPI_GHES_MAX_RAW_DATA_LENGTH * ACPI_GHES_ERROR_SOURCE_COUNT);
> +
> +    /* Tell guest firmware to place hardware_errors blob into RAM */
> +    bios_linker_loader_alloc(linker, ACPI_GHES_ERRORS_FW_CFG_FILE,
> +                             hardware_errors, 1, false);
                                                ^^
/*                                                                               
 * bios_linker_loader_alloc: ask guest to load file into guest memory.           
[...]
 * @alloc_align: required minimal alignment in bytes. Must be a power of 2.      
                                                                                                          Maybe use 8 here to make 64bit addresses naturally aligned?

> +
> +    for (i = 0; i < ACPI_GHES_ERROR_SOURCE_COUNT; i++) {
> +        /*
> +         * Tell firmware to patch error_block_address entries to point to
> +         * corresponding "Generic Error Status Block"
> +         */
> +        bios_linker_loader_add_pointer(linker,
> +            ACPI_GHES_ERRORS_FW_CFG_FILE, sizeof(uint64_t) * i,
> +            sizeof(uint64_t), ACPI_GHES_ERRORS_FW_CFG_FILE,
> +            error_status_block_offset + i * ACPI_GHES_MAX_RAW_DATA_LENGTH);
> +    }
> +
> +    /*
> +     * tell firmware to write hardware_errors GPA into
> +     * hardware_errors_addr fw_cfg, once the former has been initialized.
> +     */
> +    bios_linker_loader_write_pointer(linker, ACPI_GHES_DATA_ADDR_FW_CFG_FILE,
> +        0, sizeof(uint64_t), ACPI_GHES_ERRORS_FW_CFG_FILE, 0);
> +}
> diff --git a/hw/arm/virt-acpi-build.c b/hw/arm/virt-acpi-build.c
> index bd5f771..6819fcf 100644
> --- a/hw/arm/virt-acpi-build.c
> +++ b/hw/arm/virt-acpi-build.c
> @@ -48,6 +48,7 @@
>  #include "sysemu/reset.h"
>  #include "kvm_arm.h"
>  #include "migration/vmstate.h"
> +#include "hw/acpi/ghes.h"
>  
>  #define ARM_SPI_BASE 32
>  
> @@ -830,6 +831,11 @@ void virt_acpi_build(VirtMachineState *vms, AcpiBuildTables *tables)
>      acpi_add_table(table_offsets, tables_blob);
>      build_spcr(tables_blob, tables->linker, vms);
>  
> +    if (vms->ras) {
> +        acpi_add_table(table_offsets, tables_blob);
> +        build_ghes_error_table(tables->hardware_errors, tables->linker);
> +    }
> +
>      if (ms->numa_state->num_nodes > 0) {
>          acpi_add_table(table_offsets, tables_blob);
>          build_srat(tables_blob, tables->linker, vms);
> diff --git a/include/hw/acpi/aml-build.h b/include/hw/acpi/aml-build.h
> index de4a406..8f13620 100644
> --- a/include/hw/acpi/aml-build.h
> +++ b/include/hw/acpi/aml-build.h
> @@ -220,6 +220,7 @@ struct AcpiBuildTables {
>      GArray *rsdp;
>      GArray *tcpalog;
>      GArray *vmgenid;
> +    GArray *hardware_errors;
>      BIOSLinker *linker;
>  } AcpiBuildTables;
>  
> diff --git a/include/hw/acpi/ghes.h b/include/hw/acpi/ghes.h
> new file mode 100644
> index 0000000..3dbda3f
> --- /dev/null
> +++ b/include/hw/acpi/ghes.h
> @@ -0,0 +1,26 @@
> +/*
> + * Support for generating APEI tables and recording CPER for Guests
> + *
> + * Copyright (c) 2019 HUAWEI TECHNOLOGIES CO., LTD.
> + *
> + * Author: Dongjiu Geng <gengdongjiu@huawei.com>
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
> +#ifndef ACPI_GHES_H
> +#define ACPI_GHES_H
> +
> +void build_ghes_error_table(GArray *hardware_errors, BIOSLinker *linker);
> +#endif

