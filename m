Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24370788873
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 15:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245101AbjHYNXT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Aug 2023 09:23:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236466AbjHYNXL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Aug 2023 09:23:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C99110FE
        for <kvm@vger.kernel.org>; Fri, 25 Aug 2023 06:22:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692969740;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3V1gB07yYcNrRBLflk2RNYS7w8T6BGm/wOnD2DtRQ9U=;
        b=SFzu1ArT98d1tWinksM6eXh78PIwP7x4bhaHSrx7vg0behu0ahT0lMGdoMx9yKqusLqcQh
        /ly9PFVL9EoOBr64GPtnnX+aeZg8Inohs4SXDy4usjIiro4HlnYBjx035pMW9E4R+o/2KU
        WEDeGd/IZ4rVoETAttrzt7n+H0P0SXs=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-182-J5dr9HCGNhyLLa4jhS0IAw-1; Fri, 25 Aug 2023 09:22:18 -0400
X-MC-Unique: J5dr9HCGNhyLLa4jhS0IAw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BED583C0C490;
        Fri, 25 Aug 2023 13:22:17 +0000 (UTC)
Received: from t14s.fritz.box (unknown [10.39.193.68])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 41CB9140E962;
        Fri, 25 Aug 2023 13:22:14 +0000 (UTC)
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
Subject: [PATCH v2 06/16] memory-device: Support memory devices with multiple memslots
Date:   Fri, 25 Aug 2023 15:21:39 +0200
Message-ID: <20230825132149.366064-7-david@redhat.com>
In-Reply-To: <20230825132149.366064-1-david@redhat.com>
References: <20230825132149.366064-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We want to support memory devices that have a memory region container as
device memory region that maps multiple RAM memory regions. Let's start
by supporting memory devices that statically map multiple RAM memory
regions and, thereby, consume multiple memslots.

We already have one device that uses a container as device memory region:
NVDIMMs. However, a NVDIMM always ends up consuming exactly one memslot.

Let's add support for that by asking the memory device via a new
callback how many memslots it requires.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 hw/mem/memory-device.c         | 27 +++++++++++++++++++--------
 include/hw/mem/memory-device.h | 18 ++++++++++++++++++
 2 files changed, 37 insertions(+), 8 deletions(-)

diff --git a/hw/mem/memory-device.c b/hw/mem/memory-device.c
index 22c12a4345..4613a15e1f 100644
--- a/hw/mem/memory-device.c
+++ b/hw/mem/memory-device.c
@@ -52,19 +52,30 @@ static int memory_device_build_list(Object *obj, void *opaque)
     return 0;
 }
 
-static void memory_device_check_addable(MachineState *ms, MemoryRegion *mr,
-                                        Error **errp)
+static unsigned int memory_device_get_memslots(MemoryDeviceState *md)
+{
+    const MemoryDeviceClass *mdc = MEMORY_DEVICE_GET_CLASS(md);
+
+    if (mdc->get_memslots) {
+        return mdc->get_memslots(md);
+    }
+    return 1;
+}
+
+static void memory_device_check_addable(MachineState *ms, MemoryDeviceState *md,
+                                        MemoryRegion *mr, Error **errp)
 {
     const uint64_t used_region_size = ms->device_memory->used_region_size;
     const uint64_t size = memory_region_size(mr);
+    const unsigned int required_memslots = memory_device_get_memslots(md);
 
-    /* we will need a new memory slot for kvm and vhost */
-    if (!kvm_get_free_memslots()) {
-        error_setg(errp, "hypervisor has no free memory slots left");
+    /* we will need memory slots for kvm and vhost */
+    if (kvm_get_free_memslots() < required_memslots) {
+        error_setg(errp, "hypervisor has not enough free memory slots left");
         return;
     }
-    if (!vhost_get_free_memslots()) {
-        error_setg(errp, "a used vhost backend has no free memory slots left");
+    if (vhost_get_free_memslots() < required_memslots) {
+        error_setg(errp, "a used vhost backend has not enough free memory slots left");
         return;
     }
 
@@ -233,7 +244,7 @@ void memory_device_pre_plug(MemoryDeviceState *md, MachineState *ms,
         goto out;
     }
 
-    memory_device_check_addable(ms, mr, &local_err);
+    memory_device_check_addable(ms, md, mr, &local_err);
     if (local_err) {
         goto out;
     }
diff --git a/include/hw/mem/memory-device.h b/include/hw/mem/memory-device.h
index 48d2611fc5..b51a579fb9 100644
--- a/include/hw/mem/memory-device.h
+++ b/include/hw/mem/memory-device.h
@@ -41,6 +41,11 @@ typedef struct MemoryDeviceState MemoryDeviceState;
  * successive memory regions are used, a covering memory region has to
  * be provided. Scattered memory regions are not supported for single
  * devices.
+ *
+ * The device memory region returned via @get_memory_region may either be a
+ * single RAM memory region or a memory region container with subregions
+ * that are RAM memory regions or aliases to RAM memory regions. Other
+ * memory regions or subregions are not supported.
  */
 struct MemoryDeviceClass {
     /* private */
@@ -88,6 +93,19 @@ struct MemoryDeviceClass {
      */
     MemoryRegion *(*get_memory_region)(MemoryDeviceState *md, Error **errp);
 
+    /*
+     * Optional for memory devices that require only a single memslot,
+     * required for all other memory devices: Return the number of memslots
+     * (distinct RAM memory regions in the device memory region) that are
+     * required by the device.
+     *
+     * If this function is not implemented, the assumption is "1".
+     *
+     * Called when (un)plugging the memory device, to check if the requirements
+     * can be satisfied, and to do proper accounting.
+     */
+    unsigned int (*get_memslots)(MemoryDeviceState *md);
+
     /*
      * Optional: Return the desired minimum alignment of the device in guest
      * physical address space. The final alignment is computed based on this
-- 
2.41.0

