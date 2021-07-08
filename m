Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95D113BF30A
	for <lists+kvm@lfdr.de>; Thu,  8 Jul 2021 02:56:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230433AbhGHA6t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jul 2021 20:58:49 -0400
Received: from mga18.intel.com ([134.134.136.126]:19318 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230191AbhGHA6g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jul 2021 20:58:36 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10038"; a="196696073"
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="196696073"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2021 17:55:55 -0700
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="423770031"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2021 17:55:55 -0700
From:   isaku.yamahata@gmail.com
To:     qemu-devel@nongnu.org, pbonzini@redhat.com, alistair@alistair23.me,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        cohuck@redhat.com, mtosatti@redhat.com, xiaoyao.li@intel.com,
        seanjc@google.com, erdemaktas@google.com
Cc:     kvm@vger.kernel.org, isaku.yamahata@gmail.com,
        isaku.yamahata@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH v2 13/44] i386/tdx: Frame in tdx_get_supported_cpuid with KVM_TDX_CAPABILITIES
Date:   Wed,  7 Jul 2021 17:54:43 -0700
Message-Id: <64a6aff39a1f5d96fcddff8923bfba5728fcfa8c.1625704981.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1625704980.git.isaku.yamahata@intel.com>
References: <cover.1625704980.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Add support for grabbing KVM_TDX_CAPABILITIES and use the new
kvm_get_supported_cpuid() hook to adjust the supported XCR0 bits.

Add TODOs for the remaining work.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 target/i386/kvm/kvm.c |  2 ++
 target/i386/kvm/tdx.c | 79 ++++++++++++++++++++++++++++++++++++++++---
 target/i386/kvm/tdx.h |  2 ++
 3 files changed, 78 insertions(+), 5 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 5742fa4806..25dcecd60c 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -448,6 +448,8 @@ uint32_t kvm_arch_get_supported_cpuid(KVMState *s, uint32_t function,
         ret |= 1U << KVM_HINTS_REALTIME;
     }
 
+    tdx_get_supported_cpuid(s, function, index, reg, &ret);
+
     return ret;
 }
 
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index f8c7560fc8..b1e4f27c9a 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -21,6 +21,7 @@
 #include "hw/boards.h"
 #include "qapi/error.h"
 #include "qom/object_interfaces.h"
+#include "standard-headers/asm-x86/kvm_para.h"
 #include "sysemu/sysemu.h"
 #include "sysemu/kvm.h"
 #include "sysemu/kvm_int.h"
