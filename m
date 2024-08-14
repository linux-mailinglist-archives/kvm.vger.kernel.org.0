Return-Path: <kvm+bounces-24091-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AC7F9512E6
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 05:09:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7CC81B244E1
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 03:09:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B41337171;
	Wed, 14 Aug 2024 03:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nH2tlkdb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 847381CAA2;
	Wed, 14 Aug 2024 03:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723604936; cv=none; b=GdXJo2H864H0C7kcCUCNbS759Yb8txDaJPEY8kaj5IKkQ9G+qAv5YYGzzQQyLEdoDS6iUvMUOGRqngz0Y+Dx4QYJrXgdJa/rkaWOEHPEqd5pvQFeFfyV+bjI3favYiPhNWkua0+RH/V96Htxgjp4TXlt4GIEGQImuDWnmnn+aFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723604936; c=relaxed/simple;
	bh=Qk7mEvYHo85REyjzvBa8f+wXCzKEXfe3EEwF4d9zNyk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o07YEPnmBprm4/Pe8ftYXNPqes+2tTFaEnMh0jii5yGpHDk5BjCgaw6Wt+N3nG+nPz7pTJGunRw+KbYgN/7DGU7SMuh5QVY9wXfLXLZJXnUL+ks8TtNEnLkO2affg7vIPLwtXJqJ8wZoAW+N2Heu/JL7Ymdl0JBrQkn89pA0fTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nH2tlkdb; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723604934; x=1755140934;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Qk7mEvYHo85REyjzvBa8f+wXCzKEXfe3EEwF4d9zNyk=;
  b=nH2tlkdbWU6IsdAnyfzaDwm/8gBXS/D2g4h3575b4WN07orB6LrShAx0
   r0Eg3Ih6R9q6pIkoLOsWj1wFdNw4xP1ck6A+acjwTNeQNK0mw3edQnSGz
   6Q0D1iy0CGx09GGYEeeEKIxLYqe+/lrgDkInmH/UgJHcTpkMks2S60pWE
   Ms17ou0T45BjVibEjEnOatybTJ08yvnrJtTOcaplDFQ/mC5ba3mC+MqpJ
   r36SnlJEEBQSDKtOTlEkLW8sI0caB38QsW8eUNOe7Zs2722SkPTpX8yNn
   +gYJn7hbthwTseu0HRgNuRzwFh5BMh3YrmlQqpGbXcc4YpAYoQX+9Cfe3
   A==;
X-CSE-ConnectionGUID: 7rgvmNbYSkm4LJQ3IJUP2A==
X-CSE-MsgGUID: LLz6LZ1TTmmv27G6ElDvNg==
X-IronPort-AV: E=McAfee;i="6700,10204,11163"; a="21943683"
X-IronPort-AV: E=Sophos;i="6.09,287,1716274800"; 
   d="scan'208";a="21943683"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2024 20:08:53 -0700
X-CSE-ConnectionGUID: H4BHdK13TEmW3KXH/AIZ3A==
X-CSE-MsgGUID: 4a2z6lQsTI+6gNAInmCnBQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,287,1716274800"; 
   d="scan'208";a="63268792"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by fmviesa005.fm.intel.com with ESMTP; 13 Aug 2024 20:08:50 -0700
Date: Wed, 14 Aug 2024 11:08:49 +0800
From: Yuan Yao <yuan.yao@linux.intel.com>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
	kai.huang@intel.com, isaku.yamahata@gmail.com,
	tony.lindgren@linux.intel.com, xiaoyao.li@intel.com,
	linux-kernel@vger.kernel.org,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: Re: [PATCH 13/25] KVM: TDX: create/destroy VM structure
Message-ID: <20240814030849.7yqx3db4oojsoh5k@yy-desk-7060>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-14-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240812224820.34826-14-rick.p.edgecombe@intel.com>
User-Agent: NeoMutt/20171215

