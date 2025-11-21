Return-Path: <kvm+bounces-64192-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 65096C7B40C
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 19:14:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 123773457AD
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 18:09:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB5172DFA25;
	Fri, 21 Nov 2025 18:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wVdkJuq9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40C252E6CD2
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 18:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763748559; cv=none; b=n9vYQL57SfmMD0m2qSkTpbVx0Pnbyd1uSjcBWDAXW4VvKeWP/b4as0pG1F+kWLFbNAbbdwI65/TEkYsn6kJDPKA8Pg/fxdJVUeZoHrr2ipWjKDdrXY+xbJT4RvxaW4z8351ARwbtmToNgpMmN4LFmgwj90RvflacJlrKt3M92Sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763748559; c=relaxed/simple;
	bh=ZVAd9wGvd5AcKjCA/OdwwLxe+KVxkab6mXkoWz1ntE4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Jfln43Y08AoYiBmaxu1kV6MZKcq4XPtDyd+O+OAR5kq8ROiVf/qzdxAqAr1RrTmJRVOdQ6sI1ZyHx14dluuSxgTq0wjrTbjIQVs6tqpzP/FDE0hF2XYItzyw+nGW8XddCFz6hcQiRL7BzTsWXKuZ8yp3dpCtCrTVXYSw0L9hdDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wVdkJuq9; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34377900dbcso5360579a91.2
        for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 10:09:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763748557; x=1764353357; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=cysM1a5K8N5cRoV859ZjU5C+6NBB91KVPWuXuHes6mk=;
        b=wVdkJuq9rhTQ/wXJMki5sz6rb6o56IJRsjiR/tgzgLc2OGZytYvCXpqPDqlFhzXxgu
         22boAo5rwZTvG7XN1gflozK1VK4dh2mHcbyq+XcYvFSjSMXd3WRvHGuDvLI5xlrPSHId
         klK5uuWUUFwrXdayoKJIJ5W1w/vJSr+QN77ZVYxLKbJl9KhGPwfDy4po7fyoMc26ehRv
         lBF8DUhjnUFG9VYifS3zoGRy2BgqdseMKrTL0gm7jBu77fKBM6Kb1kxnBX4AjirF8R0n
         MkTiiRHZ1nmldaPsh++JPmx37dm0siTpHQKTJwYwew3nktVqQeHoINdiuhna7AhuG2d3
         qzKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763748557; x=1764353357;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cysM1a5K8N5cRoV859ZjU5C+6NBB91KVPWuXuHes6mk=;
        b=dV3YVXKwq+g8ti+Ou7jXKFOjLkigyiOdwcCOmDZcOzRc1X5Z8ndeX5CnNN9oLBLlmJ
         snvFy1//MLgynGZDHqA6G54oXoSoQbxDOQfCAN84fjYSTdEsx2eIarQdvh9QQldSIEn+
         cvVITZMFrzDtyieLsPv+JejX/7PjB6fqdspPRs0wRbxWZTvfW9OWlTwBFKIl0EjwtwVJ
         HeSlilx64NREWT2NCzby1N4XY9UUf1R7hXPqI8XivELDw3kF5xM/yD5Mz+QgaMhx8kN8
         b3VN3w1TgvzIhmiiFLEpArYrm/NLngoUH1OZNHiVDcOIF4RewE/cK5WRx72YErKsmyA7
         EVaw==
X-Gm-Message-State: AOJu0Yz0NylHLxiZxWnaMJz5ZG1N3vv7C57VNSPPk+ww5qgtTVEL51SW
	twy5McXYCdkoE8NYRDDcv0Iqb7+8nuhpKJFLQ2Mwb2+eKj1k/PCYxJi7QPbUGf9nJTS+84siKNG
	u3ZbCXQ==
X-Google-Smtp-Source: AGHT+IFOVAoG0ccJY3BvwVvMYoQgGi4Emw3nu2druj3MU423jgSpr6hGbkvmD4iXFjB+5jAxLmfq1JkSFp4=
X-Received: from pjbms3.prod.google.com ([2002:a17:90b:2343:b0:343:7087:1d21])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:38c7:b0:340:ec6f:5ac5
 with SMTP id 98e67ed59e1d1-34733e55021mr2900996a91.2.1763748557442; Fri, 21
 Nov 2025 10:09:17 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 21 Nov 2025 10:08:54 -0800
