Return-Path: <kvm+bounces-59837-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 09638BCFDD8
	for <lists+kvm@lfdr.de>; Sun, 12 Oct 2025 01:36:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D5A0E18978B6
	for <lists+kvm@lfdr.de>; Sat, 11 Oct 2025 23:36:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E663B253F2B;
	Sat, 11 Oct 2025 23:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FYoWAPvE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBC51193077;
	Sat, 11 Oct 2025 23:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760225752; cv=none; b=P+OynZ1eo/4n8Z+e0bv877A/zXnoG5uhfSTrZ4nY5SWB2xneO92FedlJOtNcm3IlV2xlU2w19ogmnmqzu4a2pICSnYOUO0VfsB8bZJAXaxssUqjX4jUk3/zY2zd88AQYbKiICNZeQ6eyUTqkchX6v18R3V8sSFNYV1xEsj+6DB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760225752; c=relaxed/simple;
	bh=D2nnX9A3bAt550p64cwu/V8sO85/EYtXZJ1Lk2moVMw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=up3BpLSeSjhRq55OgVEIg7Jsa8nXy364BtaXbCd2z/3yFpzqAbQzL/ixbEMYPhieIw7vsAB4PuSF5rcSW+g0SXhJeI7IS7pYU5Wr54sKU73+/enTvTIQiWNOYjXC0oweOMU+VKABu9oo2nbk9OFYI5lzCelOpbDcXVi/o/T2bUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FYoWAPvE; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760225751; x=1791761751;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=D2nnX9A3bAt550p64cwu/V8sO85/EYtXZJ1Lk2moVMw=;
  b=FYoWAPvEsgwQlSwfTn5CikOnP2uT/DOQrdTsCfbxdK/dZyyjq3PPrRLH
   1mVjOs9CGZuShT6+PpLBQMLGXCTITWUdPcION1UqZQ2JhWi4pd+FebNf6
   cPudxvV/DBmTrKNWPALZ1iLP2k9Wcylb5k4GfmEbQZD8M0Ot6hnbsgO+q
   xKi8lbyDtgLMbhG7j4/1H8QeGFiPkekQc2T4RNTes76BNFDZnRDzo5vsv
   ubqeo/ZKe3DOXW3GfZRU+PkbEfYM6jD2UYA8VpEikVF0aFVM0t8MD9Upd
   j5SN8uDpRw948t0S31bR+GMoj/2JAi5NIRCPGCxU9ww38kRphROfLpdiw
   Q==;
X-CSE-ConnectionGUID: 8PCdS4pDTn+A08pLsoYzsA==
X-CSE-MsgGUID: WsvzXQHlT/GhCF0GFb9WPw==
X-IronPort-AV: E=McAfee;i="6800,10657,11579"; a="73847647"
X-IronPort-AV: E=Sophos;i="6.19,222,1754982000"; 
   d="scan'208";a="73847647"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2025 16:35:50 -0700
X-CSE-ConnectionGUID: si1EuU/VSBOZG4J0EGxbtw==
X-CSE-MsgGUID: hCpMIkXNTvWDe3JgxTXqtQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,222,1754982000"; 
   d="scan'208";a="185281302"
Received: from lkp-server01.sh.intel.com (HELO 6a630e8620ab) ([10.239.97.150])
  by orviesa003.jf.intel.com with ESMTP; 11 Oct 2025 16:35:44 -0700
Received: from kbuild by 6a630e8620ab with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v7j7l-00042l-36;
	Sat, 11 Oct 2025 23:35:41 +0000
Date: Sun, 12 Oct 2025 07:35:41 +0800
From: kernel test robot <lkp@intel.com>
To: =?utf-8?Q?Micha=C5=82?= Winiarski <michal.winiarski@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	intel-xe@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	dri-devel@lists.freedesktop.org,
	Matthew Brost <matthew.brost@intel.com>,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Lukasz Laguna <lukasz.laguna@intel.com>,
	=?utf-8?Q?Micha=C5=82?= Winiarski <michal.winiarski@intel.com>
Subject: Re: [PATCH 11/26] drm/xe: Allow the caller to pass guc_buf_cache size
Message-ID: <202510120724.osgbcJi5-lkp@intel.com>
References: <20251011193847.1836454-12-michal.winiarski@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251011193847.1836454-12-michal.winiarski@intel.com>

