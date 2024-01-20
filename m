Return-Path: <kvm+bounces-6477-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EFC6A833534
	for <lists+kvm@lfdr.de>; Sat, 20 Jan 2024 16:20:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EFEED1C21074
	for <lists+kvm@lfdr.de>; Sat, 20 Jan 2024 15:20:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45EDA10940;
	Sat, 20 Jan 2024 15:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g+R9ng5Y"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D47B7FC10;
	Sat, 20 Jan 2024 15:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705764006; cv=none; b=lK2O3qFWUAzWCu7n4P2r6Fd631LOgJKnKEM/ORbzsT2CYENxoiiCrI6DiL8LSIKqzGZlC6HsTarcIBikBcUAijMGn76Qys+2plr4C3T3mm84IqJcrIqURi4TzIJfuFW7O5tx9B1FWtZdNZsS1Hk5tLcR/QFU0SgUGNSlSBR0CwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705764006; c=relaxed/simple;
	bh=2x7L2nPWKcD/ke7shQz1wJugb8Cya+iMq5jXQicfUGk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qxTf4DcGxSoEPouespTuXzyWPVbjkEL/l1hRFF/ZCyVZC1GfSNM+HC1rrYGMaLh8G2t1bGCH++x7oCi4AatYbecftgi6Xccfq6xmnfuC1Zt2CISlhwU2KXGPipDzaNmKT3Cxhd7MbIuAH/sKPB3uLSRUlseLQp8WZ2oVlWN937M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g+R9ng5Y; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705764006; x=1737300006;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=2x7L2nPWKcD/ke7shQz1wJugb8Cya+iMq5jXQicfUGk=;
  b=g+R9ng5Yav/TvLCF5Lmc6udv+jytq+CREOXiQX/RUMjtJlEBfLzy3/9d
   7n/coNIcafioXo4WaC4sWPR5/lChE8ZDh9QSdGdrtoxeBfDChCICv7NWL
   7f+jSNNcWHAkk1QBxDC1f+PM5YWl3HaqThpGV0SuX2MyO4xiVOiu9z/ZF
   +Iqnbi4jprLULa+FTP6J4/aM3rgEy0trbmszdXvFlixysCiUEj5vQgh2u
   yF5ywEgm4jSKoURRUpfHkrkMsWqz1d9q0uQV8aO/WlVAbLlXIa81k9NJ/
   lJA5l0yynC3JyrbL9FOxoL+vNF5MuvYmDcq5CQyJSdKF+zN8p33iovh3C
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10959"; a="19521797"
X-IronPort-AV: E=Sophos;i="6.05,208,1701158400"; 
   d="scan'208";a="19521797"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2024 07:20:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10959"; a="1116484887"
X-IronPort-AV: E=Sophos;i="6.05,208,1701158400"; 
   d="scan'208";a="1116484887"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmsmga005.fm.intel.com with ESMTP; 20 Jan 2024 07:20:02 -0800
Date: Sat, 20 Jan 2024 23:16:49 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>
Subject: Re: [PATCH 3/4] KVM: Get reference to VM's address space in the
 async #PF worker
Message-ID: <Zavj4U2LYeOsnXOh@yilunxu-OptiPlex-7050>
References: <20240110011533.503302-1-seanjc@google.com>
 <20240110011533.503302-4-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240110011533.503302-4-seanjc@google.com>

