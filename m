Return-Path: <kvm+bounces-64198-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id D671AC7B3F7
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 19:13:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 6E2424F0483
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 18:09:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F26522DFA25;
	Fri, 21 Nov 2025 18:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BBsDLT5S"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F8CF34EEE3
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 18:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763748570; cv=none; b=ReRGV38xnt03t9dh98MNQ9rpbsRecX3o+r16xxcXUMmA8+/yy+PjstHUGjMcUzJbSNwp0+B+GgLJ91UYVL198k6dPw2TlRLfJPHVBQ7LZR4zeyr2iJrhrvxaam1Gqz46zJMPVN1Jc3IZr2ay050xEnSS+5M5pw9Ji8Ojca3SoZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763748570; c=relaxed/simple;
	bh=o1S4QmYB3mqZY0hSsB1EgpFpwXHtesNntL2cRuVgdIw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jyjBCrzQ2lYngE4aDjjh5/eEV4u8LdGjQ+WQNaqyLFZmHlVx4vvvGPS+EzgvgTbk48K28f7Uq5dDRP9tKsz4FhVKMsyD7BL7lIPMqavoU4DdwzQfg4N7RSxdh6IqtZnmGVhdBpbt84/+DA9qw2FN43JFZsGkzmZyWHpnw493ZBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BBsDLT5S; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2956f09f382so16644865ad.1
        for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 10:09:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763748568; x=1764353368; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=0Q20xdBdUTA9+SurjdLCRqhKAER/0k6/P8NzI82WfRM=;
        b=BBsDLT5SVYBVDnDgas7sreFop9X9us4RLhAIrqtesq/GmMLFamUNwHYQWn36TyxZ2j
         ayuekondV2hATP6SumRAgYhiQOsNZZMLQ5E3hKv+M/9y66b/MIai7cNIJELrP1qjBHU8
         kwKL1EFUcdY7Qp/XZDB0vCI88UJD0vNRrZVva3KXfDSruPbKYTMFvdr8XHNw2yGUSCX8
         za1BrB5jaTjIYJieFvL8L+CLqVAqsRiuYeb/zlt0NMcxcmM0UcNWiYltl3o2+oKz06wn
         OEZzpsw9t8tySz0cx+sraC51vRydGkcto82tR6LNJlaxSup5EFZ1cO7ZtZIJd01kpF5t
         a4OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763748568; x=1764353368;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0Q20xdBdUTA9+SurjdLCRqhKAER/0k6/P8NzI82WfRM=;
        b=M9OrRgqYRaPe+w4eXhJwYjl+b8SZEcwZRqs1BaVl8KW5WAFzmA6BbLWP3V0fCHVUBf
         3iVxeXPZUxZcZp89pH9Y49HxepKovULBzil6ln2DwXESYcbYJi5V6fyJYXS9QcAjjmBf
         YuwAT24ggEYyLRR68xpx2YvisJJb0NwOX0oFQtVX3EJK23r1OLtFMDyhtF1vmQWVlyRI
         BgLC5BmkjbSB5PPFJUu+8WyiiZEO4iczVRcHoZBPeN4YpheEZZ8qW0cwYkKQLV7zhE5c
         bwUk3CJxUN9tpq3S63F+1W1ZYSR9fK7mDfAjdY5Y/dYhEwIxrD0qZ3wPmGNvfDdpHyXI
         lnpA==
X-Gm-Message-State: AOJu0Yy41ycCP4o9UNL9004mMx5uNdhw1GCk5mOwDZW69nBlJOk+qd3M
	+m7r6UjsykvKkQ0dvQM/g+F8qbFTwkhwSpgKBR8Lfd/s1DAO/IvVHn/uJd6g6ha2UZMMPMvtPuh
	FAYeETQ==
X-Google-Smtp-Source: AGHT+IFK0gKNcblbUe3YWfEMUmMiXiiU5hz8XiNkQw3hdM7FiVBHpqSlJKMAQkBMW5JtFEOW6Ad6HZ7Hfjs=
X-Received: from plbjb17.prod.google.com ([2002:a17:903:2591:b0:297:eb04:dff1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f78c:b0:297:eb3c:51ed
 with SMTP id d9443c01a7336-29b5e38c16dmr86769975ad.16.1763748567900; Fri, 21
 Nov 2025 10:09:27 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 21 Nov 2025 10:09:00 -0800
In-Reply-To: <20251121180901.271486-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251121180901.271486-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc2.455.g230fcf2819-goog
Message-ID: <20251121180901.271486-11-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v2 10/11] x86: xsave: Drop remaining
 indentation quirks and printf markers
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Drop the remaining tab indentationa and "legal" vs. "illegal" markers in
the XSAVE test.  Now that there are more than a handful of testscases, the
annotations just get in the way.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/xsave.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/x86/xsave.c b/x86/xsave.c
index 54905e06..0763f893 100644
--- a/x86/xsave.c
+++ b/x86/xsave.c
@@ -113,8 +113,6 @@ static void test_xsave(void)
 	u64 supported_xcr0;
 	unsigned long cr4;
 
-	printf("Legal instruction testing:\n");
-
 	supported_xcr0 = this_cpu_supported_xcr0();
 	printf("Supported XCR0 bits: %#lx\n", supported_xcr0);
 
@@ -127,26 +125,24 @@ static void test_xsave(void)
 	report(this_cpu_has(X86_FEATURE_OSXSAVE),
 	       "Check CPUID.1.ECX.OSXSAVE - expect 1");
 
-	printf("\tLegal tests\n");
 	test_write_xcr0(XFEATURE_MASK_FP);
 	test_write_xcr0(XFEATURE_MASK_FP_SSE);
 
 	if (supported_xcr0 & XFEATURE_MASK_YMM)
 		test_avx_vmovdqa();
 
-	printf("\tIllegal tests\n");
 	report(write_xcr0_safe(0) == GP_VECTOR,
-	       "\t\tWrite XCR0 = 0 - expect #GP");
+	       "Write XCR0 = 0 - expect #GP");
 
 	report(write_xcr0_safe(XFEATURE_MASK_SSE) == GP_VECTOR,
-	       "\t\tWrite XCR0 = SSE - expect #GP");
+	       "Write XCR0 = SSE - expect #GP");
 
 	if (supported_xcr0 & XFEATURE_MASK_YMM) {
 		report(write_xcr0_safe(XFEATURE_MASK_YMM) == GP_VECTOR,
-		       "\t\tWrite XCR0 = YMM - expect #GP");
+		       "Write XCR0 = YMM - expect #GP");
 
 		report(write_xcr0_safe(XFEATURE_MASK_FP | XFEATURE_MASK_YMM) == GP_VECTOR,
-		       "\t\tWrite XCR0 = (FP | YMM) - expect #GP");
+		       "Write XCR0 = (FP | YMM) - expect #GP");
 	}
 
 	test_unsupported_xcrs();
-- 
2.52.0.rc2.455.g230fcf2819-goog


