Return-Path: <kvm+bounces-12381-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 71FA7885A7D
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 15:17:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 932E71C20DEF
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 14:17:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BA438526B;
	Thu, 21 Mar 2024 14:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="T5l5yva/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DBAD84FCC;
	Thu, 21 Mar 2024 14:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711030633; cv=none; b=LzUy+RNAqhaj2WbarG1YF8DSq3HIvHgtBuVcI+A5ZnrTr0/nbL2d85aMbMVoA4f2s8nkQxHXSRzW3O4+1on9o7sEy/yKTEk8YYIJTc4pIA31xYqvMeXsF3IhCji0C9X4ar+J81jUk7D82JHOarwi+txRZdKnk8HApnUuA1wRrtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711030633; c=relaxed/simple;
	bh=9XQwFo1aUQ9b/EM6QySTpjS4eXrihk6w1KvM2UgC27A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c/EL/EaARJ8+rqNn0PByzue+D6N1hRImideJpde31OlfMLBLm8KNIyGO8RttXF/Z/8j1XC2bY+s/K4olfcxIQGdjCXabcemGcY3pdpTsScGpDUpNGHzglqn+BWNFmbvq3svqyJ0AEPGMUsv4Kzkdp1Vy1Dj9e2czNylBBWZW/pI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=T5l5yva/; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711030631; x=1742566631;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=9XQwFo1aUQ9b/EM6QySTpjS4eXrihk6w1KvM2UgC27A=;
  b=T5l5yva/PfSpyDNiX9ACAL8I156wzo9Yp0oij8eqhfMpEr0lEsqCXvMv
   Y0zQ1FmXm8/sgKM4XqtevcAxuRv/JDcSM3pFgPvqtTuVt8KwTefLyVG/w
   icKkPdbyX4O1LaQyXqk9gCCcwcQfJhYRYOGL2o58dazJXHMJq29GHcjWJ
   0/POkXGxXHyquK4COCoMO/qOcmSBKFjgYy+vxN6YWR5CRuMcCn289sFKp
   ENQAVLxjD8H/ROC+fv0AbYXdfIWE4XlQlg6fdd1IMmcd8JBshBPlUEH96
   VxnGR341I6Jyz4je6/iydyL/dMrOwn0jeaZFV3GDLWY+upV6aF36mvAqk
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11019"; a="5963243"
X-IronPort-AV: E=Sophos;i="6.07,143,1708416000"; 
   d="scan'208";a="5963243"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2024 07:17:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,143,1708416000"; 
   d="scan'208";a="15164123"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2024 07:17:10 -0700
Date: Thu, 21 Mar 2024 07:17:09 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Chao Gao <chao.gao@intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 038/130] KVM: TDX: create/destroy VM structure
Message-ID: <20240321141709.GK1994522@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <7a508f88e8c8b5199da85b7a9959882ddf390796.1708933498.git.isaku.yamahata@intel.com>
 <ZfpwIespKy8qxWWE@chao-email>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZfpwIespKy8qxWWE@chao-email>

On Wed, Mar 20, 2024 at 01:12:01PM +0800,
Chao Gao <chao.gao@intel.com> wrote:

> > config KVM_SW_PROTECTED_VM
> > 	bool "Enable support for KVM software-protected VMs"
> >-	depends on EXPERT
> > 	depends on KVM && X86_64
> > 	select KVM_GENERIC_PRIVATE_MEM
> > 	help
> >@@ -89,6 +88,8 @@ config KVM_SW_PROTECTED_VM
> > config KVM_INTEL
> > 	tristate "KVM for Intel (and compatible) processors support"
> > 	depends on KVM && IA32_FEAT_CTL
> >+	select KVM_SW_PROTECTED_VM if INTEL_TDX_HOST
> 
> why does INTEL_TDX_HOST select KVM_SW_PROTECTED_VM?

I wanted KVM_GENERIC_PRIVATE_MEM.  Ah, we should do

        select KKVM_GENERIC_PRIVATE_MEM if INTEL_TDX_HOST


