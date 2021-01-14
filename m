Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31EE32F5678
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 02:58:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728412AbhANBsX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 20:48:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727153AbhANAjv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jan 2021 19:39:51 -0500
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64A88C0617A7
        for <kvm@vger.kernel.org>; Wed, 13 Jan 2021 16:37:45 -0800 (PST)
Received: by mail-qt1-x84a.google.com with SMTP id b11so2970418qtj.11
        for <kvm@vger.kernel.org>; Wed, 13 Jan 2021 16:37:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=Cnc0lgQscc6cmGJmpq+PiVOdWNnTD3AWpalFSPCSq8A=;
        b=mnGUuR+Af6UCiQ6G+/GYDXzP8oP63daouHXe/t8kMbvw5CZVl2w7nHmw3owPkq1xNT
         jHDQiY8Tk7m0+6Dmmrs2/8y3nBiIaRaMB316ZIzOEH+SXGVPMf93ZIFJGcIya6r4JHrc
         zLOkwgl30PWFNH1b9aOmUvWFi3LZudsqcenrAJTbw/nGyBrcg+U7nId1oCHBahtF44K7
         dHh1pa9qYWmsHatiPKg8pcj+3/v6ortUA1Wl3uE0OIFEBFMJLgAt/m8AdK8JhVAE81E6
         E3YXdfIP4d1Pxo3NkRfDz3xUU6bY4s2W1wpzndixX12OMw1ZXuD7ZwensYQ+Nz8asSQm
         bMRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=Cnc0lgQscc6cmGJmpq+PiVOdWNnTD3AWpalFSPCSq8A=;
        b=cADrmuKOp/24NpISMrPoiC4HbVRhIYx1saiZ2H+cSQNhYuxW+2M+BjK5xmw3+NsuNv
         C01fCQKb9NuBORBiDtVmT2ofrG4IWOQ19aQXdjmjRngk0yRKyopghQYNyrfpI2DaMAUk
         1Ts5R6ijqWg/xN/CZsuaNBExRi8hmVDPrjNHmiZraSI7496+uy4ZZT+j4k2hJuRiOfM0
         f/zO5HbZQn30/7NbWSPkfQbYIcRLpCbQbMORsn0N4QAMHe51Z2PYYEdag+kY79G29vGT
         tBDyLq9xgxCTnGh6jKitT6dM8nHiA3C/p6vO2AIXGjz/kCy2bk4Y8pSpSeA1u0Y4J3Oa
         20aw==
X-Gm-Message-State: AOAM531WmSQgPlGZw7eN1dpVgYYhpD5tkZVmpRBFJ9b67CkmO93SE3TA
        AvBgMjKMO3nPbV9xFLkJxMXHFQDumj0=
X-Google-Smtp-Source: ABdhPJzvYn9yd07lOsIKxR7vaVU8GYdd1cf2sY7HOxDK7dxEdofrZ5hL/NVXwtGmQASsTINeP7WDGrlE9ik=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
 (user=seanjc job=sendgmr) by 2002:a0c:fdec:: with SMTP id m12mr4701814qvu.11.1610584664451;
 Wed, 13 Jan 2021 16:37:44 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 13 Jan 2021 16:36:58 -0800
In-Reply-To: <20210114003708.3798992-1-seanjc@google.com>
Message-Id: <20210114003708.3798992-5-seanjc@google.com>
Mime-Version: 1.0
References: <20210114003708.3798992-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [PATCH v2 04/14] x86/cpufeatures: Assign dedicated feature word for
 AMD mem encryption
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Collect the scattered SME/SEV related feature flags into a dedicated
word.  There are now five recognized features in CPUID.0x8000001F.EAX,
with at least one more on the horizon (SEV-SNP).  Using a dedicated word
allows KVM to use its automagic CPUID adjustment logic when reporting
the set of supported features to userspace.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/cpufeature.h              |  7 +++++--
 arch/x86/include/asm/cpufeatures.h             | 17 +++++++++++------
 arch/x86/include/asm/disabled-features.h       |  3 ++-
 arch/x86/include/asm/required-features.h       |  3 ++-
 arch/x86/kernel/cpu/common.c                   |  3 +++
 arch/x86/kernel/cpu/scattered.c                |  5 -----
 tools/arch/x86/include/asm/disabled-features.h |  3 ++-
 tools/arch/x86/include/asm/required-features.h |  3 ++-
 8 files changed, 27 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 59bf91c57aa8..1728d4ce5730 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -30,6 +30,7 @@ enum cpuid_leafs
 	CPUID_7_ECX,
 	CPUID_8000_0007_EBX,
 	CPUID_7_EDX,
