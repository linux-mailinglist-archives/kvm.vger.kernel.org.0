Return-Path: <kvm+bounces-14581-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E9478A3802
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 23:42:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2C8F71F23069
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 21:42:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 240E015217F;
	Fri, 12 Apr 2024 21:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nUM/Veb+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58C2F152194;
	Fri, 12 Apr 2024 21:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712958125; cv=none; b=MeF9WhpGGcVlPKIpAK4Bj/tPxXjRl0q51DEg5c9qu34rc70tgcW98wuc/EWAB7jpIkNbDIVAyHQDJ7/z4hlSFcSLvY4TKPh8FtnWpO6sU7A0tEjIuhOLp/Y9GpAeO8Fghaap81W+RJUeutSQ4jJMNTOBLyGkgrYQ4jkIonM5aZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712958125; c=relaxed/simple;
	bh=bGqbk8oXj2YBcOYqJ0LoT0L+D2Z9mSgHKxhntmajOZI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e/kL58itpRFEltPk364G3irD4y7G3kx8ErH1Xv9N1oaPQcCZmTYuGcdEnsD7zC2QOUm9mHK6EUA5DKjZDViAKUflpRM9vUMfDm+zaf7b9+Cs77U+r+pTuC+jYqu8TytGHvdo2YyXEQp7gWBldBfI4fUAk2BY60rCfXfG4X1/YTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nUM/Veb+; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712958123; x=1744494123;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=bGqbk8oXj2YBcOYqJ0LoT0L+D2Z9mSgHKxhntmajOZI=;
  b=nUM/Veb+NmrLhsrFrsb1pU9Gpom2cLKqxa/QO9dnmv8WtXUE0mLnPA9H
   SRRoYwrtYoLs2YETcwxVFEW5is493kWXABl3fXKhaVQ8XnLkrNNGjmZaQ
   Rl4g4be2Vc8jHIBINhTxW5bDxZd74UfAY25PMgkiprV1fI1IqKCXbNeQB
   8XolF198D/za7skg0aeoB8Vu8iAaZDAcUpgfCv9d8GLpx/G2B8BQdNsXI
   ccl1Xj+ZFBMYOzEP7ojxB2AhXPC+dcRo5GTmoWHpmL4BJ8xxoA4j3/m9P
   8z/rh2W9Ucb5RiXAH8MBbRVQB3i+PHtWF3jwP9Tq9jg/R4ogBNV+r5iD6
   w==;
X-CSE-ConnectionGUID: 5HkuhNT2TD22eFWA1akflg==
X-CSE-MsgGUID: mSIkSJZeTY6Nc2r76OL0tQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11042"; a="8348552"
X-IronPort-AV: E=Sophos;i="6.07,197,1708416000"; 
   d="scan'208";a="8348552"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 14:42:03 -0700
X-CSE-ConnectionGUID: covSbDg1TE27VIdgsSf/Yg==
X-CSE-MsgGUID: EWoHZGmHSVqBNg7MUhU1+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,197,1708416000"; 
   d="scan'208";a="25775438"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 14:42:02 -0700
Date: Fri, 12 Apr 2024 14:42:01 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 087/130] KVM: TDX: handle vcpu migration over logical
 processor
Message-ID: <20240412214201.GO3039520@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <b9fe57ceeaabe650f0aecb21db56ef2b1456dcfe.1708933498.git.isaku.yamahata@intel.com>
 <0c3efffa-8dd5-4231-8e90-e0241f058a20@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <0c3efffa-8dd5-4231-8e90-e0241f058a20@intel.com>

On Fri, Apr 12, 2024 at 09:15:29AM -0700,
Reinette Chatre <reinette.chatre@intel.com> wrote:

