Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35041FD96E
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2019 10:38:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbfKOJiT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Nov 2019 04:38:19 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:34391 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726930AbfKOJiT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Nov 2019 04:38:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573810697;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tOW4/Si0jmvf7ZtuMPsof+skG06Yqb5gH8ZFAAY8YvE=;
        b=hTzAiKjsiT8gIC1stckqhoiegTPXEMlVAbLj0fIXQvBChZ1oELfg457mGZ5JopUtSWwXXS
        zrUP4g9/2Yv+VUu15HginNbBBxjBxOCmhsIDBRBVF3pGdbeXrESLY3pdpLVFWL50ODxEqK
        H516UP6tpb/JZSwZ+yAdOZpMpRhk3gE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-172-0zYVYf0-M9GzuVWeUwB2OQ-1; Fri, 15 Nov 2019 04:38:14 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0FA98801FA1;
        Fri, 15 Nov 2019 09:38:13 +0000 (UTC)
Received: from localhost (unknown [10.43.2.114])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 77E655ED2A;
        Fri, 15 Nov 2019 09:38:03 +0000 (UTC)
Date:   Fri, 15 Nov 2019 10:38:01 +0100
From:   Igor Mammedov <imammedo@redhat.com>
To:     Xiang Zheng <zhengxiang9@huawei.com>
Cc:     <pbonzini@redhat.com>, <mst@redhat.com>,
        <shannon.zhaosl@gmail.com>, <peter.maydell@linaro.org>,
        <lersek@redhat.com>, <james.morse@arm.com>,
        <gengdongjiu@huawei.com>, <mtosatti@redhat.com>, <rth@twiddle.net>,
        <ehabkost@redhat.com>, <jonathan.cameron@huawei.com>,
        <xuwei5@huawei.com>, <kvm@vger.kernel.org>,
        <qemu-devel@nongnu.org>, <qemu-arm@nongnu.org>,
        <linuxarm@huawei.com>, wanghaibin.wang@huawei.com
Subject: Re: [RESEND PATCH v21 3/6] ACPI: Add APEI GHES table generation
 support
Message-ID: <20191115103801.547fc84d@redhat.com>
In-Reply-To: <20191111014048.21296-4-zhengxiang9@huawei.com>
References: <20191111014048.21296-1-zhengxiang9@huawei.com>
        <20191111014048.21296-4-zhengxiang9@huawei.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: 0zYVYf0-M9GzuVWeUwB2OQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 11 Nov 2019 09:40:45 +0800
Xiang Zheng <zhengxiang9@huawei.com> wrote:

