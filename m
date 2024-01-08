Return-Path: <kvm+bounces-5779-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C00982692B
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 09:15:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 211DA1C21A6F
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 08:15:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55CB9F516;
	Mon,  8 Jan 2024 08:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L5U2TaNU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC192D272
	for <kvm@vger.kernel.org>; Mon,  8 Jan 2024 08:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704701695; x=1736237695;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Dv5uF8oI3xXIr2BKKd5zjxlrO3w0NklRgOEwjc4LbFk=;
  b=L5U2TaNUDT/jwhJxcH7zsF8fdaOo8mH2i1NV/2Yp8VST6ZJPBlQCGvEn
   UxGGen/LAurSpRVNtToqJzFVC9GgkvZaA4zS/LdAMw0cJyYIwDAhe8xbX
   wq9jAMr/rENiX7L9cH2eMoNg0H/GjyVds6ezH6weGyIhMWe18gA1wPhQz
   rXKSDHMkXe3+kJpr0+aGhZO6a0yO3FATD53r36cm9+H6bp2D8Ky3bkg/s
   T9XWDgQsOqTZddCsFH2SRZ67qMAu9a0Dsf3UC/tHghd2Qt7s0o0vaWcYv
   LJMI/U3MWBpbJeoNAj0QcRdpO1CCa8zPs2JdIWlmgFe9cqX+/va9kn5SK
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10946"; a="16419959"
X-IronPort-AV: E=Sophos;i="6.04,340,1695711600"; 
   d="scan'208";a="16419959"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2024 00:14:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.04,340,1695711600"; 
   d="scan'208";a="15850179"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa002.fm.intel.com with ESMTP; 08 Jan 2024 00:14:51 -0800
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
	Zhao Liu <zhao1.liu@intel.com>,
	Babu Moger <babu.moger@amd.com>,
	Yongwei Ma <yongwei.ma@intel.com>
Subject: [PATCH v7 05/16] i386: Decouple CPUID[0x1F] subleaf with specific topology level
Date: Mon,  8 Jan 2024 16:27:16 +0800
Message-Id: <20240108082727.420817-6-zhao1.liu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240108082727.420817-1-zhao1.liu@linux.intel.com>
References: <20240108082727.420817-1-zhao1.liu@linux.intel.com>
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
index bc440477d13d..5c295c9a9e2d 100644
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
@@ -6284,31 +6394,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
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
index f47bad46db5e..9c78cfc3f322 100644
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


