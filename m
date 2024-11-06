Return-Path: <kvm+bounces-30864-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DB3B69BE0E6
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 09:28:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 18D681C22F99
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 08:28:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D22621D5CC7;
	Wed,  6 Nov 2024 08:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J4Y5gozX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F5891D5178;
	Wed,  6 Nov 2024 08:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730881343; cv=none; b=uzSSWzZwgKM5ufe+2STyx7L3W71XSBR7AxfB7hGvJO+sgsjVSE2LGhbMoh7VUboNsGhvzpRE5RtpnMOD4hlMiW8Bs1C5jbhtaXNjEDZl93fIfEJ+8P0qJcz7nU/R3BKixp+mxq/bn+b90tN6eAHmHQ1+gSMD6q+EUdAtaWfJ5To=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730881343; c=relaxed/simple;
	bh=xZIKcH8xCyb0GTaVvSB3BqXD9mW6/nv+FXboxz/GI74=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CVr6sKE/yPlJxb+kymBZQZb/LEUpaEjXSPcdZRIdAUL1v0FHPKQnzFNV4I0FuL2d5aqu7dWXjdC4ssLVAcmHV2iDxCz56zvMW5nzHBvLNB/4pDIOTTfMP9gjG2ySbQF6UqBoy6jKPZrY95To2KddQzslZ+3+atZ5bXw0UQ6wSqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=J4Y5gozX; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730881341; x=1762417341;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xZIKcH8xCyb0GTaVvSB3BqXD9mW6/nv+FXboxz/GI74=;
  b=J4Y5gozXGIwkiiRR7mupiEpAAJk8DHqwPQgnpmDdDKT3Wo3kimTAgeD+
   UB1odgzjEbfnVsTwS6oVs5hzShTjR0Y5RTMUh2adeKco5RBsu64R1T4sy
   cpafDYq6Q592ruTvtBcQnI2aNUIqk2fjzNPIpIKKZU/hS6/VDcZyZ10BY
   nFj09v/CcNQny2N2Z4uPZcd9MUkcCqPmMQgxWIjmbf6OMy7rE7+zf36uD
   k1HmFaxss4vil+FFgA3j5xZYjs4bGxPXapILWqjt8W8jUFI4BlgfTk4xE
   chwzvAzAq/RYf92zh9zS8+cDgUUyFpkRc+mKAYQIS71uZetHZofuxvVh/
   Q==;
X-CSE-ConnectionGUID: cqrFxJ7hSP+IRMEWKde4pw==
X-CSE-MsgGUID: +lLpo7moTbyE4AbTOKZBxA==
X-IronPort-AV: E=McAfee;i="6700,10204,11247"; a="30886722"
X-IronPort-AV: E=Sophos;i="6.11,262,1725346800"; 
   d="scan'208";a="30886722"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 00:22:20 -0800
X-CSE-ConnectionGUID: RtbyNr8cRXG/qvBKAWPtFQ==
X-CSE-MsgGUID: LZopDLTsR6u0Qj0aY9xbhA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,262,1725346800"; 
   d="scan'208";a="89544488"
Received: from lkp-server01.sh.intel.com (HELO a48cf1aa22e8) ([10.239.97.150])
  by orviesa004.jf.intel.com with ESMTP; 06 Nov 2024 00:22:18 -0800
Received: from kbuild by a48cf1aa22e8 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1t8bIt-000n50-0a;
	Wed, 06 Nov 2024 08:22:15 +0000
Date: Wed, 6 Nov 2024 16:22:08 +0800
From: kernel test robot <lkp@intel.com>
To: James Houghton <jthoughton@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: oe-kbuild-all@lists.linux.dev, David Matlack <dmatlack@google.com>,
	David Rientjes <rientjes@google.com>,
	James Houghton <jthoughton@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>, Wei Xu <weixugc@google.com>,
	Yu Zhao <yuzhao@google.com>,
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 04/11] KVM: x86/mmu: Relax locking for
 kvm_test_age_gfn and kvm_age_gfn
Message-ID: <202411061526.RAuCXKJh-lkp@intel.com>
References: <20241105184333.2305744-5-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241105184333.2305744-5-jthoughton@google.com>

Hi James,

kernel test robot noticed the following build warnings:

[auto build test WARNING on a27e0515592ec9ca28e0d027f42568c47b314784]

url:    https://github.com/intel-lab-lkp/linux/commits/James-Houghton/KVM-Remove-kvm_handle_hva_range-helper-functions/20241106-025133
base:   a27e0515592ec9ca28e0d027f42568c47b314784
patch link:    https://lore.kernel.org/r/20241105184333.2305744-5-jthoughton%40google.com
patch subject: [PATCH v8 04/11] KVM: x86/mmu: Relax locking for kvm_test_age_gfn and kvm_age_gfn
config: x86_64-rhel-8.3 (https://download.01.org/0day-ci/archive/20241106/202411061526.RAuCXKJh-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241106/202411061526.RAuCXKJh-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202411061526.RAuCXKJh-lkp@intel.com/

All warnings (new ones prefixed by >>):

   arch/x86/kvm/mmu/tdp_mmu.c: In function 'kvm_tdp_mmu_age_spte':
>> arch/x86/kvm/mmu/tdp_mmu.c:1189:23: warning: ignoring return value of '__tdp_mmu_set_spte_atomic' declared with attribute 'warn_unused_result' [-Wunused-result]
    1189 |                 (void)__tdp_mmu_set_spte_atomic(iter, new_spte);
         |                       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


vim +1189 arch/x86/kvm/mmu/tdp_mmu.c

  1166	
  1167	/*
  1168	 * Mark the SPTEs range of GFNs [start, end) unaccessed and return non-zero
  1169	 * if any of the GFNs in the range have been accessed.
  1170	 *
  1171	 * No need to mark the corresponding PFN as accessed as this call is coming
  1172	 * from the clear_young() or clear_flush_young() notifier, which uses the
  1173	 * return value to determine if the page has been accessed.
  1174	 */
  1175	static void kvm_tdp_mmu_age_spte(struct tdp_iter *iter)
  1176	{
  1177		u64 new_spte;
  1178	
  1179		if (spte_ad_enabled(iter->old_spte)) {
  1180			iter->old_spte = tdp_mmu_clear_spte_bits_atomic(iter->sptep,
  1181							shadow_accessed_mask);
  1182			new_spte = iter->old_spte & ~shadow_accessed_mask;
  1183		} else {
  1184			new_spte = mark_spte_for_access_track(iter->old_spte);
  1185			/*
  1186			 * It is safe for the following cmpxchg to fail. Leave the
  1187			 * Accessed bit set, as the spte is most likely young anyway.
  1188			 */
> 1189			(void)__tdp_mmu_set_spte_atomic(iter, new_spte);
  1190		}
  1191	
  1192		trace_kvm_tdp_mmu_spte_changed(iter->as_id, iter->gfn, iter->level,
  1193					       iter->old_spte, new_spte);
  1194	}
  1195	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

