Return-Path: <kvm+bounces-10055-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 66629868D40
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 11:20:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 837BA1C23017
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 10:20:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E6A21386AC;
	Tue, 27 Feb 2024 10:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SpCgt0sk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BC5E138490
	for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 10:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709029175; cv=none; b=se1tBbbADRJcIwnJxZcsARVmxCIK9xQUuzBM3Wi4QwwBWMuwoGHkvOlMqnDbUSFXYprejT1vXyx++Bhq0IL6Iedef1uhlvuFIOXQO0dUzKpFuVfiZruOZGMiuM5yYkWkbfCV94IFQScCNB6KiR1a/EAZ95f4PBlJEhM9sT2GAI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709029175; c=relaxed/simple;
	bh=PJPFMih2ppMXNU8hF0bfjALdTNkZHH3RQgQUk5bZa78=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q5f46xPmpKoj3t7J5auHRs2WhMeLzLlQbkVtBarxk8mA/kAXwNVeWOp74iQWL5jp6nRL02VjyjFkQzPvYjwfT8oUORcbsvgrSvndDg00tI++3Q386FU/Rd89CQHU6rJrQWO0XTpvh6PS7a/QAy1rpJx6HiedKX2bAyyyo8RIbJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SpCgt0sk; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709029174; x=1740565174;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PJPFMih2ppMXNU8hF0bfjALdTNkZHH3RQgQUk5bZa78=;
  b=SpCgt0skzQAI0ezBIE2aMeTuRlONw9Wn1Jt27pAyPaFWr1pqso++9yGJ
   lsQLWr8lJ/qYWzxC8+XFTk3MJt508IpXOPhWA2JX+9yGKz1eZXcfTuLAe
   UOh1f77e174DIE4vwnDCskw28zxaGYIltDj5cisUkecAXAh2QJyi3+lIx
   YDk5DzCWcJe/YQU9FNEK4E3z6tq5TMDtwm2L8vBfUqS5b7qBV8yaCP2J0
   FGLrxxLC7jJW0DtlSR6rX9yPnCrr9G6UOpTs2fhb+pq2IToGPttiB+RWr
   5zZh1DkV13VnOG8GqFEvhhQIfDptQvdT0SfOJkSupYsuMZ1YOLVCNUS34
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10996"; a="6310290"
X-IronPort-AV: E=Sophos;i="6.06,187,1705392000"; 
   d="scan'208";a="6310290"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2024 02:19:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,187,1705392000"; 
   d="scan'208";a="6954817"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa010.fm.intel.com with ESMTP; 27 Feb 2024 02:19:29 -0800
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
Subject: [PATCH v9 08/21] i386/cpu: Consolidate the use of topo_info in cpu_x86_cpuid()
Date: Tue, 27 Feb 2024 18:32:18 +0800
Message-Id: <20240227103231.1556302-9-zhao1.liu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240227103231.1556302-1-zhao1.liu@linux.intel.com>
References: <20240227103231.1556302-1-zhao1.liu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhao Liu <zhao1.liu@intel.com>

In cpu_x86_cpuid(), there are many variables in representing the cpu
topology, e.g., topo_info, cs->nr_cores and cs->nr_threads.

Since the names of cs->nr_cores/cs->nr_threads does not accurately
represent its meaning, the use of cs->nr_cores/cs->nr_threads is prone
to confusion and mistakes.

And the structure X86CPUTopoInfo names its members clearly, thus the
variable "topo_info" should be preferred.

In addition, in cpu_x86_cpuid(), to uniformly use the topology variable,
replace env->dies with topo_info.dies_per_pkg as well.

Suggested-by: Robert Hoo <robert.hu@linux.intel.com>
Tested-by: Yongwei Ma <yongwei.ma@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
Changes since v8:
 * Add Philippe's reviewed-by tag.

Changes since v7:
 * Renamed cpus_per_pkg to threads_per_pkg. (Xiaoyao)
 * Dropped Michael/Babu's Acked/Tested tags since the code change.
 * Re-added Yongwei's Tested tag For his re-testing.
 * Added Xiaoyao's Reviewed tag.

Changes since v3:
 * Fixed typo. (Babu)

Changes since v1:
 * Extracted cores_per_socket from the code block and use it as a local
   variable for cpu_x86_cpuid(). (Yanan)
 * Removed vcpus_per_socket variable and use cpus_per_pkg directly.
   (Yanan)
 * Replaced env->dies with topo_info.dies_per_pkg in cpu_x86_cpuid().
---
 target/i386/cpu.c | 31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index df56c7a449c8..d115fc7002ef 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -6017,11 +6017,16 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
     uint32_t limit;
     uint32_t signature[3];
     X86CPUTopoInfo topo_info;
