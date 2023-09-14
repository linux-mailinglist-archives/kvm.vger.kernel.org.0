Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B3CD79FCE4
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 09:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235975AbjINHML (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 03:12:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235967AbjINHMJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 03:12:09 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 047AFCE5
        for <kvm@vger.kernel.org>; Thu, 14 Sep 2023 00:12:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694675525; x=1726211525;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Xno1vyATQqP9rdWhZNRXyrNgrdBTdr9nYXTq1BkfdI0=;
  b=KBIX8IM8CIP6mjQ9KEwug6FpbZPW1ldmOAq/y66hIpCmt+5lowZm2LSn
   8QXJd1srZTTMX7oJqdLnvKmOH+KynkobfQXfZoFD8EcJk+jCVc/uZ6XiB
   4jb+yRoE5YbIRwDgynw669m8r1YhMfMtEGFZAJtLiwAR12tibhKtKY1m6
   UPbVpSy7UDrO+mxvT2lW37jrC7GKJD/USE14zbqikPJh0+s6+uTbVs/N+
   XqP0HXN9yJ8YW+i40yo6rKHsj9yRntzKLUnZKmVpLkKarp87N2PK2ZNe9
   Kd82nQNmdef30FhuQNOz7lyLZWtQV06GPMLv0wy4tOEGNL5+AootI/VXU
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="359136226"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="359136226"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2023 00:11:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="779526507"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="779526507"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orsmga001.jf.intel.com with ESMTP; 14 Sep 2023 00:11:49 -0700
From:   Zhao Liu <zhao1.liu@linux.intel.com>
To:     Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Yanan Wang <wangyanan55@huawei.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Zhenyu Wang <zhenyu.z.wang@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Babu Moger <babu.moger@amd.com>, Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v4 09/21] i386: Decouple CPUID[0x1F] subleaf with specific topology level
Date:   Thu, 14 Sep 2023 15:21:47 +0800
Message-Id: <20230914072159.1177582-10-zhao1.liu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230914072159.1177582-1-zhao1.liu@linux.intel.com>
References: <20230914072159.1177582-1-zhao1.liu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Zhao Liu <zhao1.liu@intel.com>

At present, the subleaf 0x02 of CPUID[0x1F] is bound to the "die" level.

In fact, the specific topology level exposed in 0x1F depends on the
platform's support for extension levels (module, tile and die).

To help expose "module" level in 0x1F, decouple CPUID[0x1F] subleaf
with specific topology level.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
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
index 88ccc9df9118..10e11c85f459 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -268,6 +268,116 @@ static void encode_cache_cpuid4(CPUCacheInfo *cache,
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
@@ -6280,31 +6390,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
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
index 97113ad3d002..470257b92240 100644
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

