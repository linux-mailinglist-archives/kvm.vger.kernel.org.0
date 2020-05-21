Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8D0B1DC5CA
	for <lists+kvm@lfdr.de>; Thu, 21 May 2020 05:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728272AbgEUDnU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 23:43:20 -0400
Received: from ozlabs.org ([203.11.71.1]:34267 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728229AbgEUDnT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 May 2020 23:43:19 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 49SFns6cHlz9sV6; Thu, 21 May 2020 13:43:13 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1590032593;
        bh=nm9xB2V5R/0lVmUDvJmT+YhtEegXvU4xCUn008zu1Y0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J76UE+l8Q9zlvDFZqaaUtPjqUeTJjmI3FTmuPrNug7bZHMqfkVrajRLwYSd2DBlOf
         ZP9UcfOGw4fCrdb/qBjBAR1yx6znI7e5nkptHh1km7squAu7TjCboLDJUA+0hlt3B8
         +0IL111yZzXR9CWIWwNqwxJ+jZ/9kphyDwN3JQqw=
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
Subject: [RFC v2 14/18] guest memory protection: Rework the "memory-encryption" property
Date:   Thu, 21 May 2020 13:43:00 +1000
Message-Id: <20200521034304.340040-15-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200521034304.340040-1-david@gibson.dropbear.id.au>
References: <20200521034304.340040-1-david@gibson.dropbear.id.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently the "memory-encryption" property is only looked at once we get to
kvm_init().  Although protection of guest memory from the hypervisor isn't
something that could really ever work with TCG, it's not conceptually tied
to the KVM accelerator.

In addition, the way the string property is resolved to an object is
almost identical to how a QOM link property is handled.

So, create a new "guest-memory-protection" link property which sets
this QOM interface link directly in the machine.  For compatibility we
keep the "memory-encryption" property, but now implemented in terms of
the new property.

Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
---
 accel/kvm/kvm-all.c | 23 +++++++----------------
 hw/core/machine.c   | 41 ++++++++++++++++++++++++++++++++++++-----
 include/hw/boards.h |  4 +++-
 3 files changed, 46 insertions(+), 22 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 5cf1a397e3..3588adf1e1 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2102,25 +2102,16 @@ static int kvm_init(MachineState *ms)
      * if memory encryption object is specified then initialize the memory
      * encryption context.
      */
-    if (ms->memory_encryption) {
-        Object *obj = object_resolve_path_component(object_get_objects_root(),
-                                                    ms->memory_encryption);
-
-        if (object_dynamic_cast(obj, TYPE_GUEST_MEMORY_PROTECTION)) {
-            GuestMemoryProtection *gmpo = GUEST_MEMORY_PROTECTION(obj);
-            GuestMemoryProtectionClass *gmpc =
-                GUEST_MEMORY_PROTECTION_GET_CLASS(gmpo);
-
-            ret = gmpc->kvm_init(gmpo);
-            if (ret < 0) {
-                goto err;
-            }
+    if (ms->gmpo) {
+        GuestMemoryProtectionClass *gmpc =
+            GUEST_MEMORY_PROTECTION_GET_CLASS(ms->gmpo);
 
-            kvm_state->guest_memory_protection = gmpo;
-        } else {
-            ret = -1;
+        ret = gmpc->kvm_init(ms->gmpo);
+        if (ret < 0) {
             goto err;
         }
+
+        kvm_state->guest_memory_protection = ms->gmpo;
     }
 
     ret = kvm_arch_init(ms, s);
diff --git a/hw/core/machine.c b/hw/core/machine.c
index e75f0b73d0..88d699bceb 100644
--- a/hw/core/machine.c
+++ b/hw/core/machine.c
@@ -27,6 +27,7 @@
 #include "hw/pci/pci.h"
 #include "hw/mem/nvdimm.h"
 #include "migration/vmstate.h"
+#include "exec/guest-memory-protection.h"
 
 GlobalProperty hw_compat_5_0[] = {};
 const size_t hw_compat_5_0_len = G_N_ELEMENTS(hw_compat_5_0);
@@ -419,16 +420,37 @@ static char *machine_get_memory_encryption(Object *obj, Error **errp)
 {
     MachineState *ms = MACHINE(obj);
 
-    return g_strdup(ms->memory_encryption);
+    if (ms->gmpo) {
+        return object_get_canonical_path_component(OBJECT(ms->gmpo));
+    }
+
+    return NULL;
 }
 
 static void machine_set_memory_encryption(Object *obj, const char *value,
                                         Error **errp)
 {
-    MachineState *ms = MACHINE(obj);
+    Object *gmpo =
+        object_resolve_path_component(object_get_objects_root(), value);
+
+    if (!gmpo) {
+        error_setg(errp, "No such memory encryption object '%s'", value);
+        return;
+    }
 
-    g_free(ms->memory_encryption);
-    ms->memory_encryption = g_strdup(value);
+    object_property_set_link(obj, gmpo, "guest-memory-protection", errp);
+}
+
+static void machine_check_guest_memory_protection(const Object *obj,
+                                                  const char *name,
+                                                  Object *new_target,
+                                                  Error **errp)
+{
+    /*
+     * So far the only constraint is that the target has the
+     * TYPE_GUEST_MEMORY_PROTECTION interface, and that's checked by
+     * the QOM core
+     */
 }
 
 static bool machine_get_nvdimm(Object *obj, Error **errp)
@@ -849,6 +871,15 @@ static void machine_class_init(ObjectClass *oc, void *data)
     object_class_property_set_description(oc, "enforce-config-section",
         "Set on to enforce configuration section migration");
 
+    object_class_property_add_link(oc, "guest-memory-protection",
+                                   TYPE_GUEST_MEMORY_PROTECTION,
+                                   offsetof(MachineState, gmpo),
+                                   machine_check_guest_memory_protection,
+                                   OBJ_PROP_LINK_STRONG);
+    object_class_property_set_description(oc, "guest-memory-protection",
+        "Set guest memory protection object to use");
+
+    /* For compatibility */
     object_class_property_add_str(oc, "memory-encryption",
         machine_get_memory_encryption, machine_set_memory_encryption);
     object_class_property_set_description(oc, "memory-encryption",
@@ -1121,7 +1152,7 @@ void machine_run_board_init(MachineState *machine)
         }
     }
 
-    if (machine->memory_encryption) {
+    if (machine->gmpo) {
         /*
          * With guest memory protection, the host can't see the real
          * contents of RAM, so there's no point in it trying to merge
diff --git a/include/hw/boards.h b/include/hw/boards.h
index 18815d9be2..19bf2c38fc 100644
--- a/include/hw/boards.h
+++ b/include/hw/boards.h
@@ -12,6 +12,8 @@
 #include "qom/object.h"
 #include "hw/core/cpu.h"
 
+typedef struct GuestMemoryProtection GuestMemoryProtection;
+
 #define TYPE_MACHINE_SUFFIX "-machine"
 
 /* Machine class name that needs to be used for class-name-based machine
@@ -277,7 +279,7 @@ struct MachineState {
     bool suppress_vmdesc;
     bool enforce_config_section;
     bool enable_graphics;
-    char *memory_encryption;
+    GuestMemoryProtection *gmpo;
     char *ram_memdev_id;
     /*
      * convenience alias to ram_memdev_id backend memory region
-- 
2.26.2

