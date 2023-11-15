Return-Path: <kvm+bounces-1747-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AF907EBD96
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 08:18:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B03FBB20D6A
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 07:18:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68825BE49;
	Wed, 15 Nov 2023 07:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IC1gIajp"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25FE6BA39
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 07:17:49 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1DCBE9
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 23:17:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700032666; x=1731568666;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IZkTMuFS3ek5MhgYwZatICOhIMZDNbB6QL6u9KmfYe8=;
  b=IC1gIajpLDbFzmUJRAdiKzKjiF2qHfHuN3RdKJK4W0szL8BgKG6hmuyO
   LfdqA4BIPuhpOsn+uR6xYkbIQsZpe/dDtJ02g6c1tiG6DT1oPrHxuh5zL
   5gQJLAipdC1SGVkShwbnqGQ/OY2QvRUzUeZdUNRxjqzZ3+BN1hrKk2nur
   ILVmXMdib3PD4q/tz9fWKz5UEcmdwRFINuymxWx1lH2Tu+3RxIEa+VXZr
   RYwDo9tdDb656JjZZHGm0slTa1jKyjBSpLpmnZseRdjoESTvkGkEQpp8M
   v+VWLcrhQn3tFFYp3SLF5aWezQXJwaUx0DPhRHQz+9HSxZg8bdu2auMud
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="390622570"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="390622570"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2023 23:17:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="714798090"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="714798090"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orsmga003.jf.intel.com with ESMTP; 14 Nov 2023 23:17:40 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Peter Xu <peterx@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Cornelia Huck <cohuck@redhat.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	xiaoyao.li@intel.com,
	Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Claudio Fontana <cfontana@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>
Subject: [PATCH v3 20/70] i386/tdx: Adjust the supported CPUID based on TDX restrictions
Date: Wed, 15 Nov 2023 02:14:29 -0500
Message-Id: <20231115071519.2864957-21-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231115071519.2864957-1-xiaoyao.li@intel.com>
References: <20231115071519.2864957-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

According to Chapter "CPUID Virtualization" in TDX module spec, CPUID
bits of TD can be classified into 6 types:

------------------------------------------------------------------------
1 | As configured | configurable by VMM, independent of native value;
------------------------------------------------------------------------
2 | As configured | configurable by VMM if the bit is supported natively
    (if native)   | Otherwise it equals as native(0).
------------------------------------------------------------------------
3 | Fixed         | fixed to 0/1
------------------------------------------------------------------------
4 | Native        | reflect the native value
------------------------------------------------------------------------
5 | Calculated    | calculated by TDX module.
------------------------------------------------------------------------
6 | Inducing #VE  | get #VE exception
------------------------------------------------------------------------

Note:
1. All the configurable XFAM related features and TD attributes related
   features fall into type #2. And fixed0/1 bits of XFAM and TD
   attributes fall into type #3.

2. For CPUID leaves not listed in "CPUID virtualization Overview" table
   in TDX module spec, TDX module injects #VE to TDs when those are
   queried. For this case, TDs can request CPUID emulation from VMM via
   TDVMCALL and the values are fully controlled by VMM.

Due to TDX module has its own virtualization policy on CPUID bits, it leads
to what reported via KVM_GET_SUPPORTED_CPUID diverges from the supported
CPUID bits for TDs. In order to keep a consistent CPUID configuration
between VMM and TDs. Adjust supported CPUID for TDs based on TDX
restrictions.

Currently only focus on the CPUID leaves recognized by QEMU's
feature_word_info[] that are indexed by a FeatureWord.

Introduce a TDX CPUID lookup table, which maintains 1 entry for each
FeatureWord. Each entry has below fields:

 - tdx_fixed0/1: The bits that are fixed as 0/1;

 - vmm_fixup:   The bits that are configurable from the view of TDX module.
                But they requires emulation of VMM when they are configured
	        as enabled. For those, they are not supported if VMM doesn't
		report them as supported. So they need be fixed up by
		checking if VMM supports them.

 - inducing_ve: TD gets #VE when querying this CPUID leaf. The result is
                totally configurable by VMM.

 - supported_on_ve: It's valid only when @inducing_ve is true. It represents
		    the maximum feature set supported that be emulated
		    for TDs.

