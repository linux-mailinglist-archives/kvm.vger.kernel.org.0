Return-Path: <kvm+bounces-63663-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 71827C6C840
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 04:05:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sin.lore.kernel.org (Postfix) with ESMTPS id 50B122CD51
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 03:04:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C68A82D8DB9;
	Wed, 19 Nov 2025 03:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NL5GiA/j"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 815442D9EF3;
	Wed, 19 Nov 2025 03:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763521436; cv=none; b=jU/dlClPQ4uX0rXwXFsoak7BwOWIgcb+TvPhfM34zNKhKh0J505CzrTydKMdfC49Mh4UP1gy/UwFF5dvZaEpciMX7MlLqAff1sZiYKHhVMwvCE4caCZH69nfTGy7GWC2M0FM5nXyOAuERwlgivNVDnSLhrTFHL/QoIaP4NF8AwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763521436; c=relaxed/simple;
	bh=pXsZhuxxB+kI3KzL5qT6v5f2HxideVTv+RifgqSeoW0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=blfapRaS/wWy1XwHOGUl/XYl1VdnKoSe1pj6s2pWIuZueLxl4jFFDgwYNt/rLPKYT/TzlxN2qGNkPnvV7ubik9u5GHw6aKsaZc4ESUbGnMMQihRYNGuXKhWCLnbROqicy5poXD/yE9DBeKxz65NF9i590x2sInlcrPwjDz9zuos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NL5GiA/j; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763521435; x=1795057435;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=pXsZhuxxB+kI3KzL5qT6v5f2HxideVTv+RifgqSeoW0=;
  b=NL5GiA/jL0dBodDOKBDXEqb7M3ZohDxuUgjSevz8Sq+qzrPnG72J8Q6N
   4Tl6RZn5HMDHJQsifZNnJdGaod2EWnR5e2EqiK8iKPGWwklxe7vcY0apy
   QcHYKTTMo+xV43UwBNlUAHgNcFK2eLpbLKRpeZTq5b6EQH2VeVyB4KfEW
   3pvpRpenGXxc/z1K54GYduFnAfdnvcA7ELCnLBWWDV20JO6E6ND2Gfemc
   l5pyAPQnNfJK4NQEn+ePPKm4D9IDC4uFZNPp63CE5PeceS7OOX2rVB0s7
   hO5J28RldvW9ZGURTHvu872O4qQxBq8jhy3XxdYZa7B0BX7mp3c9fAf+c
   Q==;
X-CSE-ConnectionGUID: MQBX9xmkSv2JwnC4MjfkNA==
X-CSE-MsgGUID: WISKrYunTmaKvLGKeu6Lbg==
X-IronPort-AV: E=McAfee;i="6800,10657,11617"; a="83181392"
X-IronPort-AV: E=Sophos;i="6.19,315,1754982000"; 
   d="scan'208";a="83181392"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2025 19:03:54 -0800
X-CSE-ConnectionGUID: svX445uPT3aJVISNNc1eYg==
X-CSE-MsgGUID: ux192vFhRle5ZCI9piTKCA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,315,1754982000"; 
   d="scan'208";a="190200915"
Received: from lkp-server01.sh.intel.com (HELO adf6d29aa8d9) ([10.239.97.150])
  by orviesa010.jf.intel.com with ESMTP; 18 Nov 2025 19:03:48 -0800
Received: from kbuild by adf6d29aa8d9 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vLYTy-0002Nn-09;
	Wed, 19 Nov 2025 03:03:46 +0000
Date: Wed, 19 Nov 2025 11:03:33 +0800
From: kernel test robot <lkp@intel.com>
To: Nicolin Chen <nicolinc@nvidia.com>, robin.murphy@arm.com,
	joro@8bytes.org, afael@kernel.org, bhelgaas@google.com,
	alex@shazbot.org, jgg@nvidia.com, kevin.tian@intel.com
Cc: oe-kbuild-all@lists.linux.dev, will@kernel.org, lenb@kernel.org,
	baolu.lu@linux.intel.com, linux-arm-kernel@lists.infradead.org,
	iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
	kvm@vger.kernel.org, patches@lists.linux.dev,
	pjaroszynski@nvidia.com, vsethi@nvidia.com, helgaas@kernel.org,
	etzhao1900@gmail.com
Subject: Re: [PATCH v6 5/5] PCI: Suspend iommu function prior to resetting a
 device
Message-ID: <202511191219.qIkZ1n2P-lkp@intel.com>
References: <9f6caaedc278fe057aacb813d94f44a93d8cab3c.1763512374.git.nicolinc@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9f6caaedc278fe057aacb813d94f44a93d8cab3c.1763512374.git.nicolinc@nvidia.com>

Hi Nicolin,

kernel test robot noticed the following build errors:

