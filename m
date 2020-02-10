Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E17A157354
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2020 12:18:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727363AbgBJLSU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Feb 2020 06:18:20 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:10609 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727121AbgBJLSU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Feb 2020 06:18:20 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 81946A329E95B9C74D68;
        Mon, 10 Feb 2020 19:18:16 +0800 (CST)
Received: from [127.0.0.1] (10.142.68.147) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.439.0; Mon, 10 Feb 2020
 19:18:07 +0800
Subject: Re: [PATCH v22 4/9] ACPI: Build Hardware Error Source Table
To:     Jonathan Cameron <Jonathan.Cameron@Huawei.com>
CC:     <pbonzini@redhat.com>, <mst@redhat.com>, <imammedo@redhat.com>,
        <shannon.zhaosl@gmail.com>, <peter.maydell@linaro.org>,
        <fam@euphon.net>, <rth@twiddle.net>, <ehabkost@redhat.com>,
        <mtosatti@redhat.com>, <xuwei5@huawei.com>, <james.morse@arm.com>,
        <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>,
        <qemu-arm@nongnu.org>, <zhengxiang9@huawei.com>,
        <linuxarm@huawei.com>
References: <1578483143-14905-1-git-send-email-gengdongjiu@huawei.com>
 <1578483143-14905-5-git-send-email-gengdongjiu@huawei.com>
 <20200205164328.00006f1e@Huawei.com>
From:   gengdongjiu <gengdongjiu@huawei.com>
Message-ID: <f24fb648-a06b-0b97-1afa-e4ed6137a7d4@huawei.com>
Date:   Mon, 10 Feb 2020 19:18:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20200205164328.00006f1e@Huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.142.68.147]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020/2/6 0:43, Jonathan Cameron wrote:
> On Wed, 8 Jan 2020 19:32:18 +0800
> Dongjiu Geng <gengdongjiu@huawei.com> wrote:
> 
>> This patch builds Hardware Error Source Table(HEST) via fw_cfg blobs.
>> Now it only supports ARMv8 SEA, a type of Generic Hardware Error
>> Source version 2(GHESv2) error source. Afterwards, we can extend
>> the supported types if needed. For the CPER section, currently it
>> is memory section because kernel mainly wants userspace to handle
>> the memory errors.
>>
>> This patch follows the spec ACPI 6.2 to build the Hardware Error
>> Source table. For more detailed information, please refer to
>> document: docs/specs/acpi_hest_ghes.rst
>>
>> build_append_ghes_notify() will help to add Hardware Error Notification
>> to ACPI tables without using packed C structures and avoid endianness
>> issues as API doesn't need explicit conversion.
>>
>> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
>> Signed-off-by: Xiang Zheng <zhengxiang9@huawei.com>
>> Reviewed-by: Michael S. Tsirkin <mst@redhat.com>
>> Acked-by: Xiang Zheng <zhengxiang9@huawei.com>
> 
> Hi. 
> 
> I was forwards porting my old series adding CCIX error injection support
> and came across a place this could 'possibly' be improved.

Jonathan, It is great that you add CCIX error injection support based on this series.
thanks for using it.

> 
> I say possibly because it's really about enabling more flexibility
> in how this code is reused than actually 'fixing' anything here.
> 
> If you don't make the change here, I'll just add a precursor patch to my
> series.  Just seems nice to tidy it up at source.

sure, I make a change to make your patch work well.

> 
> The rest of the partMake your patch very good work.s of this series I am using seems to work great.




> 
> Thanks!
> 
> Jonathan
> 
>> ---
>>  hw/acpi/ghes.c           | 118 ++++++++++++++++++++++++++++++++++++++++++++++-
>>  hw/arm/virt-acpi-build.c |   2 +
>>  include/hw/acpi/ghes.h   |  40 ++++++++++++++++
>>  3 files changed, 159 insertions(+), 1 deletion(-)
>>
>> diff --git a/hw/acpi/ghes.c b/hw/acpi/ghes.c
>> index b7fdbbb..9d37798 100644
>> --- a/hw/acpi/ghes.c
>> +++ b/hw/acpi/ghes.c
>> @@ -34,9 +34,42 @@
>> +
> ...
>> +/* Build Generic Hardware Error Source version 2 (GHESv2) */
>> +static void build_ghes_v2(GArray *table_data, int source_id, BIOSLinker *linker)
> This function takes source ID, which uses the enum of all sources registered.
> However, it doesn't use it to locate the actual physical addresses.
> 
> Currently the code effectively assumes the value is 0.

