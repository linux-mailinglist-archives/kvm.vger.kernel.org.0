Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9D694B8365
	for <lists+kvm@lfdr.de>; Wed, 16 Feb 2022 09:55:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231810AbiBPIyX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Feb 2022 03:54:23 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:48720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231795AbiBPIyU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Feb 2022 03:54:20 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D8832ABD05
        for <kvm@vger.kernel.org>; Wed, 16 Feb 2022 00:54:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645001648; x=1676537648;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2hjc6Pok40xB2Li4GkMnvzkMlmAWKbYNYxRDyWlF/w0=;
  b=lHYYviXeOXNUROytHXK7Si0yjHyN8f94SzEg1R/SXyPv4YAFonEfgBpM
   Lblo6SXs0mgQ3wYapLSqyR66jGBCU6r7CsceU44s2BCMwaNvALBbw47tq
   jwVVFL2cQnLfceHKilrSi79u0gPQmPxm6wkOKjb0KoWjN4+3ZUdBTHSS8
   YGYZiSvTy256cMus29ciS2cbK/8DmVAM7M4SD3am9NU4rYqXasRj5EPFE
   Vv3T+Qgekts+GFd98Yt1/6XqJM4HDWWSQ1pKP9ojDRKnI+VmCreDEvplh
   EKyVygm0PbtRGOGazKrk4CYdHDdlKO/K0X2JbGgwu5PcwYNMvjDKoqPHn
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10259"; a="275135806"
X-IronPort-AV: E=Sophos;i="5.88,373,1635231600"; 
   d="scan'208";a="275135806"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2022 00:54:07 -0800
X-IronPort-AV: E=Sophos;i="5.88,373,1635231600"; 
   d="scan'208";a="633418289"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2022 00:54:07 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, ehabkost@redhat.com, mtosatti@redhat.com,
        seanjc@google.com, richard.henderson@linaro.org,
        like.xu.linux@gmail.com, wei.w.wang@intel.com,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH 6/8] target/i386: Add MSR access interface for Arch LBR
Date:   Tue, 15 Feb 2022 14:52:56 -0500
Message-Id: <20220215195258.29149-7-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220215195258.29149-1-weijiang.yang@intel.com>
References: <20220215195258.29149-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DATE_IN_PAST_12_24,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In the first generation of Arch LBR, the max support
Arch LBR depth is 32, both host and guest use the value
to set depth MSR. This can simplify the implementation
of patch given the side-effect of mismatch of host/guest
depth MSR: XRSTORS will reset all recording MSRs to 0s
if the saved depth mismatches MSR_ARCH_LBR_DEPTH.

In most of the cases Arch LBR is not in active status,
so check the control bit before save/restore the big
chunck of Arch LBR MSRs.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 target/i386/cpu.h     | 10 +++++++
 target/i386/kvm/kvm.c | 67 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 77 insertions(+)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 07b198539b..0cadd37c47 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -388,6 +388,11 @@ typedef enum X86Seg {
 #define MSR_IA32_TSX_CTRL		0x122
 #define MSR_IA32_TSCDEADLINE            0x6e0
 #define MSR_IA32_PKRS                   0x6e1
+#define MSR_ARCH_LBR_CTL                0x000014ce
+#define MSR_ARCH_LBR_DEPTH              0x000014cf
+#define MSR_ARCH_LBR_FROM_0             0x00001500
+#define MSR_ARCH_LBR_TO_0               0x00001600
+#define MSR_ARCH_LBR_INFO_0             0x00001200
 
 #define FEATURE_CONTROL_LOCKED                    (1<<0)
 #define FEATURE_CONTROL_VMXON_ENABLED_INSIDE_SMX  (1ULL << 1)
@@ -1659,6 +1664,11 @@ typedef struct CPUX86State {
     uint64_t msr_xfd;
     uint64_t msr_xfd_err;
 
+    /* Per-VCPU Arch LBR MSRs */
+    uint64_t msr_lbr_ctl;
+    uint64_t msr_lbr_depth;
+    LBR_ENTRY lbr_records[ARCH_LBR_NR_ENTRIES];
+
     /* exception/interrupt handling */
     int error_code;
     int exception_is_int;
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 764d110e0f..974ff3c0a5 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -3273,6 +3273,38 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
                               env->msr_xfd_err);
         }
 
