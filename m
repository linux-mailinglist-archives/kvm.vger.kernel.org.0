Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 409DBBC81A
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2019 14:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504972AbfIXMpb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Sep 2019 08:45:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55634 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2504968AbfIXMpa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Sep 2019 08:45:30 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 68DA585362;
        Tue, 24 Sep 2019 12:45:30 +0000 (UTC)
Received: from dritchie.redhat.com (unknown [10.33.36.128])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6B99360852;
        Tue, 24 Sep 2019 12:45:27 +0000 (UTC)
From:   Sergio Lopez <slp@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     mst@redhat.com, imammedo@redhat.com, marcel.apfelbaum@gmail.com,
        pbonzini@redhat.com, rth@twiddle.net, ehabkost@redhat.com,
        philmd@redhat.com, lersek@redhat.com, kraxel@redhat.com,
        mtosatti@redhat.com, kvm@vger.kernel.org,
        Sergio Lopez <slp@redhat.com>
Subject: [PATCH v4 3/8] hw/virtio: Factorize virtio-mmio headers
Date:   Tue, 24 Sep 2019 14:44:28 +0200
Message-Id: <20190924124433.96810-4-slp@redhat.com>
In-Reply-To: <20190924124433.96810-1-slp@redhat.com>
References: <20190924124433.96810-1-slp@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Tue, 24 Sep 2019 12:45:30 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Put QOM and main struct definition in a separate header file, so it
can be accessed from other components.

Signed-off-by: Sergio Lopez <slp@redhat.com>
---
 hw/virtio/virtio-mmio.c         | 35 +------------------
 include/hw/virtio/virtio-mmio.h | 60 +++++++++++++++++++++++++++++++++
 2 files changed, 61 insertions(+), 34 deletions(-)
 create mode 100644 include/hw/virtio/virtio-mmio.h

diff --git a/hw/virtio/virtio-mmio.c b/hw/virtio/virtio-mmio.c
index eccc795f28..6be6b298d5 100644
--- a/hw/virtio/virtio-mmio.c
+++ b/hw/virtio/virtio-mmio.c
@@ -29,44 +29,11 @@
 #include "qemu/host-utils.h"
 #include "qemu/module.h"
 #include "sysemu/kvm.h"
-#include "hw/virtio/virtio-bus.h"
+#include "hw/virtio/virtio-mmio.h"
 #include "qemu/error-report.h"
 #include "qemu/log.h"
 #include "trace.h"
 
-/* QOM macros */
-/* virtio-mmio-bus */
-#define TYPE_VIRTIO_MMIO_BUS "virtio-mmio-bus"
-#define VIRTIO_MMIO_BUS(obj) \
-        OBJECT_CHECK(VirtioBusState, (obj), TYPE_VIRTIO_MMIO_BUS)
-#define VIRTIO_MMIO_BUS_GET_CLASS(obj) \
-        OBJECT_GET_CLASS(VirtioBusClass, (obj), TYPE_VIRTIO_MMIO_BUS)
-#define VIRTIO_MMIO_BUS_CLASS(klass) \
-        OBJECT_CLASS_CHECK(VirtioBusClass, (klass), TYPE_VIRTIO_MMIO_BUS)
-
-/* virtio-mmio */
-#define TYPE_VIRTIO_MMIO "virtio-mmio"
-#define VIRTIO_MMIO(obj) \
-        OBJECT_CHECK(VirtIOMMIOProxy, (obj), TYPE_VIRTIO_MMIO)
-
-#define VIRT_MAGIC 0x74726976 /* 'virt' */
-#define VIRT_VERSION 1
-#define VIRT_VENDOR 0x554D4551 /* 'QEMU' */
-
-typedef struct {
-    /* Generic */
-    SysBusDevice parent_obj;
-    MemoryRegion iomem;
-    qemu_irq irq;
-    /* Guest accessible state needing migration and reset */
-    uint32_t host_features_sel;
-    uint32_t guest_features_sel;
-    uint32_t guest_page_shift;
-    /* virtio-bus */
-    VirtioBusState bus;
-    bool format_transport_address;
-} VirtIOMMIOProxy;
-
 static bool virtio_mmio_ioeventfd_enabled(DeviceState *d)
 {
     return kvm_eventfds_enabled();
diff --git a/include/hw/virtio/virtio-mmio.h b/include/hw/virtio/virtio-mmio.h
new file mode 100644
index 0000000000..2f3973f8c7
--- /dev/null
+++ b/include/hw/virtio/virtio-mmio.h
@@ -0,0 +1,60 @@
+/*
+ * Virtio MMIO bindings
+ *
+ * Copyright (c) 2011 Linaro Limited
+ *
+ * Author:
+ *  Peter Maydell <peter.maydell@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef QEMU_VIRTIO_MMIO_H
+#define QEMU_VIRTIO_MMIO_H
+
+#include "hw/virtio/virtio-bus.h"
+
+/* QOM macros */
+/* virtio-mmio-bus */
+#define TYPE_VIRTIO_MMIO_BUS "virtio-mmio-bus"
+#define VIRTIO_MMIO_BUS(obj) \
+        OBJECT_CHECK(VirtioBusState, (obj), TYPE_VIRTIO_MMIO_BUS)
+#define VIRTIO_MMIO_BUS_GET_CLASS(obj) \
+        OBJECT_GET_CLASS(VirtioBusClass, (obj), TYPE_VIRTIO_MMIO_BUS)
+#define VIRTIO_MMIO_BUS_CLASS(klass) \
+        OBJECT_CLASS_CHECK(VirtioBusClass, (klass), TYPE_VIRTIO_MMIO_BUS)
+
+/* virtio-mmio */
+#define TYPE_VIRTIO_MMIO "virtio-mmio"
+#define VIRTIO_MMIO(obj) \
+        OBJECT_CHECK(VirtIOMMIOProxy, (obj), TYPE_VIRTIO_MMIO)
+
+#define VIRT_MAGIC 0x74726976 /* 'virt' */
+#define VIRT_VERSION 1
+#define VIRT_VENDOR 0x554D4551 /* 'QEMU' */
+
+typedef struct {
+    /* Generic */
+    SysBusDevice parent_obj;
+    MemoryRegion iomem;
+    qemu_irq irq;
+    /* Guest accessible state needing migration and reset */
+    uint32_t host_features_sel;
+    uint32_t guest_features_sel;
+    uint32_t guest_page_shift;
+    /* virtio-bus */
+    VirtioBusState bus;
+    bool format_transport_address;
+} VirtIOMMIOProxy;
+
+#endif
-- 
2.21.0