+	CPUID_8000_001F_EAX,
 };
 
 #ifdef CONFIG_X86_FEATURE_NAMES
@@ -88,8 +89,9 @@ extern const char * const x86_bug_flags[NBUGINTS*32];
 	   CHECK_BIT_IN_MASK_WORD(REQUIRED_MASK, 16, feature_bit) ||	\
 	   CHECK_BIT_IN_MASK_WORD(REQUIRED_MASK, 17, feature_bit) ||	\
 	   CHECK_BIT_IN_MASK_WORD(REQUIRED_MASK, 18, feature_bit) ||	\
+	   CHECK_BIT_IN_MASK_WORD(REQUIRED_MASK, 19, feature_bit) ||	\
 	   REQUIRED_MASK_CHECK					  ||	\
-	   BUILD_BUG_ON_ZERO(NCAPINTS != 19))
+	   BUILD_BUG_ON_ZERO(NCAPINTS != 20))
 
 #define DISABLED_MASK_BIT_SET(feature_bit)				\
 	 ( CHECK_BIT_IN_MASK_WORD(DISABLED_MASK,  0, feature_bit) ||	\
@@ -111,8 +113,9 @@ extern const char * const x86_bug_flags[NBUGINTS*32];
 	   CHECK_BIT_IN_MASK_WORD(DISABLED_MASK, 16, feature_bit) ||	\
 	   CHECK_BIT_IN_MASK_WORD(DISABLED_MASK, 17, feature_bit) ||	\
 	   CHECK_BIT_IN_MASK_WORD(DISABLED_MASK, 18, feature_bit) ||	\
+	   CHECK_BIT_IN_MASK_WORD(DISABLED_MASK, 19, feature_bit) ||	\
 	   DISABLED_MASK_CHECK					  ||	\
-	   BUILD_BUG_ON_ZERO(NCAPINTS != 19))
+	   BUILD_BUG_ON_ZERO(NCAPINTS != 20))
 
 #define cpu_has(c, bit)							\
 	(__builtin_constant_p(bit) && REQUIRED_MASK_BIT_SET(bit) ? 1 :	\
diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 9f9e9511f7cd..7c0bb1a20050 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -13,7 +13,7 @@
 /*
  * Defines x86 CPU feature bits
  */
-#define NCAPINTS			19	   /* N 32-bit words worth of info */
+#define NCAPINTS			20	   /* N 32-bit words worth of info */
 #define NBUGINTS			1	   /* N 32-bit bug flags */
 
 /*
@@ -96,7 +96,7 @@
 #define X86_FEATURE_SYSCALL32		( 3*32+14) /* "" syscall in IA32 userspace */
 #define X86_FEATURE_SYSENTER32		( 3*32+15) /* "" sysenter in IA32 userspace */
 #define X86_FEATURE_REP_GOOD		( 3*32+16) /* REP microcode works well */
-#define X86_FEATURE_SME_COHERENT	( 3*32+17) /* "" AMD hardware-enforced cache coherency */
+/* FREE!                                ( 3*32+17) */
 #define X86_FEATURE_LFENCE_RDTSC	( 3*32+18) /* "" LFENCE synchronizes RDTSC */
 #define X86_FEATURE_ACC_POWER		( 3*32+19) /* AMD Accumulated Power Mechanism */
 #define X86_FEATURE_NOPL		( 3*32+20) /* The NOPL (0F 1F) instructions */
@@ -201,7 +201,7 @@
 #define X86_FEATURE_INVPCID_SINGLE	( 7*32+ 7) /* Effectively INVPCID && CR4.PCIDE=1 */
 #define X86_FEATURE_HW_PSTATE		( 7*32+ 8) /* AMD HW-PState */
 #define X86_FEATURE_PROC_FEEDBACK	( 7*32+ 9) /* AMD ProcFeedbackInterface */
-#define X86_FEATURE_SME			( 7*32+10) /* AMD Secure Memory Encryption */
+/* FREE!                                ( 7*32+10) */
 #define X86_FEATURE_PTI			( 7*32+11) /* Kernel Page Table Isolation enabled */
 #define X86_FEATURE_RETPOLINE		( 7*32+12) /* "" Generic Retpoline mitigation for Spectre variant 2 */
 #define X86_FEATURE_RETPOLINE_AMD	( 7*32+13) /* "" AMD Retpoline mitigation for Spectre variant 2 */
@@ -211,7 +211,7 @@
 #define X86_FEATURE_SSBD		( 7*32+17) /* Speculative Store Bypass Disable */
 #define X86_FEATURE_MBA			( 7*32+18) /* Memory Bandwidth Allocation */
 #define X86_FEATURE_RSB_CTXSW		( 7*32+19) /* "" Fill RSB on context switches */
-#define X86_FEATURE_SEV			( 7*32+20) /* AMD Secure Encrypted Virtualization */
+/* FREE!                                ( 7*32+20) */
 #define X86_FEATURE_USE_IBPB		( 7*32+21) /* "" Indirect Branch Prediction Barrier enabled */
 #define X86_FEATURE_USE_IBRS_FW		( 7*32+22) /* "" Use IBRS during runtime firmware calls */
 #define X86_FEATURE_SPEC_STORE_BYPASS_DISABLE	( 7*32+23) /* "" Disable Speculative Store Bypass. */
@@ -236,8 +236,6 @@
 #define X86_FEATURE_EPT_AD		( 8*32+17) /* Intel Extended Page Table access-dirty bit */
 #define X86_FEATURE_VMCALL		( 8*32+18) /* "" Hypervisor supports the VMCALL instruction */
 #define X86_FEATURE_VMW_VMMCALL		( 8*32+19) /* "" VMware prefers VMMCALL hypercall instruction */
-#define X86_FEATURE_SEV_ES		( 8*32+20) /* AMD Secure Encrypted Virtualization - Encrypted State */
-#define X86_FEATURE_VM_PAGE_FLUSH	( 8*32+21) /* "" VM Page Flush MSR is supported */
 
 /* Intel-defined CPU features, CPUID level 0x00000007:0 (EBX), word 9 */
 #define X86_FEATURE_FSGSBASE		( 9*32+ 0) /* RDFSBASE, WRFSBASE, RDGSBASE, WRGSBASE instructions*/
@@ -383,6 +381,13 @@
 #define X86_FEATURE_CORE_CAPABILITIES	(18*32+30) /* "" IA32_CORE_CAPABILITIES MSR */
 #define X86_FEATURE_SPEC_CTRL_SSBD	(18*32+31) /* "" Speculative Store Bypass Disable */
 
+/* AMD-defined memory encryption features, CPUID level 0x8000001f (EAX), word 19 */
+#define X86_FEATURE_SME			(19*32+ 0) /* AMD Secure Memory Encryption */
+#define X86_FEATURE_SEV			(19*32+ 1) /* AMD Secure Encrypted Virtualization */
+#define X86_FEATURE_VM_PAGE_FLUSH	(19*32+ 2) /* "" VM Page Flush MSR is supported */
+#define X86_FEATURE_SEV_ES		(19*32+ 3) /* AMD Secure Encrypted Virtualization - Encrypted State */
+#define X86_FEATURE_SME_COHERENT	(19*32+10) /* "" AMD hardware-enforced cache coherency */
+
 /*
  * BUG word(s)
  */
diff --git a/arch/x86/include/asm/disabled-features.h b/arch/x86/include/asm/disabled-features.h
index 5861d34f9771..2216077676c8 100644
--- a/arch/x86/include/asm/disabled-features.h
+++ b/arch/x86/include/asm/disabled-features.h
@@ -85,6 +85,7 @@
 			 DISABLE_ENQCMD)
 #define DISABLED_MASK17	0
 #define DISABLED_MASK18	0
