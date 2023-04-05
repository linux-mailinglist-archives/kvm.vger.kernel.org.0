Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E65C16D894B
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 23:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234009AbjDEVJF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 17:09:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231348AbjDEVJA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 17:09:00 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FCC476A9;
        Wed,  5 Apr 2023 14:08:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680728911; x=1712264911;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=picBdeJZw61WBdGmpyZ2sgLgyFBlqMaZ7koEZZt3f8c=;
  b=eezdR8znS5Fn4xo+7AdXhqwWcenmLDHr7NzBucm3S7zNYYPTBptoZMAj
   9GWDW56P0Rgu16aXoVTHwh0kFzeUKZwxVKhUWrpoWo/hthEJRDW1qOsG1
   jeu2qH0tmxVMWntrqt50UdKCzOryzowyIgQdxE0nCG9AQag9dud8nBuSx
   Ce4zaM45w510Qf7OrqIriTqT8FviO2YXSAMYCITk6Vuh6oEcxrIqoJNIs
   h32gwdVE7FRUxjUlYvJQOWKMMUXa54f77HkdXRES+0A6QDMa+pwQOihZP
   X7J7n5R5Vr+FhNv7j+e49WNAzlottDAZK3CDgvwq3M+CT6+BE4TVEfeva
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10671"; a="407657505"
X-IronPort-AV: E=Sophos;i="5.98,321,1673942400"; 
   d="scan'208";a="407657505"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2023 14:08:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10671"; a="1016620275"
X-IronPort-AV: E=Sophos;i="5.98,321,1673942400"; 
   d="scan'208";a="1016620275"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 05 Apr 2023 14:08:25 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pkAMi-000Qnu-1t;
        Wed, 05 Apr 2023 21:08:24 +0000
Date:   Thu, 6 Apr 2023 05:07:56 +0800
From:   kernel test robot <lkp@intel.com>
To:     ankita@nvidia.com, jgg@nvidia.com, alex.williamson@redhat.com,
        naoya.horiguchi@nec.com, maz@kernel.org, oliver.upton@linux.dev
Cc:     oe-kbuild-all@lists.linux.dev, aniketa@nvidia.com, cjia@nvidia.com,
        kwankhede@nvidia.com, targupta@nvidia.com, vsethi@nvidia.com,
        acurrid@nvidia.com, apopple@nvidia.com, jhubbard@nvidia.com,
        danw@nvidia.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 3/6] mm: handle poisoning of pfn without struct pages
Message-ID: <202304060452.tpNrPK39-lkp@intel.com>
References: <20230405180134.16932-4-ankita@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405180134.16932-4-ankita@nvidia.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

kernel test robot noticed the following build errors:

