Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6277EDA566
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2019 08:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437123AbfJQGUw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Oct 2019 02:20:52 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:37056 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731726AbfJQGUv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Oct 2019 02:20:51 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id EE5F4266ADB1D7F2B102;
        Thu, 17 Oct 2019 14:20:49 +0800 (CST)
Received: from [127.0.0.1] (10.133.224.57) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.439.0; Thu, 17 Oct 2019
 14:20:39 +0800
Subject: Re: [PATCH v19 3/5] ACPI: Add APEI GHES table generation support
To:     Peter Maydell <peter.maydell@linaro.org>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Shannon Zhao <shannon.zhaosl@gmail.com>,
        Laszlo Ersek <lersek@redhat.com>,
        James Morse <james.morse@arm.com>,
        gengdongjiu <gengdongjiu@huawei.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "xuwei (O)" <xuwei5@huawei.com>, kvm-devel <kvm@vger.kernel.org>,
        "QEMU Developers" <qemu-devel@nongnu.org>,
        qemu-arm <qemu-arm@nongnu.org>, Linuxarm <linuxarm@huawei.com>,
        <wanghaibin.wang@huawei.com>
References: <20191015140140.34748-1-zhengxiang9@huawei.com>
 <20191015140140.34748-4-zhengxiang9@huawei.com>
 <CAFEAcA9CWPKF5XibFtZRwavVj4PboGoaM5368Omje6qrOjV3AQ@mail.gmail.com>
From:   Xiang Zheng <zhengxiang9@huawei.com>
Message-ID: <f35f10ec-c5e0-bcdc-48a9-ceb754cf1fc1@huawei.com>
Date:   Thu, 17 Oct 2019 14:20:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <CAFEAcA9CWPKF5XibFtZRwavVj4PboGoaM5368Omje6qrOjV3AQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.133.224.57]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2019/10/15 22:52, Peter Maydell wrote:
> On Tue, 15 Oct 2019 at 15:02, Xiang Zheng <zhengxiang9@huawei.com> wrote:
>>
>> From: Dongjiu Geng <gengdongjiu@huawei.com>
>>
>> This patch implements APEI GHES Table generation via fw_cfg blobs. Now
>> it only supports ARMv8 SEA, a type of GHESv2 error source. Afterwards,
>> we can extend the supported types if needed. For the CPER section,
>> currently it is memory section because kernel mainly wants userspace to
>> handle the memory errors.
>>
>> This patch follows the spec ACPI 6.2 to build the Hardware Error Source
>> table. For more detailed information, please refer to document:
>> docs/specs/acpi_hest_ghes.rst
>>
>> Suggested-by: Laszlo Ersek <lersek@redhat.com>
>> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
>> Signed-off-by: Xiang Zheng <zhengxiang9@huawei.com>
> 
>> +    /* Error Status Address */
>> +    build_append_gas(table_data, AML_SYSTEM_MEMORY, 0x40, 0,
>> +                     4 /* QWord access */, 0);
> 
> Hi; this doesn't seem to compile with clang:
> 
> /home/petmay01/linaro/qemu-from-laptop/qemu/hw/acpi/acpi_ghes.c:330:34:
> error: implicit conversion from
>       enumeration type 'AmlRegionSpace' to different enumeration type
> 'AmlAddressSpace'
>       [-Werror,-Wenum-conversion]
>     build_append_gas(table_data, AML_SYSTEM_MEMORY, 0x40, 0,
>     ~~~~~~~~~~~~~~~~             ^~~~~~~~~~~~~~~~~
> /home/petmay01/linaro/qemu-from-laptop/qemu/hw/acpi/acpi_ghes.c:351:34:
> error: implicit conversion from
>       enumeration type 'AmlRegionSpace' to different enumeration type
> 'AmlAddressSpace'
>       [-Werror,-Wenum-conversion]
>     build_append_gas(table_data, AML_SYSTEM_MEMORY, 0x40, 0,
>     ~~~~~~~~~~~~~~~~             ^~~~~~~~~~~~~~~~~
> 2 errors generated.
> 
> Should these be AML_AS_SYSTEM_MEMORY, or should the build_append_gas()
> function be taking an AmlRegionSpace rather than an AmlAddressSpace ?

Yes, these should be AML_AS_SYSTEM_MEMORY, the first field of Generic Address
Structure(GAS) is Address Space ID. I will fix these compile errors.

> 
> thanks
> -- PMM
> 
> .
> 

-- 

Thanks,
Xiang

