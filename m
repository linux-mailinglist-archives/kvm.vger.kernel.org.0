Return-Path: <kvm+bounces-15838-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FF5B8B0EB2
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 17:39:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 92FF71C2096D
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 15:39:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16D701635D5;
	Wed, 24 Apr 2024 15:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HggmOrHh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCB0D16D303
	for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 15:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713973056; cv=none; b=dNoZ3gtjv7Ke4hraz5aFH22NgV+dAbp6i+jE5iA88RuskfHwh9OiC401sQmgO2yB93JVy6HVAUUafeD2Ev9M7x2OWnZMXEzt0CUlCWqCcAGK8FLP2rs7ciM+CKfkD1kofysUiQIqhpoH6juEeAmEYpUEFdVrdlfev+pRnxsVV04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713973056; c=relaxed/simple;
	bh=ZkHm8sHmT2nd71AUS8oMG6ZDKxb9Z/aNv/02wnecRJQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Yp3mLbIkBTPmP1T1CimHtIIbzwiWj8scDTrrSdVRNB69G8jTpHARhO082DQoBcJ/SqRAE732z8hm/IuFBh27LtF2BpT1WeYnYPV3c0++enFRQbAmB9HX43mfypbkCNbBO/jFtA8gYGXHVVtUBvK6Wb2kEbu1eXvjVwZ/CEfK894=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HggmOrHh; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713973055; x=1745509055;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZkHm8sHmT2nd71AUS8oMG6ZDKxb9Z/aNv/02wnecRJQ=;
  b=HggmOrHhTLKFa9qjxZdCj687WdMDXpZNsjZFvmUuj+N5I35hbxxn7lk8
   +4NOfSUvJo3lv3RkFLgpvRgXiQN7ScnG68oab2KW6dsYvqezcQOzsEkSY
   mhZKPC5QMeMFtvkJLPoFg9pY/AmIqlkpLo+VVt9bEtOxJep0r0kjUKsuT
   0/jeE7Ar5/JbQLMRsWM+7q1wTb3LxTwv3hzStDpEGavZY0YN8z8AiFrd0
   rRFrWbBzmtEZLxvEGVj1QCAZ4V6YCpfoH0JI9DK/wk3hQOJDW8TRrFEJ+
   nBU/hFfFbdGuFBwdfpY4WzNKF30g3KXO/i0gJSu4mneePZJp/AQmSSjLa
   g==;
X-CSE-ConnectionGUID: o74OA4eDSOyihALvBxdUsQ==
X-CSE-MsgGUID: yQLNgkHTRnqYMa2TLcWIjw==
X-IronPort-AV: E=McAfee;i="6600,9927,11054"; a="12545847"
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="12545847"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 08:37:34 -0700
X-CSE-ConnectionGUID: mVIqcb4wTMmzyalIZjUB8A==
X-CSE-MsgGUID: GkT58anERGqMqRuZpf4JTg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="25363350"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orviesa008.jf.intel.com with ESMTP; 24 Apr 2024 08:37:30 -0700
From: Zhao Liu <zhao1.liu@intel.com>
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
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Zhuocheng Ding <zhuocheng.ding@intel.com>,
	Babu Moger <babu.moger@amd.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v11 20/21] i386/cpu: Use CPUCacheInfo.share_level to encode CPUID[4]
Date: Wed, 24 Apr 2024 23:49:28 +0800
Message-Id: <20240424154929.1487382-21-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240424154929.1487382-1-zhao1.liu@intel.com>
References: <20240424154929.1487382-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

CPUID[4].EAX[bits 25:14] is used to represent the cache topology for
Intel CPUs.

After cache models have topology information, we can use
CPUCacheInfo.share_level to decide which topology level to be encoded
into CPUID[4].EAX[bits 25:14].

