Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E2CF2CE7AE
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 06:45:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728121AbgLDFpA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Dec 2020 00:45:00 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:51703 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728108AbgLDFpA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Dec 2020 00:45:00 -0500
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4CnM8f6LNcz9sSs; Fri,  4 Dec 2020 16:44:18 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1607060658;
        bh=TI0InttZ4cpldxy+Is/TnhjLzGIsGHaeLN81S9U7Zsg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D2OoZAh2yLriCG90unCBwKyMskSc/APR+ROuvB7A5a/UzSm3GKMPtumVEk+EN8dF9
         1N41Mi1ebQNPsiZtXIIjgDar2WWHr27OOQW+E/ox29F+dxRDxo7hORY+JZp+Vtkh7d
         bot4qHvcnMbfOtshTQnIjVYFywa38eiC5mOK9V7I=
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
        pasic@linux.ibm.com, Greg Kurz <groug@kaod.org>
Subject: [for-6.0 v5 01/13] qom: Allow optional sugar props
Date:   Fri,  4 Dec 2020 16:44:03 +1100
Message-Id: <20201204054415.579042-2-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201204054415.579042-1-david@gibson.dropbear.id.au>
References: <20201204054415.579042-1-david@gibson.dropbear.id.au>
MIME-Version: 1.0
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
---
 include/qom/object.h |  3 ++-
 qom/object.c         |  4 +++-
 softmmu/vl.c         | 16 ++++++++++------
 3 files changed, 15 insertions(+), 8 deletions(-)

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
index 1065355233..62218bb17d 100644
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
 
diff --git a/softmmu/vl.c b/softmmu/vl.c
index e6e0ad5a92..cf4a9dc198 100644
--- a/softmmu/vl.c
+++ b/softmmu/vl.c
@@ -884,7 +884,7 @@ static void configure_rtc(QemuOpts *opts)
         if (!strcmp(value, "slew")) {
             object_register_sugar_prop("mc146818rtc",
                                        "lost_tick_policy",
-                                       "slew");
+                                       "slew", false);
         } else if (!strcmp(value, "none")) {
             /* discard is default */
         } else {
@@ -2498,12 +2498,14 @@ static int machine_set_property(void *opaque,
         return 0;
     }
     if (g_str_equal(qom_name, "igd-passthru")) {
-        object_register_sugar_prop(ACCEL_CLASS_NAME("xen"), qom_name, value);
+        object_register_sugar_prop(ACCEL_CLASS_NAME("xen"), qom_name, value,
+                                   false);
         return 0;
     }
     if (g_str_equal(qom_name, "kvm-shadow-mem") ||
         g_str_equal(qom_name, "kernel-irqchip")) {
-        object_register_sugar_prop(ACCEL_CLASS_NAME("kvm"), qom_name, value);
+        object_register_sugar_prop(ACCEL_CLASS_NAME("kvm"), qom_name, value,
+                                   false);
         return 0;
     }
 
@@ -3645,7 +3647,8 @@ void qemu_init(int argc, char **argv, char **envp)
                 exit(1);
 #endif
                 warn_report("The -tb-size option is deprecated, use -accel tcg,tb-size instead");
-                object_register_sugar_prop(ACCEL_CLASS_NAME("tcg"), "tb-size", optarg);
+                object_register_sugar_prop(ACCEL_CLASS_NAME("tcg"), "tb-size",
+                                           optarg, false);
                 break;
             case QEMU_OPTION_icount:
                 icount_opts = qemu_opts_parse_noisily(qemu_find_opts("icount"),
@@ -3996,9 +3999,10 @@ void qemu_init(int argc, char **argv, char **envp)
         char *val;
 
         val = g_strdup_printf("%d", current_machine->smp.cpus);
-        object_register_sugar_prop("memory-backend", "prealloc-threads", val);
+        object_register_sugar_prop("memory-backend", "prealloc-threads", val,
+                                   false);
         g_free(val);
-        object_register_sugar_prop("memory-backend", "prealloc", "on");
+        object_register_sugar_prop("memory-backend", "prealloc", "on", false);
     }
 
     /*
-- 
2.28.0

