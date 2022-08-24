Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E93675A000C
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 19:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239792AbiHXRGh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Aug 2022 13:06:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239872AbiHXRGa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Aug 2022 13:06:30 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6247C79618
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 10:06:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661360790; x=1692896790;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=kuJIEmvEJRGEPbAreAu7/ngFTTzqUxHPhS+1/4Uls+A=;
  b=BAVZbqWOe+h84xhueHYDJ24lQkexCeKJ04zv1o6SQSR8W1fOxMfbM6ob
   x106TucWODU/U0/cb3RZZXOcw62v/p+/dvU9FzlhrkozbCp/vldkVgWYp
   NGUjDsGnIrgN6e+Vsq96k3H5mldiI3aGFcbbzjvuxDUE4Y9QeQ8qWOSUj
   auCbFkDP28saj/NFEEoDYDjSYA9FSIZgINVHxvP0PnfesgSosIztQRA8+
   BBFMOlsaKnjW0osLJqiIhDty9oURAlRdNh2cFIJ/dvmVc5cG45cmK3pNM
   vSkAXhGc5L3M94BSfr31KBSlku4nPr8ihmk9daFN9F5M9I1rBxBi9/Yov
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10449"; a="320088384"
X-IronPort-AV: E=Sophos;i="5.93,260,1654585200"; 
   d="scan'208";a="320088384"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2022 10:06:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,260,1654585200"; 
   d="scan'208";a="785696533"
Received: from lkp-server02.sh.intel.com (HELO 34e741d32628) ([10.239.97.151])
  by orsmga005.jf.intel.com with ESMTP; 24 Aug 2022 10:06:25 -0700
Received: from kbuild by 34e741d32628 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oQtpg-0000rt-2q;
        Wed, 24 Aug 2022 17:06:24 +0000
Date:   Thu, 25 Aug 2022 01:06:23 +0800
From:   kernel test robot <lkp@intel.com>
To:     David Matlack <dmatlack@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kbuild-all@lists.01.org, Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@suse.de>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        kvm@vger.kernel.org, David Matlack <dmatlack@google.com>
Subject: Re: [PATCH 5/9] KVM: x86/mmu: Separate TDP and non-paging fault
 handling
Message-ID: <202208250034.Vo6dL7C7-lkp@intel.com>
References: <20220815230110.2266741-6-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220815230110.2266741-6-dmatlack@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi David,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on 93472b79715378a2386598d6632c654a2223267b]

url:    https://github.com/intel-lab-lkp/linux/commits/David-Matlack/KVM-x86-mmu-Always-enable-the-TDP-MMU-when-TDP-is-enabled/20220816-135710
base:   93472b79715378a2386598d6632c654a2223267b
config: i386-debian-10.3-kselftests (https://download.01.org/0day-ci/archive/20220825/202208250034.Vo6dL7C7-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-5) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/0cbb5e1684635e3f36d0283f5b3696b0ee0660e1
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review David-Matlack/KVM-x86-mmu-Always-enable-the-TDP-MMU-when-TDP-is-enabled/20220816-135710
        git checkout 0cbb5e1684635e3f36d0283f5b3696b0ee0660e1
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>, old ones prefixed by <<):

ERROR: modpost: "kvm_tdp_mmu_test_age_gfn" [arch/x86/kvm/kvm.ko] undefined!
ERROR: modpost: "kvm_tdp_mmu_zap_all" [arch/x86/kvm/kvm.ko] undefined!
ERROR: modpost: "kvm_tdp_mmu_clear_dirty_pt_masked" [arch/x86/kvm/kvm.ko] undefined!
>> ERROR: modpost: "kvm_tdp_mmu_map" [arch/x86/kvm/kvm.ko] undefined!
ERROR: modpost: "kvm_tdp_mmu_age_gfn_range" [arch/x86/kvm/kvm.ko] undefined!
ERROR: modpost: "kvm_tdp_mmu_zap_leafs" [arch/x86/kvm/kvm.ko] undefined!
ERROR: modpost: "kvm_tdp_mmu_unmap_gfn_range" [arch/x86/kvm/kvm.ko] undefined!
ERROR: modpost: "kvm_tdp_mmu_invalidate_all_roots" [arch/x86/kvm/kvm.ko] undefined!
ERROR: modpost: "kvm_tdp_mmu_get_vcpu_root_hpa" [arch/x86/kvm/kvm.ko] undefined!
ERROR: modpost: "kvm_tdp_mmu_set_spte_gfn" [arch/x86/kvm/kvm.ko] undefined!
WARNING: modpost: suppressed 6 unresolved symbol warnings because there were too many)

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
