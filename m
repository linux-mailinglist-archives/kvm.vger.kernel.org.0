Return-Path: <kvm+bounces-17712-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E299B8C8D90
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 23:14:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 58C8CB22309
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 21:14:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71BB51411D1;
	Fri, 17 May 2024 21:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gvOYwMia"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95A1D1A2C20;
	Fri, 17 May 2024 21:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715980474; cv=none; b=Hl52mp4gbbw9wd15+xS+0A9C5y4i6+LwzpGv8s1gg7Hbzk8+6idGpmzO4jdwTcUySgwNyZHODO21y2ou/TT1ikGQbeVjZXFjZdS0JtFfImNYXqdnULRvl2UEPSaVXyFUOz4hTxSnvlfC9nkZEg2KCsib+MdG8kdFG1cCv4bJ/GQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715980474; c=relaxed/simple;
	bh=PbwdGeHYEsTxVaXokH+G/Dg9Oj++01l9iIV7peZfMmY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j47fEfu6qPsuSojb1s1Cc50ZLsNttzrcdPkzGm0Z8mtDzOzYxI9Ts7i4on7xRFy4MbRsyNmGgq7jw5SPp30N8PAREA7cU+6eQIdABKPC7rLDmuKNHEd8DEsKWkCgsCvTr7mhpBb1FUhZFKtJL0rCr1pL2YzYKW4myUyAtjbdCDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gvOYwMia; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715980473; x=1747516473;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=PbwdGeHYEsTxVaXokH+G/Dg9Oj++01l9iIV7peZfMmY=;
  b=gvOYwMiaaQUNqGZQuPCCnXxyMM5WKhEWIwmkN6dIpAbQH3UkEk6dF87v
   /h9UbvvzTH0XjHBnvmGu7GDGkZiKpvOogACn17AtpHgeYve6vrWARHWkE
   ux7e7awP28QPttnpnYubE8kAMY5gDDTFc+KNQ4wfs/209aiFybLWbnRds
   9qMGlml9wXIP78F8i2l4tbm/QKiy2jlvwSJlJis8hWv3Tgm25UmoJrP/W
   0q4ayHcZptIzXFpQzxrzVQlDWq+iGVPzV3+0pGQwlikck6MPnT81muJtj
   Vs4iQrVueq1FURqUtQlPTUw1A7AH/qO1utCJKAc6SnV/xptN0xsWpl27z
   w==;
X-CSE-ConnectionGUID: VGfBkU6BQsaqzVk9JxngaQ==
X-CSE-MsgGUID: 64adxgiKQXCOPdiDTBi8IQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11075"; a="12355104"
X-IronPort-AV: E=Sophos;i="6.08,168,1712646000"; 
   d="scan'208";a="12355104"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2024 14:14:33 -0700
X-CSE-ConnectionGUID: 2UvPJbnoQx6Lk0q/A0sJiA==
X-CSE-MsgGUID: 4Rk2GkZ3SWiQ3BSZX0RCqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,168,1712646000"; 
   d="scan'208";a="31897496"
Received: from unknown (HELO 108735ec233b) ([10.239.97.151])
  by fmviesa008.fm.intel.com with ESMTP; 17 May 2024 14:14:25 -0700
Received: from kbuild by 108735ec233b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1s84rv-00018W-0T;
	Fri, 17 May 2024 21:13:13 +0000
Date: Sat, 18 May 2024 05:11:55 +0800
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
Message-ID: <202405180535.YOmK4BgA-lkp@intel.com>
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
[also build test ERROR on powerpc/next powerpc/fixes kvm/queue mst-vhost/linux-next linus/master v6.9 next-20240517]
[cannot apply to kvm/linux-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Gautam-Menghani/arch-powerpc-kvm-Add-support-for-reading-VPA-counters-for-pseries-guests/20240510-185213
base:   https://git.kernel.org/pub/scm/linux/kernel/git/powerpc/linux.git topic/ppc-kvm
patch link:    https://lore.kernel.org/r/20240510104941.78410-1-gautam%40linux.ibm.com
patch subject: [PATCH v8] arch/powerpc/kvm: Add support for reading VPA counters for pseries guests
config: powerpc-ppc64_defconfig (https://download.01.org/0day-ci/archive/20240518/202405180535.YOmK4BgA-lkp@intel.com/config)
compiler: powerpc64-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240518/202405180535.YOmK4BgA-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202405180535.YOmK4BgA-lkp@intel.com/

All errors (new ones prefixed by >>):

   powerpc64-linux-ld: warning: discarding dynamic section .glink
   powerpc64-linux-ld: warning: discarding dynamic section .plt
   powerpc64-linux-ld: linkage table error against `__traceiter_kvmppc_vcpu_stats'
   powerpc64-linux-ld: stubs don't match calculated size
   powerpc64-linux-ld: can not build stubs: bad value
   powerpc64-linux-ld: arch/powerpc/kvm/book3s_hv_nestedv2.o: in function `do_trace_nested_cs_time':
>> book3s_hv_nestedv2.c:(.text+0x4b4): undefined reference to `__traceiter_kvmppc_vcpu_stats'
   powerpc64-linux-ld: arch/powerpc/kvm/book3s_hv_nestedv2.o:(__jump_table+0x8): undefined reference to `__tracepoint_kvmppc_vcpu_stats'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

