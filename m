Return-Path: <kvm+bounces-43922-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DD156A98880
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 13:26:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6D9175A28F7
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 11:26:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AB9E270543;
	Wed, 23 Apr 2025 11:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mm0+l9pI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94AB426FA5D
	for <kvm@vger.kernel.org>; Wed, 23 Apr 2025 11:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745407584; cv=none; b=IXk9l9abHkKlSKww0m2AaoLhfvpY7nOmpXkmkiqxtaJ3Zw6KdMJ6sdCfvgqdoxbT2Omsv/A5YU6qvM+4CzJLOzOzsz1BFjz6DCncPJcnehKEb4eEX25MPEvXxa9NVhVzrrPgBoZz9qWxTCwToCBzj5Rfx9/aUTX4rWA/0D+i/ZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745407584; c=relaxed/simple;
	bh=DWV0ttQHTzPj0FFESWYb24ft3P52op6rUaPCLN5CaJY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gIkpqLdrTHVgO/JvMt3EjqVnsn3CrcjXZoGBOVzhPwCD6ey+Wl3syAdJ1W03EW7JwYyEA4dHle5+CD7Bj10XwAxjmNpz0g3XqWxcDmF5JQGDQceisvU4bvqVunhBEbBBR3K+tS148x2fd35WLi0jaxU77af4g/jIeyZXLWWpQlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mm0+l9pI; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745407582; x=1776943582;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DWV0ttQHTzPj0FFESWYb24ft3P52op6rUaPCLN5CaJY=;
  b=mm0+l9pI5WjC6B800mGNbMzxg0V/UnhbRfhTI0sM90ppamvbjLNfM1K2
   jzc+ZvYyrYc/gfP4jN/iOBaxJCeK4MKP89kk03XthbQkMV/HZtorY2Oiu
   MyzQfSVJJoKTtNmrSymGxkatgak4b2tAszQVHBm5+PQVLWch+dKCXTdL+
   SWRI/PvxvgldZsZQHgvV5MKy7VRRC+Fkc1+mPwzP1MBIGxLh5hgVcCu6z
   JPGKeqBg5hp3ot+1ifmodAdcppNJLwKkDyetTssYUb74WT1eKW5V8P9Fm
   9VJLGV4AW4NW4a+jgzs9XFVHTBA1RnmXXzKaykr68n7GWHDUrZUefheJ0
   g==;
X-CSE-ConnectionGUID: 8SM2ThaITauJVhPw95Y7sQ==
X-CSE-MsgGUID: kN0YPfTCTxS6DWeDD4KMyg==
X-IronPort-AV: E=McAfee;i="6700,10204,11411"; a="50825269"
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="50825269"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2025 04:26:22 -0700
X-CSE-ConnectionGUID: m0qcyY3dRNCb7ErccpJYNw==
X-CSE-MsgGUID: lqWYjuQHTL+bA1m2WuW/dA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="137150744"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa003.jf.intel.com with ESMTP; 23 Apr 2025 04:26:19 -0700
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
Subject: [RFC 03/10] i386/cpu: Introduce cache model for SierraForest
Date: Wed, 23 Apr 2025 19:46:55 +0800
Message-Id: <20250423114702.1529340-4-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250423114702.1529340-1-zhao1.liu@intel.com>
References: <20250423114702.1529340-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Add the cache model to SierraForest (v3) to better emulate its
environment.

The cache model is based on SierraForest-SP (Scalable Performance):

      --- cache 0 ---
      cache type                         = data cache (1)
      cache level                        = 0x1 (1)
      self-initializing cache level      = true
      fully associative cache            = false
      maximum IDs for CPUs sharing cache = 0x0 (0)
      maximum IDs for cores in pkg       = 0x3f (63)
      system coherency line size         = 0x40 (64)
      physical line partitions           = 0x1 (1)
      ways of associativity              = 0x8 (8)
      number of sets                     = 0x40 (64)
      WBINVD/INVD acts on lower caches   = false
      inclusive to lower caches          = false
      complex cache indexing             = false
      number of sets (s)                 = 64
      (size synth)                       = 32768 (32 KB)
      --- cache 1 ---
      cache type                         = instruction cache (2)
      cache level                        = 0x1 (1)
      self-initializing cache level      = true
      fully associative cache            = false
      maximum IDs for CPUs sharing cache = 0x0 (0)
      maximum IDs for cores in pkg       = 0x3f (63)
      system coherency line size         = 0x40 (64)
      physical line partitions           = 0x1 (1)
      ways of associativity              = 0x8 (8)
      number of sets                     = 0x80 (128)
      WBINVD/INVD acts on lower caches   = false
      inclusive to lower caches          = false
      complex cache indexing             = false
      number of sets (s)                 = 128
      (size synth)                       = 65536 (64 KB)
      --- cache 2 ---
      cache type                         = unified cache (3)
      cache level                        = 0x2 (2)
      self-initializing cache level      = true
      fully associative cache            = false
      maximum IDs for CPUs sharing cache = 0x7 (7)
      maximum IDs for cores in pkg       = 0x3f (63)
      system coherency line size         = 0x40 (64)
      physical line partitions           = 0x1 (1)
      ways of associativity              = 0x10 (16)
      number of sets                     = 0x1000 (4096)
      WBINVD/INVD acts on lower caches   = false
      inclusive to lower caches          = false
      complex cache indexing             = false
      number of sets (s)                 = 4096
      (size synth)                       = 4194304 (4 MB)
      --- cache 3 ---
      cache type                         = unified cache (3)
      cache level                        = 0x3 (3)
      self-initializing cache level      = true
      fully associative cache            = false
      maximum IDs for CPUs sharing cache = 0x1ff (511)
      maximum IDs for cores in pkg       = 0x3f (63)
      system coherency line size         = 0x40 (64)
      physical line partitions           = 0x1 (1)
      ways of associativity              = 0xc (12)
      number of sets                     = 0x24000 (147456)
      WBINVD/INVD acts on lower caches   = false
      inclusive to lower caches          = false
      complex cache indexing             = true
      number of sets (s)                 = 147456
      (size synth)                       = 113246208 (108 MB)
      --- cache 4 ---
      cache type                         = no more caches (0)

