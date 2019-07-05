Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AB4460946
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2019 17:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727266AbfGEP2k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jul 2019 11:28:40 -0400
Received: from foss.arm.com ([217.140.110.172]:42056 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725497AbfGEP2k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jul 2019 11:28:40 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8141328;
        Fri,  5 Jul 2019 08:28:39 -0700 (PDT)
Received: from [10.1.31.185] (e121566-lin.cambridge.arm.com [10.1.31.185])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 125AA3F246;
        Fri,  5 Jul 2019 08:28:37 -0700 (PDT)
Subject: Re: [PATCH 39/59] KVM: arm64: nv: Move last_vcpu_ran to be per s2 mmu
To:     Marc Zyngier <marc.zyngier@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Dave Martin <Dave.Martin@arm.com>
References: <20190621093843.220980-1-marc.zyngier@arm.com>
 <20190621093843.220980-40-marc.zyngier@arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <a38cce1c-cb56-c41f-d99b-f5a2be7e058c@arm.com>
Date:   Fri, 5 Jul 2019 16:28:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190621093843.220980-40-marc.zyngier@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/21/19 10:38 AM, Marc Zyngier wrote:
> last_vcpu_ran has to be per s2 mmu now that we can have multiple S2
> per VM. Let's take this opportunity to perform some cleanup.
>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm/include/asm/kvm_host.h   |  6 +++---
>  arch/arm/include/asm/kvm_mmu.h    |  2 +-
>  arch/arm64/include/asm/kvm_host.h |  6 +++---
>  arch/arm64/include/asm/kvm_mmu.h  |  2 +-
>  arch/arm64/kvm/nested.c           | 13 ++++++-------
>  virt/kvm/arm/arm.c                | 22 ++++------------------
>  virt/kvm/arm/mmu.c                | 26 ++++++++++++++++++++------
>  7 files changed, 38 insertions(+), 39 deletions(-)
>
> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> index b821eb2383ad..cc761610e41e 100644
> --- a/arch/arm/include/asm/kvm_host.h
> +++ b/arch/arm/include/asm/kvm_host.h
> @@ -63,15 +63,15 @@ struct kvm_s2_mmu {
>  	pgd_t *pgd;
>  	phys_addr_t pgd_phys;
>  
> +	/* The last vcpu id that ran on each physical CPU */
> +	int __percpu *last_vcpu_ran;
> +
>  	struct kvm *kvm;
>  };
>  
>  struct kvm_arch {
>  	struct kvm_s2_mmu mmu;
>  
> -	/* The last vcpu id that ran on each physical CPU */
> -	int __percpu *last_vcpu_ran;
> -
>  	/* Stage-2 page table */
>  	pgd_t *pgd;
>  	phys_addr_t pgd_phys;
> diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
> index afabf1fd1d17..7a6e9008ed45 100644
> --- a/arch/arm/include/asm/kvm_mmu.h
> +++ b/arch/arm/include/asm/kvm_mmu.h
> @@ -52,7 +52,7 @@ int create_hyp_exec_mappings(phys_addr_t phys_addr, size_t size,
>  void free_hyp_pgds(void);
>  
>  void stage2_unmap_vm(struct kvm *kvm);
> -int kvm_alloc_stage2_pgd(struct kvm_s2_mmu *mmu);
> +int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu);
>  void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu);
>  int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
>  			  phys_addr_t pa, unsigned long size, bool writable);
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index cc238de170d2..b71a7a237f95 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -104,6 +104,9 @@ struct kvm_s2_mmu {
>  	 * >0: Somebody is actively using this.
>  	 */
>  	atomic_t refcnt;
> +
> +	/* The last vcpu id that ran on each physical CPU */
> +	int __percpu *last_vcpu_ran;
>  };
>  
>  static inline bool kvm_s2_mmu_valid(struct kvm_s2_mmu *mmu)
> @@ -124,9 +127,6 @@ struct kvm_arch {
>  	/* VTCR_EL2 value for this VM */
>  	u64    vtcr;
>  
> -	/* The last vcpu id that ran on each physical CPU */
> -	int __percpu *last_vcpu_ran;
> -
>  	/* The maximum number of vCPUs depends on the used GIC model */
>  	int max_vcpus;
>  
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index f4c5ac5eb95f..53103607065a 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -169,7 +169,7 @@ void free_hyp_pgds(void);
>  
>  void kvm_unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size);
>  void stage2_unmap_vm(struct kvm *kvm);
> -int kvm_alloc_stage2_pgd(struct kvm_s2_mmu *mmu);
> +int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu);
>  void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu);
>  int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
>  			  phys_addr_t pa, unsigned long size, bool writable);
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 8880033fb6e0..09afafbdc8fe 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -52,18 +52,17 @@ int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu)
>  			 GFP_KERNEL | __GFP_ZERO);
>  
>  	if (tmp) {
> -		if (tmp != kvm->arch.nested_mmus)
> +		if (tmp != kvm->arch.nested_mmus) {
>  			kfree(kvm->arch.nested_mmus);
> +			kvm->arch.nested_mmus = NULL;
> +			kvm->arch.nested_mmus_size = 0;
> +		}
>  
> -		tmp[num_mmus - 1].kvm = kvm;
> -		atomic_set(&tmp[num_mmus - 1].refcnt, 0);
> -		ret = kvm_alloc_stage2_pgd(&tmp[num_mmus - 1]);
> +		ret = kvm_init_stage2_mmu(kvm, &tmp[num_mmus - 1]);
>  		if (ret)
>  			goto out;
>  
> -		tmp[num_mmus - 2].kvm = kvm;
> -		atomic_set(&tmp[num_mmus - 2].refcnt, 0);
> -		ret = kvm_alloc_stage2_pgd(&tmp[num_mmus - 2]);
> +		ret = kvm_init_stage2_mmu(kvm, &tmp[num_mmus - 2]);
>  		if (ret) {
>  			kvm_free_stage2_pgd(&tmp[num_mmus - 1]);
>  			goto out;
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index bcca27d5c481..e8b584b79847 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -99,29 +99,21 @@ void kvm_arch_check_processor_compat(void *rtn)
>  	*(int *)rtn = 0;
>  }
>  
> -
>  /**
>   * kvm_arch_init_vm - initializes a VM data structure
>   * @kvm:	pointer to the KVM struct
>   */
>  int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>  {
> -	int ret, cpu;
> +	int ret;
>  
>  	ret = kvm_arm_setup_stage2(kvm, type);
>  	if (ret)
>  		return ret;
>  
> -	kvm->arch.last_vcpu_ran = alloc_percpu(typeof(*kvm->arch.last_vcpu_ran));
> -	if (!kvm->arch.last_vcpu_ran)
> -		return -ENOMEM;
> -
> -	for_each_possible_cpu(cpu)
> -		*per_cpu_ptr(kvm->arch.last_vcpu_ran, cpu) = -1;
> -
> -	ret = kvm_alloc_stage2_pgd(&kvm->arch.mmu);
> +	ret = kvm_init_stage2_mmu(kvm, &kvm->arch.mmu);
>  	if (ret)
> -		goto out_fail_alloc;
> +		return ret;
>  
>  	/* Mark the initial VMID generation invalid */
>  	kvm->arch.mmu.vmid.vmid_gen = 0;

More context:

 int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 {
-    int ret, cpu;
+    int ret;
 
     ret = kvm_arm_setup_stage2(kvm, type);
     if (ret)
         return ret;
 
-    kvm->arch.last_vcpu_ran = alloc_percpu(typeof(*kvm->arch.last_vcpu_ran));
-    if (!kvm->arch.last_vcpu_ran)
-        return -ENOMEM;
-
-    for_each_possible_cpu(cpu)
-        *per_cpu_ptr(kvm->arch.last_vcpu_ran, cpu) = -1;
-
-    ret = kvm_alloc_stage2_pgd(&kvm->arch.mmu);
+    ret = kvm_init_stage2_mmu(kvm, &kvm->arch.mmu);
     if (ret)
-        goto out_fail_alloc;
+        return ret;
 
     /* Mark the initial VMID generation invalid */
     kvm->arch.mmu.vmid.vmid_gen = 0;
     kvm->arch.mmu.kvm = kvm;
 

kvm_init_stage2_mmu already sets vmid_gen and kvm.

> @@ -142,9 +134,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>  	return ret;
>  out_free_stage2_pgd:
>  	kvm_free_stage2_pgd(&kvm->arch.mmu);
> -out_fail_alloc:
> -	free_percpu(kvm->arch.last_vcpu_ran);
> -	kvm->arch.last_vcpu_ran = NULL;
>  	return ret;
>  }
>  
> @@ -174,9 +163,6 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
>  
>  	kvm_vgic_destroy(kvm);
>  
> -	free_percpu(kvm->arch.last_vcpu_ran);
> -	kvm->arch.last_vcpu_ran = NULL;
> -
>  	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
>  		if (kvm->vcpus[i]) {
>  			kvm_arch_vcpu_free(kvm->vcpus[i]);
> @@ -359,7 +345,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  	if (nested_virt_in_use(vcpu))
>  		kvm_vcpu_load_hw_mmu(vcpu);
>  
> -	last_ran = this_cpu_ptr(vcpu->kvm->arch.last_vcpu_ran);
> +	last_ran = this_cpu_ptr(vcpu->arch.hw_mmu->last_vcpu_ran);
>  	cpu_data = this_cpu_ptr(&kvm_host_data);
>  
>  	/*
> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> index 94d400e7af57..6a7cba077bce 100644
> --- a/virt/kvm/arm/mmu.c
> +++ b/virt/kvm/arm/mmu.c
> @@ -903,8 +903,9 @@ int create_hyp_exec_mappings(phys_addr_t phys_addr, size_t size,
>  }
>  
>  /**
> - * kvm_alloc_stage2_pgd - allocate level-1 table for stage-2 translation.
> - * @mmu:	The stage 2 mmu struct pointer
> + * kvm_init_stage2_mmu - Initialise a S2 MMU strucrure
> + * @kvm:	The pointer to the KVM structure
> + * @mmu:	The pointer to the s2 MMU structure
>   *
>   * Allocates only the stage-2 HW PGD level table(s) of size defined by
>   * stage2_pgd_size(mmu->kvm).
> @@ -912,10 +913,11 @@ int create_hyp_exec_mappings(phys_addr_t phys_addr, size_t size,
>   * Note we don't need locking here as this is only called when the VM is
>   * created, which can only be done once.
>   */
> -int kvm_alloc_stage2_pgd(struct kvm_s2_mmu *mmu)
> +int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu)
>  {
>  	phys_addr_t pgd_phys;
>  	pgd_t *pgd;
> +	int cpu;
>  
>  	if (mmu->pgd != NULL) {
>  		kvm_err("kvm_arch already initialized?\n");
> @@ -923,18 +925,28 @@ int kvm_alloc_stage2_pgd(struct kvm_s2_mmu *mmu)
>  	}
>  
>  	/* Allocate the HW PGD, making sure that each page gets its own refcount */
> -	pgd = alloc_pages_exact(stage2_pgd_size(mmu->kvm), GFP_KERNEL | __GFP_ZERO);
> +	pgd = alloc_pages_exact(stage2_pgd_size(kvm), GFP_KERNEL | __GFP_ZERO);
>  	if (!pgd)
>  		return -ENOMEM;
>  
>  	pgd_phys = virt_to_phys(pgd);
> -	if (WARN_ON(pgd_phys & ~kvm_vttbr_baddr_mask(mmu->kvm)))
> +	if (WARN_ON(pgd_phys & ~kvm_vttbr_baddr_mask(kvm)))
>  		return -EINVAL;
>  
> +	mmu->last_vcpu_ran = alloc_percpu(typeof(*mmu->last_vcpu_ran));
> +	if (!mmu->last_vcpu_ran) {
> +		free_pages_exact(pgd, stage2_pgd_size(kvm));
> +		return -ENOMEM;
> +	}
> +
> +	mmu->kvm = kvm;
>  	mmu->pgd = pgd;
>  	mmu->pgd_phys = pgd_phys;
>  	mmu->vmid.vmid_gen = 0;
>  
> +	for_each_possible_cpu(cpu)
> +		*per_cpu_ptr(mmu->last_vcpu_ran, cpu) = -1;
> +
>  	kvm_init_s2_mmu(mmu);
>  
>  	return 0;
> @@ -1021,8 +1033,10 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
>  	spin_unlock(&kvm->mmu_lock);
>  
>  	/* Free the HW pgd, one page at a time */

last_vcpu_ran too.

> -	if (pgd)
> +	if (pgd) {
>  		free_pages_exact(pgd, stage2_pgd_size(kvm));
> +		free_percpu(mmu->last_vcpu_ran);
> +	}
>  }
>  
>  static pud_t *stage2_get_pud(struct kvm_s2_mmu *mmu, struct kvm_mmu_memory_cache *cache,
