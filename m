Return-Path: <kvm+bounces-71018-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gKfFOsdYjmn2BgEAu9opvQ
	(envelope-from <kvm+bounces-71018-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 23:48:39 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 98D4B131982
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 23:48:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8B002311CF6F
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 22:47:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AA0C2F851;
	Thu, 12 Feb 2026 22:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d2u+LiYo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8C3728689A;
	Thu, 12 Feb 2026 22:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770936453; cv=none; b=E77NepO0mFXbp82P+RZ5fajW7MS8hLQ2hB+2jpZNcA9UWr81Mevdej24Y0ssrILbzTH4acFoq/ts7u15HABXAlhK4Zws+0KQdCur9zGcMFkvgtH//MH8JUQcfMtIGe60ZodJ5AYHm7rnNH2Qb5mMiq+UWbi6qTRJIs+sIf+znrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770936453; c=relaxed/simple;
	bh=M7PMHZjVueAtj3/cl/36hF2po/Ey4rlgtmj04Sa2ebU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C4QNxxIQZuDQKJGIA4i4QDe9dse/YcpGzuGZZEL8H1TVxnYTQOidaKeY3d41NYqzQ2TctQ86lqZ21nPkRgoE6joTHFBF5nptIfy5il6rQJ+TlPGq0NkpbL+y67oJPAgl8GCoFukLnLl0u8mWsYb4qn8LdsvSxI9DSoMYRotwwxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d2u+LiYo; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770936452; x=1802472452;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=M7PMHZjVueAtj3/cl/36hF2po/Ey4rlgtmj04Sa2ebU=;
  b=d2u+LiYoAzaRI+S85Y8RZLKGyuzdMmDX4/Znb5+qPtrhES/3ZTpfvMVL
   rLd46lnwa45irpdbCh/UqXy9nG7rkl8IIJv3DP9xmN1J4hecux35x6OZn
   t54Gp2ewOPsr4rEu/ZRlYJzPHOQOpAzGyqMHFKt12h0a3iYqY7Qx25iNe
   06Hp3r8Hzu913s19lakFfHd1UX6t3juXfuVQQa5tHaXdsVB1vBGioSN+E
   5JuTEFibBuIaHPfn4bShTv8loykCKLYRLyl1bzmoZy7q+Zj0tRkF38UNL
   DE/sHrXnUI6HNDrdlUu6aOXBzb+vcaFpkw1dm/Bkg6t+d5xnvi/7OrQNy
   g==;
X-CSE-ConnectionGUID: smKOVkxvSCCY6pjdKq+3Jw==
X-CSE-MsgGUID: 9bPE79p/RgawGqjStMRwBw==
X-IronPort-AV: E=McAfee;i="6800,10657,11699"; a="72193920"
X-IronPort-AV: E=Sophos;i="6.21,287,1763452800"; 
   d="scan'208";a="72193920"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 14:47:31 -0800
X-CSE-ConnectionGUID: bfMEofrGRpSi7S8SFq4CDw==
X-CSE-MsgGUID: bk0b+8EGTPCdMzaG63FrzQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,287,1763452800"; 
   d="scan'208";a="211954714"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa010.fm.intel.com with ESMTP; 12 Feb 2026 14:47:26 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vqfT2-00000000tva-2Oap;
	Thu, 12 Feb 2026 22:47:24 +0000
Date: Fri, 13 Feb 2026 06:46:58 +0800
From: kernel test robot <lkp@intel.com>
To: Julian Ruess <julianr@linux.ibm.com>, schnelle@linux.ibm.com,
	wintera@linux.ibm.com, ts@linux.ibm.com, oberpar@linux.ibm.com,
	gbayer@linux.ibm.com, Alex Williamson <alex@shazbot.org>,
	Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	mjrosato@linux.ibm.com, alifm@linux.ibm.com, raspl@linux.ibm.com,
	hca@linux.ibm.com, agordeev@linux.ibm.com, gor@linux.ibm.com,
	julianr@linux.ibm.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
	linux-pci@vger.kernel.org
Subject: Re: [PATCH 1/3] vfio/pci: Set VFIO_PCI_OFFSET_SHIFT to 48
Message-ID: <202602130603.5vXcHBPj-lkp@intel.com>
References: <20260212-vfio_pci_ism-v1-1-333262ade074@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260212-vfio_pci_ism-v1-1-333262ade074@linux.ibm.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71018-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[24];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[lkp@intel.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[intel.com:+];
	RCVD_COUNT_FIVE(0.00)[6];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[01.org:url,intel.com:mid,intel.com:dkim,intel.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 98D4B131982
X-Rspamd-Action: no action

Hi Julian,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 05f7e89ab9731565d8a62e3b5d1ec206485eeb0b]

url:    https://github.com/intel-lab-lkp/linux/commits/Julian-Ruess/vfio-pci-Set-VFIO_PCI_OFFSET_SHIFT-to-48/20260212-220938
base:   05f7e89ab9731565d8a62e3b5d1ec206485eeb0b
patch link:    https://lore.kernel.org/r/20260212-vfio_pci_ism-v1-1-333262ade074%40linux.ibm.com
patch subject: [PATCH 1/3] vfio/pci: Set VFIO_PCI_OFFSET_SHIFT to 48
config: powerpc-randconfig-002-20260213 (https://download.01.org/0day-ci/archive/20260213/202602130603.5vXcHBPj-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260213/202602130603.5vXcHBPj-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602130603.5vXcHBPj-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/vfio/pci/vfio_pci_core.c:1646:28: warning: shift count >= width of type [-Wshift-count-overflow]
    1646 |         int index = vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
         |                                   ^  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/vfio/pci/vfio_pci_core.c:1650:9: warning: shift count >= width of type [-Wshift-count-overflow]
    1650 |                 ((1UL << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
         |                       ^  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/vfio/pci/vfio_pci_core.c:1701:22: warning: shift count >= width of type [-Wshift-count-overflow]
    1701 |                             vma->vm_pgoff >>
         |                                           ^
    1702 |                                 (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT),
         |                                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/dev_printk.h:244:9: note: expanded from macro 'dev_dbg_ratelimited'
     244 |                                   ##__VA_ARGS__);                       \
         |                                     ^~~~~~~~~~~
   drivers/vfio/pci/vfio_pci_core.c:1729:24: warning: shift count >= width of type [-Wshift-count-overflow]
    1729 |         index = vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
         |                               ^  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/vfio/pci/vfio_pci_core.c:1754:9: warning: shift count >= width of type [-Wshift-count-overflow]
    1754 |                 ((1UL << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
         |                       ^  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   5 warnings generated.


vim +1646 drivers/vfio/pci/vfio_pci_core.c

abafbc551fdded drivers/vfio/pci/vfio_pci.c      Alex Williamson 2020-04-22  1642  
aac6db75a9fc2c drivers/vfio/pci/vfio_pci_core.c Alex Williamson 2024-05-29  1643  static unsigned long vma_to_pfn(struct vm_area_struct *vma)
11c4cd07ba111a drivers/vfio/pci/vfio_pci.c      Alex Williamson 2020-04-28  1644  {
536475109c8284 drivers/vfio/pci/vfio_pci_core.c Max Gurtovoy    2021-08-26  1645  	struct vfio_pci_core_device *vdev = vma->vm_private_data;
aac6db75a9fc2c drivers/vfio/pci/vfio_pci_core.c Alex Williamson 2024-05-29 @1646  	int index = vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
aac6db75a9fc2c drivers/vfio/pci/vfio_pci_core.c Alex Williamson 2024-05-29  1647  	u64 pgoff;
11c4cd07ba111a drivers/vfio/pci/vfio_pci.c      Alex Williamson 2020-04-28  1648  
aac6db75a9fc2c drivers/vfio/pci/vfio_pci_core.c Alex Williamson 2024-05-29  1649  	pgoff = vma->vm_pgoff &
c298baab91b6e3 drivers/vfio/pci/vfio_pci_core.c Julian Ruess    2026-02-12  1650  		((1UL << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
aac6db75a9fc2c drivers/vfio/pci/vfio_pci_core.c Alex Williamson 2024-05-29  1651  
aac6db75a9fc2c drivers/vfio/pci/vfio_pci_core.c Alex Williamson 2024-05-29  1652  	return (pci_resource_start(vdev->pdev, index) >> PAGE_SHIFT) + pgoff;
11c4cd07ba111a drivers/vfio/pci/vfio_pci.c      Alex Williamson 2020-04-28  1653  }
11c4cd07ba111a drivers/vfio/pci/vfio_pci.c      Alex Williamson 2020-04-28  1654  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

