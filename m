Return-Path: <kvm+bounces-51612-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5343BAF9BED
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 23:20:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 49FEE545C47
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 21:19:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFC6C2E3704;
	Fri,  4 Jul 2025 21:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FCl+wowr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54F7522FDFF;
	Fri,  4 Jul 2025 21:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751663988; cv=none; b=MiHeBB1bZ2j6WsZe0wK/8JHVrseeKoptfIDEhUBFW8UOtfC9VrnIuDfORnJYquStBCnnmCbrvsjrKRbvsktsajpsmpSs5+ZbGeTXjhUaUVshQXTCn1Dmrb7E9Nwl7hFIKFntdt6IALvxq1ti6Hh6t3USZEKvCpB2UnkkbeUvnYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751663988; c=relaxed/simple;
	bh=DQL5r67Qu/34vn2qT6B5dU9fn3aC9sM/wv7oTD4DDII=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gvqWsau88/SdXsDzLLS2jF2DT1lmGxQOGWZLr0RRJUgzUqWlN0uKnE1ygLSnaisyZLVmcMjrV26ncSdcMKdC3q+GOzpBLthq4WP8lRWoHlmp5AahMsysIt7kq5hsAeTt4xP7axXEISR2YRCAxUghedmSViAzlslhrCSIofKSXUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FCl+wowr; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751663985; x=1783199985;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=DQL5r67Qu/34vn2qT6B5dU9fn3aC9sM/wv7oTD4DDII=;
  b=FCl+wowrd9dSSrQ5G9O3SboEu5CVAUyLVtPc+qFzp69npg/tKnZ27woy
   eBfogt6eNwoaUJd/RIZY5vrjFEmMdIpL3QqAjHcGnN4nAM55gz17um+3i
   bZryFjaDat3V2KpJfjXSreK141Y1JWgYB2QPmZoFWWo6KxIrLdN5hWcbq
   z81Et6bf+cnVwA8xfHRv3ajBFw3R6g/UGaqPwF6hDt1X+033+ch9uD+Yr
   RWF8KkL1m5IHw+aIO7J51XtBVN+il8mw3L7AuNxIljPAW21toMuDvp8PK
   8a01QUwOylWq13So+iiXFDd00Q1+sv0CZ2rpGwRriJGFYBQTe2RKVkr0Z
   A==;
X-CSE-ConnectionGUID: k1PHoDrHQteH3T+ptb3IYg==
X-CSE-MsgGUID: mBXbuqi+TvWy6azLZAbYxw==
X-IronPort-AV: E=McAfee;i="6800,10657,11484"; a="65444659"
X-IronPort-AV: E=Sophos;i="6.16,288,1744095600"; 
   d="scan'208";a="65444659"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2025 14:19:44 -0700
X-CSE-ConnectionGUID: dWI3YPAcRp+t0kOr0cMeOg==
X-CSE-MsgGUID: l41/JSsfSMeigNYlw4sxeA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,288,1744095600"; 
   d="scan'208";a="159265596"
Received: from lkp-server01.sh.intel.com (HELO 0b2900756c14) ([10.239.97.150])
  by orviesa004.jf.intel.com with ESMTP; 04 Jul 2025 14:19:41 -0700
Received: from kbuild by 0b2900756c14 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uXnop-000459-15;
	Fri, 04 Jul 2025 21:19:39 +0000
Date: Sat, 5 Jul 2025 05:19:34 +0800
From: kernel test robot <lkp@intel.com>
To: lizhe.67@bytedance.com, alex.williamson@redhat.com,
	akpm@linux-foundation.org, david@redhat.com, peterx@redhat.com,
	jgg@ziepe.ca
Cc: oe-kbuild-all@lists.linux.dev, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	lizhe.67@bytedance.com
Subject: Re: [PATCH v2 1/5] mm: introduce num_pages_contiguous()
Message-ID: <202507050529.EoMuEtd8-lkp@intel.com>
References: <20250704062602.33500-2-lizhe.67@bytedance.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250704062602.33500-2-lizhe.67@bytedance.com>

Hi,

kernel test robot noticed the following build errors:

