Return-Path: <kvm+bounces-5776-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E1AB826924
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 09:15:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A1803281202
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 08:14:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C6CA9465;
	Mon,  8 Jan 2024 08:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Mhr0aPTy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6789BBE7F
	for <kvm@vger.kernel.org>; Mon,  8 Jan 2024 08:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704701685; x=1736237685;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0PRkR0FpsPB3QHwLY2CFH2jhu2vG5akH1tXowwEXiJQ=;
  b=Mhr0aPTyuCT5fFE2+Fql39hdGcVIdYMb2YsfLrYVUnGSHBrPy4Qwudn0
   sIIEEYc5kVOwZiwO782ymH5/rzpEAv0eKGtBEPQ8pqdB2agNH8hV3FQW/
   nP9BjxSbXxc2uum1HgXXr33eYTbsWwIIXW6JyuSylRRInk5apPAnQDZXB
   zLNOMjLa0VgejaJtj3Ym+Hd+OdQ1nPTLB08QAtVzZOsFnpYMyy+YIl5Fd
   Fey+eaBfeNWbg00hGnvGaDZpCoBWFj4c+KBpWwTffdtblZzc/ue4SbUBw
   N9dnUvjdTHBD7s5LaanL4QGevJLw2b93qVQecZsilOFnEzFl/Ybg6tTic
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10946"; a="16419926"
X-IronPort-AV: E=Sophos;i="6.04,340,1695711600"; 
   d="scan'208";a="16419926"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2024 00:14:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.04,340,1695711600"; 
   d="scan'208";a="15850158"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa002.fm.intel.com with ESMTP; 08 Jan 2024 00:14:40 -0800
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
	Robert Hoo <robert.hu@linux.intel.com>,
	Babu Moger <babu.moger@amd.com>,
	Yongwei Ma <yongwei.ma@intel.com>
Subject: [PATCH v7 02/16] i386/cpu: Use APIC ID offset to encode cache topo in CPUID[4]
Date: Mon,  8 Jan 2024 16:27:13 +0800
Message-Id: <20240108082727.420817-3-zhao1.liu@linux.intel.com>
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

Refer to the fixes of cache_info_passthrough ([1], [2]) and SDM, the
CPUID.04H:EAX[bits 25:14] and CPUID.04H:EAX[bits 31:26] should use the
nearest power-of-2 integer.

The nearest power-of-2 integer can be calculated by pow2ceil() or by
using APIC ID offset (like L3 topology using 1 << die_offset [3]).

But in fact, CPUID.04H:EAX[bits 25:14] and CPUID.04H:EAX[bits 31:26]
are associated with APIC ID. For example, in linux kernel, the field
"num_threads_sharing" (Bits 25 - 14) is parsed with APIC ID. And for
another example, on Alder Lake P, the CPUID.04H:EAX[bits 31:26] is not
matched with actual core numbers and it's calculated by:
"(1 << (pkg_offset - core_offset)) - 1".

Therefore the offset of APIC ID should be preferred to calculate nearest
power-of-2 integer for CPUID.04H:EAX[bits 25:14] and CPUID.04H:EAX[bits
31:26]:
1. d/i cache is shared in a core, 1 << core_offset should be used
   instand of "cs->nr_threads" in encode_cache_cpuid4() for
   CPUID.04H.00H:EAX[bits 25:14] and CPUID.04H.01H:EAX[bits 25:14].
2. L2 cache is supposed to be shared in a core as for now, thereby
   1 << core_offset should also be used instand of "cs->nr_threads" in
   encode_cache_cpuid4() for CPUID.04H.02H:EAX[bits 25:14].
3. Similarly, the value for CPUID.04H:EAX[bits 31:26] should also be
   calculated with the bit width between the Package and SMT levels in
   the APIC ID (1 << (pkg_offset - core_offset) - 1).

In addition, use APIC ID offset to replace "pow2ceil()" for
cache_info_passthrough case.