In-Reply-To: <20251121180901.271486-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251121180901.271486-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc2.455.g230fcf2819-goog
Message-ID: <20251121180901.271486-5-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v2 04/11] x86: xsave: Add and use dedicated
 XCR0 read/write helpers
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Add dedicated {read,write}_xcr0{,_safe}() helpers so that tests don't need
to manually pass '0' for the common case of accessing XCR0.

Use the helpers in the XSTATE tests, and intentionally use the non-safe
variants for the initial writes to set XCR0=FP and XCR0=FP|SSE.  There is
no point continuing on if the most basic setup fails.

Opportunistically clean up the report messages to make them human friendly,
and fix typos in the xsetbv_safe(XCR_XFEATURE_ILLEGAL_MASK, SSE) report
message.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/processor.h | 38 +++++++++++++++++++++++++++++++
 x86/xsave.c         | 55 +++++++++++++++++----------------------------
 2 files changed, 59 insertions(+), 34 deletions(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 68bd774b..c3d3cacf 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -701,6 +701,44 @@ static inline int xsetbv_safe(u32 index, u64 value)
 	return wrreg64_safe(".byte 0x0f,0x01,0xd1", index, value);
 }
 
+static inline u64 xgetbv(u32 index)
+{
+	u64 value;
+	int vector = xgetbv_safe(index, &value);
+
+	assert_msg(!vector, "Unexpected exception '%s' reading XCR%u",
+		   exception_mnemonic(vector), index);
+	return value;
+}
+
+static inline void xsetbv(u32 index, u64 value)
+{
+	int vector = xsetbv_safe(index, value);
+
+	assert_msg(!vector, "Unexpected exception '%s' writing XCR%u = 0x%" PRIx64,
+		   exception_mnemonic(vector), index, value);
+}
+
+static inline int read_xcr0_safe(u64 *value)
+{
+	return xgetbv_safe(0, value);
+}
+
+static inline int write_xcr0_safe(u64 value)
+{
+	return xsetbv_safe(0, value);
+}
+
+static inline u64 read_xcr0(void)
+{
+	return xgetbv(0);
+}
+
+static inline void write_xcr0(u64 value)
+{
+	xsetbv(0, value);
+}
+
 static inline int write_cr0_safe(ulong val)
 {
 	return asm_safe("mov %0,%%cr0", "r" (val));
diff --git a/x86/xsave.c b/x86/xsave.c
index 9062484a..1ac0c25c 100644
--- a/x86/xsave.c
+++ b/x86/xsave.c
@@ -2,7 +2,6 @@
 #include "desc.h"
 #include "processor.h"
 
-#define XCR_XFEATURE_ENABLED_MASK	0x00000000
 #define XCR_XFEATURE_ILLEGAL_MASK	0x00000010
 
 #define XSTATE_FP	0x1
@@ -30,33 +29,23 @@ static void test_xsave(void)
 	       "Check CPUID.1.ECX.OSXSAVE - expect 1");
 
 	printf("\tLegal tests\n");
-	test_bits = XSTATE_FP;
-	report(xsetbv_safe(XCR_XFEATURE_ENABLED_MASK, test_bits) == 0,
-	       "\t\txsetbv(XCR_XFEATURE_ENABLED_MASK, XSTATE_FP)");
-
-	test_bits = XSTATE_FP | XSTATE_SSE;
-	report(xsetbv_safe(XCR_XFEATURE_ENABLED_MASK, test_bits) == 0,
-	       "\t\txsetbv(XCR_XFEATURE_ENABLED_MASK, XSTATE_FP | XSTATE_SSE)");
-	report(xgetbv_safe(XCR_XFEATURE_ENABLED_MASK, &xcr0) == 0,
-	       "\t\txgetbv(XCR_XFEATURE_ENABLED_MASK)");
+	write_xcr0(XSTATE_FP);
+	write_xcr0(XSTATE_FP | XSTATE_SSE);
+	(void)read_xcr0();
 
 	printf("\tIllegal tests\n");
-	test_bits = 0;
-	report(xsetbv_safe(XCR_XFEATURE_ENABLED_MASK, test_bits) == GP_VECTOR,
-	       "\t\txsetbv(XCR_XFEATURE_ENABLED_MASK, 0) - expect #GP");
+	report(write_xcr0_safe(0) == GP_VECTOR,
+	       "\t\tWrite XCR0 = 0 - expect #GP");
 
