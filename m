Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E6B4C12BF
	for <lists+kvm@lfdr.de>; Sun, 29 Sep 2019 04:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728831AbfI2B5X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 28 Sep 2019 21:57:23 -0400
Received: from mga03.intel.com ([134.134.136.65]:14348 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728569AbfI2B5X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 28 Sep 2019 21:57:23 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Sep 2019 18:57:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,561,1559545200"; 
   d="scan'208";a="204501452"
Received: from tao-optiplex-7060.sh.intel.com ([10.239.159.36])
  by fmsmga001.fm.intel.com with ESMTP; 28 Sep 2019 18:57:21 -0700
From:   Tao Xu <tao3.xu@intel.com>
To:     pbonzini@redhat.com, rth@twiddle.net, ehabkost@redhat.com,
        mtosatti@redhat.com
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, tao3.xu@intel.com,
        jingqi.liu@intel.com
Subject: [PATCH v5 1/2] x86/cpu: Add support for UMONITOR/UMWAIT/TPAUSE
Date:   Sun, 29 Sep 2019 09:57:17 +0800
Message-Id: <20190929015718.19562-2-tao3.xu@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190929015718.19562-1-tao3.xu@intel.com>
References: <20190929015718.19562-1-tao3.xu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

UMONITOR, UMWAIT and TPAUSE are a set of user wait instructions.
This patch adds support for user wait instructions in KVM. Availability
of the user wait instructions is indicated by the presence of the CPUID
feature flag WAITPKG CPUID.0x07.0x0:ECX[5]. User wait instructions may
be executed at any privilege level, and use IA32_UMWAIT_CONTROL MSR to
set the maximum time.

The patch enable the umonitor, umwait and tpause features in KVM.
Because umwait and tpause can put a (psysical) CPU into a power saving
state, by default we dont't expose it to kvm and enable it only when
guest CPUID has it. And use QEMU command-line "-overcommit cpu-pm=on"
(enable_cpu_pm is enabled), a VM can use UMONITOR, UMWAIT and TPAUSE
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

Changes in v5:
    - Remove CPUID_7_0_ECX_WAITPKG if enable_cpu_pm is not set.
    (Paolo)
---
 target/i386/cpu.c | 3 ++-
 target/i386/cpu.h | 1 +
 target/i386/kvm.c | 6 ++++++
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 9e0bac31e8..15f888b13f 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -1062,7 +1062,7 @@ static FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
         .type = CPUID_FEATURE_WORD,
         .feat_names = {
             NULL, "avx512vbmi", "umip", "pku",
-            NULL /* ospke */, NULL, "avx512vbmi2", NULL,
+            NULL /* ospke */, "waitpkg", "avx512vbmi2", NULL,
             "gfni", "vaes", "vpclmulqdq", "avx512vnni",
             "avx512bitalg", NULL, "avx512-vpopcntdq", NULL,
             "la57", NULL, NULL, NULL,
@@ -5227,6 +5227,7 @@ static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
             host_cpuid(5, 0, &cpu->mwait.eax, &cpu->mwait.ebx,
                        &cpu->mwait.ecx, &cpu->mwait.edx);
             env->features[FEAT_1_ECX] |= CPUID_EXT_MONITOR;
+            env->features[FEAT_7_0_ECX] |= CPUID_7_0_ECX_WAITPKG;
         }
     }
 
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 5f6e3a029a..33a0b8b365 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -673,6 +673,7 @@ typedef uint32_t FeatureWordArray[FEATURE_WORDS];
 #define CPUID_7_0_ECX_UMIP     (1U << 2)
 #define CPUID_7_0_ECX_PKU      (1U << 3)
 #define CPUID_7_0_ECX_OSPKE    (1U << 4)
+#define CPUID_7_0_ECX_WAITPKG  (1U << 5) /* UMONITOR/UMWAIT/TPAUSE Instructions */
 #define CPUID_7_0_ECX_VBMI2    (1U << 6) /* Additional VBMI Instrs */
 #define CPUID_7_0_ECX_GFNI     (1U << 8)
 #define CPUID_7_0_ECX_VAES     (1U << 9)
diff --git a/target/i386/kvm.c b/target/i386/kvm.c
index 92069099ab..ea9a87bfd8 100644
--- a/target/i386/kvm.c
+++ b/target/i386/kvm.c
@@ -400,6 +400,12 @@ uint32_t kvm_arch_get_supported_cpuid(KVMState *s, uint32_t function,
         if (host_tsx_blacklisted()) {
             ret &= ~(CPUID_7_0_EBX_RTM | CPUID_7_0_EBX_HLE);
         }
+    } else if (function == 7 && index == 0 && reg == R_ECX) {
+        if (enable_cpu_pm) {
+            ret |= CPUID_7_0_ECX_WAITPKG;
+        } else {
+            ret &= ~CPUID_7_0_ECX_WAITPKG;
+        }
     } else if (function == 7 && index == 0 && reg == R_EDX) {
         /*
          * Linux v4.17-v4.20 incorrectly return ARCH_CAPABILITIES on SVM hosts.
-- 
2.20.1

