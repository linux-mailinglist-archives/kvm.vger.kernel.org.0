Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B22262BD08
	for <lists+kvm@lfdr.de>; Wed, 16 Nov 2022 13:06:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233412AbiKPMGi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Nov 2022 07:06:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233036AbiKPMGH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Nov 2022 07:06:07 -0500
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCD89B1DA;
        Wed, 16 Nov 2022 03:59:50 -0800 (PST)
Received: from zn.tnic (p200300ea9733e74b329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e74b:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 5FBEC1EC032C;
        Wed, 16 Nov 2022 12:59:49 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1668599989;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=hJKof9wnh/Z0s3rCjN4QwsOtG6Nl0wGK7lB4XoziVvE=;
        b=SLdXhc3Ss5eT1lbfU5YcQyKqWJEOt+wwYoPV+OGNdSM6QsU84Lde9VpYVFV+S+wsA5ajq7
        d16FjMppb7sG03xasXlJCV5Jd97v85HMuTYo0ezrKK+BwMuOJl3NUJrNVc3F21sqzHkHes
        ebkVbaj9rSlpxXL180nTPdWifS9TKbg=
Date:   Wed, 16 Nov 2022 12:59:45 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Kim Phillips <kim.phillips@amd.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     x86@kernel.org, Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Juergen Gross <jgross@suse.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tony Luck <tony.luck@intel.com>,
        Babu Moger <Babu.Moger@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] x86/cpufeatures: Add support for cpuid leaf
 80000021/EAX (FeatureExt2Eax)
Message-ID: <Y3TQsUmTieC4NnO/@zn.tnic>
References: <20221104213651.141057-1-kim.phillips@amd.com>
 <20221104213651.141057-2-kim.phillips@amd.com>
 <Y2WIy2A1RuQE/9SK@zn.tnic>
 <c00b1a65-c885-c874-79cb-16011ac82eb3@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <c00b1a65-c885-c874-79cb-16011ac82eb3@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 15, 2022 at 05:10:50PM -0600, Kim Phillips wrote:
> When trying to wire up a scattered host AUTOIBRS version up to
> kvm, I couldn't get past all the reverse_cpuid_check()
> BUILD_BUGs demanding exclusivity between h/w and "Linux"
> (s/w) FEATUREs.

I guess something like below.

Sean, can you pls check the KVM bits whether I've done them all right?

In any case, it seems to work, guest has:

processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 25
model           : 1
model name      : AMD EPYC-Milan Processor
stepping        : 1
flags           : ... autoibrs ...

---
From: Borislav Petkov <bp@suse.de>
Date: Wed, 16 Nov 2022 12:50:08 +0100
Subject: [PATCH] x86/cpu, kvm: Add X86_FEATURE_AUTOIBRS

Add AMD AutoIBRS feature bit support. Use a synthetic bit as this is the
first bit from the 0x80000021 leaf.

Add the corresponding word to KVM's feature machinery so that the bit
gets advertized into the guest too.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/include/asm/cpufeatures.h |  1 +
 arch/x86/kernel/cpu/scattered.c    |  1 +
 arch/x86/kvm/cpuid.c               |  2 ++
 arch/x86/kvm/reverse_cpuid.h       | 18 ++++++++++++------
 4 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 2bc1557dc203..2cf102911241 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -306,6 +306,7 @@
 #define X86_FEATURE_RSB_VMEXIT_LITE	(11*32+17) /* "" Fill RSB on VM exit when EIBRS is enabled */
 #define X86_FEATURE_SGX_EDECCSSA	(11*32+18) /* "" SGX EDECCSSA user leaf function */
 #define X86_FEATURE_CALL_DEPTH		(11*32+19) /* "" Call depth tracking for RSB stuffing */