By applying TDX CPUID lookup table and TDX capabilities reported from
TDX module, the supported CPUID for TDs can be obtained from following
steps:

- get the base of VMM supported feature set;

- if the leaf is not a FeatureWord just return VMM's value without
  modification;

- if the leaf is an inducing_ve type, applying supported_on_ve mask and
  return;

- include all native bits, it covers type #2, #4, and parts of type #1.
  (it also includes some unsupported bits. The following step will
   correct it.)

- apply fixed0/1 to it (it covers #3, and rectifies the previous step);

- add configurable bits (it covers the other part of type #1);

- fix the ones in vmm_fixup;

- filter the one has valid .supported field;

(Calculated type is ignored since it's determined at runtime).

Co-developed-by: Chenyi Qiang <chenyi.qiang@intel.com>
Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/cpu.h     |  16 +++
 target/i386/kvm/kvm.c |   4 +
 target/i386/kvm/tdx.c | 254 ++++++++++++++++++++++++++++++++++++++++++
 target/i386/kvm/tdx.h |   2 +
 4 files changed, 276 insertions(+)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index cd2e295bd655..bd9151d3bcaa 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -780,6 +780,8 @@ uint64_t x86_cpu_get_supported_feature_word(FeatureWord w,
 
 /* Support RDFSBASE/RDGSBASE/WRFSBASE/WRGSBASE */
 #define CPUID_7_0_EBX_FSGSBASE          (1U << 0)
+/* Support for TSC adjustment MSR 0x3B */
+#define CPUID_7_0_EBX_TSC_ADJUST        (1U << 1)
 /* Support SGX */
 #define CPUID_7_0_EBX_SGX               (1U << 2)
 /* 1st Group of Advanced Bit Manipulation Extensions */
@@ -798,8 +800,12 @@ uint64_t x86_cpu_get_supported_feature_word(FeatureWord w,
 #define CPUID_7_0_EBX_INVPCID           (1U << 10)
 /* Restricted Transactional Memory */
 #define CPUID_7_0_EBX_RTM               (1U << 11)
+/* Cache QoS Monitoring */
+#define CPUID_7_0_EBX_PQM               (1U << 12)
 /* Memory Protection Extension */
 #define CPUID_7_0_EBX_MPX               (1U << 14)
+/* Resource Director Technology Allocation */
+#define CPUID_7_0_EBX_RDT_A             (1U << 15)
 /* AVX-512 Foundation */
 #define CPUID_7_0_EBX_AVX512F           (1U << 16)
 /* AVX-512 Doubleword & Quadword Instruction */
@@ -855,10 +861,16 @@ uint64_t x86_cpu_get_supported_feature_word(FeatureWord w,
 #define CPUID_7_0_ECX_AVX512VNNI        (1U << 11)
 /* Support for VPOPCNT[B,W] and VPSHUFBITQMB */
 #define CPUID_7_0_ECX_AVX512BITALG      (1U << 12)
+/* Intel Total Memory Encryption */
+#define CPUID_7_0_ECX_TME               (1U << 13)
 /* POPCNT for vectors of DW/QW */
 #define CPUID_7_0_ECX_AVX512_VPOPCNTDQ  (1U << 14)
+/* Placeholder for bit 15 */
+#define CPUID_7_0_ECX_FZM               (1U << 15)
 /* 5-level Page Tables */
 #define CPUID_7_0_ECX_LA57              (1U << 16)
+/* MAWAU for MPX */
+#define CPUID_7_0_ECX_MAWAU             (31U << 17)
 /* Read Processor ID */
 #define CPUID_7_0_ECX_RDPID             (1U << 22)
 /* Bus Lock Debug Exception */
@@ -869,6 +881,8 @@ uint64_t x86_cpu_get_supported_feature_word(FeatureWord w,
 #define CPUID_7_0_ECX_MOVDIRI           (1U << 27)
 /* Move 64 Bytes as Direct Store Instruction */
 #define CPUID_7_0_ECX_MOVDIR64B         (1U << 28)
+/* ENQCMD and ENQCMDS instructions */
+#define CPUID_7_0_ECX_ENQCMD            (1U << 29)
 /* Support SGX Launch Control */
 #define CPUID_7_0_ECX_SGX_LC            (1U << 30)
 /* Protection Keys for Supervisor-mode Pages */
@@ -886,6 +900,8 @@ uint64_t x86_cpu_get_supported_feature_word(FeatureWord w,
 #define CPUID_7_0_EDX_SERIALIZE         (1U << 14)
 /* TSX Suspend Load Address Tracking instruction */
 #define CPUID_7_0_EDX_TSX_LDTRK         (1U << 16)
+/* PCONFIG instruction */
+#define CPUID_7_0_EDX_PCONFIG           (1U << 18)
 /* Architectural LBRs */
 #define CPUID_7_0_EDX_ARCH_LBR          (1U << 19)
 /* AMX_BF16 instruction */
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 28e60c5ea4a7..f2627dd61d2b 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -522,6 +522,10 @@ uint32_t kvm_arch_get_supported_cpuid(KVMState *s, uint32_t function,
         ret |= 1U << KVM_HINTS_REALTIME;
     }
 
+    if (is_tdx_vm()) {
+        tdx_get_supported_cpuid(function, index, reg, &ret);
+    }
+
     return ret;
 }
 
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index cf8889f0a8f9..eda6e695a884 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -15,11 +15,129 @@
 #include "qemu/error-report.h"
 #include "qapi/error.h"
 #include "qom/object_interfaces.h"
+#include "standard-headers/asm-x86/kvm_para.h"
 #include "sysemu/kvm.h"
+#include "sysemu/sysemu.h"
 
 #include "hw/i386/x86.h"
 #include "kvm_i386.h"
 #include "tdx.h"
+#include "../cpu-internal.h"
+
+#define TDX_SUPPORTED_KVM_FEATURES  ((1U << KVM_FEATURE_NOP_IO_DELAY) | \
+                                     (1U << KVM_FEATURE_PV_UNHALT) | \
+                                     (1U << KVM_FEATURE_PV_TLB_FLUSH) | \
+                                     (1U << KVM_FEATURE_PV_SEND_IPI) | \
+                                     (1U << KVM_FEATURE_POLL_CONTROL) | \
+                                     (1U << KVM_FEATURE_PV_SCHED_YIELD) | \
+                                     (1U << KVM_FEATURE_MSI_EXT_DEST_ID))
+
+typedef struct KvmTdxCpuidLookup {
+    uint32_t tdx_fixed0;
+    uint32_t tdx_fixed1;
+
+    /*
+     * The CPUID bits that are configurable from the view of TDX module
+     * but require VMM emulation if configured to enabled by VMM.
+     *
+     * For those bits, they cannot be enabled actually if VMM (KVM/QEMU) cannot
+     * virtualize them.
+     */
+    uint32_t vmm_fixup;
+
+    bool inducing_ve;
+    /*
+     * The maximum supported feature set for given inducing-#VE leaf.
+     * It's valid only when .inducing_ve is true.
+     */
+    uint32_t supported_on_ve;
+} KvmTdxCpuidLookup;
+
+ /*
+  * QEMU maintained TDX CPUID lookup tables, which reflects how CPUIDs are
+  * virtualized for guest TDs based on "CPUID virtualization" of TDX spec.
+  *
+  * Note:
+  *
+  * This table will be updated runtime by tdx_caps reported by platform.
+  *
+  */
+static KvmTdxCpuidLookup tdx_cpuid_lookup[FEATURE_WORDS] = {
+    [FEAT_1_EDX] = {
+        .tdx_fixed0 =
+            BIT(10) /* Reserved */ | BIT(20) /* Reserved */ | CPUID_IA64,
+        .tdx_fixed1 =
+            CPUID_MSR | CPUID_PAE | CPUID_MCE | CPUID_APIC |
+            CPUID_MTRR | CPUID_MCA | CPUID_CLFLUSH | CPUID_DTS,
+        .vmm_fixup =
+            CPUID_ACPI | CPUID_PBE,
+    },
+    [FEAT_1_ECX] = {
+        .tdx_fixed0 =
+            CPUID_EXT_VMX | CPUID_EXT_SMX | BIT(16) /* Reserved */,
+        .tdx_fixed1 =
+            CPUID_EXT_CX16 | CPUID_EXT_PDCM | CPUID_EXT_X2APIC |
+            CPUID_EXT_AES | CPUID_EXT_XSAVE | CPUID_EXT_RDRAND |
+            CPUID_EXT_HYPERVISOR,
+        .vmm_fixup =
+            CPUID_EXT_EST | CPUID_EXT_TM2 | CPUID_EXT_XTPR | CPUID_EXT_DCA,
+    },
+    [FEAT_8000_0001_EDX] = {
+        .tdx_fixed1 =
+            CPUID_EXT2_NX | CPUID_EXT2_PDPE1GB | CPUID_EXT2_RDTSCP |
+            CPUID_EXT2_LM,
+    },
+    [FEAT_7_0_EBX] = {
+        .tdx_fixed0 =
+            CPUID_7_0_EBX_TSC_ADJUST | CPUID_7_0_EBX_SGX | CPUID_7_0_EBX_MPX,
+        .tdx_fixed1 =
+            CPUID_7_0_EBX_FSGSBASE | CPUID_7_0_EBX_RTM |
+            CPUID_7_0_EBX_RDSEED | CPUID_7_0_EBX_SMAP |
+            CPUID_7_0_EBX_CLFLUSHOPT | CPUID_7_0_EBX_CLWB |
+            CPUID_7_0_EBX_SHA_NI,
+        .vmm_fixup =
+            CPUID_7_0_EBX_PQM | CPUID_7_0_EBX_RDT_A,
+    },
+    [FEAT_7_0_ECX] = {
+        .tdx_fixed0 =
+            CPUID_7_0_ECX_FZM | CPUID_7_0_ECX_MAWAU |
+            CPUID_7_0_ECX_ENQCMD | CPUID_7_0_ECX_SGX_LC,
+        .tdx_fixed1 =
+            CPUID_7_0_ECX_MOVDIR64B | CPUID_7_0_ECX_BUS_LOCK_DETECT,
+        .vmm_fixup =
+            CPUID_7_0_ECX_TME,
+    },
+    [FEAT_7_0_EDX] = {
+        .tdx_fixed1 =
+            CPUID_7_0_EDX_SPEC_CTRL | CPUID_7_0_EDX_ARCH_CAPABILITIES |
+            CPUID_7_0_EDX_CORE_CAPABILITY | CPUID_7_0_EDX_SPEC_CTRL_SSBD,
+        .vmm_fixup =
+            CPUID_7_0_EDX_PCONFIG,
+    },
+    [FEAT_8000_0008_EBX] = {
+        .tdx_fixed0 =
+            ~CPUID_8000_0008_EBX_WBNOINVD,
+        .tdx_fixed1 =
+            CPUID_8000_0008_EBX_WBNOINVD,
+    },
+    [FEAT_XSAVE] = {
+        .tdx_fixed1 =
+            CPUID_XSAVE_XSAVEOPT | CPUID_XSAVE_XSAVEC |
+            CPUID_XSAVE_XSAVES,
+    },
+    [FEAT_6_EAX] = {
+        .inducing_ve = true,
+        .supported_on_ve = CPUID_6_EAX_ARAT,
+    },
+    [FEAT_8000_0007_EDX] = {
+        .inducing_ve = true,
+        .supported_on_ve = -1U,
+    },
+    [FEAT_KVM] = {
+        .inducing_ve = true,
+        .supported_on_ve = TDX_SUPPORTED_KVM_FEATURES,
+    },
+};
 
 static TdxGuest *tdx_guest;
 
@@ -31,6 +149,142 @@ bool is_tdx_vm(void)
     return !!tdx_guest;
 }
 
+static inline uint32_t host_cpuid_reg(uint32_t function,
+                                      uint32_t index, int reg)
+{
+    uint32_t eax, ebx, ecx, edx;
+    uint32_t ret = 0;
+
+    host_cpuid(function, index, &eax, &ebx, &ecx, &edx);
+
+    switch (reg) {
+    case R_EAX:
+        ret = eax;
+        break;
+    case R_EBX:
+        ret = ebx;
+        break;
+    case R_ECX:
+        ret = ecx;
+        break;
+    case R_EDX:
+        ret = edx;
+        break;
+    }
+    return ret;
+}
+
+static inline uint32_t tdx_cap_cpuid_config(uint32_t function,
+                                            uint32_t index, int reg)
+{
+    struct kvm_tdx_cpuid_config *cpuid_c;
+    int ret = 0;
+    int i;
+
+    if (tdx_caps->nr_cpuid_configs <= 0) {
+        return ret;
+    }
+
+    for (i = 0; i < tdx_caps->nr_cpuid_configs; i++) {
+        cpuid_c = &tdx_caps->cpuid_configs[i];
+        /* 0xffffffff in sub_leaf means the leaf doesn't require a sublesf */
+        if (cpuid_c->leaf == function &&
+            (cpuid_c->sub_leaf == 0xffffffff || cpuid_c->sub_leaf == index)) {
+            switch (reg) {
+            case R_EAX:
+                ret = cpuid_c->eax;
+                break;
+            case R_EBX:
+                ret = cpuid_c->ebx;
+                break;
+            case R_ECX:
+                ret = cpuid_c->ecx;
+                break;
+            case R_EDX:
+                ret = cpuid_c->edx;
+                break;
+            default:
+                return 0;
+            }
+        }
+    }
+    return ret;
+}
+
+static FeatureWord get_cpuid_featureword_index(uint32_t function,
+                                               uint32_t index, int reg)
+{
+    FeatureWord w;
+
+    for (w = 0; w < FEATURE_WORDS; w++) {
+        FeatureWordInfo *f = &feature_word_info[w];
+
+        if (f->type == MSR_FEATURE_WORD || f->cpuid.eax != function ||
+            f->cpuid.reg != reg ||
+            (f->cpuid.needs_ecx && f->cpuid.ecx != index)) {
+            continue;
+        }
+
+        return w;
+    }
+
+    return w;
+}
+
+/*
+ * TDX supported CPUID varies from what KVM reports. Adjust the result by
+ * applying the TDX restrictions.
+ */
+void tdx_get_supported_cpuid(uint32_t function, uint32_t index, int reg,
+                             uint32_t *ret)
+{
+    uint32_t vmm_cap = *ret;
+    FeatureWord w;
+
+    /* Only handle features leaves that recognized by feature_word_info[] */
+    w = get_cpuid_featureword_index(function, index, reg);
+    if (w == FEATURE_WORDS) {
+        return;
+    }
+
+    if (tdx_cpuid_lookup[w].inducing_ve) {
+        *ret &= tdx_cpuid_lookup[w].supported_on_ve;
+        return;
+    }
+
+    /*
+     * Include all the native bits as first step. It covers types
+     * - As configured (if native)
+     * - Native
+     * - XFAM related and Attributes realted
+     *
+     * It also has side effect to enable unsupported bits, e.g., the
+     * bits of "fixed0" type while present natively. It's safe because
+     * the unsupported bits will be masked off by .fixed0 later.
+     */
+    *ret |= host_cpuid_reg(function, index, reg);
+
+    /* Adjust according to "fixed" type in tdx_cpuid_lookup. */
+    *ret |= tdx_cpuid_lookup[w].tdx_fixed1;
+    *ret &= ~tdx_cpuid_lookup[w].tdx_fixed0;
+
+    /*
+     * Configurable cpuids are supported unconditionally. It's mainly to
+     * include those configurable regardless of native existence.
+     */
+    *ret |= tdx_cap_cpuid_config(function, index, reg);
+
+    /*
+     * clear the configurable bits that require VMM emulation and VMM doesn't
+     * report the support.
+     */
+    *ret &= ~(~vmm_cap & tdx_cpuid_lookup[w].vmm_fixup);
+
+    /* special handling */
+    if (function == 1 && reg == R_ECX && !enable_cpu_pm)
+        *ret &= ~CPUID_EXT_MONITOR;
+}
+
 enum tdx_ioctl_level{
     TDX_PLATFORM_IOCTL,
     TDX_VM_IOCTL,
diff --git a/target/i386/kvm/tdx.h b/target/i386/kvm/tdx.h
index 4036ca2f3f99..06599b65b827 100644
--- a/target/i386/kvm/tdx.h
+++ b/target/i386/kvm/tdx.h
@@ -27,5 +27,7 @@ bool is_tdx_vm(void);
 #endif /* CONFIG_TDX */
 
 int tdx_kvm_init(MachineState *ms, Error **errp);
+void tdx_get_supported_cpuid(uint32_t function, uint32_t index, int reg,
+                             uint32_t *ret);
 
 #endif /* QEMU_I386_TDX_H */
-- 
2.34.1


