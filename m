Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B066D2EFBE4
	for <lists+kvm@lfdr.de>; Sat,  9 Jan 2021 00:56:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725875AbhAHX4l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jan 2021 18:56:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725792AbhAHX4k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jan 2021 18:56:40 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84216C061573
        for <kvm@vger.kernel.org>; Fri,  8 Jan 2021 15:56:00 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id b8so6527007plx.0
        for <kvm@vger.kernel.org>; Fri, 08 Jan 2021 15:56:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=S+3Q5yToh9Uk9nbueKe5L7MEZPl+t268Lhvo5vvjOLk=;
        b=ayoFHmCU+ddKUf/HXTOSnh8QZoT8Qpv2bGtVLkl1iMBAl7ISvQEPWm4sOOzzJsVBJV
         WAuLtLnsGaOOb/sngXY3GjJnTJNYTO3rbhleyXbainaPscZ/T1pGtb+RpV8AtXwBZFTA
         fizo3W1eYtt+QhcDWD62iyAAgVnOMNWz8GSvLf+36lRUag8N7tVi7ppAKQPHSw/qjFCc
         ElIuv2UJL65R/QgggtH7FWiOPlSfufKm17JpDZEZfQ3S4m/e+JivDEESV7gbDnJbPRLt
         NViXgcgEIUTjIic2/l35v2+Qe28ZV6UPtATM0plLeko/msuyXJyca4KGNLG8qfR0W3Ot
         0umg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=S+3Q5yToh9Uk9nbueKe5L7MEZPl+t268Lhvo5vvjOLk=;
        b=eDBWfTZ9gZLt939ADMZqU7Q+0Gik33P+prbkfqAVQaP91Pv2Upkly5VnCSeDNNu0dX
         9JzpQiAKMMMO1blp76uKgO50qnzgJbmttc0YQ8SxlZ54Tl35MXucZZ6N+S4NIQk0mATZ
         2ftW4rsLGKfP/LLvWh1j8Z9zUhqY0GGowRYWTX62SEr7AdhqaehemcFuYzseIoeEjSt8
         d8MgqksGjxEN2MC9lg23DRkyey3p2RHraBFyTdbg40kbwLU1SjDaXCYowATZFOfsQnZU
         cRez9U8PtbF2pA1Y7h1jtwPnxrdGhONYNTEvxFvBRQHaA8LpS6mQnMPkP3sDN98r5HCZ
         +c/Q==
X-Gm-Message-State: AOAM530j+zesQuVcFFDb/LBk61P28IftTHdQIf6SZHwALApcmLNQmoj+
        CidFtbtuhTdGXNa0TVnSVpmeacZ4AtxhWw==
X-Google-Smtp-Source: ABdhPJxSYdXxv8emVjwNDTkskPKqr5+hJ5Wj5OeADTJtcmcp3BarPdM3j8boc6DTpvRUdmOJ8wu00g==
X-Received: by 2002:a17:90b:228b:: with SMTP id kx11mr6418148pjb.122.1610150159906;
        Fri, 08 Jan 2021 15:55:59 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id a18sm10228693pfg.107.2021.01.08.15.55.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 15:55:59 -0800 (PST)
Date:   Fri, 8 Jan 2021 15:55:52 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Kai Huang <kai.huang@intel.com>,
        Dave Hansen <dave.hansen@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, jarkko@kernel.org,
        luto@kernel.org, haitao.huang@intel.com, pbonzini@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH 04/23] x86/cpufeatures: Add SGX1 and SGX2 sub-features
Message-ID: <X/jxCOLG+HUO4QlZ@google.com>
References: <cover.1609890536.git.kai.huang@intel.com>
 <381b25a0dc0ed3e4579d50efb3634329132a2c02.1609890536.git.kai.huang@intel.com>
 <20210106221527.GB24607@zn.tnic>
 <20210107120946.ef5bae4961d0be91eff56d6b@intel.com>
 <20210107064125.GB14697@zn.tnic>
 <20210108150018.7a8c2e2fb442c9c68b0aa624@intel.com>
 <a0f75623-b0ce-bf19-4678-0f3e94a3a828@intel.com>
 <20210108200350.7ba93b8cd19978fe27da74af@intel.com>
 <20210108071722.GA4042@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210108071722.GA4042@zn.tnic>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 08, 2021, Borislav Petkov wrote:
