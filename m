Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 720541F81AC
	for <lists+kvm@lfdr.de>; Sat, 13 Jun 2020 10:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726577AbgFMILq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 13 Jun 2020 04:11:46 -0400
Received: from mga07.intel.com ([134.134.136.100]:64611 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726589AbgFMILm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 13 Jun 2020 04:11:42 -0400
IronPort-SDR: i7rtusce3IP1GoV5ICSzqfdXkngpl8/m0JNB/DCVsmpVPR6ErtqQG9u+mfE/2pKCv8kV+vZh/K
 QPR4oPLYv6mw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2020 01:11:41 -0700
IronPort-SDR: 4vOTELTGn2dSvfowlnqEBt9ut7pIiGuwW5OmvT4fXwdkjrSbhzsz4ePuNTILeW23eJuOYGrqTD
 f+g//eJ5sKIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,506,1583222400"; 
   d="scan'208";a="474467482"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by fmsmga006.fm.intel.com with ESMTP; 13 Jun 2020 01:11:37 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, ak@linux.intel.com,
        wei.w.wang@intel.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Like Xu <like.xu@linux.intel.com>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org
Subject: [Qemu-devel] [PATCH 1/2] target/i386: define a new MSR based feature word - FEAT_PERF_CAPABILITIES
Date:   Sat, 13 Jun 2020 16:09:57 +0800
Message-Id: <20200613080958.132489-13-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20200613080958.132489-1-like.xu@linux.intel.com>
References: <20200613080958.132489-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The Perfmon and Debug Capability MSR named IA32_PERF_CAPABILITIES is
a feature-enumerating MSR, which only enumerates the feature full-width
write (via bit 13) by now which indicates the processor supports IA32_A_PMCx
interface for updating bits 32 and above of IA32_PMCx.

The existence of MSR IA32_PERF_CAPABILITIES is enumerated by CPUID.1:ECX[15].

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Eduardo Habkost <ehabkost@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org
Signed-off-by: Like Xu <like.xu@linux.intel.com>
Message-Id: <20200529074347.124619-5-like.xu@linux.intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 target/i386/cpu.c | 23 +++++++++++++++++++++++
 target/i386/cpu.h |  3 +++
 target/i386/kvm.c | 20 ++++++++++++++++++++
 3 files changed, 46 insertions(+)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 02065e35d4..e47c9d1604 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -1139,6 +1139,22 @@ static FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
             .index = MSR_IA32_CORE_CAPABILITY,
         },
     },
