Return-Path: <kvm+bounces-10056-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CE7A868D42
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 11:20:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B6F39289815
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 10:20:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 234E71386BB;
	Tue, 27 Feb 2024 10:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lW6Pv0Ku"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5E27138490
	for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 10:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709029180; cv=none; b=C17K/SLJPK8P08/3eI5FK6vgO8kWisFbVgXX7SIQGXlnwo5sKjTB3GNl6W9+65EWtOBRhLJUxuiXzSwg63/4nNK4n5NDA+Q8V/Rh3IAP6HOvXPblfFc/V8MsTtb8PAOaB6zHPp34M/24RpFAKIES9OdqtCLFNRbkp0MqJxl+xyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709029180; c=relaxed/simple;
	bh=xE2WmkfQfsHDM5mvsIOm95FXOfGs7VUkEvbtrPZhgyo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=C79PPozZRADXEUNldLRiVgxLmAZru9a7f0OIBD0GL3395aCFysIfl4ufFQIO/SHJq0Lu0k2uZDdf2jhprZKZnLo212QQoRpIvs6nG/Xx4eDN82+UgrjgBNf14QyvUV41DHOwVNzNXucs2kSAbdOO9/2iWw6pvL55iP9GzfVCM0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lW6Pv0Ku; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709029178; x=1740565178;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xE2WmkfQfsHDM5mvsIOm95FXOfGs7VUkEvbtrPZhgyo=;
  b=lW6Pv0KuAt4fTNW112aSDgsVbxypuAmFKd6ayUKQp7AyU3h5NGaecg1w
   +G2k+mFTmWO50aqAf5rGkeIM0IZZ8lJS+puuM+uRSRc1q75iCbUF4tlWs
   c+l/Qiq8w6TX83+8uIitqPTx+TI3s561Bv+C7WhwXzjVxV6gEDAheJzhv
   acuaTAEwsYOUbG8wq1anucM63wAC/piOGCJ4DFLT2PHKu3rSX1rbElkat
   Aowf3ul1M+/AHl+ipod/lkjXl7Gzszvjzt0FYR3ujtcMDxcE3AnWCjp4l
   d7PKIcd3oGFwm0WfwMMy7PLfnxo95mt+mm4tqQ4OeBLhSYOp1D+4w+ic4
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10996"; a="6310299"
X-IronPort-AV: E=Sophos;i="6.06,187,1705392000"; 
   d="scan'208";a="6310299"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2024 02:19:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,187,1705392000"; 
   d="scan'208";a="6954822"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa010.fm.intel.com with ESMTP; 27 Feb 2024 02:19:34 -0800
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
Subject: [PATCH v9 09/21] i386/cpu: Introduce bitmap to cache available CPU topology levels
Date: Tue, 27 Feb 2024 18:32:19 +0800
Message-Id: <20240227103231.1556302-10-zhao1.liu@linux.intel.com>
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

Currently, QEMU checks the specify number of topology domains to detect
if there's extended topology levels (e.g., checking nr_dies).

With this bitmap, the extended CPU topology (the levels other than SMT,
core and package) could be easier to detect without touching the
topology details.

This is also in preparation for the follow-up to decouple CPUID[0x1F]
subleaf with specific topology level.

Tested-by: Yongwei Ma <yongwei.ma@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
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
index 684dce90e92c..1e4ff7188f6a 100644
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
index d115fc7002ef..2070d5a91cfa 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -6282,7 +6282,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
         break;
     case 0x1F:
         /* V2 Extended Topology Enumeration Leaf */
-        if (topo_info.dies_per_pkg < 2) {
+        if (!x86_has_extended_topo(env->avail_cpu_topo)) {
             *eax = *ebx = *ecx = *edx = 0;
             break;
         }
@@ -7114,7 +7114,7 @@ void x86_cpu_expand_features(X86CPU *cpu, Error **errp)
          * cpu->vendor_cpuid_only has been unset for compatibility with older
          * machine types.
          */
-        if ((env->nr_dies > 1) &&
+        if (x86_has_extended_topo(env->avail_cpu_topo) &&
             (IS_INTEL_CPU(env) || !cpu->vendor_cpuid_only)) {
             x86_cpu_adjust_level(cpu, &env->cpuid_min_level, 0x1F);
         }
@@ -7620,13 +7620,25 @@ static void x86_cpu_post_initfn(Object *obj)
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
index dfe43b820420..4592353616f9 100644
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
index 42970ab046fa..1e235ae04fdd 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -50,6 +50,7 @@
 #include "hw/i386/apic_internal.h"
 #include "hw/i386/apic-msidef.h"
 #include "hw/i386/intel_iommu.h"
+#include "hw/i386/topology.h"
 #include "hw/i386/x86-iommu.h"
 #include "hw/i386/e820_memory_layout.h"
 
@@ -1913,7 +1914,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
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


