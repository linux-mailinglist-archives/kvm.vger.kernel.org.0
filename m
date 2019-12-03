Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD9C10F5A2
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2019 04:35:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbfLCDfX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Dec 2019 22:35:23 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7191 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726319AbfLCDfX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Dec 2019 22:35:23 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 95E033A9891C360ACA0D;
        Tue,  3 Dec 2019 11:35:19 +0800 (CST)
Received: from [127.0.0.1] (10.133.224.57) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.439.0; Tue, 3 Dec 2019
 11:35:09 +0800
Subject: Re: [RESEND PATCH v21 5/6] target-arm: kvm64: handle SIGBUS signal
 from kernel or KVM
To:     Beata Michalska <beata.michalska@linaro.org>
CC:     <pbonzini@redhat.com>, <mst@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        <shannon.zhaosl@gmail.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Laszlo Ersek <lersek@redhat.com>, <james.morse@arm.com>,
        gengdongjiu <gengdongjiu@huawei.com>, <mtosatti@redhat.com>,
        <rth@twiddle.net>, <ehabkost@redhat.com>,
        <jonathan.cameron@huawei.com>, <xuwei5@huawei.com>,
        <kvm@vger.kernel.org>, <qemu-devel@nongnu.org>,
        <qemu-arm@nongnu.org>, <linuxarm@huawei.com>,
        <wanghaibin.wang@huawei.com>
References: <20191111014048.21296-1-zhengxiang9@huawei.com>
 <20191111014048.21296-6-zhengxiang9@huawei.com>
 <CADSWDztF=eaUDNnq8bhnPyTKW1YjAWm4UBaH-NBPkzjnzx0bxg@mail.gmail.com>
 <22a3935a-a672-f8f1-e5be-6c0725f738c4@huawei.com>
 <CADSWDzsEFNMKrC6h4=r70KMzG8XX_5DS1CfGBGBCMmOTfu6qyA@mail.gmail.com>
