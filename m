Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8FA1292DA
	for <lists+kvm@lfdr.de>; Fri, 24 May 2019 10:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389663AbfEXIVF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 May 2019 04:21:05 -0400
Received: from mga07.intel.com ([134.134.136.100]:38552 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389462AbfEXIVE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 May 2019 04:21:04 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 May 2019 01:21:04 -0700
X-ExtLoop1: 1
Received: from tao-optiplex-7060.sh.intel.com ([10.239.13.104])
  by fmsmga007.fm.intel.com with ESMTP; 24 May 2019 01:21:02 -0700
From:   Tao Xu <tao3.xu@intel.com>
To:     pbonzini@redhat.com, rth@twiddle.net, ehabkost@redhat.com
Cc:     cohuck@redhat.com, mst@redhat.com, mtosatti@redhat.com,
        qemu-devel@nongnu.org, kvm@vger.kernel.org, tao3.xu@intel.com,
        jingqi.liu@intel.com
Subject: [PATCH v2 1/2] x86/cpu: Add support for UMONITOR/UMWAIT/TPAUSE
Date:   Fri, 24 May 2019 16:18:38 +0800
Message-Id: <20190524081839.6228-2-tao3.xu@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190524081839.6228-1-tao3.xu@intel.com>
References: <20190524081839.6228-1-tao3.xu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

UMONITOR, UMWAIT and TPAUSE are a set of user wait instructions.
Availability of the user wait instructions is indicated by the presence
of the CPUID feature flag WAITPKG CPUID.0x07.0x0:ECX[5].

The patch enable the umonitor, umwait and tpause features in KVM.
Because umwait and tpause can put a (psysical) CPU into a power saving
state, by default we dont't expose it in kvm and provide a capability to
enable it. Use kvm capability to enable UMONITOR, UMWAIT and TPAUSE when
QEMU use "-overcommit cpu-pm=on, a VM can use UMONITOR, UMWAIT and TPAUSE
instructions. If the instruction causes a delay, the amount of time
delayed is called here the physical delay. The physical delay is first
computed by determining the virtual delay (the time to delay relative to
the VM’s timestamp counter). Otherwise, UMONITOR, UMWAIT and TPAUSE cause
an invalid-opcode exception(#UD).

The release document ref below link:
https://software.intel.com/sites/default/files/\
managed/39/c5/325462-sdm-vol-1-2abcd-3abcd.pdf

Co-developed-by: Jingqi Liu <jingqi.liu@intel.com>
Signed-off-by: Jingqi Liu <jingqi.liu@intel.com>
Signed-off-by: Tao Xu <tao3.xu@intel.com>
---
 linux-headers/linux/kvm.h |  1 +
 target/i386/cpu.c         |  3 ++-
 target/i386/cpu.h         |  1 +
 target/i386/kvm.c         | 13 +++++++++++++
 4 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
index c8423e760c..86cc2dbdd0 100644
--- a/linux-headers/linux/kvm.h
+++ b/linux-headers/linux/kvm.h
@@ -993,6 +993,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_ARM_SVE 170
 #define KVM_CAP_ARM_PTRAUTH_ADDRESS 171
 #define KVM_CAP_ARM_PTRAUTH_GENERIC 172
+#define KVM_CAP_ENABLE_USR_WAIT_PAUSE 173
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 2df56fa977..c2ad7866a5 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -1057,7 +1057,7 @@ static FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
         .type = CPUID_FEATURE_WORD,
         .feat_names = {
             NULL, "avx512vbmi", "umip", "pku",
-            NULL /* ospke */, NULL, "avx512vbmi2", NULL,
+            NULL /* ospke */, "waitpkg", "avx512vbmi2", NULL,
             "gfni", "vaes", "vpclmulqdq", "avx512vnni",
             "avx512bitalg", NULL, "avx512-vpopcntdq", NULL,
             "la57", NULL, NULL, NULL,
@@ -5196,6 +5196,7 @@ static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
             host_cpuid(5, 0, &cpu->mwait.eax, &cpu->mwait.ebx,
                        &cpu->mwait.ecx, &cpu->mwait.edx);
             env->features[FEAT_1_ECX] |= CPUID_EXT_MONITOR;
+            env->features[FEAT_7_0_ECX] |= CPUID_7_0_ECX_WAITPKG;
         }
     }
 
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index fce6660bac..66fa61f02b 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -679,6 +679,7 @@ typedef uint32_t FeatureWordArray[FEATURE_WORDS];
 #define CPUID_7_0_ECX_UMIP     (1U << 2)
 #define CPUID_7_0_ECX_PKU      (1U << 3)
 #define CPUID_7_0_ECX_OSPKE    (1U << 4)
+#define CPUID_7_0_ECX_WAITPKG  (1U << 5) /* UMONITOR/UMWAIT/TPAUSE Instructions */
 #define CPUID_7_0_ECX_VBMI2    (1U << 6) /* Additional VBMI Instrs */
 #define CPUID_7_0_ECX_GFNI     (1U << 8)
 #define CPUID_7_0_ECX_VAES     (1U << 9)
diff --git a/target/i386/kvm.c b/target/i386/kvm.c
index 3b29ce5c0d..b58fc7ab3a 100644
--- a/target/i386/kvm.c
+++ b/target/i386/kvm.c
@@ -389,6 +389,10 @@ uint32_t kvm_arch_get_supported_cpuid(KVMState *s, uint32_t function,
         if (host_tsx_blacklisted()) {
             ret &= ~(CPUID_7_0_EBX_RTM | CPUID_7_0_EBX_HLE);
         }
+    } else if (function == 7 && index == 0 && reg == R_ECX) {
+        if (enable_cpu_pm) {
+            ret |= CPUID_7_0_ECX_WAITPKG;
+        }
     } else if (function == 7 && index == 0 && reg == R_EDX) {
         /*
          * Linux v4.17-v4.20 incorrectly return ARCH_CAPABILITIES on SVM hosts.
@@ -1654,6 +1658,15 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
             error_report("kvm: guest stopping CPU not supported: %s",
                          strerror(-ret));
         }
+
+        if (kvm_check_extension(s, KVM_CAP_ENABLE_USR_WAIT_PAUSE)) {
+            ret = kvm_vm_enable_cap(s, KVM_CAP_ENABLE_USR_WAIT_PAUSE, 0);
+            if (ret < 0) {
+                error_report("kvm: guest can't enable user-level"
+                             " wait and pause: %s",
+                             strerror(-ret));
+            }
+        }
     }
 
     return 0;
-- 
2.20.1

