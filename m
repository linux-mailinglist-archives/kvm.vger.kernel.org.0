Return-Path: <kvm+bounces-50839-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E281AEA1AC
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 17:00:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C86555A6E4D
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 14:54:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1ED6D2F365F;
	Thu, 26 Jun 2025 14:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DK9hezrp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D2342EB5C2
	for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 14:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750949363; cv=none; b=IejKzo6o6XFgs4XEtatzfxZEm6/aZgEmOprnfcU05ZYmop7gGQdn4J1+FaQtrWltlhUhuvMo+gsuuACkUuNSd6f5WmiAF2gTQgNkgoMkuqGn2tQim1gJUC5F3qTewMCFgOEY8HthttsC7zpeeWg2HW33/Qo8QEJ4mZxtSMq760A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750949363; c=relaxed/simple;
	bh=7I0KkfMozSmWmOJFqIYPWGWMo0l1yuJq2E+dyh3oxN4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Er9QpvRWOwCHdmO799TLlD0Cq5KDvTGrTZi2qKXNQhmFHwTCbxgf6SaRO2eTimFon4k5sZbYYMUZAcuUumDZUn1RLBnnbG8DRoS1x1glqf4F6FctDZ1F0xGliO5BGq1TOfaSl/ts0ai0Ueq8wKejSZpi1fzQ5oFTVkxkkEPC1To=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DK9hezrp; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b115fb801bcso1160542a12.3
        for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 07:49:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750949360; x=1751554160; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=w8Q2VXXKCy8uCDy91bAW48HYprxI/+gEXH10G1t7AxI=;
        b=DK9hezrpNTO96nC1qSIptNDqz1p8JOcArWcYm1iTPLerkkGHtnilq2/ddVyhzYa8En
         S2xYHEyevTpYqKefjLTdZMI/CcaXbOj/VG9qZUYcvLzTtJbCWcKokzRQjMEn4nWuncMz
         PQuCcN3gfWm+38b2ILY5rwnw0GB6hqtiVzB4xxMOIk+ydKxkQtaXIL6pu3Uu+omfcQlL
         qXalSVnx7hv56yFk6+S1HFIYgJcSx5536L1tMDuVhPk/LZLrCHTonZYMUt27cESxR8Tf
         zLz7m3Z+FtNYTNFgzJw8egoWzTh2eQJwDz4gg55ONR4NFNFumIxRKFJTKGzd+MHU/RmX
         9pWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750949360; x=1751554160;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w8Q2VXXKCy8uCDy91bAW48HYprxI/+gEXH10G1t7AxI=;
        b=wjQXV43ySd3Dn9VF+AGNj84L0D2XubVqZwTgxtBVBPKTB9WpkACkpB33oqgN1gObqR
         ryZDFoyNrP89VXTfkDnY/r2mW+yvzplAudAEXNAED0cytRiwF3Ytzda2LPzSpDt7hYJp
         pobU1vYJl97Srvsjmc4DwIFzTvFqeoJQuIV5Nh0taG5eywsGm0by1liLCgZinefBAlc0
         Td5kYAfIibLZG08zybiW4hjyzKyvDN8ZEBx9L+ySQvz4/bMEV7CkIVEyismj27dZYCpo
         3tD0jVamXtpPNmAWZL1JvnMLrRXlT2oSK0a+H4Rm5OumndwmYz+ohbXZW9wvP2KBhM3q
         0S1w==
X-Forwarded-Encrypted: i=1; AJvYcCU8UTIvIHdXyKbkBPspm14Ge9aSWS7Q07wMkRXLTuaLeg80Ji0YuHs3uCj5Uvr9o8J9dAM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzw2XSukEqLkgyJ0uSAPmr5Uz18WAmqVcsUkGveCGIOkMv2P/Ra
	4LPh+BKbBTIJjA9dG+tiSlERXXC+Fjm5qFqaLbn9Y8KnWVDuAfxCFmoiiwHItuOoybspKtywC8q
	OwXpAXQ==
