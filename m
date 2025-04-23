Return-Path: <kvm+bounces-43921-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F801A98881
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 13:26:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 921B21886AEA
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 11:26:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3C91270540;
	Wed, 23 Apr 2025 11:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YN+woeox"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BF8426FA5D
	for <kvm@vger.kernel.org>; Wed, 23 Apr 2025 11:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745407580; cv=none; b=J/d7ixGMdCU8EPSH1cVlzvduXIvPLspCMauYBJLdrIJqiVv1wNuJm4/QJFaxOBKRFapnLArWhrJ4+n0UABhPVI5yKyCZj4qQrqSPX9BbrquCN+njbt79hLfA1AUsh8u7RxGKXJIameZVc6CPcyTeTo8hChlRjCEiAAwtp8PxPtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745407580; c=relaxed/simple;
	bh=1ySg7f0MXv81a/sh1bBBvbxV263DWqo05jeGhcaGOgU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QxIJiK71VWI6MMKgYTPPd+aSu9mdztJ1RcnYz32TZP0LVbso55Hj5WqutdlbWzk0NDamfZq13yNJ4efjcZ0yvFoH7wBzPcfy04a4bcfAu00YdPYR5YWnXJ5kzuvY+ReOAHAKLeBv//9mEHNG1xRZxZ/fHaEq45f7lDDLgKzExlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YN+woeox; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745407578; x=1776943578;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1ySg7f0MXv81a/sh1bBBvbxV263DWqo05jeGhcaGOgU=;
  b=YN+woeoxHg4789heWXXFGn6tZuIFtCC8Gqd6Xcash2PrjLtOkQRtV8gB
   r5q2MfNSGWbkNQt/seLDRUJhj7IIvG/Rjt4CTGJjhrgTsAqVhVxQT6H/y
   +WzlxGMpiwMqp1q5P9pfSplddAtzEtOG3cD7TNYBpJLqiRyL3jr01ru1/
   7SAtB0uX03Nt6hrIqsTDcn6McatemAxDK+TcgZ35H78pk5oB9kI+tEqE6
   dlRAS8W+eII9zvA+O0YnRGObpJmuRcAb6mByz6Sx/DdpXbXbHY/aYFaM1
   dpzAXyfQ5KYNvcHfJ7BbXjtl7Z7qTpBdl0g26/WGQpFhd0TODEK/SbehD
   w==;
X-CSE-ConnectionGUID: bItJ/I6TS26neOSa5fFXJw==
X-CSE-MsgGUID: 6N2ovaAHTV+/xV1WT5GPRA==
X-IronPort-AV: E=McAfee;i="6700,10204,11411"; a="50825261"
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="50825261"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2025 04:26:18 -0700
X-CSE-ConnectionGUID: J/zQ7+W7SpG7028dkKk6iw==
X-CSE-MsgGUID: 0bwUUFdxSS+gDtdPahEu6A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="137150732"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa003.jf.intel.com with ESMTP; 23 Apr 2025 04:26:15 -0700
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>
Cc: Babu Moger <babu.moger@amd.com>,
	Ewan Hai <ewanhai-oc@zhaoxin.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Tejus GK <tejus.gk@nutanix.com>,
	Jason Zeng <jason.zeng@intel.com>,
	Manish Mishra <manish.mishra@nutanix.com>,
	Tao Su <tao1.su@intel.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [RFC 02/10] i386/cpu: Fix CPUID[0x80000006] for Intel CPU
Date: Wed, 23 Apr 2025 19:46:54 +0800
Message-Id: <20250423114702.1529340-3-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250423114702.1529340-1-zhao1.liu@intel.com>
References: <20250423114702.1529340-1-zhao1.liu@intel.com>
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
 * Rename AMD_ENC_ASSOC to X86_ENC_ASSOC since Intel also uses the same
   rules. (While there are some slight differences between the rules in
   AMD APM v4.07 no.40332 and those in the current QEMU, generally they
   are consistent.)
 * Check the vendor in CPUID[0x80000006] and just encode L2 to ECX for
   Intel.
 * Assert L2's lines_per_tag is not 0 for AMD, and assert it is 0 for
   Intel.
 * Apply the encoding change of Intel for Zhaoxin as well.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/cpu.c | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 8fdafa8aedaf..5119d7aa4150 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -436,8 +436,8 @@ static uint32_t encode_cache_cpuid80000005(CPUCacheInfo *cache)
 
 #define ASSOC_FULL 0xFF
 
