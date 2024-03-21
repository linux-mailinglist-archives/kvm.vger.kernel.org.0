Return-Path: <kvm+bounces-12396-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DB16885AC0
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 15:29:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B7F172813C7
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 14:29:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AF1186634;
	Thu, 21 Mar 2024 14:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VkcR9nPq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00B1384038
	for <kvm@vger.kernel.org>; Thu, 21 Mar 2024 14:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711031304; cv=none; b=YL3qtsFQ0Oje8Hdr/ucxleLgtQWRi6xad7E5z37jIv12BLHsD/tZkwiKJ1iFpXaVW+ROWwlcPjHLoumfWpxhFuU53x2cNK/hUoE/jBeR/buXWuoiQVWoMV+xX+/mekPkotXaN7MwGKsm6tDscwIpHo7iSWk4Ec69IRF+be2NkRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711031304; c=relaxed/simple;
	bh=ER7gvp3BATFU35LtXPhRNJAMTf98qfkoBJBfjUlh4Ck=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=szAcCD8lCAsGcxbj5V8gRvMP9Nl3gatba+4Q5SL+87HJPIKEeUGpYr/zS2bVj+hLRySdYii+zOUbFmux+M7gE8LsJrsLCZT3ZS7RBVXA8xyfI1cL3UmMuxKgD54wt68aKM05XAbIqdfwRkInkkRWLDawjxrw2sMkAPSp5tubb1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VkcR9nPq; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711031304; x=1742567304;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ER7gvp3BATFU35LtXPhRNJAMTf98qfkoBJBfjUlh4Ck=;
  b=VkcR9nPqBYBSbNGjAKY6+jk180+28VLoPgWXSawl7hqsYEeAVad2hi6G
   PV/DQoJ1KkJ2REM2lK50QYieT1xuI5u/0BSxPt53C+PM5zEmgsUUPij9U
   fzOnJ/wZs0J8OQ1T6ZIjr5wWOwsNxBczmOXLESQ70lGlbEgsSQ+H2rBw/
   pKuqYQC2pVzQxH4dZmm0lqDJXqBlaefiZOjI0S6SAlw64dbq10NfMryQD
   VmohFZ7uODDfVysYknuWnhr+w61yYd1gQoGVgOWc/fDBX6PQZuR4dFYM5
   qkFlVL95hJHzWkiXe1ftaK5DkhgpMvjFJZyZVZ1nYfnsktykudeIiX96g
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11020"; a="9806570"
X-IronPort-AV: E=Sophos;i="6.07,143,1708416000"; 
   d="scan'208";a="9806570"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2024 07:28:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,143,1708416000"; 
   d="scan'208";a="14528175"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orviesa009.jf.intel.com with ESMTP; 21 Mar 2024 07:28:18 -0700
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
Subject: [PATCH v10 14/21] i386: Expose module level in CPUID[0x1F]
Date: Thu, 21 Mar 2024 22:40:41 +0800
Message-Id: <20240321144048.3699388-15-zhao1.liu@linux.intel.com>
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

