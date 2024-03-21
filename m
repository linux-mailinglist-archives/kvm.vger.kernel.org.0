Return-Path: <kvm+bounces-12388-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A0B2885AAB
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 15:28:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B4CFF28406E
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 14:28:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FA1B85C69;
	Thu, 21 Mar 2024 14:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LsT1NxQG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 628682CCA3
	for <kvm@vger.kernel.org>; Thu, 21 Mar 2024 14:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711031264; cv=none; b=ji598CHR4Z9KB1WvTXRaDz6kBci/ug2W6rmPdZWaW9PaLosHfJj5ly+W0KFJxQd056SjiOghSp1FPCBIKtip1A32diRjAlX80HtrLc22s3+kSkRx0VvW6e/Yyjvql1lffGHtwr+Eyahuo6pUo3XYfLjyD6o5B34/Rq5skO8pRyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711031264; c=relaxed/simple;
	bh=59Ymzh8hY0elBFp2wTCAzcbs6odwFA8/GIFX/nTx+co=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qfza4wFp7PZYkJpdTnAuLIa8W6shYky3O0sPEUmp2PkKitJd9K4ODv8pX7B1B3A5S9yXGJr9dkYUx1dsKv5OUCERtsJD1HyRrd6cojKHUIHLsd3K15Xoc/MF5f/+3Z50MN46a6iznIVTAlCObLtt5lzNM5YudqoB9KMiruGHJPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LsT1NxQG; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711031263; x=1742567263;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=59Ymzh8hY0elBFp2wTCAzcbs6odwFA8/GIFX/nTx+co=;
  b=LsT1NxQGadOmlmrOzdnxJAUc4qDeJWph2KO9DLhFD/Dz8/jmNAG8nuHn
   Aik/Ci+QEG1Myjm5B1/voKI+1cz+zsSLtYoSmqIptiFv2GWm5EUehhJgk
   ZBzQGtMpe8gFbqm+f5JbavGQLVFz6nM6/cC3YNXSVDZMiV0xnJ4nC64ZP
   WRY9VulSJhla/UY45jw9kJj/9cmKQjZ7RX7GXsTPEDGIq2HIY+UlVpsiZ
   hTGnBgYqb3ci1JYhl+fUxiNVgXqrJaUBw1mdcFDMhqm0w3VrLHVnAoYrz
   /97sahw3yfZeeUCueKLbdKRiPDk1i4Z3i3YxmYcDoNrlNGCrZJwAic0Y4
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11020"; a="9806440"
X-IronPort-AV: E=Sophos;i="6.07,143,1708416000"; 
   d="scan'208";a="9806440"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2024 07:27:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,143,1708416000"; 
   d="scan'208";a="14527902"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orviesa009.jf.intel.com with ESMTP; 21 Mar 2024 07:27:37 -0700
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
	Zhao Liu <zhao1.liu@intel.com>,
	Robert Hoo <robert.hu@linux.intel.com>
Subject: [PATCH v10 06/21] i386/cpu: Use APIC ID info to encode cache topo in CPUID[4]
Date: Thu, 21 Mar 2024 22:40:33 +0800
Message-Id: <20240321144048.3699388-7-zhao1.liu@linux.intel.com>
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

Refer to the fixes of cache_info_passthrough ([1], [2]) and SDM, the
CPUID.04H:EAX[bits 25:14] and CPUID.04H:EAX[bits 31:26] should use the
nearest power-of-2 integer.

The nearest power-of-2 integer can be calculated by pow2ceil() or by
using APIC ID offset/width (like L3 topology using 1 << die_offset [3]).

But in fact, CPUID.04H:EAX[bits 25:14] and CPUID.04H:EAX[bits 31:26]
are associated with APIC ID. For example, in linux kernel, the field
"num_threads_sharing" (Bits 25 - 14) is parsed with APIC ID. And for
another example, on Alder Lake P, the CPUID.04H:EAX[bits 31:26] is not
matched with actual core numbers and it's calculated by:
"(1 << (pkg_offset - core_offset)) - 1".

Therefore the topology information of APIC ID should be preferred to
calculate nearest power-of-2 integer for CPUID.04H:EAX[bits 25:14] and
CPUID.04H:EAX[bits 31:26]:
1. d/i cache is shared in a core, 1 << core_offset should be used
   instead of "cs->nr_threads" in encode_cache_cpuid4() for
   CPUID.04H.00H:EAX[bits 25:14] and CPUID.04H.01H:EAX[bits 25:14].
2. L2 cache is supposed to be shared in a core as for now, thereby
   1 << core_offset should also be used instead of "cs->nr_threads" in
   encode_cache_cpuid4() for CPUID.04H.02H:EAX[bits 25:14].
3. Similarly, the value for CPUID.04H:EAX[bits 31:26] should also be
   calculated with the bit width between the package and SMT levels in
   the APIC ID (1 << (pkg_offset - core_offset) - 1).

In addition, use APIC ID bits calculations to replace "pow2ceil()" for
cache_info_passthrough case.

[1]: efb3934adf9e ("x86: cpu: make sure number of addressable IDs for processor cores meets the spec")
[2]: d7caf13b5fcf ("x86: cpu: fixup number of addressable IDs for logical processors sharing cache")
[3]: d65af288a84d ("i386: Update new x86_apicid parsing rules with die_offset support")

Fixes: 7e3482f82480 ("i386: Helpers to encode cache information consistently")
Suggested-by: Robert Hoo <robert.hu@linux.intel.com>
Tested-by: Yongwei Ma <yongwei.ma@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
Tested-by: Babu Moger <babu.moger@amd.com>
---
Changes since v9:
 * Added comments on addressable_threads_width and
   addressable_cores_width. (Xiaoyao)

