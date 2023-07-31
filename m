Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58865769C53
	for <lists+kvm@lfdr.de>; Mon, 31 Jul 2023 18:25:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233163AbjGaQZK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 12:25:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232022AbjGaQZH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 12:25:07 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EEBB171C
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 09:25:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690820706; x=1722356706;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dRjJnplBZqshOVUlL2HsM+HSmg8sekLwwBqcDcf81FM=;
  b=eRw9K7ur/0ZYP5HAcCwrG467okJ82OPQoBX0qAOhx5GcEwlODAp0F15e
   MnKjpzJtI24zjfdD+t+QeGSbvj26nRy+ZWMktg8KMQdGpe9NKffPgV1i/
   o9bsSWIpQEA8Vmrjca979GuAgWep/QoWle5hhtKOGvo+Bd/X031a+QRkA
   aLCBFaDsbjEaLnIMGULZvgdkBxIy6MFcklU1KZfiythYNHBFxbDCgBpQf
   jc76Lt8tjocOETMYpgoXpZqoOfBa02q8lUwjxRSRW2nS437sPtm9JJqHz
   4qtFmzO24FkE+1T7oroajLt1kHzFf2lFIJXGeLIatD+VA7PTixWOKKDf2
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="353993395"
X-IronPort-AV: E=Sophos;i="6.01,244,1684825200"; 
   d="scan'208";a="353993395"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2023 09:25:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="757984045"
X-IronPort-AV: E=Sophos;i="6.01,244,1684825200"; 
   d="scan'208";a="757984045"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.46])
  by orsmga008.jf.intel.com with ESMTP; 31 Jul 2023 09:25:01 -0700
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
Subject: [RFC PATCH 03/19] RAMBlock: Support KVM gmemory
Date:   Mon, 31 Jul 2023 12:21:45 -0400
Message-Id: <20230731162201.271114-4-xiaoyao.li@intel.com>
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

Add KVM gmem support to RAMBlock so we can have both normal
hva based memory and gmem fd based memory in one RAMBlock.

The gmem part is represented by the gmem_fd.

Signed-off-by: Chao Peng <chao.p.peng@linux.intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 include/exec/memory.h   | 8 ++++++++
 include/exec/ramblock.h | 1 +
 softmmu/memory.c        | 9 +++++++++
 softmmu/physmem.c       | 2 ++
 4 files changed, 20 insertions(+)

diff --git a/include/exec/memory.h b/include/exec/memory.h
index 7f5c11a0cc9e..61e31c7b9874 100644
--- a/include/exec/memory.h
+++ b/include/exec/memory.h
@@ -1376,6 +1376,14 @@ void memory_region_init_ram_from_fd(MemoryRegion *mr,
                                     int fd,
                                     ram_addr_t offset,
                                     Error **errp);
+/**
+ * memory_region_set_gmem_fd:  Set RAM memory region with a restricted fd.
+ *
+ * @mr: the #MemoryRegion to be set.
+ * @fd: the fd to provide restricted memory.
+ */
+void memory_region_set_gmem_fd(MemoryRegion *mr, int fd);
+
 #endif
 
 /**
diff --git a/include/exec/ramblock.h b/include/exec/ramblock.h
index 69c6a5390293..0d158b3909c9 100644
--- a/include/exec/ramblock.h
+++ b/include/exec/ramblock.h
@@ -41,6 +41,7 @@ struct RAMBlock {
     QLIST_HEAD(, RAMBlockNotifier) ramblock_notifiers;
     int fd;
     uint64_t fd_offset;
+    int gmem_fd;
     size_t page_size;
     /* dirty bitmap used during migration */
     unsigned long *bmap;
diff --git a/softmmu/memory.c b/softmmu/memory.c
index 7d9494ce7028..4f8f8c0a02e6 100644
--- a/softmmu/memory.c
+++ b/softmmu/memory.c
@@ -1661,6 +1661,15 @@ void memory_region_init_ram_from_fd(MemoryRegion *mr,
         error_propagate(errp, err);
     }
 }
+
+void memory_region_set_gmem_fd(MemoryRegion *mr, int fd)
+{
+    if (mr->ram_block) {
+        assert(fd >= 0);
+        mr->ram_block->gmem_fd = fd;
+    }
+}
+
 #endif
 
 void memory_region_init_ram_ptr(MemoryRegion *mr,
diff --git a/softmmu/physmem.c b/softmmu/physmem.c
index 3df73542e1fe..8f64128de0b5 100644
--- a/softmmu/physmem.c
+++ b/softmmu/physmem.c
@@ -1920,6 +1920,7 @@ RAMBlock *qemu_ram_alloc_from_fd(ram_addr_t size, MemoryRegion *mr,
     new_block->used_length = size;
     new_block->max_length = size;
     new_block->flags = ram_flags;
+    new_block->gmem_fd = -1;
     new_block->host = file_ram_alloc(new_block, size, fd, readonly,
                                      !file_size, offset, errp);
     if (!new_block->host) {
@@ -1990,6 +1991,7 @@ RAMBlock *qemu_ram_alloc_internal(ram_addr_t size, ram_addr_t max_size,
     new_block->max_length = max_size;
     assert(max_size >= size);
     new_block->fd = -1;
+    new_block->gmem_fd = -1;
     new_block->page_size = qemu_real_host_page_size();
     new_block->host = host;
     new_block->flags = ram_flags;
-- 
2.34.1

