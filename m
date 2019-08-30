Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 539C1A344A
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2019 11:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727754AbfH3Jmt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Aug 2019 05:42:49 -0400
Received: from foss.arm.com ([217.140.110.172]:57484 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727417AbfH3Jms (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Aug 2019 05:42:48 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 722B4344;
        Fri, 30 Aug 2019 02:42:47 -0700 (PDT)
Received: from localhost (e113682-lin.copenhagen.arm.com [10.32.144.41])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 05BDD3F718;
        Fri, 30 Aug 2019 02:42:46 -0700 (PDT)
Date:   Fri, 30 Aug 2019 11:42:45 +0200
From:   Christoffer Dall <christoffer.dall@arm.com>
To:     Steven Price <steven.price@arm.com>
Cc:     Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-doc@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v4 05/10] KVM: arm64: Support stolen time reporting via
 shared structure
Message-ID: <20190830094245.GB5307@e113682-lin.lund.arm.com>
References: <20190830084255.55113-1-steven.price@arm.com>
 <20190830084255.55113-6-steven.price@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190830084255.55113-6-steven.price@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 30, 2019 at 09:42:50AM +0100, Steven Price wrote:
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
> ---
>  arch/arm/include/asm/kvm_host.h   | 20 +++++++++++
>  arch/arm64/include/asm/kvm_host.h | 21 +++++++++++-
>  arch/arm64/kvm/Kconfig            |  1 +
>  include/linux/kvm_types.h         |  2 ++
>  virt/kvm/arm/arm.c                | 11 ++++++
>  virt/kvm/arm/hypercalls.c         |  3 ++
>  virt/kvm/arm/pvtime.c             | 56 +++++++++++++++++++++++++++++++
>  7 files changed, 113 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> index 5a0c3569ebde..5c401482d62d 100644
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
> @@ -329,6 +330,25 @@ static inline long kvm_hypercall_pv_features(struct kvm_vcpu *vcpu)
>  	return SMCCC_RET_NOT_SUPPORTED;
>  }
>  
> +static inline long kvm_hypercall_stolen_time(struct kvm_vcpu *vcpu)
> +{
> +	return SMCCC_RET_NOT_SUPPORTED;
> +}
> +
> +static inline int kvm_update_stolen_time(struct kvm_vcpu *vcpu, bool init)
> +{
> +	return -ENOTSUPP;
> +}
> +
> +static inline void kvm_arm_pvtime_vcpu_init(struct kvm_vcpu_arch *vcpu_arch)
> +{
> +}
> +
> +static inline bool kvm_arm_is_pvtime_enabled(struct kvm_vcpu_arch *vcpu_arch)
> +{
> +	return false;
> +}
> +
>  void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot);
>  
>  struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr);
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 93b46d9526d0..1697e63f6dd8 100644
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
> @@ -338,8 +339,14 @@ struct kvm_vcpu_arch {
>  	/* True when deferrable sysregs are loaded on the physical CPU,
>  	 * see kvm_vcpu_load_sysregs and kvm_vcpu_put_sysregs. */
>  	bool sysregs_loaded_on_cpu;
> -};
>  
> +	/* Guest PV state */
> +	struct {
> +		u64 steal;
> +		u64 last_steal;
> +		gpa_t base;
> +	} steal;
> +};
>  /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
>  #define vcpu_sve_pffr(vcpu) ((void *)((char *)((vcpu)->arch.sve_state) + \
>  				      sve_ffr_offset((vcpu)->arch.sve_max_vl)))
> @@ -479,6 +486,18 @@ int kvm_perf_init(void);
>  int kvm_perf_teardown(void);
>  
>  long kvm_hypercall_pv_features(struct kvm_vcpu *vcpu);
> +long kvm_hypercall_stolen_time(struct kvm_vcpu *vcpu);
> +int kvm_update_stolen_time(struct kvm_vcpu *vcpu, bool init);
> +
> +static inline void kvm_arm_pvtime_vcpu_init(struct kvm_vcpu_arch *vcpu_arch)
> +{
> +	vcpu_arch->steal.base = GPA_INVALID;
> +}
> +
> +static inline bool kvm_arm_is_pvtime_enabled(struct kvm_vcpu_arch *vcpu_arch)
> +{
> +	return (vcpu_arch->steal.base != GPA_INVALID);
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
> index 35a069815baf..eaceb2d0f0c0 100644
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
> @@ -350,6 +354,8 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
>  
>  	kvm_arm_reset_debug_ptr(vcpu);
>  
> +	kvm_arm_pvtime_vcpu_init(&vcpu->arch);
> +
>  	return kvm_vgic_vcpu_init(vcpu);
>  }
>  
> @@ -379,6 +385,8 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  	kvm_vcpu_load_sysregs(vcpu);
>  	kvm_arch_vcpu_load_fp(vcpu);
>  	kvm_vcpu_pmu_restore_guest(vcpu);
> +	if (kvm_arm_is_pvtime_enabled(&vcpu->arch))
> +		kvm_make_request(KVM_REQ_RECORD_STEAL, vcpu);
>  
>  	if (single_task_running())
>  		vcpu_clear_wfe_traps(vcpu);
> @@ -644,6 +652,9 @@ static void check_vcpu_requests(struct kvm_vcpu *vcpu)
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
> index e2521e0d3978..3091a5d2e842 100644
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
> index 7887a61651c6..d9d0dbc6994b 100644
> --- a/virt/kvm/arm/pvtime.c
> +++ b/virt/kvm/arm/pvtime.c
> @@ -3,8 +3,45 @@
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
> +	u64 steal;
> +	u64 steal_le;
> +	u64 offset;
> +	int idx;
> +	u64 base = vcpu->arch.steal.base;
> +
> +	if (base == GPA_INVALID)
> +		return -ENOTSUPP;
> +
> +	/* Let's do the local bookkeeping */
> +	steal = vcpu->arch.steal.steal;
> +	steal += current->sched_info.run_delay - vcpu->arch.steal.last_steal;
> +	vcpu->arch.steal.last_steal = current->sched_info.run_delay;
> +	vcpu->arch.steal.steal = steal;
> +
> +	steal_le = cpu_to_le64(steal);
> +	idx = srcu_read_lock(&kvm->srcu);
> +	if (init) {
> +		struct pvclock_vcpu_stolen_time init_values = {
> +			.revision = 0,
> +			.attributes = 0
> +		};
> +		kvm_write_guest(kvm, base, &init_values,
> +				sizeof(init_values));
> +	}
> +	offset = offsetof(struct pvclock_vcpu_stolen_time, stolen_time);
> +	kvm_put_guest(kvm, base + offset, steal_le, u64);

