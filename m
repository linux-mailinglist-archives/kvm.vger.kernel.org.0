Return-Path: <kvm+bounces-14794-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BE3798A7142
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 18:21:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E11F71C22757
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 16:21:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BE9C132813;
	Tue, 16 Apr 2024 16:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pCxVV0w2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9FF61327E7
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 16:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713284495; cv=none; b=MjVHc5bsRnsjrQFkb2422toQmXQXNGgTlMsGkirgkOyNa6/gj5yuRP09wd4A+YLdhxms/nbbUztWpZA2ZD0/zYgmnvvh6FILZ1/aY5pIwIzcRl2UVXO0UEj45pvV61Vdl/HpMKXeM7GTaR1BD/cFMs87EeDeevCOEEoP+MfElrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713284495; c=relaxed/simple;
	bh=O5b9c5640BzzfVMVLecu7NgRW4URHOvsieLJjWOVZfY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=f8/93+QG/BXtdWGtAjc2/8BqmRGPDbrsvUpoq85OnboOogyf/IM9NdDCPN0tS19hWshfHHuJgBvcBMDn96D+xrf3yj1eyo/3Yc/Pq/PSNa4FjrrnjypHe/+FZLU8xzjVUH8jYnc7pla2fTHseiZDZPsOJLougczwiGlRqcAuH40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pCxVV0w2; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2a5e1e7bab9so4682934a91.2
        for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 09:21:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713284493; x=1713889293; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=K6HaXmqGlR6KdW24efqaI5FbhvJWf4Fq5iqQ3ifJoOs=;
        b=pCxVV0w2flvn85NzSYG9IY/ZOkNjwmufFIfh5l4+2Bl7ZKB5FwkRuFxeYT9kHIUC1j
         Wi/1nSZ7gR5kIGUKF0PrQLRDRe0WHHnRHIUlcJhjT4Pzy99kGD7wjnkxvxD/D0pL+diP
         I4aONBjcPXII34lEtxyHTFA9m8m77UL81LfcIRBQUUVMrFGiKWHBnqr4yRfc1dcgpXCO
         UGj4Cw7uNpvzkUyfsp7PtrCBqi/433FXb87zMlPbhLkaQeuU8cT/yyIKA7eB5AJ5KCwN
         ZJpE5588kMfeU7Hniehum6SVOpswkssSRYIl9m2aUfAVzIRYSd9ig/DVFBy7ubOhr3ej
         0LEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713284493; x=1713889293;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K6HaXmqGlR6KdW24efqaI5FbhvJWf4Fq5iqQ3ifJoOs=;
        b=ee5YCXjlFXVj31+uXidTIIG0ghOmU2jI/4ENCpVB91dt/CGYUoAlmyIEVgPUfLbNdR
         rn2ThjNPoYHOeB1SDdCVuzF8aObasfsP/tYCXV3f/m500wGQS3FAkrXfG+azXLQC7mzk
         Y56O96W7VgQ8OIbZv7E3GRvXG8a8QtxhogWh2owYVD/Re+5PQ3SIjFLNnQFQXyE67mlo
         UfTCxeABV7UCjsiT6jTRzc/y8DqAajCYCn+eMyNX+WBAXaIqoNFUNgG+4ayFb2la7/HN
         U7hJzkX7p7PMY9Hx9uY8vNlBbbbKq49GUO7VENHXwgIw3RoeaFYSADpY+qlGzntfR5Dv
         eEeg==
X-Forwarded-Encrypted: i=1; AJvYcCXuacI9Dh/ATp60yYOffZckcUWly6MZY2IKEQN+17vYcUAGIKJQJEso4vek6owm2wv70SGDptgATWrNdLIC7ovSZsI9
X-Gm-Message-State: AOJu0YxLvsbJYaZB95fC7RkEXc3wZ5r9pkUMdZDtGEKAcjrMKr19wK8O
	npI+JqE2a0HnBRdMBquolWVh0LyZMW/Ki58JTPEv3zF7qQPJ+zuKXXYxGifziaxmD7B7k7SDZ13
	yYQ==
