Return-Path: <kvm+bounces-11427-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8983E876E84
	for <lists+kvm@lfdr.de>; Sat,  9 Mar 2024 02:28:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 097872843AE
	for <lists+kvm@lfdr.de>; Sat,  9 Mar 2024 01:28:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46DEE22F1E;
	Sat,  9 Mar 2024 01:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zvlTCoei"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B34091096F
	for <kvm@vger.kernel.org>; Sat,  9 Mar 2024 01:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709947655; cv=none; b=QLdnaj16ASeP9kggW+Y8OwHy2UW83CD7zZMXumZqgx8OhRgTA/t9/pWhPzRYA0vD6NQdBpa9aM6LLUTSI/iurWVWgE0bXGssYMmlY6dScnpZG+kvKyXFEYQ+ZPeeUkCTrb/LGBbh0VwC98ecdxitGYaaeucPfXyZY6+UJ2pOUUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709947655; c=relaxed/simple;
	bh=pSKQNm5JvNwxiEm9TrDvsr+6vXSmj4xUeeMJYJlK4/0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZaZ3cBvsZ6ClwZHd33axEYR6cnF/JjA1VBeawHj1NmZNJYFRmc2mBIjZmClze4UPIvSheXP90vnNFS9pTZh2Tg2XTFtlS0fHaGkEKvt4VE2s5mQ1qrOcokE2hByxbF/pg2Wmyeh4UpnsXc6LprKL+B/80yKv9+dzVhrn6BdMQAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zvlTCoei; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-60a0890f2cdso16924717b3.1
        for <kvm@vger.kernel.org>; Fri, 08 Mar 2024 17:27:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709947653; x=1710552453; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=EaBCMidXAkgUGM8CxSfXfUhRT077xv0MmYJnGKo2lwk=;
        b=zvlTCoeiFrJkV81ymSGjQ/gtJ1ZNhPXFfRaAgG4SD6pib8VRDxpNy99RLk48A94G1i
         H5xqVfFStXlo0uApFPkhekFN1aiiLjBMs2mVT1qOULEIPZYBYYizLHPQyVrk8P/7tgJh
         s/RE1qYRZ4DXO7jc0BaMN7OhctKxuBAe3NusOTOI0I4J+/B+mBXIuRtuof2GxAd9o9Bf
         5QHJvBisj6DloAIiR8LSMwLdfOSXIhpUmMJnGGfUsXTEl1OzSRZL8U1HDoEjvP3y+nGv
         3meDgiAu3fmklRH7tufq5YO+WiFbagQwuq4JtuL+W1yzjP5X61oou4B2AwLYJPc3mPqU
         pE5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709947653; x=1710552453;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EaBCMidXAkgUGM8CxSfXfUhRT077xv0MmYJnGKo2lwk=;
        b=dMvgHU4ASKU/eUaaxYzXokDGhBDOz/yFhI57ZE6MpWufI6uFYwsJZZPKNfu6lGvTXH
         PgYSvtc7akOWCz9dV34JSyiV5CNQbjcQfCrpCG0N7gt3W78B5d52LJJdvzu1RGobSpbQ
         VhlBnDNJ5BmjOf3BmxiSsJnKN3InBxvegwpM0FpjmJ8jC5Ae1k8DQXZgTQNfcjZegIHB
         w6doW/+Lqa9lf85ZiApfbC/uyAfUZ3ZcsewTX9GE8EG+eigXNtKrUUNzhWm231PpWYcH
         x51pO93BB21VlfNfuQoLCuBuf/UYA/0aX6bIGHwegVO26MCpuqH/YswR65CNcnfNRj2u
         MIGA==
