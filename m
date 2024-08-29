Return-Path: <kvm+bounces-25410-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D29A39650D3
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 22:38:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8A71A284738
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 20:38:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 603C81BAEF1;
	Thu, 29 Aug 2024 20:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="anW59re8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 836E9189F5A;
	Thu, 29 Aug 2024 20:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724963898; cv=none; b=BjlzDdA/WKx+LXldThH8q4blG3tZX3TGZ5+V1DdIsFozNrKtcHev/PlEn09x+bWf9BPncjjA7XjhXJLmAn1PZKMiSMval2trr7FS6hURZxfNbtXyBYDSqWjUcG7abGzEDgWyYz3zSwFjazqHrfdSyGIdveFaqFqgYTyjV4waMq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724963898; c=relaxed/simple;
	bh=tscwRgI2saPDR7x1unDsFBI0xOp0fMmY1QDhyt+9PHk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ss3sJVP4SYqLwK/aO06zGgpYIXDBCRWJUcU3tts3v05dtuccu3W6lTIpsrch2enAl6mrU9UtMpENgGxBD6dV8OKwCI9J1K4Li6P1ejHAk6A2FqmyCrkjXlPJkRi8wCSod51A5CUO7i2d4ChCx7uet/5Cf+TAP4lvEAe7OJqstHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=anW59re8; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724963897; x=1756499897;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=tscwRgI2saPDR7x1unDsFBI0xOp0fMmY1QDhyt+9PHk=;
  b=anW59re8g7E9kAelpNk+BBP1JV1PEOrPDKd7lZU3vM+SOIaCuXobj0e7
   uP8jDX1W910+zN1waibuYTbWL94NJXYfhUx2AC9ZLDFiUSrgdhMxcwleh
   OUEOtML7MWvmxWzN/kTUyo65swMO2bpGzo61/drgiQ/kPWsVZjOSyz2jV
   RIylGzGYX7dHLL5pkZqeCHM9cIzq4NMLT1Lq1EiwtFMExxfQwx/P2Bse4
   i3a5xxZANsNKbKJtTLaOEFDOOKEf1GGNI6f/lyXCoFIQCUAf4iwRPCoW8
   GfNpg9+UU3sctCg7zK6YcjZCv0EM+Dipba01RU1n3VXzfgtzA+iajeMPQ
   w==;
X-CSE-ConnectionGUID: uMfpJ0muT5O3mIJDIuxDYw==
X-CSE-MsgGUID: lbXaaTgCQVukWM3SIXoUVQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11179"; a="34200571"
X-IronPort-AV: E=Sophos;i="6.10,186,1719903600"; 
   d="scan'208";a="34200571"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2024 13:37:41 -0700
X-CSE-ConnectionGUID: +2I+PKpfTEWO7ZhOV/mdjw==
X-CSE-MsgGUID: 9jFLsk+2R9icUo/uf7t0Ig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,186,1719903600"; 
   d="scan'208";a="63325399"
Received: from lkp-server01.sh.intel.com (HELO 9c6b1c7d3b50) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 29 Aug 2024 13:37:38 -0700
Received: from kbuild by 9c6b1c7d3b50 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sjltg-0000iM-02;
	Thu, 29 Aug 2024 20:37:36 +0000
Date: Fri, 30 Aug 2024 04:37:35 +0800
From: kernel test robot <lkp@intel.com>
To: Vegard Nossum <vegard.nossum@oracle.com>,
	Masahiro Yamada <masahiroy@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-omap@vger.kernel.org, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, linux-um@lists.infradead.org,
	bpf@vger.kernel.org, llvm@lists.linux.dev,
	Vegard Nossum <vegard.nossum@oracle.com>
Subject: Re: [PATCH] kbuild: use objcopy to generate asm-offsets
Message-ID: <202408300438.xObK98m5-lkp@intel.com>
References: <20240828083605.3093701-1-vegard.nossum@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240828083605.3093701-1-vegard.nossum@oracle.com>

Hi Vegard,

kernel test robot noticed the following build warnings:

