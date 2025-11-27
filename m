Return-Path: <kvm+bounces-64798-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id A590CC8C7F7
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 02:05:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 3467B4E5B97
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 01:05:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89E2A29346F;
	Thu, 27 Nov 2025 01:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YQ0v8MEa"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D17702773F4;
	Thu, 27 Nov 2025 01:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764205539; cv=none; b=P2lik7yZjL35o7LlCHDVpXaEcfA6bJJv1rMLISDj/W+jyANoHcC1oKAh09yY69oUmD5wSWtsZcEoVlhQAsx/ku1yDWIHYQF/CgOAYVqvAREHU6FKXMUc/oYBJJMLWsruDdPEuO5qFZJ3UZQJxiE17UuWcAIXsOVT4ldAn+Rzjyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764205539; c=relaxed/simple;
	bh=WZ0WKykRJQw4J/W4spMQxkjY/MdBH3bIVjZr9mxhDN0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WG0o0tpxsm9VqGfoWwxwb45XcJSCjIVihpSPnV3zUuHe3pQ1bJ7xtrviczHfR9xbLCKAmnhsQuYFgUncRnzGtWIUwIvNeihaWuUHKqJohXGWc46j1witm2NTruHXbGU1FkYMRXe/bzDjryeq7DcDVK8xJyQAG2XffWtkqEsE9n4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YQ0v8MEa; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764205537; x=1795741537;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=WZ0WKykRJQw4J/W4spMQxkjY/MdBH3bIVjZr9mxhDN0=;
  b=YQ0v8MEaLaOaRLxcBYjuEHszovxBY2NZi06TQral/SbmKV1RLkpH5uQ1
   P2ZLSPpaw/LM0ixdkvi7cKaOESN8xF+q4JJgzOU9nQs0/VIKCNB4jAFGv
   H6Zuh2t9/eDU4sN2zjFDPffteT1IzdLX9WR58remBbeK8NP6HzVTr+eOm
   1Dtv6EH3atMhFXSTbDoCQskOaD7Lx6zg4sDJMS3ZhFjWIGYvQY4YcGCN+
   IP273va71umIm+CNr+YWvD+w5gDfzh4cmABVEBoeXM8UOuifOuNkOfvL/
   IeBEHqla2Q52v7DWicjg8CDWyREfhVK5tocoRo1OlOK0JG3wN/ahT12pl
   Q==;
X-CSE-ConnectionGUID: vR43UL65ThmgIWqXxOa2RA==
X-CSE-MsgGUID: qrWNMXgHTBqT2tAGdv2XTg==
X-IronPort-AV: E=McAfee;i="6800,10657,11625"; a="70112306"
X-IronPort-AV: E=Sophos;i="6.20,229,1758610800"; 
   d="scan'208";a="70112306"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 17:05:37 -0800
X-CSE-ConnectionGUID: ymgDICuaTi+tFFCtw1/gvw==
X-CSE-MsgGUID: Gh5MCfipTmWFGtvG6Dg4aw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,229,1758610800"; 
   d="scan'208";a="224047470"
Received: from lkp-server01.sh.intel.com (HELO 4664bbef4914) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 26 Nov 2025 17:05:32 -0800
Received: from kbuild by 4664bbef4914 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vOQRt-000000003WX-3mtV;
	Thu, 27 Nov 2025 01:05:29 +0000
Date: Thu, 27 Nov 2025 09:04:41 +0800
From: kernel test robot <lkp@intel.com>
To: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, x86@kernel.org,
	David Kaplan <david.kaplan@amd.com>,
	Nikolay Borisov <nik.borisov@suse.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Asit Mallick <asit.k.mallick@intel.com>,
	Tao Zhang <tao1.zhang@intel.com>
Subject: Re: [PATCH v5 4/9] x86/vmscape: Move mitigation selection to a
 switch()
Message-ID: <202511270829.xMEXUXCW-lkp@intel.com>
References: <20251126-vmscape-bhb-v5-4-02d66e423b00@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251126-vmscape-bhb-v5-4-02d66e423b00@linux.intel.com>

Hi Pawan,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 6a23ae0a96a600d1d12557add110e0bb6e32730c]