X-Google-Smtp-Source: AGHT+IFS8+wZ4+y5mkFJRyDOuVy9lAQaFYGrh6js0FtXmr+9KAl1rBk6sjWRGmK0T9FMrSujnNEMnAiy/Ig=
X-Received: from pfbbd20.prod.google.com ([2002:a05:6a00:2794:b0:746:fd4c:1fcf])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:2453:b0:220:25c4:1881
 with SMTP id adf61e73a8af0-2207f2a6676mr12560996637.39.1750949360434; Thu, 26
 Jun 2025 07:49:20 -0700 (PDT)
Date: Thu, 26 Jun 2025 07:49:18 -0700
In-Reply-To: <20250612141637.131314-1-minipli@grsecurity.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250612141637.131314-1-minipli@grsecurity.net>
Message-ID: <aF1d7rh_vbr8cr7j@google.com>
Subject: Re: [kvm-unit-tests PATCH] x86/emulator64: Extend non-canonical
 memory access tests with CR2 coverage
From: Sean Christopherson <seanjc@google.com>
To: Mathias Krause <minipli@grsecurity.net>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: multipart/mixed; charset="UTF-8"; boundary="KMqhKOFQerfDU/yy"


--KMqhKOFQerfDU/yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 12, 2025, Mathias Krause wrote:
> Extend the non-canonical memory access tests to verify CR2 stays
> unchanged.
> 
> There's currently a bug in QEMU/TCG that breaks that assumption.
> 
> Link: https://gitlab.com/qemu-project/qemu/-/issues/928
> Signed-off-by: Mathias Krause <minipli@grsecurity.net>
> ---
>  x86/emulator64.c | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 
> diff --git a/x86/emulator64.c b/x86/emulator64.c
> index 5d1bb0f06d4f..abef2bda29f1 100644
> --- a/x86/emulator64.c
> +++ b/x86/emulator64.c
> @@ -325,16 +325,39 @@ static void test_mmx_movq_mf(uint64_t *mem)
>  	report(exception_vector() == MF_VECTOR, "movq mmx generates #MF");
>  }
>  
> +#define CR2_REF_VALUE	0xdecafbadUL
> +
> +static void setup_cr2(void)
> +{
> +	write_cr2(CR2_REF_VALUE);
> +}
> +
> +static void check_cr2(void)
> +{
> +	unsigned long cr2 = read_cr2();
> +
> +	if (cr2 == CR2_REF_VALUE) {
> +		report(true, "CR2 unchanged");
> +	} else {
> +		report(false, "CR2 changed from %#lx to %#lx", CR2_REF_VALUE, cr2);
> +		setup_cr2();

Writing CR2 isn't expensive in the grand scheme, so rather than conditionally
re-write CR2, I think it makes sense to write CR2 at the start of every testcase,
and then just do "report(cr2 == CR2_REF_VALUE".

> +	}
> +}
> +
>  static void test_jmp_noncanonical(uint64_t *mem)
>  {
> +	setup_cr2();
>  	*mem = NONCANONICAL;
>  	asm volatile (ASM_TRY("1f") "jmp *%0; 1:" : : "m"(*mem));
>  	report(exception_vector() == GP_VECTOR,
>  	       "jump to non-canonical address");
> +	check_cr2();
>  }
>  
>  static void test_reg_noncanonical(void)
>  {
> +	setup_cr2();
> +
>  	/* RAX based, should #GP(0) */
>  	asm volatile(ASM_TRY("1f") "orq $0, (%[noncanonical]); 1:"
>  		     : : [noncanonical]"a"(NONCANONICAL));
> @@ -342,6 +365,7 @@ static void test_reg_noncanonical(void)
>  	       "non-canonical memory access, should %s(0), got %s(%u)",
>  	       exception_mnemonic(GP_VECTOR),
>  	       exception_mnemonic(exception_vector()), exception_error_code());
> +	check_cr2();

And then rather than add more copy+paste, what if we add a macro to handle the
checks?  Then the CR2 validation can slot in nicely (and maybe someday the macro
could be used outside of the x86/emulator64.c).

Attached patches yield:	

#define CR2_REF_VALUE	0xdecafbadUL

