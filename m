Return-Path: <kvm+bounces-19422-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 96572904ED5
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 11:12:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DD93CB23E4D
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 09:12:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3806716D9A6;
	Wed, 12 Jun 2024 09:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U5xrjmpf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79BE7BE78;
	Wed, 12 Jun 2024 09:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718183509; cv=none; b=G82Od/wjaTki3/XFbSXgECWF7WNTFSeR5YOECi/5LEJXmIF1Y5KoujtvePAW0Z42/UykRlx1tKy925SvotzlUpa9zfC/N96uxbI0X9h5IjnSTieEpMdheE2HTMiA1mIk+gEGQn9TpAUcief4O7YSd4TqofUIGLTN8zMKgXx3dcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718183509; c=relaxed/simple;
	bh=uHHbRBCTiJ34kbeRIJM+Nw7RNe5FB8UcM4OyBaMx2Jk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GlIxYPiSklI2JKzHp6ldw7BKlosT2hAHLi8PYcIhqAnK3cdBVQq3aEoslir8GkkmReL8DDWW0ngzVDacRYlqBXO+QHm/oWNKLXyU+W1wWMqNg7oGPNaCFzdvspt+uq8cu5tlF7ZbTnrLAAyRMP5jl37pquRXQBm13bMvC/uCqWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U5xrjmpf; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718183508; x=1749719508;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=uHHbRBCTiJ34kbeRIJM+Nw7RNe5FB8UcM4OyBaMx2Jk=;
  b=U5xrjmpfG6kcIHs07BoB/g0A8bfjHXVASuoF/Y0sNg6eZh/dsiU1YAvA
   xBbymNxRqYqJxDpXXaWrV2ZzqpiNAsbivm1/2uxMTzRFofaA94e8mtpE5
   8DtABq4cWnOdBPdtC/f7rcp00Gn1q8OIMmD51HaJ0hBiSu4rP9O8XD051
   CEfrE61kJmcTLrbkCyVw+N6d7XGPE2+GmeZk21kYEkeJB7/k34HU9LrK3
   La7RQDhOWRc+elA/7k8VJ03B5wfs6IKiK2hx4bUDTiuYX94g4HC/Lpf6t
   X5uwEMwZwxf87x3NR01jmhoWX/JRnQbIE0CWBbslEPzLDYuJ6jFGmoQcX
   w==;
X-CSE-ConnectionGUID: jlYsa1XASVWyep98n6HMow==
X-CSE-MsgGUID: 8KHQRwRfSdK3IPtDsHCJzA==
X-IronPort-AV: E=McAfee;i="6600,9927,11100"; a="32471837"
X-IronPort-AV: E=Sophos;i="6.08,232,1712646000"; 
   d="scan'208";a="32471837"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2024 02:11:47 -0700
X-CSE-ConnectionGUID: KJv0yy49TpKfXdtNEZCfqw==
X-CSE-MsgGUID: BGIpTBxDQWG9p72u13GTVQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,232,1712646000"; 
   d="scan'208";a="40357291"
Received: from lkp-server01.sh.intel.com (HELO 628d7d8b9fc6) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 12 Jun 2024 02:11:40 -0700
Received: from kbuild by 628d7d8b9fc6 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sHK14-0001Oc-16;
	Wed, 12 Jun 2024 09:11:38 +0000
Date: Wed, 12 Jun 2024 17:11:20 +0800
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
Message-ID: <202406121640.yr6LK5HJ-lkp@intel.com>
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

kernel test robot noticed the following build warnings:

