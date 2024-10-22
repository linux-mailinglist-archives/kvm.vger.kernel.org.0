Return-Path: <kvm+bounces-29406-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CB2F89AA344
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 15:36:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ECFB11C2247D
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 13:36:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A960819DFA5;
	Tue, 22 Oct 2024 13:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Qo6yy/VL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1B96D2FB
	for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 13:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729604175; cv=none; b=Z2Fg7OIfNhjaBm/q7tTQi+ctjAk7SzJWiEx9S224mRPlWFDWaNa/2c0/vhiX+Wc07XmPUVLAaVfZvZvkc21/CI2af+4gpPIgkk+b/92qQa63PU5vVO2jl3aT4M5uXLGLi7ROxgRq+OaifrGc4qClC7k4VXfaGtvcKVVaMtkzSUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729604175; c=relaxed/simple;
	bh=rfk8ITGJI1L5Cei1tN2GoDq9qTCt0wMD3MSKGrYw9Os=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=crznU95Q+m64suS4ZO4pHgmGaASyAyxMRGNKoxM/R9cNjC0N11zCTCVNNjQj/eIUA1U4J+UL81GNQK0KDswRXth64rKv9gDBJ09/JBl85EkqbG7EiIlqrr2CiLZ1EOsz8FslEztGeEx4YgJy3LwJyuR3v6QhrpJNoEp48wBUSHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Qo6yy/VL; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729604174; x=1761140174;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rfk8ITGJI1L5Cei1tN2GoDq9qTCt0wMD3MSKGrYw9Os=;
  b=Qo6yy/VLnZmeShYZ6eHgpmMl8mF2pA35cYCL2eawYt6E14aGnJihs8HB
   GOWXSMcZ+PRzftNhjtS2C4+/9F5p/EdVtTIhf83Dj3ClK6r1EVqaiDc4y
   L7cJktyvihuzDalZB7j6ecf3eUxuKyEwCK/fQGmuzp9V7mQIl/1B7PlVQ
   tvRtQuy132jvSvtGoN116XT6cDY9QiDxoocZPCyZDlP60RoyDBd79mR0z
   qxV4h3mdYiwQMVBicUR3IEySCRY1Mif3Kz3Rt1VyhzuMlOg8cPjsmUs8m
   58Bsvuahp2VjRdqH7hvWHPQHXNotGRHrhQOHtEqrT0+Y3XnA+BJ/LCKvR
   Q==;
X-CSE-ConnectionGUID: pSaBp0BPTPClBo3uw+KTYg==
X-CSE-MsgGUID: 8rMm1hK7TEGrkpX33ame7A==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="46603603"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="46603603"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2024 06:36:10 -0700
X-CSE-ConnectionGUID: pTHKGFXAR5+ONseAbwlpxA==
X-CSE-MsgGUID: 3qo7ZV6NTTmPwm6Pv4ReyA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,223,1725346800"; 
   d="scan'208";a="79782232"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by orviesa009.jf.intel.com with ESMTP; 22 Oct 2024 06:36:04 -0700
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
	Alireza Sanaee <alireza.sanaee@huawei.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	qemu-riscv@nongnu.org,
	qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v4 1/9] i386/cpu: Don't enumerate the "invalid" CPU topology level
Date: Tue, 22 Oct 2024 21:51:43 +0800
Message-Id: <20241022135151.2052198-2-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241022135151.2052198-1-zhao1.liu@intel.com>
References: <20241022135151.2052198-1-zhao1.liu@intel.com>
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
index 1ff1af032eaa..638de9c29c4c 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -367,20 +367,21 @@ static void encode_topo_cpuid1f(CPUX86State *env, uint32_t count,
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
@@ -391,6 +392,8 @@ static void encode_topo_cpuid1f(CPUX86State *env, uint32_t count,
             level = CPU_TOPO_LEVEL_INVALID;
             break;
         }
+        /* Search the next level. */
+        base_level = level + 1;
     }
 
     if (level == CPU_TOPO_LEVEL_INVALID) {
-- 
2.34.1


