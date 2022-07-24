Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C74457F29A
	for <lists+kvm@lfdr.de>; Sun, 24 Jul 2022 03:59:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232172AbiGXBzZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 23 Jul 2022 21:55:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbiGXBzY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 23 Jul 2022 21:55:24 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 661CE6413
        for <kvm@vger.kernel.org>; Sat, 23 Jul 2022 18:55:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658627722; x=1690163722;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=4IPajJpoNWeNMxggFAz0vEdewrwxNl/rvz1DaS/AiXA=;
  b=j1L3HR36SHKW0tJJZBOU6tX90SQukPkRcn9WxQV/JskrztscYl8z4bHC
   Qcp4n5wPPQCzEMOeFs9na3LDOLpp/OV+1+NfJecTzJ78nVCgqnufypU7L
   Y1a7PV+Z9FY2ZAgWHp3N8PMAxApdWP5T7N3fdAKY7kMGR7NyntiuIUICl
   5sdNFDiiEX/52fvc8b1A2w13temQ4scJL8zNjlngeEwvmUnQC3GMYQ97X
   5xekDwKE1iX+6Xd2usc8gul/xWTLOc3I1cEUyyoJ2yWI8BEtIBTdXtjP0
   gEeR+PAjVNnzhgWCvb5poYs1p9GMvZn2jVn9DOVLdCQtm0TxN8SrlO+TT
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10417"; a="373810639"
X-IronPort-AV: E=Sophos;i="5.93,189,1654585200"; 
   d="scan'208";a="373810639"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2022 18:55:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,189,1654585200"; 
   d="scan'208";a="688671411"
Received: from lkp-server01.sh.intel.com (HELO e0eace57cfef) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 23 Jul 2022 18:55:18 -0700
Received: from kbuild by e0eace57cfef with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oFQpy-0003Nm-0A;
        Sun, 24 Jul 2022 01:55:18 +0000
Date:   Sun, 24 Jul 2022 09:54:56 +0800
From:   kernel test robot <lkp@intel.com>
To:     Peter Collingbourne <pcc@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Evgenii Stepanov <eugenis@google.com>, kvm@vger.kernel.org,
        Steven Price <steven.price@arm.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Peter Collingbourne <pcc@google.com>
Subject: Re: [PATCH v2 1/7] arm64: mte: Fix/clarify the PG_mte_tagged
 semantics
Message-ID: <202207240907.aR4gvNkj-lkp@intel.com>
References: <20220722015034.809663-2-pcc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220722015034.809663-2-pcc@google.com>
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Peter,

I love your patch! Yet something to improve:

