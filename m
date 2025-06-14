Return-Path: <kvm+bounces-49553-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 25C1EAD997D
	for <lists+kvm@lfdr.de>; Sat, 14 Jun 2025 03:36:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 80A343A5DCC
	for <lists+kvm@lfdr.de>; Sat, 14 Jun 2025 01:36:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A0673594E;
	Sat, 14 Jun 2025 01:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="js+/J+7W"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B354B12B93
	for <kvm@vger.kernel.org>; Sat, 14 Jun 2025 01:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749865004; cv=none; b=rDSlqfrCwhyN4noZgasHbs/kO0wumUhupktyVAA4Roea0N5xaYHkuV0w/f+7UvGru091iZ71z7cxUEZEm9VqVVRH1I+0PFLkEiTzDTHfDQTqDuLXT6w2ZpwtNfImdpqSUuovqbuBSCvvGHifgT/vchzbdWLEtYHkY8xIw1I198s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749865004; c=relaxed/simple;
	bh=VO3kg1FEolUOhMe2kMHJwNm6Mnj3UC8tH/cDB49YqvQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=NVo1IMxu32xF1OrpV6mTovoNWOdXn8gxn3Ba4UQQM3mT7pr9c7OMc2MhSqgfc8I2tbVgJdMXiMwkSKrkO+NzJuk5/B8RDcz2dFnLRESuVsLp5tcvAVyy0/Dz25mQxECpou+s5vOPrV1EwyLcy+YZI9okpdx6jO6STUzbyTI5e9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=js+/J+7W; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749865002; x=1781401002;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=VO3kg1FEolUOhMe2kMHJwNm6Mnj3UC8tH/cDB49YqvQ=;
  b=js+/J+7WlUT7l6AtpxDBvz7zqWjn//h8JwCb1sgbl+oWgpguz31hGYBb
   oRb5uKH/+okvgqs2+u3r/C9j3mPLD4qxJODvTufzZBuP1h76Rc8qdritb
   wzYs/0nUr/NTWiD50QCj1EERiE/G0FqHCus5n//OLhSw2TtgsD0OO6pOW
   kd7e8LpOeKVzoFikLSVMQHsm3LkZHmqAqMpA1G3AoKasHRSjFxtF2x5Di
   UPe8n61xvoqW2QZlJih9WJC1Azfv01x7bk7fvM6eQFyB/iIl9Ui4c4IVX
   4lhI6EEzAYQPOXfR3pr/da9R6hwJtY4Gqaa1QLhFMiUSzEgqzE1UXU+Iu
   A==;
X-CSE-ConnectionGUID: YuIDiinXRTqk6r4o3umyOQ==
X-CSE-MsgGUID: Zt6dHt4MSJ+oLFNznlJtOw==
X-IronPort-AV: E=McAfee;i="6800,10657,11463"; a="63498597"
X-IronPort-AV: E=Sophos;i="6.16,235,1744095600"; 
   d="scan'208";a="63498597"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2025 18:36:41 -0700
X-CSE-ConnectionGUID: g3AfTelIQ9aCDZ1DUdQhvA==
X-CSE-MsgGUID: lyWgD0QORamsmcC6nEibZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,235,1744095600"; 
   d="scan'208";a="178859156"
Received: from lkp-server01.sh.intel.com (HELO e8142ee1dce2) ([10.239.97.150])
  by orviesa002.jf.intel.com with ESMTP; 13 Jun 2025 18:36:39 -0700
Received: from kbuild by e8142ee1dce2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uQFoz-000D9G-1N;
	Sat, 14 Jun 2025 01:36:37 +0000
Date: Sat, 14 Jun 2025 09:35:58 +0800
From: kernel test robot <lkp@intel.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: oe-kbuild-all@lists.linux.dev, kvm@vger.kernel.org,
	Farrah Chen <farrah.chen@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Fuad Tabba <tabba@google.com>
