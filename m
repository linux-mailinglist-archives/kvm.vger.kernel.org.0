Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A316E695A5C
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 08:12:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231977AbjBNHM1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 02:12:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231894AbjBNHMH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 02:12:07 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FB6622DDE;
        Mon, 13 Feb 2023 23:08:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676358525; x=1707894525;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=7mxrqjucLiuCXh3jkBMuGLi7BeMczW6z9ZSnKt52TSc=;
  b=EhMyNz8ugA8EgruVcE7JAIGXHDuwwlGgcVV0TQNgww+Ny2bGkhtkEZi2
   ZF+RMwqPLd2MAyTaWf67Tj8r6GQtZMj9n3+GhgitkP3I7l3QBGJlWA6Sq
   ZcQtm6QGLWlcmC1RTYn43cz68qS10SSZ9W+rA9243GnTzAKBxKBIqj2xz
   HO+d/IUZ6Pt7K2m405NFHLXXztNIQ5xbIX+RKNfrM9yvN7a7Jth81WHnV
   FOoOeUy8nuH3fDP3wfB8y4VL7QqhmmWfpeRFHGObgquJxCxMG4qllWW/A
   I8cmovKRDUdoWcxAeZPxCWDpTsZeFuiLeqg3tN4qBnHxB0YTwsTzxxyPU
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="393499245"
X-IronPort-AV: E=Sophos;i="5.97,296,1669104000"; 
   d="scan'208";a="393499245"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 23:08:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="618939126"
X-IronPort-AV: E=Sophos;i="5.97,296,1669104000"; 
   d="scan'208";a="618939126"
Received: from lkp-server01.sh.intel.com (HELO 4455601a8d94) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 13 Feb 2023 23:07:59 -0800
Received: from kbuild by 4455601a8d94 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pRpPy-0008I9-1S;
        Tue, 14 Feb 2023 07:07:58 +0000
Date:   Tue, 14 Feb 2023 15:07:23 +0800
From:   kernel test robot <lkp@intel.com>
To:     Tianrui Zhao <zhaotianrui@loongson.cn>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     oe-kbuild-all@lists.linux.dev, Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: Re: [PATCH v1 22/24] LoongArch: KVM: Implement vcpu world switch
Message-ID: <202302141408.1hBkpMAf-lkp@intel.com>
References: <20230214025648.1898508-23-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230214025648.1898508-23-zhaotianrui@loongson.cn>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Tianrui,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on kvm/queue]
[also build test WARNING on linus/master v6.2-rc8]
[cannot apply to kvm/linux-next next-20230214]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Tianrui-Zhao/LoongArch-KVM-Implement-kvm-module-related-interface/20230214-110506
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
patch link:    https://lore.kernel.org/r/20230214025648.1898508-23-zhaotianrui%40loongson.cn
patch subject: [PATCH v1 22/24] LoongArch: KVM: Implement vcpu world switch
config: loongarch-allyesconfig (https://download.01.org/0day-ci/archive/20230214/202302141408.1hBkpMAf-lkp@intel.com/config)
compiler: loongarch64-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/1adfa2faabc606d0813446b2d2111e04aa3d2828
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Tianrui-Zhao/LoongArch-KVM-Implement-kvm-module-related-interface/20230214-110506
        git checkout 1adfa2faabc606d0813446b2d2111e04aa3d2828
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=loongarch olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=loongarch prepare

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202302141408.1hBkpMAf-lkp@intel.com/

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

   217	
 > 218	void output_signal_defines(void)
   219	{
   220		COMMENT("Linux signal numbers.");
   221		DEFINE(_SIGHUP, SIGHUP);
   222		DEFINE(_SIGINT, SIGINT);
   223		DEFINE(_SIGQUIT, SIGQUIT);
   224		DEFINE(_SIGILL, SIGILL);
   225		DEFINE(_SIGTRAP, SIGTRAP);
   226		DEFINE(_SIGIOT, SIGIOT);
   227		DEFINE(_SIGABRT, SIGABRT);
   228		DEFINE(_SIGFPE, SIGFPE);
   229		DEFINE(_SIGKILL, SIGKILL);
   230		DEFINE(_SIGBUS, SIGBUS);
   231		DEFINE(_SIGSEGV, SIGSEGV);
   232		DEFINE(_SIGSYS, SIGSYS);
   233		DEFINE(_SIGPIPE, SIGPIPE);
   234		DEFINE(_SIGALRM, SIGALRM);
   235		DEFINE(_SIGTERM, SIGTERM);
   236		DEFINE(_SIGUSR1, SIGUSR1);
   237		DEFINE(_SIGUSR2, SIGUSR2);
   238		DEFINE(_SIGCHLD, SIGCHLD);
   239		DEFINE(_SIGPWR, SIGPWR);
   240		DEFINE(_SIGWINCH, SIGWINCH);
   241		DEFINE(_SIGURG, SIGURG);
   242		DEFINE(_SIGIO, SIGIO);
   243		DEFINE(_SIGSTOP, SIGSTOP);
   244		DEFINE(_SIGTSTP, SIGTSTP);
   245		DEFINE(_SIGCONT, SIGCONT);
   246		DEFINE(_SIGTTIN, SIGTTIN);
   247		DEFINE(_SIGTTOU, SIGTTOU);
   248		DEFINE(_SIGVTALRM, SIGVTALRM);
   249		DEFINE(_SIGPROF, SIGPROF);
   250		DEFINE(_SIGXCPU, SIGXCPU);
   251		DEFINE(_SIGXFSZ, SIGXFSZ);
   252		BLANK();
   253	}
   254	
   255	#ifdef CONFIG_SMP
   256	void output_smpboot_defines(void)
   257	{
   258		COMMENT("Linux smp cpu boot offsets.");
   259		OFFSET(CPU_BOOT_STACK, secondary_data, stack);
   260		OFFSET(CPU_BOOT_TINFO, secondary_data, thread_info);
   261		BLANK();
   262	}
   263	#endif
   264	
   265	#ifdef CONFIG_HIBERNATION
   266	void output_pbe_defines(void)
   267	{
   268		COMMENT(" Linux struct pbe offsets. ");
   269		OFFSET(PBE_ADDRESS, pbe, address);
   270		OFFSET(PBE_ORIG_ADDRESS, pbe, orig_address);
   271		OFFSET(PBE_NEXT, pbe, next);
   272		DEFINE(PBE_SIZE, sizeof(struct pbe));
   273		BLANK();
   274	}
   275	#endif
   276	
 > 277	void output_kvm_defines(void)

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
