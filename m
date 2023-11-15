Return-Path: <kvm+bounces-1752-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E30287EBDA2
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 08:18:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3D66BB20F53
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 07:18:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 885163D6E;
	Wed, 15 Nov 2023 07:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y/sePcXo"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0FCCE56A
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 07:18:13 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FEF8E9
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 23:18:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700032692; x=1731568692;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=q/vGUcTjmW3xLkhpTgJb1cHgy5ooIIHzznjqzU/8EUA=;
  b=Y/sePcXoj5jyDp8Fbc5SwWrJVaXLkpKihENwoQV5BqYt4DEms9wyDh89
   zLE82tgNo7RgYBmrx73a+YT6QqMIy+NRfz+m2tsS+tfifrPQR2oOdnOjf
   8mvDLebKdK2hvEY6sb2ccUc1GEKa0wvz1vs8gU6OSWKd5x+4adP1a0Oz9
   WzVM0yiiLq17Bjr9yNKwxTt44UgqiCKpY+GMIp/Nxi8WcnrDwR5uSWaFv
   lfIDS923KDy5WUS3l9Q31MzbnwD852i3LkE3KLMneBxJAe0GUlbZOohsK
   ZD5lmpkUKUtIyAFSjyprfECgtS6V16C0GbjhcPiFS88vjozCrW5ikFp9E
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="390622721"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="390622721"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2023 23:18:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="714798324"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="714798324"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orsmga003.jf.intel.com with ESMTP; 14 Nov 2023 23:18:04 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Peter Xu <peterx@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Cornelia Huck <cohuck@redhat.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	xiaoyao.li@intel.com,
	Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Claudio Fontana <cfontana@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>
Subject: [PATCH v3 24/70] i386/kvm: Move architectural CPUID leaf generation to separate helper
Date: Wed, 15 Nov 2023 02:14:33 -0500
Message-Id: <20231115071519.2864957-25-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231115071519.2864957-1-xiaoyao.li@intel.com>
References: <20231115071519.2864957-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
index f2627dd61d2b..dafe4d262977 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -1733,6 +1733,236 @@ static void kvm_init_nested_state(CPUX86State *env)
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
@@ -1749,8 +1979,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
 
     X86CPU *cpu = X86_CPU(cs);
     CPUX86State *env = &cpu->env;
-    uint32_t limit, i, j, cpuid_i;
-    uint32_t unused;
+    uint32_t cpuid_i;
     struct kvm_cpuid_entry2 *c;
     uint32_t signature[3];
     int kvm_base = KVM_CPUID_SIGNATURE;
@@ -1903,8 +2132,6 @@ int kvm_arch_init_vcpu(CPUState *cs)
         c->edx = env->features[FEAT_KVM_HINTS];
     }
 
-    cpu_x86_cpuid(env, 0, 0, &limit, &unused, &unused, &unused);
-
     if (cpu->kvm_pv_enforce_cpuid) {
         r = kvm_vcpu_enable_cap(cs, KVM_CAP_ENFORCE_PV_FEATURE_CPUID, 0, 1);
         if (r < 0) {
@@ -1915,224 +2142,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
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
index c3ef46a97a7b..cbf52c1c6d17 100644
--- a/target/i386/kvm/kvm_i386.h
+++ b/target/i386/kvm/kvm_i386.h
@@ -24,6 +24,9 @@
 #define kvm_ioapic_in_kernel() \
     (kvm_irqchip_in_kernel() && !kvm_irqchip_is_split())
 
+uint32_t kvm_x86_arch_cpuid(CPUX86State *env, struct kvm_cpuid_entry2 *entries,
+                            uint32_t cpuid_i);
+
 #else
 
 #define kvm_pit_in_kernel()      0
-- 
2.34.1


