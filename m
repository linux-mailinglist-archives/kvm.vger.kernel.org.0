Return-Path: <kvm+bounces-48876-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FCD6AD4355
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 21:55:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 66F2B3A4F38
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 19:55:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33AA5266B6B;
	Tue, 10 Jun 2025 19:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1a/5mRWv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02851265629
	for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 19:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749585277; cv=none; b=LpS4MRPloRBvKLZUfRwLgaZEVl4oakx+9oq5pcgIK6yR5xwElrZpzq6rg0FELAn4adgQfDOjRefGUqLWeVMs2hkefxMj9xn4H5/umSVL5K0VS8w1IUGRyuZOGkEbZSstfWaORyv+OSpK4uKjqwplRmxBxfyNvVeF86tPxdOQKp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749585277; c=relaxed/simple;
	bh=DR3VHNgYif/XsLe9bwIZJjuT6IS7yEpxpVbC18gf99E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QFA+uza4PLkWzgwPjb8wgXPW+4Nn5XNJAs6CqVx3+l6M678dSvnP8+DnUidEogB71xwGPlrHo4babb8jAlQV63qsxkM5MF7F/qNvU52hhMXZXsCq38QUscCgHgdQ1G6q3V485M+L9s9KVc2cR7Ju0If5lv+MemXMt1YBr1WZTLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1a/5mRWv; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3138e65efe2so2180800a91.1
        for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 12:54:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749585275; x=1750190075; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=2i0YkfjEA8J3WUrXSSBFjI/PiKmpX8tZhqtOtgUl+Xk=;
        b=1a/5mRWv2mitTTtU/Kji0QG1vKC6egHspqUb5HhlVRYPHb1uLiR4qDRAR1trYoh3VM
         vGbHFl8cq6gXQxWAjK1jWWFCtgBoRTzytea+hz5K1SQ2cs0Rmal5z8DKG8m3qzw0H4sa
         44MpsyizoBupxHVlO37FSST3WfWCStttoE99y0HwpGYZXVYXyoaD+FUGzkNoXNAoQr9U
         Wws+ms0j15SbuvI5Z/gtcE/Q5G2ABO6e1C0OB7zH44vp9YLZJYkTtl2HwgBZ9jejHx3u
         DKVi2v/aJgdZ1A9xzVzpM5YZ7PqWd5UaUUgWfqkELk0PdPC99QRf3Q27wYpXiJ2S+Xid
         WbVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749585275; x=1750190075;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2i0YkfjEA8J3WUrXSSBFjI/PiKmpX8tZhqtOtgUl+Xk=;
        b=YA4CxHGqmlZQAKRqByzhL5sMo9PuI25PsWMlAUMCDzokeVYPyzMrrk3VDF2Fi64wLy
         LwoiBzqoFlbjDbqROCZFnO2K9KbJjWZX4YmljrQ1iMIf4aFGd8zWg8S+/3nzuKb6G4PS
         9vGSHZyHAJ6PiQ/4aMJKB/4DDbyoIVAN78T8BBSKB3EPANE0NzAxUBBnyeAPqlEZihEf
         hJUrdIUbD2rVm5JvIEqXJyBmje5U0bHkb9nZ0cAn/w7wrYb6RgKIskDVCYvbkbVU2SYA
         LAPpCO2kHA/y98avVBgyDtgSICu3GjII+qyz/lMaA75v+ueQP0smbPJB7JQNPLo1hY74
         awHw==
X-Gm-Message-State: AOJu0YypkG5PS2rJ5ZtxLQPfv/9N1Sh+5KTVPanYz0AxoZuWtsKYzRjR
	GJpk4OirTGlIVc0FV5ZBAzs1FKdMKXGWE9kiY9Sa1XaNo/rjUID5+1yrq+EaOzAIrkeIa+CeyGt
	YXyqnkw==
