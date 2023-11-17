Return-Path: <kvm+bounces-1921-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AE2AA7EECC1
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 08:40:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6A1A61F211F4
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 07:40:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F5F910A04;
	Fri, 17 Nov 2023 07:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HnroripB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACA83D55
	for <kvm@vger.kernel.org>; Thu, 16 Nov 2023 23:39:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700206783; x=1731742783;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oDpceN9UpFAa3nnomI7eCB+Z2zqmrgByiUKpHzUKN2Q=;
  b=HnroripBHy0R5b5m2pFPvk7E1G5cVz4/Onxat4s8JbjPyfFfMhq7tqEn
   gYFC/f5GV3NfOChKnq1NeXvhK1b+Qlm8UByFryRn/VybsJdk/LGgGFHFC
   zZXKGjf538i7C7uOzGQ7+Pe3VSYft8f5Njx4R4W+QpSgz7lklxhiIUfnN
   q09Bpsj1vHN1AKdbJrcfswydxLtgk4NEXGIVCOSE5ceJ8vk5B7ylTLcmY
   7U6fyFhuCZDaJEEcGKiWOHL3it4fUbhMYeAjBxnRnvJe063z4RjbOLiSK
   qFnb9Z18CjY0FR+F2AWa7TM0sSxO1RncDDexTayiqGbEvFn7RY0T4DzZg
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10896"; a="395180321"
X-IronPort-AV: E=Sophos;i="6.04,206,1695711600"; 
   d="scan'208";a="395180321"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2023 23:39:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10896"; a="883042684"
X-IronPort-AV: E=Sophos;i="6.04,206,1695711600"; 
   d="scan'208";a="883042684"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmsmga002.fm.intel.com with ESMTP; 16 Nov 2023 23:39:39 -0800
From: Zhao Liu <zhao1.liu@linux.intel.com>
To: Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Zhuocheng Ding <zhuocheng.ding@intel.com>,
	Babu Moger <babu.moger@amd.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v6 05/16] i386: Decouple CPUID[0x1F] subleaf with specific topology level
Date: Fri, 17 Nov 2023 15:50:55 +0800
Message-Id: <20231117075106.432499-6-zhao1.liu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231117075106.432499-1-zhao1.liu@linux.intel.com>
References: <20231117075106.432499-1-zhao1.liu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhao Liu <zhao1.liu@intel.com>

At present, the subleaf 0x02 of CPUID[0x1F] is bound to the "die" level.

In fact, the specific topology level exposed in 0x1F depends on the
platform's support for extension levels (module, tile and die).

To help expose "module" level in 0x1F, decouple CPUID[0x1F] subleaf
with specific topology level.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
Tested-by: Babu Moger <babu.moger@amd.com>
Tested-by: Yongwei Ma <yongwei.ma@intel.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
---
Changes since v3:
 * New patch to prepare to expose module level in 0x1F.
 * Move the CPUTopoLevel enumeration definition from "i386: Add cache
   topology info in CPUCacheInfo" to this patch. Note, to align with
   topology types in SDM, revert the name of CPU_TOPO_LEVEL_UNKNOW to
   CPU_TOPO_LEVEL_INVALID.
---
 target/i386/cpu.c | 136 +++++++++++++++++++++++++++++++++++++---------
 target/i386/cpu.h |  15 +++++
 2 files changed, 126 insertions(+), 25 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index fe9098353ac3..1713499c44cd 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -269,6 +269,116 @@ static void encode_cache_cpuid4(CPUCacheInfo *cache,
            (cache->complex_indexing ? CACHE_COMPLEX_IDX : 0);
 }
 
