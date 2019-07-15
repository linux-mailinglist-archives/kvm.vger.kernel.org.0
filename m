Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 149A369798
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2019 17:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730607AbfGOPL4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jul 2019 11:11:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34166 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730749AbfGONxA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jul 2019 09:53:00 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3C35B30821BE;
        Mon, 15 Jul 2019 13:53:00 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.36.118.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8CFB65B681;
        Mon, 15 Jul 2019 13:52:55 +0000 (UTC)
From:   Juan Quintela <quintela@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Juan Quintela <quintela@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Laurent Vivier <lvivier@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Peter Xu <peterx@redhat.com>
Subject: [PULL 16/21] kvm: Support KVM_CLEAR_DIRTY_LOG
Date:   Mon, 15 Jul 2019 15:51:20 +0200
Message-Id: <20190715135125.17770-17-quintela@redhat.com>
In-Reply-To: <20190715135125.17770-1-quintela@redhat.com>
References: <20190715135125.17770-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Mon, 15 Jul 2019 13:53:00 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Peter Xu <peterx@redhat.com>

Firstly detect the interface using KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2
and mark it.  When failed to enable the new feature we'll fall back to
the old sync.

Provide the log_clear() hook for the memory listeners for both address
spaces of KVM (normal system memory, and SMM) and deliever the clear
message to kernel.

Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
Message-Id: <20190603065056.25211-11-peterx@redhat.com>
Signed-off-by: Juan Quintela <quintela@redhat.com>
---
 accel/kvm/kvm-all.c    | 182 +++++++++++++++++++++++++++++++++++++++++
 accel/kvm/trace-events |   1 +
 2 files changed, 183 insertions(+)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 621c9a43ab..35ea3cb624 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -91,6 +91,7 @@ struct KVMState
     int many_ioeventfds;
     int intx_set_mask;
     bool sync_mmu;
+    bool manual_dirty_log_protect;
     /* The man page (and posix) say ioctl numbers are signed int, but
      * they're not.  Linux, glibc and *BSD all treat ioctl numbers as
      * unsigned, and treating them as signed here can break things */
@@ -560,6 +561,159 @@ out:
     return ret;
 }
 
