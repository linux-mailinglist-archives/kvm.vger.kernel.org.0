Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5A0C79F91A
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 05:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234471AbjINDw1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 23:52:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234552AbjINDwY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 23:52:24 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A5D61BF1
        for <kvm@vger.kernel.org>; Wed, 13 Sep 2023 20:52:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694663538; x=1726199538;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CMoUkTu0XoMVNmvzrbCVHiTlm286z9ePGh8MA6ueE+o=;
  b=ahyRE0PUsn2osuFBnWwzNZzEjilcV9DGtqQLDVd06K6L4YWgGH6OJPOR
   2AXHShpkJbQ2PCpsM4z7VKWZcK7+upAy+WnBYaRKS3oklUWymfD0+jxu7
   jyHQW65W2gSGT3tuY04oq19UGXHe+LIjYOAIV5FP393DbgwwYs1iiS5wh
   akgq7FV5Y+TPJSgztAelUS0Ep9thPlobTtIeOuJbJ5smMhljS5hqu2b2/
   AEFHFi+k77zsbeXX/PrHPwtW56RN5+BAAXZf3cYn/jHHZId+bntBkB2EG
   J0uGLsLbEby2cvXA1OtSrBrNyBIi+DCmXkL6gU7FH5j536AeZ841fFL7J
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="381528469"
X-IronPort-AV: E=Sophos;i="6.02,144,1688454000"; 
   d="scan'208";a="381528469"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 20:52:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="814500617"
X-IronPort-AV: E=Sophos;i="6.02,144,1688454000"; 
   d="scan'208";a="814500617"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmsmga004.fm.intel.com with ESMTP; 13 Sep 2023 20:52:13 -0700
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
Subject: [RFC PATCH v2 12/21] kvm/memory: Introduce the infrastructure to set the default shared/private value
Date:   Wed, 13 Sep 2023 23:51:08 -0400
Message-Id: <20230914035117.3285885-13-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230914035117.3285885-1-xiaoyao.li@intel.com>
References: <20230914035117.3285885-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce new flag RAM_DEFAULT_PRIVATE for RAMBlock. It's used to
indicate the default attribute,  private or not.

Set the RAM range to private explicitly when it's default private.

Originated-from: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 accel/kvm/kvm-all.c   | 10 ++++++++++
 include/exec/memory.h |  6 ++++++
 softmmu/memory.c      | 13 +++++++++++++
 3 files changed, 29 insertions(+)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index eeccc6317fa9..7e32ee83b258 100644
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
index 4b8486ca3632..2c738b5dc420 100644
--- a/include/exec/memory.h
+++ b/include/exec/memory.h
@@ -238,6 +238,9 @@ typedef struct IOMMUTLBEvent {
 /* RAM can be private that has kvm gmem backend */
 #define RAM_KVM_GMEM    (1 << 10)
 
+/* RAM is default private */
+#define RAM_DEFAULT_PRIVATE     (1 << 11)
+
 static inline void iommu_notifier_init(IOMMUNotifier *n, IOMMUNotify fn,
                                        IOMMUNotifierFlag flags,
                                        hwaddr start, hwaddr end,
@@ -1684,6 +1687,9 @@ bool memory_region_is_protected(MemoryRegion *mr);
  */
 bool memory_region_has_gmem_fd(MemoryRegion *mr);
 
+void memory_region_set_default_private(MemoryRegion *mr);
+bool memory_region_is_default_private(MemoryRegion *mr);
+
 /**
  * memory_region_get_iommu: check whether a memory region is an iommu
  *
diff --git a/softmmu/memory.c b/softmmu/memory.c
index e69a5f96d5d1..dc5d0d7703b5 100644
--- a/softmmu/memory.c
+++ b/softmmu/memory.c
@@ -1851,6 +1851,19 @@ bool memory_region_has_gmem_fd(MemoryRegion *mr)
     return mr->ram_block && mr->ram_block->gmem_fd >= 0;
 }
 
+bool memory_region_is_default_private(MemoryRegion *mr)
+{
+    return memory_region_has_gmem_fd(mr) &&
+           (mr->ram_block->flags & RAM_DEFAULT_PRIVATE);
+}
+
+void memory_region_set_default_private(MemoryRegion *mr)
+{
+    if (memory_region_has_gmem_fd(mr)) {
+        mr->ram_block->flags |= RAM_DEFAULT_PRIVATE;
+    }
+}
+
 uint8_t memory_region_get_dirty_log_mask(MemoryRegion *mr)
 {
     uint8_t mask = mr->dirty_log_mask;
-- 
2.34.1

