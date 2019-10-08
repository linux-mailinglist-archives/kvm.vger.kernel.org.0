Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2969DCFA35
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2019 14:42:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730933AbfJHMmk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Oct 2019 08:42:40 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3275 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730317AbfJHMmj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Oct 2019 08:42:39 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 967A3210434A454C42DE;
        Tue,  8 Oct 2019 20:42:37 +0800 (CST)
Received: from [127.0.0.1] (10.133.224.57) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.439.0; Tue, 8 Oct 2019
 20:42:31 +0800
Subject: Re: [PATCH v18 6/6] target-arm: kvm64: handle SIGBUS signal from
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
References: <20190906083152.25716-1-zhengxiang9@huawei.com>
 <20190906083152.25716-7-zhengxiang9@huawei.com>
 <CAFEAcA9Y3J8uRDN+HQO74-codKhoj5CyPW=9q3GwH8Mk_PNYTA@mail.gmail.com>
From:   Xiang Zheng <zhengxiang9@huawei.com>
Message-ID: <161a9a3b-d937-0db7-0cad-ebf6bb73cca7@huawei.com>
Date:   Tue, 8 Oct 2019 20:42:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <CAFEAcA9Y3J8uRDN+HQO74-codKhoj5CyPW=9q3GwH8Mk_PNYTA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.133.224.57]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2019/9/27 21:57, Peter Maydell wrote:
> On Fri, 6 Sep 2019 at 09:33, Xiang Zheng <zhengxiang9@huawei.com> wrote:
>>
>> From: Dongjiu Geng <gengdongjiu@huawei.com>
>>
>> Add a SIGBUS signal handler. In this handler, it checks the SIGBUS type,
>> translates the host VA delivered by host to guest PA, then fills this PA
>> to guest APEI GHES memory, then notifies guest according to the SIGBUS
>> type.
>>
>> If guest accesses the poisoned memory, it generates Synchronous External
>> Abort(SEA). Then host kernel gets an APEI notification and calls
>> memory_failure() to unmapped the affected page in stage 2, finally
>> returns to guest.
>>
>> Guest continues to access PG_hwpoison page, it will trap to KVM as
>> stage2 fault, then a SIGBUS_MCEERR_AR synchronous signal is delivered to
>> Qemu, Qemu records this error address into guest APEI GHES memory and
>> notifes guest using Synchronous-External-Abort(SEA).
>>
>> Suggested-by: James Morse <james.morse@arm.com>
>> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
>> Signed-off-by: Xiang Zheng <zhengxiang9@huawei.com>
>> ---
>>  hw/acpi/acpi_ghes.c         | 252 ++++++++++++++++++++++++++++++++++++
>>  include/hw/acpi/acpi_ghes.h |  40 ++++++
>>  include/sysemu/kvm.h        |   2 +-
>>  target/arm/kvm64.c          |  39 ++++++
>>  4 files changed, 332 insertions(+), 1 deletion(-)
> 
> I'll let somebody else review the ACPI parts as that's not my
> area of expertise, but I'll look at the target/arm parts below:
> 
>> diff --git a/hw/acpi/acpi_ghes.c b/hw/acpi/acpi_ghes.c
>> index 20c45179ff..2d17c88045 100644
>> --- a/hw/acpi/acpi_ghes.c
>> +++ b/hw/acpi/acpi_ghes.c
>> @@ -26,6 +26,168 @@
>>  #include "sysemu/sysemu.h"
>>  #include "qemu/error-report.h"
>>
>> +/* Total size for Generic Error Status Block
> 
> This block comment should start with '/*' on a line of its own
> (as should others in this patch). Usually checkpatch catches these
> but it's not infallible.

Yes, checkpatch catches these and reports 'WARNING' informations. I will
clean up all these 'WARINIG's.

> 
>> diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
>> index 909bcd77cf..5f57e4ed43 100644
>> --- a/include/sysemu/kvm.h
>> +++ b/include/sysemu/kvm.h
>> @@ -378,7 +378,7 @@ bool kvm_vcpu_id_is_valid(int vcpu_id);
>>  /* Returns VCPU ID to be used on KVM_CREATE_VCPU ioctl() */
>>  unsigned long kvm_arch_vcpu_id(CPUState *cpu);
>>
>> -#ifdef TARGET_I386
>> +#if defined(TARGET_I386) || defined(TARGET_AARCH64)
>>  #define KVM_HAVE_MCE_INJECTION 1
>>  void kvm_arch_on_sigbus_vcpu(CPUState *cpu, int code, void *addr);
>>  #endif
> 
> Rather than introducing a new ifdef with lots of TARGET_*,
> I think it would be better to have target/i386/cpu.h and
> target/arm/cpu.h do "#define KVM_HAVE_MCE_INJECTION 1"
> (nb that the arm cpu.h needs to define it only for aarch64,
> not for 32-bit arm host compiles).
> 
> and then kvm.h can just do
> #ifdef KVM_HAVE_MCE_INJECTION
> void kvm_arch_on_sigbus_vcpu(CPUState *cpu, int code, void *addr);
> #endif