-#define DISABLED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS != 19)
+#define DISABLED_MASK19	0
+#define DISABLED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS != 20)
 
 #endif /* _ASM_X86_DISABLED_FEATURES_H */
diff --git a/arch/x86/include/asm/required-features.h b/arch/x86/include/asm/required-features.h
index 3ff0d48469f2..b2d504f11937 100644
--- a/arch/x86/include/asm/required-features.h
+++ b/arch/x86/include/asm/required-features.h
@@ -101,6 +101,7 @@
 #define REQUIRED_MASK16	0
 #define REQUIRED_MASK17	0
 #define REQUIRED_MASK18	0
-#define REQUIRED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS != 19)
+#define REQUIRED_MASK19	0
+#define REQUIRED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS != 20)
 
 #endif /* _ASM_X86_REQUIRED_FEATURES_H */
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 35ad8480c464..9215b91bc044 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -960,6 +960,9 @@ void get_cpu_cap(struct cpuinfo_x86 *c)
 	if (c->extended_cpuid_level >= 0x8000000a)
 		c->x86_capability[CPUID_8000_000A_EDX] = cpuid_edx(0x8000000a);
 
+	if (c->extended_cpuid_level >= 0x8000001f)
+		c->x86_capability[CPUID_8000_001F_EAX] = cpuid_eax(0x8000001f);
+
 	init_scattered_cpuid_features(c);
 	init_speculation_control(c);
 
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
index 236924930bf0..972ec3bfa9c0 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -40,11 +40,6 @@ static const struct cpuid_bit cpuid_bits[] = {
 	{ X86_FEATURE_CPB,		CPUID_EDX,  9, 0x80000007, 0 },
 	{ X86_FEATURE_PROC_FEEDBACK,    CPUID_EDX, 11, 0x80000007, 0 },
 	{ X86_FEATURE_MBA,		CPUID_EBX,  6, 0x80000008, 0 },
-	{ X86_FEATURE_SME,		CPUID_EAX,  0, 0x8000001f, 0 },
-	{ X86_FEATURE_SEV,		CPUID_EAX,  1, 0x8000001f, 0 },
-	{ X86_FEATURE_SEV_ES,		CPUID_EAX,  3, 0x8000001f, 0 },
-	{ X86_FEATURE_SME_COHERENT,	CPUID_EAX, 10, 0x8000001f, 0 },
-	{ X86_FEATURE_VM_PAGE_FLUSH,	CPUID_EAX,  2, 0x8000001f, 0 },
 	{ 0, 0, 0, 0, 0 }
 };
 
