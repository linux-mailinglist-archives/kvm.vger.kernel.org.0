Return-Path: <kvm+bounces-50043-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DF81AAE1715
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 11:07:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3D76F19E425D
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 09:08:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32B2727FD6E;
	Fri, 20 Jun 2025 09:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="P20Ec1nS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECE5C27FB35
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 09:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750410450; cv=none; b=KMxTvqWD/lNamDDXSUAgqeL0R5tp/aw1vtHd5zd/buptaWngFOFx4dhpUx2g5CIJYhMXisHLqUDdWWb/4NqjKerOtOMONTFAU4jNnFFLmbFo3LJvhzk8U+N/byLOczZGSoodkWqEG18kH+DKQ5oYI+AivaXEogb6XKXxx58Q2q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750410450; c=relaxed/simple;
	bh=lh9RIWNb8fbwwbj3bBbTOmbr82tAR9PK8zJMLq0s76U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=s1cazJwJeYA6wyXQOIq65gl9VOlHfYfm9hgopQQaU52hfIYyKw6W9zISarJmJ5iE4RNwQDhSaYEAI33XyZfshXqZ6Q+lsS8XP5tHQsFhVeAonTaFPOLMYHvho6Yci6gD4U99xCsmraFESkT1Z0PTpLs5gypqRyACGBCT5f1NZ3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=P20Ec1nS; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750410449; x=1781946449;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lh9RIWNb8fbwwbj3bBbTOmbr82tAR9PK8zJMLq0s76U=;
  b=P20Ec1nSZdkVFjRPXXHi4KOCxzOu9dPPGTt4qfA9kVO+K4QybrmEGDiz
   WQd0Pyflt8kNJAmlaTYMR0ee9wO1dmJgpedMIhPpJYi1EpTibLM+oG8HP
   Z2odVQA9oeics/7wtuVWWbwniR60/IT3iadLlFaZ5a4EkuvpFACmzb7ll
   4yGV/oH9M7F3hWqHJLeL2V7Co0+aevtOjB/pSjeZroFgHzqiunuNUecBO
   tG3rY/6hsp9JVHtb1Hb2+QVRG6GhdqWAYFOfessE3cLkinExZ8kQC2XOh
   xscab1bNbiciSx8JSeMFKZF4E1lpm0JrWQZ0IwKBILWs4Nor/K+oLGG1j
   A==;
X-CSE-ConnectionGUID: pZyWVGx1Ste4Tf1WglkCig==
X-CSE-MsgGUID: YkGw5oYeRhahbnfCxN4gCA==
X-IronPort-AV: E=McAfee;i="6800,10657,11469"; a="56466844"
X-IronPort-AV: E=Sophos;i="6.16,251,1744095600"; 
   d="scan'208";a="56466844"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2025 02:07:29 -0700
X-CSE-ConnectionGUID: poMZEsFRTbOjvohkAsR8OQ==
X-CSE-MsgGUID: U8+wHQ3oQb6GMJ50crTdvA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,251,1744095600"; 
   d="scan'208";a="156670194"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa005.jf.intel.com with ESMTP; 20 Jun 2025 02:07:25 -0700
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
Subject: [PATCH 15/16] i386/cpu: Select legacy cache model based on vendor in CPUID 0x8000001D
Date: Fri, 20 Jun 2025 17:27:33 +0800
Message-Id: <20250620092734.1576677-16-zhao1.liu@intel.com>
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

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/cpu.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 4fa5907027a0..4e9ac37850c0 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -8089,7 +8089,22 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
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
@@ -8097,19 +8112,19 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
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
@@ -8120,6 +8135,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
             *edx &= CACHE_NO_INVD_SHARING | CACHE_INCLUSIVE;
         }
         break;
+    }
     case 0x8000001E:
         if (cpu->core_id <= 255) {
             encode_topo_cpuid8000001e(cpu, topo_info, eax, ebx, ecx, edx);
-- 
2.34.1


