Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 102B717B461
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2020 03:21:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbgCFCVv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 21:21:51 -0500
Received: from mga09.intel.com ([134.134.136.24]:42728 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726490AbgCFCVv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Mar 2020 21:21:51 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Mar 2020 18:21:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,520,1574150400"; 
   d="scan'208";a="413742217"
Received: from snr.bj.intel.com ([10.240.193.90])
  by orsmga005.jf.intel.com with ESMTP; 05 Mar 2020 18:21:48 -0800
From:   Luwei Kang <luwei.kang@intel.com>
To:     pbonzini@redhat.com, rth@twiddle.net, ehabkost@redhat.com,
        mst@redhat.com, marcel.apfelbaum@gmail.com
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Luwei Kang <luwei.kang@intel.com>
Subject: [PATCH v1 3/3] i386: Add support for save/load IA32_PEBS_DATA_CFG MSR
Date:   Fri,  6 Mar 2020 18:20:05 +0800
Message-Id: <1583490005-27761-4-git-send-email-luwei.kang@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1583490005-27761-1-git-send-email-luwei.kang@intel.com>
References: <1583490005-27761-1-git-send-email-luwei.kang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add support for save/load PEBS baseline feature
IA32_PEBS_DATA_CFG MSR.

Signed-off-by: Luwei Kang <luwei.kang@intel.com>
---
 target/i386/cpu.h     |  2 ++
 target/i386/kvm.c     | 14 ++++++++++++++
 target/i386/machine.c | 24 ++++++++++++++++++++++++
 3 files changed, 40 insertions(+)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 872a495..a9a7b3f 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -413,6 +413,7 @@ typedef enum X86Seg {
 #define MSR_CORE_PERF_GLOBAL_OVF_CTRL   0x390
 
 #define MSR_IA32_PEBS_ENABLE            0x3f1
+#define MSR_IA32_PEBS_DATA_CFG          0x3f2
 #define MSR_IA32_DS_AREA                0x600
 
 #define MSR_MC0_CTL                     0x400
@@ -1449,6 +1450,7 @@ typedef struct CPUX86State {
 
     uint64_t msr_pebs_enable;
     uint64_t msr_ds_area;
+    uint64_t msr_pebs_data_cfg;
 
     uint64_t pat;
     uint32_t smbase;
diff --git a/target/i386/kvm.c b/target/i386/kvm.c
index 1043961..ab4e7bb 100644
--- a/target/i386/kvm.c
+++ b/target/i386/kvm.c
@@ -104,6 +104,7 @@ static bool has_msr_core_capabs;
 static bool has_msr_vmx_vmfunc;
 static bool has_msr_pebs_enable;
 static bool has_msr_ds_area;
+static bool has_msr_pebs_data_cfg;
 
 static uint32_t has_architectural_pmu_version;
 static uint32_t num_architectural_pmu_gp_counters;
@@ -2056,6 +2057,9 @@ static int kvm_get_supported_msrs(KVMState *s)
             case MSR_IA32_DS_AREA:
                 has_msr_ds_area = true;
                 break;
+            case MSR_IA32_PEBS_DATA_CFG:
+                has_msr_pebs_data_cfg = true;
+                break;
             }
         }
     }
@@ -2786,6 +2790,10 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
                 kvm_msr_entry_add(cpu, MSR_IA32_DS_AREA,
                                   env->msr_ds_area);
             }
+            if (has_msr_pebs_data_cfg) {
+                kvm_msr_entry_add(cpu, MSR_IA32_PEBS_DATA_CFG,
+                                  env->msr_pebs_data_cfg);
+            }
         }
 
         /*
@@ -3177,6 +3185,9 @@ static int kvm_get_msrs(X86CPU *cpu)
         if (has_msr_ds_area) {
             kvm_msr_entry_add(cpu, MSR_IA32_DS_AREA, 0);
         }
+        if (has_msr_pebs_data_cfg) {
+            kvm_msr_entry_add(cpu, MSR_IA32_PEBS_DATA_CFG, 0);
+        }
     }
 
     if (env->mcg_cap) {
@@ -3431,6 +3442,9 @@ static int kvm_get_msrs(X86CPU *cpu)
         case MSR_IA32_DS_AREA:
             env->msr_ds_area = msrs[i].data;
             break;
+        case MSR_IA32_PEBS_DATA_CFG:
+            env->msr_pebs_data_cfg = msrs[i].data;
+            break;
         case HV_X64_MSR_HYPERCALL:
             env->msr_hv_hypercall = msrs[i].data;
             break;
diff --git a/target/i386/machine.c b/target/i386/machine.c
index 82a2101..58b786d 100644
--- a/target/i386/machine.c
+++ b/target/i386/machine.c
@@ -670,6 +670,29 @@ static const VMStateDescription vmstate_msr_pebs_via_ds = {
     }
 };
 
+static bool pebs_baseline_needed(void *opaque)
+{
+    X86CPU *cpu = opaque;
+    CPUX86State *env = &cpu->env;
+
+    if (env->msr_pebs_data_cfg) {
+        return true;
+    }
+
+    return false;
+}
+
+static const VMStateDescription vmstate_msr_pebs_baseline = {
+    .name = "cpu/msr_pebs_baseline",
+    .version_id = 1,
+    .minimum_version_id = 1,
+    .needed = pebs_baseline_needed,
+    .fields = (VMStateField[]) {
+        VMSTATE_UINT64(env.msr_pebs_data_cfg, X86CPU),
+        VMSTATE_END_OF_LIST()
+    }
+};
+
 static bool mpx_needed(void *opaque)
 {
     X86CPU *cpu = opaque;
@@ -1424,6 +1447,7 @@ VMStateDescription vmstate_x86_cpu = {
         &vmstate_msr_ia32_feature_control,
         &vmstate_msr_architectural_pmu,
         &vmstate_msr_pebs_via_ds,
+        &vmstate_msr_pebs_baseline,
         &vmstate_mpx,
         &vmstate_msr_hypercall_hypercall,
         &vmstate_msr_hyperv_vapic,
-- 
1.8.3.1

