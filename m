Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EEDA57EB23
	for <lists+kvm@lfdr.de>; Sat, 23 Jul 2022 03:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236965AbiGWByJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 21:54:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236728AbiGWBx6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 21:53:58 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36E8A9E78F
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 18:53:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658541234; x=1690077234;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FNw7P42GVcdFgc6sl5AcYSLL6g7u6PAzHXy9t9ojsGw=;
  b=DzQOgbpo7yqJEci4GCuHp9Tbx1GOkrtzP/SuHPLH8FLftnI7VxUHb/J0
   2EOXKl+bdJgWySeqJOYYjYbFqRGCw1Se7tJo6uPn/vQtaVBzjFoEppn8K
   UcryCnOfg44IU5xSosbSHXNQjW8wZRy5Ey7mP/4yENXAX4FYdck/EHDpX
   F3ALC6xWi5kngEurHsolg6JKX+iT2zESkPWbMYr5Hgx7Au4tHg1/lpkYw
   e+qIBWN50tycgX3SlxeP1migdLGv4ubGGzCFH+SasVDkM/kE8zWFbQesU
   NUFPTyox9qr+LyrVN7b659UjU2wNFAMRf89IlhemXK2i2GCgSGoEm8wel
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10416"; a="286197490"
X-IronPort-AV: E=Sophos;i="5.93,186,1654585200"; 
   d="scan'208";a="286197490"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2022 18:53:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,186,1654585200"; 
   d="scan'208";a="688471593"
Received: from lkp-server01.sh.intel.com (HELO e0eace57cfef) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 22 Jul 2022 18:53:50 -0700
Received: from kbuild by e0eace57cfef with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oF4L0-00022v-0P;
        Sat, 23 Jul 2022 01:53:50 +0000
Date:   Sat, 23 Jul 2022 09:53:35 +0800
From:   kernel test robot <lkp@intel.com>
To:     Peter Collingbourne <pcc@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc:     kbuild-all@lists.01.org, Catalin Marinas <catalin.marinas@arm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Evgenii Stepanov <eugenis@google.com>, kvm@vger.kernel.org,
        Steven Price <steven.price@arm.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Peter Collingbourne <pcc@google.com>
Subject: Re: [PATCH v2 1/7] arm64: mte: Fix/clarify the PG_mte_tagged
 semantics
Message-ID: <202207230959.jvdok5UK-lkp@intel.com>
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
config: arm64-randconfig-s032-20220721 (https://download.01.org/0day-ci/archive/20220723/202207230959.jvdok5UK-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 12.1.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # apt-get install sparse
        # sparse version: v0.6.4-39-gce1a6720-dirty
        # https://github.com/intel-lab-lkp/linux/commit/3323e416892d6b5326503b9afc2ee835162b819b
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Peter-Collingbourne/KVM-arm64-permit-MAP_SHARED-mappings-with-MTE-enabled/20220722-095300
        git checkout 3323e416892d6b5326503b9afc2ee835162b819b
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=arm64 prepare

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from arch/arm64/include/asm/pgtable.h:12,
                    from include/linux/pgtable.h:6,
                    from include/linux/kasan.h:33,
                    from include/linux/slab.h:140,
                    from include/linux/resource_ext.h:11,
                    from include/linux/acpi.h:14,
                    from include/acpi/apei.h:9,
                    from include/acpi/ghes.h:5,
                    from include/linux/arm_sdei.h:8,
                    from arch/arm64/kernel/asm-offsets.c:10:
>> arch/arm64/include/asm/mte.h:80:15: error: return type defaults to 'int' [-Werror=implicit-int]
      80 | static inline set_page_mte_tagged(struct page *page)
         |               ^~~~~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors
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
