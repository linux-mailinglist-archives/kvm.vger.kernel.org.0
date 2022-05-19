Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 866A352C9E3
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 04:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232983AbiESCnC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 22:43:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233017AbiESCm6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 22:42:58 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28F28D9E95;
        Wed, 18 May 2022 19:42:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652928176; x=1684464176;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=l6xV8ekPzx3Yt2dpmJfC+atg0RJvwErhgJl3h4CHsSg=;
  b=Z6eSmOSaI+PW8Tze8JurZaE/hpOxkEg06iX77Sdx6dhDfjItJ1abTEtj
   eoSD84lKbiQgxEG1Pu9MwFHVChw2nkG9PdrsyIo3i8SEaprARniuASzvs
   mH5WfGzQfKf6Pn1XFDxc2+3wDNafNujQzhvAve++RmSo0lXmF84ynkHvK
   Vnd7ncFdgP8IPS+l9PKoIZDGv4rv2iwu7wHY0tAmumLIbM1il3gJYGTIY
   /5pjzLpo+lYx3lKyawmFzZTWnUxVYl5zAE1lCG8Ee03unhtS80MpI9bZN
   xQOn/caeneTlxsN1HzTM0vePT9wTMrHJfNkSrQYX6567x/k5XjK7XQbZS
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10351"; a="271680412"
X-IronPort-AV: E=Sophos;i="5.91,236,1647327600"; 
   d="scan'208";a="271680412"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2022 19:42:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,236,1647327600"; 
   d="scan'208";a="545836026"
Received: from lkp-server02.sh.intel.com (HELO 242b25809ac7) ([10.239.97.151])
  by orsmga006.jf.intel.com with ESMTP; 18 May 2022 19:42:44 -0700
Received: from kbuild by 242b25809ac7 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nrW7f-0002xn-4X;
        Thu, 19 May 2022 02:42:43 +0000
Date:   Thu, 19 May 2022 10:42:17 +0800
From:   kernel test robot <lkp@intel.com>
To:     Uros Bizjak <ubizjak@gmail.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        Uros Bizjak <ubizjak@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH] KVM: VMX: Use try_cmpxchg64 in pi_try_set_control
Message-ID: <202205191028.PcCtw7Xz-lkp@intel.com>
References: <20220518134550.2358-1-ubizjak@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220518134550.2358-1-ubizjak@gmail.com>
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Uros,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on kvm/master]
[also build test ERROR on mst-vhost/linux-next linux/master linus/master v5.18-rc7 next-20220518]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Uros-Bizjak/KVM-VMX-Use-try_cmpxchg64-in-pi_try_set_control/20220518-214709
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git master
config: i386-randconfig-a002 (https://download.01.org/0day-ci/archive/20220519/202205191028.PcCtw7Xz-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 853fa8ee225edf2d0de94b0dcbd31bea916e825e)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/2af4f7c4ecfcaedf9b98ba30ee508dc0d9002955
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Uros-Bizjak/KVM-VMX-Use-try_cmpxchg64-in-pi_try_set_control/20220518-214709
        git checkout 2af4f7c4ecfcaedf9b98ba30ee508dc0d9002955
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash arch/x86/kvm/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> arch/x86/kvm/vmx/posted_intr.c:45:7: error: call to undeclared function 'try_cmpxchg64'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
           if (!try_cmpxchg64(&pi_desc->control, pold, new))
                ^
   arch/x86/kvm/vmx/posted_intr.c:45:7: note: did you mean '__cmpxchg64'?
   arch/x86/include/asm/cmpxchg_32.h:47:19: note: '__cmpxchg64' declared here
   static inline u64 __cmpxchg64(volatile u64 *ptr, u64 old, u64 new)
                     ^
   1 error generated.


vim +/try_cmpxchg64 +45 arch/x86/kvm/vmx/posted_intr.c

    36	
    37	static int pi_try_set_control(struct pi_desc *pi_desc, u64 *pold, u64 new)
    38	{
    39		/*
    40		 * PID.ON can be set at any time by a different vCPU or by hardware,
    41		 * e.g. a device.  PID.control must be written atomically, and the
    42		 * update must be retried with a fresh snapshot an ON change causes
    43		 * the cmpxchg to fail.
    44		 */
  > 45		if (!try_cmpxchg64(&pi_desc->control, pold, new))
    46			return -EBUSY;
    47	
    48		return 0;
    49	}
    50	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
