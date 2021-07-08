Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C41A3BF2FC
	for <lists+kvm@lfdr.de>; Thu,  8 Jul 2021 02:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbhGHA6k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jul 2021 20:58:40 -0400
Received: from mga09.intel.com ([134.134.136.24]:27079 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230150AbhGHA6f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jul 2021 20:58:35 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10038"; a="209381419"
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="209381419"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2021 17:55:53 -0700
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="423769989"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2021 17:55:52 -0700
From:   isaku.yamahata@gmail.com
To:     qemu-devel@nongnu.org, pbonzini@redhat.com, alistair@alistair23.me,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        cohuck@redhat.com, mtosatti@redhat.com, xiaoyao.li@intel.com,
        seanjc@google.com, erdemaktas@google.com
Cc:     kvm@vger.kernel.org, isaku.yamahata@gmail.com,
        isaku.yamahata@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH v2 03/44] i386/kvm: Move architectural CPUID leaf generation to separarte helper
Date:   Wed,  7 Jul 2021 17:54:33 -0700
Message-Id: <d5ee34f3ef17c4dd2cfbcf4edb8c622859e227eb.1625704980.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1625704980.git.isaku.yamahata@intel.com>
References: <cover.1625704980.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Move the architectural (for lack of a better term) CPUID leaf generation
to a separate helper so that the generation code can be reused by TDX,
which needs to generate a canonical VM-scoped configuration.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 target/i386/kvm/kvm.c      | 186 +++++++++++++++++++------------------
 target/i386/kvm/kvm_i386.h |   4 +
 2 files changed, 102 insertions(+), 88 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 04e4ec063f..0558e4b506 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -1507,90 +1507,12 @@ static int hyperv_init_vcpu(X86CPU *cpu)
 
 static Error *invtsc_mig_blocker;
 
-#define KVM_MAX_CPUID_ENTRIES  100
-
-int kvm_arch_init_vcpu(CPUState *cs)
+uint32_t kvm_x86_arch_cpuid(CPUX86State *env, struct kvm_cpuid_entry2 *entries,
+                            uint32_t cpuid_i)
 {
-    struct {
-        struct kvm_cpuid2 cpuid;
-        struct kvm_cpuid_entry2 entries[KVM_MAX_CPUID_ENTRIES];
-    } cpuid_data;
-    /*
-     * The kernel defines these structs with padding fields so there
-     * should be no extra padding in our cpuid_data struct.
-     */
-    QEMU_BUILD_BUG_ON(sizeof(cpuid_data) !=
-                      sizeof(struct kvm_cpuid2) +
-                      sizeof(struct kvm_cpuid_entry2) * KVM_MAX_CPUID_ENTRIES);
-
-    X86CPU *cpu = X86_CPU(cs);
-    CPUX86State *env = &cpu->env;
-    uint32_t limit, i, j, cpuid_i;
+    uint32_t limit, i, j;
     uint32_t unused;
     struct kvm_cpuid_entry2 *c;
-    uint32_t signature[3];
-    int kvm_base = KVM_CPUID_SIGNATURE;
-    int max_nested_state_len;
-    int r;
-    Error *local_err = NULL;
-
-    memset(&cpuid_data, 0, sizeof(cpuid_data));
-
-    cpuid_i = 0;
-
-    r = kvm_arch_set_tsc_khz(cs);
-    if (r < 0) {
-        return r;
-    }
-
-    /* vcpu's TSC frequency is either specified by user, or following
-     * the value used by KVM if the former is not present. In the
-     * latter case, we query it from KVM and record in env->tsc_khz,
-     * so that vcpu's TSC frequency can be migrated later via this field.
-     */
-    if (!env->tsc_khz) {
-        r = kvm_check_extension(cs->kvm_state, KVM_CAP_GET_TSC_KHZ) ?
-            kvm_vcpu_ioctl(cs, KVM_GET_TSC_KHZ) :
-            -ENOTSUP;
-        if (r > 0) {
-            env->tsc_khz = r;
-        }
-    }
-
-    env->apic_bus_freq = KVM_APIC_BUS_FREQUENCY;
-
-    /* Paravirtualization CPUIDs */
-    hyperv_expand_features(cs, &local_err);
-    if (local_err) {
-        error_report_err(local_err);
-        return -ENOSYS;
-    }
-
-    if (hyperv_enabled(cpu)) {
-        r = hyperv_init_vcpu(cpu);
-        if (r) {
-            return r;
-        }
-
-        cpuid_i = hyperv_fill_cpuids(cs, cpuid_data.entries);
-        kvm_base = KVM_CPUID_SIGNATURE_NEXT;
-        has_msr_hv_hypercall = true;
-    }
-
-    if (cpu->expose_kvm) {
-        memcpy(signature, "KVMKVMKVM\0\0\0", 12);
-        c = &cpuid_data.entries[cpuid_i++];
-        c->function = KVM_CPUID_SIGNATURE | kvm_base;
-        c->eax = KVM_CPUID_FEATURES | kvm_base;
-        c->ebx = signature[0];
-        c->ecx = signature[1];
-        c->edx = signature[2];
-
-        c = &cpuid_data.entries[cpuid_i++];
-        c->function = KVM_CPUID_FEATURES | kvm_base;
-        c->eax = env->features[FEAT_KVM];
-        c->edx = env->features[FEAT_KVM_HINTS];
-    }
 
     cpu_x86_cpuid(env, 0, 0, &limit, &unused, &unused, &unused);
 
@@ -1599,7 +1521,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
             fprintf(stderr, "unsupported level value: 0x%x\n", limit);
             abort();
         }
