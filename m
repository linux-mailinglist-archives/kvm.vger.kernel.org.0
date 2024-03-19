Return-Path: <kvm+bounces-12107-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 597ED87F8C4
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 09:03:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7DAA21C2184D
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 08:03:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 583A27C6CC;
	Tue, 19 Mar 2024 08:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PA5Xs2UQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E021A54780
	for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 08:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710835305; cv=none; b=Vht8P48EkHtaDYcwowm9V4ZOMXfDInAMtwKnpOxUGoT8/TgvaxH7DFtCTcie5YH8eMYr4mnbZnBB9B5vqJxx3ICLJGJQMeD9HDG6hUjjxKKUGYTJDCQIWs7WATVUH0f0pwtZmM/klnOonV8i+jc68fzuEuJTXp4bASziRktcKBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710835305; c=relaxed/simple;
	bh=IL4KbM42ErlIgq3SRmykFH6zwx3dWlPzQDbEY4UvSuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tfn+bLNzcOuwPaeJVW2on/wi1NoSAyhrhH37PLP53++4mEgvr87wixtFOO2Fg10boB9k0rbtThODJ0FbezMo3DiHMiIGVeBtTN2nnVliLY25muQ/LGfZHxIk5t8UQs3L5ZnsNmZvH0H9vm0l494eGpwoylyzyqW5WZszcxxpnqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PA5Xs2UQ; arc=none smtp.client-ip=209.85.161.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-5a4a2d99598so1147662eaf.2
        for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 01:01:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710835303; x=1711440103; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4V9DMm5uSUsFZwShNvLzFyDowiDRUN/JREmEJLYYvh4=;
        b=PA5Xs2UQlLyBuim16HxjuDEUiK5qVB46r/gNjtNUNdU0p7OJl9T/OBvGdc5kKdr8ov
         ULnBjmKnFaygHTZ8CedfLDUpuYr5bGL/l+70pArv+Ql7sm+JZC1Rapp0J7DLEkRxLzEp
         gCGIv2OiwixK3p0YQwZd9PnfFrvDR1rSQIdcxnzMO2qWcgeQAbl34wMpNIP0V9Rk8Zxt
         xYfznyNB2tRRqY50W47kwd9/Hmz29XeaY1IKqL+mYvDnHfHBRn7RFpcU0MelDV69vkte
         iW2nxcdmNAK6ekL27yR7lHvpGKULMlnZTv2qMK4dbBcPqLSSppILMJWbfLLcZtODEF/I
         FufA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710835303; x=1711440103;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4V9DMm5uSUsFZwShNvLzFyDowiDRUN/JREmEJLYYvh4=;
        b=TvT9Eb6V+xdpE4oGNP0Ogn5H4vZtEzOI5yhMvzq9LL3sW6ZRi/KpOIFG21BUGe54yl
         J35TOVsHAa2x0xcf1Ui/WrCQx9l2ljcS3N0vWGmThLN1c9v2XGtWfzBrj7lYi0QbK08b
         pa1C+2v2R7P86q/aFTxnQF7Vs3gvjKr1c0xn9X9If6P2+cesmTbjCq+k00vQKrEQ1t/s
         GRuI5NBzuWj9xuv3G4ZXym5imbcQXkL6i7ptHYQhVgf2FLULqjvK9WomsVJM3mIjBNEY
         4FeGTsoAPYFSycVtNC/FUAdx+Aq2aXqQ63sVqAZBMkAl9hj2QyXlowMdwulpRP7yfLyD
         X1Sw==
X-Forwarded-Encrypted: i=1; AJvYcCWoP/kbGC7nXNNufnYc6aSoL5XmzYHYlThPJKVuoujPMv4iDNXMdvkKOAdb6AABfbAXL6zpV1myzm6js63h1uZlc9Aa
X-Gm-Message-State: AOJu0YwZw83xj64X2k2G6o7qwvnqd9VWBatIZby1duBkES4rTEa9a0qc
	LmzSeCXMUIw1XvGeDYuvryse+HYNRFZJELkwuRfUcKEfZSh0/T9C