On Mon, Aug 12, 2024 at 03:48:08PM -0700, Rick Edgecombe wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> Implement managing the TDX private KeyID to implement, create, destroy
> and free for a TDX guest.
>
> When creating at TDX guest, assign a TDX private KeyID for the TDX guest
> for memory encryption, and allocate pages for the guest. These are used
> for the Trust Domain Root (TDR) and Trust Domain Control Structure (TDCS).
>
> On destruction, free the allocated pages, and the KeyID.
>
> Before tearing down the private page tables, TDX requires the guest TD to
> be destroyed by reclaiming the KeyID. Do it at vm_destroy() kvm_x86_ops
> hook.
>
> Add a call for vm_free() at the end of kvm_arch_destroy_vm() because the
> per-VM TDR needs to be freed after the KeyID.
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Co-developed-by: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> Co-developed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> ---
...
> +void tdx_mmu_release_hkid(struct kvm *kvm)
> +{
> +	bool packages_allocated, targets_allocated;
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> +	cpumask_var_t packages, targets;
> +	u64 err;
> +	int i;
> +
> +	if (!is_hkid_assigned(kvm_tdx))
> +		return;
> +
> +	/* KeyID has been allocated but guest is not yet configured */
> +	if (!is_td_created(kvm_tdx)) {
> +		tdx_hkid_free(kvm_tdx);
> +		return;
> +	}
> +
> +	packages_allocated = zalloc_cpumask_var(&packages, GFP_KERNEL);
> +	targets_allocated = zalloc_cpumask_var(&targets, GFP_KERNEL);
> +	cpus_read_lock();
> +
> +	/*
> +	 * TDH.PHYMEM.CACHE.WB tries to acquire the TDX module global lock
> +	 * and can fail with TDX_OPERAND_BUSY when it fails to get the lock.
> +	 * Multiple TDX guests can be destroyed simultaneously. Take the
> +	 * mutex to prevent it from getting error.
> +	 */
> +	mutex_lock(&tdx_lock);
> +
> +	/*
> +	 * We need three SEAMCALLs, TDH.MNG.VPFLUSHDONE(), TDH.PHYMEM.CACHE.WB(),
> +	 * and TDH.MNG.KEY.FREEID() to free the HKID. When the HKID is assigned,
> +	 * we need to use TDH.MEM.SEPT.REMOVE() or TDH.MEM.PAGE.REMOVE(). When
> +	 * the HKID is free, we need to use TDH.PHYMEM.PAGE.RECLAIM().  Get lock
> +	 * to not present transient state of HKID.
> +	 */
> +	write_lock(&kvm->mmu_lock);
> +
> +	for_each_online_cpu(i) {
> +		if (packages_allocated &&
> +		    cpumask_test_and_set_cpu(topology_physical_package_id(i),
> +					     packages))
> +			continue;
> +		if (targets_allocated)
> +			cpumask_set_cpu(i, targets);
> +	}
> +	if (targets_allocated)
> +		on_each_cpu_mask(targets, smp_func_do_phymem_cache_wb, NULL, true);
> +	else
> +		on_each_cpu(smp_func_do_phymem_cache_wb, NULL, true);
> +	/*
> +	 * In the case of error in smp_func_do_phymem_cache_wb(), the following
> +	 * tdh_mng_key_freeid() will fail.
> +	 */
> +	err = tdh_mng_key_freeid(kvm_tdx);
> +	if (KVM_BUG_ON(err, kvm)) {
> +		pr_tdx_error(TDH_MNG_KEY_FREEID, err);
> +		pr_err("tdh_mng_key_freeid() failed. HKID %d is leaked.\n",
> +		       kvm_tdx->hkid);
> +	} else {
> +		tdx_hkid_free(kvm_tdx);
> +	}
> +
> +	write_unlock(&kvm->mmu_lock);
> +	mutex_unlock(&tdx_lock);
> +	cpus_read_unlock();
> +	free_cpumask_var(targets);
> +	free_cpumask_var(packages);
> +}
> +
> +static inline u8 tdx_sysinfo_nr_tdcs_pages(void)
> +{
> +	return tdx_sysinfo->td_ctrl.tdcs_base_size / PAGE_SIZE;
> +}
> +
> +void tdx_vm_free(struct kvm *kvm)
> +{
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> +	u64 err;
> +	int i;
> +
> +	/*
> +	 * tdx_mmu_release_hkid() failed to reclaim HKID.  Something went wrong
> +	 * heavily with TDX module.  Give up freeing TD pages.  As the function
> +	 * already warned, don't warn it again.
> +	 */
> +	if (is_hkid_assigned(kvm_tdx))
> +		return;
> +
> +	if (kvm_tdx->tdcs_pa) {
> +		for (i = 0; i < tdx_sysinfo_nr_tdcs_pages(); i++) {
> +			if (!kvm_tdx->tdcs_pa[i])
> +				continue;
> +
> +			tdx_reclaim_control_page(kvm_tdx->tdcs_pa[i]);
> +		}
> +		kfree(kvm_tdx->tdcs_pa);
> +		kvm_tdx->tdcs_pa = NULL;
> +	}
> +
> +	if (!kvm_tdx->tdr_pa)
> +		return;
> +
> +	if (__tdx_reclaim_page(kvm_tdx->tdr_pa))
> +		return;
> +
> +	/*
> +	 * Use a SEAMCALL to ask the TDX module to flush the cache based on the
> +	 * KeyID. TDX module may access TDR while operating on TD (Especially
> +	 * when it is reclaiming TDCS).
> +	 */
> +	err = tdh_phymem_page_wbinvd(set_hkid_to_hpa(kvm_tdx->tdr_pa,
> +						     tdx_global_keyid));
> +	if (KVM_BUG_ON(err, kvm)) {
> +		pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err);
> +		return;
> +	}
> +	tdx_clear_page(kvm_tdx->tdr_pa);
> +
> +	free_page((unsigned long)__va(kvm_tdx->tdr_pa));
> +	kvm_tdx->tdr_pa = 0;
> +}
> +
...
> +static int __tdx_td_init(struct kvm *kvm)
> +{
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> +	cpumask_var_t packages;
> +	unsigned long *tdcs_pa = NULL;
> +	unsigned long tdr_pa = 0;
> +	unsigned long va;
> +	int ret, i;
> +	u64 err;
> +
> +	ret = tdx_guest_keyid_alloc();
> +	if (ret < 0)
> +		return ret;
> +	kvm_tdx->hkid = ret;
> +
> +	va = __get_free_page(GFP_KERNEL_ACCOUNT);
> +	if (!va)
> +		goto free_hkid;
> +	tdr_pa = __pa(va);
> +
> +	tdcs_pa = kcalloc(tdx_sysinfo_nr_tdcs_pages(), sizeof(*kvm_tdx->tdcs_pa),
> +			  GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> +	if (!tdcs_pa)
> +		goto free_tdr;
> +
> +	for (i = 0; i < tdx_sysinfo_nr_tdcs_pages(); i++) {
> +		va = __get_free_page(GFP_KERNEL_ACCOUNT);
> +		if (!va)
> +			goto free_tdcs;
> +		tdcs_pa[i] = __pa(va);
> +	}
> +
> +	if (!zalloc_cpumask_var(&packages, GFP_KERNEL)) {
> +		ret = -ENOMEM;
> +		goto free_tdcs;
> +	}
> +
> +	cpus_read_lock();
> +
> +	/*
> +	 * Need at least one CPU of the package to be online in order to
> +	 * program all packages for host key id.  Check it.
> +	 */
> +	for_each_present_cpu(i)
> +		cpumask_set_cpu(topology_physical_package_id(i), packages);
> +	for_each_online_cpu(i)
> +		cpumask_clear_cpu(topology_physical_package_id(i), packages);
> +	if (!cpumask_empty(packages)) {
> +		ret = -EIO;
> +		/*
> +		 * Because it's hard for human operator to figure out the
> +		 * reason, warn it.
> +		 */
> +#define MSG_ALLPKG	"All packages need to have online CPU to create TD. Online CPU and retry.\n"
> +		pr_warn_ratelimited(MSG_ALLPKG);
> +		goto free_packages;
> +	}
> +
> +	/*
> +	 * TDH.MNG.CREATE tries to grab the global TDX module and fails
> +	 * with TDX_OPERAND_BUSY when it fails to grab.  Take the global
> +	 * lock to prevent it from failure.
> +	 */
> +	mutex_lock(&tdx_lock);
> +	kvm_tdx->tdr_pa = tdr_pa;
> +	err = tdh_mng_create(kvm_tdx, kvm_tdx->hkid);
> +	mutex_unlock(&tdx_lock);
> +
> +	if (err == TDX_RND_NO_ENTROPY) {
> +		kvm_tdx->tdr_pa = 0;

code path after 'free_packages' set it to 0, so this can be removed.

> +		ret = -EAGAIN;
> +		goto free_packages;
> +	}
> +
> +	if (WARN_ON_ONCE(err)) {
> +		kvm_tdx->tdr_pa = 0;

Ditto.

> +		pr_tdx_error(TDH_MNG_CREATE, err);
> +		ret = -EIO;
> +		goto free_packages;
> +	}
> +
> +	for_each_online_cpu(i) {
> +		int pkg = topology_physical_package_id(i);
> +
> +		if (cpumask_test_and_set_cpu(pkg, packages))
> +			continue;
> +
> +		/*
> +		 * Program the memory controller in the package with an
> +		 * encryption key associated to a TDX private host key id
> +		 * assigned to this TDR.  Concurrent operations on same memory
> +		 * controller results in TDX_OPERAND_BUSY. No locking needed
> +		 * beyond the cpus_read_lock() above as it serializes against
> +		 * hotplug and the first online CPU of the package is always
> +		 * used. We never have two CPUs in the same socket trying to
> +		 * program the key.
> +		 */
> +		ret = smp_call_on_cpu(i, tdx_do_tdh_mng_key_config,
> +				      kvm_tdx, true);
> +		if (ret)
> +			break;
> +	}
> +	cpus_read_unlock();
> +	free_cpumask_var(packages);
> +	if (ret) {
> +		i = 0;
> +		goto teardown;
> +	}
> +
> +	kvm_tdx->tdcs_pa = tdcs_pa;
> +	for (i = 0; i < tdx_sysinfo_nr_tdcs_pages(); i++) {
> +		err = tdh_mng_addcx(kvm_tdx, tdcs_pa[i]);
> +		if (err == TDX_RND_NO_ENTROPY) {
> +			/* Here it's hard to allow userspace to retry. */
> +			ret = -EBUSY;
> +			goto teardown;
> +		}
> +		if (WARN_ON_ONCE(err)) {
> +			pr_tdx_error(TDH_MNG_ADDCX, err);
> +			ret = -EIO;
> +			goto teardown;

This and above 'goto teardown' under same for() free the
partially added TDCX pages w/o take ownership back, may
'goto teardown_reclaim' (or any better name) below can
handle this, see next comment for this patch.

> +		}
> +	}
> +
> +	/*
> +	 * Note, TDH_MNG_INIT cannot be invoked here.  TDH_MNG_INIT requires a dedicated
> +	 * ioctl() to define the configure CPUID values for the TD.
> +	 */
> +	return 0;
> +
> +	/*
> +	 * The sequence for freeing resources from a partially initialized TD
> +	 * varies based on where in the initialization flow failure occurred.
> +	 * Simply use the full teardown and destroy, which naturally play nice
> +	 * with partial initialization.
> +	 */
> +teardown:
> +	for (; i < tdx_sysinfo_nr_tdcs_pages(); i++) {
> +		if (tdcs_pa[i]) {
> +			free_page((unsigned long)__va(tdcs_pa[i]));
> +			tdcs_pa[i] = 0;
> +		}
> +	}
> +	if (!kvm_tdx->tdcs_pa)
> +		kfree(tdcs_pa);

Add 'teardown_reclaim:' Here, pair with my last comment.

> +	tdx_mmu_release_hkid(kvm);
> +	tdx_vm_free(kvm);
> +
> +	return ret;
> +
> +free_packages:
> +	cpus_read_unlock();
> +	free_cpumask_var(packages);
> +
> +free_tdcs:
> +	for (i = 0; i < tdx_sysinfo_nr_tdcs_pages(); i++) {
> +		if (tdcs_pa[i])
> +			free_page((unsigned long)__va(tdcs_pa[i]));
> +	}
> +	kfree(tdcs_pa);
> +	kvm_tdx->tdcs_pa = NULL;
> +
> +free_tdr:
> +	if (tdr_pa)
> +		free_page((unsigned long)__va(tdr_pa));
> +	kvm_tdx->tdr_pa = 0;
> +
> +free_hkid:
> +	tdx_hkid_free(kvm_tdx);
> +
> +	return ret;
> +}
> +
>  int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
>  {
>  	struct kvm_tdx_cmd tdx_cmd;
> @@ -274,6 +747,11 @@ static int __init __tdx_bringup(void)
>  {
>  	int r;
>
> +	if (!cpu_feature_enabled(X86_FEATURE_MOVDIR64B)) {
> +		pr_warn("MOVDIR64B is reqiured for TDX\n");
> +		return -EOPNOTSUPP;
> +	}
> +
>  	if (!enable_ept) {
>  		pr_err("Cannot enable TDX with EPT disabled.\n");
>  		return -EINVAL;
> diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> index 78f84c53a948..268959d0f74f 100644
> --- a/arch/x86/kvm/vmx/tdx.h
> +++ b/arch/x86/kvm/vmx/tdx.h
> @@ -14,6 +14,9 @@ struct kvm_tdx {
>  	struct kvm kvm;
>
>  	unsigned long tdr_pa;
> +	unsigned long *tdcs_pa;
> +
> +	int hkid;
>  };
>
>  struct vcpu_tdx {
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index c1bdf7d8fee3..96c74880bd36 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -120,12 +120,18 @@ void vmx_setup_mce(struct kvm_vcpu *vcpu);
>
>  #ifdef CONFIG_INTEL_TDX_HOST
>  int tdx_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap);
> +int tdx_vm_init(struct kvm *kvm);
> +void tdx_mmu_release_hkid(struct kvm *kvm);
> +void tdx_vm_free(struct kvm *kvm);
>  int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
>  #else
>  static inline int tdx_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
>  {
>  	return -EINVAL;
>  };
> +static inline int tdx_vm_init(struct kvm *kvm) { return -EOPNOTSUPP; }
> +static inline void tdx_mmu_release_hkid(struct kvm *kvm) {}
> +static inline void tdx_vm_free(struct kvm *kvm) {}
>  static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
>  #endif
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 751b3841c48f..ce2ef63f30f2 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12852,6 +12852,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
>  	kvm_page_track_cleanup(kvm);
>  	kvm_xen_destroy_vm(kvm);
>  	kvm_hv_destroy_vm(kvm);
> +	static_call_cond(kvm_x86_vm_free)(kvm);
>  }
>
>  static void memslot_rmap_free(struct kvm_memory_slot *slot)
> --
> 2.34.1
>
>

