Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CBBF77D727
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 02:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240864AbjHPAn6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 20:43:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233831AbjHPAnZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 20:43:25 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFFB38E;
        Tue, 15 Aug 2023 17:43:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692146603; x=1723682603;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=EXFt+DVMPpy5/WiDLt0PKUW2C3TnX2KNn2swCXJ/iCM=;
  b=WRn29HQMLB7163zt52vnEF9wFZdKprD9Vjw+u/2BRytomaEwS8CTZD26
   UlsUwf+5Ojq1Ns9qqt/LMVFqookoEVWmnW6DgJJUilxQGiFCl5ekdXqlK
   38pXBlL78WOg3iCjlTY4Tl0pgq12zcgXP11/KzZPlk+e8q7v+oh1VtIme
   OHgPIK2thKZuOzDKQ8OmkYvdnmmxEXozzsTDNJK92uCCnhmIiKXKPRaLZ
   Wwg8R/zc9W7i3w8wzRJqqimyZ8CesaLBuCnTu7PCGEDt9k/krWEopJh0o
   vdf/UdLQfWNVaV6SoQX8lXY7G+krkEupFAeeFfeR5qKtpabngazx1mSqG
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="352739008"
X-IronPort-AV: E=Sophos;i="6.01,175,1684825200"; 
   d="scan'208";a="352739008"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2023 17:43:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="763459820"
X-IronPort-AV: E=Sophos;i="6.01,175,1684825200"; 
   d="scan'208";a="763459820"
Received: from lkp-server02.sh.intel.com (HELO b5fb8d9e1ffc) ([10.239.97.151])
  by orsmga008.jf.intel.com with ESMTP; 15 Aug 2023 17:43:18 -0700
Received: from kbuild by b5fb8d9e1ffc with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qW4d3-0001M3-0B;
        Wed, 16 Aug 2023 00:43:17 +0000
Date:   Wed, 16 Aug 2023 08:42:20 +0800
From:   kernel test robot <lkp@intel.com>
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     oe-kbuild-all@lists.linux.dev, isaku.yamahata@intel.com,
        isaku.yamahata@gmail.com, Michael Roth <michael.roth@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, erdemaktas@google.com,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        linux-coco@lists.linux.dev,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Xu Yilun <yilun.xu@intel.com>,
        Quentin Perret <qperret@google.com>, wei.w.wang@intel.com,
        Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH 6/8] KVM: gmem, x86: Add gmem hook for invalidating
 private memory
Message-ID: <202308160801.jwbys3HI-lkp@intel.com>
References: <8c9f0470ba6e5dc122f3f4e37c4dcfb6fb97b184.1692119201.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8c9f0470ba6e5dc122f3f4e37c4dcfb6fb97b184.1692119201.git.isaku.yamahata@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

kernel test robot noticed the following build errors:

[auto build test ERROR on 89b6a7b873d72280e85976bbb8fe4998b2ababa8]

url:    https://github.com/intel-lab-lkp/linux/commits/isaku-yamahata-intel-com/KVM-gmem-Make-kvm_gmem_bind-return-EBADF-on-wrong-fd/20230816-012315
base:   89b6a7b873d72280e85976bbb8fe4998b2ababa8
patch link:    https://lore.kernel.org/r/8c9f0470ba6e5dc122f3f4e37c4dcfb6fb97b184.1692119201.git.isaku.yamahata%40intel.com
patch subject: [PATCH 6/8] KVM: gmem, x86: Add gmem hook for invalidating private memory
config: x86_64-allyesconfig (https://download.01.org/0day-ci/archive/20230816/202308160801.jwbys3HI-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce: (https://download.01.org/0day-ci/archive/20230816/202308160801.jwbys3HI-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202308160801.jwbys3HI-lkp@intel.com/

All errors (new ones prefixed by >>):

   arch/x86/kvm/../../../virt/kvm/guest_mem.c: In function 'kvm_gmem_punch_hole':
>> arch/x86/kvm/../../../virt/kvm/guest_mem.c:186:40: error: 'kvm' undeclared (first use in this function)
     186 |         kvm_gmem_issue_arch_invalidate(kvm, file, start, end);
         |                                        ^~~
   arch/x86/kvm/../../../virt/kvm/guest_mem.c:186:40: note: each undeclared identifier is reported only once for each function it appears in
>> arch/x86/kvm/../../../virt/kvm/guest_mem.c:186:45: error: 'file' undeclared (first use in this function)
     186 |         kvm_gmem_issue_arch_invalidate(kvm, file, start, end);
         |                                             ^~~~


vim +/kvm +186 arch/x86/kvm/../../../virt/kvm/guest_mem.c

   169	
   170	static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
   171	{
   172		struct list_head *gmem_list = &inode->i_mapping->private_list;
   173		pgoff_t start = offset >> PAGE_SHIFT;
   174		pgoff_t end = (offset + len) >> PAGE_SHIFT;
   175		struct kvm_gmem *gmem;
   176	
   177		/*
   178		 * Bindings must stable across invalidation to ensure the start+end
   179		 * are balanced.
   180		 */
   181		filemap_invalidate_lock(inode->i_mapping);
   182	
   183		list_for_each_entry(gmem, gmem_list, entry)
   184			kvm_gmem_invalidate_begin(gmem, start, end);
   185	
 > 186		kvm_gmem_issue_arch_invalidate(kvm, file, start, end);
   187		truncate_inode_pages_range(inode->i_mapping, offset, offset + len - 1);
   188	
   189		list_for_each_entry(gmem, gmem_list, entry)
   190			kvm_gmem_invalidate_end(gmem, start, end);
   191	
   192		filemap_invalidate_unlock(inode->i_mapping);
   193	
   194		return 0;
   195	}
   196	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
