Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7A33137C24
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2020 08:33:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728526AbgAKHdV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 11 Jan 2020 02:33:21 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:2923 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728501AbgAKHdV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 11 Jan 2020 02:33:21 -0500
Received: from DGGEMM401-HUB.china.huawei.com (unknown [172.30.72.56])
        by Forcepoint Email with ESMTP id 85B55B68251585DA7E47;
        Sat, 11 Jan 2020 15:33:19 +0800 (CST)
Received: from dggeme755-chm.china.huawei.com (10.3.19.101) by
 DGGEMM401-HUB.china.huawei.com (10.3.20.209) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Sat, 11 Jan 2020 15:33:19 +0800
Received: from [127.0.0.1] (10.173.221.248) by dggeme755-chm.china.huawei.com
 (10.3.19.101) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Sat, 11
 Jan 2020 15:33:18 +0800
Subject: Re: [PATCH v2 6/6] KVM: arm64: Support the VCPU preemption check
To:     Steven Price <steven.price@arm.com>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        <linux-doc@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>
CC:     <maz@kernel.org>, <james.morse@arm.com>, <linux@armlinux.org.uk>,
        <suzuki.poulose@arm.com>, <julien.thierry.kdev@gmail.com>,
        <catalin.marinas@arm.com>, <mark.rutland@arm.com>,
        <will@kernel.org>, <daniel.lezcano@linaro.org>,
        "Wanghaibin (D)" <wanghaibin.wang@huawei.com>
References: <20191226135833.1052-1-yezengruan@huawei.com>
 <20191226135833.1052-7-yezengruan@huawei.com>
 <5a1f6745-2deb-253b-7022-f2725d8d40ba@arm.com>
From:   yezengruan <yezengruan@huawei.com>
Message-ID: <f746a436-e8da-d263-c4b8-e5b73366d8e4@huawei.com>
Date:   Sat, 11 Jan 2020 15:33:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <5a1f6745-2deb-253b-7022-f2725d8d40ba@arm.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.221.248]
X-ClientProxiedBy: dggeme701-chm.china.huawei.com (10.1.199.97) To
 dggeme755-chm.china.huawei.com (10.3.19.101)
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Steve,

