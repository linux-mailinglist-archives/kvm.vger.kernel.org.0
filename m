Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5E4312AAF5
	for <lists+kvm@lfdr.de>; Thu, 26 Dec 2019 09:34:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726425AbfLZIeB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Dec 2019 03:34:01 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:2917 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725878AbfLZIeB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Dec 2019 03:34:01 -0500
Received: from DGGEMM404-HUB.china.huawei.com (unknown [172.30.72.56])
        by Forcepoint Email with ESMTP id 6735E18ECE6BEEBE7A1E;
        Thu, 26 Dec 2019 16:33:57 +0800 (CST)
Received: from dggeme755-chm.china.huawei.com (10.3.19.101) by
 DGGEMM404-HUB.china.huawei.com (10.3.20.212) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 26 Dec 2019 16:33:31 +0800
Received: from [127.0.0.1] (10.173.221.248) by dggeme755-chm.china.huawei.com
 (10.3.19.101) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Thu, 26
 Dec 2019 16:33:30 +0800
Subject: Re: [PATCH 3/5] KVM: arm64: Support pvlock preempted via shared
 structure
To:     Steven Price <steven.price@arm.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "maz@kernel.org" <maz@kernel.org>,
        James Morse <James.Morse@arm.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        Suzuki Poulose <Suzuki.Poulose@arm.com>,
        "julien.thierry.kdev@gmail.com" <julien.thierry.kdev@gmail.com>,
        "Catalin Marinas" <Catalin.Marinas@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>
References: <20191217135549.3240-1-yezengruan@huawei.com>
 <20191217135549.3240-4-yezengruan@huawei.com>
 <20191217143301.GC38811@arm.com>
From:   yezengruan <yezengruan@huawei.com>
Message-ID: <31f9d0b2-1366-26f9-2628-61583fb4a50d@huawei.com>
Date:   Thu, 26 Dec 2019 16:33:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20191217143301.GC38811@arm.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.221.248]
X-ClientProxiedBy: dggeme719-chm.china.huawei.com (10.1.199.115) To
 dggeme755-chm.china.huawei.com (10.3.19.101)
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Steve,

