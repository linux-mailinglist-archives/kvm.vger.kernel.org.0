Return-Path: <kvm+bounces-24119-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 175259517C5
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 11:33:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BEF812845A6
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 09:33:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85BD114A4D2;
	Wed, 14 Aug 2024 09:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XJYlDezI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00AE714A0AD;
	Wed, 14 Aug 2024 09:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723628026; cv=none; b=L9TKm0YdVHXgcoOcNGd0xLySszpzwIrqvjt6w5krfAr/yVuXOcAeQauEyfVOVpMvgnlVTcupTgN8Gdsxa6aHrGrqydc3ChHyUQS4N5rf9WyMz4mjwmlfJLu74lZC0bka2p5flxzbzs2PLQzDA9rHX7E8Yqrks/7OP9wAWKzWLP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723628026; c=relaxed/simple;
	bh=qMVgxt+7Ss1AA3wSvp0fvB6rLrSxpJ8aL45BP/09Peg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wcg9n6SxnjZT5f1qUNoTAOdTgOZOZQ69QSLiha1MwG/Nqn87mAIqXOBn1wtUpOI/Tcd+IWNJ8V/9uj+geE/AN7F7RIOAIe8Fn6MSaEyvajN5KAlafrbjMuF+FboNpYGhd98XcWiXWVUZ+e7OQfod6jCIxhDIkiya7OeEaJqAKQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XJYlDezI; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723628025; x=1755164025;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=qMVgxt+7Ss1AA3wSvp0fvB6rLrSxpJ8aL45BP/09Peg=;
  b=XJYlDezIaK1dCp6CGHPjCfvRv7VVQFtR5ulk8bDVOZ2f8g1xv4Ve/ODd
   5qp21CUg4fSjMMQQ86CllEN0y4SLpx/+krsbEjZSyt6k91a6rSM8Up9cD
   v/G5iFDVqZHU8lyHkH8l/BirwKazJBHS0pODNtxrxSh12Vm4tupdYN5c4
   5WDlL2Y4t7wOwnZpQgmMmeJchVHvelQnhfm5JTynCvrZcnH1m/vEaypdr
   tFLX+EnS1lRDowsGH2H9rs5+OXvHsOol1fRgQz3dbgB+Z0FHvpkPoZaHp
   RpZkuX4mo2hTfvh4mJoZTvMrLvDYDcfqAGlfLF7ryOp+kdeLJhmA7ShoX
   w==;
X-CSE-ConnectionGUID: 6Lt6UqEWTpSPSQZtneJ1cg==
X-CSE-MsgGUID: xrPByqW3TpmSBZgG55sD0Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11163"; a="25593431"
X-IronPort-AV: E=Sophos;i="6.09,288,1716274800"; 
   d="scan'208";a="25593431"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2024 02:33:44 -0700
X-CSE-ConnectionGUID: qPD2f555SMaOwVJih+WFXg==
X-CSE-MsgGUID: dGEWQ0gsRTmyzGGR5+k2xw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,288,1716274800"; 
   d="scan'208";a="59529376"
Received: from lkp-server01.sh.intel.com (HELO 9a732dc145d3) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 14 Aug 2024 02:33:42 -0700
Received: from kbuild by 9a732dc145d3 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1seANw-0001Xz-0d;
	Wed, 14 Aug 2024 09:33:40 +0000
Date: Wed, 14 Aug 2024 17:33:25 +0800
From: kernel test robot <lkp@intel.com>
To: Vipin Sharma <vipinsh@google.com>, seanjc@google.com,
	pbonzini@redhat.com
Cc: oe-kbuild-all@lists.linux.dev, dmatlack@google.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Vipin Sharma <vipinsh@google.com>
Subject: Re: [PATCH 2/2] KVM: x86/mmu: Recover NX Huge pages belonging to TDP
 MMU under MMU read lock
Message-ID: <202408141753.ZY1CSmGo-lkp@intel.com>
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

kernel test robot noticed the following build errors:

[auto build test ERROR on 332d2c1d713e232e163386c35a3ba0c1b90df83f]

url:    https://github.com/intel-lab-lkp/linux/commits/Vipin-Sharma/KVM-x86-mmu-Split-NX-hugepage-recovery-flow-into-TDP-and-non-TDP-flow/20240814-091542
base:   332d2c1d713e232e163386c35a3ba0c1b90df83f
patch link:    https://lore.kernel.org/r/20240812171341.1763297-3-vipinsh%40google.com
patch subject: [PATCH 2/2] KVM: x86/mmu: Recover NX Huge pages belonging to TDP MMU under MMU read lock
config: i386-buildonly-randconfig-005-20240814 (https://download.01.org/0day-ci/archive/20240814/202408141753.ZY1CSmGo-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240814/202408141753.ZY1CSmGo-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202408141753.ZY1CSmGo-lkp@intel.com/

All errors (new ones prefixed by >>):

   arch/x86/kvm/mmu/mmu.c: In function 'kvm_mmu_possible_nx_huge_page':
>> arch/x86/kvm/mmu/mmu.c:7324:29: error: 'struct kvm_arch' has no member named 'tdp_mmu_pages_lock'
    7324 |         spin_lock(&kvm->arch.tdp_mmu_pages_lock);
         |                             ^
   arch/x86/kvm/mmu/mmu.c:7335:47: error: 'struct kvm_arch' has no member named 'tdp_mmu_pages_lock'
    7335 |                         spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
         |                                               ^
   arch/x86/kvm/mmu/mmu.c:7340:31: error: 'struct kvm_arch' has no member named 'tdp_mmu_pages_lock'
    7340 |         spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
         |                               ^


vim +7324 arch/x86/kvm/mmu/mmu.c

  7313	
  7314	/*
  7315	 * Get the first shadow mmu page of desired type from the NX huge pages list.
  7316	 * Return NULL if list doesn't have the needed page with in the first max pages.
  7317	 */
  7318	struct kvm_mmu_page *kvm_mmu_possible_nx_huge_page(struct kvm *kvm, bool tdp_mmu,
  7319							   ulong max)
  7320	{
  7321		struct kvm_mmu_page *sp = NULL;
  7322		ulong i = 0;
  7323	
> 7324		spin_lock(&kvm->arch.tdp_mmu_pages_lock);
  7325		/*
  7326		 * We use a separate list instead of just using active_mmu_pages because
  7327		 * the number of shadow pages that be replaced with an NX huge page is
  7328		 * expected to be relatively small compared to the total number of shadow
  7329		 * pages. And because the TDP MMU doesn't use active_mmu_pages.
  7330		 */
  7331		list_for_each_entry(sp, &kvm->arch.possible_nx_huge_pages, possible_nx_huge_page_link) {
  7332			if (i++ >= max)
  7333				break;
  7334			if (is_tdp_mmu_page(sp) == tdp_mmu) {
  7335				spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
  7336				return sp;
  7337			}
  7338		}
  7339	
  7340		spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
  7341		return NULL;
  7342	}
  7343	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

