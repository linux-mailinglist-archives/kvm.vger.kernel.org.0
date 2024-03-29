Return-Path: <kvm+bounces-13073-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B9E92891679
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 11:06:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6E6DE286C84
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 10:06:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7374853385;
	Fri, 29 Mar 2024 10:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lgxn9qil"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0739524AA
	for <kvm@vger.kernel.org>; Fri, 29 Mar 2024 10:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711706772; cv=none; b=dcM/SDO2rBhxx0OzIHgADYnWBe3DJ8t5y0LacxvPveiuF5v3AjaXIfjUR77+QwUox2i9pUC5iRvHEAQIFLQ0s9+sH+zey1GIlNn8fQ9vqMuRcOlu1rnYeToVBNvABiph5T3O7b8Jo5MtlketDmXyuNN9zMfFp7aD/EgJmRoxjKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711706772; c=relaxed/simple;
	bh=tGavWDETP6FT06JEiwwRQmVvkPbXQlkwx2ajYdHWMAQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pNVhY++jHEVZiDfI98+sGjWiNOHytRK8rbkuRNDR55Q2y0VnEBDKMrVnnSDhp6Ewjwu6jVL9GMTn+dD0AT3zCozPOynyAqPEmdhnfbwmcy6CtUMLe7APIGhTo0isBWKlOTSTj27Yw9gvz66ZU1+LLZiXqsECHvFt1XgbEJHl/zU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lgxn9qil; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711706771; x=1743242771;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tGavWDETP6FT06JEiwwRQmVvkPbXQlkwx2ajYdHWMAQ=;
  b=lgxn9qilT84QRCkLBzSTjGDs4HIpjw7oF5w0CkAtS3EDZWTrUVDk120t
   Mx0JdOmD8HunWNncdKxyf/+ZnzGOCWdvFbicUM8/ZUlQh7J8dRJbRTcyf
   o/AWUmACUmpt5UvvqgLBzUtfGDcmA14Y4Isugzvmb2RZbWODPS34ykqjI
   Jupq/5b18kmGzOojlEV08EB2eYi9pXXAvbCmICEbn4Yuk0F+yU2KG/NxG
   wHehRj+c4wKmLjkifNZ0AQceXrNWxz3yjuRPQSp2vWw2w39oLaEefeePL
   M4NzmkACJmESjTjNqyRkxu10bdCPLf3SdSASrqygc9cFEjUpRKBzLH2hj
   Q==;
X-CSE-ConnectionGUID: h7iVaNUbSRy514G004Ioww==
X-CSE-MsgGUID: KuN34osbT1+1NY/Ng65u8w==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="17519195"
X-IronPort-AV: E=Sophos;i="6.07,164,1708416000"; 
   d="scan'208";a="17519195"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2024 03:06:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,164,1708416000"; 
   d="scan'208";a="21441949"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa003.fm.intel.com with ESMTP; 29 Mar 2024 03:06:07 -0700
From: Zhao Liu <zhao1.liu@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Tim Wiederhake <twiederh@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH for-9.1 1/7] target/i386/kvm: Add feature bit definitions for KVM CPUID
Date: Fri, 29 Mar 2024 18:19:48 +0800
Message-Id: <20240329101954.3954987-2-zhao1.liu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240329101954.3954987-1-zhao1.liu@linux.intel.com>
References: <20240329101954.3954987-1-zhao1.liu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhao Liu <zhao1.liu@intel.com>

Add feature definiations for KVM_CPUID_FEATURES in CPUID (
CPUID[4000_0001].EAX and CPUID[4000_0001].EDX), to get rid of lots of
offset calculations.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 hw/i386/kvm/clock.c   |  5 ++---
 target/i386/cpu.h     | 23 +++++++++++++++++++++++
 target/i386/kvm/kvm.c | 28 ++++++++++++++--------------
 3 files changed, 39 insertions(+), 17 deletions(-)

