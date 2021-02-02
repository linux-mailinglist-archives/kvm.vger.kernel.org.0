Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93ED130B63E
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 05:14:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231605AbhBBEOL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 23:14:11 -0500
Received: from ozlabs.org ([203.11.71.1]:45035 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231586AbhBBEOB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Feb 2021 23:14:01 -0500
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4DVBHy2H5Pz9tkT; Tue,  2 Feb 2021 15:13:18 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1612239198;
        bh=wapW+hFPonrY5NcNhJL2s94tGKTRKw27BwqVT6c2VhM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kxrndv7WCmuM7u8JHMgB7B+Agc7901eUVObmDzzSI88LwsaT6hImoIICXv3cUnsPb
         5UTZ1927wgxoDi+DRpBEDCHFsQAcwygcYD7bsTG0YxgN2yyej5M7j4Wz5d4oRH9BkH
         X2QKaT9Ia/7X6+ZPJBlNpd9w5rPhrAfx1CJUURck=
From:   David Gibson <david@gibson.dropbear.id.au>
To:     dgilbert@redhat.com, pair@us.ibm.com, qemu-devel@nongnu.org,
        brijesh.singh@amd.com, pasic@linux.ibm.com
Cc:     pragyansri.pathi@intel.com, Greg Kurz <groug@kaod.org>,
        richard.henderson@linaro.org, berrange@redhat.com,
        David Hildenbrand <david@redhat.com>,
        mdroth@linux.vnet.ibm.com, kvm@vger.kernel.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        pbonzini@redhat.com, mtosatti@redhat.com, borntraeger@de.ibm.com,
        Cornelia Huck <cohuck@redhat.com>, qemu-ppc@nongnu.org,
        David Gibson <david@gibson.dropbear.id.au>,
        qemu-s390x@nongnu.org, thuth@redhat.com, mst@redhat.com,
        frankja@linux.ibm.com, jun.nakajima@intel.com,
        andi.kleen@intel.com, Eduardo Habkost <ehabkost@redhat.com>
Subject: [PATCH v8 02/13] confidential guest support: Introduce new confidential guest support class
Date:   Tue,  2 Feb 2021 15:13:04 +1100
Message-Id: <20210202041315.196530-3-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210202041315.196530-1-david@gibson.dropbear.id.au>
References: <20210202041315.196530-1-david@gibson.dropbear.id.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Several architectures have mechanisms which are designed to protect
guest memory from interference or eavesdropping by a compromised
hypervisor.  AMD SEV does this with in-chip memory encryption and
Intel's TDX can do similar things.  POWER's Protected Execution
Framework (PEF) accomplishes a similar goal using an ultravisor and
new memory protection features, instead of encryption.

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
 backends/confidential-guest-support.c     | 33 ++++++++++++++++++++
 backends/meson.build                      |  1 +
 include/exec/confidential-guest-support.h | 38 +++++++++++++++++++++++
 include/qemu/typedefs.h                   |  1 +
 target/i386/sev.c                         |  5 +--
 5 files changed, 76 insertions(+), 2 deletions(-)
 create mode 100644 backends/confidential-guest-support.c
 create mode 100644 include/exec/confidential-guest-support.h

diff --git a/backends/confidential-guest-support.c b/backends/confidential-guest-support.c
new file mode 100644
index 0000000000..052fde8db0
--- /dev/null
+++ b/backends/confidential-guest-support.c
@@ -0,0 +1,33 @@
+/*
+ * QEMU Confidential Guest support
+ *
+ * Copyright Red Hat.
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
+OBJECT_DEFINE_ABSTRACT_TYPE(ConfidentialGuestSupport,
+                            confidential_guest_support,
+                            CONFIDENTIAL_GUEST_SUPPORT,
+                            OBJECT)
+
+static void confidential_guest_support_class_init(ObjectClass *oc, void *data)
+{
+}
+
+static void confidential_guest_support_init(Object *obj)
+{
+}
+
+static void confidential_guest_support_finalize(Object *obj)
+{
+}
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
index 0000000000..3db6380e63
--- /dev/null
+++ b/include/exec/confidential-guest-support.h
@@ -0,0 +1,38 @@
+/*
+ * QEMU Confidential Guest support
+ *   This interface describes the common pieces between various
+ *   schemes for protecting guest memory or other state against a
+ *   compromised hypervisor.  This includes memory encryption (AMD's
+ *   SEV and Intel's MKTME) or special protection modes (PEF on POWER,
+ *   or PV on s390x).
+ *
+ * Copyright Red Hat.
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
+OBJECT_DECLARE_SIMPLE_TYPE(ConfidentialGuestSupport, CONFIDENTIAL_GUEST_SUPPORT)
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
index 68deb74ef6..dc39b05c30 100644
--- a/include/qemu/typedefs.h
+++ b/include/qemu/typedefs.h
@@ -37,6 +37,7 @@ typedef struct Chardev Chardev;
 typedef struct Clock Clock;
 typedef struct CompatProperty CompatProperty;
 typedef struct CoMutex CoMutex;
+typedef struct ConfidentialGuestSupport ConfidentialGuestSupport;
 typedef struct CPUAddressSpace CPUAddressSpace;
 typedef struct CPUState CPUState;
 typedef struct DeviceListener DeviceListener;
diff --git a/target/i386/sev.c b/target/i386/sev.c
index 1546606811..b738dc45b6 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -31,6 +31,7 @@
 #include "qom/object.h"
 #include "exec/address-spaces.h"
 #include "monitor/monitor.h"
+#include "exec/confidential-guest-support.h"
 
 #define TYPE_SEV_GUEST "sev-guest"
 OBJECT_DECLARE_SIMPLE_TYPE(SevGuestState, SEV_GUEST)
@@ -47,7 +48,7 @@ OBJECT_DECLARE_SIMPLE_TYPE(SevGuestState, SEV_GUEST)
  *         -machine ...,memory-encryption=sev0
  */
 struct SevGuestState {
-    Object parent_obj;
+    ConfidentialGuestSupport parent_obj;
 
     /* configuration parameters */
     char *sev_device;
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

