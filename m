Return-Path: <kvm+bounces-1304-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A30BF7E64AE
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 08:51:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 44774B21011
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 07:51:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2955210973;
	Thu,  9 Nov 2023 07:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d2NbwX/7"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1BF3FC0E
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 07:50:24 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28D622D51
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 23:50:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699516224; x=1731052224;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qS2divpzlg34Mgdu79EblBhmAA77ycjlMQsD+syQIDc=;
  b=d2NbwX/7LTEQFNukQikmF2tLIHgGaQwvL1ywIWZlCw5dd80GKlggblU9
   kz5n9qtYLeDAvjCU7tChKFkAE1xtjXH2B3ZIy7lyVzWRD/MGUe3X1pwJS
   BzDUjsnbz3vzBdH+JIW3IR989Kn2hKrfs9eVQUKj+Z1T8z4V7BqVErpnS
   YrqlSTUKFPqnGs1Q1H8ntOgUsKDy3f4pNg7+IxT3VwrgEdQYgjNKDq2U1
   hN57aKDxrsInRBUXp+uYm66qRcVjUjdeVsfLW78zLxz8YsHXQbRRn8ky6
   WBDdXI72N3xfh+Q+gUMRX5MUYps9eYHRMP1ur3uqNGGMMFgo3hq/KgNej
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10888"; a="476165169"
X-IronPort-AV: E=Sophos;i="6.03,288,1694761200"; 
   d="scan'208";a="476165169"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2023 23:50:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10888"; a="763329295"
X-IronPort-AV: E=Sophos;i="6.03,288,1694761200"; 
   d="scan'208";a="763329295"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by orsmga002.jf.intel.com with ESMTP; 08 Nov 2023 23:50:23 -0800
From: Xin Li <xin3.li@intel.com>
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org,
	richard.henderson@linaro.org,
	pbonzini@redhat.com,
	eduardo@habkost.net,
	seanjc@google.com,
	chao.gao@intel.com,
	hpa@zytor.com,
	xiaoyao.li@intel.com,
	weijiang.yang@intel.com
Subject: [PATCH v3 6/6] target/i386: Add get/set/migrate support for FRED MSRs
Date: Wed,  8 Nov 2023 23:20:12 -0800
Message-ID: <20231109072012.8078-7-xin3.li@intel.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231109072012.8078-1-xin3.li@intel.com>
References: <20231109072012.8078-1-xin3.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

FRED CPU states are managed in 9 new FRED MSRs, in addtion to a few
existing CPU registers and MSRs, e.g., CR4.FRED and MSR_IA32_PL0_SSP.

Save/restore/migrate FRED MSRs if FRED is exposed to the guest.

Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 target/i386/cpu.h     | 22 +++++++++++++++++++
 target/i386/kvm/kvm.c | 49 +++++++++++++++++++++++++++++++++++++++++++
 target/i386/machine.c | 28 +++++++++++++++++++++++++
 3 files changed, 99 insertions(+)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index cc3b4fefb8..3b13eceffe 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -529,6 +529,17 @@ typedef enum X86Seg {
 #define MSR_IA32_XFD                    0x000001c4
 #define MSR_IA32_XFD_ERR                0x000001c5
 
+/* FRED MSRs */
+#define MSR_IA32_FRED_RSP0              0x000001cc       /* Stack level 0 regular stack pointer */
+#define MSR_IA32_FRED_RSP1              0x000001cd       /* Stack level 1 regular stack pointer */
+#define MSR_IA32_FRED_RSP2              0x000001ce       /* Stack level 2 regular stack pointer */
+#define MSR_IA32_FRED_RSP3              0x000001cf       /* Stack level 3 regular stack pointer */
+#define MSR_IA32_FRED_STKLVLS           0x000001d0       /* FRED exception stack levels */
+#define MSR_IA32_FRED_SSP1              0x000001d1       /* Stack level 1 shadow stack pointer in ring 0 */
+#define MSR_IA32_FRED_SSP2              0x000001d2       /* Stack level 2 shadow stack pointer in ring 0 */
+#define MSR_IA32_FRED_SSP3              0x000001d3       /* Stack level 3 shadow stack pointer in ring 0 */
+#define MSR_IA32_FRED_CONFIG            0x000001d4       /* FRED Entrypoint and interrupt stack level */
+
 #define MSR_IA32_BNDCFGS                0x00000d90
 #define MSR_IA32_XSS                    0x00000da0
 #define MSR_IA32_UMWAIT_CONTROL         0xe1
@@ -1687,6 +1698,17 @@ typedef struct CPUArchState {
     target_ulong cstar;
     target_ulong fmask;
     target_ulong kernelgsbase;
+
+    /* FRED MSRs */
+    uint64_t fred_rsp0;
+    uint64_t fred_rsp1;
+    uint64_t fred_rsp2;
+    uint64_t fred_rsp3;
+    uint64_t fred_stklvls;
+    uint64_t fred_ssp1;
+    uint64_t fred_ssp2;
+    uint64_t fred_ssp3;
+    uint64_t fred_config;
 #endif
 
     uint64_t tsc_adjust;
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 11b8177eff..101ff63805 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -3309,6 +3309,17 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
         kvm_msr_entry_add(cpu, MSR_KERNELGSBASE, env->kernelgsbase);
         kvm_msr_entry_add(cpu, MSR_FMASK, env->fmask);
         kvm_msr_entry_add(cpu, MSR_LSTAR, env->lstar);
+        if (env->features[FEAT_7_1_EAX] & CPUID_7_1_EAX_FRED) {
+            kvm_msr_entry_add(cpu, MSR_IA32_FRED_RSP0, env->fred_rsp0);
+            kvm_msr_entry_add(cpu, MSR_IA32_FRED_RSP1, env->fred_rsp1);
+            kvm_msr_entry_add(cpu, MSR_IA32_FRED_RSP2, env->fred_rsp2);
+            kvm_msr_entry_add(cpu, MSR_IA32_FRED_RSP3, env->fred_rsp3);
+            kvm_msr_entry_add(cpu, MSR_IA32_FRED_STKLVLS, env->fred_stklvls);
+            kvm_msr_entry_add(cpu, MSR_IA32_FRED_SSP1, env->fred_ssp1);
+            kvm_msr_entry_add(cpu, MSR_IA32_FRED_SSP2, env->fred_ssp2);
+            kvm_msr_entry_add(cpu, MSR_IA32_FRED_SSP3, env->fred_ssp3);
+            kvm_msr_entry_add(cpu, MSR_IA32_FRED_CONFIG, env->fred_config);
+        }
     }
 #endif
 
@@ -3773,6 +3784,17 @@ static int kvm_get_msrs(X86CPU *cpu)
         kvm_msr_entry_add(cpu, MSR_KERNELGSBASE, 0);
         kvm_msr_entry_add(cpu, MSR_FMASK, 0);
         kvm_msr_entry_add(cpu, MSR_LSTAR, 0);
+        if (env->features[FEAT_7_1_EAX] & CPUID_7_1_EAX_FRED) {
+            kvm_msr_entry_add(cpu, MSR_IA32_FRED_RSP0, 0);
+            kvm_msr_entry_add(cpu, MSR_IA32_FRED_RSP1, 0);
+            kvm_msr_entry_add(cpu, MSR_IA32_FRED_RSP2, 0);
+            kvm_msr_entry_add(cpu, MSR_IA32_FRED_RSP3, 0);
+            kvm_msr_entry_add(cpu, MSR_IA32_FRED_STKLVLS, 0);
+            kvm_msr_entry_add(cpu, MSR_IA32_FRED_SSP1, 0);
+            kvm_msr_entry_add(cpu, MSR_IA32_FRED_SSP2, 0);
+            kvm_msr_entry_add(cpu, MSR_IA32_FRED_SSP3, 0);
+            kvm_msr_entry_add(cpu, MSR_IA32_FRED_CONFIG, 0);
+        }
     }
 #endif
     kvm_msr_entry_add(cpu, MSR_KVM_SYSTEM_TIME, 0);