diff --git a/hw/i386/kvm/clock.c b/hw/i386/kvm/clock.c
index 40aa9a32c32c..7c9752d5036f 100644
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
+        cpu->env.features[FEAT_KVM] & (CPUID_FEAT_KVM_CLOCK |
+                                       CPUID_FEAT_KVM_CLOCK2)) {
         sysbus_create_simple(TYPE_KVM_CLOCK, -1, NULL);
     }
 }
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 83e473584517..b1b8d11cb0fe 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -27,6 +27,7 @@
 #include "qapi/qapi-types-common.h"
 #include "qemu/cpu-float.h"
 #include "qemu/timer.h"
+#include "standard-headers/asm-x86/kvm_para.h"
 
 #define XEN_NR_VIRQS 24
 
@@ -951,6 +952,28 @@ uint64_t x86_cpu_get_supported_feature_word(FeatureWord w,
 /* Packets which contain IP payload have LIP values */
 #define CPUID_14_0_ECX_LIP              (1U << 31)
 
+/* (Old) KVM paravirtualized clocksource */
+#define CPUID_FEAT_KVM_CLOCK            (1U << KVM_FEATURE_CLOCKSOURCE)
+/* (New) KVM specific paravirtualized clocksource */
+#define CPUID_FEAT_KVM_CLOCK2           (1U << KVM_FEATURE_CLOCKSOURCE2)
+/* KVM asynchronous page fault */
+#define CPUID_FEAT_KVM_ASYNCPF          (1U << KVM_FEATURE_ASYNC_PF)
+/* KVM stolen (when guest vCPU is not running) time accounting */
+#define CPUID_FEAT_KVM_STEAL_TIME       (1U << KVM_FEATURE_STEAL_TIME)
+/* KVM paravirtualized end-of-interrupt signaling */
+#define CPUID_FEAT_KVM_PV_EOI           (1U << KVM_FEATURE_PV_EOI)
+/* KVM paravirtualized spinlocks support */
+#define CPUID_FEAT_KVM_PV_UNHALT        (1U << KVM_FEATURE_PV_UNHALT)
+/* KVM host-side polling on HLT control from the guest */
+#define CPUID_FEAT_KVM_POLL_CONTROL     (1U << KVM_FEATURE_POLL_CONTROL)
+/* KVM interrupt based asynchronous page fault*/
+#define CPUID_FEAT_KVM_ASYNCPF_INT      (1U << KVM_FEATURE_ASYNC_PF_INT)
+/* KVM 'Extended Destination ID' support for external interrupts */
+#define CPUID_FEAT_KVM_MSI_EXT_DEST_ID  (1U << KVM_FEATURE_MSI_EXT_DEST_ID)
+
+/* Hint to KVM that vCPUs expect never preempted for an unlimited time */
+#define CPUID_FEAT_KVM_HINTS_REALTIME    (1U << KVM_HINTS_REALTIME)
+
 /* CLZERO instruction */
 #define CPUID_8000_0008_EBX_CLZERO      (1U << 0)
 /* Always save/restore FP error pointers */
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index e68cbe929302..2f3c8bc3a4ed 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -481,13 +481,13 @@ uint32_t kvm_arch_get_supported_cpuid(KVMState *s, uint32_t function,
          * be enabled without the in-kernel irqchip
          */
         if (!kvm_irqchip_in_kernel()) {
-            ret &= ~(1U << KVM_FEATURE_PV_UNHALT);
+            ret &= ~CPUID_FEAT_KVM_PV_UNHALT;
         }
         if (kvm_irqchip_is_split()) {
-            ret |= 1U << KVM_FEATURE_MSI_EXT_DEST_ID;
+            ret |= CPUID_FEAT_KVM_MSI_EXT_DEST_ID;
         }
     } else if (function == KVM_CPUID_FEATURES && reg == R_EDX) {
-        ret |= 1U << KVM_HINTS_REALTIME;
+        ret |= CPUID_FEAT_KVM_HINTS_REALTIME;
     }
 
     return ret;
@@ -3324,20 +3324,20 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
         kvm_msr_entry_add(cpu, MSR_IA32_TSC, env->tsc);
         kvm_msr_entry_add(cpu, MSR_KVM_SYSTEM_TIME, env->system_time_msr);
         kvm_msr_entry_add(cpu, MSR_KVM_WALL_CLOCK, env->wall_clock_msr);
-        if (env->features[FEAT_KVM] & (1 << KVM_FEATURE_ASYNC_PF_INT)) {
+        if (env->features[FEAT_KVM] & CPUID_FEAT_KVM_ASYNCPF_INT) {
             kvm_msr_entry_add(cpu, MSR_KVM_ASYNC_PF_INT, env->async_pf_int_msr);
         }
-        if (env->features[FEAT_KVM] & (1 << KVM_FEATURE_ASYNC_PF)) {
+        if (env->features[FEAT_KVM] & CPUID_FEAT_KVM_ASYNCPF) {
             kvm_msr_entry_add(cpu, MSR_KVM_ASYNC_PF_EN, env->async_pf_en_msr);
         }
-        if (env->features[FEAT_KVM] & (1 << KVM_FEATURE_PV_EOI)) {
+        if (env->features[FEAT_KVM] & CPUID_FEAT_KVM_PV_EOI) {
             kvm_msr_entry_add(cpu, MSR_KVM_PV_EOI_EN, env->pv_eoi_en_msr);
         }
-        if (env->features[FEAT_KVM] & (1 << KVM_FEATURE_STEAL_TIME)) {
+        if (env->features[FEAT_KVM] & CPUID_FEAT_KVM_STEAL_TIME) {
             kvm_msr_entry_add(cpu, MSR_KVM_STEAL_TIME, env->steal_time_msr);
         }
 
-        if (env->features[FEAT_KVM] & (1 << KVM_FEATURE_POLL_CONTROL)) {
+        if (env->features[FEAT_KVM] & CPUID_FEAT_KVM_POLL_CONTROL) {
             kvm_msr_entry_add(cpu, MSR_KVM_POLL_CONTROL, env->poll_control_msr);
         }
 
@@ -3789,19 +3789,19 @@ static int kvm_get_msrs(X86CPU *cpu)
 #endif
     kvm_msr_entry_add(cpu, MSR_KVM_SYSTEM_TIME, 0);
     kvm_msr_entry_add(cpu, MSR_KVM_WALL_CLOCK, 0);
-    if (env->features[FEAT_KVM] & (1 << KVM_FEATURE_ASYNC_PF_INT)) {
+    if (env->features[FEAT_KVM] & CPUID_FEAT_KVM_ASYNCPF_INT) {
         kvm_msr_entry_add(cpu, MSR_KVM_ASYNC_PF_INT, 0);
     }
-    if (env->features[FEAT_KVM] & (1 << KVM_FEATURE_ASYNC_PF)) {
+    if (env->features[FEAT_KVM] & CPUID_FEAT_KVM_ASYNCPF) {
         kvm_msr_entry_add(cpu, MSR_KVM_ASYNC_PF_EN, 0);
     }
-    if (env->features[FEAT_KVM] & (1 << KVM_FEATURE_PV_EOI)) {
+    if (env->features[FEAT_KVM] & CPUID_FEAT_KVM_PV_EOI) {
         kvm_msr_entry_add(cpu, MSR_KVM_PV_EOI_EN, 0);
     }
-    if (env->features[FEAT_KVM] & (1 << KVM_FEATURE_STEAL_TIME)) {
+    if (env->features[FEAT_KVM] & CPUID_FEAT_KVM_STEAL_TIME) {
         kvm_msr_entry_add(cpu, MSR_KVM_STEAL_TIME, 0);
     }
-    if (env->features[FEAT_KVM] & (1 << KVM_FEATURE_POLL_CONTROL)) {
+    if (env->features[FEAT_KVM] & CPUID_FEAT_KVM_POLL_CONTROL) {
         kvm_msr_entry_add(cpu, MSR_KVM_POLL_CONTROL, 1);
     }
     if (has_architectural_pmu_version > 0) {
@@ -5434,7 +5434,7 @@ uint64_t kvm_swizzle_msi_ext_dest_id(uint64_t address)
         return address;
     }
     env = &X86_CPU(first_cpu)->env;
-    if (!(env->features[FEAT_KVM] & (1 << KVM_FEATURE_MSI_EXT_DEST_ID))) {
+    if (!(env->features[FEAT_KVM] & CPUID_FEAT_KVM_MSI_EXT_DEST_ID)) {
         return address;
     }
 
-- 
2.34.1