[auto build test ERROR on awilliam-vfio/for-linus]
[also build test ERROR on kvmarm/next akpm-mm/mm-everything linus/master v6.3-rc5]
[cannot apply to awilliam-vfio/next next-20230405]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/ankita-nvidia-com/kvm-determine-memory-type-from-VMA/20230406-020404
base:   https://github.com/awilliam/linux-vfio.git for-linus
patch link:    https://lore.kernel.org/r/20230405180134.16932-4-ankita%40nvidia.com
patch subject: [PATCH v3 3/6] mm: handle poisoning of pfn without struct pages
config: x86_64-randconfig-a015-20230403 (https://download.01.org/0day-ci/archive/20230406/202304060452.tpNrPK39-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-8) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/25466c8c2fa22d39a08721a24f0cf3bc3059417b
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review ankita-nvidia-com/kvm-determine-memory-type-from-VMA/20230406-020404
        git checkout 25466c8c2fa22d39a08721a24f0cf3bc3059417b
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=x86_64 olddefconfig
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202304060452.tpNrPK39-lkp@intel.com/

All errors (new ones prefixed by >>):

   ld: vmlinux.o: in function `memory_failure_pfn':
>> mm/memory-failure.c:2124: undefined reference to `interval_tree_iter_first'
>> ld: mm/memory-failure.c:2125: undefined reference to `interval_tree_iter_next'
   ld: vmlinux.o: in function `register_pfn_address_space':
>> mm/memory-failure.c:2087: undefined reference to `interval_tree_insert'
   ld: vmlinux.o: in function `unregister_pfn_address_space':
>> mm/memory-failure.c:2105: undefined reference to `interval_tree_remove'


vim +2124 mm/memory-failure.c

  2065	
  2066	/**
  2067	 * register_pfn_address_space - Register PA region for poison notification.
  2068	 * @pfn_space: structure containing region range and callback function on
  2069	 *             poison detection.
  2070	 *
  2071	 * This function is called by a kernel module to register a PA region and
  2072	 * a callback function with the kernel. On detection of poison, the
  2073	 * kernel code will go through all registered regions and call the
  2074	 * appropriate callback function associated with the range. The kernel
  2075	 * module is responsible for tracking the poisoned pages.
  2076	 *
  2077	 * Return: 0 if successfully registered,
  2078	 *         -EBUSY if the region is already registered
  2079	 */
  2080	int register_pfn_address_space(struct pfn_address_space *pfn_space)
  2081	{
  2082		if (!request_mem_region(pfn_space->node.start << PAGE_SHIFT,
  2083			(pfn_space->node.last - pfn_space->node.start + 1) << PAGE_SHIFT, ""))
  2084			return -EBUSY;
  2085	
  2086		mutex_lock(&pfn_space_lock);
> 2087		interval_tree_insert(&pfn_space->node, &pfn_space_itree);
  2088		mutex_unlock(&pfn_space_lock);
  2089	
  2090		return 0;
  2091	}
  2092	EXPORT_SYMBOL_GPL(register_pfn_address_space);
  2093	
  2094	/**
  2095	 * unregister_pfn_address_space - Unregister a PA region from poison
  2096	 * notification.
  2097	 * @pfn_space: structure containing region range to be unregistered.
  2098	 *
  2099	 * This function is called by a kernel module to unregister the PA region
  2100	 * from the kernel from poison tracking.
  2101	 */
  2102	void unregister_pfn_address_space(struct pfn_address_space *pfn_space)
  2103	{
  2104		mutex_lock(&pfn_space_lock);
> 2105		interval_tree_remove(&pfn_space->node, &pfn_space_itree);
  2106		mutex_unlock(&pfn_space_lock);
  2107		release_mem_region(pfn_space->node.start << PAGE_SHIFT,
  2108			(pfn_space->node.last - pfn_space->node.start + 1) << PAGE_SHIFT);
  2109	}
  2110	EXPORT_SYMBOL_GPL(unregister_pfn_address_space);
  2111	
  2112	static int memory_failure_pfn(unsigned long pfn, int flags)
  2113	{
  2114		struct interval_tree_node *node;
  2115		int rc = -EBUSY;
  2116		LIST_HEAD(tokill);
  2117	
  2118		mutex_lock(&pfn_space_lock);
  2119		/*
  2120		 * Modules registers with MM the address space mapping to the device memory they
  2121		 * manage. Iterate to identify exactly which address space has mapped to this
  2122		 * failing PFN.
  2123		 */
> 2124		for (node = interval_tree_iter_first(&pfn_space_itree, pfn, pfn); node;
> 2125		     node = interval_tree_iter_next(node, pfn, pfn)) {
  2126			struct pfn_address_space *pfn_space =
  2127				container_of(node, struct pfn_address_space, node);
  2128			rc = 0;
  2129	
  2130			/*
  2131			 * Modules managing the device memory needs to be conveyed about the
  2132			 * memory failure so that the poisoned PFN can be tracked.
  2133			 */
  2134			pfn_space->ops->failure(pfn_space, pfn);
  2135	
  2136			collect_procs_pgoff(NULL, pfn_space->mapping, pfn, &tokill);
  2137	
  2138			unmap_mapping_range(pfn_space->mapping, pfn << PAGE_SHIFT,
  2139					    PAGE_SIZE, 0);
  2140		}
  2141		mutex_unlock(&pfn_space_lock);
  2142	
  2143		/*
  2144		 * Unlike System-RAM there is no possibility to swap in a different
  2145		 * physical page at a given virtual address, so all userspace
  2146		 * consumption of direct PFN memory necessitates SIGBUS (i.e.
  2147		 * MF_MUST_KILL)
  2148		 */
  2149		flags |= MF_ACTION_REQUIRED | MF_MUST_KILL;
  2150		kill_procs(&tokill, true, false, pfn, flags);
  2151	
  2152		pr_err("%#lx: recovery action for %s: %s\n",
  2153				pfn, action_page_types[MF_MSG_PFN],
  2154				action_name[rc ? MF_FAILED : MF_RECOVERED]);
  2155	
  2156		return rc;
  2157	}
  2158	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
