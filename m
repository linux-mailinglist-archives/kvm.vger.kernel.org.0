Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE0F550C22B
	for <lists+kvm@lfdr.de>; Sat, 23 Apr 2022 00:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231787AbiDVWK3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 18:10:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231657AbiDVWIy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 18:08:54 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB8DB1FB896;
        Fri, 22 Apr 2022 13:56:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650660980; x=1682196980;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=khxBa9ANLkANHc/Zo28EzKs8RaABxYVq6PMhf/+H9ok=;
  b=BL8kJj1ccBFecM9fTJ+DU79Mzha5qMOf1qrhMFICsOLTpz6vacQVN/HS
   VQsvtjzABCRt7kf8cx9ICK/lSbT+SqVbvq9ayayG2RTp4VD3e0Q0gNgZb
   UvyIF+M6beG/WWR8Wz9DDEDoIxFJQrVVyUHdLZwKKCpk27CmRRESjP+gM
   X9erwN/0OWJQ8lqwpl/j2KtW0B5TuaxmeAbNpCKmtPTKaxu2TLCjRyOVW
   103/XCerF17/5+sVJyMbX7ihFNUiMBu0Ykmquzc/SyjyoAkZyrxP0FioO
   on0JZWPLytjUAOnIeFnly7u/FdJUVdRcKy7KlkAG+vFkgdx96Yt2v8dYi
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10324"; a="252102512"
X-IronPort-AV: E=Sophos;i="5.90,282,1643702400"; 
   d="scan'208";a="252102512"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2022 12:58:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,282,1643702400"; 
   d="scan'208";a="511718007"
Received: from lkp-server01.sh.intel.com (HELO 3abc53900bec) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 22 Apr 2022 12:58:11 -0700
Received: from kbuild by 3abc53900bec with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nhzPu-000AXl-M5;
        Fri, 22 Apr 2022 19:58:10 +0000
Date:   Sat, 23 Apr 2022 03:57:29 +0800
From:   kernel test robot <lkp@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Peter Gonda <pgonda@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH for-5.18] KVM: fix bad user ABI for KVM_EXIT_SYSTEM_EVENT
Message-ID: <202204230312.8EOM8DHM-lkp@intel.com>
References: <20220422103013.34832-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220422103013.34832-1-pbonzini@redhat.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

I love your patch! Yet something to improve:

[auto build test ERROR on kvm/master]
[also build test ERROR on linus/master v5.18-rc3]
[cannot apply to kvmarm/next mst-vhost/linux-next linux/master next-20220422]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Paolo-Bonzini/KVM-fix-bad-user-ABI-for-KVM_EXIT_SYSTEM_EVENT/20220422-184535
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git master
config: riscv-randconfig-r014-20220422 (https://download.01.org/0day-ci/archive/20220423/202204230312.8EOM8DHM-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 5bd87350a5ae429baf8f373cb226a57b62f87280)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install riscv cross compiling tool for clang build
        # apt-get install binutils-riscv64-linux-gnu
        # https://github.com/intel-lab-lkp/linux/commit/71af2c55b700878ad9d73c90c6b75f327f36d0a9
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Paolo-Bonzini/KVM-fix-bad-user-ABI-for-KVM_EXIT_SYSTEM_EVENT/20220422-184535
        git checkout 71af2c55b700878ad9d73c90c6b75f327f36d0a9
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=riscv SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> arch/riscv/kvm/vcpu_sbi.c:98:30: error: use of undeclared identifier 'reason'
           run->system_event.data[0] = reason;
                                       ^
   1 error generated.


vim +/reason +98 arch/riscv/kvm/vcpu_sbi.c

    83	
    84	void kvm_riscv_vcpu_sbi_system_reset(struct kvm_vcpu *vcpu,
    85					     struct kvm_run *run,
    86					     u32 type, u64 flags)
    87	{
    88		unsigned long i;
    89		struct kvm_vcpu *tmp;
    90	
    91		kvm_for_each_vcpu(i, tmp, vcpu->kvm)
    92			tmp->arch.power_off = true;
    93		kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_SLEEP);
    94	
    95		memset(&run->system_event, 0, sizeof(run->system_event));
    96		run->system_event.type = type;
    97		run->system_event.ndata = 1;
  > 98		run->system_event.data[0] = reason;
    99		run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
   100	}
   101	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
