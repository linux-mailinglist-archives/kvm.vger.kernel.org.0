Return-Path: <kvm+bounces-30833-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 34A739BDD2F
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 03:50:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8BF3EB230DA
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 02:50:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA028190051;
	Wed,  6 Nov 2024 02:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N+g+ElIV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28AF218FC84
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 02:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730861399; cv=none; b=qVUd/jnMEonA9KipaE0EDCcLKBppnB2N80hzDahh1UJxxh3Fv88uQzlDL4QNxKntAOFll5dS+CSg91g2Vv6CAlEyuWM5NaEmozYXA3zM6Ezy4d8unSteoYjd8Awv4/ftW3LmXWqzkn3AorFKM3rekOvpGYWHXb6Uls4kv2JY9qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730861399; c=relaxed/simple;
	bh=8vl5rexe63k4nr+JznMOIYOBxZwKEHBFQriO22wJpks=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iy655nyI3Fn5uRkebfyNnBLs1lHg0fBYbisUT0w39Nw36uvyWhjKGXTsVKjIrRE6M8f4J1bXXAnJ99Li3MU4q2OyosbV5FWoGvNpcNwkGR3ajZyLEFaUkoId2/44nZZ1B652qqpUwQ+aOMpTiDAlBQv/lRr92uNAvpMwTqc2FFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N+g+ElIV; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730861397; x=1762397397;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8vl5rexe63k4nr+JznMOIYOBxZwKEHBFQriO22wJpks=;
  b=N+g+ElIV5QHYolq/yy1w3Atn/oJ9gtW8yx4fn764DlC19QSQf24jAfvV
   r+1phPYh5JeDYoVq3EGTx+tfAq89nPhPE5G62BkHNulMyH/tM3Y5shiSV
   7Rzyl1hiZHL5gH0u7D3lYxEaJLz1DR/FUftTVUX+JweQ9/AhVmxyE4CAw
   igvnQMeVI0Zd4NUnIPDEdYR2DaQvBZNSOGtOiz0CuxneSspR8RwAQ6qhD
   OqmMKBrnt0m2MTEwBLYZ2GRewooPufjL7iIvTzHiEag/PUUyulm08el2r
   uTr0vLx1L7QW4EwBy+AYJ1+nbkvK1M/Vl0sFHMMo+grSe7XnNEDas000e
   w==;
X-CSE-ConnectionGUID: rb+iZfbdTIWeCqEriaoJ3Q==
X-CSE-MsgGUID: PEw9EYUzRbWOZQVD+7h9gQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30492210"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30492210"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 18:49:56 -0800
X-CSE-ConnectionGUID: as78JoftRCmoSA3eagVTXw==
X-CSE-MsgGUID: kVYjVzZ9QLe7VZLDMlfAxg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,261,1725346800"; 
   d="scan'208";a="115077979"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa001.fm.intel.com with ESMTP; 05 Nov 2024 18:49:52 -0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Tao Su <tao1.su@linux.intel.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Zide Chen <zide.chen@intel.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v5 02/11] target/i386/kvm: Add feature bit definitions for KVM CPUID
Date: Wed,  6 Nov 2024 11:07:19 +0800
Message-Id: <20241106030728.553238-3-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241106030728.553238-1-zhao1.liu@intel.com>
References: <20241106030728.553238-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add feature definitions for KVM_CPUID_FEATURES in CPUID (
CPUID[4000_0001].EAX and CPUID[4000_0001].EDX), to get rid of lots of
offset calculations.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
Reviewed-by: Zide Chen <zide.chen@intel.com>
---
v3: Resolved a rebasing conflict.
v2: Changed the prefix from CPUID_FEAT_KVM_* to CPUID_KVM_*. (Xiaoyao)
---
 hw/i386/kvm/clock.c   |  5 ++---
 target/i386/cpu.h     | 23 +++++++++++++++++++++++
 target/i386/kvm/kvm.c | 28 ++++++++++++++--------------
 3 files changed, 39 insertions(+), 17 deletions(-)

diff --git a/hw/i386/kvm/clock.c b/hw/i386/kvm/clock.c
index 40aa9a32c32c..ce416c05a3d0 100644
--- a/hw/i386/kvm/clock.c
+++ b/hw/i386/kvm/clock.c
@@ -27,7 +27,6 @@
 #include "qapi/error.h"
 
 #include <linux/kvm.h>
