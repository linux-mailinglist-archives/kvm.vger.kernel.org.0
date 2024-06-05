Return-Path: <kvm+bounces-18960-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FE6B8FDA43
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 01:19:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DBDB21F25193
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 23:19:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69EF8168C35;
	Wed,  5 Jun 2024 23:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="y/5Qh6xN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E821667D6
	for <kvm@vger.kernel.org>; Wed,  5 Jun 2024 23:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717629566; cv=none; b=OH+eWrNJv8VL2IgZZu48q4Qqfl/7oCB/m4PM0GuJ1ZZNaNKNtbj5MQwuHvjG0plqvGoF3+QwEjgNomNmQeLcd7kYiHXyG7cmEUB0RHTVBaKaS7xOTSPCmji2VS1yUEP99thHOyB3v7x54O69Tag1d3KF0e73jaZRZE9jOwqcTNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717629566; c=relaxed/simple;
	bh=KZVWBgVm+CoCy+mG92mANe4J3jeidmvuMbYAybvIczw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qYCaSwAWOGAOSjOwo15dq3Qq+gV+DT3/RP9Fodc7dRXfZR+UkA/r5ClaeA895QXq5tVkDuJx7SpTYe2xRro+q/vMQM/B0jcvVmbHsV3D437oD662D7Y2F9AKki8Lo5/+StvZzZ1Vn1vcG+3+vYEr8dw+EuYevERMOjkZArWEvG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=y/5Qh6xN; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-627e7f0ca54so5423417b3.3
        for <kvm@vger.kernel.org>; Wed, 05 Jun 2024 16:19:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717629564; x=1718234364; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=vvPc1pSLCjHLrclONtENlA0BfdAfFhbhl4BmiE6e03E=;
        b=y/5Qh6xNCCnYjOh6iKqtxY8Fvl1LjNpzqV/BIG/T+mRlRvJu1+VP0a0dF53qClgGf6
         fpWD7L4NnDrWmES+mx6JDis9TTPBm27xQVlUc2vx5iCE2E6Feh5oJLItZs8aP5b3IECl
         xoNH/w90llIqVDISb+DegBRvUz8NTuFoGQKXL6bT5C/FeF6rG9SUSgCuOnue2iVCWocr
         g6iGbRE/KQbDUP2nE/MgVXG+0akVMTOOvETZVRWSE3DT2nFS3zOU/prQK9IJTvODoI7Z
         haA64dYzzhBZUL86zgVbjI8rwCOYR7jzIMZZPvR6ERl3CZD+L2HLuW3zmeh2iiK3Dv1R
         49Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717629564; x=1718234364;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vvPc1pSLCjHLrclONtENlA0BfdAfFhbhl4BmiE6e03E=;
        b=hCsq60HB6Pum2m7oSfc8yyCNn6aZqm8GBMLQSlfD2GzrlYjgl7I/ZESzB7IbrAq4oX
         rdUB6MhZQjcvF+bJa/s48ohhJ/AkwI42dVkwBZY/BxrJSH1eSiPNAJKsw7RBr31l+oDx
         0Qm4R9yqHxjFe3ZXYulLw9xbILDWGY5XbgpebixDROs4SbIjl2CUqDBNwAIU2YujewbL
         GXS6ryfmZDmZTuHXPOj3tt3RKGf38XoTVuEW1cJdI2L6o+6EFVy9u7T8eDQ3z5B6yknk
         K6SDlPf5LGQrcAOZa8lYa/C0fk6cFXSvxubPfMEEXV4HPrlgSEdSC+gpD+uuCYNomGKW
         XY5g==