-        c = &cpuid_data.entries[cpuid_i++];
+        c = &entries[cpuid_i++];
 
         switch (i) {
         case 2: {
@@ -1618,7 +1540,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
                             "cpuid(eax:2):eax & 0xf = 0x%x\n", times);
                     abort();
                 }
-                c = &cpuid_data.entries[cpuid_i++];
+                c = &entries[cpuid_i++];
                 c->function = i;
                 c->flags = KVM_CPUID_FLAG_STATEFUL_FUNC;
                 cpu_x86_cpuid(env, i, 0, &c->eax, &c->ebx, &c->ecx, &c->edx);
@@ -1664,7 +1586,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
                             "cpuid(eax:0x%x,ecx:0x%x)\n", i, j);
                     abort();
                 }
-                c = &cpuid_data.entries[cpuid_i++];
+                c = &entries[cpuid_i++];
             }
             break;
         case 0x7:
@@ -1683,7 +1605,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
                                 "cpuid(eax:0x%x,ecx:0x%x)\n", i, j);
                     abort();
                 }
-                c = &cpuid_data.entries[cpuid_i++];
+                c = &entries[cpuid_i++];
                 c->function = i;
                 c->index = j;
                 c->flags = KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
@@ -1740,7 +1662,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
             fprintf(stderr, "unsupported xlevel value: 0x%x\n", limit);
             abort();
         }
-        c = &cpuid_data.entries[cpuid_i++];
+        c = &entries[cpuid_i++];
 
         switch (i) {
         case 0x8000001d:
@@ -1759,7 +1681,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
                             "cpuid(eax:0x%x,ecx:0x%x)\n", i, j);
                     abort();
                 }
-                c = &cpuid_data.entries[cpuid_i++];
+                c = &entries[cpuid_i++];
             }
             break;
         default:
@@ -1786,7 +1708,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
                 fprintf(stderr, "unsupported xlevel2 value: 0x%x\n", limit);
                 abort();
             }
-            c = &cpuid_data.entries[cpuid_i++];
+            c = &entries[cpuid_i++];
 
             c->function = i;
             c->flags = 0;
@@ -1794,6 +1716,94 @@ int kvm_arch_init_vcpu(CPUState *cs)
         }
     }
 
