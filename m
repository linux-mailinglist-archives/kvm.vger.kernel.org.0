Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2755DA544
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2019 08:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404804AbfJQGDq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Oct 2019 02:03:46 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:43594 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2392531AbfJQGDp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Oct 2019 02:03:45 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id E14F230BF13D4765E53A;
        Thu, 17 Oct 2019 14:03:42 +0800 (CST)
Received: from [127.0.0.1] (10.133.224.57) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.439.0; Thu, 17 Oct 2019
 14:03:32 +0800
Subject: Re: [PATCH v19 5/5] target-arm: kvm64: handle SIGBUS signal from
 kernel or KVM
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
 <20191015140140.34748-6-zhengxiang9@huawei.com>
 <CAFEAcA-92YEgrBPDVVFEmjBYnw=keJWKUDnqNRakw-jKYaxK5Q@mail.gmail.com>
From:   Xiang Zheng <zhengxiang9@huawei.com>
Message-ID: <c0ecb6af-c26f-0f97-c6dd-7745a03da94c@huawei.com>
Date:   Thu, 17 Oct 2019 14:03:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <CAFEAcA-92YEgrBPDVVFEmjBYnw=keJWKUDnqNRakw-jKYaxK5Q@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.133.224.57]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2019/10/15 22:48, Peter Maydell wrote:
> On Tue, 15 Oct 2019 at 15:02, Xiang Zheng <zhengxiang9@huawei.com> wrote:
>>
>> From: Dongjiu Geng <gengdongjiu@huawei.com>
>>
>> Add a SIGBUS signal handler. In this handler, it checks the SIGBUS type,
>> translates the host VA delivered by host to guest PA, then fills this PA
>> to guest APEI GHES memory, then notifies guest according to the SIGBUS
>> type.
>>
>> When guest accesses the poisoned memory, it will generate a Synchronous
>> External Abort(SEA). Then host kernel gets an APEI notification and calls
>> memory_failure() to unmapped the affected page in stage 2, finally
>> returns to guest.
>>
>> Guest continues to access the PG_hwpoison page, it will trap to KVM as
>> stage2 fault, then a SIGBUS_MCEERR_AR synchronous signal is delivered to
>> Qemu, Qemu records this error address into guest APEI GHES memory and
>> notifes guest using Synchronous-External-Abort(SEA).
>>
>> In order to inject a vSEA, we introduce the kvm_inject_arm_sea() function
>> in which we can setup the type of exception and the syndrome information.
>> When switching to guest, the target vcpu will jump to the synchronous
>> external abort vector table entry.
>>
>> The ESR_ELx.DFSC is set to synchronous external abort(0x10), and the
>> ESR_ELx.FnV is set to not valid(0x1), which will tell guest that FAR is
>> not valid and hold an UNKNOWN value. These values will be set to KVM
>> register structures through KVM_SET_ONE_REG IOCTL.
>>
>> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
>> Signed-off-by: Xiang Zheng <zhengxiang9@huawei.com>
> 
>> +static int acpi_ghes_record_mem_error(uint64_t error_block_address,
>> +                                      uint64_t error_physical_addr,
>> +                                      uint32_t data_length)
>> +{
>> +    GArray *block;
>> +    uint64_t current_block_length;
>> +    /* Memory Error Section Type */
>> +    QemuUUID mem_section_id_le = UEFI_CPER_SEC_PLATFORM_MEM;
>> +    QemuUUID fru_id = {0};
> 
> Hi; this makes at least some versions of clang complain
> (this is a clang bug, but it's present in shipped versions):
> 
> /home/petmay01/linaro/qemu-from-laptop/qemu/hw/acpi/acpi_ghes.c:135:24:
> error: suggest braces around
>       initialization of subobject [-Werror,-Wmissing-braces]
>     QemuUUID fru_id = {0};
>                        ^
>                        {}
> 
> We generally use "{}" as the generic zero-initializer for
> this reason (it's gcc/clang specific whereas "{0}" is
> in the standard, but all of the compilers we care about
> support it and don't warn about its use).
> 
>> +    uint8_t fru_text[20] = {0};
> 
> Clang doesn't mind this one because it's not initializing
> a struct type, but you could use "{}" here too for consistency.
> 

OK, I will replace all the "{0}" with "{}".

> thanks
> -- PMM
> 
> .
> 

-- 

Thanks,
Xiang

