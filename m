Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDB7F6ADE7F
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 13:16:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231556AbjCGMQW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Mar 2023 07:16:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231483AbjCGMQG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Mar 2023 07:16:06 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38C9D769FE;
        Tue,  7 Mar 2023 04:15:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678191305; x=1709727305;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=6O7hG9U+DTFJVH1dbtQKzCcJYBXYsb17kRaZ4RamDEU=;
  b=TUXPdYB7ImclvDGzDP5qLkop8w2+lGrMFm+Q7wBp2Q3dS6R3tU9M+EDO
   p7Si7V295EGwW0QCfzPmF3GmhLm3JBL8H1NSY7Ihi78YlGwYae1IvDSyQ
   //pXHHq37+jdsihllybDL3tbxifcTivOWcaDocsgm2h3MnF8KaJDbTmmx
   my24JesCFNxFEboSxJgZ/6+bxKAWbbqEVkqMtUtrOIYdpAMMzZ43440km
   EGb5DxZKcDLQFdOP2TqPdUKoC7BPjq/0Fuj4ZbCSmu6YcPOV4rBUqk2vy
   4wtcrekV7ASLIcNTwdLLUSlwj4BHnpof++URN8QK5wCHpgideK0AZnaTl
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="319665869"
X-IronPort-AV: E=Sophos;i="5.98,240,1673942400"; 
   d="scan'208";a="319665869"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2023 04:14:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="819742253"
X-IronPort-AV: E=Sophos;i="5.98,240,1673942400"; 
   d="scan'208";a="819742253"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 07 Mar 2023 04:14:04 -0800
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pZWCh-0001IG-1U;
        Tue, 07 Mar 2023 12:14:03 +0000
Date:   Tue, 7 Mar 2023 20:13:12 +0800
From:   kernel test robot <lkp@intel.com>
To:     Vipin Sharma <vipinsh@google.com>, seanjc@google.com,
        pbonzini@redhat.com, bgardon@google.com, dmatlack@google.com
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        jmattson@google.com, mizhang@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vipin Sharma <vipinsh@google.com>
Subject: Re: [Patch v4 03/18] KVM: x86/mmu: Track count of pages in KVM MMU
 page caches globally
Message-ID: <202303071922.uBuWNRnA-lkp@intel.com>
References: <20230306224127.1689967-4-vipinsh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230306224127.1689967-4-vipinsh@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Vipin,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on kvm/queue]
[also build test WARNING on kvmarm/next linus/master v6.3-rc1 next-20230307]
[cannot apply to mst-vhost/linux-next kvm/linux-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Vipin-Sharma/KVM-x86-mmu-Change-KVM-mmu-shrinker-to-no-op/20230307-064510
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
patch link:    https://lore.kernel.org/r/20230306224127.1689967-4-vipinsh%40google.com
patch subject: [Patch v4 03/18] KVM: x86/mmu: Track count of pages in KVM MMU page caches globally
config: x86_64-randconfig-a016-20230306 (https://download.01.org/0day-ci/archive/20230307/202303071922.uBuWNRnA-lkp@intel.com/config)
compiler: clang version 14.0.6 (https://github.com/llvm/llvm-project f28c006a5895fc0e329fe15fead81e37457cb1d1)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/511e837798da25063830276b8a3345c7601c6459
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Vipin-Sharma/KVM-x86-mmu-Change-KVM-mmu-shrinker-to-no-op/20230307-064510
        git checkout 511e837798da25063830276b8a3345c7601c6459
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash arch/x86/kvm/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303071922.uBuWNRnA-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> arch/x86/kvm/mmu/mmu.c:676: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
    * Caller should hold mutex lock corresponding to cache, if available.
   arch/x86/kvm/mmu/mmu.c:693: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
    * Caller should hold mutex lock corresponding to kvm_mmu_memory_cache, if
   arch/x86/kvm/mmu/mmu.c:1404: warning: Function parameter or member 'kvm' not described in 'kvm_arch_mmu_enable_log_dirty_pt_masked'
   arch/x86/kvm/mmu/mmu.c:1404: warning: Function parameter or member 'slot' not described in 'kvm_arch_mmu_enable_log_dirty_pt_masked'
   arch/x86/kvm/mmu/mmu.c:1404: warning: Function parameter or member 'gfn_offset' not described in 'kvm_arch_mmu_enable_log_dirty_pt_masked'
   arch/x86/kvm/mmu/mmu.c:1404: warning: Function parameter or member 'mask' not described in 'kvm_arch_mmu_enable_log_dirty_pt_masked'


vim +676 arch/x86/kvm/mmu/mmu.c

   674	
   675	/**
 > 676	 * Caller should hold mutex lock corresponding to cache, if available.
   677	 */
   678	static int mmu_topup_sp_memory_cache(struct kvm_mmu_memory_cache *cache,
   679					     int min)
   680	{
   681		int orig_nobjs, r;
   682	
   683		orig_nobjs = cache->nobjs;
   684		r = kvm_mmu_topup_memory_cache(cache, min);
   685		if (orig_nobjs != cache->nobjs)
   686			percpu_counter_add(&kvm_total_unused_cached_pages,
   687					   (cache->nobjs - orig_nobjs));
   688	
   689		return r;
   690	}
   691	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