Yes, it's much better.

> 
>> diff --git a/target/arm/kvm64.c b/target/arm/kvm64.c
>> index bf6edaa3f6..186d855522 100644
>> --- a/target/arm/kvm64.c
>> +++ b/target/arm/kvm64.c
>> @@ -28,6 +28,8 @@
>>  #include "kvm_arm.h"
>>  #include "hw/boards.h"
>>  #include "internals.h"
>> +#include "hw/acpi/acpi.h"
>> +#include "hw/acpi/acpi_ghes.h"
>>
>>  static bool have_guest_debug;
>>
>> @@ -1070,6 +1072,43 @@ int kvm_arch_get_registers(CPUState *cs)
>>      return ret;
>>  }
>>
>> +void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr)
>> +{
>> +    ram_addr_t ram_addr;
>> +    hwaddr paddr;
>> +
>> +    assert(code == BUS_MCEERR_AR || code == BUS_MCEERR_AO);
>> +
>> +    if (acpi_enabled && addr &&
>> +            object_property_get_bool(qdev_get_machine(), "ras", NULL)) {
>> +        ram_addr = qemu_ram_addr_from_host(addr);
>> +        if (ram_addr != RAM_ADDR_INVALID &&
>> +            kvm_physical_memory_addr_from_host(c->kvm_state, addr, &paddr)) {
>> +            kvm_hwpoison_page_add(ram_addr);
>> +            /* Asynchronous signal will be masked by main thread, so
>> +             * only handle synchronous signal.
>> +             */
> 
> I don't entirely understand this comment. The x86 version
> of this function says:
> 
>     /* If we get an action required MCE, it has been injected by KVM
>      * while the VM was running.  An action optional MCE instead should
>      * be coming from the main thread, which qemu_init_sigbus identifies
>      * as the "early kill" thread.
>      */

This comment also applies to the Arm KVM.

> 
> so we can be called for action-optional MCE here (not on the vcpu
> thread). We obviously can't deliver those as a synchronous exception
> to a particular CPU, but is there no mechanism for reporting them
> to the guest at all?

On the one hand, the AO MCE/SEI cannot be recovered by the guest. On the other hand,
the SIGBUS signal is masked by qemu main thread[1]. Thus we only deliver a SEA to the
target vCPU.

[1] https://lists.gnu.org/archive/html/qemu-devel/2017-11/msg03575.html.

> 
>> +            if (code == BUS_MCEERR_AR) {
>> +                kvm_cpu_synchronize_state(c);
>> +                if (ACPI_GHES_CPER_FAIL !=
>> +                    acpi_ghes_record_errors(ACPI_GHES_NOTIFY_SEA, paddr)) {
>> +                    kvm_inject_arm_sea(c);
>> +                } else {
>> +                    fprintf(stderr, "failed to record the error\n");
>> +                }
>> +            }
>> +            return;
>> +        }
>> +        fprintf(stderr, "Hardware memory error for memory used by "
>> +                "QEMU itself instead of guest system!\n");
>> +    }
>> +
>> +    if (code == BUS_MCEERR_AR) {
>> +        fprintf(stderr, "Hardware memory error!\n");
>> +        exit(1);
>> +    }
>> +}
>> +
>>  /* C6.6.29 BRK instruction */
>>  static const uint32_t brk_insn = 0xd4200000;
>>
> 
> thanks
> -- PMM
> 
> .
> 

-- 

Thanks,
Xiang

