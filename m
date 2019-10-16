Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 099F7D866F
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2019 05:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389155AbfJPD0Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Oct 2019 23:26:25 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4162 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728871AbfJPD0Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Oct 2019 23:26:25 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 83F0FEC8CDB2DA02A902;
        Wed, 16 Oct 2019 11:26:22 +0800 (CST)
Received: from [127.0.0.1] (10.133.224.57) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.439.0; Wed, 16 Oct 2019
 11:26:13 +0800
Subject: Re: [PATCH v19 2/5] docs: APEI GHES generation and CPER record
 description
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
 <20191015140140.34748-3-zhengxiang9@huawei.com>
 <CAFEAcA85gZUXnL+Qy=Wdg-MVbb1PqiKWCi72XvRnX8pZsgVr_A@mail.gmail.com>
From:   Xiang Zheng <zhengxiang9@huawei.com>
Message-ID: <9724f69a-2887-7896-29d8-3e9aa022df14@huawei.com>
Date:   Wed, 16 Oct 2019 11:26:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <CAFEAcA85gZUXnL+Qy=Wdg-MVbb1PqiKWCi72XvRnX8pZsgVr_A@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.133.224.57]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2019/10/15 23:08, Peter Maydell wrote:
> On Tue, 15 Oct 2019 at 15:02, Xiang Zheng <zhengxiang9@huawei.com> wrote:
>>
>> From: Dongjiu Geng <gengdongjiu@huawei.com>
>>
>> Add APEI/GHES detailed design document
>>
>> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
>> Signed-off-by: Xiang Zheng <zhengxiang9@huawei.com>
>> ---
>>  docs/specs/acpi_hest_ghes.rst | 94 +++++++++++++++++++++++++++++++++++++++++++
>>  docs/specs/index.rst          |  1 +
>>  2 files changed, 95 insertions(+)
>>  create mode 100644 docs/specs/acpi_hest_ghes.rst
>>
>> diff --git a/docs/specs/acpi_hest_ghes.rst b/docs/specs/acpi_hest_ghes.rst
>> new file mode 100644
>> index 0000000..905b6d1
>> --- /dev/null
>> +++ b/docs/specs/acpi_hest_ghes.rst
>> @@ -0,0 +1,94 @@
>> +APEI tables generating and CPER record
>> +======================================
>> +
>> +Copyright (c) 2019 HUAWEI TECHNOLOGIES CO., LTD.
>> +
>> +This work is licensed under the terms of the GNU GPL, version 2 or later.
>> +See the COPYING file in the top-level directory.
> 
> This puts the copyright/license statement into the HTML rendered
> docs seen by the user. We generally put them into an RST comment,
> so they're in the source .rst but not the rendered views, like this:
> 
> diff --git a/docs/specs/acpi_hest_ghes.rst b/docs/specs/acpi_hest_ghes.rst
> index 5b43e4b0da2..348825f9d3e 100644
> --- a/docs/specs/acpi_hest_ghes.rst
> +++ b/docs/specs/acpi_hest_ghes.rst
> @@ -1,10 +1,11 @@
>  APEI tables generating and CPER record
>  ======================================
> 
> -Copyright (c) 2019 HUAWEI TECHNOLOGIES CO., LTD.
> +..
> +   Copyright (c) 2019 HUAWEI TECHNOLOGIES CO., LTD.
> 
> -This work is licensed under the terms of the GNU GPL, version 2 or later.
> -See the COPYING file in the top-level directory.
> +   This work is licensed under the terms of the GNU GPL, version 2 or later.
> +   See the COPYING file in the top-level directory.
> 

OK.

> 
>> +(9) When QEMU gets a SIGBUS from the kernel, QEMU formats the CPER right into
>> +    guest memory, and then injects platform specific interrupt (in case of
>> +    arm/virt machine it's Synchronous External Abort) as a notification which
>> +    is necessary for notifying the guest.
>> +
>> +(10) This notification (in virtual hardware) will be handled by the guest
>> +    kernel, guest APEI driver will read the CPER which is recorded by QEMU and
>> +    do the recovery.
> 
> Sphinx thinks the indentation here is not syntactically valid:
> 
>   SPHINX  docs/specs
> 
> Warning, treated as error:
> /home/petmay01/linaro/qemu-from-laptop/qemu/docs/specs/acpi_hest_ghes.rst:93:Enumerated
> list ends without a blank line; unexpected unindent.
> Makefile:997: recipe for target 'docs/specs/index.html' failed
> 
> That's because for an enumerated list all the lines in the paragraph need to
> start at the same column. Moving in the two following lines in the (10) item
> fixes this:
> 
> --- a/docs/specs/acpi_hest_ghes.rst
> +++ b/docs/specs/acpi_hest_ghes.rst
> @@ -90,5 +90,5 @@ Design Details
>      is necessary for notifying the guest.
> 
>  (10) This notification (in virtual hardware) will be handled by the guest
> -    kernel, guest APEI driver will read the CPER which is recorded by QEMU and
> -    do the recovery.
> +     kernel, guest APEI driver will read the CPER which is recorded by QEMU and
> +     do the recovery.
> 

Thanks, I will fix them.


-- 

Thanks,
Xiang

