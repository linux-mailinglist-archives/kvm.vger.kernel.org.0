Return-Path: <kvm+bounces-19401-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7909C904AD2
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 07:24:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7E4501C209F2
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 05:24:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 756ED3F9E8;
	Wed, 12 Jun 2024 05:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VUMSEovo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DA35381D9
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 05:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718169838; cv=none; b=q7n2041plVVfelZ5mdOtjZXUim8HMpR94z5Y60Ot6BPIYitXDO0QEDsAdeabhNy2bPNH8Ds3ff2wKJfQ0m5INWFqg59rUYNVkRkwmolYCyUJ8ncBcKLivD6W4mATtIOrXusCHo+eFZfVErCEVKl9RQ7ge/4hgQFq8LwNo8/fycU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718169838; c=relaxed/simple;
	bh=Vfe6PHX898mJxb7zxyeWS2hgnLlIZ9z1JeLepshuOWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TjqEwS7a06BXVUrAw5/corkeeWvHiJY7n8ziYVhBDYIIzLqC6BELmuDsmhl+KPU3GG6DS3PqAPQHEeD5AMkv2gX9kYedTLPffQMiUStU9VjC7bd1CgCxUcPepSFLkeYIZGV8NYvOIDr/VTi09KzD/abhCM3XAt2CLPqI/0Dj8/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VUMSEovo; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-6c4926bf9bbso1299537a12.2
        for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 22:23:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718169836; x=1718774636; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D8/CNw5jyd7VS+tHQzKTa3xNFmIwglcsZDjLDhI8+6I=;
        b=VUMSEovoM7lHyIyaGodGT+jfVG0FM88Di+VAfUtE/4w4nxhWP2Yxco0nuFeEuFp2Nv
         77Qt/LUKcRUT4G2TR02/9sLx+uHDesRPa3V2zCIAINghKwKviws4UEozkwjPapgUJ3S1
         DqflIqX9tUcnkcBACuaQ2PdleQY8Kbt2H+MbPG9crjzghH4MZaB3gMtilA3Fll9VJPyO
         tJy9rKF2RhtLCnG+oHACLCavZ3u01LY1ezdGvFlpIy7dByyUTvnOhXmAydZcB4G6hKpv
         IxQBjcc/YAHUI6gjXEFQSgaGiD9hHAp55jWD2Cc5+bZMJ1PHrjYOgoHT4XcF9pnNLp8r
         bMXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718169836; x=1718774636;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D8/CNw5jyd7VS+tHQzKTa3xNFmIwglcsZDjLDhI8+6I=;
        b=tFgti7i9Qor/KoM8t2K3D1vloGoawl7UzuSsd5PJ1yRdrfVbsZZ+IU0iP0wCA8IVIT
         ZuNono07VnJHeCrP2KzH23KXPNg1+RCUtcL1fkB/cgGL+AbKveQyZKAIpaVV8V9FtotF
         jQNgnMGjcimuwhRIqaZ9vBgV4BCxxNz+quKiNx02COOicuz3bBzgtUZnXfsSef9d94uU
         5dbC8MjfW5NXcXicA4tGzrye6ACGPiinoJTqjQDxFwyR6gHZyyW/cOyBtHSO1SA5Ipws
         BVmADDuNMGJbO0gOZTgED7xFBMv39TL3pY8bSMXdSpwhQUmYRE2avaF6RNin8fPyfL1q
         LbOw==
X-Forwarded-Encrypted: i=1; AJvYcCUfInazX+fy7DRUvOPFnFMUVdbLYkx3t06IxWhs8fS0HSGeYUE6uD8/TI+H/Hin5UBQeuHNimS8sOln7W3YLfcQMn0D
X-Gm-Message-State: AOJu0Ywa3z6tjyyjEhCqSlsTIHliazisHHNUmgJhDc4q4t8hWMNc4xD6
	B5BiXiUp0CsRjLUv2jk2wIC9boWf4oIYXIlWQk/mk/sf56M+ANrx
X-Google-Smtp-Source: AGHT+IFS9FRhv3/niWXE0r4xCxU4swY0zi2eP3yaAz4BQwq0k3AX4FFiyQYrEuZBRAMb3V4+32tdig==
X-Received: by 2002:a05:6a20:3d89:b0:1b6:7d90:1c96 with SMTP id adf61e73a8af0-1b8a9b589c6mr1095866637.22.1718169836301;
        Tue, 11 Jun 2024 22:23:56 -0700 (PDT)
