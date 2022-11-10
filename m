Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9960C624784
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 17:50:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232735AbiKJQuV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 11:50:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232096AbiKJQty (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 11:49:54 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D6F9BC8B
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 08:48:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668098898;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FnmIzFs7Npf3HFGOMIuNdk5GFtHnhbFpd0CPbW0qThc=;
        b=Qf6DgnsguQzmFlQGWD8Gvr4TRAhqWdNumsPJKcgvkYevynxOfdbDrN/0X6uK14cowYongL
        Nx6dYfILYj2G+ASIRi5zGurhaDWFug61uN+QJA7vh3wpg9lv45eF0C3wrZ+O/HqeZtFz4S
        xe1hf8N8oPBhdNpSdC1p2WSVnD0vwnw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-411-W8_bNZVPNjeVGdN0mETRxQ-1; Thu, 10 Nov 2022 11:48:12 -0500
X-MC-Unique: W8_bNZVPNjeVGdN0mETRxQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6E40E85A59D;
        Thu, 10 Nov 2022 16:48:10 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 24F5640C94AA;
        Thu, 10 Nov 2022 16:48:10 +0000 (UTC)
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Yanan Wang <wangyanan55@huawei.com>, kvm@vger.kernel.org,
        David Hildenbrand <david@redhat.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>
Subject: [PATCH v2 3/3]  kvm: Atomic memslot updates
Date:   Thu, 10 Nov 2022 11:48:07 -0500
Message-Id: <20221110164807.1306076-4-eesposit@redhat.com>
In-Reply-To: <20221110164807.1306076-1-eesposit@redhat.com>
References: <20221110164807.1306076-1-eesposit@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Hildenbrand <david@redhat.com>

If we update an existing memslot (e.g., resize, split), we temporarily
remove the memslot to re-add it immediately afterwards. These updates
are not atomic, especially not for KVM VCPU threads, such that we can
get spurious faults.

Let's inhibit most KVM ioctls while performing relevant updates, such
that we can perform the update just as if it would happen atomically
without additional kernel support.

We capture the add/del changes and apply them in the notifier commit
stage instead. There, we can check for overlaps and perform the ioctl
inhibiting only if really required (-> overlap).

To keep things simple we don't perform additional checks that wouldn't
actually result in an overlap -- such as !RAM memory regions in some
cases (see kvm_set_phys_mem()).

To minimize cache-line bouncing, use a separate indicator
(in_ioctl_lock) per CPU.  Also, make sure to hold the kvm_slots_lock
while performing both actions (removing+re-adding).

We have to wait until all IOCTLs were exited and block new ones from
getting executed.

This approach cannot result in a deadlock as long as the inhibitor does
not hold any locks that might hinder an IOCTL from getting finished and
exited - something fairly unusual. The inhibitor will always hold the BQL.

AFAIKs, one possible candidate would be userfaultfd. If a page cannot be
placed (e.g., during postcopy), because we're waiting for a lock, or if the
userfaultfd thread cannot process a fault, because it is waiting for a
lock, there could be a deadlock. However, the BQL is not applicable here,
because any other guest memory access while holding the BQL would already
result in a deadlock.

Nothing else in the kernel should block forever and wait for userspace
intervention.

Note: pause_all_vcpus()/resume_all_vcpus() or
start_exclusive()/end_exclusive() cannot be used, as they either drop
the BQL or require to be called without the BQL - something inhibitors
cannot handle. We need a low-level locking mechanism that is
deadlock-free even when not releasing the BQL.

Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
Tested-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
---
 accel/kvm/kvm-all.c      | 100 ++++++++++++++++++++++++++++++++++-----
 include/sysemu/kvm_int.h |   8 ++++
 2 files changed, 97 insertions(+), 11 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index dfc6fe76db..ec478dbe69 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -31,6 +31,7 @@
 #include "sysemu/kvm_int.h"
 #include "sysemu/runstate.h"
 #include "sysemu/cpus.h"
+#include "sysemu/accel-blocker.h"
 #include "qemu/bswap.h"
 #include "exec/memory.h"
 #include "exec/ram_addr.h"
@@ -46,6 +47,7 @@
 #include "sysemu/hw_accel.h"
 #include "kvm-cpus.h"
 #include "sysemu/dirtylimit.h"
+#include "qemu/range.h"
 
 #include "hw/boards.h"
 #include "monitor/stats.h"
@@ -1292,6 +1294,7 @@ void kvm_set_max_memslot_size(hwaddr max_slot_size)
     kvm_max_slot_size = max_slot_size;
 }
 
