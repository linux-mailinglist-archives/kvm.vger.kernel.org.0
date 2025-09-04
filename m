Return-Path: <kvm+bounces-56786-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 00DF2B43535
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 10:14:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 199E31C264C0
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 08:14:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77FAC2D2482;
	Thu,  4 Sep 2025 08:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kKqDAMEk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71DC72D1F68
	for <kvm@vger.kernel.org>; Thu,  4 Sep 2025 08:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756973521; cv=none; b=qtYZbi1InRQW5RrzTuBx6dAJwhQU12LVanVF34Lg2QPxjqepWPPaUeiDlIWg7Bq3eAms1q52sb3DLGLAUdjz69Pc5wAwrgfyuGqQQhTGkWdz7XJbQQa9PUF6yqg4uzbq/tgBNhnqrkbQYwT4xPTd2nm3KFL3YI2XNijsA4wpLV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756973521; c=relaxed/simple;
	bh=ymCWKRCoXSqz0MnE3RhkeGxhBI5pbpduq+psGAU4ZXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jWS5gKsvR9v1b1/5KU0csA2FL7Fqx16QMlHbRuRbmRvKz1pWBSwM5KAXJj+PBWDOkAJKTckcPAcV9M5oo14jLsQMsIsosrO7LW6aZoyHePXp1z9bLzqhFX0w+p4vJxo3IukDwcXI6O7r52CfmxNpndliO0Lt8obAthOg9+GChnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=kKqDAMEk; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b043da5a55fso107838466b.0
        for <kvm@vger.kernel.org>; Thu, 04 Sep 2025 01:11:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756973518; x=1757578318; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KM2ZDhNYkLW1KWUOdLmFVe8gLAQ7wgd1StjOThDS9B0=;
        b=kKqDAMEk1hyPIGUJUybOF1cDAAsWITnLXv+ZX19l8cMbfGHh7w+QKe8EigCDGPHhVu
         cXWqzYpft2Zl6SLKHlU8cn9p+QcfLkONvo9z6hKcy2AHk+JIN2TThx4KB5k6NbTGu2Dv
         NCidrc9GcqLnsP3Du+bVsLXpUPHHiIQz3uZBKNYDnen3oZvuNY7nnFnB1z6poSxGy76r
         QF3fauC6mkoatNqcIKUUxj7pkmG1U9WOhQZUVQSdH4yTlpba/tzSZu2yPaQJmOk1SGik
         Mxin3+4ifcU+umUrXbICRV6Wb7UNZr/+jWACQG6hgnOhcR6l8bZbYyifkcGDFCYG79Fy
         oIrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756973518; x=1757578318;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KM2ZDhNYkLW1KWUOdLmFVe8gLAQ7wgd1StjOThDS9B0=;
        b=tCUAMUtJnQM0UVrLVe+CyePQzWwZAIWvTvJXDdCp8nWDb4Lt/zb6/eygK5YrRuExTR
         C3gZmcVapWdp0y2PDhfRJqbaqMo336lLQt/QpG1BSy3DGT9QiCt2MI6HMZ0b05UDRoD1
         khP0ISqpOVmcHgdvXfljPdyvohNzwqaBvqWwUa0kXu86CDXOYC2kPOsdOJyAB5ToY0iG
         o/o7U/bcO5CD4mBCuItQKyv4Dk0suKRGxlRvBcAOCDhqvA1Tg+yyg5Nyal6OXVbYa9Id
         Krb4ruSzYPs2wIt6aJJuh05Z/LPRzQenSBVVVj3i8MpRX6FEEtmMfHvt9G3ZmKTSrtti
         yvdQ==
X-Forwarded-Encrypted: i=1; AJvYcCV4Mb/tYxI1F35ws0DozmJ5zOY4K0FMEqtC/q+frsE5Ob9kzuKEsyC8mhaX8uT/bk26p9I=@vger.kernel.org
X-Gm-Message-State: AOJu0YyemhX2Ka/k9cVtIrVCgCJZWtkKV6X5a0HeAXyJw48yhNU4YTck
	5GNTdlQwg1IapQJMoxnLO/yrjWOH+XXyulfD9yEef1ftoPIfBWIOCMFD+lX2rfdjnnM=
