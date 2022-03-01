Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E5C24C8064
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 02:36:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbiCABhZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Feb 2022 20:37:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbiCABhY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Feb 2022 20:37:24 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71B193D4A1
        for <kvm@vger.kernel.org>; Mon, 28 Feb 2022 17:36:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646098604; x=1677634604;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=IejONB9Ar6hv7gIVr7qWjaHMF9E8l+CgMnmkrj5P9K8=;
  b=SMKc2iH93d9y3Ih5cucNxyWk6u9Wb7KHvtKGSM9rUp0UH/tnhaBe5UIW
   XPFz+O4cWIyfjcenLa/hIwaaIMXVEWY090cAM9HgB4mhTGSSZGO2XmXe6
   vELziZ9wSSHvEGIz0v2wpKSvXT/ySj5q1PaLTOvxcZILI2yWLJwy7HSGy
   99SKo3E7CgEfkrPbJf2jmZAuzf/RX2KrwoB07JwloGBvTPlJ0m+C63v2D
   DnRH54VpUBOLXf/BGE0JNwQ0mi/RafhDnDbCgzJ4sN7RJQoboH596raki
   J96ZVY/55qc1giT8F5OcT477Gne/x07b1ColBhjaeDIMkqV6N/W+TQl/r
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10272"; a="240442503"
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="240442503"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 17:36:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="708872469"
Received: from lkp-server01.sh.intel.com (HELO 788b1cd46f0d) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 28 Feb 2022 17:36:40 -0800
Received: from kbuild by 788b1cd46f0d with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nOrRP-0007za-NW; Tue, 01 Mar 2022 01:36:39 +0000
Date:   Tue, 1 Mar 2022 09:36:25 +0800
From:   kernel test robot <lkp@intel.com>
To:     David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kbuild-all@lists.01.org, Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Metin Kaya <metikaya@amazon.co.uk>,
        Paul Durrant <pdurrant@amazon.co.uk>
Subject: Re: [PATCH v2 12/17] KVM: x86/xen: handle PV timers oneshot mode
Message-ID: <202203010947.CeWMN6HC-lkp@intel.com>
References: <20220228200552.150406-13-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220228200552.150406-13-dwmw2@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi David,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on kvm/master]
[also build test WARNING on v5.17-rc6 next-20220228]
[cannot apply to mst-vhost/linux-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/David-Woodhouse/KVM-Add-Xen-event-channel-acceleration/20220301-040936
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git master
config: i386-allyesconfig (https://download.01.org/0day-ci/archive/20220301/202203010947.CeWMN6HC-lkp@intel.com/config)
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
reproduce (this is a W=1 build):
        # https://github.com/0day-ci/linux/commit/9e28d0cae6d7075379c9afdd36f014227c6a7553
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review David-Woodhouse/KVM-Add-Xen-event-channel-acceleration/20220301-040936
        git checkout 9e28d0cae6d7075379c9afdd36f014227c6a7553
        # save the config file to linux build tree
        mkdir build_dir
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash arch/x86/kvm/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> arch/x86/kvm/xen.c:183:6: warning: no previous prototype for 'kvm_xen_init_timer' [-Wmissing-prototypes]
     183 | void kvm_xen_init_timer(struct kvm_vcpu *vcpu)
         |      ^~~~~~~~~~~~~~~~~~
   In file included from include/asm-generic/bug.h:5,
                    from arch/x86/include/asm/bug.h:84,
                    from include/linux/bug.h:5,
                    from include/linux/mmdebug.h:5,
                    from include/linux/percpu.h:5,
                    from include/linux/context_tracking_state.h:5,
                    from include/linux/hardirq.h:5,
                    from include/linux/kvm_host.h:7,
                    from arch/x86/kvm/x86.h:5,
                    from arch/x86/kvm/xen.c:9:
   arch/x86/kvm/xen.c: In function 'kvm_xen_hcall_set_timer_op':
>> arch/x86/kvm/xen.c:1030:41: warning: right shift count >= width of type [-Wshift-count-overflow]
    1030 |         (delta > 0 && (uint32_t) (delta >> 50) != 0))) {
         |                                         ^~
   include/linux/compiler.h:78:42: note: in definition of macro 'unlikely'
      78 | # define unlikely(x) __builtin_expect(!!(x), 0)
         |                                          ^


vim +/kvm_xen_init_timer +183 arch/x86/kvm/xen.c

   182	
 > 183	void kvm_xen_init_timer(struct kvm_vcpu *vcpu)
   184	{
   185		hrtimer_init(&vcpu->arch.xen.timer, CLOCK_MONOTONIC,
   186			     HRTIMER_MODE_ABS_PINNED);
   187		vcpu->arch.xen.timer.function = xen_timer_callback;
   188	}
   189	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