-#include "standard-headers/asm-x86/kvm_para.h"
 #include "qom/object.h"
 
 #define TYPE_KVM_CLOCK "kvmclock"
@@ -334,8 +333,8 @@ void kvmclock_create(bool create_always)
 
     assert(kvm_enabled());
     if (create_always ||
-        cpu->env.features[FEAT_KVM] & ((1ULL << KVM_FEATURE_CLOCKSOURCE) |
-                                       (1ULL << KVM_FEATURE_CLOCKSOURCE2))) {
+        cpu->env.features[FEAT_KVM] & (CPUID_KVM_CLOCK |
+                                       CPUID_KVM_CLOCK2)) {
         sysbus_create_simple(TYPE_KVM_CLOCK, -1, NULL);
     }
 }
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 59959b8b7a4d..c4ec64e0078f 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -29,6 +29,7 @@
 #include "qapi/qapi-types-common.h"
 #include "qemu/cpu-float.h"
 #include "qemu/timer.h"
+#include "standard-headers/asm-x86/kvm_para.h"
 
 #define XEN_NR_VIRQS 24
 
@@ -1009,6 +1010,28 @@ uint64_t x86_cpu_get_supported_feature_word(X86CPU *cpu, FeatureWord w);
 #define CPUID_8000_0007_EBX_OVERFLOW_RECOV    (1U << 0)
 #define CPUID_8000_0007_EBX_SUCCOR      (1U << 1)
 
