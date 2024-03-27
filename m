Return-Path: <kvm+bounces-12906-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0849488F222
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 23:54:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8C4601F2E918
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 22:54:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCFC4154437;
	Wed, 27 Mar 2024 22:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MIG180wm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3581154430;
	Wed, 27 Mar 2024 22:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711580023; cv=none; b=RvUBy39oYoW5obEd351Wjnb+4BFM4sO+Ivo/2/54JO0Qlw8WfHtOIBceaLzy2oQS+dUIlYT7r+uRRz/S8oxI8vXEoZ7l56HDHlWgVUUJXWJVwHeHNGwJ+EXTifixyc8y5VE+D7v+k9HXAdTTiUF8PZbvoJFxzcGFrqyAqHpGxpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711580023; c=relaxed/simple;
	bh=pGS6XRKRkwNcNdiGrNzGelAPGlvj+qQ18x69yBkIU5Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sYS2uPbGZLGRJLiLjmcYMDsoEKHB+OBc8TPtxDSO2c7T0UT1kdQIohgwX4NZz6CrTiWbUpVAUeeLpD1Z3tRL8XM70+Z9jeFAzXShHbjJNDJYwlIxaeqe4aLfMnLOp7UX3MsHXyvY+N/Lo1qxAFGxwb0ivUHP3blTrOl84iY+2b8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MIG180wm; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711580019; x=1743116019;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=pGS6XRKRkwNcNdiGrNzGelAPGlvj+qQ18x69yBkIU5Q=;
  b=MIG180wmg/ij59bk0WXVhoMgF33n686yQ8Jp2vmVqz1RBBHbqO/zD4YH
   vkZEBhTnh9cpPSGQ0+yRVHGhTREA+iaMH1h0YAxXPJVULP/Jpsk6qnlBp
   jjWjiGgYQ3xp//34CxetUaJtvfqS95qlq75UnnHZgxzR765K8jmRjqbQP
   k3D6dMkSTNHyCAy5jRudNiaRX8TL9DcOR001J0o9S4BynLGEBhtuYbaFi
   aTJNIXTQqqE9gDD7cBpAZi8Zr6fX9Jr79Bine5bUZ1aCgCx6ogEPwaejv
   RplW7HPW5WSLkFcq/cAB+fY0MbllkEwjTHkXQJF2bzdQm5yJjUqAPngX9
   A==;
X-CSE-ConnectionGUID: sjLY3w8OSkuJsr+7VFNWnQ==
X-CSE-MsgGUID: e4c+U5gvT+iGq0LEoQkfog==
X-IronPort-AV: E=McAfee;i="6600,9927,11026"; a="6903581"
X-IronPort-AV: E=Sophos;i="6.07,160,1708416000"; 
   d="scan'208";a="6903581"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 15:53:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,160,1708416000"; 
   d="scan'208";a="16474920"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 15:53:39 -0700
Date: Wed, 27 Mar 2024 15:53:37 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
Cc: "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, "Chen, Bo2" <chen.bo@intel.com>,
	"Yuan, Hang" <hang.yuan@intel.com>,
	"Zhang, Tina" <tina.zhang@intel.com>,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 038/130] KVM: TDX: create/destroy VM structure
Message-ID: <20240327225337.GF2444378@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <7a508f88e8c8b5199da85b7a9959882ddf390796.1708933498.git.isaku.yamahata@intel.com>
 <a0627c0f-5c2d-4403-807f-fc800b43fd3b@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a0627c0f-5c2d-4403-807f-fc800b43fd3b@intel.com>

On Tue, Mar 26, 2024 at 02:43:54PM +1300,
"Huang, Kai" <kai.huang@intel.com> wrote:

