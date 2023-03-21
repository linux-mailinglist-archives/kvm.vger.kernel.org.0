Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AAF76C2BEB
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 09:08:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbjCUIIi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 04:08:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbjCUIIg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 04:08:36 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68D293C2E;
        Tue, 21 Mar 2023 01:08:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679386114; x=1710922114;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=QGXy2d/duKc2M5ZsAkijSTTqJVxAXEAzOUuiNs2X4TE=;
  b=jgtbOC8uYGKCg3nDTYhJIqGuE6WABcVICbttyrbN+43Rh11Cl1SnxQ9N
   wKmAXYPigyznfIY+vWp382a2ynLkokz1J8fvmmTFnslZdZ5JSFfDaGbv5
   hjmfVc9pjRPPjuum7Ithzry2dscywfC3WKDUUyd0t9UIR+1NYYJXKnFhc
   y8Z+nLRjvyRysXvQEBcz3UDLT5On5q3dsLdK0QgZ4g/zgGMMyR/FlKY+8
   szc/tPovZlYQrYDIXQQC5sPfNN4/49HGPOA5vnteSr9rX33zTwvGq5neI
   bkCA9uCRPeMAMlRqwLrqDfbBkWiHPqULR6zyWwdmq2PuaI3uFLyMEL72I
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="338912215"
X-IronPort-AV: E=Sophos;i="5.98,278,1673942400"; 
   d="scan'208";a="338912215"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2023 01:08:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="750445952"
X-IronPort-AV: E=Sophos;i="5.98,278,1673942400"; 
   d="scan'208";a="750445952"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 21 Mar 2023 01:08:19 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1peX2Z-000BkM-0c;
        Tue, 21 Mar 2023 08:08:19 +0000
Date:   Tue, 21 Mar 2023 16:07:26 +0800
From:   kernel test robot <lkp@intel.com>
To:     Tianrui Zhao <zhaotianrui@loongson.cn>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     oe-kbuild-all@lists.linux.dev, Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn,
        Xi Ruoyao <xry111@xry111.site>
