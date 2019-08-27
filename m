Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C2749E842
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2019 14:46:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729834AbfH0MqE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Aug 2019 08:46:04 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5669 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726170AbfH0MqE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Aug 2019 08:46:04 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 041F6D3CA078F0D5976C;
        Tue, 27 Aug 2019 20:45:57 +0800 (CST)
Received: from [127.0.0.1] (10.184.12.158) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.439.0; Tue, 27 Aug 2019
 20:45:45 +0800
Subject: Re: [PATCH v3 10/10] arm64: Retrieve stolen time as paravirtualized
 guest
To:     Steven Price <steven.price@arm.com>, Marc Zyngier <maz@kernel.org>,
        "Will Deacon" <will@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>
CC:     <kvm@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Russell King <linux@armlinux.org.uk>,
        <linux-kernel@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
References: <20190821153656.33429-1-steven.price@arm.com>
 <20190821153656.33429-11-steven.price@arm.com>
 <6040a45c-fc39-a33e-c6a4-7baa586c247c@huawei.com>
 <29cd1304-6b4d-05ef-3c08-6b4ba769c8fa@arm.com>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <21c73195-4cf7-8e3f-f188-ba8bfcb4dd41@huawei.com>
Date:   Tue, 27 Aug 2019 20:43:40 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:64.0) Gecko/20100101
 Thunderbird/64.0
MIME-Version: 1.0
In-Reply-To: <29cd1304-6b4d-05ef-3c08-6b4ba769c8fa@arm.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.184.12.158]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2019/8/23 22:22, Steven Price wrote:
> On 23/08/2019 12:45, Zenghui Yu wrote:
>> Hi Steven,
>>
>> On 2019/8/21 23:36, Steven Price wrote:
>>> Enable paravirtualization features when running under a hypervisor
>>> supporting the PV_TIME_ST hypercall.
>>>
>>> For each (v)CPU, we ask the hypervisor for the location of a shared
>>> page which the hypervisor will use to report stolen time to us. We set
>>> pv_time_ops to the stolen time function which simply reads the stolen
>>> value from the shared page for a VCPU. We guarantee single-copy
>>> atomicity using READ_ONCE which means we can also read the stolen
>>> time for another VCPU than the currently running one while it is
>>> potentially being updated by the hypervisor.
>>>
>>> Signed-off-by: Steven Price <steven.price@arm.com>
>>> ---
>>>    arch/arm64/include/asm/paravirt.h |   9 +-
>>>    arch/arm64/kernel/paravirt.c      | 148 ++++++++++++++++++++++++++++++
>>>    arch/arm64/kernel/time.c          |   3 +
>>>    include/linux/cpuhotplug.h        |   1 +
>>>    4 files changed, 160 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arch/arm64/include/asm/paravirt.h
>>> b/arch/arm64/include/asm/paravirt.h
>>> index 799d9dd6f7cc..125c26c42902 100644
>>> --- a/arch/arm64/include/asm/paravirt.h
>>> +++ b/arch/arm64/include/asm/paravirt.h
>>> @@ -21,6 +21,13 @@ static inline u64 paravirt_steal_clock(int cpu)
>>>    {
>>>        return pv_ops.time.steal_clock(cpu);
>>>    }
>>> -#endif
>>> +
>>> +int __init kvm_guest_init(void);
>>> +
>>> +#else
>>> +
>>> +#define kvm_guest_init()
>>> +
>>> +#endif // CONFIG_PARAVIRT
>>>      #endif
>>> diff --git a/arch/arm64/kernel/paravirt.c b/arch/arm64/kernel/paravirt.c
>>> index 4cfed91fe256..ea8dbbbd3293 100644
>>> --- a/arch/arm64/kernel/paravirt.c
>>> +++ b/arch/arm64/kernel/paravirt.c
>>> @@ -6,13 +6,161 @@
>>>     * Author: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
>>>     */
>>>    +#define pr_fmt(fmt) "kvmarm-pv: " fmt
>>> +
>>> +#include <linux/arm-smccc.h>
>>> +#include <linux/cpuhotplug.h>
>>>    #include <linux/export.h>
>>> +#include <linux/io.h>
>>>    #include <linux/jump_label.h>
>>> +#include <linux/printk.h>
>>> +#include <linux/psci.h>
>>> +#include <linux/reboot.h>
>>> +#include <linux/slab.h>
>>>    #include <linux/types.h>
>>> +
>>>    #include <asm/paravirt.h>
>>> +#include <asm/pvclock-abi.h>
>>> +#include <asm/smp_plat.h>
>>>      struct static_key paravirt_steal_enabled;
>>>    struct static_key paravirt_steal_rq_enabled;
>>>      struct paravirt_patch_template pv_ops;
>>>    EXPORT_SYMBOL_GPL(pv_ops);
>>> +
>>> +struct kvmarm_stolen_time_region {
>>> +    struct pvclock_vcpu_stolen_time *kaddr;
>>> +};
>>> +
>>> +static DEFINE_PER_CPU(struct kvmarm_stolen_time_region,
>>> stolen_time_region);
>>> +
>>> +static bool steal_acc = true;
>>> +static int __init parse_no_stealacc(char *arg)
>>> +{
>>> +    steal_acc = false;
>>> +    return 0;
>>> +}
>>> +
>>> +early_param("no-steal-acc", parse_no_stealacc);
>>> +
>>> +/* return stolen time in ns by asking the hypervisor */
>>> +static u64 kvm_steal_clock(int cpu)
>>> +{
>>> +    struct kvmarm_stolen_time_region *reg;
>>> +
>>> +    reg = per_cpu_ptr(&stolen_time_region, cpu);
>>> +    if (!reg->kaddr) {
>>> +        pr_warn_once("stolen time enabled but not configured for cpu
>>> %d\n",
>>> +                 cpu);
>>> +        return 0;
>>> +    }
>>> +
>>> +    return le64_to_cpu(READ_ONCE(reg->kaddr->stolen_time));
>>> +}
>>> +
>>> +static int disable_stolen_time_current_cpu(void)
>>> +{
>>> +    struct kvmarm_stolen_time_region *reg;
>>> +
>>> +    reg = this_cpu_ptr(&stolen_time_region);
>>> +    if (!reg->kaddr)
>>> +        return 0;
>>> +
>>> +    memunmap(reg->kaddr);
>>> +    memset(reg, 0, sizeof(*reg));
>>> +
>>> +    return 0;
>>> +}
>>> +
>>> +static int stolen_time_dying_cpu(unsigned int cpu)
>>> +{
>>> +    return disable_stolen_time_current_cpu();
>>> +}
>>> +
>>> +static int init_stolen_time_cpu(unsigned int cpu)
>>> +{
>>> +    struct kvmarm_stolen_time_region *reg;
>>> +    struct arm_smccc_res res;
>>> +
>>> +    reg = this_cpu_ptr(&stolen_time_region);
>>> +
>>> +    arm_smccc_1_1_invoke(ARM_SMCCC_HV_PV_TIME_ST, &res);
>>> +
>>> +    if ((long)res.a0 < 0)
>>> +        return -EINVAL;
>>> +
>>> +    reg->kaddr = memremap(res.a0,
>>> +                  sizeof(struct pvclock_vcpu_stolen_time),
>>> +                  MEMREMAP_WB);
>>
>> cpuhp callbacks can be invoked in atomic context (see:
>>      secondary_start_kernel ->
>>      notify_cpu_starting ->
>>      invoke callbacks),
>> but memremap might sleep...
>>
>> Try to run a DEBUG_ATOMIC_SLEEP enabled PV guest, I guess we will be
>> greeted by the Sleep-in-Atomic-Context BUG.  We need an alternative
>> here?
> 
> Actually I had run DEBUG_ATOMIC_SLEEP and not seen any issue. But I
> think that's because of the way I've configured the region in my kvmtool
> changes. I'm hitting the path where the memory region is in the linear
> map of the kernel and so no actual remapping is needed and hence
> memremap doesn't sleep (the shared structure is in a reserved region of
> RAM).
> 
> But even changing the memory layout of the guest so the call goes into
> ioremap_page_range() (which contains a might_sleep()) I'm not seeing any
> problems.

