Return-Path: <kvm+bounces-63268-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 138DEC5F47A
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 21:52:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7E1C042021B
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 20:52:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7962B2FBE05;
	Fri, 14 Nov 2025 20:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Of79wNUo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 452EC328274
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 20:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763153488; cv=none; b=rgfyOmuxw3glCeK7giASjl3FgJwlsBwPQTKiRlewK/13Wo9F/gAnHQd1gN781E1rhFqntSSA4wuPY/602AFclTHNaqZz16JmoOovVQ8Y7VGFAqJ7yDlK45FSNJdiK8osUVdkrqFShqhGRtJEfj+46FG59bzBWypcn5XdrXTYAAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763153488; c=relaxed/simple;
	bh=Up7F4n6gbsSj0LmGDH4ugVgi4MHUsh3K1T5NxM6ybmY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Nod7zW1adyCF7cZWaz4MPiJq9zuISffTiSyII89u5LR9mgstcWe7xI4EltL/EvTucnnBKKrW5ROrVXqCsEmk2/nGGEdvbvs5trDBbWO2U/lYN3hKmuQJ5aXvJW6K5ehS3VgTmPK90YoU1pF+UOZx8A4+8eFZAAPw/brzn7aU14E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Of79wNUo; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2980ef53fc5so6297355ad.1
        for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 12:51:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763153487; x=1763758287; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Ajkwxsnw8UTLLCmio2wEKxdJJ0yhub7uVnVKnmR9rjw=;
        b=Of79wNUoR0J09J7iqeAtcazIX2J9uOjjJWbDUS0aUZg+jv9gvSxAU2x8W1k2iEqYny
         mWB82y2jVA4CVVf7slBc4w0lu/5lvZ6+B5I/XHTYHiYts7dZ9aC1r+AT+w+JGFDnejkX
         /bVvGp12Rib2Fpa1JwhWIkX7AXJBTVQunt38sQ2X+Xd3WcgOxtjMfnUzkvo11liTvmst
         OY2KIzM55cOebR5Uy+OiCJ3buFwLxT9GAqrzBtLw+C3g7Fs9Kib0HzToUlVJx6LCo/oy
         q5A6DEiLXETCbSyBZQiEALB+uZYo6blNByrpaZn1QtPZv+pLPe2ZR3Mnb6cVDjFfzM+u
         Ujmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763153487; x=1763758287;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ajkwxsnw8UTLLCmio2wEKxdJJ0yhub7uVnVKnmR9rjw=;
        b=P5d0Gx9iKGa9wpfH566MLZPNKkY/bXbvvWfjkmTPOHqEl/K/jjR8b267qZTnQ1ICg0
         dQ+JxYDQbWDVz8VjFCcs1nLxAAQA2t1iE8R//zA+qhhzVHfsC2IkYv4NonAsKWE3YR81
         JzP4Rm3vndNtq3TpYvmZzJyfeYdi79cizCMpoUjPWODU+Blp8BCxS2sGogu4qqiYRpd4
         FXKElqY4Hgv9N/DMy/oCKytFIc1kCSxyBWIUdm1yIgEAKGLAhF4l2zQSa++sGTrSZfT3
         Bs+yTTpd/acRiMRpQPYvsrlhn/GjZIHdWNWxpGV/BhxoqzQgqxL3WFIKHt+cXrmYLuwl
         icoQ==
X-Gm-Message-State: AOJu0YyxeG+E7KDOfG8ob0JG6LfPi4gQ3h8cjQpJdRgWakbrd3N4TjJD
	30NGqGeyHnlKZEHHZzmIk/SZytXUarOQ4SnfB256XxbAR4fdAfqHJM3O+IgHQt5Qd8jKYZTr0qM
	bGwWD0w==
X-Google-Smtp-Source: AGHT+IGzvUGxeLQMA40CqMvPY04l4OFj/gw03FfmgR/FLCvFe9hKHPUdUlzL4xbkVdJASvzfWTzykSb+jms=
X-Received: from plbi1.prod.google.com ([2002:a17:903:20c1:b0:297:e887:3f69])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:daca:b0:294:9813:4512
 with SMTP id d9443c01a7336-2986a6ba40bmr58236255ad.3.1763153486598; Fri, 14
 Nov 2025 12:51:26 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 14 Nov 2025 12:50:54 -0800
In-Reply-To: <20251114205100.1873640-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251114205100.1873640-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251114205100.1873640-13-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v4 12/18] x86: cet: Test far returns too
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Chao Gao <chao.gao@intel.com>, 
	Mathias Krause <minipli@grsecurity.net>, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Mathias Krause <minipli@grsecurity.net>

Add a test for far returns which has a dedicated error code.

Tested-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
[sean: use lretl instead of bare lret]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/cet.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/x86/cet.c b/x86/cet.c
index f19ceb22..eeab5901 100644
--- a/x86/cet.c
+++ b/x86/cet.c
@@ -31,6 +31,34 @@ static uint64_t cet_shstk_func(void)
 	return 0;
 }
 
+static uint64_t cet_shstk_far_ret(void)
+{
+	struct far_pointer32 fp = {
+		.offset = (uintptr_t)&&far_func,
+		.selector = USER_CS,
+	};
+
+	if (fp.offset != (uintptr_t)&&far_func) {
+		printf("Code address too high.\n");
+		return -1;
+	}
+
+	printf("Try to temper the return-address of far-called function...\n");
+
+	/* The NOP isn't superfluous, the called function tries to skip it. */
+	asm goto ("lcall *%0; nop" : : "m" (fp) : : far_func);
+
+	printf("Uhm... how did we get here?! This should have #CP'ed!\n");
+
+	return 0;
+far_func:
+	asm volatile (/* mess with the ret addr, make it point past the NOP */
+		      "incq (%rsp)\n\t"
+		      /* 32-bit return, just as we have been called */
+		      "lretl");
+	__builtin_unreachable();
+}
+
 static uint64_t cet_ibt_func(void)
 {
 	unsigned long tmp;
@@ -104,6 +132,10 @@ int main(int ac, char **av)
 	report(rvc && exception_error_code() == CP_ERR_NEAR_RET,
 	       "NEAR RET shadow-stack protection test");
 
+	run_in_user(cet_shstk_far_ret, CP_VECTOR, 0, 0, 0, 0, &rvc);
+	report(rvc && exception_error_code() == CP_ERR_FAR_RET,
+	       "FAR RET shadow-stack protection test");
+
 	/* Enable indirect-branch tracking */
 	wrmsr(MSR_IA32_U_CET, ENABLE_IBT_BIT);
 
-- 
2.52.0.rc1.455.g30608eb744-goog


