Return-Path: <kvm+bounces-34122-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8247A9F76FE
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 09:14:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4B8407A3149
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 08:14:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EEA42165F7;
	Thu, 19 Dec 2024 08:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FI0no6NO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51924217720
	for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 08:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734596064; cv=none; b=Lba/5xZ7XKd/OaQihmo4TZ8A8TZbBZsSbx6BukF2VxCFlVRpebjzMZGb3mu8X1t+PwpwpDAEJ9Y/nVdL6uAMstTMFKsKiBAC/SSlgvJs2HygqwEks2ImhU5TiT/dvsSeMSVz/+W+Y4eifLOObkzCS2qM5Vx7BHJP9BVXY8F/PgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734596064; c=relaxed/simple;
	bh=t15kUcDSUDGh6VCzQEjxGJih7PIkID2ut/arbO15P9k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dJpZP9O2mppaB9QsGpA1o/Ob5fxBA6jxXhzvQ/RYy59CpuBJ6DUNaVupUBhdqzkrVH24g5gsXv2c1ZBbcV7SCoLUsZ7ybvZjdWww1RnhWejqHXGhj25tqhOFe3GARbbY5Th/A0ALY5tRzMBXqI645+fw5OrbUYb2ZoO6dBMCUAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FI0no6NO; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734596062; x=1766132062;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=t15kUcDSUDGh6VCzQEjxGJih7PIkID2ut/arbO15P9k=;
  b=FI0no6NOOjJgAOM9mbjVig7ah+fP8oHLpSbZzO6jtpvhBQSZT2Bn3xon
   0GgjPy8VwPL9xXZUDFW2a8Hm1MsG1M4Oot8xcpQzfAgXuAaVnktDbrJi4
   YxSZEMGN2eGvPrjeWao/EsqApigTslDwISz/ttsASOq/crdw7x1TYq2+2
   aNO8wuFymAOM/r9RMteDpBWAp2gCKaFUcE0XA1+v2LyvBAK+M1okHNlqB
   2aAMIeEFzfSKJ5tX5yXmaDRO3S1d4rRWkyLsQrG9o0lhj0KHctw/UUe5P
   n1Ps6wFy2dy2Lxe6+/MIQEsWU81zIt7BIAOUpbvq41zYnUTunxtvVL0QL
   g==;
X-CSE-ConnectionGUID: t7z2Wh65Rjiz9fxUqqY0Ug==
X-CSE-MsgGUID: yuzHDDpISEm4RsHtulzlzA==
X-IronPort-AV: E=McAfee;i="6700,10204,11290"; a="34378633"
X-IronPort-AV: E=Sophos;i="6.12,247,1728975600"; 
   d="scan'208";a="34378633"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2024 00:14:22 -0800
X-CSE-ConnectionGUID: ZMs8fyShQJ+JrGGTIbhtqw==
X-CSE-MsgGUID: i0VdozjBRWeb+soBYWCkFg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="129097528"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by fmviesa001.fm.intel.com with ESMTP; 19 Dec 2024 00:14:18 -0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Alireza Sanaee <alireza.sanaee@huawei.com>,
	Sia Jee Heng <jeeheng.sia@starfivetech.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Zhao Liu <zhao1.liu@intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>
Subject: [PATCH v6 2/4] i386/cpu: Update cache topology with machine's configuration
Date: Thu, 19 Dec 2024 16:32:35 +0800
Message-Id: <20241219083237.265419-3-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241219083237.265419-1-zhao1.liu@intel.com>
References: <20241219083237.265419-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

User will configure smp cache topology via -machine smp-cache.

For this case, update the x86 CPUs' cache topology with user's
configuration in MachineState.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
Tested-by: Yongwei Ma <yongwei.ma@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
Changes since Patch v3:
 * Updated MachineState.smp_cache to consume "default" level and did a
   check to ensure topological hierarchical relationships are correct.
---
 target/i386/cpu.c | 67 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 67 insertions(+)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 87ffb9840cc1..bd5620dcc086 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -7757,6 +7757,64 @@ static void x86_cpu_hyperv_realize(X86CPU *cpu)
     cpu->hyperv_limits[2] = 0;
 }
 
