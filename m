Return-Path: <kvm+bounces-64196-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id D9F61C7B3F4
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 19:13:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 6D2D04EFFC1
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 18:09:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 691E82EA154;
	Fri, 21 Nov 2025 18:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2vowHt3q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C36D2E7F29
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 18:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763748566; cv=none; b=NyuSyIkVJyRK7010hEs8Qlwgl2KhU+QeGWRNw51j5TKp48WUFopED2daDoLlNEqrRiqy/P4HxbcD3OdFeDulLyXumLoFMcYhCd4MPgoKZ0tBulCc5lZ9+edGnjX1XUhyAg34tnceC+gWEQJw9P/7kcfX6lVj1LiyzzOMTuvMhtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763748566; c=relaxed/simple;
	bh=1ocN4vJ9IF3Z4+2TLl/+P8jaqeQF1s4xU2vepjPe9Wk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WhqPis9xRfxM+6PTBvnizqwNq+8/XQUIzdinJmZEwAaiCzUIqw4W7w/BBYzNdsCyhJ9OxXsjEHKSV+S4Hk4aIANRx3BuyW5b/mZguDO2XAAISKgAzhDba3n3PbPUqmt+Jna3Mxi1Th/NGOfElWF8x6Ka+sDpc1YtU/z2JdtUiRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2vowHt3q; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3436d81a532so4748005a91.3
        for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 10:09:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763748564; x=1764353364; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ytYInl4ClISgAOcsU3ehvsV+XUpsVHC8dwvJGRmCQCY=;
        b=2vowHt3qDj2NzVMBvXjIW+Krdo1eoq7cfFI06jV5ndOWbOi9SJ73BwI949Dtmw8A1U
         rQyvtl2JkeHef/Nd03JcmF6c0Pi7TnHZnH5HW271Dygf1q3dCfpRSvm0+N4fyywiRoW6
         CZBbDiBpg0LDVSxSTAXVIqnWCQkVIzsOM+IZEYL8zDxRW6UwDnnpdgB3/xG+cbQLRXPf
         MUNNxZeltrf526mPnEVRwslHUPmqM5k5SG2dYgLn6XWcCNuoFFBabYcOeONJdbriVMe9
         YRrBO5/jy+dByuEBVmMrDMlxO0mwER/e55dn8CYhzfB5ka7ArORj5qZn2tnoXbVprZbA
         TivQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763748564; x=1764353364;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ytYInl4ClISgAOcsU3ehvsV+XUpsVHC8dwvJGRmCQCY=;
        b=pW2vIhN11pLilEM91Kbjers253Nkf7t7o5H4/ZDnVUuPTspHvNEqcgqqmyi6q/pCHG
         EM0gH0fFKg9HWJ68OGOeQGhLokOfmuoaKXdJXCMsPVBSit0NhYRdNx1J2DJ2kMFNQWhy
         wUuFy2ga4WvJIZxc4WXXM4tMqK5IEKwjjT6SYPLK+FW3baNnYirkNKoOE69GPI9tm1Yk
         8AmP36ounKvBsd5ccnACczLgZGDeON/dQTDOc2HTRGa14dCa8CG9FGoRCjUhH3IHOha1
         iFK3icofOWJtfSMFTTpZiWyHriVDobAsmmYPH0ngb4T8sznzd4kk2ZbNfZzQe4O++3jT
         t1EA==
X-Gm-Message-State: AOJu0YxRzy7yCZmNrfxwJr82r31p2rYwea3hdwYPc3naaF7SPz6nbGwe
	EMiCa5/RVECrko/UXDjEkeD/nlMPL3CJE5o4A16iMJDbK/pr5n/hHfvHKpM5MCrKmPZsm+UMJ2w
	8ZwJ06A==
X-Google-Smtp-Source: AGHT+IF3NW788qU6XskkcKs4Vs1q9TYQ7yfi1JmcqP0Yp6RhD+voevoela2cJfJ7L8DSw6MK40b+Ei/6gN0=
X-Received: from pjvh22.prod.google.com ([2002:a17:90a:db96:b0:33b:51fe:1a89])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5628:b0:341:194:5e7c
 with SMTP id 98e67ed59e1d1-34733f2d700mr3593005a91.24.1763748564457; Fri, 21
 Nov 2025 10:09:24 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 21 Nov 2025 10:08:58 -0800
