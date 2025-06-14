Return-Path: <kvm+bounces-49558-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D9A83AD9CB3
	for <lists+kvm@lfdr.de>; Sat, 14 Jun 2025 14:29:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C051D3BAA44
	for <lists+kvm@lfdr.de>; Sat, 14 Jun 2025 12:29:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E1CC2C3263;
	Sat, 14 Jun 2025 12:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Uq16Z+/L"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D01E2741AD;
	Sat, 14 Jun 2025 12:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749904189; cv=none; b=WX1PrHNsKL4g1X0q5/WmAyAarQisUm/gGUBxMp9Y93zJ8tL64BNCY7Ujr6MRC7l/hB8ZbVtrZsClzDiQ71YZ8+7BFHjWaJhD+Bzc+Ipybrxbl0f8X99YWsthtJECueUHnmO4aHGH0Y+ftMTlYKH7T5BBQPGI+U7PLlh/VQRRFKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749904189; c=relaxed/simple;
	bh=Wfcj9Z0uZC+J1XfReVkQBWAOdiJOlKthbX24fnDHccY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZPChatGPlCVM827nfKRpplkfDl+dRo1Nu1XSHt3e0u0y+s5n9P4ydEk+N+kKU+lfKyljuMl3FZMVC8d2vqzm9UcwRrhuRG94sfotQM4abfjZwJsl+YTSqnB8z1k3IdmVskV5g+QGYdFPMG2xRuwtAloub3cjBh2yQkRovtgNEFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Uq16Z+/L; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749904187; x=1781440187;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Wfcj9Z0uZC+J1XfReVkQBWAOdiJOlKthbX24fnDHccY=;
  b=Uq16Z+/LqCrWXL4i5spmeS3IhNYwnuvZSsQyaNET8DDifLh7dGm6C8pv
   xwEksJIs7AJzIsBruNY9hi9ctLRfB1fnEDVDZhPbuT6ETnGMIFajI8mX2
   G2otIRU1RsRqeJj/3lEALAtFPLsRgAv/j6PMSYFzvD9auE9REIivzErHz
   HqWEIyNwPWRDc0Qz3i5ZvEYPD3eUKGhluJzvLFiK1GhGj5TWZ/pvAESGc
   etm5U0ljZ9xwbqRtBudqPAKwndFfFHHlfuY5baJ5OgaoMwKTcDyrgQCcQ
   G9RMDB0JWpcSYMviDl31rqzq/SFANVWD3zBg72XXAmCooT2xHROIKuJno
   A==;
X-CSE-ConnectionGUID: IxM9ckuATp2igKjq2z3BDA==
X-CSE-MsgGUID: pncXVvAnR26NkpoH77feyA==
X-IronPort-AV: E=McAfee;i="6800,10657,11464"; a="63460139"
X-IronPort-AV: E=Sophos;i="6.16,236,1744095600"; 
   d="scan'208";a="63460139"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2025 05:29:47 -0700
X-CSE-ConnectionGUID: eRUp2Z2+TQeA5wES6VPyZw==
X-CSE-MsgGUID: ysyuDi1DR/WRKncs7Q0YCA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,236,1744095600"; 
   d="scan'208";a="147943808"
Received: from lkp-server01.sh.intel.com (HELO e8142ee1dce2) ([10.239.97.150])
  by fmviesa007.fm.intel.com with ESMTP; 14 Jun 2025 05:29:44 -0700
Received: from kbuild by e8142ee1dce2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uQQ10-000DVO-19;
	Sat, 14 Jun 2025 12:29:42 +0000
Date: Sat, 14 Jun 2025 20:28:42 +0800
From: kernel test robot <lkp@intel.com>
To: James Houghton <jthoughton@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: oe-kbuild-all@lists.linux.dev, Vipin Sharma <vipinsh@google.com>,
	David Matlack <dmatlack@google.com>,
	James Houghton <jthoughton@google.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/7] KVM: x86/mmu: Track TDP MMU NX huge pages
 separately
Message-ID: <202506142050.kfDUdARX-lkp@intel.com>
References: <20250613202315.2790592-2-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250613202315.2790592-2-jthoughton@google.com>

Hi James,

kernel test robot noticed the following build errors:

[auto build test ERROR on 8046d29dde17002523f94d3e6e0ebe486ce52166]

