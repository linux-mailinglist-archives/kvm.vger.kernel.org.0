Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 561AA3BF319
	for <lists+kvm@lfdr.de>; Thu,  8 Jul 2021 02:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230488AbhGHA7D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jul 2021 20:59:03 -0400
Received: from mga03.intel.com ([134.134.136.65]:19088 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230256AbhGHA6k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jul 2021 20:58:40 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10038"; a="209462013"
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="209462013"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2021 17:55:58 -0700
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="423770096"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2021 17:55:58 -0700
From:   isaku.yamahata@gmail.com
To:     qemu-devel@nongnu.org, pbonzini@redhat.com, alistair@alistair23.me,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        cohuck@redhat.com, mtosatti@redhat.com, xiaoyao.li@intel.com,
        seanjc@google.com, erdemaktas@google.com
Cc:     kvm@vger.kernel.org, isaku.yamahata@gmail.com,
        isaku.yamahata@intel.com, Chenyi Qiang <chenyi.qiang@intel.com>
Subject: [RFC PATCH v2 33/44] qmp: add query-tdx-capabilities query-tdx command
Date:   Wed,  7 Jul 2021 17:55:03 -0700
Message-Id: <f9391aea17154c05a8d51da8a15b8aec4e2d5873.1625704981.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1625704980.git.isaku.yamahata@intel.com>
References: <cover.1625704980.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Chenyi Qiang <chenyi.qiang@intel.com>

Add QMP commands that can be used by libvirt to query the TDX capabilities
and TDX info.  The set of capabilities that needs to be reported is only
enabled at the moment, which means TDX is enabled.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
Co-developed-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 include/sysemu/tdx.h       |  6 ++++
 qapi/misc-target.json      | 59 ++++++++++++++++++++++++++++++++++++++
 target/i386/kvm/tdx-stub.c | 10 +++++++
 target/i386/kvm/tdx.c      | 19 ++++++++++++
 target/i386/monitor.c      | 23 +++++++++++++++
 5 files changed, 117 insertions(+)

diff --git a/include/sysemu/tdx.h b/include/sysemu/tdx.h
index f3eced10f9..756f46d2de 100644
--- a/include/sysemu/tdx.h
+++ b/include/sysemu/tdx.h
@@ -13,4 +13,10 @@ int tdx_system_firmware_init(PCMachineState *pcms, MemoryRegion *rom_memory);
 void tdx_pre_create_vcpu(CPUState *cpu);
 void tdx_post_init_vcpu(CPUState *cpu);
 
+struct TDXInfo;
+struct TDXInfo *tdx_get_info(void);
+
+struct TDXCapability;
+struct TDXCapability *tdx_get_capabilities(void);
+
 #endif
diff --git a/qapi/misc-target.json b/qapi/misc-target.json
index 5573dcf8f0..c1de95c082 100644
--- a/qapi/misc-target.json
+++ b/qapi/misc-target.json
@@ -323,3 +323,62 @@
 { 'command': 'query-sev-attestation-report', 'data': { 'mnonce': 'str' },
   'returns': 'SevAttestationReport',
   'if': 'defined(TARGET_I386)' }
+
+##
+# @TDXInfo:
+#
+# Information about Trust Domain Extensions (TDX) support
+#
+# @enabled: true if TDX is active
+#
+##
+{ 'struct': 'TDXInfo',
+    'data': { 'enabled': 'bool' },
+  'if': 'defined(TARGET_I386)'
+}
+
+##
+# @query-tdx:
+#
+# Returns information about TDX
+#
+# Returns: @TdxInfo
+#
+#
+# Example:
+#
+# -> { "execute": "query-tdx" }
+# <- { "return": { "enabled": true } }
+#
+##
+{ 'command': 'query-tdx', 'returns': 'TDXInfo',
+  'if': 'defined(TARGET_I386)' }
+
+##
+# @TDXCapability:
+#
+# The struct describes capability for a TDX
+# feature.
+#
+##
+{ 'struct': 'TDXCapability',
+  'data': { 'enabled': 'bool' },
+  'if': 'defined(TARGET_I386)' }
+
+##
+# @query-tdx-capabilities:
+#
+# This command is used to get the TDX capabilities, and is supported on Intel
+# X86 platforms only.
+#
+# Returns: @TDXCapability.
+#
+#
+# Example:
+#
+# -> { "execute": "query-tdx-capabilities" }
+# <- { "return": { 'enabled': 'bool' }}
+#
+##
+{ 'command': 'query-tdx-capabilities', 'returns': 'TDXCapability',
+  'if': 'defined(TARGET_I386)' }
diff --git a/target/i386/kvm/tdx-stub.c b/target/i386/kvm/tdx-stub.c
index 4e1a0a4280..5d8faf0716 100644
--- a/target/i386/kvm/tdx-stub.c
+++ b/target/i386/kvm/tdx-stub.c
@@ -21,3 +21,13 @@ void tdx_pre_create_vcpu(CPUState *cpu)
 void tdx_post_init_vcpu(CPUState *cpu)
 {
 }
+
+struct TDXInfo *tdx_get_info(void)
+{
+    return NULL;
+}
+
+struct TDXCapability *tdx_get_capabilities(void)
+{
+    return NULL;
+}
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 6b560c1c0b..1316d95209 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -22,6 +22,7 @@
 #include "hw/i386/tdvf-hob.h"
 #include "qapi/error.h"
 #include "qom/object_interfaces.h"
+#include "qapi/qapi-types-misc-target.h"
 #include "standard-headers/asm-x86/kvm_para.h"
 #include "sysemu/sysemu.h"
 #include "sysemu/kvm.h"
@@ -39,6 +40,24 @@ bool kvm_has_tdx(KVMState *s)
     return !!(kvm_check_extension(s, KVM_CAP_VM_TYPES) & BIT(KVM_X86_TDX_VM));
 }
 
