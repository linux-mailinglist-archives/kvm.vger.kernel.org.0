Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C340D47589
	for <lists+kvm@lfdr.de>; Sun, 16 Jun 2019 17:38:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbfFPPiG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 16 Jun 2019 11:38:06 -0400
Received: from mga07.intel.com ([134.134.136.100]:48772 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726453AbfFPPiF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 16 Jun 2019 11:38:05 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Jun 2019 08:38:05 -0700
X-ExtLoop1: 1
Received: from tao-optiplex-7060.sh.intel.com ([10.239.13.104])
  by FMSMGA003.fm.intel.com with ESMTP; 16 Jun 2019 08:38:03 -0700
From:   Tao Xu <tao3.xu@intel.com>
To:     pbonzini@redhat.com, rth@twiddle.net, ehabkost@redhat.com
Cc:     cohuck@redhat.com, mst@redhat.com, mtosatti@redhat.com,
        qemu-devel@nongnu.org, kvm@vger.kernel.org, tao3.xu@intel.com,
        jingqi.liu@intel.com
Subject: [PATCH v3 2/2] target/i386: Add support for save/load IA32_UMWAIT_CONTROL MSR
Date:   Sun, 16 Jun 2019 23:35:25 +0800
Message-Id: <20190616153525.27072-3-tao3.xu@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190616153525.27072-1-tao3.xu@intel.com>
References: <20190616153525.27072-1-tao3.xu@intel.com>
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

no changes in v3:
---
 target/i386/cpu.h     |  2 ++
 target/i386/kvm.c     | 13 +++++++++++++
 target/i386/machine.c | 20 ++++++++++++++++++++
 3 files changed, 35 insertions(+)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 2f7c57a3c2..eb98b2e54a 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -450,6 +450,7 @@ typedef enum X86Seg {
 
 #define MSR_IA32_BNDCFGS                0x00000d90
 #define MSR_IA32_XSS                    0x00000da0
+#define MSR_IA32_UMWAIT_CONTROL         0xe1
 
 #define XSTATE_FP_BIT                   0
 #define XSTATE_SSE_BIT                  1
@@ -1348,6 +1349,7 @@ typedef struct CPUX86State {
     uint16_t fpregs_format_vmstate;
 
     uint64_t xss;
+    uint64_t umwait;
 
     TPRAccess tpr_access_type;
 } CPUX86State;
diff --git a/target/i386/kvm.c b/target/i386/kvm.c
index 3efdb90f11..506c7cd038 100644
--- a/target/i386/kvm.c
+++ b/target/i386/kvm.c
@@ -91,6 +91,7 @@ static bool has_msr_hv_stimer;
 static bool has_msr_hv_frequencies;
 static bool has_msr_hv_reenlightenment;
 static bool has_msr_xss;
+static bool has_msr_umwait;
 static bool has_msr_spec_ctrl;
 static bool has_msr_virt_ssbd;
 static bool has_msr_smi_count;
@@ -1486,6 +1487,9 @@ static int kvm_get_supported_msrs(KVMState *s)
                 case MSR_IA32_XSS:
                     has_msr_xss = true;
                     break;
+                case MSR_IA32_UMWAIT_CONTROL:
+                    has_msr_umwait = true;
+                    break;
                 case HV_X64_MSR_CRASH_CTL:
                     has_msr_hv_crash = true;
                     break;
@@ -2023,6 +2027,9 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
     if (has_msr_xss) {
         kvm_msr_entry_add(cpu, MSR_IA32_XSS, env->xss);
     }
+    if (has_msr_umwait) {
+        kvm_msr_entry_add(cpu, MSR_IA32_UMWAIT_CONTROL, env->umwait);
+    }
     if (has_msr_spec_ctrl) {
         kvm_msr_entry_add(cpu, MSR_IA32_SPEC_CTRL, env->spec_ctrl);
     }
@@ -2416,6 +2423,9 @@ static int kvm_get_msrs(X86CPU *cpu)
     if (has_msr_xss) {
         kvm_msr_entry_add(cpu, MSR_IA32_XSS, 0);
     }
+    if (has_msr_umwait) {
+        kvm_msr_entry_add(cpu, MSR_IA32_UMWAIT_CONTROL, 0);
+    }
     if (has_msr_spec_ctrl) {
         kvm_msr_entry_add(cpu, MSR_IA32_SPEC_CTRL, 0);
     }
@@ -2665,6 +2675,9 @@ static int kvm_get_msrs(X86CPU *cpu)
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
index 4aff1a763f..db388b6b85 100644
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
@@ -1100,6 +1119,7 @@ VMStateDescription vmstate_x86_cpu = {
         &vmstate_msr_hyperv_reenlightenment,
         &vmstate_avx512,
         &vmstate_xss,
+        &vmstate_umwait,
         &vmstate_tsc_khz,
         &vmstate_msr_smi_count,
 #ifdef TARGET_X86_64
-- 
2.20.1

