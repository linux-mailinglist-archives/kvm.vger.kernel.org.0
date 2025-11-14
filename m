Return-Path: <kvm+bounces-63141-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DECAC5ABB7
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 01:14:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id A66B04E51B6
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:14:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 943EE23EAA5;
	Fri, 14 Nov 2025 00:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zyYfjAoW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE5B23D2A3
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 00:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763079208; cv=none; b=CoFZjqQY7wQm0iYFCS8UOKSQ6EVlFSe10yc38mjqhcF7CHDWsbgikUr4ypNJLMA7z83Z3tMJ1EcdbiMhjvv+0BRDlAvkP7uC+vRcG4Eqm5jJI2H6mVa8aILGWQvtml2u0HbCLy1brY/68FnU0rjHucxhCTkp2hhUrGLaRgDdCls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763079208; c=relaxed/simple;
	bh=Net58idKoz03mp4ukzu2JhUlWf+oQ0BdISBxtllWfJc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cirMJfGMzGVX0cxtgGMKG9Xqq0pU2hkSrDctKlGqD1u5QG8xpf91QVABuWdt58Ht8xr/+VRBifUCfEZsNnu8XWjjIXUoiZay+0QZmhax2fmQr+Rvt+Q7gX2bQeRrJFNSQqVrTUTTnvW1cmmS3c4tC4PY0/vS+NKqVZL85ETbZsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zyYfjAoW; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-343daf0f488so2087853a91.1
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 16:13:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763079206; x=1763684006; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=NGdMYCNR3AldLYyeZCHo/RAaQpMYBuNJhShu1FK3zsE=;
        b=zyYfjAoWt82Z2pH8enkyX5/CTSGWk9EFnF/Ptdjyc0bfsE2WdeUqbVysKeImggxFI9
         a0rwMwJ/Qn1ch8/phqik5M3AnsZQ3zVHZSIjaBHkrCjdtouycsukOGhYnYGirv9M2CJS
         5e51Pcs81HefroX9LUMKAUVkDXwdfMc0Emqw4t1oXRT8GXvQvqzwJJLKDNEpQEjWSwYf
         qv6Wh73q6D86b7x3nggkWK7GPTA6AXYembjeZBFQS9vtO9DpMjGYrKVubWL0BiCr3Ovr
         hS5TjHMHQsmOg6twdxTQntqbE4g/9s33wkgXSN9KNV/tMTovAFW3pHNB9L1AO69COx50
         xi+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763079206; x=1763684006;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NGdMYCNR3AldLYyeZCHo/RAaQpMYBuNJhShu1FK3zsE=;
        b=JvCnuUdvjVmdVDiyh2Pmat5fxuXFXYwy0bdsvABbd+gNSN0zgLOyjR9w2SxM9psjEw
         Q4Il+xXXRqJ+7ndoAIDICuZIF8o/eVA0THCFz7q1W8qQt8ir5WMyb7elCQLso2S7GRyt
         /TXCC86kuI3wIc0C9xGvt+5vyIJsUYCtZbwZ1hHw29KMD1YEQuiTndPYtX9OXQSkFWsj
         bTeNtHeEehgJJrMVL1Tb3ScHm2pu7YD+R7+QhohQipGMJtLcPla+qrGNscxmPnnrjKu7
         vvgJRt23ogoG8CZehEAsSlrN3qy6v+joWy8HtPPfQ65vlOWpcaIb2UOBLd8DGS7SrR1a
         8qFQ==
X-Gm-Message-State: AOJu0YxfeMNA0V5rxaQOwTmrDQurS+wFUI51Mi7MaH15htF05PAR2Jae
	m8wjvj5roAEZqqVimus596B9IE07ftSyYAlHGZyhbfsBk+RQ4zfKD8n5KH1VomFkp0wC/957wY/
	S/BFt0w==