[auto build test ERROR on awilliam-vfio/next]
[also build test ERROR on awilliam-vfio/for-linus akpm-mm/mm-everything linus/master v6.16-rc4 next-20250704]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/lizhe-67-bytedance-com/mm-introduce-num_pages_contiguous/20250704-142948
base:   https://github.com/awilliam/linux-vfio.git next
patch link:    https://lore.kernel.org/r/20250704062602.33500-2-lizhe.67%40bytedance.com
patch subject: [PATCH v2 1/5] mm: introduce num_pages_contiguous()
config: sh-allmodconfig (https://download.01.org/0day-ci/archive/20250705/202507050529.EoMuEtd8-lkp@intel.com/config)
compiler: sh4-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250705/202507050529.EoMuEtd8-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202507050529.EoMuEtd8-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from arch/sh/include/asm/page.h:160,
                    from arch/sh/include/asm/thread_info.h:13,
                    from include/linux/thread_info.h:60,
                    from include/asm-generic/preempt.h:5,
                    from ./arch/sh/include/generated/asm/preempt.h:1,
                    from include/linux/preempt.h:79,
                    from include/linux/spinlock.h:56,
                    from include/linux/mmzone.h:8,
                    from include/linux/gfp.h:7,
                    from include/linux/mm.h:7,
                    from arch/sh/kernel/asm-offsets.c:14:
   include/linux/mm.h: In function 'num_pages_contiguous':
>> include/asm-generic/memory_model.h:48:21: error: implicit declaration of function 'page_to_section'; did you mean 'present_section'? [-Wimplicit-function-declaration]
      48 |         int __sec = page_to_section(__pg);                      \
         |                     ^~~~~~~~~~~~~~~
   include/asm-generic/memory_model.h:53:32: note: in definition of macro '__pfn_to_page'
      53 | ({      unsigned long __pfn = (pfn);                    \
         |                                ^~~
   include/asm-generic/memory_model.h:65:21: note: in expansion of macro '__page_to_pfn'
      65 | #define page_to_pfn __page_to_pfn
         |                     ^~~~~~~~~~~~~
   include/linux/mm.h:200:38: note: in expansion of macro 'page_to_pfn'
     200 | #define nth_page(page,n) pfn_to_page(page_to_pfn((page)) + (n))
         |                                      ^~~~~~~~~~~
   include/linux/mm.h:221:33: note: in expansion of macro 'nth_page'
     221 |                 if (pages[i] != nth_page(first_page, i))
         |                                 ^~~~~~~~
   include/linux/mm.h: At top level:
>> include/linux/mm.h:2002:29: error: conflicting types for 'page_to_section'; have 'long unsigned int(const struct page *)'
    2002 | static inline unsigned long page_to_section(const struct page *page)
         |                             ^~~~~~~~~~~~~~~
   include/asm-generic/memory_model.h:48:21: note: previous implicit declaration of 'page_to_section' with type 'int()'
      48 |         int __sec = page_to_section(__pg);                      \
         |                     ^~~~~~~~~~~~~~~
   include/asm-generic/memory_model.h:53:32: note: in definition of macro '__pfn_to_page'
      53 | ({      unsigned long __pfn = (pfn);                    \
         |                                ^~~
   include/asm-generic/memory_model.h:65:21: note: in expansion of macro '__page_to_pfn'
      65 | #define page_to_pfn __page_to_pfn
         |                     ^~~~~~~~~~~~~
   include/linux/mm.h:200:38: note: in expansion of macro 'page_to_pfn'
     200 | #define nth_page(page,n) pfn_to_page(page_to_pfn((page)) + (n))
         |                                      ^~~~~~~~~~~
   include/linux/mm.h:221:33: note: in expansion of macro 'nth_page'
     221 |                 if (pages[i] != nth_page(first_page, i))
         |                                 ^~~~~~~~
   make[3]: *** [scripts/Makefile.build:98: arch/sh/kernel/asm-offsets.s] Error 1
   make[3]: Target 'prepare' not remade because of errors.
   make[2]: *** [Makefile:1274: prepare0] Error 2
   make[2]: Target 'prepare' not remade because of errors.
   make[1]: *** [Makefile:248: __sub-make] Error 2
   make[1]: Target 'prepare' not remade because of errors.
   make: *** [Makefile:248: __sub-make] Error 2
   make: Target 'prepare' not remade because of errors.


vim +2002 include/linux/mm.h

bf4e8902ee5080 Daniel Kiper      2011-05-24  2001  
aa462abe8aaf21 Ian Campbell      2011-08-17 @2002  static inline unsigned long page_to_section(const struct page *page)
d41dee369bff3b Andy Whitcroft    2005-06-23  2003  {
d41dee369bff3b Andy Whitcroft    2005-06-23  2004  	return (page->flags >> SECTIONS_PGSHIFT) & SECTIONS_MASK;
d41dee369bff3b Andy Whitcroft    2005-06-23  2005  }
308c05e35e3517 Christoph Lameter 2008-04-28  2006  #endif
d41dee369bff3b Andy Whitcroft    2005-06-23  2007  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

