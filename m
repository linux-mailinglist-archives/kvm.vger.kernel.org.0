Return-Path: <kvm+bounces-15033-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D91D78A8F4C
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 01:29:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8F0A52832F4
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 23:29:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEFBB8612C;
	Wed, 17 Apr 2024 23:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SS8Ccksu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCD8B85938
	for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 23:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713396552; cv=none; b=GUHLD7SVRyxYArhMQoEvoUbcEzfh8UPHjIPq9pyLlzKM2oR7ULqJrB2tjYPMY9vUoUK8jl8jH7C8ccO9ZQqFI/6WoJXJ7/SzZ5zKQGvP82VFwzEo3eJy/D0ZiBR4qla0N776g1/dQWwx3QSimg6LKpHcQ+3dYkv3C2SSmIaPmns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713396552; c=relaxed/simple;
	bh=DkS5o81iXQi2eVHIg5hhRdAwP+8uKR3UvUZxSz6vGxc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ocanddN1pGi74MBHi2cQJXnK2Ta/iEE8q9zCMoLIN2evi9eB6nwnITvs1LeIetUfl9JTn9CMSAIq+fY5zoSLKmvqd/s3uA4zLScFlr0T9R7rrJa3qKSdNCWMcKDmwmlcEO0ife3YiFAburqF0AETZ7Yu2ltmMTLjPymDuNscXtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SS8Ccksu; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1e4ad1c0fc8so3768885ad.2
        for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 16:29:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713396550; x=1714001350; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=jQqFFRXRU849ibmcFH3fAPe/axPrUFOxR1CKAjUb6P0=;
        b=SS8CcksugtX+fh9QqsD4u0rAAg/h3lG7FPG2wAxpojeMzK+wBv68KRfgeZHdHZIdZZ
         ElPBu3JpE3Qec9ysD8eYtLf4LWu+Fvw79TYnzWESjIgPE6R9WvlkV45Rf8G7n8h9sPgF
         nbFrSAPZ6j7eqfeWdZVNYnbJhwTqi4AZXV+YvGSqy+RpbbcJzzkSA7+fP2H/sPv6Ex3r
         cyWhz9fdHjmYcaUSKOF4ack+49dOlidDcYq5a6LXPVA15hZk0HAB8Abt3hw+3E6K5i1h
         SnM1vZjSZxjE6UX9KHPbYZGTHqgi4Ynfexe8clRRaK6u/89at5nSNVbU4MLov/AtKPj7
         HekA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713396550; x=1714001350;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jQqFFRXRU849ibmcFH3fAPe/axPrUFOxR1CKAjUb6P0=;
        b=EaHBDDz+Z8w/wEgknlCiBmcIDfDxED/SswPbMyRUbR4QxhQBrRgZ7DVY3yghl4kQJG
         bxreFRTxLWeQoqreHvf0SIS1INQhJkr6sNiZYo/kk92movDvcq68qzcsyXEwUL/zpc+t
         hSD3cYQ4RlLbAMCngft+k/RLvPKY+3yYkbzsj0TWUE7ko3jvJJSrnaW5CB8UTqLB9stU
         qAnLxiPaGJ16BfXcZ0iHsWTkY5VHM9USw8Cp/SGPelSt8hGWRzgxaQT49Az90RK8jWSD
         ecnbGp6CAUT+4xRQJjgQWupD4ewUfK5A0L2CtX21UV+LgQ2MyaelHhIWasSN8bdzwp10
         sV1w==
X-Gm-Message-State: AOJu0YxY1G/N6goTAaRPFDUxy5+tl5EdVKz+oxDuMP7naZa0BdVBQTGj
	JNayA+PqPLsvae1yU5UwuNYrVuX2/L6rI3QvZS5py8l53nmkGlEoxiGMONMFHGS8jBfq3LSOGoO
	wcdgncQ==
X-Google-Smtp-Source: AGHT+IGZquuROUBy5InYfFmY0Aj/dJdaZ5CcBeLKG/FKpBagPdyR/eNZug5iJ9aoTeLa/hMlf8yd9TDwLYOl
X-Received: from mizhang-super.c.googlers.com ([34.105.13.176]) (user=mizhang
 job=sendgmr) by 2002:a17:902:e84f:b0:1e2:96a1:afe6 with SMTP id
 t15-20020a170902e84f00b001e296a1afe6mr71789plg.12.1713396550104; Wed, 17 Apr
 2024 16:29:10 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Wed, 17 Apr 2024 23:29:05 +0000
In-Reply-To: <20240417232906.3057638-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240417232906.3057638-1-mizhang@google.com>
X-Mailer: git-send-email 2.44.0.683.g7961c838ac-goog
Message-ID: <20240417232906.3057638-2-mizhang@google.com>
Subject: [kvm-unit-tests PATCH v2 1/2] x86: Add FEP support on read/write
 register instructions
From: Mingwei Zhang <mizhang@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"

Add FEP support on read/write register instructions to enable testing rdmsr
and wrmsr when force emulation is turned on.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 lib/x86/desc.h      | 30 ++++++++++++++++++++++++------
 lib/x86/processor.h | 18 ++++++++++++++----
 2 files changed, 38 insertions(+), 10 deletions(-)

