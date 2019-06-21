Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 754CD4E0A9
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2019 08:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726058AbfFUGyM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jun 2019 02:54:12 -0400
Received: from mga12.intel.com ([192.55.52.136]:37411 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726008AbfFUGyL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jun 2019 02:54:11 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Jun 2019 23:54:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,399,1557212400"; 
   d="scan'208";a="335735526"
Received: from tao-optiplex-7060.sh.intel.com ([10.239.13.104])
  by orsmga005.jf.intel.com with ESMTP; 20 Jun 2019 23:54:09 -0700
From:   Tao Xu <tao3.xu@intel.com>
To:     pbonzini@redhat.com, rth@twiddle.net, ehabkost@redhat.com,
        cohuck@redhat.com, mst@redhat.com, mtosatti@redhat.com
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, tao3.xu@intel.com,
        jingqi.liu@intel.com, xiaoyao.li@linux.intel.com
Subject: [PATCH RESEND v3 1/2] x86/cpu: Add support for UMONITOR/UMWAIT/TPAUSE
Date:   Fri, 21 Jun 2019 14:51:33 +0800
Message-Id: <20190621065134.7392-2-tao3.xu@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190621065134.7392-1-tao3.xu@intel.com>
References: <20190621065134.7392-1-tao3.xu@intel.com>
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

changes in v3:
	Simplify the patches, expose user wait instructions when the guest
	has CPUID (Paolo)
	Resend to update the dependcy KVM link:
	https://lkml.org/lkml/2019/6/21/23
---
 target/i386/cpu.c | 3 ++-
 target/i386/cpu.h | 1 +
 target/i386/kvm.c | 4 ++++
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index fbed2eb804..0fb86c90db 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -1060,7 +1060,7 @@ static FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
         .type = CPUID_FEATURE_WORD,
         .feat_names = {
             NULL, "avx512vbmi", "umip", "pku",
-            NULL /* ospke */, NULL, "avx512vbmi2", NULL,
+            NULL /* ospke */, "waitpkg", "avx512vbmi2", NULL,
             "gfni", "vaes", "vpclmulqdq", "avx512vnni",
             "avx512bitalg", NULL, "avx512-vpopcntdq", NULL,
             "la57", NULL, NULL, NULL,
@@ -5222,6 +5222,7 @@ static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
             host_cpuid(5, 0, &cpu->mwait.eax, &cpu->mwait.ebx,
                        &cpu->mwait.ecx, &cpu->mwait.edx);
             env->features[FEAT_1_ECX] |= CPUID_EXT_MONITOR;
+            env->features[FEAT_7_0_ECX] |= CPUID_7_0_ECX_WAITPKG;
         }
     }
 
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 0732e059ec..2f7c57a3c2 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -670,6 +670,7 @@ typedef uint32_t FeatureWordArray[FEATURE_WORDS];
 #define CPUID_7_0_ECX_UMIP     (1U << 2)
 #define CPUID_7_0_ECX_PKU      (1U << 3)
 #define CPUID_7_0_ECX_OSPKE    (1U << 4)
+#define CPUID_7_0_ECX_WAITPKG  (1U << 5) /* UMONITOR/UMWAIT/TPAUSE Instructions */
 #define CPUID_7_0_ECX_VBMI2    (1U << 6) /* Additional VBMI Instrs */
 #define CPUID_7_0_ECX_GFNI     (1U << 8)
 #define CPUID_7_0_ECX_VAES     (1U << 9)
diff --git a/target/i386/kvm.c b/target/i386/kvm.c
index 6899061b4e..3efdb90f11 100644
--- a/target/i386/kvm.c
+++ b/target/i386/kvm.c
@@ -388,6 +388,10 @@ uint32_t kvm_arch_get_supported_cpuid(KVMState *s, uint32_t function,
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
-- 
2.20.1

