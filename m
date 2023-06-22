Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 626A873AD0B
	for <lists+kvm@lfdr.de>; Fri, 23 Jun 2023 01:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231637AbjFVXRa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jun 2023 19:17:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231592AbjFVXR0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jun 2023 19:17:26 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B0402686;
        Thu, 22 Jun 2023 16:17:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687475834; x=1719011834;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ey//Er7uRB344w44NonunJHMD5Ey7BtAHN0MXVhUTHM=;
  b=LKlzvoWIj7iG8jZR06FfSD7ThFb4U3wyZuWDqM0nnJ5PBrF9yyVt2Z/o
   qFwP10eH9FoSbYH7GIoBOCI9Vy5TPFrIwgVo8Maq8KUZUmB+UWZXf/G4a
   xulxfFvkeEzyoZvfWUwxgF1gp1dexRXN0M4nQhV5p2glICrmZ5bF+dA33
   Q69E/BpS4ZMVENWRdu32VvGG9/UCn2gsXtnE8Q1m6JyOYBAoXRH8oeNCS
   mKmKraJ+VJ5sExO1YU7zVht/Hv4KEBp7qbbpFmNhX3Io/Jhc2OwoLhTN/
   1tw0HGaBeYeurc6Z6YCbEeCqmgZgzmSkZcYxVC4cd9WfRnBN1HYDNzILZ
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10749"; a="358129721"
X-IronPort-AV: E=Sophos;i="6.01,150,1684825200"; 
   d="scan'208";a="358129721"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2023 16:17:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10749"; a="718285976"
X-IronPort-AV: E=Sophos;i="6.01,150,1684825200"; 
   d="scan'208";a="718285976"
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
Subject: [RFC PATCH v2 2/6] KVM: selftests: Fix guest_memfd()
Date:   Thu, 22 Jun 2023 16:16:26 -0700
Message-Id: <6934b5a7c87a9804360678c52553cf92c3870b5a.1687474039.git.isaku.yamahata@intel.com>
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

Some test cases should succeed.  Check !ret instead of ret.

Fixes: 36eedd5b91e3 ("KVM: selftests: Add basic selftest for guest_memfd()")
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
Changes v1 -> v2:
- no change
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

