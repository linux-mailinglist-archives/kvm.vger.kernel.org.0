Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CA8062FB70
	for <lists+kvm@lfdr.de>; Fri, 18 Nov 2022 18:17:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242482AbiKRRRz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Nov 2022 12:17:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234216AbiKRRRy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Nov 2022 12:17:54 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C567827B23
        for <kvm@vger.kernel.org>; Fri, 18 Nov 2022 09:17:53 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id k7so5117521pll.6
        for <kvm@vger.kernel.org>; Fri, 18 Nov 2022 09:17:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=b5nxzOpKEeCGYJhJRX5YsoAl8Hgv43ND8xd6hX2KrkY=;
        b=CsQbyovAo5pbcqNycehXEy1eBJxNPz3NPbJ2gpnj5k/6T7qIUhvedMUaLg768/L6vf
         zlLV6Ct2a4yu0FIamw04MHvaVe0JNzOgSKmoLx9bNs5/8K7I/oCpVFVG9V43ZBuQmjth
         iJRK0v66H+BzKwothF2Ejj1XrpC+9pQgk98UNsEKPvPe5jQX+ENQCTiBmVXgeL75a3nd
         dF6j3O1iPBCPcuDVSTQGlhvgAmT/u1+SVbRVTBv47f6vej54yIGYumeoqOfhr+8MSbFO
         r0Vpzw9Xa/t4iUYesh4T+wL/k0cRHoLbd0uEWqwEPokTrj1Mx8oqYxpFdgSkdh1JXOUV
         jLNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b5nxzOpKEeCGYJhJRX5YsoAl8Hgv43ND8xd6hX2KrkY=;
        b=T/8gxpXBEO9no/408jHwihhw+ZlkXGyzXpVRW/ROc1mEDJbjl3Rmw0AYswr3uDHWHP
         C7jGB8kZprlgITnVb3RDAtxnQ0Ntp3kQg8GFDpie7XKBysXFXNgef3SzYxEU5/FoJJja
         ixkrm2xv1HxfbetzbWrxRDvVen9KICUwylGgagX7ZCXbaEX/UGDjF4FlET4B4VY71INh
         lRLTbXmUoPtrId3vIFtkSv0ThL4PkyDgSUWjnwA1shh9+w2dQ64nRRw5yQduALsu/pss
         B6rTLV2/ic/1E+zWyw0RGp5rurD1KkZVpV3O/pVwJJitmid6+FnNgymxbqlZw1Wk52pS
         hWUg==
X-Gm-Message-State: ANoB5pkOHiagxsBnbwugwTydwIZdNVKkGSIiHuRXSd4LuuDe++h7iky0
        no/zdJHVMh05XKfUAEHEhtGVKg==
X-Google-Smtp-Source: AA0mqf7rDwdDj3hXsrprWP1jRxOpUOVx04vjbpzKkO5HjVV69Bfglok1pHOhxEnzbjdtfmX1UIC25g==
X-Received: by 2002:a17:902:e0ca:b0:188:712f:dfa5 with SMTP id e10-20020a170902e0ca00b00188712fdfa5mr362168pla.140.1668791873063;
        Fri, 18 Nov 2022 09:17:53 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id bo12-20020a17090b090c00b0021858c84c7bsm2972443pjb.50.2022.11.18.09.17.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 09:17:52 -0800 (PST)
Date:   Fri, 18 Nov 2022 17:17:48 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jiaxi Chen <jiaxi.chen@linux.intel.com>
Cc:     kvm@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, pbonzini@redhat.com, ndesaulniers@google.com,
        alexandre.belloni@bootlin.com, peterz@infradead.org,
        jpoimboe@kernel.org, chang.seok.bae@intel.com,
        pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com,
        jmattson@google.com, sandipan.das@amd.com, tony.luck@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, fenghua.yu@intel.com,
        keescook@chromium.org, nathan@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 4/6] x86: KVM: Advertise AVX-VNNI-INT8 CPUID to user
 space
Message-ID: <Y3e+PNvvuuT3aCmb@google.com>
References: <20221118141509.489359-1-jiaxi.chen@linux.intel.com>
 <20221118141509.489359-5-jiaxi.chen@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="NxmGoc9WWi4h5czq"
