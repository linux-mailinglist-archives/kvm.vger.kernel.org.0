Return-Path: <kvm+bounces-2687-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6928A7FC9F1
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 23:51:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 11517283104
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 22:51:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80D9D50255;
	Tue, 28 Nov 2023 22:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bEHLT8wK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A84DE19A4;
	Tue, 28 Nov 2023 14:51:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701211871; x=1732747871;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=EIWKmpw10W2gy/QBlGnv98l25AschMZIIelg6y9oG0E=;
  b=bEHLT8wKUrbEdFY8J5bc55eIyn6CCdQ2A1rI2v8SbD+A16gFXYSxD0cG
   +sXko8z/4zT+z2J/CK4NwpaOD3lcka9EqB6mKCo6y715mzmUZlkazaW8H
   hTeey1VuhENAlm8odSx8of2kNK07yU4O0eGg4PODAmnQasYIT5/hQRCme
   wUKAejqQ9VOSMK1/+oDvr01t77tRRuqllx0HRGsvv+oeuDB9WSUDvDXQp
   xQ7Alv+jwUG4k+KRDkPhqw8FkyAomBxwCsPfyjG6DDHbJd0GVCk4QYzhn
   8WvXdLQl9Vmpb3XvPEugcRR7HmMDlBYg4SMBTSbRLbERCj6DUDtJ1U+HO
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10908"; a="392797065"
X-IronPort-AV: E=Sophos;i="6.04,234,1695711600"; 
   d="scan'208";a="392797065"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2023 14:51:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10908"; a="942106666"
X-IronPort-AV: E=Sophos;i="6.04,234,1695711600"; 
   d="scan'208";a="942106666"
Received: from lkp-server01.sh.intel.com (HELO d584ee6ebdcc) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 28 Nov 2023 14:51:06 -0800
Received: from kbuild by d584ee6ebdcc with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1r86v2-0008E2-10;
	Tue, 28 Nov 2023 22:51:04 +0000
Date: Wed, 29 Nov 2023 06:50:58 +0800
From: kernel test robot <lkp@intel.com>
To: Nikunj A Dadhania <nikunj@amd.com>, linux-kernel@vger.kernel.org,
	thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, bp@alien8.de,
	mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
	dionnaglaze@google.com, pgonda@google.com, seanjc@google.com,
	pbonzini@redhat.com, nikunj@amd.com
Subject: Re: [PATCH v6 07/16] x86/sev: Move and reorganize sev guest request
 api
