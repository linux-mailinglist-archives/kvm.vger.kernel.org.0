Return-Path: <kvm+bounces-9831-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A6E9867198
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 11:42:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4543EB2275C
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:30:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D0A85F845;
	Mon, 26 Feb 2024 10:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ViYtHbeA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D76365F546
	for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 10:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708942469; cv=none; b=SNnICp5bm4IwI12zCHKFvVyy1nSPqC7ssoOwpiguQ2MIO7jIX43h7IDEEIK+o4vS8MAARMMiFr8RLhpuzEjv7T4V6gx4GNW04DTUa6efq+TbJ7BRFKQ8E0bAHxv2iH3lErzYJUwWWICaC0fAHb0NxHeIu96eE2fb8tcN2cGWjhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708942469; c=relaxed/simple;
	bh=g6oTGk1XOtGxj3W9q30PPZ3yPL/yAU9Sd4csEuNKGSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aOUGcPPC+AVdUlW6t0XdYhSg4T1CsMFDfrFRK3/tcLlJkup+8PMFiADabDAU+HWfGcwKuN5RcVita1wHMhDFVwAMV9mZgqZU80bEoWexvWwc4LEDejxJ3JvFN24xj8SRaAeMaBnME2BF0vhIr3e1s/zkx87pEZijrdoJ/vOeXTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ViYtHbeA; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-6e435542d41so1651432b3a.1
        for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 02:14:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708942467; x=1709547267; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x9fqZM1HjgMhnvdX9i/83KImMUDpC7gY5LwA4oHSYi8=;
        b=ViYtHbeAlQj+PjbwBj8Vcw/DCmi5effjxgLp6y/GKzasTuZ3p8dtIrdpOLqvzBYSSz
         wYLB5PAmL1BUSb1xC+Thh6+umU+YsL36lvszgSddd1whcwoalR4zn7Hjk973t1EeVLeP
         NZqJ4F+jlSpLmzJaSi3vWYDk768ONxAgvhM4FcBHJaAcdNzV2wSR2Ef5zJNewPDeQymU
         cWlEnwIFwj7I6ckVf1rZ50KCWg/f05lKepnH/rR/EoLzbf49IZ4XG11FgACp9+GRY6P7
         qGQGZQtEYYPhen00AlklRPmK5PgdgnK2S4e6vh6SMwoqi96EBwxIRGXo0G9aEfiy8U49
         DWvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708942467; x=1709547267;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x9fqZM1HjgMhnvdX9i/83KImMUDpC7gY5LwA4oHSYi8=;
        b=deRfhmv1/9n4WjFIgoXZykHGxnoCQRWDwo559rW8cWly3CiK6RFCxNJgG8tyVK149t
         jktD89m8nebfxyzKF/pB+dMYWzDb0tQ5BQk5gRIprpxv3B4fLdI5Adh//DaKodf4Wb38
         9uIyM6jx9nhoPUMlm/t90HzUQnSwPGPmKjFDcqv3ALFrx70CK/JT4wEPH9fZ4ds335LS
         53IrCgBjHf44Avp34pivNJxYMMICzOutBm819SQdsiMMuK/+FINhaAUA4uGVeFdwFwGW
         29Z8kk7A0AVlZWyCDXecPYiAf/reGoULqtyp33fy5AARD3grn8K1rYqK92Ih4zVDB+my
         X1MA==
X-Forwarded-Encrypted: i=1; AJvYcCXWNoYvyfndBH+gnJwjMp0b1jJhqfEfoG6iFgWtlfXlRzXhFx9QH9L6ICALiajml1EMk+zCTVUUzWZNVJdeM1lGe9F/
X-Gm-Message-State: AOJu0YxR31sxW93OLjsJFHrCAtVuApD1k0kkQBvZ6pINqnBreYBElGog
	UN6yOqE0gGygkNNpS0ICLdcV12bEDN60+mq+cfhTjd8aJXlP+epO
X-Google-Smtp-Source: AGHT+IE5TwZZ/SvnCc5VuH70NTT9y/dfzmTVfHBIKIkrrWmivfBVpHAxivyOg8Fq47nc4bd9XU1rHQ==
X-Received: by 2002:aa7:8a54:0:b0:6e3:d201:3f87 with SMTP id n20-20020aa78a54000000b006e3d2013f87mr5294276pfa.28.1708942467166;
        Mon, 26 Feb 2024 02:14:27 -0800 (PST)
Received: from wheely.local0.net (220-235-194-103.tpgi.com.au. [220.235.194.103])
        by smtp.gmail.com with ESMTPSA id x24-20020aa784d8000000b006e463414493sm3626693pfn.105.2024.02.26.02.14.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 02:14:26 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Joel Stanley <joel@jms.id.au>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH 27/32] powerpc: add usermode support
Date: Mon, 26 Feb 2024 20:12:13 +1000
Message-ID: <20240226101218.1472843-28-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240226101218.1472843-1-npiggin@gmail.com>
References: <20240226101218.1472843-1-npiggin@gmail.com>
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
index 238549f12..59dc4fbb5 100644
--- a/lib/powerpc/spinlock.c
+++ b/lib/powerpc/spinlock.c
@@ -8,6 +8,8 @@
  */
 void spin_lock(struct spinlock *lock)
 {
+	assert(!in_usermode());
+
 	if (!multithreaded) {
 		assert(lock->v == 0);
 		lock->v = 1;
@@ -19,7 +21,9 @@ void spin_lock(struct spinlock *lock)
 
 void spin_unlock(struct spinlock *lock)
 {
+	assert(!in_usermode());
 	assert(lock->v == 1);
+
 	if (!multithreaded) {
 		lock->v = 0;
 	} else {
diff --git a/lib/ppc64/mmu.c b/lib/ppc64/mmu.c
index f1219033a..313da6e78 100644
--- a/lib/ppc64/mmu.c
+++ b/lib/ppc64/mmu.c
@@ -43,6 +43,7 @@ void mmu_enable(pgd_t *pgtable)
 
 	cpu->pgtable = pgtable;
 
+	assert(!in_usermode());
 	mtmsr(mfmsr() | (MSR_IR|MSR_DR));
 }
 
@@ -52,6 +53,7 @@ void mmu_disable(void)
 
 	cpu->pgtable = NULL;
 
+	assert(!in_usermode());
 	mtmsr(mfmsr() & ~(MSR_IR|MSR_DR));
 }
 
diff --git a/powerpc/interrupts.c b/powerpc/interrupts.c
index 35a47581c..1f5f7cfcd 100644
--- a/powerpc/interrupts.c
+++ b/powerpc/interrupts.c
@@ -327,6 +327,33 @@ static void test_illegal(void)
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
@@ -479,6 +506,7 @@ int main(int argc, char **argv)
 		test_mce();
 	test_mmu();
 	test_illegal();
+	test_privileged();
 	test_dec();
 	test_sc();
 	test_trace();
-- 
2.42.0


