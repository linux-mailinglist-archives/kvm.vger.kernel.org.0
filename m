Return-Path: <kvm+bounces-59836-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DB0EBCFD69
	for <lists+kvm@lfdr.de>; Sun, 12 Oct 2025 00:53:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 095BC4E25DF
	for <lists+kvm@lfdr.de>; Sat, 11 Oct 2025 22:53:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C9CF2580E4;
	Sat, 11 Oct 2025 22:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AZ2W0G13"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A8052494D8;
	Sat, 11 Oct 2025 22:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760223169; cv=none; b=ljmP2o0Ava5Df+TMrR6PeGOM9j13hxBleZJYa9ygs5vVFHoDdaZNq31a0NOqfqvdpZpNQKA7isj98PvC5O3zWPP2asvEJqguV6+NnXc2BWzKdUiXwJlWvTx3X7lQlR++zTic15bFHuB3/YHAxgDrFfW1LEkN8mr14B9zWgtGoOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760223169; c=relaxed/simple;
	bh=HetozuPvBPzpEzFnud6d+gPP7gQysdnjnk4oDQH188M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k04NDPE2sNUtuEQCPmfbF5wGLEhlIl+HFFOnDciIqgYoZlYdZ/oBj/iJrdDoNYgTF3wi7faXdMCXBPlSn/LUlsH2s64vlL+bUDfhe3Eaxw2bH+1rpWF4LSfL6308eVKkIUs/3PCHpd/8QEIvTbI9xZ6JbY8HDJiT4Jx4/lUpkcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AZ2W0G13; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760223168; x=1791759168;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=HetozuPvBPzpEzFnud6d+gPP7gQysdnjnk4oDQH188M=;
  b=AZ2W0G13pj4xPBx6Mr2QmcOdsG73U4B4XEgJYDEX/qkm4sqW+sQ3wU+h
   /r6n5PGR8Cfl/9PoIrFe85EYI9g/rt/fdrtLiEWHO/2rr0cu6BQHcWhkR
   G3/XhwDfzPzM6iJc15/HPogc227rFwUh44qua3FJi9huwI4skhyOFCsIT
   rIqm4+ZprFPuXN3wyo5W/yQ8Ep+mWNRX3yM0FxOmd55fpkw2ei33Zux9p
   cD/Zur2/2tnfmEPa7XE/JwAd46aHlMC6ei6HxNdk4QBBmv3D3xBrhWb3K
   zAYbnhmyKYEkoKS6d+d2xrec/202itnjhP+iLkKf1KZGdY/fpJ0eNXMJG
   A==;
X-CSE-ConnectionGUID: lCA3oXwYRMSPvU428zBaaQ==
X-CSE-MsgGUID: 9Zo0Wy5wQB6Jh0T+P5rDPw==
X-IronPort-AV: E=McAfee;i="6800,10657,11579"; a="80045091"
X-IronPort-AV: E=Sophos;i="6.19,221,1754982000"; 
   d="scan'208";a="80045091"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2025 15:52:46 -0700
X-CSE-ConnectionGUID: ECh9xyt7RkS8QF1ZJ5WDxQ==
X-CSE-MsgGUID: SS9rZIXDSQqly8dy7fyNkA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,221,1754982000"; 
   d="scan'208";a="186548737"
Received: from lkp-server01.sh.intel.com (HELO 6a630e8620ab) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 11 Oct 2025 15:52:41 -0700
Received: from kbuild by 6a630e8620ab with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v7iS7-000423-1F;
	Sat, 11 Oct 2025 22:52:39 +0000
Date: Sun, 12 Oct 2025 06:52:37 +0800
From: kernel test robot <lkp@intel.com>
To: =?utf-8?Q?Micha=C5=82?= Winiarski <michal.winiarski@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	intel-xe@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	dri-devel@lists.freedesktop.org,
	Matthew Brost <matthew.brost@intel.com>,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Lukasz Laguna <lukasz.laguna@intel.com>,
	=?utf-8?Q?Micha=C5=82?= Winiarski <michal.winiarski@intel.com>
Subject: Re: [PATCH 08/26] drm/xe/pf: Add minimalistic migration descriptor
Message-ID: <202510120634.LMJaAJ9S-lkp@intel.com>
References: <20251011193847.1836454-9-michal.winiarski@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251011193847.1836454-9-michal.winiarski@intel.com>

Hi Michał,

kernel test robot noticed the following build warnings:

[auto build test WARNING on drm-xe/drm-xe-next]
[also build test WARNING on next-20251010]
[cannot apply to awilliam-vfio/next drm-i915/for-linux-next drm-i915/for-linux-next-fixes linus/master awilliam-vfio/for-linus v6.17]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Micha-Winiarski/drm-xe-pf-Remove-GuC-version-check-for-migration-support/20251012-034301
base:   https://gitlab.freedesktop.org/drm/xe/kernel.git drm-xe-next
patch link:    https://lore.kernel.org/r/20251011193847.1836454-9-michal.winiarski%40intel.com
patch subject: [PATCH 08/26] drm/xe/pf: Add minimalistic migration descriptor
config: riscv-randconfig-002-20251012 (https://download.01.org/0day-ci/archive/20251012/202510120634.LMJaAJ9S-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 39f292ffa13d7ca0d1edff27ac8fd55024bb4d19)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251012/202510120634.LMJaAJ9S-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202510120634.LMJaAJ9S-lkp@intel.com/

All warnings (new ones prefixed by >>):

   Warning: drivers/gpu/drm/xe/xe_sriov_pf_migration_data.c:273 function parameter 'xe' not described in 'xe_sriov_pf_migration_data_read'
   Warning: drivers/gpu/drm/xe/xe_sriov_pf_migration_data.c:383 function parameter 'xe' not described in 'xe_sriov_pf_migration_data_write'
>> Warning: drivers/gpu/drm/xe/xe_sriov_pf_migration_data.c:457 function parameter 'xe' not described in 'xe_sriov_pf_migration_data_process_desc'
   Warning: drivers/gpu/drm/xe/xe_sriov_pf_migration_data.c:545 function parameter 'xe' not described in 'xe_sriov_pf_migration_data_save_init'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

