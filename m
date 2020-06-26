Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE08920AD05
	for <lists+kvm@lfdr.de>; Fri, 26 Jun 2020 09:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728737AbgFZHYu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Jun 2020 03:24:50 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:38889 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728735AbgFZHYu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Jun 2020 03:24:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593156288;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WT2MQcvCiIRK06ehjaDXhdCDjT5gnyaryGIf1QwZi8o=;
        b=NiLVQb7ZUW9zja2l0Xc14MWjzWRI4oUveAxz5/GaLlkwzKB2BhjuYQtbP+gIq7/LSLfgnK
        zFJEhwRV9U9F2VgE7Ji6yy9jvtq0+dA9aFDN2D6TI+LqqK3hCm+TJ2hzlJ+0tyWNCoAoBq
        OWsDwqbvx5oLMbYH31/YXuqgz7zzVps=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-30-3dUxo9kDNyqOKdln5j_R8w-1; Fri, 26 Jun 2020 03:24:47 -0400
X-MC-Unique: 3dUxo9kDNyqOKdln5j_R8w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EC4861005512;
        Fri, 26 Jun 2020 07:24:45 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-113-35.ams2.redhat.com [10.36.113.35])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C5EB91C8;
        Fri, 26 Jun 2020 07:24:34 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>
Subject: [PATCH v5 17/21] virtio-pci: Send qapi events when the virtio-mem size changes
Date:   Fri, 26 Jun 2020 09:22:44 +0200
Message-Id: <20200626072248.78761-18-david@redhat.com>
In-Reply-To: <20200626072248.78761-1-david@redhat.com>
References: <20200626072248.78761-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's register the notifier and trigger the qapi event with the right
device id.

MEMORY_DEVICE_SIZE_CHANGE is similar to BALLOON_CHANGE, however on a
memory device level.

Don't unregister the notifier (we neither have finalize() nor unrealize()
for VirtIOPCIProxy, so it's not that simple to do it) - both devices are
expected to vanish at the same time.

Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Markus Armbruster <armbru@redhat.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Eric Blake <eblake@redhat.com>
Cc: Igor Mammedov <imammedo@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 hw/virtio/virtio-mem-pci.c | 28 ++++++++++++++++++++++++++++
 hw/virtio/virtio-mem-pci.h |  1 +
 monitor/monitor.c          |  1 +
 qapi/misc.json             | 25 +++++++++++++++++++++++++
 4 files changed, 55 insertions(+)

diff --git a/hw/virtio/virtio-mem-pci.c b/hw/virtio/virtio-mem-pci.c
index b325303b32..1a8e854123 100644
--- a/hw/virtio/virtio-mem-pci.c
+++ b/hw/virtio/virtio-mem-pci.c
@@ -14,6 +14,7 @@
 #include "virtio-mem-pci.h"
 #include "hw/mem/memory-device.h"
 #include "qapi/error.h"
