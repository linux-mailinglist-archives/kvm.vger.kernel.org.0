Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 414E9785544
	for <lists+kvm@lfdr.de>; Wed, 23 Aug 2023 12:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233376AbjHWKUJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Aug 2023 06:20:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232892AbjHWKUH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Aug 2023 06:20:07 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 985B193;
        Wed, 23 Aug 2023 03:20:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692786003; x=1724322003;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=J/smH+od+JQo9e6T8OxoQJwtGe7Bs2VOOafthAAhtBs=;
  b=ly7RPjJa9pPchWinWLJkwPPoX7NDIBTz6HcdkrMX2qVMrPb1LwTJYhlM
   FkY5E07VyHjkSJ5OjDGguhmJDucfU0DDvaMnKc7iDeX+dG5ecNGetTtJx
   yH1AGal06klx+X8nx5LQqi8KTC3opBLoW/ItZ5NEL0gIOBXv3YP40rJuy
   +YseZMuZQRwybtVwnEJs3wH64hJX6CsfnARGk17RJUATJd5GcViVwTQgV
   I+XZ+RJSmx3QWopPnYVaEYwDMbDSef8ehKVTKauNj3XY54z+v/8cettp6
   FDXJUkhZLZcyZ/zO8L2N2n2l3mANqlEZtvb5p1KniHiBcdr/oB+cq93M7
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10810"; a="377884496"
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="scan'208";a="377884496"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2023 03:20:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10810"; a="730169336"
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="scan'208";a="730169336"
Received: from lkp-server02.sh.intel.com (HELO daf8bb0a381d) ([10.239.97.151])
  by orsmga007.jf.intel.com with ESMTP; 23 Aug 2023 03:19:57 -0700
Received: from kbuild by daf8bb0a381d with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qYkxw-00016C-0r;
        Wed, 23 Aug 2023 10:19:56 +0000
Date:   Wed, 23 Aug 2023 18:19:40 +0800
From:   kernel test robot <lkp@intel.com>
To:     Huang Jiaqing <jiaqing.huang@intel.com>, kvm@vger.kernel.org,
        iommu@lists.linux.dev, linux-kernel@vger.kernel.org
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        joro@8bytes.org, will@kernel.org, robin.murphy@arm.com,
        kevin.tian@intel.com, baolu.lu@linux.intel.com,
        jacob.jun.pan@linux.intel.com, yi.l.liu@intel.com,
        yi.y.sun@intel.com, jiaqing.huang@intel.com
Subject: Re: [PATCH] iommu/vt-d: Introduce a rb_tree for looking up device
Message-ID: <202308231801.6MtvqTmB-lkp@intel.com>
References: <20230821071659.123981-1-jiaqing.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230821071659.123981-1-jiaqing.huang@intel.com>
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

[auto build test WARNING on v6.5-rc7]
[also build test WARNING on linus/master]
[cannot apply to joro-iommu/next next-20230823]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Huang-Jiaqing/iommu-vt-d-Introduce-a-rb_tree-for-looking-up-device/20230821-151945
base:   v6.5-rc7
patch link:    https://lore.kernel.org/r/20230821071659.123981-1-jiaqing.huang%40intel.com
patch subject: [PATCH] iommu/vt-d: Introduce a rb_tree for looking up device
config: x86_64-rhel-8.3-rust (https://download.01.org/0day-ci/archive/20230823/202308231801.6MtvqTmB-lkp@intel.com/config)
compiler: clang version 15.0.7 (https://github.com/llvm/llvm-project.git 8dfdcc7b7bf66834a761bd8de445840ef68e4d1a)
reproduce: (https://download.01.org/0day-ci/archive/20230823/202308231801.6MtvqTmB-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202308231801.6MtvqTmB-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/iommu/intel/iommu.c:239:28: warning: no previous prototype for function 'device_rbtree_find' [-Wmissing-prototypes]
   struct device_domain_info *device_rbtree_find(struct intel_iommu *iommu, u8 bus, u8 devfn)
                              ^
   drivers/iommu/intel/iommu.c:239:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   struct device_domain_info *device_rbtree_find(struct intel_iommu *iommu, u8 bus, u8 devfn)
   ^
   static 
   1 warning generated.


vim +/device_rbtree_find +239 drivers/iommu/intel/iommu.c

   237	
   238	
 > 239	struct device_domain_info *device_rbtree_find(struct intel_iommu *iommu, u8 bus, u8 devfn)
   240	{
   241		struct device_domain_info *data = NULL;
   242		struct rb_node *node;
   243	
   244		down_read(&iommu->iopf_device_sem);
   245	
   246		node = iommu->iopf_device_rbtree.rb_node;
   247		while (node) {
   248			data = container_of(node, struct device_domain_info, node);
   249			s16 result = RB_NODE_CMP(bus, devfn, data->bus, data->devfn);
   250	
   251			if (result < 0)
   252				node = node->rb_left;
   253			else if (result > 0)
   254				node = node->rb_right;
   255			else
   256				break;
   257		}
   258		up_read(&iommu->iopf_device_sem);
   259	
   260		return node ? data : NULL;
   261	}
   262	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