X-Gm-Gg: ASbGncsG5rQ6v6Yw8h/Cv23U71a6EYYnOZ+uwaMLxhEuFWoJ9DEyiQnYkDWTWHP45G/
	UI6qokvxTA9WuKXqPQfF+ZdRpIrgPkPGYRldi0coKkCn56Ve4P6j1Wc7sMp6I3A1lxBrT/t/6LI
	blLmhYAy2qmylE6QRGzZ5H73xpV3rC4KT7Dgw5alQYm8ZvjG6dlc1FeOnceFVTPZCRzuHxwqjc+
	AjvPAsFRWpVMJgkC5862i9YnLsL/1SH7s/+dXPnIa+6TAJVT11wkQYR5PUFOyyvGAdlDroY+adn
	SJlP05WL2+my3JcNjCYlgim/Hc80dcCC1SY0PPZebC7WR9VTNM+ZOyJeWarcHp7ZuVel6nQzCZ+
	BX7lLazxsIgJ2htQRzOGYpkH+6f5PNJwzVA==
X-Google-Smtp-Source: AGHT+IE6k0GqNytWpGYUw8aMikHxjbuztoWFqvzmVO/on4V3dK6nYD0ba2/sDJcNk3Tb6kLpXPbyDw==
X-Received: by 2002:a17:907:961a:b0:b04:2edd:280b with SMTP id a640c23a62f3a-b042edd2a50mr1478196866b.39.1756973517480;
        Thu, 04 Sep 2025 01:11:57 -0700 (PDT)
Received: from draig.lan ([185.126.160.19])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b041f6fb232sm1080452766b.87.2025.09.04.01.11.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Sep 2025 01:11:55 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 30E81601A8;
	Thu, 04 Sep 2025 09:11:34 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: Reinoud Zandijk <reinoud@netbsd.org>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	qemu-arm@nongnu.org,
	Fam Zheng <fam@euphon.net>,
	Helge Deller <deller@gmx.de>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Fabiano Rosas <farosas@suse.de>,
	qemu-rust@nongnu.org,
	Bibo Mao <maobibo@loongson.cn>,
	qemu-riscv@nongnu.org,
	Thanos Makatos <thanos.makatos@nutanix.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Riku Voipio <riku.voipio@iki.fi>,
	Cameron Esfahani <dirty@apple.com>,
	Alexander Graf <agraf@csgraf.de>,
	Laurent Vivier <lvivier@redhat.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	qemu-ppc@nongnu.org,
	Stafford Horne <shorne@gmail.com>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	Jagannathan Raman <jag.raman@oracle.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Brian Cain <brian.cain@oss.qualcomm.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	devel@lists.libvirt.org,
	Mads Ynddal <mads@ynddal.dk>,
	Elena Ufimtseva <elena.ufimtseva@oracle.com>,
	Peter Xu <peterx@redhat.com>,
	Jason Herne <jjherne@linux.ibm.com>,
	Michael Rolnik <mrolnik@gmail.com>,
	Weiwei Li <liwei1518@gmail.com>,
	Laurent Vivier <laurent@vivier.eu>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	qemu-block@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Kostiantyn Kostiuk <kkostiuk@redhat.com>,
	Kyle Evans <kevans@freebsd.org>,
	David Hildenbrand <david@redhat.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Warner Losh <imp@bsdimp.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	John Snow <jsnow@redhat.com>,
	Yoshinori Sato <yoshinori.sato@nifty.com>,
	Aleksandar Rikalo <arikalo@gmail.com>,
	Alistair Francis <alistair@alistair23.me>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Yonggang Luo <luoyonggang@gmail.com>,
	Radoslaw Biernacki <rad@semihalf.com>,
	Artyom Tarasenko <atar4qemu@gmail.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Richard Henderson <richard.henderson@linaro.org>,
	qemu-s390x@nongnu.org,
	Alex Williamson <alex.williamson@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Ani Sinha <anisinha@redhat.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Manos Pitsidianakis <manos.pitsidianakis@linaro.org>,
	Chinmay Rath <rathc@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	Cleber Rosa <crosa@redhat.com>,
	kvm@vger.kernel.org,
	Song Gao <gaosong@loongson.cn>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Halil Pasic <pasic@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Leif Lindholm <leif.lindholm@oss.qualcomm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Michael Roth <michael.roth@amd.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	John Levon <john.levon@nutanix.com>
