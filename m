Return-Path: <kvm+bounces-15832-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B90768B0EAA
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 17:39:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 32CC71F2B470
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 15:39:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0200916C854;
	Wed, 24 Apr 2024 15:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dlwytoq6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC37F161902
	for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 15:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713973036; cv=none; b=lp/OmmYOkgsMaRWmjveIz+FpnLpIoDQmkWhCU79ajWCWawA0npCth3jZrMfbuxBp+IetApAPQkwMMiGMmXNx2YDZy1TyWkzDzaFbAPA2YglXhWs8ggMsZg21rvpIb2smNkYnfEQFuvQBnKw+R5fDJFFqTJnFQtfoouo72vxZahY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713973036; c=relaxed/simple;
	bh=iIl0C+Qixsw04e7TkAPrjhJFuOEqzJHHadMylFCGKCE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Gy2PfPvi6fZz0z6Z88RpEmYMS9wharNWhSEtFcZ4k+2jl2+7hGppIIJUAmHi4pOK52sOs3jW0HDOPEV4RFqveoNWldhAnjAZOUjczkc/gbdt+P7A1bR8GhwLeLhkAMzFWthSm4S7Kd96Ezia8cbOe14c2kSC8i35znnfKWgX+WA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dlwytoq6; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713973035; x=1745509035;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iIl0C+Qixsw04e7TkAPrjhJFuOEqzJHHadMylFCGKCE=;
  b=dlwytoq6bVJD/vdxkFT8Q78W9V3a3NHSDcXohkuHqkTU3TBR4Atygf/n
   MGGd4VBnzysIKUh5u0/Js5EdHgcTo1L5/re0132k26Vwn1io1YuhWYvPM
   IWo4PjVYmK06+g7MykiVf23YcgA6J/Q3eaeZgA8LNhTPnJf3YI2mqDRwI
   QJKbVAWRJXHwtDtQGRbppok8EkkxeIb/RPrs7s4Y7ys/lo26SKf48rAA2
   hD16VFxZJGU6SUuy8jf0oJEsXbzlIFCPlYGutNYzd6ZdI3QgMW4XGc1f1
   IicUXsyc/VJuKLQVVCtJR79QmzIldohizoNoB8m60uVlZlUaUvodtw/fs
   Q==;
X-CSE-ConnectionGUID: hqTxxRLaQKSEuigrE7fw6w==
X-CSE-MsgGUID: vpe4X6f4Twa7p3yM6zfNLA==
X-IronPort-AV: E=McAfee;i="6600,9927,11054"; a="12545782"
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="12545782"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 08:37:06 -0700
X-CSE-ConnectionGUID: aXTSxeZKTUG/WEVDwsyX1g==
X-CSE-MsgGUID: 0d3aahLiQzKh1p3y71cYXQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="25363317"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orviesa008.jf.intel.com with ESMTP; 24 Apr 2024 08:37:02 -0700
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
Subject: [PATCH v11 14/21] i386: Expose module level in CPUID[0x1F]
Date: Wed, 24 Apr 2024 23:49:22 +0800
Message-Id: <20240424154929.1487382-15-zhao1.liu@intel.com>
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
index f2a0f68020d6..69f56aafeed6 100644
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
index 5c6936dd0253..a637a8ad8f51 100644
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
index 630129838c08..b0ecf90460ab 100644
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


