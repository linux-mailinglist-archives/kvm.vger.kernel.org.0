Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08CF91C6D9C
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 11:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729270AbgEFJvK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 05:51:10 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:56427 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729279AbgEFJvJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 May 2020 05:51:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588758668;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wV4EATbXKx0yfoicp1MyNawAoP7R4yGLGPwFlFlYLgg=;
        b=UpIXEMwGjvtYyS2mQvr/cCoCimBuzqgOdsHkDhwiRxlBDY2x7y3Xo1Xse2afT1oQLFYSGf
        gS8/Io5naoPhMFFt4KmT43gwS8cZkLcBbUVtCtcU13v22VeBKyryMfma3ICrDRXe5ylV9J
        KRW7ihdWpp2fEmkLTjerDjWisb0JUE8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-150-9weV7qJ5NwavGmfRKWAGNA-1; Wed, 06 May 2020 05:51:04 -0400
X-MC-Unique: 9weV7qJ5NwavGmfRKWAGNA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 66226835B43;
        Wed,  6 May 2020 09:51:03 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-113-17.ams2.redhat.com [10.36.113.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5F6285C1BD;
        Wed,  6 May 2020 09:51:01 +0000 (UTC)
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
Subject: [PATCH v1 16/17] virtio-mem: Allow notifiers for size changes
Date:   Wed,  6 May 2020 11:49:47 +0200
Message-Id: <20200506094948.76388-17-david@redhat.com>
In-Reply-To: <20200506094948.76388-1-david@redhat.com>
References: <20200506094948.76388-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We want to send qapi events in case the size of a virtio-mem device
changes. This allows upper layers to always know how much memory is
actually currently consumed via a virtio-mem device.

Unfortuantely, we have to report the id of our proxy device. Let's provid=
e
an easy way for our proxy device to register, so it can send the qapi
events. Piggy-backing on the notifier infrastructure (although we'll
only ever have one notifier registered) seems to be an easy way.

Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Igor Mammedov <imammedo@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 hw/virtio/virtio-mem.c         | 21 ++++++++++++++++++++-
 include/hw/virtio/virtio-mem.h |  5 +++++
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/hw/virtio/virtio-mem.c b/hw/virtio/virtio-mem.c
index e25b2c74f2..88a99a0d90 100644
--- a/hw/virtio/virtio-mem.c
+++ b/hw/virtio/virtio-mem.c
@@ -198,6 +198,7 @@ static int virtio_mem_state_change_request(VirtIOMEM =
*vmem, uint64_t gpa,
     } else {
         vmem->size -=3D size;
     }
+    notifier_list_notify(&vmem->size_change_notifiers, &vmem->size);
     return VIRTIO_MEM_RESP_ACK;
 }
=20
@@ -253,7 +254,10 @@ static int virtio_mem_unplug_all(VirtIOMEM *vmem)
         return -EBUSY;
     }
     bitmap_clear(vmem->bitmap, 0, vmem->bitmap_size);
-    vmem->size =3D 0;
+    if (vmem->size !=3D 0) {
+        vmem->size =3D 0;
+        notifier_list_notify(&vmem->size_change_notifiers, &vmem->size);
+    }
=20
     virtio_mem_resize_usable_region(vmem, vmem->requested_size, true);
     return 0;
@@ -594,6 +598,18 @@ static MemoryRegion *virtio_mem_get_memory_region(Vi=
rtIOMEM *vmem, Error **errp)
     return &vmem->memdev->mr;
 }
=20
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
 static void virtio_mem_get_size(Object *obj, Visitor *v, const char *nam=
e,
                                 void *opaque, Error **errp)
 {
@@ -705,6 +721,7 @@ static void virtio_mem_instance_init(Object *obj)
     VirtIOMEM *vmem =3D VIRTIO_MEM(obj);
=20
     vmem->block_size =3D VIRTIO_MEM_MIN_BLOCK_SIZE;
+    notifier_list_init(&vmem->size_change_notifiers);
=20
     object_property_add(obj, VIRTIO_MEM_SIZE_PROP, "size", virtio_mem_ge=
t_size,
                         NULL, NULL, NULL, &error_abort);
@@ -743,6 +760,8 @@ static void virtio_mem_class_init(ObjectClass *klass,=
 void *data)
=20
     vmc->fill_device_info =3D virtio_mem_fill_device_info;
     vmc->get_memory_region =3D virtio_mem_get_memory_region;
+    vmc->add_size_change_notifier =3D virtio_mem_add_size_change_notifie=
r;
+    vmc->remove_size_change_notifier =3D virtio_mem_remove_size_change_n=
otifier;
 }
=20
 static const TypeInfo virtio_mem_info =3D {
diff --git a/include/hw/virtio/virtio-mem.h b/include/hw/virtio/virtio-me=
m.h
index 27158cb611..5820b5c23e 100644
--- a/include/hw/virtio/virtio-mem.h
+++ b/include/hw/virtio/virtio-mem.h
@@ -66,6 +66,9 @@ typedef struct VirtIOMEM {
     /* block size and alignment */
     uint32_t block_size;
     uint32_t migration_block_size;
+
+    /* notifiers to notify when "size" changes */
+    NotifierList size_change_notifiers;
 } VirtIOMEM;
=20
 typedef struct VirtIOMEMClass {
@@ -75,6 +78,8 @@ typedef struct VirtIOMEMClass {
     /* public */
     void (*fill_device_info)(const VirtIOMEM *vmen, VirtioMEMDeviceInfo =
*vi);
     MemoryRegion *(*get_memory_region)(VirtIOMEM *vmem, Error **errp);
+    void (*add_size_change_notifier)(VirtIOMEM *vmem, Notifier *notifier=
);
+    void (*remove_size_change_notifier)(VirtIOMEM *vmem, Notifier *notif=
ier);
 } VirtIOMEMClass;
=20
 #endif
--=20
2.25.3