Content-Disposition: inline
In-Reply-To: <20221118141509.489359-5-jiaxi.chen@linux.intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--NxmGoc9WWi4h5czq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 18, 2022, Jiaxi Chen wrote:
> AVX-VNNI-INT8 is a new set of instructions in the latest Intel platform
> Sierra Forest, aims for the platform to have superior AI capabilities.
> This instruction multiplies the individual bytes of two unsigned or
> unsigned source operands, then adds and accumulates the results into the
> destination dword element size operand.
> 
> The bit definition:
> CPUID.(EAX=7,ECX=1):EDX[bit 4]
> 
> This CPUID is exposed to user space. Besides, there is no other VMX
> control for this instruction.
> 
> Signed-off-by: Jiaxi Chen <jiaxi.chen@linux.intel.com>
> ---
>  arch/x86/kvm/cpuid.c         | 5 ++++-
>  arch/x86/kvm/reverse_cpuid.h | 5 +++++
>  2 files changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 5726afb2d14c..e2b8e5485474 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -660,6 +660,9 @@ void kvm_set_cpu_caps(void)
>  		F(AVX_VNNI) | F(AVX512_BF16) | F(CMPCCXADD) | F(AMX_FP16) |
>  		F(AVX_IFMA));
>  
> +	kvm_cpu_cap_init_scattered(CPUID_7_1_EDX,

Ah, this is going to be confusing and potentially error prone.  AVX_VNNI_INT8
isn't actually scattered, i.e. kvm_cpu_cap_init_scattered() is poorly named.  And
using SF() would be _really_ broken as boot_cpu_has() would consume garbage and
potentially leak kernel state to userspace.

To address these issue and also document how to add KVM-only features, can you
slot in the two attached patches at the begining of this series?

Thanks!

> +		F(AVX_VNNI_INT8));

Terminators on a separate line please.

>  	kvm_cpu_cap_mask(CPUID_D_1_EAX,
>  		F(XSAVEOPT) | F(XSAVEC) | F(XGETBV1) | F(XSAVES) | f_xfd
>  	);

--NxmGoc9WWi4h5czq
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-KVM-x86-Add-BUILD_BUG_ON-to-detect-bad-usage-of-scat.patch"

From d913e35721688aca42056e57a261fa4baad0c45e Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Fri, 18 Nov 2022 08:17:55 -0800
Subject: [PATCH 1/2] KVM: x86: Add BUILD_BUG_ON() to detect bad usage of
 "scattered" flags

Add a compile-time assert in the SF() macro to detect improper usage,
i.e. to detect passing in an X86_FEATURE_* flag that isn't actually
scattered by the kernel.  Upcoming feature flags will be 100% KVM-only
and will have X86_FEATURE_* macros that point at a kvm_only_cpuid_leafs
word, not a kernel-defined word.  Using SF() and thus boot_cpu_has() for
such feature flags would access memory beyond x86_capability[NCAPINTS]
and at best incorrectly hide a feature, and at worst leak kernel state to
userspace.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 6b5912578edd..ff2e9734e5c1 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -65,7 +65,13 @@ u32 xstate_required_size(u64 xstate_bv, bool compacted)
 #define KVM_X86_FEATURE_AMD_PSFD	(13*32+28) /* Predictive Store Forwarding Disable */
 
 #define F feature_bit
-#define SF(name) (boot_cpu_has(X86_FEATURE_##name) ? F(name) : 0)
+
+/* Scattered Flag - For features that are scattered by cpufeatures.h. */
+#define SF(name)						\
+({								\
+	BUILD_BUG_ON(X86_FEATURE_##name >= MAX_CPU_FEATURES);	\
+	(boot_cpu_has(X86_FEATURE_##name) ? F(name) : 0);	\
+})
 
 /*
  * Magic value used by KVM when querying userspace-provided CPUID entries and

base-commit: d663b8a285986072428a6a145e5994bc275df994
-- 
2.38.1.584.g0f3c55d4c2-goog


--NxmGoc9WWi4h5czq
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0002-KVM-x86-Update-KVM-only-leaf-handling-to-allow-for-1.patch"

From 565a06e1d6e1ea40daa113bc2b3d10e7b2a8a508 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Fri, 18 Nov 2022 08:52:28 -0800
Subject: [PATCH 2/2] KVM: x86: Update KVM-only leaf handling to allow for 100%
 KVM-only leafs

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
index ff2e9734e5c1..73c3c6dc6e7b 100644
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
2.38.1.584.g0f3c55d4c2-goog


--NxmGoc9WWi4h5czq--
