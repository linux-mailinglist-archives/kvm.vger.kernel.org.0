Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18AC45958E6
	for <lists+kvm@lfdr.de>; Tue, 16 Aug 2022 12:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234950AbiHPKtD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 06:49:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235077AbiHPKsr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 06:48:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8F63F12AAF
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 03:12:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660644778;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NKA6rxMzSG9plLayOOUgu+lS1k1tefQ9X0WWKNpyvdw=;
        b=P5hqpAPvgYfTMOymlbXpKJ2Lhe5D9M43gxS3iWLKs9/Uw+IxkLahzzM/sLbFifk0O+/JWP
        g6L/gWI7qMlucp7kKNWs1MNKlhPhrsQzn/fFjnMHFBDuBKLCUpQMCaX17Wt07WiTwj40YO
        /wYMmR0dJQBhXC0qGc6kqYVqVMQadZA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-455-Lryv6ImxNMy3GiCPK2AxZA-1; Tue, 16 Aug 2022 06:12:57 -0400
X-MC-Unique: Lryv6ImxNMy3GiCPK2AxZA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B104E85A586;
        Tue, 16 Aug 2022 10:12:56 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6CF7640D2827;
        Tue, 16 Aug 2022 10:12:56 +0000 (UTC)
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
Subject: [RFC PATCH 2/2] kvm/kvm-all.c: listener should delay kvm_vm_ioctl to the commit phase
Date:   Tue, 16 Aug 2022 06:12:50 -0400
Message-Id: <20220816101250.1715523-3-eesposit@redhat.com>
In-Reply-To: <20220816101250.1715523-1-eesposit@redhat.com>
References: <20220816101250.1715523-1-eesposit@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
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
callbacks are called, "queue" all memory regions in a list that will
be emptied only when committing.

This allow the KVM kernel API to be extended and support multiple
memslots updates in a single call.

Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
---
 accel/kvm/kvm-all.c       | 99 ++++++++++++++++++++++++++++-----------
 include/sysemu/kvm_int.h  |  6 +++
 linux-headers/linux/kvm.h |  9 ++++
 3 files changed, 87 insertions(+), 27 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 645f0a249a..3afa46b2ef 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -357,39 +357,40 @@ int kvm_physical_memory_addr_from_host(KVMState *s, void *ram,
     return ret;
 }
 
+static void kvm_memory_region_node_add(KVMMemoryListener *kml,
+                                       struct kvm_userspace_memory_region *mem)
+{
+    MemoryRegionNode *node;
+
+    node = g_malloc(sizeof(MemoryRegionNode));
+    *node = (MemoryRegionNode) {
+        .mem = mem,
+    };
+    QTAILQ_INSERT_TAIL(&kml->mem_list, node, list);
+}
+
 static int kvm_set_user_memory_region(KVMMemoryListener *kml, KVMSlot *slot, bool new)
 {
-    KVMState *s = kvm_state;
-    struct kvm_userspace_memory_region mem;
-    int ret;
+    struct kvm_userspace_memory_region *mem;
 
-    mem.slot = slot->slot | (kml->as_id << 16);
-    mem.guest_phys_addr = slot->start_addr;
-    mem.userspace_addr = (unsigned long)slot->ram;
-    mem.flags = slot->flags;
+    mem = g_malloc(sizeof(struct kvm_userspace_memory_region));
 
-    if (slot->memory_size && !new && (mem.flags ^ slot->old_flags) & KVM_MEM_READONLY) {
+    mem->slot = slot->slot | (kml->as_id << 16);
+    mem->guest_phys_addr = slot->start_addr;
+    mem->userspace_addr = (unsigned long)slot->ram;
+    mem->flags = slot->flags;
+
+    if (slot->memory_size && !new && (mem->flags ^ slot->old_flags) &
+        KVM_MEM_READONLY) {
         /* Set the slot size to 0 before setting the slot to the desired
          * value. This is needed based on KVM commit 75d61fbc. */
-        mem.memory_size = 0;
-        ret = kvm_vm_ioctl(s, KVM_SET_USER_MEMORY_REGION, &mem);
-        if (ret < 0) {
-            goto err;
-        }
-    }
-    mem.memory_size = slot->memory_size;
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
+        mem->memory_size = 0;
+        kvm_memory_region_node_add(kml, mem);
     }
-    return ret;
+    mem->memory_size = slot->memory_size;
+    kvm_memory_region_node_add(kml, mem);
+    slot->old_flags = mem->flags;
+    return 0;
 }
 
 static int do_kvm_destroy_vcpu(CPUState *cpu)
