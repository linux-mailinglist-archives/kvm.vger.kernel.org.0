Return-Path: <kvm+bounces-38250-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 22701A36B00
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 02:30:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7BC0E7A3365
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 01:29:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A7FC151991;
	Sat, 15 Feb 2025 01:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Bw5Xy1Se"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE767DA62
	for <kvm@vger.kernel.org>; Sat, 15 Feb 2025 01:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739583027; cv=none; b=oMF1Z8uUpiMxFj/VDoqjhVjAf3DdXe5Ir0sLcSR1TBKubCFp6C48qh42jtddj+zGWe69s3mJgHw5Lx7zAzKY3z4V/sLhBkFRrn3n4RmbYr9wY+2sWFrWYPc0w7RrRtUmtMhx6eQZuBAyn3K6EkBCeFs4CcVgEiZ99nbfi8TT384=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739583027; c=relaxed/simple;
	bh=c1AIaGnuJeM1AeYU4D16fG2sEhaecw/3jBmKDGCdMD4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KbSnm9wpytSRWQu9NT41BjMnH3dgGjHn7DTXdc/dgPn64oOOyVDQr2f77yFylFyQ4I2XJwxulCAPsMhx5m3jfVNqCQ3pjL2wk/s4tozi7MVbb3wlIv9/6GTyYA+7jaMrzHHhXRgrlfkmhDbCaG2DUwq1o/4Wk50zdFKeN1xo0+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Bw5Xy1Se; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fa57c42965so5609939a91.1
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 17:30:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739583026; x=1740187826; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=x4s7pFI0aY9o6O21bKm5JYyoqQO0/jilZnXQOfrGt04=;
        b=Bw5Xy1SexwJ5fneDyzJramMt4I85W/B8dyh45GBc18842Droam7x827F5Ego322q/r
         w2zJ/hToLv9fHpRQaIJqnUagty2FJX8+f4Us9L0fu+3y42+6SPXTE85SCWiGWwoptUE7
         V6jDg89pJmvHXJZB/unFwRI8X9pxsZKfEI4CQjGYLYMjRB145inSYPw3fPpW8DvNKdHY
         Jg+ipQNC9C5+ES03h6DcWYXHRc4Ec7t2ZETFGzJ8Mc6dPBDgTMylgC1SbyT22VblfLRN
         MMPfu8kEnf9dHHOmRwSFxG+/PTJW2jr0nviG3cnxOp+uKh/1Z/MC3w9LngpePwBzR8WS
         FegA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739583026; x=1740187826;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=x4s7pFI0aY9o6O21bKm5JYyoqQO0/jilZnXQOfrGt04=;
        b=Ap7QK8M5whixx3vS9HFUwYi9HXntf5MsYAJLzEKOMU4hOfSZt9ZWha0kWdNz1Gp6sh
         3KddaoqMiGKq9798WFKh4zxB6kwZZQO91DJMF8BGv3E/JUpPINXEGdmPCY3t+qFit3dA
         QV0XKB2byvClsXRkCKpisqG5QHFtkxDtBkymn24MvhXJ/VYjlSgGKv4oLoomtu/LoWoo
         gDtpGL1V+LoJ6u05tOO3AxxBnnuJiPjM8s60diwP7p6w7Y37V3/jkloBTWpTARiCzvWJ
         HSrGrNPHfFjieCed6wC58sirVIehEbaE16yIgnfFQ6tDKEzPf+fTM0FoswyPJ4ZCdy/u
         Mhkg==
X-Gm-Message-State: AOJu0YyT8zqqs4m26xeMpMNLhmCVwHRyEd6eY9YtdqwHqlLWByQ4ulJM
	/4nEVGoHAeAQe1n9sCmRVYatXvszSiFl5VThJNHXIgBOdbD5EToJpf7YLaPcqCf/+1WTvIx+HTT
	idA==
X-Google-Smtp-Source: AGHT+IEAFDp4Wh/lvhwQ7icQNdKaeJpkXkkSi2JKZ1n58yZhBJ9hX8TXrSnvFutznkk40EXIA+hTKHBv9iU=
X-Received: from pfbbd15.prod.google.com ([2002:a05:6a00:278f:b0:730:89cf:cf2e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:4f95:b0:730:8768:76d7
 with SMTP id d2e1a72fcca58-732618c29a9mr2122216b3a.17.1739583025757; Fri, 14
 Feb 2025 17:30:25 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 14 Feb 2025 17:30:15 -0800
In-Reply-To: <20250215013018.1210432-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250215013018.1210432-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250215013018.1210432-4-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v2 3/6] x86: Move struct invpcid_desc
 descriptor to processor.h
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Maxim Levitsky <mlevitsk@redhat.com>

Move struct invpcid_desc descriptor to processor.h so that it can be used
in tests that are external to pcid.c.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Link: https://lore.kernel.org/r/20240907005440.500075-4-mlevitsk@redhat.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/processor.h | 7 ++++++-
 x86/pcid.c          | 6 ------
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 9248a06b..bb54ec61 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -836,8 +836,13 @@ static inline void invlpg(volatile void *va)
 	asm volatile("invlpg (%0)" ::"r" (va) : "memory");
 }
 
+struct invpcid_desc {
+	u64 pcid : 12;
+	u64 rsv  : 52;
+	u64 addr : 64;
+};
 
-static inline int invpcid_safe(unsigned long type, void *desc)
+static inline int invpcid_safe(unsigned long type, struct invpcid_desc *desc)
 {
 	/* invpcid (%rax), %rbx */
 	return asm_safe(".byte 0x66,0x0f,0x38,0x82,0x18", "a" (desc), "b" (type));
diff --git a/x86/pcid.c b/x86/pcid.c
index c503efb8..7425e0fe 100644
--- a/x86/pcid.c
+++ b/x86/pcid.c
@@ -4,12 +4,6 @@
 #include "processor.h"
 #include "desc.h"
 
-struct invpcid_desc {
-    u64 pcid : 12;
-    u64 rsv  : 52;
-    u64 addr : 64;
-};
-
 static void test_pcid_enabled(void)
 {
     int passed = 0;
-- 
2.48.1.601.g30ceb7b040-goog