> From: Dongjiu Geng <gengdongjiu@huawei.com>
>=20
> This patch implements APEI GHES Table generation via fw_cfg blobs. Now
> it only supports ARMv8 SEA, a type of GHESv2 error source. Afterwards,
> we can extend the supported types if needed. For the CPER section,
> currently it is memory section because kernel mainly wants userspace to
> handle the memory errors.
>=20
> This patch follows the spec ACPI 6.2 to build the Hardware Error Source
> table. For more detailed information, please refer to document:
> docs/specs/acpi_hest_ghes.rst
>=20
> Suggested-by: Laszlo Ersek <lersek@redhat.com>
> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
> Signed-off-by: Xiang Zheng <zhengxiang9@huawei.com>
> Reviewed-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  default-configs/arm-softmmu.mak |   1 +
>  hw/acpi/Kconfig                 |   4 +
>  hw/acpi/Makefile.objs           |   1 +
>  hw/acpi/acpi_ghes.c             | 267 ++++++++++++++++++++++++++++++++
>  hw/acpi/aml-build.c             |   2 +
>  hw/arm/virt-acpi-build.c        |  12 ++
>  include/hw/acpi/acpi_ghes.h     |  56 +++++++
>  include/hw/acpi/aml-build.h     |   1 +
>  8 files changed, 344 insertions(+)
>  create mode 100644 hw/acpi/acpi_ghes.c
>  create mode 100644 include/hw/acpi/acpi_ghes.h
>=20
> diff --git a/default-configs/arm-softmmu.mak b/default-configs/arm-softmm=
u.mak
> index 1f2e0e7fde..5722f3130e 100644
> --- a/default-configs/arm-softmmu.mak
> +++ b/default-configs/arm-softmmu.mak
> @@ -40,3 +40,4 @@ CONFIG_FSL_IMX25=3Dy
>  CONFIG_FSL_IMX7=3Dy
>  CONFIG_FSL_IMX6UL=3Dy
>  CONFIG_SEMIHOSTING=3Dy
> +CONFIG_ACPI_APEI=3Dy
> diff --git a/hw/acpi/Kconfig b/hw/acpi/Kconfig
> index 12e3f1e86e..ed8c34d238 100644
> --- a/hw/acpi/Kconfig
> +++ b/hw/acpi/Kconfig
> @@ -23,6 +23,10 @@ config ACPI_NVDIMM
>      bool
>      depends on ACPI
> =20
> +config ACPI_APEI
> +    bool
> +    depends on ACPI
> +
>  config ACPI_PCI
>      bool
>      depends on ACPI && PCI
> diff --git a/hw/acpi/Makefile.objs b/hw/acpi/Makefile.objs
> index 655a9c1973..84474b0ca8 100644
> --- a/hw/acpi/Makefile.objs
> +++ b/hw/acpi/Makefile.objs
> @@ -5,6 +5,7 @@ common-obj-$(CONFIG_ACPI_CPU_HOTPLUG) +=3D cpu_hotplug.o
>  common-obj-$(CONFIG_ACPI_MEMORY_HOTPLUG) +=3D memory_hotplug.o
>  common-obj-$(CONFIG_ACPI_CPU_HOTPLUG) +=3D cpu.o
>  common-obj-$(CONFIG_ACPI_NVDIMM) +=3D nvdimm.o
> +common-obj-$(CONFIG_ACPI_APEI) +=3D acpi_ghes.o
>  common-obj-$(CONFIG_ACPI_VMGENID) +=3D vmgenid.o
>  common-obj-$(CONFIG_ACPI_HW_REDUCED) +=3D generic_event_device.o
>  common-obj-$(call lnot,$(CONFIG_ACPI_X86)) +=3D acpi-stub.o
> diff --git a/hw/acpi/acpi_ghes.c b/hw/acpi/acpi_ghes.c
> new file mode 100644
> index 0000000000..42c00ff3d3
> --- /dev/null
> +++ b/hw/acpi/acpi_ghes.c
> @@ -0,0 +1,267 @@
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
> + * You should have received a copy of the GNU General Public License alo=
ng
> + * with this program; if not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#include "qemu/osdep.h"
> +#include "hw/acpi/acpi.h"
> +#include "hw/acpi/aml-build.h"
> +#include "hw/acpi/acpi_ghes.h"
> +#include "hw/nvram/fw_cfg.h"
> +#include "sysemu/sysemu.h"
> +#include "qemu/error-report.h"
> +
> +#define ACPI_GHES_ERRORS_FW_CFG_FILE        "etc/hardware_errors"
> +#define ACPI_GHES_DATA_ADDR_FW_CFG_FILE     "etc/hardware_errors_addr"
> +
> +/*
> + * The size of Address field in Generic Address Structure.
> + * ACPI 2.0/3.0: 5.2.3.1 Generic Address Structure.
> + */
> +#define ACPI_GHES_ADDRESS_SIZE              8
there is not such thing as GHES_ADDRESS_SIZE.

I'd just use sizeof(unit64_t), shorter and obvious value
when seen at a call site

> +
> +/* The max size in bytes for one error block */
> +#define ACPI_GHES_MAX_RAW_DATA_LENGTH       0x1000
> +
> +/*
> + * Now only support ARMv8 SEA notification type error source
> + */
maybe one line comment

