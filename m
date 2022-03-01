Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7504C8042
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 02:16:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231965AbiCABRZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Feb 2022 20:17:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231853AbiCABRX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Feb 2022 20:17:23 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD4E0102
        for <kvm@vger.kernel.org>; Mon, 28 Feb 2022 17:16:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646097403; x=1677633403;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=K/alCFk4en1g0lgM6VD+vI0LcQxhJdJodviuusV7svw=;
  b=SpKoG2TRt4vM0yGZJFRfgvTcrqony62g2JPVFInqm+uWo0WaMbPLdyXS
   5so8nVA6Afhf6BkIPCTAuOVM92GQF8eL4E6BTaBwDjc2luxO2MjJVUMTb
   5Q17EjJlOALg+O0yn+dHA0Zu1vd0I2vaFx6dzP9HXy4bV9+NcfS7lmILL
   6gSZ6p2foVHJTozj2KhesCPQ5TSCPDYHs7nbJIxOFduKfM5tR3SMYrld9
   5OcFVNggr6kqsm6pJIQ4A8ZMgPmR4l53O514xsQ+71c6bUqHRExmqmkcB
   qe0C1C0USConw+5r+hFwVFVGDq+xmiOt4uxf2BPjSjGbWVwVdu7bxMuIN
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10272"; a="253220060"
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="253220060"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 17:16:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="575528526"
Received: from lkp-server01.sh.intel.com (HELO 788b1cd46f0d) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 28 Feb 2022 17:16:39 -0800
Received: from kbuild by 788b1cd46f0d with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nOr83-0007y6-AJ; Tue, 01 Mar 2022 01:16:39 +0000
Date:   Tue, 1 Mar 2022 09:15:45 +0800
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
Message-ID: <202203010934.3Jekh58R-lkp@intel.com>
References: <20220228200552.150406-13-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220228200552.150406-13-dwmw2@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
config: x86_64-randconfig-a015 (https://download.01.org/0day-ci/archive/20220301/202203010934.3Jekh58R-lkp@intel.com/config)
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
reproduce (this is a W=1 build):
        # https://github.com/0day-ci/linux/commit/9e28d0cae6d7075379c9afdd36f014227c6a7553
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review David-Woodhouse/KVM-Add-Xen-event-channel-acceleration/20220301-040936
        git checkout 9e28d0cae6d7075379c9afdd36f014227c6a7553
        # save the config file to linux build tree
        mkdir build_dir
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash arch/x86/kvm/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> arch/x86/kvm/xen.c:183:6: warning: no previous prototype for 'kvm_xen_init_timer' [-Wmissing-prototypes]
     183 | void kvm_xen_init_timer(struct kvm_vcpu *vcpu)
         |      ^~~~~~~~~~~~~~~~~~


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