+/* Alignment requirement for KVM_CLEAR_DIRTY_LOG - 64 pages */
+#define KVM_CLEAR_LOG_SHIFT  6
+#define KVM_CLEAR_LOG_ALIGN  (qemu_real_host_page_size << KVM_CLEAR_LOG_SHIFT)
+#define KVM_CLEAR_LOG_MASK   (-KVM_CLEAR_LOG_ALIGN)
+
+/**
+ * kvm_physical_log_clear - Clear the kernel's dirty bitmap for range
+ *
+ * NOTE: this will be a no-op if we haven't enabled manual dirty log
+ * protection in the host kernel because in that case this operation
+ * will be done within log_sync().
+ *
+ * @kml:     the kvm memory listener
+ * @section: the memory range to clear dirty bitmap
+ */
+static int kvm_physical_log_clear(KVMMemoryListener *kml,
+                                  MemoryRegionSection *section)
+{
+    KVMState *s = kvm_state;
+    struct kvm_clear_dirty_log d;
+    uint64_t start, end, bmap_start, start_delta, bmap_npages, size;
+    unsigned long *bmap_clear = NULL, psize = qemu_real_host_page_size;
+    KVMSlot *mem = NULL;
+    int ret, i;
+
+    if (!s->manual_dirty_log_protect) {
+        /* No need to do explicit clear */
+        return 0;
+    }
+
+    start = section->offset_within_address_space;
+    size = int128_get64(section->size);
+
+    if (!size) {
+        /* Nothing more we can do... */
+        return 0;
+    }
+
+    kvm_slots_lock(kml);
+
+    /* Find any possible slot that covers the section */
+    for (i = 0; i < s->nr_slots; i++) {
+        mem = &kml->slots[i];
+        if (mem->start_addr <= start &&
+            start + size <= mem->start_addr + mem->memory_size) {
+            break;
+        }
+    }
+
+    /*
+     * We should always find one memslot until this point, otherwise
+     * there could be something wrong from the upper layer
+     */
+    assert(mem && i != s->nr_slots);
+
+    /*
+     * We need to extend either the start or the size or both to
+     * satisfy the KVM interface requirement.  Firstly, do the start
+     * page alignment on 64 host pages
+     */
+    bmap_start = (start - mem->start_addr) & KVM_CLEAR_LOG_MASK;
+    start_delta = start - mem->start_addr - bmap_start;
+    bmap_start /= psize;
+
+    /*
+     * The kernel interface has restriction on the size too, that either:
+     *
+     * (1) the size is 64 host pages aligned (just like the start), or
+     * (2) the size fills up until the end of the KVM memslot.
+     */
+    bmap_npages = DIV_ROUND_UP(size + start_delta, KVM_CLEAR_LOG_ALIGN)
+        << KVM_CLEAR_LOG_SHIFT;
+    end = mem->memory_size / psize;
+    if (bmap_npages > end - bmap_start) {
+        bmap_npages = end - bmap_start;
+    }
+    start_delta /= psize;
+
+    /*
+     * Prepare the bitmap to clear dirty bits.  Here we must guarantee
+     * that we won't clear any unknown dirty bits otherwise we might
+     * accidentally clear some set bits which are not yet synced from
+     * the kernel into QEMU's bitmap, then we'll lose track of the
+     * guest modifications upon those pages (which can directly lead
+     * to guest data loss or panic after migration).
+     *
+     * Layout of the KVMSlot.dirty_bmap:
+     *
+     *                   |<-------- bmap_npages -----------..>|
+     *                                                     [1]
+     *                     start_delta         size
+     *  |----------------|-------------|------------------|------------|
+     *  ^                ^             ^                               ^
+     *  |                |             |                               |
+     * start          bmap_start     (start)                         end
+     * of memslot                                             of memslot
+     *
+     * [1] bmap_npages can be aligned to either 64 pages or the end of slot
+     */
+
+    assert(bmap_start % BITS_PER_LONG == 0);
+    /* We should never do log_clear before log_sync */
+    assert(mem->dirty_bmap);
+    if (start_delta) {
+        /* Slow path - we need to manipulate a temp bitmap */
+        bmap_clear = bitmap_new(bmap_npages);
+        bitmap_copy_with_src_offset(bmap_clear, mem->dirty_bmap,
+                                    bmap_start, start_delta + size / psize);
+        /*
+         * We need to fill the holes at start because that was not
+         * specified by the caller and we extended the bitmap only for
+         * 64 pages alignment
+         */
+        bitmap_clear(bmap_clear, 0, start_delta);
+        d.dirty_bitmap = bmap_clear;
+    } else {
+        /* Fast path - start address aligns well with BITS_PER_LONG */
+        d.dirty_bitmap = mem->dirty_bmap + BIT_WORD(bmap_start);
+    }
+
+    d.first_page = bmap_start;
+    /* It should never overflow.  If it happens, say something */
+    assert(bmap_npages <= UINT32_MAX);
+    d.num_pages = bmap_npages;
+    d.slot = mem->slot | (kml->as_id << 16);
+
+    if (kvm_vm_ioctl(s, KVM_CLEAR_DIRTY_LOG, &d) == -1) {
+        ret = -errno;
+        error_report("%s: KVM_CLEAR_DIRTY_LOG failed, slot=%d, "
+                     "start=0x%"PRIx64", size=0x%"PRIx32", errno=%d",
+                     __func__, d.slot, (uint64_t)d.first_page,
+                     (uint32_t)d.num_pages, ret);
+    } else {
+        ret = 0;
+        trace_kvm_clear_dirty_log(d.slot, d.first_page, d.num_pages);
+    }
+
+    /*
+     * After we have updated the remote dirty bitmap, we update the
+     * cached bitmap as well for the memslot, then if another user
+     * clears the same region we know we shouldn't clear it again on
+     * the remote otherwise it's data loss as well.
+     */
+    bitmap_clear(mem->dirty_bmap, bmap_start + start_delta,
+                 size / psize);
+    /* This handles the NULL case well */
+    g_free(bmap_clear);
+
+    kvm_slots_unlock(kml);
+
+    return ret;
+}
+
 static void kvm_coalesce_mmio_region(MemoryListener *listener,
                                      MemoryRegionSection *secion,
                                      hwaddr start, hwaddr size)
