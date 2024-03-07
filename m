Return-Path: <kvm+bounces-11312-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C45B4875305
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 16:22:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 61BC3B21C2A
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 15:22:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BF7412F379;
	Thu,  7 Mar 2024 15:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LgS+NoHh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0567112DDBA;
	Thu,  7 Mar 2024 15:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709824928; cv=none; b=ff5dyzpFxxBHDBG3gwI0Ixyxe+YAI0za/cj01CGo4wthSA0NidYteCbDIRVGNnOTuc8AKCwtRJscBpqwWcXLIYuI2WoIY8P3zBVEHa4+4yK2KzmVLEUf7KtXLZIrNV2GDjFBZvVs3Z4AHX89LtVPpZkC6N5YXKDwkYx/3yaKoYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709824928; c=relaxed/simple;
	bh=dXXAP6ggtVzzLfF8jgYN0QQav58miECgxTM+SNjFCi0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iHFU6HDA5dT7A9MekrN06TSm3wYDM1zmHjVDkU2VgGJGWsVaOgPxz7+hZk6fSDV0nv6Ebx7SAncD7xde82Tx02z8vB+uIaupzgwpi9kzEYrWC5q1tLa0XWbRK5CAALRW5KgZOAklnKQ7nWftRfXhJ91y/1MFonSZOkr1J6L+XiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LgS+NoHh; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709824925; x=1741360925;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=dXXAP6ggtVzzLfF8jgYN0QQav58miECgxTM+SNjFCi0=;
  b=LgS+NoHhmTAdUkTPv42bZ82p3A7xtyqthiwJvUUeRqd5+yAQ+bHL66O9
   61sH+uvQi+/NSvbhqYwarJk+ZWzAiKAOz2FSlv2mpBVQXX+fJw+AU1qE+
   SguJwcKYZ+r1tjQC9SQmSD9aashEIHBHVA0MEbjxqqefEOVIJOQ54etBW
   Eb9SvjMQhr6Owd07TWqjp+2jDCaOdCntpHII2IcTvNR1BA0b9PEOpf0YL
   KDQzV5HUWTtaDeyq2gX6ZYbNFmRc11fTG7oTcNd6haA4/9b945SGHi2RZ
   k0v6tqExpoutvdXex3qZB9Ge0gOloYxT/p7lI4IOudD7CUwOevjByh0I6
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11006"; a="4617588"
X-IronPort-AV: E=Sophos;i="6.07,211,1708416000"; 
   d="scan'208";a="4617588"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2024 07:22:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,211,1708416000"; 
   d="scan'208";a="14801134"
Received: from lkp-server01.sh.intel.com (HELO b21307750695) ([10.239.97.150])
  by orviesa003.jf.intel.com with ESMTP; 07 Mar 2024 07:22:01 -0800
Received: from kbuild by b21307750695 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1riFZG-0005Hr-2x;
	Thu, 07 Mar 2024 15:21:58 +0000
Date: Thu, 7 Mar 2024 23:21:47 +0800
From: kernel test robot <lkp@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	kvm@vger.kernel.org, eric.auger@redhat.com, clg@redhat.com,
	reinette.chatre@intel.com, linux-kernel@vger.kernel.org,
	kevin.tian@intel.com, diana.craciun@oss.nxp.com
Subject: Re: [PATCH 7/7] vfio/fsl-mc: Block calling interrupt handler without
 trigger
Message-ID: <202403072356.jlxR3E5Q-lkp@intel.com>
References: <20240306211445.1856768-8-alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240306211445.1856768-8-alex.williamson@redhat.com>

Hi Alex,

kernel test robot noticed the following build warnings:

