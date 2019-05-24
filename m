Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2845C292DB
	for <lists+kvm@lfdr.de>; Fri, 24 May 2019 10:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389668AbfEXIVH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 May 2019 04:21:07 -0400
Received: from mga07.intel.com ([134.134.136.100]:38552 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389665AbfEXIVG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 May 2019 04:21:06 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 May 2019 01:21:06 -0700
X-ExtLoop1: 1
Received: from tao-optiplex-7060.sh.intel.com ([10.239.13.104])
  by fmsmga007.fm.intel.com with ESMTP; 24 May 2019 01:21:04 -0700
From:   Tao Xu <tao3.xu@intel.com>
To:     pbonzini@redhat.com, rth@twiddle.net, ehabkost@redhat.com
Cc:     cohuck@redhat.com, mst@redhat.com, mtosatti@redhat.com,
        qemu-devel@nongnu.org, kvm@vger.kernel.org, tao3.xu@intel.com,
        jingqi.liu@intel.com
Subject: [PATCH v2 2/2] target/i386: Add support for save/load IA32_UMWAIT_CONTROL MSR
Date:   Fri, 24 May 2019 16:18:39 +0800
Message-Id: <20190524081839.6228-3-tao3.xu@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190524081839.6228-1-tao3.xu@intel.com>
References: <20190524081839.6228-1-tao3.xu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

UMWAIT and TPAUSE instructions use IA32_UMWAIT_CONTROL at MSR index
E1H to determines the maximum time in TSC-quanta that the processor
can reside in either C0.1 or C0.2.

This patch is to Add support for save/load IA32_UMWAIT_CONTROL MSR in
guest.

Co-developed-by: Jingqi Liu <jingqi.liu@intel.com>
Signed-off-by: Jingqi Liu <jingqi.liu@intel.com>
Signed-off-by: Tao Xu <tao3.xu@intel.com>
---
 target/i386/cpu.h     |  2 ++
 target/i386/kvm.c     | 15 +++++++++++++++
 target/i386/machine.c | 20 ++++++++++++++++++++
 3 files changed, 37 insertions(+)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 66fa61f02b..9d1c8edc1f 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -459,6 +459,7 @@ typedef enum X86Seg {
 
 #define MSR_IA32_BNDCFGS                0x00000d90
 #define MSR_IA32_XSS                    0x00000da0
+#define MSR_IA32_UMWAIT_CONTROL         0xe1
 
 #define XSTATE_FP_BIT                   0
 #define XSTATE_SSE_BIT                  1
@@ -1360,6 +1361,7 @@ typedef struct CPUX86State {
     uint16_t fpregs_format_vmstate;
 
     uint64_t xss;
+    uint64_t umwait;
 
     TPRAccess tpr_access_type;
 } CPUX86State;
diff --git a/target/i386/kvm.c b/target/i386/kvm.c
index b58fc7ab3a..7845f684fc 100644
--- a/target/i386/kvm.c
+++ b/target/i386/kvm.c
@@ -92,6 +92,7 @@ static bool has_msr_hv_stimer;
 static bool has_msr_hv_frequencies;
 static bool has_msr_hv_reenlightenment;
 static bool has_msr_xss;
+static bool has_msr_umwait;
 static bool has_msr_spec_ctrl;
 static bool has_msr_virt_ssbd;
 static bool has_msr_smi_count;
@@ -1487,6 +1488,9 @@ static int kvm_get_supported_msrs(KVMState *s)
                 case MSR_IA32_XSS:
                     has_msr_xss = true;
                     break;
+                case MSR_IA32_UMWAIT_CONTROL:
+                    has_msr_umwait = true;
+                    break;
                 case HV_X64_MSR_CRASH_CTL:
                     has_msr_hv_crash = true;
                     break;
@@ -1667,6 +1671,8 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
                              strerror(-ret));
             }
         }
+    } else {
+        has_msr_umwait = false;
     }
 
     return 0;
@@ -2033,6 +2039,9 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
     if (has_msr_xss) {
         kvm_msr_entry_add(cpu, MSR_IA32_XSS, env->xss);
     }
+    if (has_msr_umwait) {
+        kvm_msr_entry_add(cpu, MSR_IA32_UMWAIT_CONTROL, env->umwait);
+    }
     if (has_msr_spec_ctrl) {
         kvm_msr_entry_add(cpu, MSR_IA32_SPEC_CTRL, env->spec_ctrl);
     }
@@ -2426,6 +2435,9 @@ static int kvm_get_msrs(X86CPU *cpu)
     if (has_msr_xss) {
         kvm_msr_entry_add(cpu, MSR_IA32_XSS, 0);
     }
+    if (has_msr_umwait) {
+        kvm_msr_entry_add(cpu, MSR_IA32_UMWAIT_CONTROL, 0);
+    }
     if (has_msr_spec_ctrl) {
         kvm_msr_entry_add(cpu, MSR_IA32_SPEC_CTRL, 0);
     }
@@ -2675,6 +2687,9 @@ static int kvm_get_msrs(X86CPU *cpu)
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
index 225b5d433b..e51285a583 100644
--- a/target/i386/machine.c
+++ b/target/i386/machine.c
@@ -810,6 +810,25 @@ static const VMStateDescription vmstate_xss = {
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
+        VMSTATE_UINT64(env.umwait, X86CPU),
+        VMSTATE_END_OF_LIST()
+    }
+};
+
 #ifdef TARGET_X86_64
 static bool pkru_needed(void *opaque)
 {
@@ -1079,6 +1098,7 @@ VMStateDescription vmstate_x86_cpu = {
         &vmstate_msr_hyperv_reenlightenment,
         &vmstate_avx512,
         &vmstate_xss,
+        &vmstate_umwait,
         &vmstate_tsc_khz,
         &vmstate_msr_smi_count,
 #ifdef TARGET_X86_64
-- 
2.20.1

