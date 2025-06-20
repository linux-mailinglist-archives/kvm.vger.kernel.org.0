Return-Path: <kvm+bounces-50035-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D344BAE1705
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 11:07:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DC1E4188D653
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 09:07:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4598327FD72;
	Fri, 20 Jun 2025 09:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HJ9KIpbN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D863427F75C
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 09:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750410414; cv=none; b=DgpPj4QkSj/XVL7eQqYnS2QJYDovPxHnG43iGXzs8vGfEt6biwEhT15lnt80qQQ2LSyj/Hl+ZWzcVflrDxuXmYESGZA5co3K6D3MCjWOm4Mg83yXtuMjdjdh9qiryPG+Wp7h1B0A9EmtLp9z8vN9IxQKsJFQ5k3wy2VoduKcJa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750410414; c=relaxed/simple;
	bh=QYpGG5KzrC6gv5uRcEil6mVgb1iSBM8LOyqu6n5cCW4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qbVVJs8PGGM9Jgt0WwN+3K/lngPWoy2BIQwP4nE1qHJjLmltH34iUEHSo3dQmNkEWz5QXA7LXZ4rDEn4a6uHDAqfoS4apmLuZ/DPPRfgKL84TjprQNrvjIQ43M28I8bj4xDH9HnNupxpgt6nIhVpClJfX8xAwx39cdVBvoC6Z60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HJ9KIpbN; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750410413; x=1781946413;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QYpGG5KzrC6gv5uRcEil6mVgb1iSBM8LOyqu6n5cCW4=;
  b=HJ9KIpbN+RFFa4X+pu1xM9bs1umKTia1VMPcCaIojYuZO0iOvXaYBR6K
   Xm+EeV1Qpti3kEquVP3/6v80YXkLGYldnR/8VbbvYVHe+WjUq0iGGKb+S
   kf5vhwWTFztRzMJOiz0LoZCeA1y/fk3HoWx9vu2A62TUBpzfKW0aFsEte
   HhLTtEpW4Eb0sve3ZWvoapb13CL5FXMhBUoYmV1uODA9iFxB4xa+xDA6u
   gs34Z926tRxcrPzmqZK6+8f83jsy2NySkldPWsuPx3Lq+7frmGdZaASSs
   8upFrX5Th9+NhP6Z1Fhvd5bsIR6Tcn9+U08uCM7TgC/nYirDodLaEndMH
   A==;
X-CSE-ConnectionGUID: 7rdXhKc8QC66FPoyIS3/Mg==
X-CSE-MsgGUID: X8fkCEp4RwKMXyaXhigUbw==
X-IronPort-AV: E=McAfee;i="6800,10657,11469"; a="56466692"
X-IronPort-AV: E=Sophos;i="6.16,251,1744095600"; 
   d="scan'208";a="56466692"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2025 02:06:53 -0700
X-CSE-ConnectionGUID: uXfGFCjTSfSYwqCumqHTDA==
X-CSE-MsgGUID: kYjhpG7GQV6+QwHSPwIbtg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,251,1744095600"; 
   d="scan'208";a="156670042"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa005.jf.intel.com with ESMTP; 20 Jun 2025 02:06:49 -0700
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>
Cc: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Babu Moger <babu.moger@amd.com>,
	Ewan Hai <ewanhai-oc@zhaoxin.com>,
	Pu Wen <puwen@hygon.cn>,
	Tao Su <tao1.su@intel.com>,
	Yi Lai <yi1.lai@intel.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH 07/16] i386/cpu: Mark CPUID[0x80000005] as reserved for Intel
Date: Fri, 20 Jun 2025 17:27:25 +0800
Message-Id: <20250620092734.1576677-8-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250620092734.1576677-1-zhao1.liu@intel.com>
References: <20250620092734.1576677-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Per SDM, 0x80000005 leaf is reserved for Intel CPU, and its current
"assert" check blocks adding new cache model for non-AMD CPUs.

And please note, although Zhaoxin mostly follows Intel behavior,
this leaf is an exception [1].

So, add a compat property "x-vendor-cpuid-only-v2" (for PC machine v10.0
and older) to keep the original behavior. For the machine since v10.1,
check the vendor and encode this leaf as all-0 only for Intel CPU.

This fix also resolves 2 FIXMEs of legacy_l1d_cache_amd and
legacy_l1i_cache_amd:

/*FIXME: CPUID leaf 0x80000005 is inconsistent with leaves 2 & 4 */

