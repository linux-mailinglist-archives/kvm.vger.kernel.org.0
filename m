Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3D701C6D9B
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 11:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729218AbgEFJvG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 05:51:06 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:23478 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729267AbgEFJvF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 May 2020 05:51:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588758663;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W2SInkhAIawUVaThIi/q7IY8VTE4Y+kHdMQ9prL2k5E=;
        b=KWpERWt3t26oX1+f9ldPBcVIpZnv0ZvMUcDIWDcR5NjeX+DKMRkWWa0V73vlSLfSuiNpm7
        srFPdJfCQ9GSjaM3oIC+kQBDvMqHjbJEwoQNkva2kKbWkItpA6r4fOznfl8LIfjfHlypLd
        7f+p3OhautdJqjF+kGDhR1KYLWDwWqQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-263-Ah1xG7R5OV-pXh4BYC61wg-1; Wed, 06 May 2020 05:51:02 -0400
X-MC-Unique: Ah1xG7R5OV-pXh4BYC61wg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 13A6D835B41;
        Wed,  6 May 2020 09:51:01 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-113-17.ams2.redhat.com [10.36.113.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AD9265C1BD;
        Wed,  6 May 2020 09:50:58 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>
Subject: [PATCH v1 15/17] pc: Support for virtio-mem-pci
Date:   Wed,  6 May 2020 11:49:46 +0200
Message-Id: <20200506094948.76388-16-david@redhat.com>
In-Reply-To: <20200506094948.76388-1-david@redhat.com>
References: <20200506094948.76388-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's wire it up similar to virtio-pmem. Also disallow unplug, so it's
harder for users to shoot themselves into the foot.

Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Eduardo Habkost <ehabkost@redhat.com>
Cc: Eric Blake <eblake@redhat.com>
Cc: Markus Armbruster <armbru@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 hw/i386/Kconfig |  1 +
 hw/i386/pc.c    | 49 ++++++++++++++++++++++++++++---------------------
 2 files changed, 29 insertions(+), 21 deletions(-)

diff --git a/hw/i386/Kconfig b/hw/i386/Kconfig
index c93f32f657..03e347b207 100644
--- a/hw/i386/Kconfig
+++ b/hw/i386/Kconfig
@@ -35,6 +35,7 @@ config PC
     select ACPI_PCI
     select ACPI_VMGENID
     select VIRTIO_PMEM_SUPPORTED
+    select VIRTIO_MEM_SUPPORTED
=20
 config PC_PCI
     bool
diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index f6b8431c8b..588804f895 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -86,6 +86,7 @@
 #include "hw/net/ne2000-isa.h"
 #include "standard-headers/asm-x86/bootparam.h"
 #include "hw/virtio/virtio-pmem-pci.h"
+#include "hw/virtio/virtio-mem-pci.h"
 #include "hw/mem/memory-device.h"
 #include "sysemu/replay.h"
 #include "qapi/qmp/qerror.h"
@@ -1654,8 +1655,8 @@ static void pc_cpu_pre_plug(HotplugHandler *hotplug=
_dev,
     numa_cpu_pre_plug(cpu_slot, dev, errp);
 }
=20
-static void pc_virtio_pmem_pci_pre_plug(HotplugHandler *hotplug_dev,
-                                        DeviceState *dev, Error **errp)
+static void pc_virtio_md_pci_pre_plug(HotplugHandler *hotplug_dev,
+                                      DeviceState *dev, Error **errp)
 {
     HotplugHandler *hotplug_dev2 =3D qdev_get_bus_hotplug_handler(dev);
     Error *local_err =3D NULL;
@@ -1666,7 +1667,8 @@ static void pc_virtio_pmem_pci_pre_plug(HotplugHand=
ler *hotplug_dev,
          * order. This should never be the case on x86, however better a=
dd
          * a safety net.
          */
-        error_setg(errp, "virtio-pmem-pci not supported on this bus.");
+        error_setg(errp,
+                   "virtio based memory devices not supported on this bu=
s.");
         return;
     }
     /*
@@ -1681,8 +1683,8 @@ static void pc_virtio_pmem_pci_pre_plug(HotplugHand=
ler *hotplug_dev,
     error_propagate(errp, local_err);
 }
=20
-static void pc_virtio_pmem_pci_plug(HotplugHandler *hotplug_dev,
-                                    DeviceState *dev, Error **errp)
+static void pc_virtio_md_pci_plug(HotplugHandler *hotplug_dev,
+                                  DeviceState *dev, Error **errp)
 {
     HotplugHandler *hotplug_dev2 =3D qdev_get_bus_hotplug_handler(dev);
     Error *local_err =3D NULL;
@@ -1700,17 +1702,17 @@ static void pc_virtio_pmem_pci_plug(HotplugHandle=
r *hotplug_dev,
     error_propagate(errp, local_err);
 }
=20
-static void pc_virtio_pmem_pci_unplug_request(HotplugHandler *hotplug_de=
v,
-                                              DeviceState *dev, Error **=
errp)
+static void pc_virtio_md_pci_unplug_request(HotplugHandler *hotplug_dev,
+                                            DeviceState *dev, Error **er=
rp)
 {
-    /* We don't support virtio pmem hot unplug */
-    error_setg(errp, "virtio pmem device unplug not supported.");
+    /* We don't support hot unplug of virtio based memory devices */
+    error_setg(errp, "virtio based memory devices cannot be unplugged.")=
;
 }
=20
-static void pc_virtio_pmem_pci_unplug(HotplugHandler *hotplug_dev,
-                                      DeviceState *dev, Error **errp)
+static void pc_virtio_md_pci_unplug(HotplugHandler *hotplug_dev,
+                                    DeviceState *dev, Error **errp)
 {
-    /* We don't support virtio pmem hot unplug */
+    /* We don't support hot unplug of virtio based memory devices */
 }
=20
 static void pc_machine_device_pre_plug_cb(HotplugHandler *hotplug_dev,
@@ -1720,8 +1722,9 @@ static void pc_machine_device_pre_plug_cb(HotplugHa=
ndler *hotplug_dev,
         pc_memory_pre_plug(hotplug_dev, dev, errp);
     } else if (object_dynamic_cast(OBJECT(dev), TYPE_CPU)) {
         pc_cpu_pre_plug(hotplug_dev, dev, errp);
-    } else if (object_dynamic_cast(OBJECT(dev), TYPE_VIRTIO_PMEM_PCI)) {
-        pc_virtio_pmem_pci_pre_plug(hotplug_dev, dev, errp);
+    } else if (object_dynamic_cast(OBJECT(dev), TYPE_VIRTIO_PMEM_PCI) ||
+               object_dynamic_cast(OBJECT(dev), TYPE_VIRTIO_MEM_PCI)) {
+        pc_virtio_md_pci_pre_plug(hotplug_dev, dev, errp);
     }
 }
=20
@@ -1732,8 +1735,9 @@ static void pc_machine_device_plug_cb(HotplugHandle=
r *hotplug_dev,
         pc_memory_plug(hotplug_dev, dev, errp);
     } else if (object_dynamic_cast(OBJECT(dev), TYPE_CPU)) {
         pc_cpu_plug(hotplug_dev, dev, errp);
-    } else if (object_dynamic_cast(OBJECT(dev), TYPE_VIRTIO_PMEM_PCI)) {
-        pc_virtio_pmem_pci_plug(hotplug_dev, dev, errp);
+    } else if (object_dynamic_cast(OBJECT(dev), TYPE_VIRTIO_PMEM_PCI) ||
+               object_dynamic_cast(OBJECT(dev), TYPE_VIRTIO_MEM_PCI)) {
+        pc_virtio_md_pci_plug(hotplug_dev, dev, errp);
     }
 }
=20
@@ -1744,8 +1748,9 @@ static void pc_machine_device_unplug_request_cb(Hot=
plugHandler *hotplug_dev,
         pc_memory_unplug_request(hotplug_dev, dev, errp);
     } else if (object_dynamic_cast(OBJECT(dev), TYPE_CPU)) {
         pc_cpu_unplug_request_cb(hotplug_dev, dev, errp);
-    } else if (object_dynamic_cast(OBJECT(dev), TYPE_VIRTIO_PMEM_PCI)) {
-        pc_virtio_pmem_pci_unplug_request(hotplug_dev, dev, errp);
+    } else if (object_dynamic_cast(OBJECT(dev), TYPE_VIRTIO_PMEM_PCI) ||
+               object_dynamic_cast(OBJECT(dev), TYPE_VIRTIO_MEM_PCI)) {
+        pc_virtio_md_pci_unplug_request(hotplug_dev, dev, errp);
     } else {
         error_setg(errp, "acpi: device unplug request for not supported =
device"
                    " type: %s", object_get_typename(OBJECT(dev)));
@@ -1759,8 +1764,9 @@ static void pc_machine_device_unplug_cb(HotplugHand=
ler *hotplug_dev,
         pc_memory_unplug(hotplug_dev, dev, errp);
     } else if (object_dynamic_cast(OBJECT(dev), TYPE_CPU)) {
         pc_cpu_unplug_cb(hotplug_dev, dev, errp);
-    } else if (object_dynamic_cast(OBJECT(dev), TYPE_VIRTIO_PMEM_PCI)) {
-        pc_virtio_pmem_pci_unplug(hotplug_dev, dev, errp);
+    } else if (object_dynamic_cast(OBJECT(dev), TYPE_VIRTIO_PMEM_PCI) ||
+               object_dynamic_cast(OBJECT(dev), TYPE_VIRTIO_MEM_PCI)) {
+        pc_virtio_md_pci_unplug(hotplug_dev, dev, errp);
     } else {
         error_setg(errp, "acpi: device unplug for not supported device"
                    " type: %s", object_get_typename(OBJECT(dev)));
@@ -1772,7 +1778,8 @@ static HotplugHandler *pc_get_hotplug_handler(Machi=
neState *machine,
 {
     if (object_dynamic_cast(OBJECT(dev), TYPE_PC_DIMM) ||
         object_dynamic_cast(OBJECT(dev), TYPE_CPU) ||
-        object_dynamic_cast(OBJECT(dev), TYPE_VIRTIO_PMEM_PCI)) {
+        object_dynamic_cast(OBJECT(dev), TYPE_VIRTIO_PMEM_PCI) ||
+        object_dynamic_cast(OBJECT(dev), TYPE_VIRTIO_MEM_PCI)) {
         return HOTPLUG_HANDLER(machine);
     }
=20
--=20
2.25.3