[auto build test WARNING on masahiroy-kbuild/for-next]
[also build test WARNING on masahiroy-kbuild/fixes soc/for-next kvmarm/next kvm/queue uml/next krzk-mem-ctrl/for-next bpf-next/master bpf/master linus/master v6.11-rc5 next-20240829]
[cannot apply to tmlind-omap/for-next kvm/linux-next uml/fixes]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Vegard-Nossum/kbuild-use-objcopy-to-generate-asm-offsets/20240828-163854
base:   https://git.kernel.org/pub/scm/linux/kernel/git/masahiroy/linux-kbuild.git for-next
patch link:    https://lore.kernel.org/r/20240828083605.3093701-1-vegard.nossum%40oracle.com
patch subject: [PATCH] kbuild: use objcopy to generate asm-offsets
config: mips-loongson3_defconfig (https://download.01.org/0day-ci/archive/20240830/202408300438.xObK98m5-lkp@intel.com/config)
compiler: mips64el-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240830/202408300438.xObK98m5-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202408300438.xObK98m5-lkp@intel.com/

All warnings (new ones prefixed by >>):

   mips64el-linux-objcopy: /dev/stdout[.data.kbuild]: Illegal seek
   In file included from include/linux/mm_types.h:18,
                    from include/linux/uio.h:10,
                    from include/linux/socket.h:8,
                    from include/linux/compat.h:15,
                    from arch/mips/kernel/asm-offsets.c:12:
   include/linux/page-flags-layout.h:15:5: warning: "MAX_NR_ZONES" is not defined, evaluates to 0 [-Wundef]
      15 | #if MAX_NR_ZONES < 2
         |     ^~~~~~~~~~~~
   include/linux/page-flags-layout.h:58:19: warning: "LRU_GEN_WIDTH" is not defined, evaluates to 0 [-Wundef]
      58 | #if ZONES_WIDTH + LRU_GEN_WIDTH + SECTIONS_WIDTH + NODES_SHIFT \
         |                   ^~~~~~~~~~~~~
   include/linux/page-flags-layout.h:59:28: warning: "NR_PAGEFLAGS" is not defined, evaluates to 0 [-Wundef]
      59 |         <= BITS_PER_LONG - NR_PAGEFLAGS
         |                            ^~~~~~~~~~~~
   include/linux/page-flags-layout.h:93:19: warning: "LRU_GEN_WIDTH" is not defined, evaluates to 0 [-Wundef]
      93 | #if ZONES_WIDTH + LRU_GEN_WIDTH + SECTIONS_WIDTH + NODES_WIDTH + \
         |                   ^~~~~~~~~~~~~
   include/linux/page-flags-layout.h:94:64: warning: "NR_PAGEFLAGS" is not defined, evaluates to 0 [-Wundef]
      94 |         KASAN_TAG_WIDTH + LAST_CPUPID_SHIFT <= BITS_PER_LONG - NR_PAGEFLAGS
         |                                                                ^~~~~~~~~~~~
   include/linux/page-flags-layout.h:104:19: warning: "LRU_GEN_WIDTH" is not defined, evaluates to 0 [-Wundef]
     104 | #if ZONES_WIDTH + LRU_GEN_WIDTH + SECTIONS_WIDTH + NODES_WIDTH + \
         |                   ^~~~~~~~~~~~~
   include/linux/page-flags-layout.h:105:63: warning: "NR_PAGEFLAGS" is not defined, evaluates to 0 [-Wundef]
     105 |         KASAN_TAG_WIDTH + LAST_CPUPID_WIDTH > BITS_PER_LONG - NR_PAGEFLAGS
         |                                                               ^~~~~~~~~~~~
   In file included from include/linux/mm_types.h:5:
   include/linux/mm_types_task.h:22:34: warning: "SPINLOCK_SIZE" is not defined, evaluates to 0 [-Wundef]
      22 | #define ALLOC_SPLIT_PTLOCKS     (SPINLOCK_SIZE > BITS_PER_LONG/8)
         |                                  ^~~~~~~~~~~~~
   include/linux/mm_types.h:478:5: note: in expansion of macro 'ALLOC_SPLIT_PTLOCKS'
     478 | #if ALLOC_SPLIT_PTLOCKS
         |     ^~~~~~~~~~~~~~~~~~~
   In file included from include/linux/dcache.h:14,
                    from include/linux/fs.h:8,
                    from include/linux/compat.h:17:
>> include/linux/lockref.h:23:36: warning: "SPINLOCK_SIZE" is not defined, evaluates to 0 [-Wundef]
      23 |          IS_ENABLED(CONFIG_SMP) && SPINLOCK_SIZE <= 4)
         |                                    ^~~~~~~~~~~~~
   include/linux/lockref.h:27:5: note: in expansion of macro 'USE_CMPXCHG_LOCKREF'
      27 | #if USE_CMPXCHG_LOCKREF
         |     ^~~~~~~~~~~~~~~~~~~
   In file included from include/linux/gfp.h:7,
                    from include/linux/xarray.h:16,
                    from include/linux/list_lru.h:14,
                    from include/linux/fs.h:13:
   include/linux/mmzone.h:842:29: error: 'MAX_NR_ZONES' undeclared here (not in a function); did you mean 'MAX_NR_GENS'?
     842 |         long lowmem_reserve[MAX_NR_ZONES];
         |                             ^~~~~~~~~~~~
         |                             MAX_NR_GENS
   include/linux/mm_types_task.h:22:34: warning: "SPINLOCK_SIZE" is not defined, evaluates to 0 [-Wundef]
      22 | #define ALLOC_SPLIT_PTLOCKS     (SPINLOCK_SIZE > BITS_PER_LONG/8)
         |                                  ^~~~~~~~~~~~~
   include/linux/mm.h:2889:5: note: in expansion of macro 'ALLOC_SPLIT_PTLOCKS'
    2889 | #if ALLOC_SPLIT_PTLOCKS
         |     ^~~~~~~~~~~~~~~~~~~
   In file included from include/linux/swap.h:9,
                    from include/linux/suspend.h:5,
                    from arch/mips/kernel/asm-offsets.c:17:
   include/linux/memcontrol.h: In function 'mem_cgroup_get_zone_lru_size':
