Return-Path: <kvm+bounces-63139-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 05751C5ABB1
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 01:14:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 82F984E7710
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:14:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5DF223C512;
	Fri, 14 Nov 2025 00:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kWjX1tto"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A073523A9AE
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 00:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763079205; cv=none; b=Nb2U2ppIoi+CBIhue+o8tMvpdsw401ZBWnImb28xJSkTFVu92/qa5UAhOqzF4PwTuzJfiVAlHUUddhUKoP4fH1gmZ+Zjit5fYZ9oFMVvrsgAriyltMSI7I0tObxbWJOVtljF/RUQTnj/8h7fb2WcIYy26/UPrnFJ3yDaUhAovSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763079205; c=relaxed/simple;
	bh=Up7F4n6gbsSj0LmGDH4ugVgi4MHUsh3K1T5NxM6ybmY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BTyRNe/czPDPHN9ZGYR5gX/SAnSAZJt0KWsYcDUuJVzZ0cSV7VKV1Nq3a1xMle2YFplNKRiJ7dg9HXA4cZFbiYYaTOS4ZEXF1ZUXejlhyGNAXkMhKhSKMdjQkU1u0+r3MCVSXOjamF68E65Ipl9wjH2m/ATBxWMAOR3g5MrMJqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kWjX1tto; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-343823be748so1826026a91.0
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 16:13:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763079203; x=1763684003; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Ajkwxsnw8UTLLCmio2wEKxdJJ0yhub7uVnVKnmR9rjw=;
        b=kWjX1ttosVYnaopTJR4sJpwqh/6nlpvI9vHEBSxOpM/SUl3YJhSGIbHVnzg8UPYMiJ
         ODRoB7vhvq/X1elvzTkGEYzzdy9zACGM9HqM/hSit6+Xf83cAju+ja+39Y0Xnd9uxZwX
         ZEXIf2EmKEgaoG95gYNlCp1KRS/w1HcokbLKheOylSl7HpCpGCW2anmZl/KvmJx3s9OU
         IdezuUD1iFEISQnGl0z6FnDjnbMlgClVXQl//qek5P6VF5YbSQ4Q8oxSlhl3iOcZrMzf
         +YfRnj51u+uffyZOU1/7ubi7Yet28ka+hRqIOeIvHCDY08gAgkz9YTNo8/KJyiSKAKI9
         K77Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763079203; x=1763684003;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ajkwxsnw8UTLLCmio2wEKxdJJ0yhub7uVnVKnmR9rjw=;
        b=eojDRZJQAEmNyGLZFUXkDzr4PXRk3lZmI1mDDn6FsYWceQ5vkLhp7ijaY4A98vgGiO
         QUU29V8dNShzXAEk9u3ueALXb1RXOkhYmOQMHwnKWbTTqTiDq7+RhgKE63erBCgLgs8A
         jXMKP88ntxqsKt/LVVQz6E2rgRk95WX5ogx9Y3Avu0N2dAiBQDOUz1nXiJW8HhVOYi6v
         FM8/UuU1m8EZCYtzw4WdvMMppEzMHhdOEMBmNiTnHbGzmK77w52jvZKHAiJrgn7Cl+A4
         wOlhcezE9mmDhc3u2o2GfrhnYNE3ejrLxLdibTNuyiPc8DP9jlw5WvLiYWYvB2eSHF8v
         2u/w==
X-Gm-Message-State: AOJu0YwsfRyyCZydXDhIQFueprE1KDCRAUuZgLY6oLMRNIhrlLMZHsZU
	eLYa2RwH8soVy/M//gM3OpzHDkgZN0GFHW7HDJOfbqG9K8QIXJ9DIEe/51dfNzMq4e34LPWRA3i
	9pkkCmw==
X-Google-Smtp-Source: AGHT+IHH9o45sdUBoKGQjowN+4ZtFJ1BvVh70WYZAZz0U/ndDx/FXYa5nNuJn6GjnoEn1ZnMKVgR+3fFWgU=
X-Received: from plgn12.prod.google.com ([2002:a17:902:f60c:b0:295:68e0:66ed])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:a90:b0:298:4ef0:5e98
 with SMTP id d9443c01a7336-2986a76a2c1mr9415805ad.56.1763079202859; Thu, 13
 Nov 2025 16:13:22 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 13 Nov 2025 16:12:54 -0800
In-Reply-To: <20251114001258.1717007-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251114001258.1717007-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251114001258.1717007-14-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v3 13/17] x86: cet: Test far returns too
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>, Chao Gao <chao.gao@intel.com>, 
	Mathias Krause <minipli@grsecurity.net>
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


