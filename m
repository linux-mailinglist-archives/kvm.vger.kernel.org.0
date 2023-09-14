Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37B2F79FCE3
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 09:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235999AbjINHMJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 03:12:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235966AbjINHMG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 03:12:06 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB4F1CCD
        for <kvm@vger.kernel.org>; Thu, 14 Sep 2023 00:12:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694675522; x=1726211522;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8Wsvh8a4OTp/q7yLTwS9/myf28U3xFPd+NE+sxvPILI=;
  b=IbOWtzFfz8llZB7X2SJ90v7QoGDcLrUS/reO5Ld8n5hT+RS6cq4g23nb
   6og/+3STLDzUdsB1zr4FSNMFfGXSwFfV3HZk0yPncCdsrtxrfgMd5pD9m
   c6GIVJjC7w787BWpaXKX+uZ9FeVtFYyECw5CCtxy1QCcaJoorgZOfFyOT
   4c1Se7cKn0zOKkGB4tIpq7FEyWHdEPSZskrepHxVIyCSEhpgAmEbU4WUV
   d00ioKdz6ihtfL3180B6nvtsZR11WeOnG0nwfIpNCDidSAQqX1P4WLE3K
   amiXnCcEcyekwNBl6Asw/R5b7fJpdUWdkHSblT4jlvyhVYrLshieuZAYp
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="359136159"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="359136159"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2023 00:11:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="779526454"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="779526454"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orsmga001.jf.intel.com with ESMTP; 14 Sep 2023 00:11:45 -0700
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
        Babu Moger <babu.moger@amd.com>, Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v4 08/21] i386: Split topology types of CPUID[0x1F] from the definitions of CPUID[0xB]
Date:   Thu, 14 Sep 2023 15:21:46 +0800
Message-Id: <20230914072159.1177582-9-zhao1.liu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230914072159.1177582-1-zhao1.liu@linux.intel.com>
References: <20230914072159.1177582-1-zhao1.liu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Zhao Liu <zhao1.liu@intel.com>

CPUID[0xB] defines SMT, Core and Invalid types, and this leaf is shared
by Intel and AMD CPUs.

But for extended topology levels, Intel CPU (in CPUID[0x1F]) and AMD CPU
(in CPUID[0x80000026]) have the different definitions with different
enumeration values.

Though CPUID[0x80000026] hasn't been implemented in QEMU, to avoid
possible misunderstanding, split topology types of CPUID[0x1F] from the
definitions of CPUID[0xB] and introduce CPUID[0x1F]-specific topology
types.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes since v3:
 * New commit to prepare to refactor CPUID[0x1F] encoding.
---
 target/i386/cpu.c | 14 +++++++-------
 target/i386/cpu.h | 13 +++++++++----
 2 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 0e9a33034026..88ccc9df9118 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -6250,17 +6250,17 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
         case 0:
             *eax = apicid_core_offset(&topo_info);
             *ebx = topo_info.threads_per_core;
-            *ecx |= CPUID_TOPOLOGY_LEVEL_SMT;
+            *ecx |= CPUID_B_ECX_TOPO_LEVEL_SMT << 8;
             break;
         case 1:
             *eax = apicid_pkg_offset(&topo_info);
             *ebx = cpus_per_pkg;
-            *ecx |= CPUID_TOPOLOGY_LEVEL_CORE;
+            *ecx |= CPUID_B_ECX_TOPO_LEVEL_CORE << 8;
             break;
         default:
             *eax = 0;
             *ebx = 0;
-            *ecx |= CPUID_TOPOLOGY_LEVEL_INVALID;
+            *ecx |= CPUID_B_ECX_TOPO_LEVEL_INVALID << 8;
         }
 
         assert(!(*eax & ~0x1f));
@@ -6286,22 +6286,22 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
         case 0:
             *eax = apicid_core_offset(&topo_info);
             *ebx = topo_info.threads_per_core;
-            *ecx |= CPUID_TOPOLOGY_LEVEL_SMT;
+            *ecx |= CPUID_1F_ECX_TOPO_LEVEL_SMT << 8;
             break;
         case 1:
             *eax = apicid_die_offset(&topo_info);
             *ebx = topo_info.cores_per_die * topo_info.threads_per_core;
-            *ecx |= CPUID_TOPOLOGY_LEVEL_CORE;
+            *ecx |= CPUID_1F_ECX_TOPO_LEVEL_CORE << 8;
             break;
         case 2:
             *eax = apicid_pkg_offset(&topo_info);
             *ebx = cpus_per_pkg;
-            *ecx |= CPUID_TOPOLOGY_LEVEL_DIE;
+            *ecx |= CPUID_1F_ECX_TOPO_LEVEL_DIE << 8;
             break;
         default:
             *eax = 0;
             *ebx = 0;
-            *ecx |= CPUID_TOPOLOGY_LEVEL_INVALID;
+            *ecx |= CPUID_1F_ECX_TOPO_LEVEL_INVALID << 8;
         }
         assert(!(*eax & ~0x1f));
         *ebx &= 0xffff; /* The count doesn't need to be reliable. */
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 70eb3bc23eb8..97113ad3d002 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -1009,10 +1009,15 @@ uint64_t x86_cpu_get_supported_feature_word(FeatureWord w,
 #define CPUID_MWAIT_EMX     (1U << 0) /* enumeration supported */
 
 /* CPUID[0xB].ECX level types */
-#define CPUID_TOPOLOGY_LEVEL_INVALID  (0U << 8)
-#define CPUID_TOPOLOGY_LEVEL_SMT      (1U << 8)
-#define CPUID_TOPOLOGY_LEVEL_CORE     (2U << 8)
-#define CPUID_TOPOLOGY_LEVEL_DIE      (5U << 8)
+#define CPUID_B_ECX_TOPO_LEVEL_INVALID  0
+#define CPUID_B_ECX_TOPO_LEVEL_SMT      1
+#define CPUID_B_ECX_TOPO_LEVEL_CORE     2
+
+/* COUID[0x1F].ECX level types */
+#define CPUID_1F_ECX_TOPO_LEVEL_INVALID  CPUID_B_ECX_TOPO_LEVEL_INVALID
+#define CPUID_1F_ECX_TOPO_LEVEL_SMT      CPUID_B_ECX_TOPO_LEVEL_SMT
+#define CPUID_1F_ECX_TOPO_LEVEL_CORE     CPUID_B_ECX_TOPO_LEVEL_CORE
+#define CPUID_1F_ECX_TOPO_LEVEL_DIE      5
 
 /* MSR Feature Bits */
 #define MSR_ARCH_CAP_RDCL_NO            (1U << 0)
-- 
2.34.1

