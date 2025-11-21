Return-Path: <kvm+bounces-64193-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D65EC7B3E2
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 19:13:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 4E4D74EF848
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 18:09:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C11A34846A;
	Fri, 21 Nov 2025 18:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ed7EmmfT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCD6A223DD6
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 18:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763748561; cv=none; b=XmiQ03w9mvelZxeAYThNRTgh8iVmgFHBRS7IxrPDvPa988tSHnUMiWLfVt65PyvjPuVxx18nxTuq7FK1jDjrFSMGhStn6d72mIkllBPU7sdYol5XkPJqoAP61eSUS6lMpxWY5CtEfoql3/x9k7Ra5Dr4BZcqGCjJCaMFt5IZkLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763748561; c=relaxed/simple;
	bh=hDJGqCMTZJ1S33HtGBWg7xZ824mcbOv3kjmHK6PrkqQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lngXC5a/mbdTYj5KyqZP8PA0Y6TsLmIJDOqXFY4tUf3hw6L/8+KKl/zKT7V7VfNWuUEgRi0RLvHKZ8ru4Zv7zEj8luHeX/X05GJRs3qR782ZLABHDf/IRwIUPs/3OqyBV0C2Y7AsAvcquR6BXl3LDZ2jTuQti5A/uOOCTOIE8qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ed7EmmfT; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-297fbfb4e53so40509185ad.1
        for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 10:09:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763748559; x=1764353359; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=gQj9aYAbFp3twBXrffVQBBv31kFSpE3ISk53q1sGC3Y=;
        b=ed7EmmfT/3NNnqvHFgYXe7Bm/3YABquye3zLxeZkrnEis7AnPT9DF0OqRjUcmbP4xv
         Jz1LVEObax/q02T/g7vKRe4mZN+xFSTXg/j7253IaeF45xXNVwMcaSYWw8B5vzF5AZvh
         7ZwYdNGZ5FZkltE83sULMKsdxXwAb2ZgBCxyuk14T4Ch/rSC+JGIzg2fG/xnO7Zh+1Mv
         iFjU5HUaYwLsjmZNW1iNeKVMuq87oypdogVQfJgu0krTs1Yf4685X6oxZoFsi8KRQtng
         c7pS2gZ9Vh6yih+5blFhV46uIOtMN4s/a3AbfK/qahL6pSOc8xJ73Xw0Aq7VELdAg//L
         t2wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763748559; x=1764353359;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gQj9aYAbFp3twBXrffVQBBv31kFSpE3ISk53q1sGC3Y=;
        b=Ch1G9tGA2xD1gEwna348vVHfETIGY4ovcbxQrj6jvOH6KLNypcZ+/J8WoEtJMK1a6d
         M6mON/PKlAutEWpSDVvOZspPNUltx5ZuHH4sC26IZXfafj0z/uJ1Omc/0TtXzr9butqX
         Pgy3u+VeFGHYO1DJZBEEkP8HzekmVCcalzi+xBUszN3YHnRj9p4IA7vwRNClpYOIS/be
         Q51/SH7Oc53OemeEzUQ/YfHHP6GFo/1ChBZbDzGMgRNZow0zB4sAL+IBdBsyqCPnk0Vs
         U4nmz9m6Xigj6O4soX8o9SdrwHyvZjxO7PLZQxwAAa4O91sp/QmDTIrgkfPcgWARBkdl
         7EPA==
X-Gm-Message-State: AOJu0YzGNd/TezXqcQzDHGsb5tgS5t9UpSKCyMFS+GLlc6XM8dQNWioL
	J7QCOvnvi2myg6kJNYoY5yNOdlGuLzCO26NCrlETSkKf3uJURejJT1M/gaYWddbLmo7xaRiduPw
	N74+JEA==
