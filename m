Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52BB056ABEB
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 21:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236055AbiGGTiJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 15:38:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231875AbiGGTiE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 15:38:04 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6009C2A70A;
        Thu,  7 Jul 2022 12:38:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657222683; x=1688758683;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=aHrPmGRc5fy9j72/df86+pvlt4cuHptP8n9fnKrcDVY=;
  b=I9Jx71FUfZp7ZPZVy8e4HOgkh1QYJv6IHdiILs42ip2nj2qRbtXIFdeu
   iIA1iFynKXJ4+3cFdoPC7k9/U+UOQ2zpW0TYSn29gT6gcYJsPGgcbyVcL
   fXnx7BP74IoZaI60psnQl9f9Q9wtBWRiN2IXShTPV0CqhljI0Nbg6fFUi
   t0FHN6fngR7eJebboqfrVoyEu9n3oM26tdGKSb0Q+IdUlB9IORKZ/xxix
   Km+iZPiGIOIHkeL92Hk7dvC3Pghhzov8w/TTRH8CgxPQW3s7qPHd8Vv/5
   2GLSRJyN/DHOUOpwjJTioZhjlTodrSaUSaMAUt38ZOnwsA/mwLLse4oWO
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10401"; a="263889050"
X-IronPort-AV: E=Sophos;i="5.92,253,1650956400"; 
   d="scan'208";a="263889050"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2022 12:38:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,253,1650956400"; 
   d="scan'208";a="593857176"
Received: from lkp-server01.sh.intel.com (HELO 68b931ab7ac1) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 07 Jul 2022 12:37:59 -0700
Received: from kbuild by 68b931ab7ac1 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1o9XK3-000MNO-1h;
        Thu, 07 Jul 2022 19:37:59 +0000
Date:   Fri, 8 Jul 2022 03:37:32 +0800
From:   kernel test robot <lkp@intel.com>
To:     Dan Carpenter <error27@gmail.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc:     kbuild-all@lists.01.org, Yishai Hadas <yishaih@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Leon Romanovsky <leon@kernel.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] vfio/mlx5: clean up overflow check
Message-ID: <202207080331.FTVSHxW8-lkp@intel.com>
References: <YsbzgQQ4bg6v+iTS@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YsbzgQQ4bg6v+iTS@kili>
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Dan,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on awilliam-vfio/next]
[also build test WARNING on rdma/for-next linus/master v5.19-rc5 next-20220707]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Dan-Carpenter/vfio-mlx5-clean-up-overflow-check/20220707-225657
base:   https://github.com/awilliam/linux-vfio.git next
config: i386-allyesconfig (https://download.01.org/0day-ci/archive/20220708/202207080331.FTVSHxW8-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-3) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/44607f8f3817e1af6622db7d70ad5bc457b8f203
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Dan-Carpenter/vfio-mlx5-clean-up-overflow-check/20220707-225657
        git checkout 44607f8f3817e1af6622db7d70ad5bc457b8f203
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash drivers/vfio/pci/mlx5/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   In file included from include/linux/device.h:29,
                    from drivers/vfio/pci/mlx5/main.c:6:
   drivers/vfio/pci/mlx5/main.c: In function 'mlx5vf_resume_write':
>> include/linux/overflow.h:67:22: warning: comparison of distinct pointer types lacks a cast
      67 |         (void) (&__a == &__b);                  \
         |                      ^~
   drivers/vfio/pci/mlx5/main.c:282:13: note: in expansion of macro 'check_add_overflow'
     282 |             check_add_overflow(len, (unsigned long)*pos, &requested_length))
         |             ^~~~~~~~~~~~~~~~~~
   include/linux/overflow.h:68:22: warning: comparison of distinct pointer types lacks a cast
      68 |         (void) (&__a == __d);                   \
         |                      ^~
   drivers/vfio/pci/mlx5/main.c:282:13: note: in expansion of macro 'check_add_overflow'
     282 |             check_add_overflow(len, (unsigned long)*pos, &requested_length))
         |             ^~~~~~~~~~~~~~~~~~


vim +67 include/linux/overflow.h

9b80e4c4ddaca35 Kees Cook        2020-08-12  54  
f0907827a8a9152 Rasmus Villemoes 2018-05-08  55  /*
f0907827a8a9152 Rasmus Villemoes 2018-05-08  56   * For simplicity and code hygiene, the fallback code below insists on
f0907827a8a9152 Rasmus Villemoes 2018-05-08  57   * a, b and *d having the same type (similar to the min() and max()
f0907827a8a9152 Rasmus Villemoes 2018-05-08  58   * macros), whereas gcc's type-generic overflow checkers accept
f0907827a8a9152 Rasmus Villemoes 2018-05-08  59   * different types. Hence we don't just make check_add_overflow an
f0907827a8a9152 Rasmus Villemoes 2018-05-08  60   * alias for __builtin_add_overflow, but add type checks similar to
f0907827a8a9152 Rasmus Villemoes 2018-05-08  61   * below.
f0907827a8a9152 Rasmus Villemoes 2018-05-08  62   */
9b80e4c4ddaca35 Kees Cook        2020-08-12  63  #define check_add_overflow(a, b, d) __must_check_overflow(({	\
f0907827a8a9152 Rasmus Villemoes 2018-05-08  64  	typeof(a) __a = (a);			\
f0907827a8a9152 Rasmus Villemoes 2018-05-08  65  	typeof(b) __b = (b);			\
f0907827a8a9152 Rasmus Villemoes 2018-05-08  66  	typeof(d) __d = (d);			\
f0907827a8a9152 Rasmus Villemoes 2018-05-08 @67  	(void) (&__a == &__b);			\
f0907827a8a9152 Rasmus Villemoes 2018-05-08  68  	(void) (&__a == __d);			\
f0907827a8a9152 Rasmus Villemoes 2018-05-08  69  	__builtin_add_overflow(__a, __b, __d);	\
9b80e4c4ddaca35 Kees Cook        2020-08-12  70  }))
f0907827a8a9152 Rasmus Villemoes 2018-05-08  71  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