On 2020/1/9 23:09, Steven Price wrote:
> On 26/12/2019 13:58, Zengruan Ye wrote:
>> Support the vcpu_is_preempted() functionality under KVM/arm64. This will
>> enhance lock performance on overcommitted hosts (more runnable VCPUs
>> than physical CPUs in the system) as doing busy waits for preempted
>> VCPUs will hurt system performance far worse than early yielding.
>>
>> unix benchmark result:
>>    host:  kernel 5.5.0-rc1, HiSilicon Kunpeng920, 8 CPUs
>>    guest: kernel 5.5.0-rc1, 16 VCPUs
>>
>>                 test-case                |    after-patch    |   before-patch
>> ----------------------------------------+-------------------+------------------
>>   Dhrystone 2 using register variables   | 334600751.0 lps   | 335319028.3 lps
>>   Double-Precision Whetstone             |     32856.1 MWIPS |     32849.6 MWIPS
>>   Execl Throughput                       |      3662.1 lps   |      2718.0 lps
>>   File Copy 1024 bufsize 2000 maxblocks  |    432906.4 KBps  |    158011.8 KBps
>>   File Copy 256 bufsize 500 maxblocks    |    116023.0 KBps  |     37664.0 KBps
>>   File Copy 4096 bufsize 8000 maxblocks  |   1432769.8 KBps  |    441108.8 KBps
>>   Pipe Throughput                        |   6405029.6 lps   |   6021457.6 lps
>>   Pipe-based Context Switching           |    185872.7 lps   |    184255.3 lps
>>   Process Creation                       |      4025.7 lps   |      3706.6 lps
>>   Shell Scripts (1 concurrent)           |      6745.6 lpm   |      6436.1 lpm
>>   Shell Scripts (8 concurrent)           |       998.7 lpm   |       931.1 lpm
>>   System Call Overhead                   |   3913363.1 lps   |   3883287.8 lps
>> ----------------------------------------+-------------------+------------------
>>   System Benchmarks Index Score          |      1835.1       |      1327.6
>>
>> Signed-off-by: Zengruan Ye <yezengruan@huawei.com>
>> ---
>>   arch/arm64/include/asm/paravirt.h |   3 +
>>   arch/arm64/kernel/paravirt.c      | 117 ++++++++++++++++++++++++++++++
>>   arch/arm64/kernel/setup.c         |   2 +
>>   include/linux/cpuhotplug.h        |   1 +
>>   4 files changed, 123 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/paravirt.h b/arch/arm64/include/asm/paravirt.h
>> index 7b1c81b544bb..ca3a2c7881f3 100644
>> --- a/arch/arm64/include/asm/paravirt.h
>> +++ b/arch/arm64/include/asm/paravirt.h
>> @@ -29,6 +29,8 @@ static inline u64 paravirt_steal_clock(int cpu)
>>     int __init pv_time_init(void);
>>   +int __init pv_lock_init(void);
>> +
>>   __visible bool __native_vcpu_is_preempted(int cpu);
>>     static inline bool pv_vcpu_is_preempted(int cpu)
>> @@ -39,6 +41,7 @@ static inline bool pv_vcpu_is_preempted(int cpu)
>>   #else
>>     #define pv_time_init() do {} while (0)
>> +#define pv_lock_init() do {} while (0)
>>     #endif // CONFIG_PARAVIRT
>>   diff --git a/arch/arm64/kernel/paravirt.c b/arch/arm64/kernel/paravirt.c
>> index d8f1ba8c22ce..bd2ad6a17a26 100644
>> --- a/arch/arm64/kernel/paravirt.c
>> +++ b/arch/arm64/kernel/paravirt.c
>> @@ -22,6 +22,7 @@
>>   #include <asm/paravirt.h>
>>   #include <asm/pvclock-abi.h>
>>   #include <asm/smp_plat.h>
>> +#include <asm/pvlock-abi.h>
>>     struct static_key paravirt_steal_enabled;
>>   struct static_key paravirt_steal_rq_enabled;
>> @@ -35,6 +36,10 @@ struct pv_time_stolen_time_region {
>>       struct pvclock_vcpu_stolen_time *kaddr;
>>   };
>>   +struct pv_lock_state_region {
>> +    struct pvlock_vcpu_state *kaddr;
>> +};
>> +
>>   static DEFINE_PER_CPU(struct pv_time_stolen_time_region, stolen_time_region);
>>     static bool steal_acc = true;
>> @@ -158,3 +163,115 @@ int __init pv_time_init(void)
>>         return 0;
>>   }
>> +
>> +static DEFINE_PER_CPU(struct pv_lock_state_region, lock_state_region);
>> +
>> +static bool kvm_vcpu_is_preempted(int cpu)
>> +{
>> +    struct pv_lock_state_region *reg;
>> +    __le64 preempted_le;
>> +
>> +    reg = per_cpu_ptr(&lock_state_region, cpu);
>> +    if (!reg->kaddr) {
>> +        pr_warn_once("PV lock enabled but not configured for cpu %d\n",
>> +                 cpu);
>> +        return false;
>> +    }
>> +
>> +    preempted_le = le64_to_cpu(READ_ONCE(reg->kaddr->preempted));
>> +
>> +    return !!(preempted_le & 1);
> 
> According to the documentation preempted != 0 means preempted, but here you are checking the LSB. You need to be consistent about the ABI.

Thanks for posting this. I'll update the code.

> 
>> +}
>> +
>> +static int pvlock_vcpu_state_dying_cpu(unsigned int cpu)
>> +{
>> +    struct pv_lock_state_region *reg;
>> +
>> +    reg = this_cpu_ptr(&lock_state_region);
>> +    if (!reg->kaddr)
>> +        return 0;
>> +
>> +    memunmap(reg->kaddr);
>> +    memset(reg, 0, sizeof(*reg));
>> +
>> +    return 0;
>> +}
>> +
>> +static int init_pvlock_vcpu_state(unsigned int cpu)
>> +{
>> +    struct pv_lock_state_region *reg;
>> +    struct arm_smccc_res res;
>> +
>> +    reg = this_cpu_ptr(&lock_state_region);
>> +
>> +    arm_smccc_1_1_invoke(ARM_SMCCC_HV_PV_LOCK_PREEMPTED, &res);
>> +
>> +    if (res.a0 == SMCCC_RET_NOT_SUPPORTED) {
>> +        pr_warn("Failed to init PV lock data structure\n");
>> +        return -EINVAL;
>> +    }
>> +
>> +    reg->kaddr = memremap(res.a0,
>> +                  sizeof(struct pvlock_vcpu_state),
>> +                  MEMREMAP_WB);
>> +
>> +    if (!reg->kaddr) {
>> +        pr_warn("Failed to map PV lock data structure\n");
>> +        return -ENOMEM;
>> +    }
>> +
>> +    return 0;
>> +}
>> +
>> +static int kvm_arm_init_pvlock(void)
>> +{
>> +    int ret;
>> +
>> +    ret = cpuhp_setup_state(CPUHP_AP_ARM_KVM_PVLOCK_STARTING,
>> +                "hypervisor/arm/pvlock:starting",
>> +                init_pvlock_vcpu_state,
>> +                pvlock_vcpu_state_dying_cpu);
>> +    if (ret < 0) {
>> +        pr_warn("PV-lock init failed\n");
>> +        return ret;
>> +    }
>> +
>> +    return 0;
>> +}
>> +
>> +static bool has_kvm_pvlock(void)
>> +{
>> +    struct arm_smccc_res res;
>> +
>> +    /* To detect the presence of PV lock support we require SMCCC 1.1+ */
>> +    if (psci_ops.smccc_version < SMCCC_VERSION_1_1)
>> +        return false;
>> +
>> +    arm_smccc_1_1_invoke(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
>> +                 ARM_SMCCC_HV_PV_LOCK_FEATURES, &res);
> 
> As mentioned previously we could do with something more robust to check that the hypervisor is actually KVM before assuming that vendor specific IDs are valid.

Will update next version.

> 
> Steve
> 
>> +
>> +    if (res.a0 != SMCCC_RET_SUCCESS)
>> +        return false;
>> +
>> +    return true;
>> +}
>> +
>> +int __init pv_lock_init(void)
>> +{
>> +    int ret;
>> +
>> +    if (is_hyp_mode_available())
>> +        return 0;
>> +
>> +    if (!has_kvm_pvlock())
>> +        return 0;
>> +
>> +    ret = kvm_arm_init_pvlock();
>> +    if (ret)
>> +        return ret;
>> +
>> +    pv_ops.lock.vcpu_is_preempted = kvm_vcpu_is_preempted;
>> +    pr_info("using PV-lock preempted\n");
>> +
>> +    return 0;
>> +}
>> diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
>> index 56f664561754..aa3a8b9e710f 100644
>> --- a/arch/arm64/kernel/setup.c
>> +++ b/arch/arm64/kernel/setup.c
>> @@ -341,6 +341,8 @@ void __init setup_arch(char **cmdline_p)
>>       smp_init_cpus();
>>       smp_build_mpidr_hash();
>>   +    pv_lock_init();
>> +
>>       /* Init percpu seeds for random tags after cpus are set up. */
>>       kasan_init_tags();
>>   diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
>> index e51ee772b9f5..f72ff95ab63a 100644
>> --- a/include/linux/cpuhotplug.h
>> +++ b/include/linux/cpuhotplug.h
>> @@ -138,6 +138,7 @@ enum cpuhp_state {
>>       CPUHP_AP_DUMMY_TIMER_STARTING,
>>       CPUHP_AP_ARM_XEN_STARTING,
>>       CPUHP_AP_ARM_KVMPV_STARTING,
>> +    CPUHP_AP_ARM_KVM_PVLOCK_STARTING,
>>       CPUHP_AP_ARM_CORESIGHT_STARTING,
>>       CPUHP_AP_ARM64_ISNDEP_STARTING,
>>       CPUHP_AP_SMPCFD_DYING,
>>
> 
> 
> .

Thanks,

Zengruan

