Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C9DA43C9F1
	for <lists+kvm@lfdr.de>; Wed, 27 Oct 2021 14:45:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241985AbhJ0MsM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Oct 2021 08:48:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26352 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241978AbhJ0MsL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Oct 2021 08:48:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635338746;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PxRO//KGswXPKqSCCWXXkgC8CPdp/iPZT12lPG2xPHY=;
        b=bIL3tFHkysoq7ma4H6b8rKSCU74tBLrFlbtbPgYGKeFVoaew7E14AuLOIHyCVjvM7wOCa/
        3zvw0su49hL2jYxsBQTnDc9vkagB657p5C+2KEHsJbga0/G60nSAIsKDgG4AqT1hn0cWBB
        zA2fwDwx8F81DPIHFALilNaFT4l8mVU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-243-7qP48cA4NxeNUK2czPSimA-1; Wed, 27 Oct 2021 08:45:42 -0400
X-MC-Unique: 7qP48cA4NxeNUK2czPSimA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4F2D78066F9;
        Wed, 27 Oct 2021 12:45:41 +0000 (UTC)
Received: from t480s.redhat.com (unknown [10.39.193.176])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 912FA196E6;
        Wed, 27 Oct 2021 12:45:37 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     David Hildenbrand <david@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Ani Sinha <ani@anisinha.ca>, Peter Xu <peterx@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Hui Zhu <teawater@gmail.com>,
        Sebastien Boeuf <sebastien.boeuf@intel.com>,
        kvm@vger.kernel.org
Subject: [PATCH v1 01/12] kvm: Return number of free memslots
Date:   Wed, 27 Oct 2021 14:45:20 +0200
Message-Id: <20211027124531.57561-2-david@redhat.com>
In-Reply-To: <20211027124531.57561-1-david@redhat.com>
References: <20211027124531.57561-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's return the number of free slots instead of only checking if there
is a free slot. Required to support memory devices that consume multiple
memslots.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 accel/kvm/kvm-all.c    | 24 +++++++++++-------------
 accel/stubs/kvm-stub.c |  4 ++--
 hw/mem/memory-device.c |  2 +-
 include/sysemu/kvm.h   |  2 +-
 4 files changed, 15 insertions(+), 17 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index db8d83b137..0846be835e 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -103,6 +103,7 @@ struct KVMState
     AccelState parent_obj;
 
     int nr_slots;
+    int nr_free_slots;
     int fd;
     int vmfd;
     int coalesced_mmio;
@@ -245,6 +246,13 @@ int kvm_get_max_memslots(void)
     return s->nr_slots;
 }
 
+unsigned int kvm_get_free_memslots(void)
+{
+    KVMState *s = kvm_state;
+
+    return s->nr_free_slots;
+}
+
 /* Called with KVMMemoryListener.slots_lock held */
 static KVMSlot *kvm_get_free_slot(KVMMemoryListener *kml)
 {
@@ -260,19 +268,6 @@ static KVMSlot *kvm_get_free_slot(KVMMemoryListener *kml)
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
@@ -1410,6 +1405,7 @@ static void kvm_set_phys_mem(KVMMemoryListener *kml,
             }
             start_addr += slot_size;
             size -= slot_size;
+            kvm_state->nr_free_slots++;
         } while (size);
         goto out;
     }
@@ -1435,6 +1431,7 @@ static void kvm_set_phys_mem(KVMMemoryListener *kml,
         ram_start_offset += slot_size;
         ram += slot_size;
         size -= slot_size;
+        kvm_state->nr_free_slots--;
     } while (size);
 
 out:
@@ -2364,6 +2361,7 @@ static int kvm_init(MachineState *ms)
     if (!s->nr_slots) {
         s->nr_slots = 32;
     }
+    s->nr_free_slots = s->nr_slots;
 
     s->nr_as = kvm_check_extension(s, KVM_CAP_MULTI_ADDRESS_SPACE);
     if (s->nr_as <= 1) {
diff --git a/accel/stubs/kvm-stub.c b/accel/stubs/kvm-stub.c
index 5b1d00a222..cbaeb7c656 100644
--- a/accel/stubs/kvm-stub.c
+++ b/accel/stubs/kvm-stub.c
@@ -133,9 +133,9 @@ int kvm_irqchip_remove_irqfd_notifier_gsi(KVMState *s, EventNotifier *n,
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
index d9f8301711..9045ead33e 100644
--- a/hw/mem/memory-device.c
+++ b/hw/mem/memory-device.c
@@ -73,7 +73,7 @@ static void memory_device_check_addable(MachineState *ms, uint64_t size,
     uint64_t used_region_size = 0;
 
     /* we will need a new memory slot for kvm and vhost */
-    if (kvm_enabled() && !kvm_has_free_slot(ms)) {
+    if (kvm_enabled() && !kvm_get_free_memslots()) {
         error_setg(errp, "hypervisor has no free memory slots left");
         return;
     }
diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index a1ab1ee12d..c18be3cbd5 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -211,7 +211,7 @@ typedef struct Notifier Notifier;
 
 /* external API */
 
-bool kvm_has_free_slot(MachineState *ms);
+unsigned int kvm_get_free_memslots(void);
 bool kvm_has_sync_mmu(void);
 int kvm_has_vcpu_events(void);
 int kvm_has_robust_singlestep(void);
-- 
2.31.1

