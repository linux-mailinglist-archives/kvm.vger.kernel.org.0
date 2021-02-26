Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC51325B76
	for <lists+kvm@lfdr.de>; Fri, 26 Feb 2021 03:11:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbhBZCK2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Feb 2021 21:10:28 -0500
Received: from mga03.intel.com ([134.134.136.65]:38817 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229508AbhBZCK0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Feb 2021 21:10:26 -0500
IronPort-SDR: pcgBFgUmuEY9Jnb/bitu+bwoTZOAIYNavK/MyB2Q9aXu8x8XfG1RtS5MEsU9f7e8J4jR3I3xdC
 5Wk421JB+/Bg==
X-IronPort-AV: E=McAfee;i="6000,8403,9906"; a="185801040"
X-IronPort-AV: E=Sophos;i="5.81,207,1610438400"; 
   d="scan'208";a="185801040"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2021 18:09:35 -0800
IronPort-SDR: JDHpce75e1uFfvdHv/L9hyXSWvhZ3ObaTrnDgG90MBW4X34CoWaT1C2iYeQcv8QdMlp4vR/Dw+
 Zk84rCAswIgA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,207,1610438400"; 
   d="scan'208";a="404680085"
Received: from unknown (HELO local-michael-cet-test.sh.intel.com) ([10.239.159.166])
  by orsmga008.jf.intel.com with ESMTP; 25 Feb 2021 18:09:33 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, richard.henderson@linaro.org,
        ehabkost@redhat.com, mtosatti@redhat.com,
        sean.j.christopherson@intel.com, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v7 4/6] target/i386: Add user-space MSR access interface for CET
Date:   Fri, 26 Feb 2021 10:20:56 +0800
Message-Id: <20210226022058.24562-5-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20210226022058.24562-1-weijiang.yang@intel.com>
References: <20210226022058.24562-1-weijiang.yang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CET states are divided into user-mode and supervisor-mode states,
MSR_KVM_GUEST_SSP holds current SHSTK pointer in use, MSR_IA32_U_CET and
MSR_IA32_PL3_SSP are for user-mode states, others are for supervisor-mode
states. Expose access according to current CET supported bits in CPUID
and XSS.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 target/i386/cpu.h | 18 ++++++++++++
 target/i386/kvm.c | 72 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 90 insertions(+)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index a43fb6d597..83628e823c 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -484,6 +484,15 @@ typedef enum X86Seg {
 #define MSR_IA32_VMX_TRUE_ENTRY_CTLS     0x00000490
 #define MSR_IA32_VMX_VMFUNC             0x00000491
 
+#define MSR_IA32_U_CET                  0x000006a0
+#define MSR_IA32_S_CET                  0x000006a2
+#define MSR_IA32_PL0_SSP                0x000006a4
+#define MSR_IA32_PL1_SSP                0x000006a5
+#define MSR_IA32_PL2_SSP                0x000006a6
+#define MSR_IA32_PL3_SSP                0x000006a7
+#define MSR_IA32_SSP_TBL                0x000006a8
+#define MSR_KVM_GUEST_SSP               0x4b564d08
+
 #define XSTATE_FP_BIT                   0
 #define XSTATE_SSE_BIT                  1
 #define XSTATE_YMM_BIT                  2
@@ -1584,6 +1593,15 @@ typedef struct CPUX86State {
 
     uintptr_t retaddr;
 
+    uint64_t u_cet;
+    uint64_t s_cet;
+    uint64_t pl0_ssp;
+    uint64_t pl1_ssp;
+    uint64_t pl2_ssp;
+    uint64_t pl3_ssp;
+    uint64_t ssp_tbl;
+    uint64_t guest_ssp;
+
     /* Fields up to this point are cleared by a CPU reset */
     struct {} end_reset_fields;
 
diff --git a/target/i386/kvm.c b/target/i386/kvm.c
index a2934dda02..67d5203d19 100644
--- a/target/i386/kvm.c
+++ b/target/i386/kvm.c
@@ -2992,6 +2992,30 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
         }
     }
 
