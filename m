Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 378543BF303
	for <lists+kvm@lfdr.de>; Thu,  8 Jul 2021 02:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230349AbhGHA6n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jul 2021 20:58:43 -0400
Received: from mga18.intel.com ([134.134.136.126]:19318 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230180AbhGHA6g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jul 2021 20:58:36 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10038"; a="196696065"
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="196696065"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2021 17:55:55 -0700
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="423770021"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2021 17:55:54 -0700
From:   isaku.yamahata@gmail.com
To:     qemu-devel@nongnu.org, pbonzini@redhat.com, alistair@alistair23.me,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        cohuck@redhat.com, mtosatti@redhat.com, xiaoyao.li@intel.com,
        seanjc@google.com, erdemaktas@google.com
Cc:     kvm@vger.kernel.org, isaku.yamahata@gmail.com,
        isaku.yamahata@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH v2 10/44] hw/i386: Initialize TDX via KVM ioctl() when kvm_type is TDX
Date:   Wed,  7 Jul 2021 17:54:40 -0700
Message-Id: <d173ac1f4524153b738309530c6a6599aeaa18fd.1625704981.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1625704980.git.isaku.yamahata@intel.com>
References: <cover.1625704980.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Xiaoyao Li <xiaoyao.li@intel.com>

Introduce tdx_ioctl() to invoke TDX specific sub-ioctls of
KVM_MEMORY_ENCRYPT_OP.  Use tdx_ioctl() to invoke KVM_TDX_INIT, by way
of tdx_init(), during kvm_arch_init().  KVM_TDX_INIT configures global
TD state, e.g. the canonical CPUID config, and must be executed prior to
creating vCPUs.

Note, this doesn't address the fact that Qemu may change the CPUID
configuration when creating vCPUs, i.e. punts on refactoring Qemu to
provide a stable CPUID config prior to kvm_arch_init().

Explicitly set subleaf index and flags when adding CPUID
Set the index and flags when adding a CPUID entry to avoid propagating
stale state from a removed entry, e.g. when the CPUID 0x4 loop bails, it
can leave non-zero index and flags in the array.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 accel/kvm/kvm-all.c        |   2 +
 include/sysemu/tdx.h       |   2 +
 qapi/qom.json              |  14 +++++
 target/i386/kvm/tdx-stub.c |   4 ++
 target/i386/kvm/tdx.c      | 126 +++++++++++++++++++++++++++++++++++++
 target/i386/kvm/tdx.h      |  24 +++++++
 6 files changed, 172 insertions(+)
 create mode 100644 target/i386/kvm/tdx.h

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index fdbe24bf59..6475f15d5f 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -38,6 +38,7 @@
 #include "qemu/main-loop.h"
 #include "trace.h"
 #include "hw/irq.h"
+#include "sysemu/tdx.h"
 #include "qapi/visitor.h"
 #include "qapi/qapi-types-common.h"
 #include "qapi/qapi-visit-common.h"
@@ -459,6 +460,7 @@ int kvm_init_vcpu(CPUState *cpu, Error **errp)
 
     trace_kvm_init_vcpu(cpu->cpu_index, kvm_arch_vcpu_id(cpu));
 
+    tdx_pre_create_vcpu(cpu);
     ret = kvm_get_vcpu(s, kvm_arch_vcpu_id(cpu));
     if (ret < 0) {
         error_setg_errno(errp, -ret, "kvm_init_vcpu: kvm_get_vcpu failed (%lu)",
diff --git a/include/sysemu/tdx.h b/include/sysemu/tdx.h
index 60ebded851..36a901e723 100644
--- a/include/sysemu/tdx.h
+++ b/include/sysemu/tdx.h
@@ -7,4 +7,6 @@
 bool kvm_has_tdx(KVMState *s);
 #endif
 
+void tdx_pre_create_vcpu(CPUState *cpu);
+
 #endif
diff --git a/qapi/qom.json b/qapi/qom.json
index 652be317b8..70c70e3efe 100644
--- a/qapi/qom.json
+++ b/qapi/qom.json
@@ -760,6 +760,18 @@
             '*cbitpos': 'uint32',
             'reduced-phys-bits': 'uint32' } }
 
