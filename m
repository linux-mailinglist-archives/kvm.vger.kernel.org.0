Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 250984BEC26
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 21:58:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234112AbiBUU7K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 15:59:10 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234099AbiBUU7J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 15:59:09 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81FEF237F4;
        Mon, 21 Feb 2022 12:58:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645477125; x=1677013125;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Q8VbVq+l2O93VD3PU9iLNfpkN2dA3vfhrpThY/iQv7k=;
  b=CuSW0yR16nYDmv8KQCiFubbtrGT6I8N3Nxt/QWSg9FmW3Rs1NafrOEnU
   /tOkJgomlM6ErdLdFHoYL/TshgcVLX4JU5GZKakl70q2dFA9fy4dBLddE
   DuKSKM5Yg0lFoYWgtFnPy5LJjGSaclI84CDN3hPwIWJLpeSfmhc7Dm3/f
   pDW6glRrcIbHatrxanc6TCf1A5g/p0nssFTl6v87KK4v6kkCv/X7NAtFx
   eEUGmBEjShdSYcZ86YpECfm0OZyLlX44mBd6Au4PYw6WbDNEq369gVOg0
   IQnQuii7TT7j25gTfPwpyRpv6B0JgT0aBcjht6K/CthihvzCNZ0nmmPwZ
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10265"; a="238984546"
X-IronPort-AV: E=Sophos;i="5.88,386,1635231600"; 
   d="scan'208";a="238984546"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2022 12:58:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,386,1635231600"; 
   d="scan'208";a="591075000"
Received: from lkp-server01.sh.intel.com (HELO da3212ac2f54) ([10.239.97.150])
  by fmsmga008.fm.intel.com with ESMTP; 21 Feb 2022 12:58:41 -0800
Received: from kbuild by da3212ac2f54 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nMFlZ-0001ya-5Z; Mon, 21 Feb 2022 20:58:41 +0000
Date:   Tue, 22 Feb 2022 04:57:51 +0800
From:   kernel test robot <lkp@intel.com>
To:     Like Xu <like.xu.linux@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>
Subject: Re: [PATCH 09/11] KVM: x86/pmu: Replace pmc_perf_hw_id() with
 perf_get_hw_event_config()
Message-ID: <202202220414.dzxjtMiF-lkp@intel.com>
References: <20220221115201.22208-10-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220221115201.22208-10-likexu@tencent.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Like,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on kvm/master]
[also build test WARNING on linus/master v5.17-rc5 next-20220217]
[cannot apply to tip/perf/core mst-vhost/linux-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Like-Xu/KVM-x86-pmu-Get-rid-of-PERF_TYPE_HARDWAR-and-other-minor-fixes/20220221-195359
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git master
config: x86_64-randconfig-c007-20220221 (https://download.01.org/0day-ci/archive/20220222/202202220414.dzxjtMiF-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project d271fc04d5b97b12e6b797c6067d3c96a8d7470e)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/29bdfb8b85a85f36e3fca739146845d7050a372d
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Like-Xu/KVM-x86-pmu-Get-rid-of-PERF_TYPE_HARDWAR-and-other-minor-fixes/20220221-195359
        git checkout 29bdfb8b85a85f36e3fca739146845d7050a372d
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash arch/x86/kvm/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> arch/x86/kvm/pmu.c:471:66: warning: use of logical '&&' with constant operand [-Wconstant-logical-operand]
           return !((pmc->eventsel ^ perf_get_hw_event_config(perf_hw_id)) &&
                                                                           ^
   arch/x86/kvm/pmu.c:471:66: note: use '&' for a bitwise operation
           return !((pmc->eventsel ^ perf_get_hw_event_config(perf_hw_id)) &&
                                                                           ^~
                                                                           &
   arch/x86/kvm/pmu.c:471:66: note: remove constant to silence this warning
           return !((pmc->eventsel ^ perf_get_hw_event_config(perf_hw_id)) &&
                                                                          ~^~
   1 warning generated.


vim +471 arch/x86/kvm/pmu.c

   467	
   468	static inline bool eventsel_match_perf_hw_id(struct kvm_pmc *pmc,
   469		unsigned int perf_hw_id)
   470	{
 > 471		return !((pmc->eventsel ^ perf_get_hw_event_config(perf_hw_id)) &&
   472			AMD64_RAW_EVENT_MASK_NB);
   473	}
   474	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
