Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E76D71F53FA
	for <lists+kvm@lfdr.de>; Wed, 10 Jun 2020 13:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728891AbgFJL4F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jun 2020 07:56:05 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:57527 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728870AbgFJL4E (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 10 Jun 2020 07:56:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591790162;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wekDDw574QgT8J4I/42gBDbU1WxIpKSkHwqQsu+1Vwk=;
        b=K4/OGpYZOwc7etieWaUvihoepnkdwb81SYBtdghA+75wCf7NkAk7WKjQt9S2sUduYHdObT
        Oxd4Rda+5lF5+nPfTXgmx2o5Ahl9pFCd3oWo3bxn7evhf2V3Uu7+uw6+u/bf8flfxiehOv
        RlSFXIwhSadKHFvR3zrcF4sM8OsQwbw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-460-4QSvKPO-Mq6I8ILWbBNFhA-1; Wed, 10 Jun 2020 07:56:00 -0400
X-MC-Unique: 4QSvKPO-Mq6I8ILWbBNFhA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BA1961B18BC0;
        Wed, 10 Jun 2020 11:55:59 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-114-42.ams2.redhat.com [10.36.114.42])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DE2CB5D9D3;
        Wed, 10 Jun 2020 11:55:57 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>
Subject: [PATCH v4 20/21] virtio-mem: Exclude unplugged memory during migration
Date:   Wed, 10 Jun 2020 13:54:18 +0200
Message-Id: <20200610115419.51688-21-david@redhat.com>
In-Reply-To: <20200610115419.51688-1-david@redhat.com>
References: <20200610115419.51688-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The content of unplugged memory is undefined and should not be migrated,
ever. Exclude all unplugged memory during precopy using the precopy notifier
infrastructure introduced for free page hinting in virtio-balloon.

Unplugged memory is marked as "not dirty", meaning it won't be
considered for migration.

Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 hw/virtio/virtio-mem.c         | 54 +++++++++++++++++++++++++++++++++-
 include/hw/virtio/virtio-mem.h |  3 ++
 2 files changed, 56 insertions(+), 1 deletion(-)

diff --git a/hw/virtio/virtio-mem.c b/hw/virtio/virtio-mem.c
index 468fb4170f..21a23a3252 100644
--- a/hw/virtio/virtio-mem.c
+++ b/hw/virtio/virtio-mem.c
@@ -62,8 +62,14 @@ static bool virtio_mem_is_busy(void)
     /*
      * Postcopy cannot handle concurrent discards and we don't want to migrate
      * pages on-demand with stale content when plugging new blocks.
+     *
+     * For precopy, we don't want unplugged blocks in our migration stream, and
+     * when plugging new blocks, the page content might differ between source
+     * and destination (observable by the guest when not initializing pages
+     * after plugging them) until we're running on the destination (as we didn't
+     * migrate these blocks when they were unplugged).
      */
-    return migration_in_incoming_postcopy();
+    return migration_in_incoming_postcopy() || !migration_is_idle();
 }
 
 static bool virtio_mem_test_bitmap(VirtIOMEM *vmem, uint64_t start_gpa,
@@ -475,6 +481,7 @@ static void virtio_mem_device_realize(DeviceState *dev, Error **errp)
     host_memory_backend_set_mapped(vmem->memdev, true);
     vmstate_register_ram(&vmem->memdev->mr, DEVICE(vmem));
     qemu_register_reset(virtio_mem_system_reset, vmem);
+    precopy_add_notifier(&vmem->precopy_notifier);
 }
 
 static void virtio_mem_device_unrealize(DeviceState *dev)
@@ -482,6 +489,7 @@ static void virtio_mem_device_unrealize(DeviceState *dev)
     VirtIODevice *vdev = VIRTIO_DEVICE(dev);
     VirtIOMEM *vmem = VIRTIO_MEM(dev);
 
+    precopy_remove_notifier(&vmem->precopy_notifier);
     qemu_unregister_reset(virtio_mem_system_reset, vmem);
     vmstate_unregister_ram(&vmem->memdev->mr, DEVICE(vmem));
     host_memory_backend_set_mapped(vmem->memdev, false);
@@ -756,12 +764,56 @@ static void virtio_mem_set_block_size(Object *obj, Visitor *v, const char *name,
     vmem->block_size = value;
 }
 
+static void virtio_mem_precopy_exclude_unplugged(VirtIOMEM *vmem)
+{
+    void * const host = qemu_ram_get_host_addr(vmem->memdev->mr.ram_block);
+    unsigned long first_zero_bit, last_zero_bit;
+    uint64_t offset, length;
+
+    /*
+     * Find consecutive unplugged blocks and exclude them from migration.
+     *
+     * Note: Blocks cannot get (un)plugged during precopy, no locking needed.
+     */
+    first_zero_bit = find_first_zero_bit(vmem->bitmap, vmem->bitmap_size);
+    while (first_zero_bit < vmem->bitmap_size) {
+        offset = first_zero_bit * vmem->block_size;
+        last_zero_bit = find_next_bit(vmem->bitmap, vmem->bitmap_size,
+                                      first_zero_bit + 1) - 1;
+        length = (last_zero_bit - first_zero_bit + 1) * vmem->block_size;
+
+        qemu_guest_free_page_hint(host + offset, length);
+        first_zero_bit = find_next_zero_bit(vmem->bitmap, vmem->bitmap_size,
+                                            last_zero_bit + 2);
+    }
+}
+
+static int virtio_mem_precopy_notify(NotifierWithReturn *n, void *data)
+{
+    VirtIOMEM *vmem = container_of(n, VirtIOMEM, precopy_notifier);
+    PrecopyNotifyData *pnd = data;
+
+    switch (pnd->reason) {
+    case PRECOPY_NOTIFY_SETUP:
+        precopy_enable_free_page_optimization();
+        break;
+    case PRECOPY_NOTIFY_AFTER_BITMAP_SYNC:
+        virtio_mem_precopy_exclude_unplugged(vmem);
+        break;
+    default:
+        break;
+    }
+
+    return 0;
+}
+
 static void virtio_mem_instance_init(Object *obj)
 {
     VirtIOMEM *vmem = VIRTIO_MEM(obj);
 
     vmem->block_size = VIRTIO_MEM_MIN_BLOCK_SIZE;
     notifier_list_init(&vmem->size_change_notifiers);
+    vmem->precopy_notifier.notify = virtio_mem_precopy_notify;
 
     object_property_add(obj, VIRTIO_MEM_SIZE_PROP, "size", virtio_mem_get_size,
                         NULL, NULL, NULL);
diff --git a/include/hw/virtio/virtio-mem.h b/include/hw/virtio/virtio-mem.h
index b74c77cd42..0778224964 100644
--- a/include/hw/virtio/virtio-mem.h
+++ b/include/hw/virtio/virtio-mem.h
@@ -67,6 +67,9 @@ typedef struct VirtIOMEM {
 
     /* notifiers to notify when "size" changes */
     NotifierList size_change_notifiers;
+
+    /* don't migrate unplugged memory */
+    NotifierWithReturn precopy_notifier;
 } VirtIOMEM;
 
 typedef struct VirtIOMEMClass {
-- 
2.26.2