+#ifndef CONFIG_USER_ONLY
+static bool x86_cpu_update_smp_cache_topo(MachineState *ms, X86CPU *cpu,
+                                          Error **errp)
+{
+    CPUX86State *env = &cpu->env;
+    CpuTopologyLevel level;
+
+    level = machine_get_cache_topo_level(ms, CACHE_LEVEL_AND_TYPE_L1D);
+    if (level != CPU_TOPOLOGY_LEVEL_DEFAULT) {
+        env->cache_info_cpuid4.l1d_cache->share_level = level;
+        env->cache_info_amd.l1d_cache->share_level = level;
+    } else {
+        machine_set_cache_topo_level(ms, CACHE_LEVEL_AND_TYPE_L1D,
+            env->cache_info_cpuid4.l1d_cache->share_level);
+        machine_set_cache_topo_level(ms, CACHE_LEVEL_AND_TYPE_L1D,
+            env->cache_info_amd.l1d_cache->share_level);
+    }
+
+    level = machine_get_cache_topo_level(ms, CACHE_LEVEL_AND_TYPE_L1I);
+    if (level != CPU_TOPOLOGY_LEVEL_DEFAULT) {
+        env->cache_info_cpuid4.l1i_cache->share_level = level;
+        env->cache_info_amd.l1i_cache->share_level = level;
+    } else {
+        machine_set_cache_topo_level(ms, CACHE_LEVEL_AND_TYPE_L1I,
+            env->cache_info_cpuid4.l1i_cache->share_level);
+        machine_set_cache_topo_level(ms, CACHE_LEVEL_AND_TYPE_L1I,
+            env->cache_info_amd.l1i_cache->share_level);
+    }
+
+    level = machine_get_cache_topo_level(ms, CACHE_LEVEL_AND_TYPE_L2);
+    if (level != CPU_TOPOLOGY_LEVEL_DEFAULT) {
+        env->cache_info_cpuid4.l2_cache->share_level = level;
+        env->cache_info_amd.l2_cache->share_level = level;
+    } else {
+        machine_set_cache_topo_level(ms, CACHE_LEVEL_AND_TYPE_L2,
+            env->cache_info_cpuid4.l2_cache->share_level);
+        machine_set_cache_topo_level(ms, CACHE_LEVEL_AND_TYPE_L2,
+            env->cache_info_amd.l2_cache->share_level);
+    }
+
+    level = machine_get_cache_topo_level(ms, CACHE_LEVEL_AND_TYPE_L3);
+    if (level != CPU_TOPOLOGY_LEVEL_DEFAULT) {
+        env->cache_info_cpuid4.l3_cache->share_level = level;
+        env->cache_info_amd.l3_cache->share_level = level;
+    } else {
+        machine_set_cache_topo_level(ms, CACHE_LEVEL_AND_TYPE_L3,
+            env->cache_info_cpuid4.l3_cache->share_level);
+        machine_set_cache_topo_level(ms, CACHE_LEVEL_AND_TYPE_L3,
+            env->cache_info_amd.l3_cache->share_level);
+    }
+
+    if (!machine_check_smp_cache(ms, errp)) {
+        return false;
+    }
+    return true;
+}
+#endif
+
 static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
 {
     CPUState *cs = CPU(dev);
@@ -7981,6 +8039,15 @@ static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
 
 #ifndef CONFIG_USER_ONLY
     MachineState *ms = MACHINE(qdev_get_machine());
+
+    /*
+     * TODO: Add a SMPCompatProps.has_caches flag to avoid useless updates
+     * if user didn't set smp_cache.
+     */
+    if (!x86_cpu_update_smp_cache_topo(ms, cpu, errp)) {
+        return;
+    }
+
     qemu_register_reset(x86_cpu_machine_reset_cb, cpu);
 
     if (cpu->env.features[FEAT_1_EDX] & CPUID_APIC || ms->smp.cpus > 1) {
-- 
2.34.1


