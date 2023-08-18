Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C655B78091F
	for <lists+kvm@lfdr.de>; Fri, 18 Aug 2023 11:56:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359464AbjHRJ4Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Aug 2023 05:56:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359544AbjHRJzu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Aug 2023 05:55:50 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E520D30F6
        for <kvm@vger.kernel.org>; Fri, 18 Aug 2023 02:55:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692352543; x=1723888543;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9PyA2gDXLUrXv4dKqBoQcsq2fBVcVnKf/KO9XkbpnV0=;
  b=dhmIir3hO7YR1u+114pnwz8yZpGR6vVrgciahLHHhRD8wTrzuEJCpNhf
   ejEXF7AjJ+son03IwdzamwKR8TvyHdpgUNCCmicWA9kS5WQnbN7XTyI4/
   bNZuEZh0exRBkgkrcoj64H2wOvhfyyDWUWPBBUxfmYcOOKZdAXc2dUvgL
   qKJlrR7v2igSjWTOLVmrlstKHg6P9iDlqy2+0gbFRpyN3XRFE1pbbyC7p
   7OY1BvUGQhXlL8wmwZY7i0NQIRmPwKg4iGR0+xUcPfgvQwYXuGVBgmamv
   MDjSlHqQiyrc4ZGDT8VKzsrpJ/ZOwQrUWnyvAygRd2HRxMX2o7aIdyJk9
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="371965815"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="371965815"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2023 02:55:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="849234895"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="849234895"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.46])
  by fmsmga002.fm.intel.com with ESMTP; 18 Aug 2023 02:55:25 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Ani Sinha <anisinha@redhat.com>, Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Eduardo Habkost <eduardo@habkost.net>,
        Laszlo Ersek <lersek@redhat.com>, xiaoyao.li@intel.com,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        erdemaktas@google.com, Chenyi Qiang <chenyi.qiang@intel.com>
Subject: [PATCH v2 12/58] i386/kvm: Move architectural CPUID leaf generation to separate helper
Date:   Fri, 18 Aug 2023 05:49:55 -0400
Message-Id: <20230818095041.1973309-13-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230818095041.1973309-1-xiaoyao.li@intel.com>
References: <20230818095041.1973309-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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
 target/i386/kvm/kvm.c      | 454 +++++++++++++++++++------------------
 target/i386/kvm/kvm_i386.h |   3 +
 2 files changed, 235 insertions(+), 222 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 46a455a1e331..9ee41fffc445 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -1799,6 +1799,236 @@ static void kvm_init_nested_state(CPUX86State *env)
     }
 }
 
