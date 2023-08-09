Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E1097751BA
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 05:57:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbjHID5a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Aug 2023 23:57:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjHID52 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Aug 2023 23:57:28 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41BA510DC;
        Tue,  8 Aug 2023 20:57:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691553448; x=1723089448;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=zv0+2rI5B5teEQrq2dbURi5j/GcMeTdxtcdPjk3899g=;
  b=lR1CvOq5VGwFZlMbLNbjLCnGyqmTo2OZ5Bbxe1OWozW/z0Pj5uhm/q7R
   /voIIf7EdqrNkWgNtvVKNXu1BdQWM+QksIKUZzmse4RfP4LB1e598KR54
   kx/wSKXMqdIGpqb8szgHFo3qdilyiS+dPaPWfjIfa35NFvb0v70D1fUvy
   bb0g/BRhju4DDS+mAgF18/10tM+NnxrmljdAa2pqrZKhiIKVT1+JAk4vZ
   mug2zdyixqI43cpUXLAvl9R8KWQzNYG8LNO5NxpAmp0gPy+s+4q98XTKR
   5brZRqtuwHJhokjIMbmzTUi7XcsXIFk050uQ/QoxINYzcZw9z0GC9Mjb1
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="351322619"
X-IronPort-AV: E=Sophos;i="6.01,158,1684825200"; 
   d="scan'208";a="351322619"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2023 20:57:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="708541838"
X-IronPort-AV: E=Sophos;i="6.01,158,1684825200"; 
   d="scan'208";a="708541838"
Received: from lkp-server01.sh.intel.com (HELO d1ccc7e87e8f) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 08 Aug 2023 20:57:22 -0700
Received: from kbuild by d1ccc7e87e8f with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qTaK0-0005nO-2y;
        Wed, 09 Aug 2023 03:57:20 +0000
Date:   Wed, 9 Aug 2023 11:57:04 +0800
From:   kernel test robot <lkp@intel.com>
To:     Huang Shijie <shijie@os.amperecomputing.com>, maz@kernel.org
Cc:     oe-kbuild-all@lists.linux.dev, oliver.upton@linux.dev,
        james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
        catalin.marinas@arm.com, will@kernel.org, pbonzini@redhat.com,
        ingo@redhat.com, acme@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@kernel.org,
        namhyung@kernel.org, irogers@google.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-perf-users@vger.kernel.org, patches@amperecomputing.com,
        zwang@amperecomputing.com,
        Huang Shijie <shijie@os.amperecomputing.com>
Subject: Re: [PATCH] perf/core: fix the bug in the event multiplexing
Message-ID: <202308091142.nsjuu1ek-lkp@intel.com>
References: <20230809013953.7692-1-shijie@os.amperecomputing.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230809013953.7692-1-shijie@os.amperecomputing.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Huang,

kernel test robot noticed the following build warnings:

[auto build test WARNING on kvm/queue]
[also build test WARNING on kvmarm/next tip/perf/core linus/master v6.5-rc5 next-20230808]
[cannot apply to acme/perf/core kvm/linux-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Huang-Shijie/perf-core-fix-the-bug-in-the-event-multiplexing/20230809-094637
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
patch link:    https://lore.kernel.org/r/20230809013953.7692-1-shijie%40os.amperecomputing.com
patch subject: [PATCH] perf/core: fix the bug in the event multiplexing
config: loongarch-allyesconfig (https://download.01.org/0day-ci/archive/20230809/202308091142.nsjuu1ek-lkp@intel.com/config)
compiler: loongarch64-linux-gcc (GCC) 12.3.0
reproduce: (https://download.01.org/0day-ci/archive/20230809/202308091142.nsjuu1ek-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202308091142.nsjuu1ek-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> kernel/events/core.c:4232:13: warning: no previous prototype for 'arch_perf_rotate_pmu_set' [-Wmissing-prototypes]
    4232 | void __weak arch_perf_rotate_pmu_set(void)
         |             ^~~~~~~~~~~~~~~~~~~~~~~~


vim +/arch_perf_rotate_pmu_set +4232 kernel/events/core.c

  4231	
> 4232	void __weak arch_perf_rotate_pmu_set(void)
  4233	{
  4234	}
  4235	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