+##
+# @TdxGuestProperties:
+#
+# Properties for tdx-guest objects.
+#
+# @debug: enable debug mode (default: off)
+#
+# Since: 6.0
+##
+{ 'struct': 'TdxGuestProperties',
+  'data': { '*debug': 'bool' } }
+
 ##
 # @ObjectType:
 #
@@ -802,6 +814,7 @@
     'secret_keyring',
     'sev-guest',
     's390-pv-guest',
+    'tdx-guest',
     'throttle-group',
     'tls-creds-anon',
     'tls-creds-psk',
@@ -858,6 +871,7 @@
       'secret':                     'SecretProperties',
       'secret_keyring':             'SecretKeyringProperties',
       'sev-guest':                  'SevGuestProperties',
+      'tdx-guest':                  'TdxGuestProperties',
       'throttle-group':             'ThrottleGroupProperties',
       'tls-creds-anon':             'TlsCredsAnonProperties',
       'tls-creds-psk':              'TlsCredsPskProperties',
diff --git a/target/i386/kvm/tdx-stub.c b/target/i386/kvm/tdx-stub.c
index e1eb09cae1..93d5913c89 100644
--- a/target/i386/kvm/tdx-stub.c
+++ b/target/i386/kvm/tdx-stub.c
@@ -8,3 +8,7 @@ bool kvm_has_tdx(KVMState *s)
         return false;
 }
 #endif
+
+void tdx_pre_create_vcpu(CPUState *cpu)
+{
+}
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index e62a570f75..e8c70f241d 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -14,8 +14,10 @@
 #include "qemu/osdep.h"
 
 #include <linux/kvm.h>
+#include <sys/ioctl.h>
 
 #include "cpu.h"
+#include "kvm_i386.h"
 #include "hw/boards.h"
 #include "qapi/error.h"
 #include "qom/object_interfaces.h"
@@ -23,8 +25,132 @@
 #include "sysemu/kvm.h"
 #include "sysemu/kvm_int.h"
 #include "sysemu/tdx.h"
+#include "tdx.h"
+
+#define TDX1_TD_ATTRIBUTE_DEBUG BIT_ULL(0)
+#define TDX1_TD_ATTRIBUTE_PERFMON BIT_ULL(63)
 
 bool kvm_has_tdx(KVMState *s)
 {
     return !!(kvm_check_extension(s, KVM_CAP_VM_TYPES) & BIT(KVM_X86_TDX_VM));
 }
