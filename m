Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4203718EE5D
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 04:15:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbgCWDOo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 Mar 2020 23:14:44 -0400
Received: from mga11.intel.com ([192.55.52.93]:48945 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727096AbgCWDOn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 Mar 2020 23:14:43 -0400
IronPort-SDR: jgzhjl6VD3yr6tOboL7jh4l6o5BxGyRbcqCEOop1cXukEgGFgmgKyGsuphJpYzIbB3NXfP58fA
 BfIseASw9Chg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2020 20:14:42 -0700
IronPort-SDR: Gg+QmSZ8XLK3JGiAcInv8v2C/jGZtEXMFOu8gL1rc12E5hYuMeikfstiUIPjnpYrAk6dz6rqwo
 ULjSfFlndTVg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,294,1580803200"; 
   d="scan'208";a="292453684"
Received: from lxy-clx-4s.sh.intel.com ([10.239.43.161])
  by FMSMGA003.fm.intel.com with ESMTP; 22 Mar 2020 20:14:40 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>
Cc:     kvm@vger.kernel.org, qemu-devel@nongnu.org,
        Xiaoyao Li <xiaoyao.li@linux.intel.com>
Subject: [PATCH 2/3] target/i386: Add support for TEST_CTRL MSR
Date:   Mon, 23 Mar 2020 10:56:57 +0800
Message-Id: <20200323025658.4540-3-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200323025658.4540-1-xiaoyao.li@intel.com>
References: <20200323025658.4540-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Xiaoyao Li <xiaoyao.li@linux.intel.com>

MSR_TEST_CTRL is needed and accessed by feature split lock detection.

Signed-off-by: Xiaoyao Li <xiaoyao.li@linux.intel.com>
---
 target/i386/cpu.h     |  2 ++
 target/i386/kvm.c     | 13 +++++++++++++
 target/i386/machine.c | 20 ++++++++++++++++++++
 3 files changed, 35 insertions(+)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index f6c54412ba5e..177732ad19da 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -343,6 +343,7 @@ typedef enum X86Seg {
 #define MSR_IA32_APICBASE_ENABLE        (1<<11)
 #define MSR_IA32_APICBASE_EXTD          (1 << 10)
 #define MSR_IA32_APICBASE_BASE          (0xfffffU<<12)
+#define MSR_TEST_CTRL                   0x33
 #define MSR_IA32_FEATURE_CONTROL        0x0000003a
 #define MSR_TSC_ADJUST                  0x0000003b
 #define MSR_IA32_SPEC_CTRL              0x48
@@ -1466,6 +1467,7 @@ typedef struct CPUX86State {
 
     uint64_t spec_ctrl;
     uint64_t virt_ssbd;
+    uint64_t msr_test_ctrl;
 
     /* End of state preserved by INIT (dummy marker).  */
     struct {} end_init_save;
diff --git a/target/i386/kvm.c b/target/i386/kvm.c
index 6888cb7caeae..411402aa29fa 100644
--- a/target/i386/kvm.c
+++ b/target/i386/kvm.c
@@ -101,6 +101,7 @@ static bool has_msr_umwait;
 static bool has_msr_spec_ctrl;
 static bool has_msr_tsx_ctrl;
 static bool has_msr_virt_ssbd;
+static bool has_msr_test_ctrl;
 static bool has_msr_smi_count;
 static bool has_msr_arch_capabs;
 static bool has_msr_core_capabs;
@@ -2048,6 +2049,9 @@ static int kvm_get_supported_msrs(KVMState *s)
             case MSR_VIRT_SSBD:
                 has_msr_virt_ssbd = true;
                 break;
+            case MSR_TEST_CTRL:
+                has_msr_test_ctrl = true;
+                break;
             case MSR_IA32_ARCH_CAPABILITIES:
                 has_msr_arch_capabs = true;
                 break;
@@ -2766,6 +2770,9 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
     if (has_msr_virt_ssbd) {
         kvm_msr_entry_add(cpu, MSR_VIRT_SSBD, env->virt_ssbd);
     }
+    if (has_msr_test_ctrl) {
+        kvm_msr_entry_add(cpu, MSR_TEST_CTRL, env->msr_test_ctrl);
+    }
 
 #ifdef TARGET_X86_64
     if (lm_capable_kernel) {
@@ -3154,6 +3161,9 @@ static int kvm_get_msrs(X86CPU *cpu)
     if (has_msr_virt_ssbd) {
         kvm_msr_entry_add(cpu, MSR_VIRT_SSBD, 0);
     }
+    if (has_msr_test_ctrl) {
+        kvm_msr_entry_add(cpu, MSR_TEST_CTRL, 0);
+    }
     if (!env->tsc_valid) {
         kvm_msr_entry_add(cpu, MSR_IA32_TSC, 0);
         env->tsc_valid = !runstate_is_running();
@@ -3549,6 +3559,9 @@ static int kvm_get_msrs(X86CPU *cpu)
         case MSR_VIRT_SSBD:
             env->virt_ssbd = msrs[i].data;
             break;
+        case MSR_TEST_CTRL:
+            env->msr_test_ctrl = msrs[i].data;
+            break;
         case MSR_IA32_RTIT_CTL:
             env->msr_rtit_ctrl = msrs[i].data;
             break;
diff --git a/target/i386/machine.c b/target/i386/machine.c
index 0c96531a56f0..a23c6687d5ba 100644
--- a/target/i386/machine.c
+++ b/target/i386/machine.c
@@ -1252,6 +1252,25 @@ static const VMStateDescription vmstate_msr_virt_ssbd = {
     }
 };
 
+static bool msr_test_ctrl_needed(void *opaque)
+{
+    X86CPU *cpu = opaque;
+    CPUX86State *env = &cpu->env;
+
+    return env->msr_test_ctrl != 0;
+}
+
+static const VMStateDescription vmstate_msr_test_ctrl = {
+    .name = "cpu/msr_test_ctrl",
+    .version_id = 1,
+    .minimum_version_id = 1,
+    .needed = msr_test_ctrl_needed,
+    .fields = (VMStateField[]){
+        VMSTATE_UINT64(env.msr_test_ctrl, X86CPU),
+        VMSTATE_END_OF_LIST()
+    }
+};
+
 static bool svm_npt_needed(void *opaque)
 {
     X86CPU *cpu = opaque;
@@ -1439,6 +1458,7 @@ VMStateDescription vmstate_x86_cpu = {
         &vmstate_mcg_ext_ctl,
         &vmstate_msr_intel_pt,
         &vmstate_msr_virt_ssbd,
+        &vmstate_msr_test_ctrl,
         &vmstate_svm_npt,
 #ifndef TARGET_X86_64
         &vmstate_efer32,
-- 
2.20.1

