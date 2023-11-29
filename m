Return-Path: <kvm+bounces-2713-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 33F6C7FCD07
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 03:42:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DE8151F20FF1
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 02:42:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84A484C6D;
	Wed, 29 Nov 2023 02:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q0HGjJjq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 618B71707;
	Tue, 28 Nov 2023 18:42:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701225725; x=1732761725;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Mubz9Exmpr4/3rGVakHcVmpeHzDMQMlVnqjaNJ8UhQY=;
  b=Q0HGjJjqJ9WgQFN/VsxjFZWMEfGzA//CLMGVGkUsbQCS3krmGDNwG03t
   uzM/jQvnm+Dqo4G09A8e94kawVk1atwjdivzzNb5PTI10IzWjzh1niLTW
   e/lyX1rLPvpQmeU5Zg+nPUaKfzIS4hhgOTl146kL15WCwwDsgwY69Am+i
   xUIVgXH7ubbNGsnEYr8T+nisGcbkuNbzg6r9KUqbwyY4QfmGMt86z+sBy
   wKnMS3haQuPF+O9BDkzS930r9oXruihQfs3Zq5bqg5fJELqfSA4XMmkPD
   gc8U+wGe+u7tz0q4OxZRO0XIb9/REEt8UKAovFFZNE13X0YmfI5iNNoca
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10908"; a="395897473"
X-IronPort-AV: E=Sophos;i="6.04,234,1695711600"; 
   d="scan'208";a="395897473"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2023 18:42:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10908"; a="768749641"
X-IronPort-AV: E=Sophos;i="6.04,234,1695711600"; 
   d="scan'208";a="768749641"
Received: from lkp-server01.sh.intel.com (HELO d584ee6ebdcc) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 28 Nov 2023 18:42:00 -0800
Received: from kbuild by d584ee6ebdcc with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1r8AWU-0008SR-29;
	Wed, 29 Nov 2023 02:41:58 +0000
Date: Wed, 29 Nov 2023 10:40:31 +0800
From: kernel test robot <lkp@intel.com>
To: Nikunj A Dadhania <nikunj@amd.com>, linux-kernel@vger.kernel.org,
	thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, bp@alien8.de,
	mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
	dionnaglaze@google.com, pgonda@google.com, seanjc@google.com,
	pbonzini@redhat.com, nikunj@amd.com
Subject: Re: [PATCH v6 07/16] x86/sev: Move and reorganize sev guest request
 api
Message-ID: <202311290851.yrAyZYIl-lkp@intel.com>
References: <20231128125959.1810039-8-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231128125959.1810039-8-nikunj@amd.com>

Hi Nikunj,

kernel test robot noticed the following build warnings:

[auto build test WARNING on tip/x86/mm]
[also build test WARNING on linus/master v6.7-rc3 next-20231128]
[cannot apply to tip/x86/core kvm/queue kvm/linux-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Nikunj-A-Dadhania/virt-sev-guest-Move-mutex-to-SNP-guest-device-structure/20231128-220026
base:   tip/x86/mm
patch link:    https://lore.kernel.org/r/20231128125959.1810039-8-nikunj%40amd.com
patch subject: [PATCH v6 07/16] x86/sev: Move and reorganize sev guest request api
config: x86_64-rhel-8.3-rust (https://download.01.org/0day-ci/archive/20231129/202311290851.yrAyZYIl-lkp@intel.com/config)
compiler: clang version 16.0.4 (https://github.com/llvm/llvm-project.git ae42196bc493ffe877a7e3dff8be32035dea4d07)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231129/202311290851.yrAyZYIl-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202311290851.yrAyZYIl-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> arch/x86/kernel/sev.c:2404:6: warning: variable 'ret' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
           if (!pdata->layout) {
               ^~~~~~~~~~~~~~
   arch/x86/kernel/sev.c:2446:9: note: uninitialized use occurs here
           return ret;
                  ^~~
   arch/x86/kernel/sev.c:2404:2: note: remove the 'if' if its condition is always false
           if (!pdata->layout) {
           ^~~~~~~~~~~~~~~~~~~~~
   arch/x86/kernel/sev.c:2380:9: note: initialize the variable 'ret' to silence this warning
           int ret;
                  ^
                   = 0
   1 warning generated.


vim +2404 arch/x86/kernel/sev.c

  2376	
  2377	int snp_setup_psp_messaging(struct snp_guest_dev *snp_dev)
  2378	{
  2379		struct sev_guest_platform_data *pdata;
  2380		int ret;
  2381	
  2382		if (!cc_platform_has(CC_ATTR_GUEST_SEV_SNP)) {
  2383			pr_err("SNP not supported\n");
  2384			return 0;
  2385		}
  2386	
  2387		if (platform_data) {
  2388			pr_debug("SNP platform data already initialized.\n");
  2389			goto create_ctx;
  2390		}
  2391	
  2392		if (!secrets_pa) {
  2393			pr_err("SNP secrets page not found\n");
  2394			return -ENODEV;
  2395		}
  2396	
  2397		pdata = kzalloc(sizeof(struct sev_guest_platform_data), GFP_KERNEL);
  2398		if (!pdata) {
  2399			pr_err("Allocation of SNP guest platform data failed\n");
  2400			return -ENOMEM;
  2401		}
  2402	
  2403		pdata->layout = (__force void *)ioremap_encrypted(secrets_pa, PAGE_SIZE);
> 2404		if (!pdata->layout) {
  2405			pr_err("Failed to map SNP secrets page.\n");
  2406			goto e_free_pdata;
  2407		}
  2408	
  2409		ret = -ENOMEM;
  2410		/* Allocate the shared page used for the request and response message. */
  2411		pdata->request = alloc_shared_pages(sizeof(struct snp_guest_msg));
  2412		if (!pdata->request)
  2413			goto e_unmap;
  2414	
  2415		pdata->response = alloc_shared_pages(sizeof(struct snp_guest_msg));
  2416		if (!pdata->response)
  2417			goto e_free_request;
  2418	
  2419		/* initial the input address for guest request */
  2420		pdata->input.req_gpa = __pa(pdata->request);
  2421		pdata->input.resp_gpa = __pa(pdata->response);
  2422		platform_data = pdata;
  2423	
  2424	create_ctx:
  2425		ret = -EIO;
  2426		snp_dev->ctx = snp_init_crypto(snp_dev->vmpck_id);
  2427		if (!snp_dev->ctx) {
  2428			pr_err("SNP crypto context initialization failed\n");
  2429			platform_data = NULL;
  2430			goto e_free_response;
  2431		}
  2432	
  2433		snp_dev->pdata = platform_data;
  2434	
  2435		return 0;
  2436	
  2437	e_free_response:
  2438		free_shared_pages(pdata->response, sizeof(struct snp_guest_msg));
  2439	e_free_request:
  2440		free_shared_pages(pdata->request, sizeof(struct snp_guest_msg));
  2441	e_unmap:
  2442		iounmap(pdata->layout);
  2443	e_free_pdata:
  2444		kfree(pdata);
  2445	
  2446		return ret;
  2447	}
  2448	EXPORT_SYMBOL_GPL(snp_setup_psp_messaging);
  2449	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