@@ -894,6 +1048,22 @@ static void kvm_log_sync(MemoryListener *listener,
     }
 }
 
+static void kvm_log_clear(MemoryListener *listener,
+                          MemoryRegionSection *section)
+{
+    KVMMemoryListener *kml = container_of(listener, KVMMemoryListener, listener);
+    int r;
+
+    r = kvm_physical_log_clear(kml, section);
+    if (r < 0) {
+        error_report_once("%s: kvm log clear failed: mr=%s "
+                          "offset=%"HWADDR_PRIx" size=%"PRIx64, __func__,
+                          section->mr->name, section->offset_within_region,
+                          int128_get64(section->size));
+        abort();
+    }
+}
+
 static void kvm_mem_ioeventfd_add(MemoryListener *listener,
                                   MemoryRegionSection *section,
                                   bool match_data, uint64_t data,
@@ -985,6 +1155,7 @@ void kvm_memory_listener_register(KVMState *s, KVMMemoryListener *kml,
     kml->listener.log_start = kvm_log_start;
     kml->listener.log_stop = kvm_log_stop;
     kml->listener.log_sync = kvm_log_sync;
+    kml->listener.log_clear = kvm_log_clear;
     kml->listener.priority = 10;
 
     memory_listener_register(&kml->listener, as);
@@ -1709,6 +1880,17 @@ static int kvm_init(MachineState *ms)
     s->coalesced_pio = s->coalesced_mmio &&
                        kvm_check_extension(s, KVM_CAP_COALESCED_PIO);
 
+    s->manual_dirty_log_protect =
+        kvm_check_extension(s, KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2);
+    if (s->manual_dirty_log_protect) {
+        ret = kvm_vm_enable_cap(s, KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2, 0, 1);
+        if (ret) {
+            warn_report("Trying to enable KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2 "
+                        "but failed.  Falling back to the legacy mode. ");
+            s->manual_dirty_log_protect = false;
+        }
+    }
+
 #ifdef KVM_CAP_VCPU_EVENTS
     s->vcpu_events = kvm_check_extension(s, KVM_CAP_VCPU_EVENTS);
 #endif
diff --git a/accel/kvm/trace-events b/accel/kvm/trace-events
index 33c5b1b3af..4fb6e59d19 100644
--- a/accel/kvm/trace-events
+++ b/accel/kvm/trace-events
@@ -15,4 +15,5 @@ kvm_irqchip_release_virq(int virq) "virq %d"
 kvm_set_ioeventfd_mmio(int fd, uint64_t addr, uint32_t val, bool assign, uint32_t size, bool datamatch) "fd: %d @0x%" PRIx64 " val=0x%x assign: %d size: %d match: %d"
 kvm_set_ioeventfd_pio(int fd, uint16_t addr, uint32_t val, bool assign, uint32_t size, bool datamatch) "fd: %d @0x%x val=0x%x assign: %d size: %d match: %d"
 kvm_set_user_memory(uint32_t slot, uint32_t flags, uint64_t guest_phys_addr, uint64_t memory_size, uint64_t userspace_addr, int ret) "Slot#%d flags=0x%x gpa=0x%"PRIx64 " size=0x%"PRIx64 " ua=0x%"PRIx64 " ret=%d"
+kvm_clear_dirty_log(uint32_t slot, uint64_t start, uint32_t size) "slot#%"PRId32" start 0x%"PRIx64" size 0x%"PRIx32
 
-- 
2.21.0

