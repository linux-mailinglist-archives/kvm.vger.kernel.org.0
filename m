Return-Path: <kvm+bounces-47199-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 244F3ABE821
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 01:39:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 200A17A3B25
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 23:37:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA6F325E83F;
	Tue, 20 May 2025 23:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VSujWilA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C67AD256C7D;
	Tue, 20 May 2025 23:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747784331; cv=none; b=pswJLKd3EuT+y0iwVmOVHF3QR94wSivclkr0Dsr7ZET05ihGm/iTZPMqj3sjL+Xx8P8zVh0fd2QbPyqyXrt/rwQb7glhjv8jpZrg0CHjEqH91L2qhSqp0R76BlT3JNGcPMFGvKZX6Y2sh2dfGHLRDQei8MN6fVQMhUaTIk3OERs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747784331; c=relaxed/simple;
	bh=6k7yATObDw4adb5vnXcEwNXFnoSuP4qFoAizUOImBEw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KGsUShFva/SGjA/FYuMgYslX7nqL5oF2se5Aw6ixAPjY55VCSNckszVxD4uK9+s87x565TUnVCJFtGixSO1P65xWFrSVh1/XOkU92XvPoZWiQWwBpFslnZm2/aAbfWxbl0ZtDMgNd5lQlrhZHOu/59BJgy0XFote+cr02Tlh1sE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VSujWilA; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747784329; x=1779320329;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=6k7yATObDw4adb5vnXcEwNXFnoSuP4qFoAizUOImBEw=;
  b=VSujWilA3ybCRl7Hd7jUQIf+PUvKT15vw7UcgDAB2HXAtSA3FGw4dujG
   nOW9zrtcFJJxdp8uFQi/t5VvOhiAryKg/5bzGWfockGFVExpp+Cdy6q4z
   nnLrBezgqFUS7RpcNlXqJZumXpI5Xd1Vwj9Za1P0QDCjcCaQ3AdkIWn+x
   QzJ/RdS3Gai4qcHmunbGE6Z3WWzlcpLo+dcCflWGj+6z3XGQDZiZcsdBg
   z/m9pzbNELibjbT3gDpoVixdHB15e2ySYA60sClc9qm5XlJVAHSzAig/r
   1FDpK1wR9DkZGi7MLkePBveb/daM1WnavSAMuV85Jxn84pASpWvXOwoZS
   w==;
X-CSE-ConnectionGUID: ZaCxezxsSmqAfurGTDr9VA==
X-CSE-MsgGUID: JtsGmn2jTTOPdd0MsuMdZg==
X-IronPort-AV: E=McAfee;i="6700,10204,11439"; a="60380972"
X-IronPort-AV: E=Sophos;i="6.15,303,1739865600"; 
   d="scan'208";a="60380972"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2025 16:38:48 -0700
X-CSE-ConnectionGUID: nAe3oT3uTHyMCF3lRzQ6hg==
X-CSE-MsgGUID: n77WxTsbRF22rRPP9zdLSA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,303,1739865600"; 
   d="scan'208";a="144725084"
Received: from lkp-server01.sh.intel.com (HELO 1992f890471c) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 20 May 2025 16:38:46 -0700
Received: from kbuild by 1992f890471c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uHWXk-000Nfo-1f;
	Tue, 20 May 2025 23:38:44 +0000
Date: Wed, 21 May 2025 07:37:57 +0800
From: kernel test robot <lkp@intel.com>
To: lizhe.67@bytedance.com, alex.williamson@redhat.com
Cc: oe-kbuild-all@lists.linux.dev, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, lizhe.67@bytedance.com,
	muchun.song@linux.dev
Subject: Re: [PATCH v3] vfio/type1: optimize vfio_pin_pages_remote() for huge
 folio
Message-ID: <202505210701.WY7sKXwU-lkp@intel.com>
References: <20250520070020.6181-1-lizhe.67@bytedance.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250520070020.6181-1-lizhe.67@bytedance.com>

Hi,

kernel test robot noticed the following build errors:

