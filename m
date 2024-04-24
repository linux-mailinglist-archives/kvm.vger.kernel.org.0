Return-Path: <kvm+bounces-15827-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D9858B0EA3
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 17:38:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 56147281D76
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 15:38:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99AE016C6AD;
	Wed, 24 Apr 2024 15:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hEBO57av"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59DCE1422AF
	for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 15:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713973003; cv=none; b=qj7qCQaJhH1PxWz1rAJ210/0oOnI64op1fT0kOESzCZlPEGaBMuylxWWtZYhIT97PXb3/DkmyipvxAJug2HKQLAJWr6BPWy//xPcLOhyH9qynlTkD5kX6ChFuPA5z8D/8OmMfQIA6xvS92UjZRhiooUJxK1uvUtyCvbE7ODEUNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713973003; c=relaxed/simple;
	bh=aBOwpxkkwCsLiWf7E1bzg+udTEWTRhPXi5vjfc/GDFo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lZMoMRxLK0PxRg5yXs7Fi4eRCHs1yiUjw8zUa61BP1sqpwcIUwfXCe5pQSnBtfm7d01yi7oTXE5WR0ek37lLDP+W2J5yJyce529ia8XyNsxq5vBsThM2OjU2d5FkpAs0PQQcnwuNfOKi7Fqw/ZtRVGLXMyNWgWFZ8erFQ/w2IqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hEBO57av; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713973002; x=1745509002;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aBOwpxkkwCsLiWf7E1bzg+udTEWTRhPXi5vjfc/GDFo=;
  b=hEBO57avAnUVWZ5oVWD8ccHhf4vylCPhHY595gfDu/poewCPQpBU/UjA
   YeHl852mUQFNM60FTrsyUnSM8vscdNZ3cmkgTGxnpykm01+ux0vr+J3yj
   kr2As5+f0bQ+ovGE7K5XPepyKciQHuRS1cegC95OgSpqSV01/9jn8fsmp
   VN1MeDOjfMLwd4l/G9KpFIF6rTU9J/iPNz5ruWeloQ/hxCwli9J04cTwi
   sLEwcsb1pUYZpbV84gPqVdfZ1mEFyoEHXVAGXN75GVdvo2OPQyrDS3cxd
   PMyXw20KoYsY615HvViDw2aZBCx0uc9zSNyiAcnkT/bc6UrS3P07cWhAf
   Q==;
X-CSE-ConnectionGUID: u282kf/hRAWlSe8jM+xyMQ==
X-CSE-MsgGUID: 9ydMXEJpQ1yvJOseooanPg==
X-IronPort-AV: E=McAfee;i="6600,9927,11054"; a="12545685"
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="12545685"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 08:36:42 -0700
X-CSE-ConnectionGUID: E02F/BcpSFyhpWdXTavWAQ==
X-CSE-MsgGUID: nnBVEwhKSV2QGYwIxfFDJw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="25363148"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orviesa008.jf.intel.com with ESMTP; 24 Apr 2024 08:36:38 -0700
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
Subject: [PATCH v11 09/21] i386/cpu: Introduce bitmap to cache available CPU topology levels
Date: Wed, 24 Apr 2024 23:49:17 +0800
Message-Id: <20240424154929.1487382-10-zhao1.liu@intel.com>
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

Currently, QEMU checks the specify number of topology domains to detect
if there's extended topology levels (e.g., checking nr_dies).

With this bitmap, the extended CPU topology (the levels other than SMT,
core and package) could be easier to detect without touching the
topology details.

This is also in preparation for the follow-up to decouple CPUID[0x1F]
subleaf with specific topology level.

Tested-by: Yongwei Ma <yongwei.ma@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
Tested-by: Babu Moger <babu.moger@amd.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
Changes since v10:
 * Rebased on commit 88daa112d4eda.

Changes since v7:
 * New commit to response Xiaoyao's suggestion about the gloabl variable
   to cache topology levels. (Xiaoyao)
---
 hw/i386/x86.c              |  5 ++++-
 include/hw/i386/topology.h | 23 +++++++++++++++++++++++
 target/i386/cpu.c          | 18 +++++++++++++++---
 target/i386/cpu.h          |  4 ++++
 target/i386/kvm/kvm.c      |  3 ++-
 5 files changed, 48 insertions(+), 5 deletions(-)