X-Google-Smtp-Source: AGHT+IESndRZxmVYR3aWQFc8J3ywMq+W9T8nbAizR36ZNBEdo81XF49H9z5CVIBA1GFiZzgDNPlxqeFfE1o=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:cf01:b0:2a2:8afc:944d with SMTP id
 h1-20020a17090acf0100b002a28afc944dmr60424pju.3.1713284492989; Tue, 16 Apr
 2024 09:21:32 -0700 (PDT)
Date: Tue, 16 Apr 2024 09:21:31 -0700
In-Reply-To: <20240415172542.1830566-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240415172542.1830566-1-mizhang@google.com>
Message-ID: <Zh6liyoOJL9_Wifg@google.com>
Subject: Re: [kvm-unit-tests PATCH] x86: msr: Remove the loop for testing
 reserved bits in MSR_IA32_FLUSH_CMD
From: Sean Christopherson <seanjc@google.com>
To: Mingwei Zhang <mizhang@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Apr 15, 2024, Mingwei Zhang wrote:
> Avoid testing reserved bits in MSR_IA32_FLUSH_CMD. Since KVM passes through
> the MSR at runtime, testing reserved bits directly touches the HW and
> should generate #GP. However, some older CPU models like skylake with
> certain FMS do not generate #GP.
> 
> Ideally, it could be fixed by enumerating all such CPU models. The value
> added is would be low. So just remove the testing loop and allow the test
> pass.
> 
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> ---
>  x86/msr.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/x86/msr.c b/x86/msr.c
> index 3a041fab..76c80d29 100644
> --- a/x86/msr.c
> +++ b/x86/msr.c
> @@ -302,8 +302,6 @@ static void test_cmd_msrs(void)
>  		test_wrmsr_fault(MSR_IA32_FLUSH_CMD, "FLUSH_CMD", 0);
>  		test_wrmsr_fault(MSR_IA32_FLUSH_CMD, "FLUSH_CMD", L1D_FLUSH);
>  	}
> -	for (i = 1; i < 64; i++)
> -		test_wrmsr_fault(MSR_IA32_FLUSH_CMD, "FLUSH_CMD", BIT_ULL(i));

Rather than remove this entirely, what forcing emulation?  E.g. (compile tested
only, and haven't verified all macros)

---
 lib/x86/desc.h      | 30 ++++++++++++++++++++++++------
 lib/x86/processor.h | 18 ++++++++++++++----
 x86/msr.c           | 16 +++++++++++++++-
 3 files changed, 53 insertions(+), 11 deletions(-)

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
diff --git a/x86/msr.c b/x86/msr.c
index 3a041fab..2830530b 100644
--- a/x86/msr.c
+++ b/x86/msr.c
@@ -112,6 +112,16 @@ static void test_rdmsr_fault(u32 msr, const char *name)
 	       "Expected #GP on RDSMR(%s), got vector %d", name, vector);
 }
 
+static void test_wrmsr_fep_fault(u32 msr, const char *name,
+				 unsigned long long val)
+{
+	unsigned char vector = wrmsr_fep_safe(msr, val);
+
+	report(vector == GP_VECTOR,
+	       "Expected #GP on emulated WRSMR(%s, 0x%llx), got vector %d",
+	       name, val, vector);
+}
+
 static void test_msr(struct msr_info *msr, bool is_64bit_host)
 {
 	if (is_64bit_host || !msr->is_64bit_only) {
@@ -302,8 +312,12 @@ static void test_cmd_msrs(void)
 		test_wrmsr_fault(MSR_IA32_FLUSH_CMD, "FLUSH_CMD", 0);
 		test_wrmsr_fault(MSR_IA32_FLUSH_CMD, "FLUSH_CMD", L1D_FLUSH);
 	}
+
+	if (!is_fep_available())
+		return;
+
 	for (i = 1; i < 64; i++)
-		test_wrmsr_fault(MSR_IA32_FLUSH_CMD, "FLUSH_CMD", BIT_ULL(i));
+		test_wrmsr_fep_fault(MSR_IA32_FLUSH_CMD, "FLUSH_CMD", BIT_ULL(i));
 }
 
 int main(int ac, char **av)

base-commit: 38135e08a580b9f3696f9b4ae5ca228dc71a1a56
-- 