Message-ID: <202311290340.dJ5EmU8J-lkp@intel.com>
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
config: x86_64-allyesconfig (https://download.01.org/0day-ci/archive/20231129/202311290340.dJ5EmU8J-lkp@intel.com/config)
compiler: clang version 16.0.4 (https://github.com/llvm/llvm-project.git ae42196bc493ffe877a7e3dff8be32035dea4d07)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231129/202311290340.dJ5EmU8J-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202311290340.dJ5EmU8J-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/virt/coco/sev-guest/sev-guest.c:450:6: warning: variable 'ret' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
           if (!snp_dev->certs_data)
               ^~~~~~~~~~~~~~~~~~~~
   drivers/virt/coco/sev-guest/sev-guest.c:480:9: note: uninitialized use occurs here
           return ret;
                  ^~~
   drivers/virt/coco/sev-guest/sev-guest.c:450:2: note: remove the 'if' if its condition is always false
           if (!snp_dev->certs_data)
           ^~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/virt/coco/sev-guest/sev-guest.c:424:9: note: initialize the variable 'ret' to silence this warning
           int ret;
                  ^
                   = 0
   1 warning generated.


vim +450 drivers/virt/coco/sev-guest/sev-guest.c

f47906782c7629 drivers/virt/coco/sev-guest/sev-guest.c Dan Williams          2023-10-10  418  
2bf93ffbb97e06 drivers/virt/coco/sevguest/sevguest.c   Tom Lendacky          2022-04-20  419  static int __init sev_guest_probe(struct platform_device *pdev)
fce96cf0443083 drivers/virt/coco/sevguest/sevguest.c   Brijesh Singh         2022-03-07  420  {
fce96cf0443083 drivers/virt/coco/sevguest/sevguest.c   Brijesh Singh         2022-03-07  421  	struct device *dev = &pdev->dev;
fce96cf0443083 drivers/virt/coco/sevguest/sevguest.c   Brijesh Singh         2022-03-07  422  	struct snp_guest_dev *snp_dev;
fce96cf0443083 drivers/virt/coco/sevguest/sevguest.c   Brijesh Singh         2022-03-07  423  	struct miscdevice *misc;
fce96cf0443083 drivers/virt/coco/sevguest/sevguest.c   Brijesh Singh         2022-03-07  424  	int ret;
fce96cf0443083 drivers/virt/coco/sevguest/sevguest.c   Brijesh Singh         2022-03-07  425  
d6fd48eff7506b drivers/virt/coco/sev-guest/sev-guest.c Borislav Petkov (AMD  2023-02-15  426) 	if (!cc_platform_has(CC_ATTR_GUEST_SEV_SNP))
d6fd48eff7506b drivers/virt/coco/sev-guest/sev-guest.c Borislav Petkov (AMD  2023-02-15  427) 		return -ENODEV;
d6fd48eff7506b drivers/virt/coco/sev-guest/sev-guest.c Borislav Petkov (AMD  2023-02-15  428) 
fce96cf0443083 drivers/virt/coco/sevguest/sevguest.c   Brijesh Singh         2022-03-07  429  	snp_dev = devm_kzalloc(&pdev->dev, sizeof(struct snp_guest_dev), GFP_KERNEL);
fce96cf0443083 drivers/virt/coco/sevguest/sevguest.c   Brijesh Singh         2022-03-07  430  	if (!snp_dev)
81b918a5844565 drivers/virt/coco/sev-guest/sev-guest.c Nikunj A Dadhania     2023-11-28  431  		return -ENOMEM;
fce96cf0443083 drivers/virt/coco/sevguest/sevguest.c   Brijesh Singh         2022-03-07  432  
523ae6405daace drivers/virt/coco/sev-guest/sev-guest.c Nikunj A Dadhania     2023-11-28  433  	if (!snp_assign_vmpck(snp_dev, vmpck_id)) {
523ae6405daace drivers/virt/coco/sev-guest/sev-guest.c Nikunj A Dadhania     2023-11-28  434  		dev_err(dev, "invalid vmpck id %u\n", vmpck_id);
81b918a5844565 drivers/virt/coco/sev-guest/sev-guest.c Nikunj A Dadhania     2023-11-28  435  		ret = -EINVAL;
81b918a5844565 drivers/virt/coco/sev-guest/sev-guest.c Nikunj A Dadhania     2023-11-28  436  		goto e_free_snpdev;
fce96cf0443083 drivers/virt/coco/sevguest/sevguest.c   Brijesh Singh         2022-03-07  437  	}
fce96cf0443083 drivers/virt/coco/sevguest/sevguest.c   Brijesh Singh         2022-03-07  438  
81b918a5844565 drivers/virt/coco/sev-guest/sev-guest.c Nikunj A Dadhania     2023-11-28  439  	if (snp_setup_psp_messaging(snp_dev)) {
81b918a5844565 drivers/virt/coco/sev-guest/sev-guest.c Nikunj A Dadhania     2023-11-28  440  		dev_err(dev, "Unable to setup PSP messaging vmpck id %u\n", snp_dev->vmpck_id);
81b918a5844565 drivers/virt/coco/sev-guest/sev-guest.c Nikunj A Dadhania     2023-11-28  441  		ret = -ENODEV;
81b918a5844565 drivers/virt/coco/sev-guest/sev-guest.c Nikunj A Dadhania     2023-11-28  442  		goto e_free_snpdev;
fce96cf0443083 drivers/virt/coco/sevguest/sevguest.c   Brijesh Singh         2022-03-07  443  	}
fce96cf0443083 drivers/virt/coco/sevguest/sevguest.c   Brijesh Singh         2022-03-07  444  
4ec0ddf1cc3c0c drivers/virt/coco/sev-guest/sev-guest.c Nikunj A Dadhania     2023-11-28  445  	mutex_init(&snp_dev->cmd_mutex);
fce96cf0443083 drivers/virt/coco/sevguest/sevguest.c   Brijesh Singh         2022-03-07  446  	platform_set_drvdata(pdev, snp_dev);
fce96cf0443083 drivers/virt/coco/sevguest/sevguest.c   Brijesh Singh         2022-03-07  447  	snp_dev->dev = dev;
fce96cf0443083 drivers/virt/coco/sevguest/sevguest.c   Brijesh Singh         2022-03-07  448  
81b918a5844565 drivers/virt/coco/sev-guest/sev-guest.c Nikunj A Dadhania     2023-11-28  449  	snp_dev->certs_data = alloc_shared_pages(SEV_FW_BLOB_MAX_SIZE);
d80b494f712317 drivers/virt/coco/sevguest/sevguest.c   Brijesh Singh         2022-03-07 @450  	if (!snp_dev->certs_data)
81b918a5844565 drivers/virt/coco/sev-guest/sev-guest.c Nikunj A Dadhania     2023-11-28  451  		goto e_free_ctx;
fce96cf0443083 drivers/virt/coco/sevguest/sevguest.c   Brijesh Singh         2022-03-07  452  
fce96cf0443083 drivers/virt/coco/sevguest/sevguest.c   Brijesh Singh         2022-03-07  453  	misc = &snp_dev->misc;
fce96cf0443083 drivers/virt/coco/sevguest/sevguest.c   Brijesh Singh         2022-03-07  454  	misc->minor = MISC_DYNAMIC_MINOR;
fce96cf0443083 drivers/virt/coco/sevguest/sevguest.c   Brijesh Singh         2022-03-07  455  	misc->name = DEVICE_NAME;
fce96cf0443083 drivers/virt/coco/sevguest/sevguest.c   Brijesh Singh         2022-03-07  456  	misc->fops = &snp_guest_fops;
fce96cf0443083 drivers/virt/coco/sevguest/sevguest.c   Brijesh Singh         2022-03-07  457  
f47906782c7629 drivers/virt/coco/sev-guest/sev-guest.c Dan Williams          2023-10-10  458  	ret = tsm_register(&sev_tsm_ops, snp_dev, &tsm_report_extra_type);
f47906782c7629 drivers/virt/coco/sev-guest/sev-guest.c Dan Williams          2023-10-10  459  	if (ret)
f47906782c7629 drivers/virt/coco/sev-guest/sev-guest.c Dan Williams          2023-10-10  460  		goto e_free_cert_data;
f47906782c7629 drivers/virt/coco/sev-guest/sev-guest.c Dan Williams          2023-10-10  461  
f47906782c7629 drivers/virt/coco/sev-guest/sev-guest.c Dan Williams          2023-10-10  462  	ret = devm_add_action_or_reset(&pdev->dev, unregister_sev_tsm, NULL);
f47906782c7629 drivers/virt/coco/sev-guest/sev-guest.c Dan Williams          2023-10-10  463  	if (ret)
f47906782c7629 drivers/virt/coco/sev-guest/sev-guest.c Dan Williams          2023-10-10  464  		goto e_free_cert_data;
f47906782c7629 drivers/virt/coco/sev-guest/sev-guest.c Dan Williams          2023-10-10  465  
fce96cf0443083 drivers/virt/coco/sevguest/sevguest.c   Brijesh Singh         2022-03-07  466  	ret =  misc_register(misc);
fce96cf0443083 drivers/virt/coco/sevguest/sevguest.c   Brijesh Singh         2022-03-07  467  	if (ret)
81b918a5844565 drivers/virt/coco/sev-guest/sev-guest.c Nikunj A Dadhania     2023-11-28  468  		goto e_free_cert_data;
81b918a5844565 drivers/virt/coco/sev-guest/sev-guest.c Nikunj A Dadhania     2023-11-28  469  
81b918a5844565 drivers/virt/coco/sev-guest/sev-guest.c Nikunj A Dadhania     2023-11-28  470  	dev_info(dev, "Initialized SEV guest driver (using vmpck_id %u)\n", snp_dev->vmpck_id);
fce96cf0443083 drivers/virt/coco/sevguest/sevguest.c   Brijesh Singh         2022-03-07  471  
fce96cf0443083 drivers/virt/coco/sevguest/sevguest.c   Brijesh Singh         2022-03-07  472  	return 0;
fce96cf0443083 drivers/virt/coco/sevguest/sevguest.c   Brijesh Singh         2022-03-07  473  
d80b494f712317 drivers/virt/coco/sevguest/sevguest.c   Brijesh Singh         2022-03-07  474  e_free_cert_data:
d80b494f712317 drivers/virt/coco/sevguest/sevguest.c   Brijesh Singh         2022-03-07  475  	free_shared_pages(snp_dev->certs_data, SEV_FW_BLOB_MAX_SIZE);
81b918a5844565 drivers/virt/coco/sev-guest/sev-guest.c Nikunj A Dadhania     2023-11-28  476  e_free_ctx:
81b918a5844565 drivers/virt/coco/sev-guest/sev-guest.c Nikunj A Dadhania     2023-11-28  477  	kfree(snp_dev->ctx);
81b918a5844565 drivers/virt/coco/sev-guest/sev-guest.c Nikunj A Dadhania     2023-11-28  478  e_free_snpdev:
81b918a5844565 drivers/virt/coco/sev-guest/sev-guest.c Nikunj A Dadhania     2023-11-28  479  	kfree(snp_dev);
fce96cf0443083 drivers/virt/coco/sevguest/sevguest.c   Brijesh Singh         2022-03-07  480  	return ret;
fce96cf0443083 drivers/virt/coco/sevguest/sevguest.c   Brijesh Singh         2022-03-07  481  }
fce96cf0443083 drivers/virt/coco/sevguest/sevguest.c   Brijesh Singh         2022-03-07  482  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

