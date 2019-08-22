Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 904E099115
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2019 12:40:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731389AbfHVKkA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Aug 2019 06:40:00 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:33798 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726687AbfHVKj7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Aug 2019 06:39:59 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id E52FE60E25E38C112446;
        Thu, 22 Aug 2019 18:39:56 +0800 (CST)
Received: from localhost (10.202.226.61) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.439.0; Thu, 22 Aug 2019
 18:39:55 +0800
Date:   Thu, 22 Aug 2019 11:39:42 +0100
From:   Jonathan Cameron <jonathan.cameron@huawei.com>
To:     Steven Price <steven.price@arm.com>
CC:     Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>,
        "Mark Rutland" <mark.rutland@arm.com>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        Radim =?UTF-8?Q?Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Suzuki K Pouloze" <suzuki.poulose@arm.com>,
        <linux-doc@vger.kernel.org>,
        "Russell King" <linux@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: Re: [PATCH v3 05/10] KVM: arm64: Support stolen time reporting via
 shared structure
Message-ID: <20190822113942.0000701f@huawei.com>
In-Reply-To: <20190821153656.33429-6-steven.price@arm.com>
References: <20190821153656.33429-1-steven.price@arm.com>
        <20190821153656.33429-6-steven.price@arm.com>
Organization: Huawei
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.226.61]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 21 Aug 2019 16:36:51 +0100
Steven Price <steven.price@arm.com> wrote:

> Implement the service call for configuring a shared structure between a
> VCPU and the hypervisor in which the hypervisor can write the time
> stolen from the VCPU's execution time by other tasks on the host.
> 
> The hypervisor allocates memory which is placed at an IPA chosen by user
> space. The hypervisor then updates the shared structure using
> kvm_put_guest() to ensure single copy atomicity of the 64-bit value
> reporting the stolen time in nanoseconds.
> 
> Whenever stolen time is enabled by the guest, the stolen time counter is
> reset.
> 
> The stolen time itself is retrieved from the sched_info structure
> maintained by the Linux scheduler code. We enable SCHEDSTATS when
> selecting KVM Kconfig to ensure this value is meaningful.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>

One totally trivial comment inline... Feel free to ignore :)