On Tue, Jan 09, 2024 at 05:15:32PM -0800, Sean Christopherson wrote:
> Get a reference to the target VM's address space in async_pf_execute()
> instead of gifting a reference from kvm_setup_async_pf().  Keeping the
> address space alive just to service an async #PF is counter-productive,
> i.e. if the process is exiting and all vCPUs are dead, then NOT doing
> get_user_pages_remote() and freeing the address space asap is desirable.
> 
> Handling the mm reference entirely within async_pf_execute() also
> simplifies the async #PF flows as a whole, e.g. it's not immediately
> obvious when the worker task vs. the vCPU task is responsible for putting
> the gifted mm reference.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  include/linux/kvm_host.h |  1 -
>  virt/kvm/async_pf.c      | 32 ++++++++++++++++++--------------
>  2 files changed, 18 insertions(+), 15 deletions(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 7e7fd25b09b3..bbfefd7e612f 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -238,7 +238,6 @@ struct kvm_async_pf {
>  	struct list_head link;
>  	struct list_head queue;
>  	struct kvm_vcpu *vcpu;
> -	struct mm_struct *mm;
>  	gpa_t cr2_or_gpa;
>  	unsigned long addr;
>  	struct kvm_arch_async_pf arch;
> diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
> index d5dc50318aa6..c3f4f351a2ae 100644
> --- a/virt/kvm/async_pf.c
> +++ b/virt/kvm/async_pf.c
> @@ -46,8 +46,8 @@ static void async_pf_execute(struct work_struct *work)
>  {
>  	struct kvm_async_pf *apf =
>  		container_of(work, struct kvm_async_pf, work);
> -	struct mm_struct *mm = apf->mm;
>  	struct kvm_vcpu *vcpu = apf->vcpu;
> +	struct mm_struct *mm = vcpu->kvm->mm;
>  	unsigned long addr = apf->addr;
>  	gpa_t cr2_or_gpa = apf->cr2_or_gpa;
>  	int locked = 1;
> @@ -56,16 +56,24 @@ static void async_pf_execute(struct work_struct *work)
>  	might_sleep();
>  
>  	/*
> -	 * This work is run asynchronously to the task which owns
> -	 * mm and might be done in another context, so we must
> -	 * access remotely.
> +	 * Attempt to pin the VM's host address space, and simply skip gup() if
> +	 * acquiring a pin fail, i.e. if the process is exiting.  Note, KVM
> +	 * holds a reference to its associated mm_struct until the very end of
> +	 * kvm_destroy_vm(), i.e. the struct itself won't be freed before this
> +	 * work item is fully processed.
>  	 */
> -	mmap_read_lock(mm);
> -	get_user_pages_remote(mm, addr, 1, FOLL_WRITE, NULL, &locked);
> -	if (locked)
> -		mmap_read_unlock(mm);
> -	mmput(mm);
> +	if (mmget_not_zero(mm)) {
> +		mmap_read_lock(mm);
> +		get_user_pages_remote(mm, addr, 1, FOLL_WRITE, NULL, &locked);
> +		if (locked)
> +			mmap_read_unlock(mm);
> +		mmput(mm);
> +	}
>  
> +	/*
> +	 * Notify and kick the vCPU even if faulting in the page failed, e.g.

How about when the process is exiting? Could we just skip the following?

Thanks,
Yilun

> +	 * so that the vCPU can retry the fault synchronously.
> +	 */
>  	if (IS_ENABLED(CONFIG_KVM_ASYNC_PF_SYNC))
>  		kvm_arch_async_page_present(vcpu, apf);
>  
> @@ -129,10 +137,8 @@ void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu)
>  #ifdef CONFIG_KVM_ASYNC_PF_SYNC
>  		flush_work(&work->work);
>  #else
> -		if (cancel_work_sync(&work->work)) {
> -			mmput(work->mm);
> +		if (cancel_work_sync(&work->work))
>  			kmem_cache_free(async_pf_cache, work);
> -		}
>  #endif
>  		spin_lock(&vcpu->async_pf.lock);
>  	}
> @@ -211,8 +217,6 @@ bool kvm_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  	work->cr2_or_gpa = cr2_or_gpa;
>  	work->addr = hva;
>  	work->arch = *arch;
> -	work->mm = current->mm;
> -	mmget(work->mm);
>  
>  	INIT_WORK(&work->work, async_pf_execute);
>  
> -- 
> 2.43.0.472.g3155946c3a-goog
> 

