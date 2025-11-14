Return-Path: <kvm+bounces-63266-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 55CFAC5F491
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 21:52:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 0F9734E1A7D
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 20:52:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E44E2FB99A;
	Fri, 14 Nov 2025 20:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2owZ+GYR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF3602FB990
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 20:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763153485; cv=none; b=gz8lhyRJ3hLN0b9MqKzjAzz4u9o5IkyBkUSPqtrJnEamHH/hyXXohI7aTgq+8rQT+zLqsoummnN6CKCx52+bVEoGlkhAEt4JIN2X4m2s1G79zWUMp1QJVPAEyTdZ9yd1iSjzbIsdmhJlCygO4jl61Dw0DrFwuuQ9OGQaUY4pJKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763153485; c=relaxed/simple;
	bh=RPXiHrb/THv1cH6Ul3eKvuNP50SujRr1Gedyr4o9NTE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=f3LhDV/6KKqQytlAGLoCnf3XSZWqOFTOcWezKVoXLCPAMkNoCWhOB8GANiVkCUCTU3pvGikE3ADE4o7oko/oRMC73TO8bKGIdyA3iKEjjVjtuFTzW39c0KO3n+/EN4IxhXhdtzBY31DXcWRtZbSuQuM9KKCgynh5o1sFcDPkrus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2owZ+GYR; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-295fbc7d4abso25821575ad.1
        for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 12:51:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763153483; x=1763758283; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Zo47hSbM58dWwJRUo7/2AjoAf7lTnClyBAE8xb6EBzc=;
        b=2owZ+GYR9mfF9lf6zcem81DOIdNeg/RDmUsrjYdUXKvzdhcNsalqqgicpkyC26DWM4
         c6MUiL/MkK50Cw7DyRMO7gFMxYKZPSHtFLcdpUPMw92fLtbUYu9oNl4oqDWIxp6L20gY
         /7CeybFBOTw7wWSHzob8SZo0guGTYSn2ieAfIEb1owGM49ZKWojV0AJnV+bA6dyll1br
         qQhq6JdNc41fvT7Fc+q/Kya3yMuK6FzTitgxfPTjetW/Pd8sLQ657amtliti7HjG4qZ6
         xtHJkg6sRbvACKPnMabRhi4vJYShwUvL3tX078xHOirDxfKXzd/lb6y5/YvjN8WFah9G
         5vgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763153483; x=1763758283;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Zo47hSbM58dWwJRUo7/2AjoAf7lTnClyBAE8xb6EBzc=;
        b=e88k6ozNHtIEoThV6meANC6MQHMZk+lKr+KF6kln5DrchElo1zZIhP9uoV+wYHFwgn
         Y6nLvnNtHERVKJINw2OjxtKefmrANIAq5U2pvzu/jtlqzU64Y/N83I7hsBe25UE6i8cR
         FNqBHay4cI6dWhq1enZ++HDemBS7WmyX3VaHbnuFl+v/n0cEgvc+xQsbYU7KVJYIYBZn
         +8mQp1GsZKUHdEUbXR+8URiPB0yTgr6qjeR2SJ0XwjDhj70Wh1JD+u8ZWV07jGKR87uA
         fQ4HoWiJ2i6P6Ql9baQZGhayUwtEfzZuDLgFO/vzdO6iGtvYUbUd+q//HgLxf8ExZLLH
         PhpA==
X-Gm-Message-State: AOJu0Yxijzp1qXMV2w6MV409gdytO6wR4iti+p6lPolpTuS0V6WFmT36
	YqySU2C+Hjub9roqZhv0awWU/OA0LJayPRt6A2eJ99kyAEnuqOTwxlz8PMZGvQBCbioaZaC1vHO
	VII39gg==
X-Google-Smtp-Source: AGHT+IHnkE1k0nVxUb+wfn7TCdYDy4FmtAL8mzWrJruXRgRrFSTrCHfm4KbwsAbZ9bJwIS+2i0a1AEqd/0w=
X-Received: from plbiy1.prod.google.com ([2002:a17:903:1301:b0:297:f793:fc65])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:286:b0:295:9d7f:9294
 with SMTP id d9443c01a7336-2986a6d6827mr46772805ad.21.1763153483144; Fri, 14
 Nov 2025 12:51:23 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 14 Nov 2025 12:50:52 -0800
In-Reply-To: <20251114205100.1873640-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251114205100.1873640-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251114205100.1873640-11-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v4 10/18] x86: cet: Simplify IBT test
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Chao Gao <chao.gao@intel.com>, 
	Mathias Krause <minipli@grsecurity.net>, Sean Christopherson <seanjc@google.com>
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


