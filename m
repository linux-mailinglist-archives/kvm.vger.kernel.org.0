Return-Path: <kvm+bounces-38251-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BAAB2A36B01
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 02:30:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1A3513B1F7B
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 01:30:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5957A152E12;
	Sat, 15 Feb 2025 01:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3BkvRe6s"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F4ED151985
	for <kvm@vger.kernel.org>; Sat, 15 Feb 2025 01:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739583029; cv=none; b=b/2uMUSORSDhj0xbdKijwwJYM084Kp27a1qWwlVIvu5/GNCnappUWxsOK/EHYlarIHT9dGPSaOPJowOYg5w2zbT05Rvl+6rhcPfHEXtiVhbsdUEwTZJ5a70CNoOoOVJ3oSamvHUr4zOB4/EVQgWqlughYkKzSuU3fAY1vkZ/BWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739583029; c=relaxed/simple;
	bh=V0fJ4VH6oNplMlatOTJIZHaORH/sgyQ8OkXwtWJst7U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=p5o+Bqxaa87o3o2JMfEF/rw5QDtL4OgDQvnRgL37e8Kppvkiphy8MZbbN9x7nN7N7IG3Zigcd/s4z+dJ6yZGT8Aj1OgDwZfE71q80pWtbhntD255lYlNl4LF8zolJzhxJj320MFNd2ocTA8gWlzVAkDT09afSRnfSwfO0snrdNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3BkvRe6s; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-21a7cbe3b56so43725625ad.0
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 17:30:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739583027; x=1740187827; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ETGgC6G+yyJ54bJkFbhvWzGmT5jKr731rfTGJSUN2mc=;
        b=3BkvRe6sxES8ZQCl/nPJRaV97mGDEeR9Ji4krkMLPHD2TQOIJFT0vQAptGVWc13229
         DGnAXTIOPQR1YdHoszsrHV68ugrPNKh6Ika1vyYy1Sc6wupcI6Qt7T+RgbrQM89I2FHY
         Y7LNSefmCRJoiewYBnaF5qH9qHX+zZvY4ScCJbjbblY57v9FYKuOAivv5ITm6UqhNnQ4
         +TXmfn+t3gPJ93yu4Bst8UnEq2FOuscuIzYKSrgCIBFaW4U9kOrLXmr6tXUXfvFz6lAc
         I75EHz//5kttWfNKFb07boRDlvUC+xdZKykezTLN2xnjmwuXYWSOICM2/2cGq9LCvKFT
         BJ7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739583027; x=1740187827;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ETGgC6G+yyJ54bJkFbhvWzGmT5jKr731rfTGJSUN2mc=;
        b=aJPoCap6o80NBvp62/c/5/OcU7QOadbKHjOs9c1rAgYEeLH1IvUfj0bvdTwVjAmhAp
         /u8bR88x5IqvZlq5v1Rh9zKTyhIr/k92Av5MAuq57NmO6HosIj2EiX7vE+TjD06t9rca
         KMPpmMs6ugX7teZEno0287hNBXp3Qkn9bbsDCbIGOtDWFq2u6ZoqtQGihyCttcgmltSJ
         DEIyLmZMwO+0eiO7xJVXmJxYfmdJPmUGhpBEdGABDomdLkIYWo8dYmWxPHABB9UUlzzb
         VNFSoESL1cyRareyUJxtsednbxmLWGYoLuDq9oNr/pfJxsJj7UReNgWxpeNaq2G1Gs7X
         JhMQ==
X-Gm-Message-State: AOJu0YzkEQiAkfXv0pZLk+ORayDoyHaJnEriZ1N4Yf7Wg4+AA7jy7dWC
	WkzEMTq2Z2M/rNpT15XQWrue2wmkissUdwUozIslGm7cokOt+4pfB/jmGr2R8VY0NJEh3QDa8iM
	Y9g==
