Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 127BF769C5C
	for <lists+kvm@lfdr.de>; Mon, 31 Jul 2023 18:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233313AbjGaQ0F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 12:26:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233331AbjGaQZ7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 12:25:59 -0400
Received: from mgamail.intel.com (unknown [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 819A61996
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 09:25:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690820743; x=1722356743;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2F3BNnQpA+emsmbBfMLeFksuw4ODRYROEr7ulTUvnvs=;
  b=PjRxEv873NQpIBd3mCkYAc6poyW7GjYsUTAu+eLOYlQd8LCW/KB4gLzW
   gx+KNhOe+BK7xia+v0oVd7QpzFMHfkOxFJ881HHAPWUFFg53trq09ZdVP
   HuZ6URaPWuYGq+Vwi/WbeeAtCvAwRjVAwfoxJ7h5Q58PpZvAyB+zE3g2a
   QOks7u2VMSayT6XuTmmLDoVJSttq6Ym5Wq+QDp82gHywVVGxgwWxHX28J
   eZZNNqSYPvlyqBjz+3g9WFpHxgLMCh49eGe341gyl68ZgGXUJBnDuAIfc
   hoJMFX87pxu68oASVyfJ4JSF8fvhRXqhIv8KoXj/opPFukje1WSkbC7LU
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="353993510"
X-IronPort-AV: E=Sophos;i="6.01,244,1684825200"; 
   d="scan'208";a="353993510"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2023 09:25:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="757984276"
X-IronPort-AV: E=Sophos;i="6.01,244,1684825200"; 
   d="scan'208";a="757984276"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.46])
  by orsmga008.jf.intel.com with ESMTP; 31 Jul 2023 09:25:38 -0700
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
Subject: [RFC PATCH 11/19] kvm/memory: Introduce the infrastructure to set the default shared/private value
Date:   Mon, 31 Jul 2023 12:21:53 -0400
Message-Id: <20230731162201.271114-12-xiaoyao.li@intel.com>
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

Introduce new flags for MemoryRegion to indicate the default attribute,
private or not. And update the attribute if default private.

Originated-from: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 accel/kvm/kvm-all.c   | 10 ++++++++++
 include/exec/memory.h |  6 ++++++
 softmmu/memory.c      | 13 +++++++++++++
 3 files changed, 29 insertions(+)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 6dd22fa4fd6f..f9b5050b8885 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -1487,6 +1487,16 @@ static void kvm_set_phys_mem(KVMMemoryListener *kml,
                     strerror(-err));
             abort();
         }
+
+        if (memory_region_is_default_private(mr)) {
+            err = kvm_set_memory_attributes_private(start_addr, slot_size);
+            if (err) {
+                error_report("%s: failed to set memory attribute private: %s\n",
+                             __func__, strerror(-err));
+                exit(1);
+            }
+        }
+
         start_addr += slot_size;
         ram_start_offset += slot_size;
         ram += slot_size;
diff --git a/include/exec/memory.h b/include/exec/memory.h
index ddf0e14970b0..759f797b6acd 100644
--- a/include/exec/memory.h
+++ b/include/exec/memory.h
@@ -235,6 +235,9 @@ typedef struct IOMMUTLBEvent {
 /* RAM is an mmap-ed named file */
 #define RAM_NAMED_FILE (1 << 9)
 
+/* RAM is default private */
+#define RAM_DEFAULT_PRIVATE     (1 << 10)
+
 static inline void iommu_notifier_init(IOMMUNotifier *n, IOMMUNotify fn,
                                        IOMMUNotifierFlag flags,
                                        hwaddr start, hwaddr end,
@@ -1689,6 +1692,9 @@ bool memory_region_is_protected(MemoryRegion *mr);
  */
 bool memory_region_can_be_private(MemoryRegion *mr);
 
+void memory_region_set_default_private(MemoryRegion *mr);
+bool memory_region_is_default_private(MemoryRegion *mr);
+
 /**
  * memory_region_get_iommu: check whether a memory region is an iommu
  *
diff --git a/softmmu/memory.c b/softmmu/memory.c
index 336c76ede660..af6aa3c1e3c9 100644
--- a/softmmu/memory.c
+++ b/softmmu/memory.c
@@ -1860,6 +1860,19 @@ bool memory_region_can_be_private(MemoryRegion *mr)
     return mr->ram_block && mr->ram_block->gmem_fd >= 0;
 }
 
+bool memory_region_is_default_private(MemoryRegion *mr)
+{
+    return mr->ram_block && mr->ram_block->gmem_fd >= 0 &&
+        (mr->ram_block->flags & RAM_DEFAULT_PRIVATE);
+}
+
+void memory_region_set_default_private(MemoryRegion *mr)
+{
+    if (mr->ram_block && mr->ram_block->gmem_fd >= 0) {
+        mr->ram_block->flags |= RAM_DEFAULT_PRIVATE;
+    }
+}
+
 uint8_t memory_region_get_dirty_log_mask(MemoryRegion *mr)
 {
     uint8_t mask = mr->dirty_log_mask;
-- 
2.34.1