> +#define ACPI_GHES_ERROR_SOURCE_COUNT        1
> +
> +/*
> + * Generic Hardware Error Source version 2
> + */
ditto

> +#define ACPI_GHES_SOURCE_GENERIC_ERROR_V2   10


> +
> +/*
> + * | +--------------------------+ 0
> + * | |        Header            |
> + * | +--------------------------+ 40---+-
> + * | | .................        |      |
> + * | | error_status_address-----+ 60   |
> + * | | .................        |      |
> + * | | read_ack_register--------+ 104  92
> + * | | read_ack_preserve        |      |
> + * | | read_ack_write           |      |
> + * + +--------------------------+ 132--+-
> + *
> + * From above GHES definition, the error status address offset is 60;
> + * the Read Ack Register offset is 104, the whole size of GHESv2 is 92
> + */
> +
> +/* The error status address offset in GHES */
> +#define ACPI_GHES_ERROR_STATUS_ADDRESS_OFFSET(start_addr, n) (start_addr=
 + \
> +            60 + offsetof(struct AcpiGenericAddress, address) + n * 92)
> +
> +/* The Read Ack Register offset in GHES */
> +#define ACPI_GHES_READ_ACK_REGISTER_ADDRESS_OFFSET(start_addr, n) (start=
_addr +\
> +            104 + offsetof(struct AcpiGenericAddress, address) + n * 92)
drop this hunk, see below why

> +
> +typedef struct AcpiGhesState {
> +    uint64_t ghes_addr_le;
> +} AcpiGhesState;
> +
> +/*
> + * Hardware Error Notification
> + * ACPI 4.0: 17.3.2.7 Hardware Error Notification

add/
composes dummy Hardware Error Notification descriptor of specified type

> + */
> +static void acpi_ghes_build_notify(GArray *table, const uint8_t type)

typically format should be build_WHAT(), so
 build_ghes_hw_error_notification()

And I'd move this out into its own patch.
this applies to other trivial in-depended sub-tables,
that take all data needed to construct them from supplied arguments.

> +{
> +        /* Type */
> +        build_append_int_noprefix(table, type, 1);
> +        /*
> +         * Length:
> +         * Total length of the structure in bytes
> +         */
> +        build_append_int_noprefix(table, 28, 1);
> +        /* Configuration Write Enable */
> +        build_append_int_noprefix(table, 0, 2);
> +        /* Poll Interval */
> +        build_append_int_noprefix(table, 0, 4);
> +        /* Vector */
> +        build_append_int_noprefix(table, 0, 4);
> +        /* Switch To Polling Threshold Value */
> +        build_append_int_noprefix(table, 0, 4);
> +        /* Switch To Polling Threshold Window */
> +        build_append_int_noprefix(table, 0, 4);
> +        /* Error Threshold Value */
> +        build_append_int_noprefix(table, 0, 4);
> +        /* Error Threshold Window */
> +        build_append_int_noprefix(table, 0, 4);
> +}
> +

/*
  Initialize "etc/hardware_errors" and "etc/hardware_errors_addr" fwcfg blo=
bs.
  See docs/specs/acpi_hest_ghes.rst for blobs format
*/
> +void acpi_ghes_build_error_table(GArray *hardware_errors, BIOSLinker *li=
nker)
build_ghes_error_table()

also I'd move this function into its own patch along with other
related code that initializes and wires it into virt board.