> >+	select KVM_GENERIC_MEMORY_ATTRIBUTES if INTEL_TDX_HOST
> > 	help
> > 	.vcpu_precreate = vmx_vcpu_precreate,
> > 	.vcpu_create = vmx_vcpu_create,
> 
> >--- a/arch/x86/kvm/vmx/tdx.c
> >+++ b/arch/x86/kvm/vmx/tdx.c
> >@@ -5,10 +5,11 @@
> > 
> > #include "capabilities.h"
> > #include "x86_ops.h"
> >-#include "x86.h"
> > #include "mmu.h"
> > #include "tdx_arch.h"
> > #include "tdx.h"
> >+#include "tdx_ops.h"
> >+#include "x86.h"
> 
> any reason to reorder x86.h?

No, I think it's accidental during rebase.
Will fix.



> >+static void tdx_do_tdh_phymem_cache_wb(void *unused)
> >+{
> >+	u64 err = 0;
> >+
> >+	do {
> >+		err = tdh_phymem_cache_wb(!!err);
> >+	} while (err == TDX_INTERRUPTED_RESUMABLE);
> >+
> >+	/* Other thread may have done for us. */
> >+	if (err == TDX_NO_HKID_READY_TO_WBCACHE)
> >+		err = TDX_SUCCESS;
> >+	if (WARN_ON_ONCE(err))
> >+		pr_tdx_error(TDH_PHYMEM_CACHE_WB, err, NULL);
> >+}
> >+
> >+void tdx_mmu_release_hkid(struct kvm *kvm)
> >+{
> >+	bool packages_allocated, targets_allocated;
> >+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> >+	cpumask_var_t packages, targets;
> >+	u64 err;
> >+	int i;
> >+
> >+	if (!is_hkid_assigned(kvm_tdx))
> >+		return;
> >+
> >+	if (!is_td_created(kvm_tdx)) {
> >+		tdx_hkid_free(kvm_tdx);
> >+		return;
> >+	}
> >+
> >+	packages_allocated = zalloc_cpumask_var(&packages, GFP_KERNEL);
> >+	targets_allocated = zalloc_cpumask_var(&targets, GFP_KERNEL);
> >+	cpus_read_lock();
> >+
> >+	/*
> >+	 * We can destroy multiple guest TDs simultaneously.  Prevent
> >+	 * tdh_phymem_cache_wb from returning TDX_BUSY by serialization.
> >+	 */
> >+	mutex_lock(&tdx_lock);
> >+
> >+	/*
> >+	 * Go through multiple TDX HKID state transitions with three SEAMCALLs
> >+	 * to make TDH.PHYMEM.PAGE.RECLAIM() usable.  Make the transition atomic
> >+	 * to other functions to operate private pages and Secure-EPT pages.
> >+	 *
> >+	 * Avoid race for kvm_gmem_release() to call kvm_mmu_unmap_gfn_range().
> >+	 * This function is called via mmu notifier, mmu_release().
> >+	 * kvm_gmem_release() is called via fput() on process exit.
> >+	 */
> >+	write_lock(&kvm->mmu_lock);
> >+
> >+	for_each_online_cpu(i) {
> >+		if (packages_allocated &&
> >+		    cpumask_test_and_set_cpu(topology_physical_package_id(i),
> >+					     packages))
> >+			continue;
> >+		if (targets_allocated)
> >+			cpumask_set_cpu(i, targets);
> >+	}
> >+	if (targets_allocated)
> >+		on_each_cpu_mask(targets, tdx_do_tdh_phymem_cache_wb, NULL, true);
> >+	else
> >+		on_each_cpu(tdx_do_tdh_phymem_cache_wb, NULL, true);
> 
> This tries flush cache on all CPUs when we run out of memory. I am not sure if
> it is the best solution. A simple solution is just use two global bitmaps.
> 
> And current logic isn't optimal. e.g., if packages_allocated is true while
> targets_allocated is false, then we will fill in the packages bitmap but don't
> use it at all.
> 
> That said, I prefer to optimize the rare case in a separate patch. We can just use
> two global bitmaps or let the flush fail here just as you are doing below on
> seamcall failure.

Makes sense. We can allocate cpumasks on hardware_setup/unsetup() and update them
on hardware_enable/disable().

...

> >+static int __tdx_td_init(struct kvm *kvm)
> >+{
> >+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> >+	cpumask_var_t packages;
> >+	unsigned long *tdcs_pa = NULL;
> >+	unsigned long tdr_pa = 0;
> >+	unsigned long va;
> >+	int ret, i;
> >+	u64 err;
> >+
> >+	ret = tdx_guest_keyid_alloc();
> >+	if (ret < 0)
> >+		return ret;
> >+	kvm_tdx->hkid = ret;
> >+
> >+	va = __get_free_page(GFP_KERNEL_ACCOUNT);
> >+	if (!va)
> >+		goto free_hkid;
> >+	tdr_pa = __pa(va);
> >+
> >+	tdcs_pa = kcalloc(tdx_info->nr_tdcs_pages, sizeof(*kvm_tdx->tdcs_pa),
> >+			  GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> >+	if (!tdcs_pa)
> >+		goto free_tdr;
> >+	for (i = 0; i < tdx_info->nr_tdcs_pages; i++) {
> >+		va = __get_free_page(GFP_KERNEL_ACCOUNT);
> >+		if (!va)
> >+			goto free_tdcs;
> >+		tdcs_pa[i] = __pa(va);
> >+	}
> >+
> >+	if (!zalloc_cpumask_var(&packages, GFP_KERNEL)) {
> >+		ret = -ENOMEM;
> >+		goto free_tdcs;
> >+	}
> >+	cpus_read_lock();
> >+	/*
> >+	 * Need at least one CPU of the package to be online in order to
> >+	 * program all packages for host key id.  Check it.
> >+	 */
> >+	for_each_present_cpu(i)
> >+		cpumask_set_cpu(topology_physical_package_id(i), packages);
> >+	for_each_online_cpu(i)
> >+		cpumask_clear_cpu(topology_physical_package_id(i), packages);
> >+	if (!cpumask_empty(packages)) {
> >+		ret = -EIO;
> >+		/*
> >+		 * Because it's hard for human operator to figure out the
> >+		 * reason, warn it.
> >+		 */
> >+#define MSG_ALLPKG	"All packages need to have online CPU to create TD. Online CPU and retry.\n"
> >+		pr_warn_ratelimited(MSG_ALLPKG);
> >+		goto free_packages;
> >+	}
> >+
> >+	/*
> >+	 * Acquire global lock to avoid TDX_OPERAND_BUSY:
> >+	 * TDH.MNG.CREATE and other APIs try to lock the global Key Owner
> >+	 * Table (KOT) to track the assigned TDX private HKID.  It doesn't spin
> >+	 * to acquire the lock, returns TDX_OPERAND_BUSY instead, and let the
> >+	 * caller to handle the contention.  This is because of time limitation
> >+	 * usable inside the TDX module and OS/VMM knows better about process
> >+	 * scheduling.
> >+	 *
> >+	 * APIs to acquire the lock of KOT:
> >+	 * TDH.MNG.CREATE, TDH.MNG.KEY.FREEID, TDH.MNG.VPFLUSHDONE, and
> >+	 * TDH.PHYMEM.CACHE.WB.
> >+	 */
> >+	mutex_lock(&tdx_lock);
> >+	err = tdh_mng_create(tdr_pa, kvm_tdx->hkid);
> >+	mutex_unlock(&tdx_lock);
> >+	if (err == TDX_RND_NO_ENTROPY) {
> >+		ret = -EAGAIN;
> >+		goto free_packages;
> >+	}
> >+	if (WARN_ON_ONCE(err)) {
> >+		pr_tdx_error(TDH_MNG_CREATE, err, NULL);
> >+		ret = -EIO;
> >+		goto free_packages;
> >+	}
> >+	kvm_tdx->tdr_pa = tdr_pa;
> >+
> >+	for_each_online_cpu(i) {
> >+		int pkg = topology_physical_package_id(i);
> >+
> >+		if (cpumask_test_and_set_cpu(pkg, packages))
> >+			continue;
> >+
> >+		/*
> >+		 * Program the memory controller in the package with an
> >+		 * encryption key associated to a TDX private host key id
> >+		 * assigned to this TDR.  Concurrent operations on same memory
> >+		 * controller results in TDX_OPERAND_BUSY.  Avoid this race by
> >+		 * mutex.
> >+		 */
> >+		mutex_lock(&tdx_mng_key_config_lock[pkg]);
> 
> the lock is superfluous to me. with cpu lock held, even if multiple CPUs try to
> create TDs, the same set of CPUs (the first online CPU of each package) will be
> selected to configure the key because of the cpumask_test_and_set_cpu() above.
> it means, we never have two CPUs in the same socket trying to program the key,
> i.e., no concurrent calls.

Makes sense. Will drop the lock.


> >+		ret = smp_call_on_cpu(i, tdx_do_tdh_mng_key_config,
> >+				      &kvm_tdx->tdr_pa, true);
> >+		mutex_unlock(&tdx_mng_key_config_lock[pkg]);
> >+		if (ret)
> >+			break;
> >+	}
> >+	cpus_read_unlock();
> >+	free_cpumask_var(packages);
> >+	if (ret) {
> >+		i = 0;
> >+		goto teardown;
> >+	}
> >+
> >+	kvm_tdx->tdcs_pa = tdcs_pa;
> >+	for (i = 0; i < tdx_info->nr_tdcs_pages; i++) {
> >+		err = tdh_mng_addcx(kvm_tdx->tdr_pa, tdcs_pa[i]);
> >+		if (err == TDX_RND_NO_ENTROPY) {
> >+			/* Here it's hard to allow userspace to retry. */
> >+			ret = -EBUSY;
> >+			goto teardown;
> >+		}
> >+		if (WARN_ON_ONCE(err)) {
> >+			pr_tdx_error(TDH_MNG_ADDCX, err, NULL);
> >+			ret = -EIO;
> >+			goto teardown;
> >+		}
> >+	}
> >+
> >+	/*
> >+	 * Note, TDH_MNG_INIT cannot be invoked here.  TDH_MNG_INIT requires a dedicated
> >+	 * ioctl() to define the configure CPUID values for the TD.
> >+	 */
> >+	return 0;
> >+
> >+	/*
> >+	 * The sequence for freeing resources from a partially initialized TD
> >+	 * varies based on where in the initialization flow failure occurred.
> >+	 * Simply use the full teardown and destroy, which naturally play nice
> >+	 * with partial initialization.
> >+	 */
> >+teardown:
> >+	for (; i < tdx_info->nr_tdcs_pages; i++) {
> >+		if (tdcs_pa[i]) {
> >+			free_page((unsigned long)__va(tdcs_pa[i]));
> >+			tdcs_pa[i] = 0;
> >+		}
> >+	}
> >+	if (!kvm_tdx->tdcs_pa)
> >+		kfree(tdcs_pa);
> >+	tdx_mmu_release_hkid(kvm);
> >+	tdx_vm_free(kvm);
> >+	return ret;
> >+
> >+free_packages:
> >+	cpus_read_unlock();
> >+	free_cpumask_var(packages);
> >+free_tdcs:
> >+	for (i = 0; i < tdx_info->nr_tdcs_pages; i++) {
> >+		if (tdcs_pa[i])
> >+			free_page((unsigned long)__va(tdcs_pa[i]));
> >+	}
> >+	kfree(tdcs_pa);
> >+	kvm_tdx->tdcs_pa = NULL;
> >+
> >+free_tdr:
> >+	if (tdr_pa)
> >+		free_page((unsigned long)__va(tdr_pa));
> >+	kvm_tdx->tdr_pa = 0;
> >+free_hkid:
> >+	if (is_hkid_assigned(kvm_tdx))
> 
> IIUC, this is always true because you just return if keyid
> allocation fails.

You're right. Will fix
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