Subject: [PATCH v2 049/281] semihosting: Initialize heap once per process
Date: Thu,  4 Sep 2025 09:07:23 +0100
Message-ID: <20250904081128.1942269-50-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250904081128.1942269-1-alex.bennee@linaro.org>
References: <20250904081128.1942269-1-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Richard Henderson <richard.henderson@linaro.org>

While semihosting isn't really thread aware, the current
implementation allocates space for the heap per-thread.

Remove the heap_base and heap_limit fields from TaskState.
Replace with static variables within do_common_semihosting.

Reviewed-by: Peter Maydell <peter.maydell@linaro.org>
Signed-off-by: Richard Henderson <richard.henderson@linaro.org>
---
 linux-user/qemu.h             |  5 -----
 linux-user/aarch64/cpu_loop.c |  7 -------
 linux-user/arm/cpu_loop.c     | 25 +++++++++++--------------
 linux-user/m68k/cpu_loop.c    |  8 --------
 linux-user/riscv/cpu_loop.c   |  4 ----
 semihosting/arm-compat-semi.c | 22 +++++++++-------------
 6 files changed, 20 insertions(+), 51 deletions(-)

diff --git a/linux-user/qemu.h b/linux-user/qemu.h
index b6621536b36..4d6fad28c63 100644
--- a/linux-user/qemu.h
+++ b/linux-user/qemu.h
@@ -121,11 +121,6 @@ struct TaskState {
     abi_ulong child_tidptr;
 #ifdef TARGET_M68K
     abi_ulong tp_value;
-#endif
-#if defined(TARGET_ARM) || defined(TARGET_M68K) || defined(TARGET_RISCV)
-    /* Extra fields for semihosted binaries.  */
-    abi_ulong heap_base;
-    abi_ulong heap_limit;
 #endif
     int used; /* non zero if used */
     struct image_info *info;
diff --git a/linux-user/aarch64/cpu_loop.c b/linux-user/aarch64/cpu_loop.c
index b65999a75bf..030a630c936 100644
--- a/linux-user/aarch64/cpu_loop.c
+++ b/linux-user/aarch64/cpu_loop.c
@@ -140,9 +140,6 @@ void cpu_loop(CPUARMState *env)
 void target_cpu_copy_regs(CPUArchState *env, target_pt_regs *regs)
 {
     ARMCPU *cpu = env_archcpu(env);
-    CPUState *cs = env_cpu(env);
-    TaskState *ts = get_task_state(cs);
-    struct image_info *info = ts->info;
     int i;
 
     if (!(arm_feature(env, ARM_FEATURE_AARCH64))) {
@@ -167,8 +164,4 @@ void target_cpu_copy_regs(CPUArchState *env, target_pt_regs *regs)
     if (cpu_isar_feature(aa64_pauth, cpu)) {
         qemu_guest_getrandom_nofail(&env->keys, sizeof(env->keys));
     }
-
-    ts->heap_base = info->brk;
-    /* This will be filled in on the first SYS_HEAPINFO call.  */
-    ts->heap_limit = 0;
 }
diff --git a/linux-user/arm/cpu_loop.c b/linux-user/arm/cpu_loop.c
index e40d6beafa2..9d54422736c 100644
--- a/linux-user/arm/cpu_loop.c
+++ b/linux-user/arm/cpu_loop.c
@@ -492,19 +492,16 @@ void target_cpu_copy_regs(CPUArchState *env, target_pt_regs *regs)
     for(i = 0; i < 16; i++) {
         env->regs[i] = regs->uregs[i];
     }
-#if TARGET_BIG_ENDIAN
-    /* Enable BE8.  */
-    if (EF_ARM_EABI_VERSION(info->elf_flags) >= EF_ARM_EABI_VER4
-        && (info->elf_flags & EF_ARM_BE8)) {
-        env->uncached_cpsr |= CPSR_E;
-        env->cp15.sctlr_el[1] |= SCTLR_E0E;
-    } else {
-        env->cp15.sctlr_el[1] |= SCTLR_B;
-    }
-    arm_rebuild_hflags(env);
-#endif
 
-    ts->heap_base = info->brk;
-    /* This will be filled in on the first SYS_HEAPINFO call.  */
-    ts->heap_limit = 0;
+    if (TARGET_BIG_ENDIAN) {
+        /* Enable BE8.  */
+        if (EF_ARM_EABI_VERSION(info->elf_flags) >= EF_ARM_EABI_VER4
+            && (info->elf_flags & EF_ARM_BE8)) {
+            env->uncached_cpsr |= CPSR_E;
+            env->cp15.sctlr_el[1] |= SCTLR_E0E;
+        } else {
+            env->cp15.sctlr_el[1] |= SCTLR_B;
+        }
+        arm_rebuild_hflags(env);
+    }
 }
diff --git a/linux-user/m68k/cpu_loop.c b/linux-user/m68k/cpu_loop.c
index 3aaaf02ca4e..23693f33582 100644
--- a/linux-user/m68k/cpu_loop.c
+++ b/linux-user/m68k/cpu_loop.c
@@ -94,10 +94,6 @@ void cpu_loop(CPUM68KState *env)
 
 void target_cpu_copy_regs(CPUArchState *env, target_pt_regs *regs)
 {
-    CPUState *cpu = env_cpu(env);
-    TaskState *ts = get_task_state(cpu);
-    struct image_info *info = ts->info;
-
     env->pc = regs->pc;
     env->dregs[0] = regs->d0;
     env->dregs[1] = regs->d1;
@@ -116,8 +112,4 @@ void target_cpu_copy_regs(CPUArchState *env, target_pt_regs *regs)
     env->aregs[6] = regs->a6;
     env->aregs[7] = regs->usp;
     env->sr = regs->sr;
-
-    ts->heap_base = info->brk;
-    /* This will be filled in on the first SYS_HEAPINFO call.  */
-    ts->heap_limit = 0;
 }
diff --git a/linux-user/riscv/cpu_loop.c b/linux-user/riscv/cpu_loop.c
index 541de765ffa..2dd30c7b288 100644
--- a/linux-user/riscv/cpu_loop.c
+++ b/linux-user/riscv/cpu_loop.c
@@ -108,8 +108,4 @@ void target_cpu_copy_regs(CPUArchState *env, target_pt_regs *regs)
         error_report("Incompatible ELF: RVE cpu requires RVE ABI binary");
         exit(EXIT_FAILURE);
     }