On 2019/12/17 22:33, Steven Price wrote:
> On Tue, Dec 17, 2019 at 01:55:47PM +0000, yezengruan@huawei.com wrote:
>> From: Zengruan Ye <yezengruan@huawei.com>
>>
>> Implement the service call for configuring a shared structure between a
>> vcpu and the hypervisor in which the hypervisor can tell the vcpu is
>> running or not.
>>
>> The preempted field is zero if 1) some old KVM deos not support this filed.
>> 2) the vcpu is not preempted. Other values means the vcpu has been preempted.
>>
>> Signed-off-by: Zengruan Ye <yezengruan@huawei.com>
>> ---
>>  arch/arm/include/asm/kvm_host.h   | 13 +++++++++++++
>>  arch/arm64/include/asm/kvm_host.h | 17 +++++++++++++++++
>>  arch/arm64/kvm/Makefile           |  1 +
>>  virt/kvm/arm/arm.c                |  8 ++++++++
>>  virt/kvm/arm/hypercalls.c         |  4 ++++
>>  virt/kvm/arm/pvlock.c             | 21 +++++++++++++++++++++
>>  6 files changed, 64 insertions(+)
>>  create mode 100644 virt/kvm/arm/pvlock.c
>>
>> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
>> index 556cd818eccf..098375f1c89e 100644
>> --- a/arch/arm/include/asm/kvm_host.h
>> +++ b/arch/arm/include/asm/kvm_host.h
>> @@ -356,6 +356,19 @@ static inline bool kvm_arm_is_pvtime_enabled(struct kvm_vcpu_arch *vcpu_arch)
>>  	return false;
>>  }
>>  
>> +static inline void kvm_arm_pvlock_preempted_init(struct kvm_vcpu_arch *vcpu_arch)
>> +{
>> +}
>> +
>> +static inline bool kvm_arm_is_pvlock_preempted_ready(struct kvm_vcpu_arch *vcpu_arch)
>> +{
>> +	return false;
>> +}
>> +
>> +static inline void kvm_update_pvlock_preempted(struct kvm_vcpu *vcpu, u64 preempted)
>> +{
>> +}
>> +
>>  void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot);
>>  
>>  struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr);
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>> index c61260cf63c5..d9b2a21a87ac 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -354,6 +354,11 @@ struct kvm_vcpu_arch {
>>  		u64 last_steal;
>>  		gpa_t base;
>>  	} steal;
>> +
>> +	/* Guest PV lock state */
>> +	struct {
>> +		gpa_t base;
>> +	} pv;
>>  };
>>  
>>  /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
>> @@ -515,6 +520,18 @@ static inline bool kvm_arm_is_pvtime_enabled(struct kvm_vcpu_arch *vcpu_arch)
>>  	return (vcpu_arch->steal.base != GPA_INVALID);
>>  }
>>  
>> +static inline void kvm_arm_pvlock_preempted_init(struct kvm_vcpu_arch *vcpu_arch)
>> +{
>> +	vcpu_arch->pv.base = GPA_INVALID;
>> +}
>> +
>> +static inline bool kvm_arm_is_pvlock_preempted_ready(struct kvm_vcpu_arch *vcpu_arch)
>> +{
>> +	return (vcpu_arch->pv.base != GPA_INVALID);
>> +}
>> +
>> +void kvm_update_pvlock_preempted(struct kvm_vcpu *vcpu, u64 preempted);
>> +
>>  void kvm_set_sei_esr(struct kvm_vcpu *vcpu, u64 syndrome);
>>  
>>  struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr);
>> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
>> index 5ffbdc39e780..e4591f56d5f1 100644
>> --- a/arch/arm64/kvm/Makefile
>> +++ b/arch/arm64/kvm/Makefile
>> @@ -15,6 +15,7 @@ kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/arm.o $(KVM)/arm/mmu.o $(KVM)/arm/mmio.
>>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/psci.o $(KVM)/arm/perf.o
>>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/hypercalls.o
>>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/pvtime.o
>> +kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/pvlock.o
>>  
>>  kvm-$(CONFIG_KVM_ARM_HOST) += inject_fault.o regmap.o va_layout.o
>>  kvm-$(CONFIG_KVM_ARM_HOST) += hyp.o hyp-init.o handle_exit.o
>> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
>> index 12e0280291ce..c562f62fdd45 100644
>> --- a/virt/kvm/arm/arm.c
>> +++ b/virt/kvm/arm/arm.c
>> @@ -383,6 +383,8 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
>>  
>>  	kvm_arm_pvtime_vcpu_init(&vcpu->arch);
>>  
>> +	kvm_arm_pvlock_preempted_init(&vcpu->arch);
>> +
>>  	return kvm_vgic_vcpu_init(vcpu);
>>  }
>>  
>> @@ -421,6 +423,9 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>>  		vcpu_set_wfx_traps(vcpu);
>>  
>>  	vcpu_ptrauth_setup_lazy(vcpu);
>> +
>> +	if (kvm_arm_is_pvlock_preempted_ready(&vcpu->arch))
>> +		kvm_update_pvlock_preempted(vcpu, 0);
>>  }
>>  
>>  void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>> @@ -434,6 +439,9 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>>  	vcpu->cpu = -1;
>>  
>>  	kvm_arm_set_running_vcpu(NULL);
>> +
>> +	if (kvm_arm_is_pvlock_preempted_ready(&vcpu->arch))
>> +		kvm_update_pvlock_preempted(vcpu, 1);
>>  }
>>  
>>  static void vcpu_power_off(struct kvm_vcpu *vcpu)
>> diff --git a/virt/kvm/arm/hypercalls.c b/virt/kvm/arm/hypercalls.c
>> index ff13871fd85a..5964982ccd05 100644
>> --- a/virt/kvm/arm/hypercalls.c
>> +++ b/virt/kvm/arm/hypercalls.c
>> @@ -65,6 +65,10 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>>  		if (gpa != GPA_INVALID)
>>  			val = gpa;
>>  		break;
>> +	case ARM_SMCCC_HV_PV_LOCK_PREEMPTED:
>> +		vcpu->arch.pv.base = smccc_get_arg1(vcpu);
>> +		val = SMCCC_RET_SUCCESS;
> 
> It would be useful to at least do some basic validation that the address
> passed in is valid. Debugging problems with this interface will be hard
> if it always returns success even if the address cannot be used.
> 
> The second patch also states that the structure should be 64 byte
> aligned, but there's nothing here to enforce that.

Thanks for posting this. I'll update the code.

> 
> Steve
> 
>> +		break;
>>  	default:
>>  		return kvm_psci_call(vcpu);
>>  	}
>> diff --git a/virt/kvm/arm/pvlock.c b/virt/kvm/arm/pvlock.c
>> new file mode 100644
>> index 000000000000..c3464958b0f5
>> --- /dev/null
>> +++ b/virt/kvm/arm/pvlock.c
>> @@ -0,0 +1,21 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>> +/*
>> + * Copyright(c) 2019 Huawei Technologies Co., Ltd
>> + * Author: Zengruan Ye <yezengruan@huawei.com>
>> + */
>> +
>> +#include <linux/arm-smccc.h>
>> +#include <linux/kvm_host.h>
>> +
>> +#include <kvm/arm_hypercalls.h>
>> +
>> +void kvm_update_pvlock_preempted(struct kvm_vcpu *vcpu, u64 preempted)
>> +{
>> +	u64 preempted_le;
>> +	u64 base;
>> +	struct kvm *kvm = vcpu->kvm;
>> +
>> +	base = vcpu->arch.pv.base;
>> +	preempted_le = cpu_to_le64(preempted);
>> +	kvm_put_guest(kvm, base, preempted_le, u64);
>> +}
>> -- 
>> 2.19.1
>>
>>
> 
> .
> 

Thanks,

Zengruan

