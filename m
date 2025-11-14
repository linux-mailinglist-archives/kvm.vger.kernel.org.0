Return-Path: <kvm+bounces-63137-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 52633C5ABC0
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 01:14:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 0323F353DD5
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:14:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 962B42367AC;
	Fri, 14 Nov 2025 00:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Q7uNA9Ci"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BAC722A7E6
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 00:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763079201; cv=none; b=llfh2oqfd3HsWCwSBxZn5ScaUFgch+g8i0R6+IllZsq9em1F9D33/lcVox9ZWFK9o672RkUGWwU2caUTkyjCT2eInS/UdEgql+L/2KSi425YTaCDsIlJGjERF6y9CmTLIjfl8pVxqtkDaAXPZ8djLCTcO+hzTUepo3qII5TBpzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763079201; c=relaxed/simple;
	bh=RPXiHrb/THv1cH6Ul3eKvuNP50SujRr1Gedyr4o9NTE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=J+O+T6JvzBHAet3sTsUnom0v7oO1iyX4IOpMZu9v9VKg8RndnS0m49AofGNxlEGTisrMSsjGMV7xXBHYO1uDKv+8xpISyhOuRyv3EAFW5oPuiRrHwYvb+6O3ODlfzNKbT1cJNcM4euNV4vRcAsBUc7Sh7XS3V8o1cgBc7Y4vLJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Q7uNA9Ci; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3436e9e3569so3117326a91.2
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 16:13:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763079199; x=1763683999; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Zo47hSbM58dWwJRUo7/2AjoAf7lTnClyBAE8xb6EBzc=;
        b=Q7uNA9CiOOBXU9/VnkMN6CsG0xncoSCP33WfL3116BsPNd4d/7Bf2vh5xDQRzfw2/7
         QgJYvGoSj9YeCA7p4MxFeybTF9XBI3hxnHhx8lNCV4r7NwxxsUdbqxZioDd2KCi/PPpA
         tU7kH5PwX7rMUaHzeVGGFAkThNzBJ2vb5lBX4PEX+mccmTLr71/YXD8gZHK/nhJApos6
         E/J8fVppwLI4gXjb1pJ4Et8vvYV1vXtPvXC/9w+RL199H3z3kpcz5Er964nsaeB6UcGU
         6r9XD86p3uzcJkPXad1v9QB8E9TL7kJIYHY9i9H2uH/Dyib7LTzDWm1+C6Kga4jMfeyN
         OJqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763079200; x=1763684000;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Zo47hSbM58dWwJRUo7/2AjoAf7lTnClyBAE8xb6EBzc=;
        b=xF0AqT1Lt5BfWBBKfxXVkkd7KmLUCWo8Q0h/nqXnsAyxBsJt1qLMVmFllyxdxJSYxn
         uzaQcljt3AwNFfLhq6QUzYOAH+pyhnOnzzG9LHn/blxsXDszXnz0XePWpCqci3Nr1tKz
         Kso70Qi3fQIi2P9NMJ0mVmNtzvuo31lf+pF2EQPwoXUAs/IHQhuemZmpOfKEW1hSaINp
         nRft/qmTkEm8bDZ5EQ5psiEGLVl7NfL7IIjWEeoj0SD+OibdsEn0Dzxdj8zVtIpg+YFS
         OqEvnFdG4eHXG/BDteky9C8nvSvG6VSTxdx9b7EMQgm69Ej1M6Jbo3++gauN2bsGgUCH
         UcUQ==
X-Gm-Message-State: AOJu0YynBeDxRDrsew8EBgHhe75P4rF56f8Bv++29dtIkVgxodjA3cQx
	qetE0NglC7o0ZVU0z9cWdKNEgrw+AJ3DxUQDREM/VNknETclGj5t1FjXNS1ST4KYSqy6JxJFBAn
	VixgoYA==
X-Google-Smtp-Source: AGHT+IExaTijm4b/BWm6IVvb4g15QDFUOAFnDoSzUU3g9VD6wYKkQw15glJDNkYE8LLSlfHUMB56crDZDVA=
X-Received: from pjgg5.prod.google.com ([2002:a17:90b:57c5:b0:340:d03e:4ed9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4c85:b0:343:66e2:5f9b
 with SMTP id 98e67ed59e1d1-343fa73b681mr1209517a91.24.1763079199619; Thu, 13
 Nov 2025 16:13:19 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 13 Nov 2025 16:12:52 -0800
In-Reply-To: <20251114001258.1717007-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251114001258.1717007-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251114001258.1717007-12-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v3 11/17] x86: cet: Simplify IBT test
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>, Chao Gao <chao.gao@intel.com>, 
	Mathias Krause <minipli@grsecurity.net>
Content-Type: text/plain; charset="UTF-8"

From: Mathias Krause <minipli@grsecurity.net>

The inline assembly of cet_ibt_func() does unnecessary things and
doesn't mention the clobbered registers.

Fix that by reducing the code to what's needed (an indirect jump to a
target lacking the ENDBR instruction) and passing and output register
variable for it.

Signed-off-by: Mathias Krause <minipli@grsecurity.net>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/cet.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/x86/cet.c b/x86/cet.c
index 61059ef2..a1643c83 100644
--- a/x86/cet.c
+++ b/x86/cet.c
@@ -33,18 +33,17 @@ static uint64_t cet_shstk_func(void)
 
 static uint64_t cet_ibt_func(void)
 {
+	unsigned long tmp;
 	/*
 	 * In below assembly code, the first instruction at label 2 is not
 	 * endbr64, it'll trigger #CP with error code 0x3, and the execution
 	 * is terminated when HW detects the violation.
 	 */
 	printf("No endbr64 instruction at jmp target, this triggers #CP...\n");
-	asm volatile ("movq $2, %rcx\n"
-		      "dec %rcx\n"
-		      "leaq 2f(%rip), %rax\n"
-		      "jmp *%rax \n"
-		      "2:\n"
-		      "dec %rcx\n");
+	asm volatile ("leaq 2f(%%rip), %0\n\t"
+		      "jmpq *%0\n\t"
+		      "2:"
+		      : "=r"(tmp));
 	return 0;
 }
 
-- 
2.52.0.rc1.455.g30608eb744-goog