diff --git a/hw/i386/x86.c b/hw/i386/x86.c
index 3d5b51e92db3..004627fa8985 100644
--- a/hw/i386/x86.c
+++ b/hw/i386/x86.c
@@ -313,7 +313,10 @@ void x86_cpu_pre_plug(HotplugHandler *hotplug_dev,
 
     init_topo_info(&topo_info, x86ms);
 
-    env->nr_dies = ms->smp.dies;
+    if (ms->smp.dies > 1) {
+        env->nr_dies = ms->smp.dies;
+        set_bit(CPU_TOPO_LEVEL_DIE, env->avail_cpu_topo);
+    }
 
     /*
      * If APIC ID is not set,
diff --git a/include/hw/i386/topology.h b/include/hw/i386/topology.h
index d4eeb7ab8290..befeb92b0b19 100644
--- a/include/hw/i386/topology.h
+++ b/include/hw/i386/topology.h
@@ -60,6 +60,21 @@ typedef struct X86CPUTopoInfo {
     unsigned threads_per_core;
 } X86CPUTopoInfo;
 
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
 /* Return the bit width needed for 'count' IDs */
 static unsigned apicid_bitwidth_for_count(unsigned count)
 {
@@ -168,4 +183,12 @@ static inline apic_id_t x86_apicid_from_cpu_idx(X86CPUTopoInfo *topo_info,
     return x86_apicid_from_topo_ids(topo_info, &topo_ids);
 }
 
+/*
+ * Check whether there's extended topology level (die)?
+ */
+static inline bool x86_has_extended_topo(unsigned long *topo_bitmap)
+{
+    return test_bit(CPU_TOPO_LEVEL_DIE, topo_bitmap);
+}
+
 #endif /* HW_I386_TOPOLOGY_H */
diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 0611f8ffbf8b..6d6d93ca1497 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -6426,7 +6426,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
         break;
     case 0x1F:
         /* V2 Extended Topology Enumeration Leaf */
-        if (topo_info.dies_per_pkg < 2) {
+        if (!x86_has_extended_topo(env->avail_cpu_topo)) {
             *eax = *ebx = *ecx = *edx = 0;
             break;
         }
@@ -7259,7 +7259,7 @@ void x86_cpu_expand_features(X86CPU *cpu, Error **errp)
          * cpu->vendor_cpuid_only has been unset for compatibility with older
          * machine types.
          */
-        if ((env->nr_dies > 1) &&
+        if (x86_has_extended_topo(env->avail_cpu_topo) &&
             (IS_INTEL_CPU(env) || !cpu->vendor_cpuid_only)) {
             x86_cpu_adjust_level(cpu, &env->cpuid_min_level, 0x1F);
         }
@@ -7782,13 +7782,25 @@ static void x86_cpu_post_initfn(Object *obj)
     accel_cpu_instance_init(CPU(obj));
 }
 
+static void x86_cpu_init_default_topo(X86CPU *cpu)
+{
+    CPUX86State *env = &cpu->env;
+
+    env->nr_dies = 1;
+
+    /* SMT, core and package levels are set by default. */
+    set_bit(CPU_TOPO_LEVEL_SMT, env->avail_cpu_topo);
+    set_bit(CPU_TOPO_LEVEL_CORE, env->avail_cpu_topo);
+    set_bit(CPU_TOPO_LEVEL_PACKAGE, env->avail_cpu_topo);
+}
+
 static void x86_cpu_initfn(Object *obj)
 {
     X86CPU *cpu = X86_CPU(obj);
     X86CPUClass *xcc = X86_CPU_GET_CLASS(obj);
     CPUX86State *env = &cpu->env;
 
-    env->nr_dies = 1;
+    x86_cpu_init_default_topo(cpu);
 
     object_property_add(obj, "feature-words", "X86CPUFeatureWordInfo",
                         x86_cpu_get_feature_words,
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 6112e27bfd5c..3eef30f2847d 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -24,6 +24,7 @@
 #include "cpu-qom.h"
 #include "kvm/hyperv-proto.h"
 #include "exec/cpu-defs.h"
+#include "hw/i386/topology.h"
 #include "qapi/qapi-types-common.h"
 #include "qemu/cpu-float.h"
 #include "qemu/timer.h"
@@ -1892,6 +1893,9 @@ typedef struct CPUArchState {
 
     /* Number of dies within this CPU package. */
     unsigned nr_dies;
+
+    /* Bitmap of available CPU topology levels for this CPU. */
+    DECLARE_BITMAP(avail_cpu_topo, CPU_TOPO_LEVEL_MAX);
 } CPUX86State;
 
 struct kvm_msrs;
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index c5943605ee3a..6c864e4611f6 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -51,6 +51,7 @@
 #include "hw/i386/apic_internal.h"
 #include "hw/i386/apic-msidef.h"
 #include "hw/i386/intel_iommu.h"
+#include "hw/i386/topology.h"
 #include "hw/i386/x86-iommu.h"
 #include "hw/i386/e820_memory_layout.h"
 
@@ -1791,7 +1792,7 @@ static uint32_t kvm_x86_build_cpuid(CPUX86State *env,
             break;
         }
         case 0x1f:
-            if (env->nr_dies < 2) {
+            if (!x86_has_extended_topo(env->avail_cpu_topo)) {
                 cpuid_i--;
                 break;
             }
-- 
2.34.1


