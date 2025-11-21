Return-Path: <kvm+bounces-64189-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 6ECDBC7B3D9
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 19:12:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 86CB04EC3AC
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 18:09:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 513FD346E46;
	Fri, 21 Nov 2025 18:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DS25VvA+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD78A2ECE9E
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 18:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763748551; cv=none; b=HyLehDV5K0PLaGXC4G4ZwdfZ+kGSN86YA3c3AxfY+s9ansllzJidy9I3ktWprerrrN/qqQTRYhP8eFN1EvEPpjNr8/Uu26HlJ6EV/AlZu87eV9Q3YkDisXZ68tj/aAhp4J5BrRcsZwvKS/5XtZaUjJZ87L156pupQsd0oV0kpvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763748551; c=relaxed/simple;
	bh=2Jp7PfybFscpT60rns5vtX6GlJp4pJRYziHrtkEOwdc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lcV2R/AWghDKTYw1xEriZvYA3ULqT25jGQg++dsr7MrwCzacy/zFp+6vQquvPBoQaNQyWWuSUEYgIGiJDZQC/vU8zqwHzQyM3vlVq8SoOOW56o/dgOnOGtOwPUi13njUl2UwIfc61pzAURSQZkyKMP3ZjR0/YLu5V553HalD7G8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DS25VvA+; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-29806c42760so93214215ad.2
        for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 10:09:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763748549; x=1764353349; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=KISUJG5gt6VfSRdAsI/PpXH/vLzc4XFQbCkhNP/fpmY=;
        b=DS25VvA+xfzxEuXVipFDJ6ysu3c8a/9tEC/v3LeMqZf0dlSlbsBEHAWp3TP9TW6MA1
         OUdW1yMeE+KMfsTCJ4n6L0gmC7BEIhweyjlrTOyZDjQiYPmPolscO7eI34bBq99qCIP8
         M5VBYHFs8Q77c0h6NHwo0UInAZZNwFAY+MvHDoJNXp18pwcn5MVAGpkuTbY8+Fne7IwB
         qlep/uQzhm3NRfiVoV8sTCVDt21LeOH49otcXcO9s7lYuZzKXGkPW9gn8YRxuq1r/Bip
         glzKojuEe7wsdwlHst8EzIIKQ01t8mUhadbev166vvdTHUSS/liNiTT8JJE+NaQlAl8o
         RZ6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763748549; x=1764353349;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KISUJG5gt6VfSRdAsI/PpXH/vLzc4XFQbCkhNP/fpmY=;
        b=gQNKTI7FKyxSGdbTvrzDiIYH7rXwpvP+VarsSRXMXzMfYSpv7Xxtgez7IGpTgjSLrh
         ptM5KQGDq0b2LDpLa0hl3g0TqC47W4jiWG4t/ejP0lYi2V81xWkMTSDKVCaLL24sN+EP
         H8wghBd1EkHpOA9D4pdTXPqKYbwAgXWejynDKhnA54Nxgwa7RafWY5e9IQsPQdjmdJ9y
         rN0ozBszoVSEMsgHu2xcx8FdN6XL5roDH18bf5wG/fR9gTnTFfUkW/uA/DFdKVHUjUq+
         YM9BOb11/5isxgdeW4Hatx70r4a5EDZ6nynzNyKVDdq94VwGX1dmY2coiKb6Y2haebjG
         0CzQ==
X-Gm-Message-State: AOJu0Yx6Z5v3uGu7HZ76wqwTqmktataOPPpepjaR8XbVFG65yxwe9ooM
	+bzBnyPOweQxTSlAoo0aYk6sovOjGdJ6aAVTNPGcmYNJ10SBFuApLdiNnQNCfNVEBVFvjfhfIwB
	ykpx3Tg==
X-Google-Smtp-Source: AGHT+IFbU3GyI+4+Z/vOcQSWviVOZGO+JWRa4cFq4DXjiw6LoqweKKGcVtek6IcS3eVDI0lrce3cZwRnyuI=
X-Received: from pgmj22.prod.google.com ([2002:a63:5956:0:b0:bac:a20:5f03])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:988:b0:297:d777:a2d4
 with SMTP id d9443c01a7336-29b6bf3bfffmr46162565ad.46.1763748549099; Fri, 21
 Nov 2025 10:09:09 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 21 Nov 2025 10:08:51 -0800
