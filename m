Return-Path: <kvm+bounces-10067-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 49A2E868D5C
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 11:21:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CD7571F22D0B
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 10:21:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E37161386B9;
	Tue, 27 Feb 2024 10:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d5nCteRq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F4591384B0
	for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 10:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709029234; cv=none; b=ub64vJnOI1HbQwE2f9s3sCrtiC65Q42cnr3yFVTIVjxPXT8QF9C9croCEyblu8RDRM3daxlxLzM7ZT6pMZwUzXMF2qAJl8i1gJ49VyIA9wSqTZZaI34AR5VLq2OhAvBNdeJXqjKYnOettUToAolrTvvpxYQszoc5UaVFCruRuKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709029234; c=relaxed/simple;
	bh=WKMpdedVITUQ6ZgjAWs6AFYbXSAJZv6us+WenYjObC8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iVWqEjzjvpn8RjWZRMswLsC/gbGo2BGRBvMPiaUHOg99x6o8UiNqKcktsWxTGv8w2XmM1b6z01ijZXc/V82+6RwFp740y7sv0xLvoHfe6Kk5yFGKG4KzzndJ8T/tFftZrYhGXiWekd9HlzcaKuGlKSlZWi0BsXuEc9K8SUy1TvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d5nCteRq; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709029232; x=1740565232;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WKMpdedVITUQ6ZgjAWs6AFYbXSAJZv6us+WenYjObC8=;
  b=d5nCteRqO1fxd3osuW+I+yTAACT7OnngxhKfjoXxGvNt414JMIM1jbja
   Gyzq8RFft2uDedxBQXar2yIWwZqeMxNSbxiNH3KGbo8nkfVy17ckZP9Yr
   MjtvmBzTuOlGGflqf50kEdvqupiXetpeiCVR68giG2nw/FAm+3xWynrIR
   Tk2x2+B6o/yEvQUt/kGJVOIsvcv3zIEiJcTZokz/ZgjkyiR6tN9NtchtL
   Xz5GmCCtgU09HDndexSENCIfRekPZDvjhDzBXjq88Yz9sIUKegQDFjNmQ
   CFv8MmOdpwBT4YOncRL6KZG18e+MZvRP9KZEPhP/RuAPU7skjmShUovTb
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10996"; a="6310485"
X-IronPort-AV: E=Sophos;i="6.06,187,1705392000"; 
   d="scan'208";a="6310485"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2024 02:20:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,187,1705392000"; 
   d="scan'208";a="6955254"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa010.fm.intel.com with ESMTP; 27 Feb 2024 02:20:27 -0800
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
Subject: [PATCH v9 20/21] i386/cpu: Use CPUCacheInfo.share_level to encode CPUID[4]
Date: Tue, 27 Feb 2024 18:32:30 +0800
Message-Id: <20240227103231.1556302-21-zhao1.liu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240227103231.1556302-1-zhao1.liu@linux.intel.com>
References: <20240227103231.1556302-1-zhao1.liu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhao Liu <zhao1.liu@intel.com>

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
 target/i386/cpu.c | 76 ++++++++++++++++++++++++++++-------------------
 1 file changed, 45 insertions(+), 31 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 3da2c5be9fa5..07cd729c3524 100644
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
@@ -6247,10 +6278,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
                (cpuid2_cache_descriptor(env->cache_info_cpuid2.l1i_cache) <<  8) |
                (cpuid2_cache_descriptor(env->cache_info_cpuid2.l2_cache));
         break;
-    case 4: {
-        int addressable_cores_width;
-        int addressable_threads_width;
-
+    case 4:
         /* cache info: needed for Core compatibility */
         if (cpu->cache_info_passthrough) {
             x86_cpu_get_cache_cpuid(index, count, eax, ebx, ecx, edx);
@@ -6262,55 +6290,42 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
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
@@ -6321,7 +6336,6 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
             }
         }
         break;
-    }
     case 5:
         /* MONITOR/MWAIT Leaf */
         *eax = cpu->mwait.eax; /* Smallest monitor-line size in bytes */
-- 
2.34.1