> On Fri, Jan 08, 2021 at 08:03:50PM +1300, Kai Huang wrote:
> > > > I am not sure changing reverse lookup to handle dynamic would be acceptable. To
> > > > me it is ugly, and I don't have a first glance on how to do it. KVM can query
> > > > host CPUID when dealing with SGX w/o X86_FEATURE_SGX1/2, but it is not as
> > > > straightforward as having X86_FEATURE_SGX1/2.
> > > 
> > > So, Boris was pretty direct here.  Could you please go spend a bit of
> > > time to see what it would take to make these dynamic?  You can check
> > > what our (Intel) plans are for this leaf, but if it's going to remain
> > > sparsely-used, we need to look into making the leaves a bit more dynamic.

To be fair, this is the third time we've got conflicting, direct feedback on
this exact issue.  I do agree that it doesn't make sense to burn a whole word
for just two features, I guess I just feel like whining.

[*] https://lore.kernel.org/kvm/20180828102140.GA31102@nazgul.tnic/
[*] https://lore.kernel.org/linux-sgx/20190924162520.GJ19317@zn.tnic/

> > I don't think reverse lookup can be made dyanmic, but like I said if we don't
> > have X86_FEATURE_SGX1/2, KVM needs to query raw CPUID when dealing with SGX.
> 
> How about before you go and say that "it is ugly" and "don't think can
> be made" you actually go and *really* try it first? Because actually
> trying is sometimes faster than trying to find arguments against it. :)
> 
> Because I just did it and unless I'm missing something obvious - I
> haven't actually tested it - this is not ugly at all and in the long run
> it will become one big switch-case, which is perfectly fine.
>
> ---
> diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
> index 59bf91c57aa8..0bf5cb5441f8 100644
> --- a/arch/x86/include/asm/cpufeature.h
> +++ b/arch/x86/include/asm/cpufeature.h
> @@ -30,6 +30,7 @@ enum cpuid_leafs
>  	CPUID_7_ECX,
>  	CPUID_8000_0007_EBX,
>  	CPUID_7_EDX,
> +	CPUID_12_EAX,	/* used only by KVM for now */
>  };
>  
>  #ifdef CONFIG_X86_FEATURE_NAMES
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index 84b887825f12..1bc1ade64489 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -292,6 +292,8 @@
>  #define X86_FEATURE_FENCE_SWAPGS_KERNEL	(11*32+ 5) /* "" LFENCE in kernel entry SWAPGS path */
>  #define X86_FEATURE_SPLIT_LOCK_DETECT	(11*32+ 6) /* #AC for split lock */
>  #define X86_FEATURE_PER_THREAD_MBA	(11*32+ 7) /* "" Per-thread Memory Bandwidth Allocation */
> +#define X86_FEATURE_SGX1		(11*32+ 8) /* SGX1 leaf functions */
> +#define X86_FEATURE_SGX2		(11*32+ 9) /* SGX2 leaf functions */
>  
>  /* Intel-defined CPU features, CPUID level 0x00000007:1 (EAX), word 12 */
>  #define X86_FEATURE_AVX512_BF16		(12*32+ 5) /* AVX512 BFLOAT16 instructions */
> diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
> index dc921d76e42e..33c53a7411a1 100644
> --- a/arch/x86/kvm/cpuid.h
> +++ b/arch/x86/kvm/cpuid.h
> @@ -63,8 +63,27 @@ static const struct cpuid_reg reverse_cpuid[] = {
>  	[CPUID_8000_0007_EBX] = {0x80000007, 0, CPUID_EBX},
>  	[CPUID_7_EDX]         = {         7, 0, CPUID_EDX},
>  	[CPUID_7_1_EAX]       = {         7, 1, CPUID_EAX},
> +	[CPUID_12_EAX]        = {      0x12, 0, CPUID_EAX},
>  };

