Return-Path: <kvm+bounces-48592-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 62C29ACF7C6
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 21:22:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4AD8D1762D4
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 19:22:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB5F727A915;
	Thu,  5 Jun 2025 19:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XVNzuNN6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99A6C27CB02
	for <kvm@vger.kernel.org>; Thu,  5 Jun 2025 19:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749151360; cv=none; b=SVEkz/KCmIzlGO6lx0uK+iZlz++wG8+8ZpCTEUGs+lHapJhh4IklHPe8Meh5hDfrc0nK//iZ5Mu0wvnZv8Vt51L6TqauTZjUGirEKzq5PQzmX3rEHx9zqrwPplBF4eyZbp2APKgz3afxkaS2Q1XBld/BZWWo/HPR3V9uKAeNaUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749151360; c=relaxed/simple;
	bh=B4HkJzsqKbx9SbCySSd9jhS9d3PalKO/jtuAdD6Ha8E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lXDFs7/w7Uj8zbt4b6arOOaP1Q8W1N2ghIQd/Cm2IUhAAqyqVrQwT9X+yHHeUATTrVI0dK7StFAZpQvkLWiukCnfrjej4DuUX982v8Z8kzxwyCFcnDluF6Y5+kKiUP+cob1qqqmFB7lm3q+F2MMMdkPUofylf1tVNUYuarMgoEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XVNzuNN6; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b2c38df7ed2so932940a12.3
        for <kvm@vger.kernel.org>; Thu, 05 Jun 2025 12:22:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749151358; x=1749756158; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Geg4DUgP+1CF7jZ+6jr2Cd9JkGs1fntSgiwVVDtVd0s=;
        b=XVNzuNN6LLAp1Fab33H9JHh39n2puY1KbbKTXzKW+1/9uTjLrhDIvTEX2oCz9AX7Y1
         DTIexEOb8aRRIv7vIKR4T0O5Mm7qwl1ZESGdUnIr0ekvC2KLBu4ElgaAVvznt0DH4FQr
         cJaxmh9OJxEFIpqv4zUzn7cDy0zctt6b+lY6+CixUxa4HUCTrLrHsxq0PWEJA48oXIOQ
         YHvfz6XeTOMvWgBDBRPYzzXAfcADdo3xwq7hH3rGHFGYQNiZsxS5jjPMo6f+K3e1Qm+u
         A8X+Rl8ZswaM1Zr+LSoGJQSnsvC4RpbbLKyTqtumggWFlyWagp6hGvSPYNeZV4cmN+9Q
         +uZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749151358; x=1749756158;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Geg4DUgP+1CF7jZ+6jr2Cd9JkGs1fntSgiwVVDtVd0s=;
        b=OLqW9wJcMzGkXtSo1xNNaBd1v/y/ngFxfDbb02B3neTYfpSdX3Az+X74JP94qZxKgt
         lUBCKU5p7pXlTvqzp4t+FpMvS9s2xeZVmKHCrkzDOP3+vnWTAUqvrERzApc+qI6yKYo3
         5IMbq/WNd6FGTXeHqSQJAjXLUhbSUU3wLlVLiF9VZnwHdU+fo5GGA1W1//N4G5MlixZB
         KXjdpKprzVMZkhQH0jjudhe9Q7iPreHjD5S1ypenuARIHssR8O8qCrhmhST0GJPSW2E3
         Bkrm5qgeYd4Bi7s/KMCWyosilKwVuJH3zIw4b/Rdj312o6XoFBJGQotBNGEg9ypoPp5Z
         zlOA==
X-Gm-Message-State: AOJu0YwZUb7hlaDpi7Sgy0XfwDfKUtUFlBdTj3GSlrpUqHZuLoOzrCbw
	1djbPmkDsq0ls4gPXaJp60GlQxywu2JoPMbXzoavsnrSBa3Qwt4ieAJc/dz11o7NhI2q23DbDpw
	dVASQLA==
X-Google-Smtp-Source: AGHT+IESpC8+telrH9+l4MsefBLON8nWM7eDOoWQkB3osnrVkyYlRipjfhKpeU6cyfke5EgYIpP1n3aV7L4=
X-Received: from pjbsr4.prod.google.com ([2002:a17:90b:4e84:b0:30a:7da4:f075])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5345:b0:311:ffe8:20e9
 with SMTP id 98e67ed59e1d1-31347308c79mr1476305a91.17.1749151357870; Thu, 05
 Jun 2025 12:22:37 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  5 Jun 2025 12:22:21 -0700