X-Forwarded-Encrypted: i=1; AJvYcCUTQot0a5uPlG5/BrifjNSDzUeFDbLDe3fAmYHt8Jj0pQ6rVEbKYaUEG7PmfLxPsbcIJm2unfDwWeyfPzcK8kIdVsQx
X-Gm-Message-State: AOJu0Yy31yP/dHOJa3gvr2R4lH36lsJAANHNOmLjyP9jgMxbp3frzSET
	3Wy+4n9brvT7dSb3J4WOJURHt+P9UiMAMAKXq4BMadDgqzSoJBYemVrFoutc5s/YYTjfv/OgT2J
	CfQ==
X-Google-Smtp-Source: AGHT+IGJKBjd+vklKwLu3ypQCI2MgbZgIC4pHjjoZgBjV4khc/YSZk3awEL+tQe1YSQxZ3H38MuL2HIekWI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:690d:0:b0:dc6:e5e9:f3af with SMTP id
 e13-20020a25690d000000b00dc6e5e9f3afmr108780ybc.9.1709947652925; Fri, 08 Mar
 2024 17:27:32 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  8 Mar 2024 17:27:17 -0800
In-Reply-To: <20240309012725.1409949-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240309012725.1409949-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240309012725.1409949-2-seanjc@google.com>
Subject: [PATCH v6 1/9] x86/cpu: KVM: Add common defines for architectural
 memory types (PAT, MTRRs, etc.)
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Shan Kang <shan.kang@intel.com>, Kai Huang <kai.huang@intel.com>, Xin Li <xin3.li@intel.com>
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
index f1bd7b91b3c6..29f0ea78e41c 100644
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
 /* Intel MSRs. Some also available on other CPUs */
 
 #define MSR_TEST_CTRL				0x00000033
@@ -1108,7 +1122,6 @@
 #define VMX_BASIC_64		0x0001000000000000LLU
 #define VMX_BASIC_MEM_TYPE_SHIFT	50
 #define VMX_BASIC_MEM_TYPE_MASK	0x003c000000000000LLU
-#define VMX_BASIC_MEM_TYPE_WB	6LLU
 #define VMX_BASIC_INOUT		0x0040000000000000LLU
 
 /* Resctrl MSRs: */
diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 0e73616b82f3..4fdc76263066 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -504,9 +504,10 @@ enum vmcs_field {
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
index d05ddf751491..82a35aba7d2b 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -7006,7 +7006,7 @@ static void nested_vmx_setup_basic(struct nested_vmx_msrs *msrs)
 		VMCS12_REVISION |
 		VMX_BASIC_TRUE_CTLS |
 		((u64)VMCS12_SIZE << VMX_BASIC_VMCS_SIZE_SHIFT) |
-		(VMX_BASIC_MEM_TYPE_WB << VMX_BASIC_MEM_TYPE_SHIFT);
+		(X86_MEMTYPE_WB << VMX_BASIC_MEM_TYPE_SHIFT);
 
 	if (cpu_has_vmx_basic_inout())
 		msrs->basic |= VMX_BASIC_INOUT;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 7a74388f9ecf..71cc6e3b3221 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2692,7 +2692,7 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 #endif
 
 	/* Require Write-Back (WB) memory type for VMCS accesses. */
-	if (((vmx_msr_high >> 18) & 15) != 6)
+	if (((vmx_msr_high >> 18) & 15) != X86_MEMTYPE_WB)
 		return -EIO;
 
 	rdmsrl(MSR_IA32_VMX_MISC, misc_msr);
diff --git a/arch/x86/mm/pat/memtype.c b/arch/x86/mm/pat/memtype.c
index 0904d7e8e126..3e0ba044925f 100644
--- a/arch/x86/mm/pat/memtype.c
+++ b/arch/x86/mm/pat/memtype.c
@@ -175,15 +175,6 @@ static inline void set_page_memtype(struct page *pg,
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
@@ -193,13 +184,13 @@ static enum page_cache_mode __init pat_get_cache_mode(unsigned int pat_val,
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
@@ -254,11 +245,11 @@ void pat_cpu_init(void)
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
2.44.0.278.ge034bb2e1d-goog