X-Google-Smtp-Source: AGHT+IHmiEjUY8dAY3gFQhXlG29+x9LoGTSVS5YYDna26w7Vw6FRskQKrm6q6Kqg8v2Z5TpwfdpWV8cipaU=
X-Received: from pjbhl3.prod.google.com ([2002:a17:90b:1343:b0:2fc:15bf:92f6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:41c8:b0:216:3466:7414
 with SMTP id d9443c01a7336-221040bcc46mr25577295ad.44.1739583027400; Fri, 14
 Feb 2025 17:30:27 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 14 Feb 2025 17:30:16 -0800
In-Reply-To: <20250215013018.1210432-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250215013018.1210432-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250215013018.1210432-5-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v2 4/6] x86: Expand LA57 test to 64-bit mode
 (to prep for canonical testing)
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Expand the LA57 test to also validate that attempting to toggle LA57 while
in 64-bit mode fails.  The extra test coverage isn't terribly interesting,
but it's still useful, and extending the LA57 test to 64-bit configs will
allow extending it further with LA57-specific canonical tests.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/Makefile.common | 3 ++-
 x86/Makefile.i386   | 2 +-
 x86/la57.c          | 9 ++++++---
 x86/unittests.cfg   | 2 +-
 4 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/x86/Makefile.common b/x86/Makefile.common
index 4ae9a557..0b7f35c8 100644
--- a/x86/Makefile.common
+++ b/x86/Makefile.common
@@ -96,7 +96,8 @@ tests-common = $(TEST_DIR)/vmexit.$(exe) $(TEST_DIR)/tsc.$(exe) \
 # use absolute addresses in their inline assembly code, which cannot compile
 # with the '-fPIC' flag
 ifneq ($(CONFIG_EFI),y)
-tests-common += $(TEST_DIR)/realmode.$(exe)
+tests-common += $(TEST_DIR)/realmode.$(exe) \
+		$(TEST_DIR)/la57.$(exe)
 endif
 
 test_cases: $(tests-common) $(tests)
diff --git a/x86/Makefile.i386 b/x86/Makefile.i386
index 0a845e65..a1ea1c2d 100644
--- a/x86/Makefile.i386
+++ b/x86/Makefile.i386
@@ -9,6 +9,6 @@ arch_LDFLAGS = -m elf_i386
 cflatobjs += lib/x86/setjmp32.o lib/ldiv32.o
 
 tests = $(TEST_DIR)/taskswitch.$(exe) $(TEST_DIR)/taskswitch2.$(exe) \
-	$(TEST_DIR)/cmpxchg8b.$(exe) $(TEST_DIR)/la57.$(exe)
+	$(TEST_DIR)/cmpxchg8b.$(exe)
 
 include $(SRCDIR)/$(TEST_DIR)/Makefile.common
diff --git a/x86/la57.c b/x86/la57.c
index 1f11412c..aff35ead 100644
--- a/x86/la57.c
+++ b/x86/la57.c
@@ -5,9 +5,12 @@
 int main(int ac, char **av)
 {
 	int vector = write_cr4_safe(read_cr4() | X86_CR4_LA57);
-	int expected = this_cpu_has(X86_FEATURE_LA57) ? 0 : 13;
+	bool is_64bit = rdmsr(MSR_EFER) & EFER_LMA;
+	int expected = !is_64bit && this_cpu_has(X86_FEATURE_LA57) ? 0 : GP_VECTOR;
+
+	report(vector == expected, "%s when CR4.LA57 %ssupported (in %u-bit mode)",
+	       expected ? "#GP" : "No fault",
+	       this_cpu_has(X86_FEATURE_LA57) ? "un" : "", is_64bit ? 64 : 32);
 
-	report(vector == expected, "%s when CR4.LA57 %ssupported",
-	       expected ? "#GP" : "No fault", expected ? "un" : "");
 	return report_summary();
 }
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 7c1691a9..665f3d4c 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -316,7 +316,7 @@ extra_params = -cpu qemu64,+umip
 
 [la57]
 file = la57.flat
-arch = i386
+extra_params = -cpu max,host-phys-bits
 
 [vmx]
 file = vmx.flat
-- 
2.48.1.601.g30ceb7b040-goog


