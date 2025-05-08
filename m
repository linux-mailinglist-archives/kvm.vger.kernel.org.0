Return-Path: <kvm+bounces-45916-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 93718AAFE68
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 17:09:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7CFD59C30FF
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:08:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 473DA27F72B;
	Thu,  8 May 2025 15:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HRmXMe0S"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC1411D7E41
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 15:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746716736; cv=none; b=l4EgjCc71hEsHsR2ne1wsFCtV2W7DiOCp5PyTvr3ahLn7vHutpZ8H+HMyWcYFspXr8OJIvkN2zVA8L/oUC6cIevdR8kxl2WWegO04bU6NJNOi1p1zzELorlgGRItMDj7Cao/LQpiRYeMB34lZar5ze+t0cPtWIvIPnueWh8WZ60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746716736; c=relaxed/simple;
	bh=1RB3Yi0DcwKMNUkAGxpXWLpQgmAnDT7EpwecO866NlU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZmjV2fWtHAFDdlJaiJbmbx5bh4jSrQPLfSk1EARVywfoQEE1Q5n80Yxu1EI4SioG4iu2sXZyq9qU6toGt8CgdRepe6BQyRuGe2ugYHOexVMy1ubsPcYqypce2chXdVqTNOWESill7ugzKEAHE6jHGkZ/5UO6UNTL8azNMkbNFvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HRmXMe0S; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746716735; x=1778252735;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1RB3Yi0DcwKMNUkAGxpXWLpQgmAnDT7EpwecO866NlU=;
  b=HRmXMe0S8exBM9o5jaILWnv7xozgnCjIKDkRItKHhILbAnKAb/gS7qCQ
   ZXenYWnFaVVpB/WX8W9rgZIWMdhMuUDgzr0jnfQn2QuR2Nd6KQtdMi577
   GspHjJ1Ln+FbRdAlSKzpcW9Elk8N9+kDnx78o3r2d/D7h7WsRDUBxeoVS
   631ljy0whrWQyl8k96wXZzaFG0ppdRAr9WYT2ghTypbQ/1Mmvbl8uaCep
   4Dy6xlvuJazGoowVkmrAtL2OM5csdnsvcUvbgW9jWT+tNd0ZxnzckIo9v
   bDYoux5fqagqKMbpr5hp9gONqEGBpS0YuNqzJ6rzZzD433SICzDwWSFJh
   Q==;
X-CSE-ConnectionGUID: vZAfY7UCQ7KarYLvtkCCfA==
X-CSE-MsgGUID: npzj2B0PSdq5cO7qGjnq5g==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="73888094"
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="73888094"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 08:05:34 -0700
X-CSE-ConnectionGUID: ezYztjJuQFS+N7V1jI043g==
X-CSE-MsgGUID: DvUMM9FKT9astI8JdMtWZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="141439886"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 08 May 2025 08:05:31 -0700
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Francesco Lavra <francescolavra.fl@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v9 13/55] i386/tdx: Support user configurable mrconfigid/mrowner/mrownerconfig
Date: Thu,  8 May 2025 10:59:19 -0400
Message-ID: <20250508150002.689633-14-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250508150002.689633-1-xiaoyao.li@intel.com>
References: <20250508150002.689633-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Three sha384 hash values, mrconfigid, mrowner and mrownerconfig, of a TD
can be provided for TDX attestation. Detailed meaning of them can be
found: https://lore.kernel.org/qemu-devel/31d6dbc1-f453-4cef-ab08-4813f4e0ff92@intel.com/

Allow user to specify those values via property mrconfigid, mrowner and
mrownerconfig. They are all in base64 format.

example
-object tdx-guest, \
  mrconfigid=ASNFZ4mrze8BI0VniavN7wEjRWeJq83vASNFZ4mrze8BI0VniavN7wEjRWeJq83v,\
  mrowner=ASNFZ4mrze8BI0VniavN7wEjRWeJq83vASNFZ4mrze8BI0VniavN7wEjRWeJq83v,\
  mrownerconfig=ASNFZ4mrze8BI0VniavN7wEjRWeJq83vASNFZ4mrze8BI0VniavN7wEjRWeJq83v

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Markus Armbruster <armbru@redhat.com>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes in v9:
 - return -1 directly when qbase64_decode() return NULL; (Daniel)

