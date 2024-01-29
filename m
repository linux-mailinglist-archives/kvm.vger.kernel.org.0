Return-Path: <kvm+bounces-7362-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C62F840C19
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 17:47:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 23322286C3F
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 16:47:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB3A4157E66;
	Mon, 29 Jan 2024 16:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="IAP5HEP1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DDB1157057
	for <kvm@vger.kernel.org>; Mon, 29 Jan 2024 16:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706546822; cv=none; b=mPkK30qhLhV4ABemajUsKGLJqsCtXWhhIn+8x+bW4bTrqsBbHUcur/+d1WKM1GhJuB6uh9SclxhnWGIRc9qyS5nbDVNChicZB1ZIz9hKGdTrjzHp5KRBT2rti9RXHGDeGgORUB8CAGuY3l3adnkUAzQPLQPYLS2bxN4sStJaXVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706546822; c=relaxed/simple;
	bh=K2/zo/olqr+LwGgkwVwqtkKRRVPhp8U2Ppfsfj3qlcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kEhKljgUrT1mKdnjryMb1Qu45cgDyFO3EUxaE77E4tGZJ6BCWlmQYQOvO4heE/nMBx8nrZX3lIkEVxfUSI9j3eVs+WefsQx0ZUWV9wvSgra/ZQaD/BIQnMSSTcvtCkOKOW15urEVXk2Y0nOEUh2X5FeP5NrCeVxuxFPt1zkufI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=IAP5HEP1; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-40e9101b5f9so36012805e9.3
        for <kvm@vger.kernel.org>; Mon, 29 Jan 2024 08:46:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1706546818; x=1707151618; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ib12xEQ9cS3zFPlxG0XK1YK2Htrv2nPGlK1Cf6JOxPw=;
        b=IAP5HEP1aW+F2Ax9LTUpMVEhW/PFNA6kRCBSQnyS5A0SQhkM3xnZlDQgIJZlhvzy+N
         O3L8EYhR+Cb2a9556d3HeMxvpiGL7ZO6qadg8gbtz11Ayuxpu9wNyz+cZBJD4ZLrV4up
         h8uvR02fYoXZuScih4Uxhyiwf1fzZZvbmAKVzgmOfAelHnaLrW6IjPAa6hHqh9HqCu6q
         EFyTp4byzlrY3HaVkAXKFYVEqp5Uzr8ufJDFsc9XxVGWx7PRFB5QtKSLme/4l+LwtTJ3
         Zy5EVtWd6scdQLhYJI6UFIhLFSNYlRaLfHIRuV8czDUW2GSYD/2TYVtHEAxYzbo2NBtA
         qHtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706546818; x=1707151618;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ib12xEQ9cS3zFPlxG0XK1YK2Htrv2nPGlK1Cf6JOxPw=;
        b=OuuBClIzDBmWgxRlE3sBthAZj/TARy/c9NdRC7k6dDUOcuaQbEKP9W2pwUaF3WpL6l
         ebT0AeRmJFBFciAm9DhfIMRrcUQTqw2owjhBJ+RTsbL+LMql6OnJqPHdpUdeEmcZUprz
         c3aLkKnLiluRRgYRTJHwutDpp5Cr1dLSolf8jxqi9cJeD1dNB7q+StPh25DcIH5w/nnn
         U7UQE/V8hfY8dFxu0teygGyKfTwDqvL/9ziZ29b+VkyJ4QTqO0AjddRLk8CaB7AEWwHH
         XbdEeBAuOHJgP8h1YY9eY7uupQ9A+FlqRwQMjiDJWiBiHNIg4xKNjhL7JISH7/fex3py
         t65g==
X-Gm-Message-State: AOJu0Yys9Bf2H+gQ5NwI/ZEfYKdzaP+r253i8tj5TGZ7h6KYdYbvIWeb
	og3d0IiU/Mwx5fR/ZDMwnZURqfUhPWO7PTNkdskG5T+V3ks7A4/6ZbDcGO6bd6g=
X-Google-Smtp-Source: AGHT+IGVfe+WC+EmpdEquqGJQEaGbV4DU6mu7M5n0LNuNCmfmZ9Sf9Syv280bcWHDh3dOmHki1e+SQ==
X-Received: by 2002:a05:600c:1396:b0:40e:d425:85a with SMTP id u22-20020a05600c139600b0040ed425085amr6002839wmf.17.1706546818295;
        Mon, 29 Jan 2024 08:46:58 -0800 (PST)
Received: from m1x-phil.lan ([176.187.219.39])
        by smtp.gmail.com with ESMTPSA id bu25-20020a056000079900b0033ae4f2edb0sm6145102wrb.37.2024.01.29.08.46.56
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Jan 2024 08:46:57 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-riscv@nongnu.org,
	qemu-s390x@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	qemu-ppc@nongnu.org,
	qemu-arm@nongnu.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Thomas Huth <thuth@redhat.com>,
	Laurent Vivier <laurent@vivier.eu>
Subject: [PATCH v3 16/29] target/m68k: Prefer fast cpu_env() over slower CPU QOM cast macro
Date: Mon, 29 Jan 2024 17:44:58 +0100
Message-ID: <20240129164514.73104-17-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20240129164514.73104-1-philmd@linaro.org>
References: <20240129164514.73104-1-philmd@linaro.org>
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

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/m68k/cpu.c       | 33 +++++++++++----------------------
 target/m68k/gdbstub.c   |  6 ++----
 target/m68k/helper.c    |  6 ++----
 target/m68k/m68k-semi.c |  6 ++----
 target/m68k/op_helper.c | 11 +++--------
 target/m68k/translate.c |  3 +--
 6 files changed, 21 insertions(+), 44 deletions(-)