In-Reply-To: <20250605192226.532654-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250605192226.532654-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.604.gd4ff7b7c86-goog
Message-ID: <20250605192226.532654-4-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v2 3/8] x86: nSVM: Clean up variable types and
 names in test_msr_intercept()
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Use a u64 for the MSR value and a u32 for the index to match the actual
sizes of MSR values and indices, and opportunistically tweak the names
to shorten line lengths and prepare for future enhancements.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/svm_tests.c | 43 +++++++++++++++++++++----------------------
 1 file changed, 21 insertions(+), 22 deletions(-)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 1795d7f6..5d06249f 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -317,13 +317,12 @@ static void prepare_msr_intercept(struct svm_test *test)
 
 static void test_msr_intercept(struct svm_test *test)
 {
-	unsigned long msr_value = 0xef8056791234abcd; /* Arbitrary value */
-	unsigned long msr_index;
-	u64 ignored;
+	u64 ignored, arb_val = 0xef8056791234abcd; /* Arbitrary value */
 	int vector;
+	u32 msr;
 
-	for (msr_index = 0; msr_index <= 0xc0012000; msr_index++) {
-		if (msr_index == 0xC0010131 /* MSR_SEV_STATUS */) {
+	for (msr = 0; msr <= 0xc0012000; msr++) {
+		if (msr == 0xC0010131 /* MSR_SEV_STATUS */) {
 			/*
 			 * Per section 15.34.10 "SEV_STATUS MSR" of AMD64 Architecture
 			 * Programmer's Manual volume 2 - System Programming:
@@ -337,34 +336,34 @@ static void test_msr_intercept(struct svm_test *test)
 		 * Test one MSR just before and after each range, but otherwise
 		 * skips gaps between supported MSR ranges.
 		 */
-		if (msr_index == 0x2000 + 1)
-			msr_index = 0xc0000000 - 1;
-		else if (msr_index == 0xc0002000 + 1)
-			msr_index = 0xc0010000 - 1;
+		if (msr == 0x2000 + 1)
+			msr = 0xc0000000 - 1;
+		else if (msr == 0xc0002000 + 1)
+			msr = 0xc0010000 - 1;
 
 		test->scratch = -1;
 
-		vector = rdmsr_safe(msr_index, &ignored);
+		vector = rdmsr_safe(msr, &ignored);
 		if (vector)
-			report_fail("Expected RDMSR(0x%lx) to #VMEXIT, got exception '%u'",
-				    msr_index, vector);
-		else if (test->scratch != msr_index)
-			report_fail("Expected RDMSR(0x%lx) to #VMEXIT, got scratch '%ld",
-				    msr_index, test->scratch);
+			report_fail("Expected RDMSR(0x%x) to #VMEXIT, got exception '%u'",
+				    msr, vector);
+		else if (test->scratch != msr)
+			report_fail("Expected RDMSR(0x%x) to #VMEXIT, got scratch '%ld",
+				    msr, test->scratch);
 
 		/*
 		 * Poor man approach to generate a value that
 		 * seems arbitrary each time around the loop.
 		 */
-		msr_value += (msr_value << 1);
+		arb_val += (arb_val << 1);
 
-		vector = wrmsr_safe(msr_index, msr_value);
+		vector = wrmsr_safe(msr, arb_val);
 		if (vector)
-			report_fail("Expected WRMSR(0x%0lx) to #VMEXIT, got exception '%u'",
-				    msr_index, vector);
-		else if (test->scratch != msr_value)
-			report_fail("Expected WRMSR(0x%lx) to #VMEXIT, got scratch '%ld' (wanted %ld)",
-				    msr_index, test->scratch, msr_value);
+			report_fail("Expected WRMSR(0x%x) to #VMEXIT, got exception '%u'",
+				    msr, vector);
+		else if (test->scratch != arb_val)
+			report_fail("Expected WRMSR(0x%x) to #VMEXIT, got scratch '%ld' (wanted %ld)",
+				    msr, test->scratch, arb_val);
 	}
 
 	test->scratch = -2;
-- 
2.50.0.rc0.604.gd4ff7b7c86-goog


