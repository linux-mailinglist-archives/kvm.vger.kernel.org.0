Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA34D5B3165
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 10:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231400AbiIIIMJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 04:12:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231325AbiIIIMB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 04:12:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40D73B69ED
        for <kvm@vger.kernel.org>; Fri,  9 Sep 2022 01:11:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662711118;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OaVxRmOqhUa1BGCUbms2VhwQdBBdao4awVXqKCRWbOw=;
        b=SiD9/B8imjV1uHbDhgsj2DzpcPd9fM3A4t8ABUo+0p2Y1gklfEt6cZY5q7StLxk9Q9UiwK
        v3Ko5xf8uvnm38oqnfyAl27tKy0rjpqUHExl3FEi+QbhMVJPzbKTKaNdv/mAeEypZuecrE
        ce25Q1Alt7jA77Rt/Ur27tS/TYczpjw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-424-ZxpyqabtNHedvw_2JaB1SA-1; Fri, 09 Sep 2022 04:11:57 -0400
X-MC-Unique: ZxpyqabtNHedvw_2JaB1SA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C6FAB1C05AAD;
        Fri,  9 Sep 2022 08:11:56 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7D266400EA8F;
        Fri,  9 Sep 2022 08:11:56 +0000 (UTC)
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>
Subject: [RFC PATCH v2 3/3] kvm/kvm-all.c: listener should delay kvm_vm_ioctl to the commit phase
Date:   Fri,  9 Sep 2022 04:11:50 -0400
Message-Id: <20220909081150.709060-4-eesposit@redhat.com>
In-Reply-To: <20220909081150.709060-1-eesposit@redhat.com>
References: <20220909081150.709060-1-eesposit@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Instead of sending a single ioctl every time ->region_* or ->log_*
callbacks are called, "queue" all memory regions in a
kvm_userspace_memory_region_list that will be sent only when committing.

This allow the KVM kernel API to be extended and support multiple
memslots updates in a single call.

Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
---
 accel/kvm/kvm-all.c      | 131 ++++++++++++++++++++++++++-------------
 include/sysemu/kvm_int.h |   8 +++
 2 files changed, 96 insertions(+), 43 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index e9947ec18b..9780f3d2da 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -357,56 +357,50 @@ int kvm_physical_memory_addr_from_host(KVMState *s, void *ram,
     return ret;
 }
 
