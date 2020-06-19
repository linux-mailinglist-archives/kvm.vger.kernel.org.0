Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EB5A200005
	for <lists+kvm@lfdr.de>; Fri, 19 Jun 2020 04:06:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729228AbgFSCGO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Jun 2020 22:06:14 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:43839 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728125AbgFSCGL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Jun 2020 22:06:11 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 49p2GS51gdz9sSf; Fri, 19 Jun 2020 12:06:08 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1592532368;
        bh=Tyfc+G1PqLXR9Edr87dtqwm5FYWBIwO1iB0LtB7dWSM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=drqFS3tpsGIz2+f7bAqa/NyDDVa8fH74EB+evMxQBZ+GKXjKVqjxhls6+I8ngzm4X
         aYxiIo3goBkbOVNhJO3Kxp/sVaSHSc8Yn/BFhn0ZiluUUAP7vKlkigQ70pu7WuRso9
         DHGoeXqhC1s5d09Esffgc94vIW1vDMUjWYMAEf6g=
From:   David Gibson <david@gibson.dropbear.id.au>
To:     qemu-devel@nongnu.org, brijesh.singh@amd.com, pair@us.ibm.com,
        pbonzini@redhat.com, dgilbert@redhat.com, frankja@linux.ibm.com
Cc:     Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, kvm@vger.kernel.org,
        qemu-ppc@nongnu.org, mst@redhat.com, mdroth@linux.vnet.ibm.com,
        Richard Henderson <rth@twiddle.net>, cohuck@redhat.com,
        pasic@linux.ibm.com, Eduardo Habkost <ehabkost@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        qemu-s390x@nongnu.org, david@redhat.com
Subject: [PATCH v3 4/9] host trust limitation: Rework the "memory-encryption" property
Date:   Fri, 19 Jun 2020 12:05:57 +1000
Message-Id: <20200619020602.118306-5-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200619020602.118306-1-david@gibson.dropbear.id.au>
References: <20200619020602.118306-1-david@gibson.dropbear.id.au>
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

So, create a new "host-trust-limitation" link property which sets this QOM
interface link directly in the machine.  For compatibility we keep the
"memory-encryption" property, but now implemented in terms of the new
property.

Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
---
 accel/kvm/kvm-all.c | 23 +++++++----------------
 hw/core/machine.c   | 41 ++++++++++++++++++++++++++++++++++++-----
 include/hw/boards.h |  2 +-
 3 files changed, 44 insertions(+), 22 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 1e43e27f45..d8e8fa345e 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2180,25 +2180,16 @@ static int kvm_init(MachineState *ms)
      * if memory encryption object is specified then initialize the memory
      * encryption context.
      */
-    if (ms->memory_encryption) {
-        Object *obj = object_resolve_path_component(object_get_objects_root(),
-                                                    ms->memory_encryption);
-
-        if (object_dynamic_cast(obj, TYPE_HOST_TRUST_LIMITATION)) {
-            HostTrustLimitation *htl = HOST_TRUST_LIMITATION(obj);
-            HostTrustLimitationClass *htlc
-                = HOST_TRUST_LIMITATION_GET_CLASS(htl);
-
-            ret = htlc->kvm_init(htl);
-            if (ret < 0) {
-                goto err;
-            }
+    if (ms->htl) {
+        HostTrustLimitationClass *htlc =
+            HOST_TRUST_LIMITATION_GET_CLASS(ms->htl);
 
-            kvm_state->htl = htl;
-        } else {
-            ret = -1;
+        ret = htlc->kvm_init(ms->htl);
+        if (ret < 0) {
             goto err;
         }
+
+        kvm_state->htl = ms->htl;
     }
 
     ret = kvm_arch_init(ms, s);
diff --git a/hw/core/machine.c b/hw/core/machine.c
index fdc0c7e038..a71792bc16 100644
--- a/hw/core/machine.c
+++ b/hw/core/machine.c
@@ -27,6 +27,7 @@
 #include "hw/pci/pci.h"
 #include "hw/mem/nvdimm.h"
 #include "migration/vmstate.h"
+#include "exec/host-trust-limitation.h"
 
 GlobalProperty hw_compat_5_0[] = {
     { "virtio-balloon-device", "page-poison", "false" },
@@ -425,16 +426,37 @@ static char *machine_get_memory_encryption(Object *obj, Error **errp)
 {
     MachineState *ms = MACHINE(obj);
 
-    return g_strdup(ms->memory_encryption);
+    if (ms->htl) {
+        return object_get_canonical_path_component(OBJECT(ms->htl));
+    }
+
+    return NULL;
 }
 
 static void machine_set_memory_encryption(Object *obj, const char *value,
                                         Error **errp)
 {
-    MachineState *ms = MACHINE(obj);
+    Object *htl =
+        object_resolve_path_component(object_get_objects_root(), value);
+
+    if (!htl) {
+        error_setg(errp, "No such memory encryption object '%s'", value);
+        return;
+    }
 
-    g_free(ms->memory_encryption);
-    ms->memory_encryption = g_strdup(value);
+    object_property_set_link(obj, htl, "host-trust-limitation", errp);
+}
+
+static void machine_check_host_trust_limitation(const Object *obj,
+                                                const char *name,
+                                                Object *new_target,
+                                                Error **errp)
+{
+    /*
+     * So far the only constraint is that the target has the
+     * TYPE_HOST_TRUST_LIMITATION interface, and that's checked by the
+     * QOM core
+     */
 }
 
 static bool machine_get_nvdimm(Object *obj, Error **errp)
@@ -855,6 +877,15 @@ static void machine_class_init(ObjectClass *oc, void *data)
     object_class_property_set_description(oc, "enforce-config-section",
         "Set on to enforce configuration section migration");
 
+    object_class_property_add_link(oc, "host-trust-limitation",
+                                   TYPE_HOST_TRUST_LIMITATION,
+                                   offsetof(MachineState, htl),
+                                   machine_check_host_trust_limitation,
+                                   OBJ_PROP_LINK_STRONG);
+    object_class_property_set_description(oc, "host-trust-limitation",
+        "Set host trust limitation object to use");
+
+    /* For compatibility */
     object_class_property_add_str(oc, "memory-encryption",
         machine_get_memory_encryption, machine_set_memory_encryption);
     object_class_property_set_description(oc, "memory-encryption",
@@ -1127,7 +1158,7 @@ void machine_run_board_init(MachineState *machine)
         }
     }
 
-    if (machine->memory_encryption) {
+    if (machine->htl) {
         /*
          * With host trust limitation, the host can't see the real
          * contents of RAM, so there's no point in it trying to merge
diff --git a/include/hw/boards.h b/include/hw/boards.h
index 18815d9be2..a9f8444729 100644
--- a/include/hw/boards.h
+++ b/include/hw/boards.h
@@ -277,7 +277,7 @@ struct MachineState {
     bool suppress_vmdesc;
     bool enforce_config_section;
     bool enable_graphics;
-    char *memory_encryption;
+    HostTrustLimitation *htl;
     char *ram_memdev_id;
     /*
      * convenience alias to ram_memdev_id backend memory region
-- 
2.26.2

