Return-Path: <kvm+bounces-18578-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B41A28D71A1
	for <lists+kvm@lfdr.de>; Sat,  1 Jun 2024 21:15:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 665051F21A0F
	for <lists+kvm@lfdr.de>; Sat,  1 Jun 2024 19:15:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D64C3125DE;
	Sat,  1 Jun 2024 19:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ui+iMp0B"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 734A233EA
	for <kvm@vger.kernel.org>; Sat,  1 Jun 2024 19:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717269335; cv=none; b=fQTtG02J9ELWG7y30Xqhp+DTp23S/Wy+RE/cdpaEa6jG/q74Fr29ps3olDFqoAr8dY4kfRXNeLpqXF2vp289vmQYZZPIuBDHeTJK8ZV5v2qjKjdgVP3JMmvgW1jb/bx9cNhup2zBE6NgLcZW1TGESbokr/6n75uVgwdK1u08CqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717269335; c=relaxed/simple;
	bh=TCNSPxPns4EhFR9yBjsnQhWnMT3BTaZJ5LndNteH2Ns=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nxKnODVyXs6JIJUIalLaJ6CWYOKwkvVS2A1UrB0n94fvgjLO8HpdytRt0f/YYeKFMaAjjoGjMV+rH7LEhp5/EzYwQTZpiPwc197Mu3cGBWimXeqVujyJewE6+qjP/Joj7LvxcVHqUIzjivRJELOsjZX++C9h/QvFCvCbZLNyeGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ui+iMp0B; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717269333; x=1748805333;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=TCNSPxPns4EhFR9yBjsnQhWnMT3BTaZJ5LndNteH2Ns=;
  b=Ui+iMp0BHJMsejzYibXW9WxN99pEPm0eMyteNW8X6z63pAC6hDFyoHuO
   Y9DTIfcrbfErbyXaLC4eLCPlcaS4QPQdd4FZjsRHGAZ6OdWW8wv2lm1fq
   1KrhpYodValK+0edcHnyelso89FXlFuji06TDerVDYtgEmX1k/3GCA5bv
   H6Jds7A6OIqAOW7qOV+XbtAUYM5i0jIAAcLzxkfaVRHWugpLFCND4XaAN
   /GZdk+pLMZrucDu7SAfUfGIGnbeX5xSo9KYHAkZmVbnjtwj83iOkDin37
   5TxYSLcv5rTc/fB53t60z2Yg4iEm3jFOww6OMt11lPZ29rBQOUzv6xrVl
   Q==;
X-CSE-ConnectionGUID: rIhVR0dwRFKjA3YKL1+0MA==
X-CSE-MsgGUID: m4ARZbuoRXyO4HsqaXmu5g==
X-IronPort-AV: E=McAfee;i="6600,9927,11090"; a="14024366"
X-IronPort-AV: E=Sophos;i="6.08,207,1712646000"; 
   d="scan'208";a="14024366"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2024 12:15:31 -0700
X-CSE-ConnectionGUID: rWV/KU92STmxbEjmvCR7Zw==
X-CSE-MsgGUID: bgxV5EY2QLGvKJagxrtxBw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,207,1712646000"; 
   d="scan'208";a="41560131"
Received: from unknown (HELO 0610945e7d16) ([10.239.97.151])
  by orviesa004.jf.intel.com with ESMTP; 01 Jun 2024 12:15:29 -0700
Received: from kbuild by 0610945e7d16 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sDUBq-000JHH-06;
	Sat, 01 Jun 2024 19:15:21 +0000
Date: Sun, 2 Jun 2024 03:13:51 +0800
From: kernel test robot <lkp@intel.com>
To: Srujana Challa <schalla@marvell.com>, virtualization@lists.linux.dev,
	kvm@vger.kernel.org, mst@redhat.com, jasowang@redhat.com
Cc: oe-kbuild-all@lists.linux.dev, schalla@marvell.com,
	vattunuru@marvell.com, sthotton@marvell.com,
	ndabilpuram@marvell.com, jerinj@marvell.com
Subject: Re: [PATCH] vdpa: Add support for no-IOMMU mode
Message-ID: <202406020255.Xp36fzlp-lkp@intel.com>
References: <20240530101823.1210161-1-schalla@marvell.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240530101823.1210161-1-schalla@marvell.com>

Hi Srujana,

kernel test robot noticed the following build warnings:

[auto build test WARNING on mst-vhost/linux-next]
[also build test WARNING on linus/master v6.10-rc1 next-20240531]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Srujana-Challa/vdpa-Add-support-for-no-IOMMU-mode/20240530-182129
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git linux-next
patch link:    https://lore.kernel.org/r/20240530101823.1210161-1-schalla%40marvell.com
patch subject: [PATCH] vdpa: Add support for no-IOMMU mode
config: powerpc64-randconfig-r123-20240601 (https://download.01.org/0day-ci/archive/20240602/202406020255.Xp36fzlp-lkp@intel.com/config)
compiler: powerpc64-linux-gcc (GCC) 13.2.0
reproduce: (https://download.01.org/0day-ci/archive/20240602/202406020255.Xp36fzlp-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202406020255.Xp36fzlp-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> drivers/vhost/vdpa.c:39:6: sparse: sparse: symbol 'vhost_vdpa_noiommu' was not declared. Should it be static?

vim +/vhost_vdpa_noiommu +39 drivers/vhost/vdpa.c

    38	
  > 39	bool vhost_vdpa_noiommu;
    40	module_param_named(enable_vhost_vdpa_unsafe_noiommu_mode,
    41			   vhost_vdpa_noiommu, bool, 0644);
    42	MODULE_PARM_DESC(enable_vhost_vdpa_unsafe_noiommu_mode, "Enable UNSAFE, no-IOMMU mode.  This mode provides no device isolation, no DMA translation, no host kernel protection, cannot be used for device assignment to virtual machines, requires RAWIO permissions, and will taint the kernel.  If you do not know what this is for, step away. (default: false)");
    43	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

