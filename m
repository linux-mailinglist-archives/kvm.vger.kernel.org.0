Return-Path: <kvm+bounces-12390-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D714B885AAD
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 15:28:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3CD701F22877
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 14:28:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09FD38592F;
	Thu, 21 Mar 2024 14:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OJYDfmOD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D6E585278
	for <kvm@vger.kernel.org>; Thu, 21 Mar 2024 14:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711031274; cv=none; b=C1HKaltwKFP85oyo0nQz2bmakQFNUJYJC64LchyXayxGHgJminR5/GZRHu9cVLKhTIsbZ23Nq3u6W7ISZf+v6O5MZQd84vHmcJC0ahrigPw8hmwAQC7DHxUPxu1utO/sMzeMQTRN2KE7mtq5R0z0hyCA/VLAbQOPr5dXEjbHkGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711031274; c=relaxed/simple;
	bh=kSakjQlsAzRYW8sQ/3mEOr16V95LD9ru+bcIX0cebwE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NDEpuLHwTS6/YpOFux2Sb9QOuFDp2Z81vqterdc+wi4+5YKUQYWfViv6RLuZnz3KFUpMKblnpIYUx8cs4tQ6wmEkSTDK1aLUa3CMUm/o07UdlAhvOyfqp0aAhujLzTeU3UI2MdF6x4/Jo5JbzDAJnLyHQvVImSKc8plxMC4yYYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OJYDfmOD; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711031273; x=1742567273;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kSakjQlsAzRYW8sQ/3mEOr16V95LD9ru+bcIX0cebwE=;
  b=OJYDfmOD+weZuMdaNNmyO7F4AaY6VXNMZAedlWsiMJ+Sgxh8urezmbMi
   +Qd0HZyGq5Qv891zeCZMPZH8zfrTRtfE9st+rUIShTjRDVbim+skpS44R
   P5hbz0WdBZKT6z4y2I5URp6jVVGx+r2EvYjF9YZHhwRVw9Xw34Y9/Dra+
   ObIDR25BiaOGhaVFOevzmBEpXfXgvy1kBhl65cdwMnhjfGAXUh9htE2jg
   glVat3dDIqXHMlsP3Si2005VgU4oL+hPhdgtt+Sh2zg9AeHtCAnJVRHXJ
   WzMgj+zx3TzWgY3xni6sLXWBoQsU9NwfANUzNXCNi7RFJTLNeXxccK4+4
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11020"; a="9806473"
X-IronPort-AV: E=Sophos;i="6.07,143,1708416000"; 
   d="scan'208";a="9806473"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2024 07:27:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,143,1708416000"; 
   d="scan'208";a="14527941"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orviesa009.jf.intel.com with ESMTP; 21 Mar 2024 07:27:47 -0700
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
Subject: [PATCH v10 08/21] i386/cpu: Consolidate the use of topo_info in cpu_x86_cpuid()
Date: Thu, 21 Mar 2024 22:40:35 +0800
Message-Id: <20240321144048.3699388-9-zhao1.liu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240321144048.3699388-1-zhao1.liu@linux.intel.com>
References: <20240321144048.3699388-1-zhao1.liu@linux.intel.com>
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

Since the names of cs->nr_cores and cs->nr_threads do not accurately
represent its meaning, the use of cs->nr_cores or cs->nr_threads is
prone to confusion and mistakes.

And the structure X86CPUTopoInfo names its members clearly, thus the
variable "topo_info" should be preferred.

In addition, in cpu_x86_cpuid(), to uniformly use the topology variable,
replace env->dies with topo_info.dies_per_pkg as well.

Suggested-by: Robert Hoo <robert.hu@linux.intel.com>
Tested-by: Yongwei Ma <yongwei.ma@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Tested-by: Babu Moger <babu.moger@amd.com>
---
Changes since v9:
 * Polished the commit message. ( Xiaoyao)

Changes since v8:
 * Added Philippe's reviewed-by tag.

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
index 8f559b42f706..0ad400cd709a 100644
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
@@ -6106,15 +6111,15 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
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
 
@@ -6260,12 +6265,12 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
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
@@ -6285,7 +6290,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
         break;
     case 0x1F:
         /* V2 Extended Topology Enumeration Leaf */
-        if (env->nr_dies < 2) {
+        if (topo_info.dies_per_pkg < 2) {
             *eax = *ebx = *ecx = *edx = 0;
             break;
         }
@@ -6295,7 +6300,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
         switch (count) {
         case 0:
             *eax = apicid_core_offset(&topo_info);
-            *ebx = cs->nr_threads;
+            *ebx = topo_info.threads_per_core;
             *ecx |= CPUID_TOPOLOGY_LEVEL_SMT;
             break;
         case 1:
@@ -6305,7 +6310,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
             break;
         case 2:
             *eax = apicid_pkg_offset(&topo_info);
-            *ebx = cs->nr_cores * cs->nr_threads;
+            *ebx = threads_per_pkg;
             *ecx |= CPUID_TOPOLOGY_LEVEL_DIE;
             break;
         default:
@@ -6533,7 +6538,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
          * discards multiple thread information if it is set.
          * So don't set it here for Intel to make Linux guests happy.
          */
-        if (cs->nr_cores * cs->nr_threads > 1) {
+        if (threads_per_pkg > 1) {
             if (env->cpuid_vendor1 != CPUID_VENDOR_INTEL_1 ||
                 env->cpuid_vendor2 != CPUID_VENDOR_INTEL_2 ||
                 env->cpuid_vendor3 != CPUID_VENDOR_INTEL_3) {
@@ -6599,7 +6604,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
              *eax |= (cpu_x86_virtual_addr_width(env) << 8);
         }
         *ebx = env->features[FEAT_8000_0008_EBX];
-        if (cs->nr_cores * cs->nr_threads > 1) {
+        if (threads_per_pkg > 1) {
             /*
              * Bits 15:12 is "The number of bits in the initial
              * Core::X86::Apic::ApicId[ApicId] value that indicate
@@ -6607,7 +6612,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
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


