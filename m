Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B53B7320B2
	for <lists+kvm@lfdr.de>; Thu, 15 Jun 2023 22:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236191AbjFOUMr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 16:12:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230174AbjFOUMj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 16:12:39 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C6E9E69;
        Thu, 15 Jun 2023 13:12:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686859958; x=1718395958;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SXFiwNIFA8ag0+D8oI15OIEKtW2U4baWFXxyYWhjlKM=;
  b=Gn0bVqzuEIjd15icPYgK011Z0DfS5oKXzWBZ2tWlI5LhRh8tKFucOWSn
   7ipLLymSp1FgcBVm5Hf7AgcaVfkk6P8VEXY05VNY11yK1rmdphaIiGGyA
   tsvDh7nU/TYJTgoEgOtqqJMxjrtg2pvUCRMSOZj2ULrzB9nq5O7cFW4i+
   oN7zePLO/bPhmzxqTc06rG5wUbYWLtAQsA7myOCbUecYcEj8saUvaMMhM
   6tzU6FVU4FAIPRyC8rrTgBVys2PiNzfxKXEeiOuYVLYqfZCIr6j/0HCsS
   9QwH5tEYnn6qtgpu3V7ws51nhGU5Cd8uL8zw9T8V+WahslC57Hvu+Bvwf
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="387611447"
X-IronPort-AV: E=Sophos;i="6.00,245,1681196400"; 
   d="scan'208";a="387611447"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 13:12:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="712576651"
X-IronPort-AV: E=Sophos;i="6.00,245,1681196400"; 
   d="scan'208";a="712576651"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 13:12:36 -0700
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
Subject: [RFC PATCH 2/6] KVM: selftests: Fix guest_memfd()
Date:   Thu, 15 Jun 2023 13:12:15 -0700
Message-Id: <9e3e99f78fcbd7db21368b5fe1d931feeb4db567.1686858861.git.isaku.yamahata@intel.com>
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

Some test cases should succeed.  Check !ret instead of ret.

Fixes: 36eedd5b91e3 ("KVM: selftests: Add basic selftest for guest_memfd()")
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 tools/testing/selftests/kvm/guest_memfd_test.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 3b6532b833b2..f3b99c1e5464 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -72,11 +72,11 @@ static void test_fallocate(int fd, size_t page_size, size_t total_size)
 
 	ret = fallocate(fd, FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE,
 			total_size, page_size);
-	TEST_ASSERT(ret, "fallocate(PUNCH_HOLE) at total_size should be fine (no-op)");
+	TEST_ASSERT(!ret, "fallocate(PUNCH_HOLE) at total_size should be fine (no-op)");
 
 	ret = fallocate(fd, FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE,
 			total_size + page_size, page_size);
-	TEST_ASSERT(ret, "fallocate(PUNCH_HOLE) after total_size should be fine (no-op)");
+	TEST_ASSERT(!ret, "fallocate(PUNCH_HOLE) after total_size should be fine (no-op)");
 
 	ret = fallocate(fd, FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE,
 			page_size, page_size - 1);
-- 
2.25.1

