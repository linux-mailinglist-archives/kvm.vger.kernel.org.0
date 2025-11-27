Return-Path: <kvm+bounces-64853-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 6814EC8D876
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 10:25:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 77898346600
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 09:25:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE2C426F2AD;
	Thu, 27 Nov 2025 09:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="c4e16URe"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE53E328B68;
	Thu, 27 Nov 2025 09:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764235521; cv=none; b=SYWKHCFTBy23T7E0KQGuFOf8JP1FtDC5pYTbmYAatGGSPi/ALpM/QffzfqlMuvDILrbt3tzn89p03tm3kWlKQxM4nK1ykDytxbPGKX9+FLfyp5Olzx/goDn2ZufT0gikQtsbYeuVuucHpUUTeJ3Wl51Hx33KtG93lWMQtX0teEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764235521; c=relaxed/simple;
	bh=dKVw7WCI669xYparOitpzs+aXbeQn7xNAtOzxdtNdjc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lXHrV5U96XGFtp2fxvAMSuRANckVG3f//OaknH4hjJeGur3y+JkPUJMJaa1TRVN6rERUAHhX3LauIz3R1OB+vDVq8V3acjb+XU9jzEmPVFvtLUh6X/HxEUGXWpiaqbzUhAEI1xcwh7Bx7ZtZwmPNknwoYC9kHSVb81ldeymanB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=c4e16URe; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764235519; x=1795771519;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=dKVw7WCI669xYparOitpzs+aXbeQn7xNAtOzxdtNdjc=;
  b=c4e16URe+4KwjJbrvqDt+/jlu+qDpluOWG/5i18+Rn1ZzXOcplal0x0o
   XtCOGT7AUnNDEW1tEBpGbNkA448Ktx+OLvKgOCFsgiRCzhbUT7eCwuydm
   AWLODxfhVfYaJS4Kf3PNX420pq7wHbLCHoYVGg6/7x8r00bKT59omI63k
   S5DrkCvmQR/rU/oBWIw0MgIrFhXrLcnIORBkQROVoaxPkahduqoiqP7MT
   1bYvuM4deDUno+1cIy5rEzolHBVeUIKeKsiCYRJ9985MmIId4N+JXyz4Y
   Vs0o1LrGo1J6uz36abJ5CzFzEC+FRcOQ8UNBvOoYMyVzfW85Qz0d8cNF6
   w==;
X-CSE-ConnectionGUID: sTfybrIPQKOkX7+CCfGpVg==
X-CSE-MsgGUID: +uY72ZRoT5isL3cXbTGCMA==
X-IronPort-AV: E=McAfee;i="6800,10657,11625"; a="66226421"
X-IronPort-AV: E=Sophos;i="6.20,230,1758610800"; 
   d="scan'208";a="66226421"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2025 01:25:17 -0800
X-CSE-ConnectionGUID: qnUhwLQBRx2i3D9EMh7ltA==
X-CSE-MsgGUID: wTQgJDKGRmC9eSaGlBaXGQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,230,1758610800"; 
   d="scan'208";a="193000719"
Received: from lkp-server01.sh.intel.com (HELO 4664bbef4914) ([10.239.97.150])
  by orviesa009.jf.intel.com with ESMTP; 27 Nov 2025 01:25:10 -0800
Received: from kbuild by 4664bbef4914 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vOYFP-000000004CQ-2yB2;
	Thu, 27 Nov 2025 09:25:07 +0000
Date: Thu, 27 Nov 2025 17:24:20 +0800
From: kernel test robot <lkp@intel.com>
To: Juergen Gross <jgross@suse.com>, linux-kernel@vger.kernel.org,
	x86@kernel.org, linux-hyperv@vger.kernel.org,
	virtualization@lists.linux.dev, kvm@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, Juergen Gross <jgross@suse.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	xen-devel@lists.xenproject.org
Subject: Re: [PATCH v4 21/21] x86/pvlocks: Move paravirt spinlock functions
 into own header
Message-ID: <202511271704.MdDOB4pB-lkp@intel.com>
References: <20251127070844.21919-22-jgross@suse.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251127070844.21919-22-jgross@suse.com>

Hi Juergen,

kernel test robot noticed the following build errors:

