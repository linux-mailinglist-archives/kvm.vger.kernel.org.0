Return-Path: <kvm+bounces-63259-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F987C5F476
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 21:52:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id A40FE4E0593
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 20:51:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B7F92FB0B4;
	Fri, 14 Nov 2025 20:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oMRy/Soq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE6302FB60A
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 20:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763153473; cv=none; b=IEVIrdSJAjjgpWVu8TW6d4nBIzarlD5U01AcZSNPUl4ij/aMsP20m5DQPxFibH41CgRSDhHZb6wM+f1MGXbCFv4vMjXGW+iJ/r6dLmOTIL13XpcTa/czjD+onBbvP+NjY18g1ju+LCNl4TGXKiDG5YN3pYWiTXWYC46D63Vljgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763153473; c=relaxed/simple;
	bh=oGTggzr5jKcuOffOHLrYYa9DDB5vwZR9gG9clLfnX5Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Gfqb2hIcJxMlsb19iis4YwrTYbVadqB3Zo8zjl2zUNjoJ5KTio0su6zBeaR3U1llQUA8MV2YlXHGeXtAC7eFVWw0KibGS3bXPkDGY0ItkmUjycrClX4uGj+ZLPZroHcSB/As+uoW5NoJSTV5P4+YvCjBIh/irFWyYiXNeMLnKJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oMRy/Soq; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-343823be748so3087256a91.0
        for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 12:51:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763153471; x=1763758271; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=kRBMfjFsGZBNLPJPvrgkKEEzOwvRF5vo6ZIWna3fffU=;
        b=oMRy/SoqEWhMi03dZD6vN7RULoR2NUK0injZItum1wj6pmwcU+OlhTiERFha6FMG4J
         wuf4X2O7uNB5Sjq+8LJAAX/s8N887JolczniSdU/Kiy0lp1iFFptNTXd/6jZnPdzFaGn
         fMU8qgN2/AyX9SqcPWgQvX/SelFquSPeBo3/PQx7ksjxTr9z1IwVL0P25Q7SZV2jbYuk
         HJwe55aswvdt083T0YXVf/Lub0jw5IrAoKFo0QgIzVIamRDCfzX8t1gFWLMbnmQcANrE
         r0Jdh5r0uFtD84bDC5BOAjPlXadbndT7u11pNi5fvbUM3NI9mZ5pFh6OefNlBn/2QYld
         v5mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763153471; x=1763758271;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kRBMfjFsGZBNLPJPvrgkKEEzOwvRF5vo6ZIWna3fffU=;
        b=cDkQEkFsXJnTdBSPIO6wrcKJKQtbiYj3VE9rpl7YpDP8I6CI9AFNz7xJFja5cBDaSr
         clF5mTXvOE2r1OXcS/wZaVPAPq6CBrI7HqfFdX+992iQpKD/v//nWnoNKlc4vA9A5Xei
         d0xlMBGgdcUCWPUYx5vfnOwa6WkKkKDB3VndcoDCimw3cXFtj0cDfJANnYW1DZEVrzSK
         6oXOh/vYFGKd2PKIQamH5O/5r13np9dM8DbBZLrWHvrujCa9EqiOeM3jcdPSEYUQy3cw
         G3shaO6i6ssLotJX2iC3QTJvvtY1zWHQ+8ZF5T3bza125cWnuoGP5HUgFzk09eZHm9XN
         AgHw==
X-Gm-Message-State: AOJu0YwiarHd+khz5PmdvGhiZpZLx8/ndyU+j2RTyIyAEkX+wntY2XWv
	KPZkX/UWnVispz7yEVDnKPoiuCpFFh9VnF+v9QPYQCOWuBpB1H0BvePPrvK3zmrKa5SpIUu2gLZ
	jKiKx0g==
X-Google-Smtp-Source: AGHT+IGwu7rc7ZtHbT5LRtKJ3nFTekLJhw/a5B5gmzo9vspC1Aec5XJrZuadgk6x4sY9gdHzZ0/f33ST/Jg=
X-Received: from pjzh15.prod.google.com ([2002:a17:90a:ea8f:b0:343:1fc1:8553])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:518f:b0:340:a5b2:c305
 with SMTP id 98e67ed59e1d1-343f9e906dbmr4419441a91.2.1763153471133; Fri, 14
 Nov 2025 12:51:11 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 14 Nov 2025 12:50:45 -0800
