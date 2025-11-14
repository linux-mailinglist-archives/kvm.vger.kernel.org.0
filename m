Return-Path: <kvm+bounces-63270-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 697BFC5F485
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 21:52:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 18A56420EDC
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 20:52:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F27312FC010;
	Fri, 14 Nov 2025 20:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PLhUSjlJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6CA2328274
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 20:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763153492; cv=none; b=DsvMN9un8OME7lrvBuauJikDYoZ1MF0fOTVirT34iaP9GVs2V0gzgQF9BkYECD73IAz5DSq739ULISfTEUxc40jc/FlFb+0UIJ3Yg9lyQRjkOn5RygEFjUp3geQTT6hiL6IDe6NGiUCxBZxIfpTGD7lm5G8IoSgx9F1AkyELYyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763153492; c=relaxed/simple;
	bh=Gkr4O5+mDPSjvGIZmIryZG9wM3GWh3LFgbLk2M5ctDc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MhaybuzvHKcm+GlQuGeOLsLs5/MEkKDc0zVl/cU0YWjAkdzzpc+5fJ3iArJZ9NxEGHtObGbq/1s4xMvrAPYsgu9ZAyiqegHyKUA0+I41Jya4hnC16TyULFf7eMtY3nZEcwLI8MoRiCaBhdl3ERJw3iHBKaOWchzg+hH+QQrJAlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PLhUSjlJ; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-295592eb5dbso30580855ad.0
        for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 12:51:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763153490; x=1763758290; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Ol3zJ3Ku77ki9fUQ97/m5+e7G6fc7jBQJ2EL2IjcFFU=;
        b=PLhUSjlJov82umuPgS6oxriQ0ZodVhzAGQbipPp0X1OMQ7hsM9KOUUwPyuoaBZ+5WP
         e21+x2Bzo3+ZHlIm2RITQzQJMW0bAqLCGXk+vacYdKvc05LlC6ZU0M/HbOV1+U961ReH
         7tPuD2Oig08w2JLpQJL+nHBgaVmlAFvlloVCxOJliBZ+4kdUVc94hCShMCJJXwiGHN2X
         MdnUzqoM5VelrqX8ayL4cUUwdswTUEjCw9uFEQRspMNBRfZkHRLq2+1hUA/EHIOhAzn9
         WsIijZYz2plyN+gp1hQpHQaA283fiiWdN+/UJDuY3GXYtmsdkJ2xguD0hFlECrJYvcUk
         GPGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763153490; x=1763758290;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ol3zJ3Ku77ki9fUQ97/m5+e7G6fc7jBQJ2EL2IjcFFU=;
        b=PUzZuahmV4v4r1Gnk3ICAyK+1gkLAE1eUiV/arWdEWH9iflj9zwfvcJC3GEGKO/u/g
         xuCDCVTRfrbbq1xSg2p7CyvvFdQq4xjqJyqJao+9K/kCTFdxMVRQeiSn3zbAyA55KTCT
         tgPDhX8zb7QqaH1FqLqvH6fWwQAq5JeQ4kdUy1T0S+hCPxkJkKxAyVGH8l1aCqP9lnqd
         6qB0mWYqsbGgyRM3FkdgBg/gCCUcreOKsQFE5x7jVQ5cxosmTOo5xe91YhbWS1vPJwwg
         dwj70Cyexu+jbXAihdqvGvCJziezomv1Y4d+2bxP5mh6PW9uJ/pdvnwi1yR5rcIHq/qG
         dQ5w==
X-Gm-Message-State: AOJu0YyN8ZcMn+AcmoUeu6eeFBnW7EtHq7O96BmPWQj+UMce7jM8eR5e
	FimWRWaxPuFx2oCXQ74KkB4NgRWdV6iWMnK27sYOfK7OdF1kBadpsaiMrUVPh4Q488eV6I9FoUV
	lonQXmA==
X-Google-Smtp-Source: AGHT+IH0y+4/YncIbxaMze8JPEWqspviWvjqEqy5pN1QL3j9EBXnu/FwPt+geRb121FN5Mpv0i6W91B+wto=
X-Received: from plqt9.prod.google.com ([2002:a17:902:a5c9:b0:298:371:94ea])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e84c:b0:295:4d97:84dd
 with SMTP id d9443c01a7336-2986a742d00mr50949855ad.51.1763153490120; Fri, 14
 Nov 2025 12:51:30 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 14 Nov 2025 12:50:56 -0800
In-Reply-To: <20251114205100.1873640-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251114205100.1873640-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251114205100.1873640-15-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v4 14/18] x86: cet: Run SHSTK and IBT tests as
 appropriate if either feature is supported
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Chao Gao <chao.gao@intel.com>, 
	Mathias Krause <minipli@grsecurity.net>, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Run the SHSTK and IBT tests if their respective feature is supported, as
nothing in the architecture requires both features to be supported.
Decoupling the two features allows running the SHSTK test on AMD CPUs,
which support SHSTK but not IBT.

Reviewed-by: Mathias Krause <minipli@grsecurity.net>
Tested-by: Mathias Krause <minipli@grsecurity.net>
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


