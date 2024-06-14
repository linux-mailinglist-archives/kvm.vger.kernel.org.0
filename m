Return-Path: <kvm+bounces-19671-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B1B3908C6A
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 15:25:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B7C452821D9
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 13:25:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45FDE19AA76;
	Fri, 14 Jun 2024 13:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="T+UIlMOM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EECD71474C6;
	Fri, 14 Jun 2024 13:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718371511; cv=none; b=U7gvR86Zqlvembl+QEnT/dv4EfH09rFQeghuhSRhu87qYHbEOANgjTGWKzHe5ZhU0pw2Oxk5bxZ7Ut3tV0CtuoKlAlzjf4aDyIKvj9NxTN0jCaX6zXwCfSQfn55bgpU6rGPf9DL8bBuAioYPODoju1Pg5poleVSAgZGShvewLTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718371511; c=relaxed/simple;
	bh=PodNgtK+CFxkcM1xg2YMWxubqXt7QosyFJw5EQkc+Os=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h2yIHkaXW9bpntOQItLsTQWM7WIfA461rpiJgJ6sSm3yQtiZUtAcb1hZ6NPPjQF3O7bG5ZbB6AxBwBHu58cBBovWRcaacT+PN1xwBYUgJJTsUvybCnelAiYPSJaaHI0CCCRmaSiPlAUWkuDRopMfuJbih6xNfM6hAYBlqwBMbZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=T+UIlMOM; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718371509; x=1749907509;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=PodNgtK+CFxkcM1xg2YMWxubqXt7QosyFJw5EQkc+Os=;
  b=T+UIlMOMGKtHjRlC0mSbpOQDEul+UymqUj88yAeN4QoEw2uTHxH5XdMt
   JgiLI7jXKyRfjVHoE7BV5I/5+B0/mmR4pPLHLlNXGd/CUkApWJBicC82a
   GWgwb5v3wzf4kJpcw9lqDVdn/zI+z2rAFhUGNxXi52v8Y91DPaa+axg8f
   mrPE1WmNDsQIrCrKGntagcl2C6OwFeGQVCtXC2OWPDYCVhX05U3xa7TB1
   /zQKn9TiJaO5mzg36D4MoN/LJ2927v80XRv/Rcwvoo7mWo5z+6OKiLkn3
   fkSnIzvM+GFAajJFLkC31Q/VkSw44vUts8Kmwa5lzgUalylsfl1TRn+iq
   g==;
X-CSE-ConnectionGUID: 6PMhbOzORCWZqVDD7yG2DA==
X-CSE-MsgGUID: 8L+oe9l+RTWUl8gyoT0Kiw==
X-IronPort-AV: E=McAfee;i="6700,10204,11103"; a="15380521"
X-IronPort-AV: E=Sophos;i="6.08,237,1712646000"; 
   d="scan'208";a="15380521"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2024 06:25:08 -0700
X-CSE-ConnectionGUID: 8QN9I4/STiyppCp86fjhJg==
X-CSE-MsgGUID: oLaBGBtXR2aEW9t2ihg8PQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,237,1712646000"; 
   d="scan'208";a="40635695"
Received: from lkp-server01.sh.intel.com (HELO 9e3ee4e9e062) ([10.239.97.150])
  by orviesa009.jf.intel.com with ESMTP; 14 Jun 2024 06:25:03 -0700
Received: from kbuild by 9e3ee4e9e062 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sI6vM-0001Ln-0t;
	Fri, 14 Jun 2024 13:25:00 +0000
Date: Fri, 14 Jun 2024 21:24:07 +0800
From: kernel test robot <lkp@intel.com>
To: Shivaprasad G Bhat <sbhat@linux.ibm.com>, mpe@ellerman.id.au,
	tpearson@raptorengineering.com, alex.williamson@redhat.com,
	linuxppc-dev@lists.ozlabs.org, aik@amd.com
Cc: oe-kbuild-all@lists.linux.dev, npiggin@gmail.com,
	christophe.leroy@csgroup.eu, aneesh.kumar@kernel.org,
	naveen.n.rao@linux.ibm.com, gbatra@linux.vnet.ibm.com,
	brking@linux.vnet.ibm.com, sbhat@linux.ibm.com, aik@ozlabs.ru,
	jgg@ziepe.ca, ruscur@russell.cc, robh@kernel.org,
	linux-kernel@vger.kernel.org, joel@jms.id.au, kvm@vger.kernel.org,
	msuchanek@suse.de, oohall@gmail.com, mahesh@linux.ibm.com,
	jroedel@suse.de, vaibhav@linux.ibm.com, svaidy@linux.ibm.com