In-Reply-To: <20251121180901.271486-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251121180901.271486-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc2.455.g230fcf2819-goog
Message-ID: <20251121180901.271486-2-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v2 01/11] x86: xsave: Replace spaces with tabs
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Replace spaces with tabs in the XSAVE test so that upcoming changes don't
have to carry forward the non-standard formatting.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/xsave.c | 198 ++++++++++++++++++++++++++--------------------------
 1 file changed, 99 insertions(+), 99 deletions(-)

diff --git a/x86/xsave.c b/x86/xsave.c
index cc8e3a0a..f18d66a1 100644
--- a/x86/xsave.c
+++ b/x86/xsave.c
@@ -8,120 +8,120 @@
 #define uint64_t unsigned long long
 #endif
 
-#define XCR_XFEATURE_ENABLED_MASK       0x00000000
-#define XCR_XFEATURE_ILLEGAL_MASK       0x00000010
+#define XCR_XFEATURE_ENABLED_MASK	0x00000000
+#define XCR_XFEATURE_ILLEGAL_MASK	0x00000010
 
-#define XSTATE_FP       0x1
-#define XSTATE_SSE      0x2
-#define XSTATE_YMM      0x4
+#define XSTATE_FP	0x1
+#define XSTATE_SSE	0x2
+#define XSTATE_YMM	0x4
 
 static void test_xsave(void)
 {
-    unsigned long cr4;
-    uint64_t supported_xcr0;
-    uint64_t test_bits;
-    u64 xcr0;
-
-    printf("Legal instruction testing:\n");
-
-    supported_xcr0 = this_cpu_supported_xcr0();
-    printf("Supported XCR0 bits: %#lx\n", supported_xcr0);
-
-    test_bits = XSTATE_FP | XSTATE_SSE;
-    report((supported_xcr0 & test_bits) == test_bits,
-           "Check minimal XSAVE required bits");
-
-    cr4 = read_cr4();
-    report(write_cr4_safe(cr4 | X86_CR4_OSXSAVE) == 0, "Set CR4 OSXSAVE");
-    report(this_cpu_has(X86_FEATURE_OSXSAVE),
-           "Check CPUID.1.ECX.OSXSAVE - expect 1");
-
-    printf("\tLegal tests\n");
-    test_bits = XSTATE_FP;
-    report(xsetbv_safe(XCR_XFEATURE_ENABLED_MASK, test_bits) == 0,
-           "\t\txsetbv(XCR_XFEATURE_ENABLED_MASK, XSTATE_FP)");
-
-    test_bits = XSTATE_FP | XSTATE_SSE;
-    report(xsetbv_safe(XCR_XFEATURE_ENABLED_MASK, test_bits) == 0,
-           "\t\txsetbv(XCR_XFEATURE_ENABLED_MASK, XSTATE_FP | XSTATE_SSE)");
-    report(xgetbv_safe(XCR_XFEATURE_ENABLED_MASK, &xcr0) == 0,
-           "        xgetbv(XCR_XFEATURE_ENABLED_MASK)");
-
-    printf("\tIllegal tests\n");
-    test_bits = 0;
-    report(xsetbv_safe(XCR_XFEATURE_ENABLED_MASK, test_bits) == GP_VECTOR,
-           "\t\txsetbv(XCR_XFEATURE_ENABLED_MASK, 0) - expect #GP");
-
-    test_bits = XSTATE_SSE;
-    report(xsetbv_safe(XCR_XFEATURE_ENABLED_MASK, test_bits) == GP_VECTOR,
-           "\t\txsetbv(XCR_XFEATURE_ENABLED_MASK, XSTATE_SSE) - expect #GP");
-
-    if (supported_xcr0 & XSTATE_YMM) {
-        test_bits = XSTATE_YMM;
-        report(xsetbv_safe(XCR_XFEATURE_ENABLED_MASK, test_bits) == GP_VECTOR,
-               "\t\txsetbv(XCR_XFEATURE_ENABLED_MASK, XSTATE_YMM) - expect #GP");
-
-        test_bits = XSTATE_FP | XSTATE_YMM;
-        report(xsetbv_safe(XCR_XFEATURE_ENABLED_MASK, test_bits) == GP_VECTOR,
-               "\t\txsetbv(XCR_XFEATURE_ENABLED_MASK, XSTATE_FP | XSTATE_YMM) - expect #GP");
-    }
-
-    test_bits = XSTATE_SSE;
-    report(xsetbv_safe(XCR_XFEATURE_ILLEGAL_MASK, test_bits) == GP_VECTOR,
-           "\t\txsetbv(XCR_XFEATURE_ILLEGAL_MASK, XSTATE_FP) - expect #GP");
-
-    test_bits = XSTATE_SSE;
-    report(xsetbv_safe(XCR_XFEATURE_ILLEGAL_MASK, test_bits) == GP_VECTOR,
-           "\t\txgetbv(XCR_XFEATURE_ILLEGAL_MASK, XSTATE_FP) - expect #GP");
-
-    cr4 &= ~X86_CR4_OSXSAVE;
-    report(write_cr4_safe(cr4) == 0, "Unset CR4 OSXSAVE");
-    report(this_cpu_has(X86_FEATURE_OSXSAVE) == 0,
-           "Check CPUID.1.ECX.OSXSAVE - expect 0");
-
-    printf("\tIllegal tests:\n");
-    test_bits = XSTATE_FP;
-    report(xsetbv_safe(XCR_XFEATURE_ENABLED_MASK, test_bits) == UD_VECTOR,
-           "\t\txsetbv(XCR_XFEATURE_ENABLED_MASK, XSTATE_FP) - expect #UD");
-
-    test_bits = XSTATE_FP | XSTATE_SSE;
-    report(xsetbv_safe(XCR_XFEATURE_ENABLED_MASK, test_bits) == UD_VECTOR,
-           "\t\txsetbv(XCR_XFEATURE_ENABLED_MASK, XSTATE_FP | XSTATE_SSE) - expect #UD");
-
-    printf("\tIllegal tests:\n");
-    report(xgetbv_safe(XCR_XFEATURE_ENABLED_MASK, &xcr0) == UD_VECTOR,
-           "\txgetbv(XCR_XFEATURE_ENABLED_MASK) - expect #UD");
+	unsigned long cr4;
+	uint64_t supported_xcr0;
+	uint64_t test_bits;
+	u64 xcr0;
+
+	printf("Legal instruction testing:\n");
+
+	supported_xcr0 = this_cpu_supported_xcr0();
+	printf("Supported XCR0 bits: %#lx\n", supported_xcr0);
+
+	test_bits = XSTATE_FP | XSTATE_SSE;
+	report((supported_xcr0 & test_bits) == test_bits,
+	       "Check minimal XSAVE required bits");
+
+	cr4 = read_cr4();
+	report(write_cr4_safe(cr4 | X86_CR4_OSXSAVE) == 0, "Set CR4 OSXSAVE");
+	report(this_cpu_has(X86_FEATURE_OSXSAVE),
+	       "Check CPUID.1.ECX.OSXSAVE - expect 1");
+
+	printf("\tLegal tests\n");
+	test_bits = XSTATE_FP;
+	report(xsetbv_safe(XCR_XFEATURE_ENABLED_MASK, test_bits) == 0,
+	       "\t\txsetbv(XCR_XFEATURE_ENABLED_MASK, XSTATE_FP)");
+
+	test_bits = XSTATE_FP | XSTATE_SSE;
+	report(xsetbv_safe(XCR_XFEATURE_ENABLED_MASK, test_bits) == 0,
+	       "\t\txsetbv(XCR_XFEATURE_ENABLED_MASK, XSTATE_FP | XSTATE_SSE)");
+	report(xgetbv_safe(XCR_XFEATURE_ENABLED_MASK, &xcr0) == 0,
+	       "\t\txgetbv(XCR_XFEATURE_ENABLED_MASK)");
+
+	printf("\tIllegal tests\n");
+	test_bits = 0;
+	report(xsetbv_safe(XCR_XFEATURE_ENABLED_MASK, test_bits) == GP_VECTOR,
+	       "\t\txsetbv(XCR_XFEATURE_ENABLED_MASK, 0) - expect #GP");
+
+	test_bits = XSTATE_SSE;
+	report(xsetbv_safe(XCR_XFEATURE_ENABLED_MASK, test_bits) == GP_VECTOR,
+	       "\t\txsetbv(XCR_XFEATURE_ENABLED_MASK, XSTATE_SSE) - expect #GP");
+
+	if (supported_xcr0 & XSTATE_YMM) {
+		test_bits = XSTATE_YMM;
+		report(xsetbv_safe(XCR_XFEATURE_ENABLED_MASK, test_bits) == GP_VECTOR,
+		       "\t\txsetbv(XCR_XFEATURE_ENABLED_MASK, XSTATE_YMM) - expect #GP");
+
+		test_bits = XSTATE_FP | XSTATE_YMM;
+		report(xsetbv_safe(XCR_XFEATURE_ENABLED_MASK, test_bits) == GP_VECTOR,
+		       "\t\txsetbv(XCR_XFEATURE_ENABLED_MASK, XSTATE_FP | XSTATE_YMM) - expect #GP");
+	}
+
+	test_bits = XSTATE_SSE;
+	report(xsetbv_safe(XCR_XFEATURE_ILLEGAL_MASK, test_bits) == GP_VECTOR,
+	       "\t\txsetbv(XCR_XFEATURE_ILLEGAL_MASK, XSTATE_FP) - expect #GP");
+
+	test_bits = XSTATE_SSE;
+	report(xsetbv_safe(XCR_XFEATURE_ILLEGAL_MASK, test_bits) == GP_VECTOR,
+	       "\t\txgetbv(XCR_XFEATURE_ILLEGAL_MASK, XSTATE_FP) - expect #GP");
+
+	cr4 &= ~X86_CR4_OSXSAVE;
+	report(write_cr4_safe(cr4) == 0, "Unset CR4 OSXSAVE");
+	report(this_cpu_has(X86_FEATURE_OSXSAVE) == 0,
+	       "Check CPUID.1.ECX.OSXSAVE - expect 0");
+
+	printf("\tIllegal tests:\n");
+	test_bits = XSTATE_FP;
+	report(xsetbv_safe(XCR_XFEATURE_ENABLED_MASK, test_bits) == UD_VECTOR,
+	       "\t\txsetbv(XCR_XFEATURE_ENABLED_MASK, XSTATE_FP) - expect #UD");
+
+	test_bits = XSTATE_FP | XSTATE_SSE;
+	report(xsetbv_safe(XCR_XFEATURE_ENABLED_MASK, test_bits) == UD_VECTOR,
+	       "\t\txsetbv(XCR_XFEATURE_ENABLED_MASK, XSTATE_FP | XSTATE_SSE) - expect #UD");
+
+	printf("\tIllegal tests:\n");
+	report(xgetbv_safe(XCR_XFEATURE_ENABLED_MASK, &xcr0) == UD_VECTOR,
+	       "\txgetbv(XCR_XFEATURE_ENABLED_MASK) - expect #UD");
 }
 
 static void test_no_xsave(void)
 {
-    unsigned long cr4;
-    u64 xcr0;
+	unsigned long cr4;
+	u64 xcr0;
 
-    report(this_cpu_has(X86_FEATURE_OSXSAVE) == 0,
-           "Check CPUID.1.ECX.OSXSAVE - expect 0");
+	report(this_cpu_has(X86_FEATURE_OSXSAVE) == 0,
+	       "Check CPUID.1.ECX.OSXSAVE - expect 0");
 
-    printf("Illegal instruction testing:\n");
+	printf("Illegal instruction testing:\n");
 
-    cr4 = read_cr4();
-    report(write_cr4_safe(cr4 | X86_CR4_OSXSAVE) == GP_VECTOR,
-           "Set OSXSAVE in CR4 - expect #GP");
+	cr4 = read_cr4();
+	report(write_cr4_safe(cr4 | X86_CR4_OSXSAVE) == GP_VECTOR,
+	       "Set OSXSAVE in CR4 - expect #GP");
 
-    report(xgetbv_safe(XCR_XFEATURE_ENABLED_MASK, &xcr0) == UD_VECTOR,
-           "Execute xgetbv - expect #UD");
+	report(xgetbv_safe(XCR_XFEATURE_ENABLED_MASK, &xcr0) == UD_VECTOR,
+	       "Execute xgetbv - expect #UD");
 
-    report(xsetbv_safe(XCR_XFEATURE_ENABLED_MASK, 0x3) == UD_VECTOR,
-           "Execute xsetbv - expect #UD");
+	report(xsetbv_safe(XCR_XFEATURE_ENABLED_MASK, 0x3) == UD_VECTOR,
+	       "Execute xsetbv - expect #UD");
 }
 
 int main(void)
 {
-    if (this_cpu_has(X86_FEATURE_XSAVE)) {
-        printf("CPU has XSAVE feature\n");
-        test_xsave();
-    } else {
-        printf("CPU don't has XSAVE feature\n");
-        test_no_xsave();
-    }
-    return report_summary();
+	if (this_cpu_has(X86_FEATURE_XSAVE)) {
+		printf("CPU has XSAVE feature\n");
+		test_xsave();
+	} else {
+		printf("CPU don't has XSAVE feature\n");
+		test_no_xsave();
+	}
+	return report_summary();
 }
-- 
2.52.0.rc2.455.g230fcf2819-goog