In-Reply-To: <20251121180901.271486-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251121180901.271486-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc2.455.g230fcf2819-goog
Message-ID: <20251121180901.271486-9-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v2 08/11] x86: xsave: Add testcase for
 emulation of AVX instructions
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Paolo Bonzini <pbonzini@redhat.com>

Extend the XSAVE test to validate KVM's recently added emulation of AVX
VMOVDQA instructions.  Test mem=>reg, reg=>reg, and reg=>mem moves, and
when forced emulation is supported, verify that mixing forced emulation
and native accesses works as expected, e.g. that KVM writes internal state
into hardware.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Link: https://patch.msgid.link/20251114003228.60592-1-pbonzini@redhat.com
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/xsave.c | 66 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)

diff --git a/x86/xsave.c b/x86/xsave.c
index 0113073f..72e9c673 100644
--- a/x86/xsave.c
+++ b/x86/xsave.c
@@ -2,6 +2,69 @@
 #include "desc.h"
 #include "processor.h"
 
+char __attribute__((aligned(32))) v32_1[32];
+char __attribute__((aligned(32))) v32_2[32];
+char __attribute__((aligned(32))) v32_3[32];
+
+static void initialize_avx_buffers(void)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(v32_1); i++)
+		v32_1[i] = (char)rdtsc();
+
+	memset(v32_2, 0, sizeof(v32_2));
+	memset(v32_3, 0, sizeof(v32_3));
+}
+
+#define __TEST_VMOVDQA(reg1, reg2, FEP)					\
+do {									\
+	asm volatile(FEP "vmovdqa v32_1(%%rip), %%" #reg1 "\n"		\
+		     FEP "vmovdqa %%" #reg1 ", %%" #reg2 "\n"		\
+		     FEP "vmovdqa %%" #reg2 ", v32_2(%%rip)\n"		\
+		     "vmovdqa %%" #reg2 ", v32_3(%%rip)\n"		\
+		     ::: "memory", #reg1, #reg2);			\
+									\
+	report(!memcmp(v32_1, v32_2, sizeof(v32_1)),			\
+	       "%s VMOVDQA using " #reg1 " and " #reg2,			\
+	       strlen(FEP) ? "Emulated" : "Native");			\
+	report(!memcmp(v32_1, v32_3, sizeof(v32_1)),			\
+	       "%s VMOVDQA using " #reg1 " and " #reg2,			\
+	       strlen(FEP) ? "Emulated+Native" : "Native");		\
+} while (0)
+
+#define TEST_VMOVDQA(r1, r2)						\
+do {									\
+	initialize_avx_buffers();					\
+									\
+	__TEST_VMOVDQA(ymm##r1, ymm##r2, "");				\
+									\
+	if (is_fep_available)						\
+		__TEST_VMOVDQA(ymm##r1, ymm##r2, KVM_FEP);		\
+} while (0)
+
+static __attribute__((target("avx"))) void test_avx_vmovdqa(void)
+{
+	write_xcr0(XFEATURE_MASK_FP_SSE | XFEATURE_MASK_YMM);
+
+	TEST_VMOVDQA(0, 15);
+	TEST_VMOVDQA(1, 14);
+	TEST_VMOVDQA(2, 13);
+	TEST_VMOVDQA(3, 12);
+	TEST_VMOVDQA(4, 11);
+	TEST_VMOVDQA(5, 10);
+	TEST_VMOVDQA(6, 9);
+	TEST_VMOVDQA(7, 8);
+	TEST_VMOVDQA(8, 7);
+	TEST_VMOVDQA(9, 6);
+	TEST_VMOVDQA(10, 5);
+	TEST_VMOVDQA(11, 4);
+	TEST_VMOVDQA(12, 3);
+	TEST_VMOVDQA(13, 2);
+	TEST_VMOVDQA(14, 2);
+	TEST_VMOVDQA(15, 1);
+}
+
 static void test_unsupported_xcrs(void)
 {
 	u64 ign;
@@ -61,6 +124,9 @@ static void test_xsave(void)
 	write_xcr0(XFEATURE_MASK_FP_SSE);
 	(void)read_xcr0();
 
+	if (supported_xcr0 & XFEATURE_MASK_YMM)
+		test_avx_vmovdqa();
+
 	printf("\tIllegal tests\n");
 	report(write_xcr0_safe(0) == GP_VECTOR,
 	       "\t\tWrite XCR0 = 0 - expect #GP");
-- 
2.52.0.rc2.455.g230fcf2819-goog


