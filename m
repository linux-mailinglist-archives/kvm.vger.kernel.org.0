Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67EE022BC2E
	for <lists+kvm@lfdr.de>; Fri, 24 Jul 2020 04:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbgGXC5v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jul 2020 22:57:51 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:39313 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726543AbgGXC5u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jul 2020 22:57:50 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4BCYlv4Z8Sz9sSn; Fri, 24 Jul 2020 12:57:47 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1595559467;
        bh=R0fgLYiXYKzsBYFKyppNWeAvNHP70nX+ch1lmvuKdkA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nfyg+H1j2J84kBQamTgGTxcM7EJvrRZ+dLtwvoISyZJ9FIF3BwuTfOeq7x76/C0/W
         U4DTmGjwwPKE+0UwUR5DhjQcFxzLuHbN3JuJLtbWPvhqdT8k9qOKkbDOFpBjyR9HvI
         TRE7xA2fFVoIgxJ5fW2b5jvI2Y9BuFFLrtcEkyIc=
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
Subject: [for-5.2 v4 04/10] host trust limitation: Rework the "memory-encryption" property
Date:   Fri, 24 Jul 2020 12:57:38 +1000
Message-Id: <20200724025744.69644-5-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200724025744.69644-1-david@gibson.dropbear.id.au>
References: <20200724025744.69644-1-david@gibson.dropbear.id.au>
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
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 accel/kvm/kvm-all.c | 23 +++++++----------------
 hw/core/machine.c   | 41 ++++++++++++++++++++++++++++++++++++-----
 include/hw/boards.h |  2 +-
 3 files changed, 44 insertions(+), 22 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index d7d95eacc7..e2d8f47f93 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2186,25 +2186,16 @@ static int kvm_init(MachineState *ms)
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
index 035a1fc631..b599b0ba65 100644
--- a/hw/core/machine.c
+++ b/hw/core/machine.c
@@ -27,6 +27,7 @@
 #include "hw/pci/pci.h"
 #include "hw/mem/nvdimm.h"
 #include "migration/vmstate.h"
+#include "exec/host-trust-limitation.h"
 
 GlobalProperty hw_compat_5_0[] = {
     { "virtio-balloon-device", "page-poison", "false" },
@@ -422,16 +423,37 @@ static char *machine_get_memory_encryption(Object *obj, Error **errp)
 {
     MachineState *ms = MACHINE(obj);
 
-    return g_strdup(ms->memory_encryption);
+    if (ms->htl) {
+        return g_strdup(object_get_canonical_path_component(OBJECT(ms->htl)));
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
+    object_property_set_link(obj, "host-trust-limitation", htl, errp);
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
@@ -852,6 +874,15 @@ static void machine_class_init(ObjectClass *oc, void *data)
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
@@ -1123,7 +1154,7 @@ void machine_run_board_init(MachineState *machine)
         }
     }
 
-    if (machine->memory_encryption) {
+    if (machine->htl) {
         /*
          * With host trust limitation, the host can't see the real
          * contents of RAM, so there's no point in it trying to merge
diff --git a/include/hw/boards.h b/include/hw/boards.h
index 426ce5f625..c70fb8bd9f 100644
--- a/include/hw/boards.h
+++ b/include/hw/boards.h
@@ -278,7 +278,7 @@ struct MachineState {
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

