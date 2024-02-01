Return-Path: <kvm+bounces-7678-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E994D8452BB
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 09:32:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5AA2C1F26296
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 08:32:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCAEE15A498;
	Thu,  1 Feb 2024 08:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gCuTdw3P"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D35B2171D0;
	Thu,  1 Feb 2024 08:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706776354; cv=none; b=rZWR1wCZGnpK6LL6R2mlmTL0c0m4Wg+djTCjsL0tnYMnzfYxYMgrVebXq42gj2XaoHZEgsRCcW8CHYsmXGVONG0ZglKBv/0L9L7Dn2gMAfx8yx9hadDnw1I2pc6wGLQ5W4WlchXDapF4tvEHFub5iKFJADuZghZGNu8reupikso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706776354; c=relaxed/simple;
	bh=RnETpHswIxeuggpr8eHX9OVMxLvyaYBLdBnvLWvYjWQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=em+ZOTo+tgVeI7i7qzxsT+5ogyzTFKxWwzVpZdMCRwtztIT+2zsxkW0YF0zJz6kTts8Mea3NXQ0IbADprqO4+ZOxr21Lxcf0yKUsKNxJjZzwd6LPPbdMTSrTuO+0OUZCTMaaBDG9CqeSHfOPwA1YXON9eLG3Y5LtjtfXfTCUvsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gCuTdw3P; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706776353; x=1738312353;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=RnETpHswIxeuggpr8eHX9OVMxLvyaYBLdBnvLWvYjWQ=;
  b=gCuTdw3PZjjkuSUVK0K21SuPy7scwqBPjS6gXE2AviYoC/nRJdMuXOWr
   otCq58Au501AZ0qLBcSSJ0APllsJ1flCeR9NxwadVz0rck290+JrZOTn6
   ZPktZICpuV8iVXtBv9Z0XE4WIjpDGLdYTO1q2H5SoXBPs33eOSsdEzrp6
   ZKTsvhIC3wku0mji+HtJmmaFm8uanu9e0N6kx9kkGL0lLnEzYRhoO5oIs
   O7itzT4LpdlEH10CJFLI1AhZDplzqzqQ13fOIcxddi5jig3Iwlz90oTWU
   Tp5L7Hw2q407d5obBQXM4Tpz9ga/RTP2Vh4vCXvEDsdpVU4UOF0MGFs1E
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10969"; a="10944861"
X-IronPort-AV: E=Sophos;i="6.05,234,1701158400"; 
   d="scan'208";a="10944861"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2024 00:32:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,234,1701158400"; 
   d="scan'208";a="4318752"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by orviesa005.jf.intel.com with ESMTP; 01 Feb 2024 00:32:29 -0800
Date: Thu, 1 Feb 2024 16:32:27 +0800
From: Yuan Yao <yuan.yao@linux.intel.com>
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v18 024/121] KVM: TDX: create/destroy VM structure
Message-ID: <20240201083227.vwyqlptrr3bdwr7m@yy-desk-7060>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
 <167b3797f5928c580526f388761dcfb342626ad2.1705965634.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167b3797f5928c580526f388761dcfb342626ad2.1705965634.git.isaku.yamahata@intel.com>
User-Agent: NeoMutt/20171215