[auto build test ERROR on next-20251118]
[cannot apply to pci/next pci/for-linus awilliam-vfio/next awilliam-vfio/for-linus rafael-pm/linux-next rafael-pm/bleeding-edge linus/master v6.18-rc6 v6.18-rc5 v6.18-rc4 v6.18-rc6]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Nicolin-Chen/iommu-Lock-group-mutex-in-iommu_deferred_attach/20251119-085721
base:   next-20251118
patch link:    https://lore.kernel.org/r/9f6caaedc278fe057aacb813d94f44a93d8cab3c.1763512374.git.nicolinc%40nvidia.com
patch subject: [PATCH v6 5/5] PCI: Suspend iommu function prior to resetting a device
config: alpha-allnoconfig (https://download.01.org/0day-ci/archive/20251119/202511191219.qIkZ1n2P-lkp@intel.com/config)
compiler: alpha-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251119/202511191219.qIkZ1n2P-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511191219.qIkZ1n2P-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/pci/pci.c: In function 'pcie_flr':
>> drivers/pci/pci.c:4341:43: error: passing argument 1 of 'pci_dev_reset_iommu_prepare' from incompatible pointer type [-Wincompatible-pointer-types]
    4341 |         ret = pci_dev_reset_iommu_prepare(dev);
         |                                           ^~~
         |                                           |
         |                                           struct pci_dev *
   In file included from drivers/pci/pci.c:16:
   include/linux/iommu.h:1519:62: note: expected 'struct device *' but argument is of type 'struct pci_dev *'
    1519 | static inline int pci_dev_reset_iommu_prepare(struct device *dev)
         |                                               ~~~~~~~~~~~~~~~^~~
>> drivers/pci/pci.c:4361:34: error: passing argument 1 of 'pci_dev_reset_iommu_done' from incompatible pointer type [-Wincompatible-pointer-types]
    4361 |         pci_dev_reset_iommu_done(dev);
         |                                  ^~~
         |                                  |
         |                                  struct pci_dev *
   include/linux/iommu.h:1524:60: note: expected 'struct device *' but argument is of type 'struct pci_dev *'
    1524 | static inline void pci_dev_reset_iommu_done(struct device *dev)
         |                                             ~~~~~~~~~~~~~~~^~~
   drivers/pci/pci.c: In function 'pci_af_flr':
   drivers/pci/pci.c:4418:43: error: passing argument 1 of 'pci_dev_reset_iommu_prepare' from incompatible pointer type [-Wincompatible-pointer-types]
    4418 |         ret = pci_dev_reset_iommu_prepare(dev);
         |                                           ^~~
         |                                           |
         |                                           struct pci_dev *
   include/linux/iommu.h:1519:62: note: expected 'struct device *' but argument is of type 'struct pci_dev *'
    1519 | static inline int pci_dev_reset_iommu_prepare(struct device *dev)
         |                                               ~~~~~~~~~~~~~~~^~~
   drivers/pci/pci.c:4439:34: error: passing argument 1 of 'pci_dev_reset_iommu_done' from incompatible pointer type [-Wincompatible-pointer-types]
    4439 |         pci_dev_reset_iommu_done(dev);
         |                                  ^~~
         |                                  |
         |                                  struct pci_dev *
   include/linux/iommu.h:1524:60: note: expected 'struct device *' but argument is of type 'struct pci_dev *'
    1524 | static inline void pci_dev_reset_iommu_done(struct device *dev)
         |                                             ~~~~~~~~~~~~~~~^~~
   drivers/pci/pci.c: In function 'pci_pm_reset':
   drivers/pci/pci.c:4476:43: error: passing argument 1 of 'pci_dev_reset_iommu_prepare' from incompatible pointer type [-Wincompatible-pointer-types]
    4476 |         ret = pci_dev_reset_iommu_prepare(dev);
         |                                           ^~~
         |                                           |
         |                                           struct pci_dev *
   include/linux/iommu.h:1519:62: note: expected 'struct device *' but argument is of type 'struct pci_dev *'
    1519 | static inline int pci_dev_reset_iommu_prepare(struct device *dev)
         |                                               ~~~~~~~~~~~~~~~^~~
   drivers/pci/pci.c:4493:34: error: passing argument 1 of 'pci_dev_reset_iommu_done' from incompatible pointer type [-Wincompatible-pointer-types]
    4493 |         pci_dev_reset_iommu_done(dev);
         |                                  ^~~
         |                                  |
         |                                  struct pci_dev *
   include/linux/iommu.h:1524:60: note: expected 'struct device *' but argument is of type 'struct pci_dev *'
    1524 | static inline void pci_dev_reset_iommu_done(struct device *dev)
         |                                             ~~~~~~~~~~~~~~~^~~
   drivers/pci/pci.c: In function 'pci_reset_bus_function':
   drivers/pci/pci.c:4922:42: error: passing argument 1 of 'pci_dev_reset_iommu_prepare' from incompatible pointer type [-Wincompatible-pointer-types]
    4922 |         rc = pci_dev_reset_iommu_prepare(dev);
         |                                          ^~~
         |                                          |
         |                                          struct pci_dev *
   include/linux/iommu.h:1519:62: note: expected 'struct device *' but argument is of type 'struct pci_dev *'
    1519 | static inline int pci_dev_reset_iommu_prepare(struct device *dev)
         |                                               ~~~~~~~~~~~~~~~^~~
   drivers/pci/pci.c:4934:34: error: passing argument 1 of 'pci_dev_reset_iommu_done' from incompatible pointer type [-Wincompatible-pointer-types]
    4934 |         pci_dev_reset_iommu_done(dev);
         |                                  ^~~
         |                                  |
         |                                  struct pci_dev *
   include/linux/iommu.h:1524:60: note: expected 'struct device *' but argument is of type 'struct pci_dev *'
    1524 | static inline void pci_dev_reset_iommu_done(struct device *dev)
         |                                             ~~~~~~~~~~~~~~~^~~
   drivers/pci/pci.c: In function 'cxl_reset_bus_function':
   drivers/pci/pci.c:4959:42: error: passing argument 1 of 'pci_dev_reset_iommu_prepare' from incompatible pointer type [-Wincompatible-pointer-types]
    4959 |         rc = pci_dev_reset_iommu_prepare(dev);
         |                                          ^~~
         |                                          |
         |                                          struct pci_dev *
   include/linux/iommu.h:1519:62: note: expected 'struct device *' but argument is of type 'struct pci_dev *'
    1519 | static inline int pci_dev_reset_iommu_prepare(struct device *dev)
         |                                               ~~~~~~~~~~~~~~~^~~
   drivers/pci/pci.c:4979:34: error: passing argument 1 of 'pci_dev_reset_iommu_done' from incompatible pointer type [-Wincompatible-pointer-types]
    4979 |         pci_dev_reset_iommu_done(dev);
         |                                  ^~~
         |                                  |
         |                                  struct pci_dev *
   include/linux/iommu.h:1524:60: note: expected 'struct device *' but argument is of type 'struct pci_dev *'
    1524 | static inline void pci_dev_reset_iommu_done(struct device *dev)
         |                                             ~~~~~~~~~~~~~~~^~~
--
   drivers/pci/quirks.c: In function '__pci_dev_specific_reset':
>> drivers/pci/quirks.c:4237:43: error: passing argument 1 of 'pci_dev_reset_iommu_prepare' from incompatible pointer type [-Wincompatible-pointer-types]
    4237 |         ret = pci_dev_reset_iommu_prepare(dev);
         |                                           ^~~
         |                                           |
         |                                           struct pci_dev *
   In file included from drivers/pci/quirks.c:24:
   include/linux/iommu.h:1519:62: note: expected 'struct device *' but argument is of type 'struct pci_dev *'
    1519 | static inline int pci_dev_reset_iommu_prepare(struct device *dev)
         |                                               ~~~~~~~~~~~~~~~^~~
>> drivers/pci/quirks.c:4244:34: error: passing argument 1 of 'pci_dev_reset_iommu_done' from incompatible pointer type [-Wincompatible-pointer-types]
    4244 |         pci_dev_reset_iommu_done(dev);
         |                                  ^~~
         |                                  |
         |                                  struct pci_dev *
   include/linux/iommu.h:1524:60: note: expected 'struct device *' but argument is of type 'struct pci_dev *'
    1524 | static inline void pci_dev_reset_iommu_done(struct device *dev)
         |                                             ~~~~~~~~~~~~~~~^~~


vim +/pci_dev_reset_iommu_prepare +4341 drivers/pci/pci.c

  4325	
  4326	/**
  4327	 * pcie_flr - initiate a PCIe function level reset
  4328	 * @dev: device to reset
  4329	 *
  4330	 * Initiate a function level reset unconditionally on @dev without
  4331	 * checking any flags and DEVCAP
  4332	 */
  4333	int pcie_flr(struct pci_dev *dev)
  4334	{
  4335		int ret;
  4336	
  4337		if (!pci_wait_for_pending_transaction(dev))
  4338			pci_err(dev, "timed out waiting for pending transaction; performing function level reset anyway\n");
  4339	
  4340		/* Have to call it after waiting for pending DMA transaction */
> 4341		ret = pci_dev_reset_iommu_prepare(dev);
  4342		if (ret) {
  4343			pci_err(dev, "failed to stop IOMMU for a PCI reset: %d\n", ret);
  4344			return ret;
  4345		}
  4346	
  4347		pcie_capability_set_word(dev, PCI_EXP_DEVCTL, PCI_EXP_DEVCTL_BCR_FLR);
  4348	
  4349		if (dev->imm_ready)
  4350			goto done;
  4351	
  4352		/*
  4353		 * Per PCIe r4.0, sec 6.6.2, a device must complete an FLR within
  4354		 * 100ms, but may silently discard requests while the FLR is in
  4355		 * progress.  Wait 100ms before trying to access the device.
  4356		 */
  4357		msleep(100);
  4358	
  4359		ret = pci_dev_wait(dev, "FLR", PCIE_RESET_READY_POLL_MS);
  4360	done:
> 4361		pci_dev_reset_iommu_done(dev);
  4362		return ret;
  4363	}
  4364	EXPORT_SYMBOL_GPL(pcie_flr);
  4365	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