-
-    ts->heap_base = info->brk;
-    /* This will be filled in on the first SYS_HEAPINFO call.  */
-    ts->heap_limit = 0;
 }
diff --git a/semihosting/arm-compat-semi.c b/semihosting/arm-compat-semi.c
index bc04b02eba8..bcd13cd6dfd 100644
--- a/semihosting/arm-compat-semi.c
+++ b/semihosting/arm-compat-semi.c
@@ -666,7 +666,7 @@ void do_common_semihosting(CPUState *cs)
             int i;
 #ifdef CONFIG_USER_ONLY
             TaskState *ts = get_task_state(cs);
-            target_ulong limit;
+            static abi_ulong heapbase, heaplimit;
 #else
             LayoutInfo info = common_semi_find_bases(cs);
 #endif
@@ -678,24 +678,20 @@ void do_common_semihosting(CPUState *cs)
              * Some C libraries assume the heap immediately follows .bss, so
              * allocate it using sbrk.
              */
-            if (!ts->heap_limit) {
-                abi_ulong ret;
-
-                ts->heap_base = do_brk(0);
-                limit = ts->heap_base + COMMON_SEMI_HEAP_SIZE;
+            if (!heaplimit) {
+                heapbase = do_brk(0);
                 /* Try a big heap, and reduce the size if that fails.  */
-                for (;;) {
-                    ret = do_brk(limit);
+                for (abi_ulong size = COMMON_SEMI_HEAP_SIZE; ; size >>= 1) {
+                    abi_ulong limit = heapbase + size;
+                    abi_ulong ret = do_brk(limit);
                     if (ret >= limit) {
+                        heaplimit = limit;
                         break;
                     }
-                    limit = (ts->heap_base >> 1) + (limit >> 1);
                 }
-                ts->heap_limit = limit;
             }
-
-            retvals[0] = ts->heap_base;
-            retvals[1] = ts->heap_limit;
+            retvals[0] = heapbase;
+            retvals[1] = heaplimit;
             /*
              * Note that semihosting is *not* thread aware.
              * Always return the stack base of the main thread.
-- 
2.47.2