X-Google-Smtp-Source: AGHT+IE3MLIRdfbHGkyeIpysNFDyg4+v4EmFVEiw7DJw8pV1mU6kuPL33Blgto6A5vcne/ADguQAix62I20=
X-Received: from pjbtb15.prod.google.com ([2002:a17:90b:53cf:b0:311:7bc3:2a8d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2c90:b0:312:25dd:1c86
 with SMTP id 98e67ed59e1d1-313af197dc1mr1237199a91.18.1749585275547; Tue, 10
 Jun 2025 12:54:35 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 10 Jun 2025 12:54:11 -0700
In-Reply-To: <20250610195415.115404-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250610195415.115404-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250610195415.115404-11-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v2 10/14] x86/sev: Skip the AMD SEV test if SEV
 is unsupported/disabled
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Sean Christopherson <seanjc@google.com>, Liam Merwick <liam.merwick@oracle.com>
Content-Type: text/plain; charset="UTF-8"

Skip the AMD SEV test if SEV is unsupported, as KVM-Unit-Tests typically
don't report failures if feature is missing.

Opportunistically use amd_sev_enabled() instead of duplicating all of its
functionality.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/amd_sev.c | 51 +++++++--------------------------------------------
 1 file changed, 7 insertions(+), 44 deletions(-)

diff --git a/x86/amd_sev.c b/x86/amd_sev.c
index 7757d4f8..4ec45543 100644
--- a/x86/amd_sev.c
+++ b/x86/amd_sev.c
@@ -15,51 +15,10 @@
 #include "x86/amd_sev.h"
 #include "msr.h"
 
-#define EXIT_SUCCESS 0
-#define EXIT_FAILURE 1
-
 #define TESTDEV_IO_PORT 0xe0
 
 static char st1[] = "abcdefghijklmnop";
 
-static int test_sev_activation(void)
-{
-	struct cpuid cpuid_out;
-	u64 msr_out;
-
-	printf("SEV activation test is loaded.\n");
-
-	/* Tests if CPUID function to check SEV is implemented */
-	cpuid_out = cpuid(CPUID_FN_LARGEST_EXT_FUNC_NUM);
-	printf("CPUID Fn8000_0000[EAX]: 0x%08x\n", cpuid_out.a);
-	if (cpuid_out.a < CPUID_FN_ENCRYPT_MEM_CAPAB) {
-		printf("CPUID does not support FN%08x\n",
-		       CPUID_FN_ENCRYPT_MEM_CAPAB);
-		return EXIT_FAILURE;
-	}
-
-	/* Tests if SEV is supported */
-	cpuid_out = cpuid(CPUID_FN_ENCRYPT_MEM_CAPAB);
-	printf("CPUID Fn8000_001F[EAX]: 0x%08x\n", cpuid_out.a);
-	printf("CPUID Fn8000_001F[EBX]: 0x%08x\n", cpuid_out.b);
-	if (!(cpuid_out.a & SEV_SUPPORT_MASK)) {
-		printf("SEV is not supported.\n");
-		return EXIT_FAILURE;
-	}
-	printf("SEV is supported\n");
-
-	/* Tests if SEV is enabled */
-	msr_out = rdmsr(MSR_SEV_STATUS);
-	printf("MSR C001_0131[EAX]: 0x%08lx\n", msr_out & 0xffffffff);
-	if (!(msr_out & SEV_ENABLED_MASK)) {
-		printf("SEV is not enabled.\n");
-		return EXIT_FAILURE;
-	}
-	printf("SEV is enabled\n");
-
-	return EXIT_SUCCESS;
-}
-
 static void test_sev_es_activation(void)
 {
 	if (rdmsr(MSR_SEV_STATUS) & SEV_ES_ENABLED_MASK) {
@@ -88,10 +47,14 @@ static void test_stringio(void)
 
 int main(void)
 {
-	int rtn;
-	rtn = test_sev_activation();
-	report(rtn == EXIT_SUCCESS, "SEV activation test.");
+	if (!amd_sev_enabled()) {
+		report_skip("AMD SEV not enabled\n");
+		goto out;
+	}
+
 	test_sev_es_activation();
 	test_stringio();
+
+out:
 	return report_summary();
 }
-- 
2.50.0.rc0.642.g800a2b2222-goog


