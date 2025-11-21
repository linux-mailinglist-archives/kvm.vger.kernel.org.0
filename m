Return-Path: <kvm+bounces-64195-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 859F4C7B3F1
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 19:13:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id E07994EFD70
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 18:09:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A848E325724;
	Fri, 21 Nov 2025 18:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HiiCS/jp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F79B223DD6
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 18:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763748564; cv=none; b=TbHc+W5tcP7879mtSgC6rzsyeCZgZNN9wwO2F6tvAYSdR98SY7r5+vz7N26HbYNuzYFcik0SH43Bs6wc6b0NyF8EsXEz7+uAFOKBfTdblNEGvF3btZ66iX/xDRE/j5siPBcpY9qCzIdNyYuDPpigiDMya3hrCNQkgPKh1CQbJ0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763748564; c=relaxed/simple;
	bh=n7foK8VypMH/THj4Nk1uAIdNHtj/CDAwO7g+4D37gn4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sbXYbC/Twtl1dsVnlnSu9SXY+Y2Rqc3V30TfMifce6dfexO+ixkAuDhrj3DgEX9fWtMPH/8EbPK/MBeoBLZBSoQjFLuv0MQu9XyyjczBvmiOP4BGaK9p6KDuMufDwL58SF8dQ3Q1BhzF6WfTH0nzHZIVIq79B6XJCXE5IKLVEvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HiiCS/jp; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3418ad76023so5133318a91.0
        for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 10:09:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763748562; x=1764353362; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=aUJrxLVB4MlfiVVqDDvl00n4jgB5qO4q86TsxJGMGqs=;
        b=HiiCS/jpuriQcDPjw0ex2KNvn59Aku+rcXt0BOkFFpfYUTPrm7y5YCboXxw0tXlVDu
         yh6oBPUo4BjBYLAspr3390wT7HTugBoOkZWkBaHWM8ibW0k16jmfmUOHiVEiaEvra9ZH
         QUGsAnkYrt9d47QmpjsL0jV68axYqIuVN30P6jisO4gsqtvat+N9ZxDN2tvX8wVC1mwt
         AYRCSRs1WF0ZUqTOjW+1fsJWxT/u3nGl6l+XhLRObBFgrvirn5SIVUxVPs1qFR7BFK6R
         Ha7Hzaug1cDv7VNIaOAHIc1fTOiTmpttZTF5Xl2rOq85zvnNiacfolpTVfzJ6RUdefjV
         TziQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763748562; x=1764353362;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aUJrxLVB4MlfiVVqDDvl00n4jgB5qO4q86TsxJGMGqs=;
        b=DE/qm7ZYURrRifJG447c9COF2GXC6uloQS0PRsHb4hCvdA3AFiVV2MDmBjoho92SJ/
         lmylSdMltCfScUABVrqmnJjCUVIOnfIzHeuPBW6bgsfk0lV9oQJI4PuS8oOgVXMQQkm2
         qLC6QPzky97LwSt/PIT0s0TSC2Pd8bSZDqG87+IEkxKW4+czcvwIu78OqDy5YLhjZFiS
         0Ny0XFD+o8STAg+JtwsX6vISEebgYo7se97mTxZe1d/6A7Ww2eKbzTENiDYGJ/+ITZvU
         ZOce+/5ClK0o50Rpe8xTu6z1CW6LRpuXhHvNJY0r/KN594ZVI9NxEhkDBo87pZmCJ+qE
         Qt8g==
X-Gm-Message-State: AOJu0Yx7bctS7JzvnjH9P79vHkZJfsg5FUZqwP6nW3nfHuoRO/LcmCGs
	wZH1fXPytVdFIy8v8H3dwRcqj2yrBV++15EilZHwJjA1c8SobTKI2HgljD0VYIr52LlmTIyFVqi
	ORT22qQ==
X-Google-Smtp-Source: AGHT+IG4KxIubr1wbk8Uh7ps6VoFAYs4zM9uXCpaD+vMdtLgsUI4yxLMaMMg/lHO5S6iKIv4fzglL9+YnrM=
X-Received: from pjbbo21.prod.google.com ([2002:a17:90b:915:b0:33b:dce0:c8ba])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:224e:b0:33e:2d0f:479b
 with SMTP id 98e67ed59e1d1-34733e4683cmr3870905a91.6.1763748562247; Fri, 21
 Nov 2025 10:09:22 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 21 Nov 2025 10:08:57 -0800
