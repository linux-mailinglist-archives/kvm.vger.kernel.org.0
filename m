Return-Path: <kvm+bounces-12393-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E362885AB6
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 15:28:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C33521F228BC
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 14:28:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CF3D85958;
	Thu, 21 Mar 2024 14:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QmaWVN2R"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D445F85957
	for <kvm@vger.kernel.org>; Thu, 21 Mar 2024 14:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711031290; cv=none; b=Baj7Ax4yk1K9UR9ja/S/WpA2pUtBqn76fXlJwfOmz7U6+il7/l0vJ92lus4GyYsmMHEz+IvJGWyJu0EZ6HT0zM96GtClXhnRqVhr8EpJoGw/ZpI7b/a3m3JLHOFLH5dAwa3ja85bmMr+yu+FMJq/0hiSFDD0drtvdWOmQ431B2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711031290; c=relaxed/simple;
	bh=88GTBJkfUnxLcjA9TMVhLlZ8wNj+pl19Efm0ZPp/iFw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=POM8RUPfbiVYE1pjpONoIgvwncJXkGSfPPh1NEzImu3v2xjhNEKIsas7yAgzYhfA51KBYTPRLKrz2uFSQBxUn6SR5ep9H7nVXMhb4QUbC8r0+U2aKl9qE8YAAqKppNdr+upJXgK0TI2xQq1H7rUpeW1qZFaEb2D9xh0PS5oryys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QmaWVN2R; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711031289; x=1742567289;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=88GTBJkfUnxLcjA9TMVhLlZ8wNj+pl19Efm0ZPp/iFw=;
  b=QmaWVN2Rhb8KN5kXjhgzVLOj4WoNK4xu6HIkM84VHloyYFGFt1kjVDWj
   m5/QBLJ73G12f+c3c89baEBH/iiGtvhXFf+og+2/6Ha6L7KwWmdNpKIto
   NZVfrMm/tyaCMGQL+r3nN7LxLILh9o3MnYdeI43khh8v+mgz+jJ7erqjM
   HVo6XL3qiA9OmhfLZJ4p7CpJible2lYIxwTqELJbX0K9l9rKOE8zHluhk
   4ldXVr+5yUaYPTRUk5unpGNdPhV9pIN6OClmZ+ogiqkQAJH9owWH7PnrJ
   4T2vo6pBMorq/B+zYze6WFPEc6l8k/fKFZixDzI2xkHD7Pvzz7n2D80LX
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11020"; a="9806515"
X-IronPort-AV: E=Sophos;i="6.07,143,1708416000"; 
   d="scan'208";a="9806515"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2024 07:28:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,143,1708416000"; 
   d="scan'208";a="14528126"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orviesa009.jf.intel.com with ESMTP; 21 Mar 2024 07:28:02 -0700
From: Zhao Liu <zhao1.liu@linux.intel.com>
To: Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Zhuocheng Ding <zhuocheng.ding@intel.com>,
	Babu Moger <babu.moger@amd.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v10 11/21] i386/cpu: Decouple CPUID[0x1F] subleaf with specific topology level
Date: Thu, 21 Mar 2024 22:40:38 +0800
Message-Id: <20240321144048.3699388-12-zhao1.liu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240321144048.3699388-1-zhao1.liu@linux.intel.com>
References: <20240321144048.3699388-1-zhao1.liu@linux.intel.com>
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

Tested-by: Yongwei Ma <yongwei.ma@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
Tested-by: Babu Moger <babu.moger@amd.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
Changes since v10:
 * Combined ecx and edx encoding into the single line. (Xiaoyao)
 * Fixed the comment in encode_topo_cpuid1f(). (Xiaoyao)

Changes since v7:
 * Refactored the encode_topo_cpuid1f() to use traversal to search the
   encoded level and avoid using static variables. (Xiaoyao)
   - Since the total number of levels in the bitmap is not too large,
     the overhead of traversing is supposed to be acceptable.
 * Renamed the variable num_cpus_next_level to num_threads_next_level.
   (Xiaoyao)
 * Renamed the helper num_cpus_by_topo_level() to
   num_threads_by_topo_level(). (Xiaoyao)
 * Dropped Michael/Babu's Acked/Tested tags since the code change.
 * Re-added Yongwei's Tested tag For his re-testing.

Changes since v3:
 * New patch to prepare to expose module level in 0x1F.
 * Moved the CPUTopoLevel enumeration definition from "i386: Add cache
   topology info in CPUCacheInfo" to this patch. Note, to align with
   topology types in SDM, revert the name of CPU_TOPO_LEVEL_UNKNOW to
   CPU_TOPO_LEVEL_INVALID.
---
 target/i386/cpu.c | 135 +++++++++++++++++++++++++++++++++++++---------
 1 file changed, 110 insertions(+), 25 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index d030b45f9c3e..92d85e920015 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -269,6 +269,115 @@ static void encode_cache_cpuid4(CPUCacheInfo *cache,
            (cache->complex_indexing ? CACHE_COMPLEX_IDX : 0);
 }
 
+static uint32_t num_threads_by_topo_level(X86CPUTopoInfo *topo_info,
+                                          enum CPUTopoLevel topo_level)
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
+    X86CPU *cpu = env_archcpu(env);
+    unsigned long level, next_level;
+    uint32_t num_threads_next_level, offset_next_level;
+
+    assert(count + 1 < CPU_TOPO_LEVEL_MAX);
+
+    /*
+     * Find the No.(count + 1) topology level in avail_cpu_topo bitmap.
+     * The search starts from bit 1 (CPU_TOPO_LEVEL_INVALID + 1).
+     */
+    level = CPU_TOPO_LEVEL_INVALID;
+    for (int i = 0; i <= count; i++) {
+        level = find_next_bit(env->avail_cpu_topo,
+                              CPU_TOPO_LEVEL_PACKAGE,
+                              level + 1);
+
+        /*
+         * CPUID[0x1f] doesn't explicitly encode the package level,
+         * and it just encodes the invalid level (all fields are 0)
+         * into the last subleaf of 0x1f.
+         */
+        if (level == CPU_TOPO_LEVEL_PACKAGE) {
+            level = CPU_TOPO_LEVEL_INVALID;
+            break;
+        }
+    }
+
+    if (level == CPU_TOPO_LEVEL_INVALID) {
+        num_threads_next_level = 0;
+        offset_next_level = 0;
+    } else {
+        next_level = find_next_bit(env->avail_cpu_topo,
+                                   CPU_TOPO_LEVEL_PACKAGE,
+                                   level + 1);
+        num_threads_next_level = num_threads_by_topo_level(topo_info,
+                                                           next_level);
+        offset_next_level = apicid_offset_by_topo_level(topo_info,
+                                                        next_level);
+    }
+
+    *eax = offset_next_level;
+    /* The count (bits 15-00) doesn't need to be reliable. */
+    *ebx = num_threads_next_level & 0xffff;
+    *ecx = (count & 0xff) | (cpuid1f_topo_type(level) << 8);
+    *edx = cpu->apic_id;
+
+    assert(!(*eax & ~0x1f));
+}
+
 /* Encode cache info for CPUID[0x80000005].ECX or CPUID[0x80000005].EDX */
 static uint32_t encode_cache_cpuid80000005(CPUCacheInfo *cache)
 {
@@ -6295,31 +6404,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
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
-            *ebx = threads_per_pkg;
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
-- 
2.34.1


