Return-Path: <kvm+bounces-7225-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E99C683E48B
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 23:06:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1AD291C20CCD
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 22:06:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D426A50A9F;
	Fri, 26 Jan 2024 22:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="c3jLHtwy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2199933CC5
	for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 22:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706306721; cv=none; b=ZhSb5n91ELlAqQZV3krc/21Ds+9w1fomi3XgfVAQYM0e9kCVi7RXvnHTYOhzeV5OrKIWiv31J9Mt67xisN66Wfp3DSidjTfqB7bSB+snGhzlaU57iUDTKDxKn00h9Q6yuyBvh4D+AOjxuxct3oWSU3UIHEo/A7/oEWzovXlKTtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706306721; c=relaxed/simple;
	bh=VtydEN97YkFxWF6L0PE70BVMYQAyfIYSjh7UEB393u8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VJ2vNRZP21VpXJbU/wahqTWg7rcExAi6xGmozUYu3hAHxs7dH3z7c7gtMZ0qLnsNIxF2QiTAmgJ65yMtFiLhAist5IfOaHk1G6GJJ9EkzGvZjn42HJxsShZ4A3E3yHAH+Ll3y9dDjXnLciOY74eXtMKKwsWJGaRIGHeLTjtsidQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=c3jLHtwy; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5100cb64e7dso1320416e87.0
        for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 14:05:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1706306717; x=1706911517; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=woNcbihCgyljuhpYMr+Cr15jve2C8HR8mCIZjTtoatM=;
        b=c3jLHtwyOgozPLG/iw9Uoou7AO0S6IqrB3f1K7++QYj9NhtsTJfdDDLZap3LfVysfi
         XC6GtpLoPG49B9VRDE3rnGakcGvvQEK97eD6fmf1ZKmkNqvQ5ehCJW99prTPbiSJUMA4
         UT9ek5hvqfn2B5ftMyGmauU1Ee47g92zFlNQhUY51/LA1p6UI9QZgxHuE9yUarbuROb3
         NbjcZu01vSvUuPkAHiCyse3JnzVqJSl+cfMMdNL5w5h6X4evIdVm/nd6P9imNKdesm9b
         RSqyJGXq/ZFsHQnn/5DbnXPmQ1VTI6djtDmk3RmaK/d460EqYKSbPqxq5KT55OxULvEw
         XRew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706306717; x=1706911517;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=woNcbihCgyljuhpYMr+Cr15jve2C8HR8mCIZjTtoatM=;
        b=XRdR7AsfBKIkdYTj52LK7fYKb+r47c93GG1ENXtAZ70GAfhKj/DHDw0ba1IyXL7ev8
         guqTCFak/FBudmMktxqDCISZSQml39zjxn9hJNjmy+XrXVTrmCEJTZLuy6ndLhkvD92k
         nOl8vbJi/4jFz2XvFJliVLUQ3XaO26RxnO7Rd4UI/pR2dw4S5fYzRiHvhWBfyVapeyx/
         xisx8EOs6s2ON1TaGGCEpH+Jh/FpCLP51ukE1LrIZmbQToPIZ7dQuSPb+9IZibzofOpS
         N+B8l+E+/kAqyZTCqqlG7Nr1DgYTfVxX6xnAhG8Ht6E86m55KIXM83N51sSPNUIq9i+p
         9S0g==
X-Gm-Message-State: AOJu0Yx9zXeaBgf/Fr84VLnExGWKWg+I6g4crFhtVHNDyTZiuhKzeGjP
	AWACXvItKOKoOI+Im0ufeaN7dRErVvN2LVjC/IOMoh9ILZiFyY1a+98gIAO75hvianCTmBflrw8
	v
X-Google-Smtp-Source: AGHT+IGEfUSbbgqMLQdvSJbtXPFqUYX6PGTjtPfy/2qbsLf9jCgJGYcSa5vmpQHmXErBdW8QamwwYA==
X-Received: by 2002:a2e:8ed5:0:b0:2cc:e9e6:e451 with SMTP id e21-20020a2e8ed5000000b002cce9e6e451mr172509ljl.86.1706306717285;
        Fri, 26 Jan 2024 14:05:17 -0800 (PST)
