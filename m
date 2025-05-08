Return-Path: <kvm+bounces-45948-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 151E7AAFEB7
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 17:14:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 583601893FBF
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:13:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6946276054;
	Thu,  8 May 2025 15:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KvSAyACi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 334C92882CD
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 15:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746716835; cv=none; b=aCo4mXASSyeD6cIAWNN1872aMC5o/isGgkTWjlv1IvWKLrscorJKvKxIZshXZZznRZQy4TV56ApqO88i2RBGdazsZGPUEF/oEJ5Mjt6MtcPA/Uz3EEpTxShTZUd6hLd+FBFmS+MCuxICPCTTDxgbqzHo9YYq1M6TqFPzXuZGneo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746716835; c=relaxed/simple;
	bh=e9oQQbUuVFnD2yUp7MAAvRQXcEzbsQkQNA1ukXyYs6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TVjzGHXVWGqF9sj0n1NlC8KXnSeuCzwCjEl4HCmSo19axbSE1CHGGRQUbEBXlQ2Npt65qp4WBXEvPrsBAZxjwskTV/WGPfP/hDWDHu6i9pf5dEkSVq5Q6oHVGhYmFPmXwzGWRO9dHyqzUJMASOqarnkf9ftq/hy4riUxggNIP1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KvSAyACi; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746716834; x=1778252834;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=e9oQQbUuVFnD2yUp7MAAvRQXcEzbsQkQNA1ukXyYs6U=;
  b=KvSAyACiUnvjkfdLHEvG0rD02LeYVzQKDiGd5Gr7o/yZNVSGw858aCty
   rcHw6qAg0fz+Lwsite1K73dJQvit1tx1OJwmEygxThkyS9KRz97SMRYfd
   bI1EEC4k9WCEGGax73Q5E8juYA5fAK6mUbYF/9kYuKPdzTsRO5BI60W31
   gOxxXlQWLEnxlFQnSAmYmE+AfWPxKgnOVx6y0TzJvUNYrU+4ZV4je389R
   J2kjlEkzKlhMeTaqNCfKVgqAG8BJflJV5+nk2WKZ5/ZplzDnkgJAKT8x+
   Tk6TO6mOcHdpdHh3CfnpeUe2IIRwtfQ6y16EcGfFoemcFLk9fGVfqm9fq
   g==;
X-CSE-ConnectionGUID: rcfEdiLbTF+/wHC7nxgnEQ==
X-CSE-MsgGUID: XKy6+Y8VRNGZPgUKcazA9w==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="73888497"
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="73888497"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 08:07:14 -0700
X-CSE-ConnectionGUID: yFG925/xQkyNJiJBdE2Cyg==
X-CSE-MsgGUID: dW3Ndon8TdS6AGLeV9YtDg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="141440410"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 08 May 2025 08:07:11 -0700
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Francesco Lavra <francescolavra.fl@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v9 45/55] i386/tdx: Add TDX fixed1 bits to supported CPUIDs
Date: Thu,  8 May 2025 10:59:51 -0400
Message-ID: <20250508150002.689633-46-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250508150002.689633-1-xiaoyao.li@intel.com>
References: <20250508150002.689633-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

TDX architecture forcibly sets some CPUID bits for TD guest that VMM
cannot disable it. They are fixed1 bits.

Fixed1 bits are not covered by tdx_caps.cpuid (which only contains the
directly configurable bits), while fixed1 bits are supported for TD guest
obviously.

Add fixed1 bits to tdx_supported_cpuid. Besides, set all the fixed1
bits to the initial set of KVM's support since KVM might not report them
as supported.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes in v9:
 - Use the MACRO for bits in CPUID leaf 0x7_2_EDX; (Zhao Liu)
 - cleanup KVM_MAX_CPUID_ENTRIES in sev.c; (Zhao Liu)
---
 target/i386/cpu.h          |   2 +
 target/i386/kvm/kvm_i386.h |   7 ++
 target/i386/kvm/tdx.c      | 134 +++++++++++++++++++++++++++++++++++++
 target/i386/sev.c          |   8 ---
 4 files changed, 143 insertions(+), 8 deletions(-)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 42ef77789ded..115137279a1a 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -924,6 +924,8 @@ uint64_t x86_cpu_get_supported_feature_word(X86CPU *cpu, FeatureWord w);
 #define CPUID_7_0_EDX_FSRM              (1U << 4)
 /* AVX512 Vector Pair Intersection to a Pair of Mask Registers */
 #define CPUID_7_0_EDX_AVX512_VP2INTERSECT (1U << 8)
+ /* "md_clear" VERW clears CPU buffers */
+#define CPUID_7_0_EDX_MD_CLEAR          (1U << 10)
 /* SERIALIZE instruction */
 #define CPUID_7_0_EDX_SERIALIZE         (1U << 14)
 /* TSX Suspend Load Address Tracking instruction */
