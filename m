Return-Path: <kvm+bounces-64194-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 2813FC7B3EE
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 19:13:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 796C54EFB08
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 18:09:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D785A34D4DC;
	Fri, 21 Nov 2025 18:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EFvxEPYx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A3742E6CD2
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 18:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763748563; cv=none; b=FTZtm9DocIBx2jh3tI/gEt/B/McK9gWUO6EBPQV86b9eYKpm6RsIr1UNK8YUb5bJxCx6gPseGpxdr9mNKgX9zsn2yL/yZt5d1wNFWlI50J3SjUGnw+UB/llOodQhLR/kRO5V3O42qE0yGYIsq/UzrnM2d0qIxcVT5yulcJdinTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763748563; c=relaxed/simple;
	bh=G/BD/d6Wi+LoTThPcwrIhMGTl5xHUA7IwelJVbpPbVA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FgzX6nxRDn6CbIGV4fooW1KIIn12MgIdnsRtS3YfbkAYbmOPC7UPMeDatp7v1/6Xx8bf+a/ogxgcc+L+dbmgZAXxiTCeH3s5XEZGRVcGGoaZ/9TdR8qRwCohw7F0omPDuyj2jpF1/LyDowNaadCEjZb1qTHHyarcd5b0K45fQ0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EFvxEPYx; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-340bc4ef67fso2864382a91.3
        for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 10:09:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763748561; x=1764353361; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=eFn6wz7px41rAdaujGibAWyqbnn/3mJwVS7lVuPunFc=;
        b=EFvxEPYxOW6rK6iGBVGiCIuqgFRnixhvNcHC69zqBpoKnJJogWmlZQSKywLgTpij+Q
         41M3Uv5/Foz3mIqApCqC3HP6iC8H/PLb8o9Sj7TZDw2OYrb7MnpodWeR+sUfhlUnWbpf
         G+9wUZWFZYhXhtFxeWPjndbNreooNi0h2lGVvaSX0d7A6ycg8M9KB28tEEB8CD1XTvcL
         n7eFWfK+1OX+wyMs7rBk9HvgfYQAUOFnr4/c+ylk9xnLntEksQi2aCKEc7pTLtM9k8jQ
         F9lPLd3ELsXEhv//u1QIZt5U72lE5n63PH42aQRJLNuLGGNdb07hSCNAdrBYmC60Wk4U
         PNxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763748561; x=1764353361;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eFn6wz7px41rAdaujGibAWyqbnn/3mJwVS7lVuPunFc=;
        b=NtdXtVIYeAAFul5lVjhUBO3uDFd1M5kNAWojEOM8eG5DLjEtrKIu9laqKNKF38Hs9D
         DMyZYtCoCOaRtCWdBkSFQaJfx3nfpByBg6uQ+PX9v91vsDQGcZ0lmYRRi/8hEbLM39G2
         MCoKTAALcPMP9MdrVSkU6KNYKqRN+qV+DPhkofjEchthgEasVYbAdW8PE4GCjsb7G8ib
         0crpZE9gGxjIQLWqguKALwWfXO4QJdXYmihSbmPcu0xfqqxLTc0+SEa/M2R9acV0YAly
         eHKvyMkThBjASED/rSU66GCJ2DfVUZTDrtgPKD0JgU3aS6s+HD3VGI+TpaVTjnVAJfCd
         Ce1w==
X-Gm-Message-State: AOJu0Yz1Im3b3VX1us1pXxfruTSHzEybDB66TeAfWpuAL5oeHZvQzlOn
	HaE7l5I02Pl+DSQKz5ABupVYKH975hEz1EhXKTaAaQbuUjjnWL0njq5axl+rP15mkzU34NSdKAZ
	5gdeC7A==
