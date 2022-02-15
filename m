Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 423694B8363
	for <lists+kvm@lfdr.de>; Wed, 16 Feb 2022 09:55:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231785AbiBPIyS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Feb 2022 03:54:18 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:48556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231767AbiBPIyR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Feb 2022 03:54:17 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EFE2189A8D
        for <kvm@vger.kernel.org>; Wed, 16 Feb 2022 00:54:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645001646; x=1676537646;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Aqdv8MZYaBIeZdcgvu5e2Fh6FIGmCmAW19zWgTGh2xk=;
  b=kymW3RARvFwgYtzm2GvOe0qt56t4j1em4+M2hx7Rf7ba9PZ7av3QVokS
   kiBcCk3RFDUod3k1w0lvIWUenMrsK7DxrvY1tCT/mSYlxrSXDTOVjnAo4
   T32b/7U99uiNAMeUHzgLhxABYXwXAMqTc2woStFNnZb9rvuaj4doVobMZ
   Xv/eMyRnGwm0STJ5CEAwQWQ7Mahmqjr6zAKrLyy6NH+vQCnler26ES5Tw
   zufgyrs6mCVGNP1A738r4mNVJcwABBZzXExoslTfiIRRprQlo4PWKKGhP
   UB1ZCf0rUNA0EJSwzW7yVKyM52Gjc+LGhOS4ZB7db5f4A62vRMiWIKZcY
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10259"; a="275135776"
X-IronPort-AV: E=Sophos;i="5.88,373,1635231600"; 
   d="scan'208";a="275135776"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2022 00:54:05 -0800
X-IronPort-AV: E=Sophos;i="5.88,373,1635231600"; 
   d="scan'208";a="633418264"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2022 00:54:05 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, ehabkost@redhat.com, mtosatti@redhat.com,
        seanjc@google.com, richard.henderson@linaro.org,
        like.xu.linux@gmail.com, wei.w.wang@intel.com,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>,
        Like Xu <like.xu@linux.intel.com>
Subject: [PATCH 1/8] qdev-properties: Add a new macro with bitmask check for uint64_t property
Date:   Tue, 15 Feb 2022 14:52:51 -0500
Message-Id: <20220215195258.29149-2-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220215195258.29149-1-weijiang.yang@intel.com>
References: <20220215195258.29149-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DATE_IN_PAST_12_24,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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

