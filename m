Return-Path: <kvm+bounces-54638-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E3986B25AC6
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 07:23:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AAE3B1B65F46
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 05:23:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87F13221703;
	Thu, 14 Aug 2025 05:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PTX6FDuZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A7D2165F3;
	Thu, 14 Aug 2025 05:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755148975; cv=none; b=Q1NzCc5Tm442xPq5GXB/c9sUknm9NLiahhLZyzoRJFYoagfBV/Hx0DGwYHFLvrdDcvuQrqLAIwVj+xgOKDmA7ER1Pzv+SC38R8LSEZ/ZvXnJwHEGoRMLeCHW5tUl/qFXfGe/JXirylJJcJBWl8AJ/tNjVRbDThUZD6ED9n3nYaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755148975; c=relaxed/simple;
	bh=AZhFvfAsgfnk60hqg/m2YLJo/VHTNiBHUmkW/MGd2Ww=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qjPCQl557ZNsowq7va/kQf/GnN3GlZ4CY8Ke6j+ZqX03r7MiM9UyyaXmvOdcl0FpZsJKr3z0dBKxZZb42qw7tAm8a9dkEPNW26S6D1lNILxM8tya+5AlqOEyMJROwRwbaahp5wxjpy+zRBSWFnm/yNetqUsGQYvYMQ6mmwoTYW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PTX6FDuZ; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755148974; x=1786684974;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=AZhFvfAsgfnk60hqg/m2YLJo/VHTNiBHUmkW/MGd2Ww=;
  b=PTX6FDuZL2Aq2eRj6XpiZ+KWxB9ZjkXtTsqt0uWiroMlHjSN8TNdzcn7
   M6ddKcx5LN4Prvtjnc8wPCJmWMVPeH3yQH8LfNDeJrDXLdgaVW6BDmJCv
   oZZTJ2VHqoXN+YRkTcMhrKkxjPMqnEODLei81IoRV3Qce5azmOwbKHLC6
   x4UKTmrIdHGJtdHLEXXd3GuMgHZf0Gyl4LxG1mT7Yu1grxsEwxVrx9lm3
   2RgsWtcZc9trDQ8kZmJFTE0JQ2mndpaml7gNumAgej9NtyTu1h+Wv5VmD
   7cgC1ezqRiO2eUJAfIxH/CxoZnspT2/SPImI24erL4IsmUQOSKaM8jmPf
   g==;
X-CSE-ConnectionGUID: f387LcVoTT+lob3hm33SrA==
X-CSE-MsgGUID: 8JfAhBj3R76SlAMWk9BmlA==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="57410558"
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="57410558"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2025 22:22:53 -0700
X-CSE-ConnectionGUID: phLfqAzSQjSj1O4tTwJmcQ==
X-CSE-MsgGUID: ZkuBPprRRTKuzkTRFePUQA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="197521485"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by fmviesa001.fm.intel.com with ESMTP; 13 Aug 2025 22:22:50 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1umQQK-000Abc-2C;
	Thu, 14 Aug 2025 05:22:48 +0000
Date: Thu, 14 Aug 2025 13:22:27 +0800
From: kernel test robot <lkp@intel.com>
To: Farhan Ali <alifm@linux.ibm.com>, linux-s390@vger.kernel.org,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	schnelle@linux.ibm.com, mjrosato@linux.ibm.com, alifm@linux.ibm.com,
	alex.williamson@redhat.com
Subject: Re: [PATCH v1 5/6] vfio-pci/zdev: Perform platform specific function
 reset for zPCI
Message-ID: <202508141314.OUnmuib7-lkp@intel.com>
References: <20250813170821.1115-6-alifm@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250813170821.1115-6-alifm@linux.ibm.com>

Hi Farhan,

kernel test robot noticed the following build warnings:

[auto build test WARNING on awilliam-vfio/next]
[also build test WARNING on s390/features linus/master v6.17-rc1 next-20250813]
[cannot apply to kvms390/next awilliam-vfio/for-linus]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Farhan-Ali/s390-pci-Restore-airq-unconditionally-for-the-zPCI-device/20250814-012243
base:   https://github.com/awilliam/linux-vfio.git next
patch link:    https://lore.kernel.org/r/20250813170821.1115-6-alifm%40linux.ibm.com
patch subject: [PATCH v1 5/6] vfio-pci/zdev: Perform platform specific function reset for zPCI
config: i386-randconfig-005-20250814 (https://download.01.org/0day-ci/archive/20250814/202508141314.OUnmuib7-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250814/202508141314.OUnmuib7-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508141314.OUnmuib7-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from drivers/vfio/pci/vfio_pci_intrs.c:23:
>> drivers/vfio/pci/vfio_pci_priv.h:104:5: warning: no previous prototype for function 'vfio_pci_zdev_reset' [-Wmissing-prototypes]
     104 | int vfio_pci_zdev_reset(struct vfio_pci_core_device *vdev)
         |     ^
   drivers/vfio/pci/vfio_pci_priv.h:104:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
     104 | int vfio_pci_zdev_reset(struct vfio_pci_core_device *vdev)
         | ^
         | static 
   1 warning generated.


vim +/vfio_pci_zdev_reset +104 drivers/vfio/pci/vfio_pci_priv.h

   101	
   102	static inline void vfio_pci_zdev_close_device(struct vfio_pci_core_device *vdev)
   103	{}
 > 104	int vfio_pci_zdev_reset(struct vfio_pci_core_device *vdev)
   105	{
   106		return -ENODEV;
   107	}
   108	#endif
   109	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