X-Google-Smtp-Source: AGHT+IGNe9GrKkEtEWWI5wVo6H7/OuuzSnEF2OR4/AZGmVSchV5AiYnqgpOrOPRSZ4WuYpF53DITogHHURc=
X-Received: from pjbjx18.prod.google.com ([2002:a17:90b:46d2:b0:343:641d:e8c3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2802:b0:32e:3829:a71c
 with SMTP id 98e67ed59e1d1-34733e6d4f0mr3734478a91.16.1763748560667; Fri, 21
 Nov 2025 10:09:20 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 21 Nov 2025 10:08:56 -0800
In-Reply-To: <20251121180901.271486-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251121180901.271486-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc2.455.g230fcf2819-goog
Message-ID: <20251121180901.271486-7-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v2 06/11] x86: xsave: Programmatically test
 more unsupported XCR accesses
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Expand the XSAVE test's coverage for unsupported XCRs to more than just
XCR16.  Somewhat arbitrarily test XCRs 1-63, and XCRs [bit1:bit31] as a
middle ground between hardcoding a few XCRs and exhaustively testing all
four billion possibilities.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/xsave.c | 45 ++++++++++++++++++++++++++++++++++++---------
 1 file changed, 36 insertions(+), 9 deletions(-)

diff --git a/x86/xsave.c b/x86/xsave.c
index ff093db8..a3645622 100644
--- a/x86/xsave.c
+++ b/x86/xsave.c
@@ -2,12 +2,45 @@
 #include "desc.h"
 #include "processor.h"
 
-#define XCR_XFEATURE_ILLEGAL_MASK	0x00000010
-
 #define XSTATE_FP	0x1
 #define XSTATE_SSE	0x2
 #define XSTATE_YMM	0x4
 
+static void test_unsupported_xcrs(void)
+{
+	u64 ign;
+	int i;
+
+	for (i = 1; i < 64; i++) {
+		/* XGETBV(1) returns "XCR0 & XINUSE" on some CPUs. */
+		if (i != 1)
+			report(xgetbv_safe(i, &ign) == GP_VECTOR,
+			       "XGETBV(%u) - expect #GP", i);
+
+		report(xsetbv_safe(i, XSTATE_FP) == GP_VECTOR,
+		      "XSETBV(%u, FP) - expect #GP", i);
+
+		report(xsetbv_safe(i, XSTATE_FP | XSTATE_SSE) == GP_VECTOR,
+		      "XSETBV(%u, FP|SSE) - expect #GP", i);
+
+		/*
+		 * RCX[63:32] are ignored by XGETBV and XSETBV, i.e. testing
+		 * bits set above 31 will access XCR0.
+		 */
+		if (i > 31)
+			continue;
+
+		report(xgetbv_safe(BIT(i), &ign) == GP_VECTOR,
+		       "XGETBV(0x%lx) - expect #GP", BIT(i));
+
+		report(xsetbv_safe(BIT(i), XSTATE_FP) == GP_VECTOR,
+		      "XSETBV(0x%lx, FP) - expect #GP", BIT(i));
+
+		report(xsetbv_safe(BIT(i), XSTATE_FP | XSTATE_SSE) == GP_VECTOR,
+		      "XSETBV(0x%lx, FP|SSE) - expect #GP", BIT(i));
+	}
+}
+
 static void test_xsave(void)
 {
 	u64 supported_xcr0, test_bits;
@@ -48,13 +81,7 @@ static void test_xsave(void)
 		       "\t\tWrite XCR0 = (FP | YMM) - expect #GP");
 	}
 
-	test_bits = XSTATE_SSE;
-	report(xsetbv_safe(XCR_XFEATURE_ILLEGAL_MASK, test_bits) == GP_VECTOR,
-	       "\t\txsetbv(XCR_XFEATURE_ILLEGAL_MASK, XSTATE_FP) - expect #GP");
-
-	test_bits = XSTATE_SSE;
-	report(xsetbv_safe(XCR_XFEATURE_ILLEGAL_MASK, test_bits) == GP_VECTOR,
-	       "\t\txgetbv(XCR_XFEATURE_ILLEGAL_MASK, XSTATE_FP) - expect #GP");
+	test_unsupported_xcrs();
 
 	write_cr4(cr4);
 
-- 
2.52.0.rc2.455.g230fcf2819-goog


