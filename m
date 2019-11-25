Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22AA9108ABD
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2019 10:23:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727182AbfKYJXo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Nov 2019 04:23:44 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:60717 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726118AbfKYJXn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Nov 2019 04:23:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574673823;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HgbMH1JLqmE+gc7GZe7uPNlw3bty4GEf8kkmyAbc6us=;
        b=Uxwbf2m0PvXJwWLqmFhZMDV4WVj3iOfY7nImn2AvrjwV6tOdVAwZ3Kk2trxMcPsL4KSQVX
        pN7LmvIee34XUa8QH65w7dEcIqG9OqA0s8dFhyPqZCAOYCOutN1+d/4OZvo82rij94UWh9
        MBwYQBdQkny6iwvnR8n3bGjX63OUOJ4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-387-KScnyE1ZOsmi2pkiMoT3EQ-1; Mon, 25 Nov 2019 04:23:41 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A3518801E63;
        Mon, 25 Nov 2019 09:23:39 +0000 (UTC)
Received: from localhost (unknown [10.43.2.114])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EC3FF600C6;
        Mon, 25 Nov 2019 09:23:32 +0000 (UTC)
Date:   Mon, 25 Nov 2019 10:23:31 +0100
From:   Igor Mammedov <imammedo@redhat.com>
To:     Beata Michalska <beata.michalska@linaro.org>
Cc:     Xiang Zheng <zhengxiang9@huawei.com>, pbonzini@redhat.com,
        mst@redhat.com, shannon.zhaosl@gmail.com,
        Peter Maydell <peter.maydell@linaro.org>,
        Laszlo Ersek <lersek@redhat.com>, james.morse@arm.com,
        gengdongjiu@huawei.com, mtosatti@redhat.com, rth@twiddle.net,
        ehabkost@redhat.com, jonathan.cameron@huawei.com,
        xuwei5@huawei.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        qemu-arm@nongnu.org, linuxarm@huawei.com,
        wanghaibin.wang@huawei.com
Subject: Re: [RESEND PATCH v21 3/6] ACPI: Add APEI GHES table generation
 support
Message-ID: <20191125102331.51af069a@redhat.com>
In-Reply-To: <CADSWDztOKT6jZ4FmCkt8jmZH6TiMQ_yrW6AoEnGB=Rg-oWRdBg@mail.gmail.com>
References: <20191111014048.21296-1-zhengxiang9@huawei.com>
        <20191111014048.21296-4-zhengxiang9@huawei.com>
        <CADSWDztOKT6jZ4FmCkt8jmZH6TiMQ_yrW6AoEnGB=Rg-oWRdBg@mail.gmail.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: KScnyE1ZOsmi2pkiMoT3EQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 22 Nov 2019 15:42:52 +0000
Beata Michalska <beata.michalska@linaro.org> wrote:

