Return-Path: <kvm+bounces-52135-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 96805B01937
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 12:02:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8C783540B88
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 10:02:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 292A9283CB0;
	Fri, 11 Jul 2025 10:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Anpcewr1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB52E27FB10
	for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 10:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752228106; cv=none; b=jEAkuwJS0UmwpJlyMqM0V2sv1QeceP80idNXajgzyjH+DOzEhFnB08bgogDWEYvHf9pu2/hKaJXYYz//jP9vA07tn+yAjn8twV71ggWJ5fY/6i+MnJfwR/41kmXi2Cnp/XlbAzzQ6tU5+dmb6iYSI95lZxa3g1X6OZnDyEShHTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752228106; c=relaxed/simple;
	bh=XIdoThL/w+88qJ0nzFUPEXeYz1YyOXsdwaPKHQb2Un8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bdt4poX5Pg4YMjxHJMx+thYq1JWeaMpmTrEvaj/PyNWa45mHdPw9ZyNhm6Qngl3dhXqKzfiUS1pTszl9m+tNf+mqmi5aAir+1VIvo3lAelb/92MsIzK5DJ5QnFradI7nS5hsP8x+AxGhLCRwai/yzgRdgLNHsoGfJ8+bXNehP18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Anpcewr1; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752228105; x=1783764105;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XIdoThL/w+88qJ0nzFUPEXeYz1YyOXsdwaPKHQb2Un8=;
  b=Anpcewr19SCpPsj2lrP1spDR2f+wANiF4szXDrIcOoVz6/M7zOYCOPFV
   SctuqACJ9T1hjQtnz8kE1+M0QjfyhDp2He0QbROf87re63mdTseva1lwJ
   sFAvndJBhm956hzQXTqs+x3v2z+wNAlRcWO7ZjdKbfiV56BDCwnJilha4
   ZGBn34Gk2zCQd/KwD73vD2BOFUNFFR5IxDf2eXlntjOA4LRvPR2O7GMHg
   8cPWsm2b3mKU6sjD9JQmoCCmR0zru3Bq8s148oo3nCNaoBLEUeuzclt0K
   sv5HNLfSwIGADBAEhKXKT48ZUJ9JJu4sryTpCxhSONsSF8YZpn2sckJ4t
   Q==;
X-CSE-ConnectionGUID: 6YgznAp6SDGR61uouzvS4A==
X-CSE-MsgGUID: yZDWvuQ7TPSnkr8HZ0sa5Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11490"; a="54496449"
X-IronPort-AV: E=Sophos;i="6.16,303,1744095600"; 
   d="scan'208";a="54496449"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 03:01:45 -0700
X-CSE-ConnectionGUID: VE1FAdX3SfqhL5gNMRIQvQ==
X-CSE-MsgGUID: vdtHbcFEQEqYm/U0kIVTnw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,303,1744095600"; 
   d="scan'208";a="160662159"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa003.jf.intel.com with ESMTP; 11 Jul 2025 03:01:40 -0700
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
Subject: [PATCH v2 17/18] i386/cpu: Select legacy cache model based on vendor in CPUID 0x8000001D
Date: Fri, 11 Jul 2025 18:21:42 +0800
Message-Id: <20250711102143.1622339-18-zhao1.liu@intel.com>
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

As preparation for merging cache_info_cpuid4 and cache_info_amd in
X86CPUState, set legacy cache model based on vendor in the CPUID
0x8000001D leaf. For AMD CPU, select legacy AMD cache model (in
cache_info_amd) as the default cache model like before, otherwise,
select legacy Intel cache model (in cache_info_cpuid4).

In fact, for Intel (and Zhaoxin) CPU, this change is safe because the
extended CPUID level supported by Intel is up to 0x80000008. So Intel
Guest doesn't have this 0x8000001D leaf.

Although someone could bump "xlevel" up to 0x8000001D for Intel Guest,
it's meaningless and this is undefined behavior. This leaf should be
considered reserved, but the SDM does not explicitly state this. So,
there's no need to specifically use vendor_cpuid_only_v2 to fix
anything, as it doesn't even qualify as a fix since nothing is
currently broken.

Therefore, it is acceptable to select the default legacy cache model
based on the vendor.

For the CPUID 0x8000001D leaf, in X86CPUState, a unified cache_info is
enough. It only needs to be initialized and configured with the
corresponding legacy cache model based on the vendor.

Tested-by: Yi Lai <yi1.lai@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/cpu.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index fe1c118b284f..df13dbc63a3f 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -8082,7 +8082,22 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
             *edx = 0;
         }
         break;
-    case 0x8000001D:
+    case 0x8000001D: {
+        const CPUCaches *caches;
+
+        /*
+         * FIXME: Temporarily select cache info model here based on
+         * vendor, and merge these 2 cache info models later.
+         *
+         * Intel doesn't support this leaf so that Intel Guests don't
+         * have this leaf. This change is harmless to Intel CPUs.
+         */
+        if (IS_AMD_CPU(env)) {
+            caches = &env->cache_info_amd;
+        } else {
+            caches = &env->cache_info_cpuid4;
+        }
+
         *eax = 0;
         if (cpu->cache_info_passthrough) {
             x86_cpu_get_cache_cpuid(index, count, eax, ebx, ecx, edx);
@@ -8090,19 +8105,19 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
         }
         switch (count) {
         case 0: /* L1 dcache info */
-            encode_cache_cpuid8000001d(env->cache_info_amd.l1d_cache,
+            encode_cache_cpuid8000001d(caches->l1d_cache,
                                        topo_info, eax, ebx, ecx, edx);
             break;
         case 1: /* L1 icache info */
-            encode_cache_cpuid8000001d(env->cache_info_amd.l1i_cache,
+            encode_cache_cpuid8000001d(caches->l1i_cache,
                                        topo_info, eax, ebx, ecx, edx);
             break;
         case 2: /* L2 cache info */
-            encode_cache_cpuid8000001d(env->cache_info_amd.l2_cache,
+            encode_cache_cpuid8000001d(caches->l2_cache,
                                        topo_info, eax, ebx, ecx, edx);
             break;
         case 3: /* L3 cache info */
-            encode_cache_cpuid8000001d(env->cache_info_amd.l3_cache,
+            encode_cache_cpuid8000001d(caches->l3_cache,
                                        topo_info, eax, ebx, ecx, edx);
             break;
         default: /* end of info */
@@ -8113,6 +8128,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
             *edx &= CACHE_NO_INVD_SHARING | CACHE_INCLUSIVE;
         }
         break;
+    }
     case 0x8000001E:
         if (cpu->core_id <= 255) {
             encode_topo_cpuid8000001e(cpu, topo_info, eax, ebx, ecx, edx);
-- 
2.34.1


