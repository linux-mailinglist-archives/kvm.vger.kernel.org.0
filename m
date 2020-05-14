Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDCF61D280B
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 08:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726190AbgENGlv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 02:41:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726113AbgENGlc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 May 2020 02:41:32 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0771C061A0C
        for <kvm@vger.kernel.org>; Wed, 13 May 2020 23:41:31 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 49N24k59dhz9sTP; Thu, 14 May 2020 16:41:26 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1589438486;
        bh=fb8v2WK7q2CLIssDQs3lioTxwfC3bg8wERvDM6ht70w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FUJNdzX7H2C/GCRpIk7dYKK+zbHfzjSEv9FFM3z4+O8YRcTZNUaxkFQOcHMDgx153
         4zul+ZGzsEFgHtZVve+xYB++EkZvKBv8ye0dyo5Vs+2QtYOh82tVxA1K690uI+4cJf
         VT5z7+WsTmgCz13gQaKyjYQYMshuMD7hk6Rsfpdo=
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
Subject: [RFC 11/18] guest memory protection: Handle memory encrption via interface
Date:   Thu, 14 May 2020 16:41:13 +1000
Message-Id: <20200514064120.449050-12-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200514064120.449050-1-david@gibson.dropbear.id.au>
References: <20200514064120.449050-1-david@gibson.dropbear.id.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

At the moment AMD SEV sets a special function pointer, plus an opaque
handle in KVMState to let things know how to encrypt guest memory.

Now that we have a QOM interface for handling things related to guest
memory protection, use a QOM method on that interface, rather than a bare
function pointer for this.

Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
---
 accel/kvm/kvm-all.c                    | 23 +++----
 accel/kvm/sev-stub.c                   |  5 --
 include/exec/guest-memory-protection.h |  2 +
 include/sysemu/sev.h                   |  6 +-
 target/i386/sev.c                      | 90 ++++++++++++++------------
 5 files changed, 66 insertions(+), 60 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 439a4efe52..47d7142aa1 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -44,6 +44,7 @@
 #include "qapi/visitor.h"
 #include "qapi/qapi-types-common.h"
 #include "qapi/qapi-visit-common.h"
+#include "exec/guest-memory-protection.h"
 
 #include "hw/boards.h"
 
@@ -118,8 +119,7 @@ struct KVMState
     QLIST_HEAD(, KVMParkedVcpu) kvm_parked_vcpus;
 
     /* memory encryption */
-    void *memcrypt_handle;
-    int (*memcrypt_encrypt_data)(void *handle, uint8_t *ptr, uint64_t len);
+    GuestMemoryProtection *guest_memory_protection;
 
     /* For "info mtree -f" to tell if an MR is registered in KVM */
     int nr_as;