[auto build test ERROR on tip/x86/core]
[also build test ERROR on tip/sched/core kvm/queue kvm/next linus/master v6.18-rc7]
[cannot apply to kvm/linux-next next-20251127]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Juergen-Gross/x86-paravirt-Remove-not-needed-includes-of-paravirt-h/20251127-152054
base:   tip/x86/core
patch link:    https://lore.kernel.org/r/20251127070844.21919-22-jgross%40suse.com
patch subject: [PATCH v4 21/21] x86/pvlocks: Move paravirt spinlock functions into own header
config: i386-allnoconfig (https://download.01.org/0day-ci/archive/20251127/202511271704.MdDOB4pB-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251127/202511271704.MdDOB4pB-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511271704.MdDOB4pB-lkp@intel.com/

All errors (new ones prefixed by >>):

   arch/x86/kernel/alternative.c: In function 'alternative_instructions':
>> arch/x86/kernel/alternative.c:2373:9: error: implicit declaration of function 'paravirt_set_cap'; did you mean 'paravirt_ret0'? [-Wimplicit-function-declaration]
    2373 |         paravirt_set_cap();
         |         ^~~~~~~~~~~~~~~~
         |         paravirt_ret0


vim +2373 arch/x86/kernel/alternative.c

270a69c4485d7d0 arch/x86/kernel/alternative.c  Peter Zijlstra            2023-02-08  2344  
9a0b5817ad97bb7 arch/i386/kernel/alternative.c Gerd Hoffmann             2006-03-23  2345  void __init alternative_instructions(void)
9a0b5817ad97bb7 arch/i386/kernel/alternative.c Gerd Hoffmann             2006-03-23  2346  {
ebebe30794d38c5 arch/x86/kernel/alternative.c  Pawan Gupta               2025-05-03  2347  	u64 ibt;
ebebe30794d38c5 arch/x86/kernel/alternative.c  Pawan Gupta               2025-05-03  2348  
7457c0da024b181 arch/x86/kernel/alternative.c  Peter Zijlstra            2019-05-03  2349  	int3_selftest();
7457c0da024b181 arch/x86/kernel/alternative.c  Peter Zijlstra            2019-05-03  2350  
7457c0da024b181 arch/x86/kernel/alternative.c  Peter Zijlstra            2019-05-03  2351  	/*
7457c0da024b181 arch/x86/kernel/alternative.c  Peter Zijlstra            2019-05-03  2352  	 * The patching is not fully atomic, so try to avoid local
7457c0da024b181 arch/x86/kernel/alternative.c  Peter Zijlstra            2019-05-03  2353  	 * interruptions that might execute the to be patched code.
7457c0da024b181 arch/x86/kernel/alternative.c  Peter Zijlstra            2019-05-03  2354  	 * Other CPUs are not running.
7457c0da024b181 arch/x86/kernel/alternative.c  Peter Zijlstra            2019-05-03  2355  	 */
8f4e956b313dccc arch/i386/kernel/alternative.c Andi Kleen                2007-07-22  2356  	stop_nmi();
123aa76ec0cab5d arch/x86/kernel/alternative.c  Andi Kleen                2009-02-12  2357  
123aa76ec0cab5d arch/x86/kernel/alternative.c  Andi Kleen                2009-02-12  2358  	/*
123aa76ec0cab5d arch/x86/kernel/alternative.c  Andi Kleen                2009-02-12  2359  	 * Don't stop machine check exceptions while patching.
123aa76ec0cab5d arch/x86/kernel/alternative.c  Andi Kleen                2009-02-12  2360  	 * MCEs only happen when something got corrupted and in this
123aa76ec0cab5d arch/x86/kernel/alternative.c  Andi Kleen                2009-02-12  2361  	 * case we must do something about the corruption.
32b1cbe380417f2 arch/x86/kernel/alternative.c  Marco Ammon               2019-09-02  2362  	 * Ignoring it is worse than an unlikely patching race.
123aa76ec0cab5d arch/x86/kernel/alternative.c  Andi Kleen                2009-02-12  2363  	 * Also machine checks tend to be broadcast and if one CPU
123aa76ec0cab5d arch/x86/kernel/alternative.c  Andi Kleen                2009-02-12  2364  	 * goes into machine check the others follow quickly, so we don't
123aa76ec0cab5d arch/x86/kernel/alternative.c  Andi Kleen                2009-02-12  2365  	 * expect a machine check to cause undue problems during to code
123aa76ec0cab5d arch/x86/kernel/alternative.c  Andi Kleen                2009-02-12  2366  	 * patching.
123aa76ec0cab5d arch/x86/kernel/alternative.c  Andi Kleen                2009-02-12  2367  	 */
8f4e956b313dccc arch/i386/kernel/alternative.c Andi Kleen                2007-07-22  2368  
4e6292114c74122 arch/x86/kernel/alternative.c  Juergen Gross             2021-03-11  2369  	/*
f7af6977621a416 arch/x86/kernel/alternative.c  Juergen Gross             2023-12-10  2370  	 * Make sure to set (artificial) features depending on used paravirt
f7af6977621a416 arch/x86/kernel/alternative.c  Juergen Gross             2023-12-10  2371  	 * functions which can later influence alternative patching.
4e6292114c74122 arch/x86/kernel/alternative.c  Juergen Gross             2021-03-11  2372  	 */
4e6292114c74122 arch/x86/kernel/alternative.c  Juergen Gross             2021-03-11 @2373  	paravirt_set_cap();
4e6292114c74122 arch/x86/kernel/alternative.c  Juergen Gross             2021-03-11  2374  
ebebe30794d38c5 arch/x86/kernel/alternative.c  Pawan Gupta               2025-05-03  2375  	/* Keep CET-IBT disabled until caller/callee are patched */
ebebe30794d38c5 arch/x86/kernel/alternative.c  Pawan Gupta               2025-05-03  2376  	ibt = ibt_save(/*disable*/ true);
ebebe30794d38c5 arch/x86/kernel/alternative.c  Pawan Gupta               2025-05-03  2377  
931ab63664f02b1 arch/x86/kernel/alternative.c  Peter Zijlstra            2022-10-27  2378  	__apply_fineibt(__retpoline_sites, __retpoline_sites_end,
1d7e707af446134 arch/x86/kernel/alternative.c  Mike Rapoport (Microsoft  2025-01-26  2379) 			__cfi_sites, __cfi_sites_end, true);
026211c40b05548 arch/x86/kernel/alternative.c  Kees Cook                 2025-09-03  2380  	cfi_debug = false;
931ab63664f02b1 arch/x86/kernel/alternative.c  Peter Zijlstra            2022-10-27  2381  
7508500900814d1 arch/x86/kernel/alternative.c  Peter Zijlstra            2021-10-26  2382  	/*
7508500900814d1 arch/x86/kernel/alternative.c  Peter Zijlstra            2021-10-26  2383  	 * Rewrite the retpolines, must be done before alternatives since
7508500900814d1 arch/x86/kernel/alternative.c  Peter Zijlstra            2021-10-26  2384  	 * those can rewrite the retpoline thunks.
7508500900814d1 arch/x86/kernel/alternative.c  Peter Zijlstra            2021-10-26  2385  	 */
1d7e707af446134 arch/x86/kernel/alternative.c  Mike Rapoport (Microsoft  2025-01-26  2386) 	apply_retpolines(__retpoline_sites, __retpoline_sites_end);
1d7e707af446134 arch/x86/kernel/alternative.c  Mike Rapoport (Microsoft  2025-01-26  2387) 	apply_returns(__return_sites, __return_sites_end);
7508500900814d1 arch/x86/kernel/alternative.c  Peter Zijlstra            2021-10-26  2388  
a82b26451de126a arch/x86/kernel/alternative.c  Peter Zijlstra (Intel     2025-06-03  2389) 	its_fini_core();
a82b26451de126a arch/x86/kernel/alternative.c  Peter Zijlstra (Intel     2025-06-03  2390) 
e81dc127ef69887 arch/x86/kernel/alternative.c  Thomas Gleixner           2022-09-15  2391  	/*
ab9fea59487d8b5 arch/x86/kernel/alternative.c  Peter Zijlstra            2025-02-07  2392  	 * Adjust all CALL instructions to point to func()-10, including
ab9fea59487d8b5 arch/x86/kernel/alternative.c  Peter Zijlstra            2025-02-07  2393  	 * those in .altinstr_replacement.
e81dc127ef69887 arch/x86/kernel/alternative.c  Thomas Gleixner           2022-09-15  2394  	 */
e81dc127ef69887 arch/x86/kernel/alternative.c  Thomas Gleixner           2022-09-15  2395  	callthunks_patch_builtin_calls();
e81dc127ef69887 arch/x86/kernel/alternative.c  Thomas Gleixner           2022-09-15  2396  
ab9fea59487d8b5 arch/x86/kernel/alternative.c  Peter Zijlstra            2025-02-07  2397  	apply_alternatives(__alt_instructions, __alt_instructions_end);
ab9fea59487d8b5 arch/x86/kernel/alternative.c  Peter Zijlstra            2025-02-07  2398  
be0fffa5ca894a9 arch/x86/kernel/alternative.c  Peter Zijlstra            2023-06-22  2399  	/*
be0fffa5ca894a9 arch/x86/kernel/alternative.c  Peter Zijlstra            2023-06-22  2400  	 * Seal all functions that do not have their address taken.
be0fffa5ca894a9 arch/x86/kernel/alternative.c  Peter Zijlstra            2023-06-22  2401  	 */
1d7e707af446134 arch/x86/kernel/alternative.c  Mike Rapoport (Microsoft  2025-01-26  2402) 	apply_seal_endbr(__ibt_endbr_seal, __ibt_endbr_seal_end);
ed53a0d971926e4 arch/x86/kernel/alternative.c  Peter Zijlstra            2022-03-08  2403  
ebebe30794d38c5 arch/x86/kernel/alternative.c  Pawan Gupta               2025-05-03  2404  	ibt_restore(ibt);
ebebe30794d38c5 arch/x86/kernel/alternative.c  Pawan Gupta               2025-05-03  2405  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

