Return-Path: <kvm+bounces-50642-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B3704AE7DCB
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 11:46:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 401184A29D9
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 09:45:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57FC62C08A5;
	Wed, 25 Jun 2025 09:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UIiGv3X1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B050A29A303;
	Wed, 25 Jun 2025 09:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750844366; cv=none; b=ojVZW7egchYuiU4dpBHWxS1uVNBKqEVXEQaG6ANcLBG36ia/GZa11rZcqNqi7/tR5FuHkjAkUZQLI6Bn0GB7ygq8kRWRdmDFzVkQzE9wSzkCPOA8jaAQKU8700y7vmGPksESJEchM11sIXXAgDJcqEfHrJ1TRY0wCGHLufrM3tY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750844366; c=relaxed/simple;
	bh=wsM2YbD+M0xXuq6ZAwS4w4/eJ5LnAfTL+ORhH1xoJ+Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=itOPafxRWVd6wRKL3rM5nzJ4cqkvJahUehEvoCK7QIGT7YLo3gXUQSLU29CrEG9iDrfxK+r2VGRh3dCCD7ewN3OCq4ytWr+wukQ03loEomyhhemvuIKxrNTEED29JlQWEwrsiv/PL5DMJ0kPUVlUfeAL4r74vVt1rlubbII1fXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UIiGv3X1; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750844364; x=1782380364;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=wsM2YbD+M0xXuq6ZAwS4w4/eJ5LnAfTL+ORhH1xoJ+Q=;
  b=UIiGv3X1IswA68W5hOY6ktto4m1D5sRKjrcweHy6G0KMBOCr0tTnyZ+k
   Lqy6bjfDN7aM9uWKHIcezttZ5ontMJP77PzMpojz8vDBIV3oYJL2kRpmj
   HX5BDoM1CgE1K/4PxgMfIdcRAiQ+B2wKjS5+UmOQc/12GOLKrj3524mnx
   QcKb24X+yeJqwCRb+S2dgmYNS5zrsqyCSgp+N8BExuJxA9ejZVu5HZKUp
   tjEjfu7+ZSNgU5mJck4vWItWIPgCZ3aQffcuurAXiy/HhN6W0Zi2ZXRLO
   PgsPHYEFiU/SJ/x1AumBFNPx+M3MyQNBn8KRdLW5blshHPDZs6riuywhT
   A==;
X-CSE-ConnectionGUID: RdDEEVQ2Q4icNfq7s4LX6Q==
X-CSE-MsgGUID: Ua0aXaRSRZmG0FO3ZVc+mw==
X-IronPort-AV: E=McAfee;i="6800,10657,11474"; a="40726608"
X-IronPort-AV: E=Sophos;i="6.16,264,1744095600"; 
   d="scan'208";a="40726608"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2025 02:39:23 -0700
X-CSE-ConnectionGUID: rE6PHxq3SY6amVbIO6+R9Q==
X-CSE-MsgGUID: UXE3rrreQwWkT/nXb7LPYg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,264,1744095600"; 
   d="scan'208";a="151584247"
Received: from lkp-server01.sh.intel.com (HELO e8142ee1dce2) ([10.239.97.150])
  by orviesa010.jf.intel.com with ESMTP; 25 Jun 2025 02:39:18 -0700
Received: from kbuild by e8142ee1dce2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uUMb5-000SyA-2S;
	Wed, 25 Jun 2025 09:39:15 +0000
Date: Wed, 25 Jun 2025 17:38:18 +0800
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
Subject: Re: [PATCH v5 7/9] PCI/VGA: Replace vga_is_firmware_default() with a
 screen info check
Message-ID: <202506251749.fPKnHMH5-lkp@intel.com>
References: <20250624203042.1102346-8-superm1@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250624203042.1102346-8-superm1@kernel.org>

Hi Mario,

kernel test robot noticed the following build errors:

[auto build test ERROR on pci/next]
[also build test ERROR on pci/for-linus tiwai-sound/for-next tiwai-sound/for-linus tip/x86/core linus/master v6.16-rc3 next-20250625]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Mario-Limonciello/PCI-Add-helper-for-checking-if-a-PCI-device-is-a-display-controller/20250625-043200
base:   https://git.kernel.org/pub/scm/linux/kernel/git/pci/pci.git next
patch link:    https://lore.kernel.org/r/20250624203042.1102346-8-superm1%40kernel.org
patch subject: [PATCH v5 7/9] PCI/VGA: Replace vga_is_firmware_default() with a screen info check
config: x86_64-defconfig (https://download.01.org/0day-ci/archive/20250625/202506251749.fPKnHMH5-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-12) 11.3.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250625/202506251749.fPKnHMH5-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202506251749.fPKnHMH5-lkp@intel.com/

All errors (new ones prefixed by >>):

   ld: vmlinux.o: in function `vga_arbiter_add_pci_device':
>> vgaarb.c:(.text+0x5f8f90): undefined reference to `screen_info_pci_dev'
>> ld: vgaarb.c:(.text+0x5f91f8): undefined reference to `screen_info_pci_dev'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

