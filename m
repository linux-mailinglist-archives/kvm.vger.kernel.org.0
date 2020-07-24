Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC52222BC2D
	for <lists+kvm@lfdr.de>; Fri, 24 Jul 2020 04:57:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726800AbgGXC5v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jul 2020 22:57:51 -0400
Received: from ozlabs.org ([203.11.71.1]:42497 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726178AbgGXC5t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jul 2020 22:57:49 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4BCYlv27sJz9sPB; Fri, 24 Jul 2020 12:57:47 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1595559467;
        bh=jOh302ICMvqv+PqzmEYZM/FeEcTqLZlPD0brgAjYmLU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ax3uyoL3DMEDQU+kVdFw8ajofr1GheaEnjnjIqAGJGYNMleUsjmoLbYhZzERr9Hrz
         5vN4FtGUUHrslBUodzGTv7vDUKks96VKaM81LyhwdgpZc+qSNrWeS07B+dm529q23H
         fvQW8SXUEyh7QkdbgnqXIqNv+HRpNpP4GYum0vgQ=
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
Subject: [for-5.2 v4 02/10] host trust limitation: Handle memory encryption via interface
Date:   Fri, 24 Jul 2020 12:57:36 +1000
Message-Id: <20200724025744.69644-3-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200724025744.69644-1-david@gibson.dropbear.id.au>
References: <20200724025744.69644-1-david@gibson.dropbear.id.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

At the moment AMD SEV sets a special function pointer, plus an opaque
handle in KVMState to let things know how to encrypt guest memory.

Now that we have a QOM interface for handling things related to host trust
limitation, use a QOM method on that interface, rather than a bare function
pointer for this.

Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 accel/kvm/kvm-all.c                  |  38 ++++++---
 accel/kvm/sev-stub.c                 |   7 +-
 include/exec/host-trust-limitation.h |   3 +
 include/sysemu/sev.h                 |   4 +-
 target/i386/sev.c                    | 119 +++++++++++----------------
 5 files changed, 80 insertions(+), 91 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 63ef6af9a1..d7d95eacc7 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -39,11 +39,11 @@
 #include "qemu/main-loop.h"
 #include "trace.h"
 #include "hw/irq.h"
-#include "sysemu/sev.h"
 #include "qapi/visitor.h"
 #include "qapi/qapi-types-common.h"
 #include "qapi/qapi-visit-common.h"
 #include "sysemu/reset.h"
+#include "exec/host-trust-limitation.h"
 
 #include "hw/boards.h"
 
@@ -117,9 +117,8 @@ struct KVMState
     KVMMemoryListener memory_listener;
     QLIST_HEAD(, KVMParkedVcpu) kvm_parked_vcpus;
 
-    /* memory encryption */
-    void *memcrypt_handle;
-    int (*memcrypt_encrypt_data)(void *handle, uint8_t *ptr, uint64_t len);
+    /* host trust limitation (e.g. by guest memory encryption) */
+    HostTrustLimitation *htl;
 
     /* For "info mtree -f" to tell if an MR is registered in KVM */
     int nr_as;
@@ -221,7 +220,7 @@ int kvm_get_max_memslots(void)
 
 bool kvm_memcrypt_enabled(void)
 {
-    if (kvm_state && kvm_state->memcrypt_handle) {
+    if (kvm_state && kvm_state->htl) {
         return true;
     }
 
@@ -230,10 +229,12 @@ bool kvm_memcrypt_enabled(void)
 
 int kvm_memcrypt_encrypt_data(uint8_t *ptr, uint64_t len)
 {
-    if (kvm_state->memcrypt_handle &&
-        kvm_state->memcrypt_encrypt_data) {
-        return kvm_state->memcrypt_encrypt_data(kvm_state->memcrypt_handle,
-                                              ptr, len);
+    HostTrustLimitation *htl = kvm_state->htl;
+
+    if (htl) {
+        HostTrustLimitationClass *htlc = HOST_TRUST_LIMITATION_GET_CLASS(htl);
+
+        return htlc->encrypt_data(htl, ptr, len);
     }
 
     return 1;
@@ -2186,13 +2187,24 @@ static int kvm_init(MachineState *ms)
      * encryption context.
      */
     if (ms->memory_encryption) {
-        kvm_state->memcrypt_handle = sev_guest_init(ms->memory_encryption);
-        if (!kvm_state->memcrypt_handle) {
+        Object *obj = object_resolve_path_component(object_get_objects_root(),
+                                                    ms->memory_encryption);
+
+        if (object_dynamic_cast(obj, TYPE_HOST_TRUST_LIMITATION)) {
+            HostTrustLimitation *htl = HOST_TRUST_LIMITATION(obj);
+            HostTrustLimitationClass *htlc
+                = HOST_TRUST_LIMITATION_GET_CLASS(htl);
+
+            ret = htlc->kvm_init(htl);
+            if (ret < 0) {
+                goto err;
+            }
+
+            kvm_state->htl = htl;
+        } else {
             ret = -1;
             goto err;
         }
-
-        kvm_state->memcrypt_encrypt_data = sev_encrypt_data;
     }
 
     ret = kvm_arch_init(ms, s);
diff --git a/accel/kvm/sev-stub.c b/accel/kvm/sev-stub.c
index 4f97452585..9c7c897593 100644
--- a/accel/kvm/sev-stub.c
+++ b/accel/kvm/sev-stub.c
@@ -15,12 +15,7 @@
 #include "qemu-common.h"
 #include "sysemu/sev.h"
 
-int sev_encrypt_data(void *handle, uint8_t *ptr, uint64_t len)
-{
-    abort();
-}
-
-void *sev_guest_init(const char *id)
+HostTrustLimitation *sev_guest_init(const char *id)
 {
     return NULL;
 }
diff --git a/include/exec/host-trust-limitation.h b/include/exec/host-trust-limitation.h
index 03887b1be1..a19f12ae14 100644
--- a/include/exec/host-trust-limitation.h
+++ b/include/exec/host-trust-limitation.h
@@ -28,6 +28,9 @@
 
 typedef struct HostTrustLimitationClass {
     InterfaceClass parent;
+
+    int (*kvm_init)(HostTrustLimitation *);
+    int (*encrypt_data)(HostTrustLimitation *, uint8_t *, uint64_t);
 } HostTrustLimitationClass;
 
 #endif /* QEMU_HOST_TRUST_LIMITATION_H */
diff --git a/include/sysemu/sev.h b/include/sysemu/sev.h
index 98c1ec8d38..a4aee6a87d 100644
--- a/include/sysemu/sev.h
+++ b/include/sysemu/sev.h
@@ -16,6 +16,6 @@
 
 #include "sysemu/kvm.h"
 
-void *sev_guest_init(const char *id);
-int sev_encrypt_data(void *handle, uint8_t *ptr, uint64_t len);
+HostTrustLimitation *sev_guest_init(const char *id);
+
 #endif
diff --git a/target/i386/sev.c b/target/i386/sev.c
index c3ecf86704..8e3c9dcc2c 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -28,6 +28,7 @@
 #include "sysemu/runstate.h"
 #include "trace.h"
 #include "migration/blocker.h"
+#include "exec/host-trust-limitation.h"
 
 #define TYPE_SEV_GUEST "sev-guest"
 #define SEV_GUEST(obj)                                          \
@@ -281,26 +282,6 @@ sev_guest_set_sev_device(Object *obj, const char *value, Error **errp)
     sev->sev_device = g_strdup(value);
 }
 
-static void
-sev_guest_class_init(ObjectClass *oc, void *data)
-{
-    object_class_property_add_str(oc, "sev-device",
-                                  sev_guest_get_sev_device,
-                                  sev_guest_set_sev_device);
-    object_class_property_set_description(oc, "sev-device",
-            "SEV device to use");
-    object_class_property_add_str(oc, "dh-cert-file",
-                                  sev_guest_get_dh_cert_file,
-                                  sev_guest_set_dh_cert_file);
-    object_class_property_set_description(oc, "dh-cert-file",
-            "guest owners DH certificate (encoded with base64)");
-    object_class_property_add_str(oc, "session-file",
-                                  sev_guest_get_session_file,
-                                  sev_guest_set_session_file);
-    object_class_property_set_description(oc, "session-file",
-            "guest owners session parameters (encoded with base64)");
-}
-
 static void
 sev_guest_instance_init(Object *obj)
 {
@@ -319,40 +300,6 @@ sev_guest_instance_init(Object *obj)
                                    OBJ_PROP_FLAG_READWRITE);
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
@@ -679,10 +626,9 @@ sev_vm_state_change(void *opaque, int running, RunState state)
     }
 }
 
-void *
-sev_guest_init(const char *id)
+static int sev_kvm_init(HostTrustLimitation *htl)
 {
-    SevGuestState *sev;
+    SevGuestState *sev = SEV_GUEST(htl);
     char *devname;
     int ret, fw_error;
     uint32_t ebx;
@@ -692,14 +638,7 @@ sev_guest_init(const char *id)
     ret = ram_block_discard_disable(true);
     if (ret) {
         error_report("%s: cannot disable RAM discard", __func__);
-        return NULL;
-    }
-
-    sev = lookup_sev_guest_info(id);
-    if (!sev) {
-        error_report("%s: '%s' is not a valid '%s' object",
-                     __func__, id, TYPE_SEV_GUEST);
-        goto err;
+        return -1;
     }
 
     sev_guest = sev;
@@ -763,17 +702,17 @@ sev_guest_init(const char *id)
     qemu_add_machine_init_done_notifier(&sev_machine_done_notify);
     qemu_add_vm_change_state_handler(sev_vm_state_change, sev);
 
-    return sev;
+    return 0;
 err:
     sev_guest = NULL;
     ram_block_discard_disable(false);
-    return NULL;
+    return -1;
 }
 
-int
-sev_encrypt_data(void *handle, uint8_t *ptr, uint64_t len)
+static int
+sev_encrypt_data(HostTrustLimitation *opaque, uint8_t *ptr, uint64_t len)
 {
-    SevGuestState *sev = handle;
+    SevGuestState *sev = SEV_GUEST(opaque);
 
     assert(sev);
 
@@ -785,6 +724,46 @@ sev_encrypt_data(void *handle, uint8_t *ptr, uint64_t len)
     return 0;
 }
 
+static void
+sev_guest_class_init(ObjectClass *oc, void *data)
+{
+    HostTrustLimitationClass *htlc = HOST_TRUST_LIMITATION_CLASS(oc);
+
+    object_class_property_add_str(oc, "sev-device",
+                                  sev_guest_get_sev_device,
+                                  sev_guest_set_sev_device);
+    object_class_property_set_description(oc, "sev-device",
+        "SEV device to use");
+    object_class_property_add_str(oc, "dh-cert-file",
+                                  sev_guest_get_dh_cert_file,
+                                  sev_guest_set_dh_cert_file);
+    object_class_property_set_description(oc, "dh-cert-file",
+        "guest owners DH certificate (encoded with base64)");
+    object_class_property_add_str(oc, "session-file",
+                                  sev_guest_get_session_file,
+                                  sev_guest_set_session_file);
+    object_class_property_set_description(oc, "session-file",
+        "guest owners session parameters (encoded with base64)");
+
+    htlc->kvm_init = sev_kvm_init;
+    htlc->encrypt_data = sev_encrypt_data;
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
+        { TYPE_HOST_TRUST_LIMITATION },
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