[auto build test ERROR on arm64/for-next/core]
[also build test ERROR on next-20220722]
[cannot apply to kvmarm/next arm/for-next soc/for-next xilinx-xlnx/master linus/master v5.19-rc7]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Peter-Collingbourne/KVM-arm64-permit-MAP_SHARED-mappings-with-MTE-enabled/20220722-095300
base:   https://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-next/core
config: arm64-buildonly-randconfig-r004-20220722 (https://download.01.org/0day-ci/archive/20220724/202207240907.aR4gvNkj-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 72686d68c137551cce816416190a18d45b4d4e2a)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install arm64 cross compiling tool for clang build
        # apt-get install binutils-aarch64-linux-gnu
        # https://github.com/intel-lab-lkp/linux/commit/3323e416892d6b5326503b9afc2ee835162b819b
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Peter-Collingbourne/KVM-arm64-permit-MAP_SHARED-mappings-with-MTE-enabled/20220722-095300
        git checkout 3323e416892d6b5326503b9afc2ee835162b819b
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=arm64 prepare

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from arch/arm64/kernel/asm-offsets.c:10:
   In file included from include/linux/arm_sdei.h:8:
   In file included from include/acpi/ghes.h:5:
   In file included from include/acpi/apei.h:9:
   In file included from include/linux/acpi.h:15:
   In file included from include/linux/device.h:32:
   In file included from include/linux/device/driver.h:21:
   In file included from include/linux/module.h:19:
   In file included from include/linux/elf.h:6:
   In file included from arch/arm64/include/asm/elf.h:141:
   In file included from include/linux/fs.h:33:
   In file included from include/linux/percpu-rwsem.h:7:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:9:
   In file included from include/linux/sched/task.h:11:
   In file included from include/linux/uaccess.h:11:
   In file included from arch/arm64/include/asm/uaccess.h:24:
>> arch/arm64/include/asm/mte.h:80:15: error: type specifier missing, defaults to 'int'; ISO C99 and later do not support implicit int [-Wimplicit-int]
   static inline set_page_mte_tagged(struct page *page)
   ~~~~~~~~~~~~~ ^
   int
   In file included from arch/arm64/kernel/asm-offsets.c:12:
   In file included from include/linux/kexec.h:31:
   include/linux/compat.h:456:22: warning: array index 3 is past the end of the array (which contains 1 element) [-Warray-bounds]
           case 4: v.sig[7] = (set->sig[3] >> 32); v.sig[6] = set->sig[3];
                               ^        ~
   include/uapi/asm-generic/signal.h:62:2: note: array 'sig' declared here
           unsigned long sig[_NSIG_WORDS];
           ^
   In file included from arch/arm64/kernel/asm-offsets.c:12:
   In file included from include/linux/kexec.h:31:
   include/linux/compat.h:456:10: warning: array index 7 is past the end of the array (which contains 2 elements) [-Warray-bounds]
           case 4: v.sig[7] = (set->sig[3] >> 32); v.sig[6] = set->sig[3];
                   ^     ~
   include/linux/compat.h:131:2: note: array 'sig' declared here
           compat_sigset_word      sig[_COMPAT_NSIG_WORDS];
           ^
   include/linux/compat.h:456:42: warning: array index 6 is past the end of the array (which contains 2 elements) [-Warray-bounds]
           case 4: v.sig[7] = (set->sig[3] >> 32); v.sig[6] = set->sig[3];
                                                   ^     ~
   include/linux/compat.h:131:2: note: array 'sig' declared here
           compat_sigset_word      sig[_COMPAT_NSIG_WORDS];
           ^
   include/linux/compat.h:456:53: warning: array index 3 is past the end of the array (which contains 1 element) [-Warray-bounds]
           case 4: v.sig[7] = (set->sig[3] >> 32); v.sig[6] = set->sig[3];
                                                              ^        ~
   include/uapi/asm-generic/signal.h:62:2: note: array 'sig' declared here
           unsigned long sig[_NSIG_WORDS];
           ^
   In file included from arch/arm64/kernel/asm-offsets.c:12:
   In file included from include/linux/kexec.h:31:
   include/linux/compat.h:458:22: warning: array index 2 is past the end of the array (which contains 1 element) [-Warray-bounds]
           case 3: v.sig[5] = (set->sig[2] >> 32); v.sig[4] = set->sig[2];
                               ^        ~
   include/uapi/asm-generic/signal.h:62:2: note: array 'sig' declared here
           unsigned long sig[_NSIG_WORDS];
           ^
   In file included from arch/arm64/kernel/asm-offsets.c:12:
   In file included from include/linux/kexec.h:31:
   include/linux/compat.h:458:10: warning: array index 5 is past the end of the array (which contains 2 elements) [-Warray-bounds]
           case 3: v.sig[5] = (set->sig[2] >> 32); v.sig[4] = set->sig[2];
                   ^     ~
   include/linux/compat.h:131:2: note: array 'sig' declared here
           compat_sigset_word      sig[_COMPAT_NSIG_WORDS];
           ^
   include/linux/compat.h:458:42: warning: array index 4 is past the end of the array (which contains 2 elements) [-Warray-bounds]
           case 3: v.sig[5] = (set->sig[2] >> 32); v.sig[4] = set->sig[2];
                                                   ^     ~
   include/linux/compat.h:131:2: note: array 'sig' declared here
           compat_sigset_word      sig[_COMPAT_NSIG_WORDS];
           ^
   include/linux/compat.h:458:53: warning: array index 2 is past the end of the array (which contains 1 element) [-Warray-bounds]
           case 3: v.sig[5] = (set->sig[2] >> 32); v.sig[4] = set->sig[2];
                                                              ^        ~
   include/uapi/asm-generic/signal.h:62:2: note: array 'sig' declared here
           unsigned long sig[_NSIG_WORDS];
           ^
   In file included from arch/arm64/kernel/asm-offsets.c:12:
   In file included from include/linux/kexec.h:31:
   include/linux/compat.h:460:22: warning: array index 1 is past the end of the array (which contains 1 element) [-Warray-bounds]
           case 2: v.sig[3] = (set->sig[1] >> 32); v.sig[2] = set->sig[1];
                               ^        ~
   include/uapi/asm-generic/signal.h:62:2: note: array 'sig' declared here
           unsigned long sig[_NSIG_WORDS];
           ^
   In file included from arch/arm64/kernel/asm-offsets.c:12:
   In file included from include/linux/kexec.h:31:
   include/linux/compat.h:460:10: warning: array index 3 is past the end of the array (which contains 2 elements) [-Warray-bounds]
           case 2: v.sig[3] = (set->sig[1] >> 32); v.sig[2] = set->sig[1];
                   ^     ~
   include/linux/compat.h:131:2: note: array 'sig' declared here
           compat_sigset_word      sig[_COMPAT_NSIG_WORDS];
           ^
   include/linux/compat.h:460:42: warning: array index 2 is past the end of the array (which contains 2 elements) [-Warray-bounds]
           case 2: v.sig[3] = (set->sig[1] >> 32); v.sig[2] = set->sig[1];
                                                   ^     ~
   include/linux/compat.h:131:2: note: array 'sig' declared here
           compat_sigset_word      sig[_COMPAT_NSIG_WORDS];
           ^
   include/linux/compat.h:460:53: warning: array index 1 is past the end of the array (which contains 1 element) [-Warray-bounds]
           case 2: v.sig[3] = (set->sig[1] >> 32); v.sig[2] = set->sig[1];
                                                              ^        ~
   include/uapi/asm-generic/signal.h:62:2: note: array 'sig' declared here
           unsigned long sig[_NSIG_WORDS];
           ^
   12 warnings and 1 error generated.
   make[2]: *** [scripts/Makefile.build:117: arch/arm64/kernel/asm-offsets.s] Error 1
   make[2]: Target '__build' not remade because of errors.
   make[1]: *** [Makefile:1200: prepare0] Error 2
   make[1]: Target 'prepare' not remade because of errors.
   make: *** [Makefile:219: __sub-make] Error 2
   make: Target 'prepare' not remade because of errors.


vim +/int +80 arch/arm64/include/asm/mte.h

    79	
  > 80	static inline set_page_mte_tagged(struct page *page)
    81	{
    82	}
    83	static inline bool page_mte_tagged(struct page *page)
    84	{
    85		return false;
    86	}
    87	static inline void mte_zero_clear_page_tags(void *addr)
    88	{
    89	}
    90	static inline void mte_sync_tags(pte_t old_pte, pte_t pte)
    91	{
    92	}
    93	static inline void mte_copy_page_tags(void *kto, const void *kfrom)
    94	{
    95	}
    96	static inline void mte_thread_init_user(void)
    97	{
    98	}
    99	static inline void mte_thread_switch(struct task_struct *next)
   100	{
   101	}
   102	static inline void mte_suspend_enter(void)
   103	{
   104	}
   105	static inline long set_mte_ctrl(struct task_struct *task, unsigned long arg)
   106	{
   107		return 0;
   108	}
   109	static inline long get_mte_ctrl(struct task_struct *task)
   110	{
   111		return 0;
   112	}
   113	static inline int mte_ptrace_copy_tags(struct task_struct *child,
   114					       long request, unsigned long addr,
   115					       unsigned long data)
   116	{
   117		return -EIO;
   118	}
   119	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