X-Google-Smtp-Source: AGHT+IFcGnuTBJe+j+XzsjufEHph7ZercKja5RcHeNe3SBnYjGm2Dzt9EMCwoo3cPWuyCg/a5br72MOQWWc=
X-Received: from pjbev2.prod.google.com ([2002:a17:90a:eac2:b0:343:c839:21d1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3f0c:b0:340:d06d:ea73
 with SMTP id 98e67ed59e1d1-343fa525a24mr1011537a91.19.1763079206429; Thu, 13
 Nov 2025 16:13:26 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 13 Nov 2025 16:12:56 -0800
In-Reply-To: <20251114001258.1717007-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251114001258.1717007-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251114001258.1717007-16-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v3 15/17] x86/cet: Run SHSTK and IBT tests as
 appropriate if either feature is supported
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>, Chao Gao <chao.gao@intel.com>, 
	Mathias Krause <minipli@grsecurity.net>
Content-Type: text/plain; charset="UTF-8"

Run the SHSTK and IBT tests if their respective feature is supported, as
nothing in the architecture requires both features to be supported.
Decoupling the two features allows running the SHSTK test on AMD CPUs,
which support SHSTK but not IBT.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/cet.c | 50 +++++++++++++++++++++++++++++++++-----------------
 1 file changed, 33 insertions(+), 17 deletions(-)

diff --git a/x86/cet.c b/x86/cet.c
index eeab5901..26cd1c9b 100644
--- a/x86/cet.c
+++ b/x86/cet.c
@@ -85,7 +85,7 @@ static uint64_t cet_ibt_func(void)
 #define ENABLE_SHSTK_BIT 0x1
 #define ENABLE_IBT_BIT   0x4
 
-int main(int ac, char **av)
+static void test_shstk(void)
 {
 	char *shstk_virt;
 	unsigned long shstk_phys;
@@ -94,17 +94,10 @@ int main(int ac, char **av)
 	bool rvc;
 
 	if (!this_cpu_has(X86_FEATURE_SHSTK)) {
-		report_skip("SHSTK not enabled");
-		return report_summary();
+		report_skip("SHSTK not supported");
+		return;
 	}
 
-	if (!this_cpu_has(X86_FEATURE_IBT)) {
-		report_skip("IBT not enabled");
-		return report_summary();
-	}
-
-	setup_vm();
-
 	/* Allocate one page for shadow-stack. */
 	shstk_virt = alloc_vpage();
 	shstk_phys = (unsigned long)virt_to_phys(alloc_page());
@@ -124,9 +117,6 @@ int main(int ac, char **av)
 	/* Store shadow-stack pointer. */
 	wrmsr(MSR_IA32_PL3_SSP, (u64)(shstk_virt + 0x1000));
 
-	/* Enable CET master control bit in CR4. */
-	write_cr4(read_cr4() | X86_CR4_CET);
-
 	printf("Unit tests for CET user mode...\n");
 	run_in_user(cet_shstk_func, CP_VECTOR, 0, 0, 0, 0, &rvc);
 	report(rvc && exception_error_code() == CP_ERR_NEAR_RET,
@@ -136,19 +126,45 @@ int main(int ac, char **av)
 	report(rvc && exception_error_code() == CP_ERR_FAR_RET,
 	       "FAR RET shadow-stack protection test");
 
+	/* SSP should be 4-Byte aligned */
+	vector = wrmsr_safe(MSR_IA32_PL3_SSP, 0x1);
+	report(vector == GP_VECTOR, "MSR_IA32_PL3_SSP alignment test.");
+}
+
+static void test_ibt(void)
+{
+	bool rvc;
+
+	if (!this_cpu_has(X86_FEATURE_IBT)) {
+		report_skip("IBT not supported");
+		return;
+	}
+
 	/* Enable indirect-branch tracking */
 	wrmsr(MSR_IA32_U_CET, ENABLE_IBT_BIT);
 
 	run_in_user(cet_ibt_func, CP_VECTOR, 0, 0, 0, 0, &rvc);
 	report(rvc && exception_error_code() == CP_ERR_ENDBR,
 	       "Indirect-branch tracking test");
+}
+
+int main(int ac, char **av)
+{
+	if (!this_cpu_has(X86_FEATURE_SHSTK) && !this_cpu_has(X86_FEATURE_IBT)) {
+		report_skip("No CET features supported");
+		return report_summary();
+	}
+
+	setup_vm();
+
+	/* Enable CET global control bit in CR4. */
+	write_cr4(read_cr4() | X86_CR4_CET);
+
+	test_shstk();
+	test_ibt();
 
 	write_cr4(read_cr4() & ~X86_CR4_CET);
 	wrmsr(MSR_IA32_U_CET, 0);
 
-	/* SSP should be 4-Byte aligned */
-	vector = wrmsr_safe(MSR_IA32_PL3_SSP, 0x1);
-	report(vector == GP_VECTOR, "MSR_IA32_PL3_SSP alignment test.");
-
 	return report_summary();
 }
-- 
2.52.0.rc1.455.g30608eb744-goog


