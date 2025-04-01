Return-Path: <kvm+bounces-42372-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 21B76A780C2
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 18:44:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E700518883EF
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 16:44:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 113F620F07E;
	Tue,  1 Apr 2025 16:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hVa7N9El"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B22C920E309
	for <kvm@vger.kernel.org>; Tue,  1 Apr 2025 16:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743525799; cv=none; b=fo+WYRLk04yX2XDMG1bQaMMVQKgan4GQxNWYLonNrWwLmYizqGZQhZ23J0vJwvfUViL7L6b5+1C/XVRQ1SRm6FLGZfKK9c6cmHDTKgQ6u/AbYrmAs2p9sjUo+oQBcx2SVBRgjq8AcuTI9Z0E3cacpnnusUrAkHAjaPWwtxkgqn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743525799; c=relaxed/simple;
	bh=jGuwQyi4PUoNb9tVJY2auvrWnk5ldsHm2gyBlrKR40I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Gp63UGaJ5MwwJk1P76eI9tnLsJjDSqX5EMs06LfZrhBnRc1IrSYWeX4y0jezzPYn3+anHNRAE/pA21qVe27q1Ws8B5E/0Zp72Ttvj3TUkE30+BPC1i7XBLiY7EgF+H/PPUTsTar8g6FpZDanPyLqBfV7EhR6NPsN5iI9+LhXhBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hVa7N9El; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2254e500a73so77471365ad.0
        for <kvm@vger.kernel.org>; Tue, 01 Apr 2025 09:43:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743525797; x=1744130597; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=cDvP5BZpEDyKBmPstvDIZN80Syur3P8OaOWHbakcInk=;
        b=hVa7N9ElrbNfcAg1jLOLP5EPxthvxMGVYFreS7KIRdo6rOKEzm52+yLMNQleULnE4g
         MiJm9t67idfdGe0PgNVfr/uVIZg4AWNy9IWk7aAVquEypW1Jx6ZonnVmYiNGtutctN/g
         op7VCaUpr3vLPtm0tnN3wMDWeBh2fMqjkC8V+n5cITDfoWrfTnTBWqhk87x8hzRaJvX9
         k6dpgkiJ0Q2Hie7qI9zcEl856CIUem2YIUqC49m5hdknnNoWXTxR2IkTZ7TyzJhJmG8w
         3XTdpIsuMe8McNsA1BAaWAW4yxcQOPY/RGyMZI6NmX3XAiFcczj/K7PtJJJk0rAPEu8k
         6uaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743525797; x=1744130597;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cDvP5BZpEDyKBmPstvDIZN80Syur3P8OaOWHbakcInk=;
        b=AeQNPpUBXIUONS3NJnKxoLF+7SWLXFm7Vi80xegOjbdScsVPW8AehO7tK1I/2IQW3i
         TwoE8zyQfLuBWNeLYObHDibLtZofQb3ofS0fmG8NmlNKx6j0c8nQcNoO0oHU6UaJsrR1
         oGDlhEzDyHdcT1BjRAY1VnqB1kXhmjmZQzpB1IYRRkTSbgddCf1w9GfNA7c+h0yjj27g
         r2qPqSwSnVWpGemHWcfzSuTzmqecwoujbFT2bz3JYYvLJHJc0euCSigu8zDU/YMhLZ02
         nfsCq/facUZzW8QEmYnQZ68d9B5rPHeYE1L3bVN6ZPQNt7MUBToFC9vFN7dTpbZIjIwn
         m4zA==
X-Forwarded-Encrypted: i=1; AJvYcCVHUUNz63ssmnDRhxvNGACZd8GwwwW0DVKLIPzJUYledbSXS5qnmU4IvaGQwKqKEo7EWSc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0YKRrmfrncUTjEQ7s321SoFw/QPhjLYOQBkFIPw7JyqqmsXCx
	m0njVl9gfIe2JXQa9/G6XYDI/7rvdZZiXqeAIoSzqneeh1B84lsA9dbFAx/UEQlS5u+mVmuBwqz
	a4Q==
X-Google-Smtp-Source: AGHT+IGxxWnUBIlHU15BzVG9W/GeQ6sCwXTyMrI61xhzsb0eCK4R7c40Z6JqSwtcB6fShFN5RLpLo6Zov7E=
X-Received: from pfbfo6.prod.google.com ([2002:a05:6a00:6006:b0:736:3cd5:ba36])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1901:b0:739:48f2:4374
 with SMTP id d2e1a72fcca58-739b5ff7f6cmr5338777b3a.10.1743525797032; Tue, 01
 Apr 2025 09:43:17 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  1 Apr 2025 09:34:41 -0700
