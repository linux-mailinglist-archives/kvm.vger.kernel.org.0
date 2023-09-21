Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12DA47AA092
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 22:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231893AbjIUUlS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 16:41:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232245AbjIUUlF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 16:41:05 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E793199B;
        Thu, 21 Sep 2023 13:14:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695327289; x=1726863289;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=j8I9xEhVY8G4DBx7Fus59ORWF9OXOGvs193SinT1foI=;
  b=LwjCAnJ137rH5XRwhcftBz4jCl1S0nkY7prTsUCfMFCTDsRuhLhxu3Ku
   DJ1uKoTsBixOBKYKhKe3vkT5bWzroUTahGx+95DH/Pw02++eqAdqelvTR
   9Uu7uYG7z6O+HQ6UZFYp2pJXPx6Stw8oXaQ+l06W61Fz8uSatYEEkvXcr
   cgRsuFjxkVpMcL3Iz4k8DU0EkYUbQL18PMOD9i+bN3JemwMyGGUQzEvpt
   OSZNyHnUMe8Kf3smRMduiqvXdxAutPq9mDzVksCcQFxo9J3stsh/YmDD1
   SJmRDTk1rbDExScqTuhP9FrB1t3kTUdjBOoaZG+5QpyZ4FS03MPxV2LZo
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10840"; a="383401598"
X-IronPort-AV: E=Sophos;i="6.03,166,1694761200"; 
   d="scan'208";a="383401598"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2023 13:14:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10840"; a="696897787"
X-IronPort-AV: E=Sophos;i="6.03,166,1694761200"; 
   d="scan'208";a="696897787"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2023 13:14:46 -0700
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
Subject: [RFC PATCH v2 2/6] KVM: selftests: Add negative test cases for punch hole for guest_memfd()
Date:   Thu, 21 Sep 2023 13:14:35 -0700
Message-Id: <bf9094185cc93cc1ff0efac0349258cf68046c99.1695327124.git.isaku.yamahata@intel.com>
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

Add test cases to check for punch hole of guest_memfd to reject unaligned
offset or size.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 .../testing/selftests/kvm/guest_memfd_test.c  | 32 +++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 75073645aaa1..d5b4bfcdc3fe 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -91,6 +91,37 @@ static void test_fallocate(int fd, size_t page_size, size_t total_size)
 	TEST_ASSERT(!ret, "fallocate to restore punched hole should succeed");
 }
 
+/* Negative tests */
+static void test_fallocate_fail(int fd, size_t page_size, size_t total_size)
+{
+	struct {
+		off_t offset;
+		off_t len;
+	} cases[] = {
+		{0, 1},
+		{0, page_size - 1},
+		{0, page_size + 1},
+
+		{1, 1},
+		{1, page_size - 1},
+		{1, page_size},
+		{1, page_size + 1},
+
+		{page_size, 1},
+		{page_size, page_size - 1},
+		{page_size, page_size + 1},
+	};
+	int ret;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(cases); i++) {
+		ret = fallocate(fd, FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE,
+				cases[i].offset, cases[i].len);
+		TEST_ASSERT(ret == -1,
+			    "fallocate(PUNCH_HOLE) with unaligned offset and/or size should fail");
+	}
+}
+
 static void test_create_guest_memfd_invalid(struct kvm_vm *vm)
 {
 	uint64_t valid_flags = 0;
@@ -160,6 +191,7 @@ int main(int argc, char *argv[])
 	test_mmap(fd, page_size);
 	test_file_size(fd, page_size, total_size);
 	test_fallocate(fd, page_size, total_size);
+	test_fallocate_fail(fd, page_size, total_size);
 
 	close(fd);
 }
-- 
2.25.1

