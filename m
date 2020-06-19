Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C59A3200004
	for <lists+kvm@lfdr.de>; Fri, 19 Jun 2020 04:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727915AbgFSCGM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Jun 2020 22:06:12 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:36545 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727911AbgFSCGK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Jun 2020 22:06:10 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 49p2GS1dYgz9sNR; Fri, 19 Jun 2020 12:06:08 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1592532368;
        bh=gLWD9Joj8IIB/tTWGt6QwLtKruFK1pcFHrhx6E7+hAA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nJSanPg8NeKsUcm7P+zX/JVyECFc0xANus0zN7ZXcMfswdMa7g4E9Y+wA81Bpfj3y
         +KrsONmNKbqxLTMakO/mYVlUf+9y/pUO96TnOtTv140aKrE7ioEdjqWS8fUOPnj4rj
         AAWfHyWIaUknWsxeYZWj/0V9n9jwPbvL5JTJx9BI=
From:   David Gibson <david@gibson.dropbear.id.au>
To:     qemu-devel@nongnu.org, brijesh.singh@amd.com, pair@us.ibm.com,
        pbonzini@redhat.com, dgilbert@redhat.com, frankja@linux.ibm.com
Cc:     Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, kvm@vger.kernel.org,
        qemu-ppc@nongnu.org, mst@redhat.com, mdroth@linux.vnet.ibm.com,
        Richard Henderson <rth@twiddle.net>, cohuck@redhat.com,
        pasic@linux.ibm.com, Eduardo Habkost <ehabkost@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        qemu-s390x@nongnu.org, david@redhat.com
Subject: [PATCH v3 1/9] host trust limitation: Introduce new host trust limitation interface
Date:   Fri, 19 Jun 2020 12:05:54 +1000
Message-Id: <20200619020602.118306-2-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200619020602.118306-1-david@gibson.dropbear.id.au>
References: <20200619020602.118306-1-david@gibson.dropbear.id.au>
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
---
 backends/Makefile.objs               |  2 ++
 backends/host-trust-limitation.c     | 29 ++++++++++++++++++++++++
 include/exec/host-trust-limitation.h | 33 ++++++++++++++++++++++++++++
 include/qemu/typedefs.h              |  1 +
 4 files changed, 65 insertions(+)
 create mode 100644 backends/host-trust-limitation.c
 create mode 100644 include/exec/host-trust-limitation.h

diff --git a/backends/Makefile.objs b/backends/Makefile.objs
index 28a847cd57..af761c9ab1 100644
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
index ce4a78b687..f75c7eb2f2 100644
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

