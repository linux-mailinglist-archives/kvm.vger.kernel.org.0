Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E82E1496B08
	for <lists+kvm@lfdr.de>; Sat, 22 Jan 2022 09:37:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233795AbiAVIhs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Jan 2022 03:37:48 -0500
Received: from mga06.intel.com ([134.134.136.31]:1159 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231217AbiAVIhr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Jan 2022 03:37:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642840667; x=1674376667;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Aqdv8MZYaBIeZdcgvu5e2Fh6FIGmCmAW19zWgTGh2xk=;
  b=KQeDqEzWjYm/KoMjMdQNhNYZNegIZxvdy0nD22IYKaCrmXGIzlFT671k
   YNyG391Ha3RQY2XVGc6znvbPQtrGri4mI5Qph/6ePesDzZfpY3HuHsCUI
   EBhXJFTbdoP8wLKcscDi5MsN2CYU2YwqfkddcZ9atg+ZAMGrn51EzHBXU
   kpg+gYCKbh4icLrBMZCjSleZH84u9EXv6gAR3Qv1hYj2uo5LTqZ/Icbqh
   BeX6pSLSV1vr2nG6EB7cz2w+xbRuM5a8izIstcLX/0wg63S3fPswXQGf1
   WcMvGbWoL64aAOBTqIKaAGIe8HSkhFSMD+KoLWZUPAzZR88Ndl/k0AruX
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10234"; a="306524173"
X-IronPort-AV: E=Sophos;i="5.88,307,1635231600"; 
   d="scan'208";a="306524173"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2022 00:37:46 -0800
X-IronPort-AV: E=Sophos;i="5.88,307,1635231600"; 
   d="scan'208";a="765937377"
Received: from sqa-gate.sh.intel.com (HELO michael.clx.dev.tsp.org) ([10.239.48.212])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2022 00:37:44 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, ehabkost@redhat.com, mtosatti@redhat.com,
        richard.henderson@linaro.org, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, likexu@tencent.com, wei.w.wang@intel.com
Cc:     weijiang.yang@intel.com, Like Xu <like.xu@linux.intel.com>
Subject: [PATCH v5 1/2] qdev-properties: Add a new macro with bitmask check for uint64_t property
Date:   Sun, 23 Jan 2022 00:12:00 +0800
Message-Id: <20220122161201.73528-2-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20220122161201.73528-1-weijiang.yang@intel.com>
References: <20220122161201.73528-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
index c34aac6ebc..27566e5ef7 100644
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
index f7925f67d0..e1df08876c 100644
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
@@ -54,6 +55,7 @@ extern const PropertyInfo qdev_prop_uint16;
 extern const PropertyInfo qdev_prop_uint32;
 extern const PropertyInfo qdev_prop_int32;
 extern const PropertyInfo qdev_prop_uint64;
+extern const PropertyInfo qdev_prop_uint64_checkmask;
 extern const PropertyInfo qdev_prop_int64;
 extern const PropertyInfo qdev_prop_size;
 extern const PropertyInfo qdev_prop_string;
@@ -103,6 +105,16 @@ extern const PropertyInfo qdev_prop_link;
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
2.27.0