X-Forwarded-Encrypted: i=1; AJvYcCVo8Fk+orMxKdtlUCyy8reJvQd7chCZ+sl+sIF7c0U5Hr4p93fWRZptUS1lIypNjGX4BUTfGL25HHFb/8L8g3TetcOF
X-Gm-Message-State: AOJu0YzU8bQmRpCBnv2Ts1ZyEafP75a5x50a6czg0eYfZUc/CR13tm6F
	AEHW4C1LGDOSFNBtk4UM9qQ2RKg+hJhfpHq8uTIH0zrCI+vWKG+u/IbiSBoDglVJdtpYEsCVH0g
	VAA==
X-Google-Smtp-Source: AGHT+IGrUaoiWnAsMmJQulI1tZsuHcHEgbkRQ0IFiQ5e3Jr9zXTeKx2KPl9xfXoVkzW4PpCZhjlQYQ8r3sw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:6808:b0:61a:bda3:a78c with SMTP id
 00721157ae682-62cbb3004camr9862417b3.0.1717629563976; Wed, 05 Jun 2024
 16:19:23 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  5 Jun 2024 16:19:09 -0700
In-Reply-To: <20240605231918.2915961-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240605231918.2915961-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.1.467.gbab1589fc0-goog
Message-ID: <20240605231918.2915961-2-seanjc@google.com>
Subject: [PATCH v8 01/10] x86/cpu: KVM: Add common defines for architectural
 memory types (PAT, MTRRs, etc.)
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Kai Huang <kai.huang@intel.com>, 
	Jim Mattson <jmattson@google.com>, Shan Kang <shan.kang@intel.com>, Xin Li <xin3.li@intel.com>, 
	Zhao Liu <zhao1.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"

Add defines for the architectural memory types that can be shoved into
various MSRs and registers, e.g. MTRRs, PAT, VMX capabilities MSRs, EPTPs,
etc.  While most MSRs/registers support only a subset of all memory types,
the values themselves are architectural and identical across all users.

