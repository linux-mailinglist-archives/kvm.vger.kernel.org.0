Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF0091DC5D1
	for <lists+kvm@lfdr.de>; Thu, 21 May 2020 05:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728103AbgEUDnm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 23:43:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728285AbgEUDnS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 May 2020 23:43:18 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51634C061A0F
        for <kvm@vger.kernel.org>; Wed, 20 May 2020 20:43:18 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 49SFns5ftgz9sV2; Thu, 21 May 2020 13:43:13 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1590032593;
        bh=gQ7WBzFCWsSO8Y6ZBoDXD7CE89Jjg6PXDsNnEC8gJ/Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n0ZFujptmNQqtbScYQR4NUz+GHU4Vsgmyl8ih2NxLksU8mYVfT4boyRqjAwNl3Xmi
         awB/JgMXVbR+xvGfa/QWWx0we5QVVFToVhV6hotfIpLip9UKr6WoROxF7EVDs4/+3N
         09EIlfDem8HP41lnmEC3dVhyeuDNQAREPYoJITC8=
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
Subject: [RFC v2 12/18] guest memory protection: Perform KVM init via interface
Date:   Thu, 21 May 2020 13:42:58 +1000
Message-Id: <20200521034304.340040-13-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200521034304.340040-1-david@gibson.dropbear.id.au>
References: <20200521034304.340040-1-david@gibson.dropbear.id.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently the "memory-encryption" machine option is notionally generic,
but in fact is only used for AMD SEV setups.  Make another step towards it
being actually generic, but having using the GuestMemoryProtection QOM
interface to dispatch the initial setup, rather than directly calling
sev_guest_init() from kvm_init().

Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
---
 accel/kvm/kvm-all.c                    | 18 ++++++++++---
 include/exec/guest-memory-protection.h |  1 +
 target/i386/sev.c                      | 37 ++++----------------------
 3 files changed, 21 insertions(+), 35 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 40997de38c..5cf1a397e3 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -39,7 +39,6 @@
 #include "qemu/main-loop.h"
 #include "trace.h"
 #include "hw/irq.h"
-#include "sysemu/sev.h"
 #include "sysemu/balloon.h"
 #include "qapi/visitor.h"
 #include "qapi/qapi-types-common.h"
@@ -2104,8 +2103,21 @@ static int kvm_init(MachineState *ms)
      * encryption context.
      */
     if (ms->memory_encryption) {
-        kvm_state->guest_memory_protection = sev_guest_init(ms->memory_encryption);
-        if (!kvm_state->guest_memory_protection) {
+        Object *obj = object_resolve_path_component(object_get_objects_root(),
+                                                    ms->memory_encryption);
+
+        if (object_dynamic_cast(obj, TYPE_GUEST_MEMORY_PROTECTION)) {
+            GuestMemoryProtection *gmpo = GUEST_MEMORY_PROTECTION(obj);
+            GuestMemoryProtectionClass *gmpc =
+                GUEST_MEMORY_PROTECTION_GET_CLASS(gmpo);
+
+            ret = gmpc->kvm_init(gmpo);
+            if (ret < 0) {
+                goto err;
+            }
+
+            kvm_state->guest_memory_protection = gmpo;
+        } else {
             ret = -1;
             goto err;
         }
diff --git a/include/exec/guest-memory-protection.h b/include/exec/guest-memory-protection.h
index eb712a5804..3707b96515 100644
--- a/include/exec/guest-memory-protection.h
+++ b/include/exec/guest-memory-protection.h
@@ -31,6 +31,7 @@ typedef struct GuestMemoryProtection GuestMemoryProtection;
 typedef struct GuestMemoryProtectionClass {
     InterfaceClass parent;
 
+    int (*kvm_init)(GuestMemoryProtection *);
     int (*encrypt_data)(GuestMemoryProtection *, uint8_t *, uint64_t);
 } GuestMemoryProtectionClass;
 
diff --git a/target/i386/sev.c b/target/i386/sev.c
index 986c2fee51..60e9d8c735 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -300,26 +300,6 @@ sev_guest_instance_init(Object *obj)
                                    OBJ_PROP_FLAG_READWRITE);
 }
 
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
@@ -637,23 +617,15 @@ sev_vm_state_change(void *opaque, int running, RunState state)
     }
 }
 
-GuestMemoryProtection *
-sev_guest_init(const char *id)
+static int sev_kvm_init(GuestMemoryProtection *gmpo)
 {
-    SevGuestState *sev;
+    SevGuestState *sev = SEV_GUEST(gmpo);
     char *devname;
     int ret, fw_error;
     uint32_t ebx;
     uint32_t host_cbitpos;
     struct sev_user_data_status status = {};
 
-    sev = lookup_sev_guest_info(id);
-    if (!sev) {
-        error_report("%s: '%s' is not a valid '%s' object",
-                     __func__, id, TYPE_SEV_GUEST);
-        goto err;
-    }
-
     sev_guest = sev;
     sev->state = SEV_STATE_UNINIT;
 
@@ -715,10 +687,10 @@ sev_guest_init(const char *id)
     qemu_add_machine_init_done_notifier(&sev_machine_done_notify);
     qemu_add_vm_change_state_handler(sev_vm_state_change, sev);
 
-    return GUEST_MEMORY_PROTECTION(sev);
+    return 0;
 err:
     sev_guest = NULL;
-    return NULL;
+    return -1;
 }
 
 static int
@@ -757,6 +729,7 @@ sev_guest_class_init(ObjectClass *oc, void *data)
     object_class_property_set_description(oc, "session-file",
         "guest owners session parameters (encoded with base64)");
 
+    gmpc->kvm_init = sev_kvm_init;
     gmpc->encrypt_data = sev_encrypt_data;
 }
 
-- 
2.26.2