-	test_bits = XSTATE_SSE;
-	report(xsetbv_safe(XCR_XFEATURE_ENABLED_MASK, test_bits) == GP_VECTOR,
-	       "\t\txsetbv(XCR_XFEATURE_ENABLED_MASK, XSTATE_SSE) - expect #GP");
+	report(write_xcr0_safe(XSTATE_SSE) == GP_VECTOR,
+	       "\t\tWrite XCR0 = SSE - expect #GP");
 
 	if (supported_xcr0 & XSTATE_YMM) {
-		test_bits = XSTATE_YMM;
-		report(xsetbv_safe(XCR_XFEATURE_ENABLED_MASK, test_bits) == GP_VECTOR,
-		       "\t\txsetbv(XCR_XFEATURE_ENABLED_MASK, XSTATE_YMM) - expect #GP");
+		report(write_xcr0_safe(XSTATE_YMM) == GP_VECTOR,
+		       "\t\tWrite XCR0 = YMM - expect #GP");
 
-		test_bits = XSTATE_FP | XSTATE_YMM;
-		report(xsetbv_safe(XCR_XFEATURE_ENABLED_MASK, test_bits) == GP_VECTOR,
-		       "\t\txsetbv(XCR_XFEATURE_ENABLED_MASK, XSTATE_FP | XSTATE_YMM) - expect #GP");
+		report(write_xcr0_safe(XSTATE_FP | XSTATE_YMM) == GP_VECTOR,
+		       "\t\tWrite XCR0 = (FP | YMM) - expect #GP");
 	}
 
 	test_bits = XSTATE_SSE;
@@ -72,17 +61,15 @@ static void test_xsave(void)
 	       "Check CPUID.1.ECX.OSXSAVE - expect 0");
 
 	printf("\tIllegal tests:\n");
-	test_bits = XSTATE_FP;
-	report(xsetbv_safe(XCR_XFEATURE_ENABLED_MASK, test_bits) == UD_VECTOR,
-	       "\t\txsetbv(XCR_XFEATURE_ENABLED_MASK, XSTATE_FP) - expect #UD");
+	report(write_xcr0_safe(XSTATE_FP) == UD_VECTOR,
+	       "\t\tWrite XCR0=FP with CR4.OSXSAVE=0 - expect #UD");
 
-	test_bits = XSTATE_FP | XSTATE_SSE;
-	report(xsetbv_safe(XCR_XFEATURE_ENABLED_MASK, test_bits) == UD_VECTOR,
-	       "\t\txsetbv(XCR_XFEATURE_ENABLED_MASK, XSTATE_FP | XSTATE_SSE) - expect #UD");
+	report(write_xcr0_safe(XSTATE_FP | XSTATE_SSE) == UD_VECTOR,
+	       "\t\tWrite XCR0=(FP|SSE) with CR4.OSXSAVE=0 - expect #UD");
 
 	printf("\tIllegal tests:\n");
-	report(xgetbv_safe(XCR_XFEATURE_ENABLED_MASK, &xcr0) == UD_VECTOR,
-	       "\txgetbv(XCR_XFEATURE_ENABLED_MASK) - expect #UD");
+	report(read_xcr0_safe(&xcr0) == UD_VECTOR,
+	       "\tRead XCR0 with CR4.OSXSAVE=0 - expect #UD");
 }
 
 static void test_no_xsave(void)
@@ -99,11 +86,11 @@ static void test_no_xsave(void)
 	report(write_cr4_safe(cr4 | X86_CR4_OSXSAVE) == GP_VECTOR,
 	       "Set OSXSAVE in CR4 - expect #GP");
 
-	report(xgetbv_safe(XCR_XFEATURE_ENABLED_MASK, &xcr0) == UD_VECTOR,
-	       "Execute xgetbv - expect #UD");
+	report(read_xcr0_safe(&xcr0) == UD_VECTOR,
+	       "Read XCR0 without XSAVE support - expect #UD");
 
-	report(xsetbv_safe(XCR_XFEATURE_ENABLED_MASK, 0x3) == UD_VECTOR,
-	       "Execute xsetbv - expect #UD");
+	report(write_xcr0_safe(XSTATE_FP | XSTATE_SSE) == UD_VECTOR,
+	       "Write XCR0=(FP|SSE) without XSAVE support - expect #UD");
 }
 
 int main(void)
-- 
2.52.0.rc2.455.g230fcf2819-goog


