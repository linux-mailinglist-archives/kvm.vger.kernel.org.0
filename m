Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 076BE312A74
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 07:06:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbhBHGGx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 01:06:53 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:51239 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229681AbhBHGGe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Feb 2021 01:06:34 -0500
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4DYwVs3z6Pz9sVt; Mon,  8 Feb 2021 17:05:41 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1612764341;
        bh=HatGcTSprIrTulxbpIQAS0oYiQKEyFDrhO9QP/pGcuE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=baOj3Flcmvp9RGtBHOPeNuS21B/6AWCw5OjRWusJf+y+P38MtYawnJJZ1FzjqGtMw
         astBTtEoZ0dLWs5mVPLGIk00lvZSIiGw7YY2VeJlNF6eFxgWEz5G9wY4KjswY3DQo7
         fVnLed1qb5Ej7gNcEam/6F3XUr0G+SUN/o8uu7L4=
From:   David Gibson <david@gibson.dropbear.id.au>
To:     pasic@linux.ibm.com, dgilbert@redhat.com, pair@us.ibm.com,
        qemu-devel@nongnu.org, brijesh.singh@amd.com
Cc:     ehabkost@redhat.com, mtosatti@redhat.com, mst@redhat.com,
        jun.nakajima@intel.com, kvm@vger.kernel.org,
        Richard Henderson <richard.henderson@linaro.org>,
        qemu-s390x@nongnu.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        pbonzini@redhat.com, frankja@linux.ibm.com, andi.kleen@intel.com,
        cohuck@redhat.com, Thomas Huth <thuth@redhat.com>,
        borntraeger@de.ibm.com, mdroth@linux.vnet.ibm.com,
        David Gibson <david@gibson.dropbear.id.au>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        qemu-ppc@nongnu.org, David Hildenbrand <david@redhat.com>,
        Greg Kurz <groug@kaod.org>, pragyansri.pathi@intel.com
Subject: [PULL v9 05/13] confidential guest support: Rework the "memory-encryption" property
Date:   Mon,  8 Feb 2021 17:05:30 +1100
Message-Id: <20210208060538.39276-6-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210208060538.39276-1-david@gibson.dropbear.id.au>
References: <20210208060538.39276-1-david@gibson.dropbear.id.au>
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

So, create a new "confidential-guest-support" link property which sets
this QOM interface link directly in the machine.  For compatibility we
keep the "memory-encryption" property, but now implemented in terms of
the new property.

Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
Reviewed-by: Greg Kurz <groug@kaod.org>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
---
 accel/kvm/kvm-all.c  |  5 +++--
 accel/kvm/sev-stub.c |  5 +++--
 hw/core/machine.c    | 43 +++++++++++++++++++++++++++++++++++++------
 include/hw/boards.h  |  2 +-
 include/sysemu/sev.h |  2 +-
 target/i386/sev.c    | 32 ++------------------------------
 6 files changed, 47 insertions(+), 42 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 3526e88b6c..88a6b8c19e 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2184,8 +2184,9 @@ static int kvm_init(MachineState *ms)
      * if memory encryption object is specified then initialize the memory
      * encryption context.
      */
