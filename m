Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0101B2F56D3
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 02:58:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728261AbhANBxo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 20:53:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729678AbhAMX7I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jan 2021 18:59:08 -0500
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1B38C0617A3
        for <kvm@vger.kernel.org>; Wed, 13 Jan 2021 15:58:20 -0800 (PST)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4DGPXQ0Kttz9sVy; Thu, 14 Jan 2021 10:58:13 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1610582294;
        bh=PMr7j5j8OSe0AP5kUuFMOJLePX4fph0iQtNNjr88kFA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WOU/Nolj6jlStIr4NRM6WXyowwAzxfu41mUBsAt2hjacUVyKfMzCuBeg3nnoRXdhH
         hz2tPK9t7Dy95n4vvy1Ul/4WMa/beNDURAUo0XociRRNmbNIiWM7vgaXJPhjxnXS8J
         E1NNnb87UwZo6RN48TQLEmCj5ir03CdkKQRyk5r4=
From:   David Gibson <david@gibson.dropbear.id.au>
To:     brijesh.singh@amd.com, pair@us.ibm.com, dgilbert@redhat.com,
        pasic@linux.ibm.com, qemu-devel@nongnu.org
Cc:     cohuck@redhat.com,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        David Hildenbrand <david@redhat.com>, borntraeger@de.ibm.com,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>, mst@redhat.com,
        jun.nakajima@intel.com, thuth@redhat.com,
        pragyansri.pathi@intel.com, kvm@vger.kernel.org,
        Eduardo Habkost <ehabkost@redhat.com>, qemu-s390x@nongnu.org,
        qemu-ppc@nongnu.org, frankja@linux.ibm.com,
        Greg Kurz <groug@kaod.org>, mdroth@linux.vnet.ibm.com,
        David Gibson <david@gibson.dropbear.id.au>,
        berrange@redhat.com, andi.kleen@intel.com,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [PATCH v7 01/13] qom: Allow optional sugar props
Date:   Thu, 14 Jan 2021 10:57:59 +1100
Message-Id: <20210113235811.1909610-2-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210113235811.1909610-1-david@gibson.dropbear.id.au>
References: <20210113235811.1909610-1-david@gibson.dropbear.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Greg Kurz <groug@kaod.org>

Global properties have an @optional field, which allows to apply a given
property to a given type even if one of its subclasses doesn't support
it. This is especially used in the compat code when dealing with the
"disable-modern" and "disable-legacy" properties and the "virtio-pci"
type.

Allow object_register_sugar_prop() to set this field as well.

Signed-off-by: Greg Kurz <groug@kaod.org>
Message-Id: <159738953558.377274.16617742952571083440.stgit@bahia.lan>
Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
Reviewed-by: Eduardo Habkost <ehabkost@redhat.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 include/qom/object.h |  3 ++-
 qom/object.c         |  4 +++-
 softmmu/rtc.c        |  3 ++-
 softmmu/vl.c         | 17 +++++++++++------
 4 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/include/qom/object.h b/include/qom/object.h
index d378f13a11..6721cd312e 100644
--- a/include/qom/object.h
+++ b/include/qom/object.h
@@ -638,7 +638,8 @@ bool object_apply_global_props(Object *obj, const GPtrArray *props,
                                Error **errp);
 void object_set_machine_compat_props(GPtrArray *compat_props);
 void object_set_accelerator_compat_props(GPtrArray *compat_props);
-void object_register_sugar_prop(const char *driver, const char *prop, const char *value);
+void object_register_sugar_prop(const char *driver, const char *prop,
+                                const char *value, bool optional);
 void object_apply_compat_props(Object *obj);
 
 /**
diff --git a/qom/object.c b/qom/object.c
index 2fa0119647..491823db4a 100644
--- a/qom/object.c
+++ b/qom/object.c
@@ -442,7 +442,8 @@ static GPtrArray *object_compat_props[3];
  * other than "-global".  These are generally used for syntactic
  * sugar and legacy command line options.
  */
-void object_register_sugar_prop(const char *driver, const char *prop, const char *value)
+void object_register_sugar_prop(const char *driver, const char *prop,
+                                const char *value, bool optional)
 {
     GlobalProperty *g;
     if (!object_compat_props[2]) {
@@ -452,6 +453,7 @@ void object_register_sugar_prop(const char *driver, const char *prop, const char
     g->driver = g_strdup(driver);
     g->property = g_strdup(prop);
     g->value = g_strdup(value);
+    g->optional = optional;
     g_ptr_array_add(object_compat_props[2], g);
 }
 
diff --git a/softmmu/rtc.c b/softmmu/rtc.c
index e1e15ef613..5632684fc9 100644
--- a/softmmu/rtc.c
+++ b/softmmu/rtc.c
@@ -179,7 +179,8 @@ void configure_rtc(QemuOpts *opts)
         if (!strcmp(value, "slew")) {
             object_register_sugar_prop("mc146818rtc",
                                        "lost_tick_policy",
-                                       "slew");
+                                       "slew",
+                                       false);
         } else if (!strcmp(value, "none")) {
             /* discard is default */
         } else {
diff --git a/softmmu/vl.c b/softmmu/vl.c
index 7ddf405d76..3f7721b83e 100644
--- a/softmmu/vl.c
+++ b/softmmu/vl.c
@@ -1663,16 +1663,20 @@ static int machine_set_property(void *opaque,
         return 0;
     }
     if (g_str_equal(qom_name, "igd-passthru")) {
-        object_register_sugar_prop(ACCEL_CLASS_NAME("xen"), qom_name, value);
+        object_register_sugar_prop(ACCEL_CLASS_NAME("xen"), qom_name, value,
+                                   false);
         return 0;
     }
     if (g_str_equal(qom_name, "kvm-shadow-mem")) {
-        object_register_sugar_prop(ACCEL_CLASS_NAME("kvm"), qom_name, value);
+        object_register_sugar_prop(ACCEL_CLASS_NAME("kvm"), qom_name, value,
+                                   false);
         return 0;
     }
     if (g_str_equal(qom_name, "kernel-irqchip")) {
-        object_register_sugar_prop(ACCEL_CLASS_NAME("kvm"), qom_name, value);
-        object_register_sugar_prop(ACCEL_CLASS_NAME("whpx"), qom_name, value);
+        object_register_sugar_prop(ACCEL_CLASS_NAME("kvm"), qom_name, value,
+                                   false);
+        object_register_sugar_prop(ACCEL_CLASS_NAME("whpx"), qom_name, value,
+                                   false);
         return 0;
     }
 
@@ -2297,9 +2301,10 @@ static void qemu_process_sugar_options(void)
 
         val = g_strdup_printf("%d",
                  (uint32_t) qemu_opt_get_number(qemu_find_opts_singleton("smp-opts"), "cpus", 1));
-        object_register_sugar_prop("memory-backend", "prealloc-threads", val);
+        object_register_sugar_prop("memory-backend", "prealloc-threads", val,
+                                   false);
         g_free(val);
-        object_register_sugar_prop("memory-backend", "prealloc", "on");
+        object_register_sugar_prop("memory-backend", "prealloc", "on", false);
     }
 
     if (watchdog) {
-- 
2.29.2