+        if (kvm_enabled() && cpu->enable_pmu &&
+            (env->features[FEAT_7_0_EDX] & CPUID_7_0_EDX_ARCH_LBR)) {
+            uint64_t depth;
+            int i, ret;
+
+            /*
+             * Only migrate Arch LBR states when: 1) Arch LBR is enabled
+             * for migrated vcpu. 2) the host Arch LBR depth equals that
+             * of source guest's, this is to avoid mismatch of guest/host
+             * config for the msr hence avoid unexpected misbehavior.
+             */
+            ret = kvm_get_one_msr(cpu, MSR_ARCH_LBR_DEPTH, &depth);
+
+            if (ret == 1 && (env->msr_lbr_ctl & 0x1) && !!depth &&
+                depth == env->msr_lbr_depth) {
+                kvm_msr_entry_add(cpu, MSR_ARCH_LBR_CTL, env->msr_lbr_ctl);
+                kvm_msr_entry_add(cpu, MSR_ARCH_LBR_DEPTH, env->msr_lbr_depth);
+
+                for (i = 0; i < ARCH_LBR_NR_ENTRIES; i++) {
+                    if (!env->lbr_records[i].from) {
+                        continue;
+                    }
+                    kvm_msr_entry_add(cpu, MSR_ARCH_LBR_FROM_0 + i,
+                                      env->lbr_records[i].from);
+                    kvm_msr_entry_add(cpu, MSR_ARCH_LBR_TO_0 + i,
+                                      env->lbr_records[i].to);
+                    kvm_msr_entry_add(cpu, MSR_ARCH_LBR_INFO_0 + i,
+                                      env->lbr_records[i].info);
+                }
+            }
+        }
+
         /* Note: MSR_IA32_FEATURE_CONTROL is written separately, see
          *       kvm_put_msr_feature_control. */
     }
@@ -3670,6 +3702,26 @@ static int kvm_get_msrs(X86CPU *cpu)
         kvm_msr_entry_add(cpu, MSR_IA32_XFD_ERR, 0);
     }
 
+    if (kvm_enabled() && cpu->enable_pmu &&
+        (env->features[FEAT_7_0_EDX] & CPUID_7_0_EDX_ARCH_LBR)) {
+        uint64_t ctl, depth;
+        int i, ret2;
+
+        ret = kvm_get_one_msr(cpu, MSR_ARCH_LBR_CTL, &ctl);
+        ret2 = kvm_get_one_msr(cpu, MSR_ARCH_LBR_DEPTH, &depth);
+        if (ret == 1 && ret2 == 1 && (ctl & 0x1) &&
+            depth == ARCH_LBR_NR_ENTRIES) {
+            kvm_msr_entry_add(cpu, MSR_ARCH_LBR_CTL, 0);
+            kvm_msr_entry_add(cpu, MSR_ARCH_LBR_DEPTH, 0);
+
+            for (i = 0; i < ARCH_LBR_NR_ENTRIES; i++) {
+                kvm_msr_entry_add(cpu, MSR_ARCH_LBR_FROM_0 + i, 0);
+                kvm_msr_entry_add(cpu, MSR_ARCH_LBR_TO_0 + i, 0);
+                kvm_msr_entry_add(cpu, MSR_ARCH_LBR_INFO_0 + i, 0);
+            }
+        }
+    }
+
     ret = kvm_vcpu_ioctl(CPU(cpu), KVM_GET_MSRS, cpu->kvm_msr_buf);
     if (ret < 0) {
         return ret;
@@ -3972,6 +4024,21 @@ static int kvm_get_msrs(X86CPU *cpu)
         case MSR_IA32_XFD_ERR:
             env->msr_xfd_err = msrs[i].data;
             break;
+        case MSR_ARCH_LBR_CTL:
+            env->msr_lbr_ctl = msrs[i].data;
+            break;
+        case MSR_ARCH_LBR_DEPTH:
+            env->msr_lbr_depth = msrs[i].data;
+            break;
+        case MSR_ARCH_LBR_FROM_0 ... MSR_ARCH_LBR_FROM_0 + 31:
+            env->lbr_records[index - MSR_ARCH_LBR_FROM_0].from = msrs[i].data;
+            break;
+        case MSR_ARCH_LBR_TO_0 ... MSR_ARCH_LBR_TO_0 + 31:
+            env->lbr_records[index - MSR_ARCH_LBR_TO_0].to = msrs[i].data;
+            break;
+        case MSR_ARCH_LBR_INFO_0 ... MSR_ARCH_LBR_INFO_0 + 31:
+            env->lbr_records[index - MSR_ARCH_LBR_INFO_0].info = msrs[i].data;
+            break;
         }
     }
 
-- 
2.27.0

