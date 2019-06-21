Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DED614E0AA
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2019 08:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbfFUGyO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jun 2019 02:54:14 -0400
Received: from mga12.intel.com ([192.55.52.136]:37411 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726138AbfFUGyO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jun 2019 02:54:14 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Jun 2019 23:54:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,399,1557212400"; 
   d="scan'208";a="335735536"
Received: from tao-optiplex-7060.sh.intel.com ([10.239.13.104])
  by orsmga005.jf.intel.com with ESMTP; 20 Jun 2019 23:54:11 -0700
From:   Tao Xu <tao3.xu@intel.com>
To:     pbonzini@redhat.com, rth@twiddle.net, ehabkost@redhat.com,
        cohuck@redhat.com, mst@redhat.com, mtosatti@redhat.com
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, tao3.xu@intel.com,
        jingqi.liu@intel.com, xiaoyao.li@linux.intel.com
Subject: [PATCH RESEND v3 2/2] target/i386: Add support for save/load IA32_UMWAIT_CONTROL MSR
Date:   Fri, 21 Jun 2019 14:51:34 +0800
Message-Id: <20190621065134.7392-3-tao3.xu@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190621065134.7392-1-tao3.xu@intel.com>
References: <20190621065134.7392-1-tao3.xu@intel.com>
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

Changes in v3:
        Resend to update the dependcy KVM link:
        https://lkml.org/lkml/2019/6/21/23
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