Changes in v8:
 - it gets squashed into previous patch in v7. So split it out in v8;

Changes in v6:
 - refine the doc comment of QAPI properties;

Changes in v5:
 - refine the description of QAPI properties and add description of
   default value when not specified;

Changes in v4:
 - describe more of there fields in qom.json
 - free the old value before set new value to avoid memory leak in
   _setter(); (Daniel)

Changes in v3:
 - use base64 encoding instread of hex-string;
---
 qapi/qom.json         | 16 +++++++-
 target/i386/kvm/tdx.c | 95 +++++++++++++++++++++++++++++++++++++++++++
 target/i386/kvm/tdx.h |  3 ++
 3 files changed, 113 insertions(+), 1 deletion(-)

diff --git a/qapi/qom.json b/qapi/qom.json
index f229bb07aaec..a8379bac1719 100644
--- a/qapi/qom.json
+++ b/qapi/qom.json
@@ -1060,11 +1060,25 @@
 #     pages.  Some guest OS (e.g., Linux TD guest) may require this to
 #     be set, otherwise they refuse to boot.
 #
+# @mrconfigid: ID for non-owner-defined configuration of the guest TD,
+#     e.g., run-time or OS configuration (base64 encoded SHA384 digest).
+#     Defaults to all zeros.
+#
+# @mrowner: ID for the guest TD’s owner (base64 encoded SHA384 digest).
+#     Defaults to all zeros.
+#
+# @mrownerconfig: ID for owner-defined configuration of the guest TD,
+#     e.g., specific to the workload rather than the run-time or OS
+#     (base64 encoded SHA384 digest).  Defaults to all zeros.
+#
 # Since: 10.1
 ##
 { 'struct': 'TdxGuestProperties',
   'data': { '*attributes': 'uint64',
-            '*sept-ve-disable': 'bool' } }
+            '*sept-ve-disable': 'bool',
+            '*mrconfigid': 'str',
+            '*mrowner': 'str',
+            '*mrownerconfig': 'str' } }
 
 ##
 # @ThreadContextProperties:
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 3de3b5fa6a49..39fd964c6b27 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -11,8 +11,10 @@
 
 #include "qemu/osdep.h"
 #include "qemu/error-report.h"
+#include "qemu/base64.h"
 #include "qapi/error.h"
 #include "qom/object_interfaces.h"
+#include "crypto/hash.h"
 
 #include "hw/i386/x86.h"
 #include "kvm_i386.h"
@@ -240,6 +242,7 @@ int tdx_pre_create_vcpu(CPUState *cpu, Error **errp)
     CPUX86State *env = &x86cpu->env;
     g_autofree struct kvm_tdx_init_vm *init_vm = NULL;
     Error *local_err = NULL;
+    size_t data_len;
     int retry = 10000;
     int r = 0;
 
@@ -251,6 +254,45 @@ int tdx_pre_create_vcpu(CPUState *cpu, Error **errp)
     init_vm = g_malloc0(sizeof(struct kvm_tdx_init_vm) +
                         sizeof(struct kvm_cpuid_entry2) * KVM_MAX_CPUID_ENTRIES);
 
