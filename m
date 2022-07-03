Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2D5C5649B6
	for <lists+kvm@lfdr.de>; Sun,  3 Jul 2022 22:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232425AbiGCUfU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 3 Jul 2022 16:35:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbiGCUfS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 3 Jul 2022 16:35:18 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FF3B2649
        for <kvm@vger.kernel.org>; Sun,  3 Jul 2022 13:35:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656880518; x=1688416518;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=QvXLDpv34oPQy6RqkXgiyjKnL/zLtxHb/+WKFc5VtLw=;
  b=TvFt2lDiPzjFeN1yG1H80z9YQL2aGHM0i958RLbOG8S3jQU5pn4yx7DR
   ejqQjEDJyNnyBIo34C3PeI/2k6UgXi3QyFo7gCb+O/9/QEX/PFREoyKfW
   UiOcJlvObvL6eU970qUT641n1oXUvDj9NlxoEJS0LOkeUjhD/e+fELjiq
   /MntffMeJD2ALdOF9HNpKeE2pkwwPW0yDHrg5D2gm3Mx5KqAJTRoQUWbq
   9a1/k2BRqpBoJ12y2fJXOzSkUhHEQMSUHbr1Z9s1EeFrjjtI5YkeAFZep
   0reK/V6HwRNKYWyjGuettudjZ4Yd2P++KO905ds59lcTRkGGEb4B6b+F1
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10397"; a="284090032"
X-IronPort-AV: E=Sophos;i="5.92,241,1650956400"; 
   d="scan'208";a="284090032"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2022 13:35:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,241,1650956400"; 
   d="scan'208";a="542346866"
Received: from lkp-server01.sh.intel.com (HELO 68b931ab7ac1) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 03 Jul 2022 13:35:16 -0700
Received: from kbuild by 68b931ab7ac1 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1o86JH-000GwF-GQ;
        Sun, 03 Jul 2022 20:35:15 +0000
Date:   Mon, 4 Jul 2022 04:34:58 +0800
From:   kernel test robot <lkp@intel.com>
To:     Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org
Cc:     kbuild-all@lists.01.org, pbonzini@redhat.com, jmattson@google.com,
        seanjc@google.com, Aaron Lewis <aaronlewis@google.com>
Subject: Re: [PATCH 3/3] KVM: x86: Don't deflect MSRs to userspace that can't
 be filtered
Message-ID: <202207040455.aag6l8Io-lkp@intel.com>
References: <20220703191636.2159067-4-aaronlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220703191636.2159067-4-aaronlewis@google.com>
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Aaron,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on kvm/queue]
[also build test WARNING on next-20220701]
[cannot apply to mst-vhost/linux-next linus/master v5.19-rc4]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Aaron-Lewis/MSR-Filtering-updates/20220704-031727
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
config: i386-allyesconfig (https://download.01.org/0day-ci/archive/20220704/202207040455.aag6l8Io-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-3) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/0c12a0d47fb511592df45bf2030cc200b5bab5ef
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Aaron-Lewis/MSR-Filtering-updates/20220704-031727
        git checkout 0c12a0d47fb511592df45bf2030cc200b5bab5ef
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash arch/x86/kvm/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> arch/x86/kvm/x86.c:1715:6: warning: no previous prototype for 'kvm_msr_filtering_disallowed' [-Wmissing-prototypes]
    1715 | bool kvm_msr_filtering_disallowed(u32 index)
         |      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~


vim +/kvm_msr_filtering_disallowed +1715 arch/x86/kvm/x86.c

  1714	
> 1715	bool kvm_msr_filtering_disallowed(u32 index)
  1716	{
  1717		/* x2APIC MSRs do not support filtering. */
  1718		if (index >= 0x800 && index <= 0x8ff)
  1719			return true;
  1720	
  1721		return false;
  1722	}
  1723	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