+    [FEAT_PERF_CAPABILITIES] = {
+        .type = MSR_FEATURE_WORD,
+        .feat_names = {
+            NULL, NULL, NULL, NULL,
+            NULL, NULL, NULL, NULL,
+            NULL, NULL, NULL, NULL,
+            NULL, "full-width-write", NULL, NULL,
+            NULL, NULL, NULL, NULL,
+            NULL, NULL, NULL, NULL,
+            NULL, NULL, NULL, NULL,
+            NULL, NULL, NULL, NULL,
+        },
+        .msr = {
+            .index = MSR_IA32_PERF_CAPABILITIES,
+        },
+    },
 
     [FEAT_VMX_PROCBASED_CTLS] = {
         .type = MSR_FEATURE_WORD,
@@ -1316,6 +1332,10 @@ static FeatureDep feature_dependencies[] = {
         .from = { FEAT_7_0_EDX,             CPUID_7_0_EDX_CORE_CAPABILITY },
         .to = { FEAT_CORE_CAPABILITY,       ~0ull },
     },
+    {
+        .from = { FEAT_1_ECX,             CPUID_EXT_PDCM },
+        .to = { FEAT_PERF_CAPABILITIES,       ~0ull },
+    },
     {
         .from = { FEAT_1_ECX,               CPUID_EXT_VMX },
         .to = { FEAT_VMX_PROCBASED_CTLS,    ~0ull },
@@ -5488,6 +5508,9 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
             *ebx |= (cs->nr_cores * cs->nr_threads) << 16;
             *edx |= CPUID_HT;
         }
+        if (!cpu->enable_pmu) {
+            *ecx &= ~CPUID_EXT_PDCM;
+        }
         break;
     case 2:
         /* cache info: needed for Pentium Pro compatibility */
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 408392dbf6..fad2f874bd 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -356,6 +356,8 @@ typedef enum X86Seg {
 #define MSR_IA32_ARCH_CAPABILITIES      0x10a
 #define ARCH_CAP_TSX_CTRL_MSR		(1<<7)
 
+#define MSR_IA32_PERF_CAPABILITIES      0x345
+
 #define MSR_IA32_TSX_CTRL		0x122
 #define MSR_IA32_TSCDEADLINE            0x6e0
 
@@ -529,6 +531,7 @@ typedef enum FeatureWord {
     FEAT_XSAVE_COMP_HI, /* CPUID[EAX=0xd,ECX=0].EDX */
     FEAT_ARCH_CAPABILITIES,
     FEAT_CORE_CAPABILITY,
+    FEAT_PERF_CAPABILITIES,
     FEAT_VMX_PROCBASED_CTLS,
     FEAT_VMX_SECONDARY_CTLS,
     FEAT_VMX_PINBASED_CTLS,
diff --git a/target/i386/kvm.c b/target/i386/kvm.c
index 34f838728d..9be6f76b2c 100644
--- a/target/i386/kvm.c
+++ b/target/i386/kvm.c
@@ -106,6 +106,7 @@ static bool has_msr_core_capabs;
 static bool has_msr_vmx_vmfunc;
 static bool has_msr_ucode_rev;
 static bool has_msr_vmx_procbased_ctls2;
+static bool has_msr_perf_capabs;
 
 static uint32_t has_architectural_pmu_version;
 static uint32_t num_architectural_pmu_gp_counters;
@@ -2027,6 +2028,9 @@ static int kvm_get_supported_msrs(KVMState *s)
             case MSR_IA32_CORE_CAPABILITY:
                 has_msr_core_capabs = true;
                 break;
+            case MSR_IA32_PERF_CAPABILITIES:
+                has_msr_perf_capabs = true;
+                break;
             case MSR_IA32_VMX_VMFUNC:
                 has_msr_vmx_vmfunc = true;
                 break;
@@ -2643,6 +2647,18 @@ static void kvm_msr_entry_add_vmx(X86CPU *cpu, FeatureWordArray f)
                       VMCS12_MAX_FIELD_INDEX << 1);
 }
 
+static void kvm_msr_entry_add_perf(X86CPU *cpu, FeatureWordArray f)
+{
+    uint64_t kvm_perf_cap =
+        kvm_arch_get_supported_msr_feature(kvm_state,
+                                           MSR_IA32_PERF_CAPABILITIES);
+
+    if (kvm_perf_cap) {
+        kvm_msr_entry_add(cpu, MSR_IA32_PERF_CAPABILITIES,
+                        kvm_perf_cap & f[FEAT_PERF_CAPABILITIES]);
+    }
+}
+
 static int kvm_buf_set_msrs(X86CPU *cpu)
 {
     int ret = kvm_vcpu_ioctl(CPU(cpu), KVM_SET_MSRS, cpu->kvm_msr_buf);
@@ -2675,6 +2691,10 @@ static void kvm_init_msrs(X86CPU *cpu)
                           env->features[FEAT_CORE_CAPABILITY]);
     }
 
+    if (has_msr_perf_capabs && cpu->enable_pmu) {
+        kvm_msr_entry_add_perf(cpu, env->features);
+    }
+
     if (has_msr_ucode_rev) {
         kvm_msr_entry_add(cpu, MSR_IA32_UCODE_REV, cpu->ucode_rev);
     }
-- 
2.21.3

