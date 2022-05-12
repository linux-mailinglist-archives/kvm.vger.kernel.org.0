Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69166524339
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 05:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343493AbiELDTL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 May 2022 23:19:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245593AbiELDTB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 May 2022 23:19:01 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05EF86D39A
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 20:18:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652325540; x=1683861540;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xXOpZyf6vx7tJv/hV11QMvvy3TYUd0GngrfsQ4GYerg=;
  b=CCc5sEswHNMdnd+XTC4wW+xmBu0leTpArlOpP1p/V9ul4FidAla7fnNK
   joW99KiGcNF7oN81hCohB9Smha1iMBIQk/mX5b2D5Z01zZS1RW2GlJN/C
   jjAYTPyo7xv3fzBfSq/ArBWe0Q9+cdiTta+z6/fFV/d9XC1mHdYogYmpC
   qzcyF2XbeAzkz2SA7o3TfzGuNSu2oY5UiPYCVJPOSFDFxwOWpoTWdxJtd
   3HpRHTC4QBxU7FcfkcZ3BwAlpbUD8EM7gAD4O0fr8IYXDDuaA3vrvpG8s
   jYEL5/hYShAv0GWiA+37zc8fXy41a3+0QWBaQ463DTZtwd60ptYN4CRDY
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10344"; a="332914808"
X-IronPort-AV: E=Sophos;i="5.91,218,1647327600"; 
   d="scan'208";a="332914808"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2022 20:18:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,218,1647327600"; 
   d="scan'208";a="594455614"
Received: from lxy-dell.sh.intel.com ([10.239.159.55])
  by orsmga008.jf.intel.com with ESMTP; 11 May 2022 20:18:52 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        isaku.yamahata@intel.com, Gerd Hoffmann <kraxel@redhat.com>,
        =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Eric Blake <eblake@redhat.com>
Cc:     Connor Kuehl <ckuehl@redhat.com>, erdemaktas@google.com,
        kvm@vger.kernel.org, qemu-devel@nongnu.org, seanjc@google.com,
        xiaoyao.li@intel.com
Subject: [RFC PATCH v4 10/36] i386/kvm: Move architectural CPUID leaf generation to separate helper
Date:   Thu, 12 May 2022 11:17:37 +0800
Message-Id: <20220512031803.3315890-11-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220512031803.3315890-1-xiaoyao.li@intel.com>
References: <20220512031803.3315890-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Move the architectural (for lack of a better term) CPUID leaf generation
to a separate helper so that the generation code can be reused by TDX,
which needs to generate a canonical VM-scoped configuration.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/kvm/kvm.c      | 222 +++++++++++++++++++------------------
 target/i386/kvm/kvm_i386.h |   4 +
 2 files changed, 119 insertions(+), 107 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 0751e6e102cc..5be151e6499b 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -1686,8 +1686,6 @@ static int hyperv_init_vcpu(X86CPU *cpu)
 
 static Error *invtsc_mig_blocker;
 
-#define KVM_MAX_CPUID_ENTRIES  100
-
 static void kvm_init_xsave(CPUX86State *env)
 {
     if (has_xsave2) {
@@ -1708,115 +1706,21 @@ static void kvm_init_xsave(CPUX86State *env)
            env->xsave_buf_len);
 }
 
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
-    has_xsave2 = kvm_check_extension(cs->kvm_state, KVM_CAP_XSAVE2);
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
-    /*
-     * kvm_hyperv_expand_features() is called here for the second time in case
-     * KVM_CAP_SYS_HYPERV_CPUID is not supported. While we can't possibly handle
-     * 'query-cpu-model-expansion' in this case as we don't have a KVM vCPU to
-     * check which Hyper-V enlightenments are supported and which are not, we
-     * can still proceed and check/expand Hyper-V enlightenments here so legacy
-     * behavior is preserved.
-     */
-    if (!kvm_hyperv_expand_features(cpu, &local_err)) {
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
 
-    if (cpu->kvm_pv_enforce_cpuid) {
-        r = kvm_vcpu_enable_cap(cs, KVM_CAP_ENFORCE_PV_FEATURE_CPUID, 0, 1);
-        if (r < 0) {
-            fprintf(stderr,
-                    "failed to enable KVM_CAP_ENFORCE_PV_FEATURE_CPUID: %s",
-                    strerror(-r));
-            abort();
-        }
-    }
-
     for (i = 0; i <= limit; i++) {
         if (cpuid_i == KVM_MAX_CPUID_ENTRIES) {
             fprintf(stderr, "unsupported level value: 0x%x\n", limit);
             abort();
         }
-        c = &cpuid_data.entries[cpuid_i++];
+        c = &entries[cpuid_i++];
 
         switch (i) {
         case 2: {
@@ -1835,7 +1739,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
                             "cpuid(eax:2):eax & 0xf = 0x%x\n", times);
                     abort();
                 }
-                c = &cpuid_data.entries[cpuid_i++];
+                c = &entries[cpuid_i++];
                 c->function = i;
                 c->flags = KVM_CPUID_FLAG_STATEFUL_FUNC;
                 cpu_x86_cpuid(env, i, 0, &c->eax, &c->ebx, &c->ecx, &c->edx);
@@ -1881,7 +1785,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
                             "cpuid(eax:0x%x,ecx:0x%x)\n", i, j);
                     abort();
                 }