@@ -1517,12 +1518,52 @@ static void kvm_region_add(MemoryListener *listener,
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
+    assert(QTAILQ_EMPTY(&kml->mem_list));
+}
+
+static void kvm_commit(MemoryListener *listener)
+{
+    KVMMemoryListener *kml = container_of(listener, KVMMemoryListener,
+                                          listener);
+    MemoryRegionNode *node, *next;
+    KVMState *s = kvm_state;
+
+    QTAILQ_FOREACH_SAFE(node, &kml->mem_list, list, next) {
+        struct kvm_userspace_memory_region *mem = node->mem;
+        int ret;
+
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
+
+        QTAILQ_REMOVE(&kml->mem_list, node, list);
+        g_free(mem);
+        g_free(node);
+    }
+
+
+
+}
+
 static void kvm_log_sync(MemoryListener *listener,
                          MemoryRegionSection *section)
 {
@@ -1664,8 +1705,12 @@ void kvm_memory_listener_register(KVMState *s, KVMMemoryListener *kml,
         kml->slots[i].slot = i;
     }
 
+    QTAILQ_INIT(&kml->mem_list);
+
     kml->listener.region_add = kvm_region_add;
     kml->listener.region_del = kvm_region_del;
+    kml->listener.begin = kvm_begin;
+    kml->listener.commit = kvm_commit;
     kml->listener.log_start = kvm_log_start;
     kml->listener.log_stop = kvm_log_stop;
     kml->listener.priority = 10;
diff --git a/include/sysemu/kvm_int.h b/include/sysemu/kvm_int.h
index 1f5487d9b7..eab8598007 100644
--- a/include/sysemu/kvm_int.h
+++ b/include/sysemu/kvm_int.h
@@ -30,9 +30,15 @@ typedef struct KVMSlot
     ram_addr_t ram_start_offset;
 } KVMSlot;
 
+typedef struct MemoryRegionNode {
+    struct kvm_userspace_memory_region *mem;
+    QTAILQ_ENTRY(MemoryRegionNode) list;
+} MemoryRegionNode;
+
 typedef struct KVMMemoryListener {
     MemoryListener listener;
     KVMSlot *slots;
+    QTAILQ_HEAD(, MemoryRegionNode) mem_list;
     int as_id;
 } KVMMemoryListener;
 
diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
index f089349149..f215efdaa8 100644
--- a/linux-headers/linux/kvm.h
+++ b/linux-headers/linux/kvm.h
@@ -103,6 +103,13 @@ struct kvm_userspace_memory_region {
 	__u64 userspace_addr; /* start of the userspace allocated memory */
 };
 
+/* for KVM_SET_USER_MEMORY_REGION_LIST */
+struct kvm_userspace_memory_region_list {
+	__u32 nent;
+	__u32 flags;
+	struct kvm_userspace_memory_region entries[0];
+};
+
 /*
  * The bit 0 ~ bit 15 of kvm_memory_region::flags are visible for userspace,
  * other bits are reserved for kvm internal use which are defined in
@@ -1426,6 +1433,8 @@ struct kvm_vfio_spapr_tce {
 					struct kvm_userspace_memory_region)
 #define KVM_SET_TSS_ADDR          _IO(KVMIO,   0x47)
 #define KVM_SET_IDENTITY_MAP_ADDR _IOW(KVMIO,  0x48, __u64)
+#define KVM_SET_USER_MEMORY_REGION_LIST _IOW(KVMIO, 0x49, \
+					struct kvm_userspace_memory_region_list)
 
 /* enable ucontrol for s390 */
 struct kvm_s390_ucas_mapping {
-- 
2.31.1

