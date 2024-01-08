Return-Path: <kvm+bounces-5778-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CA7682692A
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 09:15:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1F9201F216E0
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 08:15:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5F89C2E6;
	Mon,  8 Jan 2024 08:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OTwCx5MR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A5EBE7F
	for <kvm@vger.kernel.org>; Mon,  8 Jan 2024 08:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704701692; x=1736237692;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pNzhHK79i2KZqGhGkmIfzT6Zu2ywGd7JncYaLYLok0k=;
  b=OTwCx5MRSdICHa/al2FZsg/iRvnQ12nYYwNrhu45H5ctpaZ2fNCaRmjo
   q2rPK/4BZb411zdluH7PMbCW77wpay5bbZLY3Ho6vO4viKEKF2tWXNDL9
   h/PU1Osd9hNyuPLFqmZmry1PLV+DRZp6ILsrneQkLzuPpuUgTbbLblQa3
   6Vr3ZEIUtMFTPH0EPnN2JFVtWmyBOL2Jag46AgNPqpJfzh3qMkL+1V8P6
   EiAjdUtDTThrbQG7uJWo/JpV7FcoWekx4YkVxUAs8eyRBiolcr+K1xel9
   W22ar7pRybaNNEnFJjaGHDUDwEGCLuXBIoluF0qEyFlndYM9JSE/z3ms6
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10946"; a="16419950"
X-IronPort-AV: E=Sophos;i="6.04,340,1695711600"; 
   d="scan'208";a="16419950"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2024 00:14:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.04,340,1695711600"; 
   d="scan'208";a="15850172"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa002.fm.intel.com with ESMTP; 08 Jan 2024 00:14:48 -0800
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
	Babu Moger <babu.moger@amd.com>,
	Yongwei Ma <yongwei.ma@intel.com>
Subject: [PATCH v7 04/16] i386: Split topology types of CPUID[0x1F] from the definitions of CPUID[0xB]
Date: Mon,  8 Jan 2024 16:27:15 +0800
Message-Id: <20240108082727.420817-5-zhao1.liu@linux.intel.com>
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
Tested-by: Babu Moger <babu.moger@amd.com>
Tested-by: Yongwei Ma <yongwei.ma@intel.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
---
Changes since v3:
 * New commit to prepare to refactor CPUID[0x1F] encoding.
---
 target/i386/cpu.c | 14 +++++++-------
 target/i386/cpu.h | 13 +++++++++----
 2 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 6f8fa772ecf8..bc440477d13d 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -6255,17 +6255,17 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
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
@@ -6290,22 +6290,22 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
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
index ef987f344cff..f47bad46db5e 100644
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


