Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F576137C21
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2020 08:31:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728558AbgAKHbW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 11 Jan 2020 02:31:22 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:2922 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728500AbgAKHbV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 11 Jan 2020 02:31:21 -0500
Received: from DGGEMM404-HUB.china.huawei.com (unknown [172.30.72.54])
        by Forcepoint Email with ESMTP id 9DB748B199B1D4CB891D;
        Sat, 11 Jan 2020 15:30:45 +0800 (CST)
Received: from dggeme755-chm.china.huawei.com (10.3.19.101) by
 DGGEMM404-HUB.china.huawei.com (10.3.20.212) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Sat, 11 Jan 2020 15:30:45 +0800
Received: from [127.0.0.1] (10.173.221.248) by dggeme755-chm.china.huawei.com
 (10.3.19.101) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Sat, 11
 Jan 2020 15:30:44 +0800
Subject: Re: [PATCH v2 3/6] KVM: arm64: Support pvlock preempted via shared
 structure
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
 <20191226135833.1052-4-yezengruan@huawei.com>
 <468e2bb4-8986-5e1e-8c4a-31aa56a9ae4f@arm.com>
From:   yezengruan <yezengruan@huawei.com>
Message-ID: <c479977c-3824-4b53-ef46-300d59ac35de@huawei.com>
Date:   Sat, 11 Jan 2020 15:30:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <468e2bb4-8986-5e1e-8c4a-31aa56a9ae4f@arm.com>
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

On 2020/1/9 23:02, Steven Price wrote:
> On 26/12/2019 13:58, Zengruan Ye wrote:
>> Implement the service call for configuring a shared structure between a
>> VCPU and the hypervisor in which the hypervisor can tell the VCPU is
>> running or not.
>>
>> The preempted field is zero if 1) some old KVM deos not support this filed.
> 
> NIT: s/deos/does/

Thanks for posting this.

> 
> However, I would hope that the service call will fail if it's an old KVM not simply return zero.

Sorry, I'm not sure what you mean. The service call will fail if it's an old KVM, and the Guest will use __native_vcpu_is_preempted.