Received: from wheely.local0.net (220-235-199-47.tpgi.com.au. [220.235.199.47])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f6bd75f711sm112170705ad.11.2024.06.11.22.23.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jun 2024 22:23:56 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v10 07/15] powerpc: add usermode support
Date: Wed, 12 Jun 2024 15:23:12 +1000
Message-ID: <20240612052322.218726-8-npiggin@gmail.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240612052322.218726-1-npiggin@gmail.com>
References: <20240612052322.218726-1-npiggin@gmail.com>
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

Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 lib/powerpc/asm/processor.h |  9 +++++++++
 lib/powerpc/asm/reg.h       |  1 +
 lib/powerpc/asm/smp.h       |  1 +
 lib/powerpc/io.c            |  7 +++++++
 lib/powerpc/processor.c     | 38 +++++++++++++++++++++++++++++++++++++
 lib/powerpc/rtas.c          |  3 +++
 lib/powerpc/setup.c         |  7 +++++--
 lib/ppc64/mmu.c             |  2 ++
 powerpc/interrupts.c        | 28 +++++++++++++++++++++++++++
 9 files changed, 94 insertions(+), 2 deletions(-)

diff --git a/lib/powerpc/asm/processor.h b/lib/powerpc/asm/processor.h
index b4f195856..9609c9c67 100644
--- a/lib/powerpc/asm/processor.h
+++ b/lib/powerpc/asm/processor.h
@@ -22,6 +22,8 @@ extern bool cpu_has_prefix;
 extern bool cpu_has_sc_lev;
 extern bool cpu_has_pause_short;
 
+bool in_usermode(void);
+
 static inline uint64_t mfspr(int nr)
 {
 	uint64_t ret;
@@ -54,6 +56,8 @@ static inline void local_irq_enable(void)
 {
 	unsigned long msr;
 
+	assert(!in_usermode());
+
 	asm volatile(
 "		mfmsr	%0		\n \
 		ori	%0,%0,%1	\n \
@@ -65,6 +69,8 @@ static inline void local_irq_disable(void)
 {
 	unsigned long msr;
 
+	assert(!in_usermode());
+
 	asm volatile(
 "		mfmsr	%0		\n \
 		andc	%0,%0,%1	\n \
@@ -93,4 +99,7 @@ static inline bool machine_is_pseries(void)
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
index bc2a68935..9ec416e25 100644
--- a/lib/powerpc/asm/smp.h
+++ b/lib/powerpc/asm/smp.h
@@ -11,6 +11,7 @@ struct cpu {
 	unsigned long server_no;
 	unsigned long stack;
 	unsigned long exception_stack;
+	bool in_user;
 	secondary_entry_fn entry;
 	pgd_t *pgtable;
 };
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
index b7450e5e5..c1f0f9adf 100644
--- a/lib/powerpc/setup.c
+++ b/lib/powerpc/setup.c
@@ -209,10 +209,12 @@ void cpu_init(struct cpu *cpu, int cpu_id)
 	cpu->exception_stack = (unsigned long)memalign_pages(SZ_4K, SZ_64K);
 	cpu->exception_stack += SZ_64K - 64;
 	cpu->pgtable = NULL;
+	cpu->in_user = false;
 }
 
 bool host_is_tcg;
 bool host_is_kvm;
+bool is_hvmode;
 
 void setup(const void *fdt)
 {
@@ -222,8 +224,6 @@ void setup(const void *fdt)
 	u32 fdt_size;
 	int ret;
 
-	cpu_has_hv = !!(mfmsr() & (1ULL << MSR_HV_BIT));
-
 	memset(cpus, 0xff, sizeof(cpus));
 
 	cpu = &cpus[0];
@@ -231,10 +231,13 @@ void setup(const void *fdt)
 	cpu->exception_stack = (unsigned long)boot_exception_stack;
 	cpu->exception_stack += EXCEPTION_STACK_SIZE - 64;
 	cpu->pgtable = NULL;
+	cpu->in_user = false;
 
 	mtspr(SPR_SPRG0, (unsigned long)cpu);
 	__current_cpu = cpu;
 
+	cpu_has_hv = !!(mfmsr() & (1ULL << MSR_HV_BIT));
+
 	enable_mcheck();
 
 	/*
diff --git a/lib/ppc64/mmu.c b/lib/ppc64/mmu.c
index 6f9f4130f..f2aebf584 100644
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
index 66b4cd626..4c136a842 100644
--- a/powerpc/interrupts.c
+++ b/powerpc/interrupts.c
@@ -329,6 +329,33 @@ static void test_illegal(void)
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
@@ -481,6 +508,7 @@ int main(int argc, char **argv)
 		test_mce();
 	test_mmu();
 	test_illegal();
+	test_privileged();
 	test_dec();
 	test_sc();
 	test_trace();
-- 
2.45.1


