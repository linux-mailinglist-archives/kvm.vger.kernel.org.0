Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51C90153577
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 17:43:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727052AbgBEQnc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 11:43:32 -0500
Received: from lhrrgout.huawei.com ([185.176.76.210]:2382 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726359AbgBEQnc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Feb 2020 11:43:32 -0500
Received: from lhreml703-cah.china.huawei.com (unknown [172.18.7.106])
        by Forcepoint Email with ESMTP id 2BCBD87DFEB78505D9D6;
        Wed,  5 Feb 2020 16:43:30 +0000 (GMT)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 lhreml703-cah.china.huawei.com (10.201.108.44) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 5 Feb 2020 16:43:29 +0000
Received: from localhost (10.202.226.57) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Wed, 5 Feb 2020
 16:43:29 +0000
Date:   Wed, 5 Feb 2020 16:43:28 +0000
From:   Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To:     Dongjiu Geng <gengdongjiu@huawei.com>
CC:     <pbonzini@redhat.com>, <mst@redhat.com>, <imammedo@redhat.com>,
        <shannon.zhaosl@gmail.com>, <peter.maydell@linaro.org>,
        <fam@euphon.net>, <rth@twiddle.net>, <ehabkost@redhat.com>,
        <mtosatti@redhat.com>, <xuwei5@huawei.com>, <james.morse@arm.com>,
        <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>,
        <qemu-arm@nongnu.org>, <zhengxiang9@huawei.com>,
        <linuxarm@huawei.com>
Subject: Re: [PATCH v22 4/9] ACPI: Build Hardware Error Source Table
Message-ID: <20200205164328.00006f1e@Huawei.com>
In-Reply-To: <1578483143-14905-5-git-send-email-gengdongjiu@huawei.com>
References: <1578483143-14905-1-git-send-email-gengdongjiu@huawei.com>
        <1578483143-14905-5-git-send-email-gengdongjiu@huawei.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.226.57]
X-ClientProxiedBy: lhreml712-chm.china.huawei.com (10.201.108.63) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected
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

Hi. 

I was forwards porting my old series adding CCIX error injection support
and came across a place this could 'possibly' be improved.

I say possibly because it's really about enabling more flexibility
in how this code is reused than actually 'fixing' anything here.

If you don't make the change here, I'll just add a precursor patch to my
series.  Just seems nice to tidy it up at source.

The rest of the parts of this series I am using seems to work great.

Thanks!

Jonathan

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
> +
...
> +/* Build Generic Hardware Error Source version 2 (GHESv2) */
> +static void build_ghes_v2(GArray *table_data, int source_id, BIOSLinker *linker)
This function takes source ID, which uses the enum of all sources registered.
However, it doesn't use it to locate the actual physical addresses.

Currently the code effectively assumes the value is 0.

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

The offset here would need to be source_id * sizeof(uint64_t) I think

> +
> +    /*
> +     * Notification Structure
> +     * Now only enable ARMv8 SEA notification type
> +     */
> +    build_ghes_hw_error_notification(table_data, ACPI_GHES_NOTIFY_SEA);
Perhaps a switch for this to allow for other options later.

	switch (source_id) {
	case ACPI_HEST_SRC_ID_SEA:
		...
		break;
	default:
	//print some error message.

	}
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

Offset of (ACPI_GHES_ERROR_SOURCE_COUNT + source_id) * sizeof(uint64_t)

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



