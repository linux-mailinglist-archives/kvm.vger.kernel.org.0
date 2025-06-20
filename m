Return-Path: <kvm+bounces-50033-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 77973AE1700
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 11:07:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 817627AA4AB
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 09:05:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 411F327FD56;
	Fri, 20 Jun 2025 09:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ER6ZsE/Y"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E341727FB1B
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 09:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750410405; cv=none; b=eCz/okTpPTYGEffXgI0f9l7qCBKH0OKfwV5aU1DhvK6qeCkej3lFlfscAjWF0aEGAvOthKqsu4+1upvAeBew9BoAJXyH6boaELZw86ZOjBLrZgZV4gQbqPgVe17k70/wOEYKsifuwzAP9GN38b7gypBsqC0G7m7/H+Or8710FK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750410405; c=relaxed/simple;
	bh=65qXWX5jHQ5ZGTW9Q8QusnykV+YUDGSqPzotpWRYlLo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=S7mRbT0OqdlE7orD1XuPEYVk8faGgbOoSytHYg7otwgNriNL1Sj1HoZpItq8AK68TQLPHdFFn1CpLaa/ZLgPRZAquy6q4E+3jbyHO3Ssg59oCeG2gH5/pBMnlXSA889qXxEsb6qos+PiAz1KWSSxc/KvtANfGBCPKCO31WqBR50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ER6ZsE/Y; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750410404; x=1781946404;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=65qXWX5jHQ5ZGTW9Q8QusnykV+YUDGSqPzotpWRYlLo=;
  b=ER6ZsE/Yh7hQcp5scKo4bEOUcbgYhzMt+DNSCw3ps9UoUpaU66a8An1O
   V18j9YOX6TM2KjteEdMklKnmzNdnBuOsvYi/ZxPd61+xXjERj6u+PQvgA
   myNUq+/kDzeim+XUhFEwPPpCumRvO1P/sm5KB1ePx/3eSEmWSDDqjyaAj
   YpWQhnQw7bncc77fMVC/246C/4e//G1y292+BJSWtVmVKpXLNMoLftaZN
   6tAGQ5qGZTnGMqaFPtgUgd46ZQF4gz4ZUSwyyM/4zw+dGf0HhHAm55tU0
   0Rt/rnD2H2v19vJ1Y09BRxb1BC1GFr2lxntDRCHvApT8vb7UfZ+NWsgZr
   g==;
X-CSE-ConnectionGUID: OVivdS+QQzKGoabbnN72rQ==
X-CSE-MsgGUID: 9HstMg0TQIe3WTriqTwS4g==
X-IronPort-AV: E=McAfee;i="6800,10657,11469"; a="56466615"
X-IronPort-AV: E=Sophos;i="6.16,251,1744095600"; 
   d="scan'208";a="56466615"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2025 02:06:44 -0700
X-CSE-ConnectionGUID: VYLEjsR1SOGnzxmIf8l0CA==
X-CSE-MsgGUID: N3+QkdSwTW2eRz8dwn0pIw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,251,1744095600"; 
   d="scan'208";a="156669950"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa005.jf.intel.com with ESMTP; 20 Jun 2025 02:06:40 -0700
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
Subject: [PATCH 05/16] i386/cpu: Consolidate CPUID 0x4 leaf
Date: Fri, 20 Jun 2025 17:27:23 +0800
Message-Id: <20250620092734.1576677-6-zhao1.liu@intel.com>
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

Modern Intel CPUs use CPUID 0x4 leaf to describe cache information
and leave space in 0x2 for prefetch and TLBs (even TLB has its own leaf
CPUID 0x18).

And 0x2 leaf provides a descriptor 0xFF to instruct software to check
cache information in 0x4 leaf instead.

Therefore, follow this behavior to encode 0xFF when Intel CPU has 0x4
leaf with "x-consistent-cache=true" for compatibility.

In addition, for older CPUs without 0x4 leaf, still enumerate the cache
descriptor in 0x2 leaf, except the case that there's no descriptor
matching the cache model, then directly encode 0xFF in 0x2 leaf. This
makes sense, as in the 0x2 leaf era, all supported caches should have
the corresponding descriptor.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/cpu.c | 48 ++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 37 insertions(+), 11 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 2f895bf13523..a06aa1d629dc 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -223,7 +223,7 @@ struct CPUID2CacheDescriptorInfo cpuid2_cache_descriptors[] = {
  * Return a CPUID 2 cache descriptor for a given cache.
  * If no known descriptor is found, return CACHE_DESCRIPTOR_UNAVAILABLE
  */
-static uint8_t cpuid2_cache_descriptor(CPUCacheInfo *cache)
+static uint8_t cpuid2_cache_descriptor(CPUCacheInfo *cache, bool *unmacthed)
 {
     int i;
 
@@ -240,9 +240,44 @@ static uint8_t cpuid2_cache_descriptor(CPUCacheInfo *cache)
             }
     }
 
+    *unmacthed |= true;
     return CACHE_DESCRIPTOR_UNAVAILABLE;
 }
 
+/* Encode cache info for CPUID[4] */
+static void encode_cache_cpuid2(X86CPU *cpu,
+                                uint32_t *eax, uint32_t *ebx,
+                                uint32_t *ecx, uint32_t *edx)
+{
+    CPUX86State *env = &cpu->env;
+    CPUCaches *caches = &env->cache_info_cpuid2;
+    int l1d, l1i, l2, l3;
+    bool unmatched = false;
+
+    *eax = 1; /* Number of CPUID[EAX=2] calls required */
+    *ebx = *ecx = *edx = 0;
+
+    l1d = cpuid2_cache_descriptor(caches->l1d_cache, &unmatched);
+    l1i = cpuid2_cache_descriptor(caches->l1i_cache, &unmatched);
+    l2 = cpuid2_cache_descriptor(caches->l2_cache, &unmatched);
+    l3 = cpuid2_cache_descriptor(caches->l3_cache, &unmatched);
+
+    if (!cpu->consistent_cache ||
+        (env->cpuid_min_level < 0x4 && !unmatched)) {
+        /*
+         * Though SDM defines code 0x40 for cases with no L2 or L3. It's
+         * also valid to just ignore l3's code if there's no l2.
+         */
+        if (cpu->enable_l3_cache) {
+            *ecx = l3;
+        }
+        *edx = (l1d << 16) | (l1i <<  8) | l2;
+    } else {
+        *ecx = 0;
+        *edx = CACHE_DESCRIPTOR_UNAVAILABLE;
+    }
+}
+
 /* CPUID Leaf 4 constants: */
 
 /* EAX: */
@@ -7451,16 +7486,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
             *eax = *ebx = *ecx = *edx = 0;
             break;
         }
-        *eax = 1; /* Number of CPUID[EAX=2] calls required */
-        *ebx = 0;
-        if (!cpu->enable_l3_cache) {
-            *ecx = 0;
-        } else {
-            *ecx = cpuid2_cache_descriptor(env->cache_info_cpuid2.l3_cache);
-        }
-        *edx = (cpuid2_cache_descriptor(env->cache_info_cpuid2.l1d_cache) << 16) |
-               (cpuid2_cache_descriptor(env->cache_info_cpuid2.l1i_cache) <<  8) |
-               (cpuid2_cache_descriptor(env->cache_info_cpuid2.l2_cache));
+        encode_cache_cpuid2(cpu, eax, ebx, ecx, edx);
         break;
     case 4:
         /* cache info: needed for Core compatibility */
-- 
2.34.1


