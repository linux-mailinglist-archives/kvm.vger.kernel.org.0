Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84E4B7AA096
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 22:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231960AbjIUUlu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 16:41:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230197AbjIUUlf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 16:41:35 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F1511731;
        Thu, 21 Sep 2023 13:15:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695327319; x=1726863319;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xgBlKNZhDNJa7QFdNnudGsohvQxeiXqUZBEeWY2YObQ=;
  b=EHO0LIM/x1tFIuqEOXOraBxGoiC3wL3XeEvUQi76PSAv2AYAJCbQk7Qi
   D24pIX6CkkEAwsv4Pk0/OZQ679ETeH2lAh/Zatn1cJq6AAtZm/x/uTEqR
   Df9a5aGmrCb4/7S/4qOnWBA9TZ1cjmbQ+YaC/GvACvYTDhfC3VsiraNjX
   Gelt3u36fY6T5Id7Nhl3WgFRXUKVgqueiwQKfRmmBmu3QA4EXJXi2xMQ2
   S4tKbVNuhArxpvYuVmsVbrJ03Vc+Ww0OgPHRsgbOM08lcRi74eWeE7nJc
   nA5j6q5HAbehud+d3DE7Rj9J9wMa6aEiAXAPOZO01pWGfgyPuj01xufDm
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10840"; a="383401651"
X-IronPort-AV: E=Sophos;i="6.03,166,1694761200"; 
   d="scan'208";a="383401651"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2023 13:14:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10840"; a="696897810"
X-IronPort-AV: E=Sophos;i="6.03,166,1694761200"; 
   d="scan'208";a="696897810"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2023 13:14:49 -0700
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
Subject: [RFC PATCH v2 5/6] KVM: selftests: Add test cases for KVM_GUEST_MEMORY_FAILURE
Date:   Thu, 21 Sep 2023 13:14:38 -0700
Message-Id: <71be0cea7cd1ed2d7d20403a803213a9e2b28c11.1695327124.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1695327124.git.isaku.yamahata@intel.com>
References: <cover.1695327124.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
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

Add text cases for guest_memfd KVM_GUEST_MEMORY_FAILURE ioctl.
+ ioctl(KVM_GUEST_MEMORY_FAILURE) success with backing pages
+ ioctl(KVM_GUEST_MEMORY_FAILURE) fails with ENOENT without backing page
+ interaction with fallocate(PUNCH_HOLE)

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 .../testing/selftests/kvm/guest_memfd_test.c  | 48 +++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index d5b4bfcdc3fe..f8b242c9319d 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -122,6 +122,53 @@ static void test_fallocate_fail(int fd, size_t page_size, size_t total_size)
 	}
 }
 
+static void test_memory_failure(int fd, size_t page_size, size_t total_size)
+{
+	struct kvm_guest_memory_failure mf;
+	int ret;
+	int i;
+
+	/* Make whole file unallocated as known initial state */
+	ret = fallocate(fd, FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE,
+			0, total_size);
+	TEST_ASSERT(!ret, "fallocate(PUNCH_HOLE) at while file should succeed");
+
+	/* Because there is no backing page, fail to inject memory failure. */
+	for (i = 0; i < total_size / page_size; i++) {
+		mf = (struct kvm_guest_memory_failure) {
+			.offset = i * page_size,
+		};
+
+		ret = ioctl(fd, KVM_GUEST_MEMORY_FAILURE, &mf);
+		if (ret == -1 && errno == EPERM) {
+			pr_info("KVM_GUEST_MEMORY_FAILURE requires CAP_SYS_ADMIN. Skipping.\n")
+			return;
+		}
+		TEST_ASSERT(ret == -1 && errno == ENOENT,
+			    "ioctl(KVM_GUEST_MEMORY_FAILURE) should fail i %d", i);
+	}
+
+	/* Allocate pages with index one and two. */
+	ret = fallocate(fd, FALLOC_FL_KEEP_SIZE, page_size, page_size * 2);
+	TEST_ASSERT(!ret, "fallocate beginning at page_size should succeed");
+
+	for (i = 0; i < total_size / page_size; i++) {
+		mf = (struct kvm_guest_memory_failure) {
+			.offset = i * page_size,
+		};
+
+		ret = ioctl(fd, KVM_GUEST_MEMORY_FAILURE, &mf);
+
+		if (i == 1 || i == 2) {
+			TEST_ASSERT(!ret || (ret == -1 && errno == EBUSY),
+				    "ioctl(KVM_GUEST_MEMORY_FAILURE) should succeed i %d", i);
+		} else {
+			TEST_ASSERT(ret == -1 && errno == ENOENT,
+				    "ioctl(KVM_GUEST_MEMORY_FAILURE) should fail i %d", i);
+		}
+	}
+}
+
 static void test_create_guest_memfd_invalid(struct kvm_vm *vm)
 {
 	uint64_t valid_flags = 0;
@@ -192,6 +239,7 @@ int main(int argc, char *argv[])
 	test_file_size(fd, page_size, total_size);
 	test_fallocate(fd, page_size, total_size);
 	test_fallocate_fail(fd, page_size, total_size);
+	test_memory_failure(fd, page_size, total_size);
 
 	close(fd);
 }
-- 
2.25.1