+/* Called with KVMMemoryListener.slots_lock held */
 static void kvm_set_phys_mem(KVMMemoryListener *kml,
                              MemoryRegionSection *section, bool add)
 {
@@ -1326,14 +1329,12 @@ static void kvm_set_phys_mem(KVMMemoryListener *kml,
     ram = memory_region_get_ram_ptr(mr) + mr_offset;
     ram_start_offset = memory_region_get_ram_addr(mr) + mr_offset;
 
-    kvm_slots_lock();
-
     if (!add) {
         do {
             slot_size = MIN(kvm_max_slot_size, size);
             mem = kvm_lookup_matching_slot(kml, start_addr, slot_size);
             if (!mem) {
-                goto out;
+                return;
             }
             if (mem->flags & KVM_MEM_LOG_DIRTY_PAGES) {
                 /*
@@ -1371,7 +1372,7 @@ static void kvm_set_phys_mem(KVMMemoryListener *kml,
             start_addr += slot_size;
             size -= slot_size;
         } while (size);
-        goto out;
+        return;
     }
 
     /* register the new slot */
@@ -1396,9 +1397,6 @@ static void kvm_set_phys_mem(KVMMemoryListener *kml,
         ram += slot_size;
         size -= slot_size;
     } while (size);
-
-out:
-    kvm_slots_unlock();
 }
 
 static void *kvm_dirty_ring_reaper_thread(void *data)
@@ -1455,18 +1453,94 @@ static void kvm_region_add(MemoryListener *listener,
                            MemoryRegionSection *section)
 {
     KVMMemoryListener *kml = container_of(listener, KVMMemoryListener, listener);
+    KVMMemoryUpdate *update;
+
+    update = g_new0(KVMMemoryUpdate, 1);
+    update->section = memory_region_section_new_copy(section);
 
-    memory_region_ref(section->mr);
-    kvm_set_phys_mem(kml, section, true);
+    QSIMPLEQ_INSERT_TAIL(&kml->transaction_add, update, next);
 }
 
 static void kvm_region_del(MemoryListener *listener,
                            MemoryRegionSection *section)
 {
     KVMMemoryListener *kml = container_of(listener, KVMMemoryListener, listener);
+    KVMMemoryUpdate *update;
 
-    kvm_set_phys_mem(kml, section, false);
-    memory_region_unref(section->mr);
+    update = g_new0(KVMMemoryUpdate, 1);
+    update->section = memory_region_section_new_copy(section);
+
+    QSIMPLEQ_INSERT_TAIL(&kml->transaction_del, update, next);
+}
+
+static void kvm_region_commit(MemoryListener *listener)
+{
+    KVMMemoryListener *kml = container_of(listener, KVMMemoryListener,
+                                          listener);
+    KVMMemoryUpdate *u1, *u2;
+    bool need_inhibit = false;
+
+    if (QSIMPLEQ_EMPTY(&kml->transaction_add) &&
+        QSIMPLEQ_EMPTY(&kml->transaction_del)) {
+        return;
+    }
+
+    /*
+     * We have to be careful when regions to add overlap with ranges to remove.
+     * We have to simulate atomic KVM memslot updates by making sure no ioctl()
+     * is currently active.
+     *
+     * The lists are order by addresses, so it's easy to find overlaps.
+     */
+    u1 = QSIMPLEQ_FIRST(&kml->transaction_del);
+    u2 = QSIMPLEQ_FIRST(&kml->transaction_add);
+    while (u1 && u2) {
+        Range r1, r2;
+
+        range_init_nofail(&r1, u1->section->offset_within_address_space,
+                          int128_get64(u1->section->size));
+        range_init_nofail(&r2, u2->section->offset_within_address_space,
+                          int128_get64(u2->section->size));
+
+        if (range_overlaps_range(&r1, &r2)) {
+            need_inhibit = true;
+            break;
+        }
+        if (range_lob(&r1) < range_lob(&r2)) {
+            u1 = QSIMPLEQ_NEXT(u1, next);
+        } else {
+            u2 = QSIMPLEQ_NEXT(u2, next);
+        }
+    }
+
+
+    kvm_slots_lock();
+    if (need_inhibit) {
+        accel_ioctl_inhibit_begin();
+    }
+
+    /* Remove all memslots before adding the new ones. */
+    QSIMPLEQ_FOREACH_SAFE(u1, &kml->transaction_del, next, u2) {
+        kvm_set_phys_mem(kml, u1->section, false);
+        memory_region_unref(u1->section->mr);
+
+        QSIMPLEQ_REMOVE(&kml->transaction_del, u1, KVMMemoryUpdate, next);
+        memory_region_section_free_copy(u1->section);
+        g_free(u1);
+    }
+    QSIMPLEQ_FOREACH_SAFE(u1, &kml->transaction_add, next, u2) {
+        memory_region_ref(u1->section->mr);
+        kvm_set_phys_mem(kml, u1->section, true);
+
+        QSIMPLEQ_REMOVE(&kml->transaction_add, u1, KVMMemoryUpdate, next);
+        memory_region_section_free_copy(u1->section);
+        g_free(u1);
+    }
+
+    if (need_inhibit) {
+        accel_ioctl_inhibit_end();
+    }
+    kvm_slots_unlock();
 }
 
 static void kvm_log_sync(MemoryListener *listener,
@@ -1610,8 +1684,12 @@ void kvm_memory_listener_register(KVMState *s, KVMMemoryListener *kml,
         kml->slots[i].slot = i;
     }
 
+    QSIMPLEQ_INIT(&kml->transaction_add);
+    QSIMPLEQ_INIT(&kml->transaction_del);
+
     kml->listener.region_add = kvm_region_add;
     kml->listener.region_del = kvm_region_del;
+    kml->listener.commit = kvm_region_commit;
     kml->listener.log_start = kvm_log_start;
     kml->listener.log_stop = kvm_log_stop;
     kml->listener.priority = 10;
diff --git a/include/sysemu/kvm_int.h b/include/sysemu/kvm_int.h
index 3b4adcdc10..5ea2d7924b 100644
--- a/include/sysemu/kvm_int.h
+++ b/include/sysemu/kvm_int.h
@@ -12,6 +12,7 @@
 #include "exec/memory.h"
 #include "qapi/qapi-types-common.h"
 #include "qemu/accel.h"
+#include "qemu/queue.h"
 #include "sysemu/kvm.h"
 
 typedef struct KVMSlot
@@ -31,10 +32,17 @@ typedef struct KVMSlot
     ram_addr_t ram_start_offset;
 } KVMSlot;
 
+typedef struct KVMMemoryUpdate {
+    QSIMPLEQ_ENTRY(KVMMemoryUpdate) next;
+    MemoryRegionSection *section;
+} KVMMemoryUpdate;
+
 typedef struct KVMMemoryListener {
     MemoryListener listener;
     KVMSlot *slots;
     int as_id;
+    QSIMPLEQ_HEAD(, KVMMemoryUpdate) transaction_add;
+    QSIMPLEQ_HEAD(, KVMMemoryUpdate) transaction_del;
 } KVMMemoryListener;
 
 #define KVM_MSI_HASHTAB_SIZE    256
-- 
2.31.1