From:   Xiang Zheng <zhengxiang9@huawei.com>
Message-ID: <9e22a655-5333-ba65-a00d-712b5b144ff4@huawei.com>
Date:   Tue, 3 Dec 2019 11:35:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <CADSWDzsEFNMKrC6h4=r70KMzG8XX_5DS1CfGBGBCMmOTfu6qyA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.133.224.57]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2019/11/27 22:17, Beata Michalska wrote:
> Hi
> 
> On Wed, 27 Nov 2019 at 12:47, Xiang Zheng <zhengxiang9@huawei.com> wrote:
>>
>> Hi Beata,
>>
>> Thanks for you review!
>>
> YAW
> 
>> On 2019/11/22 23:47, Beata Michalska wrote:
>>> Hi,
>>>
>>> On Mon, 11 Nov 2019 at 01:48, Xiang Zheng <zhengxiang9@huawei.com> wrote:
>>>>
>>>> From: Dongjiu Geng <gengdongjiu@huawei.com>
>>>>
>>>> Add a SIGBUS signal handler. In this handler, it checks the SIGBUS type,
>>>> translates the host VA delivered by host to guest PA, then fills this PA
>>>> to guest APEI GHES memory, then notifies guest according to the SIGBUS
>>>> type.
>>>>
>>>> When guest accesses the poisoned memory, it will generate a Synchronous
>>>> External Abort(SEA). Then host kernel gets an APEI notification and calls
>>>> memory_failure() to unmapped the affected page in stage 2, finally
>>>> returns to guest.
>>>>
>>>> Guest continues to access the PG_hwpoison page, it will trap to KVM as
>>>> stage2 fault, then a SIGBUS_MCEERR_AR synchronous signal is delivered to
>>>> Qemu, Qemu records this error address into guest APEI GHES memory and
>>>> notifes guest using Synchronous-External-Abort(SEA).
>>>>
>>>> In order to inject a vSEA, we introduce the kvm_inject_arm_sea() function
>>>> in which we can setup the type of exception and the syndrome information.
>>>> When switching to guest, the target vcpu will jump to the synchronous
>>>> external abort vector table entry.
>>>>
>>>> The ESR_ELx.DFSC is set to synchronous external abort(0x10), and the
>>>> ESR_ELx.FnV is set to not valid(0x1), which will tell guest that FAR is
>>>> not valid and hold an UNKNOWN value. These values will be set to KVM
>>>> register structures through KVM_SET_ONE_REG IOCTL.
>>>>
>>>> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
>>>> Signed-off-by: Xiang Zheng <zhengxiang9@huawei.com>
>>>> Reviewed-by: Michael S. Tsirkin <mst@redhat.com>
>>>> ---
>>>>  hw/acpi/acpi_ghes.c         | 297 ++++++++++++++++++++++++++++++++++++
>>>>  include/hw/acpi/acpi_ghes.h |   4 +
>>>>  include/sysemu/kvm.h        |   3 +-
>>>>  target/arm/cpu.h            |   4 +
>>>>  target/arm/helper.c         |   2 +-
>>>>  target/arm/internals.h      |   5 +-
>>>>  target/arm/kvm64.c          |  64 ++++++++
>>>>  target/arm/tlb_helper.c     |   2 +-
>>>>  target/i386/cpu.h           |   2 +
>>>>  9 files changed, 377 insertions(+), 6 deletions(-)
>>>>
>>>> diff --git a/hw/acpi/acpi_ghes.c b/hw/acpi/acpi_ghes.c
>>>> index 42c00ff3d3..f5b54990c0 100644
>>>> --- a/hw/acpi/acpi_ghes.c
>>>> +++ b/hw/acpi/acpi_ghes.c
>>>> @@ -39,6 +39,34 @@
>>>>  /* The max size in bytes for one error block */
>>>>  #define ACPI_GHES_MAX_RAW_DATA_LENGTH       0x1000
>>>>
>>>> +/*
>>>> + * The total size of Generic Error Data Entry
>>>> + * ACPI 6.1/6.2: 18.3.2.7.1 Generic Error Data,
>>>> + * Table 18-343 Generic Error Data Entry
>>>> + */
>>>> +#define ACPI_GHES_DATA_LENGTH               72
>>>> +
>>>> +/*
>>>> + * The memory section CPER size,
>>>> + * UEFI 2.6: N.2.5 Memory Error Section
>>>> + */
>>>> +#define ACPI_GHES_MEM_CPER_LENGTH           80
>>>> +
>>>> +/*
>>>> + * Masks for block_status flags
>>>> + */
>>>> +#define ACPI_GEBS_UNCORRECTABLE         1
>>>
>>> Why not listing all supported statuses ? Similar to error severity below ?
>>>
>>
>> We now only use the first bit for uncorrectable error. The correctable errors
>> are handled in host and would not be delivered to QEMU.
>>
>> I think it's unnecessary to list all the bit masks.
> 
> I'm not sure we are using all the error severity types either, but fair enough.
>>
>>>> +
>>>> +/*
>>>> + * Values for error_severity field
>>>> + */
>>>> +enum AcpiGenericErrorSeverity {
>>>> +    ACPI_CPER_SEV_RECOVERABLE,
>>>> +    ACPI_CPER_SEV_FATAL,
>>>> +    ACPI_CPER_SEV_CORRECTED,
>>>> +    ACPI_CPER_SEV_NONE,
>>>> +};
>>>> +
>>>>  /*
>>>>   * Now only support ARMv8 SEA notification type error source
>>>>   */
>>>> @@ -49,6 +77,16 @@
>>>>   */
>>>>  #define ACPI_GHES_SOURCE_GENERIC_ERROR_V2   10
>>>>
>>>> +#define UUID_BE(a, b, c, d0, d1, d2, d3, d4, d5, d6, d7)        \
>>>> +    {{{ ((a) >> 24) & 0xff, ((a) >> 16) & 0xff, ((a) >> 8) & 0xff, (a) & 0xff, \
>>>> +    ((b) >> 8) & 0xff, (b) & 0xff,                   \
>>>> +    ((c) >> 8) & 0xff, (c) & 0xff,                    \
>>>> +    (d0), (d1), (d2), (d3), (d4), (d5), (d6), (d7) } } }
>>>> +
>>>> +#define UEFI_CPER_SEC_PLATFORM_MEM                   \
>>>> +    UUID_BE(0xA5BC1114, 0x6F64, 0x4EDE, 0xB8, 0x63, 0x3E, 0x83, \
>>>> +    0xED, 0x7C, 0x83, 0xB1)
>>>> +
>>>>  /*
> 
> As suggested in different thread - could this be also made common with
> NVMe code ?

Sure, I will make it common in a separate patch.

>>>> @@ -1036,6 +1062,44 @@ int kvm_arch_get_registers(CPUState *cs)
>>>>      return ret;
>>>>  }
>>>>
>>>> +void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr)
>>>> +{
>>>> +    ram_addr_t ram_addr;
>>>> +    hwaddr paddr;
>>>> +
>>>> +    assert(code == BUS_MCEERR_AR || code == BUS_MCEERR_AO);
>>>> +
>>>> +    if (acpi_enabled && addr &&
>>>> +            object_property_get_bool(qdev_get_machine(), "ras", NULL)) {
>>>> +        ram_addr = qemu_ram_addr_from_host(addr);
>>>> +        if (ram_addr != RAM_ADDR_INVALID &&
>>>> +            kvm_physical_memory_addr_from_host(c->kvm_state, addr, &paddr)) {
>>>> +            kvm_hwpoison_page_add(ram_addr);
>>>> +            /*
>>>> +             * Asynchronous signal will be masked by main thread, so
>>>> +             * only handle synchronous signal.
>>>> +             */
>>>
>>> I'm not entirely sure that the comment above is correct (it has been
>>> pointed out before). I would expect the AO signal to be handled here as
>>> well. Not having proper support to do that just yet is another story but
>>> the comment might be bit misleading.
>>>
>>
>> We also expect the AO signal can be handled here. Maybe we could add the comment like:
>>
>> "Asynchronous signal is masked by main thread now. Once it can be asserted, we could
>> handle it." :)
>>
> Still not entirely there - if I'm not mistaken. Both BUS_MCEERR_AR and
> BUS_MVEERR_AO can end up here.
> I'm not entirely sure what you mean by "masked by main thread" ? Both will be
> handled by sigbus_handler and as such both will end up here either
> directly through kvm_on_sigbus
> or through kvm_cpu_exec with pending sigbus. Or am I misguided ?
> 

In fact BUS_MCEERR_AO cannot go to here, because QEMU main thread masks the SIGBUS signal[1]
and vcpu threads can only handle the BUS_MCEERR_AR.

         Qemu Main Thread   VCPU Threads

Kernel:  Mask SIGBUS        AO SIGBUS would be send to Qemu main thread in kernel(kill_proc())

KVM:     Mask SIGBUS        Only send AR SIGBUS to VCPU threads in KVM(kvm_send_hwpoison_signal())


However, maybe we shouldn't consider the behaviors of kernel or KVM and just keep
the logic of handling the AO signal in kvm_arch_on_sigbus_vcpu() like what x86 version
does.


[1] https://lists.gnu.org/archive/html/qemu-devel/2017-11/msg03575.html

-- 

Thanks,
Xiang

