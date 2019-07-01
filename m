Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD2DC487D1
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2019 17:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728195AbfFQPty (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jun 2019 11:49:54 -0400
Received: from mga04.intel.com ([192.55.52.120]:27592 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725863AbfFQPtx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jun 2019 11:49:53 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jun 2019 08:49:53 -0700
X-ExtLoop1: 1
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.10])
  by FMSMGA003.fm.intel.com with ESMTP; 17 Jun 2019 08:49:51 -0700
From:   Xiaoyao Li <xiaoyao.li@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     Xiaoyao Li <xiaoyao.li@linux.intel.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, Paul Lai <paul.c.lai@intel.com>
Subject: [PATCH v2] target/i386: define a new MSR based feature word - FEAT_CORE_CAPABILITY
Date:   Mon, 17 Jun 2019 23:36:54 +0800
Message-Id: <20190617153654.916-1-xiaoyao.li@linux.intel.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

MSR IA32_CORE_CAPABILITY is a feature-enumerating MSR, which only
enumerates the feature split lock detection (via bit 5) by now.

The existence of MSR IA32_CORE_CAPABILITY is enumerated by CPUID.7_0:EDX[30].

The latest kernel patches about them can be found here:
https://lkml.org/lkml/2019/4/24/1909

Signed-off-by: Xiaoyao Li <xiaoyao.li@linux.intel.com>
---
Changelog:
v2
    Add definition of MSR_CORE_CAP_SPLIT_LOCK_DETECT for SNR cpu model
---
 target/i386/cpu.c | 22 +++++++++++++++++++++-
 target/i386/cpu.h |  5 +++++
 target/i386/kvm.c |  9 +++++++++
 3 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index fbed2eb804..fc47c650b8 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -1085,7 +1085,7 @@ static FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
             NULL, NULL, NULL, NULL,
             NULL, NULL, NULL, NULL,
             NULL, NULL, "spec-ctrl", "stibp",
-            NULL, "arch-capabilities", NULL, "ssbd",
+            NULL, "arch-capabilities", "core-capability", "ssbd",
         },
         .cpuid = {
             .eax = 7,
@@ -1203,6 +1203,26 @@ static FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
             }
         },
     },
+    [FEAT_CORE_CAPABILITY] = {
+        .type = MSR_FEATURE_WORD,
+        .feat_names = {
+            NULL, NULL, NULL, NULL,
+            NULL, "split-lock-detect", NULL, NULL,
+            NULL, NULL, NULL, NULL,
+            NULL, NULL, NULL, NULL,
+            NULL, NULL, NULL, NULL,
+            NULL, NULL, NULL, NULL,
+            NULL, NULL, NULL, NULL,
+            NULL, NULL, NULL, NULL,
+        },
+        .msr = {
+            .index = MSR_IA32_CORE_CAPABILITY,
+            .cpuid_dep = {
+                FEAT_7_0_EDX,
+                CPUID_7_0_EDX_CORE_CAPABILITY,
+            },
+        },
+    },
 };
 
 typedef struct X86RegisterInfo32 {
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 0732e059ec..192b0db076 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -345,6 +345,7 @@ typedef enum X86Seg {
 #define MSR_IA32_SPEC_CTRL              0x48
 #define MSR_VIRT_SSBD                   0xc001011f
 #define MSR_IA32_PRED_CMD               0x49
+#define MSR_IA32_CORE_CAPABILITY        0xcf
 #define MSR_IA32_ARCH_CAPABILITIES      0x10a
 #define MSR_IA32_TSCDEADLINE            0x6e0
 
@@ -496,6 +497,7 @@ typedef enum FeatureWord {
     FEAT_XSAVE_COMP_LO, /* CPUID[EAX=0xd,ECX=0].EAX */
     FEAT_XSAVE_COMP_HI, /* CPUID[EAX=0xd,ECX=0].EDX */
     FEAT_ARCH_CAPABILITIES,
+    FEAT_CORE_CAPABILITY,
     FEATURE_WORDS,
 } FeatureWord;
 
@@ -687,6 +689,7 @@ typedef uint32_t FeatureWordArray[FEATURE_WORDS];
 #define CPUID_7_0_EDX_AVX512_4FMAPS (1U << 3) /* AVX512 Multiply Accumulation Single Precision */
 #define CPUID_7_0_EDX_SPEC_CTRL     (1U << 26) /* Speculation Control */
 #define CPUID_7_0_EDX_ARCH_CAPABILITIES (1U << 29)  /*Arch Capabilities*/
+#define CPUID_7_0_EDX_CORE_CAPABILITY   (1U << 30)  /*Core Capability*/
 #define CPUID_7_0_EDX_SPEC_CTRL_SSBD  (1U << 31) /* Speculative Store Bypass Disable */
 
 #define CPUID_8000_0008_EBX_WBNOINVD  (1U << 9)  /* Write back and
@@ -734,6 +737,8 @@ typedef uint32_t FeatureWordArray[FEATURE_WORDS];
 #define MSR_ARCH_CAP_SKIP_L1DFL_VMENTRY (1U << 3)
 #define MSR_ARCH_CAP_SSB_NO     (1U << 4)
 
+#define MSR_CORE_CAP_SPLIT_LOCK_DETECT  (1U << 5)
+
 #ifndef HYPERV_SPINLOCK_NEVER_RETRY
 #define HYPERV_SPINLOCK_NEVER_RETRY             0xFFFFFFFF
 #endif
diff --git a/target/i386/kvm.c b/target/i386/kvm.c
index 6899061b4e..da99e91ea9 100644
--- a/target/i386/kvm.c
+++ b/target/i386/kvm.c
@@ -95,6 +95,7 @@ static bool has_msr_spec_ctrl;
 static bool has_msr_virt_ssbd;
 static bool has_msr_smi_count;
 static bool has_msr_arch_capabs;
+static bool has_msr_core_capabs;
 
 static uint32_t has_architectural_pmu_version;
 static uint32_t num_architectural_pmu_gp_counters;
@@ -1515,6 +1516,9 @@ static int kvm_get_supported_msrs(KVMState *s)
                 case MSR_IA32_ARCH_CAPABILITIES:
                     has_msr_arch_capabs = true;
                     break;
+                case MSR_IA32_CORE_CAPABILITY:
+                    has_msr_core_capabs = true;
+                    break;
                 }
             }
         }
@@ -2041,6 +2045,11 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
                           env->features[FEAT_ARCH_CAPABILITIES]);
     }
 
+    if (has_msr_core_capabs) {
+        kvm_msr_entry_add(cpu, MSR_IA32_CORE_CAPABILITY,
+                          env->features[FEAT_CORE_CAPABILITY]);
+    }
+
     /*
      * The following MSRs have side effects on the guest or are too heavy
      * for normal writeback. Limit them to reset or full state updates.
-- 
2.19.1