Suggested-by: Tejus GK <tejus.gk@nutanix.com>
Suggested-by: Jason Zeng <jason.zeng@intel.com>
Suggested-by: "Daniel P . Berrangé" <berrange@redhat.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/cpu.c | 96 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 96 insertions(+)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 5119d7aa4150..4f7ab6246e39 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -2453,6 +2453,97 @@ static const CPUCaches epyc_genoa_cache_info = {
     },
 };
 
+static const CPUCaches xeon_srf_cache_info = {
+    .l1d_cache = &(CPUCacheInfo) {
+        // CPUID 0x4.0x0.EAX
+        .type = DATA_CACHE,
+        .level = 1,
+        .self_init = true,
+
+        // CPUID 0x4.0x0.EBX
+        .line_size = 64,
+        .partitions = 1,
+        .associativity = 8,
+
+        // CPUID 0x4.0x0.ECX
+        .sets = 64,
+
+        // CPUID 0x4.0x0.EDX
+        .no_invd_sharing = false,
+        .inclusive = false,
+        .complex_indexing = false,
+
+        .size = 32 * KiB,
+        .share_level = CPU_TOPOLOGY_LEVEL_CORE,
+    },
+    .l1i_cache = &(CPUCacheInfo) {
+        // CPUID 0x4.0x1.EAX
+        .type = INSTRUCTION_CACHE,
+        .level = 1,
+        .self_init = true,
+
+        // CPUID 0x4.0x1.EBX
+        .line_size = 64,
+        .partitions = 1,
+        .associativity = 8,
+
+        // CPUID 0x4.0x1.ECX
+        .sets = 128,
+
+        // CPUID 0x4.0x1.EDX
+        .no_invd_sharing = false,
+        .inclusive = false,
+        .complex_indexing = false,
+
+        .size = 64 * KiB,
+        .share_level = CPU_TOPOLOGY_LEVEL_CORE,
+    },
+    .l2_cache = &(CPUCacheInfo) {
+        // CPUID 0x4.0x2.EAX
+        .type = UNIFIED_CACHE,
+        .level = 2,
+        .self_init = true,
+
+        // CPUID 0x4.0x2.EBX
+        .line_size = 64,
+        .partitions = 1,
+        .associativity = 16,
+
+        // CPUID 0x4.0x2.ECX
+        .sets = 4096,
+
+        // CPUID 0x4.0x2.EDX
+        .no_invd_sharing = false,
+        .inclusive = false,
+        .complex_indexing = false,
+
+        .size = 4 * MiB,
+        .share_level = CPU_TOPOLOGY_LEVEL_MODULE,
+    },
+    .l3_cache = &(CPUCacheInfo) {
+        // CPUID 0x4.0x3.EAX
+        .type = UNIFIED_CACHE,
+        .level = 3,
+        .self_init = true,
+
+        // CPUID 0x4.0x3.EBX
+        .line_size = 64,
+        .partitions = 1,
+        .associativity = 12,
+
+        // CPUID 0x4.0x3.ECX
+        .sets = 147456,
+
+        // CPUID 0x4.0x3.EDX
+        .no_invd_sharing = false,
+        .inclusive = false,
+        .complex_indexing = true,
+
+        .size = 108 * MiB,
+        .share_level = CPU_TOPOLOGY_LEVEL_SOCKET,
+    },
+};
+
 /* The following VMX features are not supported by KVM and are left out in the
  * CPU definitions:
  *
@@ -4571,6 +4662,11 @@ static const X86CPUDefinition builtin_x86_defs[] = {
                     { /* end of list */ }
                 }
             },
+            {
+                .version = 3,
+                .note = "with srf-sp cache model",
+                .cache_info = &xeon_srf_cache_info,
+            },
             { /* end of list */ },
         },
     },
-- 
2.34.1