Subject: Re: [PATCH v3 6/6] powerpc/iommu: Reimplement the
 iommu_table_group_ops for pSeries
Message-ID: <202406142110.r97Ts8Xm-lkp@intel.com>
References: <171810901192.1721.18057294492426295643.stgit@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171810901192.1721.18057294492426295643.stgit@linux.ibm.com>

Hi Shivaprasad,

kernel test robot noticed the following build errors:

[auto build test ERROR on powerpc/fixes]
[also build test ERROR on awilliam-vfio/next awilliam-vfio/for-linus linus/master v6.10-rc3]
[cannot apply to powerpc/next next-20240613]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Shivaprasad-G-Bhat/powerpc-iommu-Move-pSeries-specific-functions-to-pseries-iommu-c/20240611-203313
base:   https://git.kernel.org/pub/scm/linux/kernel/git/powerpc/linux.git fixes
patch link:    https://lore.kernel.org/r/171810901192.1721.18057294492426295643.stgit%40linux.ibm.com
patch subject: [PATCH v3 6/6] powerpc/iommu: Reimplement the iommu_table_group_ops for pSeries
config: powerpc64-randconfig-r133-20240614 (https://download.01.org/0day-ci/archive/20240614/202406142110.r97Ts8Xm-lkp@intel.com/config)
compiler: clang version 19.0.0git (https://github.com/llvm/llvm-project 78ee473784e5ef6f0b19ce4cb111fb6e4d23c6b2)
reproduce: (https://download.01.org/0day-ci/archive/20240614/202406142110.r97Ts8Xm-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202406142110.r97Ts8Xm-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from arch/powerpc/platforms/pseries/iommu.c:16:
   In file included from include/linux/mm.h:2253:
   include/linux/vmstat.h:500:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
     500 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     501 |                            item];
         |                            ~~~~
   include/linux/vmstat.h:507:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
     507 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     508 |                            NR_VM_NUMA_EVENT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~~
   include/linux/vmstat.h:514:36: warning: arithmetic between different enumeration types ('enum node_stat_item' and 'enum lru_list') [-Wenum-enum-conversion]
     514 |         return node_stat_name(NR_LRU_BASE + lru) + 3; // skip "nr_"
         |                               ~~~~~~~~~~~ ^ ~~~
   include/linux/vmstat.h:519:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
     519 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     520 |                            NR_VM_NUMA_EVENT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~~
   include/linux/vmstat.h:528:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
     528 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     529 |                            NR_VM_NUMA_EVENT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~~
>> arch/powerpc/platforms/pseries/iommu.c:1839:47: error: use of undeclared identifier 'dev_has_iommu_table'; did you mean 'device_iommu_capable'?
    1839 |         ret = iommu_group_for_each_dev(group, &pdev, dev_has_iommu_table);
         |                                                      ^~~~~~~~~~~~~~~~~~~
         |                                                      device_iommu_capable
   include/linux/iommu.h:1079:20: note: 'device_iommu_capable' declared here
    1079 | static inline bool device_iommu_capable(struct device *dev, enum iommu_cap cap)
         |                    ^
   arch/powerpc/platforms/pseries/iommu.c:1953:15: warning: variable 'entries_shift' set but not used [-Wunused-but-set-variable]
    1953 |         unsigned int entries_shift;
         |                      ^
   arch/powerpc/platforms/pseries/iommu.c:2166:17: warning: variable 'pci' set but not used [-Wunused-but-set-variable]
    2166 |         struct pci_dn *pci;
         |                        ^
   7 warnings and 1 error generated.


vim +1839 arch/powerpc/platforms/pseries/iommu.c

  1829	
  1830	static struct pci_dev *iommu_group_get_first_pci_dev(struct iommu_group *group)
  1831	{
  1832		struct pci_dev *pdev = NULL;
  1833		int ret;
  1834	
  1835		/* No IOMMU group ? */
  1836		if (!group)
  1837			return NULL;
  1838	
> 1839		ret = iommu_group_for_each_dev(group, &pdev, dev_has_iommu_table);
  1840		if (!ret || !pdev)
  1841			return NULL;
  1842		return pdev;
  1843	}
  1844	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

