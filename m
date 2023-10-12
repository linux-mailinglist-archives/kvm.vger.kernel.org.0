Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D6997C7803
	for <lists+kvm@lfdr.de>; Thu, 12 Oct 2023 22:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347402AbjJLUmc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Oct 2023 16:42:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343782AbjJLUmb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Oct 2023 16:42:31 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B5EAD7;
        Thu, 12 Oct 2023 13:42:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697143349; x=1728679349;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=grZVskJc6ajq0UaMPLY1+vxdNrKtPGrIR2HY2iTkC6c=;
  b=LhMEs1PpBrYA9bQkwuqrFDZrd4SocdTJoTV7BaFuUyYDQK2tcpCnS+mI
   JKIwntNCpJ8Kph0htB2ByC7QyS9h+z70drOjbgXdPyYFNIDtKHNzEdrjz
   NV+u21jzwaRLrM5M0CKW7l65/DZfD252ib2pbbEmkpDvRf3pePEBzspNC
   7LOee5erNYibB8XtO1iScuTW5TKuQCsR3sm3xgRggK3xaE97Lc6/fv5qL
   XS6tZnXfZPO14LX6Y5ps6o8IZ8xL5KpX6130pbHUgyiBhbgs1Pz9UgQJ2
   2Oh2g4qSxjDHZfz7YfwUVat8zEZnITrpRWclk9TVeitj/qS1soiJNLXmL
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10861"; a="375385887"
X-IronPort-AV: E=Sophos;i="6.03,219,1694761200"; 
   d="scan'208";a="375385887"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2023 13:42:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10861"; a="824755431"
X-IronPort-AV: E=Sophos;i="6.03,219,1694761200"; 
   d="scan'208";a="824755431"
Received: from lkp-server02.sh.intel.com (HELO f64821696465) ([10.239.97.151])
  by fmsmga004.fm.intel.com with ESMTP; 12 Oct 2023 13:42:05 -0700
Received: from kbuild by f64821696465 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qr2VP-0003rZ-2F;
        Thu, 12 Oct 2023 20:42:03 +0000
Date:   Fri, 13 Oct 2023 04:41:38 +0800
From:   kernel test robot <lkp@intel.com>
To:     Tianyi Liu <i.pear@outlook.com>, seanjc@google.com,
        pbonzini@redhat.com, peterz@infradead.org, mingo@redhat.com,
        acme@kernel.org
Cc:     oe-kbuild-all@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@kernel.org,
        namhyung@kernel.org, irogers@google.com, adrian.hunter@intel.com,
        Tianyi Liu <i.pear@outlook.com>
Subject: Re: [PATCH v2 4/5] perf kvm: Support sampling guest callchains
Message-ID: <202310130419.cIkNaYZm-lkp@intel.com>
References: <SY4P282MB108433024762F1F292D47C2A9DCFA@SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SY4P282MB108433024762F1F292D47C2A9DCFA@SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Tianyi,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 8a749fd1a8720d4619c91c8b6e7528c0a355c0aa]

url:    https://github.com/intel-lab-lkp/linux/commits/Tianyi-Liu/KVM-Add-arch-specific-interfaces-for-sampling-guest-callchains/20231008-230042
base:   8a749fd1a8720d4619c91c8b6e7528c0a355c0aa
patch link:    https://lore.kernel.org/r/SY4P282MB108433024762F1F292D47C2A9DCFA%40SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM
patch subject: [PATCH v2 4/5] perf kvm: Support sampling guest callchains
config: i386-randconfig-061-20231012 (https://download.01.org/0day-ci/archive/20231013/202310130419.cIkNaYZm-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231013/202310130419.cIkNaYZm-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202310130419.cIkNaYZm-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> arch/x86/events/core.c:2808:52: sparse: sparse: incorrect type in argument 1 (different modifiers) @@     expected void *addr @@     got struct stack_frame *const * @@
   arch/x86/events/core.c:2808:52: sparse:     expected void *addr
   arch/x86/events/core.c:2808:52: sparse:     got struct stack_frame *const *
>> arch/x86/events/core.c:2811:52: sparse: sparse: incorrect type in argument 1 (different modifiers) @@     expected void *addr @@     got unsigned long const * @@
   arch/x86/events/core.c:2811:52: sparse:     expected void *addr
   arch/x86/events/core.c:2811:52: sparse:     got unsigned long const *
>> arch/x86/events/core.c:2784:44: sparse: sparse: incorrect type in argument 1 (different modifiers) @@     expected void *addr @@     got unsigned int const * @@
   arch/x86/events/core.c:2784:44: sparse:     expected void *addr
   arch/x86/events/core.c:2784:44: sparse:     got unsigned int const *
   arch/x86/events/core.c:2787:44: sparse: sparse: incorrect type in argument 1 (different modifiers) @@     expected void *addr @@     got unsigned int const * @@
   arch/x86/events/core.c:2787:44: sparse:     expected void *addr
   arch/x86/events/core.c:2787:44: sparse:     got unsigned int const *

vim +2808 arch/x86/events/core.c

  2775	
  2776	static inline void
  2777	perf_callchain_guest32(struct perf_callchain_entry_ctx *entry)
  2778	{
  2779		struct stack_frame_ia32 frame;
  2780		const struct stack_frame_ia32 *fp;
  2781	
  2782		fp = (void *)perf_guest_get_frame_pointer();
  2783		while (fp && entry->nr < entry->max_stack) {
> 2784			if (!perf_guest_read_virt(&fp->next_frame, &frame.next_frame,
  2785				sizeof(frame.next_frame)))
  2786				break;
  2787			if (!perf_guest_read_virt(&fp->return_address, &frame.return_address,
  2788				sizeof(frame.return_address)))
  2789				break;
  2790			perf_callchain_store(entry, frame.return_address);
  2791			fp = (void *)frame.next_frame;
  2792		}
  2793	}
  2794	
  2795	void
  2796	perf_callchain_guest(struct perf_callchain_entry_ctx *entry)
  2797	{
  2798		struct stack_frame frame;
  2799		const struct stack_frame *fp;
  2800		unsigned int guest_state;
  2801	
  2802		guest_state = perf_guest_state();
  2803		perf_callchain_store(entry, perf_guest_get_ip());
  2804	
  2805		if (guest_state & PERF_GUEST_64BIT) {
  2806			fp = (void *)perf_guest_get_frame_pointer();
  2807			while (fp && entry->nr < entry->max_stack) {
> 2808				if (!perf_guest_read_virt(&fp->next_frame, &frame.next_frame,
  2809					sizeof(frame.next_frame)))
  2810					break;
> 2811				if (!perf_guest_read_virt(&fp->return_address, &frame.return_address,
  2812					sizeof(frame.return_address)))
  2813					break;
  2814				perf_callchain_store(entry, frame.return_address);
  2815				fp = (void *)frame.next_frame;
  2816			}
  2817		} else {
  2818			perf_callchain_guest32(entry);
  2819		}
  2820	}
  2821	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
