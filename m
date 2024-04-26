Return-Path: <kvm+bounces-16035-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3767F8B348A
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 11:53:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E2EFF283173
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 09:53:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02E50140386;
	Fri, 26 Apr 2024 09:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="glCtBPoO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B4E313FD7E
	for <kvm@vger.kernel.org>; Fri, 26 Apr 2024 09:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714125198; cv=none; b=pemJjcs2CttWEfXOrmfQtXP4lKLt2IOZPQVUDV9qcb3W2ro3qf0ErJMWx6Ln83ZhSOB/QjdtIGEcBwHKmuROdn7v2UzpTLAKc3oInjoaooLJDH/JSFxcIL5tEMj+EyQjZ46i8eUXHr1/6X4VstCqB0dmQtUaQcPPUTxwt/8EBhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714125198; c=relaxed/simple;
	bh=kG8SaF5P7m7Uz9jW0sK28yBVn/tvrppYDL3cxHGZObM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pgsmm2uDNooDjeNhaWwP+vgLmgTyvQ6+3f0LuyINj7g+ASS2qy7CRuBiTdmZrRDuS8I49ktZfa+5rAv4Zhr0WaDF3D6mwzIhFIT3KTXkPdUVsar+KhAnUGOdu8LUTnLd2sMYXx7SNBAgpiEDcJoSPVQgmkHbVynWWQaAjN3dOOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=glCtBPoO; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714125197; x=1745661197;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kG8SaF5P7m7Uz9jW0sK28yBVn/tvrppYDL3cxHGZObM=;
  b=glCtBPoOSINzHTcJeoB6OlwDQ437u99z90jz/YmIgMG+sPqqI1VBF3Pt
   1xcuQw5mtzLDazbUvXHyZ4LROCbi31J4UNb0eij3nVgf8BCWKL4SeoYQb
   HjORQLjC0076Cb3vsTmy+/gp1sAIhfmnWw8yukBLL+3Ynb/kPrYZpQk8v
   EwTNUaGbM4i8PVj/XR9Pq/gIq0tdIB3+5mq9ZmdOONyc8P9VN1LrIJkyY
   nUffRrrxsP1z7AenfauHeynBDGTFIa+GlOGf37NR17v4qICr8BEHmCSaH
   Qa/pY3OJSJpNgvpNjr90gGgqJ3J056YoFxbxvY9Vov2FjsRjOW8On+gUT
   w==;
X-CSE-ConnectionGUID: Ey3uuaLSTnCzLAgYKfhZ9g==
X-CSE-MsgGUID: TIa4uHSTR6yE6zMR62Gmeg==
X-IronPort-AV: E=McAfee;i="6600,9927,11055"; a="9707393"
X-IronPort-AV: E=Sophos;i="6.07,232,1708416000"; 
   d="scan'208";a="9707393"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2024 02:53:16 -0700
X-CSE-ConnectionGUID: VF5wpoSoSpC4bdrXiQX/3A==
X-CSE-MsgGUID: 0YpObBkfT4+6/yepekrPAQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,232,1708416000"; 
   d="scan'208";a="25412313"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa008.fm.intel.com with ESMTP; 26 Apr 2024 02:53:13 -0700
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH 1/6] target/i386/kvm: Add feature bit definitions for KVM CPUID
Date: Fri, 26 Apr 2024 18:07:10 +0800
Message-Id: <20240426100716.2111688-2-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240426100716.2111688-1-zhao1.liu@intel.com>
References: <20240426100716.2111688-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add feature definiations for KVM_CPUID_FEATURES in CPUID (
CPUID[4000_0001].EAX and CPUID[4000_0001].EDX), to get rid of lots of
offset calculations.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
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
index 6112e27bfd5c..caa32a91346b 100644
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
index c5943605ee3a..d9e03891113f 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -527,13 +527,13 @@ uint32_t kvm_arch_get_supported_cpuid(KVMState *s, uint32_t function,
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
 
     return ret;
@@ -3377,20 +3377,20 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
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
 
@@ -3842,19 +3842,19 @@ static int kvm_get_msrs(X86CPU *cpu)
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
@@ -5487,7 +5487,7 @@ uint64_t kvm_swizzle_msi_ext_dest_id(uint64_t address)
         return address;
     }
     env = &X86_CPU(first_cpu)->env;
-    if (!(env->features[FEAT_KVM] & (1 << KVM_FEATURE_MSI_EXT_DEST_ID))) {
+    if (!(env->features[FEAT_KVM] & CPUID_KVM_MSI_EXT_DEST_ID)) {
         return address;
     }
 
-- 
2.34.1


