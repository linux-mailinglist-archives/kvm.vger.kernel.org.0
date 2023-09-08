Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F217B798888
	for <lists+kvm@lfdr.de>; Fri,  8 Sep 2023 16:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243800AbjIHOWx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Sep 2023 10:22:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243789AbjIHOWw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Sep 2023 10:22:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 854BE1BF8
        for <kvm@vger.kernel.org>; Fri,  8 Sep 2023 07:21:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694182916;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qnTHMLcRnBjSX0HX1pgBvV2KvHSENwYwwq39XL4vDpQ=;
        b=HXZVh3yCmEASTrI7Ed3FRxwPxeh5L4XESWlaTl1xiJVtMctI6pnHyUf3ok/VQaHw3vz6TK
        tDehHWPLEUSPiJEyFoCaw2IUBMp11cTq3OCoGDGb0ofw1pomviVI3fhCx6mTYW106Rlp8+
        WQq9OR/IyQQ0jWI98sLayCaaYGIhYGk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-515-01cIp1v0OrKGk1Aeh_B-6w-1; Fri, 08 Sep 2023 10:21:52 -0400
X-MC-Unique: 01cIp1v0OrKGk1Aeh_B-6w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 298F98015AA;
        Fri,  8 Sep 2023 14:21:52 +0000 (UTC)
Received: from t14s.redhat.com (unknown [10.39.194.76])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 908C8C03295;
        Fri,  8 Sep 2023 14:21:49 +0000 (UTC)
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
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>,
        kvm@vger.kernel.org
Subject: [PATCH v3 04/16] kvm: Return number of free memslots
Date:   Fri,  8 Sep 2023 16:21:24 +0200
Message-ID: <20230908142136.403541-5-david@redhat.com>
In-Reply-To: <20230908142136.403541-1-david@redhat.com>
References: <20230908142136.403541-1-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's return the number of free slots instead of only checking if there
is a free slot. While at it, check all address spaces, which will also
consider SMM under x86 correctly.

This is a preparation for memory devices that consume multiple memslots.

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 accel/kvm/kvm-all.c      | 33 ++++++++++++++++++++-------------
 accel/stubs/kvm-stub.c   |  4 ++--
 hw/mem/memory-device.c   |  2 +-
 include/sysemu/kvm.h     |  2 +-
 include/sysemu/kvm_int.h |  1 +
 5 files changed, 25 insertions(+), 17 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 2ba7521695..a29906d441 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -181,6 +181,24 @@ int kvm_get_max_memslots(void)
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
@@ -1387,6 +1392,7 @@ static void kvm_set_phys_mem(KVMMemoryListener *kml,
             }
             start_addr += slot_size;
             size -= slot_size;
+            kml->nr_used_slots--;
         } while (size);
         return;
     }
@@ -1412,6 +1418,7 @@ static void kvm_set_phys_mem(KVMMemoryListener *kml,
         ram_start_offset += slot_size;
         ram += slot_size;
         size -= slot_size;
+        kml->nr_used_slots++;
     } while (size);
 }
 
diff --git a/accel/stubs/kvm-stub.c b/accel/stubs/kvm-stub.c
index 235dc661bc..a5d4442d8f 100644
--- a/accel/stubs/kvm-stub.c
+++ b/accel/stubs/kvm-stub.c
@@ -109,9 +109,9 @@ int kvm_irqchip_remove_irqfd_notifier_gsi(KVMState *s, EventNotifier *n,
     return -ENOSYS;
 }
 
-bool kvm_has_free_slot(MachineState *ms)
+unsigned int kvm_get_free_memslots(void)
 {
-    return false;
+    return 0;
 }
 
 void kvm_init_cpu_signals(CPUState *cpu)
diff --git a/hw/mem/memory-device.c b/hw/mem/memory-device.c
index 667d56bd29..98e355c960 100644
--- a/hw/mem/memory-device.c
+++ b/hw/mem/memory-device.c
@@ -59,7 +59,7 @@ static void memory_device_check_addable(MachineState *ms, MemoryRegion *mr,
     const uint64_t size = memory_region_size(mr);
 
     /* we will need a new memory slot for kvm and vhost */
-    if (kvm_enabled() && !kvm_has_free_slot(ms)) {
+    if (kvm_enabled() && !kvm_get_free_memslots()) {
         error_setg(errp, "hypervisor has no free memory slots left");
         return;
     }
diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index ee9025f8e9..c3d831baef 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -215,7 +215,7 @@ typedef struct KVMRouteChange {
 
 /* external API */
 
-bool kvm_has_free_slot(MachineState *ms);
+unsigned int kvm_get_free_memslots(void);
 bool kvm_has_sync_mmu(void);
 int kvm_has_vcpu_events(void);
 int kvm_has_robust_singlestep(void);
diff --git a/include/sysemu/kvm_int.h b/include/sysemu/kvm_int.h
index 511b42bde5..dba2f78fc3 100644
--- a/include/sysemu/kvm_int.h
+++ b/include/sysemu/kvm_int.h
@@ -40,6 +40,7 @@ typedef struct KVMMemoryUpdate {
 typedef struct KVMMemoryListener {
     MemoryListener listener;
     KVMSlot *slots;
+    unsigned int nr_used_slots;
     int as_id;
     QSIMPLEQ_HEAD(, KVMMemoryUpdate) transaction_add;
     QSIMPLEQ_HEAD(, KVMMemoryUpdate) transaction_del;
-- 
2.41.0

