Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A87279FCF1
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 09:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236048AbjINHMs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 03:12:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236060AbjINHMo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 03:12:44 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76E3310C9
        for <kvm@vger.kernel.org>; Thu, 14 Sep 2023 00:12:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694675560; x=1726211560;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MhOfVJY580KfIp4Fybth+wo1ybI2RWPtBwiUTz324Nk=;
  b=Ol6Ypu8uF6BRJFC4Qeit93bntOmoI1o1NHRZdEMTR9ctCh40xOCVzNYp
   Nusq/QFe0nbXyvj8cgLc+CEBgCmVPCp3U2iwsm2VeKZ4JKaBXdwCnKw67
   9MJBJJ2j5K118Y3BXp09rICxvoE+Pct4CeRT70Rclr29djEDA89gXWu3D
   CDHWhPl+VUac8UKodWa0LY9HtcSMnuwS7KP4p9AADclRt/4UyTdLplEwH
   kGepdcXgOAleMnvTba8It+F+90YTyMDoHbnqu+vcQRdBxbw5olvkkLJBp
   IikoSNnlfe8e2UCL9iTwGF8DT8XkUpPGXuVSh/YAlQqiO4xEZ6cBPPSIY
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="359136790"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="359136790"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2023 00:12:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="779526871"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="779526871"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orsmga001.jf.intel.com with ESMTP; 14 Sep 2023 00:12:36 -0700
From:   Zhao Liu <zhao1.liu@linux.intel.com>
To:     Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Yanan Wang <wangyanan55@huawei.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Zhenyu Wang <zhenyu.z.wang@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Babu Moger <babu.moger@amd.com>,
        Zhao Liu <zhao1.liu@intel.com>,
        Yongwei Ma <yongwei.ma@intel.com>
Subject: [PATCH v4 21/21] i386: Add new property to control L2 cache topo in CPUID.04H
Date:   Thu, 14 Sep 2023 15:21:59 +0800
Message-Id: <20230914072159.1177582-22-zhao1.liu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230914072159.1177582-1-zhao1.liu@linux.intel.com>
References: <20230914072159.1177582-1-zhao1.liu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Zhao Liu <zhao1.liu@intel.com>

The property x-l2-cache-topo will be used to change the L2 cache
topology in CPUID.04H.

Now it allows user to set the L2 cache is shared in core level or
cluster level.

If user passes "-cpu x-l2-cache-topo=[core|cluster]" then older L2 cache
topology will be overrode by the new topology setting.

Here we expose to user "cluster" instead of "module", to be consistent
with "cluster-id" naming.

Since CPUID.04H is used by intel CPUs, this property is available on
intel CPUs as for now.

When necessary, it can be extended to CPUID.8000001DH for AMD CPUs.

(Tested the cache topology in CPUID[0x04] leaf with "x-l2-cache-topo=[
core|cluster]", and tested the live migration between the QEMUs w/ &
w/o this patch series.)

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
Tested-by: Yongwei Ma <yongwei.ma@intel.com>
---
Changes since v3:
 * Add description about test for live migration compatibility. (Babu)

Changes since v1:
 * Rename MODULE branch to CPU_TOPO_LEVEL_MODULE to match the previous
   renaming changes.
---
 target/i386/cpu.c | 34 +++++++++++++++++++++++++++++++++-
 target/i386/cpu.h |  2 ++
 2 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 3bed823dc3b7..b1282c8bd3b7 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -243,6 +243,9 @@ static uint32_t max_processor_ids_for_cache(X86CPUTopoInfo *topo_info,
     case CPU_TOPO_LEVEL_CORE:
         num_ids = 1 << apicid_core_offset(topo_info);
         break;
+    case CPU_TOPO_LEVEL_MODULE:
+        num_ids = 1 << apicid_module_offset(topo_info);
+        break;
     case CPU_TOPO_LEVEL_DIE:
         num_ids = 1 << apicid_die_offset(topo_info);
         break;
@@ -251,7 +254,7 @@ static uint32_t max_processor_ids_for_cache(X86CPUTopoInfo *topo_info,
         break;
     default:
         /*
-         * Currently there is no use case for SMT and MODULE, so use
+         * Currently there is no use case for SMT, so use
          * assert directly to facilitate debugging.
          */
         g_assert_not_reached();
@@ -7576,6 +7579,34 @@ static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
         env->cache_info_amd.l3_cache = &legacy_l3_cache;
     }
 
+    if (cpu->l2_cache_topo_level) {
+        /*
+         * FIXME: Currently only supports changing CPUID[4] (for intel), and
+         * will support changing CPUID[0x8000001D] when necessary.
+         */
+        if (!IS_INTEL_CPU(env)) {
+            error_setg(errp, "only intel cpus supports x-l2-cache-topo");
+            return;
+        }
+
+        if (!strcmp(cpu->l2_cache_topo_level, "core")) {
+            env->cache_info_cpuid4.l2_cache->share_level = CPU_TOPO_LEVEL_CORE;
+        } else if (!strcmp(cpu->l2_cache_topo_level, "cluster")) {
+            /*
+             * We expose to users "cluster" instead of "module", to be
+             * consistent with "cluster-id" naming.
+             */
+            env->cache_info_cpuid4.l2_cache->share_level =
+                                                        CPU_TOPO_LEVEL_MODULE;
+        } else {
+            error_setg(errp,
+                       "x-l2-cache-topo doesn't support '%s', "
+                       "and it only supports 'core' or 'cluster'",
+                       cpu->l2_cache_topo_level);
+            return;
+        }
+    }
+
 #ifndef CONFIG_USER_ONLY
     MachineState *ms = MACHINE(qdev_get_machine());
     qemu_register_reset(x86_cpu_machine_reset_cb, cpu);
@@ -8079,6 +8110,7 @@ static Property x86_cpu_properties[] = {
                      false),
     DEFINE_PROP_BOOL("x-intel-pt-auto-level", X86CPU, intel_pt_auto_level,
                      true),
+    DEFINE_PROP_STRING("x-l2-cache-topo", X86CPU, l2_cache_topo_level),
     DEFINE_PROP_END_OF_LIST()
 };
 
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index a13132007415..05ffc4c1cc6e 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -2073,6 +2073,8 @@ struct ArchCPU {
     int32_t hv_max_vps;
 
     bool xen_vapic;
+
+    char *l2_cache_topo_level;
 };
 
 
-- 
2.34.1