And since with the helper max_processor_ids_for_cache(), the filed
CPUID[4].EAX[bits 25:14] (original virable "num_apic_ids") is parsed
based on cpu topology levels, which are verified when parsing -smp, it's
no need to check this value by "assert(num_apic_ids > 0)" again, so
remove this assert().

Additionally, wrap the encoding of CPUID[4].EAX[bits 31:26] into a
helper to make the code cleaner.

Tested-by: Yongwei Ma <yongwei.ma@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
Tested-by: Babu Moger <babu.moger@amd.com>
---
Changes since v7:
 * Renamed max_processor_ids_for_cache() to max_thread_ids_for_cache().
   (Xiaoyao)
 * Dropped Michael/Babu's ACKed/Tested tags since the code change.
 * Re-added Yongwei's Tested tag For his re-testing.

Changes since v1:
 * Used "enum CPUTopoLevel share_level" as the parameter in
   max_processor_ids_for_cache().
 * Made cache_into_passthrough case also use
   max_processor_ids_for_cache() and max_core_ids_in_package() to
   encode CPUID[4]. (Yanan)
 * Renamed the title of this patch (the original is "i386: Use
   CPUCacheInfo.share_level to encode CPUID[4].EAX[bits 25:14]").
---
 target/i386/cpu.c | 84 +++++++++++++++++++++++++----------------------
 1 file changed, 45 insertions(+), 39 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 5ba44c57666d..6ab517a59aee 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -235,22 +235,53 @@ static uint8_t cpuid2_cache_descriptor(CPUCacheInfo *cache)
                        ((t) == UNIFIED_CACHE) ? CACHE_TYPE_UNIFIED : \
                        0 /* Invalid value */)
 
