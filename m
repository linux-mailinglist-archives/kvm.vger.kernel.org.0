Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8AF67BF618
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 10:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442978AbjJJIgG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 04:36:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442928AbjJJIfl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 04:35:41 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B189EB4;
        Tue, 10 Oct 2023 01:35:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696926939; x=1728462939;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=o5MD2FPMw4tHBthOkn4CAG942xWE4Di7Fgiy08pHbDg=;
  b=UIFpXu14YFLCr6Q2IJYfye6b2fpkjRbP3hH67zkmd4V0qy99cwH33bh/
   J96S00sLPbeEn8WKym2vCKE6Jy01bFK0TkaHPhSslHMU47qIO/ka3ieWQ
   ug6KDXT2EzY6iCxq3Ouv2El3F4AnjLKtMxlUIFeFF9qG5yQ8Y/HSm8YY6
   uwLDjOhG4X310sQlO/NZDzrWWtOdaC6rk8h7Rlg3DDfdu99OAJmOf+dl/
   EaoJWqRuIn1zHARkEwZSlgs4Jsks56Z3ncycGV1Kp3UzN81SelplKHdg1
   EjEfvu73K0HlQBY/TXGiMy1fEwIK7e00Mo/HJrIaj/dxoXj1zn35rgf5o
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10858"; a="363689848"
X-IronPort-AV: E=Sophos;i="6.03,212,1694761200"; 
   d="scan'208";a="363689848"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2023 01:35:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10858"; a="1084687210"
X-IronPort-AV: E=Sophos;i="6.03,212,1694761200"; 
   d="scan'208";a="1084687210"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2023 01:35:36 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Michael Roth <michael.roth@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-coco@lists.linux.dev, Chao Peng <chao.p.peng@linux.intel.com>
Subject: [PATCH 11/12] KVM: selftests: lib: Add src memory type for hwpoison test
Date:   Tue, 10 Oct 2023 01:35:19 -0700
Message-Id: <f3fe54089dd91357a29590444cf1a41abee39a9a.1696926843.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1696926843.git.isaku.yamahata@intel.com>
References: <cover.1696926843.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

For hwpoison test to recover hwpoisoned memory, use madvise(MADV_FREE) that
requires private mapping.  Add a new src memory type for it.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 tools/testing/selftests/kvm/include/test_util.h | 2 ++
 tools/testing/selftests/kvm/lib/kvm_util.c      | 7 +++++--
 tools/testing/selftests/kvm/lib/test_util.c     | 8 ++++++++
 3 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
index 7e614adc6cf4..c97af4ff0699 100644
--- a/tools/testing/selftests/kvm/include/test_util.h
+++ b/tools/testing/selftests/kvm/include/test_util.h
@@ -111,6 +111,8 @@ enum vm_mem_backing_src_type {
 	VM_MEM_SRC_ANONYMOUS_HUGETLB_16GB,
 	VM_MEM_SRC_SHMEM,
 	VM_MEM_SRC_SHARED_HUGETLB,
+	VM_MEM_SRC_ANONYMOUS_MEMFD,
+	VM_MEM_SRC_ANONYMOUS_MEMFD_HUGETLB,
 	NUM_SRC_TYPES,
 };
 
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 310c3a760cb8..95ffb3b97dcf 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1007,9 +1007,12 @@ void __vm_userspace_mem_region_add(struct kvm_vm *vm,
 		region->mmap_size += alignment;
 
 	region->fd = -1;
-	if (backing_src_is_shared(src_type))
+	if (backing_src_is_shared(src_type) ||
+		src_type == VM_MEM_SRC_ANONYMOUS_MEMFD ||
+		src_type == VM_MEM_SRC_ANONYMOUS_MEMFD_HUGETLB)
 		region->fd = kvm_memfd_alloc(region->mmap_size,
-					     src_type == VM_MEM_SRC_SHARED_HUGETLB);
+					     src_type == VM_MEM_SRC_SHARED_HUGETLB ||
+					     src_type == VM_MEM_SRC_ANONYMOUS_MEMFD_HUGETLB);
 
 	region->mmap_start = mmap(NULL, region->mmap_size,
 				  PROT_READ | PROT_WRITE,
diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/selftests/kvm/lib/test_util.c
index 5d7f28b02d73..a09bba5c074e 100644
--- a/tools/testing/selftests/kvm/lib/test_util.c
+++ b/tools/testing/selftests/kvm/lib/test_util.c
@@ -281,6 +281,14 @@ const struct vm_mem_backing_src_alias *vm_mem_backing_src_alias(uint32_t i)
 			 */
 			.flag = MAP_SHARED,
 		},
+		[VM_MEM_SRC_ANONYMOUS_MEMFD] = {
+			.name = "anonymous_memfd",
+			.flag = ANON_FLAGS,
+		},
+		[VM_MEM_SRC_ANONYMOUS_MEMFD_HUGETLB] = {
+			.name = "anonymous_memfd_hugetlb",
+			.flag = ANON_HUGE_FLAGS,
+		},
 	};
 	_Static_assert(ARRAY_SIZE(aliases) == NUM_SRC_TYPES,
 		       "Missing new backing src types?");
-- 
2.25.1

