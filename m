Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 528AD2F2745
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 05:46:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732061AbhALEp5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jan 2021 23:45:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731559AbhALEpx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jan 2021 23:45:53 -0500
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 390B4C061786
        for <kvm@vger.kernel.org>; Mon, 11 Jan 2021 20:45:13 -0800 (PST)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4DFJ0R1z8nz9sjB; Tue, 12 Jan 2021 15:45:11 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1610426711;
        bh=gBUeaK98QZtVQEHJbntNBZNi+IibOo0phuHzavixG5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NfFyzhTO0FtNXPj/fWKIyu2EHfZJ9McjaJt/5Z/ku/lzdiBKDqnhs6ywjBpc1wmhI
         FxlajbzW2vHECdF6OLPr1oE0SX+4vpDq9mrJjFEdhneK5AhNAsHw/O6N59xoF31bpg
         irkF7R9qBWZlEkhlQLmxslNbpHd6SW1lwqE1lHr8=
From:   David Gibson <david@gibson.dropbear.id.au>
To:     pasic@linux.ibm.com, brijesh.singh@amd.com, pair@us.ibm.com,
        dgilbert@redhat.com, qemu-devel@nongnu.org
Cc:     andi.kleen@intel.com, qemu-ppc@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Greg Kurz <groug@kaod.org>, frankja@linux.ibm.com,
        thuth@redhat.com, Christian Borntraeger <borntraeger@de.ibm.com>,
        mdroth@linux.vnet.ibm.com, richard.henderson@linaro.org,
        kvm@vger.kernel.org,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eduardo Habkost <ehabkost@redhat.com>, david@redhat.com,
        Cornelia Huck <cohuck@redhat.com>, mst@redhat.com,
        qemu-s390x@nongnu.org, pragyansri.pathi@intel.com,
        jun.nakajima@intel.com
Subject: [PATCH v6 02/13] confidential guest support: Introduce new confidential guest support class
Date:   Tue, 12 Jan 2021 15:44:57 +1100
Message-Id: <20210112044508.427338-3-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210112044508.427338-1-david@gibson.dropbear.id.au>
References: <20210112044508.427338-1-david@gibson.dropbear.id.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Several architectures have mechanisms which are designed to protect guest
memory from interference or eavesdropping by a compromised hypervisor.  AMD
SEV does this with in-chip memory encryption and Intel's MKTME can do
similar things.  POWER's Protected Execution Framework (PEF) accomplishes a
similar goal using an ultravisor and new memory protection features,
instead of encryption.

To (partially) unify handling for these, this introduces a new
ConfidentialGuestSupport QOM base class.  "Confidential" is kind of vague,
but "confidential computing" seems to be the buzzword about these schemes,
and "secure" or "protected" are often used in connection to unrelated
things (such as hypervisor-from-guest or guest-from-guest security).

The "support" in the name is significant because in at least some of the
cases it requires the guest to take specific actions in order to protect
itself from hypervisor eavesdropping.

Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
---
 backends/confidential-guest-support.c     | 30 +++++++++++++++
 backends/meson.build                      |  1 +
 include/exec/confidential-guest-support.h | 46 +++++++++++++++++++++++
 include/qemu/typedefs.h                   |  1 +
 target/i386/sev.c                         |  3 +-
 5 files changed, 80 insertions(+), 1 deletion(-)
 create mode 100644 backends/confidential-guest-support.c
 create mode 100644 include/exec/confidential-guest-support.h

