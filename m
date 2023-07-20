Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08A3775B112
	for <lists+kvm@lfdr.de>; Thu, 20 Jul 2023 16:19:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232155AbjGTOTw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jul 2023 10:19:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232141AbjGTOTt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jul 2023 10:19:49 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DBA02126
        for <kvm@vger.kernel.org>; Thu, 20 Jul 2023 07:19:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689862788; x=1721398788;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=M/a3wHNklegTy0CnAtcx63Fey327xDt1/DhN1RH7MDU=;
  b=IpkQoUxq9r5UOIyq4Ebscvi0I9dnBjMmcz7/joFiWBc7CUGJ+0b6V9Mu
   n1PN1AhA8qZ5qjiEsxXfOegXHgyqgPtuuJ80tXvQx9Ij/TbJcw4XEoCJb
   KnWAsNTFetfk8ONnA48k45KuQdmMLXK666hdKEauxqmKRDh0EtSDLCs1O
   kNCDVqhctoM5uF0LKqAOAl+UzCLcqtpiQd22itMf7KLGl/J2OxhP1x2Zw
   ScwL40OxlqufGO9wM9Yb1QBfhe48iQgSRRDtjNFIg3fda6d7W9b+fjRhu
   wqpn55InldsdBd/5PO6poEb0NV5c1bjmNK8r19QTOFzWOJKongmCZWU4W
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10777"; a="397629174"
X-IronPort-AV: E=Sophos;i="6.01,219,1684825200"; 
   d="scan'208";a="397629174"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2023 07:19:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10777"; a="898295622"
X-IronPort-AV: E=Sophos;i="6.01,219,1684825200"; 
   d="scan'208";a="898295622"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2023 07:19:29 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, mtosatti@redhat.com, seanjc@google.com,
        qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, weijiang.yang@intel.com
Subject: [PATCH v2 2/4] target/i386: Add CET MSRs access interface
Date:   Thu, 20 Jul 2023 07:14:43 -0400
Message-Id: <20230720111445.99509-3-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230720111445.99509-1-weijiang.yang@intel.com>
References: <20230720111445.99509-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CET MSRs include:
MSR_IA32_U_CET - user mode CET control bits.
MSR_IA32_S_CET - supervisor mode CET control bits.
MSR_IA32_PL{0,1,2,3}_SSP - linear addresses of SSPs for user/kernel modes.
MSR_IA32_SSP_TBL_ADDR - linear address of interrupt SSP table
MSR_KVM_GUEST_SSP - current shadow stack pointer

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 target/i386/cpu.h     | 18 +++++++++++++
 target/i386/kvm/kvm.c | 59 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 77 insertions(+)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 06855e0926..ef1f3d6138 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -545,6 +545,15 @@ typedef enum X86Seg {
 #define MSR_IA32_VMX_TRUE_ENTRY_CTLS     0x00000490
 #define MSR_IA32_VMX_VMFUNC             0x00000491
 
+#define MSR_IA32_U_CET                  0x000006a0
+#define MSR_IA32_S_CET                  0x000006a2
+#define MSR_IA32_PL0_SSP                0x000006a4
+#define MSR_IA32_PL1_SSP                0x000006a5
+#define MSR_IA32_PL2_SSP                0x000006a6
+#define MSR_IA32_PL3_SSP                0x000006a7
+#define MSR_IA32_SSP_TBL_ADDR           0x000006a8
+#define MSR_KVM_GUEST_SSP               0x4b564d09
+
 #define XSTATE_FP_BIT                   0
 #define XSTATE_SSE_BIT                  1
 #define XSTATE_YMM_BIT                  2
@@ -1766,6 +1775,15 @@ typedef struct CPUArchState {
 
     uintptr_t retaddr;
 
+    uint64_t u_cet;
+    uint64_t s_cet;
+    uint64_t pl0_ssp;
+    uint64_t pl1_ssp;
+    uint64_t pl2_ssp;
+    uint64_t pl3_ssp;
+    uint64_t ssp_table_addr;
+    uint64_t guest_ssp;
+
     /* Fields up to this point are cleared by a CPU reset */
     struct {} end_reset_fields;
 
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index de531842f6..ab3a755b97 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -3591,6 +3591,24 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
                               env->msr_ia32_sgxlepubkeyhash[3]);
         }
 
