Return-Path: <kvm+bounces-52128-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 31931B01929
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 12:02:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A5FD21C21DE5
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 10:02:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E51F327EFF3;
	Fri, 11 Jul 2025 10:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="h/FLkaLT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C0B3285404
	for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 10:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752228072; cv=none; b=ExAqtrKHzmUwLIRdmnQVJwp8subXYFKc1qsI1tK7I6OVAMQfBwjqrvKsjaI1hv1TaviB9r6wUOgC8fabI/cRhVY8Wd7t1bXWhAjkexKGlcu9aqgP7gBm7M3vLlo+d+oWAnMOvOioipIDmpICkVfI112Mis7pW3LSP7FimnxU5Zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752228072; c=relaxed/simple;
	bh=OWvNFKsV7hzM+qTU1YrQuD91g8tHqECnL/vc/zNLCno=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uqio8ZlxENwulyPF9m+JmWI0fgvliDdNlZ6D81ROsGqNhBYjczZ5YQWezknjs/EQuUnytbERw6kREDf4cvtvxsCPRaFeXbpUII9UlP/aN7WZsQGw43ad++4lbo1zEsfhe1IYHLPbsaags6jLo6lVnC5p7GqbCibNwZ6Qjr1IX7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=h/FLkaLT; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752228070; x=1783764070;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OWvNFKsV7hzM+qTU1YrQuD91g8tHqECnL/vc/zNLCno=;
  b=h/FLkaLT68fYfZHtcq9+luSrLbvM+yIC/pLKa2LW+cqsRcGMsuodXdki
   qszPganJ+3v/mi+l2PwLgbx2s7fnQrbabvqP9t064raw97KBtYuoP7kM2
   iunZxiNBE/P002l2Hnrx77Wsh85zoBNq9oWnKzOhFx81Rpkc4LTIGPmot
   F8voEEqT5kjMORcCjIkyhWAr51iyG/zh7cZEsqpD2IB+srgqCHPPnDnrB
   jlFJJfZlhIw1DlCRMZA1CClvVj+dbWPrcQLiykXSx6v3jd9I08I4sA+ed
   xGOEyC1randJ2ruKeFyqDQL0d/MsutqV0waY56n4aSsz9Eyx8Y2EXTXWD
   w==;
X-CSE-ConnectionGUID: cQdwMisCQj2rXr0Q3MO/lw==
X-CSE-MsgGUID: 6n2rVettR5anPBgwHW7xYQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11490"; a="54496343"
X-IronPort-AV: E=Sophos;i="6.16,303,1744095600"; 
   d="scan'208";a="54496343"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 03:01:10 -0700
X-CSE-ConnectionGUID: uXa0yX4nQbq6F4DewAEYdQ==
X-CSE-MsgGUID: 2anHszCTTw20zsbfqlyKJw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,303,1744095600"; 
   d="scan'208";a="160662076"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa003.jf.intel.com with ESMTP; 11 Jul 2025 03:01:05 -0700
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
Subject: [PATCH v2 10/18] i386/cpu: Fix CPUID[0x80000006] for Intel CPU
Date: Fri, 11 Jul 2025 18:21:35 +0800
Message-Id: <20250711102143.1622339-11-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250711102143.1622339-1-zhao1.liu@intel.com>
References: <20250711102143.1622339-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Per SDM, Intel supports CPUID[0x80000006]. But only L2 information is
encoded in ECX (note that L2 associativity field encodings rules
consistent with AMD are used), all other fields are reserved.

Therefore, make the following changes to CPUID[0x80000006]:
 * Check the vendor in CPUID[0x80000006] and just encode L2 to ECX for
   Intel.
 * Drop the lines_per_tag assertion, since AMD supports this field but
   Intel doesn't. And this field can be easily checked via cpuid tool
   in Guest.
 * Apply the encoding change of Intel for Zhaoxin as well [1].

This fix also resolves the FIXME of legacy_l2_cache_amd:

/*FIXME: CPUID leaf 0x80000006 is inconsistent with leaves 2 & 4 */

In addition, per AMD's APM, update the comment of CPUID[0x80000006].

[1]: https://lore.kernel.org/qemu-devel/c522ebb5-04d5-49c6-9ad8-d755b8998988@zhaoxin.com/

Tested-by: Yi Lai <yi1.lai@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes Since v1:
 * Drop the lines_per_tag assertion in encode_cache_cpuid80000006(),
   since it breaks the case running Intel CPUs (with cache model) on
   PC/Q35 machine v10.0.

Changes Since RFC:
 * Check vendor_cpuid_only_v2 instead of vendor_cpuid_only.
 * Move lines_per_tag assert check into encode_cache_cpuid80000006().
---
 target/i386/cpu.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index e0d5a39e477c..609efb10ddb5 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -529,16 +529,15 @@ static void encode_cache_cpuid80000006(CPUCacheInfo *l2,
 {
     assert(l2->size % 1024 == 0);
     assert(l2->associativity > 0);
-    assert(l2->lines_per_tag > 0);
     assert(l2->line_size > 0);
     *ecx = ((l2->size / 1024) << 16) |
            (X86_ENC_ASSOC(l2->associativity) << 12) |
            (l2->lines_per_tag << 8) | (l2->line_size);
 
+    /* For Intel, EDX is reserved. */
     if (l3) {
         assert(l3->size % (512 * 1024) == 0);
         assert(l3->associativity > 0);
-        assert(l3->lines_per_tag > 0);
         assert(l3->line_size > 0);
         *edx = ((l3->size / (512 * 1024)) << 18) |
                (X86_ENC_ASSOC(l3->associativity) << 12) |
@@ -710,7 +709,6 @@ static CPUCacheInfo legacy_l2_cache = {
     .share_level = CPU_TOPOLOGY_LEVEL_CORE,
 };
 
-/*FIXME: CPUID leaf 0x80000006 is inconsistent with leaves 2 & 4 */
 static CPUCacheInfo legacy_l2_cache_amd = {
     .type = UNIFIED_CACHE,
     .level = 2,
@@ -7902,11 +7900,20 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
         *edx = encode_cache_cpuid80000005(env->cache_info_amd.l1i_cache);
         break;
     case 0x80000006:
-        /* cache info (L2 cache) */
+        /* cache info (L2 cache/TLB/L3 cache) */
         if (cpu->cache_info_passthrough) {
             x86_cpu_get_cache_cpuid(index, 0, eax, ebx, ecx, edx);
             break;
         }
+
+        if (cpu->vendor_cpuid_only_v2 &&
+            (IS_INTEL_CPU(env) || IS_ZHAOXIN_CPU(env))) {
+            *eax = *ebx = 0;
+            encode_cache_cpuid80000006(env->cache_info_cpuid4.l2_cache,
+                                       NULL, ecx, edx);
+            break;
+        }
+
         *eax = (X86_ENC_ASSOC(L2_DTLB_2M_ASSOC) << 28) |
                (L2_DTLB_2M_ENTRIES << 16) |
                (X86_ENC_ASSOC(L2_ITLB_2M_ASSOC) << 12) |
@@ -7915,6 +7922,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
                (L2_DTLB_4K_ENTRIES << 16) |
                (X86_ENC_ASSOC(L2_ITLB_4K_ASSOC) << 12) |
                (L2_ITLB_4K_ENTRIES);
+
         encode_cache_cpuid80000006(env->cache_info_amd.l2_cache,
                                    cpu->enable_l3_cache ?
                                    env->cache_info_amd.l3_cache : NULL,
-- 
2.34.1


