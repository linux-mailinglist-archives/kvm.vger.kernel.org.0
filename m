Return-Path: <kvm+bounces-30284-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 983009B8CC3
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 09:16:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 56BC8286593
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 08:16:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AACDD156C72;
	Fri,  1 Nov 2024 08:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l6zpyYvF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67E3314D29B
	for <kvm@vger.kernel.org>; Fri,  1 Nov 2024 08:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730448966; cv=none; b=oxS8PQsZfUmoxSoxdpgyFDmEH/XVJLU9fwfQ+EhsbXoJPXxL8mYVYOGLiZPwSQTJUpuvLG9ld2nczbPwO+uaBv9JGM7okUAJarOjcxdtO6n/8oohi8TNEceqDJcpbBLxwu8LOegx6S7FXcbE5mki40JNm8AEaZ2kmyKjXoDjUq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730448966; c=relaxed/simple;
	bh=1dPWfn08NUNqOZ5PO7IBAQYY2uK5uWynR2m08PGiW3k=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nmwH+CmXdXZaMTS/NT5MSA5X2z7UsW29x2/d07KDApuSrPwjYwjHxJKhikYAwgfq3G3rJg7yuwFzyaIelufHzlxJLYcSwu2iVw4fe7KF74+qOCQFho/blRBvoMnNcuYlPOP3G995QOiOqSW2JZuyEwAkZ4GaTA/wWzPYsTYgpkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=l6zpyYvF; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730448965; x=1761984965;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=1dPWfn08NUNqOZ5PO7IBAQYY2uK5uWynR2m08PGiW3k=;
  b=l6zpyYvFGX7ygqc2KMqdauMp7YVuElBuWXs50/UZ6KsB4oRUOQIK9Cib
   fFmsn9QtBsG3VbIkUoysgNmBQ2dRELFNZXMsoZzQOMKeSa/7KZVj2jZBK
   RsfEiF6gftKLdPVt1BfSkQltLSvvtp1UezCwYNhTKjyZ5DLBnrG2KKHgv
   PjNSwh9p1mbRPPjjgtJMRGMryLdWMiJ+Tz4jdNfu8vQGWlvm3Ts+qbmYB
   WCPeBCGMaGn732kKkB5E4EKgvTsNj9jMTah4PgG+VWTdrBRc77gYiwJmv
   LJrTyW8DDVWgKWMqP1RcVE+7ZhVcADSy7nOq6sg8CCMqFjwZ3p2D9F4Kr
   g==;
X-CSE-ConnectionGUID: NkchP2vqSbG5ucEo/HF7VQ==
X-CSE-MsgGUID: +NQerxLuROmhlf9YXSyJQw==
X-IronPort-AV: E=McAfee;i="6700,10204,11242"; a="17846005"
X-IronPort-AV: E=Sophos;i="6.11,249,1725346800"; 
   d="scan'208";a="17846005"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2024 01:16:04 -0700
X-CSE-ConnectionGUID: LUBhdBhGQwKOVlizCOoROQ==
X-CSE-MsgGUID: R3gWI9O9St23dpn0CDALbw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,249,1725346800"; 
   d="scan'208";a="86834558"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa003.fm.intel.com with ESMTP; 01 Nov 2024 01:15:59 -0700
From: Zhao Liu <zhao1.liu@intel.com>
To: =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sia Jee Heng <jeeheng.sia@starfivetech.com>,
	Alireza Sanaee <alireza.sanaee@huawei.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	qemu-riscv@nongnu.org,
	qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v5 1/9] i386/cpu: Don't enumerate the "invalid" CPU topology level
Date: Fri,  1 Nov 2024 16:33:23 +0800
Message-Id: <20241101083331.340178-2-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241101083331.340178-1-zhao1.liu@intel.com>
References: <20241101083331.340178-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In the follow-up change, the CPU topology enumeration will be moved to
QAPI. And considerring "invalid" should not be exposed to QAPI as an
unsettable item, so, as a preparation for future changes, remove
"invalid" level from the current CPU topology enumeration structure
and define it by a macro instead.