-                c = &cpuid_data.entries[cpuid_i++];
+                c = &entries[cpuid_i++];
             }
             break;
         case 0x7:
@@ -1901,7 +1805,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
                                 "cpuid(eax:0x12,ecx:0x%x)\n", j);
                     abort();
                 }
-                c = &cpuid_data.entries[cpuid_i++];
+                c = &entries[cpuid_i++];
             }
             break;
         case 0x14:
@@ -1921,7 +1825,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
                                 "cpuid(eax:0x%x,ecx:0x%x)\n", i, j);
                     abort();
                 }
-                c = &cpuid_data.entries[cpuid_i++];
+                c = &entries[cpuid_i++];
                 c->function = i;
                 c->index = j;
                 c->flags = KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
@@ -1978,7 +1882,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
             fprintf(stderr, "unsupported xlevel value: 0x%x\n", limit);
             abort();
         }
-        c = &cpuid_data.entries[cpuid_i++];
+        c = &entries[cpuid_i++];
 
         switch (i) {
         case 0x8000001d:
@@ -1997,7 +1901,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
                             "cpuid(eax:0x%x,ecx:0x%x)\n", i, j);
                     abort();
                 }
-                c = &cpuid_data.entries[cpuid_i++];
+                c = &entries[cpuid_i++];
             }
             break;
         default:
@@ -2024,7 +1928,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
                 fprintf(stderr, "unsupported xlevel2 value: 0x%x\n", limit);
                 abort();
             }
-            c = &cpuid_data.entries[cpuid_i++];
+            c = &entries[cpuid_i++];
 
             c->function = i;
             c->flags = 0;
@@ -2032,6 +1936,110 @@ int kvm_arch_init_vcpu(CPUState *cs)
         }
     }
 
+    return cpuid_i;
+}
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
+    has_xsave2 = kvm_check_extension(cs->kvm_state, KVM_CAP_XSAVE2);
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
+    /*
+     * kvm_hyperv_expand_features() is called here for the second time in case
+     * KVM_CAP_SYS_HYPERV_CPUID is not supported. While we can't possibly handle
+     * 'query-cpu-model-expansion' in this case as we don't have a KVM vCPU to
+     * check which Hyper-V enlightenments are supported and which are not, we
+     * can still proceed and check/expand Hyper-V enlightenments here so legacy
+     * behavior is preserved.
+     */
+    if (!kvm_hyperv_expand_features(cpu, &local_err)) {
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
+    if (cpu->kvm_pv_enforce_cpuid) {
+        r = kvm_vcpu_enable_cap(cs, KVM_CAP_ENFORCE_PV_FEATURE_CPUID, 0, 1);
+        if (r < 0) {
+            fprintf(stderr,
+                    "failed to enable KVM_CAP_ENFORCE_PV_FEATURE_CPUID: %s",
+                    strerror(-r));
+            abort();
+        }
+    }
+
+    cpuid_i = kvm_x86_arch_cpuid(env, cpuid_data.entries, cpuid_i);
     cpuid_data.cpuid.nent = cpuid_i;
 
     if (((env->cpuid_version >> 8)&0xF) >= 6
diff --git a/target/i386/kvm/kvm_i386.h b/target/i386/kvm/kvm_i386.h
index b434feaa6b1d..5c7972f617e8 100644
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
2.27.0