+    if (tdx_guest->mrconfigid) {
+        g_autofree uint8_t *data = qbase64_decode(tdx_guest->mrconfigid,
+                              strlen(tdx_guest->mrconfigid), &data_len, errp);
+        if (!data) {
+            return -1;
+        }
+        if (data_len != QCRYPTO_HASH_DIGEST_LEN_SHA384) {
+            error_setg(errp, "TDX: failed to decode mrconfigid");
+            return -1;
+        }
+        memcpy(init_vm->mrconfigid, data, data_len);
+    }
+
+    if (tdx_guest->mrowner) {
+        g_autofree uint8_t *data = qbase64_decode(tdx_guest->mrowner,
+                              strlen(tdx_guest->mrowner), &data_len, errp);
+        if (!data) {
+            return -1;
+        }
+        if (data_len != QCRYPTO_HASH_DIGEST_LEN_SHA384) {
+            error_setg(errp, "TDX: failed to decode mrowner");
+            return -1;
+        }
+        memcpy(init_vm->mrowner, data, data_len);
+    }
+
+    if (tdx_guest->mrownerconfig) {
+        g_autofree uint8_t *data = qbase64_decode(tdx_guest->mrownerconfig,
+                            strlen(tdx_guest->mrownerconfig), &data_len, errp);
+        if (!data) {
+            return -1;
+        }
+        if (data_len != QCRYPTO_HASH_DIGEST_LEN_SHA384) {
+            error_setg(errp, "TDX: failed to decode mrownerconfig");
+            return -1;
+        }
+        memcpy(init_vm->mrownerconfig, data, data_len);
+    }
+
     r = setup_td_guest_attributes(x86cpu, errp);
     if (r) {
         return r;
@@ -314,6 +356,51 @@ static void tdx_guest_set_sept_ve_disable(Object *obj, bool value, Error **errp)
     }
 }
 
+static char *tdx_guest_get_mrconfigid(Object *obj, Error **errp)
+{
+    TdxGuest *tdx = TDX_GUEST(obj);
+
+    return g_strdup(tdx->mrconfigid);
+}
+
+static void tdx_guest_set_mrconfigid(Object *obj, const char *value, Error **errp)
+{
+    TdxGuest *tdx = TDX_GUEST(obj);
+
+    g_free(tdx->mrconfigid);
+    tdx->mrconfigid = g_strdup(value);
+}
+
+static char *tdx_guest_get_mrowner(Object *obj, Error **errp)
+{
+    TdxGuest *tdx = TDX_GUEST(obj);
+
+    return g_strdup(tdx->mrowner);
+}
+
+static void tdx_guest_set_mrowner(Object *obj, const char *value, Error **errp)
+{
+    TdxGuest *tdx = TDX_GUEST(obj);
+
+    g_free(tdx->mrowner);
+    tdx->mrowner = g_strdup(value);
+}
+
+static char *tdx_guest_get_mrownerconfig(Object *obj, Error **errp)
+{
+    TdxGuest *tdx = TDX_GUEST(obj);
+
+    return g_strdup(tdx->mrownerconfig);
+}
+
+static void tdx_guest_set_mrownerconfig(Object *obj, const char *value, Error **errp)
+{
+    TdxGuest *tdx = TDX_GUEST(obj);
+
+    g_free(tdx->mrownerconfig);
+    tdx->mrownerconfig = g_strdup(value);
+}
+
 /* tdx guest */
 OBJECT_DEFINE_TYPE_WITH_INTERFACES(TdxGuest,
                                    tdx_guest,
@@ -337,6 +424,14 @@ static void tdx_guest_init(Object *obj)
     object_property_add_bool(obj, "sept-ve-disable",
                              tdx_guest_get_sept_ve_disable,
                              tdx_guest_set_sept_ve_disable);
+    object_property_add_str(obj, "mrconfigid",
+                            tdx_guest_get_mrconfigid,
+                            tdx_guest_set_mrconfigid);
+    object_property_add_str(obj, "mrowner",
+                            tdx_guest_get_mrowner, tdx_guest_set_mrowner);
+    object_property_add_str(obj, "mrownerconfig",
+                            tdx_guest_get_mrownerconfig,
+                            tdx_guest_set_mrownerconfig);
 }
 
 static void tdx_guest_finalize(Object *obj)
diff --git a/target/i386/kvm/tdx.h b/target/i386/kvm/tdx.h
index 4e2b5c61ff5b..e472b11fb0dd 100644
--- a/target/i386/kvm/tdx.h
+++ b/target/i386/kvm/tdx.h
@@ -24,6 +24,9 @@ typedef struct TdxGuest {
     bool initialized;
     uint64_t attributes;    /* TD attributes */
     uint64_t xfam;
+    char *mrconfigid;       /* base64 encoded sha348 digest */
+    char *mrowner;          /* base64 encoded sha348 digest */
+    char *mrownerconfig;    /* base64 encoded sha348 digest */
 } TdxGuest;
 
 #ifdef CONFIG_TDX
-- 
2.43.0


