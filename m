Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB813ADC55
	for <lists+kvm@lfdr.de>; Sun, 20 Jun 2021 04:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbhFTCaH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 19 Jun 2021 22:30:07 -0400
Received: from mga12.intel.com ([192.55.52.136]:39960 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230236AbhFTCaH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 19 Jun 2021 22:30:07 -0400
IronPort-SDR: upc2F6LVgJ2KYniAA2ZFbSdGnmTaTsnJEeJjZxq9BemlGp7/63o4QyyJaIhW9rjCyvWjcGbUZx
 5RDF+EufWN3A==
X-IronPort-AV: E=McAfee;i="6200,9189,10020"; a="186389885"
X-IronPort-AV: E=Sophos;i="5.83,286,1616482800"; 
   d="scan'208";a="186389885"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2021 19:27:55 -0700
IronPort-SDR: 4pAXabuFJpfuZZ76hcFnMU3wu05cM0jl++IWFDfSSd3JfyEgenyoD56ARZ6OAEToHbqMFCFMsG
 nnamTfVzRpTw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,286,1616482800"; 
   d="scan'208";a="486095352"
Received: from michael-optiplex-9020.sh.intel.com ([10.239.159.182])
  by orsmga001.jf.intel.com with ESMTP; 19 Jun 2021 19:27:53 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, qemu-devel@nongnu.org, kvm@vger.kernel.org,
        richard.henderson@linaro.org, armbru@redhat.com,
        wei.w.wang@intel.com
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v4 1/2] qdev-properties: Add a new macro with bitmask check for uint64_t property
Date:   Sun, 20 Jun 2021 10:42:36 +0800
Message-Id: <1624156957-7223-1-git-send-email-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The DEFINE_PROP_UINT64_CHECKMASK maro applies certain mask check agaist
user-supplied property value, reject the value if it violates the bitmask.

Co-developed-by: Like Xu <like.xu@linux.intel.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 hw/core/qdev-properties.c    | 19 +++++++++++++++++++
 include/hw/qdev-properties.h | 12 ++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/hw/core/qdev-properties.c b/hw/core/qdev-properties.c
index 50f40949f5..343a200784 100644
--- a/hw/core/qdev-properties.c
+++ b/hw/core/qdev-properties.c
@@ -428,6 +428,25 @@ const PropertyInfo qdev_prop_int64 = {
     .set_default_value = qdev_propinfo_set_default_value_int,
 };
 
+static void set_uint64_checkmask(Object *obj, Visitor *v, const char *name,
+                      void *opaque, Error **errp)
+{
+    Property *prop = opaque;
+    uint64_t *ptr = object_field_prop_ptr(obj, prop);
+
+    visit_type_uint64(v, name, ptr, errp);
+    if (*ptr & ~prop->bitmask) {
+        error_setg(errp, "Property value for '%s' violates bitmask '0x%lx'",
+                   name, prop->bitmask);
+    }
+}
+
+const PropertyInfo qdev_prop_uint64_checkmask = {
+    .name  = "uint64",
+    .get   = get_uint64,
+    .set   = set_uint64_checkmask,
+};
+
 /* --- string --- */
 
 static void release_string(Object *obj, const char *name, void *opaque)
diff --git a/include/hw/qdev-properties.h b/include/hw/qdev-properties.h
index 0ef97d60ce..075882e8c1 100644
--- a/include/hw/qdev-properties.h
+++ b/include/hw/qdev-properties.h
@@ -17,6 +17,7 @@ struct Property {
     const PropertyInfo *info;
     ptrdiff_t    offset;
     uint8_t      bitnr;
+    uint64_t     bitmask;
     bool         set_default;
     union {
         int64_t i;
@@ -53,6 +54,7 @@ extern const PropertyInfo qdev_prop_uint16;
 extern const PropertyInfo qdev_prop_uint32;
 extern const PropertyInfo qdev_prop_int32;
 extern const PropertyInfo qdev_prop_uint64;
+extern const PropertyInfo qdev_prop_uint64_checkmask;
 extern const PropertyInfo qdev_prop_int64;
 extern const PropertyInfo qdev_prop_size;
 extern const PropertyInfo qdev_prop_string;
@@ -102,6 +104,16 @@ extern const PropertyInfo qdev_prop_link;
                 .set_default = true,                         \
                 .defval.u    = (bool)_defval)
 
+/**
+ * The DEFINE_PROP_UINT64_CHECKMASK macro checks a user-supplied value
+ * against corresponding bitmask, rejects the value if it violates.
+ * The default value is set in instance_init().
+ */
+#define DEFINE_PROP_UINT64_CHECKMASK(_name, _state, _field, _bitmask)   \
+    DEFINE_PROP(_name, _state, _field, qdev_prop_uint64_checkmask, uint64_t, \
+                .bitmask    = (_bitmask),                     \
+                .set_default = false)
+
 #define PROP_ARRAY_LEN_PREFIX "len-"
 
 /**
-- 
2.21.1

