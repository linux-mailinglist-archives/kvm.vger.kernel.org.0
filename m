Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95A971D2804
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 08:41:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726147AbgENGln (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 02:41:43 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:59647 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726107AbgENGld (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 May 2020 02:41:33 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 49N24l5SM8z9sTl; Thu, 14 May 2020 16:41:27 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1589438487;
        bh=R6MXAAmaaPvC+5o8Bj46125hc04Qz/lg2z4W1QphsUY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TrlfbR4IjOjzT0+UcgsaLMwdlcr03ipnSnURyUqH9EYY47QqSGZ86bW5pYoy4aa1H
         nliEuI7zkAQa898fCoaQfj9HJQOQXI1mKwyvdv/z/0iTpfym3uyRyAtoPpzwxoH2fV
         G3E5j7Ppsfpte6Gh6C4+7nwZkpKm0UKHjdeJkoJw=
From:   David Gibson <david@gibson.dropbear.id.au>
To:     dgilbert@redhat.com, frankja@linux.ibm.com, pair@us.redhat.com,
        qemu-devel@nongnu.org, brijesh.singh@amd.com
Cc:     kvm@vger.kernel.org, qemu-ppc@nongnu.org,
        David Gibson <david@gibson.dropbear.id.au>,
        Richard Henderson <rth@twiddle.net>, cohuck@redhat.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>, qemu-devel@nongnu.-rg,
        mdroth@linux.vnet.ibm.com
Subject: [RFC 14/18] guest memory protection: Rework the "memory-encryption" property
Date:   Thu, 14 May 2020 16:41:16 +1000
Message-Id: <20200514064120.449050-15-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200514064120.449050-1-david@gibson.dropbear.id.au>
References: <20200514064120.449050-1-david@gibson.dropbear.id.au>
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
index 9b4863aced..60c4fe326b 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2068,25 +2068,16 @@ static int kvm_init(MachineState *ms)
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
index a50ba82d74..37d9f7f85c 100644
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
@@ -853,6 +875,15 @@ static void machine_class_init(ObjectClass *oc, void *data)
     object_class_property_set_description(oc, "enforce-config-section",
         "Set on to enforce configuration section migration", &error_abort);
 
+    object_class_property_add_link(oc, "guest-memory-protection",
+                                   TYPE_GUEST_MEMORY_PROTECTION,
+                                   offsetof(MachineState, gmpo),
+                                   machine_check_guest_memory_protection,
+                                   OBJ_PROP_LINK_STRONG, &error_abort);
+    object_class_property_set_description(oc, "guest-memory-protection",
+        "Set guest memory protection object to use", &error_abort);
+
+    /* For compatibility */
     object_class_property_add_str(oc, "memory-encryption",
         machine_get_memory_encryption, machine_set_memory_encryption,
         &error_abort);
@@ -1132,7 +1163,7 @@ void machine_run_board_init(MachineState *machine)
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

