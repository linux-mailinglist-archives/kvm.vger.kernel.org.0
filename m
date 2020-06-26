Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B8D620AD03
	for <lists+kvm@lfdr.de>; Fri, 26 Jun 2020 09:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728719AbgFZHYj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Jun 2020 03:24:39 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:36334 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728738AbgFZHYj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Jun 2020 03:24:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593156277;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3peSn+MW315QQpa+fsZ3dboRuGSyq5a24dDEiIpLnsw=;
        b=hD2zOUYY1a6bV5ZYiG3CcCo7dNNRR6qSmCY7X7CNkCoFkyAEmSHZpVwAYXS0FQihFIgKEC
        8Iq5STE60a6/AdHK+3+bzZdaTo9qwzZdbTnjNVWr/bId14urpsY47Qn/ehi9TlmRKDX6sT
        UIy5HeU1CBbn6pSD8zOJn2g8P80KNwY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-165-tPFJ30_LOL-srNbDge3UPA-1; Fri, 26 Jun 2020 03:24:35 -0400
X-MC-Unique: tPFJ30_LOL-srNbDge3UPA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7830F18FE86A;
        Fri, 26 Jun 2020 07:24:34 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-113-35.ams2.redhat.com [10.36.113.35])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 78DEB70915;
        Fri, 26 Jun 2020 07:24:32 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>
Subject: [PATCH v5 16/21] virtio-mem: Allow notifiers for size changes
Date:   Fri, 26 Jun 2020 09:22:43 +0200
Message-Id: <20200626072248.78761-17-david@redhat.com>
In-Reply-To: <20200626072248.78761-1-david@redhat.com>
References: <20200626072248.78761-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We want to send qapi events in case the size of a virtio-mem device
changes. This allows upper layers to always know how much memory is
actually currently consumed via a virtio-mem device.

Unfortuantely, we have to report the id of our proxy device. Let's provide
an easy way for our proxy device to register, so it can send the qapi
events. Piggy-backing on the notifier infrastructure (although we'll
only ever have one notifier registered) seems to be an easy way.

Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Igor Mammedov <imammedo@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 hw/virtio/virtio-mem.c         | 21 ++++++++++++++++++++-
 include/hw/virtio/virtio-mem.h |  5 +++++
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/hw/virtio/virtio-mem.c b/hw/virtio/virtio-mem.c
index d8a0c974d3..2df33f9125 100644
--- a/hw/virtio/virtio-mem.c
+++ b/hw/virtio/virtio-mem.c
@@ -184,6 +184,7 @@ static int virtio_mem_state_change_request(VirtIOMEM *vmem, uint64_t gpa,
     } else {
         vmem->size -= size;
     }
+    notifier_list_notify(&vmem->size_change_notifiers, &vmem->size);
     return VIRTIO_MEM_RESP_ACK;
 }
 
@@ -242,7 +243,10 @@ static int virtio_mem_unplug_all(VirtIOMEM *vmem)
         return -EBUSY;
     }
     bitmap_clear(vmem->bitmap, 0, vmem->bitmap_size);
-    vmem->size = 0;
+    if (vmem->size) {
+        vmem->size = 0;
+        notifier_list_notify(&vmem->size_change_notifiers, &vmem->size);
+    }
 
     virtio_mem_resize_usable_region(vmem, vmem->requested_size, true);
     return 0;
@@ -561,6 +565,18 @@ static MemoryRegion *virtio_mem_get_memory_region(VirtIOMEM *vmem, Error **errp)
     return &vmem->memdev->mr;
 }
 
+static void virtio_mem_add_size_change_notifier(VirtIOMEM *vmem,
+                                                Notifier *notifier)
+{
+    notifier_list_add(&vmem->size_change_notifiers, notifier);
+}
+
+static void virtio_mem_remove_size_change_notifier(VirtIOMEM *vmem,
+                                                   Notifier *notifier)
+{
+    notifier_remove(notifier);
+}
+
 static void virtio_mem_get_size(Object *obj, Visitor *v, const char *name,
                                 void *opaque, Error **errp)
 {
@@ -668,6 +684,7 @@ static void virtio_mem_instance_init(Object *obj)
     VirtIOMEM *vmem = VIRTIO_MEM(obj);
 
     vmem->block_size = VIRTIO_MEM_MIN_BLOCK_SIZE;
+    notifier_list_init(&vmem->size_change_notifiers);
 
     object_property_add(obj, VIRTIO_MEM_SIZE_PROP, "size", virtio_mem_get_size,
                         NULL, NULL, NULL);
@@ -705,6 +722,8 @@ static void virtio_mem_class_init(ObjectClass *klass, void *data)
 
     vmc->fill_device_info = virtio_mem_fill_device_info;
     vmc->get_memory_region = virtio_mem_get_memory_region;
+    vmc->add_size_change_notifier = virtio_mem_add_size_change_notifier;
+    vmc->remove_size_change_notifier = virtio_mem_remove_size_change_notifier;
 }
 
 static const TypeInfo virtio_mem_info = {
diff --git a/include/hw/virtio/virtio-mem.h b/include/hw/virtio/virtio-mem.h
index 6981096f7c..b74c77cd42 100644
--- a/include/hw/virtio/virtio-mem.h
+++ b/include/hw/virtio/virtio-mem.h
@@ -64,6 +64,9 @@ typedef struct VirtIOMEM {
 
     /* block size and alignment */
     uint64_t block_size;
+
+    /* notifiers to notify when "size" changes */
+    NotifierList size_change_notifiers;
 } VirtIOMEM;
 
 typedef struct VirtIOMEMClass {
@@ -73,6 +76,8 @@ typedef struct VirtIOMEMClass {
     /* public */
     void (*fill_device_info)(const VirtIOMEM *vmen, VirtioMEMDeviceInfo *vi);
     MemoryRegion *(*get_memory_region)(VirtIOMEM *vmem, Error **errp);
+    void (*add_size_change_notifier)(VirtIOMEM *vmem, Notifier *notifier);
+    void (*remove_size_change_notifier)(VirtIOMEM *vmem, Notifier *notifier);
 } VirtIOMEMClass;
 
 #endif
-- 
2.26.2