[1]: efb3934adf9e ("x86: cpu: make sure number of addressable IDs for processor cores meets the spec")
[2]: d7caf13b5fcf ("x86: cpu: fixup number of addressable IDs for logical processors sharing cache")
[3]: d65af288a84d ("i386: Update new x86_apicid parsing rules with die_offset support")

Fixes: 7e3482f82480 ("i386: Helpers to encode cache information consistently")
Suggested-by: Robert Hoo <robert.hu@linux.intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
Tested-by: Babu Moger <babu.moger@amd.com>
Tested-by: Yongwei Ma <yongwei.ma@intel.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
---
Changes since v3:
 * Fix compile warnings. (Babu)
 * Fix spelling typo.

Changes since v1:
 * Use APIC ID offset to replace "pow2ceil()" for cache_info_passthrough
   case. (Yanan)
 * Split the L1 cache fix into a separate patch.
 * Rename the title of this patch (the original is "i386/cpu: Fix number
   of addressable IDs in CPUID.04H").
---
 target/i386/cpu.c | 30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 5a3678a789cf..c8d2a585723a 100644
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
@@ -6098,39 +6097,56 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
                 int host_vcpus_per_cache = 1 + ((*eax & 0x3FFC000) >> 14);
                 int vcpus_per_socket = cs->nr_cores * cs->nr_threads;
                 if (cs->nr_cores > 1) {
+                    int addressable_cores_offset =
+                                                apicid_pkg_offset(&topo_info) -
+                                                apicid_core_offset(&topo_info);
+
                     *eax &= ~0xFC000000;
-                    *eax |= (pow2ceil(cs->nr_cores) - 1) << 26;
+                    *eax |= (1 << (addressable_cores_offset - 1)) << 26;
                 }
                 if (host_vcpus_per_cache > vcpus_per_socket) {
+                    int pkg_offset = apicid_pkg_offset(&topo_info);
+
                     *eax &= ~0x3FFC000;
-                    *eax |= (pow2ceil(vcpus_per_socket) - 1) << 14;
+                    *eax |= (1 << (pkg_offset - 1)) << 14;
                 }
             }
         } else if (cpu->vendor_cpuid_only && IS_AMD_CPU(env)) {
             *eax = *ebx = *ecx = *edx = 0;
         } else {
             *eax = 0;
+            int addressable_cores_offset = apicid_pkg_offset(&topo_info) -
+                                           apicid_core_offset(&topo_info);
+            int core_offset, die_offset;
+
             switch (count) {
             case 0: /* L1 dcache info */
+                core_offset = apicid_core_offset(&topo_info);
                 encode_cache_cpuid4(env->cache_info_cpuid4.l1d_cache,
-                                    cs->nr_threads, cs->nr_cores,
+                                    (1 << core_offset),
+                                    (1 << addressable_cores_offset),
                                     eax, ebx, ecx, edx);
                 break;
             case 1: /* L1 icache info */
+                core_offset = apicid_core_offset(&topo_info);
                 encode_cache_cpuid4(env->cache_info_cpuid4.l1i_cache,
-                                    cs->nr_threads, cs->nr_cores,
+                                    (1 << core_offset),
+                                    (1 << addressable_cores_offset),
                                     eax, ebx, ecx, edx);
                 break;
             case 2: /* L2 cache info */
+                core_offset = apicid_core_offset(&topo_info);
                 encode_cache_cpuid4(env->cache_info_cpuid4.l2_cache,
-                                    cs->nr_threads, cs->nr_cores,
+                                    (1 << core_offset),
+                                    (1 << addressable_cores_offset),
                                     eax, ebx, ecx, edx);
                 break;
             case 3: /* L3 cache info */
                 die_offset = apicid_die_offset(&topo_info);
                 if (cpu->enable_l3_cache) {
                     encode_cache_cpuid4(env->cache_info_cpuid4.l3_cache,
-                                        (1 << die_offset), cs->nr_cores,
+                                        (1 << die_offset),
+                                        (1 << addressable_cores_offset),
                                         eax, ebx, ecx, edx);
                     break;
                 }
-- 
2.34.1