+    return cpuid_i;
+}
+
+#define KVM_MAX_CPUID_ENTRIES  100
+
+int kvm_arch_init_vcpu(CPUState *cs)
+{
+    struct {
+        struct kvm_cpuid2 cpuid;
+        struct kvm_cpuid_entry2 entries[KVM_MAX_CPUID_ENTRIES];
+    } cpuid_data;
+    /*
+     * The kernel defines these structs with padding fields so there
+     * should be no extra padding in our cpuid_data struct.
+     */
+    QEMU_BUILD_BUG_ON(sizeof(cpuid_data) !=
+                      sizeof(struct kvm_cpuid2) +
+                      sizeof(struct kvm_cpuid_entry2) * KVM_MAX_CPUID_ENTRIES);
+
+    X86CPU *cpu = X86_CPU(cs);
+    CPUX86State *env = &cpu->env;
+    uint32_t cpuid_i;
+    struct kvm_cpuid_entry2 *c;
+    uint32_t signature[3];
+    int kvm_base = KVM_CPUID_SIGNATURE;
+    int max_nested_state_len;
+    int r;
+    Error *local_err = NULL;
+
+    memset(&cpuid_data, 0, sizeof(cpuid_data));
+
+    cpuid_i = 0;
+
+    r = kvm_arch_set_tsc_khz(cs);
+    if (r < 0) {
+        return r;
+    }
+
+    /* vcpu's TSC frequency is either specified by user, or following
+     * the value used by KVM if the former is not present. In the
+     * latter case, we query it from KVM and record in env->tsc_khz,
+     * so that vcpu's TSC frequency can be migrated later via this field.
+     */
+    if (!env->tsc_khz) {
+        r = kvm_check_extension(cs->kvm_state, KVM_CAP_GET_TSC_KHZ) ?
+            kvm_vcpu_ioctl(cs, KVM_GET_TSC_KHZ) :
+            -ENOTSUP;
+        if (r > 0) {
+            env->tsc_khz = r;
+        }
+    }
+
+    env->apic_bus_freq = KVM_APIC_BUS_FREQUENCY;
+
+    /* Paravirtualization CPUIDs */
+    hyperv_expand_features(cs, &local_err);
+    if (local_err) {
+        error_report_err(local_err);
+        return -ENOSYS;
+    }
+
+    if (hyperv_enabled(cpu)) {
+        r = hyperv_init_vcpu(cpu);
+        if (r) {
+            return r;
+        }
+
+        cpuid_i = hyperv_fill_cpuids(cs, cpuid_data.entries);
+        kvm_base = KVM_CPUID_SIGNATURE_NEXT;
+        has_msr_hv_hypercall = true;
+    }
+
+    if (cpu->expose_kvm) {
+        memcpy(signature, "KVMKVMKVM\0\0\0", 12);
+        c = &cpuid_data.entries[cpuid_i++];
+        c->function = KVM_CPUID_SIGNATURE | kvm_base;
+        c->eax = KVM_CPUID_FEATURES | kvm_base;
+        c->ebx = signature[0];
+        c->ecx = signature[1];
+        c->edx = signature[2];
+
+        c = &cpuid_data.entries[cpuid_i++];
+        c->function = KVM_CPUID_FEATURES | kvm_base;
+        c->eax = env->features[FEAT_KVM];
+        c->edx = env->features[FEAT_KVM_HINTS];
+    }
+
+    cpuid_i = kvm_x86_arch_cpuid(env, cpuid_data.entries, cpuid_i);
     cpuid_data.cpuid.nent = cpuid_i;
 
     if (((env->cpuid_version >> 8)&0xF) >= 6
diff --git a/target/i386/kvm/kvm_i386.h b/target/i386/kvm/kvm_i386.h
index dc72508389..c9a92578b1 100644
--- a/target/i386/kvm/kvm_i386.h
+++ b/target/i386/kvm/kvm_i386.h
@@ -24,6 +24,10 @@
 #define kvm_ioapic_in_kernel() \
     (kvm_irqchip_in_kernel() && !kvm_irqchip_is_split())
 
+#define KVM_MAX_CPUID_ENTRIES  100
+uint32_t kvm_x86_arch_cpuid(CPUX86State *env, struct kvm_cpuid_entry2 *entries,
+                            uint32_t cpuid_i);
+
 #else
 
 #define kvm_pit_in_kernel()      0
-- 
2.25.1

