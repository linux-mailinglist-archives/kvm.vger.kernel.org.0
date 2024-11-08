Return-Path: <kvm+bounces-31226-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BB2729C15EC
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 06:14:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 481E61F24331
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 05:14:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91E421C9EB4;
	Fri,  8 Nov 2024 05:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ect/Yf32"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F220619C571
	for <kvm@vger.kernel.org>; Fri,  8 Nov 2024 05:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731042836; cv=none; b=ecxtOdoEifgOuLmgGkIbFtwJjA+nVhlDCT7SM+pBdDo70XQGWzy4UxmK/I58EtfMmKRWyP8Mzrxc0bFdMBAy+WjqrAwDfNCuHu8mx7zk0+dvVDVJCky2I+wq1ny2oq49oPqxuui6Jepz5mK8/LwuwzawcVTem1Ysu53GA8YflFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731042836; c=relaxed/simple;
	bh=pYc9Qbhl30laTpqG2U4WFIYnywiRC9RUCYu1mKTYEf0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KJWrouJzZf1ck6CJlx8bvxVcRIxKaPhvBVphf88XBPKmy5P/Q5l43JutgC2QDcSjLU6WFvp8UddwQfo+F1gj6OFfh44zGo760dE9yrZ8tTwkqA6GfYkD2Ma4IJuyZ5Wo0W09FgU8dTa39GuKUOE/iSwdE9SLDBFE18TXAyVg01A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ect/Yf32; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731042835; x=1762578835;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=pYc9Qbhl30laTpqG2U4WFIYnywiRC9RUCYu1mKTYEf0=;
  b=ect/Yf32HSgJ6Ac7i/jFTpKf2wbSVQn+wlIrwVbPZmz6H2tMMkrR2L0Q
   e5q6wP8521eX7uPDHwhDCwjLBQRzAfJ6x6XS0m3DA3gbXRLp3Jyh+wKZs
   4JoWT7nrR0D9HYHyjpFunSAg8jTDXd0ZnpPq2sqpSLJQaANXqGcaVnySQ
   VNBDtbRGKOP9rZBXCoNM9Zr6z4qpdWAepziUB9XAp3KocNC17jBWtQk6f
   pA/4s0gnmohhBCgesCfAAIC8ylDisNrrkTwabHdDVhMw0YLDTG3BQOjx3
   w1JOazPzV22ALARl3mAmV+b5A9b0ayfSfmjG/uaSHxRqhyFVWMdu83Twu
   w==;
X-CSE-ConnectionGUID: epriIcfcSwufnhgHg4f4mw==
X-CSE-MsgGUID: dQY6P00mRrS2b/rybdjpXA==
X-IronPort-AV: E=McAfee;i="6700,10204,11249"; a="34842600"
X-IronPort-AV: E=Sophos;i="6.12,137,1728975600"; 
   d="scan'208";a="34842600"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2024 21:13:54 -0800
X-CSE-ConnectionGUID: hj1jmGEURHufH/7Z2oU9RA==
X-CSE-MsgGUID: nD8TOoO9TvCWTbnMnhN+5A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,137,1728975600"; 
   d="scan'208";a="90033772"
Received: from lkp-server01.sh.intel.com (HELO a48cf1aa22e8) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 07 Nov 2024 21:13:50 -0800
Received: from kbuild by a48cf1aa22e8 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1t9HJc-000r3c-0f;
	Fri, 08 Nov 2024 05:13:48 +0000
Date: Fri, 8 Nov 2024 13:13:17 +0800
From: kernel test robot <lkp@intel.com>
To: Jing Zhang <jingzhangos@google.com>, KVM <kvm@vger.kernel.org>,
	KVMARM <kvmarm@lists.linux.dev>,
	ARMLinux <linux-arm-kernel@lists.infradead.org>,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@google.com>,
	Joey Gouly <joey.gouly@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Kunkun Jiang <jiangkunkun@huawei.com>
