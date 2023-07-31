Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31198769C62
	for <lists+kvm@lfdr.de>; Mon, 31 Jul 2023 18:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233332AbjGaQ02 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 12:26:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233346AbjGaQ0W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 12:26:22 -0400
Received: from mgamail.intel.com (unknown [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B222E1BF2
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 09:25:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690820759; x=1722356759;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/dXf+igjdEHFljunA6/Y/7Okg+auCCSxG402x9zxZbs=;
  b=fCaeEsrk1xdkkG8B3/IebgjbEveTncquYJ08OKFsZIVK8FxgapUrkUKF
   vm1vPaIErmsQudY7SxCFCndCT+s1Gdk3247XwA20oCaZ36WZFVE0FYiq0
   EeyHjgDS6wARsn/pivR5I7OfXIeLBtwbO8Qx5LSWz8bMUpSihsMW3vbrh
   uBhiPaDBiSGu7RsabLj1AwZpAoai8/eLr2IKVQtaP5riyQfuFf+2jwX3/
   FA2PFi1ss4IXGgr65yDVtppu0dqj23VEIZ7JsAC94o56bZe/RuDGEZdFY
   3r9Wb6cGTDX1wgNOeaAcYlwX+3DMCgwaLitL82fvVx9Lmk5erBhL1VVmB
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="353993557"
X-IronPort-AV: E=Sophos;i="6.01,244,1684825200"; 
   d="scan'208";a="353993557"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2023 09:25:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="757984310"
X-IronPort-AV: E=Sophos;i="6.01,244,1684825200"; 
   d="scan'208";a="757984310"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.46])
  by orsmga008.jf.intel.com with ESMTP; 31 Jul 2023 09:25:52 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Hildenbrand <david@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     Markus Armbruster <armbru@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Peter Xu <peterx@redhat.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Michael Roth <michael.roth@amd.com>, isaku.yamahata@gmail.com,
        xiaoyao.li@intel.com, qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: [RFC PATCH 14/19] physmem: Add ram_block_convert_range
Date:   Mon, 31 Jul 2023 12:21:56 -0400
Message-Id: <20230731162201.271114-15-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230731162201.271114-1-xiaoyao.li@intel.com>
References: <20230731162201.271114-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Chao Peng <chao.p.peng@linux.intel.com>

This new routine adds support for memory conversion between
shared/private memory for gmem fd based private ram_block.

Signed-off-by: Chao Peng <chao.p.peng@linux.intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 include/exec/cpu-common.h |  2 ++
 softmmu/physmem.c         | 61 ++++++++++++++++++++++++++++++---------
 2 files changed, 50 insertions(+), 13 deletions(-)

diff --git a/include/exec/cpu-common.h b/include/exec/cpu-common.h
index 87dc9a752c9a..558684b9f246 100644
--- a/include/exec/cpu-common.h
+++ b/include/exec/cpu-common.h
@@ -157,6 +157,8 @@ typedef int (RAMBlockIterFunc)(RAMBlock *rb, void *opaque);
 
 int qemu_ram_foreach_block(RAMBlockIterFunc func, void *opaque);
 int ram_block_discard_range(RAMBlock *rb, uint64_t start, size_t length);
+int ram_block_convert_range(RAMBlock *rb, uint64_t start, size_t length,
+                            bool shared_to_private);
 
 #endif
 
diff --git a/softmmu/physmem.c b/softmmu/physmem.c
index 05c981e5c18e..2acc8bee5b33 100644
--- a/softmmu/physmem.c
+++ b/softmmu/physmem.c
@@ -3415,15 +3415,9 @@ int qemu_ram_foreach_block(RAMBlockIterFunc func, void *opaque)
     return ret;
 }
 
-/*
- * Unmap pages of memory from start to start+length such that
- * they a) read as 0, b) Trigger whatever fault mechanism
- * the OS provides for postcopy.
- * The pages must be unmapped by the end of the function.
- * Returns: 0 on success, none-0 on failure
- *
- */
-int ram_block_discard_range(RAMBlock *rb, uint64_t start, size_t length)
+static int ram_block_discard_range_fd(RAMBlock *rb, uint64_t start,
+                                      size_t length, int fd)
+
 {
     int ret = -1;
 
@@ -3449,8 +3443,8 @@ int ram_block_discard_range(RAMBlock *rb, uint64_t start, size_t length)
          *    fallocate works on hugepages and shmem
          *    shared anonymous memory requires madvise REMOVE
          */
-        need_madvise = (rb->page_size == qemu_host_page_size);
-        need_fallocate = rb->fd != -1;
+        need_madvise = (rb->page_size == qemu_host_page_size) && (rb->fd == fd);
+        need_fallocate = fd != -1;
         if (need_fallocate) {
             /* For a file, this causes the area of the file to be zero'd
              * if read, and for hugetlbfs also causes it to be unmapped
@@ -3475,7 +3469,7 @@ int ram_block_discard_range(RAMBlock *rb, uint64_t start, size_t length)
                                  " users of the file", __func__);
             }
 
-            ret = fallocate(rb->fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
+            ret = fallocate(fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
                             start, length);
             if (ret) {
                 ret = -errno;
@@ -3498,7 +3492,7 @@ int ram_block_discard_range(RAMBlock *rb, uint64_t start, size_t length)
              * fallocate'd away).
              */
 #if defined(CONFIG_MADVISE)
-            if (qemu_ram_is_shared(rb) && rb->fd < 0) {
+            if (qemu_ram_is_shared(rb) && fd < 0) {
                 ret = madvise(host_startaddr, length, QEMU_MADV_REMOVE);
             } else {
                 ret = madvise(host_startaddr, length, QEMU_MADV_DONTNEED);
@@ -3528,6 +3522,20 @@ err:
     return ret;
 }
 
+/*
+ * Unmap pages of memory from start to start+length such that
+ * they a) read as 0, b) Trigger whatever fault mechanism
+ * the OS provides for postcopy.
+ *
+ * The pages must be unmapped by the end of the function.
+ * Returns: 0 on success, none-0 on failure.
+ */
+int ram_block_discard_range(RAMBlock *rb, uint64_t start, size_t length)
+{
+    return ram_block_discard_range_fd(rb, start, length, rb->fd);
+}
+
+
 bool ramblock_is_pmem(RAMBlock *rb)
 {
     return rb->flags & RAM_PMEM;
@@ -3715,3 +3723,30 @@ bool ram_block_discard_is_required(void)
     return qatomic_read(&ram_block_discard_required_cnt) ||
            qatomic_read(&ram_block_coordinated_discard_required_cnt);
 }
+
+int ram_block_convert_range(RAMBlock *rb, uint64_t start, size_t length,
+                            bool shared_to_private)
+{
+    int fd;
+
+    if (!rb || rb->gmem_fd < 0) {
+        return -1;
+    }
+
+    if (!QEMU_PTR_IS_ALIGNED(start, rb->page_size) ||
+        !QEMU_PTR_IS_ALIGNED(length, rb->page_size)) {
+        return -1;
+    }
+
+    if (length > rb->max_length) {
+        return -1;
+    }
+
+    if (shared_to_private) {
+        fd = rb->fd;
+    } else {
+        fd = rb->gmem_fd;
+    }
+
+    return ram_block_discard_range_fd(rb, start, length, fd);
+}
-- 
2.34.1

