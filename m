Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A30BA732BBB
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 11:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344246AbjFPJbF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 05:31:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344729AbjFPJaK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 05:30:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A206A44A4
        for <kvm@vger.kernel.org>; Fri, 16 Jun 2023 02:28:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686907651;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vXfvzy3BvbKdCDWMLjmLhycK9z1x71ghzYUbYVGNwEY=;
        b=BE1Or16/CEcIJPS+mpiq5ImH4w7sCLmPJfBGsdd3/g1lN9ajUG9FRDBLiD+aB7/uU7Mmsb
        wewxtjm0CdN7dOYPij1akRf3Nvs9dh07lIH11NKGQz1ihFJ4uPArFJnvIkdBA0e0qVVpYc
        5a7Si/RdojuA8g0UPQkJcbODoj09+mk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-170-6baqK4W6MZe1t16lFeUvvA-1; Fri, 16 Jun 2023 05:27:26 -0400
X-MC-Unique: 6baqK4W6MZe1t16lFeUvvA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0D317185A78E;
        Fri, 16 Jun 2023 09:27:26 +0000 (UTC)
Received: from t480s.fritz.box (unknown [10.39.194.44])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 239431121314;
        Fri, 16 Jun 2023 09:27:21 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     David Hildenbrand <david@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Michal Privoznik <mprivozn@redhat.com>,
        =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Subject: [PATCH v1 05/15] kvm: Return number of free memslots
Date:   Fri, 16 Jun 2023 11:26:44 +0200
Message-Id: <20230616092654.175518-6-david@redhat.com>
In-Reply-To: <20230616092654.175518-1-david@redhat.com>
References: <20230616092654.175518-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's return the number of free slots instead of only checking if there
is a free slot. While at it, check all address spaces, which will also
consider SMM under x86 correctly.

Make the stub return UINT_MAX, such that we can call the function
unconditionally.

This is a preparation for memory devices that consume multiple memslots.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 accel/kvm/kvm-all.c      | 33 ++++++++++++++++++++-------------
 accel/stubs/kvm-stub.c   |  4 ++--
 hw/mem/memory-device.c   |  2 +-
 include/sysemu/kvm.h     |  2 +-
 include/sysemu/kvm_int.h |  1 +
 5 files changed, 25 insertions(+), 17 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 94d672010e..33295239ca 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -181,6 +181,24 @@ unsigned int kvm_get_max_memslots(void)
     return s->nr_slots;
 }
 
+unsigned int kvm_get_free_memslots(void)
+{
+    unsigned int used_slots = 0;
+    KVMState *s = kvm_state;
+    int i;
+
+    kvm_slots_lock();
+    for (i = 0; i < s->nr_as; i++) {
+        if (!s->as[i].ml) {
+            continue;
+        }
+        used_slots = MAX(used_slots, s->as[i].ml->nr_used_slots);
+    }
+    kvm_slots_unlock();
+
+    return s->nr_slots - used_slots;
+}
+
 /* Called with KVMMemoryListener.slots_lock held */
 static KVMSlot *kvm_get_free_slot(KVMMemoryListener *kml)
 {
@@ -196,19 +214,6 @@ static KVMSlot *kvm_get_free_slot(KVMMemoryListener *kml)
     return NULL;
 }
 
-bool kvm_has_free_slot(MachineState *ms)
-{
-    KVMState *s = KVM_STATE(ms->accelerator);
-    bool result;
-    KVMMemoryListener *kml = &s->memory_listener;
-
-    kvm_slots_lock();
-    result = !!kvm_get_free_slot(kml);
-    kvm_slots_unlock();
-
-    return result;
-}
-
 /* Called with KVMMemoryListener.slots_lock held */
 static KVMSlot *kvm_alloc_slot(KVMMemoryListener *kml)
 {
@@ -1384,6 +1389,7 @@ static void kvm_set_phys_mem(KVMMemoryListener *kml,
             }
             start_addr += slot_size;
             size -= slot_size;
+            kml->nr_used_slots--;
         } while (size);
         return;
     }
@@ -1409,6 +1415,7 @@ static void kvm_set_phys_mem(KVMMemoryListener *kml,
         ram_start_offset += slot_size;
         ram += slot_size;
         size -= slot_size;
+        kml->nr_used_slots++;
     } while (size);
 }
 
diff --git a/accel/stubs/kvm-stub.c b/accel/stubs/kvm-stub.c
index 506bc8c9e4..fd0b8ae8bb 100644
--- a/accel/stubs/kvm-stub.c
+++ b/accel/stubs/kvm-stub.c
@@ -113,9 +113,9 @@ unsigned int kvm_get_max_memslots(void)
     return UINT_MAX;
 }
 
-bool kvm_has_free_slot(MachineState *ms)
+unsigned int kvm_get_free_memslots(void)
 {
-    return false;
+    return UINT_MAX;
 }
 
 void kvm_init_cpu_signals(CPUState *cpu)
diff --git a/hw/mem/memory-device.c b/hw/mem/memory-device.c
index 0d007e559c..cee90d5182 100644
--- a/hw/mem/memory-device.c
+++ b/hw/mem/memory-device.c
@@ -133,7 +133,7 @@ static void memory_device_check_addable(MachineState *ms, MemoryRegion *mr,
     const uint64_t size = memory_region_size(mr);
 
     /* we will need a new memory slot for kvm and vhost */
-    if (kvm_enabled() && !kvm_has_free_slot(ms)) {
+    if (!kvm_get_free_memslots()) {
         error_setg(errp, "hypervisor has no free memory slots left");
         return;
     }
diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index 7a999eff52..8bf6ef5a07 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -214,7 +214,7 @@ typedef struct KVMRouteChange {
 /* external API */
 
 unsigned int kvm_get_max_memslots(void);
-bool kvm_has_free_slot(MachineState *ms);
+unsigned int kvm_get_free_memslots(void);
 bool kvm_has_sync_mmu(void);
 int kvm_has_vcpu_events(void);
 int kvm_has_robust_singlestep(void);
diff --git a/include/sysemu/kvm_int.h b/include/sysemu/kvm_int.h
index 511b42bde5..8b09e78b12 100644
--- a/include/sysemu/kvm_int.h
+++ b/include/sysemu/kvm_int.h
@@ -40,6 +40,7 @@ typedef struct KVMMemoryUpdate {
 typedef struct KVMMemoryListener {
     MemoryListener listener;
     KVMSlot *slots;
+    int nr_used_slots;
     int as_id;
     QSIMPLEQ_HEAD(, KVMMemoryUpdate) transaction_add;
     QSIMPLEQ_HEAD(, KVMMemoryUpdate) transaction_del;
-- 
2.40.1

