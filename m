Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B25A47D779D
	for <lists+kvm@lfdr.de>; Thu, 26 Oct 2023 00:08:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbjJYWIv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 18:08:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjJYWIu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 18:08:50 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CA50137;
        Wed, 25 Oct 2023 15:08:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698271728; x=1729807728;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=DWvlz5HH3IT7+JIB5yYoTEyrNXh/OYjDwgjcnyHWpak=;
  b=mYK7380dPTkRJGodNDTDoIrRKIJJyzjYHYgjT5GI9kLeuD6BAvjjU0fA
   6O4qJDhvMTAxkMbcX8ZbTNw56+f20Z3WUavl/parv0BNsp0xbyOP82KXJ
   hNx53WsqJUfpnEFIM7+NCaw88xLPPqzkDcFIM8/lsfXgaoV8Ms807d197
   JxiQi9YePxT1LB92uWN+BpGV2C8RlREoDQ0nmer8h54IUbQ3BzssRQfw+
   g7N2kXSTv5ifel88ZUVLqpw6UNUJ06Ef56Zdoe2RZZ+3GlPcQAhlUoA0p
   /ZgdiDuDXUdQse7i0hF3g7T59ZXaMyL0/tqyODzlGjRl5lBR6r6WkAMqi
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10874"; a="191204"
X-IronPort-AV: E=Sophos;i="6.03,252,1694761200"; 
   d="scan'208";a="191204"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2023 15:08:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10874"; a="875670600"
X-IronPort-AV: E=Sophos;i="6.03,252,1694761200"; 
   d="scan'208";a="875670600"
Received: from lkp-server01.sh.intel.com (HELO 8917679a5d3e) ([10.239.97.150])
  by fmsmga002.fm.intel.com with ESMTP; 25 Oct 2023 15:08:42 -0700
Received: from kbuild by 8917679a5d3e with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qvm3M-0009EQ-1W;
        Wed, 25 Oct 2023 22:08:40 +0000
Date:   Thu, 26 Oct 2023 06:08:01 +0800
From:   kernel test robot <lkp@intel.com>
To:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, tony.luck@intel.com,
        ak@linux.intel.com, tim.c.chen@linux.intel.com
Cc:     oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org,
        Alyssa Milburn <alyssa.milburn@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        antonio.gomez.iglesias@linux.intel.com,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Subject: Re: [PATCH  v2 4/6] x86/bugs: Use ALTERNATIVE() instead of
 mds_user_clear static key
Message-ID: <202310260517.TrEGc1ZW-lkp@intel.com>
References: <20231024-delay-verw-v2-4-f1881340c807@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231024-delay-verw-v2-4-f1881340c807@linux.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Pawan,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 05d3ef8bba77c1b5f98d941d8b2d4aeab8118ef1]

url:    https://github.com/intel-lab-lkp/linux/commits/Pawan-Gupta/x86-bugs-Add-asm-helpers-for-executing-VERW/20231024-161029
base:   05d3ef8bba77c1b5f98d941d8b2d4aeab8118ef1
patch link:    https://lore.kernel.org/r/20231024-delay-verw-v2-4-f1881340c807%40linux.intel.com
patch subject: [PATCH  v2 4/6] x86/bugs: Use ALTERNATIVE() instead of mds_user_clear static key
reproduce: (https://download.01.org/0day-ci/archive/20231026/202310260517.TrEGc1ZW-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202310260517.TrEGc1ZW-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> Documentation/arch/x86/mds.rst:153: WARNING: Unexpected section title.

vim +153 Documentation/arch/x86/mds.rst

   141	
   142	   When transitioning from kernel to user space the CPU buffers are flushed
   143	   on affected CPUs when the mitigation is not disabled on the kernel
   144	   command line. The mitigation is enabled through the feature flag
   145	   X86_FEATURE_CLEAR_CPU_BUF.
   146	
   147	   The mitigation is invoked just before transitioning to userspace after
   148	   user registers are restored. This is done to minimize the window in
   149	   which kernel data could be accessed after VERW e.g. via an NMI after
   150	   VERW.
   151	
   152	   Corner case not handled
 > 153	   ^^^^^^^^^^^^^^^^^^^^^^^
   154	   Interrupts returning to kernel don't clear CPUs buffers since the
   155	   exit-to-user path is expected to do that anyways. But, there could be
   156	   a case when an NMI is generated in kernel after the exit-to-user path
   157	   has cleared the buffers. This case is not handled and NMI returning to
   158	   kernel don't clear CPU buffers because:
   159	
   160	   1. It is rare to get an NMI after VERW, but before returning to userspace.
   161	   2. For an unprivileged user, there is no known way to make that NMI
   162	      less rare or target it.
   163	   3. It would take a large number of these precisely-timed NMIs to mount
   164	      an actual attack.  There's presumably not enough bandwidth.
   165	   4. The NMI in question occurs after a VERW, i.e. when user state is
   166	      restored and most interesting data is already scrubbed. Whats left
   167	      is only the data that NMI touches, and that may or may not be of
   168	      any interest.
   169	
   170	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