Cc: oe-kbuild-all@lists.linux.dev, Paolo Bonzini <pbonzini@redhat.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Colton Lewis <coltonlewis@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Shusen Li <lishusen2@huawei.com>, Eric Auger <eauger@redhat.com>,
	Jing Zhang <jingzhangos@google.com>
Subject: Re: [PATCH v4 3/5] KVM: arm64: vgic-its: Add a data length check in
 vgic_its_save_*
Message-ID: <202411081338.47eReEKu-lkp@intel.com>
References: <20241107214137.428439-4-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241107214137.428439-4-jingzhangos@google.com>

Hi Jing,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 59b723cd2adbac2a34fc8e12c74ae26ae45bf230]

url:    https://github.com/intel-lab-lkp/linux/commits/Jing-Zhang/KVM-selftests-aarch64-Add-VGIC-selftest-for-save-restore-ITS-table-mappings/20241108-054433
base:   59b723cd2adbac2a34fc8e12c74ae26ae45bf230
patch link:    https://lore.kernel.org/r/20241107214137.428439-4-jingzhangos%40google.com
patch subject: [PATCH v4 3/5] KVM: arm64: vgic-its: Add a data length check in vgic_its_save_*
config: arm64-randconfig-004-20241108 (https://download.01.org/0day-ci/archive/20241108/202411081338.47eReEKu-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241108/202411081338.47eReEKu-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202411081338.47eReEKu-lkp@intel.com/

All warnings (new ones prefixed by >>):

   arch/arm64/kvm/vgic/vgic-its.c: In function 'vgic_its_save_collection_table':
>> arch/arm64/kvm/vgic/vgic-its.c:2495:13: warning: unused variable 'val' [-Wunused-variable]
    2495 |         u64 val;
         |             ^~~


vim +/val +2495 arch/arm64/kvm/vgic/vgic-its.c

ea1ad53e1e31a3 virt/kvm/arm/vgic/vgic-its.c   Eric Auger         2017-01-09  2484  
0aa34b37a78d06 arch/arm64/kvm/vgic/vgic-its.c Sebastian Ott      2024-07-23  2485  /*
3b65808f4b2914 virt/kvm/arm/vgic/vgic-its.c   Eric Auger         2016-12-24  2486   * vgic_its_save_collection_table - Save the collection table into
3b65808f4b2914 virt/kvm/arm/vgic/vgic-its.c   Eric Auger         2016-12-24  2487   * guest RAM
3b65808f4b2914 virt/kvm/arm/vgic/vgic-its.c   Eric Auger         2016-12-24  2488   */
3b65808f4b2914 virt/kvm/arm/vgic/vgic-its.c   Eric Auger         2016-12-24  2489  static int vgic_its_save_collection_table(struct vgic_its *its)
3b65808f4b2914 virt/kvm/arm/vgic/vgic-its.c   Eric Auger         2016-12-24  2490  {
ea1ad53e1e31a3 virt/kvm/arm/vgic/vgic-its.c   Eric Auger         2017-01-09  2491  	const struct vgic_its_abi *abi = vgic_its_get_abi(its);
c2385eaa6c5a87 virt/kvm/arm/vgic/vgic-its.c   Eric Auger         2017-10-26  2492  	u64 baser = its->baser_coll_table;
8ad50c8985d805 virt/kvm/arm/vgic/vgic-its.c   Kristina Martsenko 2018-09-26  2493  	gpa_t gpa = GITS_BASER_ADDR_48_to_52(baser);
ea1ad53e1e31a3 virt/kvm/arm/vgic/vgic-its.c   Eric Auger         2017-01-09  2494  	struct its_collection *collection;
ea1ad53e1e31a3 virt/kvm/arm/vgic/vgic-its.c   Eric Auger         2017-01-09 @2495  	u64 val;
ea1ad53e1e31a3 virt/kvm/arm/vgic/vgic-its.c   Eric Auger         2017-01-09  2496  	size_t max_size, filled = 0;
ea1ad53e1e31a3 virt/kvm/arm/vgic/vgic-its.c   Eric Auger         2017-01-09  2497  	int ret, cte_esz = abi->cte_esz;
ea1ad53e1e31a3 virt/kvm/arm/vgic/vgic-its.c   Eric Auger         2017-01-09  2498  
c2385eaa6c5a87 virt/kvm/arm/vgic/vgic-its.c   Eric Auger         2017-10-26  2499  	if (!(baser & GITS_BASER_VALID))
ea1ad53e1e31a3 virt/kvm/arm/vgic/vgic-its.c   Eric Auger         2017-01-09  2500  		return 0;
ea1ad53e1e31a3 virt/kvm/arm/vgic/vgic-its.c   Eric Auger         2017-01-09  2501  
c2385eaa6c5a87 virt/kvm/arm/vgic/vgic-its.c   Eric Auger         2017-10-26  2502  	max_size = GITS_BASER_NR_PAGES(baser) * SZ_64K;
ea1ad53e1e31a3 virt/kvm/arm/vgic/vgic-its.c   Eric Auger         2017-01-09  2503  
ea1ad53e1e31a3 virt/kvm/arm/vgic/vgic-its.c   Eric Auger         2017-01-09  2504  	list_for_each_entry(collection, &its->collection_list, coll_list) {
ea1ad53e1e31a3 virt/kvm/arm/vgic/vgic-its.c   Eric Auger         2017-01-09  2505  		ret = vgic_its_save_cte(its, collection, gpa, cte_esz);
ea1ad53e1e31a3 virt/kvm/arm/vgic/vgic-its.c   Eric Auger         2017-01-09  2506  		if (ret)
ea1ad53e1e31a3 virt/kvm/arm/vgic/vgic-its.c   Eric Auger         2017-01-09  2507  			return ret;
ea1ad53e1e31a3 virt/kvm/arm/vgic/vgic-its.c   Eric Auger         2017-01-09  2508  		gpa += cte_esz;
ea1ad53e1e31a3 virt/kvm/arm/vgic/vgic-its.c   Eric Auger         2017-01-09  2509  		filled += cte_esz;
ea1ad53e1e31a3 virt/kvm/arm/vgic/vgic-its.c   Eric Auger         2017-01-09  2510  	}
ea1ad53e1e31a3 virt/kvm/arm/vgic/vgic-its.c   Eric Auger         2017-01-09  2511  
ea1ad53e1e31a3 virt/kvm/arm/vgic/vgic-its.c   Eric Auger         2017-01-09  2512  	if (filled == max_size)
ea1ad53e1e31a3 virt/kvm/arm/vgic/vgic-its.c   Eric Auger         2017-01-09  2513  		return 0;
ea1ad53e1e31a3 virt/kvm/arm/vgic/vgic-its.c   Eric Auger         2017-01-09  2514  
ea1ad53e1e31a3 virt/kvm/arm/vgic/vgic-its.c   Eric Auger         2017-01-09  2515  	/*
ea1ad53e1e31a3 virt/kvm/arm/vgic/vgic-its.c   Eric Auger         2017-01-09  2516  	 * table is not fully filled, add a last dummy element
ea1ad53e1e31a3 virt/kvm/arm/vgic/vgic-its.c   Eric Auger         2017-01-09  2517  	 * with valid bit unset
ea1ad53e1e31a3 virt/kvm/arm/vgic/vgic-its.c   Eric Auger         2017-01-09  2518  	 */
c4380c338c9607 arch/arm64/kvm/vgic/vgic-its.c Kunkun Jiang       2024-11-07  2519  	return vgic_its_write_entry_lock(its, gpa, 0, cte_esz);
3b65808f4b2914 virt/kvm/arm/vgic/vgic-its.c   Eric Auger         2016-12-24  2520  }
3b65808f4b2914 virt/kvm/arm/vgic/vgic-its.c   Eric Auger         2016-12-24  2521  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

