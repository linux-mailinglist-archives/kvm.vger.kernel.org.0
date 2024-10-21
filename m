Return-Path: <kvm+bounces-29313-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C99C29A920B
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 23:31:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8B1CE2836AD
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 21:31:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC2BF10A3E;
	Mon, 21 Oct 2024 21:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cvnBhXoh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B41E198A24;
	Mon, 21 Oct 2024 21:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729546256; cv=none; b=BxBn8GxF39e/RnUiOohHX1IjQR9fxYoA92DEWwf/ExddlmlgMgUdFejJnDONFxfby+UCoMFdflhXnn2GleqqD+3TygjtP02cJUPAE32VgSnu92ihhgfS2TmPsooxOXbKPY2e25iujW2gXYxC/FXCRAFdJ2PzZudZne5Q0+n4al4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729546256; c=relaxed/simple;
	bh=2K2BnL01mudXgYs2bPVCK/91kCes0pjgE95Z2IWenrs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=miCgiRsytUzODmK158M7aXXt58vgp+CJHbAT0h8BfPqj991sPY6qibDvnAi5D/xzDEa1ollpgJNIVkgnV7QNt2COCgPEPWL7RXgHBQXYLpyOuLWTjatHHjgALivvWlC+i1Zkn2LVTENwyPjww06U4iQ1Ht/5nQ+FO1Y9Hn9NXL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cvnBhXoh; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729546256; x=1761082256;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=2K2BnL01mudXgYs2bPVCK/91kCes0pjgE95Z2IWenrs=;
  b=cvnBhXohNjP2sC8B7zW6kInjxB/kH6sJeMPZWaxqFXMkhyASPxY5vDji
   yS+b+19SJm9ouJRF6FSuEQTBs6Q1hHvWDRWszmIp5g2bKggWXAJ9SSkmp
   JlRBmK60o6ELjs0lyRRfHgIeq/IRwEcqmbz5+LQ52SLbE96QRjNSp/9/7
   1pcrz2hYlg+6tCQWIscH0zuWCb9nj3/LgQiAgjLzRKmu+FKlEP0JWdUmU
   LuZSa8K+NWfHjNv2dE6ot0S2JWPyJrkeXs/+r7Q4/J5nJN/K05ROkrAAD
   m+nI0VJS3vlnkLfVUWkv2dcynOOGMh8h7wWN964eTiNKUeMGZPEuj7n8n
   w==;
X-CSE-ConnectionGUID: cz+R+/RBS+2N7xqPAOsUXg==
X-CSE-MsgGUID: ZXTNt25fTmqBThCd9z4FTg==
X-IronPort-AV: E=McAfee;i="6700,10204,11232"; a="40439551"
X-IronPort-AV: E=Sophos;i="6.11,221,1725346800"; 
   d="scan'208";a="40439551"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2024 14:30:55 -0700
X-CSE-ConnectionGUID: dnBnO5ydQambEqaZt6MSaw==
X-CSE-MsgGUID: jKCVjk7jRa+WHsExy0JzQw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,221,1725346800"; 
   d="scan'208";a="117075239"
Received: from lkp-server01.sh.intel.com (HELO a48cf1aa22e8) ([10.239.97.150])
  by orviesa001.jf.intel.com with ESMTP; 21 Oct 2024 14:30:51 -0700
Received: from kbuild by a48cf1aa22e8 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1t2zzE-000Sf3-2C;
	Mon, 21 Oct 2024 21:30:48 +0000
Date: Tue, 22 Oct 2024 05:30:06 +0800
From: kernel test robot <lkp@intel.com>
To: Nikunj A Dadhania <nikunj@amd.com>, linux-kernel@vger.kernel.org,
	thomas.lendacky@amd.com, bp@alien8.de, x86@kernel.org,
	kvm@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, mingo@redhat.com,
	tglx@linutronix.de, dave.hansen@linux.intel.com, pgonda@google.com,
	seanjc@google.com, pbonzini@redhat.com, nikunj@amd.com,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Juergen Gross <jgross@suse.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH v13 11/13] tsc: Switch to native sched clock
Message-ID: <202410220542.6y7YYM8W-lkp@intel.com>
References: <20241021055156.2342564-12-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241021055156.2342564-12-nikunj@amd.com>

Hi Nikunj,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 0a895c0d9b73d934de95aa0dd4e631c394bdd25d]

url:    https://github.com/intel-lab-lkp/linux/commits/Nikunj-A-Dadhania/x86-sev-Carve-out-and-export-SNP-guest-messaging-init-routines/20241021-140125
base:   0a895c0d9b73d934de95aa0dd4e631c394bdd25d
patch link:    https://lore.kernel.org/r/20241021055156.2342564-12-nikunj%40amd.com
patch subject: [PATCH v13 11/13] tsc: Switch to native sched clock
config: x86_64-allnoconfig (https://download.01.org/0day-ci/archive/20241022/202410220542.6y7YYM8W-lkp@intel.com/config)
compiler: clang version 18.1.8 (https://github.com/llvm/llvm-project 3b5b5c1ec4a3095ab096dd780e84d7ab81f3d7ff)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241022/202410220542.6y7YYM8W-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202410220542.6y7YYM8W-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> arch/x86/kernel/tsc.c:293:6: warning: no previous prototype for function 'enable_native_sched_clock' [-Wmissing-prototypes]
     293 | void enable_native_sched_clock(void) { }
         |      ^
   arch/x86/kernel/tsc.c:293:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
     293 | void enable_native_sched_clock(void) { }
         | ^
         | static 
   1 warning generated.


vim +/enable_native_sched_clock +293 arch/x86/kernel/tsc.c

   292	
 > 293	void enable_native_sched_clock(void) { }
   294	#endif
   295	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