In-Reply-To: <20251114205100.1873640-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251114205100.1873640-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251114205100.1873640-4-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v4 03/18] x86: cet: Directly check for #CP
 exception in run_in_user()
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Chao Gao <chao.gao@intel.com>, 
	Mathias Krause <minipli@grsecurity.net>, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Chao Gao <chao.gao@intel.com>

Current CET tests validate if a #CP exception is raised by registering
a #CP handler. This handler counts the #CP exceptions and raises a #GP
exception, which is then caught by the run_in_user() infrastructure to
switch back to the kernel. This is convoluted.

Catch the #CP exception directly by run_in_user() to avoid the manual
counting of #CP exceptions and the #CP->#GP dance.

Signed-off-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/cet.c | 23 ++++-------------------
 1 file changed, 4 insertions(+), 19 deletions(-)

diff --git a/x86/cet.c b/x86/cet.c
index e2681886..7635fe34 100644
--- a/x86/cet.c
+++ b/x86/cet.c
@@ -8,9 +8,6 @@
 #include "alloc_page.h"
 #include "fault_test.h"
 
-static int cp_count;
-static unsigned long invalid_offset = 0xffffffffffffff;
-
 static u64 cet_shstk_func(void)
 {
 	unsigned long *ret_addr, *ssp;
@@ -54,15 +51,6 @@ static u64 cet_ibt_func(void)
 #define ENABLE_SHSTK_BIT 0x1
 #define ENABLE_IBT_BIT   0x4
 
-static void handle_cp(struct ex_regs *regs)
-{
-	cp_count++;
-	printf("In #CP exception handler, error_code = 0x%lx\n",
-		regs->error_code);
-	/* Below jmp is expected to trigger #GP */
-	asm("jmpq *%0": :"m"(invalid_offset));
-}
-
 int main(int ac, char **av)
 {
 	char *shstk_virt;
@@ -70,7 +58,6 @@ int main(int ac, char **av)
 	pteval_t pte = 0;
 	bool rvc;
 
-	cp_count = 0;
 	if (!this_cpu_has(X86_FEATURE_SHSTK)) {
 		printf("SHSTK not enabled\n");
 		return report_summary();
@@ -82,7 +69,6 @@ int main(int ac, char **av)
 	}
 
 	setup_vm();
-	handle_exception(CP_VECTOR, handle_cp);
 
 	/* Allocate one page for shadow-stack. */
 	shstk_virt = alloc_vpage();
@@ -107,15 +93,14 @@ int main(int ac, char **av)
 	write_cr4(read_cr4() | X86_CR4_CET);
 
 	printf("Unit test for CET user mode...\n");
-	run_in_user((usermode_func)cet_shstk_func, GP_VECTOR, 0, 0, 0, 0, &rvc);
-	report(cp_count == 1, "Completed shadow-stack protection test successfully.");
-	cp_count = 0;
+	run_in_user((usermode_func)cet_shstk_func, CP_VECTOR, 0, 0, 0, 0, &rvc);
+	report(rvc, "Shadow-stack protection test.");
 
 	/* Enable indirect-branch tracking */
 	wrmsr(MSR_IA32_U_CET, ENABLE_IBT_BIT);
 
-	run_in_user((usermode_func)cet_ibt_func, GP_VECTOR, 0, 0, 0, 0, &rvc);
-	report(cp_count == 1, "Completed Indirect-branch tracking test successfully.");
+	run_in_user((usermode_func)cet_ibt_func, CP_VECTOR, 0, 0, 0, 0, &rvc);
+	report(rvc, "Indirect-branch tracking test.");
 
 	write_cr4(read_cr4() & ~X86_CR4_CET);
 	wrmsr(MSR_IA32_U_CET, 0);
-- 
2.52.0.rc1.455.g30608eb744-goog


