Return-Path: <kvm+bounces-46511-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 35D80AB6FCF
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 17:30:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9066816713D
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 15:28:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC9BC1EA7DE;
	Wed, 14 May 2025 15:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dTuLbvpK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D02D1C84BD;
	Wed, 14 May 2025 15:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747236469; cv=none; b=XyYF+/XcGkTKYXiaNYjCR8TJUF6Z2t/MlxKTfW+zIaa3+L/qEF0K8p1iTuE7DDHAofSBXElLiKBcR3u46gsdaRI/iabB3Q1vNbC0FSPFgq3a97hVYJFsvR9kCuUPbfrweXNU0RY0grz5cGsMA8fRigjwquTTBc+MOPpJMKUsvrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747236469; c=relaxed/simple;
	bh=P4BH575FBKSRRUHOEBLubn9LCIJLPGRG4oWLRNDGjY8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dAv4G6kMhzKik7D754iQJ40/hzP/WU9qQdEz4r6GI4OE05vjRkx2yTwfM++SAuKESA7NHviHSNSMVWmvwGWDGP37UVlOvt8shq2ifhuJLR44qpA2GzECUh3voROTXG9UjMkMEcUfJAKchPZDcBwcg+Qq7EMOlHIVZxdxL3210YE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dTuLbvpK; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747236468; x=1778772468;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=P4BH575FBKSRRUHOEBLubn9LCIJLPGRG4oWLRNDGjY8=;
  b=dTuLbvpKOoJkIusofNu6VRmTzQ9/6ot3/cke8bdygyRaEcuFy50twmSj
   drCzaLsSydIyfpvK4QHQobScfUUbFudbzpouvdx8wgwqt4rQaEQb5p9/U
   /+o9r/9x/lPM2GIq8cT9bxlIT5EyHg01An7zwazb1BaaAqK2U67EzyuN3
   95F737bQRvKB7m2Lg76tGLWDK+8BH0Y0taWXe+6mQY0u23iIrlQhlWnsW
   dO1q93E3ZQ3FPWvhspQ0WsTmp1Ripz7r6kkQ4aFDf5JVz+xO48XgmV0Iz
   d0SODeSGmEwuIINIo80l5aZoRBkDcv/l9+BvURL1s2hGG2pTpSS1pbbwY
   A==;
X-CSE-ConnectionGUID: ay4aNdGVRrePCMylWM5Wzg==
X-CSE-MsgGUID: NQ+bFWnrQk23H5at9mO0cA==
X-IronPort-AV: E=McAfee;i="6700,10204,11433"; a="49011867"
X-IronPort-AV: E=Sophos;i="6.15,288,1739865600"; 
   d="scan'208";a="49011867"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2025 08:27:47 -0700
X-CSE-ConnectionGUID: 6M0mFNVXS1WQNOpaUjmxFA==
X-CSE-MsgGUID: r0hgZytISMGBd7h96K6ctA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,288,1739865600"; 
   d="scan'208";a="138597901"
Received: from lkp-server01.sh.intel.com (HELO 1992f890471c) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 14 May 2025 08:27:40 -0700
Received: from kbuild by 1992f890471c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uFE1C-000HHD-0g;
	Wed, 14 May 2025 15:27:38 +0000
Date: Wed, 14 May 2025 23:27:07 +0800
From: kernel test robot <lkp@intel.com>
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
	linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: oe-kbuild-all@lists.linux.dev, pbonzini@redhat.com,
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org,
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu,
	seanjc@google.com, viro@zeniv.linux.org.uk, brauner@kernel.org,
	willy@infradead.org, akpm@linux-foundation.org,
	xiaoyao.li@intel.com, yilun.xu@intel.com,
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com,
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net,
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com,
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com,
	wei.w.wang@intel.com
Subject: Re: [PATCH v9 10/17] KVM: x86: Compute max_mapping_level with input
 from guest_memfd
Message-ID: <202505142334.6dQb5Sei-lkp@intel.com>
References: <20250513163438.3942405-11-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250513163438.3942405-11-tabba@google.com>

Hi Fuad,

kernel test robot noticed the following build errors:

[auto build test ERROR on 82f2b0b97b36ee3fcddf0f0780a9a0825d52fec3]

url:    https://github.com/intel-lab-lkp/linux/commits/Fuad-Tabba/KVM-Rename-CONFIG_KVM_PRIVATE_MEM-to-CONFIG_KVM_GMEM/20250514-003900
base:   82f2b0b97b36ee3fcddf0f0780a9a0825d52fec3
patch link:    https://lore.kernel.org/r/20250513163438.3942405-11-tabba%40google.com
patch subject: [PATCH v9 10/17] KVM: x86: Compute max_mapping_level with input from guest_memfd
config: x86_64-buildonly-randconfig-002-20250514 (https://download.01.org/0day-ci/archive/20250514/202505142334.6dQb5Sei-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250514/202505142334.6dQb5Sei-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202505142334.6dQb5Sei-lkp@intel.com/

All errors (new ones prefixed by >>):

   arch/x86/kvm/mmu/mmu.c: In function 'kvm_mmu_max_mapping_level':
>> arch/x86/kvm/mmu/mmu.c:3315:14: error: implicit declaration of function 'kvm_get_memory_attributes' [-Werror=implicit-function-declaration]
    3315 |              kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE)) {
         |              ^~~~~~~~~~~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors


vim +/kvm_get_memory_attributes +3315 arch/x86/kvm/mmu/mmu.c

  3303	
  3304	int kvm_mmu_max_mapping_level(struct kvm *kvm,
  3305				      const struct kvm_memory_slot *slot, gfn_t gfn)
  3306	{
  3307		int max_level;
  3308	
  3309		max_level = kvm_lpage_info_max_mapping_level(kvm, slot, gfn, PG_LEVEL_NUM);
  3310		if (max_level == PG_LEVEL_4K)
  3311			return PG_LEVEL_4K;
  3312	
  3313		if (kvm_slot_has_gmem(slot) &&
  3314		    (kvm_gmem_memslot_supports_shared(slot) ||
> 3315		     kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE)) {
  3316			return kvm_gmem_max_mapping_level(slot, gfn, max_level);
  3317		}
  3318	
  3319		return min(max_level, host_pfn_mapping_level(kvm, gfn, slot));
  3320	}
  3321	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

