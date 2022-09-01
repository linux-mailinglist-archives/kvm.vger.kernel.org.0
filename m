Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E56C5A9E89
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 20:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234005AbiIAR7i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 13:59:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233908AbiIAR7e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 13:59:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69569786FD
        for <kvm@vger.kernel.org>; Thu,  1 Sep 2022 10:59:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D0AF9B8259D
        for <kvm@vger.kernel.org>; Thu,  1 Sep 2022 17:59:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ED34C433C1;
        Thu,  1 Sep 2022 17:59:27 +0000 (UTC)
Date:   Thu, 1 Sep 2022 18:59:23 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     kernel test robot <lkp@intel.com>
Cc:     Peter Collingbourne <pcc@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kbuild-all@lists.01.org, Cornelia Huck <cohuck@redhat.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Evgenii Stepanov <eugenis@google.com>, kvm@vger.kernel.org,
        Steven Price <steven.price@arm.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>
Subject: Re: [PATCH v3 3/7] mm: Add PG_arch_3 page flag
Message-ID: <YxDy+zFasbAP7Yrq@arm.com>
References: <20220810193033.1090251-4-pcc@google.com>
 <202208111500.62e0Bl2l-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202208111500.62e0Bl2l-lkp@intel.com>
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 11, 2022 at 03:16:08PM +0800, kernel test robot wrote:
> Thank you for the patch! Perhaps something to improve:
> 
> [auto build test WARNING on arm64/for-next/core]
> [also build test WARNING on linus/master next-20220811]
> [cannot apply to kvmarm/next arm/for-next soc/for-next xilinx-xlnx/master v5.19]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Peter-Collingbourne/KVM-arm64-permit-MAP_SHARED-mappings-with-MTE-enabled/20220811-033310
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-next/core
> config: loongarch-defconfig (https://download.01.org/0day-ci/archive/20220811/202208111500.62e0Bl2l-lkp@intel.com/config)
> compiler: loongarch64-linux-gcc (GCC) 12.1.0
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://github.com/intel-lab-lkp/linux/commit/1a400517d8428df0ec9f86f8d303b2227ee9702f
>         git remote add linux-review https://github.com/intel-lab-lkp/linux
>         git fetch --no-tags linux-review Peter-Collingbourne/KVM-arm64-permit-MAP_SHARED-mappings-with-MTE-enabled/20220811-033310
>         git checkout 1a400517d8428df0ec9f86f8d303b2227ee9702f
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=loongarch SHELL=/bin/bash
> 
> If you fix the issue, kindly add following tag where applicable
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All warnings (new ones prefixed by >>):
> 
> >> mm/memory.c:92:2: warning: #warning Unfortunate NUMA and NUMA Balancing config, growing page-frame for last_cpupid. [-Wcpp]
>       92 | #warning Unfortunate NUMA and NUMA Balancing config, growing page-frame for last_cpupid.
>          |  ^~~~~~~
> 
> 
> vim +92 mm/memory.c
> 
> 42b7772812d15b Jan Beulich    2008-07-23  90  
> af27d9403f5b80 Arnd Bergmann  2018-02-16  91  #if defined(LAST_CPUPID_NOT_IN_PAGE_FLAGS) && !defined(CONFIG_COMPILE_TEST)
> 90572890d20252 Peter Zijlstra 2013-10-07 @92  #warning Unfortunate NUMA and NUMA Balancing config, growing page-frame for last_cpupid.
> 75980e97daccfc Peter Zijlstra 2013-02-22  93  #endif
> 75980e97daccfc Peter Zijlstra 2013-02-22  94  

It looks like ith CONFIG_NUMA_BALANCING=y on loongarch we run out of
spare bits in page->flags to fit last_cpupid. The reason we don't see it
on arm64 is that we select SPARSEMEM_VMEMMAP and SECTIONS_WIDTH becomes
0. On loongarch SECTIONS_WIDTH takes 19 bits (48 - 29) in page->flags.

I think instead of always defining PG_arch_{2,3} if CONFIG_64BIT, we
could add a CONFIG_ARCH_WANTS_PG_ARCH_23 option and only select it on
arm64 for the time being.

-- 
Catalin