Let's hope we don't have thousands of memslots through which we have to
do a linear scan on every vcpu load after this.  If that were the case,
I think the memslot search path would have to be updated anyhow.

Otherwise looks reasonable to me.

Thanks,

    Christoffer

> +	srcu_read_unlock(&kvm->srcu, idx);
> +
> +	return 0;
> +}
> +
>  long kvm_hypercall_pv_features(struct kvm_vcpu *vcpu)
>  {
>  	u32 feature = smccc_get_arg1(vcpu);
> @@ -12,6 +49,7 @@ long kvm_hypercall_pv_features(struct kvm_vcpu *vcpu)
>  
>  	switch (feature) {
>  	case ARM_SMCCC_HV_PV_FEATURES:
> +	case ARM_SMCCC_HV_PV_TIME_ST:
>  		val = SMCCC_RET_SUCCESS;
>  		break;
>  	}
> @@ -19,3 +57,21 @@ long kvm_hypercall_pv_features(struct kvm_vcpu *vcpu)
>  	return val;
>  }
>  
> +long kvm_hypercall_stolen_time(struct kvm_vcpu *vcpu)
> +{
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
> +		return SMCCC_RET_NOT_SUPPORTED;
> +
> +	return vcpu->arch.steal.base;
> +}
> -- 
> 2.20.1
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
