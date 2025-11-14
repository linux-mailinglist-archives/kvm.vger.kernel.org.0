Return-Path: <kvm+bounces-63262-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 149D0C5F46D
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 21:51:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BB995420B36
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 20:51:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF0612FCC04;
	Fri, 14 Nov 2025 20:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1+7oiXpG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97DF82FB0B5
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 20:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763153478; cv=none; b=jPy3Mr0zlcahWzmWBwp5tXph1STzNNJAdIqrAHW0PdM+LpjoNu0x1q1Ig3cddKFWinjiiJwcg9gMnhWMjAO/bog91NVAeS23xmcBvDb0DCLg6MA14YoGnw0Qr53nlfhV4s/GUDUzxuraIorvg5MGvfpx0xeinK+qQYFDSJIkC5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763153478; c=relaxed/simple;
	bh=PL3Qhn7iqi/F3cJTiDIoK+i7tq0WNOMmbjMemBAGU5o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pQawWuxu0irUmknLPzDhYabeNanyzGocqTzp+wFTp9amF5Fei69onI1TbP/f6Ufo0z3HGJUNogVzJIL1R7o/EbuHsE6h0a0P9V9sANIWD6oH58RluPoY1lbJ1EdndVsQTvqznFTaATAUFQXKGZzViaR9MmUZEnomO/VWMArlhh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1+7oiXpG; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-340ad9349b3so5761265a91.1
        for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 12:51:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763153476; x=1763758276; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=AlrJv6PsuPgoMU2zaUNJTWd5rKIuTNoQ9zZEmw0g4i8=;
        b=1+7oiXpG/H6ma8M/pZCxqc6H5I34BX3X2hGalk06Nx3C3/PPJBsOOLGU608rJA8bgn
         UJdCip+1fXWNBwFOheby6yi/oecSIo6JX2sNFbQXk9j1IL9Wlh78+RfYCqtV/X9ocynd
         EMD+8IrAmAG8edWctvt2GSHMqT1zo4pauZwUDcpEUp5VcpGIShKvGbQalGjGnKrCE1Pw
         c1aVYxGfra4JRUz5HVq+1VJqb2Dy6anUY61kn/EXC6lAzUqY4P/QIZQQ9zD9wR9q3rl4
         UhEcHYEkOgPbKpXAKZXyfN7dX4lqEcLW9Wue20qprPr5J0Uq0L4SRI0KIv6J4LK4iuFv
         20IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763153476; x=1763758276;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AlrJv6PsuPgoMU2zaUNJTWd5rKIuTNoQ9zZEmw0g4i8=;
        b=jdPKDSA+Mb5hYJBJJkj8XKRTAsY8yQDyX34NuPLh4fVYN9PGW5cxxw9rcDA0bMXedO
         pyl75mB9qVme45AjAXWCr5GgbEL0NEe84rA2GmqehyRZStChNRRnsotXG35a/5n0Zgjc
         x3YP24++DoW0xUqxX0Dd85jJ2udj21JTX92rLjU1LTiQ4hheOSerleG8BqcPCE/FlyXR
         QO4K4tk8PMZmV3X0hhIXVeeamVDirogcvt2z9YETqkvxAXlmd52exqpeABgJF+sYXPhl
         BTmIvvJvPgeYqpbniCiq9yG2AjZguCwwIabS0Xz3FdU1HQ0gspqH7aEdm7p4XMQd7Dm8
         MSwA==
X-Gm-Message-State: AOJu0Yw6Ty1dJ2Y5ebjjArI6cPaFOYgH+NfMr5mEEEIDPNa+ofj46rtG
	kfrNXliCbYrP0+mPw717xxXFxb2adTh7AST2E9YY+RwTtHzQ7jOSogJspHTk+uD/e4YwvS67LmQ
	ES9yP4g==
X-Google-Smtp-Source: AGHT+IF9NeaeyZbf0PRheTZByz29Py2Per/MvLjijNUqvYwKsUacvtGMw/hk9oquxHHvG2mdvZ3oaUBK+gQ=
X-Received: from pjbgc23.prod.google.com ([2002:a17:90b:3117:b0:343:685d:292f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4d0d:b0:340:c261:f9db
 with SMTP id 98e67ed59e1d1-343fa0d7297mr4688428a91.10.1763153475928; Fri, 14
 Nov 2025 12:51:15 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 14 Nov 2025 12:50:48 -0800
In-Reply-To: <20251114205100.1873640-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251114205100.1873640-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251114205100.1873640-7-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v4 06/18] x86: cet: Drop unnecessary casting
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Chao Gao <chao.gao@intel.com>, 
	Mathias Krause <minipli@grsecurity.net>, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Chao Gao <chao.gao@intel.com>

cet_shstk_func() and cet_ibt_func() have the same type as usermode_func.
So, remove the unnecessary casting.

Signed-off-by: Chao Gao <chao.gao@intel.com>
[mks: make the types really equal by using uint64_t]
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/cet.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/x86/cet.c b/x86/cet.c
index d6ca5dd8..8c2cf8c6 100644
--- a/x86/cet.c
+++ b/x86/cet.c
@@ -8,7 +8,7 @@
 #include "alloc_page.h"
 #include "fault_test.h"
 
-static u64 cet_shstk_func(void)
+static uint64_t cet_shstk_func(void)
 {
 	unsigned long *ret_addr, *ssp;
 
@@ -31,7 +31,7 @@ static u64 cet_shstk_func(void)
 	return 0;
 }
 
-static u64 cet_ibt_func(void)
+static uint64_t cet_ibt_func(void)
 {
 	/*
 	 * In below assembly code, the first instruction at label 2 is not
@@ -93,13 +93,13 @@ int main(int ac, char **av)
 	write_cr4(read_cr4() | X86_CR4_CET);
 
 	printf("Unit test for CET user mode...\n");
-	run_in_user((usermode_func)cet_shstk_func, CP_VECTOR, 0, 0, 0, 0, &rvc);
+	run_in_user(cet_shstk_func, CP_VECTOR, 0, 0, 0, 0, &rvc);
 	report(rvc && exception_error_code() == 1, "Shadow-stack protection test.");
 
 	/* Enable indirect-branch tracking */
 	wrmsr(MSR_IA32_U_CET, ENABLE_IBT_BIT);
 
-	run_in_user((usermode_func)cet_ibt_func, CP_VECTOR, 0, 0, 0, 0, &rvc);
+	run_in_user(cet_ibt_func, CP_VECTOR, 0, 0, 0, 0, &rvc);
 	report(rvc && exception_error_code() == 3, "Indirect-branch tracking test.");
 
 	write_cr4(read_cr4() & ~X86_CR4_CET);
-- 
2.52.0.rc1.455.g30608eb744-goog


