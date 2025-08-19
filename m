Return-Path: <kvm+bounces-54983-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 97FBAB2C391
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 14:31:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A3F45189D166
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 12:26:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0DE23043B7;
	Tue, 19 Aug 2025 12:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iV/dvY8z"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66C82305078;
	Tue, 19 Aug 2025 12:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755606240; cv=none; b=Hns+nqUAbeu+pQ++PPoP7fTS10Min8F1hyMsIy7lQW6987CCUOdc2Xb6X7koSf0woG2Hh2dItAvI2aMC4CoPtZd5BK56gZCxBuR/R1SRblzp944l2HbrDqMjmgu5y9F8liZZoLtqU8ECj3naYrlw1Fw3E49crZcKuk9PwwNht5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755606240; c=relaxed/simple;
	bh=fI4hT8CuNMb2bjEOBw/jySCX58PyHsr/5lyNM6n1Y/M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JSgrPapZuOKmzug1fb8ygYkdbicXOh0JUqGM1/8OdbhFOXdZk3nmsSztBnDT2ogPwaQA+4ahAylLtur55zxelvJpvFD20YTostyWjwfQyvBcSf58qjSWZAd1b6wdRyaIXLCOeGEEVHfr8TkOhznmzm72HE364MT1qP/aCZdWttY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iV/dvY8z; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755606238; x=1787142238;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=fI4hT8CuNMb2bjEOBw/jySCX58PyHsr/5lyNM6n1Y/M=;
  b=iV/dvY8zESFhi7jwblHd4om2A637rKYwuMCbyS262ion8sEB1xc8xSxm
   bMx4hHiSW5Ap/GArYiy6jxcqu4kTGl7bu7mxv6AFMfr0XVqVL81R+SjJe
   CCOMc4T7UeZZcum7K7w8YK1TIrwx6VDT04W+OExnnfa/oEcWvO1tF5tfA
   KH/H+HKtWNkyUMoYPUNMFvnJklotU0/1YK2bFVbfuwI+Td/l2GxyMA+ct
   YgOmcYyc8mKxR7NtxL0euK8zfnMbEGayDkz1+V7pKxuG5BWrJK/+az+Yi
   VDrW9RiR0R6Ap6KrPTFypLkrhMM6vSlBEdeJA7Ffc0UJ9lJamUU6WIGA7
   g==;
X-CSE-ConnectionGUID: QmVrevXMTTOZXADd7xp30A==
X-CSE-MsgGUID: UAH4kCtwTF2Z0XWhqVFaVg==
X-IronPort-AV: E=McAfee;i="6800,10657,11526"; a="68556133"
X-IronPort-AV: E=Sophos;i="6.17,300,1747724400"; 
   d="scan'208";a="68556133"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2025 05:23:58 -0700
X-CSE-ConnectionGUID: kQGhHvgmRhy3OwX7KAoInA==
X-CSE-MsgGUID: UMzsUuHOSzqhndiWOT2Drg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,300,1747724400"; 
   d="scan'208";a="204987164"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by orviesa001.jf.intel.com with ESMTP; 19 Aug 2025 05:23:52 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uoLMb-000Gqh-0m;
	Tue, 19 Aug 2025 12:23:28 +0000
Date: Tue, 19 Aug 2025 20:22:01 +0800
From: kernel test robot <lkp@intel.com>
To: Ashish Kalra <Ashish.Kalra@amd.com>, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, seanjc@google.com,
	pbonzini@redhat.com, thomas.lendacky@amd.com,
	herbert@gondor.apana.org.au
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, nikunj@amd.com,
	davem@davemloft.net, aik@amd.com, ardb@kernel.org,
	michael.roth@amd.com, Neeraj.Upadhyay@amd.com,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: [RESEND PATCH v2 3/3] crypto: ccp - Add AMD Seamless Firmware
 Servicing (SFS) driver
Message-ID: <202508192016.ZlSGEWUC-lkp@intel.com>
References: <1f3398c19eab6701566f4044c2c1059114d9bc48.1755548015.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1f3398c19eab6701566f4044c2c1059114d9bc48.1755548015.git.ashish.kalra@amd.com>

Hi Ashish,

kernel test robot noticed the following build warnings:

[auto build test WARNING on next-20250818]
[cannot apply to herbert-cryptodev-2.6/master herbert-crypto-2.6/master tip/x86/core tip/master linus/master tip/auto-latest v6.17-rc2 v6.17-rc1 v6.16 v6.17-rc2]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Ashish-Kalra/x86-sev-Add-new-quiet-parameter-to-snp_leak_pages-API/20250819-042220
base:   next-20250818
patch link:    https://lore.kernel.org/r/1f3398c19eab6701566f4044c2c1059114d9bc48.1755548015.git.ashish.kalra%40amd.com
patch subject: [RESEND PATCH v2 3/3] crypto: ccp - Add AMD Seamless Firmware Servicing (SFS) driver
config: x86_64-rhel-9.4-rust (https://download.01.org/0day-ci/archive/20250819/202508192016.ZlSGEWUC-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
rustc: rustc 1.88.0 (6b00bc388 2025-06-23)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250819/202508192016.ZlSGEWUC-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508192016.ZlSGEWUC-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/crypto/ccp/sfs.c:262:6: warning: variable 'ret' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
     262 |         if (!page) {
         |             ^~~~~
   drivers/crypto/ccp/sfs.c:301:9: note: uninitialized use occurs here
     301 |         return ret;
         |                ^~~
   drivers/crypto/ccp/sfs.c:262:2: note: remove the 'if' if its condition is always false
     262 |         if (!page) {
         |         ^~~~~~~~~~~~
     263 |                 dev_dbg(dev, "Command Buffer HV-Fixed page allocation failed\n");
         |                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     264 |                 goto cleanup_dev;
         |                 ~~~~~~~~~~~~~~~~~
     265 |         }
         |         ~
   drivers/crypto/ccp/sfs.c:250:9: note: initialize the variable 'ret' to silence this warning
     250 |         int ret;
         |                ^
         |                 = 0
   1 warning generated.


vim +262 drivers/crypto/ccp/sfs.c

   244	
   245	int sfs_dev_init(struct psp_device *psp)
   246	{
   247		struct device *dev = psp->dev;
   248		struct sfs_device *sfs_dev;
   249		struct page *page;
   250		int ret;
   251	
   252		sfs_dev = devm_kzalloc(dev, sizeof(*sfs_dev), GFP_KERNEL);
   253		if (!sfs_dev)
   254			return -ENOMEM;
   255	
   256		/*
   257		 * Pre-allocate 2MB command buffer for all SFS commands using
   258		 * SNP HV_Fixed page allocator which also transitions the
   259		 * SFS command buffer to HV_Fixed page state if SNP is enabled.
   260		 */
   261		page = snp_alloc_hv_fixed_pages(SFS_NUM_2MB_PAGES_CMDBUF);
 > 262		if (!page) {

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