+TDXInfo *tdx_get_info(void)
+{
+    TDXInfo *info;
+
+    info = g_new0(TDXInfo, 1);
+    info->enabled = kvm_enabled() && kvm_tdx_enabled();
+    return info;
+}
+
+TDXCapability *tdx_get_capabilities(void)
+{
+    TDXCapability *cap;
+
+    cap = g_new0(TDXCapability, 1);
+    cap->enabled = kvm_enabled() && kvm_has_tdx(kvm_state);
+    return cap;
+}
+
 static void __tdx_ioctl(void *state, int ioctl_no, const char *ioctl_name,
                         __u32 metadata, void *data)
 {
diff --git a/target/i386/monitor.c b/target/i386/monitor.c
index 119211f0b0..c0be99d13d 100644
--- a/target/i386/monitor.c
+++ b/target/i386/monitor.c
@@ -30,6 +30,7 @@
 #include "qapi/qmp/qdict.h"
 #include "sysemu/kvm.h"
 #include "sysemu/sev.h"
+#include "sysemu/tdx.h"
 #include "qapi/error.h"
 #include "sev_i386.h"
 #include "qapi/qapi-commands-misc-target.h"
@@ -763,3 +764,25 @@ qmp_query_sev_attestation_report(const char *mnonce, Error **errp)
 {
     return sev_get_attestation_report(mnonce, errp);
 }
+
+TDXInfo *qmp_query_tdx(Error **errp)
+{
+    TDXInfo *info;
+
+    info = tdx_get_info();
+    if (!info) {
+        error_setg(errp, "TDX is not available.");
+    }
+    return info;
+}
+
+TDXCapability *qmp_query_tdx_capabilities(Error **errp)
+{
+    TDXCapability *cap;
+
+    cap = tdx_get_capabilities();
+    if (!cap) {
+        error_setg(errp, "TDX is not available.");
+    }
+    return cap;
+}
-- 
2.25.1

