Return-Path: <kvm+bounces-15059-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B8DB68A9505
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 10:32:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6E5DB281622
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 08:32:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A01B146585;
	Thu, 18 Apr 2024 08:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l116uchs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10E62155724
	for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 08:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713429110; cv=none; b=u+G6zE11yMebBrY7MdcNavIOpgqvfyMsY01p2ZIKTfbCuL//fwi1iwHU9QbcX4FUjdm+1eNyD0ZM2cRxZ43cs4h8lGLvR9uEc1hWfDuBhXBQbEHjihwdsGX8bWXkS7fDW3GRkb8EYL2Cq6b3sDijgMgvdjER1a7w9FEeGmxsxkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713429110; c=relaxed/simple;
	bh=r0cHX+yPn3EpLqLWYxcJY0gh+lIngVTwfX2DOv5govg=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=NsqacIg6rOaIbNyWPsqIzkBMdEY+z66YN17nLuHWVMuzhq0OGK71jos5jDJFBh7xkBWyKNXlXC9aN1PFvM0E5zyaG8DWX0ULNt5kieOtIG4jaCgZBnrCC3TxS3LV0BGpBcNO5Wt1nCVFpCyGU1/a8cQriM3kk5VJW55ihd4GmF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=l116uchs; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713429109; x=1744965109;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=r0cHX+yPn3EpLqLWYxcJY0gh+lIngVTwfX2DOv5govg=;
  b=l116uchsD9V9Z9UlOiQedC5oWUli83L/4SCKp7FXPAaxUim03mM4icor
   aOnt8FtjyQ4LFhGK/YJ/OFto2X2jhpZcPPRpws2ac+CIqBDgZVnTaLgt7
   hO7XZccOaUeFQSl0KX/Dhpo6skFaPvnUWe0YKrokCNwq3kz43v6XIA8Kr
   rdJxQ7ogDdkMlmRg8yOrz5nKZEVj64eLQZMJyJ5vnIv1Fd2lIhosWLa7k
   pUOf0llo+SUAaKloIG/mMjs6iCKz0JQUZ2QTGYANIE34TyJ4l302tpXf3
   eWCikD+QEPLvlc12fb3MnL2gW9jVxlvMD72j+SxQyyrjLN9gZKPz/Uhfm
   w==;
X-CSE-ConnectionGUID: 8XPWeDnAQKiE2nz4wuoQ+Q==
X-CSE-MsgGUID: ROLkuyDvSbCrAX7dKF+dRg==
X-IronPort-AV: E=McAfee;i="6600,9927,11047"; a="20353351"
X-IronPort-AV: E=Sophos;i="6.07,211,1708416000"; 
   d="scan'208";a="20353351"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2024 01:31:48 -0700
X-CSE-ConnectionGUID: GRQW/y+KQm66LV673pfENA==
X-CSE-MsgGUID: qVSrxr6oQ++A1FXxExByag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,211,1708416000"; 
   d="scan'208";a="23518646"
Received: from unknown (HELO 23c141fc0fd8) ([10.239.97.151])
  by orviesa008.jf.intel.com with ESMTP; 18 Apr 2024 01:31:45 -0700
Received: from kbuild by 23c141fc0fd8 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1rxNAx-0007Qs-0h;
	Thu, 18 Apr 2024 08:31:28 +0000
Date: Thu, 18 Apr 2024 16:29:24 +0800
From: kernel test robot <lkp@intel.com>
To: Isaku Yamahata <isaku.yamahata@intel.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	kvm@vger.kernel.org, Robert Hu <robert.hu@intel.com>,
	Farrah Chen <farrah.chen@intel.com>,
	Danmei Wei <danmei.wei@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm:kvm-coco-queue 71/72]
 arch/x86/kvm/../../../virt/kvm/kvm_main.c:4928:2: warning: unannotated
 fall-through between switch labels