diff --git a/lib/x86/desc.h b/lib/x86/desc.h
index 7778a0f8..92c45a48 100644
--- a/lib/x86/desc.h
+++ b/lib/x86/desc.h
@@ -272,9 +272,9 @@ extern gdt_entry_t *get_tss_descr(void);
 extern unsigned long get_gdt_entry_base(gdt_entry_t *entry);
 extern unsigned long get_gdt_entry_limit(gdt_entry_t *entry);
 
-#define asm_safe(insn, inputs...)					\
+#define __asm_safe(fep, insn, inputs...)				\
 ({									\
-	asm volatile(ASM_TRY("1f")					\
+	asm volatile(__ASM_TRY(fep, "1f")				\
 		     insn "\n\t"					\
 		     "1:\n\t"						\
 		     :							\
@@ -283,9 +283,15 @@ extern unsigned long get_gdt_entry_limit(gdt_entry_t *entry);
 	exception_vector();						\
 })
 
-#define asm_safe_out1(insn, output, inputs...)				\
+#define asm_safe(insn, inputs...)					\
+	__asm_safe("", insn, inputs)
+
+#define asm_fep_safe(insn, output, inputs...)				\
+	__asm_safe_out1(KVM_FEP, insn, output, inputs)
+
+#define __asm_safe_out1(fep, insn, output, inputs...)			\
 ({									\
-	asm volatile(ASM_TRY("1f")					\
+	asm volatile(__ASM_TRY(fep, "1f")				\
 		     insn "\n\t"					\
 		     "1:\n\t"						\
 		     : output						\
@@ -294,9 +300,15 @@ extern unsigned long get_gdt_entry_limit(gdt_entry_t *entry);
 	exception_vector();						\
 })
 
-#define asm_safe_out2(insn, output1, output2, inputs...)		\
+#define asm_safe_out1(insn, output, inputs...)				\
+	__asm_safe_out1("", insn, output, inputs)
+
+#define asm_fep_safe_out1(insn, output, inputs...)			\
+	__asm_safe_out1(KVM_FEP, insn, output, inputs)
+
+#define __asm_safe_out2(fep, insn, output1, output2, inputs...)		\
 ({									\
-	asm volatile(ASM_TRY("1f")					\
+	asm volatile(__ASM_TRY(fep, "1f")				\
 		     insn "\n\t"					\
 		     "1:\n\t"						\
 		     : output1, output2					\
@@ -305,6 +317,12 @@ extern unsigned long get_gdt_entry_limit(gdt_entry_t *entry);
 	exception_vector();						\
 })
 
+#define asm_safe_out2(fep, insn, output1, output2, inputs...)		\
+	__asm_safe_out2("", insn, output1, output2, inputs)
+
+#define asm_fep_safe_out2(insn, output1, output2, inputs...)		\
+	__asm_safe_out2(KVM_FEP, insn, output1, output2, inputs)
+
 #define __asm_safe_report(want, insn, inputs...)			\
 do {									\
 	int vector = asm_safe(insn, inputs);				\
diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 44f4fd1e..d20496c0 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -430,12 +430,12 @@ static inline void wrmsr(u32 index, u64 val)
 	asm volatile ("wrmsr" : : "a"(a), "d"(d), "c"(index) : "memory");
 }
 
-#define rdreg64_safe(insn, index, val)					\
+#define __rdreg64_safe(fep, insn, index, val)				\
 ({									\
 	uint32_t a, d;							\
 	int vector;							\
 									\
-	vector = asm_safe_out2(insn, "=a"(a), "=d"(d), "c"(index));	\
+	vector = __asm_safe_out2(fep, insn, "=a"(a), "=d"(d), "c"(index));\
 									\
 	if (vector)							\
 		*(val) = 0;						\
@@ -444,13 +444,18 @@ static inline void wrmsr(u32 index, u64 val)
 	vector;								\
 })
 
-#define wrreg64_safe(insn, index, val)					\
+#define rdreg64_safe(insn, index, val)					\
+	__rdreg64_safe("", insn, index, val)
+
+#define __wrreg64_safe(fep, insn, index, val)				\
 ({									\
 	uint32_t eax = (val), edx = (val) >> 32;			\
 									\
-	asm_safe(insn, "a" (eax), "d" (edx), "c" (index));		\
+	__asm_safe(fep, insn, "a" (eax), "d" (edx), "c" (index));	\
 })
 
+#define wrreg64_safe(insn, index, val)					\
+	__wrreg64_safe("", insn, index, val)
 
 static inline int rdmsr_safe(u32 index, uint64_t *val)
 {
@@ -462,6 +467,11 @@ static inline int wrmsr_safe(u32 index, u64 val)
 	return wrreg64_safe("wrmsr", index, val);
 }
 
+static inline int wrmsr_fep_safe(u32 index, u64 val)
+{
+	return __wrreg64_safe(KVM_FEP, "wrmsr", index, val);
+}
+
 static inline int rdpmc_safe(u32 index, uint64_t *val)
 {
 	return rdreg64_safe("rdpmc", index, val);
-- 
2.44.0.683.g7961c838ac-goog