yes, because there is only one source, so the value is 0.

> 
>> +{
>> +    uint64_t address_offset;
>> +    /*
>> +     * Type:
>> +     * Generic Hardware Error Source version 2(GHESv2 - Type 10)
>> +     */
>> +    build_append_int_noprefix(table_data, ACPI_GHES_SOURCE_GENERIC_ERROR_V2, 2);
>> +    /* Source Id */
>> +    build_append_int_noprefix(table_data, source_id, 2);
>> +    /* Related Source Id */
>> +    build_append_int_noprefix(table_data, 0xffff, 2);
>> +    /* Flags */
>> +    build_append_int_noprefix(table_data, 0, 1);
>> +    /* Enabled */
>> +    build_append_int_noprefix(table_data, 1, 1);
>> +
>> +    /* Number of Records To Pre-allocate */
>> +    build_append_int_noprefix(table_data, 1, 4);
>> +    /* Max Sections Per Record */
>> +    build_append_int_noprefix(table_data, 1, 4);
>> +    /* Max Raw Data Length */
>> +    build_append_int_noprefix(table_data, ACPI_GHES_MAX_RAW_DATA_LENGTH, 4);
>> +
>> +    address_offset = table_data->len;
>> +    /* Error Status Address */
>> +    build_append_gas(table_data, AML_AS_SYSTEM_MEMORY, 0x40, 0,
>> +                     4 /* QWord access */, 0);
>> +    bios_linker_loader_add_pointer(linker, ACPI_BUILD_TABLE_FILE,
>> +        address_offset + GAS_ADDR_OFFSET,
>> +        sizeof(uint64_t), ACPI_GHES_ERRORS_FW_CFG_FILE, 0);
> 
> The offset here would need to be source_id * sizeof(uint64_t) I think
> 
>> +
>> +    /*
>> +     * Notification Structure
>> +     * Now only enable ARMv8 SEA notification type
>> +     */
>> +    build_ghes_hw_error_notification(table_data, ACPI_GHES_NOTIFY_SEA);
> Perhaps a switch for this to allow for other options later.

OK, I will make this change in order to easily support more hardware error source.

> 
> 	switch (source_id) {
> 	case ACPI_HEST_SRC_ID_SEA:
> 		...
> 		break;
> 	default:
> 	//print some error message.
> 
> 	}

ok

>> +
>> +    /* Error Status Block Length */
>> +    build_append_int_noprefix(table_data, ACPI_GHES_MAX_RAW_DATA_LENGTH, 4);
>> +
>> +    /*
>> +     * Read Ack Register
>> +     * ACPI 6.1: 18.3.2.8 Generic Hardware Error Source
>> +     * version 2 (GHESv2 - Type 10)
>> +     */
>> +    address_offset = table_data->len;
>> +    build_append_gas(table_data, AML_AS_SYSTEM_MEMORY, 0x40, 0,
>> +                     4 /* QWord access */, 0);
>> +    bios_linker_loader_add_pointer(linker, ACPI_BUILD_TABLE_FILE,
>> +        address_offset + GAS_ADDR_OFFSET,
>> +        sizeof(uint64_t), ACPI_GHES_ERRORS_FW_CFG_FILE,
>> +        ACPI_GHES_ERROR_SOURCE_COUNT * sizeof(uint64_t));
> 
> Offset of (ACPI_GHES_ERROR_SOURCE_COUNT + source_id) * sizeof(uint64_t)
yes, It due to I only support one source, the source_id is zero and not use it.
In order to easily extend, I will add this change.

> 
>> +
>> +    /*
>> +     * Read Ack Preserve
>> +     * We only provide the first bit in Read Ack Register to OSPM to write
>> +     * while the other bits are preserved.
>> +     */
>> +    build_append_int_noprefix(table_data, ~0x1ULL, 8);
>> +    /* Read Ack Write */
>> +    build_append_int_noprefix(table_data, 0x1, 8);
>> +}
> 
> 
> 
> .
> 