Received: from m1x-phil.lan ([176.176.142.39])
        by smtp.gmail.com with ESMTPSA id n1-20020a056402434100b0055d1d0b4a4asm1002967edc.18.2024.01.26.14.05.15
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 26 Jan 2024 14:05:16 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-arm@nongnu.org,
	Thomas Huth <thuth@redhat.com>,
	qemu-s390x@nongnu.org,
	qemu-riscv@nongnu.org,
	Eduardo Habkost <eduardo@habkost.net>,
	kvm@vger.kernel.org,
	qemu-ppc@nongnu.org,
	Richard Henderson <richard.henderson@linaro.org>,
	Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Laurent Vivier <laurent@vivier.eu>
Subject: [PATCH v2 11/23] target/m68k: Prefer fast cpu_env() over slower CPU QOM cast macro
Date: Fri, 26 Jan 2024 23:03:53 +0100
Message-ID: <20240126220407.95022-12-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20240126220407.95022-1-philmd@linaro.org>
References: <20240126220407.95022-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Mechanical patch produced running the command documented
in scripts/coccinelle/cpu_env.cocci_template header.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/m68k/cpu.c       | 30 ++++++++++--------------------
 target/m68k/gdbstub.c   |  6 ++----
 target/m68k/helper.c    |  3 +--
 target/m68k/m68k-semi.c |  6 ++----
 target/m68k/op_helper.c | 11 +++--------
 target/m68k/translate.c |  3 +--
 6 files changed, 19 insertions(+), 40 deletions(-)