> ... continue the previous review ...
> 
> > +
> > +static void tdx_reclaim_control_page(unsigned long td_page_pa)
> > +{
> > +	WARN_ON_ONCE(!td_page_pa);
> 
> From the name 'td_page_pa' we cannot tell whether it is a control page, but
> this function is only intended for control page AFAICT, so perhaps a more
> specific name.
> 
> > +
> > +	/*
> > +	 * TDCX are being reclaimed.  TDX module maps TDCX with HKID
> 
> "are" -> "is".
> 
> Are you sure it is TDCX, but not TDCS?
> 
> AFAICT TDCX is the control structure for 'vcpu', but here you are handling
> the control structure for the VM.

TDCS, TDVPR, and TDCX.  Will update the comment.

> 
> > +	 * assigned to the TD.  Here the cache associated to the TD
> > +	 * was already flushed by TDH.PHYMEM.CACHE.WB before here, So
> > +	 * cache doesn't need to be flushed again.
> > +	 */
> 
> How about put this part as the comment for this function?
> 
> /*
>  * Reclaim <name of control page> page(s) which are crypto-protected
>  * by TDX guest's private KeyID.  Assume the cache associated with the
>  * TDX private KeyID has been flushed.
>  */
> > +	if (tdx_reclaim_page(td_page_pa))
> > +		/*
> > +		 * Leak the page on failure:
> > +		 * tdx_reclaim_page() returns an error if and only if there's an
> > +		 * unexpected, fatal error, e.g. a SEAMCALL with bad params,
> > +		 * incorrect concurrency in KVM, a TDX Module bug, etc.
> > +		 * Retrying at a later point is highly unlikely to be
> > +		 * successful.
> > +		 * No log here as tdx_reclaim_page() already did.
> 
> IMHO can be simplified to below, and nothing else matters.
> 
> 	/*
> 	 * Leak the page if the kernel failed to reclaim the page.
> 	 * The krenel cannot use it safely anymore.
> 	 */
> 
> And you can put this comment above the 'if (tdx_reclaim_page())' statement.

Sure.


> > +		 */
> > +		return;
> 
> Empty line.
> 
> > +	free_page((unsigned long)__va(td_page_pa));
> > +}
> > +
> > +static void tdx_do_tdh_phymem_cache_wb(void *unused)
> 
> Better to make the name explicit that it is a smp_func, and you don't need
> the "tdx_" prefix for all the 'static' functions here:
> 
> 	static void smp_func_do_phymem_cache_wb(void *unused)

Ok, will rename it.


