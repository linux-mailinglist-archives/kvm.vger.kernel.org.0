Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B87479F91D
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 05:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234482AbjINDwi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 23:52:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234518AbjINDwg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 23:52:36 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17FC999
        for <kvm@vger.kernel.org>; Wed, 13 Sep 2023 20:52:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694663552; x=1726199552;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=P7JD5Z/Zea9/ImjYPBZjZe+vU1JZG61vgXwgTLUb5Js=;
  b=g2D/R85zhhIMkPTEeRC7h9Sdl+FtU6IeP6v2fK0yrDR3iyDOCBis5w7Z
   zDX0npoIcP/0MqlxaTZfw99EBuS2cTE5RAFHgO6qpIA5+Gh78vDnVDFIF
   0eON0ClbcPUSPBiyLj4NuNIS+rXZ/jZ7rZpNkkdIH9VVHspZ1TdSDWl34
   ydeB+mpNLNpIrJHxnIVXL7f3IH7qeRbtz4oA04U5fQC7j7yZS08LBdKuO
   hhwvolvCSqK+IrUq+WMUqhUsDR/IgpO/kpks7zhUN2kMkaK+v2hzdhmly
   epP8FkwpqgBKZRG1GBuoiPgEldXgd9fAp/Lzjc3RCv6HIU2dBtTYQFwAz
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="381528501"
X-IronPort-AV: E=Sophos;i="6.02,144,1688454000"; 
   d="scan'208";a="381528501"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 20:52:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="814500659"
X-IronPort-AV: E=Sophos;i="6.02,144,1688454000"; 
   d="scan'208";a="814500659"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmsmga004.fm.intel.com with ESMTP; 13 Sep 2023 20:52:27 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Peter Xu <peterx@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, xiaoyao.li@intel.com,
        Michael Roth <michael.roth@amd.com>, isaku.yamahata@gmail.com,
        Sean Christopherson <seanjc@google.com>,
        Claudio Fontana <cfontana@suse.de>
Subject: [RFC PATCH v2 15/21] physmem: extract ram_block_discard_range_fd() from ram_block_discard_range()
Date:   Wed, 13 Sep 2023 23:51:11 -0400
Message-Id: <20230914035117.3285885-16-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230914035117.3285885-1-xiaoyao.li@intel.com>
References: <20230914035117.3285885-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Extract the alignment check and sanity check out from
ram_block_discard_range() into a seperate function
ram_block_discard_range_fd(), which can be passed with an explicit fd as
input parameter.

ram_block_discard_range_fd() can be used to discard private memory range
from gmem fd with later patch. When doing private memory <-> shared
memory conversion, it requires 4KB alignment instead of
RamBlock.page_size.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 softmmu/physmem.c | 192 ++++++++++++++++++++++++----------------------
 1 file changed, 100 insertions(+), 92 deletions(-)

diff --git a/softmmu/physmem.c b/softmmu/physmem.c
index 34d580ec0d39..6ee6bc794f44 100644
--- a/softmmu/physmem.c
+++ b/softmmu/physmem.c
@@ -3425,117 +3425,125 @@ int qemu_ram_foreach_block(RAMBlockIterFunc func, void *opaque)
     return ret;
 }
 
