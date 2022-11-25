Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD3A1638AA7
	for <lists+kvm@lfdr.de>; Fri, 25 Nov 2022 13:58:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbiKYM6v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Nov 2022 07:58:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbiKYM6s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Nov 2022 07:58:48 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C75522870A;
        Fri, 25 Nov 2022 04:58:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669381127; x=1700917127;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gVUECM94yIRd057tWclrKJlWO+Krnw3qbsLeXiY67U4=;
  b=fT0Ox0Jyw2gCVYCnv8Cq/WO2HrKeK2yu9P1GZXcaXGGvXyLUBa2d3uY4
   8pTs7muKOCnXoSuOo8jyZBa5NGToV0PEsTJSQLxOWJI10G1p1XzFSNcjL
   ISzUnG72076CzBcmUkNlEPPBEQjhbP2zJC46q6W3Rycn6jHwFdi+DRkcp
   OVGfK14rkQUNK/OE2EXOKXhxBd29Cc4DpOMAcJhw8UQp79HiGvKQKXKGg
   SfIfqApcC9LfucsEX1fL/4UF7eBoVWZBLaNyciFAQ9n4nJPQ00bH9Bhno
   0tVmxOUflLXMQZFb1zSNNWqBnnUse0VcwE+Q9sS8r6O8VEQu2GIf6oW/e
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="294180562"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="294180562"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2022 04:58:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="706061243"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="706061243"
Received: from jiaxichen-precision-3650-tower.sh.intel.com ([10.239.159.75])
  by fmsmga008.fm.intel.com with ESMTP; 25 Nov 2022 04:58:42 -0800
From:   Jiaxi Chen <jiaxi.chen@linux.intel.com>
To:     kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        seanjc@google.com, pbonzini@redhat.com, ndesaulniers@google.com,
        alexandre.belloni@bootlin.com, peterz@infradead.org,
        jpoimboe@kernel.org, chang.seok.bae@intel.com,
        pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com,
        jmattson@google.com, sandipan.das@amd.com, tony.luck@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, fenghua.yu@intel.com,
        keescook@chromium.org, nathan@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 2/8] KVM: x86: Update KVM-only leaf handling to allow for 100% KVM-only leafs
Date:   Fri, 25 Nov 2022 20:58:39 +0800
Message-Id: <20221125125845.1182922-3-jiaxi.chen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221125125845.1182922-1-jiaxi.chen@linux.intel.com>
References: <20221125125845.1182922-1-jiaxi.chen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Rename kvm_cpu_cap_init_scattered() to kvm_cpu_cap_init_kvm_defined() in
anticipation of adding KVM-only CPUID leafs that aren't recognized by the
kernel and thus not scattered, i.e. for leafs that are 100% KVM-defined.

Adjust/add comments to kvm_only_cpuid_leafs and KVM_X86_FEATURE to
document how to create new kvm_only_cpuid_leafs entries for scattered
features as well as features that are entirely unknown to the kernel.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c         |  8 ++++----
 arch/x86/kvm/reverse_cpuid.h | 18 +++++++++++++++---
 2 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 65b103874139..a3adac48766b 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -549,9 +549,9 @@ static __always_inline void __kvm_cpu_cap_mask(unsigned int leaf)
 }
 
 static __always_inline
-void kvm_cpu_cap_init_scattered(enum kvm_only_cpuid_leafs leaf, u32 mask)
+void kvm_cpu_cap_init_kvm_defined(enum kvm_only_cpuid_leafs leaf, u32 mask)
 {
-	/* Use kvm_cpu_cap_mask for non-scattered leafs. */
+	/* Use kvm_cpu_cap_mask for leafs that aren't KVM-only. */
 	BUILD_BUG_ON(leaf < NCAPINTS);
 
 	kvm_cpu_caps[leaf] = mask;
@@ -561,7 +561,7 @@ void kvm_cpu_cap_init_scattered(enum kvm_only_cpuid_leafs leaf, u32 mask)
 
 static __always_inline void kvm_cpu_cap_mask(enum cpuid_leafs leaf, u32 mask)
 {
-	/* Use kvm_cpu_cap_init_scattered for scattered leafs. */
+	/* Use kvm_cpu_cap_init_kvm_defined for KVM-only leafs. */
 	BUILD_BUG_ON(leaf >= NCAPINTS);
 
 	kvm_cpu_caps[leaf] &= mask;
@@ -670,7 +670,7 @@ void kvm_set_cpu_caps(void)
 		F(XSAVEOPT) | F(XSAVEC) | F(XGETBV1) | F(XSAVES) | f_xfd
 	);
 
-	kvm_cpu_cap_init_scattered(CPUID_12_EAX,
+	kvm_cpu_cap_init_kvm_defined(CPUID_12_EAX,
 		SF(SGX1) | SF(SGX2)
 	);
 
diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
index a19d473d0184..443a6b3e66c0 100644
--- a/arch/x86/kvm/reverse_cpuid.h
+++ b/arch/x86/kvm/reverse_cpuid.h
@@ -7,9 +7,9 @@
 #include <asm/cpufeatures.h>
 
 /*
- * Hardware-defined CPUID leafs that are scattered in the kernel, but need to
- * be directly used by KVM.  Note, these word values conflict with the kernel's
- * "bug" caps, but KVM doesn't use those.
+ * Hardware-defined CPUID leafs that are either scattered by the kernel or are
+ * unknown to the kernel, but need to be directly used by KVM.  Note, these
+ * word values conflict with the kernel's "bug" caps, but KVM doesn't use those.
  */
 enum kvm_only_cpuid_leafs {
 	CPUID_12_EAX	 = NCAPINTS,
@@ -18,6 +18,18 @@ enum kvm_only_cpuid_leafs {
 	NKVMCAPINTS = NR_KVM_CPU_CAPS - NCAPINTS,
 };
 
+/*
+ * Define a KVM-only feature flag.
+ *
+ * For features that are scattered by cpufeatures.h, __feature_translate() also
+ * needs to be updated to translate the kernel-defined feature into the
+ * KVM-defined feature.
+ *
+ * For features that are 100% KVM-only, i.e. not defined by cpufeatures.h,
+ * forego the intermediate KVM_X86_FEATURE and directly define X86_FEATURE_* so
+ * that X86_FEATURE_* can be used in KVM.  No __feature_translate() handling is
+ * needed in this case.
+ */
 #define KVM_X86_FEATURE(w, f)		((w)*32 + (f))
 
 /* Intel-defined SGX sub-features, CPUID level 0x12 (EAX). */
-- 
2.27.0

