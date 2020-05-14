Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A04301D27FA
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 08:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726005AbgENGl2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 02:41:28 -0400
Received: from ozlabs.org ([203.11.71.1]:59295 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725818AbgENGl1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 May 2020 02:41:27 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 49N24j4HLYz9sT2; Thu, 14 May 2020 16:41:25 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1589438485;
        bh=3is+X3Kh4vr6EuJLRPfai8Wdaqw70P12F8E8xlDgjTI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FRvpZB94My+pqXh40JkpqcL4g9tq0sScxcE0XO47WdwLZhkrqOrBqh0rxXTGwgk8D
         D5H49If9d3mhrUphpWvy5U1gx2+atSPNxNu5OLuOfNmVJXZQO7RCntFqQFf4M7EM4s
         YorWTXIbt7W6flqEwBaTWja896adjcK3h2teEAEM=
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
Subject: [RFC 03/18] target/i386: sev: Rename QSevGuestInfo
Date:   Thu, 14 May 2020 16:41:05 +1000
Message-Id: <20200514064120.449050-4-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200514064120.449050-1-david@gibson.dropbear.id.au>
References: <20200514064120.449050-1-david@gibson.dropbear.id.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

At the moment this is a purely passive object which is just a container for
information used elsewhere, hence the name.  I'm going to change that
though, so as a preliminary rename it to SevGuestState.

That name risks confusion with both SEVState and SevState, but I'll be
working on that in following patches.

Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
---
 target/i386/sev.c | 87 ++++++++++++++++++++++++-----------------------
 1 file changed, 44 insertions(+), 43 deletions(-)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index c7a6e3f6d2..0f7abe134a 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -29,22 +29,23 @@
 #include "trace.h"
 #include "migration/blocker.h"
 
-#define TYPE_QSEV_GUEST_INFO "sev-guest"
-#define QSEV_GUEST_INFO(obj)                  \
-    OBJECT_CHECK(QSevGuestInfo, (obj), TYPE_QSEV_GUEST_INFO)
+#define TYPE_SEV_GUEST "sev-guest"
+#define SEV_GUEST(obj)                                          \
+    OBJECT_CHECK(SevGuestState, (obj), TYPE_SEV_GUEST)
 
-typedef struct QSevGuestInfo QSevGuestInfo;
+typedef struct SevGuestState SevGuestState;
 
 /**
- * QSevGuestInfo:
+ * SevGuestState:
  *
- * The QSevGuestInfo object is used for creating a SEV guest.
+ * The SevGuestState object is used for creating and managing a SEV
+ * guest.
  *
  * # $QEMU \
  *         -object sev-guest,id=sev0 \
  *         -machine ...,memory-encryption=sev0
  */
-struct QSevGuestInfo {
+struct SevGuestState {
     Object parent_obj;
 
     char *sev_device;
@@ -57,7 +58,7 @@ struct QSevGuestInfo {
 };
 
 struct SEVState {
-    QSevGuestInfo *sev_info;
+    SevGuestState *sev_info;
     uint8_t api_major;
     uint8_t api_minor;
     uint8_t build_id;
@@ -235,85 +236,85 @@ static struct RAMBlockNotifier sev_ram_notifier = {
 };
 
 static void
-qsev_guest_finalize(Object *obj)
+sev_guest_finalize(Object *obj)
 {
 }
 
 static char *
-qsev_guest_get_session_file(Object *obj, Error **errp)
+sev_guest_get_session_file(Object *obj, Error **errp)
 {
-    QSevGuestInfo *s = QSEV_GUEST_INFO(obj);
+    SevGuestState *s = SEV_GUEST(obj);
 
     return s->session_file ? g_strdup(s->session_file) : NULL;
 }
 
 static void
-qsev_guest_set_session_file(Object *obj, const char *value, Error **errp)
+sev_guest_set_session_file(Object *obj, const char *value, Error **errp)
 {
-    QSevGuestInfo *s = QSEV_GUEST_INFO(obj);
+    SevGuestState *s = SEV_GUEST(obj);
 
     s->session_file = g_strdup(value);
 }
 
 static char *
-qsev_guest_get_dh_cert_file(Object *obj, Error **errp)
+sev_guest_get_dh_cert_file(Object *obj, Error **errp)
 {
-    QSevGuestInfo *s = QSEV_GUEST_INFO(obj);
+    SevGuestState *s = SEV_GUEST(obj);
 
     return g_strdup(s->dh_cert_file);
 }
 
 static void
-qsev_guest_set_dh_cert_file(Object *obj, const char *value, Error **errp)
+sev_guest_set_dh_cert_file(Object *obj, const char *value, Error **errp)
 {
-    QSevGuestInfo *s = QSEV_GUEST_INFO(obj);
+    SevGuestState *s = SEV_GUEST(obj);
 
     s->dh_cert_file = g_strdup(value);
 }
 
 static char *
-qsev_guest_get_sev_device(Object *obj, Error **errp)
+sev_guest_get_sev_device(Object *obj, Error **errp)
 {
-    QSevGuestInfo *sev = QSEV_GUEST_INFO(obj);
+    SevGuestState *sev = SEV_GUEST(obj);
 
     return g_strdup(sev->sev_device);
 }
 
 static void
-qsev_guest_set_sev_device(Object *obj, const char *value, Error **errp)
+sev_guest_set_sev_device(Object *obj, const char *value, Error **errp)
 {
-    QSevGuestInfo *sev = QSEV_GUEST_INFO(obj);
+    SevGuestState *sev = SEV_GUEST(obj);
 
     sev->sev_device = g_strdup(value);
 }
 
 static void
-qsev_guest_class_init(ObjectClass *oc, void *data)
+sev_guest_class_init(ObjectClass *oc, void *data)
 {
     object_class_property_add_str(oc, "sev-device",
-                                  qsev_guest_get_sev_device,
-                                  qsev_guest_set_sev_device,
+                                  sev_guest_get_sev_device,
+                                  sev_guest_set_sev_device,
                                   NULL);
     object_class_property_set_description(oc, "sev-device",
             "SEV device to use", NULL);
     object_class_property_add_str(oc, "dh-cert-file",
-                                  qsev_guest_get_dh_cert_file,
-                                  qsev_guest_set_dh_cert_file,
+                                  sev_guest_get_dh_cert_file,
+                                  sev_guest_set_dh_cert_file,
                                   NULL);
     object_class_property_set_description(oc, "dh-cert-file",
             "guest owners DH certificate (encoded with base64)", NULL);
     object_class_property_add_str(oc, "session-file",
-                                  qsev_guest_get_session_file,
-                                  qsev_guest_set_session_file,
+                                  sev_guest_get_session_file,
+                                  sev_guest_set_session_file,
                                   NULL);
     object_class_property_set_description(oc, "session-file",
             "guest owners session parameters (encoded with base64)", NULL);
 }
 
 static void
-qsev_guest_init(Object *obj)
+sev_guest_instance_init(Object *obj)
 {
-    QSevGuestInfo *sev = QSEV_GUEST_INFO(obj);
+    SevGuestState *sev = SEV_GUEST(obj);
 
     sev->sev_device = g_strdup(DEFAULT_SEV_DEVICE);
     sev->policy = DEFAULT_GUEST_POLICY;
@@ -329,32 +330,32 @@ qsev_guest_init(Object *obj)
 }
 
 /* sev guest info */
-static const TypeInfo qsev_guest_info = {
+static const TypeInfo sev_guest_info = {
     .parent = TYPE_OBJECT,
-    .name = TYPE_QSEV_GUEST_INFO,
-    .instance_size = sizeof(QSevGuestInfo),
-    .instance_finalize = qsev_guest_finalize,
-    .class_init = qsev_guest_class_init,
-    .instance_init = qsev_guest_init,
+    .name = TYPE_SEV_GUEST,
+    .instance_size = sizeof(SevGuestState),
+    .instance_finalize = sev_guest_finalize,
+    .class_init = sev_guest_class_init,
+    .instance_init = sev_guest_instance_init,
     .interfaces = (InterfaceInfo[]) {
         { TYPE_USER_CREATABLE },
         { }
     }
 };
 
-static QSevGuestInfo *
+static SevGuestState *
 lookup_sev_guest_info(const char *id)
 {
     Object *obj;
-    QSevGuestInfo *info;
+    SevGuestState *info;
 
     obj = object_resolve_path_component(object_get_objects_root(), id);
     if (!obj) {
         return NULL;
     }
 
-    info = (QSevGuestInfo *)
-            object_dynamic_cast(obj, TYPE_QSEV_GUEST_INFO);
+    info = (SevGuestState *)
+            object_dynamic_cast(obj, TYPE_SEV_GUEST);
     if (!info) {
         return NULL;
     }
@@ -513,7 +514,7 @@ sev_launch_start(SEVState *s)
     gsize sz;
     int ret = 1;
     int fw_error, rc;
-    QSevGuestInfo *sev = s->sev_info;
+    SevGuestState *sev = s->sev_info;
     struct kvm_sev_launch_start *start;
     guchar *session = NULL, *dh_cert = NULL;
 
@@ -699,7 +700,7 @@ sev_guest_init(const char *id)
     s->sev_info = lookup_sev_guest_info(id);
     if (!s->sev_info) {
         error_report("%s: '%s' is not a valid '%s' object",
-                     __func__, id, TYPE_QSEV_GUEST_INFO);
+                     __func__, id, TYPE_SEV_GUEST);
         goto err;
     }
 
@@ -789,7 +790,7 @@ sev_encrypt_data(void *handle, uint8_t *ptr, uint64_t len)
 static void
 sev_register_types(void)
 {
-    type_register_static(&qsev_guest_info);
+    type_register_static(&sev_guest_info);
 }
 
 type_init(sev_register_types);
-- 
2.26.2