Emm, I hit this SAC BUG when testing your V1 with the kvmtool changes
you've provided, but forgot to report it at that time.  I go back to V1
and get the following call trace:

[    0.120113] BUG: sleeping function called from invalid context at 
mm/slab.h:501
[    0.120118] in_atomic(): 1, irqs_disabled(): 128, pid: 0, name: swapper/1
[    0.120122] no locks held by swapper/1/0.
[    0.120126] irq event stamp: 0
[    0.120135] hardirqs last  enabled at (0): [<0000000000000000>] 0x0
[    0.120145] hardirqs last disabled at (0): [<ffff200010113b40>] 
copy_process+0x870/0x2878
[    0.120152] softirqs last  enabled at (0): [<ffff200010113b40>] 
copy_process+0x870/0x2878
[    0.120157] softirqs last disabled at (0): [<0000000000000000>] 0x0
[    0.120164] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.3.0-rc6+ #2
[    0.120168] Hardware name: linux,dummy-virt (DT)
[    0.120173] Call trace:
[    0.120179]  dump_backtrace+0x0/0x250
[    0.120184]  show_stack+0x24/0x30
[    0.120192]  dump_stack+0x120/0x174
[    0.120198]  ___might_sleep+0x1b0/0x280
[    0.120203]  __might_sleep+0x80/0xf0
[    0.120209]  kmem_cache_alloc_node_trace+0x30c/0x3c8
[    0.120216]  __get_vm_area_node+0x9c/0x208
[    0.120221]  get_vm_area_caller+0x58/0x68
[    0.120227]  __ioremap_caller+0x78/0x120
[    0.120233]  ioremap_cache+0xf0/0x1a8
[    0.120240]  memremap+0x154/0x3b8
[    0.120245]  init_stolen_time_cpu+0x94/0x150
[    0.120251]  cpuhp_invoke_callback+0x12c/0x12f8
[    0.120257]  notify_cpu_starting+0xa0/0xc0
[    0.120263]  secondary_start_kernel+0x1d4/0x328

But things may have changed because we're talking about V3 now...
I will dig it a bit deeper.

> Am I missing something? I have to admit I don't entirely follow the
> early start up - perhaps it's a simple as DEBUG_ATOMIC_SLEEP doesn't
> work this early in boot?

I think it should work.


Thanks,
zenghui

