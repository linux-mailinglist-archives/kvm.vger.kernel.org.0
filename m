Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 043181C6D9D
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 11:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729276AbgEFJvL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 05:51:11 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:60104 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729280AbgEFJvK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 May 2020 05:51:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588758668;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rWys4epAU2XbucOUD2NVIBpXUWNVgzGVlwwLM5nrzXo=;
        b=OhL/LYtP/L2en4Zo2fYK5EMRL5yknDpkBBaauKFn5ptyo1ga/DoeLwNvSc5ODY2jkMxunc
        qdCETX5zSU6F/tmKeWTzMTQe3Jd7WRcvPXoU/kax7ktw7KAS4ayCgsNRiu5wqJIRw9PazH
        2HYHInwrQMzonZqQApRcWvQDDiVoFmU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-25-Xl0oQs4VM6OnDDsJytsSUg-1; Wed, 06 May 2020 05:51:07 -0400
X-MC-Unique: Xl0oQs4VM6OnDDsJytsSUg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 148DC80058A;
        Wed,  6 May 2020 09:51:06 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-113-17.ams2.redhat.com [10.36.113.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B4A7D5C1BD;
        Wed,  6 May 2020 09:51:03 +0000 (UTC)
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
Subject: [PATCH v1 17/17] virtio-pci: Send qapi events when the virtio-mem size changes
Date:   Wed,  6 May 2020 11:49:48 +0200
Message-Id: <20200506094948.76388-18-david@redhat.com>
In-Reply-To: <20200506094948.76388-1-david@redhat.com>
References: <20200506094948.76388-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
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
 hw/virtio/virtio-mem.c     |  2 +-
 monitor/monitor.c          |  1 +
 qapi/misc.json             | 25 +++++++++++++++++++++++++
 5 files changed, 56 insertions(+), 1 deletion(-)

diff --git a/hw/virtio/virtio-mem-pci.c b/hw/virtio/virtio-mem-pci.c
index a47d21c81f..780d7b4af7 100644
--- a/hw/virtio/virtio-mem-pci.c
+++ b/hw/virtio/virtio-mem-pci.c
@@ -15,6 +15,7 @@
 #include "virtio-mem-pci.h"
 #include "hw/mem/memory-device.h"
 #include "qapi/error.h"
+#include "qapi/qapi-events-misc.h"
=20
 static void virtio_mem_pci_realize(VirtIOPCIProxy *vpci_dev, Error **err=
p)
 {
@@ -75,6 +76,21 @@ static void virtio_mem_pci_fill_device_info(const Memo=
ryDeviceState *md,
     info->type =3D MEMORY_DEVICE_INFO_KIND_VIRTIO_MEM;
 }
=20
+static void virtio_mem_pci_size_change_notify(Notifier *notifier, void *=
data)
+{
+    VirtIOMEMPCI *pci_mem =3D container_of(notifier, VirtIOMEMPCI,
+                                         size_change_notifier);
+    DeviceState *dev =3D DEVICE(pci_mem);
+    const uint64_t * const size_p =3D data;
+    const char *id =3D NULL;
+
+    if (dev->id) {
+        id =3D g_strdup(dev->id);
+    }
+
+    qapi_event_send_memory_device_size_change(!!id, id, *size_p);
+}
+
 static void virtio_mem_pci_class_init(ObjectClass *klass, void *data)
 {
     DeviceClass *dc =3D DEVICE_CLASS(klass);
@@ -99,9 +115,21 @@ static void virtio_mem_pci_class_init(ObjectClass *kl=
ass, void *data)
 static void virtio_mem_pci_instance_init(Object *obj)
 {
     VirtIOMEMPCI *dev =3D VIRTIO_MEM_PCI(obj);
+    VirtIOMEMClass *vmc;
+    VirtIOMEM *vmem;
=20
     virtio_instance_init_common(obj, &dev->vdev, sizeof(dev->vdev),
                                 TYPE_VIRTIO_MEM);
+
+    dev->size_change_notifier.notify =3D virtio_mem_pci_size_change_noti=
fy;
+    vmem =3D VIRTIO_MEM(&dev->vdev);
+    vmc =3D VIRTIO_MEM_GET_CLASS(vmem);
+    /*
+     * We never remove the notifier again, as we expect both devices to
+     * disappear at the same time.
+     */
+    vmc->add_size_change_notifier(vmem, &dev->size_change_notifier);
+
     object_property_add_alias(obj, VIRTIO_MEM_BLOCK_SIZE_PROP,
                               OBJECT(&dev->vdev),
                               VIRTIO_MEM_BLOCK_SIZE_PROP, &error_abort);
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
=20
 #endif /* QEMU_VIRTIO_MEM_PCI_H */
diff --git a/hw/virtio/virtio-mem.c b/hw/virtio/virtio-mem.c
index 88a99a0d90..eb5cf66855 100644
--- a/hw/virtio/virtio-mem.c
+++ b/hw/virtio/virtio-mem.c
@@ -491,7 +491,7 @@ static void virtio_mem_device_unrealize(DeviceState *=
dev, Error **errp)
     virtio_del_queue(vdev, 0);
     virtio_cleanup(vdev);
     g_free(vmem->bitmap);
-    ramblock_discard_set_required(false);
+    ram_block_discard_set_required(false);
 }
=20
 static int virtio_mem_pre_save(void *opaque)
diff --git a/monitor/monitor.c b/monitor/monitor.c
index 125494410a..19dcb8fbe3 100644
--- a/monitor/monitor.c
+++ b/monitor/monitor.c
@@ -235,6 +235,7 @@ static MonitorQAPIEventConf monitor_qapi_event_conf[Q=
API_EVENT__MAX] =3D {
     [QAPI_EVENT_QUORUM_REPORT_BAD] =3D { 1000 * SCALE_MS },
     [QAPI_EVENT_QUORUM_FAILURE]    =3D { 1000 * SCALE_MS },
     [QAPI_EVENT_VSERPORT_CHANGE]   =3D { 1000 * SCALE_MS },
+    [QAPI_EVENT_MEMORY_DEVICE_SIZE_CHANGE] =3D { 1000 * SCALE_MS },
 };
=20
 /*
diff --git a/qapi/misc.json b/qapi/misc.json
index feaeacec22..58b073562b 100644
--- a/qapi/misc.json
+++ b/qapi/misc.json
@@ -1432,6 +1432,31 @@
 ##
 { 'command': 'query-memory-devices', 'returns': ['MemoryDeviceInfo'] }
=20
+##
+# @MEMORY_DEVICE_SIZE_CHANGE:
+#
+# Emitted when the size of a memory device changes. Only emitted for mem=
ory
+# devices that can actually change the size (e.g., virtio-mem due to gue=
st
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
--=20
2.25.3