Subject: [kvm:queue 23/30] include/linux/compiler_types.h:568:45: error: call
 to '__compiletime_assert_421' declared with attribute error: BUILD_BUG
 failed
Message-ID: <202506140912.0npst1Ch-lkp@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
head:   79150772457f4d45e38b842d786240c36bb1f97f
commit: f562719cc02e3f85fee6daadc8c4bdb6a99132f5 [23/30] KVM: x86: Consult guest_memfd when computing max_mapping_level
config: x86_64-buildonly-randconfig-003-20250614 (https://download.01.org/0day-ci/archive/20250614/202506140912.0npst1Ch-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250614/202506140912.0npst1Ch-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202506140912.0npst1Ch-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from <command-line>:
   In function 'kvm_gmem_mapping_order',
       inlined from 'kvm_gmem_max_mapping_level' at arch/x86/kvm/mmu/mmu.c:3302:14,
       inlined from 'kvm_mmu_max_mapping_level' at arch/x86/kvm/mmu/mmu.c:3318:10:
>> include/linux/compiler_types.h:568:45: error: call to '__compiletime_assert_421' declared with attribute error: BUILD_BUG failed
     568 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |                                             ^
   include/linux/compiler_types.h:549:25: note: in definition of macro '__compiletime_assert'
     549 |                         prefix ## suffix();                             \
         |                         ^~~~~~
   include/linux/compiler_types.h:568:9: note: in expansion of macro '_compiletime_assert'
     568 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_assert'
      39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
         |                                     ^~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:59:21: note: in expansion of macro 'BUILD_BUG_ON_MSG'
      59 | #define BUILD_BUG() BUILD_BUG_ON_MSG(1, "BUILD_BUG failed")
         |                     ^~~~~~~~~~~~~~~~
   include/linux/kvm_host.h:2604:9: note: in expansion of macro 'BUILD_BUG'
    2604 |         BUILD_BUG();
         |         ^~~~~~~~~


vim +/__compiletime_assert_421 +568 include/linux/compiler_types.h

eb5c2d4b45e3d2 Will Deacon 2020-07-21  554  
eb5c2d4b45e3d2 Will Deacon 2020-07-21  555  #define _compiletime_assert(condition, msg, prefix, suffix) \
eb5c2d4b45e3d2 Will Deacon 2020-07-21  556  	__compiletime_assert(condition, msg, prefix, suffix)
eb5c2d4b45e3d2 Will Deacon 2020-07-21  557  
eb5c2d4b45e3d2 Will Deacon 2020-07-21  558  /**
eb5c2d4b45e3d2 Will Deacon 2020-07-21  559   * compiletime_assert - break build and emit msg if condition is false
eb5c2d4b45e3d2 Will Deacon 2020-07-21  560   * @condition: a compile-time constant condition to check
eb5c2d4b45e3d2 Will Deacon 2020-07-21  561   * @msg:       a message to emit if condition is false
eb5c2d4b45e3d2 Will Deacon 2020-07-21  562   *
eb5c2d4b45e3d2 Will Deacon 2020-07-21  563   * In tradition of POSIX assert, this macro will break the build if the
eb5c2d4b45e3d2 Will Deacon 2020-07-21  564   * supplied condition is *false*, emitting the supplied error message if the
eb5c2d4b45e3d2 Will Deacon 2020-07-21  565   * compiler has support to do so.
eb5c2d4b45e3d2 Will Deacon 2020-07-21  566   */
eb5c2d4b45e3d2 Will Deacon 2020-07-21  567  #define compiletime_assert(condition, msg) \
eb5c2d4b45e3d2 Will Deacon 2020-07-21 @568  	_compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
eb5c2d4b45e3d2 Will Deacon 2020-07-21  569  

:::::: The code at line 568 was first introduced by commit
:::::: eb5c2d4b45e3d2d5d052ea6b8f1463976b1020d5 compiler.h: Move compiletime_assert() macros into compiler_types.h

:::::: TO: Will Deacon <will@kernel.org>
:::::: CC: Will Deacon <will@kernel.org>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

