Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 389246F622E
	for <lists+kvm@lfdr.de>; Thu,  4 May 2023 01:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbjECXnq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 May 2023 19:43:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjECXno (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 May 2023 19:43:44 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 954DD8693
        for <kvm@vger.kernel.org>; Wed,  3 May 2023 16:43:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683157422; x=1714693422;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=qTenYN15vOzc0n9ab3eQwMr2KsWCXdTwEdx3dVCYBow=;
  b=jYAxGoJO0fDVSS+vr6Mi64f4NGcrP/omTTEPUYvZe1TDdGjO5k1h+H9Q
   Bw7tWhTfY4drtcxwfUu0ELq7RW2K/GZ/H9QZFh85XsVplzzehcVv94QKM
   bcIspTni/5cVqeYbyC211D6PGJN7anXH90ps1zoIqASaMsqYGI56gimGP
   iqrLjaugo5t3BVF07TNGxGtCBw1WQ0pC25rBcmm+myzUh9UOfiAKRodJl
   z+PSaFLH1ULElZmSe5dzz/uCOqfPFogNA/EyfR5fBwcOU/UaGjZODLcIf
   9yEU+Yudo/bw9Cg6N3GRFgjmQ4yR0IJMeDAYMbBwuvqLWJB3EstjA+5Sl
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10699"; a="350875771"
X-IronPort-AV: E=Sophos;i="5.99,248,1677571200"; 
   d="scan'208";a="350875771"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2023 16:43:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10699"; a="840881961"
X-IronPort-AV: E=Sophos;i="5.99,248,1677571200"; 
   d="scan'208";a="840881961"
Received: from lkp-server01.sh.intel.com (HELO e3434d64424d) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 03 May 2023 16:43:38 -0700
Received: from kbuild by e3434d64424d with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1puM8H-0002N8-2g;
        Wed, 03 May 2023 23:43:37 +0000
Date:   Thu, 4 May 2023 07:43:29 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jing Zhang <jingzhangos@google.com>, KVM <kvm@vger.kernel.org>,
        KVMARM <kvmarm@lists.linux.dev>,
        ARMLinux <linux-arm-kernel@lists.infradead.org>,
        Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@google.com>
Cc:     oe-kbuild-all@lists.linux.dev, Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Jing Zhang <jingzhangos@google.com>
Subject: Re: [PATCH v8 3/6] KVM: arm64: Use per guest ID register for
 ID_AA64PFR0_EL1.[CSV2|CSV3]
Message-ID: <202305040748.hUxGyrJF-lkp@intel.com>
References: <20230503171618.2020461-4-jingzhangos@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230503171618.2020461-4-jingzhangos@google.com>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jing,

kernel test robot noticed the following build errors:

[auto build test ERROR on 6a8f57ae2eb07ab39a6f0ccad60c760743051026]

url:    https://github.com/intel-lab-lkp/linux/commits/Jing-Zhang/KVM-arm64-Move-CPU-ID-feature-registers-emulation-into-a-separate-file/20230504-011759
base:   6a8f57ae2eb07ab39a6f0ccad60c760743051026
patch link:    https://lore.kernel.org/r/20230503171618.2020461-4-jingzhangos%40google.com
patch subject: [PATCH v8 3/6] KVM: arm64: Use per guest ID register for ID_AA64PFR0_EL1.[CSV2|CSV3]
config: arm64-allyesconfig (https://download.01.org/0day-ci/archive/20230504/202305040748.hUxGyrJF-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/5c887874c5459c9690cf3eac8b68022d72789533
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Jing-Zhang/KVM-arm64-Move-CPU-ID-feature-registers-emulation-into-a-separate-file/20230504-011759
        git checkout 5c887874c5459c9690cf3eac8b68022d72789533
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=arm64 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=arm64 SHELL=/bin/bash arch/arm64/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202305040748.hUxGyrJF-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from include/linux/rhashtable-types.h:14,
                    from include/linux/ipc.h:7,
                    from include/uapi/linux/sem.h:5,
                    from include/linux/sem.h:5,
                    from include/linux/sched.h:15,
                    from include/linux/hardirq.h:9,
                    from include/linux/kvm_host.h:7,
                    from arch/arm64/kvm/id_regs.c:13:
   arch/arm64/kvm/id_regs.c: In function 'get_id_reg':
>> arch/arm64/kvm/id_regs.c:152:25: error: 'struct kvm_arch' has no member named 'config_lock'
     152 |         mutex_lock(&arch->config_lock);
         |                         ^~
   include/linux/mutex.h:187:44: note: in definition of macro 'mutex_lock'
     187 | #define mutex_lock(lock) mutex_lock_nested(lock, 0)
         |                                            ^~~~
   arch/arm64/kvm/id_regs.c:154:27: error: 'struct kvm_arch' has no member named 'config_lock'
     154 |         mutex_unlock(&arch->config_lock);
         |                           ^~
   arch/arm64/kvm/id_regs.c: In function 'set_id_aa64pfr0_el1':
   arch/arm64/kvm/id_regs.c:221:25: error: 'struct kvm_arch' has no member named 'config_lock'
     221 |         mutex_lock(&arch->config_lock);
         |                         ^~
   include/linux/mutex.h:187:44: note: in definition of macro 'mutex_lock'
     187 | #define mutex_lock(lock) mutex_lock_nested(lock, 0)
         |                                            ^~~~
   arch/arm64/kvm/id_regs.c:239:27: error: 'struct kvm_arch' has no member named 'config_lock'
     239 |         mutex_unlock(&arch->config_lock);
         |                           ^~


vim +152 arch/arm64/kvm/id_regs.c

   139	
   140	/*
   141	 * cpufeature ID register user accessors
   142	 *
   143	 * For now, these registers are immutable for userspace, so no values
   144	 * are stored, and for set_id_reg() we don't allow the effective value
   145	 * to be changed.
   146	 */
   147	static int get_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
   148			      u64 *val)
   149	{
   150		struct kvm_arch *arch = &vcpu->kvm->arch;
   151	
 > 152		mutex_lock(&arch->config_lock);
   153		*val = read_id_reg(vcpu, rd);
   154		mutex_unlock(&arch->config_lock);
   155	
   156		return 0;
   157	}
   158	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
