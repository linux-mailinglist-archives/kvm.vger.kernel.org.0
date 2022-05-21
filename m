Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AAAC52FAB7
	for <lists+kvm@lfdr.de>; Sat, 21 May 2022 12:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233811AbiEUKpo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 21 May 2022 06:45:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiEUKpk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 21 May 2022 06:45:40 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C25967D32;
        Sat, 21 May 2022 03:45:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653129939; x=1684665939;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=THS3frs05rhmQUjFPvgFuEIt/YVzc4/2LQdY6c296Ck=;
  b=AplcfcTSj2an4x3oaZ197HSbQ2QF0qOoaM8dFj1oGn2xFiPiNaynXTAV
   s/Ap4C9FLhFkSW/djYf+pyjd7BAZdQBmAcYRTqJlJqLqefvvHd0xqc6eR
   pmKzAc5xxiN5i1NsdrlXsen5v1PvGhVRixku6NjD4G6LyHsgO8Vju0tWQ
   hUTu99RvJldl9TAD54j2gTbNLoqx9b+QEurNTRtm5p6BHFUCn3mDs+rli
   buTsr/3rBo7q/p0qqhvcZ/qigfd7UCyhMunTTsAD04hZkJndM6cDEFrCq
   QRkk2aJC0l4/cxRtq2Y/X3iiGJgpvHbxDNCK+3Y+YqClbTnI8VBgR9rAO
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10353"; a="254888883"
X-IronPort-AV: E=Sophos;i="5.91,242,1647327600"; 
   d="scan'208";a="254888883"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2022 03:45:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,242,1647327600"; 
   d="scan'208";a="571260401"
Received: from lkp-server02.sh.intel.com (HELO 242b25809ac7) ([10.239.97.151])
  by orsmga007.jf.intel.com with ESMTP; 21 May 2022 03:45:36 -0700
Received: from kbuild by 242b25809ac7 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nsMc4-0006DG-3O;
        Sat, 21 May 2022 10:45:36 +0000
Date:   Sat, 21 May 2022 18:45:33 +0800
From:   kernel test robot <lkp@intel.com>
To:     Uros Bizjak <ubizjak@gmail.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Uros Bizjak <ubizjak@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH v2] KVM: VMX: Use try_cmpxchg64 in pi_try_set_control
Message-ID: <202205211837.X2KKIXbP-lkp@intel.com>
References: <20220520143737.62513-1-ubizjak@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220520143737.62513-1-ubizjak@gmail.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Uros,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on kvm/master]
[also build test ERROR on mst-vhost/linux-next linux/master linus/master v5.18-rc7]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Uros-Bizjak/KVM-VMX-Use-try_cmpxchg64-in-pi_try_set_control/20220520-223925
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git master
config: x86_64-allyesconfig (https://download.01.org/0day-ci/archive/20220521/202205211837.X2KKIXbP-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-1) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/84128ccce45cc3ece9b9f8d4df8afa81651547c9
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Uros-Bizjak/KVM-VMX-Use-try_cmpxchg64-in-pi_try_set_control/20220520-223925
        git checkout 84128ccce45cc3ece9b9f8d4df8afa81651547c9
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   arch/x86/kvm/vmx/posted_intr.c: In function 'pi_try_set_control':
>> arch/x86/kvm/vmx/posted_intr.c:45:14: error: implicit declaration of function 'try_cmpxchg64'; did you mean 'try_cmpxchg'? [-Werror=implicit-function-declaration]
      45 |         if (!try_cmpxchg64(&pi_desc->control, &old, new))
         |              ^~~~~~~~~~~~~
         |              try_cmpxchg
   cc1: some warnings being treated as errors


vim +45 arch/x86/kvm/vmx/posted_intr.c

    36	
    37	static int pi_try_set_control(struct pi_desc *pi_desc, u64 old, u64 new)
    38	{
    39		/*
    40		 * PID.ON can be set at any time by a different vCPU or by hardware,
    41		 * e.g. a device.  PID.control must be written atomically, and the
    42		 * update must be retried with a fresh snapshot an ON change causes
    43		 * the cmpxchg to fail.
    44		 */
  > 45		if (!try_cmpxchg64(&pi_desc->control, &old, new))
    46			return -EBUSY;
    47	
    48		return 0;
    49	}
    50	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
