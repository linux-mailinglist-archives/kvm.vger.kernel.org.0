Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB25322BC35
	for <lists+kvm@lfdr.de>; Fri, 24 Jul 2020 04:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbgGXC5u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jul 2020 22:57:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726381AbgGXC5t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jul 2020 22:57:49 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB05AC0619D3
        for <kvm@vger.kernel.org>; Thu, 23 Jul 2020 19:57:49 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4BCYlv33w0z9sSt; Fri, 24 Jul 2020 12:57:47 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1595559467;
        bh=aXMwhPSEkPHTpzErQPz4f4zNkJ2AVJxzRI0h3KgdOaE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I8R/r6K0P/IZg9wSKSjVg8EjaXlXMJmGktM9HhxalYdYd1gB7LXXgFxkcmHIyQHqn
         yxPqtlhIW670eVcVZpL3C3m1uB0rstBiBaYembN8TPTdsKUsNqvjo+wNjHOe5V8GXt
         lrZfMdVdBphNf6F/mciBlXPWMn31lLx5pZr4iUis=
From:   David Gibson <david@gibson.dropbear.id.au>
To:     dgilbert@redhat.com, frankja@linux.ibm.com, pair@us.ibm.com,
        qemu-devel@nongnu.org, pbonzini@redhat.com, brijesh.singh@amd.com
Cc:     ehabkost@redhat.com, marcel.apfelbaum@gmail.com,
        "Michael S. Tsirkin" <mst@redhat.com>, qemu-ppc@nongnu.org,
        kvm@vger.kernel.org, pasic@linux.ibm.com, qemu-s390x@nongnu.org,
        David Gibson <david@gibson.dropbear.id.au>,
        David Hildenbrand <david@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Richard Henderson <rth@twiddle.net>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        mdroth@linux.vnet.ibm.com, Thomas Huth <thuth@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: [for-5.2 v4 01/10] host trust limitation: Introduce new host trust limitation interface
Date:   Fri, 24 Jul 2020 12:57:35 +1000
Message-Id: <20200724025744.69644-2-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200724025744.69644-1-david@gibson.dropbear.id.au>
References: <20200724025744.69644-1-david@gibson.dropbear.id.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Several architectures have mechanisms which are designed to protect guest
memory from interference or eavesdropping by a compromised hypervisor.  AMD
SEV does this with in-chip memory encryption and Intel has a similar
mechanism.  POWER's Protected Execution Framework (PEF) accomplishes a
similar goal using an ultravisor and new memory protection features,
instead of encryption.

To (partially) unify handling for these, this introduces a new
HostTrustLimitation QOM interface.

Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
Acked-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 backends/Makefile.objs               |  2 ++
 backends/host-trust-limitation.c     | 29 ++++++++++++++++++++++++
 include/exec/host-trust-limitation.h | 33 ++++++++++++++++++++++++++++
 include/qemu/typedefs.h              |  1 +
 4 files changed, 65 insertions(+)
 create mode 100644 backends/host-trust-limitation.c
 create mode 100644 include/exec/host-trust-limitation.h

diff --git a/backends/Makefile.objs b/backends/Makefile.objs
index 22d204cb48..dcb8f58d31 100644
--- a/backends/Makefile.objs
+++ b/backends/Makefile.objs
@@ -21,3 +21,5 @@ common-obj-$(CONFIG_LINUX) += hostmem-memfd.o
 common-obj-$(CONFIG_GIO) += dbus-vmstate.o
 dbus-vmstate.o-cflags = $(GIO_CFLAGS)
 dbus-vmstate.o-libs = $(GIO_LIBS)
+
+common-obj-y += host-trust-limitation.o
diff --git a/backends/host-trust-limitation.c b/backends/host-trust-limitation.c
new file mode 100644
index 0000000000..96a381cd8a
--- /dev/null
+++ b/backends/host-trust-limitation.c
@@ -0,0 +1,29 @@
+/*
+ * QEMU Host Trust Limitation interface
+ *
+ * Copyright: David Gibson, Red Hat Inc. 2020
+ *
+ * Authors:
+ *  David Gibson <david@gibson.dropbear.id.au>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2 or
+ * later.  See the COPYING file in the top-level directory.
+ *
+ */
+
+#include "qemu/osdep.h"
+
+#include "exec/host-trust-limitation.h"
+
+static const TypeInfo host_trust_limitation_info = {
+    .name = TYPE_HOST_TRUST_LIMITATION,
+    .parent = TYPE_INTERFACE,
+    .class_size = sizeof(HostTrustLimitationClass),
+};
+
+static void host_trust_limitation_register_types(void)
+{
+    type_register_static(&host_trust_limitation_info);
+}
+
+type_init(host_trust_limitation_register_types)
diff --git a/include/exec/host-trust-limitation.h b/include/exec/host-trust-limitation.h
new file mode 100644
index 0000000000..03887b1be1
--- /dev/null
+++ b/include/exec/host-trust-limitation.h
@@ -0,0 +1,33 @@
+/*
+ * QEMU Host Trust Limitation interface
+ *
+ * Copyright: David Gibson, Red Hat Inc. 2020
+ *
+ * Authors:
+ *  David Gibson <david@gibson.dropbear.id.au>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2 or
+ * later.  See the COPYING file in the top-level directory.
+ *
+ */
+#ifndef QEMU_HOST_TRUST_LIMITATION_H
+#define QEMU_HOST_TRUST_LIMITATION_H
+
+#include "qom/object.h"
+
+#define TYPE_HOST_TRUST_LIMITATION "host-trust-limitation"
+#define HOST_TRUST_LIMITATION(obj)                                    \
+    INTERFACE_CHECK(HostTrustLimitation, (obj),                       \
+                    TYPE_HOST_TRUST_LIMITATION)
+#define HOST_TRUST_LIMITATION_CLASS(klass)                            \
+    OBJECT_CLASS_CHECK(HostTrustLimitationClass, (klass),             \
+                       TYPE_HOST_TRUST_LIMITATION)
+#define HOST_TRUST_LIMITATION_GET_CLASS(obj)                          \
+    OBJECT_GET_CLASS(HostTrustLimitationClass, (obj),                 \
+                     TYPE_HOST_TRUST_LIMITATION)
+
+typedef struct HostTrustLimitationClass {
+    InterfaceClass parent;
+} HostTrustLimitationClass;
+
+#endif /* QEMU_HOST_TRUST_LIMITATION_H */
diff --git a/include/qemu/typedefs.h b/include/qemu/typedefs.h
index 427027a970..624d59c037 100644
--- a/include/qemu/typedefs.h
+++ b/include/qemu/typedefs.h
@@ -51,6 +51,7 @@ typedef struct FWCfgIoState FWCfgIoState;
 typedef struct FWCfgMemState FWCfgMemState;
 typedef struct FWCfgState FWCfgState;
 typedef struct HostMemoryBackend HostMemoryBackend;
+typedef struct HostTrustLimitation HostTrustLimitation;
 typedef struct I2CBus I2CBus;
 typedef struct I2SCodec I2SCodec;
 typedef struct IOMMUMemoryRegion IOMMUMemoryRegion;
-- 
2.26.2