Leave the goofy MTRR_TYPE_* definitions as-is since they are in a uapi
header, but add compile-time assertions to connect the dots (and sanity
check that the msr-index.h values didn't get fat-fingered).

Keep the VMX_EPTP_MT_* defines so that it's slightly more obvious that the
EPTP holds a single memory type in 3 of its 64 bits; those bits just
happen to be 2:0, i.e. don't need to be shifted.

Opportunistically use X86_MEMTYPE_WB instead of an open coded '6' in
setup_vmcs_config().

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/msr-index.h | 15 ++++++++++++++-
 arch/x86/include/asm/vmx.h       |  5 +++--
 arch/x86/kernel/cpu/mtrr/mtrr.c  |  6 ++++++
 arch/x86/kvm/vmx/nested.c        |  2 +-
 arch/x86/kvm/vmx/vmx.c           |  2 +-
 arch/x86/mm/pat/memtype.c        | 33 ++++++++++++--------------------
 6 files changed, 37 insertions(+), 26 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index e022e6eb766c..1978ba0adb49 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -36,6 +36,20 @@
 #define EFER_FFXSR		(1<<_EFER_FFXSR)
 #define EFER_AUTOIBRS		(1<<_EFER_AUTOIBRS)
 
+/*
+ * Architectural memory types that are common to MTRRs, PAT, VMX MSRs, etc.
+ * Most MSRs support/allow only a subset of memory types, but the values
+ * themselves are common across all relevant MSRs.
+ */
+#define X86_MEMTYPE_UC		0ull	/* Uncacheable, a.k.a. Strong Uncacheable */
+#define X86_MEMTYPE_WC		1ull	/* Write Combining */
+/* RESERVED			2 */
+/* RESERVED			3 */
+#define X86_MEMTYPE_WT		4ull	/* Write Through */
+#define X86_MEMTYPE_WP		5ull	/* Write Protected */
+#define X86_MEMTYPE_WB		6ull	/* Write Back */
+#define X86_MEMTYPE_UC_MINUS	7ull	/* Weak Uncacheabled (PAT only) */
+
 /* FRED MSRs */
 #define MSR_IA32_FRED_RSP0	0x1cc			/* Level 0 stack pointer */
 #define MSR_IA32_FRED_RSP1	0x1cd			/* Level 1 stack pointer */
@@ -1153,7 +1167,6 @@
 #define VMX_BASIC_64		0x0001000000000000LLU
 #define VMX_BASIC_MEM_TYPE_SHIFT	50
 #define VMX_BASIC_MEM_TYPE_MASK	0x003c000000000000LLU
-#define VMX_BASIC_MEM_TYPE_WB	6LLU
 #define VMX_BASIC_INOUT		0x0040000000000000LLU
 
 /* Resctrl MSRs: */
diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index d77a31039f24..e531d8d80a11 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -508,9 +508,10 @@ enum vmcs_field {
 #define VMX_EPTP_PWL_4				0x18ull
 #define VMX_EPTP_PWL_5				0x20ull
 #define VMX_EPTP_AD_ENABLE_BIT			(1ull << 6)
+/* The EPTP memtype is encoded in bits 2:0, i.e. doesn't need to be shifted. */
 #define VMX_EPTP_MT_MASK			0x7ull
-#define VMX_EPTP_MT_WB				0x6ull
-#define VMX_EPTP_MT_UC				0x0ull
+#define VMX_EPTP_MT_WB				X86_MEMTYPE_WB
+#define VMX_EPTP_MT_UC				X86_MEMTYPE_UC
 #define VMX_EPT_READABLE_MASK			0x1ull
 #define VMX_EPT_WRITABLE_MASK			0x2ull
 #define VMX_EPT_EXECUTABLE_MASK			0x4ull
diff --git a/arch/x86/kernel/cpu/mtrr/mtrr.c b/arch/x86/kernel/cpu/mtrr/mtrr.c
index 767bf1c71aad..125e36010b82 100644
--- a/arch/x86/kernel/cpu/mtrr/mtrr.c
+++ b/arch/x86/kernel/cpu/mtrr/mtrr.c
@@ -55,6 +55,12 @@
 
 #include "mtrr.h"
 
+static_assert(X86_MEMTYPE_UC == MTRR_TYPE_UNCACHABLE);
+static_assert(X86_MEMTYPE_WC == MTRR_TYPE_WRCOMB);
+static_assert(X86_MEMTYPE_WT == MTRR_TYPE_WRTHROUGH);
+static_assert(X86_MEMTYPE_WP == MTRR_TYPE_WRPROT);
+static_assert(X86_MEMTYPE_WB == MTRR_TYPE_WRBACK);
+
 /* arch_phys_wc_add returns an MTRR register index plus this offset. */
 #define MTRR_TO_PHYS_WC_OFFSET 1000
 
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 75b4f41d9926..3bd6c026f192 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -7033,7 +7033,7 @@ static void nested_vmx_setup_basic(struct nested_vmx_msrs *msrs)
 		VMCS12_REVISION |
 		VMX_BASIC_TRUE_CTLS |
 		((u64)VMCS12_SIZE << VMX_BASIC_VMCS_SIZE_SHIFT) |
-		(VMX_BASIC_MEM_TYPE_WB << VMX_BASIC_MEM_TYPE_SHIFT);
+		(X86_MEMTYPE_WB << VMX_BASIC_MEM_TYPE_SHIFT);
 
 	if (cpu_has_vmx_basic_inout())
 		msrs->basic |= VMX_BASIC_INOUT;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0e3aaf520db2..e495a8b28314 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2711,7 +2711,7 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 #endif
 
 	/* Require Write-Back (WB) memory type for VMCS accesses. */
-	if (((vmx_msr_high >> 18) & 15) != 6)
+	if (((vmx_msr_high >> 18) & 15) != X86_MEMTYPE_WB)
 		return -EIO;
 
 	rdmsrl(MSR_IA32_VMX_MISC, misc_msr);
diff --git a/arch/x86/mm/pat/memtype.c b/arch/x86/mm/pat/memtype.c
index bdc2a240c2aa..15b888ebaf17 100644
--- a/arch/x86/mm/pat/memtype.c
+++ b/arch/x86/mm/pat/memtype.c
@@ -176,15 +176,6 @@ static inline void set_page_memtype(struct page *pg,
 }
 #endif
 
-enum {
-	PAT_UC = 0,		/* uncached */
-	PAT_WC = 1,		/* Write combining */
-	PAT_WT = 4,		/* Write Through */
-	PAT_WP = 5,		/* Write Protected */
-	PAT_WB = 6,		/* Write Back (default) */
-	PAT_UC_MINUS = 7,	/* UC, but can be overridden by MTRR */
-};
-
 #define CM(c) (_PAGE_CACHE_MODE_ ## c)
 
 static enum page_cache_mode __init pat_get_cache_mode(unsigned int pat_val,
@@ -194,13 +185,13 @@ static enum page_cache_mode __init pat_get_cache_mode(unsigned int pat_val,
 	char *cache_mode;
 
 	switch (pat_val) {
-	case PAT_UC:       cache = CM(UC);       cache_mode = "UC  "; break;
-	case PAT_WC:       cache = CM(WC);       cache_mode = "WC  "; break;
-	case PAT_WT:       cache = CM(WT);       cache_mode = "WT  "; break;
-	case PAT_WP:       cache = CM(WP);       cache_mode = "WP  "; break;
-	case PAT_WB:       cache = CM(WB);       cache_mode = "WB  "; break;
-	case PAT_UC_MINUS: cache = CM(UC_MINUS); cache_mode = "UC- "; break;
-	default:           cache = CM(WB);       cache_mode = "WB  "; break;
+	case X86_MEMTYPE_UC:       cache = CM(UC);       cache_mode = "UC  "; break;
+	case X86_MEMTYPE_WC:       cache = CM(WC);       cache_mode = "WC  "; break;
+	case X86_MEMTYPE_WT:       cache = CM(WT);       cache_mode = "WT  "; break;
+	case X86_MEMTYPE_WP:       cache = CM(WP);       cache_mode = "WP  "; break;
+	case X86_MEMTYPE_WB:       cache = CM(WB);       cache_mode = "WB  "; break;
+	case X86_MEMTYPE_UC_MINUS: cache = CM(UC_MINUS); cache_mode = "UC- "; break;
+	default:                   cache = CM(WB);       cache_mode = "WB  "; break;
 	}
 
 	memcpy(msg, cache_mode, 4);
@@ -257,11 +248,11 @@ void pat_cpu_init(void)
 void __init pat_bp_init(void)
 {
 	struct cpuinfo_x86 *c = &boot_cpu_data;
-#define PAT(p0, p1, p2, p3, p4, p5, p6, p7)			\
-	(((u64)PAT_ ## p0) | ((u64)PAT_ ## p1 << 8) |		\
-	((u64)PAT_ ## p2 << 16) | ((u64)PAT_ ## p3 << 24) |	\
-	((u64)PAT_ ## p4 << 32) | ((u64)PAT_ ## p5 << 40) |	\
-	((u64)PAT_ ## p6 << 48) | ((u64)PAT_ ## p7 << 56))
+#define PAT(p0, p1, p2, p3, p4, p5, p6, p7)				\
+	((X86_MEMTYPE_ ## p0)      | (X86_MEMTYPE_ ## p1 << 8)  |	\
+	(X86_MEMTYPE_ ## p2 << 16) | (X86_MEMTYPE_ ## p3 << 24) |	\
+	(X86_MEMTYPE_ ## p4 << 32) | (X86_MEMTYPE_ ## p5 << 40) |	\
+	(X86_MEMTYPE_ ## p6 << 48) | (X86_MEMTYPE_ ## p7 << 56))
 
 
 	if (!IS_ENABLED(CONFIG_X86_PAT))
-- 
2.45.1.467.gbab1589fc0-goog


