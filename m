Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4228654B4
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 12:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728355AbfGKKpR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 06:45:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54780 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728311AbfGKKpR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 06:45:17 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 229B883F3D;
        Thu, 11 Jul 2019 10:45:17 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.36.118.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B56B460600;
        Thu, 11 Jul 2019 10:45:05 +0000 (UTC)
From:   Juan Quintela <quintela@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>, kvm@vger.kernel.org,
        Thomas Huth <thuth@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>
Subject: [PULL 16/19] kvm: Introduce slots lock for memory listener
Date:   Thu, 11 Jul 2019 12:44:09 +0200
Message-Id: <20190711104412.31233-17-quintela@redhat.com>
In-Reply-To: <20190711104412.31233-1-quintela@redhat.com>
References: <20190711104412.31233-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Thu, 11 Jul 2019 10:45:17 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Peter Xu <peterx@redhat.com>

Introduce KVMMemoryListener.slots_lock to protect the slots inside the
kvm memory listener.  Currently it is close to useless because all the
KVM code path now is always protected by the BQL.  But it'll start to
make sense in follow up patches where we might do remote dirty bitmap
clear and also we'll update the per-slot cached dirty bitmap even
without the BQL.  So let's prepare for it.

We can also use per-slot lock for above reason but it seems to be an
overkill.  Let's just use this bigger one (which covers all the slots
of a single address space) but anyway this lock is still much smaller
than the BQL.

Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Juan Quintela <quintela@redhat.com>
Message-Id: <20190603065056.25211-10-peterx@redhat.com>
Signed-off-by: Juan Quintela <quintela@redhat.com>
---
 accel/kvm/kvm-all.c      | 58 +++++++++++++++++++++++++++++++---------
 include/sysemu/kvm_int.h |  2 ++
 2 files changed, 48 insertions(+), 12 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 23ace52b9e..621c9a43ab 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -138,6 +138,9 @@ static const KVMCapabilityInfo kvm_required_capabilites[] = {
     KVM_CAP_LAST_INFO
 };
 
+#define kvm_slots_lock(kml)      qemu_mutex_lock(&(kml)->slots_lock)
+#define kvm_slots_unlock(kml)    qemu_mutex_unlock(&(kml)->slots_lock)
+
 int kvm_get_max_memslots(void)
 {
     KVMState *s = KVM_STATE(current_machine->accelerator);
@@ -165,6 +168,7 @@ int kvm_memcrypt_encrypt_data(uint8_t *ptr, uint64_t len)
     return 1;
 }
 