+uint32_t kvm_x86_arch_cpuid(CPUX86State *env, struct kvm_cpuid_entry2 *entries,
+                            uint32_t cpuid_i)
+{
+    uint32_t limit, i, j;
+    uint32_t unused;
+    struct kvm_cpuid_entry2 *c;
+
+    cpu_x86_cpuid(env, 0, 0, &limit, &unused, &unused, &unused);
+
+    for (i = 0; i <= limit; i++) {
+        if (cpuid_i == KVM_MAX_CPUID_ENTRIES) {
+            fprintf(stderr, "unsupported level value: 0x%x\n", limit);
+            abort();
+        }
+        c = &entries[cpuid_i++];
+
+        switch (i) {
+        case 2: {
+            /* Keep reading function 2 till all the input is received */
+            int times;
+
+            c->function = i;
+            c->flags = KVM_CPUID_FLAG_STATEFUL_FUNC |
+                       KVM_CPUID_FLAG_STATE_READ_NEXT;
+            cpu_x86_cpuid(env, i, 0, &c->eax, &c->ebx, &c->ecx, &c->edx);
+            times = c->eax & 0xff;
+
+            for (j = 1; j < times; ++j) {
+                if (cpuid_i == KVM_MAX_CPUID_ENTRIES) {
+                    fprintf(stderr, "cpuid_data is full, no space for "
+                            "cpuid(eax:2):eax & 0xf = 0x%x\n", times);
+                    abort();
+                }
+                c = &entries[cpuid_i++];
+                c->function = i;
+                c->flags = KVM_CPUID_FLAG_STATEFUL_FUNC;
+                cpu_x86_cpuid(env, i, 0, &c->eax, &c->ebx, &c->ecx, &c->edx);
+            }
+            break;
+        }
+        case 0x1f:
+            if (env->nr_dies < 2) {
+                cpuid_i--;
+                break;
+            }
+            /* fallthrough */
+        case 4:
+        case 0xb:
+        case 0xd:
+            for (j = 0; ; j++) {
+                if (i == 0xd && j == 64) {
+                    break;
+                }
+
+                c->function = i;
+                c->flags = KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
+                c->index = j;
+                cpu_x86_cpuid(env, i, j, &c->eax, &c->ebx, &c->ecx, &c->edx);
+
+                if (i == 4 && c->eax == 0) {
+                    break;
+                }
+                if (i == 0xb && !(c->ecx & 0xff00)) {
+                    break;
+                }
+                if (i == 0x1f && !(c->ecx & 0xff00)) {
+                    break;
+                }
+                if (i == 0xd && c->eax == 0) {
+                    continue;
+                }
+                if (cpuid_i == KVM_MAX_CPUID_ENTRIES) {
+                    fprintf(stderr, "cpuid_data is full, no space for "
+                            "cpuid(eax:0x%x,ecx:0x%x)\n", i, j);
+                    abort();
+                }
+                c = &entries[cpuid_i++];
+            }
+            break;
+        case 0x7:
+        case 0x12:
+            for (j = 0; ; j++) {
+                c->function = i;
+                c->flags = KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
+                c->index = j;
+                cpu_x86_cpuid(env, i, j, &c->eax, &c->ebx, &c->ecx, &c->edx);
+
+                if (j > 1 && (c->eax & 0xf) != 1) {
+                    break;
+                }
+
+                if (cpuid_i == KVM_MAX_CPUID_ENTRIES) {
+                    fprintf(stderr, "cpuid_data is full, no space for "
+                                "cpuid(eax:0x12,ecx:0x%x)\n", j);
+                    abort();
+                }
+                c = &entries[cpuid_i++];
+            }
+            break;
+        case 0x14:
+        case 0x1d:
+        case 0x1e: {
+            uint32_t times;
+
+            c->function = i;
+            c->index = 0;
+            c->flags = KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
+            cpu_x86_cpuid(env, i, 0, &c->eax, &c->ebx, &c->ecx, &c->edx);
+            times = c->eax;
+
+            for (j = 1; j <= times; ++j) {
+                if (cpuid_i == KVM_MAX_CPUID_ENTRIES) {
+                    fprintf(stderr, "cpuid_data is full, no space for "
+                                "cpuid(eax:0x%x,ecx:0x%x)\n", i, j);
+                    abort();
+                }
+                c = &entries[cpuid_i++];
+                c->function = i;
+                c->index = j;
+                c->flags = KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
+                cpu_x86_cpuid(env, i, j, &c->eax, &c->ebx, &c->ecx, &c->edx);
+            }
+            break;
+        }
+        default:
+            c->function = i;
+            c->flags = 0;
+            cpu_x86_cpuid(env, i, 0, &c->eax, &c->ebx, &c->ecx, &c->edx);
+            if (!c->eax && !c->ebx && !c->ecx && !c->edx) {
+                /*
+                 * KVM already returns all zeroes if a CPUID entry is missing,
+                 * so we can omit it and avoid hitting KVM's 80-entry limit.
+                 */
+                cpuid_i--;
+            }
+            break;
+        }
+    }
+
+    if (limit >= 0x0a) {
+        uint32_t eax, edx;
+
+        cpu_x86_cpuid(env, 0x0a, 0, &eax, &unused, &unused, &edx);
+
+        has_architectural_pmu_version = eax & 0xff;
+        if (has_architectural_pmu_version > 0) {
+            num_architectural_pmu_gp_counters = (eax & 0xff00) >> 8;
+
+            /* Shouldn't be more than 32, since that's the number of bits
+             * available in EBX to tell us _which_ counters are available.
+             * Play it safe.
+             */
+            if (num_architectural_pmu_gp_counters > MAX_GP_COUNTERS) {
+                num_architectural_pmu_gp_counters = MAX_GP_COUNTERS;
+            }
+
+            if (has_architectural_pmu_version > 1) {
+                num_architectural_pmu_fixed_counters = edx & 0x1f;
+
+                if (num_architectural_pmu_fixed_counters > MAX_FIXED_COUNTERS) {
+                    num_architectural_pmu_fixed_counters = MAX_FIXED_COUNTERS;
+                }
+            }
+        }
+    }
+
+    cpu_x86_cpuid(env, 0x80000000, 0, &limit, &unused, &unused, &unused);
+
+    for (i = 0x80000000; i <= limit; i++) {
+        if (cpuid_i == KVM_MAX_CPUID_ENTRIES) {
+            fprintf(stderr, "unsupported xlevel value: 0x%x\n", limit);
+            abort();
+        }
+        c = &entries[cpuid_i++];
+
+        switch (i) {
+        case 0x8000001d:
+            /* Query for all AMD cache information leaves */
+            for (j = 0; ; j++) {
+                c->function = i;
+                c->flags = KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
+                c->index = j;
+                cpu_x86_cpuid(env, i, j, &c->eax, &c->ebx, &c->ecx, &c->edx);
+
+                if (c->eax == 0) {
+                    break;
+                }
+                if (cpuid_i == KVM_MAX_CPUID_ENTRIES) {
+                    fprintf(stderr, "cpuid_data is full, no space for "
+                            "cpuid(eax:0x%x,ecx:0x%x)\n", i, j);
+                    abort();
+                }
+                c = &entries[cpuid_i++];
+            }
+            break;
+        default:
+            c->function = i;
+            c->flags = 0;
+            cpu_x86_cpuid(env, i, 0, &c->eax, &c->ebx, &c->ecx, &c->edx);
+            if (!c->eax && !c->ebx && !c->ecx && !c->edx) {
+                /*
+                 * KVM already returns all zeroes if a CPUID entry is missing,
+                 * so we can omit it and avoid hitting KVM's 80-entry limit.
+                 */
+                cpuid_i--;
+            }
+            break;
+        }
+    }
+
+    /* Call Centaur's CPUID instructions they are supported. */
+    if (env->cpuid_xlevel2 > 0) {
+        cpu_x86_cpuid(env, 0xC0000000, 0, &limit, &unused, &unused, &unused);
+
+        for (i = 0xC0000000; i <= limit; i++) {
+            if (cpuid_i == KVM_MAX_CPUID_ENTRIES) {
+                fprintf(stderr, "unsupported xlevel2 value: 0x%x\n", limit);
+                abort();
+            }
+            c = &entries[cpuid_i++];
+
+            c->function = i;
+            c->flags = 0;
+            cpu_x86_cpuid(env, i, 0, &c->eax, &c->ebx, &c->ecx, &c->edx);
+        }
+    }
+
+    return cpuid_i;
+}
+
 int kvm_arch_init_vcpu(CPUState *cs)
 {
     struct {
@@ -1815,8 +2045,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
 
     X86CPU *cpu = X86_CPU(cs);
     CPUX86State *env = &cpu->env;
-    uint32_t limit, i, j, cpuid_i;
-    uint32_t unused;
+    uint32_t cpuid_i;
     struct kvm_cpuid_entry2 *c;
     uint32_t signature[3];
     int kvm_base = KVM_CPUID_SIGNATURE;
@@ -1965,8 +2194,6 @@ int kvm_arch_init_vcpu(CPUState *cs)
         c->edx = env->features[FEAT_KVM_HINTS];
     }
 
-    cpu_x86_cpuid(env, 0, 0, &limit, &unused, &unused, &unused);
-
     if (cpu->kvm_pv_enforce_cpuid) {
         r = kvm_vcpu_enable_cap(cs, KVM_CAP_ENFORCE_PV_FEATURE_CPUID, 0, 1);
         if (r < 0) {
@@ -1977,224 +2204,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
         }
     }
 
-    for (i = 0; i <= limit; i++) {
-        if (cpuid_i == KVM_MAX_CPUID_ENTRIES) {
-            fprintf(stderr, "unsupported level value: 0x%x\n", limit);
-            abort();
-        }
-        c = &cpuid_data.entries[cpuid_i++];
-
-        switch (i) {
-        case 2: {
-            /* Keep reading function 2 till all the input is received */
-            int times;
-
-            c->function = i;
-            c->flags = KVM_CPUID_FLAG_STATEFUL_FUNC |
-                       KVM_CPUID_FLAG_STATE_READ_NEXT;
-            cpu_x86_cpuid(env, i, 0, &c->eax, &c->ebx, &c->ecx, &c->edx);
-            times = c->eax & 0xff;
-
-            for (j = 1; j < times; ++j) {
-                if (cpuid_i == KVM_MAX_CPUID_ENTRIES) {
-                    fprintf(stderr, "cpuid_data is full, no space for "
-                            "cpuid(eax:2):eax & 0xf = 0x%x\n", times);
-                    abort();
-                }
-                c = &cpuid_data.entries[cpuid_i++];
-                c->function = i;
-                c->flags = KVM_CPUID_FLAG_STATEFUL_FUNC;
-                cpu_x86_cpuid(env, i, 0, &c->eax, &c->ebx, &c->ecx, &c->edx);
-            }
-            break;
-        }
-        case 0x1f:
-            if (env->nr_dies < 2) {
-                cpuid_i--;
-                break;
-            }
-            /* fallthrough */
-        case 4:
-        case 0xb:
-        case 0xd:
-            for (j = 0; ; j++) {
-                if (i == 0xd && j == 64) {
-                    break;
-                }
-
-                c->function = i;
-                c->flags = KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
-                c->index = j;
-                cpu_x86_cpuid(env, i, j, &c->eax, &c->ebx, &c->ecx, &c->edx);
-
-                if (i == 4 && c->eax == 0) {
-                    break;
-                }
-                if (i == 0xb && !(c->ecx & 0xff00)) {
-                    break;
-                }
-                if (i == 0x1f && !(c->ecx & 0xff00)) {
-                    break;
-                }
-                if (i == 0xd && c->eax == 0) {
-                    continue;
-                }
-                if (cpuid_i == KVM_MAX_CPUID_ENTRIES) {
-                    fprintf(stderr, "cpuid_data is full, no space for "
-                            "cpuid(eax:0x%x,ecx:0x%x)\n", i, j);
-                    abort();
-                }
-                c = &cpuid_data.entries[cpuid_i++];
-            }
-            break;
-        case 0x7:
-        case 0x12:
-            for (j = 0; ; j++) {
-                c->function = i;
-                c->flags = KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
-                c->index = j;
-                cpu_x86_cpuid(env, i, j, &c->eax, &c->ebx, &c->ecx, &c->edx);
-
-                if (j > 1 && (c->eax & 0xf) != 1) {
-                    break;
-                }
-
-                if (cpuid_i == KVM_MAX_CPUID_ENTRIES) {
-                    fprintf(stderr, "cpuid_data is full, no space for "
-                                "cpuid(eax:0x12,ecx:0x%x)\n", j);
-                    abort();
-                }
-                c = &cpuid_data.entries[cpuid_i++];
-            }
-            break;
-        case 0x14:
-        case 0x1d:
-        case 0x1e: {
-            uint32_t times;
-
-            c->function = i;
-            c->index = 0;
-            c->flags = KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
-            cpu_x86_cpuid(env, i, 0, &c->eax, &c->ebx, &c->ecx, &c->edx);
-            times = c->eax;
-
-            for (j = 1; j <= times; ++j) {
-                if (cpuid_i == KVM_MAX_CPUID_ENTRIES) {
-                    fprintf(stderr, "cpuid_data is full, no space for "
-                                "cpuid(eax:0x%x,ecx:0x%x)\n", i, j);
-                    abort();
-                }
-                c = &cpuid_data.entries[cpuid_i++];
-                c->function = i;
-                c->index = j;
-                c->flags = KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
-                cpu_x86_cpuid(env, i, j, &c->eax, &c->ebx, &c->ecx, &c->edx);
-            }
-            break;
-        }
-        default:
-            c->function = i;
-            c->flags = 0;
-            cpu_x86_cpuid(env, i, 0, &c->eax, &c->ebx, &c->ecx, &c->edx);
-            if (!c->eax && !c->ebx && !c->ecx && !c->edx) {
-                /*
-                 * KVM already returns all zeroes if a CPUID entry is missing,
-                 * so we can omit it and avoid hitting KVM's 80-entry limit.
-                 */
-                cpuid_i--;
-            }
-            break;
-        }
-    }
-
-    if (limit >= 0x0a) {
-        uint32_t eax, edx;
-
-        cpu_x86_cpuid(env, 0x0a, 0, &eax, &unused, &unused, &edx);
-
-        has_architectural_pmu_version = eax & 0xff;
-        if (has_architectural_pmu_version > 0) {
-            num_architectural_pmu_gp_counters = (eax & 0xff00) >> 8;
-
-            /* Shouldn't be more than 32, since that's the number of bits
-             * available in EBX to tell us _which_ counters are available.
-             * Play it safe.
-             */
-            if (num_architectural_pmu_gp_counters > MAX_GP_COUNTERS) {
-                num_architectural_pmu_gp_counters = MAX_GP_COUNTERS;
-            }
-
-            if (has_architectural_pmu_version > 1) {
-                num_architectural_pmu_fixed_counters = edx & 0x1f;
-
-                if (num_architectural_pmu_fixed_counters > MAX_FIXED_COUNTERS) {
-                    num_architectural_pmu_fixed_counters = MAX_FIXED_COUNTERS;
-                }
-            }
-        }
-    }
-
-    cpu_x86_cpuid(env, 0x80000000, 0, &limit, &unused, &unused, &unused);
-
-    for (i = 0x80000000; i <= limit; i++) {
-        if (cpuid_i == KVM_MAX_CPUID_ENTRIES) {
-            fprintf(stderr, "unsupported xlevel value: 0x%x\n", limit);
-            abort();
-        }
-        c = &cpuid_data.entries[cpuid_i++];
-
-        switch (i) {
-        case 0x8000001d:
-            /* Query for all AMD cache information leaves */
-            for (j = 0; ; j++) {
-                c->function = i;
-                c->flags = KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
-                c->index = j;
-                cpu_x86_cpuid(env, i, j, &c->eax, &c->ebx, &c->ecx, &c->edx);
-
-                if (c->eax == 0) {
-                    break;
-                }
-                if (cpuid_i == KVM_MAX_CPUID_ENTRIES) {
-                    fprintf(stderr, "cpuid_data is full, no space for "
-                            "cpuid(eax:0x%x,ecx:0x%x)\n", i, j);
-                    abort();
-                }
-                c = &cpuid_data.entries[cpuid_i++];
-            }
-            break;
-        default:
-            c->function = i;
-            c->flags = 0;
-            cpu_x86_cpuid(env, i, 0, &c->eax, &c->ebx, &c->ecx, &c->edx);
-            if (!c->eax && !c->ebx && !c->ecx && !c->edx) {
-                /*
-                 * KVM already returns all zeroes if a CPUID entry is missing,
-                 * so we can omit it and avoid hitting KVM's 80-entry limit.
-                 */
-                cpuid_i--;
-            }
-            break;
-        }
-    }
-
-    /* Call Centaur's CPUID instructions they are supported. */
-    if (env->cpuid_xlevel2 > 0) {
-        cpu_x86_cpuid(env, 0xC0000000, 0, &limit, &unused, &unused, &unused);
-
-        for (i = 0xC0000000; i <= limit; i++) {
-            if (cpuid_i == KVM_MAX_CPUID_ENTRIES) {
-                fprintf(stderr, "unsupported xlevel2 value: 0x%x\n", limit);
-                abort();
-            }
-            c = &cpuid_data.entries[cpuid_i++];
-
-            c->function = i;
-            c->flags = 0;
-            cpu_x86_cpuid(env, i, 0, &c->eax, &c->ebx, &c->ecx, &c->edx);
-        }
-    }
-
+    cpuid_i = kvm_x86_arch_cpuid(env, cpuid_data.entries, cpuid_i);
     cpuid_data.cpuid.nent = cpuid_i;
 
     if (((env->cpuid_version >> 8)&0xF) >= 6
diff --git a/target/i386/kvm/kvm_i386.h b/target/i386/kvm/kvm_i386.h
index 769eadbba56c..fd7e76fcf847 100644
--- a/target/i386/kvm/kvm_i386.h
+++ b/target/i386/kvm/kvm_i386.h
@@ -26,6 +26,9 @@
 #define kvm_ioapic_in_kernel() \
     (kvm_irqchip_in_kernel() && !kvm_irqchip_is_split())
 
+uint32_t kvm_x86_arch_cpuid(CPUX86State *env, struct kvm_cpuid_entry2 *entries,
+                            uint32_t cpuid_i);
+
 #else
 
 #define kvm_pit_in_kernel()      0
-- 
2.34.1

