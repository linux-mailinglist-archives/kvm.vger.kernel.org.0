Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C285622E0CC
	for <lists+kvm@lfdr.de>; Sun, 26 Jul 2020 17:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbgGZPes (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Jul 2020 11:34:48 -0400
Received: from mga03.intel.com ([134.134.136.65]:17603 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726065AbgGZPer (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Jul 2020 11:34:47 -0400
IronPort-SDR: DWLr7vKMGPiADKniRIlTx4ae3ArcjaeC4Av5QrBzjVFT3sRssmPWYGx7bQwaiBKvUXPJgZliJB
 MtVnV7G1FkXg==
X-IronPort-AV: E=McAfee;i="6000,8403,9694"; a="150890963"
X-IronPort-AV: E=Sophos;i="5.75,399,1589266800"; 
   d="scan'208";a="150890963"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2020 08:34:46 -0700
IronPort-SDR: vxspwqeHLJVp8zYHCu9lL8ndMhtakzWTni51jaPdnDq9vBZ7qBOMTekiYhPw7To0chsq4p4TbB
 W9SnT/+3N38g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,399,1589266800"; 
   d="scan'208";a="303177524"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by orsmga002.jf.intel.com with ESMTP; 26 Jul 2020 08:34:43 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        Like Xu <like.xu@linux.intel.com>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org
Subject: [PATCH] target/i386: add -cpu,lbr=true support to enable guest LBR
Date:   Sun, 26 Jul 2020 23:32:20 +0800
Message-Id: <20200726153229.27149-3-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20200726153229.27149-1-like.xu@linux.intel.com>
References: <20200726153229.27149-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The LBR feature would be enabled on the guest if:
- the KVM is enabled and the PMU is enabled and,
- the msr-based-feature IA32_PERF_CAPABILITIES is supporterd and,
- the supported returned value for lbr_fmt from this msr is not zero.

The LBR feature would be disabled on the guest if:
- the msr-based-feature IA32_PERF_CAPABILITIES is unsupporterd OR,
- qemu set the IA32_PERF_CAPABILITIES msr feature without lbr_fmt values OR,
- the requested guest vcpu model doesn't support PDCM.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Eduardo Habkost <ehabkost@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org
Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 hw/i386/pc.c      |  1 +
 target/i386/cpu.c | 24 ++++++++++++++++++++++--
 target/i386/cpu.h |  2 ++
 target/i386/kvm.c |  7 ++++++-
 4 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index 3d419d5991..857aff75bb 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -318,6 +318,7 @@ GlobalProperty pc_compat_1_5[] = {
     { "Nehalem-" TYPE_X86_CPU, "min-level", "2" },
     { "virtio-net-pci", "any_layout", "off" },
     { TYPE_X86_CPU, "pmu", "on" },
+    { TYPE_X86_CPU, "lbr", "on" },
     { "i440FX-pcihost", "short_root_bus", "0" },
     { "q35-pcihost", "short_root_bus", "0" },
 };
diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 588f32e136..c803994887 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -1142,8 +1142,8 @@ static FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
     [FEAT_PERF_CAPABILITIES] = {
         .type = MSR_FEATURE_WORD,
         .feat_names = {
-            NULL, NULL, NULL, NULL,
-            NULL, NULL, NULL, NULL,
+            "lbr-fmt-bit-0", "lbr-fmt-bit-1", "lbr-fmt-bit-2", "lbr-fmt-bit-3",
+            "lbr-fmt-bit-4", "lbr-fmt-bit-5", NULL, NULL,
             NULL, NULL, NULL, NULL,
             NULL, "full-width-write", NULL, NULL,
             NULL, NULL, NULL, NULL,
@@ -4224,6 +4224,12 @@ static bool lmce_supported(void)
     return !!(mce_cap & MCG_LMCE_P);
 }
 
+static inline bool lbr_supported(void)
+{
+    return kvm_enabled() && (kvm_arch_get_supported_msr_feature(kvm_state,
+        MSR_IA32_PERF_CAPABILITIES) & PERF_CAP_LBR_FMT);
+}
+
 #define CPUID_MODEL_ID_SZ 48
 
 /**
@@ -4327,6 +4333,9 @@ static void max_x86_cpu_initfn(Object *obj)
     }
 
     object_property_set_bool(OBJECT(cpu), "pmu", true, &error_abort);
+    if (lbr_supported()) {
+        object_property_set_bool(OBJECT(cpu), "lbr", true, &error_abort);
+    }
 }
 
 static const TypeInfo max_x86_cpu_type_info = {
@@ -5535,6 +5544,10 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
         }
         if (!cpu->enable_pmu) {
             *ecx &= ~CPUID_EXT_PDCM;
+            if (cpu->enable_lbr) {
+                warn_report("LBR is unsupported since guest PMU is disabled.");
+                exit(1);
+            }
         }
         break;
     case 2:
@@ -6553,6 +6566,12 @@ static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
         }
     }
 
+    if (!cpu->max_features && cpu->enable_lbr &&
+        !(env->features[FEAT_1_ECX] & CPUID_EXT_PDCM)) {
+        warn_report("requested vcpu model doesn't support PDCM for LBR.");
+        exit(1);
+    }
+
     if (cpu->ucode_rev == 0) {
         /* The default is the same as KVM's.  */
         if (IS_AMD_CPU(env)) {
@@ -7187,6 +7206,7 @@ static Property x86_cpu_properties[] = {
 #endif
     DEFINE_PROP_INT32("node-id", X86CPU, node_id, CPU_UNSET_NUMA_NODE_ID),
     DEFINE_PROP_BOOL("pmu", X86CPU, enable_pmu, false),
+    DEFINE_PROP_BOOL("lbr", X86CPU, enable_lbr, false),
 
     DEFINE_PROP_UINT32("hv-spinlocks", X86CPU, hyperv_spinlock_attempts,
                        HYPERV_SPINLOCK_NEVER_RETRY),
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index e1a5c174dc..a059913e26 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -357,6 +357,7 @@ typedef enum X86Seg {
 #define ARCH_CAP_TSX_CTRL_MSR		(1<<7)
 
 #define MSR_IA32_PERF_CAPABILITIES      0x345
+#define PERF_CAP_LBR_FMT      0x3f
 
 #define MSR_IA32_TSX_CTRL		0x122
 #define MSR_IA32_TSCDEADLINE            0x6e0
@@ -1702,6 +1703,7 @@ struct X86CPU {
      * capabilities) directly to the guest.
      */
     bool enable_pmu;
+    bool enable_lbr;
 
     /* LMCE support can be enabled/disabled via cpu option 'lmce=on/off'. It is
      * disabled by default to avoid breaking migration between QEMU with
diff --git a/target/i386/kvm.c b/target/i386/kvm.c
index b8455c89ed..feb33d5472 100644
--- a/target/i386/kvm.c
+++ b/target/i386/kvm.c
@@ -2690,8 +2690,10 @@ static void kvm_msr_entry_add_perf(X86CPU *cpu, FeatureWordArray f)
     uint64_t kvm_perf_cap =
         kvm_arch_get_supported_msr_feature(kvm_state,
                                            MSR_IA32_PERF_CAPABILITIES);
-
     if (kvm_perf_cap) {
+        if (!cpu->enable_lbr) {
+            kvm_perf_cap &= ~PERF_CAP_LBR_FMT;
+        }
         kvm_msr_entry_add(cpu, MSR_IA32_PERF_CAPABILITIES,
                         kvm_perf_cap & f[FEAT_PERF_CAPABILITIES]);
     }
@@ -2731,6 +2733,9 @@ static void kvm_init_msrs(X86CPU *cpu)
 
     if (has_msr_perf_capabs && cpu->enable_pmu) {
         kvm_msr_entry_add_perf(cpu, env->features);
+    } else if (!has_msr_perf_capabs && cpu->enable_lbr) {
+        warn_report("KVM doesn't support MSR_IA32_PERF_CAPABILITIES for LBR.");
+        exit(1);
     }
 
     if (has_msr_ucode_rev) {
-- 
2.21.3