+#define X86_FEATURE_AUTOIBRS		(11*32+20) /* AMD Automatic IBRS */
 
 /* Intel-defined CPU features, CPUID level 0x00000007:1 (EAX), word 12 */
 #define X86_FEATURE_AVX_VNNI		(12*32+ 4) /* AVX VNNI instructions */
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
index f53944fb8f7f..e20117658c5b 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -45,6 +45,7 @@ static const struct cpuid_bit cpuid_bits[] = {
 	{ X86_FEATURE_CPB,		CPUID_EDX,  9, 0x80000007, 0 },
 	{ X86_FEATURE_PROC_FEEDBACK,    CPUID_EDX, 11, 0x80000007, 0 },
 	{ X86_FEATURE_MBA,		CPUID_EBX,  6, 0x80000008, 0 },
+	{ X86_FEATURE_AUTOIBRS,		CPUID_EAX,  8, 0x80000021, 0 },
 	{ X86_FEATURE_PERFMON_V2,	CPUID_EAX,  0, 0x80000022, 0 },
 	{ X86_FEATURE_AMD_LBR_V2,	CPUID_EAX,  1, 0x80000022, 0 },
 	{ 0, 0, 0, 0, 0 }
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index c92c49a0b35b..050bca360731 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -750,6 +750,8 @@ void kvm_set_cpu_caps(void)
 		kvm_cpu_cap_clear(X86_FEATURE_RDTSCP);
 		kvm_cpu_cap_clear(X86_FEATURE_RDPID);
 	}
+
+	kvm_cpu_cap_init_scattered(CPUID_8000_0021_EAX, SF(AUTOIBRS));
 }
 EXPORT_SYMBOL_GPL(kvm_set_cpu_caps);
 
diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
index 4e5b8444f161..c4801ac84a4a 100644
--- a/arch/x86/kvm/reverse_cpuid.h
+++ b/arch/x86/kvm/reverse_cpuid.h
@@ -13,6 +13,7 @@
  */
 enum kvm_only_cpuid_leafs {
 	CPUID_12_EAX	 = NCAPINTS,
+	CPUID_8000_0021_EAX,
 	NR_KVM_CPU_CAPS,
 
 	NKVMCAPINTS = NR_KVM_CPU_CAPS - NCAPINTS,
@@ -25,6 +26,9 @@ enum kvm_only_cpuid_leafs {
 #define KVM_X86_FEATURE_SGX2		KVM_X86_FEATURE(CPUID_12_EAX, 1)
 #define KVM_X86_FEATURE_SGX_EDECCSSA	KVM_X86_FEATURE(CPUID_12_EAX, 11)
 
+/* AMD-defined Extended Feature 2 EAX, CPUID level 0x80000021 (EAX) */
+#define KVM_X86_FEATURE_AUTOIBRS	KVM_X86_FEATURE(CPUID_8000_0021_EAX, 8)
+
 struct cpuid_reg {
 	u32 function;
 	u32 index;
@@ -49,6 +53,7 @@ static const struct cpuid_reg reverse_cpuid[] = {
 	[CPUID_7_1_EAX]       = {         7, 1, CPUID_EAX},
 	[CPUID_12_EAX]        = {0x00000012, 0, CPUID_EAX},
 	[CPUID_8000_001F_EAX] = {0x8000001f, 0, CPUID_EAX},
+	[CPUID_8000_0021_EAX] = {0x80000021, 0, CPUID_EAX},
 };
 
 /*
@@ -75,12 +80,13 @@ static __always_inline void reverse_cpuid_check(unsigned int x86_leaf)
  */
 static __always_inline u32 __feature_translate(int x86_feature)
 {
-	if (x86_feature == X86_FEATURE_SGX1)
-		return KVM_X86_FEATURE_SGX1;
-	else if (x86_feature == X86_FEATURE_SGX2)
-		return KVM_X86_FEATURE_SGX2;
-	else if (x86_feature == X86_FEATURE_SGX_EDECCSSA)
-		return KVM_X86_FEATURE_SGX_EDECCSSA;
+	switch (x86_feature) {
+	case X86_FEATURE_SGX1:		return KVM_X86_FEATURE_SGX1;
+	case X86_FEATURE_SGX2:		return KVM_X86_FEATURE_SGX2;
+	case X86_FEATURE_SGX_EDECCSSA:	return KVM_X86_FEATURE_SGX_EDECCSSA;
+	case X86_FEATURE_AUTOIBRS:	return KVM_X86_FEATURE_AUTOIBRS;
+	default: break;
+	}
 
 	return x86_feature;
 }
-- 
2.35.1

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