url:    https://github.com/intel-lab-lkp/linux/commits/Pawan-Gupta/x86-bhi-x86-vmscape-Move-LFENCE-out-of-clear_bhb_loop/20251127-061843
base:   6a23ae0a96a600d1d12557add110e0bb6e32730c
patch link:    https://lore.kernel.org/r/20251126-vmscape-bhb-v5-4-02d66e423b00%40linux.intel.com
patch subject: [PATCH v5 4/9] x86/vmscape: Move mitigation selection to a switch()
config: x86_64-allnoconfig (https://download.01.org/0day-ci/archive/20251127/202511270829.xMEXUXCW-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251127/202511270829.xMEXUXCW-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511270829.xMEXUXCW-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> arch/x86/kernel/cpu/bugs.c:3260:2: warning: label at end of compound statement is a C23 extension [-Wc23-extensions]
    3260 |         }
         |         ^
   1 warning generated.


vim +3260 arch/x86/kernel/cpu/bugs.c

556c1ad666ad90 Pawan Gupta  2025-08-14  3231  
556c1ad666ad90 Pawan Gupta  2025-08-14  3232  static void __init vmscape_select_mitigation(void)
556c1ad666ad90 Pawan Gupta  2025-08-14  3233  {
0091dd36e9ee51 Pawan Gupta  2025-11-26  3234  	if (!boot_cpu_has_bug(X86_BUG_VMSCAPE)) {
556c1ad666ad90 Pawan Gupta  2025-08-14  3235  		vmscape_mitigation = VMSCAPE_MITIGATION_NONE;
556c1ad666ad90 Pawan Gupta  2025-08-14  3236  		return;
556c1ad666ad90 Pawan Gupta  2025-08-14  3237  	}
556c1ad666ad90 Pawan Gupta  2025-08-14  3238  
0091dd36e9ee51 Pawan Gupta  2025-11-26  3239  	if ((vmscape_mitigation == VMSCAPE_MITIGATION_AUTO) &&
0091dd36e9ee51 Pawan Gupta  2025-11-26  3240  	    !should_mitigate_vuln(X86_BUG_VMSCAPE))
0091dd36e9ee51 Pawan Gupta  2025-11-26  3241  		vmscape_mitigation = VMSCAPE_MITIGATION_NONE;
0091dd36e9ee51 Pawan Gupta  2025-11-26  3242  
0091dd36e9ee51 Pawan Gupta  2025-11-26  3243  	switch (vmscape_mitigation) {
0091dd36e9ee51 Pawan Gupta  2025-11-26  3244  	case VMSCAPE_MITIGATION_NONE:
0091dd36e9ee51 Pawan Gupta  2025-11-26  3245  		break;
0091dd36e9ee51 Pawan Gupta  2025-11-26  3246  
0091dd36e9ee51 Pawan Gupta  2025-11-26  3247  	case VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER:
0091dd36e9ee51 Pawan Gupta  2025-11-26  3248  		if (!boot_cpu_has(X86_FEATURE_IBPB))
0091dd36e9ee51 Pawan Gupta  2025-11-26  3249  			vmscape_mitigation = VMSCAPE_MITIGATION_NONE;
0091dd36e9ee51 Pawan Gupta  2025-11-26  3250  		break;
0091dd36e9ee51 Pawan Gupta  2025-11-26  3251  
0091dd36e9ee51 Pawan Gupta  2025-11-26  3252  	case VMSCAPE_MITIGATION_AUTO:
0091dd36e9ee51 Pawan Gupta  2025-11-26  3253  		if (boot_cpu_has(X86_FEATURE_IBPB))
556c1ad666ad90 Pawan Gupta  2025-08-14  3254  			vmscape_mitigation = VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER;
5799d5d8a6c877 David Kaplan 2025-09-12  3255  		else
5799d5d8a6c877 David Kaplan 2025-09-12  3256  			vmscape_mitigation = VMSCAPE_MITIGATION_NONE;
0091dd36e9ee51 Pawan Gupta  2025-11-26  3257  		break;
0091dd36e9ee51 Pawan Gupta  2025-11-26  3258  
0091dd36e9ee51 Pawan Gupta  2025-11-26  3259  	default:
5799d5d8a6c877 David Kaplan 2025-09-12 @3260  	}
556c1ad666ad90 Pawan Gupta  2025-08-14  3261  }
556c1ad666ad90 Pawan Gupta  2025-08-14  3262  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

