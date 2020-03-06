Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 393D717B460
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2020 03:21:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbgCFCVp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 21:21:45 -0500
Received: from mga18.intel.com ([134.134.136.126]:19716 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726769AbgCFCVp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Mar 2020 21:21:45 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Mar 2020 18:21:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,520,1574150400"; 
   d="scan'208";a="413742198"
Received: from snr.bj.intel.com ([10.240.193.90])
  by orsmga005.jf.intel.com with ESMTP; 05 Mar 2020 18:21:42 -0800
From:   Luwei Kang <luwei.kang@intel.com>
To:     pbonzini@redhat.com, rth@twiddle.net, ehabkost@redhat.com,
        mst@redhat.com, marcel.apfelbaum@gmail.com
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Luwei Kang <luwei.kang@intel.com>
Subject: [PATCH v1 2/3] i386: Add support for save/load PEBS MSRs
Date:   Fri,  6 Mar 2020 18:20:04 +0800
Message-Id: <1583490005-27761-3-git-send-email-luwei.kang@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1583490005-27761-1-git-send-email-luwei.kang@intel.com>
References: <1583490005-27761-1-git-send-email-luwei.kang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PEBS feature virtualization required IA32_PEBS_ENABLE and
DS_AREA MSRs. This patch is to add the support of these MSRs
saved/loaded in guest.

Signed-off-by: Luwei Kang <luwei.kang@intel.com>
---
 target/i386/cpu.h     |  6 ++++++
 target/i386/kvm.c     | 29 +++++++++++++++++++++++++++++
 target/i386/machine.c | 25 +++++++++++++++++++++++++
 3 files changed, 60 insertions(+)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 398810f..872a495 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -412,6 +412,9 @@ typedef enum X86Seg {
 #define MSR_CORE_PERF_GLOBAL_CTRL       0x38f
 #define MSR_CORE_PERF_GLOBAL_OVF_CTRL   0x390
 
+#define MSR_IA32_PEBS_ENABLE            0x3f1
+#define MSR_IA32_DS_AREA                0x600
+
 #define MSR_MC0_CTL                     0x400
 #define MSR_MC0_STATUS                  0x401
 #define MSR_MC0_ADDR                    0x402
@@ -1444,6 +1447,9 @@ typedef struct CPUX86State {
     uint64_t msr_gp_counters[MAX_GP_COUNTERS];
     uint64_t msr_gp_evtsel[MAX_GP_COUNTERS];
 
+    uint64_t msr_pebs_enable;
+    uint64_t msr_ds_area;
+
     uint64_t pat;
     uint32_t smbase;
     uint64_t msr_smi_count;
diff --git a/target/i386/kvm.c b/target/i386/kvm.c
index bfd09bd..1043961 100644
--- a/target/i386/kvm.c
+++ b/target/i386/kvm.c
@@ -102,6 +102,8 @@ static bool has_msr_smi_count;
 static bool has_msr_arch_capabs;
 static bool has_msr_core_capabs;
 static bool has_msr_vmx_vmfunc;
+static bool has_msr_pebs_enable;
+static bool has_msr_ds_area;
 
 static uint32_t has_architectural_pmu_version;
 static uint32_t num_architectural_pmu_gp_counters;
@@ -2048,6 +2050,12 @@ static int kvm_get_supported_msrs(KVMState *s)
             case MSR_IA32_VMX_VMFUNC:
                 has_msr_vmx_vmfunc = true;
                 break;
+            case MSR_IA32_PEBS_ENABLE:
+                has_msr_pebs_enable = true;
+                break;
+            case MSR_IA32_DS_AREA:
+                has_msr_ds_area = true;
+                break;
             }
         }
     }
@@ -2770,7 +2778,16 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
                 kvm_msr_entry_add(cpu, MSR_CORE_PERF_GLOBAL_CTRL,
                                   env->msr_global_ctrl);
             }
+            if (has_msr_pebs_enable) {
+                kvm_msr_entry_add(cpu, MSR_IA32_PEBS_ENABLE,
+                                  env->msr_pebs_enable);
+            }
+            if (has_msr_ds_area) {
+                kvm_msr_entry_add(cpu, MSR_IA32_DS_AREA,
+                                  env->msr_ds_area);
+            }
         }
+
         /*
          * Hyper-V partition-wide MSRs: to avoid clearing them on cpu hot-add,
          * only sync them to KVM on the first cpu
@@ -3154,6 +3171,12 @@ static int kvm_get_msrs(X86CPU *cpu)
             kvm_msr_entry_add(cpu, MSR_P6_PERFCTR0 + i, 0);
             kvm_msr_entry_add(cpu, MSR_P6_EVNTSEL0 + i, 0);
         }
+        if (has_msr_pebs_enable) {
+            kvm_msr_entry_add(cpu, MSR_IA32_PEBS_ENABLE, 0);
+        }
+        if (has_msr_ds_area) {
+            kvm_msr_entry_add(cpu, MSR_IA32_DS_AREA, 0);
+        }
     }
 
     if (env->mcg_cap) {
@@ -3402,6 +3425,12 @@ static int kvm_get_msrs(X86CPU *cpu)
         case MSR_P6_EVNTSEL0 ... MSR_P6_EVNTSEL0 + MAX_GP_COUNTERS - 1:
             env->msr_gp_evtsel[index - MSR_P6_EVNTSEL0] = msrs[i].data;
             break;
+        case MSR_IA32_PEBS_ENABLE:
+            env->msr_pebs_enable = msrs[i].data;
+            break;
+        case MSR_IA32_DS_AREA:
+            env->msr_ds_area = msrs[i].data;
+            break;
         case HV_X64_MSR_HYPERCALL:
             env->msr_hv_hypercall = msrs[i].data;
             break;
diff --git a/target/i386/machine.c b/target/i386/machine.c
index 6481f84..82a2101 100644
--- a/target/i386/machine.c
+++ b/target/i386/machine.c
@@ -646,6 +646,30 @@ static const VMStateDescription vmstate_msr_architectural_pmu = {
     }
 };
 
+static bool pebs_via_ds_needed(void *opaque)
+{
+    X86CPU *cpu = opaque;
+    CPUX86State *env = &cpu->env;
+
+    if (env->msr_pebs_enable || env->msr_ds_area) {
+        return true;
+    }
+
+    return false;
+}
+
+static const VMStateDescription vmstate_msr_pebs_via_ds = {
+    .name = "cpu/msr_pebs_via_ds",
+    .version_id = 1,
+    .minimum_version_id = 1,
+    .needed = pebs_via_ds_needed,
+    .fields = (VMStateField[]) {
+        VMSTATE_UINT64(env.msr_pebs_enable, X86CPU),
+        VMSTATE_UINT64(env.msr_ds_area, X86CPU),
+        VMSTATE_END_OF_LIST()
+    }
+};
+
 static bool mpx_needed(void *opaque)
 {
     X86CPU *cpu = opaque;
@@ -1399,6 +1423,7 @@ VMStateDescription vmstate_x86_cpu = {
         &vmstate_msr_ia32_misc_enable,
         &vmstate_msr_ia32_feature_control,
         &vmstate_msr_architectural_pmu,
+        &vmstate_msr_pebs_via_ds,
         &vmstate_mpx,
         &vmstate_msr_hypercall_hypercall,
         &vmstate_msr_hyperv_vapic,
-- 
1.8.3.1