diff --git a/target/m68k/cpu.c b/target/m68k/cpu.c
index 1421e77c2c..c122fd96fb 100644
--- a/target/m68k/cpu.c
+++ b/target/m68k/cpu.c
@@ -117,8 +117,7 @@ static ObjectClass *m68k_cpu_class_by_name(const char *cpu_model)
 
 static void m5206_cpu_initfn(Object *obj)
 {
-    M68kCPU *cpu = M68K_CPU(obj);
-    CPUM68KState *env = &cpu->env;
+    CPUM68KState *env = cpu_env(CPU(obj));
 
     m68k_set_feature(env, M68K_FEATURE_CF_ISA_A);
     m68k_set_feature(env, M68K_FEATURE_MOVEFROMSR_PRIV);
@@ -127,8 +126,7 @@ static void m5206_cpu_initfn(Object *obj)
 /* Base feature set, including isns. for m68k family */
 static void m68000_cpu_initfn(Object *obj)
 {
-    M68kCPU *cpu = M68K_CPU(obj);
-    CPUM68KState *env = &cpu->env;
+    CPUM68KState *env = cpu_env(CPU(obj));
 
     m68k_set_feature(env, M68K_FEATURE_M68K);
     m68k_set_feature(env, M68K_FEATURE_USP);
@@ -141,8 +139,7 @@ static void m68000_cpu_initfn(Object *obj)
  */
 static void m68010_cpu_initfn(Object *obj)
 {
-    M68kCPU *cpu = M68K_CPU(obj);
-    CPUM68KState *env = &cpu->env;
+    CPUM68KState *env = cpu_env(CPU(obj));
 
     m68000_cpu_initfn(obj);
     m68k_set_feature(env, M68K_FEATURE_M68010);
@@ -161,8 +158,7 @@ static void m68010_cpu_initfn(Object *obj)
  */
 static void m68020_cpu_initfn(Object *obj)
 {
-    M68kCPU *cpu = M68K_CPU(obj);
-    CPUM68KState *env = &cpu->env;
+    CPUM68KState *env = cpu_env(CPU(obj));
 
     m68010_cpu_initfn(obj);
     m68k_unset_feature(env, M68K_FEATURE_M68010);
@@ -192,8 +188,7 @@ static void m68020_cpu_initfn(Object *obj)
  */
 static void m68030_cpu_initfn(Object *obj)
 {
-    M68kCPU *cpu = M68K_CPU(obj);
-    CPUM68KState *env = &cpu->env;
+    CPUM68KState *env = cpu_env(CPU(obj));
 
     m68020_cpu_initfn(obj);
     m68k_unset_feature(env, M68K_FEATURE_M68020);
@@ -219,8 +214,7 @@ static void m68030_cpu_initfn(Object *obj)
  */
 static void m68040_cpu_initfn(Object *obj)
 {
-    M68kCPU *cpu = M68K_CPU(obj);
-    CPUM68KState *env = &cpu->env;
+    CPUM68KState *env = cpu_env(CPU(obj));
 
     m68030_cpu_initfn(obj);
     m68k_unset_feature(env, M68K_FEATURE_M68030);
@@ -240,8 +234,7 @@ static void m68040_cpu_initfn(Object *obj)
  */
 static void m68060_cpu_initfn(Object *obj)
 {
-    M68kCPU *cpu = M68K_CPU(obj);
-    CPUM68KState *env = &cpu->env;
+    CPUM68KState *env = cpu_env(CPU(obj));
 
     m68040_cpu_initfn(obj);
     m68k_unset_feature(env, M68K_FEATURE_M68040);
@@ -254,8 +247,7 @@ static void m68060_cpu_initfn(Object *obj)
 
 static void m5208_cpu_initfn(Object *obj)
 {
-    M68kCPU *cpu = M68K_CPU(obj);
-    CPUM68KState *env = &cpu->env;
+    CPUM68KState *env = cpu_env(CPU(obj));
 
     m68k_set_feature(env, M68K_FEATURE_CF_ISA_A);
     m68k_set_feature(env, M68K_FEATURE_CF_ISA_APLUSC);
@@ -267,8 +259,7 @@ static void m5208_cpu_initfn(Object *obj)
 
 static void cfv4e_cpu_initfn(Object *obj)
 {
-    M68kCPU *cpu = M68K_CPU(obj);
-    CPUM68KState *env = &cpu->env;
+    CPUM68KState *env = cpu_env(CPU(obj));
 
     m68k_set_feature(env, M68K_FEATURE_CF_ISA_A);
     m68k_set_feature(env, M68K_FEATURE_CF_ISA_B);
@@ -281,8 +272,7 @@ static void cfv4e_cpu_initfn(Object *obj)
 
 static void any_cpu_initfn(Object *obj)
 {
-    M68kCPU *cpu = M68K_CPU(obj);
-    CPUM68KState *env = &cpu->env;
+    CPUM68KState *env = cpu_env(CPU(obj));
 
     m68k_set_feature(env, M68K_FEATURE_CF_ISA_A);
     m68k_set_feature(env, M68K_FEATURE_CF_ISA_B);
diff --git a/target/m68k/gdbstub.c b/target/m68k/gdbstub.c
index 1e5f033a12..15547e2313 100644
--- a/target/m68k/gdbstub.c
+++ b/target/m68k/gdbstub.c
@@ -23,8 +23,7 @@
 
 int m68k_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 {
-    M68kCPU *cpu = M68K_CPU(cs);
-    CPUM68KState *env = &cpu->env;
+    CPUM68KState *env = cpu_env(cs);
 
     if (n < 8) {
         /* D0-D7 */
@@ -50,8 +49,7 @@ int m68k_cpu_gdb_read_register(CPUState *cs, GByteArray *mem_buf, int n)
 
 int m68k_cpu_gdb_write_register(CPUState *cs, uint8_t *mem_buf, int n)
 {
-    M68kCPU *cpu = M68K_CPU(cs);
-    CPUM68KState *env = &cpu->env;
+    CPUM68KState *env = cpu_env(cs);
     uint32_t tmp;
 
     tmp = ldl_p(mem_buf);
diff --git a/target/m68k/helper.c b/target/m68k/helper.c
index 14508dfa11..85f3cd1680 100644
--- a/target/m68k/helper.c
+++ b/target/m68k/helper.c
@@ -894,8 +894,7 @@ txfail:
 
 hwaddr m68k_cpu_get_phys_page_debug(CPUState *cs, vaddr addr)
 {
-    M68kCPU *cpu = M68K_CPU(cs);
-    CPUM68KState *env = &cpu->env;
+    CPUM68KState *env = cpu_env(cs);
     hwaddr phys_addr;
     int prot;
     int access_type;
diff --git a/target/m68k/m68k-semi.c b/target/m68k/m68k-semi.c
index b4ffb70f8b..546cff2246 100644
--- a/target/m68k/m68k-semi.c
+++ b/target/m68k/m68k-semi.c
@@ -77,8 +77,7 @@ static int host_to_gdb_errno(int err)
 
 static void m68k_semi_u32_cb(CPUState *cs, uint64_t ret, int err)
 {
-    M68kCPU *cpu = M68K_CPU(cs);
-    CPUM68KState *env = &cpu->env;
+    CPUM68KState *env = cpu_env(cs);
 
     target_ulong args = env->dregs[1];
     if (put_user_u32(ret, args) ||
@@ -95,8 +94,7 @@ static void m68k_semi_u32_cb(CPUState *cs, uint64_t ret, int err)
 
 static void m68k_semi_u64_cb(CPUState *cs, uint64_t ret, int err)
 {
-    M68kCPU *cpu = M68K_CPU(cs);
-    CPUM68KState *env = &cpu->env;
+    CPUM68KState *env = cpu_env(cs);
 
     target_ulong args = env->dregs[1];
     if (put_user_u32(ret >> 32, args) ||
diff --git a/target/m68k/op_helper.c b/target/m68k/op_helper.c
index 1ce850bbc5..851cca640d 100644
--- a/target/m68k/op_helper.c
+++ b/target/m68k/op_helper.c
@@ -441,10 +441,7 @@ static void do_interrupt_all(CPUM68KState *env, int is_hw)
 
 void m68k_cpu_do_interrupt(CPUState *cs)
 {
-    M68kCPU *cpu = M68K_CPU(cs);
-    CPUM68KState *env = &cpu->env;
-
-    do_interrupt_all(env, 0);
+    do_interrupt_all(cpu_env(cs), 0);
 }
 
 static inline void do_interrupt_m68k_hardirq(CPUM68KState *env)
@@ -457,8 +454,7 @@ void m68k_cpu_transaction_failed(CPUState *cs, hwaddr physaddr, vaddr addr,
                                  int mmu_idx, MemTxAttrs attrs,
                                  MemTxResult response, uintptr_t retaddr)
 {
-    M68kCPU *cpu = M68K_CPU(cs);
-    CPUM68KState *env = &cpu->env;
+    CPUM68KState *env = cpu_env(cs);
 
     cpu_restore_state(cs, retaddr);
 
@@ -511,8 +507,7 @@ void m68k_cpu_transaction_failed(CPUState *cs, hwaddr physaddr, vaddr addr,
 
 bool m68k_cpu_exec_interrupt(CPUState *cs, int interrupt_request)
 {
-    M68kCPU *cpu = M68K_CPU(cs);
-    CPUM68KState *env = &cpu->env;
+    CPUM68KState *env = cpu_env(cs);
 
     if (interrupt_request & CPU_INTERRUPT_HARD
         && ((env->sr & SR_I) >> SR_I_SHIFT) < env->pending_level) {
diff --git a/target/m68k/translate.c b/target/m68k/translate.c
index 4a0b0b2703..9688476a7b 100644
--- a/target/m68k/translate.c
+++ b/target/m68k/translate.c
@@ -6108,8 +6108,7 @@ static double floatx80_to_double(CPUM68KState *env, uint16_t high, uint64_t low)
 
 void m68k_cpu_dump_state(CPUState *cs, FILE *f, int flags)
 {
-    M68kCPU *cpu = M68K_CPU(cs);
-    CPUM68KState *env = &cpu->env;
+    CPUM68KState *env = cpu_env(cs);
     int i;
     uint16_t sr;
     for (i = 0; i < 8; i++) {
-- 
2.41.0