Changes since v7:
 * Fixed calculations in cache_info_passthrough case. (Xiaoyao)
 * Renamed variables as *_width. (Xiaoyao)
 * Unified variable names for encoding cache_info_passthrough case and
   non-cache_info_passthrough case as addressable_cores_width and
   addressable_threads_width.
 * Fixed typos in commit message. (Xiaoyao)
 * Dropped Michael/Babu's ACKed/Tested tags since the code change.
 * Re-added Yongwei's Tested tag For his re-testing.

Changes since v3:
 * Fixed compile warnings. (Babu)
 * Fixed spelling typo.

Changes since v1:
 * Used APIC ID offset to replace "pow2ceil()" for cache_info_passthrough
   case. (Yanan)
 * Split the L1 cache fix into a separate patch.
 * Renamed the title of this patch (the original is "i386/cpu: Fix number
   of addressable IDs in CPUID.04H").
---
 target/i386/cpu.c | 45 ++++++++++++++++++++++++++++++++++++---------
 1 file changed, 36 insertions(+), 9 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index eedc2c5ea6e0..0ebacacf2aad 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -6014,7 +6014,6 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
 {
     X86CPU *cpu = env_archcpu(env);
     CPUState *cs = env_cpu(env);
-    uint32_t die_offset;
     uint32_t limit;
     uint32_t signature[3];
     X86CPUTopoInfo topo_info;
@@ -6086,7 +6085,18 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
                (cpuid2_cache_descriptor(env->cache_info_cpuid2.l1i_cache) <<  8) |
                (cpuid2_cache_descriptor(env->cache_info_cpuid2.l2_cache));
         break;
-    case 4:
+    case 4: {
+        /*
+         * CPUID.04H:EAX[bits 25:14]: Maximum number of addressable IDs for
+         * logical processors sharing this cache.
+         */
+        int addressable_threads_width;
+        /*
+         * CPUID.04H:EAX[bits 31:26]: Maximum number of addressable IDs for
+         * processor cores in the physical package.
+         */
+        int addressable_cores_width;
+
         /* cache info: needed for Core compatibility */
         if (cpu->cache_info_passthrough) {
             x86_cpu_get_cache_cpuid(index, count, eax, ebx, ecx, edx);
@@ -6098,39 +6108,55 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
                 int host_vcpus_per_cache = 1 + ((*eax & 0x3FFC000) >> 14);
                 int vcpus_per_socket = cs->nr_cores * cs->nr_threads;
                 if (cs->nr_cores > 1) {
+                    addressable_cores_width = apicid_pkg_offset(&topo_info) -
+                                              apicid_core_offset(&topo_info);
+
                     *eax &= ~0xFC000000;
-                    *eax |= (pow2ceil(cs->nr_cores) - 1) << 26;
+                    *eax |= ((1 << addressable_cores_width) - 1) << 26;
                 }
                 if (host_vcpus_per_cache > vcpus_per_socket) {
+                    /* Share the cache at package level. */
+                    addressable_threads_width = apicid_pkg_offset(&topo_info);
+
                     *eax &= ~0x3FFC000;
-                    *eax |= (pow2ceil(vcpus_per_socket) - 1) << 14;
+                    *eax |= ((1 << addressable_threads_width) - 1) << 14;
                 }
             }
         } else if (cpu->vendor_cpuid_only && IS_AMD_CPU(env)) {
             *eax = *ebx = *ecx = *edx = 0;
         } else {
             *eax = 0;
+            addressable_cores_width = apicid_pkg_offset(&topo_info) -
+                                      apicid_core_offset(&topo_info);
+
             switch (count) {
             case 0: /* L1 dcache info */
+                addressable_threads_width = apicid_core_offset(&topo_info);
                 encode_cache_cpuid4(env->cache_info_cpuid4.l1d_cache,
-                                    cs->nr_threads, cs->nr_cores,
+                                    (1 << addressable_threads_width),
+                                    (1 << addressable_cores_width),
                                     eax, ebx, ecx, edx);
                 break;
             case 1: /* L1 icache info */
+                addressable_threads_width = apicid_core_offset(&topo_info);
                 encode_cache_cpuid4(env->cache_info_cpuid4.l1i_cache,
-                                    cs->nr_threads, cs->nr_cores,
+                                    (1 << addressable_threads_width),
+                                    (1 << addressable_cores_width),
                                     eax, ebx, ecx, edx);
                 break;
             case 2: /* L2 cache info */
+                addressable_threads_width = apicid_core_offset(&topo_info);
                 encode_cache_cpuid4(env->cache_info_cpuid4.l2_cache,
-                                    cs->nr_threads, cs->nr_cores,
+                                    (1 << addressable_threads_width),
+                                    (1 << addressable_cores_width),
                                     eax, ebx, ecx, edx);
                 break;
             case 3: /* L3 cache info */
-                die_offset = apicid_die_offset(&topo_info);
                 if (cpu->enable_l3_cache) {
+                    addressable_threads_width = apicid_die_offset(&topo_info);
                     encode_cache_cpuid4(env->cache_info_cpuid4.l3_cache,
-                                        (1 << die_offset), cs->nr_cores,
+                                        (1 << addressable_threads_width),
+                                        (1 << addressable_cores_width),
                                         eax, ebx, ecx, edx);
                     break;
                 }
@@ -6141,6 +6167,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
             }
         }
         break;
+    }
     case 5:
         /* MONITOR/MWAIT Leaf */
         *eax = cpu->mwait.eax; /* Smallest monitor-line size in bytes */
-- 
2.34.1


