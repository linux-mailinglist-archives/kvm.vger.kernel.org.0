Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF8579F91E
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 05:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234596AbjINDwl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 23:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234251AbjINDwk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 23:52:40 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56CF61BE3
        for <kvm@vger.kernel.org>; Wed, 13 Sep 2023 20:52:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694663556; x=1726199556;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=C1mGXkusPnhkfU37hQJOr1iYXe1QHqcmTFhsRyRYjTI=;
  b=i9Mz6Ke5z6EIbSnEWzWfM7KZll62AOokFIHMZv8DeTgybwr1ddYx1YZz
   Qz1caS3V2x0+RO/qRkcS1CrtJl6CrA8caN0QTytf5dl+1WKxTXkvZ1KMq
   9syTg7dWDWx5eCXr5I6mU7yOj12ouljOtYgsIw9T+V4lYJKvzxyE0Jg3n
   VIRIhMCee3AbssaAjspQR5IGuWOgv67q03uJsmNRG60hdKoCJQOq+p8Wy
   ImX3FoKrAS/XkOcpH1RDx0RCj/6DtLF6eYHiFZn9owXK0XMP4BW4G+pRT
   oW/alwE6yXPbpM8LFdcpl81cOTrtFOkEXnDgcZNzZKZnUYd9w5ua04Spt
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="381528511"
X-IronPort-AV: E=Sophos;i="6.02,144,1688454000"; 
   d="scan'208";a="381528511"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 20:52:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="814500677"
X-IronPort-AV: E=Sophos;i="6.02,144,1688454000"; 
   d="scan'208";a="814500677"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmsmga004.fm.intel.com with ESMTP; 13 Sep 2023 20:52:31 -0700
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
Subject: [RFC PATCH v2 16/21] physmem: Introduce ram_block_convert_range()
Date:   Wed, 13 Sep 2023 23:51:12 -0400
Message-Id: <20230914035117.3285885-17-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230914035117.3285885-1-xiaoyao.li@intel.com>
References: <20230914035117.3285885-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It's used for discarding oppsite memory after memory conversion to
shared/private.

Note, private-shared page conversion is done at 4KB granularity. Don't
check alignment with rb->page_size, instead qemu_host_page_size, which
is 4K.

Originally-from: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 include/exec/cpu-common.h |  2 ++
 softmmu/physmem.c         | 36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+)

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
index 6ee6bc794f44..dab3247d461c 100644
--- a/softmmu/physmem.c
+++ b/softmmu/physmem.c
@@ -3733,3 +3733,39 @@ bool ram_block_discard_is_required(void)
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
+        void *host_startaddr = rb->host + start;
+
+        if (!QEMU_PTR_IS_ALIGNED(host_startaddr, qemu_host_page_size)) {
+            return -1;
+        }
+        fd = rb->fd;
+    } else {
+        fd = rb->gmem_fd;
+    }
+
+    return ram_block_discard_range_fd(rb, start, length, fd);
+}
-- 
2.34.1

