Return-Path: <kvm+bounces-52127-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A8A2B01922
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 12:01:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 19C834A22D7
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 10:01:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B33F27FD4E;
	Fri, 11 Jul 2025 10:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KpXJ1RF+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD51A284B56
	for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 10:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752228067; cv=none; b=FMCkfLNp7wMLicusNyQVdhhVG6xezrn8J8MiBTd9/sR0rFIIvsEihCd45CtGblrfck6os/gtLCfaENYxyfnt235kvfI+tfDsTaofLTZ4IQalNi1m3TB253Zg3NegEbwTKjrscuaqNmTXEqhg/IwOduLGyRRAuM0YMC7nQH0Q0DA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752228067; c=relaxed/simple;
	bh=m/3V6uk+n+NZ1SFoxeznqGZElzksyaiZeYkUPu8QMoI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dHVzMKgvWkpQb6fr6pgksyUUd1jXXgVZ9gurKd8Fd9JDXiC+c1ggtR3j3kfyQveWw9wpeHKpV3m22urY21SMV14v2cWmxg9Wlx5AFiuZzHI2FOp4kZPCGqW0/gF27/gOHw5hxnqEw+E6VEODAQ4InAVuDOYDnbzwyAr3g2jdkxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KpXJ1RF+; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752228066; x=1783764066;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=m/3V6uk+n+NZ1SFoxeznqGZElzksyaiZeYkUPu8QMoI=;
  b=KpXJ1RF+4A6uz9S5UtKD8HeI4Ro0ZL9n5IVUfhEAhj1fSLyBvtrcYKIg
   D9Qatl/zvGhzzg3IY2kfwo3GyqHre3rv5Dnvau4GYeC7GOuJJSqgV8V8y
   Ogrk5ExtI0gYPOJRgJIXoBcTY/J6br8LU2xjC0mCDhUCdFAIGHFH3BiJv
   vP01fBiRT8W3uzWKE+0gvR+XPyTctxyHiUi7I5qbxuqhejsBRntCArB+4
   VGBS3i5Le4JsMRnf+dvGJD6rl2IqZMhRreot/au5LKq1CR9a2eYs9T/zG
   3eU/Y30Gw+ehY5VFp0t6R401psRkDqE9dKH1ZECMvGKyisIzbIO5DYrnH
   g==;
X-CSE-ConnectionGUID: WWyRjXcVR++wiCTsr5kVxA==
X-CSE-MsgGUID: AkVJXYJSTHycHET9iKTAhg==
X-IronPort-AV: E=McAfee;i="6800,10657,11490"; a="54496325"
X-IronPort-AV: E=Sophos;i="6.16,303,1744095600"; 
   d="scan'208";a="54496325"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 03:01:05 -0700
X-CSE-ConnectionGUID: evhk2FJkTOS7fU+EyNZjgA==
X-CSE-MsgGUID: KyTMyk8lRNOLMW+rqHZ91A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,303,1744095600"; 
   d="scan'208";a="160662069"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa003.jf.intel.com with ESMTP; 11 Jul 2025 03:01:01 -0700
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
Subject: [PATCH v2 09/18] i386/cpu: Rename AMD_ENC_ASSOC to X86_ENC_ASSOC
Date: Fri, 11 Jul 2025 18:21:34 +0800
Message-Id: <20250711102143.1622339-10-zhao1.liu@intel.com>
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

Rename AMD_ENC_ASSOC to X86_ENC_ASSOC since Intel also uses the same
rules.

While there are some slight differences between the rules in AMD APM
v4.07 no.40332 and Intel. But considerring the needs of current QEMU,
generally they are consistent and current AMD_ENC_ASSOC can be applied
for Intel CPUs..

Tested-by: Yi Lai <yi1.lai@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes Since v1:
 * Spilt this cleanup as a seperate patch.
---
 target/i386/cpu.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 6ab199c9a112..e0d5a39e477c 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -505,8 +505,8 @@ static uint32_t encode_cache_cpuid80000005(CPUCacheInfo *cache)
 
 #define ASSOC_FULL 0xFF
 
-/* AMD associativity encoding used on CPUID Leaf 0x80000006: */
-#define AMD_ENC_ASSOC(a) (a <=   1 ? a   : \
+/* x86 associativity encoding used on CPUID Leaf 0x80000006: */
+#define X86_ENC_ASSOC(a) (a <=   1 ? a   : \
                           a ==   2 ? 0x2 : \
                           a ==   4 ? 0x4 : \
                           a ==   8 ? 0x6 : \
@@ -532,7 +532,7 @@ static void encode_cache_cpuid80000006(CPUCacheInfo *l2,
     assert(l2->lines_per_tag > 0);
     assert(l2->line_size > 0);
     *ecx = ((l2->size / 1024) << 16) |
-           (AMD_ENC_ASSOC(l2->associativity) << 12) |
+           (X86_ENC_ASSOC(l2->associativity) << 12) |
            (l2->lines_per_tag << 8) | (l2->line_size);
 
     if (l3) {
@@ -541,7 +541,7 @@ static void encode_cache_cpuid80000006(CPUCacheInfo *l2,
         assert(l3->lines_per_tag > 0);
         assert(l3->line_size > 0);
         *edx = ((l3->size / (512 * 1024)) << 18) |
-               (AMD_ENC_ASSOC(l3->associativity) << 12) |
+               (X86_ENC_ASSOC(l3->associativity) << 12) |
                (l3->lines_per_tag << 8) | (l3->line_size);
     } else {
         *edx = 0;
@@ -7907,13 +7907,13 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
             x86_cpu_get_cache_cpuid(index, 0, eax, ebx, ecx, edx);
             break;
         }
-        *eax = (AMD_ENC_ASSOC(L2_DTLB_2M_ASSOC) << 28) |
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
         encode_cache_cpuid80000006(env->cache_info_amd.l2_cache,
                                    cpu->enable_l3_cache ?
-- 
2.34.1