In-Reply-To: <20251121180901.271486-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251121180901.271486-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc2.455.g230fcf2819-goog
Message-ID: <20251121180901.271486-8-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v2 07/11] x86: xsave: Define
 XFEATURE_MASK_<feature> bits in processor.h
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Define all known XFEATURE_MASK_<feature> bits in processor.h so that the
macros are available to all tests, and to match the nomenclature used by
the Linux kernel.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/processor.h | 24 ++++++++++++++++++++++++
 x86/xsave.c         | 33 ++++++++++++++-------------------
 2 files changed, 38 insertions(+), 19 deletions(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index c3d3cacf..0e17ed70 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -182,6 +182,30 @@ static inline u64 get_non_canonical(u64 addr, u64 mask)
 #define X86_EFLAGS_ALU (X86_EFLAGS_CF | X86_EFLAGS_PF | X86_EFLAGS_AF | \
 			X86_EFLAGS_ZF | X86_EFLAGS_SF | X86_EFLAGS_OF)
 
+#define XFEATURE_MASK_FP		BIT_ULL(0)
+#define XFEATURE_MASK_SSE		BIT_ULL(1)
+#define XFEATURE_MASK_YMM		BIT_ULL(2)
+#define XFEATURE_MASK_BNDREGS		BIT_ULL(3)
+#define XFEATURE_MASK_BNDCSR		BIT_ULL(4)
+#define XFEATURE_MASK_OPMASK		BIT_ULL(5)
+#define XFEATURE_MASK_ZMM_Hi256		BIT_ULL(6)
+#define XFEATURE_MASK_Hi16_ZMM		BIT_ULL(7)
+#define XFEATURE_MASK_PT		BIT_ULL(8)
+#define XFEATURE_MASK_PKRU		BIT_ULL(9)
+#define XFEATURE_MASK_PASID		BIT_ULL(10)
+#define XFEATURE_MASK_CET_USER		BIT_ULL(11)
+#define XFEATURE_MASK_CET_KERNEL	BIT_ULL(12)
+#define XFEATURE_MASK_LBR		BIT_ULL(15)
+#define XFEATURE_MASK_XTILE_CFG		BIT_ULL(17)
+#define XFEATURE_MASK_XTILE_DATA	BIT_ULL(18)
+
+#define XFEATURE_MASK_FP_SSE		(XFEATURE_MASK_FP | XFEATURE_MASK_SSE)
+
+#define XFEATURE_MASK_AVX512		(XFEATURE_MASK_OPMASK | \
+					 XFEATURE_MASK_ZMM_Hi256 | \
+					 XFEATURE_MASK_Hi16_ZMM)
+#define XFEATURE_MASK_XTILE		(XFEATURE_MASK_XTILE_DATA | \
+					 XFEATURE_MASK_XTILE_CFG)
 
 /*
  * CPU features
diff --git a/x86/xsave.c b/x86/xsave.c
index a3645622..0113073f 100644
--- a/x86/xsave.c
+++ b/x86/xsave.c
@@ -2,10 +2,6 @@
 #include "desc.h"
 #include "processor.h"
 
-#define XSTATE_FP	0x1
-#define XSTATE_SSE	0x2
-#define XSTATE_YMM	0x4
-
 static void test_unsupported_xcrs(void)
 {
 	u64 ign;
@@ -17,10 +13,10 @@ static void test_unsupported_xcrs(void)
 			report(xgetbv_safe(i, &ign) == GP_VECTOR,
 			       "XGETBV(%u) - expect #GP", i);
 
-		report(xsetbv_safe(i, XSTATE_FP) == GP_VECTOR,
+		report(xsetbv_safe(i, XFEATURE_MASK_FP) == GP_VECTOR,
 		      "XSETBV(%u, FP) - expect #GP", i);
 
-		report(xsetbv_safe(i, XSTATE_FP | XSTATE_SSE) == GP_VECTOR,
+		report(xsetbv_safe(i, XFEATURE_MASK_FP_SSE) == GP_VECTOR,
 		      "XSETBV(%u, FP|SSE) - expect #GP", i);
 
 		/*
@@ -33,17 +29,17 @@ static void test_unsupported_xcrs(void)
 		report(xgetbv_safe(BIT(i), &ign) == GP_VECTOR,
 		       "XGETBV(0x%lx) - expect #GP", BIT(i));
 
-		report(xsetbv_safe(BIT(i), XSTATE_FP) == GP_VECTOR,
+		report(xsetbv_safe(BIT(i), XFEATURE_MASK_FP) == GP_VECTOR,
 		      "XSETBV(0x%lx, FP) - expect #GP", BIT(i));
 
-		report(xsetbv_safe(BIT(i), XSTATE_FP | XSTATE_SSE) == GP_VECTOR,
+		report(xsetbv_safe(BIT(i), XFEATURE_MASK_FP_SSE) == GP_VECTOR,
 		      "XSETBV(0x%lx, FP|SSE) - expect #GP", BIT(i));
 	}
 }
 
 static void test_xsave(void)
 {
-	u64 supported_xcr0, test_bits;
+	u64 supported_xcr0;
 	unsigned long cr4;
 
 	printf("Legal instruction testing:\n");
@@ -51,9 +47,8 @@ static void test_xsave(void)
 	supported_xcr0 = this_cpu_supported_xcr0();
 	printf("Supported XCR0 bits: %#lx\n", supported_xcr0);
 
-	test_bits = XSTATE_FP | XSTATE_SSE;
-	report((supported_xcr0 & test_bits) == test_bits,
-	       "Check minimal XSAVE required bits");
+	report((supported_xcr0 & XFEATURE_MASK_FP_SSE) == XFEATURE_MASK_FP_SSE,
+	       "FP and SSE should always be supported in XCR0");
 
 	cr4 = read_cr4();
 	write_cr4(cr4 | X86_CR4_OSXSAVE);
@@ -62,22 +57,22 @@ static void test_xsave(void)
 	       "Check CPUID.1.ECX.OSXSAVE - expect 1");
 
 	printf("\tLegal tests\n");
-	write_xcr0(XSTATE_FP);
-	write_xcr0(XSTATE_FP | XSTATE_SSE);
+	write_xcr0(XFEATURE_MASK_FP);
+	write_xcr0(XFEATURE_MASK_FP_SSE);
 	(void)read_xcr0();
 
 	printf("\tIllegal tests\n");
 	report(write_xcr0_safe(0) == GP_VECTOR,
 	       "\t\tWrite XCR0 = 0 - expect #GP");
 
-	report(write_xcr0_safe(XSTATE_SSE) == GP_VECTOR,
+	report(write_xcr0_safe(XFEATURE_MASK_SSE) == GP_VECTOR,
 	       "\t\tWrite XCR0 = SSE - expect #GP");
 
-	if (supported_xcr0 & XSTATE_YMM) {
-		report(write_xcr0_safe(XSTATE_YMM) == GP_VECTOR,
+	if (supported_xcr0 & XFEATURE_MASK_YMM) {
+		report(write_xcr0_safe(XFEATURE_MASK_YMM) == GP_VECTOR,
 		       "\t\tWrite XCR0 = YMM - expect #GP");
 
-		report(write_xcr0_safe(XSTATE_FP | XSTATE_YMM) == GP_VECTOR,
+		report(write_xcr0_safe(XFEATURE_MASK_FP | XFEATURE_MASK_YMM) == GP_VECTOR,
 		       "\t\tWrite XCR0 = (FP | YMM) - expect #GP");
 	}
 
@@ -103,7 +98,7 @@ static void test_no_xsave(void)
 	report(read_xcr0_safe(&xcr0) == UD_VECTOR,
 	       "Read XCR0 without OSXSAVE enabled - expect #UD");
 
-	report(write_xcr0_safe(XSTATE_FP | XSTATE_SSE) == UD_VECTOR,
+	report(write_xcr0_safe(XFEATURE_MASK_FP_SSE) == UD_VECTOR,
 	       "Write XCR0=(FP|SSE) without XSAVE support - expect #UD");
 
 	if (cr4 & X86_CR4_OSXSAVE)
-- 
2.52.0.rc2.455.g230fcf2819-goog