Subject: Re: [PATCH v4 27/29] LoongArch: KVM: Implement vcpu world switch
Message-ID: <202303211554.OkK5r3bb-lkp@intel.com>
References: <20230321035651.598505-28-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230321035651.598505-28-zhaotianrui@loongson.cn>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Tianrui,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on kvm/queue]
[also build test WARNING on linus/master v6.3-rc3 next-20230321]
[cannot apply to kvm/linux-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Tianrui-Zhao/LoongArch-KVM-Add-kvm-related-header-files/20230321-120249
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
patch link:    https://lore.kernel.org/r/20230321035651.598505-28-zhaotianrui%40loongson.cn
patch subject: [PATCH v4 27/29] LoongArch: KVM: Implement vcpu world switch
config: loongarch-allyesconfig (https://download.01.org/0day-ci/archive/20230321/202303211554.OkK5r3bb-lkp@intel.com/config)
compiler: loongarch64-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/92ac063f865b08997b28bd090d6fa3986d0f21cb
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Tianrui-Zhao/LoongArch-KVM-Add-kvm-related-header-files/20230321-120249
        git checkout 92ac063f865b08997b28bd090d6fa3986d0f21cb
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=loongarch olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=loongarch prepare

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303211554.OkK5r3bb-lkp@intel.com/

All warnings (new ones prefixed by >>):

   arch/loongarch/kernel/asm-offsets.c:17:6: warning: no previous prototype for 'output_ptreg_defines' [-Wmissing-prototypes]
      17 | void output_ptreg_defines(void)
         |      ^~~~~~~~~~~~~~~~~~~~
   arch/loongarch/kernel/asm-offsets.c:64:6: warning: no previous prototype for 'output_task_defines' [-Wmissing-prototypes]
      64 | void output_task_defines(void)
         |      ^~~~~~~~~~~~~~~~~~~
   arch/loongarch/kernel/asm-offsets.c:79:6: warning: no previous prototype for 'output_thread_info_defines' [-Wmissing-prototypes]
      79 | void output_thread_info_defines(void)
         |      ^~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/loongarch/kernel/asm-offsets.c:95:6: warning: no previous prototype for 'output_thread_defines' [-Wmissing-prototypes]
      95 | void output_thread_defines(void)
         |      ^~~~~~~~~~~~~~~~~~~~~
   arch/loongarch/kernel/asm-offsets.c:138:6: warning: no previous prototype for 'output_thread_fpu_defines' [-Wmissing-prototypes]
     138 | void output_thread_fpu_defines(void)
         |      ^~~~~~~~~~~~~~~~~~~~~~~~~
   arch/loongarch/kernel/asm-offsets.c:178:6: warning: no previous prototype for 'output_mm_defines' [-Wmissing-prototypes]
     178 | void output_mm_defines(void)
         |      ^~~~~~~~~~~~~~~~~
   arch/loongarch/kernel/asm-offsets.c:210:6: warning: no previous prototype for 'output_sc_defines' [-Wmissing-prototypes]
     210 | void output_sc_defines(void)
         |      ^~~~~~~~~~~~~~~~~
   arch/loongarch/kernel/asm-offsets.c:218:6: warning: no previous prototype for 'output_signal_defines' [-Wmissing-prototypes]
     218 | void output_signal_defines(void)
         |      ^~~~~~~~~~~~~~~~~~~~~
   arch/loongarch/kernel/asm-offsets.c:256:6: warning: no previous prototype for 'output_smpboot_defines' [-Wmissing-prototypes]
     256 | void output_smpboot_defines(void)
         |      ^~~~~~~~~~~~~~~~~~~~~~
   arch/loongarch/kernel/asm-offsets.c:266:6: warning: no previous prototype for 'output_pbe_defines' [-Wmissing-prototypes]
     266 | void output_pbe_defines(void)
         |      ^~~~~~~~~~~~~~~~~~
>> arch/loongarch/kernel/asm-offsets.c:277:6: warning: no previous prototype for 'output_kvm_defines' [-Wmissing-prototypes]
     277 | void output_kvm_defines(void)
         |      ^~~~~~~~~~~~~~~~~~
--
   arch/loongarch/kernel/asm-offsets.c:17:6: warning: no previous prototype for 'output_ptreg_defines' [-Wmissing-prototypes]
      17 | void output_ptreg_defines(void)
         |      ^~~~~~~~~~~~~~~~~~~~
   arch/loongarch/kernel/asm-offsets.c:64:6: warning: no previous prototype for 'output_task_defines' [-Wmissing-prototypes]
      64 | void output_task_defines(void)
         |      ^~~~~~~~~~~~~~~~~~~
   arch/loongarch/kernel/asm-offsets.c:79:6: warning: no previous prototype for 'output_thread_info_defines' [-Wmissing-prototypes]
      79 | void output_thread_info_defines(void)
         |      ^~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/loongarch/kernel/asm-offsets.c:95:6: warning: no previous prototype for 'output_thread_defines' [-Wmissing-prototypes]
      95 | void output_thread_defines(void)
         |      ^~~~~~~~~~~~~~~~~~~~~
   arch/loongarch/kernel/asm-offsets.c:138:6: warning: no previous prototype for 'output_thread_fpu_defines' [-Wmissing-prototypes]
     138 | void output_thread_fpu_defines(void)
         |      ^~~~~~~~~~~~~~~~~~~~~~~~~
   arch/loongarch/kernel/asm-offsets.c:178:6: warning: no previous prototype for 'output_mm_defines' [-Wmissing-prototypes]
     178 | void output_mm_defines(void)
         |      ^~~~~~~~~~~~~~~~~
   arch/loongarch/kernel/asm-offsets.c:210:6: warning: no previous prototype for 'output_sc_defines' [-Wmissing-prototypes]
     210 | void output_sc_defines(void)
         |      ^~~~~~~~~~~~~~~~~
   arch/loongarch/kernel/asm-offsets.c:218:6: warning: no previous prototype for 'output_signal_defines' [-Wmissing-prototypes]
     218 | void output_signal_defines(void)
         |      ^~~~~~~~~~~~~~~~~~~~~
   arch/loongarch/kernel/asm-offsets.c:256:6: warning: no previous prototype for 'output_smpboot_defines' [-Wmissing-prototypes]
     256 | void output_smpboot_defines(void)
         |      ^~~~~~~~~~~~~~~~~~~~~~
   arch/loongarch/kernel/asm-offsets.c:266:6: warning: no previous prototype for 'output_pbe_defines' [-Wmissing-prototypes]
     266 | void output_pbe_defines(void)
         |      ^~~~~~~~~~~~~~~~~~
>> arch/loongarch/kernel/asm-offsets.c:277:6: warning: no previous prototype for 'output_kvm_defines' [-Wmissing-prototypes]
     277 | void output_kvm_defines(void)
         |      ^~~~~~~~~~~~~~~~~~
   <stdin>:569:2: warning: #warning syscall fstat not implemented [-Wcpp]


vim +/output_kvm_defines +277 arch/loongarch/kernel/asm-offsets.c

   276	
 > 277	void output_kvm_defines(void)

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