> Hi Isaku,
> 
> On 2/26/2024 12:26 AM, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> ...
> 
> > @@ -218,6 +257,87 @@ static void tdx_reclaim_control_page(unsigned long td_page_pa)
> >  	free_page((unsigned long)__va(td_page_pa));
> >  }
> >  
> > +struct tdx_flush_vp_arg {
> > +	struct kvm_vcpu *vcpu;
> > +	u64 err;
> > +};
> > +
> > +static void tdx_flush_vp(void *arg_)
> > +{
> > +	struct tdx_flush_vp_arg *arg = arg_;
> > +	struct kvm_vcpu *vcpu = arg->vcpu;
> > +	u64 err;
> > +
> > +	arg->err = 0;
> > +	lockdep_assert_irqs_disabled();
> > +
> > +	/* Task migration can race with CPU offlining. */
> > +	if (unlikely(vcpu->cpu != raw_smp_processor_id()))
> > +		return;
> > +
> > +	/*
> > +	 * No need to do TDH_VP_FLUSH if the vCPU hasn't been initialized.  The
> > +	 * list tracking still needs to be updated so that it's correct if/when
> > +	 * the vCPU does get initialized.
> > +	 */
> > +	if (is_td_vcpu_created(to_tdx(vcpu))) {
> > +		/*
> > +		 * No need to retry.  TDX Resources needed for TDH.VP.FLUSH are,
> > +		 * TDVPR as exclusive, TDR as shared, and TDCS as shared.  This
> > +		 * vp flush function is called when destructing vcpu/TD or vcpu
> > +		 * migration.  No other thread uses TDVPR in those cases.
> > +		 */
> 
> (I have comment later that refer back to this comment about needing retry.)
> 
> ...
> 
> > @@ -233,26 +353,31 @@ static void tdx_do_tdh_phymem_cache_wb(void *unused)
> >  		pr_tdx_error(TDH_PHYMEM_CACHE_WB, err, NULL);
> >  }
> >  
> > -void tdx_mmu_release_hkid(struct kvm *kvm)
> > +static int __tdx_mmu_release_hkid(struct kvm *kvm)
> >  {
> >  	bool packages_allocated, targets_allocated;
> >  	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> >  	cpumask_var_t packages, targets;
> > +	struct kvm_vcpu *vcpu;
> > +	unsigned long j;
> > +	int i, ret = 0;
> >  	u64 err;
> > -	int i;
> >  
> >  	if (!is_hkid_assigned(kvm_tdx))
> > -		return;
> > +		return 0;
> >  
> >  	if (!is_td_created(kvm_tdx)) {
> >  		tdx_hkid_free(kvm_tdx);
> > -		return;
> > +		return 0;
> >  	}
> >  
> >  	packages_allocated = zalloc_cpumask_var(&packages, GFP_KERNEL);
> >  	targets_allocated = zalloc_cpumask_var(&targets, GFP_KERNEL);
> >  	cpus_read_lock();
> >  
> > +	kvm_for_each_vcpu(j, vcpu, kvm)
> > +		tdx_flush_vp_on_cpu(vcpu);
> > +
> >  	/*
> >  	 * We can destroy multiple guest TDs simultaneously.  Prevent
> >  	 * tdh_phymem_cache_wb from returning TDX_BUSY by serialization.
> > @@ -270,6 +395,19 @@ void tdx_mmu_release_hkid(struct kvm *kvm)
> >  	 */
> >  	write_lock(&kvm->mmu_lock);
> >  
> > +	err = tdh_mng_vpflushdone(kvm_tdx->tdr_pa);
> > +	if (err == TDX_FLUSHVP_NOT_DONE) {
> > +		ret = -EBUSY;
> > +		goto out;
> > +	}
> > +	if (WARN_ON_ONCE(err)) {
> > +		pr_tdx_error(TDH_MNG_VPFLUSHDONE, err, NULL);
> > +		pr_err("tdh_mng_vpflushdone() failed. HKID %d is leaked.\n",
> > +		       kvm_tdx->hkid);
> > +		ret = -EIO;
> > +		goto out;
> > +	}
> > +
> >  	for_each_online_cpu(i) {
> >  		if (packages_allocated &&
> >  		    cpumask_test_and_set_cpu(topology_physical_package_id(i),
> > @@ -291,14 +429,24 @@ void tdx_mmu_release_hkid(struct kvm *kvm)
> >  		pr_tdx_error(TDH_MNG_KEY_FREEID, err, NULL);
> >  		pr_err("tdh_mng_key_freeid() failed. HKID %d is leaked.\n",
> >  		       kvm_tdx->hkid);
> > +		ret = -EIO;
> >  	} else
> >  		tdx_hkid_free(kvm_tdx);
> >  
> > +out:
> >  	write_unlock(&kvm->mmu_lock);
> >  	mutex_unlock(&tdx_lock);
> >  	cpus_read_unlock();
> >  	free_cpumask_var(targets);
> >  	free_cpumask_var(packages);
> > +
> > +	return ret;
> > +}
> > +
> > +void tdx_mmu_release_hkid(struct kvm *kvm)
> > +{
> > +	while (__tdx_mmu_release_hkid(kvm) == -EBUSY)
> > +		;
> >  }
> 
> As I understand, __tdx_mmu_release_hkid() returns -EBUSY
> after TDH.VP.FLUSH has been sent for every vCPU followed by
> TDH.MNG.VPFLUSHDONE, which returns TDX_FLUSHVP_NOT_DONE.
> 
> Considering earlier comment that a retry of TDH.VP.FLUSH is not
> needed, why is this while() loop here that sends the
> TDH.VP.FLUSH again to all vCPUs instead of just a loop within
> __tdx_mmu_release_hkid() to _just_ resend TDH.MNG.VPFLUSHDONE?
> 
> Could it be possible for a vCPU to appear during this time, thus
> be missed in one TDH.VP.FLUSH cycle, to require a new cycle of
> TDH.VP.FLUSH?

Yes. There is a race between closing KVM vCPU fd and MMU notifier release hook.
When KVM vCPU fd is closed, vCPU context can be loaded again.  The MMU notifier
release hook eventually calls tdx_mmu_release_hkid().  Other kernel thread
(concretely, vhost krenel thread) can get reference count to mmu and put it by
timer, the MMU notifier release hook can be triggered during closing vCPU fd.

The possible alternative is to make the vCPU closing path complicated not to
load vCPU context instead f sending IPI on every retry.


> I note that TDX_FLUSHVP_NOT_DONE is distinct from TDX_OPERAND_BUSY
> that can also be returned from TDH.MNG.VPFLUSHDONE and
> wonder if a retry may be needed in that case also/instead? It looks like
> TDH.MNG.VPFLUSHDONE needs exclusive access to all operands and I
> do not know enough yet if this is the case here.

Because we're destructing the guest and gain mmu_lock, we shouldn't have other
thread racing.  Probably we can simply retry on TDX_OPERAND_BUSY without
worrying race.  It would be more robust and easier to understand.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

