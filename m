Return-Path: <kvm+bounces-1726-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 271237EBD36
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 07:50:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A0E831F22B42
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 06:50:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DF954427;
	Wed, 15 Nov 2023 06:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="n5IyyrMu"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA4B23D6C
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 06:50:07 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56594D0;
	Tue, 14 Nov 2023 22:50:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700031006; x=1731567006;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=azmQ9x7lcmsX/9QI+AnsuE83G/gHZzw6UwYJYlET6to=;
  b=n5IyyrMun4WQ2e1+CButkLSgljG3VMPuNaMmnrGcZIj6rjlNPrWZn+jR
   fgREANGG3PVsjsH1uFBHZR+YmZbnr8Jl87yAUZjrWfdG9Cym8+CDqQoOr
   ebEyWEvuYVxTclFeYfybFMeTKmjJZPmPMVeX5pelY/aGIfUmWGZQq0tpP
   flx8nacRkn6Otx1t2i9wsDWQGP/rFnqq1iw/bSubiaru/NnyBTBuqeoRO
   UE79y0HgI2qXgi0CpzuA10yJjVW2ysvwtR6UnQlq058q83c4D5VSMhwz/
   3t0YeydA5wOXJqOYS7cT9dXO9QZc0I19Bi7GR+/loSTQcXuC1Zqfe+jza
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="375858488"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="375858488"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2023 22:50:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="764895489"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="764895489"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by orsmga002.jf.intel.com with ESMTP; 14 Nov 2023 22:49:57 -0800
Date: Wed, 15 Nov 2023 14:49:56 +0800
From: Yuan Yao <yuan.yao@linux.intel.com>
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, David Matlack <dmatlack@google.com>,
	Kai Huang <kai.huang@intel.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
	hang.yuan@intel.com, tina.zhang@intel.com
Subject: Re: [PATCH v17 071/116] KVM: TDX: handle vcpu migration over logical
 processor
Message-ID: <20231115064956.du6qjjraqkxtjuud@yy-desk-7060>
References: <cover.1699368322.git.isaku.yamahata@intel.com>
 <89926d400f0228384c9571c73208d7f1ab045fda.1699368322.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <89926d400f0228384c9571c73208d7f1ab045fda.1699368322.git.isaku.yamahata@intel.com>
User-Agent: NeoMutt/20171215

