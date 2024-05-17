Return-Path: <kvm+bounces-17567-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C7B68C7FB4
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 03:59:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C1E8FB20A9D
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 01:59:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C21A1523D;
	Fri, 17 May 2024 01:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C5mhggp0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5A6C17FD;
	Fri, 17 May 2024 01:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715911154; cv=none; b=s/Ir95H5iO5PjFM4BtDpykJ0EGBVXUczSUUuucae+td1D5nRZVih3PoZbacrZ9YU25/37bPoyMDNzsIo2rw9Lip0JCwbLX2JrHwqlwUgrIK/Cvl+U1ZdzBZQftcsDSXDNM+JYo62GeMb199PSdK9bkqQh9nHeQAybi20XS7P04w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715911154; c=relaxed/simple;
	bh=/asIFP3VhVOl5Bww+xsuwvWltg7PkBCAkGCa0RHdLdA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oaGDcJ54OrPnab2r4UZ6QQtdsgnN66gAt2vBSEx2CFQi/Dw/uCfwMXd3eIH1ycyw/qWEoHrv5ZP5XMC9tgsLouSX7jzEZxlj0OaP3HOOk9wAfGmlee20cAv5dQbuM/uPFkGPnPbfQivcPbgl4QSDGQb7+PbKV80fKswYovqwo1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C5mhggp0; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715911152; x=1747447152;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/asIFP3VhVOl5Bww+xsuwvWltg7PkBCAkGCa0RHdLdA=;
  b=C5mhggp0moSPCqqGn08cnnyh9Iy0zfbR68XUZVrGnr0qic02WkkbmM5C
   jQWRXmQbW3I3J6fE86Xe64WCrKuHQzooO3vsIi/emopDph2K0PWBxXsiO
   jpv5oa1wOPcHhfnT0Lx1b//T3QcwB2crr5fzCt9LiCAqGaBG1vGRy7lM5
   mJUmrUWy/aOS5vTrtS2uNXStcGxMa49QXYcURC5d1lhkD73KQo1B3zYHd
   N/hlR87jP5eQof2xwUPs1cOmaZi+OawWCDUe8YTHMG60OGlE92yDBQxsn
   mM4NIrytPRDiEhOjuJL4f6QRUs9pGLQFTA4R+xgSxGJL3bcMs2jr0EvQ2
   g==;
X-CSE-ConnectionGUID: 972Yn3yZRrK48/6V8Z8Kuw==
X-CSE-MsgGUID: cEpmpB5uRU2M4MiqXfin1g==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="15851730"
X-IronPort-AV: E=Sophos;i="6.08,166,1712646000"; 
   d="scan'208";a="15851730"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2024 18:59:11 -0700
X-CSE-ConnectionGUID: CNT/fEo6SwSom5nZfVz3+Q==
X-CSE-MsgGUID: pPKBAhxkS6eFBytinS7TpQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,166,1712646000"; 
   d="scan'208";a="36191348"
Received: from unknown (HELO 108735ec233b) ([10.239.97.151])
  by fmviesa004.fm.intel.com with ESMTP; 16 May 2024 18:59:09 -0700
Received: from kbuild by 108735ec233b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1s7mri-00002e-30;
	Fri, 17 May 2024 01:58:54 +0000
Date: Fri, 17 May 2024 09:57:58 +0800
From: kernel test robot <lkp@intel.com>
To: Gautam Menghani <gautam@linux.ibm.com>, mpe@ellerman.id.au,
	npiggin@gmail.com, christophe.leroy@csgroup.eu,
	naveen.n.rao@linux.ibm.com
Cc: oe-kbuild-all@lists.linux.dev, kvm@vger.kernel.org,
	Gautam Menghani <gautam@linux.ibm.com>,
	linux-kernel@vger.kernel.org, Naveen N Rao <naveen@kernel.org>,
	Vaibhav Jain <vaibhav@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v8] arch/powerpc/kvm: Add support for reading VPA
 counters for pseries guests
Message-ID: <202405170932.TL7G99IJ-lkp@intel.com>
References: <20240510104941.78410-1-gautam@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240510104941.78410-1-gautam@linux.ibm.com>

Hi Gautam,

kernel test robot noticed the following build errors:

[auto build test ERROR on powerpc/topic/ppc-kvm]
[also build test ERROR on powerpc/next powerpc/fixes kvm/queue mst-vhost/linux-next linus/master v6.9 next-20240516]
[cannot apply to kvm/linux-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Gautam-Menghani/arch-powerpc-kvm-Add-support-for-reading-VPA-counters-for-pseries-guests/20240510-185213
base:   https://git.kernel.org/pub/scm/linux/kernel/git/powerpc/linux.git topic/ppc-kvm
patch link:    https://lore.kernel.org/r/20240510104941.78410-1-gautam%40linux.ibm.com
patch subject: [PATCH v8] arch/powerpc/kvm: Add support for reading VPA counters for pseries guests
config: powerpc-allmodconfig (https://download.01.org/0day-ci/archive/20240517/202405170932.TL7G99IJ-lkp@intel.com/config)
compiler: powerpc64-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240517/202405170932.TL7G99IJ-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202405170932.TL7G99IJ-lkp@intel.com/

All errors (new ones prefixed by >>):

   powerpc64-linux-ld: warning: discarding dynamic section .glink
   powerpc64-linux-ld: warning: discarding dynamic section .plt
   powerpc64-linux-ld: linkage table error against `__traceiter_kvmppc_vcpu_stats'
   powerpc64-linux-ld: stubs don't match calculated size
   powerpc64-linux-ld: can not build stubs: bad value
   powerpc64-linux-ld: arch/powerpc/kvm/book3s_hv_nestedv2.o: in function `do_trace_nested_cs_time':
>> book3s_hv_nestedv2.c:(.text.do_trace_nested_cs_time+0x264): undefined reference to `__traceiter_kvmppc_vcpu_stats'
>> powerpc64-linux-ld: arch/powerpc/kvm/book3s_hv_nestedv2.o:(__jump_table+0x8): undefined reference to `__tracepoint_kvmppc_vcpu_stats'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