> +{
> +    int i, error_status_block_offset;
> +
> +    /*
> +     * | +--------------------------+
> +     * | |    error_block_address   |
> +     * | |      ..........          |
> +     * | +--------------------------+
> +     * | |    read_ack_register     |
> +     * | |     ...........          |
> +     * | +--------------------------+
> +     * | |  Error Status Data Block |
> +     * | |      ........            |
> +     * | +--------------------------+
> +     */
I'd drop this comment, acpi_hest_ghes.rst should be sufficient,
if it's not then fix spec. For example it's not obvious from spec
that "Error Status Data Block" immediately follows 'read_ack_register'

> +
> +    /* Build error_block_address */
> +    for (i =3D 0; i < ACPI_GHES_ERROR_SOURCE_COUNT; i++) {
> +        build_append_int_noprefix(hardware_errors, 0, ACPI_GHES_ADDRESS_=
SIZE);
> +    }
> +
> +    /* Build read_ack_register */
> +    for (i =3D 0; i < ACPI_GHES_ERROR_SOURCE_COUNT; i++) {
> +        /*
> +         * Initialize the value of read_ack_register to 1, so GHES can b=
e
> +         * writeable in the first time.
s/in the first time/after (re)boot/

> +         * ACPI 6.2: 18.3.2.8 Generic Hardware Error Source version 2
> +         * (GHESv2 - Type 10)
> +         */
> +        build_append_int_noprefix(hardware_errors, 1, ACPI_GHES_ADDRESS_=
SIZE);
> +    }
> +
> +    /* Generic Error Status Block offset in the hardware error fw_cfg bl=
ob */
> +    error_status_block_offset =3D hardware_errors->len;
> +
> +    /* Build Error Status Data Block */

/* reserve space for Error Status Data Block */

> +    build_append_int_noprefix(hardware_errors, 0,
> +        ACPI_GHES_MAX_RAW_DATA_LENGTH * ACPI_GHES_ERROR_SOURCE_COUNT);
this function is for integers only, if you just need to reserve space
you can use acpi_data_push().

> +
> +    /* Allocate guest memory for the hardware error fw_cfg blob */
/* tell guest firmware to place hardware_errors blob into RAM */

> +    bios_linker_loader_alloc(linker, ACPI_GHES_ERRORS_FW_CFG_FILE,
> +                             hardware_errors, 1, false);
> +
> +    for (i =3D 0; i < ACPI_GHES_ERROR_SOURCE_COUNT; i++) {
> +        /*
> +         * Patch the address of Error Status Data Block into
> +         * the error_block_address of hardware_errors fw_cfg blob
 Tell firmware to patch error_block_address entries to point to
 corresponding "Error Status Data Block"

> +         */
> +        bios_linker_loader_add_pointer(linker,
> +            ACPI_GHES_ERRORS_FW_CFG_FILE, ACPI_GHES_ADDRESS_SIZE * i,
> +            ACPI_GHES_ADDRESS_SIZE, ACPI_GHES_ERRORS_FW_CFG_FILE,
> +            error_status_block_offset + i * ACPI_GHES_MAX_RAW_DATA_LENGT=
H);
> +    }
> +
> +    /*
> +     * Write the address of hardware_errors blob into the
> +     * hardware_errors_addr fw_cfg blob.
/*
tell firmware to write hardware_errors GPA into hardware_errors_addr fw_cfg=
,
once the former has been initialized.
*/

> +     */
> +    bios_linker_loader_write_pointer(linker, ACPI_GHES_DATA_ADDR_FW_CFG_=
FILE,
> +        0, ACPI_GHES_ADDRESS_SIZE, ACPI_GHES_ERRORS_FW_CFG_FILE, 0);
> +}
> +
> +/* Build Hardware Error Source Table */
> +void acpi_ghes_build_hest(GArray *table_data, GArray *hardware_errors,
> +                          BIOSLinker *linker)
it's not GEST specific table, so
  build_hest()