#define ASM_TRY_NONCANONICAL(insn, inputs, access, ex_vector)			\
do {										\
	unsigned int vector, ec;						\
										\
	write_cr2(CR2_REF_VALUE);						\
										\
	asm volatile(ASM_TRY("1f") insn "; 1:" :: inputs);			\
										\
	vector = exception_vector();						\
	ec = exception_error_code();						\
										\
	report(vector == ex_vector && !ec,					\
	      "non-canonical " access ", should %s(0), got %s(%u)",		\
	      exception_mnemonic(ex_vector), exception_mnemonic(vector), ec);	\
										\
	if (vector != PF_VECTOR) {						\
		unsigned long cr2  = read_cr2();				\
										\
		report(cr2 == CR2_REF_VALUE,					\
		       "Wanted CR2 '0x%lx', got '0x%lx", CR2_REF_VALUE, cr2);	\
	}									\
} while (0)

static void test_jmp_noncanonical(uint64_t *mem)
{
	*mem = NONCANONICAL;

	ASM_TRY_NONCANONICAL("jmp *%0", "m"(*mem), "jmp", GP_VECTOR);
}

static void test_reg_noncanonical(void)
{
	/* RAX based, should #GP(0) */
	ASM_TRY_NONCANONICAL("orq $0, (%[nc])", [nc]"a"(NONCANONICAL),
			     "memory access", GP_VECTOR);

	/* RSP based, should #SS(0) */
	ASM_TRY_NONCANONICAL("orq $0, (%%rsp,%[nc],1)", [nc]"r"(NONCANONICAL),
			     "rsp-based access", SS_VECTOR);

	/* RBP based, should #SS(0) */
	ASM_TRY_NONCANONICAL("orq $0, (%%rbp,%[nc],1)", [nc]"r"(NONCANONICAL),
			     "rbp-based access", SS_VECTOR);
}

--KMqhKOFQerfDU/yy
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-x86-emulator64-Add-macro-to-test-emulation-of-non-ca.patch"

From 0a7ee3543ef899ea36614ddff56c306dd63c341c Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Thu, 26 Jun 2025 07:39:43 -0700
Subject: [PATCH 1/2] x86/emulator64: Add macro to test emulation of
 non-canonical accesses

Add a macro to "try" and check a non-canonical access.  In addition to
de-duplicating the checking logic, this will allow extending the logic to
verify that CR2 isn't incorrectly modified, e.g. on #GP/#SS.

No functional change intended (ignoring the newly added check on the error
code for the JMP case).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/emulator64.c | 43 ++++++++++++++++++++++---------------------
 1 file changed, 22 insertions(+), 21 deletions(-)

diff --git a/x86/emulator64.c b/x86/emulator64.c
index 138903af..21df3b0a 100644
--- a/x86/emulator64.c
+++ b/x86/emulator64.c
@@ -325,39 +325,40 @@ static void test_mmx_movq_mf(uint64_t *mem)
 	report(exception_vector() == MF_VECTOR, "movq mmx generates #MF");
 }
 