+    uint32_t cores_per_pkg;
+    uint32_t threads_per_pkg;
 
     topo_info.dies_per_pkg = env->nr_dies;
     topo_info.cores_per_die = cs->nr_cores / env->nr_dies;
     topo_info.threads_per_core = cs->nr_threads;
 
+    cores_per_pkg = topo_info.cores_per_die * topo_info.dies_per_pkg;
+    threads_per_pkg = cores_per_pkg * topo_info.threads_per_core;
+
     /* Calculate & apply limits for different index ranges */
     if (index >= 0xC0000000) {
         limit = env->cpuid_xlevel2;
@@ -6057,8 +6062,8 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
             *ecx |= CPUID_EXT_OSXSAVE;
         }
         *edx = env->features[FEAT_1_EDX];
-        if (cs->nr_cores * cs->nr_threads > 1) {
-            *ebx |= (cs->nr_cores * cs->nr_threads) << 16;
+        if (threads_per_pkg > 1) {
+            *ebx |= threads_per_pkg << 16;
             *edx |= CPUID_HT;
         }
         if (!cpu->enable_pmu) {
@@ -6098,15 +6103,15 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
              */
             if (*eax & 31) {
                 int host_vcpus_per_cache = 1 + ((*eax & 0x3FFC000) >> 14);
-                int vcpus_per_socket = cs->nr_cores * cs->nr_threads;
-                if (cs->nr_cores > 1) {
+
+                if (cores_per_pkg > 1) {
                     addressable_cores_width = apicid_pkg_offset(&topo_info) -
                                               apicid_core_offset(&topo_info);
 
                     *eax &= ~0xFC000000;
                     *eax |= ((1 << addressable_cores_width) - 1) << 26;
                 }
-                if (host_vcpus_per_cache > vcpus_per_socket) {
+                if (host_vcpus_per_cache > threads_per_pkg) {
                     /* Share the cache at package level. */
                     addressable_threads_width = apicid_pkg_offset(&topo_info);
 
@@ -6252,12 +6257,12 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
         switch (count) {
         case 0:
             *eax = apicid_core_offset(&topo_info);
-            *ebx = cs->nr_threads;
+            *ebx = topo_info.threads_per_core;
             *ecx |= CPUID_TOPOLOGY_LEVEL_SMT;
             break;
         case 1:
             *eax = apicid_pkg_offset(&topo_info);
-            *ebx = cs->nr_cores * cs->nr_threads;
+            *ebx = threads_per_pkg;
             *ecx |= CPUID_TOPOLOGY_LEVEL_CORE;
             break;
         default:
@@ -6277,7 +6282,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
         break;
     case 0x1F:
         /* V2 Extended Topology Enumeration Leaf */
-        if (env->nr_dies < 2) {
+        if (topo_info.dies_per_pkg < 2) {
             *eax = *ebx = *ecx = *edx = 0;
             break;
         }
@@ -6287,7 +6292,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
         switch (count) {
         case 0:
             *eax = apicid_core_offset(&topo_info);
-            *ebx = cs->nr_threads;
+            *ebx = topo_info.threads_per_core;
             *ecx |= CPUID_TOPOLOGY_LEVEL_SMT;
             break;
         case 1:
@@ -6297,7 +6302,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
             break;
         case 2:
             *eax = apicid_pkg_offset(&topo_info);
-            *ebx = cs->nr_cores * cs->nr_threads;
+            *ebx = threads_per_pkg;
             *ecx |= CPUID_TOPOLOGY_LEVEL_DIE;
             break;
         default:
@@ -6525,7 +6530,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
          * discards multiple thread information if it is set.
          * So don't set it here for Intel to make Linux guests happy.
          */
-        if (cs->nr_cores * cs->nr_threads > 1) {
+        if (threads_per_pkg > 1) {
             if (env->cpuid_vendor1 != CPUID_VENDOR_INTEL_1 ||
                 env->cpuid_vendor2 != CPUID_VENDOR_INTEL_2 ||
                 env->cpuid_vendor3 != CPUID_VENDOR_INTEL_3) {
@@ -6591,7 +6596,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
              *eax |= (cpu_x86_virtual_addr_width(env) << 8);
         }
         *ebx = env->features[FEAT_8000_0008_EBX];
-        if (cs->nr_cores * cs->nr_threads > 1) {
+        if (threads_per_pkg > 1) {
             /*
              * Bits 15:12 is "The number of bits in the initial
              * Core::X86::Apic::ApicId[ApicId] value that indicate
@@ -6599,7 +6604,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
              * Bits 7:0 is "The number of threads in the package is NC+1"
              */
             *ecx = (apicid_pkg_offset(&topo_info) << 12) |
-                   ((cs->nr_cores * cs->nr_threads) - 1);
+                   (threads_per_pkg - 1);
         } else {
             *ecx = 0;
         }
-- 
2.34.1


