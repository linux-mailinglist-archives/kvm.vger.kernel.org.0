Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D63C8122F01
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2019 15:40:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728699AbfLQOki (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Dec 2019 09:40:38 -0500
Received: from foss.arm.com ([217.140.110.172]:39214 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728532AbfLQOki (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Dec 2019 09:40:38 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 474501FB;
        Tue, 17 Dec 2019 06:40:37 -0800 (PST)
Received: from arm.com (e112269-lin.cambridge.arm.com [10.1.196.56])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4B9183F67D;
        Tue, 17 Dec 2019 06:40:35 -0800 (PST)
Date:   Tue, 17 Dec 2019 14:40:33 +0000
From:   Steven Price <steven.price@arm.com>
To:     "yezengruan@huawei.com" <yezengruan@huawei.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
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
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>
Subject: Re: [PATCH 5/5] KVM: arm64: Support the vcpu preemption check
Message-ID: <20191217144032.GD38811@arm.com>
References: <20191217135549.3240-1-yezengruan@huawei.com>
 <20191217135549.3240-6-yezengruan@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191217135549.3240-6-yezengruan@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 17, 2019 at 01:55:49PM +0000, yezengruan@huawei.com wrote:
> From: Zengruan Ye <yezengruan@huawei.com>
> 
> Support the vcpu_is_preempted() functionality under KVM/arm64. This will
> enhance lock performance on overcommitted hosts (more runnable vcpus
> than physical cpus in the system) as doing busy waits for preempted
> vcpus will hurt system performance far worse than early yielding.
> 
> unix benchmark result:
>   host:  kernel 5.5.0-rc1, HiSilicon Kunpeng920, 8 cpus
>   guest: kernel 5.5.0-rc1, 16 vcpus
> 
>                test-case                |    after-patch    |   before-patch
> ----------------------------------------+-------------------+------------------
>  Dhrystone 2 using register variables   | 334600751.0 lps   | 335319028.3 lps
>  Double-Precision Whetstone             |     32856.1 MWIPS |     32849.6 MWIPS
>  Execl Throughput                       |      3662.1 lps   |      2718.0 lps
>  File Copy 1024 bufsize 2000 maxblocks  |    432906.4 KBps  |    158011.8 KBps
>  File Copy 256 bufsize 500 maxblocks    |    116023.0 KBps  |     37664.0 KBps
>  File Copy 4096 bufsize 8000 maxblocks  |   1432769.8 KBps  |    441108.8 KBps
>  Pipe Throughput                        |   6405029.6 lps   |   6021457.6 lps
>  Pipe-based Context Switching           |    185872.7 lps   |    184255.3 lps
>  Process Creation                       |      4025.7 lps   |      3706.6 lps
>  Shell Scripts (1 concurrent)           |      6745.6 lpm   |      6436.1 lpm
>  Shell Scripts (8 concurrent)           |       998.7 lpm   |       931.1 lpm
>  System Call Overhead                   |   3913363.1 lps   |   3883287.8 lps
> ----------------------------------------+-------------------+------------------
>  System Benchmarks Index Score          |      1835.1       |      1327.6
> 
> Signed-off-by: Zengruan Ye <yezengruan@huawei.com>
> ---
>  arch/arm64/include/asm/paravirt.h |  3 +
>  arch/arm64/kernel/paravirt.c      | 91 +++++++++++++++++++++++++++++++
>  arch/arm64/kernel/setup.c         |  2 +
>  include/linux/cpuhotplug.h        |  1 +
>  4 files changed, 97 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/paravirt.h b/arch/arm64/include/asm/paravirt.h
> index 7b1c81b544bb..a2cd0183bbef 100644
> --- a/arch/arm64/include/asm/paravirt.h
> +++ b/arch/arm64/include/asm/paravirt.h
> @@ -29,6 +29,8 @@ static inline u64 paravirt_steal_clock(int cpu)
>  
>  int __init pv_time_init(void);
>  
> +int __init kvm_guest_init(void);
> +

This is a *very* generic name - I suggest something like pv_lock_init()
so it's clear what the function actually does.

>  __visible bool __native_vcpu_is_preempted(int cpu);
>  
>  static inline bool pv_vcpu_is_preempted(int cpu)
> @@ -39,6 +41,7 @@ static inline bool pv_vcpu_is_preempted(int cpu)
>  #else
>  
>  #define pv_time_init() do {} while (0)
> +#define kvm_guest_init() do {} while (0)
>  
>  #endif // CONFIG_PARAVIRT
>  
> diff --git a/arch/arm64/kernel/paravirt.c b/arch/arm64/kernel/paravirt.c
> index d8f1ba8c22ce..a86dead40473 100644
> --- a/arch/arm64/kernel/paravirt.c
> +++ b/arch/arm64/kernel/paravirt.c
> @@ -22,6 +22,7 @@
>  #include <asm/paravirt.h>
>  #include <asm/pvclock-abi.h>
>  #include <asm/smp_plat.h>
> +#include <asm/pvlock-abi.h>
>  
>  struct static_key paravirt_steal_enabled;
>  struct static_key paravirt_steal_rq_enabled;
> @@ -158,3 +159,93 @@ int __init pv_time_init(void)
>  
>  	return 0;
>  }
> +
> +DEFINE_PER_CPU(struct pvlock_vcpu_state, pvlock_vcpu_region) __aligned(64);
> +EXPORT_PER_CPU_SYMBOL(pvlock_vcpu_region);
> +
> +static int pvlock_vcpu_state_dying_cpu(unsigned int cpu)
> +{
> +	struct pvlock_vcpu_state *reg;
> +
> +	reg = this_cpu_ptr(&pvlock_vcpu_region);
> +	if (!reg)
> +		return -EFAULT;
> +
> +	memset(reg, 0, sizeof(*reg));

I might be missing something obvious here - but I don't see the point of
this. The hypervisor might immediately overwrite the structure again.
Indeed you should conside a mechanism for the guest to "unregister" the
region - otherwise you will face issues with the likes of kexec.

For pv_time the memory is allocated by the hypervisor not the guest to
avoid lifetime issues about kexec.

> +
> +	return 0;
> +}
> +
> +static int init_pvlock_vcpu_state(unsigned int cpu)
> +{
> +	struct pvlock_vcpu_state *reg;
> +	struct arm_smccc_res res;
> +
> +	reg = this_cpu_ptr(&pvlock_vcpu_region);
> +	if (!reg)
> +		return -EFAULT;
> +
> +	/* Pass the memory address to host via hypercall */
> +	arm_smccc_1_1_invoke(ARM_SMCCC_HV_PV_LOCK_PREEMPTED,
> +			     virt_to_phys(reg), &res);
> +
> +	return 0;
> +}
> +
> +static bool kvm_vcpu_is_preempted(int cpu)
> +{
> +	struct pvlock_vcpu_state *reg = &per_cpu(pvlock_vcpu_region, cpu);
> +
> +	if (reg)
> +		return !!(reg->preempted & 1);
> +
> +	return false;
> +}
> +
> +static int kvm_arm_init_pvlock(void)
> +{
> +	int ret;
> +
> +	ret = cpuhp_setup_state(CPUHP_AP_ARM_KVM_PVLOCK_STARTING,
> +				"hypervisor/arm/pvlock:starting",
> +				init_pvlock_vcpu_state,
> +				pvlock_vcpu_state_dying_cpu);
> +	if (ret < 0)
> +		return ret;
> +
> +	pv_ops.lock.vcpu_is_preempted = kvm_vcpu_is_preempted;
> +
> +	pr_info("using PV-lock preempted\n");
> +
> +	return 0;
> +}
> +
> +static bool has_kvm_pvlock(void)
> +{
> +	struct arm_smccc_res res;
> +
> +	/* To detect the presence of PV lock support we require SMCCC 1.1+ */
> +	if (psci_ops.smccc_version < SMCCC_VERSION_1_1)
> +		return false;
> +
> +	arm_smccc_1_1_invoke(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
> +			     ARM_SMCCC_HV_PV_LOCK_FEATURES, &res);
> +
> +	if (res.a0 != SMCCC_RET_SUCCESS)
> +		return false;
> +
> +	return true;
> +}
> +
> +int __init kvm_guest_init(void)
> +{
> +	if (is_hyp_mode_available())
> +		return 0;
> +
> +	if (!has_kvm_pvlock())
> +		return 0;
> +
> +	kvm_arm_init_pvlock();

Consider reporting errors from kvm_arm_init_pvlock()? At the moment
it's impossible to tell the difference between pvlock not being
supported and something failing in the setup.

Steve

> +
> +	return 0;
> +}
> diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
> index 56f664561754..64c4d515ba2d 100644
> --- a/arch/arm64/kernel/setup.c
> +++ b/arch/arm64/kernel/setup.c
> @@ -341,6 +341,8 @@ void __init setup_arch(char **cmdline_p)
>  	smp_init_cpus();
>  	smp_build_mpidr_hash();
>  
> +	kvm_guest_init();
> +
>  	/* Init percpu seeds for random tags after cpus are set up. */
>  	kasan_init_tags();
>  
> diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
> index e51ee772b9f5..f72ff95ab63a 100644
> --- a/include/linux/cpuhotplug.h
> +++ b/include/linux/cpuhotplug.h
> @@ -138,6 +138,7 @@ enum cpuhp_state {
>  	CPUHP_AP_DUMMY_TIMER_STARTING,
>  	CPUHP_AP_ARM_XEN_STARTING,
>  	CPUHP_AP_ARM_KVMPV_STARTING,
> +	CPUHP_AP_ARM_KVM_PVLOCK_STARTING,
>  	CPUHP_AP_ARM_CORESIGHT_STARTING,
>  	CPUHP_AP_ARM64_ISNDEP_STARTING,
>  	CPUHP_AP_SMPCFD_DYING,
> -- 
> 2.19.1
> 
> 
