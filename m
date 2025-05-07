Return-Path: <kvm+bounces-45691-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 37337AAD568
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 07:45:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5F33B3BA6BC
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 05:44:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50B5F1FCD1F;
	Wed,  7 May 2025 05:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MK6IJYal"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12B1C1EE7BE;
	Wed,  7 May 2025 05:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746596692; cv=none; b=O9djkFBl+NFfWFWaYzKaoVUdphgeCOSc9pj7Fun81y9YtubfB8v8rYVr0r6XJR4ZK3mYxd412btdcHTD3qhxiKyI2Mck8nt/w7LrdLQa5b4TXrDwCBAVcLSQMHzljg2/LXAPLnaEgYVYVYdUdMOb8WBC1UCcX1Uy7PXbRZvk4OY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746596692; c=relaxed/simple;
	bh=JQX+pNi+rd47yrsUf9LzXxL1bR3OCMpgA5gg847AdJU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UhEZpFpH/ZjWSPZPUdAJ2vMqSK/Ri4ONBplvnuVbTdq8Xmo5Aw3zezylvPcbXZ682/H7a1JnnQkZWFJPYDOlemYuwAnYx8PfbNkpdgQhViqdctKF+FhHMooOLmnOUbGFiw10cZio9+rlEJPKk7/rMgstVpUf2DmyAOKXUAYT+ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MK6IJYal; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746596690; x=1778132690;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=JQX+pNi+rd47yrsUf9LzXxL1bR3OCMpgA5gg847AdJU=;
  b=MK6IJYalkhLgDuZa2sGeIx0Rd0kXh4XubKcOw6OfbaIIGm9abJZWIACe
   /KUBBoy1ZhEv2iF8/VRW7cFI/Ub+3jegyiEElIOpn/sd0dIEyzrYfrKgM
   niZw9zLzD0/eA/72NxZMhEVBbwWRU7oVQOgakK4vSc8poFSJhcRVuDNkF
   YJFBjxHg7RB90b6d1st2vBArnbD8rnwfs4XXi3pqWzynWAbi3dDE4vRHA
   uRb0Yz7wuPTT8I/L/GJYYxcglpOB1y6XSM6pHgaSHEBpEpODPMgNU4Cdj
   qer9K+eUvOWEaqyWyt6AWE/zsrjQUPDBnqeO4bsTG4i1efefgMwdrodNK
   A==;
X-CSE-ConnectionGUID: GzO16g5DTF6yO5ZFZ+iT7g==
X-CSE-MsgGUID: 2GN5LkD1RPuSFNQQ1vYnaQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11425"; a="48202530"
X-IronPort-AV: E=Sophos;i="6.15,268,1739865600"; 
   d="scan'208";a="48202530"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2025 22:44:49 -0700
X-CSE-ConnectionGUID: h2ssVtyISB66sQtFkP2/BA==
X-CSE-MsgGUID: 1ljMQRoCQ7G7X1gly5+u1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,268,1739865600"; 
   d="scan'208";a="135844091"
Received: from lkp-server01.sh.intel.com (HELO 1992f890471c) ([10.239.97.150])
  by fmviesa007.fm.intel.com with ESMTP; 06 May 2025 22:44:45 -0700
Received: from kbuild by 1992f890471c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uCXaF-00076C-1W;
	Wed, 07 May 2025 05:44:43 +0000
Date: Wed, 7 May 2025 13:44:35 +0800
From: kernel test robot <lkp@intel.com>
To: Ashish Kalra <Ashish.Kalra@amd.com>, seanjc@google.com,
	pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
	bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
	herbert@gondor.apana.org.au
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, x86@kernel.org,
	john.allen@amd.com, davem@davemloft.net, thomas.lendacky@amd.com,
	michael.roth@amd.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v3 3/4] crypto: ccp: Add support to enable
 CipherTextHiding on SNP_INIT_EX
Message-ID: <202505071309.cJl7zfy2-lkp@intel.com>
References: <94ffa7595fca67cfdcd2352354791bdb6ac00499.1745279916.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <94ffa7595fca67cfdcd2352354791bdb6ac00499.1745279916.git.ashish.kalra@amd.com>

Hi Ashish,

kernel test robot noticed the following build errors:

[auto build test ERROR on next-20250417]
[cannot apply to herbert-cryptodev-2.6/master herbert-crypto-2.6/master kvm/queue kvm/next linus/master kvm/linux-next v6.15-rc3 v6.15-rc2 v6.15-rc1 v6.15-rc5]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Ashish-Kalra/crypto-ccp-New-bit-field-definitions-for-SNP_PLATFORM_STATUS-command/20250422-082725
base:   next-20250417
patch link:    https://lore.kernel.org/r/94ffa7595fca67cfdcd2352354791bdb6ac00499.1745279916.git.ashish.kalra%40amd.com
patch subject: [PATCH v3 3/4] crypto: ccp: Add support to enable CipherTextHiding on SNP_INIT_EX
config: i386-buildonly-randconfig-002-20250422 (https://download.01.org/0day-ci/archive/20250507/202505071309.cJl7zfy2-lkp@intel.com/config)
compiler: clang version 20.1.2 (https://github.com/llvm/llvm-project 58df0ef89dd64126512e4ee27b4ac3fd8ddf6247)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250507/202505071309.cJl7zfy2-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202505071309.cJl7zfy2-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from arch/x86/kvm/svm/svm.c:24:
>> include/linux/psp-sev.h:1035:74: error: use of undeclared identifier 'FALSE'
    1035 | static inline bool is_sev_snp_ciphertext_hiding_supported(void) { return FALSE; }
         |                                                                          ^
   1 error generated.


vim +/FALSE +1035 include/linux/psp-sev.h

  1034	
> 1035	static inline bool is_sev_snp_ciphertext_hiding_supported(void) { return FALSE; }
  1036	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

