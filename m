Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B50B7654AE
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 12:44:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728413AbfGKKop (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 06:44:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44502 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728327AbfGKKop (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 06:44:45 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 038883082E46;
        Thu, 11 Jul 2019 10:44:45 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.36.118.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DE4BF60600;
        Thu, 11 Jul 2019 10:44:42 +0000 (UTC)
From:   Juan Quintela <quintela@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>, kvm@vger.kernel.org,
        Thomas Huth <thuth@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>
Subject: [PULL 10/19] memory: Don't set migration bitmap when without migration
Date:   Thu, 11 Jul 2019 12:44:03 +0200
Message-Id: <20190711104412.31233-11-quintela@redhat.com>
In-Reply-To: <20190711104412.31233-1-quintela@redhat.com>
References: <20190711104412.31233-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Thu, 11 Jul 2019 10:44:45 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Peter Xu <peterx@redhat.com>

Similar to 9460dee4b2 ("memory: do not touch code dirty bitmap unless
TCG is enabled", 2015-06-05) but for the migration bitmap - we can
skip the MIGRATION bitmap update if migration not enabled.

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Juan Quintela <quintela@redhat.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
Message-Id: <20190603065056.25211-4-peterx@redhat.com>
Signed-off-by: Juan Quintela <quintela@redhat.com>
---
 include/exec/memory.h   |  2 ++
 include/exec/ram_addr.h | 12 +++++++++++-
 memory.c                |  2 +-
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/include/exec/memory.h b/include/exec/memory.h
index 2c5cdffa31..70d6f7e451 100644
--- a/include/exec/memory.h
+++ b/include/exec/memory.h
@@ -46,6 +46,8 @@
         OBJECT_GET_CLASS(IOMMUMemoryRegionClass, (obj), \
                          TYPE_IOMMU_MEMORY_REGION)
 
+extern bool global_dirty_log;
+
 typedef struct MemoryRegionOps MemoryRegionOps;
 typedef struct MemoryRegionMmio MemoryRegionMmio;
 
diff --git a/include/exec/ram_addr.h b/include/exec/ram_addr.h
index 44dcc98de6..0a532c3963 100644
--- a/include/exec/ram_addr.h
+++ b/include/exec/ram_addr.h
@@ -349,8 +349,13 @@ static inline void cpu_physical_memory_set_dirty_lebitmap(unsigned long *bitmap,
             if (bitmap[k]) {
                 unsigned long temp = leul_to_cpu(bitmap[k]);
 
-                atomic_or(&blocks[DIRTY_MEMORY_MIGRATION][idx][offset], temp);
                 atomic_or(&blocks[DIRTY_MEMORY_VGA][idx][offset], temp);
+
+                if (global_dirty_log) {
+                    atomic_or(&blocks[DIRTY_MEMORY_MIGRATION][idx][offset],
+                              temp);
+                }
+
                 if (tcg_enabled()) {
                     atomic_or(&blocks[DIRTY_MEMORY_CODE][idx][offset], temp);
                 }
@@ -367,6 +372,11 @@ static inline void cpu_physical_memory_set_dirty_lebitmap(unsigned long *bitmap,
         xen_hvm_modified_memory(start, pages << TARGET_PAGE_BITS);
     } else {
         uint8_t clients = tcg_enabled() ? DIRTY_CLIENTS_ALL : DIRTY_CLIENTS_NOCODE;
+
+        if (!global_dirty_log) {
+            clients &= ~(1 << DIRTY_MEMORY_MIGRATION);
+        }
+
         /*
          * bitmap-traveling is faster than memory-traveling (for addr...)
          * especially when most of the memory is not dirty.
diff --git a/memory.c b/memory.c
index 480f3d989b..93486a71d7 100644
--- a/memory.c
+++ b/memory.c
@@ -38,7 +38,7 @@
 static unsigned memory_region_transaction_depth;
 static bool memory_region_update_pending;
 static bool ioeventfd_update_pending;
-static bool global_dirty_log = false;
+bool global_dirty_log;
 
 static QTAILQ_HEAD(, MemoryListener) memory_listeners
     = QTAILQ_HEAD_INITIALIZER(memory_listeners);
-- 
2.21.0

