Return-Path: <kvm+bounces-17779-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3AFDF8CA1A1
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 19:59:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BA1F91F225FD
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 17:59:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6D7F1384A6;
	Mon, 20 May 2024 17:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BQPPOOZ7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA11137C28
	for <kvm@vger.kernel.org>; Mon, 20 May 2024 17:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716227976; cv=none; b=FxfGOkR+36vUDGMSJS9AeykXTcg5ulqd4LNVYjGFzsAPkFJYwgaYjfLer8iQ6/136ziRYhzdtFnTRZeSkIAM3B3W0tmlT7drPKOval5p1pW4br8R8X4WDGb7/GkzaBrQlEkhBmb4ZvPrrp/X+YjJjJKsJLAyOVXgEFwozaRVeo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716227976; c=relaxed/simple;
	bh=uox+OZEzbgy33swDxnq4tYC/CQYEFaLA6vhUYfkNEug=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ru6Ov+waTkH5awoCJPLbumz8hIpZdAzxnlkrKRXZmmQW8lFIsp9j29Bl9CDIwRZ8UzTZI3uX2eQZjuG1FHHetLLEgoULAg0Q92xpXcAP6P9j1b9OlG6TKn3wct6mHjHT/8ul4RPdFS6jfCrE7vhVX1Gs3n3tzFzcSUYSZJv/DIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BQPPOOZ7; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-622ccd54587so186223357b3.0
        for <kvm@vger.kernel.org>; Mon, 20 May 2024 10:59:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716227973; x=1716832773; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=jSLy0GyDLrcWsvMiqcNdDj9YLlKRjjDtTa+5xSab0PQ=;
        b=BQPPOOZ74VaazHZAdw+CKlmWL/jF5RNxmXutu6CApUmvT+ftGRvC5Jl9EQf8p9bpfo
         lfZKfvP9xjeut1IJVtDI0qcd/vW7gMONmNG1qZ9bBnF+fgVwQ6bnrfmCcYpja2CIsqdB
         gMZ0jH8uOQyqKoav7/58lji3rluBB1AnlkAomVM680OIjpyMFWM4hnyYdQe6dG3G31hZ
         qCoRvHlxtz0hksJIoR1+NEvhd8Q+0SEH1d+IZAHm8lGsJuGXWG1WXm6zPqRHpmi4od/A
         9mR1LCsXYk+oAzPBQtsHnvjQ7ZsOo2J8sFnmM+1iXBu6zR/zuvpfsquvHvEQrf8NFJu0
         mBZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716227973; x=1716832773;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jSLy0GyDLrcWsvMiqcNdDj9YLlKRjjDtTa+5xSab0PQ=;
        b=s1mzdqSpTIktCqA8ZH8TXgScnfw+9NhfPBYfB4Iy5A1LtQRY68tkQthRnzmKHpGbpd
         nyLO0fTqrbWRWuq0GR5Z7Z1Lr6san7P1dlft5r9CBWSD9uDHbh1uf0fN+FxFghbI0HHy
         HFMbbxK3Wxqa3zvOHpIG4OLJ3XHn79l5zhZ8N+IF6SaHO2eZqkvbzX9Wvrvwn83E60Js
         MRFYD1OlIo8UjDVoz3x5GtJ3qsyNK/gJEyv3NHQOoUtQdkYXnqTSJPfGpOacbdyaJ3YV
         nU9QHxjL3Iwj5+uJduFuoLyaaG12F/Xl7tZh592JOEI9JFKOD/TqHu9+xcTg2f0PEZl/
         IBgA==
X-Gm-Message-State: AOJu0Yy2CWfoXt16G7pm8SH7X4rmLP5Ti3uZByjZJtgtCMMMaz2qRWJw
	bTPudwLySIfQGZ04weFCP0ouJqS3z/WnH9fLPlUlU720pMP9NcCe21dnhUsFiBR3gySownKAT1a
	77A==
X-Google-Smtp-Source: AGHT+IGuOVtJe1S9HeVClEhCAyugjkHOhza1py8kyGxWRCUqNc2tnV7aeGA1DuS3CFt8c3Joo6IVyJVYa58=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:d8d4:0:b0:de4:e042:eee9 with SMTP id
 3f1490d57ef6-dee4f2e9594mr7192098276.6.1716227973509; Mon, 20 May 2024
 10:59:33 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 20 May 2024 10:59:16 -0700
In-Reply-To: <20240520175925.1217334-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240520175925.1217334-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.0.215.g3402c0e53f-goog
Message-ID: <20240520175925.1217334-2-seanjc@google.com>
Subject: [PATCH v7 01/10] x86/cpu: KVM: Add common defines for architectural
 memory types (PAT, MTRRs, etc.)
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Kai Huang <kai.huang@intel.com>, 
	Shan Kang <shan.kang@intel.com>, Xin Li <xin3.li@intel.com>, Zhao Liu <zhao1.liu@intel.com>
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
index e72c2b872957..3ea00500a263 100644
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
@@ -1154,7 +1168,6 @@
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
index d5b832126e34..804e9240889a 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -7028,7 +7028,7 @@ static void nested_vmx_setup_basic(struct nested_vmx_msrs *msrs)
 		VMCS12_REVISION |
 		VMX_BASIC_TRUE_CTLS |
 		((u64)VMCS12_SIZE << VMX_BASIC_VMCS_SIZE_SHIFT) |
-		(VMX_BASIC_MEM_TYPE_WB << VMX_BASIC_MEM_TYPE_SHIFT);
+		(X86_MEMTYPE_WB << VMX_BASIC_MEM_TYPE_SHIFT);
 
 	if (cpu_has_vmx_basic_inout())
 		msrs->basic |= VMX_BASIC_INOUT;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 51b2cd13250a..7dd76d04b4b0 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2712,7 +2712,7 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 #endif
 
 	/* Require Write-Back (WB) memory type for VMCS accesses. */
-	if (((vmx_msr_high >> 18) & 15) != 6)
+	if (((vmx_msr_high >> 18) & 15) != X86_MEMTYPE_WB)
 		return -EIO;
 
 	rdmsrl(MSR_IA32_VMX_MISC, misc_msr);
diff --git a/arch/x86/mm/pat/memtype.c b/arch/x86/mm/pat/memtype.c
index 36b603d0cdde..0417368011c4 100644
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
@@ -256,11 +247,11 @@ void pat_cpu_init(void)
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
2.45.0.215.g3402c0e53f-goog


