Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 109BE7B4CDF
	for <lists+kvm@lfdr.de>; Mon,  2 Oct 2023 09:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235804AbjJBHw6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Oct 2023 03:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235802AbjJBHwz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Oct 2023 03:52:55 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48AF0D8
        for <kvm@vger.kernel.org>; Mon,  2 Oct 2023 00:52:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696233173; x=1727769173;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kw/yjSYXiI7ySaJO66BP5TFzDlJrtu/QbJsPliJ4Iec=;
  b=V1J7VdzUqnLm4LyAZ/2VZHTDC7mc06BTb7jw9q9/BYqOk2s/jlX30O/A
   m5KW9ORKyqVdi0Spp3USoJwOkFjdRf4kg4gQOc3S49hljeZks/uskZJTQ
   WksaQVEapTXkH6RWmH2NXcTuiu9E8Fpu7C3fFOKS0RcwMEYoD0xuQgp0A
   /+XXzeS+afRHDqo+TkKJYuCF5XOETq8hLJMSawVdOEVIV3wiOfhCegKGg
   HSQqeGRVZaJyj2KePtiwgUq8BaC0OpA+0/rTRTs/YgY7kpkh5WNnoYpok
   W2+tQr8WHLNxYQWNGHuchB3UTyZLKZmwmGvyjJ9NaojmYg8ZPM4SL+hy6
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10850"; a="361975583"
X-IronPort-AV: E=Sophos;i="6.03,193,1694761200"; 
   d="scan'208";a="361975583"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2023 00:52:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10850"; a="750511633"
X-IronPort-AV: E=Sophos;i="6.03,193,1694761200"; 
   d="scan'208";a="750511633"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by orsmga002.jf.intel.com with ESMTP; 02 Oct 2023 00:52:50 -0700
From:   Xin Li <xin3.li@intel.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, richard.henderson@linaro.org,
        pbonzini@redhat.com, eduardo@habkost.net, seanjc@google.com,
        chao.gao@intel.com, hpa@zytor.com, xiaoyao.li@intel.com,
        weijiang.yang@intel.com
Subject: [PATCH v2 4/4] target/i386: Add get/set/migrate support for FRED MSRs
Date:   Mon,  2 Oct 2023 00:23:13 -0700
Message-Id: <20231002072313.17603-5-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231002072313.17603-1-xin3.li@intel.com>
References: <20231002072313.17603-1-xin3.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

FRED CPU states are managed in 9 new FRED MSRs, in addtion to a few
existing CPU registers and MSRs, e.g., CR4.FRED and MSR_IA32_PL0_SSP.