+static int ram_block_discard_range_fd(RAMBlock *rb, uint64_t start,
+                                      size_t length, int fd)
+{
+    uint8_t *host_startaddr = rb->host + start;
+    bool need_madvise, need_fallocate;
+    int ret = -1;
+
+    errno = ENOTSUP; /* If we are missing MADVISE etc */
+
+    /* The logic here is messy;
+     *    madvise DONTNEED fails for hugepages
+     *    fallocate works on hugepages and shmem
+     *    shared anonymous memory requires madvise REMOVE
+     */
+    need_madvise = (rb->page_size == qemu_host_page_size) && (rb->fd == fd);
+    need_fallocate = fd != -1;
+
+    if (need_fallocate) {
+        /* For a file, this causes the area of the file to be zero'd
+         * if read, and for hugetlbfs also causes it to be unmapped
+         * so a userfault will trigger.
+         */
+#ifdef CONFIG_FALLOCATE_PUNCH_HOLE
+        /*
+         * We'll discard data from the actual file, even though we only
+         * have a MAP_PRIVATE mapping, possibly messing with other
+         * MAP_PRIVATE/MAP_SHARED mappings. There is no easy way to
+         * change that behavior whithout violating the promised
+         * semantics of ram_block_discard_range().
+         *
+         * Only warn, because it works as long as nobody else uses that
+         * file.
+         */
+        if (!qemu_ram_is_shared(rb)) {
+            warn_report_once("%s: Discarding RAM"
+                                " in private file mappings is possibly"
+                                " dangerous, because it will modify the"
+                                " underlying file and will affect other"
+                                " users of the file", __func__);
+        }
+
+        ret = fallocate(fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
+                        start, length);
+        if (ret) {
+            ret = -errno;
+            error_report("%s: Failed to fallocate %s:%" PRIx64 " +%zx (%d)",
+                            __func__, rb->idstr, start, length, ret);
+            return ret;
+        }
+#else
+        ret = -ENOSYS;
+        error_report("%s: fallocate not available/file "
+                     "%s:%" PRIx64 " +%zx (%d)",
+                     __func__, rb->idstr, start, length, ret);
+        return ret;
+#endif
+    }
+
+    if (need_madvise) {
+        /* For normal RAM this causes it to be unmapped,
+         * for shared memory it causes the local mapping to disappear
+         * and to fall back on the file contents (which we just
+         * fallocate'd away).
+         */
+#if defined(CONFIG_MADVISE)
+        if (qemu_ram_is_shared(rb) && fd < 0) {
+            ret = madvise(host_startaddr, length, QEMU_MADV_REMOVE);
+        } else {
+            ret = madvise(host_startaddr, length, QEMU_MADV_DONTNEED);
+        }
+        if (ret) {
+            ret = -errno;
+            error_report("%s: Failed to discard range %s:%" PRIx64 " +%zx (%d)",
+                         __func__, rb->idstr, start, length, ret);
+            return ret;
+        }
+#else
+        ret = -ENOSYS;
+        error_report("%s: MADVISE not available %s:%" PRIx64 " +%zx (%d)",
+                        __func__, rb->idstr, start, length, ret);
+        return ret;
+#endif
+    }
+
+    trace_ram_block_discard_range(rb->idstr, host_startaddr, length,
+                                  need_madvise, need_fallocate, ret);
+    return ret;
+}
+
 /*
  * Unmap pages of memory from start to start+length such that
  * they a) read as 0, b) Trigger whatever fault mechanism
  * the OS provides for postcopy.
+ *
  * The pages must be unmapped by the end of the function.
- * Returns: 0 on success, none-0 on failure
- *
+ * Returns: 0 on success, none-0 on failure.
  */
 int ram_block_discard_range(RAMBlock *rb, uint64_t start, size_t length)
 {
-    int ret = -1;
-
     uint8_t *host_startaddr = rb->host + start;
 
     if (!QEMU_PTR_IS_ALIGNED(host_startaddr, rb->page_size)) {
         error_report("%s: Unaligned start address: %p",
                      __func__, host_startaddr);
-        goto err;
+        return -1;
     }
 
-    if ((start + length) <= rb->max_length) {
-        bool need_madvise, need_fallocate;
-        if (!QEMU_IS_ALIGNED(length, rb->page_size)) {
-            error_report("%s: Unaligned length: %zx", __func__, length);
-            goto err;
-        }
-
-        errno = ENOTSUP; /* If we are missing MADVISE etc */
-
-        /* The logic here is messy;
-         *    madvise DONTNEED fails for hugepages
-         *    fallocate works on hugepages and shmem
-         *    shared anonymous memory requires madvise REMOVE
-         */
-        need_madvise = (rb->page_size == qemu_host_page_size);
-        need_fallocate = rb->fd != -1;
-        if (need_fallocate) {
-            /* For a file, this causes the area of the file to be zero'd
-             * if read, and for hugetlbfs also causes it to be unmapped
-             * so a userfault will trigger.
-             */
-#ifdef CONFIG_FALLOCATE_PUNCH_HOLE
-            /*
-             * We'll discard data from the actual file, even though we only
-             * have a MAP_PRIVATE mapping, possibly messing with other
-             * MAP_PRIVATE/MAP_SHARED mappings. There is no easy way to
-             * change that behavior whithout violating the promised
-             * semantics of ram_block_discard_range().
-             *
-             * Only warn, because it works as long as nobody else uses that
-             * file.
-             */
-            if (!qemu_ram_is_shared(rb)) {
-                warn_report_once("%s: Discarding RAM"
-                                 " in private file mappings is possibly"
-                                 " dangerous, because it will modify the"
-                                 " underlying file and will affect other"
-                                 " users of the file", __func__);
-            }
-
-            ret = fallocate(rb->fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
-                            start, length);
-            if (ret) {
-                ret = -errno;
-                error_report("%s: Failed to fallocate %s:%" PRIx64 " +%zx (%d)",
-                             __func__, rb->idstr, start, length, ret);
-                goto err;
-            }
-#else
-            ret = -ENOSYS;
-            error_report("%s: fallocate not available/file"
-                         "%s:%" PRIx64 " +%zx (%d)",
-                         __func__, rb->idstr, start, length, ret);
-            goto err;
-#endif
-        }
-        if (need_madvise) {
-            /* For normal RAM this causes it to be unmapped,
-             * for shared memory it causes the local mapping to disappear
-             * and to fall back on the file contents (which we just
-             * fallocate'd away).
-             */
-#if defined(CONFIG_MADVISE)
-            if (qemu_ram_is_shared(rb) && rb->fd < 0) {
-                ret = madvise(host_startaddr, length, QEMU_MADV_REMOVE);
-            } else {
-                ret = madvise(host_startaddr, length, QEMU_MADV_DONTNEED);
-            }
-            if (ret) {
-                ret = -errno;
-                error_report("%s: Failed to discard range "
-                             "%s:%" PRIx64 " +%zx (%d)",
-                             __func__, rb->idstr, start, length, ret);
-                goto err;
-            }
-#else
-            ret = -ENOSYS;
-            error_report("%s: MADVISE not available %s:%" PRIx64 " +%zx (%d)",
-                         __func__, rb->idstr, start, length, ret);
-            goto err;
-#endif
-        }
-        trace_ram_block_discard_range(rb->idstr, host_startaddr, length,
-                                      need_madvise, need_fallocate, ret);
-    } else {
+    if ((start + length) > rb->max_length) {
         error_report("%s: Overrun block '%s' (%" PRIu64 "/%zx/" RAM_ADDR_FMT")",
                      __func__, rb->idstr, start, length, rb->max_length);
+        return -1;
     }
 
-err:
-    return ret;
+    if (!QEMU_IS_ALIGNED(length, rb->page_size)) {
+        error_report("%s: Unaligned length: %zx", __func__, length);
+        return -1;
+    }
+
+    return ram_block_discard_range_fd(rb, start, length, rb->fd);
 }
 
 bool ramblock_is_pmem(RAMBlock *rb)
-- 
2.34.1

