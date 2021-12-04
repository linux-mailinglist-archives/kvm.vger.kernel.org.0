Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E5BD4681FD
	for <lists+kvm@lfdr.de>; Sat,  4 Dec 2021 03:33:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239083AbhLDCg5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Dec 2021 21:36:57 -0500
Received: from mga03.intel.com ([134.134.136.65]:41693 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235609AbhLDCg5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Dec 2021 21:36:57 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10187"; a="237028244"
X-IronPort-AV: E=Sophos;i="5.87,286,1631602800"; 
   d="scan'208";a="237028244"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2021 18:33:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,286,1631602800"; 
   d="scan'208";a="610623549"
Received: from lkp-server02.sh.intel.com (HELO 9e1e9f9b3bcb) ([10.239.97.151])
  by orsmga004.jf.intel.com with ESMTP; 03 Dec 2021 18:33:29 -0800
Received: from kbuild by 9e1e9f9b3bcb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mtKrg-000ILp-JW; Sat, 04 Dec 2021 02:33:28 +0000
Date:   Sat, 4 Dec 2021 10:32:39 +0800
From:   kernel test robot <lkp@intel.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     kbuild-all@lists.01.org, cohuck@redhat.com, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, thuth@redhat.com, pasic@linux.ibm.com,
        david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 10/17] KVM: s390: pv: add mmu_notifier
Message-ID: <202112041017.COolnLgE-lkp@intel.com>
References: <20211203165814.73016-11-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211203165814.73016-11-imbrenda@linux.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Claudio,

I love your patch! Yet something to improve:

[auto build test ERROR on s390/features]
[also build test ERROR on kvm/queue v5.16-rc3 next-20211203]
[cannot apply to kvms390/next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Claudio-Imbrenda/KVM-s390-pv-implement-lazy-destroy-for-reboot/20211204-010121
base:   https://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git features
config: s390-randconfig-r034-20211203 (https://download.01.org/0day-ci/archive/20211204/202112041017.COolnLgE-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/c2d394c61e53062a1e7ba537029dce61f7a75cff
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Claudio-Imbrenda/KVM-s390-pv-implement-lazy-destroy-for-reboot/20211204-010121
        git checkout c2d394c61e53062a1e7ba537029dce61f7a75cff
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=s390 SHELL=/bin/bash arch/s390/kvm/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   arch/s390/kvm/pv.c: In function 'kvm_s390_pv_init_vm':
>> arch/s390/kvm/pv.c:257:17: error: implicit declaration of function 'mmu_notifier_register'; did you mean 'mmu_notifier_release'? [-Werror=implicit-function-declaration]
     257 |                 mmu_notifier_register(&kvm->arch.pv.mmu_notifier, kvm->mm);
         |                 ^~~~~~~~~~~~~~~~~~~~~
         |                 mmu_notifier_release
   cc1: some warnings being treated as errors


vim +257 arch/s390/kvm/pv.c

   212	
   213	int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
   214	{
   215		struct uv_cb_cgc uvcb = {
   216			.header.cmd = UVC_CMD_CREATE_SEC_CONF,
   217			.header.len = sizeof(uvcb)
   218		};
   219		int cc, ret;
   220		u16 dummy;
   221	
   222		ret = kvm_s390_pv_alloc_vm(kvm);
   223		if (ret)
   224			return ret;
   225	
   226		/* Inputs */
   227		uvcb.guest_stor_origin = 0; /* MSO is 0 for KVM */
   228		uvcb.guest_stor_len = kvm->arch.pv.guest_len;
   229		uvcb.guest_asce = kvm->arch.gmap->asce;
   230		uvcb.guest_sca = (unsigned long)kvm->arch.sca;
   231		uvcb.conf_base_stor_origin = (u64)kvm->arch.pv.stor_base;
   232		uvcb.conf_virt_stor_origin = (u64)kvm->arch.pv.stor_var;
   233	
   234		cc = uv_call_sched(0, (u64)&uvcb);
   235		*rc = uvcb.header.rc;
   236		*rrc = uvcb.header.rrc;
   237		KVM_UV_EVENT(kvm, 3, "PROTVIRT CREATE VM: handle %llx len %llx rc %x rrc %x",
   238			     uvcb.guest_handle, uvcb.guest_stor_len, *rc, *rrc);
   239	
   240		/* Outputs */
   241		kvm->arch.pv.handle = uvcb.guest_handle;
   242	
   243		atomic_inc(&kvm->mm->context.protected_count);
   244		if (cc) {
   245			if (uvcb.header.rc & UVC_RC_NEED_DESTROY) {
   246				kvm_s390_pv_deinit_vm(kvm, &dummy, &dummy);
   247			} else {
   248				atomic_dec(&kvm->mm->context.protected_count);
   249				kvm_s390_pv_dealloc_vm(kvm);
   250			}
   251			return -EIO;
   252		}
   253		kvm->arch.gmap->guest_handle = uvcb.guest_handle;
   254		/* Add the notifier only once. No races because we hold kvm->lock */
   255		if (kvm->arch.pv.mmu_notifier.ops != &kvm_s390_pv_mmu_notifier_ops) {
   256			kvm->arch.pv.mmu_notifier.ops = &kvm_s390_pv_mmu_notifier_ops;
 > 257			mmu_notifier_register(&kvm->arch.pv.mmu_notifier, kvm->mm);
   258		}
   259		return 0;
   260	}
   261	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