Save/restore/migrate FRED MSRs if FRED is exposed to the guest.

Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 target/i386/cpu.h     | 26 +++++++++++++++++++++
 target/i386/kvm/kvm.c | 54 +++++++++++++++++++++++++++++++++++++++++++
 target/i386/machine.c | 29 +++++++++++++++++++++++
 3 files changed, 109 insertions(+)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index f4f0c57574..48e713ecc1 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -529,6 +529,20 @@ typedef enum X86Seg {
 #define MSR_IA32_XFD                    0x000001c4
 #define MSR_IA32_XFD_ERR                0x000001c5
 
+#define MSR_IA32_PL0_SSP                0x000006a4       /* Stack level 0 shadow stack pointer in ring 0 */
+
+/* FRED MSRs */
+#define MSR_IA32_FRED_RSP0              0x000001cc       /* Stack level 0 regular stack pointer */
+#define MSR_IA32_FRED_RSP1              0x000001cd       /* Stack level 1 regular stack pointer */
+#define MSR_IA32_FRED_RSP2              0x000001ce       /* Stack level 2 regular stack pointer */
+#define MSR_IA32_FRED_RSP3              0x000001cf       /* Stack level 3 regular stack pointer */
+#define MSR_IA32_FRED_STKLVLS           0x000001d0       /* FRED exception stack levels */
+#define MSR_IA32_FRED_SSP0              MSR_IA32_PL0_SSP /* Stack level 0 shadow stack pointer in ring 0 */
+#define MSR_IA32_FRED_SSP1              0x000001d1       /* Stack level 1 shadow stack pointer in ring 0 */
+#define MSR_IA32_FRED_SSP2              0x000001d2       /* Stack level 2 shadow stack pointer in ring 0 */
+#define MSR_IA32_FRED_SSP3              0x000001d3       /* Stack level 3 shadow stack pointer in ring 0 */
+#define MSR_IA32_FRED_CONFIG            0x000001d4       /* FRED Entrypoint and interrupt stack level */
+
 #define MSR_IA32_BNDCFGS                0x00000d90
 #define MSR_IA32_XSS                    0x00000da0
 #define MSR_IA32_UMWAIT_CONTROL         0xe1
@@ -1684,6 +1698,18 @@ typedef struct CPUArchState {
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
+    uint64_t fred_ssp0;
+    uint64_t fred_ssp1;
+    uint64_t fred_ssp2;
+    uint64_t fred_ssp3;
+    uint64_t fred_config;
 #endif
 
     uint64_t tsc_adjust;
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index f6c7f7e268..6ee3369a93 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -3399,6 +3399,18 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
         kvm_msr_entry_add(cpu, MSR_KERNELGSBASE, env->kernelgsbase);
         kvm_msr_entry_add(cpu, MSR_FMASK, env->fmask);
         kvm_msr_entry_add(cpu, MSR_LSTAR, env->lstar);
+        if (env->features[FEAT_7_1_EAX] & CPUID_7_1_EAX_FRED) {
+            kvm_msr_entry_add(cpu, MSR_IA32_FRED_RSP0, env->fred_rsp0);
+            kvm_msr_entry_add(cpu, MSR_IA32_FRED_RSP1, env->fred_rsp1);
+            kvm_msr_entry_add(cpu, MSR_IA32_FRED_RSP2, env->fred_rsp2);
+            kvm_msr_entry_add(cpu, MSR_IA32_FRED_RSP3, env->fred_rsp3);
+            kvm_msr_entry_add(cpu, MSR_IA32_FRED_STKLVLS, env->fred_stklvls);
+            kvm_msr_entry_add(cpu, MSR_IA32_FRED_SSP0, env->fred_ssp0);
+            kvm_msr_entry_add(cpu, MSR_IA32_FRED_SSP1, env->fred_ssp1);
+            kvm_msr_entry_add(cpu, MSR_IA32_FRED_SSP2, env->fred_ssp2);
+            kvm_msr_entry_add(cpu, MSR_IA32_FRED_SSP3, env->fred_ssp3);
+            kvm_msr_entry_add(cpu, MSR_IA32_FRED_CONFIG, env->fred_config);
+        }
     }
 #endif
 
@@ -3897,6 +3909,18 @@ static int kvm_get_msrs(X86CPU *cpu)
         kvm_msr_entry_add(cpu, MSR_KERNELGSBASE, 0);
         kvm_msr_entry_add(cpu, MSR_FMASK, 0);
         kvm_msr_entry_add(cpu, MSR_LSTAR, 0);
+        if (env->features[FEAT_7_1_EAX] & CPUID_7_1_EAX_FRED) {
+            kvm_msr_entry_add(cpu, MSR_IA32_FRED_RSP0, 0);
+            kvm_msr_entry_add(cpu, MSR_IA32_FRED_RSP1, 0);
+            kvm_msr_entry_add(cpu, MSR_IA32_FRED_RSP2, 0);
+            kvm_msr_entry_add(cpu, MSR_IA32_FRED_RSP3, 0);
+            kvm_msr_entry_add(cpu, MSR_IA32_FRED_STKLVLS, 0);
+            kvm_msr_entry_add(cpu, MSR_IA32_FRED_SSP0, 0);
+            kvm_msr_entry_add(cpu, MSR_IA32_FRED_SSP1, 0);
+            kvm_msr_entry_add(cpu, MSR_IA32_FRED_SSP2, 0);
+            kvm_msr_entry_add(cpu, MSR_IA32_FRED_SSP3, 0);
+            kvm_msr_entry_add(cpu, MSR_IA32_FRED_CONFIG, 0);
+        }
     }
 #endif
     kvm_msr_entry_add(cpu, MSR_KVM_SYSTEM_TIME, 0);
@@ -4118,6 +4142,36 @@ static int kvm_get_msrs(X86CPU *cpu)
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
+        case MSR_IA32_FRED_SSP0:
+            env->fred_ssp0 = msrs[i].data;
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
index a1041ef828..695e402246 100644
--- a/target/i386/machine.c
+++ b/target/i386/machine.c
@@ -1544,6 +1544,34 @@ static const VMStateDescription vmstate_msr_xfd = {
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
+        VMSTATE_UINT64(env.fred_ssp0, X86CPU),
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
@@ -1747,6 +1775,7 @@ const VMStateDescription vmstate_x86_cpu = {
         &vmstate_pdptrs,
         &vmstate_msr_xfd,
 #ifdef TARGET_X86_64
+        &vmstate_msr_fred,
         &vmstate_amx_xtile,
 #endif
         &vmstate_arch_lbr,
-- 
2.34.1