@@ -3994,6 +4016,33 @@ static int kvm_get_msrs(X86CPU *cpu)
         case MSR_LSTAR:
             env->lstar = msrs[i].data;
             break;
+        case MSR_IA32_FRED_RSP0:
+            env->fred_rsp0 = msrs[i].data;
+            break;
+        case MSR_IA32_FRED_RSP1:
+            env->fred_rsp1 = msrs[i].data;
+            break;
+        case MSR_IA32_FRED_RSP2:
+            env->fred_rsp2 = msrs[i].data;
+            break;
+        case MSR_IA32_FRED_RSP3:
+            env->fred_rsp3 = msrs[i].data;
+            break;
+        case MSR_IA32_FRED_STKLVLS:
+            env->fred_stklvls = msrs[i].data;
+            break;
+        case MSR_IA32_FRED_SSP1:
+            env->fred_ssp1 = msrs[i].data;
+            break;
+        case MSR_IA32_FRED_SSP2:
+            env->fred_ssp2 = msrs[i].data;
+            break;
+        case MSR_IA32_FRED_SSP3:
+            env->fred_ssp3 = msrs[i].data;
+            break;
+        case MSR_IA32_FRED_CONFIG:
+            env->fred_config = msrs[i].data;
+            break;
 #endif
         case MSR_IA32_TSC:
             env->tsc = msrs[i].data;
diff --git a/target/i386/machine.c b/target/i386/machine.c
index a1041ef828..850a19cb8e 100644
--- a/target/i386/machine.c
+++ b/target/i386/machine.c
@@ -1544,6 +1544,33 @@ static const VMStateDescription vmstate_msr_xfd = {
 };
 
 #ifdef TARGET_X86_64
+static bool intel_fred_msrs_needed(void *opaque)
+{
+    X86CPU *cpu = opaque;
+    CPUX86State *env = &cpu->env;
+
+    return !!(env->features[FEAT_7_1_EAX] & CPUID_7_1_EAX_FRED);
+}
+
+static const VMStateDescription vmstate_msr_fred = {
+    .name = "cpu/fred",
+    .version_id = 1,
+    .minimum_version_id = 1,
+    .needed = intel_fred_msrs_needed,
+    .fields = (VMStateField[]) {
+        VMSTATE_UINT64(env.fred_rsp0, X86CPU),
+        VMSTATE_UINT64(env.fred_rsp1, X86CPU),
+        VMSTATE_UINT64(env.fred_rsp2, X86CPU),
+        VMSTATE_UINT64(env.fred_rsp3, X86CPU),
+        VMSTATE_UINT64(env.fred_stklvls, X86CPU),
+        VMSTATE_UINT64(env.fred_ssp1, X86CPU),
+        VMSTATE_UINT64(env.fred_ssp2, X86CPU),
+        VMSTATE_UINT64(env.fred_ssp3, X86CPU),
+        VMSTATE_UINT64(env.fred_config, X86CPU),
+        VMSTATE_END_OF_LIST()
+            }
+        };
+
 static bool amx_xtile_needed(void *opaque)
 {
     X86CPU *cpu = opaque;
@@ -1747,6 +1774,7 @@ const VMStateDescription vmstate_x86_cpu = {
         &vmstate_pdptrs,
         &vmstate_msr_xfd,
 #ifdef TARGET_X86_64
+        &vmstate_msr_fred,
         &vmstate_amx_xtile,
 #endif
         &vmstate_arch_lbr,
-- 
2.42.0


