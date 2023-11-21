Return-Path: <kvm+bounces-2172-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E04147F2B3F
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 12:01:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1D7001C217F4
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 11:01:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FF5B482D8;
	Tue, 21 Nov 2023 11:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZFoI5/zT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 854F610F9;
	Tue, 21 Nov 2023 03:00:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700564447; x=1732100447;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=NcRwqwQTwQ6onun3MTTPMLU8sOfAkpxdSQyc+TxerF0=;
  b=ZFoI5/zTlJWERs04X0S9hDE0/8EAzzUIV0jN9FOXzp71pI9DPIwvGwtN
   evK/mjVNjVArwvWskLhtPDuGLOu542EcBJfbPgLaOuuy2bmUtULy78cJX
   BOOxc99KLqMbhAud5DR1hCkn6XDUqMECxdofADMpnHuHvtFeCmX/u/lCy
   woxGYpDzstAszbgWEvXfLhqEpN2m1arLXyMT/SaJa4jRwRVfoR0nbkpj6
   RjTQWQ/v8wcs7iml42+1lCRg2oImLlhoZG61kiWYwXDMd3oGrnWEUDrM5
   Q+KixSdTb9nWm+CGDIwbapwJ5mwGE/TTz27tEk7237EuN+DyhciEEVVRx
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10900"; a="382209974"
X-IronPort-AV: E=Sophos;i="6.04,215,1695711600"; 
   d="scan'208";a="382209974"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2023 03:00:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10900"; a="766607182"
X-IronPort-AV: E=Sophos;i="6.04,215,1695711600"; 
   d="scan'208";a="766607182"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2023 03:00:46 -0800
Date: Tue, 21 Nov 2023 03:00:45 -0800
From: Isaku Yamahata <isaku.yamahata@linux.intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, David Matlack <dmatlack@google.com>,
	Kai Huang <kai.huang@intel.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
	hang.yuan@intel.com, tina.zhang@intel.com,
	Xiaoyao Li <xiaoyao.li@intel.com>, isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v6 11/16] KVM: x86/tdp_mmu: Split the large page when zap
 leaf
Message-ID: <20231121110045.GH1109547@ls.amr.corp.intel.com>
References: <cover.1699368363.git.isaku.yamahata@intel.com>
 <8b43a9203c34b5330c4ea5901da5dac3458ac98d.1699368363.git.isaku.yamahata@intel.com>
 <5d9aadbd-975b-4c4d-ba18-ac6e0fb07ba1@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5d9aadbd-975b-4c4d-ba18-ac6e0fb07ba1@linux.intel.com>

