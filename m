Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7474B52C91D
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 03:05:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232391AbiESBFT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 21:05:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230476AbiESBFS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 21:05:18 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36811CE16;
        Wed, 18 May 2022 18:05:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652922317; x=1684458317;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FON4eDfFwoyqPsYBMR3zCyP6L0REBuQlLSooLaoyyGc=;
  b=f2j+S3kIpG/i65ehqZXWOgRZ5ei2tkD8J8qAXC5vjhdIuKGNblOZFQNl
   zY5q5BUpNAjp4V6K7L7F9KHVqG26CiOLuDJeT2D+qj/kA/dyPudxsgFYn
   cCl3c0Whuf4ACHWNyw/HyzESWSzBJmqZyzN+C7Zw6R5UwXLUsf1s7Ue27
   khAUdgVaQLRl1TwjrQkwdnemNkU2PT7tY01lcnakE4aj3bfTe9PwN/D6Y
   JoTHF8kfeMT1QM2k8Dm7Yj60SQpqO7xwcukTXv9n7x5fby/zGEmG/7OKO
   L30kqjsZeDDw/AcqDKUT6VuKExegX3v8RIM7ckHP+W2YDQ+AqrlBMNcFI
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10351"; a="297264158"
X-IronPort-AV: E=Sophos;i="5.91,236,1647327600"; 
   d="scan'208";a="297264158"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2022 18:05:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,236,1647327600"; 
   d="scan'208";a="523804352"
Received: from lkp-server02.sh.intel.com (HELO 242b25809ac7) ([10.239.97.151])
  by orsmga003.jf.intel.com with ESMTP; 18 May 2022 18:05:15 -0700
Received: from kbuild by 242b25809ac7 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nrUbK-0002qT-A6;
        Thu, 19 May 2022 01:05:14 +0000
Date:   Thu, 19 May 2022 09:04:27 +0800
From:   kernel test robot <lkp@intel.com>
To:     Uros Bizjak <ubizjak@gmail.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Uros Bizjak <ubizjak@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH] KVM: VMX: Use try_cmpxchg64 in pi_try_set_control
Message-ID: <202205190852.VUijQkwc-lkp@intel.com>
References: <20220518134550.2358-1-ubizjak@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220518134550.2358-1-ubizjak@gmail.com>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
config: i386-debian-10.3-kselftests (https://download.01.org/0day-ci/archive/20220519/202205190852.VUijQkwc-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.2.0-20) 11.2.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/2af4f7c4ecfcaedf9b98ba30ee508dc0d9002955
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Uros-Bizjak/KVM-VMX-Use-try_cmpxchg64-in-pi_try_set_control/20220518-214709
        git checkout 2af4f7c4ecfcaedf9b98ba30ee508dc0d9002955
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash arch/x86/kvm/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   arch/x86/kvm/vmx/posted_intr.c: In function 'pi_try_set_control':
>> arch/x86/kvm/vmx/posted_intr.c:45:14: error: implicit declaration of function 'try_cmpxchg64'; did you mean 'try_cmpxchg'? [-Werror=implicit-function-declaration]
      45 |         if (!try_cmpxchg64(&pi_desc->control, pold, new))
         |              ^~~~~~~~~~~~~
         |              try_cmpxchg
   cc1: some warnings being treated as errors


vim +45 arch/x86/kvm/vmx/posted_intr.c

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
