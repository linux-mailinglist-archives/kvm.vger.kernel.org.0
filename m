Return-Path: <kvm+bounces-50253-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 54CF7AE2E9A
	for <lists+kvm@lfdr.de>; Sun, 22 Jun 2025 08:06:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B3F6A1895EEC
	for <lists+kvm@lfdr.de>; Sun, 22 Jun 2025 06:06:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29B4C191F84;
	Sun, 22 Jun 2025 06:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L8wdi/Dj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C61718FDBD;
	Sun, 22 Jun 2025 06:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750572200; cv=none; b=JLgCLqQm3rzpc9620KM3LQ8bbJg+9BhuLgk3EPT4aSZrVhNcPEeKFoN5bPrSGgdb56H9QVDi6I0Ib+ysvt3Zf3XNn62xBkFRm+CrhoD9oIwkRXou2mTXNzxdNC3Mhz0QJ02Jd6JPG+h8T8jjTCgXKSJ5i+BEHNYTj8PYmO3UABk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750572200; c=relaxed/simple;
	bh=6Q8FrnkdsmldV9GcNFIT4wN8l3RVnI5WN8GsaLdbscs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I3hMv/CAqC8P3Cq1R2jKf3iGSnJ4R3NFOoWk3tdNQP2RYowsr8QeGAoEEbtYt0MDSuGYPMDONvzfbpdjhDXNeadDx+g6NheaDglqX/mvyHtNfcsdaNfgDL6GNXc06DYboW7LK4PR2v99o+KsO3GwaVppl4faInOWhWmbMCreshE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=L8wdi/Dj; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750572198; x=1782108198;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=6Q8FrnkdsmldV9GcNFIT4wN8l3RVnI5WN8GsaLdbscs=;
  b=L8wdi/DjgBkqsUn6VOoMUpREt3Ueq5Xaa97I4q9kIfo7H6zgy5qFsRVF
   3A80sxjmBVgAAkY4ZzV2Wx11uqohPQANJ5StaRXfXGqZX7ycGLTE2nTVr
   wb7/usA9SAJKMxQZ0cbtLfkOwfmnpqEAlQaIQvZc56H5kTzxrYSt+n7gv
   N6fuV59hOiM12mdQUcz7rXyd6sZiDlST0oiSyQ13UVPQsD5fsgSytpuiX
   ZEPvIuTsU9unMTEhtmSrlEcdhqOZXxUoz3v8pJAFx1+febSv93NrzmFXU
   WOxkhA2lrU2ZETnX0blqkjNBSWjJlLXriPvqoDd7RVgAfN8s9DmYfokld
   Q==;
X-CSE-ConnectionGUID: eGRT+8zxRl2DmD9s3zO9Mg==
X-CSE-MsgGUID: J0E5uukVQeqNrmxXAX4grQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11470"; a="63473344"
X-IronPort-AV: E=Sophos;i="6.16,255,1744095600"; 
   d="scan'208";a="63473344"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2025 23:03:16 -0700
X-CSE-ConnectionGUID: YCSARsZ5RWG/zST+8dcpBQ==
X-CSE-MsgGUID: 3MdxRylsSUqbPeP8nS9RvA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,255,1744095600"; 
   d="scan'208";a="150871451"
Received: from lkp-server01.sh.intel.com (HELO e8142ee1dce2) ([10.239.97.150])
  by fmviesa007.fm.intel.com with ESMTP; 21 Jun 2025 23:03:10 -0700
Received: from kbuild by e8142ee1dce2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uTDnI-000N5q-1P;
	Sun, 22 Jun 2025 06:03:08 +0000
Date: Sun, 22 Jun 2025 14:02:35 +0800
From: kernel test robot <lkp@intel.com>
To: Mario Limonciello <superm1@kernel.org>,
	Bjorn Helgaas <helgaas@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev, Alex Deucher <alexander.deucher@amd.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Lukas Wunner <lukas@wunner.de>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Woodhouse <dwmw2@infradead.org>,
	Lu Baolu <baolu.lu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	"(open list:INTEL IOMMU (VT-d))" <iommu@lists.linux.dev>,
	linux-pci@vger.kernel.org, kvm@vger.kernel.org,
	linux-sound@vger.kernel.org, Daniel Dadap <ddadap@nvidia.com>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: Re: [PATCH v3 6/7] PCI/VGA: Move check for firmware default out of
 VGA arbiter
Message-ID: <202506221312.49Fy1aNA-lkp@intel.com>
References: <20250620024943.3415685-7-superm1@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250620024943.3415685-7-superm1@kernel.org>

Hi Mario,

kernel test robot noticed the following build errors:

[auto build test ERROR on pci/next]
[also build test ERROR on pci/for-linus tiwai-sound/for-next tiwai-sound/for-linus awilliam-vfio/next awilliam-vfio/for-linus tip/x86/core linus/master v6.16-rc2 next-20250620]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Mario-Limonciello/PCI-Add-helper-for-checking-if-a-PCI-device-is-a-display-controller/20250620-105220
base:   https://git.kernel.org/pub/scm/linux/kernel/git/pci/pci.git next
patch link:    https://lore.kernel.org/r/20250620024943.3415685-7-superm1%40kernel.org
patch subject: [PATCH v3 6/7] PCI/VGA: Move check for firmware default out of VGA arbiter
config: sparc-defconfig (https://download.01.org/0day-ci/archive/20250622/202506221312.49Fy1aNA-lkp@intel.com/config)
compiler: sparc-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250622/202506221312.49Fy1aNA-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202506221312.49Fy1aNA-lkp@intel.com/

All errors (new ones prefixed by >>):

   sparc-linux-ld: drivers/pci/vgaarb.o: in function `vga_arbiter_add_pci_device':
>> vgaarb.c:(.text+0x14ec): undefined reference to `video_is_primary_device'
>> sparc-linux-ld: vgaarb.c:(.text+0x174c): undefined reference to `video_is_primary_device'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