+static uint32_t max_thread_ids_for_cache(X86CPUTopoInfo *topo_info,
+                                         enum CPUTopoLevel share_level)
+{
+    uint32_t num_ids = 0;
+
+    switch (share_level) {
+    case CPU_TOPO_LEVEL_CORE:
+        num_ids = 1 << apicid_core_offset(topo_info);
+        break;
+    case CPU_TOPO_LEVEL_DIE:
+        num_ids = 1 << apicid_die_offset(topo_info);
+        break;
+    case CPU_TOPO_LEVEL_PACKAGE:
+        num_ids = 1 << apicid_pkg_offset(topo_info);
+        break;
+    default:
+        /*
+         * Currently there is no use case for SMT and MODULE, so use
+         * assert directly to facilitate debugging.
+         */
+        g_assert_not_reached();
+    }
+
+    return num_ids - 1;
+}
+
+static uint32_t max_core_ids_in_package(X86CPUTopoInfo *topo_info)
+{
+    uint32_t num_cores = 1 << (apicid_pkg_offset(topo_info) -
+                               apicid_core_offset(topo_info));
+    return num_cores - 1;
+}
 
 /* Encode cache info for CPUID[4] */
 static void encode_cache_cpuid4(CPUCacheInfo *cache,
-                                int num_apic_ids, int num_cores,
+                                X86CPUTopoInfo *topo_info,
                                 uint32_t *eax, uint32_t *ebx,
                                 uint32_t *ecx, uint32_t *edx)
 {
     assert(cache->size == cache->line_size * cache->associativity *
                           cache->partitions * cache->sets);
 
-    assert(num_apic_ids > 0);
     *eax = CACHE_TYPE(cache->type) |
            CACHE_LEVEL(cache->level) |
            (cache->self_init ? CACHE_SELF_INIT_LEVEL : 0) |
-           ((num_cores - 1) << 26) |
-           ((num_apic_ids - 1) << 14);
+           (max_core_ids_in_package(topo_info) << 26) |
+           (max_thread_ids_for_cache(topo_info, cache->share_level) << 14);
 
     assert(cache->line_size > 0);
     assert(cache->partitions > 0);
@@ -6380,18 +6411,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
                (cpuid2_cache_descriptor(env->cache_info_cpuid2.l1i_cache) <<  8) |
                (cpuid2_cache_descriptor(env->cache_info_cpuid2.l2_cache));
         break;
-    case 4: {
-        /*
-         * CPUID.04H:EAX[bits 25:14]: Maximum number of addressable IDs for
-         * logical processors sharing this cache.
-         */
-        int addressable_threads_width;
-        /*
-         * CPUID.04H:EAX[bits 31:26]: Maximum number of addressable IDs for
-         * processor cores in the physical package.
-         */
-        int addressable_cores_width;
-
+    case 4:
         /* cache info: needed for Core compatibility */
         if (cpu->cache_info_passthrough) {
             x86_cpu_get_cache_cpuid(index, count, eax, ebx, ecx, edx);
@@ -6403,55 +6423,42 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
                 int host_vcpus_per_cache = 1 + ((*eax & 0x3FFC000) >> 14);
 
                 if (cores_per_pkg > 1) {
-                    addressable_cores_width = apicid_pkg_offset(&topo_info) -
-                                              apicid_core_offset(&topo_info);
-
                     *eax &= ~0xFC000000;
-                    *eax |= ((1 << addressable_cores_width) - 1) << 26;
+                    *eax |= max_core_ids_in_package(&topo_info) << 26;
                 }
                 if (host_vcpus_per_cache > threads_per_pkg) {
-                    /* Share the cache at package level. */
-                    addressable_threads_width = apicid_pkg_offset(&topo_info);
-
                     *eax &= ~0x3FFC000;
-                    *eax |= ((1 << addressable_threads_width) - 1) << 14;
+
+                    /* Share the cache at package level. */
+                    *eax |= max_thread_ids_for_cache(&topo_info,
+                                CPU_TOPO_LEVEL_PACKAGE) << 14;
                 }
             }
         } else if (cpu->vendor_cpuid_only && IS_AMD_CPU(env)) {
             *eax = *ebx = *ecx = *edx = 0;
         } else {
             *eax = 0;
-            addressable_cores_width = apicid_pkg_offset(&topo_info) -
-                                      apicid_core_offset(&topo_info);
 
             switch (count) {
             case 0: /* L1 dcache info */
-                addressable_threads_width = apicid_core_offset(&topo_info);
                 encode_cache_cpuid4(env->cache_info_cpuid4.l1d_cache,
-                                    (1 << addressable_threads_width),
-                                    (1 << addressable_cores_width),
+                                    &topo_info,
                                     eax, ebx, ecx, edx);
                 break;
             case 1: /* L1 icache info */
-                addressable_threads_width = apicid_core_offset(&topo_info);
                 encode_cache_cpuid4(env->cache_info_cpuid4.l1i_cache,
-                                    (1 << addressable_threads_width),
-                                    (1 << addressable_cores_width),
+                                    &topo_info,
                                     eax, ebx, ecx, edx);
                 break;
             case 2: /* L2 cache info */
-                addressable_threads_width = apicid_core_offset(&topo_info);
                 encode_cache_cpuid4(env->cache_info_cpuid4.l2_cache,
-                                    (1 << addressable_threads_width),
-                                    (1 << addressable_cores_width),
+                                    &topo_info,
                                     eax, ebx, ecx, edx);
                 break;
             case 3: /* L3 cache info */
                 if (cpu->enable_l3_cache) {
-                    addressable_threads_width = apicid_die_offset(&topo_info);
                     encode_cache_cpuid4(env->cache_info_cpuid4.l3_cache,
-                                        (1 << addressable_threads_width),
-                                        (1 << addressable_cores_width),
+                                        &topo_info,
                                         eax, ebx, ecx, edx);
                     break;
                 }
@@ -6462,7 +6469,6 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
             }
         }
         break;
-    }
     case 5:
         /* MONITOR/MWAIT Leaf */
         *eax = cpu->mwait.eax; /* Smallest monitor-line size in bytes */
-- 
2.34.1