>> include/linux/memcontrol.h:914:31: warning: parameter 'lru' set but not used [-Wunused-but-set-parameter]
     914 |                 enum lru_list lru, int zone_idx)
         |                 ~~~~~~~~~~~~~~^~~
>> include/linux/memcontrol.h:914:40: warning: parameter 'zone_idx' set but not used [-Wunused-but-set-parameter]
     914 |                 enum lru_list lru, int zone_idx)
         |                                    ~~~~^~~~~~~~
   make[3]: *** [scripts/Makefile.build:244: arch/mips/kernel/asm-offsets.o] Error 1
   make[3]: Target 'missing-syscalls' not remade because of errors.
   make[2]: *** [arch/mips/Makefile:432: archprepare] Error 2
   make[2]: Target 'prepare' not remade because of errors.
   make[1]: *** [Makefile:224: __sub-make] Error 2
   make[1]: Target 'prepare' not remade because of errors.
   make: *** [Makefile:224: __sub-make] Error 2
   make: Target 'prepare' not remade because of errors.


vim +/SPINLOCK_SIZE +23 include/linux/lockref.h

57f4257eae33e0 Peter Zijlstra     2013-11-14  20  
57f4257eae33e0 Peter Zijlstra     2013-11-14  21  #define USE_CMPXCHG_LOCKREF \
57f4257eae33e0 Peter Zijlstra     2013-11-14  22  	(IS_ENABLED(CONFIG_ARCH_USE_CMPXCHG_LOCKREF) && \
597d795a2a786d Kirill A. Shutemov 2013-12-20 @23  	 IS_ENABLED(CONFIG_SMP) && SPINLOCK_SIZE <= 4)
0f8f2aaaab0b0f Waiman Long        2013-08-28  24  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

