Return-Path: <kvm+bounces-49551-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DD80BAD9932
	for <lists+kvm@lfdr.de>; Sat, 14 Jun 2025 02:44:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BBFBD1BC2149
	for <lists+kvm@lfdr.de>; Sat, 14 Jun 2025 00:45:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 869B71802B;
	Sat, 14 Jun 2025 00:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LAF16msG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A04035972
	for <kvm@vger.kernel.org>; Sat, 14 Jun 2025 00:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749861880; cv=none; b=PMi7K2wsHXCc7Vv50F5h1/BYeNRAqoacuPZrbjpwhDqagGDEFiwp9Yahkg2LGfAG8JyaiyQMsudaRtRYjekFCAsTOxPKGF0K95uxcmN+G6YUw3SHpvuOePPGrBGgyPaPMbhfUmtXh5HYwAFoEjtSwex9si/1MKvvnTCaLu5c+iY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749861880; c=relaxed/simple;
	bh=ZMPWmv2eNkpmwMQT3XlTq81nCnIYtb7lK975Hh7JJQA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=q0vHUb/ac2BPreOWKRMUeM0KvCw4xas5aER2TRhvIjOTOwdQ9ihJY+1wIg1g3bf3VR+Gnd8xH8BTLFgS4Zo5vd7tqyI4BKvR7c7awOabjnpOj0QWknyPkOiHC0v5YqKos5lwmmC/mbBp2WJAp7JWvaB09b0VC3IXs5K+7vgDtKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LAF16msG; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749861880; x=1781397880;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=ZMPWmv2eNkpmwMQT3XlTq81nCnIYtb7lK975Hh7JJQA=;
  b=LAF16msGaLfEOgh2sM+zCmnXT+6KvpK/eeTeMcMdZApe7681BEPpvFrb
   RDygl794/j36AkRg+LlskeY9iaNc4furKSzcC1Qlll42+4Qhz+4SwG319
   hE/txnC5L7LVNzWOAfIjjTPuvsy8XfNClkBhq3qYUx9dzfOCCrLaWBvr3
   qeggUVyfpKtMsHV6mcFD8SdpUckr3Xs8ABBnI6PnRRmv1ZNWTAEMccSLp
   Rh2DLkXUSoP4IauGQa5C2N3ab+Wpt8NbT9lTSGjPgmkoxGVP8JbFUVhB6
   V9V/BcI5vrkO4DmL/2G6WDVggHAJQoFlicbDwkL4k1Ffhie7ymbnweBdM
   g==;
X-CSE-ConnectionGUID: +J0t3wcyRXK5VNddIoUaig==
X-CSE-MsgGUID: UFSE4lzDTom3cwCXjvY+xw==
X-IronPort-AV: E=McAfee;i="6800,10657,11463"; a="74617624"
X-IronPort-AV: E=Sophos;i="6.16,235,1744095600"; 
   d="scan'208";a="74617624"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2025 17:44:39 -0700
X-CSE-ConnectionGUID: MUdbOHRaQdKe5NqehsCv9g==
X-CSE-MsgGUID: yBU6wmQoR9mnPHCDPKNtYQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,235,1744095600"; 
   d="scan'208";a="147859562"
Received: from lkp-server01.sh.intel.com (HELO e8142ee1dce2) ([10.239.97.150])
  by orviesa010.jf.intel.com with ESMTP; 13 Jun 2025 17:44:36 -0700
Received: from kbuild by e8142ee1dce2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uQF0b-000D7g-1O;
	Sat, 14 Jun 2025 00:44:33 +0000
Date: Sat, 14 Jun 2025 08:44:26 +0800
From: kernel test robot <lkp@intel.com>
To: Fuad Tabba <tabba@google.com>
Cc: oe-kbuild-all@lists.linux.dev, kvm@vger.kernel.org,
	Farrah Chen <farrah.chen@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Ira Weiny <ira.weiny@intel.com>, Gavin Shan <gshan@redhat.com>,
	Shivank Garg <shivankg@amd.com>, Vlastimil Babka <vbabka@suse.cz>,
	David Hildenbrand <david@redhat.com>
Subject: [kvm:queue 16/30] arch/x86/kvm/vmx/tdx.c:627:18: error: 'struct
 kvm_arch' has no member named 'has_private_mem'
Message-ID: <202506140800.swbOU0sS-lkp@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Fuad,

FYI, the error/warning was bisected to this commit, please ignore it if it's irrelevant.

tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
head:   79150772457f4d45e38b842d786240c36bb1f97f
commit: 7221fa63c070975edd88fa684e191cda37bf6c28 [16/30] KVM: x86: Rename kvm->arch.has_private_mem to kvm->arch.supports_gmem
config: x86_64-buildonly-randconfig-003-20250614 (https://download.01.org/0day-ci/archive/20250614/202506140800.swbOU0sS-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250614/202506140800.swbOU0sS-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202506140800.swbOU0sS-lkp@intel.com/

All errors (new ones prefixed by >>):

   arch/x86/kvm/vmx/tdx.c: In function 'tdx_vm_init':
>> arch/x86/kvm/vmx/tdx.c:627:18: error: 'struct kvm_arch' has no member named 'has_private_mem'
     627 |         kvm->arch.has_private_mem = true;
         |                  ^
   arch/x86/kvm/vmx/tdx.c: In function 'tdx_vcpu_init_mem_region':
   arch/x86/kvm/vmx/tdx.c:3167:28: error: implicit declaration of function 'kvm_gmem_populate'; did you mean 'vmemmap_populate'? [-Werror=implicit-function-declaration]
    3167 |                 gmem_ret = kvm_gmem_populate(kvm, gpa_to_gfn(region.gpa),
         |                            ^~~~~~~~~~~~~~~~~
         |                            vmemmap_populate
   cc1: some warnings being treated as errors


vim +627 arch/x86/kvm/vmx/tdx.c

8d032b683c29930 Isaku Yamahata 2025-02-25  621  
8d032b683c29930 Isaku Yamahata 2025-02-25  622  int tdx_vm_init(struct kvm *kvm)
8d032b683c29930 Isaku Yamahata 2025-02-25  623  {
0186dd29a251866 Isaku Yamahata 2025-01-14  624  	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
0186dd29a251866 Isaku Yamahata 2025-01-14  625  
8d032b683c29930 Isaku Yamahata 2025-02-25  626  	kvm->arch.has_protected_state = true;
8d032b683c29930 Isaku Yamahata 2025-02-25 @627  	kvm->arch.has_private_mem = true;
90fe64a94d54757 Yan Zhao       2025-02-24  628  	kvm->arch.disabled_quirks |= KVM_X86_QUIRK_IGNORE_GUEST_PAT;
8d032b683c29930 Isaku Yamahata 2025-02-25  629  
7d10ffb1acac2c1 Isaku Yamahata 2024-11-12  630  	/*
7d10ffb1acac2c1 Isaku Yamahata 2024-11-12  631  	 * Because guest TD is protected, VMM can't parse the instruction in TD.
7d10ffb1acac2c1 Isaku Yamahata 2024-11-12  632  	 * Instead, guest uses MMIO hypercall.  For unmodified device driver,
7d10ffb1acac2c1 Isaku Yamahata 2024-11-12  633  	 * #VE needs to be injected for MMIO and #VE handler in TD converts MMIO
7d10ffb1acac2c1 Isaku Yamahata 2024-11-12  634  	 * instruction into MMIO hypercall.
7d10ffb1acac2c1 Isaku Yamahata 2024-11-12  635  	 *
7d10ffb1acac2c1 Isaku Yamahata 2024-11-12  636  	 * SPTE value for MMIO needs to be setup so that #VE is injected into
7d10ffb1acac2c1 Isaku Yamahata 2024-11-12  637  	 * TD instead of triggering EPT MISCONFIG.
7d10ffb1acac2c1 Isaku Yamahata 2024-11-12  638  	 * - RWX=0 so that EPT violation is triggered.
7d10ffb1acac2c1 Isaku Yamahata 2024-11-12  639  	 * - suppress #VE bit is cleared to inject #VE.
7d10ffb1acac2c1 Isaku Yamahata 2024-11-12  640  	 */
7d10ffb1acac2c1 Isaku Yamahata 2024-11-12  641  	kvm_mmu_set_mmio_spte_value(kvm, 0);
7d10ffb1acac2c1 Isaku Yamahata 2024-11-12  642  
f94f4a97e66543b Isaku Yamahata 2024-10-30  643  	/*
f94f4a97e66543b Isaku Yamahata 2024-10-30  644  	 * TDX has its own limit of maximum vCPUs it can support for all
f94f4a97e66543b Isaku Yamahata 2024-10-30  645  	 * TDX guests in addition to KVM_MAX_VCPUS.  TDX module reports
f94f4a97e66543b Isaku Yamahata 2024-10-30  646  	 * such limit via the MAX_VCPU_PER_TD global metadata.  In
f94f4a97e66543b Isaku Yamahata 2024-10-30  647  	 * practice, it reflects the number of logical CPUs that ALL
f94f4a97e66543b Isaku Yamahata 2024-10-30  648  	 * platforms that the TDX module supports can possibly have.
f94f4a97e66543b Isaku Yamahata 2024-10-30  649  	 *
f94f4a97e66543b Isaku Yamahata 2024-10-30  650  	 * Limit TDX guest's maximum vCPUs to the number of logical CPUs
f94f4a97e66543b Isaku Yamahata 2024-10-30  651  	 * the platform has.  Simply forwarding the MAX_VCPU_PER_TD to
f94f4a97e66543b Isaku Yamahata 2024-10-30  652  	 * userspace would result in an unpredictable ABI.
f94f4a97e66543b Isaku Yamahata 2024-10-30  653  	 */
f94f4a97e66543b Isaku Yamahata 2024-10-30  654  	kvm->max_vcpus = min_t(int, kvm->max_vcpus, num_present_cpus());
f94f4a97e66543b Isaku Yamahata 2024-10-30  655  
0186dd29a251866 Isaku Yamahata 2025-01-14  656  	kvm_tdx->state = TD_STATE_UNINITIALIZED;
0186dd29a251866 Isaku Yamahata 2025-01-14  657  
0186dd29a251866 Isaku Yamahata 2025-01-14  658  	return 0;
8d032b683c29930 Isaku Yamahata 2025-02-25  659  }
8d032b683c29930 Isaku Yamahata 2025-02-25  660  

:::::: The code at line 627 was first introduced by commit
:::::: 8d032b683c299302aa8b5fbce17b9b87a138a5f5 KVM: TDX: create/destroy VM structure

:::::: TO: Isaku Yamahata <isaku.yamahata@intel.com>
:::::: CC: Paolo Bonzini <pbonzini@redhat.com>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

