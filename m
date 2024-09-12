Return-Path: <kvm+bounces-26731-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BD32976CC5
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 16:54:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A5230B250EB
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 14:54:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1966F1B5304;
	Thu, 12 Sep 2024 14:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XQHMPfWb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BB3F192B87
	for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 14:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726152819; cv=none; b=ny/9hgiy6Ote8WE77yenHfIBFUFEPRPE9ah+MSUXJicvr6rLmyQujpC5SdSfsg95FWszwcLwRZqCCEPSJW+s2EN+WCghwbvWpqrWzvGua8BS37kBeAV4WgijBMiAeyMAjKh8WS4GXw4gQFyCJDDI0yIFcqt2IjgKCgd3NP1rJwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726152819; c=relaxed/simple;
	bh=Mu1iveyIKRBj/frOcWiQg1pMR4qLnYURMBvJG04Pa9Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hVdGrR77JDn44yczAnli8q/HTWYYyQs2Z7HzW2fwzbUlPS0nGW1XlJjB9f+DnVQgJhz76LVnsnLpnDAV0QuyIGHKTnBCE/o0VS3ITa8bBOVWq9tGjmlndYl3NgWPN9Ft8EQp0TpXRMuiS1DFjtGB8D9XH2PIckCD5EkLiSgC85k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XQHMPfWb; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726152818; x=1757688818;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Mu1iveyIKRBj/frOcWiQg1pMR4qLnYURMBvJG04Pa9Y=;
  b=XQHMPfWb8wbK0i7H6YdWH5nujVb6xn9J86kFbhG6ui81JowEHyZ6V1Gd
   EcXOhoZIlhHVELnjcZRzMzxmL4AmmoKX/cwGdztvH+11N1y3BcE27ThFw
   Go2+hmtfJSwudEEcn+W81Bah2tiAhiiBGjPyr+UAyghwlxeYqiqCRqmYz
   sXD+wscuceEz6+Mmx7ey8TaoeSrLU7Ncv6uh2F1SeBmtT09XljhOSp5io
   nBVIcwVofbsqKkBpipOGIDEIBLI5ZMg7kcU0s9dwf7nw6cX6R+EcQjy/D
   vUhM3n/SmhaXfNkx0HVAzlWZBsXl1nezh7yLv9oCgfssIwEkZL6Az+kxD
   Q==;
X-CSE-ConnectionGUID: ghwj46slRb+to2M4pY76YA==
X-CSE-MsgGUID: ojAqG3G7QQeQZwzgK4U3eg==
X-IronPort-AV: E=McAfee;i="6700,10204,11193"; a="24836111"
X-IronPort-AV: E=Sophos;i="6.10,223,1719903600"; 
   d="scan'208";a="24836111"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2024 07:53:11 -0700
X-CSE-ConnectionGUID: dKmondxhQtWNkq6SQCgzLA==
X-CSE-MsgGUID: bpwUapB7SeGqCOj5+unffw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,223,1719903600"; 
   d="scan'208";a="67988216"
Received: from lkp-server01.sh.intel.com (HELO 53e96f405c61) ([10.239.97.150])
  by fmviesa010.fm.intel.com with ESMTP; 12 Sep 2024 07:53:03 -0700
Received: from kbuild by 53e96f405c61 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1solBt-0005Is-0j;
	Thu, 12 Sep 2024 14:53:01 +0000
Date: Thu, 12 Sep 2024 22:52:38 +0800
From: kernel test robot <lkp@intel.com>
To: Colton Lewis <coltonlewis@google.com>, kvm@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, Oliver Upton <oliver.upton@linux.dev>,
	Sean Christopherson <seanjc@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Will Deacon <will@kernel.org>, Russell King <linux@armlinux.org.uk>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Naveen N Rao <naveen@kernel.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v2 5/5] perf: Correct perf sampling with guest VMs
Message-ID: <202409122254.PnIe8ulL-lkp@intel.com>
References: <20240911222433.3415301-6-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240911222433.3415301-6-coltonlewis@google.com>

Hi Colton,

kernel test robot noticed the following build warnings:

[auto build test WARNING on perf-tools-next/perf-tools-next]
[also build test WARNING on tip/perf/core perf-tools/perf-tools acme/perf/core linus/master v6.11-rc7 next-20240912]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Colton-Lewis/arm-perf-Drop-unused-functions/20240912-063910
base:   https://git.kernel.org/pub/scm/linux/kernel/git/perf/perf-tools-next.git perf-tools-next
patch link:    https://lore.kernel.org/r/20240911222433.3415301-6-coltonlewis%40google.com
patch subject: [PATCH v2 5/5] perf: Correct perf sampling with guest VMs
config: x86_64-buildonly-randconfig-005-20240912 (https://download.01.org/0day-ci/archive/20240912/202409122254.PnIe8ulL-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240912/202409122254.PnIe8ulL-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202409122254.PnIe8ulL-lkp@intel.com/

All warnings (new ones prefixed by >>):

   arch/x86/events/core.c: In function 'perf_arch_misc_flags':
>> arch/x86/events/core.c:2971:22: warning: unused variable 'guest_state' [-Wunused-variable]
    2971 |         unsigned int guest_state = perf_guest_state();
         |                      ^~~~~~~~~~~


vim +/guest_state +2971 arch/x86/events/core.c

8f19518b57cef1 arch/x86/events/core.c           Colton Lewis        2024-09-11  2968  
a2d1490e40282f arch/x86/events/core.c           Colton Lewis        2024-09-11  2969  unsigned long perf_arch_misc_flags(struct pt_regs *regs)
39447b386c846b arch/x86/kernel/cpu/perf_event.c Zhang, Yanmin       2010-04-19  2970  {
1c3430516b0732 arch/x86/events/core.c           Sean Christopherson 2021-11-11 @2971  	unsigned int guest_state = perf_guest_state();
8f19518b57cef1 arch/x86/events/core.c           Colton Lewis        2024-09-11  2972  	unsigned long misc = common_misc_flags(regs);
dcf46b9443ad48 arch/x86/kernel/cpu/perf_event.c Zhang, Yanmin       2010-04-20  2973  
d07bdfd322d307 arch/x86/kernel/cpu/perf_event.c Peter Zijlstra      2012-07-10  2974  	if (user_mode(regs))
dcf46b9443ad48 arch/x86/kernel/cpu/perf_event.c Zhang, Yanmin       2010-04-20  2975  		misc |= PERF_RECORD_MISC_USER;
dcf46b9443ad48 arch/x86/kernel/cpu/perf_event.c Zhang, Yanmin       2010-04-20  2976  	else
dcf46b9443ad48 arch/x86/kernel/cpu/perf_event.c Zhang, Yanmin       2010-04-20  2977  		misc |= PERF_RECORD_MISC_KERNEL;
dcf46b9443ad48 arch/x86/kernel/cpu/perf_event.c Zhang, Yanmin       2010-04-20  2978  
39447b386c846b arch/x86/kernel/cpu/perf_event.c Zhang, Yanmin       2010-04-19  2979  	return misc;
39447b386c846b arch/x86/kernel/cpu/perf_event.c Zhang, Yanmin       2010-04-19  2980  }
b3d9468a8bd218 arch/x86/kernel/cpu/perf_event.c Gleb Natapov        2011-11-10  2981  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

