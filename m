Return-Path: <kvm+bounces-38270-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C1C90A36B21
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 02:38:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4B621188CF89
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 01:38:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49D9D189919;
	Sat, 15 Feb 2025 01:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qVv2Bv2H"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBAE3189903
	for <kvm@vger.kernel.org>; Sat, 15 Feb 2025 01:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739583428; cv=none; b=PbFi7LLtA/BjExTPvkF6AiwsiAE2nUoiH9fyALfDpgz2rgoA1BSSxDbZBlxvzsgGLDifIsShQ07xIa1ASAeVhgrejc/Je8fwEbPUPlw4uPnOQHGZG+W2zYEUl8RcFJi2IE07aDyhjlGXdbe1sE+6Xga2z0O8FUSx3YRIt/rfAuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739583428; c=relaxed/simple;
	bh=iFMEaSFr4u6QO2xWJa+JTHxQfiTPDCuqBDfEN6Irbjc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=r/+iKaSGKdhuULfk4eoqaxjkIvdHRtt6UDX6lQ0dFCGU65WvfJK1BczuZU+WpprC1GJtwXp6Pijpq9xKktllArmCT8Mzr7cUQ2L7FkP/wdnZk1n+87dM7/sz4jL+dRUACu1HicNgZjdi6C4YYILQKTmRQNFMfo2fKLhzqq4iyk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qVv2Bv2H; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-220e62c4f27so53649855ad.0
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 17:37:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739583425; x=1740188225; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=YkGxjySw6SeU0HbZY6za+CWENo+jqBmvTmjBTneSZ8k=;
        b=qVv2Bv2HhmxlaIOuZJ25t4fgB9uMTbWDWhp0X9rWZFKU19qWLd7pjVGYj/+qSCaYkK
         YlIr3OCYSebYnT66v3QTHyxmL7lawusv2YxHXUaoJo2Lov5R5reW5Ytzt4m2pOISCn4O
         7qFgoaOL49v/vmJOdzav6F/LVZgRk/fYjR5YUXadCaJFXtkux4wiQLmCtUeG+sOiGpMt
         cxMBt11yVxOlr+ApDERAgR0F4tqnq9SFV/RLcO9b0gAxgjWPXMo23J514L3T3panYFZ/
         i/8T+YboAr/fAtf3q0dy3WU/g1IRzc4FpkAnmpNMiQgUBvuz5hyMGBDzJILmYlTOalkv
         QpSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739583425; x=1740188225;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YkGxjySw6SeU0HbZY6za+CWENo+jqBmvTmjBTneSZ8k=;
        b=lP/K/dt6lqih+DjsgEyfuKbki4UghREuefWc3n8Qp/6BjLonrc5CBWNmBqcWM3A0O2
         PnVGD2YRRiyTiPgZUbGdo6aUZCZqjo8okAxh/2ixAr/BgSKOx6qh0xR5qd9f6NsIFr22
         pmrHGYl+m/TG3oux+hly0PHscdvunyQBOrXetCvrsM5TSZxdj3x1BR5xFr0pBm9eOT6h
         dqCOY8lt0huknwlo4k9Nw7d+IoBJXwYSVbLPR4xCg9Vso1lTVujF1G8tyFrbx3hXJ5LF
         0Yj108Tz5I7KuPELT8RQcUlVlDbIe0RPIjGpQtfSJ2RNJDf1y+Yw4oQDkUmXqZskB5fH
         dQKA==
X-Gm-Message-State: AOJu0YyECLTCfug82Kraiz14yVYIIqDLLmmecyxXVGg8iT7MGhtSzz4M
	rR0dU/ce9+/Xd7JKS3DvIjxW0gOq5L7G2xcKvBo3HdmS64I/FVnmm2dNB0QXtiI28xswswNahSF
	Elw==
X-Google-Smtp-Source: AGHT+IECyQ7q8FWPgGZ5e/ti558oMBcj8hGILm7/pQeXGmZwwjuI7c3Ub+v53i1RP4x/WoHyYG5Wow/5PSI=
X-Received: from plbko6.prod.google.com ([2002:a17:903:7c6:b0:21f:193c:fe98])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d542:b0:215:f1c2:fcc4
 with SMTP id d9443c01a7336-221040bc31bmr24400625ad.41.1739583425385; Fri, 14
 Feb 2025 17:37:05 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 14 Feb 2025 17:36:33 -0800
In-Reply-To: <20250215013636.1214612-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250215013636.1214612-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250215013636.1214612-17-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v7 16/18] x86: pmu: Add IBPB indirect jump asm blob
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>, 
	Xiong Zhang <xiong.y.zhang@intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Mingwei Zhang <mizhang@google.com>, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

Currently the lower boundary of branch misses event is set to 0.
Strictly speaking 0 shouldn't be a valid count since it can't tell us if
branch misses event counter works correctly or even disabled. Whereas
it's also possible and reasonable that branch misses event count is 0
especailly for such simple loop() program with advanced branch
predictor.

To eliminate such ambiguity and make branch misses event verification
more acccurately, an extra IBPB indirect jump asm blob is appended and
IBPB command is leveraged to clear the branch target buffer and force to
cause a branch miss for the indirect jump.

Suggested-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/pmu.c | 70 ++++++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 56 insertions(+), 14 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index 1fc94f26..63156ea8 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -19,24 +19,52 @@
 #define EXPECTED_INSTR 17
 #define EXPECTED_BRNCH 5
 
