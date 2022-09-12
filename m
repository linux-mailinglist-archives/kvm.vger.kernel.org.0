Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 016C45B632F
	for <lists+kvm@lfdr.de>; Mon, 12 Sep 2022 23:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbiILV5h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Sep 2022 17:57:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230129AbiILV5g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Sep 2022 17:57:36 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 331434D147
        for <kvm@vger.kernel.org>; Mon, 12 Sep 2022 14:57:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663019855; x=1694555855;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ORWRhX+tPVpgCYMdKHsvKVZPD3JhgswU/a9SwPyj87w=;
  b=EQMg6mqWNR0rH9Ceg/K+dvbZpvW6QazmDl+2tnxOxsnLUAT0R+XkDb/8
   Qaxp6q6vE1AQ11hrQ4biHwYGxbdmWwkRV1XOAgeAynh5HBrUwtH8lIhBs
   OX6nZ26vdb6SnXYldYS6Ccl+sDB5pMEgkoTAFvnYU+UcU5tS2pQrhHFur
   aUduhVkyYbmZmnesSJVMAkCzAANxaZzzWfFBRs7OXNTbvN8c8WFwMkcqC
   ODmSvQ21g8IQn3TQc+DMIcV0PlYVhT1Kpks6TL7ZMm0qpiWxIkJPAe4dz
   odT+mYhZK7BxfNuen1nkIW0Nod2P5Znz9sJi35V1s82rqILAb4wvK8GxB
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10468"; a="299318414"
X-IronPort-AV: E=Sophos;i="5.93,310,1654585200"; 
   d="scan'208";a="299318414"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2022 14:57:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,310,1654585200"; 
   d="scan'208";a="567333392"
Received: from lkp-server02.sh.intel.com (HELO 4011df4f4fd3) ([10.239.97.151])
  by orsmga003.jf.intel.com with ESMTP; 12 Sep 2022 14:57:32 -0700
Received: from kbuild by 4011df4f4fd3 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oXrQp-0002uR-1g;
        Mon, 12 Sep 2022 21:57:31 +0000
Date:   Tue, 13 Sep 2022 05:57:09 +0800
From:   kernel test robot <lkp@intel.com>
To:     Shivam Kumar <shivam.kumar1@nutanix.com>, pbonzini@redhat.com,
        seanjc@google.com, maz@kernel.org, james.morse@arm.com,
        borntraeger@linux.ibm.com, david@redhat.com
Cc:     kbuild-all@lists.01.org, kvm@vger.kernel.org,
        Shivam Kumar <shivam.kumar1@nutanix.com>,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
Subject: Re: [PATCH v5 1/5] KVM: Implement dirty quota-based throttling of
 vcpus
Message-ID: <202209130532.2BJwW65L-lkp@intel.com>
References: <20220912040926.185481-2-shivam.kumar1@nutanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220912040926.185481-2-shivam.kumar1@nutanix.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Shivam,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on kvm/queue]
[also build test WARNING on mst-vhost/linux-next linus/master v6.0-rc5 next-20220912]
[cannot apply to kvms390/next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Shivam-Kumar/KVM-Dirty-quota-based-throttling/20220912-123509
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
reproduce:
        # https://github.com/intel-lab-lkp/linux/commit/772b4ec9f5aee3af7759fe673b6c1e157e7afb8d
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Shivam-Kumar/KVM-Dirty-quota-based-throttling/20220912-123509
        git checkout 772b4ec9f5aee3af7759fe673b6c1e157e7afb8d
        make menuconfig
        # enable CONFIG_COMPILE_TEST, CONFIG_WARN_MISSING_DOCUMENTS, CONFIG_WARN_ABI_ERRORS
        make htmldocs

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> Documentation/virt/kvm/api.rst:6630: WARNING: Block quote ends without a blank line; unexpected unindent.

vim +6630 Documentation/virt/kvm/api.rst

  6618	
  6619			/* KVM_EXIT_DIRTY_QUOTA_EXHAUSTED */
  6620			struct {
  6621				__u64 count;
  6622				__u64 quota;
  6623			} dirty_quota_exit;
  6624	If exit reason is KVM_EXIT_DIRTY_QUOTA_EXHAUSTED, it indicates that the VCPU has
  6625	exhausted its dirty quota. The 'dirty_quota_exit' member of kvm_run structure
  6626	makes the following information available to the userspace:
  6627		'count' field: the current count of pages dirtied by the VCPU, can be
  6628	        skewed based on the size of the pages accessed by each vCPU.
  6629		'quota' field: the observed dirty quota just before the exit to userspace.
> 6630	The userspace can design a strategy to allocate the overall scope of dirtying
  6631	for the VM among the vcpus. Based on the strategy and the current state of dirty
  6632	quota throttling, the userspace can make a decision to either update (increase)
  6633	the quota or to put the VCPU to sleep for some time.
  6634	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