X-Google-Smtp-Source: AGHT+IHYMmmwdLuXvnCTkUmqmuFeVHxSgRnEcnZa5QYrG6+y2DYfytetjfi7GLm/qy0I6e+FFM0efPRhkQ4=
X-Received: from pghg2.prod.google.com ([2002:a63:e602:0:b0:bac:a20:5ef4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d588:b0:296:3f23:b910
 with SMTP id d9443c01a7336-29b6be866f4mr32906375ad.9.1763748559085; Fri, 21
 Nov 2025 10:09:19 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 21 Nov 2025 10:08:55 -0800
In-Reply-To: <20251121180901.271486-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251121180901.271486-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc2.455.g230fcf2819-goog
Message-ID: <20251121180901.271486-6-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v2 05/11] x86: xsave: Dedup XGETBV and XSETBV
 #UD tests
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Deduplicate the "no XSAVE support" and "CR4.OSXSAVE=0" #UD tests as the
two scenarios are identical for all intents and purposes.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/xsave.c | 44 +++++++++++++++++++-------------------------
 1 file changed, 19 insertions(+), 25 deletions(-)

diff --git a/x86/xsave.c b/x86/xsave.c
index 1ac0c25c..ff093db8 100644
--- a/x86/xsave.c
+++ b/x86/xsave.c
@@ -10,7 +10,7 @@
 
 static void test_xsave(void)
 {
-	u64 supported_xcr0, xcr0, test_bits;
+	u64 supported_xcr0, test_bits;
 	unsigned long cr4;
 
 	printf("Legal instruction testing:\n");
@@ -56,51 +56,45 @@ static void test_xsave(void)
 	report(xsetbv_safe(XCR_XFEATURE_ILLEGAL_MASK, test_bits) == GP_VECTOR,
 	       "\t\txgetbv(XCR_XFEATURE_ILLEGAL_MASK, XSTATE_FP) - expect #GP");
 
-	write_cr4(cr4 & ~X86_CR4_OSXSAVE);
-	report(this_cpu_has(X86_FEATURE_OSXSAVE) == 0,
-	       "Check CPUID.1.ECX.OSXSAVE - expect 0");
+	write_cr4(cr4);
 
-	printf("\tIllegal tests:\n");
-	report(write_xcr0_safe(XSTATE_FP) == UD_VECTOR,
-	       "\t\tWrite XCR0=FP with CR4.OSXSAVE=0 - expect #UD");
-
-	report(write_xcr0_safe(XSTATE_FP | XSTATE_SSE) == UD_VECTOR,
-	       "\t\tWrite XCR0=(FP|SSE) with CR4.OSXSAVE=0 - expect #UD");
-
-	printf("\tIllegal tests:\n");
-	report(read_xcr0_safe(&xcr0) == UD_VECTOR,
-	       "\tRead XCR0 with CR4.OSXSAVE=0 - expect #UD");
+	report(this_cpu_has(X86_FEATURE_OSXSAVE) == !!(cr4 & X86_CR4_OSXSAVE),
+	       "CPUID.1.ECX.OSXSAVE == CR4.OSXSAVE");
 }
 
 static void test_no_xsave(void)
 {
-	unsigned long cr4;
+	unsigned long cr4 = read_cr4();
 	u64 xcr0;
 
+	if (cr4 & X86_CR4_OSXSAVE)
+		write_cr4(cr4 & ~X86_CR4_OSXSAVE);
+
 	report(this_cpu_has(X86_FEATURE_OSXSAVE) == 0,
 	       "Check CPUID.1.ECX.OSXSAVE - expect 0");
 
-	printf("Illegal instruction testing:\n");
-
-	cr4 = read_cr4();
-	report(write_cr4_safe(cr4 | X86_CR4_OSXSAVE) == GP_VECTOR,
-	       "Set OSXSAVE in CR4 - expect #GP");
-
 	report(read_xcr0_safe(&xcr0) == UD_VECTOR,
-	       "Read XCR0 without XSAVE support - expect #UD");
+	       "Read XCR0 without OSXSAVE enabled - expect #UD");
 
 	report(write_xcr0_safe(XSTATE_FP | XSTATE_SSE) == UD_VECTOR,
 	       "Write XCR0=(FP|SSE) without XSAVE support - expect #UD");
+
+	if (cr4 & X86_CR4_OSXSAVE)
+		write_cr4(cr4);
 }
 
 int main(void)
 {
+	test_no_xsave();
+
 	if (this_cpu_has(X86_FEATURE_XSAVE)) {
-		printf("CPU has XSAVE feature\n");
 		test_xsave();
 	} else {
-		printf("CPU don't has XSAVE feature\n");
-		test_no_xsave();
+		report_skip("XSAVE unsupported, skipping positive tests");
+
+		report(write_cr4_safe(read_cr4() | X86_CR4_OSXSAVE) == GP_VECTOR,
+		       "Set CR4.OSXSAVE without XSAVE- expect #GP");
 	}
+
 	return report_summary();
 }
-- 
2.52.0.rc2.455.g230fcf2819-goog