-/* Enable GLOBAL_CTRL + disable GLOBAL_CTRL + clflush/mfence instructions */
-#define EXTRA_INSNS  (3 + 3 +2)
+#define IBPB_JMP_INSNS		9
+#define IBPB_JMP_BRANCHES	2
+
+#if defined(__i386__) || defined(_M_IX86) /* i386 */
+#define IBPB_JMP_ASM(_wrmsr)				\
+	"mov $1, %%eax; xor %%edx, %%edx;\n\t"		\
+	"mov $73, %%ecx;\n\t"				\
+	_wrmsr "\n\t"					\
+	"call 1f\n\t"					\
+	"1: pop %%eax\n\t"				\
+	"add $(2f-1b), %%eax\n\t"			\
+	"jmp *%%eax;\n\t"                               \
+	"nop;\n\t"					\
+	"2: nop;\n\t"
+#else /* x86_64 */
+#define IBPB_JMP_ASM(_wrmsr)				\
+	"mov $1, %%eax; xor %%edx, %%edx;\n\t"		\
+	"mov $73, %%ecx;\n\t"				\
+	_wrmsr "\n\t"					\
+	"call 1f\n\t"					\
+	"1: pop %%rax\n\t"				\
+	"add $(2f-1b), %%rax\n\t"                       \
+	"jmp *%%rax;\n\t"                               \
+	"nop;\n\t"					\
+	"2: nop;\n\t"
+#endif
+
+/* GLOBAL_CTRL enable + disable + clflush/mfence + IBPB_JMP */
+#define EXTRA_INSNS  (3 + 3 + 2 + IBPB_JMP_INSNS)
 #define LOOP_INSNS   (N * 10 + EXTRA_INSNS)
-#define LOOP_BRANCHES  (N)
-#define LOOP_ASM(_wrmsr, _clflush)					\
-	_wrmsr "\n\t"							\
+#define LOOP_BRANCHES  (N + IBPB_JMP_BRANCHES)
+#define LOOP_ASM(_wrmsr1, _clflush, _wrmsr2)				\
+	_wrmsr1 "\n\t"							\
 	"mov %%ecx, %%edi; mov %%ebx, %%ecx;\n\t"			\
 	_clflush "\n\t"                                 		\
 	"mfence;\n\t"                                   		\
 	"1: mov (%1), %2; add $64, %1;\n\t"				\
 	"nop; nop; nop; nop; nop; nop; nop;\n\t"			\
 	"loop 1b;\n\t"							\
+	IBPB_JMP_ASM(_wrmsr2) 						\
 	"mov %%edi, %%ecx; xor %%eax, %%eax; xor %%edx, %%edx;\n\t"	\
-	_wrmsr "\n\t"
+	_wrmsr1 "\n\t"
 
-#define _loop_asm(_wrmsr, _clflush)				\
+#define _loop_asm(_wrmsr1, _clflush, _wrmsr2)			\
 do {								\
-	asm volatile(LOOP_ASM(_wrmsr, _clflush)			\
+	asm volatile(LOOP_ASM(_wrmsr1, _clflush, _wrmsr2)	\
 		     : "=b"(tmp), "=r"(tmp2), "=r"(tmp3)	\
 		     : "a"(eax), "d"(edx), "c"(global_ctl),	\
 		       "0"(N), "1"(buf)				\
@@ -100,6 +128,12 @@ static struct pmu_event *gp_events;
 static unsigned int gp_events_size;
 static unsigned int fixed_counters_num;
 
+static int has_ibpb(void)
+{
+	return this_cpu_has(X86_FEATURE_SPEC_CTRL) ||
+	       this_cpu_has(X86_FEATURE_AMD_IBPB);
+}
+
 static inline void __loop(void)
 {
 	unsigned long tmp, tmp2, tmp3;
@@ -107,10 +141,14 @@ static inline void __loop(void)
 	u32 eax = 0;
 	u32 edx = 0;
 
-	if (this_cpu_has(X86_FEATURE_CLFLUSH))
-		_loop_asm("nop", "clflush (%1)");
+	if (this_cpu_has(X86_FEATURE_CLFLUSH) && has_ibpb())
+		_loop_asm("nop", "clflush (%1)", "wrmsr");
+	else if (this_cpu_has(X86_FEATURE_CLFLUSH))
+		_loop_asm("nop", "clflush (%1)", "nop");
+	else if (has_ibpb())
+		_loop_asm("nop", "nop", "wrmsr");
 	else
-		_loop_asm("nop", "nop");
+		_loop_asm("nop", "nop", "nop");
 }
 
 /*
@@ -127,10 +165,14 @@ static inline void __precise_loop(u64 cntrs)
 	u32 eax = cntrs & (BIT_ULL(32) - 1);
 	u32 edx = cntrs >> 32;
 
-	if (this_cpu_has(X86_FEATURE_CLFLUSH))
-		_loop_asm("wrmsr", "clflush (%1)");
+	if (this_cpu_has(X86_FEATURE_CLFLUSH) && has_ibpb())
+		_loop_asm("wrmsr", "clflush (%1)", "wrmsr");
+	else if (this_cpu_has(X86_FEATURE_CLFLUSH))
+		_loop_asm("wrmsr", "clflush (%1)", "nop");
+	else if (has_ibpb())
+		_loop_asm("wrmsr", "nop", "wrmsr");
 	else
-		_loop_asm("wrmsr", "nop");
+		_loop_asm("wrmsr", "nop", "nop");
 }
 
 static inline void loop(u64 cntrs)
-- 
2.48.1.601.g30ceb7b040-goog


