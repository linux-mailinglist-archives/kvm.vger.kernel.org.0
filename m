Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A8E26E3443
	for <lists+kvm@lfdr.de>; Sun, 16 Apr 2023 00:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbjDOWKE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 15 Apr 2023 18:10:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjDOWKC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 15 Apr 2023 18:10:02 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9E4D2D56
        for <kvm@vger.kernel.org>; Sat, 15 Apr 2023 15:10:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681596600; x=1713132600;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Os+p0upBEWbxGvNLlKpp2n+3KvGMCu7BXDKIpiqGD+c=;
  b=edNn+czquF8UFqT3ktgZBWAovhDstN2LYxIBrwsRH+MDFfokMGHOBDJX
   ghfpTQTuJmFru5Y4N6GGepzrhC6g57tZWVaxuyQ7WwuQkCwP3TS6hC4eQ
   EPwS99kNI/IX37cqApUUQ8e3OItPZ6fzDmi+bJDjoQ80K6BUrJBtuc1OW
   CbrataPj6EPnmwfyAhF23ddnyw3pvn9spbpRt845bAtARWkPsdJoo7RLJ
   gA6jxhyPrxam1hs3eUl9ioVsy9bTHWafhnMnjExKr0YWJvJuzQTOZeIrc
   b57/CxrV7G8byq2sSKXVPrGm63WGMK87BPHcQe/qTtg+Npmvr7kkXxRSl
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10681"; a="333472501"
X-IronPort-AV: E=Sophos;i="5.99,201,1677571200"; 
   d="scan'208";a="333472501"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2023 15:10:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10681"; a="814326955"
X-IronPort-AV: E=Sophos;i="5.99,201,1677571200"; 
   d="scan'208";a="814326955"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 15 Apr 2023 15:09:55 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pno5i-000bNb-1X;
        Sat, 15 Apr 2023 22:09:54 +0000
Date:   Sun, 16 Apr 2023 06:09:04 +0800
From:   kernel test robot <lkp@intel.com>
To:     Reiji Watanabe <reijiw@google.com>, Marc Zyngier <maz@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        kvmarm@lists.linux.dev
Cc:     oe-kbuild-all@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Shaoqin Huang <shahuang@redhat.com>,
        Rob Herring <robh@kernel.org>,
        Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH v3 2/2] KVM: arm64: PMU: Don't overwrite PMUSERENR with
 vcpu loaded
Message-ID: <202304160658.Oqr1xZbi-lkp@intel.com>
References: <20230415164029.526895-3-reijiw@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230415164029.526895-3-reijiw@google.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Reiji,

kernel test robot noticed the following build errors:

[auto build test ERROR on 09a9639e56c01c7a00d6c0ca63f4c7c41abe075d]

url:    https://github.com/intel-lab-lkp/linux/commits/Reiji-Watanabe/KVM-arm64-PMU-Restore-the-host-s-PMUSERENR_EL0/20230416-004142
base:   09a9639e56c01c7a00d6c0ca63f4c7c41abe075d
patch link:    https://lore.kernel.org/r/20230415164029.526895-3-reijiw%40google.com
patch subject: [PATCH v3 2/2] KVM: arm64: PMU: Don't overwrite PMUSERENR with vcpu loaded
config: arm64-allyesconfig (https://download.01.org/0day-ci/archive/20230416/202304160658.Oqr1xZbi-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/276e15e5db09003944d194da2b2577cff5192884
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Reiji-Watanabe/KVM-arm64-PMU-Restore-the-host-s-PMUSERENR_EL0/20230416-004142
        git checkout 276e15e5db09003944d194da2b2577cff5192884
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=arm64 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=arm64 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202304160658.Oqr1xZbi-lkp@intel.com/

All errors (new ones prefixed by >>):

   aarch64-linux-ld: Unexpected GOT/PLT entries detected!
   aarch64-linux-ld: Unexpected run-time procedure linkages detected!
   aarch64-linux-ld: arch/arm64/kvm/hyp/nvhe/kvm_nvhe.o: in function `__kvm_nvhe___activate_traps_common':
>> __kvm_nvhe_switch.c:(.hyp.text+0x14b4): undefined reference to `__kvm_nvhe_warn_bogus_irq_restore'
   aarch64-linux-ld: arch/arm64/kvm/hyp/nvhe/kvm_nvhe.o: in function `__kvm_nvhe___deactivate_traps_common':
   __kvm_nvhe_switch.c:(.hyp.text+0x1f6c): undefined reference to `__kvm_nvhe_warn_bogus_irq_restore'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
