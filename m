Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5C313BF31A
	for <lists+kvm@lfdr.de>; Thu,  8 Jul 2021 02:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230493AbhGHA7E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jul 2021 20:59:04 -0400
Received: from mga03.intel.com ([134.134.136.65]:19087 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230247AbhGHA6k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jul 2021 20:58:40 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10038"; a="209462011"
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="209462011"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2021 17:55:58 -0700
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="423770089"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2021 17:55:57 -0700
From:   isaku.yamahata@gmail.com
To:     qemu-devel@nongnu.org, pbonzini@redhat.com, alistair@alistair23.me,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        cohuck@redhat.com, mtosatti@redhat.com, xiaoyao.li@intel.com,
        seanjc@google.com, erdemaktas@google.com
Cc:     kvm@vger.kernel.org, isaku.yamahata@gmail.com,
        isaku.yamahata@intel.com
Subject: [RFC PATCH v2 31/44] target/i386/tdx: Allows mrconfigid/mrowner/mrownerconfig for TDX_INIT_VM
Date:   Wed,  7 Jul 2021 17:55:01 -0700
Message-Id: <9f1e7fd7678900791d2094d2f0def53fe0afc658.1625704981.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1625704980.git.isaku.yamahata@intel.com>
References: <cover.1625704980.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

When creating VM with TDX_INIT_VM, three sha384 hash values are accepted
for TDX attestation.
So far they were hard coded as 0. Now allow user to specify those values
via property mrconfigid, mrowner and mrownerconfig.
string for those property are hex string of 48 * 2 length.

example
-device tdx-guest, \
  mrconfigid=0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef, \
  mrowner=fedcba9876543210fedcba9876543210fedcba9876543210fedcba9876543210fedcba9876543210fedcba9876543210, \
  mrownerconfig=0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 qapi/qom.json         | 11 ++++++++++-
 target/i386/kvm/tdx.c | 17 +++++++++++++++++
 target/i386/kvm/tdx.h |  3 +++
 3 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/qapi/qom.json b/qapi/qom.json
index 70c70e3efe..8f8b7828b3 100644
--- a/qapi/qom.json
+++ b/qapi/qom.json
@@ -767,10 +767,19 @@
 #
 # @debug: enable debug mode (default: off)
 #
+# @mrconfigid: MRCONFIGID SHA384 hex string of 48 * 2 length (default: 0)
+#
+# @mrowner: MROWNER SHA384 hex string of 48 * 2 length (default: 0)
+#
+# @mrownerconfig: MROWNERCONFIG SHA384 hex string of 48 * 2 length (default: 0)
+#
 # Since: 6.0
 ##
 { 'struct': 'TdxGuestProperties',
-  'data': { '*debug': 'bool' } }
+  'data': { '*debug': 'bool',
+            '*mrconfigid': 'str',
+            '*mrowner': 'str',
+            '*mrownerconfig': 'str' } }
 
 ##
 # @ObjectType:
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 47a502051c..6b560c1c0b 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -282,6 +282,17 @@ void tdx_pre_create_vcpu(CPUState *cpu)
     init_vm.attributes |= tdx->debug ? TDX1_TD_ATTRIBUTE_DEBUG : 0;
     init_vm.attributes |= x86cpu->enable_pmu ? TDX1_TD_ATTRIBUTE_PERFMON : 0;
 
+    QEMU_BUILD_BUG_ON(sizeof(init_vm.mrconfigid) != sizeof(tdx->mrconfigid));
+    memcpy(init_vm.mrconfigid, tdx->mrconfigid, sizeof(init_vm.mrconfigid));
+    QEMU_BUILD_BUG_ON(sizeof(init_vm.mrowner) != sizeof(tdx->mrowner));
+    memcpy(init_vm.mrowner, tdx->mrowner, sizeof(init_vm.mrowner));
+    QEMU_BUILD_BUG_ON(sizeof(init_vm.mrownerconfig) !=
+                      sizeof(tdx->mrownerconfig));
+    memcpy(init_vm.mrownerconfig, tdx->mrownerconfig,
+           sizeof(init_vm.mrownerconfig));
+
+    memset(init_vm.reserved, 0, sizeof(init_vm.reserved));
+
     init_vm.cpuid = (__u64)(&cpuid_data);
     tdx_ioctl(KVM_TDX_INIT_VM, 0, &init_vm);
 out:
@@ -336,6 +347,12 @@ static void tdx_guest_init(Object *obj)
     tdx->debug = false;
     object_property_add_bool(obj, "debug", tdx_guest_get_debug,
                              tdx_guest_set_debug);
+    object_property_add_sha384(obj, "mrconfigid", tdx->mrconfigid,
+                               OBJ_PROP_FLAG_READWRITE);
+    object_property_add_sha384(obj, "mrowner", tdx->mrowner,
+                               OBJ_PROP_FLAG_READWRITE);
+    object_property_add_sha384(obj, "mrownerconfig", tdx->mrownerconfig,
+                               OBJ_PROP_FLAG_READWRITE);
 }
 
 static void tdx_guest_finalize(Object *obj)
diff --git a/target/i386/kvm/tdx.h b/target/i386/kvm/tdx.h
index 2fed27b3fb..4132d1be30 100644
--- a/target/i386/kvm/tdx.h
+++ b/target/i386/kvm/tdx.h
@@ -44,6 +44,9 @@ typedef struct TdxGuest {
 
     bool initialized;
     bool debug;
+    uint8_t mrconfigid[48];     /* sha348 digest */
+    uint8_t mrowner[48];        /* sha348 digest */
+    uint8_t mrownerconfig[48];  /* sha348 digest */
 
     TdxFirmware fw;
 } TdxGuest;
-- 
2.25.1