diff --git a/tools/arch/x86/include/asm/disabled-features.h b/tools/arch/x86/include/asm/disabled-features.h
index 5861d34f9771..2216077676c8 100644
--- a/tools/arch/x86/include/asm/disabled-features.h
+++ b/tools/arch/x86/include/asm/disabled-features.h
@@ -85,6 +85,7 @@
 			 DISABLE_ENQCMD)
 #define DISABLED_MASK17	0
 #define DISABLED_MASK18	0
-#define DISABLED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS != 19)
+#define DISABLED_MASK19	0
+#define DISABLED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS != 20)
 
 #endif /* _ASM_X86_DISABLED_FEATURES_H */
diff --git a/tools/arch/x86/include/asm/required-features.h b/tools/arch/x86/include/asm/required-features.h
index 3ff0d48469f2..b2d504f11937 100644
--- a/tools/arch/x86/include/asm/required-features.h
+++ b/tools/arch/x86/include/asm/required-features.h
@@ -101,6 +101,7 @@
 #define REQUIRED_MASK16	0
 #define REQUIRED_MASK17	0
 #define REQUIRED_MASK18	0
-#define REQUIRED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS != 19)
+#define REQUIRED_MASK19	0
+#define REQUIRED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS != 20)
 
 #endif /* _ASM_X86_REQUIRED_FEATURES_H */
-- 
2.30.0.284.gd98b1dd5eaa7-goog

