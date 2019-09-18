Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07B0FB5DF2
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2019 09:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728698AbfIRHXj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Sep 2019 03:23:39 -0400
Received: from mga07.intel.com ([134.134.136.100]:60890 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728682AbfIRHXi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Sep 2019 03:23:38 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Sep 2019 00:23:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,519,1559545200"; 
   d="scan'208";a="187694692"
Received: from tao-optiplex-7060.sh.intel.com ([10.239.159.36])
  by fmsmga007.fm.intel.com with ESMTP; 18 Sep 2019 00:23:35 -0700
From:   Tao Xu <tao3.xu@intel.com>
To:     pbonzini@redhat.com, rth@twiddle.net, ehabkost@redhat.com,
        mtosatti@redhat.com
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, tao3.xu@intel.com,
        jingqi.liu@intel.com
Subject: [PATCH RESEND v4 2/2] target/i386: Add support for save/load IA32_UMWAIT_CONTROL MSR
Date:   Wed, 18 Sep 2019 15:23:29 +0800
Message-Id: <20190918072329.1911-3-tao3.xu@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190918072329.1911-1-tao3.xu@intel.com>
References: <20190918072329.1911-1-tao3.xu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

UMWAIT and TPAUSE instructions use 32bits IA32_UMWAIT_CONTROL at MSR
index E1H to determines the maximum time in TSC-quanta that the processor
can reside in either C0.1 or C0.2.

This patch is to Add support for save/load IA32_UMWAIT_CONTROL MSR in
guest.

Co-developed-by: Jingqi Liu <jingqi.liu@intel.com>
Signed-off-by: Jingqi Liu <jingqi.liu@intel.com>
Signed-off-by: Tao Xu <tao3.xu@intel.com>
---

Changes in v4:
        Set IA32_UMWAIT_CONTROL 32bits
---
 target/i386/cpu.h     |  2 ++
 target/i386/kvm.c     | 13 +++++++++++++
 target/i386/machine.c | 20 ++++++++++++++++++++
 3 files changed, 35 insertions(+)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 33a0b8b365..bcd1cbbfc0 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -451,6 +451,7 @@ typedef enum X86Seg {
 
 #define MSR_IA32_BNDCFGS                0x00000d90
 #define MSR_IA32_XSS                    0x00000da0
+#define MSR_IA32_UMWAIT_CONTROL         0xe1
 
 #define XSTATE_FP_BIT                   0
 #define XSTATE_SSE_BIT                  1
@@ -1393,6 +1394,7 @@ typedef struct CPUX86State {
     uint16_t fpregs_format_vmstate;
 
     uint64_t xss;
+    uint32_t umwait;
 
     TPRAccess tpr_access_type;
 
diff --git a/target/i386/kvm.c b/target/i386/kvm.c
index dc618e4062..e548379096 100644
--- a/target/i386/kvm.c
+++ b/target/i386/kvm.c
@@ -95,6 +95,7 @@ static bool has_msr_hv_stimer;
 static bool has_msr_hv_frequencies;
 static bool has_msr_hv_reenlightenment;
 static bool has_msr_xss;
+static bool has_msr_umwait;
 static bool has_msr_spec_ctrl;
 static bool has_msr_virt_ssbd;
 static bool has_msr_smi_count;
@@ -1907,6 +1908,9 @@ static int kvm_get_supported_msrs(KVMState *s)
             case MSR_IA32_XSS:
                 has_msr_xss = true;
                 break;
+            case MSR_IA32_UMWAIT_CONTROL:
+                has_msr_umwait = true;
+                break;
             case HV_X64_MSR_CRASH_CTL:
                 has_msr_hv_crash = true;
                 break;
@@ -2457,6 +2461,9 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
     if (has_msr_xss) {
         kvm_msr_entry_add(cpu, MSR_IA32_XSS, env->xss);
     }
+    if (has_msr_umwait) {
+        kvm_msr_entry_add(cpu, MSR_IA32_UMWAIT_CONTROL, env->umwait);
+    }
     if (has_msr_spec_ctrl) {
         kvm_msr_entry_add(cpu, MSR_IA32_SPEC_CTRL, env->spec_ctrl);
     }
@@ -2861,6 +2868,9 @@ static int kvm_get_msrs(X86CPU *cpu)
     if (has_msr_xss) {
         kvm_msr_entry_add(cpu, MSR_IA32_XSS, 0);
     }
+    if (has_msr_umwait) {
+        kvm_msr_entry_add(cpu, MSR_IA32_UMWAIT_CONTROL, 0);
+    }
     if (has_msr_spec_ctrl) {
         kvm_msr_entry_add(cpu, MSR_IA32_SPEC_CTRL, 0);
     }
@@ -3113,6 +3123,9 @@ static int kvm_get_msrs(X86CPU *cpu)
         case MSR_IA32_XSS:
             env->xss = msrs[i].data;
             break;
+        case MSR_IA32_UMWAIT_CONTROL:
+            env->umwait = msrs[i].data;
+            break;
         default:
             if (msrs[i].index >= MSR_MC0_CTL &&
                 msrs[i].index < MSR_MC0_CTL + (env->mcg_cap & 0xff) * 4) {
diff --git a/target/i386/machine.c b/target/i386/machine.c
index 2767b3096d..6481f846f6 100644
--- a/target/i386/machine.c
+++ b/target/i386/machine.c
@@ -943,6 +943,25 @@ static const VMStateDescription vmstate_xss = {
     }
 };
 
+static bool umwait_needed(void *opaque)
+{
+    X86CPU *cpu = opaque;
+    CPUX86State *env = &cpu->env;
+
+    return env->umwait != 0;
+}
+
+static const VMStateDescription vmstate_umwait = {
+    .name = "cpu/umwait",
+    .version_id = 1,
+    .minimum_version_id = 1,
+    .needed = umwait_needed,
+    .fields = (VMStateField[]) {
+        VMSTATE_UINT32(env.umwait, X86CPU),
+        VMSTATE_END_OF_LIST()
+    }
+};
+
 #ifdef TARGET_X86_64
 static bool pkru_needed(void *opaque)
 {
@@ -1391,6 +1410,7 @@ VMStateDescription vmstate_x86_cpu = {
         &vmstate_msr_hyperv_reenlightenment,
         &vmstate_avx512,
         &vmstate_xss,
+        &vmstate_umwait,
         &vmstate_tsc_khz,
         &vmstate_msr_smi_count,
 #ifdef TARGET_X86_64
-- 
2.20.1