diff --git a/backends/confidential-guest-support.c b/backends/confidential-guest-support.c
new file mode 100644
index 0000000000..2c7793c74f
--- /dev/null
+++ b/backends/confidential-guest-support.c
@@ -0,0 +1,30 @@
+/*
+ * QEMU Confidential Guest support
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
+#include "exec/confidential-guest-support.h"
+
+static const TypeInfo confidential_guest_support_info = {
+    .parent = TYPE_OBJECT,
+    .name = TYPE_CONFIDENTIAL_GUEST_SUPPORT,
+    .class_size = sizeof(ConfidentialGuestSupportClass),
+    .instance_size = sizeof(ConfidentialGuestSupport),
+};
+
+static void confidential_guest_support_register_types(void)
+{
+    type_register_static(&confidential_guest_support_info);
+}
+
+type_init(confidential_guest_support_register_types)
diff --git a/backends/meson.build b/backends/meson.build
index 484456ece7..d4221831fc 100644
--- a/backends/meson.build
+++ b/backends/meson.build
@@ -6,6 +6,7 @@ softmmu_ss.add([files(
   'rng-builtin.c',
   'rng-egd.c',
   'rng.c',
+  'confidential-guest-support.c',
 ), numa])
 
 softmmu_ss.add(when: 'CONFIG_POSIX', if_true: files('rng-random.c'))
diff --git a/include/exec/confidential-guest-support.h b/include/exec/confidential-guest-support.h
new file mode 100644
index 0000000000..f9cf170802
--- /dev/null
+++ b/include/exec/confidential-guest-support.h
@@ -0,0 +1,46 @@
+/*
+ * QEMU Confidential Guest support
+ *   This interface describes the common pieces between various
+ *   schemes for protecting guest memory or other state against a
+ *   compromised hypervisor.  This includes memory encryption (AMD's
+ *   SEV and Intel's MKTME) or special protection modes (PEF on POWER,
+ *   or PV on s390x).
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
+#ifndef QEMU_CONFIDENTIAL_GUEST_SUPPORT_H
+#define QEMU_CONFIDENTIAL_GUEST_SUPPORT_H
+
+#ifndef CONFIG_USER_ONLY
+
+#include "qom/object.h"
+
+#define TYPE_CONFIDENTIAL_GUEST_SUPPORT "confidential-guest-support"
+#define CONFIDENTIAL_GUEST_SUPPORT(obj)                                    \
+    OBJECT_CHECK(ConfidentialGuestSupport, (obj),                          \
+                 TYPE_CONFIDENTIAL_GUEST_SUPPORT)
+#define CONFIDENTIAL_GUEST_SUPPORT_CLASS(klass)                            \
+    OBJECT_CLASS_CHECK(ConfidentialGuestSupportClass, (klass),             \
+                       TYPE_CONFIDENTIAL_GUEST_SUPPORT)
+#define CONFIDENTIAL_GUEST_SUPPORT_GET_CLASS(obj)                          \
+    OBJECT_GET_CLASS(ConfidentialGuestSupportClass, (obj),                 \
+                     TYPE_CONFIDENTIAL_GUEST_SUPPORT)
+
+struct ConfidentialGuestSupport {
+    Object parent;
+};
+
+typedef struct ConfidentialGuestSupportClass {
+    ObjectClass parent;
+} ConfidentialGuestSupportClass;
+
+#endif /* !CONFIG_USER_ONLY */
+
+#endif /* QEMU_CONFIDENTIAL_GUEST_SUPPORT_H */
diff --git a/include/qemu/typedefs.h b/include/qemu/typedefs.h
index 976b529dfb..33685c79ed 100644
--- a/include/qemu/typedefs.h
+++ b/include/qemu/typedefs.h
@@ -36,6 +36,7 @@ typedef struct BusState BusState;
 typedef struct Chardev Chardev;
 typedef struct CompatProperty CompatProperty;
 typedef struct CoMutex CoMutex;
+typedef struct ConfidentialGuestSupport ConfidentialGuestSupport;
 typedef struct CPUAddressSpace CPUAddressSpace;
 typedef struct CPUState CPUState;
 typedef struct DeviceListener DeviceListener;
diff --git a/target/i386/sev.c b/target/i386/sev.c
index 1546606811..6b49925f51 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -31,6 +31,7 @@
 #include "qom/object.h"
 #include "exec/address-spaces.h"
 #include "monitor/monitor.h"
+#include "exec/confidential-guest-support.h"
 
 #define TYPE_SEV_GUEST "sev-guest"
 OBJECT_DECLARE_SIMPLE_TYPE(SevGuestState, SEV_GUEST)
@@ -322,7 +323,7 @@ sev_guest_instance_init(Object *obj)
 
 /* sev guest info */
 static const TypeInfo sev_guest_info = {
-    .parent = TYPE_OBJECT,
+    .parent = TYPE_CONFIDENTIAL_GUEST_SUPPORT,
     .name = TYPE_SEV_GUEST,
     .instance_size = sizeof(SevGuestState),
     .instance_finalize = sev_guest_finalize,
-- 
2.29.2