@@ -171,7 +171,7 @@ int kvm_get_max_memslots(void)
 
 bool kvm_memcrypt_enabled(void)
 {
-    if (kvm_state && kvm_state->memcrypt_handle) {
+    if (kvm_state && kvm_state->guest_memory_protection) {
         return true;
     }
 
@@ -180,10 +180,13 @@ bool kvm_memcrypt_enabled(void)
 
 int kvm_memcrypt_encrypt_data(uint8_t *ptr, uint64_t len)
 {
-    if (kvm_state->memcrypt_handle &&
-        kvm_state->memcrypt_encrypt_data) {
-        return kvm_state->memcrypt_encrypt_data(kvm_state->memcrypt_handle,
-                                              ptr, len);
+    GuestMemoryProtection *gmpo = kvm_state->guest_memory_protection;
+
+    if (gmpo) {
+        GuestMemoryProtectionClass *gmpc =
+            GUEST_MEMORY_PROTECTION_GET_CLASS(gmpo);
+
+        return gmpc->encrypt_data(gmpo, ptr, len);
     }
 
     return 1;
@@ -2067,13 +2070,11 @@ static int kvm_init(MachineState *ms)
      * encryption context.
      */
     if (ms->memory_encryption) {
-        kvm_state->memcrypt_handle = sev_guest_init(ms->memory_encryption);
-        if (!kvm_state->memcrypt_handle) {
+        kvm_state->guest_memory_protection = sev_guest_init(ms->memory_encryption);
+        if (!kvm_state->guest_memory_protection) {
             ret = -1;
             goto err;
         }
-
-        kvm_state->memcrypt_encrypt_data = sev_encrypt_data;
     }
 
     ret = kvm_arch_init(ms, s);
diff --git a/accel/kvm/sev-stub.c b/accel/kvm/sev-stub.c
index 4f97452585..4a5cc5569e 100644
--- a/accel/kvm/sev-stub.c
+++ b/accel/kvm/sev-stub.c
@@ -15,11 +15,6 @@
 #include "qemu-common.h"
 #include "sysemu/sev.h"
 
-int sev_encrypt_data(void *handle, uint8_t *ptr, uint64_t len)
-{
-    abort();
-}
-
 void *sev_guest_init(const char *id)
 {
     return NULL;
diff --git a/include/exec/guest-memory-protection.h b/include/exec/guest-memory-protection.h
index 38e9b01667..eb712a5804 100644
--- a/include/exec/guest-memory-protection.h
+++ b/include/exec/guest-memory-protection.h
@@ -30,6 +30,8 @@ typedef struct GuestMemoryProtection GuestMemoryProtection;
 
 typedef struct GuestMemoryProtectionClass {
     InterfaceClass parent;
+
+    int (*encrypt_data)(GuestMemoryProtection *, uint8_t *, uint64_t);
 } GuestMemoryProtectionClass;
 
 #endif /* QEMU_GUEST_MEMORY_PROTECTION_H */
diff --git a/include/sysemu/sev.h b/include/sysemu/sev.h
index 98c1ec8d38..7735a7942e 100644
--- a/include/sysemu/sev.h
+++ b/include/sysemu/sev.h
@@ -16,6 +16,8 @@
 
 #include "sysemu/kvm.h"
 
-void *sev_guest_init(const char *id);
-int sev_encrypt_data(void *handle, uint8_t *ptr, uint64_t len);
+typedef struct GuestMemoryProtection GuestMemoryProtection;
+
+GuestMemoryProtection *sev_guest_init(const char *id);
+
 #endif
diff --git a/target/i386/sev.c b/target/i386/sev.c
index d7c2032989..d9c17af514 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -28,6 +28,7 @@
 #include "sysemu/runstate.h"
 #include "trace.h"
 #include "migration/blocker.h"
+#include "exec/guest-memory-protection.h"
 
 #define TYPE_SEV_GUEST "sev-guest"
 #define SEV_GUEST(obj)                                          \
@@ -281,29 +282,6 @@ sev_guest_set_sev_device(Object *obj, const char *value, Error **errp)
     sev->sev_device = g_strdup(value);
 }
 
-static void
-sev_guest_class_init(ObjectClass *oc, void *data)
-{
-    object_class_property_add_str(oc, "sev-device",
-                                  sev_guest_get_sev_device,
-                                  sev_guest_set_sev_device,
-                                  NULL);
-    object_class_property_set_description(oc, "sev-device",
-            "SEV device to use", NULL);
-    object_class_property_add_str(oc, "dh-cert-file",
-                                  sev_guest_get_dh_cert_file,
-                                  sev_guest_set_dh_cert_file,
-                                  NULL);
-    object_class_property_set_description(oc, "dh-cert-file",
-            "guest owners DH certificate (encoded with base64)", NULL);
-    object_class_property_add_str(oc, "session-file",
-                                  sev_guest_get_session_file,
-                                  sev_guest_set_session_file,
-                                  NULL);
-    object_class_property_set_description(oc, "session-file",
-            "guest owners session parameters (encoded with base64)", NULL);
-}
-
 static void
 sev_guest_instance_init(Object *obj)
 {
@@ -322,20 +300,6 @@ sev_guest_instance_init(Object *obj)
                                    OBJ_PROP_FLAG_READWRITE, NULL);
 }
 
-/* sev guest info */
-static const TypeInfo sev_guest_info = {
-    .parent = TYPE_OBJECT,
-    .name = TYPE_SEV_GUEST,
-    .instance_size = sizeof(SevGuestState),
-    .instance_finalize = sev_guest_finalize,
-    .class_init = sev_guest_class_init,
-    .instance_init = sev_guest_instance_init,
-    .interfaces = (InterfaceInfo[]) {
-        { TYPE_USER_CREATABLE },
-        { }
-    }
-};
-
 static SevGuestState *
 lookup_sev_guest_info(const char *id)
 {
@@ -673,7 +637,7 @@ sev_vm_state_change(void *opaque, int running, RunState state)
     }
 }
 
-void *
+GuestMemoryProtection *
 sev_guest_init(const char *id)
 {
     SevGuestState *sev;
@@ -751,16 +715,16 @@ sev_guest_init(const char *id)
     qemu_add_machine_init_done_notifier(&sev_machine_done_notify);
     qemu_add_vm_change_state_handler(sev_vm_state_change, sev);
 
-    return sev;
+    return GUEST_MEMORY_PROTECTION(sev);
 err:
     sev_guest = NULL;
     return NULL;
 }
 
-int
-sev_encrypt_data(void *handle, uint8_t *ptr, uint64_t len)
+static int
+sev_encrypt_data(GuestMemoryProtection *opaque, uint8_t *ptr, uint64_t len)
 {
-    SevGuestState *sev = handle;
+    SevGuestState *sev = SEV_GUEST(opaque);
 
     assert(sev);
 
@@ -772,6 +736,48 @@ sev_encrypt_data(void *handle, uint8_t *ptr, uint64_t len)
     return 0;
 }
 
+static void
+sev_guest_class_init(ObjectClass *oc, void *data)
+{
+    GuestMemoryProtectionClass *gmpc = GUEST_MEMORY_PROTECTION_CLASS(oc);
+
+    object_class_property_add_str(oc, "sev-device",
+                                  sev_guest_get_sev_device,
+                                  sev_guest_set_sev_device,
+                                  NULL);
+    object_class_property_set_description(oc, "sev-device",
+            "SEV device to use", NULL);
+    object_class_property_add_str(oc, "dh-cert-file",
+                                  sev_guest_get_dh_cert_file,
+                                  sev_guest_set_dh_cert_file,
+                                  NULL);
+    object_class_property_set_description(oc, "dh-cert-file",
+            "guest owners DH certificate (encoded with base64)", NULL);
+    object_class_property_add_str(oc, "session-file",
+                                  sev_guest_get_session_file,
+                                  sev_guest_set_session_file,
+                                  NULL);
+    object_class_property_set_description(oc, "session-file",
+            "guest owners session parameters (encoded with base64)", NULL);
+
+    gmpc->encrypt_data = sev_encrypt_data;
+}
+
+/* sev guest info */
+static const TypeInfo sev_guest_info = {
+    .parent = TYPE_OBJECT,
+    .name = TYPE_SEV_GUEST,
+    .instance_size = sizeof(SevGuestState),
+    .instance_finalize = sev_guest_finalize,
+    .class_init = sev_guest_class_init,
+    .instance_init = sev_guest_instance_init,
+    .interfaces = (InterfaceInfo[]) {
+        { TYPE_GUEST_MEMORY_PROTECTION },
+        { TYPE_USER_CREATABLE },
+        { }
+    }
+};
+
 static void
 sev_register_types(void)
 {
-- 
2.26.2