[auto build test WARNING on awilliam-vfio/next]
[also build test WARNING on linus/master v6.8-rc7 next-20240307]
[cannot apply to awilliam-vfio/for-linus]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Alex-Williamson/vfio-pci-Disable-auto-enable-of-exclusive-INTx-IRQ/20240307-051931
base:   https://github.com/awilliam/linux-vfio.git next
patch link:    https://lore.kernel.org/r/20240306211445.1856768-8-alex.williamson%40redhat.com
patch subject: [PATCH 7/7] vfio/fsl-mc: Block calling interrupt handler without trigger
config: x86_64-allyesconfig (https://download.01.org/0day-ci/archive/20240307/202403072356.jlxR3E5Q-lkp@intel.com/config)
compiler: clang version 17.0.6 (https://github.com/llvm/llvm-project 6009708b4367171ccdbf4b5905cb6a803753fe18)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240307/202403072356.jlxR3E5Q-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202403072356.jlxR3E5Q-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c:111:11: warning: variable 'hwirq' set but not used [-Wunused-but-set-variable]
     111 |         int ret, hwirq;
         |                  ^
   1 warning generated.


vim +/hwirq +111 drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c

cc0ee20bd96971 Diana Craciun   2020-10-05  104  
2e0d29561f593a Diana Craciun   2020-10-05  105  static int vfio_fsl_mc_set_irq_trigger(struct vfio_fsl_mc_device *vdev,
2e0d29561f593a Diana Craciun   2020-10-05  106  				       unsigned int index, unsigned int start,
2e0d29561f593a Diana Craciun   2020-10-05  107  				       unsigned int count, u32 flags,
2e0d29561f593a Diana Craciun   2020-10-05  108  				       void *data)
2e0d29561f593a Diana Craciun   2020-10-05  109  {
cc0ee20bd96971 Diana Craciun   2020-10-05  110  	struct fsl_mc_device *mc_dev = vdev->mc_dev;
cc0ee20bd96971 Diana Craciun   2020-10-05 @111  	int ret, hwirq;
cc0ee20bd96971 Diana Craciun   2020-10-05  112  	struct vfio_fsl_mc_irq *irq;
cc0ee20bd96971 Diana Craciun   2020-10-05  113  	struct device *cont_dev = fsl_mc_cont_dev(&mc_dev->dev);
cc0ee20bd96971 Diana Craciun   2020-10-05  114  	struct fsl_mc_device *mc_cont = to_fsl_mc_device(cont_dev);
cc0ee20bd96971 Diana Craciun   2020-10-05  115  
159246378d8483 Diana Craciun   2020-10-15  116  	if (!count && (flags & VFIO_IRQ_SET_DATA_NONE))
159246378d8483 Diana Craciun   2020-10-15  117  		return vfio_set_trigger(vdev, index, -1);
159246378d8483 Diana Craciun   2020-10-15  118  
cc0ee20bd96971 Diana Craciun   2020-10-05  119  	if (start != 0 || count != 1)
2e0d29561f593a Diana Craciun   2020-10-05  120  		return -EINVAL;
cc0ee20bd96971 Diana Craciun   2020-10-05  121  
da119f387e9464 Jason Gunthorpe 2021-08-05  122  	mutex_lock(&vdev->vdev.dev_set->lock);
cc0ee20bd96971 Diana Craciun   2020-10-05  123  	ret = fsl_mc_populate_irq_pool(mc_cont,
cc0ee20bd96971 Diana Craciun   2020-10-05  124  			FSL_MC_IRQ_POOL_MAX_TOTAL_IRQS);
cc0ee20bd96971 Diana Craciun   2020-10-05  125  	if (ret)
cc0ee20bd96971 Diana Craciun   2020-10-05  126  		goto unlock;
cc0ee20bd96971 Diana Craciun   2020-10-05  127  
cc0ee20bd96971 Diana Craciun   2020-10-05  128  	ret = vfio_fsl_mc_irqs_allocate(vdev);
cc0ee20bd96971 Diana Craciun   2020-10-05  129  	if (ret)
cc0ee20bd96971 Diana Craciun   2020-10-05  130  		goto unlock;
da119f387e9464 Jason Gunthorpe 2021-08-05  131  	mutex_unlock(&vdev->vdev.dev_set->lock);
cc0ee20bd96971 Diana Craciun   2020-10-05  132  
cc0ee20bd96971 Diana Craciun   2020-10-05  133  	if (flags & VFIO_IRQ_SET_DATA_EVENTFD) {
cc0ee20bd96971 Diana Craciun   2020-10-05  134  		s32 fd = *(s32 *)data;
cc0ee20bd96971 Diana Craciun   2020-10-05  135  
cc0ee20bd96971 Diana Craciun   2020-10-05  136  		return vfio_set_trigger(vdev, index, fd);
cc0ee20bd96971 Diana Craciun   2020-10-05  137  	}
cc0ee20bd96971 Diana Craciun   2020-10-05  138  
d86a6d47bcc6b4 Thomas Gleixner 2021-12-10  139  	hwirq = vdev->mc_dev->irqs[index]->virq;
cc0ee20bd96971 Diana Craciun   2020-10-05  140  
cc0ee20bd96971 Diana Craciun   2020-10-05  141  	irq = &vdev->mc_irqs[index];
cc0ee20bd96971 Diana Craciun   2020-10-05  142  
cc0ee20bd96971 Diana Craciun   2020-10-05  143  	if (flags & VFIO_IRQ_SET_DATA_NONE) {
dce72fdf5c6be9 Alex Williamson 2024-03-06  144  		if (irq->trigger)
dce72fdf5c6be9 Alex Williamson 2024-03-06  145  			eventfd_signal(irq->trigger);
cc0ee20bd96971 Diana Craciun   2020-10-05  146  
cc0ee20bd96971 Diana Craciun   2020-10-05  147  	} else if (flags & VFIO_IRQ_SET_DATA_BOOL) {
cc0ee20bd96971 Diana Craciun   2020-10-05  148  		u8 trigger = *(u8 *)data;
cc0ee20bd96971 Diana Craciun   2020-10-05  149  
dce72fdf5c6be9 Alex Williamson 2024-03-06  150  		if (trigger && irq->trigger)
dce72fdf5c6be9 Alex Williamson 2024-03-06  151  			eventfd_signal(irq->trigger);
cc0ee20bd96971 Diana Craciun   2020-10-05  152  	}
cc0ee20bd96971 Diana Craciun   2020-10-05  153  
cc0ee20bd96971 Diana Craciun   2020-10-05  154  	return 0;
cc0ee20bd96971 Diana Craciun   2020-10-05  155  
cc0ee20bd96971 Diana Craciun   2020-10-05  156  unlock:
da119f387e9464 Jason Gunthorpe 2021-08-05  157  	mutex_unlock(&vdev->vdev.dev_set->lock);
cc0ee20bd96971 Diana Craciun   2020-10-05  158  	return ret;
cc0ee20bd96971 Diana Craciun   2020-10-05  159  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