+static uint32_t num_cpus_by_topo_level(X86CPUTopoInfo *topo_info,
+                                       enum CPUTopoLevel topo_level)
+{
+    switch (topo_level) {
+    case CPU_TOPO_LEVEL_SMT:
+        return 1;
+    case CPU_TOPO_LEVEL_CORE:
+        return topo_info->threads_per_core;
+    case CPU_TOPO_LEVEL_DIE:
+        return topo_info->threads_per_core * topo_info->cores_per_die;
+    case CPU_TOPO_LEVEL_PACKAGE:
+        return topo_info->threads_per_core * topo_info->cores_per_die *
+               topo_info->dies_per_pkg;
+    default:
+        g_assert_not_reached();
+    }
+    return 0;
+}
+
+static uint32_t apicid_offset_by_topo_level(X86CPUTopoInfo *topo_info,
+                                            enum CPUTopoLevel topo_level)
+{
+    switch (topo_level) {
+    case CPU_TOPO_LEVEL_SMT:
+        return 0;
+    case CPU_TOPO_LEVEL_CORE:
+        return apicid_core_offset(topo_info);
+    case CPU_TOPO_LEVEL_DIE:
+        return apicid_die_offset(topo_info);
+    case CPU_TOPO_LEVEL_PACKAGE:
+        return apicid_pkg_offset(topo_info);
+    default:
+        g_assert_not_reached();
+    }
+    return 0;
+}
+
+static uint32_t cpuid1f_topo_type(enum CPUTopoLevel topo_level)
+{
+    switch (topo_level) {
+    case CPU_TOPO_LEVEL_INVALID:
+        return CPUID_1F_ECX_TOPO_LEVEL_INVALID;
+    case CPU_TOPO_LEVEL_SMT:
+        return CPUID_1F_ECX_TOPO_LEVEL_SMT;
+    case CPU_TOPO_LEVEL_CORE:
+        return CPUID_1F_ECX_TOPO_LEVEL_CORE;
+    case CPU_TOPO_LEVEL_DIE:
+        return CPUID_1F_ECX_TOPO_LEVEL_DIE;
+    default:
+        /* Other types are not supported in QEMU. */
+        g_assert_not_reached();
+    }
+    return 0;
+}
+
+static void encode_topo_cpuid1f(CPUX86State *env, uint32_t count,
+                                X86CPUTopoInfo *topo_info,
+                                uint32_t *eax, uint32_t *ebx,
+                                uint32_t *ecx, uint32_t *edx)
+{
+    static DECLARE_BITMAP(topo_bitmap, CPU_TOPO_LEVEL_MAX);
+    X86CPU *cpu = env_archcpu(env);
+    unsigned long level, next_level;
+    uint32_t num_cpus_next_level, offset_next_level;
+
+    /*
+     * Initialize the bitmap to decide which levels should be
+     * encoded in 0x1f.
+     */
+    if (!count) {
+        /* SMT and core levels are exposed in 0x1f leaf by default. */
+        set_bit(CPU_TOPO_LEVEL_SMT, topo_bitmap);
+        set_bit(CPU_TOPO_LEVEL_CORE, topo_bitmap);
+
+        if (env->nr_dies > 1) {
+            set_bit(CPU_TOPO_LEVEL_DIE, topo_bitmap);
+        }
+    }
+
+    *ecx = count & 0xff;
+    *edx = cpu->apic_id;
+
+    level = find_first_bit(topo_bitmap, CPU_TOPO_LEVEL_MAX);
+    if (level == CPU_TOPO_LEVEL_MAX) {
+        num_cpus_next_level = 0;
+        offset_next_level = 0;
+
+        /* Encode CPU_TOPO_LEVEL_INVALID into the last subleaf of 0x1f. */
+        level = CPU_TOPO_LEVEL_INVALID;
+    } else {
+        next_level = find_next_bit(topo_bitmap, CPU_TOPO_LEVEL_MAX, level + 1);
+        if (next_level == CPU_TOPO_LEVEL_MAX) {
+            next_level = CPU_TOPO_LEVEL_PACKAGE;
+        }
+
+        num_cpus_next_level = num_cpus_by_topo_level(topo_info, next_level);
+        offset_next_level = apicid_offset_by_topo_level(topo_info, next_level);
+    }
+
+    *eax = offset_next_level;
+    *ebx = num_cpus_next_level;
+    *ecx |= cpuid1f_topo_type(level) << 8;
+
+    assert(!(*eax & ~0x1f));
+    *ebx &= 0xffff; /* The count doesn't need to be reliable. */
+    if (level != CPU_TOPO_LEVEL_MAX) {
+        clear_bit(level, topo_bitmap);
+    }
+}
+
 /* Encode cache info for CPUID[0x80000005].ECX or CPUID[0x80000005].EDX */
 static uint32_t encode_cache_cpuid80000005(CPUCacheInfo *cache)
 {
@@ -6283,31 +6393,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
             break;
         }
 
-        *ecx = count & 0xff;
-        *edx = cpu->apic_id;
-        switch (count) {
-        case 0:
-            *eax = apicid_core_offset(&topo_info);
-            *ebx = topo_info.threads_per_core;
-            *ecx |= CPUID_1F_ECX_TOPO_LEVEL_SMT << 8;
-            break;
-        case 1:
-            *eax = apicid_die_offset(&topo_info);
-            *ebx = topo_info.cores_per_die * topo_info.threads_per_core;
-            *ecx |= CPUID_1F_ECX_TOPO_LEVEL_CORE << 8;
-            break;
-        case 2:
-            *eax = apicid_pkg_offset(&topo_info);
-            *ebx = cpus_per_pkg;
-            *ecx |= CPUID_1F_ECX_TOPO_LEVEL_DIE << 8;
-            break;
-        default:
-            *eax = 0;
-            *ebx = 0;
-            *ecx |= CPUID_1F_ECX_TOPO_LEVEL_INVALID << 8;
-        }
-        assert(!(*eax & ~0x1f));
-        *ebx &= 0xffff; /* The count doesn't need to be reliable. */
+        encode_topo_cpuid1f(env, count, &topo_info, eax, ebx, ecx, edx);
         break;
     case 0xD: {
         /* Processor Extended State */
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 5aa0b8cf4137..a214d056ac4b 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -1008,6 +1008,21 @@ uint64_t x86_cpu_get_supported_feature_word(FeatureWord w,
 #define CPUID_MWAIT_IBE     (1U << 1) /* Interrupts can exit capability */
 #define CPUID_MWAIT_EMX     (1U << 0) /* enumeration supported */
 
+/*
+ * CPUTopoLevel is the general i386 topology hierarchical representation,
+ * ordered by increasing hierarchical relationship.
+ * Its enumeration value is not bound to the type value of Intel (CPUID[0x1F])
+ * or AMD (CPUID[0x80000026]).
+ */
+enum CPUTopoLevel {
+    CPU_TOPO_LEVEL_INVALID,
+    CPU_TOPO_LEVEL_SMT,
+    CPU_TOPO_LEVEL_CORE,
+    CPU_TOPO_LEVEL_DIE,
+    CPU_TOPO_LEVEL_PACKAGE,
+    CPU_TOPO_LEVEL_MAX,
+};
+
 /* CPUID[0xB].ECX level types */
 #define CPUID_B_ECX_TOPO_LEVEL_INVALID  0
 #define CPUID_B_ECX_TOPO_LEVEL_SMT      1
-- 
2.34.1


