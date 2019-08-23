Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15EB39B1D2
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2019 16:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395190AbfHWOWs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Aug 2019 10:22:48 -0400
Received: from foss.arm.com ([217.140.110.172]:35296 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731879AbfHWOWr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Aug 2019 10:22:47 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B9A4528;
        Fri, 23 Aug 2019 07:22:46 -0700 (PDT)
Received: from [10.1.196.133] (e112269-lin.cambridge.arm.com [10.1.196.133])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5606E3F718;
        Fri, 23 Aug 2019 07:22:45 -0700 (PDT)
From:   Steven Price <steven.price@arm.com>
Subject: Re: [PATCH v3 10/10] arm64: Retrieve stolen time as paravirtualized
 guest
To:     Zenghui Yu <yuzenghui@huawei.com>, Marc Zyngier <maz@kernel.org>,
        Will Deacon <will@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-doc@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20190821153656.33429-1-steven.price@arm.com>
 <20190821153656.33429-11-steven.price@arm.com>
 <6040a45c-fc39-a33e-c6a4-7baa586c247c@huawei.com>
Message-ID: <29cd1304-6b4d-05ef-3c08-6b4ba769c8fa@arm.com>
Date:   Fri, 23 Aug 2019 15:22:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <6040a45c-fc39-a33e-c6a4-7baa586c247c@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/08/2019 12:45, Zenghui Yu wrote:
> Hi Steven,
> 
> On 2019/8/21 23:36, Steven Price wrote:
>> Enable paravirtualization features when running under a hypervisor
>> supporting the PV_TIME_ST hypercall.
>>
>> For each (v)CPU, we ask the hypervisor for the location of a shared
>> page which the hypervisor will use to report stolen time to us. We set
>> pv_time_ops to the stolen time function which simply reads the stolen
>> value from the shared page for a VCPU. We guarantee single-copy
>> atomicity using READ_ONCE which means we can also read the stolen
>> time for another VCPU than the currently running one while it is
>> potentially being updated by the hypervisor.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>>   arch/arm64/include/asm/paravirt.h |   9 +-
>>   arch/arm64/kernel/paravirt.c      | 148 ++++++++++++++++++++++++++++++
>>   arch/arm64/kernel/time.c          |   3 +
>>   include/linux/cpuhotplug.h        |   1 +
>>   4 files changed, 160 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/include/asm/paravirt.h
>> b/arch/arm64/include/asm/paravirt.h
>> index 799d9dd6f7cc..125c26c42902 100644
>> --- a/arch/arm64/include/asm/paravirt.h
>> +++ b/arch/arm64/include/asm/paravirt.h
>> @@ -21,6 +21,13 @@ static inline u64 paravirt_steal_clock(int cpu)
>>   {
>>       return pv_ops.time.steal_clock(cpu);
>>   }
>> -#endif
>> +
>> +int __init kvm_guest_init(void);
>> +
>> +#else
>> +
>> +#define kvm_guest_init()
>> +
>> +#endif // CONFIG_PARAVIRT
>>     #endif
>> diff --git a/arch/arm64/kernel/paravirt.c b/arch/arm64/kernel/paravirt.c
>> index 4cfed91fe256..ea8dbbbd3293 100644
>> --- a/arch/arm64/kernel/paravirt.c
>> +++ b/arch/arm64/kernel/paravirt.c
>> @@ -6,13 +6,161 @@
>>    * Author: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
>>    */
>>   +#define pr_fmt(fmt) "kvmarm-pv: " fmt
>> +
>> +#include <linux/arm-smccc.h>
>> +#include <linux/cpuhotplug.h>
>>   #include <linux/export.h>
>> +#include <linux/io.h>
>>   #include <linux/jump_label.h>
>> +#include <linux/printk.h>
>> +#include <linux/psci.h>
>> +#include <linux/reboot.h>
>> +#include <linux/slab.h>
>>   #include <linux/types.h>
>> +
>>   #include <asm/paravirt.h>
>> +#include <asm/pvclock-abi.h>
>> +#include <asm/smp_plat.h>
>>     struct static_key paravirt_steal_enabled;
>>   struct static_key paravirt_steal_rq_enabled;
>>     struct paravirt_patch_template pv_ops;
>>   EXPORT_SYMBOL_GPL(pv_ops);
>> +
>> +struct kvmarm_stolen_time_region {
>> +    struct pvclock_vcpu_stolen_time *kaddr;
>> +};
>> +
>> +static DEFINE_PER_CPU(struct kvmarm_stolen_time_region,
>> stolen_time_region);
>> +
>> +static bool steal_acc = true;
>> +static int __init parse_no_stealacc(char *arg)
>> +{
>> +    steal_acc = false;
>> +    return 0;
>> +}
>> +
>> +early_param("no-steal-acc", parse_no_stealacc);
>> +
>> +/* return stolen time in ns by asking the hypervisor */
>> +static u64 kvm_steal_clock(int cpu)
>> +{
>> +    struct kvmarm_stolen_time_region *reg;
>> +
>> +    reg = per_cpu_ptr(&stolen_time_region, cpu);
>> +    if (!reg->kaddr) {
>> +        pr_warn_once("stolen time enabled but not configured for cpu
>> %d\n",
>> +                 cpu);
>> +        return 0;
>> +    }
>> +
>> +    return le64_to_cpu(READ_ONCE(reg->kaddr->stolen_time));
>> +}
>> +
>> +static int disable_stolen_time_current_cpu(void)
>> +{
>> +    struct kvmarm_stolen_time_region *reg;
>> +
>> +    reg = this_cpu_ptr(&stolen_time_region);
>> +    if (!reg->kaddr)
>> +        return 0;
>> +
>> +    memunmap(reg->kaddr);
>> +    memset(reg, 0, sizeof(*reg));
>> +
>> +    return 0;
>> +}
>> +
>> +static int stolen_time_dying_cpu(unsigned int cpu)
>> +{
>> +    return disable_stolen_time_current_cpu();
>> +}
>> +
>> +static int init_stolen_time_cpu(unsigned int cpu)
>> +{
>> +    struct kvmarm_stolen_time_region *reg;
>> +    struct arm_smccc_res res;
>> +
>> +    reg = this_cpu_ptr(&stolen_time_region);
>> +
>> +    arm_smccc_1_1_invoke(ARM_SMCCC_HV_PV_TIME_ST, &res);
>> +
>> +    if ((long)res.a0 < 0)
>> +        return -EINVAL;
>> +
>> +    reg->kaddr = memremap(res.a0,
>> +                  sizeof(struct pvclock_vcpu_stolen_time),
>> +                  MEMREMAP_WB);
> 
> cpuhp callbacks can be invoked in atomic context (see:
>     secondary_start_kernel ->
>     notify_cpu_starting ->
>     invoke callbacks),
> but memremap might sleep...
> 
> Try to run a DEBUG_ATOMIC_SLEEP enabled PV guest, I guess we will be
> greeted by the Sleep-in-Atomic-Context BUG.  We need an alternative
> here?

Actually I had run DEBUG_ATOMIC_SLEEP and not seen any issue. But I
think that's because of the way I've configured the region in my kvmtool
changes. I'm hitting the path where the memory region is in the linear
map of the kernel and so no actual remapping is needed and hence
memremap doesn't sleep (the shared structure is in a reserved region of
RAM).

But even changing the memory layout of the guest so the call goes into
ioremap_page_range() (which contains a might_sleep()) I'm not seeing any
problems.

Am I missing something? I have to admit I don't entirely follow the
early start up - perhaps it's a simple as DEBUG_ATOMIC_SLEEP doesn't
work this early in boot?

>> +
>> +    if (!reg->kaddr) {
>> +        pr_warn("Failed to map stolen time data structure\n");
>> +        return -ENOMEM;
>> +    }
>> +
>> +    if (le32_to_cpu(reg->kaddr->revision) != 0 ||
>> +        le32_to_cpu(reg->kaddr->attributes) != 0) {
>> +        pr_warn("Unexpected revision or attributes in stolen time
>> data\n");
>> +        return -ENXIO;
>> +    }
>> +
>> +    return 0;
>> +}
>> +
>> +static int kvm_arm_init_stolen_time(void)
>> +{
>> +    int ret;
>> +
>> +    ret = cpuhp_setup_state(CPUHP_AP_ARM_KVMPV_STARTING,
>> +                "hypervisor/kvmarm/pv:starting",
>> +                init_stolen_time_cpu, stolen_time_dying_cpu);
>> +    if (ret < 0)
>> +        return ret;
>> +    return 0;
>> +}
>> +
>> +static bool has_kvm_steal_clock(void)
>> +{
>> +    struct arm_smccc_res res;
>> +
>> +    /* To detect the presence of PV time support we require SMCCC
>> 1.1+ */
>> +    if (psci_ops.smccc_version < SMCCC_VERSION_1_1)
>> +        return false;
>> +
>> +    arm_smccc_1_1_invoke(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
>> +                 ARM_SMCCC_HV_PV_FEATURES, &res);
>> +
>> +    if (res.a0 != SMCCC_RET_SUCCESS)
>> +        return false;
>> +
>> +    arm_smccc_1_1_invoke(ARM_SMCCC_HV_PV_FEATURES,
>> +                 ARM_SMCCC_HV_PV_TIME_ST, &res);
>> +
>> +    if (res.a0 != SMCCC_RET_SUCCESS)
>> +        return false;
>> +
>> +    return true;
>> +}
>> +
>> +int __init kvm_guest_init(void)
>> +{
>> +    int ret = 0;
> 
> And this look like a redundant initialization?

Yes - that should go, thanks for spotting it.

Steve

> 
> 
> Thanks,
> zenghui
> 
>> +
>> +    if (!has_kvm_steal_clock())
>> +        return 0;
>> +
>> +    ret = kvm_arm_init_stolen_time();
>> +    if (ret)
>> +        return ret;
>> +
>> +    pv_ops.time.steal_clock = kvm_steal_clock;
>> +
>> +    static_key_slow_inc(&paravirt_steal_enabled);
>> +    if (steal_acc)
>> +        static_key_slow_inc(&paravirt_steal_rq_enabled);
>> +
>> +    pr_info("using stolen time PV\n");
>> +
>> +    return 0;
>> +}
>> diff --git a/arch/arm64/kernel/time.c b/arch/arm64/kernel/time.c
>> index 0b2946414dc9..a52aea14c6ec 100644
>> --- a/arch/arm64/kernel/time.c
>> +++ b/arch/arm64/kernel/time.c
>> @@ -30,6 +30,7 @@
>>     #include <asm/thread_info.h>
>>   #include <asm/stacktrace.h>
>> +#include <asm/paravirt.h>
>>     unsigned long profile_pc(struct pt_regs *regs)
>>   {
>> @@ -65,4 +66,6 @@ void __init time_init(void)
>>         /* Calibrate the delay loop directly */
>>       lpj_fine = arch_timer_rate / HZ;
>> +
>> +    kvm_guest_init();
>>   }
>> diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
>> index 068793a619ca..89d75edb5750 100644
>> --- a/include/linux/cpuhotplug.h
>> +++ b/include/linux/cpuhotplug.h
>> @@ -136,6 +136,7 @@ enum cpuhp_state {
>>       /* Must be the last timer callback */
>>       CPUHP_AP_DUMMY_TIMER_STARTING,
>>       CPUHP_AP_ARM_XEN_STARTING,
>> +    CPUHP_AP_ARM_KVMPV_STARTING,
>>       CPUHP_AP_ARM_CORESIGHT_STARTING,
>>       CPUHP_AP_ARM64_ISNDEP_STARTING,
>>       CPUHP_AP_SMPCFD_DYING,
>>
> 

