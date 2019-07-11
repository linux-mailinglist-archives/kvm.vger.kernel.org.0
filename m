Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA7D654B1
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 12:44:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728320AbfGKKo5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 06:44:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58326 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728055AbfGKKo5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 06:44:57 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6EECA3082A8D;
        Thu, 11 Jul 2019 10:44:56 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.36.118.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2710960600;
        Thu, 11 Jul 2019 10:44:51 +0000 (UTC)
From:   Juan Quintela <quintela@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>, kvm@vger.kernel.org,
        Thomas Huth <thuth@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>
Subject: [PULL 13/19] memory: Introduce memory listener hook log_clear()
Date:   Thu, 11 Jul 2019 12:44:06 +0200
Message-Id: <20190711104412.31233-14-quintela@redhat.com>
In-Reply-To: <20190711104412.31233-1-quintela@redhat.com>
References: <20190711104412.31233-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Thu, 11 Jul 2019 10:44:56 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Peter Xu <peterx@redhat.com>

Introduce a new memory region listener hook log_clear() to allow the
listeners to hook onto the points where the dirty bitmap is cleared by
the bitmap users.

Previously log_sync() contains two operations:

  - dirty bitmap collection, and,
  - dirty bitmap clear on remote site.

Let's take KVM as example - log_sync() for KVM will first copy the
kernel dirty bitmap to userspace, and at the same time we'll clear the
dirty bitmap there along with re-protecting all the guest pages again.

We add this new log_clear() interface only to split the old log_sync()
into two separated procedures:

  - use log_sync() to collect the collection only, and,
  - use log_clear() to clear the remote dirty bitmap.

With the new interface, the memory listener users will still be able
to decide how to implement the log synchronization procedure, e.g.,
they can still only provide log_sync() method only and put all the two
procedures within log_sync() (that's how the old KVM works before
KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2 is introduced).  However with this
new interface the memory listener users will start to have a chance to
postpone the log clear operation explicitly if the module supports.
That can really benefit users like KVM at least for host kernels that
support KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2.

There are three places that can clear dirty bits in any one of the
dirty bitmap in the ram_list.dirty_memory[3] array:

        cpu_physical_memory_snapshot_and_clear_dirty
        cpu_physical_memory_test_and_clear_dirty
        cpu_physical_memory_sync_dirty_bitmap

Currently we hook directly into each of the functions to notify about
the log_clear().

Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Juan Quintela <quintela@redhat.com>
Message-Id: <20190603065056.25211-7-peterx@redhat.com>
Signed-off-by: Juan Quintela <quintela@redhat.com>
---
 exec.c                  | 12 ++++++++++
 include/exec/memory.h   | 17 ++++++++++++++
 include/exec/ram_addr.h |  3 +++
 memory.c                | 51 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 83 insertions(+)