X-Google-Smtp-Source: AGHT+IEt+NscoRi6n00XI5VhxDOMyWtBlUHhlXL3LXHFPBG6XVtQ3ppVYZJ8b1XdLMEXBihI+PjOIQ==
X-Received: by 2002:a05:6358:64a0:b0:176:99f3:8d11 with SMTP id g32-20020a05635864a000b0017699f38d11mr8312869rwh.32.1710835302950;
        Tue, 19 Mar 2024 01:01:42 -0700 (PDT)
Received: from wheely.local0.net (193-116-208-39.tpgi.com.au. [193.116.208.39])
        by smtp.gmail.com with ESMTPSA id q23-20020a62ae17000000b006e5c464c0a9sm9121283pff.23.2024.03.19.01.01.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 01:01:42 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v7 31/35] powerpc: add usermode support
Date: Tue, 19 Mar 2024 17:59:22 +1000
Message-ID: <20240319075926.2422707-32-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240319075926.2422707-1-npiggin@gmail.com>
References: <20240319075926.2422707-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The biggest difficulty for user mode is MMU support. Otherwise it is
a simple matter of setting and clearing MSR[PR] with rfid and sc
respectively.

Some common harness operations will fail in usermode, so some workarounds
are reqiured (e.g., puts() can't be used directly).

A usermode privileged instruction interrupt test is added.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 lib/powerpc/asm/processor.h |  9 +++++++++
 lib/powerpc/asm/reg.h       |  1 +
 lib/powerpc/asm/smp.h       |  1 +
 lib/powerpc/io.c            |  7 +++++++
 lib/powerpc/processor.c     | 38 +++++++++++++++++++++++++++++++++++++
 lib/powerpc/rtas.c          |  3 +++
 lib/powerpc/setup.c         |  8 ++++++--
 lib/powerpc/spinlock.c      |  4 ++++
 lib/ppc64/mmu.c             |  2 ++
 powerpc/interrupts.c        | 28 +++++++++++++++++++++++++++
 10 files changed, 99 insertions(+), 2 deletions(-)

diff --git a/lib/powerpc/asm/processor.h b/lib/powerpc/asm/processor.h
index d348239c5..749155696 100644
--- a/lib/powerpc/asm/processor.h
+++ b/lib/powerpc/asm/processor.h
@@ -19,6 +19,8 @@ extern bool cpu_has_prefix;
 extern bool cpu_has_sc_lev;
 extern bool cpu_has_pause_short;
 
+bool in_usermode(void);
+
 static inline uint64_t mfspr(int nr)
 {
 	uint64_t ret;
@@ -51,6 +53,8 @@ static inline void local_irq_enable(void)
 {
 	unsigned long msr;
 
+	assert(!in_usermode());
+
 	asm volatile(
 "		mfmsr	%0		\n \
 		ori	%0,%0,%1	\n \
@@ -62,6 +66,8 @@ static inline void local_irq_disable(void)
 {
 	unsigned long msr;
 
+	assert(!in_usermode());
+
 	asm volatile(
 "		mfmsr	%0		\n \
 		andc	%0,%0,%1	\n \
@@ -90,4 +96,7 @@ static inline bool machine_is_pseries(void)
 void enable_mcheck(void);
 void disable_mcheck(void);
 
+void enter_usermode(void);
+void exit_usermode(void);
+
 #endif /* _ASMPOWERPC_PROCESSOR_H_ */
diff --git a/lib/powerpc/asm/reg.h b/lib/powerpc/asm/reg.h
index b2fab4313..69ef21adb 100644
--- a/lib/powerpc/asm/reg.h
+++ b/lib/powerpc/asm/reg.h
@@ -58,5 +58,6 @@
 #define MSR_SE		UL(0x0400)		/* Single Step Enable */
 #define MSR_EE		UL(0x8000)
 #define MSR_ME		UL(0x1000)
+#define MSR_PR		UL(0x4000)
 
 #endif
diff --git a/lib/powerpc/asm/smp.h b/lib/powerpc/asm/smp.h
index 820c05e9e..b96a55903 100644
--- a/lib/powerpc/asm/smp.h
+++ b/lib/powerpc/asm/smp.h
@@ -11,6 +11,7 @@ struct cpu {
 	unsigned long server_no;
 	unsigned long stack;
 	unsigned long exception_stack;
+	bool in_user;
 	secondary_entry_fn entry;
 	pgd_t *pgtable;
 } __attribute__((packed)); /* used by asm */
diff --git a/lib/powerpc/io.c b/lib/powerpc/io.c
index cb7f2f050..5c2810884 100644
--- a/lib/powerpc/io.c
+++ b/lib/powerpc/io.c
@@ -11,6 +11,7 @@
 #include <asm/setup.h>
 #include <asm/processor.h>
 #include <asm/atomic.h>
+#include <asm/smp.h>
 #include "io.h"
 
 static struct spinlock print_lock;
@@ -41,10 +42,16 @@ void io_init(void)
 
 void puts(const char *s)
 {
+	bool user = in_usermode();
+
+	if (user)
+		exit_usermode();
 	spin_lock(&print_lock);
 	while (*s)
 		putchar(*s++);
 	spin_unlock(&print_lock);
+	if (user)
+		enter_usermode();
 }
 
 /*
diff --git a/lib/powerpc/processor.c b/lib/powerpc/processor.c
index 09f6bb9d8..6c3000d5c 100644
--- a/lib/powerpc/processor.c
+++ b/lib/powerpc/processor.c
@@ -47,6 +47,8 @@ void do_handle_exception(struct pt_regs *regs)
 	unsigned char v;
 
 	__current_cpu = (struct cpu *)mfspr(SPR_SPRG0);
+	if (in_usermode())
+		current_cpu()->in_user = false;
 
 	/*
 	 * We run with AIL=0, so interrupts taken with MMU disabled.
@@ -60,6 +62,8 @@ void do_handle_exception(struct pt_regs *regs)
 
 	if (v < 128 && handlers[v].func) {
 		handlers[v].func(regs, handlers[v].data);
+		if (regs->msr & MSR_PR)
+			current_cpu()->in_user = true;
 		return;
 	}
 
@@ -169,3 +173,37 @@ void disable_mcheck(void)
 {
 	rfid_msr(mfmsr() & ~MSR_ME);
 }
+
+bool in_usermode(void)
+{
+	return current_cpu()->in_user;
+}
+
+static void usermode_sc_handler(struct pt_regs *regs, void *data)
+{
+	regs->msr &= ~(MSR_PR|MSR_EE);
+	/* Interrupt return handler will keep in_user clear */
+}
+
+void enter_usermode(void)
+{
+	assert_msg(!in_usermode(), "enter_usermode called with in_usermode");
+	/* mfmsr would fault in usermode anyway */
+	assert_msg(!(mfmsr() & MSR_PR), "enter_usermode called from user mode");
+	assert_msg(!(mfmsr() & MSR_EE), "enter_usermode called with interrupts enabled");
+	assert_msg((mfmsr() & (MSR_IR|MSR_DR)) == (MSR_IR|MSR_DR),
+		"enter_usermode called with virtual memory disabled");
+
+	handle_exception(0xc00, usermode_sc_handler, NULL);
+	rfid_msr(mfmsr() | (MSR_PR|MSR_IR|MSR_DR|MSR_EE));
+	current_cpu()->in_user = true;
+}
+
+void exit_usermode(void)
+{
+	assert_msg(in_usermode(), "enter_usermode called with !in_usermode");
+	asm volatile("sc 0" ::: "memory");
+	handle_exception(0xc00, NULL, NULL);
+	assert(!in_usermode());
+	assert(!(mfmsr() & MSR_PR));
+}
diff --git a/lib/powerpc/rtas.c b/lib/powerpc/rtas.c
index b477a38e0..9c1e0affc 100644
--- a/lib/powerpc/rtas.c
+++ b/lib/powerpc/rtas.c
@@ -9,6 +9,7 @@
 #include <libfdt/libfdt.h>
 #include <devicetree.h>
 #include <asm/spinlock.h>
+#include <asm/smp.h>
 #include <asm/hcall.h>
 #include <asm/io.h>
 #include <asm/rtas.h>
@@ -137,6 +138,8 @@ int rtas_call(int token, int nargs, int nret, int *outputs, ...)
 	va_list list;
 	int ret;
 
+	assert_msg(!in_usermode(), "May not make RTAS call from user mode\n");
+
 	spin_lock(&rtas_lock);
 
 	va_start(list, outputs);
diff --git a/lib/powerpc/setup.c b/lib/powerpc/setup.c
index ba659cc2b..30b988a5c 100644
--- a/lib/powerpc/setup.c
+++ b/lib/powerpc/setup.c
@@ -201,8 +201,11 @@ void cpu_init(struct cpu *cpu, int cpu_id)
 	cpu->exception_stack = (unsigned long)memalign(SZ_4K, SZ_64K);
 	cpu->exception_stack += SZ_64K - 64;
 	cpu->pgtable = NULL;
+	cpu->in_user = false;
 }
 
+bool is_hvmode;
+
 void setup(const void *fdt)
 {
 	void *freemem = &stacktop;
@@ -211,8 +214,6 @@ void setup(const void *fdt)
 	u32 fdt_size;
 	int ret;
 
-	cpu_has_hv = !!(mfmsr() & (1ULL << MSR_HV_BIT));
-
 	memset(cpus, 0xff, sizeof(cpus));
 
 	cpu = &cpus[0];
@@ -220,10 +221,13 @@ void setup(const void *fdt)
 	cpu->exception_stack = (unsigned long)boot_exception_stack;
 	cpu->exception_stack += SZ_64K - 64;
 	cpu->pgtable = NULL;
+	cpu->in_user = false;
 
 	mtspr(SPR_SPRG0, (unsigned long)cpu);
 	__current_cpu = cpu;
 
+	cpu_has_hv = !!(mfmsr() & (1ULL << MSR_HV_BIT));
+
 	enable_mcheck();
 
 	/*
diff --git a/lib/powerpc/spinlock.c b/lib/powerpc/spinlock.c
index 623a1f2c1..2c4904a33 100644
--- a/lib/powerpc/spinlock.c
+++ b/lib/powerpc/spinlock.c
@@ -9,6 +9,8 @@
  */
 void spin_lock(struct spinlock *lock)
 {
+	assert(!in_usermode());
+
 	if (!multithreaded) {
 		assert(lock->v == 0);
 		lock->v = 1;
@@ -20,7 +22,9 @@ void spin_lock(struct spinlock *lock)
 
 void spin_unlock(struct spinlock *lock)
 {
+	assert(!in_usermode());
 	assert(lock->v == 1);
+
 	if (!multithreaded) {
 		lock->v = 0;
 	} else {
diff --git a/lib/ppc64/mmu.c b/lib/ppc64/mmu.c
index ac9c0a285..4129f726c 100644
--- a/lib/ppc64/mmu.c
+++ b/lib/ppc64/mmu.c
@@ -42,6 +42,7 @@ void mmu_enable(pgd_t *pgtable)
 
 	cpu->pgtable = pgtable;
 
+	assert(!in_usermode());
 	mtmsr(mfmsr() | (MSR_IR|MSR_DR));
 }
 
@@ -51,6 +52,7 @@ void mmu_disable(void)
 
 	cpu->pgtable = NULL;
 
+	assert(!in_usermode());
 	mtmsr(mfmsr() & ~(MSR_IR|MSR_DR));
 }
 
diff --git a/powerpc/interrupts.c b/powerpc/interrupts.c
index 6bed26e41..ba965ff76 100644
--- a/powerpc/interrupts.c
+++ b/powerpc/interrupts.c
@@ -326,6 +326,33 @@ static void test_illegal(void)
 	report_prefix_pop();
 }
 
+static void dec_ignore_handler(struct pt_regs *regs, void *data)
+{
+	mtspr(SPR_DEC, 0x7fffffff);
+}
+
+static void test_privileged(void)
+{
+	unsigned long msr;
+
+	if (!mmu_enabled())
+		return;
+
+	report_prefix_push("privileged instruction");
+
+	handle_exception(0x700, &program_handler, NULL);
+	handle_exception(0x900, &dec_ignore_handler, NULL);
+	enter_usermode();
+	asm volatile("mfmsr %0" : "=r"(msr) :: "memory");
+	exit_usermode();
+	report(got_interrupt, "interrupt on privileged instruction");
+	got_interrupt = false;
+	handle_exception(0x900, NULL, NULL);
+	handle_exception(0x700, NULL, NULL);
+
+	report_prefix_pop();
+}
+
 static void sc_handler(struct pt_regs *regs, void *data)
 {
 	got_interrupt = true;
@@ -478,6 +505,7 @@ int main(int argc, char **argv)
 		test_mce();
 	test_mmu();
 	test_illegal();
+	test_privileged();
 	test_dec();
 	test_sc();
 	test_trace();
-- 
2.42.0