+#include "qapi/qapi-events-misc.h"
 
 static void virtio_mem_pci_realize(VirtIOPCIProxy *vpci_dev, Error **errp)
 {
@@ -74,6 +75,21 @@ static void virtio_mem_pci_fill_device_info(const MemoryDeviceState *md,
     info->type = MEMORY_DEVICE_INFO_KIND_VIRTIO_MEM;
 }
 
+static void virtio_mem_pci_size_change_notify(Notifier *notifier, void *data)
+{
+    VirtIOMEMPCI *pci_mem = container_of(notifier, VirtIOMEMPCI,
+                                         size_change_notifier);
+    DeviceState *dev = DEVICE(pci_mem);
+    const uint64_t * const size_p = data;
+    const char *id = NULL;
+
+    if (dev->id) {
+        id = g_strdup(dev->id);
+    }
+
+    qapi_event_send_memory_device_size_change(!!id, id, *size_p);
+}
+
 static void virtio_mem_pci_class_init(ObjectClass *klass, void *data)
 {
     DeviceClass *dc = DEVICE_CLASS(klass);
@@ -98,9 +114,21 @@ static void virtio_mem_pci_class_init(ObjectClass *klass, void *data)
 static void virtio_mem_pci_instance_init(Object *obj)
 {
     VirtIOMEMPCI *dev = VIRTIO_MEM_PCI(obj);
+    VirtIOMEMClass *vmc;
+    VirtIOMEM *vmem;
 
     virtio_instance_init_common(obj, &dev->vdev, sizeof(dev->vdev),
                                 TYPE_VIRTIO_MEM);
+
+    dev->size_change_notifier.notify = virtio_mem_pci_size_change_notify;
+    vmem = VIRTIO_MEM(&dev->vdev);
+    vmc = VIRTIO_MEM_GET_CLASS(vmem);
+    /*
+     * We never remove the notifier again, as we expect both devices to
+     * disappear at the same time.
+     */
+    vmc->add_size_change_notifier(vmem, &dev->size_change_notifier);
+
     object_property_add_alias(obj, VIRTIO_MEM_BLOCK_SIZE_PROP,
                               OBJECT(&dev->vdev), VIRTIO_MEM_BLOCK_SIZE_PROP);
     object_property_add_alias(obj, VIRTIO_MEM_SIZE_PROP, OBJECT(&dev->vdev),
diff --git a/hw/virtio/virtio-mem-pci.h b/hw/virtio/virtio-mem-pci.h
index 8820cd6628..b51a28b275 100644
--- a/hw/virtio/virtio-mem-pci.h
+++ b/hw/virtio/virtio-mem-pci.h
@@ -28,6 +28,7 @@ typedef struct VirtIOMEMPCI VirtIOMEMPCI;
 struct VirtIOMEMPCI {
     VirtIOPCIProxy parent_obj;
     VirtIOMEM vdev;
+    Notifier size_change_notifier;
 };
 
 #endif /* QEMU_VIRTIO_MEM_PCI_H */
diff --git a/monitor/monitor.c b/monitor/monitor.c
index 125494410a..19dcb8fbe3 100644
--- a/monitor/monitor.c
+++ b/monitor/monitor.c
@@ -235,6 +235,7 @@ static MonitorQAPIEventConf monitor_qapi_event_conf[QAPI_EVENT__MAX] = {
     [QAPI_EVENT_QUORUM_REPORT_BAD] = { 1000 * SCALE_MS },
     [QAPI_EVENT_QUORUM_FAILURE]    = { 1000 * SCALE_MS },
     [QAPI_EVENT_VSERPORT_CHANGE]   = { 1000 * SCALE_MS },
+    [QAPI_EVENT_MEMORY_DEVICE_SIZE_CHANGE] = { 1000 * SCALE_MS },
 };
 
 /*
diff --git a/qapi/misc.json b/qapi/misc.json
index 65ca3edf32..149c925246 100644
--- a/qapi/misc.json
+++ b/qapi/misc.json
@@ -1434,6 +1434,31 @@
 ##
 { 'command': 'query-memory-devices', 'returns': ['MemoryDeviceInfo'] }
 
+##
+# @MEMORY_DEVICE_SIZE_CHANGE:
+#
+# Emitted when the size of a memory device changes. Only emitted for memory
+# devices that can actually change the size (e.g., virtio-mem due to guest
+# action).
+#
+# @id: device's ID
+# @size: the new size of memory that the device provides
+#
+# Note: this event is rate-limited.
+#
+# Since: 5.1
+#
+# Example:
+#
+# <- { "event": "MEMORY_DEVICE_SIZE_CHANGE",
+#      "data": { "id": "vm0", "size": 1073741824},
+#      "timestamp": { "seconds": 1588168529, "microseconds": 201316 } }
+#
+##
+{ 'event': 'MEMORY_DEVICE_SIZE_CHANGE',
+  'data': { '*id': 'str', 'size': 'size' } }
+
+
 ##
 # @MEM_UNPLUG_ERROR:
 #
-- 
2.26.2