In addition, per AMD's APM, update the comment of CPUID[0x80000005].

[1]: https://lore.kernel.org/qemu-devel/fa16f7a8-4917-4731-9d9f-7d4c10977168@zhaoxin.com/
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes since RFC:
 * Only set all-0 for Intel CPU.
 * Add x-vendor-cpuid-only-v2.
---
 hw/i386/pc.c      |  1 +
 target/i386/cpu.c | 11 ++++++++---
 target/i386/cpu.h | 11 ++++++++++-
 3 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index ad2d6495ebde..9ec3f4db31f3 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -83,6 +83,7 @@
 
 GlobalProperty pc_compat_10_0[] = {
     { TYPE_X86_CPU, "x-consistent-cache", "false" },
+    { TYPE_X86_CPU, "x-vendor-cpuid-only-v2", "false" },
 };
 const size_t pc_compat_10_0_len = G_N_ELEMENTS(pc_compat_10_0);
 
diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 8f174fb971b6..df40d1362566 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -655,7 +655,6 @@ static CPUCacheInfo legacy_l1d_cache = {
     .share_level = CPU_TOPOLOGY_LEVEL_CORE,
 };
 
-/*FIXME: CPUID leaf 0x80000005 is inconsistent with leaves 2 & 4 */
 static CPUCacheInfo legacy_l1d_cache_amd = {
     .type = DATA_CACHE,
     .level = 1,
@@ -684,7 +683,6 @@ static CPUCacheInfo legacy_l1i_cache = {
     .share_level = CPU_TOPOLOGY_LEVEL_CORE,
 };
 
-/*FIXME: CPUID leaf 0x80000005 is inconsistent with leaves 2 & 4 */
 static CPUCacheInfo legacy_l1i_cache_amd = {
     .type = INSTRUCTION_CACHE,
     .level = 1,
@@ -7889,11 +7887,17 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
         *edx = env->cpuid_model[(index - 0x80000002) * 4 + 3];
         break;
     case 0x80000005:
-        /* cache info (L1 cache) */
+        /* cache info (L1 cache/TLB Associativity Field) */
         if (cpu->cache_info_passthrough) {
             x86_cpu_get_cache_cpuid(index, 0, eax, ebx, ecx, edx);
             break;
         }
+
+        if (cpu->vendor_cpuid_only_v2 && IS_INTEL_CPU(env)) {
+            *eax = *ebx = *ecx = *edx = 0;
+            break;
+        }
+
         *eax = (L1_DTLB_2M_ASSOC << 24) | (L1_DTLB_2M_ENTRIES << 16) |
                (L1_ITLB_2M_ASSOC <<  8) | (L1_ITLB_2M_ENTRIES);
         *ebx = (L1_DTLB_4K_ASSOC << 24) | (L1_DTLB_4K_ENTRIES << 16) |
@@ -9464,6 +9468,7 @@ static const Property x86_cpu_properties[] = {
     DEFINE_PROP_STRING("hv-vendor-id", X86CPU, hyperv_vendor),
     DEFINE_PROP_BOOL("cpuid-0xb", X86CPU, enable_cpuid_0xb, true),
     DEFINE_PROP_BOOL("x-vendor-cpuid-only", X86CPU, vendor_cpuid_only, true),
+    DEFINE_PROP_BOOL("x-vendor-cpuid-only-v2", X86CPU, vendor_cpuid_only_v2, true),
     DEFINE_PROP_BOOL("x-amd-topoext-features-only", X86CPU, amd_topoext_features_only, true),
     DEFINE_PROP_BOOL("lmce", X86CPU, enable_lmce, false),
     DEFINE_PROP_BOOL("l3-cache", X86CPU, enable_l3_cache, true),
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 8d3ce8a2b678..02cda176798f 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -2282,9 +2282,18 @@ struct ArchCPU {
     /* Enable auto level-increase for all CPUID leaves */
     bool full_cpuid_auto_level;
 
-    /* Only advertise CPUID leaves defined by the vendor */
+    /*
+     * Compatibility bits for old machine types (PC machine v6.0 and older).
+     * Only advertise CPUID leaves defined by the vendor.
+     */
     bool vendor_cpuid_only;
 
+    /*
+     * Compatibility bits for old machine types (PC machine v10.0 and older).
+     * Only advertise CPUID leaves defined by the vendor.
+     */
+    bool vendor_cpuid_only_v2;
+
     /* Only advertise TOPOEXT features that AMD defines */
     bool amd_topoext_features_only;
 
-- 
2.34.1