diff --git a/target/i386/kvm/kvm_i386.h b/target/i386/kvm/kvm_i386.h
index 484a1de84d51..c1bafcfc9b63 100644
--- a/target/i386/kvm/kvm_i386.h
+++ b/target/i386/kvm/kvm_i386.h
@@ -13,8 +13,15 @@
 
 #include "system/kvm.h"
 
+#include <linux/kvm.h>
+
 #define KVM_MAX_CPUID_ENTRIES  100
 
+typedef struct KvmCpuidInfo {
+    struct kvm_cpuid2 cpuid;
+    struct kvm_cpuid_entry2 entries[KVM_MAX_CPUID_ENTRIES];
+} KvmCpuidInfo;
+
 /* always false if !CONFIG_KVM */
 #define kvm_pit_in_kernel() \
     (kvm_irqchip_in_kernel() && !kvm_irqchip_is_split())
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 91c6295ddd17..cbbbbf399309 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -374,6 +374,133 @@ static Notifier tdx_machine_done_notify = {
     .notify = tdx_finalize_vm,
 };
 
+/*
+ * Some CPUID bits change from fixed1 to configurable bits when TDX module
+ * supports TDX_FEATURES0.VE_REDUCTION. e.g., MCA/MCE/MTRR/CORE_CAPABILITY.
+ *
+ * To make QEMU work with all the versions of TDX module, keep the fixed1 bits
+ * here if they are ever fixed1 bits in any of the version though not fixed1 in
+ * the latest version. Otherwise, with the older version of TDX module, QEMU may
+ * treat the fixed1 bit as unsupported.
+ *
+ * For newer TDX module, it does no harm to keep them in tdx_fixed1_bits even
+ * though they changed to configurable bits. Because tdx_fixed1_bits is used to
+ * setup the supported bits.
+ */
+KvmCpuidInfo tdx_fixed1_bits = {
+    .cpuid.nent = 8,
+    .entries[0] = {
+        .function = 0x1,
+        .index = 0,
+        .ecx = CPUID_EXT_SSE3 | CPUID_EXT_PCLMULQDQ | CPUID_EXT_DTES64 |
+               CPUID_EXT_DSCPL | CPUID_EXT_SSSE3 | CPUID_EXT_CX16 |
+               CPUID_EXT_PDCM | CPUID_EXT_PCID | CPUID_EXT_SSE41 |
+               CPUID_EXT_SSE42 | CPUID_EXT_X2APIC | CPUID_EXT_MOVBE |
+               CPUID_EXT_POPCNT | CPUID_EXT_AES | CPUID_EXT_XSAVE |
+               CPUID_EXT_RDRAND | CPUID_EXT_HYPERVISOR,
+        .edx = CPUID_FP87 | CPUID_VME | CPUID_DE | CPUID_PSE | CPUID_TSC |
+               CPUID_MSR | CPUID_PAE | CPUID_MCE | CPUID_CX8 | CPUID_APIC |
+               CPUID_SEP | CPUID_MTRR | CPUID_PGE | CPUID_MCA | CPUID_CMOV |
+               CPUID_PAT | CPUID_CLFLUSH | CPUID_DTS | CPUID_MMX | CPUID_FXSR |
+               CPUID_SSE | CPUID_SSE2,
+    },
+    .entries[1] = {
+        .function = 0x6,
+        .index = 0,
+        .eax = CPUID_6_EAX_ARAT,
+    },
+    .entries[2] = {
+        .function = 0x7,
+        .index = 0,
+        .flags = KVM_CPUID_FLAG_SIGNIFCANT_INDEX,
+        .ebx = CPUID_7_0_EBX_FSGSBASE | CPUID_7_0_EBX_FDP_EXCPTN_ONLY |
+               CPUID_7_0_EBX_SMEP | CPUID_7_0_EBX_INVPCID |
+               CPUID_7_0_EBX_ZERO_FCS_FDS | CPUID_7_0_EBX_RDSEED |
+               CPUID_7_0_EBX_SMAP | CPUID_7_0_EBX_CLFLUSHOPT |
+               CPUID_7_0_EBX_CLWB | CPUID_7_0_EBX_SHA_NI,
+        .ecx = CPUID_7_0_ECX_BUS_LOCK_DETECT | CPUID_7_0_ECX_MOVDIRI |
+               CPUID_7_0_ECX_MOVDIR64B,
+        .edx = CPUID_7_0_EDX_MD_CLEAR | CPUID_7_0_EDX_SPEC_CTRL |
+               CPUID_7_0_EDX_STIBP | CPUID_7_0_EDX_FLUSH_L1D |
+               CPUID_7_0_EDX_ARCH_CAPABILITIES | CPUID_7_0_EDX_CORE_CAPABILITY |
+               CPUID_7_0_EDX_SPEC_CTRL_SSBD,
+    },
+    .entries[3] = {
+        .function = 0x7,
+        .index = 2,
+        .flags = KVM_CPUID_FLAG_SIGNIFCANT_INDEX,
+        .edx = CPUID_7_2_EDX_PSFD | CPUID_7_2_EDX_IPRED_CTRL |
+               CPUID_7_2_EDX_RRSBA_CTRL | CPUID_7_2_EDX_BHI_CTRL,
+    },
+    .entries[4] = {
+        .function = 0xD,
+        .index = 0,
+        .flags = KVM_CPUID_FLAG_SIGNIFCANT_INDEX,
+        .eax = XSTATE_FP_MASK | XSTATE_SSE_MASK,
+    },
+    .entries[5] = {
+        .function = 0xD,
+        .index = 1,
+        .flags = KVM_CPUID_FLAG_SIGNIFCANT_INDEX,
+        .eax = CPUID_XSAVE_XSAVEOPT | CPUID_XSAVE_XSAVEC|
+               CPUID_XSAVE_XGETBV1 | CPUID_XSAVE_XSAVES,
+    },
+    .entries[6] = {
+        .function = 0x80000001,
+        .index = 0,
+        .ecx = CPUID_EXT3_LAHF_LM | CPUID_EXT3_ABM | CPUID_EXT3_3DNOWPREFETCH,
+        /*
+         * Strictly speaking, SYSCALL is not fixed1 bit since it depends on
+         * the CPU to be in 64-bit mode. But here fixed1 is used to serve the
+         * purpose of supported bits for TDX. In this sense, SYACALL is always
+         * supported.
+         */
+        .edx = CPUID_EXT2_SYSCALL | CPUID_EXT2_NX | CPUID_EXT2_PDPE1GB |
+               CPUID_EXT2_RDTSCP | CPUID_EXT2_LM,
+    },
+    .entries[7] = {
+        .function = 0x80000007,
+        .index = 0,
+        .edx = CPUID_APM_INVTSC,
+    },
+};
+
+static struct kvm_cpuid_entry2 *find_in_supported_entry(uint32_t function,
+                                                        uint32_t index)
+{
+    struct kvm_cpuid_entry2 *e;
+
+    e = cpuid_find_entry(tdx_supported_cpuid, function, index);
+    if (!e) {
+        if (tdx_supported_cpuid->nent >= KVM_MAX_CPUID_ENTRIES) {
+            error_report("tdx_supported_cpuid requries more space than %d entries",
+                          KVM_MAX_CPUID_ENTRIES);
+            exit(1);
+        }
+        e = &tdx_supported_cpuid->entries[tdx_supported_cpuid->nent++];
+        e->function = function;
+        e->index = index;
+    }
+
+    return e;
+}
+
+static void tdx_add_supported_cpuid_by_fixed1_bits(void)
+{
+    struct kvm_cpuid_entry2 *e, *e1;
+    int i;
+
+    for (i = 0; i < tdx_fixed1_bits.cpuid.nent; i++) {
+        e = &tdx_fixed1_bits.entries[i];
+
+        e1 = find_in_supported_entry(e->function, e->index);
+        e1->eax |= e->eax;
+        e1->ebx |= e->ebx;
+        e1->ecx |= e->ecx;
+        e1->edx |= e->edx;
+    }
+}
+
 static void tdx_setup_supported_cpuid(void)
 {
     if (tdx_supported_cpuid) {
@@ -386,6 +513,8 @@ static void tdx_setup_supported_cpuid(void)
     memcpy(tdx_supported_cpuid->entries, tdx_caps->cpuid.entries,
            tdx_caps->cpuid.nent * sizeof(struct kvm_cpuid_entry2));
     tdx_supported_cpuid->nent = tdx_caps->cpuid.nent;
+
+    tdx_add_supported_cpuid_by_fixed1_bits();
 }
 
 static int tdx_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
@@ -470,6 +599,11 @@ static uint32_t tdx_adjust_cpuid_features(X86ConfidentialGuest *cg,
 {
     struct kvm_cpuid_entry2 *e;
 
+    e = cpuid_find_entry(&tdx_fixed1_bits.cpuid, feature, index);
+    if (e) {
+        value |= cpuid_entry_get_reg(e, reg);
+    }
+
     if (is_feature_word_cpuid(feature, index, reg)) {
         e = cpuid_find_entry(tdx_supported_cpuid, feature, index);
         if (e) {
diff --git a/target/i386/sev.c b/target/i386/sev.c
index a6c0a697250b..d03c2f157844 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -211,14 +211,6 @@ static const char *const sev_fw_errlist[] = {
 
 #define SEV_FW_MAX_ERROR      ARRAY_SIZE(sev_fw_errlist)
 
-/* <linux/kvm.h> doesn't expose this, so re-use the max from kvm.c */
-#define KVM_MAX_CPUID_ENTRIES 100
-
-typedef struct KvmCpuidInfo {
-    struct kvm_cpuid2 cpuid;
-    struct kvm_cpuid_entry2 entries[KVM_MAX_CPUID_ENTRIES];
-} KvmCpuidInfo;
-
 #define SNP_CPUID_FUNCTION_MAXCOUNT 64
 #define SNP_CPUID_FUNCTION_UNKNOWN 0xFFFFFFFF
 
-- 
2.43.0