-    if (ms->memory_encryption) {
-        ret = sev_guest_init(ms->memory_encryption);
+    if (ms->cgs) {
+        /* FIXME handle mechanisms other than SEV */
+        ret = sev_kvm_init(ms->cgs);
         if (ret < 0) {
             goto err;
         }
diff --git a/accel/kvm/sev-stub.c b/accel/kvm/sev-stub.c
index 5db9ab8f00..3d4787ae4a 100644
--- a/accel/kvm/sev-stub.c
+++ b/accel/kvm/sev-stub.c
@@ -15,7 +15,8 @@
 #include "qemu-common.h"
 #include "sysemu/sev.h"
 
-int sev_guest_init(const char *id)
+int sev_kvm_init(ConfidentialGuestSupport *cgs)
 {
-    return -1;
+    /* SEV can't be selected if it's not compiled */
+    g_assert_not_reached();
 }
diff --git a/hw/core/machine.c b/hw/core/machine.c
index 919067b5c9..f45a795478 100644
--- a/hw/core/machine.c
+++ b/hw/core/machine.c
@@ -32,6 +32,7 @@
 #include "hw/mem/nvdimm.h"
 #include "migration/global_state.h"
 #include "migration/vmstate.h"
+#include "exec/confidential-guest-support.h"
 
 GlobalProperty hw_compat_5_2[] = {};
 const size_t hw_compat_5_2_len = G_N_ELEMENTS(hw_compat_5_2);
@@ -427,16 +428,37 @@ static char *machine_get_memory_encryption(Object *obj, Error **errp)
 {
     MachineState *ms = MACHINE(obj);
 
-    return g_strdup(ms->memory_encryption);
+    if (ms->cgs) {
+        return g_strdup(object_get_canonical_path_component(OBJECT(ms->cgs)));
+    }
+
+    return NULL;
 }
 
 static void machine_set_memory_encryption(Object *obj, const char *value,
                                         Error **errp)
 {
-    MachineState *ms = MACHINE(obj);
+    Object *cgs =
+        object_resolve_path_component(object_get_objects_root(), value);
+
+    if (!cgs) {
+        error_setg(errp, "No such memory encryption object '%s'", value);
+        return;
+    }
 
-    g_free(ms->memory_encryption);
-    ms->memory_encryption = g_strdup(value);
+    object_property_set_link(obj, "confidential-guest-support", cgs, errp);
+}
+
+static void machine_check_confidential_guest_support(const Object *obj,
+                                                     const char *name,
+                                                     Object *new_target,
+                                                     Error **errp)
+{
+    /*
+     * So far the only constraint is that the target has the
+     * TYPE_CONFIDENTIAL_GUEST_SUPPORT interface, and that's checked
+     * by the QOM core
+     */
 }
 
 static bool machine_get_nvdimm(Object *obj, Error **errp)
@@ -836,6 +858,15 @@ static void machine_class_init(ObjectClass *oc, void *data)
     object_class_property_set_description(oc, "suppress-vmdesc",
         "Set on to disable self-describing migration");
 
+    object_class_property_add_link(oc, "confidential-guest-support",
+                                   TYPE_CONFIDENTIAL_GUEST_SUPPORT,
+                                   offsetof(MachineState, cgs),
+                                   machine_check_confidential_guest_support,
+                                   OBJ_PROP_LINK_STRONG);
+    object_class_property_set_description(oc, "confidential-guest-support",
+                                          "Set confidential guest scheme to support");
+
+    /* For compatibility */
     object_class_property_add_str(oc, "memory-encryption",
         machine_get_memory_encryption, machine_set_memory_encryption);
     object_class_property_set_description(oc, "memory-encryption",
@@ -1158,9 +1189,9 @@ void machine_run_board_init(MachineState *machine)
                     cc->deprecation_note);
     }
 
-    if (machine->memory_encryption) {
+    if (machine->cgs) {
         /*
-         * With memory encryption, the host can't see the real
+         * With confidential guests, the host can't see the real
          * contents of RAM, so there's no point in it trying to merge
          * areas.
          */
diff --git a/include/hw/boards.h b/include/hw/boards.h
index 85af4faf76..a46dfe5d1a 100644
--- a/include/hw/boards.h
+++ b/include/hw/boards.h
@@ -270,7 +270,7 @@ struct MachineState {
     bool iommu;
     bool suppress_vmdesc;
     bool enable_graphics;
-    char *memory_encryption;
+    ConfidentialGuestSupport *cgs;
     char *ram_memdev_id;
     /*
      * convenience alias to ram_memdev_id backend memory region
diff --git a/include/sysemu/sev.h b/include/sysemu/sev.h
index 7335e59867..3b5b1aacf1 100644
--- a/include/sysemu/sev.h
+++ b/include/sysemu/sev.h
@@ -16,7 +16,7 @@
 
 #include "sysemu/kvm.h"
 
-int sev_guest_init(const char *id);
+int sev_kvm_init(ConfidentialGuestSupport *cgs);
 int sev_encrypt_flash(uint8_t *ptr, uint64_t len, Error **errp);
 int sev_inject_launch_secret(const char *hdr, const char *secret,
                              uint64_t gpa, Error **errp);
diff --git a/target/i386/sev.c b/target/i386/sev.c
index 8d4e1ea262..fa962d533c 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -335,26 +335,6 @@ static const TypeInfo sev_guest_info = {
     }
 };
 
-static SevGuestState *
-lookup_sev_guest_info(const char *id)
-{
-    Object *obj;
-    SevGuestState *info;
-
-    obj = object_resolve_path_component(object_get_objects_root(), id);
-    if (!obj) {
-        return NULL;
-    }
-
-    info = (SevGuestState *)
-            object_dynamic_cast(obj, TYPE_SEV_GUEST);
-    if (!info) {
-        return NULL;
-    }
-
-    return info;
-}
-
 bool
 sev_enabled(void)
 {
@@ -682,10 +662,9 @@ sev_vm_state_change(void *opaque, int running, RunState state)
     }
 }
 
-int
-sev_guest_init(const char *id)
+int sev_kvm_init(ConfidentialGuestSupport *cgs)
 {
-    SevGuestState *sev;
+    SevGuestState *sev = SEV_GUEST(cgs);
     char *devname;
     int ret, fw_error;
     uint32_t ebx;
@@ -698,13 +677,6 @@ sev_guest_init(const char *id)
         return -1;
     }
 
-    sev = lookup_sev_guest_info(id);
-    if (!sev) {
-        error_report("%s: '%s' is not a valid '%s' object",
-                     __func__, id, TYPE_SEV_GUEST);
-        goto err;
-    }
-
     sev_guest = sev;
     sev->state = SEV_STATE_UNINIT;
 
-- 
2.29.2

