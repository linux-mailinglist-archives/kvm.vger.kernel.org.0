Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F36C11DC5C3
	for <lists+kvm@lfdr.de>; Thu, 21 May 2020 05:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728260AbgEUDnR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 23:43:17 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:40197 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728218AbgEUDnQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 May 2020 23:43:16 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 49SFns3n23z9sTq; Thu, 21 May 2020 13:43:13 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1590032593;
        bh=5KLDWlcKYyTYo3NQYirtMT0jjuuJjP++orsplm2jw/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GPSqg05BjZwbm6erLBBKafVtKtXNxUDW5hP+sPLfb1kphPhopYmRy2Gqgw3KSXVHu
         4PAshUTPvB228yu4FvEzJy1BXcoAw2appFcR2QEIunhprXziTsV6ilJqLAjQHaXXNN
         Am+4HY9hn40sP0efS/rBIyJhmF7TRy+ZgfZ5Syfo=
From:   David Gibson <david@gibson.dropbear.id.au>
To:     qemu-devel@nongnu.org, brijesh.singh@amd.com,
        frankja@linux.ibm.com, dgilbert@redhat.com, pair@us.ibm.com
Cc:     qemu-ppc@nongnu.org, kvm@vger.kernel.org,
        David Gibson <david@gibson.dropbear.id.au>,
        mdroth@linux.vnet.ibm.com, cohuck@redhat.com,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: [RFC v2 10/18] guest memory protection: Add guest memory protection interface
Date:   Thu, 21 May 2020 13:42:56 +1000
Message-Id: <20200521034304.340040-11-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200521034304.340040-1-david@gibson.dropbear.id.au>
References: <20200521034304.340040-1-david@gibson.dropbear.id.au>
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

This introduces a new GuestMemoryProtection QOM interface which we'll use
to (partially) unify handling of these various mechanisms.

Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
---
 backends/Makefile.objs                 |  2 ++
 backends/guest-memory-protection.c     | 29 +++++++++++++++++++++
 include/exec/guest-memory-protection.h | 36 ++++++++++++++++++++++++++
 3 files changed, 67 insertions(+)
 create mode 100644 backends/guest-memory-protection.c
 create mode 100644 include/exec/guest-memory-protection.h

diff --git a/backends/Makefile.objs b/backends/Makefile.objs
index 28a847cd57..e4fb4f5280 100644
--- a/backends/Makefile.objs
+++ b/backends/Makefile.objs
@@ -21,3 +21,5 @@ common-obj-$(CONFIG_LINUX) += hostmem-memfd.o
 common-obj-$(CONFIG_GIO) += dbus-vmstate.o
 dbus-vmstate.o-cflags = $(GIO_CFLAGS)
 dbus-vmstate.o-libs = $(GIO_LIBS)
+
+common-obj-y += guest-memory-protection.o
diff --git a/backends/guest-memory-protection.c b/backends/guest-memory-protection.c
new file mode 100644
index 0000000000..7e538214f7
--- /dev/null
+++ b/backends/guest-memory-protection.c
@@ -0,0 +1,29 @@
+#/*
+ * QEMU Guest Memory Protection interface
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
+#include "exec/guest-memory-protection.h"
+
+static const TypeInfo guest_memory_protection_info = {
+    .name = TYPE_GUEST_MEMORY_PROTECTION,
+    .parent = TYPE_INTERFACE,
+    .class_size = sizeof(GuestMemoryProtectionClass),
+};
+
+static void guest_memory_protection_register_types(void)
+{
+    type_register_static(&guest_memory_protection_info);
+}
+
+type_init(guest_memory_protection_register_types)
diff --git a/include/exec/guest-memory-protection.h b/include/exec/guest-memory-protection.h
new file mode 100644
index 0000000000..38e9b01667
--- /dev/null
+++ b/include/exec/guest-memory-protection.h
@@ -0,0 +1,36 @@
+#/*
+ * QEMU Guest Memory Protection interface
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
+#ifndef QEMU_GUEST_MEMORY_PROTECTION_H
+#define QEMU_GUEST_MEMORY_PROTECTION_H
+
+#include "qom/object.h"
+
+typedef struct GuestMemoryProtection GuestMemoryProtection;
+
+#define TYPE_GUEST_MEMORY_PROTECTION "guest-memory-protection"
+#define GUEST_MEMORY_PROTECTION(obj)                                    \
+    INTERFACE_CHECK(GuestMemoryProtection, (obj),                       \
+                    TYPE_GUEST_MEMORY_PROTECTION)
+#define GUEST_MEMORY_PROTECTION_CLASS(klass)                            \
+    OBJECT_CLASS_CHECK(GuestMemoryProtectionClass, (klass),             \
+                       TYPE_GUEST_MEMORY_PROTECTION)
+#define GUEST_MEMORY_PROTECTION_GET_CLASS(obj)                          \
+    OBJECT_GET_CLASS(GuestMemoryProtectionClass, (obj),                 \
+                     TYPE_GUEST_MEMORY_PROTECTION)
+
+typedef struct GuestMemoryProtectionClass {
+    InterfaceClass parent;
+} GuestMemoryProtectionClass;
+
+#endif /* QEMU_GUEST_MEMORY_PROTECTION_H */
+
-- 
2.26.2

