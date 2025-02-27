Return-Path: <kvm+bounces-39428-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D0667A4709F
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 02:01:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D0C0716E97F
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 01:01:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C746D22F01;
	Thu, 27 Feb 2025 01:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jGTj5zd7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 881FA74040
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 01:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740618079; cv=none; b=GGMUkopp1F6ToLoFAEb1zIzLvag6V0J6dLqwYUyQCZ6Qn+zyOCdWBHzi1PycZmNGDA+370prJwvIhv84BZXpn3lduywH9LXZ2+DcLj0aNtwk9oymHCI79kmcDGnYkM1sDPceJ5ArfGZbVePbGk0gnAhs6Pslnm1HSYS8NMxJYLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740618079; c=relaxed/simple;
	bh=GZ6qMOoOVuiq1MAFI9FkQ+kQcduE2jvLA2wNIUu2RL4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VmF+Fzk869R9+exrYXJ58bhJSAMpqbBrGSGxRWz6LY+GPOIzPCHW9CYy/Rqmcl5awKof0AmLDbfO0rJVrfop/PZ495kI6VgBGSmVWGznSeY681RTrQN3wXYA5tAn4a8/sln0WG/d8/I6EdnJ4qzHsF1sgAghmfwRU9eFo1sNzu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jGTj5zd7; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2f83e54432dso1334018a91.2
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 17:01:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740618076; x=1741222876; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=RDoWSiiBmUA4Cvc4ko+cuVneWh/qlxcsIoQ/Ggi5MbQ=;
        b=jGTj5zd7Pl7Sjfe3lxYdK3cPRnlbeKCHyeOl4JzzQRM5+RX/cqOMH98XLyVndS9JN1
         Q8VSThw7CWrJVAwb/xpCZYkKk22v6PMk94gTJj7RAoVnaO0uWoL9uSKbORHF/VQohTE3
         jnMBpTxB5cfwzMJGs/7/VVQj70B4AGaUCofjb+TzOV9YTUbCXXXG9zDoROIynInqFc4D
         Knet/4v7FlJwDrEvHnz+jC93UFaRQWgYR8nKvgeXwq9v/uF9iBoqb2aNvRZeXgdcQtlY
         oc6Dt5i5IlrZ7ZwO7kf/jZBbYKSsZs2AZB9MkQpTdFVf2z6NTxip0gJ7xyFE+8hLl1se
         tHXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740618076; x=1741222876;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RDoWSiiBmUA4Cvc4ko+cuVneWh/qlxcsIoQ/Ggi5MbQ=;
        b=fFEX9QZCeptc5vFYBv0uGiVHyxYz0CMlU6Q5f55uN53Y4LBG2R/BOV8CdXiKUlO2H0
         xZEJsN2qgv8xRKR53sCJqESQWikRW+lELnsJN0E5qYT8hwJMnEL5dJDDQ8c9E4e03tX/
         eEV2TWhOr8hWY/g52Lj9l+jSk0vtbbqWJyyJibaqOH1J+HN2y3CcnS7wR6JSiUQ+cHjV
         3duVFrU84QkPyf3fNF0tU8oELpIxiu+qXWOP3zZi5APEI38xqXjsWASehc+fIjkRMWXu
         DE1RQxrKY86OGY/fclfpZFLEzpYwwHsWb80kczsQrzbSKD4H0hkAzd0UfiI7thvfzOJY
         G0Fw==
X-Gm-Message-State: AOJu0YyWthXol8STja0hVVBohybW0y6wOIAsKqAZ6FqUmq7BAh/RA6pA
	sWS7yQC1iCIrQBjKU0s/AfTAxaNhEaFsYmlKkrEPxrYNnz6Y6+XVmSKmZiqNPYPGE4LFIIL9Mmr
	mkg==
X-Google-Smtp-Source: AGHT+IH1hWe5Okz6/gdiRccw2sOEjxHYPXs3ilAyiVOoy2RH4ZzxsE7mftj9onRF83A6Ybwzulh3XobBvzI=
X-Received: from pjbtb8.prod.google.com ([2002:a17:90b:53c8:b0:2fc:ccfe:368])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5686:b0:2ee:aed6:9ec2
 with SMTP id 98e67ed59e1d1-2fe7e30045emr10064662a91.14.1740618075925; Wed, 26
 Feb 2025 17:01:15 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 26 Feb 2025 17:01:10 -0800
In-Reply-To: <20250227010111.3222742-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250227010111.3222742-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250227010111.3222742-2-seanjc@google.com>
Subject: [PATCH 1/2] x86/msr: Rename the WRMSRNS opcode macro to ASM_WRMSRNS
 (for KVM)
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Xin Li <xin@zytor.com>
Content-Type: text/plain; charset="UTF-8"

Rename the WRMSRNS instruction opcode macro so that it doesn't collide
with X86_FEATURE_WRMSRNS when using token pasting to generate references
to X86_FEATURE_WRMSRNS.  KVM heavily uses token pasting to generate KVM's
set of support feature bits, and adding WRMSRNS support in KVM will run
will run afoul of the opcode macro.

  arch/x86/kvm/cpuid.c:719:37: error: pasting "X86_FEATURE_" and "" "" does not
                                      give a valid preprocessing token
  719 |         u32 __leaf = __feature_leaf(X86_FEATURE_##name);                \
      |                                     ^~~~~~~~~~~~

KVM has worked around one such collision in the past by #undef'ing the
problematic macro in order to avoid blocking a KVM rework, but such games
are generally undesirable, e.g. requires bleeding macro details into KVM,
risks weird behavior if what KVM is #undef'ing changes, etc.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/msr.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index 001853541f1e..60b80a36d045 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -300,7 +300,7 @@ do {							\
 #endif	/* !CONFIG_PARAVIRT_XXL */
 
 /* Instruction opcode for WRMSRNS supported in binutils >= 2.40 */
-#define WRMSRNS _ASM_BYTES(0x0f,0x01,0xc6)
+#define ASM_WRMSRNS _ASM_BYTES(0x0f,0x01,0xc6)
 
 /* Non-serializing WRMSR, when available.  Falls back to a serializing WRMSR. */
 static __always_inline void wrmsrns(u32 msr, u64 val)
@@ -309,7 +309,7 @@ static __always_inline void wrmsrns(u32 msr, u64 val)
 	 * WRMSR is 2 bytes.  WRMSRNS is 3 bytes.  Pad WRMSR with a redundant
 	 * DS prefix to avoid a trailing NOP.
 	 */
-	asm volatile("1: " ALTERNATIVE("ds wrmsr", WRMSRNS, X86_FEATURE_WRMSRNS)
+	asm volatile("1: " ALTERNATIVE("ds wrmsr", ASM_WRMSRNS, X86_FEATURE_WRMSRNS)
 		     "2: " _ASM_EXTABLE_TYPE(1b, 2b, EX_TYPE_WRMSR)
 		     : : "c" (msr), "a" ((u32)val), "d" ((u32)(val >> 32)));
 }
-- 
2.48.1.711.g2feabab25a-goog