> +{
> +    uint32_t hest_start =3D table_data->len;
> +    uint32_t source_id =3D 0;
> +
> +    /* Hardware Error Source Table header*/
> +    acpi_data_push(table_data, sizeof(AcpiTableHeader));
> +
> +    /* Error Source Count */
> +    build_append_int_noprefix(table_data, ACPI_GHES_ERROR_SOURCE_COUNT, =
4);
> +

this is the place where all error source structures will be enumerated.
I'd move out GHESv2 specific coed into a separate function so that code her=
e
would look like this

    build_ghes_v2(...);
   =20
   =20
  =20
> +    /*
> +     * Type:
> +     * Generic Hardware Error Source version 2(GHESv2 - Type 10)
> +     */
> +    build_append_int_noprefix(table_data, ACPI_GHES_SOURCE_GENERIC_ERROR=
_V2, 2);
> +    /*
> +     * Source Id

> +     * Once we support more than one hardware error sources, we need to
> +     * increase the value of this field.
I'm not sure ^^^ is correct, according to spec it's just unique id per
distinct error structure, so we just assign arbitrary values to each
declared source and that never changes once assigned.

For now I'd make source_id an enum with one member
  enum {
    ACPI_HEST_SRC_ID_SEA =3D 0,
    /* future ids go here */
    ACPI_HEST_SRC_ID_RESERVED,
  }

and use that instead of allocating magic 0 at the beginning of the function=
.
 build_ghes_v2(ACPI_HEST_GHES_SEA);
Also add a comment to declaration that already assigned values are not to b=
e changed

> +     */
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
> +    build_append_int_noprefix(table_data, ACPI_GHES_MAX_RAW_DATA_LENGTH,=
 4);
