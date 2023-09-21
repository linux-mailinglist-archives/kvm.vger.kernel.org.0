Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 847877AA093
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 22:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232218AbjIUUlO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 16:41:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232037AbjIUUlD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 16:41:03 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 184B526B6;
        Thu, 21 Sep 2023 13:14:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695327286; x=1726863286;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=uUCSLp/kd/xQmu6AYVH2w6xDmJBkRdaL5zkVvNRUtpE=;
  b=G0qelphJrhk5QH+VHZuifkUQPKf6mbNVaIZb7Hji7rOaSxFhTUqn57Fq
   R0JVXDBIeYH/00um5ed92sGVTi9RUkWC8LT7ApAQRUOcTL6bMnzoX+YU4
   oGksFPFcraqlRMtZtUKi4b0fSJ2lny2Vb8+hhBjD6lwaeIZvbYXQadL+2
   iVe6FN7cY0ZvQ0H7rRBIYF16YFj2pDTk/lx/quD4X2USUR1hL5enAzG6U
   78X3IjDo3T9Xk2lI+BkQwpQFroeINLHBCuwSNHCP4k0T63xILOdOYGPWM
   hUyr7V21yUFlZHNT5r3pKWJ/GGQdX/emx3ZHYuhaiMitvmsDH9OFWOrpK
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10840"; a="383401581"
X-IronPort-AV: E=Sophos;i="6.03,166,1694761200"; 
   d="scan'208";a="383401581"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2023 13:14:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10840"; a="696897775"
X-IronPort-AV: E=Sophos;i="6.03,166,1694761200"; 
   d="scan'208";a="696897775"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2023 13:14:44 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Michael Roth <michael.roth@amd.com>,
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
Subject: [RFC PATCH v2 0/6] KVM: gmem: Implement test cases for error_remove_page
Date:   Thu, 21 Sep 2023 13:14:33 -0700
Message-Id: <cover.1695327124.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

This patch series is to implement test cases for the KVM gmem error_remove_page
method.
- Update punch hole method to truncate pages
- Add a new ioctl KVM_GUEST_MEMORY_FAILURE to inject memory failure on
  offset of gmem

TODO:
- Update TDX KVM to handle it and Add test cases for TDX.
  This will be done by its own patch series.

Changes:
v2:
- rebased to [RFC PATCH v12 00/33] KVM: guest_memfd() and per-page attributes
  https://lore.kernel.org/all/20230914015531.1419405-1-seanjc@google.com/
- introduce new ioctl to inject memory fault on gmem and drop FIBMAP hack
- Implement test cases

v1:
https://lore.kernel.org/all/cover.1694599703.git.isaku.yamahata@intel.com/

Isaku Yamahata (6):
  KVM: gmem: Truncate pages on punch hole
  KVM: selftests: Add negative test cases for punch hole for
    guest_memfd()
  KVM: selftests: Add tests for punch hole on guest_memfd
  KVM: gmem: Add ioctl to inject memory failure on guest memfd
  KVM: selftests: Add test cases for KVM_GUEST_MEMORY_FAILURE
  KVM: guest_memfd: selftest: Add test case for error_remove_page method

 include/uapi/linux/kvm.h                      |   6 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../testing/selftests/kvm/guest_memfd_test.c  |  80 ++++
 .../kvm/x86_64/private_mem_conversions_test.c |  26 +-
 .../kvm/x86_64/private_mem_hwpoison_test.c    | 367 ++++++++++++++++++
 virt/kvm/guest_mem.c                          |  82 +++-
 6 files changed, 554 insertions(+), 8 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/private_mem_hwpoison_test.c


base-commit: 42dc814987c1feb6410904e58cfd4c36c4146150
prerequisite-patch-id: 3c646922da088ceebe447974a90217f377b76e4a
prerequisite-patch-id: 635c4dca26af8d105a4fd8f603e4a9cf830395c7
prerequisite-patch-id: eede5382aa76c0602a853fc93a1450995c651345
prerequisite-patch-id: 5549aad02248eb5a0c2853058dc7c102044c7a9d
prerequisite-patch-id: ab6557f79edb77246ee1e9955be81a10841e65fd
prerequisite-patch-id: bf75388851ee37a83b37bfa7cb0084f27301f6bc
prerequisite-patch-id: cecffe9a2445f2ea01b9fdb1356b1c87eb6b8fe7
prerequisite-patch-id: e1692d657690f974d836ba3efdd277ea82e675ca
prerequisite-patch-id: 747debe72334ef0cd12bbb42d1acb281eb59cd98
prerequisite-patch-id: 2d1df1bad8af51577ec15a37510ea8bf018b0d4f
prerequisite-patch-id: d05f7429ca893fe0fe3beb460bba1400379cd0d1
prerequisite-patch-id: 9916b6553a61beb9a5435bc0b1fcacf0a87165ea
prerequisite-patch-id: 313219882d617e4d4cb226760d1f071f52b3f882
prerequisite-patch-id: 5412c4037793bc0999377f9732290b9944257b7c
prerequisite-patch-id: b737a534d8da531f6d030be5e864a3097ca97384
prerequisite-patch-id: cafe1f6964532d261b950e1879e091dc8c0b4386
prerequisite-patch-id: 20a5d5b1f853828061ccb07ed08459b9922e5214
prerequisite-patch-id: 756402fa0914a86ac7db59aa54e36a7bca9d0770
prerequisite-patch-id: 0e93d19cb59f3a052a377a56ff0a4399046818aa
prerequisite-patch-id: 8576bf7ec9f786870e72b78299dcab5dd4eb0d23
prerequisite-patch-id: 0693f3aa65226ff9ffa1f70b6f6da2410ebd0588
prerequisite-patch-id: 301dbdf8448175ea609664c890a3694750ecf740
prerequisite-patch-id: 8f67d4366ca5c9875c4ef7f445941e3ad3162c75
prerequisite-patch-id: 2d62d84b4f9db4148af35495ce1b188c6b46f421
prerequisite-patch-id: b4526dee5b5a95da0a13116ae0c73d4e69efa3c6
prerequisite-patch-id: 8a2b4167ea632413ba8f6d39788ddf19eb928ab0
prerequisite-patch-id: 5618d2414a1ef641b4c247b5e28076f67a765b24
prerequisite-patch-id: 4415e2df6492fbb64746e3503deba6e991a0e08b
prerequisite-patch-id: ba50138fe73e9a5f58e19eebaab2c17a2dc231e3
prerequisite-patch-id: 1225df90aeae430a74354bc5ad0ddf508d0707db
prerequisite-patch-id: 4c0e6ab89b9a3ed3a2cb236e942b5842926bf868
prerequisite-patch-id: 59f78d417ca58088e336f8e2a9540d1c95bd2f6c
prerequisite-patch-id: b6a6a8916fe89e7da1fadefb7d311960732e0faf
-- 
2.25.1