> Hi Xiang,
> 
> On Mon, 11 Nov 2019 at 01:48, Xiang Zheng <zhengxiang9@huawei.com> wrote:
> >
> > From: Dongjiu Geng <gengdongjiu@huawei.com>
> >
> > This patch implements APEI GHES Table generation via fw_cfg blobs. Now
> > it only supports ARMv8 SEA, a type of GHESv2 error source. Afterwards,
> > we can extend the supported types if needed. For the CPER section,
> > currently it is memory section because kernel mainly wants userspace to
> > handle the memory errors.
> >
> > This patch follows the spec ACPI 6.2 to build the Hardware Error Source
> > table. For more detailed information, please refer to document:
> > docs/specs/acpi_hest_ghes.rst
> >
> > Suggested-by: Laszlo Ersek <lersek@redhat.com>
> > Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
> > Signed-off-by: Xiang Zheng <zhengxiang9@huawei.com>
> > Reviewed-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> >  default-configs/arm-softmmu.mak |   1 +
> >  hw/acpi/Kconfig                 |   4 +
> >  hw/acpi/Makefile.objs           |   1 +
> >  hw/acpi/acpi_ghes.c             | 267 ++++++++++++++++++++++++++++++++
> >  hw/acpi/aml-build.c             |   2 +
> >  hw/arm/virt-acpi-build.c        |  12 ++
> >  include/hw/acpi/acpi_ghes.h     |  56 +++++++
> >  include/hw/acpi/aml-build.h     |   1 +
> >  8 files changed, 344 insertions(+)
> >  create mode 100644 hw/acpi/acpi_ghes.c
> >  create mode 100644 include/hw/acpi/acpi_ghes.h
> >
> > diff --git a/default-configs/arm-softmmu.mak b/default-configs/arm-softmmu.mak
> > index 1f2e0e7fde..5722f3130e 100644
> > --- a/default-configs/arm-softmmu.mak
> > +++ b/default-configs/arm-softmmu.mak
> > @@ -40,3 +40,4 @@ CONFIG_FSL_IMX25=y
> >  CONFIG_FSL_IMX7=y
> >  CONFIG_FSL_IMX6UL=y
> >  CONFIG_SEMIHOSTING=y
> > +CONFIG_ACPI_APEI=y
> > diff --git a/hw/acpi/Kconfig b/hw/acpi/Kconfig
> > index 12e3f1e86e..ed8c34d238 100644
> > --- a/hw/acpi/Kconfig
> > +++ b/hw/acpi/Kconfig
> > @@ -23,6 +23,10 @@ config ACPI_NVDIMM
> >      bool
> >      depends on ACPI
> >
> > +config ACPI_APEI
> > +    bool
> > +    depends on ACPI
> > +
> >  config ACPI_PCI
> >      bool
> >      depends on ACPI && PCI
> > diff --git a/hw/acpi/Makefile.objs b/hw/acpi/Makefile.objs
> > index 655a9c1973..84474b0ca8 100644
> > --- a/hw/acpi/Makefile.objs
> > +++ b/hw/acpi/Makefile.objs
> > @@ -5,6 +5,7 @@ common-obj-$(CONFIG_ACPI_CPU_HOTPLUG) += cpu_hotplug.o
> >  common-obj-$(CONFIG_ACPI_MEMORY_HOTPLUG) += memory_hotplug.o
> >  common-obj-$(CONFIG_ACPI_CPU_HOTPLUG) += cpu.o
> >  common-obj-$(CONFIG_ACPI_NVDIMM) += nvdimm.o
> > +common-obj-$(CONFIG_ACPI_APEI) += acpi_ghes.o  
> 
> Minor: The 'acpi' prefix could be dropped - it does not seem to be used
> for other files (self impliend by the dir name).
> This also applies to most of the naming within this patch
> 
> >  common-obj-$(CONFIG_ACPI_VMGENID) += vmgenid.o
> >  common-obj-$(CONFIG_ACPI_HW_REDUCED) += generic_event_device.o
> >  common-obj-$(call lnot,$(CONFIG_ACPI_X86)) += acpi-stub.o
> > diff --git a/hw/acpi/acpi_ghes.c b/hw/acpi/acpi_ghes.c
> > new file mode 100644
> > index 0000000000..42c00ff3d3
> > --- /dev/null
> > +++ b/hw/acpi/acpi_ghes.c
> > @@ -0,0 +1,267 @@
> > +/*
> > + * Support for generating APEI tables and recording CPER for Guests
> > + *
> > + * Copyright (c) 2019 HUAWEI TECHNOLOGIES CO., LTD.
> > + *
> > + * Author: Dongjiu Geng <gengdongjiu@huawei.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation; either version 2 of the License, or
> > + * (at your option) any later version.
> > +
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > +
> > + * You should have received a copy of the GNU General Public License along
> > + * with this program; if not, see <http://www.gnu.org/licenses/>.
> > + */
> > +
> > +#include "qemu/osdep.h"
> > +#include "hw/acpi/acpi.h"
> > +#include "hw/acpi/aml-build.h"
> > +#include "hw/acpi/acpi_ghes.h"
> > +#include "hw/nvram/fw_cfg.h"
> > +#include "sysemu/sysemu.h"
> > +#include "qemu/error-report.h"
> > +
> > +#define ACPI_GHES_ERRORS_FW_CFG_FILE        "etc/hardware_errors"
> > +#define ACPI_GHES_DATA_ADDR_FW_CFG_FILE     "etc/hardware_errors_addr"
> > +
> > +/*
> > + * The size of Address field in Generic Address Structure.
> > + * ACPI 2.0/3.0: 5.2.3.1 Generic Address Structure.
> > + */
> > +#define ACPI_GHES_ADDRESS_SIZE              8
> > +  
> As already mentioned, you can safely drop this and use sizeof(unit64_t).
> 
> > +/* The max size in bytes for one error block */
> > +#define ACPI_GHES_MAX_RAW_DATA_LENGTH       0x1000
> > +
> > +/*
> > + * Now only support ARMv8 SEA notification type error source
> > + */
> > +#define ACPI_GHES_ERROR_SOURCE_COUNT        1
> > +
> > +/*
> > + * Generic Hardware Error Source version 2
> > + */
> > +#define ACPI_GHES_SOURCE_GENERIC_ERROR_V2   10  
> 
> Minor: this is actually a type so would be good if the name would
> reflect that somehow......
> 
> > +
> > +/*
> > + * | +--------------------------+ 0
> > + * | |        Header            |
> > + * | +--------------------------+ 40---+-
> > + * | | .................        |      |
> > + * | | error_status_address-----+ 60   |
> > + * | | .................        |      |
> > + * | | read_ack_register--------+ 104  92
> > + * | | read_ack_preserve        |      |
> > + * | | read_ack_write           |      |
> > + * + +--------------------------+ 132--+-
> > + *
> > + * From above GHES definition, the error status address offset is 60;
> > + * the Read Ack Register offset is 104, the whole size of GHESv2 is 92
> > + */
> > +  
> This could potentially land into the doc instead.
> Also the GHEST is actually part of HEST so your offsets are for
> HEST not GHEST itself so the comment might be slightly misleading
> 
> > +/* The error status address offset in GHES */
> > +#define ACPI_GHES_ERROR_STATUS_ADDRESS_OFFSET(start_addr, n) (start_addr + \
> > +            60 + offsetof(struct AcpiGenericAddress, address) + n * 92)
> > +
> > +/* The Read Ack Register offset in GHES */
> > +#define ACPI_GHES_READ_ACK_REGISTER_ADDRESS_OFFSET(start_addr, n) (start_addr +\
> > +            104 + offsetof(struct AcpiGenericAddress, address) + n * 92)
> > +
> > +typedef struct AcpiGhesState {
> > +    uint64_t ghes_addr_le;
> > +} AcpiGhesState;
> > +  
> Minor: Why AcpiGhes*State* ? And do we need the struct to track single address?
> 
> > +/*
> > + * Hardware Error Notification
> > + * ACPI 4.0: 17.3.2.7 Hardware Error Notification
> > + */  
> You are referencing older spec here. The commit message states
> 6.2 version. Not to mention that 4.0 did not support ARMv8 SEA source.
> You should not mention sections that do not correspond to the spec
> the patch is based on.