@@ -49,7 +50,11 @@ static void __tdx_ioctl(int ioctl_no, const char *ioctl_name,
     tdx_cmd.metadata = metadata;
     tdx_cmd.data = (__u64)(unsigned long)data;
 
-    r = kvm_vm_ioctl(kvm_state, KVM_MEMORY_ENCRYPT_OP, &tdx_cmd);
+    if (ioctl_no == KVM_TDX_CAPABILITIES) {
+        r = kvm_ioctl(kvm_state, KVM_MEMORY_ENCRYPT_OP, &tdx_cmd);
+    } else {
+        r = kvm_vm_ioctl(kvm_state, KVM_MEMORY_ENCRYPT_OP, &tdx_cmd);
+    }
     if (r) {
         error_report("%s failed: %s", ioctl_name, strerror(-r));
         exit(1);
@@ -67,6 +72,18 @@ static Notifier tdx_machine_done_late_notify = {
     .notify = tdx_finalize_vm,
 };
 
+#define TDX1_MAX_NR_CPUID_CONFIGS 6
+
+static struct {
+    struct kvm_tdx_capabilities __caps;
+    struct kvm_tdx_cpuid_config __cpuid_configs[TDX1_MAX_NR_CPUID_CONFIGS];
+} __tdx_caps;
+
+static struct kvm_tdx_capabilities *tdx_caps = (void *)&__tdx_caps;
+
+#define XCR0_MASK (MAKE_64BIT_MASK(0, 8) | BIT_ULL(9))
+#define XSS_MASK (~XCR0_MASK)
+
 int tdx_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
 {
     TdxGuest *tdx = (TdxGuest *)object_dynamic_cast(OBJECT(cgs),
@@ -75,10 +92,65 @@ int tdx_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
         return 0;
     }
 
+    QEMU_BUILD_BUG_ON(sizeof(__tdx_caps) !=
+                      sizeof(struct kvm_tdx_capabilities) +
+                      sizeof(struct kvm_tdx_cpuid_config) *
+                      TDX1_MAX_NR_CPUID_CONFIGS);
+
+    tdx_caps->nr_cpuid_configs = TDX1_MAX_NR_CPUID_CONFIGS;
+    tdx_ioctl(KVM_TDX_CAPABILITIES, 0, tdx_caps);
+
     qemu_add_machine_init_done_late_notifier(&tdx_machine_done_late_notify);
+
     return 0;
 }
 
+void tdx_get_supported_cpuid(KVMState *s, uint32_t function,
+                             uint32_t index, int reg, uint32_t *ret)
+{
+    MachineState *ms = MACHINE(qdev_get_machine());
+    TdxGuest *tdx = (TdxGuest *)object_dynamic_cast(OBJECT(ms->cgs),
+                                                    TYPE_TDX_GUEST);
+
+    if (!tdx) {
+        return;
+    }
+
+    switch (function) {
+    case 1:
+        if (reg == R_ECX) {
+            *ret &= ~CPUID_EXT_VMX;
+        }
+        break;
+    case 0xd:
+        if (index == 0) {
+            if (reg == R_EAX) {
+                *ret &= (uint32_t)tdx_caps->xfam_fixed0 & XCR0_MASK;
+                *ret |= (uint32_t)tdx_caps->xfam_fixed1 & XCR0_MASK;
+            } else if (reg == R_EDX) {
+                *ret &= (tdx_caps->xfam_fixed0 & XCR0_MASK) >> 32;
+                *ret |= (tdx_caps->xfam_fixed1 & XCR0_MASK) >> 32;
+            }
+        } else if (index == 1) {
+            /* TODO: Adjust XSS when it's supported. */
+        }
+        break;
+    case KVM_CPUID_FEATURES:
+        if (reg == R_EAX) {
+            *ret &= ~((1ULL << KVM_FEATURE_CLOCKSOURCE) |
+                      (1ULL << KVM_FEATURE_CLOCKSOURCE2) |
+                      (1ULL << KVM_FEATURE_CLOCKSOURCE_STABLE_BIT) |
+                      (1ULL << KVM_FEATURE_ASYNC_PF) |
+                      (1ULL << KVM_FEATURE_ASYNC_PF_VMEXIT) |
+                      (1ULL << KVM_FEATURE_ASYNC_PF_INT));
+        }
+        break;
+    default:
+        /* TODO: Use tdx_caps to adjust CPUID leafs. */
+        break;
+    }
+}
+
 void tdx_pre_create_vcpu(CPUState *cpu)
 {
     struct {
@@ -105,10 +177,7 @@ void tdx_pre_create_vcpu(CPUState *cpu)
         return;
     }
 
-    /* HACK: Remove MPX support, which is not allowed by TDX. */
-    env->features[FEAT_XSAVE_COMP_LO] &= ~(XSTATE_BNDREGS_MASK |
-                                           XSTATE_BNDCSR_MASK);
-
+    /* TODO: Use tdx_caps to validate the config. */
     if (!(env->features[FEAT_1_ECX] & CPUID_EXT_XSAVE)) {
         error_report("TDX VM must support XSAVE features");
         exit(1);
diff --git a/target/i386/kvm/tdx.h b/target/i386/kvm/tdx.h
index e15657d272..844d24aade 100644
--- a/target/i386/kvm/tdx.h
+++ b/target/i386/kvm/tdx.h
@@ -23,5 +23,7 @@ typedef struct TdxGuest {
 } TdxGuest;
 
 int tdx_kvm_init(ConfidentialGuestSupport *cgs, Error **errp);
+void tdx_get_supported_cpuid(KVMState *s, uint32_t function,
+                             uint32_t index, int reg, uint32_t *ret);
 
 #endif
-- 
2.25.1