+    if (((env->features[FEAT_7_0_ECX] & CPUID_7_0_ECX_CET_SHSTK) ||
+        (env->features[FEAT_7_0_EDX] & CPUID_7_0_EDX_CET_IBT)) &&
+        (env->features[FEAT_XSAVE_XSS_LO] & XSTATE_CET_U_MASK)) {
+        kvm_msr_entry_add(cpu, MSR_IA32_U_CET, env->u_cet);
+        kvm_msr_entry_add(cpu, MSR_IA32_PL3_SSP, env->pl3_ssp);
+    }
+
+    if (env->features[FEAT_XSAVE_XSS_LO] & XSTATE_CET_S_MASK) {
+        if (env->features[FEAT_7_0_ECX] & CPUID_7_0_ECX_CET_SHSTK) {
+            kvm_msr_entry_add(cpu, MSR_IA32_PL0_SSP, env->pl0_ssp);
+            kvm_msr_entry_add(cpu, MSR_IA32_PL1_SSP, env->pl1_ssp);
+            kvm_msr_entry_add(cpu, MSR_IA32_PL2_SSP, env->pl2_ssp);
+            kvm_msr_entry_add(cpu, MSR_IA32_SSP_TBL, env->ssp_tbl);
+        }
+
+        kvm_msr_entry_add(cpu, MSR_IA32_S_CET, env->s_cet);
+    }
+
+    if ((env->features[FEAT_7_0_ECX] & CPUID_7_0_ECX_CET_SHSTK) &&
+        (env->features[FEAT_XSAVE_XSS_LO] & (XSTATE_CET_U_MASK |
+        XSTATE_CET_S_MASK))) {
+        kvm_msr_entry_add(cpu, MSR_KVM_GUEST_SSP, env->guest_ssp);
+    }
+
     return kvm_buf_set_msrs(cpu);
 }
 
@@ -3311,6 +3335,30 @@ static int kvm_get_msrs(X86CPU *cpu)
         }
     }
 
+    if (((env->features[FEAT_7_0_ECX] & CPUID_7_0_ECX_CET_SHSTK) ||
+        (env->features[FEAT_7_0_EDX] & CPUID_7_0_EDX_CET_IBT)) &&
+        (env->features[FEAT_XSAVE_XSS_LO] & XSTATE_CET_U_MASK)) {
+        kvm_msr_entry_add(cpu, MSR_IA32_U_CET, 0);
+        kvm_msr_entry_add(cpu, MSR_IA32_PL3_SSP, 0);
+    }
+
+    if (env->features[FEAT_XSAVE_XSS_LO] & XSTATE_CET_S_MASK) {
+        if (env->features[FEAT_7_0_ECX] & CPUID_7_0_ECX_CET_SHSTK) {
+            kvm_msr_entry_add(cpu, MSR_IA32_PL0_SSP, 0);
+            kvm_msr_entry_add(cpu, MSR_IA32_PL1_SSP, 0);
+            kvm_msr_entry_add(cpu, MSR_IA32_PL2_SSP, 0);
+            kvm_msr_entry_add(cpu, MSR_IA32_SSP_TBL, 0);
+        }
+
+        kvm_msr_entry_add(cpu, MSR_IA32_S_CET, 0);
+    }
+
+    if ((env->features[FEAT_7_0_ECX] & CPUID_7_0_ECX_CET_SHSTK) &&
+        (env->features[FEAT_XSAVE_XSS_LO] & (XSTATE_CET_U_MASK |
+        XSTATE_CET_S_MASK))) {
+        kvm_msr_entry_add(cpu, MSR_KVM_GUEST_SSP, 0);
+    }
+
     ret = kvm_vcpu_ioctl(CPU(cpu), KVM_GET_MSRS, cpu->kvm_msr_buf);
     if (ret < 0) {
         return ret;
@@ -3597,6 +3645,30 @@ static int kvm_get_msrs(X86CPU *cpu)
         case MSR_IA32_RTIT_ADDR0_A ... MSR_IA32_RTIT_ADDR3_B:
             env->msr_rtit_addrs[index - MSR_IA32_RTIT_ADDR0_A] = msrs[i].data;
             break;
+        case MSR_IA32_U_CET:
+            env->u_cet = msrs[i].data;
+            break;
+        case MSR_IA32_S_CET:
+            env->s_cet = msrs[i].data;
+            break;
+        case MSR_IA32_PL0_SSP:
+            env->pl0_ssp = msrs[i].data;
+            break;
+        case MSR_IA32_PL1_SSP:
+            env->pl1_ssp = msrs[i].data;
+            break;
+        case MSR_IA32_PL2_SSP:
+            env->pl2_ssp = msrs[i].data;
+            break;
+        case MSR_IA32_PL3_SSP:
+            env->pl3_ssp = msrs[i].data;
+            break;
+        case MSR_IA32_SSP_TBL:
+            env->ssp_tbl = msrs[i].data;
+            break;
+        case MSR_KVM_GUEST_SSP:
+            env->guest_ssp = msrs[i].data;
+            break;
         }
     }
 
-- 
2.26.2