Message-ID: <202404181659.jsyP7h1R-lkp@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-coco-queue
head:   0a2d4030dd6dcd480232ca0755de2e76c6d9ce59
commit: aaca8c3f5ff360afe055631ce000b41a31fc9c2c [71/72] KVM: x86: Implement kvm_arch_vcpu_map_memory()
config: x86_64-buildonly-randconfig-006-20240418 (https://download.01.org/0day-ci/archive/20240418/202404181659.jsyP7h1R-lkp@intel.com/config)
compiler: clang version 17.0.6 (https://github.com/llvm/llvm-project 6009708b4367171ccdbf4b5905cb6a803753fe18)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240418/202404181659.jsyP7h1R-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202404181659.jsyP7h1R-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> arch/x86/kvm/../../../virt/kvm/kvm_main.c:4928:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
    4928 |         default:
         |         ^
   arch/x86/kvm/../../../virt/kvm/kvm_main.c:4928:2: note: insert 'break;' to avoid fall-through
    4928 |         default:
         |         ^
         |         break; 
   1 warning generated.


vim +4928 arch/x86/kvm/../../../virt/kvm/kvm_main.c

852b6d57dc7fa3 Scott Wood          2013-04-12  4853  
f15ba52bfabc3b Thomas Huth         2023-02-08  4854  static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
92b591a4c46b10 Alexander Graf      2014-07-14  4855  {
92b591a4c46b10 Alexander Graf      2014-07-14  4856  	switch (arg) {
92b591a4c46b10 Alexander Graf      2014-07-14  4857  	case KVM_CAP_USER_MEMORY:
bb58b90b1a8f75 Sean Christopherson 2023-10-27  4858  	case KVM_CAP_USER_MEMORY2:
92b591a4c46b10 Alexander Graf      2014-07-14  4859  	case KVM_CAP_DESTROY_MEMORY_REGION_WORKS:
92b591a4c46b10 Alexander Graf      2014-07-14  4860  	case KVM_CAP_JOIN_MEMORY_REGIONS_WORKS:
92b591a4c46b10 Alexander Graf      2014-07-14  4861  	case KVM_CAP_INTERNAL_ERROR_DATA:
92b591a4c46b10 Alexander Graf      2014-07-14  4862  #ifdef CONFIG_HAVE_KVM_MSI
92b591a4c46b10 Alexander Graf      2014-07-14  4863  	case KVM_CAP_SIGNAL_MSI:
92b591a4c46b10 Alexander Graf      2014-07-14  4864  #endif
c5b31cc2371728 Paolo Bonzini       2023-10-18  4865  #ifdef CONFIG_HAVE_KVM_IRQCHIP
dc9be0fac70a2a Paolo Bonzini       2015-03-05  4866  	case KVM_CAP_IRQFD:
92b591a4c46b10 Alexander Graf      2014-07-14  4867  #endif
e9ea5069d9e569 Jason Wang          2015-09-15  4868  	case KVM_CAP_IOEVENTFD_ANY_LENGTH:
92b591a4c46b10 Alexander Graf      2014-07-14  4869  	case KVM_CAP_CHECK_EXTENSION_VM:
e5d83c74a5800c Paolo Bonzini       2017-02-16  4870  	case KVM_CAP_ENABLE_CAP_VM:
acd05785e48c01 David Matlack       2020-04-17  4871  	case KVM_CAP_HALT_POLL:
92b591a4c46b10 Alexander Graf      2014-07-14  4872  		return 1;
4b4357e02523ec Paolo Bonzini       2017-03-31  4873  #ifdef CONFIG_KVM_MMIO
3042255899540d Paolo Bonzini       2017-03-31  4874  	case KVM_CAP_COALESCED_MMIO:
3042255899540d Paolo Bonzini       2017-03-31  4875  		return KVM_COALESCED_MMIO_PAGE_OFFSET;
0804c849f1df09 Peng Hao            2018-10-14  4876  	case KVM_CAP_COALESCED_PIO:
0804c849f1df09 Peng Hao            2018-10-14  4877  		return 1;
3042255899540d Paolo Bonzini       2017-03-31  4878  #endif
3c9bd4006bfc2d Jay Zhou            2020-02-27  4879  #ifdef CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT
3c9bd4006bfc2d Jay Zhou            2020-02-27  4880  	case KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2:
3c9bd4006bfc2d Jay Zhou            2020-02-27  4881  		return KVM_DIRTY_LOG_MANUAL_CAPS;
3c9bd4006bfc2d Jay Zhou            2020-02-27  4882  #endif
92b591a4c46b10 Alexander Graf      2014-07-14  4883  #ifdef CONFIG_HAVE_KVM_IRQ_ROUTING
92b591a4c46b10 Alexander Graf      2014-07-14  4884  	case KVM_CAP_IRQ_ROUTING:
92b591a4c46b10 Alexander Graf      2014-07-14  4885  		return KVM_MAX_IRQ_ROUTES;
f481b069e67437 Paolo Bonzini       2015-05-17  4886  #endif
eed52e434bc336 Sean Christopherson 2023-10-27  4887  #if KVM_MAX_NR_ADDRESS_SPACES > 1
f481b069e67437 Paolo Bonzini       2015-05-17  4888  	case KVM_CAP_MULTI_ADDRESS_SPACE:
eed52e434bc336 Sean Christopherson 2023-10-27  4889  		if (kvm)
eed52e434bc336 Sean Christopherson 2023-10-27  4890  			return kvm_arch_nr_memslot_as_ids(kvm);
eed52e434bc336 Sean Christopherson 2023-10-27  4891  		return KVM_MAX_NR_ADDRESS_SPACES;
92b591a4c46b10 Alexander Graf      2014-07-14  4892  #endif
c110ae578ca0a1 Paolo Bonzini       2019-03-28  4893  	case KVM_CAP_NR_MEMSLOTS:
c110ae578ca0a1 Paolo Bonzini       2019-03-28  4894  		return KVM_USER_MEM_SLOTS;
fb04a1eddb1a65 Peter Xu            2020-09-30  4895  	case KVM_CAP_DIRTY_LOG_RING:
17601bfed909fa Marc Zyngier        2022-09-26  4896  #ifdef CONFIG_HAVE_KVM_DIRTY_RING_TSO
17601bfed909fa Marc Zyngier        2022-09-26  4897  		return KVM_DIRTY_RING_MAX_ENTRIES * sizeof(struct kvm_dirty_gfn);
17601bfed909fa Marc Zyngier        2022-09-26  4898  #else
17601bfed909fa Marc Zyngier        2022-09-26  4899  		return 0;
17601bfed909fa Marc Zyngier        2022-09-26  4900  #endif
17601bfed909fa Marc Zyngier        2022-09-26  4901  	case KVM_CAP_DIRTY_LOG_RING_ACQ_REL:
17601bfed909fa Marc Zyngier        2022-09-26  4902  #ifdef CONFIG_HAVE_KVM_DIRTY_RING_ACQ_REL
fb04a1eddb1a65 Peter Xu            2020-09-30  4903  		return KVM_DIRTY_RING_MAX_ENTRIES * sizeof(struct kvm_dirty_gfn);
fb04a1eddb1a65 Peter Xu            2020-09-30  4904  #else
fb04a1eddb1a65 Peter Xu            2020-09-30  4905  		return 0;
86bdf3ebcfe1de Gavin Shan          2022-11-10  4906  #endif
86bdf3ebcfe1de Gavin Shan          2022-11-10  4907  #ifdef CONFIG_NEED_KVM_DIRTY_RING_WITH_BITMAP
86bdf3ebcfe1de Gavin Shan          2022-11-10  4908  	case KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP:
fb04a1eddb1a65 Peter Xu            2020-09-30  4909  #endif
ce55c049459cff Jing Zhang          2021-06-18  4910  	case KVM_CAP_BINARY_STATS_FD:
d495f942f40aa4 Paolo Bonzini       2022-04-22  4911  	case KVM_CAP_SYSTEM_EVENT_DATA:
63912245c19d3a Wei Wang            2023-03-15  4912  	case KVM_CAP_DEVICE_CTRL:
ce55c049459cff Jing Zhang          2021-06-18  4913  		return 1;
5a475554db1e47 Chao Peng           2023-10-27  4914  #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
5a475554db1e47 Chao Peng           2023-10-27  4915  	case KVM_CAP_MEMORY_ATTRIBUTES:
5a475554db1e47 Chao Peng           2023-10-27  4916  		return kvm_supported_mem_attributes(kvm);
a7800aa80ea4d5 Sean Christopherson 2023-11-13  4917  #endif
a7800aa80ea4d5 Sean Christopherson 2023-11-13  4918  #ifdef CONFIG_KVM_PRIVATE_MEM
a7800aa80ea4d5 Sean Christopherson 2023-11-13  4919  	case KVM_CAP_GUEST_MEMFD:
a7800aa80ea4d5 Sean Christopherson 2023-11-13  4920  		return !kvm || kvm_arch_has_private_mem(kvm);
5b9f4d628c780f Isaku Yamahata      2024-04-10  4921  #endif
5b9f4d628c780f Isaku Yamahata      2024-04-10  4922  #ifdef CONFIG_KVM_GENERIC_MAP_MEMORY
5b9f4d628c780f Isaku Yamahata      2024-04-10  4923  	case KVM_CAP_MAP_MEMORY:
5b9f4d628c780f Isaku Yamahata      2024-04-10  4924  		if (!kvm)
5b9f4d628c780f Isaku Yamahata      2024-04-10  4925  			return 1;
5b9f4d628c780f Isaku Yamahata      2024-04-10  4926  		/* Leave per-VM implementation to kvm_vm_ioctl_check_extension().  */
5a475554db1e47 Chao Peng           2023-10-27  4927  #endif
92b591a4c46b10 Alexander Graf      2014-07-14 @4928  	default:
92b591a4c46b10 Alexander Graf      2014-07-14  4929  		break;
92b591a4c46b10 Alexander Graf      2014-07-14  4930  	}
92b591a4c46b10 Alexander Graf      2014-07-14  4931  	return kvm_vm_ioctl_check_extension(kvm, arg);
92b591a4c46b10 Alexander Graf      2014-07-14  4932  }
92b591a4c46b10 Alexander Graf      2014-07-14  4933  

:::::: The code at line 4928 was first introduced by commit
:::::: 92b591a4c46b103ebd3fc0d03a084e1efd331253 KVM: Allow KVM_CHECK_EXTENSION on the vm fd

:::::: TO: Alexander Graf <agraf@suse.de>
:::::: CC: Alexander Graf <agraf@suse.de>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