+/* (Old) KVM paravirtualized clocksource */
+#define CPUID_KVM_CLOCK            (1U << KVM_FEATURE_CLOCKSOURCE)
+/* (New) KVM specific paravirtualized clocksource */
+#define CPUID_KVM_CLOCK2           (1U << KVM_FEATURE_CLOCKSOURCE2)
+/* KVM asynchronous page fault */
+#define CPUID_KVM_ASYNCPF          (1U << KVM_FEATURE_ASYNC_PF)
+/* KVM stolen (when guest vCPU is not running) time accounting */
+#define CPUID_KVM_STEAL_TIME       (1U << KVM_FEATURE_STEAL_TIME)
+/* KVM paravirtualized end-of-interrupt signaling */
+#define CPUID_KVM_PV_EOI           (1U << KVM_FEATURE_PV_EOI)
+/* KVM paravirtualized spinlocks support */
+#define CPUID_KVM_PV_UNHALT        (1U << KVM_FEATURE_PV_UNHALT)
+/* KVM host-side polling on HLT control from the guest */
+#define CPUID_KVM_POLL_CONTROL     (1U << KVM_FEATURE_POLL_CONTROL)
+/* KVM interrupt based asynchronous page fault*/
+#define CPUID_KVM_ASYNCPF_INT      (1U << KVM_FEATURE_ASYNC_PF_INT)
+/* KVM 'Extended Destination ID' support for external interrupts */
+#define CPUID_KVM_MSI_EXT_DEST_ID  (1U << KVM_FEATURE_MSI_EXT_DEST_ID)
+
+/* Hint to KVM that vCPUs expect never preempted for an unlimited time */
+#define CPUID_KVM_HINTS_REALTIME    (1U << KVM_HINTS_REALTIME)
+
 /* CLZERO instruction */
 #define CPUID_8000_0008_EBX_CLZERO      (1U << 0)
 /* Always save/restore FP error pointers */
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 8e17942c3ba1..4fb822511a12 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -564,13 +564,13 @@ uint32_t kvm_arch_get_supported_cpuid(KVMState *s, uint32_t function,
          * be enabled without the in-kernel irqchip
          */
         if (!kvm_irqchip_in_kernel()) {
-            ret &= ~(1U << KVM_FEATURE_PV_UNHALT);
+            ret &= ~CPUID_KVM_PV_UNHALT;
         }
         if (kvm_irqchip_is_split()) {
-            ret |= 1U << KVM_FEATURE_MSI_EXT_DEST_ID;
+            ret |= CPUID_KVM_MSI_EXT_DEST_ID;
         }
     } else if (function == KVM_CPUID_FEATURES && reg == R_EDX) {
-        ret |= 1U << KVM_HINTS_REALTIME;
+        ret |= CPUID_KVM_HINTS_REALTIME;
     }
 
     if (current_machine->cgs) {
@@ -3963,20 +3963,20 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
         kvm_msr_entry_add(cpu, MSR_IA32_TSC, env->tsc);
         kvm_msr_entry_add(cpu, MSR_KVM_SYSTEM_TIME, env->system_time_msr);
         kvm_msr_entry_add(cpu, MSR_KVM_WALL_CLOCK, env->wall_clock_msr);
-        if (env->features[FEAT_KVM] & (1 << KVM_FEATURE_ASYNC_PF_INT)) {
+        if (env->features[FEAT_KVM] & CPUID_KVM_ASYNCPF_INT) {
             kvm_msr_entry_add(cpu, MSR_KVM_ASYNC_PF_INT, env->async_pf_int_msr);
         }
-        if (env->features[FEAT_KVM] & (1 << KVM_FEATURE_ASYNC_PF)) {
+        if (env->features[FEAT_KVM] & CPUID_KVM_ASYNCPF) {
             kvm_msr_entry_add(cpu, MSR_KVM_ASYNC_PF_EN, env->async_pf_en_msr);
         }
-        if (env->features[FEAT_KVM] & (1 << KVM_FEATURE_PV_EOI)) {
+        if (env->features[FEAT_KVM] & CPUID_KVM_PV_EOI) {
             kvm_msr_entry_add(cpu, MSR_KVM_PV_EOI_EN, env->pv_eoi_en_msr);
         }
-        if (env->features[FEAT_KVM] & (1 << KVM_FEATURE_STEAL_TIME)) {
+        if (env->features[FEAT_KVM] & CPUID_KVM_STEAL_TIME) {
             kvm_msr_entry_add(cpu, MSR_KVM_STEAL_TIME, env->steal_time_msr);
         }
 
-        if (env->features[FEAT_KVM] & (1 << KVM_FEATURE_POLL_CONTROL)) {
+        if (env->features[FEAT_KVM] & CPUID_KVM_POLL_CONTROL) {
             kvm_msr_entry_add(cpu, MSR_KVM_POLL_CONTROL, env->poll_control_msr);
         }
 
@@ -4441,19 +4441,19 @@ static int kvm_get_msrs(X86CPU *cpu)
 #endif
     kvm_msr_entry_add(cpu, MSR_KVM_SYSTEM_TIME, 0);
     kvm_msr_entry_add(cpu, MSR_KVM_WALL_CLOCK, 0);
-    if (env->features[FEAT_KVM] & (1 << KVM_FEATURE_ASYNC_PF_INT)) {
+    if (env->features[FEAT_KVM] & CPUID_KVM_ASYNCPF_INT) {
         kvm_msr_entry_add(cpu, MSR_KVM_ASYNC_PF_INT, 0);
     }
-    if (env->features[FEAT_KVM] & (1 << KVM_FEATURE_ASYNC_PF)) {
+    if (env->features[FEAT_KVM] & CPUID_KVM_ASYNCPF) {
         kvm_msr_entry_add(cpu, MSR_KVM_ASYNC_PF_EN, 0);
     }
-    if (env->features[FEAT_KVM] & (1 << KVM_FEATURE_PV_EOI)) {
+    if (env->features[FEAT_KVM] & CPUID_KVM_PV_EOI) {
         kvm_msr_entry_add(cpu, MSR_KVM_PV_EOI_EN, 0);
     }
-    if (env->features[FEAT_KVM] & (1 << KVM_FEATURE_STEAL_TIME)) {
+    if (env->features[FEAT_KVM] & CPUID_KVM_STEAL_TIME) {
         kvm_msr_entry_add(cpu, MSR_KVM_STEAL_TIME, 0);
     }
-    if (env->features[FEAT_KVM] & (1 << KVM_FEATURE_POLL_CONTROL)) {
+    if (env->features[FEAT_KVM] & CPUID_KVM_POLL_CONTROL) {
         kvm_msr_entry_add(cpu, MSR_KVM_POLL_CONTROL, 1);
     }
     if (has_architectural_pmu_version > 0) {
@@ -6180,7 +6180,7 @@ uint64_t kvm_swizzle_msi_ext_dest_id(uint64_t address)
         return address;
     }
     env = &X86_CPU(first_cpu)->env;
-    if (!(env->features[FEAT_KVM] & (1 << KVM_FEATURE_MSI_EXT_DEST_ID))) {
+    if (!(env->features[FEAT_KVM] & CPUID_KVM_MSI_EXT_DEST_ID)) {
         return address;
     }
 
-- 
2.34.1


