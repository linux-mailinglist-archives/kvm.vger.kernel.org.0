Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2EC02CE7BE
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 06:47:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728326AbgLDFpu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Dec 2020 00:45:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728203AbgLDFpo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Dec 2020 00:45:44 -0500
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2D20C061A52
        for <kvm@vger.kernel.org>; Thu,  3 Dec 2020 21:45:03 -0800 (PST)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4CnM8g4ZGpz9sVS; Fri,  4 Dec 2020 16:44:19 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1607060659;
        bh=kdYvFLKM63q+FlqswmpyvW9PA1nGgs8gSeZCixeRoWI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eClbQXzs/c6c4HuFl4LzxegJDpJf85x/cwcWPj7nAcbbTTwime4OvFGJdL59mXx54
         HzPQyeK1ID37Co+Q5w5bCkPtImzoohOtJ0eSYvB9wy64nv5h6iREEOuTuqrlF5eU4w
         qf3PSN6hhUcXPo0Eqc8idtr4Yme6Llsrzjm4xKlc=
From:   David Gibson <david@gibson.dropbear.id.au>
To:     pair@us.ibm.com, pbonzini@redhat.com, frankja@linux.ibm.com,
        brijesh.singh@amd.com, dgilbert@redhat.com, qemu-devel@nongnu.org
Cc:     Eduardo Habkost <ehabkost@redhat.com>, qemu-ppc@nongnu.org,
        rth@twiddle.net, thuth@redhat.com, berrange@redhat.com,
        mdroth@linux.vnet.ibm.com, Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        david@redhat.com, Richard Henderson <richard.henderson@linaro.org>,
        borntraeger@de.ibm.com, David Gibson <david@gibson.dropbear.id.au>,
        cohuck@redhat.com, kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        pasic@linux.ibm.com
Subject: [for-6.0 v5 05/13] securable guest memory: Rework the "memory-encryption" property
Date:   Fri,  4 Dec 2020 16:44:07 +1100
Message-Id: <20201204054415.579042-6-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201204054415.579042-1-david@gibson.dropbear.id.au>
References: <20201204054415.579042-1-david@gibson.dropbear.id.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently the "memory-encryption" property is only looked at once we
get to kvm_init().  Although protection of guest memory from the
hypervisor isn't something that could really ever work with TCG, it's
not conceptually tied to the KVM accelerator.

In addition, the way the string property is resolved to an object is
almost identical to how a QOM link property is handled.

So, create a new "securable-guest-memory" link property which sets
this QOM interface link directly in the machine.  For compatibility we
keep the "memory-encryption" property, but now implemented in terms of
the new property.

Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 accel/kvm/kvm-all.c | 22 ++++++----------------
 hw/core/machine.c   | 43 +++++++++++++++++++++++++++++++++++++------
 include/hw/boards.h |  2 +-
 3 files changed, 44 insertions(+), 23 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 9e7cea64d6..92a49b328a 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2207,24 +2207,14 @@ static int kvm_init(MachineState *ms)
      * if memory encryption object is specified then initialize the memory
      * encryption context.
      */
-    if (ms->memory_encryption) {
-        Object *obj = object_resolve_path_component(object_get_objects_root(),
-                                                    ms->memory_encryption);
-
-        if (object_dynamic_cast(obj, TYPE_SECURABLE_GUEST_MEMORY)) {
-            SecurableGuestMemory *sgm = SECURABLE_GUEST_MEMORY(obj);
-
-            /* FIXME handle mechanisms other than SEV */
-            ret = sev_kvm_init(sgm);
-            if (ret < 0) {
-                goto err;
-            }
-
-            kvm_state->sgm = sgm;
-        } else {
-            ret = -1;
+    if (ms->sgm) {
+        /* FIXME handle mechanisms other than SEV */
+        ret = sev_kvm_init(ms->sgm);
+        if (ret < 0) {
             goto err;
         }
+
+        kvm_state->sgm = ms->sgm;
     }
 
     ret = kvm_arch_init(ms, s);
diff --git a/hw/core/machine.c b/hw/core/machine.c
index cb0711508d..816ea3ae3e 100644
--- a/hw/core/machine.c
+++ b/hw/core/machine.c
@@ -27,6 +27,7 @@
 #include "hw/pci/pci.h"
 #include "hw/mem/nvdimm.h"
 #include "migration/vmstate.h"
+#include "exec/securable-guest-memory.h"
 
 GlobalProperty hw_compat_5_1[] = {
     { "vhost-scsi", "num_queues", "1"},
@@ -417,16 +418,37 @@ static char *machine_get_memory_encryption(Object *obj, Error **errp)
 {
     MachineState *ms = MACHINE(obj);
 
-    return g_strdup(ms->memory_encryption);
+    if (ms->sgm) {
+        return g_strdup(object_get_canonical_path_component(OBJECT(ms->sgm)));
+    }
+
+    return NULL;
 }
 
 static void machine_set_memory_encryption(Object *obj, const char *value,
                                         Error **errp)
 {
-    MachineState *ms = MACHINE(obj);
+    Object *sgm =
+        object_resolve_path_component(object_get_objects_root(), value);
+
+    if (!sgm) {
+        error_setg(errp, "No such memory encryption object '%s'", value);
+        return;
+    }
 
-    g_free(ms->memory_encryption);
-    ms->memory_encryption = g_strdup(value);
+    object_property_set_link(obj, "securable-guest-memory", sgm, errp);
+}
+
+static void machine_check_securable_guest_memory(const Object *obj,
+                                                 const char *name,
+                                                 Object *new_target,
+                                                 Error **errp)
+{
+    /*
+     * So far the only constraint is that the target has the
+     * TYPE_SECURABLE_GUEST_MEMORY interface, and that's checked by
+     * the QOM core
+     */
 }
 
 static bool machine_get_nvdimm(Object *obj, Error **errp)
@@ -833,6 +855,15 @@ static void machine_class_init(ObjectClass *oc, void *data)
     object_class_property_set_description(oc, "suppress-vmdesc",
         "Set on to disable self-describing migration");
 
+    object_class_property_add_link(oc, "securable-guest-memory",
+                                   TYPE_SECURABLE_GUEST_MEMORY,
+                                   offsetof(MachineState, sgm),
+                                   machine_check_securable_guest_memory,
+                                   OBJ_PROP_LINK_STRONG);
+    object_class_property_set_description(oc, "securable-guest-memory",
+        "Set securable guest memory scheme to use");
+
+    /* For compatibility */
     object_class_property_add_str(oc, "memory-encryption",
         machine_get_memory_encryption, machine_set_memory_encryption);
     object_class_property_set_description(oc, "memory-encryption",
@@ -1123,9 +1154,9 @@ void machine_run_board_init(MachineState *machine)
                     cc->deprecation_note);
     }
 
-    if (machine->memory_encryption) {
+    if (machine->sgm) {
         /*
-         * With memory encryption, the host can't see the real
+         * With securable guest memory, the host can't see the real
          * contents of RAM, so there's no point in it trying to merge
          * areas.
          */
diff --git a/include/hw/boards.h b/include/hw/boards.h
index a49e3a6b44..2ea9790183 100644
--- a/include/hw/boards.h
+++ b/include/hw/boards.h
@@ -269,7 +269,7 @@ struct MachineState {
     bool iommu;
     bool suppress_vmdesc;
     bool enable_graphics;
-    char *memory_encryption;
+    SecurableGuestMemory *sgm;
     char *ram_memdev_id;
     /*
      * convenience alias to ram_memdev_id backend memory region
-- 
2.28.0