+/* Called with KVMMemoryListener.slots_lock held */
 static KVMSlot *kvm_get_free_slot(KVMMemoryListener *kml)
 {
     KVMState *s = kvm_state;
@@ -182,10 +186,17 @@ static KVMSlot *kvm_get_free_slot(KVMMemoryListener *kml)
 bool kvm_has_free_slot(MachineState *ms)
 {
     KVMState *s = KVM_STATE(ms->accelerator);
+    bool result;
+    KVMMemoryListener *kml = &s->memory_listener;
 
-    return kvm_get_free_slot(&s->memory_listener);
+    kvm_slots_lock(kml);
+    result = !!kvm_get_free_slot(kml);
+    kvm_slots_unlock(kml);
+
+    return result;
 }
 
+/* Called with KVMMemoryListener.slots_lock held */
 static KVMSlot *kvm_alloc_slot(KVMMemoryListener *kml)
 {
     KVMSlot *slot = kvm_get_free_slot(kml);
@@ -244,18 +255,21 @@ int kvm_physical_memory_addr_from_host(KVMState *s, void *ram,
                                        hwaddr *phys_addr)
 {
     KVMMemoryListener *kml = &s->memory_listener;
-    int i;
+    int i, ret = 0;
 
+    kvm_slots_lock(kml);
     for (i = 0; i < s->nr_slots; i++) {
         KVMSlot *mem = &kml->slots[i];
 
         if (ram >= mem->ram && ram < mem->ram + mem->memory_size) {
             *phys_addr = mem->start_addr + (ram - mem->ram);
-            return 1;
+            ret = 1;
+            break;
         }
     }
+    kvm_slots_unlock(kml);
 
-    return 0;
+    return ret;
 }
 
 static int kvm_set_user_memory_region(KVMMemoryListener *kml, KVMSlot *slot, bool new)
@@ -396,6 +410,7 @@ static int kvm_mem_flags(MemoryRegion *mr)
     return flags;
 }
 
+/* Called with KVMMemoryListener.slots_lock held */
 static int kvm_slot_update_flags(KVMMemoryListener *kml, KVMSlot *mem,
                                  MemoryRegion *mr)
 {
@@ -414,19 +429,26 @@ static int kvm_section_update_flags(KVMMemoryListener *kml,
 {
     hwaddr start_addr, size;
     KVMSlot *mem;
+    int ret = 0;
 
     size = kvm_align_section(section, &start_addr);
     if (!size) {
         return 0;
     }
 
+    kvm_slots_lock(kml);
+
     mem = kvm_lookup_matching_slot(kml, start_addr, size);
     if (!mem) {
         /* We don't have a slot if we want to trap every access. */
-        return 0;
+        goto out;
     }
 
-    return kvm_slot_update_flags(kml, mem, section->mr);
+    ret = kvm_slot_update_flags(kml, mem, section->mr);
+
+out:
+    kvm_slots_unlock(kml);
+    return ret;
 }
 
 static void kvm_log_start(MemoryListener *listener,
@@ -483,6 +505,8 @@ static int kvm_get_dirty_pages_log_range(MemoryRegionSection *section,
  * This function will first try to fetch dirty bitmap from the kernel,
  * and then updates qemu's dirty bitmap.
  *
+ * NOTE: caller must be with kml->slots_lock held.
+ *
  * @kml: the KVM memory listener object
  * @section: the memory section to sync the dirty bitmap with
  */
@@ -493,13 +517,14 @@ static int kvm_physical_sync_dirty_bitmap(KVMMemoryListener *kml,
     struct kvm_dirty_log d = {};
     KVMSlot *mem;
     hwaddr start_addr, size;
+    int ret = 0;
 
     size = kvm_align_section(section, &start_addr);
     if (size) {
         mem = kvm_lookup_matching_slot(kml, start_addr, size);
         if (!mem) {
             /* We don't have a slot if we want to trap every access. */
-            return 0;
+            goto out;
         }
 
         /* XXX bad kernel interface alert
@@ -525,13 +550,14 @@ static int kvm_physical_sync_dirty_bitmap(KVMMemoryListener *kml,
         d.slot = mem->slot | (kml->as_id << 16);
         if (kvm_vm_ioctl(s, KVM_GET_DIRTY_LOG, &d) == -1) {
             DPRINTF("ioctl failed %d\n", errno);
-            return -1;
+            ret = -1;
+            goto out;
         }
 
         kvm_get_dirty_pages_log_range(section, d.dirty_bitmap);
     }
-
-    return 0;
+out:
+    return ret;
 }
 
 static void kvm_coalesce_mmio_region(MemoryListener *listener,
@@ -793,10 +819,12 @@ static void kvm_set_phys_mem(KVMMemoryListener *kml,
     ram = memory_region_get_ram_ptr(mr) + section->offset_within_region +
           (start_addr - section->offset_within_address_space);
 
+    kvm_slots_lock(kml);
+
     if (!add) {
         mem = kvm_lookup_matching_slot(kml, start_addr, size);
         if (!mem) {
-            return;
+            goto out;
         }
         if (mem->flags & KVM_MEM_LOG_DIRTY_PAGES) {
             kvm_physical_sync_dirty_bitmap(kml, section);
@@ -813,7 +841,7 @@ static void kvm_set_phys_mem(KVMMemoryListener *kml,
                     __func__, strerror(-err));
             abort();
         }
-        return;
+        goto out;
     }
 
     /* register the new slot */
@@ -829,6 +857,9 @@ static void kvm_set_phys_mem(KVMMemoryListener *kml,
                 strerror(-err));
         abort();
     }
+
+out:
+    kvm_slots_unlock(kml);
 }
 
 static void kvm_region_add(MemoryListener *listener,
@@ -855,7 +886,9 @@ static void kvm_log_sync(MemoryListener *listener,
     KVMMemoryListener *kml = container_of(listener, KVMMemoryListener, listener);
     int r;
 
+    kvm_slots_lock(kml);
     r = kvm_physical_sync_dirty_bitmap(kml, section);
+    kvm_slots_unlock(kml);
     if (r < 0) {
         abort();
     }
@@ -939,6 +972,7 @@ void kvm_memory_listener_register(KVMState *s, KVMMemoryListener *kml,
 {
     int i;
 
+    qemu_mutex_init(&kml->slots_lock);
     kml->slots = g_malloc0(s->nr_slots * sizeof(KVMSlot));
     kml->as_id = as_id;
 
diff --git a/include/sysemu/kvm_int.h b/include/sysemu/kvm_int.h
index 687a2ee423..31df465fdc 100644
--- a/include/sysemu/kvm_int.h
+++ b/include/sysemu/kvm_int.h
@@ -27,6 +27,8 @@ typedef struct KVMSlot
 
 typedef struct KVMMemoryListener {
     MemoryListener listener;
+    /* Protects the slots and all inside them */
+    QemuMutex slots_lock;
     KVMSlot *slots;
     int as_id;
 } KVMMemoryListener;
-- 
2.21.0