diff --git a/target/m68k/cpu.c b/target/m68k/cpu.c
index 4d14d04c33..4be0f0f33a 100644
--- a/target/m68k/cpu.c
+++ b/target/m68k/cpu.c
@@ -69,9 +69,8 @@ static void m68k_unset_feature(CPUM68KState *env, int feature)
 static void m68k_cpu_reset_hold(Object *obj)
 {
     CPUState *cs = CPU(obj);
-    M68kCPU *cpu = M68K_CPU(cs);
     M68kCPUClass *mcc = M68K_CPU_GET_CLASS(obj);
-    CPUM68KState *env = &cpu->env;
+    CPUM68KState *env = cpu_env(cs);
     floatx80 nan = floatx80_default_nan(NULL);
     int i;
 
@@ -117,8 +116,7 @@ static ObjectClass *m68k_cpu_class_by_name(const char *cpu_model)
 
 static void m5206_cpu_initfn(Object *obj)
 {
-    M68kCPU *cpu = M68K_CPU(obj);
-    CPUM68KState *env = &cpu->env;
+    CPUM68KState *env = cpu_env(CPU(obj));
 
     m68k_set_feature(env, M68K_FEATURE_CF_ISA_A);
     m68k_set_feature(env, M68K_FEATURE_MOVEFROMSR_PRIV);
@@ -127,8 +125,7 @@ static void m5206_cpu_initfn(Object *obj)
 /* Base feature set, including isns. for m68k family */
 static void m68000_cpu_initfn(Object *obj)
 {
-    M68kCPU *cpu = M68K_CPU(obj);
-    CPUM68KState *env = &cpu->env;
+    CPUM68KState *env = cpu_env(CPU(obj));
 
     m68k_set_feature(env, M68K_FEATURE_M68K);
     m68k_set_feature(env, M68K_FEATURE_USP);
@@ -141,8 +138,7 @@ static void m68000_cpu_initfn(Object *obj)
  */
 static void m68010_cpu_initfn(Object *obj)
 {
-    M68kCPU *cpu = M68K_CPU(obj);
-    CPUM68KState *env = &cpu->env;
+    CPUM68KState *env = cpu_env(CPU(obj));
 
     m68000_cpu_initfn(obj);
     m68k_set_feature(env, M68K_FEATURE_M68010);
@@ -161,8 +157,7 @@ static void m68010_cpu_initfn(Object *obj)
  */
 static void m68020_cpu_initfn(Object *obj)
 {
-    M68kCPU *cpu = M68K_CPU(obj);
-    CPUM68KState *env = &cpu->env;
+    CPUM68KState *env = cpu_env(CPU(obj));
 
     m68010_cpu_initfn(obj);
     m68k_unset_feature(env, M68K_FEATURE_M68010);
@@ -192,8 +187,7 @@ static void m68020_cpu_initfn(Object *obj)
  */
 static void m68030_cpu_initfn(Object *obj)
 {
-    M68kCPU *cpu = M68K_CPU(obj);
-    CPUM68KState *env = &cpu->env;
+    CPUM68KState *env = cpu_env(CPU(obj));
 
     m68020_cpu_initfn(obj);
     m68k_unset_feature(env, M68K_FEATURE_M68020);
@@ -219,8 +213,7 @@ static void m68030_cpu_initfn(Object *obj)
  */
 static void m68040_cpu_initfn(Object *obj)
 {
-    M68kCPU *cpu = M68K_CPU(obj);
-    CPUM68KState *env = &cpu->env;
+    CPUM68KState *env = cpu_env(CPU(obj));
 
     m68030_cpu_initfn(obj);
     m68k_unset_feature(env, M68K_FEATURE_M68030);
@@ -240,8 +233,7 @@ static void m68040_cpu_initfn(Object *obj)
  */
 static void m68060_cpu_initfn(Object *obj)
 {
-    M68kCPU *cpu = M68K_CPU(obj);
-    CPUM68KState *env = &cpu->env;
+    CPUM68KState *env = cpu_env(CPU(obj));
 
     m68040_cpu_initfn(obj);
     m68k_unset_feature(env, M68K_FEATURE_M68040);
@@ -254,8 +246,7 @@ static void m68060_cpu_initfn(Object *obj)
 
 static void m5208_cpu_initfn(Object *obj)
 {
-    M68kCPU *cpu = M68K_CPU(obj);
-    CPUM68KState *env = &cpu->env;
+    CPUM68KState *env = cpu_env(CPU(obj));
 
     m68k_set_feature(env, M68K_FEATURE_CF_ISA_A);
     m68k_set_feature(env, M68K_FEATURE_CF_ISA_APLUSC);
@@ -267,8 +258,7 @@ static void m5208_cpu_initfn(Object *obj)
 
 static void cfv4e_cpu_initfn(Object *obj)
 {
-    M68kCPU *cpu = M68K_CPU(obj);
-    CPUM68KState *env = &cpu->env;
+    CPUM68KState *env = cpu_env(CPU(obj));
 
     m68k_set_feature(env, M68K_FEATURE_CF_ISA_A);
     m68k_set_feature(env, M68K_FEATURE_CF_ISA_B);
@@ -281,8 +271,7 @@ static void cfv4e_cpu_initfn(Object *obj)
 
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
index a812f328a1..3ec835293a 100644
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
@@ -943,8 +942,7 @@ bool m68k_cpu_tlb_fill(CPUState *cs, vaddr address, int size,
                        MMUAccessType qemu_access_type, int mmu_idx,
                        bool probe, uintptr_t retaddr)
 {
-    M68kCPU *cpu = M68K_CPU(cs);
-    CPUM68KState *env = &cpu->env;
+    CPUM68KState *env = cpu_env(cs);
     hwaddr physical;
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


