Return-Path: <kvm+bounces-38268-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 64F6CA36B20
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 02:37:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0D96A188D37A
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 01:38:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8EE01624FD;
	Sat, 15 Feb 2025 01:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dXS8hbuV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D19A1624FE
	for <kvm@vger.kernel.org>; Sat, 15 Feb 2025 01:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739583424; cv=none; b=KyKFaSsar4CzqInR2xEGc4O+iXBguz4B0eUUfnCi6/VQsDtxM+G2ffD+IUmfuGKvIGDaeQiCjoYtNs5+TekQbz8qJzjvvZZ4c/CNjBm8LrLCjzHajCKI7217X8kx9DiK5wZ0hG17Cs9505vlu0L0k0S0MhYPo8QRMtk4amzULAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739583424; c=relaxed/simple;
	bh=1xmDQtVLijreQRQRBOSWuwkyhYbbJbgXpIh8cKvfn+0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oG3en+442AshCZ73d4Cmgh/iBpbR8FNi400uZk5xnXSnMWoTuStlDpsDNICeiLWY95dp5uDrHCg7JttDdnGaWsGGu6GZRy7ES4DERCAsuzfayx0Y1rWRUtMx1S8TZCK2X9bMOwlA8270ZiLq9F6984RdW1e8n0oy19J5cXj5qKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dXS8hbuV; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2f816a85facso5429702a91.3
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 17:37:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739583422; x=1740188222; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=kp8cbhkEefWj/oZJIeO/gLxPkRSxRvUGaEcxz3p1KuY=;
        b=dXS8hbuVwsXpblycbiSQLTbwSifrWLa10BhHfRnkWnI1ZoClO4GBYVwLPzjpTZpS+I
         NxgAO+66xj81+cphB1F624hC8V8NduAvsO1y5pDx43DnAvGEyO8j3MDouj6hftbmCrIF
         kDa6OUb9DZm6W5RzleOipND9klPuq/AHWMS5udRx9euDPqFyLEPReLxyNEWhmv61WbyS
         Tsoa+XMipurR/XYodicqTffZVstpQopRnpNOiMGhr2fI97f2S4MKA3dwutuSH8Xy6Nq1
         bFx4x+hTUO44xwxvlbifRqIqTwgb+CG8GEe/aOzUSRWm0T2YG8SSCXo4PwHtl7TCa0Vw
         HJdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739583422; x=1740188222;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kp8cbhkEefWj/oZJIeO/gLxPkRSxRvUGaEcxz3p1KuY=;
        b=Y/lYJWhBs7nmSMWyRlIL6aolJCmj94OUPLBaABpBG4Ah9PJreZ3/jUwSRNSdg8Dstj
         S8SUmyLSydCFTQX0Kg1nEqpX3yhMo53P2fESOa2ZdccIEqBh4CL9mWyPKZ3WlEUxfPu2
         kDpdpkOE97uewDowwtYEKUU+n1n1lNHpe5Kh3dMzu/HGjTyhC5IgHXFjZqdbuLN0qMhH
         X5TxLPpPMFTTobzx182o/0hwysYRv99WrNinNW9lcC6hB40mJ3GZqTPMcojO1dOw/FoT
         hneaUbDzk3I1IzIW6fdbsAntUYMs87W3Pvzy/xNO/zkh7SQVolGm7s4K0fNvf25H3BMq
         0OIA==
X-Gm-Message-State: AOJu0Yz8vWZAcc4CnNBxdc/D8pyORdwN/iv+9Ug2shmc+Hmq4RbeMBCr
	eKWpEWy8yGr+9WZL+Wym0doOWWUvUDpaTJrLYkYS0ieVQpgYEwj9P7Y1FvQnFnfEV++MwUZ4xgq
	PrA==
X-Google-Smtp-Source: AGHT+IFQcEIWZESSG1+LxhdxWi7042HSGA0UGj37URjUoMGfM/pvf4nLuk8QPF6jgvjxiq7M+Swg6pmATsQ=
X-Received: from pjbeu15.prod.google.com ([2002:a17:90a:f94f:b0:2fc:1eb0:5743])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1b0d:b0:2ee:c9b6:4c42
 with SMTP id 98e67ed59e1d1-2fc40f22cbamr2205833a91.16.1739583421997; Fri, 14
 Feb 2025 17:37:01 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 14 Feb 2025 17:36:31 -0800