On Mon, Jan 22, 2024 at 03:53:00PM -0800, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> As the first step to create TDX guest, create/destroy VM struct.  Assign
> TDX private Host Key ID (HKID) to the TDX guest for memory encryption and
> allocate extra pages for the TDX guest. On destruction, free allocated
> pages, and HKID.
>
> Before tearing down private page tables, TDX requires some resources of the
> guest TD to be destroyed (i.e. HKID must have been reclaimed, etc).  Add
> mmu notifier release callback before tearing down private page tables for
> it.
>
> Add vm_free() of kvm_x86_ops hook at the end of kvm_arch_destroy_vm()
> because some per-VM TDX resources, e.g. TDR, need to be freed after other
> TDX resources, e.g. HKID, were freed.
>
> Co-developed-by: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>
> ---
> v18:
> - Use TDH.SYS.RD() instead of struct tdsysinfo_struct.
> - Rename tdx_reclaim_td_page() to tdx_reclaim_control_page()
> - return -EAGAIN on TDX_RND_NO_ENTROPY of TDH.MNG.CREATE(), TDH.MNG.ADDCX()
> - fix comment to remove extra the.
> - use true instead of 1 for boolean.
> - remove an extra white line.
>
> v16:
> - Simplified tdx_reclaim_page()
> - Reorganize the locking of tdx_release_hkid(), and use smp_call_mask()
>   instead of smp_call_on_cpu() to hold spinlock to race with invalidation
>   on releasing guest memfd
> ---
>  arch/x86/include/asm/kvm-x86-ops.h |   2 +
>  arch/x86/include/asm/kvm_host.h    |   2 +
>   arch/x86/kvm/Kconfig               |   3 +-
>  arch/x86/kvm/mmu/mmu.c             |   7 +
>  arch/x86/kvm/vmx/main.c            |  26 +-
>  arch/x86/kvm/vmx/tdx.c             | 474 ++++++++++++++++++++++++++++-
>  arch/x86/kvm/vmx/tdx.h             |   6 +-
>  arch/x86/kvm/vmx/x86_ops.h         |   6 +
>  arch/x86/kvm/x86.c                 |   1 +
>  9 files changed, 519 insertions(+), 8 deletions(-)
...
> +
> +static int __tdx_reclaim_page(hpa_t pa)
> +{
> +	struct tdx_module_args out;
> +	u64 err;
> +
> +	do {
> +		err = tdh_phymem_page_reclaim(pa, &out);
> +		/*
> +		 * TDH.PHYMEM.PAGE.RECLAIM is allowed only when TD is shutdown.
> +		 * state.  i.e. destructing TD.
> +		 * TDH.PHYMEM.PAGE.RECLAIM requires TDR and target page.
> +		 * Because we're destructing TD, it's rare to contend with TDR.
> +		 */
> +	} while (unlikely(err == (TDX_OPERAND_BUSY | TDX_OPERAND_ID_RCX)));

v16 changed to tdx module 1.5, so here should be TDX_OPERAND_ID_TDR, value 128ULL.

> +	if (WARN_ON_ONCE(err)) {
> +		pr_tdx_error(TDH_PHYMEM_PAGE_RECLAIM, err, &out);
> +		return -EIO;
> +	}
> +
> +	return 0;
> +}
> +
> +static int tdx_reclaim_page(hpa_t pa)
> +{
> +	int r;
> +
> +	r = __tdx_reclaim_page(pa);
> +	if (!r)
> +		tdx_clear_page(pa);
> +	return r;
> +}
> +
> +static void tdx_reclaim_control_page(unsigned long td_page_pa)
> +{
> +	WARN_ON_ONCE(!td_page_pa);
> +
> +	/*
> +	 * TDCX are being reclaimed.  TDX module maps TDCX with HKID
> +	 * assigned to the TD.  Here the cache associated to the TD
> +	 * was already flushed by TDH.PHYMEM.CACHE.WB before here, So
> +	 * cache doesn't need to be flushed again.
> +	 */
> +	if (tdx_reclaim_page(td_page_pa))
> +		/*
> +		 * Leak the page on failure:
> +		 * tdx_reclaim_page() returns an error if and only if there's an
> +		 * unexpected, fatal error, e.g. a SEAMCALL with bad params,
> +		 * incorrect concurrency in KVM, a TDX Module bug, etc.
> +		 * Retrying at a later point is highly unlikely to be
> +		 * successful.
> +		 * No log here as tdx_reclaim_page() already did.
> +		 */
> +		return;
> +	free_page((unsigned long)__va(td_page_pa));
> +}
> +
> +static void tdx_do_tdh_phymem_cache_wb(void *unused)
> +{
> +	u64 err = 0;
> +
> +	do {
> +		err = tdh_phymem_cache_wb(!!err);
> +	} while (err == TDX_INTERRUPTED_RESUMABLE);
> +
> +	/* Other thread may have done for us. */
> +	if (err == TDX_NO_HKID_READY_TO_WBCACHE)
> +		err = TDX_SUCCESS;
> +	if (WARN_ON_ONCE(err))
> +		pr_tdx_error(TDH_PHYMEM_CACHE_WB, err, NULL);
> +}
> +
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
> +	 * We can destroy multiple guest TDs simultaneously.  Prevent
> +	 * tdh_phymem_cache_wb from returning TDX_BUSY by serialization.
> +	 */
> +	mutex_lock(&tdx_lock);
> +
> +	/*
> +	 * Go through multiple TDX HKID state transitions with three SEAMCALLs
> +	 * to make TDH.PHYMEM.PAGE.RECLAIM() usable.  Make the transition atomic
> +	 * to other functions to operate private pages and Secure-EPT pages.
> +	 *
> +	 * Avoid race for kvm_gmem_release() to call kvm_mmu_unmap_gfn_range().
> +	 * This function is called via mmu notifier, mmu_release().
> +	 * kvm_gmem_release() is called via fput() on process exit.
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
> +		on_each_cpu_mask(targets, tdx_do_tdh_phymem_cache_wb, NULL, true);
> +	else
> +		on_each_cpu(tdx_do_tdh_phymem_cache_wb, NULL, true);
> +	/*
> +	 * In the case of error in tdx_do_tdh_phymem_cache_wb(), the following
> +	 * tdh_mng_key_freeid() will fail.
> +	 */
> +	err = tdh_mng_key_freeid(kvm_tdx->tdr_pa);
> +	if (WARN_ON_ONCE(err)) {
> +		pr_tdx_error(TDH_MNG_KEY_FREEID, err, NULL);
> +		pr_err("tdh_mng_key_freeid() failed. HKID %d is leaked.\n",
> +		       kvm_tdx->hkid);
> +	} else
> +		tdx_hkid_free(kvm_tdx);
> +
> +	write_unlock(&kvm->mmu_lock);
> +	mutex_unlock(&tdx_lock);
> +	cpus_read_unlock();
> +	free_cpumask_var(targets);
> +	free_cpumask_var(packages);
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
> +		for (i = 0; i < tdx_info->nr_tdcs_pages; i++) {
> +			if (kvm_tdx->tdcs_pa[i])
> +				tdx_reclaim_control_page(kvm_tdx->tdcs_pa[i]);
> +		}
> +		kfree(kvm_tdx->tdcs_pa);
> +		kvm_tdx->tdcs_pa = NULL;
> +	}
> +
> +	if (!kvm_tdx->tdr_pa)
> +		return;
> +	if (__tdx_reclaim_page(kvm_tdx->tdr_pa))
> +		return;
> +	/*
> +	 * TDX module maps TDR with TDX global HKID.  TDX module may access TDR
> +	 * while operating on TD (Especially reclaiming TDCS).  Cache flush with
> +	 * TDX global HKID is needed.
> +	 */
> +	err = tdh_phymem_page_wbinvd(set_hkid_to_hpa(kvm_tdx->tdr_pa,
> +						     tdx_global_keyid));
> +	if (WARN_ON_ONCE(err)) {
> +		pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err, NULL);
> +		return;
> +	}
> +	tdx_clear_page(kvm_tdx->tdr_pa);
> +
> +	free_page((unsigned long)__va(kvm_tdx->tdr_pa));
> +	kvm_tdx->tdr_pa = 0;
> +}
> +
> +static int tdx_do_tdh_mng_key_config(void *param)
> +{
> +	hpa_t *tdr_p = param;
> +	u64 err;
> +
> +	do {
> +		err = tdh_mng_key_config(*tdr_p);
> +
> +		/*
> +		 * If it failed to generate a random key, retry it because this
> +		 * is typically caused by an entropy error of the CPU's random
> +		 * number generator.
> +		 */
> +	} while (err == TDX_KEY_GENERATION_FAILED);
> +
> +	if (WARN_ON_ONCE(err)) {
> +		pr_tdx_error(TDH_MNG_KEY_CONFIG, err, NULL);
> +		return -EIO;
> +	}
> +
> +	return 0;
> +}
> +
> +static int __tdx_td_init(struct kvm *kvm);
> +
> +int tdx_vm_init(struct kvm *kvm)
> +{
> +	/*
> +	 * TDX has its own limit of the number of vcpus in addition to
> +	 * KVM_MAX_VCPUS.
> +	 */
> +	kvm->max_vcpus = min(kvm->max_vcpus, TDX_MAX_VCPUS);
> +
> +	/* Place holder for TDX specific logic. */
> +	return __tdx_td_init(kvm);
> +}
> +
>  static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
>  {
>  	struct kvm_tdx_capabilities __user *user_caps;
> @@ -181,6 +459,176 @@ static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
>  	return ret;
>  }
>
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
> +	tdcs_pa = kcalloc(tdx_info->nr_tdcs_pages, sizeof(*kvm_tdx->tdcs_pa),
> +			  GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> +	if (!tdcs_pa)
> +		goto free_tdr;
> +	for (i = 0; i < tdx_info->nr_tdcs_pages; i++) {
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
> +	cpus_read_lock();
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

Generate/release hkid both requests to have "cpumask of at least 1
cpu per each node", how about add one helper for this ? The helper also
checks the cpus_read_lock() is held and return the cpumask if at least
1 cpu is online per node, thus this init funciotn can be simplified and
become more easy to review.

> +
> +	/*
> +	 * Acquire global lock to avoid TDX_OPERAND_BUSY:
> +	 * TDH.MNG.CREATE and other APIs try to lock the global Key Owner
> +	 * Table (KOT) to track the assigned TDX private HKID.  It doesn't spin
> +	 * to acquire the lock, returns TDX_OPERAND_BUSY instead, and let the
> +	 * caller to handle the contention.  This is because of time limitation
> +	 * usable inside the TDX module and OS/VMM knows better about process
> +	 * scheduling.
> +	 *
> +	 * APIs to acquire the lock of KOT:
> +	 * TDH.MNG.CREATE, TDH.MNG.KEY.FREEID, TDH.MNG.VPFLUSHDONE, and
> +	 * TDH.PHYMEM.CACHE.WB.
> +	 */
> +	mutex_lock(&tdx_lock);
> +	err = tdh_mng_create(tdr_pa, kvm_tdx->hkid);
> +	mutex_unlock(&tdx_lock);
> +	if (err == TDX_RND_NO_ENTROPY) {
> +		ret = -EAGAIN;
> +		goto free_packages;
> +	}
> +	if (WARN_ON_ONCE(err)) {
> +		pr_tdx_error(TDH_MNG_CREATE, err, NULL);
> +		ret = -EIO;
> +		goto free_packages;
> +	}
> +	kvm_tdx->tdr_pa = tdr_pa;
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
> +		 * controller results in TDX_OPERAND_BUSY.  Avoid this race by
> +		 * mutex.
> +		 */
> +		mutex_lock(&tdx_mng_key_config_lock[pkg]);
> +		ret = smp_call_on_cpu(i, tdx_do_tdh_mng_key_config,
> +				      &kvm_tdx->tdr_pa, true);
> +		mutex_unlock(&tdx_mng_key_config_lock[pkg]);
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
> +	for (i = 0; i < tdx_info->nr_tdcs_pages; i++) {
> +		err = tdh_mng_addcx(kvm_tdx->tdr_pa, tdcs_pa[i]);
> +		if (err == TDX_RND_NO_ENTROPY) {
> +			/* Here it's hard to allow userspace to retry. */
> +			ret = -EBUSY;
> +			goto teardown;
> +		}
> +		if (WARN_ON_ONCE(err)) {
> +			pr_tdx_error(TDH_MNG_ADDCX, err, NULL);
> +			ret = -EIO;
> +			goto teardown;
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
> +	for (; i < tdx_info->nr_tdcs_pages; i++) {
> +		if (tdcs_pa[i]) {
> +			free_page((unsigned long)__va(tdcs_pa[i]));
> +			tdcs_pa[i] = 0;
> +		}
> +	}
> +	if (!kvm_tdx->tdcs_pa)
> +		kfree(tdcs_pa);
> +	tdx_mmu_release_hkid(kvm);
> +	tdx_vm_free(kvm);
> +	return ret;
> +
> +free_packages:
> +	cpus_read_unlock();
> +	free_cpumask_var(packages);
> +free_tdcs:
> +	for (i = 0; i < tdx_info->nr_tdcs_pages; i++) {
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
> +free_hkid:
> +	if (is_hkid_assigned(kvm_tdx))
> +		tdx_hkid_free(kvm_tdx);
> +	return ret;
> +}
> +
>  int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
>  {
>  	struct kvm_tdx_cmd tdx_cmd;
> @@ -212,12 +660,13 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
>
>  static int __init tdx_module_setup(void)
>  {
> -	u16 num_cpuid_config;
> +	u16 num_cpuid_config, tdcs_base_size;
>  	int ret;
>  	u32 i;
>
>  	struct tdx_md_map mds[] = {
>  		TDX_MD_MAP(NUM_CPUID_CONFIG, &num_cpuid_config),
> +		TDX_MD_MAP(TDCS_BASE_SIZE, &tdcs_base_size),
>  	};
>
>  #define TDX_INFO_MAP(_field_id, _member)			\
> @@ -272,6 +721,8 @@ static int __init tdx_module_setup(void)
>  		c->edx = ecx_edx >> 32;
>  	}
>
> +	tdx_info->nr_tdcs_pages = tdcs_base_size / PAGE_SIZE;
> +
>  	return 0;
>
>  error_sys_rd:
> @@ -319,13 +770,27 @@ int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
>  	struct vmx_tdx_enabled vmx_tdx = {
>  		.err = ATOMIC_INIT(0),
>  	};
> +	int max_pkgs;
>  	int r = 0;
> +	int i;
>
> +	if (!cpu_feature_enabled(X86_FEATURE_MOVDIR64B)) {
> +		pr_warn("MOVDIR64B is reqiured for TDX\n");
> +		return -EOPNOTSUPP;
> +	}
>  	if (!enable_ept) {
>  		pr_warn("Cannot enable TDX with EPT disabled\n");
>  		return -EINVAL;
>  	}
>
> +	max_pkgs = topology_max_packages();
> +	tdx_mng_key_config_lock = kcalloc(max_pkgs, sizeof(*tdx_mng_key_config_lock),
> +				   GFP_KERNEL);
> +	if (!tdx_mng_key_config_lock)
> +		return -ENOMEM;
> +	for (i = 0; i < max_pkgs; i++)
> +		mutex_init(&tdx_mng_key_config_lock[i]);
> +
>  	if (!zalloc_cpumask_var(&vmx_tdx.vmx_enabled, GFP_KERNEL)) {
>  		r = -ENOMEM;
>  		goto out;
> @@ -350,4 +815,5 @@ int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
>  void tdx_hardware_unsetup(void)
>  {
>  	kfree(tdx_info);
> +	kfree(tdx_mng_key_config_lock);
>  }
> diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> index 22c0b57f69ca..ae117f864cfb 100644
> --- a/arch/x86/kvm/vmx/tdx.h
> +++ b/arch/x86/kvm/vmx/tdx.h
> @@ -8,7 +8,11 @@
>
>  struct kvm_tdx {
>  	struct kvm kvm;
> -	/* TDX specific members follow. */
> +
> +	unsigned long tdr_pa;
> +	unsigned long *tdcs_pa;
> +
> +	int hkid;
>  };
>
>  struct vcpu_tdx {
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index 3a3be66888da..5befcc2d58e1 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -140,6 +140,9 @@ void tdx_hardware_unsetup(void);
>  bool tdx_is_vm_type_supported(unsigned long type);
>
>  int tdx_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap);
> +int tdx_vm_init(struct kvm *kvm);
> +void tdx_mmu_release_hkid(struct kvm *kvm);
> +void tdx_vm_free(struct kvm *kvm);
>  int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
>  #else
>  static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return -EOPNOTSUPP; }
> @@ -150,6 +153,9 @@ static inline int tdx_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
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
> index a1389ddb1b33..3ab243d9fe9d 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12714,6 +12714,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
>  	kvm_page_track_cleanup(kvm);
>  	kvm_xen_destroy_vm(kvm);
>  	kvm_hv_destroy_vm(kvm);
> +	static_call_cond(kvm_x86_vm_free)(kvm);
>  }
>
>  static void memslot_rmap_free(struct kvm_memory_slot *slot)
> --
> 2.25.1
>
>