> 
>> 2) the VCPU is not preempted. Other values means the VCPU has been preempted.
>>
>> Signed-off-by: Zengruan Ye <yezengruan@huawei.com>
>> ---
>>   arch/arm/include/asm/kvm_host.h   | 18 ++++++++++++
>>   arch/arm64/include/asm/kvm_host.h | 19 +++++++++++++
>>   arch/arm64/kvm/Makefile           |  1 +
>>   virt/kvm/arm/arm.c                |  8 ++++++
>>   virt/kvm/arm/hypercalls.c         |  8 ++++++
>>   virt/kvm/arm/pvlock.c             | 46 +++++++++++++++++++++++++++++++
>>   6 files changed, 100 insertions(+)
>>   create mode 100644 virt/kvm/arm/pvlock.c
>>
>> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
>> index 556cd818eccf..dfeaf9204875 100644
>> --- a/arch/arm/include/asm/kvm_host.h
>> +++ b/arch/arm/include/asm/kvm_host.h
>> @@ -356,6 +356,24 @@ static inline bool kvm_arm_is_pvtime_enabled(struct kvm_vcpu_arch *vcpu_arch)
>>       return false;
>>   }
>>   +static inline void kvm_arm_pvlock_preempted_init(struct kvm_vcpu_arch *vcpu_arch)
>> +{
>> +}
>> +
>> +static inline bool kvm_arm_is_pvlock_preempted_ready(struct kvm_vcpu_arch *vcpu_arch)
>> +{
>> +    return false;
>> +}
>> +
>> +static inline gpa_t kvm_init_pvlock(struct kvm_vcpu *vcpu)
>> +{
>> +    return GPA_INVALID;
>> +}
>> +
>> +static inline void kvm_update_pvlock_preempted(struct kvm_vcpu *vcpu, u64 preempted)
>> +{
>> +}
>> +
>>   void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot);
>>     struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr);
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>> index c61260cf63c5..2818a2330f92 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -354,6 +354,12 @@ struct kvm_vcpu_arch {
>>           u64 last_steal;
>>           gpa_t base;
>>       } steal;
>> +
>> +    /* Guest PV lock state */
>> +    struct {
>> +        u64 preempted;
> 
> I'm not sure why the kernel needs to (separately) track this preempted state? It doesn't appear to be used from what I can tell.

Good point, the preempted state field is not actually used, I'll remove it.

> 
> Steve
> 
>> +        gpa_t base;
>> +    } pv;
>>   };
>>     /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
>> @@ -515,6 +521,19 @@ static inline bool kvm_arm_is_pvtime_enabled(struct kvm_vcpu_arch *vcpu_arch)
>>       return (vcpu_arch->steal.base != GPA_INVALID);
>>   }
>>   +static inline void kvm_arm_pvlock_preempted_init(struct kvm_vcpu_arch *vcpu_arch)
>> +{
>> +    vcpu_arch->pv.base = GPA_INVALID;
>> +}
>> +
>> +static inline bool kvm_arm_is_pvlock_preempted_ready(struct kvm_vcpu_arch *vcpu_arch)
>> +{
>> +    return (vcpu_arch->pv.base != GPA_INVALID);
>> +}
>> +
>> +gpa_t kvm_init_pvlock(struct kvm_vcpu *vcpu);
>> +void kvm_update_pvlock_preempted(struct kvm_vcpu *vcpu, u64 preempted);
>> +
>>   void kvm_set_sei_esr(struct kvm_vcpu *vcpu, u64 syndrome);
>>     struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr);
>> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
>> index 5ffbdc39e780..e4591f56d5f1 100644
>> --- a/arch/arm64/kvm/Makefile
>> +++ b/arch/arm64/kvm/Makefile
>> @@ -15,6 +15,7 @@ kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/arm.o $(KVM)/arm/mmu.o $(KVM)/arm/mmio.
>>   kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/psci.o $(KVM)/arm/perf.o
>>   kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/hypercalls.o
>>   kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/pvtime.o
>> +kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/pvlock.o
>>     kvm-$(CONFIG_KVM_ARM_HOST) += inject_fault.o regmap.o va_layout.o
>>   kvm-$(CONFIG_KVM_ARM_HOST) += hyp.o hyp-init.o handle_exit.o
>> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
>> index 8de4daf25097..36d57e77d3c4 100644
>> --- a/virt/kvm/arm/arm.c
>> +++ b/virt/kvm/arm/arm.c
>> @@ -383,6 +383,8 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
>>         kvm_arm_pvtime_vcpu_init(&vcpu->arch);
>>   +    kvm_arm_pvlock_preempted_init(&vcpu->arch);
>> +
>>       return kvm_vgic_vcpu_init(vcpu);
>>   }
>>   @@ -421,6 +423,9 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>>           vcpu_set_wfx_traps(vcpu);
>>         vcpu_ptrauth_setup_lazy(vcpu);
>> +
>> +    if (kvm_arm_is_pvlock_preempted_ready(&vcpu->arch))
>> +        kvm_update_pvlock_preempted(vcpu, 0);
>>   }
>>     void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>> @@ -434,6 +439,9 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>>       vcpu->cpu = -1;
>>         kvm_arm_set_running_vcpu(NULL);
>> +
>> +    if (kvm_arm_is_pvlock_preempted_ready(&vcpu->arch))
>> +        kvm_update_pvlock_preempted(vcpu, 1);
>>   }
>>     static void vcpu_power_off(struct kvm_vcpu *vcpu)
>> diff --git a/virt/kvm/arm/hypercalls.c b/virt/kvm/arm/hypercalls.c
>> index 550dfa3e53cd..1c6a11f21bb4 100644
>> --- a/virt/kvm/arm/hypercalls.c
>> +++ b/virt/kvm/arm/hypercalls.c
>> @@ -52,6 +52,9 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>>           case ARM_SMCCC_HV_PV_TIME_FEATURES:
>>               val = SMCCC_RET_SUCCESS;
>>               break;
>> +        case ARM_SMCCC_HV_PV_LOCK_FEATURES:
>> +            val = SMCCC_RET_SUCCESS;
>> +            break;
>>           }
>>           break;
>>       case ARM_SMCCC_HV_PV_TIME_FEATURES:
>> @@ -62,6 +65,11 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>>           if (gpa != GPA_INVALID)
>>               val = gpa;
>>           break;
>> +    case ARM_SMCCC_HV_PV_LOCK_PREEMPTED:
>> +        gpa = kvm_init_pvlock(vcpu);
>> +        if (gpa != GPA_INVALID)
>> +            val = gpa;
>> +        break;
>>       default:
>>           return kvm_psci_call(vcpu);
>>       }
>> diff --git a/virt/kvm/arm/pvlock.c b/virt/kvm/arm/pvlock.c
>> new file mode 100644
>> index 000000000000..cdfd30a903b9
>> --- /dev/null
>> +++ b/virt/kvm/arm/pvlock.c
>> @@ -0,0 +1,46 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>> +/*
>> + * Copyright(c) 2019 Huawei Technologies Co., Ltd
>> + * Author: Zengruan Ye <yezengruan@huawei.com>
>> + */
>> +
>> +#include <linux/arm-smccc.h>
>> +#include <linux/kvm_host.h>
>> +
>> +#include <asm/pvlock-abi.h>
>> +
>> +#include <kvm/arm_hypercalls.h>
>> +
>> +gpa_t kvm_init_pvlock(struct kvm_vcpu *vcpu)
>> +{
>> +    struct pvlock_vcpu_state init_values = {};
>> +    struct kvm *kvm = vcpu->kvm;
>> +    u64 base = vcpu->arch.pv.base;
>> +    int idx;
>> +
>> +    if (base == GPA_INVALID)
>> +        return base;
>> +
>> +    idx = srcu_read_lock(&kvm->srcu);
>> +    kvm_write_guest(kvm, base, &init_values, sizeof(init_values));
>> +    srcu_read_unlock(&kvm->srcu, idx);
>> +
>> +    return base;
>> +}
>> +
>> +void kvm_update_pvlock_preempted(struct kvm_vcpu *vcpu, u64 preempted)
>> +{
>> +    int idx;
>> +    u64 offset;
>> +    __le64 preempted_le;
>> +    struct kvm *kvm = vcpu->kvm;
>> +    u64 base = vcpu->arch.pv.base;
>> +
>> +    vcpu->arch.pv.preempted = preempted;
>> +    preempted_le = cpu_to_le64(preempted);
>> +
>> +    idx = srcu_read_lock(&kvm->srcu);
>> +    offset = offsetof(struct pvlock_vcpu_state, preempted);
>> +    kvm_put_guest(kvm, base + offset, preempted_le, u64);
>> +    srcu_read_unlock(&kvm->srcu, idx);
>> +}
>>
> 
> 
> .

Thanks,

Zengruan

