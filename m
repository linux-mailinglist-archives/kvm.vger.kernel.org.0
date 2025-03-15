Return-Path: <kvm+bounces-41141-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D329A6251B
	for <lists+kvm@lfdr.de>; Sat, 15 Mar 2025 04:07:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8AEC17AB8E3
	for <lists+kvm@lfdr.de>; Sat, 15 Mar 2025 03:06:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D2D9192D9D;
	Sat, 15 Mar 2025 03:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rkaKDIb5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 558CD18E023
	for <kvm@vger.kernel.org>; Sat, 15 Mar 2025 03:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742007997; cv=none; b=imROPvga3n4LLgDz4fZjRt9Mn2qKhrsN6gab7i4O8pqbHZvdpjkHStSW4LezlSERZ1zoU6jRxGmBBoJ/1Sw2LOX8ueclNYFmg1z1mSHh+V89uFHuFFARZv+9CpMNAxqt47++4dWswgcSBk6GYIo4dPOxtRu7RM+apjn10XI8bJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742007997; c=relaxed/simple;
	bh=+WK1bltbWDTrbagBZEBAiy7h0kT2VEa0FdxHN4yhE9Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NegGDO3hofPz7FvBsBQzsCA9als5aEzHB30EeLBTM1LROcBDmKnjPPtSaf/MG5lLI0kHm3adAI/e4SgeQ74lCjNcgnzHmFkCmctDZnzydpiTkNSILO/vV2u4ySA6HBptwvKSDGVUhA6vZcMjf4dNv7r4M9VGbN8h8/0x7MxQIz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rkaKDIb5; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ff7cf599beso712122a91.0
        for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 20:06:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742007996; x=1742612796; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=vHe6yayu6Pa5fekV1jp+JV4SQqE+N7492v9RWvirBCU=;
        b=rkaKDIb5IkP2/N6o1yzoZwGPAerPT2LrFdFzI6HhSTjTCFDQ7TLxX1y9HjPlTNhSUk
         2UZU4RIiQiugLzYpehug2+xrSxYHZb4JIVLgCd/hmE2SbTZC/lIEKTPsdx7PfRr/iis6
         YCtiSH7EKRXmstg1DMbiy9/i2ynO5xOjkxqqOLm560glBJXGSp301U1kOuv6EwX+J76n
         SVECsJc66XIj5MXLZgeGvFfUaRlA0WfMzmTKXiPFxgcJXm+2qwCeId/ZJZClkMCEja7Q
         GK5PYr9bxWsxMgWInBILKkXSgIiFcHnSMvc9kXIWfjQlb4XQkJcNMev4SS6mAe6qzlyT
         /2jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742007996; x=1742612796;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vHe6yayu6Pa5fekV1jp+JV4SQqE+N7492v9RWvirBCU=;
        b=SiW+wYUJSujbpQVMjwWRbayYoPGKp/bDSf0q5lhzBr4mC03Q1OKG3c8vlyoTv1b8Af
         Os8s6QwPUhsB8qIDv40A1ZXh8qYb7gS6+SkSIy3yORTbs0Q3F3nr/ql6ocVVbz9W9I9q
         sB3VV+NVSiNx3P3q3d7B5VGHhwoCrRcwtSnpo08u7ibQsqM0O4KpWRmHzNiRY5hfX001
         hzKTx3wOqAwGvQVIA6u5RVxZ6SCM0xLCjF0wZTgx28ef33A0im56qBmBjuNJhOS5myO4
         SCXgEV8fzzJGlX3VGv0KgG8D0pga2a1XJr74pW8t+ZJa+YVZCMrxPwBpKOmifHMkf9IF
         pASQ==
X-Forwarded-Encrypted: i=1; AJvYcCWGLbFVQqdZmKG1Hjz2FeltH5P2I4IE7XjOEJGsl/061fPmp8Ky4CpJYGPRGjU1p1Pn62M=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5I3NMIvy4DA1n8og6Rkwc37BOggGo230mgBf429Fu35Oh/oXJ
	YpAjB9Hxv2aLuNJoQAFR27CYivFsVHU4dL5AusQp6YML15U37Z1XlOI20Tiitupo4jy9OCBSLJS
	QOQ==
X-Google-Smtp-Source: AGHT+IHm3ikpa45S+MzJ9ChgrVNIn//2DPUl62WT86s6estUNWscdmElpdksr3RkSuK4oMZ2hPanzmR+FmA=
X-Received: from pjbsc17.prod.google.com ([2002:a17:90b:5111:b0:2ea:aa56:49c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5387:b0:2ff:4a8d:74f8
 with SMTP id 98e67ed59e1d1-30151c9a341mr5024590a91.6.1742007995777; Fri, 14
 Mar 2025 20:06:35 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 14 Mar 2025 20:06:23 -0700
In-Reply-To: <20250315030630.2371712-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250315030630.2371712-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.rc1.451.g8f38331e32-goog
Message-ID: <20250315030630.2371712-3-seanjc@google.com>
Subject: [PATCH 2/8] x86/irq: Track if IRQ was found in PIR during initial
 loop (to load PIR vals)
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Jacob Pan <jacob.jun.pan@linux.intel.com>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

Track whether or not at least one IRQ was found in PIR during the initial
loop to load PIR chunks from memory.  Doing so generates slightly better
code (arguably), especially for the case where there are no pending IRQs.

Note, while PIR can be modified between the initial load and the XCHG, it
can only _gain_ new IRQs, i.e. there is no danger of a false positive due
to the final version of pir_copy[] being empty.

Opportunistically rename the boolean in anticipation of moving the PIR
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
 arch/x86/kernel/irq.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 9e5263887ff6..3f95b00ccd7f 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -409,25 +409,28 @@ static __always_inline bool handle_pending_pir(u64 *pir, struct pt_regs *regs)
 {
 	int i, vec = FIRST_EXTERNAL_VECTOR;
 	unsigned long pir_copy[4];
-	bool handled = false;
+	bool found_irq = false;
 
-	for (i = 0; i < 4; i++)
+	for (i = 0; i < 4; i++) {
 		pir_copy[i] = READ_ONCE(pir[i]);
+		if (pir_copy[i])
+			found_irq = true;
+	}
+
+	if (!found_irq)
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
2.49.0.rc1.451.g8f38331e32-goog