-/* AMD associativity encoding used on CPUID Leaf 0x80000006: */
-#define AMD_ENC_ASSOC(a) (a <=   1 ? a   : \
+/* x86 associativity encoding used on CPUID Leaf 0x80000006: */
+#define X86_ENC_ASSOC(a) (a <=   1 ? a   : \
                           a ==   2 ? 0x2 : \
                           a ==   4 ? 0x4 : \
                           a ==   8 ? 0x6 : \
@@ -460,19 +460,19 @@ static void encode_cache_cpuid80000006(CPUCacheInfo *l2,
 {
     assert(l2->size % 1024 == 0);
     assert(l2->associativity > 0);
-    assert(l2->lines_per_tag > 0);
     assert(l2->line_size > 0);
     *ecx = ((l2->size / 1024) << 16) |
-           (AMD_ENC_ASSOC(l2->associativity) << 12) |
+           (X86_ENC_ASSOC(l2->associativity) << 12) |
            (l2->lines_per_tag << 8) | (l2->line_size);
 
+    /* For Intel, EDX is reserved. */
     if (l3) {
         assert(l3->size % (512 * 1024) == 0);
         assert(l3->associativity > 0);
         assert(l3->lines_per_tag > 0);
         assert(l3->line_size > 0);
         *edx = ((l3->size / (512 * 1024)) << 18) |
-               (AMD_ENC_ASSOC(l3->associativity) << 12) |
+               (X86_ENC_ASSOC(l3->associativity) << 12) |
                (l3->lines_per_tag << 8) | (l3->line_size);
     } else {
         *edx = 0;
@@ -7277,15 +7277,25 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
         if (cpu->cache_info_passthrough) {
             x86_cpu_get_cache_cpuid(index, 0, eax, ebx, ecx, edx);
             break;
+        } else if (cpu->vendor_cpuid_only &&
+            (IS_INTEL_CPU(env) || IS_ZHAOXIN_CPU(env))) {
+            *eax = *ebx = 0;
+            assert(env->cache_info_cpuid4.l2_cache->lines_per_tag == 0);
+            encode_cache_cpuid80000006(env->cache_info_cpuid4.l2_cache,
+                                       NULL, ecx, edx);
+            break;
         }
-        *eax = (AMD_ENC_ASSOC(L2_DTLB_2M_ASSOC) << 28) |
+
+        *eax = (X86_ENC_ASSOC(L2_DTLB_2M_ASSOC) << 28) |
                (L2_DTLB_2M_ENTRIES << 16) |
-               (AMD_ENC_ASSOC(L2_ITLB_2M_ASSOC) << 12) |
+               (X86_ENC_ASSOC(L2_ITLB_2M_ASSOC) << 12) |
                (L2_ITLB_2M_ENTRIES);
-        *ebx = (AMD_ENC_ASSOC(L2_DTLB_4K_ASSOC) << 28) |
+        *ebx = (X86_ENC_ASSOC(L2_DTLB_4K_ASSOC) << 28) |
                (L2_DTLB_4K_ENTRIES << 16) |
-               (AMD_ENC_ASSOC(L2_ITLB_4K_ASSOC) << 12) |
+               (X86_ENC_ASSOC(L2_ITLB_4K_ASSOC) << 12) |
                (L2_ITLB_4K_ENTRIES);
+
+        assert(env->cache_info_amd.l2_cache->lines_per_tag > 0);
         encode_cache_cpuid80000006(env->cache_info_amd.l2_cache,
                                    cpu->enable_l3_cache ?
                                    env->cache_info_amd.l3_cache : NULL,
-- 
2.34.1