diff --git a/exec.c b/exec.c
index 3a00698cc0..3e78de3b8f 100644
--- a/exec.c
+++ b/exec.c
@@ -1358,6 +1358,8 @@ bool cpu_physical_memory_test_and_clear_dirty(ram_addr_t start,
     DirtyMemoryBlocks *blocks;
     unsigned long end, page;
     bool dirty = false;
+    RAMBlock *ramblock;
+    uint64_t mr_offset, mr_size;
 
     if (length == 0) {
         return false;
@@ -1369,6 +1371,10 @@ bool cpu_physical_memory_test_and_clear_dirty(ram_addr_t start,
     rcu_read_lock();
 
     blocks = atomic_rcu_read(&ram_list.dirty_memory[client]);
+    ramblock = qemu_get_ram_block(start);
+    /* Range sanity check on the ramblock */
+    assert(start >= ramblock->offset &&
+           start + length <= ramblock->offset + ramblock->used_length);
 
     while (page < end) {
         unsigned long idx = page / DIRTY_MEMORY_BLOCK_SIZE;
@@ -1380,6 +1386,10 @@ bool cpu_physical_memory_test_and_clear_dirty(ram_addr_t start,
         page += num;
     }
 
+    mr_offset = (ram_addr_t)(page << TARGET_PAGE_BITS) - ramblock->offset;
+    mr_size = (end - page) << TARGET_PAGE_BITS;
+    memory_region_clear_dirty_bitmap(ramblock->mr, mr_offset, mr_size);
+
     rcu_read_unlock();
 
     if (dirty && tcg_enabled()) {
@@ -1435,6 +1445,8 @@ DirtyBitmapSnapshot *cpu_physical_memory_snapshot_and_clear_dirty
         tlb_reset_dirty_range_all(start, length);
     }
 
+    memory_region_clear_dirty_bitmap(mr, offset, length);
+
     return snap;
 }
 
diff --git a/include/exec/memory.h b/include/exec/memory.h
index 70d6f7e451..bb0961ddb9 100644
--- a/include/exec/memory.h
+++ b/include/exec/memory.h
@@ -416,6 +416,7 @@ struct MemoryListener {
     void (*log_stop)(MemoryListener *listener, MemoryRegionSection *section,
                      int old, int new);
     void (*log_sync)(MemoryListener *listener, MemoryRegionSection *section);
+    void (*log_clear)(MemoryListener *listener, MemoryRegionSection *section);
     void (*log_global_start)(MemoryListener *listener);
     void (*log_global_stop)(MemoryListener *listener);
     void (*eventfd_add)(MemoryListener *listener, MemoryRegionSection *section,
@@ -1269,6 +1270,22 @@ void memory_region_set_log(MemoryRegion *mr, bool log, unsigned client);
 void memory_region_set_dirty(MemoryRegion *mr, hwaddr addr,
                              hwaddr size);
 
+/**
+ * memory_region_clear_dirty_bitmap - clear dirty bitmap for memory range
+ *
+ * This function is called when the caller wants to clear the remote
+ * dirty bitmap of a memory range within the memory region.  This can
+ * be used by e.g. KVM to manually clear dirty log when
+ * KVM_CAP_MANUAL_DIRTY_LOG_PROTECT is declared support by the host
+ * kernel.
+ *
+ * @mr:     the memory region to clear the dirty log upon
+ * @start:  start address offset within the memory region
+ * @len:    length of the memory region to clear dirty bitmap
+ */
+void memory_region_clear_dirty_bitmap(MemoryRegion *mr, hwaddr start,
+                                      hwaddr len);
+
 /**
  * memory_region_snapshot_and_clear_dirty: Get a snapshot of the dirty
  *                                         bitmap and clear it.
diff --git a/include/exec/ram_addr.h b/include/exec/ram_addr.h
index 1843b6f2d3..222b4338fb 100644
--- a/include/exec/ram_addr.h
+++ b/include/exec/ram_addr.h
@@ -462,6 +462,9 @@ uint64_t cpu_physical_memory_sync_dirty_bitmap(RAMBlock *rb,
                 idx++;
             }
         }
+
+        /* TODO: split the huge bitmap into smaller chunks */
+        memory_region_clear_dirty_bitmap(rb->mr, start, length);
     } else {
         ram_addr_t offset = rb->offset;
 
diff --git a/memory.c b/memory.c
index 71fcaf2d00..beac26e173 100644
--- a/memory.c
+++ b/memory.c
@@ -2064,6 +2064,57 @@ static void memory_region_sync_dirty_bitmap(MemoryRegion *mr)
     }
 }
 
+void memory_region_clear_dirty_bitmap(MemoryRegion *mr, hwaddr start,
+                                      hwaddr len)
+{
+    MemoryRegionSection mrs;
+    MemoryListener *listener;
+    AddressSpace *as;
+    FlatView *view;
+    FlatRange *fr;
+    hwaddr sec_start, sec_end, sec_size;
+
+    QTAILQ_FOREACH(listener, &memory_listeners, link) {
+        if (!listener->log_clear) {
+            continue;
+        }
+        as = listener->address_space;
+        view = address_space_get_flatview(as);
+        FOR_EACH_FLAT_RANGE(fr, view) {
+            if (!fr->dirty_log_mask || fr->mr != mr) {
+                /*
+                 * Clear dirty bitmap operation only applies to those
+                 * regions whose dirty logging is at least enabled
+                 */
+                continue;
+            }
+
+            mrs = section_from_flat_range(fr, view);
+
+            sec_start = MAX(mrs.offset_within_region, start);
+            sec_end = mrs.offset_within_region + int128_get64(mrs.size);
+            sec_end = MIN(sec_end, start + len);
+
+            if (sec_start >= sec_end) {
+                /*
+                 * If this memory region section has no intersection
+                 * with the requested range, skip.
+                 */
+                continue;
+            }
+
+            /* Valid case; shrink the section if needed */
+            mrs.offset_within_address_space +=
+                sec_start - mrs.offset_within_region;
+            mrs.offset_within_region = sec_start;
+            sec_size = sec_end - sec_start;
+            mrs.size = int128_make64(sec_size);
+            listener->log_clear(listener, &mrs);
+        }
+        flatview_unref(view);
+    }
+}
+
 DirtyBitmapSnapshot *memory_region_snapshot_and_clear_dirty(MemoryRegion *mr,
                                                             hwaddr addr,
                                                             hwaddr size,
-- 
2.21.0

