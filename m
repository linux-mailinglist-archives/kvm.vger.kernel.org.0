Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31F8F780923
	for <lists+kvm@lfdr.de>; Fri, 18 Aug 2023 11:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359439AbjHRJ4z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Aug 2023 05:56:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359475AbjHRJ41 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Aug 2023 05:56:27 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 956893C1E
        for <kvm@vger.kernel.org>; Fri, 18 Aug 2023 02:56:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692352569; x=1723888569;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YHMk3uk6o95oadbFae3CGNbGH8ZiUOpdSrULMBfEA+g=;
  b=JLd6EpqdkmgM4TKV86WAUSohZDPkmwXWk6u1J/yiglwtFa8wPiB5qS1W
   6R4GHTJ5HzuEV6oId2tj4Gd08irWcakMMFJmxO3aVvP6Z5j6ZiuYklAqS
   YfcFeI3LsbWhTejnSJZV0sn+3lLa2MeRtXIPloJCxC48W3Pz2x+n8VeOQ
   Q+lWeY8lZoNU8ge+/3ASxjzUkmFbCDkN9JEPaPd8DPB9UPkD/Ey+GNANA
   j3Q+52p9nFwQmoEevmMHOtkUF1jAR0h/Y/cT92p/ePqTTvC/pP9TOQbcZ
   yHCfpDP+/Hq/wllfiM7aB62JbA/p9f1R7TppvBtstvjfyF17bR54vSy6r
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="371965924"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="371965924"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2023 02:56:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="849235075"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="849235075"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.46])
  by fmsmga002.fm.intel.com with ESMTP; 18 Aug 2023 02:56:01 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Ani Sinha <anisinha@redhat.com>, Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Eduardo Habkost <eduardo@habkost.net>,
        Laszlo Ersek <lersek@redhat.com>, xiaoyao.li@intel.com,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        erdemaktas@google.com, Chenyi Qiang <chenyi.qiang@intel.com>
Subject: [PATCH v2 19/58] qom: implement property helper for sha384
Date:   Fri, 18 Aug 2023 05:50:02 -0400
Message-Id: <20230818095041.1973309-20-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230818095041.1973309-1-xiaoyao.li@intel.com>
References: <20230818095041.1973309-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Implement property_add_sha384() which converts hex string <-> uint8_t[48]
It will be used for TDX which uses sha384 for measurement.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 include/qom/object.h | 17 ++++++++++
 qom/object.c         | 76 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 93 insertions(+)

diff --git a/include/qom/object.h b/include/qom/object.h
index ef7258a5e149..70399a5b1940 100644
--- a/include/qom/object.h
+++ b/include/qom/object.h
@@ -1887,6 +1887,23 @@ ObjectProperty *object_property_add_alias(Object *obj, const char *name,
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
index e25f1e96db1e..e71ce46ed576 100644
--- a/qom/object.c
+++ b/qom/object.c
@@ -15,6 +15,7 @@
 #include "qapi/error.h"
 #include "qom/object.h"
 #include "qom/object_interfaces.h"
+#include "qemu/ctype.h"
 #include "qemu/cutils.h"
 #include "qemu/memalign.h"
 #include "qapi/visitor.h"
@@ -2781,6 +2782,81 @@ object_property_add_alias(Object *obj, const char *name,
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
2.34.1