> +
> +    /* Error Status Address */
> +    build_append_gas(table_data, AML_AS_SYSTEM_MEMORY, 0x40, 0,
> +                     4 /* QWord access */, 0);
> +    bios_linker_loader_add_pointer(linker, ACPI_BUILD_TABLE_FILE,
> +        ACPI_GHES_ERROR_STATUS_ADDRESS_OFFSET(hest_start, source_id),
it's fine only if GHESv2 is the only entries in HEST, but once
other types are added this macro will silently fall apart and
cause table corruption.

Instead of offset from hest_start, I suggest to use offset relative
to GAS structure, here is an idea

#define GAS_ADDR_OFFSET 4

    off =3D table->len
    build_append_gas()
    bios_linker_loader_add_pointer(...,
        off + GAS_ADDR_OFFSET, ...

> +        ACPI_GHES_ADDRESS_SIZE, ACPI_GHES_ERRORS_FW_CFG_FILE,
> +        source_id * ACPI_GHES_ADDRESS_SIZE);
> +
> +    /*
> +     * Notification Structure
> +     * Now only enable ARMv8 SEA notification type
> +     */
> +    acpi_ghes_build_notify(table_data, ACPI_GHES_NOTIFY_SEA);
> +
> +    /* Error Status Block Length */
> +    build_append_int_noprefix(table_data, ACPI_GHES_MAX_RAW_DATA_LENGTH,=
 4);
> +
> +    /*
> +     * Read Ack Register
> +     * ACPI 6.1: 18.3.2.8 Generic Hardware Error Source
> +     * version 2 (GHESv2 - Type 10)
> +     */
> +    build_append_gas(table_data, AML_AS_SYSTEM_MEMORY, 0x40, 0,
> +                     4 /* QWord access */, 0);
> +    bios_linker_loader_add_pointer(linker, ACPI_BUILD_TABLE_FILE,
> +        ACPI_GHES_READ_ACK_REGISTER_ADDRESS_OFFSET(hest_start, 0),
ditto

> +        ACPI_GHES_ADDRESS_SIZE, ACPI_GHES_ERRORS_FW_CFG_FILE,
> +        (ACPI_GHES_ERROR_SOURCE_COUNT + source_id) * ACPI_GHES_ADDRESS_S=
IZE);
> +
> +    /*
> +     * Read Ack Preserve
> +     * We only provide the first bit in Read Ack Register to OSPM to wri=
te
> +     * while the other bits are preserved.
> +     */
> +    build_append_int_noprefix(table_data, ~0x1ULL, 8);
> +    /* Read Ack Write */
> +    build_append_int_noprefix(table_data, 0x1, 8);
> +
> +    build_header(linker, table_data, (void *)(table_data->data + hest_st=
art),
> +        "HEST", table_data->len - hest_start, 1, NULL, "GHES");
hest is not GHEST specific so s/GHES/NULL/
                                                        =20
> +}
> +
> +static AcpiGhesState ges;
> +void acpi_ghes_add_fw_cfg(FWCfgState *s, GArray *hardware_error)
> +{
> +
> +    size_t size =3D 2 * ACPI_GHES_ADDRESS_SIZE + ACPI_GHES_MAX_RAW_DATA_=
LENGTH;
> +    size_t request_block_size =3D ACPI_GHES_ERROR_SOURCE_COUNT * size;
> +

> +    /* Create a read-only fw_cfg file for GHES */
> +    fw_cfg_add_file(s, ACPI_GHES_ERRORS_FW_CFG_FILE, hardware_error->dat=
a,
> +                    request_block_size);
> +
> +    /* Create a read-write fw_cfg file for Address */
> +    fw_cfg_add_file_callback(s, ACPI_GHES_DATA_ADDR_FW_CFG_FILE, NULL, N=
ULL,
> +        NULL, &ges.ghes_addr_le, sizeof(ges.ghes_addr_le), false);
> +}
> diff --git a/hw/acpi/aml-build.c b/hw/acpi/aml-build.c
> index 2c3702b882..3681ec6e3d 100644
> --- a/hw/acpi/aml-build.c
> +++ b/hw/acpi/aml-build.c
> @@ -1578,6 +1578,7 @@ void acpi_build_tables_init(AcpiBuildTables *tables=
)
>      tables->table_data =3D g_array_new(false, true /* clear */, 1);
>      tables->tcpalog =3D g_array_new(false, true /* clear */, 1);
>      tables->vmgenid =3D g_array_new(false, true /* clear */, 1);
> +    tables->hardware_errors =3D g_array_new(false, true /* clear */, 1);
>      tables->linker =3D bios_linker_loader_init();
>  }
> =20
> @@ -1588,6 +1589,7 @@ void acpi_build_tables_cleanup(AcpiBuildTables *tab=
les, bool mfre)
>      g_array_free(tables->table_data, true);
>      g_array_free(tables->tcpalog, mfre);
>      g_array_free(tables->vmgenid, mfre);
> +    g_array_free(tables->hardware_errors, mfre);
>  }
> =20
>  /*
> diff --git a/hw/arm/virt-acpi-build.c b/hw/arm/virt-acpi-build.c
> index 4cd50175e0..1b1fd273e4 100644
> --- a/hw/arm/virt-acpi-build.c
> +++ b/hw/arm/virt-acpi-build.c
> @@ -48,6 +48,7 @@
>  #include "sysemu/reset.h"
>  #include "kvm_arm.h"
>  #include "migration/vmstate.h"
> +#include "hw/acpi/acpi_ghes.h"
> =20
>  #define ARM_SPI_BASE 32
> =20
> @@ -825,6 +826,13 @@ void virt_acpi_build(VirtMachineState *vms, AcpiBuil=
dTables *tables)
>      acpi_add_table(table_offsets, tables_blob);
>      build_spcr(tables_blob, tables->linker, vms);
> =20
> +    if (vms->ras) {
> +        acpi_add_table(table_offsets, tables_blob);
> +        acpi_ghes_build_error_table(tables->hardware_errors, tables->lin=
ker);
> +        acpi_ghes_build_hest(tables_blob, tables->hardware_errors,
> +                             tables->linker);
> +    }
> +
>      if (ms->numa_state->num_nodes > 0) {
>          acpi_add_table(table_offsets, tables_blob);
>          build_srat(tables_blob, tables->linker, vms);
> @@ -942,6 +950,10 @@ void virt_acpi_setup(VirtMachineState *vms)
>      fw_cfg_add_file(vms->fw_cfg, ACPI_BUILD_TPMLOG_FILE, tables.tcpalog-=
>data,
>                      acpi_data_len(tables.tcpalog));
> =20
> +    if (vms->ras) {
> +        acpi_ghes_add_fw_cfg(vms->fw_cfg, tables.hardware_errors);
> +    }
> +
>      build_state->rsdp_mr =3D acpi_add_rom_blob(virt_acpi_build_update,
>                                               build_state, tables.rsdp,
>                                               ACPI_BUILD_RSDP_FILE, 0);
> diff --git a/include/hw/acpi/acpi_ghes.h b/include/hw/acpi/acpi_ghes.h
> new file mode 100644
> index 0000000000..cb62ec9c7b
> --- /dev/null
> +++ b/include/hw/acpi/acpi_ghes.h
> @@ -0,0 +1,56 @@
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
> + * You should have received a copy of the GNU General Public License alo=
ng
> + * with this program; if not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#ifndef ACPI_GHES_H
> +#define ACPI_GHES_H
> +
> +#include "hw/acpi/bios-linker-loader.h"
> +
> +/*
> + * Values for Hardware Error Notification Type field
> + */
> +enum AcpiGhesNotifyType {
> +    ACPI_GHES_NOTIFY_POLLED =3D 0,    /* Polled */
> +    ACPI_GHES_NOTIFY_EXTERNAL =3D 1,  /* External Interrupt */
> +    ACPI_GHES_NOTIFY_LOCAL =3D 2, /* Local Interrupt */
> +    ACPI_GHES_NOTIFY_SCI =3D 3,   /* SCI */
> +    ACPI_GHES_NOTIFY_NMI =3D 4,   /* NMI */
> +    ACPI_GHES_NOTIFY_CMCI =3D 5,  /* CMCI, ACPI 5.0: 18.3.2.7, Table 18-=
290 */
> +    ACPI_GHES_NOTIFY_MCE =3D 6,   /* MCE, ACPI 5.0: 18.3.2.7, Table 18-2=
90 */
> +    /* GPIO-Signal, ACPI 6.0: 18.3.2.7, Table 18-332 */
> +    ACPI_GHES_NOTIFY_GPIO =3D 7,
> +    /* ARMv8 SEA, ACPI 6.1: 18.3.2.9, Table 18-345 */
> +    ACPI_GHES_NOTIFY_SEA =3D 8,
> +    /* ARMv8 SEI, ACPI 6.1: 18.3.2.9, Table 18-345 */
> +    ACPI_GHES_NOTIFY_SEI =3D 9,
> +    /* External Interrupt - GSIV, ACPI 6.1: 18.3.2.9, Table 18-345 */
> +    ACPI_GHES_NOTIFY_GSIV =3D 10,
> +    /* Software Delegated Exception, ACPI 6.2: 18.3.2.9, Table 18-383 */
> +    ACPI_GHES_NOTIFY_SDEI =3D 11,
> +    ACPI_GHES_NOTIFY_RESERVED =3D 12 /* 12 and greater are reserved */
> +};
maybe make all comment go on newline, otherwise zoo above look ugly
=20
> +
> +void acpi_ghes_build_hest(GArray *table_data, GArray *hardware_error,
> +                          BIOSLinker *linker);
> +
> +void acpi_ghes_build_error_table(GArray *hardware_errors, BIOSLinker *li=
nker);
> +void acpi_ghes_add_fw_cfg(FWCfgState *s, GArray *hardware_errors);
> +#endif
> diff --git a/include/hw/acpi/aml-build.h b/include/hw/acpi/aml-build.h
> index de4a406568..8f13620701 100644
> --- a/include/hw/acpi/aml-build.h
> +++ b/include/hw/acpi/aml-build.h
> @@ -220,6 +220,7 @@ struct AcpiBuildTables {
>      GArray *rsdp;
>      GArray *tcpalog;
>      GArray *vmgenid;
> +    GArray *hardware_errors;
>      BIOSLinker *linker;
>  } AcpiBuildTables;
> =20