Linux kernel (from v6.4, with commit edc0a2b595765 ("x86/topology: Fix
erroneous smp_num_siblings on Intel Hybrid platforms") is able to
handle platforms with Module level enumerated via CPUID.1F.

Expose the module level in CPUID[0x1F] if the machine has more than 1
modules.

Tested-by: Yongwei Ma <yongwei.ma@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
Tested-by: Babu Moger <babu.moger@amd.com>
---
Changes since v7:
 * Mapped x86 module to smp module instead of cluster.
 * Dropped Michael/Babu's ACKed/Tested tags since the code change.
 * Re-added Yongwei's Tested tag For his re-testing.

Changes since v3:
 * New patch to expose module level in 0x1F.
 * Added Tested-by tag from Yongwei.
---
 hw/i386/x86.c              | 2 +-
 include/hw/i386/topology.h | 6 ++++--
 target/i386/cpu.c          | 6 ++++++
 target/i386/cpu.h          | 1 +
 4 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/hw/i386/x86.c b/hw/i386/x86.c
index 6df762369c71..a4da29ec8115 100644
--- a/hw/i386/x86.c
+++ b/hw/i386/x86.c
@@ -322,7 +322,7 @@ void x86_cpu_pre_plug(HotplugHandler *hotplug_dev,
 
     if (ms->smp.modules > 1) {
         env->nr_modules = ms->smp.modules;
-        /* TODO: Expose module level in CPUID[0x1F]. */
+        set_bit(CPU_TOPO_LEVEL_MODULE, env->avail_cpu_topo);
     }
 
     if (ms->smp.dies > 1) {
diff --git a/include/hw/i386/topology.h b/include/hw/i386/topology.h
index 7622d806932c..ea871045779d 100644
--- a/include/hw/i386/topology.h
+++ b/include/hw/i386/topology.h
@@ -71,6 +71,7 @@ enum CPUTopoLevel {
     CPU_TOPO_LEVEL_INVALID,
     CPU_TOPO_LEVEL_SMT,
     CPU_TOPO_LEVEL_CORE,
+    CPU_TOPO_LEVEL_MODULE,
     CPU_TOPO_LEVEL_DIE,
     CPU_TOPO_LEVEL_PACKAGE,
     CPU_TOPO_LEVEL_MAX,
@@ -198,11 +199,12 @@ static inline apic_id_t x86_apicid_from_cpu_idx(X86CPUTopoInfo *topo_info,
 }
 
 /*
- * Check whether there's extended topology level (die)?
+ * Check whether there's extended topology level (module or die)?
  */
 static inline bool x86_has_extended_topo(unsigned long *topo_bitmap)
 {
-    return test_bit(CPU_TOPO_LEVEL_DIE, topo_bitmap);
+    return test_bit(CPU_TOPO_LEVEL_MODULE, topo_bitmap) ||
+           test_bit(CPU_TOPO_LEVEL_DIE, topo_bitmap);
 }
 
 #endif /* HW_I386_TOPOLOGY_H */
diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 7c5c6a0e87a6..8dab6d473247 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -277,6 +277,8 @@ static uint32_t num_threads_by_topo_level(X86CPUTopoInfo *topo_info,
         return 1;
     case CPU_TOPO_LEVEL_CORE:
         return topo_info->threads_per_core;
+    case CPU_TOPO_LEVEL_MODULE:
+        return topo_info->threads_per_core * topo_info->cores_per_module;
     case CPU_TOPO_LEVEL_DIE:
         return topo_info->threads_per_core * topo_info->cores_per_module *
                topo_info->modules_per_die;
@@ -297,6 +299,8 @@ static uint32_t apicid_offset_by_topo_level(X86CPUTopoInfo *topo_info,
         return 0;
     case CPU_TOPO_LEVEL_CORE:
         return apicid_core_offset(topo_info);
+    case CPU_TOPO_LEVEL_MODULE:
+        return apicid_module_offset(topo_info);
     case CPU_TOPO_LEVEL_DIE:
         return apicid_die_offset(topo_info);
     case CPU_TOPO_LEVEL_PACKAGE:
@@ -316,6 +320,8 @@ static uint32_t cpuid1f_topo_type(enum CPUTopoLevel topo_level)
         return CPUID_1F_ECX_TOPO_LEVEL_SMT;
     case CPU_TOPO_LEVEL_CORE:
         return CPUID_1F_ECX_TOPO_LEVEL_CORE;
+    case CPU_TOPO_LEVEL_MODULE:
+        return CPUID_1F_ECX_TOPO_LEVEL_MODULE;
     case CPU_TOPO_LEVEL_DIE:
         return CPUID_1F_ECX_TOPO_LEVEL_DIE;
     default:
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 095540e58f7a..c3a83c33345a 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -1025,6 +1025,7 @@ uint64_t x86_cpu_get_supported_feature_word(FeatureWord w,
 #define CPUID_1F_ECX_TOPO_LEVEL_INVALID  CPUID_B_ECX_TOPO_LEVEL_INVALID
 #define CPUID_1F_ECX_TOPO_LEVEL_SMT      CPUID_B_ECX_TOPO_LEVEL_SMT
 #define CPUID_1F_ECX_TOPO_LEVEL_CORE     CPUID_B_ECX_TOPO_LEVEL_CORE
+#define CPUID_1F_ECX_TOPO_LEVEL_MODULE   3
 #define CPUID_1F_ECX_TOPO_LEVEL_DIE      5
 
 /* MSR Feature Bits */
-- 
2.34.1