Due to the removal of the enumeration of "invalid", bit 0 of
CPUX86State.avail_cpu_topo bitmap will no longer correspond to "invalid"
level, but will start at the SMT level. Therefore, to honor this change,
update the encoding rule for CPUID[0x1F].

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
Tested by the following cases to ensure 0x1f's behavior hasn't
changed:
  -smp cpus=24,sockets=2,dies=3,modules=2,cores=2,threads=1
  -smp cpus=24,sockets=2,dies=1,modules=3,cores=2,threads=2
  -smp cpus=24,sockets=2,modules=3,cores=2,threads=2
  -smp cpus=24,sockets=2,dies=3,modules=1,cores=2,threads=2
  -smp cpus=24,sockets=2,dies=3,cores=2,threads=2
---
Changes since Patch v3:
  * Now commit to stop exposing "invalid" enumeration in QAPI. (Daniel)
---
 include/hw/i386/topology.h |  3 ++-
 target/i386/cpu.c          | 13 ++++++++-----
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/include/hw/i386/topology.h b/include/hw/i386/topology.h
index dff49fce1154..48b43edc5a90 100644
--- a/include/hw/i386/topology.h
+++ b/include/hw/i386/topology.h
@@ -62,6 +62,8 @@ typedef struct X86CPUTopoInfo {
     unsigned threads_per_core;
 } X86CPUTopoInfo;
 
+#define CPU_TOPO_LEVEL_INVALID CPU_TOPO_LEVEL_MAX
+
 /*
  * CPUTopoLevel is the general i386 topology hierarchical representation,
  * ordered by increasing hierarchical relationship.
@@ -69,7 +71,6 @@ typedef struct X86CPUTopoInfo {
  * or AMD (CPUID[0x80000026]).
  */
 enum CPUTopoLevel {
-    CPU_TOPO_LEVEL_INVALID,
     CPU_TOPO_LEVEL_SMT,
     CPU_TOPO_LEVEL_CORE,
     CPU_TOPO_LEVEL_MODULE,
diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 3baa95481fbc..ca13cf66a787 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -370,20 +370,21 @@ static void encode_topo_cpuid1f(CPUX86State *env, uint32_t count,
                                 uint32_t *ecx, uint32_t *edx)
 {
     X86CPU *cpu = env_archcpu(env);
-    unsigned long level, next_level;
+    unsigned long level, base_level, next_level;
     uint32_t num_threads_next_level, offset_next_level;
 
-    assert(count + 1 < CPU_TOPO_LEVEL_MAX);
+    assert(count <= CPU_TOPO_LEVEL_PACKAGE);
 
     /*
      * Find the No.(count + 1) topology level in avail_cpu_topo bitmap.
-     * The search starts from bit 1 (CPU_TOPO_LEVEL_INVALID + 1).
+     * The search starts from bit 0 (CPU_TOPO_LEVEL_SMT).
      */
-    level = CPU_TOPO_LEVEL_INVALID;
+    level = CPU_TOPO_LEVEL_SMT;
+    base_level = level;
     for (int i = 0; i <= count; i++) {
         level = find_next_bit(env->avail_cpu_topo,
                               CPU_TOPO_LEVEL_PACKAGE,
-                              level + 1);
+                              base_level);
 
         /*
          * CPUID[0x1f] doesn't explicitly encode the package level,
@@ -394,6 +395,8 @@ static void encode_topo_cpuid1f(CPUX86State *env, uint32_t count,
             level = CPU_TOPO_LEVEL_INVALID;
             break;
         }
+        /* Search the next level. */
+        base_level = level + 1;
     }
 
     if (level == CPU_TOPO_LEVEL_INVALID) {
-- 
2.34.1