In-Reply-To: <20250401163447.846608-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250401163447.846608-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.472.ge94155a9ec-goog
Message-ID: <20250401163447.846608-3-seanjc@google.com>
Subject: [PATCH v2 2/8] x86/irq: Track if IRQ was found in PIR during initial
 loop (to load PIR vals)
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

Track whether or not at least one IRQ was found in PIR during the initial
loop to load PIR chunks from memory.  Doing so generates slightly better
code (arguably) for processing the for-loop of XCHGs, especially for the
case where there are no pending IRQs.

Note, while PIR can be modified between the initial load and the XCHG, it
can only _gain_ new IRQs, i.e. there is no danger of a false positive due
to the final version of pir_copy[] being empty.

Opportunistically convert the boolean to an "unsigned long" and compute
the effective boolean result via bitwise-OR.  Some compilers, e.g.
clang-14, need the extra "hint" to elide conditional branches.

Opportunistically rename the variable in anticipation of moving the PIR
accesses to a common helper that can be shared by posted MSIs and KVM.

Old:
   <+74>:	test   %rdx,%rdx
   <+77>:	je     0xffffffff812bbeb0 <handle_pending_pir+144>
   <pir[0]>
   <+88>:	mov    $0x1,%dl>
   <+90>:	test   %rsi,%rsi
   <+93>:	je     0xffffffff812bbe8c <handle_pending_pir+108>
   <pir[1]>
   <+106>:	mov    $0x1,%dl
   <+108>:	test   %rcx,%rcx
   <+111>:	je     0xffffffff812bbe9e <handle_pending_pir+126>
   <pir[2]>
   <+124>:	mov    $0x1,%dl
   <+126>:	test   %rax,%rax
   <+129>:	je     0xffffffff812bbeb9 <handle_pending_pir+153>
   <pir[3]>
   <+142>:	jmp    0xffffffff812bbec1 <handle_pending_pir+161>
   <+144>:	xor    %edx,%edx
   <+146>:	test   %rsi,%rsi
   <+149>:	jne    0xffffffff812bbe7f <handle_pending_pir+95>
   <+151>:	jmp    0xffffffff812bbe8c <handle_pending_pir+108>
   <+153>:	test   %dl,%dl
   <+155>:	je     0xffffffff812bbf8e <handle_pending_pir+366>

New:
   <+74>:	mov    %rax,%r8
   <+77>:	or     %rcx,%r8
   <+80>:	or     %rdx,%r8
   <+83>:	or     %rsi,%r8
   <+86>:	setne  %bl
   <+89>:	je     0xffffffff812bbf88 <handle_pending_pir+360>
   <+95>:	test   %rsi,%rsi
   <+98>:	je     0xffffffff812bbe8d <handle_pending_pir+109>
   <pir[0]>
   <+109>:	test   %rdx,%rdx
   <+112>:	je     0xffffffff812bbe9d <handle_pending_pir+125>
   <pir[1]>
   <+125>:	test   %rcx,%rcx
   <+128>:	je     0xffffffff812bbead <handle_pending_pir+141>
   <pir[2]>
   <+141>:	test   %rax,%rax
   <+144>:	je     0xffffffff812bbebd <handle_pending_pir+157>
   <pir[3]>

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kernel/irq.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 85fa2db38dc4..5d732ff357ef 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -409,27 +409,28 @@ void intel_posted_msi_init(void)
  */
 static __always_inline bool handle_pending_pir(u64 *pir, struct pt_regs *regs)
 {
+	unsigned long pir_copy[4], pending = 0;
 	int i, vec = FIRST_EXTERNAL_VECTOR;
-	unsigned long pir_copy[4];
-	bool handled = false;
 
-	for (i = 0; i < 4; i++)
+	for (i = 0; i < 4; i++) {
 		pir_copy[i] = READ_ONCE(pir[i]);
+		pending |= pir_copy[i];
+	}
+
+	if (!pending)
+		return false;
 
 	for (i = 0; i < 4; i++) {
 		if (!pir_copy[i])
 			continue;
 
 		pir_copy[i] = arch_xchg(&pir[i], 0);
-		handled = true;
 	}
 
-	if (handled) {
-		for_each_set_bit_from(vec, pir_copy, FIRST_SYSTEM_VECTOR)
-			call_irq_handler(vec, regs);
-	}
+	for_each_set_bit_from(vec, pir_copy, FIRST_SYSTEM_VECTOR)
+		call_irq_handler(vec, regs);
 
-	return handled;
+	return true;
 }
 
 /*
-- 
2.49.0.472.ge94155a9ec-goog