Hi Michał,

kernel test robot noticed the following build errors:

[auto build test ERROR on drm-xe/drm-xe-next]
[also build test ERROR on next-20251010]
[cannot apply to awilliam-vfio/next drm-i915/for-linux-next drm-i915/for-linux-next-fixes linus/master awilliam-vfio/for-linus v6.17]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Micha-Winiarski/drm-xe-pf-Remove-GuC-version-check-for-migration-support/20251012-034301
base:   https://gitlab.freedesktop.org/drm/xe/kernel.git drm-xe-next
patch link:    https://lore.kernel.org/r/20251011193847.1836454-12-michal.winiarski%40intel.com
patch subject: [PATCH 11/26] drm/xe: Allow the caller to pass guc_buf_cache size
config: riscv-randconfig-002-20251012 (https://download.01.org/0day-ci/archive/20251012/202510120724.osgbcJi5-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 39f292ffa13d7ca0d1edff27ac8fd55024bb4d19)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251012/202510120724.osgbcJi5-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202510120724.osgbcJi5-lkp@intel.com/

All error/warnings (new ones prefixed by >>):

   In file included from drivers/gpu/drm/xe/xe_guc_buf.c:180:
>> drivers/gpu/drm/xe/tests/xe_guc_buf_kunit.c:75:61: error: too many arguments provided to function-like macro invocation
      75 |         KUNIT_ASSERT_EQ(test, 0, xe_guc_buf_cache_init(&guc->buf), SZ_8K);
         |                                                                    ^
   include/kunit/test.h:1358:9: note: macro 'KUNIT_ASSERT_EQ' defined here
    1358 | #define KUNIT_ASSERT_EQ(test, left, right) \
         |         ^
   In file included from drivers/gpu/drm/xe/xe_guc_buf.c:180:
>> drivers/gpu/drm/xe/tests/xe_guc_buf_kunit.c:75:2: error: use of undeclared identifier 'KUNIT_ASSERT_EQ'; did you mean 'KUNIT_ASSERTION'?
      75 |         KUNIT_ASSERT_EQ(test, 0, xe_guc_buf_cache_init(&guc->buf), SZ_8K);
         |         ^~~~~~~~~~~~~~~
         |         KUNIT_ASSERTION
   include/kunit/assert.h:27:2: note: 'KUNIT_ASSERTION' declared here
      27 |         KUNIT_ASSERTION,
         |         ^
   In file included from drivers/gpu/drm/xe/xe_guc_buf.c:180:
>> drivers/gpu/drm/xe/tests/xe_guc_buf_kunit.c:75:2: warning: expression result unused [-Wunused-value]
      75 |         KUNIT_ASSERT_EQ(test, 0, xe_guc_buf_cache_init(&guc->buf), SZ_8K);
         |         ^~~~~~~~~~~~~~~
   1 warning and 2 errors generated.


vim +75 drivers/gpu/drm/xe/tests/xe_guc_buf_kunit.c

    51	
    52	static int guc_buf_test_init(struct kunit *test)
    53	{
    54		struct xe_pci_fake_data fake = {
    55			.sriov_mode = XE_SRIOV_MODE_PF,
    56			.platform = XE_TIGERLAKE, /* some random platform */
    57			.subplatform = XE_SUBPLATFORM_NONE,
    58		};
    59		struct xe_ggtt *ggtt;
    60		struct xe_guc *guc;
    61	
    62		test->priv = &fake;
    63		xe_kunit_helper_xe_device_test_init(test);
    64	
    65		ggtt = xe_device_get_root_tile(test->priv)->mem.ggtt;
    66		guc = &xe_device_get_gt(test->priv, 0)->uc.guc;
    67	
    68		KUNIT_ASSERT_EQ(test, 0,
    69				xe_ggtt_init_kunit(ggtt, DUT_GGTT_START,
    70						   DUT_GGTT_START + DUT_GGTT_SIZE));
    71	
    72		kunit_activate_static_stub(test, xe_managed_bo_create_pin_map,
    73					   replacement_xe_managed_bo_create_pin_map);
    74	
  > 75		KUNIT_ASSERT_EQ(test, 0, xe_guc_buf_cache_init(&guc->buf), SZ_8K);
    76	
    77		test->priv = &guc->buf;
    78		return 0;
    79	}
    80	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

