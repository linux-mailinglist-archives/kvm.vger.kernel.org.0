Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C9E45A7A92
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 11:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbiHaJuJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 05:50:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiHaJuI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 05:50:08 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6145313D14;
        Wed, 31 Aug 2022 02:50:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661939406; x=1693475406;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=w8dohBsUnNgNN5IHL66P9ft9i1qrWZxpzUPmgsUyMx4=;
  b=AxuD2o3jER0cNKyCdZg6dRpjPX6ragzmECxiB5wPA6S905oav/U2fE7H
   ZFCWCAHbDjBiIUXtWa2l5xOH4gaOC6Df4YhXt1BQRnLgvJH5Mu38RYBe/
   7dsmsnRkYgU6CDS7UjtzJJjnfHHOVCNrZUVw5J4zjM8JNqsSFOQOfVrmO
   /FrwZRnlMSbNgo4nH42wv9HwtlYJRltUKdE8HFqaF6nBIdvK9s5wai05H
   o7oJH7IqpCfQfcix3Qh8S5xobAn+NQEGfZPChbe86YgdbVfruJoVM6CtG
   9VdGOMIgBBxSAbfYwsWnBWYOo/0FugU13MzJtE42UcmjcBWvw9DUuIAUx
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10455"; a="321552591"
X-IronPort-AV: E=Sophos;i="5.93,277,1654585200"; 
   d="scan'208";a="321552591"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2022 02:50:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,277,1654585200"; 
   d="scan'208";a="645177250"
Received: from lkp-server02.sh.intel.com (HELO 811e2ceaf0e5) ([10.239.97.151])
  by orsmga001.jf.intel.com with ESMTP; 31 Aug 2022 02:50:02 -0700
Received: from kbuild by 811e2ceaf0e5 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oTKMD-0000BB-1x;
        Wed, 31 Aug 2022 09:50:01 +0000
Date:   Wed, 31 Aug 2022 17:49:27 +0800
From:   kernel test robot <lkp@intel.com>
To:     Sean Christopherson <seanjc@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Like Xu <like.xu.linux@gmail.com>
Subject: Re: [PATCH v3 3/3] KVM: VMX: Advertise PMU LBRs if and only if perf
 supports LBRs
Message-ID: <202208311746.VAzmtgNx-lkp@intel.com>
References: <20220831000051.4015031-4-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220831000051.4015031-4-seanjc@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

I love your patch! Yet something to improve:

[auto build test ERROR on 372d07084593dc7a399bf9bee815711b1fb1bcf2]

url:    https://github.com/intel-lab-lkp/linux/commits/Sean-Christopherson/KVM-x86-Intel-LBR-related-perf-cleanups/20220831-080309
base:   372d07084593dc7a399bf9bee815711b1fb1bcf2
config: x86_64-randconfig-a012 (https://download.01.org/0day-ci/archive/20220831/202208311746.VAzmtgNx-lkp@intel.com/config)
compiler: clang version 14.0.6 (https://github.com/llvm/llvm-project f28c006a5895fc0e329fe15fead81e37457cb1d1)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/094f42374997562fff3f9f9637ec9aa8257490a0
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Sean-Christopherson/KVM-x86-Intel-LBR-related-perf-cleanups/20220831-080309
        git checkout 094f42374997562fff3f9f9637ec9aa8257490a0
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 prepare

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from arch/x86/kernel/asm-offsets.c:22:
   In file included from arch/x86/kernel/../kvm/vmx/vmx.h:11:
>> arch/x86/kernel/../kvm/vmx/capabilities.h:416:2: error: implicit declaration of function 'x86_perf_get_lbr' is invalid in C99 [-Werror,-Wimplicit-function-declaration]
           x86_perf_get_lbr(&lbr);
           ^
   1 error generated.
   make[2]: *** [scripts/Makefile.build:117: arch/x86/kernel/asm-offsets.s] Error 1
   make[2]: Target '__build' not remade because of errors.
   make[1]: *** [Makefile:1207: prepare0] Error 2
   make[1]: Target 'prepare' not remade because of errors.
   make: *** [Makefile:222: __sub-make] Error 2
   make: Target 'prepare' not remade because of errors.


vim +/x86_perf_get_lbr +416 arch/x86/kernel/../kvm/vmx/capabilities.h

   403	
   404	static inline u64 vmx_get_perf_capabilities(void)
   405	{
   406		u64 perf_cap = PMU_CAP_FW_WRITES;
   407		struct x86_pmu_lbr lbr;
   408		u64 host_perf_cap = 0;
   409	
   410		if (!enable_pmu)
   411			return 0;
   412	
   413		if (boot_cpu_has(X86_FEATURE_PDCM))
   414			rdmsrl(MSR_IA32_PERF_CAPABILITIES, host_perf_cap);
   415	
 > 416		x86_perf_get_lbr(&lbr);
   417		if (lbr.nr)
   418			perf_cap |= host_perf_cap & PMU_CAP_LBR_FMT;
   419	
   420		if (vmx_pebs_supported()) {
   421			perf_cap |= host_perf_cap & PERF_CAP_PEBS_MASK;
   422			if ((perf_cap & PERF_CAP_PEBS_FORMAT) < 4)
   423				perf_cap &= ~PERF_CAP_PEBS_BASELINE;
   424		}
   425	
   426		return perf_cap;
   427	}
   428	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