> > +{
> > +	u64 err = 0;
> > +
> > +	do {
> > +		err = tdh_phymem_cache_wb(!!err);
> 
> 		bool resume = !!err;
> 
> 		err = tdh_phymem_cache_wb(resume);
> 
> So that we don't need to jump to the tdh_phymem_cache_wb() to see what does
> !!err mean.

Ok.


> > +	} while (err == TDX_INTERRUPTED_RESUMABLE);
> 
> Add a comment before the do {} while():
> 
> 	/*
> 	 * TDH.PHYMEM.CACHE.WB flushes caches associated with _ANY_
> 	 * TDX private KeyID on the package (or logical cpu?) where
> 	 * it is called on.  The TDX module may not finish the cache
> 	 * flush but return TDX_INTERRUPTED_RESUMEABLE instead.  The
> 	 * kernel should retry it until it returns success w/o
> 	 * rescheduling.
> 	 */

Ok.


> > +
> > +	/* Other thread may have done for us. */
> > +	if (err == TDX_NO_HKID_READY_TO_WBCACHE)
> > +		err = TDX_SUCCESS;
> 
> Empty line.
> 
> > +	if (WARN_ON_ONCE(err))
> > +		pr_tdx_error(TDH_PHYMEM_CACHE_WB, err, NULL);
> > +}
> > +
> > +void tdx_mmu_release_hkid(struct kvm *kvm)
> > +{
> > +	bool packages_allocated, targets_allocated;
> > +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> > +	cpumask_var_t packages, targets;
> > +	u64 err;
> > +	int i;
> > +
> > +	if (!is_hkid_assigned(kvm_tdx))
> > +		return;
> > +
> > +	if (!is_td_created(kvm_tdx)) {
> > +		tdx_hkid_free(kvm_tdx);
> > +		return;
> > +	}
> 
> I lost tracking what does "td_created()" mean.
> 
> I guess it means: KeyID has been allocated to the TDX guest, but not yet
> programmed/configured.
> 
> Perhaps add a comment to remind the reviewer?

As Chao suggested, will introduce state machine for vm and vcpu.

https://lore.kernel.org/kvm/ZfvI8t7SlfIsxbmT@chao-email/

> > +
> > +	packages_allocated = zalloc_cpumask_var(&packages, GFP_KERNEL);
> > +	targets_allocated = zalloc_cpumask_var(&targets, GFP_KERNEL);
> > +	cpus_read_lock();
> > +
> > +	/*
> > +	 * We can destroy multiple guest TDs simultaneously.  Prevent
> > +	 * tdh_phymem_cache_wb from returning TDX_BUSY by serialization.
> > +	 */
> 
> IMHO it's better to remind people that TDH.PHYMEM.CACHE.WB tries to grab the
> global TDX module lock:
> 
> 	/*
> 	 * TDH.PHYMEM.CACHE.WB tries to acquire the TDX module global
> 	 * lock and can fail with TDX_OPERAND_BUSY when it fails to
> 	 * grab.  Multiple TDX guests can be destroyed simultaneously.
> 	 * Take the mutex to prevent it from getting error.
> 	 */
> > +	mutex_lock(&tdx_lock);
> > +
> > +	/*
> > +	 * Go through multiple TDX HKID state transitions with three SEAMCALLs
> > +	 * to make TDH.PHYMEM.PAGE.RECLAIM() usable.
> 
> 
> What is "TDX HKID state transitions"?  Not mentioned before, so needs
> explanation _if_ you want to say this.

Ok.
> And what are the three "SEAMCALLs"?  Where are they?  The only _two_
> SEAMCALLs that I can see here are: TDH.PHYMEM.CACHE.WB and
> TDH.MNG.KEY.FREEID.

tdh_mng_vpflushdone(). I'll those three in the comment.  It may not seem
to hkid state machine, though.


> 
>  Make the transition atomic
> > +	 * to other functions to operate private pages and Secure-EPT pages.
> 
> What's the consequence to "other functions" if we don't make it atomic here?

Other thread can be removing pages from TD.  If the HKID is freed, other
thread in loop to remove pages can get error.

TDH.MEM.SEPT.REMOVE(), TDH.MEM.PAGE.REMOVE() can fail with
TDX_OP_STATE_INCORRECT when HKID is not assigned.

When HKID is freed, we need to use TDH.PHYMEM.PAGE.RECLAIM().
TDH.PHYMEM.PAGE.RECLAIM() fails with TDX_LIECYCLE_STATE_INCORRECT when
HKID isn't freed.

How about this?

/*
 * We need three SEAMCALLs, TDH.MNG.VPFLUSHDONE(), TDH.PHYMEM.CACHE.WB(), and
 * TDH.MNG.KEY.FREEID() to free the HKID.
 * Other threads can remove pages from TD.  When the HKID is assigned, we need
 * to use TDH.MEM.SEPT.REMOVE() or TDH.MEM.PAGE.REMOVE().
 * TDH.PHYMEM.PAGE.RECLAIM() is needed when the HKID is free.  Get lock to not
 * present transient state of HKID.
 */


> > +	 *
> > +	 * Avoid race for kvm_gmem_release() to call kvm_mmu_unmap_gfn_range().
> > +	 * This function is called via mmu notifier, mmu_release().
> > +	 * kvm_gmem_release() is called via fput() on process exit.
> > +	 */
> > +	write_lock(&kvm->mmu_lock);
> 
> I don't fully get the race here, but it seems strange that this function is
> called via mmu notifier.
> 
> IIUC, this function is "supposedly" only be called when we tear down the VM,

That's correct.  The hook when destroying the VM is mmu notifier mmu_release().
It's called on the behalf of mmput().  Because other component like vhost-net
can increment the reference, mmu_release mmu notifier can be triggered by
a thread other than the guest VM.


> so I don't know why there's such race.

When guest_memfd is released, the private memory is unmapped.  
the thread of guest VM can issue exit to closes guest_memfd and
other thread can trigger mmu notifier of the guest VM.

Also, if we have multiple fds for the same guest_memfd, the last file closure
can be done in the context of the guest VM or other process.


> > +
> > +	for_each_online_cpu(i) {
> > +		if (packages_allocated &&
> > +		    cpumask_test_and_set_cpu(topology_physical_package_id(i),
> > +					     packages))
> > +			continue;
> > +		if (targets_allocated)
> > +			cpumask_set_cpu(i, targets);
> > +	}
> > +	if (targets_allocated)
> > +		on_each_cpu_mask(targets, tdx_do_tdh_phymem_cache_wb, NULL, true);
> > +	else
> > +		on_each_cpu(tdx_do_tdh_phymem_cache_wb, NULL, true);
> 
> I don't understand the logic here -- no comments whatever.
> 
> But I am 99% sure the logic here could be simplified.

Yes, as Chao suggested, I'll use global variable for those cpumasks.
https://lore.kernel.org/kvm/ZfpwIespKy8qxWWE@chao-email/


> > +	/*
> > +	 * In the case of error in tdx_do_tdh_phymem_cache_wb(), the following
> > +	 * tdh_mng_key_freeid() will fail.
> > +	 */
> > +	err = tdh_mng_key_freeid(kvm_tdx->tdr_pa);
> > +	if (WARN_ON_ONCE(err)) {
> 
> I see KVM_BUG_ON() is normally used for SEAMCALL error.  Why this uses
> WARN_ON_ONCE() here?

Because vm_free() hook is (one of) the final steps to free struct kvm.  No one
else touches this kvm.  Because it doesn't harm to use KVM_BUG_ON() here,
I'll change it for consistency.


> > +		pr_tdx_error(TDH_MNG_KEY_FREEID, err, NULL);
> > +		pr_err("tdh_mng_key_freeid() failed. HKID %d is leaked.\n",
> > +		       kvm_tdx->hkid);
> > +	} else
> > +		tdx_hkid_free(kvm_tdx);
> > +
> > +	write_unlock(&kvm->mmu_lock);
> > +	mutex_unlock(&tdx_lock);
> > +	cpus_read_unlock();
> > +	free_cpumask_var(targets);
> > +	free_cpumask_var(packages);
> > +}
> > +
> > +void tdx_vm_free(struct kvm *kvm)
> > +{
> > +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> > +	u64 err;
> > +	int i;
> > +
> > +	/*
> > +	 * tdx_mmu_release_hkid() failed to reclaim HKID.  Something went wrong
> > +	 * heavily with TDX module.  Give up freeing TD pages.  As the function
> > +	 * already warned, don't warn it again.
> > +	 */
> > +	if (is_hkid_assigned(kvm_tdx))
> > +		return;
> > +
> > +	if (kvm_tdx->tdcs_pa) {
> > +		for (i = 0; i < tdx_info->nr_tdcs_pages; i++) {
> > +			if (kvm_tdx->tdcs_pa[i])
> > +				tdx_reclaim_control_page(kvm_tdx->tdcs_pa[i]);
> 
> AFAICT, here tdcs_pa[i] cannot be NULL, right?  How about:

If tdh_mng_addcx() fails in the middle of 0 < i < nr_tdcs_pages, tdcs_pa[i] can
be NULL.  The current allocation/free code is unnecessarily convoluted. I'll
clean them up.


> 			if (!WARN_ON_ONCE(!kvm_tdx->tdcs_pa[i]))
> 				continue;
> 			
> 			tdx_reclaim_control_page(...);
> 
> which at least saves you some indent.
> 
> Btw, does it make sense to stop if any tdx_reclaim_control_page() fails?

It doesn't matter much in practice because it's unlikely to hit error for some
of TDCS pages.  So I chose to make it return void to skip error check by the
caller.


> It's OK to continue, but perhaps worth to add a comment to point out:
> 
> 			/*
> 			 * Continue to reclaim other control pages and
> 			 * TDR page, even failed to reclaim one control
> 			 * page.  Do the best to reclaim these TDX
> 			 * private pages.
> 			 */
> 			tdx_reclaim_control_page();

Sure, it will make the intention clear.


> > +		}
> > +		kfree(kvm_tdx->tdcs_pa);
> > +		kvm_tdx->tdcs_pa = NULL;
> > +	}
> > +
> > +	if (!kvm_tdx->tdr_pa)
> > +		return;
> > +	if (__tdx_reclaim_page(kvm_tdx->tdr_pa))
> > +		return;
> > +	/*
> > +	 * TDX module maps TDR with TDX global HKID.  TDX module may access TDR
> > +	 * while operating on TD (Especially reclaiming TDCS).  Cache flush with > +	 * TDX global HKID is needed.
> > +	 */
> 
> "Especially reclaiming TDCS" -> "especially when it is reclaiming TDCS".
> 
> Use imperative mode to describe your change:
> 
> Use the SEAMCALL to ask the TDX module to flush the cache of it using the
> global KeyID.
> 
> > +	err = tdh_phymem_page_wbinvd(set_hkid_to_hpa(kvm_tdx->tdr_pa,
> > +						     tdx_global_keyid));
> > +	if (WARN_ON_ONCE(err)) {
> 
> Again, KVM_BUG_ON()?
> 
> Should't matter, though.

Ok, let's use KVM_BUG_ON() consistently.



> > +		pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err, NULL);
> > +		return;
> > +	}
> > +	tdx_clear_page(kvm_tdx->tdr_pa);
> > +
> > +	free_page((unsigned long)__va(kvm_tdx->tdr_pa));
> > +	kvm_tdx->tdr_pa = 0;
> > +}
> > +
> > +static int tdx_do_tdh_mng_key_config(void *param)
> > +{
> > +	hpa_t *tdr_p = param;
> > +	u64 err;
> > +
> > +	do {
> > +		err = tdh_mng_key_config(*tdr_p);
> > +
> > +		/*
> > +		 * If it failed to generate a random key, retry it because this
> > +		 * is typically caused by an entropy error of the CPU's random
> > +		 * number generator.
> > +		 */
> > +	} while (err == TDX_KEY_GENERATION_FAILED);
> 
> If you want to handle TDX_KEY_GENERTION_FAILED, it's better to have a retry
> limit similar to the TDX host code does.

Ok, although it would complicates the error recovery path, let me update it.


> > +
> > +	if (WARN_ON_ONCE(err)) {
> 
> KVM_BUG_ON()?
> 
> > +		pr_tdx_error(TDH_MNG_KEY_CONFIG, err, NULL);
> > +		return -EIO;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int __tdx_td_init(struct kvm *kvm);
> > +
> > +int tdx_vm_init(struct kvm *kvm)
> > +{
> > +	/*
> > +	 * TDX has its own limit of the number of vcpus in addition to
> > +	 * KVM_MAX_VCPUS.
> > +	 */
> > +	kvm->max_vcpus = min(kvm->max_vcpus, TDX_MAX_VCPUS);
> 
> I believe this should be part of the patch that handles KVM_CAP_MAX_VCPUS.

Ok.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

