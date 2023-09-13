Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70A8A79E53C
	for <lists+kvm@lfdr.de>; Wed, 13 Sep 2023 12:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239782AbjIMKtZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 06:49:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239734AbjIMKtR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 06:49:17 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05E6019AF;
        Wed, 13 Sep 2023 03:49:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694602152; x=1726138152;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xwzNgHMxNVvtmveSbOCZiym0KA+uWinftiYSWsEC+Yk=;
  b=PRfT0uWndEFuxpeVjNZFHfLshIdp4OrlJYwm/d8i5B9k+BKzyzN5h0EZ
   +5d2VZdgP1zk6mLJ7cAflFJZzWHJTfFqlWIKMJPzihwBl4aJ/a52/G2pg
   eyKW6Lz3WOIf5Jci9HjnHy+ksbtSusSEgCPtnCB5bNz1fTnskVOm02zHJ
   UVxA62UC1ZNeijbGdIPGfPuxo66Pm1we6Cz8f8krpE7F6bBiU0nWu7UzF
   P+nd+CYILi0+imGTCNHSWSJO+XqvfXOeUE9vjY5ACo5FKkY4wZiN/mtTZ
   fjVkyb3LyeJHqP8CGt3qU4qp+80y72xya2iDP1xk6Q3ZAG+V+oS6SbeEf
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10831"; a="377537900"
X-IronPort-AV: E=Sophos;i="6.02,143,1688454000"; 
   d="scan'208";a="377537900"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 03:49:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10831"; a="809635597"
X-IronPort-AV: E=Sophos;i="6.02,143,1688454000"; 
   d="scan'208";a="809635597"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 03:49:12 -0700
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
Subject: [RFC PATCH 5/6] KVM: selftests: Add selftest for guest_memfd() fibmap
Date:   Wed, 13 Sep 2023 03:48:54 -0700
Message-Id: <dc081ebc9b35f52a95cfa67a1c71781198e3dad5.1694599703.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1694599703.git.isaku.yamahata@intel.com>
References: <cover.1694599703.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 .../testing/selftests/kvm/guest_memfd_test.c  | 45 +++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 4d2b110ab0d6..c20b4a14e9c7 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -10,6 +10,7 @@
 #include "kvm_util_base.h"
 #include <linux/bitmap.h>
 #include <linux/falloc.h>
+#include <linux/fs.h>
 #include <sys/mman.h>
 #include <sys/types.h>
 #include <sys/stat.h>
@@ -91,6 +92,49 @@ static void test_fallocate(int fd, size_t page_size, size_t total_size)
 	TEST_ASSERT(!ret, "fallocate to restore punched hole should succeed");
 }
 
+static void test_fibmap(int fd, size_t page_size, size_t total_size)
+{
+	int ret;
+	int b;
+	int i;
+
+	/* Make while file unallocated as known initial state */
+	ret = fallocate(fd, FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE,
+			0, total_size);
+	TEST_ASSERT(!ret, "fallocate(PUNCH_HOLE) at while file should succeed");
+
+	for (i = 0; i < total_size / page_size; i++) {
+		b = i;
+		ret = ioctl(fd, FIBMAP, &b);
+		if (ret == -EINVAL) {
+			print_skip("Set CONFIG_KVM_GENERIC_PRIVATE_MEM_BMAP=y. bmap test. ");
+			return;
+		}
+		TEST_ASSERT(!ret, "ioctl(FIBMAP) should succeed");
+		TEST_ASSERT(!b, "ioctl(FIBMAP) should return zero 0x%x", b);
+	}
+
+	ret = fallocate(fd, FALLOC_FL_KEEP_SIZE, page_size, page_size * 2);
+	TEST_ASSERT(!ret, "fallocate beginning at page_size should succeed");
+
+	for (i = 0; i < total_size / page_size; i++) {
+		b = i;
+		ret = ioctl(fd, FIBMAP, &b);
+		if (ret == -EINVAL) {
+			print_skip("Set CONFIG_KVM_GENERIC_PRIVATE_MEM_BMAP=y. bmap test. ");
+			return;
+		}
+		TEST_ASSERT(!ret, "ioctl(FIBMAP) should succeed");
+
+		if (i == 1 || i == 2) {
+			TEST_ASSERT(b, "ioctl(FIBMAP) should return non-zero 0x%x", b);
+		} else {
+			TEST_ASSERT(!b, "ioctl(FIBMAP) should return non-zero, 0x%x", b);
+		}
+	}
+
+}
+
 static void test_create_guest_memfd_invalid(struct kvm_vm *vm)
 {
 	uint64_t valid_flags = 0;
@@ -158,6 +202,7 @@ int main(int argc, char *argv[])
 	test_mmap(fd, page_size);
 	test_file_size(fd, page_size, total_size);
 	test_fallocate(fd, page_size, total_size);
+	test_fibmap(fd, page_size, total_size);
 
 	close(fd);
 }
-- 
2.25.1