On Tue, Nov 07, 2023 at 06:56:37AM -0800, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> For vcpu migration, in the case of VMX, VMCS is flushed on the source pcpu,
> and load it on the target pcpu.  There are corresponding TDX SEAMCALL APIs,
> call them on vcpu migration.  The logic is mostly same as VMX except the
> TDX SEAMCALLs are used.
>
> When shutting down the machine, (VMX or TDX) vcpus needs to be shutdown on
> each pcpu.  Do the similar for TDX with TDX SEAMCALL APIs.
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/kvm/vmx/main.c    |  32 ++++++-
>  arch/x86/kvm/vmx/tdx.c     | 190 ++++++++++++++++++++++++++++++++++++-
>  arch/x86/kvm/vmx/tdx.h     |   2 +
>  arch/x86/kvm/vmx/x86_ops.h |   4 +
>  4 files changed, 221 insertions(+), 7 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index e7c570686736..8b109d0fe764 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -44,6 +44,14 @@ static int vt_hardware_enable(void)
>  	return ret;
>  }
>
......
> -void tdx_mmu_release_hkid(struct kvm *kvm)
> +static int __tdx_mmu_release_hkid(struct kvm *kvm)
>  {
>  	bool packages_allocated, targets_allocated;
>  	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
>  	cpumask_var_t packages, targets;
> +	struct kvm_vcpu *vcpu;
> +	unsigned long j;
> +	int i, ret = 0;
>  	u64 err;
> -	int i;
>
>  	if (!is_hkid_assigned(kvm_tdx))
> -		return;
> +		return 0;
>
>  	if (!is_td_created(kvm_tdx)) {
>  		tdx_hkid_free(kvm_tdx);
> -		return;
> +		return 0;
>  	}
>
>  	packages_allocated = zalloc_cpumask_var(&packages, GFP_KERNEL);
>  	targets_allocated = zalloc_cpumask_var(&targets, GFP_KERNEL);
>  	cpus_read_lock();
>
> +	kvm_for_each_vcpu(j, vcpu, kvm)
> +		tdx_flush_vp_on_cpu(vcpu);
> +
>  	/*
>  	 * We can destroy multiple the guest TDs simultaneously.  Prevent
>  	 * tdh_phymem_cache_wb from returning TDX_BUSY by serialization.
> @@ -236,6 +361,19 @@ void tdx_mmu_release_hkid(struct kvm *kvm)
>  	 */
>  	write_lock(&kvm->mmu_lock);
>
> +	err = tdh_mng_vpflushdone(kvm_tdx->tdr_pa);
> +	if (err == TDX_FLUSHVP_NOT_DONE) {

Not sure IIUC, The __tdx_mmu_release_hkid() is called in MMU release
callback, which means all threads of the process have dropped mm by
do_exit() so they won't run kvm code anymore, and tdx_flush_vp_on_cpu()
is called for each pcpu they run last time, so will this error really
happen ?

> +		ret = -EBUSY;
> +		goto out;
> +	}
> +	if (WARN_ON_ONCE(err)) {
> +		pr_tdx_error(TDH_MNG_VPFLUSHDONE, err, NULL);
> +		pr_err("tdh_mng_vpflushdone() failed. HKID %d is leaked.\n",
> +		       kvm_tdx->hkid);
> +		ret = -EIO;
> +		goto out;
> +	}
> +
>  	for_each_online_cpu(i) {
>  		if (packages_allocated &&
>  		    cpumask_test_and_set_cpu(topology_physical_package_id(i),
> @@ -258,14 +396,24 @@ void tdx_mmu_release_hkid(struct kvm *kvm)
>  		pr_tdx_error(TDH_MNG_KEY_FREEID, err, NULL);
>  		pr_err("tdh_mng_key_freeid() failed. HKID %d is leaked.\n",
>  		       kvm_tdx->hkid);
> +		ret = -EIO;
>  	} else
>  		tdx_hkid_free(kvm_tdx);
>
> +out:
>  	write_unlock(&kvm->mmu_lock);
>  	mutex_unlock(&tdx_lock);
>  	cpus_read_unlock();
>  	free_cpumask_var(targets);
>  	free_cpumask_var(packages);
> +
> +	return ret;
> +}
> +
> +void tdx_mmu_release_hkid(struct kvm *kvm)
> +{
> +	while (__tdx_mmu_release_hkid(kvm) == -EBUSY)
> +		;
>  }
>
>  void tdx_vm_free(struct kvm *kvm)
> @@ -429,6 +577,26 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
>  	return 0;
>  }
>
> +void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
> +{
> +	struct vcpu_tdx *tdx = to_tdx(vcpu);
> +
> +	if (vcpu->cpu == cpu)
> +		return;
> +
> +	tdx_flush_vp_on_cpu(vcpu);
> +
> +	local_irq_disable();
> +	/*
> +	 * Pairs with the smp_wmb() in tdx_disassociate_vp() to ensure
> +	 * vcpu->cpu is read before tdx->cpu_list.
> +	 */
> +	smp_rmb();
> +
> +	list_add(&tdx->cpu_list, &per_cpu(associated_tdvcpus, cpu));
> +	local_irq_enable();
> +}
> +
>  void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_tdx *tdx = to_tdx(vcpu);
> @@ -469,6 +637,16 @@ void tdx_vcpu_free(struct kvm_vcpu *vcpu)
>  	struct vcpu_tdx *tdx = to_tdx(vcpu);
>  	int i;
>
> +	/*
> +	 * When destroying VM, kvm_unload_vcpu_mmu() calls vcpu_load() for every
> +	 * vcpu after they already disassociated from the per cpu list by
> +	 * tdx_mmu_release_hkid().  So we need to disassociate them again,
> +	 * otherwise the freed vcpu data will be accessed when do
> +	 * list_{del,add}() on associated_tdvcpus list later.
> +	 */
> +	tdx_disassociate_vp_on_cpu(vcpu);
> +	WARN_ON_ONCE(vcpu->cpu != -1);
> +
>  	/*
>  	 * This methods can be called when vcpu allocation/initialization
>  	 * failed. So it's possible that hkid, tdvpx and tdvpr are not assigned
> @@ -1873,6 +2051,10 @@ int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
>  		return -EINVAL;
>  	}
>
> +	/* tdx_hardware_disable() uses associated_tdvcpus. */
> +	for_each_possible_cpu(i)
> +		INIT_LIST_HEAD(&per_cpu(associated_tdvcpus, i));
> +
>  	for (i = 0; i < ARRAY_SIZE(tdx_uret_msrs); i++) {
>  		/*
>  		 * Here it checks if MSRs (tdx_uret_msrs) can be saved/restored
> diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> index c700792c08e2..4f803814126a 100644
> --- a/arch/x86/kvm/vmx/tdx.h
> +++ b/arch/x86/kvm/vmx/tdx.h
> @@ -70,6 +70,8 @@ struct vcpu_tdx {
>  	unsigned long tdvpr_pa;
>  	unsigned long *tdvpx_pa;
>
> +	struct list_head cpu_list;
> +
>  	union tdx_exit_reason exit_reason;
>
>  	bool initialized;
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index 4c9793b5b30d..911ef1e8eeda 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -137,6 +137,7 @@ void vmx_setup_mce(struct kvm_vcpu *vcpu);
>  #ifdef CONFIG_INTEL_TDX_HOST
>  int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops);
>  void tdx_hardware_unsetup(void);
> +void tdx_hardware_disable(void);
>  bool tdx_is_vm_type_supported(unsigned long type);
>  int tdx_offline_cpu(void);
>
> @@ -153,6 +154,7 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
>  fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu);
>  void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu);
>  void tdx_vcpu_put(struct kvm_vcpu *vcpu);
> +void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
>  u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
>
>  int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
> @@ -164,6 +166,7 @@ void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level);
>  #else
>  static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return -EOPNOTSUPP; }
>  static inline void tdx_hardware_unsetup(void) {}
> +static inline void tdx_hardware_disable(void) {}
>  static inline bool tdx_is_vm_type_supported(unsigned long type) { return false; }
>  static inline int tdx_offline_cpu(void) { return 0; }
>
> @@ -183,6 +186,7 @@ static inline void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event) {}
>  static inline fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu) { return EXIT_FASTPATH_NONE; }
>  static inline void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu) {}
>  static inline void tdx_vcpu_put(struct kvm_vcpu *vcpu) {}
> +static inline void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu) {}
>  static inline u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio) { return 0; }
>
>  static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
> --
> 2.25.1
>
>