As is, this won't build (if KVM uses the features) because KVM cares about where
the feature actually lives in Linux's words.  The addition of CPUID_12_EAX is
unnecessary, and the new entry in reverse_cpuid would need to be
s/CPUID_12_EAX/CPUID_LNX_4.

That being said, I dislike this approach as it introduces fragility into KVM's
CPUID shenanigans.  E.g. fixing the above will make guest_cpuid_has() functional,
but kvm_cpu_cap_mask() and cpuid_entry_override() will not work as expected.

Here's a more involved approach that I believe will work (compile tested only)
and retains KVM's build magic.  Idea is to allocate a word kvm_cpu_caps for the
hardware-defined, Linux-scattered features, and use boot_cpu_has() to bridge the
gap when populating kvm_cpu_caps.

Another alternative would be to have KVM use boot_cpu_has() for everything, and
omit the memcpy from boot_cpu_data.x86_capability -> kvm_cpu_caps.  That would
eliminate some of the special logic for scattered features, but it adds nearly
3k bytes to kvm_set_cpu_caps(), which is hard to stomach even though it's
effectively one-and-done code.


From 6bdd61e23f1c0bd7519a3a6391c95cde5456f79d Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Fri, 8 Jan 2021 15:46:11 -0800
Subject: [PATCH] KVM: x86: Add support for reverse CPUID lookup of scattered
 features

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/cpufeatures.h |  2 ++
 arch/x86/kvm/cpuid.c               | 36 ++++++++++++++++++---
 arch/x86/kvm/cpuid.h               | 50 +++++++++++++++++++++++++++---
 3 files changed, 78 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 9f9e9511f7cd..2fe57736d644 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -291,6 +291,8 @@
 #define X86_FEATURE_FENCE_SWAPGS_KERNEL	(11*32+ 5) /* "" LFENCE in kernel entry SWAPGS path */
 #define X86_FEATURE_SPLIT_LOCK_DETECT	(11*32+ 6) /* #AC for split lock */
 #define X86_FEATURE_PER_THREAD_MBA	(11*32+ 7) /* "" Per-thread Memory Bandwidth Allocation */
+#define X86_FEATURE_SGX1                (11*32+ 8) /* SGX1 leafs */
+#define X86_FEATURE_SGX2        	(11*32+ 9) /* SGX2 leafs */

 /* Intel-defined CPU features, CPUID level 0x00000007:1 (EAX), word 12 */
 #define X86_FEATURE_AVX512_BF16		(12*32+ 5) /* AVX512 BFLOAT16 instructions */
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 13036cf0b912..4e647524f302 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -28,7 +28,7 @@
  * Unlike "struct cpuinfo_x86.x86_capability", kvm_cpu_caps doesn't need to be
  * aligned to sizeof(unsigned long) because it's not accessed via bitops.
  */
-u32 kvm_cpu_caps[NCAPINTS] __read_mostly;
+u32 kvm_cpu_caps[NR_KVM_CPU_CAPS] __read_mostly;
 EXPORT_SYMBOL_GPL(kvm_cpu_caps);

 static u32 xstate_required_size(u64 xstate_bv, bool compacted)
@@ -53,6 +53,7 @@ static u32 xstate_required_size(u64 xstate_bv, bool compacted)
 }

 #define F feature_bit
+#define SF(name) (boot_cpu_has(X86_FEATURE_##name) ? F(name) : 0)

 static inline struct kvm_cpuid_entry2 *cpuid_entry2_find(
 	struct kvm_cpuid_entry2 *entries, int nent, u32 function, u32 index)
@@ -331,13 +332,13 @@ int kvm_vcpu_ioctl_get_cpuid2(struct kvm_vcpu *vcpu,
 	return r;
 }