normally we use the spec where structure appeared first,
and use later one only when there is no other choice
(i.e. work uses/implement fields that weren't in the original structure revision)


> 
> > +static void acpi_ghes_build_notify(GArray *table, const uint8_t type)  
> 
> As it has already been mentioned - the naming here could follow the existing
> convention. Also this function is creating Hardware Error Notification table
> which is not necessarily tightly connected to GHES
> Similarly this applies to the overall naming used within this patch.
> > +{
> > +        /* Type */
> > +        build_append_int_noprefix(table, type, 1);
> > +        /*
> > +         * Length:
> > +         * Total length of the structure in bytes
> > +         */
> > +        build_append_int_noprefix(table, 28, 1);
> > +        /* Configuration Write Enable */
> > +        build_append_int_noprefix(table, 0, 2);
> > +        /* Poll Interval */
> > +        build_append_int_noprefix(table, 0, 4);
> > +        /* Vector */
> > +        build_append_int_noprefix(table, 0, 4);
> > +        /* Switch To Polling Threshold Value */
> > +        build_append_int_noprefix(table, 0, 4);
> > +        /* Switch To Polling Threshold Window */
> > +        build_append_int_noprefix(table, 0, 4);
> > +        /* Error Threshold Value */
> > +        build_append_int_noprefix(table, 0, 4);
> > +        /* Error Threshold Window */
> > +        build_append_int_noprefix(table, 0, 4);  
> 
> Most of  those fields are being set to the same single value.
> Why not covering it all in one go ?


that's intentional.
yep it takes more lines to code but it also makes comparing
code against spec much easier as it practically matches table
in the spec line by line.

> > +}
> > +
> > +/* Build table for the hardware error fw_cfg blob */
> > +void acpi_ghes_build_error_table(GArray *hardware_errors, BIOSLinker *linker)
> > +{
> > +    int i, error_status_block_offset;
> > +
> > +    /*
> > +     * | +--------------------------+
> > +     * | |    error_block_address   |
> > +     * | |      ..........          |
> > +     * | +--------------------------+
> > +     * | |    read_ack_register     |
> > +     * | |     ...........          |
> > +     * | +--------------------------+
> > +     * | |  Error Status Data Block |
> > +     * | |      ........            |
> > +     * | +--------------------------+
> > +     */
> > +
> > +    /* Build error_block_address */
> > +    for (i = 0; i < ACPI_GHES_ERROR_SOURCE_COUNT; i++) {
> > +        build_append_int_noprefix(hardware_errors, 0, ACPI_GHES_ADDRESS_SIZE);
> > +    }
> > +
> > +    /* Build read_ack_register */
> > +    for (i = 0; i < ACPI_GHES_ERROR_SOURCE_COUNT; i++) {
> > +        /*
> > +         * Initialize the value of read_ack_register to 1, so GHES can be
> > +         * writeable in the first time.
> > +         * ACPI 6.2: 18.3.2.8 Generic Hardware Error Source version 2
> > +         * (GHESv2 - Type 10)
> > +         */
> > +        build_append_int_noprefix(hardware_errors, 1, ACPI_GHES_ADDRESS_SIZE);  
> This is a bit of a simplification (justified to some extent) but this
> should take into
> account both Read Ack Preserve and Read Ack Write masks.....
> or having at least a comment would be good
> 
> Also the above implies support only for GHESTv2 (the 'Ack' regs are GHESv2
> specific) still this is iterating over potentially available/supported
> hw error sources
> At this point it is ok but if the support gets extended this will not
> be valid - managing
> 'Ack' regs should be properly guarded for GHESv2 ..

It ok for code to be more complicated so it would be able to handle
other usecases in the future.
But if there aren't actual plans to add other usecases, then it's just
over-engineering which might mislead reader later on to trying
figure out what's going on here.
(modulo the case where we are defining ABI between guest and QEMU)

So I'd rather simplify code if there aren't plans to extend it,
and let someone else to generalize it when there is an actual need for it.

> 
> > +    }
> > +
> > +    /* Generic Error Status Block offset in the hardware error fw_cfg blob */
> > +    error_status_block_offset = hardware_errors->len;
> > +
> > +    /* Build Error Status Data Block */
> > +    build_append_int_noprefix(hardware_errors, 0,
> > +        ACPI_GHES_MAX_RAW_DATA_LENGTH * ACPI_GHES_ERROR_SOURCE_COUNT);
> > +
> > +    /* Allocate guest memory for the hardware error fw_cfg blob */
> > +    bios_linker_loader_alloc(linker, ACPI_GHES_ERRORS_FW_CFG_FILE,
> > +                             hardware_errors, 1, false);
> > +
> > +    for (i = 0; i < ACPI_GHES_ERROR_SOURCE_COUNT; i++) {
> > +        /*
> > +         * Patch the address of Error Status Data Block into
> > +         * the error_block_address of hardware_errors fw_cfg blob
> > +         */
> > +        bios_linker_loader_add_pointer(linker,
> > +            ACPI_GHES_ERRORS_FW_CFG_FILE, ACPI_GHES_ADDRESS_SIZE * i,
> > +            ACPI_GHES_ADDRESS_SIZE, ACPI_GHES_ERRORS_FW_CFG_FILE,
> > +            error_status_block_offset + i * ACPI_GHES_MAX_RAW_DATA_LENGTH);
> > +    }
> > +
> > +    /*
> > +     * Write the address of hardware_errors fw_cfg blob into the
> > +     * hardware_errors_addr fw_cfg blob.
> > +     */
> > +    bios_linker_loader_write_pointer(linker, ACPI_GHES_DATA_ADDR_FW_CFG_FILE,
> > +        0, ACPI_GHES_ADDRESS_SIZE, ACPI_GHES_ERRORS_FW_CFG_FILE, 0);
> > +}
> > +
> > +/* Build Hardware Error Source Table */
> > +void acpi_ghes_build_hest(GArray *table_data, GArray *hardware_errors,
> > +                          BIOSLinker *linker)
> > +{
> > +    uint32_t hest_start = table_data->len;
> > +    uint32_t source_id = 0;
> > +
> > +    /* Hardware Error Source Table header*/
> > +    acpi_data_push(table_data, sizeof(AcpiTableHeader));
> > +
> > +    /* Error Source Count */
> > +    build_append_int_noprefix(table_data, ACPI_GHES_ERROR_SOURCE_COUNT, 4);
> > +
> > +    /*
> > +     * Type:
> > +     * Generic Hardware Error Source version 2(GHESv2 - Type 10)
> > +     */
> > +    build_append_int_noprefix(table_data, ACPI_GHES_SOURCE_GENERIC_ERROR_V2, 2);
> > +    /*
> > +     * Source Id
> > +     * Once we support more than one hardware error sources, we need to
> > +     * increase the value of this field.
> > +     */
> > +    build_append_int_noprefix(table_data, source_id, 2);
> > +    /* Related Source Id */
> > +    build_append_int_noprefix(table_data, 0xffff, 2);  
> 
> Would be nice to have a comment on the value used ->
> 'no alternate sources'

usually we use verbaltim field name as in the spec table definition.
This way reader could easily find it in the spec and read on the meaning
of values. This is done to avoid copying needlessly spec text into QEMU.
So if 0xffff is described in the table definition, then typically just
field name comment is sufficient.

> > +    /* Flags */
> > +    build_append_int_noprefix(table_data, 0, 1);
> > +    /* Enabled */
> > +    build_append_int_noprefix(table_data, 1, 1);
> > +
> > +    /* Number of Records To Pre-allocate */
> > +    build_append_int_noprefix(table_data, 1, 4);
> > +    /* Max Sections Per Record */
> > +    build_append_int_noprefix(table_data, 1, 4);
> > +    /* Max Raw Data Length */
> > +    build_append_int_noprefix(table_data, ACPI_GHES_MAX_RAW_DATA_LENGTH, 4);
> > +
> > +    /* Error Status Address */
> > +    build_append_gas(table_data, AML_AS_SYSTEM_MEMORY, 0x40, 0,
> > +                     4 /* QWord access */, 0);
> > +    bios_linker_loader_add_pointer(linker, ACPI_BUILD_TABLE_FILE,
> > +        ACPI_GHES_ERROR_STATUS_ADDRESS_OFFSET(hest_start, source_id),
> > +        ACPI_GHES_ADDRESS_SIZE, ACPI_GHES_ERRORS_FW_CFG_FILE,
> > +        source_id * ACPI_GHES_ADDRESS_SIZE);
> > +
> > +    /*
> > +     * Notification Structure
> > +     * Now only enable ARMv8 SEA notification type
> > +     */
> > +    acpi_ghes_build_notify(table_data, ACPI_GHES_NOTIFY_SEA);
> > +
> > +    /* Error Status Block Length */
> > +    build_append_int_noprefix(table_data, ACPI_GHES_MAX_RAW_DATA_LENGTH, 4);
> > +
> > +    /*
> > +     * Read Ack Register
> > +     * ACPI 6.1: 18.3.2.8 Generic Hardware Error Source
> > +     * version 2 (GHESv2 - Type 10)
> > +     */
> > +    build_append_gas(table_data, AML_AS_SYSTEM_MEMORY, 0x40, 0,
> > +                     4 /* QWord access */, 0);
> > +    bios_linker_loader_add_pointer(linker, ACPI_BUILD_TABLE_FILE,
> > +        ACPI_GHES_READ_ACK_REGISTER_ADDRESS_OFFSET(hest_start, 0),
> > +        ACPI_GHES_ADDRESS_SIZE, ACPI_GHES_ERRORS_FW_CFG_FILE,
> > +        (ACPI_GHES_ERROR_SOURCE_COUNT + source_id) * ACPI_GHES_ADDRESS_SIZE);
> > +
> > +    /*
> > +     * Read Ack Preserve
> > +     * We only provide the first bit in Read Ack Register to OSPM to write
> > +     * while the other bits are preserved.
> > +     */
> > +    build_append_int_noprefix(table_data, ~0x1ULL, 8);
> > +    /* Read Ack Write */
> > +    build_append_int_noprefix(table_data, 0x1, 8);
> > +
> > +    build_header(linker, table_data, (void *)(table_data->data + hest_start),
> > +        "HEST", table_data->len - hest_start, 1, NULL, "GHES");
> > +}
> > +  
> Already mentioned .... but ...
> the last few lines are GHESv2 specific but it seems that HES/GHES/GHESv2
> are being mixed within this patch. Would be nice if those could be separated
> to easy future extensions
> 
> BR
> 
> Beata
> 
> > +static AcpiGhesState ges;
> > +void acpi_ghes_add_fw_cfg(FWCfgState *s, GArray *hardware_error)
> > +{
> > +
> > +    size_t size = 2 * ACPI_GHES_ADDRESS_SIZE + ACPI_GHES_MAX_RAW_DATA_LENGTH;
> > +    size_t request_block_size = ACPI_GHES_ERROR_SOURCE_COUNT * size;
> > +
> > +    /* Create a read-only fw_cfg file for GHES */
> > +    fw_cfg_add_file(s, ACPI_GHES_ERRORS_FW_CFG_FILE, hardware_error->data,
> > +                    request_block_size);
> > +
> > +    /* Create a read-write fw_cfg file for Address */
> > +    fw_cfg_add_file_callback(s, ACPI_GHES_DATA_ADDR_FW_CFG_FILE, NULL, NULL,
> > +        NULL, &ges.ghes_addr_le, sizeof(ges.ghes_addr_le), false);
> > +}
> > diff --git a/hw/acpi/aml-build.c b/hw/acpi/aml-build.c
> > index 2c3702b882..3681ec6e3d 100644
> > --- a/hw/acpi/aml-build.c
> > +++ b/hw/acpi/aml-build.c
> > @@ -1578,6 +1578,7 @@ void acpi_build_tables_init(AcpiBuildTables *tables)
> >      tables->table_data = g_array_new(false, true /* clear */, 1);
> >      tables->tcpalog = g_array_new(false, true /* clear */, 1);
> >      tables->vmgenid = g_array_new(false, true /* clear */, 1);
> > +    tables->hardware_errors = g_array_new(false, true /* clear */, 1);
> >      tables->linker = bios_linker_loader_init();
> >  }
> >
> > @@ -1588,6 +1589,7 @@ void acpi_build_tables_cleanup(AcpiBuildTables *tables, bool mfre)
> >      g_array_free(tables->table_data, true);
> >      g_array_free(tables->tcpalog, mfre);
> >      g_array_free(tables->vmgenid, mfre);
> > +    g_array_free(tables->hardware_errors, mfre);
> >  }
> >
> >  /*
> > diff --git a/hw/arm/virt-acpi-build.c b/hw/arm/virt-acpi-build.c
> > index 4cd50175e0..1b1fd273e4 100644
> > --- a/hw/arm/virt-acpi-build.c
> > +++ b/hw/arm/virt-acpi-build.c
> > @@ -48,6 +48,7 @@
> >  #include "sysemu/reset.h"
> >  #include "kvm_arm.h"
> >  #include "migration/vmstate.h"
> > +#include "hw/acpi/acpi_ghes.h"
> >
> >  #define ARM_SPI_BASE 32
> >
> > @@ -825,6 +826,13 @@ void virt_acpi_build(VirtMachineState *vms, AcpiBuildTables *tables)
> >      acpi_add_table(table_offsets, tables_blob);
> >      build_spcr(tables_blob, tables->linker, vms);
> >
> > +    if (vms->ras) {
> > +        acpi_add_table(table_offsets, tables_blob);
> > +        acpi_ghes_build_error_table(tables->hardware_errors, tables->linker);
> > +        acpi_ghes_build_hest(tables_blob, tables->hardware_errors,
> > +                             tables->linker);
> > +    }
> > +
> >      if (ms->numa_state->num_nodes > 0) {
> >          acpi_add_table(table_offsets, tables_blob);
> >          build_srat(tables_blob, tables->linker, vms);
> > @@ -942,6 +950,10 @@ void virt_acpi_setup(VirtMachineState *vms)
> >      fw_cfg_add_file(vms->fw_cfg, ACPI_BUILD_TPMLOG_FILE, tables.tcpalog->data,
> >                      acpi_data_len(tables.tcpalog));
> >
> > +    if (vms->ras) {
> > +        acpi_ghes_add_fw_cfg(vms->fw_cfg, tables.hardware_errors);
> > +    }
> > +
> >      build_state->rsdp_mr = acpi_add_rom_blob(virt_acpi_build_update,
> >                                               build_state, tables.rsdp,
> >                                               ACPI_BUILD_RSDP_FILE, 0);
> > diff --git a/include/hw/acpi/acpi_ghes.h b/include/hw/acpi/acpi_ghes.h
> > new file mode 100644
> > index 0000000000..cb62ec9c7b
> > --- /dev/null
> > +++ b/include/hw/acpi/acpi_ghes.h
> > @@ -0,0 +1,56 @@
> > +/*
> > + * Support for generating APEI tables and recording CPER for Guests
> > + *
> > + * Copyright (c) 2019 HUAWEI TECHNOLOGIES CO., LTD.
> > + *
> > + * Author: Dongjiu Geng <gengdongjiu@huawei.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation; either version 2 of the License, or
> > + * (at your option) any later version.
> > +
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > +
> > + * You should have received a copy of the GNU General Public License along
> > + * with this program; if not, see <http://www.gnu.org/licenses/>.
> > + */
> > +
> > +#ifndef ACPI_GHES_H
> > +#define ACPI_GHES_H
> > +
> > +#include "hw/acpi/bios-linker-loader.h"
> > +
> > +/*
> > + * Values for Hardware Error Notification Type field
> > + */
> > +enum AcpiGhesNotifyType {
> > +    ACPI_GHES_NOTIFY_POLLED = 0,    /* Polled */
> > +    ACPI_GHES_NOTIFY_EXTERNAL = 1,  /* External Interrupt */
> > +    ACPI_GHES_NOTIFY_LOCAL = 2, /* Local Interrupt */
> > +    ACPI_GHES_NOTIFY_SCI = 3,   /* SCI */
> > +    ACPI_GHES_NOTIFY_NMI = 4,   /* NMI */
> > +    ACPI_GHES_NOTIFY_CMCI = 5,  /* CMCI, ACPI 5.0: 18.3.2.7, Table 18-290 */
> > +    ACPI_GHES_NOTIFY_MCE = 6,   /* MCE, ACPI 5.0: 18.3.2.7, Table 18-290 */
> > +    /* GPIO-Signal, ACPI 6.0: 18.3.2.7, Table 18-332 */
> > +    ACPI_GHES_NOTIFY_GPIO = 7,
> > +    /* ARMv8 SEA, ACPI 6.1: 18.3.2.9, Table 18-345 */
> > +    ACPI_GHES_NOTIFY_SEA = 8,
> > +    /* ARMv8 SEI, ACPI 6.1: 18.3.2.9, Table 18-345 */
> > +    ACPI_GHES_NOTIFY_SEI = 9,
> > +    /* External Interrupt - GSIV, ACPI 6.1: 18.3.2.9, Table 18-345 */
> > +    ACPI_GHES_NOTIFY_GSIV = 10,
> > +    /* Software Delegated Exception, ACPI 6.2: 18.3.2.9, Table 18-383 */
> > +    ACPI_GHES_NOTIFY_SDEI = 11,
> > +    ACPI_GHES_NOTIFY_RESERVED = 12 /* 12 and greater are reserved */
> > +};
> > +
> > +void acpi_ghes_build_hest(GArray *table_data, GArray *hardware_error,
> > +                          BIOSLinker *linker);
> > +
> > +void acpi_ghes_build_error_table(GArray *hardware_errors, BIOSLinker *linker);
> > +void acpi_ghes_add_fw_cfg(FWCfgState *s, GArray *hardware_errors);
> > +#endif
> > diff --git a/include/hw/acpi/aml-build.h b/include/hw/acpi/aml-build.h
> > index de4a406568..8f13620701 100644
> > --- a/include/hw/acpi/aml-build.h
> > +++ b/include/hw/acpi/aml-build.h
> > @@ -220,6 +220,7 @@ struct AcpiBuildTables {
> >      GArray *rsdp;
> >      GArray *tcpalog;
> >      GArray *vmgenid;
> > +    GArray *hardware_errors;
> >      BIOSLinker *linker;
> >  } AcpiBuildTables;
> >
> > --
> > 2.19.1
> >
> >
> >  
> 