+#define ASM_TRY_NONCANONICAL(insn, inputs, access, ex_vector)			\
+do {										\
+	unsigned int vector, ec;						\
+										\
+	asm volatile(ASM_TRY("1f") insn "; 1:" :: inputs);			\
+										\
+	vector = exception_vector();						\
+	ec = exception_error_code();						\
+										\
+	report(vector == ex_vector && !ec,					\
+	      "non-canonical " access ", should %s(0), got %s(%u)",		\
+	      exception_mnemonic(ex_vector), exception_mnemonic(vector), ec);	\
+} while (0)
+
 static void test_jmp_noncanonical(uint64_t *mem)
 {
 	*mem = NONCANONICAL;
-	asm volatile (ASM_TRY("1f") "jmp *%0; 1:" : : "m"(*mem));
-	report(exception_vector() == GP_VECTOR,
-	       "jump to non-canonical address");
+
+	ASM_TRY_NONCANONICAL("jmp *%0", "m"(*mem), "jmp", GP_VECTOR);
 }
 
 static void test_reg_noncanonical(void)
 {
 	/* RAX based, should #GP(0) */
-	asm volatile(ASM_TRY("1f") "orq $0, (%[noncanonical]); 1:"
-		     : : [noncanonical]"a"(NONCANONICAL));
-	report(exception_vector() == GP_VECTOR && exception_error_code() == 0,
-	       "non-canonical memory access, should %s(0), got %s(%u)",
-	       exception_mnemonic(GP_VECTOR),
-	       exception_mnemonic(exception_vector()), exception_error_code());
+	ASM_TRY_NONCANONICAL("orq $0, (%[nc])", [nc]"a"(NONCANONICAL),
+			     "memory access", GP_VECTOR);
 
 	/* RSP based, should #SS(0) */
-	asm volatile(ASM_TRY("1f") "orq $0, (%%rsp,%[noncanonical],1); 1:"
-		     : : [noncanonical]"r"(NONCANONICAL));
-	report(exception_vector() == SS_VECTOR && exception_error_code() == 0,
-	       "non-canonical rsp-based access, should %s(0), got %s(%u)",
-	       exception_mnemonic(SS_VECTOR),
-	       exception_mnemonic(exception_vector()), exception_error_code());
+	ASM_TRY_NONCANONICAL("orq $0, (%%rsp,%[nc],1)", [nc]"r"(NONCANONICAL),
+			     "rsp-based access", SS_VECTOR);
 
 	/* RBP based, should #SS(0) */
-	asm volatile(ASM_TRY("1f") "orq $0, (%%rbp,%[noncanonical],1); 1:"
-		     : : [noncanonical]"r"(NONCANONICAL));
-	report(exception_vector() == SS_VECTOR && exception_error_code() == 0,
-	       "non-canonical rbp-based access, should %s(0), got %s(%u)",
-	       exception_mnemonic(SS_VECTOR),
-	       exception_mnemonic(exception_vector()), exception_error_code());
+	ASM_TRY_NONCANONICAL("orq $0, (%%rbp,%[nc],1)", [nc]"r"(NONCANONICAL),
+			     "rbp-based access", SS_VECTOR);
 }
 
 static void test_movabs(uint64_t *mem)

base-commit: 525bdb5d65d51a367341f471eb1bcd505d73c51f
-- 
2.50.0.727.gbf7dc18ff4-goog


--KMqhKOFQerfDU/yy
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0002-x86-emulator64-Extend-non-canonical-memory-access-te.patch"

From efb11a007a0e041ef029753b0b98abe071008334 Mon Sep 17 00:00:00 2001
From: Mathias Krause <minipli@grsecurity.net>
Date: Thu, 26 Jun 2025 07:42:51 -0700
Subject: [PATCH 2/2] x86/emulator64: Extend non-canonical memory access tests
 with CR2 coverage

Extend the non-canonical memory access tests to verify CR2 stays
unchanged.

There's currently a bug in QEMU/TCG that breaks that assumption.

Link: https://gitlab.com/qemu-project/qemu/-/issues/928
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/emulator64.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/x86/emulator64.c b/x86/emulator64.c
index 21df3b0a..6a85122f 100644
--- a/x86/emulator64.c
+++ b/x86/emulator64.c
@@ -325,10 +325,14 @@ static void test_mmx_movq_mf(uint64_t *mem)
 	report(exception_vector() == MF_VECTOR, "movq mmx generates #MF");
 }
 
+#define CR2_REF_VALUE	0xdecafbadUL
+
 #define ASM_TRY_NONCANONICAL(insn, inputs, access, ex_vector)			\
 do {										\
 	unsigned int vector, ec;						\
 										\
+	write_cr2(CR2_REF_VALUE);						\
+										\
 	asm volatile(ASM_TRY("1f") insn "; 1:" :: inputs);			\
 										\
 	vector = exception_vector();						\
@@ -337,6 +341,13 @@ do {										\
 	report(vector == ex_vector && !ec,					\
 	      "non-canonical " access ", should %s(0), got %s(%u)",		\
 	      exception_mnemonic(ex_vector), exception_mnemonic(vector), ec);	\
+										\
+	if (vector != PF_VECTOR) {						\
+		unsigned long cr2  = read_cr2();				\
+										\
+		report(cr2 == CR2_REF_VALUE,					\
+		       "Wanted CR2 '0x%lx', got '0x%lx", CR2_REF_VALUE, cr2);	\
+	}									\
 } while (0)
 
 static void test_jmp_noncanonical(uint64_t *mem)
-- 
2.50.0.727.gbf7dc18ff4-goog


--KMqhKOFQerfDU/yy--