+static struct kvm_userspace_memory_region_entry *kvm_memory_region_entry_get(
+                                                        KVMMemoryListener *kml)
+{
+    struct MemoryRegionNodeArray *arr = &kml->mem_array;
+    struct kvm_userspace_memory_region_list *list = arr->list;
+
+    if (list->nent == arr->max_entries) {
+        arr->max_entries += DEFAULT_KVM_MEMORY_REGION_ARRAY_GROW;
+        list = g_realloc(list,
+                              sizeof(struct kvm_userspace_memory_region_list) +
+                              arr->max_entries *
+                              sizeof(struct kvm_userspace_memory_region_entry));
+    }
+
+    return &list->entries[list->nent++];
+}
+
 static int kvm_set_user_memory_region(KVMMemoryListener *kml, KVMSlot *slot, bool new)
 {
-    KVMState *s = kvm_state;
-    struct kvm_userspace_memory_region_entry mem;
-    int ret;
+    struct kvm_userspace_memory_region_entry *mem;
+
+    mem = kvm_memory_region_entry_get(kml);
+
+    mem->slot = slot->slot | (kml->as_id << 16);
+    mem->guest_phys_addr = slot->start_addr;
+    mem->userspace_addr = (unsigned long)slot->ram;
+    mem->flags = slot->flags;
 
-    mem.slot = slot->slot | (kml->as_id << 16);
-    mem.guest_phys_addr = slot->start_addr;
-    mem.userspace_addr = (unsigned long)slot->ram;
-    mem.flags = slot->flags;
+    if (slot->memory_size && !new && (mem->flags ^ slot->old_flags) &
+        KVM_MEM_READONLY) {
+        struct kvm_userspace_memory_region_entry *mem2 = mem;
 
-    if (slot->memory_size && !new && (mem.flags ^ slot->old_flags) & KVM_MEM_READONLY) {
+        mem = kvm_memory_region_entry_get(kml);
+        memcpy(mem, mem2, sizeof(struct kvm_userspace_memory_region_entry));
         /* Set the slot size to 0 before setting the slot to the desired
          * value. This is needed based on KVM commit 75d61fbc. */
-        mem.memory_size = 0;
-        mem.invalidate_slot = 1;
-        /*
-         * Note that mem is struct kvm_userspace_memory_region_entry, while the
-         * kernel expects a kvm_userspace_memory_region, so it will currently
-         * ignore mem->invalidate_slot and mem->padding.
-         */
-        ret = kvm_vm_ioctl(s, KVM_SET_USER_MEMORY_REGION, &mem);
-        if (ret < 0) {
-            goto err;
-        }
+        mem2->memory_size = 0;
+        mem2->invalidate_slot = 1;
     }
-    mem.memory_size = slot->memory_size;
-    /*
-     * Invalidate if it's a kvm memslot MOVE or DELETE operation, but
-     * currently QEMU does not perform any memslot MOVE operation.
-     */
-    mem.invalidate_slot = slot->memory_size == 0;
+    mem->memory_size = slot->memory_size;
+    mem->invalidate_slot = slot->memory_size == 0;
 
-    /*
-     * Note that mem is struct kvm_userspace_memory_region_entry, while the
-     * kernel expects a kvm_userspace_memory_region, so it will currently
-     * ignore mem->invalidate_slot and mem->padding.
-     */
-    ret = kvm_vm_ioctl(s, KVM_SET_USER_MEMORY_REGION, &mem);
-    slot->old_flags = mem.flags;
-err:
-    trace_kvm_set_user_memory(mem.slot, mem.flags, mem.guest_phys_addr,
-                              mem.memory_size, mem.userspace_addr, ret);
-    if (ret < 0) {
-        error_report("%s: KVM_SET_USER_MEMORY_REGION failed, slot=%d,"
-                     " start=0x%" PRIx64 ", size=0x%" PRIx64 ": %s",
-                     __func__, mem.slot, slot->start_addr,
-                     (uint64_t)mem.memory_size, strerror(errno));
-    }
-    return ret;
+    slot->old_flags = mem->flags;
+    return 0;
 }
 
 static int do_kvm_destroy_vcpu(CPUState *cpu)
@@ -1534,12 +1528,54 @@ static void kvm_region_add(MemoryListener *listener,
 static void kvm_region_del(MemoryListener *listener,
                            MemoryRegionSection *section)
 {
-    KVMMemoryListener *kml = container_of(listener, KVMMemoryListener, listener);
+    KVMMemoryListener *kml = container_of(listener, KVMMemoryListener,
+                                          listener);
 
     kvm_set_phys_mem(kml, section, false);
     memory_region_unref(section->mr);
 }
 
+static void kvm_begin(MemoryListener *listener)
+{
+    KVMMemoryListener *kml = container_of(listener, KVMMemoryListener,
+                                          listener);
+    assert(kml->mem_array.list->nent == 0);
+}
+
+static void kvm_commit(MemoryListener *listener)
+{
+    KVMMemoryListener *kml = container_of(listener, KVMMemoryListener,
+                                          listener);
+    KVMState *s = kvm_state;
+    int i;
+
+    for (i = 0; i < kml->mem_array.list->nent; i++) {
+        struct kvm_userspace_memory_region_entry *mem;
+        int ret;
+
+        mem = &kml->mem_array.list->entries[i];
+
+        /*
+         * Note that mem is struct kvm_userspace_memory_region_entry, while the
+         * kernel expects a kvm_userspace_memory_region, so it will currently
+         * ignore mem->invalidate_slot and mem->padding.
+         */
+        ret = kvm_vm_ioctl(s, KVM_SET_USER_MEMORY_REGION, mem);
+
+        trace_kvm_set_user_memory(mem->slot, mem->flags, mem->guest_phys_addr,
+                                  mem->memory_size, mem->userspace_addr, 0);
+
+        if (ret < 0) {
+            error_report("%s: KVM_SET_USER_MEMORY_REGION failed, slot=%d,"
+                         " start=0x%" PRIx64 ": %s",
+                         __func__, mem->slot,
+                         (uint64_t)mem->memory_size, strerror(errno));
+        }
+    }
+
+    kml->mem_array.list->nent = 0;
+}
+
 static void kvm_log_sync(MemoryListener *listener,
                          MemoryRegionSection *section)
 {
@@ -1681,8 +1717,16 @@ void kvm_memory_listener_register(KVMState *s, KVMMemoryListener *kml,
         kml->slots[i].slot = i;
     }
 
+    kml->mem_array.max_entries = DEFAULT_KVM_MEMORY_REGION_ARRAY_GROW;
+    kml->mem_array.list = g_malloc0(
+                            sizeof(struct kvm_userspace_memory_region_list) +
+                            sizeof(struct kvm_userspace_memory_region_entry) *
+                            kml->mem_array.max_entries);
+
     kml->listener.region_add = kvm_region_add;
     kml->listener.region_del = kvm_region_del;
+    kml->listener.begin = kvm_begin;
+    kml->listener.commit = kvm_commit;
     kml->listener.log_start = kvm_log_start;
     kml->listener.log_stop = kvm_log_stop;
     kml->listener.priority = 10;
@@ -2691,6 +2735,7 @@ err:
         close(s->fd);
     }
     g_free(s->memory_listener.slots);
+    g_free(s->memory_listener.mem_array.list);
 
     return ret;
 }
diff --git a/include/sysemu/kvm_int.h b/include/sysemu/kvm_int.h
index 1f5487d9b7..1adc1c8722 100644
--- a/include/sysemu/kvm_int.h
+++ b/include/sysemu/kvm_int.h
@@ -30,9 +30,17 @@ typedef struct KVMSlot
     ram_addr_t ram_start_offset;
 } KVMSlot;
 
+#define DEFAULT_KVM_MEMORY_REGION_ARRAY_GROW 10
+
+struct MemoryRegionNodeArray {
+    struct kvm_userspace_memory_region_list *list;
+    int max_entries;
+};
+
 typedef struct KVMMemoryListener {
     MemoryListener listener;
     KVMSlot *slots;
+    struct MemoryRegionNodeArray mem_array;
     int as_id;
 } KVMMemoryListener;
 
-- 
2.31.1

