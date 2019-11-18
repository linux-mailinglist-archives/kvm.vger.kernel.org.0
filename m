Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 401DE10064D
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2019 14:18:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726627AbfKRNSP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Nov 2019 08:18:15 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:33652 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726284AbfKRNSP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Nov 2019 08:18:15 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 863DE3839AA8C708ED17;
        Mon, 18 Nov 2019 21:18:13 +0800 (CST)
Received: from [127.0.0.1] (10.142.68.147) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.439.0; Mon, 18 Nov 2019
 21:18:03 +0800
Subject: Re: [RESEND PATCH v21 3/6] ACPI: Add APEI GHES table generation
 support
From:   gengdongjiu <gengdongjiu@huawei.com>
To:     Igor Mammedov <imammedo@redhat.com>,
        Xiang Zheng <zhengxiang9@huawei.com>
CC:     <pbonzini@redhat.com>, <mst@redhat.com>,
        <shannon.zhaosl@gmail.com>, <peter.maydell@linaro.org>,
        <lersek@redhat.com>, <james.morse@arm.com>, <mtosatti@redhat.com>,
        <rth@twiddle.net>, <ehabkost@redhat.com>,
        <jonathan.cameron@huawei.com>, <xuwei5@huawei.com>,
        <kvm@vger.kernel.org>, <qemu-devel@nongnu.org>,
        <qemu-arm@nongnu.org>, <linuxarm@huawei.com>,
        <wanghaibin.wang@huawei.com>
References: <20191111014048.21296-1-zhengxiang9@huawei.com>
 <20191111014048.21296-4-zhengxiang9@huawei.com>
 <20191115103801.547fc84d@redhat.com>
 <cf5e5aa4-2283-6cf9-70d0-278d167e3a13@huawei.com>
Message-ID: <87758ec2-c242-71c3-51f8-a5d348f8e7fd@huawei.com>
Date:   Mon, 18 Nov 2019 21:18:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <cf5e5aa4-2283-6cf9-70d0-278d167e3a13@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.142.68.147]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2019/11/18 20:49, gengdongjiu wrote:
>>> +     */
>>> +    build_append_int_noprefix(table_data, source_id, 2);
>>> +    /* Related Source Id */
>>> +    build_append_int_noprefix(table_data, 0xffff, 2);
>>> +    /* Flags */
>>> +    build_append_int_noprefix(table_data, 0, 1);
>>> +    /* Enabled */
>>> +    build_append_int_noprefix(table_data, 1, 1);
>>> +
>>> +    /* Number of Records To Pre-allocate */
>>> +    build_append_int_noprefix(table_data, 1, 4);
>>> +    /* Max Sections Per Record */
>>> +    build_append_int_noprefix(table_data, 1, 4);
>>> +    /* Max Raw Data Length */
>>> +    build_append_int_noprefix(table_data, ACPI_GHES_MAX_RAW_DATA_LENGTH, 4);
>>> +
>>> +    /* Error Status Address */
>>> +    build_append_gas(table_data, AML_AS_SYSTEM_MEMORY, 0x40, 0,
>>> +                     4 /* QWord access */, 0);
>>> +    bios_linker_loader_add_pointer(linker, ACPI_BUILD_TABLE_FILE,
>>> +        ACPI_GHES_ERROR_STATUS_ADDRESS_OFFSET(hest_start, source_id),
>> it's fine only if GHESv2 is the only entries in HEST, but once
>> other types are added this macro will silently fall apart and
>> cause table corruption.
   why  silently fall?
   I think the acpi_ghes.c only support GHESv2 type, not support other type.

>>
>> Instead of offset from hest_start, I suggest to use offset relative
>> to GAS structure, here is an idea>>
>> #define GAS_ADDR_OFFSET 4
>>
>>     off = table->len
>>     build_append_gas()
>>     bios_linker_loader_add_pointer(...,
>>         off + GAS_ADDR_OFFSET, ...

If use offset relative to GAS structure, the code does not easily extend to support more Generic Hardware Error Source.
if use offset relative to hest_start, just use a loop, the code can support  more error source, for example:
for (source_id = 0; i<n; source_id++)
{
   ......
    bios_linker_loader_add_pointer(linker, ACPI_BUILD_TABLE_FILE,
        ACPI_GHES_ERROR_STATUS_ADDRESS_OFFSET(hest_start, source_id),
        sizeof(uint64_t), ACPI_GHES_ERRORS_FW_CFG_FILE,
        source_id * sizeof(uint64_t));
  .......
}

My previous series patch support 2 error sources, but now only enable 'SEA' type Error Source