> ---
>  arch/arm/include/asm/kvm_host.h   | 20 +++++++++
>  arch/arm64/include/asm/kvm_host.h | 25 +++++++++++-
>  arch/arm64/kvm/Kconfig            |  1 +
>  include/linux/kvm_types.h         |  2 +
>  virt/kvm/arm/arm.c                | 10 +++++
>  virt/kvm/arm/hypercalls.c         |  3 ++
>  virt/kvm/arm/pvtime.c             | 67 +++++++++++++++++++++++++++++++
>  7 files changed, 127 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> index 369b5d2d54bf..47d2ced99421 100644
> --- a/arch/arm/include/asm/kvm_host.h
> +++ b/arch/arm/include/asm/kvm_host.h
> @@ -39,6 +39,7 @@
>  	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>  #define KVM_REQ_IRQ_PENDING	KVM_ARCH_REQ(1)
>  #define KVM_REQ_VCPU_RESET	KVM_ARCH_REQ(2)
> +#define KVM_REQ_RECORD_STEAL	KVM_ARCH_REQ(3)
>  
>  DECLARE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
>  
> @@ -329,6 +330,25 @@ static inline int kvm_hypercall_pv_features(struct kvm_vcpu *vcpu)
>  	return SMCCC_RET_NOT_SUPPORTED;
>  }
>  
> +static inline int kvm_hypercall_stolen_time(struct kvm_vcpu *vcpu)
> +{
> +	return SMCCC_RET_NOT_SUPPORTED;
> +}
> +
> +static inline int kvm_update_stolen_time(struct kvm_vcpu *vcpu, bool init)
> +{
> +	return -ENOTSUPP;
> +}
> +
> +static inline void kvm_pvtime_init_vm(struct kvm_arch *kvm_arch)
> +{
> +}
> +
> +static inline bool kvm_is_pvtime_enabled(struct kvm_arch *kvm_arch)
> +{
> +	return false;
> +}
> +
>  void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot);
>  
>  struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr);
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 583b3639062a..b6fa7beffd8a 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -44,6 +44,7 @@
>  	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>  #define KVM_REQ_IRQ_PENDING	KVM_ARCH_REQ(1)
>  #define KVM_REQ_VCPU_RESET	KVM_ARCH_REQ(2)
> +#define KVM_REQ_RECORD_STEAL	KVM_ARCH_REQ(3)
>  
>  DECLARE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
>  
> @@ -83,6 +84,11 @@ struct kvm_arch {
>  
>  	/* Mandated version of PSCI */
>  	u32 psci_version;
> +
> +	struct kvm_arch_pvtime {
> +		gpa_t st_base;
> +		u64 st_size;
> +	} pvtime;
>  };
>  
>  #define KVM_NR_MEM_OBJS     40
> @@ -338,8 +344,13 @@ struct kvm_vcpu_arch {
>  	/* True when deferrable sysregs are loaded on the physical CPU,
>  	 * see kvm_vcpu_load_sysregs and kvm_vcpu_put_sysregs. */
>  	bool sysregs_loaded_on_cpu;
> -};
>  
> +	/* Guest PV state */
> +	struct {
> +		u64 steal;
> +		u64 last_steal;
> +	} steal;
> +};
>  /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
>  #define vcpu_sve_pffr(vcpu) ((void *)((char *)((vcpu)->arch.sve_state) + \
>  				      sve_ffr_offset((vcpu)->arch.sve_max_vl)))
> @@ -479,6 +490,18 @@ int kvm_perf_init(void);
>  int kvm_perf_teardown(void);
>  
>  int kvm_hypercall_pv_features(struct kvm_vcpu *vcpu);
> +int kvm_hypercall_stolen_time(struct kvm_vcpu *vcpu);
> +int kvm_update_stolen_time(struct kvm_vcpu *vcpu, bool init);
> +
> +static inline void kvm_pvtime_init_vm(struct kvm_arch *kvm_arch)
> +{
> +	kvm_arch->pvtime.st_base = GPA_INVALID;
> +}
> +
> +static inline bool kvm_is_pvtime_enabled(struct kvm_arch *kvm_arch)
> +{
> +	return (kvm_arch->pvtime.st_base != GPA_INVALID);
> +}
>  
>  void kvm_set_sei_esr(struct kvm_vcpu *vcpu, u64 syndrome);
>  
> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> index a67121d419a2..d8b88e40d223 100644
> --- a/arch/arm64/kvm/Kconfig
> +++ b/arch/arm64/kvm/Kconfig
> @@ -39,6 +39,7 @@ config KVM
>  	select IRQ_BYPASS_MANAGER
>  	select HAVE_KVM_IRQ_BYPASS
>  	select HAVE_KVM_VCPU_RUN_PID_CHANGE
> +	select SCHEDSTATS
>  	---help---
>  	  Support hosting virtualized guest machines.
>  	  We don't support KVM with 16K page tables yet, due to the multiple
> diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
> index bde5374ae021..1c88e69db3d9 100644
> --- a/include/linux/kvm_types.h
> +++ b/include/linux/kvm_types.h
> @@ -35,6 +35,8 @@ typedef unsigned long  gva_t;
>  typedef u64            gpa_t;
>  typedef u64            gfn_t;
>  
> +#define GPA_INVALID	(~(gpa_t)0)
> +
>  typedef unsigned long  hva_t;
>  typedef u64            hpa_t;
>  typedef u64            hfn_t;
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index 35a069815baf..5e8343e2dd62 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -40,6 +40,10 @@
>  #include <asm/kvm_coproc.h>
>  #include <asm/sections.h>
>  
> +#include <kvm/arm_hypercalls.h>
> +#include <kvm/arm_pmu.h>
> +#include <kvm/arm_psci.h>
> +
>  #ifdef REQUIRES_VIRT
>  __asm__(".arch_extension	virt");
>  #endif
> @@ -135,6 +139,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>  	kvm->arch.max_vcpus = vgic_present ?
>  				kvm_vgic_get_max_vcpus() : KVM_MAX_VCPUS;
>  
> +	kvm_pvtime_init_vm(&kvm->arch);
>  	return ret;
>  out_free_stage2_pgd:
>  	kvm_free_stage2_pgd(kvm);
> @@ -379,6 +384,8 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  	kvm_vcpu_load_sysregs(vcpu);
>  	kvm_arch_vcpu_load_fp(vcpu);
>  	kvm_vcpu_pmu_restore_guest(vcpu);
> +	if (kvm_is_pvtime_enabled(&vcpu->kvm->arch))
> +		kvm_make_request(KVM_REQ_RECORD_STEAL, vcpu);
>  
>  	if (single_task_running())
>  		vcpu_clear_wfe_traps(vcpu);
> @@ -644,6 +651,9 @@ static void check_vcpu_requests(struct kvm_vcpu *vcpu)
>  		 * that a VCPU sees new virtual interrupts.
>  		 */
>  		kvm_check_request(KVM_REQ_IRQ_PENDING, vcpu);
> +
> +		if (kvm_check_request(KVM_REQ_RECORD_STEAL, vcpu))
> +			kvm_update_stolen_time(vcpu, false);
>  	}
>  }
>  
> diff --git a/virt/kvm/arm/hypercalls.c b/virt/kvm/arm/hypercalls.c
> index 63ae629c466a..ac678eabf15f 100644
> --- a/virt/kvm/arm/hypercalls.c
> +++ b/virt/kvm/arm/hypercalls.c
> @@ -56,6 +56,9 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>  	case ARM_SMCCC_HV_PV_FEATURES:
>  		val = kvm_hypercall_pv_features(vcpu);
>  		break;
> +	case ARM_SMCCC_HV_PV_TIME_ST:
> +		val = kvm_hypercall_stolen_time(vcpu);
> +		break;
>  	default:
>  		return kvm_psci_call(vcpu);
>  	}
> diff --git a/virt/kvm/arm/pvtime.c b/virt/kvm/arm/pvtime.c
> index 6201d71cb1f8..28603689f6e0 100644
> --- a/virt/kvm/arm/pvtime.c
> +++ b/virt/kvm/arm/pvtime.c
> @@ -3,8 +3,51 @@
>  
>  #include <linux/arm-smccc.h>
>  
> +#include <asm/pvclock-abi.h>
> +
>  #include <kvm/arm_hypercalls.h>
>  
> +int kvm_update_stolen_time(struct kvm_vcpu *vcpu, bool init)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +	struct kvm_arch_pvtime *pvtime = &kvm->arch.pvtime;
> +	u64 steal;
> +	u64 steal_le;
> +	u64 offset;
> +	int idx;
> +	const int stride = sizeof(struct pvclock_vcpu_stolen_time);
> +
> +	if (pvtime->st_base == GPA_INVALID)
> +		return -ENOTSUPP;
> +
> +	/* Let's do the local bookkeeping */
> +	steal = vcpu->arch.steal.steal;
> +	steal += current->sched_info.run_delay - vcpu->arch.steal.last_steal;
> +	vcpu->arch.steal.last_steal = current->sched_info.run_delay;
> +	vcpu->arch.steal.steal = steal;
> +
> +	offset = stride * kvm_vcpu_get_idx(vcpu);
> +
> +	if (unlikely(offset + stride > pvtime->st_size))
> +		return -EINVAL;
> +
> +	steal_le = cpu_to_le64(steal);
> +	idx = srcu_read_lock(&kvm->srcu);
> +	if (init) {
> +		struct pvclock_vcpu_stolen_time init_values = {
> +			.revision = 0,
> +			.attributes = 0
> +		};
> +		kvm_write_guest(kvm, pvtime->st_base + offset, &init_values,
> +				sizeof(init_values));
> +	}
> +	offset += offsetof(struct pvclock_vcpu_stolen_time, stolen_time);
> +	kvm_put_guest(kvm, pvtime->st_base + offset, steal_le, u64);
> +	srcu_read_unlock(&kvm->srcu, idx);
> +
> +	return 0;
> +}
> +
>  int kvm_hypercall_pv_features(struct kvm_vcpu *vcpu)
>  {
>  	u32 feature = smccc_get_arg1(vcpu);
> @@ -12,6 +55,7 @@ int kvm_hypercall_pv_features(struct kvm_vcpu *vcpu)
>  
>  	switch (feature) {
>  	case ARM_SMCCC_HV_PV_FEATURES:
> +	case ARM_SMCCC_HV_PV_TIME_ST:
>  		val = SMCCC_RET_SUCCESS;
>  		break;
>  	}
> @@ -19,3 +63,26 @@ int kvm_hypercall_pv_features(struct kvm_vcpu *vcpu)
>  	return val;
>  }
>  
> +int kvm_hypercall_stolen_time(struct kvm_vcpu *vcpu)
> +{
> +	u64 ret;
> +	int err;
> +
> +	/*
> +	 * Start counting stolen time from the time the guest requests
> +	 * the feature enabled.
> +	 */
> +	vcpu->arch.steal.steal = 0;
> +	vcpu->arch.steal.last_steal = current->sched_info.run_delay;
> +
> +	err = kvm_update_stolen_time(vcpu, true);
> +
> +	if (err)
> +		ret = SMCCC_RET_NOT_SUPPORTED;

Trivial by why not
		return SMCCC_RET_NOT_SUPPORTED;

	return vcpu->kvm->arch.pvtime.st_base +
...
Drops the indentation a bit and puts the error handling out of
line which is slightly nicer to read (to my eyes).

> +	else
> +		ret = vcpu->kvm->arch.pvtime.st_base +
> +			(sizeof(struct pvclock_vcpu_stolen_time) *
> +			 kvm_vcpu_get_idx(vcpu));
> +
> +	return ret;
> +}


