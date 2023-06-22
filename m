Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1E9573AD0A
	for <lists+kvm@lfdr.de>; Fri, 23 Jun 2023 01:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231618AbjFVXR2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jun 2023 19:17:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231608AbjFVXRX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jun 2023 19:17:23 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D8C51BCC;
        Thu, 22 Jun 2023 16:17:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687475832; x=1719011832;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ermiXTEXQyF8E2ENU1Af3tf1v3KAorTSmp9Pi7fGpOs=;
  b=Vhq4I2BV6FYdew35LoEKDmIw8SZc8U8sbR6zTu2ihKFjd5C/dcF/Ukft
   dyesFvSu9Mpo/Zk7s/BBKQ6JQokvNnoAf312meSXwoN8EQS+kPCi+TDfh
   O25uvbr7aGut4NE5/N9etWkWcwqCOImqLD1O5VuWEXC7BSpOouJBVBHA6
   bP3YMYlccY32NLtTBLLlQEAoIGp37chsbIfRhvQ/Erwr8dG8A6METia86
   KRQdkRUMN4m9ROw9zQMW/GxcYdTDzkFj7IerrIqGGruI3oF02qbksckTS
   yP1AsELHEOURudq0jeFyoTUp78sd9VFduc7Q7TvV5IZUwzY/rWADmL5j6
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10749"; a="358129716"
X-IronPort-AV: E=Sophos;i="6.01,150,1684825200"; 
   d="scan'208";a="358129716"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2023 16:17:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10749"; a="718285973"
X-IronPort-AV: E=Sophos;i="6.01,150,1684825200"; 
   d="scan'208";a="718285973"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2023 16:17:10 -0700
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
Subject: [RFC PATCH v2 1/6] KVM: selftests: Fix test_add_overlapping_private_memory_regions()
Date:   Thu, 22 Jun 2023 16:16:25 -0700
Message-Id: <ac38d8f7248ad5b9fe0bb473d00e8e4430e04028.1687474039.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1687474039.git.isaku.yamahata@intel.com>
References: <cover.1687474039.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
Changes v1 -> v2:
- no change
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