On Tue, Nov 21, 2023 at 05:57:28PM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index 7873e9ee82ad..a209a67decae 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -964,6 +964,14 @@ bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
> >   	return true;
> >   }
> > +
> > +static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
> > +						       struct tdp_iter *iter,
> > +						       bool shared);
> > +
> > +static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
> > +				   struct kvm_mmu_page *sp, bool shared);
> > +
> >   /*
> >    * If can_yield is true, will release the MMU lock and reschedule if the
> >    * scheduler needs the CPU or there is contention on the MMU lock. If this
> > @@ -975,13 +983,15 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
> >   			      gfn_t start, gfn_t end, bool can_yield, bool flush,
> >   			      bool zap_private)
> >   {
> > +	bool is_private = is_private_sp(root);
> > +	struct kvm_mmu_page *split_sp = NULL;
> >   	struct tdp_iter iter;
> >   	end = min(end, tdp_mmu_max_gfn_exclusive());
> >   	lockdep_assert_held_write(&kvm->mmu_lock);
> > -	WARN_ON_ONCE(zap_private && !is_private_sp(root));
> > +	WARN_ON_ONCE(zap_private && !is_private);
> >   	if (!zap_private && is_private_sp(root))
> Can use is_private instead of is_private_sp(root) here as well.

I'll update it.

> 
> >   		return false;
> > @@ -1006,12 +1016,66 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
> >   		    !is_last_spte(iter.old_spte, iter.level))
> >   			continue;
> > +		if (is_private && kvm_gfn_shared_mask(kvm) &&
> > +		    is_large_pte(iter.old_spte)) {
> > +			gfn_t gfn = iter.gfn & ~kvm_gfn_shared_mask(kvm);
> > +			gfn_t mask = KVM_PAGES_PER_HPAGE(iter.level) - 1;
> > +			struct kvm_memory_slot *slot;
> > +			struct kvm_mmu_page *sp;
> > +
> > +			slot = gfn_to_memslot(kvm, gfn);
> > +			if (kvm_hugepage_test_mixed(slot, gfn, iter.level) ||
> > +			    (gfn & mask) < start ||
> > +			    end < (gfn & mask) + KVM_PAGES_PER_HPAGE(iter.level)) {
> > +				WARN_ON_ONCE(!can_yield);
> > +				if (split_sp) {
> > +					sp = split_sp;
> > +					split_sp = NULL;
> > +					sp->role = tdp_iter_child_role(&iter);
> > +				} else {
> > +					WARN_ON(iter.yielded);
> > +					if (flush && can_yield) {
> > +						kvm_flush_remote_tlbs(kvm);
> > +						flush = false;
> > +					}
> Is it necessary to do the flush here?

Because tdp_mmu_alloc_sp_for_split() may unlock mmu_lock and block.
While blocking, other thread operates on KVM MMU and gets confused due to
remaining TLB cache.


> > +					sp = tdp_mmu_alloc_sp_for_split(kvm, &iter, false);
> > +					if (iter.yielded) {
> > +						split_sp = sp;
> > +						continue;
> > +					}
> > +				}
> > +				KVM_BUG_ON(!sp, kvm);
> > +
> > +				tdp_mmu_init_sp(sp, iter.sptep, iter.gfn);
> > +				if (tdp_mmu_split_huge_page(kvm, &iter, sp, false)) {
> > +					kvm_flush_remote_tlbs(kvm);
> > +					flush = false;
> Why it needs to flush TLB immediately if tdp_mmu_split_huge_page() fails?

Hmm, we don't need it.  When breaking up page table, we need to tlb flush
before issuing TDH.MEM.PAGE.DEMOTE(), not after it.  Will remove those two lines.


> Also, when KVM MMU write lock is held, it seems tdp_mmu_split_huge_page()
> will not fail.

This can happen with TDX_OPERAND_BUSY with secure-ept tree lock with other
vcpus TDH.VP.ENTER(). TDH.VP.ENTER() can take exclusive lock of secure-EPT.


> But let's assume this condition can be triggered, since sp is
> local
> variable, it will lost its value after continue, and split_sp is also NULL,
> it will try to allocate a new sp, memory leakage here?

Nice catch. I'll add split_sp = sp;


> > +					/* force retry on this gfn. */
> > +					iter.yielded = true;
> > +				} else
> > +					flush = true;
> > +				continue;
> > +			}
> > +		}
> > +
> >   		tdp_mmu_iter_set_spte(kvm, &iter, SHADOW_NONPRESENT_VALUE);
> >   		flush = true;
> >   	}
> >   	rcu_read_unlock();
> > +	if (split_sp) {
> > +		WARN_ON(!can_yield);
> > +		if (flush) {
> > +			kvm_flush_remote_tlbs(kvm);
> > +			flush = false;
> > +		}
> Same here, why we need to do the flush here?
> Can we delay it till the caller do the flush?

No. Because we unlock mmu_lock and may block when freeing memory.


> > +
> > +		write_unlock(&kvm->mmu_lock);
> > +		tdp_mmu_free_sp(split_sp);
> > +		write_lock(&kvm->mmu_lock);
> > +	}
> > +
> >   	/*
> >   	 * Because this flow zaps _only_ leaf SPTEs, the caller doesn't need
> >   	 * to provide RCU protection as no 'struct kvm_mmu_page' will be freed.
> > @@ -1606,8 +1670,6 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
> >   	KVM_BUG_ON(kvm_mmu_page_role_is_private(role) !=
> >   		   is_private_sptep(iter->sptep), kvm);
> > -	/* TODO: Large page isn't supported for private SPTE yet. */
> > -	KVM_BUG_ON(kvm_mmu_page_role_is_private(role), kvm);
> >   	/*
> >   	 * Since we are allocating while under the MMU lock we have to be
> 
> 

-- 
Isaku Yamahata <isaku.yamahata@linux.intel.com>

