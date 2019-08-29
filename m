Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0946A10CB
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 07:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727318AbfH2F1A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 01:27:00 -0400
Received: from mga01.intel.com ([192.55.52.88]:2694 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725970AbfH2F07 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Aug 2019 01:26:59 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Aug 2019 22:26:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,442,1559545200"; 
   d="scan'208";a="171783713"
Received: from icl-2s.bj.intel.com ([10.240.193.48])
  by orsmga007.jf.intel.com with ESMTP; 28 Aug 2019 22:26:57 -0700
From:   Luwei Kang <luwei.kang@intel.com>
To:     pbonzini@redhat.com, rth@twiddle.net, ehabkost@redhat.com
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Luwei Kang <luwei.kang@intel.com>
Subject: [PATCH 1/2] target/i386: Add support for save PEBS registers
Date:   Thu, 29 Aug 2019 13:22:54 +0800
Message-Id: <1567056175-14275-1-git-send-email-luwei.kang@intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Intel processor introduce some hardware extensions that output PEBS record
to Intel PT buffer instead of DS area, so PEBS can be enabled in KVM guest
by PEBS output Intel PT. This patch adds a section for PEBS which use for
saves PEBS registers when the value is no-zero.

Signed-off-by: Luwei Kang <luwei.kang@intel.com>
---
 target/i386/cpu.h     |  8 ++++++++
 target/i386/machine.c | 41 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 5f6e3a0..d7cec36 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -409,6 +409,10 @@ typedef enum X86Seg {
 #define MSR_CORE_PERF_GLOBAL_CTRL       0x38f
 #define MSR_CORE_PERF_GLOBAL_OVF_CTRL   0x390
 
+#define MSR_IA32_PEBS_ENABLE            0x3f1
+#define MSR_RELOAD_FIXED_CTR0           0x1309
+#define MSR_RELOAD_PMC0                 0x14c1
+
 #define MSR_MC0_CTL                     0x400
 #define MSR_MC0_STATUS                  0x401
 #define MSR_MC0_ADDR                    0x402
@@ -1291,6 +1295,10 @@ typedef struct CPUX86State {
     uint64_t msr_rtit_cr3_match;
     uint64_t msr_rtit_addrs[MAX_RTIT_ADDRS];
 
+    uint64_t msr_pebs_enable;
+    uint64_t msr_reload_fixed_ctr[MAX_FIXED_COUNTERS];
+    uint64_t msr_reload_pmc[MAX_GP_COUNTERS];
+
     /* exception/interrupt handling */
     int error_code;
     int exception_is_int;
diff --git a/target/i386/machine.c b/target/i386/machine.c
index 2767b30..334d703 100644
--- a/target/i386/machine.c
+++ b/target/i386/machine.c
@@ -1274,6 +1274,46 @@ static const VMStateDescription vmstate_efer32 = {
 };
 #endif
 
+static bool pebs_enable_needed(void *opaque)
+{
+    X86CPU *cpu = opaque;
+    CPUX86State *env = &cpu->env;
+    int i;
+
+    if (env->msr_pebs_enable) {
+        return true;
+    }
+
+    for (i = 0; i < MAX_FIXED_COUNTERS; i++) {
+        if (env->msr_reload_fixed_ctr[i]) {
+            return true;
+        }
+    }
+
+    for (i = 0; i < MAX_GP_COUNTERS; i++) {
+        if (env->msr_reload_pmc[i]) {
+            return true;
+        }
+    }
+
+    return false;
+}
+
+static const VMStateDescription vmstate_msr_pebs = {
+    .name = "cpu/pebs",
+    .version_id = 1,
+    .minimum_version_id = 1,
+    .needed = pebs_enable_needed,
+    .fields = (VMStateField[]) {
+        VMSTATE_UINT64(env.msr_pebs_enable, X86CPU),
+        VMSTATE_UINT64_ARRAY(env.msr_reload_fixed_ctr, X86CPU,
+                                MAX_FIXED_COUNTERS),
+        VMSTATE_UINT64_ARRAY(env.msr_reload_pmc, X86CPU,
+                                MAX_GP_COUNTERS),
+        VMSTATE_END_OF_LIST()
+    }
+};
+
 VMStateDescription vmstate_x86_cpu = {
     .name = "cpu",
     .version_id = 12,
@@ -1407,6 +1447,7 @@ VMStateDescription vmstate_x86_cpu = {
 #ifdef CONFIG_KVM
         &vmstate_nested_state,
 #endif
+        &vmstate_msr_pebs,
         NULL
     }
 };
-- 
1.8.3.1

