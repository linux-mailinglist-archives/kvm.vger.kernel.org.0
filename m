Return-Path: <kvm+bounces-24215-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CF4889525FA
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 00:51:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 90E5E283077
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 22:51:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 712F814B97E;
	Wed, 14 Aug 2024 22:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="a1fEymYV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5842F149C68;
	Wed, 14 Aug 2024 22:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723675850; cv=none; b=L6U3TLiOVDx87Fr5fCD6lnVLsR1cHLExf3K+uVoRakiaDj2HHgOBQuq/PgtipwOPk9VdIVKidYFKYKSX9BuNOMx3OkXc1nSx8L/fpm9VJsHfOxw0z3z64pjahmuLFKV7fi91/dcjsuXmrfhUitBpmggDvplxU7bs1a2jqtPyc9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723675850; c=relaxed/simple;
	bh=XACRDTFRCEdt4Ybi1MT/HUspbONa/ZokfleowFT6sVA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WiifErx8/lPu3U6KDbAkWNNS7gvuLUzfc+M1Q05/CnWP2gOL1qRoDbEvfc1emk5Aa2lgFZkUSyCL5Fplza6x9GYFAUTzhxXmwA0gGAxgafZlu9J6hr4zHMUHtQm+22p7hnHC5LLFjEQmL6ZTPK45tmFJzTCzplA+1Jefc/I1Lxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=a1fEymYV; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723675847; x=1755211847;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=XACRDTFRCEdt4Ybi1MT/HUspbONa/ZokfleowFT6sVA=;
  b=a1fEymYVtATT83042PXmI/bJVXHong5CHtGk97N78t99THdINuMSveaU
   i8dZ+TmGdhDWoIftw0xNlwpyTc1tUxrFPGqS0ZfMIcYEPLCZaUbsMgk8x
   WjRgPVWm6hIQ+ZsdXXDbs/tk5CxCsjjQVGer0sDiKUHhWmfzL1/AAuWsb
   uryyx7loXDr80rfid6G5bTMC7tn63KIYwYEgTN/37PKJ17unoU2zjTqq8
   a+JpCSxCjILWNjEllzRdKr4J+5J0qaNnDDE05eP7VeLx7ZnqDkcSgWo7M
   BCPBc3QIO0U7yUwqUmvIh16ARkvsyyW5aWUtLD9zC891MxT/4fKaCFzZl
   g==;
X-CSE-ConnectionGUID: anTOy87zQs6UQLD2LySSiA==
X-CSE-MsgGUID: p28pns+KTFmIGCUM0uPibg==
X-IronPort-AV: E=McAfee;i="6700,10204,11164"; a="33330266"
X-IronPort-AV: E=Sophos;i="6.10,147,1719903600"; 
   d="scan'208";a="33330266"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2024 15:50:46 -0700
X-CSE-ConnectionGUID: NCgkFaq2RLaUvtWr7qMiIQ==
X-CSE-MsgGUID: qow68/JDQyaVfRBa7KD4qw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,147,1719903600"; 
   d="scan'208";a="58834085"
Received: from lkp-server01.sh.intel.com (HELO 9a732dc145d3) ([10.239.97.150])
  by fmviesa007.fm.intel.com with ESMTP; 14 Aug 2024 15:50:44 -0700
Received: from kbuild by 9a732dc145d3 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1seMpF-0002xE-18;
	Wed, 14 Aug 2024 22:50:41 +0000
Date: Thu, 15 Aug 2024 06:50:04 +0800
From: kernel test robot <lkp@intel.com>
To: Vipin Sharma <vipinsh@google.com>, seanjc@google.com,
	pbonzini@redhat.com
Cc: oe-kbuild-all@lists.linux.dev, dmatlack@google.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Vipin Sharma <vipinsh@google.com>
Subject: Re: [PATCH 2/2] KVM: x86/mmu: Recover NX Huge pages belonging to TDP
 MMU under MMU read lock
Message-ID: <202408150646.VV4z8Znl-lkp@intel.com>
References: <20240812171341.1763297-3-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240812171341.1763297-3-vipinsh@google.com>

Hi Vipin,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 332d2c1d713e232e163386c35a3ba0c1b90df83f]

url:    https://github.com/intel-lab-lkp/linux/commits/Vipin-Sharma/KVM-x86-mmu-Split-NX-hugepage-recovery-flow-into-TDP-and-non-TDP-flow/20240814-091542
base:   332d2c1d713e232e163386c35a3ba0c1b90df83f
patch link:    https://lore.kernel.org/r/20240812171341.1763297-3-vipinsh%40google.com
patch subject: [PATCH 2/2] KVM: x86/mmu: Recover NX Huge pages belonging to TDP MMU under MMU read lock
config: x86_64-randconfig-123-20240814 (https://download.01.org/0day-ci/archive/20240815/202408150646.VV4z8Znl-lkp@intel.com/config)
compiler: clang version 18.1.5 (https://github.com/llvm/llvm-project 617a15a9eac96088ae5e9134248d8236e34b91b1)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240815/202408150646.VV4z8Znl-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202408150646.VV4z8Znl-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> arch/x86/kvm/mmu/tdp_mmu.c:847:21: sparse: sparse: incompatible types in comparison expression (different address spaces):
   arch/x86/kvm/mmu/tdp_mmu.c:847:21: sparse:    unsigned long long [usertype] *
   arch/x86/kvm/mmu/tdp_mmu.c:847:21: sparse:    unsigned long long [noderef] [usertype] __rcu *
   arch/x86/kvm/mmu/tdp_mmu.c: note: in included file (through include/linux/rbtree.h, include/linux/mm_types.h, include/linux/mmzone.h, ...):
   include/linux/rcupdate.h:812:25: sparse: sparse: context imbalance in '__tdp_mmu_zap_root' - unexpected unlock
   arch/x86/kvm/mmu/tdp_mmu.c:1447:33: sparse: sparse: context imbalance in 'tdp_mmu_split_huge_pages_root' - unexpected unlock

vim +847 arch/x86/kvm/mmu/tdp_mmu.c

   819	
   820	static bool tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
   821	{
   822		struct tdp_iter iter = {};
   823	
   824		lockdep_assert_held_read(&kvm->mmu_lock);
   825	
   826		/*
   827		 * This helper intentionally doesn't allow zapping a root shadow page,
   828		 * which doesn't have a parent page table and thus no associated entry.
   829		 */
   830		if (WARN_ON_ONCE(!sp->ptep))
   831			return false;
   832	
   833		iter.old_spte = kvm_tdp_mmu_read_spte(sp->ptep);
   834		iter.sptep = sp->ptep;
   835		iter.level = sp->role.level + 1;
   836		iter.gfn = sp->gfn;
   837		iter.as_id = kvm_mmu_page_as_id(sp);
   838	
   839	retry:
   840		/*
   841		 * Since mmu_lock is held in read mode, it's possible to race with
   842		 * another CPU which can remove sp from the page table hierarchy.
   843		 *
   844		 * No need to re-read iter.old_spte as tdp_mmu_set_spte_atomic() will
   845		 * update it in the case of failure.
   846		 */
 > 847		if (sp->spt != spte_to_child_pt(iter.old_spte, iter.level))
   848			return false;
   849	
   850		if (tdp_mmu_set_spte_atomic(kvm, &iter, SHADOW_NONPRESENT_VALUE))
   851			goto retry;
   852	
   853		return true;
   854	}
   855	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