-static __always_inline void kvm_cpu_cap_mask(enum cpuid_leafs leaf, u32 mask)
+/* Mask kvm_cpu_caps for @leaf with the raw CPUID capabilities of this CPU. */
+static __always_inline void __kvm_cpu_cap_mask(enum cpuid_leafs leaf)
 {
 	const struct cpuid_reg cpuid = x86_feature_cpuid(leaf * 32);
 	struct kvm_cpuid_entry2 entry;

 	reverse_cpuid_check(leaf);
-	kvm_cpu_caps[leaf] &= mask;

 	cpuid_count(cpuid.function, cpuid.index,
 		    &entry.eax, &entry.ebx, &entry.ecx, &entry.edx);
@@ -345,6 +346,26 @@ static __always_inline void kvm_cpu_cap_mask(enum cpuid_leafs leaf, u32 mask)
 	kvm_cpu_caps[leaf] &= *__cpuid_entry_get_reg(&entry, cpuid.reg);
 }

+static __always_inline void kvm_cpu_cap_mask(enum cpuid_leafs leaf, u32 mask)
+{
+	/* Use the "init" variant for scattered leafs. */
+	BUILD_BUG_ON(leaf >= NCAPINTS);
+
+	kvm_cpu_caps[leaf] &= mask;
+
+	__kvm_cpu_cap_mask(leaf);
+}
+
+static __always_inline void kvm_cpu_cap_init(enum cpuid_leafs leaf, u32 mask)
+{
+	/* Use the "mask" variant for hardwared-defined leafs. */
+	BUILD_BUG_ON(leaf < NCAPINTS);
+
+	kvm_cpu_caps[leaf] = mask;
+
+	__kvm_cpu_cap_mask(leaf);
+}
+
 void kvm_set_cpu_caps(void)
 {
 	unsigned int f_nx = is_efer_nx() ? F(NX) : 0;
@@ -355,12 +376,13 @@ void kvm_set_cpu_caps(void)
 	unsigned int f_gbpages = 0;
 	unsigned int f_lm = 0;
 #endif
+	memset(kvm_cpu_caps, 0, sizeof(kvm_cpu_caps));

-	BUILD_BUG_ON(sizeof(kvm_cpu_caps) >
+	BUILD_BUG_ON(sizeof(kvm_cpu_caps) - (NKVMCAPINTS * sizeof(*kvm_cpu_caps)) >
 		     sizeof(boot_cpu_data.x86_capability));

 	memcpy(&kvm_cpu_caps, &boot_cpu_data.x86_capability,
-	       sizeof(kvm_cpu_caps));
+	       sizeof(kvm_cpu_caps) - (NKVMCAPINTS * sizeof(*kvm_cpu_caps)));

 	kvm_cpu_cap_mask(CPUID_1_ECX,
 		/*
@@ -503,6 +525,10 @@ void kvm_set_cpu_caps(void)
 		F(ACE2) | F(ACE2_EN) | F(PHE) | F(PHE_EN) |
 		F(PMM) | F(PMM_EN)
 	);
+
+	kvm_cpu_cap_init(CPUID_12_EAX,
+		SF(SGX1) | SF(SGX2)
+	);
 }
 EXPORT_SYMBOL_GPL(kvm_set_cpu_caps);

diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index dc921d76e42e..21f92d81d5a5 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -7,7 +7,25 @@
 #include <asm/processor.h>
 #include <uapi/asm/kvm_para.h>

-extern u32 kvm_cpu_caps[NCAPINTS] __read_mostly;
+/*
+ * Hardware-defined CPUID leafs that are scattered in the kernel, but need to
+ * be directly by KVM.  Note, these word values conflict with the kernel's
+ * "bug" caps, but KVM doesn't use those.
+ */
+enum kvm_only_cpuid_leafs {
+	CPUID_12_EAX	 = NCAPINTS,
+	NR_KVM_CPU_CAPS,
+
+	NKVMCAPINTS = NR_KVM_CPU_CAPS - NCAPINTS,
+};
+
+#define X86_KVM_FEATURE(w, f)		((w)*32 + (f))
+
+/* Intel-defined SGX sub-features, CPUID level 0x12 (EAX). */
+#define __X86_FEATURE_SGX1		X86_KVM_FEATURE(CPUID_12_EAX, 0)
+#define __X86_FEATURE_SGX2		X86_KVM_FEATURE(CPUID_12_EAX, 1)
+
+extern u32 kvm_cpu_caps[NR_KVM_CPU_CAPS] __read_mostly;
 void kvm_set_cpu_caps(void);

 void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu);
@@ -63,6 +81,7 @@ static const struct cpuid_reg reverse_cpuid[] = {
 	[CPUID_8000_0007_EBX] = {0x80000007, 0, CPUID_EBX},
 	[CPUID_7_EDX]         = {         7, 0, CPUID_EDX},
 	[CPUID_7_1_EAX]       = {         7, 1, CPUID_EAX},
+	[CPUID_12_EAX]        = {0x00000012, 0, CPUID_EAX},
 };

 /*
@@ -83,6 +102,25 @@ static __always_inline void reverse_cpuid_check(unsigned int x86_leaf)
 	BUILD_BUG_ON(reverse_cpuid[x86_leaf].function == 0);
 }

+/*
+ * A handful of feature bits are scattered in the kernel's cpufeatures word,
+ * translate them to KVM features that align with the hardware definitions.
+ */
+static __always_inline u32 __feature_translate(int x86_feature)
+{
+	if (x86_feature == X86_FEATURE_SGX1)
+		return __X86_FEATURE_SGX1;
+	else if (x86_feature == X86_FEATURE_SGX2)
+		return __X86_FEATURE_SGX2;
+
+	return x86_feature;
+}
+
+static __always_inline u32 __feature_leaf(int x86_feature)
+{
+	return __feature_translate(x86_feature) / 32;
+}
+
 /*
  * Retrieve the bit mask from an X86_FEATURE_* definition.  Features contain
  * the hardware defined bit number (stored in bits 4:0) and a software defined
@@ -91,6 +129,8 @@ static __always_inline void reverse_cpuid_check(unsigned int x86_leaf)
  */
 static __always_inline u32 __feature_bit(int x86_feature)
 {
+	x86_feature = __feature_translate(x86_feature);
+
 	reverse_cpuid_check(x86_feature / 32);
 	return 1 << (x86_feature & 31);
 }
@@ -99,7 +139,7 @@ static __always_inline u32 __feature_bit(int x86_feature)

 static __always_inline struct cpuid_reg x86_feature_cpuid(unsigned int x86_feature)
 {
-	unsigned int x86_leaf = x86_feature / 32;
+	unsigned int x86_leaf = __feature_leaf(x86_feature);

 	reverse_cpuid_check(x86_leaf);
 	return reverse_cpuid[x86_leaf];
@@ -291,7 +331,7 @@ static inline bool cpuid_fault_enabled(struct kvm_vcpu *vcpu)

 static __always_inline void kvm_cpu_cap_clear(unsigned int x86_feature)
 {
-	unsigned int x86_leaf = x86_feature / 32;
+	unsigned int x86_leaf = __feature_leaf(x86_feature);

 	reverse_cpuid_check(x86_leaf);
 	kvm_cpu_caps[x86_leaf] &= ~__feature_bit(x86_feature);
@@ -299,7 +339,7 @@ static __always_inline void kvm_cpu_cap_clear(unsigned int x86_feature)

 static __always_inline void kvm_cpu_cap_set(unsigned int x86_feature)
 {
-	unsigned int x86_leaf = x86_feature / 32;
+	unsigned int x86_leaf = __feature_leaf(x86_feature);

 	reverse_cpuid_check(x86_leaf);
 	kvm_cpu_caps[x86_leaf] |= __feature_bit(x86_feature);
@@ -307,7 +347,7 @@ static __always_inline void kvm_cpu_cap_set(unsigned int x86_feature)

 static __always_inline u32 kvm_cpu_cap_get(unsigned int x86_feature)
 {
-	unsigned int x86_leaf = x86_feature / 32;
+	unsigned int x86_leaf = __feature_leaf(x86_feature);

 	reverse_cpuid_check(x86_leaf);
 	return kvm_cpu_caps[x86_leaf] & __feature_bit(x86_feature);
--
2.30.0.284.gd98b1dd5eaa7-goog

