Return-Path: <kvm+bounces-49560-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 701ACAD9DDF
	for <lists+kvm@lfdr.de>; Sat, 14 Jun 2025 16:47:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C67A6189C807
	for <lists+kvm@lfdr.de>; Sat, 14 Jun 2025 14:47:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F4422E2EE9;
	Sat, 14 Jun 2025 14:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dhTZ7alw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DC3D101C8;
	Sat, 14 Jun 2025 14:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749912423; cv=none; b=PdaD/cDWpwZDKP7tCgk5kUakwYXGjIUuG5YstkXNElzyOBxfTskJ3wyiosc4ulNaX9eHxK+/SpUeYSY+rl6pSxjbRikLTLYVlHbl2IV1tQaToV0mvPI2AnPC1Gop2eqoYst+vhLWAJhYNDLEkq4rS+eTGVEsov52kuhGwUol5fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749912423; c=relaxed/simple;
	bh=yszUTL4SUmgXliViH82bafHq+QCIDg65TrpXnQFrs0U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bHtDuGg4cJgwDJohl/pM67gun+WgvFjD/7YXgvuOO4vTWPUqnuYsLHAk1QtDuVE4aEUbHN1GgeZgqj4uBcDbpBeZaz+T9t251I6a+TK5KaYdogCARSPknG0sSrpFHNZm8L+8zmoblneVI8QuuX5xBUM3sE+c6UxSvS+liiEsauQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dhTZ7alw; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749912422; x=1781448422;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=yszUTL4SUmgXliViH82bafHq+QCIDg65TrpXnQFrs0U=;
  b=dhTZ7alwqPuEkM3IVYAOhS4y0FQ2anVsYRME8JIWNfZLypZ83nnEP4/W
   fmgne5p6kiHqYMTVzFTyAlXBQHghbsiPEWXm5XBCqWsZHOCxzUiIW45Vz
   rTXTA+wa7b9J8vDD3fogpZ2z/0yEBt+bupi62nGDkcUW7QmF8XbHHjgjP
   SzLFqyfawM2Uib/rnZLj846yvA850UaEycvUWKV5sjyHfDoTwli635x3o
   CdhH5SKnhSW3rIYXoouqYcb/Xq3nW7+UkuJyVq4721ik+2Q4npfSuHMR1
   SjTitrCvHHHFlEEYIspSM7woFjA7LYBr/mXKBBiijznh6FLk3kxMFBeD0
   g==;
X-CSE-ConnectionGUID: o1qbXmmjSPqkBoVzdeMlKg==
X-CSE-MsgGUID: vkbkCotfQaS6f8Fnp12QdA==
X-IronPort-AV: E=McAfee;i="6800,10657,11464"; a="74640700"
X-IronPort-AV: E=Sophos;i="6.16,236,1744095600"; 
   d="scan'208";a="74640700"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2025 07:47:01 -0700
X-CSE-ConnectionGUID: oOtMxOXRQ6+xe094Y20BGg==
X-CSE-MsgGUID: f+RlwJaZRj6dVdN1G84eLw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,236,1744095600"; 
   d="scan'208";a="147967921"
Received: from lkp-server01.sh.intel.com (HELO e8142ee1dce2) ([10.239.97.150])
  by orviesa010.jf.intel.com with ESMTP; 14 Jun 2025 07:46:58 -0700
Received: from kbuild by e8142ee1dce2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uQS9n-000Das-1S;
	Sat, 14 Jun 2025 14:46:55 +0000
Date: Sat, 14 Jun 2025 22:46:45 +0800
From: kernel test robot <lkp@intel.com>
To: Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, kvm@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Zi Yan <ziy@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>,
	Alex Mastro <amastro@fb.com>, David Hildenbrand <david@redhat.com>,
	Nico Pache <npache@redhat.com>, peterx@redhat.com
Subject: Re: [PATCH 4/5] vfio: Introduce vfio_device_ops.get_unmapped_area
 hook
Message-ID: <202506142215.koMEU2rT-lkp@intel.com>
References: <20250613134111.469884-5-peterx@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250613134111.469884-5-peterx@redhat.com>

Hi Peter,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Peter-Xu/mm-Deduplicate-mm_get_unmapped_area/20250613-214307
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20250613134111.469884-5-peterx%40redhat.com
patch subject: [PATCH 4/5] vfio: Introduce vfio_device_ops.get_unmapped_area hook
config: sh-randconfig-002-20250614 (https://download.01.org/0day-ci/archive/20250614/202506142215.koMEU2rT-lkp@intel.com/config)
compiler: sh4-linux-gcc (GCC) 12.4.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250614/202506142215.koMEU2rT-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202506142215.koMEU2rT-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/vfio/vfio_main.c: In function 'vfio_device_get_unmapped_area':
>> drivers/vfio/vfio_main.c:1367:24: error: implicit declaration of function 'mm_get_unmapped_area'; did you mean 'get_unmapped_area'? [-Werror=implicit-function-declaration]
    1367 |                 return mm_get_unmapped_area(current->mm, file, addr,
         |                        ^~~~~~~~~~~~~~~~~~~~
         |                        get_unmapped_area
   cc1: some warnings being treated as errors


vim +1367 drivers/vfio/vfio_main.c

  1356	
  1357	static unsigned long vfio_device_get_unmapped_area(struct file *file,
  1358							   unsigned long addr,
  1359							   unsigned long len,
  1360							   unsigned long pgoff,
  1361							   unsigned long flags)
  1362	{
  1363		struct vfio_device_file *df = file->private_data;
  1364		struct vfio_device *device = df->device;
  1365	
  1366		if (!device->ops->get_unmapped_area)
> 1367			return mm_get_unmapped_area(current->mm, file, addr,
  1368						    len, pgoff, flags);
  1369	
  1370		return device->ops->get_unmapped_area(device, file, addr, len,
  1371						      pgoff, flags);
  1372	}
  1373	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