[auto build test WARNING on powerpc/fixes]
[also build test WARNING on awilliam-vfio/next awilliam-vfio/for-linus linus/master v6.10-rc3]
[cannot apply to powerpc/next next-20240612]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Shivaprasad-G-Bhat/powerpc-iommu-Move-pSeries-specific-functions-to-pseries-iommu-c/20240611-203313
base:   https://git.kernel.org/pub/scm/linux/kernel/git/powerpc/linux.git fixes
patch link:    https://lore.kernel.org/r/171810901192.1721.18057294492426295643.stgit%40linux.ibm.com
patch subject: [PATCH v3 6/6] powerpc/iommu: Reimplement the iommu_table_group_ops for pSeries
config: powerpc64-randconfig-001-20240612 (https://download.01.org/0day-ci/archive/20240612/202406121640.yr6LK5HJ-lkp@intel.com/config)
compiler: powerpc64-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240612/202406121640.yr6LK5HJ-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202406121640.yr6LK5HJ-lkp@intel.com/

All warnings (new ones prefixed by >>):

   arch/powerpc/platforms/pseries/iommu.c: In function 'spapr_tce_create_table':
>> arch/powerpc/platforms/pseries/iommu.c:1953:22: warning: variable 'entries_shift' set but not used [-Wunused-but-set-variable]
    1953 |         unsigned int entries_shift;
         |                      ^~~~~~~~~~~~~
   arch/powerpc/platforms/pseries/iommu.c: In function 'spapr_tce_unset_window':
>> arch/powerpc/platforms/pseries/iommu.c:2166:24: warning: variable 'pci' set but not used [-Wunused-but-set-variable]
    2166 |         struct pci_dn *pci;
         |                        ^~~


vim +/entries_shift +1953 arch/powerpc/platforms/pseries/iommu.c

  1940	
  1941	static long spapr_tce_create_table(struct iommu_table_group *table_group, int num,
  1942					   __u32 page_shift, __u64 window_size, __u32 levels,
  1943					   struct iommu_table **ptbl)
  1944	{
  1945		struct pci_dev *pdev = iommu_group_get_first_pci_dev(table_group->group);
  1946		u32 ddw_avail[DDW_APPLICABLE_SIZE];
  1947		struct ddw_create_response create;
  1948		unsigned long liobn, offset, size;
  1949		unsigned long start = 0, end = 0;
  1950		struct ddw_query_response query;
  1951		const __be32 *default_prop;
  1952		struct failed_ddw_pdn *fpdn;
> 1953		unsigned int entries_shift;
  1954		unsigned int window_shift;
  1955		struct device_node *pdn;
  1956		struct iommu_table *tbl;
  1957		struct dma_win *window;
  1958		struct property *win64;
  1959		struct pci_dn *pci;
  1960		u64 win_addr;
  1961		int len, i;
  1962		long ret;
  1963	
  1964		if (!is_power_of_2(window_size) || levels > 1)
  1965			return -EINVAL;
  1966	
  1967		window_shift = order_base_2(window_size);
  1968		entries_shift = window_shift - page_shift;
  1969	
  1970		mutex_lock(&dma_win_init_mutex);
  1971	
  1972		ret = -ENODEV;
  1973	
  1974		pdn = pci_dma_find_parent_node(pdev, table_group);
  1975		if (!pdn || !PCI_DN(pdn)) { /* Niether of 32s|64-bit exist! */
  1976			dev_warn(&pdev->dev, "No dma-windows exist for the node %pOF\n", pdn);
  1977			goto out_failed;
  1978		}
  1979		pci = PCI_DN(pdn);
  1980	
  1981		/* If the enable DDW failed for the pdn, dont retry! */
  1982		list_for_each_entry(fpdn, &failed_ddw_pdn_list, list) {
  1983			if (fpdn->pdn == pdn) {
  1984				dev_info(&pdev->dev, "%pOF in failed DDW device list\n", pdn);
  1985				goto out_unlock;
  1986			}
  1987		}
  1988	
  1989		tbl = iommu_pseries_alloc_table(pci->phb->node);
  1990		if (!tbl) {
  1991			dev_dbg(&pdev->dev, "couldn't create new IOMMU table\n");
  1992			goto out_unlock;
  1993		}
  1994	
  1995		if (num == 0) {
  1996			bool direct_mapping;
  1997			/* The request is not for default window? Ensure there is no DDW window already */
  1998			if (!is_default_window_request(table_group, page_shift, window_size)) {
  1999				if (find_existing_ddw(pdn, &pdev->dev.archdata.dma_offset, &len,
  2000						      &direct_mapping)) {
  2001					dev_warn(&pdev->dev, "%pOF: 64-bit window already present.", pdn);
  2002					ret = -EPERM;
  2003					goto out_unlock;
  2004				}
  2005			} else {
  2006				/* Request is for Default window, ensure there is no DDW if there is a
  2007				 * need to reset. reset-pe otherwise removes the DDW also
  2008				 */
  2009				default_prop = of_get_property(pdn, "ibm,dma-window", NULL);
  2010				if (!default_prop) {
  2011					if (find_existing_ddw(pdn, &pdev->dev.archdata.dma_offset, &len,
  2012							      &direct_mapping)) {
  2013						dev_warn(&pdev->dev, "%pOF: Attempt to create window#0 when 64-bit window is present. Preventing the attempt as that would destroy the 64-bit window",
  2014							 pdn);
  2015						ret = -EPERM;
  2016						goto out_unlock;
  2017					}
  2018	
  2019					restore_default_dma_window(pdev, pdn);
  2020	
  2021					default_prop = of_get_property(pdn, "ibm,dma-window", NULL);
  2022					of_parse_dma_window(pdn, default_prop, &liobn, &offset, &size);
  2023					/* Limit the default window size to window_size */
  2024					iommu_table_setparms_common(tbl, pci->phb->bus->number, liobn,
  2025								    offset, 1UL << window_shift,
  2026								    IOMMU_PAGE_SHIFT_4K, NULL,
  2027								    &iommu_table_lpar_multi_ops);
  2028					iommu_init_table(tbl, pci->phb->node, start, end);
  2029	
  2030					table_group->tables[0] = tbl;
  2031	
  2032					mutex_unlock(&dma_win_init_mutex);
  2033	
  2034					goto exit;
  2035				}
  2036			}
  2037		}
  2038	
  2039		ret = of_property_read_u32_array(pdn, "ibm,ddw-applicable",
  2040					&ddw_avail[0], DDW_APPLICABLE_SIZE);
  2041		if (ret) {
  2042			dev_info(&pdev->dev, "ibm,ddw-applicable not found\n");
  2043			goto out_failed;
  2044		}
  2045		ret = -ENODEV;
  2046	
  2047		pr_err("%s: Calling query %pOF\n", __func__, pdn);
  2048		ret = query_ddw(pdev, ddw_avail, &query, pdn);
  2049		if (ret)
  2050			goto out_failed;
  2051		ret = -ENODEV;
  2052	
  2053		len = window_shift;
  2054		if (query.largest_available_block < (1ULL << (len - page_shift))) {
  2055			dev_dbg(&pdev->dev, "can't map window 0x%llx with %llu %llu-sized pages\n",
  2056					1ULL << len, query.largest_available_block,
  2057					1ULL << page_shift);
  2058			ret = -EINVAL; /* Retry with smaller window size */
  2059			goto out_unlock;
  2060		}
  2061	
  2062		if (create_ddw(pdev, ddw_avail, &create, page_shift, len)) {
  2063			pr_err("%s: Create ddw failed %pOF\n", __func__, pdn);
  2064			goto out_failed;
  2065		}
  2066	
  2067		win_addr = ((u64)create.addr_hi << 32) | create.addr_lo;
  2068		win64 = ddw_property_create(DMA64_PROPNAME, create.liobn, win_addr, page_shift, len);
  2069		if (!win64)
  2070			goto remove_window;
  2071	
  2072		ret = of_add_property(pdn, win64);
  2073		if (ret) {
  2074			dev_err(&pdev->dev, "unable to add DMA window property for %pOF: %ld", pdn, ret);
  2075			goto free_property;
  2076		}
  2077		ret = -ENODEV;
  2078	
  2079		window = ddw_list_new_entry(pdn, win64->value);
  2080		if (!window)
  2081			goto remove_property;
  2082	
  2083		window->direct = false;
  2084	
  2085		for (i = 0; i < ARRAY_SIZE(pci->phb->mem_resources); i++) {
  2086			const unsigned long mask = IORESOURCE_MEM_64 | IORESOURCE_MEM;
  2087	
  2088			/* Look for MMIO32 */
  2089			if ((pci->phb->mem_resources[i].flags & mask) == IORESOURCE_MEM) {
  2090				start = pci->phb->mem_resources[i].start;
  2091				end = pci->phb->mem_resources[i].end;
  2092					break;
  2093			}
  2094		}
  2095	
  2096		/* New table for using DDW instead of the default DMA window */
  2097		iommu_table_setparms_common(tbl, pci->phb->bus->number, create.liobn, win_addr,
  2098					    1UL << len, page_shift, NULL, &iommu_table_lpar_multi_ops);
  2099		iommu_init_table(tbl, pci->phb->node, start, end);
  2100	
  2101		pci->table_group->tables[num] = tbl;
  2102		set_iommu_table_base(&pdev->dev, tbl);
  2103		pdev->dev.archdata.dma_offset = win_addr;
  2104	
  2105		spin_lock(&dma_win_list_lock);
  2106		list_add(&window->list, &dma_win_list);
  2107		spin_unlock(&dma_win_list_lock);
  2108	
  2109		mutex_unlock(&dma_win_init_mutex);
  2110	
  2111		goto exit;
  2112	
  2113	remove_property:
  2114		of_remove_property(pdn, win64);
  2115	free_property:
  2116		kfree(win64->name);
  2117		kfree(win64->value);
  2118		kfree(win64);
  2119	remove_window:
  2120		__remove_dma_window(pdn, ddw_avail, create.liobn);
  2121	
  2122	out_failed:
  2123		fpdn = kzalloc(sizeof(*fpdn), GFP_KERNEL);
  2124		if (!fpdn)
  2125			goto out_unlock;
  2126		fpdn->pdn = pdn;
  2127		list_add(&fpdn->list, &failed_ddw_pdn_list);
  2128	
  2129	out_unlock:
  2130		mutex_unlock(&dma_win_init_mutex);
  2131	
  2132		return ret;
  2133	exit:
  2134		/* Allocate the userspace view */
  2135		pseries_tce_iommu_userspace_view_alloc(tbl);
  2136		tbl->it_allocated_size = spapr_tce_get_table_size(page_shift, window_size, levels);
  2137	
  2138		*ptbl = iommu_tce_table_get(tbl);
  2139	
  2140		return 0;
  2141	}
  2142	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

