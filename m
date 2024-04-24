Return-Path: <kvm+bounces-15813-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 544A78B0D27
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 16:50:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 92B2BB232D9
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 14:50:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF1F915ECEB;
	Wed, 24 Apr 2024 14:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="c4IESvIJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE2A715E5BE
	for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 14:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713970221; cv=none; b=NyLWALoSq1e23b/ZzS90iux3noQTkOFyUuZC6qAbXsDuZUL+GM08x0sqBY9OlAKXSZ/SNbkgK5iQ6IwHVqqfKuoASKG1nuGPl6ih+1zh7AhLgvr0GCN9LUHHY5vgls1O8Odfyw++CbUtmICGBwl++dB5CiQHPdgG7/ffBpwWp28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713970221; c=relaxed/simple;
	bh=Na03EZ4M0BoY2aVd84qx13LApk0vDLfNnDJxd2Jk/2M=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=G5xc004XU3OxFfOTYJK4tQdfZkYNgS10Absh+CFylcu8IcDhjkCej4plnx9sG7QIVgj9QOMgokyjZrjCcinlfZmmsPKjrKbZqu+0Rc0iAZpdwY1frdYQgOdrlks3xN8EuVQOPtxHHBhFbONuPalkRcSY+sWjByy/bGaV0i3kRp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=c4IESvIJ; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713970220; x=1745506220;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=Na03EZ4M0BoY2aVd84qx13LApk0vDLfNnDJxd2Jk/2M=;
  b=c4IESvIJT1EhxWQ+9edUyCJxrNZ976rqfscXURZCg43Kz4IA1q9P3XeE
   Byy5Gfp8zlxU19ZNMvB5ey6mocO35lmjS7VRKPI2PrUhkXSqBgqum/qtm
   N/ay2uJ1rWVclR6+xJ9RufVpySz2M+BH607t1W7306VvdKtSblqtL7IrY
   j0zhZb7u635dn+PuOzpekjklqskiqiP+q1xeMiPdN/Nh0BOVJzynBXJOZ
   IZ9EUPzpIlV3kEEzsyPAnEwoQyH38t9B2l3vClH5uuGXQdi+gkPKJjlsW
   y7AreA3uZINccvcNKUZr4m9rcAbezD7Znn7RZLGSx3UcpPMFSnVs67l9u
   w==;
X-CSE-ConnectionGUID: +X4vxFT7REmDJWUC2W9mmw==
X-CSE-MsgGUID: QIlXiPSwRzasmYNC2nZjvw==
X-IronPort-AV: E=McAfee;i="6600,9927,11054"; a="9715867"
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="9715867"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 07:50:19 -0700
X-CSE-ConnectionGUID: 8O2CM2aaTPC5pLDBBvqOpg==
X-CSE-MsgGUID: E0EwNkkBRIeLeD3IakOCBQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="62194456"
Received: from lkp-server01.sh.intel.com (HELO e434dd42e5a1) ([10.239.97.150])
  by orviesa001.jf.intel.com with ESMTP; 24 Apr 2024 07:50:18 -0700
Received: from kbuild by e434dd42e5a1 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1rzdwt-0001Lk-1t;
	Wed, 24 Apr 2024 14:50:15 +0000
Date: Wed, 24 Apr 2024 22:49:35 +0800
From: kernel test robot <lkp@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: oe-kbuild-all@lists.linux.dev, kvm@vger.kernel.org
Subject: [awilliam-vfio:vfio-address-space 4/4]
 drivers/vfio/pci/vfio_pci_core.c:1693:undefined reference to
 `vmf_insert_pfn_pud'
Message-ID: <202404242226.o8OcEO59-lkp@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://github.com/awilliam/linux-vfio.git vfio-address-space
head:   ec6c970f8374f91df0ebfe180cd388ba31187942
commit: ec6c970f8374f91df0ebfe180cd388ba31187942 [4/4] vfio/pci: Make use of huge_fault
config: arm64-defconfig (https://download.01.org/0day-ci/archive/20240424/202404242226.o8OcEO59-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240424/202404242226.o8OcEO59-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202404242226.o8OcEO59-lkp@intel.com/

All errors (new ones prefixed by >>):

   aarch64-linux-ld: Unexpected GOT/PLT entries detected!
   aarch64-linux-ld: Unexpected run-time procedure linkages detected!
   aarch64-linux-ld: drivers/vfio/pci/vfio_pci_core.o: in function `vfio_pci_mmap_huge_fault':
>> drivers/vfio/pci/vfio_pci_core.c:1693:(.text+0xc40): undefined reference to `vmf_insert_pfn_pud'


vim +1693 drivers/vfio/pci/vfio_pci_core.c

  1666	
  1667	static vm_fault_t vfio_pci_mmap_huge_fault(struct vm_fault *vmf, unsigned int order)
  1668	{
  1669		struct vm_area_struct *vma = vmf->vma;
  1670		struct vfio_pci_core_device *vdev = vma->vm_private_data;
  1671		unsigned long pfn, pgoff = vmf->pgoff - vma->vm_pgoff;
  1672		vm_fault_t ret = VM_FAULT_FALLBACK;
  1673	
  1674		if (vmf->address & ((PAGE_SIZE << order) - 1) ||
  1675		    vmf->address + (PAGE_SIZE << order) > vma->vm_end)
  1676			return ret;
  1677	
  1678		if (vma_to_pfn(vma, &pfn))
  1679			return ret;
  1680	
  1681		down_read(&vdev->memory_lock);
  1682	
  1683		if (vdev->pm_runtime_engaged || !__vfio_pci_memory_enabled(vdev)) {
  1684			ret = VM_FAULT_SIGBUS;
  1685			goto out_disabled;
  1686		}
  1687	
  1688		if (order == 0)
  1689			ret = vmf_insert_pfn(vma, vmf->address, pfn + pgoff);
  1690		else if (order == PMD_ORDER)
  1691			ret = vmf_insert_pfn_pmd(vmf, __pfn_to_pfn_t(pfn + pgoff, PFN_DEV), false);
  1692		else if (order == PUD_ORDER)
> 1693			ret = vmf_insert_pfn_pud(vmf, __pfn_to_pfn_t(pfn + pgoff, PFN_DEV), false);
  1694	
  1695	out_disabled:
  1696		up_read(&vdev->memory_lock);
  1697	
  1698		return ret;
  1699	}
  1700	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

