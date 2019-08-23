Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C947E9B0AD
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2019 15:23:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732899AbfHWNXL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Aug 2019 09:23:11 -0400
Received: from foss.arm.com ([217.140.110.172]:34444 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726319AbfHWNXL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Aug 2019 09:23:11 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A8C3E28;
        Fri, 23 Aug 2019 06:23:09 -0700 (PDT)
Received: from [10.1.196.133] (e112269-lin.cambridge.arm.com [10.1.196.133])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 240BD3F718;
        Fri, 23 Aug 2019 06:23:08 -0700 (PDT)
Subject: Re: [PATCH v3 05/10] KVM: arm64: Support stolen time reporting via
 shared structure
To:     Zenghui Yu <yuzenghui@huawei.com>, Marc Zyngier <maz@kernel.org>,
        Will Deacon <will@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-doc@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20190821153656.33429-1-steven.price@arm.com>
 <20190821153656.33429-6-steven.price@arm.com>
 <d3c493f0-31e8-2334-0ac3-f27bfe9fa976@huawei.com>
From:   Steven Price <steven.price@arm.com>
Message-ID: <5c12ce80-0014-ff92-d6d1-08c81ee8f35b@arm.com>
Date:   Fri, 23 Aug 2019 14:23:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <d3c493f0-31e8-2334-0ac3-f27bfe9fa976@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/08/2019 13:07, Zenghui Yu wrote:
> Hi Steven,
> 
> Only one comment, at the bottom.
> 
> On 2019/8/21 23:36, Steven Price wrote:
>> Implement the service call for configuring a shared structure between a
>> VCPU and the hypervisor in which the hypervisor can write the time
>> stolen from the VCPU's execution time by other tasks on the host.
>>
>> The hypervisor allocates memory which is placed at an IPA chosen by user
>> space. The hypervisor then updates the shared structure using
>> kvm_put_guest() to ensure single copy atomicity of the 64-bit value
>> reporting the stolen time in nanoseconds.
>>
>> Whenever stolen time is enabled by the guest, the stolen time counter is
>> reset.
>>
>> The stolen time itself is retrieved from the sched_info structure
>> maintained by the Linux scheduler code. We enable SCHEDSTATS when
>> selecting KVM Kconfig to ensure this value is meaningful.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>>   arch/arm/include/asm/kvm_host.h   | 20 +++++++++
>>   arch/arm64/include/asm/kvm_host.h | 25 +++++++++++-
>>   arch/arm64/kvm/Kconfig            |  1 +
>>   include/linux/kvm_types.h         |  2 +
>>   virt/kvm/arm/arm.c                | 10 +++++
>>   virt/kvm/arm/hypercalls.c         |  3 ++
>>   virt/kvm/arm/pvtime.c             | 67 +++++++++++++++++++++++++++++++
>>   7 files changed, 127 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm/include/asm/kvm_host.h
>> b/arch/arm/include/asm/kvm_host.h
>> index 369b5d2d54bf..47d2ced99421 100644
>> --- a/arch/arm/include/asm/kvm_host.h
>> +++ b/arch/arm/include/asm/kvm_host.h
>> @@ -39,6 +39,7 @@
>>       KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>>   #define KVM_REQ_IRQ_PENDING    KVM_ARCH_REQ(1)
>>   #define KVM_REQ_VCPU_RESET    KVM_ARCH_REQ(2)
>> +#define KVM_REQ_RECORD_STEAL    KVM_ARCH_REQ(3)
>>     DECLARE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
>>   @@ -329,6 +330,25 @@ static inline int
>> kvm_hypercall_pv_features(struct kvm_vcpu *vcpu)
>>       return SMCCC_RET_NOT_SUPPORTED;
>>   }
>>   +static inline int kvm_hypercall_stolen_time(struct kvm_vcpu *vcpu)
>> +{
>> +    return SMCCC_RET_NOT_SUPPORTED;
>> +}
>> +
>> +static inline int kvm_update_stolen_time(struct kvm_vcpu *vcpu, bool
>> init)
>> +{
>> +    return -ENOTSUPP;
>> +}
>> +
>> +static inline void kvm_pvtime_init_vm(struct kvm_arch *kvm_arch)
>> +{
>> +}
>> +
>> +static inline bool kvm_is_pvtime_enabled(struct kvm_arch *kvm_arch)
>> +{
>> +    return false;
>> +}
>> +
>>   void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot);
>>     struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long
>> mpidr);
>> diff --git a/arch/arm64/include/asm/kvm_host.h
>> b/arch/arm64/include/asm/kvm_host.h
>> index 583b3639062a..b6fa7beffd8a 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -44,6 +44,7 @@
>>       KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>>   #define KVM_REQ_IRQ_PENDING    KVM_ARCH_REQ(1)
>>   #define KVM_REQ_VCPU_RESET    KVM_ARCH_REQ(2)
>> +#define KVM_REQ_RECORD_STEAL    KVM_ARCH_REQ(3)
>>     DECLARE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
>>   @@ -83,6 +84,11 @@ struct kvm_arch {
>>         /* Mandated version of PSCI */
>>       u32 psci_version;
>> +
>> +    struct kvm_arch_pvtime {
>> +        gpa_t st_base;
>> +        u64 st_size;
>> +    } pvtime;
>>   };
>>     #define KVM_NR_MEM_OBJS     40
>> @@ -338,8 +344,13 @@ struct kvm_vcpu_arch {
>>       /* True when deferrable sysregs are loaded on the physical CPU,
>>        * see kvm_vcpu_load_sysregs and kvm_vcpu_put_sysregs. */
>>       bool sysregs_loaded_on_cpu;
>> -};
>>   +    /* Guest PV state */
>> +    struct {
>> +        u64 steal;
>> +        u64 last_steal;
>> +    } steal;
>> +};
>>   /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
>>   #define vcpu_sve_pffr(vcpu) ((void *)((char
>> *)((vcpu)->arch.sve_state) + \
>>                         sve_ffr_offset((vcpu)->arch.sve_max_vl)))
>> @@ -479,6 +490,18 @@ int kvm_perf_init(void);
>>   int kvm_perf_teardown(void);
>>     int kvm_hypercall_pv_features(struct kvm_vcpu *vcpu);
>> +int kvm_hypercall_stolen_time(struct kvm_vcpu *vcpu);
>> +int kvm_update_stolen_time(struct kvm_vcpu *vcpu, bool init);
>> +
>> +static inline void kvm_pvtime_init_vm(struct kvm_arch *kvm_arch)
>> +{
>> +    kvm_arch->pvtime.st_base = GPA_INVALID;
>> +}
>> +
>> +static inline bool kvm_is_pvtime_enabled(struct kvm_arch *kvm_arch)
>> +{
>> +    return (kvm_arch->pvtime.st_base != GPA_INVALID);
>> +}
>>     void kvm_set_sei_esr(struct kvm_vcpu *vcpu, u64 syndrome);
>>   diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
>> index a67121d419a2..d8b88e40d223 100644
>> --- a/arch/arm64/kvm/Kconfig
>> +++ b/arch/arm64/kvm/Kconfig
>> @@ -39,6 +39,7 @@ config KVM
>>       select IRQ_BYPASS_MANAGER
>>       select HAVE_KVM_IRQ_BYPASS
>>       select HAVE_KVM_VCPU_RUN_PID_CHANGE
>> +    select SCHEDSTATS
>>       ---help---
>>         Support hosting virtualized guest machines.
>>         We don't support KVM with 16K page tables yet, due to the
>> multiple
>> diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
>> index bde5374ae021..1c88e69db3d9 100644
>> --- a/include/linux/kvm_types.h
>> +++ b/include/linux/kvm_types.h
>> @@ -35,6 +35,8 @@ typedef unsigned long  gva_t;
>>   typedef u64            gpa_t;
>>   typedef u64            gfn_t;
>>   +#define GPA_INVALID    (~(gpa_t)0)
>> +
>>   typedef unsigned long  hva_t;
>>   typedef u64            hpa_t;
>>   typedef u64            hfn_t;
>> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
>> index 35a069815baf..5e8343e2dd62 100644
>> --- a/virt/kvm/arm/arm.c
>> +++ b/virt/kvm/arm/arm.c
>> @@ -40,6 +40,10 @@
>>   #include <asm/kvm_coproc.h>
>>   #include <asm/sections.h>
>>   +#include <kvm/arm_hypercalls.h>
>> +#include <kvm/arm_pmu.h>
>> +#include <kvm/arm_psci.h>
>> +
>>   #ifdef REQUIRES_VIRT
>>   __asm__(".arch_extension    virt");
>>   #endif
>> @@ -135,6 +139,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned
>> long type)
>>       kvm->arch.max_vcpus = vgic_present ?
>>                   kvm_vgic_get_max_vcpus() : KVM_MAX_VCPUS;
>>   +    kvm_pvtime_init_vm(&kvm->arch);
>>       return ret;
>>   out_free_stage2_pgd:
>>       kvm_free_stage2_pgd(kvm);
>> @@ -379,6 +384,8 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int
>> cpu)
>>       kvm_vcpu_load_sysregs(vcpu);
>>       kvm_arch_vcpu_load_fp(vcpu);
>>       kvm_vcpu_pmu_restore_guest(vcpu);
>> +    if (kvm_is_pvtime_enabled(&vcpu->kvm->arch))
>> +        kvm_make_request(KVM_REQ_RECORD_STEAL, vcpu);
>>         if (single_task_running())
>>           vcpu_clear_wfe_traps(vcpu);
>> @@ -644,6 +651,9 @@ static void check_vcpu_requests(struct kvm_vcpu
>> *vcpu)
>>            * that a VCPU sees new virtual interrupts.
>>            */
>>           kvm_check_request(KVM_REQ_IRQ_PENDING, vcpu);
>> +
>> +        if (kvm_check_request(KVM_REQ_RECORD_STEAL, vcpu))
>> +            kvm_update_stolen_time(vcpu, false);
>>       }
>>   }
>>   diff --git a/virt/kvm/arm/hypercalls.c b/virt/kvm/arm/hypercalls.c
>> index 63ae629c466a..ac678eabf15f 100644
>> --- a/virt/kvm/arm/hypercalls.c
>> +++ b/virt/kvm/arm/hypercalls.c
>> @@ -56,6 +56,9 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>>       case ARM_SMCCC_HV_PV_FEATURES:
>>           val = kvm_hypercall_pv_features(vcpu);
>>           break;
>> +    case ARM_SMCCC_HV_PV_TIME_ST:
>> +        val = kvm_hypercall_stolen_time(vcpu);
>> +        break;
>>       default:
>>           return kvm_psci_call(vcpu);
>>       }
>> diff --git a/virt/kvm/arm/pvtime.c b/virt/kvm/arm/pvtime.c
>> index 6201d71cb1f8..28603689f6e0 100644
>> --- a/virt/kvm/arm/pvtime.c
>> +++ b/virt/kvm/arm/pvtime.c
>> @@ -3,8 +3,51 @@
>>     #include <linux/arm-smccc.h>
>>   +#include <asm/pvclock-abi.h>
>> +
>>   #include <kvm/arm_hypercalls.h>
>>   +int kvm_update_stolen_time(struct kvm_vcpu *vcpu, bool init)
>> +{
>> +    struct kvm *kvm = vcpu->kvm;
>> +    struct kvm_arch_pvtime *pvtime = &kvm->arch.pvtime;
>> +    u64 steal;
>> +    u64 steal_le;
>> +    u64 offset;
>> +    int idx;
>> +    const int stride = sizeof(struct pvclock_vcpu_stolen_time);
>> +
>> +    if (pvtime->st_base == GPA_INVALID)
>> +        return -ENOTSUPP;
>> +
>> +    /* Let's do the local bookkeeping */
>> +    steal = vcpu->arch.steal.steal;
>> +    steal += current->sched_info.run_delay -
>> vcpu->arch.steal.last_steal;
>> +    vcpu->arch.steal.last_steal = current->sched_info.run_delay;
>> +    vcpu->arch.steal.steal = steal;
>> +
>> +    offset = stride * kvm_vcpu_get_idx(vcpu);
>> +
>> +    if (unlikely(offset + stride > pvtime->st_size))
>> +        return -EINVAL;
>> +
>> +    steal_le = cpu_to_le64(steal);
>> +    idx = srcu_read_lock(&kvm->srcu);
>> +    if (init) {
>> +        struct pvclock_vcpu_stolen_time init_values = {
>> +            .revision = 0,
>> +            .attributes = 0
>> +        };
>> +        kvm_write_guest(kvm, pvtime->st_base + offset, &init_values,
>> +                sizeof(init_values));
>> +    }
>> +    offset += offsetof(struct pvclock_vcpu_stolen_time, stolen_time);
>> +    kvm_put_guest(kvm, pvtime->st_base + offset, steal_le, u64);
>> +    srcu_read_unlock(&kvm->srcu, idx);
>> +
>> +    return 0;
>> +}
>> +
>>   int kvm_hypercall_pv_features(struct kvm_vcpu *vcpu)
>>   {
>>       u32 feature = smccc_get_arg1(vcpu);
>> @@ -12,6 +55,7 @@ int kvm_hypercall_pv_features(struct kvm_vcpu *vcpu)
>>         switch (feature) {
>>       case ARM_SMCCC_HV_PV_FEATURES:
>> +    case ARM_SMCCC_HV_PV_TIME_ST:
>>           val = SMCCC_RET_SUCCESS;
>>           break;
>>       }
>> @@ -19,3 +63,26 @@ int kvm_hypercall_pv_features(struct kvm_vcpu *vcpu)
>>       return val;
>>   }
>>   +int kvm_hypercall_stolen_time(struct kvm_vcpu *vcpu)
>> +{
>> +    u64 ret;
>> +    int err;
>> +
>> +    /*
>> +     * Start counting stolen time from the time the guest requests
>> +     * the feature enabled.
>> +     */
>> +    vcpu->arch.steal.steal = 0;
>> +    vcpu->arch.steal.last_steal = current->sched_info.run_delay;
>> +
>> +    err = kvm_update_stolen_time(vcpu, true);
>> +
>> +    if (err)
>> +        ret = SMCCC_RET_NOT_SUPPORTED;
>> +    else
>> +        ret = vcpu->kvm->arch.pvtime.st_base +
>> +            (sizeof(struct pvclock_vcpu_stolen_time) *
>> +             kvm_vcpu_get_idx(vcpu));
>> +
>> +    return ret;
> 
> The *type* of the 'ret' here looks a bit messy to me:
> (1)u64 -> (2)int -> (3)u32 -> (4)unsigned long
> 
> (1)->(2): just inside kvm_hypercall_stolen_time()
> (2)->(3): inside kvm_hvc_call_handler(), assign 'ret' to 'val'
> (3)->(4): through smccc_set_retval()
> 
> I really have seen an issue caused by (2)->(3).
> 
> When the PV guest running without PV_TIME device supporting, the result
> of the ARM_SMCCC_HV_PV_TIME_ST hypercall is expected to be -1 (which
> means "not supported"), but the actual result I got is 4294967295.
> Guest continues to run blindly, bad things would happen then...
> 
> I think this needs a fix?

Yes you are entirely right. I'm afraid this happened because I
refactored the functions and apparently forgot to update the return
type. In a previous version the functions themselves did
smccc_set_retval() themselves and the return value was always "1" (the
same as kvm_hvc_call_handler()).

The function should really return a "long" and "val" in
kvm_hvc_call_handler() should be upgraded to a "long" too - the
SMC64/HVC64 calling convention requires error codes to be 64-bit signed
integers.

Thanks for spotting this!

Steve