+
+static void __tdx_ioctl(int ioctl_no, const char *ioctl_name,
+                        __u32 metadata, void *data)
+{
+    struct kvm_tdx_cmd tdx_cmd;
+    int r;
+
+    memset(&tdx_cmd, 0x0, sizeof(tdx_cmd));
+
+    tdx_cmd.id = ioctl_no;
+    tdx_cmd.metadata = metadata;
+    tdx_cmd.data = (__u64)(unsigned long)data;
+
+    r = kvm_vm_ioctl(kvm_state, KVM_MEMORY_ENCRYPT_OP, &tdx_cmd);
+    if (r) {
+        error_report("%s failed: %s", ioctl_name, strerror(-r));
+        exit(1);
+    }
+}
+#define tdx_ioctl(ioctl_no, metadata, data) \
+        __tdx_ioctl(ioctl_no, stringify(ioctl_no), metadata, data)
+
+void tdx_pre_create_vcpu(CPUState *cpu)
+{
+    struct {
+        struct kvm_cpuid2 cpuid;
+        struct kvm_cpuid_entry2 entries[KVM_MAX_CPUID_ENTRIES];
+    } cpuid_data;
+
+    /*
+     * The kernel defines these structs with padding fields so there
+     * should be no extra padding in our cpuid_data struct.
+     */
+    QEMU_BUILD_BUG_ON(sizeof(cpuid_data) !=
+                      sizeof(struct kvm_cpuid2) +
+                      sizeof(struct kvm_cpuid_entry2) * KVM_MAX_CPUID_ENTRIES);
+
+    MachineState *ms = MACHINE(qdev_get_machine());
+    X86CPU *x86cpu = X86_CPU(cpu);
+    CPUX86State *env = &x86cpu->env;
+    TdxGuest *tdx = (TdxGuest *)object_dynamic_cast(OBJECT(ms->cgs),
+                                                    TYPE_TDX_GUEST);
+    struct kvm_tdx_init_vm init_vm;
+
+    if (!tdx) {
+        return;
+    }
+
+    /* HACK: Remove MPX support, which is not allowed by TDX. */
+    env->features[FEAT_XSAVE_COMP_LO] &= ~(XSTATE_BNDREGS_MASK |
+                                           XSTATE_BNDCSR_MASK);
+
+    if (!(env->features[FEAT_1_ECX] & CPUID_EXT_XSAVE)) {
+        error_report("TDX VM must support XSAVE features");
+        exit(1);
+    }
+
+    qemu_mutex_lock(&tdx->lock);
+    if (tdx->initialized) {
+        goto out;
+    }
+    tdx->initialized = true;
+
+    memset(&cpuid_data, 0, sizeof(cpuid_data));
+
+    cpuid_data.cpuid.nent = kvm_x86_arch_cpuid(env, cpuid_data.entries, 0);
+    cpuid_data.cpuid.padding = 0;
+
+    init_vm.max_vcpus = ms->smp.cpus;
+    init_vm.attributes = 0;
+    init_vm.attributes |= tdx->debug ? TDX1_TD_ATTRIBUTE_DEBUG : 0;
+    init_vm.attributes |= x86cpu->enable_pmu ? TDX1_TD_ATTRIBUTE_PERFMON : 0;
+
+    init_vm.cpuid = (__u64)(&cpuid_data);
+    tdx_ioctl(KVM_TDX_INIT_VM, 0, &init_vm);
+out:
+    qemu_mutex_unlock(&tdx->lock);
+}
+
+static bool tdx_guest_get_debug(Object *obj, Error **errp)
+{
+    TdxGuest *tdx = TDX_GUEST(obj);
+
+    return tdx->debug;
+}
+
+static void tdx_guest_set_debug(Object *obj, bool value, Error **errp)
+{
+    TdxGuest *tdx = TDX_GUEST(obj);
+
+    tdx->debug = value;
+}
+
+/* tdx guest */
+OBJECT_DEFINE_TYPE_WITH_INTERFACES(TdxGuest,
+                                   tdx_guest,
+                                   TDX_GUEST,
+                                   CONFIDENTIAL_GUEST_SUPPORT,
+                                   { TYPE_USER_CREATABLE },
+                                   { NULL })
+
+static void tdx_guest_init(Object *obj)
+{
+    TdxGuest *tdx = TDX_GUEST(obj);
+
+    tdx->parent_obj.ready = true;
+    qemu_mutex_init(&tdx->lock);
+
+    tdx->debug = false;
+    object_property_add_bool(obj, "debug", tdx_guest_get_debug,
+                             tdx_guest_set_debug);
+}
+
+static void tdx_guest_finalize(Object *obj)
+{
+}
+
+static void tdx_guest_class_init(ObjectClass *oc, void *data)
+{
+}
diff --git a/target/i386/kvm/tdx.h b/target/i386/kvm/tdx.h
new file mode 100644
index 0000000000..6ad6c9a313
--- /dev/null
+++ b/target/i386/kvm/tdx.h
@@ -0,0 +1,24 @@
+#ifndef QEMU_I386_TDX_H
+#define QEMU_I386_TDX_H
+
+#include "qom/object.h"
+#include "exec/confidential-guest-support.h"
+
+#define TYPE_TDX_GUEST "tdx-guest"
+#define TDX_GUEST(obj)     \
+    OBJECT_CHECK(TdxGuest, (obj), TYPE_TDX_GUEST)
+
+typedef struct TdxGuestClass {
+    ConfidentialGuestSupportClass parent_class;
+} TdxGuestClass;
+
+typedef struct TdxGuest {
+    ConfidentialGuestSupport parent_obj;
+
+    QemuMutex lock;
+
+    bool initialized;
+    bool debug;
+} TdxGuest;
+
+#endif
-- 
2.25.1

