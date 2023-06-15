Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E7B67320B1
	for <lists+kvm@lfdr.de>; Thu, 15 Jun 2023 22:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235704AbjFOUMo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 16:12:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbjFOUMi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 16:12:38 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD3F912E;
        Thu, 15 Jun 2023 13:12:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686859957; x=1718395957;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eOHhXhX/zKooxVF8rvqXJbJxqJhicIuTcsuvo4fz+k0=;
  b=CvgVwPD3hw6PuX3pdZyIrNjVhf3vKlseoa+4U2MuPO38mUk7Kf62Jhh+
   eQOVEy7/J1mws2Bw/eiJD3ekccOuwUgjRHoFjdR0h+6aqSczXi4dZ77vw
   n2GzEWa17MUFsR5W8Cjt3IrgRD8QLrVvgn38wJ9RAvFxIycZ/m16a5iA3
   6jXy+zYCcdVVy57id576beZPkkb9N9c0XBPZgZqtdO9qxo++Amt3i+C7A
   P1GnubKsCAkEaRwqBAW5/DgpyPrALGka+KVHboCypm7rWNKbkBeQWnLFj
   mvCBXGZkhvSV8MFgePwnwe1ENAqsxe+O32RgsBweSKbiC95dDLS6Gro2j
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="387611436"
X-IronPort-AV: E=Sophos;i="6.00,245,1681196400"; 
   d="scan'208";a="387611436"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 13:12:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="712576646"
X-IronPort-AV: E=Sophos;i="6.00,245,1681196400"; 
   d="scan'208";a="712576646"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 13:12:35 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        linux-coco@lists.linux.dev,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Michael Roth <michael.roth@amd.com>
Subject: [RFC PATCH 1/6] KVM: selftests: Fix test_add_overlapping_private_memory_regions()
Date:   Thu, 15 Jun 2023 13:12:14 -0700
Message-Id: <b09b6a888067658c5ac42ad2b2256a8154525c10.1686858861.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1686858861.git.isaku.yamahata@intel.com>
References: <cover.1686858861.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

The last test in test_add_overlapping_private_memory_regions() doesn't use
overlapping regions resulting in the failure.  When the region is overlaps
with the existing ones, the error code is EEXIST instead of EINVAL.  Pass
the overlapping region, and check if the errno is EEXIST.

Fixes: bdb645960cb5 ("KVM: selftests: Expand set_memory_region_test to validate guest_memfd()")
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 .../selftests/kvm/set_memory_region_test.c       | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
index f46841843300..ea7da324c4d6 100644
--- a/tools/testing/selftests/kvm/set_memory_region_test.c
+++ b/tools/testing/selftests/kvm/set_memory_region_test.c
@@ -432,6 +432,7 @@ static void test_add_overlapping_private_memory_regions(void)
 {
 	struct kvm_vm *vm;
 	int memfd;
+	int r;
 
 	pr_info("Testing ADD of overlapping KVM_MEM_PRIVATE memory regions\n");
 
@@ -453,8 +454,19 @@ static void test_add_overlapping_private_memory_regions(void)
 	vm_set_user_memory_region2(vm, MEM_REGION_SLOT, KVM_MEM_PRIVATE,
 				   MEM_REGION_GPA, 0, NULL, -1, 0);
 
-	test_invalid_guest_memfd(vm, memfd, MEM_REGION_SIZE,
-				 "Overlapping guest_memfd() bindings should fail");
+	r = __vm_set_user_memory_region2(vm, MEM_REGION_SLOT, KVM_MEM_PRIVATE,
+					 MEM_REGION_GPA * 2 - MEM_REGION_SIZE,
+					 MEM_REGION_SIZE * 2,
+					 0, memfd, 0);
+	TEST_ASSERT(r == -1 && errno == EEXIST, "%s",
+		    "Overlapping guest_memfd() bindings should fail");
+
+	r = __vm_set_user_memory_region2(vm, MEM_REGION_SLOT, KVM_MEM_PRIVATE,
+					 MEM_REGION_GPA * 2 + MEM_REGION_SIZE,
+					 MEM_REGION_SIZE * 2,
+					 0, memfd, 0);
+	TEST_ASSERT(r == -1 && errno == EEXIST, "%s",
+		    "Overlapping guest_memfd() bindings should fail");
 
 	close(memfd);
 	kvm_vm_free(vm);
-- 
2.25.1

