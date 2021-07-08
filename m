Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C05E73BF31D
	for <lists+kvm@lfdr.de>; Thu,  8 Jul 2021 02:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231187AbhGHA7G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jul 2021 20:59:06 -0400
Received: from mga03.intel.com ([134.134.136.65]:19087 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230240AbhGHA6j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jul 2021 20:58:39 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10038"; a="209462010"
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="209462010"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2021 17:55:58 -0700
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="423770085"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2021 17:55:57 -0700
From:   isaku.yamahata@gmail.com
To:     qemu-devel@nongnu.org, pbonzini@redhat.com, alistair@alistair23.me,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        cohuck@redhat.com, mtosatti@redhat.com, xiaoyao.li@intel.com,
        seanjc@google.com, erdemaktas@google.com
Cc:     kvm@vger.kernel.org, isaku.yamahata@gmail.com,
        isaku.yamahata@intel.com
Subject: [RFC PATCH v2 30/44] qom: implement property helper for sha384
Date:   Wed,  7 Jul 2021 17:55:00 -0700
Message-Id: <398d321c9c74c43bf0fa137c04932b1b7a89efab.1625704981.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1625704980.git.isaku.yamahata@intel.com>
References: <cover.1625704980.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Implement property_add_sha384() which converts hex string <-> uint8_t[48]
It will be used for TDX which uses sha384 for measurement.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 include/qom/object.h | 17 ++++++++++
 qom/object.c         | 76 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 93 insertions(+)

diff --git a/include/qom/object.h b/include/qom/object.h
index 6721cd312e..594d0ec52c 100644
--- a/include/qom/object.h
+++ b/include/qom/object.h
@@ -1853,6 +1853,23 @@ ObjectProperty *object_property_add_alias(Object *obj, const char *name,
 ObjectProperty *object_property_add_const_link(Object *obj, const char *name,
                                                Object *target);
 
+
+/**
+ * object_property_add_sha384:
+ * @obj: the object to add a property to
+ * @name: the name of the property
+ * @v: pointer to value
+ * @flags: bitwise-or'd ObjectPropertyFlags
+ *
+ * Add an sha384 property in memory.  This function will add a
+ * property of type 'sha384'.
+ *
+ * Returns: The newly added property on success, or %NULL on failure.
+ */
+ObjectProperty * object_property_add_sha384(Object *obj, const char *name,
+                                            const uint8_t *v,
+                                            ObjectPropertyFlags flags);
+
 /**
  * object_property_set_description:
  * @obj: the object owning the property
diff --git a/qom/object.c b/qom/object.c
index 6a01d56546..e33a0b8c5d 100644
--- a/qom/object.c
+++ b/qom/object.c
@@ -15,6 +15,7 @@
 #include "qapi/error.h"
 #include "qom/object.h"
 #include "qom/object_interfaces.h"
+#include "qemu/ctype.h"
 #include "qemu/cutils.h"
 #include "qapi/visitor.h"
 #include "qapi/string-input-visitor.h"
@@ -2749,6 +2750,81 @@ object_property_add_alias(Object *obj, const char *name,
     return op;
 }
 
+#define SHA384_DIGEST_SIZE      48
+static void property_get_sha384(Object *obj, Visitor *v, const char *name,
+                                void *opaque, Error **errp)
+{
+    uint8_t *value = (uint8_t *)opaque;
+    char str[SHA384_DIGEST_SIZE * 2 + 1];
+    char *str_ = (char*)str;
+    size_t i;
+
+    for (i = 0; i < SHA384_DIGEST_SIZE; i++) {
+        char *buf;
+        buf = &str[i * 2];
+
+        sprintf(buf, "%02hhx", value[i]);
+    }
+    str[SHA384_DIGEST_SIZE * 2] = '\0';
+
+    visit_type_str(v, name, &str_, errp);
+}
+
+static void property_set_sha384(Object *obj, Visitor *v, const char *name,
+                                    void *opaque, Error **errp)
+{
+    uint8_t *value = (uint8_t *)opaque;
+    char* str;
+    size_t len;
+    size_t i;
+
+    if (!visit_type_str(v, name, &str, errp)) {
+        goto err;
+    }
+
+    len = strlen(str);
+    if (len != SHA384_DIGEST_SIZE * 2) {
+        error_setg(errp, "invalid length for sha348 hex string %s. "
+                   "it must be 48 * 2 hex", name);
+        goto err;
+    }
+
+    for (i = 0; i < SHA384_DIGEST_SIZE; i++) {
+        if (!qemu_isxdigit(str[i * 2]) || !qemu_isxdigit(str[i * 2 + 1])) {
+            error_setg(errp, "invalid char for sha318 hex string %s at %c%c",
+                       name, str[i * 2], str[i * 2 + 1]);
+            goto err;
+        }
+
+        if (sscanf(str + i * 2, "%02hhx", &value[i]) != 1) {
+            error_setg(errp, "invalid format for sha318 hex string %s", name);
+            goto err;
+        }
+    }
+
+err:
+    g_free(str);
+}
+
+ObjectProperty *
+object_property_add_sha384(Object *obj, const char *name,
+                           const uint8_t *v, ObjectPropertyFlags flags)
+{
+    ObjectPropertyAccessor *getter = NULL;
+    ObjectPropertyAccessor *setter = NULL;
+
+    if ((flags & OBJ_PROP_FLAG_READ) == OBJ_PROP_FLAG_READ) {
+        getter = property_get_sha384;
+    }
+
+    if ((flags & OBJ_PROP_FLAG_WRITE) == OBJ_PROP_FLAG_WRITE) {
+        setter = property_set_sha384;
+    }
+
+    return object_property_add(obj, name, "sha384",
+                               getter, setter, NULL, (void *)v);
+}
+
 void object_property_set_description(Object *obj, const char *name,
                                      const char *description)
 {
-- 
2.25.1