[auto build test ERROR on awilliam-vfio/next]
[also build test ERROR on awilliam-vfio/for-linus linus/master v6.15-rc7 next-20250516]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/lizhe-67-bytedance-com/vfio-type1-optimize-vfio_pin_pages_remote-for-huge-folio/20250520-150123
base:   https://github.com/awilliam/linux-vfio.git next
patch link:    https://lore.kernel.org/r/20250520070020.6181-1-lizhe.67%40bytedance.com
patch subject: [PATCH v3] vfio/type1: optimize vfio_pin_pages_remote() for huge folio
config: i386-randconfig-013-20250521 (https://download.01.org/0day-ci/archive/20250521/202505210701.WY7sKXwU-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250521/202505210701.WY7sKXwU-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202505210701.WY7sKXwU-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from <command-line>:
   drivers/vfio/vfio_iommu_type1.c: In function 'vfio_pin_pages_remote':
>> include/linux/compiler_types.h:542:45: error: call to '__compiletime_assert_499' declared with attribute error: min((long)batch->size, folio_nr_pages(folio) - (({ const struct page *__pg = (batch->pages[batch->offset]); int __sec = page_to_section(__pg); (unsigned long)(__pg - __section_mem_map_addr(__nr_to_section(__sec))); }) - folio_pfn(folio))) signedness error
     542 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |                                             ^
   include/linux/compiler_types.h:523:25: note: in definition of macro '__compiletime_assert'
     523 |                         prefix ## suffix();                             \
         |                         ^~~~~~
   include/linux/compiler_types.h:542:9: note: in expansion of macro '_compiletime_assert'
     542 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_assert'
      39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
         |                                     ^~~~~~~~~~~~~~~~~~
   include/linux/minmax.h:93:9: note: in expansion of macro 'BUILD_BUG_ON_MSG'
      93 |         BUILD_BUG_ON_MSG(!__types_ok(ux, uy),           \
         |         ^~~~~~~~~~~~~~~~
   include/linux/minmax.h:98:9: note: in expansion of macro '__careful_cmp_once'
      98 |         __careful_cmp_once(op, x, y, __UNIQUE_ID(x_), __UNIQUE_ID(y_))
         |         ^~~~~~~~~~~~~~~~~~
   include/linux/minmax.h:105:25: note: in expansion of macro '__careful_cmp'
     105 | #define min(x, y)       __careful_cmp(min, x, y)
         |                         ^~~~~~~~~~~~~
   drivers/vfio/vfio_iommu_type1.c:709:36: note: in expansion of macro 'min'
     709 |                         nr_pages = min((long)batch->size, folio_nr_pages(folio) -
         |                                    ^~~
--
   In file included from <command-line>:
   vfio_iommu_type1.c: In function 'vfio_pin_pages_remote':
>> include/linux/compiler_types.h:542:45: error: call to '__compiletime_assert_499' declared with attribute error: min((long)batch->size, folio_nr_pages(folio) - (({ const struct page *__pg = (batch->pages[batch->offset]); int __sec = page_to_section(__pg); (unsigned long)(__pg - __section_mem_map_addr(__nr_to_section(__sec))); }) - folio_pfn(folio))) signedness error
     542 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |                                             ^
   include/linux/compiler_types.h:523:25: note: in definition of macro '__compiletime_assert'
     523 |                         prefix ## suffix();                             \
         |                         ^~~~~~
   include/linux/compiler_types.h:542:9: note: in expansion of macro '_compiletime_assert'
     542 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_assert'
      39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
         |                                     ^~~~~~~~~~~~~~~~~~
   include/linux/minmax.h:93:9: note: in expansion of macro 'BUILD_BUG_ON_MSG'
      93 |         BUILD_BUG_ON_MSG(!__types_ok(ux, uy),           \
         |         ^~~~~~~~~~~~~~~~
   include/linux/minmax.h:98:9: note: in expansion of macro '__careful_cmp_once'
      98 |         __careful_cmp_once(op, x, y, __UNIQUE_ID(x_), __UNIQUE_ID(y_))
         |         ^~~~~~~~~~~~~~~~~~
   include/linux/minmax.h:105:25: note: in expansion of macro '__careful_cmp'
     105 | #define min(x, y)       __careful_cmp(min, x, y)
         |                         ^~~~~~~~~~~~~
   vfio_iommu_type1.c:709:36: note: in expansion of macro 'min'
     709 |                         nr_pages = min((long)batch->size, folio_nr_pages(folio) -
         |                                    ^~~


vim +/__compiletime_assert_499 +542 include/linux/compiler_types.h

eb5c2d4b45e3d2 Will Deacon 2020-07-21  528  
eb5c2d4b45e3d2 Will Deacon 2020-07-21  529  #define _compiletime_assert(condition, msg, prefix, suffix) \
eb5c2d4b45e3d2 Will Deacon 2020-07-21  530  	__compiletime_assert(condition, msg, prefix, suffix)
eb5c2d4b45e3d2 Will Deacon 2020-07-21  531  
eb5c2d4b45e3d2 Will Deacon 2020-07-21  532  /**
eb5c2d4b45e3d2 Will Deacon 2020-07-21  533   * compiletime_assert - break build and emit msg if condition is false
eb5c2d4b45e3d2 Will Deacon 2020-07-21  534   * @condition: a compile-time constant condition to check
eb5c2d4b45e3d2 Will Deacon 2020-07-21  535   * @msg:       a message to emit if condition is false
eb5c2d4b45e3d2 Will Deacon 2020-07-21  536   *
eb5c2d4b45e3d2 Will Deacon 2020-07-21  537   * In tradition of POSIX assert, this macro will break the build if the
eb5c2d4b45e3d2 Will Deacon 2020-07-21  538   * supplied condition is *false*, emitting the supplied error message if the
eb5c2d4b45e3d2 Will Deacon 2020-07-21  539   * compiler has support to do so.
eb5c2d4b45e3d2 Will Deacon 2020-07-21  540   */
eb5c2d4b45e3d2 Will Deacon 2020-07-21  541  #define compiletime_assert(condition, msg) \
eb5c2d4b45e3d2 Will Deacon 2020-07-21 @542  	_compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
eb5c2d4b45e3d2 Will Deacon 2020-07-21  543  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