+        if ((env->features[FEAT_XSAVE_XSS_LO] & XSTATE_CET_U_MASK) &&
+            (env->features[FEAT_XSAVE_XSS_LO] & XSTATE_CET_S_MASK)) {
+            if (env->features[FEAT_7_0_ECX] & CPUID_7_0_ECX_CET_SHSTK) {
+                kvm_msr_entry_add(cpu, MSR_IA32_U_CET, env->u_cet);
+                kvm_msr_entry_add(cpu, MSR_IA32_S_CET, env->s_cet);
+                kvm_msr_entry_add(cpu, MSR_KVM_GUEST_SSP, env->guest_ssp);
+                kvm_msr_entry_add(cpu, MSR_IA32_PL0_SSP, env->pl0_ssp);
+                kvm_msr_entry_add(cpu, MSR_IA32_PL1_SSP, env->pl1_ssp);
+                kvm_msr_entry_add(cpu, MSR_IA32_PL2_SSP, env->pl2_ssp);
+                kvm_msr_entry_add(cpu, MSR_IA32_PL3_SSP, env->pl3_ssp);
+                kvm_msr_entry_add(cpu, MSR_IA32_SSP_TBL_ADDR,
+                                  env->ssp_table_addr);
+            } else if (env->features[FEAT_7_0_EDX] & CPUID_7_0_EDX_CET_IBT) {
+                kvm_msr_entry_add(cpu, MSR_IA32_U_CET, env->u_cet);
+                kvm_msr_entry_add(cpu, MSR_IA32_S_CET, env->s_cet);
+            }
+        }
+
         if (env->features[FEAT_XSAVE] & CPUID_D_1_EAX_XFD) {
             kvm_msr_entry_add(cpu, MSR_IA32_XFD,
                               env->msr_xfd);
@@ -4024,6 +4042,23 @@ static int kvm_get_msrs(X86CPU *cpu)
         kvm_msr_entry_add(cpu, MSR_IA32_SGXLEPUBKEYHASH3, 0);
     }
 
+    if ((env->features[FEAT_XSAVE_XSS_LO] & XSTATE_CET_U_MASK) &&
+        (env->features[FEAT_XSAVE_XSS_LO] & XSTATE_CET_S_MASK)) {
+            if (env->features[FEAT_7_0_ECX] & CPUID_7_0_ECX_CET_SHSTK) {
+                kvm_msr_entry_add(cpu, MSR_IA32_U_CET, 0);
+                kvm_msr_entry_add(cpu, MSR_IA32_S_CET, 0);
+                kvm_msr_entry_add(cpu, MSR_KVM_GUEST_SSP, 0);
+                kvm_msr_entry_add(cpu, MSR_IA32_PL0_SSP, 0);
+                kvm_msr_entry_add(cpu, MSR_IA32_PL1_SSP, 0);
+                kvm_msr_entry_add(cpu, MSR_IA32_PL2_SSP, 0);
+                kvm_msr_entry_add(cpu, MSR_IA32_PL3_SSP, 0);
+                kvm_msr_entry_add(cpu, MSR_IA32_SSP_TBL_ADDR, 0);
+             } else if (env->features[FEAT_7_0_EDX] & CPUID_7_0_EDX_CET_IBT) {
+                kvm_msr_entry_add(cpu, MSR_IA32_U_CET, 0);
+                kvm_msr_entry_add(cpu, MSR_IA32_S_CET, 0);
+            }
+    }
+
     if (env->features[FEAT_XSAVE] & CPUID_D_1_EAX_XFD) {
         kvm_msr_entry_add(cpu, MSR_IA32_XFD, 0);
         kvm_msr_entry_add(cpu, MSR_IA32_XFD_ERR, 0);
@@ -4346,6 +4381,30 @@ static int kvm_get_msrs(X86CPU *cpu)
             env->msr_ia32_sgxlepubkeyhash[index - MSR_IA32_SGXLEPUBKEYHASH0] =
                            msrs[i].data;
             break;
+        case MSR_IA32_U_CET:
+            env->u_cet = msrs[i].data;
+            break;
+        case MSR_IA32_S_CET:
+            env->s_cet = msrs[i].data;
+            break;
+        case MSR_KVM_GUEST_SSP:
+            env->guest_ssp = msrs[i].data;
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
+        case MSR_IA32_SSP_TBL_ADDR:
+            env->ssp_table_addr = msrs[i].data;
+            break;
         case MSR_IA32_XFD:
             env->msr_xfd = msrs[i].data;
             break;
-- 
2.27.0

