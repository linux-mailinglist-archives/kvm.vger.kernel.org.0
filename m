Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 754D26EA475
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 09:17:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbjDUHRA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 03:17:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbjDUHQz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 03:16:55 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFB00210B
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 00:16:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682061413; x=1713597413;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=q49+U447u2dX8OZEmGwYu4+4pk7aWYQAaNivI2RgVRk=;
  b=j5lq+j/EtbuQk3jqmL/iDiv0g5td8S/EazJNSk5HJWr2zOBip9/BBEdw
   yUuqCDzowHwkk4YOCfUcOrX2AiL3e+br+q7jyRDUOeoIb/tg/niyQJtRY
   NYAfFrV7qnmW98SB/dCIoJf1+g8Rux+dg6EiyJKD3p8EhTTAxKdtat0+7
   d2shYAkFyk6lLKuh/tiRsrF8Zz6YF8XpXziYWDeeukxJQNiXmFjGuRWT9
   XZGHq7eM7cQ2hbEco8MHW3tq62igiYNXXHykjYuN20gZsB06di2vIHAn6
   ER2PO6YlXlyUZ+kbMbqzul5TK5LFDO39uxf7v7oTESmHpSs3rzEa6d4tO
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="326260545"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="326260545"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 00:16:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="938385326"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="938385326"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 00:16:39 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, mtosatti@redhat.com, seanjc@google.com,
        qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, weijiang.yang@intel.com
Subject: [PATCH 2/4] target/i386: Add CET MSRs access interfaces
Date:   Fri, 21 Apr 2023 00:12:25 -0400
Message-Id: <20230421041227.90915-3-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230421041227.90915-1-weijiang.yang@intel.com>
References: <20230421041227.90915-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add access interfaces for supported CET MSRs.
These CET MSRs include:
MSR_IA32_U_CET - store user mode CET control bits.
MSR_IA32_S_CET - store supervisor mode CET control bits.
MSR_IA32_PL3_SSP - strore user mode shadow stack pointer.
MSR_KVM_GUEST_SSP - store current shadow stack pointer.

Other MSRs, i.e., MSR_IA32_PL{0,1,2}_SSP and MSR_IA32_INTR_SSP_TBL
are for non-supported supervisor mode shadow stack, are ignored now.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 target/i386/cpu.h     | 10 ++++++++++
 target/i386/kvm/kvm.c | 44 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 54 insertions(+)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 6526a03206..b78ce8e5c4 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -545,6 +545,11 @@ typedef enum X86Seg {
 #define MSR_IA32_VMX_TRUE_ENTRY_CTLS     0x00000490
 #define MSR_IA32_VMX_VMFUNC             0x00000491
 
+#define MSR_IA32_U_CET                  0x000006a0
+#define MSR_IA32_S_CET                  0x000006a2
+#define MSR_IA32_PL3_SSP                0x000006a7
+#define MSR_KVM_GUEST_SSP               0x4b564d09
+
 #define XSTATE_FP_BIT                   0
 #define XSTATE_SSE_BIT                  1
 #define XSTATE_YMM_BIT                  2
@@ -1756,6 +1761,11 @@ typedef struct CPUArchState {
 
     uintptr_t retaddr;
 
+    uint64_t u_cet;
+    uint64_t s_cet;
+    uint64_t pl3_ssp;
+    uint64_t guest_ssp;
+
     /* Fields up to this point are cleared by a CPU reset */
     struct {} end_reset_fields;
 
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index de531842f6..13fae898ce 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -3646,6 +3646,22 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
         }
     }
 
+    if (((env->features[FEAT_7_0_ECX] & CPUID_7_0_ECX_CET_SHSTK) ||
+        (env->features[FEAT_7_0_EDX] & CPUID_7_0_EDX_CET_IBT)) &&
+        (env->features[FEAT_XSAVE_XSS_LO] & XSTATE_CET_U_MASK)) {
+        kvm_msr_entry_add(cpu, MSR_IA32_U_CET, env->u_cet);
+        kvm_msr_entry_add(cpu, MSR_IA32_PL3_SSP, env->pl3_ssp);
+    }
+
+    if ((env->features[FEAT_7_0_ECX] & CPUID_7_0_ECX_CET_SHSTK) &&
+        (env->features[FEAT_XSAVE_XSS_LO] & XSTATE_CET_U_MASK)) {
+        kvm_msr_entry_add(cpu, MSR_KVM_GUEST_SSP, env->guest_ssp);
+    }
+
+    if (env->features[FEAT_7_0_EDX] & CPUID_7_0_EDX_CET_IBT) {
+        kvm_msr_entry_add(cpu, MSR_IA32_S_CET, env->s_cet);
+    }
+
     return kvm_buf_set_msrs(cpu);
 }
 
@@ -4024,6 +4040,22 @@ static int kvm_get_msrs(X86CPU *cpu)
         kvm_msr_entry_add(cpu, MSR_IA32_SGXLEPUBKEYHASH3, 0);
     }
 
+    if (((env->features[FEAT_7_0_ECX] & CPUID_7_0_ECX_CET_SHSTK) ||
+        (env->features[FEAT_7_0_EDX] & CPUID_7_0_EDX_CET_IBT)) &&
+        (env->features[FEAT_XSAVE_XSS_LO] & XSTATE_CET_U_MASK)) {
+        kvm_msr_entry_add(cpu, MSR_IA32_U_CET, 0);
+        kvm_msr_entry_add(cpu, MSR_IA32_PL3_SSP, 0);
+    }
+
+    if ((env->features[FEAT_7_0_ECX] & CPUID_7_0_ECX_CET_SHSTK) &&
+        (env->features[FEAT_XSAVE_XSS_LO] & XSTATE_CET_U_MASK)) {
+        kvm_msr_entry_add(cpu, MSR_KVM_GUEST_SSP, 0);
+    }
+
+    if (env->features[FEAT_7_0_EDX] & CPUID_7_0_EDX_CET_IBT) {
+        kvm_msr_entry_add(cpu, MSR_IA32_S_CET, 0);
+    }
+
     if (env->features[FEAT_XSAVE] & CPUID_D_1_EAX_XFD) {
         kvm_msr_entry_add(cpu, MSR_IA32_XFD, 0);
         kvm_msr_entry_add(cpu, MSR_IA32_XFD_ERR, 0);
@@ -4346,6 +4378,18 @@ static int kvm_get_msrs(X86CPU *cpu)
             env->msr_ia32_sgxlepubkeyhash[index - MSR_IA32_SGXLEPUBKEYHASH0] =
                            msrs[i].data;
             break;
+        case MSR_IA32_U_CET:
+            env->u_cet = msrs[i].data;
+            break;
+        case MSR_IA32_S_CET:
+            env->s_cet = msrs[i].data;
+            break;
+        case MSR_IA32_PL3_SSP:
+            env->pl3_ssp = msrs[i].data;
+            break;
+        case MSR_KVM_GUEST_SSP:
+            env->guest_ssp = msrs[i].data;
+            break;
         case MSR_IA32_XFD:
             env->msr_xfd = msrs[i].data;
             break;
-- 
2.27.0

