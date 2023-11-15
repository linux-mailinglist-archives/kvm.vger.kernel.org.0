Return-Path: <kvm+bounces-1736-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C6577EBD7F
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 08:17:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 44ECEB20B95
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 07:17:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2F278F67;
	Wed, 15 Nov 2023 07:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mTKTIFr0"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73FB68C1B
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 07:16:41 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6B85EB
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 23:16:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700032598; x=1731568598;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=d8m/K4WT12hdYcKmOmyFhEUCYXWBDBTjG/rXpGvxHMU=;
  b=mTKTIFr0BFBw+3j0WSK/prPEKA5yk7J261e8o95mhqxgYgSldTsJaYkO
   tOFey2F5o4kWpVwpyArJcNpepE/JPvnXpyNGjp5FCmCMaFQhC1FijpcoA
   ixW2+dsDgaIXqxv0dPXZCiRgvN8dCu0b4YKjXa5f+kYR1Uzg72ovUrOn3
   AquDWfqpVa/hrQlW3s627E/SD4LxMsIvGHYgFhIqxwiDN+Rf16xsCXyUJ
   +E5oe+k98tJz4FGZ++611Y9n6OCCX+w47oCeNhRKEyh8TtdaHGI9nCV6g
   ZDQZrbfWk/Z9q/ygAY7B0UDi+f3zo5PuXUOxDuldzJVtZxuUycJx92sM4
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="390622256"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="390622256"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2023 23:16:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="714797186"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="714797186"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orsmga003.jf.intel.com with ESMTP; 14 Nov 2023 23:16:30 -0800
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
Subject: [PATCH v3 09/70] physmem: Introduce ram_block_convert_range() for page conversion
Date: Wed, 15 Nov 2023 02:14:18 -0500
Message-Id: <20231115071519.2864957-10-xiaoyao.li@intel.com>
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

It's used for discarding opposite memory after memory conversion, for
confidential guest.

When page is converted from shared to private, the original shared
memory can be discarded via ram_block_discard_range();

When page is converted from private to shared, the original private
memory is back'ed by guest_memfd. Introduce
ram_block_discard_guest_memfd_range() for discarding memory in
guest_memfd.

Originally-from: Isaku Yamahata <isaku.yamahata@intel.com>
Codeveloped-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 include/exec/cpu-common.h |  2 ++
 system/physmem.c          | 50 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 52 insertions(+)

diff --git a/include/exec/cpu-common.h b/include/exec/cpu-common.h
index 41115d891940..de728a18eef2 100644
--- a/include/exec/cpu-common.h
+++ b/include/exec/cpu-common.h
@@ -175,6 +175,8 @@ typedef int (RAMBlockIterFunc)(RAMBlock *rb, void *opaque);
 
 int qemu_ram_foreach_block(RAMBlockIterFunc func, void *opaque);
 int ram_block_discard_range(RAMBlock *rb, uint64_t start, size_t length);
+int ram_block_convert_range(RAMBlock *rb, uint64_t start, size_t length,
+                            bool shared_to_private);
 
 #endif
 
diff --git a/system/physmem.c b/system/physmem.c
index ddfecddefcd6..cd6008fa09ad 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -3641,6 +3641,29 @@ err:
     return ret;
 }
 
+static int ram_block_discard_guest_memfd_range(RAMBlock *rb, uint64_t start,
+                                               size_t length)
+{
+    int ret = -1;
+
+#ifdef CONFIG_FALLOCATE_PUNCH_HOLE
+    ret = fallocate(rb->guest_memfd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
+                    start, length);
+
+    if (ret) {
+        ret = -errno;
+        error_report("%s: Failed to fallocate %s:%" PRIx64 " +%zx (%d)",
+                     __func__, rb->idstr, start, length, ret);
+    }
+#else
+    ret = -ENOSYS;
+    error_report("%s: fallocate not available %s:%" PRIx64 " +%zx (%d)",
+                 __func__, rb->idstr, start, length, ret);
+#endif
+
+    return ret;
+}
+
 bool ramblock_is_pmem(RAMBlock *rb)
 {
     return rb->flags & RAM_PMEM;
@@ -3828,3 +3851,30 @@ bool ram_block_discard_is_required(void)
     return qatomic_read(&ram_block_discard_required_cnt) ||
            qatomic_read(&ram_block_coordinated_discard_required_cnt);
 }
+
+int ram_block_convert_range(RAMBlock *rb, uint64_t start, size_t length,
+                            bool shared_to_private)
+{
+    if (!rb || rb->guest_memfd < 0) {
+        return -1;
+    }
+
+    if (!QEMU_PTR_IS_ALIGNED(start, qemu_host_page_size) ||
+        !QEMU_PTR_IS_ALIGNED(length, qemu_host_page_size)) {
+        return -1;
+    }
+
+    if (!length) {
+        return -1;
+    }
+
+    if (start + length > rb->max_length) {
+        return -1;
+    }
+
+    if (shared_to_private) {
+        return ram_block_discard_range(rb, start, length);
+    } else {
+        return ram_block_discard_guest_memfd_range(rb, start, length);
+    }
+}
-- 
2.34.1