url:    https://github.com/intel-lab-lkp/linux/commits/James-Houghton/KVM-x86-mmu-Track-TDP-MMU-NX-huge-pages-separately/20250614-042620
base:   8046d29dde17002523f94d3e6e0ebe486ce52166
patch link:    https://lore.kernel.org/r/20250613202315.2790592-2-jthoughton%40google.com
patch subject: [PATCH v4 1/7] KVM: x86/mmu: Track TDP MMU NX huge pages separately
config: i386-randconfig-003-20250614 (https://download.01.org/0day-ci/archive/20250614/202506142050.kfDUdARX-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250614/202506142050.kfDUdARX-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202506142050.kfDUdARX-lkp@intel.com/

All errors (new ones prefixed by >>):

   arch/x86/kvm/mmu/mmu.c: In function 'kvm_recover_nx_huge_pages':
>> arch/x86/kvm/mmu/mmu.c:7609:38: error: 'KVM_TDP_MMU' undeclared (first use in this function)
    7609 |                 else if (mmu_type == KVM_TDP_MMU)
         |                                      ^~~~~~~~~~~
   arch/x86/kvm/mmu/mmu.c:7609:38: note: each undeclared identifier is reported only once for each function it appears in


vim +/KVM_TDP_MMU +7609 arch/x86/kvm/mmu/mmu.c

  7537	
  7538	static void kvm_recover_nx_huge_pages(struct kvm *kvm,
  7539					      enum kvm_mmu_type mmu_type)
  7540	{
  7541		unsigned long to_zap = nx_huge_pages_to_zap(kvm, mmu_type);
  7542		struct list_head *nx_huge_pages;
  7543		struct kvm_memory_slot *slot;
  7544		struct kvm_mmu_page *sp;
  7545		LIST_HEAD(invalid_list);
  7546		bool flush = false;
  7547		int rcu_idx;
  7548	
  7549		nx_huge_pages = &kvm->arch.possible_nx_huge_pages[mmu_type].pages;
  7550	
  7551		rcu_idx = srcu_read_lock(&kvm->srcu);
  7552		write_lock(&kvm->mmu_lock);
  7553	
  7554		/*
  7555		 * Zapping TDP MMU shadow pages, including the remote TLB flush, must
  7556		 * be done under RCU protection, because the pages are freed via RCU
  7557		 * callback.
  7558		 */
  7559		rcu_read_lock();
  7560	
  7561		for ( ; to_zap; --to_zap) {
  7562			if (list_empty(nx_huge_pages))
  7563				break;
  7564	
  7565			/*
  7566			 * We use a separate list instead of just using active_mmu_pages
  7567			 * because the number of shadow pages that be replaced with an
  7568			 * NX huge page is expected to be relatively small compared to
  7569			 * the total number of shadow pages.  And because the TDP MMU
  7570			 * doesn't use active_mmu_pages.
  7571			 */
  7572			sp = list_first_entry(nx_huge_pages,
  7573					      struct kvm_mmu_page,
  7574					      possible_nx_huge_page_link);
  7575			WARN_ON_ONCE(!sp->nx_huge_page_disallowed);
  7576			WARN_ON_ONCE(!sp->role.direct);
  7577	
  7578			/*
  7579			 * Unaccount and do not attempt to recover any NX Huge Pages
  7580			 * that are being dirty tracked, as they would just be faulted
  7581			 * back in as 4KiB pages. The NX Huge Pages in this slot will be
  7582			 * recovered, along with all the other huge pages in the slot,
  7583			 * when dirty logging is disabled.
  7584			 *
  7585			 * Since gfn_to_memslot() is relatively expensive, it helps to
  7586			 * skip it if it the test cannot possibly return true.  On the
  7587			 * other hand, if any memslot has logging enabled, chances are
  7588			 * good that all of them do, in which case unaccount_nx_huge_page()
  7589			 * is much cheaper than zapping the page.
  7590			 *
  7591			 * If a memslot update is in progress, reading an incorrect value
  7592			 * of kvm->nr_memslots_dirty_logging is not a problem: if it is
  7593			 * becoming zero, gfn_to_memslot() will be done unnecessarily; if
  7594			 * it is becoming nonzero, the page will be zapped unnecessarily.
  7595			 * Either way, this only affects efficiency in racy situations,
  7596			 * and not correctness.
  7597			 */
  7598			slot = NULL;
  7599			if (atomic_read(&kvm->nr_memslots_dirty_logging)) {
  7600				struct kvm_memslots *slots;
  7601	
  7602				slots = kvm_memslots_for_spte_role(kvm, sp->role);
  7603				slot = __gfn_to_memslot(slots, sp->gfn);
  7604				WARN_ON_ONCE(!slot);
  7605			}
  7606	
  7607			if (slot && kvm_slot_dirty_track_enabled(slot))
  7608				unaccount_nx_huge_page(kvm, sp);
> 7609			else if (mmu_type == KVM_TDP_MMU)
  7610				flush |= kvm_tdp_mmu_zap_sp(kvm, sp);
  7611			else
  7612				kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
  7613			WARN_ON_ONCE(sp->nx_huge_page_disallowed);
  7614	
  7615			if (need_resched() || rwlock_needbreak(&kvm->mmu_lock)) {
  7616				kvm_mmu_remote_flush_or_zap(kvm, &invalid_list, flush);
  7617				rcu_read_unlock();
  7618	
  7619				cond_resched_rwlock_write(&kvm->mmu_lock);
  7620				flush = false;
  7621	
  7622				rcu_read_lock();
  7623			}
  7624		}
  7625		kvm_mmu_remote_flush_or_zap(kvm, &invalid_list, flush);
  7626	
  7627		rcu_read_unlock();
  7628	
  7629		write_unlock(&kvm->mmu_lock);
  7630		srcu_read_unlock(&kvm->srcu, rcu_idx);
  7631	}
  7632	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