In-Reply-To: <20250215013636.1214612-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250215013636.1214612-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250215013636.1214612-15-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v7 14/18] x86: pmu: Improve LLC misses event verification
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>, 
	Xiong Zhang <xiong.y.zhang@intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Mingwei Zhang <mizhang@google.com>, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

When running pmu test on SPR, sometimes the following failure is
reported.

  1 <= 0 <= 1000000
  FAIL: Intel: llc misses-4

Currently The LLC misses occurring only depends on probability. It's
possible that there is no LLC misses happened in the whole loop(),
especially along with processors have larger and larger cache size just
like what we observed on SPR.

Thus, add clflush instruction into the loop() asm blob and ensure once
LLC miss is triggered at least.

Suggested-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/pmu.c | 39 ++++++++++++++++++++++++++-------------
 1 file changed, 26 insertions(+), 13 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index 217ab938..97c05177 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -19,19 +19,30 @@
 #define EXPECTED_INSTR 17
 #define EXPECTED_BRNCH 5
 
-/* Enable GLOBAL_CTRL + disable GLOBAL_CTRL instructions */
-#define EXTRA_INSNS  (3 + 3)
+/* Enable GLOBAL_CTRL + disable GLOBAL_CTRL + clflush/mfence instructions */
+#define EXTRA_INSNS  (3 + 3 +2)
 #define LOOP_INSNS   (N * 10 + EXTRA_INSNS)
 #define LOOP_BRANCHES  (N)
-#define LOOP_ASM(_wrmsr)						\
+#define LOOP_ASM(_wrmsr, _clflush)					\
 	_wrmsr "\n\t"							\
 	"mov %%ecx, %%edi; mov %%ebx, %%ecx;\n\t"			\
+	_clflush "\n\t"                                 		\
+	"mfence;\n\t"                                   		\
 	"1: mov (%1), %2; add $64, %1;\n\t"				\
 	"nop; nop; nop; nop; nop; nop; nop;\n\t"			\
 	"loop 1b;\n\t"							\
 	"mov %%edi, %%ecx; xor %%eax, %%eax; xor %%edx, %%edx;\n\t"	\
 	_wrmsr "\n\t"
 
+#define _loop_asm(_wrmsr, _clflush)				\
+do {								\
+	asm volatile(LOOP_ASM(_wrmsr, _clflush)			\
+		     : "=b"(tmp), "=r"(tmp2), "=r"(tmp3)	\
+		     : "a"(eax), "d"(edx), "c"(global_ctl),	\
+		       "0"(N), "1"(buf)				\
+		     : "edi");					\
+} while (0)
+
 typedef struct {
 	uint32_t ctr;
 	uint32_t idx;
@@ -88,14 +99,17 @@ static struct pmu_event *gp_events;
 static unsigned int gp_events_size;
 static unsigned int fixed_counters_num;
 
-
 static inline void __loop(void)
 {
 	unsigned long tmp, tmp2, tmp3;
+	u32 global_ctl = 0;
+	u32 eax = 0;
+	u32 edx = 0;
 
-	asm volatile(LOOP_ASM("nop")
-		     : "=c"(tmp), "=r"(tmp2), "=r"(tmp3)
-		     : "0"(N), "1"(buf));
+	if (this_cpu_has(X86_FEATURE_CLFLUSH))
+		_loop_asm("nop", "clflush (%1)");
+	else
+		_loop_asm("nop", "nop");
 }
 
 /*
@@ -108,15 +122,14 @@ static inline void __loop(void)
 static inline void __precise_loop(u64 cntrs)
 {
 	unsigned long tmp, tmp2, tmp3;
-	unsigned int global_ctl = pmu.msr_global_ctl;
+	u32 global_ctl = pmu.msr_global_ctl;
 	u32 eax = cntrs & (BIT_ULL(32) - 1);
 	u32 edx = cntrs >> 32;
 
-	asm volatile(LOOP_ASM("wrmsr")
-		     : "=b"(tmp), "=r"(tmp2), "=r"(tmp3)
-		     : "a"(eax), "d"(edx), "c"(global_ctl),
-		       "0"(N), "1"(buf)
-		     : "edi");
+	if (this_cpu_has(X86_FEATURE_CLFLUSH))
+		_loop_asm("wrmsr", "clflush (%1)");
+	else
+		_loop_asm("wrmsr", "nop");
 }
 
 static inline void loop(u64 cntrs)
-- 
2.48.1.601.g30ceb7b040-goog


