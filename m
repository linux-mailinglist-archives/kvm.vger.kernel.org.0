Return-Path: <kvm+bounces-1735-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 31BAC7EBD7C
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 08:17:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8535F2813A8
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 07:16:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 999426120;
	Wed, 15 Nov 2023 07:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b1NtTrsj"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1014B5CBD
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 07:16:34 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD63CEB
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 23:16:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700032591; x=1731568591;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6duWlmGjrYjaSy+uawy4hL3f6xwtFIDwK1CCT0SHZFw=;
  b=b1NtTrsjJEL5xZO1JNj3QG2lGGKXFZfhH03BUTRP87Ekqo9zLzmhwEy8
   z15DfNW/UgxXeLbZy/lpORBKz/xrrfLO7tRihVRI8Ux8g58DrDYpwmpUm
   H0xjRNOmgWFsvtubkyJooQVEZmJyPr2nrDf9Tlmg7sKPn3egObwAzwD12
   fUEwlp+cmjROyLoFQXDmgqYBHU4VvdZZg8AAlolMiRiOHM1ypvsn93xOd
   BA2iOPo6BvOz3rgBw1cUhefMQdAq3LZfQRTfEYB2q3qhjU062PZgzT5vu
   yTnNN8lBSAOxESOv19Xa3Cepn7OrO+P4ySSf0dHUc0w3rZDvFOjFsW7eK
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="390622225"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="390622225"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2023 23:16:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="714797093"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="714797093"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orsmga003.jf.intel.com with ESMTP; 14 Nov 2023 23:16:23 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Peter Xu <peterx@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Cornelia Huck <cohuck@redhat.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	xiaoyao.li@intel.com,
	Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Claudio Fontana <cfontana@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>
Subject: [PATCH v3 08/70] physmem: replace function name with __func__ in ram_block_discard_range()
Date: Wed, 15 Nov 2023 02:14:17 -0500
Message-Id: <20231115071519.2864957-9-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231115071519.2864957-1-xiaoyao.li@intel.com>
References: <20231115071519.2864957-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use __func__ to avoid hard-coded function name.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 system/physmem.c | 38 +++++++++++++++++---------------------
 1 file changed, 17 insertions(+), 21 deletions(-)

diff --git a/system/physmem.c b/system/physmem.c
index 8a4e42c7cf60..ddfecddefcd6 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -3533,16 +3533,15 @@ int ram_block_discard_range(RAMBlock *rb, uint64_t start, size_t length)
     uint8_t *host_startaddr = rb->host + start;
 
     if (!QEMU_PTR_IS_ALIGNED(host_startaddr, qemu_host_page_size)) {
-        error_report("ram_block_discard_range: Unaligned start address: %p",
-                     host_startaddr);
+        error_report("%s: Unaligned start address: %p",
+                     __func__, host_startaddr);
         goto err;
     }
 
     if ((start + length) <= rb->max_length) {
         bool need_madvise, need_fallocate;
         if (!QEMU_IS_ALIGNED(length, rb->page_size)) {
-            error_report("ram_block_discard_range: Unaligned length: %zx",
-                         length);
+            error_report("%s: Unaligned length: %zx", __func__, length);
             goto err;
         }
 
@@ -3566,8 +3565,8 @@ int ram_block_discard_range(RAMBlock *rb, uint64_t start, size_t length)
              * proper error message.
              */
             if (rb->flags & RAM_READONLY_FD) {
-                error_report("ram_block_discard_range: Discarding RAM"
-                             " with readonly files is not supported");
+                error_report("%s: Discarding RAM with readonly files is not"
+                             " supported", __func__);
                 goto err;
 
             }
@@ -3582,27 +3581,26 @@ int ram_block_discard_range(RAMBlock *rb, uint64_t start, size_t length)
              * file.
              */
             if (!qemu_ram_is_shared(rb)) {
-                warn_report_once("ram_block_discard_range: Discarding RAM"
+                warn_report_once("%s: Discarding RAM"
                                  " in private file mappings is possibly"
                                  " dangerous, because it will modify the"
                                  " underlying file and will affect other"
-                                 " users of the file");
+                                 " users of the file", __func__);
             }
 
             ret = fallocate(rb->fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
                             start, length);
             if (ret) {
                 ret = -errno;
-                error_report("ram_block_discard_range: Failed to fallocate "
-                             "%s:%" PRIx64 " +%zx (%d)",
-                             rb->idstr, start, length, ret);
+                error_report("%s: Failed to fallocate %s:%" PRIx64 " +%zx (%d)",
+                             __func__, rb->idstr, start, length, ret);
                 goto err;
             }
 #else
             ret = -ENOSYS;
-            error_report("ram_block_discard_range: fallocate not available/file"
+            error_report("%s: fallocate not available/file"
                          "%s:%" PRIx64 " +%zx (%d)",
-                         rb->idstr, start, length, ret);
+                         __func__, rb->idstr, start, length, ret);
             goto err;
 #endif
         }
@@ -3620,25 +3618,23 @@ int ram_block_discard_range(RAMBlock *rb, uint64_t start, size_t length)
             }
             if (ret) {
                 ret = -errno;
-                error_report("ram_block_discard_range: Failed to discard range "
+                error_report("%s: Failed to discard range "
                              "%s:%" PRIx64 " +%zx (%d)",
-                             rb->idstr, start, length, ret);
+                             __func__, rb->idstr, start, length, ret);
                 goto err;
             }
 #else
             ret = -ENOSYS;
-            error_report("ram_block_discard_range: MADVISE not available"
-                         "%s:%" PRIx64 " +%zx (%d)",
-                         rb->idstr, start, length, ret);
+            error_report("%s: MADVISE not available %s:%" PRIx64 " +%zx (%d)",
+                         __func__, rb->idstr, start, length, ret);
             goto err;
 #endif
         }
         trace_ram_block_discard_range(rb->idstr, host_startaddr, length,
                                       need_madvise, need_fallocate, ret);
     } else {
-        error_report("ram_block_discard_range: Overrun block '%s' (%" PRIu64
-                     "/%zx/" RAM_ADDR_FMT")",
-                     rb->idstr, start, length, rb->max_length);
+        error_report("%s: Overrun block '%s' (%" PRIu64 "/%zx/" RAM_ADDR_FMT")",
+                     __func__, rb->idstr, start, length, rb->max_length);
     }
 
 err:
-- 
2.34.1


